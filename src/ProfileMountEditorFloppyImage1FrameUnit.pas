unit ProfileMountEditorFloppyImage1FrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ProfileMountEditorFormUnit;

type
  TProfileMountEditorFloppyImage1Frame = class(TFrame, TProfileMountEditorFrame)
    FloppyImageEdit: TLabeledEdit;
    FloppyImageButton: TSpeedButton;
    FloppyImageCreateButton: TSpeedButton;
    FloppyImageDriveLetterLabel: TLabel;
    FloppyImageDriveLetterComboBox: TComboBox;
    FloppyImageDriveLetterWarningLabel: TLabel;
    DriveLetterInfoLabel1: TLabel;
    OpenDialog: TOpenDialog;
    FloppyPopupMenu: TPopupMenu;
    FloppyPopupCreateImage: TMenuItem;
    FloppyPopupReadImage: TMenuItem;
    procedure FloppyImageButtonClick(Sender: TObject);
    procedure FloppyImageCreateButtonClick(Sender: TObject);
    procedure FloppyImageDriveLetterComboBoxChange(Sender: TObject);
    procedure FloppyPopupWork(Sender: TObject);
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

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, CreateISOImageFormUnit,
     CreateImageUnit, IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorFloppyImage1Frame }

function TProfileMountEditorFloppyImage1Frame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  FloppyImageEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFile;
  FloppyImageDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  FloppyImageDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  DriveLetterInfoLabel1.Caption:=LanguageSetup.ProfileMountingLetterInfo;
  FloppyImageButton.Hint:=LanguageSetup.ChooseFile;
  FloppyImageCreateButton.Hint:=LanguageSetup.ProfileMountingCreateImage;

  FloppyImageDriveLetterComboBox.Items.BeginUpdate;
  try
    FloppyImageDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do FloppyImageDriveLetterComboBox.Items.Add(C);
    FloppyImageDriveLetterComboBox.Items.Add('0');
    FloppyImageDriveLetterComboBox.Items.Add('1');
    FloppyImageDriveLetterComboBox.ItemIndex:=0;
  finally
    FloppyImageDriveLetterComboBox.Items.EndUpdate;
  end;

  FloppyPopupCreateImage.Caption:=LanguageSetup.ProfileMountingFloppyImageCreate;
  FloppyPopupReadImage.Caption:=LanguageSetup.ProfileMountingFloppyImageRead;

  UserIconLoader.DialogImage(DI_SelectFile,FloppyImageButton);
  UserIconLoader.DialogImage(DI_ImageFloppy,FloppyImageCreateButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='FLOPPYIMAGE' then begin
      {ImageFile;FLOPPYIMAGE;Letter;;;}
      result:=True;
      FloppyImageEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=FloppyImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FloppyImageDriveLetterComboBox.ItemIndex:=I;
      end;
    end else begin
      result:=False;
      For I:=0 to FloppyImageDriveLetterComboBox.Items.Count-1 do begin
        If Pos(FloppyImageDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin FloppyImageDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  FloppyImageDriveLetterComboBoxChange(self);
end;

procedure TProfileMountEditorFloppyImage1Frame.ShowFrame;
begin
end;

function TProfileMountEditorFloppyImage1Frame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

function TProfileMountEditorFloppyImage1Frame.Done: String;
begin
  {ImageFile;FLOPPYIMAGE;Letter;;;}
  result:=StringReplace(MakeRelPath(FloppyImageEdit.Text,PrgSetup.BaseDir),';','<semicolon>',[rfReplaceAll])+';FloppyImage;'+FloppyImageDriveLetterComboBox.Text+';;;';
end;

function TProfileMountEditorFloppyImage1Frame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingFloppyImageSheet;
end;

procedure TProfileMountEditorFloppyImage1Frame.FloppyImageButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(FloppyImageEdit.Text)='' then S:=PrgSetup.BaseDir else S:=FloppyImageEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='img';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
  if not OpenDialog.Execute then exit;
  FloppyImageEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorFloppyImage1Frame.FloppyImageCreateButtonClick(Sender: TObject);
Var P : TPoint;
begin
  P:=ClientToScreen(Point(FloppyImageCreateButton.Left,FloppyImageCreateButton.Top));
  FloppyPopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TProfileMountEditorFloppyImage1Frame.FloppyImageDriveLetterComboBoxChange(Sender: TObject);
begin
  FloppyImageDriveLetterWarningLabel.Visible:=(FloppyImageDriveLetterComboBox.ItemIndex>=0) and (Pos(FloppyImageDriveLetterComboBox.Items[FloppyImageDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorFloppyImage1Frame.FloppyPopupWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=ShowCreateImageFileDialog(self,True,False,InfoData.GameDB);
          If S='' then exit;
          FloppyImageEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);;
        end;
    1 : begin
          if not ShowCreateISOImageDialog(self,S,True) then exit;
          If S='' then exit;
          FloppyImageEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
  end;
end;

end.
