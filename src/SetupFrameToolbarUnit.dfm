object SetupFrameToolbar: TSetupFrameToolbar
  Left = 0
  Top = 0
  Width = 685
  Height = 505
  TabOrder = 0
  DesignSize = (
    685
    505)
  object AddButtonFunctionLabel: TLabel
    Left = 193
    Top = 113
    Width = 183
    Height = 13
    Caption = 'Funktion der Hinzuf'#252'gen-Schaltfl'#228'che:'
  end
  object ToolbarImageButton: TSpeedButton
    Tag = 9
    Left = 650
    Top = 222
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
      0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
      B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
      FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
      FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
      FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
      0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
      0555555555777777755555555555555555555555555555555555}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ToolbarImageButtonClick
  end
  object ToolbarFontSizeLabel: TLabel
    Left = 15
    Top = 261
    Width = 59
    Height = 13
    Caption = 'Schriftgr'#246#223'e'
  end
  object ButtonsLabel: TLabel
    Left = 16
    Top = 47
    Width = 92
    Height = 13
    Caption = 'Sichtbare Symbole:'
  end
  object AddButtonFunctionComboBox: TComboBox
    Left = 193
    Top = 132
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 3
    Text = 'Auswahlmen'#252
    Items.Strings = (
      'Hinzuf'#252'gen-Dialog'
      'Assistent'
      'Auswahlmen'#252)
  end
  object ShowToolbarCheckBox: TCheckBox
    Left = 16
    Top = 16
    Width = 657
    Height = 17
    Caption = 'Symbolleiste anzeigen'
    TabOrder = 0
  end
  object ShowToolbarCaptionsCheckBox: TCheckBox
    Left = 193
    Top = 74
    Width = 480
    Height = 17
    Caption = 'Beschriftungen der Symbolleiste anzeigen'
    TabOrder = 2
  end
  object ToolbarImageEdit: TEdit
    Left = 152
    Top = 223
    Width = 492
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = ToolbarImageEditChange
  end
  object ToolbarImageCheckBox: TCheckBox
    Left = 16
    Top = 227
    Width = 130
    Height = 17
    Caption = 'Hintergrundbild'
    TabOrder = 5
  end
  object ToolbarFontSizeEdit: TSpinEdit
    Left = 15
    Top = 280
    Width = 59
    Height = 22
    MaxValue = 48
    MinValue = 1
    TabOrder = 6
    Value = 9
  end
  object ButtonsListBox: TCheckListBox
    Left = 16
    Top = 66
    Width = 161
    Height = 135
    ItemHeight = 13
    TabOrder = 1
  end
  object ImageOpenDialog: TOpenDialog
    DefaultExt = 'jpeg'
    Left = 480
    Top = 134
  end
end
