unit DOSBoxLangTools;
interface

uses Classes;

Function LoadDOSBoxLangFile(const FileName : String; const LangIDStrings, LangValueStrings : TStringList) : Boolean;
Function SaveDOSBoxLangFile(const FileName : String; const LangIDStrings, LangValueStrings : TStringList) : Boolean;

Procedure GetDOSBoxLangNamesAndFiles(const DOSBoxPath : String; const Names, Files : TStrings; const WithDefaultEnglish : Boolean);
Function GetDOSBoxLangNames(const DOSBoxPath : String; const WithDefaultEnglish : Boolean) : TStringList;

Function GetTempDOSBoxEnglishLangFile : String;

implementation

uses Windows, SysUtils, Math, CommonTools, PrgConsts, PrgSetupUnit,
     DOSBoxTempUnit, DOSBoxUnit, MainUnit;

const SpecialChars : Array[0..6] of AnsiChar = (ansichar($1B), ansichar($C9),
          ansichar($CD), ansichar($BA), ansichar($BB), ansichar($C8), ansichar($BC));
      SpecialSymbols : Array[0..6] of String = ('<ESC>','<UL>','<->','<|>','<UR>','<LL>','<LR>');

const NoConvert : Array[0..2] of String = ('CONFIG_','AUTOEXEC_CONFIGFILE_HELP','CONFIGFILE_INTRO');

Function SingleLineStringToDOSBoxLangString(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  if Trim(result)='' then exit;

  For I:=Low(SpecialChars) to High(SpecialChars) do
    result:=Replace(result, SpecialSymbols[I], Char(SpecialChars[I]));
end;

Function StringToDOSBoxLangString(const S : String) : String;
Var St : TStringList;
    I : Integer;
begin
  St:=TStringList.Create;
  try
    St.Text:=S;
    For I:=0 to St.Count-1 do St[I]:=SingleLineStringToDOSBoxLangString(St[I]);
    result:=St.Text;
  finally
    St.Free;
  end;
end;

Function SingleLineDOSBoxLangStringToString(const S : String) : String;
Var T : String;
    I : Integer;
begin
  result:=S;
  if Trim(result)='' then exit;

  For I:=Low(SpecialChars) to High(SpecialChars) do result:=Replace(result,SpecialChars[I],SpecialSymbols[I]);
  result:=T;
end;

Function DOSBoxLangStringToString(const S : String) : String;
Var St : TStringList;
    I : Integer;
begin
  St:=TStringList.Create;
  try
    St.Text:=S;
    For I:=0 to St.Count-1 do St[I]:=SingleLineDOSBoxLangStringToString(St[I]);
    result:=St.Text;
  finally
    St.Free;
  end;
end;

Function LoadDOSBoxLangFile(const FileName : String; const LangIDStrings, LangValueStrings : TStringList) : Boolean;
Var St : TStringList;
    I,J : Integer;
    TempID, TempValue,S : String;
    B : Boolean;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  St:=TStringList.Create;
  try
    try St.LoadFromFile(FileName); except exit; end;
    TempID:=''; TempValue:='';
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      If (S<>'') and (S[1]=':') then begin
        If Trim(TempID)<>'' then begin
          LangIDStrings.Add(TempID);
          LangValueStrings.Add(TempValue);
        end;
        TempID:=Copy(S,2,MaxInt); TempValue:='';
      end else begin
        If TempValue<>'' then begin
          If TempValue=' ' then TempValue:=#13 else TempValue:=TempValue+#13;
        end;
        If (St[I]='') and (TempValue='') then TempValue:=' ' else TempValue:=TempValue+St[I];
      end;
    end;
    If TempID<>'' then begin
      LangIDStrings.Add(TempID);
      LangValueStrings.Add(TempValue);
    end;
    result:=True;
  finally
    St.Free;
  end;

  For I:=0 to LangIDStrings.Count-1 do begin
    S:=Trim(ExtUpperCase(LangIDStrings[I]));
    B:=True; For J:=Low(NoConvert) to High(NoConvert) do If Copy(S,1,length(NoConvert[J]))=NoConvert[J] then begin B:=False; break; end;
    If B then LangValueStrings[I]:=DOSBoxLangStringToString(LangValueStrings[I]);
  end;
end;

Function SaveDOSBoxLangFile(const FileName : String; const LangIDStrings, LangValueStrings : TStringList) : Boolean;
Var St,St2,LangValueStrings2 : TStringList;
    I,J : Integer;
    S : String;
    B : Boolean;
begin
  LangValueStrings2:=TStringList.Create;
  try
    LangValueStrings2.AddStrings(LangValueStrings);

   For I:=0 to LangIDStrings.Count-1 do begin
      S:=Trim(ExtUpperCase(LangIDStrings[I]));
      B:=True; For J:=Low(NoConvert) to High(NoConvert) do If Copy(S,1,length(NoConvert[J]))=NoConvert[J] then begin B:=False; break; end;
      If B then LangValueStrings2[I]:=StringToDOSBoxLangString(LangValueStrings2[I]);
    end;

    result:=False;
    St:=TStringList.Create;
    try
      For I:=0 to Min(LangIDStrings.Count,LangValueStrings2.Count)-1 do begin
        St.Add(':'+LangIDStrings[I]);
        St2:=TStringList.Create;
        try
          St2.Text:=LangValueStrings2[I];
          While (St2.Count>0) and (Trim(St2[St2.Count-1])='') do St2.Delete(St2.Count-1);
          St.AddStrings(St2);
        finally
          St2.Free;
        end;
      end;
      try St.SaveToFile(FileName); except exit; end;
      result:=True;
    finally
      St.Free;
    end;
  finally
    LangValueStrings2.Free;
  end;
end;

Procedure FindAndAddLngFiles(const Dir : String; const St, St2 : TStrings);
Var Rec : TSearchRec;
    I,J : Integer;
    B : Boolean;
    S : String;
begin
  I:=FindFirst(Dir+'*.lng',faAnyFile,Rec);
  try
    while I=0 do begin
      B:=True;
      S:=Trim(ExtUpperCase(ChangeFileExt(Rec.Name,'')));
      For J:=0 to St.Count-1 do If Trim(ExtUpperCase(St[I]))=S then begin B:=False; break; end;
      If B then begin St.Add(ChangeFileExt(Rec.Name,'')); St2.Add(Dir+Rec.Name); end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure GetDOSBoxLangNamesAndFiles(const DOSBoxPath : String; const Names, Files : TStrings; const WithDefaultEnglish : Boolean);
Var I : Integer;
    St1, St2 : TStringList;
begin
  St1:=TStringList.Create;
  St2:=TStringList.Create;

  try
    If WithDefaultEnglish then begin
      St1.Add('English');
      St2.Add('');
    end;

    FindAndAddLngFiles(PrgDataDir+LanguageSubDir+'\',St1,St2);
    FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxPath),St1,St2);

    For I:=0 to St1.Count-1 do St1.Objects[I]:=TObject(I);
    St1.Sort;

    For I:=0 to St1.Count-1 do begin
      Names.Add(St1[I]);
      Files.Add(St2[Integer(St1.Objects[I])]);
    end;

  finally
    St1.Free;
    St2.Free;
  end;
end;

Function GetDOSBoxLangNames(const DOSBoxPath : String; const WithDefaultEnglish : Boolean) : TStringList;
Var Files : TStringList;
begin
  result:=TStringList.Create;
  Files:=TStringList.Create;
  try
    GetDOSBoxLangNamesAndFiles(DOSBoxPath,result,Files,WithDefaultEnglish);
  finally
    Files.Free;
  end;
end;

Function GetTempDOSBoxEnglishLangFile : String;
Var TempGame : TTempGame;
begin
  ForceDirectories(TempDir+TempSubFolder+'\');
  result:=TempDir+TempSubFolder+'\DOSBox-English.lng';
  TempGame:=TTempGame.Create;
  try
    TempGame.SetSimpleDefaults;
    TempGame.Game.CloseDosBoxAfterGameExit:=True;
    TempGame.Game.CustomDOSBoxLanguage:='ENGLISH';
    TempGame.Game.StoreAllValues;
    RunCommandAndWait(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'CONFIG -writelang "'+result+'"'+#13+'exit',true);
  finally
    TempGame.Free;
  end;
end;

end.
