unit ChecksumScanner;
interface

uses Classes;

Type TChecksumScanner=class
  private
    FDirectory, FFileMask : String;
    FFileNames, FChecksums : TStringList;
    FOwner : TComponent;
    FSmallFiles : Boolean;
    FShowScanDialog  : Boolean;
    Function GetCount: Integer;
  protected
    Function GetFileChecksum(const Filename : String) : String; virtual;
  public
    Constructor Create(const ADirectory, AFileMask : String; const ASmallFiles : Boolean; const AShowScanDialog : Boolean; const AOwner : TComponent);
    Destructor Destroy; override;
    Procedure ReScan;
    Function GetChecksum(const AFileName : String) : String;
    Function ChecksumInList(const AChecksum : String) : Boolean;
    property Directory : String read FDirectory;
    property Count : Integer read GetCount;
end;

Type TLanguageFileChecksumScanner=class(TChecksumScanner)
  protected
    Function GetFileChecksum(const Filename : String) : String; override;
  public
    Constructor Create(const ADirectory : String; const AShowScanDialog : Boolean; const AOwner : TComponent);  
end;

implementation

uses SysUtils, IniFiles, CommonTools, HashCalc, WaitFormUnit, LanguageSetupUnit;

{ TChecksumScanner }

constructor TChecksumScanner.Create(const ADirectory, AFileMask : String; const ASmallFiles : Boolean; const AShowScanDialog : Boolean; const AOwner : TComponent);
begin
  inherited Create;
  FDirectory:=IncludeTrailingPathDelimiter(ADirectory);
  FFileMask:=AFileMask;
  FFileNames:=TStringList.Create;
  FChecksums:=TStringList.Create;
  FFileNames.Capacity:=1500;
  FChecksums.Capacity:=1500;
  FSmallFiles:=ASmallFiles;
  FShowScanDialog:=AShowScanDialog;
  FOwner:=AOwner;
  ReScan;
end;

destructor TChecksumScanner.Destroy;
begin
  FFileNames.Free;
  FChecksums.Free;
  inherited Destroy;
end;

Function TChecksumScanner.GetCount: Integer;
begin
  result:=FFileNames.Count;
end;

function TChecksumScanner.GetFileChecksum(const Filename: String): String;
begin
  result:=GetMD5Sum(Filename,FSmallFiles);
end;

procedure TChecksumScanner.ReScan;
Var Rec : TSearchRec;
    I : Integer;
    WaitForm : TWaitForm;
begin
  FFileNames.Clear;
  FChecksums.Clear;

  I:=FindFirst(FDirectory+FFileMask,faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then FFileNames.AddObject(ExtUpperCase(Rec.Name),TObject(FFileNames.Count));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If FShowScanDialog and ((FFileNames.Count>100) or ((not FSmallFiles) and (FFileNames.Count>20))) then WaitForm:=CreateWaitForm(FOwner,LanguageSetup.PackageManagerScanning,FFileNames.Count) else WaitForm:=nil;
  try
    For I:=0 to FFileNames.Count-1 do begin
      If Assigned(WaitForm) and (I mod 10=0) then WaitForm.Step(I);
      FChecksums.Add(GetFileChecksum(FDirectory+FFileNames[I]));
    end;
  finally
    If Assigned(WaitForm) then FreeAndNil(WaitForm);
  end;

  FFileNames.Sort;
end;

Function TChecksumScanner.GetChecksum(const AFileName: String): String;
Var I : integer;
begin
  result:='';
  I:=FFileNames.IndexOf(ExtUpperCase(AFileName)); If I<0 then exit;
  result:=FChecksums[Integer(FFileNames.Objects[I])];
end;

Function TChecksumScanner.ChecksumInList(const AChecksum : String) : Boolean;
begin
  result:=(FChecksums.IndexOf(AChecksum)>=0);
end;

{ TLanguageFileChecksumScanner }

constructor TLanguageFileChecksumScanner.Create(const ADirectory: String; const AShowScanDialog: Boolean; const AOwner: TComponent);
begin
  inherited Create(ADirectory,'*.ini',true,AShowScanDialog,AOwner);
end;

function TLanguageFileChecksumScanner.GetFileChecksum(const Filename: String): String;
Var Ini : TIniFile;
begin
  Ini:=TIniFile.Create(Filename);
  try
    result:=Ini.ReadString('LanguageFileInfo','DownloadChecksum',inherited GetFileChecksum(Filename));
  finally
    Ini.Free;
  end;
end;

end.
