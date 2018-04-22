object ZipInfoForm: TZipInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'ZipInfoForm'
  ClientHeight = 176
  ClientWidth = 452
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
    452
    176)
  PixelsPerInch = 96
  TextHeight = 13
  GlassFrame.Enabled = True
  GlassFrame.SheetOfGlass = True
  object InfoLabel: TLabel
    Left = 24
    Top = 56
    Width = 411
    Height = 112
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object ProgressBar: TProgressBar
    Left = 24
    Top = 16
    Width = 307
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object CancelButton: TBitBtn
    Left = 346
    Top = 12
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Abbrechen'
    Enabled = False
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelButtonClick
    NumGlyphs = 2
  end
end
