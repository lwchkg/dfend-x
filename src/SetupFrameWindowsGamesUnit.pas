unit SetupFrameWindowsGamesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFrameWindowsGames = class(TFrame, ISetupFrame)
    MinimizeDFendCheckBox: TCheckBox;
    RestoreWindowCheckBox: TCheckBox;
    AutoRestoreInfoLabel: TLabel;
    AllowWindowsPackagesCheckBox: TCheckBox;
    AllowWindowsPackagesLabel: TLabel;
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameWindowsGames }

function TSetupFrameWindowsGames.GetName: String;
begin
  result:=LanguageSetup.SetupFormWindows;
end;

procedure TSetupFrameWindowsGames.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(MinimizeDFendCheckBox);
  NoFlicker(RestoreWindowCheckBox);

  MinimizeDFendCheckBox.Checked:=PrgSetup.MinimizeOnWindowsGameStart;
  RestoreWindowCheckBox.Checked:=PrgSetup.RestoreWhenWindowsGameCloses;

  AllowWindowsPackagesCheckBox.Checked:=PrgSetup.AllowPackingWindowsGames;

  MinimizeDFendCheckBoxClick(self);
end;

procedure TSetupFrameWindowsGames.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameWindowsGames.LoadLanguage;
begin
  MinimizeDFendCheckBox.Caption:=LanguageSetup.SetupFormWindowsMinimizeDFendWindowsGame;
  RestoreWindowCheckBox.Caption:=LanguageSetup.SetupFormWindowsRestoreWhenWindowsGameCloses;
  AutoRestoreInfoLabel.Caption:=LanguageSetup.SetupFormWindowsRestoreWhenWindowsGameClosesInfo;
  AllowWindowsPackagesCheckBox.Caption:=LanguageSetup.SetupFormWindowsAllowPackages;
  AllowWindowsPackagesLabel.Caption:=LanguageSetup.SetupFormWindowsAllowPackagesInfo;

  HelpContext:=ID_FileOptionsWindows;
end;

procedure TSetupFrameWindowsGames.MinimizeDFendCheckBoxClick(Sender: TObject);
begin
  RestoreWindowCheckBox.Enabled:=MinimizeDFendCheckBox.Checked;
end;

procedure TSetupFrameWindowsGames.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameWindowsGames.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameWindowsGames.HideFrame;
begin
end;

procedure TSetupFrameWindowsGames.RestoreDefaults;
begin
  MinimizeDFendCheckBox.Checked:=False;
  RestoreWindowCheckBox.Checked:=False;
  AllowWindowsPackagesCheckBox.Checked:=False;
  MinimizeDFendCheckBoxClick(self);
end;

procedure TSetupFrameWindowsGames.SaveSetup;
begin
  PrgSetup.MinimizeOnWindowsGameStart:=MinimizeDFendCheckBox.Checked;
  PrgSetup.RestoreWhenWindowsGameCloses:=RestoreWindowCheckBox.Checked;
  PrgSetup.AllowPackingWindowsGames:=AllowWindowsPackagesCheckBox.Checked;
end;

end.
