unit DOSBoxShortNameUnit;
interface

Function DOSBoxShortName(const RootPath, LongName : String) : String;

implementation

uses Classes, SysUtils, Dialogs, Math, FileNameConvertor, DOSBoxUnit,
     CommonTools, PrgSetupUnit, LanguageSetupUnit;

{ old algorithm }

Function OldDOSBoxShortName(const RootPath, LongName : String) : String;
Var Path,ReferenceShortName,S : String;
    Rec : TSearchRec;
    I : Integer;
    St : TStringList;
    S1,S2 : String;
begin
  Path:=IncludeTrailingPathDelimiter(RootPath);

  {Check if LongName is already ok}
  S1:=ExtUpperCase(ShortName(Path+LongName));
  S:=ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(Path)));
  S1:=Copy(S1,length(S)+1,MaxInt);

  S2:=ExtUpperCase(Path+LongName);
  S:=ExtUpperCase(IncludeTrailingPathDelimiter(Path));
  S2:=Copy(S2,length(S)+1,MaxInt);

  If S1=S2 then begin result:=ExtUpperCase(LongName); exit; end;

  {Create short name for compareing}
  ReferenceShortName:=ExtractFileName(ExtUpperCase(ShortName(Path+LongName)));
  If length(ReferenceShortName)>2 then SetLength(ReferenceShortName,length(ReferenceShortName)-2);
  result:=ReferenceShortName+'~1';

  St:=TStringList.Create;
  try
    {Find all files with the same shortname (without ~x}
    I:=FindFirst(Path+'*.*',faAnyFile,Rec);
    try
      While I=0 do begin
        S:=ExtUpperCase(ShortName(Path+Rec.Name));
        While Pos('\',S)>0 do S:=Copy(S,Pos('\',S)+1,MaxInt);
        If length(S)>2 then SetLength(S,length(S)-2);
        If S=ReferenceShortName then St.Add(Rec.Name);
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    {Find new number}
    St.Sort;
    For I:=0 to St.Count-1 do begin
      If ExtUpperCase(St[I])=ExtUpperCase(LongName) then begin
        result:=ReferenceShortName+'~'+IntToStr(I+1); exit;
      end;
    end;
  finally
    St.Free;
  end;
end;

{ new algorithm }

Function PathNameOK(SubDir : String) : Boolean;
const AllowedCharsDefault='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyzäöüß01234567890-_=.,;!()$#@{}&''`~'+chr(246)+chr(255)+chr($a0)+chr($e5);
Var I : Integer;
    Name, Ext : String;
begin
  result:=False;

  {Only check subdir}
  repeat
    I:=Pos('\',SubDir);
    If I>0 then SubDir:=Copy(SubDir,I+1,MaxInt);
  until I<=0;

  I:=Pos('.',SubDir);
  If I>0 then begin Name:=Copy(SubDir,1,I-1); Ext:=Copy(SubDir,I+1,MaxInt); end else begin Name:=SubDir; Ext:=''; end;

  If (length(Name)>8) or (length(Ext)>3) then exit;

  For I:=1 to length(Name) do if Pos(Name[I],AllowedCharsDefault)<0 then exit;
  For I:=1 to length(Ext) do if Pos(Ext[I],AllowedCharsDefault)<0 then exit;

  result:=True;
end;

Procedure GetShortParts(const PathName : String; var Name, Ext : String);
Var I : Integer;
begin
  I:=Pos('.',PathName);
  If I>0 then begin Name:=Copy(PathName,1,I-1); Ext:=Copy(PathName,I+1,MaxInt); end else begin Name:=PathName; Ext:=''; end;
  Name:=RemoveIllegalFileNameChars(Name);
  If Name<>'' then Name:=ExtUpperCase(Name);
  Ext:=RemoveIllegalFileNameChars(Ext);
  If Ext<>'' then Ext:=ExtUpperCase(Ext);
  If length(Name)>8 then Name:=Copy(Name,1,8);
  If length(Ext)>3 then Ext:=Copy(Ext,1,3);
end;

Function FilesWithSameShortName(ParentDir : String; Name, Ext : String; const Digits : Integer) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
    Name2, Ext2 : String;
begin
  result:=TStringList.Create;

  ParentDir:=IncludeTrailingPathDelimiter(ParentDir);
  If length(Name)>8-1-Digits then SetLength(Name,8-1-Digits);

  I:=FindFirst(ParentDir+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        If not PathNameOK(Rec.Name) then begin
          GetShortParts(Rec.Name,Name2,Ext2);
          If length(Name2)>8-1-Digits then SetLength(Name2,8-1-Digits);
          If (Name=Name2) and (Ext=Ext2) then result.Add(Rec.Name);
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function NewDOSBoxShortName(const RootPath, LongName : String) : String;
Var PDir, SDir, Name, Ext, S : String;
    I : Integer;
    St : TStringList;
begin
  result:='';

  PDir:=IncludeTrailingPathDelimiter(MakeAbsPath(RootPath,PrgSetup.BaseDir));
  SDir:=LongName;

  If (not DirectoryExists(PDir+SDir)) and (not FileExists(PDir+SDir)) then exit;

  If PathNameOK(SDir) then begin result:=ExtUpperCase(SDir); exit; end;

  GetShortParts(SDir,Name,Ext);

  I:=0; St:=nil;

  try
    repeat
      inc(I);
      If Assigned(St) then FreeAndNil(St);
      St:=FilesWithSameShortName(PDir,Name,Ext,I);
    until St.Count<Round(Power(10,I));

    St.Sort;

    S:=ExtUpperCase(SDir);
    For I:=0 to St.Count-1 do If ExtUpperCase(St[I])=S then begin
      S:=IntToStr(I+1);
      S:=Copy(Name,1,8-1-length(S))+'~'+S;
      result:=S;
      break;
    end;

  finally
    St.Free;
  end;
end;

{ the real DOSBox way of making short names}

Procedure RealDOSBoxShortNameErrorMessage(const RootPath, LongName, ShortName : String; ConvertResult : TConvertResult);
Var ErrorMessage : String;
begin
  ErrorMessage:='';
  case ConvertResult of
    tcrErrParentNotFound          : ErrorMessage:=Format(LanguageSetup.MessageShortNameErrorParentNotFound,[RootPath]);
    tcrErrDelimiterInFileName     : ErrorMessage:=Format(LanguageSetup.MessageShortNameErrorDelimiterInFileName,[LongName]);
    tcrErrFileNotFound            : ErrorMessage:=Format(LanguageSetup.MessageShortNameErrorFileNotFound,[LongName,RootPath]);
    tcrWarnInvalidChars           : ErrorMessage:=Format(LanguageSetup.MessageShortNameWarningInvalidChars,[LongName]);
    tcrWarnSystemShort            : ErrorMessage:=Format(LanguageSetup.MessageShortNameWarningSystemShort,[LongName]);
    tcrWarnSystemShortAlreadyUsed : ErrorMessage:=Format(LanguageSetup.MessageShortNameWarningSystemShortAlreadyUsed,[LongName]);
    else ErrorMessage:='';
  end;
  If ErrorMessage<>'' then begin
    If ConvertResult in [tcrWarnInvalidChars, tcrWarnSystemShort, tcrWarnSystemShortAlreadyUsed]
      then MessageDlg(ErrorMessage,mtWarning,[mbOK],0)
      else MessageDlg(ErrorMessage,mtError,[mbOK],0);
  end;
end;

Function RealDOSBoxShortName(const RootPath, LongName : String; const UseSystemShortName : Boolean) : String;
Var ConvertResult : TConvertResult;
    isDir : Boolean;
    ShortName : String;
begin
  ConvertResult:=ConvertLongFileNameToShort(
    RootPath,
    LongName,
    WineSupportEnabled,
    UseSystemShortName,
    True,
    False,
    ShortName,isDir
  );

  If ConvertResult in [tcrErrParentNotFound, tcrErrDelimiterInFileName, tcrErrFileNotFound] then ShortName:=LongName;
  result:=ShortName;

  If not PrgSetup.ShowShortNameWarnings then exit;
  RealDOSBoxShortNameErrorMessage(RootPath,LongName,ShortName,ConvertResult); {if not in separate function compiler says "return value may not defined"}
end;

{ select algorithm }

Function DOSBoxShortName(const RootPath, LongName : String) : String;
begin
  Case PrgSetup.DOSBoxShortFileNameAlgorithm of
    1 : result:=OldDOSBoxShortName(RootPath,LongName);
    2 : begin result:=NewDOSBoxShortName(RootPath,LongName); if result='' then result:=OldDOSBoxShortName(RootPath,LongName); end;
    3 : result:=RealDOSBoxShortName(RootPath,LongName,False);
    else result:=RealDOSBoxShortName(RootPath,LongName,False);
  end;
end;

end.
