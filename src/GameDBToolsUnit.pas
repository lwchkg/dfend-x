unit GameDBToolsUnit;
interface

uses Windows, Classes, ComCtrls, Controls, Graphics, Menus, CheckLst,
     GameDBUnit, LinkFileUnit;

var GameDBToolsUnitShowDialogs : Boolean = False;

{DEFINE SpeedTest}

{ Load Data to GUI }

Type TSortListBy=(slbName=1, slbSetup=2, slbGenre=3, slbDeveloper=4, slbPublisher=5, slbYear=6, slbLanguage=7, slbComment=8, slbStartCount=9);

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);

Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean; const O,V : String; const VUserSt : TStringList; const T : String; const ScreenshotViewMode, ScummVMTemplate : Boolean; const UseBackgroundColor : Boolean; const BackgroundColor : TColor); overload;
Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo, ScreenshotViewMode, ScummVMTemplate : Boolean; const UseBackgroundColor : Boolean; const BackgroundColor : TColor); overload;
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile, ScreenshotViewMode : Boolean); overload;
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Game : TGame; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile, ScreenshotViewMode : Boolean); overload;
Procedure GamesListSaveColWidths(const AListView : TListView);
Procedure GamesListLoadColWidths(const AListView : TListView);
Function GamesListSaveColWidthsToString(const AListView : TListView) : String;
Procedure GamesListLoadColWidthsFromString(const AListView : TListView; const Data : String);

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
Procedure AddSoundsToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Procedure AddVideosToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);

Procedure GetColOrderAndVisible(var O,V,VUser : String);
Function GetUserCols : String;
Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);

Procedure InitMountingListView(const MountingListView : TListView);
Procedure LoadMountingListView(const MountingListView : TListView; const Mounting : TStringList);

{ Selection lists }

Procedure BuildCheckList(const CheckListBox : TCheckListBox; const GameDB : TGameDB; const WithDefaultProfile, HideScummVMAndWindowsProfiles : Boolean; const HideWindowsProfiles : Boolean = False);
Procedure BuildSelectPopupMenu(const Popup : TPopupMenu; const GameDB : TGameDB; const OnClick : TNotifyEvent; const WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean = False);
Procedure SelectGamesByPopupMenu(const Sender : TObject; const CheckListBox : TCheckListBox); overload;
Procedure SelectGamesByPopupMenu(const Sender : TObject; const ListView : TListView); overload;

Function GetUserDataList(const GameDB : TGameDB) : TStringList;

{ Upgrade from D-Fend / First-run init / Repair }

Procedure DeleteOldFiles;
Procedure ReplaceAbsoluteDirs(const GameDB : TGameDB);
Procedure BuildDefaultDosProfileAutoexec(const GameDB : TGameDB);
Function BuildDefaultDosProfile(const GameDB : TGameDB; const CopyFiles : Boolean = True) : TGame;
Procedure BuildDefaultProfile;
Procedure ReBuildTemplates(const InBackground : Boolean);
Function CopyFiles(Source, Dest : String; const OverwriteExistingFiles, ProcessMessages : Boolean) : Boolean;
Procedure UpdateUserDataFolderAndSettingsAfterUpgrade(const GameDB : TGameDB; const LastVersion : Integer);
Procedure UpdateSettingsFilesLocation;

Var FreeDOSInitThreadRunning : Boolean = False;
    TemplatesInitThreadRunning : Boolean = False;

{ Extras }

Type TGamesListExportColumn=(glecEmulationType=1, glecGenre=2, glecDeveloper=3, glecPublisher=4, glecYear=5, glecLanguage=6, glecWWW=7, glecLicense=8, glecStartCount=9, glecUserFields=10, glecNotes=11);
Type TGamesListExportColumns=set of TGamesListExportColumn;
Type TGamesListExportFormat=(glefAuto=0, glefText=1, glefTable=2, glefHTML=3, glefXML=4);

Function GetGamesListExportLanguageColumns : TStringList;
Procedure ExportGamesList(const GameDB : TGameDB; const FileName : String; const Columns : TGamesListExportColumns; const Format : TGamesListExportFormat);
Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList);
Procedure CreateConfFilesForProfiles(const GameDB : TGameDB; const Dir : String);

Function EncodeUserHTMLSymbolsOnly(const S : String) : String;
Function EncodeHTMLSymbols(const S : String) : String;
Function DecodeHTMLSymbols(const S : String) : String;

{ Import }

Procedure ImportConfData(const AGameDB : TGameDB; const AGame : TGame; const Lines : String); overload;
Procedure ImportConfData(const AGameDB : TGameDB; const AGame : TGame; const St : TStringList); overload;
Procedure ImportConfFileData(const AGameDB : TGameDB; const AGame : TGame; const AFileName : String);
Function ImportConfFile(const AGameDB : TGameDB; const AFileName : String) : TGame;

{ Checksums }

Procedure CreateGameCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Procedure CreateSetupCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Function ChecksumForGameOK(const AGame : TGame) : Boolean;
Function ChecksumForSetupOK(const AGame : TGame) : Boolean;
Procedure ProfileEditorOpenCheck(const AGame : TGame);
Procedure ProfileEditorCloseCheck(const AGame : TGame; const NewGameExe, NewSetupExe : String);
Function RunCheck(const AGame : TGame; const RunSetup : Boolean; const RunExtraFile : Integer = -1) : Boolean;
Procedure CreateCheckSumsForAllGames(const AGameDB : TGameDB);
Type TFolderType=(ftCapture,ftGameData);
Procedure CreateFoldersForAllGames(const AGameDB : TGameDB; const FolderType : TFolderType);

Type T5StringArray=Array[0..4] of String;
Function GetAdditionalChecksumData(const AGame : TGame; Path : String; DataNeeded : Integer; var Files, Checksums : T5StringArray) : Integer;
Procedure AddAdditionalChecksumDataToAutoSetupTemplate(const AGame : TGame);

{ Last modification date }

Function GetLastModificationDate(const AGame : TGame) : String;

{ ScummVM and Windows files}

Function DOSBoxMode(const Game : TGame) : Boolean;
Function ScummVMMode(const Game : TGame) : Boolean;
Function WindowsExeMode(const Game : TGame) : Boolean;

{ CheckDB }

Function CheckGameDB(const GameDB : TGameDB) : TStringList;
Function CheckDoubleChecksums(const AutoSetupDB : TGameDB) : TStringList;

{ DOSBox versions }

Function GetDOSBoxNr(const Game : TGame) : Integer;

{ Viewing configuration files }

Procedure OpenConfigurationFile(const Game : TGame; const DeleteOnExit : TStringList);

{ Program file selection }

Function SelectProgramFile(var FileName : String; const HintFirstFile, HintSecondFile : String; const WindowsMode : Boolean; const OtherEmulator : Integer; const Owner : TComponent) : Boolean;

{ Change mounting settings in templates }

Function BuildGameDirMountData(const Template : TGame; const ProgrammFileDir, SetupFileDir : String) : TStringList; overload;
Procedure BuildGameDirMountData(const Mounting : TStringList; const ProgrammFileDir, SetupFileDir : String); overload;

{Check if auto setup template is available}

Procedure CheckAutoSetupTemplates(const AutoSetupDB : TGameDB; const NewAutoSetupTemplatesFolder : String);

{Get Pixel shader list}

Function GetPixelShaders(const DOSBoxDir : String) : TStringList;

implementation

uses SysUtils, Forms, Dialogs, ShellAPI, ShlObj, IniFiles, Math,  PNGImage,
     JPEG, GIFImage, CommonTools, LanguageSetupUnit, PrgConsts, PrgSetupUnit,
     ProfileEditorFormUnit, ModernProfileEditorFormUnit, HashCalc,
     SmallWaitFormUnit, ChecksumFormUnit, WaitFormUnit, ImageCacheUnit,
     DosBoxUnit, ScummVMUnit, ImageStretch, MainUnit, GameDBFilterUnit,
     HistoryUnit, IconLoaderUnit, ScreenshotsCacheUnit, LoggingUnit;

Function GroupMatch(const GameGroupUpper, SelectedGroupUpper : String) : Boolean; forward;

Procedure AddTypeSelector(const ATreeView : TTreeView; const Name : String; const St : TStringList);
Var N,N2 : TTreeNode;
    I : Integer;
    S : String;
begin
  try
    N:=ATreeView.Items.AddChild(nil,Name);
    N.ImageIndex:=12;
    N.SelectedIndex:=12;
    if (St<>nil) then For I:=0 to St.Count-1 do begin
      S:=St[I];
      If S='' then S:=LanguageSetup.NotSet;
      N2:=ATreeView.Items.AddChild(N,S);
      N2.ImageIndex:=10;
      N2.SelectedIndex:=10;
    end
  finally
    St.Free;
  end;
end;

Function RemoveDoubleEntrys(const St : TStringList) : TStringList; {return value = St}
Var I : Integer;
    Upper : TStringList;
    S : String;
begin
  result:=St;

  Upper:=TStringList.Create;
  try
    I:=0;
    While I<St.Count do begin
      If Trim(St[I])='' then begin St.Delete(I); continue; end;
      S:=ExtUpperCase(St[I]);
      If Upper.IndexOf(S)>=0 then begin St.Delete(I); continue; end;
      Upper.Add(S); inc(I);
    end;
  finally
    Upper.Free;
  end;
end;

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Var N,N2 : TTreeNode;
    Group, SubGroup, TreeFilter : String;
    I : Integer;
    OnChange : TTVChangedEvent;
    UserGroups : TStringList;
begin
  OnChange:=ATreeView.OnChange;
  ATreeView.OnChange:=nil;
  try
    ATreeView.ReadOnly:=True;

    If ATreeView.Selected=nil then begin Group:=''; SubGroup:=''; end else begin
      If ATreeView.Selected.Parent=nil then begin
        Group:=ATreeView.Selected.Text; SubGroup:='';
      end else begin
        Group:=ATreeView.Selected.Parent.Text;
        SubGroup:=ATreeView.Selected.Text;
      end;
    end;

    ATreeView.Items.BeginUpdate;
    try
      ATreeView.Items.Clear;

      {All games}
      N:=ATreeView.Items.AddChild(nil,RemoveUnderline(LanguageSetup.All));
      N.ImageIndex:=8;
      N.SelectedIndex:=8;

      {Favorites}
      N:=ATreeView.Items.AddChild(nil,LanguageSetup.GameFavorites);
      N.ImageIndex:=9;
      N.SelectedIndex:=9;

      {Genre, Developer, Publisher, Year, Language, License}
      TreeFilter:=PrgSetup.DefaultTreeFilter;
      while (length(TreeFilter)<8) do TreeFilter:=TreeFilter+'1';

      if TreeFilter[1]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GameGenre,GetCustomGenreName(GameDB.GetGenreList));
      if TreeFilter[2]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GameDeveloper,GameDB.GetDeveloperList);
      if TreeFilter[3]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GamePublisher,GameDB.GetPublisherList);
      if TreeFilter[4]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GameYear,GameDB.GetYearList);
      if TreeFilter[5]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GameLanguage,GetCustomLanguageName(GameDB.GetLanguageList));
      if TreeFilter[6]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GameLicense,GetCustomLicenseName(GameDB.GetLicenseList));

      {Emulation type}
      if TreeFilter[7]<>'0' then begin
        N:=ATreeView.Items.AddChild(nil,LanguageSetup.GameEmulationType);
        N.ImageIndex:=12; N.SelectedIndex:=12;
        N2:=ATreeView.Items.AddChild(N,LanguageSetup.GameEmulationTypeDOSBox); N2.ImageIndex:=16; N2.SelectedIndex:=16;
        N2:=ATreeView.Items.AddChild(N,LanguageSetup.GameEmulationTypeScummVM); N2.ImageIndex:=37; N2.SelectedIndex:=37;
        N2:=ATreeView.Items.AddChild(N,LanguageSetup.GameEmulationTypeWindows); N2.ImageIndex:=40; N2.SelectedIndex:=40;
        For I:=0 to PrgSetup.WindowsBasedEmulatorsNames.Count-1 do begin
          N2:=ATreeView.Items.AddChild(N,PrgSetup.WindowsBasedEmulatorsNames[I]); N2.ImageIndex:=MI_Count+I; N2.SelectedIndex:=MI_Count+I;
        end;
      end;

      {Recently played}
      if TreeFilter[8]<>'0' then AddTypeSelector(ATreeView,LanguageSetup.GameRecentlyPlayed,nil);

      {User categories}
      UserGroups:=RemoveDoubleEntrys(StringToStringList(PrgSetup.UserGroups));
      try
        For I:=0 to UserGroups.Count-1 do
          AddTypeSelector(ATreeView,UserGroups[I],GameDB.GetKeyValueList(UserGroups[I]));
      finally
        UserGroups.Free;
      end;

      {Select a group}
      If Group='' then exit;

      For I:=0 to ATreeview.Items.Count-1 do begin
        If SubGroup='' then begin
          If (ATreeView.Items[I].Parent=nil) and (ATreeView.Items[I].Text=Group) then begin ATreeView.Selected:=ATreeView.Items[I]; exit; end;
        end else begin
          If (ATreeView.Items[I].Parent<>nil) and (ATreeView.Items[I].Text=SubGroup) and (ATreeView.Items[I].Parent.Text=Group) then begin ATreeView.Selected:=ATreeView.Items[I]; exit; end;
        end;
      end;

    finally
      ATreeView.Items.EndUpdate;
    end;
  finally
    ATreeView.OnChange:=OnChange;
  end;
end;

Procedure GetColOrderAndVisible(var O,V,VUser : String);
Var I,UserCount : Integer;
    S : String;
begin
  V:=PrgSetup.ColVisible;

  I:=Pos(';',V);
  If I>0 then begin VUser:=Trim(Copy(V,I+1,MaxInt)); V:=Trim(Copy(V,1,I-1)); end else VUser:='';
  while length(V)<8 do V:=V+'1';
  If Length(V)>8 then V:=Copy(V,1,8);
  If VUser<>'' then PrgSetup.ColVisible:=V+';'+VUser else PrgSetup.ColVisible:=V;

  O:=PrgSetup.ColOrder;
  UserCount:=0; S:=VUser;
  While S<>'' do begin
    inc(UserCount);
    I:=Pos(';',S); If I=0 then break;
    S:=Trim(Copy(S,I+1,MaxInt));
  end;
  while length(O)<8+UserCount do If length(O)<9
    then O:=O+chr(length(O)+Ord('1'))
    else O:=O+chr(length(O)-9+Ord('A'));
  If Length(O)>8+UserCount then O:=Copy(O,1,8+UserCount);
  PrgSetup.ColOrder:=O;
end;

Function GetUserCols : String;
Var O,V : String;
begin
  GetColOrderAndVisible(O,V,result);
end;

Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);
Procedure SetListSort(const L : TSortListBy);
begin
  If ListSort=L then ListSortReverse:=not ListSortReverse else begin ListSort:=L; ListSortReverse:=False; end;
end;
Var O,V,VUser : String;
    I,Nr,C : Integer;
    VUserSt : TStringList;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If ColumnIndex=0 then SetListSort(slbName) else begin
      If not PrgSetup.ShowExtraInfo then SetListSort(slbSetup) else begin
        C:=0;
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=8 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-8>VUserSt.Count then continue;
          end;
          inc(C);
          If C=ColumnIndex then begin
            Case Nr-1 of
              0 : SetListSort(slbSetup);
              1 : SetListSort(slbGenre);
              2 : SetListSort(slbDeveloper);
              3 : SetListSort(slbPublisher);
              4 : SetListSort(slbYear);
              5 : SetListSort(slbLanguage);
              6 : SetListSort(slbComment);
              7 : SetListSort(slbStartCount);
              else SetListSort(TSortListBy((Nr-9+10)));
            end;
            break;
          end;
        end;
      end;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure InitMountingListView(const MountingListView : TListView);
Var L : TListColumn;
begin
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingFolderImage;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingAs;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLetter;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLabel;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingIOControl;
end;

Procedure LoadMountingListView(const MountingListView : TListView; const Mounting : TStringList);
Var I : Integer;
    St : TStringList;
    L : TListItem;
    S,T,U : String;
    B : Boolean;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        If St.Count>0 then begin
          L:=MountingListView.Items.Add;

          S:=Trim(St[0]);
          If St.Count>1 then begin
            T:=Trim(ExtUpperCase(St[1]));
            If Pos('$',S)<>0 then begin
              If (T='PHYSFS') or (T='ZIP')
                then S:=Copy(S,Pos('$',S)+1,MaxInt)+' (+ '+Copy(S,1,Pos('$',S)-1)+')'
                else S:=Copy(S,1,Pos('$',S)-1)+' (+'+LanguageSetup.More+')';
            end;
            If (T='CDROM') and (S='ASK') then S:=LanguageSetup.ProfileMountingCDDriveTypeAskShort;
            If (T='CDROM') and (Pos(':',S)<>0) then begin
              U:=Trim(Copy(S,1,Pos(':',S)-1));
              If U='NUMBER' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeNumberShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
              If U='LABEL' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeLabelShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
              If U='FILE' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeFileShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
              If U='FOLDER' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeFolderShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
            end;
          end;
          L.Caption:=S;

          If St.Count>1 then begin
            S:=Trim(ExtUpperCase(St[1])); B:=False;
            If (not B) and (S='DRIVE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeDRIVE); B:=True; end;
            If (not B) and (S='CDROM') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeCDROM); B:=True; end;
            If (not B) and (S='CDROMIMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeCDROMIMAGE); B:=True; end;
            If (not B) and (S='FLOPPY') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeFLOPPY); B:=True; end;
            If (not B) and (S='FLOPPYIMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeFLOPPYIMAGE); B:=True; end;
            If (not B) and (S='IMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeIMAGE); B:=True; end;
            If (not B) and (S='PHYSFS') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypePHYSFS); B:=True; end;
            If (not B) and (S='ZIP') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeZIP); B:=True; end;
            If not B then L.SubItems.Add(St[1]);
          end else begin
            L.SubItems.Add('');
          end;

          If St.Count>2 then L.SubItems.Add(St[2]) else L.SubItems.Add('');
          If St.Count>4 then L.SubItems.Add(St[4]) else L.SubItems.Add('');
          If St.Count>3 then begin
            If Trim(ExtUpperCase(St[3]))='TRUE' then L.SubItems.Add(RemoveUnderline(LanguageSetup.Yes)) else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
          end else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
        end;
      finally
        St.Free;
      end;
    end;
    If MountingListView.Items.Count>0 then MountingListView.ItemIndex:=0;
  finally
    MountingListView.Items.EndUpdate;
  end;
end;

Procedure BuildSelectPopupSubMenu(const Popup : TPopupMenu; const Name : String; const MenuSelect, MenuUnselect : TMenuItem; const Tag : Integer; const OnClick : TNotifyEvent; const Items : TStringList);
Var SubSelect, SubUnselect,M : TMenuItem;
    I : Integer;
begin
  SubSelect:=TMenuItem.Create(Popup);
  SubSelect.Caption:=MaskUnderlineAmpersand(Name);
  SubSelect.Tag:=Tag;
  MenuSelect.Add(SubSelect);

  SubUnselect:=TMenuItem.Create(Popup);
  SubUnselect.Caption:=MaskUnderlineAmpersand(Name);
  SubUnselect.Tag:=Tag;
  MenuUnselect.Add(SubUnselect);

  For I:=0 to Items.Count-1 do begin
    M:=TMenuItem.Create(Popup);
    M.Caption:=MaskUnderlineAmpersand(Items[I]);
    M.Tag:=I;
    M.OnClick:=OnClick;
    SubSelect.Add(M);
    M:=TMenuItem.Create(Popup);
    M.Caption:=MaskUnderlineAmpersand(Items[I]);
    M.Tag:=I;
    M.OnClick:=OnClick;
    SubUnselect.Add(M);
  end;
end;

Procedure BuildCheckList(const CheckListBox : TCheckListBox; const GameDB : TGameDB; const WithDefaultProfile, HideScummVMAndWindowsProfiles : Boolean; const HideWindowsProfiles : Boolean);
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do If WithDefaultProfile or (GameDB[I].Name<>DosBoxDOSProfile) then begin
      If HideScummVMAndWindowsProfiles and (ScummVMMode(GameDB[I]) or WindowsExeMode(GameDB[I])) then continue;
      If HideWindowsProfiles and WindowsExeMode(GameDB[I]) then continue;
      St.AddObject(GameDB[I].Name,GameDB[I]);
    end;
    St.Sort;
    CheckListBox.Items.Assign(St);
    For I:=0 to CheckListBox.Items.Count-1 do CheckListBox.Checked[I]:=True;
  finally
    St.Free;
  end;
end;

Type TUserDataRecord=record
  Name, NameUpper : String;
  Values, ValuesUpper : TStringList;
end;

Procedure BuildSelectPopupMenu(const Popup : TPopupMenu; const GameDB : TGameDB; const OnClick : TNotifyEvent; const WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean);
Var MenuSelect, MenuUnselect : TMenuItem;
    St : TStringList;
    I,J,K,Nr : Integer;
    S,T,U,SUpper : String;
    UserData : Array of TUserDataRecord;
begin
  { Base settings }

  MenuSelect:=TMenuItem.Create(Popup);
  MenuSelect.Caption:=LanguageSetup.Select;
  MenuSelect.Tag:=1;
  Popup.Items.Add(MenuSelect);
  MenuUnselect:=TMenuItem.Create(Popup);
  MenuUnselect.Caption:=LanguageSetup.Unselect;
  MenuUnselect.Tag:=0;
  Popup.Items.Add(MenuUnselect);

  { Add normal meta data submenus }

  St:=GetCustomGenreName(GameDB.GetGenreList(WithDefaultProfile,HideWindowsProfiles));
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameGenre,MenuSelect,MenuUnselect,0,OnClick,St); finally St.Free; end;

  St:=GameDB.GetDeveloperList(WithDefaultProfile,HideWindowsProfiles);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameDeveloper,MenuSelect,MenuUnselect,1,OnClick,St); finally St.Free; end;

  St:=GameDB.GetPublisherList(WithDefaultProfile,HideWindowsProfiles);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GamePublisher,MenuSelect,MenuUnselect,2,OnClick,St); finally St.Free; end;

  St:=GameDB.GetYearList(WithDefaultProfile,HideWindowsProfiles);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameYear,MenuSelect,MenuUnselect,3,OnClick,St); finally St.Free; end;

  St:=GetCustomLanguageName(GameDB.GetLanguageList(WithDefaultProfile,HideWindowsProfiles));
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameLanguage,MenuSelect,MenuUnselect,4,OnClick,St); finally St.Free; end;

  St:=GetCustomLicenseName(GameDB.GetLicenseList(WithDefaultProfile,HideWindowsProfiles));
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameLicense,MenuSelect,MenuUnselect,5,OnClick,St); finally St.Free; end;

  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.GameEmulationTypeDOSBox);
    St.Add(LanguageSetup.GameEmulationTypeScummVM);
    If not HideWindowsProfiles then St.Add(LanguageSetup.GameEmulationTypeWindows);
    BuildSelectPopupSubMenu(Popup,LanguageSetup.GameEmulationType,MenuSelect,MenuUnselect,6,OnClick,St);
  finally
    St.Free;
  end;

  { Collect user data }

  SetLength(UserData,0);

  try
    For I:=0 to GameDB.Count-1 do If WithDefaultProfile or (GameDB[I].Name<>DosBoxDOSProfile) then begin
      St:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St.Count-1 do begin
          S:=Trim(St[J]);
          If (S='') or (Pos('=',S)=0) then continue;
          T:=Trim(Copy(S,Pos('=',S)+1,MaxInt));
          S:=Trim(Copy(S,1,Pos('=',S)-1));
          If (S='') or (T='') then continue;

          SUpper:=ExtUpperCase(S);
          If SUpper='LICENSE' then continue;
          Nr:=-1;
          For K:=0 to length(UserData)-1 do If UserData[K].NameUpper=SUpper then begin Nr:=K; break; end;
          If Nr<0 then begin
            Nr:=length(UserData); SetLength(UserData,Nr+1);
            UserData[Nr].Name:=S; UserData[Nr].NameUpper:=SUpper;
            UserData[Nr].Values:=TStringList.Create;
            UserData[Nr].ValuesUpper:=TStringList.Create;
          end;
          K:=Pos(';',T);
          While T<>'' do begin
            If K>0 then begin
              U:=Trim(Copy(T,1,K-1));
              T:=Trim(Copy(T,K+1,MaxInt));
            end else begin
              U:=T; T:='';
            end;
            If UserData[Nr].ValuesUpper.IndexOf(ExtUpperCase(U))<0 then begin
              UserData[Nr].Values.Add(U);
              UserData[Nr].ValuesUpper.Add(ExtUpperCase(U));
            end;
            K:=Pos(';',T);
          end;
        end;
      finally
        St.Free;
      end;
    end;

    { Build menu from user data }

    For I:=0 to length(UserData)-1 do begin
      BuildSelectPopupSubMenu(Popup,UserData[I].Name,MenuSelect,MenuUnselect,-1,OnClick,UserData[I].Values);
    end;

  finally
    { Free records }

    For I:=0 to length(UserData)-1 do begin
      UserData[I].Values.Free;
      UserData[I].ValuesUpper.Free;
    end;
  end;
end;

Function UserDataContainValue(const UserInfo, Key, Value : String) : Boolean;
Var St : TStringList;
    I,J : Integer;
    S,T : String;
begin
  result:=False;

  St:=StringToStringList(UserInfo);
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      J:=Pos('=',S);
      If J=0 then continue;
      T:=Trim(Copy(S,J+1,MaxInt));
      S:=Trim(Copy(S,1,J-1));
      If (S=Key) and GroupMatch(T,Value) then begin result:=True; exit; end;
    end;
  finally
    St.Free;
  end;
end;

Procedure SelectGamesByPopupMenu(const Sender : TObject; const CheckListBox : TCheckListBox);
Var Select : Boolean;
    Category : Integer;
    CategoryValue : String;
    I : Integer;
    M : TMenuItem;
    G : TGame;
    S, CategoryName : String;
begin
  If not (Sender is TMenuItem) then exit;
  M:=Sender as TMenuItem;
  CategoryValue:=RemoveUnderline(Trim(ExtUpperCase(M.Caption)));
  If CategoryValue=Trim(ExtUpperCase(LanguageSetup.NotSet)) then CategoryValue:='';
  Category:=M.Parent.Tag;
  Select:=(M.Parent.Parent.Tag=1);
  If Category=-1 then CategoryName:=RemoveUnderline(ExtUpperCase(M.Parent.Caption)) else CategoryName:='';

  For I:=0 to CheckListBox.Items.Count-1 do begin
    G:=TGame(CheckListBox.Items.Objects[I]);
    If CategoryName<>'' then begin
      If not UserDataContainValue(G.UserInfo,CategoryName,CategoryValue) then continue;
    end else begin
      Case Category of
        0 : S:=GetCustomGenreName(G.CacheGenre);
        1 : S:=G.CacheDeveloper;
        2 : S:=G.CachePublisher;
        3 : S:=G.CacheYear;
        4 : S:=GetCustomLanguageName(G.CacheLanguage);
        5 : S:=GetCustomLicenseName(G.License);
        6 : begin
              S:='DOSBox';
              If ScummVMMode(G) then S:='ScummVM';
              If WindowsExeMode(G) then S:='Windows';
            end;
      end;
      S:=Trim(S);
      If not GroupMatch(ExtUpperCase(S),CategoryValue) then continue;
    end;
    CheckListBox.Checked[I]:=Select;
  end;
end;

Procedure SelectGamesByPopupMenu(const Sender : TObject; const ListView : TListView);
Var Select : Boolean;
    Category : Integer;
    CategoryValue : String;
    I : Integer;
    M : TMenuItem;
    G : TGame;
    S, CategoryName : String;
begin
  If not (Sender is TMenuItem) then exit;
  M:=Sender as TMenuItem;
  CategoryValue:=RemoveUnderline(Trim(ExtUpperCase(M.Caption)));
  If CategoryValue=Trim(ExtUpperCase(LanguageSetup.NotSet)) then CategoryValue:='';
  Category:=M.Parent.Tag;
  Select:=(M.Parent.Parent.Tag=1);
  If Category=-1 then CategoryName:=RemoveUnderline(ExtUpperCase(M.Parent.Caption)) else CategoryName:='';

  For I:=0 to ListView.Items.Count-1 do begin
    G:=TGame(ListView.Items[I].Data);
    If CategoryName<>'' then begin
      If not UserDataContainValue(G.UserInfo,CategoryName,CategoryValue) then continue;
    end else begin
      Case Category of
        0 : S:=GetCustomGenreName(G.CacheGenre);
        1 : S:=G.CacheDeveloper;
        2 : S:=G.CachePublisher;
        3 : S:=G.CacheYear;
        4 : S:=GetCustomLanguageName(G.CacheLanguage);
        5 : begin
              S:='DOSBox';
              If ScummVMMode(G) then S:='ScummVM';
              If WindowsExeMode(G) then S:='Windows';
            end;
      end;
      S:=Trim(S);
      If ExtUpperCase(S)<>CategoryValue then continue;
    end;
    ListView.Items[I].Checked:=Select;
  end;
end;

Function GetUserDataList(const GameDB : TGameDB) : TStringList;
Var UserData : Array of TUserDataRecord;
    I,J,K,Nr : Integer;
    St : TStringList;
    S,T,SUpper : String;
begin
  SetLength(UserData,0);
  For I:=0 to GameDB.Count-1 do begin
    St:=StringToStringList(GameDB[I].UserInfo);
    try
      For J:=0 to St.Count-1 do begin
        S:=Trim(St[J]);
        If (S='') or (Pos('=',S)=0) then continue;
        T:=Trim(Copy(S,Pos('=',S)+1,MaxInt));
        S:=Trim(Copy(S,1,Pos('=',S)-1));
        If (S='') or (T='') then continue;
        SUpper:=ExtUpperCase(S);
        Nr:=-1;
        For K:=0 to length(UserData)-1 do If UserData[K].NameUpper=SUpper then begin Nr:=K; break; end;
        If Nr<0 then begin
          Nr:=length(UserData); SetLength(UserData,Nr+1);
          UserData[Nr].Name:=S; UserData[Nr].NameUpper:=SUpper;
        end;
      end;
    finally
      St.Free;
    end;
  end;
  result:=TStringList.Create;
  For I:=0 to length(UserData)-1 do result.Add(UserData[I].Name);
end;

Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);
Var C : TListColumn;
    I,Nr : Integer;
    V,O,VUser : String;
    VUserSt : TStringList;
begin
  AListView.ReadOnly:=True;

  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    AListView.Columns.BeginUpdate;
    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;
      AListView.Columns.Clear;

      C:=AListView.Columns.Add;
      C.Caption:=LanguageSetup.GameName;
      C.Width:=-1;

      If not ShowExtraInfo then begin
        C:=AListView.Columns.Add;
        C.Caption:=LanguageSetup.GameSetup;
        C.Width:=-2;
        exit;
      end;

      For I:=0 to length(O)-1 do begin
        Nr:=-1;
        Case O[I+1] of
          '1'..'9' : Nr:=StrToInt(O[I+1]);
          'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
          'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
        end;
        If Nr<1 then continue;
        If Nr<=8 then begin
          If V[Nr]='0' then continue;
        end else begin
          If Nr-8>VUserSt.Count then continue;
        end;

        C:=AListView.Columns.Add;
        Case Nr-1 of
          0 : C.Caption:=GetCustomGenreName(LanguageSetup.GameSetup);
          1 : C.Caption:=LanguageSetup.GameGenre;
          2 : C.Caption:=LanguageSetup.GameDeveloper;
          3 : C.Caption:=LanguageSetup.GamePublisher;
          4 : C.Caption:=LanguageSetup.GameYear;
          5 : C.Caption:=GetCustomLanguageName(LanguageSetup.GameLanguage);
          6 : C.Caption:=LanguageSetup.GameNotes;
          7 : C.Caption:=LanguageSetup.GameStartCount;
          else C.Caption:=VUserSt[Nr-9];
        end;
        If Nr-1=0 then C.Width:=-2 else C.Width:=-1;
      end;
    finally
      AListView.Columns.EndUpdate;
      AListView.Items.EndUpdate;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure ScaleGraphicToImageList(const Graphic : TGraphic; const ImageList : TImageList; const UseFiltering : Boolean; const UseBackgroundColor : Boolean; const BackgroundColor : TColor);
Var B,B2 : TBitmap;
    D1,D2 : Double;
    W,H : Integer;
begin
  B:=TBitmap.Create;
  try
    SetStretchBltMode(B.Canvas.Handle,STRETCH_HALFTONE);
    SetBrushOrgEx(B.Canvas.Handle,0,0,nil);
    B.Transparent:=True;

    If UseBackgroundColor then begin
      B.Canvas.Brush.Color:=BackgroundColor;
      B.Canvas.Rectangle(-1,-1,B.Width+1,B.Height+1);
    end;

    B2:=nil;
    try
      B2:=TBitmap.Create;
      B2.Width:=Graphic.Width;
      B2.Height:=Graphic.Height;
      B2.Canvas.Draw(0,0,Graphic);

      B.Width:=ImageList.Width; B.Height:=ImageList.Height;
      D1:=B2.Width/B2.Height; D2:=B.Width/B.Height;
      If D1>=D2 then begin W:=B.Width; H:=Round(W/D1); end else begin H:=B.Height; W:=Round(H*D1); end;
      ScaleImage(B2,B,W,H,UseFiltering);
      ImageList.Add(B,nil);
    finally
      If B2<>nil then B2.Free;
    end;
  finally
    B.Free;
  end;
end;

Function LoadScreenshotToImageLists(const Game : TGame; ImageList2 : TImageList; const UseBackgroundColor : Boolean; const BackgroundColor : TColor) : Boolean;
Var S,T,U : String;
    Rec : TSearchRec;
    I : Integer;
    P : TPicture;
    B : Boolean;
    St : TStringList;
begin
  result:=False;
  S:=Trim(Game.CaptureFolder);
  If S='' then exit;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  If not DirectoryExists(S) then exit;

  B:=False;
  If Trim(Game.ScreenshotListScreenshot)<>'' then begin
    If Pos('\',Game.ScreenshotListScreenshot)<>0 then begin
      T:=MakeAbsPath(Game.ScreenshotListScreenshot,PrgSetup.BaseDir);
    end else begin
      T:=IncludeTrailingPathDelimiter(S)+Trim(Game.ScreenshotListScreenshot);
    end;
    B:=FileExists(T);
  end;

  If (not B) and PrgSetup.ScreenshotListUseFirstScreenshot then begin
    T:='';
    St:=TStringList.Create;
    try
      I:=FindFirst(IncludeTrailingPathDelimiter(S)+'*.*',faAnyFile,Rec);
      try
        While I=0 do begin
          If (Rec.Attr and faDirectory)=0 then begin
            U:=ExtUpperCase(ExtractFileExt(Rec.Name));
            If (U='.BMP') or (U='.GIF') or (U='.PNG') or (U='.JPG') or (U='.JPEG') then St.Add(Rec.Name);
          end;
          I:=FindNext(Rec);
        end;
      finally
       FindClose(Rec);
      end;
      St.Sort;

      If St.Count>0 then T:=IncludeTrailingPathDelimiter(S)+St[Min(St.Count-1,Max(0,PrgSetup.ScreenshotListUseFirstScreenshotNr-1))];
    finally
      St.Free;
    end;
  end;
  
  If T='' then exit;

  P:=PictureCache.GetPicture(T);
  result:=(P<>nil);

  If result then ScaleGraphicToImageList(P.Graphic,ImageList2,True,UseBackgroundColor,BackgroundColor);
end;

Function UserInfoGetValue(const UserInfo, Key : String) : String;
Var I,J : Integer;
    St : TStringList;
    S,KeyUpper : String;
begin
 result:='';
 KeyUpper:=ExtUpperCase(Key);

  St:=StringToStringList(UserInfo);
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      J:=Pos('=',S);
      If J=0 then continue;
      If Trim(Copy(S,1,J-1))=KeyUpper then begin
        result:=Trim(Copy(Trim(St[I]),J+1,MaxInt));
        exit;
      end;
    end;
  finally
    St.Free;
  end;
end;

Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean; const O,V : String; const VUserSt : TStringList; const T : String; const ScreenshotViewMode, ScummVMTemplate : Boolean; const UseBackgroundColor : Boolean; const BackgroundColor : TColor);
Var IconNr,I,J,Nr : Integer;
    B : Boolean;
    S : String;
    L : TListItem;
    SubUsed,SubCount : Integer;
    Icon : TIcon;
    St : TStringList;
begin
  {Set IconNr to the corrosponding icon in imagelist}
  B:=False; IconNr:=0;
  If ScreenshotViewMode then begin
    B:=LoadScreenshotToImageLists(Game,AListViewIconImageList,UseBackgroundColor,BackgroundColor);
    If B then IconNr:=AListViewIconImageList.Count-1;
  end;
  If not B then begin
    If Trim(Game.Icon)<>'' then S:=MakeAbsIconName(Game.Icon) else S:='';
    If (S<>'') and (not FileExists(S)) then S:='';
    If (S='') and WindowsExeMode(Game) and PrgSetup.UseWindowsExeIcons then
      S:=MakeAbsIconName(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir));
    If S<>'' then Icon:=IconCache.GetIcon(S) else Icon:=nil;
    B:=(Icon<>nil);
    If B then begin
      AListViewImageList.AddIcon(Icon);
      If ScreenshotViewMode then begin
        ScaleGraphicToImageList(Icon,AListViewIconImageList,True,UseBackgroundColor,BackgroundColor);
      end else begin
        If Icon.Width>=AListViewIconImageList.Width then begin
          I:=AListViewIconImageList.Count;
          AListViewIconImageList.AddIcon(Icon);
          If AListViewIconImageList.Count=I then ScaleGraphicToImageList(Icon,AListViewIconImageList,False,UseBackgroundColor,BackgroundColor);
        end else begin
          ScaleGraphicToImageList(Icon,AListViewIconImageList,False,UseBackgroundColor,BackgroundColor);
        end;
      end;
    end;
    If B then IconNr:=AListViewIconImageList.Count-1;
  end;

  {Set L to TListItem to use}
  If ItemsUsed>=AListView.Items.Count
    then L:=AListView.Items.Add
    else L:=AListView.Items[ItemsUsed];
  inc(ItemsUsed);

  {Set caption}
  If (Game.CacheName='') and (not Game.OwnINI) then begin
    If ScummVMTemplate
      then L.Caption:=LanguageSetup.TemplateFormDefaultScummVM
      else L.Caption:=LanguageSetup.TemplateFormDefault;
  end else begin
    If L.Caption<>Game.CacheName then L.Caption:=Game.CacheName;
  end;

  {Set additional cols}
  with L do begin
    Data:=Game;

    SubUsed:=0; SubCount:=SubItems.Count;
    SubItems.BeginUpdate;
    try
      SubItems.Capacity:=Max(SubItems.Capacity,10);
      If ShowExtraInfo then begin
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=8 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-8>VUserSt.Count then continue;
          end;
          Case Nr-1 of
            0 : If Trim(Game.SetupExe)<>'' then S:=LanguageSetupFastYes else S:=LanguageSetupFastNo;
            1 : begin S:=GetCustomGenreName(Game.CacheGenre); If Trim(S)='' then S:=T; end;
            2 : begin S:=Game.CacheDeveloper; If Trim(S)='' then S:=T; end;
            3 : begin S:=Game.CachePublisher; If Trim(S)='' then S:=T; end;
            4 : begin S:=Game.CacheYear; If Trim(S)='' then S:=T; end;
            5 : begin S:=GetCustomLanguageName(Game.CacheLanguage); If Trim(S)='' then S:=T; end;
            6 : begin
                  St:=StringToStringList(Game.Notes); S:=St.Text; St.Free;
                  For J:=1 to length(S) do if (S[J]=#10) or (S[J]=#13) then S[J]:=' ';
                  If length(S)>100 then S:=Copy(S,1,100)+'...';
                  If Trim(S)='' then S:=T;
                end;
            7 : S:=IntToStr(History.GameStartCount(Game.CacheName));
            else S:=UserInfoGetValue(Game.UserInfo,VUserSt[(Nr-1)-8]);
          end;
          If SubUsed<SubCount then SubItems[SubUsed]:=S else SubItems.Add(S);
          inc(SubUsed);
        end;
      end else begin
        If Trim(Game.SetupExe)<>'' then S:=LanguageSetupFastYes else S:=LanguageSetupFastNo;
        If SubUsed<SubCount then begin
          If SubItems[SubUsed]<>S then SubItems[SubUsed]:=S;
        end else begin
          SubItems.Add(S);
        end;
        inc(SubUsed);
      end;
      While SubCount>SubUsed do begin SubItems.Delete(SubCount-1); dec(SubCount); end;
    finally
      SubItems.EndUpdate;
    end;
    ImageIndex:=IconNr;
  end;
end;

Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo, ScreenshotViewMode, ScummVMTemplate : Boolean; const UseBackgroundColor : Boolean; const BackgroundColor : TColor);
Var O,V,VUser,T : String;
    VUserSt : TStringList;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If Trim(PrgSetup.ValueForNotSet)='' then T:=LanguageSetup.NotSet else T:=Trim(PrgSetup.ValueForNotSet);
    AddGameToList(AListView,ItemsUsed,AListViewImageList,AListViewIconImageList,AImageList,Game,ShowExtraInfo,O,V,VUserSt,T,ScreenshotViewMode,ScummVMTemplate,UseBackgroundColor,BackgroundColor);
  finally
    VUserSt.Free;
  end;
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile, ScreenshotViewMode : Boolean);
begin
  AddGamesToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,GameDB,nil,Group,SubGroup,SearchString,ShowExtraInfo,SortBy,ReverseOrder,HideScummVMProfiles,HideWindowsProfiles,HideDefaultProfile,ScreenshotViewMode);
end;

Function GroupMatch(const GameGroupUpper, SelectedGroupUpper : String) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=True;
  If GameGroupUpper=SelectedGroupUpper then exit;

  S:=GameGroupUpper;
  I:=Pos(';',S);
  If I<>0 then While S<>'' do begin
    If I>0 then begin
      If Trim(Copy(S,1,I-1))=SelectedGroupUpper then exit;
      S:=Trim(Copy(S,I+1,MaxInt));
    end else begin
      If Trim(S)=SelectedGroupUpper then exit;
      break;
    end;
    I:=Pos(';',S);
  end;

  result:=False;
end;

Function SortByStartCount(Item1, Item2: Pointer) : Integer;
begin
  result:=History.GameStartCount(TGame(Item2).CacheName)-History.GameStartCount(TGame(Item1).CacheName);
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Game : TGame; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile,  ScreenshotViewMode : Boolean); overload;
Var I,J,K,Nr,ItemsUsed : Integer;
    GroupUpper, SubGroupUpper : String;
    B, FirstDefaultTemplate : Boolean;
    C : Array of Integer;
    List : TList;
    St,St2 : TStringList;
    S,T : String;
    O,V,VUser : String;
    EmType1,EmType2, EmType3 : String;
    EmTypeUser : Array of String;
    Bitmap : TBitmap;
    VUserSt : TStringList;
    W : TWinControl;
    F : TForm;
    Filter : TGamesListFilter;
    UseBackgroundColor : Boolean;
    BackgroundColor : TColor;
    RecentlyStarted : TStringList;
    {$IFDEF SpeedTest}Ca : Cardinal;{$ENDIF}
begin
  {$IFDEF SpeedTest}Ca:=GetTickCount;{$ENDIF}
  LogInfo('### Start of AddGamesToList ###');

  S:=Trim(PrgSetup.GamesListViewBackground);
  UseBackgroundColor:=(S<>''); BackgroundColor:=clWhite;
  If UseBackgroundColor then try BackgroundColor:=StringToColor(S); except UseBackgroundColor:=False; end;

  LogInfo('Preparing ListView');
  {Prepare ListView}
  AListViewImageList.Clear;

  Bitmap:=TBitmap.Create;
  try
    AImageList.GetBitmap(0,Bitmap);
    ScaleGraphicToImageList(Bitmap,AListViewImageList,False,UseBackgroundColor,BackgroundColor);
  finally
    Bitmap.Free;
  end;

  AListViewIconImageList.Clear;
  If ScreenshotViewMode then begin
    Bitmap:=TBitmap.Create;
    try
      AImageList.GetBitmap(0,Bitmap);
      ScaleGraphicToImageList(Bitmap,AListViewIconImageList,False,UseBackgroundColor,BackgroundColor);
    finally
      Bitmap.Free;
    end;
  end else begin
    Bitmap:=TBitmap.Create;
    try
      AImageList.GetBitmap(0,Bitmap);
      ScaleGraphicToImageList(Bitmap,AListViewIconImageList,False,UseBackgroundColor,BackgroundColor);
    finally
      Bitmap.Free;
    end;
  end;
  SetLength(C,AListView.Columns.Count);
  AListView.Columns.BeginUpdate;
  try
    For I:=0 to length(C)-1 do begin C[I]:=AListView.Columns[I].Width; AListView.Columns[I].Width:=1; end;
  finally
    AListView.Columns.EndUpdate;
  end;

  LogInfo('Selecting game to add to ListView');
  RecentlyStarted:=nil;
  List:=TList.Create;
  try
    {Select games to add}
    Filter:=TGamesListFilter.Create;
    try
      Filter.SetFilterString(SearchString);
      If (SubGroup='') and (Group<>LanguageSetup.GameRecentlyPlayed) then begin
        B:=(Group=LanguageSetup.GameFavorites);
        for I:=0 to GameDB.Count-1 do begin
          If B and (not GameDB[I].Favorite) then continue;
          If HideDefaultProfile and (GameDB[I].Name=DosBoxDOSProfile) then continue;
          If HideScummVMProfiles and (ScummVMMode(GameDB[I]) or WindowsExeMode(GameDB[I])) then continue;
          If HideWindowsProfiles and WindowsExeMode(GameDB[I]) then continue;
          If (SearchString<>'') and (not Filter.FilterOk(GameDB[I])) then continue;
          List.Add(GameDB[I]);
        end;
      end else begin
        GroupUpper:=Trim(ExtUpperCase(Group));
        If SubGroup=LanguageSetup.NotSet then SubGroupUpper:='' else SubGroupUpper:=ExtUpperCase(SubGroup);
        Nr:=7;
        If Group=LanguageSetup.GameGenre then Nr:=0;
        If Group=LanguageSetup.GameDeveloper then Nr:=1;
        If Group=LanguageSetup.GamePublisher then Nr:=2;
        If Group=LanguageSetup.GameYear then Nr:=3;
        If Group=LanguageSetup.GameLanguage then Nr:=4;
        If Group=LanguageSetup.GameEmulationType then Nr:=5;
        If Group=LanguageSetup.GameLicense then Nr:=6;
        If Group=LanguageSetup.GameRecentlyPlayed then Nr:=8;

        if Nr=8 then begin
          RecentlyStarted:=History.GetRecentlyStarted(50,true);
        end;

        EmType1:=ExtUpperCase(LanguageSetup.GameEmulationTypeDOSBox);
        EmType2:=ExtUpperCase(LanguageSetup.GameEmulationTypeScummVM);
        EmType3:=ExtUpperCase(LanguageSetup.GameEmulationTypeWindows);
        SetLength(EmTypeUser,PrgSetup.WindowsBasedEmulatorsNames.Count);
        For I:=0 to PrgSetup.WindowsBasedEmulatorsNames.Count-1 do EmTypeUser[I]:=ExtUpperCase(PrgSetup.WindowsBasedEmulatorsNames[I]);

        For I:=0 to GameDB.Count-1 do begin
          If HideScummVMProfiles and (ScummVMMode(GameDB[I]) or WindowsExeMode(GameDB[I])) then continue;
          If HideDefaultProfile and (GameDB[I].Name=DosBoxDOSProfile) then continue;
          B:=False;
          Case Nr of
            0 : B:=GroupMatch(ExtUpperCase(GetCustomGenreName(GameDB[I].CacheGenre)),SubGroupUpper);
            1 : B:=GroupMatch(GameDB[I].CacheDeveloperUpper,SubGroupUpper);
            2 : B:=GroupMatch(GameDB[I].CachePublisherUpper,SubGroupUpper);
            3 : B:=GroupMatch(GameDB[I].CacheYearUpper,SubGroupUpper);
            4 : B:=GroupMatch(ExtUpperCase(GetCustomLanguageName(GameDB[I].CacheLanguage)),SubGroupUpper);
            5 : begin
                  If SubGroupUpper=EmType1 then B:=DOSBoxMode(GameDB[I]) else begin
                    If SubGroupUpper=EmType2 then B:=ScummVMMode(GameDB[I]) else begin
                      If SubGroupUpper=EmType3 then begin
                        B:=WindowsExeMode(GameDB[I]);
                        If B then For J:=0 to Length(EmTypeUser)-1 do begin
                          if ExtUpperCase(MakeAbsPath(GameDB[I].GameExe,PrgSetup.BaseDir))=ExtUpperCase(PrgSetup.WindowsBasedEmulatorsPrograms[J]) then begin
                            B:=False;
                            break;
                          end;
                        end;
                      end else begin
                        B:=False;
                        If WindowsExeMode(GameDB[I]) then For J:=0 to Length(EmTypeUser)-1 do If SubGroupUpper=EmTypeUser[J] then begin
                          B:=(ExtUpperCase(MakeAbsPath(GameDB[I].GameExe,PrgSetup.BaseDir))=ExtUpperCase(PrgSetup.WindowsBasedEmulatorsPrograms[J]));
                          break;
                        end;
                      end;
                    end;
                  end;
                end;
            6 : B:=GroupMatch(ExtUpperCase(GetCustomLicenseName(GameDB[I].License)),SubGroupUpper);
            7 : begin
                  B:=(SubGroupUpper='');
                  St2:=StringToStringList(GameDB[I].CacheUserInfo);
                  try
                    For J:=0 to St2.Count-1 do begin
                      S:=St2[J]; K:=Pos('=',S); If K=0 then T:='' else begin T:=Trim(Copy(S,K+1,MaxInt)); S:=Trim(Copy(S,1,K-1)); end;
                      If Trim(ExtUpperCase(S))=GroupUpper then begin B:=GroupMatch(Trim(ExtUpperCase(T)),SubGroupUpper); break; end;
                    end;
                  finally
                    St2.Free;
                  end;
                end;
            8 : begin
                  B:=(RecentlyStarted.IndexOf(GameDB[I].CacheNameUpper)>=0);
                end;
          end;
          If not B then continue;
          If (SearchString<>'') and (not Filter.FilterOk(GameDB[I])) then continue;
          List.Add(GameDB[I]);
        end;
      end;
    finally
      Filter.Free;  
    end;

    If Game<>nil then begin
      List.Add(Game); {DOSBox default template}
      List.Add(Game); {ScummVM default template}
    end;

    LogInfo('Sorting games');
    St:=TStringList.Create;
    try
      {Sort games}
      GetColOrderAndVisible(O,V,VUser);
      VUserSt:=ValueToList(VUser);
      try
        If SortBy<>slbStartCount then begin
          For I:=0 to List.Count-1 do begin
            Case SortBy of
              slbName : St.AddObject(TGame(List[I]).CacheName,TGame(List[I]));
              slbSetup : If Trim(TGame(List[I]).SetupExe)<>''
                           then St.AddObject(RemoveUnderline(LanguageSetup.Yes),TGame(List[I]))
                           else St.AddObject(RemoveUnderline(LanguageSetup.No),TGame(List[I]));
              slbGenre : St.AddObject(GetCustomGenreName(TGame(List[I]).CacheGenre),TGame(List[I]));
              slbDeveloper : St.AddObject(TGame(List[I]).CacheDeveloper,TGame(List[I]));
              slbPublisher : St.AddObject(TGame(List[I]).CachePublisher,TGame(List[I]));
              slbYear : St.AddObject(TGame(List[I]).CacheYear,TGame(List[I]));
              slbLanguage : St.AddObject(GetCustomLanguageName(TGame(List[I]).CacheLanguage),TGame(List[I]));
              slbComment : St.AddObject(TGame(List[I]).Notes,TGame(List[I]));
              {slbStartCount : begin
                                S:=IntToStr(History.GameStartCount(TGame(List[I]).CacheName));
                                while length(S)<6 do S:='0'+S;
                                St.AddObject(S,TGame(List[I]));
                              end;}
            End;
            If Integer(SortBy)>=10 then begin
              St.AddObject(UserInfoGetValue(TGame(List[I]).UserInfo,VUserSt[Min(VUserSt.Count-1,Integer(SortBy)-10)]),TGame(List[I]));
            end;
          end;
          St.Sort;
        end else begin
          List.Sort(SortByStartCount);
          For I:=0 to List.Count-1 do St.AddObject('',TGame(List[I]));
        end;

        LogInfo('Adding game to ListView (start)');
        {Add games to list}
        ItemsUsed:=0;
        If Trim(PrgSetup.ValueForNotSet)='' then T:=LanguageSetup.NotSet else T:=Trim(PrgSetup.ValueForNotSet);
        AListView.Items.BeginUpdate;
        try
          FirstDefaultTemplate:=True;

          F:=nil;
          If St.Count>50 then begin
            W:=AListView.Parent;
            While (W<>nil) and (not (W is TForm)) do W:=W.Parent;
            If W is TForm then F:=W as TForm;
            If Assigned(F) then F.Enabled:=False;
          end;

          try
            If ReverseOrder then begin
              For I:=St.Count-1 downto 0 do begin
                If (I mod 25=0) and Assigned(F) then Application.ProcessMessages;
                if (St.Count<100) then LogInfo('Adding '+IntToStr(I+1)+'/'+IntToStr(St.Count)+': '+TGame(St.Objects[I]).CacheName);
                if (St.Objects[I]=nil) or (not (St.Objects[I] is TGame)) then continue;
                AddGameToList(AListView,ItemsUsed,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo,O,V,VUserSt,T,ScreenshotViewMode,FirstDefaultTemplate,UseBackgroundColor,BackgroundColor);
                If (TGame(St.Objects[I]).CacheName='') and (not TGame(St.Objects[I]).OwnINI) then FirstDefaultTemplate:=False;
              end;
            end else begin
              For I:=0 to St.Count-1 do begin
                If (I mod 25=0) and Assigned(F) then Application.ProcessMessages;
                if (St.Count<100) then LogInfo('Adding '+IntToStr(I+1)+'/'+IntToStr(St.Count)+': '+TGame(St.Objects[I]).CacheName);
                if (St.Objects[I]=nil) or (not (St.Objects[I] is TGame)) then continue;
                AddGameToList(AListView,ItemsUsed,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo,O,V,VUserSt,T,ScreenshotViewMode, not FirstDefaultTemplate,UseBackgroundColor,BackgroundColor);
                If (TGame(St.Objects[I]).CacheName='') and (not TGame(St.Objects[I]).OwnINI) then FirstDefaultTemplate:=False;
              end;
            end;
          finally
            If Assigned(F) then F.Enabled:=True;
          end;
        finally
          AListView.Items.EndUpdate;
        end;
      finally
        VUserSt.Free;
      end;

      LogInfo('Adding game to ListView (done)');

      while ItemsUsed<AListView.Items.Count do AListView.Items.Delete(AListView.Items.Count-1);

    finally
      St.Free;
    end;
  finally
   if RecentlyStarted<>nil then RecentlyStarted.Free;
    List.Free;
    LogInfo('Updating column widths');
    AListView.Columns.BeginUpdate;
    try
      For I:=0 to min(length(C),AListView.Columns.Count)-1 do AListView.Columns[I].Width:=C[I];
    finally
      AListView.Columns.EndUpdate;
    end;
  end;

  {$IFDEF SpeedTest}Application.MainForm.Caption:=IntToStr(GetTickCount-Ca);{$ENDIF}

  LogInfo('### End of AddGamesToList ###');
end;

Function GamesListSaveColWidthsToString(const AListView : TListView) : String;
Var O,V,VUser : String;
    St,VUserSt : TStringList;
    I,Nr,C : Integer;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If PrgSetup.ShowExtraInfo then begin
      St:=ValueToList(PrgSetup.ColumnWidths);
      try
        while St.Count<9 do St.Add('-1');
        For I:=8 to St.Count-1 do St[I]:='-1';
        St[0]:=IntToStr(AListView.Column[0].Width);
        C:=0;
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=8 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-8>VUserSt.Count then continue;
          end;
          inc(C);
          If AListView.Columns.Count>C then begin
            While St.Count<Nr+1 do St.Add('-1');
            St[Nr]:=IntToStr(AListView.Column[C].Width);
          end;
        end;
        result:=ListToValue(St);
      finally
        St.Free;
      end;
    end else begin
      St:=TStringList.Create;
      try
        St.Add(IntToStr(AListView.Column[0].Width));
        St.Add(IntToStr(AListView.Column[1].Width));
        result:=ListToValue(St);
      finally
        St.Free;
      end;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure GamesListLoadColWidthsFromString(const AListView : TListView; const Data : String);
Var O,V,VUser : String;
    St,VUserSt : TStringList;
    I,Nr,C,W : Integer;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If PrgSetup.ShowExtraInfo then begin
      St:=ValueToList(Data);
      try
        while St.Count<9+VUserSt.Count do St.Add('');
        If TryStrToInt(St[0],W) and (W>=-2) and (W<1000) then AListView.Column[0].Width:=W;
        C:=0;
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=8 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-8>VUserSt.Count then continue;
          end;
          inc(C);
          If Nr<St.Count then begin
            If TryStrToInt(St[Nr],W) and (W>=-2) and (W<1000) then AListView.Column[C].Width:=W;
          end;
        end;
      finally
        St.Free;
      end;
    end else begin
      St:=ValueToList(Data);
      try
        while St.Count<2 do St.Add('');
        If TryStrToInt(St[0],W) and (W>=-2) and (W<1000) then AListView.Column[0].Width:=W;
        If TryStrToInt(St[1],W) and (W>=-2) and (W<1000) then AListView.Column[1].Width:=W;
      finally
        St.Free;
      end;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure GamesListSaveColWidths(const AListView : TListView);
begin
  If PrgSetup.ShowExtraInfo
    then PrgSetup.ColumnWidths:=GamesListSaveColWidthsToString(AListView)
    else PrgSetup.ColumnWidthsNoExtraInfoMode:=GamesListSaveColWidthsToString(AListView);
end;

Procedure GamesListLoadColWidths(const AListView : TListView);
begin
  If PrgSetup.ShowExtraInfo
    then GamesListLoadColWidthsFromString(AListView,PrgSetup.ColumnWidths)
    else GamesListLoadColWidthsFromString(AListView,PrgSetup.ColumnWidthsNoExtraInfoMode)
end;

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
const Exts : Array[0..4] of String = ('png','jpg','jpeg','gif','bmp');
Var St : TStringList;
    I,K : Integer;
    Rec : TSearchRec;
    B : TBitmap;
    L : TListItem;
begin
  AListView.SortType:=stNone;
  Dir:=IncludeTrailingPathDelimiter(Dir);

  St:=TStringList.Create;
  try
    {Get files list}
    For K:=Low(Exts) to High(Exts) do begin
      I:=FindFirst(Dir+'*.'+Exts[K],faAnyFile,Rec);
      try while I=0 do begin St.Add(Rec.Name); I:=FindNext(Rec); end; finally FindClose(Rec); end;
    end;

    {Sort list}
    St.Sort;

    {Add games to list view}
    For K:=0 to St.Count-1 do begin
      B:=ScreenshotsCache.GetThumbnail(Dir+St[K],AImageList.Width,AImageList.Height);
      If B<>nil then begin
        AImageList.AddMasked(B,clNone); B.Free;
        L:=AListView.Items.Add;
        L.Caption:=St[K];
        L.ImageIndex:=AImageList.Count-1;
      end;
    end;
  finally
    St.Free;
  end;

  AListView.SortType:=stNone;
  AListView.SortType:=stText;
end;

Procedure AddSoundsToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Procedure FindAndAddFiles(const Ext : String);
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
begin
  I:=FindFirst(Dir+'*.'+Ext,faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);

  FindAndAddFiles('wav');
  FindAndAddFiles('mp3');
  FindAndAddFiles('ogg');
  FindAndAddFiles('mid');
  FindAndAddFiles('midi');

  AListView.SortType:=stNone;
  AListView.SortType:=stText;
end;

Procedure AddVideosToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);

  I:=FindFirst(Dir+'*.avi',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.mpg',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.mpeg',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.wmv',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  AListView.SortType:=stNone;
  AListView.SortType:=stText;
end;

Procedure DeleteFiles(const ADir, AMask : String);
Var I : Integer;
    Rec : TSearchRec;
    Dir : String;
begin
  Dir:=IncludeTrailingPathDelimiter(ADir);
  I:=FindFirst(Dir+AMask,faAnyFile,Rec);
  try
    while I=0 do begin
      ExtDeleteFile(Dir+Rec.Name,ftProfile);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure DeleteOldFiles;
begin
  If not PrgSetup.CreateConfFilesForProfiles or (OperationMode=omPortable) then begin
    DeleteFiles(PrgDataDir+GameListSubDir,'*.conf');
  end;
  DeleteFiles(PrgDataDir+GameListSubDir,'tempprof.*');
  ExtDeleteFile(PrgDataDir+'Developers.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Genres.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Profiles.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Publisher.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'stderr.txt',ftProfile);
  ExtDeleteFile(PrgDataDir+'stdout.txt',ftProfile);
  DeleteFiles(PrgDataDir,'temp.*');
  ExtDeleteFile(PrgDataDir+'Templates.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Years.dat',ftProfile);
end;

Function RemoveBackslash(const S : String) : String;
begin
  If S='\' then result:='' else result:=S;
end;

Procedure ReplaceAbsoluteDirs(const GameDB : TGameDB);
Var I,J,K : Integer;
    G : TGame;
    St : TStringList;
    S,T : String;
begin
  For I:=0 to GameDB.Count-1 do begin
    G:=GameDB[I];

    G.GameExe:=RemoveBackslash(MakeRelPath(G.GameExe,PrgSetup.BaseDir));
    G.SetupExe:=RemoveBackslash(MakeRelPath(G.SetupExe,PrgSetup.BaseDir));
    G.CaptureFolder:=RemoveBackslash(MakeRelPath(G.CaptureFolder,PrgSetup.BaseDir,True));
    G.DataDir:=RemoveBackslash(MakeRelPath(G.DataDir,PrgSetup.BaseDir,True));

    St:=ValueToList(G.ExtraFiles);
    try
      For J:=0 to St.Count-1 do St[J]:=RemoveBackslash(MakeRelPath(St[J],PrgSetup.BaseDir));
      J:=0; while J<St.Count do If Trim(St[J])='' then St.Delete(J) else inc(J);
      G.ExtraFiles:=ListToValue(St);
    finally
      St.Free;
    end;

    St:=ValueToList(G.ExtraDirs);
    try
      For J:=0 to St.Count-1 do St[J]:=RemoveBackslash(MakeRelPath(St[J],PrgSetup.BaseDir,True));
      J:=0; while J<St.Count do If Trim(St[J])='' then St.Delete(J) else inc(J);
      G.ExtraDirs:=ListToValue(St);
    finally
      St.Free;
    end;

    For J:=0 to G.NrOfMounts-1 do begin
      St:=ValueToList(G.Mount[J]);
      If St.Count>0 then try
        S:=Trim(St[0]); T:='';
        K:=Pos('$',S);
        while K>0 do begin
          T:=T+RemoveBackslash(MakeRelPath(Trim(Copy(S,1,K-1)),PrgSetup.BaseDir,True))+'$';
          S:=Trim(Copy(S,K+1,MaxInt));
          K:=Pos('$',S);
        end;
        T:=T+RemoveBackslash(MakeRelPath(Trim(S),PrgSetup.BaseDir,True));
        St[0]:=T;
        G.Mount[J]:=ListToValue(St);
      finally
        St.Free;
      end;
    end;

    G.StoreAllValues;
    G.LoadCache;
  end;
end;

Function CopyFiles(Source, Dest : String; const OverwriteExistingFiles, ProcessMessages : Boolean) : Boolean;
Var I : Integer;
    Rec : TSearchRec;
    Files, Folders : TStringList;
begin
  result:=False;

  Source:=IncludeTrailingPathDelimiter(Source);
  Dest:=IncludeTrailingPathDelimiter(Dest);
  if not ForceDirectories(Dest) then exit;

  Files:=TStringList.Create;
  Folders:=TStringList.Create;
  try
    I:=FindFirst(Source+'*.*',faAnyFile,Rec);
    try
      while I=0 do begin
        If (Rec.Attr and faDirectory)<>0 then begin
          If (Rec.Name<>'.') and (Rec.Name<>'..') then Folders.Add(Rec.Name);
        end else begin
          If ProcessMessages and (Files.Count mod 20 =0) then Application.ProcessMessages;
          Files.Add(Rec.Name);
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    For I:=0 to Files.Count-1 do begin
      If ProcessMessages then Application.ProcessMessages;
      If OverwriteExistingFiles then begin
        if not CopyFile(PChar(Source+Files[I]),PChar(Dest+Files[I]),False) then exit;
      end else begin
        If not FileExists(Dest+Files[I]) then begin
          if not CopyFile(PChar(Source+Files[I]),PChar(Dest+Files[I]),False) then exit;
        end;
      end;
    end;

    For I:=0 to Folders.Count-1 do If not CopyFiles(Source+Folders[I],Dest+Folders[I],OverwriteExistingFiles,ProcessMessages) then exit;
  finally
    Files.Free;
    Folders.Free;
  end;

  result:=True;
end;

Procedure UpdateTemplate(const G : TGame; const LastVersion : Integer);
Var B : Boolean;
begin
  B:=False;
  If LastVersion<900 then begin
    If Trim(ExtUpperCase(G.VideoCard))='VGA' then begin G.VideoCard:='vga_s3'; B:=True; end;
    If G.Cycles='Max' then begin G.Cycles:='max'; B:=True; end;
    If G.Cycles='Auto' then begin G.Cycles:='auto'; B:=True; end;
  end;
  If LastVersion<910 then begin
    If G.MixerRate=22050 then begin G.MixerRate:=44100; B:=True; end;
    If G.SBOplRate=22050 then begin G.SBOplRate:=44100; B:=True; end;
    If G.SpeakerRate=22050 then begin G.SpeakerRate:=44100; B:=True; end;
    If G.SpeakerTandyRate=22050 then begin G.SpeakerTandyRate:=44100; B:=True; end;
    If G.JoystickButtonwrap then begin G.JoystickButtonwrap:=False; B:=True; end;
  end;

  If LastVersion<10000 then begin
    If not G.UseScanCodesOld then begin G.UseScanCodes:=False; B:=True; end;
  end;

  If B then G.StoreAllValues;
end;

Procedure UpdateUserDataFolderAndSettingsAfterUpgrade(const GameDB : TGameDB; const LastVersion : Integer);
Var Source,Dest,S : String;
    I : Integer;
    DB : TGameDB;
    G : TGame;
    B : Boolean;
begin
  {Copy new and changed NewUserData files to DataDir}
  If PrgDataDir<>PrgDir then begin
    {Update DataReader.xml to version 6 (only if upgrade from below 1.4.0)}
    if LastVersion<10400 then begin
      If FileExists(PrgDir+NewUserDataSubDir+'\'+DataReaderConfigFile) then CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+DataReaderConfigFile),PChar(PrgDataDir+SettingsFolder+'\'+DataReaderConfigFile),False); {False = overwrite existing file}
    end;

    {Update installer package base script (only if upgrade from below 0.9)}
    If LastVersion<900 then begin
      If FileExists(PrgDir+NSIInstallerHelpFile) then begin
        CopyFile(PChar(PrgDir+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False); {False = overwrite existing file}
      end else begin
        If FileExists(PrgDir+BinFolder+'\'+NSIInstallerHelpFile) then begin
          CopyFile(PChar(PrgDir+BinFolder+'\'+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False); {False = overwrite existing file}
        end;
      end;
    end;

    {Copy Icons.ini to settings folder (always)}
    If FileExists(PrgDir+NewUserDataSubDir+'\'+IconsConfFile) then begin
      If FileExists(PrgDataDir+SettingsFolder+'\'+IconsConfFile) then begin
        If FileExists(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old')) then DeleteFile(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
        RenameFile(PrgDataDir+SettingsFolder+'\'+IconsConfFile,PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
      end;
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+IconsConfFile),PChar(PrgDataDir+SettingsFolder+'\'+IconsConfFile),True);
    end;

    {Add new auto setup templates (always)}
    CopyFiles(PrgDir+NewUserDataSubDir+'\'+AutoSetupSubDir,PrgDataDir+AutoSetupSubDir,False,True); {False = do not overwrite existing file}

    {Update DozZip (only if upgrade from below 1.3)}
    If LastVersion<10300 then begin
      Source:=PrgDir+NewUserDataSubDir+'\DOSZIP\';
      If DirectoryExists(Source) then CopyFiles(Source,IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'DOSZIP\',True,True);
    end;

    {Update FreeDOS (only if upgrade from below 1.3)}
    If LastVersion<10300 then begin
      Source:=PrgDir+NewUserDataSubDir+'\FREEDOS';
      Dest:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'FREEDOS';
      if DirectoryExists(Source) and DirectoryExists(Dest) then begin
        if (GetMD5Sum(Dest+'\kernel.sys',true)=FD10KernelSys) and (GetMD5Sum(Source+'\kernel.sys',true)=FD11KernelSys) then
          CopyFiles(Source,Dest,True,True);
      end;
    end;

    {Update DOSBox screenshot}
    ForceDirectories(PrgDataDir+CaptureSubDir+'\'+DosBoxDOSProfile+'\');
    CopyFiles(PrgDir+NewUserDataSubDir+'\'+CaptureSubDir+'\'+DosBoxDOSProfile+'\',PrgDataDir+CaptureSubDir+'\'+DosBoxDOSProfile+'\',True,False);
  end;

  {Update game DB: Max->max, Auto->auto (only if upgrade from below 9.0)}
  If LastVersion<900 then begin
    For I:=0 to GameDB.Count-1 do begin
      B:=False;
      If GameDB[I].Cycles='Max' then begin GameDB[I].Cycles:='max'; B:=True; end;
      If GameDB[I].Cycles='Auto' then begin GameDB[I].Cycles:='auto'; B:=True; end;
      If B then begin GameDB[I].StoreAllValues; GameDB[I].LoadCache; end;
      Application.ProcessMessages;
    end;
  end;

  {Update default template}
  G:=TGame.Create(PrgSetup);
  try
    If LastVersion<10000 then begin
      G.GUS:=False;
      G.CyclesUp:=10;
      G.MixerRate:=44100;
      G.MixerBlocksize:=1024;
      G.MixerPrebuffer:=20;
      G.SBOplRate:=44100;
      G.GUSRate:=44100;
      G.SpeakerRate:=44100;
      G.SpeakerTandyRate:=44100;
      G.JoystickButtonwrap:=False;
    end;
    If LastVersion<900 then begin
      If G.Cycles='Max' then G.Cycles:='max';
      If G.Cycles='Auto' then G.Cycles:='auto';
    end;
    G.StoreAllValues;
  finally
    G.Free;
  end;

  {Update templates and auto setup template (see UpdateTemplate)}
  DB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  try
    For I:=0 to DB.Count-1 do begin
      UpdateTemplate(DB[I],LastVersion);
      Application.ProcessMessages;
    end;
  finally
    DB.Free;
  end;
  DB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  try
    For I:=0 to DB.Count-1 do begin
      UpdateTemplate(DB[I],LastVersion);
      Application.ProcessMessages;
    end;
  finally
    DB.Free;
  end;
  G:=TGame.Create(PrgSetup);
  try
    UpdateTemplate(G,LastVersion);
  finally
    G.Free;
  end;

  {Change year from 2007 or 2009 to 2010 and "multilingual" to "Multilingual" in "DOSBox DOS" profile (always / only if upgrade from below 9.0)}
  I:=GameDB.IndexOf(DosBoxDOSProfile);
  If (I>0) and ((GameDB[I].CacheYear='2007') or (GameDB[I].CacheYear='2009')) then begin
    GameDB[I].Year:='2010'; GameDB[I].StoreAllValues; GameDB[I].LoadCache;
  end;
  If LastVersion<900 then begin
    If (I>0) and (GameDB[I].CacheLanguage='multilingual') then begin
      GameDB[I].Language:='Multilingual'; GameDB[I].StoreAllValues; GameDB[I].LoadCache;
    end;
  end;

  {Update Autoexec.bat in "DOSBox DOS" profile (only if upgrade from below 1.3)}
  If LastVersion<10300 then begin
    BuildDefaultDosProfileAutoexec(GameDB);
  end;

  {Add new games list column}
  If LastVersion<10009 then begin
    PrgSetup.ColVisible:=Copy(PrgSetup.ColVisible,1,7)+'0'+Copy(PrgSetup.ColVisible,8,MaxInt);
    S:=Trim(PrgSetup.ColOrder);
    For I:=0 to length(S) do begin
      If S[I]='8' then begin S[I]:='9'; continue; end;
      If S[I]='9' then begin S[I]:='A'; continue; end;
      If (ExtUpperCase(S[I])>='A') and (ExtUpperCase(S[I])<='Y') then S[I]:=chr(ord(S[I])+1);
    end;
    PrgSetup.ColOrder:=S;
  end;

  {Update settings in ConfOpt.dat}
  If LastVersion<11100 then begin
    GameDB.ConfOpt.ResolutionFullscreen:=DefaultValuesResolutionFullscreen;
    GameDB.ConfOpt.ResolutionWindow:=DefaultValuesResolutionWindow;
  end;
  If LastVersion<10000 then begin
    GameDB.ConfOpt.Video:=DefaultValuesVideo;
    GameDB.ConfOpt.ResolutionFullscreen:=DefaultValuesResolutionFullscreen;
    GameDB.ConfOpt.ResolutionWindow:=DefaultValuesResolutionWindow;
    GameDB.ConfOpt.TandyRate:=DefaultValuesTandyRate;
    GameDB.ConfOpt.Sblaster:=DefaultValuesSBlaster;
    GameDB.ConfOpt.ReportedDOSVersion:=DefaultValuesReportedDOSVersion;
  end;
  If LastVersion<902 then begin
    GameDB.ConfOpt.Codepage:=DefaultValuesCodepage;
    GameDB.ConfOpt.TandyRate:=DefaultValuesTandyRate;
  end;
  If LastVersion<901 then begin
    GameDB.ConfOpt.KeyboardLayout:=DefaultValuesKeyboardLayout;
    GameDB.ConfOpt.Codepage:=DefaultValuesCodepage;
  end;
  If LastVersion<900 then begin
    GameDB.ConfOpt.Video:=DefaultValuesVideo;
  end;
  If LastVersion<801 then begin
    GameDB.ConfOpt.Joysticks:=DefaultValuesJoysticks;
    GameDB.ConfOpt.GUSRate:=DefaultValuesGUSRate;
    GameDB.ConfOpt.OPLRate:=DefaultValuesOPLRate;
    GameDB.ConfOpt.PCRate:=DefaultValuesPCRate;
    GameDB.ConfOpt.Rate:=DefaultValuesRate;
    GameDB.ConfOpt.Oplmode:=DefaultValuesOPLModes;
    GameDB.ConfOpt.SBBase:=DefaultValuesSBBase;
    GameDB.ConfOpt.GUSBase:=DefaultValuesGUSBase;
    GameDB.ConfOpt.Dma:=DefaultValuesDMA;
    GameDB.ConfOpt.GUSDma:=DefaultValuesDMA1;
    GameDB.ConfOpt.HDMA:=DefaultValuesHDMA;
    GameDB.ConfOpt.Memory:=DefaultValuesMemory;
  end;
  If LastVersion<800 then begin
    GameDB.ConfOpt.ResolutionFullscreen:=DefaultValuesResolutionFullscreen;
    GameDB.ConfOpt.ResolutionWindow:=DefaultValuesResolutionWindow;
    GameDB.ConfOpt.Scale:=DefaultValuesScale;
    GameDB.ConfOpt.Video:=DefaultValuesVideo;
  end;
  GameDB.ConfOpt.StoreAllValues;
end;

Procedure MoveDataFile(const FileName : String);
begin
  If not FileExists(PrgDataDir+FileName) then exit;

  If FileExists(PrgDataDir+SettingsFolder+'\'+FileName) then begin
    {File in new position already exists -> new version of DFR has already used -> delete old file}
    {Ext}DeleteFile(PrgDataDir+FileName{,ftProfile}); {Can't use ExtDelete because ExtDelete querys string from PrgSetup which is not loaded by this time}
  end else begin
    {Move data  file to new position}
    If CopyFile(PChar(PrgDataDir+FileName),PChar(PrgDataDir+SettingsFolder+'\'+FileName),True) then
      {Ext}DeleteFile(PrgDataDir+FileName{,ftProfile}); {Can't use ExtDelete because ExtDelete querys string from PrgSetup which is not loaded by this time}
  end;
end;

Procedure UpdateSettingsFilesLocation;
begin
  {Move configuration files to SettingsFolder}
  ForceDirectories(PrgDataDir+SettingsFolder);

  MoveDataFile(ConfOptFile);
  MoveDataFile(ScummVMConfOptFile);
  MoveDataFile(HistoryFileName);
  MoveDataFile(IconsConfFile);
  MoveDataFile(MainSetupFile);
  MoveDataFile('Links.txt');
  MoveDataFile('SearchLinks.txt');
  MoveDataFile(NSIInstallerHelpFile);
end;

Function RestoreFREEDOSFolder(const ShowWaitForm : Boolean) : Boolean;
Var Source1, Source2, Dest1, Dest2 : String;
    B1, B2 : Boolean;
begin
  result:=True;

  Source1:=PrgDir+NewUserDataSubDir+'\DOSZIP';
  Source2:=PrgDir+NewUserDataSubDir+'\FREEDOS';
  Dest1:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'DOSZIP';
  Dest2:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'FREEDOS';
  B1:=DirectoryExists(Source1);
  B2:=DirectoryExists(Source2);

  If B1 or B2 then begin
    If ShowWaitForm then LoadAndShowSmallWaitForm(LanguageSetup.SetupFormService3WaitInfo);
    try
      If B1 then result:=CopyFiles(Source1,Dest1,True,ShowWaitForm);
      If B2 then result:=CopyFiles(Source2,Dest2,True,ShowWaitForm);
    finally
      If ShowWaitForm then FreeSmallWaitForm;
    end;
  end;
end;

Type TRestoreFreeDOSFolderThread=class(TThread)
  protected
    Procedure Execute; override;
  public
    Constructor Create;
end;

Constructor TRestoreFreeDOSFolderThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate:=True;
  Resume;
end;

Procedure TRestoreFreeDOSFolderThread.Execute;
begin
  FreeDOSInitThreadRunning:=True;
  try
    SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_BELOW_NORMAL);
    While not MainWindowShowComplete do Sleep(100);
    RestoreFREEDOSFolder(False);
  finally
    FreeDOSInitThreadRunning:=False;
  end;
end;

Procedure BuildDefaultDosProfileAutoexec(const GameDB : TGameDB);
Var I : Integer;
    Game : TGame;
    St : TStringList;
begin
  I:=GameDB.IndexOf(DosBoxDOSProfile);
  If I>=0 then Game:=GameDB[I] else exit;

  St:=TStringList.Create;
  try
    St.Add('C:');
    St.Add('echo.');
    St.Add('');
    St.Add('If exist C:\FREEDOS\COMMAND.COM goto AddFreeDos');
    St.Add('Goto Next1');
    St.Add(':AddFreeDos');
    St.Add('set path=%PATH%;C:\FREEDOS');
    St.Add(':Next1');
    St.Add('');
    St.Add('If exist C:\NC55\NC.EXE goto AddNC55');
    St.Add('Goto Next2');
    St.Add(':AddNC55');
    St.Add('set path=%PATH%;C:\NC55');
    St.Add('echo You can start Norton Commander (file manager) by typing "NC".');
    St.Add('Goto Next3');
    St.Add(':Next2');
    St.Add('');
    St.Add('If exist C:\NC551\NC.EXE goto AddNC551');
    St.Add('Goto Next3');
    St.Add(':AddNC551');
    St.Add('set path=%PATH%;C:\NC551');
    St.Add('echo You can start Norton Commander (file manager) by typing "NC".');
    St.Add(':Next3');
    St.Add('');
    St.Add('If exist C:\NDN\NDN.COM goto AddNDN');
    St.Add('Goto Next4');
    St.Add(':AddNDN');
    St.Add('set path=%PATH%;C:\NDN');
    St.Add('echo You can start Necromancer''s Dos Navigator (file manager) by typing "NDN".');
    St.Add(':Next4');
    St.Add('');
    St.Add('If exist C:\DOSZIP\DZ.EXE goto AddDZ');
    St.Add('Goto Next5');
    St.Add(':AddDZ');
    St.Add('set path=%PATH%;C:\DOSZIP');
    St.Add('echo You can start Doszip Commander (file manager) by typing "DZ".');
    St.Add(':Next5');
    St.Add('');
    St.Add('If exist C:\FREEDOS\DOSSHELL.EXE goto AddDosshell');
    St.Add('Goto Next6');
    St.Add(':AddDosshell');
    St.Add('echo You can start FreeDOS Shell (file manager) by typing "DOSSHELL".');
    St.Add(':Next6');
    Game.Autoexec:=StringListToString(St);
    Game.StoreAllValues;
    Game.LoadCache;
  finally
    St.Free;
  end;
end;

Function BuildDefaultDosProfile(const GameDB : TGameDB; const CopyFiles : Boolean) : TGame;
Var I : Integer;
begin
  I:=GameDB.IndexOf(DosBoxDOSProfile);
  If I>=0 then result:=GameDB[I] else result:=GameDB[GameDB.Add(DosBoxDOSProfile)];

  BuildDefaultDosProfileAutoexec(GameDB);

  result.NrOfMounts:=1;
  result.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;';
  result.CloseDosBoxAfterGameExit:=False;
  result.Environment:='PATH[61]Z:\[13]';
  result.StartFullscreen:=False;
  result.CaptureFolder:=MakeRelPath(IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+DosBoxDOSProfile,PrgSetup.BaseDir);
  result.Genre:='Program';
  result.WWW[1]:='http:/'+'/www.dosbox.com';
  result.Name:=DosBoxDOSProfile;
  result.Favorite:=True;
  result.Developer:='DOSBox Team';
  result.Publisher:='DOSBox Team';
  result.Year:='2010';
  result.Language:='Multilingual';
  result.UserInfo:='License=GPL[13]';
  result.Icon:='DOSBox.ico';

  result.StoreAllValues;
  result.LoadCache;

  If (PrgDir<>PrgDataDir) and DirectoryExists(PrgDir+NewUserDataSubDir) then begin
    If FileExists(PrgDir+NewUserDataSubDir+'\'+IconsSubDir+'\DOSBox.ico') then begin
      ForceDirectories(PrgDataDir+IconsSubDir);
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+IconsSubDir+'\'+'DOSBox.ico'),PChar(PrgDataDir+IconsSubDir+'\DOSBox.ico'),False);
    end;
    If FileExists(PrgDir+NewUserDataSubDir+'\'+CaptureSubDir+'\DOSBox DOS\dosbox_000.png') then begin
      ForceDirectories(MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)+'DOSBox DOS');
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+CaptureSubDir+'\DOSBox DOS\dosbox_000.png'),PChar(MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)+'DOSBox DOS\dosbox_000.png'),False);
    end;
  end;

  If FileExists(PrgDir+NSIInstallerHelpFile) then begin
    CopyFile(PChar(PrgDir+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False);
  end else begin
    If FileExists(PrgDir+BinFolder+'\'+NSIInstallerHelpFile) then begin
      CopyFile(PChar(PrgDir+BinFolder+'\'+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False);
    end;
  end;

  If FileExists(PrgDir+NewUserDataSubDir+'\'+IconsConfFile) then begin
    If FileExists(PrgDataDir+SettingsFolder+'\'+IconsConfFile) then begin
      If FileExists(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old')) then DeleteFile(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
      RenameFile(PrgDataDir+SettingsFolder+'\'+IconsConfFile,PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
    end;
    CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+IconsConfFile),PChar(PrgDataDir+SettingsFolder+'\'+IconsConfFile),True);
  end;

  If CopyFiles then TRestoreFreeDOSFolderThread.Create;
end;

Procedure BuildDefaultProfile;
Var DefaultGame : TGame;
begin
  DefaultGame:=TGame.Create(PrgSetup);
  try
    DefaultGame.ResetToDefault;
    DefaultGame.NrOfMounts:=1;
    DefaultGame.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;';
    DefaultGame.Environment:='PATH[61]Z:\[13]';
  finally
    DefaultGame.Free;
  end;
end;

Procedure CopyTemplates(Dir1, Dir2 : String);
Var Rec : TSearchRec;
    I : Integer;
begin
  Dir1:=IncludeTrailingPathDelimiter(Dir1);
  Dir2:=IncludeTrailingPathDelimiter(Dir2);
  I:=FindFirst(Dir1+'*.prof',faAnyFile,Rec);
  try
    While I=0 do begin
      CopyFile(PChar(Dir1+Rec.Name),PChar(Dir2+Rec.Name),False);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Type TReBuildTemplatesThread=class(TThread)
  protected
    Procedure Execute; override;
  public
    Constructor Create;
end;

Constructor TReBuildTemplatesThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate:=True;
  Resume;
end;

Procedure TReBuildTemplatesThread.Execute;
begin
  TemplatesInitThreadRunning:=True;
  try
    SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_BELOW_NORMAL);
    ReBuildTemplates(false);
  finally
    TemplatesInitThreadRunning:=False;
  end;
end;

Procedure ReBuildTemplates(const InBackground : Boolean);
begin
  If PrgDir=PrgDataDir then exit;

  If InBackground then begin
    TReBuildTemplatesThread.Create;
    exit;
  end;

  ForceDirectories(PrgDataDir+TemplateSubDir);
  If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+TemplateSubDir) then
    CopyTemplates(PrgDir+NewUserDataSubDir+'\'+TemplateSubDir,PrgDataDir+TemplateSubDir);

  ForceDirectories(PrgDataDir+AutoSetupSubDir);
  If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+AutoSetupSubDir) then
    CopyTemplates(PrgDir+NewUserDataSubDir+'\'+AutoSetupSubDir,PrgDataDir+AutoSetupSubDir);
end;

Function GetGamesListExportLanguageColumns : TStringList;
begin
  result:=TStringList.Create;

  result.Add(LanguageSetup.GameName);
  result.Add(LanguageSetup.GameEmulationType);
  result.Add(LanguageSetup.GameGenre);
  result.Add(LanguageSetup.GameDeveloper);
  result.Add(LanguageSetup.GamePublisher);
  result.Add(LanguageSetup.GameYear);
  result.Add(LanguageSetup.GameLanguage);
  result.Add(LanguageSetup.GameWWW);
  result.Add(LanguageSetup.GameLicense);
  result.Add(LanguageSetup.GameStartCount);
end;

Function GetGamesListExportXMLColumns : TStringList;
begin
  result:=TStringList.Create;

  result.Add('Name');
  result.Add('EmulationType');
  result.Add('Genre');
  result.Add('Developer');
  result.Add('Publisher');
  result.Add('Year');
  result.Add('Language');
  result.Add('WWW');
  result.Add('License');
  result.Add('StartCount');
end;

Function GetGamesListExportColumnValue(const Game : TGame; const Column : TGamesListExportColumn; const WWWEncode : Boolean = False) : String;
Var I : Integer;
    S : String;
begin
  result:='';
  Case Column of
    glecEmulationType : If ScummVMMode(Game) then result:=LanguageSetup.GameEmulationTypeScummVM else begin If WindowsExeMode(Game) then result:=LanguageSetup.GameEmulationTypeWindows else result:=LanguageSetup.GameEmulationTypeDOSBox; end;
    glecGenre : result:=GetCustomGenreName(Game.CacheGenre);
    glecDeveloper : result:=Game.CacheDeveloper;
    glecPublisher : result:=Game.CachePublisher;
    glecYear : result:=Game.CacheYear;
    glecLanguage : result:=GetCustomLanguageName(Game.CacheLanguage);
    glecWWW : for I:=1 to 9 do begin
                S:='';
                If WWWEncode and (ExtUpperCase(Copy(Trim(Game.WWW[I]),1,4))='HTTP') then result:='<a href="'+Game.WWW[I]+'" target="_blank">'+Game.WWWName[I]+'</a>' else result:=Game.WWWName[I]+' ('+Game.WWW[I]+')';
                If S='' then continue;
                If result<>'' then result:=result+'<br>';
                result:=result+S;
              end;
    glecLicense : result:=GetCustomLicenseName(Game.License);
    glecStartCount : result:=IntToStr(History.GameStartCount(Game.CacheName));
    else result:='';
  end;
  If WWWEncode and (Column<>glecWWW) then result:=EncodeHTMLSymbols(result);
end;

Procedure ExportGamesListTextFile(const GameDB : TGameDB; const Columns : TGamesListExportColumns; const St : TStringList);
Var St2 : TStringList;
    I,J,Len : Integer;
    ColumnNames : TStringList;
    S,T : String;
    L : TList;
begin
  ColumnNames:=GetGamesListExportLanguageColumns;
  try
    {Calculate maximum column name length}
    Len:=0;
    For I:=0 to ColumnNames.Count-1 do If TGamesListExportColumn(I) in Columns then Len:=max(Len,length(ColumnNames[I]));
    If glecUserFields in Columns then For I:=0 to GameDB.Count-1 do begin
      St2:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
          S:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
          If ExtUpperCase(S)='LICENSE' then continue;
          Len:=max(Len,length(S));
        end;
      finally
        St2.Free;
      end;
    end;

    {Make all column names have the same length}
    For I:=0 to ColumnNames.Count-1 do while length(ColumnNames[I])<Len do ColumnNames[I]:=ColumnNames[I]+' ';

    {Output list}
    L:=GameDB.GetSortedGamesList;
    try
      For I:=0 to L.Count-1 do begin
        If I<>0 then St.Add('');

        St.Add(ColumnNames[0]+' : '+TGame(L[I]).CacheName);

        For J:=1 to ColumnNames.Count-1 do If TGamesListExportColumn(J) in Columns then begin
          S:=ColumnNames[J]+' : '+GetGamesListExportColumnValue(TGame(L[I]),TGamesListExportColumn(J));
          St.Add(S);
        end;

        If (glecUserFields in Columns) and (Trim(TGame(L[I]).CacheUserInfo)<>'') then begin
          St2:=StringToStringList(TGame(L[I]).CacheUserInfo);
          try
            For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
              S:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
              If ExtUpperCase(S)='LICENSE' then continue;
              while length(S)<Len do S:=S+' ';
              St.Add(S+' : '+Copy(St2[J],Pos('=',St2[J])+1,MaxInt));
            end;
          finally
            St2.Free;
          end;
        end;

        If (glecNotes in Columns) and (Trim(TGame(L[I]).Notes)<>'') then begin
          St2:=StringToStringList(Trim(TGame(L[I]).Notes));
          try
            If St2.Count=1 then begin
              T:=LanguageSetup.GameNotes;
              While length(T)<Len do T:=T+' ';
              St.Add(T+' : '+St2[0]);
            end else begin
              St.Add(LanguageSetup.GameNotes+':');
              St.AddStrings(St2);
            end;
          finally
            St2.Free;
          end;
        end;
      end;
    finally
      L.Free;
    end;
  finally
    ColumnNames.Free;
  end;
end;

Function EncodeCSV(S : String) : String;
Var I : Integer;
begin
  result:='';
  I:=Pos('"',S);
  While I>0 do begin
    result:=result+Copy(S,1,I-1)+'""';
    S:=Copy(S,I+1,MaxInt);
    I:=Pos('"',S);
  end;
  result:=result+S;
end;

Procedure ExportGamesListTableFile(const GameDB : TGameDB; const Columns : TGamesListExportColumns; const St : TStringList);
Var I,J,K : Integer;
    L : TList;
    UserList, UserListUpper, St2 : TStringList;
    S,T : String;
    ColumnNames : TStringList;
begin
  ColumnNames:=GetGamesListExportLanguageColumns;
  UserList:=TStringList.Create;
  UserListUpper:=TStringList.Create;
  try
    {Output heading line}
    S:='"'+EncodeCSV(ColumnNames[0])+'"';
    For I:=1 to ColumnNames.Count-1 do If TGamesListExportColumn(I) in Columns then S:=S+';"'+EncodeCSV(ColumnNames[I])+'"';
    If glecUserFields in Columns then begin
      For I:=0 to GameDB.Count-1 do begin
        St2:=StringToStringList(GameDB[I].CacheUserInfo);
        try
          For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
            T:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
            If ExtUpperCase(T)='LICENSE' then continue;
            If UserListUpper.IndexOf(ExtUpperCase(T))<0 then begin UserList.Add(T); UserListUpper.Add(ExtUpperCase(T)); end;
          end;
        finally
          St2.Free;
        end;
      end;
      For I:=0 to UserList.Count-1 do S:=S+';"'+EncodeCSV(UserList[I])+'"';
    end;
    If glecNotes in Columns then S:=S+';"'+EncodeCSV(LanguageSetup.GameNotes)+'"';
    St.Add(S);

    {Output list}
    L:=GameDB.GetSortedGamesList;
    try
      For I:=0 to L.Count-1 do begin
        S:='"'+EncodeCSV(TGame(L[I]).CacheName)+'"';

        For J:=1 to ColumnNames.Count-1 do If TGamesListExportColumn(J) in Columns then
          S:=S+';"'+EncodeCSV(GetGamesListExportColumnValue(TGame(L[I]),TGamesListExportColumn(J)))+'"';

        If glecUserFields in Columns then begin
          St2:=StringToStringList(TGame(L[I]).CacheUserInfo);
          try
            For J:=0 to UserList.Count-1 do begin
            T:='';
            For K:=0 to St2.Count-1 do If Pos('=',St2[K])>0 then begin
              If Trim(ExtUpperCase(Copy(St2[K],1,Pos('=',St2[K])-1)))=UserListUpper[J] then begin
                T:=Trim(Copy(St2[K],Pos('=',St2[K])+1,MaxInt)); break;
              end;
            end;
            S:=S+';"'+EncodeCSV(T)+'"';
          end;
          finally
            St2.Free;
          end;
        end;

        If glecNotes in Columns then begin
          S:=S+';"';
          St2:=StringToStringList(TGame(L[I]).Notes);
          try
            For J:=0 to St2.Count-1 do begin
              If J>0 then S:=S+' ';
              S:=S+EncodeCSV(St2[J]);
            end;
          finally St2.Free; end;
          S:=S+'"';
        end;

        St.Add(S);
      end;
    finally
      L.Free;
    end;
  finally
    UserList.Free;
    UserListUpper.Free;
    ColumnNames.Free;
  end;
end;

Function EncodeUserHTMLSymbolsOnly(const S : String) : String;
Var I : Integer;
    St : TStringList;
    A,B : String;
begin
  result:=S;

  St:=ValueToList(LanguageSetup.CharsetHTMLTranslate,',');
  try
    If St.Count mod 2=1 then St.Add(St[St.Count-1]);
    For I:=0 to (St.Count div 2)-1 do begin
      A:=St[2*I]; If length(A)=0 then continue;
      B:=St[2*I+1]; If (B<>'') and (B[length(B)]<>';') then B:=B+';';
      If (A[1]='&') or (ExtUpperCase(B)='&AMP;') then continue;
      result:=Replace(result,A[1],B);
    end;
  finally
    St.Free;
  end;
end;

Function EncodeHTMLSymbols(const S : String) : String;
begin
  result:=S;
  result:=Replace(result,'&','&amp;'); {must be the first, otherweise "ä" -> "&auml;" -> "&amp;auml;" will happen}
  result:=Replace(result,'<','&lt;');
  result:=Replace(result,'>','&gt;');
  result:=Replace(result,'"','&quot;');
  {result:=Replace(result,'''','&apos;'); only valid in XHTML}
  result:=EncodeUserHTMLSymbolsOnly(result);
end;

Function TryStrToHex(const S : String; var Hex : Integer) : Boolean;
Var I : Integer;
begin
  result:=False;
  Hex:=0;
  For I:=1 to length(S) do begin
    Hex:=Hex*16;
    Case UpCase(S[I]) of
      '0'..'9' : Hex:=Hex+(ord(S[I])-ord('0'));
      'A'..'F' : Hex:=Hex+(ord(UpCase(S[I]))-ord('A')+10);
      else exit;
    End;
  end;
  result:=True;
end;

Function DecodeHTMLSymbols(const S : String) : String;
Var I,J,K : Integer;
    St : TStringList;
    A,B : String;
begin
  result:=S;
  result:=Replace(result,'&amp;','&');
  result:=Replace(result,'&lt;','<');
  result:=Replace(result,'&gt;','>');
  result:=Replace(result,'&quot;','"');
  result:=Replace(result,'&apos;','''');

  I:=1;
  While I<length(result)-1 do begin
    If (result[I]='&') and (result[I+1]='#') then begin
      If (I<length(result)-2) and (result[I+2]='x') then begin
        {Hex number}
        J:=0; while (I+3+J<length(result)) and (result[I+3+J]<>';') do inc(J);
        If (J>=1) and (J<=3) and TryStrToHex(Copy(result,I+3,J),K) then result:=copy(result,1,I-1)+chr(K)+copy(result,I+3+J);
      end else begin
        {Decimal number}
        J:=0; while (I+2+J<length(result)) and (result[I+2+J]<>';') do inc(J);
        If (J>=1) and (J<=2) and TryStrToInt(Copy(result,I+3,J),K) then result:=copy(result,1,I-1)+chr(K)+copy(result,I+2+J);
      end;
    end;
    inc(I);
  end;

  St:=ValueToList(LanguageSetup.CharsetHTMLTranslate,',');
  try
    If St.Count mod 2=1 then St.Add(St[St.Count-1]);
    For I:=0 to (St.Count div 2)-1 do begin
      A:=St[2*I]; If length(A)=0 then continue;
      B:=St[2*I+1]; If (B<>'') and (B[length(B)]<>';') then B:=B+';';
      If (A[1]='&') or (ExtUpperCase(B)='&AMP;') then continue;
      result:=Replace(result,B,A[1]);
    end;
  finally
    St.Free;
  end;
end;

Procedure GetUserLists(const GameDB : TGameDB; var UserList, UserListUpper : TStringLIst);
Var I,J : Integer;
    S : String;
    St2 : TStringList;
begin
  UserList:=TStringList.Create;
  UserListUpper:=TStringList.Create;

  For I:=0 to GameDB.Count-1 do begin
    St2:=StringToStringList(GameDB[I].UserInfo);
    try
      For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
        S:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
        If ExtUpperCase(S)='LICENSE' then continue;
        If UserListUpper.IndexOf(ExtUpperCase(S))<0 then begin UserList.Add(S); UserListUpper.Add(ExtUpperCase(S)); end;
      end;
    finally
      St2.Free;
    end;
  end;
end;

Procedure ExportGamesListHTMLFile(const GameDB : TGameDB; const Columns : TGamesListExportColumns; const St : TStringList);
Var I,J,K : Integer;
    L : TList;
    UserList, UserListUpper, St2 : TStringList;
    S,T : String;
    ColumnNames : TStringList;
begin
  ColumnNames:=GetGamesListExportLanguageColumns;
  GetUserLists(GameDB,UserList,UserListUpper);
  try
    St.Add('<!DOCTYPE HTML PUBLIC "-/'+'/W3C/'+'/DTD HTML 4.01 Transitional/'+'/EN">');
    St.Add('<html>');
    St.Add('  <head>');
    St.Add('    <title>D-Fend Reloaded</title>');
    St.Add('    <meta http-equiv="content-type" content="text/html; charset='+LanguageSetup.CharsetHTMLCharset+'">');
    St.Add('    <meta name="description" content="D-Fend Reloaded games list">');
    St.Add('    <meta name="DC.creator" content="D-Fend Reloaded '+GetNormalFileVersionAsString+'">');
    St.Add('    <style type="text/css">');
    St.Add('    <!--');
    St.Add('      body {font-family: Arial, Helvetica, sans-serif;}');
    St.Add('      table {border-collapse: collapse;}');
    St.Add('      td,th {border: solid 1px black; padding: 2px 4px 2px 4px;}');
    St.Add('    -->');
    St.Add('    </style>');
    St.Add('  </head>');
    St.Add('  <body>');
    St.Add('    <h1>'+EncodeHTMLSymbols(LanguageSetup.MenuFileExportGamesListHTMLTitle)+'</h1>');
    St.Add('    <table>');
    St.Add('      <tr>');
    For I:=0 to ColumnNames.Count-1 do If (I=0) or (TGamesListExportColumn(I) in Columns) then St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(ColumnNames[I])]));
    If glecUserFields in Columns then For I:=0 to UserList.Count-1 do St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(UserList[I])]));
    If glecNotes in Columns then St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameNotes)]));
    St.Add('      </tr>');

    L:=GameDB.GetSortedGamesList;
    try
      For I:=0 to L.Count-1 do begin
        St.Add('      <tr>');
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(TGame(L[I]).CacheName)]));

        For J:=1 to ColumnNames.Count-1 do If TGamesListExportColumn(J) in Columns then
          St.Add(Format('        <td>%s</td>',[GetGamesListExportColumnValue(TGame(L[I]),TGamesListExportColumn(J),True)]));

        If glecUserFields in Columns then begin
          St2:=StringToStringList(TGame(L[I]).CacheUserInfo);
          try
            For J:=0 to UserList.Count-1 do begin
              S:='';
              For K:=0 to St2.Count-1 do If Pos('=',St2[K])>0 then begin
                If Trim(ExtUpperCase(Copy(St2[K],1,Pos('=',St2[K])-1)))=UserListUpper[J] then begin
                  S:=Trim(Copy(St2[K],Pos('=',St2[K])+1,MaxInt)); break;
                end;
              end;
              St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(S)]));
            end;
          finally
            St2.Free;
          end;
        end;

        If glecNotes in Columns then begin
          T:='        <td>';
          St2:=StringToStringList(TGame(L[I]).Notes);
          try
            For J:=0 to St2.Count-1 do begin
              If J>0 then T:=T+'<br>';
              T:=T+EncodeHTMLSymbols(St2[J]);
            end;
          finally
            St2.Free;
          end;
          St.Add(T+'</td>');
        end;

        St.Add('      </tr>');
      end;
    finally
      L.Free;
    end;
    St.Add('    </table>');
    St.Add('  </body>');
    St.Add('</html>');
  finally
    UserList.Free;
    UserListUpper.Free;
    ColumnNames.Free;
  end;
end;

Procedure ExportGamesListXMLFile(const GameDB : TGameDB; const Columns : TGamesListExportColumns; const St : TStringList);
Var I,J,K : Integer;
    L : TList;
    UserList, UserListUpper, St2 : TStringList;
    S,T : String;
    ColumnNames : TStringList;
    Year, Month, Day : Word;
begin
  ColumnNames:=GetGamesListExportXMLColumns;
  GetUserLists(GameDB,UserList,UserListUpper);
  try
    St.Add('<?xml version="1.0" encoding="'+LanguageSetup.CharsetHTMLCharset+'" standalone="no"?>');
    St.Add('<!DOCTYPE GamesList SYSTEM "http:/'+'/dfendreloaded.sourceforge.net/GamesListExport/GamesListExport.dtd">');
    St.Add('');
    DecodeDate(Date,Year,Month,Day);
    St.Add('<GamesList DFRVersion="'+GetNormalFileVersionAsString+'" ExportDate="'+Format('%d-%.2d-%.2d',[Year,Month,Day])+'">');
    L:=GameDB.GetSortedGamesList;
    try
      For I:=0 to L.Count-1 do begin
        St.Add('');
        St.Add('  <Game>');

        St.Add(Format('    <Name>%s</Name>',[EncodeHTMLSymbols(TGame(L[I]).CacheName)]));

        For J:=1 to ColumnNames.Count-1 do If TGamesListExportColumn(J) in Columns then begin
          S:=GetGamesListExportColumnValue(TGame(L[I]),TGamesListExportColumn(J),False);
          If TGamesListExportColumn(J)<>glecWWW then S:=EncodeHTMLSymbols(S);
          If Trim(S)<>'' then St.Add(Format('    <%s>%s</%s>',[ColumnNames[J],S,ColumnNames[J]]));
        end;

        If glecUserFields in Columns then begin
          St2:=StringToStringList(TGame(L[I]).CacheUserInfo);
          try
            For J:=0 to UserList.Count-1 do begin
              S:='';
              For K:=0 to St2.Count-1 do If Pos('=',St2[K])>0 then begin
                If Trim(ExtUpperCase(Copy(St2[K],1,Pos('=',St2[K])-1)))=UserListUpper[J] then begin
                  S:=Trim(Copy(St2[K],Pos('=',St2[K])+1,MaxInt)); break;
                end;
              end;
              S:=EncodeHTMLSymbols(S);
              if Trim(S)<>'' then begin
                St.Add('    <UserData>');
                St.Add(Format('      <Name>%s</Name>',[EncodeHTMLSymbols(UserList[J])]));
                St.Add(Format('      <Value>%s</Value>',[S]));
                St.Add('    </UserData>');
              end;
            end;
          finally
            St2.Free;
          end;
        end;

        If glecNotes in Columns then begin
          T:='';
          St2:=StringToStringList(TGame(L[I]).Notes);
          try
            For J:=0 to St2.Count-1 do T:=T+EncodeHTMLSymbols(St2[J])+#13;
          finally
            St2.Free;
          end;
          If T<>'' then St.Add('    <Notes>'+#13+'    <![CDATA['+#13+T+'    ]]>'+#13+'    </Notes>');
        end;

        St.Add('  </Game>');
      end;

      If L.Count>0 then St.Add('');
    finally
      L.Free;
    end;
    St.Add('</GamesList>');
  finally
    UserList.Free;
    UserListUpper.Free;
    ColumnNames.Free;
  end;
end;

Procedure ExportGamesList(const GameDB : TGameDB; const FileName : String; const Columns : TGamesListExportColumns; const Format : TGamesListExportFormat);
Var S : String;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    If Format=glefAuto then begin
      S:=ExtUpperCase(Trim(ExtractFileExt(FileName)));
      If S='.CSV' then ExportGamesListTableFile(GameDB,Columns,St);
      If (S='.HTML') or (S='.HTM') then ExportGamesListHTMLFile(GameDB,Columns,St);
      If S='.XML' then ExportGamesListXMLFile(GameDB,Columns,St);
      If St.Count=0 then ExportGamesListTextFile(GameDB,Columns,St);
    end;
    If Format=glefText then ExportGamesListTextFile(GameDB,Columns,St);
    If Format=glefTable then ExportGamesListTableFile(GameDB,Columns,St);
    If Format=glefHTML then ExportGamesListHTMLFile(GameDB,Columns,St);
    If Format=glefXML then ExportGamesListXMLFile(GameDB,Columns,St);
    try
      St.SaveToFile(FileName);
    except
      MessageDlg(LanguageSetup.MessageCouldNotSaveFile,mtError,[mbOK],0);
    end;
  finally
    St.Free;
  end;
end;

Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList);
Var DefaultGame : TGame;
    L,L2 : TList;
begin
  DefaultGame:=TGame.Create(PrgSetup);
  L:=TList.Create;
  L2:=TList.Create;
  try
    L.Add(DefaultGame);
    L2.Add(Pointer(1));
    If PrgSetup.DFendStyleProfileEditor then begin
      EditGameTemplate(AOwner,GameDB,DefaultGame,nil,ASearchLinkFile,ADeleteOnExit,L,L2);
    end else begin
      ModernEditGameTemplate(AOwner,GameDB,DefaultGame,nil,ASearchLinkFile,ADeleteOnExit,L,L2);
    end;
  finally
    DefaultGame.Free;
    L.Free;
    L2.Free;
  end;
end;

Function GetAllConfFiles(const Dir : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=TStringList.Create;

  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.conf',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then result.Add(ExtUpperCase(Rec.Name));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function NeedUpdate(const ProfFile, ConfFile : String) : Boolean;
Var D1,D2 : TDateTime;
begin
  If not FileExists(ConfFile) then begin result:=True; exit; end;
  D1:=GetFileDate(ProfFile); D2:=GetFileDate(ConfFile);
  result:=(D1<0.001) or (D2<0.001) or (D2<D1-5/86400);
end;

Procedure CreateConfFilesForProfiles(const GameDB : TGameDB; const Dir : String);
Var St,St2 : TStringList;
    S,T : String;
    I,J : Integer;
begin
  St:=GetAllConfFiles(Dir);
  try
    For I:=0 to GameDB.Count-1 do begin
      If not DOSBoxMode(GameDB[I]) then continue;
      S:=GameDB[I].SetupFile; T:=ChangeFileExt(S,'.conf');
      If NeedUpdate(S,T) then begin
        St2:=BuildConfFile(GameDB[I],False,False,-1,nil,false);
        try St2.SaveToFile(T); finally St2.Free; end;
      end;
      J:=St.IndexOf(ExtUpperCase(ExtractFileName(T))); If J>=0 then St.Delete(J);
    end;

    S:=IncludeTrailingPathDelimiter(Dir);
    For I:=0 to St.Count-1 do DeleteFile(S+St[I]);
  finally
    St.Free;
  end;
end;

Function StrToBool(S : String) : Boolean;
begin
  S:=Trim(ExtUpperCase(S));
  result:=(S='TRUE') or (S='T') or (S='1');
end;

Procedure AddDrive(const Game : TGame; const RealFolder, Letter, FreeSpace : String);
Var S : String;
begin
  {RealFolder;DRIVE;Letter;False;;FreeSpace}
  S:=MakeRelPath(RealFolder,PrgSetup.BaseDir,True)+';Drive;'+Letter+';;'+FreeSpace;

  Game.Mount[Game.NrOfMounts]:=S;
  Game.NrOfMounts:=Game.NrOfMounts+1;
end;

Procedure AddCDImageDrive(const Game : TGame; const RealFolder, Letter : String);
Var S : String;
begin
  {ImageFile;CDROMIMAGE;Letter;;;}
  S:=MakeRelPath(RealFolder,PrgSetup.BaseDir,True)+';CDRomImage;'+Letter+';;';

  Game.Mount[Game.NrOfMounts]:=S;
  Game.NrOfMounts:=Game.NrOfMounts+1;
end;


Function GetFolderAndDriveLetter(var Params, Letter, Folder : String) : Boolean;
Var J,K : Integer;
begin
  result:=False;

  J:=Pos(' ',Params); If J=0 then exit;
  Letter:=Trim(Copy(Params,1,J-1)); Params:=Trim(Copy(Params,J+1,MaxInt));

  If length(Letter)=3 then begin If (Letter[2]<>':') or (Letter[3]<>'\') then exit; Letter:=Letter[1]; end;
  If length(Letter)=2 then begin If Letter[2]<>':' then exit; Letter:=Letter[1]; end;
  Letter:=ExtUpperCase(Letter);
  If (Letter<'A') or (Letter>'Z') then exit;

  If Params[1]='"' then begin
    Params:=Trim(Copy(Params,2,MaxInt));
    K:=-1;
    For J:=1 to length(Params) do If Params[J]='"' then begin K:=J; break; end;
    If K=-1 then begin Folder:=''; Params:='"'+Params; end else begin Folder:=Trim(Copy(Params,1,K-1)); Params:=Trim(Copy(Params,K+1,MaxInt)); end;
  end else begin
    J:=Pos(' ',Params); If J>0 then begin Folder:=Trim(Copy(Params,1,J-1)); Params:=Trim(Copy(Params,J+1,MaxInt)); end else begin Folder:=Params; Params:=''; end;
  end;
  
  result:=True;
end;

Procedure MakeMountsFromAutoexec(const Game : TGame; const Autoexec : TStringList);
Var I : Integer;
    S,SUpper,Letter,Folder : String;
begin
  I:=0;
  while I<Autoexec.Count do begin
    If Game.NrOfMounts=10 then exit;

    S:=Trim(Autoexec[I]);
    If (S<>'') and (S[1]='@') then S:=Trim(Copy(S,2,MaxInt));
    SUpper:=ExtUpperCase(S);
    If (S='') or (Copy(SUpper,1,4)='ECHO') or (Copy(SUpper,1,3)='REM') or (Copy(SUpper,1,4)='SET ') or (Copy(SUpper,1,5)='KEYB ') then begin inc(I); continue; end;

    If Copy(SUpper,1,6)='MOUNT ' then begin
      S:=Trim(Copy(S,7,MaxInt));
      if not GetFolderAndDriveLetter(S,Letter,Folder) then begin inc(I); continue; end;
      If Trim(ExtUpperCase(Copy(S,1,9)))='-FREESIZE' then S:=Trim(Copy(S,10,MaxInt)) else S:='';
      AddDrive(Game,Folder,Letter,S);
      Autoexec.Delete(I);
      continue;
    end;

    If Copy(SUpper,1,9)='IMGMOUNT ' then begin
      S:=Trim(Copy(S,10,MaxInt));
      if not GetFolderAndDriveLetter(S,Letter,Folder) then begin inc(I); continue; end;
      S:=Trim(ExtUpperCase(S));
      if (S<>'-T ISO -FS ISO') and (S<>'-FS ISO -T ISO') then begin inc(I); continue; end;
      AddCDImageDrive(Game,Folder,Letter);
      Autoexec.Delete(I);
      continue;
    end;

    inc(I);
  end;
end;

Procedure LoadSpecialData(const Game : TGame; const FileName : String);
Var St,Autoexec : TStringList;
    I : Integer;
    Sec : Integer;
    S,T,U : String;
begin
  St:=TStringList.Create;
  Autoexec:=TStringList.Create;
  try
    St.LoadFromFile(FileName);
    Sec:=-1;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If (S<>'') and (S[1]='[') and (Pos(']',S)>0) then begin
        S:=Trim(Copy(S,2,Pos(']',S)-2));
        If S='GENERAL' then Sec:=0 else begin
          If S='AUTOEXEC' then Sec:=1 else Sec:=-1;
        end;
        continue;
      end;

      If Sec=0 then begin
        S:=Trim(ExtUpperCase(St[I]));
        If (S='') or (S[1]<>'#') or (Pos('=',S)=0) then continue;
        S:=Trim(Copy(Trim(St[I]),2,MaxInt));
        T:=Trim(ExtUpperCase(Copy(S,1,Pos('=',S)-1)));
        U:=Trim(Copy(S,Pos('=',S)+1,MaxInt));

        If T='SNAPSHOTIMAGE' then Game.CaptureFolder:=U;
        If T='EXIT' then Game.CloseDosBoxAfterGameExit:=StrToBool(U);
        If T='MANUALFILE' then Game.DataDir:=ExtractFilePath(U);
        If T='WWWSITE' then Game.WWW[1]:=U;
      end;

      If Sec=1 then begin
        T:=ExtUpperCase(St[I]);
        if T='EXIT' then begin Game.CloseDosBoxAfterGameExit:=true; continue; end;
        if Copy(Trim(T),1,1)='#' then continue;
        Autoexec.Add(St[I]);
      end;
    end;

    MakeMountsFromAutoexec(Game,Autoexec);

    while (Autoexec.Count>0) and (Trim(Autoexec[0])='') do Autoexec.Delete(0);

    Game.Autoexec:=StringListToString(Autoexec);
  finally
    St.Free;
    Autoexec.Free;
  end;
end;

Procedure ImportConfData(const AGameDB : TGameDB; const AGame : TGame; const Lines : String);
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    St.Text:=Lines;
    ImportConfData(AGameDB,AGame,St);
  finally
    St.Free;
  end;
end;

Procedure ImportConfData(const AGameDB : TGameDB; const AGame : TGame; const St : TStringList);
Var FileName : String;
begin
  FileName:=TempDir+'DFRTempConfFile.conf';
  St.SaveToFile(FileName);
  try
    ImportConfFileData(AGameDB,AGame,FileName);
  finally
    ExtDeleteFile(FileName,ftProfile);
  end;
end;

Procedure ImportConfFileData(const AGameDB : TGameDB; const AGame : TGame; const AFileName : String);
Var INI : TINIFile;
    B : Boolean;
    I : Integer;
    S : String;
    St : TStringList;
begin
  INI:=TIniFile.Create(AFileName);
  try
    AGame.StartFullscreen:=StrToBool(INI.ReadString('sdl','fullscreen','false'));
    AGame.UseDoublebuffering:=StrToBool(INI.ReadString('sdl','fulldouble','false'));
    AGame.Render:=Ini.ReadString('sdl','output','surface');
    AGame.FullscreenResolution:=Ini.ReadString('sdl','fullresolution','original');
    AGame.WindowResolution:=Ini.ReadString('sdl','windowresolution','original');
    AGame.AutoLockMouse:=StrToBool(INI.ReadString('sdl','autolock','true'));
    AGame.MouseSensitivity:=INI.ReadInteger('sdl','sensitivity',100);
    AGame.Priority:=Ini.ReadString('sdl','priority','higher,normal');
    AGame.UseScanCodes:=StrToBool(INI.ReadString('sdl','usescancodes','true'));
    AGame.CustomKeyMappingFile:=INI.ReadString('sdl','mapperfile','');
    If Trim(AGame.CustomKeyMappingFile)<>'' then AGame.CustomKeyMappingFile:=MakeRelPath(AGame.CustomKeyMappingFile,PrgSetup.BaseDir);

    AGame.VideoCard:=Ini.ReadString('dosbox','machine','vga');
    AGame.Memory:=INI.ReadInteger('dosbox','memsize',16);
    AGame.CaptureFolder:=MakeRelPath(INI.ReadString('dosbox','captures',IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)),PrgSetup.BaseDir,True);

    AGame.FrameSkip:=INI.ReadInteger('render','frameskip',0);
    AGame.AspectCorrection:=StrToBool(INI.ReadString('render','aspect','false'));
    AGame.Scale:=INI.ReadString('render','scaler','normal2x');

    AGame.Core:=INI.ReadString('cpu','core','auto');
    AGame.Cycles:=INI.ReadString('cpu','cycles','auto');

    B:=TryStrToInt(AGame.Cycles,I);
    If not B then begin
      S:=Trim(ExtUpperCase(AGame.Cycles));
      St:=ValueToList(AGameDB.ConfOpt.Cycles,';,');
      try
        For I:=0 to St.Count-1 do If Trim(ExtUpperCase(St[I]))=S then begin B:=True; break; end;
      finally
        St.Free;
      end;
    end;
    If not B then AGame.Cycles:='auto';

    AGame.CyclesUp:=INI.ReadInteger('cpu','cycleup',500);
    AGame.CyclesDown:=INI.ReadInteger('cpu','cycledown',20);

    AGame.EMS:=StrToBool(INI.ReadString('dos','ems','true'));
    AGame.XMS:=StrToBool(INI.ReadString('dos','xms','true'));
    AGame.UMB:=StrToBool(INI.ReadString('dos','umb','true'));
    AGame.KeyboardLayout:=INI.ReadString('dos','keyboardlayout','none');
    If ExtUpperCase(AGame.KeyboardLayout)='AUTO' then AGame.KeyboardLayout:='default';

    AGame.MixerNosound:=StrToBool(INI.ReadString('mixer','nosound','false'));
    AGame.MixerRate:=Ini.ReadInteger('mixer','rate',22050);
    AGame.MixerBlocksize:=Ini.ReadInteger('mixer','blocksize',2048);
    AGame.MixerPrebuffer:=Ini.ReadInteger('mixer','prebuffer',10);

    AGame.SBType:=Ini.ReadString('sblaster','sbtype','sb16');
    AGame.SBBase:=Ini.ReadString('sblaster','sbbase','220');
    AGame.SBIRQ:=Ini.ReadInteger('sblaster','irq',7);
    AGame.SBDMA:=Ini.ReadInteger('sblaster','dma',1);
    AGame.SBHDMA:=Ini.ReadInteger('sblaster','hdma',5);
    AGame.SBMixer:=StrToBool(INI.ReadString('mixer','mixer','true'));
    AGame.SBOplMode:=Ini.ReadString('sblaster','oplmode','auto');
    AGame.SBOplRate:=Ini.ReadInteger('sblaster','oplrate',22050);

    AGame.GUS:=StrToBool(INI.ReadString('gus','gus','true'));
    AGame.GUSRate:=Ini.ReadInteger('gus','gusrate',22050);
    AGame.GUSBase:=Ini.ReadString('gus','gusbase','240');
    AGame.GUSIRQ:=Ini.ReadInteger('gus','irg1',5);
    AGame.GUSDMA:=Ini.ReadInteger('gus','dma1',3);
    AGame.GUSUltraDir:=Ini.ReadString('gus','ultradir','C:\ULTRASND');

    AGame.MIDIType:=Ini.ReadString('midi','mpu401','intelligent');
    AGame.MIDIDevice:=Ini.ReadString('midi','device','default');
    AGame.MIDIConfig:=Ini.ReadString('midi','config','');

    AGame.SpeakerPC:=StrToBool(INI.ReadString('speaker','pcspeaker','true'));
    AGame.SpeakerRate:=Ini.ReadInteger('speaker','pcrate',22050);
    AGame.SpeakerTandy:=Ini.ReadString('speaker','tandy','auto');
    AGame.SpeakerRate:=Ini.ReadInteger('speaker','tandyrate',22050);
    AGame.SpeakerDisney:=StrToBool(INI.ReadString('speaker','disney','true'));

    AGame.JoystickType:=Ini.ReadString('joystick','joysticktype','auto');
    AGame.JoystickTimed:=StrToBool(INI.ReadString('joystick','timed','true'));
    AGame.JoystickAutoFire:=StrToBool(INI.ReadString('joystick','autofire','false'));
    AGame.JoystickSwap34:=StrToBool(INI.ReadString('joystick','swap34','false'));
    AGame.JoystickButtonwrap:=StrToBool(INI.ReadString('joystick','buttonwrap','true'));

    AGame.Serial1:=INI.ReadString('serial','serial1','dummy');
    AGame.Serial2:=INI.ReadString('serial','serial2','dummy');
    AGame.Serial3:=INI.ReadString('serial','serial3','disabled');
    AGame.Serial4:=INI.ReadString('serial','serial4','disabled');

    AGame.IPX:=StrToBool(INI.ReadString('ipx','ipx','false'));
  finally
    Ini.Free;
  end;
  LoadSpecialData(AGame,AFileName);
end;

Function ImportConfFile(const AGameDB : TGameDB; const AFileName : String) : TGame;
begin
  result:=AGameDB[AGameDB.Add(ChangeFileExt(ExtractFileName(AGameDB.ProfFileName(ExtractFileName(AFileName),True)),''))];
  ImportConfFileData(AGameDB,result,AFileName);
end;

Function GameCheckSumOK(const AGame : TGame) : Boolean;
Var S,T : String;
begin
  result:=True;
  If (AGame.GameExeMD5='') or (Trim(ExtUpperCase(AGame.GameExeMD5))='OFF') then exit;
  If AGame.GameExe='' then exit;
  T:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
  If not FileExists(T) then exit;
  S:=GetMD5Sum(T,False); If S='' then exit;
  result:=(S=AGame.GameExeMD5);
end;

Function SetupCheckSumOK(const AGame : TGame) : Boolean;
Var S,T : String;
begin
  result:=True;
  If (AGame.SetupExeMD5='') or (Trim(ExtUpperCase(AGame.SetupExeMD5))='OFF') then exit;
  If AGame.SetupExe='' then exit;
  T:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
  If not FileExists(T) then exit;
  S:=GetMD5Sum(T,False); If S='' then exit;
  result:=(S=AGame.SetupExeMD5);
end;

Procedure CreateGameCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Var S : String;
begin
  If (AGame.GameExeMD5<>'') and (not OverwriteExistingCheckSum) then exit;
  If Trim(ExtUpperCase(AGame.GameExeMD5))='OFF' then exit;
  If AGame.GameExe='' then exit;
  S:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
  if not FileExists(S) then exit;
  AGame.GameExeMD5:=GetMD5Sum(S,False);
end;

Procedure CreateSetupCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Var S : String;
begin
  If (AGame.SetupExeMD5<>'') and (not OverwriteExistingCheckSum) then exit;
  If Trim(ExtUpperCase(AGame.SetupExeMD5))='OFF' then exit;
  If AGame.SetupExe='' then exit;
  S:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
  if not FileExists(S) then exit;
  AGame.SetupExeMD5:=GetMD5Sum(S,False);
end;

Function ChecksumForGameOK(const AGame : TGame) : Boolean;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;
  result:=GameCheckSumOK(AGame);
end;

Function ChecksumForSetupOK(const AGame : TGame) : Boolean;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;
  result:=SetupCheckSumOK(AGame);
end;

Procedure ProfileEditorOpenCheck(const AGame : TGame);
Var St : TStringList;
    S : String;
begin
  If (AGame=nil) or (not PrgSetup.UseCheckSumsForProfiles) then exit;

  If not GameCheckSumOK(AGame) then begin
    St:=StringToStringList(LanguageSetup.CheckSumProfileEditorMismatch); try S:=St.Text; finally St.Free; end;
    S:=Format(S,[AGame.GameExe]);
    Case ShowCheckSumWarningDialog(Application.MainForm,S) of
      cdYes : CreateGameCheckSum(AGame,True);
      cdNo : ;
      cdTurnOff : begin AGame.GameExeMD5:='Off'; AGame.SetupExeMD5:='Off'; end;
    end;
  end;
  If not SetupCheckSumOK(AGame) then begin
    St:=StringToStringList(LanguageSetup.CheckSumProfileEditorMismatch); try S:=St.Text; finally St.Free; end;
    S:=Format(S,[AGame.SetupExe]);
    Case ShowCheckSumWarningDialog(Application.MainForm,S) of
      cdYes : CreateSetupCheckSum(AGame,True);
      cdNo : ;
      cdTurnOff : begin AGame.GameExeMD5:='Off'; AGame.SetupExeMD5:='Off'; end;
    end;
  end;
end;

Procedure ProfileEditorCloseCheck(const AGame : TGame; const NewGameExe, NewSetupExe : String);
Var NewGameFileName, NewSetupFileName : String;
    B1, B2 : Boolean;
begin
  NewGameFileName:=Trim(ExtUpperCase(ExtractFileName(NewGameExe)));
  NewSetupFileName:=Trim(ExtUpperCase(ExtractFileName(NewSetupExe)));
  B1:=Trim(ExtUpperCase(ExtractFileName(AGame.GameExe)))<>NewGameFileName;
  B2:=Trim(ExtUpperCase(ExtractFileName(AGame.SetupExe)))<>NewSetupFileName;
  AGame.GameExe:=NewGameExe;
  AGame.SetupExe:=NewSetupFileName;
  CreateGameCheckSum(AGame,B1);
  CreateSetupCheckSum(AGame,B2);
end;

Function RunCheck(const AGame : TGame; const RunSetup : Boolean; const RunExtraFile : Integer) : Boolean;
Var S,T : String;
    St : TStringList;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;

  If RunExtraFile>=0 then begin
    exit;
  end else begin
    If RunSetup then begin
      If SetupCheckSumOK(AGame) then exit;
      S:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
    end else begin
      If GameCheckSumOK(AGame) then exit;
      S:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
    end;
  end;

  St:=StringToStringList(LanguageSetup.CheckSumRunMismatch); try T:=St.Text; finally St.Free; end;
  S:=Format(T,[S]);
  Case ShowCheckSumWarningDialog(Application.MainForm,S) of
    cdYes     : begin
                  result:=True;
                  If RunSetup then CreateSetupCheckSum(AGame,True) else CreateGameCheckSum(AGame,True);
                end;
    cdNo      : result:=False;
    cdTurnOff : begin
                  result:=True;
                  AGame.GameExeMD5:='Off'; AGame.SetupExeMD5:='Off';
                end;
  end;
end;

Procedure CreateCheckSumsForAllGames(const AGameDB : TGameDB);
Var I : Integer;
begin
  InitProgressWindow(Application.MainForm,AGameDB.Count);
  try
    For I:=0 to AGameDB.Count-1 do begin
      CreateGameCheckSum(AGameDB[I],False);
      CreateSetupCheckSum(AGameDB[I],False);
      StepProgressWindow;
    end;
  finally
    DoneProgressWindow;
  end;
end;

Function CreateUniqueFolder(const GameName, ShortFolderName, BaseDir : String) : String;
Var S : String;
    I : Integer;
begin
  result:='';

  If Trim(ShortFolderName)<>'' then begin
    S:=MakeAbsPath(ShortFolderName,PrgSetup.BaseDir);
    If not DirectoryExists(S) then ForceDirectories(S);
    exit;
  end;

  S:=MakeAbsPath(IncludeTrailingPathDelimiter(BaseDir)+MakeFileSysOKFolderName(GameName)+'\',PrgSetup.BaseDir);
  I:=0;
  While DirectoryExists(S) do begin
    inc(I);
    S:=MakeRelPath(IncludeTrailingPathDelimiter(BaseDir)+MakeFileSysOKFolderName(GameName)+IntToStr(I)+'\',PrgSetup.BaseDir);
  end;
  ForceDirectories(S);
  result:=MakeRelPath(S,PrgSetup.BaseDir);  
end;

Procedure CreateFoldersForAllGames(const AGameDB : TGameDB; const FolderType : TFolderType);
Var I : Integer;
    S,T : String;
begin
  InitProgressWindow(Application.MainForm,AGameDB.Count);
  try
    If FolderType=ftCapture then T:=PrgSetup.CaptureDir else T:=PrgSetup.DataDir; 
    For I:=0 to AGameDB.Count-1 do begin
      If FolderType=ftCapture then S:=AGameDB[I].CaptureFolder else S:=AGameDB[I].DataDir;
      S:=CreateUniqueFolder(AGameDB[I].Name,S,T);
      If S<>'' then begin
        If FolderType=ftCapture then AGameDB[I].CaptureFolder:=S else AGameDB[I].DataDir:=S;
        AGameDB[I].StoreAllValues;
      end;
      StepProgressWindow;
    end;
  finally
    DoneProgressWindow;
  end;
end;

Function GetAdditionalChecksumData(const AGame : TGame; Path : String; DataNeeded : Integer; var Files, Checksums : T5StringArray) : Integer;
Var I,J : Integer;
    Exe1,Exe2,S : String;
    Rec : TSearchRec;
    OK : Boolean;
begin
  result:=0;
  Path:=IncludeTrailingPathDelimiter(Path);

  If Trim(AGame.GameExe)<>'' then Exe1:=Trim(ExtUpperCase(ExtractFileName(MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir)))) else Exe1:='';
  If Trim(AGame.SetupExe)<>'' then Exe2:=Trim(ExtUpperCase(ExtractFileName(MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir)))) else Exe2:='';

  I:=FindFirst(Path+'*.*',faAnyFile,Rec);
  try
    While (I=0) and (DataNeeded>0) do begin
      If (Rec.Attr and faDirectory)=0 then begin
        S:=ExtUpperCase(Rec.Name);
        If (S<>Exe1) and (S<>Exe2) then begin
          S:=ExtUpperCase(ExtractFileExt(Rec.Name)); If (S<>'') and (S[1]='.') then S:=Copy(S,2,MaxInt);
          OK:=False;
          For J:=Low(AdditionalChecksumDataGoodFileExt) to High(AdditionalChecksumDataGoodFileExt) do If AdditionalChecksumDataGoodFileExt[J]=S then begin OK:=True; break; end;
          If OK then For J:=Low(AdditionalChecksumDataExcludeFiles) to High(AdditionalChecksumDataExcludeFiles) do if Pos(AdditionalChecksumDataExcludeFiles[J],S)<>0 then begin Ok:=False; break; end;
          If OK then begin
            Files[result]:=Rec.Name;
            Checksums[result]:=GetMD5Sum(Path+Rec.Name,False);
            inc(result); dec(DataNeeded);
          end;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure AddAdditionalChecksumDataToAutoSetupTemplate(const AGame : TGame);
Var DataNeeded, DataAvailable,I : Integer;
    Path : String;
    Files, Checksums : T5StringArray;
begin
  If Trim(AGame.GameExe)='' then exit;

  DataNeeded:=0;
  If Trim(AGame.AddtionalChecksumFile1Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile2Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile3Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile4Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile5Checksum)='' then inc(DataNeeded);

  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir)));

  DataAvailable:=GetAdditionalChecksumData(AGame,Path,DataNeeded,Files,Checksums);

  I:=0;
  If (Trim(AGame.AddtionalChecksumFile1Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile1:=Files[I];
    AGame.AddtionalChecksumFile1Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile2Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile2:=Files[I];
    AGame.AddtionalChecksumFile2Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile3Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile3:=Files[I];
    AGame.AddtionalChecksumFile3Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile4Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile4:=Files[I];
    AGame.AddtionalChecksumFile4Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile5Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile5:=Files[I];
    AGame.AddtionalChecksumFile5Checksum:=Checksums[I];
  end;
end;

Function GetLastModificationDate(const AGame : TGame) : String;
Var I : Integer;
    S,T : String;
begin
  result:='';
  I:=Pos('-',AGame.LastModification); If I=0 then exit;
  S:=''; try S:=DateToStr(StrToInt(Copy(AGame.LastModification,1,I-1))); except exit; end;
  T:=''; try T:=TimeToStr(StrToInt(Copy(AGame.LastModification,I+1,MaxInt))/86400); except exit; end;
  result:=S+' '+T;
end;

Function DOSBoxMode(const Game : TGame) : Boolean;
Var S : String;
begin
  result:=False;
  If Game=nil then exit;
  S:=Trim(ExtUpperCase(Game.ProfileMode));
  result:=(S<>'SCUMMVM') and (S<>'WINDOWS');
end;

Function ScummVMMode(const Game : TGame) : Boolean;
begin
  result:=False;
  If Game=nil then exit;
  result:=(Trim(ExtUpperCase(Game.ProfileMode))='SCUMMVM');
end;

Function WindowsExeMode(const Game : TGame) : Boolean;
begin
  result:=False;
  If Game=nil then exit;
  result:=(Trim(ExtUpperCase(Game.ProfileMode))='WINDOWS');
end;

Function CheckGameDB(const GameDB : TGameDB) : TStringList;
Var I,J : Integer;
    Game : TGame;
    S : String;
    FirstError : Boolean;
    St : TStringList;
Procedure Error(const S : String); begin if FirstError then begin FirstError:=False; If result.Count>0 then result.Add(''); result.Add(Game.Name); end; result.Add('  '+S); end;
begin
  result:=TStringList.Create;

  InitProgressWindow(Application.MainForm,GameDB.Count);

  try
    For I:=0 to GameDB.Count-1 do begin
      Game:=GameDB[I];
      FirstError:=True;

      If ScummVMMode(Game) then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(Trim(Game.ScummVMPath),PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesGameDirectory,[S]));
      end else begin
        If WindowsExeMode(Game) then begin
          S:=Trim(Game.GameExe);
          If S<>'' then begin
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesGameFile,[S])) else begin
              If not ChecksumForGameOK(Game) then Error(Format(LanguageSetup.MissingFilesGameChecksum,[S]));
            end;
          end;
          S:=Trim(Game.SetupExe);
          If S<>'' then begin
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesSetupFile,[S])) else begin
              If not ChecksumForSetupOK(Game) then Error(Format(LanguageSetup.MissingFilesSetupChecksum,[S]));
            end;
          end;
        end else begin
          S:=Trim(Game.GameExe);
          If (S<>'') and (ExtUpperCase(Copy(S,1,7))<>'DOSBOX:') then begin
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesGameFile,[S])) else begin
              If not ChecksumForGameOK(Game) then Error(Format(LanguageSetup.MissingFilesGameChecksum,[S]));
            end;
          end;
          S:=Trim(Game.SetupExe);
          If (S<>'') and (ExtUpperCase(Copy(S,1,7))='DOSBOX:') then begin
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesSetupFile,[S])) else begin
              If not ChecksumForSetupOK(Game) then Error(Format(LanguageSetup.MissingFilesSetupChecksum,[S]));
            end;
          end;
        end;
      end;

      S:=Trim(Game.CaptureFolder);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(S,PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesCaptureFolder,[S]));
      end;

      S:=MakeAbsIconName(Game.Icon);
      If S<>'' then begin
        If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesIconFile,[S]));
      end;

      S:=Trim(Game.DataDir);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(S,PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesDataDirectory,[S]));
      end;

      S:=Trim(Game.ExtraFiles);
      If S<>'' then begin
        St:=ValueToList(S);
        try
          For J:=0 to St.Count-1 do If Trim(St[J])<>'' then begin
            S:=MakeAbsPath(St[J],PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesExtraFile,[S]));
          end;
        finally
          St.Free;
        end;
      end;

      S:=Trim(Game.ExtraDirs);
      If S<>'' then begin
        St:=ValueToList(S);
        try
          For J:=0 to St.Count-1 do If Trim(St[J])<>'' then begin
            S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(St[J]),PrgSetup.BaseDir));
            If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesExtraDirectory,[S]));
          end;
        finally
          St.Free;
        end;
      end;

      StepProgressWindow;
    end;
  finally
    DoneProgressWindow;
  end;
end;

Function ExtendedChecksumCompare(const A1,A2 : TGame) : Boolean;
Var St1, St1c, St2, St2c : TStringList;
    I,J : Integer;
begin
  result:=False;

  St1:=TStringList.Create;
  St1c:=TStringList.Create;
  St2:=TStringList.Create;
  St2c:=TStringList.Create;
  try
    If A1.AddtionalChecksumFile1<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile1)); St1c.Add(A1.AddtionalChecksumFile1Checksum); end;
    If A1.AddtionalChecksumFile2<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile2)); St1c.Add(A1.AddtionalChecksumFile2Checksum); end;
    If A1.AddtionalChecksumFile3<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile3)); St1c.Add(A1.AddtionalChecksumFile3Checksum); end;
    If A1.AddtionalChecksumFile4<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile4)); St1c.Add(A1.AddtionalChecksumFile4Checksum); end;
    If A1.AddtionalChecksumFile5<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile5)); St1c.Add(A1.AddtionalChecksumFile5Checksum); end;
    If A2.AddtionalChecksumFile1<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile1)); St2c.Add(A2.AddtionalChecksumFile1Checksum); end;
    If A2.AddtionalChecksumFile2<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile2)); St2c.Add(A2.AddtionalChecksumFile2Checksum); end;
    If A2.AddtionalChecksumFile3<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile3)); St2c.Add(A2.AddtionalChecksumFile3Checksum); end;
    If A2.AddtionalChecksumFile4<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile4)); St2c.Add(A2.AddtionalChecksumFile4Checksum); end;
    If A2.AddtionalChecksumFile5<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile5)); St2c.Add(A2.AddtionalChecksumFile5Checksum); end;

    For I:=0 to St1.Count-1 do begin
      J:=St2.IndexOf(St1[I]);
      If (J>=0) and (St1c[I]<>St2c[J]) then begin result:=True; exit; end;
    end;

  finally
    St1.Free;
    St1c.Free;
    St2.Free;
    St2c.Free;
  end;
end;

Function CheckDoubleChecksums(const AutoSetupDB : TGameDB) : TStringList;
Var I,J : Integer;
    Names, Sums : TStringList;
    S : String;
begin
  result:=TStringList.Create;

  Names:=TStringList.Create;
  Sums:=TStringList.Create;
  try
    For I:=0 to AutoSetupDB.Count-1 do begin

      S:=Trim(ExtUpperCase(AutoSetupDB[I].GameExe));
      If Trim(S)='' then continue;
      J:=Names.IndexOf(S);
      If J<0 then begin
        Names.AddObject(S,TObject(I));
        Sums.Add(AutoSetupDB[I].GameExeMD5);
      end else begin
        If (Sums[J]=AutoSetupDB[I].GameExeMD5) and (not ExtendedChecksumCompare(AutoSetupDB[Integer(Names.Objects[J])],AutoSetupDB[I])) then
          result.Add(AutoSetupDB[Integer(Names.Objects[J])].CacheName+' <-> '+AutoSetupDB[I].CacheName);
      end;
    end;
  finally
    Names.Free;
    Sums.Free;
  end;
end;

Function GetDOSBoxNr(const Game : TGame) : Integer;
Var I : Integer;
    S : String;
begin
  result:=-1;
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxDir));
  If (S='DEFAULT') or (S='') then begin result:=0; exit; end;

  For I:=1 to PrgSetup.DOSBoxSettingsCount-1 do If Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[I].Name))=S then begin result:=I; break; end;
end;

Procedure OpenConfigurationFile(const Game : TGame; const DeleteOnExit : TStringList);
Var S,T : String;
    St : TStringList;
begin
  If WindowsExeMode(Game) then exit;
  If ScummVMMode(Game) then begin
    S:=TempDir+ChangeFileExt(ExtractFileName(Game.SetupFile),'.ini');
    T:='ScummVM';
    St:=BuildScummVMIniFile(Game);
  end else begin
    S:=TempDir+ChangeFileExt(ExtractFileName(Game.SetupFile),'.conf');
    T:='DOSBox';
    St:=BuildConfFile(Game,False,False,-1,nil,false);
    If St=nil then exit;
  end;
    try
      St.Insert(0,'# This '+T+' configuration file was automatically created by D-Fend Reloaded.');
      St.Insert(1,'# Changes made to this file will NOT be transfered to D-Rend Reloaded profiles list.');
      St.Insert(2,'# D-Fend Reloaded will delete this file from temp directory on program close.');
      St.Insert(3,'');
      St.Insert(4,'# Command line used when starting '+T+':');

      If ScummVMMode(Game) then begin
        T:=Trim(PrgSetup.ScummVMAdditionalCommandLine);
        If Trim(Game.ScummVMParameters)<>'' then begin
          If T<>'' then T:=T+' ';
          T:=T+Trim(Game.ScummVMParameters);
        end;
        T:=GetScummVMCommandLine(S,Game.ScummVMGame,T,Game.ScummVMRenderMode,Game.ScummVMPlatform);
      end else begin
        T:=GetDOSBoxCommandLine(GetDOSBoxNr(Game),S,Game.ShowConsoleWindow,'');
      end;

      St.Insert(5,'# '+T);
      St.Insert(6,'');
      St.Insert(7,'# Config file for profile "'+Game.Name+'"');
      St.Insert(8,'');

      St.SaveToFile(S);
    finally
      St.Free;
    end;
  OpenFileInEditor(S);
  If DeleteOnExit.IndexOf(S)<0 then DeleteOnExit.Add(S);
end;

Function SelectProgramFile(var FileName : String; const HintFirstFile, HintSecondFile : String; const WindowsMode : Boolean; const OtherEmulator : Integer; const Owner : TComponent) : Boolean;
Var S,S1,S2,S3,T,U : String;
    OpenDialog : TOpenDialog;
    St,St2 : TStringList;
    I,J : Integer;
begin
  result:=False;
  OpenDialog:=TOpenDialog.Create(Owner);
  try
    {Filter, DefaultExt and Title}
    If WindowsMode and (OtherEmulator>=0) then begin
      OpenDialog.Title:=LanguageSetup.MenuProfileAddOtherSelectTitle;
      OpenDialog.DefaultExt:='';
      If (PrgSetup.WindowsBasedEmulatorsNames.Count<=OtherEmulator) or (PrgSetup.WindowsBasedEmulatorsPrograms.Count<=OtherEmulator) or (PrgSetup.WindowsBasedEmulatorsParameters.Count<=OtherEmulator) or  (PrgSetup.WindowsBasedEmulatorsExtensions.Count<=OtherEmulator) then exit;
      S:=Trim(PrgSetup.WindowsBasedEmulatorsExtensions[OtherEmulator]);
      While S<>'' do begin
       I:=Pos(';',S);
       If T<>'' then T:=T+', ';
       If U<>'' then U:=U+';';
       If I=0 then begin
         If OpenDialog.DefaultExt='' then OpenDialog.DefaultExt:=Trim(S);
         T:=T+'*.'+Trim(S);
         U:=U+'*.'+Trim(S);
         S:='';
       end else begin
         If OpenDialog.DefaultExt='' then OpenDialog.DefaultExt:=Trim(Copy(S,1,I-1));
         T:=T+'*.'+Trim(Copy(S,1,I-1));
         U:=U+'*.'+Trim(Copy(S,1,I-1));
         S:=Trim(Copy(S,I+1,MaxInt));
       end;
      end;
      OpenDialog.Filter:=Format(LanguageSetup.MenuProfileAddOtherSelectFilter,[PrgSetup.WindowsBasedEmulatorsNames[OtherEmulator],T,U]);
    end else begin
      OpenDialog.DefaultExt:='exe';
      OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
      If (Trim(PrgSetup.QBasic)<>'') and FileExists(Trim(PrgSetup.QBasic)) and (not WindowsMode) then S:=LanguageSetup.ProfileEditorEXEFilterWithBasic else S:=LanguageSetup.ProfileEditorEXEFilter;
      S1:=''; S2:=''; S3:='';
      If not WindowsMode then begin
        St:=TStringList.Create;
        try
          For I:=0 to Min(PrgSetup.DOSBoxBasedUserInterpretersPrograms.Count,PrgSetup.DOSBoxBasedUserInterpretersExtensions.Count)-1 do begin
            St2:=ValueToList(PrgSetup.DOSBoxBasedUserInterpretersExtensions[I]);
            try
              T:=''; U:='';
              For J:=0 to St2.Count-1 do begin
                If St.IndexOf(ExtUpperCase(St2[J]))<0 then begin
                  St2.Add(ExtUpperCase(St2[J]));
                  S1:=S1+', *.'+ExtLowerCase(St2[J]);
                  S2:=S2+';*.'+ExtLowerCase(St2[J]);
                end;
                If T='' then T:='*.'+ExtLowerCase(St2[J]) else T:=T+', *.'+ExtLowerCase(St2[J]);
                If U='' then U:='*.'+ExtLowerCase(St2[J]) else U:=U+';*.'+ExtLowerCase(St2[J]);
              end;
              S3:=S3+'|'+ChangeFileExt(ExtractFileName(PrgSetup.DOSBoxBasedUserInterpretersPrograms[I]),'')+' ('+T+')|'+U;
            finally
              St2.Free;
            end;
          end;
        finally
          St.Free;
        end;
      end;
      OpenDialog.Filter:=Format(S,[S1,S2,S3]);
    end;

    {InitialDir}
    S:='';
    If FileName<>'' then begin S:=ExtractFilePath(MakeAbsPath(FileName,PrgSetup.BaseDir)); end;
    If (S='') and (Trim(HintFirstFile)<>'') then S:=ExtractFilePath(MakeAbsPath(HintFirstFile,PrgSetup.BaseDir));
    If (S='') and (Trim(HintSecondFile)<>'') then S:=ExtractFilePath(MakeAbsPath(HintSecondFile,PrgSetup.BaseDir));
    If (S='') and WindowsMode then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
    If S='' then S:=PrgSetup.GameDir;
    If S='' then S:=PrgSetup.BaseDir;
    OpenDialog.InitialDir:=S;

    {Run}
    if not OpenDialog.Execute then exit;

    S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
    If S='' then exit;
    FileName:=S;
    result:=True;
  finally
    OpenDialog.Free;
  end;
end;

function NextFreeDriveLetter(const Mounting : TStringList): Char;
Var I : Integer;
    B : Boolean;
    St : TStringList;
begin
  result:='C';
  repeat
    B:=True;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        If St.Count<3 then continue;
        if UpperCase(St[2])=result then begin inc(result); B:=False; break; end;
      finally
        St.Free;
      end;
    end;
  until B;
end;

function CanReachFile(const Mounting : TStringList; const FileName: String): Boolean;
Var S,FilePath : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;
  FilePath:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(ExtractFilePath(FileName),PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      {Types to check:
       RealFolder;DRIVE;Letter;False;;FreeSpace
       RealFolder;FLOPPY;Letter;False;;
       RealFolder;CDROM;Letter;IO;Label;
       all other are images}
      If St.Count<2 then continue;
      S:=Trim(ExtUpperCase(St[1]));
      If (S<>'DRIVE') and (S<>'FLOPPY') and (S<>'CDROM') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));

      result:=(Copy(FilePath,1,length(S))=S);
      if result then exit;
    finally
      St.Free;
    end;
  end;
end;

Procedure AddPrgDir(const Mounting : TStringList; const ProgrammFileDir : String);
begin
  if CanReachFile(Mounting,ProgrammFileDir) then exit;
  If Mounting.Count=10 then Mounting.Delete(9);
  Mounting.Add(MakeRelPath(ProgrammFileDir,PrgSetup.BaseDir)+';Drive;'+NextFreeDriveLetter(Mounting)+';false;');
end;

Function BuildGameDirMountData(const Template : TGame; const ProgrammFileDir, SetupFileDir : String) : TStringList;
Var G : TGame;
    I : Integer;
    St : TStringList;
    S,T : String;
    B : Boolean;
begin
  result:=TStringList.Create;

  {Load from template}
  If Template=nil then G:=TGame.Create(PrgSetup) else G:=Template;
  try
    For I:=0 to 9 do
      If G.NrOfMounts>=I+1 then result.Add(G.Mount[I]) else break;
  finally
    If Template=nil then G.Free;
  end;

  {Add GameDir}
  B:=False;
  T:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)))));
  For I:=0 to result.Count-1 do begin
    St:=ValueToList(result[I]);
    try
      If (St.Count<2) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));
      B:=(T=S); If B then break;
    finally
      St.Free;
    end;
  end;
  if not B then result.Add(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';DRIVE;'+NextFreeDriveLetter(result)+';False;;'+IntToStr(DefaultFreeHDSize));

  {Add program file and setup file dir}
  If ProgrammFileDir<>'' then AddPrgDir(result,ProgrammFileDir);
  If SetupFileDir<>'' then AddPrgDir(result,SetupFileDir);
end;

Procedure BuildGameDirMountData(const Mounting : TStringList; const ProgrammFileDir, SetupFileDir : String);
Var B : Boolean;
    I : Integer;
    S,T : String;
    St : TStringList;
begin
  {Everything already ok ?}
  If ((Trim(ProgrammFileDir)='') or CanReachFile(Mounting,ProgrammFileDir)) and
     ((Trim(SetupFileDir)='') or CanReachFile(Mounting,SetupFileDir)) then exit;

  {Add GameDir}
  B:=False;
  T:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      If (St.Count<2) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));
      B:=(T=S); If B then break;
    finally
      St.Free;
    end;
  end;
  if not B then Mounting.Add(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';DRIVE;'+NextFreeDriveLetter(Mounting)+';False;;'+IntToStr(DefaultFreeHDSize));

  {Add program file and setup file dir}
  If ProgrammFileDir<>'' then AddPrgDir(Mounting,ProgrammFileDir);
  If SetupFileDir<>'' then AddPrgDir(Mounting,SetupFileDir);
end;

Function GetProfFileList(const Dir : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=TStringList.Create;
  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.prof',faAnyFile,Rec);
  try
    While I=0 do begin result.Add(Rec.Name); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;
end;

Function TemplateNeeded(const AutoSetupDB : TGameDB; const ExeMD5 : String) : Boolean;
Var S : String;
    I : Integer;
begin
  S:=Trim(ExeMD5);
  if S='' then begin result:=True; exit; end;
  result:=False;
  For I:=0 to AutoSetupDB.Count-1 do If AutoSetupDB[I].GameExeMD5=S then exit;
  result:=True;
end;

Procedure CheckAutoSetupTemplates(const AutoSetupDB : TGameDB; const NewAutoSetupTemplatesFolder : String);
Var St : TStringList;
    I,J : Integer;
    Dir,S : String;
    Ini : TIniFile;
begin
  Dir:=IncludeTrailingPathDelimiter(NewAutoSetupTemplatesFolder);
  St:=nil;
  try
    St:=GetProfFileList(Dir);

    For I:=0 to St.Count-1 do begin
      Ini:=TIniFile.Create(Dir+St[I]);
      try
        S:=Ini.ReadString('Extra','ExeMD5','');
        If not TemplateNeeded(AutoSetupDB,S) then begin
          {Delete not needed auto setup file}
          FreeAndNil(Ini);
          DeleteFile(Dir+St[I]);
        end else begin
          {Fix auto setup template}
          Ini.WriteString('Extra','Exe',ExtractFileName(Ini.ReadString('Extra','Exe','')));
          Ini.WriteString('Extra','Setup',ExtractFileName(Ini.ReadString('Extra','Setup','')));
          Ini.WriteString('Extra','0','.\VirtualHD\;Drive;C;false;');
          For J:=1 to 9 do Ini.DeleteKey('Extra',IntToStr(J));
        end;
      finally
        Ini.Free;
      end;
    end;
  finally
    St.Free;
  end;
end;

Function GetPixelShaders(const DOSBoxDir : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;

begin
  result:=TStringList.Create;
  result.Add('none');  

  I:=FindFirst(IncludeTrailingPathDelimiter(DOSBoxDir)+'Shaders\*.fx',faAnyFile,Rec);
  try
    While I=0 do begin
      result.Add(ChangeFileExt(Rec.Name,''));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(rec);
  end;
end;

end.
