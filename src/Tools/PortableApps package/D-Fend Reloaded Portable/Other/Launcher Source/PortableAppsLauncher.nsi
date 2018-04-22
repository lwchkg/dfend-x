OutFile "..\..\D-Fend Reloaded Portable.exe"
!packhdr "$%TEMP%\exehead.tmp" '..\..\..\..\..\Install\Tools\upx.exe "$%TEMP%\exehead.tmp"'

Name "D-Fend Reloaded PortableApps Launcher"
Caption "D-Fend Reloaded PortableApps Launcher"
RequestExecutionLevel user
SetCompressor /solid lzma
Icon "..\..\App\AppInfo\appicon.ico"

Function .onInit
  SetSilent silent
FunctionEnd

Section "-Work"
  SectionIn RO
  
  Exec ".\App\D-Fend Reloaded\DFend.exe"
SectionEnd