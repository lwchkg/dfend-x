unit ModernProfileEditorDirectoryFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorDirectoryFrame = class(TFrame, IModernProfileEditorFrame)
    ScreenshotFolderEdit: TLabeledEdit;
    ScreenshotFolderEditButton: TSpeedButton;
    GenerateScreenshotFolderNameButton: TBitBtn;
    DataFolderEdit: TLabeledEdit;
    DataFolderEditButton: TSpeedButton;
    GenerateGameDataFolderNameButton: TBitBtn;
    ExtraDirsLabel: TLabel;
    ExtraDirsListBox: TListBox;
    ExtraDirsAddButton: TSpeedButton;
    ExtraDirsEditButton: TSpeedButton;
    ExtraDirsDelButton: TSpeedButton;
    ExtraDirsInfoLabel: TLabel;
    DataFolderInfoLabel: TLabel;
    Timer: TTimer;
    ExtraFilesLabel: TLabel;
    ExtraFilesListBox: TListBox;
    ExtraFilesAddButton: TSpeedButton;
    ExtraFilesEditButton: TSpeedButton;
    ExtraFilesDelButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExtraDirsListBoxClick(Sender: TObject);
    procedure ExtraDirsListBoxDblClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure GenerateScreenshotFolderNameButtonClick(Sender: TObject);
    procedure GenerateGameDataFolderNameButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ExtraFilesListBoxClick(Sender: TObject);
    procedure ExtraFilesListBoxDblClick(Sender: TObject);
    procedure ExtraFilesListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScreenshotFolderEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    FCurrentProfileName, FCurrentCaptureDir : PString;
    FLastCurrentProfileName : String;
    IsWindowsMode : Boolean;
    Procedure ShowFrame(Sender: TObject);
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     PrgConsts, GameDBToolsUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TModernProfileEditorDirectoryFrame }

procedure TModernProfileEditorDirectoryFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  InitData.OnShowFrame:=ShowFrame;
  InitData.AllowDefaultValueReset:=False;

  NoFlicker(ScreenshotFolderEdit);
  NoFlicker(DataFolderEdit);
  NoFlicker(ExtraFilesListBox);
  NoFlicker(ExtraDirsListBox);

  FCurrentProfileName:=InitData.CurrentProfileName;
  FCurrentCaptureDir:=InitData.CurrentCaptureDir;

  ScreenshotFolderEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorCaptureFolder;
  ScreenshotFolderEditButton.Hint:=LanguageSetup.ChooseFolder;
  GenerateScreenshotFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateScreenshotFolderName;
  UserIconLoader.DialogImage(DI_SelectFolder,ScreenshotFolderEditButton);
  UserIconLoader.DialogImage(DI_Screenshot,GenerateScreenshotFolderNameButton);

  DataFolderEdit.EditLabel.Caption:=LanguageSetup.GameDataDir;
  DataFolderEditButton.Hint:=LanguageSetup.ChooseFolder;
  DataFolderInfoLabel.Caption:=LanguageSetup.GameDataDirEditInfo;
  GenerateGameDataFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateGameDataFolder;
  UserIconLoader.DialogImage(DI_SelectFolder,DataFolderEditButton);
  UserIconLoader.DialogImage(DI_SelectFile,GenerateGameDataFolderNameButton);

  ExtraFilesLabel.Caption:=LanguageSetup.ProfileEditorExtraFiles;
  ExtraFilesAddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  ExtraFilesEditButton.Hint:=RemoveUnderline(LanguageSetup.Edit);
  ExtraFilesDelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  UserIconLoader.DialogImage(DI_Add,ExtraFilesAddButton);
  UserIconLoader.DialogImage(DI_Edit,ExtraFilesEditButton);
  UserIconLoader.DialogImage(DI_Delete,ExtraFilesDelButton);

  ExtraDirsLabel.Caption:=LanguageSetup.ProfileEditorExtraDirs;
  ExtraDirsAddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  ExtraDirsEditButton.Hint:=RemoveUnderline(LanguageSetup.Edit);
  ExtraDirsDelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  ExtraDirsInfoLabel.Caption:=LanguageSetup.ProfileEditorExtraDirsEditInfo;
  UserIconLoader.DialogImage(DI_Add,ExtraDirsAddButton);
  UserIconLoader.DialogImage(DI_Edit,ExtraDirsEditButton);
  UserIconLoader.DialogImage(DI_Delete,ExtraDirsDelButton);

  OpenDialog.Title:=LanguageSetup.ProfileEditorExtraFilesCaption;
  OpenDialog.Filter:=LanguageSetup.ProfileEditorExtraFilesFilter;

  FLastCurrentProfileName:='';

  HelpContext:=ID_ProfileEditProgramDirectories;
end;

procedure TModernProfileEditorDirectoryFrame.ScreenshotFolderEditChange(Sender: TObject);
begin
  FCurrentCaptureDir^:=ScreenshotFolderEdit.Text;
end;

procedure TModernProfileEditorDirectoryFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    I : Integer;
begin
  If Trim(Game.CaptureFolder)<>''
    then ScreenshotFolderEdit.Text:=Game.CaptureFolder
    else ScreenshotFolderEdit.Text:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir);
  If LoadFromTemplate and PrgSetup.AlwaysSetScreenshotFolderAutomatically then Timer.Enabled:=True;

  FLastCurrentProfileName:=FCurrentProfileName^;

  DataFolderEdit.Text:=Game.DataDir;

  St:=ValueToList(Game.ExtraFiles);
  try
    I:=0; While I<St.Count do If Trim(St[I])='' then St.Delete(I) else inc(I);
    ExtraFilesListBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  If ExtraFilesListBox.Items.Count>0 then ExtraFilesListBox.ItemIndex:=0;
  ExtraFilesListBoxClick(nil);
  St:=ValueToList(Game.ExtraDirs);
  try
    I:=0; While I<St.Count do If Trim(St[I])='' then St.Delete(I) else inc(I);
    ExtraDirsListBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=0;
  ExtraDirsListBoxClick(nil);

  IsWindowsMode:=WindowsExeMode(Game);
end;

procedure TModernProfileEditorDirectoryFrame.ShowFrame;
begin
  If IsWindowsMode then begin

ExtraFilesLabel.Visible:=False;
    ExtraFilesLabel.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraFilesListBox.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraFilesAddButton.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraFilesEditButton.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraFilesDelButton.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraDirsLabel.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraDirsLabel.Caption:=LanguageSetup.ProfileEditorExtraDirsWindowsProfile;
    ExtraDirsListBox.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraDirsAddButton.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraDirsEditButton.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraDirsDelButton.Visible:=PrgSetup.AllowPackingWindowsGames;
    ExtraDirsInfoLabel.Visible:=False;
  end;
end;

procedure TModernProfileEditorDirectoryFrame.TimerTimer(Sender: TObject);
Var S,DefaultFolder,OldFolder : String;
begin
  If FLastCurrentProfileName=FCurrentProfileName^ then exit;

  S:=Trim(ExtUpperCase(MakeRelPath(ScreenshotFolderEdit.Text,PrgSetup.BaseDir)));

  DefaultFolder:=Trim(ExtUpperCase(MakeRelPath(IncludeTrailingPathDelimiter(PrgSetup.CaptureDir),PrgSetup.BaseDir)));
  OldFolder:=Trim(ExtUpperCase(MakeRelPath(IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(FLastCurrentProfileName)+'\',PrgSetup.BaseDir)));

  If (S=DefaultFolder) or (S=OldFolder) then begin
    ScreenshotFolderEdit.Text:=MakeRelPath(IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(FCurrentProfileName^)+'\',PrgSetup.BaseDir);
    FLastCurrentProfileName:=FCurrentProfileName^;
  end else begin
    {Debug: ShowMessage(S+#13+DefaultFolder+#13+OldFolder);}
    Timer.Enabled:=False;
  end;
end;

procedure TModernProfileEditorDirectoryFrame.GetGame(const Game: TGame);
Var I : Integer;
begin
  If Timer.Enabled then begin
    Timer.Enabled:=False;
    TimerTimer(Timer);
  end;

  Game.CaptureFolder:=MakeRelPath(ScreenshotFolderEdit.Text,PrgSetup.BaseDir);
  Game.DataDir:=MakeRelPath(DataFolderEdit.Text,PrgSetup.BaseDir);
  I:=0; While I<ExtraFilesListBox.Items.Count do If Trim(ExtraFilesListBox.Items[I])='' then ExtraFilesListBox.Items.Delete(I) else inc(I);
  Game.Extrafiles:=ListToValue(ExtraFilesListBox.Items);
  I:=0; While I<ExtraDirsListBox.Items.Count do If Trim(ExtraDirsListBox.Items[I])='' then ExtraDirsListBox.Items.Delete(I) else inc(I);
  Game.ExtraDirs:=ListToValue(ExtraDirsListBox.Items);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxClick(Sender: TObject);
begin
  ExtraDirsEditButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
  ExtraDirsDelButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxDblClick(Sender: TObject);
begin
  ButtonWork(ExtraDirsEditButton);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(ExtraDirsAddButton);
    VK_RETURN : ButtonWork(ExtraDirsEditButton);
    VK_DELETE : ButtonWork(ExtraDirsDelButton);
  end;
end;

procedure TModernProfileEditorDirectoryFrame.ExtraFilesListBoxClick(Sender: TObject);
begin
  ExtraFilesEditButton.Enabled:=(ExtraFilesListBox.ItemIndex>=0);
  ExtraFilesDelButton.Enabled:=(ExtraFilesListBox.ItemIndex>=0);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraFilesListBoxDblClick(Sender: TObject);
begin
  ButtonWork(ExtraFilesEditButton);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraFilesListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(ExtraFilesAddButton);
    VK_RETURN : ButtonWork(ExtraFilesEditButton);
    VK_DELETE : ButtonWork(ExtraFilesDelButton);
  end;
end;

procedure TModernProfileEditorDirectoryFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TSpeedButton).Tag of
    0 : begin
          S:=PrgSetup.BaseDir;
          If Trim(ScreenshotFolderEdit.Text)=''
            then S:=MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)
            else S:=MakeAbsPath(IncludeTrailingPathDelimiter(ScreenshotFolderEdit.Text),S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir,True);
          If S='' then exit;
          ScreenshotFolderEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    1 : begin
          If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
          If Trim(DataFolderEdit.Text)<>'' then
            S:=MakeAbsPath(DataFolderEdit.Text,S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir,True);
          If S='' then exit;
          DataFolderEdit.Text:=S;
        end;
    2 : begin
          If Trim(PrgSetup.GameDir)='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          OpenDialog.InitialDir:=S;
          If not OpenDialog.Execute then exit;
          S:=OpenDialog.FileName;
          ExtraFilesListBox.Items.Add(MakeRelPath(S,PrgSetup.BaseDir));
          ExtraFilesListBox.ItemIndex:=ExtraFilesListBox.Items.count-1;
          ExtraFilesListBoxClick(Sender);
        end;
    3 : begin
          S:=MakeAbsPath(ExtraFilesListBox.Items[ExtraFilesListBox.ItemIndex],PrgSetup.BaseDir);
          OpenDialog.InitialDir:=ExtractFilePath(S);
          If not OpenDialog.Execute then exit;
          S:=OpenDialog.FileName;
          ExtraFilesListBox.Items[ExtraFilesListBox.ItemIndex]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    4 : begin
          I:=ExtraFilesListBox.ItemIndex;
          if I<0 then exit;
          ExtraFilesListBox.Items.Delete(I);
          If ExtraFilesListBox.Items.Count>0 then ExtraFilesListBox.ItemIndex:=Max(0,I-1);
          ExtraFilesListBoxClick(Sender);
        end;
    5 : begin
          If Trim(PrgSetup.GameDir)='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items.Add(MakeRelPath(S,PrgSetup.BaseDir,True));
          ExtraDirsListBox.ItemIndex:=ExtraDirsListBox.Items.count-1;
          ExtraDirsListBoxClick(Sender);
        end;
    6 : If ExtraDirsListBox.ItemIndex>=0 then begin
          S:=MakeAbsPath(ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex],PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex]:=MakeRelPath(S,PrgSetup.BaseDir,True);
        end;
    7 : begin
          I:=ExtraDirsListBox.ItemIndex;
          if I<0 then exit;
          ExtraDirsListBox.Items.Delete(I);
          If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=Max(0,I-1);
          ExtraDirsListBoxClick(Sender);
        end;
  end;
end;

procedure TModernProfileEditorDirectoryFrame.GenerateScreenshotFolderNameButtonClick(Sender: TObject);
Var I : Integer;
    S : String;
begin
  If (Trim(ScreenshotFolderEdit.Text)<>'') and DirectoryExists(MakeAbsPath(ScreenshotFolderEdit.Text,PrgSetup.BaseDir)) then exit;

  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(FCurrentProfileName^)+'\';
  I:=0;
  while (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    inc(I);
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(FCurrentProfileName^)+IntToStr(I)+'\';
  end;
  ScreenshotFolderEdit.Text:=S;
end;

procedure TModernProfileEditorDirectoryFrame.GenerateGameDataFolderNameButtonClick(Sender: TObject);
Var S,T : String;
    I : Integer;
begin
  If (Trim(DataFolderEdit.Text)<>'') and DirectoryExists(MakeAbsPath(DataFolderEdit.Text,PrgSetup.BaseDir)) then exit;

  If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;

  T:=MakeRelPath(IncludeTrailingPathDelimiter(S)+MakeFileSysOKFolderName(FCurrentProfileName^)+'\',PrgSetup.BaseDir,True);

  I:=0;
  while (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(T,PrgSetup.BaseDir)) do begin
    inc(I);
    T:=MakeRelPath(IncludeTrailingPathDelimiter(S)+MakeFileSysOKFolderName(FCurrentProfileName^)+IntToStr(I)+'\',PrgSetup.BaseDir,True);
  end;
  DataFolderEdit.Text:=T;

  S:=MakeAbsPath(T,PrgSetup.BaseDir);
  If MessageDlg(Format(LanguageSetup.MessageConfirmationCreateDir,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  ForceDirectories(S);
end;

end.
