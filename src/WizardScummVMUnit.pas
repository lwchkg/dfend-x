unit WizardScummVMUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GameDBUnit;

type
  TWizardScummVMFrame = class(TFrame)
    Bevel: TBevel;
    InfoLabel: TLabel;
    ProgramEdit: TLabeledEdit;
    ProgramButton: TSpeedButton;
    GamesFolderEdit: TLabeledEdit;
    GamesFolderButton: TSpeedButton;
    FolderInfoButton: TSpeedButton;
    DataFolderShowButton: TBitBtn;
    BaseInfoLabel3: TLabel;
    DataFolderEdit: TLabeledEdit;
    BaseDataFolderEdit: TLabeledEdit;
    BaseDataFolderButton: TSpeedButton;
    DataFolderButton: TSpeedButton;
    GameNameComboBox: TComboBox;
    GameNameLabel: TLabel;
    DataFolderAutomaticCheckBox: TCheckBox;
    procedure FolderInfoButtonClick(Sender: TObject);
    procedure DataFolderShowButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure ShowScummVMFrame;
    Procedure WriteDataToGame(const Game : TGame);
    Function GetScummVMGameName : String;
  end;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, ScummVMToolsUnit,
     CommonTools, IconLoaderUnit;

{$R *.dfm}

{ TWizardScummVMFrame }

procedure TWizardScummVMFrame.Init(const GameDB: TGameDB);
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  BaseInfoLabel3.Font.Style:=[fsBold];

  InfoLabel.Caption:=LanguageSetup.WizardFormPage2Info;
  ProgramEdit.EditLabel.Caption:=LanguageSetup.WizardFormProgramFolder;
  ProgramButton.Hint:=LanguageSetup.ChooseFolder;
  GamesFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormGamesFolder;
  GamesFolderButton.Caption:=LanguageSetup.WizardFormExplorer;
  GameNameLabel.Caption:=LanguageSetup.ProfileEditorScummVMGame;
  DataFolderShowButton.Caption:=LanguageSetup.WizardFormDataFolderButton;
  BaseInfoLabel3.Caption:=LanguageSetup.WizardFormInfoLabel3;
  DataFolderAutomaticCheckBox.Caption:=LanguageSetup.WizardFormDataFolderCheckbox;
  DataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormDataFolder;
  DataFolderButton.Hint:=LanguageSetup.ChooseFolder;
  BaseDataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormBaseDataFolder;
  BaseDataFolderButton.Caption:=LanguageSetup.WizardFormExplorer;

  GamesFolderEdit.Text:=PrgSetup.GameDir;
  BaseDataFolderEdit.Text:=PrgSetup.DataDir;

  UserIconLoader.DialogImage(DI_SelectFolder,ProgramButton);
  UserIconLoader.DialogImage(DI_SelectFolder,GamesFolderButton);
  UserIconLoader.DialogImage(DI_ToolbarHelp,FolderInfoButton);
  UserIconLoader.DialogImage(DI_SelectFolder,DataFolderButton);
  UserIconLoader.DialogImage(DI_SelectFolder,BaseDataFolderButton);
  UserIconLoader.DialogImage(DI_Down,DataFolderShowButton);

  GamesFolderEdit.Color:=Color;
  BaseDataFolderEdit.Color:=Color;
end;

procedure TWizardScummVMFrame.ShowScummVMFrame;
begin
  If ScummVMGamesList.Count=0 then ScummVMGamesList.LoadListFromScummVM(True);
  GameNameComboBox.Items.Clear;
  GameNameComboBox.Sorted:=False;
  GameNameComboBox.Items.AddStrings(ScummVMGamesList.DescriptionList);
  GameNameComboBox.Sorted:=True;
  If GameNameComboBox.Items.Count>0 then GameNameComboBox.ItemIndex:=0;
end;

procedure TWizardScummVMFrame.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : ShellExecute(Handle,'explore',PChar(GamesFolderEdit.Text),nil,PChar(GamesFolderEdit.Text),SW_SHOW);
    1 : begin
          If Trim(ProgramEdit.Text)=''
            then S:=PrgSetup.GameDir
            else S:=MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir,True);
          ProgramEdit.Text:=S;
        end;
    2 : ShellExecute(Handle,'explore',PChar(BaseDataFolderEdit.Text),nil,PChar(BaseDataFolderEdit.Text),SW_SHOW);
    3 : begin
          If Trim(DataFolderEdit.Text)=''
            then S:=PrgSetup.DataDir
            else S:=MakeAbsPath(DataFolderEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir,True);
          DataFolderEdit.Text:=S;
        end;
  end;
end;

procedure TWizardScummVMFrame.WriteDataToGame(const Game: TGame);
Var S,T : String;
    I : Integer;
begin
  Game.ScummVMPath:=ProgramEdit.Text;
  If GameNameComboBox.ItemIndex>=0
    then Game.ScummVMGame:=ScummVMGamesList.NameFromDescription(GameNameComboBox.Text)
    else Game.ScummVMGame:='';
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

procedure TWizardScummVMFrame.FolderInfoButtonClick(Sender: TObject);
begin
  MessageDlg(Format(LanguageSetup.WizardFormGamesFolderInfo,[PrgSetup.BaseDir]),mtInformation,[mbOK],0);
end;

function TWizardScummVMFrame.GetScummVMGameName: String;
begin
  If GameNameComboBox.ItemIndex>=0
    then result:=ScummVMGamesList.NameFromDescription(GameNameComboBox.Text)
    else result:='';
end;

procedure TWizardScummVMFrame.DataFolderShowButtonClick(Sender: TObject);
begin
  DataFolderShowButton.Visible:=False;
  DataFolderAutomaticCheckBox.Visible:=False;

  BaseInfoLabel3.Visible:=True;
  BaseDataFolderEdit.Visible:=True;
  BaseDataFolderButton.Visible:=True;
  DataFolderEdit.Visible:=True;
  DataFolderButton.Visible:=True;
end;

end.
