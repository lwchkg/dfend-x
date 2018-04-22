unit ModernProfileEditorScummVMSoundFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorScummVMSoundFrame = class(TFrame, IModernProfileEditorFrame)
    MusicVolumeLabel: TLabel;
    MusicVolumeEdit: TSpinEdit;
    SpeechVolumeLabel: TLabel;
    SpeechVolumeEdit: TSpinEdit;
    SFXVolumeLabel: TLabel;
    SFXVolumeEdit: TSpinEdit;
    MIDIGainLabel: TLabel;
    MIDIGainEdit: TSpinEdit;
    OutputRateLabel: TLabel;
    OutputRateComboBox: TComboBox;
    MusicDriverLabel: TLabel;
    MusicDriverComboBox: TComboBox;
    NativeMT32CheckBox: TCheckBox;
    EnableGSCheckBox: TCheckBox;
    MultiMIDICheckBox: TCheckBox;
    SpeechMuteCheckBox: TCheckBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorScummVMSoundFrame }

procedure TModernProfileEditorScummVMSoundFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(MusicVolumeEdit);
  NoFlicker(SpeechVolumeEdit);
  NoFlicker(SFXVolumeEdit);
  NoFlicker(MIDIGainEdit);
  NoFlicker(OutputRateComboBox);
  NoFlicker(MusicDriverComboBox);
  NoFlicker(NativeMT32CheckBox);
  NoFlicker(EnableGSCheckBox);
  NoFlicker(MultiMIDICheckBox);
  NoFlicker(SpeechMuteCheckBox);

  MusicVolumeLabel.Caption:=LanguageSetup.ProfileEditorScummVMMusicVolume;
  SpeechVolumeLabel.Caption:=LanguageSetup.ProfileEditorScummVMSpeechVolume;
  SFXVolumeLabel.Caption:=LanguageSetup.ProfileEditorScummVMSFXVolume;
  MIDIGainLabel.Caption:=LanguageSetup.ProfileEditorScummVMMIDIGain;
  OutputRateLabel.Caption:=LanguageSetup.ProfileEditorSoundSampleRate;
  MusicDriverLabel.Caption:=LanguageSetup.ProfileEditorScummVMMusicDriver;
  NativeMT32CheckBox.Caption:=LanguageSetup.ProfileEditorScummVMNativeMT32;
  EnableGSCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMEnableGS;
  MultiMIDICheckBox.Caption:=LanguageSetup.ProfileEditorScummVMMultiMIDI;
  SpeechMuteCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMSpeechMute;

  with OutputRateComboBox.Items do begin Add('11025'); Add('22050'); Add('44100'); end;
  St:=ValueToList(InitData.GameDB.ConfOpt.ScummVMMusicDriver,';,'); try MusicDriverComboBox.Items.AddStrings(St); finally St.Free; end;

  AddDefaultValueHint(MusicDriverComboBox);

  HelpContext:=ID_ProfileEditSound;
end;

procedure TModernProfileEditorScummVMSoundFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S,T : String;
    I,J : Integer;
begin
  MusicVolumeEdit.Value:=Max(0,Min(255,Game.ScummVMMusicVolume));
  SpeechVolumeEdit.Value:=Max(0,Min(255,Game.ScummVMSpeechVolume));
  SFXVolumeEdit.Value:=Max(0,Min(255,Game.ScummVMSFXVolume));
  MIDIGainEdit.Value:=Max(0,Min(1000,Game.ScummVMMIDIGain));
  Case Game.ScummVMSampleRate of
    11025 : OutputRateComboBox.ItemIndex:=0;
    22050 : OutputRateComboBox.ItemIndex:=1;
    44100 : OutputRateComboBox.ItemIndex:=2;
    else OutputRateComboBox.ItemIndex:=1;
  end;
  If MusicDriverComboBox.Items.Count>1 then MusicDriverComboBox.ItemIndex:=1;
  S:=Trim(ExtUpperCase(Game.ScummVMMusicDriver));
  If (S<>'') and (S[length(S)]=')') then SetLength(S,length(S)-1);
  For I:=0 to MusicDriverComboBox.Items.Count-1 do begin
    T:=Trim(MusicDriverComboBox.Items[I]);
    If (T<>'') and (T[length(T)]=')') then begin
      For J:=length(T)-1 downto 1 do If T[J]='(' then begin T:=Trim(Copy(T,J+1,MaxInt)); break; end;
    end;
    If (T<>'') and (T[length(T)]=')') then SetLength(T,length(T)-1);
    If ExtUpperCase(T)=S then begin MusicDriverComboBox.ItemIndex:=I; break; end;
  end;
  NativeMT32CheckBox.Checked:=Game.ScummVMNativeMT32;
  EnableGSCheckBox.Checked:=Game.ScummVMEnableGS;
  MultiMIDICheckBox.Checked:=Game.ScummVMMultiMIDI;
  SpeechMuteCheckBox.Checked:=Game.ScummVMSpeechMute;
end;

procedure TModernProfileEditorScummVMSoundFrame.GetGame(const Game: TGame);
Var S : String;
    I : Integer;
begin
  Game.ScummVMMusicVolume:=MusicVolumeEdit.Value;
  Game.ScummVMSpeechVolume:=SpeechVolumeEdit.Value;
  Game.ScummVMSFXVolume:=SFXVolumeEdit.Value;
  Game.ScummVMMIDIGain:=MIDIGainEdit.Value;
  Case OutputRateComboBox.ItemIndex of
    0 : Game.ScummVMSampleRate:=11025;
    1 : Game.ScummVMSampleRate:=22050;
    2 : Game.ScummVMSampleRate:=44100;
  end;
  
  S:=Trim(MusicDriverComboBox.Text);
  If (S<>'') and (S[length(S)]=')') then begin
    For I:=length(S)-1 downto 1 do If S[I]='(' then begin S:=Trim(Copy(S,I+1,MaxInt)); break; end;
  end;
  If (S<>'') and (S[length(S)]=')') then SetLength(S,length(S)-1);
  Game.ScummVMMusicDriver:=S;

  Game.ScummVMNativeMT32:=NativeMT32CheckBox.Checked;
  Game.ScummVMEnableGS:=EnableGSCheckBox.Checked;
  Game.ScummVMMultiMIDI:=MultiMIDICheckBox.Checked;
  Game.ScummVMSpeechMute:=SpeechMuteCheckBox.Checked;
end;

end.
