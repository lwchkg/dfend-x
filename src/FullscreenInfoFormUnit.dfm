object FullscreenInfoForm: TFullscreenInfoForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FullscreenInfoForm'
  ClientHeight = 123
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    427
    123)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 12
    Width = 411
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'You can close DOSBox at any time by pressing Ctrl+F9.'
    WordWrap = True
  end
  object CheckBox: TCheckBox
    Left = 8
    Top = 64
    Width = 411
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Do not show this information again'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 90
    Width = 89
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
end
