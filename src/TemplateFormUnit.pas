unit TemplateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, Menus, GameDBUnit, GameDBToolsUnit,
  LinkFileUnit;

type
  TTemplateForm = class(TForm)
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    PopupUse: TMenuItem;
    N1: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDel: TMenuItem;
    ListViewImageList: TImageList;
    UsePopupMenu: TPopupMenu;
    PopupUseProfile: TMenuItem;
    PopupUseDefault: TMenuItem;
    PopupUseProfile2: TMenuItem;
    PopupUseDefault2: TMenuItem;
    AddPopupMenu: TPopupMenu;
    PopupAddNew: TMenuItem;
    PopupAddFromProfile: TMenuItem;
    PopupCopy: TMenuItem;
    ListviewIconImageList: TImageList;
    PageControl: TPageControl;
    TemplateTab: TTabSheet;
    ListView: TListView;
    AutoSetupSheet: TTabSheet;
    ListView2: TListView;
    AddPopupMenu2: TPopupMenu;
    PopupAddNew2: TMenuItem;
    PopupAddFromProfile2: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupEdit2: TMenuItem;
    PopupCopy2: TMenuItem;
    PopupDel2: TMenuItem;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuFileUse: TMenuItem;
    N2: TMenuItem;
    MenuFileClose: TMenuItem;
    MenuEdit: TMenuItem;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton7: TToolButton;
    UseButton: TToolButton;
    ToolButton3: TToolButton;
    AddButton: TToolButton;
    EditButton: TToolButton;
    DeleteButton: TToolButton;
    CoolBar1: TCoolBar;
    ToolBar2: TToolBar;
    CloseButton2: TToolButton;
    ToolButton2: TToolButton;
    AddButton2: TToolButton;
    EditButton2: TToolButton;
    DeleteButton2: TToolButton;
    MenuFileUseAsProfile: TMenuItem;
    MenuFileUseAsDefault: TMenuItem;
    MenuEditAdd: TMenuItem;
    MenuEditEdit: TMenuItem;
    MenuEditEditMultipleTemplates: TMenuItem;
    MenuEditDelete2: TMenuItem;
    MenuEditAdd2: TMenuItem;
    MenuEditEdit2: TMenuItem;
    MenuEditDelete: TMenuItem;
    MenuEditEditMultipleTemplates2: TMenuItem;
    MenuEditAddNewTemplate: TMenuItem;
    MenuEditAddTemplateFromProfile: TMenuItem;
    MenuEditAdd2NewTemplate: TMenuItem;
    MenuEditAdd2TemplateFromProfile: TMenuItem;
    HelpButton2: TToolButton;
    HelpButton: TToolButton;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    MenuHelp: TMenuItem;
    MenuHelpHelp: TMenuItem;
    MenuEditCopy: TMenuItem;
    MenuEditCopy2: TMenuItem;
    N3: TMenuItem;
    MenuEditCheck: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView2ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListView2DblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    TemplateDB, AutoSetupDB : TGameDB;
    DefaultTemplate : TGame;
    ListSort, ListSort2 : TSortListBy;
    ListSortReverse, ListSortReverse2 : Boolean;
    Procedure LoadList;
    Procedure LoadList2;
    procedure SelectGame(const AGame: TGame; const AGameName : String);
    procedure SelectGame2(const AGame: TGame);
    Procedure DoubleChecksumCheck;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Template : TGame;
    TemplateScummVM : Boolean;
    SearchLinkFile : TLinkFile;
    DeleteOnExit : TStringList;
  end;

var
  TemplateForm: TTemplateForm;

Function ShowTemplateDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList) : TGame;

Procedure RemoveNonAutoSetupValues(const G : TGame);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     ProfileEditorFormUnit, PrgSetupUnit, TemplateSelectProfileFormUnit,
     ModernProfileEditorFormUnit, SelectProfilesFormUnit,
     HelpConsts, IconLoaderUnit, WaitFormUnit, StatisticsFormUnit,
     MultipleProfilesEditorFormUnit;

{$R *.dfm}

procedure TTemplateForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  DoubleBuffered:=True;
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(PageControl);
  NoFlicker(ToolBar);
  NoFlicker(ListView);

  ListSort:=slbName;
  ListSortReverse:=False;
  ListSort2:=slbName;
  ListSortReverse2:=False;

  Template:=nil;
  TemplateScummVM:=False;

  Caption:=LanguageSetup.TemplateForm;
  TemplateTab.Caption:=LanguageSetup.TemplateForm;
  AutoSetupSheet.Caption:=LanguageSetup.TemplateFormAutoSetupCaption;

  CoolBar.Font.Size:=PrgSetup.ToolbarFontSize;

  { Menu }

  MenuFile.Caption:=LanguageSetup.MenuFile;
  MenuFileUseAsProfile.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  MenuFileUseAsDefault.Caption:=LanguageSetup.TemplateFormUseAsDefault;
  MenuFileUse.Caption:=LanguageSetup.Use;
  MenuFileClose.Caption:=LanguageSetup.Close;
  MenuEdit.Caption:=LanguageSetup.Edit;
  MenuEditAdd.Caption:=LanguageSetup.MenuProfileAdd;
  MenuEditAddNewTemplate.Caption:=LanguageSetup.TemplateFormNewTemplate;
  MenuEditAddTemplateFromProfile.Caption:=LanguageSetup.TemplateFormNewFromProfile;
  MenuEditAdd2.Caption:=LanguageSetup.MenuProfileAdd;
  MenuEditAdd2NewTemplate.Caption:=LanguageSetup.TemplateFormNewTemplate;
  MenuEditAdd2TemplateFromProfile.Caption:=LanguageSetup.TemplateFormNewFromProfile;
  MenuEditEdit.Caption:=LanguageSetup.MenuProfileEdit;
  MenuEditEdit2.Caption:=LanguageSetup.MenuProfileEdit;
  MenuEditCopy.Caption:=LanguageSetup.TemplateFormCopy;
  MenuEditCopy2.Caption:=LanguageSetup.TemplateFormCopy;
  MenuEditEditMultipleTemplates.Caption:=LanguageSetup.TemplateFormEditMultipleTemplates;
  MenuEditEditMultipleTemplates2.Caption:=LanguageSetup.TemplateFormEditMultipleTemplates;
  MenuEditDelete.Caption:=LanguageSetup.Del;
  MenuEditDelete2.Caption:=LanguageSetup.Del;
  MenuEditCheck.Caption:=LanguageSetup.TemplateFormEditCheckChecksums;
  MenuHelp.Caption:=LanguageSetup.MenuHelp;
  MenuHelpHelp.Caption:=LanguageSetup.Help;

  { Template sheet }

  CloseButton.Caption:=LanguageSetup.Close;
  CloseButton.Hint:=LanguageSetup.CloseHintWindow;

  UseButton.Caption:=LanguageSetup.Use;
  UseButton.Hint:=LanguageSetup.UseHintTemplate;
  PopupUseProfile2.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  PopupUseDefault2.Caption:=LanguageSetup.TemplateFormUseAsDefault;
  AddButton.Caption:=LanguageSetup.Add;
  AddButton.Hint:=LanguageSetup.AddHintTemplate;
  EditButton.Caption:=LanguageSetup.Edit;
  EditButton.Hint:=LanguageSetup.EditHintTemplate;
  DeleteButton.Caption:=LanguageSetup.Del;
  DeleteButton.Hint:=LanguageSetup.DelHintTemplate;
  HelpButton.Caption:=LanguageSetup.Help;
  HelpButton.Hint:=LanguageSetup.HelpHint;

  PopupUse.Caption:=LanguageSetup.Use;
  PopupUseProfile.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  PopupUseDefault.Caption:=LanguageSetup.TemplateFormUseAsDefault;
  PopupEdit.Caption:=LanguageSetup.MenuProfileEdit;
  PopupCopy.Caption:=LanguageSetup.TemplateFormCopy;
  PopupDel.Caption:=LanguageSetup.Del;

  PopupUseProfile2.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  PopupUseDefault2.Caption:=LanguageSetup.TemplateFormUseAsDefault;

  PopupAddNew.Caption:=LanguageSetup.TemplateFormNewTemplate;
  PopupAddFromProfile.Caption:=LanguageSetup.TemplateFormNewFromProfile;

  { AutoSetup sheet }

  CloseButton2.Caption:=LanguageSetup.Close;
  CloseButton2.Hint:=LanguageSetup.CloseHintWindow;

  AddButton2.Caption:=LanguageSetup.Add;
  AddButton2.Hint:=LanguageSetup.AddHintTemplate;
  EditButton2.Caption:=LanguageSetup.Edit;
  EditButton2.Hint:=LanguageSetup.EditHintTemplate;
  DeleteButton2.Caption:=LanguageSetup.Del;
  DeleteButton2.Hint:=LanguageSetup.DelHintTemplate;
  HelpButton2.Caption:=LanguageSetup.Help;
  HelpButton2.Hint:=LanguageSetup.HelpHint;

  PopupEdit2.Caption:=LanguageSetup.MenuProfileEdit;
  PopupCopy2.Caption:=LanguageSetup.TemplateFormCopy;
  PopupDel2.Caption:=LanguageSetup.Del;

  PopupAddNew2.Caption:=LanguageSetup.TemplateFormNewTemplate;
  PopupAddFromProfile2.Caption:=LanguageSetup.TemplateFormNewFromProfile;

  { Init lists }

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  PrgSetup.UpdateFile;
  DefaultTemplate:=TGame.Create(PrgSetup);
  If DefaultTemplate.Name<>'' then DefaultTemplate.Name:='';

  UserIconLoader.DialogImage(DI_ImageFloppy,ImageList,0);
  UserIconLoader.DialogImage(DI_CloseWindow,ImageList,1);
  UserIconLoader.DialogImage(DI_UseTemplate,ImageList,2);
  UserIconLoader.DialogImage(DI_Add,ImageList,3);
  UserIconLoader.DialogImage(DI_Edit,ImageList,4);
  UserIconLoader.DialogImage(DI_Clear,ImageList,5);
  UserIconLoader.DialogImage(DI_ToolbarHelp,ImageList,6);

  InitListViewForGamesList(ListView,True);
  InitListViewForGamesList(ListView2,True);
  LoadList;
  LoadList2;
  PageControlChange(Sender);
end;

procedure TTemplateForm.FormDestroy(Sender: TObject);
begin
  TemplateDB.Free;
  AutoSetupDB.Free;
  DefaultTemplate.Free;
end;

procedure TTemplateForm.SelectGame(const AGame: TGame; const AGameName : String);
Var I : Integer;
begin
  If AGame<>nil then begin
    For I:=0 to ListView.Items.Count-1 do If TGame(ListView.Items[I].Data)=AGame then begin ListView.Selected:=ListView.Items[I]; break; end;
  end else If AGameName<>'' then begin
    For I:=0 to ListView.Items.Count-1 do If (TGame(ListView.Items[I].Data)=DefaultTemplate) and (ListView.Items[I].Caption=AGameName) then begin ListView.Selected:=ListView.Items[I]; break; end;
  end;
  ListViewSelectItem(self,ListView.Selected,ListView.Selected<>nil);
end;

procedure TTemplateForm.SelectGame2(const AGame: TGame);
Var I : Integer;
begin
  For I:=0 to ListView2.Items.Count-1 do If TGame(ListView2.Items[I].Data)=AGame then begin ListView2.Selected:=ListView2.Items[I]; break; end;
  ListView2SelectItem(self,ListView2.Selected,ListView2.Selected<>nil);
end;

procedure TTemplateForm.LoadList;
Var G, OldDefaultTemplate : TGame;
    GName : String;
begin
  OldDefaultTemplate:=DefaultTemplate;
  DefaultTemplate.Free;
  DefaultTemplate:=TGame.Create(PrgSetup);

  ListView.Items.BeginUpdate;
  try
    If ListView.Selected<>nil then begin
      G:=TGame(ListView.Selected.Data);
      If G=OldDefaultTemplate then begin G:=nil; GName:=ListView.Selected.Caption; end else GName:='';
    end else begin
      G:=nil;
      GName:='';
    end;
    AddGamesToList(ListView,ListViewImageList,ListViewIconImageList,ImageList,TemplateDB,DefaultTemplate,RemoveUnderline(LanguageSetup.All),'','',True,ListSort,ListSortReverse,False,False,False,False);
    SelectGame(G,GName);
    If (ListView.Selected=nil) and (ListView.Items.Count>0) then ListView.Selected:=ListView.Items[0];

    StatusBar.Panels[0].Text:=IntToStr(ListView.Items.Count)+' '+LanguageSetup.StatisticsNumberTemplates;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TTemplateForm.LoadList2;
Var G : TGame;
begin
  ListView2.Items.BeginUpdate;
  try
    If ListView2.Selected<>nil then G:=TGame(ListView2.Selected.Data) else G:=nil;
    AddGamesToList(ListView2,ListViewImageList,ListViewIconImageList,ImageList,AutoSetupDB,RemoveUnderline(LanguageSetup.All),'','',True,ListSort2,ListSortReverse2,False,False,False,False);
    SelectGame2(G);
    If (ListView2.Selected=nil) and (ListView2.Items.Count>0) then ListView2.Selected:=ListView2.Items[0];

    StatusBar.Panels[1].Text:=IntToStr(ListView2.Items.Count)+' '+LanguageSetup.StatisticsNumberAutoSetupTemplates;
  finally
    ListView2.Items.EndUpdate;
  end;
end;

procedure TTemplateForm.PageControlChange(Sender: TObject);
begin
  CoolBar.Visible:=(PageControl.ActivePageIndex=0);
  CoolBar1.Visible:=(PageControl.ActivePageIndex=1);

  MenuFileUse.Visible:=CoolBar.Visible;
  MenuEditAdd.Visible:=CoolBar.Visible;
  MenuEditEdit.Visible:=CoolBar.Visible;
  MenuEditCopy.Visible:=CoolBar.Visible;
  MenuEditEditMultipleTemplates.Visible:=CoolBar.Visible;
  MenuEditDelete.Visible:=CoolBar.Visible;

  MenuEditAdd2.Visible:=CoolBar1.Visible;
  MenuEditEdit2.Visible:=CoolBar1.Visible;
  MenuEditCopy2.Visible:=CoolBar1.Visible;
  MenuEditEditMultipleTemplates2.Visible:=CoolBar1.Visible;
  MenuEditDelete2.Visible:=CoolBar1.Visible;
  MenuEditCheck.Visible:=CoolBar1.Visible;
end;

procedure TTemplateForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B,B2,ScummVM : Boolean;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  B2:=B and (TGame(Item.Data)<>DefaultTemplate);
  If B and (not B2) then begin
    ScummVM:=(TGame(ListView.Selected.Data)=DefaultTemplate) and (ListView.Selected.Caption<>LanguageSetup.TemplateFormDefault);
  end else begin
    ScummVM:=False;
  end;

  UseButton.Enabled:=B;
  EditButton.Enabled:=B;
  DeleteButton.Enabled:=B2;

  PopupUse.Enabled:=B;
  PopupEdit.Enabled:=B;
  PopupCopy.Enabled:=B and (not ScummVM);
  PopupDel.Enabled:=B2;

  PopupUseDefault.Enabled:=B2;
  PopupUseDefault2.Enabled:=B2;

  MenuFileUse.Enabled:=B;
  MenuFileUseAsDefault.Enabled:=B2;
  MenuEditEdit.Enabled:=B;
  MenuEditCopy.Enabled:=B and (not ScummVM);
  MenuEditDelete.Enabled:=B2;
end;

procedure TTemplateForm.ListView2SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  EditButton2.Enabled:=B;
  DeleteButton2.Enabled:=B;

  PopupEdit2.Enabled:=B;
  PopupCopy2.Enabled:=B;
  PopupDel2.Enabled:=B;

  MenuEditEdit2.Enabled:=B;
  MenuEditCopy2.Enabled:=B;
  MenuEditDelete2.Enabled:=B;
end;

procedure TTemplateForm.ListViewAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  DefaultDraw:=True;
  If (Item<>nil) and (Item.Data<>nil) and (TGame(Item.Data)=DefaultTemplate) then TListview(Sender).Canvas.Font.Color:=clBlue else TListview(Sender).Canvas.Font.Color:=clWindowText;
end;

procedure TTemplateForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort,ListSortReverse);
  LoadList;
end;

procedure TTemplateForm.ListViewDblClick(Sender: TObject);
Var Key : Word;
begin
  Key:=VK_F2;
  ListViewKeyDown(Sender,Key,[]);
end;

procedure TTemplateForm.ListView2ColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort2,ListSortReverse2);
  LoadList2;
end;

procedure TTemplateForm.ListView2DblClick(Sender: TObject);
Var Key : Word;
begin
  Key:=VK_F2;
  ListView2KeyDown(Sender,Key,[]);
end;

procedure TTemplateForm.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin ButtonWork(EditButton); exit; end;
  if Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(AddButton);
    VK_DELETE : ButtonWork(DeleteButton);
    VK_F2     : ButtonWork(EditButton);
  end;
end;

procedure TTemplateForm.ListView2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin ButtonWork(EditButton2); exit; end;
  if Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(AddButton2);
    VK_DELETE : ButtonWork(DeleteButton2);
    VK_F2     : ButtonWork(EditButton2);
  end;
end;

procedure TTemplateForm.ButtonWork(Sender: TObject);
Var G,G2 : TGame;
    GName : String;
    P : TPoint;
    S : String;
    L,L2 : TList;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          {Template: Use button}
          P:=ToolBar.ClientToScreen(Point(UseButton.Left+5,UseButton.Top+5));
          UsePopupMenu.Popup(P.X,P.Y);
        end;
    2 : begin
          {Template: Add button}
          P:=ToolBar.ClientToScreen(Point(AddButton.Left+5,AddButton.Top+5));
          AddPopupMenu.Popup(P.X,P.Y);
        end;
    3 : begin
          {Template: Edit button}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          {Because "Default template" and "Default ScummVM template" are the same object, cannot handle them in one list, IndexOf will not find the right one}
          If TGame(ListView.Selected.Data)=DefaultTemplate then begin
            {Default template or ScummVM default template}
            L:=TList.Create;
            L2:=TList.Create;
            try
              G:=TGame(ListView.Selected.Data);
              L.Add(G);
              If ListView.Selected.Caption=LanguageSetup.TemplateFormDefault then L2.Add(Pointer(1)) else L2.Add(Pointer(2));
              GName:=ListView.Selected.Caption;
              If PrgSetup.DFendStyleProfileEditor then begin
                if not EditGameTemplate(self,TemplateDB,G,nil,SearchLinkFile,DeleteOnExit,L,L2) then exit;
              end else begin
                if not ModernEditGameTemplate(self,TemplateDB,G,nil,SearchLinkFile,DeleteOnExit,L,L2) then exit;
              end;
              G.LoadCache;
              LoadList;
              SelectGame(nil,GName);
            finally
              L.Free;
              L2.Free;
            end;
          end else begin
            {Normal template}
            L:=TList.Create;
            try
              For I:=0 to ListView.Items.Count-1 do begin
                If TGame(ListView.Items[I].Data)=DefaultTemplate then continue;
                L.Add(ListView.Items[I].Data);
              end;
              G:=TGame(ListView.Selected.Data);
              If PrgSetup.DFendStyleProfileEditor then begin
                if not EditGameTemplate(self,TemplateDB,G,nil,SearchLinkFile,DeleteOnExit,L,nil) then exit;
              end else begin
                if not ModernEditGameTemplate(self,TemplateDB,G,nil,SearchLinkFile,DeleteOnExit,L,nil) then exit;
              end;
              G.LoadCache;
              LoadList;
              SelectGame(G,'');
            finally
              L.Free;
            end;
          end;
        end;
    4 : begin
          {Template: Delete buton}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          If PrgSetup.AskBeforeDelete then begin
            if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecord,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end;
          if not TemplateDB.Delete(G) then exit;
          LoadList;
        end;
    5 : begin
          {Template: Use for new profile}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
             MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
           end;
           Template:=TGame(ListView.Selected.Data);
           TemplateScummVM:=(TGame(ListView.Selected.Data)=DefaultTemplate) and (ListView.Selected.Caption<>LanguageSetup.TemplateFormDefault);
           Close;
        end;
    6 : begin
          {Template: Use a new default template}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
             MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
           end;
           DefaultTemplate.AssignFromButKeepScummVMSettings(TGame(ListView.Selected.Data));
           DefaultTemplate.Name:='';
           LoadList;
        end;
    7 : begin
          {Template: Add new}
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameTemplate(self,TemplateDB,G,DefaultTemplate,SearchLinkFile,DeleteOnExit) then exit;
          end else begin
            if not ModernEditGameTemplate(self,TemplateDB,G,DefaultTemplate,SearchLinkFile,DeleteOnExit) then exit;
          end;
          G.LoadCache;
          LoadList;
          SelectGame(G,'');
        end;
    8 : begin
          {Template: Add from profile}
          G2:=SelectProfile(self,GameDB);
          If G2=nil then exit;
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameTemplate(self,TemplateDB,G,G2,SearchLinkFile,DeleteOnExit) then exit;
          end else begin
            if not ModernEditGameTemplate(self,TemplateDB,G,G2,SearchLinkFile,DeleteOnExit) then exit;
          end;
          G.LoadCache;
          LoadList;
          SelectGame(G,'');
        end;
    9 : begin
          {Template: Copy}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          If (TGame(ListView.Selected.Data)=DefaultTemplate) and (ListView.Selected.Caption<>LanguageSetup.TemplateFormDefault) then exit;
          S:=TGame(ListView.Selected.Data).CacheName;
          If not InputQuery(LanguageSetup.MenuProfileCopyTitle,LanguageSetup.MenuProfileCopyPrompt,S) then exit;
          G:=TemplateDB[TemplateDB.Add(S)];
          G.AssignFrom(TGame(ListView.Selected.Data));
          G.Name:=S;
          G.LoadCache;
          G.StoreAllValues;
          LoadList;
          SelectGame(G,'');
        end;
   10 : begin
          {AutoSetup: Add button}
          P:=ToolBar.ClientToScreen(Point(AddButton2.Left+5,AddButton2.Top+5));
          AddPopupMenu2.Popup(P.X,P.Y);
        end;
   11 : begin
          {AutoSetup: Edit button}
          If (ListView2.Selected=nil) or (ListView2.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          L:=TList.Create;
          try
            For I:=0 to ListView2.Items.Count-1 do L.Add(ListView2.Items[I].Data);
            G:=TGame(ListView2.Selected.Data);
            If PrgSetup.DFendStyleProfileEditor then begin
              if not EditGameTemplate(self,AutoSetupDB,G,nil,SearchLinkFile,DeleteOnExit,L) then exit;
            end else begin
              if not ModernEditGameTemplate(self,AutoSetupDB,G,nil,SearchLinkFile,DeleteOnExit,L) then exit;
            end;
            G.LoadCache;
            LoadList2;
            SelectGame2(G);
          finally
            L.Free;
          end;
        end;
   12 : begin
          {AutoSetup: Del button}
          If (ListView2.Selected=nil) or (ListView2.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView2.Selected.Data);
          If PrgSetup.AskBeforeDelete then begin
            if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecord,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end;
          if not AutoSetupDB.Delete(G) then exit;
          LoadList2;
        end;
   13 : begin
          {AutoSetup: Add new}
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameTemplate(self,AutoSetupDB,G,DefaultTemplate,SearchLinkFile,DeleteOnExit) then exit;
          end else begin
            if not ModernEditGameTemplate(self,AutoSetupDB,G,DefaultTemplate,SearchLinkFile,DeleteOnExit) then exit;
          end;
          G.LoadCache;
          LoadList2;
          SelectGame2(G);
        end;
   14 : begin
          {AutoSetup: Add from profile}
          if not ShowSelectProfilesDialog(self,GameDB,L) then exit;
          try
            For I:=0 to L.Count-1 do begin
              {Create Checksums if there are none}
              CreateGameCheckSum(TGame(L[I]),False);
              CreateSetupCheckSum(TGame(L[I]),False);
              AddAdditionalChecksumDataToAutoSetupTemplate(TGame(L[I]));

              {Copy to template}
              G:=AutoSetupDB[AutoSetupDB.Add(TGame(L[I]).Name)];
              G.AssignFrom(TGame(L[I]));

              {Delete not template-useable values}
              RemoveNonAutoSetupValues(G);
              G.LoadCache;
              G.StoreAllValues;
            end;
            LoadList2;
            SelectGame2(G);
          finally
            L.Free;
          end;
        end;
   15 : begin
          {AutoSetup: Copy}
          If (ListView2.Selected=nil) or (ListView2.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          S:=TGame(ListView2.Selected.Data).CacheName;
          If not InputQuery(LanguageSetup.MenuProfileCopyTitle,LanguageSetup.MenuProfileCopyPrompt,S) then exit;
          G:=AutoSetupDB[AutoSetupDB.Add(S)];
          G.AssignFrom(TGame(ListView2.Selected.Data));
          G.Name:=S;
          G.LoadCache;
          G.StoreAllValues;
          LoadList2;
          SelectGame2(G);
        end;
   16 : begin
          {Template: Multi edit}
          If not ShowMultipleProfilesEditorDialog(self,TemplateDB,True) then exit;
          If ListView.Selected=nil then begin G:=nil; GName:=''; end else begin
            G:=TGame(ListView.Selected.Data);
            If G=DefaultTemplate then begin G:=nil; GName:=ListView.Selected.Caption; end else GName:='';
          end;
          LoadList;
          SelectGame(G,GName);
        end;
   17 : begin
          {AutoSetup: Multi edit}
          If not ShowMultipleProfilesEditorDialog(self,AutoSetupDB,True) then exit;
          If ListView2.Selected=nil then G:=nil else G:=TGame(ListView2.Selected.Data);
          LoadList2;
          SelectGame2(G);
        end;
   18 : Application.HelpCommand(HELP_CONTEXT,ID_ExtrasTemplates);
   19 : begin
          {AutoSetup: Check for duplicate checksums}
          DoubleChecksumCheck;
        end;
  end;
end;

procedure TTemplateForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then ButtonWork(HelpButton);
end;

{ global }

Procedure RemoveNonAutoSetupValues(const G : TGame);
Var S,T : String;
begin
  If Trim(G.GameExe)<>'' then G.GameExe:=ExtractFileName(G.GameExe);
  If Trim(G.SetupExe)<>'' then G.SetupExe:=ExtractFileName(G.SetupExe);
  G.CaptureFolder:='';
  G.DataDir:='';
  G.ExtraDirs:='';
  G.ExtraFiles:='';
  G.CustomDOSBoxDir:='';

  If Trim(G.Icon)<>'' then begin
    S:=ExtUpperCase(MakeAbsPath(G.Icon,PrgSetup.BaseDir));
    T:=ExtUpperCase(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
    If Copy(S,1,length(T))=T then G.Icon:='';
  end;
end;

Function ShowTemplateDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList) : TGame;
begin
  result:=nil;
  TemplateForm:=TTemplateForm.Create(AOwner);
  try
    TemplateForm.GameDB:=AGameDB;
    TemplateForm.SearchLinkFile:=ASearchLinkFile;
    TemplateForm.DeleteOnExit:=ADeleteOnExit;
    TemplateForm.ShowModal;
    if TemplateForm.Template=nil then exit;

    If TemplateForm.TemplateScummVM then TemplateForm.Template.ProfileMode:='ScummVM';
    try
      If PrgSetup.DFendStyleProfileEditor and (not TemplateForm.TemplateScummVM) then begin
        EditGameProfil(AOwner,AGameDB,result,TemplateForm.Template,ASearchLinkFile,ADeleteOnExit,'','');
      end else begin
        ModernEditGameProfil(AOwner,AGameDB,result,TemplateForm.Template,ASearchLinkFile,ADeleteOnExit,'','');
      end;
    finally
      If TemplateForm.TemplateScummVM then TemplateForm.Template.ProfileMode:='DOSBox';
    end;
  finally
    TemplateForm.Free;
  end;
end;

procedure TTemplateForm.DoubleChecksumCheck;
Var Checksums, Templates, Empty, NotUnique, St : TStringList;
    I,J : Integer;
    S : String;
    WaitForm : TWaitForm;
begin
  Checksums:=TStringList.Create;
  Templates:=TStringList.Create;
  Empty:=TStringList.Create;
  NotUnique:=TStringList.Create;
  try
    If AutoSetupDB.Count>50 then WaitForm:=CreateWaitForm(self,LanguageSetup.TemplateFormEditCheckChecksumsCheckingDB,AutoSetupDB.Count) else WaitForm:=nil;
    try
      For I:=0 to AutoSetupDB.Count-1 do begin
        If Assigned(WaitForm) and ((I mod 10)=0) then WaitForm.Step(I);
        If Trim(AutoSetupDB[I].GameExe)='' then continue;
        S:=AutoSetupDB[I].GameExeMD5;
        If S='' then begin Empty.Add(AutoSetupDB[I].CacheName); continue; end;
        J:=Checksums.IndexOf(S);
        If J<0 then begin
          Checksums.Add(S);
          Templates.Add(AutoSetupDB[I].CacheName);
        end else begin
          If Trim(AutoSetupDB[I].AddtionalChecksumFile1Checksum)<>'' then continue;
          If Trim(AutoSetupDB[I].AddtionalChecksumFile2Checksum)<>'' then continue;
          If Trim(AutoSetupDB[I].AddtionalChecksumFile3Checksum)<>'' then continue;
          If Trim(AutoSetupDB[I].AddtionalChecksumFile4Checksum)<>'' then continue;
          If Trim(AutoSetupDB[I].AddtionalChecksumFile5Checksum)<>'' then continue;
          NotUnique.Add(AutoSetupDB[I].CacheName+' '+Format(LanguageSetup.TemplateFormEditCheckChecksumsSameChecksum,[Templates[J]]));
        end;
      end;
    finally
      If Assigned(WaitForm) then FreeAndNil(WaitForm);
    end;
    If Empty.Count+NotUnique.Count=0 then begin
      MessageDlg(LanguageSetup.TemplateFormEditCheckChecksumsMessageOK,mtInformation,[mbOK],0);
    end else begin
      St:=TStringList.Create;
      try
        If Empty.Count>0 then begin
          St.Add(LanguageSetup.TemplateFormEditCheckChecksumsHeadingMissingChecksums);
          St.AddStrings(Empty);
          St.Add('');
        end;
        St.Add(LanguageSetup.TemplateFormEditCheckChecksumsHeadingNonUniqueChecksums);
        St.AddStrings(NotUnique);
        ShowInfoTextDialog(self,LanguageSetup.TemplateFormEditCheckChecksumsWarningTitle,St,True);
      finally
        St.Free;
      end;
    end;
  finally
    Checksums.Free;
    Templates.Free;
    Empty.Free;
    NotUnique.Free;
  end;
end;

end.
