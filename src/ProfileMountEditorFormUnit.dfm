object ProfileMountEditorForm: TProfileMountEditorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ProfileMountEditorForm'
  ClientHeight = 372
  ClientWidth = 744
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
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TPanel
    Left = 0
    Top = 31
    Width = 744
    Height = 309
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 744
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object TypeLabel: TLabel
      Left = 16
      Top = 12
      Width = 28
      Height = 13
      Caption = 'Type:'
    end
    object TypeComboBox: TComboBox
      Left = 63
      Top = 7
      Width = 202
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
      OnChange = TypeComboBoxChange
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 340
    Width = 744
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object OKButton: TBitBtn
      Left = 16
      Top = 2
      Width = 97
      Height = 25
      TabOrder = 0
      OnClick = OKButtonClick
      Kind = bkOK
    end
    object CancelButton: TBitBtn
      Left = 127
      Top = 2
      Width = 97
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
    object HelpButton: TBitBtn
      Left = 239
      Top = 2
      Width = 97
      Height = 25
      TabOrder = 2
      OnClick = HelpButtonClick
      Kind = bkHelp
    end
  end
end
