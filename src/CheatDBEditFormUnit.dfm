object CheatDBEditForm: TCheatDBEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit cheats data base'
  ClientHeight = 394
  ClientWidth = 712
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
  DesignSize = (
    712
    394)
  PixelsPerInch = 96
  TextHeight = 13
  object GameLabel: TLabel
    Left = 8
    Top = 11
    Width = 56
    Height = 13
    Caption = 'Game name'
  end
  object GameAddButton: TSpeedButton
    Left = 239
    Top = 25
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object GameEditButton: TSpeedButton
    Tag = 1
    Left = 264
    Top = 25
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
  object GameDeleteButton: TSpeedButton
    Tag = 2
    Left = 289
    Top = 25
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object ActionLabel: TLabel
    Left = 337
    Top = 11
    Width = 30
    Height = 13
    Caption = 'Action'
  end
  object ActionAddButton: TSpeedButton
    Tag = 3
    Left = 615
    Top = 26
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object ActionEditButton: TSpeedButton
    Tag = 4
    Left = 640
    Top = 26
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
  object ActionDeleteButton: TSpeedButton
    Tag = 5
    Left = 665
    Top = 26
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object ActionStepLabel: TLabel
    Left = 336
    Top = 56
    Width = 134
    Height = 13
    Caption = 'Steps of the selected action'
  end
  object ActionStepAddButton: TSpeedButton
    Tag = 6
    Left = 615
    Top = 71
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object ActionStepDeleteButton: TSpeedButton
    Tag = 7
    Left = 665
    Top = 71
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object Bevel1: TBevel
    Left = -2
    Top = 89
    Width = 715
    Height = 15
    Shape = bsBottomLine
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 361
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 110
    Top = 361
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 212
    Top = 361
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 7
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object GameComboBox: TComboBox
    Left = 8
    Top = 26
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = GameComboBoxChange
  end
  object ActionComboBox: TComboBox
    Left = 337
    Top = 26
    Width = 272
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ActionComboBoxChange
  end
  object FileMaskEdit: TLabeledEdit
    Left = 8
    Top = 72
    Width = 225
    Height = 21
    EditLabel.Width = 154
    EditLabel.Height = 13
    EditLabel.Caption = 'File mask for the selected action'
    TabOrder = 2
  end
  object ActionStepComboBox: TComboBox
    Left = 336
    Top = 72
    Width = 273
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = ActionStepComboBoxChange
    OnDropDown = ActionStepComboBoxDropDown
  end
  object Notebook: TNotebook
    Left = 8
    Top = 110
    Width = 696
    Height = 251
    PageIndex = 1
    TabOrder = 4
    object TPage
      Left = 0
      Top = 0
      Caption = 'ChangeAddress'
      object ChangeAddressBytesLabel: TLabel
        Left = 272
        Top = 88
        Width = 67
        Height = 13
        Caption = 'Bytes to write'
      end
      object ChangeAddressAddressLabel: TLabel
        Left = 4
        Top = 51
        Width = 352
        Height = 31
        AutoSize = False
        Caption = 
          '(Negative addresses mean seeking from file end. -1 is the addres' +
          's of the last byte in file.)'
        WordWrap = True
      end
      object ChangeAddressInfoLabel: TLabel
        Left = 4
        Top = 131
        Width = 352
        Height = 54
        AutoSize = False
        Caption = 
          'You can enter addresses and values in decimal or hexadezimal. He' +
          'xadecimal values have to start with a "$" sign.'
        WordWrap = True
      end
      object ChangeAddressAddressEdit: TLabeledEdit
        Left = 4
        Top = 24
        Width = 352
        Height = 21
        EditLabel.Width = 342
        EditLabel.Height = 13
        EditLabel.Caption = 
          'Addresses to change (multiple values can be separated by ";" or ' +
          'by ",")'
        TabOrder = 0
      end
      object ChangeAddressNewValueEdit: TLabeledEdit
        Left = 4
        Top = 104
        Width = 253
        Height = 21
        EditLabel.Width = 50
        EditLabel.Height = 13
        EditLabel.Caption = 'New value'
        TabOrder = 1
      end
      object ChangeAddressBytesComboBox: TComboBox
        Left = 272
        Top = 104
        Width = 84
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 2
        Text = '4'
        Items.Strings = (
          '1'
          '2'
          '4')
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'ChangeAddressWithDialog'
      object ChangeAddressWithDialogBytesLabel: TLabel
        Left = 272
        Top = 160
        Width = 67
        Height = 13
        Caption = 'Bytes to write'
      end
      object ChangeAddressWithDialogInfoLabel: TLabel
        Left = 8
        Top = 200
        Width = 351
        Height = 50
        AutoSize = False
        Caption = 
          '(You can leave the minimal and the maximal value field blank if ' +
          'there is no minimal or maximal value.)'
        WordWrap = True
      end
      object ChangeAddressWithDialogAddressLabel: TLabel
        Left = 4
        Top = 48
        Width = 352
        Height = 33
        AutoSize = False
        Caption = 
          '(Negative addresses mean seeking from file end. -1 is the addres' +
          's of the last byte in file.)'
        WordWrap = True
      end
      object ChangeAddressWithDialogInfoLabel2: TLabel
        Left = 384
        Top = 91
        Width = 281
        Height = 62
        AutoSize = False
        Caption = 
          'You can enter addresses and values in decimal or hexadezimal. He' +
          'xadecimal values have to start with a "$" sign.'
        WordWrap = True
      end
      object ChangeAddressWithDialogAddressEdit: TLabeledEdit
        Left = 4
        Top = 24
        Width = 352
        Height = 21
        EditLabel.Width = 342
        EditLabel.Height = 13
        EditLabel.Caption = 
          'Addresses to change (multiple values can be separated by ";" or ' +
          'by ",")'
        TabOrder = 0
      end
      object ChangeAddressWithDialogDefaultAddressRadioButton: TRadioButton
        Left = 8
        Top = 95
        Width = 234
        Height = 17
        Caption = 'Read default value from address'
        TabOrder = 1
      end
      object ChangeAddressWithDialogDefaultFixedRadioButton: TRadioButton
        Left = 8
        Top = 122
        Width = 234
        Height = 17
        Caption = 'Fixed default value'
        Checked = True
        TabOrder = 3
        TabStop = True
      end
      object ChangeAddressWithDialogDefaultAddressEdit: TEdit
        Left = 248
        Top = 91
        Width = 108
        Height = 21
        TabOrder = 2
        OnChange = ChangeAddressWithDialogDefaultEditChange
      end
      object ChangeAddressWithDialogDefaultFixedEdit: TEdit
        Left = 248
        Top = 118
        Width = 108
        Height = 21
        TabOrder = 4
        OnChange = ChangeAddressWithDialogDefaultEditChange
      end
      object ChangeAddressWithDialogPromptEdit: TLabeledEdit
        Left = 384
        Top = 24
        Width = 281
        Height = 21
        EditLabel.Width = 66
        EditLabel.Height = 13
        EditLabel.Caption = 'Dialog prompt'
        TabOrder = 5
      end
      object ChangeAddressWithDialogMinValueEdit: TLabeledEdit
        Left = 8
        Top = 176
        Width = 108
        Height = 21
        EditLabel.Width = 63
        EditLabel.Height = 13
        EditLabel.Caption = 'Minimal value'
        TabOrder = 6
      end
      object ChangeAddressWithDialogMaxValueEdit: TLabeledEdit
        Left = 124
        Top = 176
        Width = 108
        Height = 21
        EditLabel.Width = 67
        EditLabel.Height = 13
        EditLabel.Caption = 'Maximal value'
        TabOrder = 7
      end
      object ChangeAddressWithDialogBytesComboBox: TComboBox
        Left = 272
        Top = 176
        Width = 84
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 8
        Text = '4'
        Items.Strings = (
          '1'
          '2'
          '4')
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Internal'
      object InternalLabel: TLabel
        Left = 4
        Top = 8
        Width = 110
        Height = 13
        Caption = 'Internal cheat to apply'
      end
      object InternalEdit: TSpinEdit
        Left = 4
        Top = 24
        Width = 77
        Height = 22
        MaxValue = 99
        MinValue = 1
        TabOrder = 0
        Value = 1
      end
    end
  end
  object UpdateButton: TBitBtn
    Left = 315
    Top = 361
    Width = 185
    Height = 25
    Caption = 'Search for updates now'
    TabOrder = 8
    OnClick = UpdateButtonClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0010992000D26C1000D26C1000D26C
      1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF001099200010992000A3D6A700A3D6A700E3B79400E3B7
      9400D26C1000D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000B1E7BC00B1E7BC00109920004AB25A00D26C1000C55E
      0A00E3B79400E3B79400D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000BCEDD3005CCC8B004AB25A004AB25A00D26C1000C55E
      0A00C55E0A00E3B79400D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0010992000BCEDD3008CD49B004AB25A00E9A04100E9A04100E9A04100D26C
      1000D26C100010992000A3D6A700D26C1000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000E9A04100E3B79400E9A04100E9A04100E9A041004AB2
      5A004AB25A004AB25A00A3D6A70010992000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000E9A041008CD49B00E9A04100E9A04100E9A041005CCC
      8B005CCC8B004AB25A00A3D6A70010992000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000BCEDD300BCEDD3008CD49B00FAEBD000FAEBD0004AB2
      5A005CCC8B005CCC8B00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00D26C1000E6F7EC00BCEDD300E6F7EC00458F6300458F6300E6F7
      EC004AB25A00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000E6F7EC00FF00FF00458F63005CCC8B004AB25A00458F
      6300E6F7EC00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B005CCC8B005CCC8B005CCC
      8B00458F6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00458F6300458F6300458F63005CCC8B005CCC8B00458F
      6300458F6300458F6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B005CCC8B00458F
      6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B004AB25A00458F
      6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
  end
  object AddActionStepPopupMenu: TPopupMenu
    Left = 656
    Top = 37
    object AddActionStepPopupChangeAddress: TMenuItem
      Tag = 8
      Caption = 'Change value at address'
      OnClick = ButtonWork
    end
    object AddActionStepPopupChangeAddressWithDialog: TMenuItem
      Tag = 9
      Caption = 'Change value at address with dialog'
      OnClick = ButtonWork
    end
  end
end
