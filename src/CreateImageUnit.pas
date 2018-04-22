unit CreateImageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, GameDBUnit;

type
  TCreateImageForm = class(TForm)
    PageControl: TPageControl;
    FloppyImageSheet: TTabSheet;
    HDImageSheet: TTabSheet;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ImageList: TImageList;
    FloppyImageTypeComboBox: TComboBox;
    FloppyImageTypeLabel: TLabel;
    FloppyCylindersLabel: TLabel;
    FloppyHeadsLabel: TLabel;
    FloppySPTLabel: TLabel;
    FloppyCylindersComboBox: TComboBox;
    FloppyHeadsComboBox: TComboBox;
    FloppySPTComboBox: TComboBox;
    FloppyImageSizeEdit: TLabeledEdit;
    OpenDialog: TOpenDialog;
    HDSizeEdit: TLabeledEdit;
    HDGeometryEdit: TLabeledEdit;
    HelpButton: TBitBtn;
    ImageFileEdit: TLabeledEdit;
    CompressedCheckBox: TCheckBox;
    ImageFileButton: TSpeedButton;
    MakeBootableCheckBox: TCheckBox;
    NeedFreeDOSLabel: TLabel;
    AddKeyboardDriverCheckBox: TCheckBox;
    AddMouseDriverCheckBox: TCheckBox;
    AddFormatCheckBox: TCheckBox;
    AddEditCheckbox: TCheckBox;
    FormatImageCheckBox: TCheckBox;
    MemoryManagerCheckBox: TCheckBox;
    WriteToFloppyCheckBox: TCheckBox;
    AddDoszipCheckBox: TCheckBox;
    CreateProfileCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ImageFileButtonClick(Sender: TObject);
    procedure FloppyImageTypeComboBoxChange(Sender: TObject);
    procedure FloppyDataChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HDSizeEditChange(Sender: TObject);
    procedure MakeBootableCheckBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PageControlChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
    FloppyDriveAvailable : Boolean;
    Procedure CalcFloppySize;
    Procedure CreateProfile(const Name, ImageFile : String; const FloppyDiskImage : Boolean);
  public
    { Public-Deklarationen }
    FloppyImageSize : Integer;
    ImageFileName : String;
    GameDB : TGameDB;
  end;

var
  CreateImageForm: TCreateImageForm;

Function ShowCreateImageFileDialog(const AOwner : TComponent; const ShowFloppySheet, ShowHDSheet : Boolean; const AGameDB : TGameDB) : String;

var NewProfileFromImageCreator : TGame = nil;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, CommonTools,
     PrgConsts, ImageTools, HelpConsts, IconLoaderUnit, CreateImageToolsUnit,
     CreateISOImageFormUnit;

{$R *.dfm}

{
Sectors=cyl*heads*spt*bps; (spt=Sectors per Track; bps=Bytes per Sector=512)

Floppy Formats:

cyl=40; heads=1; spt= 8;   160kb= 163840 (5,25" Single-Sided, Double Density (DD))
cyl=40; heads=1; spt= 9;   180kb= 184320 (5,25" Single-Sided, Double Density (DD))
cyl=40; heads=2; spt= 8;   320kb= 327680 (5,25" Double-Sided, Double Density (DD))
cyl=40; heads=2; spt= 9;   360kb= 368640 (5,25" Double-Sided, Double Density (DD))
cyl=80; heads=2; spt= 9;   720kb= 737280 (3,5" Double-Sided, Double Density (DD))
cyl=80; heads=2; spt=15;  1200kb=1228800 (5,25" Double-Sided, High-Density (HD))
cyl=80; heads=2; spt=18;  1440kb=1474560 (3,5" Double-Sided, High-Density (HD))
cyl=80; heads=2; spt=21;  1680kb=1720320 (3,5" Double-Sided, Custom Density)
cyl=82; heads=2; spt=21;  1720kb=1763328 (3,5" Double-Sided, Custom Density)
cyl=80; heads=2; spt=36;  2880kb=2949120 (3,5" Double-Sided, Extended Density (ED))

HD Formats:
cyl=63; heads=16; spt=X
}

var FloppyCylinders : Array[0..7] of Integer = (40, 40, 40, 40, 80, 80, 80, 80);
    FloppyHeads     : Array[0..7] of Integer = ( 1,  1,  2,  2,  2,  2,  2,  2);
    FloppySPT       : Array[0..7] of Integer = ( 8,  9,  8,  9,  9, 15, 18, 36);

const FloppyDefault=6;

procedure TCreateImageForm.FormCreate(Sender: TObject);
Var I : Integer;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  FloppyImageSizeEdit.Color:=clBtnFace;
  HDGeometryEdit.Color:=clBtnFace;

  Caption:=LanguageSetup.CreateImageForm;
  FloppyImageSheet.Caption:=LanguageSetup.ProfileMountingFloppyImageSheet;
  HDImageSheet.Caption:=LanguageSetup.ProfileMountingImageSheet;
  FloppyImageTypeLabel.Caption:=LanguageSetup.CreateImageFormFloppyImageType;
  FloppyCylindersLabel.Caption:=LanguageSetup.CreateImageFormCylinders;
  FloppyHeadsLabel.Caption:=LanguageSetup.CreateImageFormHeads;
  FloppySPTLabel.Caption:=LanguageSetup.CreateImageFormSPT;
  FloppyImageSizeEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormFloppyImageSize;
  ImageFileEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormFilename;
  ImageFileButton.Hint:=LanguageSetup.ChooseFile;
  CompressedCheckBox.Caption:=LanguageSetup.CreateImageFormCompression;
  MakeBootableCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootable;
  NeedFreeDOSLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  AddKeyboardDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithKeyboardDriver;
  AddMouseDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMouseDriver;
  MemoryManagerCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMemoryManager;
  AddFormatCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithFormat;
  AddEditCheckbox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithEdit;
  AddDoszipCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithDoszip;
  HDSizeEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormHDImageSize;
  HDGeometryEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormHDImageGeometry;
  FormatImageCheckBox.Caption:=LanguageSetup.CreateImageFormFormat;
  WriteToFloppyCheckBox.Caption:=LanguageSetup.ImageFromFolderWriteToFloppy;
  CreateProfileCheckBox.Caption:=LanguageSetup.CreateImageFormCreateProfile;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_SelectFile,ImageFileButton);
  UserIconLoader.DialogImage(DI_ImageFloppy,ImageList,0);
  UserIconLoader.DialogImage(DI_ImageHD,ImageList,1);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    NeedFreeDOSLabel.Font.Color:=clGrayText;
  end else begin
    NeedFreeDOSLabel.Font.Color:=clRed;
  end;

  If FileExists(PrgDir+MakeDOSFilesystemFileName) or FileExists(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName) then begin
    FloppyCylindersComboBox.Items.Add('40');
    FloppyCylindersComboBox.Items.Add('80');
    FloppySPTComboBox.Items.Add('8');
    FloppySPTComboBox.Items.Add('9');
    FloppySPTComboBox.Items.Add('15');
    FloppySPTComboBox.Items.Add('18');
    FloppySPTComboBox.Items.Add('36');
  end else begin
    For I:=1 to 100 do FloppyCylindersComboBox.Items.Add(IntToStr(I));
    For I:=1 to 40 do FloppySPTComboBox.Items.Add(IntToStr(I));
  end;
  For I:=1 to 2 do FloppyHeadsComboBox.Items.Add(IntToStr(I));
  FloppyImageTypeComboBox.Items.Add('5,25" single-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" single-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" double-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" double-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('3,5" double-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" double-sided, high-density (HD)');
  FloppyImageTypeComboBox.Items.Add('3,5" double-sided, high-density (HD)');
  FloppyImageTypeComboBox.Items.Add('3,5" double-sided, extended density (ED)');
  FloppyImageTypeComboBox.Items.Add('Custom format');

  JustChanging:=False;
  FloppyImageTypeComboBox.ItemIndex:=FloppyDefault;
  FloppyImageTypeComboBoxChange(Sender);
  HDSizeEditChange(Sender);

  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilterImgOnly;
end;

procedure TCreateImageForm.FormShow(Sender: TObject);
Var C : Char;
begin
  FloppyDriveAvailable:=False;
  For C:='A' to 'Z' do If GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin FloppyDriveAvailable:=True; break; end;
  PageControlChange(Sender);
end;

procedure TCreateImageForm.FloppyImageTypeComboBoxChange(Sender: TObject);
begin
  If JustChanging then exit;
  If FloppyImageTypeComboBox.ItemIndex=8 then exit;

  JustChanging:=True;
  try
    FloppyCylindersComboBox.ItemIndex:=
      FloppyCylindersComboBox.Items.IndexOf(IntToStr(FloppyCylinders[FloppyImageTypeComboBox.ItemIndex]));
    FloppyHeadsComboBox.ItemIndex:=
      FloppyHeadsComboBox.Items.IndexOf(IntToStr(FloppyHeads[FloppyImageTypeComboBox.ItemIndex]));
    FloppySPTComboBox.ItemIndex:=
      FloppySPTComboBox.Items.IndexOf(IntToStr(FloppySPT[FloppyImageTypeComboBox.ItemIndex]));
    CalcFloppySize;
  finally
    JustChanging:=False;
  end;
end;

procedure TCreateImageForm.FloppyDataChange(Sender: TObject);
Var I : Integer;
begin
  If JustChanging then exit;
  JustChanging:=True;
  try
    For I:=0 to 7 do If (StrToInt(FloppyCylindersComboBox.Text)=FloppyCylinders[I]) and (StrToInt(FloppyHeadsComboBox.Text)=FloppyHeads[I]) and (StrToInt(FloppySPTComboBox.Text)=FloppySPT[I]) then begin
      FloppyImageTypeComboBox.ItemIndex:=I;
      exit;
    end;
    FloppyImageTypeComboBox.ItemIndex:=8;
  finally
    JustChanging:=False;
    CalcFloppySize;
  end;
end;

procedure TCreateImageForm.CalcFloppySize;
begin
  FloppyImageSize:=512*StrToInt(FloppyCylindersComboBox.Text)*StrToInt(FloppyHeadsComboBox.Text)*StrToInt(FloppySPTComboBox.Text);
  FloppyImageSizeEdit.Text:=Format('%s Bytes = %s KB',[IntToStr(FloppyImageSize),IntToStr(FloppyImageSize div 1024)]);
end;

procedure TCreateImageForm.ImageFileButtonClick(Sender: TObject);
begin
  If ImageFileEdit.Text=''
    then OpenDialog.InitialDir:=PrgSetup.BaseDir
    else OpenDialog.InitialDir:=ExtractFilePath(ImageFileEdit.Text);
  if not OpenDialog.Execute then exit;
  ImageFileEdit.Text:=OpenDialog.FileName;
end;

procedure TCreateImageForm.HDSizeEditChange(Sender: TObject);
begin
  HDGeometryEdit.Text:='';
  try
    HDGeometryEdit.Text:=GetGemoetryFromMB(StrToInt(HDSizeEdit.Text));
  except
    exit;
  end;
end;

procedure TCreateImageForm.MakeBootableCheckBoxClick(Sender: TObject);
begin
  MakeBootableCheckBox.Enabled:=FormatImageCheckBox.Checked;
  AddKeyboardDriverCheckBox.Enabled:=MakeBootableCheckBox.Enabled and MakeBootableCheckBox.Checked;
  AddMouseDriverCheckBox.Enabled:=MakeBootableCheckBox.Enabled and MakeBootableCheckBox.Checked;
  MemoryManagerCheckBox.Enabled:=MakeBootableCheckBox.Enabled and MakeBootableCheckBox.Checked;
  AddFormatCheckBox.Enabled:=FormatImageCheckBox.Checked;
  AddEditCheckbox.Enabled:=FormatImageCheckBox.Checked;
  AddDoszipCheckBox.Enabled:=FormatImageCheckBox.Checked and DosZipAvailable;
  CreateProfileCheckBox.Enabled:=MakeBootableCheckBox.Enabled and MakeBootableCheckBox.Checked;
end;

procedure TCreateImageForm.OKButtonClick(Sender: TObject);
Var I,NeededSize,AvailableSize : Integer;
    Upgrades : TDiskImageCreatorUpgrades;
    S : String;
begin
  {Checks}
  ImageFileName:=ImageFileEdit.Text;
  If Trim(ImageFileName)='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;
  If ExtractFileExt(ImageFileName)='' then ImageFileName:=ImageFileName+'.img';
  ImageFileName:=MakeAbsPath(ImageFileName,PrgSetup.BaseDir);
  If FileExists(ImageFileName) then begin
    If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[ImageFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
      ModalResult:=mrNone; exit;
    end;
    ExtDeleteFile(ImageFileName,ftProfile);
  end;

  Upgrades:=[];
  If FormatImageCheckBox.Checked then begin
    If MakeBootableCheckBox.Checked then Upgrades:=Upgrades+[dicuMakeBootable];
    If AddKeyboardDriverCheckBox.Enabled and AddKeyboardDriverCheckBox.Checked then Upgrades:=Upgrades+[dicuKeyboardDriver];
    If AddMouseDriverCheckBox.Enabled and AddMouseDriverCheckBox.Checked then Upgrades:=Upgrades+[dicuMouseDriver];
    If MemoryManagerCheckBox.Enabled and MemoryManagerCheckBox.Checked then Upgrades:=Upgrades+[dicuMemoryManager];
    If AddFormatCheckBox.Enabled and AddFormatCheckBox.Checked then Upgrades:=Upgrades+[dicuDiskTools];
    If AddEditCheckbox.Enabled and AddEditCheckbox.Checked then Upgrades:=Upgrades+[dicuEditor];
    If AddDoszipCheckBox.Enabled and AddDoszipCheckBox.Checked then Upgrades:=Upgrades+[dicuDoszip];
    If FD11ToolsAvailable then Upgrades:=Upgrades+[dicuUseFD11Tools];
    NeededSize:=DiskImageCreatorUpgradeSize(PageControl.ActivePageIndex=1,Upgrades);
    If PageControl.ActivePageIndex=0 then begin
      AvailableSize:=FloppyImageSize
    end else begin
      try
        AvailableSize:=StrToInt(HDSizeEdit.Text)*1024*1024;
      except
        MessageDlg(LanguageSetup.MessageWrongDiskSize,mtError,[mbOK],0);
        ModalResult:=mrNone; exit;
      end;
    end;
    If NeededSize>AvailableSize then begin
      MessageDlg(Format(LanguageSetup.ImageFromFolderNotEnoughSpace,[NeededSize div 1024,AvailableSize div 1024]),mtError,[mbOk],0);
      ModalResult:=mrNone; exit;
    end;
  end;

  {Create mkdosfs or plain image}
  If PageControl.ActivePageIndex=0 then begin
    if not DiskImageCreator(
      StrToInt(FloppyCylindersComboBox.Text),
      StrToInt(FloppyHeadsComboBox.Text),
      StrToInt(FloppySPTComboBox.Text),
      ImageFileName,
      CompressedCheckBox.Checked,
      FormatImageCheckBox.Checked
    ) then begin ModalResult:=mrNone; exit; end;
  end else begin
    try
      I:=StrToInt(HDSizeEdit.Text);
    except
      MessageDlg(LanguageSetup.MessageWrongDiskSize,mtError,[mbOK],0);
      ModalResult:=mrNone; exit;
    end;
    if not DiskImageCreator(I,ImageFileName,CompressedCheckBox.Checked,FormatImageCheckBox.Checked) then begin ModalResult:=mrNone; exit; end;
  end;

  {Make bootable, add files etc.}
  if Upgrades<>[] then begin
    DiskImageCreatorUpgrade(
      ImageFileName,
      PageControl.ActivePageIndex=1,
      Upgrades,
      nil,
      nil,
      nil,
      nil,
      StrToInt(FloppyCylindersComboBox.Text),
      StrToInt(FloppyHeadsComboBox.Text),
      StrToInt(FloppySPTComboBox.Text),
      );
  end;

  {Create profile for image}
  if CreateProfileCheckBox.Enabled and CreateProfileCheckBox.Checked then begin
    S:=Format(LanguageSetup.CreateImageFormCreateProfileName,[ExtractFileName(ImageFileName)]);
    If InputQuery(LanguageSetup.CreateImageFormCreateProfileNameCaption,LanguageSetup.CreateImageFormCreateProfileNamePrompt,S) then CreateProfile(S,ImageFileName,PageControl.ActivePageIndex=0);
  end;
end;

procedure TCreateImageForm.CreateProfile(const Name, ImageFile: String; const FloppyDiskImage: Boolean);
Var I : Integer;
    NewProfile : TGame;
    S : String;
begin
  {Setup new profile}
  I:=GameDB.Add(Name);
  NewProfile:=GameDB[I];
  with NewProfile do begin
    If FloppyDiskImage then begin
      NrOfMounts:=0;
      AutoexecBootImage:=MakeRelPath(ImageFile,PrgSetup.BaseDir);
    end else begin
      NrOfMounts:=1;
      Mount0:=MakeRelPath(ImageFile,PrgSetup.BaseDir)+';IMAGE;2;;;'+GetGeometryFromFile(ImageFile);
      AutoexecBootImage:='2';
    end;
  end;

  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(NewProfile.Name)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    Inc(I);
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(NewProfile.Name)+IntToStr(I)+'\';
  end;
  NewProfile.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);

  NewProfile.StoreAllValues;
  NewProfile.LoadCache;
  NewProfileFromImageCreator:=NewProfile;
end;

procedure TCreateImageForm.PageControlChange(Sender: TObject);
begin
  WriteToFloppyCheckBox.Enabled:=(PageControl.ActivePageIndex=0) and FloppyDriveAvailable;
end;

procedure TCreateImageForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesCreateImage);
end;

procedure TCreateImageForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCreateImageFileDialog(const AOwner : TComponent; const ShowFloppySheet, ShowHDSheet : Boolean; const AGameDB : TGameDB) : String;
begin
  NewProfileFromImageCreator:=nil;
  CreateImageForm:=TCreateImageForm.Create(AOwner);
  try
    CreateImageForm.FloppyImageSheet.TabVisible:=ShowFloppySheet;
    CreateImageForm.HDImageSheet.TabVisible:=ShowHDSheet;
    CreateImageForm.GameDB:=AGameDB;
    If CreateImageForm.ShowModal=mrOk then result:=CreateImageForm.ImageFileName else result:='';
    if (result<>'') and CreateImageForm.WriteToFloppyCheckBox.Checked and CreateImageForm.WriteToFloppyCheckBox.Enabled then begin
      ShowWriteIMGImageDialog(AOwner,CreateImageForm.ImageFileEdit.Text);
    end;
  finally
    CreateImageForm.Free;
  end;
end;

end.
