unit RenameAllScreenshotsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, CommonTools;

type
  TRenameAllScreenshotsForm = class(TForm)
    Edit: TEdit;
    InfoLabel: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ThisProfileRadioButton: TRadioButton;
    AllProfilesRadioButton: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  RenameAllScreenshotsForm: TRenameAllScreenshotsForm;

Function RenameMediaFiles(const AOwner : TComponent; const Game : TGame; const GameDB : TGameDB; const RenameFiles : TRenameFiles) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, IconLoaderUnit, PrgSetupUnit;

{$R *.dfm}

procedure TRenameAllScreenshotsForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  InfoLabel.Caption:=LanguageSetup.RenameAllScheme;
  Edit.Text:=PrgSetup.RenameAllExpression;
  ThisProfileRadioButton.Caption:=LanguageSetup.RenameAllThisProfile;
  AllProfilesRadioButton.Caption:=LanguageSetup.RenameAllAllProfiles;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
end;

procedure TRenameAllScreenshotsForm.OKButtonClick(Sender: TObject);
begin
  PrgSetup.RenameAllExpression:=Edit.Text;
end;

{ global }

Function ShowRenameAllScreenshotsDialog(const AOwner : TComponent; const Caption : String; var FileMask : String; var AllProfiles : Boolean; const OnlyAllProfiles : Boolean) : Boolean;
begin
  RenameAllScreenshotsForm:=TRenameAllScreenshotsForm.Create(AOwner);
  try
    RenameAllScreenshotsForm.Caption:=Caption;

    If OnlyAllProfiles then begin
      RenameAllScreenshotsForm.AllProfilesRadioButton.Checked:=True;
      RenameAllScreenshotsForm.ThisProfileRadioButton.Enabled:=False;
      RenameAllScreenshotsForm.AllProfilesRadioButton.Enabled:=False;
    end;

    result:=(RenameAllScreenshotsForm.ShowModal=mrOK);
    if result then begin
      Filemask:=RenameAllScreenshotsForm.Edit.Text;
      AllProfiles:=RenameAllScreenshotsForm.AllProfilesRadioButton.Checked;
    end;
  finally
    RenameAllScreenshotsForm.Free;
  end;
end;

Function RenameMediaFiles(const AOwner : TComponent; const Game : TGame; const GameDB : TGameDB; const RenameFiles : TRenameFiles) : Boolean;
Var Folder, Caption, FileMask : String;
    AllProfiles : Boolean;
    I : Integer;
begin
  result:=False;

  Case RenameFiles of
    rfScreenshots : Caption:=LanguageSetup.RenameAllScreenshots;
    rfSounds : Caption:=LanguageSetup.RenameAllSounds;
    rfVideos : Caption:=LanguageSetup.RenameAllVideos;
    else Caption:=LanguageSetup.RenameAllScreenshots;
  end;

  if not ShowRenameAllScreenshotsDialog(AOwner,Caption,FileMask,AllProfiles,Game=nil) then exit;

  If AllProfiles then begin
    result:=(GameDB.Count>0);
    For I:=0 to GameDB.Count-1 do begin
      Folder:=Trim(GameDB[I].CaptureFolder); If Folder<>'' then Folder:=MakeAbsPath(Folder,PrgSetup.BaseDir); If Folder='' then exit;
      RenameAllFiles(Folder,FileMask,GameDB[I].CacheName,RenameFiles,False);
    end;
  end else begin
    Folder:=Trim(Game.CaptureFolder); If Folder<>'' then Folder:=MakeAbsPath(Folder,PrgSetup.BaseDir); If Folder='' then exit;
    result:=RenameAllFiles(Folder,FileMask,Game.CacheName,RenameFiles,True);
  end;
end;

end.
