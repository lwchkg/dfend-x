unit SetupFrameGameListIconModeAppearanceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameGameListIconModeAppearance = class(TFrame, ISetupFrame)
    IconSizeRadioGroup: TRadioGroup;
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

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TSetupFrameGameListIconModeAppearance }

function TSetupFrameGameListIconModeAppearance.GetName: String;
begin
  result:=LanguageSetup.SetupFormGameListIconModeAppearance;
end;

procedure TSetupFrameGameListIconModeAppearance.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(IconSizeRadioGroup);

  Case Max(0,Min(256,PrgSetup.IconSize)) of
    0..47 : IconSizeRadioGroup.ItemIndex:=0;
   48..95 : IconSizeRadioGroup.ItemIndex:=1;
   96..191 : IconSizeRadioGroup.ItemIndex:=2;
   else  IconSizeRadioGroup.ItemIndex:=3;
  end;
end;

procedure TSetupFrameGameListIconModeAppearance.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameGameListIconModeAppearance.LoadLanguage;
begin
  IconSizeRadioGroup.Caption:=LanguageSetup.SetupFormGameListIconModeAppearanceIconSize;

  HelpContext:=ID_FileOptionsGameListInIconMode;
end;

procedure TSetupFrameGameListIconModeAppearance.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameGameListIconModeAppearance.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameGameListIconModeAppearance.HideFrame;
begin
end;

procedure TSetupFrameGameListIconModeAppearance.RestoreDefaults;
begin
  IconSizeRadioGroup.ItemIndex:=1;
end;

procedure TSetupFrameGameListIconModeAppearance.SaveSetup;
begin
  Case IconSizeRadioGroup.ItemIndex of
    0 : PrgSetup.IconSize:=32;
    1 : PrgSetup.IconSize:=64;
    2 : PrgSetup.IconSize:=128;
    3 : PrgSetup.IconSize:=256;
  end;
end;

end.
