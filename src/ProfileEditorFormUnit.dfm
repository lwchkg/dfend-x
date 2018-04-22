object ProfileEditorForm: TProfileEditorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ProfileEditorForm'
  ClientHeight = 654
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 537
    Height = 615
    ActivePage = ProfileSettingsSheet
    Images = ImageList
    MultiLine = True
    TabOrder = 0
    object ProfileSettingsSheet: TTabSheet
      Caption = 'ProfileSettingsSheet'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ExtraDirsLabel: TLabel
        Left = 13
        Top = 437
        Width = 172
        Height = 13
        Caption = 'Zus'#228'tzliche Programmverzeichnisse:'
      end
      object ExtraDirsAddButton: TSpeedButton
        Tag = 2
        Left = 490
        Top = 456
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object ExtraDirsEditButton: TSpeedButton
        Tag = 3
        Left = 490
        Top = 484
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonWork
      end
      object ExtraDirsDelButton: TSpeedButton
        Tag = 4
        Left = 490
        Top = 512
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object ExtraFilesLabel: TLabel
        Left = 13
        Top = 324
        Width = 327
        Height = 13
        Caption = 
          'Zus'#228'tzliche Programmdateien (au'#223'erhalb des Spiele-Verzeichnisses' +
          '):'
      end
      object ExtraFilesAddButton: TSpeedButton
        Tag = 27
        Left = 490
        Top = 343
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object ExtraFilesEditButton: TSpeedButton
        Tag = 28
        Left = 490
        Top = 371
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonWork
      end
      object ExtraFilesDelButton: TSpeedButton
        Tag = 29
        Left = 490
        Top = 399
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object IconPanel: TPanel
        Left = 12
        Top = 3
        Width = 35
        Height = 35
        TabOrder = 0
        object IconImage: TImage
          Left = 1
          Top = 1
          Width = 33
          Height = 33
          Align = alClient
          ExplicitLeft = 12
          ExplicitTop = 9
          ExplicitWidth = 32
          ExplicitHeight = 32
        end
      end
      object IconSelectButton: TBitBtn
        Left = 72
        Top = 9
        Width = 141
        Height = 25
        Caption = 'Icon ausw'#228'hlen...'
        TabOrder = 1
        OnClick = ButtonWork
      end
      object IconDeleteButton: TBitBtn
        Tag = 1
        Left = 228
        Top = 9
        Width = 141
        Height = 25
        Caption = 'Icon l'#246'schen'
        TabOrder = 2
        OnClick = ButtonWork
      end
      object ProfileSettingsValueListEditor: TValueListEditor
        Left = 13
        Top = 44
        Width = 500
        Height = 237
        Strings.Strings = (
          '=')
        TabOrder = 3
        OnEditButtonClick = ProfileSettingsValueListEditorEditButtonClick
        OnKeyUp = ProfileSettingsValueListEditorKeyUp
        OnSetEditText = ProfileSettingsValueListEditorSetEditText
        ColWidths = (
          150
          344)
      end
      object ExtraDirsListBox: TListBox
        Left = 13
        Top = 456
        Width = 471
        Height = 88
        ItemHeight = 13
        TabOrder = 6
        OnClick = ExtraDirsListBoxClick
        OnDblClick = ExtraDirsListBoxDblClick
        OnKeyDown = ExtraDirsListBoxKeyDown
      end
      object GenerateScreenshotFolderNameButton: TBitBtn
        Tag = 9
        Left = 13
        Top = 287
        Width = 316
        Height = 25
        Caption = 'Screenshot-Verzeichnis automatisch festlegen'
        TabOrder = 4
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
          033333777777777773333330777777703333333773F333773333333330888033
          33333FFFF7FFF7FFFFFF0000000000000003777777777777777F0FFFFFFFFFF9
          FF037F3333333337337F0F78888888887F037F33FFFFFFFFF37F0F7000000000
          8F037F3777777777F37F0F70AAAAAAA08F037F37F3333337F37F0F70ADDDDDA0
          8F037F37F3333337F37F0F70A99A99A08F037F37F3333337F37F0F70A99A99A0
          8F037F37F3333337F37F0F70AAAAAAA08F037F37FFFFFFF7F37F0F7000000000
          8F037F3777777777337F0F77777777777F037F3333333333337F0FFFFFFFFFFF
          FF037FFFFFFFFFFFFF7F00000000000000037777777777777773}
        NumGlyphs = 2
      end
      object ExtraFilesListBox: TListBox
        Left = 13
        Top = 343
        Width = 471
        Height = 88
        ItemHeight = 13
        TabOrder = 5
        OnClick = ExtraFilesListBoxClick
        OnDblClick = ExtraFilesListBoxDblClick
        OnKeyDown = ExtraFilesListBoxKeyDown
      end
    end
    object GameInfoSheet: TTabSheet
      Caption = 'GameInfoSheet'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object NotesLabel: TLabel
        Left = 12
        Top = 282
        Width = 69
        Height = 13
        Caption = 'Bemerkungen:'
      end
      object GameInfoValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 501
        Height = 177
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = GameInfoValueListEditorEditButtonClick
        ColWidths = (
          150
          345)
      end
      object NotesMemo: TRichEdit
        Left = 12
        Top = 296
        Width = 501
        Height = 257
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 3
      end
      object GenerateGameDataFolderNameButton: TBitBtn
        Tag = 19
        Left = 12
        Top = 239
        Width = 278
        Height = 25
        Caption = 'Daten-Verzeichnis automatisch erstellen'
        TabOrder = 1
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333CCCCC33
          33333FFFF77777FFFFFFCCCCCC808CCCCCC3777777F7F777777F008888070888
          8003777777777777777F0F0770F7F0770F0373F33337F333337370FFFFF7FFFF
          F07337F33337F33337F370FFFB99FBFFF07337F33377F33337F330FFBF99BFBF
          F033373F337733333733370BFBF7FBFB0733337F333FF3337F33370FBF98BFBF
          0733337F3377FF337F333B0BFB990BFB03333373FF777FFF73333FB000B99000
          B33333377737777733333BFBFBFB99FBF33333333FF377F333333FBF99BF99BF
          B333333377F377F3333333FB99FB99FB3333333377FF77333333333FB9999FB3
          333333333777733333333333FBFBFB3333333333333333333333}
        NumGlyphs = 2
      end
      object GameInfoMetaDataButton: TBitBtn
        Tag = 23
        Left = 296
        Top = 239
        Width = 217
        Height = 25
        Caption = 'Benutzerdefinierte Informationen'
        TabOrder = 2
        OnClick = ButtonWork
      end
      object Panel2: TPanel
        Left = 16
        Top = 194
        Width = 500
        Height = 30
        BevelOuter = bvNone
        TabOrder = 4
        object ToolBar: TToolBar
          Left = 0
          Top = 0
          Width = 500
          Height = 29
          ButtonHeight = 30
          ButtonWidth = 140
          Caption = 'ToolBar'
          Images = ImageList
          List = True
          ShowCaptions = True
          TabOrder = 0
          object SearchGameButton: TToolButton
            Tag = 2
            Left = 0
            Top = 0
            Caption = 'Search for game at ...'
            DropdownMenu = SearchPopupMenu
            ImageIndex = 14
            Style = tbsDropDown
            OnClick = SearchClick
          end
        end
      end
    end
    object GeneralSheet: TTabSheet
      Caption = 'GeneralSheet'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GeneralValueListEditor: TValueListEditor
        Left = 11
        Top = 16
        Width = 501
        Height = 537
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = GeneralValueListEditorEditButtonClick
        ColWidths = (
          248
          247)
      end
    end
    object EnvironmentSheet: TTabSheet
      Caption = 'EnvironmentSheet'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object KeyboardLayoutInfoLabel: TLabel
        Left = 12
        Top = 524
        Width = 501
        Height = 42
        AutoSize = False
        WordWrap = True
      end
      object EnvironmentValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 501
        Height = 505
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = EnvironmentValueListEditorEditButtonClick
        ColWidths = (
          248
          247)
      end
    end
    object MountingSheet: TTabSheet
      Caption = 'MountingSheet'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MountingListView: TListView
        Left = 3
        Top = 16
        Width = 523
        Height = 481
        Columns = <>
        ReadOnly = True
        PopupMenu = PopupMenu
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = MountingListViewDblClick
        OnKeyDown = MountingListViewKeyDown
      end
      object MountingAddButton: TBitBtn
        Tag = 5
        Left = 3
        Top = 503
        Width = 94
        Height = 25
        Caption = 'Hinzuf'#252'gen...'
        TabOrder = 1
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
          333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
          0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
          07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
          07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
          0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
          33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
          B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
          3BB33773333773333773B333333B3333333B7333333733333337}
        NumGlyphs = 2
      end
      object MountingEditButton: TBitBtn
        Tag = 6
        Left = 103
        Top = 503
        Width = 94
        Height = 25
        Caption = 'Bearbeiten...'
        TabOrder = 2
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
      end
      object MountingDelButton: TBitBtn
        Tag = 7
        Left = 203
        Top = 503
        Width = 94
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 3
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
          555557777F777555F55500000000555055557777777755F75555005500055055
          555577F5777F57555555005550055555555577FF577F5FF55555500550050055
          5555577FF77577FF555555005050110555555577F757777FF555555505099910
          555555FF75777777FF555005550999910555577F5F77777775F5500505509990
          3055577F75F77777575F55005055090B030555775755777575755555555550B0
          B03055555F555757575755550555550B0B335555755555757555555555555550
          BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
          50BB555555555555575F555555555555550B5555555555555575}
        NumGlyphs = 2
      end
      object MountingDeleteAllButton: TBitBtn
        Tag = 8
        Left = 303
        Top = 503
        Width = 90
        Height = 25
        Caption = 'Alle l'#246'schen'
        TabOrder = 4
        OnClick = ButtonWork
      end
      object MountingAutoCreateButton: TBitBtn
        Tag = 20
        Left = 399
        Top = 503
        Width = 127
        Height = 25
        Caption = 'Autom. erstellen'
        TabOrder = 5
        OnClick = ButtonWork
      end
      object AutoMountCheckBox: TCheckBox
        Left = 3
        Top = 538
        Width = 501
        Height = 17
        Caption = 'Aktuell verf'#252'gbare CDs in allen Laufwerken automatisch mounten'
        TabOrder = 6
      end
    end
    object SoundSheet: TTabSheet
      Caption = 'SoundSheet'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SoundValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 501
        Height = 121
        Strings.Strings = (
          '=')
        TabOrder = 0
        ColWidths = (
          248
          247)
      end
      object PageControl2: TPageControl
        Left = 12
        Top = 152
        Width = 501
        Height = 241
        ActivePage = SoundSBSheet
        Images = ImageList
        TabOrder = 1
        object SoundSBSheet: TTabSheet
          Caption = 'SoundSBSheet'
          ImageIndex = 8
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SoundSBValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundGUSSheet: TTabSheet
          Caption = 'SoundGUSSheet'
          ImageIndex = 9
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SoundGUSValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundMIDISheet: TTabSheet
          Caption = 'SoundMIDISheet'
          ImageIndex = 10
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SoundMIDIValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundJoystickSheet: TTabSheet
          Caption = 'SoundJoystickSheet'
          ImageIndex = 11
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SoundJoystickValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundMiscSheet: TTabSheet
          Caption = 'SoundMiscSheet'
          ImageIndex = 12
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SoundMiscValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundVolumeSheet: TTabSheet
          Caption = 'SoundVolumeSheet'
          ImageIndex = 13
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SoundVolumeLeftLabel: TLabel
            Left = 148
            Top = 13
            Width = 23
            Height = 13
            Caption = 'Links'
          end
          object SoundVolumeRightLabel: TLabel
            Left = 212
            Top = 13
            Width = 33
            Height = 13
            Caption = 'Rechts'
          end
          object SoundVolumeMasterLabel: TLabel
            Left = 16
            Top = 36
            Width = 33
            Height = 13
            Caption = 'Master'
          end
          object SoundVolumeDisneyLabel: TLabel
            Left = 16
            Top = 64
            Width = 103
            Height = 13
            Caption = 'Disney Sound System'
          end
          object SoundVolumeSpeakerLabel: TLabel
            Left = 16
            Top = 92
            Width = 80
            Height = 13
            Caption = 'Internal Speaker'
          end
          object SoundVolumeGUSLabel: TLabel
            Left = 16
            Top = 120
            Width = 20
            Height = 13
            Caption = 'GUS'
          end
          object SoundVolumeSBLabel: TLabel
            Left = 16
            Top = 148
            Width = 63
            Height = 13
            Caption = 'SoundBlaster'
          end
          object SoundVolumeFMLabel: TLabel
            Left = 16
            Top = 176
            Width = 14
            Height = 13
            Caption = 'FM'
          end
          object SoundVolumeMasterLeftEdit: TSpinEdit
            Left = 148
            Top = 32
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 0
            Value = 100
          end
          object SoundVolumeMasterRightEdit: TSpinEdit
            Left = 212
            Top = 32
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 1
            Value = 100
          end
          object SoundVolumeDisneyLeftEdit: TSpinEdit
            Left = 148
            Top = 60
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 2
            Value = 100
          end
          object SoundVolumeDisneyRightEdit: TSpinEdit
            Left = 212
            Top = 60
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 3
            Value = 100
          end
          object SoundVolumeSpeakerLeftEdit: TSpinEdit
            Left = 148
            Top = 88
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 4
            Value = 100
          end
          object SoundVolumeSpeakerRightEdit: TSpinEdit
            Left = 212
            Top = 88
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 5
            Value = 100
          end
          object SoundVolumeGUSLeftEdit: TSpinEdit
            Left = 148
            Top = 116
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 6
            Value = 100
          end
          object SoundVolumeGUSRightEdit: TSpinEdit
            Left = 212
            Top = 116
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 7
            Value = 100
          end
          object SoundVolumeSBLeftEdit: TSpinEdit
            Left = 148
            Top = 144
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 8
            Value = 100
          end
          object SoundVolumeSBRightEdit: TSpinEdit
            Left = 212
            Top = 144
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 9
            Value = 100
          end
          object SoundVolumeFMLeftEdit: TSpinEdit
            Left = 148
            Top = 172
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 10
            Value = 100
          end
          object SoundVolumeFMRightEdit: TSpinEdit
            Left = 212
            Top = 172
            Width = 49
            Height = 22
            MaxValue = 200
            MinValue = 0
            TabOrder = 11
            Value = 100
          end
        end
      end
    end
    object AutoexecSheet: TTabSheet
      Caption = 'AutoexecSheet'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        529
        567)
      object AutoexecBootFloppyImageButton: TSpeedButton
        Tag = 13
        Left = 496
        Top = 480
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object AutoexecBootFloppyImageAddButton: TSpeedButton
        Tag = 21
        Left = 496
        Top = 508
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object AutoexecBootFloppyImageDelButton: TSpeedButton
        Tag = 22
        Left = 496
        Top = 532
        Width = 23
        Height = 22
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
        OnClick = ButtonWork
      end
      object AutoexecBootFloppyImageInfoLabel: TLabel
        Left = 38
        Top = 507
        Width = 194
        Height = 42
        AutoSize = False
        Caption = 'AutoexecBootFloppyImageInfoLabel'
        WordWrap = True
      end
      object AutoexecOverrideGameStartCheckBox: TCheckBox
        Left = 16
        Top = 16
        Width = 465
        Height = 17
        Caption = 'Spiel-Start '#252'berspringen'
        TabOrder = 0
      end
      object AutoexecOverrideMountingCheckBox: TCheckBox
        Left = 16
        Top = 39
        Width = 457
        Height = 17
        Caption = 'Mounting '#252'berspringen'
        TabOrder = 1
      end
      object AutoexecBootNormal: TRadioButton
        Left = 22
        Top = 430
        Width = 457
        Height = 17
        Caption = 'DosBox normal starten'
        Checked = True
        TabOrder = 3
        TabStop = True
      end
      object AutoexecBootHDImage: TRadioButton
        Left = 22
        Top = 457
        Width = 210
        Height = 17
        Caption = 'Festplattenimage starten'
        TabOrder = 4
      end
      object AutoexecBootFloppyImage: TRadioButton
        Left = 22
        Top = 484
        Width = 210
        Height = 17
        Caption = 'Diskettenimage starten'
        TabOrder = 5
      end
      object AutoexecBootHDImageComboBox: TComboBox
        Left = 242
        Top = 453
        Width = 248
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 6
        Text = 'Master (2)'
        OnChange = AutoexecBootHDImageComboBoxChange
        Items.Strings = (
          'Master (2)'
          'Slave (3)')
      end
      object AutoexecUse4DOSCheckBox: TCheckBox
        Left = 16
        Top = 65
        Width = 497
        Height = 17
        Caption = 'Use 4DOS as command line interpreter'
        TabOrder = 7
      end
      object AutoexecBootFloppyImageTab: TStringGrid
        Left = 242
        Top = 480
        Width = 248
        Height = 74
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 8
      end
      object AutoexecPageControl: TPageControl
        Left = 16
        Top = 96
        Width = 505
        Height = 157
        ActivePage = AutoexecSheet1
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        ExplicitHeight = 197
        object AutoexecSheet1: TTabSheet
          Caption = 'Autoexec.bat'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel1: TPanel
            Left = 0
            Top = 114
            Width = 497
            Height = 29
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitTop = 140
            object AutoexecClearButton: TBitBtn
              Tag = 10
              Left = 0
              Top = 3
              Width = 105
              Height = 25
              Caption = 'L'#246'schen'
              TabOrder = 0
              OnClick = ButtonWork
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000120B0000120B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
                555557777F777555F55500000000555055557777777755F75555005500055055
                555577F5777F57555555005550055555555577FF577F5FF55555500550050055
                5555577FF77577FF555555005050110555555577F757777FF555555505099910
                555555FF75777777FF555005550999910555577F5F77777775F5500505509990
                3055577F75F77777575F55005055090B030555775755777575755555555550B0
                B03055555F555757575755550555550B0B335555755555757555555555555550
                BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
                50BB555555555555575F555555555555550B5555555555555575}
              NumGlyphs = 2
            end
            object AutoexecLoadButton: TBitBtn
              Tag = 11
              Left = 111
              Top = 3
              Width = 105
              Height = 25
              Caption = 'Laden...'
              TabOrder = 1
              OnClick = ButtonWork
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
            end
            object AutoexecSaveButton: TBitBtn
              Tag = 12
              Left = 222
              Top = 3
              Width = 105
              Height = 25
              Caption = 'Speichern...'
              TabOrder = 2
              OnClick = ButtonWork
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
                7700333333337777777733333333008088003333333377F73377333333330088
                88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
                000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
                FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
                99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
                99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
                99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
                93337FFFF7737777733300000033333333337777773333333333}
              NumGlyphs = 2
            end
          end
          object AutoexecMemo: TRichEdit
            Left = 0
            Top = 0
            Width = 497
            Height = 114
            Align = alClient
            PlainText = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
        object AutoexecSheet2: TTabSheet
          Caption = 'Abschluss'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel12: TPanel
            Left = 0
            Top = 114
            Width = 497
            Height = 29
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitTop = 140
            object FinalizationClearButton: TBitBtn
              Tag = 24
              Left = 0
              Top = 3
              Width = 105
              Height = 25
              Caption = 'L'#246'schen'
              TabOrder = 0
              OnClick = ButtonWork
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000120B0000120B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
                555557777F777555F55500000000555055557777777755F75555005500055055
                555577F5777F57555555005550055555555577FF577F5FF55555500550050055
                5555577FF77577FF555555005050110555555577F757777FF555555505099910
                555555FF75777777FF555005550999910555577F5F77777775F5500505509990
                3055577F75F77777575F55005055090B030555775755777575755555555550B0
                B03055555F555757575755550555550B0B335555755555757555555555555550
                BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
                50BB555555555555575F555555555555550B5555555555555575}
              NumGlyphs = 2
            end
            object FinalizationLoadButton: TBitBtn
              Tag = 25
              Left = 111
              Top = 3
              Width = 105
              Height = 25
              Caption = 'Laden...'
              TabOrder = 1
              OnClick = ButtonWork
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
            end
            object FinalizationSaveButton: TBitBtn
              Tag = 26
              Left = 222
              Top = 3
              Width = 105
              Height = 25
              Caption = 'Speichern...'
              TabOrder = 2
              OnClick = ButtonWork
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
                7700333333337777777733333333008088003333333377F73377333333330088
                88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
                000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
                FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
                99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
                99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
                99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
                93337FFFF7737777733300000033333333337777773333333333}
              NumGlyphs = 2
            end
          end
          object FinalizationMemo: TRichEdit
            Left = 0
            Top = 0
            Width = 497
            Height = 114
            Align = alClient
            PlainText = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
      end
    end
    object CustomSetsSheet: TTabSheet
      Caption = 'CustomSetsSheet'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object CustomSetsEnvLabel: TLabel
        Left = 13
        Top = 275
        Width = 104
        Height = 13
        Caption = 'Umgebungsvariablen:'
      end
      object CustomSetsClearButton: TBitBtn
        Tag = 14
        Left = 13
        Top = 223
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 1
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
          555557777F777555F55500000000555055557777777755F75555005500055055
          555577F5777F57555555005550055555555577FF577F5FF55555500550050055
          5555577FF77577FF555555005050110555555577F757777FF555555505099910
          555555FF75777777FF555005550999910555577F5F77777775F5500505509990
          3055577F75F77777575F55005055090B030555775755777575755555555550B0
          B03055555F555757575755550555550B0B335555755555757555555555555550
          BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
          50BB555555555555575F555555555555550B5555555555555575}
        NumGlyphs = 2
      end
      object CustomSetsLoadButton: TBitBtn
        Tag = 15
        Left = 126
        Top = 223
        Width = 105
        Height = 25
        Caption = 'Laden...'
        TabOrder = 2
        OnClick = ButtonWork
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
      end
      object CustomSetsSaveButton: TBitBtn
        Tag = 16
        Left = 237
        Top = 223
        Width = 105
        Height = 25
        Caption = 'Speichern...'
        TabOrder = 3
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
          7700333333337777777733333333008088003333333377F73377333333330088
          88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
          000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
          FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
          99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
          99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
          99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
          93337FFFF7737777733300000033333333337777773333333333}
        NumGlyphs = 2
      end
      object CustomSetsValueListEditor: TValueListEditor
        Left = 12
        Top = 294
        Width = 501
        Height = 227
        KeyOptions = [keyEdit]
        TabOrder = 4
        ColWidths = (
          150
          345)
      end
      object CustomSetsEnvAdd: TBitBtn
        Tag = 17
        Left = 13
        Top = 527
        Width = 105
        Height = 25
        Caption = 'Hinzuf'#252'gen'
        TabOrder = 5
        OnClick = ButtonWork
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
      end
      object CustomSetsEnvDel: TBitBtn
        Tag = 18
        Left = 126
        Top = 527
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 6
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
          555557777F777555F55500000000555055557777777755F75555005500055055
          555577F5777F57555555005550055555555577FF577F5FF55555500550050055
          5555577FF77577FF555555005050110555555577F757777FF555555505099910
          555555FF75777777FF555005550999910555577F5F77777775F5500505509990
          3055577F75F77777575F55005055090B030555775755777575755555555550B0
          B03055555F555757575755550555550B0B335555755555757555555555555550
          BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
          50BB555555555555575F555555555555550B5555555555555575}
        NumGlyphs = 2
      end
      object CustomSetsMemo: TRichEdit
        Left = 13
        Top = 16
        Width = 500
        Height = 201
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object OKButton: TBitBtn
    Left = 4
    Top = 621
    Width = 90
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 100
    Top = 621
    Width = 90
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object PreviousButton: TBitBtn
    Tag = 1
    Left = 293
    Top = 621
    Width = 113
    Height = 25
    Caption = 'Vorheriges'
    ModalResult = 1
    TabOrder = 4
    Visible = False
    OnClick = OKButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333FF3333333333333003333333333333F77F33333333333009033
      333333333F7737F333333333009990333333333F773337FFFFFF330099999000
      00003F773333377777770099999999999990773FF33333FFFFF7330099999000
      000033773FF33777777733330099903333333333773FF7F33333333333009033
      33333333337737F3333333333333003333333333333377333333333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object NextButton: TBitBtn
    Tag = 2
    Left = 412
    Top = 621
    Width = 113
    Height = 25
    Caption = 'N'#228'chstes'
    ModalResult = 1
    TabOrder = 5
    Visible = False
    OnClick = OKButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333FF3333333333333003333
      3333333333773FF3333333333309003333333333337F773FF333333333099900
      33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
      99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
      33333333337F3F77333333333309003333333333337F77333333333333003333
      3333333333773333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object HelpButton: TBitBtn
    Left = 197
    Top = 621
    Width = 90
    Height = 25
    TabOrder = 3
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object OpenDialog: TOpenDialog
    Left = 440
    Top = 596
  end
  object SaveDialog: TSaveDialog
    Left = 472
    Top = 596
  end
  object ImageList: TImageList
    Left = 504
    Top = 594
    Bitmap = {
      494C010110001400080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF000080
      800000FFFF000080800000FFFF000080800000FFFF000080800000FFFF000080
      800000000000000000008080800000000000000000000000000080808000FFFF
      FF00808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000FF00000080000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000080800000FFFF000080
      800000FFFF000080800000FFFF000080800000FFFF000080800000FFFF000080
      800000000000000000008080800080808000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000808080000000000000000000000000000000000000000000000000008000
      0000FF000000800000008000000080000000FF00000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000808080008080800000000000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000000000000000000080000000FF00
      0000800000000080800000808000800000008000000080000000800000008000
      000080000000000000000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000800000C0C0C00000000000C0C0
      C000008000000080000080808000808080008080800080808000008000000080
      0000008000000000000080808000C0C0C000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000FFFFFF00C0C0C000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000080000000FF0000008000
      0000FF000000008080000080800080000000FF00000080000000FF0000008000
      000000808000008080000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF000000000000800000C0C0C00000000000C0C0
      C000008000008080800000000000000000000000000000000000808080000080
      0000008000000000000080808000C0C0C000000000000000000080808000FFFF
      FF008080800080808000C0C0C00000000000FFFFFF00C0C0C000808080008080
      8000808080000000000000000000000000000000000080000000FF000000FF00
      0000FF0000000080800000808000008080008000000080000000800000008000
      000000808000008080000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00000000000080000000800000008000000080
      0000008000008080800000000000000000000000000000000000808080000000
      0000008000000000000080808000C0C0C000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C00000000000FFFFFF00C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000008080000080800000808000FF000000FF000000FF0000008000
      0000FF000000800000008000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF00000000000080000000000000000000000080
      0000008000008080800000000000000000000000000000000000808080000080
      0000008000000000000080808000C0C0C000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000FFFFFF00C0C0C000FFFFFF00FFFF
      FF008080800000000000000000000000000080000000FF000000FF0000000080
      800000808000008080000080800000808000FF000000FF000000FF0000008000
      00008000000080000000FF00000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000080000000000000000000000080
      0000008000008080800000000000000000000000000000000000808080000080
      0000008000000000000080808000C0C0C000000000000000000080808000FFFF
      FF008080800080808000C0C0C00000000000FFFFFF00C0C0C000808080008080
      800080808000000000000000000000000000FF00000080000000008080000080
      800000808000008080000080800000808000FF00000000808000FF0000008000
      0000FF000000FF000000FF00000000000000FFFF00000000000000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000080000000800000008000000080
      0000008000000080000080808000808080008080800080808000008000000080
      0000008000000000000080808000C0C0C000000000000000000080808000FFFF
      FF00C0C0C000C0C0C00000000000000000000000000000000000C0C0C000C0C0
      C0008080800000000000000000000000000080000000FF000000FF0000000080
      800000808000008080000080800000808000008080000080800000808000FF00
      000080000000FF000000800000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000080000000000000008000000080
      0000008000000080000000800000008000000080000000800000008080000080
      800000800000008000008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF0080808000808080008080800080808000FFFFFF00FFFF
      FF0080808000000000000000000000000000FF000000FF000000FF0000000080
      800000808000FF000000FF00000080000000008080000080800000808000FF00
      0000FF00000080000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000080000000800000808080008080
      8000808080008080800000800000008000000080000000800000008000000080
      000000800000008000008080800080808000000000000000000080808000FFFF
      FF008080800080808000C0C0C00000000000FFFFFF00C0C0C000808080008080
      80008080800000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000808000008080000080800000808000008080000080
      800080000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000080000000000000000000000000
      000000000000000000000000000000800000C0C0C000C0C0C000C0C0C000C0C0
      C00000800000000000008080800000000000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000808080000000000000000000000000000000000080000000FF0000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00000000000080000000000000000000000000
      000000000000000000000000000000800000C0C0C000C0C0C000C0C0C000C0C0
      C00000800000000000008080800080808000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000808080000000000000000000000000000000000000000000008080000080
      80000080800000808000FF000000FF00000000808000FF000000008080000080
      8000FF0000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000080
      800000808000FF000000FF00000080000000FF00000080000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000000000FF00000080000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000800080008000
      8000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800080808000C0C0C000C0C0C000808080008080
      80008080800080808000000000000000000000000000FFFFFF00C0C0C0000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      000000000000C0C0C00080808000000000000000000080008000800080008000
      8000000000000000000000000000800080008000800080008000000000000000
      0000800080008000800080008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      80008080800080808000C0C0C000C0C0C000FFFFFF00FFFFFF00C0C0C0008080
      80008080800080808000808080000000000000000000FFFFFF00000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000080808000000000008000800080008000800080008000
      8000800080000000000080008000800080008000800080008000800080000000
      0000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000808080000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000C0C0C000000000000000000080808000FFFF
      FF00000000000000000080808000000000008000800080008000000000008000
      8000800080000000000080008000800080000000000080008000800080000000
      0000000000000000000080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000008080
      8000FFFFFF00FFFFFF00C0C0C000C0C0C000808080008080800080808000C0C0
      C0000000FF0000008000C0C0C0000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000C0C0C000000000000000000080808000FFFF
      FF00000000000000000080808000000000008000800080008000000000008000
      8000800080000000000080008000800080000000000080008000800080000000
      0000000000008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000C0C0C000000000000000
      00008080800080808000C0C0C0008080800080808000C0C0C000000000000000
      0000C0C0C00080808000808080000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      000000000000C0C0C00080808000000000008000800080008000000000008000
      8000800080000000000080008000800080000000000080008000800080000000
      0000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00808080000000
      00000000000000000000808080008080800080808000C0C0C000000000008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000080808000FFFFFF000000000000000000000000000000
      000000000000C0C0C00080808000000000008000800080008000000000008000
      8000800080000000000080008000800080000000000080008000800080000000
      0000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00C0C0C0008080
      80000000000000000000000000000000000080808000C0C0C000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000080808000FFFF
      FF00000000000000000080808000000000008000800080008000000000000000
      0000000000000000000080008000800080000000000080008000800080000000
      0000800080008000800080008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00C0C0C000C0C0
      C00080808000000000000000000080808000FFFFFF00C0C0C000808080000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF008080800000000000C0C0C000000000000000000080808000FFFF
      FF00000000000000000080808000000000008000800080008000000000000000
      0000000000000000000080008000800080000000000080008000800080000000
      0000800080008000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00C0C0C0008080
      8000C0C0C000C0C0C0008080800080808000FFFFFF00C0C0C000808080000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000080808000000000008000800080008000800080008000
      8000800080000000000080008000800080000000000080008000800080000000
      0000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00C0C0C000FFFF
      FF00C0C0C00000008000C0C0C00080808000FFFFFF00C0C0C000808080000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000080808000FFFFFF000000000000000000000000000000
      000000000000FFFFFF0080808000000000000000000080008000800080008000
      8000800080000000000080008000800080000000000080008000800080000000
      0000000000008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C000C0C0C0000000FF008000000080808000FFFFFF00C0C0C000808080000000
      00008080800000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00C0C0C000FF00000080808000FFFFFF00C0C0C000808080000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000000000008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000800080008000
      8000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800080808000FFFFFF00C0C0C00080808000FFFFFF00C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000000000000000000000FFFF0000FF
      FF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BFBFBF0000000000000000000000
      00000000FF00000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000000000000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00000000007F7F7F00BFBFBF007F7F7F00000000000000
      00000000000000000000000000000000FF00FFFF000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      00000000000000FFFF00000000000000000000000000FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000BFBFBF00BFBFBF00BFBFBF00000000000000
      000000000000000000000000FF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF00000000000000000000FFFF0000FFFF00000000000000000000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF000000FF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F00000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000BFBFBF00BFBFBF00BFBFBF00000000000000
      0000000000000000FF000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF000000000000FFFF00000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF007F7F7F00000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F000000000000000000BFBFBF00BFBFBF00000000000000
      00000000FF00000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F0000000000000000007F7F7F0000000000BFBF
      BF00BFBFBF00BFBFBF0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF007F7F7F0000000000000000007F7F7F00000000007F7F
      7F007F7F7F007F7F7F0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      00000000FF000000FF000000FF000000FF00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000BFBFBF0000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F000000000000000000BFBFBF0000000000BFBF
      BF00BFBFBF00BFBFBF0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF000000000000BFBFBF000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F0000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF000000000000000000BFBFBF00BFBFBF00000000000000
      00000000FF00000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000BFBFBF00BFBFBF00000000007F7F7F00BFBFBF00BFBFBF00000000000000
      0000000000000000FF000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF00000000007F7F7F007F7F7F00BFBFBF00000000000000
      000000000000000000000000FF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000FF00FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BFBFBF00000000007F7F7F0000000000000000000000
      00000000FF00000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000204000002040000020
      4000002040000020400000204000002040000020400000204000002040000020
      4000002040000020400000204000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F000000FF007F7F7F00FFFFFF00000000000000
      0000000000000000000000000000000000000020400000408000004080000020
      6000002040000040800000408000004080000020600000206000004080000040
      8000002060000020600000204000002040000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF000000FF000000FF000000FF0000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000002040000040A00040E0E00040E0
      E00000204000006060000040600040E0E00040E0E000004040000040600040E0
      E0000040400040E0E0000000000000204000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF00000000000000000000000000FFFF
      FF000000000000000000FFFFFF0000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF007F7F7F000000FF007F7F7F00FFFFFF0000FFFF00FFFF
      FF0000FFFF00000000000000000000000000002040000040800040E0E0000000
      000040E0E0000040600040E0E000004040000040600040E0E0000040400040E0
      E0000020400040E0E00000204000002040000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000004060000040800040E0E00040E0
      E000002040000040600040E0E000000000004060600000FFFF00002040000040
      600040E0E00000204000002040000020400000000000FFFFFF00FFFFFF00BFBF
      BF0000000000000000000000000000000000000000000000000000000000BFBF
      BF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF000000000000000000002040000040800000FFFF000040
      600040E0E0004040600000E0E000000000000040600040E0E0000040600000E0
      E0000040400040E0E000002040000020400000000000FFFFFF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFFFF00FFFFFF0000000000FFFFFF000000
      FF00FFFFFF00FF000000FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000FF007F7F7F0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000002040000040A00040E0E00040E0
      E00040608000406080004060800040E0E00040E0E000406080004060800040E0
      E0000040600040E0E000004060000020600000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      FF00FFFFFF00FF000000FFFFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF0000000000004060004060A000406080004060
      8000406080004080800040808000406080004060800040808000408080004060
      8000406080004060800000408000002060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FF000000FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000004060000060A000406080000020
      4000004040004080800040608000406080000020400000404000406080004060
      8000004040000040400000406000002060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF007F7F7F007F7F7F0000FFFF00FFFFFF007F7F7F000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000FFFF0000000000002040000040A00040E0E00040E0
      E00000204000006060000040600040E0E00040E0E000002040004060800040E0
      E00040E0E0000020400000204000002060000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF000000FF000000FF00FFFFFF0000FFFF007F7F7F000000FF000000FF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000004060000040800040E0E0000000
      000040E0E0000040400040E0E000004040000040600040E0E000000000004060
      60000040600040E0E00000204000002060000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000000000000000FFFFFF0000FFFF00FFFF
      FF000000FF000000FF007F7F7F00FFFFFF007F7F7F000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF000000000000000000004060000040A00040E0E0000000
      000040E0E0000020400040E0E000000000004060600040E0E000000000004060
      600040E0E0004040600000406000002060000000000000000000000000000000
      0000FFFFFF000000000000FF000000FF0000FFFF000000000000FFFFFF000000
      00000000000000000000000000000000000000000000BFBFBF00BFBFBF00FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BFBFBF00BFBFBF00000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000002040000040A00000FFFF000040
      600040E0E0000040600040E0E000000000000040600040E0E0004040600000E0
      E000002040000020400000204000002040000000000000000000000000000000
      0000FFFFFF0000000000FF00FF0000FF0000FF00FF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF000000FF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00000000000000000000000000002040000040A00000FFFF0040E0
      E000406080004080A0004060800040E0E00040E0E00040608000408080004060
      800040E0E00040E0E00000206000002060000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000004060004060A0000040A0000040
      8000004080004060A00000408000004080000040800000408000406080000040
      8000004080000040800040408000004060000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000020400000406000004060000040
      6000004060000040600000406000004060000040600000406000004060000040
      6000004060000040600000406000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFDC003FFFFFC00800DC003F83FFC00
      800CC003E00F20000001C003C00700000000C003800300000000C00380030000
      0000C003000100000000C003000100000000C003000100000000C00300010000
      0001C0030001E0000000C0038003F8000005C0038003F0000004C003C007E001
      FFFFC003E00FC403FFFFC003F83FEC078001FFFFFFFFFF0F00000000FFFFFC03
      0000FFFFFFFFF00000008E31FFFFE000000004108001E0000000249CFFFF2000
      00002498FFFF100100002490AA850C0700002490AAB5071F00003C91AAB5000F
      00003C93AAB5000F00000490868D000300008498FFFF80030000FFFFFFFFC007
      00000000FFFFE00F8001FFFFFFFFF81FFFFFFFFFFFFFC003FFFFFC7B0001C003
      FFFFF8370001C0030000F03E0001C0030000E01D1FF1C0030000E01B1DF1C003
      000080171CF1C0030000001F1C71C003000000101C31C0030000001F1C71C003
      000080171CF1C0030000E01B1DF1C0030000E01D1FF1C003FFFFF03E0001C003
      FFFFF8370001C003FFFFFC7B0001C003FFFFFFFF800080030000F83F00008003
      0000E00F0000C0070000C0070000000100008003000000010000800300000001
      00000001000000010000000100008003000000010000E00F000000010000E00F
      000000010000E00F000080030000E00F000080030000E00F0000C0070000E00F
      FFFFE00F0000E00FFFFFF83F0000E00F00000000000000000000000000000000
      000000000000}
  end
  object DosBoxTxtOpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Left = 408
    Top = 593
  end
  object SearchPopupMenu: TPopupMenu
    Images = ImageList
    Left = 376
    Top = 592
  end
  object ImageListM: TImageList
    Left = 488
    Top = 504
    Bitmap = {
      494C010103000400080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00007F7F7F007F7F7F007F7F7F0000FFFF0000FFFF007F7F7F007F7F7F007F7F
      7F007F7F7F0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007F7F7F000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007F7F7F000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007F7F7F000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007F7F7F000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF0000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF0000FFFF00FFFF00000000000000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000000000FF
      FF00000000000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      000000FFFF000000000000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF000000000000FFFF0000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      000000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FF7EFC00847F00009001FC0000EF0000
      C003200031BF0000E003000039FF0000E0030000993F0000E0030000CA1F0000
      E0030000F40F0000000100009C0700008000000096030000E0070000CB010000
      E00FE000FF800000E00FF800F7C00000E027F000FFE00000C073E001EFF00000
      9E79C403FFF800007EFEEC07FFFC000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenu: TPopupMenu
    Images = ImageListM
    Left = 456
    Top = 504
    object PopupAdd: TMenuItem
      Tag = 5
      Caption = 'Add'
      ImageIndex = 0
      ShortCut = 45
      OnClick = ButtonWork
    end
    object PopupEdit: TMenuItem
      Tag = 6
      Caption = 'Edit'
      Default = True
      ImageIndex = 1
      OnClick = ButtonWork
    end
    object PopupDelete: TMenuItem
      Tag = 7
      Caption = 'Delete'
      ImageIndex = 2
      ShortCut = 46
      OnClick = ButtonWork
    end
  end
end
