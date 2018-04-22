unit CreateConfFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, Menus, GameDBUnit;

type
  TCreateConfForm = class(TForm)
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    FolderEdit: TLabeledEdit;
    SelectFolderButton: TSpeedButton;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    HelpButton: TBitBtn;
    ExportAutoSetupTemplatesCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SelectFolderButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Procedure SelectGamesWithoutTemplate;
    Function FindAutoSetupForGame(const Game : TGame; const AutoSetupDB : TGameDB) : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    ProfFileMode : Boolean;
  end;

var
  CreateConfForm: TCreateConfForm;

Function ExportConfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
Function ExportProfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, DosBoxUnit, CommonTools,
     PrgSetupUnit, GameDBToolsUnit, ScummVMUnit, HelpConsts, TemplateFormUnit,
     IconLoaderUnit, PrgConsts, HashCalc;

{$R *.dfm}

procedure TCreateConfForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CreateConfForm;
  InfoLabel.Caption:=LanguageSetup.CreateConfFormInfo;
  FolderEdit.EditLabel.Caption:=LanguageSetup.CreateConfFormSelectFolder;
  SelectFolderButton.Hint:=LanguageSetup.ChooseFolder;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  ExportAutoSetupTemplatesCheckBox.Caption:=LanguageSetup.CreateConfFormAutoSetup;
  UserIconLoader.DialogImage(DI_SelectFolder,SelectFolderButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  ProfFileMode:=False;
end;

procedure TCreateConfForm.FormShow(Sender: TObject);
Var M : TMenuItem;
begin
  If ProfFileMode then begin
    Caption:=LanguageSetup.CreateConfFormProfMode;
    InfoLabel.Caption:=LanguageSetup.CreateConfFormInfoProfMode;
    FolderEdit.EditLabel.Caption:=LanguageSetup.CreateConfFormSelectFolderProfMode;
    ExportAutoSetupTemplatesCheckBox.Visible:=True;
  end;

  BuildCheckList(ListBox,GameDB,True,False,True);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,True,True);

  M:=TMenuItem.Create(self); M.Caption:='-';
  PopupMenu.Items[0].Add(M);
  M:=TMenuItem.Create(self); M.Caption:=LanguageSetup.CreateConfFormSelectGamesWithoutAutoSetup; M.Tag:=-2; M.OnClick:=SelectButtonClick;
  PopupMenu.Items[0].Add(M);

  FolderEdit.Text:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
end;

procedure TCreateConfForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  If Sender is TMenuItem then begin
    If (Sender as TMenuItem).Tag=-2 then begin
      SelectGamesWithoutTemplate;
      ExportAutoSetupTemplatesCheckBox.Checked:=True;
    end else begin
      SelectGamesByPopupMenu(Sender,ListBox);
    end;
  end;
end;

procedure TCreateConfForm.SelectFolderButtonClick(Sender: TObject);
Var S : String;
begin
  S:=FolderEdit.Text; If S='' then S:=PrgDataDir;
  if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then FolderEdit.Text:=S;
end;

function TCreateConfForm.FindAutoSetupForGame(const Game: TGame; const AutoSetupDB: TGameDB): Boolean;
Var I,J : Integer;
    File1,File2,Hash1,Hash2,S : String;
    Files, Hashs : TStringList;
    A : TGame;
    Rec : TSearchRec;
begin
  If Trim(Game.GameExe)='' then begin result:=False; exit; end;
  result:=True;

  {Level 1: Check if there is an auto setup template matching with exactly the same files to start}

  {Calc Hash values}
  File1:=Trim(ExtUpperCase(ExtractFileName(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir))));
  Hash1:=GetMD5Sum(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir),False);
  If Trim(Game.SetupExe)<>'' then begin
    File2:=Trim(ExtUpperCase(ExtractFileName(MakeAbsPath(Game.SetupExe,PrgSetup.BaseDir))));
    Hash2:=GetMD5Sum(MakeAbsPath(Game.SetupExe,PrgSetup.BaseDir),False)
  end else begin
    File2:='';
    Hash2:='';
  end;

  {Check auto setup templates}
  for I:=0 to AutoSetupDB.Count-1 do begin
    A:=AutoSetupDB[I]; If (A.GameExe='') or (A.GameExeMD5='') then continue;
    If (Trim(ExtUpperCase(A.GameExe))<>File1) or (A.GameExeMD5<>Hash1) then continue;
    If (Trim(A.SetupExe)<>'') and (File2<>'') then begin
      If (Trim(ExtUpperCase(A.SetupExe))<>File2) or (A.SetupExeMD5<>Hash2) then continue;
    end;
    exit;
  end;

  {Level 2: Check if there is an auto setup template matching the game but using some other files to start (game.exe -> start.bat for example)}

  {Calc Hash values}
  Files:=TStringList.Create;
  Hashs:=TStringList.Create;
  try
    S:=IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir)));
    I:=FindFirst(S+'*.exe',faAnyFile,Rec);
    try While I=0 do begin Files.Add(ExtUpperCase(Rec.Name)); Hashs.Add(GetMD5Sum(S+Rec.Name,False)); I:=FindNext(Rec); end;
    finally FindClose(Rec); end;
    I:=FindFirst(S+'*.com',faAnyFile,Rec);
    try While I=0 do begin Files.Add(ExtUpperCase(Rec.Name)); Hashs.Add(GetMD5Sum(S+Rec.Name,False)); I:=FindNext(Rec); end;
    finally FindClose(Rec); end;
    I:=FindFirst(S+'*.bat',faAnyFile,Rec);
    try While I=0 do begin Files.Add(ExtUpperCase(Rec.Name)); Hashs.Add(GetMD5Sum(S+Rec.Name,False)); I:=FindNext(Rec); end;
    finally FindClose(Rec); end;

    {Check auto setup templates}
    for I:=0 to AutoSetupDB.Count-1 do begin
      A:=AutoSetupDB[I]; If (A.GameExe='') or (A.GameExeMD5='') then continue;

      J:=Files.IndexOf(Trim(ExtUpperCase(A.GameExe)));
      If (J<0) or (Hashs[J]<>A.GameExeMD5) then continue;
      If Trim(A.SetupExe)<>'' then begin
        J:=Files.IndexOf(Trim(ExtUpperCase(A.SetupExe)));
        If (J<0) or (Hashs[J]<>A.SetupExeMD5) then continue;
      end;
      exit;
    end;
  finally
    Files.Free;
    Hashs.Free;
  end;

  {Nothing found}
  result:=False;
end;

procedure TCreateConfForm.SelectGamesWithoutTemplate;
Var I : Integer;
    G : TGame;
    AutoSetupDB : TGameDB;
begin
  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  try
    For I:=0 to ListBox.Items.Count-1 do If not ListBox.Checked[I] then begin
      G:=TGame(ListBox.Items.Objects[I]);
      If ScummVMMode(G) or WindowsExeMode(G) then continue;
      If G.Name=DosBoxDOSProfile then continue;
      If not FindAutoSetupForGame(G,AutoSetupDB) then ListBox.Checked[I]:=True;
    end;
  finally
    AutoSetupDB.Free;
  end;
end;

procedure TCreateConfForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    G,G2 : TGame;
    Dir,S : String;
    St : TStringList;
begin
  Dir:=IncludeTrailingPathDelimiter(FolderEdit.Text);

  if not ForceDirectories(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
    ModalResult:=mrNone;
    exit;
  end;

  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    If ProfFileMode then begin
      G.StoreAllValues;
      If ExportAutoSetupTemplatesCheckBox.Checked then begin
        {export as auto setup template}
        If ScummVMMode(G) then continue;
        CreateGameCheckSum(G,False);
        CreateSetupCheckSum(G,False);
        AddAdditionalChecksumDataToAutoSetupTemplate(G);
        G2:=TGame.Create(Dir+ExtractFileName(G.SetupFile));
        try
          G2.AssignFrom(G);
          RemoveNonAutoSetupValues(G2);
          G2.LoadCache;
          G2.StoreAllValues;
        finally
          G2.Free;
        end;
      end else begin
        {just copy profile file}
        If not CopyFile(PChar(G.SetupFile),PChar(Dir+ExtractFileName(G.SetupFile)),True) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[G.SetupFile,Dir+ExtractFileName(G.SetupFile)]),mtError,[mbOK],0);
          ModalResult:=mrNone;
          exit;
        end;
      end;
    end else begin
      If ScummVMMode(G) then begin
        S:=Dir+ChangeFileExt(ExtractFileName(G.SetupFile),'.ini');
        St:=BuildScummVMIniFile(G);
      end else begin
        S:=Dir+ChangeFileExt(ExtractFileName(G.SetupFile),'.conf');
        St:=BuildConfFile(G,False,False,-1,nil,false);
        If St=nil then continue;
      end;
      try
        try St.SaveToFile(S); except
          MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0);
          ModalResult:=mrNone;
          exit;
        end;
      finally
        St.Free;
      end;
    end;
  end;
end;

procedure TCreateConfForm.HelpButtonClick(Sender: TObject);
begin
  If ProfFileMode
    then Application.HelpCommand(HELP_CONTEXT,ID_FileExportProf)
    else Application.HelpCommand(HELP_CONTEXT,ID_FileExportConf);
end;

procedure TCreateConfForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ExportConfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  CreateConfForm:=TCreateConfForm.Create(AOwner);
  try
    CreateConfForm.GameDB:=AGameDB;
    result:=(CreateConfForm.ShowModal=mrOK);
  finally
    CreateConfForm.Free;
  end;
end;

Function ExportProfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  CreateConfForm:=TCreateConfForm.Create(AOwner);
  try
    CreateConfForm.ProfFileMode:=True;
    CreateConfForm.GameDB:=AGameDB;
    result:=(CreateConfForm.ShowModal=mrOK);
  finally
    CreateConfForm.Free;
  end;
end;

end.
