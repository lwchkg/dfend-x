unit BuildZipPackagesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, CheckLst, GameDBUnit, Menus;

type
  TBuildZipPackagesForm = class(TForm)
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    DestFolderEdit: TLabeledEdit;
    DestFolderButton: TSpeedButton;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    PopupMenu: TPopupMenu;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure DestFolderButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  BuildZipPackagesForm: TBuildZipPackagesForm;

Function ShowBuildZipPackagesDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, LanguageSetupUnit, VistaToolsUnit, CommonTools, GameDBToolsUnit,
     PrgSetupUnit, ZipPackageUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TBuildZipPackagesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.BuildZipPackages;

  InfoLabel.Caption:=LanguageSetup.BuildZipPackagesInfo;
  DestFolderEdit.EditLabel.Caption:=LanguageSetup.BuildZipPackagesDestFolder;
  DestFolderButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  UserIconLoader.DialogImage(DI_SelectFolder,DestFolderButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TBuildZipPackagesForm.FormShow(Sender: TObject);
begin
  DestFolderEdit.Text:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY));

  BuildCheckList(ListBox,GameDB,False,False,True);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False,True);
end;

procedure TBuildZipPackagesForm.SelectButtonClick(Sender: TObject);
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

procedure TBuildZipPackagesForm.DestFolderButtonClick(Sender: TObject);
Var S : String;
begin
  S:=MakeAbsPath(DestFolderEdit.Text,PrgSetup.BaseDir);
  If not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  DestFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TBuildZipPackagesForm.OKButtonClick(Sender: TObject);
Var Dir : String;
    I : Integer;
    G : TGame;
begin
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(DestFolderEdit.Text,PrgSetup.BaseDir));
  If not ForceDirectories(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  Enabled:=False;
  try
    For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
      G:=TGame(ListBox.Items.Objects[I]);
      BuildZipPackage(self,G,Dir+ChangeFileExt(ExtractFileName(G.SetupFile),'.zip'),False);
    end;
  finally
    Enabled:=True;
  end;
end;

procedure TBuildZipPackagesForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileExportBuildZipPackages);
end;

procedure TBuildZipPackagesForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowBuildZipPackagesDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
Var BuildZipPackagesForm : TBuildZipPackagesForm;
begin
  BuildZipPackagesForm:=TBuildZipPackagesForm.Create(AOwner);
  try
    BuildZipPackagesForm.GameDB:=AGameDB;
    result:=(BuildZipPackagesForm.ShowModal=mrOK);
  finally
    BuildZipPackagesForm.Free;
  end;
end;


end.
