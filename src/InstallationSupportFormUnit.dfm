object InstallationSupportForm: TInstallationSupportForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Install game from source media'
  ClientHeight = 355
  ClientWidth = 528
  Color = clBtnFace
  Constraints.MinHeight = 325
  Constraints.MinWidth = 510
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    528
    355)
  PixelsPerInch = 96
  TextHeight = 13
  object AddButton: TSpeedButton
    Left = 496
    Top = 43
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
    OnClick = ButtonWork
    ExplicitLeft = 287
  end
  object DelButton: TSpeedButton
    Tag = 1
    Left = 496
    Top = 71
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
    OnClick = ButtonWork
    ExplicitLeft = 287
  end
  object DropInfoLabel: TLabel
    Left = 8
    Top = 232
    Width = 511
    Height = 41
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'You can also drag&&drop ... here.'
    WordWrap = True
    ExplicitTop = 223
  end
  object UpButton: TSpeedButton
    Tag = 2
    Left = 497
    Top = 99
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
      3333333333777F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
      3333333777737777F333333099999990333333373F3333373333333309999903
      333333337F33337F33333333099999033333333373F333733333333330999033
      3333333337F337F3333333333099903333333333373F37333333333333090333
      33333333337F7F33333333333309033333333333337373333333333333303333
      333333333337F333333333333330333333333333333733333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
    ExplicitLeft = 288
  end
  object DownButton: TSpeedButton
    Tag = 3
    Left = 497
    Top = 127
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
      333333333337F33333333333333033333333333333373F333333333333090333
      33333333337F7F33333333333309033333333333337373F33333333330999033
      3333333337F337F33333333330999033333333333733373F3333333309999903
      333333337F33337F33333333099999033333333373333373F333333099999990
      33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333300033333333333337773333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
    ExplicitLeft = 288
  end
  object InsertMediaLabel: TLabel
    Left = 8
    Top = 43
    Width = 482
    Height = 58
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InsertMediaLabel'
    WordWrap = True
    ExplicitWidth = 461
  end
  object CDImageTypeLabel: TLabel
    Left = 8
    Top = 155
    Width = 483
    Height = 62
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Only ISO and CUE/BIN images supported.'
    Visible = False
    WordWrap = True
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 326
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    OnClick = OKButtonClick
    Kind = bkOK
    ExplicitTop = 298
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 326
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Kind = bkCancel
    ExplicitTop = 298
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 326
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    OnClick = HelpButtonClick
    Kind = bkHelp
    ExplicitTop = 298
  end
  object InstallTypeComboBox: TComboBox
    Left = 8
    Top = 8
    Width = 512
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = InstallTypeComboBoxChange
  end
  object ListBox: TListBox
    Left = 8
    Top = 35
    Width = 482
    Height = 114
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxClick
    OnDragDrop = ListBoxDragDrop
    OnKeyDown = ListBoxKeyDown
  end
  object AlwaysMountSourceCheckBox: TCheckBox
    Left = 8
    Top = 275
    Width = 512
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Make CD image available when running the game.'
    Checked = True
    State = cbChecked
    TabOrder = 2
    ExplicitTop = 247
  end
  object AlwaysMountSourceComboBox: TComboBox
    Left = 23
    Top = 292
    Width = 497
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 6
    ExplicitTop = 264
  end
  object OpenDialog: TOpenDialog
    Left = 16
    Top = 48
  end
end
