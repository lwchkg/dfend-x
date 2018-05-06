unit ScreenshotsCacheUnit;
interface

uses Classes, Graphics;

Type TScreenshotsCache=class
  private
    Thumbnails: TList;
    DataLoaded : Boolean;
    ThumbnailCacheSize : Integer;
    function GetCacheFile: String;
    function CalcThumbnail(const ScreenshotFile : String; const Width, Height : Integer) : TBitmap;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure LoadData;
    Procedure SaveData;
    Function GetThumbnail(const ScreenshotFile : String; const Width, Height : Integer) : TBitmap;
    property CacheFile : String read GetCacheFile;
end;

Var ScreenshotsCache : TScreenshotsCache;

implementation

{DEFINE DebugThumbnailCache}

uses SysUtils, {$IFDEF DebugThumbnailCache}Dialogs,{$ENDIF} Math, System.ZLib,
     PNGImage, jpeg, GIFImage, ImageStretch, PrgSetupUnit, PrgConsts, CommonTools;

{ TThumbnail }

Type TThumbnail=class
  private
    Image, ImageCompressed : TMemoryStream;
    ImageSize : Integer;
    Procedure SetImage(const B : TBitmap);
    Function GetImage : TBitmap;
  public
    Name : String;
    Width, Height : Integer;
    Date : TDateTime;
    Constructor Create;
    Destructor Destroy; override;
    Procedure Load(const Stream : TStream);
    Procedure Save(const Stream : TStream);
    property Bitmap : TBitmap read GetImage write SetImage;
end;

constructor TThumbnail.Create;
begin
  Image:=nil;
  ImageCompressed:=TMemoryStream.Create;
end;

destructor TThumbnail.Destroy;
begin
  if Image<>nil then Image.Free;
  ImageCompressed.Free;
  inherited Destroy;
end;

procedure TThumbnail.Load(const Stream: TStream);
Var I : Integer;
begin
  Stream.Read(I,SizeOf(Integer)); SetLength(Name,I); Stream.Read(Name[1],I);
  Stream.Read(Width,SizeOf(Integer));
  Stream.Read(Height,SizeOf(Integer));
  Stream.Read(Date,SizeOf(TDateTime));
  Stream.Read(ImageSize,SizeOf(Integer));
  Stream.Read(I,SizeOf(Integer)); ImageCompressed.SetSize(I); Stream.Read(ImageCompressed.Memory^,I);
end;

procedure TThumbnail.Save(const Stream: TStream);
Var I : Integer;
begin
  I:=length(Name); Stream.Write(I,SizeOf(Integer)); Stream.Write(Name[1],I);
  Stream.Write(Width,SizeOf(Integer));
  Stream.Write(Height,SizeOf(Integer));
  Stream.Write(Date,SizeOf(TDateTime));
  Stream.Write(ImageSize,SizeOf(Integer));
  I:=ImageCompressed.Size; Stream.Write(I,SizeOf(Integer)); Stream.Write(ImageCompressed.Memory^,I);
end;

function TThumbnail.GetImage: TBitmap;
Var Decompress : TDecompressionStream;
begin
  if Image=nil then begin
    Image:=TMemoryStream.Create;

    ImageCompressed.Position:=0;
    Decompress:=TDecompressionStream.Create(ImageCompressed);
    try
      Image.CopyFrom(Decompress,ImageSize);
    finally
      Decompress.Free;
    end;
  end;

  result:=TBitmap.Create;
  Image.Position:=0;
  result.LoadFromStream(Image);
end;

procedure TThumbnail.SetImage(const B: TBitmap);
Var Compress : TCompressionStream;
begin
  if Image=nil then Image:=TMemoryStream.Create;
  Image.Clear; B.SaveToStream(Image); Image.Position:=0;

  ImageCompressed.Clear;
  ImageSize:=Image.Size;
  Compress:=TCompressionStream.Create(clFastest,ImageCompressed);
  try
    Compress.Write(Image.Memory^,Image.Size);
  finally
    Compress.Free;
  end;
end;

{ TScreenshotsCache }

constructor TScreenshotsCache.Create;
begin
  Thumbnails:=TList.Create;
  DataLoaded:=False;
  ThumbnailCacheSize:=500;
end;

destructor TScreenshotsCache.Destroy;
Var I : Integer;
begin
  If DataLoaded then SaveData;
  for I:=0 to Thumbnails.Count-1 do TThumbnail(Thumbnails[I]).Free;
  Thumbnails.Free;
  inherited Destroy;
end;

function TScreenshotsCache.GetCacheFile: String;
begin
  result:=PrgDataDir+SettingsFolder+'\'+ScreenshotsCacheFileName;
end;

procedure TScreenshotsCache.LoadData;
Var Stream : TFileStream;
    Thumbnail : TThumbnail;
    S : String;
begin
  ThumbnailCacheSize:=PrgSetup.ThumbnailCacheSize;
  if not PrgSetup.BinaryCache then exit;
  if not FileExists(CacheFile) then exit;

  Stream:=TFileStream.Create(CacheFile,fmOpenRead);
  try
    try
      if Stream.Size<length(CacheVersionString) then exit;
      SetLength(S,length(CacheVersionString)); Stream.Read(S[1],length(S));
      if S<>CacheVersionString then exit;      

      while Stream.Position<Stream.Size do begin
        Thumbnail:=TThumbnail.Create;
        try
          Thumbnail.Load(Stream);
          Thumbnails.Add(Thumbnail);
        except
          Thumbnail.Free; raise;
        end;
      end;
      {$IFDEF DebugThumbnailCache} ShowMessage(IntToStr(Thumbnails.Count)+' cached thumbnails loaded'); {$ENDIF}
    finally
      Stream.Free;
    end;
  except exit; end;
end;

procedure TScreenshotsCache.SaveData;
Var Stream : TFileStream;
    I : Integer;
    S : String;
begin
  Stream:=TFileStream.Create(CacheFile,fmCreate);
  S:=CacheVersionString; Stream.Write(S[1],length(S));
  try
    for I:=Max(0,Thumbnails.Count-ThumbnailCacheSize) to Thumbnails.Count-1 do TThumbnail(Thumbnails[I]).Save(Stream);
  finally
    Stream.Free;
  end;
end;

Procedure CalcWH(const OldW, OldH, MaxW, MaxH : Integer; var NewW, NewH : Integer);
Var F : Double;
begin
  F:=OldW/OldH;

  If (OldW<=MaxW) and (OldH<=MaxH) then begin
    {too small scale up}
    If MaxH*F>MaxW then begin NewW:=MaxW; NewH:=Round(NewW/F); end else begin NewH:=MaxH; NewW:=Round(NewH*F); end;
    exit;
  end;

  {scale down}
  If OldW>MaxW then begin
    {too wide}
    NewW:=MaxW; NewH:=Round(NewW/F);
    {also to high ?}
    If NewH>MaxH then begin NewH:=MaxH; NewW:=Round(NewH*F); end;
    exit;
  end;

  {too high}
  NewH:=MaxH; NewW:=Round(NewH*F);
  {also too wide ?}
  If NewW>MaxW then begin NewW:=MaxW; NewH:=Round(NewW/F); end;
end;

function TScreenshotsCache.CalcThumbnail(const ScreenshotFile: String; const Width, Height: Integer): TBitmap;
Var S : String;
    P : TPNGObject;
    J : TJPEGImage;
    G : TGIFImage;
    B : TBitmap;
    NewW, NewH : Integer;
begin
  result:=nil;
  S:=ExtUpperCase(ExtractFileExt(ScreenshotFile));

  If S='.PNG' then begin
    P:=TPNGObject.Create;
    try
      try P.LoadFromFile(ScreenshotFile); except exit; end;
      B:=TBitmap.Create;
      try
        try
          B.Width:=P.Width; B.Height:=P.Height; P.Draw(B.Canvas,Rect(0,0,B.Width-1,B.Height-1));
          result:=TBitmap.Create;
          try
            result.SetSize(Width,Height);
            CalcWH(B.Width,B.Height,Width,Height,NewW,NewH);
            ScaleImage(B,result,NewW,NewH);
          except FreeAndNil(result); exit; end;
          exit;
        except exit; end;
      finally B.Free; end;
    finally P.Free; end;
  end;

  If (S='.JPG') or (S='.JPEG') then begin
    J:=TJPEGImage.Create;
    try
      try J.LoadFromFile(ScreenshotFile); except exit; end;
      B:=TBitmap.Create;
      try
        try
          B.Assign(J);
          result:=TBitmap.Create;
          try
            result.SetSize(Width,Height);
            CalcWH(B.Width,B.Height,Width,Height,NewW,NewH);
            ScaleImage(B,result,NewW,NewH);
          except FreeAndNil(result); exit; end;
          exit;
        except exit; end;
      finally B.Free; end;
    finally J.Free; end;
  end;

  If S='.GIF' then begin
    G:=TGifImage.Create;
    try
      try G.LoadFromFile(ScreenshotFile); except exit; end;
      B:=TBitmap.Create;
      try
        try
          B.Assign(G);
          result:=TBitmap.Create;
          try
            result.SetSize(Width,Height);
            CalcWH(B.Width,B.Height,Width,Height,NewW,NewH);
            ScaleImage(B,result,NewW,NewH);
          except FreeAndNil(result); end;
          exit;
        except exit; end;
      finally B.Free; end;
    finally G.Free; end;
  end;

  If S='.BMP' then begin
    B:=TBitmap.Create;
    try
      try B.LoadFromFile(ScreenshotFile); except exit; end;
      result:=TBitmap.Create;
      try
        result.SetSize(Width,Height);
        CalcWH(B.Width,B.Height,Width,Height,NewW,NewH);
        ScaleImage(B,result,NewW,NewH);
      except FreeAndNil(result); end;
      exit;
    finally B.Free; end;
  end;
end;

function TScreenshotsCache.GetThumbnail(const ScreenshotFile: String; const Width, Height: Integer): TBitmap;
Var D : TDateTime;
    I : Integer;
    T : TThumbnail;
    S : String;
begin
  {Check if screenshot file exists}
  if not FileExists(ScreenshotFile) then begin
    result:=TBitmap.Create;
    result.SetSize(Width,Height);
    exit;
  end;

  if not DataLoaded then begin
    DataLoaded:=True;
    LoadData;
  end;

  D:=GetFileDate(ScreenshotFile);
  S:=ExtractFileName(ScreenshotFile);

  {Try to find cache record}
  for I:=0 to Thumbnails.Count-1 do begin
    T:=TThumbnail(Thumbnails[I]);
    if (T.Name<>S) or (T.Date<>D) or (T.Width<>Width) or (T.Height<>Height) then continue;
    result:=T.Bitmap;
    exit;
  end;

  {Create Thumbnail and Cache it}
  result:=CalcThumbnail(ScreenshotFile,Width,Height);
  if result<>nil then begin
    T:=TThumbnail.Create;
    T.Name:=S; T.Date:=D; T.Width:=Width; T.Height:=Height;
    T.Bitmap:=result;
    Thumbnails.Add(T);
  end else begin
    {$IFDEF DebugThumbnailCache} ShowMessage('Error: Cannot process '+ScreenshotFile); {$ENDIF}
  end;
end;

initialization
  ScreenshotsCache:=TScreenshotsCache.Create;
finalization
  ScreenshotsCache.Free;
end.
