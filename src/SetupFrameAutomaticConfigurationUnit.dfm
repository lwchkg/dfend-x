object SetupFrameAutomaticConfiguration: TSetupFrameAutomaticConfiguration
  Left = 0
  Top = 0
  Width = 681
  Height = 563
  TabOrder = 0
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 681
    Height = 563
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    ExplicitHeight = 724
    DesignSize = (
      681
      563)
    object InstallerNamesLabel: TLabel
      Left = 8
      Top = 216
      Width = 297
      Height = 13
      Caption = 'Program file names to identify games that need to be installed'
    end
    object ArchiveIDFilesLabel: TLabel
      Left = 8
      Top = 392
      Width = 224
      Height = 13
      Caption = 'Description files for the content of archive files'
    end
    object InstallerNamesMemo: TMemo
      Left = 8
      Top = 235
      Width = 145
      Height = 142
      TabOrder = 0
    end
    object WizardRadioGroup: TRadioGroup
      Left = 8
      Top = 96
      Width = 660
      Height = 105
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Profile wizard'
      TabOrder = 1
      ExplicitWidth = 649
    end
    object ZipImportGroupBox: TGroupBox
      Left = 8
      Top = 16
      Width = 660
      Height = 57
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Archive file import'
      TabOrder = 2
      ExplicitWidth = 649
      DesignSize = (
        660
        57)
      object ZipImportCheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 641
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 
          'Do not show dialog if the game can be identifed by an auto setup' +
          ' template'
        TabOrder = 0
      end
    end
    object ArchiveIDFilesMemo: TMemo
      Left = 8
      Top = 411
      Width = 145
      Height = 142
      TabOrder = 3
    end
  end
end
