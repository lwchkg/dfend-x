program CheckLangFile;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  IniFiles;

Procedure Stopped(const S : String ='');
begin
  If S<>'' then writeln(S);
  writeln('Stopped. Press enter.');
  readln;
  halt;
end;

Procedure RepairLanguage(const DefaultFile, UserFile, NewFile : String; const Log : TStringList; var Warnings, Advices : Integer);
Var DefaultIni, UserIni, NewIni : TIniFile;
    Sections, Section : TStringList;
    I,J : Integer;
    S,T,U : String;
begin
  Warnings:=0; Advices:=0;

  DefaultIni:=nil; UserIni:=nil; NewIni:=nil; Sections:=nil; Section:=nil;
  try
    DefaultIni:=TIniFile.Create(DefaultFile);
    UserIni:=TIniFile.Create(UserFile);
    NewIni:=TIniFile.Create(NewFile);
    Sections:=TStringList.Create;
    Section:=TStringList.Create;

    DefaultIni.ReadSections(Sections);
    For I:=0 to Sections.Count-1 do begin
      Section.Clear;
      DefaultIni.ReadSection(Sections[I],Section);
      For J:=0 to Section.Count-1 do begin
        If UserIni.ValueExists(Sections[I],Section[J]) then begin
          S:=UserIni.ReadString(Sections[I],Section[J],'');
          NewIni.WriteString(Sections[I],Section[J],S);
          If DefaultIni.ReadString(Sections[I],Section[J],'')=S then begin
            T:=UpperCase(Sections[I]); U:=UpperCase(Section[J]);
            If (T='LANGUAGEFILEINFO') and (U='MAXVERSION') then continue;
            If (T='CHARSETSETTINGS') and (U='NAME') then continue;
            S:='ADVICE: Value equal to English version; section='+Sections[I]+' key='+Section[J]+' value='+S;
            writeln(S); Log.Add(S);
            inc(Advices);
          end;
        end else begin
          inc(Warnings);
          S:='WARNING: Needed key does not exist; section='+Sections[I]+' key='+Section[J];
          writeln(S); Log.Add(S);
          NewIni.WriteString(Sections[I],Section[J],DefaultIni.ReadString(Sections[I],Section[J],''));
        end;
      end;
    end;

    S:=DefaultIni.ReadString('LanguageFileInfo','MaxVersion','');
    T:=NewIni.ReadString('LanguageFileInfo','MaxVersion','');
    If S<>T then begin
      NewIni.WriteString('LanguageFileInfo','MaxVersion',S);
      inc(Warnings);
      S:='WARNING: MaxVersion in user language ('+T+') differs from MaxVersion in English.ini ('+S+'), fixed.';
      writeln(S); Log.Add(S);
    end;

  finally
    DefaultIni.Free;
    UserIni.Free;
    NewIni.Free;
    Section.Free;
    Sections.Free;
  end;
end;

Procedure AddEmptyLines(const FileName : String);
Var St : TStringList;
    I : Integer;
    S : String;
begin
  St:=THashedStringList.Create;
  try
    St.LoadFromFile(FileName);
    I:=0;
    While I<St.Count-1 do begin
      S:=St[I];
      If (S<>'') and (S[1]='[') and (I>0) and (St[I-1]<>'') then begin
        St.Insert(I,''); inc(I);
      end;
      inc(I);
    end;
    St.SaveToFile(FileName);
  finally
    St.Free;
  end;
end;

const DefaultFile='English.ini';

Var PrgDir, UserFile, NewFile, LogFile : String;
    Warnings, Advices : Integer;
    Log : TStringList;
begin
  try
    writeln('D-Fend Reloaded language file checker v.1.0');
    writeln('');

    PrgDir:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
    If not FileExists(PrgDir+'English.ini') then Stopped('File "'+PrgDir+DefaultFile+'" not found.');
    writeln('Enter input filename'); readln(UserFile);
    If not FileExists(PrgDir+UserFile) then Stopped('File "'+PrgDir+UserFile+'" not found.');
    NewFile:=ChangeFileExt(UserFile,'New.ini');
    LogFile:=ChangeFileExt(UserFile,'Log.txt');
    writeln('Working...');
    Log:=TStringList.Create;
    try
      RepairLanguage(PrgDir+DefaultFile,PrgDir+UserFile,PrgDir+NewFile,Log,Warnings,Advices);
      If Log.Count>0 then Log.SaveToFile(LogFile);
      AddEmptyLines(PrgDir+NewFile);
      writeln('Nice looking language file written to '+NewFile);
      If Log.Count>0 then writeln('Log lines written to '+LogFile);
      Stopped('Processing finished'+#13+#10+IntToStr(Warnings)+' warning(s) '+IntToStr(Advices)+' advice(s)');
    finally
      Log.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
