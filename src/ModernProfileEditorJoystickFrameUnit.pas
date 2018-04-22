unit ModernProfileEditorJoystickFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorJoystickFrame = class(TFrame, IModernProfileEditorFrame)
    TypeLabel: TLabel;
    TypeComboBox: TComboBox;
    TimedCheckBox: TCheckBox;
    AutofireCheckBox: TCheckBox;
    Swap34CheckBox: TCheckBox;
    WrapCheckBox: TCheckBox;
    WrapInfoLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorJoystickFrame }

procedure TModernProfileEditorJoystickFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(TypeComboBox);
  NoFlicker(TimedCheckBox);
  NoFlicker(AutofireCheckBox);
  NoFlicker(Swap34CheckBox);
  NoFlicker(WrapCheckBox);

  TypeLabel.Caption:=LanguageSetup.ProfileEditorSoundJoystickType;
  St:=ValueToList(InitData.GameDB.ConfOpt.Joysticks,';,'); try TypeComboBox.Items.AddStrings(St); finally St.Free; end;
  TimedCheckBox.Caption:=LanguageSetup.ProfileEditorSoundJoystickTimed;
  AutofireCheckBox.Caption:=LanguageSetup.ProfileEditorSoundJoystickAutoFire;
  Swap34CheckBox.Caption:=LanguageSetup.ProfileEditorSoundJoystickSwap34;
  WrapCheckBox.Caption:=LanguageSetup.ProfileEditorSoundJoystickButtonwrap;
  WrapInfoLabel.Caption:=LanguageSetup.ProfileEditorSoundJoystickButtonwrapInfo;

  AddDefaultValueHint(TypeComboBox);

  HelpContext:=ID_ProfileEditJoystick;
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

procedure TModernProfileEditorJoystickFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  SetComboBox(TypeComboBox,Game.JoystickType,'none');
  TimedCheckBox.Checked:=Game.JoystickTimed;
  AutofireCheckBox.Checked:=Game.JoystickAutoFire;
  Swap34CheckBox.Checked:=Game.JoystickSwap34;
  WrapCheckBox.Checked:=Game.JoystickButtonwrap;
end;

procedure TModernProfileEditorJoystickFrame.GetGame(const Game: TGame);
begin
  Game.JoystickType:=TypeComboBox.Text;
  Game.JoystickTimed:=TimedCheckBox.Checked;
  Game.JoystickAutoFire:=AutofireCheckBox.Checked;
  Game.JoystickSwap34:=Swap34CheckBox.Checked;
  Game.JoystickButtonwrap:=WrapCheckBox.Checked;
end;

end.
