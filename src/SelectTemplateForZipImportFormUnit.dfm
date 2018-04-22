object SelectTemplateForZipImportForm: TSelectTemplateForZipImportForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectTemplateForZipImportForm'
  ClientHeight = 288
  ClientWidth = 556
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
  OnShow = FormShow
  DesignSize = (
    556
    288)
  PixelsPerInch = 96
  TextHeight = 13
  object TemplateLabel: TLabel
    Left = 16
    Top = 189
    Width = 77
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Template to use'
    ExplicitTop = 192
  end
  object ProgramFileLabel: TLabel
    Left = 310
    Top = 189
    Width = 57
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Program file'
    ExplicitLeft = 240
    ExplicitTop = 192
  end
  object SetupFileLabel: TLabel
    Left = 438
    Top = 189
    Width = 45
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Setup file'
    ExplicitLeft = 368
    ExplicitTop = 192
  end
  object WarningLabel: TLabel
    Left = 223
    Top = 76
    Width = 77
    Height = 13
    Caption = 'Already existing'
    Visible = False
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 255
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 8
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 119
    Top = 255
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 9
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 464
    Top = 255
    Width = 84
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 11
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object TemplateType1RadioButton: TRadioButton
    Left = 16
    Top = 109
    Width = 530
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Matching auto setup template'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = TypeSelectClick
  end
  object TemplateType2RadioButton: TRadioButton
    Left = 16
    Top = 132
    Width = 530
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Auto setup template'
    TabOrder = 3
    OnClick = TypeSelectClick
  end
  object TemplateType3RadioButton: TRadioButton
    Left = 16
    Top = 155
    Width = 530
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'User template'
    TabOrder = 4
    OnClick = TypeSelectClick
  end
  object ProfileNameEdit: TLabeledEdit
    Left = 16
    Top = 24
    Width = 530
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 59
    EditLabel.Height = 13
    EditLabel.Caption = 'Profile name'
    TabOrder = 0
    OnChange = ProfileNameEditChange
  end
  object TemplateComboBox: TComboBox
    Left = 16
    Top = 208
    Width = 271
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 5
    OnChange = TemplateComboBoxChange
    OnDropDown = ComboBoxDropDown
  end
  object ProgramFileComboBox: TComboBox
    Left = 310
    Top = 208
    Width = 108
    Height = 21
    Style = csDropDownList
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 6
    OnDropDown = ComboBoxDropDown
  end
  object FolderEdit: TLabeledEdit
    Left = 16
    Top = 74
    Width = 201
    Height = 21
    EditLabel.Width = 99
    EditLabel.Height = 13
    EditLabel.Caption = 'Folder for new game'
    TabOrder = 1
    OnChange = FolderEditChange
  end
  object SetupFileComboBox: TComboBox
    Left = 438
    Top = 208
    Width = 108
    Height = 21
    Style = csDropDownList
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 7
    OnDropDown = ComboBoxDropDown
  end
  object InstallSupportButton: TBitBtn
    Left = 222
    Top = 255
    Width = 236
    Height = 25
    Caption = 'Use installation support'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = InstallSupportButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
      00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
      00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
      00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
      00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
      00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
      00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
      0003737FFFFFFFFF7F7330099999999900333777777777777733}
    NumGlyphs = 2
  end
end
