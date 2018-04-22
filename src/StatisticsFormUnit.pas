unit StatisticsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TStatisticsForm = class(TForm)
    Panel1: TPanel;
    Memo: TRichEdit;
    OKButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  StatisticsForm: TStatisticsForm;

Procedure ShowInfoTextDialog(const AOwner : TComponent; const ACaption : String; const AText : TStringList; const WordWrap : Boolean = False);
Procedure ShowStatisticsDialog(const AOwner : TComponent; const AGameDB : TGameDB);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TStatisticsForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  OKButton.Caption:=LanguageSetup.OK;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TStatisticsForm.HelpButtonClick(Sender: TObject);
begin
  if not StatisticsForm.HelpButton.Visible then exit;
  Application.HelpCommand(HELP_CONTEXT,ID_HelpStatistics);
end;

procedure TStatisticsForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function GetFileCount(const Mask : String) : Integer;
Var I : Integer;
    Rec : TSearchRec;
begin
  result:=0;

  I:=FindFirst(Mask,faAnyFile,Rec);
  try
    while I=0 do begin inc(result); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;
end;

Function GetNumberOfIcons: Integer;
Var Dir : String;
begin
  result:=0;

  Dir:=IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir);
  if not DirectoryExists(Dir) then exit;

  inc(result,GetFileCount(Dir+'*.ico'));
  inc(result,GetFileCount(Dir+'*.png'));
  inc(result,GetFileCount(Dir+'*.jpeg'));
  inc(result,GetFileCount(Dir+'*.jpg'));
  inc(result,GetFileCount(Dir+'*.gif'));
  inc(result,GetFileCount(Dir+'*.bmp'));
end;

Procedure BuildStatistics(const GameDB : TGameDB; const St : TStringList);
Var TemplateDB : TGameDB;
    St2 : TStringList;
    I,J,C : Integer;
    S : String;
begin
  St.Add('D-Fend Reloaded '+GetFileVersionAsString);
  St.Add('');

  St.Add(LanguageSetup.StatisticsNumberProfiles+': '+IntToStr(GameDB.Count));

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  try
    St.Add(LanguageSetup.StatisticsNumberTemplates+': '+IntToStr(TemplateDB.Count));
  finally
    TemplateDB.Free;
  end;

  TemplateDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  try
    St.Add(LanguageSetup.StatisticsNumberAutoSetupTemplates+': '+IntToStr(TemplateDB.Count));
  finally
    TemplateDB.Free;
  end;

  St.Add(LanguageSetup.StatisticsNumberIcons+': '+IntToStr(GetNumberOfIcons));

  St.Add('');
  St.Add(LanguageSetup.StatisticsNumberProfilesByGenres+':');

  St2:=GameDB.GetGenreList(True);
  try
    For I:=0 to St2.Count-1 do begin
      C:=0; S:=ExtUpperCase(St2[I]);
      For J:=0 to GameDB.Count-1 do If ExtUpperCase(GameDB[J].CacheGenre)=S then inc(C);
      St.Add('  '
      +GetCustomGenreName(St2[I])+': '+IntToStr(C));
    end;
  finally
    St2.Free;
  end;
end;

Procedure ShowStatisticsDialog(const AOwner : TComponent; const AGameDB : TGameDB);
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    BuildStatistics(AGameDB,St);
    ShowInfoTextDialog(AOwner,LanguageSetup.StatisticsCaption,St);
  finally
    St.Free;
  end;
end;

Procedure ShowInfoTextDialog(const AOwner : TComponent; const ACaption : String; const AText : TStringList; const WordWrap : Boolean);
begin
  StatisticsForm:=TStatisticsForm.Create(AOwner);
  try
    StatisticsForm.Caption:=ACaption;
    StatisticsForm.Memo.Lines.AddStrings(AText);
    StatisticsForm.Memo.WordWrap:=WordWrap;
    StatisticsForm.HelpButton.Visible:=False;
    StatisticsForm.ShowModal;
  finally
    StatisticsForm.Free;
  end;
end;

end.
