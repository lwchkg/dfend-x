unit DataReaderBaseUnit;
interface

uses Classes;

Type TDataReader=class
  protected
    FGameNames, FGameURLs : TStringList;
    FLastListRequest : String;
    FLastUpdateCheckOK : Boolean;
    FBrowserURLDOS, FBrowserURLAll, FDataDomain : String;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadConfig(const AConfigFile : String; const UpdateCheck : Boolean) : Boolean; virtual;
    Procedure OpenListPage(const ASearchString : String);
    Function ReadList(const ASearchString : String) : Boolean; virtual; abstract;
    Function GetListURL(const all : Boolean) : String; virtual; abstract;
    Function GetGameData(const Nr : Integer; var Genre, Developer, Publisher, Year, Notes, ImagePageURL : String) : Boolean; virtual; abstract;
    Function GetGameCover(const CoverPageURL : String; var ImageURL : String; const MaxImages : Integer) : Boolean; virtual; abstract;
    property GameNames : TStringList read FGameNames;
    property LastUpdateCheckOK : Boolean read FLastUpdateCheckOK;
    property DataDomain : String read FDataDomain;
end;

implementation

uses Forms, Windows, SysUtils, ShellAPI, PrgSetupUnit, DataReaderToolsUnit;

{ TDataReader }

constructor TDataReader.Create;
begin
  inherited Create;
  FGameNames:=TStringList.Create;
  FGameURLs:=TStringList.Create;
  FLastListRequest:='';
  FLastUpdateCheckOK:=True;

end;

destructor TDataReader.Destroy;
begin
  FGameNames.Free;
  FGameURLs.Free;
  inherited Destroy;
end;

function TDataReader.LoadConfig(const AConfigFile: String; const UpdateCheck: Boolean): Boolean;
begin
  result:=true;
end;

procedure TDataReader.OpenListPage(const ASearchString: String);
Var URL : String;
begin
  If PrgSetup.DataReaderAllPlatforms then URL:=FBrowserURLDOS else URL:=FBrowserURLAll;
  if URL='' then exit;
  ShellExecute(Application.Handle,'open',PChar(Format(URL,[EncodeName(ASearchString)])),nil,nil,SW_SHOW);
end;

end.
