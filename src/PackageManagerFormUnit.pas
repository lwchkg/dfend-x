unit PackageManagerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ToolWin, StdCtrls, Buttons, ExtCtrls, CheckLst,
  Menus, PackageDBUnit, PackageDBCacheUnit, ChecksumScanner, GameDBUnit,
  PackageManagerToolsUnit;

type
  TPackageManagerForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ResponsitoriesButton: TToolButton;
    ToolButton3: TToolButton;
    ImageList: TImageList;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    UpdateButton: TToolButton;
    ExePackagesListBox: TListBox;
    Splitter1: TSplitter;
    ExePackagesPanel1: TPanel;
    ExePackagesPanel2: TPanel;
    ExePackagesButton: TBitBtn;
    ExePackagesMemo: TRichEdit;
    LanguagePanel: TPanel;
    LanguageButton: TBitBtn;
    ToolButton5: TToolButton;
    HelpButton: TToolButton;
    InfoPanel: TPanel;
    InfoLabel: TLabel;
    ExePackagesDelButton: TBitBtn;
    AutoSetupPanel: TPanel;
    AutoSetupButton: TBitBtn;
    GamesPanel: TPanel;
    GamesButton: TBitBtn;
    GamesListView: TListView;
    AutoSetupListView: TListView;
    GamesFilterButton: TBitBtn;
    AutoSetupFilterButton: TBitBtn;
    FilterPopupMenu: TPopupMenu;
    TabSheet5: TTabSheet;
    IconsPanel: TPanel;
    IconsButton: TBitBtn;
    IconsListView: TListView;
    TabSheet6: TTabSheet;
    IconSetsPanel: TPanel;
    IconSetsButton: TBitBtn;
    IconSetsListView: TListView;
    LanguagesListView: TListView;
    GamesSizeLabel: TLabel;
    AutoSetupSizeLabel: TLabel;
    IconsSizeLabel: TLabel;
    IconSetsSizeLabel: TLabel;
    LanguageFilesSizeLabel: TLabel;
    ListViewPopupMenu: TPopupMenu;
    ListViewPopupMenuDelete: TMenuItem;
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExePackagesListBoxClick(Sender: TObject);
    procedure ExePackagesButtonClick(Sender: TObject);
    procedure ExePackagesDelButtonClick(Sender: TObject);
    procedure LanguageButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure GamesButtonClick(Sender: TObject);
    procedure AutoSetupButtonClick(Sender: TObject);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IconsButtonClick(Sender: TObject);
    procedure IconSetsButtonClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure ListViewChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure GamesListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewPopupMenuDeleteClick(Sender: TObject);
  private
    { Private-Deklarationen }
    PackageDB : TPackageDB;
    PackageDBCache : TPackageDBCache;
    LanguageChecksumScanner1, LanguageChecksumScanner2 : TLanguageFileChecksumScanner;
    AutoSetupChecksumScanner, IconChecksumScanner : TChecksumScanner;
    GamesFilter, AutoSetupFilter : TFilter;
    Procedure LoadLists;
    Procedure PackageDBDownload(Sender : TObject; const Progress, Size : Int64; const Status : TDownloadStatus; var ContinueDownload : Boolean);
    Procedure ProviderAction(const Data : Array of TDownloadData);
    Procedure CheckList(const ListView : TListView; const Button : TBitBtn; const InfoLabel : TLabel);
  public
    { Public-Deklarationen }
    GameDB, AutoSetupDB : TGameDB;
    HideIfAlreadyInstalled : Boolean;
    LanguageToActivate : String;
    SortCol : Array[0..4] of Integer;
  end;

var
  PackageManagerForm: TPackageManagerForm;

Function ShowPackageManagerDialog(const AOwner : TComponent; const AGameDB, AAutoSetupDB : TGameDB) : String; {result=language file to activate}

Function DonwloadAndInstall(const Owner : TComponent; const URL : String; const GameDB : TGameDB) : TGame;

implementation

uses ShellAPI, IniFiles, Math, PackageDBToolsUnit, CommonTools, PrgConsts,
     DownloadWaitFormUnit, PrgSetupUnit, VistaToolsUnit, LanguageSetupUnit,
     ZipPackageUnit, IconLoaderUnit, HelpConsts, ZipInfoFormUnit,
     PackageManagerRepositoriesEditFormUnit, ProviderFormUnit, HashCalc,
     ClassExtensions;

{$R *.dfm}

procedure TPackageManagerForm.FormCreate(Sender: TObject);
Var I : Integer;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  HideIfAlreadyInstalled:=True;
  LanguageToActivate:='';

  NoFlicker(PageControl);
  NoFlicker(GamesListView);
  NoFlicker(AutoSetupListView);
  NoFlicker(IconsListView);
  NoFlicker(IconSetsListView);
  NoFlicker(LanguagesListView);
  NoFlicker(ExePackagesListBox);

  Caption:=LanguageSetup.PackageManager;
  CloseButton.Caption:=LanguageSetup.Close;
  CloseButton.Hint:=LanguageSetup.CloseHintWindow;
  UpdateButton.Caption:=LanguageSetup.PackageManagerMenuUpdateLists;
  UpdateButton.Hint:=LanguageSetup.PackageManagerMenuUpdateListsHint;
  ResponsitoriesButton.Caption:=LanguageSetup.PackageManagerMenuRepositoriesList;
  ResponsitoriesButton.Hint:=LanguageSetup.PackageManagerMenuRepositoriesListHint;
  HelpButton.Caption:=LanguageSetup.Help;
  HelpButton.Hint:=LanguageSetup.HelpHint;

  TabSheet1.Caption:=LanguageSetup.PackageManagerPageGames;
  TabSheet2.Caption:=LanguageSetup.PackageManagerPageAutoSetups;
  TabSheet5.Caption:=LanguageSetup.PackageManagerPageIcons;
  TabSheet6.Caption:=LanguageSetup.PackageManagerPageIconSets;
  TabSheet3.Caption:=LanguageSetup.PackageManagerPageLanguages;
  TabSheet4.Caption:=LanguageSetup.PackageManagerPageExePackages;

  UserIconLoader.DirectLoad(ImageList,'PackageManager');

  GamesFilterButton.Caption:=LanguageSetup.PackageManagerFilterList;
  GamesButton.Caption:=LanguageSetup.PackageManagerInstallGames;
  AutoSetupFilterButton.Caption:=LanguageSetup.PackageManagerFilterList;
  AutoSetupButton.Caption:=LanguageSetup.PackageManagerInstallAutoSetups;
  IconsButton.Caption:=LanguageSetup.PackageManagerInstallIcons;
  IconSetsButton.Caption:=LanguageSetup.PackageManagerInstallIconSets;
  LanguageButton.Caption:=LanguageSetup.PackageManagerInstallLanguages;
  ExePackagesButton.Caption:=LanguageSetup.PackageManagerInstallPackage;
  ExePackagesDelButton.Caption:=LanguageSetup.PackageManagerDeletePackage;

  ListViewPopupMenuDelete.Caption:=LanguageSetup.Del;

  UserIconLoader.DialogImage(DI_Import,GamesButton);
  UserIconLoader.DialogImage(DI_Import,AutoSetupButton);
  UserIconLoader.DialogImage(DI_Import,LanguageButton);
  UserIconLoader.DialogImage(DI_Import,IconsButton);
  UserIconLoader.DialogImage(DI_Import,IconSetsButton);
  UserIconLoader.DialogImage(DI_Import,ExePackagesButton);
  UserIconLoader.DialogImage(DI_Delete,ExePackagesDelButton);

  with GamesFilter do begin Key:=fkNoFilter; UpperValue:=''; end;
  with AutoSetupFilter do begin Key:=fkNoFilter; UpperValue:=''; end;

  For I:=Low(SortCol) to High(SortCol) do SortCol[I]:=1;
  InitPackageManagerListView(GamesListView,False);
  InitPackageManagerListView(AutoSetupListView,True);
  InitPackageManagerIconsListView(IconsListView);
  InitPackageManagerIconSetsListView(IconSetsListView);
  InitPackageManagerLanguagessListView(LanguagesListView);
end;

procedure TPackageManagerForm.FormShow(Sender: TObject);
Var DoUpdateCheck : Boolean;
begin
  PackageDB:=TPackageDB.Create;
  PackageDB.LoadDB(False,False,True);
  PackageDB.OnDownload:=PackageDBDownload;
  PackageDBCache:=TPackageDBCache.Create;

  GamesListView:=TListView(NewWinControlType(GamesListView,TListViewSpecialHint,ctcmDangerousMagic));
  AutoSetupListView:=TListView(NewWinControlType(AutoSetupListView,TListViewSpecialHint,ctcmDangerousMagic));
  IconsListView:=TListView(NewWinControlType(IconsListView,TListViewSpecialHint,ctcmDangerousMagic));
  IconSetsListView:=TListView(NewWinControlType(IconSetsListView,TListViewSpecialHint,ctcmDangerousMagic));
  LanguagesListView:=TListView(NewWinControlType(LanguagesListView,TListViewSpecialHint,ctcmDangerousMagic));

  LanguageChecksumScanner1:=TLanguageFileChecksumScanner.Create(PrgDir+LanguageSubDir,False,nil);
  If PrgDir=PrgDataDir then begin
    LanguageChecksumScanner2:=nil;
  end else begin
    LanguageChecksumScanner2:=TLanguageFileChecksumScanner.Create(PrgDataDir+LanguageSubDir,False,nil);
  end;
  AutoSetupChecksumScanner:=TChecksumScanner.Create(PrgDataDir+AutoSetupSubDir,'*.prof',True,True,Owner);
  IconChecksumScanner:=TChecksumScanner.Create(PrgDataDir+IconsSubDir,'*.*',True,False,Owner);

  DoUpdateCheck:=False;
  Case PrgSetup.PackageListsCheckForUpdates of
    0 : DoUpdateCheck:=False;
    1 : DoUpdateCheck:=(Round(Int(Date))>=PrgSetup.LastDataReaderUpdateCheck+7);
    2 : DoUpdateCheck:=(Round(Int(Date))>=PrgSetup.LastDataReaderUpdateCheck+1);
    3 : DoUpdateCheck:=True;
  End;
  If DoUpdateCheck then begin
    PackageDB.UpdateRemoteFiles(True);
    PrgSetup.LastPackageListeUpdateCheck:=Round(Int(Date));
  end;

  LoadLists;
end;

procedure TPackageManagerForm.FormDestroy(Sender: TObject);
begin
  PackageDB.Free;
  PackageDBCache.Free;
  LanguageChecksumScanner1.Free;
  If LanguageChecksumScanner2<>nil then LanguageChecksumScanner2.Free;
  AutoSetupChecksumScanner.Free;
  IconChecksumScanner.Free;
end;

procedure TPackageManagerForm.LoadLists;
Var I,J : Integer;
    St : TStringList;
    B : Boolean;
begin
  {Games list}
  LoadListView(GamesListView,PackageDB,GamesFilter,AutoSetupChecksumScanner,False,GameDB,AutoSetupDB,HideIfAlreadyInstalled);
  GamesFilterButton.Enabled:=(GamesListView.Items.Count>0);
  SortListView(GamesListView,abs(SortCol[0])-1,SortCol[0]<0,Abs(SortCol[0])=4);

  {Auto setup templates list}
  LoadListView(AutoSetupListView,PackageDB,AutoSetupFilter,AutoSetupChecksumScanner,True,GameDB,AutoSetupDB,HideIfAlreadyInstalled);
  AutoSetupFilterButton.Enabled:=(AutoSetupListView.Items.Count>0);
  SortListView(AutoSetupListView,abs(SortCol[1])-1,SortCol[1]<0,Abs(SortCol[0])=3);

  {Icon list}
  LoadIconsListView(IconsListView,PackageDB,IconChecksumScanner,HideIfAlreadyInstalled);
  SortListView(IconsListView,abs(SortCol[2])-1,SortCol[2]<0,Abs(SortCol[0])=2);

  {Icon sets}
  LoadIconSetsListView(IconSetsListView,PackageDB,HideIfAlreadyInstalled);
  SortListView(IconSetsListView,abs(SortCol[3])-1,SortCol[3]<0,Abs(SortCol[0])=2);

  {Language files list}
  LoadLanguagesListView(LanguagesListView,PackageDB,HideIfAlreadyInstalled,LanguageChecksumScanner1,LanguageChecksumScanner2);
  SortListView(LanguagesListView,abs(SortCol[4])-1,SortCol[4]<0,false);

  {Multiple games pacakges list}
  ExePackagesListBox.Items.Clear;
  St:=TStringList.Create;
  try
    For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB.List[I].ExePackageCount-1 do
      St.AddObject(PackageDB.List[I].ExePackage[J].Name,PackageDB.List[I].ExePackage[J]);
    For I:=0 to PackageDBCache.Count-1 do If St.IndexOf(PackageDBCache.Package[I].Name)<0 then
      St.AddObject(PackageDBCache.Package[I].Name,PackageDBCache.Package[I]);
    St.Sort;
    ExePackagesListBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  If ExePackagesListBox.Items.Count>0 then ExePackagesListBox.ItemIndex:=0;
  ExePackagesListBoxClick(self);

  {Info label}
  InfoLabel.Caption:=LanguageSetup.PackageManagerAllListsEmpty;
  B:=True;
  For I:=0 to PackageDB.Count-1 do If PackageDB.List[I].GamesCount+PackageDB.List[I].AutoSetupCount+PackageDB.List[I].LanguageCount+PackageDB.List[I].ExePackageCount+PackageDB.List[I].IconCount+PackageDB.List[I].IconSetCount>0 then begin B:=False; break; end;
  InfoPanel.Visible:=B;
  ListViewClick(nil);
end;

procedure TPackageManagerForm.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
begin
  InfoTip:='';
  If (Item=nil) or (Item.Data=nil) then exit;
  InfoTip:=GetPackageManagerToolTip(TDownloadData(Item.Data));
end;

procedure TPackageManagerForm.ListViewPopupMenuDeleteClick(Sender: TObject);
Function DeleteRecord(Data : Pointer) : Boolean;
begin
  result:=False;
  Case PageControl.ActivePageIndex of
    0 : result:=PackageDB.FindAndRemoveGame(TDownloadZipData(Data),self);
    1 : result:=PackageDB.FindAndRemoveAutoSetup(TDownloadAutoSetupData(Data),self);
    2 : result:=PackageDB.FindAndRemoveIcon(TDownloadIconData(Data),self);
    3 : result:=PackageDB.FindAndRemoveIconSet(TDownloadIconSetData(Data),self);
    4 : result:=PackageDB.FindAndRemoveLanguage(TDownloadLanguageData(Data),self);
  End;
end;
Var ListView : TListView;
    I : Integer;
    Checked, NeedRebuild : Boolean;
begin
  ListView:=nil;
  Case PageControl.ActivePageIndex of
    0 : ListView:=GamesListView;
    1 : ListView:=AutoSetupListView;
    2 : ListView:=IconsListView;
    3 : ListView:=IconSetsListView;
    4 : ListView:=LanguagesListView;
  end;
  if ListView=nil then exit;
  Checked:=False;
  For I:=0 to ListView.Items.Count-1 do if ListView.Items[I].Checked then begin Checked:=True; break; end;
  if not Checked and (ListView.ItemIndex=-1) then exit;

  ListView.Visible:=False;
  try
    If Checked then begin
      NeedRebuild:=False;
      For I:=0 to ListView.Items.Count-1 do if ListView.Items[I].Checked then begin
        if DeleteRecord(ListView.Items[I].Data) then NeedRebuild:=True;
      end;
      if not NeedRebuild then exit;
    end else begin
      if not DeleteRecord(ListView.Items[ListView.ItemIndex].Data) then exit;
    end;
    LoadLists;
  finally
    ListView.Visible:=True;
  end;
end;

Procedure TPackageManagerForm.PackageDBDownload(Sender : TObject; const Progress, Size : Int64; const Status : TDownloadStatus; var ContinueDownload : Boolean);
begin
  Case Status of
    dsStart : begin Enabled:=False; InitDownloadWaitForm(self,Size div 1024); end;
    dsProgress : begin
                   If DownloadWaitForm.ProgressBar.Max=1 then DownloadWaitForm.ProgressBar.Max:=Max(1,Size div 1024);
                   ContinueDownload:=StepDownloadWaitForm(Progress div 1024);
                 end;
    dsDone : begin Enabled:=True; DoneDownloadWaitForm; end;
  End;
end;

Type TPackageInfo=record
  PackageList : TPackageList;
  DownloadData : Array of String;
end;

Function FileNameOnly(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  I:=Pos('/',result); While I>0 do begin result:=Copy(result,I+1,MaxInt); I:=Pos('/',result); end;
  I:=Pos('\',result); While I>0 do begin result:=Copy(result,I+1,MaxInt); I:=Pos('\',result); end;
end;

procedure TPackageManagerForm.ProviderAction(const Data: array of TDownloadData);
Var I,J,K : Integer;
    InfoURL, InfoDialog : Array of TPackageInfo;
    St : TStringList;
begin
  For I:=low(Data) to high(Data) do begin
    If paInfoDialog in Data[I].PackageList.ProviderActions then begin
      K:=-1; For J:=0 to length(InfoDialog)-1 do If InfoDialog[J].PackageList=Data[I].PackageList then begin K:=J; break; end;
      If K<0 then begin K:=length(InfoDialog); SetLength(InfoDialog,K+1); InfoDialog[K].PackageList:=Data[I].PackageList; end;
      J:=length(InfoDialog[K].DownloadData); SetLength(InfoDialog[K].DownloadData,J+1); InfoDialog[K].DownloadData[J]:=FileNameOnly(Data[I].Name);
    end;
    If paOpenURL in Data[I].PackageList.ProviderActions then begin
      K:=-1; For J:=0 to length(InfoURL)-1 do If InfoURL[J].PackageList=Data[I].PackageList then begin K:=J; break; end;
      If K<0 then begin K:=length(InfoURL); SetLength(InfoURL,K+1); InfoURL[K].PackageList:=Data[I].PackageList; end;
      J:=length(InfoURL[K].DownloadData); SetLength(InfoURL[K].DownloadData,J+1); InfoURL[K].DownloadData[J]:=FileNameOnly(Data[I].Name);
    end;
  end;

  For I:=0 to length(InfoURL)-1 do ShellExecute(Handle,'open',PChar(InfoURL[I].PackageList.ProviderURL),nil,nil,SW_SHOW);

  If length(InfoDialog)=0 then exit;

  For I:=0 to length(InfoDialog)-1 do begin
    St:=TStringList.Create;
    try
      For J:=0 to length(InfoDialog[I].DownloadData)-1 do St.Add(InfoDialog[I].DownloadData[J]);
      ShowProviderDialog(self,St,InfoDialog[I].PackageList.ProviderName,InfoDialog[I].PackageList.ProviderText,InfoDialog[I].PackageList.ProviderURL);
    finally
      St.Free;
    end;
  end;
end;

procedure TPackageManagerForm.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          PackageDB.LoadDB(True,((Word(GetKeyState(VK_LSHIFT)) div 256)<>0) or ((Word(GetKeyState(VK_RSHIFT)) div 256)<>0),False);
          PrgSetup.LastPackageListeUpdateCheck:=Round(Int(Date));
          LoadLists;
        end;
    2 : If ShowPackageManagerRepositoriesEditDialog(self) then begin
          PackageDB.LoadDB(True,False,True);
          LoadLists;
        end;
    3 : Application.HelpCommand(HELP_CONTEXT,ID_FileImportDownload);
  end;
end;

Procedure TPackageManagerForm.CheckList(const ListView : TListView; const Button : TBitBtn; const InfoLabel : TLabel);
Var I : Integer;
    B : Boolean;
    Size : Int64;
begin
  B:=False;
  Size:=0;
  For I:=0 to ListView.Items.Count-1 do if (ListView.Items[I].Checked) and (ListView.Items[I].Data<>nil) then begin
    Size:=Size+TDownloadZipData(ListView.Items[I].Data).Size;
    B:=True;
  end;
  Button.Enabled:=B;
  InfoLabel.Caption:=LanguageSetup.PackageManagerDownloadSize+': '+GetNiceFileSize(Size);
end;

procedure TPackageManagerForm.ListViewChanging(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  ListViewClick(Sender);
end;

procedure TPackageManagerForm.ListViewClick(Sender: TObject);
begin
  If (Sender=GamesListView) or (Sender=nil) then CheckList(GamesListView,GamesButton,GamesSizeLabel);
  If (Sender=AutoSetupListView) or (Sender=nil) then CheckList(AutoSetupListView,AutoSetupButton,AutoSetupSizeLabel);
  If (Sender=IconsListView) or (Sender=nil) then CheckList(IconsListView,IconsButton,IconsSizeLabel);
  If (Sender=IconSetsListView) or (Sender=nil) then CheckList(IconSetsListView,IconSetsButton,IconSetsSizeLabel);
  If (Sender=LanguagesListView) or (Sender=nil) then CheckList(LanguagesListView,LanguageButton,LanguageFilesSizeLabel);
end;

procedure TPackageManagerForm.FilterClick(Sender: TObject);
Var P : TPoint;
    Nr : Integer;
    AutoSetups : Boolean;
    Key : TFilterKey;
    S : String;
    Filter : ^TFilter;
    DB : TGameDB;
begin
  If Sender is TMenuItem then begin
    Nr:=(Sender as TComponent).Tag;
    AutoSetups:=(FilterPopupMenu.Tag=1);
    If Nr<0 then begin Key:=fkNoFilter; S:=''; end else Case TMenuItem(Sender).Parent.Tag of
      1 : begin Key:=fkLicense; S:=FilterSelectLicense[Nr]; end;
      2 : begin Key:=fkGenre; S:=FilterSelectGenre[Nr]; end;
      3 : begin Key:=fkDeveloper; S:=FilterSelectDeveloper[Nr]; end;
      4 : begin Key:=fkPublisher; S:=FilterSelectPublisher[Nr]; end;
      5 : begin Key:=fkYear; S:=FilterSelectYear[Nr]; end;
      6 : begin Key:=fkLanguage; S:=FilterSelectLanguage[Nr]; end;
      else exit;
    end;
    If AutoSetups then Filter:=@AutoSetupFilter else Filter:=@GamesFilter;
    Filter^.Key:=Key; Filter^.UpperValue:=ExtUpperCase(S);
    If AutoSetups
      then LoadListView(AutoSetupListView,PackageDB,AutoSetupFilter,AutoSetupChecksumScanner,True,GameDB,AutoSetupDB,HideIfAlreadyInstalled)
      else LoadListView(GamesListView,PackageDB,GamesFilter,AutoSetupChecksumScanner,False,GameDB,AutoSetupDB,HideIfAlreadyInstalled);
    ListViewClick(nil);
  end else begin
    P:=(Sender as TControl).Parent.ClientToScreen(Point((Sender as TControl).Left+5,(Sender as TControl).Top+5));
    If (Sender as TControl).Tag=1 then DB:=AutoSetupDB else DB:=GameDB;
    OpenFilterPopup(P,(Sender as TControl).Tag=1,FilterPopupMenu,PackageDB,FilterClick,HideIfAlreadyInstalled,AutoSetupChecksumScanner,DB);
  end;
end;

procedure TPackageManagerForm.GamesButtonClick(Sender: TObject);
Var I,J : Integer;
    DownloadZipData : Array of TDownloadData;
    FileName : String;
    G : TGame;
    B : Boolean;
    DR : TDownloadResult;
begin
  For I:=0 to GamesListView.Items.Count-1 do If GamesListView.Items[I].Checked then begin
    J:=length(DownloadZipData); SetLength(DownloadZipData,J+1);
    DownloadZipData[J]:=TDownloadZipData(GamesListView.Items[I].Data);
  end;
  If length(DownloadZipData)=0 then exit;

  Enabled:=False;
  try
    ProviderAction(DownloadZipData);
    For I:=0 to length(DownloadZipData)-1 do begin
      FileName:=ExtractFileNameFromURL(DownloadZipData[I].URL,'.zip',True);

      If TDownloadZipData(DownloadZipData[I]).MetaLink then begin
        DR:=MetaLinkDownload(self,DownloadZipData[I].Size,DownloadZipData[I].PackageFileURL,DownloadZipData[I].URL,DownloadZipData[I].PackageList.Referer,PackageDB.DBDir+FileName);
      end else begin
        DR:=DownloadFileWithDialog(self,DownloadZipData[I].Size,DownloadZipData[I].PackageFileURL,DownloadZipData[I].URL,DownloadZipData[I].PackageList.Referer,PackageDB.DBDir+FileName);
      end;
      If DR=drCancel then exit;
      If DR<>drSuccess then begin
        MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[DownloadZipData[I].URL]),mtError,[mbOK],0);
        continue;
      end;

      If Trim(TDownloadZipData(DownloadZipData[I]).AutoSetupForZipURL)<>'' then begin
        If Trim(TDownloadZipData(DownloadZipData[I]).AutoSetupForZipURLMaxVersion)<>'' then begin
          try
            B:=VersionToInt(GetNormalFileVersionAsString)<=VersionToInt(TDownloadZipData(DownloadZipData[I]).AutoSetupForZipURLMaxVersion);
          except
            B:=True;
          end;
        end else begin
          B:=True;
        end;
        If B then begin
          DR:=DownloadFileWithDialog(self,0,DownloadZipData[I].PackageFileURL,TDownloadZipData(DownloadZipData[I]).AutoSetupForZipURL,DownloadZipData[I].PackageList.Referer,PackageDB.DBDir+'DFRTemp.prof');
          If DR=drCancel then exit;
          if DR<>drSuccess then begin
            MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[TDownloadZipData(DownloadZipData[I]).AutoSetupForZipURL]),mtError,[mbOK],0);
            continue;
          end;
        end;
        try
          If not AutoSetupChecksumScanner.ChecksumInList(GetMD5Sum(PackageDB.DBDir+'DFRTemp.prof',True)) then begin
            J:=AutoSetupDB.Add(DownloadZipData[I].Name);
            G:=TGame.Create(PackageDB.DBDir+'DFRTemp.prof');
            try
              AutoSetupDB[J].AssignFrom(G);
            finally
              G.Free;
            end;
            AutoSetupChecksumScanner.ReScan;
          end;
        finally
          ExtDeleteFile(PackageDB.DBDir+'DFRTemp.prof',ftTemp);
        end;
      end;

      try
        G:=ImportZipPackage(self,PackageDB.DBDir+FileName,GameDB,True);

        If G<>nil then begin
          WriteMetaInformationToProfile(G,TDownloadZipData(DownloadZipData[I]));
          If paWriteInfoToProfile in DownloadZipData[I].PackageList.ProviderActions then begin
            WriteProverInfoToProfile(G,DownloadZipData[I].PackageList.ProviderName,DownloadZipData[I].PackageList.ProviderURL);
          end;
        end;
      finally
        ExtDeleteFile(PackageDB.DBDir+FileName,ftTemp);
      end;
    end;
  finally
    Enabled:=True;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.GamesListViewColumnClick(Sender: TObject; Column: TListColumn);
Var I,J,ColNr : Integer;
begin
  I:=-1; J:=-1;
  if Sender=GamesListView then begin I:=0; J:=3; end;
  if Sender=AutoSetupListView then begin I:=1; J:=2; end;
  if Sender=IconsListView then begin  I:=2; J:=1; end;
  if Sender=IconSetsListView then begin  I:=3; J:=1; end;
  if Sender=LanguagesListView then begin  I:=4; J:=1; end;
  if I<0 then exit;

  ColNr:=Column.Index+1;

  if Abs(SortCol[I])=ColNr then SortCol[I]:=-SortCol[I] else SortCol[I]:=ColNr;

  SortListView(TListView(Sender),abs(SortCol[I])-1,SortCol[I]<0,Abs(SortCol[I])=J+1);
end;

procedure TPackageManagerForm.AutoSetupButtonClick(Sender: TObject);
Var I,J : Integer;
    DownloadAutoSetupData : Array of TDownloadData;
    FileName : String;
    G,G2 : TGame;
    DR : TDownloadResult;
begin
  For I:=0 to AutoSetupListView.Items.Count-1 do If AutoSetupListView.Items[I].Checked then begin
    J:=length(DownloadAutoSetupData); SetLength(DownloadAutoSetupData,J+1);
    DownloadAutoSetupData[J]:=TDownloadAutoSetupData(AutoSetupListView.Items[I].Data);
  end;
  If length(DownloadAutoSetupData)=0 then exit;

  Enabled:=False;
  try
    ProviderAction(DownloadAutoSetupData);
    For I:=0 to length(DownloadAutoSetupData)-1 do begin
      FileName:=ExtractFileNameFromURL(DownloadAutoSetupData[I].URL,'.prof',True);
      DR:=DownloadFileWithDialog(self,DownloadAutoSetupData[I].Size,DownloadAutoSetupData[I].PackageFileURL,DownloadAutoSetupData[I].URL,DownloadAutoSetupData[I].PackageList.Referer,PackageDB.DBDir+FileName);
      If DR=drCancel then exit;
      If DR<>drSuccess then begin
        MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[DownloadAutoSetupData[I].URL]),mtError,[mbOK],0);
        continue;
      end;
      ForceDirectories(PrgDataDir+AutoSetupSubDir+'\');
      If FileExists(PrgDataDir+AutoSetupSubDir+'\'+FileName) then begin
        G:=TGame.Create(PackageDB.DBDir+FileName);
        try
          J:=AutoSetupDB.Add(DownloadAutoSetupData[I].Name); G2:=AutoSetupDB[J];
          G2.AssignFrom(G);
          WriteMetaInformationToProfile(G2,TDownloadAutoSetupData(DownloadAutoSetupData[I]));
          If paWriteInfoToProfile in DownloadAutoSetupData[I].PackageList.ProviderActions then begin
            WriteProverInfoToProfile(G2,DownloadAutoSetupData[I].PackageList.ProviderName,DownloadAutoSetupData[I].PackageList.ProviderURL);          end;
        finally
          G.Free;
        end;
        ExtDeleteFile(PackageDB.DBDir+FileName,ftTemp);
      end else begin
        MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PrgDataDir+AutoSetupSubDir+'\'+FileName));
        G:=TGame.Create(PrgDataDir+AutoSetupSubDir+'\'+FileName);
        AutoSetupDB.Add(G);
      end;
    end;
  finally
    Enabled:=True;
    AutoSetupChecksumScanner.ReScan;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.IconsButtonClick(Sender: TObject);
Var I,J : Integer;
    DownloadIconData : Array of TDownloadData;
    FileName : String;
    DR : TDownloadResult;
begin
  For I:=0 to IconsListView.Items.Count-1 do If IconsListView.Items[I].Checked then begin
    J:=length(DownloadIconData); SetLength(DownloadIconData,J+1);
    DownloadIconData[J]:=TDownloadIconData(IconsListView.Items[I].Data);
  end;
  If length(DownloadIconData)=0 then exit;

  Enabled:=False;
  try
    ProviderAction(DownloadIconData);
    For I:=0 to length(DownloadIconData)-1 do begin
      FileName:=ExtractFileNameFromURL(DownloadIconData[I].URL,'.ico',True);
      DR:=DownloadFileWithDialog(self,DownloadIconData[I].Size,DownloadIconData[I].PackageFileURL,DownloadIconData[I].URL,DownloadIconData[I].PackageList.Referer,PackageDB.DBDir+FileName);
      If DR=drCancel then exit;
      If DR=drSuccess then begin
        ForceDirectories(PrgDataDir+IconsSubDir+'\');
        If FileExists(PrgDataDir+IconsSubDir+'\'+FileName) then ExtDeleteFile(PrgDataDir+IconsSubDir+'\'+FileName,ftTemp);
        MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PrgDataDir+IconsSubDir+'\'+FileName));
      end else begin
        MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[DownloadIconData[I].URL]),mtError,[mbOK],0);
      end;
    end;
  finally
    Enabled:=True;
    IconChecksumScanner.ReScan;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.IconSetsButtonClick(Sender: TObject);
Var I,J : Integer;
    DownloadIconSetData : Array of TDownloadData;
    FileName, DestDir : String;
    B : Boolean;
    Ini : TIniFile;
    DR : TDownloadResult;
begin
  For I:=0 to IconSetsListView.Items.Count-1 do If IconSetsListView.Items[I].Checked then begin
    J:=length(DownloadIconSetData); SetLength(DownloadIconSetData,J+1);
    DownloadIconSetData[J]:=TDownloadIconSetData(IconSetsListView.Items[I].Data);
  end;
  If length(DownloadIconSetData)=0 then exit;

  Enabled:=False;
  try
    B:=False;
    ProviderAction(DownloadIconSetData);
    For I:=0 to length(DownloadIconSetData)-1 do begin
      FileName:=ExtractFileNameFromURL(DownloadIconSetData[I].URL,'.zip',True);
      DR:=DownloadFileWithDialog(self,DownloadIconSetData[I].Size,DownloadIconSetData[I].PackageFileURL,DownloadIconSetData[I].URL,DownloadIconSetData[I].PackageList.Referer,PackageDB.DBDir+FileName);
      If DR=drCancel then exit;
      If DR=drSuccess then begin
        B:=True;
        ForceDirectories(PrgDataDir+IconSetsFolder+'\');
        DestDir:=PrgDataDir+IconSetsFolder+'\'+ChangeFileExt(FileName,'');
        J:=0; While DirectoryExists(DestDir) do begin
          inc(J); DestDir:=PrgDataDir+IconSetsFolder+'\'+ChangeFileExt(FileName,'')+IntToStr(J);
        end;
        ForceDirectories(DestDir);
        ExtractZipFile(self,PackageDB.DBDir+FileName,DestDir);
        DeleteFile(PackageDB.DBDir+FileName);

        Ini:=TIniFile.Create(IncludeTrailingPathDelimiter(DestDir)+IconsConfFile);
        try
          Ini.WriteString('Information','Name',DownloadIconSetData[I].Name);
          Ini.WriteString('Information','MinVersion',TDownloadIconSetData(DownloadIconSetData[I]).MinVersion);
          Ini.WriteString('Information','MaxVersion',TDownloadIconSetData(DownloadIconSetData[I]).MaxVersion);
        finally
          Ini.Free;
        end;
      end else begin
        MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[DownloadIconSetData[I].URL]),mtError,[mbOK],0);
      end;
    end;
    If B then MessageDlg(LanguageSetup.PackageManagerIconSetDownloaded,mtInformation,[mbOK],0);
  finally
    Enabled:=True;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.LanguageButtonClick(Sender: TObject);
Var DownloadLanguageData : Array of TDownloadData;
    FileName,DestLangFile : String;
    I,J,C : Integer;
    Ini : TIniFile;
    DR : TDownloadResult;
begin
  For I:=0 to LanguagesListView.Items.Count-1 do If LanguagesListView.Items[I].Checked then begin
    J:=length(DownloadLanguageData); SetLength(DownloadLanguageData,J+1);
    DownloadLanguageData[J]:=TDownloadLanguageData(LanguagesListView.Items[I].Data);
  end;
  If length(DownloadLanguageData)=0 then exit;

  Enabled:=False;
  try
    C:=0; DestLangFile:='';
    ProviderAction(DownloadLanguageData);
    For I:=0 to length(DownloadLanguageData)-1 do begin
      FileName:=ExtractFileNameFromURL(DownloadLanguageData[I].URL,'.ini',True);
      DR:=DownloadFileWithDialog(self,DownloadLanguageData[I].Size,DownloadLanguageData[I].PackageFileURL,DownloadLanguageData[I].URL,DownloadLanguageData[I].PackageList.Referer,PackageDB.DBDir+FileName);
      If DR=drCancel then exit;
      If DR=drSuccess then begin
        inc(C);
        ForceDirectories(PrgDataDir+LanguageSubDir+'\');
        DestLangFile:=PrgDataDir+LanguageSubDir+'\'+FileName;
        If FileExists(DestLangFile) then ExtDeleteFile(DestLangFile,ftTemp);
        MoveFile(PChar(PackageDB.DBDir+FileName),PChar(DestLangFile));
        Ini:=TIniFile.Create(DestLangFile);
        try
          Ini.WriteString('LanguageFileInfo','MaxVersion',TDownloadLanguageData(DownloadLanguageData[I]).MaxVersion);
          Ini.WriteString('LanguageFileInfo','DownloadChecksum',DownloadLanguageData[I].PackageChecksum);
        finally
          Ini.Free;
        end;
      end else begin
        MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[DownloadLanguageData[I].URL]),mtError,[mbOK],0);
      end;
    end;
    If C=1 then begin
      If MessageDlg(LanguageSetup.PackageManagerLanguageDownloadedSingle,mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
        LanguageToActivate:=DestLangFile;
        Close;
        exit;
      end;
    end;
    If C>0 then MessageDlg(LanguageSetup.PackageManagerLanguageDownloaded,mtInformation,[mbOK],0);
  finally
    Enabled:=True;
    LanguageChecksumScanner1.ReScan;
    If LanguageChecksumScanner2<>nil then LanguageChecksumScanner2.ReScan;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.ExePackagesListBoxClick(Sender: TObject);
Var St : TStringList;
    DownloadExeData : TDownloadExeData;
begin
  ExePackagesMemo.Lines.Clear;
  If ExePackagesListBox.ItemIndex>=0 then begin
    St:=ExePackageInfo(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex],PackageDBCache);
    try ExePackagesMemo.Lines.AddStrings(St); finally St.Free; end;
  end;
  ExePackagesButton.Enabled:=(ExePackagesListBox.ItemIndex>=0);

  If ExePackagesListBox.ItemIndex>=0 then begin
    If ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex] is TCachedPackage then begin
      ExePackagesDelButton.Enabled:=True;
    end else begin
      DownloadExeData:=TDownloadExeData(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]);
      ExePackagesDelButton.Enabled:=(PackageDBCache.FindChecksum(DownloadExeData.Name)<>'');
    end;
  end else begin
    ExePackagesDelButton.Enabled:=False;
  end;
end;

procedure TPackageManagerForm.ExePackagesButtonClick(Sender: TObject);
Var DownloadExeData : TDownloadExeData;
    Data : Array of TDownloadData;
    FileName : String;
    CachedPackage : TCachedPackage;
    OldChecksum : String;
    OK : Boolean;
begin
  If ExePackagesListBox.ItemIndex<0 then exit;

  If ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex] is TCachedPackage then begin
    CachedPackage:=TCachedPackage(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]);
    ShellExecute(Handle,'open',PChar(CachedPackage.Filename),PChar('/D='+PrgDir),nil,SW_Show);
    Close;
    exit;
  end;

  DownloadExeData:=TDownloadExeData(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]);

  SetLength(Data,1); Data[0]:=DownloadExeData;
  ProviderAction(Data);

  OldChecksum:=PackageDBCache.FindChecksum(DownloadExeData.Name);
  FileName:=ExtractFileNameFromURL(DownloadExeData.URL,'.exe',True);
  If DownloadExeData.PackageChecksum<>OldChecksum then begin
    Enabled:=False;
    try
      OK:=(DownloadFileWithDialog(self,DownloadExeData.Size,DownloadExeData.PackageFileURL,DownloadExeData.URL,DownloadExeData.PackageList.Referer,PackageDB.DBDir+FileName)=drSuccess);
    finally
      Enabled:=True;
    end;
    If OK then begin
      PackageDBCache.DelCache(DownloadExeData.Name);
      MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PackageDBCache.DBDir+FileName));
      PackageDBCache.AddCache(DownloadExeData.Name,DownloadExeData.Description,PackageDBCache.DBDir+FileName);
    end else begin
      If OldChecksum='' then begin
        MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[DownloadExeData.URL]),mtError,[mbOK],0);
        exit;
      end else begin
        if MessageDlg(LanguageSetup.PackageManagerDownloadFailedUseOldVersion,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
        CachedPackage:=PackageDBCache.FindPackage(DownloadExeData.Name); if CachedPackage=nil then exit;
        ShellExecute(Handle,'open',PChar(CachedPackage.Filename),PChar('/D='+PrgDir),nil,SW_Show);
        Close;
        exit;
      end;
    end;
  end;

  ShellExecute(Handle,'open',PChar(PackageDBCache.DBDir+FileName),PChar('/D='+PrgDir),nil,SW_Show);
  Close;
end;

procedure TPackageManagerForm.ExePackagesDelButtonClick(Sender: TObject);
Var O : TObject;
begin
  If ExePackagesListBox.ItemIndex<0 then exit;
  O:=ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex];
  If O is TCachedPackage then PackageDBCache.DelCache(TCachedPackage(O));
  If O is TDownloadExeData then begin
    O:=PackageDBCache.FindPackage(TDownloadExeData(O).Name);
    PackageDBCache.DelCache(TCachedPackage(O));
  end;
  LoadLists;
end;

procedure TPackageManagerForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then ButtonWork(HelpButton);
end;

{ global }

Function ShowPackageManagerDialog(const AOwner : TComponent; const AGameDB, AAutoSetupDB : TGameDB) : String;
begin
  PackageManagerForm:=TPackageManagerForm.Create(AOwner);
  try
    PackageManagerForm.GameDB:=AGameDB;
    PackageManagerForm.AutoSetupDB:=AAutoSetupDB;
    PackageManagerForm.HideIfAlreadyInstalled:=((Word(GetKeyState(VK_LSHIFT)) div 256)=0) and ((Word(GetKeyState(VK_RSHIFT)) div 256)=0);
    PackageManagerForm.ShowModal;
    result:=PackageManagerForm.LanguageToActivate;
  finally
    PackageManagerForm.Free;
  end;
end;

Function DonwloadAndInstall(const Owner : TComponent; const URL : String; const GameDB : TGameDB) : TGame;
Var B : TDownloadResult;
    TempFile : String;
begin
  result:=nil;
  TempFile:=TempDir+ChangeFileExt(MakeFileSysOKFolderName(URL),'.zip');
  If Pos('METALINK.PHP',ExtUpperCase(URL))>0 then begin
    B:=MetaLinkDownload(Owner,0,'',URL,'automatic',TempFile);
  end else begin
    B:=DownloadFileWithDialog(Owner,0,'',URL,'automatic',TempFile);
  end;
  If B=drCancel then exit;
  If B<>drSuccess then begin
    MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[URL]),mtError,[mbOK],0);
    exit;
  end;
  try
    result:=ImportZipPackage(Owner,TempFile,GameDB,False);
  finally
    ExtDeleteFile(TempFile,ftTemp);
  end;
end;

end.
