unit SetupFrameQBasicUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameQBasic = class(TFrame, ISetupFrame)
    QBasicEdit: TLabeledEdit;
    QBasicButton: TSpeedButton;
    FindQBasicButton: TSpeedButton;
    QBasicParamEdit: TLabeledEdit;
    QBasicDownloadURLInfo: TLabel;
    QBasicDownloadURL: TLabel;
    PrgOpenDialog: TOpenDialog;
    procedure ButtonWork(Sender: TObject);
    procedure QBasicDownloadURLClick(Sender: TObject);
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

uses ShellAPI, ShlObj, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     CommonTools, SetupDosBoxFormUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameQBasic }

function TSetupFrameQBasic.GetName: String;
begin
  result:=LanguageSetup.SetupFormQBasicSheet;
end;

procedure TSetupFrameQBasic.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  PBaseDir:=InitData.PBaseDir;

  NoFlicker(QBasicEdit);
  NoFlicker(QBasicParamEdit);

  QBasicEdit.Text:=PrgSetup.QBasic;
  QBasicParamEdit.Text:=PrgSetup.QBasicParam;
end;

procedure TSetupFrameQBasic.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameQBasic.LoadLanguage;
begin
  QBasicEdit.EditLabel.Caption:=LanguageSetup.SetupFormQBasicFile;
  QBasicButton.Hint:=LanguageSetup.ChooseFile;
  FindQBasicButton.Hint:=LanguageSetup.SetupFormSearchQBasic;
  QBasicParamEdit.EditLabel.Caption:=LanguageSetup.SetupFormQBasicParameters;
  QBasicDownloadURLInfo.Caption:=LanguageSetup.SetupFormQBasicDownloadURL;
  QBasicDownloadURL.Caption:='http:/'+'/download.microsoft.com/download/win95upg/tool_s/1.0/w95/en-us/olddos.exe';
  with QBasicDownloadURL.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  QBasicDownloadURL.Cursor:=crHandPoint;

  UserIconLoader.DialogImage(DI_SelectFile,QBasicButton);
  UserIconLoader.DialogImage(DI_FindFile,FindQBasicButton);

  HelpContext:=ID_FileOptionsQBasic;
end;

procedure TSetupFrameQBasic.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameQBasic.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameQBasic.HideFrame;
begin
end;

procedure TSetupFrameQBasic.RestoreDefaults;
begin
  QBasicParamEdit.Text:='/run %s';
end;

procedure TSetupFrameQBasic.SaveSetup;
begin
  PrgSetup.QBasic:=QBasicEdit.Text;
  PrgSetup.QBasicParam:=QBasicParamEdit.Text;
end;

procedure TSetupFrameQBasic.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
   19 : begin
          S:=Trim(QBasicEdit.Text); If S<>'' then S:=ExtractFilePath(S);
          If Trim(S)='' then S:=IncludeTrailingPathDelimiter(PBaseDir^);
          S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(PBaseDir^));
          {If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);}
          PrgOpenDialog.Title:=LanguageSetup.SetupFormQBasicFile;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            QBasicEdit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   20 : if SearchQBasicVM(self) then QBasicEdit.Text:=PrgSetup.QBasic;
  end;
end;

procedure TSetupFrameQBasic.QBasicDownloadURLClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

end.
