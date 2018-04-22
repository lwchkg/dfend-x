unit ModernProfileEditorMIDIFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorMIDIFrame = class(TFrame, IModernProfileEditorFrame)
    TypeLabel: TLabel;
    TypeComboBox: TComboBox;
    DeviceLabel: TLabel;
    DeviceComboBox: TComboBox;
    AdditionalSettingsEdit: TLabeledEdit;
    MIDISelectButton: TButton;
    MIDISelectListBox: TListBox;
    MIDISelectLabel1: TLabel;
    MIDISelectLabel2: TLabel;
    InfoLabel: TLabel;
    MT32SettingsGroupBox: TGroupBox;
    MT32ModeComboBox: TComboBox;
    MT32TimeComboBox: TComboBox;
    MT32LevelComboBox: TComboBox;
    MT32ModeLabel: TLabel;
    MT32TimeLabel: TLabel;
    MT32LevelLabel: TLabel;
    procedure MIDISelectButtonClick(Sender: TObject);
    procedure MIDISelectListBoxClick(Sender: TObject);
    procedure DeviceComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts,
     PrgSetupUnit, MIDITools;

{$R *.dfm}

{ TModernProfileEditorMIDIFrame }

procedure TModernProfileEditorMIDIFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(TypeComboBox);
  NoFlicker(DeviceComboBox);
  NoFlicker(AdditionalSettingsEdit);
  NoFlicker(MIDISelectButton);
  NoFlicker(MIDISelectListBox);
  NoFlicker(MT32SettingsGroupBox);
  NoFlicker(MT32ModeComboBox);
  NoFlicker(MT32TimeComboBox);
  NoFlicker(MT32LevelComboBox);

  InfoLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIInfo;
  TypeLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIType;
  St:=ValueToList(InitData.GameDB.ConfOpt.MPU401,';,'); try TypeComboBox.Items.AddStrings(St); finally St.Free; end;
  DeviceLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIDevice;
  St:=ValueToList(InitData.GameDB.ConfOpt.MIDIDevice,';,'); try DeviceComboBox.Items.AddStrings(St); finally St.Free; end;
  AdditionalSettingsEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigInfo;
  MIDISelectButton.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigButton;
  MIDISelectLabel1.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigButtonInfo;
  MIDISelectLabel2.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigIDInfo;
  AddDefaultValueHint(TypeComboBox);
  AddDefaultValueHint(DeviceComboBox);

  MT32SettingsGroupBox.Caption:=LanguageSetup.ProfileEditorSoundMIDIMT32;
  MT32ModeLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIMT32Mode;
  MT32TimeLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIMT32Time;
  MT32LevelLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIMT32Level;

  St:=ValueToList(InitData.GameDB.ConfOpt.MT32ReverbMode,';,');
  try
    MT32ModeComboBox.Items.Clear;
    MT32ModeComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  St:=ValueToList(InitData.GameDB.ConfOpt.MT32ReverbTime,';,');
  try
    MT32TimeComboBox.Items.Clear;
    MT32TimeComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  St:=ValueToList(InitData.GameDB.ConfOpt.MT32ReverbLevel,';,');
  try
    MT32LevelComboBox.Items.Clear;
    MT32LevelComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  HelpContext:=ID_ProfileEditSoundMIDI;
end;

Procedure SetComboBox(const ComboBox : TComboBox; const Value : String; const Default : Integer); overload;
Var S : String;
    I : Integer;
begin
  try ComboBox.ItemIndex:=Default; except end;
  S:=Trim(ExtUpperCase(Value));
  For I:=0 to ComboBox.Items.Count-1 do If Trim(ExtUpperCase(ComboBox.Items[I]))=S then begin
    ComboBox.ItemIndex:=I; break;
  end;
end;

Procedure SetComboBox(const ComboBox : TComboBox; const Value : String; const Default : String); overload;
begin
  SetComboBox(ComboBox,Default,0);
  SetComboBox(ComboBox,Value,ComboBox.ItemIndex);
end;

procedure TModernProfileEditorMIDIFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  SetComboBox(TypeComboBox,Game.MIDIType,'intelligent');
  SetComboBox(DeviceComboBox,Game.MIDIDevice,'default');
  AdditionalSettingsEdit.Text:=Game.MIDIConfig;

  MT32ModeComboBox.ItemIndex:=Max(0,MT32ModeComboBox.Items.IndexOf(Game.MIDIMT32Mode));
  MT32TimeComboBox.ItemIndex:=Max(0,MT32TimeComboBox.Items.IndexOf(Game.MIDIMT32Time));
  MT32LevelComboBox.ItemIndex:=Max(0,MT32LevelComboBox.Items.IndexOf(Game.MIDIMT32Level));

  DeviceComboBoxChange(self);
end;

procedure TModernProfileEditorMIDIFrame.DeviceComboBoxChange(Sender: TObject);
begin
  MT32SettingsGroupBox.Visible:=(ExtUpperCase(DeviceComboBox.Text)='MT32');
end;

procedure TModernProfileEditorMIDIFrame.GetGame(const Game: TGame);
begin
  Game.MIDIType:=TypeComboBox.Text;
  Game.MIDIDevice:=DeviceComboBox.Text;
  Game.MIDIConfig:=AdditionalSettingsEdit.Text;

  Game.MIDIMT32Mode:=MT32ModeComboBox.Text;
  Game.MIDIMT32Time:=MT32TimeComboBox.Text;
  Game.MIDIMT32Level:=MT32LevelComboBox.Text;
end;

procedure TModernProfileEditorMIDIFrame.MIDISelectButtonClick(Sender: TObject);
Var St : TStringList;
begin
  St:=GetMIDIDevices;
  try
    MIDISelectListBox.Visible:=(St.Count>0);
    MIDISelectLabel2.Visible:=(St.Count>0);
    MIDISelectListBox.Items.BeginUpdate;
    try
      MIDISelectListBox.Items.Clear;
      MIDISelectListBox.Items.AddStrings(St);
    finally
      MIDISelectListBox.Items.EndUpdate;
    end;
  finally
    St.Free;
  end;
end;

procedure TModernProfileEditorMIDIFrame.MIDISelectListBoxClick(Sender: TObject);
Var S : String;
begin
  If MIDISelectListBox.ItemIndex<0 then exit;
  S:=MIDISelectListBox.Items[MIDISelectListBox.ItemIndex];
  While (S<>'') and (S[length(S)]<>'(') do SetLength(S,length(S)-1);
  SetLength(S,length(S)-1);
  AdditionalSettingsEdit.Text:=Trim(S);
end;

end.
