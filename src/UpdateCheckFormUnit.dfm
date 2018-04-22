object UpdateCheckForm: TUpdateCheckForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'UpdateCheckForm'
  ClientHeight = 502
  ClientWidth = 571
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    571
    502)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabelProgram: TLabel
    Left = 32
    Top = 34
    Width = 535
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If activated the update checker will search for new versions of ' +
      'D-Fend Reloaded. If there is a new version, it will ask you, if ' +
      'you want to update your installation.'
    WordWrap = True
    ExplicitWidth = 524
  end
  object InfoLabelPackages: TLabel
    Left = 32
    Top = 135
    Width = 535
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If activated the update checker will update the list of availabl' +
      'e packages if there are new lists on the server.'
    WordWrap = True
    ExplicitWidth = 524
  end
  object InfoLabelCheats: TLabel
    Left = 32
    Top = 236
    Width = 535
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If activated the update checker add new cheat records to the loc' +
      'al data base if there are new records on the server.'
    WordWrap = True
    ExplicitWidth = 524
  end
  object InfoLabelDatareader: TLabel
    Left = 32
    Top = 332
    Width = 535
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If activated the update checker will update the data reader conf' +
      'iguration from the server to ensure D-Fend Reloaded is able to i' +
      'nterpret the MobyGames search results homepage.'
    WordWrap = True
    ExplicitWidth = 524
  end
  object LabelDownload: TLabel
    Left = 16
    Top = 418
    Width = 409
    Height = 13
    Caption = 
      'You can also open the D-Fend Reloaded homepage and search for up' +
      'dates manually:'
  end
  object DFRHomepageLabel: TLabel
    Left = 16
    Top = 437
    Width = 96
    Height = 13
    Caption = 'DFRHomepageLabel'
    OnClick = DFRHomepageLabelClick
  end
  object StatusLabelProgram: TLabel
    Left = 32
    Top = 82
    Width = 120
    Height = 13
    Caption = 'Status: Not yet checked.'
  end
  object StatusLabelPackages: TLabel
    Left = 32
    Top = 183
    Width = 120
    Height = 13
    Caption = 'Status: Not yet checked.'
  end
  object StatusLabelCheats: TLabel
    Left = 32
    Top = 279
    Width = 120
    Height = 13
    Caption = 'Status: Not yet checked.'
  end
  object StatusLabelDatareader: TLabel
    Left = 32
    Top = 380
    Width = 120
    Height = 13
    Caption = 'Status: Not yet checked.'
  end
  object CheckBoxProgram: TCheckBox
    Left = 16
    Top = 16
    Width = 540
    Height = 17
    Caption = 'Search for program updates'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object CheckBoxPackages: TCheckBox
    Left = 16
    Top = 117
    Width = 540
    Height = 17
    Caption = 'Package lists for downloading add-ons and game packages'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object CheckBoxCheats: TCheckBox
    Left = 16
    Top = 218
    Width = 540
    Height = 17
    Caption = 'Cheats database'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object CheckBoxDatareader: TCheckBox
    Left = 16
    Top = 314
    Width = 540
    Height = 17
    Caption = 'Data reader configuration'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object UpdateButton: TBitBtn
    Tag = 3
    Left = 16
    Top = 472
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Update'
    TabOrder = 4
    OnClick = UpdateButtonClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0010992000D26C1000D26C1000D26C
      1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF001099200010992000A3D6A700A3D6A700E3B79400E3B7
      9400D26C1000D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000B1E7BC00B1E7BC00109920004AB25A00D26C1000C55E
      0A00E3B79400E3B79400D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000BCEDD3005CCC8B004AB25A004AB25A00D26C1000C55E
      0A00C55E0A00E3B79400D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0010992000BCEDD3008CD49B004AB25A00E9A04100E9A04100E9A04100D26C
      1000D26C100010992000A3D6A700D26C1000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000E9A04100E3B79400E9A04100E9A04100E9A041004AB2
      5A004AB25A004AB25A00A3D6A70010992000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000E9A041008CD49B00E9A04100E9A04100E9A041005CCC
      8B005CCC8B004AB25A00A3D6A70010992000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000BCEDD300BCEDD3008CD49B00FAEBD000FAEBD0004AB2
      5A005CCC8B005CCC8B00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00D26C1000E6F7EC00BCEDD300E6F7EC00458F6300458F6300E6F7
      EC004AB25A00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000E6F7EC00FF00FF00458F63005CCC8B004AB25A00458F
      6300E6F7EC00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B005CCC8B005CCC8B005CCC
      8B00458F6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00458F6300458F6300458F63005CCC8B005CCC8B00458F
      6300458F6300458F6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B005CCC8B00458F
      6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B004AB25A00458F
      6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
  end
  object CloseButton: TBitBtn
    Tag = 3
    Left = 135
    Top = 472
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Schlie'#223'en'
    ModalResult = 2
    TabOrder = 5
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
  end
  object SetupButton: TBitBtn
    Tag = 3
    Left = 254
    Top = 472
    Width = 243
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Automatisches Update konfigurieren'
    ModalResult = 1
    TabOrder = 6
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00370777033333
      3330337F3F7F33333F3787070003333707303F737773333373F7007703333330
      700077337F3333373777887007333337007733F773F333337733700070333333
      077037773733333F7F37703707333300080737F373333377737F003333333307
      78087733FFF3337FFF7F33300033330008073F3777F33F777F73073070370733
      078073F7F7FF73F37FF7700070007037007837773777F73377FF007777700730
      70007733FFF77F37377707700077033707307F37773F7FFF7337080777070003
      3330737F3F7F777F333778080707770333333F7F737F3F7F3333080787070003
      33337F73FF737773333307800077033333337337773373333333}
    NumGlyphs = 2
  end
end
