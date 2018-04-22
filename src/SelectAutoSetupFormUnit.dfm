object SelectAutoSetupForm: TSelectAutoSetupForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Select auto setup template'
  ClientHeight = 385
  ClientWidth = 335
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
    335
    385)
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TBitBtn
    Left = 8
    Top = 358
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 358
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkCancel
  end
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 319
    Height = 344
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 2
  end
end
