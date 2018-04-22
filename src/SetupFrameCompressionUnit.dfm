object SetupFrameCompression: TSetupFrameCompression
  Left = 0
  Top = 0
  Width = 578
  Height = 415
  TabOrder = 0
  DesignSize = (
    578
    415)
  object InfoLabel: TLabel
    Left = 16
    Top = 168
    Width = 537
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object CompressRadioGroup: TRadioGroup
    Left = 16
    Top = 16
    Width = 537
    Height = 137
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Compression level when using zip files as DOSBox drives'
    ItemIndex = 3
    Items.Strings = (
      'Store only, no compression (very fast)'
      'Fast'
      'Normal'
      'Good compression'
      'Maximum compression level, may be very slow')
    TabOrder = 0
  end
end
