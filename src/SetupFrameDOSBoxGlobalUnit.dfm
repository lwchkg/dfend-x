object SetupFrameDOSBoxGlobal: TSetupFrameDOSBoxGlobal
  Left = 0
  Top = 0
  Width = 660
  Height = 491
  TabOrder = 0
  DesignSize = (
    660
    491)
  object GlobalGroupBox: TGroupBox
    Left = 8
    Top = 15
    Width = 642
    Height = 194
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Global settings (for all installations)'
    TabOrder = 0
    DesignSize = (
      642
      194)
    object DOSBoxFailedLabel: TLabel
      Left = 8
      Top = 142
      Width = 385
      Height = 13
      Caption = 
        'Show dialog to fix problems if DOSBox closes in less than this n' +
        'umber of seconds'
    end
    object MinimizeDFendCheckBox: TCheckBox
      Left = 8
      Top = 20
      Width = 631
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'D-Fend Reloaded minimieren, wenn DOSBox gestartet wird'
      TabOrder = 0
      OnClick = MinimizeDFendCheckBoxClick
      ExplicitWidth = 617
    end
    object RestoreWindowCheckBox: TCheckBox
      Left = 29
      Top = 40
      Width = 610
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Restore program window when DOSBox is closed'
      TabOrder = 1
      ExplicitWidth = 596
    end
    object UseShortPathNamesCheckBox: TCheckBox
      Left = 8
      Top = 68
      Width = 631
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use short path names for mount commands'
      TabOrder = 2
      ExplicitWidth = 617
    end
    object ShortNameWarningsCheckBox: TCheckBox
      Left = 8
      Top = 92
      Width = 631
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Show warning messages on DOSBox path name translation errors'
      TabOrder = 3
      ExplicitWidth = 617
    end
    object CreateConfFilesCheckBox: TCheckBox
      Left = 8
      Top = 116
      Width = 631
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        'Always create conf files for all profiles (off: only when starti' +
        'ng DOSBox)'
      TabOrder = 4
      ExplicitWidth = 617
    end
    object DOSBoxFailedEdit: TSpinEdit
      Left = 8
      Top = 161
      Width = 73
      Height = 22
      MaxValue = 60
      MinValue = 1
      TabOrder = 5
      Value = 3
    end
  end
end
