object SetupFrameFreeDOS: TSetupFrameFreeDOS
  Left = 0
  Top = 0
  Width = 638
  Height = 429
  TabOrder = 0
  DesignSize = (
    638
    429)
  object PathFREEDOSButton: TSpeedButton
    Tag = 6
    Left = 594
    Top = 31
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
    OnClick = PathFREEDOSButtonClick
  end
  object InfoLabel: TLabel
    Left = 16
    Top = 117
    Width = 601
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object FreeDOSDownloadURLInfo: TLabel
    Left = 16
    Top = 64
    Width = 158
    Height = 13
    Caption = 'You can download FreeDOS from'
  end
  object FreeDOSDownloadURL: TLabel
    Left = 16
    Top = 83
    Width = 109
    Height = 13
    Caption = 'FreeDOSDownloadURL'
    OnClick = FreeDOSDownloadURLClick
  end
  object PathFREEDOSEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 572
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 86
    EditLabel.Height = 13
    EditLabel.Caption = 'PathFREEDOSEdit'
    TabOrder = 0
  end
end
