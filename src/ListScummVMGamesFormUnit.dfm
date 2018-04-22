object ListScummVMGamesForm: TListScummVMGamesForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'ListScummVMGamesForm'
  ClientHeight = 485
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TListBox
    Left = 0
    Top = 0
    Width = 409
    Height = 451
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 451
    Width = 409
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object CloseButton: TBitBtn
      Left = 4
      Top = 4
      Width = 97
      Height = 27
      TabOrder = 0
      Kind = bkClose
    end
  end
end
