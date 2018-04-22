object WizardScummVMSettingsFrame: TWizardScummVMSettingsFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 511
  TabOrder = 0
  DesignSize = (
    592
    511)
  object LanguageLabel: TLabel
    Left = 20
    Top = 100
    Width = 72
    Height = 13
    Caption = 'LanguageLabel'
  end
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 543
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bitte geben Sie an, auf welcher Vorlage das neue Profil angelegt' +
      ' werden soll.'
    WordWrap = True
  end
  object Bevel: TBevel
    Left = 3
    Top = 71
    Width = 589
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object LanguageInfoLabel: TLabel
    Left = 20
    Top = 299
    Width = 552
    Height = 137
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'LanguageInfoLabel'
    WordWrap = True
  end
  object LanguageComboBox: TComboBox
    Left = 19
    Top = 119
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = LanguageComboBoxChange
  end
  object StartFullscreenCheckBox: TCheckBox
    Left = 20
    Top = 159
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'StartFullscreenCheckBox'
    TabOrder = 1
  end
  object SavePathGroupBox: TGroupBox
    Left = 19
    Top = 199
    Width = 561
    Height = 86
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Folder for saved games'
    TabOrder = 2
    DesignSize = (
      561
      86)
    object SavePathEditButton: TSpeedButton
      Left = 535
      Top = 55
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SavePathEditButtonClick
    end
    object SavePathDefaultRadioButton: TRadioButton
      Left = 16
      Top = 18
      Width = 529
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use game folder (default)'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object SavePathCustomRadioButton: TRadioButton
      Left = 16
      Top = 39
      Width = 529
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use this custom folder'
      TabOrder = 1
    end
    object SavePathEdit: TEdit
      Left = 32
      Top = 56
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnChange = SavePathEditChange
    end
  end
  object CustomLanguageEdit: TEdit
    Left = 130
    Top = 119
    Width = 50
    Height = 21
    TabOrder = 3
    Visible = False
  end
end
