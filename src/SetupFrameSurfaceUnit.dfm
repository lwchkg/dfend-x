object SetupFrameSurface: TSetupFrameSurface
  Left = 0
  Top = 0
  Width = 733
  Height = 315
  TabOrder = 0
  DesignSize = (
    733
    315)
  object StartSizeLabel: TLabel
    Left = 16
    Top = 16
    Width = 168
    Height = 13
    Caption = 'Fenstergr'#246#223'e beim Programmstart:'
  end
  object IconSetLabel: TLabel
    Left = 16
    Top = 80
    Width = 48
    Height = 13
    Caption = 'Icon sets:'
  end
  object IconSetAuthorLabel: TLabel
    Left = 16
    Top = 271
    Width = 37
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Author:'
    ExplicitTop = 250
  end
  object IconSetAuthorNameLabel: TLabel
    Left = 16
    Top = 290
    Width = 697
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    ExplicitTop = 269
  end
  object IconSetPreviewLabel: TLabel
    Left = 16
    Top = 232
    Width = 42
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Preview:'
  end
  object IconSetImage: TImage
    Left = 16
    Top = 247
    Width = 113
    Height = 20
    Anchors = [akLeft, akBottom]
  end
  object IconCustomizeLabel: TLabel
    Left = 312
    Top = 99
    Width = 128
    Height = 13
    Caption = 'Open icons customizing file'
    OnClick = IconCustomizeLabelClick
  end
  object StartSizeComboBox: TComboBox
    Left = 16
    Top = 37
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'Vorgabewerte f'#252'r Fenstergr'#246#223'e'
    Items.Strings = (
      'Vorgabewerte f'#252'r Fenstergr'#246#223'e'
      'Letzte Fenstergr'#246#223'e wiederherstellen'
      'Minimiert starten'
      'Maximiert starten'
      'Vollbildmodus ohne Fensterrahmen')
  end
  object IconSetListbox: TCheckListBox
    Left = 16
    Top = 99
    Width = 281
    Height = 127
    OnClickCheck = IconSetListboxClickCheck
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnClick = IconSetListboxClick
  end
end
