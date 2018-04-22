unit CommonComponents;
interface

{DEFINE DoubleNumberCheck}

uses Windows, Classes, IniFiles, Math, Variants;

Type TConfigRec=record
  Nr : Integer;
  Section, Key : String;
  DefaultBool : Boolean;
  DefaultInteger : Integer;
  DefaultString : String;
  Cached : Boolean;
  CacheValueBool : Boolean;
  CacheValueInteger : Integer;
  CacheValueString : String;
end;

Type TConfigRecArray=Array of TConfigRec;
     PConfigRec=^TConfigRec;
     PConfigRecArray=^TConfigRecArray;
     TConfigIndexArray=Array of Integer;

Type TConfigType=(ctBoolean,ctInteger,ctString);

Type TFileChangeStatus=(fcsNoChange,fcsChanged,fcsDeleted);

Type TBasePrgSetup=class
  private
    FSetupFile : String;
    FFirstRun : Boolean;
    Ini : TMemIniFile;
    FOwnINI : Boolean;
    BooleanList, IntegerList, StringList : TConfigRecArray;
    BooleanListUsed, IntegerListUsed, StringListUsed : Integer;
    BooleanIndex, IntegerIndex, StringIndex : TConfigIndexArray;
    FStoreConfigOnExit : Boolean;
    FOnChanged : TNotifyEvent;
    FLastTimeStamp : DWord;
    FChanged : Boolean;
    Procedure ClearLists;
    Function IndexOf(const Nr : Integer; const List : TConfigRecArray; var Index : TConfigIndexArray) : Integer; inline;
    Function AddRec(const ANr : Integer; const ASection, AKey : String; var List : TConfigRecArray) : Integer; inline;
    function AddRecFast(const ANr: Integer; const ASection, AKey: String; var List: TConfigRecArray; var UsedCounter : Integer) : Integer; inline;
    Procedure ReadStringFromINI(const I : Integer);
    Procedure LoadBinConfig(const St : TStream; const PConfig : PConfigRecArray; const ConfigType : TConfigType);
    Procedure StoreBinConfig(const St : TStream; const PConfig : PConfigRecArray; const ConfigType : TConfigType);
    Procedure LoadIniNow; inline;
    Function GetIni : TMemIniFile;
  protected
    Procedure FastAddRecStart;
    Procedure FastAddRecDone;
    Procedure AddBooleanRec(const Nr : Integer; const Section, Key : String; const Default : Boolean); inline;
    Procedure AddIntegerRec(const Nr : Integer; const Section, Key : String; const Default : Integer); inline;
    Procedure AddStringRec(const Nr : Integer; const Section, Key : String; const Default : String); inline;
    function GetBoolean(const Index: Integer): Boolean;
    function GetInteger(const Index: Integer): Integer;
    procedure SetBoolean(const Index: Integer; const Value: Boolean);
    procedure SetInteger(const Index, Value: Integer);
    procedure SetString(const Index: Integer; const Value: String);
  public
    Constructor Create(const ASetupFile : String); overload;
    constructor CreateNoTimeStampCheck(const ASetupFile: String);
    Constructor Create(const ABasePrgSetup : TBasePrgSetup); overload;
    Destructor Destroy; override;
    Procedure UpdateFile; virtual;
    Procedure AssignFrom(const ABasePrgSetup : TBasePrgSetup);
    Procedure AssignFromPartially(const ABasePrgSetup : TBasePrgSetup; const SettingsToKeep : Array of Integer);
    Procedure StoreAllValues;
    Procedure ResetToDefault;
    Function CheckAndUpdateTimeStamp : TFileChangeStatus;
    Procedure ReloadINI; virtual;
    Procedure RenameINI(const NewFile : String); virtual;
    Procedure SetChanged;
    function GetString(const Index: Integer): String; inline;
    Procedure LoadFromStream(const St : TStream); virtual;
    Procedure SaveToStream(const St : TStream); virtual;
    Function GetBinaryVersionID : Integer;
    Procedure CacheAllStrings;
    property SetupFile : String read FSetupFile;
    property FirstRun : Boolean read FFirstRun;
    property StoreConfigOnExit : Boolean read FStoreConfigOnExit write FStoreConfigOnExit;
    property OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
    property OwnINI : Boolean read FOwnINI;
    property MemIni : TMemIniFile read GetIni;
end;

implementation

uses SysUtils, CommonTools {$IFDEF DoubleNumberCheck}, Dialogs {$ENDIF};

{ TBasePrgSetup }

Function GetSimpleFileTime(const FileName : String) : DWord;
Var hFile : THandle;
    FileTime1, FileTime2, FileTime3 : TFileTime;
    FatDate, FatTime : Word;
begin
  hFile:=CreateFile(PChar(FileName),GENERIC_READ,FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  If hFile=INVALID_HANDLE_VALUE then begin result:=0; exit; end;
  try
    GetFileTime(hFile,@FileTime1,@FileTime2,@FileTime3);
  finally
    CloseHandle(hFile)
  end;
  FileTimeToDosDateTime(FileTime3,FatDate,FatTime);
  result:=FatDate*65536+FatTime;
end;

constructor TBasePrgSetup.Create(const ASetupFile: String);
begin
  inherited Create;
  BooleanListUsed:=-1;
  IntegerListUsed:=-1;
  StringListUsed:=-1;
  FSetupFile:=ASetupFile;
  FLastTimeStamp:=0;
  FFirstRun:=not FileExists(ASetupFile);
  FOwnINI:=True;
  If ASetupFile<>'' then begin
    Ini:=nil;
    CheckAndUpdateTimeStamp;
  end else begin
    Ini:=nil; FOwnIni:=False;
  end;
  FStoreConfigOnExit:=True;
  FChanged:=False;
end;

constructor TBasePrgSetup.CreateNoTimeStampCheck(const ASetupFile: String);
begin
  inherited Create;
  BooleanListUsed:=-1;
  IntegerListUsed:=-1;
  StringListUsed:=-1;
  FSetupFile:=ASetupFile;
  FLastTimeStamp:=0;
  FFirstRun:=not FileExists(ASetupFile);
  FOwnINI:=True;
  If ASetupFile<>'' then begin
    Ini:=nil;
  end else begin
    Ini:=nil; FOwnIni:=False;
  end;
  FStoreConfigOnExit:=True;
  FChanged:=False;
end;

constructor TBasePrgSetup.Create(const ABasePrgSetup: TBasePrgSetup);
begin
  inherited Create;
  BooleanListUsed:=-1;
  IntegerListUsed:=-1;
  StringListUsed:=-1;
  FOwnINI:=False;
  FFirstRun:=False;
  Ini:=ABasePrgSetup.MemIni;
  ClearLists;
  FStoreConfigOnExit:=True;
  FChanged:=False;
end;

destructor TBasePrgSetup.Destroy;
Var St,St2 : TStringList;
    I : Integer;
begin
  If FChanged and FStoreConfigOnExit then begin
    LoadIniNow;
    If OwnINI then begin
      St:=TStringList.Create;
      St2:=TStringList.Create;
      try
        Ini.ReadSections(St);
        For I:=0 to St.Count-1 do begin
          St2.Clear;
          Ini.ReadSection(St[I],St2);
          If St2.Count=0 then Ini.EraseSection(St[I]);
        end;
      finally
        St.Free;
        St2.Free;
      end;
    end;
    try
      If Ini<>nil then begin
        ForceDirectories(ExtractFilePath(Ini.FileName));
        UpdateFile;
      end;
    except end;
  end;

  If FOwnINI and (Ini<>nil) then Ini.Free;

  inherited Destroy;
end;

Procedure TBasePrgSetup.LoadIniNow;
begin
  If (Ini=nil) and FOwnINI then
    Ini:=TMemIniFile.Create(FSetupFile);
end;

Function TBasePrgSetup.GetIni : TMemIniFile;
begin
  LoadIniNow;
  result:=Ini;
end;

function TBasePrgSetup.CheckAndUpdateTimeStamp: TFileChangeStatus;
Var NewFileTime : DWord;
begin
  If FSetupFile='' then begin result:=fcsNoChange; exit; end;

  If not FileExists(FSetupFile) then begin result:=fcsDeleted; exit; end;

  NewFileTime:=GetSimpleFileTime(FSetupFile);
  If NewFileTime=FLastTimeStamp then result:=fcsNoChange else result:=fcsChanged;
  FLastTimeStamp:=NewFileTime;
end;

Procedure TBasePrgSetup.ReloadINI;
Var I : Integer;
begin
  If Ini<>nil then Ini.Free;
  Ini:=TMemIniFile.Create(FSetupFile);
  for I:=0 to length(BooleanList)-1 do BooleanList[I].Cached:=False;
  for I:=0 to length(IntegerList)-1 do IntegerList[I].Cached:=False;
  for I:=0 to length(StringList)-1 do StringList[I].Cached:=False;
end;

procedure TBasePrgSetup.RenameINI(const NewFile: String);
begin
  LoadIniNow;
  Ini.UpdateFile;
  Ini.Free;
  If FSetupFile<>NewFile then begin
    if RenameFile(FSetupFile,NewFile) then FSetupFile:=NewFile;
  end;
  Ini:=TMemIniFile.Create(FSetupFile);
end;

procedure TBasePrgSetup.ClearLists;
begin
  SetLength(BooleanList,0);
  SetLength(IntegerList,0);
  SetLength(StringList,0);
end;

procedure TBasePrgSetup.AssignFrom(const ABasePrgSetup: TBasePrgSetup);
begin
  AssignFromPartially(ABasePrgSetup,[]);
end;

Procedure TBasePrgSetup.AssignFromPartially(const ABasePrgSetup : TBasePrgSetup; const SettingsToKeep : Array of Integer);
Var I,J : Integer;
    B : Boolean;
begin
  For I:=0 to length(BooleanList)-1 do begin
    B:=True;
    For J:=Low(SettingsToKeep) to High(SettingsToKeep) do if SettingsToKeep[J]=BooleanList[I].Nr then begin B:=False; break; end;
    If not B then continue;
    BooleanList[I].Cached:=True;
    BooleanList[I].CacheValueBool:=ABasePrgSetup.GetBoolean(BooleanList[I].Nr);
  end;
  For I:=0 to length(IntegerList)-1 do begin
    B:=True;
    For J:=Low(SettingsToKeep) to High(SettingsToKeep) do if SettingsToKeep[J]=IntegerList[I].Nr then begin B:=False; break; end;
    If not B then continue;
    IntegerList[I].Cached:=True;
    IntegerList[I].CacheValueInteger:=ABasePrgSetup.GetInteger(IntegerList[I].Nr);
  end;
  For I:=0 to length(StringList)-1 do begin
    B:=True;
    For J:=Low(SettingsToKeep) to High(SettingsToKeep) do if SettingsToKeep[J]=StringList[I].Nr then begin B:=False; break; end;
    If not B then continue;
    StringList[I].Cached:=True;
    StringList[I].CacheValueString:=ABasePrgSetup.GetString(StringList[I].Nr);
  end;

  StoreAllValues;
end;

Function TBasePrgSetup.IndexOf(const Nr : Integer; const List : TConfigRecArray; var Index : TConfigIndexArray) : Integer;
Var I : Integer;
begin
  If length(Index)=0 then begin
    {List is sorted J:=0; For I:=0 to length(List)-1 do J:=Max(J,List[I].Nr); SetLength(Index,J+1);}
    SetLength(Index,List[length(List)-1].Nr+1);
    For I:=0 to length(Index)-1 do Index[I]:=-1;
    For I:=0 to length(List)-1 do Index[List[I].Nr]:=I;
  end;
  result:=Index[Nr];
end;

procedure TBasePrgSetup.StoreAllValues;
Var I : Integer;
begin
  LoadIniNow;
  if Ini=nil then exit;

  For I:=0 to length(BooleanList)-1 do
    Ini.WriteBool(BooleanList[I].Section,BooleanList[I].Key,GetBoolean(BooleanList[I].Nr));

  For I:=0 to length(IntegerList)-1 do
    Ini.WriteInteger(IntegerList[I].Section,IntegerList[I].Key,GetInteger(IntegerList[I].Nr));

  For I:=0 to length(StringList)-1 do
    Ini.WriteString(StringList[I].Section,StringList[I].Key,GetString(StringList[I].Nr));

  If FChanged then UpdateFile;
  FChanged:=False;

  CheckAndUpdateTimeStamp;
end;

procedure TBasePrgSetup.UpdateFile;
begin
  LoadIniNow;
  try ForceDirectories(ExtractFilePath(Ini.FileName)); Ini.UpdateFile; except end; {Language Files may be read only in program foldes}
end;

procedure TBasePrgSetup.ResetToDefault;
Var I : Integer;
begin
  For I:=0 to length(BooleanList)-1 do
    SetBoolean(BooleanList[I].Nr,BooleanList[I].DefaultBool);

  For I:=0 to length(IntegerList)-1 do
    SetInteger(IntegerList[I].Nr,IntegerList[I].DefaultInteger);

  For I:=0 to length(StringList)-1 do
    SetString(StringList[I].Nr,StringList[I].DefaultString);

  UpdateFile;
  FChanged:=False;

  CheckAndUpdateTimeStamp;
end;

procedure TBasePrgSetup.FastAddRecDone;
begin
  if BooleanListUsed>=0 then SetLength(BooleanList,BooleanListUsed);
  If IntegerListUsed>=0 then SetLength(IntegerList,IntegerListUsed);
  If StringListUsed>=0 then SetLength(StringList,StringListUsed);
end;

procedure TBasePrgSetup.FastAddRecStart;
begin
  BooleanListUsed:=0;
  IntegerListUsed:=0;
  StringListUsed:=0;
end;

function TBasePrgSetup.AddRec(const ANr: Integer; const ASection, AKey: String; var List: TConfigRecArray) : Integer;
Var I,J : Integer;
begin
  result:=length(List);
  SetLength(List,result+1);

  J:=result;
  {$IFDEF DoubleNumberCheck}
  For I:=0 to result-1 do begin
    If (J=length(List)-1) and (ANr<List[I].Nr) then J:=I;
    If ANr=List[I].Nr then ShowMessage('Double use of nr '+IntToStr(ANr));
  end;
  For I:=result-1 downto J do List[I+1]:=List[I];
  result:=J;
  {$ELSE}
  If ANr<List[result-1].Nr then begin
    For I:=0 to result-1 do If ANr<List[I].Nr then begin J:=I; break; end;
    For I:=result-1 downto J do List[I+1]:=List[I];
    result:=J;
  end;
  {$ENDIF}

  with List[J] do begin
    Nr:=ANr;
    Section:=ASection;
    Key:=AKey;
    Cached:=False;
  end;
end;

function TBasePrgSetup.AddRecFast(const ANr: Integer; const ASection, AKey: String; var List: TConfigRecArray; var UsedCounter : Integer) : Integer;
Var I,J : Integer;
begin
  if UsedCounter=length(List) then SetLength(List,UsedCounter+50);
  result:=UsedCounter;
  inc(UsedCounter);

  J:=result;
  {$IFDEF DoubleNumberCheck}
  For I:=0 to result-1 do begin
    If (J=result) and (ANr<List[I].Nr) then J:=I;
    If ANr=List[I].Nr then ShowMessage('Double use of nr '+IntToStr(ANr));
  end;
  For I:=result-1 downto J do List[I+1]:=List[I];
  result:=J;
  {$ELSE}
  If ANr<List[result-1].Nr then begin
    For I:=0 to result-1 do If ANr<List[I].Nr then begin J:=I; break; end;
    For I:=result-1 downto J do List[I+1]:=List[I];
    result:=J;
  end;
  {$ENDIF}

  with List[J] do begin
    Nr:=ANr;
    Section:=ASection;
    Key:=AKey;
    Cached:=False;
  end;
end;

procedure TBasePrgSetup.AddBooleanRec(const Nr: Integer; const Section, Key: String; const Default : Boolean);
begin
  if BooleanListUsed>=0
    then BooleanList[AddRecFast(Nr,Section,Key,BooleanList,BooleanListUsed)].DefaultBool:=Default
    else BooleanList[AddRec(Nr,Section,Key,BooleanList)].DefaultBool:=Default;
end;

procedure TBasePrgSetup.AddIntegerRec(const Nr: Integer; const Section, Key: String; const Default : Integer);
begin
  If IntegerListUsed>=0
    then IntegerList[AddRecFast(Nr,Section,Key,IntegerList,IntegerListUsed)].DefaultInteger:=Default
    else IntegerList[AddRec(Nr,Section,Key,IntegerList)].DefaultInteger:=Default;
end;

procedure TBasePrgSetup.AddStringRec(const Nr: Integer; const Section, Key: String; const Default : String);
begin
  If StringListUsed>=0
    then StringList[AddRecFast(Nr,Section,Key,StringList,StringListUsed)].DefaultString:=Default
    else StringList[AddRec(Nr,Section,Key,StringList)].DefaultString:=Default;
end;

function TBasePrgSetup.GetBoolean(const Index: Integer): Boolean;
Var I : Integer;
    S : String;
    B : Boolean;
begin
  I:=IndexOf(Index,BooleanList,BooleanIndex);
  if I<0 then begin result:=False; exit; end;
  with BooleanList[I] do begin
    If Cached then begin result:=CacheValueBool; exit; end;

    If DefaultBool then S:='true' else S:='false';
    LoadIniNow;
    If Ini<>nil then S:=Trim(ExtUpperCase(Ini.ReadString(Section,Key,S)));
    B:=False; result:=False;
    If (S='0') or (S='FALSE') then begin result:=False; B:=True; end;
    If (S='1') or (S='TRUE') then begin result:=True; B:=True; end;
    If not B then result:=DefaultBool;

    Cached:=True;
    CacheValueBool:=result;
  end;
end;

function TBasePrgSetup.GetInteger(const Index: Integer): Integer;
Var I : Integer;
begin
  I:=IndexOf(Index,IntegerList,IntegerIndex);
  Assert(I>=0,'Es gibt keinen Eintrag in der Integer-Liste mit der Nummer '+IntToStr(Index));
  if I<0 then begin result:=0; exit; end;
  with IntegerList[I] do begin
    If Cached then begin result:=CacheValueInteger; exit; end;
    LoadIniNow;
    If Ini<>nil then result:=Ini.ReadInteger(Section,Key,DefaultInteger) else result:=DefaultInteger;
    Cached:=True;
    CacheValueInteger:=result;
  end;
end;

Procedure TBasePrgSetup.ReadStringFromINI(const I : Integer);
begin
  LoadIniNow;
  with StringList[I] do begin
    Cached:=True;
    if Ini<>nil then CacheValueString:=Ini.ReadString(Section,Key,DefaultString) else CacheValueString:=DefaultString;
  end;
end;

procedure TBasePrgSetup.SetChanged;
begin
  FChanged:=True;
end;

function TBasePrgSetup.GetString(const Index: Integer): String;
Var I : Integer;
begin
  I:=IndexOf(Index,StringList,StringIndex);
  if I<0 then begin result:=''; exit; end;
  with StringList[I] do begin
    If not Cached then ReadStringFromINI(I);
    result:=CacheValueString;
  end;
end;

procedure TBasePrgSetup.SetBoolean(const Index: Integer; const Value: Boolean);
Var I : Integer;
begin
  I:=IndexOf(Index,BooleanList,BooleanIndex);
  if I<0 then exit;
  with BooleanList[I] do begin
    LoadIniNow;
    If DefaultBool=Value then Ini.DeleteKey(Section,Key) else Ini.WriteBool(Section,Key,Value);
    Cached:=True;
    CacheValueBool:=Value;
    FChanged:=True;
  end;
end;

procedure TBasePrgSetup.SetInteger(const Index, Value: Integer);
Var I : Integer;
begin
  I:=IndexOf(Index,IntegerList,IntegerIndex);
  if I<0 then exit;
  with IntegerList[I] do begin
    LoadIniNow;
    If DefaultInteger=Value then Ini.DeleteKey(Section,Key) else Ini.WriteInteger(Section,Key,Value);
    Cached:=True;
    CacheValueInteger:=Value;
    FChanged:=True;
  end;
end;

procedure TBasePrgSetup.SetString(const Index: Integer; const Value: String);
Var I : Integer;
begin
  I:=IndexOf(Index,StringList,StringIndex);
  if I<0 then exit;
  with StringList[I] do begin
    LoadIniNow;
    If DefaultString=Value then Ini.DeleteKey(Section,Key) else Ini.WriteString(Section,Key,Value);
    Cached:=True;
    CacheValueString:=Value;
    FChanged:=True;
  end;
end;

Procedure TBasePrgSetup.CacheAllStrings;
Var I : Integer;
begin
  For I:=0 to length(StringList)-1 do if not StringList[I].Cached then ReadStringFromINI(I);
end;

Procedure TBasePrgSetup.LoadBinConfig(const St : TStream; const PConfig : PConfigRecArray; const ConfigType : TConfigType);
Var I,J : Integer;
begin
  Case ConfigType of
    ctBoolean : For I:=0 to length(PConfig^)-1 do begin St.Read(PConfig^[I].CacheValueBool,SizeOf(Boolean)); PConfig^[I].Cached:=True; end;
    ctInteger : For I:=0 to length(PConfig^)-1 do begin St.Read(PConfig^[I].CacheValueInteger,SizeOf(Integer)); PConfig^[I].Cached:=True; end;
    ctString : For I:=0 to length(PConfig^)-1 do begin
                 St.Read(J,SizeOf(Integer));
                 If J>0 then begin
                   SetLength(PConfig^[I].CacheValueString,J); St.Read(PConfig^[I].CacheValueString[1],J);
                 end else begin
                   PConfig^[I].CacheValueString:='';
                 end;
                 PConfig^[I].Cached:=True;
               end;
  end;
end;

Procedure TBasePrgSetup.StoreBinConfig(const St : TStream; const PConfig : PConfigRecArray; const ConfigType : TConfigType);
Var I,J : Integer;
begin
  For I:=0 to length(PConfig^)-1 do Case ConfigType of
    ctBoolean : begin
                  If not PConfig^[I].Cached then GetBoolean(PConfig^[I].Nr);
                  St.WriteBuffer(PConfig^[I].CacheValueBool,SizeOf(Boolean));
                end;
    ctInteger : begin
                  If not PConfig^[I].Cached then GetInteger(PConfig^[I].Nr);
                  St.WriteBuffer(PConfig^[I].CacheValueInteger,SizeOf(Integer));
                end;
    ctString : begin
                 If not PConfig^[I].Cached then GetString(PConfig^[I].Nr);
                 J:=Length(PConfig^[I].CacheValueString); St.WriteBuffer(J,SizeOf(Integer)); St.WriteBuffer(PConfig^[I].CacheValueString[1],J);
               end;
  end;
end;

Procedure TBasePrgSetup.LoadFromStream(const St : TStream);
begin
  LoadBinConfig(St,@BooleanList,ctBoolean);
  LoadBinConfig(St,@IntegerList,ctInteger);
  LoadBinConfig(St,@StringList,ctString);
  St.Read(FLastTimeStamp,SizeOf(FLastTimeStamp));
  FChanged:=False;
end;

Procedure TBasePrgSetup.SaveToStream(const St : TStream);
begin
  StoreBinConfig(St,@BooleanList,ctBoolean);
  StoreBinConfig(St,@IntegerList,ctInteger);
  StoreBinConfig(St,@StringList,ctString);
  St.WriteBuffer(FLastTimeStamp,SizeOf(FLastTimeStamp));
end;

Function TBasePrgSetup.GetBinaryVersionID : Integer;
begin
  result:=1000*1000*length(BooleanList)+1000*length(IntegerList)+length(StringList);
end;

end.

