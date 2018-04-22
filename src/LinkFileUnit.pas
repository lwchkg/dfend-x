unit LinkFileUnit;
interface

uses Classes, Menus, GameDBUnit;

Type TLinkList=class
  private
    FHelpID : Integer;
    FAllowLinesAndSubs, FFixedNumber : Boolean;
    FShortCutForFirstLink : TShortCut;
    FParentMenuItems, FMenuItemsEditIcons : TList;
    Procedure DataChanged(Sender : TObject);
    function GetCount: Integer;
    function GetLink(I: Integer): String;
    function GetName(I: Integer): String;
    Procedure CreateAndAddUserMenuItems(const Owner : TComponent; const Tag : Integer; const OnClick : TNotifyEvent);
    Procedure CreateAndAddEditMenuItem(const Owner : TComponent; const EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer);
    Procedure MenuClick(Sender : TObject);
  protected
    FDataNames, FDataLinks : TStringList;
    FChanged : Boolean;    
    Procedure LoadData; virtual; abstract;
    Procedure SaveData; virtual; abstract;
  public
    Constructor Create(const AAllowLinesAndSubs : Boolean; const AFixedNumber : Boolean; const AHelpID : Integer; const AShortCutForFirstLink : TShortCut);
    Destructor Destroy; override;
    Function EditFile(const AllowLines : Boolean) : Boolean;
    Function IndexOf(const AName : String) : Integer;
    Procedure MoveToTop(const AName : String);
    Class Procedure ClearLinksMenu(const Menu : TMenuItem); overload;
    Class Procedure ClearLinksMenu(const Menu : TPopupMenu); overload;
    Procedure AddLinksToMenu(const Menu : TMenuItem; const Tag, EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer); overload;
    Procedure AddLinksToMenu(const Menu : TPopupMenu; const Tag, EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer); overload;
    Procedure AddLinksToMenu(const Menu : TMenuItem; const EditImage : Integer); overload;
    Procedure AddLinksToMenu(const Menu : TPopupMenu; const EditImage : Integer); overload;
    property Count : Integer read GetCount;
    property Name[I : Integer] : String read GetName;
    property Link[I : Integer] : String read GetLink;
    property Changed : Boolean read FChanged;
    property HelpIP : Integer read FHelpID write FHelpID;
    property AllowLinesAndSubs : Boolean read FAllowLinesAndSubs write FAllowLinesAndSubs;
end;

Type TLinkFile=class(TLinkList)
  private
    FFileNameOnly : String;
  protected
    Procedure LoadData; override;
    Procedure SaveData; override;
  public
    Constructor Create(const AFileNameOnly : String; const AAllowLinesAndSubs : Boolean; const AHelpID : Integer);
end;

Type TGameLinks=class(TLinkList)
  private
    FGame : TGame;
  protected
    Procedure LoadData; override;
    Procedure SaveData; override;
  public
    Constructor Create(const AGame : TGame);
end;

Procedure OpenLink(const Link, GameNamePlaceHolder, RealGameName : String);

implementation

uses Windows, SysUtils, Forms, ShellAPI, Math, PrgSetupUnit, CommonTools,
     LanguageSetupUnit, LinkFileEditFormUnit, PrgConsts;

{ TLinkList }

constructor TLinkList.Create(const AAllowLinesAndSubs: Boolean; const AFixedNumber : Boolean; const AHelpID: Integer; const AShortCutForFirstLink : TShortCut);
begin
  inherited Create;
  FAllowLinesAndSubs:=AAllowLinesAndSubs;
  FFixedNumber:=AFixedNumber;
  FHelpID:=AHelpID;
  FShortCutForFirstLink:=AShortCutForFirstLink;
  FDataNames:=TStringList.Create;
  FDataLinks:=TStringList.Create;
  FDataNames.OnChange:=DataChanged;
  FDataLinks.OnChange:=DataChanged;
  FChanged:=False;

  FParentMenuItems:=TList.Create;
  FMenuItemsEditIcons:=TList.Create;
end;

destructor TLinkList.Destroy;
begin
  If FChanged then SaveData;
  FDataNames.Free;
  FDataLinks.Free;
  FParentMenuItems.Free;
  FMenuItemsEditIcons.Free;
  inherited Destroy;
end;

procedure TLinkList.DataChanged(Sender: TObject);
begin
  FChanged:=True;
end;

function TLinkList.GetCount: Integer;
begin
  result:=FDataNames.Count;
end;

function TLinkList.GetName(I: Integer): String;
begin
  If (I<0) or (I>=FDataNames.Count) then result:='' else result:=FDataNames[I];
end;

function TLinkList.GetLink(I: Integer): String;
begin
  If (I<0) or (I>=FDataLinks.Count) then result:='' else result:=FDataLinks[I];
end;

function TLinkList.IndexOf(const AName: String): Integer;
Var I : Integer;
    S : String;
begin
  S:=RemoveUnderline(AName);
  result:=-1;
  For I:=0 to FDataNames.Count-1 do If FDataNames[I]=S then begin result:=I; break; end;
end;

procedure TLinkList.MenuClick(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    1 : If Trim((Sender as TMenuItem).Hint)<>'' then begin
          S:=Trim((Sender as TMenuItem).Hint);
          If ExtUpperCase(Copy(S,1,7))<>'HTTP:/'+'/' then S:='http:/'+'/'+S;
          ShellExecute(Application.MainForm.Handle,'open',PChar(S),nil,nil,SW_SHOW);
        end;
    2 : If EditFile(FAllowLinesAndSubs) then For I:=0 to FParentMenuItems.Count-1 do begin
          If (TComponent(FParentMenuItems[I]) is TMenuItem)
            then AddLinksToMenu(TMenuItem(FParentMenuItems[I]),Integer(FMenuItemsEditIcons[I]))
            else AddLinksToMenu(TPopupMenu(FParentMenuItems[I]),Integer(FMenuItemsEditIcons[I]));
        end;
  end;
end;

procedure TLinkList.MoveToTop(const AName: String);
Var I : Integer;
begin
  I:=IndexOf(AName); If I>=0 then begin FDataNames.Exchange(0,I); FDataLinks.Exchange(0,I); end;
end;

function TLinkList.EditFile(const AllowLines : Boolean): Boolean;
Var SaveCount : Integer;
begin
  SaveCount:=FDataNames.Count;
  result:=ShowLinkFileEditDialog(Application.MainForm,FDataNames,FDataLinks,AllowLines,FFixedNumber,FHelpID);
  If FFixedNumber then begin
    While FDataNames.Count>SaveCount do begin FDataNames.Delete(FDataNames.Count-1); FDataLinks.Delete(FDataLinks.Count-1); end;
    While FDataNames.Count<SaveCount do begin FDataNames.Add(''); FDataLinks.Add(''); end;
  end;
  If result then SaveData;
end;

Function GetLevel(const S : String) : Integer;
Var I : Integer;
begin
  result:=0;
  For I:=1 to length(S) do If S[I]='=' then inc(result) else exit;
end;

Procedure TLinkList.CreateAndAddUserMenuItems(const Owner : TComponent; const Tag : Integer; const OnClick : TNotifyEvent);
Var I,L : Integer;
    Last,M : TMenuItem;
    Level : Array of TMenuItem;
begin
  SetLength(Level,0); Last:=nil;

  For I:=0 to FDataNames.Count-1 do begin
    If ((Trim(Name[I])='') or (Trim(Name[I])='-')) and FAllowLinesAndSubs then begin
      If I=FDataNames.Count-1 then continue;
      SetLength(Level,Min(GetLevel(Name[I+1]),length(Level)));
      M:=TMenuItem.Create(Owner.Owner);
      M.Caption:='-';
      If length(Level)=0 then begin
        If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);
      end else begin
        Level[length(Level)-1].OnClick:=nil;
        Level[length(Level)-1].Add(M);
      end;
      continue;
    end;

    If (Trim(Name[I])='') or (Trim(Name[I])='-') then continue;

    M:=TMenuItem.Create(Owner.Owner);

    If (Last<>nil) and FAllowLinesAndSubs then begin
      L:=Min(GetLevel(Name[I]),length(Level)+1);
      If L=length(Level)+1 then begin SetLength(Level,L); Level[L-1]:=Last; end else SetLength(Level,L);
    end;

    M.Caption:=Copy(Name[I],GetLevel(Name[I])+1,MaxInt);
    M.Hint:=Link[I];
    M.Tag:=Tag;
    M.OnClick:=OnClick;

    If (Last=nil) and (FShortCutForFirstLink<>0) then M.ShortCut:=FShortCutForFirstLink;

    If length(Level)=0 then begin
      If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);
    end else begin
      Level[length(Level)-1].OnClick:=nil;
      Level[length(Level)-1].Add(M);
    end;

    Last:=M;
  end;
end;

Procedure TLinkList.CreateAndAddEditMenuItem(const Owner : TComponent; const EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer);
Var M : TMenuItem;
begin
  M:=TMenuItem.Create(Owner.Owner);
  M.Caption:='-';
  If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);

  M:=TMenuItem.Create(Owner.Owner);
  M.Caption:=LanguageSetup.MenuProfileSearchGameEditLinks;
  M.Tag:=EditTag;
  M.OnClick:=OnClick;
  M.ImageIndex:=EditImage;
  If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);
end;

class procedure TLinkList.ClearLinksMenu(const Menu: TMenuItem);
begin
  While Menu.Count>0 do Menu.Items[0].Free;
end;

class procedure TLinkList.ClearLinksMenu(const Menu: TPopupMenu);
begin
  While Menu.Items.Count>0 do Menu.Items[0].Free;
end;

procedure TLinkList.AddLinksToMenu(const Menu: TMenuItem; const Tag, EditTag: Integer; const OnClick: TNotifyEvent; const EditImage: Integer);
begin
  If FParentMenuItems.IndexOf(Menu)<0 then begin
    FParentMenuItems.Add(Menu);
    FMenuItemsEditIcons.Add(Pointer(EditImage));
  end else begin
    FMenuItemsEditIcons[FParentMenuItems.IndexOf(Menu)]:=Pointer(EditImage);
  end;
  ClearLinksMenu(Menu);
  CreateAndAddUserMenuItems(Menu,Tag,OnClick);
  CreateAndAddEditMenuItem(Menu,EditTag,OnClick,EditImage);
end;

procedure TLinkList.AddLinksToMenu(const Menu: TPopupMenu; const Tag, EditTag: Integer; const OnClick: TNotifyEvent; const EditImage: Integer);
begin
  If Menu=nil then exit;
  If FParentMenuItems.IndexOf(Menu)<0 then begin
    FParentMenuItems.Add(Menu);
    FMenuItemsEditIcons.Add(Pointer(EditImage));
  end else begin
    FMenuItemsEditIcons[FParentMenuItems.IndexOf(Menu)]:=Pointer(EditImage);
  end;
  ClearLinksMenu(Menu);
  CreateAndAddUserMenuItems(Menu,Tag,OnClick);
  CreateAndAddEditMenuItem(Menu,EditTag,OnClick,EditImage);
end;

procedure TLinkList.AddLinksToMenu(const Menu: TMenuItem; const EditImage: Integer);
begin
  AddLinksToMenu(Menu,1,2,MenuClick,EditImage);
end;

procedure TLinkList.AddLinksToMenu(const Menu: TPopupMenu; const EditImage: Integer);
begin
  AddLinksToMenu(Menu,1,2,MenuClick,EditImage);
end;

{ TLinkFile }

constructor TLinkFile.Create(const AFileNameOnly: String; const AAllowLinesAndSubs : Boolean; const AHelpID : Integer);
begin
  inherited Create(AAllowLinesAndSubs,False,AHelpID,0);
  FFileNameOnly:=AFileNameOnly;
  LoadData;
end;

procedure TLinkFile.LoadData;
Var S : String;
    FSt : TStringList;
    I : Integer;
begin
  S:='';
  If FileExists(PrgDataDir+SettingsFolder+'\'+FFileNameOnly) then S:=PrgDataDir+SettingsFolder+'\'+FFileNameOnly;
  If (S='') and FileExists(PrgDataDir+FFileNameOnly) then S:=PrgDataDir+FFileNameOnly;
  If (S='') and FileExists(PrgDir+FFileNameOnly) then S:=PrgDir+FFileNameOnly;
  If (S='') and FileExists(PrgDir+BinFolder+'\'+FFileNameOnly) then S:=PrgDir+BinFolder+'\'+FFileNameOnly;
  If S='' then exit;

  FSt:=TStringList.Create;
  try
    try FSt.LoadFromFile(S); except exit; end;
    For I:=0 to FSt.Count-1 do begin
      S:=Trim(FSt[I]);
      If S='' then continue;
      If (S='-') or (S='---') then begin FDataNames.Add(''); FDataLinks.Add(''); end;
      If Pos(';',S)=0 then continue;
      FDataNames.Add(Trim(Copy(S,1,Pos(';',S)-1)));
      FDataLinks.Add(Trim(Copy(S,Pos(';',S)+1,MaxInt)));
    end;
  finally
    FSt.Free;
  end;

  FChanged:=False;
end;

procedure TLinkFile.SaveData;
Var FSt : TStringList;
    I : Integer;
begin
  FSt:=TStringList.Create;
  try
    For I:=0 to FDataNames.Count-1 do If Trim(FDataNames[I])='' then FSt.Add('---') else FSt.Add(FDataNames[I]+';'+FDataLinks[I]);
    try FSt.SaveToFile(PrgDataDir+SettingsFolder+'\'+FFileNameOnly); except end;
  finally
    FSt.Free;
  end;
  FChanged:=False;
end;

{ TGameLinks }

constructor TGameLinks.Create(const AGame: TGame);
begin
  inherited Create(False,True,-1,ShortCut(Ord('W'),[ssCtrl]));
  FGame:=AGame;
  LoadData;
end;

procedure TGameLinks.LoadData;
Var I : Integer;
begin
  For I:=1 to 9 do begin
    FDataNames.Add(FGame.WWWName[I]);
    FDataLinks.Add(FGame.WWW[I]);
  end;
  FChanged:=False;
end;

procedure TGameLinks.SaveData;
Var I : Integer;
begin
  For I:=1 to 9 do begin
    FGame.WWWName[I]:=FDataNames[I-1];
    FGame.WWW[I]:=FDataLinks[I-1];
  end;
  FGame.StoreAllValues;
  FChanged:=False;
end;

{ global }

Procedure OpenLink(const Link, GameNamePlaceHolder, RealGameName : String);
Var S,T,U : String;
    I : Integer;
begin
  S:=ExtUpperCase(Link);
  T:=ExtUpperCase(GameNamePlaceHolder);
  I:=Pos(T,S);
  If I=0 then exit;

  S:=Copy(Link,1,I-1);
  T:=Copy(Link,I+length(GameNamePlaceHolder),MaxInt);

  For I:=1 to length(RealGameName) do begin
    If Pos(RealGameName[I],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890')<>0
      then U:=U+RealGameName[I]
      else U:=U+'%'+IntToHex(Ord(RealGameName[I]),2);
  end;

  ShellExecute(Application.MainForm.Handle,'open',PChar(S+U+T),nil,nil,SW_SHOW);
end;

end.
