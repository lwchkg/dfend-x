unit SDUGeneral;
// Description: Sarah Dean's General Utils
// By Sarah Dean
// Email: sdean12@sdean12.org
// WWW:   http://www.SDean12.org/
//
// -----------------------------------------------------------------------------
//


interface

uses
  forms, controls, stdctrls,
  Windows, // Required for TWIN32FindData in ConvertSFNPartToLFN, and THandle
  classes,
  comctrls, // Required in SDUEnableControl to enable/disable TRichedit controls
  dialogs, // Required for SDUOpenSaveDialogSetup
  graphics, // Required for TFont
  ShlObj,  // Required for SHChangeNotify and SHGetSpecialFolderLocation
  ActiveX; // Required for IMalloc

type
  TInstalledOS = (
                  osWindows95,
                  osWindows98,
                  osWindowsMe,
                  osWindowsNT,
                  osWindows2000,
                  osWindowsXP,
                  osWindowsVista
                 );
  TCenterControl = (ccNone, ccVertical, ccHorizontal, ccBoth);

const
  SDUCRLF = #13+#10;

  UNITS_BYTES_DENOMINATINON: array [0..4] of string = ('bytes', 'KB', 'MB', 'GB', 'TB');
  UNITS_BYTES_MULTIPLIER = 1024;

  INSTALLED_OS_TITLE: array [TInstalledOS] of string = (
                                             'Windows 95',
                                             'Windows 98',
                                             'Windows Me',
                                             'Windows NT',
                                             'Windows 2000',
                                             'Windows XP',
                                             'Windows Vista'
                                            );
  SDU_CSIDL_PROGRAM_FILES = $0026;  // Version 5.0 and greater

// XOR the characters in two strings together
function SDUXOR(a: string; b: string): string;
// Draw a piechart on the specified canvas within specified bounds
procedure SDUSimplePieChart(
                            ACanvas: TCanvas;
                            Bounds: TRect;
                            Percent: integer;
                            ColourFg: TColor = clRed;
                            ColorBg: TColor = clGreen
                           );
// Calculate x! (factorial X)
function  SDUFactorial(x: integer): LARGE_INTEGER;
// Generate all permutations of the characters in "pool"
procedure SDUPermutate(pool: string; lst: TStringList);
// Center a control on it's parent
procedure SDUCenterControl(control: TControl; align: TCenterControl);
// double is to int as FloatTrunc(...) is to Trunc(...), but allows control as
// to the number of decimal places that truncation begins from
function SDUFloatTrunc(X: double; decimalPlaces: integer): double;
// Given an amount and the units the amount is to be displayed in, this
// function will pretty-print the value combined with the greatest denomination
// unit it can
// e.g. 2621440, [bytes, KB, MB, GB], and 1024 will give "2.5 MB"
// May be used with constant units declared in this Delphi unit
function SDUFormatUnits(
                     Value: int64;
                     denominations: array of string;
                     multiplier: integer = 1000;
                     accuracy: integer = 2
                    ): string;
// Convert boolean value to string/char
function SDUBoolToStr(value: boolean; strTrue: string = 'True'; strFalse: string = 'False'): string; overload;
function SDUBooleanToStr(value: boolean; strTrue: string = 'True'; strFalse: string = 'False'): string; overload;
function SDUBoolToChar(value: boolean; chars: string = 'TF'): char; overload;
function SDUBooleanToChar(value: boolean; chars: string = 'TF'): char; overload;
// Get the Windows directory
function SDUGetWindowsDirectory(): string;
// Get special directory.
// See CSIDL_DESKTOP, etc consts in ShlObj
function SDUGetSpecialFolderPath(const CSIDL: integer): string;
// Create a file of the specified size, filled with zeros
// Note: This will *fail* if the file already exists
// Returns TRUE on success, FALSE on failure
// If the file creation was cancelled by the user, this function will return
// FALSE, but set userCancelled to TRUE
(*
function SDUCreateLargeFile(
                            filename: string;
                            size: int64;
                            showProgress: boolean;
                            var userCancelled: boolean
                           ): boolean;
*)
// Convert the ASCII representation of binary data into binary data
// ASCIIrep - This must be set to a string containing the ASCII representation
//            of binary data (e.g. "DEADBEEF010203" as bytes $DE, $AD, $BE,
//            $EF, $01, $02, $03)
// Note: ASCIIrep **MUST** have an **even** number of hex chars
// Note: Whitespace in ASCIIrep is *ignored*
function SDUParseASCIIToData(ASCIIrep: string; var data: string): boolean;
// On a TPageControl, determine if the one tabsheet appears *after* another
// Returns TRUE if "aSheet" appears *after* bSheet
// Returns FALSE if "aSheet" appears *before* bSheet
// Returns FALSE if "aSheet" *is* "bSheet"
function SDUIsTabSheetAfter(pageCtl: TPageControl; aSheet, bSheet: TTabSheet): boolean;
// Get size of file
// This is just a slightly easier to use version of GetFileSize
// Returns file size, or -1 on error
function SDUGetFileSize(filename: string): LARGE_INTEGER;
// Returns installed OS
function SDUInstalledOS(): TInstalledOS;
// Returns TRUE if installed OS is Windows Vista or later
function SDUOSVistaOrLater(): boolean;
// Register the specified filename extension to launch the command given
function SDUFileExtnRegCmd(fileExtn: string; menuItem: string; command: string): boolean;
function SDUFileExtnUnregCmd(fileExtn: string; menuItem: string): boolean;
// Identify if the specified executable forms any part of the command for the
// associated file extension
function SDUFileExtnIsRegCmd(fileExtn: string; menuItem: string; executable: string): boolean;
// Register the specified filename extension to use the specified icon
function SDUFileExtnRegIcon(fileExtn: string; filename: string; iconNum: integer): boolean;
function SDUFileExtnUnregIcon(fileExtn: string): boolean;
// Return TRUE/FALSE, depending on if the file extension is registered or not
function SDUFileExtnIsRegd(fileExtn: string; menuItem: string): boolean;
// Get a string with the drive letters of all drives present/not present, in
// order
// Return value is all in uppercase
function SDUGetUsedDriveLetters(): string;
function SDUGetUnusedDriveLetters(): string;
// Populate "output" with a pretty-printed hex display of the contents of "data"
function SDUPrettyPrintHex(data: Pointer; offset: Longint; bytes: Longint; output: TStringList; width: cardinal = 8; dispOffsetWidth: cardinal = 8): boolean; overload;
function SDUPrettyPrintHex(data: string; offset: Longint; bytes: Longint; output: TStringList; width: cardinal = 8; dispOffsetWidth: cardinal = 8): boolean; overload;
function SDUPrettyPrintHex(data: TStream; offset: Longint; bytes: Longint; output: TStringList; width: cardinal = 8; dispOffsetWidth: cardinal = 8): boolean; overload;
// As "SDUPrettyPrintHex(...)", but returns output as a string, instead of as a TStringList and TURE/FALSE flag
// Returns '' on error/if no data was supplied
function SDUPrettyPrintHexStr(data: Pointer; offset: Longint; bytes: Longint; width: cardinal = 8; dispOffsetWidth: cardinal = 8): string; overload;
function SDUPrettyPrintHexStr(data: string; offset: Longint; bytes: Longint; width: cardinal = 8; dispOffsetWidth: cardinal = 8): string; overload;
function SDUPrettyPrintHexStr(data: TStream; offset: Longint; bytes: Longint; width: cardinal = 8; dispOffsetWidth: cardinal = 8): string; overload;
// Setup a Open/Save dialog with supplied default filename & path
// Fixes problem with just setting "filename" for these dialogs before
// Execute()ing them
procedure SDUOpenSaveDialogSetup(dlg: TCommonDialog; defaultFilename: string);
// Convert short filename to LFN
function  SDUConvertSFNToLFN(sfn: String): String;
// Convert LFN to short filename
function  SDUConvertLFNToSFN(lfn: string): string;
// Enable/disable the specified control, with correct colors
procedure SDUEnableControl(control: TControl; enable: boolean; affectAssociatedControls: boolean = TRUE);
// Set "value" to the value of the command line parameter "-<parameter> value". Returns TRUE/FALSE on success/failure
function  SDUCommandLineParameter(parameter: string; var value: string): boolean;
// Returns TRUE if the specified command line switch could be found, otherwise FALSE
function  SDUCommandLineSwitch(parameter: string): boolean;
// Returns the parameter number in the command line of the specified parameter. Returns -1 on failure
function  SDUCommandLineSwitchNumber(parameter: string): integer;
// Returns the executables version numbers as set in Project|Options|Version Info
function SDUGetVersionInfo(filename: string; var majorVersion, minorVersion, revisionVersion, buildVersion: integer): boolean;
// As SDUGetVersionInfo, but returns a nicely formatted string
function SDUGetVersionInfoString(filename: string): string;
// Pause for the given number of ms
procedure SDUPause(delayLen: integer);
// Execute the specified commandline and return when the command line returns
function  SDUWinExecAndWait32(cmdLine: string; cmdShow: integer; workDir: string = ''): cardinal;
// Returns the control within parentControl which has the specified tag value
function  SDUGetControlWithTag(tag: integer; parentControl: TControl): TControl;
// Display the Windows shell dialog displaying the properties for the specified item
procedure SDUShowFileProperties(const filename: String);
// Get a list of all environment variables
function SDUGetEnvironmentStrings(envStrings: TStringList): boolean;
// Get the value of the specified environment variable
function SDUGetEnvironmentVar(envVar: string; var value: string): boolean;
// Set the specified time/datestamps on the file referred to by Handle
// Identical to "SetFileTime", but updates all 3 timestamps (created, last
// modified and last accessed)
function SDUSetAllFileTimes(Handle: Integer; Age: Integer): integer;
// Counts the number of instances of theChar in theString, and returns this
// count
function SDUCountCharInstances(theChar: char; theString: string): integer;
// These two functions ripped from FileCtrl.pas - see Delphi 4 source
function SDUVolumeID(DriveChar: Char): string;
function SDUNetworkVolume(DriveChar: Char): string;
{$IFDEF MSWINDOWS}
// This calls SDUVolumeID/SDUNetworkVolume as appropriate
// Returns '3.5" Floppy'/'Removable Disk' instead of volume label for these
// type of drives
function SDUGetVolumeID(drive: char): string;
{$ENDIF}
// Detect if the current application is already running, and if it is, return
// a handle to it's main window.
// Returns 0 if the application is not currently running
function SDUDetectExistingApp(): THandle;
// Send a message to all existing apps
procedure SDUSendMessageExistingApp(msg: Cardinal; lParam: integer; wParam: integer);
// Post a message to all existing apps
procedure SDUPostMessageExistingApp(msg: Cardinal; lParam: integer; wParam: integer);
// Split the string supplied into two parts, before and after the split char
function SDUSplitString(wholeString: string; var firstItem: string; var theRest: string; splitOn: char = ' '): boolean;
// Convert a hex number into an integer
function SDUHexToInt(hex: string): integer;
function SDUTryHexToInt(hex: string; var Value: integer): boolean;
// Save the given font's details to the registry
function SDUSaveFontToReg(rootKey: HKEY; fontKey: string; name: string; font: TFont): boolean;
// Load the font's details back from the registry
function SDULoadFontFromReg(rootKey: HKEY; fontKey: string; name: string; font: TFont): boolean;


implementation

uses
  SysUtils,
  extctrls,
  Spin, // Required for TSpinEdit control disabling (Under the "samples" tab on Delphi 4.0)
  ShellAPI, // Required for SDUShowFileProperties
{$IFDEF MSWINDOWS}
{$WARN UNIT_PLATFORM OFF}  // Useless warning about platform - we're already
                           // protecting against that!
  FileCtrl, // Required for TDriveType
{$WARN UNIT_PLATFORM ON}
{$ENDIF}
  registry,
  //SDUProgress_U,
  //Spin64,  // Required for TSpinEdit64
  Math;  // Required for Power(...)


var
  _SDUDetectExist_AppName   : array [0..255] of Char;
  _SDUDetectExist_ClassName : array [0..255] of Char;
  _SDUDetectExist_CntFound  : integer;
  _SDUDetectExist_LastFound : HWnd;

  _SDUSendMsg_msg: cardinal;
  _SDUSendMsg_wParam: integer;
  _SDUSendMsg_lParam: integer;


procedure _SDUDetectExistWindowDetails(); forward;

// Starting from offset "offset" (zero indexed) in "data", read "bytes" bytes
// and populate "output" with a pretty printed representation of the data
// If "bytes" is set to -1, then this will read in *all* data from "data",
// starting from "offset" until the end of the stream
// !! WARNING !!
// AFTER CALLING THIS FUNCTION, THE CURRENT POSITION IN "data" WILL BE
// "offset"+"bytes" (or the last byte, whichever is the lesser)
// Each line in "output" will relate to "width" bytes from "data"
// Returns: TRUE/FALSE on success/failure
function SDUPrettyPrintHex(data: TStream; offset: Longint; bytes: Longint; output: TStringList; width: cardinal = 8; dispOffsetWidth: cardinal = 8): boolean;
var
  i: integer;
  lineHexRep: string;
  lineCharRep: string;
  currLine: string;
  posInLine: cardinal;
  x: byte;
  allOK: boolean;
  lineOffset: integer;
  bytesRead: integer;
  finished: boolean;
begin
  allOK := TRUE;

  data.Position := offset;

  lineOffset := data.Position;
  lineHexRep  := '';
  lineCharRep := '';
  posInLine := 1;

  finished := FALSE;
  // Loop around until either we have processed "bytes" bytes from "data", or
  // "finished" is set - this is done in this way so that -1 can be specified
  // for "bytes" to indicate that processing should be carried out until the
  // end of "data" is reached
  while (
          ( (bytes = -1) or ((data.Position-offset)<bytes) ) and
          not(finished)
        ) do
    begin

    bytesRead:= data.Read(x, 1);
    if (bytesRead = 0) then
      begin
      // If the read fails, then this is an error, unless we're supposed to be
      // processing until we run out of data.
      if (bytes <> -1) then
        begin
        allOK := FALSE;
        end;

      finished := TRUE;
      end
    else
      begin
      lineHexRep := lineHexRep + inttohex(x, 2) + ' ';
      if ( (x>=32) and (x<127) ) then
        begin
        lineCharRep := lineCharRep + char(x);
        end
      else
        begin
        lineCharRep := lineCharRep + '.';
        end;


      inc(posInLine);
      if (posInLine > width) then
        begin
        posInLine := 1;
        currLine := inttohex(lineOffset, dispOffsetWidth) + ' | ' + lineHexRep + '| ' + lineCharRep;
        output.add(currLine);
        lineOffset := data.Position;
        lineHexRep := '';
        lineCharRep := '';
        end;

      end;

    end;

  if (length(lineCharRep)>0) then
    begin
    // width-posInLine+1 - the +1 is because it posInLine was incremented at the end of the previous loop
    for i:=1 to (width-posInLine+1) do
      begin
      lineHexRep := lineHexRep + '   ';
      lineCharRep := lineCharRep + ' ';
      end;
    currLine := inttohex(lineOffset, dispOffsetWidth) + ' | ' + lineHexRep + '| ' + lineCharRep;
    output.add(currLine);
    end;

  Result := allOK;

end;


// Starting from offset "offset" (zero indexed) in "data", read "bytes" bytes
// and populate "output" with a pretty printed representation of the data
// If "bytes" is set to -1, then this will read in *all* data from "data",
// starting from "offset" until the end of the stream
// Each line in "output" will relate to "width" bytes from "data"
// Returns: TRUE/FALSE on success/failure
function SDUPrettyPrintHex(data: string; offset: Longint; bytes: Longint; output: TStringList; width: cardinal = 8; dispOffsetWidth: cardinal = 8): boolean; overload;
var
  dataStream: TStringStream;
  allOK: boolean;
begin
  dataStream:= TStringStream.Create(data);
  try
    allOK := SDUPrettyPrintHex(dataStream, offset, bytes, output, width, dispOffsetWidth);
  finally
    dataStream.Free();
  end;

  Result := allOK;
end;


function SDUPrettyPrintHex(data: Pointer; offset: Longint; bytes: Longint; output: TStringList; width: cardinal = 8; dispOffsetWidth: cardinal = 8): boolean; overload;
var
  str: string;
  i: integer;
begin
  str := '';
  for i:=0 to ((offset+bytes)-1) do
    begin
    str:= str + (PChar(data))[i];
    end;

  Result := SDUPrettyPrintHex(str, offset, bytes, output, width, dispOffsetWidth);

end;


function SDUPrettyPrintHexStr(data: Pointer; offset: Longint; bytes: Longint; width: cardinal = 8; dispOffsetWidth: cardinal = 8): string; overload;
var
  sl: TStringList;
  retVal: string;
begin
  retVal := '';

  sl:= TStringList.Create();
  try
    if SDUPrettyPrintHex(data, offset, bytes, sl, width, dispOffsetWidth) then
      begin
      retVal := sl.Text;
      end;

  finally
    sl.Free();
  end;

  Result := retVal;
end;

function SDUPrettyPrintHexStr(data: string; offset: Longint; bytes: Longint; width: cardinal = 8; dispOffsetWidth: cardinal = 8): string; overload;
var
  sl: TStringList;
  retVal: string;
begin
  retVal := '';

  sl:= TStringList.Create();
  try
    if SDUPrettyPrintHex(data, offset, bytes, sl, width, dispOffsetWidth) then
      begin
      retVal := sl.Text;
      end;

  finally
    sl.Free();
  end;

  Result := retVal;
end;

function SDUPrettyPrintHexStr(data: TStream; offset: Longint; bytes: Longint; width: cardinal = 8; dispOffsetWidth: cardinal = 8): string; overload;
var
  sl: TStringList;
  retVal: string;
begin
  retVal := '';

  sl:= TStringList.Create();
  try
    if SDUPrettyPrintHex(data, offset, bytes, sl, width, dispOffsetWidth) then
      begin
      retVal := sl.Text;
      end;

  finally
    sl.Free();
  end;

  Result := retVal;
end;

// Setup a Open/Save dialog with supplied default filename & path
// Fixes problem with just setting "filename" for these dialogs before
// Execute()ing them
procedure SDUOpenSaveDialogSetup(dlg: TCommonDialog; defaultFilename: string);
var
  filename: string;
  initDir: string;
begin
  // uses FileCtrl
  defaultFilename := trim(defaultFilename);
  if not(directoryexists(defaultFilename)) then
    begin
    filename := extractfilename(defaultFilename);
    initDir := extractfilepath(defaultFilename);
    end
  else
    begin
    filename := '';
    initDir := defaultFilename;
    end;

  if dlg is TOpenDialog then
    begin
    TOpenDialog(dlg).filename := filename;
    TOpenDialog(dlg).initialdir := initDir;
    end
  else if dlg is TSaveDialog then
    begin
    TSaveDialog(dlg).filename := filename;
    TSaveDialog(dlg).initialdir := initDir;
    end;

end;

// Convert a short path & filename to it's LFN version
// [IN] sfn - the short filename to be converted into a long filename
// Returns - the long filename
function SDUConvertSFNToLFN(sfn: String): String;
  function SDUConvertSFNPartToLFN(sfn: String): String;
  var
    temp: TWIN32FindData;
    searchHandle: THandle;
  begin
    searchHandle := FindFirstFile(PChar(sfn), temp);
    if searchHandle <> ERROR_INVALID_HANDLE then
      begin
      Result := String(temp.cFileName);
      if Result = '' then
        begin
        Result := String(temp.cAlternateFileName);
        end;
      end
    else
      begin
      Result := '';
      end;
    Windows.FindClose(searchHandle);
  end;

var
  lastSlash: PChar;
  tempPathPtr: PChar;
  copySfn: string;
begin
  sfn := SDUConvertLFNToSFN(sfn);

  Result := '';

  if not(FileExists(sfn)) and not(DirectoryExists(sfn)) then
    begin
    // Result already set to '' so just exit.
    exit;
    end;

  copySfn := copy(sfn, 1, length(sfn));
  tempPathPtr := PChar(copySfn);
  lastSlash := StrRScan(tempPathPtr, '\');
  while lastSlash <> nil do
    begin
    Result := '\' + SDUConvertSFNPartToLFN(tempPathPtr) + Result;
    if lastSlash <> nil then
      begin
      lastSlash^ := char(0);
      lastSlash := StrRScan(tempPathPtr, '\');

      // This bit is required to take into account the possibility of being
      // passed a UNC filename (e.g. \\computer_name\share_name\path\filename)
      if ( (Pos('\\', tempPathPtr) = 1) and
           (SDUCountCharInstances('\', tempPathPtr)=3) ) then
        begin
        lastSlash := nil;
        end;
      end
      
    end;

  if tempPathPtr[1]=':' then
    begin
    tempPathPtr[0] := upcase(tempPathPtr[0]);
    end;

  Result := tempPathPtr + Result;
end;


// Convert a LFN to it's short version
// [IN] lfn - the LFN to be converted into a short filename
// Returns - the short filename
function SDUConvertLFNToSFN(lfn: string): string;
var
  sfn: string;
begin
  if not(FileExists(lfn)) and not(DirectoryExists(lfn)) then
    begin
    Result := '';
    exit;
    end;

  sfn := ExtractShortPathName(lfn);
  if sfn[2]=':' then
    begin
    sfn[1] := upcase(sfn[1]);
    end;
  Result := sfn;
end;


procedure SDUEnableControl(control: TControl; enable: boolean; affectAssociatedControls: boolean = TRUE);
var
  i: integer;
begin
  if not(control is TPageControl) and
     not(control is TForm)        and
     not(control is TPanel)       then
    begin
    control.enabled := enable;
    end;

  if (control is TEdit)     OR
     (control is TRichedit) OR
     (control is TDateTimePicker) OR
     (control is TComboBox) then
    begin
    if enable then
      begin
      TEdit(control).color := clWindow;
      end
    else
      begin
      TEdit(control).color := clBtnFace;
      end
    end
  else if (
           (control is THotKey) or
           (control is TSpinEdit) {or
           (control is TSpinEdit64)}
          ) then
    begin
    if enable then
      begin
      TWinControl(control).Brush.Color := clWindow;
      end
    else
      begin
      TWinControl(control).Brush.Color := clBtnFace;
      end
    end
  else if control is TWinControl then
    begin
    for i:=0 to (TWinControl(control).ControlCount-1) do
      begin
      SDUEnableControl(TWinControl(control).Controls[i], enable);
      end;
    end;

  if control is TRichedit then
    begin
    TRichedit(control).enabled := TRUE;
    TRichedit(control).readonly := not(enable);
    end;

  if control is TGroupBox then
    begin
    if enable then
      begin
      TGroupBox(control).Font.Color := clWindowText;
      end
    else
      begin
      TGroupBox(control).Font.Color := clInactiveCaption;
      end;

    end;

  // Seek any controls with the same parent that have FocusControl set to this
  // component, and enabling/disabling it then as appropriate
  if affectAssociatedControls then
    begin
    if (control.Parent <> nil) then
      begin
      if (control.Parent is TWinControl) then
        begin
        for i:=0 to (TWinControl(control.Parent).ControlCount-1) do
          begin
          if (TWinControl(control.Parent).Controls[i] is TLabel) then
            begin
            if (TLabel(TWinControl(control.Parent).Controls[i]).FocusControl = control) then
              begin
              SDUEnableControl(TWinControl(control.Parent).Controls[i], enable);
              end;
            end
          else if (TWinControl(control.Parent).Controls[i] is TStaticText) then
            begin
            if (TStaticText(TWinControl(control.Parent).Controls[i]).FocusControl = control) then
              begin
              SDUEnableControl(TWinControl(control.Parent).Controls[i], enable);
              end;
            end;
          end;  // for i:=0 to (TWinControl(control.Parent).ControlCount-1) do
        end;  // if (control.Parent is TWinControl) then
      end;  // if (control.Parent <> nil) then
    end;  // if affectAssociatedControls then

end;

function SDUCommandLineParameter(parameter: string; var value: string): boolean;
var
  i: integer;
  testParam: string;
begin
  Result := FALSE;
  parameter := uppercase(parameter);
  for i:=1 to (ParamCount-1) do
    begin
    testParam := uppercase(ParamStr(i));
    if ((testParam=('-'+parameter)) OR
        (testParam=('/'+parameter))) then
      begin
      value := ParamStr(i+1);
      Result := TRUE;
      break;
      end;
    end;

end;


function SDUCommandLineSwitch(parameter: string): boolean;
var
  i: integer;
begin
  Result := FALSE;
  parameter := uppercase(parameter);
  for i:=1 to ParamCount do
    begin
    if (uppercase(ParamStr(i))=('-'+parameter)) OR
       (uppercase(ParamStr(i))=('/'+parameter)) then
      begin
      Result := TRUE;
      break;
      end;
    end;

end;

function SDUCommandLineSwitchNumber(parameter: string): integer;
var
  i: integer;
begin
  Result := -1;
  parameter := uppercase(parameter);
  for i:=1 to ParamCount do
    begin
    if (uppercase(ParamStr(i))=('-'+parameter)) OR
       (uppercase(ParamStr(i))=('/'+parameter)) then
      begin
      Result := i;
      break;
      end;
    end;

end;

// set filename to '' to get version info on the currently running executable
function SDUGetVersionInfo(filename: string; var majorVersion, minorVersion, revisionVersion, buildVersion: integer): boolean;
var
  vsize: Integer;
  puLen: Cardinal;
  dwHandle: DWORD;
  pBlock: Pointer;
  pVPointer: Pointer;
  tvs: PVSFixedFileInfo;
begin
  Result := FALSE;

  if filename='' then
    begin
    filename := Application.ExeName;
    end;

  vsize := GetFileVersionInfoSize(PChar(filename),dwHandle);
  if vsize = 0 then
    begin
    exit;
    end;

  GetMem(pBlock,vsize);
  try
    if GetFileVersionInfo(PChar(filename),dwHandle,vsize,pBlock) then
      begin
      VerQueryValue(pBlock,'\',pVPointer,puLen);
      if puLen > 0 then
        begin
        tvs := PVSFixedFileInfo(pVPointer);
        majorVersion    := tvs^.dwFileVersionMS shr 16;
        minorVersion    := tvs^.dwFileVersionMS and $ffff;
        revisionVersion := tvs^.dwFileVersionLS shr 16;
        buildVersion    := tvs^.dwFileVersionLS and $ffff;
        Result := TRUE;
        end;
      end;
  finally
    FreeMem(pBlock);
  end;

end;

function SDUGetVersionInfoString(filename: string): string;
var
  majorVersion: integer;
  minorVersion: integer;
  revisionVersion: integer;
  buildVersion: integer;
begin
  Result := '';
  if SDUGetVersionInfo(filename, majorVersion, minorVersion, revisionVersion, buildVersion) then
    begin
    Result := Format('%d.%.2d.%.2d.%.4d', [majorVersion, minorVersion, revisionVersion, buildVersion]);
    end;

end;


procedure SDUPause(delayLen: integer);
var
  delay: TTimeStamp;
begin
  delay := DateTimeToTimeStamp(now);
  delay.Time := delay.Time+delayLen;
  while (delay.time>DateTimeToTimeStamp(now).time) do
    begin
    // Nothing - just pause
    end;

end;


// !! WARNING !! cmdLine must contain no whitespaces, otherwise the first
//               parameter in the CreateProcess call must be set
// xxx - sort out that warning will sort this out later
// This function ripped from UDDF
// [IN] cmdLine - the command line to execute
// [IN] cmsShow - see the description of the nCmdShow parameter of the
//                ShowWindow function
// [IN] workDir - the working dir of the cmdLine (default is ""; no working dir)
// Returns: The return value of the command, or $FFFFFFFF on failure
function SDUWinExecAndWait32(cmdLine: string; cmdShow: integer; workDir: string = ''): cardinal;
var
  zAppName:array[0..512] of char;
//  zCurDir:array[0..255] of char;
//  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  retVal: DWORD;
  pWrkDir: PChar;
begin
  retVal := $FFFFFFFF;

  StrPCopy(zAppName, cmdLine);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := cmdShow;

  pWrkDir := nil;
  if workDir<>'' then
    begin
    pWrkDir := PChar(workDir);
    end;

  if CreateProcess(nil,
                   zAppName,              { pointer to command line string }
                   nil,                   { pointer to process security attributes }
                   nil,                   { pointer to thread security attributes }
                   false,                 { handle inheritance flag }
                   CREATE_NEW_CONSOLE or  { creation flags }
                   NORMAL_PRIORITY_CLASS,
                   nil,                   { pointer to new environment block }
                   pWrkDir,               { pointer to current directory name }
                   StartupInfo,           { pointer to STARTUPINFO }
                   ProcessInfo) then      { pointer to PROCESS_INF }
    begin
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, retVal);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    end;

  Result := retVal;

end;

function SDUGetControlWithTag(tag: integer; parentControl: TControl): TControl;
var
  i: integer;
begin
  Result := nil;

  for i:=0 to (TWinControl(parentControl).ControlCount-1) do
    begin
    if TWinControl(parentControl).Controls[i].tag = tag then
      begin
      Result := TWinControl(parentControl).Controls[i];
      end;
    end;

end;


procedure SDUShowFileProperties(const filename: String);
var
  sei: TShellExecuteinfo;
begin
  FillChar(sei,sizeof(sei),0);
  sei.cbSize := sizeof(sei);
  sei.lpFile := Pchar(filename);
  sei.lpVerb := 'properties';
  sei.fMask  := SEE_MASK_INVOKEIDLIST;
  ShellExecuteEx(@sei);
end;

function SDUVolumeID(DriveChar: Char): string;
var
  OldErrorMode: Integer;
  NotUsed, VolFlags: DWORD;
  Buf: array [0..MAX_PATH] of Char;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Buf[0] := #$00;
    if GetVolumeInformation(PChar(DriveChar + ':\'), Buf, DWORD(sizeof(Buf)),
      nil, NotUsed, VolFlags, nil, 0) then
      SetString(Result, Buf, StrLen(Buf))
    else Result := '';
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

function SDUNetworkVolume(DriveChar: Char): string;
var
  Buf: Array [0..MAX_PATH] of Char;
  DriveStr: array [0..3] of Char;
  BufferSize: DWORD;
begin
  BufferSize := sizeof(Buf);
  DriveStr[0] := UpCase(DriveChar);
  DriveStr[1] := ':';
  DriveStr[2] := #0;
  if WNetGetConnection(DriveStr, Buf, BufferSize) = WN_SUCCESS then
  begin
    SetString(Result, Buf, BufferSize);
    if pos(#0, Result)>0 then
      begin
      delete(Result, pos(#0, Result), length(Result)-pos(#0, Result)+1);
      end;
    if DriveChar < 'a' then
      Result := AnsiUpperCaseFileName(Result)
    else
      Result := AnsiLowerCaseFileName(Result);
  end
  else
    Result := SDUVolumeID(DriveChar);
end;

{$IFDEF MSWINDOWS}
function SDUGetVolumeID(drive: char): string;
var
  DriveType: TDriveType;
begin
  Result := '';

  drive := upcase(drive);
  DriveType := TDriveType(GetDriveType(PChar(drive + ':\')));

  case DriveType of
    dtFloppy:
      begin
      if (drive='A') OR (drive='B') then
        begin
        Result := '3.5" Floppy';
        end
      else
        begin
        Result := 'Removable Disk';
        end;
      end;
    dtFixed:
      begin
      Result := SDUVolumeID(drive);
      end;
    dtNetwork:
      begin
      Result := SDUNetworkVolume(drive);
      end;
    dtCDROM:
      begin
      Result := SDUVolumeID(drive);
      end;
    dtRAM:
      begin
      Result := SDUVolumeID(drive);
      end;
  end;

end;
{$ENDIF}

// Populate a TStringsList with environment variables
// [OUT] envStrings - a TStringsList to be populated with the names of all environment variables
// Returns TRUE/FALSE on success/failure
function SDUGetEnvironmentStrings(envStrings: TStringList): boolean;
var
  pEnvPtr, pSavePtr: PChar;
begin
  pEnvPtr := GetEnvironmentStrings;
  pSavePtr := pEnvPtr;
  repeat
    envStrings.add(Copy(StrPas(pEnvPtr),1,Pos('=',StrPas (pEnvPtr))-1));
    inc(pEnvPtr, StrLen(pEnvPtr)+1);
  until pEnvPtr^ = #0;

  FreeEnvironmentStrings(pSavePtr);

  Result := TRUE;
end;


// Get the value of the specified environment variable
// [IN] envVar - the name of the environment variable
// [OUT] value - set to the value of the environment variable on success
// Returns TRUE/FALSE on success/failure
function SDUGetEnvironmentVar(envVar: string; var value: string): boolean;
var
  buffer: string;
  buffSize: integer;
  i: integer;
begin
  Result := FALSE;

  SetString(buffer, nil, 1);
  buffSize := GetEnvironmentVariable(PChar(envVar), PChar(buffer), 0);
  if buffSize<>0 then
    begin
    SetString(buffer, nil, buffSize);
    GetEnvironmentVariable(PChar(envVar), PChar(buffer), buffSize);
    value := '';
    for i:=1 to buffSize-1 do
      begin
      value := value + buffer[i];
      end;

    Result := TRUE;
    end;

end;


// Set the specified time/datestamps on the file referred to by Handle
// Identical to "SetFileTime", but updates all 3 timestamps (created, last
// modified and last accessed)
function SDUSetAllFileTimes(Handle: Integer; Age: Integer): integer;
var
  LocalFileTime, FileTime: TFileTime;
begin
  Result := 0;
  if (
      DosDateTimeToFileTime(LongRec(Age).Hi, LongRec(Age).Lo, LocalFileTime) and
      LocalFileTimeToFileTime(LocalFileTime, FileTime) and
      SetFileTime(Handle, @FileTime, @FileTime, @FileTime)
     ) then
    begin
    exit;
    end;
  Result := GetLastError;
end;


// Counts the number of instances of theChar in theString, and returns this
// count
function SDUCountCharInstances(theChar: char; theString: string): integer;
var
  i: integer;
  count: integer;
begin
  count := 0;
  for i:=1 to length(theString) do
    begin
    if theString[i]=theChar then
      begin
      inc(count);
      end;
    end;

  Result := count;
end;



// This is used by SDUDetectExistingApp and carries out a check on the window
// supplied to see if it matches the current one
function _SDUDetectExistingAppCheckWindow(Handle: HWND; Temp: LongInt): BOOL; stdcall;
var
  WindowName : Array[0..255] of Char;
  ClassName  : Array[0..255] of Char;
begin
  // Go get the windows class name
  // Is the window class the same?
  if (GetClassName(Handle, ClassName, sizeof(ClassName)) > 0) then
    begin
    if (StrComp(ClassName, _SDUDetectExist_ClassName) = 0) then
      begin
      // Get its window caption
      // Does this have the same window title?
      if (GetWindowText(Handle, WindowName, sizeof(WindowName)) > 0) then
        begin
        if (StrComp(WindowName, _SDUDetectExist_AppName) = 0) then
          begin
          inc(_SDUDetectExist_CntFound);
          // Are the handles different?
          if (Handle <> Application.Handle) then
            begin
            // Save it so we can bring it to the top later.
            _SDUDetectExist_LastFound := Handle;
            end;
          end;
        end;
      end;
    end;

  Result := TRUE;
end;


// Detect if the current application is already running, and if it is, return
// a handle to it's main window.
// Returns 0 if the application is not currently running
function SDUDetectExistingApp(): THandle;
begin
  // Determine what this application's name is...
  GetWindowText(
                Application.Handle,
                _SDUDetectExist_AppName,
                sizeof(_SDUDetectExist_AppName)
               );

  // ...then determine the class name for this application...
  GetClassName(
               Application.Handle,
               _SDUDetectExist_ClassName,
               sizeof(_SDUDetectExist_ClassName)
              );

  // ...and count how many others out there are Delphi apps with this title
  _SDUDetectExist_CntFound := 0;
  _SDUDetectExist_LastFound := 0;
  EnumWindows(@_SDUDetectExistingAppCheckWindow, 0);

  Result := _SDUDetectExist_LastFound;
end;


// This is used by SDUSendMessageExistingApp and carries out a check on the
// window supplied to see if it matches the current one
function _SDUSendMessageExistingAppCheckWindow(Handle: HWND; Temp: LongInt): BOOL; stdcall;
var
  WindowName : Array[0..255] of Char;
  ClassName  : Array[0..255] of Char;
begin
  // Go get the windows class name
  // Is the window class the same?
  if (GetClassName(Handle, ClassName, sizeof(ClassName)) > 0) then
    begin
    if (StrComp(ClassName, _SDUDetectExist_ClassName) = 0) then
      begin
      // Get its window caption
      // Does this have the same window title?
      if (GetWindowText(Handle, WindowName, sizeof(WindowName)) > 0) then
        begin
        if StrComp(WindowName, _SDUDetectExist_AppName)=0 then
          begin
          SendMessage(
                      Handle,
                      _SDUSendMsg_msg,
                      _SDUSendMsg_wParam,
                      _SDUSendMsg_lParam
                     );
          end;
        end;
      end;
    end;

  Result := TRUE;
end;


// Detect if the current application is already running, and if it is, return
// a handle to it's main window.
// Returns 0 if the application is not currently running
procedure SDUSendMessageExistingApp(msg: Cardinal; lParam: integer; wParam: integer);
begin
  _SDUDetectExistWindowDetails();

  _SDUSendMsg_msg    := msg;
  _SDUSendMsg_wParam := wParam;
  _SDUSendMsg_lParam := lParam;

  EnumWindows(@_SDUSendMessageExistingAppCheckWindow, 0);

end;


// This is used by SDUPostMessageExistingApp and carries out a check on the
// window supplied to see if it matches the current one
function _SDUPostMessageExistingAppCheckWindow(Handle: HWND; Temp: LongInt): BOOL; stdcall;
var
  WindowName : Array[0..255] of Char;
  ClassName  : Array[0..255] of Char;
begin
  // Go get the windows class name
  // Is the window class the same?
  if (GetClassName(Handle, ClassName, sizeof(ClassName)) > 0) then
    begin
    if (StrComp(ClassName, _SDUDetectExist_ClassName) = 0) then
      begin
      // Get its window caption
      // Does this have the same window title?
      if (GetWindowText(Handle, WindowName, sizeof(WindowName)) > 0) then
        begin
        if StrComp(WindowName, _SDUDetectExist_AppName)=0 then
          begin
          PostMessage(
                      Handle,
                      _SDUSendMsg_msg,
                      _SDUSendMsg_wParam,
                      _SDUSendMsg_lParam
                     );
          end;
        end;
      end;
    end;

  Result := TRUE;
end;


// Detect if the current application is already running, and if it is, return
// a handle to it's main window.
// Returns 0 if the application is not currently running
procedure SDUPostMessageExistingApp(msg: Cardinal; lParam: integer; wParam: integer);
begin
  _SDUDetectExistWindowDetails();

  _SDUSendMsg_msg    := msg;
  _SDUSendMsg_wParam := wParam;
  _SDUSendMsg_lParam := lParam;

  EnumWindows(@_SDUPostMessageExistingAppCheckWindow, 0);

end;


procedure _SDUDetectExistWindowDetails();
begin
  // Determine what this application's name is...
  GetWindowText(
                Application.Handle,
                _SDUDetectExist_AppName,
                sizeof(_SDUDetectExist_AppName)
               );

  // ...then determine the class name for this application...
  GetClassName(
               Application.Handle,
               _SDUDetectExist_ClassName,
               sizeof(_SDUDetectExist_ClassName)
              );
end;


// Split the string supplied into two parts, before and after the split char
function SDUSplitString(wholeString: string; var firstItem: string; var theRest: string; splitOn: char = ' '): boolean;
begin
  Result := FALSE;
  firstItem := wholeString;
  if pos(splitOn, wholeString)>0 then
    begin
    firstItem := copy(wholeString, 1, (pos(splitOn, wholeString)-1));
    theRest := copy(wholeString, length(firstItem)+length(splitOn)+1, (length(wholeString)-(length(firstItem)+length(splitOn))));
    Result := TRUE;
    end
  else
    begin
    theRest := '';
    end;

end;


// Convert a hex number into an integer
function SDUHexToInt(hex: string): integer;
begin
  Result := StrToInt('$'+hex);

end;

function SDUTryHexToInt(hex: string; var Value: integer): boolean;
begin
  // Strip out any spaces
  hex := StringReplace(hex, ' ', '', [rfReplaceAll]);

  // If prefixed with "0x", strip this out as well
  if (Pos('0X', uppercase(hex)) = 0) then
    begin
    Delete(hex, 1, 2);
    end;

  Result := TryStrToInt('$'+hex, Value);
end;

// Save the given font's details to the registry
function SDUSaveFontToReg(rootKey: HKEY; fontKey: string; name: string; font: TFont): boolean;
var
  LogFont : TLogFont;
  registry : TRegistry;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @LogFont);
  registry := TRegistry.Create;
  try
    registry.LazyWrite := false;
    registry.RootKey := rootKey;
    registry.OpenKey(FontKey, true);
    registry.WriteBinaryData(name+'LogFont', LogFont, SizeOf(LogFont));
    registry.WriteInteger(name+'FontColor', Font.Color);
    Result := TRUE;
  finally
    registry.Free;
  end;
end;


// Load the font's details back from the registry
function SDULoadFontFromReg(rootKey: HKEY; fontKey: string; name: string; font: TFont): boolean;
var
  LogFont : TLogFont;
  registry : TRegistry;
begin
  Result := FALSE;

  registry := TRegistry.Create;
  try
    registry.RootKey := rootKey;
    if registry.OpenKey(fontKey, false) then
      begin
      if registry.ReadBinaryData(name+'LogFont', LogFont, SizeOf(LogFont))>0 then
        begin
        Font.Color := registry.ReadInteger(name+'FontColor');
        Font.Handle := CreateFontIndirect(LogFont);
        Result := TRUE;
        end;
      end;
  finally
    registry.Free();
  end;
end;

// Get a string with the drive letters of all drives present/not present, in
// order
// Return value is all in uppercase
function SDUGetUsedDriveLetters(): string;
var
  driveLetters: string;
  DriveNum: Integer;
  DriveBits: set of 0..25;
begin
  driveLetters := '';

  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do
    begin
    if (DriveNum in DriveBits) then
      begin
      driveLetters := driveLetters + Char(DriveNum + Ord('A'));
      end;
    end;

  Result := driveLetters;
end;


function SDUGetUnusedDriveLetters(): string;
var
  x: char;
  usedDriveLetters: string;
  retval: string;
begin
  retval:= '';

  usedDriveLetters := SDUGetUsedDriveLetters();
  for x:='A' to 'Z' do
    begin
    if (pos(x, usedDriveLetters) = 0) then
      begin
      retval := retval + x;
      end;
    end;

  Result := retval;
end;


// Register the specified filename extension to launch the command given
// command - This should be quoted as appropriate
function SDUFileExtnRegCmd(fileExtn: string; menuItem: string; command: string): boolean;
var
  registry: TRegistry;
  allOK: boolean;
begin
  allOK := TRUE;

  if (Pos('.', fileExtn)<>1) then
    begin
    fileExtn := '.'+fileExtn;
    end;

  registry:= TRegistry.Create();
  try
    registry.RootKey := HKEY_CLASSES_ROOT;
    registry.Access := KEY_WRITE;

    if registry.OpenKey('\'+fileExtn+'\shell\'+menuItem+'\command', TRUE) then
      begin
      registry.WriteString('', command);
      registry.CloseKey();
      allOK := TRUE;
      end;

    // Nuke any filetype
    if registry.OpenKey('\'+fileExtn, TRUE) then
      begin
      registry.DeleteValue('');
      registry.CloseKey();
      allOK := TRUE;
      end;

  finally
    registry.Free();
  end;

  // Inform Windows that an association has changed...
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);

  Result := allOK;
end;


function SDUFileExtnUnregCmd(fileExtn: string; menuItem: string): boolean;
var
  registry: TRegistry;
  allOK: boolean;
  okToDelete: boolean;
  info: TRegKeyInfo;
begin
  if (Pos('.', fileExtn)<>1) then
    begin
    fileExtn := '.'+fileExtn;
    end;

  // This is a little *ugly*, but it does the job...
  // In a nutshell, this will remove the maximum amount of keys associated with
  // the file extension as it can without causing any damage 
  registry:= TRegistry.Create();
  try
    registry.RootKey := HKEY_CLASSES_ROOT;
    registry.Access := KEY_WRITE;

    allOK := registry.DeleteKey('\'+fileExtn+'\shell\'+menuItem+'\command');
    if allOK then
      begin
      allOK := registry.DeleteKey('\'+fileExtn+'\shell\'+menuItem);
      if allOK then
        begin
        // Check to see if subkeys for other applications exist under the
        // "shell" key...
        allOK := registry.OpenKey('\'+fileExtn+'\shell', FALSE);
        if allOK then
          begin
          okToDelete := FALSE;
          registry.Access := KEY_READ;
          allOK := registry.GetKeyInfo(info);
          registry.Access := KEY_WRITE;
          if allOK then
            begin
            okToDelete := (info.NumSubKeys=0) and (info.NumValues=0);
            end;
          registry.CloseKey();

          // If not, delete the "shell" subkey
          if okToDelete then
            begin
            allOK := registry.DeleteKey('\'+fileExtn+'\shell');
            if allOK then
              begin
              // Check to see if subkeys for other applications exist under the
              // menuitem key...
              allOK:= registry.OpenKey('\'+fileExtn, FALSE);
              if allOK then
                begin
                okToDelete := FALSE;
                registry.Access := KEY_READ;
                allOK := registry.GetKeyInfo(info);
                registry.Access := KEY_WRITE;
                if allOK then
                  begin
                  okToDelete := (info.NumSubKeys=0) and (info.NumValues=0);
                  end;
                registry.CloseKey();

                // If not, delete the extension subkey
                if okToDelete then
                  begin
                  allOK := registry.DeleteKey('\'+fileExtn);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;


  finally
    registry.Free();
  end;

  // Inform Windows that an association has changed...
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);

  Result := allOK;
end;


function SDUFileExtnIsRegCmd(fileExtn: string; menuItem: string; executable: string): boolean;
var
  registry: TRegistry;
  retval: boolean;
  command: string;
begin
  retval := FALSE;

  if (Pos('.', fileExtn)<>1) then
    begin
    fileExtn := '.'+fileExtn;
    end;

  registry:= TRegistry.Create();
  try
    registry.RootKey := HKEY_CLASSES_ROOT;
    registry.Access := KEY_READ;

    if registry.OpenKey('\'+fileExtn+'\shell\'+menuItem+'\command', FALSE) then
      begin
      command := registry.ReadString('');
      registry.CloseKey();
      retval := (Pos(uppercase(executable), uppercase(command)) > 0);
      end;

  finally
    registry.Free();
  end;

  Result := retval;
end;


// Register the specified filename extension to use the specified icon
function SDUFileExtnRegIcon(fileExtn: string; filename: string; iconNum: integer): boolean;
var
  registry: TRegistry;
  allOK: boolean;
begin
  allOK := TRUE;

  if (Pos('.', fileExtn)<>1) then
    begin
    fileExtn := '.'+fileExtn;
    end;

  registry:= TRegistry.Create();
  try
    registry.RootKey := HKEY_CLASSES_ROOT;
    registry.Access := KEY_WRITE;

    if registry.OpenKey('\'+fileExtn+'\DefaultIcon', TRUE) then
      begin
      registry.WriteString('', '"'+filename+'",'+inttostr(iconNum));
      registry.CloseKey();
      allOK := TRUE;
      end;

  finally
    registry.Free();
  end;

  // Inform Windows that an association has changed...
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);

  Result := allOK;
end;


function SDUFileExtnUnregIcon(fileExtn: string): boolean;
var
  registry: TRegistry;
  allOK: boolean;
  okToDelete: boolean;
  info: TRegKeyInfo;
begin
  if (Pos('.', fileExtn)<>1) then
    begin
    fileExtn := '.'+fileExtn;
    end;

  // This is a little *ugly*, but it does the job...
  // In a nutshell, this will remove the maximum amount of keys associated with
  // the file extension as it can without causing any damage
  registry:= TRegistry.Create();
  try
    registry.RootKey := HKEY_CLASSES_ROOT;
    registry.Access := KEY_WRITE;

    allOK := registry.OpenKey('\'+fileExtn+'\DefaultIcon', FALSE);
    if allOK then
      begin
      okToDelete := FALSE;
      allOK := registry.DeleteValue('');
      if (allOK) then
        begin
        allOK := registry.GetKeyInfo(info);
        if allOK then
          begin
          okToDelete := (info.NumSubKeys=0) and (info.NumValues=0);
          end;
        end;

      registry.CloseKey();

      // If no further items under "DefaultIcon" subkey, delete it
      if okToDelete then
        begin
        allOK := registry.DeleteKey('\'+fileExtn+'\DefaultIcon');
        if allOK then
          begin
          // Check to see if subkeys for other applications exist under the
          // extension key...
          allOK:= registry.OpenKey('\'+fileExtn, FALSE);
          if allOK then
            begin
            okToDelete := FALSE;
            allOK := registry.GetKeyInfo(info);
            if allOK then
              begin
              okToDelete := (info.NumSubKeys=0) and (info.NumValues=0);
              end;
            registry.CloseKey();

            // If not, delete the extension subkey
            if okToDelete then
              begin
              allOK := registry.DeleteKey('\'+fileExtn);
              end;
            end;
          end;
        end;
      end;


  finally
    registry.Free();
  end;

  // Inform Windows that an association has changed...
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);

  Result := allOK;
end;


// Return TRUE/FALSE, depending on if the file extension is registered or not
function SDUFileExtnIsRegd(fileExtn: string; menuItem: string): boolean;
var
  registry: TRegistry;
  retval: boolean;
begin
  if (Pos('.', fileExtn)<>1) then
    begin
    fileExtn := '.'+fileExtn;
    end;

  registry:= TRegistry.Create();
  try
    registry.RootKey := HKEY_CLASSES_ROOT;
    registry.Access := KEY_READ;

    retval := registry.KeyExists('\'+fileExtn+'\shell\'+menuItem+'\command');

  finally
    registry.Free();
  end;

  Result := retval;
end;


// Returns installed OS
function SDUInstalledOS(): TInstalledOS;
var
  retVal: TInstalledOS;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
    // Windows NT/2000/XP
    if (Win32MajorVersion < 5) then
      begin
      retVal := osWindowsNT;
      end
    else
      begin
      if (Win32MajorVersion >= 6) then
        begin
        retVal := osWindowsVista;
        end
      else
        begin
        if (Win32MinorVersion = 0) then
          begin
          retVal := osWindows2000;
          end
        else
          begin
          retVal := osWindowsXP;
          end;
        end;
      end;

    end
  else
    begin
    // Windows 95/98/Me
    if (Win32MinorVersion = 0) then
      begin
      retVal := osWindows95;
      end
    else if (Win32MinorVersion = 10) then
      begin
      retVal := osWindows98;
      end
    else
      begin
      retVal := osWindowsMe;
      end;
    end;

  Result := retVal;
end;


// Returns TRUE if installed OS is Windows Vista or later
function SDUOSVistaOrLater(): boolean;
begin
  Result := (SDUInstalledOS = osWindowsVista);

end;


// Get size of file
// This is just a slightly easier to use version of GetFileSize
// Returns file size, or -1 on error
function SDUGetFileSize(filename: string): LARGE_INTEGER;
var
  fileHandle: THandle;
  retVal: LARGE_INTEGER;
  sizeLow, sizeHigh: DWORD;
begin
  retVal.QuadPart := -1;

  // Open file and get it's size
  fileHandle := CreateFile(
                          PChar(filename),  // pointer to name of the file
                          GENERIC_READ,  // access (read-write) mode
                          (FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE),  // share mode
                          nil,  // pointer to security attributes
                          OPEN_EXISTING,  // how to create
                          FILE_FLAG_RANDOM_ACCESS,  // file attributes
                          0  // handle to file with attributes to copy
                         );

  if (fileHandle <> INVALID_HANDLE_VALUE) then
    begin
    sizeLow:= GetFileSize(fileHandle, @sizeHigh);

    if not((sizeLow = $FFFFFFFF) and (GetLastError() <> NO_ERROR)) then
      begin
      retVal.HighPart := sizeHigh;
      retVal.LowPart := sizeLow;
      end;

    CloseHandle(fileHandle);
    end;

  Result := retVal;
end;

// On a TPageControl, determine if the one tabsheet appears *after* another
// Returns TRUE if "aSheet" appears *after* bSheet
// Returns FALSE if "aSheet" appears *before* bSheet
// Returns FALSE if "aSheet" *is* "bSheet"
// Returns TRUE if "aSheet" appears *after* bSheet
// Returns FALSE if "aSheet" appears *before* bSheet
// Returns FALSE if "aSheet" *is* "bSheet"
function SDUIsTabSheetAfter(pageCtl: TPageControl; aSheet, bSheet: TTabSheet): boolean;
var
  i: integer;
  isAfter: boolean;
  foundB: boolean;                   
begin
  isAfter := FALSE;
  foundB := FALSE;

  for i:=0 to (pageCtl.PageCount-1) do
    begin
    if pageCtl.Pages[i] = bSheet then
      begin
      foundB := TRUE;
      end;

    if pageCtl.Pages[i] = aSheet then
      begin
      isAfter := not(foundB);
      break;
      end;

    end;

  Result := isAfter;
end;


// Convert the ASCII representation of binary data into binary data
// ASCIIrep - This must be set to a string containing the ASCII representation
//            of binary data (e.g. "DEADBEEF010203" as bytes $DE, $AD, $BE,
//            $EF, $01, $02, $03)
// Note: ASCIIrep **MUST** have an **even** number of hex chars
// Note: Whitespace in ASCIIrep is *ignored*
function SDUParseASCIIToData(ASCIIrep: string; var data: string): boolean;
var
  retval: boolean;
  tmpStr: string;
  i: integer;
  ASCIIStripped: string;
begin
  retval := FALSE;

  // Uppercase ASCIIrep...
  ASCIIrep := uppercase(ASCIIrep);

  // Strip whitespace from ASCIIrep...
  ASCIIStripped := '';
  for i:=1 to length(ASCIIrep) do
    begin
    if (
         // If it's a numeric char...
         (
           (ord(ASCIIrep[i]) >= ord('0')) and
           (ord(ASCIIrep[i]) <= ord('9'))
         )
        OR
        // ...or "A" - "F"...
         (
           (ord(ASCIIrep[i]) >= ord('A')) and
           (ord(ASCIIrep[i]) <= ord('F'))
         )
       ) then
      begin
      ASCIIStripped := ASCIIStripped + ASCIIrep[i];
      end;

    end;

  // Sanity check; the input ASCII representation must have an even number of
  // chars; the length of the data must be a multiple of 8
  if ((Length(ASCIIStripped) mod 2) < 1) then
    begin
    data := '';

    while (Length(ASCIIStripped) > 0) do
      begin
      tmpStr := Copy(ASCIIStripped, 1, 2);
      delete(ASCIIStripped, 1, 2);

      data := data + chr(SDUHexToInt(tmpStr));
      end;

    retval := TRUE;
    end;

  Result := retval;
end;


// ----------------------------------------------------------------------------
// Create a file of the specified size, filled with zeros
// Note: This will *fail* if the file already exists
// Note: This function *could* have been implemented using SetFilePos and
//       SetEndOfFile, which would have been a lot neater than allocating an in
//       memory buffer, and just dumping it out to disk. However, that clobbers
//       any progress bar, as it doens't get updated
// Returns TRUE on success, FALSE on failure
// If the file creation was cancelled by the user, this function will return
// FALSE, but set userCancelled to TRUE
(*
function SDUCreateLargeFile(
                            filename: string;
                            size: int64;
                            showProgress: boolean;
                            var userCancelled: boolean
                           ): boolean;
const
  BUFFER_SIZE: DWORD = (2*1024*1024); // 2MB buffer; size not *particularly*
                                      // important, but it will allocate this
                                      // amount of memory
                                      // Files are created by repeatedly
                                      // writing a buffer this size out to disk
var
  allOK: boolean;
  fileHandle: THandle;
  buffer: PChar;
  x: int64;
  bytesWritten: DWORD;
  progressDlg: TSDUProgress_F;
  fullChunksToWrite: int64;
  prevCursor: TCursor;
  driveLetter: char;
  diskNumber: integer;
  freeSpace: int64;
begin
  allOK := FALSE;
  userCancelled := FALSE;
  progressDlg := nil;

  if (filename = '') then
    begin
    // No filename specified
    Result := FALSE;
    exit;
    end
  else
    begin
    // Sanity check that there's enough storage on the drive (if a local drive)
    // 2 because we skip the drive letter
    if (Pos(':\', filename) = 2) then
      begin
      driveLetter := upcase(filename[1]);
      diskNumber := ord(driveLetter)-ord('A')+1;
      freeSpace := DiskFree(diskNumber);
      if (freeSpace < size) then
        begin
        // Insufficient free space - exit
        Result := FALSE;
        exit;
        end;
      end;

    end;



  buffer := AllocMem(BUFFER_SIZE);
  try
    // Blank out the buffer
    // Note: This *should* be redundant; AllocMem should init the buffer to
    //       zero's anyway...
    FillChar(buffer^, BUFFER_SIZE, 0);

    fileHandle := CreateFile(
                             PChar(filename),	// pointer to name of the file
                             GENERIC_WRITE,	// access (read-write) mode
                             FILE_SHARE_READ,	// share mode
                             nil,	// pointer to security attributes
                             CREATE_NEW,	// how to create
                             FILE_ATTRIBUTE_NORMAL,	// file attributes
                             0 	// handle to file with attributes to copy
                            );
    if (fileHandle<>INVALID_HANDLE_VALUE) then
      begin
      allOK := TRUE;
      try

        prevCursor := Screen.Cursor;
        Screen.Cursor := crAppStart;
        try

          if (showProgress) then
            begin
            progressDlg:= TSDUProgress_F.Create(nil);
            end;
          try

            fullChunksToWrite := (size div int64(BUFFER_SIZE));

            // Initialize progress dialog
            if (showProgress) then
              begin
              progressDlg.ConfirmCancel := FALSE;


              // We add 1 to cater for if the last block is less than the
              // BUFFER_SIZE. If it's exactly a multiple of BUFFER_SIZE then this
              // simply means that the dialog will never hit 100% completed - but
              // since the dialog will be free'd off at that point, it doens't
              // really matter!
              // Cast 1 to int64 to prevent silly conversion to & from integer
              progressDlg.i64Max:= fullChunksToWrite + int64(1);
              progressDlg.i64Min:= 0;
              progressDlg.i64Position:= 0;

              progressDlg.Show();
              end;


            // Write the buffer to disk as many times as required
            x := 0;
            while (x < fullChunksToWrite) do
              begin
              WriteFile(
                        fileHandle,
                        buffer[0],
                        BUFFER_SIZE,
                        bytesWritten,
                        nil
                       );

              if (bytesWritten <> BUFFER_SIZE) then
                begin
                allOK := FALSE;
                break;
                end;

              // Cast 1 to int64 to prevent silly conversion to & from integer
              x := x + int64(1);


              Application.ProcessMessages();
              if (showProgress) then
                begin
                // Display progress...
                progressDlg.i64IncPosition();

                // Check for user cancel...
                if (progressDlg.Cancel) then
                  begin
                  userCancelled := TRUE;
                  allOK := FALSE;
                  // Get out of loop...
                  break;
                  end;

                end;

              end;

              

            if (allOK) then
              begin
              // If the size of the file requested is not a mulitple of the buffer size,
              // write the remaining bytes
              WriteFile(
                        fileHandle,
                        buffer[0],
                        (size mod BUFFER_SIZE),
                        bytesWritten,
                        nil
                       );
              if (bytesWritten <> (size mod BUFFER_SIZE)) then
                begin
                allOK := FALSE;
                end;

              end;

          finally
            if (progressDlg <> nil) then
              begin
              progressDlg.Free();
              end;
          end;

        finally
          Screen.Cursor := prevCursor;
        end;

      finally
        CloseHandle(fileHandle);

        // In case of error, delete any file created
        if not(allOK) then
          begin
          DeleteFile(filename);
          end;
      end;

      end;  // if (fileHandle<>INVALID_HANDLE_VALUE) then

  finally
    FreeMem(buffer);
  end;

  Result := allOK;
end;
*)


// ----------------------------------------------------------------------------
// Get special directory.
// See CSIDL_DESKTOP, etc consts in ShlObj
function SDUGetSpecialFolderPath(const CSIDL: integer): string;
var
  pidl: PItemIDList;
  retVal: array [0..MAX_PATH] of char;
  ifMalloc: IMalloc;
begin
  retVal := '';
  if Succeeded((SHGetSpecialFolderLocation(0, CSIDL, pidl))) then
    begin
    if (SHGetPathFromIDList(pidl, retVal)) then
      begin
      if Succeeded(ShGetMalloc(ifMalloc)) then
        begin                
        ifMalloc.Free(pidl);
        ifMalloc := nil;
        end;
      end;
    end;
    
  Result := retVal;
end;


// ----------------------------------------------------------------------------
// Get the Windows directory
function SDUGetWindowsDirectory(): string;
var
  retVal: array [0..MAX_PATH] of char;
begin
  Windows.GetWindowsDirectory(retVal, sizeof(retVal));
  Result := retVal;
end;


// ----------------------------------------------------------------------------
// Convert boolean value to string/char
function SDUBoolToStr(value: boolean; strTrue: string = 'True'; strFalse: string = 'False'): string;
begin
  Result := SDUBooleanToStr(value, strTrue, strFalse);

end;

function SDUBooleanToStr(value: boolean; strTrue: string = 'True'; strFalse: string = 'False'): string;
var
  retVal: string;
begin
  retVal := strFalse;
  if value then
    begin
    retVal := strTrue;
    end;
    
  Result := retVal;
end;

function SDUBoolToChar(value: boolean; chars: string = 'TF'): char;
begin
  Result := SDUBooleanToChar(value, chars);
end;

function SDUBooleanToChar(value: boolean; chars: string = 'TF'): char;
var
  retVal: char;
begin
  // Sanity check
  if (length(chars) < 2) then
    begin
    raise Exception.Create('Exactly zero or two characters must be passed to BoolToChar');
    end;

  retVal := chars[2];
  if value then
    begin
    retVal := chars[1];
    end;
    
  Result := retVal;
end;

// ----------------------------------------------------------------------------
function SDUFloatTrunc(X: double; decimalPlaces: integer): double;
var
  multiplier: extended;
begin
  multiplier := Power(10, decimalPlaces);
  Result := (trunc(x * multiplier)) / multiplier;
end;

// ----------------------------------------------------------------------------
function SDUFormatUnits(
                     Value: int64;
                     denominations: array of string;
                     multiplier: integer = 1000;
                     accuracy: integer = 2
                    ): string;
var
  retVal: string;
  z: double;
  useUnits: string;
  unitsIdx: integer;
  absValue: int64;
  unitsDiv: int64;
begin
  absValue := abs(Value);

  // Identify the units to be used
  unitsIdx := 0;
  unitsDiv := 1;
  while (
         (absValue >= (unitsDiv * multiplier)) and
         (unitsIdx < high(denominations))
        ) do
    begin
    inc(unitsIdx);
    unitsDiv := unitsDiv * multiplier;
    end;

  useUnits := '';
  if (
      (unitsIdx > low(denominations)) and
      (unitsIdx < high(denominations))
     ) then
  begin
    useUnits := denominations[unitsIdx];
  end;

  if (unitsIdx = 0) then
    begin
    accuracy := 0;
    end;

  z := SDUFloatTrunc((Value / unitsDiv), accuracy);

  retVal := Format('%.'+inttostr(accuracy)+'f', [z]) + ' ' + useUnits;

  Result := retVal;
end;

// ----------------------------------------------------------------------------
procedure SDUCenterControl(control: TControl; align: TCenterControl);
begin
  if (
      (align <> ccNone) and
      (control <> nil)
     ) then
    begin
    if (control.Parent <> nil) then
      begin
      if (
          (align = ccHorizontal) or
          (align = ccBoth)
         ) then
        begin
        control.Left := ((control.Parent.Width - control.Width) div 2);
        end;

      if (
          (align = ccVertical) or
          (align = ccBoth)
         ) then
        begin
        control.Top := ((control.Parent.Height - control.Height) div 2);
        end;

      end;
    end;

end;

// ----------------------------------------------------------------------------
// Generate all permutations of the characters in "pool"
// Crude, but effective; there's probably a much more efficient way of
// implementing this.
procedure SDUPermutate(pool: string; lst: TStringList);
var
  i, j: integer;
  tmpLst: TStringList;
  tmpPool: string;
  startChar: char;
begin
  if length(pool) = 1 then
    begin
    lst.add(pool);
    end
  else
    begin
    tmpLst:= TStringList.Create();
    try
      for i:=1 to length(pool) do
        begin
        tmpPool := pool;
        startChar := pool[i];
        delete(tmpPool, i, 1);

        tmpLst.Clear();
        SDUPermutate(tmpPool, tmpLst);

        for j:=0 to (tmpLst.count-1) do
          begin
          lst.Add(startChar + tmpLst[j]);
          end;

        end;
    finally
      tmpLst.Free();
    end;
    end;
    
end;


// ----------------------------------------------------------------------------
// Calculate x! (factorial X)
function SDUFactorial(x: integer): LARGE_INTEGER;
var
  retVal: LARGE_INTEGER;
  i: integer;
begin
  retVal.QuadPart := 1;

  if (x = 0) then
    begin
    retVal.QuadPart := 0;
    end;

  for i:=1 to x do
    begin
    retVal.QuadPart := retVal.QuadPart * i;

{$IFOPT Q+}
    if (retVal.QuadPart <= 0) then
      begin
      raise EIntOverflow.Create('Overflow when calculating '+inttostr(i)+'!');
      end;
{$ENDIF}
    end;

  Result := retVal;
end;


// ----------------------------------------------------------------------------
// Draw a piechart on the specified canvas within specified bounds
procedure SDUSimplePieChart(
                         ACanvas: TCanvas;
                         Bounds: TRect;
                         Percent: integer;
                         ColourFg: TColor = clRed;
                         ColorBg: TColor = clGreen
                        );
var
  centerVert, certHoriz: integer;
  Th: double;
  a, o: double;
begin
  // Draw entire "pie"
  if (Percent >= 100) then
    begin
    ACanvas.brush.color := ColourFg;
    end
  else
    begin
    ACanvas.brush.color := ColorBg;
    end;
    
  ACanvas.ellipse(Bounds);
  

  // We only draw a slice if there's a slice to be drawn (e.g. it's not zero,
  // or the entire pie)
  if (
      (Percent > 0) and
      (Percent < 100)
     ) then
    begin
    // Calculate slice
    Th := (Percent/100) * (2 * pi);  // Convert percentage into radians

    a := sin(Th) * 100;
    o := cos(Th) * 100;

    centerVert := Bounds.top + ((Bounds.bottom-Bounds.top) div 2);
    certHoriz  := Bounds.left + ((Bounds.right-Bounds.left) div 2);


    // Draw slice
    ACanvas.brush.color := ColourFg;
    ACanvas.pie(
                // Bounds of entire pie
                Bounds.left,
                Bounds.top,
                Bounds.right,
                Bounds.bottom,

                // X, Y of first line from center
                certHoriz + round(a),
                centerVert + -round(o), // We subtract "o" as co-ordinate Y=0
                                        // it at the top, Y=100 is at the bottom

                // X, Y of top center of the pie
                Bounds.left + ((Bounds.right-Bounds.left) div 2), Bounds.top,
              );
    end;

end;


// ----------------------------------------------------------------------------
function SDUXOR(a: string; b: string): string;
var
  retval: string;
  longest: integer;
  byteA: byte;
  byteB: byte;
  i: integer;
begin
  retval := '';

  longest := max(length(a), length(b));
  for i:=1 to longest do
    begin
    if (i > length(a)) then
      begin
      byteA := 0;
      end
    else
      begin
      byteA := ord(a[i]);
      end;

    if (i > length(b)) then
      begin
      byteB := 0;
      end
    else
      begin
      byteB := ord(b[i]);
      end;

    retval := retval + char(byteA XOR byteB);
    end;

  Result := retval;
end;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------

END.


