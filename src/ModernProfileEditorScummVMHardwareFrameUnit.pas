unit ModernProfileEditorScummVMHardwareFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorScummVMHardwareFrame = class(TFrame, IModernProfileEditorFrame)
    CDGroupBox: TGroupBox;
    CDRadioButton1: TRadioButton;
    CDRadioButton2: TRadioButton;
    CDEdit: TSpinEdit;
    JoystickGroupBox: TGroupBox;
    JoystickRadioButton1: TRadioButton;
    JoystickRadioButton2: TRadioButton;
    JoystickEdit: TSpinEdit;
    PlatformLabel: TLabel;
    PlatformComboBox: TComboBox;
    procedure CDEditChange(Sender: TObject);
    procedure JoystickEditChange(Sender: TObject);
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

{ TModernProfileEditorScummVMHardwareFrame }

procedure TModernProfileEditorScummVMHardwareFrame.InitGUI(var InitData: TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(CDGroupBox);
  NoFlicker(CDRadioButton1);
  NoFlicker(CDRadioButton2);
  NoFlicker(CDEdit);
  NoFlicker(JoystickGroupBox);
  NoFlicker(JoystickRadioButton1);
  NoFlicker(JoystickRadioButton2);
  NoFlicker(JoystickEdit);
  NoFlicker(PlatformComboBox);

  CDGroupBox.Caption:=LanguageSetup.ProfileEditorScummVMCDAudioDrive;
  CDRadioButton1.Caption:=LanguageSetup.ProfileEditorScummVMCDAudioOff;
  CDRadioButton2.Caption:=LanguageSetup.ProfileEditorScummVMCDAudioNr;
  JoystickGroupBox.Caption:=LanguageSetup.ProfileEditorScummVMJoystick;
  JoystickRadioButton1.Caption:=LanguageSetup.ProfileEditorScummVMJoystickOff;
  JoystickRadioButton2.Caption:=LanguageSetup.ProfileEditorScummVMJoystickNr;
  PlatformLabel.Caption:=LanguageSetup.ProfileEditorScummVMPlatform;
  St:=ValueToList(InitData.GameDB.ConfOpt.ScummVMPlatform,';,'); try PlatformComboBox.Items.AddStrings(St); finally St.Free; end;

  AddDefaultValueHint(PlatformComboBox);

  HelpContext:=ID_ProfileEditHardware;
end;

procedure TModernProfileEditorScummVMHardwareFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
    I : Integer;
begin
  CDEdit.Value:=Min(3,Max(0,Game.ScummVMCDROM));
  CDRadioButton1.Checked:=(Game.ScummVMCDROM=-1);
  CDRadioButton2.Checked:=(Game.ScummVMCDROM>=0);

  JoystickEdit.Value:=Min(3,Max(0,Game.ScummVMJoystickNum));
  JoystickRadioButton1.Checked:=(Game.ScummVMJoystickNum=-1);
  JoystickRadioButton2.Checked:=(Game.ScummVMJoystickNum>=0);

  S:=Trim(ExtUpperCase(Game.ScummVMPlatform));
  PlatformComboBox.ItemIndex:=0;
  For I:=0 to PlatformComboBox.Items.Count-1 do If S=Trim(ExtUpperCase(PlatformComboBox.Items[I])) then begin
    PlatformComboBox.ItemIndex:=I; break;
  end;
end;

procedure TModernProfileEditorScummVMHardwareFrame.GetGame(const Game: TGame);
begin
  If CDRadioButton2.Checked then Game.ScummVMCDROM:=CDEdit.Value else Game.ScummVMCDROM:=-1;
  If JoystickRadioButton2.Checked then Game.ScummVMJoystickNum:=JoystickEdit.Value else Game.ScummVMJoystickNum:=-1;
  If PlatformComboBox.ItemIndex<=0 then Game.ScummVMPlatform:='' else Game.ScummVMPlatform:=PlatformComboBox.Text; 
end;

procedure TModernProfileEditorScummVMHardwareFrame.CDEditChange(Sender: TObject);
begin
  CDRadioButton2.Checked:=True;
end;

procedure TModernProfileEditorScummVMHardwareFrame.JoystickEditChange(Sender: TObject);
begin
  JoystickRadioButton2.Checked:=True;
end;

end.
