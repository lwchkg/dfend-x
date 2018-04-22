object PackageManagerRepositoriesEditURLForm: TPackageManagerRepositoriesEditURLForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'PackageManagerRepositoriesEditURLForm'
  ClientHeight = 335
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SelectFileButton: TSpeedButton
    Left = 434
    Top = 134
    Width = 23
    Height = 22
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
    ParentShowHint = False
    ShowHint = True
    OnClick = SelectFileButtonClick
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 302
    Width = 97
    Height = 25
    TabOrder = 6
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 119
    Top = 302
    Width = 97
    Height = 25
    TabOrder = 7
    Kind = bkCancel
  end
  object RadioButtonURL: TRadioButton
    Left = 16
    Top = 16
    Width = 113
    Height = 17
    Caption = 'URL'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = RadioButtonOrEditChange
  end
  object RadioButtonLocalFile: TRadioButton
    Left = 16
    Top = 112
    Width = 113
    Height = 17
    Caption = 'Local file'
    TabOrder = 3
    OnClick = RadioButtonOrEditChange
  end
  object URLEdit: TEdit
    Left = 35
    Top = 39
    Width = 425
    Height = 21
    TabOrder = 1
    OnChange = EditChange
  end
  object PasteURLButton: TBitBtn
    Left = 32
    Top = 66
    Width = 225
    Height = 25
    Caption = 'Paste URL from clipboard'
    Enabled = False
    TabOrder = 2
    OnClick = PasteURLButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330FFFFF
      FFF03333337F3FFFF3F73333330F0000F0F03333337F777737373333330FFFFF
      FFF033FFFF7FFF33FFF77000000007F00000377777777FF777770BBBBBBBB0F0
      FF037777777777F7F3730B77777BB0F0F0337777777777F7F7330B7FFFFFB0F0
      0333777F333377F77F330B7FFFFFB0009333777F333377777FF30B7FFFFFB039
      9933777F333377F777FF0B7FFFFFB0999993777F33337777777F0B7FFFFFB999
      9999777F3333777777770B7FFFFFB0399933777FFFFF77F777F3070077007039
      99337777777777F777F30B770077B039993377FFFFFF77F777330BB7007BB999
      93337777FF777777733370000000073333333777777773333333}
    NumGlyphs = 2
  end
  object LocalFileEdit: TEdit
    Left = 32
    Top = 135
    Width = 396
    Height = 21
    TabOrder = 4
    OnChange = EditChange
  end
  object WarningGroupBox: TGroupBox
    Left = 16
    Top = 176
    Width = 444
    Height = 113
    Caption = 'WarningGroupBox'
    TabOrder = 5
    object WarningLabel: TLabel
      Left = 8
      Top = 24
      Width = 433
      Height = 73
      AutoSize = False
      Caption = 'WarningLabel'
      WordWrap = True
    end
  end
  object ClipboardTimer: TTimer
    Interval = 100
    OnTimer = ClipboardTimerTimer
    Left = 424
    Top = 64
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'xml'
    Left = 424
    Top = 96
  end
end
