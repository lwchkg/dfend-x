unit ZipPackageDBGLFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, CheckLst, ExtCtrls;

type
  TZipPackageDBGLForm = class(TForm)
    TitleEdit: TLabeledEdit;
    AuthorEdit: TLabeledEdit;
    GamesListBox: TCheckListBox;
    NotesMemo: TRichEdit;
    NotesLabel: TLabel;
    GamesLabel: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ZipPackageDBGLForm: TZipPackageDBGLForm;

Function ShowZipPackageDBGLDialog(const AOwner : TComponent; const Title, Author, Notes : String; const Profiles : TStringList) : Boolean;

implementation

uses CommonTools, LanguageSetupUnit, VistaToolsUnit, IconLoaderUnit;

{$R *.dfm}

procedure TZipPackageDBGLForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  TitleEdit.Color:=Color;
  AuthorEdit.Color:=Color;
  NotesMemo.Color:=Color;

  Caption:=LanguageSetup.ImportDBGLPackage;
  TitleEdit.EditLabel.Caption:=LanguageSetup.ImportDBGLPackageTitle;
  AuthorEdit.EditLabel.Caption:=LanguageSetup.ImportDBGLPackageAuthor;
  NotesLabel.Caption:=LanguageSetup.ImportDBGLPackageNotes;
  GamesLabel.Caption:=LanguageSetup.ImportDBGLPackageGames;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
end;

{ global }

Function ShowZipPackageDBGLDialog(const AOwner : TComponent; const Title, Author, Notes : String; const Profiles : TStringList) : Boolean;
Var I : Integer;
begin
  ZipPackageDBGLForm:=TZipPackageDBGLForm.Create(AOwner);
  try
    {To fix problems with russian translation and VCL functions}
    ZipPackageDBGLForm.TitleEdit.HandleNeeded;
    ZipPackageDBGLForm.AuthorEdit.HandleNeeded;

    ZipPackageDBGLForm.TitleEdit.Text:=Title;
    ZipPackageDBGLForm.AuthorEdit.Text:=Author;
    ZipPackageDBGLForm.NotesMemo.Text:=Notes;
    ZipPackageDBGLForm.GamesListBox.Items.BeginUpdate;
    try
      ZipPackageDBGLForm.GamesListBox.Items.Clear;
      ZipPackageDBGLForm.GamesListBox.Items.AddStrings(Profiles);
      For I:=0 to ZipPackageDBGLForm.GamesListBox.Items.Count-1 do ZipPackageDBGLForm.GamesListBox.Checked[I]:=True;
    finally
      ZipPackageDBGLForm.GamesListBox.Items.EndUpdate;
    end;
    result:=(ZipPackageDBGLForm.ShowModal=mrOK);
    if result then begin
      Profiles.Clear;
      For I:=0 to ZipPackageDBGLForm.GamesListBox.Items.Count-1 do if ZipPackageDBGLForm.GamesListBox.Checked[I] then
        Profiles.AddObject(ZipPackageDBGLForm.GamesListBox.Items[I],ZipPackageDBGLForm.GamesListBox.Items.Objects[I]);
    end;
  finally
    ZipPackageDBGLForm.Free;
  end;

end;

end.
