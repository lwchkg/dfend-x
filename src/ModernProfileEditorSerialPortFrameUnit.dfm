object ModernProfileEditorSerialPortFrame: TModernProfileEditorSerialPortFrame
  Left = 0
  Top = 0
  Width = 598
  Height = 602
  TabOrder = 0
  object IRQLabel: TLabel
    Left = 224
    Top = 8
    Width = 23
    Height = 13
    Caption = 'IR&Q:'
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
    TabOrder = 0
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
    TabOrder = 1
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
  object ModemPanel: TPanel
    Left = 24
    Top = 208
    Width = 209
    Height = 145
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    DesignSize = (
      209
      145)
    object ModemPortLabel: TLabel
      Left = 17
      Top = 48
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object ModemIPEdit: TLabeledEdit
      Left = 17
      Top = 21
      Width = 121
      Height = 21
      EditLabel.Width = 86
      EditLabel.Height = 13
      EditLabel.Caption = 'Server IP address'
      TabOrder = 0
      Visible = False
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
    object ModemListenCheckBox: TCheckBox
      Left = 17
      Top = 104
      Width = 176
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Listen for connections'
      TabOrder = 2
      OnClick = DeviceTypeClick
    end
  end
  object NullModemPanel: TPanel
    Left = 256
    Top = 208
    Width = 289
    Height = 369
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    DesignSize = (
      289
      369)
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
      Width = 264
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Server mode'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = DeviceTypeClick
    end
    object NullModemClientRadioButton: TRadioButton
      Left = 17
      Top = 79
      Width = 264
      Height = 17
      Anchors = [akLeft, akTop, akRight]
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
      Width = 264
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Telnet'
      TabOrder = 6
    end
    object NullModemDTRCheckBox: TCheckBox
      Left = 17
      Top = 253
      Width = 264
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'DTR'
      TabOrder = 7
    end
    object NullModemTransparentCheckBox: TCheckBox
      Left = 17
      Top = 276
      Width = 264
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Transparent'
      TabOrder = 8
    end
  end
  object DirectSerialPanel: TPanel
    Left = 24
    Top = 391
    Width = 209
    Height = 186
    BevelOuter = bvNone
    TabOrder = 4
    Visible = False
    object DirectSerialRXDelayLabel: TLabel
      Left = 17
      Top = 61
      Width = 46
      Height = 13
      Caption = 'RX delay:'
    end
    object DirectSerialRXDelayEdit: TSpinEdit
      Left = 17
      Top = 80
      Width = 88
      Height = 22
      MaxValue = 1000
      MinValue = 0
      TabOrder = 0
      Value = 100
    end
    object DirectSerialPortEdit: TLabeledEdit
      Left = 17
      Top = 26
      Width = 88
      Height = 21
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = 'Real port'
      TabOrder = 1
      Text = 'COM1'
    end
  end
end
