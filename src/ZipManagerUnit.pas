unit ZipManagerUnit;
interface

uses Classes, ExtCtrls, GameDBUnit;

Type TZipRecord=record
  Nr : Integer;
  DOSBoxHandle : THandle;
  InavlidDOSBox : Boolean;
  ZipDrives : Integer;
  IsScummVM : Boolean;
  Folder,ZipFile : Array[0..9] of String;
  DeleteType : Array[0..9] of Integer;
  DriveLetter : Array[0..9] of String;
  OnlyRepack : Array[0..9] of Boolean;
end;

Type TZipManager=class
  private
    Timer : TTimer;
    NrCount : Integer;
    List : Array of TZipRecord;
    FOnInfoBarNotify : TNotifyEvent;
    Function GetCount : Integer;
    Function CheckMountCommand(const Command : String; var Folder, ZipFile : String; var DeleteType : Integer; var DriveLetter : String; var IsPhysFS : Boolean) : Boolean;
    Procedure TimerWork(Sender : TObject);
    Procedure RepackData(const Folder, ZipFile: String; const DeleteType : Integer; const AddToZipFile : Boolean);
    Function UnpackData(const Folder, ZipFile : String) : Boolean;
    function GetData(I: Integer): TZipRecord;
    Function AddGameDOSBox(const Game : TGame; var Error : Boolean) : Integer;
    Function AddGameScummVM(const Game : TGame; var Error : Boolean) : Integer;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function AddGame(const Game : TGame; var Error : Boolean) : Integer;
    Procedure ActivateRepackCheck(const Nr : Integer; DOSBoxHandle : THandle);
    property Count : Integer read GetCount;
    property OnInfoBarNotify : TNotifyEvent read FOnInfoBarNotify write FOnInfoBarNotify;
    property Data[I : Integer] : TZipRecord read GetData;
end;

Var ZipManager : TZipManager;

implementation

uses Windows, SysUtils, Forms, Dialogs, LanguageSetupUnit, CommonTools,
     GameDBToolsUnit, PrgSetupUnit, DOSBoxUnit, ZipInfoFormUnit, SevenZipVCL;

{ TZipManager }

constructor TZipManager.Create;
begin
  inherited Create;
  NrCount:=-1;
  Timer:=TTimer.Create(nil);
  with Timer do begin
    OnTimer:=TimerWork;
    Interval:=1000;
    Enabled:=True;
  end;
end;

destructor TZipManager.Destroy;
begin
  Timer.Free;
  inherited Destroy;
end;

function TZipManager.GetCount: Integer;
begin
  result:=length(List);
end;

function TZipManager.GetData(I: Integer): TZipRecord;
begin
  result:=List[I];
end;

Function TZipManager.CheckMountCommand(const Command : String; var Folder, ZipFile : String; var DeleteType : Integer; var DriveLetter : String; var IsPhysFS : Boolean) : Boolean;
Var St, St2 : TStringList;
    S,T : String;
    I : Integer;
begin
  result:=False;
  IsPhysFS:=False;

  St:=ValueToList(Command);
  St2:=TStringList.Create;
  try
    S:=Trim(St[0]);
    I:=Pos('$',S);
    While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
    St2.Add(S);
    For I:=0 to St2.Count-1 do St2[I]:=MakeAbsPath(St2[I],PrgSetup.BaseDir);
    S:=St2[0];

    {general: RealFolder;Type;Letter;IO;Label;FreeSpace}
    If St.Count<3 then exit;
    If St.Count=3 then St.Add('false');
    If St.Count=4 then St.Add('');
    If St.Count=5 then St.Add('');

    T:=Trim(ExtUpperCase(St[1]));

    If St2.Count<>2 then exit;


    If T='ZIP' then begin
      {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder;no-norepack;files-norepack;folder-norepack)}
      result:=True;
      DriveLetter:=St[2];
      Folder:=ShortName(St2[0]);
      ZipFile:=ShortName(St2[1]);
      DeleteType:=0;
      If St.Count>=7 then begin
        S:=Trim(ExtUpperCase(St[6]));
        If S='FILES' then DeleteType:=1;
        If S='FOLDER' then DeleteType:=2;
        If S='NO-NOREPACK' then DeleteType:=3;
        If S='FILES-NOREPACK' then DeleteType:=4;
        If S='FOLDER-NOREPACK' then DeleteType:=5;
      end;
    end;

    If T='PHYSFS' then begin
      {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace;DeleteMode(no;files;folder;no-norepack;files-norepack;folder-norepack)}

      DeleteType:=0;
      If St.Count>=7 then begin
        S:=Trim(ExtUpperCase(St[6]));
        If S='FILES' then DeleteType:=1;
        If S='FOLDER' then DeleteType:=2;
        If S='NO-NOREPACK' then DeleteType:=3;
        If S='FILES-NOREPACK' then DeleteType:=4;
        If S='FOLDER-NOREPACK' then DeleteType:=5;
      end;
      If DeleteType=0 then exit; {no extracting needed, only add a record if repack is needed}

      IsPhysFS:=True;
      result:=True;
      DriveLetter:=St[2];
      Folder:=ShortName(St2[0]);
      ZipFile:=ShortName(St2[1]);
    end;
  finally
    St.Free;
    St2.Free;
  end;
end;

function TZipManager.AddGame(const Game: TGame; var Error : Boolean): Integer;
begin
  If ScummVMMode(Game)
    then result:=AddGameScummVM(Game,Error)
    else result:=AddGameDOSBox(Game,Error);
end;

Function TZipManager.AddGameDOSBox(const Game : TGame; var Error : Boolean) : Integer;
Var I,J,K,Nr,DeleteType : Integer;
    S,Folder,ZipFile,DriveLetter : String;
    IsPhysFS : Boolean;
begin
  Error:=False;
  result:=-1;

  Nr:=-1;
  For I:=0 to 9 do begin
    S:=Game.Mount[I];
    If S='' then continue;
    If CheckMountCommand(S,Folder,ZipFile,DeleteType,DriveLetter,IsPhysFS) then begin
      If Nr<0 then begin
        inc(NrCount);
        Nr:=length(List);
        SetLength(List,Nr+1);
        List[Nr].Nr:=NrCount;
        List[Nr].DOSBoxHandle:=INVALID_HANDLE_VALUE;
        List[Nr].IsScummVM:=False;
        List[Nr].InavlidDOSBox:=False;
        List[Nr].ZipDrives:=0;
      end;

      For J:=0 to length(List)-2 do For K:=0 to List[J].ZipDrives-1 do If Trim(ExtUpperCase(MakeRelPath(List[J].ZipFile[K],PrgSetup.BaseDir)))=Trim(ExtUpperCase(MakeRelPath(ZipFile,PrgSetup.BaseDir))) then begin
        MessageDlg(Format(LanguageSetup.ZipFormZipFileInUseWarning,[ZipFile]),mtError,[mbOK],0);
        Error:=True; dec(NrCount); SetLength(List,length(List)-1); exit;
      end;

      List[Nr].Folder[List[Nr].ZipDrives]:=Folder;
      List[Nr].ZipFile[List[Nr].ZipDrives]:=ZipFile;
      List[Nr].DeleteType[List[Nr].ZipDrives]:=DeleteType;
      List[Nr].DriveLetter[List[Nr].ZipDrives]:=DriveLetter;
      List[Nr].OnlyRepack[List[Nr].ZipDrives]:=IsPhysFS;
      inc(List[Nr].ZipDrives);
    end;
  end;

  If Nr>=0 then begin
    result:=List[Nr].Nr;
    For I:=0 to List[Nr].ZipDrives-1 do If not List[Nr].OnlyRepack[I] then begin
      If not UnpackData(List[Nr].Folder[I],List[Nr].ZipFile[I]) then begin
        Error:=True; dec(NrCount); SetLength(List,length(List)-1); exit;
      end;
    end;
  end;
end;

Function TZipManager.AddGameScummVM(const Game : TGame; var Error : Boolean) : Integer;
Var Zip, Folder : String;
    Nr,J,K : Integer;
begin
  Error:=False;
  result:=-1;

  If Trim(Game.ScummVMZip)='' then exit;
  Zip:=MakeAbsPath(Game.ScummVMZip,PrgSetup.BaseDir);
  Folder:=MakeAbsPath(Game.ScummVMPath,PrgSetup.BaseDir);

  Error:=not UnpackData(Folder,Zip); If Error then exit;

  inc(NrCount);
  Nr:=length(List);
  SetLength(List,Nr+1);
  List[Nr].Nr:=NrCount;
  List[Nr].DOSBoxHandle:=INVALID_HANDLE_VALUE;
  List[Nr].IsScummVM:=True;
  List[Nr].InavlidDOSBox:=False;
  List[Nr].ZipDrives:=1;

  For J:=0 to length(List)-2 do For K:=0 to List[J].ZipDrives-1 do If Trim(ExtUpperCase(MakeRelPath(List[J].ZipFile[K],PrgSetup.BaseDir)))=Trim(ExtUpperCase(Zip)) then begin
    MessageDlg(Format(LanguageSetup.ZipFormZipFileInUseWarning,[Zip]),mtError,[mbOK],0);
    Error:=True; dec(NrCount); SetLength(List,length(List)-1); exit;
  end;

  List[Nr].Folder[0]:=Folder;
  List[Nr].ZipFile[0]:=Zip;
  List[Nr].DeleteType[0]:=2; {2=Delete whole folder}
  List[Nr].DriveLetter[0]:='';
  List[Nr].OnlyRepack[List[Nr].ZipDrives]:=False;

  result:=List[Nr].Nr;
end;

Function TZipManager.UnpackData(const Folder, ZipFile: String) : Boolean;
Var AZipFile, ADestFolder : String;
begin
  AZipFile:=MakeAbsPath(ZipFile,PrgSetup.BaseDir);
  ADestFolder:=MakeAbsPath(Folder,PrgSetup.BaseDir);
  result:=ExtractZipFile(Application.MainForm,AZipFile,ADestFolder);
end;

procedure TZipManager.ActivateRepackCheck(const Nr: Integer; DOSBoxHandle: THandle);
Var I : Integer;
    NewHandle : THandle;
begin
  For I:=0 to length(List)-1 do If List[I].Nr=Nr then begin
    If DOSBoxHandle=INVALID_HANDLE_VALUE then begin
      List[I].DOSBoxHandle:=0;
      List[I].InavlidDOSBox:=True;
    end else begin
      DuplicateHandle(GetCurrentProcess,DOSBoxHandle,GetCurrentProcess,@NewHandle,0,False,DUPLICATE_SAME_ACCESS);
      List[I].DOSBoxHandle:=NewHandle;
    end;
    break;
  end;

  If Assigned(FOnInfoBarNotify) then FOnInfoBarNotify(self);
end;

procedure TZipManager.RepackData(const Folder, ZipFile: String; const DeleteType : Integer; const AddToZipFile : Boolean);
Var AZipFile, ADestFolder : String;
    ADeleteMode : TDeleteMode;
begin
  AZipFile:=MakeAbsPath(ZipFile,PrgSetup.BaseDir);
  ADestFolder:=MakeAbsPath(Folder,PrgSetup.BaseDir);
  Case DeleteType of
    0,3 : ADeleteMode:=dmNoNoWarning;
    1,4 : ADeleteMode:=dmFilesNoWarning;
    2,5 : ADeleteMode:=dmFolderNoWarning;
    else ADeleteMode:=dmNoNoWarning;
  end;

  if (DeleteType>=3) then begin
    {Delete only}
    DeleteUnpackedFiles(Application.MainForm,ADestFolder,ADeleteMode);
  end else begin
    {Repack and delete}
    If AddToZipFile
      then ZipInfoFormUnit.AddToZipFile(Application.MainForm,AZipFile,ADestFolder,ADeleteMode,GetCompressStrengthFromPrgSetup)
      else CreateZipFile(Application.MainForm,AZipFile,ADestFolder,ADeleteMode,GetCompressStrengthFromPrgSetup);
  end;
end;

procedure TZipManager.TimerWork(Sender: TObject);
Var I,J : Integer;
begin
  Timer.Enabled:=False;
  try
    I:=0;
    while I<length(List) do begin
      If (List[I].DOSBoxHandle<>INVALID_HANDLE_VALUE) and (List[I].InavlidDOSBox or (WaitForSingleObject(List[I].DOSBoxHandle,0)=WAIT_OBJECT_0)) then begin
        For J:=0 to List[I].ZipDrives-1 do RepackData(List[I].Folder[J],List[J].ZipFile[J],List[J].DeleteType[J],List[J].OnlyRepack[J]);
        For J:=I+1 to length(List)-1 do List[J-1]:=List[J];
        SetLength(List,length(List)-1);
        continue;
      end;
      inc(I);
    end;

    If (length(List)=0) and Assigned(FOnInfoBarNotify) then FOnInfoBarNotify(self);
  finally
    Timer.Enabled:=True;
  end;
end;

initialization
  ZipManager:=TZipManager.Create;
finalization
  ZipManager.Free;
end.
