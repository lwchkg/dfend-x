; NSI SCRIPT FOR D-FEND RELOADED
; ============================================================

!include VersionSettings.nsi
!insertmacro VersionData
!define INST_FILENAME "Setup.exe"

!include CommonTools.nsi



; Register custom page definitions for different languages
; ============================================================

!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
ReserveFile "Languages\ioFileBrazilian_Portuguese.ini"
ReserveFile "Languages\ioFileCzech.ini"
ReserveFile "Languages\ioFileDanish.ini"
ReserveFile "Languages\ioFileDutch.ini"
ReserveFile "Languages\ioFileEnglish.ini"
ReserveFile "Languages\ioFileFrench.ini"
ReserveFile "Languages\ioFileGerman.ini"
ReserveFile "Languages\ioFileItalian.ini"
ReserveFile "Languages\ioFilePolish.ini"
ReserveFile "Languages\ioFileRussian.ini"
ReserveFile "Languages\ioFileSimplified_Chinese.ini"
ReserveFile "Languages\ioFileSpanish.ini"
ReserveFile "Languages\ioFileTraditional_Chinese.ini"
ReserveFile "Languages\ioFileTurkish.ini"

ReserveFile "Languages\ioFile2Brazilian_Portuguese.ini"
ReserveFile "Languages\ioFile2Czech.ini"
ReserveFile "Languages\ioFile2Danish.ini"
ReserveFile "Languages\ioFile2Dutch.ini"
ReserveFile "Languages\ioFile2English.ini"
ReserveFile "Languages\ioFile2French.ini"
ReserveFile "Languages\ioFile2German.ini"
ReserveFile "Languages\ioFile2Italian.ini"
ReserveFile "Languages\ioFile2Polish.ini"
ReserveFile "Languages\ioFile2Russian.ini"
ReserveFile "Languages\ioFile2Simplified_Chinese.ini"
ReserveFile "Languages\ioFile2Spanish.ini"
ReserveFile "Languages\ioFile2Traditional_Chinese.ini"
ReserveFile "Languages\ioFile2Turkish.ini"



; Settings for the modern user interface (MUI)
; ============================================================

Var FastInstallationMode

Function AbortIfFastMode
  IntCmp $FastInstallationMode 1 AbortPage ShowPage
  AbortPage:
  Abort
  ShowPage:
FunctionEnd

!insertmacro MUI_PAGE_WELCOME
; !insertmacro MUI_PAGE_LICENSE $(LANGNAME_License)
Page custom InstallMode
Page custom InstallType 
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortIfFastMode
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortIfFastMode
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro UninstallerPages
!insertmacro LanguageSetup



; Definition of install sections
; ============================================================

!insertmacro CommonSections

Section "$(LANGNAME_DFendReloaded)" ID_DFend
  SectionIn RO
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDFendReloaded)"
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR"  
  SetDetailsPrint none
  
  ; Installation type
  ; ($InstallDataType=0 <=> Prg dir mode, $InstallDataType=1 <=> User dir mode; in user dir mode $DataInstDir will contain the data directory otherwise $INSTDIR)
  
  IntCmp $InstallDataType 1 UserDataDir
  strcpy $DataInstDir $INSTDIR
  Goto StartInstall
  UserDataDir:
  strcpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  StartInstall:
  
  ; Store installation folder in registry if not portable installation
  
  IntCmp $InstallDataType 2 NoRegistryWhenUSBStickInstall
  WriteRegStr HKLM "Software\D-Fend Reloaded" "ProgramFolder" "$INSTDIR"
  WriteRegStr HKLM "Software\D-Fend Reloaded" "DataFolder" "$DataInstDir"
  NoRegistryWhenUSBStickInstall:
  
  ; Install main files

  SetOutPath "$INSTDIR"
  File "..\DFend.exe"
  
  SetOutPath "$INSTDIR\Bin"
  File "..\Bin\mkdosfs.exe"  
  File "..\Bin\oggenc2.exe"
  File "..\Bin\License.txt"
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

  SetOutPath "$INSTDIR\Lang"
  File "..\Lang\*.ini"
  File "..\Lang\*.chm"
  File "..\Lang\Readme_OperationMode.txt"

  SetOutPath "$INSTDIR\IconSets"
  File /r /x Thumbs.db "..\IconSets\*.*"
  Delete "$INSTDIR\IconSets\Modern\Thumbs.db"
  
  SetOutPath "$DataInstDir\Settings"
  File "..\Bin\Cheats.xml"

  ; Remove files in $INSTDIR for which the new position is $INSTDIR\Bin or $INSTDIR\Lang
  
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

  ; Install templates  
  
  IntCmp $InstallDataType 1 WriteNewUserDir
  
    SetOutPath "$DataInstDir\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$DataInstDir\Templates"
    File "..\NewUserData\Templates\*.prof"
	
    SetOutPath "$DataInstDir\AutoSetup"
    File "..\NewUserData\AutoSetup\*.prof"

    SetOutPath "$DataInstDir\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$DataInstDir\Settings"
    File "..\NewUserData\Icons.ini"
	File "..\Tools\DataReaderServer\DataReader.xml"
  
  Goto TemplateWritingFinish
  WriteNewUserDir:  

    SetOutPath "$INSTDIR\NewUserData\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$INSTDIR\NewUserData\Templates"
    File "..\NewUserData\Templates\*.prof"
	
    SetOutPath "$INSTDIR\NewUserData\AutoSetup"
    File "..\NewUserData\AutoSetup\*.prof"

    SetOutPath "$INSTDIR\NewUserData\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$INSTDIR\NewUserData"
    File "..\NewUserData\Icons.ini"
	File "..\Tools\DataReaderServer\DataReader.xml"

  TemplateWritingFinish:
  
  ; Write installation mode to DFend.dat
  
  ClearErrors
  FileOpen $0 $INSTDIR\DFend.dat w
  IfErrors InstTypeEnd
  IntCmp $InstallDataType 0 InstType0
  IntCmp $InstallDataType 1 InstType1
  FileWrite $0 "PORTABLEMODE"
  Goto InstTypeClose
  InstType0:
  FileWrite $0 "PRGDIRMODE"
  Goto InstTypeClose
  InstType1:
  FileWrite $0 "USERDIRMODE"
  InstTypeClose:
  FileClose $0
  InstTypeEnd:
  
  ; Create uninstaller and start menu entries
  
  IntCmp $InstallDataType 2 NoDFendStartMenuLinks
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallStartMenu)"
  SetDetailsPrint listonly
  SetShellVarContext all
  SetOutPath "$SMPROGRAMS"  
  SetDetailsPrint none  
  
  SetOutPath "$INSTDIR"
  WriteUninstaller "Uninstall.exe"
  
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_DFendReloaded).lnk" "$INSTDIR\DFend.exe"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_Uninstall).lnk" "$INSTDIR\Uninstall.exe"
  CreateDirectory $DataInstDir\VirtualHD ; Has to be created before the start menu link is created otherwise the link will never work
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_GamesFolder).lnk" "$DataInstDir\VirtualHD\"
  CreateDirectory $DataInstDir\GameData ; Has to be created before the start menu link is created otherwise the link will never work
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_GameDataFolder).lnk" "$DataInstDir\GameData\"
  CreateDirectory $DataInstDir\Capture ; Has to be created before the start menu link is created otherwise the link will never work
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_CaptureFolder).lnk" "$DataInstDir\Capture\"  
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayName" "${PrgName} ($(LANGNAME_Deinstall))"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "UninstallString" '"$INSTDIR\Uninstall.exe"'  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayIcon" "$INSTDIR\DFend.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "Publisher" "Alexander Herzog"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
  WriteRegDWord HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "NoModify" 1
  WriteRegDWord HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "NoRepair" 1
  
  !insertmacro AddToGamesExplorer

  NoDFendStartMenuLinks:
SectionEnd



SectionGroup "$(LANGNAME_DOSBox)" ID_DosBox
  
Section "$(LANGNAME_ProgramFiles)" ID_DosBoxProgramFiles
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDOSBox)"
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
  
  IntCmp $InstallDataType 2 NoDosBoxStartMenuLinks
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox"
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Video"
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Configuration"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox.lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-conf $\"$INSTDIR\DosBox\dosbox.conf$\"" "$INSTDIR\DosBox\DOSBox.exe" 0
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox (noconsole).lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-noconsole -conf $\"$INSTDIR\DosBox\dosbox.conf$\"" "$INSTDIR\DosBox\DOSBox.exe" 0
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox manual.lnk" "$INSTDIR\DOSBox\DOSBox 0.74 Manual.txt"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Capture folder.lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-opencaptures explorer.exe"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Video\Video instructions.lnk" "$INSTDIR\DOSBox\Video Codec\Video Instructions.txt"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Configuration\Edit Configuration.lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-editconf notepad.exe -editconf $\"%SystemRoot%\system32\notepad.exe$\" -editconf $\"%WINDIR%\notepad.exe$\""
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Configuration\Reset Configuration.lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-eraseconf"
  
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors we_9x we_nt
  we_nt:  
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DosBox\Video\Install movie codec.lnk" "rundll32" "setupapi,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\Video Codec\zmbv.inf"
  goto end
  we_9x:
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DosBox\Video\Install movie codec.lnk" "rundll" "setupx.dll,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\Video Codec\zmbv.inf"
  end:
  NoDosBoxStartMenuLinks:
SectionEnd

Section "$(LANGNAME_LanguageFiles)" ID_DosBoxLanguageFiles
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDOSBoxLanguage)"
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\DOSBox"
  SetDetailsPrint none

  SetOutPath "$INSTDIR\DOSBox"
  File "..\DosBoxLang\*.*"
SectionEnd

Section "$(LANGNAME_VideoCodec)" ID_DosBoxVideoCodec
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDOSBoxCodec)"
  SetDetailsPrint listonly

  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors we_9x2 we_nt2
  we_nt2:
  Exec '"rundll32" setupapi,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\Video Codec\zmbv.inf'
  goto end2
  we_9x2:
  Exec '"rundll32" setupx.dll,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\Video Codec\zmbv.inf'
  end2:
  
  SetDetailsPrint none
SectionEnd
 
SectionGroupEnd



SectionGroup "$(LANGNAME_Tools)" ID_Tools

Section "$(LANGNAME_FreeDosTools)" ID_FreeDosTools
  SetDetailsPrint both  
  DetailPrint "$(LANGNAME_InstallFreeDOS)"
  SetDetailsPrint listonly
  
  IntCmp $InstallDataType 1 FreeDOSToNewUserDir
    SetOutPath "$DataInstDir\VirtualHD\FREEDOS"
  Goto FreeDOSWritingStart
  FreeDOSToNewUserDir:
    SetOutPath "$INSTDIR\NewUserData\FREEDOS"
  FreeDOSWritingStart:
  
  SetDetailsPrint none
  File /r "..\NewUserData\FREEDOS\*.*"
SectionEnd

Section "$(LANGNAME_Doszip)" ID_Doszip
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
SectionEnd

SectionGroupEnd



Section "$(LANGNAME_DesktopShortcut)" ID_DesktopShortcut
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDesktopShortcut)"
  SetDetailsPrint listonly
  SetShellVarContext all
  CreateShortCut "$DESKTOP\$(LANGNAME_DFendReloaded).lnk" "$INSTDIR\DFend.exe" 
SectionEnd



; Definition of NSIS functions
; ============================================================

!macro ExtractInstallOptionFiles
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileBrazilian_Portuguese.ini" "ioFileBrazilian_Portuguese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileCzech.ini" "ioFileCzech.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileDanish.ini" "ioFileDanish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileDutch.ini" "ioFileDutch.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileEnglish.ini" "ioFileEnglish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileFrench.ini" "ioFileFrench.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileGerman.ini" "ioFileGerman.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileItalian.ini" "ioFileItalian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFilePolish.ini" "ioFilePolish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileRussian.ini" "ioFileRussian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileSimplified_Chinese.ini" "ioFileSimplified_Chinese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileSpanish.ini" "ioFileSpanish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileTraditional_Chinese.ini" "ioFileTraditional_Chinese.ini"  
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileTurkish.ini" "ioFileTurkish.ini"
 
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Brazilian_Portuguese.ini" "ioFile2Brazilian_Portuguese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Czech.ini" "ioFile2Czech.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Danish.ini" "ioFile2Danish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Dutch.ini" "ioFile2Dutch.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2English.ini" "ioFile2English.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2French.ini" "ioFile2French.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2German.ini" "ioFile2German.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Italian.ini" "ioFile2Italian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Polish.ini" "ioFile2Polish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Russian.ini" "ioFile2Russian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Simplified_Chinese.ini" "ioFile2Simplified_Chinese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Spanish.ini" "ioFile2Spanish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Traditional_Chinese.ini" "ioFile2Traditional_Chinese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Turkish.ini" "ioFile2Turkish.ini"
!macroend

!insertmacro CommonUACCode

Var FONT

!macro ActivateSection SectionID
  SectionGetFlags ${SectionID} $R0
  IntOp $R0 $R0 | 0x00000001
  SectionSetFlags ${SectionID} $R0
!macroend

!macro DeactivateSection SectionID
  SectionGetFlags ${SectionID} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${SectionID} $R0
!macroend

Function InstallMode
  IntOp $FastInstallationMode 0 + 0
  IntCmp $AdminOK 0 InstallModePageFinish
  
  !insertmacro MUI_HEADER_TEXT $(PAGE2_TITLE) $(PAGE2_SUBTITLE)
  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG  "$(LANGNAME_ioFile2)"  
  
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile2)" "Field 1" "HWND"
  CreateFont $FONT "$(^Font)" "$(^FontSize)" "600"
  SendMessage $9 ${WM_SETFONT} $FONT 0
  
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile2)" "Field 5" "HWND"
  CreateFont $FONT "$(^Font)" "$(^FontSize)" "600"
  SendMessage $9 ${WM_SETFONT} $FONT 0  

  !insertmacro MUI_INSTALLOPTIONS_SHOW

  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile2)" "Field 5" "State"
  IntCmp $9 1 CreateShortCutFile2On
  !insertmacro DeactivateSection ${ID_DesktopShortcut}
  Goto CreateShortCutFile2Done
  CreateShortCutFile2On:
  !insertmacro ActivateSection ${ID_DesktopShortcut}
  CreateShortCutFile2Done:

  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile2)" "Field 1" "State"
  IntCmp $9 1 FastMode
  Goto InstallModePageFinish
  FastMode:  
  !insertmacro ActivateSection ${ID_DosBox}
  !insertmacro ActivateSection ${ID_DosBoxProgramFiles}
  !insertmacro ActivateSection ${ID_DosBoxLanguageFiles}
  !insertmacro ActivateSection ${ID_DosBoxVideoCodec}
  !insertmacro ActivateSection ${ID_Tools}
  !insertmacro ActivateSection ${ID_FreeDosTools}
  !insertmacro ActivateSection ${ID_Doszip}
  StrCpy $INSTDIR "$PROGRAMFILES\D-Fend Reloaded\"
  IntOp $InstallDataType 1 + 0
  IntOp $FastInstallationMode 1 + 0
  InstallModePageFinish:
FunctionEnd

Function InstallType
  IntCmp $FastInstallationMode 1 EndSel

  !insertmacro MUI_HEADER_TEXT $(PAGE_TITLE) $(PAGE_SUBTITLE)
  
  IntCmp $AdminOK 1 NoInstallrestrictions 
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 1" "Flags" "DISABLED"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 3" "State" "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 3" "Flags" "DISABLED"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 5" "State" "1"
  NoInstallrestrictions:
  
  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG  "$(LANGNAME_ioFile)"  
  
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile)" "Field 3" "HWND"
  CreateFont $FONT "$(^Font)" "$(^FontSize)" "600"
  SendMessage $9 ${WM_SETFONT} $FONT 0  
  
  !insertmacro MUI_INSTALLOPTIONS_SHOW

  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile)" "Field 1" "State"
  IntCmp $9 0 Next1
  IntOp $InstallDataType 0 + 0
  Goto EndSel
  
  Next1:
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile)" "Field 3" "State"
  IntCmp $9 0 Next2
  IntOp $InstallDataType 1 + 0
  Goto EndSel  
  
  Next2:
  IntOp $InstallDataType 2 + 0
  SectionGetFlags ${ID_DesktopShortcut} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DesktopShortcut} $R0    
  
  SectionGetFlags ${ID_DosBoxVideoCodec} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxVideoCodec} $R0

  StrCpy $INSTDIR "$DESKTOP\D-Fend Reloaded\"
  
  EndSel:
FunctionEnd

Function .onSelChange
  IntCmp $InstallDataType 2 NoDesktopShortcut
  Goto NextSelChangeCheck
  
  NoDesktopShortcut:  
  
  SectionGetFlags ${ID_DesktopShortcut} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DesktopShortcut} $R0
  
  SectionGetFlags ${ID_DosBoxVideoCodec} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxVideoCodec} $R0  
  
  NextSelChangeCheck:

  SectionGetFlags ${ID_DosBoxProgramFiles} $R0
  IntOp $R0 $R0 & 1
  IntCmp $R0 1 End
  
  SectionGetFlags ${ID_DosBoxLanguageFiles} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxLanguageFiles} $R0
    
  SectionGetFlags ${ID_DosBoxVideoCodec} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxVideoCodec} $R0
	
  End:
FunctionEnd



; Link between install sections and descriptions
; ============================================================

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DFend} $(DESC_DFend)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBox} $(DESC_DosBox)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxProgramFiles} $(DESC_DosBoxProgramFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxLanguageFiles} $(DESC_DosBoxLanguageFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxVideoCodec} $(DESC_VideoCodec)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_Tools} $(DESC_Tools)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_FreeDosTools} $(DESC_FreeDosTools)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_Doszip} $(DESC_Doszip)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DesktopShortcut} $(DESC_DesktopShortcut)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

