object ExtraExeEditForm: TExtraExeEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ExtraExeEditForm'
  ClientHeight = 444
  ClientWidth = 669
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
    669
    444)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 342
    Width = 653
    Height = 65
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
    ExplicitTop = 302
    ExplicitWidth = 629
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 413
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 413
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 413
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object Tab: TStringGrid
    Left = 8
    Top = 8
    Width = 653
    Height = 290
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    FixedCols = 0
    RowCount = 51
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 0
    OnClick = TabClick
  end
  object SelectButton: TBitBtn
    Left = 8
    Top = 304
    Width = 177
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Select program file'
    TabOrder = 1
    OnClick = SelectButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
  end
end
