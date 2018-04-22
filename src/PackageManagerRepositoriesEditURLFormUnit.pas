unit PackageManagerRepositoriesEditURLFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TPackageManagerRepositoriesEditURLForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    RadioButtonURL: TRadioButton;
    RadioButtonLocalFile: TRadioButton;
    URLEdit: TEdit;
    PasteURLButton: TBitBtn;
    LocalFileEdit: TEdit;
    SelectFileButton: TSpeedButton;
    ClipboardTimer: TTimer;
    OpenDialog: TOpenDialog;
    WarningGroupBox: TGroupBox;
    WarningLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ClipboardTimerTimer(Sender: TObject);
    procedure PasteURLButtonClick(Sender: TObject);
    procedure SelectFileButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure RadioButtonOrEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    URL : String;
  end;

var
  PackageManagerRepositoriesEditURLForm: TPackageManagerRepositoriesEditURLForm;

Function ShowPackageManagerRepositoriesEditURLDialog(const AOwner : TComponent; var AURL : String) : Boolean;

implementation

uses ClipBrd, CommonTools, VistaToolsUnit, LanguageSetupUnit, IconLoaderUnit;

{$R *.dfm}

procedure TPackageManagerRepositoriesEditURLForm.FormShow(Sender: TObject);
Var S : String;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  If Trim(URL)='' then Caption:=LanguageSetup.RepositoriesEditorAddSourceCaption else Caption:=LanguageSetup.RepositoriesEditorEditSourceCaption;
  RadioButtonURL.Caption:=LanguageSetup.RepositoriesEditorURL;
  PasteURLButton.Caption:=LanguageSetup.RepositoriesEditorURLPaste;
  RadioButtonLocalFile.Caption:=LanguageSetup.RepositoriesEditorLocalFile;
  SelectFileButton.Hint:=LanguageSetup.ChooseFile;
  WarningGroupBox.Caption:=LanguageSetup.MsgDlgWarning;
  WarningLabel.Caption:=LanguageSetup.RepositoriesEditorAddSourceWarning;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  OpenDialog.Title:=LanguageSetup.RepositoriesEditorLocalFileTitle;
  OpenDialog.Filter:=LanguageSetup.RepositoriesEditorLocalFileFilter;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_PasteFromClipboard,PasteURLButton);
  UserIconLoader.DialogImage(DI_SelectFile,SelectFileButton);

  S:=Trim(ExtUpperCase(URL));
  If (Copy(S,1,7)='HTTP:/'+'/') or (Copy(S,1,7)='HTTPS:/'+'/') or (S='') then begin
    URLEdit.Text:=URL;
    RadioButtonURL.Checked:=True;
  end else begin
    LocalFileEdit.Text:=URL;
    RadioButtonLocalFile.Checked:=True;
  end;

  If Trim(URL)='' then begin
    ClipboardTimerTimer(Sender);
    If PasteURLButton.Enabled then PasteURLButtonClick(Sender);
  end;

  RadioButtonOrEditChange(Sender);
end;

procedure TPackageManagerRepositoriesEditURLForm.EditChange(Sender: TObject);
begin
  If Sender=URLEdit then RadioButtonURL.Checked:=True;
  If Sender=LocalFileEdit then RadioButtonLocalFile.Checked:=True;

  RadioButtonOrEditChange(Sender);
end;

procedure TPackageManagerRepositoriesEditURLForm.RadioButtonOrEditChange(Sender: TObject);
Var S : String;
begin
  If RadioButtonURL.Checked then S:=URLEdit.Text else S:=LocalFileEdit.Text;
  OKButton.Enabled:=(Trim(S)<>'');
end;

procedure TPackageManagerRepositoriesEditURLForm.ClipboardTimerTimer(Sender: TObject);
Var B : Boolean;
    S : String;
begin
  B:=Clipboard.HasFormat(CF_TEXT);
  If B then begin
    S:=Trim(ExtUpperCase(Clipboard.AsText));
    B:=(Copy(S,1,7)='HTTP:/'+'/') or (Copy(S,1,7)='HTTPS:/'+'/');
  end;
  PasteURLButton.Enabled:=B;
end;

procedure TPackageManagerRepositoriesEditURLForm.PasteURLButtonClick(Sender: TObject);
begin
  URLEdit.Text:=Clipboard.AsText;
end;

procedure TPackageManagerRepositoriesEditURLForm.SelectFileButtonClick(Sender: TObject);
begin
  If Trim(LocalFileEdit.Text)='' then OpenDialog.InitialDir:='' else OpenDialog.InitialDir:=ExtractFilePath(LocalFileEdit.Text);
  If OpenDialog.Execute then begin
    Application.ProcessMessages; {Otherwise the radiobutton won't turn}
    LocalFileEdit.Text:=OpenDialog.FileName;
  end;
end;

procedure TPackageManagerRepositoriesEditURLForm.OKButtonClick(Sender: TObject);
begin
  If RadioButtonURL.Checked then URL:=URLEdit.Text else URL:=LocalFileEdit.Text;
end;

{ global }

Function ShowPackageManagerRepositoriesEditURLDialog(const AOwner : TComponent; var AURL : String) : Boolean;
begin
  PackageManagerRepositoriesEditURLForm:=TPackageManagerRepositoriesEditURLForm.Create(AOwner);
  try
    PackageManagerRepositoriesEditURLForm.URL:=AURL;
    result:=(PackageManagerRepositoriesEditURLForm.ShowModal=mrOK);
    if result then AURL:=PackageManagerRepositoriesEditURLForm.URL;
  finally
    PackageManagerRepositoriesEditURLForm.Free;
  end;
end;

end.
