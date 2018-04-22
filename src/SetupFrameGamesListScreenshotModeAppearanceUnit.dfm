object SetupFrameGamesListScreenshotModeAppearance: TSetupFrameGamesListScreenshotModeAppearance
  Left = 0
  Top = 0
  Width = 576
  Height = 375
  TabOrder = 0
  DesignSize = (
    576
    375)
  object WidthLabel: TLabel
    Left = 16
    Top = 16
    Width = 109
    Height = 13
    Caption = '&Breite der Screenshots'
    FocusControl = WidthEdit
  end
  object HeightLabel: TLabel
    Left = 16
    Top = 80
    Width = 106
    Height = 13
    Caption = '&H'#246'he der Screenshots'
    FocusControl = HeightEdit
  end
  object UseFirstScreenshotLabel: TLabel
    Left = 87
    Top = 170
    Width = 474
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '(1=ersten Screenshot verwenden, 2=zweiten Screenshot usw.)'
  end
  object WidthEdit: TSpinEdit
    Left = 16
    Top = 35
    Width = 89
    Height = 22
    MaxValue = 500
    MinValue = 10
    TabOrder = 0
    Value = 10
  end
  object HeightEdit: TSpinEdit
    Left = 16
    Top = 99
    Width = 89
    Height = 22
    MaxValue = 500
    MinValue = 10
    TabOrder = 1
    Value = 10
  end
  object UseFirstScreenshotCheckBox: TCheckBox
    Left = 16
    Top = 144
    Width = 545
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Screenshotdatei mit folgender Nummer verwenden, wenn kein Screen' +
      'shot ausgew'#228'hlt ist.'
    TabOrder = 2
  end
  object UseFirstScreenshotEdit: TSpinEdit
    Left = 32
    Top = 167
    Width = 49
    Height = 22
    MaxValue = 99
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
end
