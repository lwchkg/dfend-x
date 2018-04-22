unit ModernProfileEditorGameInfoFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, ValEdit, StdCtrls, ComCtrls, Buttons, ImgList, ToolWin,
  ExtCtrls, Menus, GameDBUnit, ModernProfileEditorFormUnit, LinkFileUnit;

type
  TModernProfileEditorGameInfoFrame = class(TFrame, IModernProfileEditorFrame)
    GameInfoValueListEditor: TValueListEditor;
    FavouriteCheckBox: TCheckBox;
    NotesLabel: TLabel;
    NotesMemo: TRichEdit;
    Tab: TStringGrid;
    UserDefinedDataLabel: TLabel;
    DelButton: TSpeedButton;
    AddButton: TSpeedButton;
    ToolBarPanel: TPanel;
    ToolBar: TToolBar;
    SearchGameButton: TToolButton;
    ImageList: TImageList;
    SearchPopupMenu: TPopupMenu;
    AddUserDataPopupMenu: TPopupMenu;
    MultiValueInfoLabel: TLabel;
    ToolButton1: TToolButton;
    DownloadDataButton: TToolButton;
    procedure FrameResize(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    Procedure SearchClick(Sender : TObject);
    procedure GameInfoValueListEditorEditButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LinkFile : TLinkFile;
    PProfileName,PCaptureDir : PString;
    GameDB : TGameDB;
    ProfileExe,ProfileSetup,ProfileScummVMGameName,ProfileScummVMPath,ProfileDOSBoxInstallation,ProfileCaptureDir : PString;
    FOnProfileNameChange : TTextEvent;
    WWWNames, WWWLinks : TStringList;
    Procedure LoadLinks;
    Procedure TabListForCell(ACol, ARow: Integer; var UseDropdownListForCell : Boolean);
    Procedure TabGetListForCell(ACol, ARow: Integer; DropdownListForCell : TStrings);
  public
    { Public-Deklarationen }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, HelpConsts,
     ClassExtensions, IconLoaderUnit, TextEditPopupUnit, DataReaderFormUnit,
     PrgSetupUnit, LinkFileEditFormUnit;

{$R *.dfm}

{ TModernProfileEditorGameInfoFrame }

constructor TModernProfileEditorGameInfoFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WWWNames:=TStringList.Create;
  WWWLinks:=TStringList.Create;
end;

destructor TModernProfileEditorGameInfoFrame.Destroy;
begin
  WWWNames.Free;
  WWWLinks.Free;
  inherited Destroy;
end;

procedure TModernProfileEditorGameInfoFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  InitData.AllowDefaultValueReset:=False;

  NoFlicker(GameInfoValueListEditor);
  NoFlicker(FavouriteCheckBox);
  NoFlicker(Tab);
  {NoFlicker(NotesMemo); - will hide text in Memo}

  SetRichEditPopup(NotesMemo);

  GameInfoValueListEditor.TitleCaptions.Clear;
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with GameInfoValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameGenre+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ExtGenreList(GetCustomGenreName(InitData.GameDB.GetGenreList)); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameDeveloper+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetDeveloperList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GamePublisher+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetPublisherList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameYear+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetYearList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameLanguage+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ExtLanguageList(GetCustomLanguageName(InitData.GameDB.GetLanguageList)); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameWWW+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.GameLicense+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ExtLicenseList(GetCustomLicenseName(InitData.GameDB.GetLicenseList)); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
  end;
  DownloadDataButton.Caption:=LanguageSetup.DataReaderButton;
  FavouriteCheckBox.Caption:=LanguageSetup.GameFavorite;
  FavouriteCheckBox.Left:=GameInfoValueListEditor.Left+GameInfoValueListEditor.Width-Application.MainForm.Canvas.TextWidth(FavouriteCheckBox.Caption)-20;

  MultiValueInfoLabel.Caption:=LanguageSetup.ProfileEditorMultipleValuesInfo;

  UserDefinedDataLabel.Caption:=LanguageSetup.ProfileEditorUserdefinedInfo+':';

  Tab:=TStringGrid(NewWinControlType(Tab,TStringGridEx,ctcmCopyProperties));
  TStringGridEx(Tab).OnListForCell:=TabListForCell;
  TStringGridEx(Tab).OnGetListForCell:=TabGetListForCell;

  Tab.Cells[0,0]:=LanguageSetup.Key;
  Tab.Cells[1,0]:=LanguageSetup.Value;
  Tab.RowHeights[0]:=GameInfoValueListEditor.RowHeights[0];
  Tab.RowHeights[1]:=GameInfoValueListEditor.RowHeights[0];
  AddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  DelButton.Hint:=RemoveUnderline(LanguageSetup.Del);

  NotesLabel.Caption:=LanguageSetup.GameNotes+':';

  UserIconLoader.DialogImage(DI_Internet,ImageList,0);
  UserIconLoader.DialogImage(DI_Edit,ImageList,1);
  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);

  PProfileName:=InitData.CurrentProfileName;
  PCaptureDir:=InitData.CurrentCaptureDir;
  LinkFile:=InitData.SearchLinkFile;
  GameDB:=InitData.GameDB;

  LoadLinks;

  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileScummVMGameName:=InitData.CurrentScummVMGameName;
  ProfileScummVMPath:=InitData.CurrentScummVMPath;
  ProfileDOSBoxInstallation:=InitData.CurrentDOSBoxInstallation;
  ProfileCaptureDir:=InitData.CurrentCaptureDir;
  FOnProfileNameChange:=InitData.OnProfileNameChange;

  HelpContext:=ID_ProfileEditProgramInformation;
end;

procedure TModernProfileEditorGameInfoFrame.LoadLinks;
begin
  LinkFile.AddLinksToMenu(SearchPopupMenu,0,1,SearchClick,1);
  SearchGameButton.Caption:=LanguageSetup.ProfileEditorLookUpGame+' '+LinkFile.Name[0];
  SearchGameButton.Hint:=LinkFile.Link[0];
end;

procedure TModernProfileEditorGameInfoFrame.SearchClick(Sender: TObject);
Var S,Name,Genre,Developer,Publisher,Year,Internet,Notes : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          LinkFile.MoveToTop((Sender as TMenuItem).Caption);
          LoadLinks;
        end;
    1 : If LinkFile.EditFile(False) then LoadLinks;
    2 : OpenLink(LinkFile.Link[0],'<GAMENAME>',PProfileName^);
    3 : begin
          If Trim(PCaptureDir^)='' then S:='' else S:=MakeAbsPath(PCaptureDir^,PrgSetup.BaseDir);
          If ShowDataReaderDialog(self,PProfileName^,Name,Genre,Developer,Publisher,Year,Internet,Notes,S) then with GameInfoValueListEditor.Strings do begin
            If Name <>'' then FOnProfileNameChange(self,Name,ProfileExe^,ProfileSetup^,ProfileScummVMGameName^,ProfileScummVMPath^,ProfileDOSBoxInstallation^,ProfileCaptureDir^);
            If Genre<>'' then ValueFromIndex[0]:=Genre;
            If Developer<>'' then ValueFromIndex[1]:=Developer;
            If Publisher<>'' then ValueFromIndex[2]:=Publisher;
            If Year<>'' then ValueFromIndex[3]:=Year;
            If (Internet<>'') and (Trim(ValueFromIndex[5])='') then ValueFromIndex[5]:=Internet;
            if Notes<>'' then NotesMemo.Lines.Add(Notes);
          end;
        end;
  end;
end;

procedure TModernProfileEditorGameInfoFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    I,J,C : Integer;
    S,T : String;
begin
  If Game=nil then begin
    GameInfoValueListEditor.Strings.ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
    exit;
  end;

  with GameInfoValueListEditor.Strings do begin
    If Game.Genre<>'' then ValueFromIndex[0]:=GetCustomGenreName(Game.Genre) else GameInfoValueListEditor.Strings[0]:=GameInfoValueListEditor.Strings.Names[0]+'=';
    If Game.Developer<>'' then ValueFromIndex[1]:=Game.Developer else GameInfoValueListEditor.Strings[1]:=GameInfoValueListEditor.Strings.Names[1]+'=';
    If Game.Publisher<>'' then ValueFromIndex[2]:=Game.Publisher else GameInfoValueListEditor.Strings[2]:=GameInfoValueListEditor.Strings.Names[2]+'=';
    If Game.Year<>'' then ValueFromIndex[3]:=Game.Year else GameInfoValueListEditor.Strings[3]:=GameInfoValueListEditor.Strings.Names[3]+'=';
    If Game.Language<>'' then ValueFromIndex[4]:=GetCustomLanguageName(Game.Language) else GameInfoValueListEditor.Strings[4]:=GameInfoValueListEditor.Strings.Names[4]+'=';
    If Game.WWW[1]<>'' then ValueFromIndex[5]:=Game.WWW[1] else GameInfoValueListEditor.Strings[5]:=GameInfoValueListEditor.Strings.Names[5]+'=';
    If Game.License<>'' then ValueFromIndex[6]:=GetCustomLicenseName(Game.License) else GameInfoValueListEditor.Strings[6]:=GameInfoValueListEditor.Strings.Names[6]+'=';
  end;
  FavouriteCheckBox.Checked:=Game.Favorite;
  For I:=1 to 9 do begin WWWNames.Add(Game.WWWName[I]); WWWLinks.Add(Game.WWW[I]); end;

  St:=StringToStringList(Game.UserInfo);
  try
    Tab.RowCount:=Max(St.Count,1)+1;
    Tab.Cells[0,1]:=''; Tab.Cells[1,1]:=''; C:=1;
    For I:=0 to St.Count-1 do begin
      S:=St[I];
      J:=Pos('=',S);
      If J=0 then T:='' else begin T:=Trim(Copy(S,J+1,MaxInt)); S:=Trim(Copy(S,1,J-1)); end;
      If Trim(ExtUpperCase(S))='LICENSE' then continue;
      Tab.Cells[0,C]:=S;
      Tab.Cells[1,C]:=T;
      inc(C);
    end;
    Tab.RowCount:=Max(2,C);
  finally
    St.Free;
  end;

  St:=StringToStringList(Game.Notes);
  try NotesMemo.Lines.Assign(St); finally St.Free; end;

  FrameResize(self);
end;

procedure TModernProfileEditorGameInfoFrame.GetGame(const Game: TGame);
Var St : TStringList;
    I : Integer;
    S,T,License : String;
begin
  with GameInfoValueListEditor.Strings do begin
    Game.Genre:=GetEnglishGenreName(ValueFromIndex[0]);
    Game.Developer:=ValueFromIndex[1];
    Game.Publisher:=ValueFromIndex[2];
    Game.Year:=ValueFromIndex[3];
    Game.Language:=GetEnglishLanguageName(ValueFromIndex[4]);
    Game.WWW[1]:=ValueFromIndex[5];
    License:=GetEnglishLicenseName(ValueFromIndex[6]);
  end;
  Game.Favorite:=FavouriteCheckBox.Checked;
  If WWWNames.Count>0 then Game.WWWName[1]:=WWWNames[0] else Game.WWWName[1]:='';
  For I:=1 to Min(8,Min(WWWNames.Count,WWWLinks.Count)) do begin Game.WWWName[I+1]:=WWWNames[I]; Game.WWW[I+1]:=WWWLinks[I]; end;

  St:=TStringList.Create;
  try
    If License<>'' then St.Add('License='+License);
    For I:=1 to Tab.RowCount-1 do begin
      S:=Trim(Tab.Cells[0,I]); T:=Trim(Tab.Cells[1,I]);
      If (S<>'') or (T<>'') then St.Add(S+'='+T);
    end;
    If St.Count=0 then Game.UserInfo:='' else Game.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;

  Game.Notes:=StringListToString(NotesMemo.Lines);
end;

procedure TModernProfileEditorGameInfoFrame.FrameResize(Sender: TObject);
begin
  Tab.ColWidths[0]:=GameInfoValueListEditor.ColWidths[0];
  Tab.ColWidths[1]:=Tab.ClientWidth-10-Tab.ColWidths[0];
end;

procedure TModernProfileEditorGameInfoFrame.AddButtonClick(Sender: TObject);
Var M : TMenuItem;
    St : TStringList;
    S : String;
    I,J : Integer;
    P : TPoint;
begin
  If (Sender as TComponent).Tag>0 then begin
    If ((Sender as TComponent).Tag=1) or (Trim(Tab.Cells[0,Tab.RowCount-1])<>'') or (Trim(Tab.Cells[1,Tab.RowCount-1])<>'') then begin
      Tab.RowCount:=Tab.RowCount+1;
      Tab.RowHeights[Tab.RowCount-1]:=GameInfoValueListEditor.RowHeights[0];
    end;
    Tab.Row:=Tab.RowCount-1;
    Tab.Col:=0;
    If (Sender as TComponent).Tag=2 then begin
      Tab.Cells[0,Tab.RowCount-1]:=RemoveUnderline((Sender as TMenuItem).Caption);
      Tab.Col:=1;
    end;

    Tab.SetFocus;
    exit;
  end;

  St:=GameDB.GetUserKeys;
  try
    I:=0;
    While I<St.Count do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='LICENSE' then begin St.Delete(I); continue; end;
      For J:=1 to Tab.RowCount-1 do If Trim(ExtUpperCase(Tab.Cells[0,J]))=S then begin St.Delete(I); dec(I); break; end;
      inc(I);
    end;
    If St.Count=0 then begin
      Tab.RowCount:=Tab.RowCount+1;
      Tab.RowHeights[Tab.RowCount-1]:=GameInfoValueListEditor.RowHeights[0];
      Tab.Row:=Tab.RowCount-1;
      Tab.Col:=0;
      Tab.SetFocus;
      exit;
    end else begin
      AddUserDataPopupMenu.Items.Clear;
      M:=TMenuItem.Create(AddUserDataPopupMenu); M.Caption:=LanguageSetup.AddNewEmptyLine; M.Tag:=1; M.OnClick:=AddButtonClick;
      AddUserDataPopupMenu.Items.Add(M);
      M:=TMenuItem.Create(AddUserDataPopupMenu); M.Caption:='-';
      AddUserDataPopupMenu.Items.Add(M);
      For I:=0 to St.Count-1 do begin
        M:=TMenuItem.Create(AddUserDataPopupMenu); M.Caption:=MaskUnderlineAmpersand(St[I]); M.Tag:=2; M.OnClick:=AddButtonClick;
        AddUserDataPopupMenu.Items.Add(M);
      end;
    end;
  finally
    St.Free;
  end;

  P:=ClientToScreen(Point((Sender as TControl).Left,(Sender as TControl).Top));
  AddUserDataPopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TModernProfileEditorGameInfoFrame.DelButtonClick(Sender: TObject);
Var I : Integer;
begin
  If Tab.RowCount=2 then begin
    Tab.Cells[0,1]:='';
    Tab.Cells[1,1]:='';
    exit;
  end;

  If Tab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoRecordSelected,mtError,[mbOK],0);
    exit;
  end;

  For I:=Tab.Row+1 to Tab.RowCount-1 do begin
    Tab.Cells[0,I-1]:=Tab.Cells[0,I];
    Tab.Cells[1,I-1]:=Tab.Cells[1,I];
  end;
  Tab.RowCount:=Tab.RowCount-1;
end;

Procedure TModernProfileEditorGameInfoFrame.TabListForCell(ACol, ARow: Integer; var UseDropdownListForCell : Boolean);
begin
  UseDropdownListForCell:=(ACol=1);
end;

Procedure TModernProfileEditorGameInfoFrame.TabGetListForCell(ACol, ARow: Integer; DropdownListForCell : TStrings);
Var St : TStringList;
begin
  DropdownListForCell.Clear;
  St:=GameDB.GetKeyValueList(Tab.Cells[0,ARow]);
  try
    DropdownListForCell.AddStrings(St);
  finally
    St.Free;
  end;
end;

procedure TModernProfileEditorGameInfoFrame.GameInfoValueListEditorEditButtonClick(Sender: TObject);
begin
  WWWLinks[0]:=GameInfoValueListEditor.Strings.ValueFromIndex[5];
  ShowLinkFileEditDialog(self,WWWNames,WWWLinks,False,True,-1);
  If WWWLinks[0]<>'' then GameInfoValueListEditor.Strings.ValueFromIndex[5]:=WWWLinks[0];
end;

end.
