unit SetupFrameDOSBoxGlobalUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SetupFormUnit, Spin;

type
  TSetupFrameDOSBoxGlobal = class(TFrame, ISetupFrame)
    GlobalGroupBox: TGroupBox;
    MinimizeDFendCheckBox: TCheckBox;
    RestoreWindowCheckBox: TCheckBox;
    UseShortPathNamesCheckBox: TCheckBox;
    ShortNameWarningsCheckBox: TCheckBox;
    CreateConfFilesCheckBox: TCheckBox;
    DOSBoxFailedLabel: TLabel;
    DOSBoxFailedEdit: TSpinEdit;
    procedure MinimizeDFendCheckBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Math, LanguageSetupUnit, PrgSetupUnit, VistaToolsUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameDOSBoxGlobal }

function TSetupFrameDOSBoxGlobal.GetName: String;
begin
  result:=LanguageSetup.SetupFormDosBoxGlobalSheet;
end;

procedure TSetupFrameDOSBoxGlobal.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(GlobalGroupBox);
  NoFlicker(MinimizeDFendCheckBox);
  NoFlicker(RestoreWindowCheckBox);
  NoFlicker(UseShortPathNamesCheckBox);
  NoFlicker(ShortNameWarningsCheckBox);
  NoFlicker(CreateConfFilesCheckBox);
  NoFlicker(DOSBoxFailedEdit);

  GlobalGroupBox.Caption:=LanguageSetup.SetupFormDOSBoxInstallationGlobal;
  MinimizeDFendCheckBox.Checked:=PrgSetup.MinimizeOnDosBoxStart;
  RestoreWindowCheckBox.Checked:=PrgSetup.RestoreWhenDOSBoxCloses;
  UseShortPathNamesCheckBox.Checked:=PrgSetup.UseShortFolderNames;
  ShortNameWarningsCheckBox.Checked:=PrgSetup.ShowShortNameWarnings;
  CreateConfFilesCheckBox.Checked:=PrgSetup.CreateConfFilesForProfiles and (OperationMode<>omPortable);
  DOSBoxFailedEdit.Value:=Min(60,Max(1,PrgSetup.DOSBoxStartFailedTimeout));

  MinimizeDFendCheckBoxClick(self);

  HelpContext:=ID_FileOptionsDOSBoxGlobal;
end;

procedure TSetupFrameDOSBoxGlobal.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDOSBoxGlobal.LoadLanguage;
begin
  MinimizeDFendCheckBox.Caption:=LanguageSetup.SetupFormMinimizeDFend;
  RestoreWindowCheckBox.Caption:=LanguageSetup.SetupFormRestoreWindow;
  UseShortPathNamesCheckBox.Caption:=LanguageSetup.SetupFormUseShortPathNames;
  ShortNameWarningsCheckBox.Caption:=LanguageSetup.SetupFormShortNameWarnings;
  CreateConfFilesCheckBox.Caption:=LanguageSetup.SetupFormAlwaysCreateConfFiles;
  DOSBoxFailedLabel.Caption:=LanguageSetup.SetupFormDOSBoxStartFailedTimeout;
end;

procedure TSetupFrameDOSBoxGlobal.MinimizeDFendCheckBoxClick(Sender: TObject);
begin
  RestoreWindowCheckBox.Enabled:=MinimizeDFendCheckBox.Checked;
end;

procedure TSetupFrameDOSBoxGlobal.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDOSBoxGlobal.ShowFrame(const AdvancedMode: Boolean);
begin
  CreateConfFilesCheckBox.Enabled:=(OperationMode<>omPortable);
end;

procedure TSetupFrameDOSBoxGlobal.HideFrame;
begin
end;

procedure TSetupFrameDOSBoxGlobal.RestoreDefaults;
begin
  MinimizeDFendCheckBox.Checked:=False;
  RestoreWindowCheckBox.Checked:=False;
  UseShortPathNamesCheckBox.Checked:=True;
  ShortNameWarningsCheckBox.Checked:=True;
  CreateConfFilesCheckBox.Checked:=False;
  DOSBoxFailedEdit.Value:=3;
  MinimizeDFendCheckBoxClick(self);
end;

procedure TSetupFrameDOSBoxGlobal.SaveSetup;
begin
  PrgSetup.MinimizeOnDosBoxStart:=MinimizeDFendCheckBox.Checked;
  PrgSetup.RestoreWhenDOSBoxCloses:=RestoreWindowCheckBox.Checked;
  PrgSetup.UseShortFolderNames:=UseShortPathNamesCheckBox.Checked;
  PrgSetup.ShowShortNameWarnings:=ShortNameWarningsCheckBox.Checked;
  PrgSetup.CreateConfFilesForProfiles:=CreateConfFilesCheckBox.Checked;
  PrgSetup.DOSBoxStartFailedTimeout:=DOSBoxFailedEdit.Value;
end;

end.
