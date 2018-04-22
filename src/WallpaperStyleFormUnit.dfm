object WallpaperStyleForm: TWallpaperStyleForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'WallpaperStyleForm'
  ClientHeight = 143
  ClientWidth = 308
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
  object TileRadioButton: TRadioButton
    Left = 16
    Top = 24
    Width = 281
    Height = 17
    Caption = 'TileRadioButton'
    TabOrder = 0
  end
  object CenterRadioButton: TRadioButton
    Left = 16
    Top = 47
    Width = 281
    Height = 17
    Caption = 'CenterRadioButton'
    TabOrder = 1
  end
  object StretchRadioButton: TRadioButton
    Left = 16
    Top = 70
    Width = 281
    Height = 17
    Caption = 'StretchRadioButton'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 106
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 106
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
end
