unit SelectAutoSetupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons;

type
  TSelectAutoSetupForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ListBox: TListBox;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    AutoSetupDB : TGameDB;
  end;

var
  SelectAutoSetupForm: TSelectAutoSetupForm;

Function ShowSelectAutoSetupDialog(const AOwner : TComponent; const AAutoSetupDB : TGameDB) : Integer;

implementation

uses CommonTools, LanguageSetupUnit, VistaToolsUnit;

{$R *.dfm}

procedure TSelectAutoSetupForm.FormShow(Sender: TObject);
Var I : Integer;
    St : TStringList;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetupSelect;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  St:=TStringList.Create;
  try
    For I:=0 to AutoSetupDB.Count-1 do St.AddObject(AutoSetupDB[I].CacheName,TObject(I));
    St.Sort;
    ListBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
end;

{ global }

Function ShowSelectAutoSetupDialog(const AOwner : TComponent; const AAutoSetupDB : TGameDB) : Integer;
begin
  SelectAutoSetupForm:=TSelectAutoSetupForm.Create(AOwner);
  try
    SelectAutoSetupForm.AutoSetupDB:=AAutoSetupDB;
    If SelectAutoSetupForm.ShowModal=mrOK then result:=Integer(SelectAutoSetupForm.ListBox.Items.Objects[SelectAutoSetupForm.ListBox.ItemIndex]) else result:=-1;
  finally
    SelectAutoSetupForm.Free;
  end;
end;

end.
