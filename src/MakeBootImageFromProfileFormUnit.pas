unit MakeBootImageFromProfileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, Spin;

type
  TMakeBootImageFromProfileForm = class(TForm)
    ProfileComboBox: TComboBox;
    InfoLabel: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    FreeSizeLabel: TLabel;
    FreeSizeEdit: TSpinEdit;
    FreeSizeMBLabel: TLabel;
    CompressedCheckBox: TCheckBox;
    MemoryManagerCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HelpButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Function GetFoldersToCopy(const Game : TGame; const SourceDirs, DestDirs : TStringList) : Boolean;
    Procedure CalcDestDirs(const SourceDirs, DestDirs : TStringList);
    Function MakeImageFromFolderAndIncludeAutoexec(const SourceDirs, DestDirs : TStringList; const ImageFile : String; const Game : TGame; const NewGameDir : String) : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    SelectGame : TGame;
    NewGame : TGame;
  end;

var
  MakeBootImageFromProfileForm: TMakeBootImageFromProfileForm;

Function ShowMakeBootImageFromProfileDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASelectGame : TGame) : TGame;

implementation

uses LanguageSetupUnit, CommonTools, VistaToolsUnit, IconLoaderUnit,
     PrgSetupUnit, ImageTools, CreateImageToolsUnit, PrgConsts, HelpConsts,
     GameDBToolsUnit;

{$R *.dfm}

procedure TMakeBootImageFromProfileForm.FormCreate(Sender: TObject);
begin
  NewGame:=nil;

  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ImageFromProfile;
  InfoLabel.Caption:=LanguageSetup.ImageFromProfileInfoLabel;
  FreeSizeLabel.Caption:=LanguageSetup.ImageFromProfileFreeSize;
  FreeSizeMBLabel.Caption:=LanguageSetup.MBytes;
  CompressedCheckBox.Caption:=LanguageSetup.CreateImageFormCompression;
  MemoryManagerCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMemoryManager;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TMakeBootImageFromProfileForm.FormShow(Sender: TObject);
Var I,Nr : Integer;
    G : TGame;
begin
  Nr:=-1;
  ProfileComboBox.Items.BeginUpdate;
  try
    For I:=0 to GameDB.Count-1 do begin
      G:=GameDB[I];
      If ScummVMMode(G) or WindowsExeMode(G) then continue;
      If (Trim(G.AutoexecBootImage)<>'') or G.AutoexecOverridegamestart or G.AutoexecOverrideMount or (Trim(G.GameExe)='') then continue;
      ProfileComboBox.Items.AddObject(G.CacheName,G);
      If G=SelectGame then Nr:=ProfileComboBox.Items.Count-1;
    end;
  finally
    ProfileComboBox.Items.EndUpdate;
  end;
  If Nr>=0 then ProfileComboBox.ItemIndex:=Nr else begin
    If ProfileComboBox.Items.Count>0 then ProfileComboBox.ItemIndex:=0;
  end;
end;

Procedure TMakeBootImageFromProfileForm.CalcDestDirs(const SourceDirs, DestDirs : TStringList);
Var I,J : Integer;
    S,T : String;
begin
  For I:=0 to SourceDirs.Count-1 do begin
    S:=''; T:=SourceDirs[I]; If (T<>'') and (T[length(T)]='\') then SetLength(T,length(T)-1);
    J:=Pos('\',T); While J>0 do begin T:=Copy(T,J+1,MaxInt); J:=Pos('\',T); end;
    For J:=1 to length(T) do begin
      If T[J]<>' ' then S:=S+T[J];
      If length(S)>=8 then break;
    end;
    T:=ExtUpperCase(S);
    J:=1; S:=T;
    While DestDirs.IndexOf(S)>=0 do begin
      S:='~'+IntToStr(J);
      S:=Copy(T,1,8-length(S))+S;
      inc(J);
    end;
    DestDirs.Add(S);
  end;
end;

Function TMakeBootImageFromProfileForm.MakeImageFromFolderAndIncludeAutoexec(const SourceDirs, DestDirs : TStringList; const ImageFile: String; const Game: TGame; const NewGameDir : String) : Boolean;
const UpgradesWithoutMM=[dicuMakeBootable,dicuKeyboardDriver,dicuMouseDriver,dicuEditor,dicuAutoexecAddLines,dicuCopyFolder];
      UpgradesWithMM=[dicuMakeBootable,dicuKeyboardDriver,dicuMouseDriver,dicuMemoryManager,dicuEditor,dicuAutoexecAddLines,dicuCopyFolder];
Var ImageSize : Integer;
    St,St2 : TStringList;
    S,T : String;
    I : Integer;
    Upgrades : TDiskImageCreatorUpgrades;
begin
  result:=False;

  If MemoryManagerCheckBox.Checked then Upgrades:=UpgradesWithMM else Upgrades:=UpgradesWithoutMM;
  
  ImageSize:=DiskImageCreatorUpgradeSize(True,Upgrades,SourceDirs,FreeSizeEdit.Value);
  If not DiskImageCreator(ImageSize div 1024 div 1024+1,ImageFile,CompressedCheckBox.Checked,True) then exit;

  St:=TStringList.Create;
  try
    St2:=StringToStringList(Game.Autoexec); try St.AddStrings(St2); finally St2.Free; end;
    S:=Trim(NewGameDir);
    While S<>'' do begin
      I:=Pos('\',S);
      If I>0 then begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end else begin T:=S; S:=''; end;
      If T<>'' then St.Add('cd '+T);
    end;
    St.Add(ExtractFileName(Game.GameExe));
    St2:=StringToStringList(Game.AutoexecFinalization); try St.AddStrings(St2); finally St2.Free; end;

    If Game.SwapMouseButtons then Upgrades:=Upgrades+[dicuSwapMouseButtons];
    If Game.Force2ButtonMouseMode then Upgrades:=Upgrades+[dicuForce2ButtonMouseMode];

    If not DiskImageCreatorUpgrade(ImageFile,True,Upgrades,SourceDirs,DestDirs,St) then exit;
  finally
    St.Free;
  end;

  result:=True;
end;

Function IsDirectSubDir(const ShortParent, LongTestDir : String) : Boolean;
Var ShortTestDir,S : String;
begin
  result:=False;
  ShortTestDir:=ShortName(LongTestDir);
  If ExtUpperCase(Copy(ShortTestDir,1,length(ShortParent)))<>ExtUpperCase(ShortParent) then exit;
  S:=Copy(ShortTestDir,length(ShortParent)+1,MaxInt);
  If (S<>'') and (S[1]='\') then S:=Copy(S,2,MaxInt);
  If (S<>'') and (S[length(S)]='\') then SetLength(S,length(S)-1);
  S:=Trim(S);
  If S='' then exit;
  If Pos('\',S)>0 then exit;
  result:=True;
end;

Function TMakeBootImageFromProfileForm.GetFoldersToCopy(const Game : TGame; const SourceDirs, DestDirs : TStringList) : Boolean;
Var GameDir,ShortGamesDir,S : String;
    ExtraDirs : TStringList;
    I : Integer;
begin
  result:=False;
  GameDir:=IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir)));
  ShortGamesDir:=ShortName(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
  ExtraDirs:=ValueToList(Game.ExtraDirs);
  try
    I:=0; While I<ExtraDirs.Count-1 do If Trim(ExtraDirs[I])='' then ExtraDirs.Delete(I) else inc(I);

    If not IsDirectSubDir(ShortGamesDir,GameDir) then begin
      {GameDir outside games directory or not a direct subdirectory of the games directory}
      If ExtraDirs.Count>0 then begin
        If MessageDlg(Format(LanguageSetup.ImageFromProfileConfirmationGameDirectoryNotInGamesDirectory,[GameDir,MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)]),mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
      end;
      SourceDirs.Add(GameDir);
      CalcDestDirs(SourceDirs,DestDirs);
    end else begin
      {GameDir is a direct subdirectory of the games directory}
      SourceDirs.Add(GameDir);
      For I:=0 to ExtraDirs.Count-1 do begin
        S:=MakeAbsPath(ExtraDirs[I],PrgSetup.BaseDir);
        If not IsDirectSubDir(ShortGamesDir,S) then begin
          If MessageDlg(Format(LanguageSetup.ImageFromProfileConfirmationExtraDirectoryNotInGamesDirectory,[ExtraDirs[I],MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)]),mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
        end else begin
          SourceDirs.Add(S);
        end;
      end;
      CalcDestDirs(SourceDirs,DestDirs);
    end;
    result:=True;
  finally
    ExtraDirs.Free;
  end;
end;

procedure TMakeBootImageFromProfileForm.OKButtonClick(Sender: TObject);
Var Game : TGame;
    GameDir, NewGameDir, ImageFileName, NewGameName, S : String;
    I : Integer;
    St,SourceDirs,DestDirs : TStringList;
begin
  If ProfileComboBox.ItemIndex<0 then exit;
  Game:=TGame(ProfileComboBox.Items.Objects[ProfileComboBox.ItemIndex]);

  SourceDirs:=TStringList.Create;
  DestDirs:=TStringList.Create;
  try
    {Collect folders to copy}
    if not GetFoldersToCopy(Game,SourceDirs,DestDirs) then exit;

    {Prepare directory for new profile}
    GameDir:=IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir)));
    NewGameDir:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(GameDir)+'-Boot');
    I:=0; While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(NewGameDir) do begin
      inc(I);
      NewGameDir:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(GameDir)+'-Boot'+IntToStr(I));
    end;
    ForceDirectories(NewGameDir);

    {Create Image}
    ImageFileName:=NewGameDir+MakeFileSysOKFolderName(Game.CacheName)+'-Harddisk.img';
    if not MakeImageFromFolderAndIncludeAutoexec(SourceDirs,DestDirs,ImageFileName,Game,DestDirs[0]) then begin ModalResult:=mrNone; exit; end;
  finally
    SourceDirs.Free;
    DestDirs.Free;
  end;

  {Setup new profile}
  NewGameName:=Game.CacheName+' ('+LanguageSetup.ImageFromProfileProfileNameAdd+')';
  I:=GameDB.Add(NewGameName);
  NewGame:=GameDB[I];
  NewGame.AssignFrom(Game);
  with NewGame do begin
    Name:=NewGameName;
    GameExe:='';
    GameExeMD5:='';
    SetupExe:='';
    SetupExeMD5:='';
    For I:=0 to 9 do ExtraPrgFile[I]:='';
    Autoexec:='';
    AutoexecFinalization:='';
    DataDir:='';
    NrOfMounts:=1;
    Mount0:=MakeRelPath(ImageFileName,PrgSetup.BaseDir)+';IMAGE;2;;;'+GetGeometryFromFile(ImageFileName);
    AutoexecBootImage:='2';
  end;

  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(NewGame.Name)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    Inc(I);
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(NewGame.Name)+IntToStr(I)+'\';
  end;
  NewGame.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);

  St:=TStringList.Create;
  try
    St.Add(MakeRelPath(NewGameDir,PrgSetup.BaseDir));
    NewGame.ExtraDirs:=ListToValue(St);
  finally
    St.Free;
  end;

  NewGame.StoreAllValues;
  NewGame.LoadCache;
end;

procedure TMakeBootImageFromProfileForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImageFromProfile);
end;

procedure TMakeBootImageFromProfileForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowMakeBootImageFromProfileDialog(const AOwner : TComponent; const AGameDB : TGameDB; const ASelectGame : TGame) : TGame;
begin
  result:=nil;

  if not DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    MessageDlg(LanguageSetup.ProfileEditorNeedFreeDOS,mtError,[mbOK],0);
    exit;
  end;
  If (not FileExists(PrgDir+MakeDOSFilesystemFileName)) and (not FileExists(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName)) then begin
    MessageDlg(Format(LanguageSetup.ImageFromProfileMKDOSFSNeeded,[PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName]),mtError,[mbOK],0);
    exit;
  end;

  MakeBootImageFromProfileForm:=TMakeBootImageFromProfileForm.Create(AOwner);
  try
    MakeBootImageFromProfileForm.GameDB:=AGameDB;
    MakeBootImageFromProfileForm.SelectGame:=ASelectGame;
    If MakeBootImageFromProfileForm.ShowModal=mrOK then result:=MakeBootImageFromProfileForm.NewGame;
  finally
    MakeBootImageFromProfileForm.Free;
  end;
end;

end.
