unit ResHookUnit;
interface

uses Consts;

type
  TMenuKeyCap = (mkcBkSp, mkcTab, mkcEsc, mkcEnter, mkcSpace, mkcPgUp,
    mkcPgDn, mkcEnd, mkcHome, mkcLeft, mkcUp, mkcRight, mkcDown, mkcIns,
    mkcDel, mkcShift, mkcCtrl, mkcAlt);

var
  MenuKeyCaps: array[TMenuKeyCap] of string = (
    SmkcBkSp, SmkcTab, SmkcEsc, SmkcEnter, SmkcSpace, SmkcPgUp,
    SmkcPgDn, SmkcEnd, SmkcHome, SmkcLeft, SmkcUp, SmkcRight,
    SmkcDown, SmkcIns, SmkcDel, SmkcShift, SmkcCtrl, SmkcAlt);

Var
  MsgDlgWarning : String = 'Warnung';
  MsgDlgError : String = 'Fehler';
  MsgDlgInformation : String = 'Informationen';
  MsgDlgConfirm : String = 'Bestätigen';
  MsgDlgYes : String = '&Ja';
  MsgDlgNo : String = '&Nein';
  MsgDlgOK : String = 'OK';
  MsgDlgCancel : String = 'Abbrechen';
  MsgDlgAbort : String = '&Abbrechen';
  MsgDlgRetry : String = '&Wiederholen';
  MsgDlgIgnore : String = '&Ignorieren';
  MsgDlgAll : String = '&Alle';
  MsgDlgNoToAll : String = '&Alle Nein';
  MsgDlgYesToAll : String = 'A&lle Ja';

implementation

uses SysUtils, Classes, Windows, Menus, IdGlobal, IdGlobalProtocols, IdException;

{ RTL patching system }

type
  PJump = ^TJump;
  TJump = packed record
    OpCode: Byte;
    Distance: Pointer;
  end;

procedure AddressPatch(const ASource, ADestination: Pointer);
const
  Size = SizeOf(TJump);
var
  NewJump: PJump;
  OldProtect: Cardinal;
begin
  if VirtualProtect(ASource, Size, PAGE_EXECUTE_READWRITE, OldProtect) then
  begin
    NewJump := PJump(ASource);
    NewJump.OpCode := $E9;
    NewJump.Distance := Pointer(Integer(ADestination) - Integer(ASource) - 5);

    FlushInstructionCache(GetCurrentProcess, ASource, SizeOf(TJump));
    VirtualProtect(ASource, Size, OldProtect, @OldProtect);
  end;
end;

{ New version of "ShortCutToText" }

function GetSpecialName(ShortCut: TShortCut): string;
var
  ScanCode: Integer;
  KeyName: array[0..255] of Char;
begin
  Result := '';
  ScanCode := MapVirtualKey(WordRec(ShortCut).Lo, 0) shl 16;
  if ScanCode <> 0 then
  begin
    GetKeyNameText(ScanCode, KeyName, SizeOf(KeyName));
    GetSpecialName := KeyName;
  end;
end;

function NewShortCutToText(ShortCut: TShortCut): string;
var
  Name: string;
begin
  case WordRec(ShortCut).Lo of
    $08, $09:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcBkSp) + WordRec(ShortCut).Lo - $08)];
    $0D: Name := MenuKeyCaps[mkcEnter];
    $1B: Name := MenuKeyCaps[mkcEsc];
    $20..$28:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcSpace) + WordRec(ShortCut).Lo - $20)];
    $2D..$2E:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcIns) + WordRec(ShortCut).Lo - $2D)];
    $30..$39: Name := Chr(WordRec(ShortCut).Lo - $30 + Ord('0'));
    $41..$5A: Name := Chr(WordRec(ShortCut).Lo - $41 + Ord('A'));
    $60..$69: Name := Chr(WordRec(ShortCut).Lo - $60 + Ord('0'));
    $70..$87: Name := 'F' + IntToStr(WordRec(ShortCut).Lo - $6F);
  else
    Name := GetSpecialName(ShortCut);
  end;
  if Name <> '' then
  begin
    Result := '';
    if ShortCut and scShift <> 0 then Result := Result + MenuKeyCaps[mkcShift];
    if ShortCut and scCtrl <> 0 then Result := Result + MenuKeyCaps[mkcCtrl];
    if ShortCut and scAlt <> 0 then Result := Result + MenuKeyCaps[mkcAlt];
    Result := Result + Name;
  end
  else Result := '';
end;

Type TLoadResStringMode = (lrsmLearning, lrsmNormal);

Var LoadResStringMode : TLoadResStringMode;

Var NrMsgDlgWarning, NrMsgDlgError, NrMsgDlgInformation, NrMsgDlgConfirm, NrMsgDlgYes,
    NrMsgDlgNo, NrMsgDlgOK, NrMsgDlgCancel, NrMsgDlgAbort, NrMsgDlgRetry, NrMsgDlgIgnore,
    NrMsgDlgAll, NrMsgDlgNoToAll, NrMsgDlgYesToAll : Integer;

Var Nr : Integer;

{ New version of "LoadResString" }

function NewLoadResString(ResStringRec: PResStringRec): string;
var Buffer: array [0..4095] of char;
begin
  if ResStringRec=nil then begin result:=''; exit; end;

  if ResStringRec.Identifier>=64*1024 then begin
    Result:=PChar(ResStringRec.Identifier);
    exit;
  end;

  If LoadResStringMode=lrsmLearning then begin
    Case Nr of
      0 : NrMsgDlgWarning:=ResStringRec.Identifier;
      1 : NrMsgDlgError:=ResStringRec.Identifier;
      2 : NrMsgDlgInformation:=ResStringRec.Identifier;
      3 : NrMsgDlgConfirm:=ResStringRec.Identifier;
      4 : NrMsgDlgYes:=ResStringRec.Identifier;
      5 : NrMsgDlgNo:=ResStringRec.Identifier;
      6 : NrMsgDlgOK:=ResStringRec.Identifier;
      7 : NrMsgDlgCancel:=ResStringRec.Identifier;
      8 : NrMsgDlgAbort:=ResStringRec.Identifier;
      9 : NrMsgDlgRetry:=ResStringRec.Identifier;
     10 : NrMsgDlgIgnore:=ResStringRec.Identifier;
     11 : NrMsgDlgAll:=ResStringRec.Identifier;
     12 : NrMsgDlgNoToAll:=ResStringRec.Identifier;
     13 : NrMsgDlgYesToAll:=ResStringRec.Identifier;
    end;
    SetString(Result, Buffer, LoadString(FindResourceHInstance(ResStringRec.Module^), ResStringRec.Identifier, Buffer, SizeOf(Buffer)));
    exit;
  end;

  If ResStringRec.Identifier=NrMsgDlgWarning then begin result:=MsgDlgWarning; exit; end;
  If ResStringRec.Identifier=NrMsgDlgError then begin result:=MsgDlgError; exit; end;
  If ResStringRec.Identifier=NrMsgDlgInformation then begin result:=MsgDlgInformation; exit; end;
  If ResStringRec.Identifier=NrMsgDlgConfirm then begin result:=MsgDlgConfirm; exit; end;
  If ResStringRec.Identifier=NrMsgDlgYes then begin result:=MsgDlgYes; exit; end;
  If ResStringRec.Identifier=NrMsgDlgNo then begin result:=MsgDlgNo; exit; end;
  If ResStringRec.Identifier=NrMsgDlgOK then begin result:=MsgDlgOK; exit; end;
  If ResStringRec.Identifier=NrMsgDlgCancel then begin result:=MsgDlgCancel; exit; end;
  If ResStringRec.Identifier=NrMsgDlgAbort then begin result:=MsgDlgAbort; exit; end;
  If ResStringRec.Identifier=NrMsgDlgRetry then begin result:=MsgDlgRetry; exit; end;
  If ResStringRec.Identifier=NrMsgDlgIgnore then begin result:=MsgDlgIgnore; exit; end;
  If ResStringRec.Identifier=NrMsgDlgAll then begin result:=MsgDlgAll; exit; end;
  If ResStringRec.Identifier=NrMsgDlgNoToAll then begin result:=MsgDlgNoToAll; exit; end;
  If ResStringRec.Identifier=NrMsgDlgYesToAll then begin result:=MsgDlgYesToAll; exit; end;

  SetString(Result, Buffer, LoadString(FindResourceHInstance(ResStringRec.Module^), ResStringRec.Identifier, Buffer, SizeOf(Buffer)));
end;

{New versions of functions from IdGlobalProtocols}

function StrToMonth(const AMonth: string): Byte;
begin
  Result := Succ(PosInStrArray(Uppercase(AMonth),
    ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']));   {do not localize}
end;

function StrToDay(const ADay: string): Byte;
begin
  Result := Succ(PosInStrArray(Uppercase(ADay),
    ['SUN','MON','TUE','WED','THU','FRI','SAT']));   {do not localize}
end;

function NewRawStrInternetToDateTime(var Value: string): TDateTime;
var
  i: Integer;
  Dt, Mo, Yr, Ho, Min, Sec: Word;
  sTime: String;
  ADelim: string;
  SaveValue : String;

  Procedure ParseDayOfMonth;
  begin
    Dt :=  StrToIntDef( Fetch(Value, ADelim), 1);
    Value := TrimLeft(Value);
  end;

  Procedure ParseMonth;
  begin
    Mo := StrToMonth( Fetch ( Value, ADelim )  );
    Value := TrimLeft(Value);
  end;
begin

  If Pos('/',Value)>0 Then
  Begin
    { Turn Invalid 'Value' Into Valid. (Added by B Capel Feb 2005)
     Example: 26/02/2005 19:23:30>>Becomes>>Sat, 26 Feb 2005 13:36:42}
    Value := FormatDateTime('ddd, dd mmm yyyy hh:nn:ss',StrToDateTime(Value));
  End;

  Result := 0.0;
  Value := Trim(Value);
  if Length(Value) = 0 then begin
    Exit;
  end;

  try
    {Day of Week}
    if StrToDay(Copy(Value, 1, 3)) > 0 then begin
      {workaround in case a space is missing after the initial column}
      if (Copy(Value,4,1)=',') and (Copy(Value,5,1)<>' ') then
      begin
        System.Insert(' ',Value,5);
      end;
      Fetch(Value);
      Value := TrimLeft(Value);
    end;

    { Workaround for some buggy web servers which use '-' to separate the date parts.    {Do not Localize}
    if (IndyPos('-', Value) > 1) and (IndyPos('-', Value) < IndyPos(' ', Value)) then begin    {Do not Localize}
      ADelim := '-';    {Do not Localize}
    end
    else begin
      ADelim := ' ';    {Do not Localize}
    end;
    {workaround for improper dates such as 'Fri, Sep 7 2001'    {Do not Localize}
    {RFC 2822 states that they should be like 'Fri, 7 Sep 2001'    {Do not Localize}
    if (StrToMonth(Fetch(Value, ADelim,False)) > 0) then
    begin
      {Month}
      ParseMonth;
      {Day of Month}
      ParseDayOfMonth;
    end
    else
    begin
      {Day of Month}
      ParseDayOfMonth;
      {Month}
      SaveValue:=Value;
      ParseMonth;
      If Mo=0 then begin
        Value:=SaveValue;
        ADelim := '-';
        ParseDayOfMonth;
        ParseMonth;
      end;
    end;
    {Year}
    { There is sometrage date/time formats like
     DayOfWeek Month DayOfMonth Time Year}

    sTime := Fetch(Value);
    Yr := StrToIntDef(sTime, 1900);
    { Is sTime valid Integer}
    if Yr = 1900 then begin
      Yr := StrToIntDef(Value, 1900);
      Value := sTime;
    end;
    if Yr < 80 then begin
      Inc(Yr, 2000);
    end else if Yr < 100 then begin
      Inc(Yr, 1900);
    end;

    Result := EncodeDate(Yr, Mo, Dt);
    { SG 26/9/00: Changed so that ANY time format is accepted}
    i := IndyPos(':', Value); {do not localize}
    if i > 0 then begin
      {Copy time string up until next space (before GMT offset)
      sTime := fetch(Value, ' ');  {do not localize}
      {Hour}
      Ho  := StrToIntDef( Fetch ( Value,':'), 0);  {do not localize}
      {Minute}
      Min := StrToIntDef( Fetch ( Value,':'), 0);  {do not localize}
      {Second}
      Sec := StrToIntDef( Fetch ( Value ), 0);
      {The date and time stamp returned}
      Result := Result + EncodeTime(Ho, Min, Sec, 0);
    end;
    Value := TrimLeft(Value);
  except
    Result := 0.0;
  end;
end;

function NewStrInternetToDateTime(Value: string): TDateTime;
begin
  Result := NewRawStrInternetToDateTime(Value);
end;

function GmtOffsetStrToDateTime(S: string): TDateTime;
begin
  Result := 0.0;
  S := Copy(Trim(s), 1, 5);
  if Length(S) > 0 then
  begin
    if s[1] in ['-', '+'] then   {do not localize}
    begin
      try
        Result := EncodeTime(StrToInt(Copy(s, 2, 2)), StrToInt(Copy(s, 4, 2)), 0, 0);
        if s[1] = '-' then  {do not localize}
        begin
          Result := -Result;
        end;
      except
        Result := 0.0;
      end;
    end;
  end;
end;

function OffsetFromUTC: TDateTime;
var
  iBias: Integer;
  tmez: TTimeZoneInformation;
begin
  Case GetTimeZoneInformation(tmez) of
    TIME_ZONE_ID_INVALID:
      raise EIdFailedToRetreiveTimeZoneInfo.Create('RSFailedTimeZoneInfo');
    TIME_ZONE_ID_UNKNOWN  :
       iBias := tmez.Bias;
    TIME_ZONE_ID_DAYLIGHT :
      iBias := tmez.Bias + tmez.DaylightBias;
    TIME_ZONE_ID_STANDARD :
      iBias := tmez.Bias + tmez.StandardBias;
    else
      raise EIdFailedToRetreiveTimeZoneInfo.Create('RSFailedTimeZoneInfo');
  end;
  {We use ABS because EncodeTime will only accept positve values}
  Result := EncodeTime(Abs(iBias) div 60, Abs(iBias) mod 60, 0, 0);
  {The GetTimeZone function returns values oriented towards convertin
   a GMT time into a local time.  We wish to do the do the opposit by returning
   the difference between the local time and GMT.  So I just make a positive
   value negative and leave a negative value as positive}
  if iBias > 0 then begin
    Result := 0 - Result;
  end;
end;

function NewGMTToLocalDateTime(S: string): TDateTime;
var  {-Always returns date/time relative to GMT!!  -Replaces StrInternetToDateTime}
  DateTimeOffset: TDateTime;
begin
  try
    If length(S)<10 then result:=Now else Result:=NewRawStrInternetToDateTime(S);
  except
    result:=Now;
  end;
  if Length(S) < 5 then begin
    DateTimeOffset := 0.0
  end else begin
    DateTimeOffset := GmtOffsetStrToDateTime(S);
  end;
  {-Apply GMT offset here}
  if DateTimeOffset < 0.0 then begin
    Result := Result + Abs(DateTimeOffset);
  end else begin
    Result := Result - DateTimeOffset;
  end;
  { Apply local offset}
  Result := Result + OffSetFromUTC;
end;


Var S : String;
initialization
  AddressPatch(@IdGlobalProtocols.GMTToLocalDateTime,@NewGMTToLocalDateTime);

  AddressPatch(@Menus.ShortCutToText,@NewShortCutToText);

  LoadResStringMode:=lrsmLearning;
  AddressPatch(@System.LoadResString,@NewLoadResString);
  {$O-}
  Nr:=0; S:=SMsgDlgWarning;
  Nr:=1; S:=SMsgDlgError;
  Nr:=2; S:=SMsgDlgInformation;
  Nr:=3; S:=SMsgDlgConfirm;
  Nr:=4; S:=SMsgDlgYes;
  Nr:=5; S:=SMsgDlgNo;
  Nr:=6; S:=SMsgDlgOK;
  Nr:=7; S:=SMsgDlgCancel;
  Nr:=8; S:=SMsgDlgAbort;
  Nr:=9; S:=SMsgDlgRetry;
  Nr:=10; S:=SMsgDlgIgnore;
  Nr:=11; S:=SMsgDlgAll;
  Nr:=12; S:=SMsgDlgNoToAll;
  Nr:=13; S:=SMsgDlgYesToAll;
  LoadResStringMode:=lrsmNormal;
end.
