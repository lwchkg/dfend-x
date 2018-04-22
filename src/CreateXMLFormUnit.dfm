object CreateXMLForm: TCreateXMLForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Create xml file'
  ClientHeight = 523
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 16
    Top = 8
    Width = 45
    Height = 13
    Caption = 'InfoLabel'
  end
  object SelectFileButton: TSpeedButton
    Left = 386
    Top = 451
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
    OnClick = SelectFileButtonClick
  end
  object ListBox: TCheckListBox
    Left = 16
    Top = 27
    Width = 393
    Height = 272
    ItemHeight = 13
    TabOrder = 0
  end
  object FileEdit: TLabeledEdit
    Left = 16
    Top = 452
    Width = 364
    Height = 21
    EditLabel.Width = 34
    EditLabel.Height = 13
    EditLabel.Caption = 'FileEdit'
    TabOrder = 5
  end
  object SelectAllButton: TBitBtn
    Left = 16
    Top = 305
    Width = 107
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 1
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 129
    Top = 305
    Width = 107
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 489
    Width = 97
    Height = 25
    TabOrder = 6
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 119
    Top = 489
    Width = 97
    Height = 25
    TabOrder = 7
    Kind = bkCancel
  end
  object SelectGenreButton: TBitBtn
    Tag = 2
    Left = 242
    Top = 305
    Width = 107
    Height = 25
    Caption = 'By ...'
    TabOrder = 3
    OnClick = SelectButtonClick
  end
  object FileTypeRadioGroup: TRadioGroup
    Left = 16
    Top = 352
    Width = 393
    Height = 65
    Caption = 'File type'
    ItemIndex = 0
    Items.Strings = (
      'DBGL style'
      'D.O.G. style')
    TabOrder = 4
  end
  object PopupMenu: TPopupMenu
    Left = 232
    Top = 488
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML files (*.xml)|*.xml|All files (*.*)|*.*'
    Title = 'Save profiles to xml file'
    Left = 264
    Top = 488
  end
end
