unit SetupFrameViewerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, SetupFormUnit;

type
  TSetupFrameViewer = class(TFrame, ISetupFrame)
    PrgOpenDialog: TOpenDialog;
    ScrollBox: TScrollBox;
    VideosGroupBox: TGroupBox;
    VideosButton: TSpeedButton;
    VideosRadioButton1: TRadioButton;
    VideosRadioButton2: TRadioButton;
    VideosRadioButton3: TRadioButton;
    VideosEdit: TEdit;
    SoundsGroupBox: TGroupBox;
    SoundsButton: TSpeedButton;
    SoundsRadioButton1: TRadioButton;
    SoundsRadioButton2: TRadioButton;
    SoundsRadioButton3: TRadioButton;
    SoundsEdit: TEdit;
    ImagesGroupBox: TGroupBox;
    ImagesButton: TSpeedButton;
    ImagesRadioButton1: TRadioButton;
    ImagesRadioButton2: TRadioButton;
    ImagesRadioButton3: TRadioButton;
    ImagesEdit: TEdit;
    ModalImageViewerCheckBox: TCheckBox;
    procedure ButtonWork(Sender: TObject);
    procedure ImagesEditChange(Sender: TObject);
    procedure SoundsEditChange(Sender: TObject);
    procedure VideosEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses ShlObj, CommonTools, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameViewer }

function TSetupFrameViewer.GetName: String;
begin
  result:=LanguageSetup.SetupFormTextMediaViewer;
end;

procedure TSetupFrameViewer.InitGUIAndLoadSetup(var InitData: TInitData);
Var S : String;
begin
  NoFlicker(ImagesGroupBox);
  NoFlicker(ImagesRadioButton1);
  NoFlicker(ImagesRadioButton2);
  NoFlicker(ImagesRadioButton3);
  NoFlicker(ImagesEdit);
  NoFlicker(SoundsGroupBox);
  NoFlicker(SoundsRadioButton1);
  NoFlicker(SoundsRadioButton2);
  NoFlicker(SoundsRadioButton3);
  NoFlicker(SoundsEdit);
  NoFlicker(VideosGroupBox);
  NoFlicker(VideosRadioButton1);
  NoFlicker(VideosRadioButton2);
  NoFlicker(VideosRadioButton3);
  NoFlicker(VideosEdit);

  S:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
  If (S='INTERNAL') or (S='') then ImagesRadioButton1.Checked:=True else begin
    If S='DEFAULT' then ImagesRadioButton2.Checked:=True else begin
      ImagesRadioButton3.Checked:=True;
      ImagesEdit.Text:=MakeRelPath(PrgSetup.ImageViewer,PrgSetup.BaseDir);
    end;
  end;
  ModalImageViewerCheckBox.Checked:=not PrgSetup.NonModalViewer;

  S:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
  If (S='INTERNAL') or (S='') then SoundsRadioButton1.Checked:=True else begin
    If S='DEFAULT' then SoundsRadioButton2.Checked:=True else begin
      SoundsRadioButton3.Checked:=True;
      SoundsEdit.Text:=MakeRelPath(PrgSetup.SoundPlayer,PrgSetup.BaseDir);
    end;
  end;

  S:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
  If (S='INTERNAL') or (S='') then VideosRadioButton1.Checked:=True else begin
    If S='DEFAULT' then VideosRadioButton2.Checked:=True else begin
      VideosRadioButton3.Checked:=True;
      VideosEdit.Text:=MakeRelPath(PrgSetup.VideoPlayer,PrgSetup.BaseDir);
    end;
  end;

  UserIconLoader.DialogImage(DI_SelectFile,ImagesButton);
  UserIconLoader.DialogImage(DI_SelectFile,SoundsButton);
  UserIconLoader.DialogImage(DI_SelectFile,VideosButton);
end;

procedure TSetupFrameViewer.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameViewer.LoadLanguage;
begin
  ImagesGroupBox.Caption:=LanguageSetup.SetupFormTextMediaViewerImages;
  SoundsGroupBox.Caption:=LanguageSetup.SetupFormTextMediaViewerSounds;
  VideosGroupBox.Caption:=LanguageSetup.SetupFormTextMediaViewerVideos;

  ImagesRadioButton1.Caption:=LanguageSetup.SetupFormTextMediaViewerInterval;
  ImagesRadioButton2.Caption:=LanguageSetup.SetupFormTextMediaViewerDefault;
  ImagesRadioButton3.Caption:=LanguageSetup.SetupFormTextMediaViewerCustom;
  ImagesButton.Hint:=LanguageSetup.ChooseFile;
  ModalImageViewerCheckBox.Caption:=LanguageSetup.SetupFormTextMediaViewerModal;
  SoundsRadioButton1.Caption:=LanguageSetup.SetupFormTextMediaViewerInterval;
  SoundsRadioButton2.Caption:=LanguageSetup.SetupFormTextMediaViewerDefault;
  SoundsRadioButton3.Caption:=LanguageSetup.SetupFormTextMediaViewerCustom;
  SoundsButton.Hint:=LanguageSetup.ChooseFile;
  VideosRadioButton1.Caption:=LanguageSetup.SetupFormTextMediaViewerInterval;
  VideosRadioButton2.Caption:=LanguageSetup.SetupFormTextMediaViewerDefault;
  VideosRadioButton3.Caption:=LanguageSetup.SetupFormTextMediaViewerCustom;
  VideosButton.Hint:=LanguageSetup.ChooseFile;

  PrgOpenDialog.Title:=LanguageSetup.SetupFormTextMediaViewerCustomOpenCaption;
  PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;

  HelpContext:=ID_FileOptionsMediaViewers;
end;

procedure TSetupFrameViewer.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameViewer.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameViewer.HideFrame;
begin
end;

procedure TSetupFrameViewer.RestoreDefaults;
begin
  ImagesEdit.Text:='';
  ImagesRadioButton1.Checked:=True;
  ModalImageViewerCheckBox.Checked:=True;
  SoundsEdit.Text:='';
  SoundsRadioButton1.Checked:=True;
  VideosEdit.Text:='';
  VideosRadioButton1.Checked:=True;
end;

procedure TSetupFrameViewer.SaveSetup;
begin
  If ImagesRadioButton1.Checked then PrgSetup.ImageViewer:='Internal';
  If ImagesRadioButton2.Checked then PrgSetup.ImageViewer:='Default';
  If ImagesRadioButton3.Checked then PrgSetup.ImageViewer:=MakeRelPath(ImagesEdit.Text,PrgSetup.BaseDir);
  PrgSetup.NonModalViewer:=not ModalImageViewerCheckBox.Checked;

  If SoundsRadioButton1.Checked then PrgSetup.SoundPlayer:='Internal';
  If SoundsRadioButton2.Checked then PrgSetup.SoundPlayer:='Default';
  If SoundsRadioButton3.Checked then PrgSetup.SoundPlayer:=MakeRelPath(SoundsEdit.Text,PrgSetup.BaseDir);

  If VideosRadioButton1.Checked then PrgSetup.VideoPlayer:='Internal';
  If VideosRadioButton2.Checked then PrgSetup.VideoPlayer:='Default';
  If VideosRadioButton3.Checked then PrgSetup.VideoPlayer:=MakeRelPath(VideosEdit.Text,PrgSetup.BaseDir);
end;

procedure TSetupFrameViewer.ImagesEditChange(Sender: TObject);
begin
  ImagesRadioButton3.Checked:=True;
end;

procedure TSetupFrameViewer.SoundsEditChange(Sender: TObject);
begin
  SoundsRadioButton3.Checked:=True;
end;

procedure TSetupFrameViewer.VideosEditChange(Sender: TObject);
begin
  VideosRadioButton3.Checked:=True;
end;

procedure TSetupFrameViewer.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : S:=ImagesEdit.Text;
    1 : S:=SoundsEdit.Text;
    2 : S:=VideosEdit.Text;
  end;

  S:=Trim(S); If S<>'' then S:=ExtractFilePath(S);
  If S='' then S:=GetSpecialFolder(Handle,CSIDL_PROGRAM_FILES);
  If S<>'' then PrgOpenDialog.InitialDir:=S;
  If not PrgOpenDialog.Execute then exit;

  Case (Sender as TComponent).Tag of
    0 : begin ImagesRadioButton3.Checked:=True; ImagesEdit.Text:=PrgOpenDialog.FileName; end;
    1 : begin SoundsRadioButton3.Checked:=True; SoundsEdit.Text:=PrgOpenDialog.FileName; end;
    2 : begin VideosRadioButton3.Checked:=True; VideosEdit.Text:=PrgOpenDialog.FileName; end;
  end;
end;

end.
