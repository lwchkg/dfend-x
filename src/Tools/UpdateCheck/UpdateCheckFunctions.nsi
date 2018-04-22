Var DefaultParameter

Var MessageCannotFindFile
Var MessageDownloadFailed
Var MessageDownloadFailedBeforeURL
Var MessageDownloadFailedAfterURL
Var MessageDownload1
Var MessageDownload2
Var MessageDownload3
Var MessageDownload4
Var MessageDownload5
Var MessageDownload6
Var MessageDownload7
Var MessageDownload8

Var MessageBoxOK
Var MessageBoxYes
Var MessageBoxNo

Function CheckParameter ; Checks if string on top of stack is empty and replaces it with DefaultParameter if empty(no changes to stack)
  Exch $R0
  StrCmp $R0 "" 0 CmdCheckOK
  StrCpy $R0 $DefaultParameter
  CmdCheckOK:
  Exch $R0
FunctionEnd

Function FileCheck ; Check if file on top of stack exists (no changes to stack)
  Exch $R0
  IfFileExists "$R0" FileExistsOK
  ;MessageBox MB_OK "$MessageCannotFindFile: $R0"
  Pop $0 ; Otherwise the plugin will not work correctl
  messagebox::show MB_SETFOREGROUND|MB_DEFBUTTON4|MB_TOPMOST "D-Fend Reloaded Update Checker" "" "$MessageCannotFindFile: $R0" "$MessageBoxOK"
  Quit
  FileExistsOK:
  Exch $R0
FunctionEnd

Function DownloadFile ; Downloads from top of stack to second stack filename; third stack value =1 means "not silent" otherwise silend (removes all three from stack)
  ; see http://nsis.sourceforge.net/Inetc_plug-in
  
  Pop $R1
  Pop $R2
  Pop $R3

  StrCmp $R3 1 0 StartSilentDownload
  SetSilent normal
  inetc::get /POPUP "$R1" /CAPTION "D-Fend Reloaded Update" /TRANSLATE "$MessageDownload1" "$MessageDownload2" "$MessageDownload3" "$MessageDownload4" "$MessageDownload5" "$MessageDownload6" "$MessageDownload7" "$MessageDownload8" "$R1" "$R2"
  SetSilent silent
  Goto CheckDownload
  StartSilentDownload:
  inetc::get "$R1" "$R2"
  
  CheckDownload:
  Pop $R0
  StrCmp $R0 "OK" DownloadOK
  StrCmp $R0 "SendRequest Error" NotAvailable ShowErrorMessage
  NotAvailable:
  StrCpy $R0 "$MessageDownloadFailedBeforeURL $R1 $MessageDownloadFailedAfterURL"
  ShowErrorMessage:
  ;MessageBox MB_OK "$MessageDownloadFailed: $R0"
  messagebox::show MB_SETFOREGROUND|MB_DEFBUTTON1|MB_TOPMOST "D-Fend Reloaded Update Checker" "" "$MessageDownloadFailed: $R0" $MessageBoxOK
  Quit
  DownloadOK:

  Push $R2
  Call FileCheck
  Pop $R2
FunctionEnd  

!macro ReadLine StoreVar
  FileRead $R0 ${StoreVar}
  Push ${StoreVar}
  Call TrimNewlines
  Pop ${StoreVar}
!macroend