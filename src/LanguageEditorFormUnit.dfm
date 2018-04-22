object LanguageEditorForm: TLanguageEditorForm
  Left = 0
  Top = 0
  Caption = 'Language editor'
  ClientHeight = 539
  ClientWidth = 659
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 659
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      659
      32)
    object CloseButton: TBitBtn
      Left = 4
      Top = 4
      Width = 97
      Height = 25
      TabOrder = 0
      Kind = bkClose
    end
    object SectionComboBox: TComboBox
      Left = 344
      Top = 5
      Width = 305
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
      OnChange = SectionComboBoxChange
      OnDropDown = ComboBoxDropDown
    end
    object ShowComboBox: TComboBox
      Left = 120
      Top = 5
      Width = 201
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = ShowComboBoxChange
      OnDropDown = ComboBoxDropDown
    end
  end
  object Tab: TStringGrid
    Left = 0
    Top = 32
    Width = 659
    Height = 488
    Align = alClient
    ColCount = 3
    FixedCols = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 1
    OnDrawCell = TabDrawCell
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 520
    Width = 659
    Height = 19
    Panels = <>
    SimplePanel = True
  end
end
