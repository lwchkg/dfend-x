1. Compile D-Fend Reloaded.

2. Set version information in VersionSettings.nsi.
3. Set version information in ..\Tools\PortableApps package\D-Fend Reloaded Portable\App\AppInfo\appinfo.ini.
4. Set version information in ..\Tools\PortableApps package\D-Fend Reloaded Portable\Other\Installer Source\PortableApps.comInstallerConfig.nsh.

5. Be sure you have 7-Zip (32 or 64 bit depending of your OS type) and NSIS (32 bit) installed.

6. Run BuildInstallers(x86).bat or BuildInstallers(x64).bat depending of your OS type.
7. Use D-Fend-Reloaded-*-Setup.exe to create a portable installation in its default folder. (Do not run the installation!)
8. Run BuildZips(x86).bat or BuildZips(x64).bat depending of your OS type.

9. Rename the 6 new files in this folder to have right version information in their names.