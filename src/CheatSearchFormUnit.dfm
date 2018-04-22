object CheatSearchForm: TCheatSearchForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Search for address in saved game'
  ClientHeight = 326
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    550
    326)
  PixelsPerInch = 96
  TextHeight = 13
  object Notebook: TNotebook
    Left = 0
    Top = 0
    Width = 550
    Height = 286
    Anchors = [akLeft, akTop, akRight, akBottom]
    PageIndex = 2
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'SelectSearch'
      DesignSize = (
        550
        286)
      object SearchStartLabel: TLabel
        Left = 16
        Top = 8
        Width = 529
        Height = 66
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'If there is no unique address found for the value a second searc' +
          'h will be needed. Please enter a name for the new search or sele' +
          'ct a search to be continued from the list.'
        WordWrap = True
      end
      object SearchStartRadioButton1: TRadioButton
        Left = 16
        Top = 72
        Width = 521
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Start new search'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object SearchNameEdit: TLabeledEdit
        Left = 32
        Top = 112
        Width = 505
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 447
        EditLabel.Height = 13
        EditLabel.Caption = 
          'Name for the value to be searched (can be "game name - value to ' +
          'be searched" for example)'
        TabOrder = 1
        OnChange = SearchNameChange
      end
      object SearchStartRadioButton2: TRadioButton
        Left = 16
        Top = 147
        Width = 521
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Continue already started search'
        TabOrder = 2
      end
      object SearchNameComboBox: TComboBox
        Left = 32
        Top = 170
        Width = 505
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 3
        OnChange = SearchNameChange
      end
      object SearchNameDeleteButton: TBitBtn
        Left = 32
        Top = 197
        Width = 209
        Height = 25
        Caption = 'Delete selected search data'
        TabOrder = 4
        OnClick = SearchNameDeleteButtonClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
          555557777F777555F55500000000555055557777777755F75555005500055055
          555577F5777F57555555005550055555555577FF577F5FF55555500550050055
          5555577FF77577FF555555005050110555555577F757777FF555555505099910
          555555FF75777777FF555005550999910555577F5F77777775F5500505509990
          3055577F75F77777575F55005055090B030555775755777575755555555550B0
          B03055555F555757575755550555550B0B335555755555757555555555555550
          BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
          50BB555555555555575F555555555555550B5555555555555575}
        NumGlyphs = 2
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'DoSearch'
      DesignSize = (
        550
        286)
      object DoSearchLabel: TLabel
        Left = 16
        Top = 8
        Width = 521
        Height = 82
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'You can search for a known value or even for a value you do not ' +
          'know exactly. In the second case you will have to do multiple se' +
          'arches and tell D-Fend Reloaded each time if the value has incre' +
          'ased or decreased. When searching for an exactly known value you' +
          ' may also need more than one search if the value is been found a' +
          't more than one addresses in the file.'
        WordWrap = True
      end
      object FileNameButton: TSpeedButton
        Left = 514
        Top = 256
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
          0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
          B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
          FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
          FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
          FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
          0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
          0555555555777777755555555555555555555555555555555555}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = FileNameButtonClick
      end
      object ValueTypeRadioButton1: TRadioButton
        Left = 16
        Top = 96
        Width = 521
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Search for known value'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object ValueEdit: TLabeledEdit
        Left = 32
        Top = 136
        Width = 153
        Height = 21
        Hint = 
          'The value can be entered in decimal or hexadecimal notation. Hex' +
          'adecimal numbers have to start with a leading "$".'
        EditLabel.Width = 91
        EditLabel.Height = 13
        EditLabel.Caption = 'Value to search for'
        TabOrder = 1
        OnClick = SearchValueChange
      end
      object ValueTypeRadioButton2: TRadioButton
        Left = 16
        Top = 168
        Width = 521
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Search for not exactly known value'
        TabOrder = 2
      end
      object ValueComboBox: TComboBox
        Left = 32
        Top = 191
        Width = 249
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 3
        Text = 'Value has increased since last search'
        OnChange = SearchValueChange
        Items.Strings = (
          'Value has increased since last search'
          'Value has decreased since last search')
      end
      object FileNameEdit: TLabeledEdit
        Left = 16
        Top = 256
        Width = 492
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 135
        EditLabel.Height = 13
        EditLabel.Caption = 'Saved game file to search in'
        TabOrder = 4
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Actions'
      DesignSize = (
        550
        286)
      object ActionLabel: TLabel
        Left = 16
        Top = 8
        Width = 513
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'An unique address for the value has been found. You can add this' +
          ' address to your cheats data base now.'
        WordWrap = True
      end
      object BytesLabel: TLabel
        Left = 416
        Top = 52
        Width = 67
        Height = 13
        Caption = 'Bytes to write'
      end
      object GameNameLabel: TLabel
        Left = 16
        Top = 112
        Width = 56
        Height = 13
        Caption = 'Game name'
      end
      object LastSavedGameHintLabel: TLabel
        Left = 192
        Top = 183
        Width = 121
        Height = 13
        Caption = 'LastSavedGameHintLabel'
      end
      object AddressEdit: TLabeledEdit
        Left = 16
        Top = 71
        Width = 249
        Height = 21
        EditLabel.Width = 100
        EditLabel.Height = 13
        EditLabel.Caption = 'Address of the value'
        ReadOnly = True
        TabOrder = 0
      end
      object BytesComboBox: TComboBox
        Left = 416
        Top = 71
        Width = 113
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = BytesComboBoxChange
      end
      object GameNameComboBox: TComboBox
        Left = 16
        Top = 131
        Width = 249
        Height = 21
        ItemHeight = 13
        TabOrder = 3
      end
      object DescriptionEdit: TLabeledEdit
        Left = 280
        Top = 131
        Width = 249
        Height = 21
        EditLabel.Width = 164
        EditLabel.Height = 13
        EditLabel.Caption = 'Description ("Money" for example)'
        TabOrder = 4
      end
      object FileMaskEdit: TLabeledEdit
        Left = 16
        Top = 180
        Width = 161
        Height = 21
        EditLabel.Width = 146
        EditLabel.Height = 13
        EditLabel.Caption = 'Filemask ("*.sav" for example)'
        TabOrder = 5
      end
      object NewValueEdit: TLabeledEdit
        Left = 280
        Top = 71
        Width = 121
        Height = 21
        EditLabel.Width = 50
        EditLabel.Height = 13
        EditLabel.Caption = 'New value'
        TabOrder = 1
      end
      object UseDialogCheckBox: TCheckBox
        Left = 16
        Top = 215
        Width = 185
        Height = 17
        Caption = 'Let the user enter the new value'
        TabOrder = 6
      end
      object UseDialogEdit: TLabeledEdit
        Left = 32
        Top = 255
        Width = 497
        Height = 21
        EditLabel.Width = 66
        EditLabel.Height = 13
        EditLabel.Caption = 'Dialog prompt'
        TabOrder = 7
        OnChange = UseDialogEditChange
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'SelectAction'
      DesignSize = (
        550
        286)
      object SelectActionLabel: TLabel
        Left = 16
        Top = 8
        Width = 521
        Height = 48
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Multiple matching addresses have been found. You can store the s' +
          'earch results and continue later to find an unique address or yo' +
          'u can create a cheat record from one of the addresses below.'
        WordWrap = True
      end
      object SelectActionRadioGroup: TRadioGroup
        Left = 16
        Top = 200
        Width = 521
        Height = 73
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Actions'
        ItemIndex = 0
        Items.Strings = (
          'Store search results and close dialog'
          'Create cheat record from selected address and delete search data'
          
            'Create cheat record from selected address but keep the search da' +
            'ta')
        TabOrder = 1
      end
      object SelectActionListBox: TListBox
        Left = 16
        Top = 55
        Width = 521
        Height = 139
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
  object NextButton: TBitBtn
    Left = 8
    Top = 292
    Width = 97
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = 'Next'
    Default = True
    TabOrder = 1
    OnClick = NextButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333FF3333333333333003333
      3333333333773FF3333333333309003333333333337F773FF333333333099900
      33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
      99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
      33333333337F3F77333333333309003333333333337F77333333333333003333
      3333333333773333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 292
    Width = 97
    Height = 27
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 292
    Width = 97
    Height = 27
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object OpenDialog: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Title = 'Select saved game to search in'
    Left = 520
    Top = 8
  end
end
