unit CopyProfileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TCopyProfileForm = class(TForm)
    NameEdit: TLabeledEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    UpdateScreenshotFolderCheckBox: TCheckBox;
    RemoveDataFolderRecordCheckBox: TCheckBox;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  CopyProfileForm: TCopyProfileForm;

Function ShowCopyProfileDialog(const AOwner : TComponent; const ADataFolderAvailable : Boolean; var ANewName : String; var AUpdateScreenshotFolder, ARemoveDataFolderRecord : Boolean) : Boolean;

implementation

uses VistaToolsUnit, CommonTools, LanguageSetupUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TCopyProfileForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.MenuProfileCopyTitle;
  NameEdit.EditLabel.Caption:=LanguageSetup.MenuProfileCopyPrompt;
  UpdateScreenshotFolderCheckBox.Caption:=LanguageSetup.MenuProfileCopyUpdateScreenshotFolder;
  RemoveDataFolderRecordCheckBox.Caption:=LanguageSetup.MenuProfileCopyRemoveDataFolderRecord;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TCopyProfileForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileCopy);
end;

procedure TCopyProfileForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCopyProfileDialog(const AOwner : TComponent; const ADataFolderAvailable : Boolean; var ANewName : String; var AUpdateScreenshotFolder, ARemoveDataFolderRecord : Boolean) : Boolean;
begin
  CopyProfileForm:=TCopyProfileForm.Create(AOwner);
  try
    CopyProfileForm.NameEdit.Text:=ANewName;
    CopyProfileForm.RemoveDataFolderRecordCheckBox.Enabled:=ADataFolderAvailable;
    result:=(CopyProfileForm.ShowModal=mrOK);
    If result then begin
      ANewName:=CopyProfileForm.NameEdit.Text;
      AUpdateScreenshotFolder:=CopyProfileForm.UpdateScreenshotFolderCheckBox.Checked;
      ARemoveDataFolderRecord:=ADataFolderAvailable and CopyProfileForm.RemoveDataFolderRecordCheckBox.Checked;
    end;
  finally
    CopyProfileForm.Free;
  end;
end;

end.
