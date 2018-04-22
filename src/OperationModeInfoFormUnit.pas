unit OperationModeInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, ValEdit;

type
  TOperationModeInfoForm = class(TForm)
    TopLabel: TLabel;
    OpModeLabel: TLabel;
    OKButton: TBitBtn;
    PrgDirEdit: TLabeledEdit;
    PrgDataDirEdit: TLabeledEdit;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox2: TCheckBox;
    HelpButton: TBitBtn;
    BaseDirEdit: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  OperationModeInfoForm: TOperationModeInfoForm;

Procedure ShowOperationModeInfoDialog(const AOwner : TComponent);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, HelpConsts,
     IconLoaderUnit;

{$R *.dfm}

procedure TOperationModeInfoForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  OpModeLabel.Font.Style:=[fsBold];

  Caption:=LanguageSetup.OperationModeCaption;
  TopLabel.Caption:=LanguageSetup.OperationModeTopLabel;
  CheckBox1.Caption:=LanguageSetup.OperationModeInfoPrgSettingsPrgDir;
  CheckBox2.Caption:=LanguageSetup.OperationModeInfoPrgSettingsUserDir;
  CheckBox3.Caption:=LanguageSetup.OperationModeInfoUsersShareSettings;
  CheckBox4.Caption:=LanguageSetup.OperationModeInfoVistaCompatible;
  CheckBox5.Caption:=LanguageSetup.OperationModeInfoDOSBoxRelative;
  OKButton.Caption:=LanguageSetup.OK;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  Case OperationMode of
    omPrgDir   : begin
                   OpModeLabel.Caption:=LanguageSetup.OperationModeOpModePrgDir;
                   CheckBox1.Checked:=True;
                   CheckBox2.Checked:=False;
                   CheckBox3.Checked:=True;
                   CheckBox4.Checked:=False;
                   CheckBox5.Checked:=False;
                 end;
    omUserDir  : begin
                   OpModeLabel.Caption:=LanguageSetup.OperationModeOpModeUserDir;
                   CheckBox1.Checked:=False;
                   CheckBox2.Checked:=True;
                   CheckBox3.Checked:=False;
                   CheckBox4.Checked:=True;
                   CheckBox5.Checked:=False;
                 end;
    omPortable : begin
                   OpModeLabel.Caption:=LanguageSetup.OperationModeOpModePortable;
                   CheckBox1.Checked:=True;
                   CheckBox2.Checked:=False;
                   CheckBox3.Checked:=True;
                   CheckBox4.Checked:=True;
                   CheckBox5.Checked:=True;
                 end;
  end;

  PrgDirEdit.EditLabel.Caption:=LanguageSetup.OperationModePrgDir;
  PrgDirEdit.Text:=PrgDir;

  PrgDataDirEdit.EditLabel.Caption:=LanguageSetup.OperationModeDataDir;
  PrgDataDirEdit.Text:=PrgDataDir;

  BaseDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormBaseDir;
  BaseDirEdit.Text:=PrgSetup.BaseDir;

  PrgDirEdit.Color:=clBtnFace;
  PrgDataDirEdit.Color:=clBtnFace;
  BaseDirEdit.Color:=clBtnFace;
end;

procedure TOperationModeInfoForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_HelpOperationMode);
end;

procedure TOperationModeInfoForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure ShowOperationModeInfoDialog(const AOwner : TComponent);
begin
  OperationModeInfoForm:=TOperationModeInfoForm.Create(AOwner);
  try
    OperationModeInfoForm.ShowModal;
  finally
    OperationModeInfoForm.Free;
  end;
end;

end.
