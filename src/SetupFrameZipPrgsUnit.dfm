object SetupFrameZipPrgs: TSetupFrameZipPrgs
  Left = 0
  Top = 0
  Width = 740
  Height = 402
  TabOrder = 0
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 740
    Height = 402
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 72
    ExplicitWidth = 449
    ExplicitHeight = 217
    DesignSize = (
      736
      398)
    object DeleteButton: TSpeedButton
      Tag = 1
      Left = 643
      Top = 27
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF33333333333330003333333333333777333333333333
        300033FFFFFF3333377739999993333333333777777F3333333F399999933333
        3300377777733333337733333333333333003333333333333377333333333333
        3333333333333333333F333333333333330033333F33333333773333C3333333
        330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
        993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
        333333377F33333333FF3333C333333330003333733333333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ButtonWork
      ExplicitLeft = 659
    end
    object UpButton: TSpeedButton
      Tag = 2
      Left = 672
      Top = 27
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
        3333333333777F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
        3333333777737777F333333099999990333333373F3333373333333309999903
        333333337F33337F33333333099999033333333373F333733333333330999033
        3333333337F337F3333333333099903333333333373F37333333333333090333
        33333333337F7F33333333333309033333333333337373333333333333303333
        333333333337F333333333333330333333333333333733333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ButtonWork
      ExplicitLeft = 688
    end
    object DownButton: TSpeedButton
      Tag = 3
      Left = 701
      Top = 27
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333337F33333333333333033333333333333373F333333333333090333
        33333333337F7F33333333333309033333333333337373F33333333330999033
        3333333337F337F33333333330999033333333333733373F3333333309999903
        333333337F33337F33333333099999033333333373333373F333333099999990
        33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333300033333333333337773333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ButtonWork
      ExplicitLeft = 717
    end
    object AddButton: TSpeedButton
      Left = 614
      Top = 27
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333FF33333333FF333993333333300033377F3333333777333993333333
        300033F77FFF3333377739999993333333333777777F3333333F399999933333
        33003777777333333377333993333333330033377F3333333377333993333333
        3333333773333333333F333333333333330033333333F33333773333333C3333
        330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
        993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
        333333333337733333FF3333333C333330003333333733333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ButtonWork
      ExplicitLeft = 630
    end
    object SelectLabel: TLabel
      Left = 16
      Top = 12
      Width = 133
      Height = 13
      Caption = 'Name of archiving program:'
    end
    object FilenameButton: TSpeedButton
      Left = 701
      Top = 76
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
      OnClick = FilenameButtonClick
      ExplicitLeft = 717
    end
    object InfoLabel: TLabel
      Left = 16
      Top = 311
      Width = 673
      Height = 49
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'If you define a archiving program for the extensions "zip" or "7' +
        'z" this external program will be used instead of the internal pa' +
        'cker.'
      WordWrap = True
      ExplicitWidth = 681
    end
    object SelectComboBox: TComboBox
      Left = 16
      Top = 27
      Width = 592
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 0
      OnChange = SelectComboBoxChange
    end
    object FilenameEdit: TLabeledEdit
      Left = 16
      Top = 76
      Width = 673
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 83
      EditLabel.Height = 13
      EditLabel.Caption = 'Program filename'
      TabOrder = 1
      OnChange = FilenameEditChange
      ExplicitWidth = 689
    end
    object ExtensionsEdit: TLabeledEdit
      Left = 16
      Top = 120
      Width = 673
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 230
      EditLabel.Height = 13
      EditLabel.Caption = 'File extensions to handle (list with ";" as divider)'
      TabOrder = 2
      ExplicitWidth = 689
    end
    object CommandExtractEdit: TLabeledEdit
      Left = 16
      Top = 164
      Width = 673
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 368
      EditLabel.Height = 13
      EditLabel.Caption = 
        'Commandline for extracting an archive file (%1=file, %2=destinat' +
        'ion folder)'
      TabOrder = 3
      ExplicitWidth = 689
    end
    object CommandCreateEdit: TLabeledEdit
      Left = 16
      Top = 204
      Width = 673
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 337
      EditLabel.Height = 13
      EditLabel.Caption = 
        'Commandline for creating an archive file (%1=file, %2=source fol' +
        'der)'
      TabOrder = 4
      ExplicitWidth = 689
    end
    object CommandAddEdit: TLabeledEdit
      Left = 16
      Top = 244
      Width = 673
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 404
      EditLabel.Height = 13
      EditLabel.Caption = 
        'Commandline for adding files / updating an archive file (%1=file' +
        ', %2=source folder)'
      TabOrder = 5
      ExplicitWidth = 689
    end
    object AutoSetupButton: TBitBtn
      Left = 16
      Top = 366
      Width = 209
      Height = 25
      Caption = 'Set default values for'
      TabOrder = 6
      Visible = False
      OnClick = AutoSetupButtonClick
    end
    object TrailingBackslashCheckBox: TCheckBox
      Left = 16
      Top = 280
      Width = 673
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Add trailing "\" to path names.'
      TabOrder = 7
      ExplicitWidth = 681
    end
  end
  object PrgOpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 168
    Top = 15
  end
end
