unit SetupFrameBaseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Spin, StdCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameBase = class(TFrame, ISetupFrame)
    MinimizeToTrayCheckBox: TCheckBox;
    StartWithWindowsCheckBox: TCheckBox;
    OnlySingleInstanceCheckBox: TCheckBox;
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
    Procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TSetupFrameBase }

function TSetupFrameBase.GetName: String;
begin
  result:=LanguageSetup.SetupFormGeneralSheet;
end;

procedure TSetupFrameBase.InitGUIAndLoadSetup(var InitData : TInitData);
begin
  NoFlicker(MinimizeToTrayCheckBox);
  NoFlicker(StartWithWindowsCheckBox);
  NoFlicker(OnlySingleInstanceCheckBox);

  MinimizeToTrayCheckBox.Checked:=PrgSetup.MinimizeToTray;
  StartWithWindowsCheckBox.Checked:=PrgSetup.StartWithWindows;
  OnlySingleInstanceCheckBox.Checked:=PrgSetup.SingleInstance;

  HelpContext:=ID_FileOptionsGeneral;
end;

procedure TSetupFrameBase.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameBase.LoadLanguage;
begin
  MinimizeToTrayCheckBox.Caption:=LanguageSetup.SetupFormMinimizeToTray;
  StartWithWindowsCheckBox.Caption:=LanguageSetup.SetupFormStartWithWindows;
  OnlySingleInstanceCheckBox.Caption:=LanguageSetup.SetupFormSingleInstance;
end;

procedure TSetupFrameBase.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameBase.ShowFrame(const AdvancedMode: Boolean);
begin
  StartWithWindowsCheckBox.Visible:=AdvancedMode;
  OnlySingleInstanceCheckBox.Visible:=AdvancedMode;
end;

procedure TSetupFrameBase.HideFrame;
begin
end;

procedure TSetupFrameBase.RestoreDefaults;
begin
  MinimizeToTrayCheckBox.Checked:=False;
  StartWithWindowsCheckBox.Checked:=False;
  OnlySingleInstanceCheckBox.Checked:=True;
end;

procedure TSetupFrameBase.SaveSetup;
begin
  PrgSetup.MinimizeToTray:=MinimizeToTrayCheckBox.Checked;
  PrgSetup.StartWithWindows:=StartWithWindowsCheckBox.Checked;
  SetStartWithWindows(PrgSetup.StartWithWindows);
  PrgSetup.SingleInstance:=OnlySingleInstanceCheckBox.Checked;
end;

end.
