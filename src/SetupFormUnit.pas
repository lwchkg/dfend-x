unit SetupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, ImgList, Menus, GameDBUnit,
  LinkFileUnit;

Type TFrameClass=class of TFrame; 

Type TSimpleEvent=Procedure of object;
     TOpenLanguageEditorEvent=Procedure(const Mode : Integer) of object;
     TCloseCheckEvent=Procedure(var CloseOK : Boolean) of object;
     TGetFrameFunction=Function(const FrameClass : TFrameClass) : TFrame of object;

Type TInitData=record
  BeforeLanguageChangeNotify, LanguageChangeNotify, DosBoxDirChangeNotify : TSimpleEvent;
  PDosBoxDir, PBaseDir, PDOSBoxLang : PString;
  GameDB : TGameDB;
  OpenLanguageEditorEvent : TOpenLanguageEditorEvent;
  CloseCheckEvent : TCloseCheckEvent;
  GetFrame : TGetFrameFunction;
  SearchLinkFile : TLinkFile;
end;

Type ISetupFrame=interface
  Function GetName : String;
  Procedure InitGUIAndLoadSetup(var InitData : TInitData);
  Procedure BeforeChangeLanguage;
  Procedure LoadLanguage;
  Procedure DOSBoxDirChanged;
  Procedure ShowFrame(const AdvancedMode : Boolean);
  Procedure HideFrame;
  Procedure RestoreDefaults;
  Procedure SaveSetup;
end;

Type TFrameRecord=record
  Frame : TFrame;
  IFrame : ISetupFrame;
  AdvancedModeOnly : Boolean;
  ParentFrame : TFrame;
  ImageIndex : Integer;
  IsEmpty : Boolean;
  CloseCheckEvent : TCloseCheckEvent;
end;

Type TOpenMode=(omNormal, omLanguage, omTreeList, omToolbar, omIconSet, omUpdate);

type
  TSetupForm = class(TForm)
    BottomPanel: TPanel;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    MainPanel: TPanel;
    Splitter1: TSplitter;
    Tree: TTreeView;
    RightPanel: TPanel;
    TopPanel: TPanel;
    ModeLabel: TLabel;
    ModeComboBox: TComboBox;
    ImageList: TImageList;
    RestoreDefaultValuesButton: TBitBtn;
    PopupMenu: TPopupMenu;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ModeComboBoxChange(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure OKButtonClick(Sender: TObject);
    procedure RestoreDefaultValuesButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Frames : Array of TFrameRecord;
    VisibleFrame : Integer;
    SetAdvanced : Boolean;
    LanguageFrame, TreeListFrame, ToolbarFrame, IconSetFrame, UpdateFrame : TFrame;
    InternalDOSBoxDir, InternalDOSBoxLang, InternalBaseDir : String;
    Procedure InitFramesList;
    Procedure AddTreeNode(const ParentFrame, NewFrame : TFrame; NewFrameInterface : ISetupFrame; const AdvancedModeOnly : Boolean; const ImageIndex : Integer; const IsEmpty : Boolean = False);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure OpenLanguageEditor(const Mode : Integer);
    Function FindNodeFromFrame(const F : TFrame) : TTreeNode;
    Procedure PopupClick(Sender : TObject);
    Procedure SelectFrame(const Nr : Integer);
    Function GetFrame(const FrameClass : TFrameClass) : TFrame;
  public
    { Public-Deklarationen }
    OpenMode : TOpenMode;
    LanguageEditorMode : Integer;
    GameDB : TGameDB;
    SearchLinkFile : TLinkFile;
  end;

var
  SetupForm: TSetupForm;

Function ShowSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const OpenLanguageTab : Boolean = False) : Boolean;
Function ShowTreeListSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
Function ShowToolbarSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
Function ShowIconSetSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
Function ShowUpdateSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     IconLoaderUnit, LanguageEditorFormUnit, LanguageEditorStartFormUnit,
     HelpConsts, SetupFrameBaseUnit, SetupFrameDirectoriesUnit,
     SetupFrameSurfaceUnit, SetupFrameLanguageUnit, SetupFrameMenubarUnit,
     SetupFrameToolbarUnit, SetupFrameGamesListColumnsUnit,
     SetupFrameGamesListAppearanceUnit, SetupFrameGamesListTreeAppearanceUnit,
     SetupFrameGamesListScreenshotAppearanceUnit, SetupFrameProfileEditorUnit,
     SetupFrameDefaultValuesUnit, SetupFrameProgramsUnit, SetupFrameDOSBoxUnit,
     SetupFrameDOSBoxExtUnit, SetupFrameFreeDOSUnit, SetupFrameScummVMUnit,
     SetupFrameQBasicUnit, SetupFrameWaveEncoderUnit, SetupFrameSecurityUnit,
     SetupFrameServiceUnit, SetupFrameUpdateUnit, SetupFrameWineUnit,
     SetupFrameCompressionUnit, SetupFrameGamesListScreenshotModeAppearanceUnit,
     SetupFrameEditorUnit, SetupFrameViewerUnit, SetupFrameWindowsGamesUnit,
     SetupFrameZipPrgsUnit, SetupFrameCustomLanguageStringsUnit,
     SetupFrameGameListIconModeAppearanceUnit, SetupFrameUserInterpreterFrameUnit,
     SetupFrameImageScalingUnit, SetupFrameMoreEmulatorsUnit,
     SetupFrameAutomaticConfigurationUnit, SetupFrameDOSBoxGlobalUnit,
     SetupFrameDataPrivacyUnit, MainUnit;

{$R *.dfm}

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  NoFlicker(MainPanel);
  NoFlicker(BottomPanel);
  NoFlicker(RightPanel);
  NoFlicker(TopPanel);
  TopPanel.ControlStyle:=TopPanel.ControlStyle-[csParentBackground];

  SetLength(Frames,0);
  SetAdvanced:=False;
  OpenMode:=omNormal;
  VisibleFrame:=-1;
  LanguageEditorMode:=0;
end;

procedure TSetupForm.FormShow(Sender: TObject);
begin
  ModeLabel.Visible:=not SetAdvanced;
  ModeComboBox.Visible:=not SetAdvanced;
  If not SetAdvanced then begin
    If PrgSetup.EasySetupMode and (not SetAdvanced) then ModeComboBox.ItemIndex:=0 else ModeComboBox.ItemIndex:=1;
  end;

  InternalDOSBoxDir:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  InternalDOSBoxLang:=PrgSetup.DOSBoxSettings[0].DosBoxLanguage;
  InternalBaseDir:=PrgSetup.BaseDir;

  UserIconLoader.DirectLoad(ImageList,'SetupForm');
  UserIconLoader.DialogImage(DI_ResetDefault,RestoreDefaultValuesButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  InitFramesList;
  LoadLanguage;

  Case OpenMode of
    omLanguage : Tree.Selected:=FindNodeFromFrame(LanguageFrame);
    omTreeList : Tree.Selected:=FindNodeFromFrame(TreeListFrame);
    omToolbar  : Tree.Selected:=FindNodeFromFrame(ToolbarFrame);
    omIconSet  : Tree.Selected:=FindNodeFromFrame(IconSetFrame);
    omUpdate   : Tree.Selected:=FindNodeFromFrame(UpdateFrame);
    else         Tree.Selected:=Tree.Items[0];
  end;
  If Tree.Selected<>nil then Tree.Selected.MakeVisible;
end;

function TSetupForm.GetFrame(const FrameClass: TFrameClass): TFrame;
Var I : Integer;
begin
  result:=nil;
  For I:=0 to length(Frames)-1 do If Frames[I].Frame is FrameClass then begin result:=Frames[I].Frame; exit; end;
end;

Procedure TSetupForm.AddTreeNode(const ParentFrame, NewFrame : TFrame; NewFrameInterface : ISetupFrame; const AdvancedModeOnly : Boolean; const ImageIndex : Integer; const IsEmpty : Boolean);
Var C : Integer;
    InitData : TInitData;
begin
  with InitData do begin
    LanguageChangeNotify:=LoadLanguage;
    DosBoxDirChangeNotify:=DOSBoxDirChanged;
    OpenLanguageEditorEvent:=OpenLanguageEditor;
    PDosBoxDir:=@InternalDOSBoxDir;
    PDOSBoxLang:=@InternalDOSBoxLang;
    PBaseDir:=@InternalBaseDir;
    CloseCheckEvent:=nil;
  end;
  InitData.BeforeLanguageChangeNotify:=BeforeChangeLanguage;
  InitData.GameDB:=GameDB;
  InitData.GetFrame:=GetFrame;
  InitData.SearchLinkFile:=SearchLinkFile;
  C:=length(Frames);
  with NewFrame do begin
    Visible:=False;
    Parent:=RightPanel;
    Align:=alClient;
    Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
    DoubleBuffered:=True;
  end;
  SetLength(Frames,C+1);
  with Frames[C] do begin
    Frame:=NewFrame;
    IFrame:=NewFrameInterface;
  end;
  Frames[C].AdvancedModeOnly:=AdvancedModeOnly;
  Frames[C].ParentFrame:=ParentFrame;
  Frames[C].ImageIndex:=ImageIndex;
  Frames[C].IsEmpty:=IsEmpty;

  try
    NewFrameInterface.InitGUIAndLoadSetup(InitData);
    Frames[C].CloseCheckEvent:=InitData.CloseCheckEvent;
  except
    on E : Exception do MessageDlg(E.Message,mtError,[mbOk],0);
  end;
end;

procedure TSetupForm.InitFramesList;
Var F,Root,Root2 : TFrame;
begin
  F:=TSetupFrameBase.Create(self); AddTreeNode(nil,F,TSetupFrameBase(F),False,0); Root:=F;
  F:=TSetupFrameDirectories.Create(self); AddTreeNode(Root,F,TSetupFrameDirectories(F),False,1);
  F:=TSetupFrameSecurity.Create(self); AddTreeNode(Root,F,TSetupFrameSecurity(F),True,5);
  F:=TSetupFrameDataPrivacy.Create(self); AddTreeNode(Root,F,TSetupFrameDataPrivacy(F),True,5);
  F:=TSetupFrameCompression.Create(self); AddTreeNode(Root,F,TSetupFrameCompression(F),True,16);
  F:=TSetupFrameWine.Create(self); AddTreeNode(Root,F,TSetupFrameWine(F),True,19);

  F:=TSetupFrameSurface.Create(self); AddTreeNode(nil,F,TSetupFrameSurface(F),False,12); Root:=F; IconSetFrame:=F;
  F:=TSetupFrameLanguage.Create(self); AddTreeNode(Root,F,TSetupFrameLanguage(F),False,2,True); LanguageFrame:=F; Root2:=F;
  F:=TSetupFrameCustomLanguageStrings.Create(self); AddTreeNode(Root2,F,TSetupFrameCustomLanguageStrings(F),True,3,False);
  F:=TSetupFrameMenubar.Create(self); AddTreeNode(Root,F,TSetupFrameMenubar(F),True,13);
  F:=TSetupFrameToolbar.Create(self); AddTreeNode(Root,F,TSetupFrameToolbar(F),True,13); ToolbarFrame:=F;
  F:=TSetupFrameGamesListTreeAppearance.Create(self); AddTreeNode(Root,F,TSetupFrameGamesListTreeAppearance(F),True,22); TreeListFrame:=F;
  F:=TSetupFrameGamesListAppearance.Create(self); AddTreeNode(Root,F,TSetupFrameGamesListAppearance(F),True,3); Root2:=F;
  F:=TSetupFrameGamesListColumns.Create(self); AddTreeNode(Root2,F,TSetupFrameGamesListColumns(F),True,3);
  F:=TSetupFrameGamesListScreenshotModeAppearance.Create(self); AddTreeNode(Root2,F,TSetupFrameGamesListScreenshotModeAppearance(F),True,20);
  F:=TSetupFrameGameListIconModeAppearance.Create(self); AddTreeNode(Root2,F,TSetupFrameGameListIconModeAppearance(F),True,21);
  F:=TSetupFrameGamesListScreenshotAppearance.Create(self); AddTreeNode(Root,F,TSetupFrameGamesListScreenshotAppearance(F),True,18);
  F:=TSetupFrameImageScaling.Create(self); AddTreeNode(Root,F,TSetupFrameImageScaling(F),True,18);

  F:=TSetupFrameProfileEditor.Create(self); AddTreeNode(nil,F,TSetupFrameProfileEditor(F),True,8); Root:=F;
  F:=TSetupFrameDefaultValues.Create(self); AddTreeNode(Root,F,TSetupFrameDefaultValues(F),True,6);
  F:=TSetupFrameAutomaticConfiguration.Create(self); AddTreeNode(Root,F,TSetupFrameAutomaticConfiguration(F),True,24);

  F:=TSetupFramePrograms.Create(self); AddTreeNode(nil,F,TSetupFramePrograms(F),False,0,True); Root:=F;
  F:=TSetupFrameDOSBox.Create(self); AddTreeNode(Root,F,TSetupFrameDOSBox(F),False,4); Root2:=F;
  F:=TSetupFrameDOSBoxGlobal.Create(self); AddTreeNode(Root2,F,TSetupFrameDOSBoxGlobal(F),True,4);
  F:=TSetupFrameDOSBoxExt.Create(self); AddTreeNode(Root2,F,TSetupFrameDOSBoxExt(F),True,4);
  F:=TSetupFrameFreeDOS.Create(self); AddTreeNode(Root,F,TSetupFrameFreeDOS(F),False,15,True);
  F:=TSetupFrameQBasic.Create(self); AddTreeNode(Root,F,TSetupFrameQBasic(F),False,11);
  F:=TSetupFrameUserInterpreterFrame.Create(self); AddTreeNode(Root,F,TSetupFrameUserInterpreterFrame(F),True,23);
  F:=TSetupFrameScummVM.Create(self); AddTreeNode(Root,F,TSetupFrameScummVM(F),False,10);
  F:=TSetupFrameMoreEmulators.Create(self); AddTreeNode(Root,F,TSetupFrameMoreEmulators(F),True,23);
  F:=TSetupFrameWaveEncoder.Create(self); AddTreeNode(Root,F,TSetupFrameWaveEncoder(F),False,9,False);
  F:=TSetupFrameZipPrgs.Create(self); AddTreeNode(Root,F,TSetupFrameZipPrgs(F),True,16,False);
  F:=TSetupFrameEditor.Create(self); AddTreeNode(Root,F,TSetupFrameEditor(F),True,17,False);
  F:=TSetupFrameViewer.Create(self); AddTreeNode(Root,F,TSetupFrameViewer(F),True,18,False);
  F:=TSetupFrameWindowsGames.Create(self); AddTreeNode(Root,F,TSetupFrameWindowsGames(F),True,8,False);

  F:=TSetupFrameService.Create(self); AddTreeNode(nil,F,TSetupFrameService(F),False,7,True); Root:=F;
  F:=TSetupFrameUpdate.Create(self); AddTreeNode(Root,F,TSetupFrameUpdate(F),False,14); UpdateFrame:=F;
end;

Procedure TSetupForm.BeforeChangeLanguage;
Var I : Integer;
begin
  For I:=0 to length(Frames)-1 do Frames[I].IFrame.BeforeChangeLanguage;
end;

procedure TSetupForm.LoadLanguage;
Var I : Integer;
begin
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.SetupForm;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  RestoreDefaultValuesButton.Caption:=LanguageSetup.SetupFormDefaultValueReset;
  ModeLabel.Caption:=LanguageSetup.SetupFormMode;
  I:=ModeComboBox.ItemIndex;
  While ModeComboBox.Items.Count<2 do ModeComboBox.Items.Add('');
  ModeComboBox.Items[0]:=LanguageSetup.SetupFormModeEasy;
  ModeComboBox.Items[1]:=LanguageSetup.SetupFormModeAdvanced;
  ModeComboBox.ItemIndex:=Max(0,Min(1,I));

  ModeComboBoxChange(self);

  For I:=0 to length(Frames)-1 do begin
    Frames[I].IFrame.LoadLanguage;
    Frames[I].Frame.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  end;
end;

procedure TSetupForm.DOSBoxDirChanged;
Var I : Integer;
begin
  For I:=0 to length(Frames)-1 do Frames[I].IFrame.DOSBoxDirChanged;
end;

procedure TSetupForm.OpenLanguageEditor(const Mode: Integer);
begin
  LanguageEditorMode:=Mode;
  ModalResult:=mrOK;
  OKButtonClick(self);
end;

function TSetupForm.FindNodeFromFrame(const F: TFrame): TTreeNode;
Var I,Data : Integer;
begin
  result:=nil;
  Data:=-1;

  For I:=0 to length(Frames)-1 do If Frames[I].Frame=F then begin Data:=I; break; end;
  If Data<0 then exit;
  For I:=0 to Tree.Items.Count-1 do If Integer(Tree.Items[I].Data)=Data then begin result:=Tree.Items[I]; exit; end;
end;

procedure TSetupForm.ModeComboBoxChange(Sender: TObject);
Var AdvancedMode : Boolean;
    LastFrame,I : Integer;
    ParentNode,Node,LastNode : TTreeNode;
begin
  If Tree.Selected=nil then LastFrame:=-1 else LastFrame:=Integer(Tree.Selected.Data);
  LastNode:=nil;
  AdvancedMode:=SetAdvanced or (ModeComboBox.ItemIndex=1);
  Tree.Selected:=nil;

  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;

    For I:=0 to length(Frames)-1 do If (not Frames[I].AdvancedModeOnly) or AdvancedMode then begin
      ParentNode:=FindNodeFromFrame(Frames[I].ParentFrame);
      Node:=Tree.Items.AddChildObject(ParentNode,Frames[I].IFrame.GetName,Pointer(I));
      Node.ImageIndex:=Frames[I].ImageIndex;
      Node.SelectedIndex:=Frames[I].ImageIndex;
      If I=LastFrame then LastNode:=Node;
    end;

    For I:=0 to Tree.Items.Count-1 do If Tree.Items[I].Parent=nil then Tree.Items[I].Expand(False);

    If LastNode=nil then LastNode:=Tree.Items[0];
    Tree.Selected:=LastNode;
  finally
    Tree.Items.EndUpdate;
  end;

  If Tree.Selected<>nil then Tree.Selected.MakeVisible;
end;

Procedure TSetupForm.SelectFrame(const Nr : Integer);
begin
  If Nr=-1 then TopPanel.Caption:='' else begin
    Frames[Nr].Frame.Visible:=True;
    Frames[Nr].IFrame.ShowFrame(SetAdvanced or (ModeComboBox.ItemIndex=1));
    TopPanel.Caption:=' '+Frames[Nr].IFrame.GetName;
  end;
end;

procedure TSetupForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  If (Tree.Selected<>nil) and (Integer(Tree.Selected.Data)=VisibleFrame) then exit;

  If VisibleFrame>=0 then begin
    Frames[VisibleFrame].IFrame.HideFrame;
    Frames[VisibleFrame].Frame.Visible:=False;
  end;

  If Tree.Selected=nil then VisibleFrame:=-1 else VisibleFrame:=Integer(Tree.Selected.Data);

  SelectFrame(VisibleFrame);
end;

procedure TSetupForm.PopupClick(Sender: TObject);
Var Nr,I : Integer;
begin
  Nr:=(Sender as TComponent).Tag;
  If Nr=-2 then begin
    If Tree.Selected=nil then exit;
    Nr:=Integer(Tree.Selected.Data);
  end;
  For I:=0 to length(Frames)-1 do If (not Frames[I].IsEmpty) and (Nr=I) or (Nr=-1) then
    Frames[I].IFrame.RestoreDefaults;
end;

procedure TSetupForm.RestoreDefaultValuesButtonClick(Sender: TObject);
Var P : TPoint;
    I : Integer;
    M : tMenuItem;
begin
  while PopupMenu.Items.Count>0 do PopupMenu.Items[0].Free;

  If Tree.Selected<>nil then begin
    {Add "This page" item}
    M:=TMenuItem.Create(PopupMenu);
    with M do begin
      Caption:=LanguageSetup.SetupFormDefaultValueResetThis;
      Tag:=-2;
      ImageIndex:=Frames[Integer(Tree.Selected.Data)].ImageIndex;
      OnClick:=PopupClick;
    end;
    PopupMenu.Items.Add(M);
  end;

  {Add "All" item}
  M:=TMenuItem.Create(PopupMenu);
  with M do begin
    Caption:=LanguageSetup.SetupFormDefaultValueResetAll;
    Tag:=-1;
    OnClick:=PopupClick;
  end;
  PopupMenu.Items.Add(M);

  {Line}
  M:=TMenuItem.Create(PopupMenu); M.Caption:='-'; PopupMenu.Items.Add(M);

  {Add pages}
  For I:=0 to length(Frames)-1 do If not Frames[I].IsEmpty then begin
    If Frames[I].AdvancedModeOnly and (not SetAdvanced) and (ModeComboBox.ItemIndex=0) then continue;
    M:=TMenuItem.Create(PopupMenu);
    with M do begin
      Caption:=Frames[I].IFrame.GetName;
      Tag:=I;
      ImageIndex:=Frames[I].ImageIndex;
      OnClick:=PopupClick;
    end;
    PopupMenu.Items.Add(M);
  end;

  {Open Popup}
  P:=BottomPanel.ClientToScreen(Point(RestoreDefaultValuesButton.Left,RestoreDefaultValuesButton.Top));
  PopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TSetupForm.OKButtonClick(Sender: TObject);
Var I,J : Integer;
    B : Boolean;
begin
  If VisibleFrame>=0 then begin
    Frames[VisibleFrame].IFrame.HideFrame;
    Frames[VisibleFrame].Frame.Visible:=False;
  end;

  For I:=0 to length(Frames)-1 do If Assigned(Frames[I].CloseCheckEvent) then begin
    B:=True; Frames[I].CloseCheckEvent(B); If not B then begin
      SelectFrame(I);
      For J:=0 to Tree.Items.Count-1 do If Integer(Tree.Items[J].Data)=I then begin Tree.Selected:=Tree.Items[I]; break; end;
      ModalResult:=mrNone; exit;
    end;
  end;

  If not SetAdvanced then PrgSetup.EasySetupMode:=(ModeComboBox.ItemIndex=0);
  For I:=0 to length(Frames)-1 do Frames[I].IFrame.SaveSetup;
end;

procedure TSetupForm.HelpButtonClick(Sender: TObject);
Var I : Integer;
begin
  I:=0;
  If VisibleFrame>=0 then I:=Frames[VisibleFrame].Frame.HelpContext;
  If I=0 then I:=ID_FileOptions;
  Application.HelpCommand(HELP_CONTEXT,I);
end;

procedure TSetupForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure OpenLanguageEditor(const AOwner : TComponent; const LanguageEditorMode : Integer);
Var S : String;
begin
  Case SetupForm.LanguageEditorMode of
    1 : begin
          ShowLanguageEditorDialog(AOwner,LanguageSetup.SetupFile);
          LanguageSetup.ReloadINI;
        end;
    2 : if ShowLanguageEditorStartDialog(AOwner,S,True) then begin
          ShowLanguageEditorDialog(AOwner,S);
          If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(LanguageSetup.SetupFile)) then LanguageSetup.ReloadINI;
        end;
  end;
end;

Function ShowSetupDialogSpecial(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const OpenMode : TOpenMode) : Boolean;
begin
  DFendReloadedMainForm.Enabled:=False;
  try
    SetupForm:=TSetupForm.Create(AOwner);
    try
      SetupForm.GameDB:=AGameDB;
      SetupForm.SearchLinkFile:=ASearchLinkFile;
      If OpenMode<>omNormal then SetupForm.OpenMode:=OpenMode;
      If (OpenMode<>omNormal) and (OpenMode<>omLanguage) and (OpenMode<>omIconSet) and (OpenMode<>omUpdate) then SetupForm.SetAdvanced:=True;
      result:=(SetupForm.ShowModal=mrOK);
      if not result then LoadLanguage(PrgSetup.Language);
      If result and (SetupForm.LanguageEditorMode>0) then OpenLanguageEditor(AOwner,SetupForm.LanguageEditorMode);
    finally
      SetupForm.Free;
    end;
  finally
    DFendReloadedMainForm.Enabled:=True;
  end;
end;

Function ShowSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const OpenLanguageTab : Boolean) : Boolean;
begin
  If OpenLanguageTab
    then result:=ShowSetupDialogSpecial(AOwner,AGameDB,ASearchLinkFile,omLanguage)
    else result:=ShowSetupDialogSpecial(AOwner,AGameDB,ASearchLinkFile,omNormal);
end;

Function ShowTreeListSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  result:=ShowSetupDialogSpecial(AOwner,AGameDB,ASearchLinkFile,omTreeList);
end;

Function ShowToolbarSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  result:=ShowSetupDialogSpecial(AOwner,AGameDB,ASearchLinkFile,omToolbar);
end;

Function ShowIconSetSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  result:=ShowSetupDialogSpecial(AOwner,AGameDB,ASearchLinkFile,omIconSet);
end;

Function ShowUpdateSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  result:=ShowSetupDialogSpecial(AOwner,AGameDB,ASearchLinkFile,omUpdate);
end;

end.
