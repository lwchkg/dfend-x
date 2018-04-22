object ModernProfileEditorGraphicsFrame: TModernProfileEditorGraphicsFrame
  Left = 0
  Top = 0
  Width = 640
  Height = 537
  TabOrder = 0
  DesignSize = (
    640
    537)
  object WindowResolutionLabel: TLabel
    Left = 24
    Top = 13
    Width = 113
    Height = 13
    Caption = 'WindowResolutionLabel'
  end
  object FullscreenResolutionLabel: TLabel
    Left = 184
    Top = 13
    Width = 123
    Height = 13
    Caption = 'FullscreenResolutionLabel'
  end
  object RenderLabel: TLabel
    Left = 24
    Top = 296
    Width = 60
    Height = 13
    Caption = 'RenderLabel'
  end
  object VideoCardLabel: TLabel
    Left = 184
    Top = 296
    Width = 74
    Height = 13
    Caption = 'VideoCardLabel'
  end
  object ScaleLabel: TLabel
    Left = 24
    Top = 352
    Width = 50
    Height = 13
    Caption = 'ScaleLabel'
  end
  object FrameSkipLabel: TLabel
    Left = 422
    Top = 352
    Width = 74
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'FrameSkipLabel'
  end
  object FullscreenInfoLabel: TLabel
    Left = 40
    Top = 138
    Width = 584
    Height = 35
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'FullscreenInfoLabel'
    WordWrap = True
  end
  object PixelShaderLabel: TLabel
    Left = 520
    Top = 352
    Width = 81
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'PixelShaderLabel'
    Visible = False
  end
  object ResolutionInfoLabel: TLabel
    Left = 24
    Top = 59
    Width = 600
    Height = 46
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'ResolutionInfoLabel'
    WordWrap = True
  end
  object GlideEmulationLabel: TLabel
    Left = 24
    Top = 240
    Width = 94
    Height = 13
    Caption = 'GlideEmulationLabel'
  end
  object GlideEmulationPortLabel: TLabel
    Left = 184
    Top = 240
    Width = 114
    Height = 13
    Caption = 'GlideEmulationPortLabel'
  end
  object GlideEmulationLFBLabel: TLabel
    Left = 363
    Top = 240
    Width = 111
    Height = 13
    Caption = 'GlideEmulationLFBLabel'
  end
  object WindowResolutionComboBox: TComboBox
    Left = 24
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object FullscreenResolutionComboBox: TComboBox
    Left = 184
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object StartFullscreenCheckBox: TCheckBox
    Left = 24
    Top = 120
    Width = 600
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'StartFullscreenCheckBox'
    TabOrder = 2
  end
  object DoublebufferingCheckBox: TCheckBox
    Left = 24
    Top = 176
    Width = 600
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DoublebufferingCheckBox'
    TabOrder = 3
  end
  object KeepAspectRatioCheckBox: TCheckBox
    Left = 24
    Top = 208
    Width = 600
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'KeepAspectRatioCheckBox'
    TabOrder = 4
  end
  object RenderComboBox: TComboBox
    Left = 24
    Top = 315
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
  end
  object VideoCardComboBox: TComboBox
    Left = 184
    Top = 315
    Width = 330
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
  end
  object ScaleComboBox: TComboBox
    Left = 24
    Top = 371
    Width = 385
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 10
  end
  object FrameSkipEdit: TSpinEdit
    Left = 422
    Top = 371
    Width = 92
    Height = 22
    Anchors = [akTop, akRight]
    MaxValue = 10
    MinValue = 0
    TabOrder = 11
    Value = 0
  end
  object TextModeLinesRadioGroup: TRadioGroup
    Left = 24
    Top = 405
    Width = 169
    Height = 76
    Caption = 'TextModeLinesRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      '25'
      '28'
      '50')
    TabOrder = 13
    Visible = False
  end
  object VGASettingsGroupBox: TGroupBox
    Left = 207
    Top = 405
    Width = 417
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'VGASettingsGroupBox'
    TabOrder = 14
    Visible = False
    DesignSize = (
      417
      105)
    object VGAChipsetLabel: TLabel
      Left = 16
      Top = 26
      Width = 81
      Height = 13
      Caption = 'VGAChipsetLabel'
    end
    object VideoRamLabel: TLabel
      Left = 167
      Top = 26
      Width = 72
      Height = 13
      Caption = 'VideoRamLabel'
    end
    object VGASettingsLabel: TLabel
      Left = 16
      Top = 68
      Width = 385
      Height = 34
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'This settings are only used if video card type is "vga".'
      WordWrap = True
    end
    object VGAChipsetComboBox: TComboBox
      Left = 16
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object VideoRamComboBox: TComboBox
      Left = 167
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object PixelShaderComboBox: TComboBox
    Left = 520
    Top = 371
    Width = 104
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 12
    Visible = False
    OnChange = PixelShaderComboBoxChange
  end
  object GlideEmulationComboBox: TComboBox
    Left = 24
    Top = 259
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object GlideEmulationPortComboBox: TComboBox
    Left = 184
    Top = 259
    Width = 105
    Height = 21
    ItemHeight = 13
    TabOrder = 6
  end
  object GlideEmulationLFBComboBox: TComboBox
    Left = 363
    Top = 259
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
end
