object ProfileMountEditorDriveFrame: TProfileMountEditorDriveFrame
  Left = 0
  Top = 0
  Width = 697
  Height = 417
  TabOrder = 0
  DesignSize = (
    697
    417)
  object FolderButton: TSpeedButton
    Left = 671
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
    OnClick = FolderButtonClick
  end
  object FolderDriveLetterLabel: TLabel
    Left = 16
    Top = 77
    Width = 98
    Height = 13
    Caption = 'Mounted drive letter'
  end
  object FolderDriveLetterWarningLabel: TLabel
    Left = 176
    Top = 99
    Width = 513
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'FolderDriveLetterWarningLabel'
    Visible = False
    WordWrap = True
    ExplicitWidth = 510
  end
  object FolderFreeSpaceLabel: TLabel
    Left = 16
    Top = 144
    Width = 166
    Height = 13
    Caption = 'Free virtual Harddisk-Space (x MB)'
  end
  object FolderEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 649
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 223
    EditLabel.Height = 13
    EditLabel.Caption = 'Select drive/CDROM/Image or floppy to mount'
    TabOrder = 0
  end
  object FolderDriveLetterComboBox: TComboBox
    Left = 16
    Top = 96
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = FolderDriveLetterComboBoxChange
  end
  object FolderFreeSpaceTrackBar: TTrackBar
    Left = 16
    Top = 162
    Width = 636
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    Max = 4000
    Min = 10
    PageSize = 10
    Frequency = 100
    Position = 10
    TabOrder = 2
    OnChange = FolderFreeSpaceTrackBarChange
  end
  object MakeZipDriveButton: TBitBtn
    Left = 16
    Top = 242
    Width = 337
    Height = 25
    Hint = 
      'This function compress the game directory to an archive file and' +
      ' will mount this file instead of the chosen folderwill extract t' +
      'he archive file and convert the mount into a normal directory mo' +
      'unt'
    Caption = 'Make archive file drive from this mount'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = MakeZipDriveButtonClick
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
  object SaveDialog: TSaveDialog
    DefaultExt = 'zip'
    Left = 368
    Top = 240
  end
end
