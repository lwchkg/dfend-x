unit QuickStartFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, StdCtrls, ImgList, Menus, GameDBUnit;

Type TProfileAddEvent=Procedure(Sender : TObject; const FileName : String; const WindowsProfile, UseWizard : Boolean; const TemplateNr : Integer) of object;
     TFilesDropEvent=Procedure(Sender : TObject; const FileList : TStringList) of object;

type
  TQuickStartForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton2: TToolButton;
    UpdateButton: TToolButton;
    StartButton: TToolButton;
    ToolButton1: TToolButton;
    HelpButton: TToolButton;
    BottomPanel: TPanel;
    MainPanel: TPanel;
    TemplateComboBox: TComboBox;
    ImageList: TImageList;
    LeftPanel: TPanel;
    TreeTypeComboBox: TComboBox;
    Tree: TTreeView;
    Splitter: TSplitter;
    TreePopupMenu: TPopupMenu;
    ListPopupMenu: TPopupMenu;
    TreeViewMode: TMenuItem;
    TreeViewModeGames: TMenuItem;
    TreeViewModeFull: TMenuItem;
    TreeExplorer: TMenuItem;
    TreeDOSBox: TMenuItem;
    ListRun: TMenuItem;
    N2: TMenuItem;
    ListMakeProfile: TMenuItem;
    ListMakeProfileWizard: TMenuItem;
    N3: TMenuItem;
    ListExplorer: TMenuItem;
    ListDOSBox: TMenuItem;
    TreeUpdate: TMenuItem;
    ListUpdate: TMenuItem;
    ListOpenInEditor: TMenuItem;
    ListRename: TMenuItem;
    ListDelete: TMenuItem;
    TreeRename: TMenuItem;
    SetupComboBox1: TComboBox;
    SetupComboBox2: TComboBox;
    TreeDelete: TMenuItem;
    TreeViewModeCapture: TMenuItem;
    TreeViewModeData: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ListRunWithParameters: TMenuItem;
    ListOpenInDefaultViewer: TMenuItem;
    List: TListView;
    TreeCreateFolder: TMenuItem;
    ListCreateFolder: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeTypeComboBoxChange(Sender: TObject);
    procedure TreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MenuWork(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure ListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreePopupMenuPopup(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListPopupMenuPopup(Sender: TObject);
  private
    { Private-Deklarationen }
    CurrentPath : String;
    GameDir, CaptureDir, DataDir : String;
    FOnAddProfile : TProfileAddEvent;
    FOnMenuCloseNotify : TNotifyEvent;
    PopupSelNode : TTreeNode;
    hChangeNotification : THandle;
    Timer : TTimer;
    TreeBaseDir : String;
    DisableCounter : Integer;
    Procedure DisableGUI;
    Procedure EnableGUI;
    Procedure BuildList;
    Function AddSubfolders(Folder: String; const ParentNode: TTreeNode; ExpandPath : String; const UpdateSort : Boolean) : TTreeNode;
    Function PathFromNode(const Node : TTreeNode) : String;
    Procedure OpenFolderInDOSBox;
    Procedure OpenDOSBox(const Path, FileName, Parameters : String);
    Procedure CheckPathAvialableInProfile(const Game : TGame; const Path : String);
    Procedure AddAutoexecCDCommands(const Game : TGame; const Path : String);
    Procedure TimerWork(Sender : TObject);
    Procedure GetFilesInFolder(const Extensions : Array of String; const FileName : String; var St1, St2 : TStringList);
    Procedure RunFile(const FileName : String; const TypeNr : Integer; const WithParameters : Boolean);
    Procedure AddProfile(const FileName : String; const WindowsProfile, UseWizard : Boolean);
    Procedure LoadStartButtonLanguage(Item : TListItem);
  public
    { Public-Deklarationen }
    Working : Boolean;
    Procedure LoadTemplateList;
    Procedure BuildTree;
    Procedure LoadLanguage;
    property OnAddProfile : TProfileAddEvent read FOnAddProfile write FOnAddProfile;
    property OnMenuCloseNotify : TNotifyEvent read FOnMenuCloseNotify write FOnMenuCloseNotify;
  end;

var
  QuickStartForm: TQuickStartForm = nil;
  JustShowingOrHidingQuickStartForm : Boolean = False;

implementation

uses ShellAPI, Math, CommonTools, VistaToolsUnit, LanguageSetupUnit,
     PrgSetupUnit, PrgConsts, DOSBoxUnit, HelpConsts, IconLoaderUnit,
     ViewImageFormUnit, PlaySoundFormUnit, PlayVideoFormUnit, GameDBToolsUnit,
     ClassExtensions, DOSBoxTempUnit, MainUnit;

{$R *.dfm}

Type TOpenType=(otNone, otOpen, otDOSBox, otImageViewer, otSoundPlayer, otVideoPlayer, otEditor);
     TFileTypeOptions=(ftAddEditItem, ftCanMakeProfileOf, ftRunWithParameters, ftDOSExe, ftWindowsExe);
     TFileTypeOptionsSet=Set of TFileTypeOptions;

Type TFileTypeInfo=record
  Ext : String; {uppercase and with leading "."}
  NameID : Integer;
  ImageIndex : Integer;
  OpenType : TOpenType;
  Options : TFileTypeOptionsSet;
end;

const FileTypes : Array[0..54] of TFileTypeInfo=
  ((Ext: '.EXE'; NameID: NR_QuickStarterColumnsTypeDOS; ImageIndex: 9; OpenType: otDOSBox; Options: [ftCanMakeProfileOf,ftDOSExe, ftRunWithParameters]),
   (Ext: '.EXE'; NameID: NR_QuickStarterColumnsTypeWindows; ImageIndex: 10; OpenType: otOpen; Options: [ftCanMakeProfileOf,ftWindowsExe, ftRunWithParameters]),
   (Ext: '.COM'; NameID: NR_QuickStarterColumnsTypeDOS; ImageIndex: 9; OpenType: otDOSBox; Options: [ftCanMakeProfileOf, ftRunWithParameters]),
   (Ext: '.BAT'; NameID: NR_QuickStarterColumnsTypeBatch; ImageIndex: 9; OpenType: otDOSBox; Options: [ftCanMakeProfileOf,ftAddEditItem, ftRunWithParameters]),

   (Ext: '.TXT'; NameID: NR_QuickStarterColumnsTypeText; ImageIndex: 8; OpenType: otEditor; Options: []),
   (Ext: '.NFO'; NameID: NR_QuickStarterColumnsTypeText; ImageIndex: 8; OpenType: otEditor; Options: []),
   (Ext: '.DIZ'; NameID: NR_QuickStarterColumnsTypeText; ImageIndex: 8; OpenType: otEditor; Options: []),
   (Ext: '.1ST'; NameID: NR_QuickStarterColumnsTypeText; ImageIndex: 8; OpenType: otEditor; Options: []),

   (Ext: '.INI'; NameID: NR_QuickStarterColumnsTypeConfiguration; ImageIndex: 8; OpenType: otEditor; Options: []),
   (Ext: '.CFG'; NameID: NR_QuickStarterColumnsTypeConfiguration; ImageIndex: 8; OpenType: otEditor; Options: []),

   (Ext: '.JPG'; NameID: NR_QuickStarterColumnsTypeImage; ImageIndex: 11; OpenType: otImageViewer; Options: []),
   (Ext: '.JPEG'; NameID: NR_QuickStarterColumnsTypeImage; ImageIndex: 11; OpenType: otImageViewer; Options: []),
   (Ext: '.BMP'; NameID: NR_QuickStarterColumnsTypeImage; ImageIndex: 11; OpenType: otImageViewer; Options: []),
   (Ext: '.PNG'; NameID: NR_QuickStarterColumnsTypeImage; ImageIndex: 11; OpenType: otImageViewer; Options: []),
   (Ext: '.GIF'; NameID: NR_QuickStarterColumnsTypeImage; ImageIndex: 11; OpenType: otImageViewer; Options: []),

   (Ext: '.ICO'; NameID: NR_QuickStarterColumnsTypeIcon; ImageIndex: 11; OpenType: otOpen; Options: []),

   (Ext: '.WAV'; NameID: NR_QuickStarterColumnsTypeSound; ImageIndex: 12; OpenType: otSoundPlayer; Options: []),
   (Ext: '.MP3'; NameID: NR_QuickStarterColumnsTypeSound; ImageIndex: 12; OpenType: otSoundPlayer; Options: []),
   (Ext: '.OGG'; NameID: NR_QuickStarterColumnsTypeSound; ImageIndex: 12; OpenType: otSoundPlayer; Options: []),
   (Ext: '.MID'; NameID: NR_QuickStarterColumnsTypeSound; ImageIndex: 12; OpenType: otSoundPlayer; Options: []),
   (Ext: '.MIDI'; NameID: NR_QuickStarterColumnsTypeSound; ImageIndex: 12; OpenType: otSoundPlayer; Options: []),

   (Ext: '.AVI'; NameID: NR_QuickStarterColumnsTypeVideo; ImageIndex: 19; OpenType: otVideoPlayer; Options: []),
   (Ext: '.MPG'; NameID: NR_QuickStarterColumnsTypeVideo; ImageIndex: 19; OpenType: otVideoPlayer; Options: []),
   (Ext: '.MPEG'; NameID: NR_QuickStarterColumnsTypeVideo; ImageIndex: 19; OpenType: otVideoPlayer; Options: []),
   (Ext: '.WMV'; NameID: NR_QuickStarterColumnsTypeVideo; ImageIndex: 19; OpenType: otVideoPlayer; Options: []),
   (Ext: '.ASF'; NameID: NR_QuickStarterColumnsTypeVideo; ImageIndex: 19; OpenType: otVideoPlayer; Options: []),

   (Ext: '.PDF'; NameID: NR_QuickStarterColumnsTypePDF; ImageIndex: 8; OpenType: otOpen; Options: []),

   (Ext: '.HTM'; NameID: NR_QuickStarterColumnsTypeHTML; ImageIndex: 14; OpenType: otOpen; Options: [ftAddEditItem]),
   (Ext: '.HTML'; NameID: NR_QuickStarterColumnsTypeHTML; ImageIndex: 14; OpenType: otOpen; Options: [ftAddEditItem]),

   (Ext: '.RTF'; NameID: NR_QuickStarterColumnsTypeRTF; ImageIndex: 8; OpenType: otOpen; Options: []),

   (Ext: '.DOC'; NameID: NR_QuickStarterColumnsTypeText; ImageIndex: 8; OpenType: otOpen; Options: []),

   (Ext: '.ZIP'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.7Z'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.RAR'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.ARJ'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.LHA'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.LZH'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.BZ2'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.BZIP2'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.CAB'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.GZ'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.GZIP'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.TAR'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.ZOO'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),
   (Ext: '.ARC'; NameID: NR_QuickStarterColumnsTypeArchive; ImageIndex: 13; OpenType: otOpen; Options: []),

   (Ext: '.IMG'; NameID: NR_QuickStarterColumnsTypeHDImage; ImageIndex: 7; OpenType: otOpen; Options: []),
   (Ext: '.IMA'; NameID: NR_QuickStarterColumnsTypeHDImage; ImageIndex: 7; OpenType: otOpen; Options: []),

   (Ext: '.ISO'; NameID: NR_QuickStarterColumnsTypeCDImage; ImageIndex: 15; OpenType: otOpen; Options: []),
   (Ext: '.BIN'; NameID: NR_QuickStarterColumnsTypeCDImage; ImageIndex: 15; OpenType: otOpen; Options: []),
   (Ext: '.CUE'; NameID: NR_QuickStarterColumnsTypeCDImage; ImageIndex: 15; OpenType: otOpen; Options: []),

   (Ext: '.DLL'; NameID: NR_QuickStarterColumnsTypeDLL; ImageIndex: 8; OpenType: otNone; Options: []),

   (Ext: '.SYS'; NameID: NR_QuickStarterColumnsTypeDOSDriver; ImageIndex: 9; OpenType: otNone; Options: []),
   (Ext: '.DRV'; NameID: NR_QuickStarterColumnsTypeDOSDriver; ImageIndex: 9; OpenType: otNone; Options: []),

   (Ext: ''{no extension}; NameID: 0; ImageIndex: 8; OpenType: otEditor; Options: []),

   (Ext: ''{unknown extension}; NameID: 0; ImageIndex: 8; OpenType: otOpen; Options: [ftAddEditItem]) {must be last element in array}
  );

{ TQuickStartForm }

procedure TQuickStartForm.FormCreate(Sender: TObject);
begin
  Working:=True;
  CurrentPath:='';
  PopupSelNode:=nil;
  TreeBaseDir:='';
  DisableCounter:=0;

  HelpContext:=ID_ViewQuickStarter;

  hChangeNotification:=INVALID_HANDLE_VALUE;

  Timer:=TTimer.Create(self);
  with Timer do begin
    Enabled:=False;
    Interval:=500;
    OnTimer:=TimerWork;
  end;

  SetVistaFonts(self);

  NoFlicker(CoolBar);
  NoFlicker(ToolBar);
  {NoFlicker(TreeTypeComboBox);}
  NoFlicker(Tree);
  NoFlicker(List);
  NoFlicker(TemplateComboBox);
  NoFlicker(SetupComboBox1);
  NoFlicker(SetupComboBox2);

  If PrgSetup.QuickStarterMaximized then begin
    WindowState:=wsMaximized;
  end else begin
    If (PrgSetup.QuickStarterLeft>0) and (PrgSetup.QuickStarterLeft<9*Screen.Width div 10) then Left:=PrgSetup.QuickStarterLeft;
    If (PrgSetup.QuickStarterTop>0) and (PrgSetup.QuickStarterTop<9*Screen.Height div 10) then Top:=PrgSetup.QuickStarterTop;
    If (PrgSetup.QuickStarterWidth>0) and (Left+PrgSetup.QuickStarterWidth<=Screen.Width) then Width:=PrgSetup.QuickStarterWidth;
    If (PrgSetup.QuickStarterHeight>0) and (Top+PrgSetup.QuickStarterHeight<=Screen.Height) then Height:=PrgSetup.QuickStarterHeight;

    if (PrgSetup.QuickStarterLeft<0) and (PrgSetup.QuickStarterTop<0) and (PrgSetup.QuickStarterWidth<0) and (PrgSetup.QuickStarterHeight<0) then begin
      Left:=DFendReloadedMainForm.Left+DFendReloadedMainForm.Width div 2-(Width div 2);
      Top:=DFendReloadedMainForm.Top+DFendReloadedMainForm.Top div 2-(Top div 2);
    end;

    Position:=poDesigned;
  end;

  GlassFrame.Enabled:=True;
  GlassFrame.Bottom:=BottomPanel.Height;
end;

procedure TQuickStartForm.FormShow(Sender: TObject);
Var C : TListColumn;
    I : Integer;
begin
  Tree:=TTreeView(NewWinControlType(Tree,TTreeViewAcceptingFiles,ctcmDangerousMagic));
  TTreeViewAcceptingFiles(Tree).ActivateAcceptFiles;

  List:=TListView(NewWinControlType(List,TListViewAcceptingFiles,ctcmDangerousMagic));
  TListViewAcceptingFiles(List).ActivateAcceptFiles;

  C:=List.Columns.Add; C.Caption:='Name'; C.Width:=-1;
  C:=List.Columns.Add; C.Caption:='Size'; C.Width:=-1;
  C:=List.Columns.Add; C.Caption:='Type'; C.Width:=-1;

  LoadLanguage;

  UserIconLoader.RegisterImageList(ImageList,'QuickStart');

  LoadTemplateList;
  BuildTree;

  SetupComboBox1.ItemIndex:=IfThen(PrgSetup.QuickStarterDOSBoxFullscreen,0,1);
  SetupComboBox2.ItemIndex:=IfThen(PrgSetup.QuickStarterDOSBoxAutoClose,0,1);
  I:=TemplateComboBox.Items.IndexOf(PrgSetup.QuickStarterDOSBoxTemplate);
  If I>=0 then TemplateComboBox.ItemIndex:=I;
end;

procedure TQuickStartForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Assigned(FOnMenuCloseNotify) then FOnMenuCloseNotify(self);

  If Action=caHide then Action:=caFree;
end;

procedure TQuickStartForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=(DisableCounter=0);
end;

procedure TQuickStartForm.FormDestroy(Sender: TObject);
begin
  UserIconLoader.UnRegisterImageList(ImageList);

  PrgSetup.QuickStarterMaximized:=(WindowState=wsMaximized);
  PrgSetup.QuickStarterLeft:=Left;
  PrgSetup.QuickStarterTop:=Top;
  PrgSetup.QuickStarterWidth:=Width;
  PrgSetup.QuickStarterHeight:=Height;

  PrgSetup.QuickStarterDOSBoxFullscreen:=(SetupComboBox1.ItemIndex=0);
  PrgSetup.QuickStarterDOSBoxAutoClose:=(SetupComboBox2.ItemIndex=0);
  If TemplateComboBox.ItemIndex=0 then PrgSetup.QuickStarterDOSBoxTemplate:='' else PrgSetup.QuickStarterDOSBoxTemplate:=TemplateComboBox.Items[TemplateComboBox.ItemIndex];

  If hChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hChangeNotification);
  QuickStartForm:=nil;
end;

procedure TQuickStartForm.ListPopupMenuPopup(Sender: TObject);
begin
  ListSelectItem(Sender,List.Selected,True);
end;

procedure TQuickStartForm.ListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var S : String;
begin
  LoadStartButtonLanguage(Item);

  ListRunWithParameters.Visible:=(Item<>nil) and (ftRunWithParameters in FileTypes[Integer(Item.Data)].Options);

  If (Item<>nil) and (FileTypes[Integer(Item.Data)].OpenType in [otImageViewer, otSoundPlayer, otVideoPlayer]) then begin
    Case FileTypes[Integer(Item.Data)].OpenType of
      otImageViewer : S:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
      otSoundPlayer : S:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
      otVideoPlayer : S:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
      else S:='';
    end;
    ListOpenInDefaultViewer.Visible:=(S='') or (S='INTERNAL');
  end else begin
    ListOpenInDefaultViewer.Visible:=False;
  end;

  ListOpenInEditor.Visible:=(Item<>nil) and (ftAddEditItem in FileTypes[Integer(Item.Data)].Options);

  ListRename.Visible:=(Item<>nil);
  ListDelete.Visible:=(Item<>nil);

  ListMakeProfile.Visible:=(Item<>nil) and (ftCanMakeProfileOf in FileTypes[Integer(Item.Data)].Options);
  ListMakeProfileWizard.Visible:=(Item<>nil) and (ftCanMakeProfileOf in FileTypes[Integer(Item.Data)].Options);
end;

Procedure TQuickStartForm.LoadStartButtonLanguage(Item : TListItem);
begin
  If Item=nil then Item:=List.Selected;

  StartButton.Enabled:=(Item<>nil) and (FileTypes[Integer(Item.Data)].OpenType<>otNone);

  If StartButton.Enabled then begin
    StartButton.ImageIndex:=FileTypes[Integer(Item.Data)].ImageIndex;
    ListRun.ImageIndex:=FileTypes[Integer(Item.Data)].ImageIndex;
    If (FileTypes[Integer(Item.Data)].OpenType=otDOSBox) or ((FileTypes[Integer(Item.Data)].OpenType=otOpen) and (ftWindowsExe in FileTypes[Integer(Item.Data)].Options)) then begin
      StartButton.Caption:=LanguageSetup.ButtonRun;
      ListRun.Caption:=LanguageSetup.ButtonRun;
    end else begin
      StartButton.Caption:=LanguageSetup.ButtonOpen;
      ListRun.Caption:=LanguageSetup.ButtonOpen;
    end;
  end else begin
    StartButton.ImageIndex:=2;
    ListRun.ImageIndex:=2;
    ListRun.Caption:=LanguageSetup.ButtonRun;
    StartButton.Caption:=LanguageSetup.ButtonRun;
  end;
  ListRun.Visible:=StartButton.Enabled;
end;

procedure TQuickStartForm.LoadLanguage;
Var I : Integer;
begin
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.QuickStarterCaption;

  CloseButton.Caption:=LanguageSetup.Close;
  CloseButton.Hint:=LanguageSetup.CloseHintWindow;
  UpdateButton.Caption:=LanguageSetup.QuickStarterUpdate;
  UpdateButton.Hint:=LanguageSetup.QuickStarterUpdateInfo;
  StartButton.Caption:=LanguageSetup.ButtonRun;
  StartButton.Hint:=LanguageSetup.ButtonRunHintFile;
  HelpButton.Caption:=LanguageSetup.Help;
  HelpButton.Hint:=LanguageSetup.HelpHint;

  While SetupComboBox1.Items.Count<2 do SetupComboBox1.Items.Add('');
  While SetupComboBox2.Items.Count<2 do SetupComboBox2.Items.Add('');
  I:=SetupComboBox1.ItemIndex;
  SetupComboBox1.Items[0]:=LanguageSetup.QuickStarterSetupFullscreen;
  SetupComboBox1.Items[1]:=LanguageSetup.QuickStarterSetupWindow;
  SetupComboBox1.ItemIndex:=Max(0,I);
  I:=SetupComboBox2.ItemIndex;
  SetupComboBox2.Items[0]:=LanguageSetup.QuickStarterSetupAutoClose;
  SetupComboBox2.Items[1]:=LanguageSetup.QuickStarterSetupNoAutoClose;
  SetupComboBox2.ItemIndex:=Max(0,I);

  I:=TreeTypeComboBox.ItemIndex;
  TreeTypeComboBox.OnChange:=nil;
  While TreeTypeComboBox.Items.Count<4 do TreeTypeComboBox.Items.Add('');
  TreeTypeComboBox.Items[0]:=LanguageSetup.QuickStarterTypeGamesDir;
  TreeTypeComboBox.Items[1]:=LanguageSetup.QuickStarterTypeCaptureDir;
  TreeTypeComboBox.Items[2]:=LanguageSetup.QuickStarterTypeDataDir;
  TreeTypeComboBox.Items[3]:=LanguageSetup.QuickStarterTypeFull;
  TreeTypeComboBox.ItemIndex:=Max(0,I);
  TreeTypeComboBox.OnChange:=TreeTypeComboBoxChange;

  List.Column[0].Caption:=LanguageSetup.QuickStarterColumnsName;
  List.Column[1].Caption:=LanguageSetup.QuickStarterColumnsSize;
  List.Column[2].Caption:=LanguageSetup.QuickStarterColumnsType;

  I:=TemplateComboBox.ItemIndex;
  If TemplateComboBox.Items.Count>0 then TemplateComboBox.Items[0]:=LanguageSetup.TemplateFormDefault;
  TemplateComboBox.ItemIndex:=I;

  TreeUpdate.Caption:=LanguageSetup.QuickStarterUpdate;
  TreeViewMode.Caption:=LanguageSetup.QuickStarterMenuViewMode;
  TreeViewModeGames.Caption:=LanguageSetup.QuickStarterMenuViewModeGames;
  TreeViewModeCapture.Caption:=LanguageSetup.QuickStarterMenuViewModeCapture;
  TreeViewModeData.Caption:=LanguageSetup.QuickStarterMenuViewModeData;
  TreeViewModeFull.Caption:=LanguageSetup.QuickStarterMenuViewModeFull;
  TreeExplorer.Caption:=LanguageSetup.QuickStarterMenuExplorer;
  TreeDOSBox.Caption:=LanguageSetup.QuickStarterMenuDOSBox;
  TreeCreateFolder.Caption:=LanguageSetup.QuickStarterMenuCreateFolder;
  TreeRename.Caption:=LanguageSetup.QuickStarterMenuRename;
  TreeDelete.Caption:=LanguageSetup.QuickStarterMenuDelete;
  ListRun.Caption:=LanguageSetup.ButtonRun;
  ListRunWithParameters.Caption:=LanguageSetup.QuickStarterMenuRunWithParameters;
  ListOpenInDefaultViewer.Caption:=LanguageSetup.QuickStarterMenuOpenInDefaultViewer;
  ListOpenInEditor.Caption:=LanguageSetup.QuickStarterMenuOpenInTextEditor;
  ListCreateFolder.Caption:=LanguageSetup.QuickStarterMenuCreateFolder;
  ListRename.Caption:=LanguageSetup.QuickStarterMenuRename;
  ListDelete.Caption:=LanguageSetup.QuickStarterMenuDelete;
  ListMakeProfile.Caption:=LanguageSetup.QuickStarterMenuMakeProfile;
  ListMakeProfileWizard.Caption:=LanguageSetup.QuickStarterMenuMakeProfileWizard;
  ListUpdate.Caption:=LanguageSetup.QuickStarterUpdate;
  ListExplorer.Caption:=LanguageSetup.QuickStarterMenuExplorer;
  ListDOSBox.Caption:=LanguageSetup.QuickStarterMenuDOSBox;

  ListRun.ShortCut:=ShortCut(VK_RETURN,[]);
  ListRunWithParameters.ShortCut:=ShortCut(VK_RETURN,[ssShift]);
  ListOpenInEditor.ShortCut:=ShortCut(VK_RETURN,[ssCtrl]);

  TemplateComboBox.Invalidate;
  SetupComboBox1.Invalidate;
  SetupComboBox2.Invalidate;

  LoadStartButtonLanguage(nil);

  CoolBar.Font.Size:=PrgSetup.ToolbarFontSize;

  BuildList;
end;

procedure TQuickStartForm.LoadTemplateList;
Var SaveTemplateName : String;
    I : Integer;
    TemplateDB : TGameDB;
begin
  SaveTemplateName:=TemplateComboBox.Text;

  TemplateComboBox.Items.BeginUpdate;
  try
    TemplateComboBox.Items.Clear;

    TemplateComboBox.Items.Add(LanguageSetup.TemplateFormDefault);
    TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
    try
      For I:=0 to TemplateDB.Count-1 do TemplateComboBox.Items.Add(TemplateDB[I].CacheName);
    finally
      TemplateDB.Free;
    end;
  finally
    TemplateComboBox.Items.EndUpdate;
  end;

  TemplateComboBox.ItemIndex:=Max(0,TemplateComboBox.Items.IndexOf(SaveTemplateName));
end;

procedure TQuickStartForm.BuildTree;
Var N,SelNode,BackupSelNode : TTreeNode;
    S, SaveCurrentPath : String;
    I1,I2,I3 : Cardinal;
    C : Char;
begin
  GameDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
  CaptureDir:=MakeAbsPath(PrgSetup.CaptureDir,PrgDataDir);
  DataDir:=MakeAbsPath(PrgSetup.DataDir,PrgSetup.BaseDir);

  BackupSelNode:=nil;

  DisableGUI;
  Tree.Items.BeginUpdate;
  try
    SaveCurrentPath:=CurrentPath;
    SelNode:=nil;

    Tree.Items.Clear;
    Tree.SortType:=stNone;

    Case TreeTypeComboBox.ItemIndex of
      0 : begin
            TreeBaseDir:=GameDir;
            N:=Tree.Items.AddChild(nil,LanguageSetup.QuickStarterTypeGamesDir);
            N.ImageIndex:=6; N.SelectedIndex:=6;
            BackupSelNode:=N;
            If Copy(SaveCurrentPath,1,length(GameDir))=GameDir then begin
              S:=Copy(SaveCurrentPath,length(GameDir)+1,MaxInt);
              If (S<>'') and (S[1]<>'\') then S:='\'+S;
            end else S:='';
            SelNode:=AddSubfolders(GameDir,N,S,False);
          end;
      1 : begin
            TreeBaseDir:=CaptureDir;
            N:=Tree.Items.AddChild(nil,LanguageSetup.QuickStarterTypeCaptureDir);
            N.ImageIndex:=6; N.SelectedIndex:=6;
            BackupSelNode:=N;
            If Copy(SaveCurrentPath,1,length(CaptureDir))=CaptureDir then begin
              S:=Copy(SaveCurrentPath,length(CaptureDir)+1,MaxInt);
              If (S<>'') and (S[1]<>'\') then S:='\'+S;
            end else S:='';
            SelNode:=AddSubfolders(CaptureDir,N,S,False);
          end;
      2 : begin
            TreeBaseDir:=DataDir;
            N:=Tree.Items.AddChild(nil,LanguageSetup.QuickStarterTypeDataDir);
            N.ImageIndex:=6; N.SelectedIndex:=6;
            BackupSelNode:=N;
            If Copy(SaveCurrentPath,1,length(DataDir))=DataDir then begin
              S:=Copy(SaveCurrentPath,length(DataDir)+1,MaxInt);
              If (S<>'') and (S[1]<>'\') then S:='\'+S;
            end else S:='';
            SelNode:=AddSubfolders(DataDir,N,S,False);
          end;
      3 : begin
            TreeBaseDir:='';
            BackupSelNode:=nil;
            For C:='A' to 'Z' do begin
              If GetDriveType(PChar(C+':\'))=DRIVE_NO_ROOT_DIR then continue;
              SetLength(S,512); if not GetVolumeInformation(PChar(C+':\'),PChar(S),500,@I1,I2,I3,nil,0) then continue;
              If not DirectoryExists(C+':\') then continue;

              N:=Tree.Items.AddChild(nil,C+':');
              N.ImageIndex:=7; N.SelectedIndex:=7;
              If C='C' then BackupSelNode:=N;
              If Copy(SaveCurrentPath,1,3)=C+':\' then begin
                S:=Copy(SaveCurrentPath,4,MaxInt);
                If (S<>'') and (S[1]<>'\') then S:='\'+S;
              end else S:='';
              N:=AddSubfolders(C+':\',N,S,False);
              If N<>nil then SelNode:=N;
            end;
            If BackupSelNode=nil then BackupSelNode:=Tree.Items[0];
          end;
    end;
  finally
    Tree.Items.EndUpdate;
    EnableGUI;
  end;

  Tree.SortType:=stText;
  If SelNode<>nil then Tree.Selected:=SelNode else Tree.Selected:=BackupSelNode;
  If Tree.Selected<>nil then Tree.Selected.MakeVisible;

  BuildList;
end;

Function TQuickStartForm.AddSubfolders(Folder: String; const ParentNode: TTreeNode; ExpandPath : String; const UpdateSort : Boolean) : TTreeNode;
Var Rec,Rec2 : TSearchRec;
    I,J : Integer;
    N : TTreeNode;
    FirstPathPart : String;
begin
  result:=nil;
  If UpdateSort then Tree.SortType:=stNone;

  Folder:=IncludeTrailingPathDelimiter(Folder);

  FirstPathPart:='';
  If (ExpandPath<>'') and (ExpandPath[1]='\') then ExpandPath:=Copy(ExpandPath,2,MaxInt);
  If ExpandPath<>'' then begin
    I:=Pos('\',ExpandPath);
    If I=0 then begin
      FirstPathPart:=ExcludeTrailingPathDelimiter(ExpandPath); ExpandPath:='';
    end else begin
      FirstPathPart:=Copy(ExpandPath,1,I-1); ExpandPath:=Copy(ExpandPath,I,MaxInt);
    end;
  end;

  I:=FindFirst(Folder+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        N:=Tree.Items.AddChildFirst(ParentNode,Rec.Name);
        N.ImageIndex:=4; N.SelectedIndex:=5;

        Application.ProcessMessages;

        If Rec.Name=FirstPathPart then begin
          {Add subdirs}
          result:=AddSubfolders(Folder+Rec.Name+'\',N,ExpandPath,False);
          If (result=nil) and ((ExpandPath='') or (ExpandPath='\')) then result:=N;
        end else begin
          {Check if expandable}
          J:=FindFirst(Folder+Rec.Name+'\*.*',faDirectory,Rec2);
          try
            While J=0 do begin
              If ((Rec2.Attr and faDirectory)<>0) and (Rec2.Name<>'.') and (Rec2.Name<>'..') then begin N.HasChildren:=True; break; end;
              J:=FindNext(Rec2);
            end;
          finally
            FindClose(Rec2);
          end;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  ParentNode.Expand(False);
  If UpdateSort then Tree.SortType:=stText;
end;

procedure TQuickStartForm.BuildList;
Var Rec : TSearchRec;
    I,J : Integer;
    N,NewSel : TListItem;
    S,T,SaveSel : String;
begin
  Timer.Enabled:=False;
  If hChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hChangeNotification);
  hChangeNotification:=INVALID_HANDLE_VALUE;

  DisableGUI;
  List.Items.BeginUpdate;
  try
    If List.Selected=nil then SaveSel:='' else SaveSel:=List.Selected.Caption;
    NewSel:=nil;

    For I:=0 to List.Columns.Count-1 do List.Column[I].Width:=1;
    List.SortType:=stNone;
    List.Items.Clear;

    If CurrentPath='' then exit;

    I:=FindFirst(CurrentPath+'*.*',faAnyFile,Rec);
    try
      While I=0 do begin
        Application.ProcessMessages;
        
        If (Rec.Attr and faDirectory)=0 then begin
          N:=List.Items.Add;
          N.Caption:=Rec.Name;
          If Rec.Name=SaveSel then NewSel:=N;
          S:=ExtUpperCase(ExtractFileExt(Rec.Name));
          N.SubItems.Add(FileSizeToStr(Rec.Size));

          N.ImageIndex:=8;
          T:='';
          N.Data:=Pointer(High(FileTypes));

          For J:=0 to High(FileTypes) do If S=FileTypes[J].Ext then begin
            If (ftDOSExe in FileTypes[J].Options) and IsWindowsExe(CurrentPath+Rec.Name) then continue;
            If (ftWindowsExe in FileTypes[J].Options) and (not IsWindowsExe(CurrentPath+Rec.Name)) then continue;

            If FileTypes[J].NameID>0 then T:=LanguageSetup.GetString(FileTypes[J].NameID);
            N.ImageIndex:=FileTypes[J].ImageIndex;
            N.Data:=Pointer(J);
            break;
          end;
          N.SubItems.Add(T);
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    For I:=0 to List.Columns.Count-1 do List.Column[I].Width:=-1;
    List.SortType:=stText;

    List.Selected:=NewSel;
  finally
    List.Items.EndUpdate;
    EnableGUI;
  end;

  If TreeBaseDir='' then begin
    hChangeNotification:=FindFirstChangeNotification(
      PChar(CurrentPath),
      True,
      FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
    );
  end else begin
    hChangeNotification:=FindFirstChangeNotification(
      PChar(TreeBaseDir),
      True,
      FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
    );
  end;
  Timer.Enabled:=True;
end;

procedure TQuickStartForm.TreeTypeComboBoxChange(Sender: TObject);
begin
  Case TreeTypeComboBox.ItemIndex of
    0 : TreeViewModeGames.Checked:=True;
    1 : TreeViewModeCapture.Checked:=True;
    2 : TreeViewModeData.Checked:=True;
    3 : TreeViewModeFull.Checked:=True;
  end;

  BuildTree;
end;

function TQuickStartForm.PathFromNode(const Node: TTreeNode): String;
Var N : TTreeNode;
begin
  result:='';
  If Node=nil then exit;
  result:='\';
  N:=Node;
  while N.Parent<>nil do begin result:='\'+N.Text+result; N:=N.Parent; end;
  If (length(N.Text)>=2) and (N.Text[2]=':') then begin result:=N.Text+result end else begin
    Case TreeTypeComboBox.ItemIndex of
      0 : result:=ExcludeTrailingPathDelimiter(GameDir)+result;
      1 : result:=ExcludeTrailingPathDelimiter(CaptureDir)+result;
      2 : result:=ExcludeTrailingPathDelimiter(DataDir)+result;
    end;
  end;
end;

procedure TQuickStartForm.TimerWork(Sender: TObject);
begin
  If (hChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hChangeNotification,0)=WAIT_OBJECT_0) then begin
    If TreeBaseDir<>'' then BuildTree else BuildList;
    FindNextChangeNotification(hChangeNotification);
  end;
end;

procedure TQuickStartForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  CurrentPath:=PathFromNode(Node);
  Caption:=LanguageSetup.QuickStarterCaption+' ['+ExcludeTrailingPathDelimiter(CurrentPath)+']';
  BuildList;

  TreeRename.Visible:=(Node<>nil) and (Node.Parent<>nil);
  TreeDelete.Visible:=(Node<>nil) and (Node.Parent<>nil);
end;

procedure TQuickStartForm.TreeExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  If Node.HasChildren and (Node.Count=0) then
    AddSubfolders(PathFromNode(Node),Node,'',True);
end;

procedure TQuickStartForm.TreePopupMenuPopup(Sender: TObject);
begin
  CurrentPath:=PathFromNode(Tree.Selected);
  TreeRename.Visible:=(Tree.Selected<>nil) and (Tree.Selected.Parent<>nil);
  TreeDelete.Visible:=(Tree.Selected<>nil) and (Tree.Selected.Parent<>nil);
  PopupSelNode:=Tree.Selected;
end;

procedure TQuickStartForm.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : BuildTree;
    2 : MenuWork(ListRun);
    3 : Application.HelpCommand(HELP_CONTEXT,ID_ViewQuickStarter);
  end;
end;

procedure TQuickStartForm.MenuWork(Sender: TObject);
Var S,T : String;
begin
  If PopupSelNode<>nil then Tree.Selected:=PopupSelNode;
  PopupSelNode:=nil;

  Case (Sender as TComponent).Tag of
    10 : BuildTree;
    11 : begin TreeTypeComboBox.ItemIndex:=0; TreeTypeComboBoxChange(Sender); end;
    12 : begin TreeTypeComboBox.ItemIndex:=1; TreeTypeComboBoxChange(Sender); end;
    13 : begin TreeTypeComboBox.ItemIndex:=2; TreeTypeComboBoxChange(Sender); end;
    14 : begin TreeTypeComboBox.ItemIndex:=3; TreeTypeComboBoxChange(Sender); end;
    15 : begin ShellExecute(Handle,'explore',PChar(CurrentPath),nil,PChar(CurrentPath),SW_SHOW); TreeChange(Sender,Tree.Selected); end;
    16 : begin OpenFolderInDOSBox; TreeChange(Sender,Tree.Selected);  end;
    17 : If (Tree.Selected<>nil) and (Tree.Selected.Parent<>nil) then begin
           S:=Tree.Selected.Text;
           If not InputQuery(LanguageSetup.QuickStarterMenuRenameCaptionFolder,LanguageSetup.QuickStarterMenuRenameLabel,S) then exit;
           If not RenameFile(PathFromNode(Tree.Selected.Parent)+Tree.Selected.Text,PathFromNode(Tree.Selected.Parent)+S) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[PathFromNode(Tree.Selected.Parent)+List.Selected.Caption,PathFromNode(Tree.Selected.Parent)+S]),mtError,[mbOK],0);
             exit;
           end;
           Tree.Selected.Text:=S;
           BuildTree;
         end;
    18 : If (Tree.Selected<>nil) and (Tree.Selected.Parent<>nil) then begin
           If MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteFolder,[PathFromNode(Tree.Selected)]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
           If not ExtDeleteFolder(PathFromNode(Tree.Selected),ftQuickStart) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[PathFromNode(Tree.Selected)]),mtError,[mbOK],0);
             exit;
           end;
           Tree.Selected:=Tree.Selected.Parent;
           BuildTree;
         end;
    19 : begin
           S:=LanguageSetup.QuickStarterMenuCreateFolderDefaultName;
           If not InputQuery(LanguageSetup.QuickStarterMenuCreateFolderCaption,LanguageSetup.QuickStarterMenuCreateFolderLabel,S) then exit;
           T:=IncludeTrailingPathDelimiter(CurrentPath)+S;
           If DirectoryExists(T) then begin
             MessageDlg(Format(LanguageSetup.MessageDirectoryAlreadyExists,[T]),mtError,[mbOK],0);
             exit;
           end;
           If not ForceDirectories(T) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[T]),mtError,[mbOK],0);
             exit;
           end;
           ButtonWork(UpdateButton);
         end;
    21 : If List.Selected<>nil then RunFile(CurrentPath+List.Selected.Caption,Integer(List.Selected.Data),False);
    22 : If List.Selected<>nil then AddProfile(CurrentPath+List.Selected.Caption,ftWindowsExe in FileTypes[Integer(List.Selected.Data)].Options,False);
    23 : If List.Selected<>nil then AddProfile(CurrentPath+List.Selected.Caption,ftWindowsExe in FileTypes[Integer(List.Selected.Data)].Options,True);
    24 : If (List.Selected<>nil) and (ftAddEditItem in FileTypes[Integer(List.Selected.Data)].Options) then OpenFileInEditor(CurrentPath+List.Selected.Caption);
    25 : If List.Selected<>nil then begin
           S:=List.Selected.Caption;
           If not InputQuery(LanguageSetup.QuickStarterMenuRenameCaptionFile,LanguageSetup.QuickStarterMenuRenameLabel,S) then exit;
           If not RenameFile(CurrentPath+List.Selected.Caption,CurrentPath+S) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[CurrentPath+List.Selected.Caption,CurrentPath+S]),mtError,[mbOK],0);
             exit;
           end;
           List.Selected.Caption:=S;
           BuildList;
         end;
    26 : If List.Selected<>nil then begin
           If MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteFile,[CurrentPath+List.Selected.Caption]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
           If not ExtDeleteFile(CurrentPath+List.Selected.Caption,ftQuickStart) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[CurrentPath+List.Selected.Caption]),mtError,[mbOK],0);
             exit;
           end;
           BuildList;
         end;
    27 : If List.Selected<>nil then RunFile(CurrentPath+List.Selected.Caption,Integer(List.Selected.Data),True);
    28 : If List.Selected<>nil then begin
           S:=CurrentPath+List.Selected.Caption;
           Case FileTypes[Integer(List.Selected.Data)].OpenType of
           otImageViewer : begin
                             T:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
                             If (T<>'') and (T<>'INTERNAL') then begin
                               If PrgSetup.NonModalViewer
                                 then ShowNonModalImageDialog(self,S,nil,nil)
                                 else ShowImageDialog(self,S,nil,nil);
                               exit;
                             end;
                           end;
           otSoundPlayer : begin
                             T:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
                             If (T<>'') and (T<>'INTERNAL') then begin PlaySoundDialog(self,S,nil,nil); exit; end;
                           end;
           otVideoPlayer : begin
                             T:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
                             If (T<>'') and (T<>'INTERNAL') then begin PlayVideoDialog(self,S,nil,nil); exit; end;
                           end;
           end;
           ShellExecute(Handle,'open',PChar('"'+S+'"'),nil,nil,SW_SHOW);
         end;
  end;
end;

procedure TQuickStartForm.ListDblClick(Sender: TObject);
begin
  MenuWork(ListRun);
end;

procedure TQuickStartForm.ListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key=VK_RETURN then begin
    If Shift=[] then MenuWork(ListRun);
    If Shift=[ssShift] then MenuWork(ListRunWithParameters);
    If Shift=[ssCtrl] then MenuWork(ListOpenInEditor);
  end;
end;

procedure TQuickStartForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift=[] then Case Key of
    VK_F1 : ButtonWork(HelpButton);
    VK_F5 : ButtonWork(UpdateButton);
    VK_F2 : If Tree.Focused then MenuWork(TreeRename) else MenuWork(ListRename);
    VK_DELETE : If Tree.Focused then MenuWork(TreeDelete) else MenuWork(ListDelete);
  end;
end;

procedure TQuickStartForm.OpenFolderInDOSBox;
begin
  OpenDOSBox(IncludeTrailingPathDelimiter(CurrentPath),'','');
end;

procedure TQuickStartForm.GetFilesInFolder(const Extensions: array of String; const FileName: String; var St1, St2: TStringList);
Var Path,FileNameOnly : String;
    Rec : TSearchRec;
    I,J : Integer;
    St : TStringList;
    S : String;
begin
  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
  FileNameOnly:=ExtUpperCase(ExtractFileName(FileName));

  St1:=TStringList.Create;
  St2:=TStringList.Create;

  St:=TStringList.Create;
  try
    {Search files}
    I:=FindFirst(Path+'*.*',faAnyFile,Rec);
    try
      While I=0 do begin
        If (Rec.Attr and faDirectory)=0 then begin
          S:=ExtUpperCase(ExtractFileExt(Rec.Name));
          For J:=Low(Extensions) to High(Extensions) do If Extensions[J]=S then begin St.Add(Rec.Name); break; end;
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    {Build lists}
    St.Sort;
    J:=St.IndexOf(ExtractFileName(FileName));
    For I:=0 to St.Count-1 do begin
      If I=J then continue;
      If I<J then St1.Add(Path+St[I]);
      If I>J then St2.Add(Path+St[I]);
    end;
  finally
    St.Free;
  end;
end;

procedure TQuickStartForm.RunFile(const FileName: String; const TypeNr : Integer; const WithParameters : Boolean);
Var Ext,Param : String;
    St1,St2 : TStringList;
begin
  Ext:=Trim(ExtUpperCase(ExtractFileExt(FileName)));

  Case FileTypes[TypeNr].OpenType of
    otNone        : {do not try to run file};
    otOpen        : begin
                      Param:='';
                      If WithParameters then begin
                        If not InputQuery(LanguageSetup.QuickStarterMenuRunWithParametersCaption,LanguageSetup.QuickStarterMenuRunWithParametersLabel,Param) then exit;
                        Param:=Trim(Param);
                      end;
                      If Param=''
                        then ShellExecute(Handle,'open',PChar(FileName),nil,PChar(ExtractFilePath(FileName)),SW_SHOW)
                        else ShellExecute(Handle,'open',PChar(FileName),PChar(Param),PChar(ExtractFilePath(FileName)),SW_SHOW);
                    end;
    otDOSBox      : begin
                      Param:='';
                      If WithParameters then begin
                        If not InputQuery(LanguageSetup.QuickStarterMenuRunWithParametersCaption,LanguageSetup.QuickStarterMenuRunWithParametersLabel,Param) then exit;
                        Param:=Trim(Param);
                      end;
                      OpenDOSBox(IncludeTrailingPathDelimiter(ExtractFilePath(FileName)),FileName,Param);
                    end;
    otImageViewer : begin
                      GetFilesInFolder(['.BMP','.JPG','.JPEG','.PNG','.GIF'],FileName,St1,St2);
                      try
                        If PrgSetup.NonModalViewer
                          then ShowNonModalImageDialog(self,FileName,St1,St2)
                          else ShowImageDialog(self,FileName,St1,St2);
                      finally
                        St1.Free; St2.Free;
                      end;
                    end;
    otSoundPlayer : begin
                      GetFilesInFolder(['.WAV','.MP3','.OGG'],FileName,St1,St2);
                      try
                        PlaySoundDialog(self,FileName,St1,St2);
                      finally
                        St1.Free; St2.Free;
                      end;
                    end;
    otVideoPlayer : begin
                      GetFilesInFolder(['.AVI','.MPG','.MPEG','.WMV','.ASF'],FileName,St1,St2);
                      try
                        PlayVideoDialog(self,FileName,St1,St2);
                      finally
                        St1.Free; St2.Free;
                      end;
                    end;
    otEditor      : OpenFileInEditor(FileName);
  end;
end;

procedure TQuickStartForm.OpenDOSBox(const Path, FileName, Parameters: String);
Var TempGame : TTempGame;
    DefaultTemplate : TGame;
    TemplateDB : TGameDB;
begin
  if TemplateComboBox.ItemIndex<0 then exit;

  TempGame:=TTempGame.Create;
  try
    If TemplateComboBox.ItemIndex=0 then begin
      {Default template}
      DefaultTemplate:=TGame.Create(PrgSetup);
      try
        TempGame.Game.AssignFrom(DefaultTemplate);
      finally
        DefaultTemplate.Free;
      end;
    end else begin
      {Template from DB}
      TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
      try
        TempGame.Game.AssignFrom(TemplateDB[TemplateComboBox.ItemIndex+1]);
      finally
        TemplateDB.Free;
      end;
    end;

    TempGame.Game.StartFullscreen:=(SetupComboBox1.ItemIndex=0);
    TempGame.Game.CloseDosBoxAfterGameExit:=(SetupComboBox2.ItemIndex=0);
    If Trim(Parameters)<>'' then TempGame.Game.GameParameters:=Trim(Parameters);

    CheckPathAvialableInProfile(TempGame.Game,Path);

    If FileName='' then begin
      TempGame.Game.CloseDosBoxAfterGameExit:=False;
      AddAutoexecCDCommands(TempGame.Game,Path);
    end;

    TempGame.Game.GameExe:=FileName;

    RunGame(TempGame.Game,DFendReloadedMainForm.DeleteOnExit);
  finally
    Sleep(100);
    TempGame.Free;
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

procedure TQuickStartForm.CheckPathAvialableInProfile(const Game: TGame; const Path: String);
Var I,J : Integer;
    St : TStringList;
    S,T,Letters : String;
begin
  Letters:='CDEFGHIJKLMNOPQRSTUVWXYZ';

  T:=MakePathShort(Trim(ExtractFilePath(MakeAbsPath(Path,PrgSetup.BaseDir))));

  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count=3 then St.Add('false');
      If St.Count=4 then St.Add('');
      If St.Count<5 then continue;

      If (Trim(ExtUpperCase(St[1]))<>'DRIVE') and (Trim(ExtUpperCase(St[1]))<>'CDROM') and (Trim(ExtUpperCase(St[1]))<>'FLOPPY') then continue;
      S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));
      If Copy(T,1,length(S))=S then begin
        {everything ok}
        exit;
      end;

      J:=Pos(St[2],Letters);
      If J>0 then Letters[J]:='-';
    finally
      St.Free;
    end;
  end;

  {RealFolder;DRIVE;Letter;False;;FreeSpace}

  For J:=1 to length(Letters) do If Letters[J]<>'-' then begin
    S:=Path+';DRIVE;'+Letters[J]+';False;;';
    Game.Mount[Game.NrOfMounts]:=S;
    Game.NrOfMounts:=Game.NrOfMounts+1;
    exit;
  end;
end;

Procedure TQuickStartForm.AddAutoexecCDCommands(const Game : TGame; const Path : String);
Var I : Integer;
    St,St2 : TStringList;
    S,T : String;
begin
  T:=MakePathShort(Trim(ExtractFilePath(MakeAbsPath(Path,PrgSetup.BaseDir))));

  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count=3 then St.Add('false');
      If St.Count=4 then St.Add('');
      If St.Count<5 then continue;

      If (Trim(ExtUpperCase(St[1]))<>'DRIVE') and (Trim(ExtUpperCase(St[1]))<>'CDROM') and (Trim(ExtUpperCase(St[1]))<>'FLOPPY') then continue;
      S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));
      If Copy(T,1,length(S))=S then begin
        T:=ExcludeTrailingPathDelimiter(Copy(T,length(S)+1,MaxInt));
        St2:=StringToStringList(Game.Autoexec);
        try
          St2.Add(St[2]+':');
          If (T='') or (T[1]<>'\') then T:='\'+T;
          St2.Add('cd '+T);
          Game.Autoexec:=StringListToString(St2);
        finally
          St2.Free;
        end;
        exit;
      end;
    finally
      St.Free;
    end;
  end;
end;

procedure TQuickStartForm.AddProfile(const FileName: String; const WindowsProfile, UseWizard: Boolean);
begin
  If Assigned(FOnAddProfile) then FOnAddProfile(self,FileName,WindowsProfile,UseWizard,TemplateComboBox.ItemIndex-1);
end;

procedure TQuickStartForm.ListDragDrop(Sender, Source: TObject; X, Y: Integer);
Var I : Integer;
    FileName,S : String;
    FileList : TStringList;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  try
    For I:=0 to FileList.Count-1 do begin
      FileName:=FileList[I];
      if DirectoryExists(FileName) then begin
        S:=CurrentPath+ExtractFileName(FileName);
        If not ForceDirectories(S) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
          exit;
        end;
        If not CopyFiles(FileName,S,True,True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFiles,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end else begin
        S:=CurrentPath+ExtractFileName(FileName);
        if not CopyFile(PChar(FileName),PChar(S),True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end;
    end;
  finally
    BuildTree;
  end;
end;

procedure TQuickStartForm.TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
Var I : Integer;
    FileName,S : String;
    FileList : TStringList;
    N : TTreeNode;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  N:=Tree.GetNodeAt(X,Y);
  If N<>nil then begin
    Tree.Selected:=N;
    TreeChange(Sender,N);
  end;

  try
    For I:=0 to FileList.Count-1 do begin
      FileName:=FileList[I];
      if DirectoryExists(FileName) then begin
        S:=CurrentPath+ExtractFileName(FileName);
        If not ForceDirectories(S) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
          exit;
        end;
        If not CopyFiles(FileName,S,True,True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFiles,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end else begin
        S:=CurrentPath+ExtractFileName(FileName);
        if not CopyFile(PChar(FileName),PChar(S),True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end;
    end;
  finally
    BuildTree;
  end;
end;

procedure TQuickStartForm.DisableGUI;
begin
  If DisableCounter=0 then begin
    ToolBar.Enabled:=False;
    TreeTypeComboBox.Enabled:=False;
    Tree.Enabled:=False;
    List.Enabled:=False;
    TemplateComboBox.Enabled:=False;
    SetupComboBox1.Enabled:=False;
    SetupComboBox2.Enabled:=False;
  end;
  inc(DisableCounter);
  Working:=True;
end;

procedure TQuickStartForm.EnableGUI;
begin
  dec(DisableCounter);
  If DisableCounter=0 then begin
    ToolBar.Enabled:=True;
    TreeTypeComboBox.Enabled:=True;
    Tree.Enabled:=True;
    List.Enabled:=True;
    TemplateComboBox.Enabled:=True;
    SetupComboBox1.Enabled:=True;
    SetupComboBox2.Enabled:=True;
    Working:=False;
  end;
end;

end.
