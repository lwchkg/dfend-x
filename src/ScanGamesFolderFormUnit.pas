unit ScanGamesFolderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, GameDBUnit, ImgList, ToolWin,
  Menus;

Type TNewGame=class
  private
    FName, FExeFile : String;
    FSelectedTemplate : Integer;
    FMatchingAutoSetup, FAllExeFiles : TStringList;
  public
    Constructor Create(const AName, AExeFile : String);
    Destructor Destroy; override;
    Function MatchingAutoSetupTemplate(const AutoSetupTemplateNr : Integer) : Boolean;
    Procedure SetExeNameFromMatchingAutoSetupTemplate(const AutoSetupTemplateNr : Integer);
    property Name : String read FName write FName;
    property ExeFile : String read FExeFile write FExeFile;
    property SelectedTemplate : Integer read FSelectedTemplate write FSelectedTemplate; {>=0 -> auto setup template, -1=default template, -2=template 0, -3=template 1, ...}
    property MatchingAutoSetup : TStringList read FMatchingAutoSetup;
    property AllExeFiles : TStringList read FAllExeFiles;
end;

type
  TScanGamesFolderForm = class(TForm)
    EditPanel: TPanel;
    List: TListView;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton2: TToolButton;
    NameTypeButton: TToolButton;
    OpenFolderButton: TToolButton;
    ScanButton: TToolButton;
    AddButton: TToolButton;
    ToolButton7: TToolButton;
    HelpButton: TToolButton;
    ImageList: TImageList;
    PopupMenuName: TPopupMenu;
    PopupNameFilename: TMenuItem;
    PopupNameFoldername: TMenuItem;
    ProfileNameEdit: TLabeledEdit;
    Template1Label: TLabel;
    Template1ComboBox: TComboBox;
    Template2Label: TLabel;
    Template2ComboBox: TComboBox;
    ProgramFileComboBox: TComboBox;
    ProgramFileLabel: TLabel;
    PopupMenu: TPopupMenu;
    PopupSelectAll: TMenuItem;
    PopupSelectNone: TMenuItem;
    PopupSelectAutoSetup: TMenuItem;
    InfoPanel: TPanel;
    InfoLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormShow(Sender: TObject);
    procedure Template1ComboBoxChange(Sender: TObject);
    Procedure UpdateListRec(Sender : TObject);
    procedure ComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    NewGames : TList;
    AutoSetupDB, TemplateDB : TGameDB;
    LastSelected, LastTemplateType : Integer;
    JustUpdating : Boolean;
    Procedure Clear;
    Procedure SetColWidths;
    Procedure AddResultsToList;
    Procedure ScanFolders;
    Procedure ScanFolder(const Folder : String; const AddAllPrgs : Boolean);
    Function FolderAlreadyknown(const Folder : String) : Boolean;
    Function GetSubFolderList: TStringList;
    Procedure AddGame(const NewGame : TNewGame);
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    GamesAdded : Boolean;
  end;

var
  ScanGamesFolderForm: TScanGamesFolderForm;

Function ShowScanGamesFolderResultsDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShellAPI, Math, CommonTools, PrgSetupUnit, LanguageSetupUnit,
     VistaToolsUnit, HelpConsts, PrgConsts, WaitFormUnit, ZipPackageUnit,
     IconLoaderUnit, GameDBToolsUnit, HashCalc;

{$R *.dfm}

{ TNewGame }

constructor TNewGame.Create(const AName, AExeFile: String);
begin
  inherited Create;
  FName:=AName;
  FExeFile:=AExeFile;
  FSelectedTemplate:=-1;
  FMatchingAutoSetup:=TStringList.Create;
  FAllExeFiles:=TStringList.Create;
end;

destructor TNewGame.Destroy;
begin
  FMatchingAutoSetup.Free;
  FAllExeFiles.Free;
  inherited Destroy;
end;

Function TNewGame.MatchingAutoSetupTemplate(const AutoSetupTemplateNr : Integer) : Boolean;
Var I : Integer;
begin
  result:=True;
  For I:=0 to FMatchingAutoSetup.Count-1 do If Integer(FMatchingAutoSetup.Objects[I])=AutoSetupTemplateNr then exit;
  result:=False;
end;

Procedure TNewGame.SetExeNameFromMatchingAutoSetupTemplate(const AutoSetupTemplateNr : Integer);
Var I : Integer;
begin
  For I:=0 to FMatchingAutoSetup.Count-1 do If Integer(FMatchingAutoSetup.Objects[I])=AutoSetupTemplateNr then begin
    FExeFile:=IncludeTrailingPathDelimiter(ExtractFilePath(FExeFile))+FMatchingAutoSetup[I];
    exit;
  end;
end;

{ TScanGamesFolderResultsForm }

procedure TScanGamesFolderForm.FormCreate(Sender: TObject);
Var C : TListColumn;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.AutoDetectGames;
  CloseButton.Caption:=LanguageSetup.Close;
  CloseButton.Hint:=LanguageSetup.CloseHintWindow;
  OpenFolderButton.Caption:=LanguageSetup.AutoDetectGamesOpenFolderButton;
  OpenFolderButton.Hint:=LanguageSetup.AutoDetectGamesOpenFolderButtonHint;
  NameTypeButton.Caption:=LanguageSetup.AutoDetectProfileNameType;
  NameTypeButton.Hint:=LanguageSetup.AutoDetectProfileNameTypeHint;
  ScanButton.Caption:=LanguageSetup.AutoDetectGamesScanButton;
  ScanButton.Hint:=LanguageSetup.AutoDetectGamesScanButtonHint;
  AddButton.Caption:=LanguageSetup.AutoDetectGamesAddButton;
  AddButton.Hint:=LanguageSetup.AutoDetectGamesAddButtonHint;
  HelpButton.Caption:=LanguageSetup.Help;
  HelpButton.Hint:=LanguageSetup.HelpHint;
  PopupNameFilename.Caption:=LanguageSetup.AutoDetectProfileNameTypeGameFilename;
  PopupNameFoldername.Caption:=LanguageSetup.AutoDetectProfileNameTypeFoldername;
  PopupSelectAll.Caption:=LanguageSetup.AutoDetectProfilePopupSelectAll;
  PopupSelectAutoSetup.Caption:=LanguageSetup.AutoDetectProfilePopupSelectAutoSetup;
  PopupSelectNone.Caption:=LanguageSetup.AutoDetectProfilePopupSelectNone;
  InfoLabel.Caption:=LanguageSetup.AutoDetectGamesResultStart;
  C:=List.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.AutoDetectProfileListName;
  C:=List.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.AutoDetectProfileListFolder;
  C:=List.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.AutoDetectProfileListFilename;
  C:=List.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.AutoDetectProfileListTemplate;

  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.AutoDetectProfileEditProfileName;
  Template1Label.Caption:=LanguageSetup.AutoDetectProfileEditTemplateType;
  Template2Label.Caption:=LanguageSetup.AutoDetectProfileEditTemplate;
  ProgramFileLabel.Caption:=LanguageSetup.AutoDetectProfileEditProgramFile;
  Template1ComboBox.Items.Add(LanguageSetup.AutoDetectProfileEditTemplateTypeUser);
  Template1ComboBox.Items.Add(LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup1);
  Template1ComboBox.Items.Add(LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup2);

  UserIconLoader.DialogImage(DI_CloseWindow,ImageList,CloseButton.ImageIndex);
  UserIconLoader.DialogImage(DI_SelectFolder,ImageList,OpenFolderButton.ImageIndex);
  UserIconLoader.DialogImage(DI_NameType,ImageList,NameTypeButton.ImageIndex);
  UserIconLoader.DialogImage(DI_Wizard,ImageList,ScanButton.ImageIndex);
  UserIconLoader.DialogImage(DI_Add,ImageList,AddButton.ImageIndex);
  UserIconLoader.DialogImage(DI_ToolbarHelp,ImageList,HelpButton.ImageIndex);

  If PrgSetup.ScanFolderUseFileName then PopupNameFilename.Checked:=True else PopupNameFoldername.Checked:=True;

  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);

  NewGames:=TList.Create;

  GamesAdded:=False;
  LastSelected:=-1; JustUpdating:=False;
end;

procedure TScanGamesFolderForm.FormShow(Sender: TObject);
begin
  SetColWidths;
end;

procedure TScanGamesFolderForm.FormDestroy(Sender: TObject);
Var I : Integer;
begin
  LastSelected:=-1;
  PrgSetup.ScanFolderUseFileName:=PopupNameFilename.Checked;
  AutoSetupDB.Free;
  TemplateDB.Free;

  For I:=0 to NewGames.Count-1 do TNewGame(NewGames[I]).Free;
  NewGames.Free;
end;

procedure TScanGamesFolderForm.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          ShellExecute(Handle,'explore',PChar(S),nil,PChar(S),SW_SHOW);
        end;
    2 : NameTypeButton.CheckMenuDropdown;
    3 : begin
          Enabled:=False;
          try
            Clear;
            ScanFolders;
            SetColWidths;
          finally
            Enabled:=True;
          end;
        end;
    4 : begin
          List.ItemIndex:=-1; ListChange(List,List.Selected,ctState);
          I:=0;
          While I<List.Items.Count do begin
            If not List.Items[I].Checked then begin Inc(I); continue; end;
            GamesAdded:=True;
            AddGame(TNewGame(NewGames[I]));
            TNewGame(NewGames[I]).Free; NewGames.Delete(I); List.Items.Delete(I);
          end;
        end;
    5 : Application.HelpCommand(HELP_CONTEXT,ID_ExtrasScanGamesFolder);
    6 : PopupNameFilename.Checked:=True;
    7 : PopupNameFoldername.Checked:=True;
    8 : begin
          ListChange(List,List.Selected,ctState);
          For I:=0 to List.Items.Count-1 do List.Items[I].Checked:=True;
        end;
    9 : begin
          ListChange(List,List.Selected,ctState);
          For I:=0 to List.Items.Count-1 do List.Items[I].Checked:=(TNewGame(NewGames[I]).SelectedTemplate>=0);
        end;
   10 : begin
          ListChange(List,List.Selected,ctState);
          For I:=0 to List.Items.Count-1 do List.Items[I].Checked:=False;
        end;
  end;
end;

Procedure TScanGamesFolderForm.SetColWidths;
Var I : Integer;
begin
  For I:=0 to List.Columns.Count-1 do If List.Items.Count>0 then begin
    List.Column[I].Width:=-2;
    List.Column[I].Width:=-1;
  end else begin
    List.Column[I].Width:=-2;
  end;

  AddButton.Enabled:=(List.Items.Count>0);
  PopupSelectAll.Enabled:=(List.Items.Count>0);
  PopupSelectAutoSetup.Enabled:=(List.Items.Count>0);
  PopupSelectNone.Enabled:=(List.Items.Count>0);
end;

procedure TScanGamesFolderForm.Clear;
Var I : Integer;
begin
  LastSelected:=-1;

  For I:=0 to NewGames.Count-1 do TNewGame(NewGames[I]).Free;
  NewGames.Clear;
  List.Items.Clear;

  ListChange(List,List.Selected,ctState);
end;

procedure TScanGamesFolderForm.ComboBoxDropDown(Sender: TObject);
begin
  If Sender is TComboBox then SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TScanGamesFolderForm.AddResultsToList;
Var I,T : Integer;
    L : TListItem;
begin
  For I:=0 to NewGames.Count-1 do begin
    L:=List.Items.Add;
    L.Caption:=TNewGame(NewGames[I]).Name;
    L.SubItems.Add(MakeRelPath(ExtractFilePath(TNewGame(NewGames[I]).ExeFile),PrgSetup.BaseDir));
    L.SubItems.Add(ExtractFileName(TNewGame(NewGames[I]).ExeFile));
    T:=TNewGame(NewGames[I]).SelectedTemplate;
    If T>=0 then L.SubItems.Add(AutoSetupDB[T].CacheName) else begin
      If T=-1 then L.SubItems.Add(LanguageSetup.TemplateFormDefault) else L.SubItems.Add(TemplateDB[-T-2].CacheName);
    end;
    L.Checked:=(T>=0);
  end;

  If List.Items.Count>0 then List.ItemIndex:=0;
  ListChange(List,List.Selected,ctState);
end;

procedure TScanGamesFolderForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then ButtonWork(HelpButton);
end;

procedure TScanGamesFolderForm.UpdateListRec(Sender : TObject);
Var NewGame : TNewGame;
begin
  If (LastSelected<0) or JustUpdating then exit;

  NewGame:=TNewGame(NewGames[LastSelected]);
  NewGame.Name:=ProfileNameEdit.Text;
  List.Items[LastSelected].Caption:=ProfileNameEdit.Text;
  If Template1ComboBox.ItemIndex=2 then begin
    {(Matching) auto setup}
    NewGame.SelectedTemplate:=Integer(Template2ComboBox.Items.Objects[Template2ComboBox.ItemIndex]);
    NewGame.SetExeNameFromMatchingAutoSetupTemplate(NewGame.SelectedTemplate);
  end else begin
    If Template1ComboBox.ItemIndex=1 then begin
      {(Not matching) auto setup template}
      If Template2ComboBox.ItemIndex<0 then NewGame.SelectedTemplate:=-1 else NewGame.SelectedTemplate:=Integer(Template2ComboBox.Items.Objects[Template2ComboBox.ItemIndex]);
      NewGame.ExeFile:=IncludeTrailingPathDelimiter(ExtractFilePath(NewGame.ExeFile))+ProgramFileComboBox.Text;
    end else begin
      {User template}
      NewGame.SelectedTemplate:=-Template2ComboBox.ItemIndex-1;
      NewGame.ExeFile:=IncludeTrailingPathDelimiter(ExtractFilePath(NewGame.ExeFile))+ProgramFileComboBox.Text;
    end;
  end;
  List.Items[LastSelected].SubItems[1]:=ExtractFileName(NewGame.ExeFile);
  If NewGame.SelectedTemplate>=0 then List.Items[LastSelected].SubItems[2]:=AutoSetupDB[NewGame.SelectedTemplate].CacheName else begin
    If NewGame.SelectedTemplate=-1 then List.Items[LastSelected].SubItems[2]:=LanguageSetup.TemplateFormDefault else List.Items[LastSelected].SubItems[2]:=TemplateDB[-NewGame.SelectedTemplate-2].CacheName;
  end;
end;

procedure TScanGamesFolderForm.ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
Var NewGame : TNewGame;
begin
  If LastSelected>=0 then UpdateListRec(Sender);

  LastSelected:=List.ItemIndex;
  EditPanel.Visible:=(List.ItemIndex>=0);
  If List.ItemIndex<0 then exit;
  NewGame:=TNewGame(NewGames[LastSelected]);

  JustUpdating:=True;
  try
    ProfileNameEdit.Text:=NewGame.Name;
    If NewGame.MatchingAutoSetup.Count=0 then begin
      If Template1ComboBox.Items.Count=3 then Template1ComboBox.Items.Delete(2);
    end else begin
      If Template1ComboBox.Items.Count=2 then Template1ComboBox.Items.Add(LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup2);
    end;
    If NewGame.SelectedTemplate>=0 then begin
      If NewGame.MatchingAutoSetupTemplate(NewGame.SelectedTemplate) then Template1ComboBox.ItemIndex:=2 else Template1ComboBox.ItemIndex:=1;
    end else begin
      Template1ComboBox.ItemIndex:=0;
    end;

    ProgramFileComboBox.Items.Clear;
    ProgramFileComboBox.Items.AddStrings(NewGame.AllExeFiles);
    ProgramFileComboBox.ItemIndex:=ProgramFileComboBox.Items.IndexOf(ExtractFileName(NewGame.ExeFile));

    LastTemplateType:=-1;
    Template1ComboBoxChange(Sender);
  finally
    JustUpdating:=False;
  end;
end;

procedure TScanGamesFolderForm.Template1ComboBoxChange(Sender: TObject);
Var I,J : Integer;
    NewGame : TNewGame;
    SaveState : Boolean;
begin
  If List.ItemIndex<0 then exit;
  NewGame:=TNewGame(NewGames[List.ItemIndex]);

  ProgramFileLabel.Visible:=(Template1ComboBox.ItemIndex<2) and (ProgramFileComboBox.Items.Count>1);
  ProgramFileComboBox.Visible:=(Template1ComboBox.ItemIndex<2) and (ProgramFileComboBox.Items.Count>1);
  Template2Label.Visible:=(Template1ComboBox.ItemIndex<2) or (NewGame.MatchingAutoSetup.Count>1);
  Template2ComboBox.Visible:=(Template1ComboBox.ItemIndex<2) or (NewGame.MatchingAutoSetup.Count>1);
  If (Template1ComboBox.ItemIndex<2) or (NewGame.MatchingAutoSetup.Count>1) then begin
    EditPanel.ClientHeight:=Template2ComboBox.Top+Template2ComboBox.Height+8;
  end else begin
    EditPanel.ClientHeight:=ProfileNameEdit.Top+ProfileNameEdit.Height+8;
  end;

  SaveState:=JustUpdating; JustUpdating:=True;
  try
    {User template}
    If Template1ComboBox.ItemIndex=0 then begin
      Template2ComboBox.Items.BeginUpdate;
      try
        Template2ComboBox.Items.Clear;
        Template2ComboBox.Items.Add(LanguageSetup.TemplateFormDefault);
        For I:=0 to TemplateDB.Count-1 do Template2ComboBox.Items.Add(TemplateDB[I].CacheName);
      finally
        Template2ComboBox.Items.EndUpdate;
      end;
      Template2ComboBox.ItemIndex:=Max(0,Min(Template2ComboBox.Items.Count-1,-NewGame.SelectedTemplate-1));
      exit;
    end;

    {(Not matching) auto setup template}
    If Template1ComboBox.ItemIndex=1 then begin
      Template2ComboBox.Items.BeginUpdate;
      try
        Template2ComboBox.Items.Clear;
        For I:=0 to AutoSetupDB.Count-1 do If Template2ComboBox.Items.IndexOf(AutoSetupDB[I].CacheName)<0 then Template2ComboBox.Items.AddObject(AutoSetupDB[I].CacheName,TObject(I));
      finally
        Template2ComboBox.Items.EndUpdate;
      end;
      I:=-1;
      For J:=0 to Template2ComboBox.Items.Count-1 do If Integer(Template2ComboBox.Items.Objects[J])=NewGame.SelectedTemplate then begin I:=J; break; end;
      Template2ComboBox.ItemIndex:=Max(0,Min(Template2ComboBox.Items.Count-1,I));
      exit;
    end;

    {(Matching) auto setup template}
    If Template1ComboBox.ItemIndex=2 then begin
      Template2ComboBox.Items.BeginUpdate;
      try
        Template2ComboBox.Items.Clear;
        J:=0;
        For I:=0 to NewGame.MatchingAutoSetup.Count-1 do begin
          Template2ComboBox.Items.AddObject(AutoSetupDB[Integer(NewGame.MatchingAutoSetup.Objects[I])].CacheName,NewGame.MatchingAutoSetup.Objects[I]);
          If Integer(NewGame.MatchingAutoSetup.Objects[I])=NewGame.SelectedTemplate then J:=I;
        end;
      finally
        Template2ComboBox.Items.EndUpdate;
      end;
      Template2ComboBox.ItemIndex:=J;
      exit;
    end;

  finally
    JustUpdating:=SaveState;
    UpdateListRec(Sender);
  end;
end;

function TScanGamesFolderForm.GetSubFolderList: TStringList;
Var Rec : TSearchRec;
    I : Integer;
    S : String;
begin
  result:=TStringList.Create;

  If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
  S:=IncludeTrailingPathDelimiter(S);

  I:=FindFirst(S+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') then result.Add(S+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TScanGamesFolderForm.ScanFolder(const Folder: String; const AddAllPrgs : Boolean);
Var S,FileToStart : String;
    NewGame : TNewGame;
    Templates,PrgFiles : TStringList;
    I,J,NewLevel : Integer;
begin
  If (not AddAllPrgs) and FolderAlreadyknown(Folder) then exit;

  PrgFiles:=TStringList.Create;
  try
    Templates:=GetTemplateFromFolderExt(True,Folder,AutoSetupDB,PrgFiles);
    try
      If PrgFiles.Count=0 then exit;

      If Templates.Count=0 then begin
        NewLevel:=-1;
        For I:=0 to PrgFiles.Count-1 do begin
          J:=Integer(PrgFiles.Objects[I]);
          If (J>NewLevel) then begin NewLevel:=J; FileToStart:=PrgFiles[I] end;
        end;
        If PopupNameFilename.Checked then begin
          NewGame:=TNewGame.Create(ChangeFileExt(FileToStart,''),IncludeTrailingPathDelimiter(Folder)+FileToStart);
        end else begin
          S:=Folder; If (S<>'') and (S[length(S)]='\') then SetLength(S,length(S)-1);
          While (S<>'') and (Pos('\',S)<>0) do begin S:=Copy(S,Pos('\',S)+1,MaxInt); end;
          If S='' then S:=ChangeFileExt(FileToStart,'');
          NewGame:=TNewGame.Create(S,IncludeTrailingPathDelimiter(Folder)+FileToStart);
        end;
        NewGame.SelectedTemplate:=-1;
        NewGame.AllExeFiles.AddStrings(PrgFiles);
        NewGames.Add(NewGame);
      end else begin
        If (Templates.Count=1) or (not AddAllPrgs) then begin
          FileToStart:=Templates[0];
          NewGame:=TNewGame.Create(AutoSetupDB[Integer(Templates.Objects[0])].CacheName,IncludeTrailingPathDelimiter(Folder)+FileToStart);
          NewGame.MatchingAutoSetup.AddStrings(Templates);
          NewGame.SelectedTemplate:=Integer(Templates.Objects[0]);
          NewGame.AllExeFiles.AddStrings(PrgFiles);
          NewGames.Add(NewGame);
        end else begin
          For I:=0 to Templates.Count-1 do begin
            FileToStart:=Templates[I];
            NewGame:=TNewGame.Create(AutoSetupDB[Integer(Templates.Objects[I])].CacheName,IncludeTrailingPathDelimiter(Folder)+FileToStart);
            NewGame.MatchingAutoSetup.AddStrings(Templates);
            NewGame.SelectedTemplate:=Integer(Templates.Objects[I]);
            NewGame.AllExeFiles.Add(FileToStart);
            NewGames.Add(NewGame);
          end;
        end;
      end;
    finally
      Templates.Free;
    end;
  finally
    PrgFiles.Free;
  end;
end;

Function TScanGamesFolderForm.FolderAlreadyknown(const Folder : String) : Boolean;
Var I,J : Integer;
    S,T : String;
    St : TStringList;
begin
  result:=True;

  T:=ExtUpperCase(Folder);
  For I:=0 to GameDB.Count-1 do begin
    S:=GameDB[I].GameExe;
    If (S<>'') and (ExtUpperCase(Copy(S,1,7))<>'DOSBOX:') then begin
      S:=ExtUpperCase(MakeAbsPath(S,PrgSetup.BaseDir));
      If Copy(S,1,length(T))=T then exit;
    end;
    S:=GameDB[I].SetupExe;
    If (S<>'') and (ExtUpperCase(Copy(S,1,7))<>'DOSBOX:') then begin
      S:=ExtUpperCase(MakeAbsPath(S,PrgSetup.BaseDir));
      If Copy(S,1,length(T))=T then exit;
    end;
    If Trim(GameDB[I].ExtraDirs)<>'' then begin
      St:=ValueToList(GameDB[I].ExtraDirs);
      try
        For J:=0 to St.Count-1 do If Trim(St[J])<>'' then begin
          S:=ExtUpperCase(MakeAbsPath(St[J],PrgSetup.BaseDir));
          If Copy(S,1,length(T))=T then exit;
        end;
      finally
        St.Free;
      end;
    end;
  end;

  result:=False;
end;

procedure TScanGamesFolderForm.ScanFolders;
Var Dirs : TStringList;
    FreeDOS,Dir : String;
    I : Integer;
begin
  InfoPanel.Visible:=False;
  Dirs:=GetSubFolderList;

  FreeDOS:=Trim(PrgSetup.PathToFREEDOS);
  If FreeDOS<>'' then FreeDOS:=IncludeTrailingPathDelimiter(MakeAbsPath(FreeDOS,PrgSetup.BaseDir));
  If not DirectoryExists(FreeDOS) then FreeDOS:='';
  FreeDOS:=ExtUpperCase(FreeDOS);

  try
    WaitForm:=CreateWaitForm(self,LanguageSetup.AutoDetectProfileScanning,Dirs.Count);
    try
      For I:=0 to Dirs.Count-1 do begin
        WaitForm.Step(I);
        Dir:=IncludeTrailingPathDelimiter(Dirs[I]);
        ScanFolder(Dir,ExtUpperCase(Dir)=FreeDOS);
      end;
    finally
      FreeAndNil(WaitForm);
      ForceForegroundWindow(Handle);
    end;
  finally
    Dirs.Free;
  end;

  AddResultsToList;
  If List.Items.Count=0 then begin
    InfoLabel.Caption:=LanguageSetup.AutoDetectGamesResultNoGames;
    InfoPanel.Visible:=True;
  end;
end;

procedure TScanGamesFolderForm.AddGame(const NewGame: TNewGame);
Var G,G2 : TGame;
    I : Integer;
    Folder : String;
    Rec : TSearchRec;
    S : String;
    St : TStringList;
begin
  I:=GameDB.Add(NewGame.Name);
  G:=GameDB[I];

  If NewGame.SelectedTemplate>=0 then begin
    If NewGame.MatchingAutoSetupTemplate(NewGame.SelectedTemplate) then begin
      {Matching auto setup template}
      G.AssignFrom(AutoSetupDB[NewGame.SelectedTemplate]);
    end else begin
      {Not matching auto setup template}
      G.AssignFrom(AutoSetupDB[NewGame.SelectedTemplate]);
    end;
    G.GameExe:=MakeRelPath(NewGame.ExeFile,PrgSetup.BaseDir);
    G.GameExeMD5:=GetMD5Sum(MakeAbsPath(G.GameExe,PrgSetup.BaseDir),False);
    If (Trim(G.SetupExe)<>'') and FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir)))+ExtractFileName(G.SetupExe)) then begin
      G.SetupExe:=MakeRelPath(IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir)))+ExtractFileName(G.SetupExe),PrgSetup.BaseDir);
      G.SetupExeMD5:=GetMD5Sum(MakeAbsPath(G.SetupExe,PrgSetup.BaseDir),False);
    end else begin
      G.SetupExe:='';
      G.SetupExeMD5:='';
    end;
  end else begin
    If NewGame.SelectedTemplate=-1 then begin
      {Default template}
      G2:=TGame.Create(PrgSetup); try G.AssignFrom(G2); finally G2.Free; end;
    end else begin
      {User template}
      G.AssignFrom(TemplateDB[-NewGame.SelectedTemplate-2]);
    end;
    G.GameExe:=MakeRelPath(NewGame.ExeFile,PrgSetup.BaseDir);
  end;
  G.Name:=NewGame.Name;

  If Trim(NewGame.ExeFile)<>'' then S:=ExtractFilePath(NewGame.ExeFile) else S:='';
  If ExtUpperCase(Copy(Trim(S),1,7))='DOSBOX:' then S:='';
  St:=BuildGameDirMountData(G,S,'');
  try
    For I:=0 to 9 do G.Mount[I]:='';
    G.NrOfMounts:=St.Count;
    For I:=0 to St.Count-1 do G.Mount[I]:=St[I];
  finally
    St.Free;
  end;

  Folder:=IncludeTrailingPathDelimiter(ExtractFilePath(NewGame.ExeFile));

  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(G.Name)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    Inc(I);
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(G.Name)+IntToStr(I)+'\';
  end;
  G.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
  ForceDirectories(MakeAbsPath(G.CaptureFolder,PrgSetup.BaseDir));

  {Look for Icons in game folder}
  I:=FindFirst(Folder+'*.ico',faAnyFile,Rec);
  try
    If I=0 then G.Icon:=MakeRelPath(Folder+Rec.Name,PrgSetup.BaseDir);
  finally
    FindClose(Rec);
  end;

  G.ProfileMode:='DOSBox';
  G.StoreAllValues;
  G.LoadCache;
end;

{ global }

Function ShowScanGamesFolderResultsDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  ScanGamesFolderForm:=TScanGamesFolderForm.Create(AOwner);
  try
    ScanGamesFolderForm.GameDB:=AGameDB;
    ScanGamesFolderForm.ShowModal;
    result:=ScanGamesFolderForm.GamesAdded;
  finally
    ScanGamesFolderForm.Free;
  end;
end;

end.
