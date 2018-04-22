unit ModernProfileEditorSoundFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorSoundFrame = class(TFrame, IModernProfileEditorFrame)
    ActivateSoundCheckBox: TCheckBox;
    MixerGroupBox: TGroupBox;
    SampleRateLabel: TLabel;
    BlockSizeLabel: TLabel;
    PreBufferLabel: TLabel;
    SampleRateComboBox: TComboBox;
    BlockSizeComboBox: TComboBox;
    PreBufferComboBox: TComboBox;
    ActivatePCSpeakerCheckBox: TCheckBox;
    PCSpeakerSampleRateLabel: TLabel;
    PCSpeakerSampleRateComboBox: TComboBox;
    TandyRadioGroup: TRadioGroup;
    TandySampleRateLabel: TLabel;
    TandyComboBox: TComboBox;
    ActivateDisneyCheckBox: TCheckBox;
  private
    { Private-Deklarationen }
    FOldSampleRate, FOldBlockSize, FOldPreBuffer, FOldSpeakerRate, FOldTandyRate : Integer;
    Procedure CheckValue(Sender : TObject; var OK : Boolean);
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorSoundFrame }

procedure TModernProfileEditorSoundFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  InitData.OnCheckValue:=CheckValue;

  NoFlicker(ActivateSoundCheckBox);
  NoFlicker(MixerGroupBox);
  NoFlicker(SampleRateComboBox);
  NoFlicker(BlockSizeComboBox);
  NoFlicker(PreBufferComboBox);
  NoFlicker(ActivatePCSpeakerCheckBox);
  NoFlicker(PCSpeakerSampleRateComboBox);
  NoFlicker(TandyComboBox);

  ActivateSoundCheckBox.Caption:=LanguageSetup.ProfileEditorSoundEnableSound;
  MixerGroupBox.Caption:=LanguageSetup.ProfileEditorSoundMixer;
  SampleRateLabel.Caption:=LanguageSetup.ProfileEditorSoundSampleRate;
  St:=ValueToList(InitData.GameDB.ConfOpt.Rate,';,'); try SampleRateComboBox.Items.AddStrings(St); finally St.Free; end;
  BlockSizeLabel.Caption:=LanguageSetup.ProfileEditorSoundBlockSize;
  St:=ValueToList(InitData.GameDB.ConfOpt.Blocksize,';,'); try BlockSizeComboBox.Items.AddStrings(St); finally St.Free; end;
  PreBufferLabel.Caption:=LanguageSetup.ProfileEditorSoundPrebuffer;
  PreBufferComboBox.Items.BeginUpdate;
  try
    with PreBufferComboBox.Items do begin Add('1'); Add('5'); Add('10'); Add('15'); Add('20'); Add('25'); Add('30'); end;
  finally
    PreBufferComboBox.Items.EndUpdate;
  end;

  ActivatePCSpeakerCheckBox.Caption:=LanguageSetup.ProfileEditorSoundMiscEnablePCSpeaker;
  PCSpeakerSampleRateLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate;
  St:=ValueToList(InitData.GameDB.ConfOpt.PCRate,';,'); try PCSpeakerSampleRateComboBox.Items.AddStrings(St); finally St.Free; end;

  TandyRadioGroup.Caption:=LanguageSetup.ProfileEditorSoundMiscEnableTandy;
  TandyRadioGroup.Items[0]:=LanguageSetup.ProfileEditorSoundMiscEnableTandyAuto;
  TandyRadioGroup.Items[1]:=LanguageSetup.On;
  TandyRadioGroup.Items[2]:=LanguageSetup.Off;

  TandySampleRateLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscTandyRate;
  St:=ValueToList(InitData.GameDB.ConfOpt.TandyRate,';,'); try TandyComboBox.Items.AddStrings(St); finally St.Free; end;

  ActivateDisneyCheckBox.Caption:=LanguageSetup.ProfileEditorSoundMiscEnableDisneySoundsSource;

  AddDefaultValueHint(SampleRateComboBox);
  AddDefaultValueHint(BlockSizeComboBox);

  HelpContext:=ID_ProfileEditSound;
end;

procedure TModernProfileEditorSoundFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
    S : String;
begin
  ActivateSoundCheckBox.Checked:=not Game.MixerNosound;
  SampleRateComboBox.ItemIndex:=SampleRateComboBox.Items.Count-2;
  For I:=0 to SampleRateComboBox.Items.Count-1 do If IntToStr(Game.MixerRate)=SampleRateComboBox.Items[I] then begin
    SampleRateComboBox.ItemIndex:=I; break;
  end;
  FOldSampleRate:=Game.MixerRate;
  BlockSizeComboBox.Text:=IntToStr(Game.MixerBlocksize);
  FOldBlockSize:=Game.MixerBlocksize;
  PreBufferComboBox.Text:=IntToStr(Game.MixerPrebuffer);
  FOldPreBuffer:=Game.MixerPrebuffer;

  ActivatePCSpeakerCheckBox.Checked:=Game.SpeakerPC;
  PCSpeakerSampleRateComboBox.ItemIndex:=PCSpeakerSampleRateComboBox.Items.Count-2;
  For I:=0 to PCSpeakerSampleRateComboBox.Items.Count-1 do If IntToStr(Game.SpeakerRate)=PCSpeakerSampleRateComboBox.Items[I] then begin
    PCSpeakerSampleRateComboBox.ItemIndex:=I; break;
  end;
  FOldSpeakerRate:=Game.SpeakerRate;

  S:=Trim(ExtUpperCase(Game.SpeakerTandy));
  TandyRadioGroup.ItemIndex:=0;
  If (S='AUTO') or (S='DEFAULT') or (S='') then TandyRadioGroup.ItemIndex:=0;
  If S='ON' then TandyRadioGroup.ItemIndex:=1;
  If S='OFF' then TandyRadioGroup.ItemIndex:=2;
  TandyComboBox.ItemIndex:=TandyComboBox.Items.Count-2;
  For I:=0 to TandyComboBox.Items.Count-1 do If IntToStr(Game.SpeakerTandyRate)=TandyComboBox.Items[I] then begin
    TandyComboBox.ItemIndex:=I; break;
  end;
  FOldTandyRate:=Game.SpeakerTandyRate;

  ActivateDisneyCheckBox.Checked:=Game.SpeakerDisney;
end;

Procedure TModernProfileEditorSoundFrame.CheckValue(Sender : TObject; var OK : Boolean);
Var I : Integer;
begin
  Ok:=True;

  If (not TryStrToInt(Trim(SampleRateComboBox.Text),I)) or (I<1) or (I>65536) then begin
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[SampleRateComboBox.Text,LanguageSetup.ProfileEditorSoundSampleRate,IntToStr(FOldSampleRate)]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      Ok:=False; exit;
    end;
  end;

  If (not TryStrToInt(Trim(BlockSizeComboBox.Text),I)) or (I<1) or (I>65536) then begin
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[BlockSizeComboBox.Text,LanguageSetup.ProfileEditorSoundBlockSize,IntToStr(FOldBlockSize)]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      Ok:=False; exit;
    end;
  end;

  If (not TryStrToInt(Trim(PreBufferComboBox.Text),I)) or (I<1) or (I>65536) then begin
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[PreBufferComboBox.Text,LanguageSetup.ProfileEditorSoundPrebuffer,IntToStr(FOldPreBuffer)]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      Ok:=False; exit;
    end;
  end;

  If (not TryStrToInt(Trim(PCSpeakerSampleRateComboBox.Text),I)) or (I<1) or (I>65536) then begin
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[PCSpeakerSampleRateComboBox.Text,LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,IntToStr(FOldSpeakerRate)]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      Ok:=False; exit;
    end;
  end;

  If (not TryStrToInt(Trim(TandyComboBox.Text),I)) or (I<1) or (I>65536) then begin
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[TandyComboBox.Text,LanguageSetup.ProfileEditorSoundMiscTandyRate,IntToStr(FOldTandyRate)]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      Ok:=False; exit;
    end;
  end;
end;

procedure TModernProfileEditorSoundFrame.GetGame(const Game: TGame);
Var I : Integer;
begin
  Game.MixerNosound:=not ActivateSoundCheckBox.Checked;
  If TryStrToInt(Trim(SampleRateComboBox.Text),I) and (I>=1) and (I<=65536) then Game.MixerRate:=I;
  If TryStrToInt(Trim(BlockSizeComboBox.Text),I) and (I>=1) and (I<=65536) then Game.MixerBlocksize:=I;
  If TryStrToInt(Trim(PreBufferComboBox.Text),I) and (I>=1) and (I<=65536) then Game.MixerPrebuffer:=I;

  Game.SpeakerPC:=ActivatePCSpeakerCheckBox.Checked;
  If TryStrToInt(Trim(PCSpeakerSampleRateComboBox.Text),I) and (I>=1) and (I<=65536) then Game.SpeakerRate:=I;

  Case TandyRadioGroup.ItemIndex of
    0 : Game.SpeakerTandy:='auto';
    1 : Game.SpeakerTandy:='on';
    2 : Game.SpeakerTandy:='off';
  end;
  If TryStrToInt(Trim(TandyComboBox.Text),I) and (I>=1) and (I<=65536) then Game.SpeakerTandyRate:=I;

  Game.SpeakerDisney:=ActivateDisneyCheckBox.Checked;
end;

end.
