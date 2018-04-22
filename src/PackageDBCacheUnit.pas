unit PackageDBCacheUnit;
interface

uses Classes;

Type TCachedPackage=class
  private
    FName, FDescription, FFilename, FPackageChecksum : String;
    FSize : Integer;
  public
    Constructor Create(const AName, ADescription, AFilename : String); {if file is available PackageChecksum will be set}
    property Name : String read FName;
    property Description : String read FDescription;
    property Filename : String read FFilename;
    property PackageChecksum : String read FPackageChecksum;
    property Size : Integer read FSize;
end;

Type TPackageDBCache=class
  private
    FDBDir : String;
    FList : TList;
    Procedure InitDBDir;
    function GetCount: Integer;
    function GetPackage(I: Integer): TCachedPackage;
    Procedure LoadCache;
    Procedure SaveCache;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure ClearCache;
    Function FindPackage(const AName : String) : TCachedPackage;
    Procedure AddCache(const AName, ADescription, AFilename : String);
    Procedure DelCache(const AName : String); overload;
    Procedure DelCache(const ACachedPackage : TCachedPackage); overload;
    Function FindChecksum(const AName : String) : String;
    property DBDir : String read FDBDir;
    property Count : Integer read GetCount;
    property Package[I : Integer] : TCachedPackage read GetPackage;
end;

implementation

uses Windows, SysUtils, Forms, XMLDoc, XMLIntf, MSXMLDOM, PrgConsts, CommonTools,
     HashCalc, PackageDBToolsUnit, PrgSetupUnit;

{ TCachedPackage }

constructor TCachedPackage.Create(const AName, ADescription, AFilename : String);
Var Rec : TSearchRec;
    I : Integer;
begin
  inherited Create;
  FName:=AName;
  FDescription:=ADescription;
  FFilename:=AFilename;
  FPackageChecksum:=GetMD5Sum(FFilename,False);

  If not FileExists(FFilename) then exit;
  I:=FindFirst(FFilename,faAnyFile,Rec);
  try
    If I=0 then FSize:=Rec.Size;
  finally
    FindClose(Rec);
  end;
end;

{ TPackageDBCache }

constructor TPackageDBCache.Create;
begin
  inherited Create;
  InitDBDir;
  FList:=TList.Create;
  LoadCache;
end;

destructor TPackageDBCache.Destroy;
Var I : Integer;
begin
  SaveCache;
  For I:=0 to FList.Count-1 do TPackageDBCache(FList[I]).Free;
  FList.Free;
  inherited Destroy;
end;

procedure TPackageDBCache.InitDBDir;
begin
  FDBDir:=IncludeTrailingPathDelimiter(PrgDataDir+PackageDBCacheSubFolder);
  ForceDirectories(FDBDir);
end;

function TPackageDBCache.GetCount: Integer;
begin
  result:=FList.Count;
end;

function TPackageDBCache.GetPackage(I: Integer): TCachedPackage;
begin
  If (I<0) or (I>=FList.Count) then result:=nil else result:=TCachedPackage(FList[I]);
end;

Function TPackageDBCache.FindPackage(const AName : String) : TCachedPackage;
Var I : Integer;
begin
  result:=nil;
  For I:=0 to FList.Count-1 do If TCachedPackage(FList[I]).Name=AName then begin result:=TCachedPackage(FList[I]); exit; end;
end;

Procedure TPackageDBCache.AddCache(const AName, ADescription, AFilename : String);
begin
  FList.Add(TCachedPackage.Create(AName,ADescription,AFilename));
  SaveCache;
end;

Procedure TPackageDBCache.DelCache(const AName : String);
begin
  DelCache(FindPackage(AName));
end;

Procedure TPackageDBCache.DelCache(const ACachedPackage : TCachedPackage);
begin
  If ACachedPackage=nil then exit;
  ExtDeleteFile(ACachedPackage.Filename,ftUninstall);
  ACachedPackage.Free;
  FList.Delete(FList.IndexOf(ACachedPackage));
  SaveCache;
end;

function TPackageDBCache.FindChecksum(const AName: String): String;
Var I : Integer;
begin
  result:='';
  For I:=0 to FList.Count-1 do If TCachedPackage(FList[I]).Name=AName then begin result:=TCachedPackage(FList[I]).PackageChecksum; exit; end;
end;

procedure TPackageDBCache.LoadCache;
Var XMLDoc : TXMLDocument;
    Rec : TSearchRec;
    I : Integer;
    S : String;
    OK : Boolean;
    N : IXMLNode;
begin
  {Step 1: Read xml file}
  XMLDoc:=LoadXMLDoc(FDBDir+PackageDBCacheFile);
  If XMLDoc<>nil then try
    If XMLDoc.DocumentElement.NodeName='DFRPackagesCache' then For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
      N:=XMLDoc.DocumentElement.ChildNodes[I];
      If (N.NodeName='ExePackage') and (N.HasAttribute('Name')) and (N.HasAttribute('Description')) and (N.NodeValue<>'') then
      FList.Add(TCachedPackage.Create(N.Attributes['Name'],N.Attributes['Description'],FDBDir+N.NodeValue));
    end;
  finally
    XMLDoc.Free;
  end;

  {Step 2: Read directory and add missing files}
  I:=FindFirst(FDBDir+'*.exe',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        S:=ExtUpperCase(Rec.Name);
        OK:=False;
        For I:=0 to FList.Count-1 do If ExtUpperCase(ExtractFileName(TCachedPackage(FList[I]).Filename))=S then begin OK:=True; break; end;
        If not OK then FList.Add(TCachedPackage.Create(ChangeFileExt(Rec.Name,''),ChangeFileExt(Rec.Name,''),FDBDir+Rec.Name));
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TPackageDBCache.SaveCache;
Var XMLDoc : TXMLDocument;
    I : Integer;
    N : IXMLNode;
begin
  If FList.Count=0 then begin
    ExtDeleteFile(FDBDir+PackageDBCacheFile,ftTemp);
    exit;
  end;

  XMLDoc:=TXMLDocument.Create(Application.MainForm);
  try
    XMLDoc.Options:=XMLDoc.Options+[doNodeAutoIndent];
    XMLDoc.NodeIndentStr:='  ';
    XMLDoc.Active:=True;
    XMLDoc.DocumentElement:=XMLDoc.CreateNode('DFRPackagesCache');
    For I:=0 to FList.Count-1 do begin
      N:=XMLDoc.DocumentElement.AddChild('ExePackage');
      N.Attributes['Name']:=TCachedPackage(FList[I]).Name;
      N.Attributes['Description']:=TCachedPackage(FList[I]).Description;
      N.NodeValue:=ExtractFileName(TCachedPackage(FList[I]).Filename);
    end;
    XMLDoc.SaveToFile(FDBDir+PackageDBCacheFile);
  finally
    XMLDoc.Free;
  end;
end;

procedure TPackageDBCache.ClearCache;
Var I : Integer;
begin
  For I:=0 to FList.Count-1 do begin
    ExtDeleteFile(TCachedPackage(FList[I]).Filename,ftUninstall);
    TCachedPackage(FList[I]).Free;
  end;
  FList.Clear;
  SaveCache;
end;

end.
