object SetupFrameWindowsGames: TSetupFrameWindowsGames
  Left = 0
  Top = 0
  Width = 671
  Height = 406
  TabOrder = 0
  DesignSize = (
    671
    406)
  object AutoRestoreInfoLabel: TLabel
    Left = 56
    Top = 69
    Width = 593
    Height = 92
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'AutoRestoreInfoLabel'
    WordWrap = True
  end
  object AllowWindowsPackagesLabel: TLabel
    Left = 37
    Top = 207
    Width = 612
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Most Windows games are not intended to be moved to other install' +
      'ations so transfering Windows games in archive files can cause m' +
      'any problems and is not recommended to do.'
    WordWrap = True
  end
  object MinimizeDFendCheckBox: TCheckBox
    Left = 16
    Top = 23
    Width = 633
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'D-Fend minimieren, wenn ein Windows-Spiel gestartet wird'
    TabOrder = 0
    OnClick = MinimizeDFendCheckBoxClick
  end
  object RestoreWindowCheckBox: TCheckBox
    Left = 37
    Top = 46
    Width = 612
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Restore program window when the Windowsgame is closed'
    TabOrder = 1
  end
  object AllowWindowsPackagesCheckBox: TCheckBox
    Left = 16
    Top = 184
    Width = 633
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Allow D-Fend Reloaded to create archive files from Windows profi' +
      'les and import Windows profile package files'
    TabOrder = 2
  end
end
