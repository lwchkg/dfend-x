object CreateShortcutForm: TCreateShortcutForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CreateShortcut'
  ClientHeight = 286
  ClientWidth = 338
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
  object DesktopRadioButton: TRadioButton
    Left = 16
    Top = 120
    Width = 209
    Height = 17
    Caption = 'DesktopRadioButton'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object StartmenuRadioButton: TRadioButton
    Left = 16
    Top = 152
    Width = 209
    Height = 17
    Caption = 'StartmenuRadioButton'
    TabOrder = 3
  end
  object StartmenuEdit: TEdit
    Left = 40
    Top = 175
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Dosgames'
    OnChange = StartmenuEditChange
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 251
    Width = 97
    Height = 25
    TabOrder = 6
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 253
    Width = 97
    Height = 25
    TabOrder = 7
    Kind = bkCancel
  end
  object UseProfileIconCheckBox: TCheckBox
    Left = 16
    Top = 216
    Width = 209
    Height = 17
    Caption = 'UseProfileIconCheckBox'
    TabOrder = 5
  end
  object LinkNameEdit: TLabeledEdit
    Left = 16
    Top = 24
    Width = 305
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'LinkNameEdit'
    TabOrder = 0
  end
  object LinkCommentEdit: TLabeledEdit
    Left = 16
    Top = 69
    Width = 305
    Height = 21
    EditLabel.Width = 81
    EditLabel.Height = 13
    EditLabel.Caption = 'LinkCommentEdit'
    TabOrder = 1
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 253
    Width = 97
    Height = 25
    TabOrder = 8
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
