object WindowsFileWarningForm: TWindowsFileWarningForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'WindowsFileWarningForm'
  ClientHeight = 122
  ClientWidth = 437
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
  DesignSize = (
    437
    122)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 421
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 94
    Width = 97
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object TurnOffWarningsCheckBox: TCheckBox
    Left = 8
    Top = 71
    Width = 421
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Turn off warnings for this profile.'
    TabOrder = 1
  end
end
