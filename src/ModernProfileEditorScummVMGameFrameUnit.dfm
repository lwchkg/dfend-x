object ModernProfileEditorScummVMGameFrame: TModernProfileEditorScummVMGameFrame
  Left = 0
  Top = 0
  Width = 675
  Height = 527
  TabOrder = 0
  DesignSize = (
    675
    527)
  object AltIntroLabel: TLabel
    Left = 48
    Top = 47
    Width = 624
    Height = 35
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '(in "Beneath a Steel Sky and "Flight of the Amazon Queen")'
    WordWrap = True
  end
  object GFXDetailsEditLabel: TLabel
    Left = 32
    Top = 88
    Width = 75
    Height = 13
    Caption = 'Graphics details'
  end
  object GFXDetailsLabel: TLabel
    Left = 32
    Top = 135
    Width = 625
    Height = 27
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '(in "Broken Sword 2")'
    WordWrap = True
  end
  object ObjectLabelsLabel: TLabel
    Left = 53
    Top = 191
    Width = 604
    Height = 27
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '(in "Broken Sword 2")'
    WordWrap = True
  end
  object ReverseStereoLabel: TLabel
    Left = 53
    Top = 247
    Width = 604
    Height = 27
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '(in "Broken Sword 2")'
    WordWrap = True
  end
  object MusicMuteLabel: TLabel
    Left = 53
    Top = 303
    Width = 604
    Height = 27
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      '("Broken Sword 2", "Flight of the Amazon Queen", "Simon the Sorc' +
      'erer 1" and "Simon the Sorcerer 2")'
    WordWrap = True
  end
  object SFXMuteLabel: TLabel
    Left = 53
    Top = 367
    Width = 604
    Height = 34
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      '("Broken Sword 2", "Flight of the Amazon Queen", "Simon the Sorc' +
      'erer 1" and "Simon the Sorcerer 2")'
    WordWrap = True
  end
  object WalkspeedEditLabel: TLabel
    Left = 37
    Top = 408
    Width = 55
    Height = 13
    Caption = 'Walk speed'
  end
  object WalkspeedLabel: TLabel
    Left = 37
    Top = 455
    Width = 620
    Height = 50
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '(in "The Legend of Kyrandia")'
    WordWrap = True
  end
  object AltIntroCheckBox: TCheckBox
    Left = 32
    Top = 24
    Width = 625
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use alternative intro'
    TabOrder = 0
  end
  object GFXDetailsEdit: TSpinEdit
    Left = 32
    Top = 107
    Width = 57
    Height = 22
    MaxValue = 3
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object ObjectLabelsCheckBox: TCheckBox
    Left = 37
    Top = 168
    Width = 620
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Show object labels'
    TabOrder = 2
  end
  object ReverseStereoCheckBox: TCheckBox
    Left = 37
    Top = 224
    Width = 620
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Reverse stereo channels'
    TabOrder = 3
  end
  object MusicMuteCheckBox: TCheckBox
    Left = 37
    Top = 280
    Width = 620
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Mute music'
    TabOrder = 4
  end
  object SFXMuteCheckBox: TCheckBox
    Left = 37
    Top = 344
    Width = 620
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Mute sound effects'
    TabOrder = 5
  end
  object WalkspeedEdit: TSpinEdit
    Left = 37
    Top = 427
    Width = 57
    Height = 22
    MaxValue = 4
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
end
