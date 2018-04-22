unit SelectProfilesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, CheckLst, GameDBUnit;

type
  TSelectProfilesForm = class(TForm)
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    PopupMenu: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  SelectProfilesForm: TSelectProfilesForm;

Function ShowSelectProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; var L : TList) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, GameDBToolsUnit, CommonTools,
     IconLoaderUnit;

{$R *.dfm}

procedure TSelectProfilesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.TemplateFormNewFromProfilesCaption;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
end;

procedure TSelectProfilesForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);
end;

procedure TSelectProfilesForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

{ global }

Function ShowSelectProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; var L : TList) : Boolean;
Var I : Integer;
begin
  SelectProfilesForm:=TSelectProfilesForm.Create(AOwner);
  try
    SelectProfilesForm.GameDB:=AGameDB;
    result:=(SelectProfilesForm.ShowModal=mrOK);
    If result then begin
      L:=TList.Create;
      For I:=0 to SelectProfilesForm.ListBox.Items.Count-1 do If SelectProfilesForm.ListBox.Checked[I] then
        L.Add(SelectProfilesForm.ListBox.Items.Objects[I]);
    end;
  finally
    SelectProfilesForm.Free;
  end;
end;

end.
