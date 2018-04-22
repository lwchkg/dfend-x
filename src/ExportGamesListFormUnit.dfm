object ExportGamesListForm: TExportGamesListForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Export games list'
  ClientHeight = 475
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    354
    475)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxLabel: TLabel
    Left = 16
    Top = 8
    Width = 88
    Height = 13
    Caption = 'Columns to export'
  end
  object SelectFileButton: TSpeedButton
    Left = 314
    Top = 289
    Width = 23
    Height = 22
    Anchors = [akLeft, akTop, akRight]
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
    OnClick = SelectFileButtonClick
  end
  object InfoLabel: TLabel
    Left = 16
    Top = 372
    Width = 312
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If "Auto select" is chosen as export format the games list will ' +
      'be exported as text file, table, html page or xml file depending' +
      ' on the file extension ("txt", "csv", "html" or "xml").'
    WordWrap = True
  end
  object ExportFormatLabel: TLabel
    Left = 16
    Top = 320
    Width = 91
    Height = 13
    Caption = 'ExportFormatLabel'
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 443
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 128
    Top = 443
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 240
    Top = 443
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 7
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object FileNameEdit: TLabeledEdit
    Left = 16
    Top = 290
    Width = 292
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'FileNameEdit'
    TabOrder = 3
    OnChange = FileNameEditChange
  end
  object ListBox: TCheckListBox
    Left = 16
    Top = 27
    Width = 321
    Height = 194
    OnClickCheck = ListBoxClickCheck
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 129
    Top = 227
    Width = 107
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object SelectAllButton: TBitBtn
    Left = 16
    Top = 227
    Width = 107
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 1
    OnClick = SelectButtonClick
  end
  object ExportFormatComboBox: TComboBox
    Left = 16
    Top = 336
    Width = 321
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = ExportFormatComboBoxChange
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Left = 312
    Top = 8
  end
end
