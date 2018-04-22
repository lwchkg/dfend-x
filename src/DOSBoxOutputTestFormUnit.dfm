object DOSBoxOutputTestForm: TDOSBoxOutputTestForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DOSBoxOutputTestForm'
  ClientHeight = 297
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    417
    297)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 399
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Using this function you can check which DOSBox output methods ar' +
      'e supported by your graphics driver.'
    WordWrap = True
    ExplicitWidth = 473
  end
  object TestButton: TBitBtn
    Left = 8
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Start test'
    Default = True
    TabOrder = 0
    OnClick = TestButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CloseButton: TBitBtn
    Left = 111
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkClose
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object Tab: TStringGrid
    Left = 8
    Top = 55
    Width = 401
    Height = 203
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    TabOrder = 3
  end
end
