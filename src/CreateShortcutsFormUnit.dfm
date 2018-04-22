object CreateShortcutsForm: TCreateShortcutsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CreateShortcutsForm'
  ClientHeight = 476
  ClientWidth = 417
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 16
    Top = 8
    Width = 45
    Height = 13
    Caption = 'InfoLabel'
  end
  object SelectFolderButton: TSpeedButton
    Left = 386
    Top = 346
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    Visible = False
    OnClick = SelectFolderButtonClick
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 445
    Width = 97
    Height = 25
    TabOrder = 9
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 128
    Top = 447
    Width = 97
    Height = 25
    TabOrder = 10
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 240
    Top = 447
    Width = 97
    Height = 25
    TabOrder = 11
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object UseProfileIconCheckBox: TCheckBox
    Left = 16
    Top = 409
    Width = 209
    Height = 17
    Caption = 'UseProfileIconCheckBox'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object StartmenuEdit: TEdit
    Left = 40
    Top = 382
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'Dosgames'
    OnChange = StartmenuEditChange
  end
  object StartmenuRadioButton: TRadioButton
    Left = 16
    Top = 363
    Width = 209
    Height = 17
    Caption = 'StartmenuRadioButton'
    TabOrder = 5
  end
  object DesktopRadioButton: TRadioButton
    Left = 16
    Top = 340
    Width = 209
    Height = 17
    Caption = 'DesktopRadioButton'
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object ListBox: TCheckListBox
    Left = 16
    Top = 24
    Width = 393
    Height = 272
    ItemHeight = 13
    TabOrder = 0
  end
  object SelectAllButton: TBitBtn
    Left = 16
    Top = 305
    Width = 107
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 1
    OnClick = SelectButtonClick
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 129
    Top = 305
    Width = 107
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object SelectGenreButton: TBitBtn
    Tag = 2
    Left = 242
    Top = 305
    Width = 107
    Height = 25
    Caption = 'By ...'
    TabOrder = 3
    OnClick = SelectButtonClick
  end
  object FolderEdit: TLabeledEdit
    Left = 16
    Top = 347
    Width = 364
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'FolderEdit'
    TabOrder = 8
    Visible = False
  end
  object PopupMenu: TPopupMenu
    Left = 360
    Top = 304
  end
end
