unit SetupFrameDirectoriesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameDirectories = class(TFrame, ISetupFrame)
    BaseDirEdit: TLabeledEdit;
    GameDirEdit: TLabeledEdit;
    DataDirEdit: TLabeledEdit;
    DataDirButton: TSpeedButton;
    GameDirButton: TSpeedButton;
    BaseDirButton: TSpeedButton;
    InfoLabel: TLabel;
    CaptureDirEdit: TLabeledEdit;
    CaptureDirButton: TSpeedButton;
    procedure ButtonWork(Sender: TObject);
    procedure BaseDirEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    PBaseDir : PString;
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools, HelpConsts,
     IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameDirectories }

function TSetupFrameDirectories.GetName: String;
begin
  result:=LanguageSetup.SetupFormDirectoriesSheet;
end;

procedure TSetupFrameDirectories.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(BaseDirEdit);
  NoFlicker(GameDirEdit);
  NoFlicker(DataDirEdit);
  NoFlicker(CaptureDirEdit);

  PBaseDir:=InitData.PBaseDir;

  BaseDirEdit.Text:=PrgSetup.BaseDir;
  GameDirEdit.Text:=PrgSetup.GameDir;
  DataDirEdit.Text:=PrgSetup.DataDir;
  CaptureDirEdit.Text:=MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir);

  UserIconLoader.DialogImage(DI_SelectFolder,BaseDirButton);
  UserIconLoader.DialogImage(DI_SelectFolder,GameDirButton);
  UserIconLoader.DialogImage(DI_SelectFolder,DataDirButton);
  UserIconLoader.DialogImage(DI_SelectFolder,CaptureDirButton);

  HelpContext:=ID_FileOptionsGeneral;
end;

procedure TSetupFrameDirectories.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDirectories.LoadLanguage;
begin
  BaseDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormBaseDir;
  BaseDirButton.Hint:=LanguageSetup.ChooseFolder;
  GameDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormGameDir;
  GameDirButton.Hint:=LanguageSetup.ChooseFolder;
  DataDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDataDir;
  DataDirButton.Hint:=LanguageSetup.ChooseFolder;
  CaptureDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormCaptureDir;
  CaptureDirButton.Hint:=LanguageSetup.ChooseFolder;
  InfoLabel.Caption:=LanguageSetup.SetupFormDirectoriesInfo;
end;

procedure TSetupFrameDirectories.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDirectories.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameDirectories.HideFrame;
begin
end;

procedure TSetupFrameDirectories.RestoreDefaults;
begin
  BaseDirEdit.Text:=PrgDataDir;
  GameDirEdit.Text:=PrgDataDir+'VirtualHD\';
  DataDirEdit.Text:=PrgDataDir+'GameData\';
  DataDirEdit.Text:=PrgDataDir+'Capture\';
end;

procedure TSetupFrameDirectories.SaveSetup;
begin
  PrgSetup.BaseDir:=BaseDirEdit.Text;
  PrgSetup.GameDir:=GameDirEdit.Text;
  PrgSetup.DataDir:=DataDirEdit.Text;
  PrgSetup.CaptureDir:=MakeRelPath(CaptureDirEdit.Text,PrgSetup.BaseDir);
end;

procedure TSetupFrameDirectories.BaseDirEditChange(Sender: TObject);
begin
  PBaseDir^:=BaseDirEdit.Text;
end;

procedure TSetupFrameDirectories.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=BaseDirEdit.Text; If S='' then S:=PrgDataDir;
          if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then BaseDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    1 : begin
          S:=GameDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormGameDir,S) then GameDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    2 : begin
          S:=DataDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDataDir,S) then DataDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    3 : begin
          S:=CaptureDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormCaptureDirSelect,S) then CaptureDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
  end;
end;

end.
