unit CacheChooseFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, GameDBUnit;

type
  TCacheChooseForm = class(TForm)
    InfoLabel: TLabel;
    ProfileListBox: TCheckListBox;
    OKButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    RestoreDeletedMode : Boolean;
    ProfileList : TStringList;
    GameDB : TGameDB;
  end;

var
  CacheChooseForm: TCacheChooseForm;

Procedure ShowCacheChooseDialog(const AOwner : TComponent; const AProfileList : TStringList; const AGameDB : TGameDB);
Procedure ShowRestoreDeletedDialog(const AOwner : TComponent; const AProfileList : TStringList; const AGameDB : TGameDB);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TCacheChooseForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  OKButton.Caption:=LanguageSetup.OK;

  RestoreDeletedMode:=False;

  UserIconLoader.DialogImage(DI_OK,OKButton);
end;

procedure TCacheChooseForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  If RestoreDeletedMode then begin
    Caption:=LanguageSetup.RestoreDeletedCaption;
    InfoLabel.Caption:=LanguageSetup.RestoreDeletedInfo;
  end else begin
    Caption:=LanguageSetup.CacheChooseCaption;
    InfoLabel.Caption:=LanguageSetup.CacheChooseInfo;
  end;

  ProfileListBox.Items.AddStrings(ProfileList);
  For I:=0 to ProfileListBox.Items.Count-1 do ProfileListBox.Checked[I]:=True;
end;

procedure TCacheChooseForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    G : TGame;
begin
  For I:=0 to ProfileListBox.Items.Count-1 do begin
    G:=TGame(ProfileListBox.Items.Objects[I]);
    If RestoreDeletedMode then begin
      If ProfileListBox.Checked[I] then begin
        G.StoreAllValues;
        G.RenameINI(G.SetupFile);
      end else begin
        GameDB.Delete(G);
      end;
    end else begin
      If ProfileListBox.Checked[I] then begin
        G:=TGame(ProfileListBox.Items.Objects[I]);
        G.ReloadINI;
        G.LoadCache;
      end else begin
        G.StoreAllValues;
      end;
    end;
  end;
end;

{ global }

Procedure ShowCacheChooseDialog(const AOwner : TComponent; const AProfileList : TStringList; const AGameDB : TGameDB);
begin
  CacheChooseForm:=TCacheChooseForm.Create(AOwner);
  try
    CacheChooseForm.ProfileList:=AProfileList;
    CacheChooseForm.GameDB:=AGameDB;
    CacheChooseForm.ShowModal;
  finally
    CacheChooseForm.Free;
  end;
end;

Procedure ShowRestoreDeletedDialog(const AOwner : TComponent; const AProfileList : TStringList; const AGameDB : TGameDB);
begin
  CacheChooseForm:=TCacheChooseForm.Create(AOwner);
  try
    CacheChooseForm.RestoreDeletedMode:=True;
    CacheChooseForm.ProfileList:=AProfileList;
    CacheChooseForm.GameDB:=AGameDB;
    CacheChooseForm.ShowModal;
  finally
    CacheChooseForm.Free;
  end;
end;

end.
