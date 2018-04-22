; NSI SCRIPT FOR D-FEND RELOADED (UPDATE)
; ============================================================

!include VersionSettings.nsi
!insertmacro VersionData
!define INST_FILENAME "UpdateSetup.exe"
!define Update
!include CommonTools.nsi



; Settings for the modern user interface (MUI)
; ============================================================

!include FileFunc.nsh
!insertmacro GetParameters
!insertmacro GetOptions

!define MUI_PAGE_CUSTOMFUNCTION_PRE SkipPageIfAutoUpdate
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_PRE SkipPageIfAutoUpdate
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_PAGE_CUSTOMFUNCTION_PRE SkipPageAndCloseIfAutoUpdate
!insertmacro MUI_PAGE_FINISH

!insertmacro UninstallerPages
!insertmacro LanguageSetup

Function SkipPageIfAutoUpdate
	${GetParameters} $R0
    ClearErrors
    ${GetOptions} $R0 /A $R0
    IfErrors +2 0
	Abort
FunctionEnd

Function SkipPageAndCloseIfAutoUpdate
	${GetParameters} $R0
    ClearErrors
    ${GetOptions} $R0 /A $R0
    IfErrors ShowFinishPage 0
	Call ExecAppFile
	Abort
	ShowFinishPage:
FunctionEnd



; Definition of install sections
; ============================================================

!insertmacro CommonSections

Section "$(LANGNAME_DFendReloaded)" ID_DFend
  SectionIn RO
  
  SetDetailsPrint none
  
  ; Read installation type
  ; ($InstallDataType=0 <=> Prg dir mode, $InstallDataType=1 <=> User dir mode; in user dir mode $DataInstDir will contain the data directory otherwise $INSTDIR)
  
  IfFileExists "$INSTDIR\DFend.dat" StartCheck
  MessageBox MB_OK "$(LANGNAME_NoInstallationFound)"
  Quit
  StartCheck:  
  StrCpy $DataInstDir $INSTDIR  
  ClearErrors
  FileOpen $0 $INSTDIR\DFend.dat r
  IfErrors ReadInstTypeEnd
  FileRead $0 $1
  FileClose $0
  StrCmp $1 "USERDIRMODE" InstUserMode
  IntOp $InstallDataType 0 + 0
  Goto ReadInstTypeEnd
  InstUserMode:
  IntOp $InstallDataType 0 + 1
  strcpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  ReadInstTypeEnd:
  
  ; Update main files
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_UpdateDFendReloaded)"

  SetDetailsPrint listonly
  SetOutPath "$INSTDIR"
  SetDetailsPrint none  
  File "..\DFend.exe"
  
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\Bin"  
  SetDetailsPrint none  
  File "..\Bin\oggenc2.exe"
  File "..\Bin\mkdosfs.exe"
  File "..\Bin\LicenseComponents.txt"
  File "..\Bin\Links.txt"
  File "..\Bin\SearchLinks.txt"
  File "..\Bin\ChangeLog.txt"
  File "..\Bin\D-Fend Reloaded DataInstaller.nsi"  
  File "..\Bin\UpdateCheck.exe"
  File "..\Bin\SetInstallerLanguage.exe"
  File "..\Bin\7za.dll"
  File "..\Bin\DelZip179.dll"
  File "..\Bin\mediaplr.dll"
  File "..\Bin\InstallVideoCodec.exe"
  File "..\Bin\AdminLauncher.exe"
  IntCmp $InstallDataType 2 +2
  File "..\Bin\DFendGameExplorerData.dll"
  
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\Lang"
  SetDetailsPrint none  
  File "..\Lang\*.ini"
  File "..\Lang\*.chm"
  File "..\Lang\Readme_OperationMode.txt"

  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\IconSets"
  SetDetailsPrint none  
  File /r /x Thumbs.db "..\IconSets\*.*"
  Delete "$INSTDIR\IconSets\Modern\Thumbs.db"
  
  SetDetailsPrint listonly
  SetOutPath "$DataInstDir\Settings"
  SetDetailsPrint none
  File "..\Bin\Cheats.xml"
  
  ; Remove files in $INSTDIR for which the new position is $INSTDIR\Bin or $INSTDIR\Lang
  
  IfFileExists "$INSTDIR\License.txt" 0 +2
    CopyFiles /SILENT "$INSTDIR\License.txt" "$INSTDIR\Bin\License.txt"
   
  Delete "$INSTDIR\oggenc2.exe"
  Delete "$INSTDIR\LicenseComponents.txt"
  Delete "$INSTDIR\License.txt"  
  IntCmp $InstallDataType 0 KeepSettingsFilesIfPrgDirIsUserDir  
  Delete "$INSTDIR\Links.txt"
  Delete "$INSTDIR\SearchLinks.txt"
  KeepSettingsFilesIfPrgDirIsUserDir:
  Delete "$INSTDIR\ChangeLog.txt"
  Delete "$INSTDIR\D-Fend Reloaded DataInstaller.nsi"
  Delete "$INSTDIR\SetInstallerLanguage.exe"
  Delete "$INSTDIR\UpdateCheck.exe"
  Delete "$INSTDIR\7za.dll"
  Delete "$INSTDIR\DelZip179.dll"
  Delete "$INSTDIR\InstallVideoCodec.exe"
  Delete "$INSTDIR\mkdosfs.exe"
  Delete "$INSTDIR\mediaplr.dll"
  Delete "$INSTDIR\Readme_OperationMode.txt"
  
  ; Update templates

  IntCmp $InstallDataType 1 WriteNewUserDir
    ; Prg dir mode -> Update files directly

	SetDetailsPrint listonly
    SetOutPath "$DataInstDir\AutoSetup"
	SetDetailsPrint none
    File "..\NewUserData\AutoSetup\*.prof"	
	
    SetOutPath "$DataInstDir\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$DataInstDir\Templates"
    File "..\NewUserData\Templates\*.prof"

    SetOutPath "$DataInstDir\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$DataInstDir\Settings"
    File "..\NewUserData\Icons.ini"
	File "..\Tools\DataReaderServer\DataReader.xml"

  Goto TemplateWritingFinish
  WriteNewUserDir:  
    ; User dir mode -> Update files in NewUserData folder

	SetDetailsPrint listonly
    SetOutPath "$INSTDIR\NewUserData\AutoSetup"
	SetDetailsPrint none
    File "..\NewUserData\AutoSetup\*.prof"

    SetOutPath "$INSTDIR\NewUserData\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$INSTDIR\NewUserData\Templates"
    File "..\NewUserData\Templates\*.prof"

    SetOutPath "$INSTDIR\NewUserData\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$INSTDIR\NewUserData"
    File "..\NewUserData\Icons.ini"
	File "..\Tools\DataReaderServer\DataReader.xml"
	
	; Copy FreeDOS files to NewUserData directory
	
	IfFileExists "$DataInstDir\VirtualHD\FREEDOS\*.*" 0 TemplateWritingFinish
	IfFileExists "$INSTDIR\NewUserData\FREEDOS\*.*" TemplateWritingFinish
	
	CreateDirectory "$INSTDIR\NewUserData\FREEDOS"
	CopyFiles /SILENT "$DataInstDir\VirtualHD\FREEDOS\*.*" "$INSTDIR\NewUserData\FREEDOS\"

  TemplateWritingFinish:
  
  ; Install DOSZip
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDOSZip)"
  SetDetailsPrint listonly

  IntCmp $InstallDataType 1 DoszipToNewUserDir
    SetOutPath "$DataInstDir\VirtualHD\DOSZIP"
  Goto DoszipWritingStart
  DoszipToNewUserDir:
    SetOutPath "$INSTDIR\NewUserData\DOSZIP"
  DoszipWritingStart:
  
  SetDetailsPrint none
  File /r "..\NewUserData\DOSZIP\*.*"
  
  IntCmp $InstallDataType 2 NoUninstallerUpdate
  
  ; Update uninstaller
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_UpdateUninstaller)"
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR"
  SetDetailsPrint none
  
  WriteUninstaller "Uninstall.exe"
  SetShellVarContext all
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
  
  !insertmacro AddToGamesExplorer
  
  NoUninstallerUpdate:
  
  ; Update DOSBox installation
  
  IfFileExists "$INSTDIR\DOSBox\*.*" 0 NoDOSBoxUpdate
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_UpdateDOSBox)"
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\DOSBox"
  SetDetailsPrint none
  
  SetOutPath "$INSTDIR\DOSBox"
  Delete "$INSTDIR\DOSBox\README.txt"
  Delete "$INSTDIR\DOSBox\COPYING.txt"
  Delete "$INSTDIR\DOSBox\THANKS.txt"
  Delete "$INSTDIR\DOSBox\NEWS.txt"
  Delete "$INSTDIR\DOSBox\AUTHORS.txt"
  Delete "$INSTDIR\DOSBox\INSTALL.txt"
  RmDir /r "$INSTDIR\DOSBox\zmbv"
  
  File "..\DOSBox\DOSBox.exe"
  File "..\DOSBox\dosbox.conf"
  File "..\DOSBox\SDL.dll"
  File "..\DOSBox\SDL_net.dll"
  File "..\DOSBox\DOSBox 0.74 Manual.txt"
  File "..\DOSBox\DOSBox 0.74 Options.bat"
  File "..\DOSBox\Reset KeyMapper.bat"
  File "..\DOSBox\Reset Options.bat"
  File "..\DOSBox\Screenshots & Recordings.bat"
  
  File "..\NewUserData\FREEDOS\CPI\*.*"
  
  SetOutPath "$INSTDIR\DOSBox\Video Codec"
  File "..\DOSBox\Video Codec\*.*"
  
  SetOutPath "$INSTDIR\DOSBox\Documentation"
  File "..\DOSBox\Documentation\*.*"  

  SetOutPath "$INSTDIR\DOSBox"
  File "..\DosBoxLang\*.*"
  
  File "..\NewUserData\FREEDOS\CPI\*.*"
  
  NoDOSBoxUpdate:
SectionEnd



; Definition of NSIS functions
; ============================================================

!macro ExtractInstallOptionFiles
!macroend

!insertmacro CommonUACCode