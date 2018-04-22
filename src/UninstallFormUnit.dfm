object UninstallForm: TUninstallForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Uninstall program'
  ClientHeight = 277
  ClientWidth = 684
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
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TCheckListBox
    Left = 0
    Top = 81
    Width = 684
    Height = 162
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      684
      81)
    object InfoLabel: TLabel
      Left = 8
      Top = 62
      Width = 201
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Please select the components to uninstall:'
    end
    object DeleteRadioButton: TRadioButton
      Left = 8
      Top = 9
      Width = 665
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Only remove profile, keep game files'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButtonWork
    end
    object UninstallRadioButton: TRadioButton
      Left = 8
      Top = 32
      Width = 665
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Uninstall selected components'
      TabOrder = 1
      OnClick = RadioButtonWork
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 243
    Width = 684
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object OKButton: TBitBtn
      Left = 8
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 0
      OnClick = OKButtonClick
      Kind = bkOK
    end
    object CancelButton: TBitBtn
      Left = 111
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
    object SelectAllButton: TBitBtn
      Left = 317
      Top = 6
      Width = 97
      Height = 25
      Caption = 'SelectAllButton'
      TabOrder = 3
      OnClick = SelectButtonClick
    end
    object SelectNoneButton: TBitBtn
      Tag = 1
      Left = 420
      Top = 6
      Width = 97
      Height = 25
      Caption = 'SelectNoneButton'
      TabOrder = 4
      OnClick = SelectButtonClick
    end
    object HelpButton: TBitBtn
      Left = 214
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 2
      OnClick = HelpButtonClick
      Kind = bkHelp
    end
  end
end
