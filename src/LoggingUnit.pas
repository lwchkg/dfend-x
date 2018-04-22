unit LoggingUnit;
interface

Procedure LogInfo(const Info : String; const ContinueLogging : Boolean = True);

implementation

uses SysUtils, Forms, ShlObj, CommonTools;

var StartupLogFile : String ='';

Procedure LogInfo(const Info : String; const ContinueLogging : Boolean);
Var F : TextFile;
begin
  If StartupLogFile='' then exit;
  If not FileExists(StartupLogFile) then begin StartupLogFile:=''; exit; end;

  AssignFile(F,StartupLogFile);
  Append(F);
  try
    Writeln(F,TimeToStr(Now)+' '+Info);
  finally
    CloseFile(F);
  end;
  If not ContinueLogging then StartupLogFile:='';
end;

initialization
  StartupLogFile:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_DESKTOPDIRECTORY))+'D-Fend-Reloaded-Log.txt';
  if not FileExists(StartupLogFile) then StartupLogFile:='';
end.
