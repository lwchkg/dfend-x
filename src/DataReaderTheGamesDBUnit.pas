unit DataReaderTheGamesDBUnit;
interface

uses Classes, XMLIntf, DataReaderBaseUnit;

Type TTheGamesDBDataReader=class(TDataReader)
  private
    Function ProcessImages(const base : String; const Node : IXMLNode) : TStringList;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function ReadList(const ASearchString : String) : Boolean; override;
    Function GetListURL(const all : Boolean) : String; override;
    Function GetGameData(const Nr : Integer; var Genre, Developer, Publisher, Year, Notes, ImagePageURL : String) : Boolean; override;
    Function GetGameCover(const CoverPageURL : String; var ImageURL : String; const MaxImages : Integer) : Boolean; override;
end;

implementation

uses SysUtils, Math, XMLDom, XMLDoc, MSXMLDOM, ActiveX, PrgSetupUnit,
     CommonTools, PrgConsts, InternetDataWaitFormUnit, DataReaderToolsUnit,
     PackageDBToolsUnit;

{ TTheGamesDBDataReader }

constructor TTheGamesDBDataReader.Create;
begin
  inherited Create;
  FDataDomain:='thegamesdb.net';
  FBrowserURLAll:='http://thegamesdb.net/';
  FBrowserURLDOS:='http://thegamesdb.net/browse/1/';
end;

destructor TTheGamesDBDataReader.Destroy;
begin
  inherited Destroy;
end;

function TTheGamesDBDataReader.GetListURL(const all: Boolean): String;
begin
  if all then result:='http://thegamesdb.net/api/GetGamesList.php?name=%s' else result:='http://thegamesdb.net/api/GetGamesList.php?name=%s&platform=PC';
end;

function TTheGamesDBDataReader.ReadList(const ASearchString: String): Boolean;
Var URL : String;
    TempFile : String;
    XMLDoc : TXMLDocument;
    I : Integer;
    N,N2,N3 : IXMLNode;
begin
  FGameNames.Clear;
  FGameURLs.Clear;
  FLastListRequest:='';
  result:=False;
  URL:=Format(GetListURL(PrgSetup.DataReaderAllPlatforms),[EncodeName(ASearchString)]);
  TempFile:=TempDir+PackageDBTempFile;
  if not DownloadFileToDisk(URL,TempFile) then exit;
  try
    CoInitialize(nil);
    XMLDoc:=LoadXMLDoc(TempFile); if XMLDoc=nil then exit;
    try
      If XMLDoc.DocumentElement.NodeName<>'Data' then exit;
      For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
        N:=XMLDoc.DocumentElement.ChildNodes[I];
        If N.NodeName='Game' then begin
          N2:=N.ChildNodes.FindNode('id');
          N3:=N.ChildNodes.FindNode('GameTitle');
          if (N2<>nil) and (N3<>nil) then begin
            FGameNames.Add(N3.NodeValue);
            FGameURLs.Add(N2.NodeValue);
          end;
        end;
      end;
    finally
      XMLDoc.Free;
    end;
  finally
    ExtDeleteFile(TempFile,ftTemp);
  end;
  result:=True;
end;

function TTheGamesDBDataReader.GetGameData(const Nr: Integer; var Genre, Developer, Publisher, Year, Notes, ImagePageURL: String): Boolean;
Var Id, URL, TempFile : String;
    XMLDoc : TXMLDocument;
    I,J,K : Integer;
    N,N2,N3 : IXMLNode;
    baseImgUrl : String;
    S : String;
    St : TStringList;
begin
  result:=False;
  Genre:=''; Developer:=''; Publisher:=''; Year:=''; Notes:=''; ImagePageURL:='';
  If (Nr<0) or (Nr>=FGameURLs.Count) then exit;
  Id:=FGameURLs[Nr];

  URL:=Format('http://thegamesdb.net/api/GetGame.php?id=%s',[Id]);
  TempFile:=TempDir+PackageDBTempFile;

  TempFile:=TempDir+PackageDBTempFile;
  if not DownloadFileToDisk(URL,TempFile) then exit;
  try
    CoInitialize(nil);
    XMLDoc:=LoadXMLDoc(TempFile); if XMLDoc=nil then exit;
    try
      If XMLDoc.DocumentElement.NodeName<>'Data' then exit;
      baseImgUrl:='';
      For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
        N:=XMLDoc.DocumentElement.ChildNodes[I];
        If N.NodeName='baseImgUrl' then begin
          baseImgUrl:=N.NodeValue;
          continue;
        end;
        If N.NodeName='Game' then begin
          For J:=0 to N.ChildNodes.Count-1 do begin
            N2:=N.ChildNodes[J];
            S:=N2.NodeName;
            if S='ReleaseDate' then begin Year:=N2.NodeValue; continue; end;
            if S='Publisher' then begin Publisher:=N2.NodeValue; continue; end;
            if S='Developer' then begin Developer:=N2.NodeValue; continue; end;
            if S='Overview' then begin Notes:=N2.NodeValue; continue; end;
            if S='Genres' then begin
              For K:=0 to N2.ChildNodes.Count-1 do begin
                N3:=N2.ChildNodes[K];
                if N3.NodeName='genre' then begin
                  if Genre<>'' then Genre:=Genre+'; ';
                  Genre:=Genre+N3.NodeValue;
                  continue;
                end;
              end;
              continue;
            end;
            if S='Images' then begin
              St:=ProcessImages(baseImgUrl,N2);
              if St<>nil then begin
                try
                  ImagePageURL:=StringListToString(St);
                finally
                  St.Free;
                end;
              end;
              continue;
            end;
          end;
          continue;
        end;
      end;
    finally
      XMLDoc.Free;
    end;
  finally
    ExtDeleteFile(TempFile,ftTemp);
  end;
  result:=True;
end;

function TTheGamesDBDataReader.ProcessImages(const base : String; const Node: IXMLNode): TStringList;
Var I : Integer;
    N,N2 : IXMLNode;
    St : Array[1..5] of TStringList;
    S : String;
begin
  result:=TStringList.Create;

  for I:=Low(St) to High(St) do St[I]:=TStringList.Create;
  try
    for I:=0 to Node.ChildNodes.Count-1 do begin
      N:=Node.ChildNodes[I];
      S:=N.NodeName;
      if S='boxart' then begin
        if N.Attributes['side']='front' then St[1].Add(base+N.NodeValue) else St[2].Add(base+N.NodeValue);
        continue;
      end;
      if S='fanart' then begin
        N2:=N.ChildNodes['original'];
        if N2<>nil then St[3].add(base+N2.NodeValue);
        continue;
      end;
      if S='screenshot' then begin
        N2:=N.ChildNodes['original'];
        if N2<>nil then St[4].add(base+N2.NodeValue);
        continue;
      end;
      if S='banner' then begin St[5].Add(base+N.NodeValue); continue; end;
    end;
    for I:=Low(St) to High(St) do result.AddStrings(St[I]);
  finally
    for I:=Low(St) to High(St) do St[I].Free;
  end;
end;

function TTheGamesDBDataReader.GetGameCover(const CoverPageURL: String; var ImageURL: String; const MaxImages: Integer): Boolean;
Var St,St2 : TStringList;
    I : Integer;
begin
  St:=StringToStringList(CoverPageURL);
  try
    St2:=TStringList.Create;
    try
      for I:=0 to min(St.Count-1,MaxImages) do St2.Add(St[I]);
      ImageURL:=ListToValue(St2,'$');
    finally
      St2.Free;
    end;
  finally
    St.Free;
  end;
  result:=True;
end;

end.
