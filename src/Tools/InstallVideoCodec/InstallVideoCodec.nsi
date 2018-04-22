; NSI SCRIPT FOR INSTALLING THE DOSBOX VIDEO CODEC
; ============================================================



; Initial settings
; ============================================================

!packhdr "$%TEMP%\exehead.tmp" '..\..\Install\Tools\upx.exe "$%TEMP%\exehead.tmp"'
RequestExecutionLevel admin
SetCompressor /solid lzma

Name "D-Fend Reloaded DOSBox video codec installer"
Caption "D-Fend Reloaded DOSBox video codec installer"
OutFile "InstallVideoCodec.exe"
Icon "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"



; Include used librarys
; ============================================================

!include "InstallVideoCodecUtilities.nsi"



; Install codec
; ============================================================

Function .onInit
  SetSilent silent
FunctionEnd

Section "-InstallCodec"
  SectionIn RO
  
  ; Command line given ?
  Call GetParameters ; Pushes parameter on stack
  Pop $0
  
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors we_9x we_nt
  
  we_nt:
  IfFileExists "$0\zmbv\zmbv.inf" 0 we_nt2
  Exec '"rundll32" setupapi,InstallHinfSection DefaultInstall 128 $0\zmbv\zmbv.inf'
  goto end
  
  we_nt2:
  IfFileExists "$0\Video Codec\zmbv.inf" 0 end
  Exec '"rundll32" setupapi,InstallHinfSection DefaultInstall 128 $0\Video Codec\zmbv.inf'
  goto end
  
  we_9x:
  IfFileExists "$0\zmbv\zmbv.inf" 0 we_9x2
  Exec '"rundll32" setupx.dll,InstallHinfSection DefaultInstall 128 $0\zmbv\zmbv.inf'
  goto end
  
  we_9x2:
  IfFileExists "$0\Video Codec\zmbv.inf" 0 end
  Exec '"rundll32" setupx.dll,InstallHinfSection DefaultInstall 128 $0\Video Codec\zmbv.inf'
  goto end  
  
  end:
SectionEnd