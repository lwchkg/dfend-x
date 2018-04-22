unit WindowsFileWarningFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TWindowsFileWarningForm = class(TForm)
    InfoLabel: TLabel;
    OKButton: TBitBtn;
    TurnOffWarningsCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    FileName : String;
  end;

var
  WindowsFileWarningForm: TWindowsFileWarningForm;

Procedure ShowWindowsFileWarningDialog(const AOwner : TComponent; const AFileName : String; var ATurnWarningsOff : Boolean);

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TWindowsFileWarningForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
end;

procedure TWindowsFileWarningForm.FormShow(Sender: TObject);
begin
  Caption:=LanguageSetup.MsgDlgWarning;
  InfoLabel.Caption:=Format(LanguageSetup.MessageWindowsExeExecuteWarning,[FileName]);
  TurnOffWarningsCheckBox.Caption:=LanguageSetup.MessageWindowsExeExecuteWarningTurnOff;

  OKButton.Caption:=LanguageSetup.OK;
  UserIconLoader.DialogImage(DI_OK,OKButton);
end;

{ global }

Procedure ShowWindowsFileWarningDialog(const AOwner : TComponent; const AFileName : String; var ATurnWarningsOff : Boolean);
begin
  WindowsFileWarningForm:=TWindowsFileWarningForm.Create(AOwner);
  try
    WindowsFileWarningForm.FileName:=AFileName;
    WindowsFileWarningForm.ShowModal;
    ATurnWarningsOff:=WindowsFileWarningForm.TurnOffWarningsCheckBox.Checked;
  finally
    WindowsFileWarningForm.Free;
  end;
end;

end.
