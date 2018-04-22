unit DataReaderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DataReaderBaseUnit;

type
  TDataReaderForm = class(TForm)
    GameNameEdit: TLabeledEdit;
    SearchButton: TBitBtn;
    SearchResultsLabel: TLabel;
    ListBox: TListBox;
    GameDataBox: TGroupBox;
    InsertButton: TBitBtn;
    CancelButton: TBitBtn;
    GenreCheckBox: TCheckBox;
    DeveloperCheckBox: TCheckBox;
    PublisherCheckBox: TCheckBox;
    YearCheckBox: TCheckBox;
    DownloadCoverCheckBox: TCheckBox;
    GenreLabel: TLabel;
    DeveloperLabel: TLabel;
    PublisherLabel: TLabel;
    YearLabel: TLabel;
    SearchTypeCheckBox: TCheckBox;
    NameCheckBox: TCheckBox;
    NameLabel: TLabel;
    DownloadCoverAllCheckBox: TCheckBox;
    DescriptionCheckBox: TCheckBox;
    SourceLabel: TLabel;
    SourceComboBox: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure InsertButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchTypeCheckBoxClick(Sender: TObject);
    procedure DownloadCoverCheckBoxClick(Sender: TObject);
    procedure SourceComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    GenreSt, DeveloperSt, PublisherSt, YearSt, CoverSt, NotesSt : TStringList;
    DataReader : TDataReader;
    ShowCompleted : Boolean;
    LastSource : Integer;
  public
    { Public-Deklarationen }
    ConfigOK : Boolean;
    CaptureDir : String;
    Name, Genre, Developer, Publisher, Year, Internet, Notes : String;
  end;

var
  DataReaderForm: TDataReaderForm;

Function ShowDataReaderDialog(const AOwner : TComponent; const AGameName : String; var Name, Genre, Developer, Publisher, Year, Internet, Notes : String; const CaptureDir : String) : Boolean;

implementation

uses Math, LanguageSetupUnit, CommonTools, VistaToolsUnit,
     InternetDataWaitFormUnit, PrgSetupUnit, PrgConsts, IconLoaderUnit,
     GameDBToolsUnit, DataReaderMobyUnit, DataReaderTheGamesDBUnit;

{$R *.dfm}

procedure TDataReaderForm.FormCreate(Sender: TObject);
begin
  ShowCompleted:=False;
  GenreSt:=TStringList.Create;
  DeveloperSt:=TStringList.Create;
  PublisherSt:=TStringList.Create;
  YearSt:=TStringList.Create;
  CoverSt:=TStringList.Create;
  NotesSt:=TStringList.Create;

  DataReader:=TTheGamesDBDataReader.Create;
  ConfigOK:=ShowDataReaderInternetConfigWaitDialog(Owner,DataReader,False,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
end;

procedure TDataReaderForm.FormShow(Sender: TObject);
Var S : String;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NameLabel.Font.Style:=[fsBold];
  GenreLabel.Font.Style:=[fsBold];
  DeveloperLabel.Font.Style:=[fsBold];
  PublisherLabel.Font.Style:=[fsBold];
  YearLabel.Font.Style:=[fsBold];
  NameLabel.Caption:='';
  GenreLabel.Caption:='';
  DeveloperLabel.Caption:='';
  PublisherLabel.Caption:='';
  YearLabel.Caption:='';

  Caption:=LanguageSetup.DataReader;
  SourceLabel.Caption:=LanguageSetup.DataReaderSource;
  GameNameEdit.EditLabel.Caption:=LanguageSetup.GameName;
  SearchButton.Caption:=LanguageSetup.Search;
  SearchTypeCheckBox.Caption:=LanguageSetup.DataReaderSearchForDOSGames;
  SearchResultsLabel.Caption:=LanguageSetup.DataReaderSearchResults;
  GameDataBox.Caption:=LanguageSetup.DataReaderNoSearchResults;
  NameCheckBox.Caption:=LanguageSetup.GameName;
  GenreCheckBox.Caption:=LanguageSetup.GameGenre;
  DeveloperCheckBox.Caption:=LanguageSetup.GameDeveloper;
  PublisherCheckBox.Caption:=LanguageSetup.GamePublisher;
  YearCheckBox.Caption:=LanguageSetup.GameYear;
  DownloadCoverCheckBox.Caption:=LanguageSetup.DataReaderCoverCheckbox;
  DownloadCoverAllCheckBox.Caption:=LanguageSetup.DataReaderCoverAllCheckbox;
  DescriptionCheckBox.Caption:=LanguageSetup.CaptureNotes;

  InsertButton.Caption:=LanguageSetup.DataReaderInsert;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_FindFile,SearchButton);
  UserIconLoader.DialogImage(DI_OK,InsertButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  SourceComboBox.ItemIndex:=Min(SourceComboBox.Items.Count-1,Max(0,PrgSetup.DataReaderSource));
  SourceComboBoxChange(nil);

  SearchTypeCheckBox.Checked:=not PrgSetup.DataReaderAllPlatforms;

  If Trim(GameNameEdit.Text)<>'' then SearchButtonClick(Sender) else ListBoxClick(Sender);
  ShowCompleted:=True;

  S:=Trim(PrgSetup.DataReaderActiveSettings);
  While length(S)<7 do S:=S+'X';
  If length(S)>7 then S:=Copy(S,1,7);
  NameCheckBox.Checked:=(S[1]<>'-');
  GenreCheckBox.Checked:=(S[2]<>'-');
  DeveloperCheckBox.Checked:=(S[3]<>'-');
  PublisherCheckBox.Checked:=(S[4]<>'-');
  YearCheckBox.Checked:=(S[5]<>'-');
  DownloadCoverCheckBox.Checked:=(S[6]<>'-');
  DownloadCoverAllCheckBox.Enabled:=DownloadCoverCheckBox.Checked;
  DownloadCoverAllCheckBox.Checked:=(S[7]<>'-');
  DescriptionCheckBox.Checked:=(S[8]<>'-');

  SearchTypeCheckBox.Visible:=(ExtUpperCase(Trim(DataReader.GetListURL(false)))<>ExtUpperCase(Trim(DataReader.GetListURL(true))));
end;

procedure TDataReaderForm.FormDestroy(Sender: TObject);
Var S : String;
begin
  PrgSetup.DataReaderSource:=SourceComboBox.ItemIndex;

  S:='';
  If NameCheckBox.Checked then S:=S+'X' else S:=S+'-';
  If GenreCheckBox.Checked then S:=S+'X' else S:=S+'-';
  If DeveloperCheckBox.Checked then S:=S+'X' else S:=S+'-';
  If PublisherCheckBox.Checked then S:=S+'X' else S:=S+'-';
  If YearCheckBox.Checked then S:=S+'X' else S:=S+'-';
  If DownloadCoverCheckBox.Checked then S:=S+'X' else S:=S+'-';
  If DownloadCoverAllCheckBox.Checked then S:=S+'X' else S:=S+'-';
  if DescriptionCheckBox.Checked then S:=S+'X' else S:=S+'-';
  
  PrgSetup.DataReaderActiveSettings:=S;

  GenreSt.Free;
  DeveloperSt.Free;
  PublisherSt.Free;
  YearSt.Free;
  CoverSt.Free;
  NotesSt.Free;
  DataReader.Free;
end;

procedure TDataReaderForm.DownloadCoverCheckBoxClick(Sender: TObject);
begin
  DownloadCoverAllCheckBox.Enabled:=DownloadCoverCheckBox.Checked and DownloadCoverCheckBox.Enabled;
end;

procedure TDataReaderForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key<>VK_RETURN then exit;

  If GameNameEdit.Focused then begin
    SearchButtonClick(Sender);
  end else begin
    ModalResult:=mrOK;
    InsertButtonClick(Sender);
  end;
end;

procedure TDataReaderForm.SearchButtonClick(Sender: TObject);
Var I : Integer;
    O : TComponent;
begin
  ListBox.Items.Clear;
  GenreSt.Clear;
  DeveloperSt.Clear;
  PublisherSt.Clear;
  YearSt.Clear;
  CoverSt.Clear;
  NotesSt.Clear;

  try
    Enabled:=False;
    try
      If ShowCompleted then O:=self else O:=Owner;
      If not ShowDataReaderInternetListWaitDialog(O,DataReader,GameNameEdit.Text,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError) then begin
        ListBoxClick(Sender);
        exit;
      end;
    finally
      Enabled:=True;
    end;
    For I:=0 to DataReader.GameNames.Count-1 do begin
      ListBox.Items.Add(DataReader.GameNames[I]);
      GenreSt.Add('');
      DeveloperSt.Add('');
      PublisherSt.Add('');
      YearSt.Add('');
      CoverSt.Add('');
      NotesSt.Add('');
    end;
  finally
    If ListBox.Items.Count>0 then ListBox.ItemIndex:=0;
    ListBoxClick(Sender);
    If ListBox.Items.Count>0 then ActiveControl:=ListBox;
  end;
end;

procedure TDataReaderForm.SearchTypeCheckBoxClick(Sender: TObject);
begin
  PrgSetup.DataReaderAllPlatforms:=not SearchTypeCheckBox.Checked;
end;

procedure TDataReaderForm.SourceComboBoxChange(Sender: TObject);
Var B : Boolean;
begin
  if DataReader<>nil then FreeAndNil(DataReader);
  
  Case SourceComboBox.ItemIndex of
    0 : DataReader:=TTheGamesDBDataReader.Create;
    1 : begin
          DataReader:=TMobyDataReader.Create;
          B:=ShowDataReaderInternetConfigWaitDialog(Owner,DataReader,False,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
          if not B then begin
            SourceComboBox.ItemIndex:=0;
            SourceComboBoxChange(nil);
            exit;
          end;
        end;
  end;

  if (Sender<>nil) and (LastSource<>SourceComboBox.ItemIndex) then SearchButtonClick(Sender);
  LastSource:=SourceComboBox.ItemIndex;
end;

Function ProcessGenre(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  For I:=1 to length(result) do if result[I]=',' then result[I]:=';';
end;

Function BuildHint(Text : String) : String;
const MaxHint=1000;
const MaxLine=70;
Var I,Count : Integer;
begin
  Text:=Trim(Text);

  Count:=0;
  For I:=1 to length(Text) do begin
    if Text[I]=#10 then continue;
    if (Text[I]=#13) or ((Count>MaxLine) and (Text[I]=' ')) then begin
      if length(result)>MaxHint then begin result:=result+'...'; exit; end;
      result:=result+#13; Count:=0;
      continue;
    end;
    result:=result+Text[I];
    inc(Count);
  end;
end;

procedure TDataReaderForm.ListBoxClick(Sender: TObject);
Var DataReaderGameDataThread : TDataReaderGameDataThread;
    Nr : Integer;
    O : TComponent;
begin
  Nr:=ListBox.ItemIndex;
  If Nr<0 then begin
    GameDataBox.Caption:=LanguageSetup.DataReaderNoSearchResults;
    InsertButton.Enabled:=False;
    NameCheckBox.Enabled:=False;
    GenreCheckBox.Enabled:=False;
    GenreLabel.Caption:='';
    DeveloperCheckBox.Enabled:=False;
    DeveloperLabel.Caption:='';
    PublisherCheckBox.Enabled:=False;
    PublisherLabel.Caption:='';
    YearCheckBox.Enabled:=False;
    YearLabel.Caption:='';
    DownloadCoverCheckBox.Enabled:=False;
    DownloadCoverAllCheckBox.Enabled:=False;
    DeveloperCheckBox.Enabled:=False;
    exit;
  end;

  If (Trim(GenreSt[Nr])='') and (Trim(DeveloperSt[Nr])='') and (Trim(PublisherSt[Nr])='') and (Trim(YearSt[Nr])='') and (Trim(CoverSt[Nr])='') and (Trim(NotesSt[Nr])='') then begin
    Enabled:=False;
    try
      If ShowCompleted then O:=self else O:=Owner;
      DataReaderGameDataThread:=ShowDataReaderInternetDataWaitDialog(O,DataReader,Nr,False,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
    finally
      Enabled:=True;
    end;
    If DataReaderGameDataThread<>nil then try
      GenreSt[Nr]:=GetCustomGenreName(ProcessGenre(DataReaderGameDataThread.Genre));
      DeveloperSt[Nr]:=DataReaderGameDataThread.Developer;
      PublisherSt[Nr]:=DataReaderGameDataThread.Publisher;
      YearSt[Nr]:=DataReaderGameDataThread.Year;
      CoverSt[Nr]:=DataReaderGameDataThread.ImageURL;
      NotesSt[Nr]:=DecodeHTMLSymbols(DataReaderGameDataThread.Notes);
    finally
      DataReaderGameDataThread.Free;
    end;
  end;

  GameDataBox.Caption:=ListBox.Items[Nr];
  NameLabel.Caption:=ListBox.Items[Nr];
  NameCheckBox.Enabled:=True;
  GenreCheckBox.Enabled:=(Trim(GenreSt[Nr])<>'');
  GenreLabel.Caption:=GenreSt[Nr];
  DeveloperCheckBox.Enabled:=(Trim(DeveloperSt[Nr])<>'');
  DeveloperLabel.Caption:=DeveloperSt[Nr];
  PublisherCheckBox.Enabled:=(Trim(PublisherSt[Nr])<>'');
  PublisherLabel.Caption:=PublisherSt[Nr];
  YearCheckBox.Enabled:=(Trim(YearSt[Nr])<>'');
  YearLabel.Caption:=YearSt[Nr];
  DownloadCoverCheckBox.Enabled:=(Trim(CoverSt[Nr])<>'');
  DownloadCoverAllCheckBox.Enabled:=DownloadCoverCheckBox.Enabled and (Pos('$',CoverSt[Nr])>0);
  DescriptionCheckBox.Enabled:=(Trim(NotesSt[Nr])<>'');
  DescriptionCheckBox.Hint:=BuildHint(NotesSt[Nr]);

  InsertButton.Enabled:=(Trim(GenreSt[Nr])<>'') or (Trim(DeveloperSt[Nr])<>'') or (Trim(PublisherSt[Nr])<>'') or (Trim(YearSt[Nr])<>'') or (Trim(CoverSt[Nr])<>'') or (Trim(NotesSt[Nr])<>'');
end;

procedure TDataReaderForm.InsertButtonClick(Sender: TObject);
Var S,T : String;
    I : Integer;
    DataReaderGameDataThread : TDataReaderGameDataThread;
    St : TStringList;
begin
  Name:='';
  Genre:='';
  Developer:='';
  Publisher:='';
  Year:='';
  Notes:='';

  If NameCheckBox.Enabled and NameCheckBox.Checked then Name:=ListBox.Items[ListBox.ItemIndex];
  If GenreCheckBox.Enabled and GenreCheckBox.Checked then Genre:=GenreLabel.Caption;
  If DeveloperCheckBox.Enabled and DeveloperCheckBox.Checked then Developer:=DeveloperLabel.Caption;
  If PublisherCheckBox.Enabled and PublisherCheckBox.Checked then Publisher:=PublisherLabel.Caption;
  If YearCheckBox.Enabled and YearCheckBox.Checked then Year:=YearLabel.Caption;

  If DownloadCoverCheckBox.Enabled and DownloadCoverCheckBox.Checked and (CaptureDir<>'') then begin
    ForceDirectories(CaptureDir);
    If DownloadCoverAllCheckBox.Checked then begin
      {Get URLs of all images}
      DataReaderGameDataThread:=ShowDataReaderInternetDataWaitDialog(self,DataReader,ListBox.ItemIndex,True,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
      If DataReaderGameDataThread<>nil then try
        S:=DataReaderGameDataThread.ImageURL;
      finally
        DataReaderGameDataThread.Free;
      end;
      {Download all}
      St:=TStringList.Create;
      try
        I:=Pos('$',S); While I>0 do begin
          T:=Trim(Copy(S,1,I-1));
          S:=Trim(Copy(S,I+1,MaxInt));
          St.Add(T);
          If not DownloadCoverAllCheckBox.Checked then break;
          I:=Pos('$',S);
        end;
        St.Add(S);
        If St.Count>0 then ShowDataReaderInternetCoverWaitDialog(self,DataReader,St,CaptureDir,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
      finally
        St.Free;
      end;
    end else begin
      S:=CoverSt[ListBox.ItemIndex];
      {Download first}
      I:=Pos('$',S); If I>0 then S:=Trim(Copy(S,1,I-1));
      ShowDataReaderInternetCoverWaitDialog(self,DataReader,S,CaptureDir,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
    end;
  end;

  If DescriptionCheckBox.Enabled and DescriptionCheckBox.Checked then Notes:=NotesSt[ListBox.ItemIndex];
end;

{ global }

Function ShowDataReaderDialog(const AOwner : TComponent; const AGameName : String; var Name, Genre, Developer, Publisher, Year, Internet, Notes : String; const CaptureDir : String) : Boolean;
begin
  DataReaderForm:=TDataReaderForm.Create(AOwner);
  try
    If not DataReaderForm.ConfigOk then begin result:=False; exit; end;
    DataReaderForm.GameNameEdit.Text:=AGameName;
    DataReaderForm.CaptureDir:=CaptureDir;
    result:=(DataReaderForm.ShowModal=mrOK);
    if result then begin
      Name:=DataReaderForm.Name;
      Genre:=DataReaderForm.Genre;
      Developer:=DataReaderForm.Developer;
      Publisher:=DataReaderForm.Publisher;
      Year:=DataReaderForm.Year;
      Internet:=DataReaderForm.Internet;
      Notes:=DataReaderForm.Notes;
    end;
  finally
    DataReaderForm.Free;
  end;
end;

end.
