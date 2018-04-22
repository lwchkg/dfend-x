object WizardGameInfoFrame: TWizardGameInfoFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 550
  TabOrder = 0
  DesignSize = (
    592
    550)
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 571
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bitte geben Sie die Metadaten zu dem Spiel oder Programm an. All' +
      ' diese Angaben sind optional k'#246'nnen auch sp'#228'ter '#252'ber den Profile' +
      'editor erg'#228'nzt und ver'#228'ndert werden, d.h. Sie m'#252'ssen nicht alle ' +
      'Felder unbedingt jetzt ausf'#252'llen.'
    WordWrap = True
  end
  object Bevel: TBevel
    Left = 0
    Top = 71
    Width = 597
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object UserDefinedDataLabel: TLabel
    Left = 8
    Top = 360
    Width = 107
    Height = 13
    Caption = 'UserDefinedDataLabel'
  end
  object NotesLabel: TLabel
    Left = 8
    Top = 458
    Width = 69
    Height = 13
    Caption = 'Bemerkungen:'
  end
  object AddButton: TSpeedButton
    Left = 531
    Top = 352
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333FF33333333FF333993333333300033377F3333333777333993333333
      300033F77FFF3333377739999993333333333777777F3333333F399999933333
      33003777777333333377333993333333330033377F3333333377333993333333
      3333333773333333333F333333333333330033333333F33333773333333C3333
      330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
      333333333337733333FF3333333C333330003333333733333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = AddButtonClick
  end
  object DelButton: TSpeedButton
    Left = 556
    Top = 352
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333FF33333333333330003333333333333777333333333333
      300033FFFFFF3333377739999993333333333777777F3333333F399999933333
      3300377777733333337733333333333333003333333333333377333333333333
      3333333333333333333F333333333333330033333F33333333773333C3333333
      330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
      333333377F33333333FF3333C333333330003333733333333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = DelButtonClick
  end
  object MultiValueInfoLabel: TLabel
    Left = 8
    Top = 136
    Width = 250
    Height = 13
    Caption = 'You can enter multiple values per key divided by ";".'
  end
  object GameInfoValueListEditor: TValueListEditor
    Left = 8
    Top = 152
    Width = 571
    Height = 160
    Anchors = [akLeft, akTop, akRight]
    Strings.Strings = (
      '=')
    TabOrder = 2
    OnEditButtonClick = GameInfoValueListEditorEditButtonClick
    ColWidths = (
      150
      415)
  end
  object FavouriteCheckBox: TCheckBox
    Left = 440
    Top = 130
    Width = 139
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'FavouriteCheckBox'
    TabOrder = 1
  end
  object Tab: TStringGrid
    Left = 8
    Top = 376
    Width = 571
    Height = 76
    Anchors = [akLeft, akTop, akRight]
    ColCount = 2
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 4
  end
  object NotesMemo: TRichEdit
    Left = 8
    Top = 472
    Width = 571
    Height = 74
    Anchors = [akLeft, akTop, akRight, akBottom]
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object ToolBarPanel: TPanel
    Left = 8
    Top = 312
    Width = 571
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 3
    object ToolBar: TToolBar
      Left = 0
      Top = 0
      Width = 571
      Height = 29
      ButtonHeight = 30
      ButtonWidth = 166
      Caption = 'ToolBar'
      Images = ImageList
      List = True
      ShowCaptions = True
      TabOrder = 0
      Wrapable = False
      object SearchGameButton: TToolButton
        Tag = 2
        Left = 0
        Top = 0
        Caption = 'Search for game at ...'
        DropdownMenu = SearchPopupMenu
        ImageIndex = 0
        Style = tbsDropDown
        OnClick = SearchClick
      end
      object ToolButton1: TToolButton
        Left = 181
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 1
        Style = tbsSeparator
      end
      object DownloadDataButton: TToolButton
        Tag = 3
        Left = 189
        Top = 0
        Caption = 'Download game information'
        ImageIndex = 0
        OnClick = SearchClick
      end
    end
  end
  object BaseName: TLabeledEdit
    Left = 8
    Top = 109
    Width = 571
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 140
    EditLabel.Height = 13
    EditLabel.Caption = 'Name des Programms / Spiels'
    TabOrder = 0
  end
  object SearchPopupMenu: TPopupMenu
    Images = ImageList
    Left = 346
    Top = 132
  end
  object ImageList: TImageList
    Left = 378
    Top = 132
    Bitmap = {
      494C010102000400140010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000FF00000080000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF000000800000008000000080000000FF00000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000FF00
      0000800000000080800000808000800000008000000080000000800000008000
      000080000000000000000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FF0000008000
      0000FF000000008080000080800080000000FF00000080000000FF0000008000
      000000808000008080000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FF000000FF00
      0000FF0000000080800000808000008080008000000080000000800000008000
      000000808000008080000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000008080000080800000808000FF000000FF000000FF0000008000
      0000FF000000800000008000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF0000000080
      800000808000008080000080800000808000FF000000FF000000FF0000008000
      00008000000080000000FF00000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000080000000008080000080
      800000808000008080000080800000808000FF00000000808000FF0000008000
      0000FF000000FF000000FF00000000000000FFFF00000000000000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF0000000080
      800000808000008080000080800000808000008080000080800000808000FF00
      000080000000FF000000800000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000080
      800000808000FF000000FF00000080000000008080000080800000808000FF00
      0000FF00000080000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000808000008080000080800000808000008080000080
      800080000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FF0000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      80000080800000808000FF000000FF00000000808000FF000000008080000080
      8000FF0000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      800000808000FF000000FF00000080000000FF00000080000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000080000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFC0000000000F83FFC0000000000
      E00F200000000000C00700000000000080030000000000008003000000000000
      0001000000000000000100000000000000010000000000000001000000000000
      0001E000000000008003F800000000008003F00000000000C007E00100000000
      E00FC40300000000F83FEC070000000000000000000000000000000000000000
      000000000000}
  end
  object AddUserDataPopupMenu: TPopupMenu
    Left = 541
    Top = 380
  end
end
