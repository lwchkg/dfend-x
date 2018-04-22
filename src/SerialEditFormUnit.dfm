object SerialEditForm: TSerialEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Serial port settings'
  ClientHeight = 397
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object IRQLabel: TLabel
    Left = 224
    Top = 8
    Width = 23
    Height = 13
    Caption = 'IR&Q:'
    FocusControl = IRQComboBox
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 364
    Width = 97
    Height = 25
    TabOrder = 3
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 364
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object IRQComboBox: TComboBox
    Left = 224
    Top = 27
    Width = 73
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'None'
    Items.Strings = (
      'None'
      '3'
      '5'
      '6'
      '7'
      '9'
      '10'
      '11'
      '15')
  end
  object DeviceTypeGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 145
    Caption = 'Device type'
    TabOrder = 0
    object SerialTypeDisabledRadioButton: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Disabled'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = DeviceTypeClick
    end
    object SerialTypeDummyRadioButton: TRadioButton
      Left = 16
      Top = 46
      Width = 113
      Height = 17
      Caption = 'Dummy'
      TabOrder = 1
      OnClick = DeviceTypeClick
    end
    object SerialTypeModemRadioButton: TRadioButton
      Left = 16
      Top = 69
      Width = 113
      Height = 17
      Caption = 'Modem'
      TabOrder = 2
      OnClick = DeviceTypeClick
    end
    object SerialTypeNullmodemRadioButton: TRadioButton
      Left = 16
      Top = 92
      Width = 113
      Height = 17
      Caption = 'Nullmodel'
      TabOrder = 3
      OnClick = DeviceTypeClick
    end
    object SerialTypeDirectSerialRadioButton: TRadioButton
      Left = 16
      Top = 115
      Width = 153
      Height = 17
      Caption = 'Direct serial'
      TabOrder = 4
      OnClick = DeviceTypeClick
    end
  end
  object Notebook: TNotebook
    Left = 207
    Top = 54
    Width = 268
    Height = 296
    PageIndex = 1
    TabOrder = 2
    object TPage
      Left = 0
      Top = 0
      Caption = 'Empty'
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Modem'
      object ModemPortLabel: TLabel
        Left = 17
        Top = 48
        Width = 20
        Height = 13
        Caption = 'Port'
      end
      object ModemListenCheckBox: TCheckBox
        Left = 17
        Top = 104
        Width = 240
        Height = 17
        Caption = 'Listen for connections'
        TabOrder = 0
        OnClick = DeviceTypeClick
      end
      object ModemPortEdit: TSpinEdit
        Left = 17
        Top = 67
        Width = 73
        Height = 22
        MaxValue = 65535
        MinValue = 1
        TabOrder = 1
        Value = 23
      end
      object ModemIPEdit: TLabeledEdit
        Left = 17
        Top = 21
        Width = 121
        Height = 21
        EditLabel.Width = 86
        EditLabel.Height = 13
        EditLabel.Caption = 'Server IP address'
        TabOrder = 2
        Visible = False
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'NullModem'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object NullModemPortLabel: TLabel
        Left = 17
        Top = 8
        Width = 46
        Height = 13
        Caption = 'TCP Port:'
      end
      object NullModemRXDelayLabel: TLabel
        Left = 17
        Top = 136
        Width = 46
        Height = 13
        Caption = 'RX delay:'
      end
      object NullModemTXDelayLabel: TLabel
        Left = 17
        Top = 183
        Width = 45
        Height = 13
        Caption = 'TX delay:'
      end
      object NullModemPortEdit: TSpinEdit
        Left = 17
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 65535
        MinValue = 1
        TabOrder = 0
        Value = 23
      end
      object NullModemServerRadioButton: TRadioButton
        Left = 17
        Top = 62
        Width = 113
        Height = 17
        Caption = 'Server mode'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = DeviceTypeClick
      end
      object NullModemClientRadioButton: TRadioButton
        Left = 17
        Top = 79
        Width = 176
        Height = 17
        Caption = 'Client mode; server address:'
        TabOrder = 2
        OnClick = DeviceTypeClick
      end
      object NullModemServerAddressEdit: TEdit
        Left = 32
        Top = 102
        Width = 89
        Height = 21
        TabOrder = 3
      end
      object NullModemRXDelayEdit: TSpinEdit
        Left = 17
        Top = 155
        Width = 66
        Height = 22
        MaxValue = 1000
        MinValue = 0
        TabOrder = 4
        Value = 100
      end
      object NullModemTXDelayEdit: TSpinEdit
        Left = 17
        Top = 202
        Width = 66
        Height = 22
        MaxValue = 1000
        MinValue = 0
        TabOrder = 5
        Value = 12
      end
      object NullModemTelnetCheckBox: TCheckBox
        Left = 17
        Top = 230
        Width = 97
        Height = 17
        Caption = 'Telnet'
        TabOrder = 6
      end
      object NullModemDTRCheckBox: TCheckBox
        Left = 17
        Top = 253
        Width = 97
        Height = 17
        Caption = 'DTR'
        TabOrder = 7
      end
      object NullModemTransparentCheckBox: TCheckBox
        Left = 17
        Top = 276
        Width = 97
        Height = 17
        Caption = 'Transparent'
        TabOrder = 8
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'DirectSerial'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DirectSerialRXDelayLabel: TLabel
        Left = 17
        Top = 61
        Width = 46
        Height = 13
        Caption = 'RX delay:'
      end
      object DirectSerialPortEdit: TLabeledEdit
        Left = 17
        Top = 26
        Width = 88
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'Real port'
        TabOrder = 0
        Text = 'COM1'
      end
      object DirectSerialRXDelayEdit: TSpinEdit
        Left = 17
        Top = 80
        Width = 88
        Height = 22
        MaxValue = 1000
        MinValue = 0
        TabOrder = 1
        Value = 100
      end
    end
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 364
    Width = 97
    Height = 25
    TabOrder = 5
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
