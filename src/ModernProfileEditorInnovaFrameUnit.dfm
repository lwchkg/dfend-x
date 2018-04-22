object ModernProfileEditorInnovaFrame: TModernProfileEditorInnovaFrame
  Left = 0
  Top = 0
  Width = 701
  Height = 256
  TabOrder = 0
  DesignSize = (
    701
    256)
  object InnovaSampleRateLabel: TLabel
    Left = 24
    Top = 64
    Width = 158
    Height = 13
    Caption = 'Innovation SSI-2001 sample rate'
  end
  object InnovaBaseLabel: TLabel
    Left = 24
    Top = 128
    Width = 166
    Height = 13
    Caption = 'Innovation SSI-2001 base address'
  end
  object InnovaQualityLabel: TLabel
    Left = 24
    Top = 192
    Width = 183
    Height = 13
    Caption = 'Innovation SSI-2001 emulation quality'
  end
  object EnableInnovaCheckBox: TCheckBox
    Left = 24
    Top = 24
    Width = 665
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enable Innovation SSI-2001 emulation'
    TabOrder = 0
  end
  object InnovaSampleRateComboBox: TComboBox
    Left = 24
    Top = 83
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object InnovaBaseComboBox: TComboBox
    Left = 24
    Top = 147
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object InnovaQualityComboBox: TComboBox
    Left = 24
    Top = 211
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
end
