unit WizardPrgFileUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, ExtCtrls, GameDBUnit;

type
  TWizardPrgFileFrame = class(TFrame)
    InfoLabel: TLabel;
    GamesFolderEdit: TLabeledEdit;
    ProgramEdit: TLabeledEdit;
    SetupEdit: TLabeledEdit;
    SetupButton: TSpeedButton;
    ProgramButton: TSpeedButton;
    GamesFolderButton: TSpeedButton;
    DataFolderEdit: TLabeledEdit;
    BaseDataFolderEdit: TLabeledEdit;
    BaseInfoLabel3: TLabel;
    BaseDataFolderButton: TSpeedButton;
    DataFolderButton: TSpeedButton;
    Bevel: TBevel;
    FolderInfoButton: TSpeedButton;
    DataFolderShowButton: TBitBtn;
    FolderInfoButton2: TSpeedButton;
    DataFolderAutomaticCheckBox: TCheckBox;
    DataFolderAutomaticButton: TBitBtn;
    procedure ButtonWork(Sender: TObject);
    procedure FolderInfoButtonClick(Sender: TObject);
    procedure DataFolderShowButtonClick(Sender: TObject);
    procedure DataFolderAutomaticButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    OtherEmulator : Integer;
    Procedure Init(const GameDB : TGameDB);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses ShellAPI, ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools,
     PrgSetupUnit, IconLoaderUnit, GameDBToolsUnit;

{$R *.dfm}

{ TWizardPrgFileFrame }

procedure TWizardPrgFileFrame.Init(const GameDB: TGameDB);
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  BaseInfoLabel3.Font.Style:=[fsBold];

  InfoLabel.Caption:=LanguageSetup.WizardFormPage2Info;
  ProgramEdit.EditLabel.Caption:=LanguageSetup.WizardFormProgram;
  ProgramButton.Hint:=LanguageSetup.ChooseFile;
  SetupEdit.EditLabel.Caption:=LanguageSetup.WizardFormSetup;
  SetupButton.Hint:=LanguageSetup.ChooseFile;
  GamesFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormGamesFolder;
  GamesFolderButton.Caption:=LanguageSetup.WizardFormExplorer;
  DataFolderShowButton.Caption:=LanguageSetup.WizardFormDataFolderButton;
  DataFolderAutomaticCheckBox.Caption:=LanguageSetup.WizardFormDataFolderCheckbox;
  BaseInfoLabel3.Caption:=LanguageSetup.WizardFormInfoLabel3;
  DataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormDataFolder;
  DataFolderButton.Hint:=LanguageSetup.ChooseFolder;
  BaseDataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormBaseDataFolder;
  BaseDataFolderButton.Caption:=LanguageSetup.WizardFormExplorer;
  DataFolderAutomaticButton.Caption:=LanguageSetup.WizardFormDataFolderAutomaticButton;

  GamesFolderEdit.Text:=PrgSetup.GameDir;
  BaseDataFolderEdit.Text:=PrgSetup.DataDir;

  UserIconLoader.DialogImage(DI_SelectFile,ProgramButton);
  UserIconLoader.DialogImage(DI_SelectFile,SetupButton);
  UserIconLoader.DialogImage(DI_SelectFolder,GamesFolderButton);
  UserIconLoader.DialogImage(DI_ToolbarHelp,FolderInfoButton);
  UserIconLoader.DialogImage(DI_SelectFolder,DataFolderButton);
  UserIconLoader.DialogImage(DI_SelectFolder,BaseDataFolderButton);
  UserIconLoader.DialogImage(DI_ToolbarHelp,FolderInfoButton2);
  UserIconLoader.DialogImage(DI_Down,DataFolderShowButton);
  UserIconLoader.DialogImage(DI_Up,DataFolderAutomaticButton);

  GamesFolderEdit.Color:=Color;
  BaseDataFolderEdit.Color:=Color;
end;

procedure TWizardPrgFileFrame.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : ShellExecute(Handle,'explore',PChar(GamesFolderEdit.Text),nil,PChar(GamesFolderEdit.Text),SW_SHOW);
    1 : begin
          S:=MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir);
          If SelectProgramFile(S,ProgramEdit.Text,SetupEdit.Text,GamesFolderEdit.Visible=False,OtherEmulator,self) then ProgramEdit.Text:=S;
        end;
    2 : begin
          S:=MakeAbsPath(SetupEdit.Text,PrgSetup.BaseDir);
          If SelectProgramFile(S,SetupEdit.Text,ProgramEdit.Text,GamesFolderEdit.Visible=False,OtherEmulator,self) then SetupEdit.Text:=S;
        end;
    3 : ShellExecute(Handle,'explore',PChar(BaseDataFolderEdit.Text),nil,PChar(BaseDataFolderEdit.Text),SW_SHOW);
    4 : begin
          If Trim(DataFolderEdit.Text)=''
            then S:=PrgSetup.DataDir
            else S:=MakeAbsPath(DataFolderEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir,True);
          DataFolderEdit.Text:=S;
        end;
  end;
end;

procedure TWizardPrgFileFrame.WriteDataToGame(const Game: TGame);
Var I : Integer;
    S,T : String;
begin
  If (not GamesFolderEdit.Visible) and (OtherEmulator>=0) then begin
    If Trim(ProgramEdit.Text)='' then begin Game.GameExe:=''; Game.GameParameters:=''; end else begin
      Game.GameExe:=MakeRelPath(PrgSetup.WindowsBasedEmulatorsPrograms[OtherEmulator],PrgSetup.BaseDir);
      Game.GameParameters:=Format(PrgSetup.WindowsBasedEmulatorsParameters[OtherEmulator],[ProgramEdit.Text]);
    end;
    If Trim(SetupEdit.Text)='' then begin Game.SetupExe:=''; Game.SetupParameters:=''; end else begin
      Game.SetupExe:=MakeRelPath(PrgSetup.WindowsBasedEmulatorsPrograms[OtherEmulator],PrgSetup.BaseDir);
      Game.SetupParameters:=Format(PrgSetup.WindowsBasedEmulatorsParameters[OtherEmulator],[SetupEdit.Text]);
    end;
  end else begin
    Game.GameExe:=ProgramEdit.Text;
    Game.SetupExe:=SetupEdit.Text;
  end;

  If DataFolderButton.Visible and (Trim(DataFolderEdit.Text)='') then DataFolderButton.Visible:=False;

  If DataFolderButton.Visible then begin
    Game.DataDir:=MakeRelPath(DataFolderEdit.Text,PrgSetup.BaseDir);
  end else begin
    If DataFolderAutomaticCheckBox.Checked then begin
      If PrgSetup.DataDir='' then T:=PrgSetup.BaseDir else T:=PrgSetup.DataDir;
      S:=IncludeTrailingPathDelimiter(T)+MakeFileSysOKFolderName(Game.Name)+'\';
      I:=0;
      While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
        inc(I);
        S:=IncludeTrailingPathDelimiter(T)+MakeFileSysOKFolderName(Game.Name)+IntToStr(I)+'\';
      end;
      Game.DataDir:=MakeRelPath(S,PrgSetup.BaseDir);
    end else begin
      Game.DataDir:='';
    end;
  end;
end;

procedure TWizardPrgFileFrame.FolderInfoButtonClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : MessageDlg(Format(LanguageSetup.WizardFormGamesFolderInfo,[PrgSetup.BaseDir]),mtInformation,[mbOK],0);
    1 : MessageDlg(Format(LanguageSetup.WizardFormBaseDataFolderInfo,[PrgSetup.BaseDir]),mtInformation,[mbOK],0);
  end;
end;

procedure TWizardPrgFileFrame.DataFolderShowButtonClick(Sender: TObject);
begin
  DataFolderShowButton.Visible:=False;
  DataFolderAutomaticCheckBox.Visible:=False;

  BaseInfoLabel3.Visible:=True;
  BaseDataFolderEdit.Visible:=True;
  BaseDataFolderButton.Visible:=True;
  DataFolderEdit.Visible:=True;
  DataFolderButton.Visible:=True;
  FolderInfoButton2.Visible:=True;
  DataFolderAutomaticButton.Visible:=True;
end;

procedure TWizardPrgFileFrame.DataFolderAutomaticButtonClick(Sender: TObject);
begin
  DataFolderShowButton.Visible:=True;
  DataFolderAutomaticCheckBox.Visible:=True;
  DataFolderAutomaticCheckBox.Checked:=True;

  BaseInfoLabel3.Visible:=False;
  BaseDataFolderEdit.Visible:=False;
  BaseDataFolderButton.Visible:=False;
  DataFolderEdit.Visible:=False;
  DataFolderButton.Visible:=False;
  FolderInfoButton2.Visible:=False;
  DataFolderAutomaticButton.Visible:=False;
end;

end.
