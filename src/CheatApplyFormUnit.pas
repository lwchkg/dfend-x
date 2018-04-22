unit CheatApplyFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons, CheatDBUnit, CheatDBToolsUnit;

type
  TCheatApplyForm = class(TForm)
    InfoLabel: TLabel;
    GameLabel: TLabel;
    CheatsLabel: TLabel;
    CheatsListBox: TCheckListBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    FilesListBox: TCheckListBox;
    GameComboBox: TComboBox;
    FilesLabel: TLabel;
    SelectButton: TButton;
    EditButton: TBitBtn;
    WarningLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GameComboBoxChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure FilesListBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    CheatDB : TCheatDB;
    GameFolders : TStringList;
    JustGameComboBoxChanging : Boolean;
    MostRecentNr : Integer;
  public
    { Public-Deklarationen }
    GameDir : String;
    EditButtonClicked : Boolean;
  end;

var
  CheatApplyForm: TCheatApplyForm;

Function ShowCheatApplyDialog(const AOwner : TComponent; const GameDir : String; var EditButtonClicked : Boolean) : Boolean;

implementation

uses PrgConsts, CommonTools, PrgSetupUnit, VistaToolsUnit, LanguageSetupUnit,
     IconLoaderUnit, HelpConsts;

{$R *.dfm}

{ TCheatApplyForm }

procedure TCheatApplyForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  EditButtonClicked:=False;
  JustGameComboBoxChanging:=False;
  GameFolders:=nil;
  CheatDB:=SmartLoadCheatsDB;

  Caption:=LanguageSetup.ApplyCheat;
  InfoLabel.Caption:=LanguageSetup.ApplyCheatInfo;
  GameLabel.Caption:=LanguageSetup.ApplyCheatGamesList;
  CheatsLabel.Caption:=LanguageSetup.ApplyCheatCheatsList;
  FilesLabel.Caption:=LanguageSetup.ApplyCheatFilesList;
  SelectButton.Caption:=LanguageSetup.ApplyCheatFilesListSelectLastChanged;
  WarningLabel.Caption:=LanguageSetup.ApplyCheatWarning;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  EditButton.Caption:=LanguageSetup.ApplyCheatEditButton;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Edit,EditButton);
end;

procedure TCheatApplyForm.FormDestroy(Sender: TObject);
begin
  If Assigned(CheatDB) then CheatDB.Free;
  If Assigned(GameFolders) then GameFolders.Free;
end;

procedure TCheatApplyForm.FormShow(Sender: TObject);
Var MatchingGameRecords : TStringList;
begin
  If CheatDB=nil then begin
    MessageDlg(LanguageSetup.ApplyCheatDataBaseError,mtError,[mbOK],0);
    PostMessage(Handle,WM_Close,0,0);
    exit;
  end;

  GameFolders:=GetGameFolders(GameDir);
  MatchingGameRecords:=FindMatchingGameRecords(CheatDB,GameFolders);
  try
    If MatchingGameRecords.Count=0 then begin
      MessageDlg(LanguageSetup.ApplyCheatNoMatchingCheatRecord,mtError,[mbOK],0);
      PostMessage(Handle,WM_Close,0,0);
      exit;
    end;

    JustGameComboBoxChanging:=True;
    GameComboBox.Items.BeginUpdate;
    try
      GameComboBox.Items.Clear;
      GameComboBox.Items.AddStrings(MatchingGameRecords);
      If GameComboBox.Items.Count>0 then GameComboBox.ItemIndex:=0;
    finally
      GameComboBox.Items.EndUpdate;
      JustGameComboBoxChanging:=False;
    end;
    GameComboBoxChange(Sender);
  finally
    MatchingGameRecords.Free;
  end;
end;

procedure TCheatApplyForm.GameComboBoxChange(Sender: TObject);
Var I,J,K : Integer;
    G : TCheatGameRecord;
    FileMasks : TStringList;
    Rec : TSearchRec;
    MostRecentTime : Integer;
    S : String;
begin
  If JustGameComboBoxChanging then exit;

  If GameComboBox.ItemIndex<0 then exit;
  G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);

  FileMasks:=TStringList.Create;
  try
    CheatsListBox.Items.BeginUpdate;
    try
      CheatsListBox.Items.Clear;
      For I:=0 to G.Count-1 do begin
        CheatsListBox.Items.AddObject(G[I].Name,G[I]);
        CheatsListBox.Checked[I]:=True;
        S:=ExtUpperCase(G[I].FileMask);
        If FileMasks.IndexOf(S)<0 then FileMasks.Add(S);
      end;
    finally
      CheatsListBox.Items.EndUpdate;
    end;

    MostRecentNr:=-1; MostRecentTime:=-1;
    FilesListBox.Items.BeginUpdate;
    try
      FilesListBox.Items.Clear;
      For I:=0 to GameFolders.Count-1 do For J:=0 to FileMasks.Count-1 do begin
        K:=FindFirst(GameFolders[I]+FileMasks[J],faAnyFile,Rec);
        try
          While K=0 do begin
            If (Rec.Attr and faDirectory)=0 then begin
              S:=MakeRelPath(GameFolders[I]+Rec.Name,PrgSetup.BaseDir);
              If FilesListBox.Items.IndexOf(S)<0 then begin
                FilesListBox.Items.Add(S);
                If Rec.Time>MostRecentTime then begin MostRecentTime:=Rec.Time; MostRecentNr:=FilesListBox.Items.Count-1; end;
              end;
            end;
            K:=FindNext(Rec);
          end;
        finally
          FindClose(Rec);
        end;
      end;
    finally
      FilesListBox.Items.EndUpdate;
    end;
    SelectButtonClick(Sender);
  finally
    FileMasks.Free;
  end;
end;

procedure TCheatApplyForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=0 to FilesListBox.Items.Count-1 do FilesListBox.Checked[I]:=(I=MostRecentNr);
  FilesListBox.ItemIndex:=MostRecentNr;
  FilesListBox.TopIndex:=FilesListBox.ItemIndex;
  FilesListBoxClick(Sender);
end;

procedure TCheatApplyForm.FilesListBoxClick(Sender: TObject);
Var I : Integer;
    B : Boolean;
begin
  B:=False;
  For I:=0 to FilesListBox.Items.Count-1 do begin
    FilesListBox.Checked[I]:=(FilesListBox.ItemIndex=I);
    If FilesListBox.Checked[I] then B:=True;
  end;
  OKButton.Enabled:=B;
end;

procedure TCheatApplyForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    A : TCheatAction;
    FileName : String;
    Backuped : TStringList;
    B : Boolean;
begin
  If FilesListBox.ItemIndex<0 then exit;
  FileName:=MakeAbsPath(FilesListBox.Items[FilesListBox.ItemIndex],PrgSetup.BaseDir);

  Backuped:=TStringList.Create;
  try
    For I:=0 to CheatsListBox.Items.Count-1 do If CheatsListBox.Checked[I] then begin
      A:=TCheatAction(CheatsListBox.Items.Objects[I]);
      If not FileMatchingMask(ExtractFileName(FileName),A.FileMask) then continue;
      B:=(Backuped.IndexOf(FileName)>0);
      If A.Apply(FileName,not B) then begin
        If not B then Backuped.Add(FileName);
      end;
    end;
  finally
    Backuped.Free;
  end;
end;

procedure TCheatApplyForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileCheating);
end;

procedure TCheatApplyForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TCheatApplyForm.EditButtonClick(Sender: TObject);
begin
  EditButtonClicked:=True;
  ModalResult:=mrOK;
end;

{ global }

Function ShowCheatApplyDialog(const AOwner : TComponent; const GameDir : String; var EditButtonClicked : Boolean) : Boolean;
begin
  CheatsDBUpdateCheckIfSetup(Application.MainForm);
  CheatApplyForm:=TCheatApplyForm.Create(AOwner);
  try
    CheatApplyForm.GameDir:=IncludeTrailingPathDelimiter(GameDir);
    result:=(CheatApplyForm.ShowModal=mrOK);
    if result then EditButtonClicked:=CheatApplyForm.EditButtonClicked else EditButtonClicked:=False;
  finally
    CheatApplyForm.Free;
  end;
end;

end.
