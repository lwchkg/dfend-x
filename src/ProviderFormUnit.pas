unit ProviderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, PackageDBUnit;

type
  TProviderForm = class(TForm)
    Label1: TLabel;
    ListBox: TListBox;
    Label2: TLabel;
    ProviderNameLabel: TLabel;
    Label3: TLabel;
    ProviderTextLabel: TLabel;
    Label4: TLabel;
    ProviderURLLabel: TLabel;
    OKButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ProviderURLLabelClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Files : TStringList;
    ProviderName, ProviderText, ProviderURL : String;
  end;

var
  ProviderForm: TProviderForm;

Procedure ShowProviderDialog(const AOwner : TComponent; const AFiles : TStringList; const AProviderName, AProviderText, AProviderURL : String);

Procedure WriteProverInfoToProfile(const AProfile : TGame; const AProviderName, AProviderURL : String); overload;
Procedure WriteProverInfoToProfile(const AProfileFile, AProviderName, AProviderURL : String); overload;

Procedure WriteMetaInformationToProfile(const AProfile : TGame; const ADownloadData : TDownloadAutoSetupData); overload;
Procedure WriteMetaInformationToProfile(const AProfileFile : String; const ADownloadData : TDownloadAutoSetupData); overload;

implementation

uses ShellAPI, CommonTools, VistaToolsUnit, LanguageSetupUnit, IconLoaderUnit;

{$R *.dfm}

procedure TProviderForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.PackageManagerProviderCaption;
  Label1.Caption:=LanguageSetup.PackageManagerProviderFiles;
  Label2.Caption:=LanguageSetup.PackageManagerProviderProvider;
  Label3.Caption:=LanguageSetup.PackageManagerProviderInformation;
  Label3.Font.Style:=[fsUnderline];
  Label4.Caption:=LanguageSetup.PackageManagerProviderHomepage;
  Label4.Font.Style:=[fsUnderline];

  UserIconLoader.DialogImage(DI_OK,OKButton);
end;

procedure TProviderForm.FormShow(Sender: TObject);
begin
  ListBox.Items.AddStrings(Files);
  with ProviderNameLabel do begin
    Caption:=ProviderName;
    Font.Style:=[fsBold];
  end;
  ProviderTextLabel.Caption:=ProviderText;
  with ProviderURLLabel do begin
    Caption:=ProviderURL;
    Font.Color:=clBlue;
    Font.Style:=[fsUnderline];
    Cursor:=crHandPoint;
  end;
end;

procedure TProviderForm.ProviderURLLabelClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar(ProviderURLLabel.Caption),nil,nil,SW_SHOW);
end;

{ global }

Procedure ShowProviderDialog(const AOwner : TComponent; const AFiles : TStringList; const AProviderName, AProviderText, AProviderURL : String);
begin
  ProviderForm:=TProviderForm.Create(AOwner);
  try
    ProviderForm.Files:=AFiles;
    ProviderForm.ProviderName:=AProviderName;
    ProviderForm.ProviderText:=AProviderText;
    ProviderForm.ProviderURL:=AProviderURL;
    ProviderForm.ShowModal;
  finally
    ProviderForm.Free;
  end;
end;

Procedure WriteProverInfoToProfile(const AProfile : TGame; const AProviderName, AProviderURL : String);
Var St : TStringList;
    I : Integer;
begin
  St:=StringToStringList(AProfile.Notes);
  try
    St.Insert(0,Format(LanguageSetup.PackageManagerProviderProfileString,[AProviderName]));
    If St.Count>1 then St.Insert(1,'');
    AProfile.Notes:=StringListToString(St);
  finally
    St.Free;
  end;
  If Trim(AProviderURL)<>'' then For I:=1 to 9 do if (Trim(AProfile.WWW[I])='') or (I=9) then begin
    AProfile.WWWName[I]:=LanguageSetup.PackageManagerProviderHomepage;
    AProfile.WWW[I]:=AProviderURL;
    break;
  end;
  AProfile.LoadCache;
  AProfile.StoreAllValues;
end;

Procedure WriteProverInfoToProfile(const AProfileFile, AProviderName, AProviderURL : String);
Var Game : TGame;
begin
  Game:=TGame.Create(AProfileFile);
  try
    WriteProverInfoToProfile(Game,AProviderName,AProviderURL);
  finally
    Game.Free;
  end;
end;

Procedure WriteMetaInformationToProfile(const AProfile : TGame; const ADownloadData : TDownloadAutoSetupData);
begin
  If Trim(ADownloadData.Name)<>'' then AProfile.Name:=ADownloadData.Name;
  If Trim(ADownloadData.Genre)<>'' then AProfile.Genre:=ADownloadData.Genre;
  If Trim(ADownloadData.Developer)<>'' then AProfile.Developer:=ADownloadData.Developer;
  If Trim(ADownloadData.Publisher)<>'' then AProfile.Publisher:=ADownloadData.Publisher;
  If Trim(ADownloadData.Year)<>'' then AProfile.Year:=ADownloadData.Year;
  If Trim(ADownloadData.Language)<>'' then AProfile.Language:=ADownloadData.Language;
  AProfile.LoadCache;
  AProfile.StoreAllValues;
end;

Procedure WriteMetaInformationToProfile(const AProfileFile : String; const ADownloadData : TDownloadAutoSetupData);
Var Game : TGame;
begin
  Game:=TGame.Create(AProfileFile);
  try
    WriteMetaInformationToProfile(Game,ADownloadData);
  finally
    Game.Free;
  end;
end;

end.
