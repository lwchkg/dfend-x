unit DataReaderMobyUnit;
interface

uses Classes, DataReaderConfigUnit, DataReaderBaseUnit;

Type TMobyDataReader=class(TDataReader)
  private
    FConfig : TDataReaderConfig;
    Function DownloadConfigFile(const DestFile : String) : Boolean;
    Function ReadListGlobalPart(const Lines : String; const NextElement : THTMLStructureElement) : Boolean;
    Procedure ReadListPerGamePart(const Lines : String; const NextElement : THTMLStructureElement; var GameName, GameURL : String);
    Procedure GetGameDataFromLines(const Lines : String; const NextElement : THTMLStructureElement; var Genre, Developer, Publisher, Year, Notes, ImagePageURL : String);
    function GetGameCoverFromLines(const Lines: String; const NextElement: THTMLStructureElement; var JSMode : Boolean) : TStringList;
    Function GetImageURLAndNextURLsFromURL(const CoverPageURL : String; var ImageURLs : TStringList; const PossibleNextURLs : TStringList) : Boolean;
    Procedure GetGameCoverFromSinglePages(const InitialURL : String; const ImageURLs : TStringList; const MaxImages : Integer);
    Procedure ProcessLinks(const BaseURL : String; const Links : TStringList; const ImageBaseURL : String; const ImageURLs: TStringList; const MaxImages: Integer);
    Procedure GetGameCoverFromMediaList(const ListPageURL : String; const ImageURLs : TStringList; const MaxImages : Integer);
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadConfig(const AConfigFile : String; const UpdateCheck : Boolean) : Boolean; override;
    Function ReadList(const ASearchString : String) : Boolean; override;
    Function GetListURL(const all : Boolean) : String; override;
    Function GetGameData(const Nr : Integer; var Genre, Developer, Publisher, Year, Notes, ImagePageURL : String) : Boolean; override;
    Function GetGameCover(const CoverPageURL : String; var ImageURL : String; const MaxImages : Integer) : Boolean; override;
    property Config : TDataReaderConfig read FConfig;
end;

Type TDataReaderThread=class(TThread)
  protected
    FDataReader : TDataReader;
    FSuccess : Boolean;
  public
    Constructor Create(const ADataReader : TDataReader);
    property Success : Boolean read FSuccess;
end;

Type TDataReaderLoadConfigThread=class(TDataReaderThread)
  private
    FForceUpdate : Boolean;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const AForceUpdate : Boolean);
end;

Type TDataReaderGameListThread=class(TDataReaderThread)
  private
    FName : String;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const AName : String);
end;

Type TDataReaderGameDataThread=class(TDataReaderThread)
  private
    FNr : Integer;
    FFullImages : Boolean;
    FGenre, FDeveloper, FPublisher, FYear, FImageURL, FNotes : String;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const ANr : Integer; const AFullImages : Boolean);
    property Genre : String read FGenre;
    property Developer : String read FDeveloper;
    property Publisher : String read FPublisher;
    property Year : String read FYear;
    property ImageURL : String read FImageURL; {Multiple images can be separated by "$"}
    property Notes : String read FNotes;
end;

Type TDataReaderGameCoverThread=class(TDataReaderThread)
  private
    FDownloadURLs : TStringList;
    FDestFolder : String;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const ADownloadURL, ADestFolder : String); overload;
    Constructor Create(const ADataReader : TDataReader; const ADownloadURLs : TStringList; const ADestFolder : String); overload;
    Destructor Destroy; override;
end;

implementation

uses Windows, SysUtils, Forms, ShellAPI, ActiveX, CommonTools,
     DataReaderToolsUnit, PrgConsts, PrgSetupUnit, InternetDataWaitFormUnit;

{ TMobyDataReader }

constructor TMobyDataReader.Create;
begin
  inherited Create;
  FConfig:=nil;
end;

destructor TMobyDataReader.Destroy;
begin
  If Assigned(FConfig) then FConfig.Free;
  inherited Destroy;
end;

function TMobyDataReader.LoadConfig(const AConfigFile : String; const UpdateCheck : Boolean): Boolean;
Var TempConfig : TDataReaderConfig;
    I : Integer;
begin
  result:=False;

  If (not FileExists(AConfigFile)) and (not DownloadConfigFile(AConfigFile)) then exit;

  if Assigned(FConfig) then FreeAndNil(FConfig);

  repeat
    FConfig:=TDataReaderConfig.Create(AConfigFile);
    result:=FConfig.ConfigOK;
    If not result then begin
      FreeAndNil(FConfig);
      If not DownloadConfigFile(AConfigFile) then exit;
    end;
  until result;

  if UpdateCheck then begin
    FLastUpdateCheckOK:=DownloadConfigFile(TempDir+ExtractFileName(AConfigFile));
    if FLastUpdateCheckOK then begin
      try
        TempConfig:=TDataReaderConfig.Create(TempDir+ExtractFileName(AConfigFile));
        try
          If TempConfig.ConfigOK then I:=TempConfig.Version else I:=-1;
        finally
          TempConfig.Free;
        end;
        If I>FConfig.Version then begin
          FConfig.Free;
          CopyFile(PChar(TempDir+ExtractFileName(AConfigFile)),PChar(AConfigFile),False);
          FConfig:=TDataReaderConfig.Create(AConfigFile);
          result:=FConfig.ConfigOK; if not result then exit;
        end;
      finally
        ExtDeleteFile(TempDir+ExtractFileName(AConfigFile),ftTemp);
      end;
    end;
  end;

  FBrowserURLDOS:=FConfig.GamesListURL;
  FBrowserURLAll:=FConfig.GamesListAllPlatformsURL;
  FDataDomain:=DomainOnly(FConfig.GameRecordBaseURL);
end;

function TMobyDataReader.DownloadConfigFile(const DestFile: String): Boolean;
begin
  result:=DownloadFileToDisk(DataReaderUpdateURL,DestFile);
end;

function TMobyDataReader.ReadList(const ASearchString: String): Boolean;
Var Lines,URL,S : String;
    I,Count : Integer;
begin
  FGameNames.Clear;
  FGameURLs.Clear;
  FLastListRequest:='';
  result:=False;
  If not Assigned(FConfig) then exit;
  URL:=GetListURL(PrgSetup.DataReaderAllPlatforms);

  result:=False;
  URL:=Format(URL,[EncodeName(ASearchString)]);
  For I:=0 to 10 do begin
    S:=URL;
    if I>0 then begin
      If S[length(S)]<>'/' then S:=S+'/';
      S:=S+'offset,'+IntToStr(I*25)+'/';
    end;
    if not DownloadTextFile(S,Lines) then exit;
    Count:=FGameURLs.Count;
    if ReadListGlobalPart(Lines,FConfig.GamesList) then result:=true;
    if FGameURLs.Count=Count then break;
  end;

  if result then FLastListRequest:=Format(URL,[EncodeName(ASearchString)]);
  result:=true; {if no games found but no error occured, report true}
end;

Function TMobyDataReader.GetListURL(const all : Boolean) : String;
begin
  If all then result:=FConfig.GamesListAllPlatformsURL else result:=FConfig.GamesListURL;
end;

function TMobyDataReader.ReadListGlobalPart(const Lines: String; const NextElement: THTMLStructureElement): Boolean;
Var St : TStringList;
    I : Integer;
    S,T : String;
begin
  result:=False;

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      result:=False;
      For I:=0 to TElement(NextElement).ChildCount-1 do begin
        if ReadListGlobalPart(S,TElement(NextElement).Children[I]) then result:=True;
      end;
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TPerGameBlock then begin
    St:=GetTagContents(Lines,1,TPerGameBlock(NextElement).ElementType,TPerGameBlock(NextElement).AttributeKey,TPerGameBlock(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      result:=True;
      For I:=0 to St.Count-1 do begin
        ReadListPerGamePart(St[I],TPerGameBlock(NextElement).Child,S,T);
        If (S<>'') and (T<>'') and (FGameURLs.IndexOf(T)<0) then begin FGameNames.Add(DecodeName(S)); FGameURLs.Add(T); end;
      end;
    finally
      St.Free;
    end;
    exit;
  end;
end;

Procedure TMobyDataReader.ReadListPerGamePart(const Lines : String; const NextElement : THTMLStructureElement; var GameName, GameURL : String);
Var St,St2 : TStringList;
    I : Integer;
    S : String;
begin
  GameName:=''; GameURL:='';

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      ReadListPerGamePart(S,TElement(NextElement).Child,GameName,GameURL);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TLink then begin
    St2:=TStringList.Create;
    try
      St:=GetTagContents(Lines,1,'a',TLink(NextElement).AttributeKey,TLink(NextElement).AttributeValue,'href',St2);
      try
        If St.Count=0 then exit;
        GameName:=St[0]; GameURL:=St2[0];
        If TLink(NextElement).Nr<>0 then begin
          I:=TLink(NextElement).Nr;
          If (I>0) and (St.Count>=I) then begin GameName:=St[I-1]; GameURL:=St2[I-1]; end;
          If (I<0) and (St.Count>=-I) then begin GameName:=St[St.Count-I]; GameURL:=St2[St.Count-I]; end;
        end;
        S:=Trim(TLink(NextElement).HrefSubstring);
        If (S<>'') and (Pos(ExtUpperCase(S),ExtUpperCase(GameURL))=0) then begin GameName:=''; GameURL:=''; end;
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    exit;
  end;
end;

function TMobyDataReader.GetGameData(const Nr: Integer; var Genre, Developer, Publisher, Year, Notes, ImagePageURL: String): Boolean;
Var S,T,Lines : String;
begin
  result:=False;
  Genre:=''; Developer:=''; Publisher:=''; Year:=''; Notes:=''; ImagePageURL:='';
  If (Nr<0) or (Nr>=FGameNames.Count) then exit;

  S:=FConfig.GameRecordBaseURL;
  If (S<>'') and (S[length(S)]<>'/') then S:=S+'/';
  T:=FGameURLs[Nr];
  If (T<>'') and (T[1]='/') then T:=Copy(T,2,MaxInt);

  if not DownloadTextFile(S+T,Lines,FLastListRequest) then exit;
  result:=True;
  GetGameDataFromLines(Lines,FConfig.GameRecord,Genre,Developer,Publisher,Year,Notes,ImagePageURL);
end;

Function ExtDecodeName(const S : String) : String;
Var St : TStringList;
    I : Integer;
begin
  result:='';
  St:=GetPlainText(S);
  try
    For I:=0 to St.Count-1 do If Trim(St[I])=',' then result:=result+';' else result:=result+DecodeName(St[I]);
  finally
    St.Free;
  end;
end;

procedure TMobyDataReader.GetGameDataFromLines(const Lines: String; const NextElement: THTMLStructureElement; var Genre, Developer, Publisher, Year, Notes, ImagePageURL: String);
Var St,St2 : TStringList;
    S,T : String;
    I,J : Integer;
    S1,S2,S3,S4,S5 : String;
begin
  If NextElement is TLink then begin
    St2:=TStringList.Create;
    try
      St:=GetTagContents(Lines,1,'a',TLink(NextElement).AttributeKey,TLink(NextElement).AttributeValue,'href',St2);
      try
        If St.Count=0 then exit;
        If ExtUpperCase(Copy(St[0],1,4))<>'<IMG' then exit;
        T:=Trim(ExtUpperCase(TLink(NextElement).HrefSubstring));
        If T<>'' then begin
          S:='';
          For I:=0 to St2.Count-1 do If (Pos(T,ExtUpperCase(St2[I]))<>0) then begin S:=St2[I]; break; end;
        end else begin
          S:=St2[0];
          If TLink(NextElement).Nr<>0 then begin
            I:=TLink(NextElement).Nr;
            If (I>0) and (St.Count>=I) then S:=St2[I-1];
            If (I<0) and (St.Count>=-I) then S:=St2[St.Count-I];
          end;
        end;
        If S<>'' then ImagePageURL:=S;
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    exit;
  end;

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue,TElement(NextElement).ContainsText);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      For I:=0 to TElement(NextElement).ChildCount-1 do
        GetGameDataFromLines(S,TElement(NextElement).Children[I],Genre,Developer,Publisher,Year,Notes,ImagePageURL);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TSearchGameData then begin
    S1:=Trim(ExtUpperCase(TSearchGameData(NextElement).Genre));
    S2:=Trim(ExtUpperCase(TSearchGameData(NextElement).Developer));
    S3:=Trim(ExtUpperCase(TSearchGameData(NextElement).Publisher));
    S4:=Trim(ExtUpperCase(TSearchGameData(NextElement).Year));
    S5:=Trim(ExtUpperCase(TSearchGameData(NextElement).Notes));

    if (S5<>'') and (S5<>'SELF') then begin
      St:=GetPlainText(Lines,TSearchGameData(NextElement).IgnoreTags,TSearchGameData(NextElement).StartTokens,TSearchGameData(NextElement).StoppTokens);
      try
        Notes:=Trim(St.Text);
        If (Notes<>'') and (Notes[length(Notes)]='[') then Notes:=Trim(Copy(Notes,1,length(Notes)-1));
      finally
        St.Free;
      end;
    end;

    {Simple mode (fallback)}

    St:=GetPlainText(Lines);
    try
      For I:=0 to St.Count-2 do begin
        S:=ExtUpperCase(St[I]);
        If (S1<>'') and (Pos(S1,S)<>0) then Genre:=DecodeName(St[I+1]);
        If (S2<>'') and (Pos(S2,S)<>0) then Developer:=DecodeName(St[I+1]);
        If (S3<>'') and (Pos(S3,S)<>0) then Publisher:=DecodeName(St[I+1]);
        If (S4<>'') and (Pos(S4,S)<>0) then Year:=DecodeName(St[I+1]);
      end;
    finally
      St.Free;
    end;

    {Semi simple mode}
    
    if S1='SELF' then Genre:=GetPlainDecodedText(Lines);
    if S2='SELF' then Developer:=GetPlainDecodedText(Lines);
    if S3='SELF' then Publisher:=GetPlainDecodedText(Lines);
    if S4='SELF' then Year:=GetPlainDecodedText(Lines);
    if S5='SELF' then Notes:=GetPlainDecodedText(Lines);

    {Complex mode for detecting multiple values}

    St:=GetTagContents(Lines,1,'div','','');
    try
      If (St.Count=1) and (Copy(St[0],1,1)='<') then begin
        St2:=GetTagContents(St[0],1,'div','',''); St.Free; St:=St2;
      end;
      For I:=0 to St.Count-2 do begin
        St2:=GetPlainText(St[I]);
        try
          If St2.Count>0 then S:=St2[0];
          For J:=1 to St2.Count-1 do S:=S+' '+St2[J];
        finally
          St2.Free;
        end;
        S:=ExtUpperCase(S);
        If (S1<>'') and (Pos(S1,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Genre:=T; end;
        If (S2<>'') and (Pos(S2,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Developer:=T; end;
        If (S3<>'') and (Pos(S3,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Publisher:=T; end;
        If (S4<>'') and (Pos(S4,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Year:=T; end;
        If (S5<>'') and (Pos(S5,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Notes:=T; end;
      end;
    finally
      St.Free;
    end;
  end;
end;

Function TMobyDataReader.GetImageURLAndNextURLsFromURL(const CoverPageURL : String; var ImageURLs : TStringList; const PossibleNextURLs : TStringList) : Boolean;
Var Lines,S,T,LinesUpper,preURL : String;
    I,J,CharsBefore : Integer;
    St : TStringList;
    JSMode : Boolean;
begin
  result:=False;
  if not DownloadTextFile(CoverPageURL,Lines) then exit;

  {Scan for image URL in lines}
  JSMode:=False;
  St:=GetGameCoverFromLines(Lines,FConfig.CoverRecord,JSMode);
  try
    result:=(St.Count<>0);
    For I:=0 to St.Count-1 do begin
      T:=Trim(ExtUpperCase(St[I]));
      If (Copy(T,1,7)<>'HTTP:/'+'/') and (Copy(T,1,8)<>'HTTPS:/'+'/') then begin
        T:=St[I];
        If (T<>'') and (T[1]='/') then T:=Copy(T,2,MaxInt);
        ImageURLs.Add(S+T);
      end else begin
        ImageURLs.Add(St[I]);
      end;
    end;
  finally
    St.Free;
  end;

  {Scan for other cover page URLs}
  if (PossibleNextURLs<>nil) and not JSMode then begin
    S:=CoverPageURL;
    If S<>'' then SetLength(S,length(S)-1);
    While (S<>'') and (S[length(S)]<>'/') do SetLength(S,length(S)-1);
    preURL:='';
    J:=0; For I:=1 to length(S) do If S[I]='/' then begin
      inc(J); If J=3 then begin preURL:=Copy(S,1,I); S:=Copy(S,I+1,MaxInt); break; end;
    end;
    S:=ExtUpperCase(S);
    If S='' then exit;

    LinesUpper:=ExtUpperCase(Lines);
    CharsBefore:=0;

    I:=Pos(S,LinesUpper); While I>0 do begin
      T:=Copy(LinesUpper,I,MaxInt);
      J:=Pos('"',T); If J=0 then break;
      PossibleNextURLs.Add(preURL+Copy(Lines,CharsBefore+I,J-1));

      LinesUpper:=Copy(LinesUpper,(I-1)+J+1,MaxInt);
      CharsBefore:=CharsBefore+(I-1)+J;

      I:=Pos(S,LinesUpper);
    end;
  end;
end;

Procedure TMobyDataReader.GetGameCoverFromSinglePages(const InitialURL : String; const ImageURLs : TStringList; const MaxImages : Integer);
Var S : String;
    WaitingURLs, ScannedURLsUpper, PossibleNextURLs, St, NewImageURLs : TStringList;
    I,J : Integer;
    B : Boolean;
begin
  WaitingURLs:=TStringList.Create;
  try
    {Get initial cover page URL}
    WaitingURLs.Add(InitialURL);

    ScannedURLsUpper:=TStringList.Create;
    PossibleNextURLs:=TStringList.Create;
    try
      {While there are URLs in the queue}
      While WaitingURLs.Count>0 do begin
        PossibleNextURLs.Clear;

        {Get next image URL and scan for more cover page URLs}
        If MaxImages=1 then St:=nil else St:=PossibleNextURLs;
        NewImageURLs:=TStringList.Create;
        try
          If GetImageURLAndNextURLsFromURL(WaitingURLs[0],NewImageURLs,St) then begin
            {Save new image URL}
            For I:=0 to NewImageURLs.Count-1 do begin
              B:=True; For J:=0 to ImageURLs.Count-1 do if ExtUpperCase(ImageURLs[J])=ExtUpperCase(NewImageURLs[I]) then begin B:=False; break; end;
              if B then ImageURLs.Add(NewImageURLs[I]);
            end;

            {Remove cover page URL from queue and mark it as scanned}
            ScannedURLsUpper.Add(ExtUpperCase(WaitingURLs[0]));
            WaitingURLs.Delete(0);

            {Check possible new cover page URLs for real new URLs}
            For I:=0 to PossibleNextURLs.Count-1 do begin
              S:=ExtUpperCase(PossibleNextURLs[I]);
              If ScannedURLsUpper.IndexOf(S)<0 then WaitingURLs.Add(PossibleNextURLs[I]);
            end;
          end else begin
            WaitingURLs.Delete(0);
          end;
        finally
          NewImageURLs.Free;
        end;

        {Stop after max. MaxImages images}
        If ImageURLs.Count>=MaxImages then break;
      end;
    finally
      ScannedURLsUpper.Free;
      PossibleNextURLs.Free;
    end;
  finally
    WaitingURLs.Free;
  end;
end;

Type TDownloadDataThread=class(TThread)
  private
    FImageBaseURL : String;
    FDataReader : TMobyDataReader;
    FURList, FImageURLs : TStringList;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const AImageBaseURL : String; const ADataReader : TMobyDataReader; const AURLList : TStringList);
    Destructor Destroy; override;
    property ImageURLs : TStringList read FImageURLs;
end;

constructor TDownloadDataThread.Create(const AImageBaseURL : String; const ADataReader : TMobyDataReader; const AURLList: TStringList);
begin
  inherited Create(true);
  FImageBaseURL:=AImageBaseURL;
  FDataReader:=ADataReader;
  FURList:=AURLList;
  FImageURLs:=TStringList.Create;
  Resume;
end;

destructor TDownloadDataThread.Destroy;
begin
  FImageURLs.Free;
  inherited Destroy;
end;

procedure TDownloadDataThread.Execute;
Var NewImageURLs : TStringList;
    I,J : Integer;
begin
  For I:=0 to FURList.Count-1 do begin
    NewImageURLs:=TStringList.Create;
    try
      {Get next image URL}
      If not FDataReader.GetImageURLAndNextURLsFromURL(FURList[I],NewImageURLs,nil) then continue;

      {Check if image URL is relative to ImageBaseURL and make is absolute if needed}
      For J:=0 to NewImageURLs.Count-1 do begin
        if ExtUpperCase(Trim(Copy(NewImageURLs[J],1,4)))<>'HTTP' then begin
          if FImageBaseURL[length(FImageBaseURL)]<>'\' then NewImageURLs[J]:=FImageBaseURL+'/'+NewImageURLs[J] else NewImageURLs[J]:=FImageBaseURL+NewImageURLs[J];
        end;
      end;

      FImageURLs.AddStrings(NewImageURLs);
    finally
      NewImageURLs.Free;
    end;
  end;
end;


Procedure TMobyDataReader.ProcessLinks(const BaseURL : String; const Links : TStringList; const ImageBaseURL : String; const ImageURLs: TStringList; const MaxImages: Integer);
const ThreadCount=8;
Var I,J,K : Integer;
    ImagePages : TStringList;
    S,NewImageURL : String;
    B : Boolean;
    ThreadURLList : Array[0..ThreadCount-1] of TStringList;
    ThreadList : Array[0..ThreadCount-1] of TDownloadDataThread;
begin
  ImagePages:=TStringList.Create;
  try
    For I:=0 to Links.Count-1 do begin
      if ImageURLs.Count+ImagePages.Count>=MaxImages then break;
      S:=Links[I];

      {Is this an URL to a real image?}
      If (ExtUpperCase(Copy(S,1,length(BaseURL)))<>ExtUpperCase(BaseURL)) or (length(S)=length(BaseURL)) then continue;

      ImagePages.Add(S);
    end;

    For I:=0 to ThreadCount-1 do ThreadURLList[I]:=TStringList.Create;
    try
      For I:=0 to ImagePages.Count-1 do ThreadURLList[I mod ThreadCount].Add(ImagePages[I]);

      For I:=0 to ThreadCount-1 do if ThreadURLList[I].Count=0 then ThreadList[I]:=nil else ThreadList[I]:=TDownloadDataThread.Create(ImageBaseURL,self,ThreadURLList[I]);

      try
        repeat
          Sleep(50);
          B:=True;
          For I:=0 to ThreadCount-1 do If (ThreadList[I]<>nil) and (WaitForSingleObject(ThreadList[I].Handle,0)<>WAIT_OBJECT_0) then begin B:=False; break; end;
        until B;

        {Save new image URLs}
        For I:=0 to ThreadCount-1 do If ThreadList[I]<>nil then For J:=0 to ThreadList[I].ImageURLs.Count-1 do begin
          NewImageURL:=ThreadList[I].ImageURLs[J];
          B:=True; For K:=0 to ImageURLs.Count-1 do if ExtUpperCase(ImageURLs[K])=ExtUpperCase(NewImageURL) then begin B:=False; break; end;
          if B then ImageURLs.Add(NewImageURL);
        end;
      finally
        For I:=0 to ThreadCount-1 do If ThreadList[I]<>nil then ThreadList[I].Free;
      end;
    finally
      For I:=0 to ThreadCount-1 do ThreadURLList[I].Free;
    end;
  finally
    ImagePages.Free;
  end;
end;

procedure TMobyDataReader.GetGameCoverFromMediaList(const ListPageURL: String; const ImageURLs: TStringList; const MaxImages: Integer);
Var Lines,ScreensahotsURL : String;
    I : Integer;
    Tags,href : TStringList;
begin
  if not DownloadTextFile(ListPageURL,Lines) then exit;

  href:=TStringList.Create;
  try
    {Get all links, find link to screenshots page}
    ScreensahotsURL:='';
    Tags:=GetTagContents(Lines,1,'a','','','href',href);
    try
      For I:=0 to href.Count-1 do begin
        href[I]:=Config.CoverRecordBaseURL+href[I];
        if Trim(ExtUpperCase(Tags[I]))='SCREENSHOTS' then ScreensahotsURL:=href[I];
      end;
    finally
      Tags.Free;
    end;

    {Process image file links}
    ProcessLinks(ListPageURL,href,Config.CoverRecordBaseURL,ImageURLs,MaxImages);
  finally
    href.free;
  end;

  if ScreensahotsURL<>'' then begin
    if ScreensahotsURL[length(ScreensahotsURL)]<>'/' then ScreensahotsURL:=ScreensahotsURL+'/';
    if not DownloadTextFile(ScreensahotsURL,Lines) then exit;
    href:=TStringList.Create;
    try
      Tags:=GetTagContents(Lines,1,'a','','','href',href);
      Tags.Free;
      For I:=0 to href.Count-1 do href[I]:=Config.CoverRecordBaseURL+href[I];
      ProcessLinks(ScreensahotsURL,href,Config.CoverRecordBaseURL,ImageURLs,MaxImages);
    finally
      href.Free;
    end;
  end;
end;

function TMobyDataReader.GetGameCover(const CoverPageURL : String; var ImageURL: String; const MaxImages : Integer): Boolean;
Var URL,S,T : String;
    ImageURLs : TStringList;
    I : Integer;
begin
  ImageURL:='';
  If Trim(CoverPageURL)='' then begin result:=True; exit; end;

  ImageURLs:=TStringList.Create;
  try
    {Get initial cover page URL}
    URL:=FConfig.CoverRecordBaseURL;
    If (URL<>'') and (URL[length(URL)]<>'/') then URL:=URL+'/';
    S:=CoverPageURL;
    If (S<>'') and (S[1]='/') then S:=Copy(S,2,MaxInt);
    URL:=URL+S;

    {Get initial cover und folder links to more images}
    GetGameCoverFromSinglePages(URL,ImageURLs,MaxImages);

    if (MaxImages>1) and PrgSetup.DataReaderDownloadCompleteMediaLibrary then begin
      {Get media list URL}
      If (URL<>'') and (URL[length(URL)]='/') then URL:=Copy(URL,1,length(URL)-1);
      While (URL<>'') and (URL[length(URL)]<>'/') do URL:=Copy(URL,1,length(URL)-1);

      {Get complete media list}
      GetGameCoverFromMediaList(URL,ImageURLs,MaxImages);
    end;

    {Fix URLs with missing absolute part}
    for I:=0 to ImageURLs.Count-1 do begin
      S:=ImageURLs[I];
      if LowerCase(Copy(S,1,4))<>'http' then begin
        if Copy(S,1,1)='/' then S:=Copy(S,2,MaxInt);
        T:=FConfig.CoverRecordBaseURL;
        if T[length(T)]<>'/' then T:=T+'/';        
        S:=T+S;
        ImageURLs[I]:=S;
      end;
    end;

    {Combine image URLs}
    If ImageURLs.count>0 then ImageURL:=ImageURLs[0];
    For I:=1 to ImageURLs.count-1 do ImageURL:=ImageURL+'$'+ImageURLs[I];
    result:=(ImageURLs.count>0);
  finally
    ImageURLs.Free;
  end;
end;

function TMobyDataReader.GetGameCoverFromLines(const Lines: String; const NextElement: THTMLStructureElement; var JSMode : Boolean) : TStringList;
Var St,St2 : TStringList;
    I : Integer;
    S : String;
begin
  result:=TStringList.create;

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      St2:=GetGameCoverFromLines(S,TElement(NextElement).Child,JSMode);
      try
        result.AddStrings(St2);
      finally
        St2.Free;
      end;
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TJavascript then begin
    JSMode:=True;
    St:=GetJavascriptURLs(Lines,TJavascript(NextElement).ContainsText);
    try
      result.AddStrings(St);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TImg then begin
    St2:=TStringList.Create;
    try
      St:=GetTagContents(Lines,1,'img',TLink(NextElement).AttributeKey,TLink(NextElement).AttributeValue,'src',St2);
      try
        If St.Count=0 then exit;
        S:=St2[0];
        If TLink(NextElement).Nr<>0 then begin
          I:=TLink(NextElement).Nr;
          If (I>0) and (St.Count>=I) then S:=St2[I-1];
          If (I<0) and (St.Count>=-I) then S:=St2[St.Count-I];
        end;
        If S<>'' then result.add(S);
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    exit;
  end;
end;

{ TDataReaderThread }

constructor TDataReaderThread.Create(const ADataReader: TDataReader);
begin
  inherited Create(True);
  FDataReader:=ADataReader;
  FSuccess:=False;
end;

{ TDataReaderLoadConfigThread }

constructor TDataReaderLoadConfigThread.Create(const ADataReader: TDataReader; const AForceUpdate : Boolean);
begin
  inherited Create(ADataReader);
  FForceUpdate:=AForceUpdate;
  Resume;
end;

procedure TDataReaderLoadConfigThread.Execute;
Var DoUpdateCheck : Boolean;
begin
  CoInitialize(nil);
  If FForceUpdate then begin
    DoUpdateCheck:=True;
  end else begin
    DoUpdateCheck:=False;
    Case PrgSetup.DataReaderCheckForUpdates of
      0 : DoUpdateCheck:=False;
      1 : DoUpdateCheck:=(Round(Int(Date))>=PrgSetup.LastDataReaderUpdateCheck+7);
      2 : DoUpdateCheck:=(Round(Int(Date))>=PrgSetup.LastDataReaderUpdateCheck+1);
      3 : DoUpdateCheck:=True;
    end;
  end;
  If FDataReader.LoadConfig(PrgDataDir+SettingsFolder+'\'+DataReaderConfigFile,DoUpdateCheck) then FSuccess:=FDataReader.LastUpdateCheckOK else FSuccess:=False;
  if not FSuccess then FSuccess:=FDataReader.LoadConfig(PrgDataDir+SettingsFolder+'\'+DataReaderConfigFile,false);  
  If DoUpdateCheck and FSuccess then PrgSetup.LastDataReaderUpdateCheck:=Round(Int(Date));
end;

{ TDataReaderGameListThread }

constructor TDataReaderGameListThread.Create(const ADataReader: TDataReader; const AName: String);
begin
  inherited Create(ADataReader);
  FName:=AName;
  Resume;
end;

procedure TDataReaderGameListThread.Execute;
begin
  FSuccess:=FDataReader.ReadList(FName);
end;

{ TDataReaderGameDataThread }

constructor TDataReaderGameDataThread.Create(const ADataReader: TDataReader; const ANr: Integer; const AFullImages : Boolean);
begin
  inherited Create(ADataReader);
  FNr:=ANr;
  FFullImages:=AFullImages;
  FGenre:=''; FDeveloper:=''; FPublisher:=''; FYear:=''; FImageURL:=''; FNotes:='';
  Resume;
end;

procedure TDataReaderGameDataThread.Execute;
Var S : String;
    MaxImageCount : Integer;
begin
  FSuccess:=FDataReader.GetGameData(fNr,FGenre,FDeveloper,FPublisher,FYear,FNotes,S);
  if FFullImages then MaxImageCount:=PrgSetup.DataReaderMaxImages else MaxImageCount:=1;
  If FSuccess then FSuccess:=FDataReader.GetGameCover(S,FImageURL,MaxImageCount);
end;

{ TDataReaderGameCoverThread }

constructor TDataReaderGameCoverThread.Create(const ADataReader: TDataReader; const ADownloadURL, ADestFolder: String);
begin
  inherited Create(ADataReader);
  FDownloadURLs:=TStringList.Create;
  FDownloadURLs.Add(ADownloadURL);
  FDestFolder:=ADestFolder;
  Resume;
end;

constructor TDataReaderGameCoverThread.Create(const ADataReader: TDataReader; const ADownloadURLs: TStringList; const ADestFolder: String);
begin
  inherited Create(ADataReader);
  FDownloadURLs:=TStringList.Create;
  FDownloadURLs.AddStrings(ADownloadURLs);
  FDestFolder:=ADestFolder;
  Resume;
end;

destructor TDataReaderGameCoverThread.Destroy;
begin
  FDownloadURLs.Free;
  inherited Destroy;
end;

procedure TDataReaderGameCoverThread.Execute;
Var FileName,Path,S : String;
    I,J : Integer;
begin
  FSuccess:=True;

  For J:=0 to FDownloadURLs.Count-1 do begin
    FileName:=FDownloadURLs[J];

    I:=Pos('/',FileName); While I>0 do begin FileName:=Copy(FileName,I+1,MaxInt); I:=Pos('/',FileName); end;
    Path:=IncludeTrailingPathDelimiter(FDestFolder);
    If FileExists(Path+FileName) then continue;

    I:=Pos('/covers/small/',FDownloadURLs[J]);
    if (I<>0) then begin
      S:=Copy(FDownloadURLs[J],1,I-1)+'/covers/large/'+copy(FDownloadURLs[J],I+length('/covers/small/'),MaxInt);
      If DownloadFileToDisk(S,Path+FileName) then continue;
    end;

    If not DownloadFileToDisk(FDownloadURLs[J],Path+FileName) then FSuccess:=False;
  end;
end;

end.
