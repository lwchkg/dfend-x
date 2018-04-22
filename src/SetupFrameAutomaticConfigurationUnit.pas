unit SetupFrameAutomaticConfigurationUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameAutomaticConfiguration = class(TFrame, ISetupFrame)
    ScrollBox: TScrollBox;
    InstallerNamesMemo: TMemo;
    InstallerNamesLabel: TLabel;
    WizardRadioGroup: TRadioGroup;
    ZipImportGroupBox: TGroupBox;
    ZipImportCheckBox: TCheckBox;
    ArchiveIDFilesLabel: TLabel;
    ArchiveIDFilesMemo: TMemo;
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

uses Math, PrgSetupUnit, LanguageSetupUnit, VistaToolsUnit, HelpConsts,
     CommonTools, PrgConsts;

{$R *.dfm}

{ TSetupFrameAutomaticConfiguration }

function TSetupFrameAutomaticConfiguration.GetName: String;
begin
  result:=LanguageSetup.SetupFormAutomaticConfiguration;
end;

procedure TSetupFrameAutomaticConfiguration.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
    St : TStringList;
begin
  WizardRadioGroup.Items.Clear;
  For I:=0 to 2 do WizardRadioGroup.Items.Add('');

  NoFlicker(ZipImportGroupBox);
  NoFlicker(ZipImportCheckBox);
  NoFlicker(WizardRadioGroup);
  NoFlicker(InstallerNamesMemo);
  NoFlicker(ArchiveIDFilesMemo);

  ZipImportCheckBox.Checked:=PrgSetup.ImportZipWithoutDialogIfPossible;
  WizardRadioGroup.ItemIndex:=Max(0,Min(2,PrgSetup.LastWizardMode));

  St:=ValueToList(PrgSetup.InstallerNames);
  try
    InstallerNamesMemo.Lines.Clear;
    InstallerNamesMemo.Lines.AddStrings(St);
  finally
    St.Free;
  end;

  St:=ValueToList(PrgSetup.ArchiveIDFiles);
  try
    ArchiveIDFilesMemo.Lines.Clear;
    ArchiveIDFilesMemo.Lines.AddStrings(St);
  finally
    St.Free;
  end;
end;

procedure TSetupFrameAutomaticConfiguration.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameAutomaticConfiguration.LoadLanguage;
Var I : Integer;
begin
  ZipImportGroupBox.Caption:=LanguageSetup.SetupFormAutomaticConfigurationArchiveImport;
  ZipImportCheckBox.Caption:=LanguageSetup.SetupFormAutomaticConfigurationArchiveImportNoDialog;
  I:=WizardRadioGroup.ItemIndex;
  WizardRadioGroup.Caption:=LanguageSetup.WizardFormWizardMode;
  WizardRadioGroup.Items[0]:=LanguageSetup.WizardFormWizardModeAlwaysAutomatically;
  WizardRadioGroup.Items[1]:=LanguageSetup.WizardFormWizardModeAutomaticallyIfAutoSetupTemplateExists;
  WizardRadioGroup.Items[2]:=LanguageSetup.WizardFormWizardModeAlwaysAllPages;
  WizardRadioGroup.ItemIndex:=I;
  InstallerNamesLabel.Caption:=LanguageSetup.SetupFormAutomaticConfigurationInstallerNames;
  ArchiveIDFilesLabel.Caption:=LanguageSetup.SetupFormAutomaticConfigurationArchiveIDFiles;

  HelpContext:=ID_FileOptionsAutomaticConfiguration;
end;

procedure TSetupFrameAutomaticConfiguration.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameAutomaticConfiguration.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameAutomaticConfiguration.HideFrame;
begin
end;

procedure TSetupFrameAutomaticConfiguration.RestoreDefaults;
Var St : TStringList;
begin
  PrgSetup.ImportZipWithoutDialogIfPossible:=True;
  PrgSetup.LastWizardMode:=1;
  St:=ValueToList(DefaultInstallerNames);
  try
    InstallerNamesMemo.Lines.Clear;
    InstallerNamesMemo.Lines.AddStrings(St);
  finally
    St.Free;
  end;
  St:=ValueToList(DefaultArchiveIDFiles);
  try
    ArchiveIDFilesMemo.Lines.Clear;
    ArchiveIDFilesMemo.Lines.AddStrings(St);
  finally
    St.Free;
  end;
end;

procedure TSetupFrameAutomaticConfiguration.SaveSetup;
Var St : TStringList;
    S : String;
    I : Integer;
begin
  PrgSetup.ImportZipWithoutDialogIfPossible:=ZipImportCheckBox.Checked;
  PrgSetup.LastWizardMode:=WizardRadioGroup.ItemIndex;
  St:=TStringList.Create;
  try
    For I:=0 to InstallerNamesMemo.Lines.Count-1 do begin
      S:=Trim(InstallerNamesMemo.Lines[I]);
      If S<>'' then St.Add(S);
    end;
    PrgSetup.InstallerNames:=ListToValue(St);
  finally
    St.Free;
  end;
  St:=TStringList.Create;
  try
    For I:=0 to ArchiveIDFilesMemo.Lines.Count-1 do begin
      S:=Trim(ArchiveIDFilesMemo.Lines[I]);
      If S<>'' then St.Add(S);
    end;
    PrgSetup.ArchiveIDFiles:=ListToValue(St);
  finally
    St.Free;
  end;
end;

end.
