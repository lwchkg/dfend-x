unit ModernProfileEditorSerialPortFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorSerialPortFrame = class(TFrame, IModernProfileEditorFrame)
    IRQLabel: TLabel;
    IRQComboBox: TComboBox;
    DeviceTypeGroupBox: TGroupBox;
    SerialTypeDisabledRadioButton: TRadioButton;
    SerialTypeDummyRadioButton: TRadioButton;
    SerialTypeModemRadioButton: TRadioButton;
    SerialTypeNullmodemRadioButton: TRadioButton;
    SerialTypeDirectSerialRadioButton: TRadioButton;
    ModemPanel: TPanel;
    ModemIPEdit: TLabeledEdit;
    ModemPortEdit: TSpinEdit;
    ModemPortLabel: TLabel;
    ModemListenCheckBox: TCheckBox;
    NullModemPanel: TPanel;
    NullModemPortLabel: TLabel;
    NullModemPortEdit: TSpinEdit;
    NullModemServerRadioButton: TRadioButton;
    NullModemClientRadioButton: TRadioButton;
    NullModemServerAddressEdit: TEdit;
    NullModemRXDelayLabel: TLabel;
    NullModemRXDelayEdit: TSpinEdit;
    NullModemTXDelayLabel: TLabel;
    NullModemTXDelayEdit: TSpinEdit;
    NullModemTelnetCheckBox: TCheckBox;
    NullModemDTRCheckBox: TCheckBox;
    NullModemTransparentCheckBox: TCheckBox;
    DirectSerialPanel: TPanel;
    DirectSerialRXDelayEdit: TSpinEdit;
    DirectSerialRXDelayLabel: TLabel;
    DirectSerialPortEdit: TLabeledEdit;
    procedure DeviceTypeClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure SetIRQ(const S: String);
  public
    { Public-Deklarationen }
    PortNr : Integer;
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorSerialPortFrame }

procedure TModernProfileEditorSerialPortFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  Name:='SerialPort'+IntToStr(PortNr)+'Frame';

  NoFlicker(DeviceTypeGroupBox);
  NoFlicker(SerialTypeDisabledRadioButton);
  NoFlicker(SerialTypeDummyRadioButton);
  NoFlicker(SerialTypeModemRadioButton);
  NoFlicker(SerialTypeNullmodemRadioButton);
  NoFlicker(SerialTypeDirectSerialRadioButton);
  NoFlicker(IRQComboBox);
  NoFlicker(ModemPanel);
  NoFlicker(ModemIPEdit);
  NoFlicker(ModemPortEdit);
  NoFlicker(ModemListenCheckBox);
  NoFlicker(NullModemPanel);
  NoFlicker(NullModemPortEdit);
  NoFlicker(NullModemServerRadioButton);
  NoFlicker(NullModemClientRadioButton);
  NoFlicker(NullModemServerAddressEdit);
  NoFlicker(NullModemRXDelayEdit);
  NoFlicker(NullModemTXDelayEdit);
  NoFlicker(NullModemTelnetCheckBox);
  NoFlicker(NullModemDTRCheckBox);
  NoFlicker(NullModemTransparentCheckBox);
  NoFlicker(DirectSerialPanel);
  NoFlicker(DirectSerialPortEdit);
  NoFlicker(DirectSerialRXDelayEdit);

  DeviceTypeGroupBox.Caption:=LanguageSetup.SerialFormDeviceType;
  SerialTypeDisabledRadioButton.Caption:=LanguageSetup.SerialFormDeviceTypeDisabled;
  SerialTypeDummyRadioButton.Caption:=LanguageSetup.SerialFormDeviceTypeDummy;
  SerialTypeModemRadioButton.Caption:=LanguageSetup.SerialFormDeviceTypeModem;
  SerialTypeNullModemRadioButton.Caption:=LanguageSetup.SerialFormDeviceTypeNullModem;
  SerialTypeDirectSerialRadioButton.Caption:=LanguageSetup.SerialFormDeviceTypeDirectSerial;

  IRQLabel.Caption:=LanguageSetup.SerialFormIRQ;
  IRQComboBox.Items[0]:=LanguageSetup.SerialFormIRQNone;

  ModemIPEdit.EditLabel.Caption:=LanguageSetup.SerialFormModemServerIP;
  ModemPortLabel.Caption:=LanguageSetup.SerialFormModemPort;
  ModemListenCheckBox.Caption:=LanguageSetup.SerialFormModemListen;

  NullModemPortLabel.Caption:=LanguageSetup.SerialFormNullModemPort;
  NullModemServerRadioButton.Caption:=LanguageSetup.SerialFormNullModemServerMode;
  NullModemClientRadioButton.Caption:=LanguageSetup.SerialFormNullModemClientMode;
  NullModemRXDelayLabel.Caption:=LanguageSetup.SerialFormRXDelay;
  NullModemTXDelayLabel.Caption:=LanguageSetup.SerialFormTXDelay;
  NullModemTelnetCheckBox.Caption:=LanguageSetup.SerialFormNullModemTelnet;
  NullModemDTRCheckBox.Caption:=LanguageSetup.SerialFormNullModemDTR;
  NullModemTransparentCheckBox.Caption:=LanguageSetup.SerialFormNullModemTransparent;

  DirectSerialPortEdit.EditLabel.Caption:=LanguageSetup.SerialFormDirectSerialPort;
  DirectSerialRXDelayLabel.Caption:=LanguageSetup.SerialFormRXDelay;

  HelpContext:=ID_ProfileEditSerialPorts;
end;

procedure TModernProfileEditorSerialPortFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Procedure Divide(const Data : String; Var Name, Value : String); Var I : Integer; begin I:=Pos(':',Data); If I=0 then begin Name:=Data; Value:=''; end else begin Name:=Trim(Copy(Data,1,I-1)); Value:=Trim(Copy(Data,I+1,MaxInt)); end; end;
Var S,Key,DataKey,DataValue : String;
    Data : TStringList;
    I,J : Integer;
begin
  IRQComboBox.ItemIndex:=0;

  Case PortNr of
    1 : S:=Game.Serial1;
    2 : S:=Game.Serial2;
    3 : S:=Game.Serial3;
    4 : S:=Game.Serial4;
    else S:=Game.Serial1;
  end;
  S:=Trim(ExtUpperCase(S));

  Data:=TStringList.Create;
  try
    I:=Pos(' ',S); If I=0 then begin Key:=S; S:=''; end else begin Key:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;

    while S<>'' do begin
      I:=Pos(' ',S);
      If I=0 then begin
        Data.Add(S);
        S:='';
      end else begin
        Data.Add(Trim(Copy(S,1,I-1)));
        S:=Trim(Copy(S,I+1,MaxInt));
      end;
    end;

    If Key='DUMMY' then begin
      SerialTypeDummyRadioButton.Checked:=True;
      For I:=0 to Data.Count-1 do begin
        Divide(Data[I],DataKey,DataValue);
        If DataKey='IRQ' then SetIRQ(DataValue);
      end;
      exit;
    end;

    If Key='MODEM' then begin
      SerialTypeModemRadioButton.Checked:=True;
      For I:=0 to Data.Count-1 do begin
        Divide(Data[I],DataKey,DataValue);
        {If DataKey='IRQ' then SetIRQ(DataValue);
        If DataKey='SERVER' then ModemIPEdit.Text:=DataValue;
        If DataKey='PORT' then begin try J:=Min(65535,Max(1,StrToInt(DataValue))); except J:=5000; end; ModemPortEdit.Value:=J; end;}
        If DataKey='LISTENPORT' then begin
          If Trim(DataValue)='0' then begin
            ModemListenCheckBox.Checked:=False;
          end else begin
            ModemListenCheckBox.Checked:=True;
            try J:=Min(65535,Max(1,StrToInt(DataValue))); except J:=5000; end;
            ModemPortEdit.Value:=J;
          end;
        end;
      end;
      exit;
    end;

    If Key='NULLMODEM' then begin
      SerialTypeNullModemRadioButton.Checked:=True;
      For I:=0 to Data.Count-1 do begin
        Divide(Data[I],DataKey,DataValue);
        If DataKey='IRQ' then SetIRQ(DataValue);
        If DataKey='PORT' then begin try J:=Min(65535,Max(1,StrToInt(DataValue))); except J:=5000; end; NullModemPortEdit.Value:=J; end;
        If DataKey='SERVER' then begin NullModemClientRadioButton.Checked:=True; NullModemServerAddressEdit.Text:=DataValue; end;
        If DataKey='RXDELAY' then begin try J:=Min(1000,Max(0,StrToInt(DataValue))); except J:=100; end; NullModemRXDelayEdit.Value:=J; end;
        If DataKey='TXDELAY' then begin try J:=Min(1000,Max(0,StrToInt(DataValue))); except J:=12; end; NullModemTXDelayEdit.Value:=J; end;
        If DataKey='TELNET' then NullModemTelnetCheckBox.Checked:=(DataValue<>'0');
        If DataKey='USEDTR' then NullModemDTRCheckBox.Checked:=(DataValue<>'0');
        If DataKey='TRANSPARENT' then NullModemTransparentCheckBox.Checked:=(DataValue<>'0');
      end;
      exit;
    end;

    If Key='DIRECTSERIAL' then begin
      SerialTypeDirectSerialRadioButton.Checked:=True;
      For I:=0 to Data.Count-1 do begin
        Divide(Data[I],DataKey,DataValue);
        If DataKey='IRQ' then SetIRQ(DataValue);
        If DataKey='REALPORT' then DirectSerialPortEdit.Text:=DataValue;
        If DataKey='RXDELAY' then begin try J:=Min(1000,Max(0,StrToInt(DataValue))); except J:=100; end; DirectSerialRXDelayEdit.Value:=J; end;
      end;
      exit;
    end;

    {KEY='DISABLED'}
    SerialTypeDisabledRadioButton.Checked:=True;
  finally
    Data.Free;
    DeviceTypeClick(Self);
  end;
end;

procedure TModernProfileEditorSerialPortFrame.SetIRQ(const S: String);
Var I : Integer;
begin
  I:=IRQComboBox.Items.IndexOf(S);
  If I>=0 then IRQComboBox.ItemIndex:=I;
end;

procedure TModernProfileEditorSerialPortFrame.DeviceTypeClick(Sender: TObject);
Procedure SetPanel(const P : TPanel);
begin
  P.Left:=IRQComboBox.Left-17; P.Top:=IRQComboBox.Top+IRQComboBox.Height+15;
  P.Width:=ClientWidth-10-P.Left; P.Height:=ClientHeight-10-P.Top;
  P.Visible:=True; P.Anchors:=[akLeft,akTop,akRight,akBottom];
end;
begin
  IRQComboBox.Enabled:=not SerialTypeDisabledRadioButton.Checked;

  ModemPanel.Visible:=False;
  NullModemPanel.Visible:=False;
  DirectSerialPanel.Visible:=False;

  If SerialTypeModemRadioButton.Checked then SetPanel(ModemPanel);
  If SerialTypeNullmodemRadioButton.Checked then SetPanel(NullModemPanel);
  If SerialTypeDirectSerialRadioButton.Checked then SetPanel(DirectSerialPanel);

  ModemIPEdit.Enabled:=not ModemListenCheckBox.Checked;
  ModemPortEdit.Enabled:=ModemListenCheckBox.Checked;

  NullModemServerAddressEdit.Enabled:=NullModemClientRadioButton.Checked;
end;

procedure TModernProfileEditorSerialPortFrame.GetGame(const Game: TGame);
Var IRQ : String;
    S : String;
begin
  If IRQComboBox.Enabled and (IRQComboBox.ItemIndex>0) then IRQ:=' IRQ:'+IRQComboBox.Text else IRQ:='';

  If SerialTypeDisabledRadioButton.Checked then begin
    S:='Disabled';
  end;

  If SerialTypeDummyRadioButton.Checked then begin
    S:='Dummy'+IRQ;
  end;

  If SerialTypeModemRadioButton.Checked then begin
    S:='Modem'+IRQ;
    If ModemListenCheckBox.Checked then begin
      S:=S+' Listenport:'+IntToStr(ModemPortEdit.Value);
    end else begin
      S:=S+' Listenport:0';
      {S:=S+' Port:'+IntToStr(ModemPortEdit.Value)+' Server:'+ModemIPEdit.Text;}
    end;
  end;

  If SerialTypeNullModemRadioButton.Checked then begin
    S:='NullModem'+IRQ+' Port:'+IntToStr(NullModemPortEdit.Value);
    If NullModemClientRadioButton.Checked then S:=S+' Server:'+NullModemServerAddressEdit.Text;
    If NullModemRXDelayEdit.Value<>100 then S:=S+' RXDelay:'+IntToStr(NullModemRXDelayEdit.Value);
    If NullModemTXDelayEdit.Value<>12 then S:=S+' TXDelay:'+IntToStr(NullModemTXDelayEdit.Value);
    If NullModemTelnetCheckBox.Checked then S:=S+' Telnet:1';
    If NullModemDTRCheckBox.Checked then S:=S+' UseDTR:1';
    If NullModemTransparentCheckBox.Checked then S:=S+' Transparent:1';
  end;

  If SerialTypeDirectSerialRadioButton.Checked then begin
    S:='DirectSerial'+IRQ+' Realport:'+DirectSerialPortEdit.Text;
    If DirectSerialRXDelayEdit.Value<>100 then S:=S+' RXDelay:'+IntToStr(DirectSerialRXDelayEdit.Value);
  end;

  Case PortNr of
    1 : Game.Serial1:=S;
    2 : Game.Serial2:=S;
    3 : Game.Serial3:=S;
    4 : Game.Serial4:=S;
  end;
end;

end.
