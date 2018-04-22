unit CreateShortcutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, ExtCtrls;

type
  TCreateShortcutForm = class(TForm)
    DesktopRadioButton: TRadioButton;
    StartmenuRadioButton: TRadioButton;
    StartmenuEdit: TEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    UseProfileIconCheckBox: TCheckBox;
    LinkNameEdit: TLabeledEdit;
    LinkCommentEdit: TLabeledEdit;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StartmenuEditChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameName, GameFile, GameExeFile, GameIcon, WinGameParameters : String;
    GameScummVM, GameWindowsExe : Boolean;
  end;

var
  CreateShortcutForm: TCreateShortcutForm;

Function ShowCreateShortcutDialog(const AOwner : TComponent; const AGameName, AGameFileName, AGameIconFile, AGammExeName, AWinGameParameters : String; const AGameScummVM, AGameWindowsExe : Boolean) : Boolean;
Function CreateLinuxShortCut(const AOwner : TComponent; const Game : TGame) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     PrgConsts, GameDBToolsUnit, DosBoxUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TCreateShortcutForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CreateShortcutForm;
  LinkNameEdit.EditLabel.Caption:=LanguageSetup.CreateShortcutFormLinkName;
  LinkCommentEdit.EditLabel.Caption:=LanguageSetup.CreateShortcutFormLinkComment;
  DesktopRadioButton.Caption:=LanguageSetup.CreateShortcutFormDesktop;
  StartmenuRadioButton.Caption:=LanguageSetup.CreateShortcutFormStartmenu;
  UseProfileIconCheckBox.Caption:=LanguageSetup.CreateShortcutFormUseProfileIcon;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TCreateShortcutForm.FormShow(Sender: TObject);
begin
  UseProfileIconCheckBox.Enabled:=(GameIcon<>'') and FileExists(MakeAbsIconName(GameIcon));
  UseProfileIconCheckBox.Checked:=UseProfileIconCheckBox.Enabled;

  LinkNameEdit.Text:=GameName;
  If GameScummVM then begin
    LinkCommentEdit.Text:=Format(LanguageSetup.CreateShortcutFormRunGameInScummVM,[GameName]);
  end else begin
    If GameWindowsExe
      then LinkCommentEdit.Text:=Format(LanguageSetup.CreateShortcutFormRunGame,[GameName])
      else LinkCommentEdit.Text:=Format(LanguageSetup.CreateShortcutFormRunGameInDOSBox,[GameName]);
  end;
end;

procedure TCreateShortcutForm.OKButtonClick(Sender: TObject);
Var Dir,Icon,FileName : String;
begin
  If UseProfileIconCheckBox.Checked then Icon:=MakeAbsIconName(GameIcon) else Icon:='';

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

  FileName:=Dir+MakeFileSysOKFolderName(GameFile)+'.lnk';

  If GameWindowsExe then begin
    CreateLink(GameExeFile,WinGameParameters,FileName,Icon,LinkCommentEdit.Text);
  end else begin
    CreateLink(ExpandFileName(Application.ExeName),GameName,FileName,Icon,LinkCommentEdit.Text);
  end;
end;

procedure TCreateShortcutForm.StartmenuEditChange(Sender: TObject);
begin
  StartmenuRadioButton.Checked:=True;
end;

procedure TCreateShortcutForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileCreateShortCut);
end;

procedure TCreateShortcutForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCreateShortcutDialog(const AOwner : TComponent; const AGameName, AGameFileName, AGameIconFile, AGammExeName, AWinGameParameters : String; const AGameScummVM, AGameWindowsExe : Boolean) : Boolean;
begin
  CreateShortcutForm:=TCreateShortcutForm.Create(AOwner);
  try
    CreateShortcutForm.GameName:=AGameName;
    CreateShortcutForm.GameFile:=ChangeFileExt(ExtractFileName(AGameFileName),'');
    If AGameWindowsExe then CreateShortcutForm.GameExeFile:=MakeAbsPath(AGammExeName,PrgSetup.BaseDir);
    CreateShortcutForm.GameIcon:=AGameIconFile;
    CreateShortcutForm.GameScummVM:=AGameScummVM;
    CreateShortcutForm.GameWindowsExe:=AGameWindowsExe;
    CreateShortcutForm.WinGameParameters:=AWinGameParameters;
    result:=(CreateShortcutForm.ShowModal=mrOK);
  finally
    CreateShortcutForm.Free;
  end;
end;

Function CreateLinuxShortCut(const AOwner : TComponent; const Game : TGame) : Boolean;
Var SaveDialog : TSaveDialog;
    St,St2 : TStringList;
    ConfFile,S : String;
    DOSBoxNr : Integer;
begin
  result:=False;

  If ScummVMMode(Game) or WindowsExeMode(Game) then begin
    MessageDlg(LanguageSetup.CreateShortcutFormNoLinuxScummVMLinks,mtError,[mbOK],0);
    exit;
  end;

  SaveDialog:=TSaveDialog.Create(AOwner);
  try
    SaveDialog.Filter:=LanguageSetup.CreateShortcutFormFilter;
    SaveDialog.Title:=LanguageSetup.CreateShortcutForm;
    If not SaveDialog.Execute then exit;

    ConfFile:=IncludeTrailingPathDelimiter(ExtractFilePath(SaveDialog.FileName))+ExtractFileName(MakeAbsPath(ChangeFileExt(Game.SetupFile,'.conf'),PrgSetup.BaseDir));
    St:=TStringList.Create;
    try
      St2:=BuildConfFile(Game,False,False,-1,nil,false);
      if St2=nil then exit;
      try
        try
          St2.SaveToFile(ConfFile);
        except
          MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[ConfFile]),mtError,[mbOK],0); exit;
        end;
      finally
        St2.Free;
      end;
      If Trim(PrgSetup.LinuxShellScriptPreamble)<>'' then St.Add(PrgSetup.LinuxShellScriptPreamble);

      DOSBoxNr:=GetDOSBoxNr(Game);
      If DOSBoxNr>=0 then S:=MakeAbsPath(PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir,PrgSetup.BaseDir) else S:=Trim(Game.CustomDOSBoxDir);
      St.Add(UnmapDrive(IncludeTrailingPathDelimiter(S)+DosBoxFileName,ptDOSBox)+' -conf "'+UnmapDrive(ConfFile,ptDOSBox)+'"');
      try
        St.SaveToFile(SaveDialog.FileName);
      except
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
      end;
    finally
      St.Free;
    end;
  finally
    SaveDialog.Free;
  end;
end;

end.
