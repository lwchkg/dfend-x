unit SetupFrameDefaultValuesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ComCtrls, Menus, SetupFormUnit, GameDBUnit;

type
  TSetupFrameDefaultValues = class(TFrame, ISetupFrame)
    DefaultValueLabel: TLabel;
    DefaultValueComboBox: TComboBox;
    DefaultValueMemo: TRichEdit;
    DefaultValueSpeedButton: TBitBtn;
    DefaultValuePopupMenu: TPopupMenu;
    PopupThisValue: TMenuItem;
    PopupAllValues: TMenuItem;
    procedure DefaultValueSpeedButtonClick(Sender: TObject);
    procedure DefaultValueComboBoxChange(Sender: TObject);
    procedure PopupMenuWork(Sender: TObject);
    procedure DefaultValueComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    GameDB : TGameDB;
    LastIndex : Integer;
    DefaultValueLists : Array of TStringList;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
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

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts, IconLoaderUnit, TextEditPopupUnit;

{$R *.dfm}

{ TSetupFrameDefaultValues }

Constructor TSetupFrameDefaultValues.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  LastIndex:=-1;
end;

destructor TSetupFrameDefaultValues.Destroy;
Var I : Integer;
begin
  for I:=0 to length(DefaultValueLists)-1 do DefaultValueLists[I].Free;
  inherited Destroy;
end;

function TSetupFrameDefaultValues.GetName: String;
begin
  result:=LanguageSetup.SetupFormDefaultValueSheet;
end;

procedure TSetupFrameDefaultValues.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  GameDB:=InitData.GameDB;

  NoFlicker(DefaultValueComboBox);

  SetRichEditPopup(DefaultValueMemo);

  UserIconLoader.DialogImage(DI_ResetDefault,DefaultValueSpeedButton);
end;

procedure TSetupFrameDefaultValues.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDefaultValues.LoadLanguage;
Procedure AddString(const Lang, S : String); begin DefaultValueComboBox.Items.AddObject(Lang,ValueToList(S,';,')); end;
Var I,J : Integer;
    P1,P2,S1,S2,S3,S4 : String;
begin
  DefaultValueLabel.Caption:=LanguageSetup.SetupFormDefaultValueLabel;
  DefaultValueSpeedButton.Caption:=LanguageSetup.SetupFormDefaultValueReset;
  DefaultValueMemo.Font.Name:='Courier New';
  PopupThisValue.Caption:=LanguageSetup.SetupFormDefaultValueResetThis;
  PopupAllValues.Caption:=LanguageSetup.SetupFormDefaultValueResetAll;

  I:=DefaultValueComboBox.ItemIndex;
  DefaultValueComboBox.ItemIndex:=-1;
  DefaultValueComboBoxChange(self);

  For J:=0 to DefaultValueComboBox.Items.Count-1 do TStringList(DefaultValueComboBox.Items.Objects[J]).Free;
  DefaultValueComboBox.Items.Clear;
  SetLength(DefaultValueLists,0);

  P1:='(DOSBox) ';
  P2:='(ScummVM) ';
  S1:='SoundBlaster ';
  S2:='GUS ';
  S3:='MIDI ';
  S4:='NE2000 ';

  AddString(P1+LanguageSetup.GameCore,GameDB.ConfOpt.Core);
  AddString(P1+LanguageSetup.GameCPUType,GameDB.ConfOpt.CPUType);
  AddString(P1+LanguageSetup.GameCycles,GameDB.ConfOpt.Cycles);
  AddString(P1+LanguageSetup.GameCyclesDown,GameDB.ConfOpt.CyclesDown);
  AddString(P1+LanguageSetup.GameCyclesUp,GameDB.ConfOpt.CyclesUp);

  AddString(P1+LanguageSetup.GameVideo,GameDB.ConfOpt.Video);
  AddString(P1+LanguageSetup.GameMemory,GameDB.ConfOpt.Memory);
  AddString(P1+LanguageSetup.GameFrameskip,GameDB.ConfOpt.Frameskip);
  AddString(P1+LanguageSetup.GameWindowResolution,GameDB.ConfOpt.ResolutionWindow);
  AddString(P1+LanguageSetup.GameFullscreenResolution,GameDB.ConfOpt.ResolutionFullscreen);
  AddString(P1+LanguageSetup.GameScale,GameDB.ConfOpt.Scale);
  AddString(P1+LanguageSetup.GameRender,GameDB.ConfOpt.Render);
  AddString(P1+LanguageSetup.GameVGAChipset,GameDB.ConfOpt.VGAChipsets);
  AddString(P1+LanguageSetup.GameVideoRam,GameDB.ConfOpt.VGAVideoRAM);
  AddString(P1+LanguageSetup.GameGlideEmulation,GameDB.ConfOpt.GlideEmulation);
  AddString(P1+LanguageSetup.GameGlideEmulationPort,GameDB.ConfOpt.GlideEmulationPort);
  AddString(P1+LanguageSetup.GameGlideEmulationLFB,GameDB.ConfOpt.GlideEmulationLFB);

  AddString(P1+LanguageSetup.GameKeyboardLayout,GameDB.ConfOpt.KeyboardLayout);
  AddString(P1+LanguageSetup.GameKeyboardCodepage,GameDB.ConfOpt.Codepage);
  AddString(P1+LanguageSetup.GameMouseSensitivity,GameDB.ConfOpt.MouseSensitivity);
  AddString(P1+LanguageSetup.GameReportedDOSVersion,GameDB.ConfOpt.ReportedDOSVersion);

  AddString(P1+LanguageSetup.ProfileEditorSoundSampleRate,GameDB.ConfOpt.Rate);
  AddString(P1+LanguageSetup.ProfileEditorSoundBlockSize,GameDB.ConfOpt.Blocksize);

  AddString(P1+LanguageSetup.GameSblaster,GameDB.ConfOpt.Sblaster);
  AddString(P1+S1+LanguageSetup.ProfileEditorSoundSBAddress,GameDB.ConfOpt.SBBase);
  AddString(P1+S1+LanguageSetup.ProfileEditorSoundSBIRQ,GameDB.ConfOpt.IRQ);
  AddString(P1+S1+LanguageSetup.ProfileEditorSoundSBDMA,GameDB.ConfOpt.Dma);
  AddString(P1+S1+LanguageSetup.ProfileEditorSoundSBHDMA,GameDB.ConfOpt.HDMA);
  AddString(P1+LanguageSetup.GameOplmode,GameDB.ConfOpt.Oplmode);
  AddString(P1+LanguageSetup.GameOplemu,GameDB.ConfOpt.OplEmu);
  AddString(P1+LanguageSetup.ProfileEditorSoundSBOplRate,GameDB.ConfOpt.OPLRate);

  AddString(P1+S2+LanguageSetup.ProfileEditorSoundGUSAddress,GameDB.ConfOpt.GUSBase);
  AddString(P1+S2+LanguageSetup.ProfileEditorSoundGUSRate,GameDB.ConfOpt.GUSRate);
  AddString(P1+S2+LanguageSetup.ProfileEditorSoundGUSIRQ,GameDB.ConfOpt.GUSIRQ);
  AddString(P1+S2+LanguageSetup.ProfileEditorSoundGUSDMA,GameDB.ConfOpt.GUSDma);

  AddString(P1+LanguageSetup.ProfileEditorSoundMIDIDevice,GameDB.ConfOpt.MIDIDevice);
  AddString(P1+S3+LanguageSetup.ProfileEditorSoundMIDIType,GameDB.ConfOpt.MPU401);
  AddString(P1+S3+LanguageSetup.ProfileEditorSoundMIDIMT32+' '+LanguageSetup.ProfileEditorSoundMIDIMT32Mode,GameDB.ConfOpt.MT32ReverbMode);
  AddString(P1+S3+LanguageSetup.ProfileEditorSoundMIDIMT32+' '+LanguageSetup.ProfileEditorSoundMIDIMT32Time,GameDB.ConfOpt.MT32ReverbTime);
  AddString(P1+S3+LanguageSetup.ProfileEditorSoundMIDIMT32+' '+LanguageSetup.ProfileEditorSoundMIDIMT32Level,GameDB.ConfOpt.MT32ReverbLevel);

  AddString(P1+LanguageSetup.ProfileEditorSoundInnovaSampleRate,GameDB.ConfOpt.InnovaEmulationSampleRate);
  AddString(P1+LanguageSetup.ProfileEditorSoundInnovaBaseAddress,GameDB.ConfOpt.InnovaEmulationBaseAddress);
  AddString(P1+LanguageSetup.ProfileEditorSoundInnovaQuality,GameDB.ConfOpt.InnovaEmulationQuality);

  AddString(P1+LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,GameDB.ConfOpt.PCRate);
  AddString(P1+LanguageSetup.ProfileEditorSoundMiscTandyRate,GameDB.ConfOpt.TandyRate);
  AddString(P1+LanguageSetup.GameJoysticks,GameDB.ConfOpt.Joysticks);

  AddString(P1+S4+LanguageSetup.GameNE2000BaseAddress,GameDB.ConfOpt.NE2000EmulationBaseAddress);
  AddString(P1+S4+LanguageSetup.GameNE2000Interrupt,GameDB.ConfOpt.NE2000EmulationInterrupt);

  AddString(P2+LanguageSetup.ProfileEditorScummVMPlatform,GameDB.ConfOpt.ScummVMPlatform);
  AddString(P2+LanguageSetup.ProfileEditorScummVMLanguageLong,GameDB.ConfOpt.ScummVMLanguages);
  AddString(P2+LanguageSetup.ProfileEditorScummVMRenderMode,GameDB.ConfOpt.ScummVMRenderMode);
  AddString(P2+LanguageSetup.ProfileEditorScummVMFilter,GameDB.ConfOpt.ScummVMFilter);
  AddString(P2+LanguageSetup.ProfileEditorScummVMMusicDriver,GameDB.ConfOpt.ScummVMMusicDriver);

  SetLength(DefaultValueLists,DefaultValueComboBox.Items.Count);
  For J:=0 to length(DefaultValueLists)-1 do DefaultValueLists[J]:=TStringList(DefaultValueComboBox.Items.Objects[J]);

  DefaultValueComboBox.ItemIndex:=Max(0,I);
  DefaultValueComboBoxChange(self);

  HelpContext:=ID_FileOptionsDefaultValues;
end;

procedure TSetupFrameDefaultValues.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDefaultValues.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameDefaultValues.HideFrame;
begin
end;

procedure TSetupFrameDefaultValues.RestoreDefaults;
begin
  PopupMenuWork(PopupAllValues);
end;

procedure TSetupFrameDefaultValues.SaveSetup;
Var I : Integer;
Function GetString : String; begin result:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[I]),','); inc(I); end;
begin
  DefaultValueComboBoxChange(self);

  I:=0;
  GameDB.ConfOpt.Core:=GetString;
  GameDB.ConfOpt.CPUType:=GetString;
  GameDB.ConfOpt.Cycles:=GetString;
  GameDB.ConfOpt.CyclesDown:=GetString;
  GameDB.ConfOpt.CyclesUp:=GetString;

  GameDB.ConfOpt.Video:=GetString;
  GameDB.ConfOpt.Memory:=GetString;
  GameDB.ConfOpt.Frameskip:=GetString;
  GameDB.ConfOpt.ResolutionWindow:=GetString;
  GameDB.ConfOpt.ResolutionFullscreen:=GetString;
  GameDB.ConfOpt.Scale:=GetString;
  GameDB.ConfOpt.Render:=GetString;
  GameDB.ConfOpt.VGAChipsets:=GetString;
  GameDB.ConfOpt.VGAVideoRAM:=GetString;
  GameDB.ConfOpt.GlideEmulation:=GetString;
  GameDB.ConfOpt.GlideEmulationPort:=GetString;
  GameDB.ConfOpt.GlideEmulationLFB:=GetString;

  GameDB.ConfOpt.KeyboardLayout:=GetString;
  GameDB.ConfOpt.Codepage:=GetString;
  GameDB.ConfOpt.MouseSensitivity:=GetString;
  GameDB.ConfOpt.ReportedDOSVersion:=GetString;

  GameDB.ConfOpt.Rate:=GetString;
  GameDB.ConfOpt.Blocksize:=GetString;

  GameDB.ConfOpt.Sblaster:=GetString;
  GameDB.ConfOpt.SBBase:=GetString;
  GameDB.ConfOpt.IRQ:=GetString;
  GameDB.ConfOpt.Dma:=GetString;
  GameDB.ConfOpt.HDMA:=GetString;
  GameDB.ConfOpt.Oplmode:=GetString;
  GameDB.ConfOpt.OplEmu:=GetString;
  GameDB.ConfOpt.OPLRate:=GetString;

  GameDB.ConfOpt.GUSBase:=GetString;
  GameDB.ConfOpt.GUSRate:=GetString;
  GameDB.ConfOpt.GUSIRQ:=GetString;
  GameDB.ConfOpt.GUSDma:=GetString;

  GameDB.ConfOpt.MIDIDevice:=GetString;
  GameDB.ConfOpt.MPU401:=GetString;
  GameDB.ConfOpt.MT32ReverbMode:=GetString;
  GameDB.ConfOpt.MT32ReverbTime:=GetString;
  GameDB.ConfOpt.MT32ReverbLevel:=GetString;

  GameDB.ConfOpt.InnovaEmulationSampleRate:=GetString;
  GameDB.ConfOpt.InnovaEmulationBaseAddress:=GetString;
  GameDB.ConfOpt.InnovaEmulationQuality:=GetString;

  GameDB.ConfOpt.PCRate:=GetString;
  GameDB.ConfOpt.TandyRate:=GetString;
  GameDB.ConfOpt.Joysticks:=GetString;

  GameDB.ConfOpt.NE2000EmulationBaseAddress:=GetString;
  GameDB.ConfOpt.NE2000EmulationInterrupt:=GetString;

  GameDB.ConfOpt.ScummVMPlatform:=GetString;
  GameDB.ConfOpt.ScummVMLanguages:=GetString;
  GameDB.ConfOpt.ScummVMRenderMode:=GetString;
  GameDB.ConfOpt.ScummVMFilter:=GetString;
  GameDB.ConfOpt.ScummVMMusicDriver:=GetString;
end;

procedure TSetupFrameDefaultValues.DefaultValueComboBoxChange(Sender: TObject);
begin
  If LastIndex>=0 then begin
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Clear;
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Assign(DefaultValueMemo.Lines);
  end;

  LastIndex:=DefaultValueComboBox.ItemIndex;
  DefaultValueMemo.Lines.Clear;
  If LastIndex<0 then exit;
  DefaultValueMemo.Lines.Assign(TStringList(DefaultValueComboBox.Items.Objects[LastIndex]));

  SetComboHint(DefaultValueComboBox);
end;

procedure TSetupFrameDefaultValues.DefaultValueComboBoxDropDown(Sender: TObject);
begin
  SetComboDropDownDropDownWidth(DefaultValueComboBox);
end;

procedure TSetupFrameDefaultValues.DefaultValueSpeedButtonClick(Sender: TObject);
Var P : TPoint;
begin
  P:=ClientToScreen(Point(DefaultValueSpeedButton.Left,DefaultValueSpeedButton.Top));
  DefaultValuePopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TSetupFrameDefaultValues.PopupMenuWork(Sender: TObject);
Var All : Boolean;
    I,J : Integer;
Procedure Work(S : String);
begin
  try
    If (I<>J) and (not All) then exit;
    TStringList(DefaultValueComboBox.Items.Objects[J]).Free;
    DefaultValueComboBox.Items.Objects[J]:=ValueToList(S,';,');
    DefaultValueLists[J]:=TStringList(DefaultValueComboBox.Items.Objects[J]);
  finally
    inc(J);
  end;
end;
begin
  All:=((Sender as TComponent).Tag=1);

  If LastIndex<0 then LastIndex:=DefaultValueComboBox.ItemIndex;

  I:=LastIndex; LastIndex:=-1; J:=0;

  Work(DefaultValuesCore);
  Work(DefaultValuesCPUType);
  Work(DefaultValueCycles);
  Work(DefaultValuesCyclesDown);
  Work(DefaultValuesCyclesUp);

  Work(DefaultValuesVideo);
  Work(DefaultValuesMemory);
  Work(DefaultValuesFrameSkip);
  Work(DefaultValuesResolutionWindow);
  Work(DefaultValuesResolutionFullscreen);
  Work(DefaultValuesScale);
  Work(DefaultValueRender);
  Work(DefaultValuesVGAChipsets);
  Work(DefaultValuesVGAVideoRAM);
  Work(DefaultValuesGlideEmulation);
  Work(DefaultValuesGlideEmulationPort);
  Work(DefaultValuesGlideEmulationLFB);

  Work(DefaultValuesKeyboardLayout);
  Work(DefaultValuesCodepage);
  Work(DefaultValuesMouseSensitivity);
  Work(DefaultValuesReportedDOSVersion);

  Work(DefaultValuesRate);
  Work(DefaultValuesBlocksize);

  Work(DefaultValuesSBlaster);
  Work(DefaultValuesSBBase);
  Work(DefaultValuesIRQ);
  Work(DefaultValuesDMA);
  Work(DefaultValuesHDMA);
  Work(DefaultValuesOPLModes);
  Work(DefaultValuesOplEmu);
  Work(DefaultValuesOPLRate);

  Work(DefaultValuesGUSBase);
  Work(DefaultValuesGUSRate);
  Work(DefaultValuesIRQ1);
  Work(DefaultValuesDMA1);

  Work(DefaultValuesMIDIDevice);
  Work(DefaultValuesMPU401);
  Work(DefaultValuesMT32ReverbMode);
  Work(DefaultValuesMT32ReverbTime);
  Work(DefaultValuesMT32ReverbLevel);

  Work(DefaultValuesInnovaEmulationSampleRate);
  Work(DefaultValuesInnovaEmulationBaseAddress);
  Work(DefaultValuesInnovaEmulationQuality);

  Work(DefaultValuesPCRate);
  Work(DefaultValuesTandyRate);
  Work(DefaultValuesJoysticks);

  Work(DefaultValuesNE2000EmulationBaseAddress);
  Work(DefaultValuesNE2000EmulationInterrupt);

  Work(DefaultValuesScummVMPlatform);
  Work(DefaultValuesScummVMLanguages);
  Work(DefaultValuesScummVMRenderMode);
  Work(DefaultValuesScummVMFilter);
  Work(DefaultValuesScummVMMusicDriver);

  DefaultValueComboBox.ItemIndex:=I; DefaultValueComboBoxChange(Sender);
end;

end.
