object ModernProfileEditorCPUFrame: TModernProfileEditorCPUFrame
  Left = 0
  Top = 0
  Width = 601
  Height = 559
  TabOrder = 0
  DesignSize = (
    601
    559)
  object CyclesUpLabel: TLabel
    Left = 32
    Top = 312
    Width = 69
    Height = 13
    Caption = 'CyclesUpLabel'
  end
  object CyclesDownLabel: TLabel
    Left = 32
    Top = 368
    Width = 83
    Height = 13
    Caption = 'CyclesDownLabel'
  end
  object CyclesInfoLabel: TLabel
    Left = 32
    Top = 431
    Width = 545
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'CyclesInfoLabel'
    WordWrap = True
  end
  object CPUTypeLabel: TLabel
    Left = 312
    Top = 24
    Width = 69
    Height = 13
    Caption = 'CPUTypeLabel'
  end
  object InfoLabel: TLabel
    Left = 312
    Top = 80
    Width = 265
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object CPUCoreRadioGroup: TRadioGroup
    Left = 24
    Top = 24
    Width = 273
    Height = 137
    Caption = 'CPUCoreRadioGroup'
    TabOrder = 0
  end
  object CPUCyclesGroupBox: TGroupBox
    Left = 24
    Top = 176
    Width = 273
    Height = 113
    Caption = 'CPUCyclesGroupBox'
    TabOrder = 2
    object CyclesAutoRadioButton: TRadioButton
      Left = 16
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Auto'
      TabOrder = 0
      OnClick = CPUCyclesChange
    end
    object CyclesMaxRadioButton: TRadioButton
      Left = 16
      Top = 56
      Width = 113
      Height = 17
      Caption = 'Max'
      TabOrder = 1
      OnClick = CPUCyclesChange
    end
    object CyclesValueRadioButton: TRadioButton
      Left = 16
      Top = 80
      Width = 113
      Height = 17
      Caption = 'Value'
      TabOrder = 3
      OnClick = CPUCyclesChange
    end
    object CyclesComboBox: TComboBox
      Left = 112
      Top = 76
      Width = 104
      Height = 21
      ItemHeight = 13
      TabOrder = 4
    end
    object CyclesMaxLimitCheckBox: TCheckBox
      Left = 112
      Top = 57
      Width = 97
      Height = 17
      Caption = 'Limit value'
      TabOrder = 2
      OnClick = CPUCyclesChange
    end
  end
  object CyclesUpEdit: TSpinEdit
    Left = 32
    Top = 328
    Width = 69
    Height = 22
    MaxValue = 50000
    MinValue = 1
    TabOrder = 3
    Value = 500
  end
  object CyclesDownEdit: TSpinEdit
    Left = 32
    Top = 387
    Width = 69
    Height = 22
    MaxValue = 50000
    MinValue = 1
    TabOrder = 5
    Value = 20
  end
  object CPUTypeComboBox: TComboBox
    Left = 312
    Top = 43
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object CyclesUpComboBox: TComboBox
    Left = 107
    Top = 328
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = CyclesUpComboBoxChange
  end
  object CyclesDownComboBox: TComboBox
    Left = 107
    Top = 387
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = CyclesDownComboBoxChange
  end
end
