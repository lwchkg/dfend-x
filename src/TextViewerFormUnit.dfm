object TextViewerForm: TTextViewerForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'TextViewerForm'
  ClientHeight = 508
  ClientWidth = 578
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 474
    Width = 578
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object CloseButton: TBitBtn
      Left = 4
      Top = 4
      Width = 97
      Height = 27
      TabOrder = 0
      Kind = bkClose
    end
  end
  object Memo: TRichEdit
    Left = 0
    Top = 0
    Width = 578
    Height = 474
    Align = alClient
    ReadOnly = True
    TabOrder = 1
  end
end
