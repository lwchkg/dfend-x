object SetupFrameSecurity: TSetupFrameSecurity
  Left = 0
  Top = 0
  Width = 653
  Height = 405
  TabOrder = 0
  DesignSize = (
    653
    405)
  object DeleteProectionLabel: TLabel
    Left = 32
    Top = 66
    Width = 609
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Diese Option stellt sicher, dass auch beim L'#246'schen von falsch ko' +
      'nfigurierten Profilen niemals Dateien, die nicht zu D-Fend geh'#246'r' +
      'en, gel'#246'scht werden k'#246'nnen.'
    WordWrap = True
  end
  object UseChecksumsLabel: TLabel
    Left = 32
    Top = 137
    Width = 609
    Height = 66
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Sowohl '#252'ber die Programmdatei wie auch (sofern vorhanden) '#252'ber d' +
      'ie Setupdatei wird jeweils eine Pr'#252'fsumme berechnet und im Profi' +
      'l gespeichert. Mit Hilfe dieser Pr'#252'fsumme kann festgestellt werd' +
      'en, ob ein importiertes Profil '#252'berhaupt f'#252'r ein vorliegende Spi' +
      'el gedacht war und ob sich Programmdateien ver'#228'ndert haben.'
    WordWrap = True
  end
  object RecycleBinLabel: TLabel
    Left = 16
    Top = 209
    Width = 625
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Dateien beim L'#246'schen in den Papierkorb verschieben:'
  end
  object AskBeforeDeleteCheckBox: TCheckBox
    Left = 16
    Top = 16
    Width = 625
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Vor dem L'#246'schen von Eintr'#228'gen nachfragen'
    TabOrder = 0
  end
  object DeleteProectionCheckBox: TCheckBox
    Left = 16
    Top = 48
    Width = 625
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Niemals Dateien au'#223'erhalb des Basis-Verzeichnisses l'#246'schen'
    TabOrder = 1
  end
  object UseChecksumsCheckBox: TCheckBox
    Left = 16
    Top = 119
    Width = 569
    Height = 17
    Caption = 'DOS-Programmdateien per Pr'#252'fsumme auf '#196'nderungen '#252'berpr'#252'fen'
    TabOrder = 2
  end
  object RecycleBinListBox: TCheckListBox
    Left = 16
    Top = 224
    Width = 625
    Height = 109
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6')
    TabOrder = 3
  end
  object OfferRunAsAdminCheckBox: TCheckBox
    Left = 16
    Top = 345
    Width = 625
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Im Profileditor anbieten, DOSBox usw. mit Admin-Rechten auszuf'#252'h' +
      'ren'
    TabOrder = 4
  end
end
