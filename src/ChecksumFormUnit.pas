unit ChecksumFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TChecksumForm = class(TForm)
    InfoLabel: TLabel;
    YesButton: TBitBtn;
    NoButton: TBitBtn;
    TurnOffButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ButtonResult : Integer;
  end;

var
  ChecksumForm: TChecksumForm;

Type TChecksumDialogResult=(cdYes,cdNo,cdTurnOff);

Function ShowCheckSumWarningDialog(const AOwner : TComponent; const Text : String) : TChecksumDialogResult;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TChecksumForm.ButtonWork(Sender: TObject);
begin
  ButtonResult:=(Sender as TComponent).Tag;
end;

procedure TChecksumForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CheckSumCaption;
  YesButton.Caption:=LanguageSetup.Yes;
  NoButton.Caption:=LanguageSetup.No;
  TurnOffButton.Caption:=LanguageSetup.CheckSumTurnOffForProfile;

  UserIconLoader.DialogImage(DI_Yes,YesButton);
  UserIconLoader.DialogImage(DI_No,NoButton);
  UserIconLoader.DialogImage(DI_Abort,TurnOffButton);

  ButtonResult:=1;
end;

{ global }

Function ShowCheckSumWarningDialog(const AOwner : TComponent; const Text : String) : TChecksumDialogResult;
begin
  result:=cdNo;
  ChecksumForm:=TChecksumForm.Create(AOwner);
  try
    ChecksumForm.InfoLabel.Caption:=Text;
    ChecksumForm.ShowModal;
    Case ChecksumForm.ButtonResult of
      0 : result:=cdYes;
      1 : result:=cdNo;
      2 : result:=cdTurnOff;
    end;
  finally
    ChecksumForm.Free;
  end;
end;

end.
