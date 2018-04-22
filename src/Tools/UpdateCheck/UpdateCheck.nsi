; NSI SCRIPT FOR D-FEND RELOADED UPDATE-CHECK
; ============================================================



; Initial settings
; ============================================================

!addplugindir "."
!packhdr "$%TEMP%\exehead.tmp" '..\..\Install\Tools\upx.exe "$%TEMP%\exehead.tmp"'
RequestExecutionLevel user
SetCompressor /solid lzma

Name "D-Fend Reloaded Update Checker"
Caption "D-Fend Reloaded Update Checker"
OutFile "UpdateCheck.exe"
Icon "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"



; Include used librarys
; ============================================================

!include "WordFunc.nsh"
!insertmacro VersionCompare
!include "UpdateCheckUtilities.nsi"
!include "UpdateCheckFunctions.nsi"



; Read config file and server update info file
; ============================================================

Function .onInit
  SetSilent silent
  
  StrCpy $MessageBoxOK "Ok"
  StrCpy $MessageBoxYes "Yes"
  StrCpy $MessageBoxNo "No"
  StrCpy $MessageCannotFindFile "Cannot find file"
FunctionEnd

Var CurrentVersion
Var ServerVersion
Var UpdateInfoFileURL
Var SetupTempFile
Var UpdateInfoFile
Var UpdateFileURL
Var SilentOnNoUpdateAvail
Var UpdateInstallDir

Var MessageCannotRead
Var MessageNoUpdates
Var MessageUpdate1
Var MessageUpdate2

Function ReadSetupFile
  Exch $R1
  Push $R0
  Push $R2
  
  ClearErrors
  FileOpen $R0 "$R1" r
  IfErrors 0 SetupFileOpened
  MessageBox MB_OK "Cannot read $R1" ; Not localizeable, setup file not read at this point
  Quit
  SetupFileOpened:
  
  !insertmacro ReadLine $CurrentVersion
  !insertmacro ReadLine $UpdateInfoFileURL
  !insertmacro ReadLine $SetupTempFile
  !insertmacro ReadLine $UpdateInstallDir
  
  !insertmacro ReadLine $R2
  StrCmp $R2 "SILENT" 0 NotReadSilent
  IntOp $SilentOnNoUpdateAvail 1 + 0
  Goto ReadSilentFinish
  NotReadSilent:
  IntOp $SilentOnNoUpdateAvail 0 + 0
  ReadSilentFinish: 
  
  !insertmacro ReadLine $MessageCannotFindFile
  !insertmacro ReadLine $MessageDownloadFailed
  !insertmacro ReadLine $MessageDownloadFailedBeforeURL
  !insertmacro ReadLine $MessageDownloadFailedAfterURL
  !insertmacro ReadLine $MessageDownload1
  !insertmacro ReadLine $MessageDownload2
  !insertmacro ReadLine $MessageDownload3
  !insertmacro ReadLine $MessageDownload4
  !insertmacro ReadLine $MessageDownload5
  !insertmacro ReadLine $MessageDownload6
  !insertmacro ReadLine $MessageDownload7
  !insertmacro ReadLine $MessageDownload8
  
  !insertmacro ReadLine $MessageCannotRead
  !insertmacro ReadLine $MessageNoUpdates
  !insertmacro ReadLine $MessageUpdate1
  !insertmacro ReadLine $MessageUpdate2
  
  !insertmacro ReadLine $MessageBoxOK
  !insertmacro ReadLine $MessageBoxYes
  !insertmacro ReadLine $MessageBoxNo

  FileClose $R0  
  Pop $R2
  Pop $R0
  Pop $R1
  
  StrCpy $SetupTempFile "$Temp\$SetupTempFile"
FunctionEnd

Function ReadUpdateInfoFile
  Push $R0

  ; Read update info file
  ClearErrors
  FileOpen $R0 "$UpdateInfoFile" r
  IfErrors 0 UpdateInfoOpened
  ;MessageBox MB_OK "$MessageCannotRead $UpdateInfoFile"
  Pop $0 ; Otherwise the plugin will not work correctl
  messagebox::show MB_SETFOREGROUND|MB_DEFBUTTON1|MB_TOPMOST "D-Fend Reloaded Update Checker" "" "$MessageCannotRead $UpdateInfoFile" $MessageBoxOK
  Quit
  UpdateInfoOpened:
  !insertmacro ReadLine $ServerVersion
  !insertmacro ReadLine $UpdateFileURL
  FileClose $R0
  
  ; Delete update info file
  Delete "$UpdateInfoFile"

  Pop $R0
FunctionEnd

 
; Define default parameter and update info temp files
; ============================================================

Section "-SetConsts"
  SectionIn RO
  
  StrCpy $DefaultParameter "UpdateCheck.txt"
  StrCpy $UpdateInfoFile "$Temp\UpdateCheckInfo.tmp"
SectionEnd



; Check for Updates and download and run
; ============================================================

Section "-Work"
  SectionIn RO
  
  ; Command line given ?
  Call GetParameters ; Pushes parameter on stack
  Call CheckParameter ; Checks string on top of stack empty (no changes to stack)
  
  ; Read setup file
  Call FileCheck ; Check if file on top of stack exists (no changes to stack)
  Call ReadSetupFile ; Read file on top of stack to globals vars (removes filename from stack)
 
  ; Download update info file
  IntOp $R0 0 + 0
  Push $R0
  Push $UpdateInfoFile
  Push $UpdateInfoFileURL
  Call DownloadFile
  
  ; Read update info file
  Call ReadUpdateInfoFile

  ; Check if file on server is newer
  ${VersionCompare} $ServerVersion $CurrentVersion $R0
  IntCmp $R0 1 UpdateAvail
  IntCmp $SilentOnNoUpdateAvail 1 QuitWithOutMessage
  ;MessageBox MB_OK "$MessageNoUpdates"
  messagebox::show MB_SETFOREGROUND|MB_DEFBUTTON1|MB_TOPMOST "D-Fend Reloaded Update Checker" "" "$MessageNoUpdates" $MessageBoxOK
  
  QuitWithOutMessage:  
  Quit
  UpdateAvail:
  ;MessageBox MB_YESNO "$MessageUpdate1 $ServerVersion $MessageUpdate2" IDYES DoUpdate
  messagebox::show MB_SETFOREGROUND|MB_DEFBUTTON2|MB_TOPMOST "D-Fend Reloaded Update Checker" "" "$MessageUpdate1 $ServerVersion $MessageUpdate2" $MessageBoxYes $MessageBoxNo
  Pop $R0
  IntCmp $R0 1 DoUpdate
  Quit
  DoUpdate:
  
  ; Download update file
  IntOp $R0 0 + 1
  Push $R0
  Push $SetupTempFile
  Push $UpdateFileURL
  Call DownloadFile  

  ; Run update file
  Exec '"$SetupTempFile" /A /D=$UpdateInstallDir'
  
  ; Delete update file
  Delete /REBOOTOK "$SetupTempFile"
SectionEnd