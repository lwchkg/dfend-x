object SelectCDDriveToMountForm: TSelectCDDriveToMountForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectCDDriveToMountForm'
  ClientHeight = 149
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    459
    149)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 47
    Width = 443
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object StartLabel1: TLabel
    Left = 8
    Top = 8
    Width = 55
    Height = 13
    Caption = 'StartLabel1'
  end
  object StartLabel2: TLabel
    Left = 8
    Top = 24
    Width = 55
    Height = 13
    Caption = 'StartLabel2'
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 119
    Width = 97
    Height = 25
    TabOrder = 0
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 119
    Width = 97
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object DriveComboBox: TComboBox
    Left = 8
    Top = 82
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
end
