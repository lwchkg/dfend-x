unit ProfileMountEditorHDImageFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit;

type
  TProfileMountEditorHDImageFrame = class(TFrame, TProfileMountEditorFrame)
    ImageEdit: TLabeledEdit;
    ImageButton: TSpeedButton;
    ImageCreateButton: TSpeedButton;
    ImageGeometryEdit: TLabeledEdit;
    ImageDriveLetterComboBox: TComboBox;
    ImageDriveLetterLabel: TLabel;
    DriveLetterInfoLabel2: TLabel;
    HDImageDriveLetterWarningLabel: TLabel;
    OpenDialog: TOpenDialog;
    procedure ImageButtonClick(Sender: TObject);
    procedure ImageCreateButtonClick(Sender: TObject);
    procedure ImageDriveLetterComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function CheckBeforeDone : Boolean;
    Function Done : String;
    Function GetName : String;
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, ImageTools, CreateImageUnit,
     IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorHDImageFrame }

function TProfileMountEditorHDImageFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  ImageEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFile;
  ImageGeometryEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingGeometry;
  ImageDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  HDImageDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  DriveLetterInfoLabel2.Caption:=LanguageSetup.ProfileMountingLetterInfo;
  ImageButton.Hint:=LanguageSetup.ChooseFile;
  ImageCreateButton.Hint:=LanguageSetup.ProfileMountingCreateImage;

  ImageDriveLetterComboBox.Items.BeginUpdate;
  try
    ImageDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do ImageDriveLetterComboBox.Items.Add(C);
    ImageDriveLetterComboBox.Items.Add('2');
    ImageDriveLetterComboBox.Items.Add('3');
    ImageDriveLetterComboBox.ItemIndex:=3;
  finally
    ImageDriveLetterComboBox.Items.EndUpdate;
  end;

  UserIconLoader.DialogImage(DI_SelectFile,ImageButton);
  UserIconLoader.DialogImage(DI_ImageHD,ImageCreateButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='IMAGE' then begin
      {ImageFile;IMAGE;LetterOR23;;;geometry}
      result:=True;
      ImageEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=ImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        ImageDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        ImageGeometryEdit.Text:=St[5];
      end;
    end else begin
      result:=False;
      For I:=2 to ImageDriveLetterComboBox.Items.Count-1 do begin
        If Pos(ImageDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin ImageDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  ImageDriveLetterComboBoxChange(self);
end;

procedure TProfileMountEditorHDImageFrame.ShowFrame;
begin
end;

function TProfileMountEditorHDImageFrame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

function TProfileMountEditorHDImageFrame.Done: String;
begin
  {ImageFile;IMAGE;LetterOR23;;;geometry}
  result:=StringReplace(MakeRelPath(ImageEdit.Text,PrgSetup.BaseDir),';','<semicolon>',[rfReplaceAll])+';Image;'+ImageDriveLetterComboBox.Text+';;;'+ImageGeometryEdit.Text;
end;

function TProfileMountEditorHDImageFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingImageSheet;
end;

procedure TProfileMountEditorHDImageFrame.ImageButtonClick(Sender: TObject);
Var s : String;
begin
  If Trim(ImageEdit.Text)='' then S:=PrgSetup.BaseDir else S:=ImageEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='img';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
  if not OpenDialog.Execute then exit;
  ImageEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
  ImageGeometryEdit.Text:=GetGeometryFromFile(OpenDialog.FileName);
end;

procedure TProfileMountEditorHDImageFrame.ImageCreateButtonClick(Sender: TObject);
Var S : String;
begin
  S:=ShowCreateImageFileDialog(self,False,True,InfoData.GameDB);
  If S='' then exit;
  ImageEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
  ImageGeometryEdit.Text:=GetGeometryFromFile(S);
end;

procedure TProfileMountEditorHDImageFrame.ImageDriveLetterComboBoxChange(Sender: TObject);
begin
  HDImageDriveLetterWarningLabel.Visible:=(ImageDriveLetterComboBox.ItemIndex>=0) and (Pos(ImageDriveLetterComboBox.Items[ImageDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

end.
