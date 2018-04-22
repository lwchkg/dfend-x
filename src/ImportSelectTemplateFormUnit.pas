unit ImportSelectTemplateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons;

type
  TImportSelectTemplateForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    InfoLabel: TLabel;
    ComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameFolder : String;
    TemplateDB : TGameDB;
    MatchingTemplates : TStringList;
    SelectedTemplate : Integer;
  end;

var
  ImportSelectTemplateForm: TImportSelectTemplateForm;

Function ShowSelectTemplateDialog(const AOwner : TComponent; const GameFolder : String; const TemplateDB : TGameDB; MatchingTemplates : TStringList) : Integer;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit, IconLoaderUnit;

{$R *.dfm}

procedure TImportSelectTemplateForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.SelectAutoSetupTemplate;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  SelectedTemplate:=-1;
end;

procedure TImportSelectTemplateForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  If GameFolder<>''
    then InfoLabel.Caption:=Format(LanguageSetup.SelectAutoSetupTemplateScanFolder,[GameFolder])
    else InfoLabel.Caption:=LanguageSetup.SelectAutoSetupTemplateImportZip;

  For I:=0 to MatchingTemplates.Count-1 do
    ComboBox.Items.Add(TemplateDB[Integer(MatchingTemplates.Objects[I])].Name);
  ComboBox.ItemIndex:=0;
end;

procedure TImportSelectTemplateForm.OKButtonClick(Sender: TObject);
begin
  SelectedTemplate:=ComboBox.ItemIndex;
end;

{ global }

Function ShowSelectTemplateDialog(const AOwner : TComponent; const GameFolder : String;  const TemplateDB : TGameDB; MatchingTemplates : TStringList) : Integer;
begin
  result:=-1;
  If MatchingTemplates.Count=0 then exit;
  If MatchingTemplates.Count=1 then begin result:=0; exit; end;

  ImportSelectTemplateForm:=TImportSelectTemplateForm.Create(AOwner);
  try
    ImportSelectTemplateForm.TemplateDB:=TemplateDB;
    ImportSelectTemplateForm.GameFolder:=GameFolder;
    ImportSelectTemplateForm.MatchingTemplates:=MatchingTemplates;
    If ImportSelectTemplateForm.ShowModal<>mrOK then exit;
    result:=ImportSelectTemplateForm.SelectedTemplate;
  finally
    ImportSelectTemplateForm.Free;
  end;
end;

end.
