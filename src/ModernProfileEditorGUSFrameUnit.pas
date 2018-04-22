unit ModernProfileEditorGUSFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorGUSFrame = class(TFrame, IModernProfileEditorFrame)
    ActivateGUSCheckBox: TCheckBox;
    AddressLabel: TLabel;
    AddressComboBox: TComboBox;
    SampleRateLabel: TLabel;
    SampleRateComboBox: TComboBox;
    Interrupt1ComboBox: TComboBox;
    Interrupt1Label: TLabel;
    DMA1ComboBox: TComboBox;
    DMA1Label: TLabel;
    PathEdit: TLabeledEdit;
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

{ TFrame1 }

procedure TModernProfileEditorGUSFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(ActivateGUSCheckBox);
  NoFlicker(AddressComboBox);
  NoFlicker(SampleRateComboBox);
  NoFlicker(Interrupt1ComboBox);
  NoFlicker(DMA1ComboBox);
  NoFlicker(PathEdit);

  ActivateGUSCheckBox.Caption:=LanguageSetup.ProfileEditorSoundGUSEnabled;
  AddressLabel.Caption:=LanguageSetup.ProfileEditorSoundGUSAddress;
  St:=ValueToList(InitData.GameDB.ConfOpt.GUSBase,';,'); try AddressComboBox.Items.AddStrings(St); finally St.Free; end;
  SampleRateLabel.Caption:=LanguageSetup.ProfileEditorSoundGUSRate;
  St:=ValueToList(InitData.GameDB.ConfOpt.GUSRate,';,'); try SampleRateComboBox.Items.AddStrings(St); finally St.Free; end;
  Interrupt1Label.Caption:=LanguageSetup.ProfileEditorSoundGUSIRQ;
  St:=ValueToList(InitData.GameDB.ConfOpt.GUSIRQ,';,'); try Interrupt1ComboBox.Items.AddStrings(St); finally St.Free; end;
  DMA1Label.Caption:=LanguageSetup.ProfileEditorSoundGUSDMA;
  St:=ValueToList(InitData.GameDB.ConfOpt.GUSDma,';,'); try DMA1ComboBox.Items.AddStrings(St); finally St.Free; end;
  PathEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSoundGUSPath;

  AddDefaultValueHint(AddressComboBox);
  AddDefaultValueHint(SampleRateComboBox);
  AddDefaultValueHint(Interrupt1ComboBox);
  AddDefaultValueHint(DMA1ComboBox);

  HelpContext:=ID_ProfileEditSoundGUS;
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

procedure TModernProfileEditorGUSFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  ActivateGUSCheckBox.Checked:=Game.GUS;
  SetComboBox(AddressComboBox,Game.GUSBase,'240');
  SetComboBox(SampleRateComboBox,IntToStr(Game.GUSRate),'22050');
  SetComboBox(Interrupt1ComboBox,IntToStr(Game.GUSIRQ),'5');
  SetComboBox(DMA1ComboBox,IntToStr(Game.GUSDMA),'1');
  PathEdit.Text:=Game.GUSUltraDir;
end;

procedure TModernProfileEditorGUSFrame.GetGame(const Game: TGame);
begin
  Game.GUS:=ActivateGUSCheckBox.Checked;
  Game.GUSBase:=AddressComboBox.Text;
  try Game.GUSRate:=StrtoInt(SampleRateComboBox.Text); except end;
  try Game.GUSIRQ:=StrtoInt(Interrupt1ComboBox.Text); except end;
  try Game.GUSDMA:=StrtoInt(DMA1ComboBox.Text); except end;
  Game.GUSUltraDir:=PathEdit.Text;
end;

end.
