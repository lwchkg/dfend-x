unit DOSBoxTempUnit;
interface

uses GameDBUnit;

Type TTempGame=class
  private
    FNormalMinimizeState : Array[0..2] of Boolean;
    FGame : TGame;
    FTempProf : String;
    Procedure AddFreeDOSToPath;
  public
    Constructor Create(const InitTempGame : Boolean = True);
    Destructor Destroy; override;
    Procedure SetSimpleDefaults; 
    property Game : TGame read FGame;
end;

const TempDOSBoxName='TempDOSBox';

Procedure RunDOSBoxCommandLineOnFolder(const Folder : String);

implementation

uses Classes, SysUtils, PrgSetupUnit, CommonTools, DosBoxUnit;

{ TTempGame }

constructor TTempGame.Create(const InitTempGame : Boolean);
Var DefaultGame : TGame;
begin
  inherited Create;

  FNormalMinimizeState[0]:=PrgSetup.MinimizeOnDosBoxStart;
  FNormalMinimizeState[1]:=PrgSetup.MinimizeOnScummVMStart;
  FNormalMinimizeState[2]:=PrgSetup.MinimizeOnWindowsGameStart;
  PrgSetup.MinimizeOnDosBoxStart:=False;
  PrgSetup.MinimizeOnScummVMStart:=False;
  PrgSetup.MinimizeOnWindowsGameStart:=False;

  If InitTempGame then begin
    FTempProf:=TempDir+TempDOSBoxName+'.prof';
    FGame:=TGame.Create(FTempProf);
    DefaultGame:=TGame.Create(PrgSetup);
    try FGame.AssignFrom(DefaultGame); finally DefaultGame.Free; end;
    AddFreeDOSToPath;
  end else begin
    FGame:=nil;
  end;
end;

destructor TTempGame.Destroy;
begin
  PrgSetup.MinimizeOnDosBoxStart:=FNormalMinimizeState[0];
  PrgSetup.MinimizeOnScummVMStart:=FNormalMinimizeState[1];
  PrgSetup.MinimizeOnWindowsGameStart:=FNormalMinimizeState[2];

  If Assigned(FGame) then begin
    FGame.Free;
    ExtDeleteFile(FTempProf,ftTemp);
  end;

  inherited Destroy;
end;

procedure TTempGame.AddFreeDOSToPath;
Var FreeDOSDir,MountDir,MountDriveLetter,InternFreeDOSPath : String;
    St,St2 : TStringList;
    I,J : Integer;
    S : String;
    Add : Boolean;
begin
  If Trim(PrgSetup.PathToFREEDOS)='' then exit;
  FreeDOSDir:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir));
  If not DirectoryExists(FreeDOSDir) then exit;

  St:=ValueToList(FGame.Mount0);
  try
    If St.Count<3 then exit;
    MountDir:=IncludeTrailingPathDelimiter(MakeAbsPath(St[0],PrgSetup.BaseDir));
    MountDriveLetter:=St[2];
  finally
    St.Free;
  end;

  If not (ExtUpperCase(Copy(FreeDOSDir,1,length(MountDir)))=ExtUpperCase(MountDir)) then exit;

  InternFreeDOSPath:=MountDriveLetter+':\'+Copy(FreeDOSDir,length(MountDir)+1,MaxInt);

  St:=StringToStringList(FGame.Environment);
  try
    For I:=0 to St.Count-1 do begin
      If Pos('=',St[I])=0 then continue;
      If Trim(ExtUpperCase(Copy(St[I],1,Pos('=',St[I])-1)))<>'PATH' then continue;
      St2:=ValueToList(Trim(Copy(St[I],Pos('=',St[I])+1,MaxInt)));
      try
        Add:=True;
        For J:=0 to St2.Count-1 do If ExtUpperCase(St2[J])=ExtUpperCase(InternFreeDOSPath) then begin Add:=False; break; end;
      finally
        St2.Free;
      end;
      If Add then begin
        S:=St[I]; If (S<>'') and (S[length(S)]<>';') then S:=S+';';
        St[I]:=S+InternFreeDOSPath;
      end;
    end;
    FGame.Environment:=StringListToString(St);
  finally
    St.Free;
  end;

end;

procedure TTempGame.SetSimpleDefaults;
begin
  if not Assigned(FGame) then exit;
  FGame.ProfileMode:='DOSBox';
  FGame.Autoexec:='';
  FGame.AutoexecOverridegamestart:=True;
  FGame.AutoexecOverrideMount:=False;
  FGame.AutoexecBootImage:='';
  FGame.StartFullscreen:=False;
  FGame.CustomDOSBoxDir:='';
  FGame.CloseDosBoxAfterGameExit:=True;
end;

Procedure RunDOSBoxCommandLineOnFolder(const Folder : String);
Var Temp : TTempGame;
    S,T : String;
    St : TStringList;
begin
  Temp:=TTempGame.Create;
  try
    S:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
    T:=MakeAbsPath(Folder,PrgSetup.BaseDir);
    Temp.Game.NrOfMounts:=1;
    St:=StringToStringList(Temp.Game.Autoexec);
    St.Add('C:');
    try
      if Copy(ExtUpperCase(T),1,length(S))=ExtUpperCase(S) then begin
        Temp.Game.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;';
        S:=ShortName(S);
        T:=ShortName(T);
        T:=Copy(T,length(S)+1,MaxInt);
        If (T<>'') and (T[length(T)]='\') then T:=Copy(T,1,length(T)-1);
        If (T<>'') and (T[1]='\') then T:=Copy(T,2,MaxInt);
        if (T<>'') then St.Add('cd '+T);
      end else begin
        Temp.Game.Mount0:=MakeRelPath(Folder,PrgSetup.BaseDir,True)+';Drive;C;false;';
      end;
      Temp.Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    RunWithCommandline(Temp.Game,nil,'',true);
  finally
    Temp.Free;
  end;
end;

end.
