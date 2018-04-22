unit SetupFrameFreeDOSUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameFreeDOS = class(TFrame, ISetupFrame)
    PathFREEDOSEdit: TLabeledEdit;
    PathFREEDOSButton: TSpeedButton;
    InfoLabel: TLabel;
    FreeDOSDownloadURLInfo: TLabel;
    FreeDOSDownloadURL: TLabel;
    procedure PathFREEDOSButtonClick(Sender: TObject);
    procedure FreeDOSDownloadURLClick(Sender: TObject);
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

uses ShellAPI, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameFreeDOS }

function TSetupFrameFreeDOS.GetName: String;
begin
  result:=LanguageSetup.SetupFormFreeDOS;
end;

procedure TSetupFrameFreeDOS.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  PBaseDir:=InitData.PBaseDir;

  NoFlicker(PathFREEDOSEdit);

  PathFREEDOSEdit.Text:=PrgSetup.PathToFREEDOS;
end;

procedure TSetupFrameFreeDOS.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameFreeDOS.LoadLanguage;
begin
  PathFREEDOSEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxFREEDOSPath;
  PathFREEDOSButton.Hint:=LanguageSetup.ChooseFolder;
  InfoLabel.Caption:=LanguageSetup.SetupFormFreeDOSInfo;
  FreeDOSDownloadURLInfo.Caption:=LanguageSetup.SetupFormFreeDOSDownloadURL;
  FreeDOSDownloadURL.Caption:='http:/'+'/www.freedos.org/';
  with FreeDOSDownloadURL.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  FreeDOSDownloadURL.Cursor:=crHandPoint;

  UserIconLoader.DialogImage(DI_SelectFolder,PathFREEDOSButton);

  HelpContext:=ID_FileOptionsFreeDOS;
end;

procedure TSetupFrameFreeDOS.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameFreeDOS.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameFreeDOS.HideFrame;
begin
end;

procedure TSetupFrameFreeDOS.RestoreDefaults;
begin
end;

procedure TSetupFrameFreeDOS.SaveSetup;
begin
  PrgSetup.PathToFREEDOS:=PathFREEDOSEdit.Text;
end;

procedure TSetupFrameFreeDOS.PathFREEDOSButtonClick(Sender: TObject);
Var S : String;
begin
  S:=PathFREEDOSEdit.Text;
  If Trim(S)='' then S:=IncludeTrailingPathDelimiter(PBaseDir^);
  S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(PBaseDir^));
  if SelectDirectory(Handle,LanguageSetup.SetupFormFreeDOSDir,S) then begin
    PathFREEDOSEdit.Text:=MakeRelPath(S,IncludeTrailingPathDelimiter(PBaseDir^),True);
  end;
end;

procedure TSetupFrameFreeDOS.FreeDOSDownloadURLClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

end.
