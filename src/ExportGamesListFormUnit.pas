unit ExportGamesListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GameDBUnit, CheckLst;

type
  TExportGamesListForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    FileNameEdit: TLabeledEdit;
    ListBoxLabel: TLabel;
    ListBox: TCheckListBox;
    SaveDialog: TSaveDialog;
    SelectFileButton: TSpeedButton;
    SelectNoneButton: TBitBtn;
    SelectAllButton: TBitBtn;
    InfoLabel: TLabel;
    ExportFormatLabel: TLabel;
    ExportFormatComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SelectFileButtonClick(Sender: TObject);
    procedure FileNameEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure ListBoxClickCheck(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExportFormatComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  ExportGamesListForm: TExportGamesListForm;

Function ShowExportGamesListDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit,
     GameDBToolsUnit, HelpConsts, PrgSetupUnit;

{$R *.dfm}

procedure TExportGamesListForm.FormCreate(Sender: TObject);
Var St : TStringList;
    I : Integer;
    S : String;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.MenuFileExportGamesListDialog;
  ListBoxLabel.Caption:=LanguageSetup.MenuFileExportGamesListListBoxLabel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  FileNameEdit.EditLabel.Caption:=LanguageSetup.MenuFileExportGamesListFileNameEdit;
  SelectFileButton.Hint:=LanguageSetup.ChooseFile;
  SaveDialog.Title:=LanguageSetup.MenuFileExportGamesListDialog;
  SaveDialog.Filter:=LanguageSetup.MenuFileExportGamesListFilter;

  ExportFormatLabel.Caption:=LanguageSetup.MenuFileExportGamesListFormat;
  ExportFormatComboBox.Items.Clear;
  ExportFormatComboBox.Items.Add(LanguageSetup.MenuFileExportGamesListFormatAuto);
  ExportFormatComboBox.Items.Add(LanguageSetup.MenuFileExportGamesListFormatText);
  ExportFormatComboBox.Items.Add(LanguageSetup.MenuFileExportGamesListFormatTable);
  ExportFormatComboBox.Items.Add(LanguageSetup.MenuFileExportGamesListFormatHTML);
  ExportFormatComboBox.Items.Add(LanguageSetup.MenuFileExportGamesListFormatXML);
  ExportFormatComboBox.ItemIndex:=0;

  InfoLabel.Caption:=LanguageSetup.MenuFileExportGamesListFileNameInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_SelectFile,SelectFileButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  St:=GetGamesListExportLanguageColumns;
  try
    For I:=0 to St.Count-1 do ListBox.Items.AddObject(St[I],TObject(I));
    ListBox.Items.AddObject(LanguageSetup.ProfileEditorUserDefinedInfo,TObject(glecUserFields));
    ListBox.Items.AddObject(LanguageSetup.GameNotes,TObject(glecUserFields));
  finally
    St.Free;
  end;

  S:=Trim(ExtUpperCase(PrgSetup.ExportColumns));
  While length(S)<ListBox.Items.Count-1 do S:=S+'X';
  ListBox.Checked[0]:=True;
  For I:=1 to ListBox.Items.Count-1 do ListBox.Checked[I]:=(S[I]='X');
end;

procedure TExportGamesListForm.FormShow(Sender: TObject);
begin
  FileNameEdit.Text:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY))+'List.txt';
  FileNameEditChange(Sender);
end;

procedure TExportGamesListForm.FormClose(Sender: TObject; var Action: TCloseAction);
Var S : String;
    I : Integer;
begin
  S:='';
  For I:=1 to ListBox.Items.Count-1 do If ListBox.Checked[I] then S:=S+'X' else S:=S+'-';
  PrgSetup.ExportColumns:=S;
end;

procedure TExportGamesListForm.ListBoxClickCheck(Sender: TObject);
begin
  ListBox.Checked[0]:=True;
end;

procedure TExportGamesListForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=1 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
end;

procedure TExportGamesListForm.SelectFileButtonClick(Sender: TObject);
begin
  SaveDialog.FileName:=FileNameEdit.Text;
  if not SaveDialog.Execute then exit;
  FileNameEdit.Text:=SaveDialog.FileName;
  FileNameEditChange(Sender);
end;

procedure TExportGamesListForm.ExportFormatComboBoxChange(Sender: TObject);
Var S,Ext : String;
begin
  Case ExportFormatComboBox.ItemIndex of
    1 : Ext:='.txt';
    2 : Ext:='.csv';
    3 : Ext:='.html';
    4 : Ext:='.xml';
    else exit;
  End;
  S:=Trim(FileNameEdit.Text); If S='' then exit;
  FileNameEdit.Text:=ChangeFileExt(S,Ext);
end;

procedure TExportGamesListForm.FileNameEditChange(Sender: TObject);
begin
  OKButton.Enabled:=(Trim(FileNameEdit.Text)<>'');
end;

procedure TExportGamesListForm.OKButtonClick(Sender: TObject);
Var Columns : TGamesListExportColumns;
    I : Integer;
begin
  Columns:=[];
  For I:=1 to ListBox.Items.Count-1 do If ListBox.Checked[I] then Columns:=Columns+[TGamesListExportColumn(I)];
  ExportGamesList(GameDB,FileNameEdit.Text,Columns,TGamesListExportFormat(ExportFormatComboBox.ItemIndex));
end;

procedure TExportGamesListForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileExportList);
end;

procedure TExportGamesListForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowExportGamesListDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  ExportGamesListForm:=TExportGamesListForm.Create(AOwner);
  try
    ExportGamesListForm.GameDB:=AGameDB;
    result:=(ExportGamesListForm.ShowModal=mrOK);
  finally
    ExportGamesListForm.Free;
  end;

end;

end.
