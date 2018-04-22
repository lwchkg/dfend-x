unit TemplateSelectProfileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList, GameDBUnit, GameDBToolsUnit;

type
  TTemplateSelectProfileForm = class(TForm)
    ListView: TListView;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ImageList: TImageList;
    ListViewImageList: TImageList;
    ListviewIconImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewDblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ListSort : TSortListBy;
    ListSortReverse : Boolean;
    procedure LoadList;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
  end;

var
  TemplateSelectProfileForm: TTemplateSelectProfileForm;

Function SelectProfile(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TTemplateSelectProfileForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  ListSort:=slbName;
  ListSortReverse:=False;

  Caption:=LanguageSetup.TemplateFormNewFromProfileCaption;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
end;

procedure TTemplateSelectProfileForm.LoadList;
begin
  ListView.Items.BeginUpdate;
  try
    AddGamesToList(ListView,ListViewImageList,ListviewIconImageList,ImageList,GameDB,'','','',True,ListSort,ListSortReverse,True,False,False,False);
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TTemplateSelectProfileForm.FormShow(Sender: TObject);
begin
  InitListViewForGamesList(ListView,True);
  LoadList;
  Game:=nil;
end;

procedure TTemplateSelectProfileForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort,ListSortReverse);
  LoadList;
end;

procedure TTemplateSelectProfileForm.ListViewDblClick(Sender: TObject);
begin
  OKButton.Click;
end;

procedure TTemplateSelectProfileForm.OKButtonClick(Sender: TObject);
begin
  If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
    MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  Game:=TGame(ListView.Selected.Data);
end;

Function SelectProfile(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
begin
  TemplateSelectProfileForm:=TTemplateSelectProfileForm.Create(AOwner);
  try
    TemplateSelectProfileForm.GameDB:=AGameDB;
    If TemplateSelectProfileForm.ShowModal=mrOK then begin
      result:=TemplateSelectProfileForm.Game;
    end else begin
      result:=nil;
    end;
  finally
    TemplateSelectProfileForm.Free;
  end;
end;

end.
