object CheatDBInternalPrivateerPositionForm: TCheatDBInternalPrivateerPositionForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Privateer position'
  ClientHeight = 101
  ClientWidth = 302
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
    302
    101)
  PixelsPerInch = 96
  TextHeight = 13
  object PositionLabel: TLabel
    Left = 16
    Top = 16
    Width = 37
    Height = 13
    Caption = 'Position'
  end
  object PositionComboBox: TComboBox
    Left = 16
    Top = 35
    Width = 273
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 68
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 118
    Top = 68
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
end
