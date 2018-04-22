unit SetupFrameDOSBoxExtUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, SetupFormUnit, GameDBUnit;

type
  TSetupFrameDOSBoxExt = class(TFrame, ISetupFrame)
    ScrollBox: TScrollBox;
    WarningLabel: TLabel;
    MountDialogGroupBox: TGroupBox;
    MultiFloppyImageCheckBox: TCheckBox;
    PhysFSCheckBox: TCheckBox;
    GraphicsGroupBox: TGroupBox;
    ExtendedTextModeCheckBox: TCheckBox;
    GlideEmulationCheckBox: TCheckBox;
    VGAChipsetCheckBox: TCheckBox;
    SoundGroupBox: TGroupBox;
    PrinterGroupBox: TGroupBox;
    PrinterCheckBox: TCheckBox;
    RenderModesCheckBox: TCheckBox;
    VideoModesCheckBox: TCheckBox;
    MIDICheckBox: TCheckBox;
    PixelShaderCheckBox: TCheckBox;
    NetworkGroupBox: TGroupBox;
    NE2000CheckBox: TCheckBox;
    InnovaCheckBox: TCheckBox;
    InfoLabel: TLabel;
    InfoURLLabel: TLabel;
    procedure DefaultValueChanged(Sender: TObject);
    procedure InfoURLLabelClick(Sender: TObject);
  private
    { Private-Deklarationen }
    GameDB : TGameDB;
    ValueChanged : Array[0..3] of Boolean;
    Function DefaultValueOnList(const List, Value : String) : Boolean;
    Function DefaultValueChange(const OldList, Value : String; const SetIt : Boolean) : String;
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

uses ShellAPI, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts;

{$R *.dfm}

{ TSetupFrameDOSBoxExt }

function TSetupFrameDOSBoxExt.GetName: String;
begin
  result:=LanguageSetup.SetupFormDosBoxCVSSheet;
end;

procedure TSetupFrameDOSBoxExt.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
begin
  GameDB:=InitData.GameDB;

  NoFlicker(MountDialogGroupBox);
  NoFlicker(MultiFloppyImageCheckBox);
  NoFlicker(PhysFSCheckBox);
  NoFlicker(GraphicsGroupBox);
  NoFlicker(ExtendedTextModeCheckBox);
  NoFlicker(GlideEmulationCheckBox);
  NoFlicker(VGAChipsetCheckBox);
  NoFlicker(RenderModesCheckBox);
  NoFlicker(VideoModesCheckBox);
  NoFlicker(PixelShaderCheckBox);
  NoFlicker(SoundGroupBox);
  NoFlicker(MIDICheckBox);
  NoFlicker(InnovaCheckBox);
  NoFlicker(PrinterGroupBox);
  NoFlicker(PrinterCheckBox);
  NoFlicker(NetworkGroupBox);
  NoFlicker(NE2000CheckBox);

  MultiFloppyImageCheckBox.Checked:=PrgSetup.AllowMultiFloppyImagesMount;
  PhysFSCheckBox.Checked:=PrgSetup.AllowPhysFSUsage;
  ExtendedTextModeCheckBox.Checked:=PrgSetup.AllowTextModeLineChange;
  GlideEmulationCheckBox.Checked:=PrgSetup.AllowGlideSettings;
  VGAChipsetCheckBox.Checked:=PrgSetup.AllowVGAChipsetSettings;

  I:=0;
  If DefaultValueOnList(GameDB.ConfOpt.Render,'openglhq') then inc(I);
  If DefaultValueOnList(GameDB.ConfOpt.Render,'direct3d') then inc(I);
  If I=1 then RenderModesCheckBox.State:=cbGrayed else RenderModesCheckBox.Checked:=(I=2);
  ValueChanged[0]:=False;

  VideoModesCheckBox.Checked:=DefaultValueOnList(GameDB.ConfOpt.Video,'demovga');
  ValueChanged[1]:=False;

  PixelShaderCheckBox.Checked:=PrgSetup.AllowPixelShader;
  ValueChanged[3]:=False;

  MIDICheckBox.Checked:=DefaultValueOnList(GameDB.ConfOpt.MIDIDevice,'mt32');
  ValueChanged[2]:=False;
  InnovaCheckBox.Checked:=PrgSetup.AllowInnova;

  PrinterCheckBox.Checked:=PrgSetup.AllowPrinterSettings;

  NE2000CheckBox.Checked:=PrgSetup.AllowNe2000;
end;

procedure TSetupFrameDOSBoxExt.DefaultValueChanged(Sender: TObject);
begin
  ValueChanged[(Sender as TComponent).Tag]:=True;
end;

function TSetupFrameDOSBoxExt.DefaultValueOnList(const List, Value: String): Boolean;
Var St : TStringList;
    I : Integer;
    S : String;
begin
  result:=False;

  S:=Trim(ExtUpperCase(Value));
  St:=ValueToList(List,';,');
  try
    For I:=0 to St.Count-1 do If Trim(ExtUpperCase(St[I]))=S then begin result:=True; exit; end;
  finally
    St.Free;
  end;
end;

procedure TSetupFrameDOSBoxExt.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDOSBoxExt.LoadLanguage;
begin
  WarningLabel.Caption:=LanguageSetup.SetupFormDosBoxCVSWarning;
  MountDialogGroupBox.Caption:=LanguageSetup.SetupFormDosBoxCVSMountGroup;
  MultiFloppyImageCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSMultipleFloppyImages;
  PhysFSCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSPhysFS;
  GraphicsGroupBox.Caption:=LanguageSetup.SetupFormDosBoxCVSGraphicsGroup;
  ExtendedTextModeCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSExtendedTextMode;
  GlideEmulationCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSGlideEmulation;
  VGAChipsetCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSVGAChipset;
  RenderModesCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSRenderModes;
  VideoModesCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSVideoModes;
  PixelShaderCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSPixelShader;
  SoundGroupBox.Caption:=LanguageSetup.SetupFormDosBoxCVSSoundGroup;
  MIDICheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSMidiModes;
  InnovaCheckBox.Caption:=LanguageSetup.SetupFormDOSBoxCVSInnova;
  PrinterGroupBox.Caption:=LanguageSetup.SetupFormDosBoxCVSPrinterGroup;
  PrinterCheckBox.Caption:=LanguageSetup.SetupFormDosBoxCVSPrinter;
  NetworkGroupBox.Caption:=LanguageSetup.SetupFormDOSBoxCVSNetworkGroup;
  NE2000CheckBox.Caption:=LanguageSetup.SetupFormDOSBoxCVSNetworkNE2000;

  InfoLabel.Caption:=LanguageSetup.SetupFormDOSBoxCVSInfo;
  InfoURLLabel.Caption:='http:/'+'/ykhwong.x-y.net/';
  with InfoURLLabel.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  InfoURLLabel.Cursor:=crHandPoint;

  HelpContext:=ID_FileOptionsDOSBoxCVSFeatures;
end;

procedure TSetupFrameDOSBoxExt.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDOSBoxExt.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameDOSBoxExt.HideFrame;
begin
end;

procedure TSetupFrameDOSBoxExt.RestoreDefaults;
begin
  MultiFloppyImageCheckBox.Checked:=False;
  PhysFSCheckBox.Checked:=False;
  ExtendedTextModeCheckBox.Checked:=False;
  GlideEmulationCheckBox.Checked:=False;
  VGAChipsetCheckBox.Checked:=False;
  PixelShaderCheckBox.Checked:=False;
  InnovaCheckBox.Checked:=False;
  PrinterCheckBox.Checked:=False;
  NE2000CheckBox.Checked:=False;
end;

function TSetupFrameDOSBoxExt.DefaultValueChange(const OldList, Value: String; const SetIt: Boolean): String;
Var St : TStringList;
    S : String;
    I : Integer;
begin
  result:=OldList;
  S:=Trim(ExtUpperCase(Value));
  St:=ValueToList(OldList,';,');
  try
    try
      If SetIt then begin
        For I:=0 to St.Count-1 do If Trim(ExtUpperCase(St[I]))=S then exit;
        St.Add(Value);
      end else begin
        I:=0; while I<St.Count do If Trim(ExtUpperCase(St[I]))=S then St.Delete(I) else inc(I);
      end;
    finally
      result:=ListToValue(St,';');
    end;
  finally
    St.Free;
  end;
end;

procedure TSetupFrameDOSBoxExt.SaveSetup;
begin
  PrgSetup.AllowMultiFloppyImagesMount:=MultiFloppyImageCheckBox.Checked;
  PrgSetup.AllowPhysFSUsage:=PhysFSCheckBox.Checked;
  PrgSetup.AllowTextModeLineChange:=ExtendedTextModeCheckBox.Checked;
  PrgSetup.AllowGlideSettings:=GlideEmulationCheckBox.Checked;
  PrgSetup.AllowVGAChipsetSettings:=VGAChipsetCheckBox.Checked;

  If ValueChanged[0] then begin
    GameDB.ConfOpt.Render:=DefaultValueChange(GameDB.ConfOpt.Render,'openglhq',RenderModesCheckBox.Checked);
    GameDB.ConfOpt.Render:=DefaultValueChange(GameDB.ConfOpt.Render,'direct3d',RenderModesCheckBox.Checked);
  end;

  If ValueChanged[1] then begin
    GameDB.ConfOpt.Video:=DefaultValueChange(GameDB.ConfOpt.Video,'demovga',VideoModesCheckBox.Checked);
  end;

  PrgSetup.AllowPixelShader:=PixelShaderCheckBox.Checked;
  If ValueChanged[3] then begin
    GameDB.ConfOpt.Scale:=DefaultValueChange(GameDB.ConfOpt.Scale,'Hardware 2x (hardware2x)',PixelShaderCheckBox.Checked);
    GameDB.ConfOpt.Scale:=DefaultValueChange(GameDB.ConfOpt.Scale,'Hardware 3x (hardware3x)',PixelShaderCheckBox.Checked);
  end;

  If ValueChanged[2] then begin
    GameDB.ConfOpt.MIDIDevice:=DefaultValueChange(GameDB.ConfOpt.MIDIDevice,'mt32',MIDICheckBox.Checked);
  end;
  PrgSetup.AllowInnova:=InnovaCheckBox.Checked;

  PrgSetup.AllowPrinterSettings:=PrinterCheckBox.Checked;

  PrgSetup.AllowNe2000:=NE2000CheckBox.Checked;
end;

procedure TSetupFrameDOSBoxExt.InfoURLLabelClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

end.
