unit MIDITools;
interface

uses Classes;

Function GetMIDIDevices : TStringList;
Function MakeDOSBoxMIDIString(const ProfileString : String) : String;

implementation

uses SysUtils, LanguageSetupUnit, DOSBoxTempUnit, DOSBoxUnit, CommonTools,
     MainUnit;

Procedure ProcessMIDIInfoLine(const Line : String; const List : TStringList);
Var I : Integer;
    S,T : String;
begin
  I:=Pos(' ',Line); If I=0 then exit;
  S:=Trim(Copy(Line,1,I-1)); T:=Trim(Copy(Line,I+1,MaxInt));
  If not TryStrToInt(S,I) then exit;
  If (T<>'') and (T[1]='"') and (T[length(T)]='"') then T:=Trim(Copy(T,2,length(T)-2));
  List.AddObject(T+' ('+LanguageSetup.ProfileEditorSoundMIDIConfigID+'='+IntToStr(I)+')',TObject(I));
end;

Function GetMIDIDevices : TStringList;
const MIDIListFile='DFR-MIDI.TMP';
Var TempGame : TTempGame;
    St : TStringList;
    S : String;
    I : Integer;
begin
  result:=TStringList.Create;
  TempGame:=TTempGame.Create;
  try
    TempGame.Game.NrOfMounts:=1;
    TempGame.Game.Mount0:=TempDir+';DRIVE;C;False;;';
    St:=TStringList.Create;
    try
      St.Add('mixer /LISTMIDI > C:\'+MIDIListFile);
      St.Add('exit');
      TempGame.Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    TempGame.Game.StoreAllValues;
    RunCommandAndWait(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',True);
    St:=TStringList.Create;
    try
      try St.LoadFromFile(TempDir+MIDIListFile); except end;
      For I:=0 to St.Count-1 do begin
        S:=Trim(St[I]);
        If S='' then continue;
        ProcessMIDIInfoLine(S,result);
      end;
    finally
      St.Free;
    end;
    ExtDeleteFile(TempDir+MIDIListFile,ftTemp);
  finally
    TempGame.Free;
  end;
end;

Function MakeDOSBoxMIDIString(const ProfileString : String) : String;
Var S,T : String;
    I,J : Integer;
    St : TStringList;
begin
  result:='';
  S:=Trim(ProfileString);
  If S='' then exit;
  If TryStrToInt(S,I) then begin result:=S; exit; end;
  S:=ExtUpperCase(S);

  St:=GetMIDIDevices;
  try
    For I:=0 to St.Count-1 do begin
      T:=St[I];
      While (T<>'') and (T[length(T)]<>'(') do SetLength(T,length(T)-1);
      If (T<>'') then SetLength(T,length(T)-1);
      If ExtUpperCase(Trim(T))=S then begin
        T:=St[I];
        If (T<>'') then SetLength(T,length(T)-1);
        J:=Pos('=',T); While J>0 do begin T:=Copy(T,J+1,MaxInt); J:=Pos('=',T); end;
        If TryStrToInt(Trim(T),J) then begin result:=IntToStr(J); exit; end;
      end;
    end;
  finally
    St.Free;
  end;
end;

end.
