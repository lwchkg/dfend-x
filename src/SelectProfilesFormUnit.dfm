object SelectProfilesForm: TSelectProfilesForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectProfilesForm'
  ClientHeight = 491
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TCheckListBox
    Left = 8
    Top = 8
    Width = 423
    Height = 406
    ItemHeight = 13
    TabOrder = 0
  end
  object SelectAllButton: TBitBtn
    Left = 8
    Top = 420
    Width = 107
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 1
    OnClick = SelectButtonClick
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 127
    Top = 420
    Width = 107
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object SelectGenreButton: TBitBtn
    Tag = 2
    Left = 246
    Top = 420
    Width = 107
    Height = 25
    Caption = 'By ...'
    TabOrder = 3
    OnClick = SelectButtonClick
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 459
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 459
    Width = 97
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object PopupMenu: TPopupMenu
    Left = 232
    Top = 461
  end
end
