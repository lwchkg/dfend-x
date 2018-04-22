unit UpdateCheckFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, LinkFileUnit;

type
  TUpdateCheckForm = class(TForm)
    CheckBoxProgram: TCheckBox;
    CheckBoxPackages: TCheckBox;
    InfoLabelProgram: TLabel;
    InfoLabelPackages: TLabel;
    CheckBoxCheats: TCheckBox;
    InfoLabelCheats: TLabel;
    CheckBoxDatareader: TCheckBox;
    InfoLabelDatareader: TLabel;
    UpdateButton: TBitBtn;
    CloseButton: TBitBtn;
    LabelDownload: TLabel;
    DFRHomepageLabel: TLabel;
    SetupButton: TBitBtn;
    StatusLabelProgram: TLabel;
    StatusLabelPackages: TLabel;
    StatusLabelCheats: TLabel;
    StatusLabelDatareader: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DFRHomepageLabelClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Procedure UpdateWindow;
    Procedure SetStatus(const ALabel : TLabel; const AText : String; const AColor : TColor);
    Procedure UpdateProgram;
    Procedure UpdatePackagesDB;
    Procedure UpdateCheatsDB;
    Procedure UpdateDataReader; 
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  UpdateCheckForm: TUpdateCheckForm;

Procedure ShowUpdateCheckDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ANoConfigButton : Boolean = False);
Procedure RunProgramStartSilentUpdateCheck(const AForm : TForm; const ForceCheck : Boolean);

implementation

uses ShellAPI, Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     IconLoaderUnit, ProgramUpdateCheckUnit, CheatDBToolsUnit, SetupFormUnit,
     DataReaderMobyUnit, InternetDataWaitFormUnit, PackageDBToolsUnit, PrgConsts;

{$R *.dfm}

const clDarkYellow=TColor($00E0E0);

procedure TUpdateCheckForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.UpdateCheckDialog;
  CheckBoxProgram.Caption:=LanguageSetup.UpdateCheckDialogProgram;
  InfoLabelProgram.Caption:=LanguageSetup.UpdateCheckDialogProgramInfo;
  CheckBoxPackages.Caption:=LanguageSetup.UpdateCheckDialogPackages;
  InfoLabelPackages.Caption:=LanguageSetup.UpdateCheckDialogPackagesInfo;
  CheckBoxCheats.Caption:=LanguageSetup.UpdateCheckDialogCheats;
  InfoLabelCheats.Caption:=LanguageSetup.UpdateCheckDialogCheatsInfo;
  CheckBoxDatareader.Caption:=LanguageSetup.UpdateCheckDialogDataReader;
  InfoLabelDatareader.Caption:=LanguageSetup.UpdateCheckDialogDataReaderInfo;
  LabelDownload.Caption:=LanguageSetup.UpdateCheckDialogDownload;
  UpdateButton.Caption:=LanguageSetup.UpdateCheckDialogUpdate;
  CloseButton.Caption:=LanguageSetup.Close;
  SetupButton.Caption:=LanguageSetup.UpdateCheckDialogAutoUpdate;

  UserIconLoader.DialogImage(DI_Update,UpdateButton);
  UserIconLoader.DialogImage(DI_Close,CloseButton);
  UserIconLoader.DirectLoad('Main',6,SetupButton);

  CheckBoxProgram.Font.Style:=[fsBold];
  CheckBoxPackages.Font.Style:=[fsBold];
  CheckBoxCheats.Font.Style:=[fsBold];
  CheckBoxDatareader.Font.Style:=[fsBold];

  SetStatus(StatusLabelProgram,LanguageSetup.UpdateCheckDialogStatusNotYetChecked,clGrayText);
  SetStatus(StatusLabelPackages,LanguageSetup.UpdateCheckDialogStatusNotYetChecked,clGrayText);
  SetStatus(StatusLabelCheats,LanguageSetup.UpdateCheckDialogStatusNotYetChecked,clGrayText);
  SetStatus(StatusLabelDatareader,LanguageSetup.UpdateCheckDialogStatusNotYetChecked,clGrayText);

  DFRHomepageLabel.Caption:=LanguageSetup.MenuHelpUpdatesURL;
  with DFRHomepageLabel.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  DFRHomepageLabel.Cursor:=crHandPoint;

  ClientWidth:=Max(ClientWidth,2*LabelDownload.Left+LabelDownload.Width);
end;

procedure TUpdateCheckForm.SetStatus(const ALabel: TLabel; const AText: String; const AColor: TColor);
begin
  ALabel.Caption:=AText;
  ALabel.Font.Color:=AColor;
  UpdateWindow;
end;

procedure TUpdateCheckForm.UpdateWindow;
begin
  Invalidate;
  Paint;
  Application.ProcessMessages;
end;

procedure TUpdateCheckForm.DFRHomepageLabelClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

procedure TUpdateCheckForm.UpdateButtonClick(Sender: TObject);
begin
  Enabled:=False;
  UpdateButton.Enabled:=False;
  CloseButton.Enabled:=False;
  SetupButton.Enabled:=False;
  try
    If CheckBoxDatareader.Checked then UpdateDataReader;
    If CheckBoxCheats.Checked then UpdateCheatsDB;
    If CheckBoxPackages.Checked then UpdatePackagesDB;
    If CheckBoxProgram.Checked then UpdateProgram;
  finally
    Enabled:=True;
    UpdateButton.Enabled:=True;
    CloseButton.Enabled:=True;
    SetupButton.Enabled:=True;
  end;
end;

procedure TUpdateCheckForm.UpdateProgram;
begin
  SetStatus(StatusLabelProgram,LanguageSetup.UpdateCheckDialogStatusSearching,clDarkYellow);
  Case RunUpdateCheck(self,True,False) of
    urNoUpdatesAvailable : SetStatus(StatusLabelProgram,LanguageSetup.UpdateCheckDialogStatusNoUpdates,clGreen);
    urUpdateAvailable : SetStatus(StatusLabelProgram,LanguageSetup.UpdateCheckDialogStatusProgramNewVersionAvailable,clDarkYellow);
    urUpdateInstallCanceled : SetStatus(StatusLabelProgram,LanguageSetup.UpdateCheckDialogStatusAborted,clRed);
  end;
  BringWindowToTop(Handle);
end;

procedure TUpdateCheckForm.UpdatePackagesDB;
begin
  SetStatus(StatusLabelPackages,LanguageSetup.UpdateCheckDialogStatusSearching,clDarkYellow);
  If UpdatePackageDB(self,((Word(GetKeyState(VK_LSHIFT)) div 256)<>0) or ((Word(GetKeyState(VK_RSHIFT)) div 256)<>0),False) then begin
    SetStatus(StatusLabelPackages,LanguageSetup.UpdateCheckDialogStatusPackagesDone,clGreen);
  end else begin
    SetStatus(StatusLabelPackages,LanguageSetup.UpdateCheckDialogStatusAborted,clRed);
  end;

  BringWindowToTop(Handle);
end;

procedure TUpdateCheckForm.UpdateCheatsDB;
begin
  SetStatus(StatusLabelCheats,LanguageSetup.UpdateCheckDialogStatusSearching,clDarkYellow);
  Case CheatsDBUpdateCheck(self,False) of
    urNoUpdatesAvailable : SetStatus(StatusLabelCheats,LanguageSetup.UpdateCheckDialogStatusNoUpdates,clGreen);
    urUpdateInstallCanceled : SetStatus(StatusLabelCheats,LanguageSetup.UpdateCheckDialogStatusAborted,clRed);
    urUpdateInstalled : SetStatus(StatusLabelCheats,LanguageSetup.UpdateCheckDialogStatusCheatsDone,clGreen);
  end;
  BringWindowToTop(Handle);
end;

procedure TUpdateCheckForm.UpdateDataReader;
Var DataReader : TMobyDataReader;
    I : Integer;
begin
  SetStatus(StatusLabelDatareader,LanguageSetup.UpdateCheckDialogStatusSearching,clDarkYellow);
  DataReader:=TMobyDataReader.Create;
  try
    If not DataReader.LoadConfig(PrgDataDir+SettingsFolder+'\'+DataReaderConfigFile,False) then begin
      SetStatus(StatusLabelDatareader,Format(LanguageSetup.DataReaderDownloadError,[DataReaderUpdateURL]),clRed);
      exit;
    end;
    I:=DataReader.Config.Version;
    If ShowDataReaderInternetConfigWaitDialog(Owner,DataReader,True,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError) then begin
      If DataReader.Config.Version>I then begin
        SetStatus(StatusLabelDatareader,LanguageSetup.UpdateCheckDialogStatusDataReaderDone,clGreen);
      end else begin
        SetStatus(StatusLabelDatareader,LanguageSetup.UpdateCheckDialogStatusNoUpdates,clGreen);
      end;
    end else begin
      SetStatus(StatusLabelDatareader,LanguageSetup.UpdateCheckDialogStatusAborted,clRed);
    end;
  finally
    DataReader.Free;
  end;
  BringWindowToTop(Handle);
end;

Procedure ShowUpdateCheckDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ANoConfigButton : Boolean);
Var OpenSetup : Boolean;
begin
  UpdateCheckForm:=TUpdateCheckForm.Create(AOwner);
  try
    UpdateCheckForm.GameDB:=AGameDB;
    If ANoConfigButton then UpdateCheckForm.SetupButton.Visible:=False;
    OpenSetup:=(UpdateCheckForm.ShowModal=mrOK);
  finally
    UpdateCheckForm.Free;
  end;

  If OpenSetup then ShowUpdateSetupDialog(AOwner,AGameDB,ASearchLinkFile);
end;

Procedure RunProgramStartSilentUpdateCheck(const AForm : TForm; const ForceCheck : Boolean);
begin
  If ForceCheck then begin
    RunUpdateCheck(AForm,True,True);
  end else begin
    RunUpdateCheckIfSetup(AForm);
  end;
end;

end.
