Name "D-Fend Reloaded - launch program as admin helper"

VIAddVersionKey "ProductName" "D-Fend Reloaded - launch program as admin helper"
VIAddVersionKey "Comments" "D-Fend Reloaded is a Frontend for DOSBox"
VIAddVersionKey "CompanyName" "Written by Alexander Herzog"
VIAddVersionKey "LegalCopyright" "Licensed under the GPL v3"
VIAddVersionKey "FileDescription" "D-Fend Reloaded - launch program as admin helper"
VIProductVersion "1.0.0.0"
VIAddVersionKey "FileVersion" "1.0.0.0"

!packhdr "$%TEMP%\exehead.tmp" '..\..\Install\Tools\upx.exe "$%TEMP%\exehead.tmp"'
RequestExecutionLevel admin
SetCompressor /solid lzma

OutFile "AdminLauncher.exe"
Icon "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"

!include FileFunc.nsh
!insertmacro GetParameters
!insertmacro GetOptions

Function .onInit
  SetSilent silent
  SetAutoClose true

  ${GetParameters} $R0
  ClearErrors
  ${GetOptions} $R0 /run= $2
  ${GetOptions} $R0 /dir= $1
  ${GetOptions} $R0 /driver= $3
FunctionEnd

Section "-InstallCodec"
  SectionIn RO

  StrLen $4 $3
  IntCmp $4 2 noEnv noEnv
  System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("SDL_VIDEODRIVER", "$3").r0'
  noEnv:
  
  SetOutPath $1
  Exec '$2'
SectionEnd