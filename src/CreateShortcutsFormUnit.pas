unit CreateShortcutsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons, Menus, ExtCtrls, GameDBUnit;

type
  TCreateShortcutsForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    UseProfileIconCheckBox: TCheckBox;
    StartmenuEdit: TEdit;
    StartmenuRadioButton: TRadioButton;
    DesktopRadioButton: TRadioButton;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    InfoLabel: TLabel;
    FolderEdit: TLabeledEdit;
    SelectFolderButton: TSpeedButton;
    PopupMenu: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure StartmenuEditChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
    procedure SelectFolderButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  CreateShortcutsForm: TCreateShortcutsForm;

Function ShowCreateShortcutsDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;  

implementation

uses ShlObj, LanguageSetupUnit, VistaToolsUnit, CommonTools, HelpConsts,
     PrgSetupUnit, GameDBToolsUnit, CreateShortcutFormUnit, IconLoaderUnit;

{$R *.dfm}

procedure TCreateShortcutsForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CreateShortcutsCaption;

  InfoLabel.Caption:=LanguageSetup.CreateShortcutsInfo;
  FolderEdit.EditLabel.Caption:=LanguageSetup.CreateShortcutsInfoWine;
  SelectFolderButton.Hint:=LanguageSetup.ChooseFolder;

  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  DesktopRadioButton.Caption:=LanguageSetup.CreateShortcutFormDesktop;
  StartmenuRadioButton.Caption:=LanguageSetup.CreateShortcutFormStartmenu;
  UseProfileIconCheckBox.Caption:=LanguageSetup.CreateShortcutsUseProfileIcons;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  If WineSupportEnabled and PrgSetup.LinuxLinkMode then begin
    DesktopRadioButton.Visible:=False;
    StartmenuRadioButton.Visible:=False;
    StartmenuEdit.Visible:=False;
    UseProfileIconCheckBox.Visible:=False;
    FolderEdit.Visible:=True;
    SelectFolderButton.Visible:=True;
    OKButton.Top:=FolderEdit.Top+FolderEdit.Height+15;
    CancelButton.Top:=FolderEdit.Top+FolderEdit.Height+15;
    HelpButton.Top:=FolderEdit.Top+FolderEdit.Height+15;
    ClientHeight:=OKButton.Top+OKButton.Height+10;
  end;

  FolderEdit.Text:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);

  UserIconLoader.DialogImage(DI_SelectFolder,SelectFolderButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TCreateShortcutsForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,True,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,True,True);
end;

procedure TCreateShortcutsForm.SelectButtonClick(Sender: TObject);
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

procedure TCreateShortcutsForm.StartmenuEditChange(Sender: TObject);
begin
  StartmenuRadioButton.Checked:=True;
end;

procedure TCreateShortcutsForm.SelectFolderButtonClick(Sender: TObject);
Var S : String;
begin
  S:=FolderEdit.Text; If S='' then S:=PrgDataDir;
  if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then FolderEdit.Text:=S;
end;

procedure TCreateShortcutsForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    G : TGame;
    Dir,LinkFile,Icon : String;
begin
  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    If WineSupportEnabled and PrgSetup.LinuxLinkMode then begin
      CreateLinuxShortCut(self,G);
    end else begin

      If UseProfileIconCheckBox.Checked and (G.Icon<>'') and FileExists(MakeAbsIconName(G.Icon)) then Icon:=MakeAbsIconName(G.Icon) else Icon:='';

      If DesktopRadioButton.Checked then begin
        Dir:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY));
      end else begin
        Dir:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_PROGRAMS));
        Dir:=Dir+StartmenuEdit.Text+'\';
        if not ForceDirectories(Dir) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
          exit;
        end;
      end;
      LinkFile:=Dir+MakeFileSysOKFolderName(G.Name)+'.lnk';

      If WindowsExeMode(G) then begin
        CreateLink(MakeAbsPath(G.GameExe,PrgSetup.BaseDir),G.GameParameters,LinkFile,Icon,Format(LanguageSetup.CreateShortcutFormRunGameInScummVM,[G.Name]));
      end else begin
        If ScummVMMode(G) then begin
          CreateLink(ExpandFileName(Application.ExeName),G.Name,LinkFile,Icon,Format(LanguageSetup.CreateShortcutFormRunGameInScummVM,[G.Name]));
        end else begin
          CreateLink(ExpandFileName(Application.ExeName),G.Name,LinkFile,Icon,Format(LanguageSetup.CreateShortcutFormRunGameInDOSBox,[G.Name]));
        end;
      end;
    end;
  end;
end;

procedure TCreateShortcutsForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasCreateShortcuts);
end;

procedure TCreateShortcutsForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCreateShortcutsDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  CreateShortcutsForm:=TCreateShortcutsForm.Create(AOwner);
  try
    CreateShortcutsForm.GameDB:=AGameDB;
    result:=(CreateShortcutsForm.ShowModal=mrOK);
  finally
    CreateShortcutsForm.Free;
  end;
end;



end.
