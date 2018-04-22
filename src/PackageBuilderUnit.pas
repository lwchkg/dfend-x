unit PackageBuilderUnit;
interface

uses Classes, Forms, XMLDoc, GameDBUnit;

Function AddPackageDataZip(const Doc : TXMLDocument; const Game : TGame; const DataFileName : String) : Boolean;
Function AddPackageDataAutoSetup(const Doc : TXMLDocument; const DataFileName, MaxVersion : String) : Boolean;
Function AddPackageDataIcon(const Doc : TXMLDocument; const DataFileName : String) : Boolean;
Function AddPackageDataIconSet(const Doc : TXMLDocument; const IconSetIniFile : String; const DataFileName : String) : Boolean;
Function AddPackageDataLanguage(const Doc : TXMLDocument; const DataFileName : String) : Boolean;
Function AddPackageDataExe(const Doc : TXMLDocument; const DataFileName : String) : Boolean;
Function AddPackageDataPlainZip(const Doc : TXMLDocument; const DataFileName : String; const AutoSetupDB : TGameDB; const Owner : TComponent; const AddAutoSetups : Boolean; const AutoSetupsMaxVersion : String) : Boolean;

Function AddPackageDataHeader(const ParentForm : TForm; const Description : String) : TXMLDocument;
Function AddPackageDataFooter(const Doc : TXMLDocument) : TStringList;

implementation

uses Windows, SysUtils, Dialogs, IniFiles, XMLIntf, MSXMLDOM, CommonTools,
     HashCalc, PackageDBToolsUnit, LanguageSetupUnit, GameDBToolsUnit,
     PrgConsts, ZipInfoFormUnit, ZipPackageUnit;

Function FileOK(const DataFileName : String) : Boolean;
begin
  result:=FileExists(DataFileName);
  If not result then result:=FileExists(DataFileName+'.part1');
  If not result then MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
end;

Function MultiFileSize(const FileName : String) : Int64;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=0;
  I:=FindFirst(FileName+'.part*',faAnyFile,Rec);
  try
    While I=0 do begin
      result:=result+Rec.Size;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function AddPackageDataZip(const Doc : TXMLDocument; const Game : TGame; const DataFileName : String) : Boolean;
Var S : String;
    N : IXMLNode;
    LargeFile : Boolean;
begin
  result:=FileOK(DataFileName); if not result then exit;
  LargeFile:=(not FileExists(DataFileName)) and FileExists(DataFileName+'.part1');

  N:=Doc.DocumentElement.AddChild('Game');
  If Game=nil then S:='' else S:=Game.CacheName;
  N.Attributes['Name']:=S;
  If Game=nil then S:='' else S:=Game.CacheGenre;
  N.Attributes['Genre']:=S;
  If Game=nil then S:='' else S:=Game.CacheDeveloper;
  N.Attributes['Developer']:=S;
  If Game=nil then S:='' else S:=Game.CachePublisher;
  N.Attributes['Publisher']:=S;
  If Game=nil then S:='' else S:=Game.CacheYear;
  N.Attributes['Year']:=S;
  If Game=nil then S:='English' else S:=Game.CacheLanguage;
  N.Attributes['Language']:=S;
  If Game=nil then S:='' else S:=Game.License;
  N.Attributes['License']:=S;
  If LargeFile then S:=GetMD5Sum(DataFileName+'.part1',False) else GetMD5Sum(DataFileName,False);
  N.Attributes['PackageChecksum']:=S;
  CreateGameCheckSum(Game,False);
  N.Attributes['GameExeChecksum']:=Game.GameExeMD5;
  If LargeFile then S:=IntToStr(MultiFileSize(DataFileName)) else S:=IntToStr(GetFileSize(DataFileName));
  N.Attributes['Size']:=S;
  N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
end;

Function AddPackageDataAutoSetup(const Doc : TXMLDocument; const DataFileName, MaxVersion : String) : Boolean;
Var Ini : TIniFile;
    N : IXMLNode;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Ini:=TIniFile.Create(DataFileName);
  try
    N:=Doc.DocumentElement.AddChild('AutoSetup');
    N.Attributes['Name']:=Ini.ReadString('ExtraInfo','Name','');
    N.Attributes['Genre']:=Ini.ReadString('ExtraInfo','Genre','');
    N.Attributes['Developer']:=Ini.ReadString('ExtraInfo','Developer','');
    N.Attributes['Publisher']:=Ini.ReadString('ExtraInfo','Publisher','');
    N.Attributes['Year']:=Ini.ReadString('ExtraInfo','Year','');
    N.Attributes['Language']:=Ini.ReadString('ExtraInfo','Language','');
    N.Attributes['PackageChecksum']:=GetMD5Sum(DataFileName,False);
    N.Attributes['GameExeChecksum']:=Ini.ReadString('Extra','ExeMD5','');
    N.Attributes['Size']:=GetFileSize(DataFileName);
    If Trim(MaxVersion)<>'' then N.Attributes['MaxVersion']:=MaxVersion;
    N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataIcon(const Doc : TXMLDocument; const DataFileName : String) : Boolean;
Var N : IXMLNode;
begin
  result:=FileOK(DataFileName); if not result then exit;

  N:=Doc.DocumentElement.AddChild('Icon');
  N.Attributes['Name']:=ChangeFileExt(ExtractFileName(DataFileName),'');
  N.Attributes['FileChecksum']:=GetMD5Sum(DataFileName,False);
  N.Attributes['Size']:=GetFileSize(DataFileName);
  N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
end;

Function AddPackageDataIconSet(const Doc : TXMLDocument; const IconSetIniFile : String; const DataFileName : String) : Boolean;
Var Ini : TIniFile;
    I : Integer;
    S : String;
    N : IXMLNode;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Ini:=TIniFile.Create(IconSetIniFile);
  try
    N:=Doc.DocumentElement.AddChild('IconSet');
    N.Attributes['Name']:=Ini.ReadString('Information','Name',ChangeFileExt(ExtractFileName(DataFileName),''));
    N.Attributes['FileChecksum']:=GetMD5Sum(DataFileName,False);
    I:=VersionToInt(GetNormalFileVersionAsString); S:=IntToStr(I div 10000)+'.'+IntToStr((I div 100) mod 100)+'.';
    N.Attributes['MinVersion']:=S+'0';
    N.Attributes['MaxVersion']:=S+'99';
    N.Attributes['Author']:=Ini.ReadString('Information','Author','');
    N.Attributes['Size']:=GetFileSize(DataFileName);
    N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataLanguage(const Doc : TXMLDocument; const DataFileName : String) : Boolean;
Var Ini : TIniFile;
    I : Integer;
    S : String;
    N : IXMLNode;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Ini:=TIniFile.Create(DataFileName);
  try
    N:=Doc.DocumentElement.AddChild('Language');
    N.Attributes['Name']:=ChangeFileExt(ExtractFileName(DataFileName),'');
    I:=VersionToInt(Ini.ReadString('LanguageFileInfo','MaxVersion','')); S:=IntToStr(I div 10000)+'.'+IntToStr((I div 100) mod 100)+'.';
    N.Attributes['MinVersion']:=S+'0';
    N.Attributes['MaxVersion']:=S+'99';
    N.Attributes['Author']:=Ini.ReadString('Author','Name','');
    N.Attributes['PackageChecksum']:=GetMD5Sum(DataFileName,False);
    N.Attributes['Size']:=GetFileSize(DataFileName);
    N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataExe(const Doc : TXMLDocument; const DataFileName : String) : Boolean;
Var N : IXMLNode;
begin
  result:=FileOK(DataFileName); if not result then exit;

  N:=Doc.DocumentElement.AddChild('ExePackage');
  N.Attributes['Name']:=ChangeFileExt(ExtractFileName(DataFileName),'');
  N.Attributes['Description']:='';
  N.Attributes['PackageChecksum']:=GetMD5Sum(DataFileName,False);
  N.Attributes['Size']:=GetFileSize(DataFileName);
  N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
end;

Function GetAutoSetupTemplateForFolder(const AutoSetupDB : TGameDB; const Dir : String) : TGame;
Var S : String;
    St : TStringList;
    I : Integer;
begin
  result:=nil;
  S:=OnlySubFolderCheck(Dir);

  St:=GetTemplateFromFolderExt(False,S,AutoSetupDB,nil);
  try
    If St.Count=1 then begin
      I:=Integer(St.Objects[0]);
      If I>=0 then result:=AutoSetupDB[I];
    end;
  finally
    St.Free;
  end;
end;

Function GetNormalLastFileVersionAsString : String;
Var I,J : Integer;
    A,B,C : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  J:=GetFileVersionEx(ExpandFileName(Application.ExeName));
  A:=I div 65536;
  B:=I mod 65536;
  C:=J div 65536;
  If C>0 then dec(C) else begin
    C:=99;
    If B>0 then dec(B) else begin
      B:=9;
      dec(A);
    end;
  end;
  result:=Format('%d.%d.%d',[A,B,C]);
end;


Function AddPackageDataPlainZip(const Doc : TXMLDocument; const DataFileName : String; const AutoSetupDB : TGameDB; const Owner : TComponent; const AddAutoSetups : Boolean; const AutoSetupsMaxVersion : String) : Boolean;
Var Temp : String;
    Template : TGame;
    S : String;
    N : IXMLNode;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
  If not ForceDirectories(Temp) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Temp]),mtError,[mbOK],0);
    result:=False; exit;
  end;
  try
    if not ExtractZipFile(Owner,DataFileName,Temp) then exit;
    Template:=GetAutoSetupTemplateForFolder(AutoSetupDB,Temp);
    If AddAutoSetups and (Template<>nil) then CopyFile(PChar(Template.SetupFile),PChar(IncludeTrailingPathDelimiter(ExtractFilePath(DataFileName))+ExtractFileName(Template.SetupFile)),False);
    N:=Doc.DocumentElement.AddChild('Game');
    If Template=nil then begin
      N.Attributes['Name']:='Warning: No matching auto setup template for '+ExtractFileName(DataFileName);
    end else begin
      N.Attributes['Name']:=Template.CacheName;
      N.Attributes['Genre']:=Template.CacheGenre;
      N.Attributes['Developer']:=Template.CacheDeveloper;
      N.Attributes['Publisher']:=Template.CachePublisher;
      N.Attributes['Year']:=Template.CacheYear;
      N.Attributes['Language']:=Template.CacheLanguage;
      N.Attributes['License']:=Template.License;
      N.Attributes['PackageChecksum']:=GetMD5Sum(DataFileName,False);
      N.Attributes['GameExeChecksum']:=Template.GameExeMD5;
      N.Attributes['Size']:=GetFileSize(DataFileName);
      If AddAutoSetups then begin
        If Template=nil then S:='not found!' else S:=URLFileNameFromFileName(ExtractFileName(Template.SetupFile));
        N.Attributes['AutoSetupURL']:=S;
        If Trim(AutoSetupsMaxVersion)<>'' then N.Attributes['AutoSetupURLMaxVersion']:=AutoSetupsMaxVersion;
      end;
      N.NodeValue:=URLFileNameFromFileName(ExtractFileName(DataFileName));
    end;
  finally
    ExtDeleteFolder(Temp,ftTemp);
  end;
end;

Function AddPackageDataHeader(const ParentForm : TForm; const Description : String) : TXMLDocument;
begin
  result:=TXMLDocument.Create(ParentForm);
  try
    result.DOMVendor:=MSXML_DOM;
    result.Active:=True;
  except
    on E : Exception do begin MessageDlg(E.Message,mtError,[mbOK],0); FreeAndNil(result); exit; end;
  end;
  result.DocumentElement:=result.CreateNode('DFRPackagesFile');
  result.DocumentElement.Attributes['Name']:=Description;
  result.DocumentElement.Attributes['LastUpdateDate']:=EncodeUpdateDate(Date);
end;

Function AddPackageDataFooter(const Doc : TXMLDocument) : TStringList;
begin
  result:=SaveXMLDoc(Doc,['<!DOCTYPE DFRPackagesFile SYSTEM "'+DFRHomepage+'Packages/DFRPackagesFile.dtd">'],False);
end;

end.
