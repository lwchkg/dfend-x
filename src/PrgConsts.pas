unit PrgConsts;
interface

const DosBoxFileName='DOSBOX.EXE';
      DosBoxConfFileName='DOSBOX.CONF';
      MakeDOSFilesystemFileName='mkdosfs.exe';

      ConfOptFile='ConfOpt.dat';
      ScummVMConfOptFile='ScummVM.dat';
      HistoryFileName='History.dat';
      IconsConfFile='Icons.ini';
      DosBoxDOSProfile='DOSBox DOS';
      RenderTestTempFile='Output.txt';
      ScreenshotsCacheFileName='ScreenshotsThumbnailCache.dat';

      GameListSubDir='Confs';
      IconsSubDir='IconLibrary';
      CaptureSubDir='Capture';
      LanguageSubDir='Lang';
      CustomConfigsSubDir='CustomConfigs';
      TemplateSubDir='Templates';
      AutoSetupSubDir='AutoSetup';
      NewUserDataSubDir='NewUserData';
      PhysFSDefaultWriteDir='PhysWrite';
      ZipTempDir='ZipTemp'; {Subdir of BaseDataDir; ment as base directory for extracting zip file for mounting}
      TempSubFolder='D-Fend Reloaded zip package'; {Subdir fo TempDir; ment for internal use when building/extracting zip packages}
      BinFolder='Bin';
      SettingsFolder='Settings';
      IconSetsFolder='IconSets';

      NSIInstallerHelpFile='D-Fend Reloaded DataInstaller.nsi';

      DFRHomepage='http:/'+'/dfendreloaded.sourceforge.net/';

      OggEncPrgFile='oggenc2.exe';
      LamePrgFile='lame.exe';
      ScummPrgFile='scummvm.exe';
      ScummVMConfFileName='scummvm.ini';
      QBasicPrgFile='QBasic.exe';
      QB45PrgFile='QB.exe';
      QB71PrgFile='QBX.exe';

      PackageDBSubFolder='Settings\Packages';
      PackageDBCacheSubFolder='Settings\Packages\Cache';
      PackageDBMainFileURL=DFRHomepage+'Packages/DFR.xml?version=%s';
      PackageDBTempFile='DFRTemp.xml';
      PackageDBMainFile='DFR.xml';
      PackageDBUserFile='User.xml';
      PackageDBCacheFile='Cache.xml';

      CacheVersionString='DFRCacheFile-FileVersion=005';
      CacheInfoString=#13+#13+'This is just a cache file for the profiles in the current directory. You can'+#13+
                      'ignore or delete this file. D-Fend Reloaded will only load data from this file'+#13+
                      'if the .prof file on disk has not changed. If you delete or change one of the'+#13+
                      '.prof files manually the cache will not be used for this profile. So just'+#13+
                      'ignore this file, you can still do what ever you want in this folder. This'+#13+
                      'cache will never mess up your database.'+#13+#13+
                      'You can turn off the creation of this cache files by setting "BinaryCache=0" in'+#13+
                      'the [ProgramSets] section of the DFend.ini.'+#13+#13+#13+
                      '===Start of binary cache==='+#13;
      CacheFile='Cache.dfr';

      DataReaderUpdateURL=DFRHomepage+'DataReader/DataReader.xml';
      DataReaderConfigFile='DataReader.xml';

      CheatDBFile='Cheats.xml';
      CheatDBSearchSubFolder='Settings\AddressSearch';
      CheatDBUpdateURL=DFRHomepage+'Cheats/Cheats.xml';

      DBGLPackageInfoFile='profiles.xml';

      MinSupportedDOSBoxVersion=0.73;

      DefaultFreeHDSize=250;


const FD10KernelSys='18D296F40F06C8A26EDA606C0031F677';
      FD11KernelSys='A9076CA70EAD7463354B3E4248ECBC21';
      FD10Dos32aExe='A5F5195B509B10228EFE61C47427CA54';
      FD10HimemExe='E3F9A56A9C1BA2656B10E5FE29A37D56';
      FD10Emm386Exe='250C47587506265FBBEA62AE2981BB28';
     

const DefaultInstallerNames : String = 'INSTALL;SETUP;INSTHD;INST;INSTALAR;INSTALLE';
      DefaultArchiveIDFiles : String = 'FILE_ID.DIZ';
      ProgramExts : Array[1..3] of String = ('EXE','COM','BAT');

      IgnoreGameExeFilesIgnore : Array[1..52] of String = (
        'README','DECIDE','DEICE','CATALOG','FACTORY','LIST','LHARC','ARJ',
        'UNARJ','UNZIP','HELPME','ORDER','DEALERS','ULTRAMID','PRINTME',
        'UNIVBE','SWCBBS','INSTHELP','COMMIT','SETMAIN','BOOTMKR','IMUSE',
        'KEYCONFI','32RTM','LOADPATS','MAKESWP','XPHELP','IBMSND','MIDPAK',
        'SBLASTER','ALIVECAT','READDOC','CWSDPMI','PSETD','PSETM','ADLIB',
        'ADLIBG','CMIDPAK','CVXSND','DIGISP','DIGVESA','LANTSND','MULTISND',
        'NOSOUND','PAUDIO','SBCLONE','SBLASTER','SMSND','SNDSYS','VMSND',
        'CWSDPMI','READTHIS'
      );

      SetupExeFilesLevel1 : Array[1..2] of String = ('SETUP','CONFIG');
      SetupExeFilesLevel2 : Array[1..4] of String = ('SETSOUND','SETSND','SETBLAST','SOUND');
      SetupExeFilesLevel3 : Array[1..6] of String = ('XINSTALL','SETUPAQ','SETUPDP','SETUPVC','MSETUP','DSETUP32');
      SetupExeFilesLevel4 : Array[1..1] of String = ('INSTALL');

      ProgramExeFiles : Array[1..1] of String = ('GO');

      AdditionalChecksumDataGoodFileExt : Array[0..11] of String = (
        'EXE','COM','DAT','ICO','HLP','DRV','DLL','PAK','PIC','LFL','BIN','OVL'
      );
      AdditionalChecksumDataExcludeFiles : Array[0..33] of String = (
        'SCORE','DOS4GW','CATALOG','LHARC','ARJ','UNARJ','UNZIP','ORDER',
        'DEALERS','ULTRAMID','UNIVBE','SWCBBS','COMMIT','SETMAIN','IMUSE',
        'CWSDPMI','PSETD','PSETM','ADLIB','ADLIBG','CMIDPAK','CVXSND','DIGISP',
        'DIGVESA','LANTSND','MULTISND','NOSOUND','PAUDIO','SBCLONE','SBLASTER',
        'SMSND','SNDSYS','VMSND','CWSDPMI'
      );

var MainSetupFile : String;
    OperationModeConfig : String;

implementation

uses SysUtils, Forms;

initialization
  MainSetupFile:=ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  OperationModeConfig:=ChangeFileExt(ExtractFileName(Application.ExeName),'.dat');
end.
