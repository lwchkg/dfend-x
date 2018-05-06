object DOSBoxFailedForm: TDOSBoxFailedForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DOSBoxFailedForm'
  ClientHeight = 357
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    645
    357)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 628
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
    ExplicitWidth = 905
  end
  object DoNotShowAgainCheckBox: TCheckBox
    Left = 128
    Top = 328
    Width = 509
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'DoNotShowAgainCheckBox'
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 324
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object ProfileGroupBox: TGroupBox
    Left = 8
    Top = 96
    Width = 629
    Height = 129
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Profile specific settings'
    TabOrder = 2
    DesignSize = (
      629
      129)
    object RenderLabel: TLabel
      Left = 8
      Top = 75
      Width = 60
      Height = 13
      Caption = 'RenderLabel'
    end
    object CloseDOSBoxCheckBox: TCheckBox
      Left = 8
      Top = 23
      Width = 605
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'CloseDOSBoxCheckBox'
      TabOrder = 0
    end
    object ShowConsoleCheckBox: TCheckBox
      Left = 8
      Top = 46
      Width = 605
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'ShowConsoleCheckBox'
      TabOrder = 1
    end
    object RenderComboBox: TComboBox
      Left = 8
      Top = 90
      Width = 225
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
  end
  object GlobalGroupBox: TGroupBox
    Left = 8
    Top = 240
    Width = 629
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Settings for all profiles'
    TabOrder = 3
    object SDLLabel: TLabel
      Left = 8
      Top = 24
      Width = 78
      Height = 13
      Caption = 'SDL video driver'
    end
    object RemoteLabel: TLabel
      Left = 248
      Top = 24
      Width = 378
      Height = 41
      AutoSize = False
      Caption = 'RemoteLabel'
      WordWrap = True
    end
    object SDLComboBox: TComboBox
      Left = 8
      Top = 39
      Width = 225
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = '[None]'
      Items.Strings = (
        '[None]'
        'Direct X'
        'Win DIB'
        'Windows')
    end
  end
end
