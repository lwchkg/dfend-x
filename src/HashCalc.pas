unit HashCalc;
interface

Function GetMD5Sum(const FileName : String; const SmallFile : Boolean) : String;

implementation

uses Classes, SysUtils, HashAlgMD5_U, HashValue_U;

Var HashAlgMD5 : THashAlgMD5;
    HashValue: THashValue;

Function GetMD5Sum(const FileName : String; const SmallFile : Boolean) : String;
Var FileStream : TFileStream;
    MemoryStream : TMemoryStream;
begin
  result:='';
  if (Trim(FileName)='') or (not FileExists(FileName)) then exit;

  If SmallFile then begin
    FileStream:=nil;
    try MemoryStream:=TMemoryStream.Create; except exit; end;
  end else begin
    try FileStream:=TFileStream.Create(FileName,fmOpenRead); except exit; end;
    MemoryStream:=nil;
  end;
  try
    If SmallFile then MemoryStream.LoadFromFile(FileName);
    HashAlgMD5.Init;
    If SmallFile then HashAlgMD5.Update(MemoryStream) else HashAlgMD5.Update(FileStream);
  finally
    FileStream.Free;
    MemoryStream.Free;
  end;
  
  HashAlgMD5.Final(HashValue);
  result:=HashValue.ValueAsASCIIHex;
end;

initialization
  HashAlgMD5:=THashAlgMD5.Create(nil);
  HashValue:=THashValue.Create;
finalization
  HashAlgMD5.Free;
  HashValue.Free;
end.
