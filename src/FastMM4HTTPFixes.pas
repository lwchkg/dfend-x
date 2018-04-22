unit FastMM4HTTPFixes;
interface

implementation

uses FastMM4, IdThreadSafe, IdGlobal;

initialization
  RegisterExpectedMemoryLeak(TIdThreadSafeInteger,1);
  RegisterExpectedMemoryLeak(TIdCriticalSection,2);
end.
