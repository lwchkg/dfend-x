unit BuildImageFromFolderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin;

type
  TBuildImageFromFolderForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    FolderEdit: TLabeledEdit;
    FileNameEdit: TLabeledEdit;
    FileNameButton: TSpeedButton;
    FolderButton: TSpeedButton;
    MakeBootableCheckBox: TCheckBox;
    AddKeyboardDriverCheckBox: TCheckBox;
    SaveDialog: TSaveDialog;
    WriteToFloppyCheckBox: TCheckBox;
    AddMouseDriverCheckBox: TCheckBox;
    HelpButton: TBitBtn;
    AddFormatCheckBox: TCheckBox;
    AddEditCheckbox: TCheckBox;
    ImageTypeGroupBox: TRadioGroup;
    MemoryManagerCheckBox: TCheckBox;
    FreeSpaceLabel: TLabel;
    FreeSpaceEdit: TSpinEdit;
    NeedFreeDOSLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure MakeBootableCheckBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImageTypeGroupBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    FloppyDriveAvailable : Boolean;
  public
    { Public-Deklarationen }
  end;

var
  BuildImageFromFolderForm: TBuildImageFromFolderForm;

Function ShowBuildImageFromFolderDialog(const AOwner : TComponent) : Boolean;

implementation

Uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     CreateISOImageFormUnit, GameDBUnit, DOSBoxUnit, PrgConsts, CreateImageToolsUnit,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TBuildImageFromFolderForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ImageFromFolderCaption;
  FolderEdit.EditLabel.Caption:=LanguageSetup.ImageFromFolderSourceFolder;
  FolderButton.Hint:=LanguageSetup.ChooseFolder;
  FileNameEdit.EditLabel.Caption:=LanguageSetup.ImageFromFolderImageFile;
  FileNamebutton.Hint:=LanguageSetup.ChooseFile;
  ImageTypeGroupBox.Caption:=LanguageSetup.ImageFromFolderImageType;
  ImageTypeGroupBox.Items[0]:=LanguageSetup.ImageFromFolderImageTypeFloppy;
  ImageTypeGroupBox.Items[1]:=LanguageSetup.ImageFromFolderImageTypeHarddisk;
  FreeSpaceLabel.Caption:=LanguageSetup.ImageFromFolderAdditionalFreeSpace;
  MakeBootableCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootable;
  NeedFreeDOSLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  AddKeyboardDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithKeyboardDriver;
  AddMouseDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMouseDriver;
  MemoryManagerCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMemoryManager;
  AddFormatCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithFormat;
  AddEditCheckbox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithEdit;
  WriteToFloppyCheckBox.Caption:=LanguageSetup.ImageFromFolderWriteToFloppy;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SaveDialog.Title:=LanguageSetup.ImageFromFolderSaveDialogTitle;
  SaveDialog.Filter:=LanguageSetup.ImageFromFolderSaveDialogFilter;

  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    NeedFreeDOSLabel.Font.Color:=clGrayText;
  end else begin
    NeedFreeDOSLabel.Font.Color:=clRed;
  end;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_SelectFolder,FolderButton);
  UserIconLoader.DialogImage(DI_SelectFile,FileNameButton);
end;

procedure TBuildImageFromFolderForm.FormShow(Sender: TObject);
Var C : Char;
begin
  FloppyDriveAvailable:=False;
  For C:='A' to 'Z' do If GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin FloppyDriveAvailable:=True; break; end;
  ImageTypeGroupBoxClick(Sender);
end;

procedure TBuildImageFromFolderForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=Trim(FolderEdit.Text);
          If S='' then S:=PrgSetup.BaseDir else S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
          If SelectDirectory(Handle,LanguageSetup.ExtractImageFolderTitle,S) then FolderEdit.Text:=S;
        end;
    1 : begin
          S:=Trim(FileNameEdit.Text);
          If S='' then S:=PrgSetup.BaseDir else S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
          SaveDialog.InitialDir:=S;
          If SaveDialog.Execute then FileNameEdit.Text:=SaveDialog.FileName;
        end;
  end;
end;

procedure TBuildImageFromFolderForm.ImageTypeGroupBoxClick(Sender: TObject);
begin
  WriteToFloppyCheckBox.Enabled:=(ImageTypeGroupBox.ItemIndex=0) and FloppyDriveAvailable;
  FreeSpaceLabel.Visible:=(ImageTypeGroupBox.ItemIndex=1);
  FreeSpaceEdit.Visible:=(ImageTypeGroupBox.ItemIndex=1);
end;

procedure TBuildImageFromFolderForm.MakeBootableCheckBoxClick(Sender: TObject);
begin
  AddKeyboardDriverCheckBox.Enabled:=MakeBootableCheckBox.Checked;
  AddMouseDriverCheckBox.Enabled:=MakeBootableCheckBox.Checked;
  MemoryManagerCheckBox.Enabled:=MakeBootableCheckBox.Checked;
end;

procedure TBuildImageFromFolderForm.OKButtonClick(Sender: TObject);
Var FileName, Dir, FreeDOS : String;
    Upgrades : TDiskImageCreatorUpgrades;
    Size : Integer;
    St : TStringList;
begin
  FreeDOS:=Trim(PrgSetup.PathToFREEDOS);
  If FreeDOS<>'' then FreeDOS:=IncludeTrailingPathDelimiter(MakeAbsPath(FreeDOS,PrgSetup.BaseDir));
  If (FreeDOS='') or (not DirectoryExists(FreeDOS)) then begin
    MessageDlg(LanguageSetup.ProfileEditorNeedFreeDOS,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  Dir:=Trim(FolderEdit.Text);
  If Dir='' then begin
    MessageDlg(LanguageSetup.MessageNoFolderName,mtError,[mbOk],0);
    ModalResult:=mrNone; exit;
  end;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(Dir),PrgSetup.BaseDir));
  If not DirectoryExists(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageDirectoryNotFound,[Dir]),mtError,[mbOk],0);
    ModalResult:=mrNone; exit;
  end;

  FileName:=Trim(FileNameEdit.Text);
  If FileName='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOk],0);
    ModalResult:=mrNone; exit;
  end;
  If ExtractFileExt(FileName)='' then FileName:=FileName+'.img';
  FileName:=MakeAbsPath(FileName,PrgSetup.BaseDir);

  Upgrades:=[dicuCopyFolder];
  If MakeBootableCheckBox.Enabled and MakeBootableCheckBox.Checked then Upgrades:=Upgrades+[dicuMakeBootable];
  If AddKeyboardDriverCheckBox.Enabled and AddKeyboardDriverCheckBox.Checked then Upgrades:=Upgrades+[dicuKeyboardDriver];
  If AddMouseDriverCheckBox.Enabled and AddMouseDriverCheckBox.Checked then Upgrades:=Upgrades+[dicuMouseDriver];
  If MemoryManagerCheckBox.Enabled and MemoryManagerCheckBox.Checked then Upgrades:=Upgrades+[dicuMemoryManager];
  If AddFormatCheckBox.Enabled and AddFormatCheckBox.Checked then Upgrades:=Upgrades+[dicuDiskTools];
  If AddEditCheckbox.Enabled and AddEditCheckbox.Checked then Upgrades:=Upgrades+[dicuEditor];

  St:=TStringList.Create;
  try
    St.Add(Dir);
    Size:=DiskImageCreatorUpgradeSize(ImageTypeGroupBox.ItemIndex=1,Upgrades,St);
    If ImageTypeGroupBox.ItemIndex=0 then begin
      If Size>1457664 then begin
        MessageDlg(Format(LanguageSetup.ImageFromFolderNotEnoughSpace,[Size div 1024,1457664 div 1024]),mtError,[mbOk],0);
        ModalResult:=mrNone; exit;
      end;
      If not DiskImageCreator(FileName) then begin ModalResult:=mrNone; exit; end;
    end else begin
      Size:=(Size div 1024 div 1024)+1+FreeSpaceEdit.Value;
      If not DiskImageCreator(Size,FileName,False,True) then begin ModalResult:=mrNone; exit; end;
    end;

    if not DiskImageCreatorUpgrade(FileName,ImageTypeGroupBox.ItemIndex=1,Upgrades,St) then begin
      ModalResult:=mrNone;
      exit;
    end;
  finally
    St.Free;
  end;
end;

procedure TBuildImageFromFolderForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesCreateFromFolder);
end;

procedure TBuildImageFromFolderForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowBuildImageFromFolderDialog(const AOwner : TComponent) : Boolean;
begin
  BuildImageFromFolderForm:=TBuildImageFromFolderForm.Create(AOwner);
  try
    result:=(BuildImageFromFolderForm.ShowModal=mrOK);
    if result and BuildImageFromFolderForm.WriteToFloppyCheckBox.Checked and BuildImageFromFolderForm.WriteToFloppyCheckBox.Enabled then begin
      result:=ShowWriteIMGImageDialog(AOwner,BuildImageFromFolderForm.FileNameEdit.Text);
    end;
  finally
    BuildImageFromFolderForm.Free;
  end;
end;

end.
