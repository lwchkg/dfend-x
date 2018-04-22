object DOSBoxLangStartForm: TDOSBoxLangStartForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DOSBoxLangStartForm'
  ClientHeight = 245
  ClientWidth = 321
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    321
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object NewFileLabel: TLabel
    Left = 32
    Top = 83
    Width = 128
    Height = 13
    Caption = 'Language file to copy from'
  end
  object NewFileRadioButton: TRadioButton
    Left = 8
    Top = 8
    Width = 303
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Start new DOSBox language file'
    TabOrder = 0
  end
  object NewFileComboBox: TComboBox
    Left = 32
    Top = 98
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = NewFileEditChange
  end
  object EditFileRadioButton: TRadioButton
    Left = 8
    Top = 144
    Width = 303
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Edit existing language file'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object EditFileComboBox: TComboBox
    Left = 32
    Top = 167
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = EditFileComboBoxChange
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 212
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 110
    Top = 212
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    Kind = bkCancel
  end
  object NewFileEdit: TLabeledEdit
    Left = 32
    Top = 48
    Width = 145
    Height = 21
    EditLabel.Width = 139
    EditLabel.Height = 13
    EditLabel.Caption = 'Filename (without extension)'
    TabOrder = 1
    OnChange = NewFileEditChange
  end
  object HelpButton: TBitBtn
    Left = 213
    Top = 212
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 7
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
