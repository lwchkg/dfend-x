object ProviderForm: TProviderForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'ProviderForm'
  ClientHeight = 393
  ClientWidth = 351
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
    351
    393)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 171
    Height = 13
    Caption = 'The files you are going to download'
  end
  object Label2: TLabel
    Left = 16
    Top = 144
    Width = 76
    Height = 13
    Caption = 'are provided by'
  end
  object ProviderNameLabel: TLabel
    Left = 16
    Top = 163
    Width = 40
    Height = 13
    Caption = 'Provider'
  end
  object Label3: TLabel
    Left = 16
    Top = 184
    Width = 56
    Height = 13
    Caption = 'Information'
  end
  object ProviderTextLabel: TLabel
    Left = 16
    Top = 203
    Width = 321
    Height = 96
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'ProviderTextLabel'
    WordWrap = True
    ExplicitHeight = 70
  end
  object Label4: TLabel
    Left = 16
    Top = 314
    Width = 51
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Homepage'
    ExplicitTop = 288
  end
  object ProviderURLLabel: TLabel
    Left = 16
    Top = 333
    Width = 19
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'URL'
    OnClick = ProviderURLLabelClick
    ExplicitTop = 307
  end
  object ListBox: TListBox
    Left = 16
    Top = 32
    Width = 321
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 361
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkOK
  end
end
