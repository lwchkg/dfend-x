unit ViewFilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, ToolWin,
  Menus;

type
  TViewFilesFrame = class(TFrame)
    ToolBar: TToolBar;
    Tree: TTreeView;
    List: TListView;
    Splitter: TSplitter;
    ImageList: TImageList;
    UpdateButton: TToolButton;
    InfoLabel: TLabel;
    SetupDataDirButton: TBitBtn;
    OpenButton: TToolButton;
    OpenFileButton: TToolButton;
    TreePopupMenu: TPopupMenu;
    TreeUpdate: TMenuItem;
    TreeRename: TMenuItem;
    TreeDelete: TMenuItem;
    N4: TMenuItem;
    TreeExplorer: TMenuItem;
    ListPopupMenu: TPopupMenu;
    ListRun: TMenuItem;
    N2: TMenuItem;
    ListUpdate: TMenuItem;
    ListRename: TMenuItem;
    ListDelete: TMenuItem;
    N5: TMenuItem;
    ListExplorer: TMenuItem;
    ListOpenInDefaultViewer: TMenuItem;
    TreeCreateFolder: TMenuItem;
    ListCreateFolder: TMenuItem;
    N1: TMenuItem;
    ListUseInScreenshotList: TMenuItem;
    procedure SetupDataDirButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure ListInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure ListDblClick(Sender: TObject);
    procedure ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure MenuWork(Sender: TObject);
    procedure TreePopupMenuPopup(Sender: TObject);
    procedure TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    { Private-Deklarationen }
    Game : TGame;
    hChangeNotification : THandle;
    Timer : TTimer;
    PopupSelNode : TTreeNode;
    FOnUpdateGamesList : TNotifyEvent;
    Function GetNewDataFolderName : String;
    Function ReadTree(const ParentNode : TTreeNode; const Dir, OldSelNode : String) : TTreeNode;
    Function GetCurrentPath(const  TreeNode : TTreeNode = nil) : String;
    Function FileInDir(const Dir : String) : Boolean;
    Procedure TimerWork(Sender : TObject);
    Procedure RunFile(const ForceExternalViewer : Boolean);
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure Init;
    Procedure LoadLanguage;
    Procedure SetGame(const AGame : TGame);
    property OnUpdateGamesList : TNotifyEvent read FOnUpdateGamesList write FOnUpdateGamesList;
  end;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     ViewImageFormUnit, PlaySoundFormUnit, PlayVideoFormUnit, GameDBToolsUnit,
     ClassExtensions, IconLoaderUnit;

{$R *.dfm}

{ TViewFilesFrame }

constructor TViewFilesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  PopupSelNode:=nil;
  hChangeNotification:=INVALID_HANDLE_VALUE;

  Timer:=TTimer.Create(self);
  with Timer do begin
    Enabled:=False;
    Interval:=500;
    OnTimer:=TimerWork;
  end;
end;

destructor TViewFilesFrame.Destroy;
begin
  If hChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hChangeNotification);
  inherited Destroy;
end;

procedure TViewFilesFrame.Init;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  InfoLabel.Top:=16;
  InfoLabel.WordWrap:=True;
  SetupDataDirButton.Top:=16+InfoLabel.Height+8;

  NoFlicker(SetupDataDirButton);

  ListRun.ShortCut:=ShortCut(VK_RETURN,[]);

  Tree:=TTreeView(NewWinControlType(Tree,TTreeViewAcceptingFiles,ctcmDangerousMagic));
  TTreeViewAcceptingFiles(Tree).ActivateAcceptFiles;
  List:=TListView(NewWinControlType(List,TListViewAcceptingFiles,ctcmDangerousMagic));
  TListViewAcceptingFiles(List).ActivateAcceptFiles;
end;

procedure TViewFilesFrame.LoadLanguage;
begin
  SetupDataDirButton.Caption:=LanguageSetup.ViewDataFilesSetup;
  InfoLabel.Caption:=LanguageSetup.ViewDataFilesSetupInfo;
  UpdateButton.Caption:=LanguageSetup.ViewDataFilesUpdate;
  UpdateButton.Hint:=LanguageSetup.ViewDataFilesUpdateHint;
  OpenButton.Caption:=LanguageSetup.ViewDataFilesOpen;
  OpenButton.Hint:=LanguageSetup.ViewDataFilesOpenHint;
  OpenFileButton.Caption:=LanguageSetup.ViewDataFilesOpenFile;
  OpenFileButton.Hint:=LanguageSetup.ViewDataFilesOpenFileHint;
  TreeUpdate.Caption:=LanguageSetup.ViewDataFilesUpdate;
  TreeCreateFolder.Caption:=LanguageSetup.ViewDataFilesCreateFolder;
  TreeRename.Caption:=LanguageSetup.ViewDataFilesRename;
  TreeDelete.Caption:=LanguageSetup.ViewDataFilesDelete;
  TreeExplorer.Caption:=LanguageSetup.ViewDataFilesOpen;
  ListRun.Caption:=LanguageSetup.ViewDataFilesOpenFile;
  ListOpenInDefaultViewer.Caption:=LanguageSetup.ViewDataFilesOpenInDefaultViewer;
  ListUpdate.Caption:=LanguageSetup.ViewDataFilesUpdate;
  ListCreateFolder.Caption:=LanguageSetup.ViewDataFilesCreateFolder;
  ListRename.Caption:=LanguageSetup.ViewDataFilesRename;
  ListDelete.Caption:=LanguageSetup.ViewDataFilesDelete;
  ListExplorer.Caption:=LanguageSetup.ViewDataFilesOpen;
  ListUseInScreenshotList.Caption:=LanguageSetup.ScreenshotPopupUseInScreenshotList;

  UserIconLoader.DialogImage(DI_Folder,ImageList,0);
  UserIconLoader.DialogImage(DI_SelectFolder,ImageList,1);
  UserIconLoader.DialogImage(DI_Update,ImageList,2);
  UserIconLoader.DialogImage(DI_ExploreFolder,ImageList,3);
  UserIconLoader.DialogImage(DI_TextFile,ImageList,4);
  UserIconLoader.DialogImage(DI_Image,ImageList,5);
  UserIconLoader.DialogImage(DI_Sound,ImageList,6);
  UserIconLoader.DialogImage(DI_Video,ImageList,7);
  UserIconLoader.DialogImage(DI_InternetPage,ImageList,8);
  UserIconLoader.DialogImage(DI_Edit,ImageList,9);
  UserIconLoader.DialogImage(DI_Delete,ImageList,10);

  ToolBar.Font.Size:=PrgSetup.ToolbarFontSize;
end;

function TViewFilesFrame.GetNewDataFolderName: String;
Var S,T : String;
    I : Integer;
begin
  result:='';
  If Game=nil then exit;

  If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
  T:=IncludeTrailingPathDelimiter(S)+MakeFileSysOKFolderName(Game.Name)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(T) do begin
    inc(I); T:=IncludeTrailingPathDelimiter(S)+MakeFileSysOKFolderName(Game.Name)+IntToStr(I)+'\';
  end;
  result:=MakeRelPath(T,PrgSetup.BaseDir);
end;

procedure TViewFilesFrame.SetGame(const AGame: TGame);
Var B : Boolean;
    N, SelSaveNode : TTreeNode;
    I : Integer;
    SelSaveName : String;
begin
  Timer.Enabled:=False;
  If hChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hChangeNotification);
  hChangeNotification:=INVALID_HANDLE_VALUE;

  Game:=AGame;
  If Game=nil then exit;

  B:=(Trim(Game.DataDir)<>'');

  If B then begin
    If not DirectoryExists(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir)) then begin
      If not ForceDirectories(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir)) then begin
        Game.DataDir:='';
        Game.StoreAllValues;
        B:=False;
      end;
    end;
  end;
  
  {To fix problems with buttons not hidden the right way when setting game while Frame is invisible}
  ToolBar.Visible:=True;
  Tree.Visible:=True;
  Splitter.Visible:=True;
  List.Visible:=True;
  InfoLabel.Visible:=True;
  SetupDataDirButton.Visible:=True;
  ToolBar.Visible:=False;
  Tree.Visible:=False;
  Splitter.Visible:=False;
  List.Visible:=False;
  InfoLabel.Visible:=False;
  SetupDataDirButton.Visible:=False;

  if not B then InfoLabel.Caption:=Format(LanguageSetup.ViewDataFilesSetupInfo,[ExcludeTrailingPathDelimiter(MakeAbsPath(GetNewDataFolderName,PrgSetup.BaseDir))]);
  ToolBar.Visible:=B;
  Tree.Visible:=B;
  Splitter.Visible:=B;
  List.Visible:=B;
  InfoLabel.Visible:=not B;
  SetupDataDirButton.Visible:=not B;

  If Splitter.Visible then Splitter.Left:=Tree.Width+Tree.Left;

  If B then begin
    hChangeNotification:=FindFirstChangeNotification(
      PChar(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir)),
      True,
      FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
    );
    Timer.Enabled:=True;
  end;

  If Tree.Selected<>nil then SelSaveName:=Tree.Selected.Text else SelSaveName:='';

  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    If not B then exit;
    N:=Tree.Items.AddChild(nil,LanguageSetup.ViewDataFilesRoot);
    N.ImageIndex:=0;
    N.SelectedIndex:=1;
    SelSaveNode:=ReadTree(N,IncludeTrailingPathDelimiter(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir)),SelSaveName);
    Tree.FullExpand;

    If (SelSaveNode<>nil) and (SelSaveNode<>N) then begin
      Tree.Selected:=SelSaveNode;
    end else begin
      Tree.Selected:=N;
      For I:=0 to Tree.Items.Count-1 do If FileInDir(GetCurrentPath(Tree.Items[I])) then begin
        Tree.Selected:=Tree.Items[I]; break;
      end;
    end;
    TreeChange(self,Tree.Selected);
  finally
    Tree.Items.EndUpdate;
  end;
end;

Function TViewFilesFrame.ReadTree(const ParentNode: TTreeNode; const Dir, OldSelNode : String) : TTreeNode;
Var Rec : TSearchRec;
    I : Integer;
    N : TTreeNode;
begin
  result:=nil;
  I:=FindFirst(Dir+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        N:=Tree.Items.AddChild(ParentNode,Rec.Name);
        N.ImageIndex:=0;
        N.SelectedIndex:=1;
        If Rec.Name=OldSelNode then result:=N;
        N:=ReadTree(N,IncludeTrailingPathDelimiter(Dir+Rec.Name),OldSelNode);
        If result=nil then result:=N;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TViewFilesFrame.SetupDataDirButtonClick(Sender: TObject);
begin
  Game.DataDir:=MakeRelPath(GetNewDataFolderName,PrgSetup.BaseDir);
  ForceDirectories(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir));
  SetGame(Game);
end;

function TViewFilesFrame.FileInDir(const Dir: String): Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;
  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin result:=True; exit; end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

function TViewFilesFrame.GetCurrentPath(const  TreeNode : TTreeNode): String;
Var N : TTreeNode;
begin
  result:='';
  If TreeNode=nil then begin
    If Tree.Selected=nil then exit;
    N:=Tree.Selected;
  end else begin
    N:=TreeNode;
  end;
  while N.Parent<>nil do begin
    If result<>'' then result:='\'+result;
    result:=N.Text+result;
    N:=N.Parent;
  end;
  result:=IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir))+result);
end;

procedure TViewFilesFrame.TreeChange(Sender: TObject; Node: TTreeNode);
Var Path : String;
    I,SelSaveItem : TListItem;
    J : Integer;
    Rec : TSearchRec;
    S,SelSaveText : String;
begin
  TreeDelete.Visible:=(Node<>nil);
  TreeRename.Visible:=(Node<>nil) and (Node.Parent<>nil);
  TreeExplorer.Visible:=(Node<>nil);
  ListExplorer.Visible:=(Node<>nil);

  If List.Selected<>nil then SelSaveText:=List.Selected.Caption else SelSaveText:='';
  SelSaveItem:=nil;

  List.Items.BeginUpdate;
  try
    List.Items.Clear;
    If Tree.Selected=nil then exit;
    Path:=GetCurrentPath;

    J:=FindFirst(Path+'*.*',faAnyFile,Rec);
    try
      While J=0 do begin
        If (Rec.Attr and faDirectory) =0 then begin
          I:=List.Items.Add;
          I.Caption:=Rec.Name;
          I.ImageIndex:=4;
          S:=ExtUpperCase(ExtractFileExt(Rec.Name));
          If (S='.JPG') or (S='.JPEG') or (S='.BMP') or (S='.PNG') or (S='.GIF') or (S='.TIF') or (S='.TIFF') then I.ImageIndex:=5;
          If (S='.WAV') or (S='.MP3') or (S='.OGG') then I.ImageIndex:=6;
          If (S='.AVI') or (S='.MPG') or (S='.MPEG') or (S='.WMV') or (S='.ASF') then I.ImageIndex:=7;
          If (S='.HTML') or (S='.HTM') then I.ImageIndex:=8;

          If Rec.Name=SelSaveText then SelSaveItem:=I;
        end;
        J:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
  finally
    List.Items.EndUpdate;
  end;

  If SelSaveItem<>nil then begin
    List.Selected:=SelSaveItem
  end else begin
    If List.Items.Count>0 then List.Selected:=List.Items[0];
  end;

  ListChange(Sender,List.Selected,ctState);
end;

procedure TViewFilesFrame.TreePopupMenuPopup(Sender: TObject);
begin
  TreeRename.Visible:=(Tree.Selected<>nil) and (Tree.Selected.Parent<>nil);
  TreeDelete.Visible:=(Tree.Selected<>nil);
  PopupSelNode:=Tree.Selected;
end;

procedure TViewFilesFrame.ListInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
begin
  InfoTip:=GetCurrentPath+Item.Caption;
end;

procedure TViewFilesFrame.ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
Var S,T : String;
begin
  ListRun.Visible:=(List.Selected<>nil);
  ListDelete.Visible:=(List.Selected<>nil);
  ListRename.Visible:=(List.Selected<>nil);
  TreeExplorer.Visible:=(Tree.Selected<>nil);

  OpenFileButton.Enabled:=(List.Selected<>nil);
  If OpenFileButton.Enabled then begin
    OpenFileButton.ImageIndex:=List.Selected.ImageIndex;
    ListRun.ImageIndex:=List.Selected.ImageIndex;
  end else begin
    OpenFileButton.ImageIndex:=4;
    ListRun.ImageIndex:=4;
  end;

  ListOpenInDefaultViewer.Visible:=False;
  If OpenFileButton.Enabled then begin
    S:=ExtUpperCase(ExtractFileExt(List.Selected.Caption)); T:='no';
    If (S='.JPG') or (S='.JPEG') or (S='.BMP') or (S='.PNG') or (S='.GIF') or (S='.TIF') or (S='.TIFF') then T:=PrgSetup.ImageViewer;
    If (S='.WAV') or (S='.MP3') or (S='.OGG') then T:=PrgSetup.SoundPlayer;
    If (S='.AVI') or (S='.MPG') or (S='.MPEG') or (S='.WMV') or (S='.ASF') then T:=PrgSetup.VideoPlayer;
    T:=Trim(ExtUpperCase(T));
    ListOpenInDefaultViewer.Visible:=(T='') or (T='INTERNAL');
  end;

  If OpenFileButton.Enabled then begin
    S:=ExtUpperCase(ExtractFileExt(List.Selected.Caption));
    ListUseInScreenshotList.Visible:=(S='.JPG') or (S='.JPEG') or (S='.BMP') or (S='.PNG') or (S='.GIF');
    If ListUseInScreenshotList.Visible then begin
      S:=GetCurrentPath+List.Selected.Caption;
      ListUseInScreenshotList.Checked:=((Trim(ExtUpperCase(S))=Trim(ExtUpperCase(MakeAbsPath(Game.ScreenshotListScreenshot,PrgSetup.BaseDir)))));
    end;
  end else begin
    ListUseInScreenshotList.Visible:=False;
  end;
end;

procedure TViewFilesFrame.ListDblClick(Sender: TObject);
begin
  ButtonWork(OpenFileButton);
  If List.Selected=nil then exit;
end;

procedure TViewFilesFrame.RunFile(const ForceExternalViewer: Boolean);
Var S,T : String;
begin
  If List.Selected=nil then exit;

  S:=GetCurrentPath;
  T:=ExtUpperCase(ExtractFileExt(List.Selected.Caption));
  If (T='.JPG') or (T='.JPEG') or (T='.BMP') or (T='.PNG') or (T='.GIF') or (T='.TIF') or (T='.TIFF') then begin
    T:=Trim(ExtUpperCase(PrgSetup.ImageViewer));
    If (not ForceExternalViewer) or ((T<>'') and (T<>'INTERNAL')) then begin
      If PrgSetup.NonModalViewer
        then ShowNonModalImageDialog(Owner,S+List.Selected.Caption,nil,nil)
        else ShowImageDialog(Owner,S+List.Selected.Caption,nil,nil);
      exit;
     end;
  end;
  If (T='.WAV') or (T='.MP3') or (T='.OGG') then begin
    T:=Trim(ExtUpperCase(PrgSetup.SoundPlayer));
    If (not ForceExternalViewer) or ((T<>'') and (T<>'INTERNAL')) then begin PlaySoundDialog(Owner,S+List.Selected.Caption,nil,nil); exit; end;
  end;
  If (T='.AVI') or (T='.MPG') or (T='.MPEG') or (T='.WMV') or (T='.ASF') then begin
    T:=Trim(ExtUpperCase(PrgSetup.VideoPlayer));
    If (not ForceExternalViewer) or ((T<>'') and (T<>'INTERNAL')) then begin PlayVideoDialog(Owner,S+List.Selected.Caption,nil,nil); exit; end;
  end;
  If (T='.TXT') or (T='.NFO') or (T='.DIZ') or (T='.1ST') or (T='.INI') then begin
    OpenFileInEditor(S+List.Selected.Caption);
    exit;
  end;

  ShellExecute(Handle,'open',PChar(S+List.Selected.Caption),nil,PChar(S),SW_SHOW);
end;

procedure TViewFilesFrame.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : SetGame(Game);
    1 : begin
          S:=MakeAbsPath(Game.DataDir,PrgSetup.BaseDir);
          ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
        end;
    2 : RunFile(False);
  end;
end;

procedure TViewFilesFrame.MenuWork(Sender: TObject);
Var S,T : String;
    IsRoot : Boolean;
begin
  If PopupSelNode<>nil then Tree.Selected:=PopupSelNode;
  PopupSelNode:=nil;

  Case (Sender as TComponent).Tag of
    11 : ButtonWork(UpdateButton);
    12 : ButtonWork(OpenButton);
    21 : If (Tree.Selected<>nil) and (Tree.Selected.Parent<>nil) then begin
           S:=Tree.Selected.Text;
           If not InputQuery(LanguageSetup.ViewDataFilesRenameCaptionFolder,LanguageSetup.ViewDataFilesRenameLabel,S) then exit;
           If not RenameFile(GetCurrentPath(Tree.Selected.Parent)+Tree.Selected.Text,GetCurrentPath(Tree.Selected.Parent)+S) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[GetCurrentPath(Tree.Selected.Parent)+List.Selected.Caption,GetCurrentPath(Tree.Selected.Parent)+S]),mtError,[mbOK],0);
             exit;
           end;
           Tree.Selected.Text:=S;
           ButtonWork(UpdateButton);
         end;

    22 : If Tree.Selected<>nil then begin
           If MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteFolder,[GetCurrentPath]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
           IsRoot:=(Tree.Selected.Parent=nil);
           If not ExtDeleteFolder(GetCurrentPath,ftDataViewer) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[GetCurrentPath]),mtError,[mbOK],0);
             exit;
           end;
           If IsRoot then begin
             Game.DataDir:='';
             Game.StoreAllValues;
           end else begin
             Tree.Selected:=Tree.Selected.Parent;
           end;
           ButtonWork(UpdateButton);
         end;
    23 : begin
           S:=LanguageSetup.QuickStarterMenuCreateFolderDefaultName;
           If not InputQuery(LanguageSetup.QuickStarterMenuCreateFolderCaption,LanguageSetup.QuickStarterMenuCreateFolderLabel,S) then exit;
           T:=IncludeTrailingPathDelimiter(GetCurrentPath)+S;
           If DirectoryExists(T) then begin
             MessageDlg(Format(LanguageSetup.MessageDirectoryAlreadyExists,[T]),mtError,[mbOK],0);
             exit;
           end;
           If not ForceDirectories(T) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[T]),mtError,[mbOK],0);
             exit;
           end;
           ButtonWork(UpdateButton);
         end;
    31 : ButtonWork(OpenFileButton);
    32 : If List.Selected<>nil then begin
           S:=List.Selected.Caption;
           If not InputQuery(LanguageSetup.ViewDataFilesRenameCaptionFile,LanguageSetup.ViewDataFilesRenameLabel,S) then exit;
           If not RenameFile(GetCurrentPath+List.Selected.Caption,GetCurrentPath+S) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[GetCurrentPath+List.Selected.Caption,GetCurrentPath+S]),mtError,[mbOK],0);
             exit;
           end;
           List.Selected.Caption:=S;
           ButtonWork(UpdateButton);
         end;
    33 : If List.Selected<>nil then begin
           If MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteFile,[GetCurrentPath+List.Selected.Caption]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
           If not ExtDeleteFile(GetCurrentPath+List.Selected.Caption,ftDataViewer) then begin
             MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[GetCurrentPath+List.Selected.Caption]),mtError,[mbOK],0);
             exit;
           end;
           ButtonWork(UpdateButton);
         end;
    34 : RunFile(True);
    35 : If List.Selected<>nil then begin
          S:=GetCurrentPath+List.Selected.Caption;
          If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(MakeAbsPath(Game.ScreenshotListScreenshot,PrgSetup.BaseDir)))
            then Game.ScreenshotListScreenshot:=''
            else Game.ScreenshotListScreenshot:=MakeRelPath(S,PrgSetup.BaseDir);
          If Assigned(FOnUpdateGamesList) then FOnUpdateGamesList(self);
        end;
  end;
end;

procedure TViewFilesFrame.TimerWork(Sender: TObject);
begin
  If (hChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hChangeNotification,0)=WAIT_OBJECT_0) then begin
    ButtonWork(UpdateButton);
    FindNextChangeNotification(hChangeNotification);
  end;
end;

procedure TViewFilesFrame.TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
Var I : Integer;
    FileName,S,CurrentPath : String;
    FileList : TStringList;
    N : TTreeNode;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  N:=Tree.GetNodeAt(X,Y);
  If N<>nil then begin
    Tree.Selected:=N;
    TreeChange(Sender,N);
  end;
  CurrentPath:=GetCurrentPath;
  
  try
    For I:=0 to FileList.Count-1 do begin
      FileName:=FileList[I];
      if DirectoryExists(FileName) then begin
        S:=CurrentPath+ExtractFileName(FileName);
        If not ForceDirectories(S) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
          exit;
        end;
        If not CopyFiles(FileName,S,True,True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFiles,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end else begin
        S:=CurrentPath+ExtractFileName(FileName);
        if not CopyFile(PChar(FileName),PChar(S),True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end;
    end;
  finally
    ButtonWork(UpdateButton);
  end;
end;

procedure TViewFilesFrame.ListDragDrop(Sender, Source: TObject; X, Y: Integer);
Var I : Integer;
    FileName,S,CurrentPath : String;
    FileList : TStringList;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  CurrentPath:=GetCurrentPath;
  try
    For I:=0 to FileList.Count-1 do begin
      FileName:=FileList[I];
      if DirectoryExists(FileName) then begin
        S:=CurrentPath+ExtractFileName(FileName);
        If not ForceDirectories(S) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
          exit;
        end;
        If not CopyFiles(FileName,S,True,True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFiles,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end else begin
        S:=CurrentPath+ExtractFileName(FileName);
        if not CopyFile(PChar(FileName),PChar(S),True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]),mtError,[mbOK],0);
          exit;
        end;
      end;
    end;
  finally
    ButtonWork(UpdateButton);
  end;
end;

end.
