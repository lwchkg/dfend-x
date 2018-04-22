unit HistoryUnit;
interface

uses Classes, ComCtrls;

Type TInfoRec=record
  Count : Integer;
  First, Last : TDateTime;
  FirstStartNamesNr : Integer;
end;

Type THistory=class
  private
    StartData : Array of TInfoRec;
    GamesList : Array[0..26] of TStringList;
    StartNames, StartDates, StartTimes : TStringList;
    StartDataIndex : TList;
    hChangeNotification : THandle;
    LastChangeNotifyCheck : Cardinal;
    LastHistoryTime : Integer;
    Function GetHistoryFileName : String;
    Function GetHistoryFileTime : Integer;
    Procedure LoadList;
    Procedure LoadOrUpdateList;
    Procedure FreeLists;
    Function ListNr(const GameName : String) : Integer;
    Procedure ResetUpdateNotify;
    function GetStartCount(I: Integer): Integer;
    function GetStartDateTime(I: Integer): TDateTime;
    function GetStartDateTimeFirst(I: Integer): TDateTime;
    function GetStartDateTimeLast(I: Integer): TDateTime;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Add(const GameName : String);
    Function Clear : Boolean;
    Procedure LoadHistory(const AListView : TListView);
    Procedure LoadStatistics(const AListView : TListView);
    function GetRecentlyStarted(const MaxGames : Integer; const UpperCase : Boolean) : TStringList;
    Function GameStartCount(const GameName : String) : Integer;
    property StartCount[I : Integer] : Integer read GetStartCount;
    property StartDateTime[I : Integer] : TDateTime read GetStartDateTime;
    property StartDateTimeFirst[I : Integer] : TDateTime read GetStartDateTimeFirst;
    property StartDateTimeLast[I : Integer] : TDateTime read GetStartDateTimeLast;
end;

var History : THistory;

implementation

uses Windows, SysUtils, Dialogs, CommonTools, PrgSetupUnit, PrgConsts,
     LanguageSetupUnit;

{ THistory }

constructor THistory.Create;
Var I : Integer;
begin
  inherited Create;
  SetLength(StartData,0);
  For I:=0 to 26 do GamesList[I]:=nil;
  StartNames:=nil;
  StartDates:=nil;
  StartTimes:=nil;
  StartDataIndex:=nil;

  hChangeNotification:=INVALID_HANDLE_VALUE;
  LastChangeNotifyCheck:=0;
  LastHistoryTime:=0;
end;

destructor THistory.Destroy;
begin
  If hChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hChangeNotification);
  FreeLists;
  inherited Destroy;
end;

procedure THistory.FreeLists;
Var I : Integer;
begin
  SetLength(StartData,0);
  For I:=0 to 26 do If Assigned(GamesList[I]) then FreeAndNil(GamesList[I]);
  If Assigned(StartNames) then FreeAndNil(StartNames);
  If Assigned(StartDates) then FreeAndNil(StartDates);
  If Assigned(StartTimes) then FreeAndNil(StartTimes);
  If Assigned(StartDataIndex) then FreeAndNil(StartDataIndex);
end;

function THistory.GetHistoryFileName: String;
begin
  result:=PrgDataDir+SettingsFolder+'\'+HistoryFileName;
end;

function THistory.GetHistoryFileTime: Integer;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=0;
  I:=FindFirst(GetHistoryFileName,faAnyFile,Rec);
  try
    If I=0 then result:=Rec.Time;
  finally
    FindClose(Rec);
  end;
end;

function THistory.ListNr(const GameName: String): Integer;
Var I : Integer;
    S : String;
begin
  result:=0;
  For I:=1 to length(GameName) do if GameName[I]<>'' then begin
    S:=ExtUpperCase(GameName[I]);
    If (S<>'') and (S[1]>='A') and (S[1]<='Z') then result:=1+(ord(S[1])-ord('A'));
    break;
  end;
end;

procedure THistory.LoadList;
Var I,Nr1,Nr2,Nr3 : Integer;
    RawList,St : TStringList;
    S : String;
    StartTime : TDateTime;
begin
  {Init lists}
  SetLength(StartData,0);
  For I:=0 to 26 do GamesList[I]:=TStringList.Create;
  StartNames:=TStringList.Create;
  StartDates:=TStringList.Create;
  StartTimes:=TStringList.Create;
  StartDataIndex:=TList.Create;

  {Load file}
  If not FileExists(GetHistoryFileName) then exit;
  RawList:=TStringList.Create;
  try
    try
      RawList.LoadFromFile(GetHistoryFileName);
    except
      exit;
    end;

    For I:=0 to RawList.Count-1 do begin
      {Prepare line}
      S:=Trim(RawList[I]);
      If S='' then continue;
      St:=ValueToList(S);
      try
        If St.Count<3 then continue;
        While St.Count>3 do begin St[0]:=St[0]+';'+St[1]; St.Delete(1); end;

        StartTime:=0;
        try StartTime:=StrToDate(St[1]); except end;
        try StartTime:=StartTime+StrToTime(St[2]); except end;

        {Add to statistics}
        Nr1:=ListNr(St[0]);
        Nr2:=GamesList[Nr1].IndexOf(St[0]);
        If Nr2<0 then begin
          Nr3:=length(StartData);
          SetLength(StartData,Nr3+1);
          with StartData[Nr3] do begin Count:=1; First:=StartTime; Last:=StartTime; FirstStartNamesNr:=StartNames.Count; end;
          GamesList[Nr1].AddObject(St[0],TObject(Nr3));
        end else begin
          Nr3:=Integer(GamesList[Nr1].Objects[Nr2]);
          with StartData[Nr3] do begin
            inc(Count);
            If StartTime>Last then Last:=StartTime;
            If StartTime<First then First:=StartTime;
          end;
        end;

        {Add to history}
        StartNames.AddObject(St[0],TObject(Nr3));
        StartDates.Add(St[1]);
        StartTimes.Add(St[2]);
        StartDataIndex.Add(Pointer(Nr3));
      finally
        St.Free;
      end;
    end;

    For I:=0 to 26 do GamesList[I].Sorted:=True;
  finally
    RawList.Free;
  end;
end;

procedure THistory.LoadOrUpdateList;
Var I : Integer;
begin
  If GamesList[0]=nil then begin
    LoadList;
    hChangeNotification:=FindFirstChangeNotification(
      PChar(ExtractFilePath(GetHistoryFileName)),
      False,
      FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
    );
    LastChangeNotifyCheck:=GetTickCount;
    LastHistoryTime:=GetHistoryFileTime;
    exit;
  end;

  if LastChangeNotifyCheck<GetTickCount+1000 then begin
    LastChangeNotifyCheck:=GetTickCount;
    If (hChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hChangeNotification,0)=WAIT_OBJECT_0) then begin
      I:=GetHistoryFileTime;
      If I<>LastHistoryTime then begin
        LastHistoryTime:=I;
        FreeLists;
        LoadList;
      end;
      FindNextChangeNotification(hChangeNotification);
    end;
  end;
end;

procedure THistory.ResetUpdateNotify;
begin
  If hChangeNotification=INVALID_HANDLE_VALUE then exit;
  While WaitForSingleObject(hChangeNotification,0)=WAIT_OBJECT_0 do FindNextChangeNotification(hChangeNotification);
  LastHistoryTime:=GetHistoryFileTime;
  LastChangeNotifyCheck:=GetTickCount;
end;

procedure THistory.Add(const GameName: String);
Var Nr1,Nr2,Nr3 : Integer;
    F : TextFile;
    StartTime : TDateTime;
begin
  If (Trim(GameName)='') or (not PrgSetup.StoreHistory) then exit;

  StartTime:=Now;
  LoadOrUpdateList;

  {Add to statistics}
  Nr1:=ListNr(GameName);
  Nr2:=GamesList[Nr1].IndexOf(GameName);
  If Nr2<0 then begin
    Nr3:=length(StartData);
    SetLength(StartData,Nr3+1);
    with StartData[Nr3] do begin Count:=1; First:=StartTime; Last:=StartTime; end;
    GamesList[Nr1].AddObject(GameName,TObject(Nr3));
  end else begin
    Nr3:=Integer(GamesList[Nr1].Objects[Nr2]);
    with StartData[Nr3] do begin inc(Count); Last:=StartTime; end;
  end;

  {Add to history}
  StartNames.Add(GameName);
  StartDates.Add(DateToStr(StartTime));
  StartTimes.Add(TimeToStr(StartTime));
  StartDataIndex.Add(Pointer(Nr3));

  {Add to file}
  try
    ResetUpdateNotify;
    AssignFile(F,GetHistoryFileName);
    If FileExists(GetHistoryFileName) then Append(F) else Rewrite(F);
    try
      writeln(F,GameName+';'+DateToStr(StartTime)+';'+TimeToStr(StartTime));
    finally
      CloseFile(F);
    end;
  except
    MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[GetHistoryFileName]),mtError,[mbOK],0);
  end;
end;

function THistory.Clear: Boolean;
Var I : Integer;
begin
  result:=True;
  if not FileExists(GetHistoryFileName) then exit;
  result:=ExtDeleteFile(GetHistoryFileName,ftProfile);
  ResetUpdateNotify;
  if not result then MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[GetHistoryFileName]),mtError,[mbOK],0);

  SetLength(StartData,0);
  For I:=0 to 26 do If Assigned(GamesList[I]) then GamesList[I].Clear;
  If Assigned(StartNames) then StartNames.Clear;
  If Assigned(StartDates) then StartDates.Clear;
  If Assigned(StartTimes) then StartTimes.Clear;
  If Assigned(StartDataIndex) then StartDataIndex.Clear;
end;

procedure THistory.LoadHistory(const AListView: TListView);
Var C : TListColumn;
    I,Nr1,Nr3 : Integer;
    L : TListItem;
begin
  LoadOrUpdateList;

  AListView.Items.BeginUpdate;
  AListView.Columns.BeginUpdate;
  try
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryGame; C.Width:=1;
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryDateTime; C.Width:=1;
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryStarts; C.Width:=1;

    For I:=0 to StartNames.Count-1 do begin
      L:=AListView.Items.Add;
      L.Caption:=StartNames[I];
      L.SubItems.Add(StartDates[I]+' '+StartTimes[I]);
      L.Data:=Pointer(I);
      Nr1:=ListNr(StartNames[I]);
      Nr3:=Integer(GamesList[Nr1].Objects[GamesList[Nr1].IndexOf(StartNames[I])]);
      L.SubItems.Add(IntToStr(StartData[Nr3].Count));
    end;
  finally
    AListView.Items.EndUpdate;
    For I:=0 to AListView.Columns.Count-1 do AListView.Columns[I].Width:=-2;
    AListView.Columns.EndUpdate;
  end;
end;

function THistory.GetRecentlyStarted(const MaxGames : Integer; const UpperCase : Boolean) : TStringList;
Var S : String;
    I : Integer;
begin
  LoadOrUpdateList;

  result:=TStringList.Create;
  For I:=StartNames.Count-1 downto 0 do begin
    S:=StartNames[I];
    if UpperCase then S:=ExtUpperCase(S);    
    if (result.indexOf(S)<0) then result.add(S);
    if (result.count>=MaxGames) then exit;
  end;
end;

procedure THistory.LoadStatistics(const AListView: TListView);
Var C : TListColumn;
    I,Nr3 : Integer;
    L : TListItem;
    St : TStringList;
begin
  LoadOrUpdateList;

  AListView.Items.BeginUpdate;
  AListView.Columns.BeginUpdate;
  try
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryGame; C.Width:=1;
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryStarts; C.Width:=1;
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryFirst; C.Width:=1;
    C:=AListView.Columns.Add; C.Caption:=LanguageSetup.HistoryLast; C.Width:=1;

    St:=TStringList.Create;
    try
      For I:=0 to 26 do St.AddStrings(GamesList[I]);
      St.Sort;
      For I:=0 to St.Count-1 do begin
        L:=AListView.Items.Add;
        L.Caption:=St[I];
        Nr3:=Integer(St.Objects[I]);
        L.Data:=Pointer(StartData[Nr3].FirstStartNamesNr);
        L.SubItems.Add(IntToStr(StartData[Nr3].Count));
        L.SubItems.Add(DateToStr(StartData[Nr3].First)+' '+TimeToStr(StartData[Nr3].First));
        L.SubItems.Add(DateToStr(StartData[Nr3].Last)+' '+TimeToStr(StartData[Nr3].Last));
      end;
    finally
      St.Free;
    end;
  finally
    AListView.Items.EndUpdate;
    For I:=0 to AListView.Columns.Count-1 do AListView.Columns[I].Width:=-2;
    AListView.Columns.EndUpdate;
  end;
end;

function THistory.GameStartCount(const GameName: String): Integer;
Var Nr2 : Integer;
    St : TStringList;
begin
  LoadOrUpdateList;

  result:=0;
  St:=GamesList[ListNr(GameName)];
  Nr2:=St.IndexOf(GameName); If Nr2<0 then exit;
  result:=StartData[Integer(St.Objects[Nr2])].Count;
end;

function THistory.GetStartCount(I: Integer): Integer;
begin
  result:=0;
  if (I<0) or (I>StartNames.Count) then exit;
  result:=StartData[Integer(StartNames.Objects[I])].Count;
end;

function THistory.GetStartDateTime(I: Integer): TDateTime;
begin
  result:=0;
  if (I<0) or (I>StartNames.Count) then exit;
  try result:=StrToDate(StartDates[I]); except end;
  try result:=result+StrToTime(StartTimes[I]); except end;
end;

function THistory.GetStartDateTimeFirst(I: Integer): TDateTime;
begin
  result:=0;
  if (I<0) or (I>StartNames.Count) then exit;
  result:=StartData[Integer(StartNames.Objects[I])].First;
end;

function THistory.GetStartDateTimeLast(I: Integer): TDateTime;
begin
  result:=0;
  if (I<0) or (I>StartNames.Count) then exit;
  result:=StartData[Integer(StartNames.Objects[I])].Last;
end;

initialization
  History:=THistory.Create;
finalization
  History.Free;
end.
