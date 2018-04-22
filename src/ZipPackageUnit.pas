unit ZipPackageUnit;
interface

uses Classes, Math, GameDBUnit;

Procedure BuildZipPackage(const AOwner : TComponent; const AGame : TGame; const AFileName : String; const SplitLargeFiles : Boolean);
Function ImportZipPackage(const AOwner : TComponent; const AFileName : String; const AGameDB : TGameDB; const NoDialogIfAutoSetupIsAvailable : Boolean) : TGame;
Function ImportFolder(const AOwner : TComponent; const AFolderName : String; const AGameDB : TGameDB; const NoDialogIfAutoSetupIsAvailable : Boolean) : TGame;

Function AdditionalDataMatching(const Folder : String; const Template : TGame) : Boolean;

Function GetTemplateFromFolderExt(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; const StartableFiles : TStringList = nil) : TStringList;
Function GetTemplateFromFolder(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; var FileToStart : String; const StartableFiles : TStringList = nil) : Integer;

Procedure TempZipFilesStartCleanUp;

Function OnlySubFolderCheck(const Dir : String) : String;

Function CreateGameFromSimpleFolder(Dir : String; const GameDB : TGameDB; const ArchiveFileName : String; const NoDialogIfAutoSetupIsAvailable, DoNotCopyFolder : Boolean) : TGame;

implementation

uses Windows, SysUtils, Forms, Controls, Dialogs, ShellAPI, ShlObj, Messages,
     XMLDoc, XMLIntf, Variants, SevenZipVCL, CommonTools, LanguageSetupUnit,
     GameDBToolsUnit, PrgSetupUnit, PrgConsts, UninstallFormUnit,
     ZipInfoFormUnit, DosBoxUnit, ScummVMUnit, HashCalc,
     ImportSelectTemplateFormUnit, SelectTemplateForZipImportFormUnit,
     InstallationSupportFormUnit, PackageDBToolsUnit, ZipPackageDBGLFormUnit,
     SmallWaitFormUnit;

Function CopyFileWithMsg(const Source, Dest : String; const ProcessMessages, MoveFileToDestDir : Boolean) : Boolean;
begin
  result:=ForceDirectories(ExtractFilePath(Dest));
  If result then begin If FileExists(Dest) then exit; end;
  if result then begin
    If MoveFileToDestDir then begin
      result:=MoveFile(PChar(Source),PChar(Dest));
      If not result then result:=CopyFile(PChar(Source),PChar(Dest),False);
    end else begin
      result:=CopyFile(PChar(Source),PChar(Dest),False);
    end;
  end;
  If ProcessMessages then Application.ProcessMessages;
  if not result then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Source,Dest]),mtError,[mbOK],0);
end;

Function CopyFolderWithMsg(Source, Dest : String; const ProcessMessages, MoveFiles : Boolean; const NewGame : TGame = nil; const IgnoreProfConfInRootDir : Boolean = False) : Boolean;
Var I : Integer;
    Rec : TSearchRec;
    S,T : String;
    B : Boolean;
    StDirs1, StDirs2, StFiles : TStringList;
begin
  result:=False;

  Source:=IncludeTrailingPathDelimiter(Source);
  Dest:=IncludeTrailingPathDelimiter(Dest);

  if not DirectoryExists(Source) then begin result:=True; exit; end;

  If not ForceDirectories(Dest) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dest]),mtError,[mbOK],0);
    exit;
  end;

  StDirs1:=TStringList.Create;
  StDirs2:=TStringList.Create;
  StFiles:=TStringList.Create;
  try
    {Scan for files and folders}
    I:=FindFirst(Source+'*.*',faAnyFile,Rec);
    try
      While I=0 do begin
        If (Rec.Attr and faDirectory)<>0 then begin
          If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
            B:=False;
            If (NewGame<>nil) and DirectoryExists(Dest+Rec.Name) then begin
              {Change path if destination capture or data folder already exists}
              S:=IncludeTrailingPathDelimiter(ExtUpperCase(Dest+Rec.Name));
              If IncludeTrailingPathDelimiter(ExtUpperCase(MakeAbsPath(NewGame.CaptureFolder,PrgSetup.BaseDir)))=S then begin
                S:=IncludeTrailingPathDelimiter(Dest+Rec.Name);
                I:=0;
                While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(IncludeTrailingPathDelimiter(S)) do begin
                  inc(I); S:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(Dest+Rec.Name)+IntToStr(I));
                end;
                StDirs1.Add(Source+Rec.Name); StDirs2.Add(S);
                NewGame.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir,True); NewGame.StoreAllValues;
                B:=True;
              end else begin
                If IncludeTrailingPathDelimiter(ExtUpperCase(MakeAbsPath(NewGame.DataDir,PrgSetup.BaseDir)))=S then begin
                  S:=IncludeTrailingPathDelimiter(Dest+Rec.Name);
                  I:=0;
                  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(IncludeTrailingPathDelimiter(S)) do begin
                    inc(I); S:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(Dest+Rec.Name)+IntToStr(I));
                  end;
                  StDirs1.Add(Source+Rec.Name); StDirs2.Add(S);
                  NewGame.DataDir:=MakeRelPath(S,PrgSetup.BaseDir,True); NewGame.StoreAllValues;
                  B:=True;
                end;
              end;
            end;
            If not B then begin
              StDirs1.Add(Source+Rec.Name); StDirs2.Add(Dest+Rec.Name);
            end;
          end;
        end else begin
          If IgnoreProfConfInRootDir then begin
            T:=Trim(ExtUpperCase(Rec.Name)); S:=ExtractFileExt(T);
            B:=(S<>'.CONF') and (S<>'.PROF') and (T<>'INSTALLREADME.TXT') and (T<>ExtUpperCase(DBGLPackageInfoFile));
          end else B:=True;
          If B then StFiles.Add(Rec.Name);
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    {Copy files}
    For I:=0 to StFiles.Count-1 do If not CopyFileWithMsg(Source+StFiles[I],Dest+StFiles[I],ProcessMessages,MoveFiles) then exit;

    {Copy subfolders}
    For I:=0 to StDirs1.Count-1 do If not CopyFolderWithMsg(StDirs1[I],StDirs2[I],ProcessMessages,MoveFiles,NewGame) then exit;
  finally
    StDirs1.Free;
    StDirs2.Free;
    StFiles.Free;
  end;

  result:=True;
end;

Function CreateInfoFile(const Game : TGame; const Dir : String) : Boolean;
Var St : TStringList;
begin
  result:=False;

  St:=TStringList.Create;
  try
    St.Add('This is a D-Fend Reloaded game package for the game');
    St.Add('"'+Game.CacheName+'".');
    St.Add('');
    St.Add('If you are using D-Fend Reloaded, you can just install this package via');
    St.Add('File|Import|Import zip-file or by just dragging the zip file to the');
    St.Add('D-Fend Reloaded program window.');
    St.Add('');
    St.Add('If you do not have a D-Fend Reloaded installation on your system, you can');
    St.Add('download it here for free:');
    St.Add(DFRHomepage+'Download.html');
    St.Add('');
    If ScummVMMode(Game) then begin
      St.Add('You can also run the game from this package without having D-Fend Reloaded');
      St.Add('installed. All you need is ScummVM (http:/'+'/www.scummvm.org/). You can just use');
      St.Add('the ini file from this folder to run the game inside ScummVM.');
    end;
    if DOSBoxMode(Game) then begin
      St.Add('You can also run the game from this package without having D-Fend Reloaded');
      St.Add('installed. All you need is DOSBox (http:/'+'/www.dosbox.com). You can just use');
      St.Add('the conf file from this folder to run the game inside DOSBox.');
    end;
    St.Add('');
    St.Add('You can find all files needed to run the game in the subfolders of this folder.');
    try
      St.SaveToFile(IncludeTrailingPathDelimiter(Dir)+'InstallReadme.txt');
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[IncludeTrailingPathDelimiter(Dir)+'InstallReadme.txt']),mtError,[mbOK],0);
      exit;
    end;
  finally
    St.Free;
  end;

  result:=True;
end;

Function CopyFilesToTempDir(const Game : TGame; const Dir : String; const ProcessMessages : Boolean) : Boolean;
Var S,T,U,V : String;
    St,Files,Folders : TStringList;
    I : Integer;
begin
  result:=False;

  LoadAndShowSmallWaitForm(LanguageSetup.MenuFileExportBuildZipPackagesWait);
  try

    Game.StoreAllValues;

    {prof file}
    if not CopyFileWithMsg(Game.SetupFile,Dir+ExtractFileName(Game.SetupFile),ProcessMessages,False) then exit;

    {conf or ini file}
    S:=Dir+ChangeFileExt(ExtractFileName(Game.SetupFile),'.conf');
    If DOSBoxMode(Game) then begin
      St:=BuildConfFile(Game,False,False,-1,nil,true);
      If St<>nil then begin
        try
          try St.SaveToFile(S); except MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0); exit; end;
        finally
          St.Free;
        end;
      end;
    end;
    If ScummVMMode(Game) then begin
      St:=BuildScummVMIniFile(Game);
      try
        try St.SaveToFile(S); except MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0); exit; end;
      finally
        St.Free;
      end;
    end;

    {*** SCUMMVM ***}
    If ScummVMMode(Game) then begin

      {ScummVM: Games folder}
      S:=Trim(Game.ScummVMPath);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
      end;

      {ScummVM: Folder as zip file}
      S:=Trim(Game.ScummVMZip);
      If S<>'' then begin
        S:=MakeRelPath(S,PrgSetup.BaseDir);
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        T:=ExtractFilePath(S);
        If (T<>'') and (T[1]='.') then Delete(T,1,1);
        If (T<>'') and (T[1]='\') then Delete(T,1,1);
        If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
        if not CopyFileWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),Dir+T+'\'+ExtractFileName(S),ProcessMessages,False) then exit;
      end;
      S:=Trim(Game.ScummVMSavePath);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
      end;

    end;

    {*** DOSBOX ***}
    if DOSBoxMode(Game) then begin
      {DOSBox: Games folder}
      S:=Trim(Game.GameExe);
      If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
      If S='' then S:=Trim(Game.SetupExe);
      If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(S),PrgSetup.BaseDir));
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
      end;
    end;

    {*** WINDOWS ***}
    if WindowsExeMode(Game) then begin
      S:=Trim(Game.GameExe);
      If S='' then S:=Trim(Game.SetupExe);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(S),PrgSetup.BaseDir));
        If Copy(S,2,2)=':\' then begin
          If ExtUpperCase(IncludeTrailingPathDelimiter(GetSpecialFolder(Application.MainForm.Handle,CSIDL_WINDOWS)))=ExtUpperCase(IncludeTrailingPathDelimiter(S)) then begin
            MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
            result:=False; exit;
          end;
          S:=MakeAbsPath(S,PrgSetup.BaseDir);
          T:=ExcludeTrailingPathDelimiter(S);
          While Pos('\',T)>0 do T:=Copy(T,Pos('\',T)+1,MaxInt);
          U:=ExcludeTrailingPathDelimiter(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir));
          If Copy(U,1,2)='.\' then U:=Copy(U,3,MaxInt) else begin
            While Pos('\',U)>0 do U:=Copy(U,Pos('\',U)+1,MaxInt);
          end;
          T:=IncludeTrailingPathDelimiter(Dir)+U+'\'+T+'\';
          if not CopyFolderWithMsg(S,T,ProcessMessages,False) then exit;
        end else begin
          if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
        end;
      end;
    end;

    {Screenshots}
    S:=Trim(Game.CaptureFolder);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
    end;

    {Icon}
    S:=MakeAbsIconName(Game.Icon);
    If (S<>'') and FileExists(S) then begin
      If ExtractFilePath(Game.Icon)='' then begin
        if not CopyFileWithMsg(S,Dir+IconsSubDir+'\'+Trim(Game.Icon),ProcessMessages,False) then exit;
      end else begin
        S:=MakeRelPath(S,PrgSetup.BaseDir);
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        T:=ExtractFilePath(S);
        If (T<>'') and (T[1]='.') then Delete(T,1,1);
        If (T<>'') and (T[1]='\') then Delete(T,1,1);
        If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
        if not CopyFileWithMsg(MakeAbsIconName(Game.Icon),Dir+T+'\'+ExtractFileName(Game.Icon),ProcessMessages,False) then exit;
      end;
    end;

    {Game data files}
    S:=Trim(Game.DataDir);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
    end;

    {Extra files}
    S:=Trim(Game.ExtraFiles);
    If S<>'' then begin
      St:=ValueToList(S);
      try
        For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
          S:=MakeRelPath(St[I],PrgSetup.BaseDir);
          If Copy(S,2,2)=':\' then begin
            If (not WindowsExeMode(Game)) or (ExtUpperCase(IncludeTrailingPathDelimiter(GetSpecialFolder(Application.MainForm.Handle,CSIDL_WINDOWS)))=ExtUpperCase(IncludeTrailingPathDelimiter(S))) then begin
              MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
              result:=False; exit;
            end;
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            V:=ExtractFileName(S); S:=ExtractFilePath(S);
            T:=ExcludeTrailingPathDelimiter(S);
            While Pos('\',T)>0 do T:=Copy(T,Pos('\',T)+1,MaxInt);
            T:=IncludeTrailingPathDelimiter(Dir)+T+'\';
            if not CopyFileWithMsg(IncludeTrailingPathDelimiter(S)+V,IncludeTrailingPathDelimiter(T)+V,ProcessMessages,False) then exit;
          end else begin
            T:=ExtractFilePath(S);
            If (T<>'') and (T[1]='.') then Delete(T,1,1);
            If (T<>'') and (T[1]='\') then Delete(T,1,1);
            If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
            if not CopyFileWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),Dir+T+'\'+ExtractFileName(S),ProcessMessages,False) then exit;
          end;
        end;
      finally
        St.Free;
      end;
    end;

    {Extra folders}
    S:=Trim(Game.ExtraDirs);
    If S<>'' then begin
      St:=ValueToList(S);
      try
        For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
          S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(St[I]),PrgSetup.BaseDir,True));
          If Copy(S,2,2)=':\' then begin
            If (not WindowsExeMode(Game)) or (ExtUpperCase(IncludeTrailingPathDelimiter(GetSpecialFolder(Application.MainForm.Handle,CSIDL_WINDOWS)))=ExtUpperCase(IncludeTrailingPathDelimiter(S))) then begin
              MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
              result:=False; exit;
            end;
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            T:=ExcludeTrailingPathDelimiter(S);
            While Pos('\',T)>0 do T:=Copy(T,Pos('\',T)+1,MaxInt);
            T:=IncludeTrailingPathDelimiter(Dir)+T+'\';
            if not CopyFolderWithMsg(S,T,ProcessMessages,False) then exit;
          end else begin
            if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
          end;
        end;
      finally
        St.Free;
      end;
    end;

    {Drives (images and zip files)}
    FileAndFoldersFromDrives(Game,Files,Folders);
    try
      For I:=0 to Files.Count-1 do begin
        S:=MakeRelPath(Files[I],PrgSetup.BaseDir);
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        T:=ExtractFilePath(S);
        If (T<>'') and (T[1]='.') then Delete(T,1,1);
        If (T<>'') and (T[1]='\') then Delete(T,1,1);
        If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
        if not CopyFileWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),Dir+T+'\'+ExtractFileName(S),ProcessMessages,False) then exit;
      end;
      For I:=0 to Folders.Count-1 do begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(Folders[I]),PrgSetup.BaseDir,True));
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir),ProcessMessages,False) then exit;
      end;
    finally
      Files.Free;
      Folders.Free;
    end;

    CreateInfoFile(Game, Dir);
  finally
    FreeSmallWaitForm;
  end;

  result:=True;
end;

Procedure SplitLargeFile(AFileName : String);
const BufferSize=2*1024*1024;
Var Input,Output : TFileStream;
    P : Pointer;
    Count, Nr : Integer;
begin
  if not FileExists(AFileName) then exit;

  LoadAndShowSmallWaitForm(LanguageSetup.MenuFileExportBuildZipPackagesSplit);
  try
    GetMem(P,BufferSize);
    try
      Input:=TFileStream.Create(AFileName,fmOpenRead);
      try
        Nr:=1; Output:=TFileStream.Create(AFileName+'.part'+IntToStr(Nr),fmCreate);
        try
          While Input.Position<Input.Size do begin
            Count:=Min(PackageMaxFileSize-Output.Size,Min(Input.Size-Input.Position,BufferSize));
            If Count>0 then begin
              Input.ReadBuffer(P^,Count);
              Output.WriteBuffer(P^,Count);
            end;
            If Output.Size=PackageMaxFileSize then begin
              FreeAndNil(Output);
              Inc(Nr); Output:=TFileStream.Create(AFileName+'.part'+IntToStr(Nr),fmCreate);
            end;
          end;
        finally
          Output.Free;
        end;
      finally
        Input.Free;
      end;
    finally
      FreeMem(P);
    end;

    DeleteFile(AFileName);
  finally
    FreeSmallWaitForm;
  end;
end;

Procedure BuildZipPackage(const AOwner : TComponent; const AGame : TGame; const AFileName : String; const SplitLargeFiles : Boolean);
Var Temp : String;
    Msg : tagMSG;
    B : Boolean;
begin
  If WindowsExeMode(AGame) and (not PrgSetup.AllowPackingWindowsGames) then exit;

  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
  If not ForceDirectories(Temp) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Temp]),mtError,[mbOK],0);
    exit;
  end;

  B:=False;
  If Application.MainForm<>nil then begin
    B:=Application.MainForm.Enabled;
   Application.MainForm.Enabled:=False;
  end;
  try
    If CopyFilesToTempDir(AGame,Temp,True) then begin
      CreateZipFile(AOwner,AFileName,Temp,dmNo,GetCompressStrengthFromPrgSetup);
      If SplitLargeFiles and (GetFileSize(AFileName)>PackageMaxFileSize) then SplitLargeFile(AFileName);
    end;
  finally
    If Application.MainForm<>nil then begin
      While PeekMessage(Msg,Application.MainForm.Handle,WM_INPUT,WM_INPUT,1) do ;
      Application.MainForm.Enabled:=B;
    end;
  end;

  ChDir(GetSpecialFolder(Application.MainForm.Handle,CSIDL_DESKTOPDIRECTORY));
  ExtDeleteFolder(Temp,ftTemp);
end;

Function GetProfFileName(const Dir : String) : String;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:='';

  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.prof',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then result:=IncludeTrailingPathDelimiter(Dir)+Rec.Name;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetPrgFilesFromFolder(Folder : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
begin
  Folder:=IncludeTrailingPathDelimiter(Folder);

  result:=TStringList.Create;

  I:=FindFirst(Folder+'*.exe',faAnyFile,Rec);
  try
    While I=0 do begin
      If (ExtUpperCase(Rec.Name)<>'DOS4GW.EXE') and (ExtUpperCase(Copy(Rec.Name,1,6))<>'README') then result.Add(Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Folder+'*.com',faAnyFile,Rec);
  try
    While I=0 do begin
      If ExtUpperCase(Copy(Rec.Name,1,6))<>'README' then result.Add(Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Folder+'*.bat',faAnyFile,Rec);
  try
    While I=0 do begin
      If ExtUpperCase(Copy(Rec.Name,1,6))<>'README' then result.Add(Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure RatePrgFiles(const Files : TStringList);
Var I,J : Integer;
    S : String;
begin
  For I:=0 to Files.Count-1 do begin
    S:=ExtUpperCase(Files[I]);
    J:=0;
    If Copy(S,1,5)='GAME.' then J:=10;
    If Copy(S,1,6)='SETUP.' then J:=-10;
    If S='RUNME.BAT' then J:=20;
    If S='RUN.BAT' then J:=20;
    If (J=0) and (Copy(S,length(S)-3,4)='.BAT') then J:=1;
    Files.Objects[I]:=Pointer(J);
  end;
end;

Function AdditionalDataMatching(const Folder : String; const Template : TGame) : Boolean;
Var I : Integer;
    F,C : String;
    NotMatching : Boolean;
begin
  result:=False; NotMatching:=False;
  For I:=1 to 5 do begin
    Case I of
      1 : begin F:=Template.AddtionalChecksumFile1; C:=Template.AddtionalChecksumFile1Checksum; end;
      2 : begin F:=Template.AddtionalChecksumFile2; C:=Template.AddtionalChecksumFile2Checksum; end;
      3 : begin F:=Template.AddtionalChecksumFile3; C:=Template.AddtionalChecksumFile3Checksum; end;
      4 : begin F:=Template.AddtionalChecksumFile4; C:=Template.AddtionalChecksumFile4Checksum; end;
      5 : begin F:=Template.AddtionalChecksumFile5; C:=Template.AddtionalChecksumFile5Checksum; end;
    End;
    If F='' then continue;
    If FileExists(Folder+F) then begin
      If GetMD5Sum(Folder+F,False)=C then result:=True else NotMatching:=True;
    end;
  end;
  if NotMatching then result:=False;
end;

Function GetTemplateFromFolderExt(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; const StartableFiles : TStringList) : TStringList;
Var PrgFiles : TStringList;
    I,J,LastLevel,NewLevel : Integer;
    GameCheckSum,S: String;
    MatchByAdditionalData : TList;
    B,Delete : Boolean;
begin
  result:=TStringList.Create;

  Folder:=IncludeTrailingPathDelimiter(Folder);

  PrgFiles:=GetPrgFilesFromFolder(Folder);
  try
    RatePrgFiles(PrgFiles);
    If StartableFiles<>nil then begin StartableFiles.Clear; StartableFiles.AddStrings(PrgFiles); end;

    {Find all matching auto setup templates}
    LastLevel:=1000; NewLevel:=-1;
    repeat
      For I:=0 to PrgFiles.Count-1 do begin J:=Integer(PrgFiles.Objects[I]); If (J<LastLevel) and (J>NewLevel) then NewLevel:=J; end;
      If NewLevel=-1 then break;

      For I:=0 to PrgFiles.Count-1 do If Integer(PrgFiles.Objects[I])=NewLevel then begin
        GameCheckSum:=GetMD5Sum(Folder+PrgFiles[I],False);
        For J:=0 to AutoSetupDB.Count-1 do
          If (Trim(ExtUpperCase(AutoSetupDB[J].GameExe))=Trim(ExtUpperCase(PrgFiles[I]))) and (AutoSetupDB[J].GameExeMD5<>'') and (AutoSetupDB[J].GameExeMD5=GameCheckSum) then begin
          result.AddObject(PrgFiles[I],TObject(J));
        end;
      end;
      LastLevel:=NewLevel; NewLevel:=-1;
    until False;

    {If there is more than one, use additional checksums}
    If result.Count>1 then begin
      MatchByAdditionalData:=TList.Create;
      try
        B:=False;
        For I:=0 to result.Count-1 do If AdditionalDataMatching(Folder,AutoSetupDB[Integer(result.Objects[I])]) then begin
          MatchByAdditionalData.Add(Pointer(1)); B:=True;
        end else begin
          MatchByAdditionalData.Add(Pointer(0));
        end;
        If B then begin
          I:=0;
          While I<result.Count do if Integer(MatchByAdditionalData[I])=0 then begin
            {Only delete sams PrgFiles records}
            Delete:=False;
            S:=result[I];
            For J:=0 to result.Count-1 do If I<>J then if (result[J]=S) and (Integer(MatchByAdditionalData[I])<>0) then begin
              Delete:=True; break;
            end;
            if Delete then begin
              result.Delete(I);
              MatchByAdditionalData.Delete(I);
            end else begin
              inc(I);
            end;
          end else begin
            inc(I);
          end;
        end;
      finally
        MatchByAdditionalData.Free;
      end;
    end;
  finally
    PrgFiles.Free;
  end;
end;

Function GetTemplateFromFolder(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; var FileToStart : String; const StartableFiles : TStringList) : Integer;
Var MatchingTemplates,PrgFiles : TStringList;
    I,J,NewLevel : Integer;
begin
  result:=-1;

  PrgFiles:=TStringList.Create;
  try
    MatchingTemplates:=GetTemplateFromFolderExt(IsFolderScan,Folder,AutoSetupDB,PrgFiles);
    try
      If StartableFiles<>nil then begin StartableFiles.Clear; StartableFiles.AddStrings(PrgFiles); end;

      {If there is still more than one, let the user select the template to use}
      If MatchingTemplates.Count>0 then begin
        If IsFolderScan then begin
          J:=ShowSelectTemplateDialog(Application.MainForm,Folder,AutoSetupDB,MatchingTemplates);
        end else begin
          J:=ShowSelectTemplateDialog(Application.MainForm,'',AutoSetupDB,MatchingTemplates);
        end;
        If J>=0 then begin
          result:=Integer(MatchingTemplates.Objects[J]);
          FileToStart:=MatchingTemplates[J];
        end else begin
          result:=-2;
        end;
        exit;
      end;

      {Use defalt template on highest ranked PrgFile}
      NewLevel:=-1;
      For I:=0 to PrgFiles.Count-1 do begin
        J:=Integer(PrgFiles.Objects[I]);
        If (J>NewLevel) then begin NewLevel:=J; FileToStart:=PrgFiles[I] end;
      end;
    finally
      MatchingTemplates.Free;
    end;
  finally
    PrgFiles.Free;
  end;
end;

Function GetFolderForGame(const GameDir : String; const NewGameFolderSuggestion : String) : String;
Var I : Integer;
begin
  If NewGameFolderSuggestion='' then result:='Game' else result:=NewGameFolderSuggestion;

  If (not DirectoryExists(GameDir+result)) or PrgSetup.IgnoreDirectoryCollisions then exit;

  I:=1;
  repeat
    If not DirectoryExists(GameDir+result+IntToStr(I)) then begin result:=result+IntToStr(I); exit; end;
    inc(I);
  until False;
end;

Function OnlySubFolderCheck(const Dir : String) : String;
Var Rec : TSearchRec;
    I,Files,Folders : Integer;
    SubFolder : String;
begin
  result:=Dir;

  Files:=0; Folders:=0; SubFolder:='';
  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then inc(Files) else begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') then begin inc(Folders); SubFolder:=Rec.Name; end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If (Files=0) and (Folders=1) and (SubFolder<>'') then begin
    result:=IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Dir)+SubFolder);
    result:=OnlySubFolderCheck(result);
  end;
end;

Function AddGameFromSimpleFolder(Dir : String; const GameDB, TemplateDB, AutoSetupDB : TGameDB; const ProfileName, ProfileFolder, FileToStart, SetupFileToStart : String; const TemplateNr : Integer; const DoNotCopyFolder, MoveFiles : Boolean) : TGame;
const FileExts : Array[0..5] of String = ('ico','png','jpeg','jpg','gif','bmp');
Var GameDir,NewGameFolder,S : String;
    I,J : Integer;
    Rec : TSearchRec;
    G : TGame;
    B : Boolean;
    Msg : tagMSG;
begin
  result:=nil;

  {Create folder for new game}
  GameDir:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
  If DoNotCopyFolder then begin
    S:=ExtUpperCase(GameDir);
    If ExtUpperCase(Copy(Dir,1,length(S)))=S then begin
      NewGameFolder:=Copy(Dir,length(S)+1,MaxInt);
      If (length(NewGameFolder)>0) and (NewGameFolder[length(NewGameFolder)]='\') then SetLength(NewGameFolder,length(NewGameFolder)-1);
    end else begin
      S:=Dir;
      If (length(S)>0) and (S[length(S)]='\') then SetLength(S,length(S)-1);
      I:=Pos('\',S); While I>0 do begin S:=Copy(S,I+1,MaxInt); I:=Pos('\',S); end;
      NewGameFolder:=S;
    end;
  end else begin
    NewGameFolder:=GetFolderForGame(GameDir,ProfileFolder);
    ForceDirectories(GameDir+NewGameFolder);
    B:=False;
    If Application.MainForm<>nil then begin
      B:=Application.MainForm.Enabled;
     Application.MainForm.Enabled:=False;
    end;
    try
      if not CopyFolderWithMsg(Dir,GameDir+NewGameFolder,True,MoveFiles) then exit;
    finally
      If Application.MainForm<>nil then begin
        While PeekMessage(Msg,Application.MainForm.Handle,WM_INPUT,WM_INPUT,1) do ;
        Application.MainForm.Enabled:=B;
      end;
    end;
  end;

  {Create game DB record}
  I:=GameDB.Add(ProfileName); result:=GameDB[I];
  If TemplateNr<0 then begin
    If TemplateNr=-1 then begin
      G:=TGame.Create(PrgSetup); try result.AssignFrom(G); finally G.Free; end;
    end else begin
      result.AssignFrom(TemplateDB[-TemplateNr-2]);
    end;
  end else begin
    GameDB[I].AssignFrom(AutoSetupDB[TemplateNr]);
  end;
  result.ProfileMode:='DOSBox';
  result.Name:=ProfileName;
  result.GameExe:=MakeRelPath(GameDir+NewGameFolder+'\'+FileToStart,PrgSetup.BaseDir);
  result.GameExeMD5:=GetMD5Sum(MakeAbsPath(result.GameExe,PrgSetup.BaseDir),False);
  If Trim(SetupFileToStart)<>'' then begin
    result.SetupExe:=MakeRelPath(GameDir+NewGameFolder+'\'+SetupFileToStart,PrgSetup.BaseDir);
    result.SetupExeMD5:=GetMD5Sum(MakeAbsPath(result.SetupExe,PrgSetup.BaseDir),False);
  end else begin
    result.SetupExe:='';
    result.SetupExeMD5:='';
  end;

  {Remove icon record if icon file does not exist}
  If not FileExists(MakeAbsIconName(result.Icon)) then result.Icon:='';

  {Look for icons in game folder}
  If result.Icon='' then For I:=Low(FileExts) to High(FileExts) do begin
    J:=FindFirst(GameDir+NewGameFolder+'\*.'+FileExts[I],faAnyFile,Rec);
    try
      If J=0 then begin
        result.Icon:=MakeRelPath(GameDir+NewGameFolder+'\'+Rec.Name,PrgSetup.BaseDir);
        break;
      end;
    finally
      FindClose(Rec);
    end;
  end;

  {Set capture directory}
  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(result.CacheName)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    inc(I); S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(result.CacheName)+IntToStr(I)+'\';
  end;
  result.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
  ForceDirectories(MakeAbsPath(result.CaptureFolder,PrgSetup.BaseDir));

  result.StoreAllValues;
  result.LoadCache;
end;

Function CreateGameFromSimpleFolder(Dir : String; const GameDB : TGameDB; const ArchiveFileName : String; const NoDialogIfAutoSetupIsAvailable, DoNotCopyFolder : Boolean) : TGame;
Var AutoSetupDB,TemplateDB : TGameDB;
    StartableFiles, AutoSetup : TStringList;
    Nr : Integer;
    ProfileName,FileToStart,SetupFileToStart,ProfileFolder : String;
    UseInstallSupport : Boolean;
    AlternateProfileNameSource, OrigDir : String;
begin
  result:=nil;

  {If folder has only got some subfolder, use this}
  OrigDir:=Dir;
  Dir:=OnlySubFolderCheck(Dir);

  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  StartableFiles:=TStringList.Create;
  try
    AutoSetup:=GetTemplateFromFolderExt(False,Dir,AutoSetupDB,StartableFiles);
    If StartableFiles.Count=0 then begin
      If ArchiveFileName=''
        then MessageDlg(LanguageSetup.MessageFolderImportError,mtError,[mbOK],0)
        else MessageDlg(LanguageSetup.MessageZipImportError,mtError,[mbOK],0);
      exit;
    end;
    try
      TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
      try
        If ArchiveFileName<>'' then AlternateProfileNameSource:='' else begin
          AlternateProfileNameSource:=OrigDir;
          If (length(AlternateProfileNameSource)>0) and (AlternateProfileNameSource[length(AlternateProfileNameSource)]='\') then SetLength(AlternateProfileNameSource,length(AlternateProfileNameSource)-1);
          While Pos('\',AlternateProfileNameSource)>0 do AlternateProfileNameSource:=Copy(AlternateProfileNameSource,Pos('\',AlternateProfileNameSource)+1,MaxInt);
        end;
        If not ShowSelectTemplateForZipImportDialog(Application.MainForm,AutoSetupDB,TemplateDB,StartableFiles,AutoSetup,ArchiveFileName,AlternateProfileNameSource,Dir,ProfileName,FileToStart,SetupFileToStart,ProfileFolder,Nr,NoDialogIfAutoSetupIsAvailable,DoNotCopyFolder,UseInstallSupport) then exit;
        If UseInstallSupport then begin
          If ArchiveFileName=''
            then result:=RunInstallationFromFolder(Application.MainForm,GameDB,Dir)
            else result:=RunInstallationFromZipFile(Application.MainForm,GameDB,ArchiveFileName,Dir);
        end else begin
          result:=AddGameFromSimpleFolder(Dir,GameDB,TemplateDB,AutoSetupDB,ProfileName,ProfileFolder,FileToStart,SetupFileToStart,Nr,DoNotCopyFolder,ArchiveFileName<>'');
        end;
      finally
        TemplateDB.Free;
      end;
    finally
      AutoSetup.Free;
    end;
  finally
    AutoSetupDB.Free;
    StartableFiles.Free;
  end;
end;

Function ProfileExistingCheck(const GameDB : TGameDB; const TempProfFile : String) : Boolean;
Var TempProf : TGame;
    I : Integer;
begin
  result:=False;

  TempProf:=TGame.Create(TempProfFile);
  try
    TempProf.StoreConfigOnExit:=False;
    I:=GameDB.IndexOf(TempProf.CacheName);
    If I<0 then begin result:=True; exit; end;
    Case MessageDlg(Format(LanguageSetup.MessageZipImportDuplicateWarning,[TempProf.CacheName]),mtWarning,[mbYes,mbNo,mbCancel],0) of
      mrYes : result:=UninstallGame(Application.MainForm,GameDB,GameDB[I]);
      mrNo : result:=True;
      mrCancel : {nothing, keep result:=False;};
    End;
  finally
    TempProf.Free;
  end;
end;

Procedure FixFileNamesForWindowsProfiles(const Game : TGame);
Function FixSingleFileRecord(S : String; const GameDir : Boolean) : String;
Var T : String;
begin
  S:=Trim(S);
  If (S<>'') and (Copy(S,1,2)<>'.\') then begin
    T:=ExtractFileName(S); S:=ExtractFilePath(S);
    S:=ExcludeTrailingPathDelimiter(S); While Pos('\',S)>0 do S:=Copy(S,Pos('\',S)+1,MaxInt);
    If GameDir then S:=IncludeTrailingPathDelimiter(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir))+S else S:='.\'+S;
    result:=IncludeTrailingPathDelimiter(S)+T;
  end else result:=S;
end;
Function FixSingleFolderRecord(S : String; const GameDir : Boolean) : String;
begin
  S:=Trim(S);
  If (S<>'') and (Copy(S,1,2)<>'.\') then begin
    S:=ExcludeTrailingPathDelimiter(S); While Pos('\',S)>0 do S:=Copy(S,Pos('\',S)+1,MaxInt);
    If GameDir then S:=IncludeTrailingPathDelimiter(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir))+S else S:='.\'+S;
    result:=IncludeTrailingPathDelimiter(S);
  end else result:=S;
end;

Var I : Integer;
    S : String;
    St : TStringList;
begin
  Game.GameExe:=FixSingleFileRecord(Game.GameExe,True);
  Game.SetupExe:=FixSingleFileRecord(Game.SetupExe,True);

  For I:=0 to 49 do begin
    S:=Game.ExtraPrgFile[I];
    If Pos(';',S)=0 then continue;
    Game.ExtraPrgFile[I]:=Copy(S,1,Pos(';',S)-1)+';'+FixSingleFileRecord(Copy(S,Pos(';',S)+1,MaxInt),True);
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      for I:=0 to St.Count-1 do St[I]:=FixSingleFileRecord(St[I],False);
      Game.ExtraFiles:=ListToValue(St);
    finally
      St.Free;
    end;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      for I:=0 to St.Count-1 do St[I]:=FixSingleFolderRecord(St[I],False);
      Game.ExtraDirs:=ListToValue(St);
    finally
      St.Free;
    end;
  end;

  Game.StoreAllValues;
end;

Function CreateGameFromDFRPackageFolder(const Dir : String; const GameDB : TGameDB; const TempProfFile : String; const MoveFiles : Boolean) : TGame;
Var ProfFile : String;
    I : Integer;
    B : Boolean;
    Msg : tagMSG;
begin
  result:=nil;

  If not ProfileExistingCheck(GameDB,TempProfFile) then exit;

  {Add profile}
  ProfFile:=PrgDataDir+GameListSubDir+'\'+ExtractFileName(TempProfFile);
  If FileExists(ProfFile) then begin
    I:=0;
    repeat inc(I); until not FileExists(ChangeFileExt(ProfFile,IntToStr(I)+'.prof'));
    ProfFile:=ChangeFileExt(ProfFile,IntToStr(I)+'.prof');
  end;
  If not CopyFileWithMsg(TempProfFile,ProfFile,False,MoveFiles) then exit;

  result:=TGame.Create(ProfFile);
  GameDB.Add(result);
  If WindowsExeMode(result) then FixFileNamesForWindowsProfiles(result);

  {Add files}
  B:=False;
  If Application.MainForm<>nil then begin
    B:=Application.MainForm.Enabled;
   Application.MainForm.Enabled:=False;
  end;
  LoadAndShowSmallWaitForm;
  try
    CopyFolderWithMsg(Dir,PrgSetup.BaseDir,True,True,result,True);
  finally
    FreeSmallWaitForm;
    If Application.MainForm<>nil then begin
      While PeekMessage(Msg,Application.MainForm.Handle,WM_INPUT,WM_INPUT,1) do ;
      Application.MainForm.Enabled:=B;
    end;
  end;
end;

Function TextNodeNotEmpty(const Node : IXMLNode) : Boolean;
begin
  result:=(VarType(Node.NodeValue)<>varNull);
end;

Function RealPathFromDOSBoxPath(const Game : TGame; const LocalPath : String) : String;
Var Drive : String;
    St : TStringList;
    I : Integer;
begin
  result:='';
  If (length(LocalPath)<2) or (LocalPath[2]<>':') then exit;
  Drive:=ExtUpperCase(LocalPath[1]);

  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count<3 then continue;
      If ExtUpperCase(St[2])=Drive then begin
        result:=IncludeTrailingPathDelimiter(St[0])+Copy(LocalPath,4,MaxInt);
        exit;
      end;
    finally
      St.Free;
    end;
  end;
end;

Function GetGameFileFromAutoexec(const Game : TGame; const Autoexec : TStringList) : String;
Var I,J : Integer;
    Lines : TList;
    S,Path,GlobalPath : String;
begin
  result:='';

  Lines:=TList.Create;
  try
    Path:='';
    For I:=0 to Autoexec.Count-1 do begin
      S:=Trim(Autoexec[I]);

      {drive letters}
      If (length(S)=2) and (S[2]=':') and (ExtUpperCase(S[1])>='A') and (ExtUpperCase(S[1])<='Z') then begin
        Path:=S; Lines.Clear; Lines.Add(TObject(I)); continue;
      end;

      {cd commands}
      If (length(S)>3) and (ExtUpperCase(Copy(S,1,2))='CD') and (S[3]=' ') and (Path<>'') then begin
        S:=Trim(Copy(S,4,MaxInt));
        If (S<>'') and (S[1]='\') then S:=Copy(S,2,MaxInt);
        If (S<>'') and (S[length(S)]='\') then S:=Copy(S,1,length(S)-1);
        Path:=Path+'\'+S;
        Lines.Add(TObject(I)); continue;
      end;

      {test filename}
      If I<Autoexec.Count-1 then begin Lines.Clear; continue; end;
      If (length(S)>5) and (ExtUpperCase(Copy(S,1,4))='CALL') and (S[5]=' ') then S:=Trim(Copy(S,6,MaxInt));
      GlobalPath:=RealPathFromDOSBoxPath(Game,Path);
      If GlobalPath='' then begin Lines.Clear; continue; end;
      GlobalPath:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(GlobalPath),PrgSetup.BaseDir));
      If not FileExists(GlobalPath+S) then begin Lines.Clear; continue; end;
      result:=MakeRelPath(GlobalPath+S,PrgSetup.BaseDir);
      Lines.Add(TObject(I));
      For J:=Lines.Count-1 downto 0 do Autoexec.Delete(Integer(Lines[J]));
      exit;
    end;
  finally
    Lines.Free;
  end;
end;

Procedure GetRunCommandFromAutoexec(const Game : TGame);
Var I : Integer;
    Autoexec,St : TStringList;
    S : String;
begin
  Autoexec:=StringToStringList(Game.Autoexec);
  try
    {Trim empty lines}
    I:=0; while i<Autoexec.Count do If Trim(Autoexec[I])='' then Autoexec.Delete(I) else inc(I);

    {Exit command}
    If (Autoexec.Count>0) and (Trim(ExtUpperCase(Autoexec[Autoexec.Count-1]))='EXIT') then begin
      Game.CloseDosBoxAfterGameExit:=True;
      Autoexec.Delete(Autoexec.Count-1);
    end;

    {Get game filename from autoexec}
    St:=TStringList.Create;
    try
      St.AddStrings(Autoexec);
      S:=GetGameFileFromAutoexec(Game,St);
      If S<>'' then begin Autoexec.Clear; Autoexec.AddStrings(St); Game.GameExe:=S; end;
    finally
      St.Free;
    end;

    Game.Autoexec:=StringListToString(Autoexec);
  finally
    Autoexec.Free;
  end;
end;

Function CreateGameFromDBGLPackage(const Dir : String; const GameDB : TGameDB; const GameNode : IXMLNode; const CustomNames : TStringList; const MoveFiles : Boolean) : TGame;
Var I,J,K,L : Integer;
    N,N2 : IXMLNode;
    S,Capture,GameDir,ID,Config : String;
    CustomValues,St : TStringList;
begin
  {Load title and create profile}
  S:='Game';
  For I:=0 to GameNode.ChildNodes.Count-1 do begin N:=GameNode.ChildNodes[I]; If (N.NodeName='title') and TextNodeNotEmpty(N) then S:=N.NodeValue; end;
  I:=GameDB.Add(S); result:=GameDB[I];

  CustomValues:=TStringList.Create;
  try
    For I:=1 to 10 do CustomValues.Add('');

    {Load data from xml node}
    Capture:=''; GameDir:=''; ID:=''; Config:='';
    For I:=0 to GameNode.ChildNodes.Count-1 do begin
      N:=GameNode.ChildNodes[I];
      If N.NodeName='captures' then For J:=0 to N.ChildNodes.Count-1 do if (N.ChildNodes[J].NodeName='raw') and TextNodeNotEmpty(N.ChildNodes[J]) then Capture:=N.ChildNodes[J].NodeValue;
      If N.NodeName='game-dir' then For J:=0 to N.ChildNodes.Count-1 do if (N.ChildNodes[J].NodeName='raw') and TextNodeNotEmpty(N.ChildNodes[J]) then GameDir:=N.ChildNodes[J].NodeValue;
      If (N.NodeName='id') and TextNodeNotEmpty(N) then ID:=N.NodeValue;
      If (N.NodeName='setup') and TextNodeNotEmpty(N) then result.SetupExe:=N.NodeValue;
      If (N.NodeName='setup-parameters') and TextNodeNotEmpty(N) then result.SetupParameters:=N.NodeValue;
      If N.NodeName='meta-info' then For J:=0 to N.ChildNodes.Count-1 do begin
        N2:=N.ChildNodes[J];
        If (N2.NodeName='developer') and TextNodeNotEmpty(N2) then result.Developer:=N2.NodeValue;
        If (N2.NodeName='publisher') and TextNodeNotEmpty(N2) then result.Publisher:=N2.NodeValue;
        If (N2.NodeName='year') and TextNodeNotEmpty(N2) then result.Year:=N2.NodeValue;
        If (N2.NodeName='genre') and TextNodeNotEmpty(N2) then result.Genre:=N2.NodeValue;
        If (N2.NodeName='favorite') and TextNodeNotEmpty(N2) then result.Favorite:=(ExtUpperCase(N2.NodeValue)<>'FALSE');
        If (N2.NodeName='notes') and TextNodeNotEmpty(N2) then result.Notes:=N2.NodeValue;
        For K:=1 to 10 do If (N2.NodeName='custom'+IntToStr(K)) and TextNodeNotEmpty(N2) then CustomValues[K-1]:=N2.NodeValue;
        For L:=1 to 9 do begin
          If N2.NodeName='link'+IntToStr(L) then For K:=0 to N2.ChildNodes.Count-1 do if (N2.ChildNodes[K].NodeName='raw') and TextNodeNotEmpty(N2.ChildNodes[K]) then result.WWW[L]:=N2.ChildNodes[K].NodeValue;
        end;
      end;
      If (N.NodeName='full-configuration') and TextNodeNotEmpty(N) then Config:=N.NodeValue;
    end;

    {Process custom data}
    St:=TStringList.Create;
    try
      For I:=0 to CustomValues.Count-1 do if (Trim(CustomValues[I])<>'') and (Trim(CustomValues[I])<>'0') then St.Add(CustomNames[I]+'='+CustomValues[I]);
      result.UserInfo:=StringListToString(St);
    finally
      St.Free;
    end;
  finally
    CustomValues.Free;
  end;

  {Compact genre data}
  St:=ValueToList(result.Genre,',');
  try
    For I:=0 to St.Count-1 do St[I]:=Trim(St[I]);
    result.Genre:=ListToValue(St,';');
  finally
    St.Free;
  end;

  {Copy game folders}
  CopyFolderWithMsg(IncludeTrailingPathDelimiter(Dir)+'dosroot\'+ID+'\',MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir),True,MoveFiles);

  {Load profile settings}
  St:=TStringList.Create;
  try
    St.Text:=Config;
    St.SaveToFile(TempDir+DosBoxConfFileName);
    try
      ImportConfFileData(GameDB,result,TempDir+DosBoxConfFileName);
    finally
      ExtDeleteFile(TempDir+DosBoxConfFileName,ftTemp);
    end;
  finally
    St.Free;
  end;

  {Setup capture folder and copy capture files}
  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(result.Name)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    Inc(I);
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(result.Name)+IntToStr(I)+'\';
  end;
  result.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
  ForceDirectories(MakeAbsPath(result.CaptureFolder,PrgSetup.BaseDir));
  If Trim(Capture)<>'' then
    CopyFolderWithMsg(IncludeTrailingPathDelimiter(Dir)+IncludeTrailingPathDelimiter(Capture),MakeAbsPath(result.CaptureFolder,PrgSetup.BaseDir),True,True);

  {Fix mount commands (DBGL is mounting ".")}
  For I:=0 to result.NrOfMounts-1 do begin
    St:=ValueToList(result.Mount[I]);
    try
      If (St.Count>0) and ((Trim(St[0])='.') or (Trim(St[0])='.\')) then begin
        St[0]:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir);
        result.Mount[I]:=ListToValue(St);
      end;
    finally
      St.Free;
    end;
  end;

  {Build game run command}
  GetRunCommandFromAutoexec(result);

  {Build setup command}
  S:=Trim(result.SetupExe);
  If (S<>'') and (Copy(S,1,2)<>'.\') and ((length(S)<2) or (S[2]<>':')) then result.SetupExe:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+S;

  result.StoreAllValues;
  result.LoadCache;
end;

Function CreateGamesFromDBGLPackageFolder(const Owner : TComponent; const Dir : String; const GameDB : TGameDB; const TempProfFile : String; const MoveFiles : Boolean) : TGame;
Var XMLDoc : TXMLDocument;
    N,N2 : IXMLNode;
    ProfileNames,CustomNames : TStringList;
    ProfileNodes : Array of IXMLNode;
    I,J,K : Integer;
    Title, Author, Notes : String;
    G : TGame;
begin
  result:=nil;
  XMLDoc:=LoadXMLDoc(TempProfFile);
  try
    If (XMLDoc=nil) or (XMLDoc.DocumentElement.NodeName<>'document') then exit;

    SetLength(ProfileNodes,0);
    ProfileNames:=TStringList.Create;
    CustomNames:=TStringList.Create;
    try
      For I:=1 to 10 do CustomNames.Add('');

      {Read xml file, find profiles}
      Title:=''; Author:=''; Notes:='';
      For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
        N:=XMLDoc.DocumentElement.ChildNodes[I];
        If N.NodeName='export' then For J:=0 to N.ChildNodes.Count-1 do begin
          N2:=N.ChildNodes[J];
          If (N2.NodeName='title') and TextNodeNotEmpty(N2) then Title:=N2.NodeValue;
          If (N2.NodeName='author') and TextNodeNotEmpty(N2) then Author:=N2.NodeValue;
          If (N2.NodeName='notes') and TextNodeNotEmpty(N2) then Notes:=N2.NodeValue;
          For K:=1 to 10 do If (N2.NodeName='custom'+IntToStr(K)) and TextNodeNotEmpty(N2) then CustomNames[K-1]:=N2.NodeValue;
        end;
        If N.NodeName='profile' then For J:=0 to N.ChildNodes.Count-1 do If (N.ChildNodes[J].NodeName='title') and TextNodeNotEmpty(N.ChildNodes[J]) then begin
          K:=length(ProfileNodes); SetLength(ProfileNodes,K+1); ProfileNodes[K]:=N;
          ProfileNames.AddObject(N.ChildNodes[J].NodeValue,TObject(K));
          break;
        end;
      end;

      {Select which profiles to install}
      if not ShowZipPackageDBGLDialog(Owner,Title,Author,Notes,ProfileNames) then exit;

      {Install profiles}
      LoadAndShowSmallWaitForm(LanguageSetup.ImportDBGLPackageProgress);
      try
        For I:=0 to ProfileNames.Count-1 do begin
          G:=CreateGameFromDBGLPackage(Dir,GameDB,ProfileNodes[Integer(ProfileNames.Objects[I])],CustomNames,MoveFiles);
          If G<>nil then result:=G;
        end;
      finally
        FreeSmallWaitForm;
      end;
    finally
      ProfileNames.Free;
      CustomNames.Free;
    end;
  finally
    XMLDoc.Free;
  end;
end;

Function CreateGameFromFolder(const Owner : TComponent; const Dir : String; const GameDB : TGameDB; const ArchivFileName : String; const NoDialogIfAutoSetupIsAvailable : Boolean) : TGame;
Var TempProfFile : String;
begin
  TempProfFile:=GetProfFileName(Dir);

  If TempProfFile='' then begin
    If FileExists(Dir+DBGLPackageInfoFile) then begin
      {Import DBGL package file}
      result:=CreateGamesFromDBGLPackageFolder(Owner,Dir,GameDB,Dir+DBGLPackageInfoFile,ArchivFileName<>'');
    end else begin
      {Add simple zip archive}
      result:=CreateGameFromSimpleFolder(Dir,GameDB,ArchivFileName,NoDialogIfAutoSetupIsAvailable,False);
    end;
  end else begin
    {Add normal zip package (with prof file)}
    result:=CreateGameFromDFRPackageFolder(Dir,GameDB,TempProfFile,ArchivFileName<>'');
  end;
end;

Procedure WindowsExeCount(const Folder : String; var DOS, Windows : Integer);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.EXE',faAnyFile,Rec);
  try
    While I=0 do begin
      If IsWindowsExe(IncludeTrailingPathDelimiter(Folder)+Rec.Name) then inc(Windows) else inc(DOS);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.COM',faAnyFile,Rec);
  try
    While I=0 do begin inc(DOS); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.BAT',faAnyFile,Rec);
  try
    While I=0 do begin inc(DOS); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then WindowsExeCount(IncludeTrailingPathDelimiter(Folder)+Rec.Name,DOS,Windows);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function FolderWindowsTest(const Folder : String; const FromArchive : Boolean) : Boolean;
Var DOS, Windows : Integer;
begin
  DOS:=0; Windows:=0;
  WindowsExeCount(Folder,DOS,Windows);
  If Windows>DOS then begin
    If FromArchive
      then result:=(MessageDlg(LanguageSetup.MessageWindowsExeImportArchiveWarning,mtWarning,[mbYes,mbNo],0)=mrYes)
      else result:=(MessageDlg(LanguageSetup.MessageWindowsExeImportFolderWarning,mtWarning,[mbYes,mbNo],0)=mrYes);
  end else begin
    result:=True;
  end;
end;

Function ImportZipPackage(const AOwner : TComponent; const AFileName : String; const AGameDB : TGameDB; const NoDialogIfAutoSetupIsAvailable : Boolean) : TGame;
Var Temp : String;
    InstSupport : Boolean;
begin
  result:=nil;
  InstSupport:=False;

  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
  If not ForceDirectories(Temp) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Temp]),mtError,[mbOK],0);
    exit;
  end;

  try
    if not ExtractZipFile(AOwner,AFileName,Temp) then exit;

    If not PrgSetup.AllowPackingWindowsGames then begin
      If not FolderWindowsTest(Temp,True) then exit;
    end;

    If TestInstallationSupportNeeded(Temp) then begin
      If MessageDlg(LanguageSetup.InstallationSupportArchiveCheck,mtConfirmation,[mbYes,mbNo],0)=mrYes then InstSupport:=True;
    end;

    if InstSupport then begin
      result:=RunInstallationFromZipFile(AOwner,AGameDB,AFileName,Temp);
    end else begin
      result:=CreateGameFromFolder(AOwner,Temp,AGameDB,AFileName,NoDialogIfAutoSetupIsAvailable);
      If result<>nil then begin
        result.StoreAllValues;
        result.LoadCache;
      end;
    end;
  finally
    ExtDeleteFolder(Temp,ftTemp);
  end;
end;

Function ImportFolder(const AOwner : TComponent; const AFolderName : String; const AGameDB : TGameDB; const NoDialogIfAutoSetupIsAvailable : Boolean) : TGame;
Var InstSupport : Boolean;
begin
  InstSupport:=False; result:=nil;

  If not FolderWindowsTest(AFolderName,False) then exit;

  If TestInstallationSupportNeeded(AFolderName) then begin
    If MessageDlg(LanguageSetup.InstallationSupportFolderCheck,mtConfirmation,[mbYes,mbNo],0)=mrYes then InstSupport:=True;
  end;

  if InstSupport then begin
    result:=RunInstallationFromFolder(AOwner,AGameDB,AFolderName);
  end else begin
    result:=CreateGameFromFolder(AOwner,AFolderName,AGameDB,'',NoDialogIfAutoSetupIsAvailable);
    If result<>nil then begin
      result.StoreAllValues;
      result.LoadCache;
    end;
  end;
end;

Procedure TempZipFilesStartCleanUp;
Var Temp : String;
begin
  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
  ExtDeleteFolder(Temp,ftTemp);
end;

end.
