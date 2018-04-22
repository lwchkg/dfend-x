object SetupFrameGamesListTreeAppearance: TSetupFrameGamesListTreeAppearance
  Left = 0
  Top = 0
  Width = 589
  Height = 548
  TabOrder = 0
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 589
    Height = 548
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      589
      548)
    object TreeViewFontSizeLabel: TLabel
      Left = 16
      Top = 129
      Width = 59
      Height = 13
      Caption = 'Schriftgr'#246#223'e'
    end
    object TreeViewFontColorLabel: TLabel
      Left = 140
      Top = 129
      Width = 61
      Height = 13
      Caption = 'Schriftfarbe:'
    end
    object TreeViewGroupsLabel: TLabel
      Left = 16
      Top = 361
      Width = 137
      Height = 13
      Caption = 'Benutzerdefinierte Gruppen:'
    end
    object TreeViewGroupsInfoLabel: TLabel
      Left = 16
      Top = 464
      Width = 561
      Height = 57
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Die benutzerdefinierten Gruppen werden in der Baumstruktur als w' +
        'eitere Filterkategorien angeboten. Bei den Spielen k'#246'nnen Werte ' +
        'f'#252'r die Kategorien '#252'ber die "Benutzerdefinierten Informationen" ' +
        'definiert werden.'
      WordWrap = True
    end
    object PredefinedGroupsLabel: TLabel
      Left = 16
      Top = 181
      Width = 84
      Height = 13
      Caption = 'Vorgabegruppen:'
    end
    object TreeViewBackgroundRadioButton1: TRadioButton
      Left = 16
      Top = 57
      Width = 561
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Standard Hintergrundfarbe'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object TreeViewBackgroundRadioButton2: TRadioButton
      Left = 16
      Top = 80
      Width = 129
      Height = 17
      Caption = 'Hintergrundfarbe'
      TabOrder = 2
    end
    object TreeViewBackgroundColorBox: TColorBox
      Left = 151
      Top = 78
      Width = 130
      Height = 22
      ItemHeight = 16
      TabOrder = 3
      OnChange = TreeViewBackgroundColorBoxChange
    end
    object TreeViewFontSizeEdit: TSpinEdit
      Left = 16
      Top = 148
      Width = 59
      Height = 22
      MaxValue = 48
      MinValue = 1
      TabOrder = 4
      Value = 9
    end
    object TreeViewFontColorBox: TColorBox
      Left = 140
      Top = 148
      Width = 130
      Height = 22
      ItemHeight = 16
      TabOrder = 5
    end
    object TreeViewGroupsEdit: TRichEdit
      Left = 16
      Top = 380
      Width = 161
      Height = 78
      PlainText = True
      ScrollBars = ssBoth
      TabOrder = 7
    end
    object UserKeysList: TBitBtn
      Left = 183
      Top = 378
      Width = 202
      Height = 25
      Caption = 'Existierende Benutzerschl'#252'ssel'
      TabOrder = 8
      OnClick = UserKeysListClick
    end
    object ReselectFilterCheckBox: TCheckBox
      Left = 16
      Top = 16
      Width = 561
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Zuletzt ausgew'#228'hlte Kategorie beim Start erneut ausw'#228'hlen'
      TabOrder = 0
    end
    object TreeViewDefaultGroups: TCheckListBox
      Left = 16
      Top = 200
      Width = 161
      Height = 129
      ItemHeight = 13
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8')
      TabOrder = 6
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 188
    Top = 369
  end
end
