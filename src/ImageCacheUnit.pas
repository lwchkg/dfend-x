unit ImageCacheUnit;
interface

uses Classes, Windows, Graphics;

Type TImageData=class
  private
    FPath : String;
    FPicture : TPicture;
    FIcon : TIcon;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadPicture(const AFileName : String) : Boolean;
    Function LoadIcon(const AFileName : String) : Boolean; overload;
    Function LoadIcon(const AIcon : TIcon; const AFileName : String) : Boolean; overload;
    property Picture : TPicture read FPicture;
    property Icon : TIcon read FIcon;
    property Path : String read FPath;
end;

Type TImageCache=class
  private
    FImageList : TStringList;
    Function LoadImageAsIcon(const AFileName: String): Integer;
    Function LoadPicture(const AFileName : String) : Integer;
    Function LoadIcon(const AFileName : String) : Integer;
    Function FindFile(const AFileName : String) : Integer;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear;
    Function GetIcon(const AFileName : String) : TIcon;
    Function GetPicture(const AFileName : String) : TPicture;
end;

var IconCache : TImageCache = nil;
    PictureCache : TImageCache = nil;

implementation

uses SysUtils, Controls, ShellAPI, CommonTools, ImageStretch;

{ TImageData }

constructor TImageData.Create;
begin
  inherited Create;
  FPicture:=nil;
  FIcon:=nil;
end;

destructor TImageData.Destroy;
begin
  If Assigned(FIcon) then FIcon.Free;
  If Assigned(FPicture) then FPicture.Free;
  inherited Destroy;
end;

function TImageData.LoadIcon(const AFileName: String): Boolean;
begin
  FIcon:=LoadIconFromExeFile(AFileName);
  result:=(FIcon<>nil);
  if result then FPath:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));
end;

Function TImageData.LoadIcon(const AIcon : TIcon; const AFileName : String) : Boolean;
begin
  FIcon:=TIcon.Create;
  FIcon.Assign(AIcon);
  FPath:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));
  result:=True;
end;

function TImageData.LoadPicture(const AFileName: String): Boolean;
begin
  result:=False;
  If not FileExists(AFileName) then exit;
  try FPicture:=LoadImageFromFile(AFileName); except FreeAndNil(FPicture); exit; end;
  if FPicture=nil then exit;
  FPath:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));
  result:=True;
end;

{ TImageCache }

constructor TImageCache.Create;
begin
  inherited Create;
  FImageList:=TStringList.Create;
  FImageList.Sorted:=True;
  FImageList.Duplicates:=dupAccept;
end;

destructor TImageCache.Destroy;
begin
  Clear;
  FImageList.Free;
  inherited Destroy;
end;

Function TImageCache.LoadImageAsIcon(const AFileName: String): Integer;
Var AImageData : TImageData;
    I : TIcon;
begin
  result:=-1;
  I:=LoadImageAsIconFromFile(AFileName); If I=nil then exit;
  try
    AImageData:=TImageData.Create;
    if not AImageData.LoadIcon(I,AFileName) then begin AImageData.Free; exit; end;
    result:=FImageList.AddObject(ExtUpperCase(ExtractFileName(AFileName)),AImageData);
  finally
    I.Free;
  end;
end;

function TImageCache.LoadIcon(const AFileName: String): Integer;
Var AImageData : TImageData;
    Ext : String;
begin
  Ext:=ExtUpperCase(ExtractFileExt(AFileName));
  If (Ext<>'.ICO') and (Ext<>'.EXE') then begin
    result:=LoadImageAsIcon(AFileName);
    exit;
  end;

  result:=-1;
  AImageData:=TImageData.Create;
  if not AImageData.LoadIcon(AFileName) then begin AImageData.Free; exit; end;
  result:=FImageList.AddObject(ExtUpperCase(ExtractFileName(AFileName)),AImageData);
end;

function TImageCache.LoadPicture(const AFileName: String): Integer;
Var AImageData : TImageData;
begin
  result:=-1;
  AImageData:=TImageData.Create;
  if not AImageData.LoadPicture(AFileName) then begin AImageData.Free; exit; end;
  result:=FImageList.AddObject(ExtUpperCase(ExtractFileName(AFileName)),AImageData);
end;

function TImageCache.FindFile(const AFileName: String): Integer;
Var S,T : String;
    MinPos,I : Integer;
begin
  result:=-1;
  S:=ExtUpperCase(ExtractFileName(AFileName));
  T:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));

  MinPos:=FImageList.IndexOf(S);
  If MinPos<0 then exit;
  While (MinPos>0) and (FImageList[MinPos-1]=S) do dec(MinPos);
  For I:=MinPos to FImageList.Count-1 do If (FImageList[I]=S) and (TImageData(FImageList.Objects[I]).Path=T) then begin result:=I; exit; end;
end;

function TImageCache.GetIcon(const AFileName: String): TIcon;
Var Nr : Integer;
begin
  result:=nil;

  Nr:=FindFile(AFileName);
  If Nr<0 then begin
    Nr:=LoadIcon(AFileName);
    if Nr<0 then exit;
  end;

  If Nr>=0 then result:=TImageData(FImageList.Objects[Nr]).Icon;
end;

function TImageCache.GetPicture(const AFileName: String): TPicture;
Var Nr : Integer;
begin
  result:=nil;

  Nr:=FindFile(AFileName);
  If Nr<0 then begin
    Nr:=LoadPicture(AFileName);
    if Nr<0 then exit;
  end;

  If Nr>=0 then result:=TImageData(FImageList.Objects[Nr]).Picture;
end;

procedure TImageCache.Clear;
Var I : Integer;
begin
  For I:=0 to FImageList.Count-1 do TImageData(FImageList.Objects[I]).Free;
  FImageList.Clear;
end;

initialization
  IconCache:=TImageCache.Create;
  PictureCache:=TImageCache.Create;
finalization
  IconCache.Free;
  PictureCache.Free;
end.
