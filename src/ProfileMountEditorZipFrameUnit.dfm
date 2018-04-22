object ProfileMountEditorZipFrame: TProfileMountEditorZipFrame
  Left = 0
  Top = 0
  Width = 697
  Height = 340
  TabOrder = 0
  DesignSize = (
    697
    340)
  object ZipFolderButton: TSpeedButton
    Tag = 13
    Left = 642
    Top = 32
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
    OnClick = ZipFolderButtonClick
  end
  object ZipFolderDriveLetterLabel: TLabel
    Left = 16
    Top = 69
    Width = 98
    Height = 13
    Caption = 'Mounted drive letter'
  end
  object ZipFolderFreeSpaceLabel: TLabel
    Left = 184
    Top = 69
    Width = 166
    Height = 13
    Caption = 'Free virtual Harddisk-Space (x MB)'
  end
  object ZipFolderDriveLetterWarningLabel: TLabel
    Left = 16
    Top = 127
    Width = 670
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'ZipFolderDriveLetterWarningLabel'
    Visible = False
    WordWrap = True
  end
  object ZipFileButton: TSpeedButton
    Tag = 14
    Left = 671
    Top = 184
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
    OnClick = ZipFileButtonClick
  end
  object RepackTypeLabel: TLabel
    Left = 16
    Top = 224
    Width = 191
    Height = 13
    Caption = 'After repacking folder content to zip file'
  end
  object InfoLabel: TLabel
    Left = 392
    Top = 224
    Width = 302
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object ZipFolderCreateButton: TSpeedButton
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
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ZipFolderCreateButtonClick
  end
  object ZipFolderEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 617
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 223
    EditLabel.Height = 13
    EditLabel.Caption = 'Select drive/CDROM/Image or floppy to mount'
    TabOrder = 0
  end
  object ZipFolderDriveLetterComboBox: TComboBox
    Left = 16
    Top = 88
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ZipFolderDriveLetterComboBoxChange
  end
  object ZipFolderFreeSpaceTrackbar: TTrackBar
    Left = 176
    Top = 88
    Width = 481
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    Max = 4000
    Min = 10
    PageSize = 10
    Frequency = 100
    Position = 10
    TabOrder = 2
    OnChange = ZipFolderFreeSpaceTrackbarChange
  end
  object ZipFileEdit: TLabeledEdit
    Left = 16
    Top = 184
    Width = 649
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 108
    EditLabel.Height = 13
    EditLabel.Caption = 'Select zip file to mount'
    TabOrder = 3
  end
  object RepackTypeComboBox: TComboBox
    Left = 16
    Top = 240
    Width = 361
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = 'Repack but keep folder content'
    OnChange = RepackTypeComboBoxChange
    OnDropDown = RepackTypeComboBoxDropDown
    Items.Strings = (
      'Repack but keep folder content'
      'Repack then delete files in folder'
      'Repack then delete files in folder and folder'
      'Do not repack, keep folder content'
      'Do not repack, delete files in folder'
      'Do not repack, delete files in folder and folder')
  end
  object MakeNormalDriveButton: TBitBtn
    Left = 16
    Top = 274
    Width = 297
    Height = 25
    Hint = 
      'This function will extract the archive file and convert the moun' +
      't into a normal directory mount'
    Caption = 'Make normal drive from this mount'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = MakeNormalDriveButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      33333FFFFFFFFFFFFFFF000000000000000077777777777777770F7777777777
      77707F3F3333333333370F988888888888707F733FFFFFFFF3370F8800000000
      88707F337777777733370F888888888888707F333FFFFFFFF3370F8800000000
      88707F337777777733370F888888888888707F333333333333370F8888888888
      88707F333333333333370FFFFFFFFFFFFFF07FFFFFFFFFFFFFF7000000000000
      0000777777777777777733333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'iso'
    Left = 224
    Top = 150
  end
  object PopupMenu: TPopupMenu
    Left = 320
    Top = 272
    object PopupExtractHere: TMenuItem
      Caption = 'Extract files to selected folder'
      OnClick = MakeNormalDriveButtonClick
    end
    object PopupExtractInGamesFolder: TMenuItem
      Tag = 1
      Caption = 'Extract files to subdirectory of the games folder'
      OnClick = MakeNormalDriveButtonClick
    end
  end
end
