object MiniRunForm: TMiniRunForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'MiniRunForm'
  ClientHeight = 299
  ClientWidth = 313
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = NameEditKeyUp
  OnShow = FormShow
  DesignSize = (
    313
    299)
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TBitBtn
    Left = 8
    Top = 266
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 266
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
  object ListBox: TListBox
    Left = 8
    Top = 35
    Width = 297
    Height = 214
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = OKButtonClick
    OnKeyUp = NameEditKeyUp
  end
  object NameEdit: TEdit
    Left = 8
    Top = 8
    Width = 297
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnKeyUp = NameEditKeyUp
  end
end
