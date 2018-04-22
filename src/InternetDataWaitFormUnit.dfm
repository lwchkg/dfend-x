object InternetDataWaitForm: TInternetDataWaitForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Reciving data'
  ClientHeight = 72
  ClientWidth = 338
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
    Left = 94
    Top = 8
    Width = 227
    Height = 50
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object Animate: TAnimate
    Left = 8
    Top = 8
    Width = 80
    Height = 50
    Active = True
    CommonAVI = aviFindFolder
    StopFrame = 27
    Timers = True
  end
  object Timer: TTimer
    Interval = 50
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
end
