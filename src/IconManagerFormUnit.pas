unit IconManagerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, Menus;

type
  TIconManagerForm = class(TForm)
    ListView: TListView;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    AddButton: TBitBtn;
    DelButton: TBitBtn;
    ImageList: TImageList;
    OpenDialog: TOpenDialog;
    LibraryIconRadioButton: TRadioButton;
    CustomIconRadioButton: TRadioButton;
    CustomIconEdit: TEdit;
    CustomIconButton: TSpeedButton;
    HelpButton: TBitBtn;
    Timer: TTimer;
    AddPopupMenu: TPopupMenu;
    PopupAddIcon: TMenuItem;
    PopupAddAllIcons: TMenuItem;
    ToolsButton: TBitBtn;
    ToolsPopupMenu: TPopupMenu;
    PopupToolsExplorer: TMenuItem;
    N1: TMenuItem;
    PopupToolsRenameUpper: TMenuItem;
    PopupToolsRenameLower: TMenuItem;
    PopupAddIconsFromFolder: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CustomIconEditChange(Sender: TObject);
    procedure CustomIconButtonClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ToolsButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Dir, LastIcon : String;
    hIconsChangeNotification : THandle;
    Procedure LoadIcons;
    Procedure PostResize(var Msg : TMessage); Message WM_USER+1;
    Procedure ScanFolderForIcons(const Folder : String);
    Procedure AddIconFromFolder(const IconFile : String);
    Procedure RenameIcons(const UpperExt : Boolean);
  public
    { Public-Deklarationen }
    IconName : String;
    DefaultCustomIconFolder : String;
  end;

var
  IconManagerForm: TIconManagerForm;

Function ShowIconManager(const AOwner : TComponent; var AIcon : String; const ADefaultCustomIconFolder : String; const NoCancel : Boolean = False) : Boolean;

implementation

uses ShellAPI, LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgConsts,
     PrgSetupUnit, HelpConsts, IconLoaderUnit, ClassExtensions;

{$R *.dfm}

const IconFileExts : Array[0..5] of String = ('ico','png','jpeg','jpg','gif','bmp');

procedure TIconManagerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.MenuExtrasIconManagerCaption;
  LibraryIconRadioButton.Caption:=LanguageSetup.MenuExtrasIconManagerIconLibrary;
  CustomIconRadioButton.Caption:=LanguageSetup.MenuExtrasIconManagerIconCustom;
  CustomIconButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  AddButton.Caption:=LanguageSetup.Add;
  PopupAddIcon.Caption:=LanguageSetup.MenuExtrasIconManagerAddSingle;
  PopupAddIconsFromFolder.Caption:=LanguageSetup.MenuExtrasIconManagerAddIconsFromFolder;
  PopupAddAllIcons.Caption:=LanguageSetup.MenuExtrasIconManagerAddAll;
  DelButton.Caption:=LanguageSetup.Del;
  HelpButton.Caption:=LanguageSetup.Help;
  ToolsButton.Caption:=LanguageSetup.MenuExtrasIconManagerTools;
  PopupToolsExplorer.Caption:=LanguageSetup.MenuExtrasIconManagerToolsExplorer;
  PopupToolsRenameUpper.Caption:=LanguageSetup.MenuExtrasIconManagerToolsRenameUpper;
  PopupToolsRenameLower.Caption:=LanguageSetup.MenuExtrasIconManagerToolsRenameLower;

  OpenDialog.Title:=LanguageSetup.MenuExtrasIconManagerDialog;
  OpenDialog.Filter:=LanguageSetup.MenuExtrasIconManagerFilter;

  Dir:=IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir);

  UserIconLoader.DialogImage(DI_SelectFile,CustomIconButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Tools,ToolsButton);

  hIconsChangeNotification:=FindFirstChangeNotification(
    PChar(PrgDataDir+IconsSubDir),
    True,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
  );
end;

procedure TIconManagerForm.FormShow(Sender: TObject);
begin
  LastIcon:=IconName;
  LoadIcons;

  ListView:=TListView(NewWinControlType(ListView,TListViewAcceptingFilesAndSpecialHint,ctcmDangerousMagic));
  TListViewAcceptingFilesAndSpecialHint(ListView).ActivateAcceptFiles;

  Timer.Enabled:=True;
end;

procedure TIconManagerForm.FormDestroy(Sender: TObject);
begin
  If hIconsChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hIconsChangeNotification);
end;

procedure TIconManagerForm.TimerTimer(Sender: TObject);
begin
  If (hIconsChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hIconsChangeNotification,0)=WAIT_OBJECT_0) then begin
    If ListView.Selected<>nil then LastIcon:=ListView.Selected.Caption else LastIcon:='';
    LoadIcons;
    FindNextChangeNotification(hIconsChangeNotification);
  end;
end;

Function GetIconsListForSingleDir(const Folder : String) : TStringList;
Var S : String;
    I,J : Integer;
    Rec : TSearchRec;
begin
  S:=IncludeTrailingPathDelimiter(Folder);
  result:=TStringList.Create;

  For J:=Low(IconFileExts) to High(IconFileExts) do begin
    I:=FindFirst(S+'*.'+IconFileExts[J],faAnyFile,Rec);
    try
      while I=0 do begin
        result.Add(S+Rec.Name);
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
  end;
end;

Function GetIconsList(const Folder : String) : TStringList;
Var S : String;
    I : Integer;
    Rec : TSearchRec;
    St : TStringList;
begin
  S:=IncludeTrailingPathDelimiter(Folder);
  result:=GetIconsListForSingleDir(Folder);

  I:=FindFirst(S+'*.*',faDirectory,Rec);
  try
    while I=0 do begin
      If (Rec.Name<>'.') and (Rec.Name<>'..') and ((Rec.Attr and faDirectory)<>0) then begin
        St:=GetIconsList(S+Rec.Name);
        try result.AddStrings(St); finally St.Free; end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TIconManagerForm.LoadIcons;
Var I : Integer;
    L : TListItem;
    Icon, Icon2 : TIcon;
    B : Boolean;
    S : String;
    St : TStringList;
begin
  ForceDirectories(Dir);

  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    ImageList.Clear;
    ListView.SortType:=stNone;

    St:=GetIconsList(Dir);
    try
      For I:=0 To St.Count-1 do begin
        B:=True;
        try
          If ExtUpperCase(ExtractFileExt(St[I]))='.ICO' then begin
            Icon:=TIcon.Create;
            Icon.LoadFromFile(St[I]);
          end else begin
            Icon:=LoadImageAsIconFromFile(St[I]);
          end;
        except
          B:=False;
        end;
        try
          If B and (Icon<>nil) then begin
            try
              ImageList.AddIcon(Icon);
            except
              Icon2:=LoadIconFromExeFile(St[I]);
              try
                If Icon2<>nil then ImageList.AddIcon(Icon2);
              finally
                Icon2.Free;
              end;
            end;
            ListView.AddItem(ExtractFileName(St[I]),nil);
            L:=ListView.Items[ListView.Items.Count-1];
            L.ImageIndex:=ImageList.Count-1;
          end;
        finally
          If (Icon<>nil) then FreeAndNil(Icon);
        end;
      end;
    finally
      St.Free;
    end;

    If ExtractFilePath(Trim(LastIcon))='' then begin
      S:=ExtUpperCase(LastIcon);
      LibraryIconRadioButton.Checked:=True;
      For I:=0 to ListView.Items.Count-1 do If ExtUpperCase(ListView.Items[I].Caption)=S then begin
        ListView.ItemIndex:=I; break;
      end;
    end else begin
      CustomIconRadioButton.Checked:=True;
      CustomIconEdit.Text:=LastIcon;
    end;


    ListView.SortType:=stText;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TIconManagerForm.OKButtonClick(Sender: TObject);
begin
  If LibraryIconRadioButton.Checked then begin
    If ListView.ItemIndex>=0 then begin
      IconName:=ListView.Items[ListView.ItemIndex].Caption;
    end else begin
      IconName:='';
    end;
  end else begin
    IconName:=CustomIconEdit.Text;
  end;
end;

procedure TIconManagerForm.FormResize(Sender: TObject);
begin
  PostMessage(Handle,WM_User+2,0,0);
end;

procedure TIconManagerForm.PostResize(var Msg: TMessage);
begin
  If Assigned(ListView) then ListView.Arrange(arAlignLeft);
end;

procedure TIconManagerForm.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  DelButton.Enabled:=(ListView.ItemIndex>=0);
end;

procedure TIconManagerForm.ListViewDblClick(Sender: TObject);
begin
  LibraryIconRadioButton.Checked:=True;
  OKButton.Click;
end;

procedure TIconManagerForm.ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
Var FileList : TStringList;
    I : Integer;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  FileList:=(Source as TStringList);

  For I:=0 to FileList.Count-1 do begin
    CopyFile(PChar(FileList[I]),PChar(PrgDataDir+IconsSubDir+'\'+ExtractFileName(FileList[I])),False);
  end;
end;

procedure TIconManagerForm.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : AddButtonClick(Sender);
    VK_RETURN : ListViewDblClick(Sender);
    VK_DELETE : DelButtonClick(Sender);
  end;
end;

procedure TIconManagerForm.AddButtonClick(Sender: TObject);
Var P : TPoint;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          P:=ClientToScreen(Point(AddButton.Left,AddButton.Top));
          AddPopupMenu.Popup(P.X+5,P.Y+5);
        end;
    1 : begin
          S:=ExtractFilePath(MakeAbsIconName(Trim(CustomIconEdit.Text)));
          If S='' then S:=DefaultCustomIconFolder;
          If S='' then S:=PrgSetup.BaseDir;
          If S<>'' then OpenDialog.InitialDir:=S;
          if not OpenDialog.Execute then exit;
          if not CopyFile(PChar(OpenDialog.FileName),PChar(Dir+ExtractFileName(OpenDialog.FileName)),True) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,Dir+ExtractFileName(OpenDialog.FileName)]),mtError,[mbOK],0);
            exit;
          end;
          LastIcon:=ExtractFileName(OpenDialog.FileName);
          LoadIcons;
        end;
    2 : begin
          Enabled:=False;
          try
            ScanFolderForIcons(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
          finally
            Enabled:=True;
          end;
          LoadIcons;
        end;
    3 : begin
          Enabled:=False;
          try
            S:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
            if not SelectDirectory(Handle,LanguageSetup.MenuExtrasIconManagerAddIconsFromFolderCaption,S) then exit;
            ScanFolderForIcons(S);
          finally
            Enabled:=True;
          end;
          LoadIcons;
        end;
  end;
end;

procedure TIconManagerForm.ScanFolderForIcons(const Folder : String);
Var Rec : TSearchRec;
    I : Integer;
begin
  Application.ProcessMessages;

  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.ico',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then AddIconFromFolder(IncludeTrailingPathDelimiter(Folder)+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') then
        ScanFolderForIcons(IncludeTrailingPathDelimiter(Folder)+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TIconManagerForm.ListViewClick(Sender: TObject);
begin
  LibraryIconRadioButton.Checked:=True;
end;

procedure TIconManagerForm.CustomIconEditChange(Sender: TObject);
begin
  CustomIconRadioButton.Checked:=True;
end;

procedure TIconManagerForm.AddIconFromFolder(const IconFile: String);
Var DestFile : String;
    I : Integer;
begin
  Application.ProcessMessages;

  DestFile:=PrgDataDir+IconsSubDir+'\'+ExtractFileName(IconFile);

  If not FileExists(DestFile) then begin
    CopyFile(PChar(IconFile),PChar(DestFile),True);
    exit;
  end;

  If CompareFiles(IconFile,DestFile) then exit;

  I:=1;
  While FileExists(ChangeFileExt(DestFile,IntToStr(I)+'.ico')) do begin
    If CompareFiles(IconFile,ChangeFileExt(DestFile,IntToStr(I)+'.ico')) then exit;
    inc(I);
  end;

  CopyFile(PChar(IconFile),PChar(ChangeFileExt(DestFile,IntToStr(I)+'.ico')),True);
end;

procedure TIconManagerForm.CustomIconButtonClick(Sender: TObject);
Var S : String;
begin
  S:=ExtractFilePath(MakeAbsIconName(Trim(CustomIconEdit.Text)));
  If S='' then S:=DefaultCustomIconFolder;
  If S='' then S:=PrgSetup.BaseDir;
  If S<>'' then OpenDialog.InitialDir:=S;
  if not OpenDialog.Execute then exit;
  CustomIconEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
  CustomIconRadioButton.Checked:=True;
end;

procedure TIconManagerForm.DelButtonClick(Sender: TObject);
Var S : String;
begin
  If ListView.ItemIndex<0 then exit;

  S:=Dir+ListView.Items[ListView.ItemIndex].Caption;
  If not ExtDeleteFile(S,ftProfile) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[S]),mtError,[mbOK],0);
    exit;
  end;

  ListView.Items.Delete(ListView.ItemIndex);
end;

procedure TIconManagerForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasManageIcons);
end;

procedure TIconManagerForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TIconManagerForm.ToolsButtonClick(Sender: TObject);
Var P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          P:=ClientToScreen(Point(ToolsButton.Left,ToolsButton.Top));
          ToolsPopupMenu.Popup(P.X+5,P.Y+5);
        end;
    1 : begin
          ShellExecute(Handle,'explore',PChar(Dir),nil,PChar(Dir),SW_SHOW);
        end;
    2 : RenameIcons(True);
    3 : RenameIcons(False);
  end;
end;

procedure TIconManagerForm.RenameIcons(const UpperExt: Boolean);
Var Rec : TSearchRec;
    I,J : Integer;
    NewName : String;
begin
  For J:=Low(IconFileExts) to High(IconFileExts) do begin
    I:=FindFirst(Dir+'*.'+IconFileExts[J],faAnyFile,Rec);
    try
      While I=0 do begin
        NewName:=ExtractFileExt(Rec.Name);
        If UpperExt then NewName:=ExtUpperCase(NewName) else NewName:=ExtLowerCase(NewName);
        NewName:=ChangeFileExt(Rec.Name,NewName);
        RenameFile(Dir+Rec.Name,Dir+NewName);
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
  end;
end;

{ global }

Function ShowIconManager(const AOwner : TComponent; var AIcon : String; const ADefaultCustomIconFolder : String; const NoCancel : Boolean) : Boolean;
begin
  IconManagerForm:=TIconManagerForm.Create(AOwner);
  try
    IconManagerForm.IconName:=AIcon;
    IconManagerForm.DefaultCustomIconFolder:=ADefaultCustomIconFolder;
    If NoCancel then begin
      IconManagerForm.CancelButton.Visible:=False;
      IconManagerForm.LibraryIconRadioButton.Visible:=False;
      IconManagerForm.CustomIconRadioButton.Visible:=False;
      IconManagerForm.CustomIconEdit.Visible:=False;
      IconManagerForm.CustomIconButton.Visible:=False;
      IconManagerForm.ListView.Height:=IconManagerForm.OKButton.Top-10;
    end;
    result:=(IconManagerForm.ShowModal=mrOK);
    if result then AIcon:=IconManagerForm.IconName;
  finally
    IconManagerForm.Free;
  end;
end;

end.
