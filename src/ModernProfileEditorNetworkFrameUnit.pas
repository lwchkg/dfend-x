unit ModernProfileEditorNetworkFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorNetworkFrame = class(TFrame, IModernProfileEditorFrame)
    ActivateCheckBox: TCheckBox;
    ConnectionsRadioGroup: TRadioGroup;
    ServerAddressEdit: TLabeledEdit;
    PortLabel: TLabel;
    PortEdit: TSpinEdit;
    NE2000CheckBox: TCheckBox;
    NE2000BaseAddressLabel: TLabel;
    NE2000InterruptLabel: TLabel;
    NE2000BaseAddressComboBox: TComboBox;
    NE2000InterruptComboBox: TComboBox;
    NE2000MACAddressEdit: TLabeledEdit;
    ResetMACButton: TButton;
    NE2000RealNICEdit: TLabeledEdit;
    ListNICButton: TButton;
    procedure ActivateCheckBoxClick(Sender: TObject);
    procedure ResetMACButtonClick(Sender: TObject);
    procedure ListNICButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ProfileDOSBoxInstallation : PString;
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts,
     PrgSetupUnit, DOSBoxUnit, DOSBoxTempUnit, MainUnit;

{$R *.dfm}

{ TModernProfileEditorNetworkFrame }

procedure TModernProfileEditorNetworkFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(ActivateCheckBox);
  NoFlicker(ConnectionsRadioGroup);
  NoFlicker(ServerAddressEdit);
  NoFlicker(PortEdit);

  ActivateCheckBox.Caption:=LanguageSetup.GameIPX;
  ConnectionsRadioGroup.Caption:=LanguageSetup.GameIPXEstablishConnection;
  ConnectionsRadioGroup.Items[0]:=LanguageSetup.GameIPXEstablishConnectionNone;
  ConnectionsRadioGroup.Items[1]:=LanguageSetup.GameIPXEstablishConnectionClient;
  ConnectionsRadioGroup.Items[2]:=LanguageSetup.GameIPXEstablishConnectionServer;
  ServerAddressEdit.EditLabel.Caption:=LanguageSetup.GameIPXAddress;
  PortLabel.Caption:=LanguageSetup.GameIPXPort;

  NE2000CheckBox.Caption:=LanguageSetup.GameNE2000;
  NE2000BaseAddressLabel.Caption:=LanguageSetup.GameNE2000BaseAddress;
  NE2000InterruptLabel.Caption:=LanguageSetup.GameNE2000Interrupt;
  NE2000MACAddressEdit.EditLabel.Caption:=LanguageSetup.GameNE2000MACAddress;
  ResetMACButton.Caption:=LanguageSetup.GameNE2000MACAddressReset;
  NE2000RealNICEdit.EditLabel.Caption:=LanguageSetup.GameNE2000RealInterface;
  ListNICButton.Caption:=LanguageSetup.GameNE2000RealInterfaceList;

  NE2000CheckBox.Visible:=PrgSetup.AllowNe2000;
  NE2000BaseAddressLabel.Visible:=PrgSetup.AllowNe2000;
  NE2000BaseAddressComboBox.Visible:=PrgSetup.AllowNe2000;
  NE2000InterruptLabel.Visible:=PrgSetup.AllowNe2000;
  NE2000InterruptComboBox.Visible:=PrgSetup.AllowNe2000;
  NE2000MACAddressEdit.Visible:=PrgSetup.AllowNe2000;
  ResetMACButton.Visible:=PrgSetup.AllowNe2000;
  NE2000RealNICEdit.Visible:=PrgSetup.AllowNe2000;
  ListNICButton.Visible:=PrgSetup.AllowNe2000;

  St:=ValueToList(InitData.GameDB.ConfOpt.NE2000EmulationBaseAddress,';,');
  try
    NE2000BaseAddressComboBox.Items.Clear;
    NE2000BaseAddressComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  St:=ValueToList(InitData.GameDB.ConfOpt.NE2000EmulationInterrupt,';,');
  try
    NE2000InterruptComboBox.Items.Clear;
    NE2000InterruptComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  ProfileDOSBoxInstallation:=InitData.CurrentDOSBoxInstallation;

  HelpContext:=ID_ProfileEditNetwork;
end;

procedure TModernProfileEditorNetworkFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
    I : Integer;
begin
 ActivateCheckBox.Checked:=Game.IPX;
 ConnectionsRadioGroup.ItemIndex:=0;
 S:=Trim(ExtUpperCase(Game.IPXType));
 If (S='') or (S='NONE') then ConnectionsRadioGroup.ItemIndex:=0;
 If S='CLIENT' then ConnectionsRadioGroup.ItemIndex:=1;
 If S='SERVER' then ConnectionsRadioGroup.ItemIndex:=2;
 ServerAddressEdit.Text:=Game.IPXAddress;
 If TryStrToInt(Game.IPXPort,I) then PortEdit.Value:=I else PortEdit.Value:=1;
  ActivateCheckBoxClick(self);

  NE2000CheckBox.Checked:=Game.NE2000;
  NE2000BaseAddressComboBox.ItemIndex:=0;
  S:=Trim(ExtUpperCase(Game.NE2000Base));
  For I:=0 to NE2000BaseAddressComboBox.Items.Count-1 do If Trim(ExtUpperCase(NE2000BaseAddressComboBox.Items[I]))=S then begin
    NE2000BaseAddressComboBox.ItemIndex:=I; break;
  end;
  NE2000InterruptComboBox.ItemIndex:=0;
  S:=IntToStr(Game.NE2000IRQ);
  For I:=0 to NE2000InterruptComboBox.Items.Count-1 do If Trim(ExtUpperCase(NE2000InterruptComboBox.Items[I]))=S then begin
    NE2000InterruptComboBox.ItemIndex:=I; break;
  end;
  NE2000MACAddressEdit.Text:=Game.NE2000MACAddress;
  NE2000RealNICEdit.Text:=Game.NE2000RealInterface;
end;

procedure TModernProfileEditorNetworkFrame.ActivateCheckBoxClick(Sender: TObject);
begin
  ConnectionsRadioGroup.Enabled:=ActivateCheckBox.Checked;
  ServerAddressEdit.Enabled:=ActivateCheckBox.Checked and (ConnectionsRadioGroup.ItemIndex=1);
  PortEdit.Enabled:=ActivateCheckBox.Checked;
end;

procedure TModernProfileEditorNetworkFrame.GetGame(const Game: TGame);
Var I : Integer;
begin
  Game.IPX:=ActivateCheckBox.Checked;
  Case ConnectionsRadioGroup.ItemIndex of
    0 : Game.IPXType:='none';
    1 : Game.IPXType:='client';
    2 : Game.IPXType:='server';
  end;
  Game.IPXAddress:=ServerAddressEdit.Text;
  Game.IPXPort:=IntToStr(Min(99999,Max(1,PortEdit.Value)));

  Game.NE2000:=NE2000CheckBox.Checked;
  Game.NE2000Base:=NE2000BaseAddressComboBox.Items[max(0,NE2000BaseAddressComboBox.ItemIndex)];
  If TryStrToInt(NE2000InterruptComboBox.Items[max(0,NE2000InterruptComboBox.ItemIndex)],I) then Game.NE2000IRQ:=I;
  Game.NE2000MACAddress:=NE2000MACAddressEdit.Text;
  Game.NE2000RealInterface:=NE2000RealNICEdit.Text;
end;

procedure TModernProfileEditorNetworkFrame.ResetMACButtonClick(Sender: TObject);
begin
  NE2000MACAddressEdit.Text:='AC:DE:48:88:99:AA';
end;

procedure TModernProfileEditorNetworkFrame.ListNICButtonClick(Sender: TObject);
Var TempGame : TTempGame;
begin
  TempGame:=TTempGame.Create;
  try
    TempGame.SetSimpleDefaults;
    TempGame.Game.NE2000:=True;
    TempGame.Game.NE2000Base:='300';
    TempGame.Game.NE2000IRQ:=3;
    TempGame.Game.NE2000MACAddress:='AC:DE:48:88:99:AA';
    TempGame.Game.NE2000RealInterface:='list';
    TempGame.Game.ShowConsoleWindow:=2;
    TempGame.Game.CustomDOSBoxDir:=ProfileDOSBoxInstallation^;
    RunCommand(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',True);
  finally
    TempGame.Free;
  end;
end;

end.
