object CopyProfileForm: TCopyProfileForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Copy profile'
  ClientHeight = 168
  ClientWidth = 411
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
  object NameEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 377
    Height = 21
    EditLabel.Width = 45
    EditLabel.Height = 13
    EditLabel.Caption = 'NameEdit'
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 134
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 127
    Top = 134
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object UpdateScreenshotFolderCheckBox: TCheckBox
    Left = 16
    Top = 72
    Width = 377
    Height = 17
    Caption = 'Set new screenshot folder'
    TabOrder = 1
  end
  object RemoveDataFolderRecordCheckBox: TCheckBox
    Left = 16
    Top = 95
    Width = 369
    Height = 17
    Caption = 'Remove extra data folder record'
    TabOrder = 2
  end
  object HelpButton: TBitBtn
    Left = 239
    Top = 135
    Width = 97
    Height = 25
    TabOrder = 5
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
