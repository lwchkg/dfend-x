object ZipPackageDBGLForm: TZipPackageDBGLForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'ZipPackageDBGLForm'
  ClientHeight = 520
  ClientWidth = 436
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
    436
    520)
  PixelsPerInch = 96
  TextHeight = 13
  object NotesLabel: TLabel
    Left = 16
    Top = 64
    Width = 28
    Height = 13
    Caption = 'Notes'
  end
  object GamesLabel: TLabel
    Left = 16
    Top = 248
    Width = 78
    Height = 13
    Caption = 'Games to import'
  end
  object TitleEdit: TLabeledEdit
    Left = 16
    Top = 24
    Width = 226
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'Package title'
    ReadOnly = True
    TabOrder = 0
  end
  object AuthorEdit: TLabeledEdit
    Left = 248
    Top = 24
    Width = 177
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = 'Package author'
    ReadOnly = True
    TabOrder = 1
  end
  object GamesListBox: TCheckListBox
    Left = 16
    Top = 267
    Width = 409
    Height = 217
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
  object NotesMemo: TRichEdit
    Left = 16
    Top = 80
    Width = 409
    Height = 153
    Anchors = [akLeft, akTop, akRight]
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 490
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 118
    Top = 490
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Kind = bkCancel
  end
end
