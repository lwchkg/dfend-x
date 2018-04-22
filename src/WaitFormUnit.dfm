object WaitForm: TWaitForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Please wait'
  ClientHeight = 37
  ClientWidth = 371
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
    371
    37)
  PixelsPerInch = 96
  TextHeight = 13
  GlassFrame.Enabled = True
  GlassFrame.SheetOfGlass = True
  object ProgressBar: TProgressBar
    Left = 8
    Top = 8
    Width = 353
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
end
