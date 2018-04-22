object ModernProfileEditorDOSBoxFrame: TModernProfileEditorDOSBoxFrame
  Left = 0
  Top = 0
  Width = 641
  Height = 530
  TabOrder = 0
  DesignSize = (
    641
    530)
  object CustomDOSBoxInstallationButton: TSpeedButton
    Left = 605
    Top = 205
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
    OnClick = CustomDOSBoxInstallationButtonClick
  end
  object CustomSetsLabel: TLabel
    Left = 16
    Top = 320
    Width = 82
    Height = 13
    Caption = 'CustomSetsLabel'
  end
  object DOSBoxForegroundPriorityLabel: TLabel
    Left = 16
    Top = 16
    Width = 154
    Height = 13
    Caption = 'DOSBoxForegroundPriorityLabel'
  end
  object DOSBoxBackgroundPriorityLabel: TLabel
    Left = 240
    Top = 16
    Width = 154
    Height = 13
    Caption = 'DOSBoxBackgroundPriorityLabel'
  end
  object CloseDOSBoxOnExitCheckBox: TCheckBox
    Left = 16
    Top = 80
    Width = 612
    Height = 15
    Anchors = [akLeft, akTop, akRight]
    Caption = 'CloseDOSBoxOnExitCheckBox'
    TabOrder = 2
  end
  object DefaultDOSBoxInstallationRadioButton: TRadioButton
    Left = 16
    Top = 137
    Width = 612
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DefaultDOSBoxInstallationRadioButton'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnClick = DOSBoxInstallationTypeClick
  end
  object CustomDOSBoxInstallationRadioButton: TRadioButton
    Left = 16
    Top = 187
    Width = 612
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'CustomDOSBoxInstallationRadioButton'
    TabOrder = 6
    OnClick = DOSBoxInstallationTypeClick
  end
  object CustomDOSBoxInstallationEdit: TEdit
    Left = 32
    Top = 206
    Width = 567
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
    OnChange = CustomDOSBoxInstallationEditChange
  end
  object CustomSetsClearButton: TBitBtn
    Left = 16
    Top = 494
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    TabOrder = 13
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
    Left = 129
    Top = 494
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Laden...'
    TabOrder = 14
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
    Left = 240
    Top = 494
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern...'
    TabOrder = 15
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
  object CustomSetsMemo: TRichEdit
    Left = 16
    Top = 336
    Width = 612
    Height = 152
    Anchors = [akLeft, akTop, akRight, akBottom]
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 12
    WordWrap = False
  end
  object DOSBoxInstallationComboBox: TComboBox
    Left = 32
    Top = 156
    Width = 596
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 5
    OnChange = DOSBoxInstallationComboBoxChange
  end
  object UserLanguageCheckBox: TCheckBox
    Left = 16
    Top = 256
    Width = 411
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use this custom language in DOSBox'
    TabOrder = 8
    OnClick = UserLanguageCheckBoxClick
  end
  object UserLanguageComboBox: TComboBox
    Left = 483
    Top = 254
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 0
    TabOrder = 9
  end
  object DOSBoxForegroundPriorityComboBox: TComboBox
    Left = 16
    Top = 35
    Width = 185
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
  end
  object DOSBoxBackgroundPriorityComboBox: TComboBox
    Left = 240
    Top = 35
    Width = 185
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 1
  end
  object UserConsoleCheckBox: TCheckBox
    Left = 16
    Top = 288
    Width = 417
    Height = 17
    Caption = 'Use this custom settings for the console window'
    TabOrder = 10
    OnClick = UserConsoleCheckBoxClick
  end
  object UserConsoleComboBox: TComboBox
    Left = 483
    Top = 286
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 0
    TabOrder = 11
  end
  object RunAsAdminCheckBox: TCheckBox
    Left = 16
    Top = 105
    Width = 612
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'RunAsAdminCheckBox'
    TabOrder = 3
  end
  object OpenDialog: TOpenDialog
    Left = 291
    Top = 322
  end
  object SaveDialog: TSaveDialog
    Left = 323
    Top = 322
  end
end
