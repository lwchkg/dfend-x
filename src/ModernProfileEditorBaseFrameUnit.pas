unit ModernProfileEditorBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorBaseFrame = class(TFrame, IModernProfileEditorFrame)
    IconPanel: TPanel;
    IconImage: TImage;
    IconSelectButton: TBitBtn;
    IconDeleteButton: TBitBtn;
    ProfileNameEdit: TLabeledEdit;
    ProfileFileNameEdit: TLabeledEdit;
    GameExeGroup: TGroupBox;
    GameExeEdit: TLabeledEdit;
    GameParameterEdit: TLabeledEdit;
    GameExeButton: TSpeedButton;
    SetupExeGroup: TGroupBox;
    SetupExeButton: TSpeedButton;
    SetupExeEdit: TLabeledEdit;
    SetupParameterEdit: TLabeledEdit;
    OpenDialog: TOpenDialog;
    GameRelPathCheckBox: TCheckBox;
    SetupRelPathCheckBox: TCheckBox;
    GameGroup: TGroupBox;
    GameComboBox: TComboBox;
    GameEdit: TLabeledEdit;
    GameButton: TSpeedButton;
    InfoLabel: TLabel;
    ExtraExeFilesButton: TBitBtn;
    GameZipCheckBox: TCheckBox;
    GameZipEdit: TEdit;
    GameZipButton: TSpeedButton;
    GameZipLabel: TLabel;
    InfoButton1: TSpeedButton;
    InfoButton2: TSpeedButton;
    IgnoreWindowsWarningsCheckBox: TCheckBox;
    TurnOffDOSBoxFailedWarningCheckBox: TCheckBox;
    RunAsAdminCheckBox: TCheckBox;
    procedure IconButtonClick(Sender: TObject);
    procedure ExeSelectButtonClick(Sender: TObject);
    procedure ProfileNameEditChange(Sender: TObject);
    procedure RelPathCheckBoxClick(Sender: TObject);
    procedure GameComboBoxChange(Sender: TObject);
    procedure ExtraExeFilesButtonClick(Sender: TObject);
    procedure SetupExeEditChange(Sender: TObject);
    procedure GameExeEditChange(Sender: TObject);
    procedure GameZipEditChange(Sender: TObject);
    procedure GameRelPathButton(Sender: TObject);
  private
    { Private-Deklarationen }
    FOnProfileNameChange : TTextEvent;
    FLoadFromTemplate : Boolean;
    IconName : String;
    OldFileName : String;
    ProfileName,ProfileExe,ProfileSetup,ProfileScummVMGameName,ProfileScummVMPath,ProfileDOSBoxInstallation,ProfileCaptureDir : PString;
    ScummVM, WindowsMode : Boolean;
    FGameDB : TGameDB;
    procedure LoadIcon;
    Procedure CheckValue(Sender : TObject; var OK : Boolean);
    Procedure ShowFrame(Sender : TObject);
    Procedure ProfileNameChangedCallback(Sender : TObject);
    Procedure CalcCheckBoxTop;
  public
    { Public-Deklarationen }
    ExtraExeFiles, ExtraExeFilesParameters : TStringList;
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses ShlObj, Math, LanguageSetupUnit, VistaToolsUnit, IconManagerFormUnit,
     PrgSetupUnit, PrgConsts, CommonTools, GameDBToolsUnit, ScummVMToolsUnit,
     ExtraExeEditFormUnit, HelpConsts, ZipInfoFormUnit, IconLoaderUnit,
     ImageStretch, DOSBoxUnit;

{$R *.dfm}

{ TModernProfileEditorBaseFrame }

constructor TModernProfileEditorBaseFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ExtraExeFiles:=TStringList.Create;
  ExtraExeFilesParameters:=TStringList.Create;
end;

destructor TModernProfileEditorBaseFrame.Destroy;
begin
  ExtraExeFiles.Free;
  ExtraExeFilesParameters.Free;
  inherited Destroy;
end;

procedure TModernProfileEditorBaseFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  InitData.OnCheckValue:=CheckValue;
  InitData.OnShowFrame:=ShowFrame;
  InitData.AllowDefaultValueReset:=False;
  InitData.OnProfileNameChangedCallback:=ProfileNameChangedCallback;

  ScummVM:=False;
  WindowsMode:=False;

  NoFlicker(ProfileNameEdit);
  NoFlicker(ProfileFileNameEdit);
  NoFlicker(GameExeGroup);
  NoFlicker(GameExeEdit);
  NoFlicker(GameParameterEdit);
  NoFlicker(SetupExeGroup);
  NoFlicker(SetupExeEdit);
  NoFlicker(SetupParameterEdit);
  NoFlicker(GameGroup);
  NoFlicker(GameComboBox);
  NoFlicker(GameEdit);
  NoFlicker(GameZipCheckBox);
  NoFlicker(GameZipEdit);

  FOnProfileNameChange:=InitData.OnProfileNameChange;
  FGameDB:=InitData.GameDB;

  IconPanel.ControlStyle:=IconPanel.ControlStyle-[csParentBackground];
  IconSelectButton.Caption:=LanguageSetup.ProfileEditorIconSelect;
  IconDeleteButton.Caption:=LanguageSetup.ProfileEditorIconDelete;
  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorProfileName;
  ProfileFileNameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorFilename;

  GameExeGroup.Caption:=LanguageSetup.ProfileEditorGame;
  GameExeEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorGameEXE;
  GameExeButton.Hint:=LanguageSetup.ChooseFile;
  GameRelPathCheckBox.Caption:=LanguageSetup.ProfileEditorRelPath;
  GameRelPathCheckBox.Hint:=LanguageSetup.ProfileEditorRelPathHint;
  RunAsAdminCheckBox.Caption:=LanguageSetup.ProfileEditorRunAsAdmin;
  GameParameterEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorGameParameters;
  UserIconLoader.DialogImage(DI_SelectFile,GameExeButton);

  SetupExeGroup.Caption:=LanguageSetup.ProfileEditorSetup;
  SetupExeEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSetupEXE;
  SetupExeButton.Hint:=LanguageSetup.ChooseFile;
  SetupRelPathCheckBox.Caption:=LanguageSetup.ProfileEditorRelPath;
  SetupRelPathCheckBox.Hint:=LanguageSetup.ProfileEditorRelPathHint;
  SetupParameterEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSetupParameters;
  InfoLabel.Caption:=LanguageSetup.ProfileEditorSetupInfo;
  ExtraExeFilesButton.Caption:=LanguageSetup.ProfileEditorExtraExeFiles;
  UserIconLoader.DialogImage(DI_SelectFile,SetupExeButton);
  UserIconLoader.DialogImage(DI_ExtraPrgFiles,ExtraExeFilesButton);

  GameGroup.Caption:=LanguageSetup.ProfileEditorScummVMGame;
  GameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorScummVMGameFolder;
  GameButton.Hint:=LanguageSetup.ChooseFolder;
  GameZipCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMGameZipFile;
  GameZipButton.Hint:=LanguageSetup.ChooseFile;
  GameZipLabel.Caption:=LanguageSetup.ProfileEditorScummVMGameZipFileInfo;
  UserIconLoader.DialogImage(DI_SelectFolder,GameButton);
  UserIconLoader.DialogImage(DI_SelectFile,GameZipButton);

  ProfileName:=InitData.CurrentProfileName;
  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileScummVMGameName:=InitData.CurrentScummVMGameName;
  ProfileScummVMPath:=InitData.CurrentScummVMPath;
  ProfileDOSBoxInstallation:=InitData.CurrentDOSBoxInstallation;
  ProfileCaptureDir:=InitData.CurrentCaptureDir;

  InfoButton1.Font.Size:=InfoButton1.Font.Size-2;
  InfoButton2.Font.Size:=InfoButton2.Font.Size-2;
  InfoButton1.Caption:=LanguageSetup.ProfileEditorRelPathInfo;
  InfoButton2.Caption:=LanguageSetup.ProfileEditorRelPathInfo;

  IgnoreWindowsWarningsCheckBox.Caption:=LanguageSetup.ProfileEditorIgnoreWindowsWarnings;
  IgnoreWindowsWarningsCheckBox.Hint:=LanguageSetup.ProfileEditorIgnoreWindowsWarningsHints;

  TurnOffDOSBoxFailedWarningCheckBox.Caption:=LanguageSetup.TurnOffDOSBoxFailedWarning;
  TurnOffDOSBoxFailedWarningCheckBox.Hint:=LanguageSetup.TurnOffDOSBoxFailedWarningHints;

  HelpContext:=ID_ProfileEditProfile;
end;

procedure TModernProfileEditorBaseFrame.SetGame(const Game: TGame; const LoadFromTemplate : Boolean);
Var S : String;
    I : Integer;
begin
  FLoadFromTemplate:=LoadFromTemplate and (Game<>nil);

  If Game=nil then begin
    ProfileFileNameEdit.Text:=LanguageSetup.ProfileEditorNoFilename;
    exit;
  end;

  OldFileName:='';

  IconName:=Game.Icon;
  LoadIcon;
  If not LoadFromTemplate then begin
    ProfileNameEdit.Text:=Game.Name;
  end;
  If LoadFromTemplate then begin
    ProfileFileNameEdit.Text:=LanguageSetup.ProfileEditorNoFilename;
    ProfileFileNameEdit.Color:=Color;
  end else begin
    If Game.SetupFile<>'' then begin
      OldFileName:=Game.SetupFile;
      ProfileFileNameEdit.Text:=ChangeFileExt(ExtractFileName(Game.SetupFile),'');
      if PrgSetup.RenameProfFileOnRenamingProfile then begin
        ProfileFileNameEdit.Color:=Color;
      end else begin
        ProfileFileNameEdit.ReadOnly:=False;
      end;
    end else begin
      {Main Template}
      ProfileNameEdit.Visible:=False;
      ProfileFileNameEdit.Text:=LanguageSetup.ProfileEditorNoFilename;
      ProfileFileNameEdit.Color:=Color;
      ProfileNameEdit.ReadOnly:=True;
    end;
  end;

  If ScummVMMode(Game) then begin
    { ScummVM mode }
    ScummVM:=True;

    If ScummVMGamesList.Count=0 then ScummVMGamesList.LoadListFromScummVM(True);
    GameComboBox.Items.Clear;
    GameComboBox.Sorted:=False;
    GameComboBox.Items.AddStrings(ScummVMGamesList.DescriptionList);
    GameComboBox.Sorted:=True;
    If GameComboBox.Items.Count>0 then GameComboBox.ItemIndex:=0;
    S:=Trim(ExtUpperCase(Game.ScummVMGame));
    For I:=0 to ScummVMGamesList.NamesList.Count-1 do If Trim(ExtUpperCase(ScummVMGamesList.NamesList[I]))=S then begin
      GameComboBox.ItemIndex:=GameComboBox.Items.IndexOf(ScummVMGamesList.DescriptionList[I]);
      break;
    end;
    GameEdit.Text:=Game.ScummVMPath;
    GameZipEdit.Text:=Trim(Game.ScummVMZip);
    GameZipCheckBox.Checked:=(GameZipEdit.Text<>'');
  end else begin
    If WindowsExeMode(Game) then begin
      { Windows mode }
      WindowsMode:=True;
      GameExeEdit.Text:=Game.GameExe;
      GameParameterEdit.Text:=Game.GameParameters;
      SetupExeEdit.Text:=Game.SetupExe;
      SetupParameterEdit.Text:=Game.SetupParameters;
      RunAsAdminCheckBox.Checked:=Game.RunAsAdmin;
    end else begin
      { DOSBox mode }
      GameRelPathCheckBox.Visible:=True;
      S:=Trim(ExtUpperCase(Game.GameExe));
      If Copy(S,1,7)='DOSBOX:' then begin
        GameRelPathCheckBox.Checked:=True;
        GameExeEdit.Text:=Copy(Trim(Game.GameExe),8,MaxInt);
      end else begin
        GameExeEdit.Text:=Game.GameExe;
      end;
      GameParameterEdit.Text:=Game.GameParameters;

      S:=Trim(ExtUpperCase(Game.SetupExe));
      If Copy(S,1,7)='DOSBOX:' then begin
        SetupRelPathCheckBox.Checked:=True;
        SetupExeEdit.Text:=Copy(Trim(Game.SetupExe),8,MaxInt);
      end else begin
        SetupExeEdit.Text:=Game.SetupExe;
      end;
      SetupParameterEdit.Text:=Game.SetupParameters;

      IgnoreWindowsWarningsCheckBox.Checked:=Game.IgnoreWindowsFileWarnings;
      TurnOffDOSBoxFailedWarningCheckBox.Checked:=Game.NoDOSBoxFailedDialog;
    end;
    { Windows and DOSBox mode }
    For I:=0 to 49 do If Trim(Game.ExtraPrgFile[I])<>'' then begin
      ExtraExeFiles.Add(Game.ExtraPrgFile[I]);
      ExtraExeFilesParameters.Add(Game.ExtraPrgFileParameter[I]);
    end;
  end;
end;

procedure TModernProfileEditorBaseFrame.ShowFrame;
begin
  If ScummVM then begin
    { ScummVM mode }
    GameExeGroup.Visible:=False;
    SetupExeGroup.Visible:=False;
    ExtraExeFilesButton.Visible:=False;
    GameGroup.Visible:=True;
    GameComboBoxChange(self);
    IgnoreWindowsWarningsCheckBox.Visible:=False;
    TurnOffDOSBoxFailedWarningCheckBox.Visible:=False;
    RunAsAdminCheckBox.Visible:=False;
  end else begin
    GameGroup.Visible:=False;
    GameExeGroup.Top:=GameGroup.Top;
    SetupExeGroup.Top:=GameExeGroup.BoundsRect.Bottom+8;
    ExtraExeFilesButton.Top:=SetupExeGroup.BoundsRect.Bottom+8;
    IgnoreWindowsWarningsCheckBox.Top:=ExtraExeFilesButton.Top+5;
    TurnOffDOSBoxFailedWarningCheckBox.Top:=IgnoreWindowsWarningsCheckBox.Top+IgnoreWindowsWarningsCheckBox.Height;
    If WindowsMode then begin
      { Windows mode }
      GameRelPathCheckBox.Visible:=False;
      SetupRelPathCheckBox.Visible:=False;
      InfoButton1.Visible:=False;
      InfoButton2.Visible:=False;
      IgnoreWindowsWarningsCheckBox.Visible:=False;
      TurnOffDOSBoxFailedWarningCheckBox.Visible:=False;
      RunAsAdminCheckBox.Visible:=PrgSetup.OfferRunAsAdmin;
    end else begin
      { DOSBox mode }
      GameExeEditChange(Sender); {Make IgnoreWindowsWarningsCheckBox visible if needed}
      TurnOffDOSBoxFailedWarningCheckBox.Visible:=TurnOffDOSBoxFailedWarningCheckBox.Checked;
      RunAsAdminCheckBox.Visible:=False;
      CalcCheckBoxTop;
    end;
  end;
end;

procedure TModernProfileEditorBaseFrame.ProfileNameChangedCallback(Sender: TObject);
begin
  ProfileNameEdit.Text:=ProfileName^;
end;

Procedure TModernProfileEditorBaseFrame.CheckValue(Sender : TObject; var OK : Boolean);
begin
  OK:=True;

  If (Trim(ProfileNameEdit.Text)='') and (not ProfileNameEdit.ReadOnly) then begin
    MessageDlg(LanguageSetup.MessageNoProfileName,mtError,[mbOK],0);
    OK:=False;
    exit;
  end;
end;

procedure TModernProfileEditorBaseFrame.GameComboBoxChange(Sender: TObject);
begin
  If GameComboBox.ItemIndex>=0 then
    FOnProfileNameChange(Sender,ProfileNameEdit.Text,ProfileExe^,ProfileSetup^,ScummVMGamesList.NameFromDescription(GameComboBox.Text),ProfileScummVMPath^,ProfileDOSBoxInstallation^,ProfileCaptureDir^);
end;

procedure TModernProfileEditorBaseFrame.GetGame(const Game: TGame);
Var NewFileName : String;
    S : String;
    I : Integer;
begin
  Game.Icon:=IconName;
  If not ProfileNameEdit.ReadOnly then Game.Name:=ProfileNameEdit.Text;

  If ScummVM then begin
    { ScummVM mode }
    Game.ProfileMode:='ScummVM';
    If GameComboBox.ItemIndex>=0
      then Game.ScummVMGame:=ScummVMGamesList.NameFromDescription(GameComboBox.Text)
      else Game.ScummVMGame:='';
    Game.ScummVMPath:=GameEdit.Text;
    If GameZipCheckBox.Checked then begin
      Game.ScummVMZip:=Trim(GameZipEdit.Text);
      GameZipEditChange(self);
    end else begin
      Game.ScummVMZip:='';
    end;
  end else begin
    If WindowsMode then begin
      { Windows mode }
      Game.ProfileMode:='Windows';
      ProfileEditorCloseCheck(Game,GameExeEdit.Text,SetupExeEdit.Text);
      Game.GameExe:=GameExeEdit.Text;
      Game.GameParameters:=GameParameterEdit.Text;
      Game.SetupExe:=SetupExeEdit.Text;
      Game.SetupParameters:=SetupParameterEdit.Text;
      Game.RunAsAdmin:=RunAsAdminCheckBox.Checked;
    end else begin
      { DOSBox mode }
      Game.ProfileMode:='DOSBox';
      ProfileEditorCloseCheck(Game,GameExeEdit.Text,SetupExeEdit.Text);
      If GameRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
      Game.GameExe:=S+GameExeEdit.Text;
      Game.GameParameters:=GameParameterEdit.Text;
      If SetupRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
      Game.SetupExe:=S+SetupExeEdit.Text;
      Game.SetupParameters:=SetupParameterEdit.Text;

      Game.IgnoreWindowsFileWarnings:=IgnoreWindowsWarningsCheckBox.Checked;
      Game.NoDOSBoxFailedDialog:=TurnOffDOSBoxFailedWarningCheckBox.Checked;
    end;

    For I:=0 to 49 do begin Game.ExtraPrgFile[I]:=''; Game.ExtraPrgFileParameter[I]:=''; end;
    For I:=0 to Min(49,ExtraExeFiles.Count-1) do begin
      Game.ExtraPrgFile[I]:=Trim(ExtraExeFiles[I]);
      Game.ExtraPrgFileParameter[I]:=Trim(ExtraExeFilesParameters[I]);
    end;
    For I:=Min(49,ExtraExeFiles.Count-1)+1 to ExtraExeFiles.Count-1 do begin
      Game.ExtraPrgFile[I]:='';
      Game.ExtraPrgFileParameter[I]:='';
    end; 
  end;

  If not ProfileNameEdit.ReadOnly then begin
    If PrgSetup.RenameProfFileOnRenamingProfile then begin
      ProfileFileNameEdit.Text:=Game.Name;
    end;

    If (OldFileName<>'') and (ProfileFileNameEdit.Text<>ChangeFileExt(ExtractFileName(OldFileName),'')) then begin
      NewFileName:=ProfileFileNameEdit.Text;
      If ExtUpperCase(FGameDB.ProfFileName(NewFileName,False))<>ExtUpperCase(OldFileName) then
        Game.RenameINI(FGameDB.ProfFileName(NewFileName,True));
    end;
  end;
end;

procedure TModernProfileEditorBaseFrame.ProfileNameEditChange(Sender: TObject);
begin
  FOnProfileNameChange(Sender,ProfileNameEdit.Text,ProfileExe^,ProfileSetup^,ProfileScummVMGameName^,ProfileScummVMPath^,ProfileDOSBoxInstallation^,ProfileCaptureDir^);
end;

procedure TModernProfileEditorBaseFrame.GameExeEditChange(Sender: TObject);
Var S : String;
begin
  If GameRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
  FOnProfileNameChange(Sender,ProfileName^,S+GameExeEdit.Text,ProfileSetup^,ProfileScummVMGameName^,ProfileScummVMPath^,ProfileDOSBoxInstallation^,ProfileCaptureDir^);

  IgnoreWindowsWarningsCheckBox.Visible:=(not GameRelPathCheckBox.Checked) and (IsWindowsExe(MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir)) or IsWindowsExe(MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir)));
  CalcCheckBoxTop;
end;

procedure TModernProfileEditorBaseFrame.GameRelPathButton(Sender: TObject);
begin
  MessageDlg(LanguageSetup.ProfileEditorRelPathHint,mtInformation,[mbOK],0);
end;

procedure TModernProfileEditorBaseFrame.SetupExeEditChange(Sender: TObject);
Var S : String;
begin
  If SetupRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
  FOnProfileNameChange(Sender,ProfileName^,ProfileExe^,S+SetupExeEdit.Text,ProfileScummVMGameName^,ProfileScummVMPath^,ProfileDOSBoxInstallation^,ProfileCaptureDir^);

  IgnoreWindowsWarningsCheckBox.Visible:=(not GameRelPathCheckBox.Checked) and (IsWindowsExe(MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir)) or IsWindowsExe(MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir)));
  CalcCheckBoxTop;
end;

Procedure TModernProfileEditorBaseFrame.CalcCheckBoxTop;
begin
  IgnoreWindowsWarningsCheckBox.Top:=ExtraExeFilesButton.Top+5;
  If IgnoreWindowsWarningsCheckBox.Visible then begin
    TurnOffDOSBoxFailedWarningCheckBox.Top:=IgnoreWindowsWarningsCheckBox.Top+IgnoreWindowsWarningsCheckBox.Height;
  end else begin
    TurnOffDOSBoxFailedWarningCheckBox.Top:=IgnoreWindowsWarningsCheckBox.Top;
  end;
end;

procedure TModernProfileEditorBaseFrame.RelPathCheckBoxClick(Sender: TObject);
Var S,T : String;
begin
  Case (Sender as TComponent).Tag of
    0 : GameExeButton.Visible:=not GameRelPathCheckBox.Checked;
    1 : SetupExeButton.Visible:=not SetupRelPathCheckBox.Checked;
  end;

  If GameRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
  If SetupRelPathCheckBox.Checked then T:='DOSBox:' else T:='';
  FOnProfileNameChange(Sender,ProfileName^,S+GameExeEdit.Text,T+SetupExeEdit.Text,ProfileScummVMGameName^,ProfileScummVMPath^,ProfileDOSBoxInstallation^,ProfileCaptureDir^);
end;

procedure TModernProfileEditorBaseFrame.GameZipEditChange(Sender: TObject);
begin
  If Trim(GameZipEdit.Text)<>'' then GameZipCheckBox.Checked:=True;
end;

procedure TModernProfileEditorBaseFrame.IconButtonClick(Sender: TObject);
Var S : String;
begin
  Case (Sender as TBitBtn).Tag of
    0 : begin
          S:='';
          If not GameRelPathCheckBox.Checked then S:=MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir);
          If (S='') and (not SetupRelPathCheckBox.Checked) then S:=MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir);
          if ShowIconManager(self,IconName,ExtractFilePath(S)) then LoadIcon;
        end;
    1 : begin IconName:=''; LoadIcon; end;
  end;
end;

procedure TModernProfileEditorBaseFrame.LoadIcon;
Var S : String;
    P : TPicture;
    B : TBitmap;
begin
  If IconName='' then begin
    IconImage.Picture:=nil;
    exit;
  end;

  S:=MakeAbsIconName(IconName);
  If not FileExists(S) then exit;

  try
    P:=LoadImageFromFile(S); If P=nil then exit;
    try
      B:=TBitmap.Create;
      try
        B.SetSize(IconImage.Width,IconImage.Height);
        ScaleImage(P,B);
        IconImage.Picture.Bitmap:=B;
      finally
        B.Free;
      end;
    finally
      P.Free;
    end;
  except end;
end;

procedure TModernProfileEditorBaseFrame.ExeSelectButtonClick(Sender: TObject);
Var S : String;
begin
  Case (Sender as TSpeedButton).Tag of
    0 : begin
          S:=GameExeEdit.Text;
          if not SelectProgramFile(S,GameExeEdit.Text,SetupExeEdit.Text,WindowsMode,-1,self) then exit;
          GameExeEdit.Text:=S;
          GameExeEditChange(Sender);
        end;
    1 : begin
          S:=SetupExeEdit.Text;
          if not SelectProgramFile(S,SetupExeEdit.Text,GameExeEdit.Text,WindowsMode,-1,self) then exit;
          SetupExeEdit.Text:=S;
          SetupExeEditChange(Sender);
        end;
    2 : begin
          If Trim(GameEdit.Text)='' then begin
            If PrgSetup.GameDir=''
              then S:=PrgSetup.BaseDir
              else S:=PrgSetup.GameDir;
          end else begin
            S:=MakeAbsPath(GameEdit.Text,PrgSetup.BaseDir);
          end;
          If SelectDirectory(Handle,LanguageSetup.ProfileEditorScummVMGameFolderCaption,S) then GameEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
        end;
    3 : begin
          If Trim(GameZipEdit.Text)='' then begin
            If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          end else S:=GameZipEdit.Text;
          S:=MakeAbsPath(S,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='zip';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingZipFile;
          OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
          if not OpenDialog.Execute then exit;
          GameZipEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          GameZipEditChange(Sender);
        end;
  end;
end;

procedure TModernProfileEditorBaseFrame.ExtraExeFilesButtonClick(Sender: TObject);
begin
  ShowExtraExeEditDialog(self,ExtraExeFiles,ExtraExeFilesParameters,WindowsMode,GameExeEdit.Text,SetupExeEdit.Text);
end;

end.
