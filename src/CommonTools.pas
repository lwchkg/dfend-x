unit CommonTools;
interface

uses Windows, Classes, Graphics, StdCtrls;

Function ExtUpperCase(const S : String) : String;
Function ExtLowerCase(const S : String) : String;

Function StrToFloatEx(S : String) : Double;

Function ValueToList(Value : String; const Divider : String = ';') : TStringList;
Function ListToValue(const St : TStrings; Divider : Char =';') : String;

Function StringToStringList(S : String) : TStringList; {"[13][10]" as Divider}
Function StringListToString(const St : TStrings) : String; overload; {"[13][10]" as Divider}
Function StringListToString(const S : String) : String; overload; {"[13][10]" as Divider}
Function Replace(const S, FromSub, ToSub : String) : String;

Function FindStringInFile(const FileName, SearchString : String) : Boolean;

Function PrgDir : String;
Function TempDir : String;

Function MakeRelPath(Path, Rel : String; const NoEmptyRelPath : Boolean =False) : String;
Function MakeAbsPath(Path, Rel : String) : string;
Function MakeExtRelPath(Path, Rel : String) : String;
Function MakeExtAbsPath(Path, Rel : String) : string;
Function MakeFileSysOKFolderName(const AName : String) : String;
Function RemoveIllegalFileNameChars(const Name : String) : String;
Function MakeAbsIconName(const Icon : String) : String;

function SelectDirectory(const AOwner : THandle; const Caption: string; var Directory: String): Boolean;
function GetSpecialFolder(hWindow: HWND; Folder: Integer): String;

Function GetFileVersionEx(const AFileName: string) : Cardinal;
Function GetFileVersionAsString : String;
Function GetNormalFileVersionAsString : String;
Function GetShortFileVersionAsString : String;
Function VersionToInt(Version : String) : Integer;

Procedure RunAndWait(const PrgFile, Path : String; const HideWindow : Boolean);
Function RunAndGetOutput(const PrgFile, Parameters : String; const HideWindow : Boolean): TStringList;
Function RunWithInput(PrgFile, Parameters : String; const HideWindow : Boolean; StdIn : TStringList) : Boolean;
Procedure CenterWindowFromProcessID(const ProcessID : THandle);
Procedure HideWindowFromProcessIDAndTitle(const ProcessID : THandle; const Title : String);
Function CheckDOSBoxVersionDirect(const Nr : Integer; const Path : String) : String; {saidly not working}
Function CheckDOSBoxVersionDirect2(const Nr : Integer; const Path : String) : String; {saidly not working}
Function CheckDOSBoxVersion(const Nr : Integer; const Path : String = '') : String;
Function OldDOSBoxVersion(const Version : String) : Boolean;
Procedure DOSBoxOutdatedWarning(const DOSBoxPath : String);

Function GetFileDate(const FileName : String) : TDateTime;
Function GetDosFileDate(const FileName : String) : Integer;
Function GetFileDateAsString : String;

Procedure CreateLink(const TargetName, Parameters, LinkFile, IconFile, Description : String);
Procedure SetStartWithWindows(const Enabled : Boolean);

function LoadIconFromExeFile(const AFileName: String): TIcon;
Function LoadImageFromFile(const FileName : String) : TPicture;
Function LoadImageAsIconFromFile(const FileName : String) : TIcon;
Procedure SaveImageToFile(const Picture : TPicture; const FileName : String); overload;
Procedure SaveImageToFile(const OldFileName, NewFileName : String); overload;

Type TWallpaperStyle=(WSTile=0,WSCenter=1,WSStretch=2);

Procedure SetDesktopWallpaper(const FileName : String; const WPStyle : TWallpaperStyle);

Function CharsetNameToFontCharSet(const Name : String) : TFontCharset;

Type TPathType=(ptMount,ptScreenshot,ptMapper,ptDOSBox);

Function UnmapDrive(const Path : String; const PathType : TPathType) : String;

Function GetScreensaverAllowStatus : Boolean;
Procedure SetScreensaverAllowStatus(const Enable : Boolean);

procedure SetComboHint(Combo: TComboBox);
procedure SetComboDropDownDropDownWidth(Combo: TComboBox);

Function GetDefaultEditor(Extension : String; const FileTypeFallback : Boolean; const RemoveParameters : Boolean = True) : String;
Procedure OpenFileInEditor(const FileName : String);
Function OpenMediaFile(const SetupString, FileName : String) : Boolean; {true=request handled by external program}

function GetFileSize(const AFileName : String): Int64;
Function FileSizeToStr(const Size : Int64) : String;

Function BaseDirSecuriryCheck(const DirToDelete : String) : Boolean;
Function BaseDirSecuriryCheckOnly(const DirToDelete : String) : Boolean; {no error dialog, just check}

Type TDeleteFileType=(ftQuickStart=0,ftTemp=1,ftProfile=2,ftUninstall=3,ftDataViewer=4,ftMediaViewer=5,ftZipOperation=6);
Function ExtDeleteFile(const FileName : String; const FileType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean; const DeletePrgSetupRecord : String ='') : Boolean; overload;
Function ExtDeleteFile(const FileName : String; const FileType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean; overload;
Function ExtDeleteFileWithPause(const FileName : String; const FileType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean; const DeletePrgSetupRecord : String) : Boolean; overload;
Function ExtDeleteFileWithPause(const FileName : String; const FileType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean; overload;
Function ExtDeleteFolder(const Folder : String; const FolderType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean; const DeletePrgSetupRecord : String ='') : Boolean; overload;
Function ExtDeleteFolder(const Folder : String; const FolderType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean; overload;
Function ExtDeleteFolderNoWarning(const Folder : String; const FolderType : TDeleteFileType) : Boolean;
Function DeleteFileToRecycleBin(const FileName : String; const AllowContinueNext : Boolean; var ContinueNext : Boolean) : Boolean; overload;
Function DeleteFileToRecycleBin(const FileName : String) : Boolean; overload;
Function DeleteFileToRecycleBinWithPause(const FileName : String; const AllowContinueNext : Boolean; var ContinueNext : Boolean) : Boolean;
Function DeleteFileToRecycleBinNoWarning(const FileName : String) : Boolean;

Function CompareFiles(const File1, File2 : String) : Boolean; {True=files match}

Type TRenameFiles=(rfScreenshots,rfSounds,rfVideos);
Function RenameAllFiles(const Folder, Expression, GameName : String; const RenameFiles : TRenameFiles; const ShowNoFilesInfo : Boolean) : Boolean;

Function ForceForegroundWindow(Wnd:HWND):Boolean;

Function CPUCount : Integer;
function IsRemoteSession: Boolean;

Var TempPrgDir : String = ''; {Temporary overwrite normal PrgDir}

implementation

uses SysUtils, Forms, ShellAPI, ShlObj, ActiveX, Messages, Dialogs, Math,
     Controls, ComObj, Registry, JPEG, GIFImage, PNGImage, LanguageSetupUnit,
     PrgSetupUnit, PrgConsts, ImageStretch;

Function ExtUpperCase(const S : String) : String;
Var I,J : Integer;
begin
  result:=Trim(S);
  For I:=1 to length(result) do begin
    If (result[I]>='a') and (result[I]<='z') then begin
      result[I]:=chr(ord(result[I])-(ord('a')-ord('A')));
      continue;
    end;
    J:=Pos(result[I],LanguageSpecialLowerCase);
    If J>0 then result[I]:=LanguageSpecialUpperCase[J];
  end;
end;

Function ExtLowerCase(const S : String) : String;
Var I,J : Integer;
begin
  result:=Trim(S);
  For I:=1 to length(result) do begin
    If (result[I]>='A') and (result[I]<='Z') then begin
      result[I]:=chr(ord(result[I])+(ord('a')-ord('A')));
      continue;
    end;
    J:=Pos(result[I],LanguageSpecialUpperCase);
    If J>0 then result[I]:=LanguageSpecialLowerCase[J];
  end;
end;

Function StrToFloatEx(S : String) : Double;
Var I : Integer;
begin
  For I:=1 to length(S) do If (S[I]='.') or (S[I]=',') then
    S[I] := FormatSettings.DecimalSeparator;
  result:=StrToFloat(S);
end;

Function ValueToList(Value : String; const Divider : String) : TStringList;
Var I,J : Integer;
begin
  result:=TStringList.Create;
  Value:=Trim(Value);

  while Value<>'' do begin
    I:=0;
    For J:=1 to length(Value) do If Pos(Value[J],Divider)<>0 then begin I:=J; break; end;

    If I>0 then begin
      result.Add(Trim(Copy(Value,1,I-1)));
      Value:=Trim(Copy(Value,I+1,MaxInt));
    end else begin
      result.Add(Value);
      Value:='';
    end;
  end;

  If Divider=';' then For I:=0 to result.count-1 do result[I]:=StringReplace(result[I],'<semicolon>',';',[rfReplaceAll,rfIgnoreCase]);
end;

Function ListToValue(const St : TStrings; Divider : Char) : String;
Var I : Integer;
    S : String;
begin
  result:='';
  For I:=0 to St.Count-1 do begin
    S:=Trim(St[I]); If S='' then continue;
    S:=StringReplace(S,';','<semicolon>',[rfReplaceAll]);
    If result<>'' then result:=result+Divider;
    result:=result+S;
  end;
end;

Function StringToStringList(S : String) : TStringList;
Var T : String;
    I,J : Integer;
begin
  T:='';
  while S<>'' do begin
    I:=Pos('[',S);
    If I=0 then begin T:=T+S; S:=''; continue; end;
    T:=T+Copy(S,1,I-1); S:=Copy(S,I+1,MaxInt);
    I:=Pos(']',S);
    If I=0 then begin T:=T+'['+S; S:=''; continue; end;
    if (not TryStrToInt(Copy(S,1,I-1),J)) or (J<0) or (J>255) then begin T:=T+'['; continue; end;
    T:=T+chr(J); S:=Copy(S,I+1,MaxInt);
  end;

  result:=TStringList.Create;
  result.Text:=T;
end;

Function StringListToString(const St : TStrings) : String;
Var I : Integer;
    S : String;
begin
  S:=St.Text;
  result:='';

  result:='';
  For I:=1 to length(S) do
    If S[I]<#32 then result:=result+'['+IntToStr(Ord(S[I]))+']' else result:=result+S[I];
end;

Function StringListToString(const S : String) : String;
Var I : Integer;
begin
  result:='';

  result:='';
  For I:=1 to length(S) do
    If S[I]<#32 then result:=result+'['+IntToStr(Ord(S[I]))+']' else result:=result+S[I];
end;

Function Replace(const S, FromSub, ToSub : String) : String;
Var I : Integer;
    Text : String;
begin
  Text:=S; result:='';
  I:=Pos(FromSub,Text);
  while I>0 do begin
    If (ToSub<>'') and (FromSub=ToSub[1]) and (Copy(Text,I,length(ToSub))=ToSub) then begin
      result:=result+Copy(Text,1,I+length(ToSub)-1);
      Text:=Copy(Text,I+length(ToSub),MaxInt);
    end else begin
      result:=result+Copy(Text,1,I-1)+ToSub;
      Text:=Copy(Text,I+length(FromSub),MaxInt);
    end;
    I:=Pos(FromSub,Text);
  end;
  result:=result+Text;
end;

Type TByteArray=Array[0..MaxInt-1] of Byte;

Function FindStringInFile(const FileName, SearchString : String) : Boolean;
Var MSt : TMemoryStream;
    I,J : Integer;
    B : Boolean;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  MSt:=TMemoryStream.Create;
  try
    try MSt.LoadFromFile(FileName); except exit; end;
      For I:=0 to MSt.Size-length(SearchString) do If TByteArray(MSt.Memory^)[I]=Byte(SearchString[1]) then begin
        B:=True;
        for J:=2 to length(SearchString) do If TByteArray(MSt.Memory^)[I+J-1]<>Byte(SearchString[J]) then begin B:=False; break; end;
        if B then begin result:=True; exit; end;
      end;
  finally
    MSt.Free;
  end;
end;

Function PrgDir : String;
begin
  If TempPrgDir<>''
    then result:=TempPrgDir
    else result:=IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(Application.ExeName)));
end;

Function TempDir : String;
begin
  SetLength(result,515);
  GetTempPath(512,PChar(result));
  SetLength(result,StrLen(PChar(result)));
  result:=IncludeTrailingPathDelimiter(result);
end;

Function ShortName(const LongName : String) : String;
begin
  SetLength(result,MAX_PATH+10);
  if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
    then result:=LongName
    else SetLength(result,StrLen(PChar(result)));
end;

Function MakeRelPath(Path, Rel : String; const NoEmptyRelPath : Boolean) : String;
Var FileName : String;
begin
  {No conversion if path DOSBox relative to DOSBox internal file system}
  If (ExtUpperCase(Copy(Trim(Path),1,7))='DOSBOX:') or (Trim(Path)='') then begin result:=Path; exit; end;

  {Check base path}
  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  {Split path into path an file name}
  If DirectoryExists(Path) then begin
    FileName:='';
    Path:=IncludeTrailingPathDelimiter(Path);
  end else begin
    FileName:=ExtractFileName(Path);
    Path:=IncludeTrailingPathDelimiter(ExtractFilePath(Path));
  end;

  {Convert}
  If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then begin
    {Path is relative to Rel}
    Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  end else begin
    Rel:=IncludeTrailingPathDelimiter(ShortName(Rel));
    {May be Path is relative to the short version of Rel}
    If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then
      Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  end;

  {Remove useless parts}
  If (Path='.\') or (Path='\') then Path:='';

  {Add file name again}
  result:=Path+FileName;

  {Set path to ".\" if empty and empty not allowed}
  if NoEmptyRelPath and (result='') then result:='.\';
end;

Function MakeAbsPath(Path, Rel : String) : string;
begin
  {No conversion if path DOSBox relative to DOSBox internal file system}
  If (ExtUpperCase(Copy(Trim(Path),1,7))='DOSBOX:') or (Trim(Path)='') then begin result:=Path; exit; end;

  {Check base path}
  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  {Check if path is already absolute}
  If (length(Path)>=2) and ((Path[2]=':') or (copy(Path,1,2)='\\')) then begin result:=Path; exit; end;

  {Remove leading ".\" or "\"}
  Path:=Trim(Path);
  If Copy(Path,1,2)='.\' then Path:=Trim(Copy(Path,3,MaxInt));
  If Copy(Path,1,1)='\' then Path:=Trim(Copy(Path,2,MaxInt));

  {Combine base path and relative path}
  result:=Rel+Path;
end;

Function MakeExtRelPath(Path, Rel : String) : String;
Var FileName,S,T,ShortPath : String;
    C : Integer;
begin
  {No conversion if path DOSBox relative to DOSBox internal file system}
  If (ExtUpperCase(Copy(Trim(Path),1,7))='DOSBOX:') or (Trim(Path)='') then begin result:=Path; exit; end;

  {Check base path}
  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  {Split path into path an file name}
  If DirectoryExists(Path) then begin
    FileName:='';
    Path:=IncludeTrailingPathDelimiter(Path);
  end else begin
    FileName:=ExtractFileName(Path);
    Path:=IncludeTrailingPathDelimiter(ExtractFilePath(Path));
  end;

  {Convert}
  If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then begin
    {Path is relative to Rel}
    Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  end else begin
    {May be Path is relative to the short version of Rel}
    Rel:=IncludeTrailingPathDelimiter(ShortName(Rel));
    If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then
      Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  end;

  {Check if path is ".." path to base path}
  If Copy(Path,1,2)<>'.\' then begin
    C:=0;
    S:=ShortName(Rel);
    ShortPath:=ShortName(Path);
    repeat
      If S<>'' then SetLength(S,length(S)-1);
      While (S<>'') and (S[length(S)]<>'\') do SetLength(S,length(S)-1);
      If S='' then break;
      inc(C);
      If (length(ShortPath)>=length(S)) and (ExtUpperCase(Copy(ShortPath,1,length(S)))=ExtUpperCase(S)) then begin
        T:=''; while C>0 do begin T:=T+'..\'; dec(C); end;
        Path:=T+Copy(ShortPath,length(S)+1,MaxInt);
        break;
      end;
    until False;
  end;

  {Remove useless parts}
  If Path='.\' then Path:='';

  {Combine base path and relative path}
  result:=Path+FileName;
end;

Function MakeExtAbsPath(Path, Rel : String) : string;
begin
  {No conversion if path DOSBox relative to DOSBox internal file system}
  If (ExtUpperCase(Copy(Trim(Path),1,7))='DOSBOX:') or (Trim(Path)='') then begin result:=Path; exit; end;

  {Check base path}
  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  {Check if path is already absolute}
  If (length(Path)>=2) and ((Path[2]=':') or (copy(Path,1,2)='\\')) then begin result:=Path; exit; end;

  Path:=Trim(Path);

  {Remove leading ".\" and directly combine base path and relative path (so next rule can't apply)}
  If Copy(Path,1,2)='.\' then begin
    Path:=Trim(Copy(Path,3,MaxInt));
    result:=Rel+Path;
    exit;
  end;

  {If path starts with "..\": remove it and remove last part in base path}
  If Copy(Path,1,3)='..\' then begin
    while Copy(Path,1,3)='..\' do begin
      If Rel='' then break;
      SetLength(Rel,length(Rel)-1);
      While (Rel<>'') and (Rel[length(Rel)]<>'\') do SetLength(Rel,length(Rel)-1);
      Path:=Copy(Path,4,MaxInt);
    end;
    result:=Rel+Path;
    exit;
  end;

  {Combine base path and relative path}
  result:=Rel+Path;
end;

const AllowedCharsDefault='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyzäöüß01234567890-_=.,;!()$#@{}&''`~'+chr(246)+chr(255)+chr($a0)+chr($e5);

Function MakeFileSysOKFolderName(const AName : String) : String;
Var I : Integer;
    AllowedChars : String;
begin
  result:='';
  AllowedChars:=LanguageSetup.CharsetAllowedFileNameChars;
  If AllowedChars='' then AllowedChars:=AllowedCharsDefault;
  AllowedChars:=AllowedChars+' ';
  For I:=1 to length(AName) do if Pos(AName[I],AllowedChars)>0 then result:=result+AName[I];
  if result='' then result:='Game';
end;

Function RemoveIllegalFileNameChars(const Name : String) : String;
Var I : Integer;
begin
  result:='';
  For I:=1 to length(Name) do If Pos(Name[I],AllowedCharsDefault)>0 then result:=result+Name[I];
end;

Function FindIconInSubfolders(const Folder, Icon : String) : String;
Var Rec : TSearchRec;
    I : Integer;
    St : TStringList;
    F : String;
begin
  result:='';
  F:=IncludeTrailingPathDelimiter(Folder);
  St:=TStringList.Create;
  try
    I:=FindFirst(F+'*.*',faDirectory,Rec);
    try
      While I=0 do begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') and ((Rec.Attr and faDirectory)<>0) then St.Add(Rec.Name);
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
    For I:=0 to St.Count-1 do If FileExists(F+St[I]+'\'+Icon) then begin result:=F+St[I]+'\'+Icon; exit; end;
    For I:=0 to St.Count-1 do begin result:=FindIconInSubfolders(F+St[I],Icon); If result<>'' then exit; end;
  finally
    St.Free;
  end;
end;

Function MakeAbsIconName(const Icon : String) : String;
Var S : String;
begin
  If Trim(Icon)='' then begin result:=''; exit; end;
  S:=ExtractFilePath(Icon);

  {Get icon from user defined folder}
  If S<>'' then begin result:=MakeAbsPath(Icon,PrgSetup.BaseDir); exit; end;

  {Get icon from icon folder (or its subdfolders}
  result:=PrgDataDir+IconsSubDir+'\'+Icon;

  If FileExists(result) then exit;
  S:=FindIconInSubfolders(PrgDataDir+IconsSubDir,Icon);
  If S<>'' then result:=S;
end;

function bffCallback(DlgHandle: HWND; Msg: Integer; lParam: Integer; lpData: Integer) : Integer; stdcall;
begin
  if Msg = BFFM_INITIALIZED then
  SendMessage(DlgHandle, BFFM_SETSELECTION, Integer(LongBool(True)), lpData);
  result:=0;
end;

function SelectDirectory(const AOwner : THandle; const Caption: string; var Directory: String): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
begin
  Result := False;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      with BrowseInfo do
      begin
        hwndOwner := AOwner;
        pidlRoot := nil;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        lpfn:=@bffCallback;
        lParam:=Integer(@(Directory[1]));
      end;

      ItemIDList := ShBrowseForFolder(BrowseInfo);
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

{
CSIDL_COOKIES              Cookies
CSIDL_DESKTOPDIRECTORY     Desktop
CSIDL_FAVORITES            Favorites
CSIDL_HISTORY              Internet history
CSIDL_INTERNET_CACHE       "Temporary Internet Files"
CSIDL_PERSONAL             User files
CSIDL_PROGRAMS             "Programe files" in start menu
CSIDL_RECENT               "Documents" in start menu
CSIDL_SENDTO               "Send to" in context menu
CSIDL_STARTMENU            Start menu
CSIDL_STARTUP              Auto start
}
function GetSpecialFolder(hWindow: HWND; Folder: Integer): String;
var pMalloc: IMalloc;
    pidl: PItemIDList;
    Path: PChar;
begin
  result:='';
  if SHGetMalloc(pMalloc) <> S_OK then exit;

  SHGetSpecialFolderLocation(hWindow, Folder, pidl);
  GetMem(Path, MAX_PATH);
  SHGetPathFromIDList(pidl, Path);
  Result:=IncludeTrailingPathDelimiter(Path);
  FreeMem(Path);

  pMalloc.Free(pidl);
end;

Function GetFileVersionEx(const AFileName: string) : Cardinal;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := Cardinal(-1);
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result:= FI.dwFileVersionLS;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

Function GetFileVersionAsString : String;
Var I,J : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  J:=GetFileVersionEx(ExpandFileName(Application.ExeName));
  {result:=Format('Version %d.%d.%d (Build %d)',[I div 65536,I mod 65536, J div 65536, J mod 65536]);}
  result:=Format('Version %d.%d.%d',[I div 65536,I mod 65536, J div 65536]);
end;

Function GetNormalFileVersionAsString : String;
Var I,J : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  J:=GetFileVersionEx(ExpandFileName(Application.ExeName));
  result:=Format('%d.%d.%d',[I div 65536,I mod 65536, J div 65536]);
end;

Function GetShortFileVersionAsString : String;
Var I : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  result:=Format('%d.%d',[I div 65536,I mod 65536]);
end;

Function VersionToInt(Version : String) : Integer;
Var I,J : Integer;
begin
  result:=0;
  I:=Pos('.',Version);
  while I>0 do begin
    J:=0; TryStrToInt(Copy(Version,1,I-1),J); Version:=Copy(Version,I+1,MaxInt);
    result:=result*100+J;
    I:=Pos('.',Version);
  end;
  J:=0; TryStrToInt(Version,J);
  result:=result*100+J;
end;

Procedure RunAndWait(const PrgFile, Path : String; const HideWindow : Boolean);
Var StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;

  If HideWindow then begin
    StartupInfo.dwFlags:=STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow:=SW_HIDE;
  end;

  If CreateProcess(PChar(PrgFile),PChar('"'+PrgFile+'"'),nil,nil,False,0,nil,PChar(Path),StartupInfo,ProcessInformation) then begin
    WaitForSingleObject(ProcessInformation.hThread,INFINITE);
    CloseHandle(ProcessInformation.hThread);
    CloseHandle(ProcessInformation.hProcess);
  end;
end;

Function RunAndGetOutput(const PrgFile, Parameters : String; const HideWindow : Boolean): TStringList;
Type TByteArray=Array[0..MaxInt-1] of Byte;
const DataBlockSize=10*1024;
Var hStdOutReadPipe, hStdOutWritePipe, hStdInReadPipe, hStdInWritePipe : THandle;
    PipeSecurityAttributes : TSecurityAttributes;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    MSt : TMemoryStream;
    I,J,K: Cardinal;
    S : String;
    LastLoop : Boolean;
begin
  {See also msdn.microsoft.com/en-us/library/ms682499.aspx}

  result:=nil;
  If not FileExists(PrgFile) then exit;

  {Set the bInheritHandle flag so pipe handles are inherited.}
  with PipeSecurityAttributes do begin
    nLength:=SizeOf(TSecurityAttributes);
    bInheritHandle:=True;
    lpSecurityDescriptor:=nil;
  end;

  {Create a pipe for the child process's STDOUT.}
  if not CreatePipe(hStdOutReadPipe,hStdOutWritePipe,@PipeSecurityAttributes,0) then exit;
  try
    {Create a pipe for the child process's STDIN.}
    if not CreatePipe(hStdInReadPipe,hStdInWritePipe,@PipeSecurityAttributes,0) then exit;
    try
      {Ensure the read handle to the pipe for STDOUT is not inherited.}
      if not SetHandleInformation(hStdOutReadPipe,HANDLE_FLAG_INHERIT,0) then exit;

      {Ensure the write handle to the pipe for STDIN is not inherited.}
      if not SetHandleInformation(hStdInWritePipe,HANDLE_FLAG_INHERIT,0) then exit;

      {Run program}
      StartupInfo.cb:=SizeOf(StartupInfo);
      with StartupInfo do begin
        lpReserved:=nil;
        lpDesktop:=nil;
        lpTitle:=nil;
        dwFlags:=STARTF_USESTDHANDLES;
        cbReserved2:=0;
        lpReserved2:=nil;
        hStdInput:=hStdInReadPipe;
        hStdOutput:=hStdOutWritePipe;
        hStdError:=hStdOutWritePipe;
      end;
      If HideWindow then with StartupInfo do begin
        dwFlags:=dwFlags or STARTF_USESHOWWINDOW;
        wShowWindow:=SW_HIDE;
      end;
      If Parameters<>'' then S:=' '+Parameters else S:='';
      if not CreateProcess(PChar(PrgFile),PChar('"'+PrgFile+'"'+S),nil,nil,True,0,nil,PChar(ExtractFilePath(PrgFile)),StartupInfo,ProcessInformation) then exit;
      CloseHandle(ProcessInformation.hProcess);
      try

        {Wait for termination of program (or buffer full)}
        WaitForSingleObject(ProcessInformation.hThread,250);

        MSt:=TMemoryStream.Create;
        try
          {Read data from pipe}
          MSt.Size:=0;

          {if pipe buffer is too small for all output data program won't terminate until all data is written}
          repeat
            LastLoop:=(WaitForSingleObject(ProcessInformation.hThread,250)=WAIT_OBJECT_0);
            {So begin reading the first blocks from pipe buffer}
            repeat
              MSt.Size:=MSt.Size+DataBlockSize;

              {Do not try to read data if no data is available}
              PeekNamedPipe(hStdOutReadPipe,nil,0,@I,@J,@K);
              If J>0 then begin
                If not ReadFile(hStdOutReadPipe,TByteArray(MSt.Memory^)[MSt.Size-DataBlockSize],DataBlockSize,I,nil) then exit;
              end else begin
                I:=0;
              end;
              If I<DataBlockSize then begin
                MSt.Size:=MSt.Size-(DataBlockSize-I);
                break;
              end;
            until False;
          until LastLoop;

          {Copy data to TStringList}
          result:=TStringList.Create;
          Mst.Position:=0;
          result.LoadFromStream(MSt);
        finally
          MSt.Free;
        end;
      finally
        CloseHandle(ProcessInformation.hThread);
      end;
    finally
      CloseHandle(hStdInReadPipe);
      CloseHandle(hStdInWritePipe);
    end;
  finally
    CloseHandle(hStdOutReadPipe);
    CloseHandle(hStdOutWritePipe);
  end;
end;

Function RunWithInput(PrgFile, Parameters : String; const HideWindow : Boolean; StdIn : TStringList) : Boolean;
Type TByteArray=Array[0..MaxInt-1] of Byte;
const OutputReaderSize=10*1024;
Var hStdOutReadPipe, hStdOutWritePipe, hStdInReadPipe, hStdInWritePipe : THandle;
    PipeSecurityAttributes : TSecurityAttributes;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    MSt : TMemoryStream;
    I,J,K : Cardinal;
    S : String;
    WritePos : Integer;
    OutputReaderBlock : Array[0..OutputReaderSize-1] of Byte;
begin
  {See also msdn.microsoft.com/en-us/library/ms682499.aspx}

  result:=False;
  If not FileExists(PrgFile) then exit;

  {Set the bInheritHandle flag so pipe handles are inherited.}
  with PipeSecurityAttributes do begin
    nLength:=SizeOf(TSecurityAttributes);
    bInheritHandle:=True;
    lpSecurityDescriptor:=nil;
  end;

  {Create a pipe for the child process's STDOUT.}
  if not CreatePipe(hStdOutReadPipe,hStdOutWritePipe,@PipeSecurityAttributes,0) then exit;
  try
    {Create a pipe for the child process's STDIN.}
    if not CreatePipe(hStdInReadPipe,hStdInWritePipe,@PipeSecurityAttributes,0) then exit;
    try
      {Ensure the read handle to the pipe for STDOUT is not inherited.}
      if not SetHandleInformation(hStdOutReadPipe,HANDLE_FLAG_INHERIT,0) then exit;

      {Ensure the write handle to the pipe for STDIN is not inherited.}
      if not SetHandleInformation(hStdInWritePipe,HANDLE_FLAG_INHERIT,0) then exit;

      MSt:=TMemoryStream.Create;
      try
        StdIn.SaveToStream(MSt);
        WritePos:=0;

        {Run program}
        StartupInfo.cb:=SizeOf(StartupInfo);
        with StartupInfo do begin
          lpReserved:=nil;
          lpDesktop:=nil;
          lpTitle:=nil;
          dwFlags:=STARTF_USESTDHANDLES;
          cbReserved2:=0;
          lpReserved2:=nil;
          hStdInput:=hStdInReadPipe;
          hStdOutput:=hStdOutWritePipe;
          hStdError:=hStdOutWritePipe;
        end;
        If HideWindow then with StartupInfo do begin
          dwFlags:=dwFlags or STARTF_USESHOWWINDOW;
          wShowWindow:=SW_HIDE;
        end;
        If Parameters<>'' then S:=' '+Parameters else S:='';
        if not CreateProcess(PChar(PrgFile),PChar('"'+PrgFile+'"'+S),nil,nil,True,0,nil,PChar(ExtractFilePath(PrgFile)),StartupInfo,ProcessInformation) then exit;
        CloseHandle(ProcessInformation.hProcess);

        try
          While (WritePos<MSt.Size) and (not (WaitForSingleObject(ProcessInformation.hThread,0)=WAIT_OBJECT_0)) do begin
            {Read data from StdOut buffer}
            PeekNamedPipe(hStdOutReadPipe,nil,0,@I,@J,@K);
            If J>0 then ReadFile(hStdOutReadPipe,OutputReaderBlock,OutputReaderSize,I,nil);

            {Write own data to StdIn buffer}
            if not WriteFile(hStdInWritePipe,TByteArray(MSt.Memory^)[WritePos],MSt.Size-WritePos,I,nil) then exit;
            inc(WritePos,I);
          end;

          repeat
            {Read remaining data from StdOut buffer so program is not blocked and can terminate}
            PeekNamedPipe(hStdOutReadPipe,nil,0,@I,@J,@K);
            If J>0 then ReadFile(hStdOutReadPipe,OutputReaderBlock,OutputReaderSize,I,nil);
          until (WaitForSingleObject(ProcessInformation.hThread,250)=WAIT_OBJECT_0);

          result:=(WritePos=MSt.Size);
        finally
          CloseHandle(ProcessInformation.hThread);
        end;
      finally
        MSt.Free;
      end;
    finally
      CloseHandle(hStdInReadPipe);
      CloseHandle(hStdInWritePipe);
    end;
  finally
    CloseHandle(hStdOutReadPipe);
    CloseHandle(hStdOutWritePipe);
  end;
end;

Procedure CenterWindow(Const hWindow : HWnd);
Var R : TRect;
begin
 GetWindowRect(hWindow,R);
 SetWindowPos(
   hWindow,
   HWND_TOP,
   (Screen.Width div 2)-((R.Right-R.Left) div 2),
   (Screen.Height div 2)-((R.Bottom-R.Top) div 2),
   0,
   0,
   SWP_SHOWWINDOW or SWP_NOSIZE
 );
end;

Function EnumWindowsFunc(const hWindow : THandle; const lParam : Integer) : Boolean; StdCall;
Var dwProcessID : Cardinal;
    C : Cardinal;
    {S : String;}
begin
  result:=True;
  GetWindowThreadProcessId(hWindow,dwProcessID);
  If dwProcessID<>Cardinal(lParam) then exit;

  C:=GetWindowLong(hWindow,GWL_STYLE);
  If ((C and WS_VISIBLE)<>0) and ((C and WS_CAPTION)<>0) and ((C and WS_SYSMENU)<>0) and ((C and WS_DISABLED)=0) and ((C and WS_TABSTOP)=0)  then begin

    {SetLength(S,255);
    GetWindowText(hWindow,PChar(S),250);
    SetLength(S,StrLen(PChar(S)));
    ShowMessage(S+#13+IntToStr(C));}

    CenterWindow(hWindow);
  end;
end;

Procedure CenterWindowFromProcessID(const ProcessID : THandle);
begin
  EnumWindows(@EnumWindowsFunc,ProcessID);
end;

var GlobalHideTitle : String = '';

Function EnumWindowsFunc2(const hWindow : THandle; const lParam : Integer) : Boolean; StdCall;
Var dwProcessID : Cardinal;
    S : String;
begin
  result:=True;
  GetWindowThreadProcessId(hWindow,dwProcessID);
  If dwProcessID<>Cardinal(lParam) then exit;

  SetLength(S,255);
  If GetWindowText(hWindow,PChar(S),250)=0 then exit;
  SetLength(S,StrLen(PChar(S)));
  S:=Trim(ExtUpperCase(S));
  If Copy(S,length(S)+1-length(GlobalHideTitle),length(GlobalHideTitle))<>GlobalHideTitle then exit;

  ShowWindow(hWindow,SW_HIDE)
end;

Procedure HideWindowFromProcessIDAndTitle(const ProcessID : THandle; const Title : String);
begin
  GlobalHideTitle:=ExtUpperCase(Title);
  EnumWindows(@EnumWindowsFunc2,ProcessID);
end;

Function CheckDOSBoxVersionDirect(const Nr : Integer; const Path : String) : String;
Var DOSBoxPath : String;
    St : TStringList;
    TempTxt, TempBat : String;
begin
  result:='';

  If Trim(Path)='' then DOSBoxPath:=PrgSetup.DOSBoxSettings[Nr].DosBoxDir else DOSBOXPath:=Path;
  DOSBoxPath:=IncludeTrailingPathDelimiter(MakeAbsPath(DOSBOXPath,PrgSetup.BaseDir));

  If not DirectoryExists(DOSBoxPath) then exit;

  TempTxt:=TempDir+'D-Fend-Reloaded-DOSBoxVer.txt';
  TempBat:=TempDir+'D-Fend-Reloaded-DOSBoxVer.bat';

  { Create batch file to run }
  try
    St:=TStringList.Create;
    try
      St.Add('"'+DOSBoxPath+DosBoxFileName+'" -version >> "'+TempTxt+'"');
      St.SaveToFile(TempBat);
    finally
      St.Free;
    end;
  except
    exit;
  end;

  { Run DOSBox }
  RunAndWait(TempBat,DOSBoxPath,True);
  ExtDeleteFile(TempBat,ftTemp);

  { Read list file }
  If not FileExists(TempTxt) then exit;

  St:=TStringList.Create;
  try
    try
      St.LoadFromFile(TempTxt);
    except exit; end;
    If St.Count>0 then result:=St.Text;
  finally
    St.Free;
  end;

  ExtDeleteFile(TempTxt,ftTemp);
end;

Function CheckDOSBoxVersionDirect2(const Nr : Integer; const Path : String) : String;
Var DOSBoxPath : String;
    St : TStringList;
begin
  result:='';

  If Trim(Path)='' then DOSBoxPath:=PrgSetup.DOSBoxSettings[Nr].DosBoxDir else DOSBOXPath:=Path;
  DOSBoxPath:=IncludeTrailingPathDelimiter(MakeAbsPath(DOSBOXPath,PrgSetup.BaseDir));

  If not DirectoryExists(DOSBoxPath) then exit;

  St:=RunAndGetOutput(DOSBoxPath+DosBoxFileName,'-version',True);
  If St=nil then exit;
  try
    If St.Count>0 then result:=St.Text;
  finally
    St.Free;
  end;
end;

Function FindManual(const Path : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
    S : String;
begin
  result:=TStringList.Create;

  I:=FindFirst(Path+'*.txt',faAnyFile,Rec);
  try
    While I=0 do begin
      S:=Trim(ExtUpperCase(Rec.Name));
      If (S='README.TXT') or ((Pos('MANUAL',S)>0) and (Pos('DOSBOX',S)>0)) then
        result.AddObject(Rec.Name,TObject(Rec.Time));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetVersionFromDOSBoxReadmeFile(const FileName : String) : String;
Var S : String;
    St : TStringList;
    I : Integer;
    B : Boolean;
begin
  result:='';
  S:='';
  St:=TStringList.Create;
  try
    try St.LoadFromFile(FileName); except exit; end;
    For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin S:=St[I]; break; end;
  finally
    St.Free;
  end;

  B:=True;
  For I:=1 to length(S) do If ((S[I]>='0') and (S[I]<='9')) or (S[I]='.') then begin
    If S[I]='.' then begin
      If B then B:=False else continue;
    end;
    result:=result+S[I];
  end;
end;

Function CheckDOSBoxVersion(const Nr : Integer; const Path : String) : String;
Var DOSBoxPath : String;
    I,J,Date : Integer;
    FileNames : TStringList;
begin
  result:='';

  If (Trim(Path)='') and (Nr>=0) then DOSBoxPath:=PrgSetup.DOSBoxSettings[Nr].DosBoxDir else DOSBoxPath:=Path;
  DOSBoxPath:=IncludeTrailingPathDelimiter(MakeAbsPath(DOSBoxPath,PrgSetup.BaseDir));

  FileNames:=FindManual(DOSBoxPath);
  try
    While FileNames.Count>0 do begin
      Date:=Integer(FileNames.Objects[0]); J:=0;
      For I:=1 to FileNames.Count-1 do if Integer(FileNames.Objects[I])>Date then begin
        Date:=Integer(FileNames.Objects[I]); J:=I;
      end;
      result:=GetVersionFromDOSBoxReadmeFile(DOSBoxPath+FileNames[J]); If result<>'' then exit;
      FileNames.Delete(J);
    end;
  finally
    FileNames.Free;
  end;
end;

Function OldDOSBoxVersion(const Version : String) : Boolean;
Var D : Double;
    S : String;
    I : Integer;
begin
  result:=False;
  S:=Trim(Version);
  If Trim(S)='' then exit;
  For I:=1 to length(S) do If (S[I]=',') or (S[I]='.') then
    S[I] := FormatSettings.DecimalSeparator;
  try D:=StrToFloat(S); except exit; end;
  result:=(D<MinSupportedDOSBoxVersion-0.0000001);
end;

Procedure DOSBoxOutdatedWarning(const DOSBoxPath : String);
Var S : String;
    I : Integer;
begin
  S:=FloatToStr(MinSupportedDOSBoxVersion);
  For I:=1 to length(S) do If S[I]=',' then S[I]:='.';
  MessageDlg(Format(LanguageSetup.MessageDOSBoxOutdated,[CheckDOSBoxVersion(-1,DOSBoxPath),S]),mtWarning,[mbOk],0);
end;

Function GetFileDate(const FileName : String) : TDateTime;
Var hFile : THandle;
begin
  result:=0;

  hFile:=CreateFile(PChar(FileName),GENERIC_READ,FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,0,0);
  if hFile=INVALID_HANDLE_VALUE then exit;
  try
    result:=FileDateToDateTime(FileGetDate(hFile));
  finally
    CloseHandle(hFile);
  end;
end;

Function GetDosFileDate(const FileName : String) : Integer;
begin
  result:=DateTimeToFileDate(GetFileDate(FileName));
end;

Function GetFileDateAsString : String;
Var D : TDateTime;
begin
  result:='';

  D:=GetFileDate(ExpandFileName(Application.ExeName));
  If D<0.001 then exit;
  result:=DateToStr(D);
end;

Procedure CreateLink(const TargetName, Parameters, LinkFile, IconFile, Description : String);
Var IObject : IUnknown;
   ISLink : IShellLink;
   IPFile : IPersistFile;
   WLinkFile : WideString;
begin
   IObject:=CreateComObject(CLSID_ShellLink);
   ISLink:=IObject as IShellLink;
   IPFile:=IObject as IPersistFile;

   with ISLink do begin
     SetPath(PChar(TargetName));
     SetWorkingDirectory(PChar(ExtractFilePath(TargetName)));
     SetArguments(PChar(Parameters));
     SetDescription(PChar(Description));
     If IconFile<>'' then SetIconLocation(PChar(IconFile),0);
   end;

   WLinkFile:=LinkFile;
   IPFile.Save(PWChar(WLinkFile), false) ;
end;

Procedure SetStartWithWindows(const Enabled : Boolean);
Var Reg : TRegistry;
begin
  Reg:=TRegistry.Create;
  try
  Reg.RootKey:=HKEY_CURRENT_USER;
    If not Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',True) then exit;
    If Enabled then begin
      Reg.WriteString('D-Fend Reloaded',ExpandFileName(Application.ExeName));
    end else begin
      Reg.DeleteValue('D-Fend Reloaded');
    end;
  finally
    Reg.Free;
  end;
end;

Procedure SaveImageToFile(const Picture : TPicture; const FileName : String);
Var Ext : String;
    JPEGImage : TJPEGImage;
    Bitmap : TBitmap;
    GifImage : TGIFImage;
    PNGObject : TPNGObject;
begin
  Ext:=Trim(ExtUpperCase(ExtractFileExt(FileName)));

  Bitmap:=TBitmap.Create;
  try
    Bitmap.Assign(Picture.Graphic);
    Bitmap.Palette:=Picture.Graphic.Palette;

    If Picture.Graphic is TPNGObject then begin
      TPNGObject(Picture.Graphic).Draw(Bitmap.Canvas,Rect(0,0,Bitmap.Width-1,Bitmap.Height-1));
    end;

    If (Ext='.JPG') or (Ext='.JPEG') then begin
      JPEGImage:=TJPEGImage.Create;
      try
        If Picture.Graphic is TJPEGImage then begin
          try
            JPEGImage.Assign(Picture.Graphic);
          except
            JPEGImage.Assign(Bitmap);
          end;
        end else begin
          JPEGImage.Assign(Bitmap);
        end;
        JPEGImage.Palette:=Picture.Graphic.Palette;
        JPEGImage.CompressionQuality:=95;
        JPEGImage.SaveToFile(FileName);
      finally
        JPEGImage.Free;
      end;
      exit;
    end;

    If (Ext='.BMP') then begin
      Bitmap.SaveToFile(FileName);
      exit;
    end;

    If (Ext='.GIF') then begin
      GifImage:=TGIFImage.Create;
      try
        GifImage.ColorReduction:=rmQuantizeWindows;
        If Picture.Graphic is TGIFImage then begin
          try
            GifImage.Assign(Picture.Graphic);
          except
            GifImage.Assign(Bitmap);
          end;
        end else begin
          GifImage.Assign(Bitmap);
        end;
        GifImage.Palette:=Picture.Graphic.Palette;
        GifImage.SaveToFile(FileName);
      finally
        GifImage.Free;
      end;
      exit;
    end;

    If (Ext='.PNG') then begin
      PNGObject:=TPNGObject.Create;
      try
        If Picture.Graphic is TPNGObject then begin
          try
            PNGObject.Assign(Picture.Graphic);
          except
            PNGObject.Assign(Bitmap);
          end;
        end else begin
          PNGObject.Assign(Bitmap);
        end;
        PNGObject.Palette:=Picture.Graphic.Palette;
        PNGObject.SaveToFile(FileName);
      finally
        PNGObject.Free;
      end;
      exit;
    end;

    Picture.SaveToFile(FileName);
  finally
    Bitmap.Free;
  end;
end;

Procedure SaveImageToFile(const OldFileName, NewFileName : String);
Var P : TPicture;
begin
  If FileExists(NewFileName) then begin
    If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[NewFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  end;

  If Trim(ExtUpperCase(ExtractFileExt(OldFileName)))=Trim(ExtUpperCase(ExtractFileExt(NewFileName))) then begin
    If not CopyFile(PChar(OldFileName),PChar(NewFileName),False) then
      MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OldFileName,NewFileName]),mtError,[mbOK],0);
    exit;
  end;

  P:=LoadImageFromFile(OldFileName);
  if P=nil then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OldFileName]),mtError,[mbOK],0);
    exit;
  end;
  try
    try
      SaveImageToFile(P,NewFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NewFileName]),mtError,[mbOK],0);
    end;
  finally
    P.Free;
  end;
end;

function LoadIconFromExeFile(const AFileName: String): TIcon;
Var FileInfo: SHFILEINFO;
    I : Integer;
    Handle : THandle;
    OK : Boolean;
begin
  result:=nil;
  If not FileExists(AFileName) then exit;

  result:=TIcon.Create;
  try
    If ExtUpperCase(ExtractFileExt(AFileName))='.EXE' then begin
      If SHGetFileInfo(PChar(AFileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON or SHGFI_LARGEICON)<>0 then result.Handle:=FileInfo.hIcon;
    end else begin
      I:=16; OK:=False;
      while I<=256 do begin
        Handle:=LoadImage(0,PChar(AFileName),IMAGE_ICON,I,I,LR_LOADFROMFILE);
        If Handle<>0 then begin result.Handle:=Handle; OK:=True; end;
        I:=I*2;
      end;
      If not OK then FreeAndNil(result);
    end;
  except
    FreeAndNil(result);
    exit;
  end;
end;

Function LoadImageFromFile(const FileName : String) : TPicture;
Var Ext : String;
    GIFImage : TGIFImage;
    FSt : TFileStream;
    B : Array[0..1] of Byte;
    I : TIcon;
begin
  Ext:=Trim(ExtUpperCase(ExtractFileExt(FileName)));

  result:=nil;
  If not FileExists(FileName) then exit;

  try
    If Ext='.GIF' then begin
      GIFImage:=TGIFImage.Create;
      try
        GIFImage.LoadFromFile(FileName);
        result:=TPicture.Create;
        result.Assign(GIFImage);
      finally
        GIFImage.Free;
      end;
      exit;
    end;
    result:=TPicture.Create;
    If Ext='.BMP' then begin
      FSt:=TFileStream.Create(FileName,fmOpenRead);
      try
        If (FSt.Read(B,2)<>2) or (B[0]<>$42) or (B[1]<>$4D) then begin
          FreeAndNil(result); exit;
        end;
      finally
        FSt.Free;
      end;
    end;
    If Ext='.ICO' then begin
      result.LoadFromFile(FileName);
      try
        result.Icon.Handle; {Loading successful ?}
      except
        I:=LoadIconFromExeFile(FileName);
        If I=nil then FreeAndNil(result) else begin
          try result.Assign(I); finally I.Free; end;
        end;
      end;
      exit;
    end;
    If Ext='.EXE' then begin
      I:=LoadIconFromExeFile(FileName);
      If I=nil then FreeAndNil(result) else begin
        try result.Assign(I); finally I.Free; end;
      end;
      exit;
    end;

    result.LoadFromFile(FileName);
  except
    If result<>nil then FreeAndNil(result);
  end;
end;

Function LoadImageAsIconFromFile(const FileName : String) : TIcon;
Var P : TPicture;
    IL : TImageList;
    C : TColor;
    B : TBitmap;
begin
  result:=nil;

  If ExtUpperCase(ExtractFileExt(FileName))='.EXE' then begin result:=LoadIconFromExeFile(FileName); exit; end;

  P:=LoadImageFromFile(FileName); If P=nil then exit;
  try
    IL:=TImageList.Create(nil);
    IL.Width:=256; IL.Height:=256;
    try
      B:=TBitmap.Create;
      try
        B.SetSize(IL.Width,IL.Height);
        ScaleImage(P,B);
        C:=B.Canvas.Pixels[0,B.Height-1];
        IL.AddMasked(B,C);

        result:=TIcon.Create;
        IL.GetIcon(0,result);
      finally
        B.Free;
      end;
    finally
      IL.Free;
    end;
  finally
    P.Free;
  end;
end;

const CLSID_ActiveDesktop : TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';

Procedure SetDesktopWallpaper(const FileName : String; const WPStyle : TWallpaperStyle);
Var S : String;
    P : TPicture;
    WS: PWideChar;
    ActiveDesktop: IActiveDesktop;
    WallpaperOptions: TWallpaperOpt;
begin
  S:=FileName;

  If ExtUpperCase(ExtractFileExt(S))='.PNG' then begin
    P:=LoadImageFromFile(FileName);
    If P=nil then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[FileName]),mtError,[mbOK],0);
      exit;
    end;
    try
      S:=TempDir+ChangeFileExt(ExtractFileName(S),'.bmp');
      SaveImageToFile(P,S);
    finally
      P.Free;
    end;
  end;

  ActiveDesktop:=CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;
  WS:=AllocMem(MAX_PATH);
  try
    StringToWideChar(S,WS,MAX_PATH);
    if not ActiveDesktop.SetWallpaper(WS,0)=S_OK then exit;
    WallpaperOptions.dwSize:=SizeOf(TWallpaperOpt);
    case WPStyle of
      WSTile    : WallpaperOptions.dwStyle:=WPSTYLE_TILE;
      WSCenter  : WallpaperOptions.dwStyle:=WPSTYLE_CENTER;
      WSStretch : WallpaperOptions.dwStyle:=WPSTYLE_STRETCH;
      else        WallpaperOptions.dwStyle:=WPSTYLE_CENTER;
    end;
    ActiveDesktop.SetWallpaperOptions(WallpaperOptions,0);
    ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
  finally
    FreeMem(WS);
  end;
end;

Type TCharsetNameRecord=record
  Name : String;
  Nr : Integer;
end;

const  CharsetNamesList : Array[0..17] of TCharsetNameRecord=(
  (Name: 'ANSI_CHARSET'; Nr: 0),
  (Name: 'DEFAULT_CHARSET'; Nr: 1),
  (Name: 'SYMBOL_CHARSET'; Nr: 2),
  (Name: 'SHIFTJIS_CHARSET'; Nr: $80),
  (Name: 'HANGEUL_CHARSET'; Nr: 129),
  (Name: 'GB2312_CHARSET'; Nr: 134),
  (Name: 'CHINESEBIG5_CHARSET'; Nr: 136),
  (Name: 'OEM_CHARSET'; Nr: 255),
  (Name: 'JOHAB_CHARSET'; Nr: 130),
  (Name: 'HEBREW_CHARSET'; Nr: 177),
  (Name: 'ARABIC_CHARSET'; Nr: 178),
  (Name: 'GREEK_CHARSET'; Nr: 161),
  (Name: 'TURKISH_CHARSET'; Nr: 162),
  (Name: 'VIETNAMESE_CHARSET'; Nr: 163),
  (Name: 'BALTIC_CHARSET'; Nr: 186),
  (Name: 'THAI_CHARSET'; Nr: 222),
  (Name: 'EASTEUROPE_CHARSET'; Nr: 238),
  (Name: 'RUSSIAN_CHARSET'; Nr: 204)
);

Function CharsetNameToFontCharSet(const Name : String) : TFontCharset;
Var S : String;
    I,Nr : Integer;
begin
  result:=DEFAULT_CHARSET;

  S:=Trim(ExtUpperCase(Name));
  If not TryStrToInt(S,Nr) then Nr:=-1;
  For I:=Low(CharsetNamesList) to High(CharsetNamesList) do If (Trim(ExtUpperCase(CharsetNamesList[I].Name))=S) or (CharsetNamesList[I].Nr=Nr) then begin
    result:=CharsetNamesList[I].Nr; exit;
  end;
end;

Function UnmapDrive(const Path : String; const PathType : TPathType) : String;
Var C : Char;
    S : String;
    I : Integer;
begin
  result:=Path;
  If not WineSupportEnabled then exit;
  Case PathType of
    ptMount      : if not PrgSetup.RemapMounts then exit;
    ptScreenshot : if not PrgSetup.RemapScreenShotFolder then exit;
    ptMapper     : if not PrgSetup.RemapMapperFile then exit;
    ptDOSBox     : if not PrgSetup.RemapDOSBoxFolder then exit;
  end;

  If (length(Path)<2) or (Path[2]<>':') then exit;
  C:=UpCase(Path[1]);
  If (C<'A') or (C>'Z') then exit;
  S:=PrgSetup.LinuxRemap[C];
  If S='' then exit;

  For I:=1 to length(result) do If result[I]='\' then result[I]:='/';
  If S[length(S)]<>'/' then S:=S+'/';
  result:=S+copy(result,4,MaxInt);
  If copy(result,length(result)-1,2)='/'+'/' then result:=Copy(result,1,length(result)-1);
end;

Function GetScreensaverAllowStatus : Boolean;
Var I : Integer;
begin
  SystemParametersInfo(SPI_GETSCREENSAVEACTIVE,0,@I,0);
  result:=(I<>0);
end;

Procedure SetScreensaverAllowStatus(const Enable : Boolean);
begin
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,Cardinal(Enable),nil,0);
end;

function GetTextSize( const hfnt: HFONT; var str: String ):SIZE;
{by Alexander Katz (skatz@svitonline.com)}
var
 hdc0: HDC;
 hfnt_saved: HFONT;
 txt_size : SIZE;
begin
  hdc0 := GetDC(0);
  try
    hfnt_saved := SelectObject(hdc0,hfnt);
    txt_size.cx:=0;
    txt_size.cy:=0;
    GetTextExtentPoint32( hdc0 , PChar(str), Length(str), txt_size );
    SelectObject(hdc0,hfnt_saved);
  finally
    ReleaseDC(0,hdc0);
  end;
  Result:=txt_size;
end;

procedure SetComboHint(Combo: TComboBox);
{by Alexander Katz (skatz@svitonline.com)}
var
 str: String;
 VisWidth: Integer;
begin
  if Combo.ItemIndex>=0 then str:=Combo.Items[Combo.ItemIndex]
  else str:=Combo.Text;
  VisWidth:=Combo.Width-4;
  if Combo.Style<>csSimple then VisWidth:=VisWidth-GetSystemMetrics(SM_CXHSCROLL);
  if GetTextSize(Combo.Font.Handle, str).cx+2<=VisWidth then str:='';
  Combo.Hint:=str;
  Combo.ShowHint:=str<>'';
end;

procedure SetComboDropDownDropDownWidth(Combo: TComboBox);
{by Alexander Katz (skatz@svitonline.com)}
var
 DroppedWidth: Integer;
 ScreenRight: Integer;
 pnt: TPoint;
 rect_size : SIZE;
 item_str : String;
 hdc0 :HDC;
 hfnt : HFONT;
 i : Integer;
 cur_width : Integer;
begin
  rect_size.cx:=0;
  rect_size.cy:=0;
  DroppedWidth := 0;
  hdc0 := GetDC(0);
  try
    hfnt := SelectObject(hdc0,Combo.Font.Handle);
    for i:=0 to Combo.Items.Count-1 do
    begin
        item_str := Combo.Items[i];
        GetTextExtentPoint32( hdc0 , PChar(item_str), Length(item_str), rect_size );
        cur_width := rect_size.cx+8;
        if cur_width > DroppedWidth then DroppedWidth := cur_width;
    end;
    SelectObject(hdc0,hfnt);
  finally
    ReleaseDC(0,hdc0);
  end;

  if Combo.Items.Count>Combo.DropDownCount then
      DroppedWidth := DroppedWidth + GetSystemMetrics(SM_CXVSCROLL);
  pnt.x:=0;
  pnt.y:=0;
  pnt := Combo.ClientToScreen(pnt);
  ScreenRight := Screen.DesktopLeft+Screen.DesktopWidth;
  if pnt.x+DroppedWidth>ScreenRight then
  begin
    if ScreenRight - pnt.x > Combo.Width then
      DroppedWidth := ScreenRight - pnt.x
    else
      DroppedWidth := Combo.Width;
  end;
  SendMessage( Combo.Handle, CB_SETDROPPEDWIDTH, DroppedWidth, 0 );
end;

Function TranslateExtendedEnvironmentString(const EnvKey : String; Var EnvValue : String) : Boolean;
Var Reg : TRegistry;
    St : TStringList;
    I : Integer;
    S : String;
begin
  result:=False;
  S:=ExtUpperCase(EnvKey);

  If (S='SYSTEMROOT') or (S='%SYSTEMROOT%') or (S='WINDIR') or (S='%WINDIR%') then begin
    SetLength(EnvValue,515);
    result:=(GetWindowsDirectory(PChar(EnvValue),512)<>0); SetLength(EnvValue,StrLen(PChar(EnvValue)));
    if result then exit;
  end;

  If (S='SYSTEMDRIVE') or (S='%SYSTEMDRIVE%') then begin
    SetLength(EnvValue,515);
    result:=(GetWindowsDirectory(PChar(EnvValue),512)<>0); SetLength(EnvValue,StrLen(PChar(EnvValue)));
    result:=result and (length(EnvValue)>=2); EnvValue:=Copy(EnvValue,1,2);
    if result then exit;
  end;

  If (S='SYSTEMDIRECTORY') or (S='%SYSTEMDIRECTORY%') then begin
    EnvValue:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_SYSTEM);
    result:=length(EnvValue)>=2; EnvValue:=ExcludeTrailingPathDelimiter(EnvValue);
    if result then exit;
  end;

  If (S='PROGRAMFILES') or (S='%PROGRAMFILES%') then begin
    EnvValue:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
    result:=length(EnvValue)>=2; EnvValue:=ExcludeTrailingPathDelimiter(EnvValue);
    if result then exit;
  end;

  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    if not Reg.OpenKeyReadOnly('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment') then exit;
    St:=TStringList.Create;
    try
      Reg.GetValueNames(St);
      For I:=0 to St.Count-1 do If (ExtUpperCase(St[I])=S) or ('%'+ExtUpperCase(St[I])+'%'=S) then begin
        EnvValue:=ExcludeTrailingPathDelimiter(Reg.ReadString(St[I]));
        result:=True;
        exit;
      end;
    finally
      St.Free;
    end;
  finally
    Reg.Free;
  end;
end;

Function GetEditorForIntTry1(const Extension : String; const RegKey : String) : String;
Var Reg : TRegistry;
    S : String;
begin
  result:='';

  Reg:=TRegistry.Create;
  try
    {find type name of "*.txt" files}
    Reg.RootKey:=HKEY_CURRENT_USER;
    If not Reg.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\'+Extension+'\UserChoise') then exit;
    S:=Reg.ReadString('Progid');
    If S='' then exit;

    {find program to open files of this type}
    Reg.RootKey:=HKEY_CLASSES_ROOT;
    if not Reg.OpenKeyReadOnly('\'+S+RegKey) then exit;
    result:=Reg.ReadString('');
  finally
    Reg.Free;
  end;
end;

Function GetEditorForIntTry2(const Extension : String; const RegKey : String) : String;
Var Reg : TRegistry;
    S : String;
begin
  result:='';

  Reg:=TRegistry.Create;
  try
    {find type name of "*.txt" files}
    Reg.RootKey:=HKEY_CLASSES_ROOT;
    If not Reg.OpenKeyReadOnly('\'+Extension) then exit;
    S:=Reg.ReadString('');
    If S='' then exit;

    {find program to open files of this type}
    if not Reg.OpenKeyReadOnly('\'+S+RegKey) then exit;
    result:=Reg.ReadString('');
  finally
    Reg.Free;
  end;
end;

Function GetEditorForIntTry3(const Extension : String; const RegKey : String) : String;
Var Reg : TRegistry;
    S,T : String;
    St : TStringList;
    I : Integer;
begin
  result:='';

  Reg:=TRegistry.Create;
  try
    {find type name of "*.txt" files}
    Reg.RootKey:=HKEY_CURRENT_USER;
    If not Reg.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\'+Extension+'\OpenWithProgids') then exit;
    St:=TStringList.Create;
    try
      Reg.GetValueNames(St);
      T:=Copy(Extension,2,MaxInt)+'file';
      S:=''; For I:=0 to St.Count-1 do If (St[I]<>T) and (St[I]<>'') then begin S:=St[I]; break; end;
      If S='' then begin
        If S='' then exit;
        S:=''; For I:=0 to St.Count-1 do If St[I]<>'' then begin S:=St[I]; break; end;
      end;
    finally
      St.Free;
    end;

    {find program to open files of this type}
    Reg.RootKey:=HKEY_CLASSES_ROOT;
    if not Reg.OpenKeyReadOnly('\'+S+RegKey) then exit;
    result:=Reg.ReadString('');
  finally
    Reg.Free;
  end;
end;

Function GetEditorFor(Extension : String; const RemoveParameters : Boolean) : String;
Var S,T : String;
    I,J,K : Integer;
begin
  result:='';
  If Extension='' then exit;
  If Extension[1]<>'.' then Extension:='.'+Extension;
  Extension:=LowerCase(Extension);

  S:=GetEditorForIntTry1(Extension,'\shell\edit\command');
  If S=''then S:=GetEditorForIntTry2(Extension,'\shell\edit\command');
  If S=''then S:=GetEditorForIntTry3(Extension,'\shell\edit\command');
  if (S='') and (Extension='.txt') then begin
    S:=GetEditorForIntTry1(Extension,'\shell\open\command');
    If S='' then S:=GetEditorForIntTry2(Extension,'\shell\open\command');
    if S='' then S:=GetEditorForIntTry3(Extension,'\shell\open\command');
  end;
  If S='' then exit;

  {remove leading and trailing "}
  If  (S<>'') and (S[1]='"') then begin
    Delete(S,1,1);
    For I:=1 to length(S) do If S[I]='"' then begin Delete(S,I,1); break; end;
  end;

  If RemoveParameters then begin
    {remove "%1"}
    I:=Pos('"%1"',S); If I>0 then S:=Copy(S,1,I-1)+Copy(S,I+4,MaxInt);
    I:=Pos('%1',S); If I>0 then S:=Copy(S,1,I-1)+Copy(S,I+2,MaxInt);
  end;

  {Translate %SystemRoot% etc.}
  I:=1;
  While I<length(S) do begin
    If S[I]='%' then begin
      K:=-1;
      For J:=I+1 to length(S)-1 do if S[J]='%' then begin K:=J; break; end;
      If K=-1 then break;
      If TranslateExtendedEnvironmentString(Copy(S,I,K-I+1),T) then begin
        S:=Copy(S,1,I-1)+T+Copy(S,K+1,MaxInt);
        continue;
      end;
    end;
    inc(I);
  end;

  If (Pos('%1',S)=0) and (not FileExists(S)) then exit;
  result:=Trim(S);
end;

Procedure TestAndFixLineWrap(const FileName : String);
const BufSize=512;
Var FSt : TFileStream;
    NeedFix : Boolean;
    Buffer : Array[0..BufSize] of Char;
    LastChar : Char;
    I,J : Integer;
    St : TStringList;
    S : String;
begin
  S:=Trim(ExtUpperCase(ExtractFileExt(FileName)));
  If (S<>'.BAT') and (S<>'.TXT') and (S<>'.NFO') and (S<>'.DIZ') and (S<>'.1ST') and (S<>'.INI') and (S<>'.PROF') and (S<>'.CONF') then exit;

  {#10 -> #13#10}
  try
    NeedFix:=False;
    FSt:=TFileStream.Create(FileName,fmOpenRead);
    try
      LastChar:=#0;
      while FSt.Position<FSt.Size-1 do begin
        I:=Min(BufSize,FSt.Size-FSt.Position-1);
        FSt.ReadBuffer(Buffer,I);
        For J:=0 to I-1 do If Buffer[J]=#10 then begin
          If J>0 then begin
            NeedFix:=(Buffer[J-1]<>#13); break;
          end else begin
            If LastChar<>#0 then begin
              NeedFix:=(LastChar<>#13); break;
            end;
          end;
        end;
      end;
    finally
      FSt.Free;
    end;

    If not NeedFix then exit;

    St:=TStringList.Create;
    try
      St.LoadFromFile(FileName);
      St.SaveToFile(FileName);
    finally
      St.Free;
    end;
  except
    exit;
  end;
end;

Function GetDefaultEditor(Extension : String; const FileTypeFallback : Boolean; const RemoveParameters : Boolean) : String;
begin
  result:=GetEditorFor(Extension,RemoveParameters);
  If (result='') and FileTypeFallback then result:=GetEditorFor('.txt',RemoveParameters);
  If result='' then result:='Notepad.exe';
end;

Procedure OpenFileInEditor(const FileName : String);
Var S,Editor : String;
    I : Integer;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  If PrgSetup.AutoFixLineWrap then TestAndFixLineWrap(FileName);

  Editor:='Notepad.exe';
  S:=Trim(ExtUpperCase(PrgSetup.TextEditor));
  If S='' then begin
    Editor:=GetDefaultEditor(ExtractFileExt(FileName),PrgSetup.FileTypeFallbackForEditor,False);
  end else begin
    If (S<>'NOTEPAD') and (S<>'NOTEPAD.EXE') then begin
      If FileExists(MakeAbsPath(PrgSetup.TextEditor,PrgSetup.BaseDir)) then Editor:=MakeAbsPath(PrgSetup.TextEditor,PrgSetup.BaseDir);
    end;
  end;

  I:=Pos('%1',Editor);
  If I=0 then begin
    ShellExecute(Application.MainForm.Handle,'open',PChar(Editor),PChar('"'+FileName+'"'),PChar(ExtractFilePath(FileName)),SW_SHOW);
  end else begin
    Editor:=Copy(Editor,1,I-1)+FileName+Copy(Editor,I+2,MaxInt);
    {ShellExecute(Application.MainForm.Handle,'open',PChar(Editor),nil,PChar(ExtractFilePath(FileName)),SW_SHOW);}
    StartupInfo.cb:=SizeOf(StartupInfo);
    with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;
    CreateProcess(nil,PChar(Editor),nil,nil,False,0,nil,PChar(ExtractFilePath(FileName)),StartupInfo,ProcessInformation);
    CloseHandle(ProcessInformation.hThread);
    CloseHandle(ProcessInformation.hProcess);
  end;
end;

Function OpenMediaFile(const SetupString, FileName : String) : Boolean;
Var S : String;
begin
  result:=True;

  S:=Trim(ExtUpperCase(SetupString));
  If S='DEFAULT' then begin
    ShellExecute(Application.MainForm.Handle,'open',PChar(FileName),nil,PChar(ExtractFilePath(FileName)),SW_SHOW);
    exit;
  end;
  If (S<>'') and (S<>'INTERNAL') and FileExists(MakeAbsPath(SetupString,PrgSetup.BaseDir)) then begin
    ShellExecute(Application.MainForm.Handle,'open',PChar(MakeAbsPath(SetupString,PrgSetup.BaseDir)),PChar('"'+FileName+'"'),PChar(ExtractFilePath(FileName)),SW_SHOW);
    exit;
  end;

  result:=False;
end;

Function GetFileSize(const AFileName : String) : Int64;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=0;
  I:=FindFirst(AFileName,faAnyFile,Rec);
  try
    If I=0 then result:=Rec.Size;
  finally
    FindClose(Rec);
  end;
end;

Function FileSizeToStr(const Size : Int64) : String;
begin
  If Size<1024 then begin result:=IntToStr(Size)+' Bytes'; exit; end;
  If Size<1024*1024 then begin result:=Format('%.1fKB',[Size/1024]); exit; end;
  If Size<1024*1024*1024 then begin result:=Format('%.1fMB',[Size/1024/1024]); exit; end;
  result:=Format('%.1fGB',[Size/1024/1024/1024]);
end;

Function BaseDirSecuriryCheck(const DirToDelete : String) : Boolean;
begin
  result:=BaseDirSecuriryCheckOnly(DirToDelete);
  If not result then MessageDlg(Format(LanguageSetup.MessageDeleteErrorProtection,[IncludeTrailingPathDelimiter(DirToDelete)]),mtError,[mbOk],0);
end;

Function BaseDirSecuriryCheckOnly(const DirToDelete : String) : Boolean;
Var S, Folder : String;
begin
  result:=True;
  If not PrgSetup.DeleteOnlyInBaseDir then exit;
  Folder:=IncludeTrailingPathDelimiter(DirToDelete);
  if not DirectoryExists(Folder) then exit;
  S:=ShortName(PrgSetup.BaseDir);
  If ExtUpperCase(Copy(ShortName(Folder),1,length(S)))=ExtUpperCase(S) then exit;
  result:=False;
end;

Function ExtDeleteFolderOnlyInt(const Dir, DeletePrgSetupRecord : String; const FolderType : TDeleteFileType) : Boolean;
begin
  if not DirectoryExists(Dir) then begin result:=True; exit; end;

  If DeletePrgSetupRecord[Integer(FolderType)+1]='1' then begin
    result:=DeleteFileToRecycleBinNoWarning(IncludeTrailingPathDelimiter(Dir));
  end else begin
    result:=RemoveDir(IncludeTrailingPathDelimiter(Dir));
  end;
end;

Function DeleteFolderIntNoWarning(const Dir, DeletePrgSetupRecord : String; const FolderType : TDeleteFileType) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
    Dirs,Files : TStringList;
    S : String;
    FileOp : TSHFileOpStruct;
begin
  S:=ExcludeTrailingPathDelimiter(Dir)+#0+#0;
  with FileOp do begin
    Wnd:=0;
    wFunc:=FO_DELETE;
    pFrom:=PChar(S);
    pTo:=nil;
    fFlags:=FOF_NOCONFIRMATION+FOF_NOERRORUI+FOF_SILENT;
    fAnyOperationsAborted:=False;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=(SHFileOperation(FileOp)=0) and (not FileOp.fAnyOperationsAborted);
  if result then exit;

  result:=True;
  If not DirectoryExists(Dir) then exit;
  If Pos('..',Dir)<>0 then begin result:=False; exit; end;

  Dirs:=TStringList.Create;
  Files:=TStringList.Create;
  try
    I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
    try
      while I=0 do begin
        if (Rec.Attr and faDirectory)=faDirectory then begin
          If Rec.Name[1]<>'.' then Dirs.Add(Rec.Name);
        end else begin
          Files.Add(Rec.Name);
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    For I:=0 to Files.Count-1 do begin
      If DeletePrgSetupRecord[Integer(FolderType)+1]='1' then begin
        if not DeleteFileToRecycleBin(Dir+Files[I]) then result:=False;
      end else begin
        If not DeleteFile(Dir+Files[I]) then result:=False;
      end;
    end;

    For I:=0 to Dirs.Count-1 do
      if not DeleteFolderIntNoWarning(Dir+Dirs[I]+'\',DeletePrgSetupRecord,FolderType) then result:=False;

  finally
    Dirs.Free;
    Files.Free;
  end;

  if not ExtDeleteFolderOnlyInt(Dir,DeletePrgSetupRecord,FolderType) then result:=False;
end;

Function DeleteFolderInt(const Dir, DeletePrgSetupRecord : String; const FolderType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
    ErrorIgnored : Boolean;
    Dirs,Files : TStringList;
    S : String;
    FileOp : TSHFileOpStruct;
begin
  S:=ExcludeTrailingPathDelimiter(Dir)+#0+#0;
  with FileOp do begin
    Wnd:=0;
    wFunc:=FO_DELETE;
    pFrom:=PChar(S);
    pTo:=nil;
    fFlags:=FOF_NOCONFIRMATION+FOF_NOERRORUI+FOF_SILENT;
    fAnyOperationsAborted:=False;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=(SHFileOperation(FileOp)=0) and (not FileOp.fAnyOperationsAborted);
  if result then exit;

  result:=False;
  ContinueNext:=False;
  ErrorIgnored:=False;

  If not DirectoryExists(Dir) then begin result:=True; exit; end;

  If Pos('..',Dir)<>0 then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorDotDotInPath,[Dir]),mtError,[mbOk],0);
    exit;
  end;

  Dirs:=TStringList.Create;
  Files:=TStringList.Create;
  try
    I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
    try
      while I=0 do begin
        if (Rec.Attr and faDirectory)=faDirectory then begin
          If Rec.Name[1]<>'.' then Dirs.Add(Rec.Name);
        end else begin
          Files.Add(Rec.Name);
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    For I:=0 to Files.Count-1 do if not ExtDeleteFile(Dir+Files[I],FolderType,AllowContinueNext,ContinueNext,DeletePrgSetupRecord) then begin
      If ContinueNext then ErrorIgnored:=True else exit;
    end;

    For I:=0 to Dirs.Count-1 do if not DeleteFolderInt(Dir+Dirs[I]+'\',DeletePrgSetupRecord,FolderType,AllowContinueNext,ContinueNext) then begin
      If ContinueNext then ErrorIgnored:=True else exit;
    end;

  finally
    Dirs.Free;
    Files.Free;
  end;

  repeat
    if not ExtDeleteFolderOnlyInt(Dir,DeletePrgSetupRecord,FolderType) then begin
      If ErrorIgnored then begin result:=False; ContinueNext:=True; exit; end;
      If AllowContinueNext then begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Dir])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
          mrIgnore : begin ContinueNext:=True; exit; end;
          mrRetry : ;
          else exit;
        End;
      end else begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Dir])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry],0) of
          mrRetry : ;
          else exit;
        End;
      end;
    end else begin
      break;
    end;
  until False;

  result:=True;
  ContinueNext:=True;
end;

Function ExtDeleteFile(const FileName : String; const FileType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean; const DeletePrgSetupRecord : String) : Boolean;
Var S : String;
begin
  if not FileExists(FileName) then begin result:=True; exit; end;

  If DeletePrgSetupRecord='' then begin
    If not Assigned(PrgSetup) then S:='' else S:=Copy(PrgSetup.DeleteToRecycleBin,1,7);
  end else begin
    S:=DeletePrgSetupRecord;
  end;
  S:=S+Copy('1011110',length(S)+1,MaxInt);

  If S[Integer(FileType)+1]='1' then begin
    result:=DeleteFileToRecycleBin(FileName,AllowContinueNext,ContinueNext);
    exit;
  end;

  result:=False;
  repeat
    If not DeleteFile(FileName) then begin
      If AllowContinueNext then begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
          mrIgnore : begin ContinueNext:=True; exit; end;
          mrRetry : ;
          else exit;
        End;
      end else begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry],0) of
          mrRetry : ;
          else exit;
        End;
      end;
    end else begin
      break;
    end;
  until False;
  result:=True;
end;

Function ExtDeleteFile(const FileName : String; const FileType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean;
Var B : Boolean;
begin
  result:=ExtDeleteFile(FileName,FileType,True,B,DeletePrgSetupRecord);
end;

Function ExtDeleteFileWithPause(const FileName : String; const FileType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean; const DeletePrgSetupRecord : String) : Boolean;
Var S : String;
    I : Integer;
begin
  if not FileExists(FileName) then begin result:=True; exit; end;

  If DeletePrgSetupRecord='' then begin
    If not Assigned(PrgSetup) then S:='' else S:=Copy(PrgSetup.DeleteToRecycleBin,1,7);
  end else begin
    S:=DeletePrgSetupRecord;
  end;
  S:=S+Copy('1011110',length(S)+1,MaxInt);

  If S[Integer(FileType)+1]='1' then begin
    result:=DeleteFileToRecycleBinWithPause(FileName,AllowContinueNext,ContinueNext);
    exit;
  end;

  result:=False;
  repeat
    For I:=0 to 10 do begin
      If DeleteFile(FileName) then begin result:=True; exit; end;
      Sleep(100);
    end;
    If not DeleteFile(FileName) then begin
      If AllowContinueNext then begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
          mrIgnore : begin ContinueNext:=True; exit; end;
          mrRetry : ;
          else exit;
        End;
      end else begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry],0) of
          mrRetry : ;
          else exit;
        End;
      end;
    end else begin
      break;
    end;
  until False;
  result:=True;
end;

Function ExtDeleteFileWithPause(const FileName : String; const FileType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean;
Var B : Boolean;
begin
  result:=ExtDeleteFileWithPause(FileName,FileType,True,B,DeletePrgSetupRecord);
end;

Function ExtDeleteFolder(const Folder : String; const FolderType : TDeleteFileType; const AllowContinueNext : Boolean; var ContinueNext : Boolean; const DeletePrgSetupRecord : String ='') : Boolean;
Var S : String;
    B : Boolean;
begin
  If not DirectoryExists(Folder) then begin result:=True; exit; end;

  If DeletePrgSetupRecord='' then begin
    If not Assigned(PrgSetup) then S:='' else S:=PrgSetup.DeleteToRecycleBin
  end else begin
    S:=DeletePrgSetupRecord;
  end;
  S:=Copy(S,1,7); S:=S+Copy('1011110',length(S)+1,MaxInt);

  If S[Integer(FolderType)+1]='1' then begin
    result:=DeleteFileToRecycleBin(Folder);
    exit;
  end;

  result:=DeleteFolderInt(Folder,S,FolderType,AllowContinueNext,B);
end;

Function ExtDeleteFolderNoWarning(const Folder : String; const FolderType : TDeleteFileType) : Boolean;
Var S : String;
begin
  If not DirectoryExists(Folder) then begin result:=True; exit; end;

  If not Assigned(PrgSetup) then S:='' else S:=PrgSetup.DeleteToRecycleBin;
  S:=Copy(S,1,7); S:=S+Copy('1011110',length(S)+1,MaxInt);

  If S[Integer(FolderType)+1]='1' then begin
    result:=DeleteFileToRecycleBin(Folder);
    exit;
  end;

  result:=DeleteFolderIntNoWarning(Folder,S,FolderType);
end;

Function ExtDeleteFolder(const Folder : String; const FolderType : TDeleteFileType; const DeletePrgSetupRecord : String) : Boolean;
Var B : Boolean;
begin
  result:=ExtDeleteFolder(Folder,FolderType,True,B,DeletePrgSetupRecord);
end;

Function DeleteFileToRecycleBin(const FileName : String; const AllowContinueNext : Boolean; var ContinueNext : Boolean) : Boolean;
Var FileOp : TSHFileOpStruct;
    ExtFileName : String;
begin
  if (not FileExists(ExcludeTrailingPathDelimiter(FileName))) and (not DirectoryExists(FileName)) then begin result:=True; exit; end;

  ExtFileName:=ExcludeTrailingPathDelimiter(FileName)+#0+#0;
  with FileOp do begin
    Wnd:=0;
    wFunc:=FO_DELETE;
    pFrom:=@ExtFileName[1];
    pTo:=nil;
    fFlags:=FOF_NOCONFIRMATION+FOF_NOERRORUI+FOF_SILENT+FOF_ALLOWUNDO;
    fAnyOperationsAborted:=False;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=False;
  repeat
    If (SHFileOperation(FileOp)<>0) or FileOp.fAnyOperationsAborted then begin
      If AllowContinueNext then begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
          mrIgnore : begin ContinueNext:=True; exit; end;
          mrRetry : ;
          else exit;
        End;
      end else begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry],0) of
          mrRetry : ;
          else exit;
        End;
      end;
    end else begin
      break;
    end;
  until False;
  result:=True;
end;

Function DeleteFileToRecycleBin(const FileName : String) : Boolean;
Var B : Boolean;
begin
  result:=DeleteFileToRecycleBin(FileName,True,B);
end;

Function DeleteFileToRecycleBinWithPause(const FileName : String; const AllowContinueNext : Boolean; var ContinueNext : Boolean) : Boolean;
Var FileOp : TSHFileOpStruct;
    ExtFileName : String;
    I : Integer;
begin
  if (not FileExists(ExcludeTrailingPathDelimiter(FileName))) and (not DirectoryExists(FileName)) then begin result:=True; exit; end;

  ExtFileName:=ExcludeTrailingPathDelimiter(FileName)+#0+#0;
  with FileOp do begin
    Wnd:=0;
    wFunc:=FO_DELETE;
    pFrom:=PChar(ExtFileName);
    pTo:=nil;
    fFlags:=FOF_NOCONFIRMATION+FOF_NOERRORUI+FOF_SILENT+FOF_ALLOWUNDO;
    fAnyOperationsAborted:=False;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=False;
  repeat
    For I:=0 to 10 do begin
      If (SHFileOperation(FileOp)=0) and (not FileOp.fAnyOperationsAborted) then begin result:=True; exit; end;
      Sleep(100);
    end;
    If (SHFileOperation(FileOp)<>0) or FileOp.fAnyOperationsAborted then begin
      If AllowContinueNext then begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
          mrIgnore : begin ContinueNext:=True; exit; end;
          mrRetry : ;
          else exit;
        End;
      end else begin
        Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry],0) of
          mrRetry : ;
          else exit;
        End;
      end;
    end else begin
      break;
    end;
  until False;
  result:=True;
end;

Function DeleteFileToRecycleBinNoWarning(const FileName : String) : Boolean;
Var FileOp : TSHFileOpStruct;
    ExtFileName : String;
begin
  if (not FileExists(ExcludeTrailingPathDelimiter(FileName))) and (not DirectoryExists(FileName)) then begin result:=True; exit; end;

  ExtFileName:=ExcludeTrailingPathDelimiter(FileName)+#0+#0;
  with FileOp do begin
    Wnd:=0;
    wFunc:=FO_DELETE;
    pFrom:=PChar(ExtFileName);
    pTo:=nil;
    fFlags:=FOF_NOCONFIRMATION+FOF_NOERRORUI+FOF_SILENT+FOF_ALLOWUNDO;
    fAnyOperationsAborted:=False;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=(SHFileOperation(FileOp)=0) and (not FileOp.fAnyOperationsAborted);
end;

Function CompareFiles(const File1, File2 : String) : Boolean;
const BSize=4096;
Var FSt1,FSt2 : TFileStream;
    B1,B2 : Array[0..BSize-1] of Byte;
    C : Cardinal;
    I,J : Integer;
begin
  result:=False;

  FSt1:=TFileStream.Create(File1,fmOpenRead);
  try
    FSt2:=TFileStream.Create(File2,fmOpenRead);
    try
      If FSt1.Size<>FSt2.Size then exit;
      C:=FSt1.Size;
      While C>0 do begin
        I:=Min(C,BSize);
        FSt1.ReadBuffer(B1,I);
        FSt2.ReadBuffer(B2,I);
        For J:=0 to I-1 do If B1[J]<>B2[J] then exit;
        dec(C,I);
      end;
    finally
      FSt2.Free;
    end;
  finally
    FSt1.Free;
  end;
  result:=True;
end;

Function GetFileList(const Folder : String; const Exts : Array of String) : TStringList;
Var Rec : TSearchRec;
    I,J : Integer;
begin
  result:=TStringList.Create;

  For I:=Low(Exts) to High(Exts) do begin
    J:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.'+Exts[I],faAnyFile,Rec);
    try
      While J=0 do begin
        If (Rec.Attr and faDirectory)=0 then result.Add(Rec.Name);
        J:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
  end;

  result.Sort;
end;

Function RenameAllFiles(const Folder, Expression, GameName : String; const RenameFiles : TRenameFiles; const ShowNoFilesInfo : Boolean) : Boolean;
const RequiredPlaceholders : Array[0..1] of String = ('%N','%E');
      ScreenshotExts : Array[0..4] of String = ('jpg','jpeg','png','gif','bmp');
      SoundsExts : Array[0..4] of String = ('wav','mp3','ogg','mid','midi');
      VideosExts : Array[0..4] of String = ('avi','mpeg','mpg','wmv','asf');
Var I,J : Integer;
    St : TStringList;
    Template,NewName,Nr,Ext,Dir,S : String;
begin
  result:=False;
  Dir:=IncludeTrailingPathDelimiter(Folder);

  {Expression ok?}
  For I:=Low(RequiredPlaceholders) to High(RequiredPlaceholders) do if Pos(RequiredPlaceholders[I],Expression)=0 then begin
    MessageDlg(Format(LanguageSetup.RenameAllPlaceholderError,[RequiredPlaceholders[I]]),mtError,[mbOK],0);
    exit;
  end;

  {Create list of files to rename}
  Case RenameFiles of
    rfScreenshots : St:=GetFileList(Dir,ScreenshotExts);
    rfSounds : St:=GetFileList(Dir,SoundsExts);
    rfVideos : St:=GetFileList(Dir,VideosExts);
    else exit;
  End;

  {Process files}
  result:=True;
  try
    If St.Count=0 then begin
      If ShowNoFilesInfo then MessageDlg(Format(LanguageSetup.RenameAllNoFiles,[Folder]),mtInformation,[mbOK],0);
      exit;
    end;
    Template:=Expression;
    I:=Pos('%P',Template); If I>0 then Template:=Copy(Template,1,I-1)+MakeFileSysOKFolderName(GameName)+Copy(Template,I+2,MaxInt);

    For I:=0 to St.Count-1 do begin
      NewName:=Template;
      Ext:=ExtractFileExt(St[I]); If (Ext<>'') and (Ext[1]='.') then Ext:=Copy(Ext,2,MaxInt);
      Nr:=IntToStr(I+1); while length(Nr)<Round(Ceil(Log10(St.Count+1))) do Nr:='0'+Nr;
      J:=Pos('%N',NewName); If J>0 then NewName:=Copy(NewName,1,J-1)+Nr+Copy(NewName,J+2,MaxInt);
      J:=Pos('%E',NewName); If J>0 then NewName:=Copy(NewName,1,J-1)+Ext+Copy(NewName,J+2,MaxInt);

      {File has already correct name?}
      If St[I]=NewName then continue;

      {File with new name already existing?}
      For J:=I+1 to St.Count-1 do begin
        If ExtUpperCase(NewName)=ExtUpperCase(St[J]) then begin
          S:=ExtractFileExt(St[J]); If S='' then S:='.';
          S:=Copy(St[J],1,length(St[J])-length(S))+'_'+IntToStr(J+1)+S;
          RenameFile(Dir+St[J],Dir+S);
          St[J]:=S;
        end;
      end;

      {Rename file}
      RenameFile(Dir+St[I],Dir+NewName);
    end;
  finally
    St.Free;
  end;
end;

{ This method was discovered by user DRON from www.delphikingdom.com site }
function ForceForegroundWindow(Wnd:HWND):Boolean;
var
  Input:TInput;
begin
  FillChar(Input,SizeOf(Input),0);
  SendInput(1,Input,SizeOf(TInput));
  Result:=SetForegroundWindow(Wnd);
end;

Function CPUCount : Integer;
Var SystemInfo : TSystemInfo;
begin
  GetSystemInfo(SystemInfo);
  result:=SystemInfo.dwNumberOfProcessors;
end;

function IsRemoteSession: Boolean;
begin
  result:=(GetSystemMetrics(SM_REMOTESESSION)<>0);
end;

end.
