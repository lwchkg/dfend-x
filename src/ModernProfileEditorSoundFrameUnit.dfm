object ModernProfileEditorSoundFrame: TModernProfileEditorSoundFrame
  Left = 0
  Top = 0
  Width = 556
  Height = 541
  TabOrder = 0
  DesignSize = (
    556
    541)
  object PCSpeakerSampleRateLabel: TLabel
    Left = 40
    Top = 215
    Width = 134
    Height = 13
    Caption = 'PCSpeakerSampleRateLabel'
  end
  object TandySampleRateLabel: TLabel
    Left = 24
    Top = 391
    Width = 112
    Height = 13
    Caption = 'TandySampleRateLabel'
  end
  object ActivateSoundCheckBox: TCheckBox
    Left = 24
    Top = 24
    Width = 508
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ActivateSoundCheckBox'
    TabOrder = 0
    ExplicitWidth = 425
  end
  object MixerGroupBox: TGroupBox
    Left = 40
    Top = 56
    Width = 492
    Height = 97
    Caption = 'MixerGroupBox'
    TabOrder = 1
    object SampleRateLabel: TLabel
      Left = 16
      Top = 32
      Width = 82
      Height = 13
      Caption = 'SampleRateLabel'
    end
    object BlockSizeLabel: TLabel
      Left = 184
      Top = 32
      Width = 68
      Height = 13
      Caption = 'BlockSizeLabel'
    end
    object PreBufferLabel: TLabel
      Left = 360
      Top = 34
      Width = 71
      Height = 13
      Caption = 'PreBufferLabel'
    end
    object SampleRateComboBox: TComboBox
      Left = 16
      Top = 51
      Width = 82
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object BlockSizeComboBox: TComboBox
      Left = 184
      Top = 51
      Width = 82
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
    object PreBufferComboBox: TComboBox
      Left = 360
      Top = 53
      Width = 82
      Height = 21
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object ActivatePCSpeakerCheckBox: TCheckBox
    Left = 24
    Top = 184
    Width = 508
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ActivatePCSpeakerCheckBox'
    TabOrder = 2
    ExplicitWidth = 425
  end
  object PCSpeakerSampleRateComboBox: TComboBox
    Left = 40
    Top = 234
    Width = 82
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object TandyRadioGroup: TRadioGroup
    Left = 24
    Top = 288
    Width = 150
    Height = 89
    Caption = 'TandyRadioGroup'
    Items.Strings = (
      'auto'
      'on'
      'off')
    TabOrder = 4
  end
  object TandyComboBox: TComboBox
    Left = 24
    Top = 410
    Width = 82
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object ActivateDisneyCheckBox: TCheckBox
    Left = 24
    Top = 464
    Width = 508
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ActivateDisneyCheckBox'
    TabOrder = 6
    ExplicitWidth = 425
  end
end
