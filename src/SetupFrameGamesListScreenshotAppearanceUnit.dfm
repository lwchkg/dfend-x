object SetupFrameGamesListScreenshotAppearance: TSetupFrameGamesListScreenshotAppearance
  Left = 0
  Top = 0
  Width = 576
  Height = 286
  TabOrder = 0
  DesignSize = (
    576
    286)
  object ScreenshotsListBackgroundButton: TSpeedButton
    Tag = 8
    Left = 544
    Top = 117
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ScreenshotsListBackgroundButtonClick
  end
  object ScreenshotsListFontSizeLabel: TLabel
    Left = 16
    Top = 160
    Width = 59
    Height = 13
    Caption = 'Schriftgr'#246#223'e'
  end
  object ScreenshotsListFontColorLabel: TLabel
    Left = 140
    Top = 160
    Width = 61
    Height = 13
    Caption = 'Schriftfarbe:'
  end
  object ScreenshotPreviewLabel: TLabel
    Left = 16
    Top = 216
    Width = 157
    Height = 13
    Caption = 'Gr'#246#223'e der Screenshot-Vorschau:'
  end
  object ScreenshotsListBackgroundRadioButton1: TRadioButton
    Left = 16
    Top = 56
    Width = 551
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Standard Hintergrundfarbe'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object ScreenshotsListBackgroundRadioButton2: TRadioButton
    Left = 16
    Top = 88
    Width = 129
    Height = 17
    Caption = 'Hintergrundfarbe'
    TabOrder = 2
  end
  object ScreenshotsListBackgroundColorBox: TColorBox
    Left = 151
    Top = 86
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 3
    OnChange = ScreenshotsListBackgroundColorBoxChange
  end
  object ScreenshotsListBackgroundRadioButton3: TRadioButton
    Left = 16
    Top = 120
    Width = 129
    Height = 17
    Caption = 'Hintergrundbild'
    TabOrder = 4
  end
  object ScreenshotsListBackgroundEdit: TEdit
    Left = 151
    Top = 118
    Width = 387
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    OnChange = ScreenshotsListBackgroundEditChange
  end
  object ScreenshotsListFontSizeEdit: TSpinEdit
    Left = 16
    Top = 179
    Width = 59
    Height = 22
    MaxValue = 48
    MinValue = 1
    TabOrder = 6
    Value = 9
  end
  object ScreenshotsListFontColorBox: TColorBox
    Left = 140
    Top = 179
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 7
  end
  object ScreenshotPreviewEdit: TSpinEdit
    Left = 16
    Top = 235
    Width = 67
    Height = 22
    MaxValue = 250
    MinValue = 20
    TabOrder = 8
    Value = 100
  end
  object ReselectCategoryCheckBox: TCheckBox
    Left = 16
    Top = 16
    Width = 551
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Zuletzt ausgew'#228'hlte Kategorie beim Start erneut ausw'#228'hlen'
    TabOrder = 0
  end
  object ImageOpenDialog: TOpenDialog
    DefaultExt = 'jpeg'
    Left = 296
    Top = 62
  end
end
