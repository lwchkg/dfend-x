object SetupFrameLanguage: TSetupFrameLanguage
  Left = 0
  Top = 0
  Width = 606
  Height = 419
  TabOrder = 0
  DesignSize = (
    606
    419)
  object LanguageLabel: TLabel
    Left = 16
    Top = 16
    Width = 90
    Height = 13
    Caption = 'Programmsprache:'
  end
  object DosBoxLangLabel: TLabel
    Left = 16
    Top = 136
    Width = 84
    Height = 13
    Caption = 'DosBoxLangLabel'
  end
  object LanguageInfoLabel: TLabel
    Left = 200
    Top = 31
    Width = 393
    Height = 174
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'LanguageInfoLabel'
    Visible = False
    WordWrap = True
  end
  object InstallerLangLabel: TLabel
    Left = 16
    Top = 192
    Width = 87
    Height = 13
    Caption = 'InstallerLangLabel'
  end
  object InstallerLangInfoLabel: TLabel
    Left = 16
    Top = 238
    Width = 577
    Height = 83
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InstallerLangInfoLabel'
    WordWrap = True
  end
  object LanguageComboBox: TComboBox
    Left = 16
    Top = 32
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = LanguageComboBoxChange
    OnDropDown = ComboBoxDropDown
  end
  object DosBoxLangEditComboBox: TComboBox
    Left = 16
    Top = 155
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnChange = DosBoxLangEditComboBoxChange
    OnDropDown = ComboBoxDropDown
  end
  object LanguageOpenEditor: TBitBtn
    Left = 16
    Top = 59
    Width = 153
    Height = 25
    Caption = 'Spracheditor '#246'ffnen'
    TabOrder = 1
    OnClick = ButtonWork
  end
  object LanguageNew: TBitBtn
    Tag = 1
    Left = 16
    Top = 90
    Width = 153
    Height = 25
    Caption = 'Neue Sprache anlegen'
    TabOrder = 4
    OnClick = ButtonWork
  end
  object InstallerLangEditComboBox: TComboBox
    Left = 16
    Top = 211
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = InstallerLangEditComboBoxChange
    OnDropDown = ComboBoxDropDown
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 304
    Top = 14
  end
end
