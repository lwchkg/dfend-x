object SetupFrameWine: TSetupFrameWine
  Left = 0
  Top = 0
  Width = 572
  Height = 452
  TabOrder = 0
  DesignSize = (
    572
    452)
  object MainInfoLabel: TLabel
    Left = 32
    Top = 42
    Width = 529
    Height = 34
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'You can overwrite this setting by using one of the following com' +
      'mand line parameters: "WindowsMode" or "NoWineSupport".'
    WordWrap = True
  end
  object ListInfoLabel: TLabel
    Left = 16
    Top = 87
    Width = 69
    Height = 13
    Caption = 'Remapping list'
  end
  object MainCheckBox: TCheckBox
    Left = 16
    Top = 24
    Width = 545
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enable Wine mode'
    TabOrder = 0
  end
  object List: TValueListEditor
    Left = 16
    Top = 102
    Width = 241
    Height = 131
    TabOrder = 1
    ColWidths = (
      91
      144)
  end
  object RemapMountsCheckBox: TCheckBox
    Left = 272
    Top = 112
    Width = 297
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Remap mount commands'
    TabOrder = 2
  end
  object RemapScreenshotFolderCheckBox: TCheckBox
    Left = 272
    Top = 144
    Width = 297
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Remap screenshot folder name'
    TabOrder = 3
  end
  object RemapMapperFileCheckBox: TCheckBox
    Left = 272
    Top = 176
    Width = 297
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Remap key mapper file'
    TabOrder = 4
  end
  object RemapDOSBoxFolderCheckBox: TCheckBox
    Left = 272
    Top = 208
    Width = 297
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Remap DOSBOX path'
    TabOrder = 5
  end
  object LinuxLinkModeCheckBox: TCheckBox
    Left = 16
    Top = 256
    Width = 545
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Switch link creation menu item to create Linux shell scripts'
    TabOrder = 6
  end
  object ShellScriptPreambleEdit: TLabeledEdit
    Left = 16
    Top = 304
    Width = 545
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 98
    EditLabel.Height = 13
    EditLabel.Caption = 'Shell script preamble'
    TabOrder = 7
  end
end
