unit PackageDBToolsUnit;
interface

uses Classes, XMLDoc, XMLIntf;

const PackageMaxFileSize=MaxInt;

Function LoadXMLDoc(const FileName : String; var XMLDoc : TXMLDocument; const OrigFileName : String ='') : String; overload;
Function LoadXMLDoc(const FileName : String; const OrigFileName : String ='') : TXMLDocument; overload;

Function SaveXMLDoc(const Doc : IXMLDocument; const Lines : Array of String; const Standalone : Boolean) : TStringList; overload;
Procedure SaveXMLDoc(const Doc : IXMLDocument; const Lines : Array of String; const Datei : String; const Standalone : Boolean); overload;

Function DecodeUpdateDate(S : String) : TDateTime;
Function EncodeUpdateDate(const Date : TDateTime) : String;

function DownloadFile(const URL: String; const Quite : Boolean): TMemoryStream; overload;
function DownloadFile(const URL, FileName: String; const Quite : Boolean): Boolean; overload;

Function GetNiceFileSize(const Size : Int64) : String;

Function ExtractFileNameFromURL(const URL, DefaultExtension : String; const RemoveDirs : Boolean) : String;
Function URLFileNameFromFileName(const FileName : String) : String;
Function ReplaceBRs(const S : String) : String;

Procedure ClearPackageCache;

Function UpdatePackageDB(const Owner : TComponent; const UpdateAllListe, Quite : Boolean) : Boolean;

implementation

uses Windows, SysUtils, Forms, Dialogs, Controls, Math, IdHTTP, LanguageSetupUnit,
     CommonTools, PrgConsts, PrgSetupUnit, PackageDBUnit, DownloadWaitFormUnit;

Function LoadXMLDoc(const FileName : String; var XMLDoc : TXMLDocument; const OrigFileName : String) : String;
Var MSt : TMemoryStream;
    ErrorFileName : String;
begin
  result:=''; XMLDoc:=nil;

  if not FileExists(FileName) then exit;

  If Trim(OrigFileName)='' then ErrorFileName:=FileName else ErrorFileName:=OrigFileName;

  XMLDoc:=TXMLDocument.Create(Application.MainForm);

  MSt:=TMemoryStream.Create;
  try
    try
      MSt.LoadFromFile(FileName);
    except
      result:=Format(LanguageSetup.MessageCouldNotOpenFile,[ErrorFileName]);
      FreeAndNil(XMLDoc);
      exit;
    end;
    try
      XMLDoc.LoadFromStream(MSt);
    except
      result:=Format(LanguageSetup.MessageCouldNotActivateXML,[ErrorFileName]);
      FreeAndNil(XMLDoc);
      exit;
    end;
  finally
    MSt.Free;
  end;
  XMLDoc.FileName:=FileName;

  If not XMLDoc.Active then begin
    result:=Format(LanguageSetup.MessageCouldNotActivateXML,[ErrorFileName]);
    FreeAndNil(XMLDoc);
    exit;
  end;
end;

Function LoadXMLDoc(const FileName : String; const OrigFileName : String) : TXMLDocument;
Var S : String;
begin
  S:=LoadXMLDoc(FileName,result,OrigFileName);
  If S<>'' then MessageDlg(S,mtError,[mbOk],0);
end;

Function SaveXMLDoc(const Doc : IXMLDocument; const Lines : Array of String; const Standalone : Boolean) : TStringList;
Var S : String;
    X : Integer;
begin
  Doc.Version:='1.0';
  If Standalone then Doc.StandAlone:='yes' else Doc.StandAlone:='no';
  Doc.Encoding:='UTF-8'; {ISO-8859-1}
  Doc.NodeIndentStr:='  ';
  Doc.Options:=Doc.Options+[doNodeAutoIndent];

  Doc.SaveToXML(S);
  try
    S:=FormatXMLData(S);
  except end;
  result:=TStringList.Create;

  result.Text:=S;
  If Standalone
    then result[0]:='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    else result[0]:='<?xml version="1.0" encoding="UTF-8" standalone="no"?>';
  For X:=Low(Lines) to High(Lines) do result.Insert(1+X-Low(Lines),Lines[X]);
end;

Procedure SaveXMLDoc(const Doc : IXMLDocument; const Lines : Array of String; const Datei : String; const Standalone : Boolean);
Var St : TStringList;
begin
  St:=SaveXMLDoc(Doc,Lines,Standalone);
  try
    St.SaveToFile(Datei);
  finally
    St.Free;
  end;
end;

Function DecodeUpdateDate(S : String) : TDateTime;
Var I: Integer;
    D,M,Y : Integer;
begin
  result:=0;

  I:=Pos('/',S); If I=0 then exit;
  try M:=StrToInt(Copy(S,1,I-1)); except exit; end;
  S:=Copy(S,I+1,MaxInt);

  I:=Pos('/',S); If I=0 then exit;
  try D:=StrToInt(Copy(S,1,I-1)); except exit; end;
  S:=Copy(S,I+1,MaxInt);

  try Y:=StrToInt(S); except exit; end;

  try result:=EncodeDate(Y,M,D); except exit; end;
end;

Function EncodeUpdateDate(const Date : TDateTime) : String;
Var Y,M,D : Word;
    S1,S2,S3 : String;
begin
  DecodeDate(Date,Y,M,D);
  S1:=IntToStr(M); if length(S1)<2 then S1:='0'+S1;
  S2:=IntToStr(D); if length(S2)<2 then S2:='0'+S2;
  S3:=IntToStr(Y); if length(S3)<2 then S3:='0'+S3;
  result:=S1+'/'+S2+'/'+S3;
end;

function DownloadFileFromInternet(const URL: String; const Quite : Boolean): TMemoryStream;
Var HTTP: TIdHTTP;
begin
  result:=nil;

  HTTP:=TIdHTTP.Create(Application.MainForm);
  try
    result:=TMemoryStream.Create;
    try
      HTTP.Get(URL,result);
    except
      If not Quite then MessageDlg(Format(LanguageSetup.PackageManagerDownloadFailed,[URL]),mtError,[mbOK],0);
      FreeAndNil(result);
    end;
  finally
    HTTP.Free;
  end;
end;

Function GetFileFromAnyDrive(const Path : String) : TMemoryStream;
Var C : Char;
    I, SaveErrorMode : Integer;
begin
  result:=nil;
  If (length(Path)<2) or (Path[2]<>':') then exit;

  For C:='A' to 'Z' do begin
    I:=GetDriveType(PChar(C+':\'));
    If (I<>DRIVE_REMOVABLE) and (I<>DRIVE_FIXED) and (I<>DRIVE_CDROM) and (I<>DRIVE_RAMDISK) then continue;
    SaveErrorMode:=SetErrorMode(SEM_FAILCRITICALERRORS);
    try
      If FileExists(C+Copy(Path,2,MaxInt)) then begin
        result:=TMemoryStream.Create;
        try
          result.LoadFromFile(C+Copy(Path,2,MaxInt));
          result.Position:=0;
          exit;
        except
          FreeAndNil(result);
        end;
      end;
    finally
      SetErrorMode(SaveErrorMode);
    end;
  end;
end;

Function GetFileFromLocalPath(const Path : String) : TMemoryStream;
begin
  repeat
    result:=GetFileFromAnyDrive(Path);
    If result<>nil then exit;
    if MessageDlg(Format(LanguageSetup.PackageManagerMenuUpdateListsLocal,[ExtractFileName(Path)]),mtInformation,[mbOK,mbCancel],0)<>mrOK then exit;
  until False;
end;

function DownloadFile(const URL: String; const Quite : Boolean): TMemoryStream;
begin
  If ExtUpperCase(Copy(URL,1,7))='HTTP:/'+'/' then begin
    result:=DownloadFileFromInternet(URL,Quite);
  end else begin
    result:=GetFileFromLocalPath(URL);
  end;
end;

function DownloadFile(const URL, FileName: String; const Quite : Boolean): Boolean;
Var MSt : TMemoryStream;
begin
  result:=False;
  MSt:=DownloadFile(URL,Quite);
  If MSt=nil then exit;
  try
    try
      MSt.SaveToFile(FileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[FileName]),mtError,[mbOK],0);
      exit;
    end;
    result:=True;
  finally
    MSt.Free;
  end;
end;

Function GetNiceFileSize(const Size : Int64) : String;
begin
  If Size<1024 then begin result:=IntToStr(Size)+' '+LanguageSetup.Bytes; exit; end;
  If Size<1024*1024 then begin result:=IntToStr(Size div 1024)+' '+LanguageSetup.KBytes; exit; end;
  result:=IntToStr(Size div 1024 div 1024)+' '+LanguageSetup.MBytes;
end;

Function ExtractFileNameFromURL(const URL, DefaultExtension : String; const RemoveDirs : Boolean) : String;
const Exts : Array[0..6] of String = ('.EXE','.ZIP','.7Z','.ICO','.INI','.PROF','.XML');
Var I : Integer;
    S : String;
begin
  result:=URL;

  If (ExtUpperCase(Copy(URL,1,7))='HTTP:/'+'/') or (Pos('/',URL)>0) then begin
    If ExtUpperCase(Copy(URL,1,7))='HTTP:/'+'/' then result:=Copy(result,8,MaxInt);
    If RemoveDirs then begin
      I:=Pos('/',result); while I>0 do begin result:=Copy(result,I+1,MaxInt); I:=Pos('/',result); end;
    end else begin
      result:=Replace(result,'/','-');
    end;
    result:=Replace(result,'%20',' ');
  end else begin
    result:=Replace(result,':','-');
    result:=Replace(result,'\','-');
    result:=Replace(result,'%20',' ');
    If ExtUpperCase(Copy(result,length(result)-3,4))='.XML' then result:=Trim(Copy(result,1,length(result)-4));
  end;

  result:=MakeFileSysOKFolderName(result);

  S:=ExtUpperCase(ExtractFileExt(ExtractFileName(result)));
  For I:=Low(Exts) to High(Exts) do If S=Exts[I] then exit;
  If S=ExtUpperCase(DefaultExtension) then exit;
  result:=result+DefaultExtension;
end;

Function URLFileNameFromFileName(const FileName : String) : String;
begin
  result:=Replace(FileName,' ','%20');
end;

Function ReplaceBRs(const S : String) : String;
begin
  result:=Replace(S,'\\',#13);
end;

Procedure ClearPackageCache;
Var I : Integer;
    Rec : TSearchRec;
    UserUpper : String;
    B : Boolean;
begin
  I:=FindFirst(PrgDataDir+PackageDBSubFolder+'\*.xml',faAnyFile,Rec);
  UserUpper:=ExtUpperCase(PackageDBUserFile);
  try
    While I=0 do begin
      B:=True;
      If ((Rec.Attr and faDirectory)=0) and (ExtUpperCase(Rec.Name)<>UserUpper) then ExtDeleteFile(PrgDataDir+PackageDBSubFolder+'\'+Rec.Name,ftTemp,True,B);
      if not B then exit;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  ExtDeleteFolder(PrgDataDir+PackageDBCacheSubFolder,ftTemp);
end;

Type TPackageDownloadStatusClass=class
  private
    FOwner : TComponent;
  public
    Constructor Create(const AOwner : TComponent);
    Procedure PackageDBDownload(Sender : TObject; const Progress, Size : Int64; const Status : TDownloadStatus; var ContinueDownload : Boolean);
end;

constructor TPackageDownloadStatusClass.Create(const AOwner: TComponent);
begin
  inherited Create;
  FOwner:=AOwner;
end;

Procedure TPackageDownloadStatusClass.PackageDBDownload(Sender : TObject; const Progress, Size : Int64; const Status : TDownloadStatus; var ContinueDownload : Boolean);
begin
  Case Status of
    dsStart : begin InitDownloadWaitForm(FOwner,Size div 1024); end;
    dsProgress : begin
                   If DownloadWaitForm.ProgressBar.Max=1 then DownloadWaitForm.ProgressBar.Max:=Max(1,Size div 1024);
                   ContinueDownload:=StepDownloadWaitForm(Progress div 1024);
                 end;
    dsDone : begin DoneDownloadWaitForm; end;
  End;
end;

Function UpdatePackageDB(const Owner : TComponent; const UpdateAllListe, Quite : Boolean) : Boolean;
Var PackageDB : TPackageDB;
    PackageDownloadStatusClass : TPackageDownloadStatusClass;
begin
  PackageDownloadStatusClass:=TPackageDownloadStatusClass.Create(Owner);
  try
    PackageDB:=TPackageDB.Create;
    try
      PackageDB.LoadDB(False,False,Quite);
      PackageDB.OnDownload:=PackageDownloadStatusClass.PackageDBDownload;
      result:=PackageDB.LoadDB(True,((Word(GetKeyState(VK_LSHIFT)) div 256)<>0) or ((Word(GetKeyState(VK_RSHIFT)) div 256)<>0),Quite);
    finally
      PackageDB.Free;
    end;
  finally
    PackageDownloadStatusClass.Free;
  end;
end;

end.
