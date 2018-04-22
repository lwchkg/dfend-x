object MakeBootImageFromProfileForm: TMakeBootImageFromProfileForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Create image file based profile from normal profile'
  ClientHeight = 265
  ClientWidth = 443
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
    443
    265)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 424
    Height = 82
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'This function can create a bootable harddisk image from a profil' +
      'e. Running a game under FreeDOS from a harddisk image can solve ' +
      'some rare problems on games not running in DOSBox directly. (The' +
      ' original profile is not changed in any way. The new harddisk im' +
      'age based profile is created as a copy.)'
    WordWrap = True
    ExplicitWidth = 377
  end
  object FreeSizeLabel: TLabel
    Left = 8
    Top = 134
    Width = 299
    Height = 13
    Caption = 'Additional free size on harddisk image (for saving games etc.):'
  end
  object FreeSizeMBLabel: TLabel
    Left = 79
    Top = 155
    Width = 14
    Height = 13
    Caption = 'MB'
  end
  object ProfileComboBox: TComboBox
    Left = 8
    Top = 96
    Width = 424
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    ExplicitWidth = 377
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 232
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 232
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 232
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object FreeSizeEdit: TSpinEdit
    Left = 8
    Top = 152
    Width = 65
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 10
  end
  object CompressedCheckBox: TCheckBox
    Left = 8
    Top = 182
    Width = 424
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Store Image with NTFS-compression'
    Checked = True
    State = cbChecked
    TabOrder = 2
    ExplicitWidth = 377
  end
  object MemoryManagerCheckBox: TCheckBox
    Left = 8
    Top = 205
    Width = 424
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use memory manager on disk image'
    Checked = True
    State = cbChecked
    TabOrder = 3
    ExplicitWidth = 377
  end
end
