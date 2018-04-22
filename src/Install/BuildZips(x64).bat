@echo off

rem Create main zip archive
"C:\Program Files\7-Zip\7z.exe" a -r D-Fend-Reloaded-.zip "C:\Users\Alexander Herzog\Desktop\D-Fend Reloaded\"

rem Create mini zip archive
md "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)"
xcopy "%USERPROFILE%\Desktop\D-Fend Reloaded" "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)" /E

del "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\DOSBox\*.*" /S /Q
rd "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\DOSBox" /S /Q

del "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\VirtualHD\DOSZip\*.*" /S /Q
rd "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\VirtualHD\DOSZip" /S /Q

del "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\VirtualHD\FREEDOS\*.*" /S /Q
rd "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\VirtualHD\FREEDOS" /S /Q

"C:\Program Files\7-Zip\7z.exe" a -r D-Fend-Reloaded--Mini.zip "C:\Users\Alexander Herzog\Desktop\D-Fend Reloaded (mini)\"

del "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)\*.*" /S /Q
rd "%USERPROFILE%\Desktop\D-Fend Reloaded (mini)" /S /Q 

rem Create portable apps package
xcopy "%USERPROFILE%\Desktop\D-Fend Reloaded" "..\Tools\PortableApps package\D-Fend Reloaded Portable\App\D-Fend Reloaded\" /E

"C:\Program Files (x86)\NSIS\makensis.exe" "..\Tools\PortableApps package\D-Fend Reloaded Portable\Other\Launcher Source\PortableAppsLauncher.nsi"
"C:\Program Files (x86)\NSIS\makensis.exe" "..\Tools\PortableApps package\D-Fend Reloaded Portable\Other\Installer Source\PortableApps.comInstaller.nsi"

copy "..\Tools\PortableApps package\*.exe" .
del "..\Tools\PortableApps package\*.exe"
del "..\Tools\PortableApps package\D-Fend Reloaded Portable\D-Fend Reloaded Portable.exe"

del "..\Tools\PortableApps package\D-Fend Reloaded Portable\App\D-Fend Reloaded\*.*" /S /Q
rd "..\Tools\PortableApps package\D-Fend Reloaded Portable\App\D-Fend Reloaded" /S /Q
md "..\Tools\PortableApps package\D-Fend Reloaded Portable\App\D-Fend Reloaded"

rem Create source archive
del "..\DFend.exe" 
del "..\*.dcu" /Q
del "..\*.~*" /Q
"C:\Program Files\7-Zip\7z.exe" a -r -i!Install\Tools\*.exe -xr-!Install\*.exe -x!Install\*.zip D-Fend-Reloaded--Source.zip "..\"

rem Clean up
del "%USERPROFILE%\Desktop\D-Fend Reloaded\*.*" /S /Q
rd "%USERPROFILE%\Desktop\D-Fend Reloaded" /S /Q 