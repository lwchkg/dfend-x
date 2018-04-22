object ProfileMountEditorHDImageFrame: TProfileMountEditorHDImageFrame
  Left = 0
  Top = 0
  Width = 697
  Height = 429
  TabOrder = 0
  DesignSize = (
    697
    429)
  object ImageButton: TSpeedButton
    Tag = 5
    Left = 640
    Top = 32
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
    OnClick = ImageButtonClick
  end
  object ImageCreateButton: TSpeedButton
    Tag = 7
    Left = 671
    Top = 32
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
      0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
      33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ImageCreateButtonClick
  end
  object ImageDriveLetterLabel: TLabel
    Left = 16
    Top = 115
    Width = 98
    Height = 13
    Caption = 'Mounted drive letter'
  end
  object DriveLetterInfoLabel2: TLabel
    Left = 18
    Top = 155
    Width = 676
    Height = 63
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'DriveLetterInfoLabel2'
    WordWrap = True
  end
  object HDImageDriveLetterWarningLabel: TLabel
    Left = 176
    Top = 131
    Width = 510
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'HDImageDriveLetterWarningLabel'
    Visible = False
    WordWrap = True
  end
  object ImageEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 609
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 223
    EditLabel.Height = 13
    EditLabel.Caption = 'Select drive/CDROM/Image or floppy to mount'
    TabOrder = 0
  end
  object ImageGeometryEdit: TLabeledEdit
    Left = 16
    Top = 82
    Width = 609
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 282
    EditLabel.Height = 13
    EditLabel.Caption = 'Drive geometry (Sectorsize, Cylinders, Heads and Sectors)'
    TabOrder = 1
  end
  object ImageDriveLetterComboBox: TComboBox
    Left = 16
    Top = 128
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = ImageDriveLetterComboBoxChange
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'iso'
    Left = 336
    Top = 102
  end
end
