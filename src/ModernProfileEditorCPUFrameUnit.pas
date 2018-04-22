unit ModernProfileEditorCPUFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorCPUFrame = class(TFrame, IModernProfileEditorFrame)
    CPUCoreRadioGroup: TRadioGroup;
    CPUCyclesGroupBox: TGroupBox;
    CyclesAutoRadioButton: TRadioButton;
    CyclesMaxRadioButton: TRadioButton;
    CyclesValueRadioButton: TRadioButton;
    CyclesComboBox: TComboBox;
    CyclesUpLabel: TLabel;
    CyclesDownLabel: TLabel;
    CyclesUpEdit: TSpinEdit;
    CyclesDownEdit: TSpinEdit;
    CyclesInfoLabel: TLabel;
    CPUTypeLabel: TLabel;
    CPUTypeComboBox: TComboBox;
    InfoLabel: TLabel;
    CyclesUpComboBox: TComboBox;
    CyclesDownComboBox: TComboBox;
    CyclesMaxLimitCheckBox: TCheckBox;
    procedure CPUCyclesChange(Sender: TObject);
    procedure CyclesUpComboBoxChange(Sender: TObject);
    procedure CyclesDownComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    SaveCycles : String;
    Procedure CheckValue(Sender : TObject; var OK : Boolean);
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, HelpConsts, PrgSetupUnit;

{$R *.dfm}

{ TModernProfileEditorCPUFrame }

procedure TModernProfileEditorCPUFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
    I : Integer;
    S : String;
begin
  InitData.OnCheckValue:=CheckValue;

  NoFlicker(CPUCoreRadioGroup);
  NoFlicker(CPUCyclesGroupBox);
  NoFlicker(CyclesAutoRadioButton);
  NoFlicker(CyclesMaxRadioButton);
  NoFlicker(CyclesValueRadioButton);
  NoFlicker(CyclesUpEdit);
  NoFlicker(CyclesUpComboBox);
  NoFlicker(CyclesDownEdit);
  NoFlicker(CyclesDownComboBox);
  NoFlicker(CPUTypeComboBox);
  NoFlicker(CyclesMaxLimitCheckBox);

  CPUCoreRadioGroup.Caption:=LanguageSetup.GameCore;
  CPUCyclesGroupBox.Caption:=LanguageSetup.GameCycles;
  CyclesAutoRadioButton.Caption:=LanguageSetup.GameCyclesAuto;
  CyclesMaxRadioButton.Caption:=LanguageSetup.GameCyclesMax;
  CyclesValueRadioButton.Caption:=LanguageSetup.Value;
  CyclesMaxLimitCheckBox.Caption:=LanguageSetup.GameCyclesMaxLimitValue;

  St:=ValueToList(InitData.GameDB.ConfOpt.Core,';,'); try CPUCoreRadioGroup.Items.AddStrings(St); finally St.Free; end;
  CPUCoreRadioGroup.ItemIndex:=0;

  St:=ValueToList(InitData.GameDB.ConfOpt.Cycles,';,');
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If (S='AUTO') or (S='MAX') then continue;
      CyclesComboBox.Items.Add(St[I]);
    end;
    CyclesComboBox.Text:='3000';
  finally
    St.Free;
  end;

  CyclesUpLabel.Caption:=LanguageSetup.GameCyclesUp;
  with CyclesUpComboBox.Items do begin
    Clear;
    Add(LanguageSetup.GameCyclesTypeValue);
    Add(LanguageSetup.GameCyclesTypePercent);
  end;
  CyclesDownLabel.Caption:=LanguageSetup.GameCyclesDown;
  with CyclesDownComboBox.Items do begin
    Clear;
    Add(LanguageSetup.GameCyclesTypeValue);
    Add(LanguageSetup.GameCyclesTypePercent);
  end;
  CyclesInfoLabel.Caption:=LanguageSetup.GameCyclesInfo;

  CPUTypeLabel.Caption:=LanguageSetup.GameCPUType;
  InfoLabel.Caption:=LanguageSetup.GameCPUInfo;

  St:=ValueToList(InitData.GameDB.ConfOpt.CPUType,';,');
  try
    CPUTypeComboBox.Items.BeginUpdate;
    try
      CPUTypeComboBox.Items.Clear;
      CPUTypeComboBox.Items.AddStrings(St);
    finally
      CPUTypeComboBox.Items.EndUpdate;
    end;
  finally
    St.Free;
  end;

  AddDefaultValueHint(CPUTypeComboBox);

  HelpContext:=ID_ProfileEditCPU;
end;

procedure TModernProfileEditorCPUFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
    S,T : String;
begin
  S:=Trim(ExtUpperCase(Game.Core));
  For I:=0 to CPUCoreRadioGroup.Items.Count-1 do begin
    If Trim(ExtUpperCase(CPUCoreRadioGroup.Items[I]))=S then begin CPUCoreRadioGroup.ItemIndex:=I; break; end;
  end;

  SaveCycles:=Game.Cycles;
  S:=Trim(ExtUpperCase(Game.Cycles));
  CyclesAutoRadioButton.Checked:=(S='AUTO');
  If Copy(S,1,3)='MAX' then begin
    CyclesMaxRadioButton.Checked:=True;
    CyclesMaxLimitCheckBox.Visible:=True;
    T:=Trim(Copy(S,4,MaxInt));
    if (T<>'') and (Copy(T,1,5)='LIMIT') then T:=Trim(Copy(T,6,MaxInt));
    if T<>'' then begin
      CyclesMaxLimitCheckBox.Checked:=True;
      CyclesComboBox.Text:=T;
    end else begin
      CyclesMaxLimitCheckBox.Checked:=False;
    end;
  end;
  If (S<>'AUTO') and (Copy(S,1,3)<>'MAX') then begin
    CyclesMaxLimitCheckBox.Visible:=False;
    CyclesValueRadioButton.Checked:=True;
    CyclesComboBox.Text:=Game.Cycles;
  end;
  CPUCyclesChange(self);

  If Game.CyclesUp<100 then CyclesUpComboBox.ItemIndex:=1 else CyclesUpComboBox.ItemIndex:=0;
  CyclesUpComboBoxChange(self);
  CyclesUpEdit.Value:=Game.CyclesUp;
  If Game.CyclesDown<100 then CyclesDownComboBox.ItemIndex:=1 else CyclesDownComboBox.ItemIndex:=0;
  CyclesDownComboBoxChange(self);
  CyclesDownEdit.Value:=Game.CyclesDown;

  CPUTypeComboBox.ItemIndex:=0;
  S:=Trim(ExtUpperCase(Game.CPUType));
  For I:=0 to CPUTypeComboBox.Items.Count-1 do If S=Trim(ExtUpperCase(CPUTypeComboBox.Items[I])) then begin
    CPUTypeComboBox.ItemIndex:=I; break;
  end;
end;

Procedure TModernProfileEditorCPUFrame.CheckValue(Sender : TObject; var OK : Boolean);
Var I : Integer;
    B : Boolean;
    S : String;
begin
  Ok:=True;

  If CyclesValueRadioButton.Checked then begin
    B:=TryStrToInt(CyclesComboBox.Text,I);
    If not B then begin
      S:=Trim(ExtUpperCase(CyclesComboBox.Text));
      For I:=0 to CyclesComboBox.Items.Count-1 do If Trim(ExtUpperCase(CyclesComboBox.Items[I]))=S then begin B:=True; break; end;
    end;
    if not B then begin
      If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[CyclesComboBox.Text,LanguageSetup.GameCycles,SaveCycles]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
        Ok:=False;
        exit;
      end else begin
        CyclesComboBox.Text:=SaveCycles;
      end;
    end;
  end;
end;

procedure TModernProfileEditorCPUFrame.CPUCyclesChange(Sender: TObject);
begin
  CyclesMaxLimitCheckBox.Visible:=CyclesMaxRadioButton.Checked;
  CyclesComboBox.Enabled:=CyclesValueRadioButton.Checked or (CyclesMaxLimitCheckBox.Visible and CyclesMaxLimitCheckBox.Checked);
end;

procedure TModernProfileEditorCPUFrame.CyclesUpComboBoxChange(Sender: TObject);
begin
  If CyclesUpComboBox.ItemIndex=0 then begin
    CyclesUpEdit.MinValue:=100; CyclesUpEdit.MaxValue:=50000;
  end else begin
    CyclesUpEdit.MinValue:=1; CyclesUpEdit.MaxValue:=99;
  end;
end;

procedure TModernProfileEditorCPUFrame.CyclesDownComboBoxChange(Sender: TObject);
begin
  If CyclesDownComboBox.ItemIndex=0 then begin
    CyclesDownEdit.MinValue:=100; CyclesDownEdit.MaxValue:=50000;
  end else begin
    CyclesDownEdit.MinValue:=1; CyclesDownEdit.MaxValue:=99;
  end;
end;

procedure TModernProfileEditorCPUFrame.GetGame(const Game: TGame);
begin
  Game.Core:=CPUCoreRadioGroup.Items[CPUCoreRadioGroup.ItemIndex];

  If CyclesAutoRadioButton.Checked then Game.Cycles:='auto';
  If CyclesMaxRadioButton.Checked then begin
    Game.Cycles:='max';
    if CyclesMaxLimitCheckBox.Checked then Game.Cycles:=Game.Cycles+' limit '+CyclesComboBox.Text;
  end;
  If CyclesValueRadioButton.Checked then Game.Cycles:=CyclesComboBox.Text;
  Game.CyclesUp:=Min(30000,Max(1,CyclesUpEdit.Value));
  Game.CyclesDown:=Min(30000,Max(1,CyclesDownEdit.Value));

  Game.CPUType:=CPUTypeComboBox.Text;
end;

end.
