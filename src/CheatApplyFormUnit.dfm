object CheatApplyForm: TCheatApplyForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change saved game'
  ClientHeight = 439
  ClientWidth = 575
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
  DesignSize = (
    575
    439)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 559
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The dropdown list will show the names of the game for that files' +
      ' matching to the saved games file masks are found in the given g' +
      'ame directory.'
    WordWrap = True
    ExplicitWidth = 679
  end
  object GameLabel: TLabel
    Left = 8
    Top = 59
    Width = 152
    Height = 13
    Caption = 'Cheats data base game record:'
  end
  object CheatsLabel: TLabel
    Left = 8
    Top = 116
    Width = 82
    Height = 13
    Caption = 'Available cheats:'
  end
  object FilesLabel: TLabel
    Left = 213
    Top = 116
    Width = 64
    Height = 13
    Caption = 'Saved games'
  end
  object WarningLabel: TLabel
    Left = 8
    Top = 359
    Width = 559
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Changing a save game file can corrupt the file and make it unloa' +
      'dable. Therefore D-Fend Reloaded will make a backup copy before ' +
      'changing the file.'
    WordWrap = True
  end
  object CheatsListBox: TCheckListBox
    Left = 8
    Top = 131
    Width = 199
    Height = 174
    ItemHeight = 13
    TabOrder = 1
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 406
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 110
    Top = 406
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 212
    Top = 406
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object FilesListBox: TCheckListBox
    Left = 213
    Top = 131
    Width = 356
    Height = 174
    ItemHeight = 13
    TabOrder = 2
    OnClick = FilesListBoxClick
  end
  object GameComboBox: TComboBox
    Left = 8
    Top = 74
    Width = 273
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = GameComboBoxChange
  end
  object SelectButton: TButton
    Left = 213
    Top = 311
    Width = 204
    Height = 25
    Caption = 'Select the last changed file'
    TabOrder = 3
    OnClick = SelectButtonClick
  end
  object EditButton: TBitBtn
    Left = 315
    Top = 406
    Width = 214
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Edit cheats data base'
    TabOrder = 7
    OnClick = EditButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
      000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
      00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
      F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
      0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
      FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
      FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
      0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
      00333377737FFFFF773333303300000003333337337777777333}
    NumGlyphs = 2
  end
end
