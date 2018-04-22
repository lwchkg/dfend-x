unit SetupFrameGamesListColumnsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, CheckLst, SetupFormUnit, Menus;

type
  TSetupFrameGamesListColumns = class(TFrame, ISetupFrame)
    ListViewLabel: TLabel;
    ListViewListBox: TCheckListBox;
    ListViewUpButton: TSpeedButton;
    ListViewDownButton: TSpeedButton;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    PopupMenu: TPopupMenu;
    StoreColumnWidthsCheckBox: TCheckBox;
    GridLinesCheckBox: TCheckBox;
    procedure ListViewMoveButtonClick(Sender: TObject);
    procedure ListViewListBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    UserDataList : TStringList;
    Procedure InitPopup;
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts,
     GameDBToolsUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameGamesListColumns }

destructor TSetupFrameGamesListColumns.Destroy;
begin
  UserDataList.Free;
  inherited Destroy;
end;

function TSetupFrameGamesListColumns.GetName: String;
begin
  result:=LanguageSetup.SetupFormListViewSheet1;
end;

procedure TSetupFrameGamesListColumns.InitGUIAndLoadSetup(var InitData: TInitData);
Var ColOrder,ColVisible,ColVisibleUser : String;
    I,J,Nr : Integer;
    B : Boolean;
    ColVisibleUserSt : TStringList;
begin
  {NoFlicker(ListViewListBox); - will cause trouble}
  NoFlicker(GridLinesCheckBox);
  NoFlicker(StoreColumnWidthsCheckBox);

  If InitData.GameDB<>nil then UserDataList:=GetUserDataList(InitData.GameDB);

  GetColOrderAndVisible(ColOrder,ColVisible,ColVisibleUser);
  ColVisibleUserSt:=ValueToList(ColVisibleUser);
  try
    For I:=0 to 7+ColVisibleUserSt.Count do begin
      Nr:=-1;
      Case ColOrder[I+1] of
        '1'..'9' : Nr:=StrToInt(ColOrder[I+1]);
        'A'..'Z' : Nr:=Ord(ColOrder[I+1])-Ord('A')+10;
        'a'..'z' : Nr:=Ord(ColOrder[I+1])-Ord('a')+10;
      end;
      If Nr<1 then continue;
      If Nr>8 then begin
        If Nr-8>ColVisibleUserSt.Count then continue;
      end;
      Case Nr-1 of
        0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(Nr-1));
        1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(Nr-1));
        2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(Nr-1));
        3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(Nr-1));
        4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(Nr-1));
        5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(Nr-1));
        6 : ListViewListBox.Items.AddObject(LanguageSetup.GameNotes,Pointer(Nr-1));
        7 : ListViewListBox.Items.AddObject(LanguageSetup.GameStartCount,Pointer(Nr-1));
        else ListViewListBox.Items.AddObject(ColVisibleUserSt[Nr-9],Pointer(100));
      end;
      ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=(ColVisible[Nr]<>'0');
    end;
    For I:=0 to 7 do begin
      B:=False;
      For J:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[J])=I then begin
        B:=True; break;
      end;
      If B then continue;
      Case I of
        0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(I));
        1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(I));
        2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(I));
        3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(I));
        4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(I));
        5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(I));
        6 : ListViewListBox.Items.AddObject(LanguageSetup.GameNotes,Pointer(I));
        7 : ListViewListBox.Items.AddObject(LanguageSetup.GameStartCount,Pointer(I));
      end;
      ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=(ColVisible[I+1]<>'0');
    end;
  finally
    ColVisibleUserSt.Free;
  end;

  UserIconLoader.DialogImage(DI_Up,ListViewUpButton);
  UserIconLoader.DialogImage(DI_Down,ListViewDownButton);
  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);

  GridLinesCheckBox.Checked:=PrgSetup.GridLinesInGamesList;
  StoreColumnWidthsCheckBox.Checked:=PrgSetup.StoreColumnWidths;

  ListViewListBoxClick(self);
end;

procedure TSetupFrameGamesListColumns.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameGamesListColumns.LoadLanguage;
Var I,J : Integer;
begin
  ListViewLabel.Caption:=LanguageSetup.SetupFormListViewInfo;
  ListViewUpButton.Hint:=RemoveUnderline(LanguageSetup.MoveUp);
  ListViewDownButton.Hint:=RemoveUnderline(LanguageSetup.MoveDown);
  AddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  DelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  GridLinesCheckBox.Caption:=LanguageSetup.SetupFormShowGridLines;
  StoreColumnWidthsCheckBox.Caption:=LanguageSetup.SetupFormStoreColumnWidths;

  For I:=0 to ListViewListBox.Items.Count-1 do begin
    J:=Integer(ListViewListBox.Items.Objects[I]);
    Case J of
      0 : ListViewListBox.Items[I]:=LanguageSetup.GameSetup;
      1 : ListViewListBox.Items[I]:=LanguageSetup.GameGenre;
      2 : ListViewListBox.Items[I]:=LanguageSetup.GameDeveloper;
      3 : ListViewListBox.Items[I]:=LanguageSetup.GamePublisher;
      4 : ListViewListBox.Items[I]:=LanguageSetup.GameYear;
      5 : ListViewListBox.Items[I]:=LanguageSetup.GameLanguage;
      6 : ListViewListBox.Items[I]:=LanguageSetup.GameNotes;
      7 : ListViewListBox.Items[I]:=LanguageSetup.GameStartCount;
    end;
  end;

  HelpContext:=ID_FileOptionsColumnsInTheGamesList;
end;

procedure TSetupFrameGamesListColumns.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameGamesListColumns.ShowFrame(const AdvancedMode: Boolean);
begin
  ListViewListBoxClick(self);
  InitPopup;
  AddButton.Visible:=(PopupMenu.Items.Count>0);
end;

procedure TSetupFrameGamesListColumns.HideFrame;
begin
end;

procedure TSetupFrameGamesListColumns.RestoreDefaults;
Var InitData : TInitData;
    S1,S2 : String;
begin
  S1:=PrgSetup.ColVisible;
  S2:=PrgSetup.ColOrder;
  try
    PrgSetup.ColVisible:='11111100';
    PrgSetup.ColOrder:='12345678';
    ListViewListBox.Items.Clear;
    InitData.GameDB:=nil;
    InitGUIAndLoadSetup(InitData);
  finally
    PrgSetup.ColVisible:=S1;
    PrgSetup.ColOrder:=S2;
  end;

  GridLinesCheckBox.Checked:=False;
  StoreColumnWidthsCheckBox.Checked:=False;
end;

procedure TSetupFrameGamesListColumns.SaveSetup;
Var S : String;
    I,J,UserCount : Integer;
    B : Boolean;
begin
  {Remove unchecked user column from list}
  I:=0;
  While I<=ListViewListBox.Items.Count-1 do begin
    If (Integer(ListViewListBox.Items.Objects[I])>=8) and (not ListViewListBox.Checked[I]) then begin
      ListViewListBox.Items.Delete(I);
      continue;
    end;
    inc(I);
  end;

  {Store column order}
  S:=''; UserCount:=0;
  For I:=0 to ListViewListBox.Items.Count-1 do begin
    J:=Integer(ListViewListBox.Items.Objects[I])+1;
    If J>=100 then begin J:=9+UserCount; inc(UserCount); end;
    Case J of
      1..9 : S:=S+IntToStr(J);
      10..35 : S:=S+Chr(Ord('A')+J-10);
    end;
  end;
  PrgSetup.ColOrder:=S;

  {Store column visible state (of the default columns, invisible user columns have already been removed}
  S:='';
  For I:=0 to 8 do begin
    B:=False;
    for J:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[J])=I then begin
      B:=ListViewListBox.Checked[J]; break;
    end;
    If B then S:=S+'1' else S:=S+'0';
  end;
  For I:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[I])>=8 then begin
    S:=S+';'+ListViewListBox.Items[I];
  end;
  PrgSetup.ColVisible:=S;

  PrgSetup.GridLinesInGamesList:=GridLinesCheckBox.Checked;
  PrgSetup.StoreColumnWidths:=StoreColumnWidthsCheckBox.Checked;
end;

procedure TSetupFrameGamesListColumns.ListViewListBoxClick(Sender: TObject);
Var I : Integer;
begin
  I:=ListViewListBox.ItemIndex;
  DelButton.Visible:=(I>=0) and (Integer(ListViewListBox.Items.Objects[I])>=8);
  ListViewUpButton.Enabled:=(I>0);
  ListViewDownButton.Enabled:=(I<ListViewListBox.Items.Count-1);
end;

procedure TSetupFrameGamesListColumns.ListViewMoveButtonClick(Sender: TObject);
Var P : TPoint;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : If ListViewListBox.ItemIndex>0 then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex-1);
          ListViewListBoxClick(Sender);
        end;
    1 : If (ListViewListBox.ItemIndex>=0) and (ListViewListBox.ItemIndex<ListViewListBox.Items.Count-1) then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex+1);
          ListViewListBoxClick(Sender);
        end;
    2 : begin
          InitPopup;
          P:=ClientToScreen(Point(AddButton.Left,AddButton.Top));
          PopupMenu.Popup(P.X+5,P.Y+5);
        end;
    3 : If (ListViewListBox.ItemIndex>=0) and (Integer(ListViewListBox.Items.Objects[ListViewListBox.ItemIndex])>=7) then begin
          ListViewListBox.Items.Delete(ListViewListBox.ItemIndex);
          InitPopup;
          AddButton.Visible:=(PopupMenu.Items.Count>0);
          ListViewListBoxClick(Sender);
        end;
    4 : begin
          S:=RemoveUnderline(TMenuItem(Sender).Caption);
          ListViewListBox.Items.AddObject(S,Pointer(100));
          ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=True;
          InitPopup;
          AddButton.Visible:=(PopupMenu.Items.Count>0);
          ListViewListBoxClick(Sender);
        end;
  end;
end;

Procedure TSetupFrameGamesListColumns.InitPopup;
Var M : TMenuItem;
    I : Integer;
begin
  PopupMenu.Items.Clear;
  For I:=0 to UserDataList.Count-1 do begin
    If ListViewListBox.Items.IndexOf(UserDataList[I])>=0 then continue;
    M:=TMenuItem.Create(PopupMenu);
    M.Caption:=MaskUnderlineAmpersand(UserDataList[I]);
    M.Tag:=4;
    M.OnClick:=ListViewMoveButtonClick;
    PopupMenu.Items.Add(M);
  end;
end;

end.
