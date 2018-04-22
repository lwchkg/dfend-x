object ModernProfileEditorScummVMSoundFrame: TModernProfileEditorScummVMSoundFrame
  Left = 0
  Top = 0
  Width = 602
  Height = 439
  TabOrder = 0
  DesignSize = (
    602
    439)
  object MusicVolumeLabel: TLabel
    Left = 16
    Top = 16
    Width = 85
    Height = 13
    Caption = 'MusicVolumeLabel'
  end
  object SpeechVolumeLabel: TLabel
    Left = 160
    Top = 16
    Width = 94
    Height = 13
    Caption = 'SpeechVolumeLabel'
  end
  object SFXVolumeLabel: TLabel
    Left = 304
    Top = 16
    Width = 77
    Height = 13
    Caption = 'SFXVolumeLabel'
  end
  object MIDIGainLabel: TLabel
    Left = 16
    Top = 80
    Width = 69
    Height = 13
    Caption = 'MIDIGainLabel'
  end
  object OutputRateLabel: TLabel
    Left = 16
    Top = 144
    Width = 82
    Height = 13
    Caption = 'OutputRateLabel'
  end
  object MusicDriverLabel: TLabel
    Left = 16
    Top = 200
    Width = 80
    Height = 13
    Caption = 'MusicDriverLabel'
  end
  object MusicVolumeEdit: TSpinEdit
    Left = 16
    Top = 35
    Width = 77
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 0
    Value = 192
  end
  object SpeechVolumeEdit: TSpinEdit
    Left = 160
    Top = 35
    Width = 77
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 1
    Value = 192
  end
  object SFXVolumeEdit: TSpinEdit
    Left = 304
    Top = 35
    Width = 77
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 2
    Value = 192
  end
  object MIDIGainEdit: TSpinEdit
    Left = 16
    Top = 99
    Width = 77
    Height = 22
    MaxValue = 1000
    MinValue = 0
    TabOrder = 3
    Value = 100
  end
  object OutputRateComboBox: TComboBox
    Left = 16
    Top = 163
    Width = 94
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 4
  end
  object MusicDriverComboBox: TComboBox
    Left = 16
    Top = 219
    Width = 569
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 5
  end
  object NativeMT32CheckBox: TCheckBox
    Left = 16
    Top = 264
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'NativeMT32CheckBox'
    TabOrder = 6
  end
  object EnableGSCheckBox: TCheckBox
    Left = 16
    Top = 296
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'EnableGSCheckBox'
    TabOrder = 7
  end
  object MultiMIDICheckBox: TCheckBox
    Left = 16
    Top = 328
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'MultiMIDICheckBox'
    TabOrder = 8
  end
  object SpeechMuteCheckBox: TCheckBox
    Left = 16
    Top = 360
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SpeechMuteCheckBox'
    TabOrder = 9
  end
end
