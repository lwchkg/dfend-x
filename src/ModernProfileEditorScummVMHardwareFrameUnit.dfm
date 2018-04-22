object ModernProfileEditorScummVMHardwareFrame: TModernProfileEditorScummVMHardwareFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 455
  TabOrder = 0
  DesignSize = (
    600
    455)
  object PlatformLabel: TLabel
    Left = 16
    Top = 248
    Width = 65
    Height = 13
    Caption = 'PlatformLabel'
  end
  object CDGroupBox: TGroupBox
    Left = 16
    Top = 15
    Width = 569
    Height = 98
    Anchors = [akLeft, akTop, akRight]
    Caption = 'CD drive for playing audio'
    TabOrder = 0
    DesignSize = (
      569
      98)
    object CDRadioButton1: TRadioButton
      Left = 16
      Top = 24
      Width = 537
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Do not try to play CD audio'
      TabOrder = 0
    end
    object CDRadioButton2: TRadioButton
      Left = 16
      Top = 47
      Width = 537
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use drive number'
      TabOrder = 1
    end
    object CDEdit: TSpinEdit
      Left = 32
      Top = 68
      Width = 57
      Height = 22
      MaxValue = 3
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = CDEditChange
    end
  end
  object JoystickGroupBox: TGroupBox
    Left = 16
    Top = 126
    Width = 569
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Joystick'
    TabOrder = 1
    object JoystickRadioButton1: TRadioButton
      Left = 16
      Top = 24
      Width = 529
      Height = 17
      Caption = 'Do not use joystick'
      TabOrder = 0
    end
    object JoystickRadioButton2: TRadioButton
      Left = 16
      Top = 48
      Width = 529
      Height = 17
      Caption = 'Use Joystick number'
      TabOrder = 1
    end
    object JoystickEdit: TSpinEdit
      Left = 32
      Top = 71
      Width = 57
      Height = 22
      MaxValue = 3
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = JoystickEditChange
    end
  end
  object PlatformComboBox: TComboBox
    Left = 16
    Top = 267
    Width = 569
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 2
  end
end
