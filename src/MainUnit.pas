unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, XPMan, StdCtrls, ComCtrls, ExtCtrls, ToolWin, ImgList,
  Menus, AppEvnts, ActiveX, GameDBUnit, GameDBToolsUnit, ViewFilesFrameUnit,
  LinkFileUnit, HelpTools, System.ImageList;

{
}

type
  TDFendReloadedMainForm = class(TForm, IDropTarget)
    TreeView: TTreeView;
    Splitter: TSplitter;
    ImageList: TImageList;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuProfileAdd: TMenuItem;
    MenuProfileEdit: TMenuItem;
    MenuProfileDelete: TMenuItem;
    MenuFileSetup: TMenuItem;
    N2: TMenuItem;
    MenuFileQuit: TMenuItem;
    MenuRun: TMenuItem;
    MenuRunGame: TMenuItem;
    MenuRunSetup: TMenuItem;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ButtonRun: TToolButton;
    ToolButton2: TToolButton;
    ButtonAdd: TToolButton;
    ButtonEdit: TToolButton;
    ButtonDelete: TToolButton;
    PopupMenu: TPopupMenu;
    PopupRunGame: TMenuItem;
    PopupRunSetup: TMenuItem;
    N3: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDelete: TMenuItem;
    N4: TMenuItem;
    PopupOpenFolder: TMenuItem;
    PopupMarkAsFavorite: TMenuItem;
    MenuExtras: TMenuItem;
    MenuProfileOpenFolder: TMenuItem;
    MenuProfileMarkAsFavorite: TMenuItem;
    MenuHelp: TMenuItem;
    N5: TMenuItem;
    MenuRunRunDosBox: TMenuItem;
    MenuRunOpenDosBoxConfig: TMenuItem;
    MenuProfile: TMenuItem;
    N6: TMenuItem;
    MenuFileExportGamesList: TMenuItem;
    SaveDialog: TSaveDialog;
    MenuExtrasIconManager: TMenuItem;
    ListviewImageList: TImageList;
    PopupOpenDataFolder: TMenuItem;
    MenuProfileOpenDataFolder: TMenuItem;
    MenuExtrasViewLogs: TMenuItem;
    MenuProfileWWW: TMenuItem;
    PopupWWW: TMenuItem;
    MenuExtrasTemplates: TMenuItem;
    TrayIcon: TTrayIcon;
    ApplicationEvents: TApplicationEvents;
    MenuExtrasOpenGamesFolder: TMenuItem;
    MenuProfileDeinstall: TMenuItem;
    PopupDeinstall: TMenuItem;
    Panel1: TPanel;
    ListView: TListView;
    Splitter1: TSplitter;
    ScreenshotImageList: TImageList;
    MenuView: TMenuItem;
    MenuViewsShowScreenshots: TMenuItem;
    ScreenshotPopupMenu: TPopupMenu;
    ScreenshotPopupOpen: TMenuItem;
    N7: TMenuItem;
    ScreenshotPopupRefresh: TMenuItem;
    N8: TMenuItem;
    ScreenshotPopupDelete: TMenuItem;
    ScreenshotPopupDeleteAll: TMenuItem;
    ScreenshotPopupCopy: TMenuItem;
    ScreenshotPopupSave: TMenuItem;
    ScreenshotSaveDialog: TSaveDialog;
    MenuExtrasDeinstallMultipleGames: TMenuItem;
    MenuFileImport: TMenuItem;
    MenuFileExport: TMenuItem;
    N10: TMenuItem;
    MenuFileCreateConf: TMenuItem;
    MenuFileImportConfFile: TMenuItem;
    OpenDialog: TOpenDialog;
    MenuProfileCopy: TMenuItem;
    PopupCopy: TMenuItem;
    MenuProfileAddWithWizard: TMenuItem;
    MenuHelpDosBox: TMenuItem;
    MenuHelpDosBoxFAQ: TMenuItem;
    MenuHelpDosBoxHotkeys: TMenuItem;
    MenuHelpDosBoxCompatibility: TMenuItem;
    MenuHelpAbandonware: TMenuItem;
    MenuHelpAbout: TMenuItem;
    ToolButton1: TToolButton;
    SearchEdit: TEdit;
    MenuViewsShowTree: TMenuItem;
    MenuViewsShowSearchBox: TMenuItem;
    MenuViewsShowExtraInfo: TMenuItem;
    N12: TMenuItem;
    MenuViewsList: TMenuItem;
    MenuViewsIcons: TMenuItem;
    ListviewIconImageList: TImageList;
    MenuProfileCreateShortcut: TMenuItem;
    PopupCreateShortcut: TMenuItem;
    MenuHelpDosBoxReadme: TMenuItem;
    MenuExtrasCreateImage: TMenuItem;
    MenuHelpDosBoxHotkeysDosbox: TMenuItem;
    MenuHelpDosBoxIntro: TMenuItem;
    MenuHelpDosBoxIntroDosBox: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N16: TMenuItem;
    MenuExtrasTransferProfiles: TMenuItem;
    MenuFileExportBuildInstaller: TMenuItem;
    MenuRunRunDosBoxKeyMapper: TMenuItem;
    MenuHelpDemoCompatibility: TMenuItem;
    MenuProfileAddFromTemplate: TMenuItem;
    AddButtonPopupMenu: TPopupMenu;
    AddButtonMenuAdd: TMenuItem;
    AddButtonMenuAddFromTemplate: TMenuItem;
    AddButtonMenuAddWithWizard: TMenuItem;
    N17: TMenuItem;
    MenuExtrasChangeProfiles: TMenuItem;
    MenuProfileOpenFileInDataFolder: TMenuItem;
    MenuProfileMakeInstaller: TMenuItem;
    PopupMakeInstaller: TMenuItem;
    PopupOpenFileInDataFolder: TMenuItem;
    MenuViewsShowTooltips: TMenuItem;
    MenuHelpUpdates: TMenuItem;
    MenuProfileViewConfFile: TMenuItem;
    PopupViewConfFile: TMenuItem;
    MenuFileImportProfFile: TMenuItem;
    ScreenshotPopupImport: TMenuItem;
    MenuHelpHomepage: TMenuItem;
    MenuViewsListNoIcons: TMenuItem;
    MenuViewsSimpleList: TMenuItem;
    MenuViewsSimpleListNoIcons: TMenuItem;
    MenuViewsSmallIcons: TMenuItem;
    N19: TMenuItem;
    PopupViews: TMenuItem;
    PopupSimpleListNoIcons: TMenuItem;
    PopupSimpleList: TMenuItem;
    PopupListNoIcons: TMenuItem;
    PopupList: TMenuItem;
    PopupSmallIcons: TMenuItem;
    PopupIcons: TMenuItem;
    N20: TMenuItem;
    MenuHelpStatistics: TMenuItem;
    MenuHelpForum: TMenuItem;
    CapturePageControl: TPageControl;
    CaptureScreenshotsTab: TTabSheet;
    CaptureSoundTab: TTabSheet;
    ScreenshotListView: TListView;
    SoundListView: TListView;
    SoundPopupMenu: TPopupMenu;
    SoundPopupOpen: TMenuItem;
    N21: TMenuItem;
    SoundPopupRefresh: TMenuItem;
    N22: TMenuItem;
    SoundPopupImport: TMenuItem;
    SoundPopupSave: TMenuItem;
    SoundPopupDelete: TMenuItem;
    SoundPopupDeleteAll: TMenuItem;
    SoundPopupSaveOgg: TMenuItem;
    SoundPopupSaveMp3: TMenuItem;
    SoundPopupSaveMp3All: TMenuItem;
    SoundPopupSaveOggAll: TMenuItem;
    N23: TMenuItem;
    TreeViewPopupMenu: TPopupMenu;
    TreeViewPopupEditUserFilters: TMenuItem;
    N24: TMenuItem;
    ScreenshotPopupUseAsBackground: TMenuItem;
    ScreenshotPopupRename: TMenuItem;
    SoundPopupRename: TMenuItem;
    MenuExtrasCreateISOImage: TMenuItem;
    MenuFileCreateProf: TMenuItem;
    MenuExtrasCreateIMGImage: TMenuItem;
    MenuExtrasWriteIMGImage: TMenuItem;
    MenuFileCreateXML: TMenuItem;
    MenuExtrasExtractImage: TMenuItem;
    IdleAddonTimer: TTimer;
    MenuExtrasImageFiles: TMenuItem;
    N1: TMenuItem;
    MenuExtrasImageFromFolder: TMenuItem;
    ScreenshotsInfoPanel: TPanel;
    SoundInfoPanel: TPanel;
    TrayIconPopupMenu: TPopupMenu;
    TrayIconPopupRestore: TMenuItem;
    N9: TMenuItem;
    N26: TMenuItem;
    TrayIconPopupClose: TMenuItem;
    TrayIconPopupAddProfile: TMenuItem;
    TrayIconPopupAddFromTemplate: TMenuItem;
    TrayIconPopupAddWithWizard: TMenuItem;
    N27: TMenuItem;
    TrayIconPopupRun: TMenuItem;
    MenuProfileAddScummVM: TMenuItem;
    N28: TMenuItem;
    MenuRunRunScummVM: TMenuItem;
    MenuRunOpenScummVMConfig: TMenuItem;
    AddButtonMenuAddScummVM: TMenuItem;
    PopupViewINIFile: TMenuItem;
    MenuHelpScummVM: TMenuItem;
    MenuProfileViewIniFile: TMenuItem;
    MenuHelpDosBoxHomepage: TMenuItem;
    MenuHelpScummVMReadme: TMenuItem;
    MenuHelpScummVMFAQ: TMenuItem;
    N15: TMenuItem;
    MenuHelpScummVMHomepage: TMenuItem;
    MenuHelpScummVMCompatibility: TMenuItem;
    MenuHelpScummVMCompatibilityIntern: TMenuItem;
    TrayIconPopupAddScummVMProfile: TMenuItem;
    MenuFileImportXMLFile: TMenuItem;
    ButtonClose: TToolButton;
    ButtonRunSetup: TToolButton;
    MenuExtrasCheckProfiles: TMenuItem;
    MenuHelpOperationMode: TMenuItem;
    ZipInfoPanel: TPanel;
    ZipInfoLabel: TLabel;
    CaptureVideoTab: TTabSheet;
    VideoListView: TListView;
    VideoInfoPanel: TPanel;
    VideoPopupMenu: TPopupMenu;
    VideoPopupOpen: TMenuItem;
    MenuItem2: TMenuItem;
    VideoPopupRefresh: TMenuItem;
    MenuItem4: TMenuItem;
    VideoPopupImport: TMenuItem;
    VideoPopupSave: TMenuItem;
    VideoPopupRename: TMenuItem;
    VideoPopupDelete: TMenuItem;
    VideoPopupDeleteAll: TMenuItem;
    VideoPopupOpenExternal: TMenuItem;
    SoundPopupOpenExternal: TMenuItem;
    DataFilesTab: TTabSheet;
    MenuProfileSearchGame: TMenuItem;
    PopupSearchGame: TMenuItem;
    MenuRunExtraFile: TMenuItem;
    PopupRunExtraFile: TMenuItem;
    MenuViewsScreenshots: TMenuItem;
    PopupScreenshots: TMenuItem;
    ListviewScreenshotImageList: TImageList;
    N29: TMenuItem;
    ScreenshotPopupUseInScreenshotList: TMenuItem;
    PopupMakeZipArchive: TMenuItem;
    N30: TMenuItem;
    MenuProfileMakeZipArchive: TMenuItem;
    N31: TMenuItem;
    MenuFileImportZIPFile: TMenuItem;
    MenuFileCreateZIP: TMenuItem;
    MenuProfileAddWindows: TMenuItem;
    AddButtonMenuAddWindows: TMenuItem;
    TrayIconPopupAddWindowsProfile: TMenuItem;
    MenuHelpHelp: TMenuItem;
    MenuHelpHelpContent: TMenuItem;
    MenuHelpIntroduction: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    MenuFileExportBuildZipPackages: TMenuItem;
    MenuHelpAddingGames: TMenuItem;
    MenuProfileOpenCaptureFolder: TMenuItem;
    PopupOpenCaptureFolder: TMenuItem;
    ScreenshotPopupOpenCaptureFolder: TMenuItem;
    SoundPopupOpenCaptureFolder: TMenuItem;
    VideoPopupOpenCaptureFolder: TMenuItem;
    MenuViewsQuickStarter: TMenuItem;
    N18: TMenuItem;
    ScreenshotPopupOpenExternal: TMenuItem;
    MenuExtrasScanGamesFolder: TMenuItem;
    MenuExtrasCreateShortcuts: TMenuItem;
    XPManifest: TXPManifest;
    MenuFileCreateInstaller: TMenuItem;
    N11: TMenuItem;
    ToolbarPopupMenu: TPopupMenu;
    ToolbarPopupSetupButtons: TMenuItem;
    ToolbarPopupSetupIconSet: TMenuItem;
    ToolButton3: TToolButton;
    ButtonHelp: TToolButton;
    MenuFileImportDownload: TMenuItem;
    MenuFileCreateXMlPackageList: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    FirstRunInfoPanel: TPanel;
    FirstRunInfoLabel: TLabel;
    FirstRunInfoButton: TSpeedButton;
    N40: TMenuItem;
    MenuExtrasTranslation: TMenuItem;
    MenuFileExportTransferProfiles: TMenuItem;
    N41: TMenuItem;
    GameNotesPanel: TTabSheet;
    GameNotesEdit: TRichEdit;
    GameNotesToolBar: TToolBar;
    GameNotesCutButton: TToolButton;
    GameNotesCopyButton: TToolButton;
    GameNotesPasteButton: TToolButton;
    ToolButton7: TToolButton;
    GameNotesUndoButton: TToolButton;
    GameNotesImageList: TImageList;
    MenuViewShowMenubar: TMenuItem;
    MenuViewShowToolbar: TMenuItem;
    N34: TMenuItem;
    ToolbarPopupShowMenubar: TMenuItem;
    MenuProfileAddOther: TMenuItem;
    TrayIconPopupAddOther: TMenuItem;
    N43: TMenuItem;
    AddButtonMenuAddOther: TMenuItem;
    ScreenshotPopupRenameAll: TMenuItem;
    SoundPopupRenameAll: TMenuItem;
    VideoPopupRenameAll: TMenuItem;
    MenuProfileAddInstallationSupport: TMenuItem;
    AddButtonMenuAddInstallationSupport: TMenuItem;
    N44: TMenuItem;
    MenuExtrasImageFromProfile: TMenuItem;
    MenuFileImportZIPFileWithInstallationSupport: TMenuItem;
    MenuProfileCheating: TMenuItem;
    PopupCheating: TMenuItem;
    MenuExtrasCheating: TMenuItem;
    MenuExtrasCheatingApply: TMenuItem;
    MenuExtrasCheatingEdit: TMenuItem;
    MenuExtrasCheatingSearch: TMenuItem;
    SearchEditTimer: TTimer;
    MenuFileImportFolder: TMenuItem;
    MenuFileImportFolderWithInstallationSupport: TMenuItem;
    N25: TMenuItem;
    AddButtonMenuAddManually: TMenuItem;
    AddButtonMenuImportZip: TMenuItem;
    MenuExtrasTranslationDOSBox: TMenuItem;
    MenuExtrasTranslationDFendReloaded: TMenuItem;
    MenuProfileAddManually: TMenuItem;
    MenuProfileImportZip: TMenuItem;
    N45: TMenuItem;
    AddButtonMenuAddGetGames: TMenuItem;
    MenuHelpGetGames: TMenuItem;
    N47: TMenuItem;
    AddButtonMenuDownloadPackages: TMenuItem;
    MenuProfileDownloadPackages: TMenuItem;
    N46: TMenuItem;
    N48: TMenuItem;
    MenuRunDOSBoxOutputTest: TMenuItem;
    PopupOpenFileInProgramFolder: TMenuItem;
    MenuProfileOpenFileInProgramFolder: TMenuItem;
    PopupOpenFolderDOSBox: TMenuItem;
    MenuProfileOpenFolderDOSBox: TMenuItem;
    MenuProfileFilesFolders: TMenuItem;
    PopupFilesFolders: TMenuItem;
    TrayIconPopupRecentlyStarted: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure MenuWork(Sender: TObject);
    procedure ListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure ApplicationEventsRestore(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ScreenshotListViewDblClick(Sender: TObject);
    procedure ScreenshotListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScreenshotMenuWork(Sender: TObject);
    procedure ScreenshotListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchEditChange(Sender: TObject);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure SoundMenuWork(Sender: TObject);
    procedure SoundListViewDblClick(Sender: TObject);
    procedure SoundListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SoundListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure TreeViewPopupEditUserFiltersClick(Sender: TObject);
    procedure IdleAddonTimerTimer(Sender: TObject);
    procedure TrayIconPopupClick(Sender: TObject);
    procedure ZipInfoPanelDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure VideoListViewDblClick(Sender: TObject);
    procedure VideoListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VideoListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure VideoMenuWork(Sender: TObject);
    procedure CapturePageControlChange(Sender: TObject);
    procedure MainDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure CaptureDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ToolbarPopupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FirstRunInfoButtonClick(Sender: TObject);
    procedure GameNotesButtonWork(Sender: TObject);
    procedure GameNotesEditEnter(Sender: TObject);
    procedure GameNotesEditExit(Sender: TObject);
    procedure SearchEditTimerTimer(Sender: TObject);
    function ApplicationEventsHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure TrayIconPopupMenuPopup(Sender: TObject);
  private
    { Private-Deklarationen }
    hScreenshotsChangeNotification, hConfsChangeNotification : THandle;
    JustStarted : Boolean;
    ListSort : TSortListBy;
    ListSortReverse : Boolean;
    OldGamesMenuUsed : Boolean;
    StartTrayMinimize : Boolean;
    FileConflictCheckRunning : Boolean;
    SaveBoundsRect : TRect;
    SaveMaximizedState : Boolean;
    ViewFilesFrame : TViewFilesFrame;
    SearchLinkFile, HelpMenuLinkFile : TLinkFile;
    GameLinkList : TGameLinks;
    HTMLhelpRouter : THTMLhelpRouter;
    LastSelectedGame : TGame;
    LastDragDropEffect : LongInt;
    hEvent : THandle;
    Procedure AfterSetupDialog(ColWidths, UserCols : String);
    Procedure StartCaptureChangeNotify;
    Procedure StopCaptureChangeNotify;
    Procedure LoadMenuLanguage;
    Procedure InitGUI(const FirstInit : Boolean);
    Procedure InitViewStyle;
    Procedure SelectGame(const AGame : TGame); overload;
    Procedure SelectGame(const AGameName : String); overload;
    Procedure LoadAbandonLinks;
    Procedure LoadHelpLinks;
    Procedure LoadSearchLinks;
    Procedure ProcessParams;
    Procedure UpdateScreenshotList;
    Procedure UpdateGameNotes;
    Procedure UpdateOpenFileInDataFolderMenu;
    Function AddDirToMenu(const Dir : String; const DataFolder : Boolean; const Menu1, Menu2 : TMenuItem; const Level : Integer) : Boolean;
    Procedure RunFile(const FileName : String);
    Procedure OpenFileInDataFolderMenuWork(Sender : TObject);
    Procedure OpenFileInDataProgramFolderMenuWork(Sender : TObject);
    Procedure UpdateAddFromTemplateMenu;
    Procedure AddFromTemplateClick(Sender: TObject);
    Procedure PostShow(var Msg : TMessage); Message WM_USER+1;
    Procedure PostResize(var Msg : TMessage); Message WM_USER+2;
    Procedure LoadGUISetup(const PrgStart : Boolean);
    Procedure SetupToolbarHints;
    Procedure LoadListViewGUISetup(const ListView : TListView; const Background, FontColor : String; const FontSize : Integer);
    Procedure LoadLabelGUISetup(const L : TPanel; const Background, FontColor : String; const FontSize : Integer);
    Procedure LoadRichEditGUISetup(const R : TRichEdit; const Background, FontColor : String; const FontSize : Integer);
    Procedure LoadTreeViewGUISetup(const TreeView : TTreeView; const Background, FontColor : String; const FontSize : Integer);
    Procedure LoadCoolBarGUISetup(const CoolBar : TCoolBar; const Background : String; const FontSize : Integer);
    Procedure ConfFileCheck;
    Procedure WMMove(Var Message : TWMMove); message WM_MOVE;
    Procedure DropImportFile(const FileName: String; var ErrorCode : String);
    Procedure StartWizard(const ExeFile : String; const WindowsExeFile : Boolean);
    Procedure AddProfile(const ExeFile : String; const Mode : String; const TemplateNr : Integer);
    Procedure AddProfileForWindowsEmulator(const Nr : Integer);
    Procedure ZipInfoNotify(Sender : TObject);
    Procedure AddProfileFromQuickStarter(Sender : TObject; const FileName : String; const WindowsProfile, UseWizard : Boolean; const TemplateNr : Integer);
    Procedure QuickStarterCloseNotify(Sender : TObject);
    Procedure DisplayResolutionChange(var Msg : TMessage); message WM_DISPLAYCHANGE;
    Procedure UpdateGamesListByViewFilesFrame(Sender : TObject);
    Procedure RunDOSBoxWithDefaultConfFile;
    Procedure OpenDOSBoxDefaultConfFile;
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; reintroduce; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    DeleteOnExit : TStringList;
    procedure SelectHelpFile;
  end;

{DEFINE CheckDoubleChecksums}

var
  DFendReloadedMainForm: TDFendReloadedMainForm;

var MainWindowShowComplete : Boolean = False;

implementation

uses ShellAPI, ShlObj, ClipBrd, Math, CommonTools, LanguageSetupUnit,
     PrgConsts, VistaToolsUnit, PrgSetupUnit, SetupDosBoxFormUnit,
     ProfileEditorFormUnit, SetupFormUnit, IconManagerFormUnit, DosBoxUnit,
     HistoryFormUnit, TemplateFormUnit, UninstallFormUnit, ViewImageFormUnit,
     UninstallSelectFormUnit, CreateConfFormUnit, WizardFormUnit,
     CreateShortcutFormUnit, CreateImageUnit, InfoFormUnit, TransferFormUnit,
     BuildInstallerFormUnit, ResHookUnit, BuildInstallerForSingleGameFormUnit,
     ModernProfileEditorFormUnit, ListViewImageUnit, StatisticsFormUnit,
     CacheChooseFormUnit, IconLoaderUnit, LanguageEditorStartFormUnit,
     LanguageEditorFormUnit, PlaySoundFormUnit, WallpaperStyleFormUnit,
     CreateISOImageFormUnit, CreateXMLFormUnit, ExpandImageFormUnit,
     FirstRunWizardFormUnit, CommonComponents, BuildImageFromFolderFormUnit,
     MiniRunFormUnit, ScummVMUnit, ListScummVMGamesFormUnit,
     DragNDropErrorFormUnit, SimpleXMLUnit, OperationModeInfoFormUnit,
     ZipManagerUnit, ZipWaitInfoFormUnit, CopyProfileFormUnit,
     PlayVideoFormUnit, ImageCacheUnit, ZipPackageUnit, WindowsProfileUnit,
     HelpConsts, BuildZipPackagesFormUnit, DOSBoxCountUnit, QuickStartFormUnit,
     ClassExtensions, SetupFrameWaveEncoderUnit, ZipInfoFormUnit,
     ScanGamesFolderFormUnit, MediaInterface, ScummVMToolsUnit,
     CreateShortcutsFormUnit, PackageManagerFormUnit, PackageBuilderUnit,
     RunPrgManagerUnit, PackageCreationFormUnit, TextEditPopupUnit,
     MultipleProfilesEditorFormUnit, InstallationSupportFormUnit,
     RenameAllScreenshotsFormUnit, MakeBootImageFromProfileFormUnit,
     CheatApplyFormUnit, CheatDBEditFormUnit, CheatSearchFormUnit,
     UpdateCheckFormUnit, ProgramUpdateCheckUnit, GameDBFilterUnit,
     LoggingUnit, DOSBoxFailedFormUnit, DOSBoxLangEditFormUnit,
     DOSBoxLangStartFormUnit, HistoryUnit, ExportGamesListFormUnit,
     DOSBoxOutputTestFormUnit, SingleInstanceUnit, SetupFrameZipPrgsUnit,
     DOSBoxTempUnit;

{$R *.dfm}

Var LastDOSBoxCount : Integer=0;
    LastLeft : Integer = -1;
    LastTop : Integer = -1;

procedure TDFendReloadedMainForm.FormCreate(Sender: TObject);
Var S : String;
    B : Boolean;
begin
  If PrgSetup.SingleInstance then begin
    If InstanceRunning(hEvent) then begin TerminateProcess(GetCurrentProcess,0); exit; end;
  end;

  LogInfo('### Start of FormCreate ###');

  {Caption:=Caption+' THIS IS A TEST VERSION ! (Beta 1 of version 1.5)';}
  {Caption:=Caption+' (Release candidate 1 of version 1.4.4)';}

  MI_Count:=ImageList.Count;
  Height:=790;
  Width:=Min(Width,790);
  JustStarted:=True;

  {Turn off events so window movements etc. do not slow down the start up}
  ApplicationEvents.OnIdle:=nil; IdleAddonTimer.Enabled:=False; TreeView.OnChange:=nil;
  ListView.OnAdvancedCustomDrawItem:=nil; ListView.OnSelectItem:=nil;

  FileConflictCheckRunning:=False;
  StartTrayMinimize:=False;
  HTMLhelpRouter:=nil;
  LastSelectedGame:=nil;
  GameLinkList:=nil;

  ListSort:=slbName;
  ListSortReverse:=False;
  OldGamesMenuUsed:=False;

  DeleteOnExit:=TStringList.Create;

  ZipManager.OnInfoBarNotify:=ZipInfoNotify;

  LogInfo('Setting up capture directory change notify');
  try ForceDirectories(MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)); except end;
  StartCaptureChangeNotify;

  LogInfo('Loading games data base');
  GameDB:=TGameDB.Create(PrgDataDir+GameListSubDir);
  ScummVMGamesList:=TScummVMGamesList.Create;

  LogInfo('Loading Links.txt and SearchLinks.txt');
  HelpMenuLinkFile:=TLinkFile.Create('Links.txt',True,ID_HelpOldGames);
  SearchLinkFile:=TLinkFile.Create('SearchLinks.txt',False,ID_ProfileSearchGame);

  LogInfo('Initializating of data viewer area');
  ViewFilesFrame:=TViewFilesFrame.Create(self);
  ViewFilesFrame.Parent:=DataFilesTab;
  ViewFilesFrame.OnUpdateGamesList:=UpdateGamesListByViewFilesFrame;

  LogInfo('Loading language');
  LoadMenuLanguage;

  LogInfo('Calling InitGUI');
  InitGUI(True);

  LogInfo('Updating template menu');
  UpdateAddFromTemplateMenu;

  If PrgSetup.FirstRun then begin
    LogInfo('First run: Searching DOSBox');
    if SearchDosBox(self,S) then PrgSetup.DOSBoxSettings[0].DosBoxDir:=S;
    LogInfo('First run: Initializating templates');
    ReBuildTemplates(True);
    LogInfo('First run: Showing first run wizard');
    ShowFirstRunWizardDialog(self,B);
    If B then begin
      LogInfo('First run: Starting update check');
      RunProgramStartSilentUpdateCheck(self,true);
    end;
  end;

  LogInfo('Initializing media player library');
  if not InitMediaPlayerLibrary(PrgDir+BinFolder) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[PrgDir+BinFolder+'\'+mplayer]),mtError,[mbOK],0);
    halt;
  end;

  ToolBar.PopupMenu:=ToolbarPopupMenu;

  LogInfo('### End of CreateForm ###'+#13);
end;

procedure TDFendReloadedMainForm.FormShow(Sender: TObject);
Var G : TGame;
    S : String;
    St : TStringList;
    I : Integer;
begin
  If not JustStarted then exit;
  JustStarted:=False;

  LogInfo('### Start of FormShow ###');
  LastDragDropEffect:=DROPEFFECT_NONE;
  RegisterDragDrop(Handle,Self);
  RegisterDragDrop(GameNotesEdit.Handle,Self);

  LogInfo('Setting up application icon');
  Icon.Assign(Application.Icon); {Window icon is only 16x16, application icon is larger; Win7 is using the window icon in the taskbar}

  {Turn on events again}
  ApplicationEvents.OnIdle:=ApplicationEventsIdle; IdleAddonTimer.Enabled:=True; TreeView.OnChange:=TreeViewChange;
  ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem; ListView.OnSelectItem:=ListViewSelectItem;

  LogInfo('Setting up drag&drop to window components');
  ListView:=TListView(NewWinControlType(ListView,TListViewAcceptingFilesAndSpecialHint,ctcmDangerousMagic));
  TListViewAcceptingFilesAndSpecialHint(ListView).ActivateAcceptFiles;
  TreeView:=TTreeView(NewWinControlType(TreeView,TTreeViewAcceptingFiles,ctcmDangerousMagic));
  TTreeViewAcceptingFiles(TreeView).ActivateAcceptFiles;
  ScreenshotListView:=TListView(NewWinControlType(ScreenshotListView,TListViewAcceptingFiles,ctcmDangerousMagic));
  TListViewAcceptingFiles(ScreenshotListView).ActivateAcceptFiles;
  SoundListView:=TListView(NewWinControlType(SoundListView,TListViewAcceptingFiles,ctcmDangerousMagic));
  TListViewAcceptingFiles(SoundListView).ActivateAcceptFiles;
  VideoListView:=TListView(NewWinControlType(VideoListView,TListViewAcceptingFiles,ctcmDangerousMagic));
  TListViewAcceptingFiles(VideoListView).ActivateAcceptFiles;

  TreeView.OnChange:=nil;

  LogInfo('Loading links and quick searching DOSBox');
  S:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  if SearchDosBox(self,S) then PrgSetup.DOSBoxSettings[0].DosBoxDir:=S;
  LoadHelpLinks;
  LoadAbandonLinks;
  LoadSearchLinks;

  LogInfo('Loading GUI icons');
  St:=TStringList.Create;
  try
    For I:=0 to PrgSetup.WindowsBasedEmulatorsPrograms.Count-1 do St.Add(MakeAbsPath(PrgSetup.WindowsBasedEmulatorsPrograms[I],PrgSetup.BaseDir));
    UserIconLoader.RegisterImageList(ImageList,'Main',St,40);
  finally
    St.Free;
  end;
  UserIconLoader.LoadIcons;

  If PrgSetup.FirstRun then begin
    LogInfo('First run: Building default template');
    BuildDefaultProfile;
    LogInfo('First run: Building "DOSBox DOS" profile (+ coping files from "NewUserData" to profile directory - if not portable)');
    G:=BuildDefaultDosProfile(GameDB);
    LogInfo('First run: Searching tools');
    FastSearchAllTools;
    If OperationMode<>omPortable then begin
      LogInfo('First run: Searching pack programs');
      FirstRunPackerAutoSetup();
    end;
    LogInfo('First run: Load language');
    LoadLanguage(PrgSetup.Language);
    LogInfo('First run: Load menu language');
    LoadMenuLanguage;
    LogInfo('First run: Calling LoadGUISetup');
    LoadGUISetup(False);
    LogInfo('First run: Selecting new "DOSBox DOS" profile');
    SelectGame(G);
    PrgSetup.DFendVersion:=GetNormalFileVersionAsString;
  end else begin
    If PrgSetup.DFendVersion<>GetNormalFileVersionAsString then begin
      LogInfo('First run after update: Updating settings');
      Enabled:=False;
      try
        UpdateUserDataFolderAndSettingsAfterUpgrade(GameDB,VersionToInt(PrgSetup.DFendVersion));
      finally
        Enabled:=True;
      end;
      PrgSetup.DFendVersion:=GetNormalFileVersionAsString;
      LogInfo('First run after update: Searching tools');
      FastSearchAllTools;
      LogInfo('First run after update: Calling LoadGUISetup');
      LoadGUISetup(False);
    end else begin
      LogInfo('Check helper program directories');
      FastSearchAllTools;
      LogInfo('Calling LoadGUISetup');
      LoadGUISetup(True);
    end;
  end;

  FirstRunInfoPanel.Visible:=(GameDB.Count<=1) and PrgSetup.ShowAddGameInfoOnEmptyGamesList;

  LogInfo('Update checker');
  RunProgramStartSilentUpdateCheck(self,False);

  LogInfo('Setting up data viewer area');
  ViewFilesFrame.Init;

  LogInfo('Deleting old temp files');
  TempZipFilesStartCleanUp;

  PostMessage(Handle,WM_USER+1,0,0);

  LogInfo('### End of ShowForm ###'+#13);
end;

procedure TDFendReloadedMainForm.FormDestroy(Sender: TObject);
Var I : Integer;
    S1, S2 : String;
begin
  While FreeDOSInitThreadRunning or TemplatesInitThreadRunning do Sleep(50);

  UpdateGameNotes; LastSelectedGame:=nil;

  try
    try
      For I:=0 to DeleteOnExit.Count-1 do If FileExists(DeleteOnExit[I]) then ExtDeleteFile(DeleteOnExit[I],ftTemp);
    finally
      DeleteOnExit.Free;
    end;
    ExtDeleteFile(PrgDataDir+PackageDBSubFolder+'\DFRTemp.prof',ftTemp);
    ExtDeleteFile(TempDir+TempSubFolder,ftTemp);
    If ParamCount=0 then ExtDeleteFile(TempDir+DosBoxConfFileName,ftTemp);
  except end;

  GamesListSaveColWidths(ListView);
  If ListView.Selected<>nil then PrgSetup.LastSelectedProfile:=TGame(ListView.Selected.Data).CacheName else PrgSetup.LastSelectedProfile:='';
  StopCaptureChangeNotify;
  PrgSetup.MainMaximized:=(WindowState=wsMaximized);
  PrgSetup.MainLeft:=Left;
  PrgSetup.MainTop:=Top;
  PrgSetup.MainWidth:=Width;
  PrgSetup.MainHeight:=Height;
  PrgSetup.TreeWidth:=TreeView.Width;
  PrgSetup.ScreenshotHeight:=CapturePageControl.Height;

  If TreeView.Selected=nil then begin S1:=''; S2:=''; end else begin
    If TreeView.Selected.Parent=nil then begin
      S1:=TreeView.Selected.Text; S2:='';
    end else begin
      S1:=TreeView.Selected.Parent.Text; S2:=TreeView.Selected.Text;
    end;
  end;
  PrgSetup.FilterMain:=S1;
  PrgSetup.FilterSub:=S2;
  PrgSetup.PreviewerCategory:=CapturePageControl.ActivePageIndex;

  ListView.Selected:=nil;
  GameDB.Free;
  ScummVMGamesList.Free;

  HelpMenuLinkFile.Free;
  SearchLinkFile.Free;

  If Assigned(GameLinkList) then FreeAndNil(GameLinkList);

  RevokeDragDrop(Handle);
  RevokeDragDrop(GameNotesEdit.Handle);

  if hEvent<>0 then CloseHandle(hEvent);
end;

procedure TDFendReloadedMainForm.LoadMenuLanguage;
begin
  LogInfo('### Start of LoadMenuLanguage ###');
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  ListView.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  MenuFile.Caption:=LanguageSetup.MenuFile;
  MenuFileImport.Caption:=LanguageSetup.MenuFileImport;
  MenuFileImportConfFile.Caption:=LanguageSetup.MenuFileImportConf;
  MenuFileImportProfFile.Caption:=LanguageSetup.MenuFileImportProf;
  MenuFileImportZIPFile.Caption:=LanguageSetup.MenuFileImportZIP;
  MenuFileImportZIPFileWithInstallationSupport.Caption:=LanguageSetup.MenuFileImportZIPWithInstallationSupport;
  MenuFileImportFolder.Caption:=LanguageSetup.MenuFileImportFolder;
  MenuFileImportFolderWithInstallationSupport.Caption:=LanguageSetup.MenuFileImportFolderWithInstallationSupport;
  MenuFileImportDownload.Caption:=LanguageSetup.MenuFileImportDownload;
  MenuFileExport.Caption:=LanguageSetup.MenuFileExport;
  MenuFileExportGamesList.Caption:=LanguageSetup.MenuFileExportGamesList;
  MenuFileExportTransferProfiles.Caption:=LanguageSetup.MenuExtrasTransferProfiles;
  MenuFileCreateConf.Caption:=LanguageSetup.MenuFileCreateConf;
  MenuFileCreateProf.Caption:=LanguageSetup.MenuFileCreateProf;
  MenuFileCreateZIP.Caption:=LanguageSetup.MenuFileCreateZIP;
  MenuFileCreateInstaller.Caption:=LanguageSetup.MenuFileCreateInstaller;
  MenuFileCreateXMlPackageList.Caption:=LanguageSetup.MenuFileExportPackageList;
  MenuFileExportBuildInstaller.Caption:=LanguageSetup.MenuFileExportBuildInstaller;
  MenuFileExportBuildZipPackages.Caption:=LanguageSetup.MenuFileExportBuildZipPackages;
  MenuFileSetup.Caption:=LanguageSetup.MenuFileSetup;
  MenuFileQuit.Caption:=LanguageSetup.MenuFileQuit;
  MenuView.Caption:=LanguageSetup.MenuView;
  MenuViewShowMenubar.Caption:=LanguageSetup.MenuViewShowMenubar;
  MenuViewShowToolbar.Caption:=LanguageSetup.MenuViewShowToolbar;
  MenuViewsShowTree.Caption:=LanguageSetup.MenuViewShowTree;
  MenuViewsShowScreenshots.Caption:=LanguageSetup.MenuViewShowScreenshots;
  MenuViewsShowSearchBox.Caption:=LanguageSetup.MenuViewShowSearchBox;
  MenuViewsShowExtraInfo.Caption:=LanguageSetup.MenuViewShowExtraInfo;
  MenuViewsShowTooltips.Caption:=LanguageSetup.MenuViewShowTooltips;
  MenuViewsSimpleListNoIcons.Caption:=LanguageSetup.MenuViewListNoIcons;
  MenuViewsSimpleList.Caption:=LanguageSetup.MenuViewList;
  MenuViewsListNoIcons.Caption:=LanguageSetup.MenuViewReportNoIcons;
  MenuViewsList.Caption:=LanguageSetup.MenuViewReport;
  MenuViewsSmallIcons.Caption:=LanguageSetup.MenuViewSmallIcons;
  MenuViewsIcons.Caption:=LanguageSetup.MenuViewIcons;
  MenuViewsScreenshots.Caption:=LanguageSetup.MenuViewScreenshots;
  MenuViewsQuickStarter.Caption:=LanguageSetup.MenuViewQuickStarter;
  MenuRun.Caption:=LanguageSetup.MenuRun;
  MenuRunGame.Caption:=LanguageSetup.MenuRunGame;
  MenuRunSetup.Caption:=LanguageSetup.MenuRunSetup;
  MenuRunExtraFile.Caption:=LanguageSetup.MenuRunExtraFile;
  MenuRunRunDosBox.Caption:=LanguageSetup.MenuRunRunDosBox;
  MenuRunRunDosBoxKeyMapper.Caption:=LanguageSetup.MenuRunRunDosBoxKeyMapper;
  MenuRunOpenDosBoxConfig.Caption:=LanguageSetup.MenuRunOpenDosBoxConfig;
  MenuRunDOSBoxOutputTest.Caption:=LanguageSetup.MenuRunDOSBoxOutputTest;
  MenuRunRunScummVM.Caption:=LanguageSetup.MenuRunRunScummVM;
  MenuRunOpenScummVMConfig.Caption:=LanguageSetup.MenuRunOpenScummVMConfig;
  MenuProfile.Caption:=LanguageSetup.MenuProfile;
  MenuProfileAddManually.Caption:=LanguageSetup.MenuProfileAddManually;
  MenuProfileAdd.Caption:=LanguageSetup.MenuProfileAdd;
  MenuProfileAddScummVM.Caption:=LanguageSetup.MenuProfileAddScummVM;
  MenuProfileAddWindows.Caption:=LanguageSetup.MenuProfileAddWindows;
  MenuProfileAddOther.Caption:=LanguageSetup.MenuProfileAddOther;
  MenuProfileAddFromTemplate.Caption:=LanguageSetup.MenuProfileAddFromTemplate;
  MenuProfileAddWithWizard.Caption:=LanguageSetup.MenuProfileAddWithWizard;
  MenuProfileImportZip.Caption:=LanguageSetup.MenuFileImportZIP;
  MenuProfileAddInstallationSupport.Caption:=LanguageSetup.MenuProfileAddWithInstallationSupport;
  MenuProfileDownloadPackages.Caption:=LanguageSetup.MenuFileImportDownload;
  MenuProfileEdit.Caption:=LanguageSetup.MenuProfileEdit;
  MenuProfileCopy.Caption:=LanguageSetup.MenuProfileCopy;
  If PrgSetup.OldDeleteMenuItem then begin
    MenuProfileDelete.Visible:=True;
    MenuProfileDelete.Caption:=LanguageSetup.MenuProfileDelete;
    MenuProfileDeinstall.Caption:=LanguageSetup.MenuProfileDeinstall;
    MenuProfileDeinstall.ImageIndex:=-1;
    MenuProfileDelete.ShortCut:=ShortCut(VK_Delete,[]);
    MenuProfileDeinstall.ShortCut:=ShortCut(VK_Delete,[ssShift]);
  end else begin
    MenuProfileDelete.Visible:=False;
    MenuProfileDelete.Caption:=LanguageSetup.MenuProfileDelete;
    MenuProfileDeinstall.Caption:=LanguageSetup.MenuProfileDelete;
    MenuProfileDeinstall.ImageIndex:=MenuProfileDelete.ImageIndex;
    MenuProfileDelete.ShortCut:=0;
    MenuProfileDeinstall.ShortCut:=ShortCut(VK_Delete,[]);
  end;
  MenuProfileMakeInstaller.Caption:=LanguageSetup.MenuProfileMakeInstaller;
  MenuProfileMakeZipArchive.Caption:=LanguageSetup.MenuProfileMakeZipArchive;
  MenuProfileViewConfFile.Caption:=LanguageSetup.MenuProfileViewConfFile;
  MenuProfileViewIniFile.Caption:=LanguageSetup.MenuProfileViewIniFile;
  MenuProfileFilesFolders.Caption:=LanguageSetup.MenuProfileFilesAndFolders;
  MenuProfileOpenFolder.Caption:=LanguageSetup.MenuProfileOpenFolder;
  MenuProfileOpenFolderDOSBox.Caption:=LanguageSetup.MenuProfileOpenFolderDOSBox;
  MenuProfileOpenCaptureFolder.Caption:=LanguageSetup.MenuProfileOpenCaptureFolder;
  MenuProfileOpenDataFolder.Caption:=LanguageSetup.MenuProfileOpenDataFolder;
  MenuProfileOpenFileInProgramFolder.Caption:=LanguageSetup.MenuProfileOpenFileInProgramFolder;
  MenuProfileOpenFileInDataFolder.Caption:=LanguageSetup.MenuProfileOpenFileInDataFolder;
  MenuProfileWWW.Caption:=LanguageSetup.GameWWW;
  MenuProfileMarkAsFavorite.Caption:=LanguageSetup.MenuProfileMarkAsFavorite;
  MenuProfileCreateShortcut.Caption:=LanguageSetup.MenuProfileCreateShortcut;
  MenuProfileSearchGame.Caption:=LanguageSetup.MenuProfileSearchGame;
  MenuProfileCheating.Caption:=LanguageSetup.MenuProfileCheating;
  MenuExtras.Caption:=LanguageSetup.MenuExtras;
  MenuExtrasIconManager.Caption:=LanguageSetup.MenuExtrasIconManager;
  MenuExtrasViewLogs.Caption:=LanguageSetup.MenuExtrasViewLogs;
  MenuExtrasOpenGamesFolder.Caption:=LanguageSetup.MenuExtrasViewLogsOpenGamesFolder;
  MenuExtrasTemplates.Caption:=LanguageSetup.MenuExtrasTemplates;
  MenuExtrasCheating.Caption:=LanguageSetup.MenuExtrasCheating;
  MenuExtrasCheatingApply.Caption:=LanguageSetup.MenuExtrasCheatingApply;
  MenuExtrasCheatingEdit.Caption:=LanguageSetup.MenuExtrasCheatingEdit;
  MenuExtrasCheatingSearch.Caption:=LanguageSetup.MenuExtrasCheatingSearch;
  MenuExtrasDeinstallMultipleGames.Caption:=LanguageSetup.MenuExtrasDeinstallMultipleGames;
  MenuExtrasImageFiles.Caption:=LanguageSetup.MenuExtrasImageFiles;
  MenuExtrasCreateIMGImage.Caption:=LanguageSetup.MenuExtrasCreateIMGImageFile;
  MenuExtrasWriteIMGImage.Caption:=LanguageSetup.MenuExtrasWriteIMGImageFile;
  MenuExtrasCreateImage.Caption:=LanguageSetup.MenuExtrasCreateImageFile;
  MenuExtrasCreateISOImage.Caption:=LanguageSetup.MenuExtrasCreateISOImageFile;
  MenuExtrasExtractImage.Caption:=LanguageSetup.MenuExtrasExtractImage;
  MenuExtrasImageFromFolder.Caption:=LanguageSetup.MenuExtrasImageFromFolder;
  MenuExtrasImageFromProfile.Caption:=LanguageSetup.MenuExtrasImageFromProfile;
  MenuExtrasScanGamesFolder.Caption:=LanguageSetup.MenuExtrasScanGamesFolder;
  MenuExtrasTransferProfiles.Caption:=LanguageSetup.MenuExtrasTransferProfiles;
  MenuExtrasChangeProfiles.Caption:=LanguageSetup.MenuExtrasChangeProfiles;
  MenuExtrasCreateShortcuts.Caption:=LanguageSetup.MenuExtrasCreateShortcuts;
  MenuExtrasCheckProfiles.Caption:=LanguageSetup.MenuExtrasCheckProfiles;
  MenuExtrasTranslation.Caption:=LanguageSetup.MenuExtrasTranslationEditor;
  MenuExtrasTranslationDFendReloaded.Caption:=LanguageSetup.MenuExtrasTranslationEditorDFendReloaded;
  MenuExtrasTranslationDOSBox.Caption:=LanguageSetup.MenuExtrasTranslationEditorDOSBox;
  MenuHelp.Caption:=LanguageSetup.MenuHelp;
  MenuHelpDosBox.Caption:=LanguageSetup.MenuHelpDosBox;
  MenuHelpDosBoxReadme.Caption:=LanguageSetup.MenuHelpDosBoxReadme;
  MenuHelpDosBoxFAQ.Caption:=LanguageSetup.MenuHelpDosBoxFAQ;
  MenuHelpDosBoxIntro.Caption:=LanguageSetup.MenuHelpDosBoxIntro;
  MenuHelpDosBoxIntroDosBox.Caption:=LanguageSetup.MenuHelpDosBoxIntroDosBox;
  MenuHelpDosBoxHotkeys.Caption:=LanguageSetup.MenuHelpDosBoxHotkeys;
  MenuHelpDosBoxHotkeysDosbox.Caption:=LanguageSetup.MenuHelpDosBoxHotkeysDosbox;
  MenuHelpDosBoxHomepage.Caption:=LanguageSetup.MenuHelpDosBoxHomepage;
  MenuHelpDosBoxCompatibility.Caption:=LanguageSetup.MenuHelpDosBoxCompatibility;
  MenuHelpDemoCompatibility.Caption:=LanguageSetup.MenuHelpDemoCompatibility;
  MenuHelpScummVM.Caption:=LanguageSetup.MenuHelpScummVM;
  MenuHelpScummVMReadme.Caption:=LanguageSetup.MenuHelpScummVMReadme;
  MenuHelpScummVMFAQ.Caption:=LanguageSetup.MenuHelpScummVMFAQ;
  MenuHelpScummVMHomepage.Caption:=LanguageSetup.MenuHelpScummVMHomepage;
  MenuHelpScummVMCompatibility.Caption:=LanguageSetup.MenuHelpScummVMCompatibility;
  MenuHelpScummVMCompatibilityIntern.Caption:=LanguageSetup.MenuHelpScummVMCompatibilityList;
  MenuHelpAbandonware.Caption:=LanguageSetup.MenuHelpAbandonware;
  MenuHelpHomepage.Caption:=LanguageSetup.MenuHelpHomepage;
  MenuHelpForum.Caption:=LanguageSetup.MenuHelpForum;
  MenuHelpUpdates.Caption:=LanguageSetup.MenuHelpUpdates;
  MenuHelpStatistics.Caption:=LanguageSetup.MenuHelpStatistics;
  MenuHelpOperationMode.Caption:=LanguageSetup.MenuHelpOperationMode;
  MenuHelpHelp.Caption:=LanguageSetup.MenuHelpHelp;
  MenuHelpHelpContent.Caption:=LanguageSetup.MenuHelpContent;
  MenuHelpIntroduction.Caption:=LanguageSetup.MenuHelpIntroduction;
  MenuHelpAddingGames.Caption:=LanguageSetup.MenuHelpAddingGames;
  MenuHelpGetGames.Caption:=LanguageSetup.MenuHelpGetGames;
  MenuHelpAbout.Caption:=LanguageSetup.MenuHelpAbout;

  AddButtonMenuAddManually.Caption:=LanguageSetup.MenuProfileAddManually;
  AddButtonMenuAdd.Caption:=LanguageSetup.MenuProfileAdd;
  AddButtonMenuAddScummVM.Caption:=LanguageSetup.MenuProfileAddScummVM;
  AddButtonMenuAddWindows.Caption:=LanguageSetup.MenuProfileAddWindows;
  AddButtonMenuAddOther.Caption:=LanguageSetup.MenuProfileAddOther;
  AddButtonMenuAddFromTemplate.Caption:=LanguageSetup.MenuProfileAddFromTemplate;
  AddButtonMenuAddWithWizard.Caption:=LanguageSetup.MenuProfileAddWithWizard;
  AddButtonMenuImportZip.Caption:=LanguageSetup.MenuFileImportZIP;
  AddButtonMenuAddInstallationSupport.Caption:=LanguageSetup.MenuProfileAddWithInstallationSupport;
  AddButtonMenuDownloadPackages.Caption:=LanguageSetup.MenuFileImportDownload;
  AddButtonMenuAddGetGames.Caption:=LanguageSetup.MenuHelpGetGames;

  SetupToolbarHints;

  PopupRunGame.Caption:=LanguageSetup.PopupRunGame;
  PopupRunSetup.Caption:=LanguageSetup.PopupRunSetup;
  PopupRunExtraFile.Caption:=LanguageSetup.PopupRunExtraFile;
  PopupEdit.Caption:=LanguageSetup.PopupEdit;
  PopupCopy.Caption:=LanguageSetup.PopupCopy;
  If PrgSetup.OldDeleteMenuItem then begin
    PopupDelete.Visible:=True;
    PopupDelete.Caption:=LanguageSetup.MenuProfileDelete;
    PopupDeinstall.Caption:=LanguageSetup.MenuProfileDeinstall;
    PopupDeinstall.ImageIndex:=-1;
    PopupDelete.ShortCut:=ShortCut(VK_Delete,[]);
    PopupDeinstall.ShortCut:=ShortCut(VK_Delete,[ssShift]);
  end else begin
    PopupDelete.Visible:=False;
    PopupDelete.Caption:=LanguageSetup.MenuProfileDelete;
    PopupDeinstall.Caption:=LanguageSetup.MenuProfileDelete;
    PopupDeinstall.ImageIndex:=PopupDelete.ImageIndex;
    PopupDelete.ShortCut:=0;
    PopupDeinstall.ShortCut:=ShortCut(VK_Delete,[]);
  end;
  PopupMakeInstaller.Caption:=LanguageSetup.PopupMakeInstaller;
  PopupMakeZipArchive.Caption:=LanguageSetup.PopupMakeZipArchive;
  PopupViewConfFile.Caption:=LanguageSetup.MenuProfileViewConfFile;
  PopupViewINIFile.Caption:=LanguageSetup.MenuProfileViewIniFile;
  PopupFilesFolders.Caption:=LanguageSetup.PopupFilesFolder;
  PopupOpenFolder.Caption:=LanguageSetup.PopupOpenFolder;
  PopupOpenFolderDOSBox.Caption:=LanguageSetup.PopupOpenFolderDOSBox;
  PopupOpenCaptureFolder.Caption:=LanguageSetup.PopupOpenCaptureFolder;
  PopupOpenDataFolder.Caption:=LanguageSetup.PopupOpenDataFolder;
  PopupOpenFileInProgramFolder.Caption:=LanguageSetup.PopupOpenFileInProgramFolder;
  PopupOpenFileInDataFolder.Caption:=LanguageSetup.PopupOpenFileInDataFolder;
  PopupWWW.Caption:=LanguageSetup.GameWWW;
  PopupMarkAsFavorite.Caption:=LanguageSetup.PopupMarkAsFavorite;
  PopupCreateShortcut.Caption:=LanguageSetup.PopupCreateShortcut;
  PopupSearchGame.Caption:=LanguageSetup.PopupSearchGame;
  PopupCheating.Caption:=LanguageSetup.MenuProfileCheating;
  PopupViews.Caption:=LanguageSetup.PopupView;
  PopupSimpleListNoIcons.Caption:=LanguageSetup.MenuViewListNoIcons;
  PopupSimpleList.Caption:=LanguageSetup.MenuViewList;
  PopupListNoIcons.Caption:=LanguageSetup.MenuViewReportNoIcons;
  PopupList.Caption:=LanguageSetup.MenuViewReport;
  PopupSmallIcons.Caption:=LanguageSetup.MenuViewSmallIcons;
  PopupIcons.Caption:=LanguageSetup.MenuViewIcons;
  PopupScreenshots.Caption:=LanguageSetup.MenuViewScreenshots;

  CaptureScreenshotsTab.Caption:=LanguageSetup.CaptureScreenshots;
  If ListView.Selected<>nil then begin
    If ScummVMMode(TGame(ListView.Selected.Data)) then begin
      ScreenshotsInfoPanel.Caption:=LanguageSetup.CaptureScreenshotsInfoScumm;
    end else begin
      If WindowsExeMode(TGame(ListView.Selected.Data))
        then ScreenshotsInfoPanel.Caption:=''
        else ScreenshotsInfoPanel.Caption:=LanguageSetup.CaptureScreenshotsInfo;
    end;
  end else begin
    ScreenshotsInfoPanel.Caption:='';
  end;
  CaptureSoundTab.Caption:=LanguageSetup.CaptureSounds;
  CaptureVideoTab.Caption:=LanguageSetup.CaptureVideos;
  SoundInfoPanel.Caption:=LanguageSetup.CaptureSoundsInfo;
  VideoInfoPanel.Caption:=LanguageSetup.CaptureVideosInfo;
  GameNotesPanel.Caption:=LanguageSetup.CaptureNotes;
  DataFilesTab.Caption:=LanguageSetup.CaptureDataFiles;

  ScreenshotPopupOpen.Caption:=LanguageSetup.ScreenshotPopupOpen;
  ScreenshotPopupOpenExternal.Caption:=LanguageSetup.ScreenshotPopupOpenExternal;
  ScreenshotPopupOpenCaptureFolder.Caption:=LanguageSetup.PopupOpenCaptureFolder;
  ScreenshotPopupRefresh.Caption:=LanguageSetup.ScreenshotPopupRefresh;
  ScreenshotPopupImport.Caption:=LanguageSetup.ScreenshotPopupImport;
  ScreenshotPopupCopy.Caption:=LanguageSetup.ScreenshotPopupCopy;
  ScreenshotPopupSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  ScreenshotPopupRename.Caption:=LanguageSetup.ScreenshotPopupRename;
  ScreenshotPopupRenameAll.Caption:=LanguageSetup.ScreenshotPopupRenameAll;
  ScreenshotPopupDelete.Caption:=LanguageSetup.ScreenshotPopupDelete;
  ScreenshotPopupDeleteAll.Caption:=LanguageSetup.ScreenshotPopupDeleteAll;
  ScreenshotPopupUseAsBackground.Caption:=LanguageSetup.ScreenshotPopupUseAsBackground;
  ScreenshotPopupUseInScreenshotList.Caption:=LanguageSetup.ScreenshotPopupUseInScreenshotList;

  SoundPopupOpen.Caption:=LanguageSetup.ScreenshotPopupOpen;
  SoundPopupOpenExternal.Caption:=LanguageSetup.SoundsPopupOpenExternal;
  SoundPopupOpenCaptureFolder.Caption:=LanguageSetup.PopupOpenCaptureFolder;
  SoundPopupRefresh.Caption:=LanguageSetup.ScreenshotPopupRefresh;
  SoundPopupImport.Caption:=LanguageSetup.ScreenshotPopupImport;
  SoundPopupSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  SoundPopupSaveMp3.Caption:=LanguageSetup.SoundsPopupSaveMp3;
  SoundPopupSaveOgg.Caption:=LanguageSetup.SoundsPopupSaveOgg;
  SoundPopupRename.Caption:=LanguageSetup.ScreenshotPopupRename;
  SoundPopupRenameAll.Caption:=LanguageSetup.ScreenshotPopupRenameAll;
  SoundPopupDelete.Caption:=LanguageSetup.ScreenshotPopupDelete;
  SoundPopupDeleteAll.Caption:=LanguageSetup.ScreenshotPopupDeleteAll;
  SoundPopupSaveMp3All.Caption:=LanguageSetup.SoundsPopupSaveMp3All;
  SoundPopupSaveOggAll.Caption:=LanguageSetup.SoundsPopupSaveOggAll;

  VideoPopupOpen.Caption:=LanguageSetup.ScreenshotPopupOpen;
  VideoPopupOpenExternal.Caption:=LanguageSetup.SoundsPopupOpenExternal;
  VideoPopupOpenCaptureFolder.Caption:=LanguageSetup.PopupOpenCaptureFolder;
  VideoPopupRefresh.Caption:=LanguageSetup.ScreenshotPopupRefresh;
  VideoPopupImport.Caption:=LanguageSetup.ScreenshotPopupImport;
  VideoPopupSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  VideoPopupRename.Caption:=LanguageSetup.ScreenshotPopupRename;
  VideoPopupRenameAll.Caption:=LanguageSetup.ScreenshotPopupRenameAll;
  VideoPopupDelete.Caption:=LanguageSetup.ScreenshotPopupDelete;
  VideoPopupDeleteAll.Caption:=LanguageSetup.ScreenshotPopupDeleteAll;

  TrayIconPopupRestore.Caption:=LanguageSetup.TrayPopupRestore;
  TrayIconPopupRun.Caption:=LanguageSetup.TrayPopupRun;
  TrayIconPopupRecentlyStarted.Caption:=LanguageSetup.GameRecentlyPlayed;
  TrayIconPopupAddProfile.Caption:=LanguageSetup.TrayPopupAdd;
  TrayIconPopupAddScummVMProfile.Caption:=LanguageSetup.MenuProfileAddScummVM;
  TrayIconPopupAddWindowsProfile.Caption:=LanguageSetup.MenuProfileAddWindows;
  TrayIconPopupAddOther.Caption:=LanguageSetup.MenuProfileAddOther;
  TrayIconPopupAddFromTemplate.Caption:=LanguageSetup.TrayPopupAddFromTemplate;
  TrayIconPopupAddWithWizard.Caption:=LanguageSetup.TrayPopupAddWithWizard;
  TrayIconPopupClose.Caption:=LanguageSetup.TrayPopupClose;

  TreeViewPopupEditUserFilters.Caption:=LanguageSetup.TreeViewPopupUserDefinedCategories;
  ToolbarPopupSetupButtons.Caption:=LanguageSetup.ToolbarPopupSetupButtons;
  ToolbarPopupSetupIconSet.Caption:=LanguageSetup.ToolbarPopupSetupIconSet;
  ToolbarPopupShowMenubar.Caption:=LanguageSetup.MenuViewShowMenubar;

  ScreenshotImageList.Height:=Max(20,Min(500,PrgSetup.ScreenshotPreviewSize));
  ScreenshotImageList.Width:=ScreenshotImageList.Height*16 div 10;

  MenuKeyCaps[mkcBkSp]:=LanguageSetup.KeyBackspace;
  MenuKeyCaps[mkcTab]:=LanguageSetup.KeyTab;
  MenuKeyCaps[mkcEsc]:=LanguageSetup.KeyEscape;
  MenuKeyCaps[mkcEnter]:=LanguageSetup.KeyEnter;
  MenuKeyCaps[mkcSpace]:=LanguageSetup.KeySpace;
  MenuKeyCaps[mkcPgUp]:=LanguageSetup.KeyPageUp;
  MenuKeyCaps[mkcPgDn]:=LanguageSetup.KeyPageDown;
  MenuKeyCaps[mkcEnd]:=LanguageSetup.KeyEnd;
  MenuKeyCaps[mkcHome]:=LanguageSetup.KeyHome;
  MenuKeyCaps[mkcLeft]:=LanguageSetup.KeyLeft;
  MenuKeyCaps[mkcUp]:=LanguageSetup.KeyUp;
  MenuKeyCaps[mkcRight]:=LanguageSetup.KeyRight;
  MenuKeyCaps[mkcDown]:=LanguageSetup.KeyDown;
  MenuKeyCaps[mkcIns]:=LanguageSetup.KeyInsert;
  MenuKeyCaps[mkcDel]:=LanguageSetup.KeyDelete;
  MenuKeyCaps[mkcShift]:=LanguageSetup.KeyShift;
  MenuKeyCaps[mkcCtrl]:=LanguageSetup.KeyCtrl;
  MenuKeyCaps[mkcAlt]:=LanguageSetup.KeyAlt;

  MsgDlgWarning:=LanguageSetup.MsgDlgWarning;
  MsgDlgError:=LanguageSetup.MsgDlgError;
  MsgDlgInformation:=LanguageSetup.MsgDlgInformation;
  MsgDlgConfirm:=LanguageSetup.MsgDlgConfirm;
  MsgDlgYes:=LanguageSetup.MsgDlgYes;
  MsgDlgNo:=LanguageSetup.MsgDlgNo;
  MsgDlgOK:=LanguageSetup.MsgDlgOK;
  MsgDlgCancel:=LanguageSetup.MsgDlgCancel;
  MsgDlgAbort:=LanguageSetup.MsgDlgAbort;
  MsgDlgRetry:=LanguageSetup.MsgDlgRetry;
  MsgDlgIgnore:=LanguageSetup.MsgDlgIgnore;
  MsgDlgAll:=LanguageSetup.MsgDlgAll;
  MsgDlgNoToAll:=LanguageSetup.MsgDlgNoToAll;
  MsgDlgYesToAll:=LanguageSetup.MsgDlgYesToAll;

  ZipInfoLabel.Caption:=LanguageSetup.ZipFormWaitInfo;

  FirstRunInfoLabel.Caption:=LanguageSetup.FirstRunInfoBar;
  FirstRunInfoButton.Hint:=LanguageSetup.FirstRunInfoBarCloseHint;

  ViewFilesFrame.LoadLanguage;
  SelectHelpFile;

  SearchEdit.OnChange:=nil;
  SearchEdit.Text:=LanguageSetup.Search;
  SearchEdit.Font.Color:=clGray;
  SearchEdit.OnChange:=SearchEditChange;

  SetRichEditPopup(GameNotesEdit);

  If Assigned(ViewImageForm) then begin
    LogInfo('Loading image viewer language');
    ViewImageForm.LoadLanguage;  
  end;

  LogInfo('Loading old software and search links');
  LoadAbandonLinks;
  LoadSearchLinks;

  If Assigned(QuickStartForm) then QuickStartForm.LoadLanguage;

  LogInfo('### End of LoadMenuLanguage ###');
end;

procedure TDFendReloadedMainForm.SelectHelpFile;
Var HelpFileName : String;
    B : Boolean;
begin
  B:=False;
  HelpFileName:=PrgDataDir+LanguageSubDir+'\'+LanguageSetup.HelpFile; If FileExists(HelpFileName) then B:=True;
  If not B then begin HelpFileName:=PrgDir+LanguageSubDir+'\'+LanguageSetup.HelpFile; If FileExists(HelpFileName) then B:=True; end;
  If not B then begin HelpFileName:=PrgDataDir+LanguageSubDir+'\English.chm'; If FileExists(HelpFileName) then B:=True; end;
  If not B then begin HelpFileName:=PrgDir+LanguageSubDir+'\English.chm'; If FileExists(HelpFileName) then B:=True; end;

  If B then begin
    If HTMLhelpRouter=nil then HTMLhelpRouter:=InitHTMLHelp(HelpFileName) else HTMLhelpRouter.Helpfile:=HelpFileName;
  end;
end;

procedure TDFendReloadedMainForm.InitGUI(const FirstInit : Boolean);
Var I,J : Integer;
    TN : TTreeNode;
    S : String;
    TreeViewChangeEvent : TTVChangedEvent;
begin
  LogInfo('### Start of InitGUI ###');
  DoubleBuffered:=True;
  SearchEdit.DoubleBuffered:=True;
  SetVistaFonts(self);
  {ListView.DoubleBuffered:=True; - causes problems with tooltips}
  CapturePageControl.DoubleBuffered:=True;
  ScreenshotListView.DoubleBuffered:=True;
  SoundListView.DoubleBuffered:=True;
  VideoListView.DoubleBuffered:=True;
  TreeView.DoubleBuffered:=True;

  LogInfo('Setting up hotkeys');
  MenuRunGame.ShortCut:=ShortCut(VK_Return,[]);
  MenuRunSetup.ShortCut:=ShortCut(VK_Return,[ssShift]);
  MenuProfileEdit.ShortCut:=ShortCut(VK_Return,[ssCtrl]);
  PopupRunGame.ShortCut:=ShortCut(VK_Return,[]);
  PopupRunSetup.ShortCut:=ShortCut(VK_Return,[ssShift]);
  PopupEdit.ShortCut:=ShortCut(VK_Return,[ssCtrl]);
  ScreenshotPopupOpen.ShortCut:=ShortCut(VK_Return,[]);
  SoundPopupOpen.ShortCut:=ShortCut(VK_Return,[]);
  SoundPopupOpenExternal.ShortCut:=ShortCut(VK_Return,[ssShift]);
  VideoPopupOpen.ShortCut:=ShortCut(VK_Return,[]);
  VideoPopupOpenExternal.ShortCut:=ShortCut(VK_Return,[ssShift]);

  LogInfo('Init tree and list view');
  If not FirstInit then S:=GamesListSaveColWidthsToString(ListView) else S:='';
  InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
  InitTreeViewForGamesList(TreeView,GameDB);
  If FirstInit then begin
    If PrgSetup.StoreColumnWidths then GamesListLoadColWidths(ListView)
  end else begin
    GamesListLoadColWidthsFromString(ListView,S);
  end;

  If PrgSetup.RestoreFilter and (Trim(PrgSetup.FilterMain)<>'') then begin
    TN:=nil;
    For I:=0 to TreeView.Items.Count-1 do If ExtUpperCase(TreeView.Items[I].Text)=ExtUpperCase(Trim(PrgSetup.FilterMain)) then begin
      TN:=TreeView.Items[I];
      If Trim(PrgSetup.FilterMain)<>'' then For J:=0 to TN.Count-1 do If ExtUpperCase(TN.Item[J].Text)=ExtUpperCase(Trim(PrgSetup.FilterSub)) then begin
        TN:=TN.Item[J]; break;
      end;
      break;
    end;
    TreeViewChangeEvent:=TreeView.OnChange;
    If FirstInit then TreeView.OnChange:=nil;
    If TN<>nil then TreeView.Selected:=TN;
    TreeView.OnChange:=TreeViewChangeEvent;
  end;

  If PrgSetup.RestorePreviewerCategory then CapturePageControl.ActivePageIndex:=Max(0,Min(PrgSetup.PreviewerCategory,CapturePageControl.PageCount-1));

  LogInfo('Set window state (1)');
  Case PrgSetup.StartWindowSize of
    0 : begin
          {nothing};
        end;
    1 : begin
          If PrgSetup.MainMaximized then begin
            {Maximize in OnShow};
          end else begin
            If (PrgSetup.MainLeft>=0) and (PrgSetup.MainLeft<9*Screen.Width div 10) then Left:=PrgSetup.MainLeft;
            If (PrgSetup.MainTop>=0) and (PrgSetup.MainTop<9*Screen.Height div 10) then Top:=PrgSetup.MainTop;
            If (PrgSetup.MainWidth>=0) and (Left+PrgSetup.MainWidth<=Screen.Width) then Width:=PrgSetup.MainWidth;
            If (PrgSetup.MainHeight>=0) and (Top+PrgSetup.MainHeight<=Screen.Height) then Height:=PrgSetup.MainHeight;
            Menu:=nil;
            Position:=poDesigned;
            Menu:=MainMenu;
          end;
          If (PrgSetup.TreeWidth>=50) and (PrgSetup.TreeWidth<9*ClientWidth div 10) then TreeView.Width:=PrgSetup.TreeWidth;
          If (PrgSetup.ScreenshotHeight>=50) and (PrgSetup.ScreenshotHeight<9*ClientHeight div 10) then CapturePageControl.Height:=PrgSetup.ScreenshotHeight;
        end;
    2 : {Minimize in OnShow};
    3 : {Maximize in OnShow};
    4 : begin
          BorderStyle:=bsNone;
          WindowState:=wsMaximized;
        end;
  end;

  LogInfo('Making GUI elements visible');
  CapturePageControl.Visible:=PrgSetup.ShowScreenshots;
  Splitter1.Visible:=CapturePageControl.Visible;
  If Splitter1.Visible then Splitter1.Top:=CapturePageControl.Top-Splitter1.Height;
  MenuViewsShowScreenshots.Checked:=PrgSetup.ShowScreenshots;

  TreeView.Visible:=PrgSetup.ShowTree;
  Splitter.Visible:=TreeView.Visible;
  If Splitter.Visible then Splitter.Left:=TreeView.Left+TreeView.Width;
  MenuViewsShowTree.Checked:=PrgSetup.ShowTree;

  ButtonClose.Visible:=PrgSetup.ShowToolbarButtonClose;
  ButtonRun.Visible:=PrgSetup.ShowToolbarButtonRun;
  ButtonRunSetup.Visible:=PrgSetup.ShowToolbarButtonRunSetup;
  ButtonAdd.Visible:=PrgSetup.ShowToolbarButtonAdd;
  ButtonEdit.Visible:=PrgSetup.ShowToolbarButtonEdit;
  ButtonDelete.Visible:=PrgSetup.ShowToolbarButtonDelete;
  ButtonHelp.Visible:=PrgSetup.ShowToolbarButtonHelp;

  SearchEdit.Visible:=PrgSetup.ShowSearchBox;
  MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;

  MenuViewsShowExtraInfo.Checked:=PrgSetup.ShowExtraInfo;
  If not FirstInit then InitViewStyle;

  ListView.ShowHint:=PrgSetup.ShowTooltips;
  MenuViewsShowTooltips.Checked:=PrgSetup.ShowTooltips;

  SearchEdit.OnChange:=nil;
  SearchEdit.Text:=LanguageSetup.Search;
  SearchEdit.Font.Color:=clGray;
  SearchEdit.OnChange:=SearchEditChange;

  MenuFileImportXMLFile.Visible:=PrgSetup.ShowXMLImportMenuItem;
  MenuFileCreateXML.Visible:=PrgSetup.ShowXMLExportMenuItem;

  MenuFileCreateInstaller.Visible:=(GetNSISPath<>'');
  MenuProfileMakeInstaller.Visible:=MenuFileCreateInstaller.Visible;
  MenuFileExportBuildInstaller.Visible:=MenuFileCreateInstaller.Visible;
  PopupMakeInstaller.Visible:=MenuFileCreateInstaller.Visible;

  LogInfo('### End of InitGUI ###');
end;

procedure TDFendReloadedMainForm.InitViewStyle;
Var S : String;
    I : Integer;
    VS : TViewStyle;
begin
  S:=Trim(ExtUpperCase(PrgSetup.ListViewStyle));
  I:=3;
  If S='SIMPLELISTNOICONS' then I:=0;
  If S='SIMPLELIST' then I:=1;
  If S='LISTNOICONS' then I:=2;
  If S='LIST' then I:=3;
  If S='SMALLICONS' then I:=4;
  If S='ICONS' then I:=5;
  If S='SCREENSHOTS' then I:=6;

  Case I of
    0 : begin
          MenuViewsSimpleListNoIcons.Checked:=True;
          PopupSimpleListNoIcons.Checked:=True;
          If (ListView.SmallImages<>nil) and (ListView.ViewStyle=vsList) then ListView.ViewStyle:=vsReport;
          ListView.LargeImages:=ListviewIconImageList;
          ListView.SmallImages:=nil;
          ListView.ViewStyle:=vsList;
        end;
    1 : begin
          MenuViewsSimpleList.Checked:=True;
          PopupSimpleList.Checked:=True;
          ListView.LargeImages:=ListviewIconImageList;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsList;
        end;
    2 : begin
          MenuViewsListNoIcons.Checked:=True;
          PopupListNoIcons.Checked:=True;
          ListView.LargeImages:=ListviewIconImageList;
          If (ListView.SmallImages<>nil) and (ListView.ViewStyle=vsReport) then ListView.ViewStyle:=vsList;
          ListView.SmallImages:=nil;
          ListView.ViewStyle:=vsReport;
        end;
    3 : begin
          MenuViewsList.Checked:=True;
          PopupList.Checked:=True;
          ListView.LargeImages:=ListviewIconImageList;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsReport;
        end;
    4 : begin
          MenuViewsSmallIcons.Checked:=True;
          PopupSmallIcons.Checked:=True;
          ListView.LargeImages:=ListviewIconImageList;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsSmallIcon;
        end;
    5 : begin
          MenuViewsIcons.Checked:=True;
          PopupIcons.Checked:=True;
          ListView.LargeImages:=ListviewIconImageList;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsIcon;
        end;
    6 : begin
          MenuViewsScreenshots.Checked:=True;
          PopupScreenshots.Checked:=True;
          ListView.LargeImages:=ListviewScreenshotImageList;
          ListView.SmallImages:=nil;
          ListView.ViewStyle:=vsIcon;
        end;
  end;

  TreeViewChange(TreeView,TreeView.Selected);
  VS:=ListView.ViewStyle;
  If ListView.ViewStyle=vsReport then ListView.ViewStyle:=vsSmallIcon else ListView.ViewStyle:=vsReport;
  ListView.ViewStyle:=VS;

  If ListView.ViewStyle=vsSmallIcon then ListView.Arrange(arDefault);
end;

Procedure TDFendReloadedMainForm.LoadAbandonLinks;
begin
  HelpMenuLinkFile.AddLinksToMenu(MenuHelpAbandonware,6102,6103,MenuWork,4);
end;

procedure TDFendReloadedMainForm.LoadHelpLinks;
Var I : Integer;
    M : TMenuItem;
    Rec : TSearchRec;
begin
  I:=FindFirst(PrgSetup.DOSBoxSettings[0].DosBoxDir+'DOSBox *.txt',faAnyFile,Rec);
  try
    while I=0 do begin
      M:=TMenuItem.Create(self);
      M.Caption:=MaskUnderlineAmpersand(Trim(Rec.Name));
      M.Tag:=6101;
      M.OnClick:=MenuWork;
      M.ImageIndex:=24;
      MenuHelpDosBoxReadme.Add(M);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
  I:=FindFirst(PrgSetup.DOSBoxSettings[0].DosBoxDir+'Readme*.txt',faAnyFile,Rec);
  try
    while I=0 do begin
      M:=TMenuItem.Create(self);
      M.Caption:=MaskUnderlineAmpersand(Trim(Rec.Name));
      M.Tag:=6101;
      M.OnClick:=MenuWork;
      M.ImageIndex:=24;
      MenuHelpDosBoxReadme.Add(M);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure TDFendReloadedMainForm.LoadSearchLinks;
begin
  SearchLinkFile.AddLinksToMenu(MenuProfileSearchGame,4015,4016,MenuWork,4);
  SearchLinkFile.AddLinksToMenu(PopupSearchGame,4015,4016,MenuWork,4);
end;

procedure TDFendReloadedMainForm.PostShow(var Msg: TMessage);
begin
  LogInfo('### Start of PostShow ###');

  Splitter1.Top:=CapturePageControl.Top-Splitter1.Height;

  LogInfo('Set window state (2)');
  Case PrgSetup.StartWindowSize of
    0 : begin
          {nothing}
          {Fix height for smaller screens}
          Height:=Min(Height,Screen.WorkAreaHeight);
          If Top+Height>Screen.WorkAreaHeight then Top:=Screen.WorkAreaHeight-Height;
          {To fix misaligend ListView when stating maximized}
          If WindowState=wsMaximized then begin
            WindowState:=wsNormal;
            WindowState:=wsMaximized;
          end;
        end;
    1 : If PrgSetup.MainMaximized then begin
          WindowState:=wsMaximized;
        end else begin
          {Done in InitGUI};
          {Fix height for smaller screens}
          Height:=Min(Height,Screen.WorkAreaHeight);
          If Top+Height>Screen.WorkAreaHeight then Top:=Screen.WorkAreaHeight-Height;
          FormResize(self);
        end;
    2 : If PrgSetup.MinimizeToTray then begin
          WindowState:=wsMinimized;
          ApplicationEventsMinimize(self);
          StartTrayMinimize:=True;
        end else begin
          WindowState:=wsMinimized;
        end;
    3 : WindowState:=wsMaximized;
    4 : {Fullscreen};
  end;

  {If ListView.Items.Count=0 then begin
    TreeViewChange(TreeView,nil);
  end else begin
    ListViewSelectItem(ListView,nil,False);
  end;}

  LogInfo('Fix misaligned listview if started maximized');
  {To fix misaligend ListView when stating maximized}
  UpdateBounds;
  Resize;
  Realign;

  LogInfo('Init view style for games list');
  InitViewStyle;
  LogInfo('Init view style for data area');
  with ScreenshotListView do begin ViewStyle:=vsReport; ViewStyle:=vsIcon; end;
  with SoundListView do begin ViewStyle:=vsReport; ViewStyle:=vsList; end;
  with VideoListView do begin ViewStyle:=vsReport; ViewStyle:=vsList; end;

  LogInfo('Process parameters');
  ProcessParams;

  If PrgSetup.RestoreLastSelectedProfile then begin
    LogInfo('Restoring last selected profile');
    SelectGame(PrgSetup.LastSelectedProfile);
  end;

  LogInfo('Set GUI for selected game');
  If (ListView.Items.Count>0) and (ListView.Selected=nil) then begin
    ListView.Selected:=ListView.Items[0];
    SelectGame(TGame(ListView.Selected.Data));
  end;
  ListViewSelectItem(ListView,ListView.Selected,True);

  LogInfo('Free unsed memory');
  MainWindowShowComplete:=True;
  SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);

  LogInfo('### End of PostShow ###'+#13);

  LogInfo('*** Turning log off ***'+#13,False);
end;

procedure TDFendReloadedMainForm.ProcessParams;
Var I : Integer;
    S,T : String;
    CloseOK : Boolean;
begin
  If ParamCount=0 then exit;

  S:=ParamStr(1);

  T:=Trim(ExtUpperCase(S));
  If (Pos('WINEMODE',T)>0) or (Pos('WINESUPPORTENABLED',T)>0) or (Pos('WINDOWSMODE',T)>0) or (Pos('NOWINESUPPORT',T)>0) or (Pos('WINESUPPORTDISABLED',T)>0) then exit;

  For I:=2 to ParamCount do S:=S+' '+ParamStr(I);
  T:=ExtUpperCase(S);
  LogInfo('Trying to find "'+S+'" in game db.');

  For I:=0 to GameDB.Count-1 do If Trim(GameDB[I].CacheNameUpper)=T then begin
    CloseOK:=True;
    If ScummVMMode(GameDB[I]) then begin
      LogInfo('Found ScummVM game "'+S+'" in game db.');
      LogInfo('Running profile '+GameDB[I].SetupFile);
      RunScummVMGame(GameDB[I]);
      CloseOK:=(ZipManager.Count=0);
    end else begin
      If WindowsExeMode(GameDB[I]) then begin
        LogInfo('Found Windows game "'+S+'" in game db.');
        LogInfo('Running profile '+GameDB[I].SetupFile);
        RunWindowsGame(GameDB[I]);
      end else begin
        LogInfo('Found DOSBox game "'+S+'" in game db.');
        LogInfo('Running profile '+GameDB[I].SetupFile);
        if GameDB[I].StartFullscreen then LogInfo('Fullscreen mode: yes') else LogInfo('Fullscreen mode: no');
        RunGame(GameDB[I],DeleteOnExit);
        CloseOK:=(ZipManager.Count=0);
      end;
    end;
    CloseOK:=CloseOK and (RunPrgManager.Count=0);

    If CloseOK then PostMessage(Handle,WM_Close,0,0);
    exit;
  end;

  MessageDlg(Format(LanguageSetup.MessageCouldNotFindGame,[S]),mtError,[mbOK],0);
end;

procedure TDFendReloadedMainForm.StartCaptureChangeNotify;
begin
  hScreenshotsChangeNotification:=FindFirstChangeNotification(
    PChar(MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)),
    True,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
  );

  hConfsChangeNotification:=FindFirstChangeNotification(
    PChar(PrgDataDir+GameListSubDir),
    True,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
  );
end;

procedure TDFendReloadedMainForm.StopCaptureChangeNotify;
begin
  If hScreenshotsChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hScreenshotsChangeNotification);
  hScreenshotsChangeNotification:=INVALID_HANDLE_VALUE;

  If hConfsChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hConfsChangeNotification);
  hConfsChangeNotification:=INVALID_HANDLE_VALUE;
end;

procedure TDFendReloadedMainForm.SearchEditChange(Sender: TObject);
begin
  SearchEditTimer.Enabled:=False;
  SearchEditTimer.Enabled:=True;
  If SearchEdit.Font.Color=clGray then begin
    SearchEdit.Font.Color:=clWindowText;
    SearchEdit.Text:='';
    exit;
  end;
end;

procedure TDFendReloadedMainForm.SearchEditTimerTimer(Sender: TObject);
begin
  SearchEditTimer.Enabled:=False;
  TreeViewChange(Sender,TreeView.Selected);
end;

procedure TDFendReloadedMainForm.SelectGame(const AGame: TGame);
Var I : Integer;
begin
  If AGame=nil then exit;
  For I:=0 to ListView.Items.Count-1 do If TGame(ListView.Items[I].Data)=AGame then begin
    ListView.Selected:=ListView.Items[I];
    ListView.Selected.MakeVisible(False);
    break;
  end;
  ListViewSelectItem(self,ListView.Selected,ListView.Selected<>nil);
end;

Procedure TDFendReloadedMainForm.SelectGame(const AGameName : String);
Var S : String;
    I : Integer;
begin
  If Trim(AGameName)='' then exit;
  S:=Trim(ExtUpperCase(AGameName));
  For I:=0 to ListView.Items.Count-1 do If TGame(ListView.Items[I].Data).CacheNameUpper=S then begin
    ListView.Selected:=ListView.Items[I];
    SelectGame(TGame(ListView.Items[I].Data));
  end;
end;

Var TreeUpdateNeededAgain : Boolean = False;
    TreeUpdateInProgress : Boolean = False;

procedure TDFendReloadedMainForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
Var G : TGame;
    S : String;
    IL1, IL2 : TImageList;
begin
  If TreeUpdateInProgress then begin
    LogInfo('TreeViewChange: Tree update in progress not rebuilding games list yet');
    TreeUpdateNeededAgain:=True;
    exit;
  end;
  LogInfo('### Start of TreeViewChange ###');

  TreeUpdateInProgress:=True;
  try
    repeat
      TreeUpdateNeededAgain:=False;

      If GameDB.Count>1 then FirstRunInfoPanel.Visible:=False;

      If ListView.LargeImages=nil then IL1:=ListviewIconImageList else IL1:=ListView.LargeImages as TImageList;
      If ListView.SmallImages=nil then IL2:=ListviewImageList else IL2:=ListView.SmallImages as TImageList;

      LogInfo('Update game notes');
      UpdateGameNotes; LastSelectedGame:=nil;

      ListView.Items.BeginUpdate;
      try
        If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;

        If SearchEdit.Font.Color<>clGray then S:=SearchEdit.Text else S:='';

        If TreeView.Selected=nil then begin
          LogInfo('Adding all games to games list');
          AddGamesToList(ListView,IL2,IL1,ImageList,GameDB,RemoveUnderline(LanguageSetup.All),'',S,PrgSetup.ShowExtraInfo,ListSort,ListSortReverse,False,False,False,MenuViewsScreenshots.Checked);
        end else begin
          If TreeView.Selected.Parent=nil then begin
            LogInfo('Adding filter matching games to games list (main category)');
            AddGamesToList(ListView,IL2,IL1,ImageList,GameDB,TreeView.Selected.Text,'',S,PrgSetup.ShowExtraInfo,ListSort,ListSortReverse,False,False,False,MenuViewsScreenshots.Checked);
          end else begin
            LogInfo('Adding filter matching games to games list (sub category)');
            AddGamesToList(ListView,IL2,IL1,ImageList,GameDB,TreeView.Selected.Parent.Text,TreeView.Selected.Text,S,PrgSetup.ShowExtraInfo,ListSort,ListSortReverse,False,False,False,MenuViewsScreenshots.Checked);
          end;
        end;
        If G<>nil then begin
          LogInfo('Select last selected game');
          SelectGame(G);
        end else begin
          If ListView.Items.Count>0 then begin
            LogInfo('Select first game in list');
            SelectGame(TGame(ListView.Items[0].Data));
          end;
        end;
      finally
        ListView.Items.EndUpdate;
      end;
    until not TreeUpdateNeededAgain;
  finally
    TreeUpdateInProgress:=False;
  end;
    LogInfo('### End of TreeViewChange ###');
end;

procedure TDFendReloadedMainForm.ListViewAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
Var FS : TFontStyles;
begin
  DefaultDraw:=True;
  FS:=[];
  If (Item<>nil) and (Item.Data<>nil) then begin
    if TGame(Item.Data).Favorite then begin
      If PrgSetup.FavoritesBold then FS:=FS+[fsBold];
      If PrgSetup.FavoritesItalic then FS:=FS+[fsItalic];
      If PrgSetup.FavoritesUnderline then FS:=FS+[fsUnderline];
    end else begin
      If PrgSetup.NonFavoritesBold then FS:=FS+[fsBold];
      If PrgSetup.NonFavoritesItalic then FS:=FS+[fsItalic];
      If PrgSetup.NonFavoritesUnderline then FS:=FS+[fsUnderline];
    end;
  end;
  TListview(Sender).Canvas.Font.Style:=FS;
end;

procedure TDFendReloadedMainForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort,ListSortReverse);
  TreeViewChange(Sender,TreeView.Selected);
end;

procedure TDFendReloadedMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F2) and (Shift=[]) then MenuWork(MenuProfileEdit);
  If (Key=VK_F5) and (Shift=[]) then begin EditDefaultProfile(self,GameDB,SearchLinkFile,DeleteOnExit); LoadSearchLinks; end;
end;

procedure TDFendReloadedMainForm.ListViewDblClick(Sender: TObject);
begin
  If ListView.Selected<>nil then MenuWork(ButtonRun);
end;

procedure TDFendReloadedMainForm.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
Var G : TGame;
    St : TStringList;
    I,J : Integer;
    S : String;
begin
  If Item=nil then exit;
  G:=TGame(Item.Data); If G=nil then exit;
  InfoTip:=G.CacheName;

  If G.Genre<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameGenre+': '+GetCustomGenreName(G.CacheGenre);
  If G.Developer<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameDeveloper+': '+G.CacheDeveloper;
  If G.Publisher<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GamePublisher+': '+G.CachePublisher;
  If G.Year<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameYear+': '+G.CacheYear;
  If G.Language<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameLanguage+': '+GetCustomLanguageName(G.CacheLanguage);
  For I:=1 to 9 do If G.WWW[I]<>'' then begin
    S:=G.WWWNamePlain[I];
    If Trim(S)='' then S:=LanguageSetup.GameWWW;
    InfoTip:=InfoTip+#13+S+': '+G.WWW[I];
  end;
  If G.License<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameLicense+': '+GetCustomLicenseName(G.License);

  S:=GetLastModificationDate(G); If S<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameLastModification+': '+S;
  InfoTip:=InfoTip+#13+Format(LanguageSetup.GameStartCountTooltip,[History.GameStartCount(G.CacheName)]);

  J:=Max(1,Min(100,PrgSetup.NoteLinesInTooltips));
  If G.Notes<>'' then begin
    St:=StringToStringList(G.Notes);
    try
      If St.Count>0 then InfoTip:=InfoTip+#13;
      For I:=0 to Min(J-1,St.Count-1) do InfoTip:=InfoTip+#13+St[I];
    finally
      St.Free;
    end;
  end;
  If Trim(G.DataDir)<>'' then InfoTip:=InfoTip+#13+#13+LanguageSetup.GameDataDirInfo;
end;

procedure TDFendReloadedMainForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B,B2,B3,CaptureFolder : Boolean;
    S : String;
    I,J : Integer;
    M : TMenuItem;
    St1,St2 : TStringList;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);
  If B then begin
    B2:=ScummVMMode(TGame(Item.Data));
    B3:=WindowsExeMode(TGame(Item.Data));
    S:=TGame(Item.Data).CaptureFolder;
    CaptureFolder:=(Trim(S)<>'');
    If CaptureFolder then begin S:=MakeAbsPath(S,PrgSetup.BaseDir); CaptureFolder:=DirectoryExists(S); end;
  end else begin
    B2:=False;
    B3:=False;
    CaptureFolder:=False;
  end;

  MenuRunGame.Enabled:=B;
  MenuRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  MenuProfileEdit.Enabled:=B;
  MenuProfileCopy.Enabled:=B;
  MenuProfileDelete.Enabled:=B;
  MenuProfileDeinstall.Enabled:=B and ((not B3) or (not PrgSetup.OldDeleteMenuItem));
  MenuProfileMakeInstaller.Enabled:=B and (not B3);
  MenuProfileMakeZipArchive.Enabled:=B and ((not B3) or PrgSetup.AllowPackingWindowsGames);
  MenuFileCreateZIP.Enabled:=B and ((not B3) or PrgSetup.AllowPackingWindowsGames);
  MenuFileCreateInstaller.Enabled:=B and (not B3);
  If not B then begin
    MenuProfileViewConfFile.Visible:=True;
    MenuProfileViewConfFile.Enabled:=False;
    MenuProfileViewIniFile.Visible:=False;
  end else begin
    MenuProfileViewConfFile.Visible:=(not B2) and (not B3);
    MenuProfileViewConfFile.Enabled:=(not B2) and (not B3);
    MenuProfileViewIniFile.Visible:=B2;
    MenuProfileViewIniFile.Enabled:=B2;
  end;
  MenuProfileOpenFolder.Enabled:=B and ((Trim(TGame(Item.Data).GameExe)<>'') or (B2 and (Trim(TGame(Item.Data).ScummVMPath)<>'')));
  MenuProfileOpenFolderDOSBox.Visible:=B and (not B2) and (not B3);
  MenuProfileOpenFolderDOSBox.Enabled:=B and (Trim(TGame(Item.Data).GameExe)<>'') and (not B2) and (not B3);
  MenuProfileOpenCaptureFolder.Enabled:=CaptureFolder;
  MenuProfileOpenDataFolder.Enabled:=B and (Trim(TGame(Item.Data).DataDir)<>'');
  MenuProfileMarkAsFavorite.Enabled:=B;
  If B then begin
    If TGame(Item.Data).Favorite
      then MenuProfileMarkAsFavorite.Caption:=LanguageSetup.MenuProfileUnMarkAsFavorite
      else MenuProfileMarkAsFavorite.Caption:=LanguageSetup.MenuProfileMarkAsFavorite;
  end else begin
    MenuProfileMarkAsFavorite.Caption:=LanguageSetup.MenuProfileMarkAsFavorite;
  end;
  MenuProfileWWW.Enabled:=B;
  If Assigned(GameLinkList) then FreeAndNil(GameLinkList);
  If B then begin
    GameLinkList:=TGameLinks.Create(TGame(Item.Data));
    GameLinkList.AddLinksToMenu(MenuProfileWWW,4);
  end else begin
    TGameLinks.ClearLinksMenu(MenuProfileWWW);
  end;
  MenuProfileCreateShortcut.Enabled:=B;
  MenuProfileSearchGame.Enabled:=B;
  MenuProfileCheating.Enabled:=B;

  PopupRunGame.Enabled:=B;
  PopupRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  PopupEdit.Enabled:=B;
  PopupCopy.Enabled:=B;
  PopupDelete.Enabled:=B;
  PopupDeinstall.Enabled:=B and ((not B3) or (not PrgSetup.OldDeleteMenuItem));
  PopupMakeInstaller.Enabled:=B and (not B3);
  PopupMakeZipArchive.Enabled:=B and ((not B3) or PrgSetup.AllowPackingWindowsGames);
  If not B then begin
    PopupViewConfFile.Visible:=True;
    PopupViewConfFile.Enabled:=False;
    PopupViewINIFile.Visible:=False;
  end else begin
    PopupViewConfFile.Visible:=(not B2) and (not B3);
    PopupViewConfFile.Enabled:=(not B2) and (not B3);
    PopupViewINIFile.Visible:=B2;
    PopupViewINIFile.Enabled:=B2;
  end;
  PopupOpenFolder.Enabled:=B and ((Trim(TGame(Item.Data).GameExe)<>'') or (B2 and (Trim(TGame(Item.Data).ScummVMPath)<>'')));
  PopupOpenFolderDOSBox.Visible:=B and (not B2) and (not B3);
  PopupOpenFolderDOSBox.Enabled:=B and (Trim(TGame(Item.Data).GameExe)<>'') and (not B2) and (not B3);
  PopupOpenCaptureFolder.Enabled:=CaptureFolder;
  PopupOpenDataFolder.Enabled:=B and (Trim(TGame(Item.Data).DataDir)<>'');
  PopupWWW.Enabled:=B;
  If B then begin
    GameLinkList.AddLinksToMenu(PopupWWW,4);
  end else begin
    TGameLinks.ClearLinksMenu(PopupWWW);
  end;
  PopupMarkAsFavorite.Enabled:=B;
  If B then begin
    If TGame(Item.Data).Favorite
      then PopupMarkAsFavorite.Caption:=LanguageSetup.MenuProfileUnMarkAsFavorite
      else PopupMarkAsFavorite.Caption:=LanguageSetup.MenuProfileMarkAsFavorite;
  end else begin
    PopupMarkAsFavorite.Caption:=LanguageSetup.MenuProfileMarkAsFavorite;
  end;
  PopupCreateShortcut.Enabled:=B;
  PopupSearchGame.Enabled:=B;
  PopupCheating.Enabled:=B;

  ScreenshotPopupOpenCaptureFolder.Enabled:=CaptureFolder;
  ScreenshotPopupRefresh.Enabled:=CaptureFolder;
  ScreenshotPopupImport.Enabled:=CaptureFolder;
  ScreenshotPopupRenameAll.Enabled:=CaptureFolder;
  ScreenshotPopupDeleteAll.Enabled:=CaptureFolder;

  SoundPopupOpenCaptureFolder.Enabled:=CaptureFolder;
  SoundPopupRefresh.Enabled:=CaptureFolder;
  SoundPopupImport.Enabled:=CaptureFolder;
  SoundPopupRenameAll.Enabled:=CaptureFolder;
  SoundPopupDeleteAll.Enabled:=CaptureFolder;

  VideoPopupOpenCaptureFolder.Enabled:=CaptureFolder;
  VideoPopupRefresh.Enabled:=CaptureFolder;
  VideoPopupImport.Enabled:=CaptureFolder;
  VideoPopupRenameAll.Enabled:=CaptureFolder;
  VideoPopupDeleteAll.Enabled:=CaptureFolder;

  ButtonRun.Enabled:=B;
  ButtonRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  ButtonEdit.Enabled:=B;
  ButtonDelete.Enabled:=B;

  UpdateScreenshotList;

  UpdateGameNotes;

  UpdateOpenFileInDataFolderMenu;

  If Selected and (Item<>nil) then begin
    ViewFilesFrame.Visible:=True;
    ViewFilesFrame.SetGame(TGame(Item.Data));
  end else begin
    ViewFilesFrame.Visible:=False;
  end;

  MenuRunExtraFile.Clear;
  PopupRunExtraFile.Clear;
  MenuRunExtraFile.Visible:=False;
  PopupRunExtraFile.Visible:=False;
  If B and (not B2) then For I:=0 to 49 do begin
    S:=Trim(TGame(Item.Data).ExtraPrgFile[I]);
    J:=Pos(';',S);
    If (S='') or (J=0) then continue;
    M:=TMenuItem.Create(self);
    M.Caption:=MaskUnderlineAmpersand(Copy(S,1,J-1));
    M.OnClick:=MenuWork;
    M.Tag:=3010+I;
    MenuRunExtraFile.Add(M);
    M:=TMenuItem.Create(self);
    M.Caption:=MaskUnderlineAmpersand(Copy(S,1,J-1));
    M.OnClick:=MenuWork;
    M.Tag:=3010+I;
    PopupRunExtraFile.Add(M);
    MenuRunExtraFile.Visible:=True;
    PopupRunExtraFile.Visible:=True;
  end;

  If PrgSetup.NonModalViewer and Assigned(ViewImageForm) then begin
    If not B then begin
      ShowNonModalImageDialog(self,'',nil,nil);
    end else begin
      St1:=TStringList.Create;
      St2:=TStringList.Create;
      try
        S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
        If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
        If ScreenshotListView.Selected<>nil then J:=ScreenshotListView.Selected.Index else J:=-1;
        For I:=0 to ScreenshotListView.Items.Count-1 do begin
          If I<J then St1.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
          If I>J then St2.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
        end;
        If J<0 then begin
          If St2.Count>0 then begin S:=St2[0]; St2.Delete(0); end else S:='';
        end else begin
          S:=IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[J].Caption;
        end;
        ShowNonModalImageDialog(self,S,St1,St2);
      finally
        St1.Free;
        St2.Free;
      end;
    end;
  end;
end;

Procedure TDFendReloadedMainForm.UpdateScreenshotList;
Var S,SelItem : String;
    I : Integer;
begin
  SelItem:='';
  If ScreenshotListView.Selected<>nil then SelItem:=ScreenshotListView.Selected.Caption;
  ScreenshotListView.Items.BeginUpdate;
  try
    ScreenshotListView.Items.Clear;
    ScreenshotImageList.Clear;
    If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S<>'' then AddScreenshotsToList(ScreenshotListView,ScreenshotImageList,S);
    end;
  finally
    ScreenshotListView.Items.EndUpdate;
  end;
  For I:=0 to ScreenshotListView.Items.Count-1 do If ScreenshotListView.Items[I].Caption=SelItem then begin
    ScreenshotListView.Selected:=ScreenshotListView.Items[I];
    break;
  end;
  ScreenshotPopupRenameAll.Enabled:=(ScreenshotListView.Items.Count>0);
  ScreenshotPopupDeleteAll.Enabled:=(ScreenshotListView.Items.Count>0);

  ScreenshotsInfoPanel.Visible:=(ScreenshotListView.Items.Count=0) and (ListView.Selected<>nil);
  ScreenshotsInfoPanel.Height:=IfThen(ScreenshotsInfoPanel.Visible,17,0);
  If ScreenshotsInfoPanel.Visible then begin
    If ScummVMMode(TGame(ListView.Selected.Data)) then begin
      ScreenshotsInfoPanel.Caption:=LanguageSetup.CaptureScreenshotsInfoScumm;
    end else begin
      If WindowsExeMode(TGame(ListView.Selected.Data))
        then ScreenshotsInfoPanel.Caption:=''
        else ScreenshotsInfoPanel.Caption:=LanguageSetup.CaptureScreenshotsInfo;
    end
  end;
  ScreenshotListViewSelectItem(self,ScreenshotListView.Selected,True);

  SelItem:='';
  If SoundListView.Selected<>nil then SelItem:=SoundListView.Selected.Caption;
  SoundListView.Items.BeginUpdate;
  try
    SoundListView.Items.Clear;
    If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S<>'' then AddSoundsToList(SoundListView,S,33);
    end;
  finally
    SoundListView.Items.EndUpdate;
  end;
  For I:=0 to SoundListView.Items.Count-1 do If SoundListView.Items[I].Caption=SelItem then begin
    SoundListView.Selected:=SoundListView.Items[I];
    break;
  end;
  SoundPopupRenameAll.Enabled:=(SoundListView.Items.Count>0);
  SoundPopupDeleteAll.Enabled:=(SoundListView.Items.Count>0);

  SoundInfoPanel.Visible:=(SoundListView.Items.Count=0) and (ListView.Selected<>nil) and (not ScummVMMode(TGame(ListView.Selected.Data))) and (not WindowsExeMode(TGame(ListView.Selected.Data)));
  SoundInfoPanel.Height:=IfThen(SoundInfoPanel.Visible,17,0);
  SoundListViewSelectItem(self,SoundListView.Selected,True);

  SelItem:='';
  If VideoListView.Selected<>nil then SelItem:=VideoListView.Selected.Caption;
  VideoListView.Items.BeginUpdate;
  try
    VideoListView.Items.Clear;
    If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S<>'' then AddVideosToList(VideoListView,S,38);
    end;
  finally
    VideoListView.Items.EndUpdate;
  end;
  For I:=0 to VideoListView.Items.Count-1 do If VideoListView.Items[I].Caption=SelItem then begin
    VideoListView.Selected:=VideoListView.Items[I];
    break;
  end;
  VideoPopupRenameAll.Enabled:=(VideoListView.Items.Count>0);
  VideoPopupDeleteAll.Enabled:=(VideoListView.Items.Count>0);

  VideoInfoPanel.Visible:=(VideoListView.Items.Count=0) and (ListView.Selected<>nil) and (not ScummVMMode(TGame(ListView.Selected.Data))) and (not WindowsExeMode(TGame(ListView.Selected.Data)));
  VideoInfoPanel.Height:=IfThen(VideoInfoPanel.Visible,17,0);
  VideoListViewSelectItem(self,VideoListView.Selected,True);
end;

Procedure TDFendReloadedMainForm.UpdateGameNotes;
Var St : TStringList;
    S : String;
begin
  GameNotesEdit.Visible:=(ListView.Selected<>nil) and (ListView.Selected.Data<>nil);
  GameNotesToolBar.Enabled:=GameNotesEdit.Visible;

  If (LastSelectedGame<>nil) and (ListView.Items.Count>0) then begin
    S:=StringListToString(GameNotesEdit.Text);
    If LastSelectedGame.Notes<>S then begin
      LastSelectedGame.Notes:=S;
      LastSelectedGame.StoreAllValues;
    end;
  end;

  If ListView.Selected<>nil then LastSelectedGame:=ListView.Selected.Data else LastSelectedGame:=nil;

  If not GameNotesEdit.Visible then exit;

  St:=StringToStringList(TGame(ListView.Selected.Data).Notes);
  try GameNotesEdit.Lines.Assign(St); finally St.Free; end;
end;

Procedure TDFendReloadedMainForm.UpdateOpenFileInDataFolderMenu;
Var B,B2,FilesAdded : Boolean;
    Dir : String;
    G : TGame;
begin
  B:=(ListView.Selected<>nil) and (ListView.Selected.Data<>nil);
  B2:=B and (Trim(TGame(ListView.Selected.Data).DataDir)<>'');

  MenuProfileOpenFileInDataFolder.Enabled:=False;
  PopupOpenFileInDataFolder.Enabled:=False;
  MenuProfileOpenFileInProgramFolder.Enabled:=False;
  PopupOpenFileInProgramFolder.Enabled:=False;

  while MenuProfileOpenFileInDataFolder.Count>0 do MenuProfileOpenFileInDataFolder.Items[0].Free;
  while PopupOpenFileInDataFolder.Count>0 do PopupOpenFileInDataFolder.Items[0].Free;
  while MenuProfileOpenFileInProgramFolder.Count>0 do MenuProfileOpenFileInProgramFolder.Items[0].Free;
  while PopupOpenFileInProgramFolder.Count>0 do PopupOpenFileInProgramFolder.Items[0].Free;

  If B then G:=TGame(ListView.Selected.Data) else G:=nil;

  If B then begin
    Dir:='';
    If DOSBoxMode(G) then Dir:=ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir));
    If ScummVMMode(G) then Dir:=MakeAbsPath(G.ScummVMPath,PrgSetup.BaseDir);
    If WindowsExeMode(G) then Dir:=ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir));
    If Trim(Dir)<>'' then begin
      Dir:=IncludeTrailingPathDelimiter(Dir);
      if DirectoryExists(Dir) then begin
        FilesAdded:=AddDirToMenu(Dir,False,MenuProfileOpenFileInProgramFolder,PopupOpenFileInProgramFolder,0);
        MenuProfileOpenFileInProgramFolder.Enabled:=FilesAdded;
        PopupOpenFileInProgramFolder.Enabled:=FilesAdded;
      end;
    end;
  end;

  If B2 then begin
    Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(G.DataDir,PrgSetup.BaseDir));
    if DirectoryExists(Dir) then begin
      FilesAdded:=AddDirToMenu(Dir,True,MenuProfileOpenFileInDataFolder,PopupOpenFileInDataFolder,0);
      MenuProfileOpenFileInDataFolder.Enabled:=FilesAdded;
      PopupOpenFileInDataFolder.Enabled:=FilesAdded;
    end;
  end;
end;

Function TDFendReloadedMainForm.AddDirToMenu(const Dir : String; const DataFolder: Boolean; const Menu1, Menu2 : TMenuItem; const Level : Integer) : Boolean;
const DataFiles : Array[0..14] of String = ('.TXT','.DIZ','.1ST','.NFO','.PDF','.INI','.HTM','.HTML','.BMP','.JPG','.JPEG','.PNG','.GIF','.TIF','.TIFF');
Var Rec : TSearchRec;
    I,J,Count : Integer;
    B : Boolean;
    M1,M2,M : TMenuItem;
    S : String;
begin
  result:=False;

  {Subdirectories}
  Count:=0;
  I:=FindFirst(Dir+'*.*',faDirectory,Rec);
  try
    while I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        If Count=20 then begin
          M1:=TMenuItem.Create(Menu1); M1.Caption:='(...)'; M1.Tag:=2; M1.ImageIndex:=8; Menu1.Add(M1);
          M2:=TMenuItem.Create(Menu2); M2.Caption:='(...)'; M2.Tag:=2; M2.ImageIndex:=8; Menu2.Add(M2);
          If DataFolder then begin
            M1.OnClick:=OpenFileInDataFolderMenuWork;
            M2.OnClick:=OpenFileInDataFolderMenuWork;
          end else begin
            M1.OnClick:=OpenFileInDataProgramFolderMenuWork;
            M2.OnClick:=OpenFileInDataProgramFolderMenuWork;
          end;
          break;
        end;
        M1:=TMenuItem.Create(Menu1); M1.Caption:=MaskUnderlineAmpersand(Rec.Name); M1.Tag:=1; M1.ImageIndex:=11; Menu1.Add(M1);
        M2:=TMenuItem.Create(Menu2); M2.Caption:=MaskUnderlineAmpersand(Rec.Name); M2.Tag:=1; M2.ImageIndex:=11; Menu2.Add(M2);
        If Level<2 then begin
          result:=result or AddDirToMenu(Dir+Rec.Name+'\',DataFolder,M1,M2,Level+1);
        end else begin
          M:=TMenuItem.Create(M1); M.Caption:='(...)'; M.Tag:=2; M.ImageIndex:=8; M1.Add(M);
          If DataFolder then M.OnClick:=OpenFileInDataFolderMenuWork else M.OnClick:=OpenFileInDataProgramFolderMenuWork;
          M:=TMenuItem.Create(M2); M.Caption:='(...)'; M.Tag:=2; M.ImageIndex:=8; M2.Add(M);
          If DataFolder then M.OnClick:=OpenFileInDataFolderMenuWork else M.OnClick:=OpenFileInDataProgramFolderMenuWork;
        end;
        inc(Count);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  {Files}
  Count:=0;
  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        If DataFolder then B:=True else begin
          S:=ExtUpperCase(ExtractFileExt(Rec.Name));
          B:=False;
          For J:=Low(DataFiles) to High(DataFiles) do If S=DataFiles[J] then begin B:=True; break; end;
        end;
        If B then begin
          result:=True;
          If Count=20 then begin
            M1:=TMenuItem.Create(Menu1); M1.Caption:='(...)'; M1.Tag:=2; M1.ImageIndex:=8; Menu1.Add(M1);
            M2:=TMenuItem.Create(Menu2); M2.Caption:='(...)'; M2.Tag:=2; M2.ImageIndex:=8; Menu2.Add(M2);
            If DataFolder then begin
              M1.OnClick:=OpenFileInDataFolderMenuWork;
              M2.OnClick:=OpenFileInDataFolderMenuWork;
            end else begin
              M1.OnClick:=OpenFileInDataProgramFolderMenuWork;
              M2.OnClick:=OpenFileInDataProgramFolderMenuWork;
            end;
            break;
          end;
          M1:=TMenuItem.Create(Menu1); M1.Caption:=MaskUnderlineAmpersand(Rec.Name); M1.Tag:=1; M1.ImageIndex:=24; Menu1.Add(M1);
          M2:=TMenuItem.Create(Menu2); M2.Caption:=MaskUnderlineAmpersand(Rec.Name); M2.Tag:=1; M2.ImageIndex:=24; Menu2.Add(M2);
          If DataFolder then begin
            M1.OnClick:=OpenFileInDataFolderMenuWork;
            M2.OnClick:=OpenFileInDataFolderMenuWork;
          end else begin
            M1.OnClick:=OpenFileInDataProgramFolderMenuWork;
            M2.OnClick:=OpenFileInDataProgramFolderMenuWork;
          end;
          inc(Count);
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure TDFendReloadedMainForm.RunFile(const FileName : String);
Var T : String;
begin
  T:=ExtUpperCase(ExtractFileExt(FileName));
  If (T='.JPG') or (T='.JPEG') or (T='.BMP') or (T='.PNG') or (T='.GIF') or (T='.TIF') or (T='.TIFF') then begin
    T:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
    If (T<>'') and (T<>'INTERNAL') then begin
      If PrgSetup.NonModalViewer
        then ShowNonModalImageDialog(Owner,FileName,nil,nil)
        else ShowImageDialog(Owner,FileName,nil,nil);
      exit;
     end;
  end;
  If (T='.WAV') or (T='.MP3') or (T='.OGG') then begin
    T:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
    If (T<>'') and (T<>'INTERNAL') then begin PlaySoundDialog(Owner,FileName,nil,nil); exit; end;
  end;
  If (T='.AVI') or (T='.MPG') or (T='.MPEG') or (T='.WMV') or (T='.ASF') then begin
    T:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
    If (T<>'') and (T<>'INTERNAL') then begin PlayVideoDialog(Owner,FileName,nil,nil); exit; end;
  end;
  If (T='.TXT') or (T='.NFO') or (T='.DIZ') or (T='.1ST') or (T='.INI') then begin
    OpenFileInEditor(FileName);
    exit;
  end;

  ShellExecute(Handle,'open',PChar(FileName),nil,PChar(ExtractFilePath(FileName)),SW_SHOW);
end;

Procedure TDFendReloadedMainForm.OpenFileInDataFolderMenuWork(Sender : TObject);
Var I : Integer;
    Dir,S : String;
    M : TMenuItem;
begin
  M:=Sender as TMenuItem;
  I:=M.Tag;
  If (I<>1) and (I<>2) then exit;
  If I=1 then S:=RemoveUnderline(M.Caption) else S:='';

  M:=M.Parent;
  while (M<>MenuProfileOpenFileInDataFolder) and (M<>PopupOpenFileInDataFolder) do begin
    if M=nil then exit;
    S:=RemoveUnderline(M.Caption)+'\'+S;
    M:=M.Parent;
  end;

  if (ListView.Selected=nil) or (ListView.Selected.Data=nil) or (Trim(TGame(ListView.Selected.Data).DataDir)='') then exit;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(TGame(ListView.Selected.Data).DataDir,PrgSetup.BaseDir));
  If not DirectoryExists(Dir) then exit;

  {I=2 open folder, I=1 open file}
  If I=2
    then ShellExecute(Handle,'open',PChar(Dir+S),nil,PChar(Dir+S),SW_SHOW)
    else RunFile(Dir+S);
end;

Procedure TDFendReloadedMainForm.OpenFileInDataProgramFolderMenuWork(Sender : TObject);
Var I : Integer;
    Dir,S : String;
    M : TMenuItem;
    G : TGame;
begin
  M:=Sender as TMenuItem;
  I:=M.Tag;
  If (I<>1) and (I<>2) then exit;
  If I=1 then S:=RemoveUnderline(M.Caption) else S:='';

  M:=M.Parent;
  while (M<>MenuProfileOpenFileInProgramFolder) and (M<>PopupOpenFileInProgramFolder) do begin
    if M=nil then exit;
    S:=RemoveUnderline(M.Caption)+'\'+S;
    M:=M.Parent;
  end;

  if (ListView.Selected=nil) or (ListView.Selected.Data=nil) then exit;

  G:=TGame(ListView.Selected.Data);
  Dir:='';
  If DOSBoxMode(G) then Dir:=ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir));
  If ScummVMMode(G) then Dir:=MakeAbsPath(G.ScummVMPath,PrgSetup.BaseDir);
  If WindowsExeMode(G) then Dir:=ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir));
  If Trim(Dir)='' then exit;
  Dir:=IncludeTrailingPathDelimiter(Dir);
  If not DirectoryExists(Dir) then exit;

  {I=2 open folder, I=1 open file}
  If I=2
    then ShellExecute(Handle,'open',PChar(Dir+S),nil,PChar(Dir+S),SW_SHOW)
    else RunFile(Dir+S);
end;

Procedure TDFendReloadedMainForm.UpdateAddFromTemplateMenu;
Var TemplateDB : TGameDB;
    I : Integer;
    M : TMenuItem;
begin
  while MenuProfileAddFromTemplate.Count>0 do MenuProfileAddFromTemplate.Items[0].Free;
  while AddButtonMenuAddFromTemplate.Count>0 do AddButtonMenuAddFromTemplate.Items[0].Free;
  while TrayIconPopupAddFromTemplate.Count>0 do TrayIconPopupAddFromTemplate.Items[0].Free;

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  try
    MenuProfileAddFromTemplate.Visible:=(TemplateDB.Count>0);
    AddButtonMenuAddFromTemplate.Visible:=(TemplateDB.Count>0);
    For I:=0 to TemplateDB.Count-1 do begin
      M:=TMenuItem.Create(MenuProfileAddFromTemplate);
      M.Caption:=MaskUnderlineAmpersand(TemplateDB[I].Name);
      M.Tag:=I;
      M.OnClick:=AddFromTemplateClick;
      MenuProfileAddFromTemplate.Add(M);

      M:=TMenuItem.Create(AddButtonMenuAddFromTemplate);
      M.Caption:=MaskUnderlineAmpersand(TemplateDB[I].Name);
      M.Tag:=I;
      M.OnClick:=AddFromTemplateClick;
      AddButtonMenuAddFromTemplate.Add(M);

      M:=TMenuItem.Create(TrayIconPopupAddFromTemplate);
      M.Caption:=MaskUnderlineAmpersand(TemplateDB[I].Name);
      M.Tag:=I;
      M.OnClick:=AddFromTemplateClick;
      TrayIconPopupAddFromTemplate.Add(M);
    end;
  finally
    TemplateDB.Free;
  end;

  If Assigned(QuickStartForm) then QuickStartForm.LoadTemplateList;
end;

procedure TDFendReloadedMainForm.UpdateGamesListByViewFilesFrame(Sender: TObject);
begin
  TreeViewChange(Sender,TreeView.Selected);
end;

Procedure TDFendReloadedMainForm.LoadListViewGUISetup(const ListView : TListView; const Background, FontColor : String; const FontSize : Integer);
Var S : String;
begin
  S:=Trim(Background);
  If S='' then begin ListView.Color:=clWindow; SetListViewImage(ListView,'') end else begin
    try
      ListView.Color:=StringToColor(S); SetListViewImage(ListView,'');
    except
      ListView.Color:=clWindow; SetListViewImage(ListView,MakeAbsPath(S,PrgSetup.BaseDir));
    end;
  end;

  S:=Trim(FontColor);
  If S='' then ListView.Font.Color:=clWindowText else begin
    try ListView.Font.Color:=StringToColor(FontColor); except ListView.Font.Color:=clWindowText; end;
  end;
  ListView.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadLabelGUISetup(const L : TPanel; const Background, FontColor : String; const FontSize : Integer);
Var S : String;
begin
  S:=Trim(Background);
  If S='' then L.Color:=clWindow else begin
    try
      L.Color:=StringToColor(S);
    except
      L.Color:=clWindow;
    end;
  end;

  S:=Trim(FontColor);
  If S='' then L.Font.Color:=clWindowText else begin
    try L.Font.Color:=StringToColor(FontColor); except L.Font.Color:=clWindowText; end;
  end;
  L.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadRichEditGUISetup(const R : TRichEdit; const Background, FontColor : String; const FontSize : Integer);
Var S : String;
begin
  S:=Trim(Background);
  If S='' then R.Color:=clWindow else begin
    try
      R.Color:=StringToColor(S);
    except
      R.Color:=clWindow;
    end;
  end;

  S:=Trim(FontColor);
  If S='' then R.Font.Color:=clWindowText else begin
    try R.Font.Color:=StringToColor(FontColor); except R.Font.Color:=clWindowText; end;
  end;
  R.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadTreeViewGUISetup(const TreeView : TTreeView; const Background, FontColor : String; const FontSize : Integer);
Var S : String;
begin
  S:=Trim(Background);
  If S='' then begin TreeView.Color:=clWindow; end else begin
    try
      TreeView.Color:=StringToColor(S);
    except
      TreeView.Color:=clWindow;
    end;
  end;

  S:=Trim(FontColor);
  If S='' then TreeView.Font.Color:=clWindowText else begin
    try TreeView.Font.Color:=StringToColor(FontColor); except TreeView.Font.Color:=clWindowText; end;
  end;
  TreeView.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadCoolBarGUISetup(const CoolBar : TCoolBar; const Background : String; const FontSize : Integer);
Var S : String;
    P : TPicture;
begin
  S:=Trim(Background);
  CoolBar.Bitmap:=nil;
  If S<>'' then begin
    S:=MakeAbsPath(S,PrgSetup.BaseDir);
    If FileExists(S) then begin
      P:=LoadImageFromFile(S);
      try
        If P<>nil then CoolBar.Bitmap.Assign(P.Graphic);
      finally
        P.Free;
      end;
    end;
  end;

  CoolBar.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.SetupToolbarHints;
begin
  ToolBar.ShowCaptions:=PrgSetup.ShowToolbarTexts;
  ToolBar.List:=ToolBar.ShowCaptions;
  If not ToolBar.ShowCaptions then ToolBar.ButtonWidth:=ToolBar.ButtonHeight;

  ButtonClose.Caption:=LanguageSetup.ButtonClose;
  ButtonRun.Caption:=LanguageSetup.ButtonRun;
  ButtonRunSetup.Caption:=LanguageSetup.ButtonRunSetup;
  ButtonAdd.Caption:=LanguageSetup.ButtonAdd;
  ButtonEdit.Caption:=LanguageSetup.ButtonEdit;
  ButtonDelete.Caption:=LanguageSetup.ButtonDelete;
  If PrgSetup.OldDeleteMenuItem then ButtonDelete.Tag:=MenuProfileDelete.Tag else ButtonDelete.Tag:=MenuProfileDeinstall.Tag;
  ButtonHelp.Caption:=LanguageSetup.ButtonHelp;

  If ToolBar.ShowCaptions then begin
    ButtonClose.Hint:=LanguageSetup.ButtonCloseHintMain;
    ButtonRun.Hint:=LanguageSetup.ButtonRunHintMain;
    ButtonRunSetup.Hint:=LanguageSetup.ButtonRunSetupHintMain;
    ButtonAdd.Hint:=LanguageSetup.ButtonAddHintMain;
    ButtonEdit.Hint:=LanguageSetup.ButtonEditHintMain;
    ButtonDelete.Hint:=LanguageSetup.ButtonDeleteHintMain;
    ButtonHelp.Hint:=LanguageSetup.ButtonHelpHintMain;
  end else begin
    ButtonClose.Hint:=RemoveUnderline(LanguageSetup.ButtonClose)+#13+#13+LanguageSetup.ButtonCloseHintMain;
    ButtonRun.Hint:=RemoveUnderline(LanguageSetup.ButtonRun)+#13+#13+LanguageSetup.ButtonRunHintMain;
    ButtonRunSetup.Hint:=RemoveUnderline(LanguageSetup.ButtonRunSetup)+#13+#13+LanguageSetup.ButtonRunSetupHintMain;
    ButtonAdd.Hint:=RemoveUnderline(LanguageSetup.ButtonAdd)+#13+#13+LanguageSetup.ButtonAddHintMain;
    ButtonEdit.Hint:=RemoveUnderline(LanguageSetup.ButtonEdit)+#13+#13+LanguageSetup.ButtonEditHintMain;
    ButtonDelete.Hint:=RemoveUnderline(LanguageSetup.ButtonDelete)+#13+#13+LanguageSetup.ButtonDeleteHintMain;
    ButtonHelp.Hint:=RemoveUnderline(LanguageSetup.ButtonHelp)+#13+#13+LanguageSetup.ButtonHelpHintMain;
  end;

  GameNotesToolBar.ShowCaptions:=PrgSetup.ShowToolbarTexts;
  GameNotesToolBar.List:=ToolBar.ShowCaptions;
  If not GameNotesToolBar.ShowCaptions then GameNotesToolBar.ButtonWidth:=GameNotesToolBar.ButtonHeight;

  GameNotesCutButton.Caption:=LanguageSetup.Cut;
  GameNotesCutButton.Hint:=LanguageSetup.CutHintMain;
  GameNotesCopyButton.Caption:=LanguageSetup.Copy;
  GameNotesCopyButton.Hint:=LanguageSetup.CopyHintMain;
  GameNotesPasteButton.Caption:=LanguageSetup.Paste;
  GameNotesPasteButton.Hint:=LanguageSetup.PasteHintMain;
  GameNotesUndoButton.Caption:=LanguageSetup.Undo;
  GameNotesUndoButton.Hint:=LanguageSetup.UndoHintMain;

  If GameNotesToolBar.ShowCaptions then begin
    GameNotesCutButton.Hint:=LanguageSetup.CutHintMain;
    GameNotesCopyButton.Hint:=LanguageSetup.CopyHintMain;
    GameNotesPasteButton.Hint:=LanguageSetup.PasteHintMain;
    GameNotesUndoButton.Hint:=LanguageSetup.UndoHintMain;
  end else begin
    GameNotesCutButton.Hint:=RemoveUnderline(LanguageSetup.Cut)+#13+#13+LanguageSetup.CutHintMain;
    GameNotesCopyButton.Hint:=RemoveUnderline(LanguageSetup.Copy)+#13+#13+LanguageSetup.CopyHintMain;
    GameNotesPasteButton.Hint:=RemoveUnderline(LanguageSetup.Paste)+#13+#13+LanguageSetup.PasteHintMain;
    GameNotesUndoButton.Hint:=RemoveUnderline(LanguageSetup.Undo)+#13+#13+LanguageSetup.UndoHintMain;
  end;
end;

Procedure TDFendReloadedMainForm.LoadGUISetup(const PrgStart : Boolean);
Var S : String;
    I : Integer;
    M : TMenuItem;
    St : TStringList;
begin
  LogInfo('### Start of LoadGUISetup ###');
  LogInfo('Setting visible state of menu and toolbar icons');
  If (not PrgSetup.ShowMainMenu) and (not PrgSetup.ShowToolbar) then PrgSetup.ShowMainMenu:=True;

  If (not PrgSetup.ShowToolbarButtonClose) and (not PrgSetup.ShowToolbarButtonRun) and (not PrgSetup.ShowToolbarButtonRunSetup)
  and (not PrgSetup.ShowToolbarButtonAdd) and (not PrgSetup.ShowToolbarButtonEdit) and (not PrgSetup.ShowToolbarButtonDelete)
  and (not PrgSetup.ShowToolbarButtonHelp) and (not PrgSetup.ShowSearchBox) then PrgSetup.ShowToolbarButtonRun:=True;

  LogInfo('Loading icons for buttons');
  St:=TStringList.Create;
  try
    For I:=0 to PrgSetup.WindowsBasedEmulatorsPrograms.Count-1 do St.Add(MakeAbsPath(PrgSetup.WindowsBasedEmulatorsPrograms[I],PrgSetup.BaseDir));
    UserIconLoader.UpdateIconsFromPath(ImageList,St);
  finally
    St.Free;
  end;
  UserIconLoader.IconSet:=PrgSetup.IconSet;
  UserIconLoader.DialogImage(DI_CloseX,FirstRunInfoButton);
  UserIconLoader.DialogImage(DI_CutToClipboard,GameNotesImageList,0);
  UserIconLoader.DialogImage(DI_CopyToClipboard,GameNotesImageList,1);
  UserIconLoader.DialogImage(DI_PasteFromClipboard,GameNotesImageList,2);
  UserIconLoader.DialogImage(DI_Undo,GameNotesImageList,3);
  ViewFilesFrame.LoadLanguage; {to update icons right after program start}

  LogInfo('Setting list view size');
  ListviewScreenshotImageList.Width:=PrgSetup.ScreenshotListViewWidth;
  ListviewScreenshotImageList.Height:=PrgSetup.ScreenshotListViewHeight;
  ListviewIconImageList.Height:=PrgSetup.IconSize;
  ListviewIconImageList.Width:=PrgSetup.IconSize;

  ListView.GridLines:=PrgSetup.GridLinesInGamesList;

  If not PrgStart then begin
    ListView.Items.BeginUpdate;
    try
      S:=GamesListSaveColWidthsToString(ListView);
      ListView.Items.Clear;
      InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
      GamesListLoadColWidthsFromString(ListView,S);
      InitTreeViewForGamesList(TreeView,GameDB);
      if not PrgStart then TreeViewChange(self,TreeView.Selected);
    finally
      ListView.Items.EndUpdate;
    end;
  end;

  LogInfo('Load list view background');
  LoadListViewGUISetup(ListView,PrgSetup.GamesListViewBackground,PrgSetup.GamesListViewFontColor,PrgSetup.GamesListViewFontSize);
  LoadLabelGUISetup(ScreenshotsInfoPanel,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadListViewGUISetup(ScreenshotListView,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadLabelGUISetup(SoundInfoPanel,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadListViewGUISetup(SoundListView,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadLabelGUISetup(VideoInfoPanel,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadListViewGUISetup(VideoListView,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadRichEditGUISetup(GameNotesEdit,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadTreeViewGUISetup(TreeView,PrgSetup.GamesTreeViewBackground,PrgSetup.GamesTreeViewFontColor,PrgSetup.GamesTreeViewFontSize);
  LoadCoolBarGUISetup(CoolBar,PrgSetup.ToolbarBackground,PrgSetup.ToolbarFontSize);
  LoadTreeViewGUISetup(ViewFilesFrame.Tree,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadListViewGUISetup(ViewFilesFrame.List,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);

  LogInfo('Setting up checked menu items');
  CoolBar.Visible:=PrgSetup.ShowToolbar;
  SetupToolbarHints;

  MenuFile.Visible:=PrgSetup.ShowMainMenu;
  MenuView.Visible:=PrgSetup.ShowMainMenu;
  MenuRun.Visible:=PrgSetup.ShowMainMenu;
  MenuProfile.Visible:=PrgSetup.ShowMainMenu;
  MenuExtras.Visible:=PrgSetup.ShowMainMenu;
  MenuHelp.Visible:=PrgSetup.ShowMainMenu;

  MenuViewShowMenubar.Checked:=True; {if menu is invisible this menu item also}
  MenuViewShowToolbar.Checked:=PrgSetup.ShowToolbar;
  ToolbarPopupShowMenubar.Visible:=not PrgSetup.ShowMainMenu;

  ButtonClose.Visible:=PrgSetup.ShowToolbarButtonClose;
  ButtonRun.Visible:=PrgSetup.ShowToolbarButtonRun;
  ButtonRunSetup.Visible:=PrgSetup.ShowToolbarButtonRunSetup;
  ButtonAdd.Visible:=PrgSetup.ShowToolbarButtonAdd;
  ButtonEdit.Visible:=PrgSetup.ShowToolbarButtonEdit;
  ButtonDelete.Visible:=PrgSetup.ShowToolbarButtonDelete;
  ButtonHelp.Visible:=PrgSetup.ShowToolbarButtonHelp;

  SearchEdit.Visible:=PrgSetup.ShowSearchBox;
  MenuViewsShowExtraInfo.Checked:=PrgSetup.ShowExtraInfo;
  MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;
  MenuViewsShowTooltips.Checked:=PrgSetup.ShowTooltips;
  ListView.ShowHint:=PrgSetup.ShowTooltips;

  TreeView.OnChange:=TreeViewChange;

  MenuRunRunScummVM.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  MenuRunOpenScummVMConfig.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  MenuProfileAddScummVM.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  AddButtonMenuAddScummVM.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  MenuHelpScummVMCompatibilityIntern.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  TrayIconPopupAddScummVMProfile.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');

  GameDB.CreateConfFilesOnSave:=(OperationMode<>omPortable) and PrgSetup.CreateConfFilesForProfiles;
  If (OperationMode<>omPortable) and PrgSetup.CreateConfFilesForProfiles then CreateConfFilesForProfiles(GameDB,PrgDataDir+GameListSubDir+'\');

  MenuProfileAddOther.Visible:=(PrgSetup.WindowsBasedEmulatorsNames.Count>0);
  AddButtonMenuAddOther.Visible:=(PrgSetup.WindowsBasedEmulatorsNames.Count>0);
  TrayIconPopupAddOther.Visible:=(PrgSetup.WindowsBasedEmulatorsNames.Count>0);
  MenuProfileAddOther.Clear;
  AddButtonMenuAddOther.Clear;
  TrayIconPopupAddOther.Clear;

  LogInfo('Setting up tray menu');
  For I:=0 to PrgSetup.WindowsBasedEmulatorsNames.Count-1 do begin
    M:=TMenuItem.Create(MainMenu);
    With M do begin Caption:=Format(LanguageSetup.MenuProfileAddOtherBasedGame,[PrgSetup.WindowsBasedEmulatorsNames[I]]); Tag:=4100+I; OnClick:=MenuWork; end;
    MenuProfileAddOther.Add(M);
    M:=TMenuItem.Create(AddButtonPopupMenu);
    With M do begin Caption:=Format(LanguageSetup.MenuProfileAddOtherBasedGame,[PrgSetup.WindowsBasedEmulatorsNames[I]]); Tag:=4100+I; OnClick:=MenuWork; end;
    AddButtonMenuAddOther.Add(M);
    M:=TMenuItem.Create(TrayIconPopupMenu);
    With M do begin Caption:=Format(LanguageSetup.MenuProfileAddOtherBasedGame,[PrgSetup.WindowsBasedEmulatorsNames[I]]); Tag:=4100+I; OnClick:=MenuWork; end;
    TrayIconPopupAddOther.Add(M);
  end;

  LogInfo('### End of LoadGUISetup');
end;

Procedure TDFendReloadedMainForm.StartWizard(const ExeFile : String; const WindowsExeFile : Boolean);
Var G : TGame;
    Ok, B1,B2 : Boolean;
begin
   G:=nil;
   try
     Ok:=ShowWizardDialog(self,GameDB,ExeFile,WindowsExeFile,G,B1,B2,SearchLinkFile);
   finally
     LoadSearchLinks;
   end;
   If Ok then begin
     InitTreeViewForGamesList(TreeView,GameDB);
     TreeViewChange(self,TreeView.Selected);
     SelectGame(G);
     If B1 then MenuWork(ButtonEdit);
   end else begin
     If B2 then MenuWork(MenuProfileAddInstallationSupport);
   end;
end;

Procedure TDFendReloadedMainForm.AddProfile(const ExeFile : String; const Mode : String; const TemplateNr : Integer);
Var G,DefaultGame : TGame;
    TemplateDB : TGameDB;
begin
   G:=nil;
   TemplateDB:=nil;

   If TemplateNr>=0 then begin
     TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
     DefaultGame:=TemplateDB[TemplateNr];
   end else begin
     DefaultGame:=TGame.Create(PrgSetup);
   end;

   Enabled:=False;
   try
     If Mode<>'' then begin
       DefaultGame.ProfileMode:=Mode;
       if not ModernEditGameProfil(self,GameDB,G,DefaultGame,SearchLinkFile,DeleteOnExit,'',ExeFile) then exit;
     end else begin
       If PrgSetup.DFendStyleProfileEditor then begin
         if not EditGameProfil(self,GameDB,G,DefaultGame,SearchLinkFile,DeleteOnExit,'',ExeFile) then exit;
       end else begin
         if not ModernEditGameProfil(self,GameDB,G,DefaultGame,SearchLinkFile,DeleteOnExit,'',ExeFile) then exit;
       end;
     end;
   finally
     Enabled:=True;
     LoadSearchLinks;
     If TemplateNr>=0 then begin
       TemplateDB.Free;
     end else begin
       DefaultGame.ProfileMode:='DOSBox';
       DefaultGame.Free;
     end;
   end;
   InitTreeViewForGamesList(TreeView,GameDB);
   TreeViewChange(self,TreeView.Selected);
   SelectGame(G);
end;

Procedure TDFendReloadedMainForm.AddProfileForWindowsEmulator(const Nr : Integer);
Var S : String;
    G, DefaultGame : TGame;
    ExeFile, Parameters : String;
begin
  If not SelectProgramFile(S,'','',True,Nr,self) then exit;

  DefaultGame:=TGame.Create(PrgSetup);
  G:=nil;

  Enabled:=False;
  try
    DefaultGame.ProfileMode:='Windows';
    ExeFile:=MakeRelPath(PrgSetup.WindowsBasedEmulatorsPrograms[Nr],PrgSetup.BaseDir);
    Parameters:=Format(PrgSetup.WindowsBasedEmulatorsParameters[Nr],[S]);
    DefaultGame.GameParameters:=Parameters;
    if not ModernEditGameProfil(self,GameDB,G,DefaultGame,SearchLinkFile,DeleteOnExit,ChangeFileExt(ExtractFileName(S),''),ExeFile) then exit;
  finally
    Enabled:=True;
    LoadSearchLinks;
    DefaultGame.ProfileMode:='DOSBox';
    DefaultGame.GameParameters:='';
    DefaultGame.Free;
  end;
  InitTreeViewForGamesList(TreeView,GameDB);
  TreeViewChange(self,TreeView.Selected);
  SelectGame(G);
end;

Procedure TDFendReloadedMainForm.AfterSetupDialog(ColWidths, UserCols : String);
Var G : TGame;
    St,St1,St2 : TStringList;
    I : Integer;
begin
   G:=nil;
   If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);
   LoadLanguage(PrgSetup.Language);
   If Assigned(QuickStartForm) then QuickStartForm.BuildTree;
   LoadMenuLanguage;
   If SearchEdit.Font.Color=clGray then begin
     SearchEdit.OnChange:=nil;
     SearchEdit.Text:=LanguageSetup.Search;
     SearchEdit.OnChange:=SearchEditChange;
   end;
   LoadGUISetup(False);
   If ColWidths<>'' then begin
     St1:=ValueToList(UserCols); St2:=ValueToList(GetUserCols); St:=ValueToList(ColWidths);
     try
       For I:=0 to Min(St1.Count,St2.Count)-1 do If ExtUpperCase(St1[I])<>ExtUpperCase(St2[I]) then St[8+I]:='-1';
       ColWidths:=ListToValue(St);
     finally
       St.Free; St1.Free; St2.Free;
     end;
     GamesListLoadColWidthsFromString(ListView,ColWidths);
   end;
   SelectGame(G);
end;

procedure TDFendReloadedMainForm.MenuWork(Sender: TObject);
Var G,G2,DefaultGame : TGame;
    S,T : String;
    L : TList;
    I : Integer;
    P : TPoint;
    St : TStringList;
    B,C : Boolean;
    AutoSetupDB : TGameDB;
begin
  StopCaptureChangeNotify;
  try
    Case (Sender as TComponent).Tag of
      {File}
      1001 : begin
               OpenDialog.Options:=OpenDialog.Options+[ofAllowMultiSelect];
               try
                 OpenDialog.DefaultExt:='conf';
                 OpenDialog.Title:=LanguageSetup.MenuFileImportConfTitle;
                 OpenDialog.Filter:=LanguageSetup.MenuFileImportConfFilter;
                 If not OpenDialog.Execute then exit;
                 For I:=0 to OpenDialog.Files.Count-1 do begin
                   G:=ImportConfFile(GameDB,OpenDialog.Files[I]);
                   If G<>nil then begin
                     InitTreeViewForGamesList(TreeView,GameDB);
                     TreeViewChange(Sender,TreeView.Selected);
                     SelectGame(G);
                   end;
                 end;
               finally
                 OpenDialog.Options:=OpenDialog.Options-[ofAllowMultiSelect];
               end;
             end;
      1002 : begin
               UpdateGameNotes;
               ShowExportGamesListDialog(self,GameDB);
             end;
      1003 : begin UpdateGameNotes; ExportConfFiles(self,GameDB); end;
      1004 : begin UpdateGameNotes; ExportProfFiles(self,GameDB); end;
      1005 : begin UpdateGameNotes; ExportXMLFiles(self,GameDB); end;
      1006 : begin
               S:=GamesListSaveColWidthsToString(ListView);
               T:=GetUserCols;
               if not ShowSetupDialog(self,GameDB,SearchLinkFile) then exit;
               AfterSetupDialog(S,T);
             end;
      1007 : Close;
      1008 : begin
               OpenDialog.Options:=OpenDialog.Options+[ofAllowMultiSelect];
               try
                 OpenDialog.DefaultExt:='prof';
                 OpenDialog.Title:=LanguageSetup.MenuFileImportProfTitle;
                 OpenDialog.Filter:=LanguageSetup.MenuFileImportProfFilter;
                 If not OpenDialog.Execute then exit;
                 For I:=0 to OpenDialog.Files.Count-1 do begin
                   S:=GameDB.ProfFileName(ExtractFileName(OpenDialog.Files[I]),True);
                   if not CopyFile(PChar(OpenDialog.Files[I]),PChar(S),True) then begin
                     MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.Files[I],S]),mtError,[mbOK],0);
                     continue;
                   end;
                   G:=TGame.Create(S);
                   GameDB.Add(G);
                   InitTreeViewForGamesList(TreeView,GameDB);
                   TreeViewChange(Sender,TreeView.Selected);
                   SelectGame(G);
                 end;
               finally
                 OpenDialog.Options:=OpenDialog.Options-[ofAllowMultiSelect];
               end;
             end;
      1009 : begin
               OpenDialog.DefaultExt:='xml';
               {OpenDialog.Title:=LanguageSetup.MenuFileImportXMLTitle;}
               OpenDialog.Title:='XML import';
               {OpenDialog.Filter:=LanguageSetup.MenuFileImportXMLFilter;}
               OpenDialog.Filter:='XML files (*.xml)|*xml|All files|*.*';
               If not OpenDialog.Execute then exit;
               If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
               S:=ImportXMLFile(GameDB,OpenDialog.FileName);
               If S<>'' then begin MessageDlg(S,mtError,[mbOK],0); exit; end;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      1010 : begin
               OpenDialog.Options:=OpenDialog.Options+[ofAllowMultiSelect];
               try
                 OpenDialog.DefaultExt:='zip';
                 OpenDialog.Title:=LanguageSetup.ProfileMountingZipFileGeneral;
                 OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
                 If not OpenDialog.Execute then exit;
                 G:=nil;
                 For I:=0 to OpenDialog.Files.Count-1 do begin
                   G2:=ImportZipPackage(self,OpenDialog.Files[I],GameDB,PrgSetup.ImportZipWithoutDialogIfPossible);
                   If G2<>nil then G:=G2;
                 end;
                 If G=nil then exit;
                 LastSelectedGame:=nil;
                 ListView.Selected:=nil;
                 ListView.Items.Clear;
                 ViewFilesFrame.SetGame(nil);
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
                 SelectGame(G);
               finally
                 OpenDialog.Options:=OpenDialog.Options-[ofAllowMultiSelect];
               end;
             end;
      1011 : begin
               Enabled:=False;
               AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
               try
                 S:=ShowPackageManagerDialog(self,GameDB,AutoSetupDB);
                 If S<>'' then begin
                   PrgSetup.Language:=ExtractFileName(S);
                   AfterSetupDialog('','');
                 end;
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
               finally
                 AutoSetupDB.Free;
                 Enabled:=True;
                 SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
               end;
             end;
      1012 : ShowPackageCreationDialog(self,GameDB);
      1013 : begin UpdateGameNotes; ShowBuildZipPackagesDialog(self,GameDB); end;
      1014 : begin UpdateGameNotes; BuildInstaller(self,GameDB); end;
      1015 : begin
               OpenDialog.DefaultExt:='zip';
               OpenDialog.Title:=LanguageSetup.ProfileMountingZipFileGeneral;
               OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
               If not OpenDialog.Execute then exit;
               G:=RunInstallationFromZipFile(self,GameDB,OpenDialog.FileName);
               If G=nil then exit;
               LastSelectedGame:=nil;
               ListView.Selected:=nil;
               ListView.Items.Clear;
               ViewFilesFrame.SetGame(nil);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      1016 : begin
               S:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
               If not SelectDirectory(Handle,LanguageSetup.MenuFileImportFolderCaption,S) then exit;
               G:=ImportFolder(self,S,GameDB,PrgSetup.ImportZipWithoutDialogIfPossible);
               If G=nil then exit;
               LastSelectedGame:=nil;
               ListView.Selected:=nil;
               ListView.Items.Clear;
               ViewFilesFrame.SetGame(nil);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      1017 : begin
               S:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
               If not SelectDirectory(Handle,LanguageSetup.MenuFileImportFolderCaption,S) then exit;
               G:=RunInstallationFromFolder(self,GameDB,S);
               If G=nil then exit;
               LastSelectedGame:=nil;
               ListView.Selected:=nil;
               ListView.Items.Clear;
               ViewFilesFrame.SetGame(nil);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      {View}
      2001 : begin
               PrgSetup.ShowTree:=not PrgSetup.ShowTree;
               TreeView.Visible:=PrgSetup.ShowTree;
               If TreeView.Visible and (TreeView.Width<50) then TreeView.Width:=50;
               Splitter.Visible:=TreeView.Visible;
               If Splitter.Visible then Splitter.Left:=TreeView.Left+TreeView.Width;
               MenuViewsShowTree.Checked:=PrgSetup.ShowTree;
               If not PrgSetup.ShowTree then begin
                 TreeView.Selected:=nil;
                 TreeViewChange(Sender,nil);
               end;
             end;
      2002 : begin
               PrgSetup.ShowScreenshots:=not PrgSetup.ShowScreenshots;
               CapturePageControl.Visible:=PrgSetup.ShowScreenshots;
               If CapturePageControl.Visible and (CapturePageControl.Height<50) then CapturePageControl.Height:=200;
               Splitter1.Visible:=CapturePageControl.Visible;
               If Splitter1.Visible then Splitter1.Top:=CapturePageControl.Top-Splitter1.Height;
               MenuViewsShowScreenshots.Checked:=PrgSetup.ShowScreenshots;
               ListViewSelectItem(Sender,ListView.Selected,True);
             end;
      2003 : begin
               PrgSetup.ShowSearchBox:=not PrgSetup.ShowSearchBox;
               SearchEdit.Visible:=PrgSetup.ShowSearchBox;
               MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;

               If SearchEdit.Font.Color=clGray then begin
                 SearchEdit.OnChange:=nil;
                 SearchEdit.Text:=LanguageSetup.Search;
                 SearchEdit.OnChange:=SearchEditChange;
               end;
               LoadGUISetup(False);
             end;
      2004 : begin
               PrgSetup.ShowExtraInfo:=not PrgSetup.ShowExtraInfo;
               MenuViewsShowExtraInfo.Checked:=PrgSetup.ShowExtraInfo;
               S:=GamesListSaveColWidthsToString(ListView);
               InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
               GamesListLoadColWidthsFromString(ListView,S);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      2005 : begin
               PrgSetup.ShowTooltips:=not PrgSetup.ShowTooltips;
               MenuViewsShowTooltips.Checked:=PrgSetup.ShowTooltips;
               ListView.ShowHint:=PrgSetup.ShowTooltips;
             end;
      2006 : begin PrgSetup.ListViewStyle:='SimpleListNoIcons'; InitViewStyle; end;
      2007 : begin PrgSetup.ListViewStyle:='SimpleList'; InitViewStyle; end;
      2008 : begin PrgSetup.ListViewStyle:='ListNoIcons'; InitViewStyle; end;
      2009 : begin PrgSetup.ListViewStyle:='List'; InitViewStyle; end;
      2010 : begin PrgSetup.ListViewStyle:='SmallIcons'; InitViewStyle; end;
      2011 : begin PrgSetup.ListViewStyle:='Icons'; InitViewStyle; end;
      2012 : begin PrgSetup.ListViewStyle:='Screenshots'; InitViewStyle; end;
      2013 : If not JustShowingOrHidingQuickStartForm then begin
               JustShowingOrHidingQuickStartForm:=True;
               try
                 If Assigned(QuickStartForm) then begin
                   If not QuickStartForm.Working then FreeAndNil(QuickStartForm)
                 end else begin
                   QuickStartForm:=TQuickStartForm.Create(self);
                   QuickStartForm.OnAddProfile:=AddProfileFromQuickStarter;
                   QuickStartForm.OnMenuCloseNotify:=QuickStarterCloseNotify;
                   QuickStartForm.Show;
                 end;
                 MenuViewsQuickStarter.Checked:=not MenuViewsQuickStarter.Checked;
                 Application.ProcessMessages;
               finally
                 JustShowingOrHidingQuickStartForm:=False;
               end;
             end;
      2014 : begin
               If (not PrgSetup.ShowToolbar) and PrgSetup.ShowMainMenu then begin
                 MessageDlg(LanguageSetup.MenuViewShowMenubarWarning,mtError,[mbOk],0);
                 exit;
               end;
               PrgSetup.ShowMainMenu:=not PrgSetup.ShowMainMenu;
               MenuFile.Visible:=PrgSetup.ShowMainMenu;
               MenuView.Visible:=PrgSetup.ShowMainMenu;
               MenuRun.Visible:=PrgSetup.ShowMainMenu;
               MenuProfile.Visible:=PrgSetup.ShowMainMenu;
               MenuExtras.Visible:=PrgSetup.ShowMainMenu;
               MenuHelp.Visible:=PrgSetup.ShowMainMenu;
               ToolbarPopupShowMenubar.Visible:=not PrgSetup.ShowMainMenu;
               If not PrgSetup.ShowMainMenu then MessageDlg(LanguageSetup.MenuViewShowMenubarRestoreInfo,mtInformation,[mbOK],0);
             end;
      2015 : begin
               If (not PrgSetup.ShowMainMenu) and PrgSetup.ShowToolbar then begin
                 MessageDlg(LanguageSetup.MenuViewShowMenubarWarning,mtError,[mbOk],0);
                 exit;
               end;
               PrgSetup.ShowToolbar:=not PrgSetup.ShowToolbar;
               CoolBar.Visible:=PrgSetup.ShowToolbar;
               MenuViewShowToolbar.Checked:=PrgSetup.ShowToolbar;
             end;
      {Run}
      3001 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               {For fixing problems with not hidden tooltips} ListView.ShowHint:=False; ListView.ShowHint:=PrgSetup.ShowTooltips;
               G:=TGame(ListView.Selected.Data);
               If ScummVMMode(G) then begin
                 RunScummVMGame(G)
               end else begin
                 If WindowsExeMode(G)
                   then RunWindowsGame(G)
                   else RunGame(G,DeleteOnExit);
               end;
             end;
      3002 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               {For fixing problems with not hidden tooltips} ListView.ShowHint:=False; ListView.ShowHint:=PrgSetup.ShowTooltips;
               G:=TGame(ListView.Selected.Data);
               If WindowsExeMode(G) then RunWindowsGame(G,True) else RunGame(G,DeleteOnExit,True);
             end;
      3003 : RunDOSBoxWithDefaultConfFile;
      3004 : begin
               If not FileExists(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName) then begin
                 MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
                 exit;
               end;
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 G:=TGame.Create(TempDir+'TempGameRec.prof');
                 try
                   with G do begin AssignFrom(DefaultGame); GameExe:=''; Autoexec:=''; NrOfMounts:=0; end;
                   RunWithCommandline(G,DeleteOnExit,'-startmapper',True);
                 finally
                   G.Free;
                 end;
               finally
                 DefaultGame.Free;
               end;
               ExtDeleteFile(TempDir+'TempGameRec.prof',ftTemp);
             end;
      3005 : OpenDOSBoxDefaultConfFile;
      3006 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile)
               then ShellExecute(Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile),nil,PChar(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)),SW_SHOW)
               else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile]),mtError,[mbOK],0);
      3007 : begin
               S:=FindScummVMIni;
              If S<>''
                 then OpenFileInEditor(S)
                 else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[S]),mtError,[mbOK],0);
             end;
      3008 : ShowDOSBoxOutputTestDialog(self,GameDB.ConfOpt);
      3010..3059 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
                     G:=TGame(ListView.Selected.Data);
                     If ScummVMMode(G) then exit;
                     If WindowsExeMode(G)
                       then RunWindowssExtraFile(G,(Sender as TComponent).Tag-3010)
                       else RunExtraFile(G,DeleteOnExit,(Sender as TComponent).Tag-3010);
                   end;
      {Profile}
      4000 : begin
               UpdateGameNotes;
               Case PrgSetup.AddButtonFunction of
                 0 : MenuWork(MenuProfileAdd);
                 1 : MenuWork(MenuProfileAddWithWizard);
                 2 : begin
                       P:=ButtonAdd.Parent.ClientToScreen(Point(ButtonAdd.Left,ButtonAdd.Top+ButtonAdd.Height));
                       AddButtonPopupMenu.Popup(P.X,P.Y);
                     end;
               end;
             end;
      4001 : begin UpdateGameNotes; AddProfile('','',-1); SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff); end;
      4002 : begin UpdateGameNotes; StartWizard('',False); SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff); end;
      4003 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               UpdateGameNotes; LastSelectedGame:=nil;
               L:=TList.Create;
               try
                 For I:=0 to ListView.Items.Count-1 do L.Add(ListView.Items[I].Data);
                 G:=TGame(ListView.Selected.Data);
                 Enabled:=False;
                 try
                   If PrgSetup.DFendStyleProfileEditor then begin
                     if not EditGameProfil(self,GameDB,G,nil,SearchLinkFile,DeleteOnExit,'','',L) then exit;
                   end else begin
                     if not ModernEditGameProfil(self,GameDB,G,nil,SearchLinkFile,DeleteOnExit,'','',L) then begin
                       SelectGame(G); {Always update screenshots list (a new image could have been downloaded)}
                       exit;
                     end;
                   end;
                 finally
                   Enabled:=True;
                 end;
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
                 SelectGame(G);
               finally
                 LoadSearchLinks;
                 L.Free;
               end;
             end;
      4004 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               UpdateGameNotes; LastSelectedGame:=nil;
               S:=TGame(ListView.Selected.Data).Name;
               If not ShowCopyProfileDialog(self,Trim(TGame(ListView.Selected.Data).DataDir)<>'',S,B,C) then exit;
               G:=GameDB[GameDB.Add(S)];
               G.AssignFrom(TGame(ListView.Selected.Data));
               G.Name:=S;
               If B then begin
                 S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(G.Name)+'\';
                 I:=0;
                 While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
                   Inc(I);
                   S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(G.Name)+IntToStr(I)+'\';
                 end;
                 G.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
               end;
               If C then G.DataDir:='';
               G.LoadCache;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      4005 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               UpdateGameNotes; LastSelectedGame:=nil;
               G:=TGame(ListView.Selected.Data);
               If PrgSetup.AskBeforeDelete then begin
                 if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecordOnly,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
               end;
               ListView.Items.Clear;
               GameDB.Delete(G);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      4006 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               UpdateGameNotes; LastSelectedGame:=nil;
               G:=TGame(ListView.Selected.Data);
               If WindowsExeMode(G) then begin
                 If PrgSetup.AskBeforeDelete then begin
                   if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecordOnly,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                 end;
                 ListView.Items.Clear;
                 GameDB.Delete(G);
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
               end else begin
                 ListView.OnAdvancedCustomDrawItem:=nil;
                 ViewFilesFrame.SetGame(nil);
                 try
                   if not UninstallGame(self,GameDB,G) then begin
                     If ListView.Selected<>nil then ViewFilesFrame.SetGame(TGame(ListView.Selected.Data));
                     exit;
                   end;
                   LastSelectedGame:=nil;
                   ListView.Selected:=nil;
                   ListView.Items.Clear;
                 finally
                   ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem;
                 end;
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
                 SelectGame(G);
               end;
             end;
      4007 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               S:=''; G:=TGame(ListView.Selected.Data);
               If DOSBoxMode(G) then S:=ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir));
               If ScummVMMode(G) then S:=MakeAbsPath(G.ScummVMPath,PrgSetup.BaseDir);
               If WindowsExeMode(G) then S:=ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir));
               ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
             end;
      4008 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               S:=MakeAbsPath(TGame(ListView.Selected.Data).DataDir,PrgSetup.BaseDir);
               ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
             end;
      4010 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               TGame(ListView.Selected.Data).Favorite:=not TGame(ListView.Selected.Data).Favorite;
               TreeViewChange(Sender,TreeView.Selected);
             end;
      4011 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               If WineSupportEnabled and PrgSetup.LinuxLinkMode then begin
                 CreateLinuxShortCut(self,TGame(ListView.Selected.Data));
               end else begin
                 G:=TGame(ListView.Selected.Data);
                 If WindowsExeMode(G)
                   then ShowCreateShortcutDialog(self,G.Name,G.SetupFile,G.Icon,G.GameExe,G.GameParameters,False,True)
                   else ShowCreateShortcutDialog(self,G.Name,G.SetupFile,G.Icon,'','',ScummVMMode(G),False);
               end;
             end;
      4012 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               UpdateGameNotes;
               BuildInstallerForSingleGame(self,TGame(ListView.Selected.Data));
             end;
      4013 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               G:=TGame(ListView.Selected.Data);
               OpenConfigurationFile(G,DeleteOnExit);
             end;
      4014 : AddProfile('','ScummVM',-1);
      4015 : OpenLink((Sender as TMenuItem).Hint,'<GAMENAME>',TGame(ListView.Selected.Data).Name);
      4016 : If SearchLinkFile.EditFile(False) then LoadSearchLinks;
      4017 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               UpdateGameNotes;
               SaveDialog.DefaultExt:='zip';
               SaveDialog.FileName:=ExtractFileName(ChangeFileExt(TGame(ListView.Selected.Data).SetupFile,''));
               SaveDialog.Title:=LanguageSetup.ProfileMountingZipFileGeneral;
               SaveDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
               SaveDialog.InitialDir:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
               If not SaveDialog.Execute then exit;
               BuildZipPackage(self,TGame(ListView.Selected.Data),SaveDialog.Filename,False);
             end;
      4018 : AddProfile('','Windows',-1);
      4019 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               G:=TGame(ListView.Selected.Data); If Trim(G.CaptureFolder)='' then exit;
               S:=MakeAbsPath(G.CaptureFolder,PrgSetup.BaseDir);
               If DirectoryExists(S) then ShellExecute(Handle,'explore',PChar(S),nil,PChar(S),SW_SHOW)
             end;
      4020 : begin
               Enabled:=False;
               try
                 G:=ShowInstallationSupportDialog(self,GameDB);
                 If G<>nil then begin
                   InitTreeViewForGamesList(TreeView,GameDB);
                   TreeViewChange(self,TreeView.Selected);
                   SelectGame(G);
                 end;
               finally
                 Enabled:=True;
               end;
             end;
      4021 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               S:=Trim(TGame(ListView.Selected.Data).GameExe);
               If S='' then S:=Trim(TGame(ListView.Selected.Data).SetupExe);
               If S='' then S:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir) else S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
               B:=False;
               If ShowCheatApplyDialog(self,S,B) and B then begin
                 ShowCheatDBEditDialog(self,B);
                 If B then ShowUpdateCheckDialog(self,GameDB,SearchLinkFile);
               end;
             end;
      4022 : begin
               G:=TGame(ListView.Selected.Data);
               RunDOSBoxCommandLineOnFolder(MakeAbsPath(ExtractFilePath(G.GameExe),PrgSetup.BaseDir));
             end;
      4100..4199 : AddProfileForWindowsEmulator((Sender as TComponent).Tag-4100);
      {Extras}
      5001 : begin S:=''; ShowIconManager(self,S,PrgSetup.GameDir,True); end;
      5002 : ShowHistoryDialog(self);
      5003 : begin
               If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
               ShellExecute(Handle,'explore',PChar(S),nil,PChar(S),SW_SHOW);
             end;
      5005 : begin
               Enabled:=False;
               try
                 G:=ShowTemplateDialog(self,GameDB,SearchLinkFile,DeleteOnExit);
               finally
                 Enabled:=True;
                 SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
               end;
               LoadSearchLinks;
               UpdateAddFromTemplateMenu;
               if G=nil then exit;
               ListView.Items.Clear;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      5006 : begin
               ListView.OnAdvancedCustomDrawItem:=nil;
               UpdateGameNotes;
               try
                 ViewFilesFrame.SetGame(nil);
                 If not UninstallMultipleGames(self,GameDB) then begin
                   If ListView.Selected<>nil then ViewFilesFrame.SetGame(TGame(ListView.Selected.Data));
                   exit;
                 end;
                 LastSelectedGame:=nil;
                 ListView.Selected:=nil;
                 ListView.Items.Clear;
               finally
                 ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem;
               end;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      5007 : begin
               ShowCreateImageFileDialog(self,True,True,GameDB);
               If NewProfileFromImageCreator<>nil then begin
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
                 SelectGame(NewProfileFromImageCreator);
               end;
             end;
      5008 : begin UpdateGameNotes; TransferGames(self,GameDB); end;
      5010 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then G:=nil else G:=TGame(ListView.Selected.Data);
               If not ShowMultipleProfilesEditorDialog(self,GameDB) then exit;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      5011 : ShowCreateISOImageDialog(self,False);
      5012 : ShowCreateISOImageDialog(self,True);
      5013 : ShowWriteIMGImageDialog(self);
      5014 : ShowExpandImageDialog(self);
      5015 : ShowBuildImageFromFolderDialog(self);
      5016 : begin
               {$IFDEF CheckDoubleChecksums}
               AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
               Enabled:=False;
               try
                 St:=CheckDoubleChecksums(AutoSetupDB);
               finally
                 Enabled:=True;
                 AutoSetupDB.Free;
               end;
               {$ELSE}
               Enabled:=False;
               try
                 St:=CheckGameDB(GameDB);
               finally
                 Enabled:=True;
               end;
               {$ENDIF}
               try
                 If St.Count=0 then begin
                   MessageDlg(LanguageSetup.MissingFilesOK,mtInformation,[mbOK],0);
                 end else begin
                   ShowInfoTextDialog(self,LanguageSetup.MissingFilesCaption,St);
                 end;
               finally
                 St.Free;
               end;
             end;
      5018 : If ShowScanGamesFolderResultsDialog(self,GameDB) then begin
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      5019 : ShowCreateShortcutsDialog(self,GameDB);
      5020 : begin
               if not ShowLanguageEditorStartDialog(self,S) then exit;
               ShowLanguageEditorDialog(self,S);
               If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(LanguageSetup.SetupFile)) then begin
                 LanguageSetup.ReloadINI;
                 LoadLanguage(PrgSetup.Language);
                 LoadMenuLanguage;
                 If SearchEdit.Font.Color=clGray then begin
                   SearchEdit.OnChange:=nil;
                   SearchEdit.Text:=LanguageSetup.Search;
                   SearchEdit.OnChange:=SearchEditChange;
                 end;
                 LoadGUISetup(False);
               end;
             end;
      5021 : begin
               Enabled:=False;
               try
                 If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
                 G:=ShowMakeBootImageFromProfileDialog(self,GameDB,G);
               finally
                 Enabled:=True;
               end;
               if G<>nil then begin
                 ListView.Items.Clear;
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
                 SelectGame(G);
               end;
             end;
      5022 : begin B:=False;
               If ShowCheatApplyDialog(self,MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir),B) and B then begin
                 ShowCheatDBEditDialog(self,B);
                 If B then ShowUpdateCheckDialog(self,GameDB,SearchLinkFile);
               end;
             end;
      5023 : begin
               ShowCheatDBEditDialog(self,B);
               If B then ShowUpdateCheckDialog(self,GameDB,SearchLinkFile);
             end;
      5024 : ShowCheatSearchDialog(self);
      5025 : begin
               Enabled:=False;
               try
                 If ShowDOSBoxLangStartDialog(self,S,T) then ShowDOSBoxLangEditDialog(self,S,T);
               finally
                 Enabled:=True;
               end;
             end;
      {Help}
      6001 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/wiki/'),nil,nil,SW_SHOW);
      6002 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/wiki/Special_Keys'),nil,nil,SW_SHOW);
      6003 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName) then begin
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 RunCommand(DefaultGame,DeleteOnExit,'intro special',True);
               finally
                 DefaultGame.Free;
               end;
             end else begin
               MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
             end;
      6004 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/comp_list.php?letter=a'),nil,nil,SW_SHOW);
      6005 : ShellExecute(Handle,'open',PChar('http:/'+'/pain.scene.org/service_dosbox.php'),nil,nil,SW_SHOW);
      6006 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/wiki/Commands'),nil,nil,SW_SHOW);
      6007 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName) then begin
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 RunCommand(DefaultGame,DeleteOnExit,'intro',True);
               finally
                 DefaultGame.Free;
               end;
             end else begin
               MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
             end;
      6008 : ShellExecute(Handle,'open',PChar(LanguageSetup.MenuHelpHomepageURL),nil,nil,SW_SHOW);
      6009 : {ShellExecute(Handle,'open',PChar('http:/'+'/vogons.zetafleet.com/viewtopic.php?t=17415'),nil,nil,SW_SHOW);}
             Application.HelpCommand(HELP_CONTEXT,ID_HelpForum);
      6010 : ShowUpdateCheckDialog(self,GameDB,SearchLinkFile);
      6014 : ShowStatisticsDialog(self,GameDB);
      6015 : ShowInfoDialog(self);
      6016 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/'),nil,nil,SW_SHOW);
      6017 : If (Trim(PrgSetup.ScummVMPath)<>'') and FileExists(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+'Readme.txt')
               then OpenFileInEditor(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+'Readme.txt')
               else ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/documentation.php'),nil,nil,SW_SHOW);
      6018 : ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/faq.php'),nil,nil,SW_SHOW);
      6019 : ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/'),nil,nil,SW_SHOW);
      6020 : ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/compatibility.php'),nil,nil,SW_SHOW);
      6021 : ShowListScummVMGamesDialog(self);
      6022 : ShowOperationModeInfoDialog(self);
      6024 : Application.HelpCommand(HELP_CONTEXT,ID_Menu);
      6025 : Application.HelpCommand(HELP_CONTEXT,ID_Index);
      6026 : Application.HelpCommand(HELP_CONTEXT,ID_Introduction);
      6027 : Application.HelpCommand(HELP_CONTEXT,ID_Introduction2);
      6028 : Application.HelpCommand(HELP_CONTEXT,ID_HelpGetGames);
      6101 : OpenFileInEditor(PrgSetup.DOSBoxSettings[0].DosBoxDir+RemoveUnderline((Sender as TMenuItem).Caption));
      6102 : If Trim((Sender as TMenuItem).Hint)<>'' then begin
               If not OldGamesMenuUsed then begin
                 MessageDlg(LanguageSetup.MenuHelpAbandonwareInfo,mtInformation,[mbOK],0);
                 OldGamesMenuUsed:=True;
               end;
               ShellExecute(Handle,'open',PChar((Sender as TMenuItem).Hint),nil,nil,SW_SHOW);
             end;
      6103 : If HelpMenuLinkFile.EditFile(True) then LoadAbandonLinks;
    end;
  finally
    StartCaptureChangeNotify;
  end;
end;

Procedure TDFendReloadedMainForm.RunDOSBoxWithDefaultConfFile;
Var D : Double;
    VerString,S,DOSBoxFile : String;
    I : Integer;
begin
  DOSBoxFile:=IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxFileName;
  If not FileExists(DOSBoxFile) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[DOSBoxFile]),mtError,[mbOK],0);
    exit;
  end;

  VerString:=CheckDOSBoxVersion(0);
  S:=VerString; For I:=1 to length(S) do
    if (S[I]=',') or (S[I]='.') then S[I] := FormatSettings.DecimalSeparator;
  If not TryStrToFloat(S,D) then D:=0.72;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_LOCAL_APPDATA))+'DOSBox\dosbox-'+VerString+'.conf';

  If (not FileExists(S)) or (D<=0.72) then begin
    ShellExecute(Handle,'open',PChar(DOSBoxFile),nil,nil,SW_SHOW);
    exit;
  end;

  If D<=0.73 then begin
    ShellExecute(Handle,'open',PChar(DOSBoxFile),PChar('-c '+S),nil,SW_SHOW);
    exit;
  end;

  ShellExecute(Handle,'open',PChar(DOSBoxFile),'-userconf',nil,SW_SHOW);
end;

Procedure TDFendReloadedMainForm.OpenDOSBoxDefaultConfFile;
Var D : Double;
    VerString,S : String;
    I : Integer;
begin
  VerString:=CheckDOSBoxVersion(0);
  S:=VerString; For I:=1 to length(S) do
    if (S[I]=',') or (S[I]='.') then S[I] := FormatSettings.DecimalSeparator;
  If not TryStrToFloat(S,D) then D:=0.72;

  If D<=0.72 then begin
    If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxConfFileName)
      then OpenFileInEditor(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxConfFileName)
      else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxConfFileName]),mtError,[mbOK],0);
    exit;
  end;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_LOCAL_APPDATA))+'DOSBox\dosbox-'+VerString+'.conf';
  If FileExists(S) then begin OpenFileInEditor(S); exit; end;
  If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxConfFileName)
    then OpenFileInEditor(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxConfFileName)
    else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)+DosBoxConfFileName]),mtError,[mbOK],0);
end;

procedure TDFendReloadedMainForm.TrayIconPopupClick(Sender: TObject);
Var G : TGame;
begin
  Case (Sender as TComponent).Tag of
    0 : TrayIconDblClick(Sender);
    1 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAdd); end;
    2 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAddScummVM); end;
    3 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAddWithWizard); end;
    4 : Close;
    5 : ShowMiniRunDialog(self,GameDB);
    6 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAddWindows); end;
   10..20 : begin
              G:=GameDB.Game[GameDB.IndexOf(RemoveUnderline((Sender as TMenuItem).Caption))];
              if G<>nil then begin
                If ScummVMMode(G) then begin
                 RunScummVMGame(G)
               end else begin
                 If WindowsExeMode(G)
                   then RunWindowsGame(G)
                   else RunGame(G,DeleteOnExit);
               end;
              end;
            end;
  end;
end;

procedure TDFendReloadedMainForm.TrayIconPopupMenuPopup(Sender: TObject);
Var I : Integer;
    M : TMenuItem;
    St : TStringList;
begin
  while TrayIconPopupRecentlyStarted.Count>0 do TrayIconPopupRecentlyStarted.Items[0].Free;

  St:=History.GetRecentlyStarted(10,false);
  try
    for I:=0 to St.Count-1 do begin
      M:=TMenuItem.Create(TrayIconPopupRecentlyStarted);
      TrayIconPopupRecentlyStarted.Add(M);
      M.Caption:=St[I];
      M.Tag:=10+I;
      M.OnClick:=TrayIconPopupClick;
    end;
  finally
    St.Free;
  end;

  if MiniRunForm<>nil then begin
    MiniRunForm.Hide;
    MiniRunForm.Close;
    Application.ProcessMessages;
  end;
end;

Procedure TDFendReloadedMainForm.AddFromTemplateClick(Sender: TObject);
begin
  If (Sender as TMenuItem).Parent=TrayIconPopupAddFromTemplate then TrayIconDblClick(Sender);
  AddProfile('','',(Sender as TComponent).Tag);
end;

procedure TDFendReloadedMainForm.ScreenshotListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
    S : String;
    I,J : Integer;
    St1,St2 : TStringList; 
begin
  B:=(Item<>nil);

  ScreenshotPopupOpen.Enabled:=B;
  ScreenshotPopupOpenExternal.Enabled:=B;
  ScreenshotPopupCopy.Enabled:=B;
  ScreenshotPopupSave.Enabled:=B;
  ScreenshotPopupRename.Enabled:=B;
  ScreenshotPopupDelete.Enabled:=B;
  ScreenshotPopupUseAsBackground.Enabled:=B;
  ScreenshotPopupUseInScreenshotList.Enabled:=B;
  If not ScreenshotPopupUseInScreenshotList.Enabled then ScreenshotPopupUseInScreenshotList.Checked:=False else begin
    ScreenshotPopupUseInScreenshotList.Checked:=(ScreenshotListView.Selected<>nil) and (ListView.Selected<>nil) and ((Trim(ExtUpperCase(ScreenshotListView.Selected.Caption))=Trim(ExtUpperCase(TGame(ListView.Selected.Data).ScreenshotListScreenshot))));
  end;

  S:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
  ScreenshotPopupOpenExternal.Visible:=(S='') or (S='INTERNAL');

  If PrgSetup.NonModalViewer and Assigned(ViewImageForm) then begin
    If ListView.Selected=nil then begin
      ShowNonModalImageDialog(self,'',nil,nil);
    end else begin
      St1:=TStringList.Create;
      St2:=TStringList.Create;
      try
        S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
        If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
        If ScreenshotListView.Selected<>nil then J:=ScreenshotListView.Selected.Index else J:=-1;
        For I:=0 to ScreenshotListView.Items.Count-1 do begin
          If I<J then St1.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
          If I>J then St2.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
        end;
        If J<0 then begin
          If St2.Count>0 then begin S:=St2[0]; St2.Delete(0); end else S:='';
        end else begin
          S:=IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[J].Caption;
        end;
        ShowNonModalImageDialog(self,S,St1,St2);
      finally
        St1.Free;
        St2.Free;
      end;
    end;
  end;
end;

procedure TDFendReloadedMainForm.SoundListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
    S : String;
    I : Integer;
begin
  B:=(Item<>nil);

  If B then S:=ExtUpperCase(ExtractFileExt(Item.Caption)) else S:='';

  SoundPopupOpen.Enabled:=B;
  SoundPopupOpenExternal.Enabled:=B;
  SoundPopupSave.Enabled:=B;
  SoundPopupSaveMp3.Enabled:=B and (S='.WAV') and FileExists(PrgSetup.WaveEncMp3);
  SoundPopupSaveOgg.Enabled:=B and (S='.WAV') and FileExists(PrgSetup.WaveEncOgg);
  SoundPopupRename.Enabled:=B;
  SoundPopupDelete.Enabled:=B;

  B:=False;
  For I:=0 to SoundListView.Items.Count-1 do If ExtUpperCase(ExtractFileExt(SoundListView.Items[I].Caption))='.WAV' then begin B:=True; break; end;
  SoundPopupSaveMp3All.Enabled:=B and FileExists(PrgSetup.WaveEncMp3);
  SoundPopupSaveOggAll.Enabled:=B and FileExists(PrgSetup.WaveEncOgg);

  S:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
  SoundPopupOpenExternal.Visible:=(S='') or (S='INTERNAL');
end;

procedure TDFendReloadedMainForm.VideoListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
    S : String;
begin
  B:=(Item<>nil);

  VideoPopupOpen.Enabled:=B;
  VideoPopupOpenExternal.Enabled:=B;
  VideoPopupSave.Enabled:=B;
  VideoPopupRename.Enabled:=B;
  VideoPopupDelete.Enabled:=B;

  S:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
  VideoPopupOpenExternal.Visible:=(S='') or (S='INTERNAL');
end;

procedure TDFendReloadedMainForm.ScreenshotListViewDblClick(Sender: TObject);
begin
  ScreenshotMenuWork(ScreenshotPopupOpen);
end;

procedure TDFendReloadedMainForm.SoundListViewDblClick(Sender: TObject);
begin
  SoundMenuWork(SoundPopupOpen);
end;

procedure TDFendReloadedMainForm.VideoListViewDblClick(Sender: TObject);
begin
  VideoMenuWork(VideoPopupOpen);
end;

procedure TDFendReloadedMainForm.ScreenshotListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssShift]) and (Key=VK_DELETE) then begin ScreenshotMenuWork(ScreenshotPopupDeleteAll); exit; end;
  If (Shift=[ssCtrl]) and (Key=ord('C')) then begin ScreenshotMenuWork(ScreenshotPopupCopy); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : ScreenshotMenuWork(ScreenshotPopupOpen);
    VK_INSERT : ScreenshotMenuWork(ScreenshotPopupImport);
    VK_F5 : ScreenshotMenuWork(ScreenshotPopupRefresh);
    VK_DELETE : ScreenshotMenuWork(ScreenshotPopupDelete);
  end;
end;

procedure TDFendReloadedMainForm.SoundListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssShift]) and (Key=VK_DELETE) then begin SoundMenuWork(SoundPopupDeleteAll); exit; end;
  If (Shift=[ssShift]) and (Key=VK_RETURN) then begin SoundMenuWork(SoundPopupOpenExternal); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : SoundMenuWork(SoundPopupOpen);
    VK_INSERT : SoundMenuWork(SoundPopupImport);
    VK_F5 : SoundMenuWork(SoundPopupRefresh);
    VK_DELETE : SoundMenuWork(SoundPopupDelete);
  end;
end;

procedure TDFendReloadedMainForm.VideoListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssShift]) and (Key=VK_DELETE) then begin VideoMenuWork(VideoPopupDeleteAll); exit; end;
  If (Shift=[ssShift]) and (Key=VK_RETURN) then begin VideoMenuWork(VideoPopupOpenExternal); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : VideoMenuWork(VideoPopupOpen);
    VK_INSERT : VideoMenuWork(VideoPopupImport);
    VK_F5 : VideoMenuWork(VideoPopupRefresh);
    VK_DELETE : VideoMenuWork(VideoPopupDelete);
  end;
end;

procedure TDFendReloadedMainForm.ScreenshotMenuWork(Sender: TObject);
Var S,T : String;
    I : Integer;
    P : TPicture;
    G : TGame;
    WPStype : TWallpaperStyle;
    St1, St2 : TStringList;
begin
  Case (Sender as TComponent).Tag of
    0 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          St1:=TStringList.Create;
          St2:=TStringList.Create;
          try
            For I:=0 to ScreenshotListView.Items.Count-1 do begin
              If I<ScreenshotListView.Selected.Index then St1.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
              If I>ScreenshotListView.Selected.Index then St2.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
            end;
            If PrgSetup.NonModalViewer
              then ShowNonModalImageDialog(self,IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,St1,St2)
              else ShowImageDialog(self,IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,St1,St2);
          finally
            St1.Free;
            St2.Free;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    1 : ListViewSelectItem(Sender,ListView.Selected,True);
    2 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          P:=LoadImageFromFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption);
          try
            if P<>nil then Clipboard.Assign(P);
          finally
            P.Free;
          end;
        end;
    3 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          ScreenshotSaveDialog.FileName:='';
          ScreenshotSaveDialog.Title:=LanguageSetup.ViewImageFormSaveTitle;
          ScreenshotSaveDialog.Filter:=LanguageSetup.ViewImageFormSaveFilter;
          if not ScreenshotSaveDialog.Execute then exit;
          SaveImageToFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,ScreenshotSaveDialog.FileName);
        end;
    4 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          if not ExtDeleteFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,ftMediaViewer) then
            Messagedlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    5 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to ScreenshotListView.Items.Count-1 do if not ExtDeleteFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption,ftMediaViewer) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption]),mtError,[mbOK],0);
            break;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    6 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          S:=Trim(G.CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          OpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
          OpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
          If not OpenDialog.Execute then exit;
          S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OpenDialog.FileName);
          if not CopyFile(PChar(OpenDialog.FileName),PChar(S),True) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,S]),mtError,[mbOK],0);
            exit;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    7 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          If not ShowWallpaperStyleDialog(self,WPStype) then exit;
          SetDesktopWallpaper(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,WPStype);
        end;
    8 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
            S:=IncludeTrailingPathDelimiter(S);
          T:=ChangeFileExt(ScreenshotListView.Selected.Caption,'');
          If not InputQuery(LanguageSetup.ScreenshotPopupRenameCaption,LanguageSetup.ScreenshotPopupRenameLabel,T) then exit;
          T:=T+ExtractFileExt(ScreenshotListView.Selected.Caption);
          If not RenameFile(S+ScreenshotListView.Selected.Caption,S+T) then
            MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[S+ScreenshotListView.Selected.Caption,S+T]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
          T:=Trim(ExtUpperCase(T));
          For I:=0 to ScreenshotListView.Items.Count-1 do
            If Trim(ExtUpperCase(ScreenshotListView.Items[I].Caption))=T then begin
            ScreenshotListView.Selected:=ScreenshotListView.Items[I];
            break;
          end;
          ScreenshotListViewSelectItem(Sender,ScreenshotListView.Selected,ScreenshotListView.Selected<>nil);
        end;
    9 : If (ScreenshotListView.Selected<>nil) and (ListView.Selected<>nil) then begin
          S:=ScreenshotListView.Selected.Caption;
          If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(TGame(ListView.Selected.Data).ScreenshotListScreenshot))
          then TGame(ListView.Selected.Data).ScreenshotListScreenshot:=''
          else TGame(ListView.Selected.Data).ScreenshotListScreenshot:=S;
          TreeViewChange(Sender,TreeView.Selected);
        end;
    10: If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          T:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
          If (T<>'') and (T<>'INTERNAL') then begin
            If PrgSetup.NonModalViewer
              then ShowNonModalImageDialog(self,IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,nil,nil)
              else ShowImageDialog(self,IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,nil,nil);
            exit;
          end;
          ShellExecute(Handle,'open',PChar('"'+IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption+'"'),nil,nil,SW_SHOW);
        end;
    11: If RenameMediaFiles(self,TGame(ListView.Selected.Data),GameDB,rfScreenshots) then TreeViewChange(Sender,TreeView.Selected);
  end;
end;

procedure TDFendReloadedMainForm.SoundMenuWork(Sender: TObject);
Var S,T : String;
    G : TGame;
    I : Integer;
    SaveDialog : TSaveDialog;
    St1,St2 : TStringList;
begin
  Case (Sender as TComponent).Tag of
    0 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          St1:=TStringList.Create;
          St2:=TStringList.Create;
          try
            For I:=0 to SoundListView.Items.Count-1 do begin
              If (I<SoundListView.Selected.Index) then St1.Add(IncludeTrailingPathDelimiter(S)+SoundListView.Items[I].Caption);
              If (I>SoundListView.Selected.Index) then St2.Add(IncludeTrailingPathDelimiter(S)+SoundListView.Items[I].Caption);
            end;
            PlaySoundDialog(self,IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption,St1,St2);
          finally
            St1.Free;
            St2.Free;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    1 : ListViewSelectItem(Sender,ListView.Selected,True);
    2 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          T:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
          If (T<>'') and (T<>'INTERNAL') then begin
            PlaySoundDialog(self,IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption,nil,nil);
            exit;
          end;
          ShellExecute(Handle,'open',PChar('"'+IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption+'"'),nil,nil,SW_SHOW);
        end;
    3 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            T:=ExtractFileExt(S);
            If (T<>'') and (T[1]='.') then T:=Copy(T,2,MaxInt);
            SaveDialog.DefaultExt:=T;
            SaveDialog.FileName:='';
            SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
            T:=Trim(ExtUpperCase(T));
            SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveWAVFilter;
            If T='MP3' then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
            If T='OGG' then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
            If (T='MID') or (T='MIDI') then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMIDFilter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            If not CopyFile(PChar(S),PChar(T),True) then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[S,T]),mtError,[mbOK],0);
          finally
            SaveDialog.Free;
          end;
        end;
    4 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            SaveDialog.DefaultExt:='mp3';
            SaveDialog.FileName:='';
            SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
            SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncMp3),PChar(ProcessEncoderParameters(PrgSetup.WaveEncMp3Parameters,S,T)),nil,SW_SHOW);
          finally
            SaveDialog.Free;
          end;
        end;
    5 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            SaveDialog.DefaultExt:='ogg';
            SaveDialog.FileName:='';
            SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
            SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncOgg),PChar(ProcessEncoderParameters(PrgSetup.WaveEncOggParameters,S,T)),nil,SW_SHOW);
          finally
            SaveDialog.Free;
          end;
        end;
    6 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          if not ExtDeleteFile(IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption,ftMediaViewer) then
            Messagedlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    7 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to SoundListView.Items.Count-1 do if not ExtDeleteFile(IncludeTrailingPathDelimiter(S)+SoundListView.Items[I].Caption,ftMediaViewer) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+SoundListView.Items[I].Caption]),mtError,[mbOK],0);
            break;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    8 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          S:=Trim(G.CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          OpenDialog.Title:=LanguageSetup.SoundCaptureImportTitle;
          OpenDialog.Filter:=LanguageSetup.SoundCaptureImportFilter;
          If not OpenDialog.Execute then exit;
          S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OpenDialog.FileName);
          if not CopyFile(PChar(OpenDialog.FileName),PChar(S),True) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,S]),mtError,[mbOK],0);
            exit;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    9 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S);
          For I:=0 to SoundListView.Items.Count-1 do If ExtUpperCase(ExtractFileExt(SoundListView.Items[I].Caption))='.WAV' then begin
            T:=SoundListView.Items[I].Caption;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncMp3),PChar(ProcessEncoderParameters(PrgSetup.WaveEncMp3Parameters,S+T,S+ChangeFileExt(T,'.mp3'))),nil,SW_SHOW);
          end;
        end;
   10 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S);
          For I:=0 to SoundListView.Items.Count-1 do If ExtUpperCase(ExtractFileExt(SoundListView.Items[I].Caption))='.WAV' then begin
            T:=SoundListView.Items[I].Caption;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncOgg),PChar(ProcessEncoderParameters(PrgSetup.WaveEncOggParameters,S+T,S+ChangeFileExt(T,'.ogg'))),nil,SW_SHOW);
          end;
        end;
   11 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S);
          T:=ChangeFileExt(SoundListView.Selected.Caption,'');
          If not InputQuery(LanguageSetup.ScreenshotPopupRenameCaption,LanguageSetup.ScreenshotPopupRenameLabel,T) then exit;
          T:=T+ExtractFileExt(SoundListView.Selected.Caption);
          If not RenameFile(S+SoundListView.Selected.Caption,S+T) then
            MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[S+SoundListView.Selected.Caption,S+T]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
          T:=Trim(ExtUpperCase(T));
          For I:=0 to SoundListView.Items.Count-1 do
            If Trim(ExtUpperCase(SoundListView.Items[I].Caption))=T then begin
            SoundListView.Selected:=SoundListView.Items[I];
            break;
          end;
          SoundListViewSelectItem(Sender,SoundListView.Selected,SoundListView.Selected<>nil);
        end;
   12 : If RenameMediaFiles(self,TGame(ListView.Selected.Data),GameDB,rfSounds) then TreeViewChange(Sender,TreeView.Selected);
  end;
end;

procedure TDFendReloadedMainForm.VideoMenuWork(Sender: TObject);
Var S,T : String;
    G : TGame;
    I : Integer;
    SaveDialog : TSaveDialog;
    St1,St2 : TStringList;
begin
  Case (Sender as TComponent).Tag of
    0 : If VideoListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          St1:=TStringList.Create;
          St2:=TStringList.Create;
          try
            For I:=0 to VideoListView.Items.Count-1 do begin
              If I<VideoListView.Selected.Index then St1.Add(IncludeTrailingPathDelimiter(S)+VideoListView.Items[I].Caption);
              If I>VideoListView.Selected.Index then St2.Add(IncludeTrailingPathDelimiter(S)+VideoListView.Items[I].Caption);
            end;
            PlayVideoDialog(self,IncludeTrailingPathDelimiter(S)+VideoListView.Selected.Caption,St1,St2);
          finally
            St1.Free;
            St2.Free;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    1 : ListViewSelectItem(Sender,ListView.Selected,True);
    2 : If VideoListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          T:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
          If (T<>'') and (T<>'INTERNAL') then begin
            PlayVideoDialog(self,IncludeTrailingPathDelimiter(S)+VideoListView.Selected.Caption,nil,nil);
            exit;
          end;
          ShellExecute(Handle,'open',PChar('"'+IncludeTrailingPathDelimiter(S)+VideoListView.Selected.Caption+'"'),nil,nil,SW_SHOW);
        end;
    3 : If VideoListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+VideoListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            T:=ExtractFileExt(S);
            If (T<>'') and (T[1]='.') then T:=Copy(T,2,MaxInt);
            SaveDialog.DefaultExt:=T;
            SaveDialog.FileName:='';
            SaveDialog.Title:=LanguageSetup.VideoCaptureSaveTitle;
            SaveDialog.Filter:=LanguageSetup.VideoCaptureSaveFilter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            If not CopyFile(PChar(S),PChar(T),True) then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[S,T]),mtError,[mbOK],0);
          finally
            SaveDialog.Free;
          end;
        end;
    6 : If VideoListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          if not ExtDeleteFile(IncludeTrailingPathDelimiter(S)+VideoListView.Selected.Caption,ftMediaViewer) then
            Messagedlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+VideoListView.Selected.Caption]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    7 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to VideoListView.Items.Count-1 do if not ExtDeleteFile(IncludeTrailingPathDelimiter(S)+VideoListView.Items[I].Caption,ftMediaViewer) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+VideoListView.Items[I].Caption]),mtError,[mbOK],0);
            break;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    8 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          S:=Trim(G.CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          OpenDialog.Title:=LanguageSetup.VideoCaptureImportTitle;
          OpenDialog.Filter:=LanguageSetup.VideoCaptureImportFilter;
          If not OpenDialog.Execute then exit;
          S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OpenDialog.FileName);
          if not CopyFile(PChar(OpenDialog.FileName),PChar(S),True) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,S]),mtError,[mbOK],0);
            exit;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
   11 : If VideoListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S);
          T:=ChangeFileExt(VideoListView.Selected.Caption,'');
          If not InputQuery(LanguageSetup.ScreenshotPopupRenameCaption,LanguageSetup.ScreenshotPopupRenameLabel,T) then exit;
          T:=T+ExtractFileExt(VideoListView.Selected.Caption);
          If not RenameFile(S+VideoListView.Selected.Caption,S+T) then
            MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[S+VideoListView.Selected.Caption,S+T]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
          T:=Trim(ExtUpperCase(T));
          For I:=0 to VideoListView.Items.Count-1 do
            If Trim(ExtUpperCase(VideoListView.Items[I].Caption))=T then begin
            VideoListView.Selected:=VideoListView.Items[I];
            break;
          end;
          VideoListViewSelectItem(Sender,VideoListView.Selected,VideoListView.Selected<>nil);
        end;
   12 : If RenameMediaFiles(self,TGame(ListView.Selected.Data),GameDB,rfVideos) then TreeViewChange(Sender,TreeView.Selected);
  end;
end;

procedure TDFendReloadedMainForm.TreeViewPopupEditUserFiltersClick(Sender: TObject);
Var S,T : String;
begin
  S:=GamesListSaveColWidthsToString(ListView);
  T:=GetUserCols;
  if not ShowTreeListSetupDialog(self,GameDB,SearchLinkFile) then exit;
  AfterSetupDialog(S,T);
end;

procedure TDFendReloadedMainForm.ToolbarPopupClick(Sender: TObject);
Var S,T : String;
begin
  S:=GamesListSaveColWidthsToString(ListView);
  T:=GetUserCols;
  Case (Sender as TComponent).Tag of
    0 : if not ShowToolbarSetupDialog(self,GameDB,SearchLinkFile) then exit;
    1 : if not ShowIconSetSetupDialog(self,GameDB,SearchLinkFile) then exit;
    2 : begin MenuWork(MenuViewShowMenubar); exit; end;
  End;
  AfterSetupDialog(S,T);
end;

procedure TDFendReloadedMainForm.IdleAddonTimerTimer(Sender: TObject);
Var Done : Boolean;
begin
  Done:=False;
  ApplicationEventsIdle(Sender,Done);
end;

function TDFendReloadedMainForm.ApplicationEventsHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
begin
  If (Command=HELP_CONTEXT) and (Data=0) then begin
    CallHelp:=False;
    Application.HelpCommand(HELP_CONTEXT,ID_Index);
  end;
  result:=False;
end;

Procedure ProcessObj(Obj : TObject);
begin
  Obj.Free;
end;

var GameDBCheck : Boolean = false;

procedure TDFendReloadedMainForm.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
Var TopWnd : THandle;
begin
  RunUpdateCheckIdleCloseHandle;

  If DOSBoxCounter.Count>LastDOSBoxCount then begin
    LastTop:=Top;
    LastLeft:=Left;
    LastDOSBoxCount:=DOSBoxCounter.Count;
  end;

  If DOSBoxCounter.Count<LastDOSBoxCount then begin
    if (LastDOSBoxStartTime>0) and (LastDOSBoxStartTime+Cardinal(Min(60,Max(1,PrgSetup.DOSBoxStartFailedTimeout)))*1000>GetTickCount) then begin
      LastDOSBoxStartTime:=0;
      ShowDOSBoxFailedDialog(self,GameDB,LastDOSBoxProfile);
      LastDOSBoxProfile:=nil;
    end else begin
      LastDOSBoxCount:=DOSBoxCounter.Count;
    end;
  end;

  If PrgSetup.MinimizeOnDosBoxStart and PrgSetup.RestoreWhenDOSBoxCloses and (WindowState=wsMinimized) and MinimizedAtDOSBoxStart then begin
    If DOSBoxCounter.Count>0 then exit;
    MinimizedAtDOSBoxStart:=False;
    If PrgSetup.MinimizeToTray then begin
      TrayIconDblClick(Sender);
    end else begin
      Application.Restore;
    end;
  end;

  If PrgSetup.MinimizeOnScummVMStart and PrgSetup.RestoreWhenScummVMCloses and (WindowState=wsMinimized) and MinimizedAtScummVMStart then begin
    If ScummVMCounter.Count>0 then exit;
    MinimizedAtScummVMStart:=False;
    If PrgSetup.MinimizeToTray then begin
      TrayIconDblClick(Sender);
    end else begin
      Application.Restore;
    end;
  end;

  If PrgSetup.MinimizeOnWindowsGameStart and PrgSetup.RestoreWhenWindowsGameCloses and (WindowState=wsMinimized) and MinimizedAtWindowsGameStart then begin
    If WindowsGameCounter.Count>0 then exit;
    MinimizedAtWindowsGameStart:=False;
    If Now-MinimizedAtWindowsGameStartTime<5/86400 then exit;
    If PrgSetup.MinimizeToTray then begin
      TrayIconDblClick(Sender);
    end else begin
      Application.Restore;
    end;
  end;

  If FileConflictCheckRunning then exit;
  FileConflictCheckRunning:=True;
  try
    If (hScreenshotsChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hScreenshotsChangeNotification,0)=WAIT_OBJECT_0) then begin
      UpdateScreenshotList;
      PictureCache.Clear;
      FindNextChangeNotification(hScreenshotsChangeNotification);
    end;

    If (hConfsChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hConfsChangeNotification,0)=WAIT_OBJECT_0) then begin
      ConfFileCheck;
      FindNextChangeNotification(hConfsChangeNotification);
    end;
  finally
    FileConflictCheckRunning:=False;
  end;

  If WaitForSingleObject(hEvent,0)=WAIT_OBJECT_0 then begin
    If TrayIcon.Visible then TrayIconDblClick(Sender) else begin
      if IsIconic(Handle) then ShowWindow(Handle,SW_RESTORE) else begin
        SetForegroundWindow(Handle);
        TopWnd:=GetLastActivePopup(Handle);
        if (TopWnd<>0) and (TopWnd<>Handle) and IsWindowVisible(TopWnd) and IsWindowEnabled(TopWnd)
          then BringWindowToTop(TopWnd)
          else BringWindowToTop(Handle);
      end;
    end;
  end;

  if (not GameDBCheck) and (pos(#68+'-'+#70+'end',Caption)<1) then begin ProcessObj(GameDB); GameDBCheck:=True; end;
end;

Procedure TDFendReloadedMainForm.PostResize(var Msg : TMessage);
begin
  If Assigned(ListView) then ListView.Arrange(arAlignLeft);
  If Assigned(ScreenshotListView) then ScreenshotListView.Arrange(arAlignLeft);
  If Assigned(SoundListView) then SoundListView.Arrange(arAlignLeft);
  If Assigned(VideoListView) then VideoListView.Arrange(arAlignLeft);
end;

procedure TDFendReloadedMainForm.FormResize(Sender: TObject);
begin
  If JustStarted then exit;

  PostMessage(Handle,WM_User+2,0,0);

  If (WindowState=wsMinimized) or (WindowState=wsMaximized) then exit;
  If (BoundsRect.Left<0) and (BoundsRect.Top<0) and (BoundsRect.Right>=Screen.WorkAreaWidth-2) and (BoundsRect.Bottom>=Screen.WorkAreaHeight-2) then exit;

  SaveBoundsRect:=BoundsRect;
  SaveMaximizedState:=(WindowState=wsMaximized);

  If (ListView<>nil) and (ListView.ViewStyle=vsSmallIcon) then ListView.Arrange(arDefault);
end;

procedure TDFendReloadedMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
  If PrgSetup.MinimizeToTray then begin
    TrayIcon.Visible:=True;
    If Assigned(QuickStartForm) then QuickStartForm.Visible:=False;    
    Visible:=False;
  end;

  SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
end;

procedure TDFendReloadedMainForm.ApplicationEventsRestore(Sender: TObject);
begin
  If PrgSetup.MinimizeToTray then begin
    TrayIcon.Visible:=False;
    Visible:=True;
  end;
  ForceForegroundWindow(Application.Handle);
  Application.BringToFront;
  if BorderStyle=bsNone then begin
     Left:=0; Top:=0;
  end else begin
    if (not SaveMaximizedState) and (WindowState<>wsMaximized) then BoundsRect:=SaveBoundsRect;
  end;
end;

procedure TDFendReloadedMainForm.TrayIconDblClick(Sender: TObject);
begin
  Application.Restore;
  If StartTrayMinimize then begin
    StartTrayMinimize:=False;
    Application.ProcessMessages;
    ApplicationEventsRestore(Sender);
    WindowState:=wsNormal;
  end;
end;

procedure TDFendReloadedMainForm.CapturePageControlChange(Sender: TObject);
begin
  If CapturePageControl.ActivePageIndex=DataFilesTab.PageIndex then begin
    If ListView.Selected<>nil then begin
      ViewFilesFrame.Visible:=False;
      ViewFilesFrame.Visible:=True;
      ViewFilesFrame.SetGame(TGame(ListView.Selected.Data));
    end else begin
      ViewFilesFrame.Visible:=False;
    end;
  end;
  If CapturePageControl.ActivePageIndex=GameNotesPanel.PageIndex then begin
    If ListView.Selected<>nil then begin
      GameNotesEdit.Visible:=True;
      GameNotesToolBar.Enabled:=True;
    end else begin
      GameNotesEdit.Visible:=True;
      GameNotesEdit.Visible:=False;
      GameNotesToolBar.Enabled:=False;
    end;
  end;
end;

procedure TDFendReloadedMainForm.GameNotesButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : GameNotesEdit.CutToClipboard;
    1 : GameNotesEdit.CopyToClipboard;
    2 : GameNotesEdit.PasteFromClipboard;
    3 : GameNotesEdit.Undo;
  end;
end;

procedure TDFendReloadedMainForm.GameNotesEditEnter(Sender: TObject);
begin
  MenuRunGame.ShortCut:=0;
  MenuRunSetup.ShortCut:=0;
  MenuProfileAdd.ShortCut:=0;
  MenuProfileEdit.ShortCut:=0;
  MenuProfileCopy.ShortCut:=0;
  MenuProfileDeinstall.ShortCut:=0;
  PopupRunGame.ShortCut:=0;
  PopupRunSetup.ShortCut:=0;
  PopupEdit.ShortCut:=0;
  PopupCopy.ShortCut:=0;
  PopupDeinstall.ShortCut:=0;
end;

procedure TDFendReloadedMainForm.GameNotesEditExit(Sender: TObject);
begin
  MenuRunGame.ShortCut:=ShortCut(VK_Return,[]);
  MenuRunSetup.ShortCut:=ShortCut(VK_Return,[ssShift]);
  MenuProfileAdd.ShortCut:=ShortCut(VK_Insert,[]);
  MenuProfileEdit.ShortCut:=ShortCut(VK_Return,[ssCtrl]);
  MenuProfileCopy.ShortCut:=ShortCut(VK_Insert,[ssShift]);
  MenuProfileDeinstall.ShortCut:=ShortCut(VK_Delete,[ssShift]);
  PopupRunGame.ShortCut:=ShortCut(VK_Return,[]);
  PopupRunSetup.ShortCut:=ShortCut(VK_Return,[ssShift]);
  PopupEdit.ShortCut:=ShortCut(VK_Return,[ssCtrl]);
  PopupCopy.ShortCut:=ShortCut(VK_Insert,[ssShift]);
  PopupDeinstall.ShortCut:=ShortCut(VK_Delete,[ssShift]);
end;

Procedure TDFendReloadedMainForm.ConfFileCheck;
Var I : Integer;
    St,St2 : TStringList;
    G,Game : TGame;
    Rec : TSearchRec;
    NeedListUpdate : Boolean;
begin
  St:=TStringList.Create;
  St2:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do Case GameDB[I].CheckAndUpdateTimeStamp of
      fcsChanged : St.AddObject(GameDB[I].CacheName,GameDB[I]);
      fcsDeleted : St2.AddObject(GameDB[I].CacheName,GameDB[I]);
    end;
    If (St.Count>0) or (St2.Count>0) then begin
      G:=nil; if ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);
      If St2.Count>0 then ListView.Items.Clear;
      If St.Count>0 then ShowCacheChooseDialog(self,St,GameDB);
      If St2.Count>0 then ShowRestoreDeletedDialog(self,St2,GameDB);
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
    end;
  finally
    St.Free;
    St2.Free;
  end;

  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do St.Add(Trim(ExtUpperCase(ExtractFileName(GameDB[I].SetupFile))));
    NeedListUpdate:=False;
    G:=nil; if ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);
    I:=FindFirst(PrgDataDir+GameListSubDir+'\*.prof',faAnyFile,Rec);
    try
      while I=0 do begin
        If St.IndexOf(Trim(ExtUpperCase(Rec.Name)))<0 then begin
          Game:=TGame.Create(PrgDataDir+GameListSubDir+'\'+Rec.Name);
          GameDB.Add(Game);
          NeedListUpdate:=True;
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
    If NeedListUpdate then begin
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
    end;
  finally
    St.Free;
  end;
end;

Procedure TDFendReloadedMainForm.DropImportFile(const FileName: String; var ErrorCode : String);
Var FileExt : String;
    G : TGame;
    S : String;
    B : Boolean;
    I,J : Integer;
    St : TStringList;
begin
  StopCaptureChangeNotify;
  try
    ErrorCode:='';

    FileExt:=Trim(ExtUpperCase(ExtractFileExt(FileName)));
    G:=nil; If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);

    if DirectoryExists(FileName) then begin
      B:=False;
      If (G<>nil) and (Trim(G.DataDir)<>'') and DirectoryExists(MakeAbsPath(G.DataDir,PrgSetup.BaseDir)) then begin
        B:=(MessageDlg(Format(LanguageSetup.DragDropImportFolderConfirmation,[FileName,G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes);
      end;
      If B then begin
        {Copy to DataDir}
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(G.DataDir,PrgSetup.BaseDir))+ExtractFileName(FileName);
        If not ForceDirectories(S) then begin ErrorCode:=Format(LanguageSetup.MessageCouldNotCreateDir,[S]); exit; end;
        If not CopyFiles(FileName,S,True,True) then ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFiles,[FileName,S]);
      end else begin
        {Import folder as game}
        ListView.OnAdvancedCustomDrawItem:=nil;
        try
          G:=ImportFolder(self,FileName,GameDB,PrgSetup.ImportZipWithoutDialogIfPossible);
          If G=nil then exit;
          LastSelectedGame:=nil;
          ListView.Selected:=nil;
          ListView.Items.Clear;
          ViewFilesFrame.SetGame(nil);
        finally
          ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem;
        end;
        InitTreeViewForGamesList(TreeView,GameDB);
        TreeViewChange(self,TreeView.Selected);
        SelectGame(G);
      end;
      exit;
    end;

    If FileExt='.CONF' then begin
      G:=ImportConfFile(GameDB,FileName);
      If G=nil then exit;
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(nil,TreeView.Selected);
      SelectGame(G);
      exit;
    end;

    If FileExt='.PROF' then begin
      S:=GameDB.ProfFileName(ExtractFileName(FileName),True);
      if not CopyFile(PChar(FileName),PChar(S),True) then begin
        ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
        exit;
      end;
      G:=TGame.Create(S);
      GameDB.Add(G);
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(nil,TreeView.Selected);
      SelectGame(G);
      exit;
    end;

    If (FileExt='.JPG') or (FileExt='.JPEG') or (FileExt='.PNG') or (FileExt='.GIF') or (FileExt='.BMP') then begin
      If G<>nil then begin
        S:=Trim(G.CaptureFolder);
        If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
        If S='' then exit;
        S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(FileName);
        If FileExists(S) then begin
          If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
        end;
        if not CopyFile(PChar(FileName),PChar(S),False) then
          ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
        exit;
      end else begin
        ErrorCode:=Format(LanguageSetup.DragDropErrorNoProfileSelectedForScreenshots,[ExtractFileName(FileName)]);
        exit;
      end;
    end;

    If (FileExt='.WAV') or (FileExt='.MP3') or (FileExt='.OGG') or (FileExt='.MID') or (FileExt='.MIDI') then begin
      If G<>nil then begin
        S:=Trim(G.CaptureFolder);
        If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
        If S='' then exit;
        S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(FileName);
        If FileExists(S) then begin
          If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
        end;
        if not CopyFile(PChar(FileName),PChar(S),False) then ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
        exit;
      end else begin
        ErrorCode:=Format(LanguageSetup.DragDropErrorNoProfileSelectedForSoundFiles,[ExtractFileName(FileName)]);
        exit;
      end;
    end;

    If (FileExt='.AVI') or (FileExt='.MPEG') or (FileExt='.MPG') or (FileExt='.WMV') or (FileExt='.ASF') then begin
      If G<>nil then begin
        S:=Trim(G.CaptureFolder);
        If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
        If S='' then exit;
        S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(FileName);
        If FileExists(S) then begin
          If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
        end;
        if not CopyFile(PChar(FileName),PChar(S),False) then ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
        exit;
      end else begin
        ErrorCode:=Format(LanguageSetup.DragDropErrorNoProfileSelectedForVideoFiles,[ExtractFileName(FileName)]);
        exit;
      end;
    end;

    If (FileExt='.EXE') or (FileExt='.COM') or (FileExt='.BAT') or (FileExt='.BAS') then begin
      If FileExt='.EXE' then B:=IsWindowsExe(FileName) else B:=False;
      StartWizard(FileName,B);
      exit;
    end;

    B:=(FileExt='.ZIP') or (FileExt='.7Z');
    If not B then For I:=0 to PrgSetup.PackerSettingsCount-1 do If ExtensionInList(FileExt,PrgSetup.PackerSettings[I].FileExtensions) then begin B:=True; break; end;
    If B then begin
      ListView.OnAdvancedCustomDrawItem:=nil;
      try
        G:=ImportZipPackage(self,FileName,GameDB,PrgSetup.ImportZipWithoutDialogIfPossible);
        If G=nil then exit;
        LastSelectedGame:=nil;
        ListView.Selected:=nil;
        ListView.Items.Clear;
        ViewFilesFrame.SetGame(nil);
      finally
        ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem;
      end;
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
      exit;
    end;

    If (FileExt='.IMG') or (FileExt='.IMA') then begin
      ListView.OnAdvancedCustomDrawItem:=nil;
      try
        G:=RunInstallationFromDiskImage(self,GameDB,FileName);
        If G=nil then exit;
        LastSelectedGame:=nil;
        ListView.Selected:=nil;
        ListView.Items.Clear;
        ViewFilesFrame.SetGame(nil);
      finally
        ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem;
      end;
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
      exit;
    end;

    If (FileExt='.ISO') or (FileExt='.CUE') or (FileExt='.BIN') then begin
      ListView.OnAdvancedCustomDrawItem:=nil;
      try
        G:=RunInstallationFromCDImage(self,GameDB,FileName);
        If G=nil then exit;
        LastSelectedGame:=nil;
        ListView.Selected:=nil;
        ListView.Items.Clear;
        ViewFilesFrame.SetGame(nil);
      finally
        ListView.OnAdvancedCustomDrawItem:=ListViewAdvancedCustomDrawItem;
      end;
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
      exit;
    end;

    {User-Interpreters}
    For I:=0 to PrgSetup.DOSBoxBasedUserInterpretersExtensions.Count-1 do begin
      St:=ValueToList(PrgSetup.DOSBoxBasedUserInterpretersExtensions[I]);
      try
        For J:=0 to St.Count-1 do begin
          S:=Trim(ExtUpperCase(St[J])); if (S<>'') and (S[1]<>'.') then S:='.'+S;
          if S=FileExt then begin
            StartWizard(FileName,False);
            exit;
          end;
        end;
      finally
        St.Free;
      end;
    end;

    {Otherwise try to copy the file to the game DataDir}
    If G<>nil then begin
      If (Trim(G.DataDir)<>'') and DirectoryExists(MakeAbsPath(G.DataDir,PrgSetup.BaseDir)) then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(G.DataDir,PrgSetup.BaseDir))+ExtractFileName(FileName);
        If FileExists(S) then begin
          If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
        end;
        if not CopyFile(PChar(FileName),PChar(S),False) then
          ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
        exit;
      end;
    end else begin
      ErrorCode:=Format(LanguageSetup.DragDropErrorUnknownExtension,[ExtractFileName(FileName)]);
    end;
  finally
    StartCaptureChangeNotify;
  end;
end;

procedure TDFendReloadedMainForm.MainDragDrop(Sender, Source: TObject; X, Y: Integer);
Var FileList, Errors : TStringList;
    I : Integer;
    S : String;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  Errors:=TStringList.Create;
  try
    For I:=0 to FileList.Count-1 do begin
      S:=''; DropImportFile(FileList[I],S);
      If S<>'' then Errors.Add(S);
    end;
    If Errors.Count>0 then ShowDragNDropErrorDialog(self,Errors);
  finally
    Errors.Free;
  end;
end;

procedure TDFendReloadedMainForm.CaptureDragDrop(Sender, Source: TObject; X, Y: Integer);
Var FileList, Errors : TStringList;
    I : Integer;
    Dir : String;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then exit;
  Dir:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
  If Dir='' then exit;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(Dir,PrgSetup.BaseDir));
  If not ForceDirectories(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
    exit;
  end;

  Errors:=TStringList.Create;
  try
    For I:=0 to FileList.Count-1 do begin
      If DirectoryExists(FileList[I]) then begin
        Errors.Add(Format(LanguageSetup.MessageCouldNotCopyDirectoriesToCapture,[FileList[I]]));
        continue;
      end;
      If FileExists(Dir+ExtractFileName(FileList[I])) then begin
        If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[Dir+ExtractFileName(FileList[I])]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then continue;
      end;
      If not CopyFile(PChar(FileList[I]),PChar(Dir+ExtractFileName(FileList[I])),False) then begin
        Errors.Add(Format(LanguageSetup.MessageCouldNotCopyFile,[FileList[I],Dir+ExtractFileName(FileList[I])]));
      end;
    end;
    If Errors.Count>0 then ShowDragNDropErrorDialog(self,Errors);
  finally
    Errors.Free;
  end;
end;

Procedure TDFendReloadedMainForm.WMMove(Var Message : TWMMove);
begin
  If (DOSBoxCounter.Count=0) and (LastDOSBoxCount>0) and (LastTop>=0) and (LastLeft>=0) and (not SaveMaximizedState) then begin
    Top:=LastTop;
    Left:=LastLeft;
  end;
  LastDOSBoxCount:=DOSBoxCounter.Count;
  LastTop:=Top;
  LastLeft:=Left;
  FormResize(self);
end;

procedure TDFendReloadedMainForm.ZipInfoNotify(Sender: TObject);
begin
  ZipInfoPanel.Visible:=(ZipManager.Count>0);
end;

procedure TDFendReloadedMainForm.ZipInfoPanelDblClick(Sender: TObject);
begin
  ShowZipWaitInfoDialog(self);
end;

procedure TDFendReloadedMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Action=caHide then HTMLhelpRouter.Free;
end;

procedure TDFendReloadedMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If ZipManager.Count>0 then begin
    If MessageDlg(LanguageSetup.ZipFormCloseWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then CanClose:=False;
  end;
end;

procedure TDFendReloadedMainForm.AddProfileFromQuickStarter(Sender: TObject; const FileName: String; const WindowsProfile, UseWizard: Boolean; const TemplateNr : Integer);
Var S : String;
begin
  If UseWizard then begin
    StartWizard(MakeRelPath(FileName,PrgSetup.BaseDir),WindowsProfile);
  end else begin
    If WindowsProfile then S:='Windows' else S:='';
    AddProfile(MakeRelPath(FileName,PrgSetup.BaseDir),S,TemplateNr);
  end;  
end;

Procedure TDFendReloadedMainForm.QuickStarterCloseNotify(Sender : TObject);
begin
  MenuViewsQuickStarter.Checked:=False;
end;

procedure TDFendReloadedMainForm.DisplayResolutionChange(var Msg: TMessage);
begin
  If Msg.WParam<=8 then exit;
  ListViewSelectItem(self,ListView.Selected,ListView.Selected<>nil);
end;

procedure TDFendReloadedMainForm.FirstRunInfoButtonClick(Sender: TObject);
begin
  FirstRunInfoPanel.Visible:=False;
  PrgSetup.ShowAddGameInfoOnEmptyGamesList:=False;
end;

function DragDropExFormatEtc(const Fmt: TClipFormat) : TFormatEtc;
begin
  with result do begin
    cfFormat:=Fmt;
    ptd:=nil; {device independent}
    dwAspect:=DVASPECT_CONTENT; {full detail}
    lindex:=-1; {all the data}
    tymed:=TYMED_HGLOBAL;
  end;
end;

function DragDropExHasFormat(const DataObj: IDataObject; const Fmt: TClipFormat): Boolean;
begin
  Result:=(DataObj.QueryGetData(DragDropExFormatEtc(Fmt))=S_OK);
end;

function DragDropExGetTextFromObj(const DataObj: IDataObject; const Fmt: TClipFormat): string;
var Medium: TStgMedium;
    PText: PChar;
begin
  if DataObj.GetData(DragDropExFormatEtc(Fmt),Medium)<>S_OK then begin result:=''; exit; end;
  try
    PText:=GlobalLock(Medium.hGlobal);
    try
      Result:=PText;
    finally
      GlobalUnlock(Medium.hGlobal);
    end;
  finally
    ReleaseStgMedium(Medium);
  end;
end;

function TDFendReloadedMainForm.DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
Var B1,B2,B3,B4,B5 : Boolean;
begin
  B1:=(Screen.ActiveForm=DFendReloadedMainForm);
  B2:=(Screen.ActiveForm=QuickStartForm);
  B3:=DragDropExHasFormat(dataObj,CF_TEXT);
  B4:=DragDropExHasFormat(dataObj,CF_OEMTEXT);
  B5:=DragDropExHasFormat(dataObj,CF_HDROP);

  If (B1 or B2) and (B3 or B4 or B5) then begin
    dwEffect:=DROPEFFECT_LINK;
    Result:=S_OK;
    LastDragDropEffect:=DROPEFFECT_LINK;
  end else begin
    Result:=S_FALSE;
    LastDragDropEffect:=DROPEFFECT_NONE;
  end;
end;

function TDFendReloadedMainForm.DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
begin
  dwEffect:=LastDragDropEffect;
  Result:=S_OK;
end;

function TDFendReloadedMainForm.DragLeave: HResult; stdcall;
begin
  Result:=S_OK;
  LastDragDropEffect:=DROPEFFECT_NONE;
end;

function TDFendReloadedMainForm.Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
Var S,T : String;
    G : TGame;
begin
  If DragDropExHasFormat(dataObj,CF_TEXT) or DragDropExHasFormat(dataObj,CF_OEMTEXT) then begin
    dwEffect:=DROPEFFECT_COPY;
    Result:=S_OK;
    If DragDropExHasFormat(dataObj,CF_TEXT) then begin
      S:=DragDropExGetTextFromObj(dataObj,CF_TEXT);
    end else begin
      S:=DragDropExGetTextFromObj(dataObj,CF_OEMTEXT);
    end;
    T:=ExtUpperCase(S);
    If (Copy(T,1,7)='HTTP:/'+'/') or (Copy(T,1,8)='HTTPS:/'+'/') or (Copy(T,1,6)='FTP:/'+'/') then begin
      G:=DonwloadAndInstall(self,S,GameDB);
      If G<>nil then begin
        InitTreeViewForGamesList(TreeView,GameDB);
        TreeViewChange(self,TreeView.Selected);
        SelectGame(G);
      end;
    end;
  end else begin
    If DragDropExHasFormat(dataObj,CF_HDROP) then begin
      Result:=2; {if not a link use the normal handler to handle droped files etc.}
    end else begin
      Result:=S_FALSE;
    end;
  end;
end;

initialization
  OleInitialize(nil);
finalization
  OleUninitialize;
end.
