unit ListScummVMGamesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TListScummVMGamesForm = class(TForm)
    ListBox: TListBox;
    Panel1: TPanel;
    CloseButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ListScummVMGamesForm: TListScummVMGamesForm;

Procedure ShowListScummVMGamesDialog(const AOwner : TComponent);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, ScummVMToolsUnit,
     IconLoaderUnit;

{$R *.dfm}

procedure TListScummVMGamesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  NoFlicker(ListBox);

  Caption:=LanguageSetup.MenuHelpScummVMCompatibilityListCaption;
  CloseButton.Caption:=LanguageSetup.Close;

  UserIconLoader.DialogImage(DI_Close,CloseButton);

  If ScummVMGamesList.Count=0 then ScummVMGamesList.LoadListFromScummVM(True);
  ListBox.Items.AddStrings(ScummVMGamesList.DescriptionList);
  ListBox.Sorted:=True;
end;

{ global }

Procedure ShowListScummVMGamesDialog(const AOwner : TComponent);
begin
  ListScummVMGamesForm:=TListScummVMGamesForm.Create(AOwner);
  try
    ListScummVMGamesForm.ShowModal;
  finally
    ListScummVMGamesForm.Free;
  end;
end;

end.
