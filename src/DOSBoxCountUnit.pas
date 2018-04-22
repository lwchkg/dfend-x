unit DOSBoxCountUnit;
interface

uses Classes, GameDBUnit;

Type TPrgCounter=class
  private
    FList : TList;
    Function GetCount : Integer;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Add(const DOSBoxHandle : THandle);
    property Count : Integer read GetCount;
end;

Var DOSBoxCounter : TPrgCounter;
    ScummVMCounter : TPrgCounter;
    WindowsGameCounter : TPrgCounter;

var LastDOSBoxStartTime : Cardinal =0;
    LastDOSBoxProfile : TGame =nil;

implementation

uses Windows;

{ TPrgCounter }

constructor TPrgCounter.Create;
begin
  inherited Create;
  FList:=TList.Create;
end;

destructor TPrgCounter.Destroy;
Var I : Integer;
begin
  For I:=0 to FList.Count-1 do CloseHandle(THandle(FList[I]));
  FList.Free;
  inherited Destroy;
end;

procedure TPrgCounter.Add(const DOSBoxHandle: THandle);
Var NewHandle : THandle;
begin
  DuplicateHandle(GetCurrentProcess,DOSBoxHandle,GetCurrentProcess,@NewHandle,0,False,DUPLICATE_SAME_ACCESS);
  If NewHandle<>INVALID_HANDLE_VALUE then FList.Add(Pointer(NewHandle));
end;

function TPrgCounter.GetCount: Integer;
Var I : Integer;
begin
  I:=0;
  While I<FList.Count do begin
    If WaitForSingleObject(THandle(FList[I]),0)=WAIT_OBJECT_0 then begin
      CloseHandle(THandle(FList[I])); FList.Delete(I); continue;
    end;
    inc(I);
  end;

  result:=FList.Count;
end;

initialization
  DOSBoxCounter:=TPrgCounter.Create;
  ScummVMCounter:=TPrgCounter.Create;
  WindowsGameCounter:=TPrgCounter.Create;
finalization
  DOSBoxCounter.Free;
  ScummVMCounter.Free;
  WindowsGameCounter.Free;
end.
