object UninstallSelectForm: TUninstallSelectForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Programme deinstallieren'
  ClientHeight = 503
  ClientWidth = 439
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
    Left = 8
    Top = 8
    Width = 272
    Height = 13
    Caption = 'Bitte w'#228'hlen Sie die zu deinstallierenden Programme aus:'
  end
  object ActionsRadioGroup: TRadioGroup
    Left = 8
    Top = 352
    Width = 423
    Height = 105
    Caption = 'Aktionen'
    ItemIndex = 2
    Items.Strings = (
      'Nur Profi-Listen Eintrag l'#246'schen'
      'Profil-Listen Eintrag und Programmverzeichnis l'#246'schen'
      
        'Profil-Listen Eintrag und alle Programmdatenverzeichnisse l'#246'sche' +
        'n'
      'F'#252'r jeden Eintrag einzelen ausw'#228'hlen')
    TabOrder = 4
  end
  object ListBox: TCheckListBox
    Left = 8
    Top = 27
    Width = 423
    Height = 270
    ItemHeight = 13
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 470
    Width = 97
    Height = 25
    TabOrder = 5
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 470
    Width = 97
    Height = 25
    TabOrder = 6
    Kind = bkCancel
  end
  object SelectAllButton: TBitBtn
    Left = 8
    Top = 303
    Width = 107
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 1
    OnClick = SelectButtonClick
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 127
    Top = 303
    Width = 107
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object SelectGenreButton: TBitBtn
    Tag = 2
    Left = 246
    Top = 303
    Width = 107
    Height = 25
    Caption = 'By ...'
    TabOrder = 3
    OnClick = SelectButtonClick
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 470
    Width = 97
    Height = 25
    TabOrder = 7
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object PopupMenu: TPopupMenu
    Left = 256
    Top = 440
  end
end
