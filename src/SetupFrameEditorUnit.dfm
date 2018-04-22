object SetupFrameEditor: TSetupFrameEditor
  Left = 0
  Top = 0
  Width = 597
  Height = 458
  TabOrder = 0
  DesignSize = (
    597
    458)
  object CustomButton: TSpeedButton
    Left = 562
    Top = 135
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
    OnClick = CustomButtonClick
  end
  object RadioButtonDefault: TRadioButton
    Left = 8
    Top = 24
    Width = 578
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use default editor for file type'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = RadioButtonClick
  end
  object FallbackCheckBox: TCheckBox
    Left = 23
    Top = 47
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'If no default editor is registered for given file type use defau' +
      'lt editor for txt files'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object RadioButtonNotepad: TRadioButton
    Left = 8
    Top = 80
    Width = 578
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Always use Notepad'
    TabOrder = 2
    OnClick = RadioButtonClick
  end
  object RadioButtonCustom: TRadioButton
    Left = 8
    Top = 112
    Width = 578
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use custom editor'
    TabOrder = 3
    OnClick = RadioButtonClick
  end
  object CustomEdit: TEdit
    Left = 23
    Top = 135
    Width = 533
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = CustomEditChange
  end
  object FixLineWrapCheckBox: TCheckBox
    Left = 8
    Top = 200
    Width = 578
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Automatically fix line wrap on opening files if needed'
    TabOrder = 5
  end
  object PrgOpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 224
    Top = 7
  end
end
