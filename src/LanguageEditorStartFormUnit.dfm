object LanguageEditorStartForm: TLanguageEditorStartForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Language editor'
  ClientHeight = 131
  ClientWidth = 337
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
  PixelsPerInch = 96
  TextHeight = 13
  object EditThisRadioButton: TRadioButton
    Left = 24
    Top = 24
    Width = 305
    Height = 17
    Caption = 'Edit this language'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object EditNewRadioButton: TRadioButton
    Left = 24
    Top = 56
    Width = 154
    Height = 17
    Caption = 'Start new language'
    TabOrder = 1
  end
  object LanguageNameEdit: TEdit
    Left = 184
    Top = 54
    Width = 145
    Height = 21
    TabOrder = 2
    OnChange = LanguageNameEditChange
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 98
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 98
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 98
    Width = 97
    Height = 25
    TabOrder = 5
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
