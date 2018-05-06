unit HelpTools;
interface

{
Usage:

Function InitHTMLHelp(const HelpFileName : String) : THTMLhelpRouter;
}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus;

const
   cVersion = '2.02';

   HH_DISPLAY_TOPIC        = $0000;
   HH_HELP_FINDER          = $0000;  { WinHelp equivalent }
   HH_DISPLAY_TOC          = $0001;  { not currently implemented }
   HH_DISPLAY_INDEX        = $0002;  { not currently implemented }
   HH_DISPLAY_SEARCH       = $0003;  { not currently implemented }
   HH_SET_WIN_TYPE         = $0004;
   HH_GET_WIN_TYPE         = $0005;
   HH_GET_WIN_HANDLE       = $0006;
   HH_ENUM_INFO_TYPE       = $0007;
   HH_SET_INFO_TYPE        = $0008;
   HH_SYNC                 = $0009;
   HH_RESERVED1            = $000A;
   HH_RESERVED2            = $000B;
   HH_RESERVED3            = $000C;
   HH_KEYWORD_LOOKUP       = $000D;
   HH_DISPLAY_TEXT_POPUP   = $000E;
   HH_HELP_CONTEXT         = $000F;
   HH_TP_HELP_CONTEXTMENU  = $0010;
   HH_TP_HELP_WM_HELP      = $0011;
   HH_CLOSE_ALL            = $0012;
   HH_ALINK_LOOKUP         = $0013;
   HH_GET_LAST_ERROR       = $0014;
   HH_ENUM_CATEGORY        = $0015;
   HH_ENUM_CATEGORY_IT     = $0016;
   HH_RESET_IT_FILTER      = $0017;
   HH_SET_INCLUSIVE_FILTER = $0018;
   HH_SET_EXCLUSIVE_FILTER = $0019;
   HH_INITIALIZE           = $001C;
   HH_UNINITIALIZE         = $001D;
   HH_PRETRANSLATEMESSAGE  = $00fd;
   HH_SET_GLOBAL_PROPERTY  = $00fc;

type
   THH_POPUP = record
      cbStruct: integer;
      hinst: THandle;
      idString: cardinal;
      pszText: PChar;
      pt: TPoint;
      clrForeground: TColor;
      clrBackground: TColor;
      rcMargins: TRect;
      pszFont: PChar;
   end;

type
   THH_AKLINK = record
      cbStruct: integer;
      fReserved: boolean;
      pszKeywords: Pchar;
      pszUrl: Pchar;
      pszMsgText: PChar;
      pszMsgTitle: PChar;
      pszMsgWindow: PChar;
      fIndexOnFail: boolean;
   end;

type
  THelpType = (htAuto, htWinhelp, htHTMLhelp);
  TShowType = (stDefault, stMain, stPopup);

  EOwnerError = class(Exception);

  THTMLhelpRouter = class(TComponent)
  private
    fHelpType: THelpType;
    fShowType: TShowType;
    fAppOnHelp: THelpEvent;
    fOnHelp: THelpEvent;
    fHelpfile: string;
    function CurrentForm: TForm;
    function FindHandle(var Helphandle: HWND; var hfile: string): boolean;
    procedure SetHelpType(value: THelpType);
    function GetVersion: string;
    procedure SetVersion(dummy: string);
    function OnRouteHelp(Command: Word; Data: THelpEventData; var CallHelp: Boolean): Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function HTMLhelpInstalled: boolean;
    function HelpContent: boolean;
    function HelpKeyword(keyword: string): boolean;
    function HelpKLink(keyword: string): boolean;
    function HelpALink(akeyword: string): boolean;
    function HelpJump(hfile, topicid: string): boolean;
    function HelpPopup(X,Y: integer; text: string): boolean;
  published
    property HelpType: THelpType read fHelpType write SetHelpType;
    property ShowType: TShowType read fShowType write fShowType default stDefault;
    property Helpfile: string read fHelpfile write fHelpfile;
    property OnHelp: THelpEvent read fOnHelp write fOnHelp;
    property Version: string read GetVersion write SetVersion;
  end;

type
   THtmlHelpA = function(hwndCaller: THandle; pszFile: PChar; uCommand: cardinal; dwData: longint): THandle; stdCall;

var
   HtmlHelpA: THtmlHelpA;
   HHCTRL: THandle;
   GLOBAL_HELPROUTER: THTMLhelpRouter;

function LoadHHCTRL: boolean;

Function InitHTMLHelp(const HelpFileName : String) : THTMLhelpRouter;

procedure Register;

implementation

{$HINTS off}
{$WARNINGS off}

function LoadHHCTRL: boolean;
begin
  if HHCTRL = 0 then
  begin
    HtmlHelpA := nil;
    HHCTRL := LoadLibrary('HHCTRL.OCX');
    if (HHCTRL <> 0) then HtmlHelpA := GetProcAddress(HHCTRL, 'HtmlHelpA');
  end;
  result := HHCTRL <> 0;
end;

function CheckRouterInstance: boolean;
begin
  result := True;
  if GLOBAL_HELPROUTER <> NIL then raise Exception.Create('Multiple instances of THTMLhelpRouter are not allowed');
end;

{ --- THTMLhelpRouter --- }

constructor THTMLhelpRouter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if CheckRouterInstance and not (csDesigning in Componentstate) then
  begin
       fAppOnHelp := Application.OnHelp;
       Application.OnHelp := OnRouteHelp;
       GLOBAL_HELPROUTER := Self;
  end;
  fShowType := stDefault;
end;

destructor THTMLhelpRouter.Destroy;
begin
  if not (csDesigning in Componentstate) then if assigned(fAppOnHelp) then Application.onhelp := fAppOnHelp else Application.onhelp := nil;
  GLOBAL_HELPROUTER := nil;
  inherited Destroy;
end;

function THTMLhelpRouter.CurrentForm: TForm;
begin
  if Screen.ActiveForm <> NIL then
       Result:= Screen.ActiveForm
  else Result:= Owner as TForm;
end;

procedure THTMLhelpRouter.SetHelpType(value: THelpType);
begin
     if value <> fHelpType then
     begin
          fHelpType := value;
          if fHelpType in [htAuto,htHTMLhelp] then LoadHHCTRL;
     end;
end;

function THTMLhelpRouter.HTMLhelpInstalled: boolean;
begin
  if HHCTRL = 0 then LoadHHCTRL;
  result := assigned(HtmlHelpA);
end;

function THTMLhelpRouter.FindHandle(var Helphandle: HWND; var Hfile: string): boolean;
var
   CForm: TForm;
begin
   case HelpType of
      htWinhelp:  result := false;
      htHTMLhelp: result := true;
      htAuto:     result := HTMLhelpInstalled;
   end;
   HFile := Application.helpfile;
   HelpHandle := Application.handle;
{IFDEF VER100}
   CForm := CurrentForm;
   if Assigned(CForm) and CForm.HandleAllocated and (CForm.HelpFile <> '') then
   begin
       HelpHandle := CForm.Handle;
       HFile := CForm.HelpFile;
   end;
{ENDIF}
   if fHelpFile <> '' then
   begin
       HFile := fhelpfile;
       HelpHandle := Application.handle;
   end;
end;

function THTMLhelpRouter.OnRouteHelp(Command: Word; Data: THelpEventData; var CallHelp: Boolean): Boolean;
var
   showHTML: boolean;
   rHandle: integer;
   HelpHandle: HWND;
   HFile: string;
begin
   result := false;

   if assigned(fOnHelp) then result := fOnHelp(command, data, callhelp);
   if not callHelp then exit;
   if assigned(fAppOnHelp) then result := fAppOnHelp(command, data, callhelp);
   if not callHelp then exit;

   showHTML := FindHandle(HelpHandle, HFile);

   result := false;
   if showHTML then
   begin
     rHandle := 0;
     HFile := changefileext(Hfile,'.chm');
     case Command of
     HELP_FINDER, HELP_CONTENTS: rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_DISPLAY_TOC, 0);  {show table of contents}
     HELP_KEY: rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_DISPLAY_INDEX, data);  {display keywordshow table of contens}
     HELP_QUIT: rHandle := HtmlHelpA(helphandle, nil, HH_CLOSE_ALL, 0);
     HELP_CONTEXT: rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_HELP_CONTEXT, data);  {display help context}
     HELP_CONTEXTPOPUP: rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_HELP_CONTEXT, data);
     end;
     Result := rHandle <> 0;
   end;
   if (not result) and (fHelpType <> htHTMLhelp) then
   begin
     case Command of
     HELP_SETPOPUP_POS: if fShowType = stMain then Command := 0;
     HELP_CONTEXTPOPUP: if fShowType = stMain then Command := HELP_CONTEXT; {no popup}
     end;
     if Command <> 0 then Result := WinHelp(HelpHandle, PChar(changefileext(HFile,'.hlp')), Command, Data)
     else Result := true;
   end;
   CallHelp := false;
end;

function THTMLhelpRouter.HelpContent: boolean;
begin
   result := application.helpcommand(HELP_FINDER, 0);
end;

function THTMLhelpRouter.HelpJump(hfile, topicid: string): boolean;
var
   Command: array[0..255] of Char;
   showHTML: boolean;
   rHandle: integer;
   HelpHandle: HWND;
   HF, HID: string;
begin
   result := false;
   showHTML := FindHandle(HelpHandle, HF);

   if Hfile <> '' then
   begin
        HF := HFile;
        HelpHandle := 0;
   end;
   if showHTML then
   begin
     {rHandle := 0;}
     HFile := changefileext(HF,'.chm');
     HID := TopicID;
     if copy(lowercase(extractfileext(HID)),1,4) <> '.htm' then HID := HID + '.htm';
     rHandle := HtmlHelpA(helphandle, pchar(Hfile+'::/'+HID), HH_DISPLAY_TOPIC, 0);  {show table of contents}
     Result := rHandle <> 0;
   end;
   if (not result) and (fHelpType <> htHTMLhelp) then
   begin
     hfile := changefileext(HF,'.hlp');
     StrLFmt(Command, SizeOf(Command) - 1, 'JumpID("","%s")', [TopicID]);
     Result := WinHelp(HelpHandle, PChar(Hfile), HELP_CONTENTS, 0);
     if Result then Result := WinHelp(HelpHandle, PChar(hfile), HELP_COMMAND, Longint(@Command));
   end;
end;

function THTMLhelpRouter.HelpPopup(X,Y: integer; text: string): boolean;
var
   CForm: TForm;
   HP: THH_Popup;
begin
   if (fHelpType <> htWinhelp) and HTMLhelpInstalled then
   begin
     CForm := CurrentForm;
     with HP do
     begin
          cbStruct := sizeof(HP);
          hInstance := 0;
          idString := 0;
          pszText := PChar(text);
          pt.x := X;
          pt.y := Y;
          ClientToScreen(CForm.handle, pt);
          clrForeground := -1;
          clrBackground := -1;
          rcMargins.Left := -1;
          rcMargins.Right := -1;
          rcMargins.Top := -1;
          rcMargins.Bottom := -1;
          pszFont := PChar('MS Sans Serif, 10');
     end;
     result := HtmlHelpA(CForm.handle, nil, HH_DISPLAY_TEXT_POPUP, longint(@HP)) <> 0;
   end
   else result := false;
end;

function THTMLhelpRouter.HelpKeyword(keyword: string): boolean;
var
  Command: array[0..255] of Char;
begin
  StrLcopy(Command, pchar(keyword), SizeOf(Command) - 1);
  result := application.helpcommand(HELP_KEY, Longint(@Command));
end;

function THTMLhelpRouter.HelpKLink(keyword: string): boolean;
var
   Command: array[0..255] of Char;
   showHTML: boolean;
   rHandle: integer;
   HelpHandle: HWND;
   HF, Hfile: string;
   HA: THH_AKLINK;
begin
   result := false;
   showHTML := FindHandle(HelpHandle, HF);

   if showHTML then
   begin
     {rHandle := 0;}
     HFile := changefileext(HF,'.chm');

     with HA do
     begin
          cbStruct := sizeof(HA);
          fReserved := false;
          pszKeywords := pchar(keyword);
          pszUrl := '';
          pszMsgText := '';
          pszMsgTitle := '';
          pszMsgWindow := '';
          fIndexOnFail := true;
     end;
     rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_DISPLAY_TOPIC, 0);  {create window}
     if rHandle <> 0 then rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_KEYWORD_LOOKUP, longint(@HA));
     Result := rHandle <> 0;
   end;
   if (not result) and (fHelpType <> htHTMLhelp) then
   begin
     helpfile := changefileext(HF,'.hlp');
     StrLFmt(Command, SizeOf(Command) - 1, 'KL("%s",1)', [keyword]);
     Result := WinHelp(HelpHandle, PChar(Hfile), HELP_CONTENTS, 0);
     if Result then Result := WinHelp(HelpHandle, PChar(hfile), HELP_COMMAND, Longint(@Command));
   end;
end;

function THTMLhelpRouter.HelpALink(akeyword: string): boolean;
var
   Command: array[0..255] of Char;
   showHTML: boolean;
   rHandle: integer;
   HelpHandle: HWND;
   HF, Hfile: string;
   HA: THH_AKLINK;
begin
   result := false;
   showHTML := FindHandle(HelpHandle, HF);

   if showHTML then
   begin
     {rHandle := 0;}
     HFile := changefileext(HF,'.chm');

     with HA do
     begin
          cbStruct := sizeof(HA);
          fReserved := false;
          pszKeywords := pchar(akeyword);
          pszUrl := '';
          pszMsgText := '';
          pszMsgTitle := '';
          pszMsgWindow := '';
          fIndexOnFail := true;
     end;
     rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_DISPLAY_TOPIC, 0);  {create window}
     if rHandle <> 0 then rHandle := HtmlHelpA(helphandle, pchar(Hfile), HH_ALINK_LOOKUP, longint(@HA));
     Result := rHandle <> 0;
   end;
   if (not result) and (fHelpType <> htHTMLhelp) then
   begin
     hfile := changefileext(HF,'.hlp');
     StrLFmt(Command, SizeOf(Command) - 1, 'AL("%s",1)', [akeyword]);
     Result := WinHelp(HelpHandle, PChar(Hfile), HELP_CONTENTS, 0);
     if Result then Result := WinHelp(HelpHandle, PChar(hfile), HELP_COMMAND, Longint(@Command));
   end;
end;

function THTMLhelpRouter.GetVersion: string;
begin
     result := cVersion;
end;
procedure THTMLhelpRouter.SetVersion(dummy: string);
begin
  {do nothing}
end;

procedure Register;
begin
  RegisterComponents('EC', [THTMLhelpRouter]);
end;

{$HINTS on}
{$WARNINGS on}

Function InitHTMLHelp(const HelpFileName : String) : THTMLhelpRouter;
begin
  result:=THTMLHelpRouter.Create(Application.MainForm);
  result.Helpfile:=HelpFileName;
  Application.HelpFile:='';
end;

initialization
  HHCTRL := 0;
finalization
   if (HHCTRL <> 0) then FreeLibrary(HHCTRL);
end.
