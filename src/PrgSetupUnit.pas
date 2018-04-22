unit PrgSetupUnit;
interface

uses Classes, CommonComponents;

Type TOperationMode=(omPrgDir, omUserDir, omPortable);

var OperationMode : TOperationMode;

{
omPrgDir=Data is stored in Programfolder; XP with User is Admin
omUserDir=Data is stored in User-Data-Folder; Vista with normal User
omPortable=like omPrgDir, but DosBoxDir, BaseDir, GameDir and DataDir are stored relative to PrgDir
}

Type TDOSBoxData=record
  Name, DosBoxDir, DosBoxMapperFile, DosBoxLanguage, SDLVideodriver, CommandLineParameters, CustomSettings : String;
  KeyboardLayout, Codepage : String;
  HideDosBoxConsole, CenterDOSBoxWindow, DisableScreensaver, WaitOnError : Boolean;
end;

Type TDOSBoxSetting=class
  private
    FPrgSetup : TBasePrgSetup;
    FNr : Integer;
    FName, FDosBoxDir, FDosBoxMapperFile, FDosBoxLanguage, FSDLVideodriver, FCommandLineParameters, FCustomSettings : String;
    FKeyboardLayout, FCodepage : String;
    FHideDosBoxConsole, FCenterDOSBoxWindow, FDisableScreensaver, FWaitOnError : Boolean;
    Procedure ReadSettings;
    Procedure WriteSettings;
    Procedure InitDirs;
    Procedure DoneDirs;
  public
    Constructor Create(const APrgSetup : TBasePrgSetup; const ANr : Integer);
    Destructor Destroy; override;
    property Nr : Integer read FNr write FNr;

    property Name : String read FName write FName;
    property DosBoxDir : String read FDosBoxDir write FDosBoxDir;
    property DosBoxMapperFile : String read FDosBoxMapperFile write FDosBoxMapperFile;
    property DosBoxLanguage : String read FDosBoxLanguage write FDosBoxLanguage;
    property SDLVideodriver : String read FSDLVideodriver write FSDLVideodriver;
    property CommandLineParameters : String read FCommandLineParameters write FCommandLineParameters;
    property CustomSettings : String read FCustomSettings write FCustomSettings;


    property KeyboardLayout : String read FKeyboardLayout write FKeyboardLayout;
    property Codepage : String read FCodepage write FCodepage;

    property HideDosBoxConsole : Boolean read FHideDosBoxConsole write FHideDosBoxConsole;
    property CenterDOSBoxWindow : Boolean read FCenterDOSBoxWindow write FCenterDOSBoxWindow;
    property DisableScreensaver : Boolean read FDisableScreensaver write FDisableScreensaver;
    property WaitOnError : Boolean read FWaitOnError write FWaitOnError;
end;

Type TPackerSetting=class
  private
    FPrgSetup : TBasePrgSetup;
    FNr : Integer;
    FName, FZipFileName, FFileExtensions : String;
    FExtractFile, FCreateFile, FUpdateFile : String;
    FTrailingBackslash : Boolean;
    Procedure ReadSettings;
    Procedure WriteSettings;
  public
    Constructor Create(const APrgSetup : TBasePrgSetup; const ANr : Integer);
    Destructor Destroy; override;
    property Nr : Integer read FNr write FNr;

    property Name : String read FName write FName;
    property ZipFileName : String read FZipFileName write FZipFileName;
    property FileExtensions : String read FFileExtensions write FFileExtensions;
    property ExtractFile : String read FExtractFile write FExtractFile;
    property CreateFile : String read FCreateFile write FCreateFile;
    property UpdateFile : String read FUpdateFile write FUpdateFile;
    property TrailingBackslash : Boolean read FTrailingBackslash write FTrailingBackslash;
 end;

Type TPrgSetup=class(TBasePrgSetup)
  private
    FDOSBox, FPacker : TList;
    FDOSBoxBasedUserInterpretersPrograms, FDOSBoxBasedUserInterpretersParameters, FDOSBoxBasedUserInterpretersExtensions : TStringList;
    FWindowsBasedEmulatorsNames, FWindowsBasedEmulatorsPrograms, FWindowsBasedEmulatorsParameters, FWindowsBasedEmulatorsExtensions : TStringList;
    Procedure ReadSettings;
    Procedure InitDirs;
    Procedure DoneDirs;
    Function GetDriveLetter(DriveLetter: Char): String;
    Procedure SetDriveLetter(DriveLetter: Char; const Value: String);
    Procedure LoadDOSBoxSettings;
    Procedure DeleteOldDOSBoxSettings;
    Procedure LoadPackerSettings;
    Procedure DeleteOldPackerSettings;
    Procedure LoadStringListSettings;
    Procedure SaveStringListSettings;
    Function GetListCount(Index : Integer) : Integer;
    Function GetDOSBoxSettings(I : Integer) : TDOSBoxSetting;
    Function GetPackerSettings(I : Integer) : TPackerSetting;
  public
    Constructor Create(const SetupFile : String = '');
    Destructor Destroy; override;

    Function AddDOSBoxSettings(const Name : String) : Integer;
    Function DeleteDOSBoxSettings(const ANr : Integer) : Boolean;
    Function SwapDOSBoxSettings(const ANr1, ANr2 : Integer) : Boolean;

    Function AddPackerSettings(const Name : String) : Integer;
    Function DeletePackerSettings(const ANr : Integer) : Boolean;
    Function SwapPackerSettings(const ANr1, ANr2 : Integer) : Boolean;

    property GameDir : String index 0 read GetString write SetString;
    property BaseDir : String index 1 read GetString write SetString;
    property DataDir : String index 2 read GetString write SetString;
    property Language : String index 3 read GetString write SetString;
    property ColOrder : String index 4 read GetString write SetString;
    property ColVisible : String index 5 read GetString write SetString;
    property ListViewStyle : String index 6 read GetString write SetString;
    property PathToFREEDOS : String index 7 read GetString write SetString;
    property UpdateCheckURL : String index 8 read GetString write SetString;
    property GamesListViewBackground : String index 9 read GetString write SetString;
    property GamesListViewFontColor : String index 10 read GetString write SetString;
    property ScreenshotsListViewBackground : String index 11 read GetString write SetString;
    property ScreenshotsListViewFontColor : String index 12 read GetString write SetString;
    property GamesTreeViewBackground : String index 13 read GetString write SetString;
    property GamesTreeViewFontColor : String index 14 read GetString write SetString;
    property ToolbarBackground : String index 15 read GetString write SetString;
    property UserGroups : String index 16 read GetString write SetString;
    property WaveEncMp3 : String index 17 read GetString write SetString;
    property WaveEncOgg : String index 18 read GetString write SetString;
    property WaveEncMp3Parameters : String index 19 read GetString write SetString;
    property WaveEncOggParameters : String index 20 read GetString write SetString;
    property ValueForNotSet : String index 21 read GetString write SetString;
    property ScummVMPath : String index 22 read GetString write SetString;
    property ScummVMAdditionalCommandLine : String index 23 read GetString write SetString;
    property DFendVersion : String index 24 read GetString write SetString;
    property LinuxShellScriptPreamble : String index 25 read GetString write SetString;
    property QBasic : String index 26 read GetString write SetString;
    property QBasicParam : String index 27 read GetString write SetString;
    property LastAddedDriveType : String index 28 read GetString write SetString;
    property QuickStarterDOSBoxTemplate : String index 29 read GetString write SetString;
    property TextEditor : String index 30 read GetString write SetString;
    property ImageViewer : String index 31 read GetString write SetString;
    property SoundPlayer : String index 32 read GetString write SetString;
    property VideoPlayer : String index 33 read GetString write SetString;
    property DeleteToRecycleBin : String index 34 read GetString write SetString;
    property FilterMain : String index 35 read GetString write SetString;
    property FilterSub : String index 36 read GetString write SetString;
    property ColumnWidths : String index 37 read GetString write SetString;
    property ColumnWidthsNoExtraInfoMode : String index 38 read GetString write SetString;
    property CaptureDir : String index 39 read GetString write SetString;
    property IconSet : String index 40 read GetString write SetString;
    property RenameAllExpression : String index 41 read GetString write SetString;
    property DataReaderActiveSettings : String index 42 read GetString write SetString;
    property InstallerNames : String index 43 read GetString write SetString;
    property ExportColumns : String index 44 read GetString write SetString;
    property ArchiveIDFiles : String index 45 read GetString write SetString;
    property LastSelectedProfile : String index 46 read GetString write SetString;
    property DefaultTreeFilter : String index 47 read GetString write SetString;
    property DefaultFloppyDrive : String index 48 read GetString write SetString;

    property LinuxRemap[DriveLetter : Char] : String read GetDriveLetter write SetDriveLetter;

    property DOSBoxBasedUserInterpretersPrograms : TStringList read FDOSBoxBasedUserInterpretersPrograms;
    property DOSBoxBasedUserInterpretersParameters : TStringList read FDOSBoxBasedUserInterpretersParameters;
    property DOSBoxBasedUserInterpretersExtensions : TStringList read FDOSBoxBasedUserInterpretersExtensions;

    property WindowsBasedEmulatorsNames : TStringList read FWindowsBasedEmulatorsNames;
    property WindowsBasedEmulatorsPrograms : TStringList read FWindowsBasedEmulatorsPrograms;
    property WindowsBasedEmulatorsParameters : TStringList read FWindowsBasedEmulatorsParameters;
    property WindowsBasedEmulatorsExtensions : TStringList read FWindowsBasedEmulatorsExtensions;

    property AskBeforeDelete : Boolean index 0 read GetBoolean write SetBoolean;
    property ReopenLastProfileEditorTab : Boolean index 1 read GetBoolean write SetBoolean;
    property MinimizeOnDosBoxStart : Boolean index 2 read GetBoolean write SetBoolean;
    property MainMaximized : Boolean index 3 read GetBoolean write SetBoolean;
    property MinimizeToTray : Boolean index 4 read GetBoolean write SetBoolean;
    property DeleteOnlyInBaseDir : Boolean index 5 read GetBoolean write SetBoolean;
    property ShowScreenshots : Boolean index 6 read GetBoolean write SetBoolean;
    property ShowTree : Boolean index 7 read GetBoolean write SetBoolean;
    property ShowSearchBox : Boolean index 8 read GetBoolean write SetBoolean;
    property ShowExtraInfo : Boolean index 9 read GetBoolean write SetBoolean;
    property StartWithWindows : Boolean index 10 read GetBoolean write SetBoolean;
    property ShowTooltips : Boolean index 11 read GetBoolean write SetBoolean;
    property DFendStyleProfileEditor : Boolean index 12 read GetBoolean write SetBoolean;
    property EasySetupMode : Boolean index 13 read GetBoolean write SetBoolean;
    property AllowMultiFloppyImagesMount : Boolean index 14 read GetBoolean write SetBoolean;
    property AllowPhysFSUsage : Boolean index 15 read GetBoolean write SetBoolean;
    property AllowTextModeLineChange : Boolean index 16 read GetBoolean write SetBoolean;
    property VersionSpecificUpdateCheck : Boolean index 17 read GetBoolean write SetBoolean;
    property UseShortFolderNames : Boolean index 18 read GetBoolean write SetBoolean;
    property AlwaysSetScreenshotFolderAutomatically : Boolean index 19 read GetBoolean write SetBoolean;
    property ShowXMLExportMenuItem : Boolean index 20 read GetBoolean write SetBoolean;
    property ShowXMLImportMenuItem : Boolean index 21 read GetBoolean write SetBoolean;
    property MinimizeOnScummVMStart : Boolean index 22 read GetBoolean write SetBoolean;
    property EnableWineMode : Boolean index 23 read GetBoolean write SetBoolean;
    property LinuxLinkMode : Boolean index 24 read GetBoolean write SetBoolean;
    property RemapMounts : Boolean index 25 read GetBoolean write SetBoolean;
    property RemapScreenShotFolder : Boolean index 26 read GetBoolean write SetBoolean;
    property RemapMapperFile : Boolean index 27 read GetBoolean write SetBoolean;
    property RemapDOSBoxFolder : Boolean index 28 read GetBoolean write SetBoolean;
    property UseCheckSumsForProfiles : Boolean index 29 read GetBoolean write SetBoolean;
    property AllowVGAChipsetSettings : Boolean index 30 read GetBoolean write SetBoolean;
    property AllowGlideSettings : Boolean index 31 read GetBoolean write SetBoolean;
    property AllowPrinterSettings : Boolean index 32 read GetBoolean write SetBoolean;
    property AllowNe2000 : Boolean index 33 read GetBoolean write SetBoolean;
    property AllowInnova : Boolean index 34 read GetBoolean write SetBoolean;
    property ShowToolbar : Boolean index 35 read GetBoolean write SetBoolean;
    property ShowToolbarTexts : Boolean index 36 read GetBoolean write SetBoolean;
    property ShowToolbarButtonClose : Boolean index 37 read GetBoolean write SetBoolean;
    property ShowToolbarButtonRun : Boolean index 38 read GetBoolean write SetBoolean;
    property ShowToolbarButtonRunSetup : Boolean index 39 read GetBoolean write SetBoolean;
    property ShowToolbarButtonAdd : Boolean index 40 read GetBoolean write SetBoolean;
    property ShowToolbarButtonEdit : Boolean index 41 read GetBoolean write SetBoolean;
    property ShowToolbarButtonDelete : Boolean index 42 read GetBoolean write SetBoolean;
    property ShowToolbarButtonHelp : Boolean index 43 read GetBoolean write SetBoolean;
    property RestoreWhenDOSBoxCloses : Boolean index 44 read GetBoolean write SetBoolean;
    property NonFavoritesBold : Boolean index 45 read GetBoolean write SetBoolean;
    property NonFavoritesItalic : Boolean index 46 read GetBoolean write SetBoolean;
    property NonFavoritesUnderline : Boolean index 47 read GetBoolean write SetBoolean;
    property FavoritesBold : Boolean index 48 read GetBoolean write SetBoolean;
    property FavoritesItalic : Boolean index 49 read GetBoolean write SetBoolean;
    property FavoritesUnderline : Boolean index 50 read GetBoolean write SetBoolean;
    property ScreenshotListUseFirstScreenshot : Boolean index 51 read GetBoolean write SetBoolean;
    property FullscreenInfo : Boolean index 52 read GetBoolean write SetBoolean;
    property GridLinesInGamesList : Boolean index 53 read GetBoolean write SetBoolean;
    property QuickStarterMaximized : Boolean index 54 read GetBoolean write SetBoolean;
    property QuickStarterDOSBoxFullscreen : Boolean index 55 read GetBoolean write SetBoolean;
    property QuickStarterDOSBoxAutoClose : Boolean index 56 read GetBoolean write SetBoolean;
    property FileTypeFallbackForEditor : Boolean index 57 read GetBoolean write SetBoolean;
    property AutoFixLineWrap : Boolean index 58 read GetBoolean write SetBoolean;
    property CenterScummVMWindow : Boolean index 59 read GetBoolean write SetBoolean;
    property HideScummVMConsole : Boolean index 60 read GetBoolean write SetBoolean;
    property ShowShortNameWarnings : Boolean index 61 read GetBoolean write SetBoolean;
    property RestoreWhenScummVMCloses : Boolean index 62 read GetBoolean write SetBoolean;
    property UseWindowsExeIcons : Boolean index 63 read GetBoolean write SetBoolean;
    property MinimizeOnWindowsGameStart : Boolean index 64 read GetBoolean write SetBoolean;
    property RestoreWhenWindowsGameCloses : Boolean index 65 read GetBoolean write SetBoolean;
    property RestoreFilter : Boolean index 66 read GetBoolean write SetBoolean;
    property AllowPixelShader : Boolean index 67 read GetBoolean write SetBoolean;
    property StoreColumnWidths : Boolean index 68 read GetBoolean write SetBoolean;
    property RenameProfFileOnRenamingProfile : Boolean index 69 read GetBoolean write SetBoolean;
    property ScanFolderAllGames : Boolean index 70 read GetBoolean write SetBoolean;
    property ScanFolderUseFileName : Boolean index 71 read GetBoolean write SetBoolean;
    property ShowAddGameInfoOnEmptyGamesList : Boolean index 72 read GetBoolean write SetBoolean;
    property RestorePreviewerCategory : Boolean index 73 read GetBoolean write SetBoolean;
    property ShowMainMenu : Boolean index 74 read GetBoolean write SetBoolean;
    property IgnoreDirectoryCollisions : Boolean index 75 read GetBoolean write SetBoolean;
    property CreateConfFilesForProfiles : Boolean index 76 read GetBoolean write SetBoolean;
    property AddMountingDataAutomatically : Boolean index 77 read GetBoolean write SetBoolean;
    property BinaryCache : Boolean index 78 read GetBoolean write SetBoolean;
    property ImportZipWithoutDialogIfPossible : Boolean index 79 read GetBoolean write SetBoolean;
    property DOSBoxStartLogging : Boolean index 80 read GetBoolean write SetBoolean;
    property DataReaderAllPlatforms : Boolean index 81 read GetBoolean write SetBoolean;
    property StoreHistory : Boolean index 82 read GetBoolean write SetBoolean;
    property RestoreLastSelectedProfile : Boolean index 83 read GetBoolean write SetBoolean;
    property OldDeleteMenuItem : Boolean index 84 read GetBoolean write SetBoolean;
    property DefaultUninstall : Boolean index 85 read GetBoolean write SetBoolean;
    property SingleInstance : Boolean index 86 read GetBoolean write SetBoolean;
    property NonModalViewer : Boolean index 87 read GetBoolean write SetBoolean;
    property AllowPackingWindowsGames : Boolean index 88 read GetBoolean write SetBoolean;
    property DataReaderDownloadCompleteMediaLibrary : Boolean index 89 read GetBoolean write SetBoolean;
    property OfferRunAsAdmin : Boolean index 90 read GetBoolean write SetBoolean;
    {property ActivateIncompleteFeatures : Boolean index 91 read GetBoolean write SetBoolean;}

    property MainLeft : Integer index 0 read GetInteger write SetInteger;
    property MainTop : Integer index 1 read GetInteger write SetInteger;
    property MainWidth : Integer index 2 read GetInteger write SetInteger;
    property MainHeight : Integer index 3 read GetInteger write SetInteger;
    property TreeWidth : Integer index 4 read GetInteger write SetInteger;
    property ScreenshotHeight : Integer index 5 read GetInteger write SetInteger;
    property ScreenshotPreviewSize : Integer index 6 read GetInteger write SetInteger;
    property AddButtonFunction : Integer index 7 read GetInteger write SetInteger;
    property CheckForUpdates : Integer index 8 read GetInteger write SetInteger;
    property LastUpdateCheck : Integer index 9 read GetInteger write SetInteger;
    property StartWindowSize : Integer index 10 read GetInteger write SetInteger;
    property GamesListViewFontSize : Integer index 11 read GetInteger write SetInteger;
    property ScreenshotsListViewFontSize : Integer index 12 read GetInteger write SetInteger;
    property GamesTreeViewFontSize : Integer index 13 read GetInteger write SetInteger;
    property ToolbarFontSize : Integer index 14 read GetInteger write SetInteger;
    property CompressionLevel : Integer index 15 read GetInteger write SetInteger;
    property ScreenshotListViewWidth : Integer index 16 read GetInteger write SetInteger;
    property ScreenshotListViewHeight : Integer index 17 read GetInteger write SetInteger;
    property QuickStarterLeft : Integer index 18 read GetInteger write SetInteger;
    property QuickStarterTop : Integer index 19 read GetInteger write SetInteger;
    property QuickStarterWidth : Integer index 20 read GetInteger write SetInteger;
    property QuickStarterHeight : Integer index 21 read GetInteger write SetInteger;
    property ScreenshotListUseFirstScreenshotNr : Integer index 22 read GetInteger write SetInteger;
    property DOSBoxShortFileNameAlgorithm : Integer index 23 read GetInteger write SetInteger;
    property LastWizardMode : Integer index 24 read GetInteger write SetInteger;
    property IconSize : Integer index 25 read GetInteger write SetInteger;
    property ImageFilter : Integer index 26 read GetInteger write SetInteger;
    property NoteLinesInTooltips : Integer index 27 read GetInteger write SetInteger;
    property PreviewerCategory : Integer index 28 read GetInteger write SetInteger;
    property LanguageEditorViewMode : Integer index 29 read GetInteger write SetInteger;
    property LastDataReaderUpdateCheck : Integer index 30 read GetInteger write SetInteger;
    property DataReaderCheckForUpdates : Integer index 31 read GetInteger write SetInteger;
    property PackageListsCheckForUpdates : Integer index 32 read GetInteger write SetInteger;
    property LastPackageListeUpdateCheck : Integer index 33 read GetInteger write SetInteger;
    property CheatsDBCheckForUpdates : Integer index 34 read GetInteger write SetInteger;
    property LastCheatsDBUpdateCheck : Integer index 35 read GetInteger write SetInteger;
    property DOSBoxStartFailedTimeout : Integer index 36 read GetInteger write SetInteger;
    property DataReaderMaxImages : Integer index 37 read GetInteger write SetInteger;
    property ThumbnailCacheSize : Integer index 38 read GetInteger write SetInteger;
    property DataReaderSource : Integer index 39 read GetInteger write SetInteger;

    property DOSBoxSettingsCount : Integer index 0 read GetListCount;
    property DOSBoxSettings[I : Integer] : TDOSBoxSetting read GetDOSBoxSettings;

    property PackerSettingsCount : Integer index 1 read GetListCount;
    property PackerSettings[I : Integer] : TPackerSetting read GetPackerSettings;
end;

var PrgSetup : TPrgSetup;

Function PrgDataDir : String;

Function WineSupportEnabled : Boolean;

Procedure DOSBoxSettingToDOSBoxData(const DOSBoxSetting : TDOSBoxSetting; var DOSBoxData : TDOSBoxData);
Procedure DOSBoxDataToDOSBoxSetting(const DOSBoxData : TDOSBoxData; const DOSBoxSetting : TDOSBoxSetting);
Procedure InitDOSBoxData(var DOSBoxData : TDOSBoxData);

implementation

uses ShlObj, SysUtils, Forms, Math, CommonTools, PrgConsts, GameDBToolsUnit;

{ TDOSBoxSetting }

constructor TDOSBoxSetting.Create(const APrgSetup: TBasePrgSetup; const ANr: Integer);
begin
  inherited Create;
  FPrgSetup:=APrgSetup;
  FNr:=ANr;
  ReadSettings;
  InitDirs;
end;

destructor TDOSBoxSetting.Destroy;
begin
  DoneDirs;
  WriteSettings;
  inherited Destroy;
end;

procedure TDOSBoxSetting.ReadSettings;
Var Section : String;
begin
  If FNr=0 then Section:='ProgramSets' else Section:='DOSBox-'+IntToStr(FNr+1);

  If FNr=0 then FName:='Default' else FName:=FPrgSetup.MemIni.ReadString(Section,'Name','');

  FDosBoxDir:=FPrgSetup.MemIni.ReadString(Section,'Location','');
  FDosBoxMapperFile:=FPrgSetup.MemIni.ReadString(Section,'LocationMap','.\mapper.map');
  FDosBoxLanguage:=FPrgSetup.MemIni.ReadString(Section,'DosBoxLanguageFile','');
  FSDLVideodriver:=FPrgSetup.MemIni.ReadString(Section,'SDLVideodriver','DirectX');
  FCommandLineParameters:=FPrgSetup.MemIni.ReadString(Section,'CommandLineParameters','');
  FCustomSettings:=FPrgSetup.MemIni.ReadString(Section,'CustomSettings','');

  FKeyboardLayout:=FPrgSetup.MemIni.ReadString(Section,'KeyboardLayout','');
  FCodepage:=FPrgSetup.MemIni.ReadString(Section,'Codepage','');

  FHideDosBoxConsole:=FPrgSetup.MemIni.ReadBool(Section,'Hideconsole',True);
  FCenterDOSBoxWindow:=FPrgSetup.MemIni.ReadBool(Section,'CenterDOSBoxWindow',False);
  FDisableScreensaver:=FPrgSetup.MemIni.ReadBool(Section,'DisableScreensaver',False);
  FWaitOnError:=FPrgSetup.MemIni.ReadBool(Section,'WaitOnError',True);
end;

procedure TDOSBoxSetting.WriteSettings;
Var Section : String;
begin
  If FNr=0 then Section:='ProgramSets' else Section:='DOSBox-'+IntToStr(FNr+1);

  If FNr<>0 then PrgSetup.MemIni.WriteString(Section,'Name',FName);

  FPrgSetup.MemIni.WriteString(Section,'Location',FDosBoxDir);
  FPrgSetup.MemIni.WriteString(Section,'LocationMap',FDosBoxMapperFile);
  FPrgSetup.MemIni.WriteString(Section,'DosBoxLanguageFile',FDosBoxLanguage);
  FPrgSetup.MemIni.WriteString(Section,'SDLVideodriver',FSDLVideodriver);
  FPrgSetup.MemIni.WriteString(Section,'CommandLineParameters',FCommandLineParameters);
  FPrgSetup.MemIni.WriteString(Section,'CustomSettings',FCustomSettings);

  FPrgSetup.MemIni.WriteString(Section,'KeyboardLayout',FKeyboardLayout);
  FPrgSetup.MemIni.WriteString(Section,'Codepage',Codepage);

  FPrgSetup.MemIni.WriteBool(Section,'Hideconsole',FHideDosBoxConsole);
  FPrgSetup.MemIni.WriteBool(Section,'CenterDOSBoxWindow',FCenterDOSBoxWindow);
  FPrgSetup.MemIni.WriteBool(Section,'DisableScreensaver',FDisableScreensaver);
  FPrgSetup.MemIni.WriteBool(Section,'WaitOnError',FWaitOnError);

  FPrgSetup.UpdateFile;
end;

procedure TDOSBoxSetting.InitDirs;
begin
  If OperationMode=omPortable then begin
    FDosBoxDir:=MakeExtAbsPath(FDosBoxDir,PrgDir);
    FDosBoxLanguage:=MakeExtAbsPath(FDosBoxLanguage,PrgDir);
    If (not FileExists(FDosBoxLanguage)) and FileExists(IncludeTrailingPathDelimiter(FDosBoxDir)+ExtractFileName(FDosBoxLanguage)) then
      FDosBoxLanguage:=IncludeTrailingPathDelimiter(FDosBoxDir)+ExtractFileName(FDosBoxLanguage);
  end;
end;

procedure TDOSBoxSetting.DoneDirs;
begin
  If OperationMode=omPortable then begin
    DosBoxDir:=MakeExtRelPath(DosBoxDir,PrgDir);
    DosBoxLanguage:=MakeExtRelPath(DosBoxLanguage,PrgDir);
  end;
end;

{ TPackerSetting }

constructor TPackerSetting.Create(const APrgSetup: TBasePrgSetup; const ANr: Integer);
begin
  inherited Create;
  FPrgSetup:=APrgSetup;
  FNr:=ANr;
  ReadSettings;
end;

destructor TPackerSetting.Destroy;
begin
  WriteSettings;
  inherited Destroy;
end;

procedure TPackerSetting.ReadSettings;
Var Section : String;
begin
  Section:='Packer-'+IntToStr(FNr+1);

  FName:=FPrgSetup.MemIni.ReadString(Section,'Name','');
  FZipFileName:=FPrgSetup.MemIni.ReadString(Section,'Filename','');
  FFileExtensions:=FPrgSetup.MemIni.ReadString(Section,'FileExtensions','');
  FExtractFile:=FPrgSetup.MemIni.ReadString(Section,'ExtractFile','');
  FCreateFile:=FPrgSetup.MemIni.ReadString(Section,'CreateFile','');
  FUpdateFile:=FPrgSetup.MemIni.ReadString(Section,'UpdateFile','');
  FTrailingBackslash:=FPrgSetup.MemIni.ReadBool(Section,'TrailingBackslash',True);
end;

procedure TPackerSetting.WriteSettings;
Var Section : String;
begin
  Section:='Packer-'+IntToStr(FNr+1);

  PrgSetup.MemIni.WriteString(Section,'Name',FName);
  PrgSetup.MemIni.WriteString(Section,'Filename',FZipFileName);
  PrgSetup.MemIni.WriteString(Section,'FileExtensions',FFileExtensions);
  PrgSetup.MemIni.WriteString(Section,'ExtractFile',FExtractFile);
  PrgSetup.MemIni.WriteString(Section,'CreateFile',FCreateFile);
  PrgSetup.MemIni.WriteString(Section,'UpdateFile',FUpdateFile);
  PrgSetup.MemIni.WriteBool(Section,'TrailingBackslash',FTrailingBackslash);

  FPrgSetup.UpdateFile;
end;

{ TPrgSetup }

constructor TPrgSetup.Create(const SetupFile : String);
begin
  If SetupFile=''
    then inherited Create(PrgDataDir+SettingsFolder+'\'+MainSetupFile)
    else inherited Create(SetupFile);

  ReadSettings;
  InitDirs;
  If ExtUpperCase(Language)='Deutsch.ini' then Language:='German.ini';

  FDOSBox:=TList.Create;
  FPacker:=TList.Create;
  FDOSBoxBasedUserInterpretersPrograms:=TStringList.Create;
  FDOSBoxBasedUserInterpretersParameters:=TStringList.Create;
  FDOSBoxBasedUserInterpretersExtensions:=TStringList.Create;
  FWindowsBasedEmulatorsNames:=TStringList.Create;
  FWindowsBasedEmulatorsPrograms:=TStringList.Create;
  FWindowsBasedEmulatorsParameters:=TStringList.Create;
  FWindowsBasedEmulatorsExtensions:=TStringList.Create;
  LoadDOSBoxSettings;
  LoadPackerSettings;
  LoadStringListSettings;
end;

destructor TPrgSetup.Destroy;
Var I : Integer;
begin
  DeleteOldDOSBoxSettings;
  For I:=0 to FDOSBox.Count-1 do TDOSBoxSetting(FDOSBox[I]).Free;
  FDOSBox.Free;

  DeleteOldPackerSettings;
  For I:=0 to FPacker.Count-1 do TPackerSetting(FPacker[I]).Free;
  FPacker.Free;

  SaveStringListSettings;
  FDOSBoxBasedUserInterpretersPrograms.Free;
  FDOSBoxBasedUserInterpretersParameters.Free;
  FDOSBoxBasedUserInterpretersExtensions.Free;
  FWindowsBasedEmulatorsNames.Free;
  FWindowsBasedEmulatorsPrograms.Free;
  FWindowsBasedEmulatorsParameters.Free;
  FWindowsBasedEmulatorsExtensions.Free;  

  DoneDirs;
  inherited Destroy;
end;

Procedure TPrgSetup.LoadDOSBoxSettings;
Var I : Integer;
begin
  FDOSBox.Add(TDOSBoxSetting.Create(self,0));
  For I:=2 to MaxInt-1 do begin
    If not MemIni.SectionExists('DOSBox-'+IntToStr(I)) then break;
    FDOSBox.Add(TDOSBoxSetting.Create(self,I-1));
  end;
end;

Procedure TPrgSetup.DeleteOldDOSBoxSettings;
Var I : Integer;
begin
  I:=FDOSBox.Count+1;
  While MemIni.SectionExists('DOSBox-'+IntToStr(I)) do begin
    MemIni.EraseSection('DOSBox-'+IntToStr(I));
    Inc(I);
  end;
end;

Procedure TPrgSetup.LoadPackerSettings;
Var I : Integer;
begin
  For I:=1 to MaxInt-1 do begin
    If not MemIni.SectionExists('Packer-'+IntToStr(I)) then break;
    FPacker.Add(TPackerSetting.Create(self,I-1));
  end;
end;

Procedure TPrgSetup.DeleteOldPackerSettings;
Var I : Integer;
begin
  I:=FPacker.Count+1;
  While MemIni.SectionExists('Packer-'+IntToStr(I)) do begin
    MemIni.EraseSection('Packer-'+IntToStr(I));
    Inc(I);
  end;
end;

Procedure TPrgSetup.LoadStringListSettings;
Var I : Integer;
    S,T,U,V : String;
begin
  {DOSBox based user interpreters}
  For I:=0 to 99 do begin
    S:=Trim(GetString(500+I));
    T:=Trim(GetString(600+I));
    U:=Trim(GetString(700+I));
    If (S<>'') or (T<>'') or (U<>'') then begin
      If (OperationMode=omPortable) and (S<>'') then S:=MakeExtAbsPath(S,PrgDir);
      FDOSBoxBasedUserInterpretersPrograms.Add(S);
      FDOSBoxBasedUserInterpretersParameters.Add(T);
      FDOSBoxBasedUserInterpretersExtensions.Add(U);
    end;
  end;

  {Windows based emulators}
  For I:=0 to 99 do begin
    S:=Trim(GetString(800+I));
    T:=Trim(GetString(900+I));
    U:=Trim(GetString(1000+I));
    V:=Trim(GetString(1100+I));
    If (S<>'') or (T<>'') or (U<>'') or (V<>'') then begin
      FWindowsBasedEmulatorsNames.Add(S);
      If (OperationMode=omPortable) and (T<>'') then T:=MakeExtAbsPath(T,PrgDir);
      FWindowsBasedEmulatorsPrograms.Add(T);
      FWindowsBasedEmulatorsParameters.Add(U);
      FWindowsBasedEmulatorsExtensions.Add(V);
    end;
  end;
end;

Procedure TPrgSetup.SaveStringListSettings;
Var I,M : Integer;
    S,T,U,V : String;
begin
  {DOSBox based user interpreters}
  M:=Max(Max(FDOSBoxBasedUserInterpretersPrograms.Count,FDOSBoxBasedUserInterpretersParameters.Count),FDOSBoxBasedUserInterpretersExtensions.Count);
  For I:=0 to M-1 do begin
    If I<FDOSBoxBasedUserInterpretersPrograms.Count then S:=Trim(FDOSBoxBasedUserInterpretersPrograms[I]) else S:='';
    If I<FDOSBoxBasedUserInterpretersParameters.Count then T:=Trim(FDOSBoxBasedUserInterpretersParameters[I]) else T:='';
    If I<FDOSBoxBasedUserInterpretersExtensions.Count then U:=Trim(FDOSBoxBasedUserInterpretersExtensions[I]) else U:='';
    If (OperationMode=omPortable) and (S<>'') then S:=MakeExtRelPath(S,PrgDir);
    SetString(500+I,S);
    SetString(600+I,T);
    SetString(700+I,U);
  end;
  For I:=M to 99 do begin
    SetString(500+I,'');
    SetString(600+I,'');
    SetString(700+I,'');
  end;

  {Windows based emulators}
  M:=Max(Max(Max(FWindowsBasedEmulatorsNames.Count,FWindowsBasedEmulatorsPrograms.Count),FWindowsBasedEmulatorsParameters.Count),FWindowsBasedEmulatorsExtensions.Count);
  For I:=0 to M-1 do begin
    If I<FWindowsBasedEmulatorsNames.Count then S:=Trim(FWindowsBasedEmulatorsNames[I]) else S:='';
    If I<FWindowsBasedEmulatorsPrograms.Count then T:=Trim(FWindowsBasedEmulatorsPrograms[I]) else T:='';
    If I<FWindowsBasedEmulatorsParameters.Count then U:=Trim(FWindowsBasedEmulatorsParameters[I]) else U:='';
    If I<FWindowsBasedEmulatorsExtensions.Count then V:=Trim(FWindowsBasedEmulatorsExtensions[I]) else V:='';
    If (OperationMode=omPortable) and (T<>'') then T:=MakeExtRelPath(T,PrgDir);
    SetString(800+I,S);
    SetString(900+I,T);
    SetString(1000+I,U);
    SetString(1100+I,V);
  end;
  For I:=M to 99 do begin
    SetString(800+I,'');
    SetString(900+I,'');
    SetString(1000+I,'');
    SetString(1100+I,'');
  end;
end;

procedure TPrgSetup.ReadSettings;
Var I : Integer;
begin
  AddStringRec(0,'ProgramSets','DefGameLoc',PrgDataDir+'VirtualHD\');
  AddStringRec(1,'ProgramSets','DefLoc',PrgDataDir);
  AddStringRec(2,'ProgramSets','DefDataLoc',PrgDataDir+'GameData\');
  AddStringRec(3,'ProgramSets','LanguageFile','English.ini');
  AddStringRec(4,'ProgramSets','ColOrder','12345678');
  AddStringRec(5,'ProgramSets','ColVisible','11111100');
  AddStringRec(6,'ProgramSets','ILVS','List');
  AddStringRec(7,'ProgramSets','PathToFREEDOS','.\VirtualHD\FREEDOS\');
  AddStringRec(8,'ProgramSets','UpdateCheckURL',DFRHomepage+'UpdateInfo.txt');
  AddStringRec(9,'ProgramSets','GamesListViewBackground','');
  AddStringRec(10,'ProgramSets','GamesListViewFontColor','clWindowText');
  AddStringRec(11,'ProgramSets','ScreenshotsListViewBackground','');
  AddStringRec(12,'ProgramSets','ScreenshotsListViewFontColor','clWindowText');
  AddStringRec(13,'ProgramSets','GamesTreeViewBackground','');
  AddStringRec(14,'ProgramSets','GamesTreeViewFontColor','clWindowText');
  AddStringRec(15,'ProgramSets','ToolbarBackground','');
  AddStringRec(16,'ProgramSets','UserGroups','');
  AddStringRec(17,'ProgramSets','WaveEncMp3','');
  AddStringRec(18,'ProgramSets','WaveEncOgg','');
  AddStringRec(19,'ProgramSets','WaveEncMp3Parameters','-h -V 0 "%1" "%2"');
  AddStringRec(20,'ProgramSets','WaveEncOggParameters','"%1" --output="%2" --quality=10');
  AddStringRec(21,'ProgramSets','ValueForNotSet','');
  AddStringRec(22,'ProgramSets','ScummVMPath','');
  AddStringRec(23,'ProgramSets','ScummVMAdditionalCommandLine','');
  AddStringRec(24,'ProgramSets','ProgramVersion','');
  AddStringRec(25,'WineSupport','ShellScriptPreamble','#!/bin/bash');
  AddStringRec(26,'ProgramSets','QBasic','');
  AddStringRec(27,'ProgramSets','QBasicParams','/run %s');
  AddStringRec(28,'ProgramSets','LastAddedDriveType','Drive');
  AddStringRec(29,'ProgramSets','QuickStarterDOSBoxTemplate','');
  AddStringRec(30,'ProgramSets','TextEditor','');
  AddStringRec(31,'ProgramSets','ImageViewer','');
  AddStringRec(32,'ProgramSets','SoundPlayer','');
  AddStringRec(33,'ProgramSets','VideoPlayer','');
  AddStringRec(34,'ProgramSets','DeleteToRecycleBin','1011110');
  AddStringRec(35,'ProgramSets','FilterMain','');
  AddStringRec(36,'ProgramSets','FilterSub','');
  AddStringRec(37,'ProgramSets','ColWidths','');
  AddStringRec(38,'ProgramSets','ColumnWidthsNoExtraInfoMode','');
  AddStringRec(39,'ProgramSets','CaptureDefaultPath','.\'+CaptureSubDir+'\');
  AddStringRec(40,'ProgramSets','IconSet','Modern');
  AddStringRec(41,'ProgramSets','RenameAllExpression','%P_%N.%E');
  AddStringRec(42,'ProgramSets','ActiveDataReaderFields','-XXXXX');
  AddStringRec(43,'ProgramSets','InstallerNames',DefaultInstallerNames);
  AddStringRec(44,'ProgramSets','ExportColumns','XXXXXXXXX');
  AddStringRec(45,'ProgramSets','ArchiveIDFiles',DefaultArchiveIDFiles);
  AddStringRec(46,'ProgramSets','LastSelectedProfile','');
  AddStringRec(47,'ProgramSets','DefaultTreeFilter','11111111');
  AddStringRec(48,'ProgramSets','DefaultFloppyDrive','');

  For I:=0 to 25 do AddStringRec(450+I,'WineSupport',chr(ord('A')+I),'');

  {DOSBox based user interpreters}
  For I:=0 to 99 do AddStringRec(500+I,'Interpreters','Program'+IntToStr(I+1),'');
  For I:=0 to 99 do AddStringRec(600+I,'Interpreters','Parameters'+IntToStr(I+1),'');
  For I:=0 to 99 do AddStringRec(700+I,'Interpreters','Extensions'+IntToStr(I+1),'');

  {Windows based emulators}
  For I:=0 to 99 do AddStringRec(800+I,'WindowsBasedEmulators','Name'+IntToStr(I+1),'');
  For I:=0 to 99 do AddStringRec(900+I,'WindowsBasedEmulators','Program'+IntToStr(I+1),'');
  For I:=0 to 99 do AddStringRec(1000+I,'WindowsBasedEmulators','Parameters'+IntToStr(I+1),'');
  For I:=0 to 99 do AddStringRec(1100+I,'WindowsBasedEmulators','Extensions'+IntToStr(I+1),'');

  AddBooleanRec(0,'ProgramSets','AskBeforeDelete',True);
  AddBooleanRec(1,'ProgramSets','ShowLastTab',False);
  AddBooleanRec(2,'ProgramSets','Minimize',False);
  AddBooleanRec(3,'ProgramSets','MainMaximized',False);
  AddBooleanRec(4,'ProgramSets','MinimizeToTray',False);
  AddBooleanRec(5,'ProgramSets','DeleteOnlyInBaseDir',True);
  AddBooleanRec(6,'ProgramSets','ShowThumbNails',True);
  AddBooleanRec(7,'ProgramSets','ShowFilterTree',True);
  AddBooleanRec(8,'ProgramSets','ShowSearchBox',True);
  AddBooleanRec(9,'ProgramSets','ShowExtrainfo',True);
  AddBooleanRec(10,'ProgramSets','StartWithWindows',False);
  AddBooleanRec(11,'ProgramSets','TooltipsInGamesList',True);
  AddBooleanRec(12,'ProgramSets','DFendStyleProfileEditor',False);
  AddBooleanRec(13,'ProgramSets','EasySetup',True);
  AddBooleanRec(14,'ProgramSets','AllowMultiFloppyImagesMount',False);
  AddBooleanRec(15,'ProgramSets','AllowPhysFSUsage',False);
  AddBooleanRec(16,'ProgramSets','AllowTextModeLineChange',False);
  AddBooleanRec(17,'ProgramSets','VersionSpecificUpdateCheck',True);
  AddBooleanRec(18,'ProgramSets','UseShortFolderNames',True);
  AddBooleanRec(19,'ProgramSets','AlwaysSetScreenshotFolderAutomatically',True);
  AddBooleanRec(20,'ProgramSets','ShowXMLExportMenuItem',False);
  AddBooleanRec(21,'ProgramSets','ShowXMLImportMenuItem',False);
  AddBooleanRec(22,'ProgramSets','MinimizeOnScummVMStart',False);
  AddBooleanRec(23,'WineSupport','Enable',False);
  AddBooleanRec(24,'WineSupport','LinuxLinkMode',False);
  AddBooleanRec(25,'WineSupport','RemapMounts',False);
  AddBooleanRec(26,'WineSupport','RemapScreenshotFolder',False);
  AddBooleanRec(27,'WineSupport','RemapMapperFile',False);
  AddBooleanRec(28,'WineSupport','RemapDOSBoxFolder',False);
  AddBooleanRec(29,'ProgramSets','UseCheckSumsForProfiles',True);
  AddBooleanRec(30,'ProgramSets','AllowVGAChipsetSettings',False);
  AddBooleanRec(31,'ProgramSets','AllowGlideSettings',False);
  AddBooleanRec(32,'ProgramSets','AllowPrinterSettings',False);
  AddBooleanRec(33,'ProgramSets','AllowNe2000',False);
  AddBooleanRec(34,'ProgramSets','AllowInnova',False);
  AddBooleanRec(35,'ProgramSets','ShowToolbar',True);
  AddBooleanRec(36,'ProgramSets','ShowToolbarCaptions',True);
  AddBooleanRec(37,'ProgramSets','ShowToolbarButtonClose',False);
  AddBooleanRec(38,'ProgramSets','ShowToolbarButtonRun',True);
  AddBooleanRec(39,'ProgramSets','ShowToolbarButtonRunSetup',False);
  AddBooleanRec(40,'ProgramSets','ShowToolbarButtonAdd',True);
  AddBooleanRec(41,'ProgramSets','ShowToolbarButtonEdit',True);
  AddBooleanRec(42,'ProgramSets','ShowToolbarButtonDelete',True);
  AddBooleanRec(43,'ProgramSets','ShowToolbarButtonHelp',True);
  AddBooleanRec(44,'ProgramSets','RestoreWindowWhenDOSBoxCloses',False);
  AddBooleanRec(45,'ProgramSets','NonFavorites.Bold',False);
  AddBooleanRec(46,'ProgramSets','NonFavorites.Italic',False);
  AddBooleanRec(47,'ProgramSets','NonFavorites.Underline',False);
  AddBooleanRec(48,'ProgramSets','Favorites.Bold',True);
  AddBooleanRec(49,'ProgramSets','Favorites.Italic',False);
  AddBooleanRec(50,'ProgramSets','Favorites.Underline',False);
  AddBooleanRec(51,'ProgramSets','ScreenshotsGamesList.UseFirstScreenshot',True);
  AddBooleanRec(52,'ProgramSets','ShowFullscreenInfo',True);
  AddBooleanRec(53,'ProgramSets','GridLinesInGamesList',False);
  AddBooleanRec(54,'ProgramSets','QuickStarterMaximized',False);
  AddBooleanRec(55,'ProgramSets','QuickStarterDOSBoxFullscreen',False);
  AddBooleanRec(56,'ProgramSets','QuickStarterDOSBoxAutoClose',True);
  AddBooleanRec(57,'ProgramSets','FileTypeFallbackForEditor',True);
  AddBooleanRec(58,'ProgramSets','AutoFixLineWrap',False);
  AddBooleanRec(59,'ProgramSets','CenterScummVMWindow',False);
  AddBooleanRec(60,'ProgramSets','HideScummVMConsole',True);
  AddBooleanRec(61,'ProgramSets','ShowShortNameWarnings',True);
  AddBooleanRec(62,'ProgramSets','RestoreWhenScummVMCloses',False);
  AddBooleanRec(63,'ProgramSets','UseWindowsExeIcons',True);
  AddBooleanRec(64,'ProgramSets','MinimizeOnWindowsGameStart',False);
  AddBooleanRec(65,'ProgramSets','RestoreWhenWindowsGameCloses',False);
  AddBooleanRec(66,'ProgramSets','RestoreFilter',True);
  AddBooleanRec(67,'ProgramSets','AllowPixelShader',False);
  AddBooleanRec(68,'ProgramSets','StoreColWidths',False);
  AddBooleanRec(69,'ProgramSets','RenameProfFileOnRenamingProfile',False);
  AddBooleanRec(70,'ProgramSets','ScanFolderAllGames',False);
  AddBooleanRec(71,'ProgramSets','ScanFolderUseFileName',True);
  AddBooleanRec(72,'ProgramSets','ShowAddGameInfoOnEmptyGamesList',True);
  AddBooleanRec(73,'ProgramSets','RestorePreviewerCategory',True);
  AddBooleanRec(74,'ProgramSets','ShowMainMenu',True);
  AddBooleanRec(75,'ProgramSets','IgnoreDirectoryCollisions',False);
  AddBooleanRec(76,'ProgramSets','CreateConfFilesForProfiles',False);
  AddBooleanRec(77,'ProgramSets','AddMountingDataAutomatically',True);
  AddBooleanRec(78,'ProgramSets','BinaryCache',True);
  AddBooleanRec(79,'ProgramSets','ImportZipWithoutDialogIfPossible',True);
  AddBooleanRec(80,'ProgramSets','DOSBoxStartLogging',False);
  AddBooleanRec(81,'ProgramSets','DataReaderAllPlatforms',False);
  AddBooleanRec(82,'ProgramSets','StoreHistory',True);
  AddBooleanRec(83,'ProgramSets','RestoreLastSelectedProfile',False);
  AddBooleanRec(84,'ProgramSets','OldDeleteMenuItem',False);
  AddBooleanRec(85,'ProgramSets','DefaultUninstall',True);
  AddBooleanRec(86,'ProgramSets','SingleInstanceOnly',True);
  AddBooleanRec(87,'ProgramSets','NonModalViewer',False);
  AddBooleanRec(88,'ProgramSets','AllowPackingWindowsGames',False);
  AddBooleanRec(89,'ProgramSets','DataReaderDownloadCompleteMediaLibrary',True);
  AddBooleanRec(90,'ProgramSets','OfferRunAsAdmin',False);
  {AddBooleanRec(91,'ProgramSets','ActivateIncompleteFeatures',False);}

  AddIntegerRec(0,'ProgramSets','MainLeft',-1);
  AddIntegerRec(1,'ProgramSets','MainTop',-1);
  AddIntegerRec(2,'ProgramSets','MainWidth',-1);
  AddIntegerRec(3,'ProgramSets','MainHeight',-1);
  AddIntegerRec(4,'ProgramSets','TreeWidth',-1);
  AddIntegerRec(5,'ProgramSets','ScreenshotHeight',-1);
  AddIntegerRec(6,'ProgramSets','ScreenshotPreviewHeight',100);
  AddIntegerRec(7,'ProgramSets','AddButtonFunction',2);
  AddIntegerRec(8,'ProgramSets','CheckForUpdates',0);
  AddIntegerRec(9,'ProgramSets','LastUpdateCheck',0);
  AddIntegerRec(10,'ProgramSets','StartWindowSize',0);
  AddIntegerRec(11,'ProgramSets','GamesListViewFontSize',9);
  AddIntegerRec(12,'ProgramSets','ScreenshotsListViewFontSize',9);
  AddIntegerRec(13,'ProgramSets','GamesTreeViewFontSize',9);
  AddIntegerRec(14,'ProgramSets','ToolbarFontSize',9);
  AddIntegerRec(15,'ProgramSets','CompressionLevel',3);
  AddIntegerRec(16,'ProgramSets','ScreenshotsGamesList.Width',150);
  AddIntegerRec(17,'ProgramSets','ScreenshotsGamesList.Height',100);
  AddIntegerRec(18,'ProgramSets','QuickStarterLeft',-1);
  AddIntegerRec(19,'ProgramSets','QuickStarterTop',-1);
  AddIntegerRec(20,'ProgramSets','QuickStarterWidth',-1);
  AddIntegerRec(21,'ProgramSets','QuickStarterHeight',-1);
  AddIntegerRec(22,'ProgramSets','ScreenshotsGamesList.UseScreenshotNr',1);
  AddIntegerRec(23,'ProgramSets','DOSBoxShortFileNameAlgorithm',3);
  AddIntegerRec(24,'ProgramSets','LastWizardMode',1);
  AddIntegerRec(25,'ProgramSets','IconSize',32);
  AddIntegerRec(26,'ProgramSets','ImageFilter',6);
  AddIntegerRec(27,'ProgramSets','NoteLinesInTooltips',5);
  AddIntegerRec(28,'ProgramSets','PreviewerCategory',0);
  AddIntegerRec(29,'ProgramSets','LanguageEditorViewMode',0);
  AddIntegerRec(30,'ProgramSets','LastDataReaderUpdateCheck',0);
  AddIntegerRec(31,'ProgramSets','DataReaderCheckForUpdates',1);
  AddIntegerRec(32,'ProgramSets','PackageListsCheckForUpdates',0);
  AddIntegerRec(33,'ProgramSets','LastPackageListeUpdateCheck',0);
  AddIntegerRec(34,'ProgramSets','CheatsDBCheckForUpdates',0);
  AddIntegerRec(35,'ProgramSets','LastCheatsDBUpdateCheck',0);
  AddIntegerRec(36,'ProgramSets','DOSBoxStartFailedTimeout',3);
  AddIntegerRec(37,'ProgramSets','DataReaderMaxImages',25);
  AddIntegerRec(38,'ProgramSets','ThumbnailCacheSize',500);
  AddIntegerRec(39,'ProgramSets','DataReaderSource',0);
end;

Procedure TPrgSetup.InitDirs;
begin
  If BaseDir='' then BaseDir:=PrgDataDir;
  If GameDir='' then GameDir:=BaseDir+'VirtualHD\';
  If DataDir='' then DataDir:=BaseDir+'GameData\';
  If CaptureDir='' then CaptureDir:=BaseDir+CaptureSubDir+'\';

  If OperationMode=omPortable then begin
    BaseDir:=MakeExtAbsPath(BaseDir,PrgDir);
    GameDir:=MakeExtAbsPath(GameDir,PrgDir);
    DataDir:=MakeExtAbsPath(DataDir,PrgDir);
    CaptureDir:=MakeExtAbsPath(CaptureDir,PrgDir);
    ScummVMPath:=MakeExtAbsPath(ScummVMPath,PrgDir);
    QBasic:=MakeExtAbsPath(QBasic,PrgDir);
    WaveEncOgg:=MakeExtAbsPath(WaveEncOgg,PrgDir);
    WaveEncMp3:=MakeExtAbsPath(WaveEncMp3,PrgDir);

    CaptureDir:=MakeRelPath(CaptureDir,BaseDir);
  end;

  If not FileExists(WaveEncOgg) then begin
    If FileExists(PrgDir+OggEncPrgFile) then WaveEncOgg:=PrgDir+OggEncPrgFile else begin
      If FileExists(PrgDir+BinFolder+'\'+OggEncPrgFile) then WaveEncOgg:=PrgDir+BinFolder+'\'+OggEncPrgFile;
    end;
  end;
end;

procedure TPrgSetup.DoneDirs;
begin
  If OperationMode=omPortable then begin
    CaptureDir:=MakeAbsPath(CaptureDir,BaseDir);

    BaseDir:=MakeExtRelPath(BaseDir,PrgDir);
    GameDir:=MakeExtRelPath(GameDir,PrgDir);
    DataDir:=MakeExtRelPath(DataDir,PrgDir);
    CaptureDir:=MakeExtRelPath(CaptureDir,PrgDir);
    ScummVMPath:=MakeExtRelPath(ScummVMPath,PrgDir);
    QBasic:=MakeExtRelPath(QBasic,PrgDir);
    WaveEncOgg:=MakeExtRelPath(WaveEncOgg,PrgDir);
    WaveEncMp3:=MakeExtRelPath(WaveEncMp3,PrgDir);
  end;
end;

Function TPrgSetup.GetDriveLetter(DriveLetter: Char): String;
begin
  result:=GetString(450+(ord(UpCase(DriveLetter)))-ord('A'));
end;

Procedure TPrgSetup.SetDriveLetter(DriveLetter: Char; const Value: String);
begin
  SetString(450+(ord(UpCase(DriveLetter)))-ord('A'),Value);
end;

Function TPrgSetup.GetListCount(Index : Integer) : Integer;
begin
  Case Index of
    0 : result:=FDOSBox.Count;
    1 : result:=FPacker.Count;
    else result:=0;
  end;
end;

Function TPrgSetup.GetDOSBoxSettings(I : Integer) : TDOSBoxSetting;
begin
  If (I<0) or (I>=FDOSBox.Count) then result:=nil else result:=TDOSBoxSetting(FDOSBox[I]);
end;

Function TPrgSetup.GetPackerSettings(I : Integer) : TPackerSetting;
begin
  If (I<0) or (I>=FPacker.Count) then result:=nil else result:=TPackerSetting(FPacker[I]);
end;

Function TPrgSetup.AddDOSBoxSettings(const Name : String) : Integer;
begin
  result:=FDOSBox.Add(TDOSBoxSetting.Create(self,FDOSBox.Count));
  TDOSBoxSetting(FDOSBox[result]).Name:=Name;
end;

Function TPrgSetup.DeleteDOSBoxSettings(const ANr : Integer) : Boolean;
Var I : Integer;
begin
  result:=(ANr>0) and (ANr<FDOSBox.Count); {do not delete ANr=0}
  If not result then exit;

  TDOSBoxSetting(FDOSBox[ANr]).Free;
  FDOSBox.Delete(ANr);
  For I:=ANr to FDOSBox.Count-1 do TDOSBoxSetting(FDOSBox[I]).Nr:=I;
end;

Function TPrgSetup.SwapDOSBoxSettings(const ANr1, ANr2 : Integer) : Boolean;
begin
  result:=(ANr1>0) and (ANr1<FDOSBox.Count) and (ANr2>0) and (ANr2<FDOSBox.Count);
  If not result then exit;

  FDOSBox.Exchange(ANr1,ANr2);
  TDOSBoxSetting(FDOSBox[ANr1]).Nr:=ANr1;
  TDOSBoxSetting(FDOSBox[ANr2]).Nr:=ANr2;
end;

Function TPrgSetup.AddPackerSettings(const Name : String) : Integer;
begin
  result:=FPacker.Add(TPackerSetting.Create(self,FPacker.Count));
  TPackerSetting(FPacker[result]).Name:=Name;
end;

Function TPrgSetup.DeletePackerSettings(const ANr : Integer) : Boolean;
Var I : Integer;
begin
  result:=(ANr>=0) and (ANr<FPacker.Count);
  If not result then exit;

  TPackerSetting(FPacker[ANr]).Free;
  FPacker.Delete(ANr);
  For I:=ANr to FPacker.Count-1 do TPackerSetting(FPacker[I]).Nr:=I;
end;

Function TPrgSetup.SwapPackerSettings(const ANr1, ANr2 : Integer) : Boolean;
begin
  result:=(ANr1>=0) and (ANr1<FPacker.Count) and (ANr2>=0) and (ANr2<FPacker.Count);
  If not result then exit;

  FPacker.Exchange(ANr1,ANr2);
  TPackerSetting(FPacker[ANr1]).Nr:=ANr1;
  TPackerSetting(FPacker[ANr2]).Nr:=ANr2;
end;

{ global }

Procedure ReadOperationMode;
Var St : TStringList;
    I : Integer;
    S : String;
begin
  OperationMode:=omPrgDir;
  if not FileExists(PrgDir+OperationModeConfig) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(PrgDir+OperationModeConfig); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='PRGDIRMODE' then begin OperationMode:=omPrgDir; exit; end;
      If S='USERDIRMODE' then begin OperationMode:=omUserDir; exit; end;
      If S='PORTABLEMODE' then begin OperationMode:=omPortable; exit; end;
    end;
  finally
    St.Free;
  end;
end;

Function PrgDataDir : String;
begin
  If OperationMode=omUserDir then begin
    result:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_PROFILE))+'D-Fend Reloaded\';
  end else begin
    result:=PrgDir;
  end;
end;

Function WineSupportEnabled : Boolean;
Var S : String;
begin
  If ParamCount=1 then begin
    S:=Trim(ExtUpperCase(ParamStr(1)));
    If (Pos('WINEMODE',S)>0) or (Pos('WINESUPPORTENABLED',S)>0) then begin result:=True; exit; end;
    If (Pos('WINDOWSMODE',S)>0) or (Pos('NOWINESUPPORT',S)>0) or (Pos('WINESUPPORTDISABLED',S)>0) then begin result:=False; exit; end;
  end;
  result:=PrgSetup.EnableWineMode;
end;

Procedure DOSBoxSettingToDOSBoxData(const DOSBoxSetting : TDOSBoxSetting; var DOSBoxData : TDOSBoxData);
begin
  DOSBoxData.Name:=DOSBoxSetting.Name;
  DOSBoxData.DosBoxDir:=DOSBoxSetting.DosBoxDir;
  DOSBoxData.DosBoxMapperFile:=DOSBoxSetting.DosBoxMapperFile;
  DOSBoxData.DosBoxLanguage:=DOSBoxSetting.DosBoxLanguage;
  DOSBoxData.SDLVideodriver:=DOSBoxSetting.SDLVideodriver;
  DOSBoxData.CommandLineParameters:=DOSBoxSetting.CommandLineParameters;
  DOSBoxData.CustomSettings:=DOSBoxSetting.CustomSettings;
  DOSBoxData.KeyboardLayout:=DOSBoxSetting.KeyboardLayout;
  DOSBoxData.Codepage:=DOSBoxSetting.Codepage;
  DOSBoxData.HideDosBoxConsole:=DOSBoxSetting.HideDosBoxConsole;
  DOSBoxData.CenterDOSBoxWindow:=DOSBoxSetting.CenterDOSBoxWindow;
  DOSBoxData.DisableScreensaver:=DOSBoxSetting.DisableScreensaver;
  DOSBoxData.WaitOnError:=DOSBoxSetting.WaitOnError;
end;

Procedure DOSBoxDataToDOSBoxSetting(const DOSBoxData : TDOSBoxData; const DOSBoxSetting : TDOSBoxSetting);
begin
  DOSBoxSetting.Name:=DOSBoxData.Name;
  DOSBoxSetting.DosBoxDir:=DOSBoxData.DosBoxDir;
  DOSBoxSetting.DosBoxMapperFile:=DOSBoxData.DosBoxMapperFile;
  DOSBoxSetting.DosBoxLanguage:=DOSBoxData.DosBoxLanguage;
  DOSBoxSetting.SDLVideodriver:=DOSBoxData.SDLVideodriver;
  DOSBoxSetting.CommandLineParameters:=DOSBoxData.CommandLineParameters;
  DOSBoxSetting.CustomSettings:=DOSBoxData.CustomSettings;
  DOSBoxSetting.KeyboardLayout:=DOSBoxData.KeyboardLayout;
  DOSBoxSetting.Codepage:=DOSBoxData.Codepage;
  DOSBoxSetting.HideDosBoxConsole:=DOSBoxData.HideDosBoxConsole;
  DOSBoxSetting.CenterDOSBoxWindow:=DOSBoxData.CenterDOSBoxWindow;
  DOSBoxSetting.DisableScreensaver:=DOSBoxData.DisableScreensaver;
  DOSBoxSetting.WaitOnError:=DOSBoxData.WaitOnError;
end;

Procedure InitDOSBoxData(var DOSBoxData : TDOSBoxData);
begin
  with DOSBoxData do begin
    Name:='';
    DosBoxDir:='';
    DosBoxMapperFile:='.\mapper.txt';
    DosBoxLanguage:='';
    SDLVideodriver:='DirectX';
    CommandLineParameters:='';
    CustomSettings:='';
    KeyboardLayout:='';
    Codepage:='';
    HideDosBoxConsole:=True;
    CenterDOSBoxWindow:=False;
    DisableScreensaver:=False;
    WaitOnError:=True;
  end;
end;

initialization
  ReadOperationMode;
  UpdateSettingsFilesLocation;
  PrgSetup:=TPrgSetup.Create;
finalization
  PrgSetup.Free;
  PrgSetup:=nil;
end.
