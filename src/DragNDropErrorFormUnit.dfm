object DragNDropErrorForm: TDragNDropErrorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DragNDropErrorForm'
  ClientHeight = 329
  ClientWidth = 645
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
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 322
    Height = 13
    Caption = 
      'The following errors occured while trying to import the droped f' +
      'iles:'
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 298
    Width = 89
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object ErrorListBox: TMemo
    Left = 8
    Top = 39
    Width = 629
    Height = 253
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
end
