object ImportSelectTemplateForm: TImportSelectTemplateForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ImportSelectTemplateForm'
  ClientHeight = 144
  ClientWidth = 319
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
  DesignSize = (
    319
    144)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 303
    Height = 58
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'There are multiple matching auto setup template for the game. Pl' +
      'ease  select which template should be used when adding the game.'
    WordWrap = True
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 115
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 110
    Top = 115
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkCancel
  end
  object ComboBox: TComboBox
    Left = 8
    Top = 80
    Width = 303
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
  end
end
