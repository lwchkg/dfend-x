unit CreateISOImageFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TCreateISOImageForm = class(TForm)
    DriveLabel: TLabel;
    DriveComboBox: TComboBox;
    FileNameEdit: TLabeledEdit;
    FileNameButton: TSpeedButton;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SaveDialog: TSaveDialog;
    InfoLabel: TLabel;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FileNameButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    FileName : String;
    Drive : Char;
    FloppyMode, WriteMode : Boolean;
  end;

var
  CreateISOImageForm: TCreateISOImageForm;

Function ShowCreateISOImageDialog(const AOwner : TComponent; var AFileName : String; const AFloppyMode : Boolean) : Boolean; overload;
Function ShowCreateISOImageDialog(const AOwner : TComponent; const AFloppyMode : Boolean) : Boolean; overload;
Function ShowWriteIMGImageDialog(const AOwner : TComponent; const ImageFileName : String ='') : Boolean;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, CommonTools,
     DriveReadFormUnit, ReadDriveUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TCreateISOImageForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  FileNameEdit.EditLabel.Caption:=LanguageSetup.ReadImageFileName;
  FileNameButton.Hint:=LanguageSetup.ChooseFile;
  InfoLabel.Caption:=LanguageSetup.ReadImageInfo;
  UserIconLoader.DialogImage(DI_SelectFile,FileNameButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  FloppyMode:=False;
  WriteMode:=False;
end;

procedure TCreateISOImageForm.FormShow(Sender: TObject);
Var C : Char;
    J : Cardinal;
begin
  If FloppyMode then begin
    If WriteMode then begin
      Caption:=LanguageSetup.WriteImageCaptionIMG;
      SaveDialog.Title:=LanguageSetup.WriteImageFileNameTitleIMG;
    end else begin
      Caption:=LanguageSetup.ReadImageCaptionIMG;
      SaveDialog.Title:=LanguageSetup.ReadImageFileNameTitleIMG;
    end;
    DriveLabel.Caption:=LanguageSetup.ReadImageDriveLabelFloppy;
    SaveDialog.Filter:=LanguageSetup.ReadImageFileNameFilterIMG;
    SaveDialog.DefaultExt:='img';

    InfoLabel.Visible:=False;
    OKButton.Top:=InfoLabel.Top+8;
    CancelButton.Top:=InfoLabel.Top+8;
    HelpButton.Top:=InfoLabel.Top+8;
    Height:=(Height-ClientHeight)+OKButton.Top+OKButton.Height+8;
  end else begin
    Caption:=LanguageSetup.ReadImageCaptionISO;
    DriveLabel.Caption:=LanguageSetup.ReadImageDriveLabelCD;
    SaveDialog.Filter:=LanguageSetup.ReadImageFileNameFilterISO;
    SaveDialog.Title:=LanguageSetup.ReadImageFileNameTitleISO;
    SaveDialog.DefaultExt:='iso';
  end;

  For C:='A' to 'Z' do begin
    J:=GetDriveType(PChar(C+':\'));
    If FloppyMode then begin
      If J=DRIVE_REMOVABLE then DriveComboBox.Items.Add(C);
    end else begin
      If J=DRIVE_CDROM then DriveComboBox.Items.Add(C);
    end;
  end;

  If DriveComboBox.Items.Count>0 then DriveComboBox.ItemIndex:=0;
end;

procedure TCreateISOImageForm.FileNameButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(FileNameEdit.Text);
  If S='' then S:=PrgSetup.BaseDir else S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
  SaveDialog.InitialDir:=S;
  If SaveDialog.Execute then FileNameEdit.Text:=SaveDialog.FileName;
end;

procedure TCreateISOImageForm.OKButtonClick(Sender: TObject);
Var S : String;
begin
  If DriveComboBox.ItemIndex<0 then begin
    MessageDlg(LanguageSetup.MessageNoDriveSelected,mtError,[mbOK],0);
    ModalResult:=mrNone;
    exit;
  end;

  If Trim(FileNameEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    ModalResult:=mrNone;
    exit;
  end;

  FileName:=MakeAbsPath(FileNameEdit.Text,PrgSetup.BaseDir);
  S:=DriveComboBox.Items[DriveComboBox.ItemIndex];
  Drive:=S[1];
end;

procedure TCreateISOImageForm.HelpButtonClick(Sender: TObject);
begin
  If FloppyMode then begin
    If WriteMode
      then Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesWriteImageToFloppy)
      else Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesCreateImageFromFloppy);
  end else begin
    Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesCreateImageFromCD);
  end;
end;

procedure TCreateISOImageForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCreateISOImageDialog(const AOwner : TComponent; var AFileName : String; const AFloppyMode : Boolean) : Boolean;
Var ReadResult : TReadDataResult;
    S : String;
    ADrive : Char;
    C : Char;
    B : Boolean;
begin
  result:=False;
  B:=False;
  If AFloppyMode then begin
    For C:='A' to 'Z' do If GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin B:=True; break; end;
  end else begin
    For C:='A' to 'Z' do If GetDriveType(PChar(C+':\'))=DRIVE_CDROM then begin B:=True; break; end;
  end;
  If not B then begin
    If AFloppyMode then S:=LanguageSetup.MessageNoFloppyDrive else S:=LanguageSetup.MessageNoCDDrive;
    MessageDlg(S,mtError,[mbOk],0);
    exit;
  end;

  CreateISOImageForm:=TCreateISOImageForm.Create(AOwner);
  try
    CreateISOImageForm.FloppyMode:=AFloppyMode;
    result:=(CreateISOImageForm.ShowModal=mrOK);
    if result then begin
      AFileName:=CreateISOImageForm.FileName;
      ADrive:=CreateISOImageForm.Drive;
      ReadResult:=ShowDriveReadDialog(AOwner,ADrive,AFileName);
      result:=(ReadResult=RD_OK);
      Case ReadResult of
        RD_CannotOpen              : S:=Format(LanguageSetup.MessageCouldNotDriveOpen,[String(ADrive)]);
        RD_CannotGetDriveData      : S:=Format(LanguageSetup.MessageCouldNotDriveGetData,[String(ADrive)]);
        RD_CannotSetExtendedAccess : S:=Format(LanguageSetup.MessageCouldNotDriveSetExtAccess,[String(ADrive)]);
        RD_CannotOpenOutputFile    : S:=Format(LanguageSetup.MessageCouldNotSaveFile,[AFileName]);
        RD_ReadError               : S:=Format(LanguageSetup.MessageCouldNotDriveReadError,[String(ADrive)]);
        else exit;
      end;
      MessageDlg(S,mtError,[mbOK],0);
    end;
  finally
    CreateISOImageForm.Free;
  end;
end;

Function ShowCreateISOImageDialog(const AOwner : TComponent; const AFloppyMode : Boolean) : Boolean;
Var AFileName : String;
begin
  result:=ShowCreateISOImageDialog(AOwner,AFileName,AFloppyMode);
end;

Function ShowWriteIMGImageDialog(const AOwner : TComponent; const ImageFileName : String) : Boolean;
Var ReadResult : TReadDataResult;
    S, AFileName : String;
    ADrive : Char;
    C : Char;
    B : Boolean;
begin
  result:=False;
  B:=False; For C:='A' to 'Z' do If GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin B:=True; break; end;
  If not B then begin
    MessageDlg(LanguageSetup.MessageNoFloppyDrive,mtError,[mbOk],0);
    exit;
  end;

  CreateISOImageForm:=TCreateISOImageForm.Create(AOwner);
  try
    CreateISOImageForm.FloppyMode:=True;
    CreateISOImageForm.WriteMode:=True;
    CreateISOImageForm.FileNameEdit.Text:=ImageFileName;
    result:=(CreateISOImageForm.ShowModal=mrOK);
    if result then begin
      AFileName:=CreateISOImageForm.FileName;
      ADrive:=CreateISOImageForm.Drive;
      ReadResult:=ShowDriveWriteDialog(AOwner,ADrive,AFileName);
      result:=(ReadResult=RD_OK);
      Case ReadResult of
        RD_CannotOpen              : S:=Format(LanguageSetup.MessageCouldNotDriveOpen,[String(ADrive)]);
        RD_CannotGetDriveData      : S:=Format(LanguageSetup.MessageCouldNotDriveGetData,[String(ADrive)]);
        RD_CannotSetExtendedAccess : S:=Format(LanguageSetup.MessageCouldNotDriveSetExtAccess,[String(ADrive)]);
        RD_CannotOpenInputFile     : S:=Format(LanguageSetup.MessageCouldNotOpenFile,[AFileName]);
        RD_WriteError              : S:=Format(LanguageSetup.MessageCouldNotDriveWriteError,[String(ADrive)]);
        else exit;
      end;
      MessageDlg(S,mtError,[mbOK],0);
    end;
  finally
    CreateISOImageForm.Free;
  end;

end;


end.
