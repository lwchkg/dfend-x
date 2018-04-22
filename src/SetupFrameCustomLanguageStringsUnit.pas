unit SetupFrameCustomLanguageStringsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, Grids, StdCtrls, Menus, SetupFormUnit, GameDBUnit;

type
  TSetupFrameCustomLanguageStrings = class(TFrame, ISetupFrame)
    TypeComboBox: TComboBox;
    Tab: TStringGrid;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    InfoLabel: TLabel;
    AddLinePopupMenu: TPopupMenu;
    EnglsihLabel: TLabel;
    procedure ButtonWork(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure TypeComboBoxChange(Sender: TObject);
    procedure TabClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LastType : Integer;
    GenreEnglish, GenreCustom, LanguageEnglish, LanguageCustom, LicenseEnglish, LicenseCustom : TStringList;
    GameDB : TGameDB;
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    Procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameCustomLanguageStrings }

Destructor TSetupFrameCustomLanguageStrings.Destroy;
begin
  GenreEnglish.Free;
  GenreCustom.Free;
  LanguageEnglish.Free;
  LanguageCustom.Free;
  LicenseEnglish.Free;
  LicenseCustom.Free;
  inherited Destroy;
end;

function TSetupFrameCustomLanguageStrings.GetName: String;
begin
  result:=LanguageSetup.SetupFormGamesListTranslations;
end;

procedure TSetupFrameCustomLanguageStrings.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(TypeComboBox);
  NoFlicker(Tab);

  LastType:=-1;
  TypeComboBox.Items.Clear;
  TypeComboBox.Items.Add('');
  TypeComboBox.Items.Add('');
  TypeComboBox.Items.Add('');

  GenreEnglish:=TStringList.Create;
  GenreCustom:=TStringList.Create;
  LanguageEnglish:=TStringList.Create;
  LanguageCustom:=TStringList.Create;
  LicenseEnglish:=TStringList.Create;
  LicenseCustom:=TStringList.Create;

  GameDB:=InitData.GameDB;

  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);
  UserIconLoader.DialogImage(DI_Up,UpButton);
  UserIconLoader.DialogImage(DI_Down,DownButton);

  HelpContext:=ID_FileOptionsGamesListTranslations;
end;

Procedure TSetupFrameCustomLanguageStrings.BeforeChangeLanguage;
begin
  TypeComboBoxChange(self);

  LanguageSetupEnglishGenres.Clear;
  LanguageSetupEnglishGenres.AddStrings(GenreEnglish);
  LanguageSetupCustomGenres.Clear;
  LanguageSetupCustomGenres.AddStrings(GenreCustom);
  LanguageSetupEnglishLanguages.Clear;
  LanguageSetupEnglishLanguages.AddStrings(LanguageEnglish);
  LanguageSetupCustomLanguages.Clear;
  LanguageSetupCustomLanguages.AddStrings(LanguageCustom);
  LanguageSetupEnglishLicenses.Clear;
  LanguageSetupEnglishLicenses.AddStrings(LicenseEnglish);
  LanguageSetupCustomLicenses.Clear;
  LanguageSetupCustomLicenses.AddStrings(LicenseCustom);

  SaveGameListTranslations;
end;

procedure TSetupFrameCustomLanguageStrings.LoadLanguage;
Var I : Integer;
    Engl : Boolean;
begin
  I:=TypeComboBox.ItemIndex;
  TypeComboBox.Items[0]:=LanguageSetup.GameGenre;
  TypeComboBox.Items[1]:=LanguageSetup.GameLanguage;
  TypeComboBox.Items[2]:=LanguageSetup.GameLicense;
  TypeComboBox.ItemIndex:=I;

  AddButton.Hint:=LanguageSetup.AddNewEmptyLine;
  DelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  UpButton.Hint:=LanguageSetup.MoveUp;
  DownButton.Hint:=LanguageSetup.MoveDown;

  Tab.Cells[0,0]:=LanguageSetup.SetupFormGamesListTranslationsEnglish;
  Tab.Cells[1,0]:=LanguageSetup.SetupFormGamesListTranslationsCustom;

  InfoLabel.Caption:=LanguageSetup.SetupFormGamesListTranslationsInfo;

  GenreEnglish.Clear;
  GenreCustom.Clear;
  LanguageEnglish.Clear;
  LanguageCustom.Clear;
  LicenseEnglish.Clear;
  LicenseCustom.Clear;

  GenreEnglish.AddStrings(LanguageSetupEnglishGenres);
  GenreCustom.AddStrings(LanguageSetupCustomGenres);
  While GenreEnglish.Count<GenreCustom.Count do GenreEnglish.Add('');
  While GenreEnglish.Count>GenreCustom.Count do GenreCustom.Add('');
  LanguageEnglish.AddStrings(LanguageSetupEnglishLanguages);
  LanguageCustom.AddStrings(LanguageSetupCustomLanguages);
  While LanguageEnglish.Count<LanguageCustom.Count do LanguageEnglish.Add('');
  While LanguageEnglish.Count>LanguageCustom.Count do LanguageCustom.Add('');
  LicenseEnglish.AddStrings(LanguageSetupEnglishLicenses);
  LicenseCustom.AddStrings(LanguageSetupCustomLicenses);
  While LicenseEnglish.Count<LicenseCustom.Count do LicenseEnglish.Add('');
  While LicenseEnglish.Count>LicenseCustom.Count do LicenseCustom.Add('');

  LastType:=-1;
  TypeComboBoxChange(self);

  Engl:=(ExtUpperCase(LanguageSetup.LocalLanguageName)='ENGLISH');
  EnglsihLabel.Visible:=Engl;
  TypeComboBox.Visible:=not Engl;
  AddButton.Visible:=not Engl;
  DelButton.Visible:=not Engl;
  UpButton.Visible:=not Engl;
  DownButton.Visible:=not Engl;
  Tab.Visible:=not Engl;
  InfoLabel.Visible:=not Engl;
end;

procedure TSetupFrameCustomLanguageStrings.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameCustomLanguageStrings.ShowFrame(const AdvancedMode: Boolean);
Var Engl : Boolean;
begin
  FrameResize(Self);
  LastType:=-1;
  TypeComboBox.ItemIndex:=0;
  TypeComboBoxChange(self);

  Engl:=(ExtUpperCase(LanguageSetup.LocalLanguageName)='ENGLISH');
  EnglsihLabel.Visible:=Engl;
  TypeComboBox.Visible:=True; TypeComboBox.Visible:=not Engl;
  AddButton.Visible:=not Engl;
  DelButton.Visible:=not Engl;
  UpButton.Visible:=not Engl;
  DownButton.Visible:=not Engl;
  Tab.Visible:=True; Tab.Visible:=not Engl;
  InfoLabel.Visible:=not Engl;
end;

procedure TSetupFrameCustomLanguageStrings.HideFrame;
begin
  TypeComboBoxChange(self);
end;

procedure TSetupFrameCustomLanguageStrings.RestoreDefaults;
Var DefaultGenreEnglish, DefaultGenreCustom, DefaultLanguageEnglish, DefaultLanguageCustom, DefaultLicenseEnglish, DefaultLicenseCustom : TStringList;
begin
  GetDefaultGameListTranslations(DefaultGenreEnglish,DefaultGenreCustom,DefaultLanguageEnglish,DefaultLanguageCustom,DefaultLicenseEnglish,DefaultLicenseCustom);

  try
    GenreEnglish.Clear;
    GenreCustom.Clear;
    LanguageEnglish.Clear;
    LanguageCustom.Clear;
    LicenseEnglish.Clear;
    LicenseCustom.Clear;

    GenreEnglish.AddStrings(DefaultGenreEnglish);
    GenreCustom.AddStrings(DefaultGenreCustom);
    While GenreEnglish.Count<GenreCustom.Count do GenreEnglish.Add('');
    While GenreEnglish.Count>GenreCustom.Count do GenreCustom.Add('');
    LanguageEnglish.AddStrings(DefaultLanguageEnglish);
    LanguageCustom.AddStrings(DefaultLanguageCustom);
    While LanguageEnglish.Count<LanguageCustom.Count do LanguageEnglish.Add('');
    While LanguageEnglish.Count>LanguageCustom.Count do LanguageCustom.Add('');
    LicenseEnglish.AddStrings(DefaultLicenseEnglish);
    LicenseCustom.AddStrings(DefaultLicenseCustom);
    While LicenseEnglish.Count<LicenseCustom.Count do LicenseEnglish.Add('');
    While LicenseEnglish.Count>LicenseCustom.Count do LicenseCustom.Add('');

    LastType:=-1;
    TypeComboBoxChange(self);
  finally
    DefaultGenreEnglish.Free;
    DefaultGenreCustom.Free;
    DefaultLanguageEnglish.Free;
    DefaultLanguageCustom.Free;
  end;
end;

procedure TSetupFrameCustomLanguageStrings.SaveSetup;
begin
  BeforeChangeLanguage;
end;

procedure TSetupFrameCustomLanguageStrings.FrameResize(Sender: TObject);
begin
  Tab.ColWidths[0]:=(Tab.ClientWidth-20) div 2;
  Tab.ColWidths[1]:=(Tab.ClientWidth-20) div 2;
end;

procedure TSetupFrameCustomLanguageStrings.ButtonWork(Sender: TObject);
Var I,J : Integer;
    S : String;
    St : TStringList;
    M : TMenuItem;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          {Add button}
          Case TypeComboBox.ItemIndex of
            0 : St:=GameDB.GetGenreList;
            1 : St:=GameDB.GetLanguageList;
            2 : St:=GameDB.GetLicenseList;
            else St:=TStringList.Create;
          End;
          try
            I:=0;
            While I<St.Count do begin
              S:=Trim(ExtUpperCase(St[I]));
              For J:=1 to Tab.RowCount-1 do If Trim(ExtUpperCase(Tab.Cells[0,J]))=S then begin St.Delete(I); dec(I); break; end;
              inc(I);
            end;
            If St.Count=0 then begin
              Tab.RowCount:=Tab.RowCount+1;
              Tab.Row:=Tab.RowCount-1;
              Tab.Col:=0;
              Tab.SetFocus;
              exit;
            end else begin
              AddLinePopupMenu.Items.Clear;
              M:=TMenuItem.Create(AddLinePopupMenu); M.Caption:=LanguageSetup.AddNewEmptyLine; M.Tag:=-1; M.OnClick:=ButtonWork;
              AddLinePopupMenu.Items.Add(M);
              M:=TMenuItem.Create(AddLinePopupMenu); M.Caption:='-';
              AddLinePopupMenu.Items.Add(M);
              For I:=0 to St.Count-1 do begin
                M:=TMenuItem.Create(AddLinePopupMenu); M.Caption:=MaskUnderlineAmpersand(St[I]); M.Tag:=-2; M.OnClick:=ButtonWork;
                AddLinePopupMenu.Items.Add(M);
              end;
            end;
          finally
            St.Free;
          end;
          P:=ClientToScreen(Point((Sender as TControl).Left,(Sender as TControl).Top));
          AddLinePopupMenu.Popup(P.X+5,P.Y+5);
        end;
   -1 : begin
          {Add empty line}
          Tab.RowCount:=Tab.RowCount+1;
          Tab.Row:=Tab.RowCount-1;
          Tab.Col:=0;
          Tab.Cells[0,Tab.Row]:=''; Tab.Cells[1,Tab.Row]:='';
          Tab.SetFocus;
         end;
   -2 : begin
          {Add used name}
          If (Trim(Tab.Cells[0,Tab.RowCount-1])<>'') or (Trim(Tab.Cells[1,Tab.RowCount-1])<>'') then Tab.RowCount:=Tab.RowCount+1;
          Tab.Row:=Tab.RowCount-1;
          Tab.Col:=0;
          Tab.Cells[0,Tab.Row]:=RemoveUnderline((Sender as TMenuItem).Caption); Tab.Cells[1,Tab.Row]:='';
          Tab.Col:=1;
          Tab.SetFocus;
        end;
    1 : If (Tab.RowCount>2) and (Tab.Row>0) then begin
          {Del button}
          For I:=Tab.Row+1 to Tab.RowCount-1 do begin Tab.Cells[0,I-1]:=Tab.Cells[0,I]; Tab.Cells[1,I-1]:=Tab.Cells[1,I]; end;
          Tab.Row:=Max(1,Tab.Row-1);
          Tab.RowCount:=Tab.RowCount-1;
        end;
    2 : If Tab.Row>1 then begin
          {Up button}
          S:=Tab.Cells[0,Tab.Row]; Tab.Cells[0,Tab.Row]:=Tab.Cells[0,Tab.Row-1]; Tab.Cells[0,Tab.Row-1]:=S;
          S:=Tab.Cells[1,Tab.Row]; Tab.Cells[1,Tab.Row]:=Tab.Cells[1,Tab.Row-1]; Tab.Cells[1,Tab.Row-1]:=S;
          Tab.Row:=Tab.Row-1;
        end;
    3 : If (Tab.Row>=1) and (Tab.Row<Tab.RowCount-1) then begin
          {Down button}
          S:=Tab.Cells[0,Tab.Row]; Tab.Cells[0,Tab.Row]:=Tab.Cells[0,Tab.Row+1]; Tab.Cells[0,Tab.Row+1]:=S;
          S:=Tab.Cells[1,Tab.Row]; Tab.Cells[1,Tab.Row]:=Tab.Cells[1,Tab.Row+1]; Tab.Cells[1,Tab.Row+1]:=S;
          Tab.Row:=Tab.Row+1;
        end;
  end;

  TabClick(Sender);
end;

procedure TSetupFrameCustomLanguageStrings.TabClick(Sender: TObject);
begin
  DelButton.Enabled:=(goEditing in Tab.Options) and (Tab.RowCount>2);
  UpButton.Enabled:=(goEditing in Tab.Options) and (Tab.Row>1);
  DownButton.Enabled:=(goEditing in Tab.Options) and (Tab.Row<Tab.RowCount-1) and (Tab.RowCount>2);
end;

procedure TSetupFrameCustomLanguageStrings.TypeComboBoxChange(Sender: TObject);
Var I : Integer;
begin
  Case LastType of
    0 : begin
          GenreEnglish.Clear;
          GenreCustom.Clear;
          For I:=1 to Tab.RowCount-1 do begin GenreEnglish.Add(Tab.Cells[0,I]); GenreCustom.Add(Tab.Cells[1,I]); end;
        end;
    1 : begin
          LanguageEnglish.Clear;
          LanguageCustom.Clear;
          For I:=1 to Tab.RowCount-1 do begin LanguageEnglish.Add(Tab.Cells[0,I]); LanguageCustom.Add(Tab.Cells[1,I]); end;
        end;
    2 : begin
          LicenseEnglish.Clear;
          LicenseCustom.Clear;
          For I:=1 to Tab.RowCount-1 do begin LicenseEnglish.Add(Tab.Cells[0,I]); LicenseCustom.Add(Tab.Cells[1,I]); end;
        end;
  end;

  LastType:=TypeComboBox.ItemIndex;
  Tab.RowCount:=2;
  Tab.Cells[0,1]:='';
  Tab.Cells[1,1]:='';
  If LastType<0 then begin
    Tab.Options:=Tab.Options-[goEditing];
    TabClick(Sender);
    exit;
  end;

  Tab.Options:=Tab.Options+[goEditing];
  Case LastType of
    0 : begin
          If GenreEnglish.Count=0 then exit;
          Tab.RowCount:=1+GenreEnglish.Count;
          For I:=0 to GenreEnglish.Count-1 do begin Tab.Cells[0,1+I]:=GenreEnglish[I]; Tab.Cells[1,1+I]:=GenreCustom[I]; end;
        end;
    1 : begin
          If LanguageEnglish.Count=0 then exit;
          Tab.RowCount:=1+LanguageEnglish.Count;
          For I:=0 to LanguageEnglish.Count-1 do begin Tab.Cells[0,1+I]:=LanguageEnglish[I]; Tab.Cells[1,1+I]:=LanguageCustom[I]; end;
        end;
    2 : begin
          If LicenseEnglish.Count=0 then exit;
          Tab.RowCount:=1+LicenseEnglish.Count;
          For I:=0 to LicenseEnglish.Count-1 do begin Tab.Cells[0,1+I]:=LicenseEnglish[I]; Tab.Cells[1,1+I]:=LicenseCustom[I]; end;
        end;
  end;

  TabClick(Sender);
end;

end.
