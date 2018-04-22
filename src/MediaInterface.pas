// Copyright(C) Lord Dr. Andrei J. Sagura II von Orechov. All rights reserved.
// Dynamic bind extension by A. Herzog
unit MediaInterface;

interface

{$DEFINE DynamicBind}

uses Windows, Messages;

{$IFDEF DynamicBind}

Function InitMediaPlayerLibrary(const Path : String) : Boolean;

Var  aboutMediaPlayer : function : shortString; stdcall;
     loadMediaFile : function (FileName : shortString; aHandle : THandle) : shortString; stdcall;
     MediaStreamAvailable : function : boolean; stdcall;
     VideoAvailable : function : boolean; stdcall;
     MediaStreamPlayed : function : boolean; stdcall;
     getCoupledVideoHeight : function (Width : integer) : integer; stdcall;
     getVideoWidth : function : integer; stdcall;
     getVideoHeight : function : integer; stdcall;
     getMediaStreamDuration : function : int64; stdcall;
     setVideoPos : function (aLeft, aTop, aWidth, aHeight : integer) : BOOL; stdcall;
     playMediaStream : function : BOOL; stdcall;
     pauseMediaStream : function : BOOL; stdcall;
     stopMediaStream : function : BOOL; stdcall;
     setMediaStreamPos : function (pos : int64) : BOOL; stdcall;
     getMediaStreamPos : function : int64; stdcall;
     freeMediaStream : function : BOOL; stdcall;
     resetMediaStream : function : BOOL; stdcall;
     setFullScreenVideo : function (Full : BOOL) : BOOL; stdcall;
     getFullScreenVideo : function : BOOL; stdcall;
     registerFileType : procedure (aFileType, key, desc, icon, aApplication : shortString); stdcall;
     deregisterFileType : procedure (aFileType : shortString); stdcall;
     getSpecialFolderName : function (aHandle : THandle; nFolder : integer) : shortString; stdcall;
     SoundChipAvailable : function : boolean; stdcall;
     getWaveOutVolume : function : integer; stdcall;
     setWaveOutVolume : procedure (Volume : cardinal); stdcall;
     lnVolume : function (aVolume : integer; aDecades : integer = 1) : integer; stdcall;
     expVolume : function (aVolume : integer; aDecades : integer = 1) : integer; stdcall;
     NotifyOwnerMessage : function (aHandle : THandle; aMsg : TMessage): HResult; stdcall;

var MediaPlayerLibHandle : THandle =0;

{$ELSE}

{$EXTERNALSYM aboutMediaPlayer} function aboutMediaPlayer : shortString; stdcall;
{$EXTERNALSYM loadMediaFile} function loadMediaFile(FileName : shortString; aHandle : THandle) : shortString; stdcall;
{$EXTERNALSYM MediaStreamAvailable} function MediaStreamAvailable : boolean; stdcall;
{$EXTERNALSYM VideoAvailable} function VideoAvailable : boolean; stdcall;
{$EXTERNALSYM MediaStreamPlayed} function MediaStreamPlayed : boolean; stdcall;
{$EXTERNALSYM getCoupledVideoHeight} function getCoupledVideoHeight(Width : integer) : integer; stdcall;
{$EXTERNALSYM getVideoWidth} function getVideoWidth : integer; stdcall;
{$EXTERNALSYM getVideoHeight} function getVideoHeight : integer; stdcall;
{$EXTERNALSYM getMediaStreamDuration} function getMediaStreamDuration : int64; stdcall;
{$EXTERNALSYM setVideoPos} function setVideoPos(aLeft, aTop, aWidth, aHeight : integer) : BOOL; stdcall;
{$EXTERNALSYM playMediaStream} function playMediaStream : BOOL; stdcall;
{$EXTERNALSYM pauseMediaStream} function pauseMediaStream : BOOL; stdcall;
{$EXTERNALSYM stopMediaStream} function stopMediaStream : BOOL; stdcall;
{$EXTERNALSYM setMediaStreamPos} function setMediaStreamPos(pos : int64) : BOOL; stdcall;
{$EXTERNALSYM getMediaStreamPos} function getMediaStreamPos : int64; stdcall;
{$EXTERNALSYM freeMediaStream} function freeMediaStream : BOOL; stdcall;
{$EXTERNALSYM freeMediaStream} function resetMediaStream : BOOL; stdcall;
{$EXTERNALSYM setFullScreenVideo} function setFullScreenVideo(Full : BOOL) : BOOL; stdcall;
{$EXTERNALSYM getFullScreenVideo} function getFullScreenVideo : BOOL; stdcall;
{$EXTERNALSYM registerFileType} procedure registerFileType(aFileType, key, desc, icon, aApplication : shortString); stdcall;
{$EXTERNALSYM deregisterFileType} procedure deregisterFileType(aFileType : shortString); stdcall;
{$EXTERNALSYM getSpecialFolderName} function getSpecialFolderName(aHandle : THandle; nFolder : integer) : shortString; stdcall;
{$EXTERNALSYM SoundChipAvailable} function SoundChipAvailable : boolean; stdcall;
{$EXTERNALSYM getWaveOutVolume} function getWaveOutVolume : integer; stdcall;
{$EXTERNALSYM setWaveOutVolume} procedure setWaveOutVolume(Volume : cardinal); stdcall;
{$EXTERNALSYM lnVolume} function lnVolume(aVolume : integer; aDecades : integer = 1) : integer; stdcall;
{$EXTERNALSYM expVolume} function expVolume(aVolume : integer; aDecades : integer = 1) : integer; stdcall;
{$EXTERNALSYM NotifyOwnerMessage} function NotifyOwnerMessage(aHandle : THandle; aMsg : TMessage): HResult; stdcall;

{$ENDIF}

const mplayer = 'mediaplr.dll';

implementation

uses SysUtils;

{$IFDEF DynamicBind}

Function InitMediaPlayerLibrary(const Path : String) : Boolean;
begin
  if MediaPlayerLibHandle<>0 then begin result:=True; exit; end;

  result:=False;

  {Load library}
  MediaPlayerLibHandle:=LoadLibrary(PChar(mplayer));
  if MediaPlayerLibHandle=0 then MediaPlayerLibHandle:=LoadLibrary(PChar(IncludeTrailingPathDelimiter(Path)+mplayer));
  if MediaPlayerLibHandle=0 then exit; {could not load library}

  {Set function pointer}
  aboutMediaPlayer:=GetProcAddress(MediaPlayerLibHandle,'aboutMediaPlayer');
  loadMediaFile:=GetProcAddress(MediaPlayerLibHandle,'loadMediaFile');
  MediaStreamAvailable:=GetProcAddress(MediaPlayerLibHandle,'MediaStreamAvailable');
  VideoAvailable:=GetProcAddress(MediaPlayerLibHandle,'VideoAvailable');
  MediaStreamPlayed:=GetProcAddress(MediaPlayerLibHandle,'MediaStreamPlayed');
  getCoupledVideoHeight:=GetProcAddress(MediaPlayerLibHandle,'getCoupledVideoHeight');
  getVideoWidth:=GetProcAddress(MediaPlayerLibHandle,'getVideoWidth');
  getVideoHeight:=GetProcAddress(MediaPlayerLibHandle,'getVideoHeight');
  getMediaStreamDuration:=GetProcAddress(MediaPlayerLibHandle,'getMediaStreamDuration');
  setVideoPos:=GetProcAddress(MediaPlayerLibHandle,'setVideoPos');
  playMediaStream:=GetProcAddress(MediaPlayerLibHandle,'playMediaStream');
  pauseMediaStream:=GetProcAddress(MediaPlayerLibHandle,'pauseMediaStream');
  stopMediaStream:=GetProcAddress(MediaPlayerLibHandle,'stopMediaStream');
  setMediaStreamPos:=GetProcAddress(MediaPlayerLibHandle,'setMediaStreamPos');
  getMediaStreamPos:=GetProcAddress(MediaPlayerLibHandle,'getMediaStreamPos');
  freeMediaStream:=GetProcAddress(MediaPlayerLibHandle,'freeMediaStream');
  resetMediaStream:=GetProcAddress(MediaPlayerLibHandle,'resetMediaStream');
  setFullScreenVideo:=GetProcAddress(MediaPlayerLibHandle,'setFullScreenVideo');
  getFullScreenVideo:=GetProcAddress(MediaPlayerLibHandle,'getFullScreenVideo');
  registerFileType:=GetProcAddress(MediaPlayerLibHandle,'registerFileType');
  deregisterFileType:=GetProcAddress(MediaPlayerLibHandle,'deregisterFileType');
  getSpecialFolderName:=GetProcAddress(MediaPlayerLibHandle,'getSpecialFolderName');
  SoundChipAvailable:=GetProcAddress(MediaPlayerLibHandle,'SoundChipAvailable');
  getWaveOutVolume:=GetProcAddress(MediaPlayerLibHandle,'getWaveOutVolume');
  setWaveOutVolume:=GetProcAddress(MediaPlayerLibHandle,'setWaveOutVolume');
  lnVolume:=GetProcAddress(MediaPlayerLibHandle,'lnVolume');
  expVolume:=GetProcAddress(MediaPlayerLibHandle,'expVolume');
  NotifyOwnerMessage:=GetProcAddress(MediaPlayerLibHandle,'NotifyOwnerMessage');

  {Check all pointer set correctly}
  result:=
    Assigned(aboutMediaPlayer) and
    Assigned(loadMediaFile) and
    Assigned(MediaStreamAvailable) and
    Assigned(VideoAvailable) and
    Assigned(MediaStreamPlayed) and
    Assigned(getCoupledVideoHeight) and
    Assigned(getVideoWidth) and
    Assigned(getVideoHeight) and
    Assigned(getMediaStreamDuration) and
    Assigned(setVideoPos) and
    Assigned(playMediaStream) and
    Assigned(pauseMediaStream) and
    Assigned(stopMediaStream) and
    Assigned(setMediaStreamPos) and
    Assigned(getMediaStreamPos) and
    Assigned(freeMediaStream) and
    Assigned(resetMediaStream) and
    Assigned(setFullScreenVideo) and
    Assigned(getFullScreenVideo) and
    Assigned(registerFileType) and
    Assigned(deregisterFileType) and
    Assigned(getSpecialFolderName) and
    Assigned(SoundChipAvailable) and
    Assigned(getWaveOutVolume) and
    Assigned(setWaveOutVolume) and
    Assigned(lnVolume) and
    Assigned(expVolume) and
    Assigned(NotifyOwnerMessage);

  if not result then begin
    FreeLibrary(MediaPlayerLibHandle);
    MediaPlayerLibHandle:=0;
  end;
end;

initialization
  aboutMediaPlayer:=nil;
  loadMediaFile:=nil;
  MediaStreamAvailable:=nil;
  VideoAvailable:=nil;
  MediaStreamPlayed:=nil;
  getCoupledVideoHeight:=nil;
  getVideoWidth:=nil;
  getVideoHeight:=nil;
  getMediaStreamDuration:=nil;
  setVideoPos:=nil;
  playMediaStream:=nil;
  pauseMediaStream:=nil;
  stopMediaStream:=nil;
  setMediaStreamPos:=nil;
  getMediaStreamPos:=nil;
  freeMediaStream:=nil;
  resetMediaStream:=nil;
  setFullScreenVideo:=nil;
  getFullScreenVideo:=nil;
  registerFileType:=nil;
  deregisterFileType:=nil;
  getSpecialFolderName:=nil;
  SoundChipAvailable:=nil;
  getWaveOutVolume:=nil;
  setWaveOutVolume:=nil;
  lnVolume:=nil;
  expVolume:=nil;
  NotifyOwnerMessage:=nil;
finalization
  If MediaPlayerLibHandle<>0 then FreeLibrary(MediaPlayerLibHandle);
  
{$ELSE}

function aboutMediaPlayer; external mplayer;
function loadMediaFile; external mplayer;
function MediaStreamAvailable; external mplayer;
function VideoAvailable; external mplayer;
function MediaStreamPlayed; external mplayer;
function getCoupledVideoHeight; external mplayer;
function getVideoWidth; external mplayer;
function getVideoHeight; external mplayer;
function getMediaStreamDuration; external mplayer;
function setVideoPos; external mplayer;
function playMediaStream; external mplayer;
function pauseMediaStream; external mplayer;
function stopMediaStream; external mplayer;
function setMediaStreamPos; external mplayer;
function getMediaStreamPos; external mplayer;
function setFullScreenVideo; external mplayer;
function getFullScreenVideo; external mplayer;
function freeMediaStream; external mplayer;
function resetMediaStream; external mplayer;
function NotifyOwnerMessage; external mplayer;

procedure registerFileType; external mplayer;
procedure deregisterFileType; external mplayer;
function getSpecialFolderName; external mplayer;

function SoundChipAvailable; external mplayer;
function getWaveOutVolume; external mplayer;
procedure setWaveOutVolume; external mplayer;
function lnVolume; external mplayer;
function expVolume; external mplayer;

{$ENDIF}

end.

