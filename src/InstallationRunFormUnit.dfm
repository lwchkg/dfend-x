object InstallationRunForm: TInstallationRunForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Game installation'
  ClientHeight = 177
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    341
    177)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 325
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object SourceLabel: TLabel
    Left = 8
    Top = 55
    Width = 100
    Height = 13
    Caption = 'Select active source:'
  end
  object SourceListBox: TCheckListBox
    Left = 8
    Top = 74
    Width = 325
    Height = 97
    OnClickCheck = SourceListBoxClick
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnClick = SourceListBoxClick
  end
end
