unit SetupFrameCompressionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameCompression = class(TFrame, ISetupFrame)
    CompressRadioGroup: TRadioGroup;
    InfoLabel: TLabel;
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

{ TSetupFrameCompression }

function TSetupFrameCompression.GetName: String;
begin
  result:=LanguageSetup.SetupFormCompression;
end;

procedure TSetupFrameCompression.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(CompressRadioGroup);

  CompressRadioGroup.ItemIndex:=Max(0,Min(4,PrgSetup.CompressionLevel));
end;

procedure TSetupFrameCompression.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameCompression.LoadLanguage;
begin
  CompressRadioGroup.Caption:=LanguageSetup.SetupFormCompressionInfo;

  CompressRadioGroup.Items[0]:=LanguageSetup.SetupFormCompressionStore;
  CompressRadioGroup.Items[1]:=LanguageSetup.SetupFormCompressionFast;
  CompressRadioGroup.Items[2]:=LanguageSetup.SetupFormCompressionNormal;
  CompressRadioGroup.Items[3]:=LanguageSetup.SetupFormCompressionGood;
  CompressRadioGroup.Items[4]:=LanguageSetup.SetupFormCompressionMaximum;
  InfoLabel.Caption:=LanguageSetup.SetupFormCompressionInfoLabel;

  HelpContext:=ID_FileOptionsCompressionSettings;
end;

procedure TSetupFrameCompression.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameCompression.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameCompression.HideFrame;
begin
end;

procedure TSetupFrameCompression.RestoreDefaults;
begin
  CompressRadioGroup.ItemIndex:=3;
end;

procedure TSetupFrameCompression.SaveSetup;
begin
  PrgSetup.CompressionLevel:=CompressRadioGroup.ItemIndex;
end;

end.
