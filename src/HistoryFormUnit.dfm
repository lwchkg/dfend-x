object HistoryForm: THistoryForm
  Left = 0
  Top = 0
  Caption = 'Verlauf'
  ClientHeight = 464
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    684
    464)
  PixelsPerInch = 96
  TextHeight = 13
  object CloseButton: TBitBtn
    Left = 8
    Top = 434
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Schlie'#223'en'
    ModalResult = 1
    TabOrder = 0
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
  end
  object ClearButton: TBitBtn
    Left = 111
    Top = 434
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&L'#246'schen'
    ModalResult = 1
    TabOrder = 1
    OnClick = ClearButtonClick
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
  object HelpButton: TBitBtn
    Left = 214
    Top = 434
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 684
    Height = 428
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Verlauf'
      object ListView: TListView
        Left = 0
        Top = 0
        Width = 676
        Height = 400
        Align = alClient
        BorderStyle = bsNone
        Columns = <>
        ReadOnly = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Statistik'
      ImageIndex = 1
      object ListView2: TListView
        Left = 0
        Top = 0
        Width = 676
        Height = 400
        Align = alClient
        BorderStyle = bsNone
        Columns = <>
        ReadOnly = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
    end
  end
end
