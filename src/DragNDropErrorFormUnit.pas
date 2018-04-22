unit DragNDropErrorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons;

type
  TDragNDropErrorForm = class(TForm)
    OKButton: TBitBtn;
    InfoLabel: TLabel;
    ErrorListBox: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Errors : TStringList;
  end;

var
  DragNDropErrorForm: TDragNDropErrorForm;

Procedure ShowDragNDropErrorDialog(const AOwner : TComponent; const AErrors : TStringList);

implementation

{$R *.dfm}

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit;

procedure TDragNDropErrorForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.DragDropErrorInfoDialogCaption;
  InfoLabel.Caption:=LanguageSetup.DragDropErrorInfoDialogLabel;
  OKButton.Caption:=LanguageSetup.OK;

  UserIconLoader.DialogImage(DI_OK,OKButton);
end;

procedure TDragNDropErrorForm.FormShow(Sender: TObject);
begin
  ErrorListBox.Lines.AddStrings(Errors);
end;

{ global }

Procedure ShowDragNDropErrorDialog(const AOwner : TComponent; const AErrors : TStringList);
begin
  DragNDropErrorForm:=TDragNDropErrorForm.Create(AOwner);
  try
    DragNDropErrorForm.Errors:=AErrors;
    DragNDropErrorForm.ShowModal;
  finally
    DragNDropErrorForm.Free;
  end;
end;

end.
