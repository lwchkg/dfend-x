unit DosBoxUnit;
interface

{DEFINE ShowSelectDialogEvenIfOnlyOneCDDrive}

uses Classes, GameDBUnit;

Procedure RunGame(const Game : TGame; const DeleteOnExit : TStringList; const RunSetup : Boolean = False; const DosBoxCommandLine : String =''; const Wait : Boolean = False);
Function RunGameAndGetHandle(const Game : TGame; const DeleteOnExit : TStringList; const RunSetup : Boolean = False; const DosBoxCommandLine : String ='') : THandle;
Procedure RunExtraFile(const Game : TGame; const DeleteOnExit : TStringList; const ExtraFile : Integer);
Procedure RunCommand(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean = False);
Procedure RunCommandAndWait(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean = False);
Function RunCommandAndGetHandle(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean = False) : THandle;
Procedure RunWithCommandline(const Game : TGame; const DeleteOnExit : TStringList; const CommandLine : String; const DisableFullscreen : Boolean = False);
Procedure RunWithCommandlineAndWait(const Game : TGame; const DeleteOnExit : TStringList; const CommandLine : String; const DisableFullscreen : Boolean = False);

Function BuildConfFile(const Game : TGame; const RunSetup : Boolean; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer; const DeleteOnExit : TStringList; const BuildForArchivePackage : Boolean) : TStringList;
Function BuildAutoexec(const Game : TGame; const RunSetup : Boolean; const St : TStringList; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer; const WarnIfWindowsExe, SelectCD : Boolean; const BuildForArchivePackage : Boolean) : Boolean;
Function GetDOSBoxCommandLine(const DOSBoxNr : Integer; const ConfFile : String; const ShowConsole : Integer; const DosBoxCommandLine : String ='') : String;

Function IsWindowsExe(const FileName : String) : Boolean;
Function IsDOSExe(const FileName : String) : Boolean;

var MinimizedAtDOSBoxStart : Boolean = False;

Function ShortName(const LongName : String) : String;
Function LongPath(const ShortPath : String) : String; {also see WinExpandLongPathName} 

implementation

uses Windows, SysUtils, ShellAPI, Forms, Dialogs, ShlObj, Math,
     CommonTools, PrgSetupUnit, PrgConsts, LanguageSetupUnit, GameDBToolsUnit,
     ZipManagerUnit, ScreensaverControlUnit, FullscreenInfoFormUnit,
     DOSBoxCountUnit, DOSBoxShortNameUnit, RunPrgManagerUnit,
     SelectCDDriveToMountFormUnit, SelectCDDriveToMountByDataFormUnit,
     FileNameConvertor, DOSBoxTempUnit, WindowsFileWarningFormUnit, MIDITools,
     HistoryUnit;
                                                                  
var SpeedTestSt : TStringList = nil;
    LastSpeedTestStep : String = '';
    LastSpeedTestStep2 : String = '';
    LastSpeedTestTickCount : Cardinal;
    SpeedTest : Integer =-1;

Function SpeedTestLogFile : String;
begin
  result:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_DESKTOPDIRECTORY)+'D-Fend-Reloaded-DOSBoxStartLog.txt';
end;

Function IsSpeedTest : Boolean;
begin
  if SpeedTest=-1 then begin
    result:=PrgSetup.DOSBoxStartLogging or FileExists(SpeedTestLogFile);
    if result then SpeedTest:=1 else SpeedTest:=0;
  end else begin
    result:=(SpeedTest=1);
  end;
end;

Procedure SpeedTestInfo(const Info : String; const Init : Boolean=False);
begin
  if not IsSpeedTest then exit;

  If Assigned(SpeedTestSt) then begin
    SpeedTestSt.Add(LastSpeedTestStep+': '+IntToStr(GetTickCount-LastSpeedTestTickCount)+'ms');
    If LastSpeedTestStep2<>'' then SpeedTestSt.Add('  '+LastSpeedTestStep2);
    LastSpeedTestStep:=Info;
    LastSpeedTestStep2:='';
    LastSpeedTestTickCount:=GetTickCount;
    exit;
  end;

  LastSpeedTestStep:='';
  LastSpeedTestStep2:='';

  If not Init then exit;

  SpeedTestSt:=TStringList.Create;
  SpeedTestSt.Add(TimeToStr(Now)+' ### Benchmarking DOSBox start ###'+#13);
  LastSpeedTestStep:=Info;
  LastSpeedTestTickCount:=GetTickCount;
end;

Procedure SpeedTestInfoOnly(const Info : String);
begin
  if not IsSpeedTest then exit;

  If Assigned(SpeedTestSt) then begin
    LastSpeedTestStep2:=Info;
  end;
end;

Procedure SpeedTestDone;
Var St : TStringList;
begin
  if not IsSpeedTest then exit;

  If not Assigned(SpeedTestSt) then exit;
  SpeedTestInfo('');
  try
    St:=TStringList.Create;
      If FileExists(SpeedTestLogFile) then begin
        try
          St.LoadFromFile(SpeedTestLogFile);
        finally
        end;
      end;
      St.Add('');
      St.AddStrings(SpeedTestSt);
      St.SaveToFile(SpeedTestLogFile);
  finally
    FreeAndNil(SpeedTestSt);
  end;
end;

Function BoolToStr(const B : Boolean) : String;
begin
  If B then result:='true' else result:='false';
end;

Function ShortName(const LongName : String) : String;
begin
  If PrgSetup.UseShortFolderNames then begin
    SetLength(result,MAX_PATH+10);
    if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
      then result:=LongName
      else SetLength(result,StrLen(PChar(result)));
  end else begin
    result:=LongName;
  end;
end;

Function LongPath(const ShortPath : String) : String;
Var S,T : String;
    I : Integer;
begin
  result:=Copy(ShortPath,1,3);
  S:=ExcludeTrailingPathDelimiter(Copy(ShortPath,4,MaxInt));
  while S<>'' do begin
    I:=Pos('\',S);
    If I=0 then begin T:=S; S:=''; end else begin T:=Copy(S,1,I-1); S:=Copy(S,I+1,MaxInt); end;
    result:=result+WinExpandLongPathName(result,T)+'\';
  end;
end;

{Function LongPath(const Root, ShortPath : String) : String; -> WinExpandLongPathName
Var Rec : TSearchRec;
    I : Integer;
    LongRoot, ShortRoot : String;
begin
  LongRoot:=IncludeTrailingPathDelimiter(Root);
  ShortRoot:=ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(LongRoot)));

  result:=ShortPath;

  I:=FindFirst(LongRoot+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      I:=FindNext(Rec);
      If ExtUpperCase(ShortName(LongRoot+Rec.Name))=ShortRoot+ExtUpperCase(ShortPath) then begin
        result:=Rec.Name; exit;
      end;
    end;
  finally
    FindClose(Rec);
  end;
end;}

Function AllSameDir(const St : TStringList) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  If St.Count<2 then exit; {No benefit if less than 2 files to mount}
  S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(St[0]))));
  For I:=1 to St.Count-1 do if S<>Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(St[I])))) then exit;
  result:=True;
end;

Function MakeDOSBoxPath(Part, Root : String) : String;
Var S : String;
    I : Integer;
begin
  Root:=IncludeTrailingPathDelimiter(Root);
  result:='';
  Part:=ExcludeTrailingPathDelimiter(Part);
  If (Part<>'') and (Part[1]='\') then Part:=Copy(Part,2,MaxInt);

  while Part<>'' do begin
    I:=Pos('\',Part);
    If I=0 then begin S:=Part; Part:=''; end else begin S:=Copy(Part,1,I-1); Part:=Copy(Part,I+1,MaxInt); end;
    S:=WinExpandLongPathName(Root,S);
    result:=result+'\'+DOSBoxShortName(MakeAbsPath(Root,PrgSetup.BaseDir),S);
    Root:=Root+S+'\';
  end;

  If result='' then result:='\';
end;

Function SpecialMultiImgMount(const DriveLetter : String; const Imgs : TStringList; const FreeDriveLetters : String; const MountCommandAdd : String) : String;
Var I : Integer;
    TempDrive : Char;
    Path,S : String;
begin
  TempDrive:='Y';
  For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
  {There must be free drive letters, because there are only 10 mounts}

  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])));

  S:='"'+TempDrive+':\'+DOSBoxShortName(ExtractFilePath(Imgs[0]),ExtractFileName(Imgs[0]))+'"';
  For I:=1 to Imgs.Count-1 do S:=S+' "'+TempDrive+':\'+DOSBoxShortName(ExtractFilePath(Imgs[I]),ExtractFileName(Imgs[I]))+'"';

  result:=
    'mount '+TempDrive+' "'+UnmapDrive(Path,ptMount)+'"'+#13+
    'imgmount '+DriveLetter+' '+S+' '+MountCommandAdd+#13+
    'mount -u '+TempDrive;
end;

Function GetCDDrives : String;
Var C : Char;
begin
  result:='';
  For C:='A' to 'Z' do if GetDriveType(PChar(C+':\'))=DRIVE_CDROM then result:=result+C;
end;

Function SpecialCDDriveMounting(var Folder : String; const DriveLetter : String; const ProfileName : String; const SelectCD : Boolean; var SpecialMountedCDDrives : String) : Boolean;
Var S,T,U,Drives : String;
    I : Integer;
begin
  result:=True;
  S:=Trim(ExtUpperCase(Folder));

  {ASK /  NUMBER:x /  LABEL:x / FILE:x / FOLDER:x}

  If S='ASK' then begin
    Drives:=GetCDDrives;
    If length(Drives)=0 then begin
      If SelectCD then begin
        MessageDlg(Format(LanguageSetup.MessageNoCDDriveMount,[DriveLetter]),mtError,[mbOK],0);
        result:=False;
      end;
      Folder:=''; exit;
    end;
    If {$IFNDEF ShowSelectDialogEvenIfOnlyOneCDDrive} (length(Drives)=1) or {$ENDIF} (not SelectCD) then begin Folder:=Drives[1]+':\'; SpecialMountedCDDrives:=SpecialMountedCDDrives+Drives[1]; exit; end;
    result:=ShowSelectCDDriveToMountDialog(Application.MainForm,Drives,DriveLetter,ProfileName,Folder);
    if result then SpecialMountedCDDrives:=SpecialMountedCDDrives+Folder[1];
    exit;
  end;

  If Pos(':',S)=0 then exit;
  T:=Copy(S,Pos(':',S)+1,MaxInt);
  S:=Copy(S,1,Pos(':',S)-1);

  Drives:=GetCDDrives;
  If length(Drives)=0 then begin
    If SelectCD and (S='LABEL') or (S='FILE') or (S='FOLDER') then begin
      MessageDlg(Format(LanguageSetup.MessageNoCDDriveMount,[DriveLetter]),mtError,[mbOK],0);
      result:=False;
      Folder:=''; exit;
    end;
  end;

  If S='NUMBER' then begin
    If not TryStrToInt(T,I) then I:=1;
    I:=Max(1,Min(length(Drives),I));
    SpecialMountedCDDrives:=SpecialMountedCDDrives+Drives[I];
    Folder:=Drives[I]+':\'; exit;
  end;
  If SelectCD then begin
    If S='LABEL' then begin
      result:=ShowSelectCDDriveToMountByDataDialog(Application.MainForm,mbLabel,T,DriveLetter,ProfileName,U);
      If result then begin Folder:=U+':\'; SpecialMountedCDDrives:=SpecialMountedCDDrives+U; end else Folder:='';
      exit;
    end;
    If S='FILE' then begin
      result:=ShowSelectCDDriveToMountByDataDialog(Application.MainForm,mbFile,T,DriveLetter,ProfileName,U);
      If result then begin Folder:=U+':\'; SpecialMountedCDDrives:=SpecialMountedCDDrives+U; end else Folder:='';
      exit;
    end;
    If S='FOLDER' then begin
      result:=ShowSelectCDDriveToMountByDataDialog(Application.MainForm,mbFolder,T,DriveLetter,ProfileName,U);
      If result then begin Folder:=U+':\'; SpecialMountedCDDrives:=SpecialMountedCDDrives+U; end else Folder:='';
      exit;
    end;
  end;
end;

Function BuildMountData(const ProfString : String; const DOSBoxVersion : Double; var FreeDriveLetters : String; const ProfileName : String; const SelectCD : Boolean; var OK : Boolean; var SpecialMountedCDDrives : String; const BuildForArchivePackage : Boolean) : String;
Procedure MarkDriveUsed(S : String);
begin
  S:=Trim(ExtUpperCase(S)); If length(S)<>1 then exit;
  If (S[1]<'A') or (S[1]>'Z') then exit;
  FreeDriveLetters[Ord(S[1])-Ord('A')+1]:='-';
end;
Var St,St2 : TStringList;
    S,T,U,V : String;
    I : Integer;
begin
  result:=''; OK:=True;

  St:=ValueToList(ProfString);
  St2:=TStringList.Create;
  try
    If St.Count<3 then exit;

    S:=Trim(St[0]);
    T:=Trim(ExtUpperCase(St[1]));
    I:=Pos('$',S);
    While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
    St2.Add(S);
    For I:=0 to St2.Count-1 do begin
      S:=Trim(ExtUpperCase(St2[I]));
      If (T='CDROM') and ((S='ASK') or (Copy(S,1,7)='NUMBER:') or (Copy(S,1,6)='LABEL:') or (Copy(S,1,5)='FILE:') or (Copy(S,1,7)='FOLDER:')) then continue;
      St2[I]:=MakeAbsPath(St2[I],PrgSetup.BaseDir);
    end;
    S:=St2[0];

    {general: RealFolder;Type;Letter;IO;Label;FreeSpace}
    If St.Count=3 then St.Add('false');
    If St.Count=4 then St.Add('');
    If St.Count=5 then St.Add('');


    If T='DRIVE' then begin
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      MarkDriveUsed(St[2]);
      U:=UnmapDrive(ShortName(S),ptMount);
      if BuildForArchivePackage then U:=MakeRelPath(U,PrgDataDir);
      result:='mount '+St[2]+' "'+U+'"';
      If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
    end;

    If T='FLOPPY' then begin
      {RealFolder;FLOPPY;Letter;False;;}
      MarkDriveUsed(St[2]);
      U:=UnmapDrive(ShortName(S),ptMount);
      if BuildForArchivePackage then U:=MakeRelPath(U,PrgDataDir);
      result:='mount '+St[2]+' "'+U+'" -t floppy';
    end;

    If T='CDROM' then begin
      {RealFolder;CDROM;Letter;IO;Label; (ASK /  NUMBER:x /  LABEL:x / FILE:x / FOLDER:x)}
      if not SpecialCDDriveMounting(S,St[2],ProfileName,SelectCD,SpecialMountedCDDrives) then begin OK:=False; exit; end;
      MarkDriveUsed(St[2]);
      U:=UnmapDrive(ShortName(S),ptMount);
      if BuildForArchivePackage then U:=MakeRelPath(U,PrgDataDir);
      result:='mount '+St[2]+' "'+U+'" -t cdrom';
      If Trim(UpperCase(St[3]))='TRUE' then result:=result+' -IOCTL';
      If Trim(UpperCase(St[3]))='NOIOCTL' then result:=result+' -NOIOCTL';
      If Trim(UpperCase(St[3]))='DX' then result:=result+' -IOCTL_DX';
      If Trim(UpperCase(St[3]))='DIO' then result:=result+' -IOCTL_DIO';
      If Trim(UpperCase(St[3]))='MCI' then result:=result+' -IOCTL_MCI';
      If St[4]<>'' then result:=result+' -label '+St[4];
    end;

    If T='FLOPPYIMAGE' then begin
      {ImageFile;FLOPPYIMAGE;Letter;;;}
      If (Trim(St[2])='0') or (Trim(St[2])='1') then U:='none' else U:='fat';
      MarkDriveUsed(St[2]);
      If AllSameDir(St2) then begin
        result:=SpecialMultiImgMount(St[2],St2,FreeDriveLetters,'-t floppy -fs '+U);
      end else begin
        S:='"'+ShortName(St2[0])+'"'; For I:=1 to St2.Count-1 do S:=S+' "'+ShortName(St2[I])+'"';
        result:='imgmount '+St[2]+' '+S+' -t floppy -fs '+U;
      end;
    end;

    If T='CDROMIMAGE' then begin
      {ImageFile;CDROMIMAGE;Letter;;;}
      MarkDriveUsed(St[2]);
      If AllSameDir(St2) then begin
        If DOSBoxVersion>0.73 then begin
          result:=SpecialMultiImgMount(St[2],St2,FreeDriveLetters,'-t cdrom');
        end else begin
          result:=SpecialMultiImgMount(St[2],St2,FreeDriveLetters,'-t iso -fs iso');
        end;
      end else begin
        S:='"'+ShortName(St2[0])+'"'; For I:=1 to St2.Count-1 do S:=S+' "'+ShortName(St2[I])+'"';
        If DOSBoxVersion>0.73 then begin
          result:='imgmount '+St[2]+' '+S+' -t cdrom';
        end else begin
          result:='imgmount '+St[2]+' '+S+' -t iso -fs iso';
        end;
      end;
    end;

    If T='IMAGE' then begin
      {ImageFile;IMAGE;LetterOR23;;;geometry}
      If St.Count>=6 then begin
        If (Trim(St[2])='2') or (Trim(St[2])='3') then U:='none' else U:='fat';
        MarkDriveUsed(St[2]);
        result:='imgmount '+St[2]+' "'+ShortName(S)+'" -t hdd -fs '+U+' -size '+St[5];
      end;
    end;

    If T='PHYSFS' then begin
      {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace}
      If St2.Count=2 then begin
        MarkDriveUsed(St[2]);
        CreateDir(MakeAbsPath(St2[0],PrgSetup.BaseDir));
        U:=UnmapDrive(ShortName(St2[0]),ptMount);
        V:=UnmapDrive(ShortName(St2[1]),ptMount);
        if BuildForArchivePackage then U:=MakeRelPath(U,PrgDataDir);
        if BuildForArchivePackage then V:=MakeRelPath(V,PrgDataDir);
        result:='mount '+St[2]+' "'+U+':'+V+':/"';
        If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
      end;
    end;

    If T='ZIP' then begin
      {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder)}
      If St2.Count=2 then begin
        MarkDriveUsed(St[2]);
        U:=UnmapDrive(ShortName(St2[0]),ptMount);
        if BuildForArchivePackage then U:=MakeRelPath(U,PrgDataDir);
        result:='mount '+St[2]+' "'+U+'"';
        If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
      end;
    end;

  finally
    St.Free;
    St2.Free;
  end;
end;

Procedure TempMountFreeDOSDir(const Game : TGame; FreeDriveLetters : String; var UseDir, Mount, UnMount : String);
Var FreeDOSPath : String;
    I : Integer;
    St : TStringList;
    S : String;
    TempDrive : Char;
begin
  UseDir:=''; Mount:=''; UnMount:='';

  FreeDOSPath:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir));
  If not DirectoryExists(FreeDOSPath) then exit;

  UseDir:='';
  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));
      If ExtUpperCase(Copy(FreeDOSPath,1,length(S)))=ExtUpperCase(S) then begin
        UseDir:=St[2]+':\'+Copy(FreeDOSPath,length(S)+1,MaxInt);
        break;
      end;
    finally
      St.Free;
    end;
  end;
  If UseDir='' then begin
    TempDrive:='Y';
    For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
    {There must be free drive letters, because there are only 10 mounts}

    Mount:='mount '+TempDrive+': "'+UnmapDrive(ShortName(FreeDOSPath),ptMount)+'"';
    UseDir:=''+TempDrive+':\';
    Unmount:='mount -u '+TempDrive;
  end;
end;

Function MakePathShort(const S : String) : String;
Var Temp : String;
begin
  SetLength(Temp,MAX_PATH+10);
  If GetShortPathName(PChar(S),PChar(Temp),MAX_PATH)<>0 then begin
    SetLength(Temp,StrLen(PChar(Temp))); result:=Trim(ExtUpperCase(Temp));
  end else begin
    result:=S;
  end;
end;

Procedure BuildLocalRunCommands(const St : TStringList; const ProgramFile, ProgramParameters : String; const UseLoadFix : Boolean; const LoadFixMemory : Integer; const Use4DOS, UseDOS32A : Boolean; const Game : TGame; const FreeDriveLetters : String; const WarnIfNotReachable : Boolean);
Var T : String;
begin
  T:=MakePathShort(Trim(ExtractFilePath(ProgramFile)));

  If (length(T)>=2) and (T[2]=':') then begin
    St.Add(Copy(T,1,2));
    St.Add('cd\');
    T:=Trim(Copy(T,3,MaxInt));
  end;

  If T<>'' then begin
    If T[1]<>'\' then T:='\'+T;
    if T[length(T)]='\' then SetLength(T,length(T)-1);    
    St.Add('cd '+T);
  end;
end;

Function MountQBasic(const Autoexec : TStringList; const Game : TGame; const FreeDriveLetters : String; var QBasicPathAndFile : String) : Boolean;
Var QBFile,S,T,Path,Drive : String;
    I : Integer;
    St : TStringList;
begin
  result:=False;
  QBasicPathAndFile:='QBasic.exe';

  QBFile:=Trim(PrgSetup.QBasic);
  If (QBFile='') or (not FileExists(QBFile)) then exit;

  T:=MakePathShort(Trim(ExtractFilePath(QBFile)));
  Path:=''; Drive:='';
  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count=3 then St.Add('false');
      If St.Count=4 then St.Add('');
      If St.Count<5 then continue;
      If (Trim(ExtUpperCase(St[1]))<>'DRIVE') and (Trim(ExtUpperCase(St[1]))<>'CDROM') and (Trim(ExtUpperCase(St[1]))<>'FLOPPY') then continue;
      S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));

      If Copy(T,1,length(S))=S then begin
        S:=Copy(T,length(S)+1,MaxInt);
        If (Drive='') or (length(S)<length(Path)) then begin Path:=S; Drive:=St[2]+':'; end;
      end;
    finally
      St.Free;
    end;
  end;
  If Drive='' then begin
    For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin
      Autoexec.Add('mount '+FreeDriveLetters[I]+' '+UnmapDrive(ExtractFilePath(T),ptMount));
      QBasicPathAndFile:=FreeDriveLetters[I]+':\'+ExtractFileName(QBFile);
      break;
    end;
  end else begin
    If (Path<>'') and (Path[1]='\') then Path:=Copy(Path,2,MaxInt);
    QBasicPathAndFile:=IncludeTrailingPathDelimiter(Drive+'\'+Path)+ExtractFileName(QBFile);
  end;

  result:=True;
end;

Function MountUserInterpreter(const Autoexec : TStringList; const Game : TGame; const FreeDriveLetters : String; var InterpreterPathAndFile : String; const InterpreterNr : Integer) : Boolean;
Var InterpreterFile,S,T,Path,Drive : String;
    I : Integer;
    St : TStringList;
begin
  result:=False;

  If InterpreterNr>=PrgSetup.DOSBoxBasedUserInterpretersPrograms.Count then exit;

  InterpreterPathAndFile:=ExtractFileName(PrgSetup.DOSBoxBasedUserInterpretersPrograms[InterpreterNr]);

  InterpreterFile:=Trim(MakeAbsPath(PrgSetup.DOSBoxBasedUserInterpretersPrograms[InterpreterNr],PrgSetup.BaseDir));
  If (InterpreterFile='') or (not FileExists(InterpreterFile)) then exit;

  T:=MakePathShort(Trim(ExtractFilePath(InterpreterFile)));
  Path:=''; Drive:='';
  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count=3 then St.Add('false');
      If St.Count=4 then St.Add('');
      If St.Count<5 then continue;
      If (Trim(ExtUpperCase(St[1]))<>'DRIVE') and (Trim(ExtUpperCase(St[1]))<>'CDROM') and (Trim(ExtUpperCase(St[1]))<>'FLOPPY') then continue;
      S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));

      If Copy(T,1,length(S))=S then begin
        S:=Copy(T,length(S)+1,MaxInt);
        If (Drive='') or (length(S)<length(Path)) then begin Path:=S; Drive:=St[2]+':'; end;
      end;
    finally
      St.Free;
    end;
  end;
  If Drive='' then begin
    For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin
      Autoexec.Add('mount '+FreeDriveLetters[I]+' '+UnmapDrive(ExtractFilePath(T),ptMount));
      InterpreterPathAndFile:=FreeDriveLetters[I]+':\'+ExtractFileName(InterpreterFile);
      break;
    end;
  end else begin
    If (Path<>'') and (Path[1]='\') then Path:=Copy(Path,2,MaxInt);
    InterpreterPathAndFile:=IncludeTrailingPathDelimiter(Drive+'\'+Path)+ExtractFileName(InterpreterFile);
  end;

  result:=True;
end;

Function RunViaUserInterpreter(const ProgramFile : String) : Integer;
Var I,J : Integer;
    Ext : String;
    St : TStringList;
begin
  result:=-1;
  Ext:=Trim(ExtUpperCase(ExtractFileExt(ProgramFile)));
  If (Ext<>'') and (Ext[1]='.') then Ext:=Copy(Ext,2,MaxInt);

  For I:=0 to PrgSetup.DOSBoxBasedUserInterpretersExtensions.Count-1 do begin
    St:=ValueToList(PrgSetup.DOSBoxBasedUserInterpretersExtensions[I]);
    try
      For J:=0 to St.Count-1 do If Trim(ExtUpperCase(St[J]))=Ext then begin result:=I; exit; end;
    finally
      St.Free;
    end;
  end;
end;

Function BuildRunCommands(const St : TStringList; const ProgramFile, ProgramParameters : String; const UseLoadFix : Boolean; const LoadFixMemory : Integer; const Use4DOS, UseDOS32A : Boolean; const Game : TGame; const FreeDriveLetters : String; const WarnIfNotReachable, WarnIfWindowsExe : Boolean) : Boolean;
Var Prefix,S,T,UsePath,Mount,Unmount : String;
    I : Integer;
    St2 : TStringList;
    NoFreeDOS : Boolean;
    Path, Drive, RootPath, RootPathTemp : String;
    B : Boolean;
begin
  result:=True;

  {Find path to FreeDOS and mount it if needed}
  SpeedTestInfo('Find path to FreeDOS and mount it if needed');
  TempMountFreeDOSDir(Game,FreeDriveLetters,UsePath,Mount,Unmount);
  NoFreeDOS:=(UsePath='');
  SpeedTestInfoOnly('FreeDOS path inside DOSBox: '+UsePath+' mount command (only if needed): '+Mount);
  If Use4DOS or UseDOS32A then begin
    If Mount<>'' then St.Add(Mount);
  end;

  S:=Trim(ExtUpperCase(ProgramFile));
  If (Copy(S,1,7)='DOSBOX:') and (length(S)>7) then begin
    {No path to file needed, because file is in image etc. and given path is local to DOSBox directory structure}
    SpeedTestInfo('Build run command for DOSBox local file');
    BuildLocalRunCommands(St,Trim(Copy(Trim(ProgramFile),8,MaxInt)),ProgramParameters,UseLoadFix,LoadFixMemory,Use4DOS,UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable);
  end else begin
    {Find path to file}
    SpeedTestInfo('Find file to run');
    If (Trim(ProgramFile)<>'') and (not FileExists(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))) and WarnIfNotReachable then begin
      Application.Restore;
      MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[MakeAbsPath(ProgramFile,PrgSetup.BaseDir)]),mtError,[mbOK],0);
      result:=false;
      exit;
    end;

    SpeedTestInfo('Windows file check');
    If IsWindowsExe(MakeAbsPath(ProgramFile,PrgSetup.BaseDir)) and WarnIfNotReachable and WarnIfWindowsExe then begin
      If not Game.IgnoreWindowsFileWarnings then begin
        Application.Restore;
        B:=False;
        ShowWindowsFileWarningDialog(Application.MainForm,MakeAbsPath(ProgramFile,PrgSetup.BaseDir),B);
        If B then begin Game.IgnoreWindowsFileWarnings:=True; Game.StoreAllValues; end;
      end;
    end;

    T:=MakePathShort(Trim(ExtractFilePath(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))));

    SpeedTestInfo('Build directory change commands to select program direcotry');
    If (Trim(ProgramFile)<>'') and (T<>'') then begin
      Path:=''; Drive:=''; RootPath:='';
      For I:=0 to Game.NrOfMounts-1 do begin
        St2:=ValueToList(Game.Mount[I]);
        try
          If St2.Count=3 then St2.Add('false');
          If St2.Count=4 then St2.Add('');
          If St2.Count<5 then continue;
          If (Trim(ExtUpperCase(St2[1]))<>'DRIVE') and (Trim(ExtUpperCase(St2[1]))<>'CDROM') and (Trim(ExtUpperCase(St2[1]))<>'FLOPPY') then continue;
          S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St2[0]),PrgSetup.BaseDir));

          If Copy(T,1,length(S))=S then begin
            RootPathTemp:=LongPath(S);
            S:=Copy(T,length(S)+1,MaxInt);
            If (Drive='') or (length(S)<length(Path)) then begin Path:=S; Drive:=St2[2]+':'; RootPath:=RootPathTemp; end;
          end;
        finally
          St2.Free;
        end;
      end;
      If Drive<>'' then begin
        St.Add(Drive);
        St.Add('cd\');
        S:=Path;
        If S<>'' then begin
          If S[1]<>'\' then S:='\'+S;
          S:=MakeDOSBoxPath(S,RootPath);
          St.Add('cd '+S);
        end;
      end else begin
        St.Add('Rem !!! The program file is not reachable via any mounted drive. !!!');
        St.Add('Rem !!! Trying to interpret the path to the file as a DOSBox relative path. !!!');
        BuildLocalRunCommands(St,Trim(ProgramFile),ProgramParameters,UseLoadFix,LoadFixMemory,Use4DOS,UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable);
        If WarnIfNotReachable then begin
          Application.Restore;
          MessageDlg(Format(LanguageSetup.MessageNoMountToReachFolder,[ExtractFilePath(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))]),mtError,[mbOK],0);
          result:=False;
        end;
      end;
    end;
  end;

  If UseLoadFix then Prefix:='loadfix -'+IntToStr(LoadFixMemory)+' ' else Prefix:='';

  SpeedTestInfo('Run via user interpreter check');
  I:=RunViaUserInterpreter(ProgramFile);
  If I>=0 then begin
    SpeedTestInfoOnly('  User interpreter '+IntToStr(I)+' (zero based)');
    {Run via user defined interpreter}
    SpeedTestInfo('Try to mount user interpreter directory');
    SpeedTestInfoOnly('Interpreter: '+S);
    if not MountUserInterpreter(St,Game,FreeDriveLetters,S,I) then begin
      If WarnIfNotReachable then begin
        Application.Restore;
        MessageDlg(Format(LanguageSetup.MessageUserInterpreterNeededToExecuteFile,[PrgSetup.DOSBoxBasedUserInterpretersPrograms[I],ExtractFileName(ProgramFile)]),mtError,[mbOK],0);
      end;
    end;
    SpeedTestInfo('Build run command');
    If PrgSetup.DOSBoxBasedUserInterpretersParameters.Count>I then T:=Trim(PrgSetup.DOSBoxBasedUserInterpretersParameters[I]) else T:='';
    If T='' then T:='%s';
    try T:=Format(T,[ExtractFileName(ProgramFile)]); except T:=Format('%s',[ExtractFileName(ProgramFile)]); end;
    T:=S+' '+T;
  end else begin
    If ExtUpperCase(ExtractFileExt(ProgramFile))='.BAS' then begin
      {Run via QBasic}
      SpeedTestInfo('Try to mount QBasic');
      if not MountQBasic(St,Game,FreeDriveLetters,S) then begin
        If WarnIfNotReachable then begin
          Application.Restore;
          MessageDlg(Format(LanguageSetup.MessageQBasicNeededToExecuteFile,[ExtractFileName(ProgramFile)]),mtError,[mbOK],0);
        end;
      end;
      SpeedTestInfo('Build run command');
      T:=Trim(PrgSetup.QBasicParam); If T='' then T:='/run %s';
      try T:=Format(T,[ExtractFileName(ProgramFile)]); except T:=Format('/run %s',[ExtractFileName(ProgramFile)]); end;
      T:=S+' '+T;
    end else begin
      {Just run in DOSBox}
      SpeedTestInfo('Build run command');
      If (not UseLoadFix) and (not Use4DOS) and (not UseDOS32A) and (Trim(ExtUpperCase(ExtractFileExt(ProgramFile)))='.BAT') then Prefix:='call ';

      If (T<>'') and (Trim(ProgramParameters)<>'') then T:=' '+ProgramParameters else T:='';
      If Copy(Trim(ExtUpperCase(ProgramFile)),1,7)='DOSBOX:' then begin
        S:=ExtractFileName(ProgramFile);
      end else begin
        SpeedTestInfo('Make DOSBox short path name');
        S:=MakeDOSBoxPath(ExtractFileName(ProgramFile),ExtractFilePath(ProgramFile));
        If (S<>'') and (S[1]='\') then S:=Copy(S,2,MaxInt);
      end;
      T:=S+T;

      SpeedTestInfo('Optionally add DOS32A or 4DOS commands');

      If UseDOS32A and (not NoFreeDOS) then begin
        St.Add(UsePath+'DOS32A.EXE '+T);
        SpeedTestInfoOnly('Command: '+UsePath+'DOS32A.EXE '+T);
        exit;
      end;

      If Use4DOS and (not NoFreeDOS) then begin
        If T<>'' then T:=' /C '+T;
        St.Add(UsePath+'4DOS.COM'+T);
        SpeedTestInfoOnly('Command: '+UsePath+'4DOS.COM'+T);
        exit;
      end;
    end;
  end;

  If Game.SecureMode then St.Add('Z:\config.com -securemode > nul');

  St.Add(Prefix+T);
end;

Procedure MultiLineAdd(const St : TStringList; NewLines : String);
Var I : Integer;
begin
  I:=Pos(#13,NewLines);
  while I<>0 do begin
    St.Add(Copy(NewLines,1,I-1)); NewLines:=Copy(NewLines,I+1,MaxInt);
    I:=Pos(#13,NewLines);
  end;
  St.Add(NewLines);
end;

Procedure BuildFloppyBoot(const Autoexec : TStringList; Images : String; const FreeDriveLetters : String; const BuildForArchivePackage : Boolean);
Var Imgs : TStringList;
    I : Integer;
    TempDrive : Char;
    Path,S,T : String;
begin
  Imgs:=TStringList.Create;
  try
    I:=Pos('$',Images);
    While I<>0 do begin Imgs.Add(MakeAbsPath(Copy(Images,1,I-1),PrgSetup.BaseDir)); Images:=Copy(Images,I+1,MaxInt); I:=Pos('$',Images); end;
    Imgs.Add(MakeAbsPath(Images,PrgSetup.BaseDir));

    If AllSameDir(Imgs) then begin
      TempDrive:='Y';
      For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
      {There must be free drive letters, because there are only 10 mounts}

      Path:=IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])));

      S:='"'+TempDrive+':\'+ExtractFileName(ShortName(Imgs[0]))+'"';
      For I:=1 to Imgs.Count-1 do S:=S+' "'+TempDrive+':\'+ExtractFileName(ShortName(Imgs[I]))+'"';

      T:=UnmapDrive(Path,ptMount);
      if BuildForArchivePackage then T:=MakeRelPath(T,PrgDataDir);
      Autoexec.Add('mount '+TempDrive+' "'+T+'"');
      Autoexec.Add('boot '+S);
    end else begin

      S:='"'+IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])))+ExtractFileName(ShortName(Imgs[0]))+'"';
      For I:=1 to Imgs.Count-1 do S:=S+' "'+IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[I])))+ExtractFileName(ShortName(Imgs[I]))+'"';
      Autoexec.Add('boot '+S);
    end;
  finally
    Imgs.Free;
  end;
end;

Procedure AutoMountCDs(const St : TStringList; const Game : TGame; const DOSBoxVersion : Double; var FreeDriveLetters, SpecialMountedCDDrives : String; const BuildForArchivePackage : Boolean);
Var AlreadyMounted,S,T : String;
    I : Integer;
    C,D : Char;
    St2 : TStringList;
    lpSectorsPerCluster,lpBytesPerSector,lpNumberOfFreeClusters,lpTotalNumberOfClusters : Cardinal;
    OK : Boolean;
begin
  {SpecialMountedCDDrives <- mounted by ASK, NUMBER, LABEL, FOLDER or FILE (not detectable my scanning the mount list)}
  AlreadyMounted:=SpecialMountedCDDrives;

  {Check which CD drives are mounted regularly}
  For I:=0 to Game.NrOfMounts do begin
    S:=Game.Mount[I];
    St2:=ValueToList(S);
    try
      If St2.Count<2 then continue;
      If Trim(ExtUpperCase(St2[1]))<>'CDROM' then continue;
      S:=Trim(ExtUpperCase(St2[0]));
      If S='' then continue;
      If (S[1]<'A') or (S[1]>'Z') then continue;
      If length(S)>3 then continue;
      If (length(S)>=2) and (S[2]<>':') then continue;
      If (length(S)>=3) and (S[2]<>'\') then continue;
      AlreadyMounted:=AlreadyMounted+S[1];
    finally
      St2.Free;
    end;
  end;

  {Find CDs and autmount them}
  For C:='C' to 'Z' do begin
    If GetDriveType(PChar(C+':\'))<>DRIVE_CDROM then continue;
    If Pos(C,AlreadyMounted)<>0 then continue;
    if not GetDiskFreeSpace(PChar(C+':\'),lpSectorsPerCluster,lpBytesPerSector,lpNumberOfFreeClusters,lpTotalNumberOfClusters) then continue;
    If lpTotalNumberOfClusters=0 then continue;
    If Pos(C,FreeDriveLetters)>0 then S:=C else begin
      S:='';
      For D:=Chr(ord(C)+1) to 'Y' do If Pos(D,FreeDriveLetters)>0 then begin S:=D; break; end;
      If S='' then For D:='A' to Chr(ord(C)-1) do If Pos(D,FreeDriveLetters)>0 then begin S:=D; break; end;
    end;
    S:=C+':\;CDROM;'+S+';TRUE;;';
    St.Add(BuildMountData(S,DOSBoxVersion,FreeDriveLetters,'',True,OK,T,BuildForArchivePackage)); {"''", "OK" and "T" can be ignored; only for user interactive mounting}
  end;
end;

Function BuildAutoexec(const Game : TGame; const RunSetup : Boolean; const St : TStringList; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer; const WarnIfWindowsExe, SelectCD : Boolean; const BuildForArchivePackage : Boolean) : Boolean;
  Procedure SetVolume(const Channel : String; const Left,Right : Integer);
  begin If (Left<>100) or (Right<>100) then St.Add('mixer '+Channel+' '+IntToStr(Left)+':'+IntToStr(Right)+' /NOSHOW'); end;
Var S,T,U,NumCommands,MouseCommands,UsePath,Mount,UnMount : String;
    I : Integer;
    B : Boolean;
    FreeDriveLetters : String;
    St2 : TStringList;
    DOSBoxNr : Integer;
    OK : Boolean;
    SpecialMountedCDDrives : String;
    DOSBoxVersion : Double;
begin
  result:=True;

  DOSBoxNr:=Max(0,GetDOSBoxNr(Game));
  If DOSBoxNr>=0 then S:=CheckDOSBoxVersion(DOSBoxNr) else S:=CheckDOSBoxVersion(-1,Game.CustomDOSBoxDir);
  If S=''
    then DOSBoxVersion:=MinSupportedDOSBoxVersion
    else try DOSBoxVersion:=StrToFloatEx(S); except DOSBoxVersion:=MinSupportedDOSBoxVersion; end;

  St.Add('');
  St.Add('[autoexec]');
  St.Add('@echo off');

  { Environment variables }


  SpeedTestInfo('Adding environment variables to [autoexec] section of DOSBox conf file');

  St2:=StringToStringList(Game.Environment);
  try
    For I:=0 to St2.Count-1 do If Trim(St2[I])<>'' then St.Add('SET '+St2[I]);
  finally
    St2.Free;
  end;

  { Keyboard layout }

  SpeedTestInfo('Adding keyboard settings to [autoexec] section of DOSBox conf file');

  T:=Trim(ExtUpperCase(Game.KeyboardLayout));
  If (T='') or (T='DEFAULT') then begin
    DOSBoxNr:=Max(0,GetDOSBoxNr(Game));
    T:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].KeyboardLayout));
    If (T='') or (T='DEFAULT') then T:=LanguageSetup.GameKeyboardLayoutDefault;
  end;
  If Pos('(',T)>0 then begin
    S:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',S)>0 then begin S:=Trim(Copy(S,1,Pos(')',S)-1)); If S<>'' then T:=S; end;
  end;

  S:=Trim(ExtUpperCase(Game.Codepage));
  If (S='') or (S='DEFAULT') then begin
    DOSBoxNr:=Max(0,GetDOSBoxNr(Game));
    S:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].Codepage));
    If (S='') or (S='DEFAULT') then S:=LanguageSetup.GameKeyboardCodepageDefault;
  end;
  If Pos('(',S)>0 then begin
    S:=Copy(S,1,Pos('(',S)-1);
  end;

  If ExtUpperCase(T)='NONE' then T:='none'; {DOSBox keyb accepts GR and gr but not NONE}

  If ExtUpperCase(T)='AUTO' then begin
    DOSBoxNr:=Max(0,GetDOSBoxNr(Game));
    T:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].KeyboardLayout));
    If (T='') or (T='DEFAULT') then T:=LanguageSetup.GameKeyboardLayoutDefault;
    If Pos('(',T)>0 then begin
      U:=Copy(T,Pos('(',T)+1,MaxInt);
      If Pos(')',U)>0 then begin U:=Trim(Copy(U,1,Pos(')',U)-1)); If U<>'' then T:=U; end;
    end;
  end;

  St.Add('keyb '+T+' '+S{+' > nul'}); {no "> nul" to display possible error message if layout and codepage do not match}

  { Reported DOS version }

  SpeedTestInfo('Adding reported DOS version settings to [autoexec] section of DOSBox conf file');

  S:=Trim(ExtUpperCase(Game.ReportedDOSVersion));
  If (S<>'') and (S<>'DEFAULT') and (S<>'AUTO') then begin
    If Pos('.',S)<>0 then begin T:=Trim(Copy(S,Pos('.',S)+1,MaxInt)); S:=Trim(Copy(S,1,Pos('.',S)-1)); end else begin T:=''; end;
    St.Add('ver set '+S+' '+T);
  end;

  { Text mode lines }

  SpeedTestInfo('Adding text mode settings to [autoexec] section of DOSBox conf file');

  If PrgSetup.AllowTextModeLineChange then begin
    If Game.TextModeLines=28 then St.Add('Z:\28.COM');
    If Game.TextModeLines=50 then St.Add('Z:\50.COM');
  end;

  { IPX connect }

  SpeedTestInfo('Adding IPX init to [autoexec] section of DOSBox conf file');

  S:=Trim(ExtUpperCase(Game.IPXType));
  If S='CLIENT' then St.Add('IPXNET CONNECT '+Game.IPXAddress+' '+Game.IPXPort);
  If S='SERVER' then St.Add('IPXNET STARTSERVER '+Game.IPXPort);

  { Mounting }

  SpeedTestInfo('Adding mount commands to [autoexec] section of DOSBox conf file');

  FreeDriveLetters:='---DEFGHIJKLMNOPQRSTUVWXY-';
  SpecialMountedCDDrives:=''; {CD drives mounted by ASK, NUMBER, LABEL, FOLDER or FILE -> for AutoMountCDs to avoid double mounting}
  if not Game.AutoexecOverrideMount then begin
    For I:=0 to 9 do begin
      If Game.NrOfMounts>=I+1 then begin
        MultiLineAdd(St,BuildMountData(Game.Mount[I],DOSBoxVersion,FreeDriveLetters,Game.CacheName,SelectCD,OK,SpecialMountedCDDrives,BuildForArchivePackage));
        If not OK then begin result:=False; exit; end;
      end else begin
        break;
      end;
    end;
    If Game.AutoMountCDs then AutoMountCDs(St,Game,DOSBoxVersion,FreeDriveLetters,SpecialMountedCDDrives,BuildForArchivePackage);
  end;

  { Mixer }

  SpeedTestInfo('Adding mixer settings to [autoexec] section of DOSBox conf file');

  SetVolume('MASTER',Game.MixerVolumeMasterLeft,Game.MixerVolumeMasterRight);
  SetVolume('DISNEY',Game.MixerVolumeDisneyLeft,Game.MixerVolumeDisneyRight);
  SetVolume('SPKR',Game.MixerVolumeSpeakerLeft,Game.MixerVolumeSpeakerRight);
  SetVolume('GUS',Game.MixerVolumeGUSLeft,Game.MixerVolumeGUSRight);
  SetVolume('SB',Game.MixerVolumeSBLeft,Game.MixerVolumeSBRight);
  SetVolume('FM',Game.MixerVolumeFMLeft,Game.MixerVolumeFMRight);
  SetVolume('CDAUDIO',Game.MixerVolumeCDLeft,Game.MixerVolumeCDRight);

  { Setting num, caps and scroll lock and CuteMouse }

  SpeedTestInfo('Adding num, caps, scroll and mouse settings to [autoexec] section of DOSBox conf file');

  NumCommands:='';
  S:=Trim(ExtUpperCase(Game.NumLockStatus));
  If (S='ON') or (S='1') or (S='TRUE') then NumCommands:='/N1';
  If (S='OFF') or (S='0') or (S='FALSE') then NumCommands:='/N0';
  S:=Trim(ExtUpperCase(Game.CapsLockStatus));
  If (S='ON') or (S='1') or (S='TRUE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/C1'; end;
  If (S='OFF') or (S='0') or (S='FALSE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/C0'; end;
  S:=Trim(ExtUpperCase(Game.ScrollLockStatus));
  If (S='ON') or (S='1') or (S='TRUE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/S1'; end;
  If (S='OFF') or (S='0') or (S='FALSE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/S0'; end;

  MouseCommands:='';
  If Game.Force2ButtonMouseMode then MouseCommands:='/Y';
  If Game.SwapMouseButtons then begin If MouseCommands<>'' then MouseCommands:=MouseCommands+' '; MouseCommands:=MouseCommands+'/L'; end;

  SpeedTestInfo('Determining how to temporary mount the FreeDOS directory');

  TempMountFreeDOSDir(Game,FreeDriveLetters,UsePath,Mount,UnMount);
  SpeedTestInfoOnly('FreeDOS directory inside DOSBox: '+UsePath+' mount command (only if needed): '+Mount);

  If ((NumCommands<>'') or (MouseCommands<>'')) and (UsePath<>'') then begin
    If Mount<>'' then St.Add(Mount);
    If NumCommands<>'' then St.Add(UsePath+'4dos.com /C Keybd '+NumCommands);
    If MouseCommands<>'' then St.Add(UsePath+'ctmouse '+MouseCommands);
    If UnMount<>'' then St.Add(UnMount);
  end;

  { User defined Autoexec }

  SpeedTestInfo('Adding user defined autoexec lines to [autoexec] section of DOSBox conf file');

  St2:=StringToStringList(Game.Autoexec);
  try
    B:=False;
    If (St2.Count>0) then for I:=0 to Min(St2.Count-1,2) do If ExtUpperCase(St2[I])='ECHO.' then begin B:=True; break; end;
    If not B then St.Add('echo.');
    St.AddStrings(St2);
  finally
    St2.Free;
  end;

  { Run command }

  S:=Trim(Game.AutoexecBootImage);
  If S<>'' then begin
    SpeedTestInfo('Building image boot command');
    If (S='2') or (S='3') then begin
      If S='2' then St.Add('boot -l C') else St.Add('boot -l D');
    end else begin
      BuildFloppyBoot(St,S,FreeDriveLetters,BuildForArchivePackage);
    end;
    SpeedTestInfoOnly('Command: '+St[St.Count-1]);
  end else begin
    If Game.AutoexecOverrideGamestart then begin
      If Game.SecureMode then St.Add('Z:\config.com -securemode > nul');
    end else begin
      SpeedTestInfo('Selecting file to run');
      If RunExtraFile>=0 then begin
        T:=Trim(Game.ExtraPrgFile[RunExtraFile]);
        I:=Pos(';',T); {ExtraPrgFile=Description;PathAndFile}
        If (T='') or (I=0) then begin
          result:=BuildRunCommands(St,Game.GameExe,Game.GameParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,Game.UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end else begin
          T:=Copy(T,I+1,MaxInt);
          result:=BuildRunCommands(St,T,Game.ExtraPrgFileParameter[RunExtraFile],Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,False,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end;
      end else begin
        If RunSetup then begin
          result:=BuildRunCommands(St,Game.SetupExe,Game.SetupParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,False,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end else begin
          result:=BuildRunCommands(St,Game.GameExe,Game.GameParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,Game.UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end;
      end;
    end;
  end;

  { User defined Finalization }

  St2:=StringToStringList(Game.AutoexecFinalization);
  try St.AddStrings(St2); finally St2.Free; end;

  { Conditionally close DOSBox }

  If (S='') and (not Game.AutoexecOverridegamestart) and Game.CloseDosBoxAfterGameExit then begin
    If RunExtraFile>=0 then begin
      St.Add('exit');
    end else begin
      If RunSetup then begin
        If Trim(Game.SetupExe)<>'' then St.Add('exit');
      end else begin
        If Trim(Game.GameExe)<>'' then St.Add('exit');
      end;
    end;
  end;
end;

Function GetPixelShader(const Game : TGame) : String;
Var S,Dir : String;
    I : Integer;
    Rec : TSearchRec;
begin
  result:='none';

  Dir:='';
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxDir));
  If (S='') or (S='DEFAULT') then begin
    Dir:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  end else begin
    For I:=1 to PrgSetup.DOSBoxSettingsCount-1 do If Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[I].Name))=S then begin Dir:=PrgSetup.DOSBoxSettings[I].DosBoxDir; break; end;
  end;
  If Dir='' then Dir:=Game.CustomDOSBoxDir;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(Dir,PrgSetup.BaseDir));

  S:=Trim(ExtUpperCase(Game.PixelShader));
  I:=FindFirst(Dir+'Shaders\*.fx',faAnyFile,Rec);
  try
    While I=0 do begin
      If S=Trim(ExtUpperCase(ChangeFileExt(Rec.Name,''))) then begin result:=Game.PixelShader; exit; end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(rec);
  end;
end;

Function BuildConfFile(const Game : TGame; const RunSetup : Boolean; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer; const DeleteOnExit : TStringList; const BuildForArchivePackage : Boolean) : TStringList;
Var St : TStringList;
    S,T : String;
    DOSBoxNr : Integer;
    DOSBoxVersion : Double;
    I : Integer;
begin
  SpeedTestInfo('Check DOSBox version');
  DOSBoxNr:=Max(0,GetDOSBoxNr(Game));
  If DOSBoxNr>=0 then S:=CheckDOSBoxVersion(DOSBoxNr) else S:=CheckDOSBoxVersion(-1,Game.CustomDOSBoxDir);
  If S=''
    then DOSBoxVersion:=MinSupportedDOSBoxVersion
    else try DOSBoxVersion:=StrToFloatEx(S); except DOSBoxVersion:=MinSupportedDOSBoxVersion; end;
  SpeedTestInfoOnly('DOSBox version: '+FloatToStr(DOSBoxVersion));

  SpeedTestInfo('Build [sdl] section of DOSBox conf file');
  result:=TStringList.Create;

  result.Add('[sdl]');
  result.Add('fullscreen='+BoolToStr(Game.StartFullscreen));
  result.Add('fulldouble='+BoolToStr(Game.UseDoublebuffering));
  result.Add('fullresolution='+Game.FullscreenResolution);
  result.Add('windowresolution='+Game.WindowResolution);
  result.Add('output='+Game.Render);
  result.Add('autolock='+BoolToStr(Game.AutoLockMouse));
  result.Add('sensitivity='+IntToStr(Game.MouseSensitivity));
  result.Add('waitonerror='+BoolToStr(PrgSetup.DOSBoxSettings[DOSBoxNr].WaitOnError));
  result.Add('usescancodes='+BoolToStr(Game.UseScanCodes));
  result.Add('priority='+Game.Priority);
  S:=Trim(Game.CustomKeyMappingFile);
  If (S='') or (ExtUpperCase(S)='DEFAULT') then S:=PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxMapperFile;
  T:=UnmapDrive(MakeAbsPath(S,PrgDataDir),ptMapper);
  if BuildForArchivePackage then T:=MakeRelPath(T,PrgDataDir);
  result.Add('mapperfile='+T);
  If PrgSetup.AllowPixelShader then begin
    SpeedTestInfo('Get pixel shader');
    S:=GetPixelShader(Game);
    If (S<>'') and (ExtUpperCase(Copy(S,length(S)-2,3))<>'.FX') then S:=S+'.fx';
    result.Add('pixelshader='+S);
  end;

  SpeedTestInfo('Build [dosbox] section of DOSBox conf file');
  result.Add('');
  result.Add('[dosbox]');
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxLanguage));
  If S<>'ENGLISH' then begin
    If (S='') or (S='DEFAULT') then S:='' else begin
      T:=Trim(ExtUpperCase(Game.CustomDOSBoxDir));
      If (T='') or (T='DEFAULT') then T:=PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir;
      If FileExists(IncludeTrailingPathDelimiter(T)+S) then S:=IncludeTrailingPathDelimiter(T)+S else begin
        If not FileExists(S) then S:='';
      end;
    end;
    If S='' then S:=PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxLanguage;

    T:=ExtractFileName(S);
    If FileExists(PrgDataDir+LanguageSubDir+'\'+T) then S:=PrgDataDir+LanguageSubDir+'\'+T;
    {Check if language file is on network share (which DOSBox can't handle)}
    If Copy(S,1,2)='\\' then begin
      if Assigned(DeleteOnExit) then begin
        CopyFile(PChar(S),PChar(TempDir+ExtractFileName(S)),False);
        DeleteOnExit.Add(TempDir+ExtractFileName(S));
      end;
      S:=TempDir+ExtractFileName(S);
      T:=UnmapDrive(S,ptDOSBox);
      if BuildForArchivePackage then begin
        T:=MakeRelPath(T,PrgDataDir);
        if BuildForArchivePackage and (Copy(T,2,1)=':') then T:=ExtractFileName(T); {Completly remove path if its not possible to make the path realtive.}
      end;
      result.Add('language='+T);
    end else begin
      T:=UnmapDrive(S,ptDOSBox);
      if BuildForArchivePackage then begin
        T:=MakeRelPath(T,PrgDataDir);
        if BuildForArchivePackage and (Copy(T,2,1)=':') then T:=ExtractFileName(T); {Completly remove path if its not possible to make the path realtive.}
      end;  
      If FileExists(S) then result.Add('language='+T);
    end;
  end;
  S:=Game.VideoCard; T:=Trim(ExtUpperCase((S)));
  If DOSBoxVersion>0.72 then begin
    If T='VGA' then S:='svga_s3';
  end else begin
    If (T='VGAONLY') or (T='SVGA_S3') or (T='SVGA_ET3000') or (T='SVGA_ET4000') or (T='SVGA_PARADISE') or (T='VESA_NOLFB') or (T='VESA_OLDVBE') then S:='vga';
  end;
  result.Add('machine='+S);
  T:=UnmapDrive(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir),ptScreenshot);
  if BuildForArchivePackage then T:=MakeRelPath(T,PrgDataDir);
  result.Add('captures='+T);
  result.Add('memsize='+IntToStr(Game.Memory));
  If PrgSetup.AllowVGAChipsetSettings then begin
    I:=Game.VideoRam;
    if (I mod 1024)<>0 then I:=(I div 1024)+1 else I:=I div 1024; 
    result.Add('vmemsize='+IntToStr(I));
  end;

  result.Add('');
  result.Add('[render]');
  result.Add('frameskip='+IntToStr(Game.FrameSkip));
  result.Add('aspect='+BoolToStr(Game.AspectCorrection));
  result.Add('scaler='+Game.Scale);

  SpeedTestInfo('Build [vga, glide, cpi, midi, sblaster, gus and speaker] sections of DOSBox conf file');

  If PrgSetup.AllowVGAChipsetSettings then begin
    result.Add('');
    result.Add('[vga]');
    result.Add('svgachipset='+Game.VGAChipset);
    result.Add('videoram='+IntToStr(Game.VideoRam));
  end;

  If PrgSetup.AllowGlideSettings then begin
    result.Add('');
    result.Add('[glide]');
    S:=Trim(ExtUpperCase(Game.GlideEmulation));
    If (S='TRUE') or (S='1') then S:='true' else begin
      If (S='FALSE') or (S='0') then S:='false' else S:=Trim(ExtLowerCase(Game.GlideEmulation));
    end;
    result.Add('glide='+S);
    If S<>'false' then begin
      result.Add('grport='+Game.GlidePort);
      result.Add('lfb='+Game.GlideLFB);
    end;
  end;

  result.Add('');
  result.Add('[cpu]');
  result.Add('core='+Game.Core);
  If Trim(Game.CPUType)<>'' then result.Add('cputype='+Game.CPUType);

  If DOSBoxVersion>0.72 then begin
    If TryStrToInt(Game.Cycles,I) then result.Add('cycles=fixed '+Game.Cycles) else result.Add('cycles='+Game.Cycles);
  end else begin
    result.Add('cycles='+Game.Cycles);
  end;
  result.Add('cycleup='+IntToStr(Game.CyclesUp));
  result.Add('cycledown='+IntToStr(Game.CyclesDown));

  result.Add('');
  result.Add('[mixer]');
  result.Add('nosound='+BoolToStr(Game.MixerNosound));
  result.Add('rate='+IntToStr(Game.MixerRate));
  result.Add('blocksize='+IntToStr(Game.MixerBlocksize));
  result.Add('prebuffer='+IntToStr(Game.MixerPrebuffer));

  result.Add('');
  result.Add('[midi]');
  result.Add('mpu401='+Game.MIDIType);
  If DOSBoxVersion>0.72 then begin
    result.Add('mididevice='+Game.MIDIDevice);
    result.Add('midiconfig='+MakeDOSBoxMIDIString(Game.MIDIConfig));
  end else begin
    result.Add('device='+Game.MIDIDevice);
    result.Add('config='+MakeDOSBoxMIDIString(Game.MIDIConfig));
    If ExtUpperCase(Game.MIDIDevice)='MT32' then begin
      result.Add('mt32reverb.mode='+Game.MIDIMT32Mode);
      result.Add('mt32reverb.time='+Game.MIDIMT32Time);
      result.Add('mt32reverb.level='+Game.MIDIMT32Level);
    end;
  end;

  result.Add('');
  result.Add('[sblaster]');
  result.Add('sbtype='+Game.SBType);
  result.Add('sbbase='+Game.SBBase);
  result.Add('irq='+IntToStr(Game.SBIRQ));
  result.Add('dma='+IntToStr(Game.SBDMA));
  result.Add('hdma='+IntToStr(Game.SBHDMA));
  If DOSBoxVersion>0.72
    then result.Add('sbmixer='+BoolToStr(Game.SBMixer))
    else result.Add('mixer='+BoolToStr(Game.SBMixer));
  result.Add('oplmode='+Game.SBOplMode);
  result.Add('oplrate='+IntToStr(Game.SBOplRate));
  If DOSBoxVersion>0.72 then result.Add('oplemu='+Game.SBOplEmu);

  result.Add('');
  result.Add('[gus]');
  result.Add('gus='+BoolToStr(Game.GUS));
  result.Add('gusrate='+IntToStr(Game.GUSRate));
  result.Add('gusbase='+Game.GUSBase);
  If DOSBoxVersion>0.72 then begin
    result.Add('gusirq='+IntToStr(Game.GUSIRQ));
    result.Add('gusdma='+IntToStr(Game.GUSDMA));
  end else begin
    result.Add('irq1='+IntToStr(Game.GUSIRQ));
    result.Add('irq2='+IntToStr(Game.GUSIRQ));
    result.Add('dma1='+IntToStr(Game.GUSDMA));
    result.Add('dma2='+IntToStr(Game.GUSDMA));
  end;
  result.Add('ultradir='+Game.GUSUltraDir);

  result.Add('');
  result.Add('[speaker]');
  result.Add('pcspeaker='+BoolToStr(Game.SpeakerPC));
  result.Add('pcrate='+IntToStr(Game.SpeakerRate));
  result.Add('tandy='+Game.SpeakerTandy);
  result.Add('tandyrate='+IntToStr(Game.SpeakerTandyRate));
  result.Add('disney='+BoolToStr(Game.SpeakerDisney));

  if PrgSetup.AllowInnova then begin
    result.Add('');
    result.Add('[innova]');
    result.Add('innova='+BoolToStr(Game.Innova));
    result.Add('samplerate='+IntToStr(Game.InnovaRate));
    result.Add('sidbase='+Game.InnovaBase);
    result.Add('quality='+IntToStr(Game.InnovaQuality));
  end;

  SpeedTestInfo('Build [dos] section of DOSBox conf file');
  result.Add('');
  result.Add('[dos]');
  result.Add('xms='+BoolToStr(Game.XMS));
  result.Add('ems='+BoolToStr(Game.EMS));
  result.Add('umb='+BoolToStr(Game.UMB));

  T:=Trim(ExtUpperCase(Game.KeyboardLayout));
  If (T='') or (T='DEFAULT') then begin
    DOSBoxNr:=Max(0,GetDOSBoxNr(Game));
    T:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].KeyboardLayout));
    If (T='') or (T='DEFAULT') then T:=LanguageSetup.GameKeyboardLayoutDefault;
  end;
  If Pos('(',T)>0 then begin
    S:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',S)>0 then begin S:=Trim(Copy(S,1,Pos(')',S)-1)); If S<>'' then T:=S; end;
  end;
  If ExtUpperCase(T)='NONE' then T:='none'; {DOSBox keyb accepts GR and gr but not NONE}
  result.Add('keyboardlayout='+T); {setting keyboard layout here and via keyb command in autoexec; if keyb in autoexec fails due to wrong codepade, keyboard layout will be right anyway}  

  {keyboardlayout can't handle layout+codepage -> moved to autoexec as keyb command
  S:=Trim(ExtUpperCase(Game.Codepage));
  If (S='') or (S='DEFAULT') then S:=LanguageSetup.GameKeyboardCodepageDefault;
  result.Add('keyboardlayout='+T+' '+S);}

  SpeedTestInfo('Build [joystick, serial, ipx, printer] section of DOSBox conf file');

  result.Add('');
  result.Add('[joystick]');
  result.Add('joysticktype='+Game.JoystickType);
  result.Add('timed='+BoolToStr(Game.JoystickTimed));
  result.Add('autofire='+BoolToStr(Game.JoystickAutoFire));
  result.Add('swap34='+BoolToStr(Game.JoystickSwap34));
  result.Add('buttonwrap='+BoolToStr(Game.JoystickButtonwrap));

  If PrgSetup.AllowNe2000 then begin
    result.Add('');
    result.Add('[ne2000]');
    result.Add('ne2000='+BoolToStr(Game.NE2000));
    result.Add('nicbase='+Game.NE2000Base);
    result.Add('nicirq='+IntToStr(Game.NE2000IRQ));
    result.Add('macaddr='+Game.NE2000MACAddress);
    result.Add('realnic='+Game.NE2000RealInterface);
  end;

  result.Add('');
  result.Add('[serial]');
  S:=ExtLowerCase(Game.Serial1);
  result.Add('serial1='+S);
  S:=ExtLowerCase(Game.Serial2);
  result.Add('serial2='+S);
  S:=ExtLowerCase(Game.Serial3);
  result.Add('serial3='+S);
  S:=ExtLowerCase(Game.Serial4);
  result.Add('serial4='+S);

  If Game.IPX then begin
    result.Add('');
    result.Add('[ipx]');
    result.Add('ipx=true');
  end;

  If PrgSetup.AllowPrinterSettings then begin
    result.Add('');
    result.Add('[printer]');
    result.Add('printer='+BoolToStr(Game.EnablePrinterEmulation));
    T:=UnmapDrive(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir),ptScreenshot);
    if BuildForArchivePackage then T:=MakeRelPath(T,PrgDataDir);
    result.Add('docpath='+T);
    result.Add('dpi='+IntToStr(Game.PrinterResolution));
    result.Add('width='+IntToStr(Game.PaperWidth));
    result.Add('height='+IntToStr(Game.PaperHeight));
    result.Add('printoutput='+Game.PrinterOutputFormat);
    result.Add('multipage='+BoolToStr(Game.PrinterMultiPage));
  end;

  if not BuildAutoexec(Game,RunSetup,result,WarnIfNotReachable,RunExtraFile,True,True,BuildForArchivePackage) then begin result.Free; result:=nil; exit; end;

  SpeedTestInfo('Add custom settings to DOSBox conf file');

  St:=StringToStringList(Game.CustomSettings);
  try
    if result<>nil then result.AddStrings(St);
  finally
    St.Free;
  end;

  St:=StringToStringList(PrgSetup.DOSBoxSettings[DOSBoxNr].CustomSettings);
  try
    if result<>nil then result.AddStrings(St);
  finally
    St.Free;
  end;
end;

Procedure FindAlternativeDOSBoxFile(var PrgFile : String);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(ChangeFileExt(PrgFile,'*.exe'),faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        PrgFile:=IncludeTrailingPathDelimiter(ExtractFilePath(PrgFile))+Rec.Name;
        exit;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetDOSBoxCommandLine(const DOSBoxNr : Integer; const ConfFile : String; const ShowConsole : Integer; const DosBoxCommandLine : String ='') : String;
Var Add : String;
begin
  Add:='';
  Case ShowConsole of
    0 : Add:=' -NOCONSOLE';
    2 : ; {always show console}
    else {1 :} if PrgSetup.DOSBoxSettings[Max(0,DOSBoxNr)].HideDosBoxConsole then Add:=' -NOCONSOLE';
  End;
  If Trim(PrgSetup.DOSBoxSettings[Max(0,DOSBoxNr)].CommandLineParameters)<>'' then Add:=Add+' '+Trim(PrgSetup.DOSBoxSettings[DOSBoxNr].CommandLineParameters);
  If DosBoxCommandLine<>'' then Add:=Add+' '+DosBoxCommandLine;
  result:='-CONF "'+ConfFile+'"'+Add;
end;

Type TCharArray=Array[0..MaxInt-1] of Char;
     PCharArray=^TCharArray;

Function RunDosBox(const DOSBoxPath : String; const DOSBoxNr : Integer; const ConfFile : String; const FullScreen : Boolean; const ShowConsole : Integer; const asAdmin : Boolean; const DosBoxCommandLine : String ='') : THandle;
Var PrgFile, Params, Env, S : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    I,Size : Integer;
    P : PCharArray;
    Q : Array of Char;
    Waited : Boolean;
begin
  SpeedTestInfo('Building DOSBox command line');
  Params:=GetDOSBoxCommandLine(DOSBoxNr,ConfFile,ShowConsole,DosBoxCommandLine);

  SpeedTestInfo('Searching DOSBox program file');
  PrgFile:=Trim(DOSBoxPath);
  If (PrgFile='') or (ExtUpperCase(PrgFile)='DEFAULT') then PrgFile:=IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir)+DosBoxFileName else begin
    If ExtUpperCase(Copy(PrgFile,length(PrgFile)-3,4))<>'.EXE' then PrgFile:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgFile,PrgSetup.BaseDir))+DosBoxFileName;
  end;
  If not FileExists(PrgFile) then FindAlternativeDOSBoxFile(PrgFile);
  if not FileExists(PrgFile) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindDosBox,[PrgFile]),mtError,[mbOK],0);
    result:=INVALID_HANDLE_VALUE;
    exit;
  end;
  PrgFile:=UnmapDrive(PrgFile,ptDOSBox);

  SpeedTestInfoOnly('DOSBox program file: '+PrgFile);

  If FullScreen then ShowFullscreenInfoDialog(Application.MainForm);

  if asAdmin then begin
    S:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].SDLVideodriver));
    Env:='';
    If S='WINDIB' then Env:='windib';
    If S='DIRECTX' then Env:='directx';
    result:=INVALID_HANDLE_VALUE;
    S:=IncludeTrailingPathDelimiter((ExtractFilePath(PrgFile)));
    ShellExecute(
      Application.MainForm.Handle,
      'open',
      PChar(PrgDir+BinFolder+'\AdminLauncher.exe'),
      PChar('/driver='+Env+' /dir='+S+' /run="'+PrgFile+'" '+Params),
      PChar(S),
      SW_SHOW
    );
    exit;
  end;

  S:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].SDLVideodriver));
  Env:='';
  If S='WINDIB' then Env:='windib';
  If S='DIRECTX' then Env:='directx';
  If Env<>'' then begin
    SpeedTestInfo('Setting up environment variables for DOSBox');
    Env:='SDL_VIDEODRIVER='+Env;
    P:=PCharArray(GetEnvironmentStrings);
    try
      Size:=0;
      For I:=0 to MaxInt-1 do If (P^[I]=#0) and (P^[I+1]=#0) then begin Size:=I+1; break; end;
      SetLength(Q,Size+length(Env)+1+1);
      Move(P^[0],Q[0],Size);
      Move(Env[1],Q[Size],length(Env));
      Q[Size+length(Env)]:=#0;
      Q[Size+length(Env)+1]:=#0;
    finally
      FreeEnvironmentStrings(PAnsiChar(P));
    end;
    SpeedTestInfoOnly('Added '+Env);
    P:=@Q[0];
  end else begin
    P:=nil;
  end;

  SpeedTestInfo('Starting DOSBox');
  SpeedTestInfoOnly('Command: "'+PrgFile+'" '+Params);
  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    lpReserved:=nil;
    lpDesktop:=nil;
    lpTitle:=nil;
    dwFlags:=0;
    cbReserved2:=0;
    lpReserved2:=nil;
  end;

  if not CreateProcess(
    PChar(PrgFile),
    PChar('"'+PrgFile+'" '+Params),
    nil,
    nil,
    False,
    0,
    P,
    PChar(ExtractFilePath(PrgFile)),
    StartupInfo,
    ProcessInformation
  ) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[PrgFile]),mtError,[mbOK],0);
    result:=INVALID_HANDLE_VALUE;
    exit;
  end;
  SpeedTestInfo('DOSBox started');
  If ProcessInformation.hProcess<>INVALID_HANDLE_VALUE then SpeedTestInfoOnly('DOSBox successfully started');

  result:=ProcessInformation.hProcess;
  CloseHandle(ProcessInformation.hThread);

  {ShellExecute(Application.MainForm.Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName),PChar('-CONF "'+ConfFile+'"'+Add),PChar(IncludeTrailingPathDelimiter((ExtractFilePath(ConfFile)))),SW_SHOW);}

  If PrgSetup.DOSBoxSettings[DOSBoxNr].CenterDOSBoxWindow and (not FullScreen) then begin
    SpeedTestInfo('Center DOSBox window');
    Sleep(1000); Waited:=True;
    CenterWindowFromProcessID(ProcessInformation.dwProcessId);
  end else begin
    Waited:=False;
  end;

  If PrgSetup.MinimizeOnDosBoxStart then begin
    If not Waited then Sleep(1000);
    {MinimizedAtDOSBoxStart:=True; -> RunGameInt}
  end;

  DOSBoxCounter.Add(result);
end;

Function RunGameInt(const Game : TGame; const RunSetup : Boolean; const DosBoxCommandLine : String; const DeleteOnExit : TStringList; const RunExtraFile : Integer = -1) : THandle;
Var St,St2 : TStringList;
    T : String;
    ZipRecNr : Integer;
    Error : Boolean;
    DOSBoxNr : Integer;
    AlreadyMinimized : Boolean;
    RunAsAdmin : Boolean;
begin
  result:=INVALID_HANDLE_VALUE;
  AlreadyMinimized:=False;

  SpeedTestInfo('Starting profile '+Game.SetupFile,True);
  SpeedTestInfo('File checksum test');
  If not RunCheck(Game,RunSetup,RunExtraFile) then exit;

  SpeedTestInfo('DOSBox installation selection');
  DOSBoxNr:=GetDOSBoxNr(Game);
  SpeedTestInfoOnly('Selected DOSBox installation number '+IntToStr(DOSBoxNr));

  try
    SpeedTestInfo('Capture folder check');
    If Trim(Game.CaptureFolder)='' then begin
      Game.CaptureFolder:=MakeRelPath(PrgSetup.CaptureDir,PrgSetup.BaseDir);
      Game.StoreAllValues;
    end;
    T:=MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir);
    ForceDirectories(T);
    SpeedTestInfoOnly('Capture folder: '+T);

    St:=BuildConfFile(Game,RunSetup,True,RunExtraFile,DeleteOnExit,false);
    If St=nil then exit;

    try
      try
        SpeedTestInfo('Storing conf file');
        SpeedTestInfoOnly('Conf filename:'+TempDir+DosBoxConfFileName);
        St.SaveToFile(TempDir+DosBoxConfFileName);
      except
        Application.Restore;
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[TempDir+DosBoxConfFileName]),mtError,[mbOK],0);
        exit;
      end;
      If Game.CacheName<>TempDOSBoxName then begin
        SpeedTestInfo('Adding historiy');
        SpeedTestInfoOnly('Game name: '+Game.CacheName);
        History.Add(Game.CacheName);
      end;

      If DOSBoxNr>=0 then T:=MakeAbsPath(PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir,PrgSetup.BaseDir) else T:=Trim(Game.CustomDOSBoxDir);

      SpeedTestInfo('Process zipped drives');
      ZipRecNr:=ZipManager.AddGame(Game,Error);
      If Error then exit;

      SpeedTestInfo('Process run before main file');
      RunPrgManager.RunBeforeExecutionCommand(Game);

      If PrgSetup.MinimizeOnDosBoxStart then begin
        SpeedTestInfo('Minimize main window');
        AlreadyMinimized:=(Application.MainForm.WindowState=wsMinimized);
        Application.Minimize;
      end;

      RunAsAdmin:=False;
      if Game.RunAsAdmin and PrgSetup.OfferRunAsAdmin then begin
        if ZipRecNr<0 then RunAsAdmin:=True else MessageDlg(LanguageSetup.ProfileMountingZipAdminError,mtError,[mbOK],0);
      end;

      result:=RunDosBox(T,Max(0,DOSBoxNr),TempDir+DosBoxConfFileName,Game.StartFullscreen,Game.ShowConsoleWindow,RunAsAdmin,DosBoxCommandLine);

      St2:=TStringList.Create;
      try
        St2.LoadFromFile(Game.SetupFile);
        SpeedTestInfoOnly(#13+#13+'### Content of prof file:'+#13+#13+St2.Text+#13+#13+'### Content of conf file:'+#13+#13+St.Text);
      finally
        St2.Free;
      end;
      SpeedTestDone;

      If ZipRecNr>=0 then ZipManager.ActivateRepackCheck(ZipRecNr,result);
      RunPrgManager.AddCommand(Game,result);
      ScreensaverControl.DOSBoxStarted(result,PrgSetup.DOSBoxSettings[Max(0,DOSBoxNr)].DisableScreensaver);

    finally
      St.Free;
    end;
  finally
    If PrgSetup.MinimizeOnDosBoxStart and (not AlreadyMinimized) then MinimizedAtDOSBoxStart:=True;
  end;
end;

Procedure RunGame(const Game : TGame; const DeleteOnExit : TStringList; const RunSetup : Boolean; const DosBoxCommandLine : String; const Wait : Boolean);
Var DOSBoxHandle : THandle;
    B : Boolean;
begin
  DOSBoxHandle:=RunGameInt(Game,RunSetup,DosBoxCommandLine,DeleteOnExit);
  try
    If Wait then begin
      WaitForSingleObject(DOSBoxHandle,INFINITE);
    end else begin
      B:=(DosBoxCommandLine='');
      If B and (not Game.IgnoreWindowsFileWarnings) then begin
        If RunSetup then begin
          If (Trim(Game.SetupExe)<>'') and (ExtUpperCase(Copy(Trim(Game.SetupExe),1,7))<>'DOSBOX:') then B:=not IsWindowsExe(MakeAbsPath(Game.SetupExe,PrgSetup.BaseDir));
        end else begin
          If (Trim(Game.GameExe)<>'') and (ExtUpperCase(Copy(Trim(Game.GameExe),1,7))<>'DOSBOX:') then B:=not IsWindowsExe(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir));
        end;
      end;
      if B then begin
        LastDOSBoxStartTime:=GetTickCount;
        LastDOSBoxProfile:=Game;
      end;
    end;
  finally
    CloseHandle(DOSBoxHandle);
  end;
end;

Function RunGameAndGetHandle(const Game : TGame; const DeleteOnExit : TStringList; const RunSetup : Boolean = False; const DosBoxCommandLine : String ='') : THandle;
begin
  result:=RunGameInt(Game,RunSetup,DosBoxCommandLine,DeleteOnExit);
end;

Procedure RunExtraFile(const Game : TGame; const DeleteOnExit : TStringList; const ExtraFile : Integer);
Var DOSBoxHandle : THandle;
begin
  DOSBoxHandle:=RunGameInt(Game,False,'',DeleteOnExit,ExtraFile);
  CloseHandle(DOSBoxHandle);
end;

Function RunCommandInt(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean) : THandle;
Var St : TStringList;
    AutoexecSave, FinalizationSave : String;
    FullscreenSave : Boolean;
begin
  FullscreenSave:=Game.StartFullscreen;
  AutoexecSave:=Game.Autoexec;
  FinalizationSave:=Game.AutoexecFinalization;
  try
    St:=StringToStringList(AutoexecSave);
    try
      If Command<>'' then St.Add(Command);
      Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    if DisableFullscreen then Game.StartFullscreen:=False;
    result:=RunGameAndGetHandle(Game,DeleteOnExit,False,'');
  finally
    Game.Autoexec:=AutoexecSave;
    Game.AutoexecFinalization:=FinalizationSave;
    Game.StartFullscreen:=FullscreenSave;
  end;
end;

Procedure RunCommand(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean);
Var DOSBoxHandle : THandle;
begin
  DOSBoxHandle:=RunCommandInt(Game,DeleteOnExit,Command,DisableFullscreen);
  CloseHandle(DOSBoxHandle);
end;

Procedure RunCommandAndWait(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean);
Var DOSBoxHandle : THandle;
begin
  DOSBoxHandle:=RunCommandInt(Game,DeleteOnExit,Command,DisableFullscreen);
  try
    WaitForSingleObject(DOSBoxHandle,INFINITE);
  finally
    CloseHandle(DOSBoxHandle);
  end;
end;

Function RunCommandAndGetHandle(const Game : TGame; const DeleteOnExit : TStringList; const Command : String; const DisableFullscreen : Boolean = False) : THandle;
begin
  result:=RunCommandInt(Game,DeleteOnExit,Command,DisableFullscreen);
end;

Procedure RunWithCommandline(const Game : TGame; const DeleteOnExit : TStringList; const CommandLine : String; const DisableFullscreen : Boolean = False);
Var FullscreenSave : Boolean;
begin
  FullscreenSave:=Game.StartFullscreen;
  try
    if DisableFullscreen then Game.StartFullscreen:=False;
    RunGame(Game,DeleteOnExit,False,CommandLine);
  finally
    Game.StartFullscreen:=FullscreenSave;
  end;
end;

Procedure RunWithCommandlineAndWait(const Game : TGame; const DeleteOnExit : TStringList; const CommandLine : String; const DisableFullscreen : Boolean = False);
Var FullscreenSave : Boolean;
begin
  FullscreenSave:=Game.StartFullscreen;
  try
    if DisableFullscreen then Game.StartFullscreen:=False;
    RunGame(Game,DeleteOnExit,False,CommandLine,True);
  finally
    Game.StartFullscreen:=FullscreenSave;
  end;
end;

Function DeepWindowsCheck(const FSt : TFileStream) : Boolean;
const SearchString='Microsoft Windows';
Var I,J : Integer;
    A : Array[0..$400] of Char;
begin
  result:=False;
  FSt.Seek(0,soBeginning); FSt.ReadBuffer(A,SizeOf(A));
  J:=1;
  For I:=0 to $400 do If A[I]<>SearchString[J] then J:=1 else begin
    inc(J);
    If J=length(SearchString) then begin result:=True; exit; end;
  end;
end;

Function IsDosZipHybridExe(const FileName : String) : Boolean;
begin
  result:=False;
  if ExtUpperCase(ExtractFileName(FileName))<>'DZ.EXE' then exit;
  if not FileExists(ChangeFileExt(FileName,'.DOS')) then exit;
  result:=True;
end;

Function IsWindowsExe(const FileName : String) : Boolean;
Var FSt : TFileStream;
    I : Integer;
    C : Array[0..3] of Char;
    W : Word;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  If Trim(ExtUpperCase(ExtractFileExt(FileName)))<>'.EXE' then exit;
  try FSt:=TFileStream.Create(FileName,fmOpenRead); except exit; end;
  try
    try
      If FSt.Size<4 then exit;
      FSt.Read(C,4);
      If (C[0]<>'M') or (C[1]<>'Z') then exit;
      If $3C>FSt.Size-4 then exit;
      {$O-}
      FSt.Read(W,2);

      {Detect win32 PE header}
      FSt.Seek($3C,soBeginning);
      FSt.Read(I,4);
      If (I<0) or (I>FSt.Size-4) then exit;
      FSt.Seek(I,soBeginning);
      FSt.Read(C,4);
      If (C[0]='P') and (C[1]='E') and (C[2]=#0) and (C[3]=#0) then begin
        if IsDosZipHybridExe(FileName) then begin result:=False; exit; end;
        result:=True;
        exit;
      end;

      {Detect win16 NE header}
      FSt.Seek($3C,soBeginning);
      FSt.Read(W,2);
      If W>FSt.Size-2 then exit;
      FSt.Seek(W,soBeginning);
      FSt.Read(C,2);
      If (C[0]='N') and (C[1]='E') then begin result:=DeepWindowsCheck(FSt); exit; end;
    finally
      FSt.Free;
    end;
  except result:=False; end;
end;

Function IsDOSExe(const FileName : String) : Boolean;
Var FSt : TFileStream;
    I : Integer;
    C : Array[0..3] of Char;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  If Trim(ExtUpperCase(ExtractFileExt(FileName)))<>'.EXE' then exit;
  try FSt:=TFileStream.Create(FileName,fmOpenRead); except exit; end;
  try
    try
      If FSt.Size<4 then exit;
      FSt.Read(C,4);
      If (C[0]<>'M') or (C[1]<>'Z') then exit;
      If $3C>FSt.Size-4 then exit;
      FSt.Seek($3C,soBeginning);
      FSt.Read(I,4);
      If (I<0) or (I>FSt.Size-4) then begin result:=True; exit; end;
      FSt.Seek(I,soBeginning);
      FSt.Read(C,4);
      result:=not ((C[0]='P') and (C[1]='E') and (C[2]=#0) and (C[3]=#0));
    finally
      FSt.Free;
    end;
  except result:=False; end;
end;

end.
