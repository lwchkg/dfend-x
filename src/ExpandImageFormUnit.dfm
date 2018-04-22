object ExpandImageForm: TExpandImageForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ExpandImageForm'
  ClientHeight = 305
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object FileNameButton: TSpeedButton
    Left = 463
    Top = 24
    Width = 23
    Height = 22
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
    OnClick = ButtonWork
  end
  object FolderButton: TSpeedButton
    Tag = 1
    Left = 463
    Top = 80
    Width = 23
    Height = 22
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
    OnClick = ButtonWork
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 273
    Width = 97
    Height = 25
    TabOrder = 4
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 273
    Width = 97
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object FileNameEdit: TLabeledEdit
    Left = 8
    Top = 24
    Width = 449
    Height = 21
    EditLabel.Width = 54
    EditLabel.Height = 13
    EditLabel.Caption = 'Imagedatei'
    TabOrder = 0
  end
  object FolderEdit: TLabeledEdit
    Left = 8
    Top = 80
    Width = 449
    Height = 21
    EditLabel.Width = 69
    EditLabel.Height = 13
    EditLabel.Caption = 'Zielverzeichnis'
    TabOrder = 1
  end
  object OpenFolderCheckBox: TCheckBox
    Left = 8
    Top = 236
    Width = 478
    Height = 17
    Caption = 'Zielverzeichnis nach entpacken anzeigen'
    TabOrder = 3
  end
  object ImageTypeRadioGroup: TRadioGroup
    Left = 8
    Top = 120
    Width = 185
    Height = 97
    Caption = 'Image-Typ'
    Items.Strings = (
      'Disketten-Image'
      'Festplatten-Image'
      'ISO-Image')
    TabOrder = 2
  end
  object HelpButton: TBitBtn
    Left = 231
    Top = 273
    Width = 97
    Height = 25
    TabOrder = 6
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'img'
    Left = 256
    Top = 236
  end
end
