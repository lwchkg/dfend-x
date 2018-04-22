unit SerialEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin;

type
  TSerialEditForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    IRQComboBox: TComboBox;
    IRQLabel: TLabel;
    DeviceTypeGroupBox: TGroupBox;
    SerialTypeDisabledRadioButton: TRadioButton;
    SerialTypeDummyRadioButton: TRadioButton;
    SerialTypeModemRadioButton: TRadioButton;
    SerialTypeNullmodemRadioButton: TRadioButton;
    SerialTypeDirectSerialRadioButton: TRadioButton;
    Notebook: TNotebook;
    ModemListenCheckBox: TCheckBox;
    ModemPortEdit: TSpinEdit;
    ModemIPEdit: TLabeledEdit;
    ModemPortLabel: TLabel;
    NullModemPortLabel: TLabel;
    NullModemPortEdit: TSpinEdit;
    NullModemServerRadioButton: TRadioButton;
    NullModemClientRadioButton: TRadioButton;
    NullModemServerAddressEdit: TEdit;
    NullModemRXDelayLabel: TLabel;
    NullModemRXDelayEdit: TSpinEdit;
    NullModemTXDelayEdit: TSpinEdit;
    NullModemTXDelayLabel: TLabel;
    NullModemTelnetCheckBox: TCheckBox;
    NullModemDTRCheckBox: TCheckBox;
    NullModemTransparentCheckBox: TCheckBox;
    DirectSerialPortEdit: TLabeledEdit;
    DirectSerialRXDelayEdit: TSpinEdit;
    DirectSerialRXDelayLabel: TLabel;
    HelpButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure DeviceTypeClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Procedure InitGUI;
    Procedure DecodeString;
    Procedure SetIRQ(const S : String);
  public
    { Public-Deklarationen }
    ProfileString : String;
  end;

var SerialEditForm: TSerialEditForm;

Function ShowSerialEditDialog(const AOwner : TComponent; var AProfileString : String) : Boolean;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts,
     IconLoaderUnit;

{$R *.dfm}

procedure TSerialEditForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  InitGUI;
  DecodeString;
end;

procedure TSerialEditForm.InitGUI;
begin
  Caption:=LanguageSetup.SerialFormCaption;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

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

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TSerialEditForm.SetIRQ(const S: String);
Var I : Integer;
begin
  I:=IRQComboBox.Items.IndexOf(S);
  If I>=0 then IRQComboBox.ItemIndex:=I;
end;

procedure TSerialEditForm.DecodeString;
Procedure Divide(const Data : String; Var Name, Value : String); Var I : Integer; begin I:=Pos(':',Data); If I=0 then begin Name:=Data; Value:=''; end else begin Name:=Trim(Copy(Data,1,I-1)); Value:=Trim(Copy(Data,I+1,MaxInt)); end; end;
Var S,Key,DataKey,DataValue : String;
    Data : TStringList;
    I,J : Integer;
begin
  IRQComboBox.ItemIndex:=0;

  S:=Trim(ExtUpperCase(ProfileString));

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
        If DataKey='IRQ' then SetIRQ(DataValue);
        {If DataKey='SERVER' then ModemIPEdit.Text:=DataValue;}
        {If DataKey='PORT' then begin try J:=Min(65535,Max(1,StrToInt(DataValue))); except J:=5000; end; ModemPortEdit.Value:=J; end;}
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

procedure TSerialEditForm.DeviceTypeClick(Sender: TObject);
begin
  IRQComboBox.Enabled:=not SerialTypeDisabledRadioButton.Checked;

  If SerialTypeDisabledRadioButton.Checked or SerialTypeDummyRadioButton.Checked then Notebook.PageIndex:=0;
  If SerialTypeModemRadioButton.Checked then Notebook.PageIndex:=1;
  If SerialTypeNullmodemRadioButton.Checked then Notebook.PageIndex:=2;
  If SerialTypeDirectSerialRadioButton.Checked then Notebook.PageIndex:=3;

  ModemIPEdit.Enabled:=not ModemListenCheckBox.Checked;
  ModemPortEdit.Enabled:=ModemListenCheckBox.Checked;

  NullModemServerAddressEdit.Enabled:=NullModemClientRadioButton.Checked;
end;

procedure TSerialEditForm.OKButtonClick(Sender: TObject);
Var IRQ : String;
begin
  If IRQComboBox.Enabled and (IRQComboBox.ItemIndex>0) then IRQ:=' IRQ:'+IRQComboBox.Text else IRQ:='';

  If SerialTypeDisabledRadioButton.Checked then begin
    ProfileString:='Disabled';
    exit;
  end;

  If SerialTypeDummyRadioButton.Checked then begin
    ProfileString:='Dummy'+IRQ;
    exit;
  end;

  If SerialTypeModemRadioButton.Checked then begin
    ProfileString:='Modem'+IRQ;
    If ModemListenCheckBox.Checked then begin
      ProfileString:=ProfileString+' Listenport:'+IntToStr(ModemPortEdit.Value);
    end else begin
      ProfileString:=ProfileString+' Listenport:0';
      {ProfileString:=ProfileString+' Port:'+IntToStr(ModemPortEdit.Value)+' Server:'+ModemIPEdit.Text;}
    end;
    exit;
  end;

  If SerialTypeNullModemRadioButton.Checked then begin
    ProfileString:='NullModem'+IRQ+' Port:'+IntToStr(NullModemPortEdit.Value);
    If NullModemClientRadioButton.Checked then ProfileString:=ProfileString+' Server:'+NullModemServerAddressEdit.Text;
    If NullModemRXDelayEdit.Value<>100 then ProfileString:=ProfileString+' RXDelay:'+IntToStr(NullModemRXDelayEdit.Value);
    If NullModemTXDelayEdit.Value<>12 then ProfileString:=ProfileString+' TXDelay:'+IntToStr(NullModemTXDelayEdit.Value);
    If NullModemTelnetCheckBox.Checked then ProfileString:=ProfileString+' Telnet:1';
    If NullModemDTRCheckBox.Checked then ProfileString:=ProfileString+' UseDTR:1';
    If NullModemTransparentCheckBox.Checked then ProfileString:=ProfileString+' Transparent:1';
    exit;
  end;

  If SerialTypeDirectSerialRadioButton.Checked then begin
    ProfileString:='DirectSerial'+IRQ+' Realport:'+DirectSerialPortEdit.Text;
    If DirectSerialRXDelayEdit.Value<>100 then ProfileString:=ProfileString+' RXDelay:'+IntToStr(DirectSerialRXDelayEdit.Value);
    exit;
  end;
end;

procedure TSerialEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileEditSerialPorts);
end;

procedure TSerialEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowSerialEditDialog(const AOwner : TComponent; var AProfileString : String) : Boolean;
begin
  SerialEditForm:=TSerialEditForm.Create(AOwner);
  try
    SerialEditForm.ProfileString:=AProfileString;
    result:=(SerialEditForm.ShowModal=mrOK);
    if result then AProfileString:=SerialEditForm.ProfileString;
  finally
    SerialEditForm.Free;
  end;
end;

end.
