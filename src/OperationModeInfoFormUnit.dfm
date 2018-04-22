object OperationModeInfoForm: TOperationModeInfoForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'OperationModeInfoForm'
  ClientHeight = 367
  ClientWidth = 621
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
  DesignSize = (
    621
    367)
  PixelsPerInch = 96
  TextHeight = 13
  object TopLabel: TLabel
    Left = 16
    Top = 16
    Width = 205
    Height = 13
    Caption = 'Operation mode chosen during installation:'
  end
  object OpModeLabel: TLabel
    Left = 16
    Top = 35
    Width = 65
    Height = 13
    Caption = 'OpModeLabel'
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 334
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    Kind = bkOK
  end
  object PrgDirEdit: TLabeledEdit
    Left = 16
    Top = 204
    Width = 597
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = 'PrgDirEdit'
    ReadOnly = True
    TabOrder = 7
  end
  object PrgDataDirEdit: TLabeledEdit
    Left = 16
    Top = 252
    Width = 597
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    EditLabel.Width = 70
    EditLabel.Height = 13
    EditLabel.Caption = 'PrgDataDirEdit'
    ReadOnly = True
    TabOrder = 8
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 64
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Program settings are stored in program folder'
    Enabled = False
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 111
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'All users on this system share settings and profiles'
    Enabled = False
    TabOrder = 4
  end
  object CheckBox4: TCheckBox
    Left = 16
    Top = 134
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Useable without admin rights and under Windows Vista or higher'
    Enabled = False
    TabOrder = 5
  end
  object CheckBox5: TCheckBox
    Left = 16
    Top = 157
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'DOSBox and games directories are stored relative to D-Fend Reloa' +
      'ded folder (for portable use)'
    Enabled = False
    TabOrder = 6
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 87
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Program settings are stored in the user profile folder'
    Enabled = False
    TabOrder = 3
  end
  object HelpButton: TBitBtn
    Left = 124
    Top = 334
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object BaseDirEdit: TLabeledEdit
    Left = 16
    Top = 300
    Width = 597
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    EditLabel.Width = 54
    EditLabel.Height = 13
    EditLabel.Caption = 'BaseDirEdit'
    ReadOnly = True
    TabOrder = 9
  end
end
