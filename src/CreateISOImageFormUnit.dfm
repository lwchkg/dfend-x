object CreateISOImageForm: TCreateISOImageForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ISO-Image von CD erstellen'
  ClientHeight = 206
  ClientWidth = 502
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
  OnShow = FormShow
  DesignSize = (
    502
    206)
  PixelsPerInch = 96
  TextHeight = 13
  object DriveLabel: TLabel
    Left = 8
    Top = 22
    Width = 61
    Height = 13
    Caption = 'CD Laufwerk'
  end
  object FileNameButton: TSpeedButton
    Left = 471
    Top = 88
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
    OnClick = FileNameButtonClick
  end
  object InfoLabel: TLabel
    Left = 8
    Top = 120
    Width = 486
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object DriveComboBox: TComboBox
    Left = 8
    Top = 38
    Width = 77
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 3
  end
  object FileNameEdit: TLabeledEdit
    Left = 8
    Top = 88
    Width = 457
    Height = 21
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = 'ISO-Datei'
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 173
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 173
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 173
    Width = 97
    Height = 25
    TabOrder = 4
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'iso'
    Title = 'ISO-Image speichern'
    Left = 240
    Top = 137
  end
end
