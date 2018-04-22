unit MiniRunFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, ExtCtrls;

type
  TMiniRunForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ListBox: TListBox;
    NameEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure NameEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    List, ListUpper : TStringList;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  MiniRunForm: TMiniRunForm;

Function ShowMiniRunDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, DosBoxUnit, ScummVMUnit,
     GameDBToolsUnit, WindowsProfileUnit, IconLoaderUnit, MainUnit;

{$R *.dfm}

procedure TMiniRunForm.FormCreate(Sender: TObject);
begin
  List:=TStringList.Create;
  ListUpper:=TStringList.Create;

  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.TrayPopupRunInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  Top:=Screen.WorkAreaRect.Bottom-Height;
  Left:=Screen.WorkAreaRect.Right-Width;
end;

procedure TMiniRunForm.FormShow(Sender: TObject);
Var I : Integer;
    W : Word;
begin
  For I:=0 to GameDB.Count-1 do List.AddObject(GameDB[I].Name,GameDB[I]);
  List.Sort;
  For I:=0 to List.Count-1 do ListUpper.Add(Trim(ExtUpperCase(List[I])));

  W:=0; NameEditKeyUp(Sender,W,[]);
end;

procedure TMiniRunForm.FormDestroy(Sender: TObject);
begin
  If Assigned(List) then List.Free;
  If Assigned(ListUpper) then ListUpper.Free;
end;

procedure TMiniRunForm.NameEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Var S : String;
    I,GNr : Integer;
    G,O : TObject;
begin
  S:=Trim(ExtUpperCase(NameEdit.Text));

  If ListBox.ItemIndex>=0 then G:=ListBox.Items.Objects[ListBox.ItemIndex] else G:=nil;
  GNr:=-1;

  ListBox.Items.BeginUpdate;
  try
    ListBox.Items.Clear;
    For I:=0 to ListUpper.Count-1 do If (S='') or (Pos(S,ListUpper[I])>0) then begin
      O:=List.Objects[I];
      If O=G then GNr:=I;
      ListBox.Items.AddObject(List[I],O);
    end;
  finally
    ListBox.Items.EndUpdate;
  end;

  If GNr>=0 then begin
    ListBox.ItemIndex:=GNr;
    ListBox.TopIndex:=GNr;
  end;

  If (Key=VK_Return) and (Shift=[]) and (ModalResult=mrNone) then OKButtonClick(Sender);
end;

procedure TMiniRunForm.OKButtonClick(Sender: TObject);
Var G : TGame;
begin
  ModalResult:=mrOK; {if triggered by listbox dblclick}

  If ListBox.ItemIndex<0 then begin
    MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  G:=TGame(ListBox.Items.Objects[ListBox.ItemIndex]);
  If ScummVMMode(G) then begin
    RunScummVMGame(G);
  end else begin
    If WindowsExeMode(G)
     then RunWindowsGame(G)
     else RunGame(G,DFendReloadedMainForm.DeleteOnExit);
  end;
end;

{ global }

Function ShowMiniRunDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  MiniRunForm:=TMiniRunForm.Create(AOwner);
  try
    MiniRunForm.GameDB:=AGameDB;
    result:=(MiniRunForm.ShowModal=mrOK);
  finally
    FreeAndNil(MiniRunForm);
  end;
end;

end.
