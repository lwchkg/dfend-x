object ModernProfileEditorBaseFrame: TModernProfileEditorBaseFrame
  Left = 0
  Top = 0
  Width = 598
  Height = 686
  TabOrder = 0
  DesignSize = (
    598
    686)
  object IconPanel: TPanel
    Left = 20
    Top = 11
    Width = 35
    Height = 35
    TabOrder = 0
    object IconImage: TImage
      Left = 1
      Top = 1
      Width = 33
      Height = 33
      Align = alClient
      ExplicitLeft = 9
      ExplicitTop = 0
    end
  end
  object IconSelectButton: TBitBtn
    Left = 80
    Top = 17
    Width = 153
    Height = 25
    Caption = 'Icon ausw'#228'hlen...'
    TabOrder = 1
    OnClick = IconButtonClick
  end
  object IconDeleteButton: TBitBtn
    Tag = 1
    Left = 239
    Top = 17
    Width = 153
    Height = 25
    Caption = 'Icon l'#246'schen'
    TabOrder = 2
    OnClick = IconButtonClick
  end
  object ProfileNameEdit: TLabeledEdit
    Left = 21
    Top = 74
    Width = 428
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = 'ProfileNameEdit'
    TabOrder = 3
    OnChange = ProfileNameEditChange
  end
  object ProfileFileNameEdit: TLabeledEdit
    Left = 455
    Top = 74
    Width = 127
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 91
    EditLabel.Height = 13
    EditLabel.Caption = 'ProfileFileNameEdit'
    ReadOnly = True
    TabOrder = 4
  end
  object GameExeGroup: TGroupBox
    Left = 12
    Top = 329
    Width = 570
    Height = 143
    Anchors = [akLeft, akTop, akRight]
    Caption = 'GameExeGroup'
    TabOrder = 5
    DesignSize = (
      570
      143)
    object GameExeButton: TSpeedButton
      Left = 532
      Top = 45
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
      OnClick = ExeSelectButtonClick
      ExplicitLeft = 431
    end
    object InfoButton1: TSpeedButton
      Left = 532
      Top = 68
      Width = 23
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Info'
      OnClick = GameRelPathButton
    end
    object GameExeEdit: TLabeledEdit
      Left = 16
      Top = 45
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 63
      EditLabel.Height = 13
      EditLabel.Caption = 'GameExeEdit'
      TabOrder = 0
      OnChange = GameExeEditChange
    end
    object GameParameterEdit: TLabeledEdit
      Left = 16
      Top = 110
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 95
      EditLabel.Height = 13
      EditLabel.Caption = 'GameParameterEdit'
      TabOrder = 3
    end
    object GameRelPathCheckBox: TCheckBox
      Left = 16
      Top = 68
      Width = 510
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Dateipfad relativ zur DOSBox-Verzeichnisstruktur interpretieren'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Visible = False
      OnClick = RelPathCheckBoxClick
    end
    object RunAsAdminCheckBox: TCheckBox
      Left = 16
      Top = 68
      Width = 510
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'RunAsAdminCheckBox'
      TabOrder = 2
    end
  end
  object SetupExeGroup: TGroupBox
    Left = 12
    Top = 470
    Width = 570
    Height = 187
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SetupExeGroup'
    TabOrder = 6
    DesignSize = (
      570
      187)
    object SetupExeButton: TSpeedButton
      Tag = 1
      Left = 532
      Top = 45
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
      OnClick = ExeSelectButtonClick
      ExplicitLeft = 431
    end
    object InfoLabel: TLabel
      Left = 15
      Top = 137
      Width = 540
      Height = 47
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 'InfoLabel'
      WordWrap = True
    end
    object InfoButton2: TSpeedButton
      Left = 532
      Top = 68
      Width = 23
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Info'
      OnClick = GameRelPathButton
    end
    object SetupExeEdit: TLabeledEdit
      Left = 16
      Top = 45
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = 'SetupExeEdit'
      TabOrder = 0
      OnChange = SetupExeEditChange
    end
    object SetupParameterEdit: TLabeledEdit
      Left = 16
      Top = 110
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 96
      EditLabel.Height = 13
      EditLabel.Caption = 'SetupParameterEdit'
      TabOrder = 2
    end
    object SetupRelPathCheckBox: TCheckBox
      Tag = 1
      Left = 16
      Top = 68
      Width = 510
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Dateipfad relativ zur DOSBox-Verzeichnisstruktur interpretieren'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = RelPathCheckBoxClick
    end
  end
  object GameGroup: TGroupBox
    Left = 12
    Top = 107
    Width = 570
    Height = 222
    Anchors = [akLeft, akTop, akRight]
    Caption = 'GameGroup'
    TabOrder = 7
    DesignSize = (
      570
      222)
    object GameButton: TSpeedButton
      Tag = 2
      Left = 532
      Top = 77
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
      OnClick = ExeSelectButtonClick
      ExplicitLeft = 531
    end
    object GameZipButton: TSpeedButton
      Tag = 3
      Left = 532
      Top = 128
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
      OnClick = ExeSelectButtonClick
    end
    object GameZipLabel: TLabel
      Left = 16
      Top = 157
      Width = 505
      Height = 62
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'GameZipLabel'
      WordWrap = True
    end
    object GameComboBox: TComboBox
      Left = 15
      Top = 26
      Width = 506
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = GameComboBoxChange
    end
    object GameEdit: TLabeledEdit
      Left = 15
      Top = 77
      Width = 506
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 45
      EditLabel.Height = 13
      EditLabel.Caption = 'GameEdit'
      TabOrder = 1
    end
    object GameZipCheckBox: TCheckBox
      Left = 16
      Top = 112
      Width = 505
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        'Spieledateien aus dieser Zip-Datei in Ordner entpacken (und wied' +
        'er einpacken)'
      TabOrder = 2
    end
    object GameZipEdit: TEdit
      Left = 16
      Top = 130
      Width = 505
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnChange = GameZipEditChange
    end
  end
  object ExtraExeFilesButton: TBitBtn
    Left = 12
    Top = 655
    Width = 245
    Height = 25
    Caption = 'ExtraExeFilesButton'
    TabOrder = 8
    OnClick = ExtraExeFilesButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333FFFFFFFFFFFFFFF000000000000000077777777777777770FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07FFFFFFFFFFFFFF70CCCCCCCCCCCCCC07777777777777777088CCCCCCCCC
      C8807FF7777777777FF700000000000000007777777777777777333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object IgnoreWindowsWarningsCheckBox: TCheckBox
    Left = 265
    Top = 660
    Width = 330
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Ignore Windows file warnings for this profile'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Visible = False
  end
  object TurnOffDOSBoxFailedWarningCheckBox: TCheckBox
    Left = 265
    Top = 669
    Width = 330
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Turn off DOSBox failed warning for this profile'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Visible = False
  end
  object OpenDialog: TOpenDialog
    Left = 536
    Top = 15
  end
end
