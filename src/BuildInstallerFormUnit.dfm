object BuildInstallerForm: TBuildInstallerForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Installer-Paket erstellen'
  ClientHeight = 578
  ClientWidth = 408
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 409
    Height = 577
    ActivePage = GamesSheet
    TabOrder = 0
    object GamesSheet: TTabSheet
      Caption = 'GamesSheet'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object InfoLabel: TLabel
        Left = 8
        Top = 8
        Width = 376
        Height = 13
        Caption = 
          'Bitte w'#228'hlen Sie die Programme, die in das Paket aufgenommen wer' +
          'den sollen:'
      end
      object DestFileButton: TSpeedButton
        Left = 362
        Top = 478
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
        OnClick = DestFileButtonClick
      end
      object ListBox: TCheckListBox
        Left = 8
        Top = 27
        Width = 377
        Height = 270
        ItemHeight = 13
        TabOrder = 0
      end
      object SelectAllButton: TBitBtn
        Left = 8
        Top = 303
        Width = 107
        Height = 25
        Caption = 'SelectAllButton'
        TabOrder = 1
        OnClick = SelectButtonClick
      end
      object SelectNoneButton: TBitBtn
        Tag = 1
        Left = 121
        Top = 303
        Width = 107
        Height = 25
        Caption = 'SelectNoneButton'
        TabOrder = 2
        OnClick = SelectButtonClick
      end
      object DestFileEdit: TLabeledEdit
        Left = 8
        Top = 478
        Width = 348
        Height = 21
        EditLabel.Width = 112
        EditLabel.Height = 13
        EditLabel.Caption = 'Dateiname des Paketes'
        TabOrder = 3
      end
      object OKButton: TBitBtn
        Left = 8
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 4
        OnClick = OKButtonClick
        Kind = bkOK
      end
      object CancelButton: TBitBtn
        Left = 120
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 5
        Kind = bkCancel
      end
      object InstTypeRadioGroup: TRadioGroup
        Left = 8
        Top = 376
        Width = 348
        Height = 73
        Caption = 'Paket-Erstellung'
        ItemIndex = 1
        Items.Strings = (
          'Nur NSI-Skript erstellen'
          'Skript erstellen und mit NSIS compilieren')
        TabOrder = 6
      end
      object GroupGamesCheckBox: TCheckBox
        Left = 8
        Top = 344
        Width = 376
        Height = 17
        Caption = 'Spiele im Installer nach Generes gruppieren'
        TabOrder = 7
      end
      object SelectGenreButton: TBitBtn
        Tag = 2
        Left = 234
        Top = 303
        Width = 107
        Height = 25
        Caption = 'By ...'
        TabOrder = 8
        OnClick = SelectButtonClick
      end
      object HelpButton: TBitBtn
        Left = 234
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 9
        OnClick = HelpButtonClick
        Kind = bkHelp
      end
    end
    object TemplatesSheet: TTabSheet
      Caption = 'TemplatesSheet'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object InfoLabel3: TLabel
        Left = 8
        Top = 8
        Width = 376
        Height = 13
        Caption = 
          'Bitte w'#228'hlen Sie die Programme, die in das Paket aufgenommen wer' +
          'den sollen:'
      end
      object DestFileButton3: TSpeedButton
        Left = 362
        Top = 478
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
        OnClick = DestFileButton3Click
      end
      object ListBox3: TCheckListBox
        Left = 8
        Top = 27
        Width = 377
        Height = 270
        ItemHeight = 13
        TabOrder = 0
      end
      object SelectAllButton3: TBitBtn
        Left = 8
        Top = 303
        Width = 107
        Height = 25
        Caption = 'SelectAllButton'
        TabOrder = 1
        OnClick = SelectButtonClick3
      end
      object SelectNoneButton3: TBitBtn
        Tag = 1
        Left = 121
        Top = 303
        Width = 107
        Height = 25
        Caption = 'SelectNoneButton'
        TabOrder = 2
        OnClick = SelectButtonClick3
      end
      object SelectGenreButton3: TBitBtn
        Tag = 2
        Left = 234
        Top = 303
        Width = 107
        Height = 25
        Caption = 'By ...'
        TabOrder = 3
        OnClick = SelectButtonClick3
      end
      object GroupGamesCheckBox3: TCheckBox
        Left = 8
        Top = 344
        Width = 376
        Height = 17
        Caption = 'Spiele im Installer nach Generes gruppieren'
        TabOrder = 4
      end
      object InstTypeRadioGroup3: TRadioGroup
        Left = 8
        Top = 376
        Width = 348
        Height = 73
        Caption = 'Paket-Erstellung'
        ItemIndex = 1
        Items.Strings = (
          'Nur NSI-Skript erstellen'
          'Skript erstellen und mit NSIS compilieren')
        TabOrder = 5
      end
      object DestFileEdit3: TLabeledEdit
        Left = 8
        Top = 478
        Width = 348
        Height = 21
        EditLabel.Width = 112
        EditLabel.Height = 13
        EditLabel.Caption = 'Dateiname des Paketes'
        TabOrder = 6
      end
      object OKButton3: TBitBtn
        Left = 8
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 7
        OnClick = OKButton3Click
        Kind = bkOK
      end
      object CancelButton3: TBitBtn
        Left = 120
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 8
        Kind = bkCancel
      end
      object HelpButton3: TBitBtn
        Left = 234
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 9
        OnClick = HelpButtonClick
        Kind = bkHelp
      end
    end
    object AutoSetupSheet: TTabSheet
      Caption = 'AutoSetupSheet'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object InfoLabel2: TLabel
        Left = 8
        Top = 8
        Width = 376
        Height = 13
        Caption = 
          'Bitte w'#228'hlen Sie die Programme, die in das Paket aufgenommen wer' +
          'den sollen:'
      end
      object DestFileButton2: TSpeedButton
        Left = 362
        Top = 478
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
        OnClick = DestFileButton2Click
      end
      object OKButton2: TBitBtn
        Left = 8
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 0
        OnClick = OKButton2Click
        Kind = bkOK
      end
      object CancelButton2: TBitBtn
        Left = 120
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
      object ListBox2: TCheckListBox
        Left = 8
        Top = 27
        Width = 377
        Height = 270
        ItemHeight = 13
        TabOrder = 2
      end
      object SelectAllButton2: TBitBtn
        Left = 8
        Top = 303
        Width = 107
        Height = 25
        Caption = 'SelectAllButton'
        TabOrder = 3
        OnClick = SelectButtonClick2
      end
      object SelectNoneButton2: TBitBtn
        Tag = 1
        Left = 121
        Top = 303
        Width = 107
        Height = 25
        Caption = 'SelectNoneButton'
        TabOrder = 4
        OnClick = SelectButtonClick2
      end
      object SelectGenreButton2: TBitBtn
        Tag = 2
        Left = 234
        Top = 303
        Width = 107
        Height = 25
        Caption = 'By ...'
        TabOrder = 5
        OnClick = SelectButtonClick2
      end
      object GroupGamesCheckBox2: TCheckBox
        Left = 8
        Top = 344
        Width = 376
        Height = 17
        Caption = 'Spiele im Installer nach Generes gruppieren'
        TabOrder = 6
      end
      object InstTypeRadioGroup2: TRadioGroup
        Left = 8
        Top = 376
        Width = 348
        Height = 73
        Caption = 'Paket-Erstellung'
        ItemIndex = 1
        Items.Strings = (
          'Nur NSI-Skript erstellen'
          'Skript erstellen und mit NSIS compilieren')
        TabOrder = 7
      end
      object DestFileEdit2: TLabeledEdit
        Left = 8
        Top = 478
        Width = 348
        Height = 21
        EditLabel.Width = 112
        EditLabel.Height = 13
        EditLabel.Caption = 'Dateiname des Paketes'
        TabOrder = 8
      end
      object HelpButton2: TBitBtn
        Left = 234
        Top = 516
        Width = 97
        Height = 25
        TabOrder = 9
        OnClick = HelpButtonClick
        Kind = bkHelp
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'exe'
    Left = 256
    Top = 504
  end
  object PopupMenu: TPopupMenu
    Left = 224
    Top = 504
  end
  object PopupMenu2: TPopupMenu
    Left = 296
    Top = 504
  end
  object PopupMenu3: TPopupMenu
    Left = 336
    Top = 504
  end
end
