unit TextViewerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TTextViewerForm = class(TForm)
    Panel1: TPanel;
    CloseButton: TBitBtn;
    Memo: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Title, Text : String;
  end;

var
  TextViewerForm: TTextViewerForm;

Procedure ShowTextViewerDialog(const AOwner : TComponent; const ATitle, AText : String);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TTextViewerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  CloseButton.Caption:=LanguageSetup.Close;

  UserIconLoader.DialogImage(DI_Close,CloseButton);
end;

procedure TTextViewerForm.FormShow(Sender: TObject);
begin
  Memo.Text:=Text;
end;

{ global }

Procedure ShowTextViewerDialog(const AOwner : TComponent; const ATitle, AText : String);
begin
  TextViewerForm:=TTextViewerForm.Create(AOwner);
  try
    TextViewerForm.Caption:=ATitle;
    TextViewerForm.Text:=AText;
    TextViewerForm.ShowModal;
  finally
    TextViewerForm.Free;
  end;
end;

end.
