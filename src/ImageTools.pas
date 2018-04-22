unit ImageTools;
interface

Function GetGeometryFromFile(const FileName : String) : String;
Function GetGemoetryFromMB(const Size : Integer) : String;
Function ShortName(const LongName : String) : String;

Function CheckCDImage(const FileName : String) : Boolean;

implementation

uses Windows, SysUtils, Classes, Math, PrgSetupUnit, CommonTools;

Function GetGeometryFromFile(const FileName : String) : String;
Var hFile : THandle;
    LoDWORD, HiDWORD : DWORD;
    LoI, HiI : Int64;
begin
  hFile:=CreateFile(PChar(FileName),GENERIC_READ,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  If hFile=INVALID_HANDLE_VALUE then begin
    result:='';
  end else begin
    try
      LoDWORD:=Windows.GetFileSize(hFile,@HiDWORD);
      LoI:=LoDWORD; HiI:=HiDWORD;
      LoI:=LoI+$100000000*HiI;
      LoI:=LoI div 512 div 63 div 16;
      result:='512,63,16,'+IntToStr(LoI);
    finally
      CloseHandle(hFile);
    end;
  end;
end;

Function GetGemoetryFromMB(const Size : Integer) : String;
begin
  {Correct way for calculating the size (512*63*16*X=Bytes => X=MBytes*128/63)
  but not the way mkdosfs works:
  I:=Size*128 div 63;
  result:='512,63,16,'+IntToStr(I);}

  {mkdosfs simply does this:}
  result:='512,63,16,'+IntToStr(Size*2);
end;

Function ShortName(const LongName : String) : String;
begin
  If PrgSetup.UseShortFolderNames then begin
    SetLength(result,MAX_PATH+10);
    if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
      then result:=LongName
      else SetLength(result,StrLen(PChar(result)));
  end else begin
    result:=LongName;
  end;
end;

Function SearchCueSheetKeyWords(const FileName : String) : Boolean;
const KeyWords : Array[0..12] of String = ('CATALOG','CDTEXTFILE','FILE','FLAGS','INDEX','ISRC','PERFORMER','POSTGAP','PREGAP','REM','SONGWRITER','TITLE','TRACK');
Var FSt : TFileStream;
    St : TStringList;
    I,J : Integer;
    S : String;
begin
  result:=False;
  FSt:=TFileStream.Create(FileName,fmOpenRead);
  try
    If FSt.Size>500*1024 then exit;
    St:=TStringList.Create;
    try
      St.LoadFromStream(FSt);
      For I:=0 to Min(50,St.Count-1) do begin
        S:=ExtUpperCase(St[I]);
        For J:=Low(KeyWords) to High(KeyWords) do if Pos(KeyWords[J],S)>0 then begin result:=True; exit; end;
      end;
    finally
      St.Free;
    end;
  finally
    FSt.Free;
  end;
end;

Function CheckISOImage(const FileName : String) : Boolean;
const ISOID=#01'CD001'#01;
Var FSt : TFileStream;
    S : String;
begin
  result:=False;
  SetLength(S,7);
  FSt:=TFileStream.Create(FileName,fmOpenRead);
  try
    If FSt.Size<$9400 then exit;
    result:=True;
    FSt.Position:=$8000; FSt.ReadBuffer(S[1],7); If S=ISOID then exit;
    FSt.Position:=$8018; FSt.ReadBuffer(S[1],7); If S=ISOID then exit;
    FSt.Position:=$9310; FSt.ReadBuffer(S[1],7); If S=ISOID then exit;
    FSt.Position:=$9318; FSt.ReadBuffer(S[1],7); If S=ISOID then exit;
    result:=False;
  finally
    FSt.Free;
  end;
end;

Function CheckCDImage(const FileName : String) : Boolean;
Var Ext : String;
begin
  result:=False;
  If not FileExists(FileName) then exit;

  Ext:=ExtUpperCase(ExtractFileExt(FileName));
  If Ext='.BIN' then begin result:=True; exit; end;
  If Ext='.CUE' then begin result:=SearchCueSheetKeyWords(FileName); exit; end;
  if Ext='.ISO' then begin result:=CheckISOImage(FileName); exit; end;

  result:=SearchCueSheetKeyWords(FileName); If result then exit;
  result:=CheckISOImage(FileName);
end;

end.
