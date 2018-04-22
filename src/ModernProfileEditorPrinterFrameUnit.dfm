object ModernProfileEditorPrinterFrame: TModernProfileEditorPrinterFrame
  Left = 0
  Top = 0
  Width = 640
  Height = 520
  TabOrder = 0
  DesignSize = (
    640
    520)
  object ResolutionLabel: TLabel
    Left = 16
    Top = 56
    Width = 75
    Height = 13
    Caption = 'ResolutionLabel'
  end
  object PaperWidthLabel: TLabel
    Left = 16
    Top = 104
    Width = 81
    Height = 13
    Caption = 'PaperWidthLabel'
  end
  object PaperHeightLabel: TLabel
    Left = 128
    Top = 104
    Width = 84
    Height = 13
    Caption = 'PaperHeightLabel'
  end
  object PaperSizeInfoLabel: TLabel
    Left = 16
    Top = 151
    Width = 92
    Height = 13
    Caption = 'PaperSizeInfoLabel'
  end
  object OutputFormatLabel: TLabel
    Left = 16
    Top = 184
    Width = 93
    Height = 13
    Caption = 'OutputFormatLabel'
  end
  object OutputFormatInfoLabel: TLabel
    Left = 143
    Top = 200
    Width = 474
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'OutputFormatInfoLabel'
    WordWrap = True
  end
  object MultiPageInfoLabel: TLabel
    Left = 32
    Top = 271
    Width = 585
    Height = 50
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'MultiPageInfoLabel'
    WordWrap = True
  end
  object EnablePrinterEmulationCheckBox: TCheckBox
    Left = 16
    Top = 16
    Width = 601
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'EnablePrinterEmulationCheckBox'
    TabOrder = 0
  end
  object ResolutionEdit: TSpinEdit
    Left = 16
    Top = 72
    Width = 65
    Height = 22
    MaxValue = 1200
    MinValue = 72
    TabOrder = 1
    Value = 360
  end
  object PaperWidthEdit: TSpinEdit
    Left = 16
    Top = 123
    Width = 65
    Height = 22
    MaxValue = 250
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
  object PaperHeightEdit: TSpinEdit
    Left = 128
    Top = 123
    Width = 65
    Height = 22
    MaxValue = 250
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
  object OutputFormatComboBox: TComboBox
    Left = 16
    Top = 200
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 4
  end
  object MultiPageCheckBox: TCheckBox
    Left = 16
    Top = 248
    Width = 601
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'MultiPageCheckBox'
    TabOrder = 5
  end
end
