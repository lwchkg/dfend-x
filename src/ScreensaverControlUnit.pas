unit ScreensaverControlUnit;
interface

uses Classes, ExtCtrls;

Type TScreensaverControl=class
  private
    HandleList : TList;
    OrigScreensaverStatus : Boolean;
    Timer : TTimer;
    Procedure TimerWork(Sender : TObject);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure DOSBoxStarted(DOSBoxHandle : THandle; const DisableScreensaver : Boolean);
end;

Var ScreensaverControl : TScreensaverControl;

implementation

uses Windows, CommonTools, PrgSetupUnit;

{ TScreensaverControl }

constructor TScreensaverControl.Create;
begin
  inherited Create;
  HandleList:=TList.Create;
  Timer:=TTimer.Create(nil);
  with Timer do begin
    OnTimer:=TimerWork;
    Interval:=1000;
    Enabled:=True;
  end;
end;

destructor TScreensaverControl.Destroy;
begin
  Timer.Free;
  HandleList.Free;
  inherited Destroy;
end;

procedure TScreensaverControl.DOSBoxStarted(DOSBoxHandle: THandle; const DisableScreensaver : Boolean);
Var NewHandle : THandle;
begin
  If HandleList.Count=0 then OrigScreensaverStatus:=GetScreensaverAllowStatus;
  DuplicateHandle(GetCurrentProcess,DOSBoxHandle,GetCurrentProcess,@NewHandle,0,False,DUPLICATE_SAME_ACCESS);
  HandleList.Add(Pointer(NewHandle));
  If (HandleList.Count=1) and DisableScreensaver then SetScreensaverAllowStatus(False);
end;

procedure TScreensaverControl.TimerWork(Sender: TObject);
Var I : Integer;
begin
  If HandleList.Count=0 then exit;

  I:=0;
  While I<HandleList.Count do begin
    If (THandle(HandleList[I])<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(THandle(HandleList[I]),0)=WAIT_OBJECT_0) then begin
      HandleList.Delete(I);
      continue;
    end;
    inc(I);
  end;

  If HandleList.Count=0 then SetScreensaverAllowStatus(OrigScreensaverStatus);
end;

initialization
  ScreensaverControl:=TScreensaverControl.Create;
finalization
  ScreensaverControl.Free;
end.
