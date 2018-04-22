unit SingleInstanceUnit;
interface

Function InstanceRunning(var hEvent : THandle) : Boolean;

implementation

uses Windows, Forms;

Function InstanceRunning(var hEvent : THandle) : Boolean;
const EventName='DFR-running';
begin
  result:=False;
  try
    hEvent:=OpenEvent(EVENT_ALL_ACCESS,False,EventName);
    If hEvent<>0 then begin
      SetEvent(hEvent);
      CloseHandle(hEvent);
      hEvent:=0;
      result:=True;
      Application.Terminate;
      exit;
    end;
    hEvent:=CreateEvent(nil,False,False,EventName);
  except end;
end;

end.
