unit CreateXMLFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ExtCtrls, CheckLst, GameDBUnit;

type
  TCreateXMLForm = class(TForm)
    InfoLabel: TLabel;
    SelectFileButton: TSpeedButton;
    ListBox: TCheckListBox;
    FileEdit: TLabeledEdit;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    FileTypeRadioGroup: TRadioGroup;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure SelectFileButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  CreateXMLForm: TCreateXMLForm;

Function ExportXMLFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, GameDBToolsUnit, CommonTools,
     SimpleXMLUnit, IconLoaderUnit;

{$R *.dfm}

procedure TCreateXMLForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  {Caption:=LanguageSetup.CreateConfForm;
  InfoLabel.Caption:=LanguageSetup.CreateConfFormInfo;}
  InfoLabel.Caption:='Please select the profiles for which shall be included to the xml file:';
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  {FileTypeRadioGroup
  FileEdit.EditLabel.Caption:=LanguageSetup.CreateConfFormSelectFolder;}
  SelectFileButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  {SaveDialog.Caption:=LanguageSetup.
  SaveDialog.Filter:=LanguageSetup.}
  UserIconLoader.DialogImage(DI_SelectFile,SelectFileButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
end;

procedure TCreateXMLForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,True,True);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,True,True);
end;

procedure TCreateXMLForm.SelectButtonClick(Sender: TObject);
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

procedure TCreateXMLForm.SelectFileButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(FileEdit.Text);
  If S='' then S:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY) else S:=ExtractFilePath(S);
  SaveDialog.InitialDir:=S;
  If SaveDialog.Execute then FileEdit.Text:=SaveDialog.FileName;
end;

procedure TCreateXMLForm.OKButtonClick(Sender: TObject);
Var L : TList;
    I : Integer;
    FileStyle : TSimpleXMLFileStyle;
begin
  L:=TList.Create;
  try
    For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then L.Add(ListBox.Items.Objects[I]);
    If FileTypeRadioGroup.ItemIndex=0 then FileStyle:=sxfsDBGL else FileStyle:=sxfsDOG;
    If not WriteProfilesToXML(L,FileEdit.Text,FileStyle) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[FileEdit.Text]),mtError,[mbOK],0);
    end;
  finally
    L.Free;
  end;
end;

{ global }

Function ExportXMLFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  CreateXMLForm:=TCreateXMLForm.Create(AOwner);
  try
    CreateXMLForm.GameDB:=AGameDB;
    result:=(CreateXMLForm.ShowModal=mrOK);
  finally
    CreateXMLForm.Free;
  end;
end;

end.
