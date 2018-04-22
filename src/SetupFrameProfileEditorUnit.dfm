object SetupFrameProfileEditor: TSetupFrameProfileEditor
  Left = 0
  Top = 0
  Width = 542
  Height = 358
  TabOrder = 0
  DesignSize = (
    542
    358)
  object ReopenLastActiveProfileSheetCheckBox: TCheckBox
    Left = 16
    Top = 24
    Width = 520
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Zuletzt aktive Seite im Profileditor merken'
    TabOrder = 0
  end
  object ProfileEditorDFendRadioButton: TRadioButton
    Left = 16
    Top = 65
    Width = 520
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Klassischen D-Fend Profileditor verwenden'
    TabOrder = 1
  end
  object ProfileEditorModernRadioButton: TRadioButton
    Left = 16
    Top = 85
    Width = 520
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Modernen Profileditor verwenden'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object AutoSetScreenshotFolderRadioGroup: TRadioGroup
    Left = 16
    Top = 120
    Width = 520
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Screenshot-Ordner beim Hinzuf'#252'gen von Profilen automatisch festl' +
      'egen'
    ItemIndex = 1
    Items.Strings = (
      'Nur beim Hinzuf'#252'gen '#252'ber den Assistenten'
      
        'Beim Hinzuf'#252'gen '#252'ber den Assistenten und '#252'ber den modernen Profi' +
        'leditor')
    TabOrder = 3
  end
  object RenameProfFilesCheckBox: TCheckBox
    Left = 16
    Top = 208
    Width = 520
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Profildateinamen immer gem'#228#223' dem Profilnamen umbenennen'
    TabOrder = 4
  end
  object AutoAddMountingsRadioGroup: TRadioGroup
    Left = 16
    Top = 250
    Width = 520
    Height = 63
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Mounting-Einstellungen bei Bedarf automatisch hinzuf'#252'gen'
    Items.Strings = (
      'Nur beim Hinzuf'#252'gen '#252'ber den Assistenten'
      
        'Beim Hinzuf'#252'gen '#252'ber den Assistenten und '#252'ber den modernen Profi' +
        'leditor')
    TabOrder = 5
  end
end
