unit ResetProfilesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, StdCtrls, Buttons, CheckLst, ComCtrls, GameDBUnit,
  LinkFileUnit;

type
  TResetProfilesForm = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    InfoLabel1: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    TabSheet2: TTabSheet;
    ScrollBox: TScrollBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    PopupMenu: TPopupMenu;
    TabSheet3: TTabSheet;
    ListBox2: TCheckListBox;
    SelectAllButton2: TBitBtn;
    SelectNoneButton2: TBitBtn;
    InfoLabel2: TLabel;
    RadioButtonTemplate: TRadioButton;
    ComboBoxTemplate: TComboBox;
    RadioButtonAutoSetup: TRadioButton;
    ComboBoxAutoSetup: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    TemplateDB, AutoSetupDB : TGameDB;
    Procedure BuildSettingsList;
    Procedure BuildTemplateList;
    Procedure ResetGame(const Game, Template : TGame);
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    SearchLinkFile : TLinkFile;
  end;

var
  ResetProfilesForm: TResetProfilesForm;

Function ShowResetProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit,
     PrgSetupUnit, PrgConsts, GameDBToolsUnit, ModernProfileEditorFormUnit,
     HelpConsts;

{$R *.dfm}

procedure TResetProfilesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);

  PageControl.ActivePageIndex:=0;
end;

procedure TResetProfilesForm.FormDestroy(Sender: TObject);
begin
  TemplateDB.Free;
  AutoSetupDB.Free;
end;

procedure TResetProfilesForm.FormShow(Sender: TObject);
begin
  Caption:=LanguageSetup.ResetProfiles;
  TabSheet1.Caption:=LanguageSetup.ResetProfilesProfiles;
  InfoLabel1.Caption:=LanguageSetup.ResetProfilesProfilesInfo;
  TabSheet2.Caption:=LanguageSetup.ResetProfilesSettings;
  InfoLabel2.Caption:=LanguageSetup.ResetProfilesSettingsInfo;
  TabSheet3.Caption:=LanguageSetup.ResetProfilesTemplate;
  RadioButtonTemplate.Caption:=LanguageSetup.ResetProfilesTemplateTemplate;
  RadioButtonAutoSetup.Caption:=LanguageSetup.ResetProfilesTemplateAutoSetup;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  SelectAllButton2.Caption:=LanguageSetup.All;
  SelectNoneButton2.Caption:=LanguageSetup.None;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);
  BuildSettingsList;
  BuildTemplateList;
end;

procedure TResetProfilesForm.SelectButtonClick(Sender: TObject);
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
      3,4: For I:=0 to ListBox2.Count-1 do ListBox2.Checked[I]:=((Sender as TComponent).Tag=3);
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

Procedure TResetProfilesForm.BuildSettingsList;
Var I : Integer;
    DefaultTemplate : TGame;
    N : TTreeNode;
    S : String;
begin
  ModernProfileEditorForm:=TModernProfileEditorForm.Create(self);
  try
    ModernProfileEditorForm.GameDB:=GameDB;
    DefaultTemplate:=TGame.Create(PrgSetup);
    try
      ModernProfileEditorForm.SearchLinkFile:=SearchLinkFile;
      ModernProfileEditorForm.Game:=DefaultTemplate;
      ModernProfileEditorForm.InitGUI;
      For I:=0 to length(ModernProfileEditorForm.FrameList)-1 do if ModernProfileEditorForm.FrameList[I].AllowDefaultValueReset then begin
        N:=ModernProfileEditorForm.FrameList[I].TreeNode;
        S:='';
        While N<>nil do begin
          If S<>'' then S:=' - '+S;
          S:=N.Text+S;
          N:=N.Parent;
        end;
        ListBox2.Items.Add(S);
      end;
    finally
      DefaultTemplate.Free;
    end;
  finally
    ModernProfileEditorForm.Free;
  end;
end;

procedure TResetProfilesForm.BuildTemplateList;
Var St : TStringList;
    I : Integer;
begin
  St:=TStringList.Create;
  try
    St.AddObject(LanguageSetup.TemplateFormDefault,nil);
    For I:=0 to TemplateDB.Count-1 do St.AddObject(TemplateDB[I].CacheName,TemplateDB[I]);
    St.Sort;
    ComboBoxTemplate.Items.AddStrings(St);

    St.Clear;

    For I:=0 to AutoSetupDB.Count-1 do St.AddObject(AutoSetupDB[I].CacheName,AutoSetupDB[I]);
    St.Sort;
    ComboBoxAutoSetup.Items.AddStrings(St);
  finally
    St.Free;
  end;

  For I:=0 to ComboBoxTemplate.Items.Count-1 do if ComboBoxTemplate.Items.Objects[I]=nil then begin
    ComboBoxTemplate.ItemIndex:=I; break;
  end;
  if (ComboBoxAutoSetup.Items.Count>0) then ComboBoxAutoSetup.ItemIndex:=0;
end;

procedure TResetProfilesForm.ComboBoxChange(Sender: TObject);
begin
  RadioButtonTemplate.Checked:=(Sender=ComboBoxTemplate);
  RadioButtonAutoSetup.Checked:=(Sender=ComboBoxAutoSetup);
end;

procedure TResetProfilesForm.ResetGame(const Game, Template: TGame);
Var I,C : Integer;
begin
  ModernProfileEditorForm:=TModernProfileEditorForm.Create(self);
  try
    ModernProfileEditorForm.GameDB:=GameDB;
    ModernProfileEditorForm.Game:=Game;
    ModernProfileEditorForm.SilentMode:=True;
    ModernProfileEditorForm.SearchLinkFile:=SearchLinkFile;
    ModernProfileEditorForm.FormShow(self);
    C:=0;
    For I:=0 to length(ModernProfileEditorForm.FrameList)-1 do if ModernProfileEditorForm.FrameList[I].AllowDefaultValueReset then begin
      if ListBox2.Checked[C] then begin
        If Assigned(ModernProfileEditorForm.FrameList[I].ResetToDefault) then ModernProfileEditorForm.FrameList[I].ResetToDefault(self,Template) else ModernProfileEditorForm.FrameList[I].IFrame.SetGame(Template,True);
      end;
      inc(C);
    end;
    ModernProfileEditorForm.OKButtonClick(ModernProfileEditorForm);
  finally
    ModernProfileEditorForm.Free;
  end;
end;

procedure TResetProfilesForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    Template, DefaultTemplate : TGame;
begin
  If RadioButtonTemplate.Checked then begin
    If ComboBoxTemplate.ItemIndex<0 then exit;
    Template:=TGame(ComboBoxTemplate.Items.Objects[ComboBoxTemplate.ItemIndex]);
  end else begin
    If ComboBoxAutoSetup.ItemIndex<0 then exit;
    Template:=TGame(ComboBoxAutoSetup.Items.Objects[ComboBoxAutoSetup.ItemIndex]);
  end;
  If Template=nil then begin
    DefaultTemplate:=TGame.Create(PrgSetup);
    Template:=DefaultTemplate;
  end else begin
    DefaultTemplate:=nil;
  end;
  try
    For I:=0 to ListBox.Items.Count-1 do if ListBox.Checked[I] then ResetGame(TGame(ListBox.Items.Objects[I]),Template);
  finally
    If DefaultTemplate<>nil then DefaultTemplate.Free;
  end;
end;

procedure TResetProfilesForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileOptionsResetProfiles);
end;

procedure TResetProfilesForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowResetProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  ResetProfilesForm:=TResetProfilesForm.Create(AOwner);
  try
    ResetProfilesForm.GameDB:=AGameDB;
    ResetProfilesForm.SearchLinkFile:=ASearchLinkFile;
    result:=(ResetProfilesForm.ShowModal=mrOK);
  finally
    ResetProfilesForm.Free;
  end;
end;

end.
