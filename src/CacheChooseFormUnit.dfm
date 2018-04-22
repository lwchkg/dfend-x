object CacheChooseForm: TCacheChooseForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'CacheChooseForm'
  ClientHeight = 412
  ClientWidth = 425
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
    Left = 16
    Top = 16
    Width = 393
    Height = 105
    AutoSize = False
    Caption = 
      'The listed profiles have changed on disk. This changes will be o' +
      'verwritten with the version in memory when D-Fend Reloaded close' +
      's. If you want to keep the manual made changes to the files on t' +
      'he disk, you have to reload this files now. please select which ' +
      'profiles should be reloaded from disk now.'
    WordWrap = True
  end
  object ProfileListBox: TCheckListBox
    Left = 16
    Top = 120
    Width = 393
    Height = 253
    ItemHeight = 13
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 379
    Width = 89
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
end
