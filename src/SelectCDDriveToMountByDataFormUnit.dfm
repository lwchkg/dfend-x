object SelectCDDriveToMountByDataForm: TSelectCDDriveToMountByDataForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectCDDriveToMountByDataForm'
  ClientHeight = 148
  ClientWidth = 416
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
    416
    148)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 51
    Width = 400
    Height = 49
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
  object CancelButton: TBitBtn
    Left = 151
    Top = 115
    Width = 97
    Height = 25
    TabOrder = 0
    Kind = bkCancel
  end
  object Timer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerTimer
    Left = 256
    Top = 111
  end
end
