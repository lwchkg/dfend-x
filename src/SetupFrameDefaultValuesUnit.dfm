object SetupFrameDefaultValues: TSetupFrameDefaultValues
  Left = 0
  Top = 0
  Width = 547
  Height = 358
  TabOrder = 0
  DesignSize = (
    547
    358)
  object DefaultValueLabel: TLabel
    Left = 8
    Top = 19
    Width = 50
    Height = 13
    Caption = 'Kategorie:'
  end
  object DefaultValueComboBox: TComboBox
    Left = 80
    Top = 17
    Width = 241
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 0
    OnChange = DefaultValueComboBoxChange
    OnDropDown = DefaultValueComboBoxDropDown
  end
  object DefaultValueMemo: TRichEdit
    Left = 8
    Top = 44
    Width = 529
    Height = 301
    Anchors = [akLeft, akTop, akRight, akBottom]
    PlainText = True
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
  object DefaultValueSpeedButton: TBitBtn
    Left = 335
    Top = 13
    Width = 202
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Vorgabewerte wiederherstellen'
    TabOrder = 2
    OnClick = DefaultValueSpeedButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
      33333333333F8888883F33330000324334222222443333388F3833333388F333
      000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
      F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
      223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
      3338888300003AAAAAAA33333333333888888833333333330000333333333333
      333333333333333333FFFFFF000033333333333344444433FFFF333333888888
      00003A444333333A22222438888F333338F3333800003A2243333333A2222438
      F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
      22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
      33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
      3333333333338888883333330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object DefaultValuePopupMenu: TPopupMenu
    Left = 504
    Top = 15
    object PopupThisValue: TMenuItem
      Caption = 'Diese Kategorie'
      OnClick = PopupMenuWork
    end
    object PopupAllValues: TMenuItem
      Tag = 1
      Caption = 'Alle Kategorien'
      OnClick = PopupMenuWork
    end
  end
end
