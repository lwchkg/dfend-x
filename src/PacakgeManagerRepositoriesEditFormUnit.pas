unit PacakgeManagerRepositoriesEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TPackageManagerRepositoriesEditForm = class(TForm)
    Label1: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  PackageManagerRepositoriesEditForm: TPackageManagerRepositoriesEditForm;

Function ShowPacakgeManagerRepositoriesEditDialog(const AOwner : TComponent) : Boolean;

implementation

uses CommonTools, PrgSetupUnit, VistaToolsUnit, LanguageSetupUnit, IconLoaderUnit; 

{$R *.dfm}

procedure TPackageManagerRepositoriesEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

{ global }

Function ShowPackageManagerRepositoriesEditDialog(const AOwner : TComponent) : Boolean;
begin
  PackageManagerRepositoriesEditForm:=TPackageManagerRepositoriesEditForm.Create(AOwner);
  try
    result:=(PackageManagerRepositoriesEditForm.ShowModal=mrOK);
  finally
    PackageManagerRepositoriesEditForm.Free;
  end;
end;

end.
