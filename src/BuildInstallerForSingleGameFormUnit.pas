unit BuildInstallerForSingleGameFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GameDBUnit;

type
  TBuildInstallerForSingleGameForm = class(TForm)
    InstTypeRadioGroup: TRadioGroup;
    DestFileEdit: TLabeledEdit;
    DestFileButton: TSpeedButton;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SaveDialog: TSaveDialog;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure DestFileButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    function BuildNSIScript: Boolean;
  public
    { Public-Deklarationen }
    Game : TGame;
  end;

var
  BuildInstallerForSingleGameForm: TBuildInstallerForSingleGameForm;

Function BuildInstallerForSingleGame(const AOwner : TComponent; const AGame : TGame) : Boolean;

implementation

uses Registry, ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit,
     CommonTools, PrgConsts, BuildInstallerFormUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TBuildInstallerForSingleGameForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.BuildInstaller;
  DestFileEdit.EditLabel.Caption:=LanguageSetup.BuildInstallerDestFile;
  DestFileButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  InstTypeRadioGroup.Caption:=LanguageSetup.BuildInstallerInstType;
  InstTypeRadioGroup.Items[0]:=LanguageSetup.BuildInstallerInstTypeScriptOnly;
  InstTypeRadioGroup.Items[1]:=LanguageSetup.BuildInstallerInstTypeFullInstaller;
  SaveDialog.Title:=LanguageSetup.BuildInstallerDestFileTitle;
  SaveDialog.Filter:=LanguageSetup.BuildInstallerDestFileFilter;
  UserIconLoader.DialogImage(DI_SelectFile,DestFileButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TBuildInstallerForSingleGameForm.FormShow(Sender: TObject);
begin
  Caption:=Caption+' ['+Game.Name+']';
  DestFileEdit.Text:=ExtractFileName(ChangeFileExt(Game.SetupFile,''));
end;

procedure TBuildInstallerForSingleGameForm.DestFileButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(DestFileEdit.Text);
  If (S='') or (Trim(ExtractFilePath(S))='') then SaveDialog.InitialDir:=PrgDataDir else SaveDialog.InitialDir:=Trim(ExtractFilePath(S));
  If not SaveDialog.Execute then exit;
  DestFileEdit.Text:=SaveDialog.FileName;
end;

function TBuildInstallerForSingleGameForm.BuildNSIScript: Boolean;
Var NSIFileName : String;
    St : TStringList;
begin
  result:=False;
  NSIFileName:=Trim(DestFileEdit.Text);
  If NSIFileName='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    exit;
  end;
  NSIFileName:=ChangeFileExt(NSIFileName,'.nsi');

  if not CheckPath(ExtractFilePath(NSIFileName)) then exit;

  If FileExists(NSIFileName) then begin
    If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[NSIFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  end;

  St:=TStringList.Create;
  try
    St.Add('OutFile "'+ExtractFileName(DestFileEdit.Text)+'"');
    St.Add('!include ".\'+SettingsFolder+'\'+NSIInstallerHelpFile+'"');

    if not AddGameToNSIScript(St,Game) then exit;

    try
      St.SaveToFile(NSIFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NSIFileName]),mtError,[mbOK],0);
      exit;
    end;

  finally
    St.Free;
  end;
  result:=True;
end;

procedure TBuildInstallerForSingleGameForm.OKButtonClick(Sender: TObject);
begin
  If (Trim(ExtractFilePath(DestFileEdit.Text))='') and (Trim(DestFileEdit.Text)<>'') then
    DestFileEdit.Text:=PrgDataDir+DestFileEdit.Text;
  If Trim(DestFileEdit.Text)<>'' then DestFileEdit.Text:=ChangeFileExt(DestFileEdit.Text,'.exe');

  If not BuildNSIScript then begin ModalResult:=mrNone; exit; end;
  If InstTypeRadioGroup.ItemIndex=1 then begin
    If not BuildEXEInstaller(Handle,DestFileEdit.Text) then begin ModalResult:=mrNone; exit; end;
  end;
end;

procedure TBuildInstallerForSingleGameForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileMakeInstallerPackage);
end;

procedure TBuildInstallerForSingleGameForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function BuildInstallerForSingleGame(const AOwner : TComponent; const AGame : TGame) : Boolean;
begin
  BuildInstallerForSingleGameForm:=TBuildInstallerForSingleGameForm.Create(AOwner);
  try
    BuildInstallerForSingleGameForm.Game:=AGame;
    result:=(BuildInstallerForSingleGameForm.ShowModal=mrOK);
  finally
    BuildInstallerForSingleGameForm.Free;
  end;
end;

end.
