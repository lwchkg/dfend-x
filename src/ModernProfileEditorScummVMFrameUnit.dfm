object ModernProfileEditorScummVMFrame: TModernProfileEditorScummVMFrame
  Left = 0
  Top = 0
  Width = 602
  Height = 512
  TabOrder = 0
  DesignSize = (
    602
    512)
  object LanguageLabel: TLabel
    Left = 24
    Top = 13
    Width = 72
    Height = 13
    Caption = 'LanguageLabel'
  end
  object AutosaveLabel: TLabel
    Left = 24
    Top = 60
    Width = 71
    Height = 13
    Caption = 'AutosaveLabel'
  end
  object TalkSpeedLabel: TLabel
    Left = 24
    Top = 100
    Width = 74
    Height = 13
    Caption = 'TalkSpeedLabel'
  end
  object CustomSetsLabel: TLabel
    Left = 24
    Top = 410
    Width = 82
    Height = 13
    Caption = 'CustomSetsLabel'
  end
  object ExtraDirButton: TSpeedButton
    Left = 559
    Top = 329
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
    OnClick = ExtraDirButtonClick
  end
  object LanguageComboBox: TComboBox
    Left = 24
    Top = 30
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
    OnChange = LanguageComboBoxChange
  end
  object SubtitlesCheckBox: TCheckBox
    Left = 24
    Top = 144
    Width = 561
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SubtitlesCheckBox'
    TabOrder = 4
  end
  object AutosaveEdit: TSpinEdit
    Left = 24
    Top = 74
    Width = 105
    Height = 22
    MaxValue = 86400
    MinValue = 1
    TabOrder = 2
    Value = 300
  end
  object TalkSpeedEdit: TSpinEdit
    Left = 24
    Top = 114
    Width = 105
    Height = 22
    MaxValue = 1000
    MinValue = 1
    TabOrder = 3
    Value = 60
  end
  object SavePathGroupBox: TGroupBox
    Left = 24
    Top = 216
    Width = 561
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Folder for saved games'
    TabOrder = 7
    DesignSize = (
      561
      81)
    object SavePathEditButton: TSpeedButton
      Left = 535
      Top = 54
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
      Top = 17
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
      Top = 36
      Width = 529
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use this custom folder'
      TabOrder = 1
    end
    object SavePathEdit: TEdit
      Left = 32
      Top = 54
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnChange = SavePathEditChange
    end
  end
  object ConfirmExitCheckBox: TCheckBox
    Left = 24
    Top = 163
    Width = 561
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Confirm program exit'
    TabOrder = 5
  end
  object CustomSetsMemo: TRichEdit
    Left = 24
    Top = 424
    Width = 558
    Height = 51
    Anchors = [akLeft, akTop, akRight, akBottom]
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 11
    WordWrap = False
  end
  object CustomSetsClearButton: TBitBtn
    Left = 26
    Top = 481
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    TabOrder = 12
    OnClick = ButtonWork
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
      555557777F777555F55500000000555055557777777755F75555005500055055
      555577F5777F57555555005550055555555577FF577F5FF55555500550050055
      5555577FF77577FF555555005050110555555577F757777FF555555505099910
      555555FF75777777FF555005550999910555577F5F77777775F5500505509990
      3055577F75F77777575F55005055090B030555775755777575755555555550B0
      B03055555F555757575755550555550B0B335555755555757555555555555550
      BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
      50BB555555555555575F555555555555550B5555555555555575}
    NumGlyphs = 2
  end
  object CustomSetsLoadButton: TBitBtn
    Tag = 1
    Left = 137
    Top = 481
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Laden...'
    TabOrder = 13
    OnClick = ButtonWork
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
  end
  object CustomSetsSaveButton: TBitBtn
    Tag = 2
    Left = 248
    Top = 481
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern...'
    TabOrder = 14
    OnClick = ButtonWork
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
      7700333333337777777733333333008088003333333377F73377333333330088
      88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
      000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
      FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
      99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
      99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
      99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
      93337FFFF7737777733300000033333333337777773333333333}
    NumGlyphs = 2
  end
  object ExtraDirCheckBox: TCheckBox
    Left = 24
    Top = 312
    Width = 561
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use extra directory'
    TabOrder = 8
  end
  object ExtraDirEdit: TEdit
    Left = 24
    Top = 330
    Width = 529
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 9
    OnChange = ExtraDirEditChange
  end
  object CustomLanguageEdit: TEdit
    Left = 135
    Top = 30
    Width = 50
    Height = 21
    TabOrder = 1
    Visible = False
  end
  object CommandLineEdit: TLabeledEdit
    Left = 24
    Top = 376
    Width = 527
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 84
    EditLabel.Height = 13
    EditLabel.Caption = 'CommandLineEdit'
    TabOrder = 10
  end
  object RunAsAdminCheckBox: TCheckBox
    Left = 24
    Top = 182
    Width = 559
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'RunAsAdminCheckBox'
    TabOrder = 6
  end
  object OpenDialog: TOpenDialog
    Left = 355
    Top = 450
  end
  object SaveDialog: TSaveDialog
    Left = 387
    Top = 450
  end
end
