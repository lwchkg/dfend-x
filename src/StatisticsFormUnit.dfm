object StatisticsForm: TStatisticsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Statistik'
  ClientHeight = 516
  ClientWidth = 394
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
  object Panel1: TPanel
    Left = 0
    Top = 478
    Width = 394
    Height = 38
    Align = alBottom
    TabOrder = 0
    object OKButton: TBitBtn
      Left = 8
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object HelpButton: TBitBtn
      Left = 120
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 1
      OnClick = HelpButtonClick
      Kind = bkHelp
    end
  end
  object Memo: TRichEdit
    Left = 0
    Top = 0
    Width = 394
    Height = 478
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
end
