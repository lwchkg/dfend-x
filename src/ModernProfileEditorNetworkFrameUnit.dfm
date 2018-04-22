object ModernProfileEditorNetworkFrame: TModernProfileEditorNetworkFrame
  Left = 0
  Top = 0
  Width = 553
  Height = 419
  TabOrder = 0
  DesignSize = (
    553
    419)
  object PortLabel: TLabel
    Left = 471
    Top = 149
    Width = 45
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'PortLabel'
  end
  object NE2000BaseAddressLabel: TLabel
    Left = 24
    Top = 256
    Width = 104
    Height = 13
    Caption = 'NE2000 base address'
  end
  object NE2000InterruptLabel: TLabel
    Left = 208
    Top = 256
    Width = 82
    Height = 13
    Caption = 'NE2000 interrupt'
  end
  object ActivateCheckBox: TCheckBox
    Left = 24
    Top = 24
    Width = 526
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ActivateCheckBox'
    TabOrder = 0
    OnClick = ActivateCheckBoxClick
  end
  object ConnectionsRadioGroup: TRadioGroup
    Left = 24
    Top = 56
    Width = 185
    Height = 81
    Caption = 'ConnectionsRadioGroup'
    Items.Strings = (
      'None'
      'Client'
      'Server')
    TabOrder = 1
    OnClick = ActivateCheckBoxClick
  end
  object ServerAddressEdit: TLabeledEdit
    Left = 24
    Top = 168
    Width = 401
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 89
    EditLabel.Height = 13
    EditLabel.Caption = 'ServerAddressEdit'
    TabOrder = 2
  end
  object PortEdit: TSpinEdit
    Left = 471
    Top = 168
    Width = 63
    Height = 22
    Anchors = [akTop, akRight]
    MaxValue = 65535
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
  object NE2000CheckBox: TCheckBox
    Left = 24
    Top = 224
    Width = 526
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Activate NE2000 emulation'
    TabOrder = 4
  end
  object NE2000BaseAddressComboBox: TComboBox
    Left = 24
    Top = 275
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'NE2000BaseAddressComboBox'
  end
  object NE2000InterruptComboBox: TComboBox
    Left = 208
    Top = 275
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = 'NE2000InterruptComboBox'
  end
  object NE2000MACAddressEdit: TLabeledEdit
    Left = 24
    Top = 325
    Width = 297
    Height = 21
    EditLabel.Width = 103
    EditLabel.Height = 13
    EditLabel.Caption = 'NE2000 MAC address'
    TabOrder = 7
  end
  object ResetMACButton: TButton
    Left = 327
    Top = 323
    Width = 146
    Height = 25
    Caption = 'Reset to default'
    TabOrder = 8
    OnClick = ResetMACButtonClick
  end
  object NE2000RealNICEdit: TLabeledEdit
    Left = 24
    Top = 376
    Width = 297
    Height = 21
    EditLabel.Width = 97
    EditLabel.Height = 13
    EditLabel.Caption = 'Real network device'
    TabOrder = 9
  end
  object ListNICButton: TButton
    Left = 327
    Top = 374
    Width = 146
    Height = 25
    Caption = 'List real network devices'
    TabOrder = 10
    OnClick = ListNICButtonClick
  end
end
