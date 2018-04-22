object RenameAllScreenshotsForm: TRenameAllScreenshotsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RenameAllScreenshotsForm'
  ClientHeight = 204
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 415
    Height = 49
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object Edit: TEdit
    Left = 8
    Top = 72
    Width = 415
    Height = 21
    TabOrder = 0
    Text = 'Edit'
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 174
    Width = 97
    Height = 25
    TabOrder = 3
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 174
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object ThisProfileRadioButton: TRadioButton
    Left = 8
    Top = 113
    Width = 415
    Height = 17
    Caption = 'Rename all files in the selected profile'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object AllProfilesRadioButton: TRadioButton
    Left = 8
    Top = 136
    Width = 415
    Height = 17
    Caption = 'Rename all files in all profiles'
    TabOrder = 2
  end
end
