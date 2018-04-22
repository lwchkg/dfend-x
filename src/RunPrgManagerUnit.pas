unit RunPrgManagerUnit;
interface

uses ExtCtrls, GameDBUnit;

Type TRunPrgRecord=record
  Commands : String;
  CommandMinimized : Boolean;
  CommandParallel : Boolean;
  WaitHandle : THandle;
end;

Type TRunPrgManager=class
  private
    Timer : TTimer;
    List : Array of TRunPrgRecord;
    Function GetCount : Integer;
    Procedure TimerWork(Sender : TObject);
    function GetData(I: Integer): TRunPrgRecord;
    Function RunCommandAndGetHandle(const Command : String; const Minimized : Boolean) : THandle;
    Procedure RunCommand(const Command : String; const Wait, Minimized : Boolean);
    Procedure RunCommands(const Commands : String; const Wait, Parallel, Minimized : Boolean);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure RunBeforeExecutionCommand(const AGame : TGame);
    Procedure AddCommand(const AGame : TGame; const AHandle : THandle);
    property Count : Integer read GetCount;
    property Data[I : Integer] : TRunPrgRecord read GetData;
end;

var RunPrgManager : TRunPrgManager;

implementation

uses Classes, Windows, Dialogs, Forms, SysUtils, ShellAPI, LanguageSetupUnit, CommonTools;

{ TRunPrgManager }

constructor TRunPrgManager.Create;
begin
  inherited Create;
  Timer:=TTimer.Create(nil);
  with Timer do begin
    OnTimer:=TimerWork;
    Interval:=1000;
    Enabled:=True;
  end;
end;

destructor TRunPrgManager.Destroy;
begin
  Timer.Free;
  inherited Destroy;
end;

procedure TRunPrgManager.RunBeforeExecutionCommand(const AGame: TGame);
begin
  RunCommands(AGame.CommandBeforeExecution,AGame.CommandBeforeExecutionWait,AGame.CommandBeforeExecutionParallel,AGame.CommandBeforeExecutionMinimized);
end;

procedure TRunPrgManager.AddCommand(const AGame: TGame; const AHandle: THandle);
Var S : String;
    I : Integer;
    NewHandle : THandle;
begin
  S:=Trim(AGame.CommandAfterExecution);
  If S='' then exit;

  I:=length(List);
  SetLength(List,I+1);
  List[I].Commands:=S;
  List[I].CommandMinimized:=AGame.CommandAfterExecutionMinimized;
  List[I].CommandParallel:=AGame.CommandAfterExecutionParallel;
  DuplicateHandle(GetCurrentProcess,AHandle,GetCurrentProcess,@NewHandle,0,False,DUPLICATE_SAME_ACCESS);
  List[I].WaitHandle:=NewHandle;
end;

function TRunPrgManager.GetCount: Integer;
begin
  result:=length(List);
end;

function TRunPrgManager.GetData(I: Integer): TRunPrgRecord;
begin
  result:=List[I];
end;

procedure TRunPrgManager.TimerWork(Sender: TObject);
Var I,J : Integer;
begin
  Timer.Enabled:=False;
  try
    I:=0;
    while I<length(List) do begin
      If (List[I].WaitHandle<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(List[I].WaitHandle,0)=WAIT_OBJECT_0) then begin
        RunCommands(List[I].Commands,False,List[I].CommandParallel,List[I].CommandMinimized);
        For J:=I+1 to length(List)-1 do List[J-1]:=List[J];
        SetLength(List,length(List)-1);
        continue;
      end;
      inc(I);
    end;
  finally
    Timer.Enabled:=True;
  end;
end;

Function TRunPrgManager.RunCommandAndGetHandle(const Command : String; const Minimized : Boolean) : THandle;
Var StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  result:=INVALID_HANDLE_VALUE;

  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;

  If Minimized then begin
    StartupInfo.dwFlags:=StartupInfo.dwFlags or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow:=SW_MINIMIZE;
  end;

  If not CreateProcess(nil,PChar(Command),nil,nil,False,0,nil,nil,StartupInfo,ProcessInformation) then begin
    If GetLastError=ERROR_BAD_EXE_FORMAT then begin
      if ShellExecute(Application.Handle,'open',PChar(Command),nil,nil,SW_SHOW)>32 then exit;
    end;
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[Command]),mtError,[mbOK],0);
    exit;
  end;

  result:=ProcessInformation.hThread;
  CloseHandle(ProcessInformation.hProcess);
end;

Procedure TRunPrgManager.RunCommand(const Command : String; const Wait, Minimized : Boolean);
Var H : THandle;
begin
  H:=RunCommandAndGetHandle(Command,Minimized);
  If H<>INVALID_HANDLE_VALUE then begin
    If Wait then WaitForSingleObject(H,INFINITE);
    CloseHandle(H);
  end;
end;

Procedure TRunPrgManager.RunCommands(const Commands : String; const Wait, Parallel, Minimized : Boolean);
Var St : TStringList;
    S : String;
    I : Integer;
    L : TList;
    H : THandle;
    B : Boolean;
begin
  St:=StringToStringList(Commands);
  try
    If Parallel then begin
      L:=TList.Create;
      try
        For I:=0 to St.Count-1 do begin
          S:=Trim(St[I]);
          If S='' then continue;
          H:=RunCommandAndGetHandle(S,Minimized);
          If H<>INVALID_HANDLE_VALUE then L.Add(Pointer(H));
        end;
        If Wait then begin
          repeat
            B:=True;
            For I:=0 to L.Count-1 do If not (WaitForSingleObject(THandle(L[I]),100)=WAIT_OBJECT_0) then B:=False;
          until B;
        end;
        For I:=0 to L.Count-1 do CloseHandle(THandle(L[I]));
      finally
        L.Free;
      end;
    end else begin
      I:=0; While I<St.Count do If Trim(St[I])='' then St.Delete(I) else inc(I);
      For I:=0 to St.Count-1 do begin
        RunCommand(Trim(St[I]),Wait or (I<St.Count-1),Minimized);
      end;
    end;
  finally
    St.Free;
  end;
end;

initialization
  RunPrgManager:=TRunPrgManager.Create;
finalization
  RunPrgManager.Free;
end.
