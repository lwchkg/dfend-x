unit FullscreenInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFullscreenInfoForm = class(TForm)
    CheckBox: TCheckBox;
    InfoLabel: TLabel;
    OKButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FullscreenInfoForm: TFullscreenInfoForm;

Procedure ShowFullscreenInfoDialog(const AOwner : TComponent);

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit, IconLoaderUnit;

{$R *.dfm}

procedure TFullscreenInfoForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.MsgDlgInformation;
  InfoLabel.Caption:=LanguageSetup.FullscreenInfoInfo;
  CheckBox.Caption:=LanguageSetup.FullscreenInfoCheckbox;
  OKButton.Caption:=LanguageSetup.OK;

  UserIconLoader.DialogImage(DI_OK,OKButton);

  InfoLabel.Font.Style:=[fsBold];
end;

procedure TFullscreenInfoForm.OKButtonClick(Sender: TObject);
begin
  PrgSetup.FullscreenInfo:=not CheckBox.Checked;
end;

{ global }

Procedure ShowFullscreenInfoDialog(const AOwner : TComponent);
Var FullscreenInfoForm : TFullscreenInfoForm;
begin
  If not PrgSetup.FullscreenInfo then exit;

  FullscreenInfoForm:=TFullscreenInfoForm.Create(AOwner);
  try
    FullscreenInfoForm.ShowModal;
  finally
    FullscreenInfoForm.Free;
  end;
end;

end.
