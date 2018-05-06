unit ModernProfileEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList, GameDBUnit, LinkFileUnit,
  Menus, System.ImageList, System.UITypes;

Type TFrameClass=class of TFrame;  

Type TTextEvent=Procedure(Sender : TObject; const ProfileName, ProfileExe, ProfileSetup, ProfileScummVMGameName, ProfileScummVMPath, ProfileDOSBoxInstallation, ProfileCaptureDir : String) of object;
     TResetEvent=Procedure(Sender : TObject; const Template : TGame) of object;
     TCheckValueEvent=Procedure(Sender : TObject; var OK : Boolean) of object;
     TGetFrameFunction=Function(const FrameClass : TFrameClass) : TFrame of object;

Type TModernProfileEditorInitData=record
  OnProfileNameChange : TTextEvent;
  OnResetToDefault : TResetEvent;
  OnCheckValue : TCheckValueEvent;
  OnProfileNameChangedCallback : TNotifyEvent;
  OnShowFrame : TNotifyEvent;
  GameDB: TGameDB;
  EditingTemplate : Boolean;
  CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName, CurrentScummVMPath, CurrentDOSBoxInstallation, CurrentCaptureDir : PString;
  SearchLinkFile : TLinkFile;
  AllowDefaultValueReset : Boolean;
  GetFrame : TGetFrameFunction;
end;

Type IModernProfileEditorFrame=interface
  Procedure InitGUI(var InitData : TModernProfileEditorInitData);
  Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
  Procedure GetGame(const Game : TGame);
end;

Type TFrameRecord=record
  Frame : TFrame;
  IFrame : IModernProfileEditorFrame;
  PageCode : Integer;
  ExtPageCode : Integer;
  TreeNode : TTreeNode;
  ResetToDefault : TResetEvent;
  CheckValue : TCheckValueEvent;
  ShowFrame : TNotifyEvent;
  ProfileNameChangedCallback : TNotifyEvent;
  AllowDefaultValueReset : Boolean;
end;

Type TPageResetMode=(rmThis, rmAll, rmAllButThis);

type
  TModernProfileEditorForm = class(TForm)
    BottomPanel: TPanel;
    MainPanel: TPanel;
    CancelButton: TBitBtn;
    PreviousButton: TBitBtn;
    NextButton: TBitBtn;
    OKButton: TBitBtn;
    Tree: TTreeView;
    ImageList: TImageList;
    Splitter1: TSplitter;
    RightPanel: TPanel;
    TopPanel: TPanel;
    HelpButton: TBitBtn;
    ToolsButton: TBitBtn;
    ToolsPopupMenu: TPopupMenu;
    ToolsImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShowConfButtonClick(Sender: TObject);
    procedure ToolsButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ProfileName, ProfileExe, ProfileSetup, ProfileScummVMGameName, ProfileScummVMPath, ProfileDOSBoxInstallation, ProfileCaptureDir : String;
    BaseFrame, StartFrame : TFrame;
    ScummVM, WindowsMode : Boolean;
    ResetThisPageMenuItems : Array of TMenuItem;
    Procedure LoadData;
    Procedure SetProfileNameEvent(Sender : TObject; const AProfileName, AProfileExe, AProfileSetup, AProfileScummVMGameName, AProfileScummVMPath, AProfileDOSBoxInstallation, AProfileCaptureDir : String);
    Function AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
    Procedure InitToolsMenu;
    Procedure PopupMenuWork(Sender: TObject);
    Procedure OpenTempConfigurationFile;
    Procedure RunGameWithCurrentConfig;
    Procedure ResetTo(const Template : TGame; const PageResetMode : TPageResetMode);
    Function GetFrame(const FrameClass : TFrameClass) : TFrame;
  public
    { Public-Deklarationen }
    LastUsedPageCode : Integer;
    LastVisibleFrame : TFrame;
    MoveStatus : Integer;
    LoadTemplate, Game : TGame;
    GameDB : TGameDB;
    RestoreLastPosition : Boolean;
    EditingTemplate : Boolean;
    SearchLinkFile : TLinkFile;
    DeleteOnExit : TStringList;
    NewExeFileName, NewProfileName : String;
    HideGameInfoPage : Boolean;
    FrameList : Array of TFrameRecord;
    SilentMode : Boolean;
    Procedure InitGUI;
  end;

var
  ModernProfileEditorForm: TModernProfileEditorForm;

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const ANewProfileName, ANewExeFile : String; const GameList : TList = nil) : Boolean;
Function ModernEditGameTemplate(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil; const TemplateType : TList = nil) : Boolean;

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const PrevButton, NextButton, RestorePos : Boolean; const EditingTemplate : Boolean; const ANewProfileName, ANewExeFile : String; const HideGameInfoPage : Boolean) : Integer;

Procedure AddDefaultValueHint(const AComboBox : TComboBox);

implementation

uses ShellAPI, Math, VistaToolsUnit, LanguageSetupUnit,
     ModernProfileEditorBaseFrameUnit, ModernProfileEditorGameInfoFrameUnit,
     ModernProfileEditorDirectoryFrameUnit, ModernProfileEditorDOSBoxFrameUnit,
     ModernProfileEditorHardwareFrameUnit, ModernProfileEditorCPUFrameUnit,
     ModernProfileEditorMemoryFrameUnit, ModernProfileEditorGraphicsFrameUnit,
     ModernProfileEditorKeyboardFrameUnit, ModernProfileEditorMouseFrameUnit,
     ModernProfileEditorSoundFrameUnit, ModernProfileEditorVolumeFrameUnit,
     ModernProfileEditorSoundBlasterFrameUnit, ModernProfileEditorGUSFrameUnit,
     ModernProfileEditorMIDIFrameUnit, ModernProfileEditorJoystickFrameUnit,
     ModernProfileEditorDrivesFrameUnit, ModernProfileEditorSerialPortsFrameUnit,
     ModernProfileEditorSerialPortFrameUnit, ModernProfileEditorNetworkFrameUnit,
     ModernProfileEditorDOSEnvironmentFrameUnit, ModernProfileEditorStartFrameUnit,
     ModernProfileEditorScummVMGraphicsFrameUnit, ModernProfileEditorScummVMFrameUnit,
     ModernProfileEditorScummVMSoundFrameUnit, ModernProfileEditorPrinterFrameUnit,
     ModernProfileEditorScummVMGameFrameUnit, ModernProfileEditorHelperProgramsFrameUnit,
     ModernProfileEditorScummVMHardwareFrameUnit, ModernProfileEditorAddtionalChecksumFrameUnit,
     ModernProfileEditorInnovaFrameUnit,
     IconLoaderUnit, GameDBToolsUnit, PrgSetupUnit, CommonTools, DOSBoxUnit,
     PrgConsts, HelpConsts, SelectAutoSetupFormUnit, ScummVMUnit,
     WindowsProfileUnit, DOSBoxTempUnit, MainUnit;

{$R *.dfm}

var LastPage, LastPageExt, LastTop, LastLeft : Integer;

{ TModernProfileEditorForm }

procedure TModernProfileEditorForm.FormCreate(Sender: TObject);
begin
  LastUsedPageCode:=-1;
  NewProfileName:='';
  NewExeFileName:='';
  HideGameInfoPage:=False;
  SilentMode:=False;
end;

Function TModernProfileEditorForm.AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
Var C : Integer;
    InitData : TModernProfileEditorInitData;
begin
  C:=length(FrameList);
  with F do begin
    Visible:=False;
    Parent:=RightPanel;
    Align:=alClient;
    Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
    DoubleBuffered:=True;
  end;

  result:=Tree.Items.AddChildObject(ParentTreeNode,Name,Pointer(C));
  result.ImageIndex:=ImageIndex;
  result.SelectedIndex:=ImageIndex;

  SetLength(FrameList,C+1);
  with FrameList[C] do begin
    Frame:=F;
    IFrame:=I;
    ExtPageCode:=LastUsedPageCode; inc(LastUsedPageCode);
    TreeNode:=result;
  end;
  FrameList[C].PageCode:=PageCode;

  with InitData do begin
    OnProfileNameChange:=SetProfileNameEvent;
    OnResetToDefault:=nil;
    OnCheckValue:=nil;
    OnShowFrame:=nil;
    AllowDefaultValueReset:=True;
    CurrentProfileName:=@ProfileName;
    CurrentProfileExe:=@ProfileExe;
    CurrentProfileSetup:=@ProfileSetup;
    CurrentScummVMGameName:=@ProfileScummVMGameName;
    CurrentScummVMPath:=@ProfileScummVMPath;
    CurrentDOSBoxInstallation:=@ProfileDOSBoxInstallation;
    CurrentCaptureDir:=@ProfileCaptureDir;
  end;
  InitData.GameDB:=GameDB;
  InitData.SearchLinkFile:=SearchLinkFile;
  InitData.EditingTemplate:=EditingTemplate;
  InitData.GetFrame:=GetFrame;
  InitData.OnProfileNameChangedCallback:=nil;

  I.InitGUI(InitData);
  with FrameList[C] do begin
    ResetToDefault:=InitData.OnResetToDefault;
    CheckValue:=InitData.OnCheckValue;
    ShowFrame:=InitData.OnShowFrame;
    ProfileNameChangedCallback:=InitData.OnProfileNameChangedCallback;
    AllowDefaultValueReset:=InitData.AllowDefaultValueReset;
  end;
end;

Procedure TModernProfileEditorForm.InitToolsMenu;
Procedure AddThisPageMenuItem(const M : TMenuItem); var I : Integer; begin I:=length(ResetThisPageMenuItems); SetLength(ResetThisPageMenuItems,I+1); ResetThisPageMenuItems[I]:=M; end;
Var M,M2,M3 : TMenuItem;
    S : String;
    TemplateDB : TGameDB;
    I : Integer;
begin
  UserIconLoader.DialogImage(DI_ViewFile,ToolsImageList,0);
  UserIconLoader.DialogImage(DI_DOSBox,ToolsImageList,1);
  UserIconLoader.DialogImage(DI_ScummVM,ToolsImageList,2);
  UserIconLoader.DialogImage(DI_ExploreFolder,ToolsImageList,3);

  ToolsPopupMenu.Items.Clear;

  {View DOSBox/ScummVM config file}
  If not WindowsMode then begin
    M:=TMenuItem.Create(ToolsPopupMenu);
    If ScummVM then S:=LanguageSetup.MenuProfileViewIniFile else S:=LanguageSetup.MenuProfileViewConfFile;
    while (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);
    M.Caption:=Trim(S);
    M.ImageIndex:=0; M.Tag:=0; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);
  end;

  {Run profile}
  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsRun;
  If WindowsMode then M.ImageIndex:=-1 else begin
    If ScummVM then M.ImageIndex:=2 else M.ImageIndex:=1;
  end;
  M.Tag:=1; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);

  {Open games folder}
  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.MenuProfileOpenFolder;
  M.ImageIndex:=3;
  M.Tag:=6; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);


  {Line}
  M:=TMenuItem.Create(ToolsPopupMenu); M.Caption:='-'; ToolsPopupMenu.Items.Add(M);

  {Reset to default data}
  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetPage;
  M.Tag:=2; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M); AddThisPageMenuItem(M);

  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetAllButThis;
  M.Tag:=7; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M); AddThisPageMenuItem(M);

  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetAll;
  M.Tag:=3; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);

  If ScummVM or WindowsMode then exit;

  {Line}
  M:=TMenuItem.Create(ToolsPopupMenu); M.Caption:='-'; ToolsPopupMenu.Items.Add(M);

  {Reset to template}
  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  try
    If TemplateDB.Count>0 then begin

      M:=TMenuItem.Create(ToolsPopupMenu);
      M.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplate;
      ToolsPopupMenu.Items.Add(M);

      For I:=0 to TemplateDB.Count-1 do begin
        M2:=TMenuItem.Create(ToolsPopupMenu);
        M2.Caption:=TemplateDB[I].Name;
        M.Add(M2);

        M3:=TMenuItem.Create(ToolsPopupMenu);
        M3.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplatePage;
        M3.Tag:=10000+I; M3.OnClick:=PopupMenuWork; M2.Add(M3); AddThisPageMenuItem(M3);

        M3:=TMenuItem.Create(ToolsPopupMenu);
        M3.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplateAllButThis;
        M3.Tag:=30000+I; M3.OnClick:=PopupMenuWork; M2.Add(M3); AddThisPageMenuItem(M3);

        M3:=TMenuItem.Create(ToolsPopupMenu);
        M3.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplateAll;
        M3.Tag:=20000+I; M3.OnClick:=PopupMenuWork; M2.Add(M3);
      end;
    end;
  finally
    TemplateDB.Free;
  end;

  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetup;
  ToolsPopupMenu.Items.Add(M);

  M2:=TMenuItem.Create(ToolsPopupMenu);
  M2.Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetupPage;
  M2.Tag:=4; M2.OnClick:=PopupMenuWork; M.Add(M2); AddThisPageMenuItem(M2);

  M2:=TMenuItem.Create(ToolsPopupMenu);
  M2.Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetupAll;
  M2.Tag:=5; M2.OnClick:=PopupMenuWork; M.Add(M2);
end;

Procedure TModernProfileEditorForm.OpenTempConfigurationFile;
Var G : TGame;
    TempProf : String;
    I : Integer;
begin
  TempProf:=TempDir+MakeFileSysOKFolderName(ProfileName);
  try
    G:=TGame.Create(TempProf);
    try
      For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(G);
      G.StoreAllValues; G.LoadCache; OpenConfigurationFile(G,DeleteOnExit);
    finally
      G.Free;
    end;
  finally
    ExtDeleteFile(TempProf,ftTemp);
  end;
end;

Procedure TModernProfileEditorForm.RunGameWithCurrentConfig;
Var I : Integer;
    TempGame : TTempGame;
begin
  TempGame:=TTempGame.Create;
  try
    For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(TempGame.Game);
    TempGame.Game.StoreAllValues; TempGame.Game.LoadCache;
    If ScummVMMode(TempGame.Game) then begin
      RunScummVMGame(TempGame.Game);
    end else begin
      If WindowsExeMode(TempGame.Game) then begin
        RunWindowsGame(TempGame.Game);
      end else begin
        RunGame(TempGame.Game,DFendReloadedMainForm.DeleteOnExit);
      end;
    end;
  finally
    Sleep(100);
    TempGame.Free;
  end;
end;

Procedure TModernProfileEditorForm.ResetTo(const Template : TGame; const PageResetMode : TPageResetMode);
Var I : Integer;
begin
  Case PageResetMode of
    rmThis :       begin
                     If Tree.Selected=nil then exit;
                     I:=Integer(Tree.Selected.Data);
                     If FrameList[I].AllowDefaultValueReset then begin
                       If Assigned(FrameList[I].ResetToDefault) then FrameList[I].ResetToDefault(self,Template) else FrameList[I].IFrame.SetGame(Template,True);
                     end;
                   end;
    rmAll :        begin
                     If MessageDlg(LanguageSetup.ProfileEditorToolsResetAllConfirm,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                     For I:=0 to length(FrameList)-1 do begin
                       If not FrameList[I].AllowDefaultValueReset then continue;
                       If Assigned(FrameList[I].ResetToDefault) then FrameList[I].ResetToDefault(self,Template) else FrameList[I].IFrame.SetGame(Template,True);
                     end;
                   end;
    rmAllButThis : begin
                     If MessageDlg(LanguageSetup.ProfileEditorToolsResetAllButThisConfirm,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                     For I:=0 to length(FrameList)-1 do begin
                       If not FrameList[I].AllowDefaultValueReset then continue;
                       If I=Integer(Tree.Selected.Data) then continue;
                       If Assigned(FrameList[I].ResetToDefault) then FrameList[I].ResetToDefault(self,Template) else FrameList[I].IFrame.SetGame(Template,True);
                     end;
                   end;
  end;
end;

Procedure TModernProfileEditorForm.PopupMenuWork(Sender: TObject);
Var DB : TGameDB;
    Nr : Integer;
    G : TGame;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : OpenTempConfigurationFile;
    1 : RunGameWithCurrentConfig;
    2 : begin
          G:=TGame.Create(PrgSetup);
          try ResetTo(G,rmThis); finally G.Free; end;
        end;
    3 : begin
          G:=TGame.Create(PrgSetup);
          try ResetTo(G,rmAll); finally G.Free; end;
        end;
    4 : begin
          DB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
          try
            Nr:=ShowSelectAutoSetupDialog(self,DB);
            If Nr>=0 then ResetTo(DB[Nr],rmThis);
          finally
            DB.Free;
          end;
        end;
    5 : begin
          DB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
          try
            Nr:=ShowSelectAutoSetupDialog(self,DB);
            If Nr>=0 then ResetTo(DB[Nr],rmAll);
          finally
            DB.Free;
          end;
        end;
    6 : begin
          If ScummVM then S:=ProfileScummVMPath else {Windows or DOSBox mode} S:=ProfileExe;
          If S='' then S:=PrgSetup.GameDir;
          S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
          ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
        end;
    7: begin
          G:=TGame.Create(PrgSetup);
          try ResetTo(G,rmAllButThis); finally G.Free; end;
       end;
    10000..19999 : begin
                     DB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
                     try ResetTo(DB[(Sender as TComponent).Tag-10000],rmThis); finally DB.Free; end;
                   end;
    20000..29999 : begin
                     DB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
                     try ResetTo(DB[(Sender as TComponent).Tag-20000],rmAll); finally DB.Free; end;
                   end;
    30000..39999 : begin
                     DB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
                     try ResetTo(DB[(Sender as TComponent).Tag-30000],rmAllButThis); finally DB.Free; end;
                   end;
  end;
end;

procedure TModernProfileEditorForm.InitGUI;
Var F : TFrame;
    N,N2 : TTreeNode;
    S : String;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(MainPanel);
  NoFlicker(BottomPanel);
  NoFlicker(RightPanel);
  NoFlicker(TopPanel);
  TopPanel.ControlStyle:=TopPanel.ControlStyle-[csParentBackground];

  LastVisibleFrame:=nil;
  MoveStatus:=0;

  Caption:=LanguageSetup.ProfileEditor;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  PreviousButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Previous;
  NextButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Next;

  UserIconLoader.DialogImage(DI_Previous,PreviousButton);
  UserIconLoader.DialogImage(DI_Next,NextButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Tools,ToolsButton);

  ScummVM:=ScummVMMode(Game) or ScummVMMode(LoadTemplate);
  WindowsMode:=WindowsExeMode(Game) or WindowsExeMode(LoadTemplate);

  If ScummVM then S:=LanguageSetup.MenuProfileViewIniFile else S:=LanguageSetup.MenuProfileViewConfFile;
  while (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);

  ToolsButton.Caption:=LanguageSetup.ProfileEditorTools;
  InitToolsMenu;

  Tree.Items.BeginUpdate;
  try
    If ScummVM then begin
      {ScummVM mode}
      F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
      BaseFrame:=F;
      If not HideGameInfoPage then begin F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1); end;
      F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);

      F:=TModernProfileEditorHelperProgramsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorHelperProgramsFrame(F),LanguageSetup.ProfileEditorHelperProgramsSheet,0,0);
      F:=TModernProfileEditorScummVMFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorScummVMFrame(F),LanguageSetup.ProfileEditorScummVMSheet,2,23);

      F:=TModernProfileEditorScummVMGameFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMGameFrame(F),LanguageSetup.ProfileEditorScummVMGameSheet,6,23);
      F:=TModernProfileEditorScummVMHardwareFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorScummVMHardwareFrame(F),LanguageSetup.ProfileEditorHardwareSheet,3,3);
      F:=TModernProfileEditorScummVMGraphicsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMGraphicsFrame(F),LanguageSetup.ProfileEditorGraphicsSheet,4,11);
      F:=TModernProfileEditorScummVMSoundFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMSoundFrame(F),LanguageSetup.ProfileEditorSoundSheet,5,5);
    end else begin
      If WindowsMode then begin
        {Windows mode}
        F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
        BaseFrame:=F;
        if EditingTemplate then begin F:=TModernProfileEditorAddtionalChecksumFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorAddtionalChecksumFrame(F),LanguageSetup.ProfileEditorAdditionalChecksums,0,0); end;
        If not HideGameInfoPage then begin F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1); end;
        F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
        F:=TModernProfileEditorHelperProgramsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorHelperProgramsFrame(F),LanguageSetup.ProfileEditorHelperProgramsSheet,0,0);
      end else begin
        {DOSBox mode}
        F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
        BaseFrame:=F;
        if EditingTemplate then begin F:=TModernProfileEditorAddtionalChecksumFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorAddtionalChecksumFrame(F),LanguageSetup.ProfileEditorAdditionalChecksums,0,0); end;
        If not HideGameInfoPage then begin F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1); end;
        F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
        F:=TModernProfileEditorHelperProgramsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorHelperProgramsFrame(F),LanguageSetup.ProfileEditorHelperProgramsSheet,0,0);
        F:=TModernProfileEditorDOSBoxFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorDOSBoxFrame(F),LanguageSetup.ProfileEditorGeneralSheet,2,2);
        F:=TModernProfileEditorHardwareFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorHardwareFrame(F),LanguageSetup.ProfileEditorHardwareSheet,3,3);
        F:=TModernProfileEditorCPUFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorCPUFrame(F),LanguageSetup.ProfileEditorCPUSheet,3,9);
        F:=TModernProfileEditorMemoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorMemoryFrame(F),LanguageSetup.ProfileEditorMemorySheet,4,10);
        F:=TModernProfileEditorGraphicsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGraphicsFrame(F),LanguageSetup.ProfileEditorGraphicsSheet,4,11);
        F:=TModernProfileEditorKeyboardFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorKeyboardFrame(F),LanguageSetup.ProfileEditorKeyboardSheet,4,15);
        F:=TModernProfileEditorMouseFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorMouseFrame(F),LanguageSetup.ProfileEditorMouseSheet,4,12);
        F:=TModernProfileEditorSoundFrame.Create(self); N2:=AddTreeNode(N,F,TModernProfileEditorSoundFrame(F),LanguageSetup.ProfileEditorSoundSheet,5,5);
        F:=TModernProfileEditorVolumeFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorVolumeFrame(F),LanguageSetup.ProfileEditorSoundVolumeSheet,5,18);
        F:=TModernProfileEditorSoundBlasterFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorSoundBlasterFrame(F),LanguageSetup.ProfileEditorSoundSoundBlaster,5,19);
        F:=TModernProfileEditorGUSFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorGUSFrame(F),LanguageSetup.ProfileEditorSoundGUS,5,20);
        F:=TModernProfileEditorMIDIFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorMIDIFrame(F),LanguageSetup.ProfileEditorSoundMIDI,5,21);
        If PrgSetup.AllowInnova then begin
          F:=TModernProfileEditorInnovaFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorInnovaFrame(F),LanguageSetup.ProfileEditorSoundInnova,5,5);
        end;
        F:=TModernProfileEditorJoystickFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorJoystickFrame(F),LanguageSetup.ProfileEditorSoundJoystick,5,16);
        F:=TModernProfileEditorDrivesFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDrivesFrame(F),LanguageSetup.ProfileEditorMountingSheet,4,4);
        F:=TModernProfileEditorSerialPortsFrame.Create(self); N2:=AddTreeNode(N,F,TModernProfileEditorSerialPortsFrame(F),LanguageSetup.ProfileEditorSerialPortsSheet,3,13);
        F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=1; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 1',3,13);
        F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=2; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 2',3,13);
        F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=3; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 3',3,13);
        F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=4; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 4',3,13);
        F:=TModernProfileEditorNetworkFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorNetworkFrame(F),LanguageSetup.ProfileEditorNetworkSheet,3,14);
        If PrgSetup.AllowPrinterSettings then begin
          F:=TModernProfileEditorPrinterFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorPrinterFrame(F),LanguageSetup.ProfileEditorPrinterSheet,3,17);
        end;
        F:=TModernProfileEditorDOSEnvironmentFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorDOSEnvironmentFrame(F),LanguageSetup.ProfileEditorDOSEnvironmentSheet,7,22);
        F:=TModernProfileEditorStartFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorStartFrame(F),LanguageSetup.ProfileEditorStartingSheet,6,6);
        StartFrame:=F;
      end;
    end;
  finally
    Tree.Items.EndUpdate;
  end;

  Tree.FullExpand;

  If Tree.Items.Count>0 then begin
    Tree.Selected:=Tree.Items[0];
    Tree.Selected.MakeVisible;
  end;

  {Fix height for smaller screens}
  Height:=Min(Height,Screen.WorkAreaHeight);
  If Top+Height>Screen.WorkAreaHeight then Top:=Screen.WorkAreaHeight-Height;
end;

procedure TModernProfileEditorForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  InitGUI;

  UserIconLoader.DirectLoad(ImageList,'ModernProfileEditor');

  If (Game=nil) and (LoadTemplate<>nil) then begin
    Game:=LoadTemplate;
    try LoadData; finally Game:=nil; end;

    If Trim(NewProfileName)<>'' then ProfileName:=NewProfileName else ProfileName:='';
    If Trim(NewExeFileName)<>'' then begin
      If Trim(NewProfileName)='' then ProfileName:=ChangeFileExt(ExtractFileName(NewExeFileName),'');
      ProfileExe:=NewExeFileName;
    end else begin
      ProfileExe:='';
    end;
    ProfileSetup:='';
    ProfileScummVMGameName:='';
    ProfileScummVMPath:='';
    ProfileDOSBoxInstallation:='';
    ProfileCaptureDir:='';
  end else begin
    LoadData;
    ProfileEditorOpenCheck(Game);
    If Trim(NewProfileName)<>'' then begin
      If Trim(Game.Name)='' then ProfileName:=NewProfileName else ProfileName:=Game.Name;
    end;
    If Trim(NewExeFileName)<>'' then begin
      If Trim(NewProfileName)='' then begin
        If Trim(Game.Name)='' then ProfileName:=ChangeFileExt(ExtractFileName(NewExeFileName),'') else ProfileName:=Game.Name;
      end;
      ProfileExe:=NewExeFileName;
    end else begin
      If Trim(NewProfileName)='' then ProfileName:=Game.Name;
      ProfileExe:=Game.GameExe;
    end;
    ProfileSetup:=Game.SetupExe;
    ProfileScummVMGameName:=Game.ScummVMGame;
    ProfileScummVMPath:=Game.ScummVMSavePath;
    ProfileDOSBoxInstallation:=Game.CustomDOSBoxDir;
    ProfileCaptureDir:=Game.CaptureFolder;
  end;

  If (Trim(NewExeFileName)<>'') or (Trim(NewProfileName)<>'') then begin
    TModernProfileEditorBaseFrame(BaseFrame).ProfileNameEdit.Text:=ProfileName;
    TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text:=ProfileExe;
  end;

  SetProfileNameEvent(self,ProfileName,ProfileExe,ProfileSetup,ProfileScummVMGameName,ProfileScummVMPath,ProfileDOSBoxInstallation,ProfileCaptureDir);

  If RestoreLastPosition then begin
    If LastPageExt>=0 then begin
      For I:=0 to length(FrameList)-1 do if FrameList[I].ExtPageCode=LastPageExt then begin
        Tree.Selected:=FrameList[I].TreeNode;
        break;
      end;
    end else begin
      For I:=0 to length(FrameList)-1 do if FrameList[I].PageCode=LastPage then begin
        Tree.Selected:=FrameList[I].TreeNode;
        break;
      end;
    end;
    If LastTop>0 then Top:=LastTop;
    If LastLeft>0 then Left:=LastLeft;
  end else begin
    If PrgSetup.ReopenLastProfileEditorTab and (Game<>nil) then begin
      If Game.LastOpenTabModern>=0 then begin
        For I:=0 to length(FrameList)-1 do if FrameList[I].ExtPageCode=Game.LastOpenTabModern then begin
          Tree.Selected:=FrameList[I].TreeNode;
          break;
        end;
      end else begin
        For I:=0 to length(FrameList)-1 do if FrameList[I].PageCode=Game.LastOpenTab then begin
          Tree.Selected:=FrameList[I].TreeNode;
          break;
        end;
      end;
    end;
  end;
  TreeChange(Sender,Tree.Selected);
end;

procedure TModernProfileEditorForm.LoadData;
Var I : Integer;
begin
  For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.SetGame(Game,LoadTemplate<>nil);
end;

procedure TModernProfileEditorForm.SetProfileNameEvent(Sender: TObject; const AProfileName, AProfileExe, AProfileSetup, AProfileScummVMGameName, AProfileScummVMPath, AProfileDOSBoxInstallation, AProfileCaptureDir : String);
Var S : String;
    B : Boolean;
    I : Integer;
begin
  B:=(ProfileName<>AProfileName);
  ProfileName:=AProfileName;
  If B then For I:=0 to length(FrameList)-1 do If Assigned(FrameList[I].ProfileNameChangedCallback) then FrameList[I].ProfileNameChangedCallback(self);
  ProfileExe:=AProfileExe;
  ProfileSetup:=AProfileSetup;
  ProfileScummVMGameName:=AProfileScummVMGameName;
  ProfileScummVMPath:=AProfileScummVMPath;
  ProfileDOSBoxInstallation:=AProfileDOSBoxInstallation;
  ProfileCaptureDir:=AProfileCaptureDir;

  If Trim(ProfileName)='' then begin
    If EditingTemplate and HideGameInfoPage then begin
      If ScummVMMode(Game)
        then S:=LanguageSetup.TemplateFormDefaultScummVM
        else S:=LanguageSetup.TemplateFormDefault;
    end else begin
      S:=LanguageSetup.NotSet
    end;
  end else begin
    S:=ProfileName;
  end;
  If (S=LanguageSetup.ProfileEditorNoFilename) or (S=LanguageSetup.NotSet)
    then Caption:=LanguageSetup.ProfileEditor
    else Caption:=LanguageSetup.ProfileEditor+' ['+S+']';
end;

procedure TModernProfileEditorForm.ToolsButtonClick(Sender: TObject);
Var P : TPoint;
    B : Boolean;
    I : Integer;
begin
  If Tree.Selected=nil then B:=False else B:=FrameList[Integer(Tree.Selected.Data)].AllowDefaultValueReset;
  For I:=0 to length(ResetThisPageMenuItems)-1 do ResetThisPageMenuItems[I].Enabled:=B; 

  P:=BottomPanel.ClientToScreen(Point(ToolsButton.Left,ToolsButton.Top));
  ToolsPopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TModernProfileEditorForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  If LastVisibleFrame<>nil then begin
    LastVisibleFrame.Visible:=False;
    LastVisibleFrame:=nil;
  end;

  If Tree.Selected<>nil then begin
    LastVisibleFrame:=FrameList[Integer(Tree.Selected.Data)].Frame;
    LastVisibleFrame.Visible:=True;
    If Assigned(FrameList[Integer(Tree.Selected.Data)].ShowFrame) then FrameList[Integer(Tree.Selected.Data)].ShowFrame(self);
    TopPanel.Caption:='  '+Tree.Selected.Text;
  end;
end;

procedure TModernProfileEditorForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S,T : String;
    St : TStringList;
    B : Boolean;
begin
  For I:=0 to Tree.Items.Count-1 do begin
    If not Assigned(FrameList[Integer(Tree.Items[I].Data)].CheckValue) then continue;
    B:=True;
    FrameList[Integer(Tree.Items[I].Data)].CheckValue(self,B);
    If not B then begin Tree.Selected:=Tree.Items[I];  ModalResult:=mrNone; exit; end;
  end;

  If not ScummVM then begin
    If (not SilentMode) and (not EditingTemplate) and (LoadTemplate<>nil) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)='') and (WindowsMode or TModernProfileEditorStartFrame(StartFrame).AutoexecBootNormal.Checked) then begin
      If MessageDlg(LanguageSetup.MessageNoGameFileNameWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
        Tree.Selected:=Tree.Items[0];
        ModalResult:=mrNone;
        exit;
      end;
    end;

    If WindowsMode then begin
      If (not SilentMode) and (not EditingTemplate) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)<>'') then begin
        S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text,PrgSetup.BaseDir);
        If IsDOSExe(S) then begin
          If MessageDlg(Format(LanguageSetup.MessageDOSExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
            Tree.Selected:=Tree.Items[0];
            ModalResult:=mrNone;
            exit;
          end;
        end;
        If (not SilentMode) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text)<>'') then begin
          S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text,PrgSetup.BaseDir);
          If IsDOSExe(S) then begin
            If MessageDlg(Format(LanguageSetup.MessageDOSExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
              Tree.Selected:=Tree.Items[0];
              ModalResult:=mrNone;
              exit;
            end;
          end;
        end;
      end;
    end else begin
      If (not SilentMode) and (not EditingTemplate) and TModernProfileEditorStartFrame(StartFrame).AutoexecBootNormal.Checked then begin
        If (not TModernProfileEditorBaseFrame(BaseFrame).GameRelPathCheckBox.Checked) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)<>'') then begin
          S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text,PrgSetup.BaseDir);
          If IsWindowsExe(S) and (not TModernProfileEditorBaseFrame(BaseFrame).IgnoreWindowsWarningsCheckBox.Checked) then begin
            If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
              Tree.Selected:=Tree.Items[0];
              ModalResult:=mrNone;
              exit;
            end;
          end;
        end;
        If (not SilentMode) and (not TModernProfileEditorBaseFrame(BaseFrame).SetupRelPathCheckBox.Checked) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text)<>'') then begin
          S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text,PrgSetup.BaseDir);
          If IsWindowsExe(S) and (not TModernProfileEditorBaseFrame(BaseFrame).IgnoreWindowsWarningsCheckBox.Checked) then begin
            If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
              Tree.Selected:=Tree.Items[0];
              ModalResult:=mrNone;
              exit;
            end;
          end;
        end;
      end;
    end;
  end;

  Case (Sender as TComponent).Tag of
    0 : MoveStatus:=0;
    1 : MoveStatus:=-1;
    2 : MoveStatus:=1;
  End;

  If Game=nil then begin
    I:=GameDB.Add(ProfileName);
    Game:=GameDB[I];
  end;

  For I:=0 to Tree.Items.Count-1 do begin
    FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(Game);
    ProfileName:=Game.Name;
  end;

  If (not WindowsMode) and (not ScummVM) and (LoadTemplate<>nil) and PrgSetup.AddMountingDataAutomatically then begin
    St:=TStringList.Create;
    try
      For I:=0 to Game.NrOfMounts-1 do St.Add(Game.Mount[I]);
      If Trim(Game.GameExe)='' then S:='' else S:=ExtractFilePath(Game.GameExe);
      If ExtUpperCase(Copy(Trim(S),1,7))='DOSBOX:' then S:='';
      If Trim(Game.SetupExe)='' then T:='' else T:=ExtractFilePath(Game.SetupExe);
      If ExtUpperCase(Copy(Trim(T),1,7))='DOSBOX:' then T:='';
      BuildGameDirMountData(St,S,T);
      Game.NrOfMounts:=St.Count;
      For I:=0 to St.Count-1 do Game.Mount[I]:=St[I];
      For I:=St.Count to 9 do Game.Mount[I]:='';
    finally
      St.Free;
    end;
  end;

  If not SilentMode then begin
    If Tree.Selected<>nil then begin
      LastPage:=FrameList[Integer(Tree.Selected.Data)].PageCode;
      LastPageExt:=FrameList[Integer(Tree.Selected.Data)].ExtPageCode;
    end else begin
      LastPage:=0;
      LastPageExt:=0;
    end;
    Game.LastOpenTab:=LastPage;
    Game.LastOpenTabModern:=LastPageExt;
  end;

  Game.StoreAllValues;
  Game.LoadCache;

  If (not WindowsMode) and (not ScummVM) and (not EditingTemplate) then begin
    St:=TStringList.Create;
    try
      BuildAutoexec(Game,False,St,True,-1,False,False,false);
    finally
      St.Free;
    end;
  end;

  If Trim(Game.CaptureFolder)<>'' then ForceDirectories(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));
end;

procedure TModernProfileEditorForm.HelpButtonClick(Sender: TObject);
Var I : Integer;
begin
  I:=0;
  If LastVisibleFrame<>nil then I:=LastVisibleFrame.HelpContext;
  If I=0 then I:=ID_FileEdit;
  Application.HelpCommand(HELP_CONTEXT,I);
end;

procedure TModernProfileEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TModernProfileEditorForm.ShowConfButtonClick(Sender: TObject);
Var G : TGame;
    TempProf : String;
    I : Integer;
begin
  TempProf:=TempDir+MakeFileSysOKFolderName(ProfileName);
  try
    G:=TGame.Create(TempProf);
    try
      For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(G);
      G.StoreAllValues;
      G.LoadCache;
      OpenConfigurationFile(G,DeleteOnExit);
    finally
      G.Free;
    end;
  finally
    ExtDeleteFile(TempProf,ftTemp);
  end;
end;

function TModernProfileEditorForm.GetFrame(const FrameClass: TFrameClass): TFrame;
Var I : Integer;
begin
  result:=nil;
  For I:=0 to length(FrameList)-1 do If FrameList[I].Frame is FrameClass then begin result:=FrameList[I].Frame; exit; end;
end;

{ global }

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const PrevButton, NextButton, RestorePos : Boolean; const EditingTemplate : Boolean; const ANewProfileName, ANewExeFile : String; const HideGameInfoPage : Boolean) : Integer;
Var D : Double;
    S : String;
    I : Integer;
begin
  If (AGame<>nil) and (Trim(ExtUpperCase(AGame.VideoCard))='VGA') then begin
    S:=CheckDOSBoxVersion(GetDOSBoxNr(AGame));
    For I:=1 to length(S) do
      If (S[I]=',') or (S[I]='.') then S[I] := FormatSettings.DecimalSeparator;
    if not TryStrToFloat(S,D) then D:=0.72;
    If D>0.72 then begin AGame.VideoCard:='svga_s3'; AGame.StoreAllValues; end;
  end;

  ModernProfileEditorForm:=TModernProfileEditorForm.Create(AOwner);

  try
    ModernProfileEditorForm.RestoreLastPosition:=RestorePos;
    If RestorePos and ((LastTop>0) or (LastLeft>0)) then ModernProfileEditorForm.Position:=poDesigned;
    ModernProfileEditorForm.GameDB:=AGameDB;
    ModernProfileEditorForm.Game:=AGame;
    ModernProfileEditorForm.SearchLinkFile:=ASearchLinkFile;
    ModernProfileEditorForm.DeleteOnExit:=ADeleteOnExit;
    ModernProfileEditorForm.LoadTemplate:=ADefaultGame;
    ModernProfileEditorForm.PreviousButton.Visible:=PrevButton;
    ModernProfileEditorForm.NextButton.Visible:=NextButton;
    ModernProfileEditorForm.EditingTemplate:=EditingTemplate;
    If ANewExeFile<>'' then ModernProfileEditorForm.NewExeFileName:=ANewExeFile;
    If ANewProfileName<>'' then ModernProfileEditorForm.NewProfileName:=ANewProfileName;
    ModernProfileEditorForm.HideGameInfoPage:=HideGameInfoPage;
    If ModernProfileEditorForm.ShowModal=mrOK then begin
      result:=ModernProfileEditorForm.MoveStatus;
      AGame:=ModernProfileEditorForm.Game;
      {LastPage set via OKButtonClick}
      LastTop:=ModernProfileEditorForm.Top;
      LastLeft:=ModernProfileEditorForm.Left;
    end else begin
      result:=-2;
    end;
  finally
    ModernProfileEditorForm.Free;
  end;
end;

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const ANewProfileName, ANewExeFile : String; const GameList : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
    S,T : String;
begin
  I:=0; RestorePos:=False;
  repeat
    If GameList=nil then begin
      NextButton:=False;
      PrevButton:=False;
    end else begin
      If I=1 then begin
        J:=GameList.IndexOf(AGame);
        If (J>=0) and (J<GameList.Count-1) then AGame:=TGame(GameList[J+1]);
      end;
      If I=-1 then begin
        J:=GameList.IndexOf(AGame);
        If J>0 then AGame:=TGame(GameList[J-1]);
      end;
      J:=GameList.IndexOf(AGame);
      NextButton:=(J>=0) and (J<GameList.Count-1);
      PrevButton:=(J>0);
    end;
    If (GameList=nil) or (GameList.Count=0) then begin S:=ANewProfileName; T:=ANewExeFile end else begin S:=''; T:=''; end;
    I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,ASearchLinkFile,ADeleteOnExit,PrevButton,NextButton,RestorePos,False,S,T,False);
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

Function ModernEditGameTemplate(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil; const TemplateType : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
    TemplateMode : Integer;
begin
  I:=0; RestorePos:=False;
  repeat
    If GameList=nil then begin
      NextButton:=False;
      PrevButton:=False;
    end else begin
      If I=1 then begin
        J:=GameList.IndexOf(AGame);
        If (J>=0) and (J<GameList.Count-1) then AGame:=TGame(GameList[J+1]);
      end;
      If I=-1 then begin
        J:=GameList.IndexOf(AGame);
        If J>0 then AGame:=TGame(GameList[J-1]);
      end;
      J:=GameList.IndexOf(AGame);
      NextButton:=(J>=0) and (J<GameList.Count-1);
      PrevButton:=(J>0);
    end;

    If (TemplateType<>nil) then begin
      TemplateMode:=Integer(TemplateType[GameList.IndexOf(AGame)]);
    end else begin
      TemplateMode:=0;
    end;
    {TemplateMode: 0=normal template, 1=default template, 2=ScummVM default template}

    If TemplateMode=2 then AGame.ProfileMode:='ScummVM';
    try
      I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,ASearchLinkFile,ADeleteOnExit,PrevButton,NextButton,RestorePos,True,'','',TemplateMode<>0);
    finally
      If TemplateMode=2 then AGame.ProfileMode:='DOSBox';
    end;
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

Procedure AddDefaultValueHint(const AComboBox : TComboBox);
Var S : String;
    I : Integer;
begin
  S:=LanguageSetup.ProfileEditorDefaultValueHint;
  If length(S)>80 then For I:=80 downto 1 do If S[I]=#32 then begin S[I]:=#13; break; end;
  AComboBox.Hint:=S;
  AComboBox.ShowHint:=True;
end;

end.
