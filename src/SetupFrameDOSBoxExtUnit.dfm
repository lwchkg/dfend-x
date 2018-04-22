object SetupFrameDOSBoxExt: TSetupFrameDOSBoxExt
  Left = 0
  Top = 0
  Width = 585
  Height = 675
  VertScrollBar.Tracking = True
  TabOrder = 0
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 585
    Height = 675
    HorzScrollBar.Visible = False
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      585
      675)
    object WarningLabel: TLabel
      Left = 16
      Top = 16
      Width = 545
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'WarningLabel'
      WordWrap = True
    end
    object InfoLabel: TLabel
      Left = 16
      Top = 608
      Width = 281
      Height = 13
      Caption = 'You can download DOSBoxs supporting this features here:'
    end
    object InfoURLLabel: TLabel
      Left = 16
      Top = 627
      Width = 64
      Height = 13
      Caption = 'InfoURLLabel'
      OnClick = InfoURLLabelClick
    end
    object MountDialogGroupBox: TGroupBox
      Left = 16
      Top = 96
      Width = 545
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      Caption = 'MountDialogGroupBox'
      TabOrder = 0
      DesignSize = (
        545
        73)
      object MultiFloppyImageCheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Allow multiple floppy images per drive'
        TabOrder = 0
      end
      object PhysFSCheckBox: TCheckBox
        Left = 16
        Top = 47
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate PhysFS tab'
        TabOrder = 1
      end
    end
    object GraphicsGroupBox: TGroupBox
      Left = 16
      Top = 183
      Width = 545
      Height = 170
      Anchors = [akLeft, akTop, akRight]
      Caption = 'GraphicsGroupBox'
      TabOrder = 1
      DesignSize = (
        545
        170)
      object ExtendedTextModeCheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate 28 and 50 line text modes'
        TabOrder = 0
      end
      object GlideEmulationCheckBox: TCheckBox
        Left = 16
        Top = 47
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate Glide emulation settings'
        TabOrder = 1
      end
      object VGAChipsetCheckBox: TCheckBox
        Left = 16
        Top = 72
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate VGA chipset settings'
        TabOrder = 2
      end
      object RenderModesCheckBox: TCheckBox
        Left = 16
        Top = 95
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Add "openglhq" and "direct3d" render modes'
        TabOrder = 3
        OnClick = DefaultValueChanged
      end
      object VideoModesCheckBox: TCheckBox
        Tag = 1
        Left = 16
        Top = 118
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Add "pcjr", "ega" and "demovga" graphic modes'
        TabOrder = 4
        OnClick = DefaultValueChanged
      end
      object PixelShaderCheckBox: TCheckBox
        Tag = 3
        Left = 16
        Top = 141
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate pixel shader settings'
        TabOrder = 5
        OnClick = DefaultValueChanged
      end
    end
    object SoundGroupBox: TGroupBox
      Left = 16
      Top = 368
      Width = 545
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      Caption = 'SoundGroupBox'
      TabOrder = 2
      DesignSize = (
        545
        73)
      object MIDICheckBox: TCheckBox
        Tag = 2
        Left = 16
        Top = 24
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Add "mt32" MIDI device'
        TabOrder = 0
        OnClick = DefaultValueChanged
      end
      object InnovaCheckBox: TCheckBox
        Left = 16
        Top = 47
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate Innova emulation settings'
        TabOrder = 1
      end
    end
    object PrinterGroupBox: TGroupBox
      Left = 16
      Top = 455
      Width = 545
      Height = 58
      Anchors = [akLeft, akTop, akRight]
      Caption = 'PrinterGroupBox'
      TabOrder = 3
      DesignSize = (
        545
        58)
      object PrinterCheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate printer settings'
        TabOrder = 0
      end
    end
    object NetworkGroupBox: TGroupBox
      Left = 16
      Top = 528
      Width = 545
      Height = 58
      Caption = 'NetworkGroupBox'
      TabOrder = 4
      DesignSize = (
        545
        58)
      object NE2000CheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 513
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Activate NE2000 emulation settings'
        TabOrder = 0
      end
    end
  end
end
