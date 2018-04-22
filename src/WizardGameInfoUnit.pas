unit WizardGameInfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Grids, ValEdit, ImgList,
  Menus, ToolWin, GameDBUnit, LinkFileUnit;

type
  TWizardGameInfoFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    GameInfoValueListEditor: TValueListEditor;
    FavouriteCheckBox: TCheckBox;
    UserDefinedDataLabel: TLabel;
    Tab: TStringGrid;
    NotesLabel: TLabel;
    NotesMemo: TRichEdit;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    ToolBarPanel: TPanel;
    ToolBar: TToolBar;
    SearchGameButton: TToolButton;
    SearchPopupMenu: TPopupMenu;
    ImageList: TImageList;
    BaseName: TLabeledEdit;
    AddUserDataPopupMenu: TPopupMenu;
    ToolButton1: TToolButton;
    DownloadDataButton: TToolButton;
    MultiValueInfoLabel: TLabel;
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure GameInfoValueListEditorEditButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LinkFile : TLinkFile;
    GameDB : TGameDB;
    TempCaptureDir : String;
    WWWNames, WWWLinks : TStringList;
    Procedure LoadLinks;
    Procedure TabListForCell(ACol, ARow: Integer; var UseDropdownListForCell : Boolean);
    Procedure TabGetListForCell(ACol, ARow: Integer; DropdownListForCell : TStrings);
  public
    { Public-Deklarationen }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Init(const AGameDB : TGameDB; const ALinkFile : TLinkFile);
    Procedure SetGameName(const AName : String; const Template : TGame);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, ClassExtensions,
     IconLoaderUnit, TextEditPopupUnit, DataReaderFormUnit, GameDBToolsUnit,
     PrgSetupUnit, LinkFileEditFormUnit;

{$R *.dfm}

{ TWizardGameInfoFrame }

constructor TWizardGameInfoFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WWWNames:=TStringList.Create;
  WWWLinks:=TStringList.Create;
end;

destructor TWizardGameInfoFrame.Destroy;
begin
  WWWNames.Free;
  WWWLinks.Free;
  inherited Destroy;
end;

procedure TWizardGameInfoFrame.Init(const AGameDB: TGameDB; const ALinkFile : TLinkFile);
Var St : TStringList;
begin
  SetVistaFonts(self);

  SetRichEditPopup(NotesMemo);

  InfoLabel.Font.Style:=[fsBold];

  InfoLabel.Caption:=LanguageSetup.WizardFormPage4Info;
  BaseName.EditLabel.Caption:=LanguageSetup.WizardFormBaseName;
  GameInfoValueListEditor.TitleCaptions.Clear;
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with GameInfoValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameGenre+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ExtGenreList(GetCustomGenreName(AGameDB.GetGenreList)); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameDeveloper+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=AGameDB.GetDeveloperList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GamePublisher+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=AGameDB.GetPublisherList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameYear+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=AGameDB.GetYearList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameLanguage+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ExtLanguageList(GetCustomLanguageName(AGameDB.GetLanguageList)); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameWWW+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.GameLicense+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ExtLicenseList(GetCustomLicenseName(AGameDB.GetLicenseList)); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
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

  Tab.ColWidths[0]:=GameInfoValueListEditor.ColWidths[0];
  Tab.ColWidths[1]:=Tab.ClientWidth-10-Tab.ColWidths[0];

  LinkFile:=ALinkFile;
  LoadLinks;

  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);
  UserIconLoader.DialogImage(DI_Internet,ImageList,0);
  UserIconLoader.DialogImage(DI_Edit,ImageList,1);

  GameDB:=AGameDB;
  TempCaptureDir:='';
end;

procedure TWizardGameInfoFrame.LoadLinks;
begin
  LinkFile.AddLinksToMenu(SearchPopupMenu,0,1,SearchClick,1);
  SearchGameButton.Caption:=LanguageSetup.ProfileEditorLookUpGame+' '+LinkFile.Name[0];
  SearchGameButton.Hint:=LinkFile.Link[0];
end;

procedure TWizardGameInfoFrame.SearchClick(Sender: TObject);
Var Name,Genre,Developer,Publisher,Year,Internet,Notes : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          LinkFile.MoveToTop((Sender as TMenuItem).Caption);
          LoadLinks;
        end;
    1 : If LinkFile.EditFile(False) then LoadLinks;
    2 : OpenLink(LinkFile.Link[0],'<GAMENAME>',BaseName.Text);
    3 : begin
          TempCaptureDir:=TempDir+'DFR-TempCapture\'; ForceDirectories(TempCaptureDir);
          If ShowDataReaderDialog(self,BaseName.Text,Name,Genre,Developer,Publisher,Year,Internet,Notes,TempCaptureDir) then with GameInfoValueListEditor.Strings do begin
            If Name<>'' then BaseName.Text:=Name;
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

procedure TWizardGameInfoFrame.SetGameName(const AName: String; const Template : TGame);
Var St : TStringList;
    I,J  : Integer;
    S,T : String;
begin
  BaseName.Text:=AName;

  If Template<>nil then begin

    with GameInfoValueListEditor.Strings do begin
      If Trim(Template.Genre)<>'' then ValueFromIndex[0]:=GetCustomGenreName(Template.Genre);
      If Trim(Template.Developer)<>'' then ValueFromIndex[1]:=Template.Developer;
      If Trim(Template.Publisher)<>'' then ValueFromIndex[2]:=Template.Publisher;
      If Trim(Template.Year)<>'' then ValueFromIndex[3]:=Template.Year;
      If Trim(Template.Language)<>'' then ValueFromIndex[4]:=GetCustomLanguageName(Template.Language);
      If Trim(Template.WWW[1])<>'' then ValueFromIndex[5]:=Template.WWW[1];
      If Trim(Template.License)<>'' then ValueFromIndex[6]:=GetCustomLicenseName(Template.License) else GameInfoValueListEditor.Strings[6]:=GameInfoValueListEditor.Strings.Names[6]+'=';
    end;
    For I:=1 to 9 do begin WWWNames.Add(Template.WWWName[I]); WWWLinks.Add(Template.WWW[I]); end;

    St:=StringToStringList(Template.UserInfo);
    try
      I:=0; While I<St.Count do begin
        S:=St[I];
        J:=Pos('=',S);
        If J<>0 then S:=Trim(Copy(S,1,J-1));
        If Trim(ExtUpperCase(S))='LICENSE' then St.Delete(I) else inc(I);
      end;
      If St.Count>0 then begin
        Tab.RowCount:=St.Count+1;
        For I:=0 to St.Count-1 do begin
          S:=St[I];
          J:=Pos('=',S);
          If J=0 then T:='' else begin T:=Trim(Copy(S,J+1,MaxInt)); S:=Trim(Copy(S,1,J-1)); end;
          Tab.Cells[0,I+1]:=S;
          Tab.Cells[1,I+1]:=T;
        end;
      end;
    finally
      St.Free;
    end;

    St:=StringToStringList(Template.Notes);
    try
      NotesMemo.Lines.Assign(St);
    finally
      St.Free;
    end;
  end else begin
    For I:=1 to 9 do begin WWWNames.Add(''); WWWLinks.Add(''); end;
  end;
end;

procedure TWizardGameInfoFrame.AddButtonClick(Sender: TObject);
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

procedure TWizardGameInfoFrame.DelButtonClick(Sender: TObject);
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

procedure TWizardGameInfoFrame.WriteDataToGame(const Game: TGame);
Var St : TStringList;
    I : Integer;
    S,T,License : String;
begin
  if BaseName.Text<>'' then Game.Name:=BaseName.Text;

  with GameInfoValueListEditor.Strings do begin
    Game.Genre:=GetEnglishGenreName(ValueFromIndex[0]);
    Game.Developer:=ValueFromIndex[1];
    Game.Publisher:=ValueFromIndex[2];
    Game.Year:=ValueFromIndex[3];
    Game.Language:=GetEnglishLanguageName(ValueFromIndex[4]);
    Game.WWW[1]:=ValueFromIndex[5];
    License:=Trim(ValueFromIndex[6]);
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

  If TempCaptureDir<>'' then begin
    If Trim(Game.CaptureFolder)<>'' then begin
      S:=MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir);
      ForceDirectories(S);
      CopyFiles(TempCaptureDir,S,False,True);
    end;
    ExtDeleteFolder(TempCaptureDir,ftTemp);
  end;
end;

Procedure TWizardGameInfoFrame.TabListForCell(ACol, ARow: Integer; var UseDropdownListForCell : Boolean);
begin
  UseDropdownListForCell:=(ACol=1);
end;

Procedure TWizardGameInfoFrame.TabGetListForCell(ACol, ARow: Integer; DropdownListForCell : TStrings);
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

procedure TWizardGameInfoFrame.GameInfoValueListEditorEditButtonClick(Sender: TObject);
begin
  WWWLinks[0]:=GameInfoValueListEditor.Strings.ValueFromIndex[5];
  ShowLinkFileEditDialog(self,WWWNames,WWWLinks,False,True,-1);
  If WWWLinks[0]<>'' then GameInfoValueListEditor.Strings.ValueFromIndex[5]:=WWWLinks[0];
end;

end.
