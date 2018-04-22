unit SetupFrameToolbarUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, Buttons, CheckLst, SetupFormUnit;

type
  TSetupFrameToolbar = class(TFrame, ISetupFrame)
    AddButtonFunctionLabel: TLabel;
    AddButtonFunctionComboBox: TComboBox;
    ImageOpenDialog: TOpenDialog;
    ShowToolbarCheckBox: TCheckBox;
    ShowToolbarCaptionsCheckBox: TCheckBox;
    ToolbarImageButton: TSpeedButton;
    ToolbarImageEdit: TEdit;
    ToolbarImageCheckBox: TCheckBox;
    ToolbarFontSizeEdit: TSpinEdit;
    ToolbarFontSizeLabel: TLabel;
    ButtonsListBox: TCheckListBox;
    ButtonsLabel: TLabel;
    procedure ToolbarImageEditChange(Sender: TObject);
    procedure ToolbarImageButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    PBaseDir : PString;
    Procedure CloseCheck(var CloseOK : Boolean);
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameToolbar }

function TSetupFrameToolbar.GetName: String;
begin
  result:=LanguageSetup.SetupFormToolbar;
end;

procedure TSetupFrameToolbar.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
begin
  NoFlicker(ShowToolbarCheckBox);
  NoFlicker(ShowToolbarCaptionsCheckBox);
  NoFlicker(AddButtonFunctionComboBox);
  NoFlicker(ToolbarImageCheckBox);
  NoFlicker(ToolbarImageEdit);
  NoFlicker(ToolbarFontSizeEdit);

  PBaseDir:=InitData.PBaseDir;

  ShowToolbarCheckBox.Checked:=PrgSetup.ShowToolbar;
  ShowToolbarCaptionsCheckBox.Checked:=PrgSetup.ShowToolbarTexts;

  If ButtonsListBox.Items.Count=0 then for I:=0 to 7 do ButtonsListBox.Items.Add('');
  ButtonsListBox.Checked[0]:=PrgSetup.ShowToolbarButtonClose;
  ButtonsListBox.Checked[1]:=PrgSetup.ShowToolbarButtonRun;
  ButtonsListBox.Checked[2]:=PrgSetup.ShowToolbarButtonRunSetup;
  ButtonsListBox.Checked[3]:=PrgSetup.ShowToolbarButtonAdd;
  ButtonsListBox.Checked[4]:=PrgSetup.ShowToolbarButtonEdit;
  ButtonsListBox.Checked[5]:=PrgSetup.ShowToolbarButtonDelete;
  ButtonsListBox.Checked[6]:=PrgSetup.ShowSearchBox;
  ButtonsListBox.Checked[7]:=PrgSetup.ShowToolbarButtonHelp;

  AddButtonFunctionComboBox.ItemIndex:=Min(2,Max(0,PrgSetup.AddButtonFunction));
  ToolbarImageCheckBox.Checked:=Trim(PrgSetup.ToolbarBackground)<>'';
  ToolbarImageEdit.Text:=PrgSetup.ToolbarBackground;
  ToolbarFontSizeEdit.Value:=PrgSetup.ToolbarFontSize;

  InitData.CloseCheckEvent:=CloseCheck;

  UserIconLoader.DialogImage(DI_SelectFile,ToolbarImageButton);
end;

procedure TSetupFrameToolbar.LoadLanguage;
Var I : Integer;
begin
  ShowToolbarCheckBox.Caption:=LanguageSetup.SetupFormShowToolbar;
  ShowToolbarCaptionsCheckBox.Caption:=LanguageSetup.SetupFormShowToolbarCaptions;
  ButtonsLabel.Caption:=LanguageSetup.SetupFormShowToolbarButtons;
  If ButtonsListBox.Items.Count=0 then for I:=0 to 6 do ButtonsListBox.Items.Add('');
  ButtonsListBox.Items[0]:=RemoveUnderline(LanguageSetup.ButtonClose);
  ButtonsListBox.Items[1]:=RemoveUnderline(LanguageSetup.ButtonRun);
  ButtonsListBox.Items[2]:=RemoveUnderline(LanguageSetup.ButtonRunSetup);
  ButtonsListBox.Items[3]:=RemoveUnderline(LanguageSetup.ButtonAdd);
  ButtonsListBox.Items[4]:=RemoveUnderline(LanguageSetup.ButtonEdit);
  ButtonsListBox.Items[5]:=RemoveUnderline(LanguageSetup.ButtonDelete);
  ButtonsListBox.Items[6]:=RemoveUnderline(LanguageSetup.MenuViewShowSearchBox);
  ButtonsListBox.Items[7]:=RemoveUnderline(LanguageSetup.ButtonHelp);
  AddButtonFunctionLabel.Caption:=LanguageSetup.SetupFormAddButtonFunctionLabel;
  I:=AddButtonFunctionComboBox.ItemIndex;
  AddButtonFunctionComboBox.Items[0]:=LanguageSetup.SetupFormAddButtonFunctionAdd;
  AddButtonFunctionComboBox.Items[1]:=LanguageSetup.SetupFormAddButtonFunctionWizard;
  AddButtonFunctionComboBox.Items[2]:=LanguageSetup.SetupFormAddButtonFunctionMenu;
  AddButtonFunctionComboBox.ItemIndex:=I;
  ToolbarImageCheckBox.Caption:=LanguageSetup.SetupFormBackgroundColorFile;
  ToolbarImageButton.Hint:=LanguageSetup.ChooseFile;
  ToolbarFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;

  HelpContext:=ID_FileOptionsToolbar;
end;

procedure TSetupFrameToolbar.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameToolbar.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameToolbar.HideFrame;
begin
end;

procedure TSetupFrameToolbar.RestoreDefaults;
begin
  ShowToolbarCheckBox.Checked:=True;
  ShowToolbarCaptionsCheckBox.Checked:=True;
  ButtonsListBox.Checked[0]:=False;
  ButtonsListBox.Checked[1]:=True;
  ButtonsListBox.Checked[2]:=False;
  ButtonsListBox.Checked[3]:=True;
  ButtonsListBox.Checked[4]:=True;
  ButtonsListBox.Checked[5]:=True;
  ButtonsListBox.Checked[6]:=True;
  ButtonsListBox.Checked[7]:=True;
  AddButtonFunctionComboBox.ItemIndex:=2;
  ToolbarImageCheckBox.Checked:=False;
  ToolbarImageEdit.Text:='';
  ToolbarFontSizeEdit.Value:=9;
end;

procedure TSetupFrameToolbar.BeforeChangeLanguage;
begin

end;

Procedure TSetupFrameToolbar.CloseCheck(var CloseOK : Boolean);
Var I : Integer;
begin
  For I:=0 to ButtonsListBox.Count-1 do If ButtonsListBox.Checked[I] then exit;
  MessageDlg(LanguageSetup.SetupFormShowToolbarButtonsError,mtError,[mbOK],0);
  CloseOK:=False;
end;

procedure TSetupFrameToolbar.SaveSetup;
begin
  PrgSetup.ShowToolbar:=ShowToolbarCheckBox.Checked;
  PrgSetup.ShowToolbarTexts:=ShowToolbarCaptionsCheckBox.Checked;
  PrgSetup.ShowToolbarButtonClose:=ButtonsListBox.Checked[0];
  PrgSetup.ShowToolbarButtonRun:=ButtonsListBox.Checked[1];
  PrgSetup.ShowToolbarButtonRunSetup:=ButtonsListBox.Checked[2];
  PrgSetup.ShowToolbarButtonAdd:=ButtonsListBox.Checked[3];
  PrgSetup.ShowToolbarButtonEdit:=ButtonsListBox.Checked[4];
  PrgSetup.ShowToolbarButtonDelete:=ButtonsListBox.Checked[5];
  PrgSetup.ShowSearchBox:=ButtonsListBox.Checked[6];
  PrgSetup.ShowToolbarButtonHelp:=ButtonsListBox.Checked[7];
  PrgSetup.AddButtonFunction:=AddButtonFunctionComboBox.ItemIndex;
  If ToolbarImageCheckBox.Checked then PrgSetup.ToolbarBackground:=ToolbarImageEdit.Text else PrgSetup.ToolbarBackground:='';
  PrgSetup.ToolbarFontSize:=ToolbarFontSizeEdit.Value;
end;

procedure TSetupFrameToolbar.ToolbarImageEditChange(Sender: TObject);
begin
  ToolbarImageCheckBox.Checked:=True;
end;

procedure TSetupFrameToolbar.ToolbarImageButtonClick(Sender: TObject);
Var S : String;
begin
  ImageOpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
  ImageOpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
  S:=ToolbarImageEdit.Text;
  If Trim(S)='' then S:=IncludeTrailingPathDelimiter(PBaseDir^);
  S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(PBaseDir^));
  ImageOpenDialog.InitialDir:=ExtractFilePath(S);
  If ImageOpenDialog.Execute then begin
    ToolbarImageEdit.Text:=MakeRelPath(ImageOpenDialog.FileName,IncludeTrailingPathDelimiter(PBaseDir^));
  end;
end;

end.
