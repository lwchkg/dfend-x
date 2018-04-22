unit TransferFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls, GameDBUnit, PrgSetupUnit,
  Menus;

type
  TTransferForm = class(TForm)
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    DestPrgDirEdit: TLabeledEdit;
    DestPrgDirButton: TSpeedButton;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    CopyDFRCheckBox: TCheckBox;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure DestPrgDirButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Function CopyInstallation(const DestPrgDir : String) : Boolean;
    Function GetOperationMode(var OpMode : TOperationMode) : Boolean;
    Function GetDestPrgDataDir(const OpMode : TOperationMode; var DestPrgDataDir : String) : Boolean;
    Function CopyDir(const SourceDir, DestDir : String) : Boolean;
    function CopyFiles(const RelDir, SourceBaseDir, DestBaseDir, GameName: String): Boolean; overload;
    function CopyFiles(const RelDir1, RelDir2, SourceBaseDir, DestBaseDir, GameName: String): Boolean; overload;
    function CopySingleFile(const RelFile, SourceBaseDir, DestBaseDir, GameName: String): Boolean;
    Function TransferGame(const Game : TGame; const DestDataDir : String) : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  TransferForm: TTransferForm;

Function TransferGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     WaitFormUnit, GameDBToolsUnit, SmallWaitFormUnit, UninstallFormUnit,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TTransferForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.TransferForm;
  InfoLabel.Caption:=LanguageSetup.TransferFormInfo;
  DestPrgDirEdit.EditLabel.Caption:=LanguageSetup.TransferFormDestPrgDir;
  DestPrgDirButton.Hint:=LanguageSetup.ChooseFolder;
  OKButton.Caption:=LanguageSetup.OK;
  HelpButton.Caption:=LanguageSetup.Help;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  CopyDFRCheckBox.Caption:=LanguageSetup.TransferFormCopyDFendReloadedPrgFiles;

  UserIconLoader.DialogImage(DI_SelectFolder,DestPrgDirButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TTransferForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,False,False,True);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False,True);
end;

procedure TTransferForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

procedure TTransferForm.DestPrgDirButtonClick(Sender: TObject);
Var S : String;
begin
  S:=DestPrgDirEdit.Text;
  if SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then DestPrgDirEdit.Text:=S;
end;

Function TTransferForm.CopyInstallation(const DestPrgDir : String) : Boolean;
Var St : TStringList;
    I : Integer;
    S : String;
    NewSetup : TPrgSetup;
    NewGameDB : TGameDB;
    OperationModeSave : TOperationMode;
    Rec : TSearchRec;
begin
  result:=False;

  LoadAndShowSmallWaitForm(LanguageSetup.TransferFormCopyDFendReloadedPrgFilesWait);
  try

    {Create destination folder}

    If not ForceDirectories(DestPrgDir) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir]),mtError,[mbOK],0);
      exit;
    end;

    If not ForceDirectories(DestPrgDir+BinFolder+'\') then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir+BinFolder+'\']),mtError,[mbOK],0);
      exit;
    end;

    If not ForceDirectories(DestPrgDir+LanguageSubDir+'\') then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir+BinFolder+'\']),mtError,[mbOK],0);
      exit;
    end;

    If not ForceDirectories(DestPrgDir+SettingsFolder+'\') then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir+SettingsFolder+'\']),mtError,[mbOK],0);
      exit;
    end;

    {Transfer program files}

    {PrgDir -> PrgDir}
    St:=TStringList.Create;
    try
      St.Add(ExtractFileName(Application.ExeName));
      St.Add('Readme_OperationMode.txt');
      For I:=0 to St.Count-1 do begin
        CopyFile(PChar(PrgDir+St[I]),PChar(DestPrgDir+St[I]),False);
        Application.ProcessMessages;
      end;
    finally
      St.Free;
    end;

    {PrgDir+BinFolder (or fall back PrgDir) -> PrgDir+BinFolder}
    St:=TStringList.Create;
    try
      St.Add(MakeDOSFilesystemFileName);
      St.Add(OggEncPrgFile);
      St.Add('License.txt');
      St.Add('LicenseComponents.txt');
      St.Add('ChangeLog.txt');
      St.Add(NSIInstallerHelpFile);
      St.Add('SetInstallerLanguage.exe');
      St.Add('7za.dll');
      St.Add('DelZip179.dll');
      St.Add('mediaplr.dll');
      St.Add('UpdateCheck.exe');
      St.Add('InstallVideoCodec.exe');
      For I:=0 to St.Count-1 do begin
        S:='';
        If FileExists(PrgDir+BinFolder+'\'+St[I]) then S:=PrgDir+BinFolder+'\'+St[I];
        If (S='') and FileExists(PrgDir+St[I]) then S:=PrgDir+St[I];
        If S<>'' then begin
          CopyFile(PChar(S),PChar(DestPrgDir+BinFolder+'\'+St[I]),False);
          Application.ProcessMessages;
        end;
      end;
    finally
      St.Free;
    end;

    {PrgDataDir+SettingsFolder (or fall back PrgDataDir or fall back PrgDir+BinFolder or even more fall back PrgDir) -> PrgDir+SettingsFolder}
    St:=TStringList.Create;
    try
      St.Add('Links.txt');
      St.Add('SearchLinks.txt');
      For I:=0 to St.Count-1 do begin
        S:='';
        If FileExists(PrgDataDir+SettingsFolder+'\'+St[I]) then S:=PrgDataDir+SettingsFolder+'\'+St[I];
        If (S='') and FileExists(PrgDataDir+St[I]) then S:=PrgDataDir+St[I];
        If (S='') and FileExists(PrgDir+BinFolder+'\'+St[I]) then S:=PrgDir+BinFolder+'\'+St[I];
        If (S='') and FileExists(PrgDir+St[I]) then S:=PrgDir+St[I];
        If S<>'' then begin
          CopyFile(PChar(S),PChar(DestPrgDir+SettingsFolder+'\'+St[I]),False);
          Application.ProcessMessages;
        end;
      end;
    finally
      St.Free;
    end;

    If not CopyDir(IncludeTrailingPathDelimiter(PrgDir+LanguageSubDir),IncludeTrailingPathDelimiter(DestPrgDir+LanguageSubDir)) then exit;

    {Transfer settings}

    St:=TStringList.Create;
    try
      St.Add(ConfOptFile);
      St.Add(ScummVMConfOptFile);
      St.Add(IconsConfFile);
      St.Add(MainSetupFile);
      St.Add(NSIInstallerHelpFile);
      For I:=0 to St.Count-1 do begin
        S:='';
        If FileExists(PrgDataDir+SettingsFolder+'\'+St[I]) then S:=PrgDataDir+SettingsFolder+'\'+St[I];
        If (S='') and FileExists(PrgDataDir+St[I]) then S:=PrgDataDir+St[I];
        If S<>'' then begin
          CopyFile(PChar(S),PChar(DestPrgDir+SettingsFolder+'\'+St[I]),False);
          Application.ProcessMessages;
        end;
      end;
    finally
      St.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add('PORTABLEMODE');
      try St.SaveToFile(DestPrgDir+OperationModeConfig); except
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[DestPrgDir+OperationModeConfig]),mtError,[mbOK],0);
        exit;
      end;
    finally
      St.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add(IconsSubDir);
      St.Add(GameListSubDir);
      St.Add('VirtualHD');
      For I:=0 to St.Count-1 do If not ForceDirectories(DestPrgDir+St[I]) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir+St[I]]),mtError,[mbOK],0);
        exit;
      end;
    finally
      St.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add(AutoSetupSubDir);
      St.Add(LanguageSubDir);
      St.Add(TemplateSubDir);
      For I:=0 to St.Count-1 do begin
        If not CopyDir(IncludeTrailingPathDelimiter(PrgDataDir+St[I]),IncludeTrailingPathDelimiter(DestPrgDir+St[I])) then exit;
        Application.ProcessMessages;
      end;
    finally
      St.Free;
    end;

    {Transfer icon sets}

    CopyDir(IncludeTrailingPathDelimiter(PrgDataDir+IconSetsFolder),IncludeTrailingPathDelimiter(DestPrgDir+IconSetsFolder));
    If PrgDir<>PrgDataDir then begin
      CopyFile(PChar(PrgDir+IconSetsFolder+'\IconSets_Readme.txt'),PChar(DestPrgDir+IconSetsFolder+'\IconSets_Readme.txt'),True);
      I:=FindFirst(PrgDir+IconSetsFolder+'\*.*',faDirectory,Rec);
      try
        While I=0 do begin
          If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
            If not DirectoryExists(DestPrgDir+IconSetsFolder+'\'+Rec.Name) then CopyDir(IncludeTrailingPathDelimiter(PrgDir+IconSetsFolder+'\'+Rec.Name),IncludeTrailingPathDelimiter(DestPrgDir+IconSetsFolder+'\'+Rec.Name));
          end;
          I:=FindNext(Rec);
        end;
      finally
        FindClose(Rec);
      end;
    end;

    {Transfer tools}

    St:=TStringList.Create;
    try
      St.Add('FREEDOS');
      St.Add('DOSZIP');
      For I:=0 to St.Count-1 do begin
        S:='';
        If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+St[I]) then S:=PrgDir+NewUserDataSubDir+'\'+St[I] else begin
          If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir))+St[I]) then S:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir))+St[I];
        end;
        If S<>'' then begin
          If not CopyDir(IncludeTrailingPathDelimiter(S),DestPrgDir+'VirtualHD\'+St[I]+'\') then exit;
        end;
      end;
    finally
      St.Free;
    end;

    {Transfer DOSBox}

    If not CopyDir(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir),IncludeTrailingPathDelimiter(DestPrgDir+'DOSBox')) then exit;
    If Trim(PrgSetup.DOSBoxSettings[0].DosBoxMapperFile)<>'' then
      CopyFile(PChar(MakeAbsPath(PrgSetup.DOSBoxSettings[0].DosBoxMapperFile,PrgSetup.BaseDir)),PChar(IncludeTrailingPathDelimiter(DestPrgDir+'DOSBox')+ExtractFileName(PrgSetup.DOSBoxSettings[0].DosBoxMapperFile)),False);

    {Change DFend.ini}

    OperationModeSave:=OperationMode;
    try
      NewSetup:=TPrgSetup.Create(DestPrgDir+SettingsFolder+'\'+MainSetupFile);
      try
        If ExtUpperCase(PrgSetup.WaveEncOgg)=ExtUpperCase(PrgDir+BinFolder+'\'+OggEncPrgFile) then begin
          NewSetup.WaveEncOgg:=DestPrgDir+BinFolder+'\'+OggEncPrgFile;
        end;
        NewSetup.BaseDir:=DestPrgDir;
        NewSetup.GameDir:=DestPrgDir+'VirtualHD';
        NewSetup.DataDir:=DestPrgDir+'GameData';
        NewSetup.CaptureDir:=DestPrgDir+CaptureSubDir;
        NewSetup.DOSBoxSettings[0].DosBoxDir:=DestPrgDir+'DOSBox';
        If Trim(PrgSetup.DOSBoxSettings[0].DosBoxLanguage)=''
          then NewSetup.DOSBoxSettings[0].DosBoxLanguage:=''
          else NewSetup.DOSBoxSettings[0].DosBoxLanguage:=DestPrgDir+'DOSBox\'+ExtractFileName(PrgSetup.DOSBoxSettings[0].DosBoxLanguage);
        NewSetup.DOSBoxSettings[0].DosBoxMapperFile:='.\'+ExtractFileName(PrgSetup.DOSBoxSettings[0].DosBoxMapperFile);
        NewSetup.PathToFREEDOS:='.\VirtualHD\FREEDOS\';
        If FileExists(DestPrgDir+OggEncPrgFile) then NewSetup.WaveEncOgg:='.\'+OggEncPrgFile;

        S:=MakeRelPath(PrgSetup.ScummVMPath,PrgSetup.BaseDir);
        If Copy(S,1,2)='.\' then NewSetup.ScummVMPath:=MakeAbsPath(S,DestPrgDir);
        S:=MakeRelPath(PrgSetup.QBasic,PrgSetup.BaseDir);
        If Copy(S,1,2)='.\' then NewSetup.QBasic:=MakeAbsPath(S,DestPrgDir);
        S:=MakeRelPath(PrgSetup.WaveEncOgg,PrgSetup.BaseDir);
        If Copy(S,1,2)='.\' then NewSetup.WaveEncOgg:=MakeAbsPath(S,DestPrgDir);
        S:=MakeRelPath(PrgSetup.WaveEncMp3,PrgSetup.BaseDir);
        If Copy(S,1,2)='.\' then NewSetup.WaveEncMp3:=MakeAbsPath(S,DestPrgDir);
        NewSetup.DOSBoxBasedUserInterpretersPrograms.Clear;
        For I:=0 to PrgSetup.DOSBoxBasedUserInterpretersPrograms.Count-1 do begin
          S:=MakeRelPath(PrgSetup.DOSBoxBasedUserInterpretersPrograms[I],PrgSetup.BaseDir);
          If Copy(S,1,2)<>'.\' then S:=PrgSetup.DOSBoxBasedUserInterpretersPrograms[I];
          NewSetup.DOSBoxBasedUserInterpretersPrograms.Add(S);
        end;

        OperationMode:=omPortable;
        TempPrgDir:=DestPrgDir;
      finally
        NewSetup.Free;
      end;
    finally
      OperationMode:=OperationModeSave;
      TempPrgDir:='';
    end;

    { Build "DOSBox DOS" profile }

    NewGameDB:=TGameDB.Create(DestPrgDir+GameListSubDir);
    try
      BuildDefaultDosProfile(NewGameDB,False);
    finally
      NewGameDB.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add('IconLibrary');
      St.Add('Capture');
      For I:=0 to St.Count-1 do begin
        S:='';
        If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+St[I]) then S:=PrgDir+NewUserDataSubDir+'\'+St[I];
        If S<>'' then begin
          If not CopyDir(IncludeTrailingPathDelimiter(S),DestPrgDir+St[I]+'\') then exit;
        end;
      end;
    finally
      St.Free;
    end;

  finally
    FreeSmallWaitForm;
  end;

  result:=True;
end;

function TTransferForm.GetOperationMode(var OpMode: TOperationMode): Boolean;
Var S : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;

  S:=Trim(DestPrgDirEdit.Text);
  If S='' then begin
    MessageDlg(LanguageSetup.MessageNoInstallationSelected,mtError,[mbOK],0);
    exit;
  end;

  result:=True;
  OpMode:=omPrgDir;

  S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OperationModeConfig);
  If not FileExists(S) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(S); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='PRGDIRMODE' then begin OpMode:=omPrgDir; exit; end;
      If S='USERDIRMODE' then begin OpMode:=omUserDir; exit; end;
      If S='PORTABLEMODE' then begin OpMode:=omPortable; exit; end;
    end;
  finally
    St.Free;
  end;
end;

function TTransferForm.GetDestPrgDataDir(const OpMode: TOperationMode; var DestPrgDataDir: String): Boolean;
Var S,T : String;
    LocalPrgSetup : TPrgSetup;
    SaveOpMode : TOperationMode;
begin
  result:=False;

  If OpMode=omUserDir then begin
    S:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_PROFILE))+'D-Fend Reloaded\';
  end else begin
    S:=IncludeTrailingPathDelimiter(Trim(DestPrgDirEdit.Text));
  end;

  T:=S;
  S:=S+SettingsFolder+'\'+ExtractFileName(MainSetupFile);
  if not FileExists(S) then begin
    MessageDlg(Format(LanguageSetup.MessageNoSetupFileFound,[ExtractFilePath(S)]),mtError,[mbOK],0);
    exit;
  end;

  result:=True;

  SaveOpMode:=OperationMode;
  OperationMode:=OpMode;
  TempPrgDir:=IncludeTrailingPathDelimiter(ExtractFilePath(T));
  LocalPrgSetup:=TPrgSetup.Create(S);
  try
    DestPrgDataDir:=LocalPrgSetup.BaseDir;
  finally
    LocalPrgSetup.Free;
    OperationMode:=SaveOpMode;
    TempPrgDir:='';
  end;
end;

function TTransferForm.CopyDir(const SourceDir, DestDir: String): Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;

  if not ForceDirectories(DestDir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestDir]),mtError,[mbOK],0);
    exit;
  end;

  I:=FindFirst(SourceDir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If Rec.Name[1]<>'.' then begin
          if not CopyDir(SourceDir+Rec.Name+'\',DestDir+Rec.Name+'\') then exit;
        end;
      end else begin
        Application.ProcessMessages;
        if not CopyFile(PChar(SourceDir+Rec.Name),PChar(DestDir+Rec.Name),False) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[SourceDir+Rec.Name,DestDir+Rec.Name]),mtError,[mbOK],0); exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  result:=True;
end;

function TTransferForm.CopyFiles(const RelDir, SourceBaseDir, DestBaseDir, GameName: String): Boolean;
Var S,T : String;
begin
  S:=IncludeTrailingPathDelimiter(MakeRelPath(RelDir,SourceBaseDir));
  If Copy(S,2,2)=':\' then begin
    MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[RelDir,GameName,S]),mtError,[mbOK],0);
    result:=False; exit;
  end;
  S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir),SourceBaseDir));
  T:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir),DestBaseDir));
  result:=CopyDir(S,T);
end;

function TTransferForm.CopyFiles(const RelDir1, RelDir2, SourceBaseDir, DestBaseDir, GameName: String): Boolean;
Var S,T : String;
begin
  S:=IncludeTrailingPathDelimiter(MakeRelPath(RelDir1,SourceBaseDir));
  If Copy(S,2,2)=':\' then begin
    MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[RelDir1,GameName,S]),mtError,[mbOK],0);
    result:=False; exit;
  end;
  S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir1),SourceBaseDir));
  T:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir2),DestBaseDir));
  result:=CopyDir(S,T);
end;

function TTransferForm.CopySingleFile(const RelFile, SourceBaseDir, DestBaseDir, GameName: String): Boolean;
Var S,T : String;
begin
  result:=False;

  S:=IncludeTrailingPathDelimiter(MakeRelPath(RelFile,SourceBaseDir));
  If Copy(S,2,2)=':\' then begin
    MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[RelFile,GameName,S]),mtError,[mbOK],0);
    result:=False; exit;
  end;

  S:=MakeAbsPath(RelFile,SourceBaseDir);
  T:=MakeAbsPath(RelFile,DestBaseDir);

  if not ForceDirectories(ExtractFilePath(T)) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[T]),mtError,[mbOK],0);
    exit;
  end;

  if not CopyFile(PChar(S),PChar(T),False) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[S,T]),mtError,[mbOK],0); exit;
  end;

  result:=True;
end;

function TTransferForm.TransferGame(const Game: TGame; const DestDataDir: String): Boolean;
Var S,T,DestProfFile : String;
    I : Integer;
    St, Files, Folders : TStringList;
    TempGame : TGame;
begin
  result:=False;
  Game.StoreAllValues;

  DestProfFile:=DestDataDir+GameListSubDir+'\'+ExtractFileName(Game.SetupFile);
  If FileExists(DestProfFile) then begin
    I:=0;
    repeat inc(I); until not FileExists(ChangeFileExt(DestProfFile,IntToStr(I)+'.prof'));
    DestProfFile:=ChangeFileExt(DestProfFile,IntToStr(I)+'.prof');
  end;
  if not CopyFile(PChar(Game.SetupFile),PChar(DestProfFile),True) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Game.SetupFile,DestProfFile]),mtError,[mbOK],0); exit;
  end;
  
  If ScummVMMode(Game) then begin
    S:=Trim(Game.ScummVMPath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(S);
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
    S:=Trim(Game.ScummVMZip);
    If S<>'' then begin
      if not CopySingleFile(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
    S:=Trim(Game.ScummVMSavePath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(S);
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  end else begin
    S:=Trim(Game.GameExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S='' then S:=Trim(Game.SetupExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(ExtractFilePath(S));
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  end;

  S:=Trim(Game.CaptureFolder);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(S);
    If (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(DestDataDir+S) then begin
      I:=0;
      repeat inc(I); until not DirectoryExists(DestDataDir+IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(S)+IntToStr(I)));
      T:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(S)+IntToStr(I));
      TempGame:=TGame.Create(DestProfFile); try TempGame.CaptureFolder:=T; TempGame.StoreAllValues; finally TempGame.Free; end;
      if not CopyFiles(S,T,PrgDataDir,DestDataDir,Game.Name) then exit;
    end else begin
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  end;

  S:=MakeAbsIconName(Game.Icon);
  If (S<>'') and FileExists(S) then begin
    If ExtractFilePath(Game.Icon)='' then begin
      S:=Trim(Game.Icon);
      if not CopyFile(PChar(PrgDataDir+IconsSubDir+'\'+S),PChar(DestDataDir+IconsSubDir+'\'+S),False) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[PrgDataDir+IconsSubDir+'\'+S,DestDataDir+IconsSubDir+'\'+S]),mtError,[mbOK],0); exit;
        exit;
      end;
    end else begin
      S:=MakeRelPath(S,PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      T:=IncludeTrailingPathDelimiter(MakeAbsPath(T,DestDataDir))+ExtractFileName(S);
      S:=MakeAbsPath(S,PrgSetup.BaseDir);
      if not CopyFile(PChar(S),PChar(T),False) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[S,T]),mtError,[mbOK],0); exit;
        exit;
      end;
    end;
  end;

  S:=Trim(Game.DataDir);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(S);
    If (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(DestDataDir+S) then begin
      I:=0;
      repeat inc(I); until not DirectoryExists(DestDataDir+IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(S)+IntToStr(I)));
      T:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(S)+IntToStr(I));
      TempGame:=TGame.Create(DestProfFile); try TempGame.DataDir:=T; TempGame.StoreAllValues; finally TempGame.Free; end;
      if not CopyFiles(S,T,PrgDataDir,DestDataDir,Game.Name) then exit;
    end else begin
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=St[I];
        If not ForceDirectories(ExtractFilePath(MakeAbsPath(S,DestDataDir))) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[ExtractFilePath(MakeAbsPath(S,DestDataDir))]),mtError,[mbOK],0); exit;
          exit;
        end;
        if not CopyFile(PChar(MakeAbsPath(S,PrgDataDir)),PChar(MakeAbsPath(S,DestDataDir)),False) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[MakeAbsPath(S,PrgDataDir),MakeAbsPath(S,DestDataDir)]),mtError,[mbOK],0); exit;
          exit;
        end;
      end;
    finally
      St.Free;
    end;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=IncludeTrailingPathDelimiter(St[I]);
        if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
      end;
    finally
      St.Free;
    end;
  end;

  FileAndFoldersFromDrives(Game,Files,Folders);
  try
    For I:=0 to Files.Count-1 do begin
      S:=MakeRelPath(Files[I],PrgSetup.BaseDir);
      If not ForceDirectories(ExtractFilePath(MakeAbsPath(S,DestDataDir))) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[ExtractFilePath(MakeAbsPath(S,DestDataDir))]),mtError,[mbOK],0); exit;
        exit;
      end;
      if not CopyFile(PChar(MakeAbsPath(S,PrgDataDir)),PChar(MakeAbsPath(S,DestDataDir)),False) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[MakeAbsPath(S,PrgDataDir),MakeAbsPath(S,DestDataDir)]),mtError,[mbOK],0); exit;
        exit;
      end;
    end;
    For I:=0 to Folders.Count-1 do begin
      S:=Folders[I];
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  finally
    Files.Free;
    Folders.Free;
  end;

  result:=True;
end;

procedure TTransferForm.OKButtonClick(Sender: TObject);
Var OpMode : TOperationMode;
    DestPrgDataDir : String;
    I,J : Integer;
begin
  If CopyDFRCheckBox.Checked then begin
    If not CopyInstallation(IncludeTrailingPathDelimiter(DestPrgDirEdit.Text)) then begin ModalResult:=mrNone; exit; end;
  end;

  If not GetOperationMode(OpMode) then begin ModalResult:=mrNone; exit; end;
  if not GetDestPrgDataDir(OpMode,DestPrgDataDir) then begin ModalResult:=mrNone; exit; end;

  J:=0; For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then inc(J);
  InitProgressWindow(self,J);
  try
    For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
      StepProgressWindow;
      if not TransferGame(TGame(ListBox.Items.Objects[I]),DestPrgDataDir) then begin ModalResult:=mrNone; exit; end;
    end;
  finally
    DoneProgressWindow;
  end;
end;

procedure TTransferForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasTransferProfiles);
end;

procedure TTransferForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function TransferGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  TransferForm:=TTransferForm.Create(AOwner);
  try
    TransferForm.GameDB:=AGameDB;
    result:=(TransferForm.ShowModal=mrOK);
  finally
    TransferForm.Free;
  end;
end;


end.
