object SetupFrameViewer: TSetupFrameViewer
  Left = 0
  Top = 0
  Width = 800
  Height = 425
  TabOrder = 0
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 800
    Height = 425
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      800
      425)
    object VideosGroupBox: TGroupBox
      Left = 5
      Top = 294
      Width = 784
      Height = 115
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Videos'
      TabOrder = 0
      DesignSize = (
        784
        115)
      object VideosButton: TSpeedButton
        Tag = 2
        Left = 750
        Top = 77
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
        OnClick = ButtonWork
        ExplicitLeft = 503
      end
      object VideosRadioButton1: TRadioButton
        Left = 16
        Top = 20
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use internal viewer'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object VideosRadioButton2: TRadioButton
        Left = 16
        Top = 40
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use default program for opening files'
        TabOrder = 1
      end
      object VideosRadioButton3: TRadioButton
        Left = 16
        Top = 60
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use custom program'
        TabOrder = 2
      end
      object VideosEdit: TEdit
        Left = 32
        Top = 78
        Width = 712
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = VideosEditChange
      end
    end
    object SoundsGroupBox: TGroupBox
      Left = 5
      Top = 167
      Width = 784
      Height = 113
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Sounds'
      TabOrder = 1
      DesignSize = (
        784
        113)
      object SoundsButton: TSpeedButton
        Tag = 1
        Left = 750
        Top = 77
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
        OnClick = ButtonWork
        ExplicitLeft = 503
      end
      object SoundsRadioButton1: TRadioButton
        Left = 16
        Top = 20
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use internal viewer'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object SoundsRadioButton2: TRadioButton
        Left = 16
        Top = 40
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use default program for opening files'
        TabOrder = 1
      end
      object SoundsRadioButton3: TRadioButton
        Left = 16
        Top = 60
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use custom program'
        TabOrder = 2
      end
      object SoundsEdit: TEdit
        Left = 32
        Top = 78
        Width = 712
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = SoundsEditChange
      end
    end
    object ImagesGroupBox: TGroupBox
      Left = 5
      Top = 16
      Width = 784
      Height = 137
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Images'
      TabOrder = 2
      DesignSize = (
        784
        137)
      object ImagesButton: TSpeedButton
        Left = 750
        Top = 77
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
        OnClick = ButtonWork
        ExplicitLeft = 503
      end
      object ImagesRadioButton1: TRadioButton
        Left = 16
        Top = 20
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use internal viewer'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object ImagesRadioButton2: TRadioButton
        Left = 16
        Top = 40
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use default program for opening files'
        TabOrder = 1
      end
      object ImagesRadioButton3: TRadioButton
        Left = 16
        Top = 60
        Width = 752
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use custom program'
        TabOrder = 2
      end
      object ImagesEdit: TEdit
        Left = 32
        Top = 78
        Width = 712
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = ImagesEditChange
      end
      object ModalImageViewerCheckBox: TCheckBox
        Left = 16
        Top = 105
        Width = 728
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Show internal image viewer as modal window'
        TabOrder = 4
      end
    end
  end
  object PrgOpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 224
    Top = 7
  end
end
