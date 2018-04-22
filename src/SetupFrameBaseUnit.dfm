object SetupFrameBase: TSetupFrameBase
  Left = 0
  Top = 0
  Width = 685
  Height = 528
  TabOrder = 0
  DesignSize = (
    685
    528)
  object MinimizeToTrayCheckBox: TCheckBox
    Left = 16
    Top = 20
    Width = 649
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Minimize to tray area'
    TabOrder = 0
  end
  object StartWithWindowsCheckBox: TCheckBox
    Left = 16
    Top = 52
    Width = 649
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Start with Windows'
    TabOrder = 1
  end
  object OnlySingleInstanceCheckBox: TCheckBox
    Left = 16
    Top = 84
    Width = 649
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Allow only one running instance'
    TabOrder = 2
  end
end
