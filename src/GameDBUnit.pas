unit GameDBUnit;
interface

{DEFINE SpeedTest}

uses Classes, CommonComponents;

Type TConfOpt=class(TBasePrgSetup)
  public
    Constructor Create;
    Destructor Destroy; override;
    property ResolutionFullscreen : String index 0 read GetString write SetString;
    property ResolutionWindow : String index 1 read GetString write SetString;
    property Joysticks : String index 2 read GetString write SetString;
    property Scale : String index 3 read GetString write SetString;
    property Render : String index 4 read GetString write SetString;
    property Cycles : String index 5 read GetString write SetString;
    property Video : String index 6 read GetString write SetString;
    property Memory : String index 7 read GetString write SetString;
    property Frameskip : String index 8 read GetString write SetString;
    property Core : String index 9 read GetString write SetString;
    property Sblaster : String index 10 read GetString write SetString;
    property Oplmode : String index 11 read GetString write SetString;
    property KeyboardLayout : String index 12 read GetString write SetString;
    property Codepage : String index 13 read GetString write SetString;
    property ReportedDOSVersion : String index 14 read GetString write SetString;
    property MIDIDevice : String index 15 read GetString write SetString;
    property Blocksize : String index 16 read GetString write SetString;
    property CyclesDown : String index 17 read GetString write SetString;
    property CyclesUp : String index 18 read GetString write SetString;
    property Dma : String index 19 read GetString write SetString;
    property GUSDma : String index 20 read GetString write SetString;
    property GUSBase : String index 21 read GetString write SetString;
    property GUSRate : String index 22 read GetString write SetString;
    property HDMA : String index 23 read GetString write SetString;
    property IRQ : String index 24 read GetString write SetString;
    property GUSIRQ : String index 25 read GetString write SetString;
    property MPU401 : String index 26 read GetString write SetString;
    property OPLRate : String index 27 read GetString write SetString;
    property PCRate : String index 28 read GetString write SetString;
    property Rate : String index 29 read GetString write SetString;
    property SBBase : String index 30 read GetString write SetString;
    property MouseSensitivity : String index 31 read GetString write SetString;
    property TandyRate : String index 32 read GetString write SetString;
    property ScummVMFilter : String index 33 read GetString write SetString;
    property ScummVMMusicDriver : String index 34 read GetString write SetString;
    property VGAChipsets : String index 35 read GetString write SetString;
    property VGAVideoRAM : String index 36 read GetString write SetString;
    property ScummVMRenderMode : String index 37 read GetString write SetString;
    property ScummVMPlatform : String index 38 read GetString write SetString;
    property ScummVMLanguages : String index 39 read GetString write SetString;
    property CPUType : String index 40 read GetString write SetString;
    property OplEmu : String index 41 read GetString write SetString;
    property GlideEmulation : String index 42 read GetString write SetString;
    property GlideEmulationPort : String index 43 read GetString write SetString;
    property GlideEmulationLFB : String index 44 read GetString write SetString;
    property InnovaEmulationSampleRate : String index 45 read GetString write SetString;
    property InnovaEmulationBaseAddress : String index 46 read GetString write SetString;
    property InnovaEmulationQuality : String index 47 read GetString write SetString;
    property NE2000EmulationBaseAddress : String index 48 read GetString write SetString;
    property NE2000EmulationInterrupt : String index 49 read GetString write SetString;
    property MT32ReverbMode : String index 50 read GetString write SetString;
    property MT32ReverbTime : String index 51 read GetString write SetString;
    property MT32ReverbLevel : String index 52 read GetString write SetString;
end;

const NR_Name=1;

      NR_Icon=11;
      NR_GameExe=12;
      NR_GameExeMD5=13;
      NR_SetupExe=14;
      NR_SetupExeMD5=15;
      NR_GameParameters=16;
      NR_SetupParameters=17;
      NR_LoadFix=18;
      NR_LoadFixMemory=19;
      NR_CaptureFolder=20;
      NR_ExtraDirs=21;
      NR_ExtraFiles=22;
      NR_LastModification=23;
      NR_ScreenshotListScreenshot=24;
      NR_IgnoreWindowsFileWarnings=25;
      NR_NoDOSBoxFailedDialog=26;

      NR_ExtraPrgFile=30; {30-79}
      NR_ExtraPrgFileParameter=80; {80-129}

      NR_Genre=151;
      NR_Developer=152;
      NR_Publisher=153;
      NR_Year=154;
      NR_DataDir=155;
      NR_Favorite=156;
      NR_Notes=157;
      NR_Language=158;
      NR_UserInfo=159;
      NR_WWW1Name=160;
      NR_WWW1=161;
      NR_WWW2Name=162;
      NR_WWW2=163;
      NR_WWW3Name=164;
      NR_WWW3=165;
      NR_WWW4Name=166;
      NR_WWW4=167;
      NR_WWW5Name=168;
      NR_WWW5=169;
      NR_WWW6Name=170;
      NR_WWW6=171;
      NR_WWW7Name=172;
      NR_WWW7=173;
      NR_WWW8Name=174;
      NR_WWW8=175;
      NR_WWW9Name=176;
      NR_WWW9=177;

      NR_CloseDosBoxAfterGameExit=201;
      NR_ShowConsoleWindow=202;
      NR_StartFullscreen=203;
      NR_AutoLockMouse=204;
      NR_Force2ButtonMouseMode=205;
      NR_SwapMouseButtons=206;
      NR_UseDoublebuffering=207;
      NR_AspectCorrection=208;
      NR_UseScanCodesOld=209;
      NR_UseScanCodes=210;
      NR_MouseSensitivity=211;
      NR_Render=212;
      NR_WindowResolution=213;
      NR_FullscreenResolution=214;
      NR_Scale=215;
      NR_TextModeLines=216;
      NR_Priority=217;
      NR_CustomDOSBoxDir=218;
      NR_CustomKeyMappingFile=219;
      NR_CustomDOSBoxLanguage=220;

      NR_Memory=231;
      NR_XMS=232;
      NR_EMS=233;
      NR_UMB=234;
      NR_Core=235;
      NR_Cycles=236;
      NR_CyclesUp=237;
      NR_CyclesDown=238;
      NR_CPUType=239;
      NR_FrameSkip=240;
      NR_VideoCard=241;
      NR_KeyboardLayout=242;
      NR_Codepage=243;
      NR_Serial1=244;
      NR_Serial2=245;
      NR_Serial3=246;
      NR_Serial4=247;
      NR_IPX=248;
      NR_IPXType=249;
      NR_IPXAddress=250;
      NR_IPXPort=251;
      NR_Use4DOS=252;
      NR_UseDOS32A=253;
      NR_ReportedDOSVersion=254;
      NR_NumLockStatus=255;
      NR_CapsLockStatus=256;
      NR_ScrollLockStatus=257;
      NR_VGAChipset=258;
      NR_VideoRam=259;
      NR_GlideEmulation=260;
      NR_GlidePort=261;
      NR_GlideLFB=262;
      NR_PixelShader=263;

      NR_EnablePrinterEmulation=271;
      NR_PrinterResolution=272;
      NR_PaperWidth=273;
      NR_PaperHeight=274;
      NR_PrinterOutputFormat=275;
      NR_PrinterMultiPage=276;

      NR_NrOfMounts=281;
      NR_Mount0=282;
      NR_Mount1=283;
      NR_Mount2=284;
      NR_Mount3=285;
      NR_Mount4=286;
      NR_Mount5=287;
      NR_Mount6=288;
      NR_Mount7=289;
      NR_Mount8=290;
      NR_Mount9=291;
      NR_AutoMountCDs=292;
      NR_SecureMode=293;

      NR_MixerNosound=301;
      NR_MixerRate=302;
      NR_MixerBlocksize=303;
      NR_MixerPrebuffer=304;
      NR_MixerVolumeMasterLeft=305;
      NR_MixerVolumeMasterRight=306;
      NR_MixerVolumeDisneyLeft=307;
      NR_MixerVolumeDisneyRight=308;
      NR_MixerVolumeSpeakerLeft=309;
      NR_MixerVolumeSpeakerRight=310;
      NR_MixerVolumeGUSLeft=311;
      NR_MixerVolumeGUSRight=312;
      NR_MixerVolumeSBLeft=313;
      NR_MixerVolumeSBRight=314;
      NR_MixerVolumeFMLeft=315;
      NR_MixerVolumeFMRight=316;
      NR_MixerVolumeCDLeft=317;
      NR_MixerVolumeCDRight=318;

      NR_SBType=331;
      NR_SBBase=332;
      NR_SBIRQ=333;
      NR_SBDMA=334;
      NR_SBHDMA=335;
      NR_SBMixer=336;
      NR_SBOplMode=337;
      NR_SBOplRate=338;
      NR_SBOplEmu=339;
      NR_GUS=351;
      NR_GUSRate=352;
      NR_GUSBase=353;
      NR_GUSIRQ=354;
      NR_GUSDMA=355;
      NR_GUSUltraDir=356;
      NR_MIDIType=371;
      NR_MIDIDevice=372;
      NR_MIDIConfig=373;
      NR_MIDIMT32Mode=374;
      NR_MIDIMT32Time=375;
      NR_MIDIMT32Level=376;
      NR_SpeakerPC=381;
      NR_SpeakerRate=382;
      NR_SpeakerTandy=383;
      NR_SpeakerTandyRate=384;
      NR_SpeakerDisney=385;
      NR_JoystickType=386;
      NR_JoystickTimed=387;
      NR_JoystickAutoFire=388;
      NR_JoystickSwap34=389;
      NR_JoystickButtonwrap=390;

      NR_NE2000=401;
      NR_NE2000Base=402;
      NR_NE2000IRQ=403;
      NR_NE2000MACAddress=404;
      NR_NE2000RealInterface=405;

      NR_Innova=411;
      NR_InnovaRate=412;
      NR_InnovaBase=413;
      NR_InnovaQuality=414;

      NR_Autoexec=421;
      NR_AutoexecOverridegamestart=422;
      NR_AutoexecOverrideMount=423;
      NR_AutoexecBootImage=424;
      NR_AutoexecFinalization=425;
      NR_CustomSettings=426;
      NR_Environment=427;

      NR_LastOpenTab=431;
      NR_LastOpenTabModern=432;
      NR_ProfileMode=433;

      NR_ScummVMGame=441;
      NR_ScummVMPath=442;
      NR_ScummVMZip=443;
      NR_ScummVMFilter=444;
      NR_ScummVMRenderMode=445;
      NR_ScummVMAutosave=446;
      NR_ScummVMLanguage=447;
      NR_ScummVMMusicVolume=448;
      NR_ScummVMSpeechVolume=449;
      NR_ScummVMSFXVolume=450;
      NR_ScummVMMIDIGain=451;
      NR_ScummVMSampleRate=452;
      NR_ScummVMMusicDriver=453;
      NR_ScummVMNativeMT32=454;
      NR_ScummVMEnableGS=455;
      NR_ScummVMMultiMIDI=456;
      NR_ScummVMTalkSpeed=457;
      NR_ScummVMSpeechMute=458;
      NR_ScummVMSubtitles=459;
      NR_ScummVMSavePath=460;
      NR_ScummVMConfirmExit=461;
      NR_ScummVMCDROM=462;
      NR_ScummVMJoystickNum=463;
      NR_ScummVMAltIntro=464;
      NR_ScummVMGFXDetails=465;
      NR_ScummVMMusicMute=466;
      NR_ScummVMObjectLabels=467;
      NR_ScummVMReverseStereo=468;
      NR_ScummVMSFXMute=469;
      NR_ScummVMWalkspeed=470;
      NR_ScummVMExtraPath=471;
      NR_ScummVMPlatform=472;
      NR_ScummVMParameters=473;

      NR_CommandBeforeExecution=490;
      NR_CommandAfterExecution=491;
      NR_CommandBeforeExecutionWait=492;
      NR_CommandBeforeExecutionMinimized=493;
      NR_CommandAfterExecutionMinimized=494;
      NR_CommandBeforeExecutionParallel=495;
      NR_CommandAfterExecutionParallel=496;
      NR_RunAsAdmin=497;

      NR_AddtionalChecksumFile1=500;
      NR_AddtionalChecksumFile1Checksum=501;
      NR_AddtionalChecksumFile2=502;
      NR_AddtionalChecksumFile2Checksum=503;
      NR_AddtionalChecksumFile3=504;
      NR_AddtionalChecksumFile3Checksum=505;
      NR_AddtionalChecksumFile4=506;
      NR_AddtionalChecksumFile4Checksum=507;
      NR_AddtionalChecksumFile5=508;
      NR_AddtionalChecksumFile5Checksum=509;


const ScummVMSettings : Array[0..32] of Integer =(
  NR_ScummVMGame, NR_ScummVMPath, NR_ScummVMZip, NR_ScummVMFilter, NR_ScummVMRenderMode, NR_ScummVMAutosave,
  NR_ScummVMLanguage, NR_ScummVMMusicVolume, NR_ScummVMSpeechVolume, NR_ScummVMSFXVolume, NR_ScummVMMIDIGain,
  NR_ScummVMSampleRate, NR_ScummVMMusicDriver, NR_ScummVMNativeMT32, NR_ScummVMEnableGS, NR_ScummVMMultiMIDI,
  NR_ScummVMTalkSpeed, NR_ScummVMSpeechMute, NR_ScummVMSubtitles, NR_ScummVMSavePath, NR_ScummVMConfirmExit,
  NR_ScummVMCDROM, NR_ScummVMJoystickNum, NR_ScummVMAltIntro, NR_ScummVMGFXDetails, NR_ScummVMMusicMute,
  NR_ScummVMObjectLabels, NR_ScummVMReverseStereo, NR_ScummVMSFXMute, NR_ScummVMWalkspeed, NR_ScummVMExtraPath,
  NR_ScummVMPlatform, NR_ScummVMParameters
);

Type TGameDB=class;

     TGame=class(TBasePrgSetup)
  private
    FGameDB : TGameDB;
    Procedure InitData;
    Function GetExtraPrgFile(I : Integer) : String;
    Procedure SetExtraPrgFile(I : Integer; S : String);
    Function GetExtraPrgFileParameter(I : Integer) : String;
    Procedure SetExtraPrgFileParameter(I : Integer; S : String);
    function GetMount(I: Integer): String;
    procedure SetMount(I: Integer; const Value: String);
    Procedure CreateConfFile;
    Function GetLicense : String;
    function GetWWWNameString(I: Integer): String;
    function GetPlainWWWNameString(I: Integer): String;
    function GetWWWString(I: Integer): String;
    procedure SetWWWNameString(I: Integer; const Value: String);
    procedure SetWWWString(I: Integer; const Value: String);
  public
    CacheName, CacheNameUpper : String;
    CacheGenre, CacheGenreUpper : String;
    CacheDeveloper, CacheDeveloperUpper : String;
    CachePublisher, CachePublisherUpper : String;
    CacheYear, CacheYearUpper : String;
    CacheLanguage, CacheLanguageUpper : String;
    CacheUserInfo : String;

    Constructor Create(const ASetupFile : String); overload;
    Constructor CreateDelayed(const ASetupFile : String; const ATimeStampCheck : Boolean);
    Constructor Create(const ABasePrgSetup : TBasePrgSetup); overload;
    Destructor Destroy; override;
    Procedure UpdateFile; override;

    Procedure LoadCache;
    Procedure ReloadINI; override;
    Procedure RenameINI(const NewFile : String); override;
    Procedure AssignFromButKeepScummVMSettings(const AGame : TGame);

    property GameDB : TGameDB read FGameDB write FGameDB;

    property Name : String index NR_Name read GetString write SetString;

    property Icon : String index NR_Icon read GetString write SetString;
    property GameExe : String index NR_GameExe read GetString write SetString;
    property GameExeMD5 : String index NR_GameExeMD5 read GetString write SetString;
    property SetupExe : String index NR_SetupExe read GetString write SetString;
    property SetupExeMD5 : String index NR_SetupExeMD5 read GetString write SetString;
    property GameParameters : String index NR_GameParameters read GetString write SetString;
    property SetupParameters : String index NR_SetupParameters read GetString write SetString;
    property LoadFix : Boolean index NR_LoadFix read GetBoolean write SetBoolean;
    property LoadFixMemory : Integer index NR_LoadFixMemory read GetInteger write SetInteger;
    property CaptureFolder : String index NR_CaptureFolder read GetString write SetString;
    property ExtraDirs : String index NR_ExtraDirs read GetString write SetString;
    property ExtraFiles : String index NR_ExtraFiles read GetString write SetString;
    property LastModification : String index NR_LastModification read GetString write SetString;
    property ScreenshotListScreenshot : String index NR_ScreenshotListScreenshot read GetString write SetString;
    property IgnoreWindowsFileWarnings : Boolean index NR_IgnoreWindowsFileWarnings read GetBoolean write SetBoolean;
    property NoDOSBoxFailedDialog : Boolean index NR_NoDOSBoxFailedDialog read GetBoolean write SetBoolean;

    property ExtraPrgFile[I : Integer] : String read GetExtraPrgFile write SetExtraPrgFile;
    property ExtraPrgFileParameter[I : Integer] : String read GetExtraPrgFileParameter write SetExtraPrgFileParameter;

    property Genre : String index NR_Genre read GetString write SetString;
    property Developer : String index NR_Developer read GetString write SetString;
    property Publisher : String index NR_Publisher read GetString write SetString;
    property Year : String index NR_Year read GetString write SetString;
    property DataDir : String index NR_DataDir read GetString write SetString;
    property Favorite : Boolean index NR_Favorite read GetBoolean write SetBoolean;
    property Notes : String index NR_Notes read GetString write SetString;
    property WWWNamePlain[I : Integer] : String read GetPlainWWWNameString;
    property WWWName[I : Integer] : String read GetWWWNameString write SetWWWNameString;
    property WWW[I : Integer] : String read GetWWWString write SetWWWString;
    property Language : String index NR_Language read GetString write SetString;
    property UserInfo : String index NR_UserInfo read GetString write SetString;
    property License : String read GetLicense;

    property CloseDosBoxAfterGameExit : Boolean index NR_CloseDosBoxAfterGameExit read GetBoolean write SetBoolean;
    property ShowConsoleWindow : Integer index NR_ShowConsoleWindow read GetInteger write SetInteger;
    property StartFullscreen : Boolean index NR_StartFullscreen read GetBoolean write SetBoolean;
    property AutoLockMouse : Boolean index NR_AutoLockMouse read GetBoolean write SetBoolean;
    property Force2ButtonMouseMode : Boolean index NR_Force2ButtonMouseMode read GetBoolean write SetBoolean;
    property SwapMouseButtons : Boolean index NR_SwapMouseButtons read GetBoolean write SetBoolean;
    property UseDoublebuffering : Boolean index NR_UseDoublebuffering read GetBoolean write SetBoolean;
    property AspectCorrection : Boolean index NR_AspectCorrection read GetBoolean write SetBoolean;
    property UseScanCodesOld : Boolean index NR_UseScanCodesOld read GetBoolean write SetBoolean;
    property UseScanCodes : Boolean index NR_UseScanCodes read GetBoolean write SetBoolean;
    property MouseSensitivity : Integer index NR_MouseSensitivity read GetInteger write SetInteger;
    property Render : String index NR_Render read GetString write SetString;
    property WindowResolution : String index NR_WindowResolution read GetString write SetString;
    property FullscreenResolution : String index NR_FullscreenResolution read GetString write SetString;
    property Scale : String index NR_Scale read GetString write SetString;
    property TextModeLines : Integer index NR_TextModeLines read GetInteger write SetInteger;
    property Priority : String index NR_Priority read GetString write SetString;
    property CustomDOSBoxDir : String index NR_CustomDOSBoxDir read GetString write SetString;
    property CustomKeyMappingFile : String index NR_CustomKeyMappingFile read GetString write SetString;
    property CustomDOSBoxLanguage : String index NR_CustomDOSBoxLanguage read GetString write SetString;

    property Memory : Integer index NR_Memory read Getinteger write SetInteger;
    property XMS : Boolean index NR_XMS read GetBoolean write SetBoolean;
    property EMS : Boolean index NR_EMS read GetBoolean write SetBoolean;
    property UMB : Boolean index NR_UMB read GetBoolean write SetBoolean;
    property Core : String index NR_Core read GetString write SetString;
    property Cycles : String index NR_Cycles read GetString write SetString;
    property CyclesUp : Integer index NR_CyclesUp read GetInteger write SetInteger;
    property CyclesDown : Integer index NR_CyclesDown read GetInteger write SetInteger;
    property CPUType : String index NR_CPUType read GetString write SetString;
    property FrameSkip : Integer index NR_FrameSkip read GetInteger write SetInteger;
    property VideoCard : String index NR_VideoCard read GetString write SetString;
    property KeyboardLayout : String index NR_KeyboardLayout read GetString write SetString;
    property Codepage : String index NR_Codepage read GetString write SetString;
    property Serial1 : String index NR_Serial1 read GetString write SetString;
    property Serial2 : String index NR_Serial2 read GetString write SetString;
    property Serial3 : String index NR_Serial3 read GetString write SetString;
    property Serial4 : String index NR_Serial4 read GetString write SetString;
    property IPX : Boolean index NR_IPX read GetBoolean write SetBoolean;
    property IPXType : String index NR_IPXType read GetString write SetString;
    property IPXAddress : String index NR_IPXAddress read GetString write SetString;
    property IPXPort : String index NR_IPXPort read GetString write SetString;
    property Use4DOS : Boolean index NR_Use4DOS read GetBoolean write SetBoolean;
    property UseDOS32A : Boolean index NR_UseDOS32A read GetBoolean write SetBoolean;
    property ReportedDOSVersion : String index NR_ReportedDOSVersion read GetString write SetString;
    property NumLockStatus : String index NR_NumLockStatus read GetString write SetString;
    property CapsLockStatus : String index NR_CapsLockStatus read GetString write SetString;
    property ScrollLockStatus : String index NR_ScrollLockStatus read GetString write SetString;
    property VGAChipset : String index NR_VGAChipset read GetString write SetString;
    property VideoRam : Integer index NR_VideoRam read GetInteger write SetInteger;
    property GlideEmulation : String index NR_GlideEmulation read GetString write SetString;
    property GlidePort : String index NR_GlidePort read GetString write SetString;
    property GlideLFB : String index NR_GlideLFB read GetString write SetString;
    property PixelShader : String index NR_PixelShader read GetString write SetString;

    property EnablePrinterEmulation : Boolean index NR_EnablePrinterEmulation read GetBoolean write SetBoolean;
    property PrinterResolution : Integer index NR_PrinterResolution read GetInteger write SetInteger;
    property PaperWidth : Integer index NR_PaperWidth read GetInteger write SetInteger;
    property PaperHeight : Integer index NR_PaperHeight read GetInteger write SetInteger;
    property PrinterOutputFormat : String index NR_PrinterOutputFormat read GetString write SetString;
    property PrinterMultiPage : Boolean index NR_PrinterMultiPage read GetBoolean write SetBoolean;

    property NrOfMounts : Integer index NR_NrOfMounts read GetInteger write SetInteger;
    property Mount0 : String index NR_Mount0 read GetString write SetString;
    property Mount1 : String index NR_Mount1 read GetString write SetString;
    property Mount2 : String index NR_Mount2 read GetString write SetString;
    property Mount3 : String index NR_Mount3 read GetString write SetString;
    property Mount4 : String index NR_Mount4 read GetString write SetString;
    property Mount5 : String index NR_Mount5 read GetString write SetString;
    property Mount6 : String index NR_Mount6 read GetString write SetString;
    property Mount7 : String index NR_Mount7 read GetString write SetString;
    property Mount8 : String index NR_Mount8 read GetString write SetString;
    property Mount9 : String index NR_Mount9 read GetString write SetString;
    property AutoMountCDs : Boolean index NR_AutoMountCDs read GetBoolean write SetBoolean;
    property SecureMode : Boolean index NR_SecureMode read GetBoolean write SetBoolean;
    property Mount[I : Integer] : String read GetMount write SetMount;

    property MixerNosound : Boolean index NR_MixerNosound read GetBoolean write SetBoolean;
    property MixerRate : Integer index NR_MixerRate read GetInteger write SetInteger;
    property MixerBlocksize : Integer index NR_MixerBlocksize read GetInteger write SetInteger;
    property MixerPrebuffer : integer index NR_MixerPrebuffer read GetInteger write SetInteger;
    property MixerVolumeMasterLeft : Integer index NR_MixerVolumeMasterLeft read GetInteger write SetInteger;
    property MixerVolumeMasterRight : Integer index NR_MixerVolumeMasterRight read GetInteger write SetInteger;
    property MixerVolumeDisneyLeft : Integer index NR_MixerVolumeDisneyLeft read GetInteger write SetInteger;
    property MixerVolumeDisneyRight : Integer index NR_MixerVolumeDisneyRight read GetInteger write SetInteger;
    property MixerVolumeSpeakerLeft : Integer index NR_MixerVolumeSpeakerLeft read GetInteger write SetInteger;
    property MixerVolumeSpeakerRight : Integer index NR_MixerVolumeSpeakerRight read GetInteger write SetInteger;
    property MixerVolumeGUSLeft : Integer index NR_MixerVolumeGUSLeft read GetInteger write SetInteger;
    property MixerVolumeGUSRight : Integer index NR_MixerVolumeGUSRight read GetInteger write SetInteger;
    property MixerVolumeSBLeft : Integer index NR_MixerVolumeSBLeft read GetInteger write SetInteger;
    property MixerVolumeSBRight : Integer index NR_MixerVolumeSBRight read GetInteger write SetInteger;
    property MixerVolumeFMLeft : Integer index NR_MixerVolumeFMLeft read GetInteger write SetInteger;
    property MixerVolumeFMRight : Integer index NR_MixerVolumeFMRight read GetInteger write SetInteger;
    property MixerVolumeCDLeft : Integer index NR_MixerVolumeCDLeft read GetInteger write SetInteger;
    property MixerVolumeCDRight : Integer index NR_MixerVolumeCDRight read GetInteger write SetInteger;
    property SBType : String index NR_SBType read GetString write SetString;
    property SBBase : String index NR_SBBase read GetString write SetString;
    property SBIRQ : Integer index NR_SBIRQ read GetInteger write SetInteger;
    property SBDMA : Integer index NR_SBDMA read GetInteger write SetInteger;
    property SBHDMA : Integer index NR_SBHDMA read GetInteger write SetInteger;
    property SBMixer : Boolean index NR_SBMixer read GetBoolean write SetBoolean;
    property SBOplMode : String index NR_SBOplMode read GetString write SetString;
    property SBOplRate : Integer index NR_SBOplRate read GetInteger write SetInteger;
    property SBOplEmu : String index NR_SBOplEmu read GetString write SetString;
    property GUS : Boolean index NR_GUS read GetBoolean write SetBoolean;
    property GUSRate : Integer index NR_GUSRate read GetInteger write SetInteger;
    property GUSBase : String index NR_GUSBase read GetString write SetString;
    property GUSIRQ : Integer index NR_GUSIRQ read GetInteger write SetInteger;
    property GUSDMA : Integer index NR_GUSDMA read GetInteger write SetInteger;
    property GUSUltraDir : String index NR_GUSUltraDir read GetString write SetString;
    property MIDIType : String index NR_MIDIType read GetString write SetString;
    property MIDIDevice : String index NR_MIDIDevice read GetString write SetString;
    property MIDIConfig : String index NR_MIDIConfig read GetString write SetString;
    property MIDIMT32Mode : String index NR_MIDIMT32Mode read GetString write SetString;
    property MIDIMT32Time : String index NR_MIDIMT32Time read GetString write SetString;
    property MIDIMT32Level : String index NR_MIDIMT32Level read GetString write SetString;
    property SpeakerPC : Boolean index NR_SpeakerPC read GetBoolean write SetBoolean;
    property SpeakerRate : Integer index NR_SpeakerRate read GetInteger write SetInteger;
    property SpeakerTandy : String index NR_SpeakerTandy read GetString write SetString;
    property SpeakerTandyRate : Integer index NR_SpeakerTandyRate read GetInteger write SetInteger;
    property SpeakerDisney : Boolean index NR_SpeakerDisney read GetBoolean write SetBoolean;
    property JoystickType : String index NR_JoystickType read GetString write SetString;
    property JoystickTimed : Boolean index NR_JoystickTimed read GetBoolean write SetBoolean;
    property JoystickAutoFire : Boolean index NR_JoystickAutoFire read GetBoolean write SetBoolean;
    property JoystickSwap34 : Boolean index NR_JoystickSwap34 read GetBoolean write SetBoolean;
    property JoystickButtonwrap : Boolean index NR_JoystickButtonwrap read GetBoolean write SetBoolean;

    property NE2000 : Boolean index NR_NE2000 read GetBoolean write SetBoolean;
    property NE2000Base : String index NR_NE2000Base read GetString write SetString;
    property NE2000IRQ : Integer index NR_NE2000IRQ read GetInteger write SetInteger;
    property NE2000MACAddress : String index NR_NE2000MACAddress read GetString write SetString;
    property NE2000RealInterface : String index NR_NE2000RealInterface read GetString write SetString;

    property Innova : Boolean index NR_Innova read GetBoolean write SetBoolean;
    property InnovaRate : Integer index NR_InnovaRate read GetInteger write SetInteger;
    property InnovaBase : String index NR_InnovaBase read GetString write SetString;
    property InnovaQuality : Integer index NR_InnovaQuality read GetInteger write SetInteger;

    property Autoexec : String index NR_Autoexec read GetString write SetString;
    property AutoexecOverridegamestart : Boolean index NR_AutoexecOverridegamestart read GetBoolean write SetBoolean;
    property AutoexecOverrideMount : Boolean index NR_AutoexecOverrideMount read GetBoolean write SetBoolean;
    property AutoexecBootImage : String index NR_AutoexecBootImage read GetString write SetString;
    property AutoexecFinalization : String index NR_AutoexecFinalization read GetString write SetString;

    property CustomSettings : String index NR_CustomSettings read GetString write SetString;
    property Environment : String index NR_Environment read GetString write SetString;

    property LastOpenTab : Integer index NR_LastOpenTab read GetInteger write SetInteger;
    property LastOpenTabModern : Integer index NR_LastOpenTabModern read GetInteger write SetInteger;

    property ProfileMode : String index NR_ProfileMode read GetString write SetString;

    property ScummVMGame : String index NR_ScummVMGame read GetString write SetString;
    property ScummVMPath : String index NR_ScummVMPath read GetString write SetString;
    property ScummVMZip : String index NR_ScummVMZip read GetString write SetString;
    property ScummVMFilter : String index NR_ScummVMFilter read GetString write SetString;
    property ScummVMRenderMode : String index NR_ScummVMRenderMode read GetString write SetString;
    property ScummVMAutosave : Integer index NR_ScummVMAutosave read GetInteger write SetInteger;
    property ScummVMLanguage : String index NR_ScummVMLanguage read GetString write SetString;
    property ScummVMMusicVolume : Integer index NR_ScummVMMusicVolume read GetInteger write SetInteger;
    property ScummVMSpeechVolume : Integer index NR_ScummVMSpeechVolume read GetInteger write SetInteger;
    property ScummVMSFXVolume : Integer index NR_ScummVMSFXVolume read GetInteger write SetInteger;
    property ScummVMMIDIGain : Integer index NR_ScummVMMIDIGain read GetInteger write SetInteger;
    property ScummVMSampleRate : Integer index NR_ScummVMSampleRate read GetInteger write SetInteger;
    property ScummVMMusicDriver : String index NR_ScummVMMusicDriver read GetString write SetString;
    property ScummVMNativeMT32 : Boolean index NR_ScummVMNativeMT32 read GetBoolean write SetBoolean;
    property ScummVMEnableGS : Boolean index NR_ScummVMEnableGS read GetBoolean write SetBoolean;
    property ScummVMMultiMIDI : Boolean index NR_ScummVMMultiMIDI read GetBoolean write SetBoolean;
    property ScummVMTalkSpeed : Integer index NR_ScummVMTalkSpeed read GetInteger write SetInteger;
    property ScummVMSpeechMute : Boolean index NR_ScummVMSpeechMute read GetBoolean write SetBoolean;
    property ScummVMSubtitles : Boolean index NR_ScummVMSubtitles read GetBoolean write SetBoolean;
    property ScummVMSavePath : String index NR_ScummVMSavePath read GetString write SetString;
    property ScummVMConfirmExit : Boolean index NR_ScummVMConfirmExit read GetBoolean write SetBoolean;
    property ScummVMCDROM : Integer index NR_ScummVMCDROM read GetInteger write SetInteger;
    property ScummVMJoystickNum : Integer index NR_ScummVMJoystickNum read GetInteger write SetInteger;
    property ScummVMAltIntro : Boolean index NR_ScummVMAltIntro read GetBoolean write SetBoolean;
    property ScummVMGFXDetails : Integer index NR_ScummVMGFXDetails read GetInteger write SetInteger;
    property ScummVMMusicMute : Boolean index NR_ScummVMMusicMute read GetBoolean write SetBoolean;
    property ScummVMObjectLabels : Boolean index NR_ScummVMObjectLabels read GetBoolean write SetBoolean;
    property ScummVMReverseStereo : Boolean index NR_ScummVMReverseStereo read GetBoolean write SetBoolean;
    property ScummVMSFXMute : Boolean index NR_ScummVMSFXMute read GetBoolean write SetBoolean;
    property ScummVMWalkspeed : Integer index NR_ScummVMWalkspeed read GetInteger write SetInteger;
    property ScummVMExtraPath : String index NR_ScummVMExtraPath read GetString write SetString;
    property ScummVMPlatform : String index NR_ScummVMPlatform read GetString write SetString;
    property ScummVMParameters : String index NR_ScummVMParameters read GetString write SetString;

    property CommandBeforeExecution : String index NR_CommandBeforeExecution read GetString write SetString;
    property CommandAfterExecution : String index NR_CommandAfterExecution read GetString write SetString;
    property CommandBeforeExecutionWait : Boolean index NR_CommandBeforeExecutionWait read GetBoolean write SetBoolean;
    property CommandBeforeExecutionMinimized : Boolean index NR_CommandBeforeExecutionMinimized read GetBoolean write SetBoolean;
    property CommandAfterExecutionMinimized : Boolean index NR_CommandAfterExecutionMinimized read GetBoolean write SetBoolean;
    property CommandBeforeExecutionParallel : Boolean index NR_CommandBeforeExecutionParallel read GetBoolean write SetBoolean;
    property CommandAfterExecutionParallel : Boolean index NR_CommandAfterExecutionParallel read GetBoolean write SetBoolean;
    property RunAsAdmin : Boolean index NR_RunAsAdmin read GetBoolean write SetBoolean;

    property AddtionalChecksumFile1 : String index NR_AddtionalChecksumFile1 read GetString write SetString;
    property AddtionalChecksumFile1Checksum : String index NR_AddtionalChecksumFile1Checksum read GetString write SetString;
    property AddtionalChecksumFile2 : String index NR_AddtionalChecksumFile2 read GetString write SetString;
    property AddtionalChecksumFile2Checksum : String index NR_AddtionalChecksumFile2Checksum read GetString write SetString;
    property AddtionalChecksumFile3 : String index NR_AddtionalChecksumFile3 read GetString write SetString;
    property AddtionalChecksumFile3Checksum : String index NR_AddtionalChecksumFile3Checksum read GetString write SetString;
    property AddtionalChecksumFile4 : String index NR_AddtionalChecksumFile4 read GetString write SetString;
    property AddtionalChecksumFile4Checksum : String index NR_AddtionalChecksumFile4Checksum read GetString write SetString;
    property AddtionalChecksumFile5 : String index NR_AddtionalChecksumFile5 read GetString write SetString;
    property AddtionalChecksumFile5Checksum : String index NR_AddtionalChecksumFile5Checksum read GetString write SetString;
end;

     TGameDB=class
  private
    FDir : String;
    FTimeStampCheck : Boolean;
    FGameList : TList;
    FOnChanged : TNotifyEvent;
    FConfOpt : TConfOpt;
    FCreateConfFilesOnSave : Boolean;
    BinLoadCache : TMemoryStream;
    BinLoadCacheOffset : Integer;
    BinLoadCacheIndex : Array['A'..'Z'] of TStringList;
    BinLoadCacheIndexLastIndex : Array['A'..'Z'] of Integer;
    BinLoadCacheIndexRest : TStringList;
    BinLoadCacheIndexRestLastIndex : Integer;
    Procedure LoadList;
    Procedure GameChanged(Sender : TObject);
    Procedure LoadGameFromFile(const FileName : String; const DOSFileDate : Integer);
    Function MakePROFFileName(const AName, ADir : String; const CheckExistingFiles : Boolean) : String;
    function GetGame(I: Integer): TGame;
    function GetCount: Integer;
    Procedure DeleteOldFiles;
    Function GetProfilesListFromDrive : TStringList;
    Procedure StoreBinCache;
    Procedure InitLoadBinCache;
    Procedure DoneLoadBinCache;
    Procedure BurnLoadBinCache;
    Function GetLoadBinCacheOffset(const FileName : String; const DOSFileDate : Integer) : Boolean;
    Function CheckGameBinaryVersionID(const CacheVersionID : Integer) : Boolean;
  public
    Constructor Create(const ADir : String; const ATimeStampCheck : Boolean = True);
    Destructor Destroy; override;
    Procedure Clear;
    Function Add(const AName : String) : Integer; overload;
    Function Add(const AGame : TGame) : Integer; overload;
    Function Delete(const Index : Integer) : Boolean; overload;
    Function Delete(const AGame : TGame) : Boolean; overload;
    Function IndexOf(const AGame : TGame) : Integer; overload;
    Function IndexOf(const AGame : String) : Integer; overload;
    Function GetGenreList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetDeveloperList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetPublisherList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetYearList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetLanguageList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetLicenseList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetWWWList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetWWWNameList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
    Function GetKeyValueList(const Key : String; WithDefaultProfile : Boolean =True) : TStringList;
    Function GetUserKeys : TStringList;
    Function GetSortedGamesList : TList;
    Procedure StoreAllValues;
    Procedure LoadCache;
    Function ProfFileName(const AName : String; const CheckExistingFiles : Boolean) : String;
    property Count : Integer read GetCount;
    property Game[I : Integer] : TGame read GetGame; default;
    property ConfOpt : TConfOpt read FConfOpt;
    property OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
    property CreateConfFilesOnSave : Boolean read FCreateConfFilesOnSave write FCreateConfFilesOnSave;
end;

Var DefaultValueReaderGame : TGame = nil;

Const DefaultValuesResolutionFullscreen='original,320x200,320x240,640x432,640x480,720x480,800x600,1024x768,1152x864,1280x720,1280x768,1280x960,1280x1024,1366x760,1366x768,1600x1200,1680x1050,1920x1080,1920x1200,0x0';
      DefaultValuesResolutionWindow='original,320x200,320x240,640x432,640x480,720x480,800x600,1024x768,1152x864,1280x720,1280x768,1280x960,1280x1024,1366x760,1366x768,1600x1200,1920x1080,1920x1200';
      DefaultValuesJoysticks='none,auto,2axis,4axis,4axis_2,fcs,ch';
      DefaultValuesScale='No Scaling (none),Nearest neighbor upscaling with factor 2 (normal2x),Nearest neighbor upscaling with factor 3 (normal3x),'+
                         'Advanced upscaling with factor 2 (advmame2x),Advanced upscaling with factor 3 (advmame3x),'+
                         'high quality with factor 2 (hq2x), high quality with factor 3 (hq3x),2xsai (2xsai), super2xsai (super2xsai), supereagle (supereagle),'+
                         'Advanced interpoling with factor 2 (advinterp2x),Advanced interpoling with factor 3 (advinterp3x),'+
                         'Advanced upscaling with sharpening with factor 2 (tv2x),Advanced upscaling with sharpening with factor 3 (tv3x),Simulates the phopsphors on a dot trio CRT with factor 2 (rgb2x),Simulates the phopsphors on a dot trio CRT with factor 3 (rgb3x),'+
                         'Nearest neighbor with black lines with factor 2 (scan2x),Nearest neighbor with black lines with factor 3 (scan3x)';
      DefaultValueRender='surface,overlay,opengl,openglnb,ddraw';
      DefaultValueCycles='auto,max,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,6000,7000,8000,9000,10000,11000,12000,12000,13000,14000,15000,16000,17000,18000,19000,20000';
      DefaultValuesVideo='hercules (Hercules Graphics Card),cga (Color Graphics Adapter),tandy (Tandy),pcjr (IBM PCjr),ega (Enhanced Graphics Adapter),'+
                         'vgaonly (Video Graphics Array), svga_s3 (VESA 2.0 compatible S3 SuperVGA card), svga_et3000 (Tseng ET3000 SuperVGA card),'+
                         'svga_et4000 (Tseng ET4000 SuperVGA card),svga_paradise (Paradise PVGA1A SuperVGA card),vesa_nolfb (VESA 2.0 compatible S3 SuperVGA card),'+
                         'vesa_oldvbe (VESA 1.2 compatible S3 SuperVGA card)';
      DefaultValuesMemory='1,2,4,8,16,32,63';
      DefaultValuesFrameSkip='0,1,2,3,4,5,6,7,8,9,10';
      DefaultValuesCore='auto,normal,dynamic,simple';
      DefaultValuesSBlaster='none,sb1,sb2,sbpro1,sbpro2,sb16,gb';
      DefaultValuesOPLModes='auto,cms,opl2,dualopl2,opl3,none';
      DefaultValuesKeyboardLayout='default,none,Albania (SQ),Albania (SQ448),Argentina (LA),Armenia (HY),Australia (US),Austria (DE),Austria (DE453),Azerbaijan (AZ),'+
                                  'Belarus (BY),Belgium (BE),Bosnia & Herzegovina (BA),Brazil (BR),Brazil (BR274),Bulgaria (BG),Bulgaria (BG241),'+
                                  'Canada (CA),Canada (CA445),Canada (CF501),Chile (LA),Colombia (LA),Croatia (HR),Czech Republic (CZ),Czech Republic (CZ243),'+
                                  'Denmark (DK),Ecuador (LA),Estonia (EE),Faeroe Islands (FO),Finland (FI),France (FR),France (FR120),Georgia (KA),Germany (DE),Germany (DE453),'+
                                  'Greece (GK),Greece (GK220),Greece (GK459),Hungary (HU),Hungary (HU208),Iceland (IS),Iceland (IS161),Ireland (UK),Ireland (UK168),'+
                                  'Italy (IT),Italy (IT142),Kazakhstan (KK),Kyrgyzstan (KY),Latin-American-Spanish (LA),Latvia (LV),Latvia (LV455),'+
                                  'Lithuania (LT),Lithuania (LT210),Lithuania (LT211),Lithuania (LT221),Lithuania (LT456),Macedonia (MK),Malta (MT),Malta (MT47),Mexico (LA),'+
                                  'Mongolia (MN),Netherlands (NL),New Zealand (US),Norway (NO),Philippines (PH),Poland (PL),Poland (PL214),Portugal (PO),Romania (RO),Romania (RO446),'+
                                  'Russia (RU),Russia (RU443),Serbia & Montenegro (SR),Serbia & Montenegro (SR450),Slovakia (SK),Slovenia (SI),South Africa (US),Spain (ES),'+
                                  'Sweden (SV),Switzerland - French (SF),Switzerland - German (SD),Turkmenistan (TM),Turkey (TR),Turkey (TR440),Ukraine (UA),Ukraine (UA465),'+
                                  'United Kingdom (UK),United Kingdom (UK168),US (US),US International (UX),US Dvorak (DV),US Left-Hand Dvorak (LH),US Right-Hand Dvorak (RH),'+
                                  'Uzbekistan (UZ),Venezuela (LA),Yugoslavia (YU)';
      DefaultValuesCodepage='default,113 (Yugoslavian),437 (United States),667 (Polish),668 (Polish),737 (Greek-2),770 (Baltic),771 (Lithuanian and Russian KBL),'+
                            '772 (Lithuanian and Russian),773 (Latin-7 Baltic - old standard),774 (Lithuanian),775 (Latin-7 Baltic),777 (Accented Lithuanian),'+
                            '778 (Accented Lithuanian),790 (Polish Mazovia),808 (Cyrillic-2 with Euro),848 (Cyrillic Ukrainian with Euro),849 (Cyrillic Belarusian with Euro),'+
                            '850 (Latin-1),851 (Greek),852 (Latin-2 Eastern European),853 (Latin-3 Southern European),855 (Cyrillic-1),857 (Latin-5 Turkish),'+
                            '858 (Latin-1 with Euro),859 (Latin-9; 858 plus full french and estonian),860 (Portugal),861 (Icelandic),863 (Canadian French),'+
                            '865 (Nordic),866 (Cyrillic-2 Russian),867 (Czech Kamenicky),869 (Greek),872 (Cyrillic-1 with Euro),899 (Armenian),991 (Polish Mazovia with Zloty sign),'+
                            '1116 (Estonian),1117 (Latvian),1125 (Cyrillic Ukrainian),1131 (Cyrillic Belarusian),57781 (Hungarian),58152 (Cyrillic Kazakh with Euro),'+
                            '58210 (Cyrillic Azeri Cyrillic),59234 (Cyrillic Tatar),59829 (Georgian),60258 (Cyrillic Azeri Latin),60853 (Georgian with capital letters),'+
                            '61282 (Latvian and Russian "RusLat"),62306 (Cyrillic Uzbek)';
      DefaultValuesReportedDOSVersion='default,6.22,6.2,6.0,5.0,4.0,3.3';
      DefaultValuesMIDIDevice='default,alsa,oss,win32,coreaudio,none';
      DefaultValuesBlocksize='512,1024,2048,3072,4096,8192';
      DefaultValuesCyclesDown='20,50,100,500,1000,2000,5000,10000';
      DefaultValuesCyclesUp='20,50,100,500,1000,2000,5000,10000';
      DefaultValuesDMA='0,1,3,5,6,7';
      DefaultValuesDMA1='0,1,3,5,6,7';
      DefaultValuesGUSBase='220,240,260,280,2a0,2c0,2e0,300';
      DefaultValuesGUSRate='8000,11025,22050,32000,44100,48000,49716';
      DefaultValuesHDMA='0,1,3,5,6,7';
      DefaultValuesIRQ='3,5,7,10,11';
      DefaultValuesIRQ1='3,5,7,10,11';
      DefaultValuesMPU401='none,intelligent,uart';
      DefaultValuesOPLRate='8000,11025,22050,32000,44100,48000,49716';
      DefaultValuesPCRate='8000,11025,22050,32000,44100,48000,49716';
      DefaultValuesRate='8000,11025,22050,32000,44100,48000,49716';
      DefaultValuesSBBase='220,240,260,280,2a0,2c0,2e0,300';
      DefaultValuesMouseSensitivity='10,20,30,40,50,60,70,80,90,100,125,150,175,200,250,300,350,400,450,500,550,600,700,800,900,1000';
      DefaultValuesTandyRate='8000,11025,16000,22050,32000,44100,48000,49716';
      DefaultValuesScummVMFilter='No filtering. no scaling. Fastest (1x),No filtering. factor 2x. default for non 640x480 games (2x),No filtering. factor 3x (3x),2xSAI filter. factor 2x (2xsai),Enhanced 2xSAI filtering. factor 2x (super2xsai),'+
                                 'Less blurry than 2xSAI but slower. Factor 2x (supereagle),Doesn''t rely on blurring like 2xSAI. fast. Factor 2x (advmame2x),Doesn''t rely on blurring like 2xSAI. fast. Factor 3x (advmame3x),Very nice high quality filter but slow. Factor 2x (hq2x),'+
                                 'Very nice high quality filter but slow. Factor 3x (hq3x),Interlace filter. Tries to emulate a TV. Factor 2x (tv2x),Dot matrix effect. Factor 2x (dotmatrix)';
      DefaultValuesScummVMMusicDriver='No music (null),Automatic (auto),Adlib emulation (adlib),FluidSynth MIDI emulation (fluidsynth),MT-32 emulation (mt32),PCjr emulation (only usable in SCUMM games) (pcjr),PC Speaker emulation (pcspk),'+
                                      'FM-TOWNS YM2612 emulation (only usable in SCUMM FM-TOWNS games) (towns),Windows MIDI (windows)';
      DefaultValuesVGAChipsets='s3,et4000,et4000new,et3000,pvga1a,none';
      DefaultValuesVGAVideoRAM='512,1024,2048,4096,8192';
      DefaultValuesScummVMRenderMode='default,CGA,EGA,Hercules green (hercGreen),Hercules amber (hercAmber),Amiga';
      DefaultValuesScummVMPlatform='auto,2gs,3do,acorn,amiga,atari,c64,fmtowns,mac,nes,pc,pce,segacd,windows';
      DefaultValuesScummVMLanguages='maniac:en-de-fr-it-es,zak:en-de-fr-it-es,dig_jp-zh-kr,comi:en-de-fr-it-pt-es-jp-zh-kr,sky:gb-en-de-fr-it-pt-es-se,sword1:en-de-fr-it-es-pt-cz,simon1:en-de-fr-it-es-hb-pl-ru,simon2:en-de-fr-it-es-hb-pl-ru';
      DefaultValuesCPUType='auto,386,386_slow,486_slow,pentium_slow,386_prefetch';
      DefaultValuesOplEmu='default,compat,fast,old';
      DefaultValuesGlideEmulation='false,true,emu';
      DefaultValuesGlideEmulationPort='400,500,600';
      DefaultValuesGlideEmulationLFB='full,read,write,none';
      DefaultValuesInnovaEmulationSampleRate='44100,48000,32000,22050,16000,11025,8000,49716';
      DefaultValuesInnovaEmulationBaseAddress='240,220,260,280,2a0,2c0,2e0,300';
      DefaultValuesInnovaEmulationQuality='0,1,2,3';
      DefaultValuesNE2000EmulationBaseAddress='300,400,500';
      DefaultValuesNE2000EmulationInterrupt='3,5,7,10,11';
      DefaultValuesMT32ReverbMode='0,1,2,3,auto';
      DefaultValuesMT32ReverbTime='0,1,2,3,4,5,6,7';
      DefaultValuesMT32ReverbLevel='0,1,2,3,4,5,6,7';

implementation

uses Windows, SysUtils, Messages, Forms, Dialogs, Math, CommonTools, PrgConsts,
     PrgSetupUnit, LanguageSetupUnit, GameDBToolsUnit, WaitFormUnit, DOSBoxUnit,
     LoggingUnit;

{ TConfOpt }

constructor TConfOpt.Create;
begin
  inherited Create(PrgDataDir+SettingsFolder+'\'+ConfOptFile);

  AddStringRec(0,'resolution','value',DefaultValuesResolutionFullscreen);
  AddStringRec(1,'resolutionWindow','value',DefaultValuesResolutionWindow);
  AddStringRec(2,'joysticks','value',DefaultValuesJoysticks);
  AddStringRec(3,'scale','value',DefaultValuesScale);
  AddStringRec(4,'render','value',DefaultValueRender);
  AddStringRec(5,'cycles','value',DefaultValueCycles);
  AddStringRec(6,'video','value',DefaultValuesVideo);
  AddStringRec(7,'memory','value',DefaultValuesMemory);
  AddStringRec(8,'frameskip','value',DefaultValuesFrameSkip);
  AddStringRec(9,'core','value',DefaultValuesCore);
  AddStringRec(10,'sblaster','value',DefaultValuesSBlaster);
  AddStringRec(11,'oplmode','value',DefaultValuesOPLModes);
  AddStringRec(12,'keyboardlayout','value',DefaultValuesKeyboardLayout);
  AddStringRec(13,'codepage','value',DefaultValuesCodepage);
  AddStringRec(14,'ReportedDOSVersion','value',DefaultValuesReportedDOSVersion);
  AddStringRec(15,'MIDIDevice','value',DefaultValuesMIDIDevice);
  AddStringRec(16,'Blocksize','value',DefaultValuesBlocksize);
  AddStringRec(17,'CyclesDown','value',DefaultValuesCyclesDown);
  AddStringRec(18,'CyclesUp','value',DefaultValuesCyclesUp);
  AddStringRec(19,'DMA','value',DefaultValuesDMA);
  AddStringRec(20,'DMA1','value',DefaultValuesDMA1);
  AddStringRec(21,'GUSBase','value',DefaultValuesGUSBase);
  AddStringRec(22,'GUSRate','value',DefaultValuesGUSRate);
  AddStringRec(23,'HDMA','value',DefaultValuesHDMA);
  AddStringRec(24,'IRQ','value',DefaultValuesIRQ);
  AddStringRec(25,'IRQ1','value',DefaultValuesIRQ1);
  AddStringRec(26,'MPU401','value',DefaultValuesMPU401);
  AddStringRec(27,'OPLRate','value',DefaultValuesOPLRate);
  AddStringRec(28,'PCRate','value',DefaultValuesPCRate);
  AddStringRec(29,'Rate','value',DefaultValuesRate);
  AddStringRec(30,'SBBase','value',DefaultValuesSBBase);
  AddStringRec(31,'MouseSensitivity','value',DefaultValuesMouseSensitivity);
  AddStringRec(32,'TandyRate','value',DefaultValuesTandyRate);
  AddStringRec(33,'ScummVMFilter','value',DefaultValuesScummVMFilter);
  AddStringRec(34,'ScummVMMusicDriver','value',DefaultValuesScummVMMusicDriver);
  AddStringRec(35,'VGAChipsets','value',DefaultValuesVGAChipsets);
  AddStringRec(36,'VGAVideoRAM','value',DefaultValuesVGAVideoRAM);
  AddStringRec(37,'ScummVMRenderMode','value',DefaultValuesScummVMRenderMode);
  AddStringRec(38,'ScummVMPlatform','value',DefaultValuesScummVMPlatform);
  AddStringRec(39,'ScummVMLanguages','value',DefaultValuesScummVMLanguages);
  AddStringRec(40,'CPUType','value',DefaultValuesCPUType);
  AddStringRec(41,'SBOplEmu','value',DefaultValuesOplEmu);
  AddStringRec(42,'GlideEmulation','value',DefaultValuesGlideEmulation);
  AddStringRec(43,'GlideEmulationPort','value',DefaultValuesGlideEmulationPort);
  AddStringRec(44,'GlideEmulationLFB','value',DefaultValuesGlideEmulationLFB);
  AddStringRec(45,'InnovaEmulationSampleRate','value',DefaultValuesInnovaEmulationSampleRate);
  AddStringRec(46,'InnovaEmulationBaseAddress','value',DefaultValuesInnovaEmulationBaseAddress);
  AddStringRec(47,'InnovaEmulationQuality','value',DefaultValuesInnovaEmulationQuality);
  AddStringRec(48,'NE2000EmulationBaseAddress','value',DefaultValuesNE2000EmulationBaseAddress);
  AddStringRec(49,'NE2000EmulationInterrupt','value',DefaultValuesNE2000EmulationInterrupt);
  AddStringRec(50,'MT32ReverbMode','value',DefaultValuesMT32ReverbMode);
  AddStringRec(51,'MT32ReverbTime','value',DefaultValuesMT32ReverbTime);
  AddStringRec(52,'MT32ReverbLevel','value',DefaultValuesMT32ReverbLevel);

  CacheAllStrings;
end;

destructor TConfOpt.Destroy;
begin
  StoreAllValues;
  inherited Destroy;
end;

{ TGame }

Constructor TGame.Create(const ASetupFile : String);
begin
  inherited Create(ASetupFile);
  FGameDB:=nil;
  InitData;
  LoadCache;
end;

Constructor TGame.CreateDelayed(const ASetupFile : String; const ATimeStampCheck : Boolean);
begin
  If ATimeStampCheck then inherited Create(ASetupFile) else inherited CreateNoTimeStampCheck(ASetupFile);
  FGameDB:=nil;
end;

constructor TGame.Create(const ABasePrgSetup: TBasePrgSetup);
begin
  inherited Create(ABasePrgSetup);
  FGameDB:=nil;
  InitData;
  LoadCache;
end;

destructor TGame.Destroy;
begin
  {not needed: StoreAllValues;}
  inherited Destroy;
end;

procedure TGame.InitData;
Var S : String;
    I : Integer;
begin
  S:=ExtractFileName(SetupFile);
  while (S<>'') and (S[length(S)]<>'.') do Delete(S,length(S),1);
  If (S<>'') and (S[length(S)]='.') then Delete(S,length(S),1);

  FastAddRecStart;

  AddStringRec(NR_Name,'ExtraInfo','Name',S);

  AddStringRec(NR_Icon,'ExtraInfo','Icon','');
  AddStringRec(NR_GameExe,'Extra','Exe','');
  AddStringRec(NR_GameExeMD5,'Extra','ExeMD5','');
  AddStringRec(NR_SetupExe,'Extra','Setup','');
  AddStringRec(NR_SetupExeMD5,'Extra','SetupMD5','');
  AddStringRec(NR_GameParameters,'Extra','GameParameters','');
  AddStringRec(NR_SetupParameters,'Extra','SetupParameters','');
  AddBooleanRec(NR_LoadFix,'Extra','Loadhigh',False);
  AddIntegerRec(NR_LoadFixMemory,'Extra','LoadFixVal',64);
  AddStringRec(NR_CaptureFolder,'dosbox','captures',IncludeTrailingPathDelimiter(PrgSetup.CaptureDir));
  AddStringRec(NR_ExtraDirs,'Extra','ExtraDirs','');
  AddStringRec(NR_ExtraFiles,'Extra','ExtraFiles','');
  AddStringRec(NR_LastModification,'Extra','LastModification','');
  AddBooleanRec(NR_IgnoreWindowsFileWarnings,'Extras','IgnoreWindowsFileWarnings',False);
  AddBooleanRec(NR_NoDOSBoxFailedDialog,'Extras','NoDOSBoxFailedDialog',False);
  AddStringRec(NR_ScreenshotListScreenshot,'Extra','ScreenshotListScreenshot','');

  For I:=0 to 49 do begin
    AddStringRec(NR_ExtraPrgFile+I,'Extra','ExtraExe'+IntToStr(I),'');
  end;
  For I:=0 to 49 do begin
    AddStringRec(NR_ExtraPrgFileParameter+I,'Extra','ExtraParameter'+IntToStr(I),'');
  end;

  AddStringRec(NR_Genre,'ExtraInfo','Genre','');
  AddStringRec(NR_Developer,'ExtraInfo','Developer','');
  AddStringRec(NR_Publisher,'ExtraInfo','Publisher','');
  AddStringRec(NR_Year,'ExtraInfo','Year','');
  AddStringRec(NR_DataDir,'Extra','DataDir','');
  AddBooleanRec(NR_Favorite,'ExtraInfo','Favorite',False);
  AddStringRec(NR_Notes,'ExtraInfo','Notes','');
  AddStringRec(NR_Language,'ExtraInfo','Language','');
  AddStringRec(NR_UserInfo,'ExtraInfo','UserInfo','');
  AddStringRec(NR_WWW1Name,'ExtraInfo','WWWName','');
  AddStringRec(NR_WWW1,'ExtraInfo','WWW','');
  AddStringRec(NR_WWW2Name,'ExtraInfo','WWW2Name','');
  AddStringRec(NR_WWW2,'ExtraInfo','WWW2','');
  AddStringRec(NR_WWW3Name,'ExtraInfo','WWW3Name','');
  AddStringRec(NR_WWW3,'ExtraInfo','WWW3','');
  AddStringRec(NR_WWW4Name,'ExtraInfo','WWW4Name','');
  AddStringRec(NR_WWW4,'ExtraInfo','WWW4','');
  AddStringRec(NR_WWW5Name,'ExtraInfo','WWW5Name','');
  AddStringRec(NR_WWW5,'ExtraInfo','WWW5','');
  AddStringRec(NR_WWW6Name,'ExtraInfo','WWW6Name','');
  AddStringRec(NR_WWW6,'ExtraInfo','WWW6','');
  AddStringRec(NR_WWW7Name,'ExtraInfo','WWW7Name','');
  AddStringRec(NR_WWW7,'ExtraInfo','WWW7','');
  AddStringRec(NR_WWW8Name,'ExtraInfo','WWW8Name','');
  AddStringRec(NR_WWW8,'ExtraInfo','WWW8','');
  AddStringRec(NR_WWW9Name,'ExtraInfo','WWW9Name','');
  AddStringRec(NR_WWW9,'ExtraInfo','WWW9','');

  AddBooleanRec(NR_CloseDosBoxAfterGameExit,'Extra','CloseOnExit',True);
  AddIntegerRec(NR_ShowConsoleWindow,'sdl','ConsoleWindow',1);
  AddBooleanRec(NR_StartFullscreen,'sdl','fullscreen',True);
  AddBooleanRec(NR_AutoLockMouse,'sdl','autolock',True);
  AddBooleanRec(NR_Force2ButtonMouseMode,'dos','Force2ButtonMouseMode',False);
  AddBooleanRec(NR_SwapMouseButtons,'dos','SwapMouseButtons',False);
  AddBooleanRec(NR_UseDoublebuffering,'sdl','fulldouble',False);
  AddBooleanRec(NR_AspectCorrection,'render','aspect',False);
  AddBooleanRec(NR_UseScanCodesOld,'sdl','usecancodes',True);
  AddBooleanRec(NR_UseScanCodes,'sdl','usescancodes',True);
  AddIntegerRec(NR_MouseSensitivity,'sdl','sensitivity',100);
  AddStringRec(NR_Render,'sdl','output','surface');
  AddStringRec(NR_WindowResolution,'sdl','windowresolution','original');
  AddStringRec(NR_FullscreenResolution,'sdl','fullresolution','original');
  AddStringRec(NR_Scale,'render','scaler','normal2x');
  AddIntegerRec(NR_TextModeLines,'render','TextModeLines',25);
  AddStringRec(NR_Priority,'sdl','priority','higher,normal');
  AddStringRec(NR_CustomDOSBoxDir,'dosbox','DOSBoxDirectory','default');
  AddStringRec(NR_CustomKeyMappingFile,'sdl','mapperfile','default');
  AddStringRec(NR_CustomDOSBoxLanguage,'sdl','DOSBoxlanguage','default');

  AddIntegerRec(NR_Memory,'dosbox','memsize',16);
  AddBooleanRec(NR_XMS,'dos','xms',True);
  AddBooleanRec(NR_EMS,'dos','ems',True);
  AddBooleanRec(NR_UMB,'dos','umb',True);
  AddStringRec(NR_Core,'cpu','core','auto');
  AddStringRec(NR_Cycles,'cpu','cycles','auto');
  AddIntegerRec(NR_CyclesUp,'cpu','cyclesup',10);
  AddIntegerRec(NR_CyclesDown,'cpu','cyclesdown',20);
  AddStringRec(NR_CPUType,'cpu','type','auto');
  AddIntegerRec(NR_FrameSkip,'render','frameskip',0);
  AddStringRec(NR_VideoCard,'dosbox','machine','svga_s3');
  AddStringRec(NR_KeyboardLayout,'dos','keyboardlayout','default');
  AddStringRec(NR_Codepage,'dos','codepage','default');
  AddStringRec(NR_Serial1,'serial','serial1','dummy');
  AddStringRec(NR_Serial2,'serial','serial2','dummy');
  AddStringRec(NR_Serial3,'serial','serial3','disabled');
  AddStringRec(NR_Serial4,'serial','serial4','disabled');
  AddBooleanRec(NR_IPX,'ipx','ipx',false);
  AddStringRec(NR_IPXType,'ipx','type','none');
  AddStringRec(NR_IPXAddress,'ipx','address','');
  AddStringRec(NR_IPXPort,'ipx','port','213');
  AddBooleanRec(NR_Use4DOS,'dos','4DOS',False);
  AddBooleanRec(NR_UseDOS32A,'dos','DOS32A',False);
  AddStringRec(NR_ReportedDOSVersion,'dos','ReportedDOSVersion','default');
  AddStringRec(NR_NumLockStatus,'dos','NumLockStatus','');
  AddStringRec(NR_CapsLockStatus,'dos','CapsLockStatus','');
  AddStringRec(NR_ScrollLockStatus,'dos','ScrollLockStatus','');
  AddStringRec(NR_VGAChipset,'vga','svgachipset','3s');
  AddIntegerRec(NR_VideoRam,'vga','videoram',2048);
  AddStringRec(NR_GlideEmulation,'glide','glide','false');
  AddStringRec(NR_GlidePort,'glide','port','600');
  AddStringRec(NR_GlideLFB,'glide','LFB','full');
  AddStringRec(NR_PixelShader,'vga','PixelShader','none');

  AddBooleanRec(NR_EnablePrinterEmulation,'printer','printer',False);
  AddIntegerRec(NR_PrinterResolution,'printer','dpi',360);
  AddIntegerRec(NR_PaperWidth,'printer','width',85);
  AddIntegerRec(NR_PaperHeight,'printer','height',110);
  AddStringRec(NR_PrinterOutputFormat,'printer','printoutput','ps');
  AddBooleanRec(NR_PrinterMultiPage,'printer','multipage',False);

  AddIntegerRec(NR_NrOfMounts,'Extra','NrOfMounts',0);
  AddStringRec(NR_Mount0,'Extra','0','');
  AddStringRec(NR_Mount1,'Extra','1','');
  AddStringRec(NR_Mount2,'Extra','2','');
  AddStringRec(NR_Mount3,'Extra','3','');
  AddStringRec(NR_Mount4,'Extra','4','');
  AddStringRec(NR_Mount5,'Extra','5','');
  AddStringRec(NR_Mount6,'Extra','6','');
  AddStringRec(NR_Mount7,'Extra','7','');
  AddStringRec(NR_Mount8,'Extra','8','');
  AddStringRec(NR_Mount9,'Extra','9','');
  AddBooleanRec(NR_AutoMountCDs,'Extra','AutoMountCDs',False);
  AddBooleanRec(NR_SecureMode,'Extra','SecureMode',True);

  AddBooleanRec(NR_MixerNosound,'mixer','nosound',false);
  AddIntegerRec(NR_MixerRate,'mixer','rate',44100);
  AddIntegerRec(NR_MixerBlocksize,'mixer','blocksize',1024);
  AddIntegerRec(NR_MixerPrebuffer,'mixer','prebuffer',10);
  AddIntegerRec(NR_MixerVolumeMasterLeft,'mixer','VolumeMasterLeft',100);
  AddIntegerRec(NR_MixerVolumeMasterRight,'mixer','VolumeMasterRight',100);
  AddIntegerRec(NR_MixerVolumeDisneyLeft,'mixer','VolumeDisneyLeft',100);
  AddIntegerRec(NR_MixerVolumeDisneyRight,'mixer','VolumeDisneyRight',100);
  AddIntegerRec(NR_MixerVolumeSpeakerLeft,'mixer','VolumeSpeakerLeft',100);
  AddIntegerRec(NR_MixerVolumeSpeakerRight,'mixer','VolumeSpeakerRight',100);
  AddIntegerRec(NR_MixerVolumeGUSLeft,'mixer','VolumeGUSLeft',100);
  AddIntegerRec(NR_MixerVolumeGUSRight,'mixer','VolumeGUSRight',100);
  AddIntegerRec(NR_MixerVolumeSBLeft,'mixer','VolumeSBLeft',100);
  AddIntegerRec(NR_MixerVolumeSBRight,'mixer','VolumeSBRight',100);
  AddIntegerRec(NR_MixerVolumeFMLeft,'mixer','VolumeFMLeft',100);
  AddIntegerRec(NR_MixerVolumeFMRight,'mixer','VolumeFMRight',100);
  AddIntegerRec(NR_MixerVolumeCDLeft,'mixer','VolumeCDLeft',100);
  AddIntegerRec(NR_MixerVolumeCDRight,'mixer','VolumeCDRight',100);
  AddStringRec(NR_SBType,'sblaster','sbtype','sb16');
  AddStringRec(NR_SBBase,'sblaster','sbbase','220');
  AddIntegerRec(NR_SBIRQ,'sblaster','irq',7);
  AddIntegerRec(NR_SBDMA,'sblaster','dma',1);
  AddIntegerRec(NR_SBHDMA,'sblaster','hdma',5);
  AddBooleanRec(NR_SBMixer,'sblaster','mixer',true);
  AddStringRec(NR_SBOplMode,'sblaster','oplmode','auto');
  AddIntegerRec(NR_SBOplRate,'sblaster','oplrate',44100);
  AddStringRec(NR_SBOplEmu,'sblaster','oplemu','default');
  AddBooleanRec(NR_GUS,'gus','gus',false);
  AddIntegerRec(NR_GUSRate,'gus','gusrate',44100);
  AddStringRec(NR_GUSBase,'gus','gusbase','240');
  AddIntegerRec(NR_GUSIRQ,'gus','irq1',5);
  AddIntegerRec(NR_GUSDMA,'gus','dma1',1);
  AddStringRec(NR_GUSUltraDir,'gus','ultradir','C:\ULTRASND');
  AddStringRec(NR_MIDIType,'midi','mpu401','intelligent');
  AddStringRec(NR_MIDIDevice,'midi','device','default');
  AddStringRec(NR_MIDIConfig,'midi','config','');
  AddStringRec(NR_MIDIMT32Mode,'midi','MT32Mode','auto');
  AddStringRec(NR_MIDIMT32Time,'midi','MT32Time','5');
  AddStringRec(NR_MIDIMT32Level,'midi','MT32Level','3');
  AddBooleanRec(NR_SpeakerPC,'speaker','pcspeaker',true);
  AddIntegerRec(NR_SpeakerRate,'speaker','pcrate',44100);
  AddStringRec(NR_SpeakerTandy,'speaker','tandy','auto');
  AddIntegerRec(NR_SpeakerTandyRate,'speaker','tandyrate',44100);
  AddBooleanRec(NR_SpeakerDisney,'speaker','disney',true);
  AddStringRec(NR_JoystickType,'joystick','joysticktype','none');
  AddBooleanRec(NR_JoystickTimed,'joystick','timed',True);
  AddBooleanRec(NR_JoystickAutoFire,'joystick','autofire',False);
  AddBooleanRec(NR_JoystickSwap34,'joystick','swap34',False);
  AddBooleanRec(NR_JoystickButtonwrap,'joystick','buttonwrap',False);

  AddBooleanRec(NR_NE2000,'ne2000','ne2000',false);
  AddStringRec(NR_NE2000Base,'ne2000','ne2000base','300');
  AddIntegerRec(NR_NE2000IRQ,'ne2000','ne2000irq',3);
  AddStringRec(NR_NE2000MACAddress,'ne2000','macaddress','AC:DE:48:88:99:AA');
  AddStringRec(NR_NE2000RealInterface,'ne2000','realinterface','');

  AddBooleanRec(NR_Innova,'Innova','Innova',false);
  AddIntegerRec(NR_InnovaRate,'Innova','rate',22050);
  AddStringRec(NR_InnovaBase,'Innova','base','280');
  AddIntegerRec(NR_InnovaQuality,'Innova','quality',0);

  AddStringRec(NR_Autoexec,'Extra','autoexec','');
  AddBooleanRec(NR_AutoexecOverridegamestart,'Extra','Overridegamestart',False);
  AddBooleanRec(NR_AutoexecOverrideMount,'Extra','OverrideMount',False);
  AddStringRec(NR_AutoexecBootImage,'Extra','BootImage','');
  AddStringRec(NR_AutoexecFinalization,'Extra','Finalization','');

  AddStringRec(NR_CustomSettings,'Extra','CustomSettings','');
  AddStringRec(NR_Environment,'Extra','Environment','PATH[61]Z:\');

  AddIntegerRec(NR_LastOpenTab,'Extra','Tab',0);
  AddIntegerRec(NR_LastOpenTabModern,'Extra','Tab2',-1);

  AddStringRec(NR_ProfileMode,'Extra','ProfileMode','DOSBox');

  AddStringRec(NR_ScummVMGame,'ScummVM','GameName','');
  AddStringRec(NR_ScummVMPath,'ScummVM','GamePath','');
  AddStringRec(NR_ScummVMZip,'ScummVM','GameZipFile','');
  AddStringRec(NR_ScummVMFilter,'ScummVM','Filter','2x');
  AddStringRec(NR_ScummVMRenderMode,'ScummVM','RenderMode','');
  AddIntegerRec(NR_ScummVMAutosave,'ScummVM','AutosavePeriod',300);
  AddStringRec(NR_ScummVMLanguage,'ScummVM','Language','');
  AddIntegerRec(NR_ScummVMMusicVolume,'ScummVM','MusicVolume',192);
  AddIntegerRec(NR_ScummVMSpeechVolume,'ScummVM','SpeechVolume',192);
  AddIntegerRec(NR_ScummVMSFXVolume,'ScummVM','SFXVolume',192);
  AddIntegerRec(NR_ScummVMMIDIGain,'ScummVM','MIDIGain',100);
  AddIntegerRec(NR_ScummVMSampleRate,'ScummVM','SampleRate',22050);
  AddStringRec(NR_ScummVMMusicDriver,'ScummVM','MusicDriver','auto');
  AddBooleanRec(NR_ScummVMNativeMT32,'ScummVM','NativeMT32',False);
  AddBooleanRec(NR_ScummVMEnableGS,'ScummVM','EnableGS',False);
  AddBooleanRec(NR_ScummVMMultiMIDI,'ScummVM','MultiMIDI',False);
  AddIntegerRec(NR_ScummVMTalkSpeed,'ScummVM','TalkSpeed',60);
  AddBooleanRec(NR_ScummVMSpeechMute,'ScummVM','SpeechMute',False);
  AddBooleanRec(NR_ScummVMSubtitles,'ScummVM','Subtitles',True);
  AddStringRec(NR_ScummVMSavePath,'ScummVM','Savepath','');
  AddBooleanRec(NR_ScummVMConfirmExit,'ScummVM','ConfirmExit',False);
  AddIntegerRec(NR_ScummVMCDROM,'ScummVM','CDROM',0);
  AddIntegerRec(NR_ScummVMJoystickNum,'ScummVM','JoystickNum',0);
  AddBooleanRec(NR_ScummVMAltIntro,'ScummVM','AltIntro',False);
  AddIntegerRec(NR_ScummVMGFXDetails,'ScummVM','GFXDetails',3);
  AddBooleanRec(NR_ScummVMMusicMute,'ScummVM','MusicMute',False);
  AddBooleanRec(NR_ScummVMObjectLabels,'ScummVM','ObjectLabels',False);
  AddBooleanRec(NR_ScummVMReverseStereo,'ScummVM','ReverseStereo',False);
  AddBooleanRec(NR_ScummVMSFXMute,'ScummVM','SFXMute',False);
  AddIntegerRec(NR_ScummVMWalkspeed,'ScummVM','Walkspeed',2);
  AddStringRec(NR_ScummVMExtraPath,'ScummVM','ExtraPath','');
  AddStringRec(NR_ScummVMPlatform,'ScummVM','Platform','');
  AddStringRec(NR_ScummVMParameters,'ScummVM','AdditionalParameters','');

  AddStringRec(NR_CommandBeforeExecution,'ExtraCommands','BeforeExecution','');
  AddStringRec(NR_CommandAfterExecution,'ExtraCommands','AfterExecution','');
  AddBooleanRec(NR_CommandBeforeExecutionWait,'ExtraCommands','BeforeExecution.Wait',True);
  AddBooleanRec(NR_CommandBeforeExecutionMinimized,'ExtraCommands','BeforeExecution.Minimized',False);
  AddBooleanRec(NR_CommandAfterExecutionMinimized,'ExtraCommands','AfterExecution.Minimized',False);
  AddBooleanRec(NR_CommandBeforeExecutionParallel,'ExtraCommands','BeforeExecution.Parallel',False);
  AddBooleanRec(NR_CommandAfterExecutionParallel,'ExtraCommands','AfterExecution.Parallel',False);
  AddBooleanRec(NR_RunAsAdmin,'Extra','RunAsAdmin',False);

  AddStringRec(NR_AddtionalChecksumFile1,'ExtraGameIdentify','File1.Filename','');
  AddStringRec(NR_AddtionalChecksumFile1Checksum,'ExtraGameIdentify','File1.Checksum','');
  AddStringRec(NR_AddtionalChecksumFile2,'ExtraGameIdentify','File2.Filename','');
  AddStringRec(NR_AddtionalChecksumFile2Checksum,'ExtraGameIdentify','File2.Checksum','');
  AddStringRec(NR_AddtionalChecksumFile3,'ExtraGameIdentify','File3.Filename','');
  AddStringRec(NR_AddtionalChecksumFile3Checksum,'ExtraGameIdentify','File3.Checksum','');
  AddStringRec(NR_AddtionalChecksumFile4,'ExtraGameIdentify','File4.Filename','');
  AddStringRec(NR_AddtionalChecksumFile4Checksum,'ExtraGameIdentify','File4.Checksum','');
  AddStringRec(NR_AddtionalChecksumFile5,'ExtraGameIdentify','File5.Filename','');
  AddStringRec(NR_AddtionalChecksumFile5Checksum,'ExtraGameIdentify','File5.Checksum','');

  FastAddRecDone;
end;

Function TGame.GetExtraPrgFile(I : Integer) : String;
begin
  result:='';
  If (I<0) or (I>49) then exit;
  result:=GetString(NR_ExtraPrgFile+I);
end;

Function TGame.GetExtraPrgFileParameter(I : Integer) : String;
begin
  result:='';
  If (I<0) or (I>49) then exit;
  result:=GetString(NR_ExtraPrgFileParameter+I);
end;

function TGame.GetLicense: String;
Var I : Integer;
    St : TStringList;
begin
  result:='';
  St:=StringToStringList(UserInfo);
  try
    For I:=0 to St.Count-1 do If ExtUpperCase(Copy(Trim(St[I]),1,8))='LICENSE=' then begin result:=Copy(Trim(St[I]),9,MaxInt); break; end;
  finally
    St.Free;
  end;
end;

Procedure TGame.SetExtraPrgFile(I : Integer; S : String);
begin
  If (I<0) or (I>49) then exit;
  SetString(NR_ExtraPrgFile+I,S);
end;

Procedure TGame.SetExtraPrgFileParameter(I : Integer; S : String);
begin
  If (I<0) or (I>49) then exit;
  SetString(NR_ExtraPrgFileParameter+I,S);
end;

function TGame.GetMount(I: Integer): String;
begin
  If (I<0) or (I>9) then result:='' else result:=GetString(NR_Mount0+I);

 {Gives a compiler warning for (for me) unknown reason:
 Case I of
    0 : result:=Mount0;
    1 : result:=Mount1;
    2 : result:=Mount2;
    3 : result:=Mount3;
    4 : result:=Mount4;
    5 : result:=Mount5;
    6 : result:=Mount6;
    7 : result:=Mount7;
    8 : result:=Mount8;
    9 : result:=Mount9;
    else result:='';
  end;}
end;

procedure TGame.SetMount(I: Integer; const Value: String);
begin
  Case I of
    0 : Mount0:=Value;
    1 : Mount1:=Value;
    2 : Mount2:=Value;
    3 : Mount3:=Value;
    4 : Mount4:=Value;
    5 : Mount5:=Value;
    6 : Mount6:=Value;
    7 : Mount7:=Value;
    8 : Mount8:=Value;
    9 : Mount9:=Value;
  end;
end;

Function TGame.GetWWWNameString(I : Integer) : String;
Var S : String;
begin
  If (I<1) or (I>9) then begin result:=''; exit; end;
  result:=GetString(NR_WWW1Name+(I-1)*2);
  If Trim(result)='' then begin
    result:=GetString(NR_WWW1+(I-1)*2);
    S:=Trim(ExtUpperCase(result));
    if Copy(S,1,7)='HTTP:/'+'/' then result:=Copy(Trim(result),8,MaxInt);
    if Copy(S,1,8)='HTTPS:/'+'/' then result:=Copy(Trim(result),9,MaxInt);
  end;
end;

Function TGame.GetPlainWWWNameString(I : Integer) : String;
begin
  If (I<1) or (I>9) then begin result:=''; exit; end;
  result:=GetString(NR_WWW1Name+(I-1)*2);
end;

Procedure TGame.SetWWWNameString(I : Integer; const Value : String);
begin
  If (I<1) or (I>9) then exit;
  SetString(NR_WWW1Name+(I-1)*2,Value);
end;

Function TGame.GetWWWString(I : Integer) : String;
begin
  If (I<1) or (I>9) then begin result:=''; exit; end;
  result:=GetString(NR_WWW1+(I-1)*2);
end;

Procedure TGame.SetWWWString(I : Integer; const Value : String);
begin
  If (I<1) or (I>9) then exit;
  SetString(NR_WWW1+(I-1)*2,Value);
end;

procedure TGame.LoadCache;
begin
  CacheName:=Name;
  CacheNameUpper:=ExtUpperCase(CacheName);
  CacheGenre:=Genre;
  CacheGenreUpper:=ExtUpperCase(CacheGenre);
  CacheDeveloper:=Developer;
  CacheDeveloperUpper:=ExtUpperCase(CacheDeveloper);
  CachePublisher:=Publisher;
  CachePublisherUpper:=ExtUpperCase(CachePublisher);
  CacheYear:=Year;
  CacheYearUpper:=ExtUpperCase(CacheYear);
  CacheLanguage:=Language;
  CacheLanguageUpper:=ExtUpperCase(CacheLanguage);
  CacheUserInfo:=UserInfo;
end;

Procedure TGame.ReloadINI;
begin
  inherited ReloadINI;
  LoadCache;
end;

Procedure TGame.CreateConfFile;
Var St : TStringList;
begin
  If not DOSBoxMode(self) then exit;

  St:=BuildConfFile(self,False,False,-1,nil,false);
  try
    St.SaveToFile(ChangeFileExt(SetupFile,'.conf'));
  finally
    St.Free;
  end;
end;


Procedure TGame.RenameINI(const NewFile : String);
Var OldName,NewName : String;
begin
  OldName:=ChangeFileExt(SetupFile,'.conf');
  inherited RenameINI(NewFile);
  NewName:=ChangeFileExt(SetupFile,'.conf');
  If Assigned(FGameDB) and FGameDB.CreateConfFilesOnSave then begin
    If FileExists(OldName) then MoveFile(PChar(OldName),PChar(NewName)) else CreateConfFile;
  end;
end;

procedure TGame.UpdateFile;
begin
  inherited UpdateFile;
  LastModification:=IntToStr(Round(Int(Now)))+'-'+IntToStr(Round(Frac(Now)*86400));
  If Assigned(FGameDB) and FGameDB.CreateConfFilesOnSave then CreateConfFile;
end;

Procedure TGame.AssignFromButKeepScummVMSettings(const AGame : TGame);
begin
  AssignFromPartially(AGame,ScummVMSettings);
end;

{ TGameDB }

constructor TGameDB.Create(const ADir : String; const ATimeStampCheck : Boolean);
Var Msg : tagMSG;
    B : Boolean;
begin
  inherited Create;

  LogInfo('### Start of TGameDB.Create ('+ADir+') ###');

  FCreateConfFilesOnSave:=False;
  FGameList:=TList.Create;

  LogInfo('Create conf opts object');
  FConfOpt:=TConfOpt.Create;
  If ATimeStampCheck then FConfOpt.CacheAllStrings;
  FDir:=IncludeTrailingPathDelimiter(ADir);
  FTimeStampCheck:=ATimeStampCheck;
  B:=False;
  If Application.MainForm<>nil then begin
    B:=Application.MainForm.Enabled;
   Application.MainForm.Enabled:=False;
  end;
  try
    LogInfo('Start loading profiles');
    LoadList;
  finally
    If Application.MainForm<>nil then begin
      While PeekMessage(Msg,Application.MainForm.Handle,WM_INPUT,WM_INPUT,1) do ;
      Application.MainForm.Enabled:=B;
    end;
  end;

  LogInfo('Deleting old files');
  DeleteOldFiles;

  LogInfo('### End of TGameDB.Create ###');
end;

destructor TGameDB.Destroy;
begin
  If PrgSetup.BinaryCache then begin
    If FGameList.Count>20 then StoreBinCache else DeleteFile(FDir+CacheFile);
  end;
  Clear;
  FGameList.Free;
  FConfOpt.Free;
  inherited Destroy;
end;

procedure TGameDB.Clear;
Var I : Integer;
begin
  For I:=0 to FGameList.Count-1 do TGame(FGameList[I]).Free;
  FGameList.Clear;
end;

Procedure TGameDB.LoadGameFromFile(const FileName: String; const DOSFileDate : Integer);
Var Game : TGame;
begin
  LogInfo('Loading profile '+FileName);
  If PrgSetup.BinaryCache and GetLoadBinCacheOffset(FileName,DOSFileDate) then begin
    LogInfo('Trying to load from cache');
    Game:=TGame.CreateDelayed(FileName,FTimeStampCheck);
    try
      Game.InitData;
      Game.LoadFromStream(BinLoadCache);
      Game.LoadCache;
    except
      LogInfo('Cache failed, burning cache for all profiles and loading from prof file');
      Game.Free;
      Game:=TGame.Create(FileName);
      BurnLoadBinCache;
    end;
    If Game.GameExeMD5='' then begin
      LogInfo('No game exe MD5 sum. May be there is just no MD5 sum stored but may be also this cached profile is damaged. Loading this profile from prof file for safety reasons.');
      Game.Free;
      Game:=TGame.Create(FileName);
    end;
  end else begin
    LogInfo('Loading profile from prof file');
    Game:=TGame.Create(FileName);
  end;

  LogInfo('Adding profile to data base list');
  Game.OnChanged:=GameChanged;
  Game.GameDB:=self;
  FGameList.Add(Game);
end;

Function TGameDB.GetProfilesListFromDrive : TStringList;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=TStringList.Create;

  I:=FindFirst(FDir+'*.prof',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)=0 then result.AddObject(Rec.Name,TObject(Rec.Time));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TGameDB.LoadList;
Var I : Integer;
    List : TStringList;
    {$IFDEF SpeedTest}C0,{$ENDIF}C1,C2 : Cardinal;
begin
  Clear;
  ForceDirectories(FDir);

  If PrgSetup.BinaryCache then begin
    LogInfo('Init binary cache');
    InitLoadBinCache;
  end;

  {$IFDEF SpeedTest}C0:=GetTickCount; {$ENDIF}
  LogInfo('Loading profiles file list from drive');
  List:=GetProfilesListFromDrive;
  WaitForm:=nil;

    try
      FGameList.Capacity:=List.Count;
      C1:=GetTickCount;

      For I:=0 to Min(List.Count,100)-1 do begin
        LoadGameFromFile(FDir+List[I],Integer(List.Objects[I]));
        If (I mod 10)=0 then Application.ProcessMessages;
      end;

      If List.Count>100 then begin
        C2:=GetTickCount;
        If Integer(C2-C1)*List.Count div 100>150 then WaitForm:=CreateWaitForm(nil,LanguageSetup.MessageLoadingDataBase,List.Count);
        For I:=100 to List.Count-1 do begin
          If (WaitForm<>nil) and ((I mod 50)=0) then WaitForm.Step(I);
          LoadGameFromFile(FDir+List[I],Integer(List.Objects[I]));
          If (I mod 10)=0 then Application.ProcessMessages;
        end;
      end;

      {$IFDEF SpeedTest}C2:=GetTickCount; If List.Count>100 then ShowMessage(IntToStr(C1-C0)+#13+IntToStr(C2-C1)+#13+FDir);{$ENDIF}

  finally
    List.Free;
    If Assigned(WaitForm) then FreeAndNil(WaitForm);
  end;

  If PrgSetup.BinaryCache then begin
    LogInfo('Freeing binary cache');
    DoneLoadBinCache;
  end;

  If Application.MainForm<>nil then ForceForegroundWindow(Application.MainForm.Handle);
end;

procedure TGameDB.DeleteOldFiles;
Var Rec : TSearchRec;
    I : Integer;
begin
  If not PrgSetup.CreateConfFilesForProfiles or (OperationMode=omPortable) then begin
    I:=FindFirst(FDir+'*.conf',faAnyFile,Rec);
    try
      while I=0 do begin
        ExtDeleteFile(FDir+Rec.Name,ftProfile);
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
  end;

  I:=FindFirst(FDir+'Tempprof.*',faAnyFile,Rec);
  try
    while I=0 do begin
      ExtDeleteFile(FDir+Rec.Name,ftProfile);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

function TGameDB.MakePROFFileName(const AName, ADir: String; const CheckExistingFiles : Boolean): String;
const AllowedChars='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyzäöüß01234567890-_=.,;!() ';
Var I : Integer;
begin
  result:='';
  For I:=1 to length(AName) do if Pos(AName[I],AllowedChars)>0 then result:=result+AName[I];
  if result='' then result:='Game';

  if FileExists(ADir+result+'.prof') and CheckExistingFiles then begin
    I:=0;
    repeat inc(I) until not FileExists(ADir+result+IntToStr(I)+'.prof');
    result:=ADir+result+IntToStr(I)+'.prof';
  end else begin
    result:=ADir+result+'.prof';
  end;
end;

Function TGameDB.ProfFileName(const AName : String; const CheckExistingFiles : Boolean) : String;
Var S : String;
begin
  S:=Trim(ExtUpperCase(AName));
  If (Copy(S,length(S)-4,5)='.PROF') or (Copy(S,length(S)-4,5)='.CONF') then begin
    S:=Trim(AName); S:=Trim(Copy(S,1,length(S)-5));
  end else begin
    S:=AName;
  end;
  result:=MakePROFFileName(Trim(S),FDir,CheckExistingFiles);
end;

function TGameDB.Add(const AName: String): Integer;
Var Game : TGame;
begin
  Game:=TGame.Create(MakePROFFileName(AName,FDir,True));
  Game.Name:=AName;
  Game.OnChanged:=GameChanged;
  Game.GameDB:=self;
  result:=FGameList.Add(Game);
end;

Function TGameDB.Add(const AGame : TGame) : Integer;
begin
  AGame.OnChanged:=GameChanged;
  result:=FGameList.Add(AGame);
  AGame.GameDB:=self;
end;

function TGameDB.Delete(const Index: Integer): Boolean;
Var FileName : String;
begin
  result:=(Index>=0) and (Index<FGameList.Count);
  if not result then exit;
  FileName:=TGame(FGameList[Index]).SetupFile;
  TGame(FGameList[Index]).Free;
  FGameList.Delete(Index);

  If FileExists(FileName) then begin
    If not ExtDeleteFile(FileName,ftProfile) then MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName]),mtError,[mbOK],0);
  end;
  If FileExists(ChangeFileExt(FileName,'.conf')) then begin
    If not ExtDeleteFile(ChangeFileExt(FileName,'.conf'),ftProfile) then MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ChangeFileExt(FileName,'.conf')]),mtError,[mbOK],0);
  end;
end;

function TGameDB.Delete(const AGame: TGame): Boolean;
begin
  result:=Delete(IndexOf(AGame));
end;

function TGameDB.IndexOf(const AGame: TGame): Integer;
Var I : Integer;
begin
  result:=-1;
  For I:=0 to FGameList.Count-1 do If TGame(FGameList[I])=AGame then begin result:=I; exit; end;
end;

function TGameDB.IndexOf(const AGame: String): Integer;
Var I : Integer;
begin
  result:=-1;
  For I:=0 to FGameList.Count-1 do If TGame(FGameList[I]).Name=AGame then begin result:=I; exit; end;
end;

function TGameDB.GetCount: Integer;
begin
  result:=FGameList.Count;
end;

function TGameDB.GetGame(I: Integer): TGame;
begin
  If (I<0) or (I>=FGameList.Count) then result:=nil else result:=TGame(FGameList[I]);
end;

function TGameDB.GetSortedGamesList: TList;
Var St : TStringList;
    I : Integer;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do St.AddObject(TGame(FGameList[I]).Name,TGame(FGameList[I]));
    St.Sort;

    result:=TList.Create;
    For I:=0 to St.Count-1 do result.Add(St.Objects[I]);
  finally
    St.Free;
  end;
end;

Function GetList(const St : TStringList) : TStringList;
Var StUpper : TStringList;
    I,J : Integer;
    S,T : String;
begin
  result:=TStringList.Create;
  StUpper:=TStringList.Create;
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      If S='' then S:=LanguageSetup.NotSet;
      while S<>'' do begin
        J:=Pos(';',S);
        If J>0 then begin
          T:=Trim(Copy(S,1,J-1));
          S:=Trim(Copy(S,J+1,MaxInt));
        end else begin
          T:=S; S:='';
        end;
        If StUpper.IndexOf(ExtUpperCase(T))<0 then begin
          result.Add(T);
          StUpper.Add(ExtUpperCase(T));
        end;
      end;
    end;
  finally
    StUpper.Free;
  end;
  result.Sort;
end;

function TGameDB.GetGenreList(WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean): TStringList;
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      St.Add(TGame(FGameList[I]).CacheGenre);
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

function TGameDB.GetDeveloperList(WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean): TStringList;
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      St.Add(TGame(FGameList[I]).CacheDeveloper);
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

function TGameDB.GetPublisherList(WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean): TStringList;
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      St.Add(TGame(FGameList[I]).CachePublisher);
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

function TGameDB.GetYearList(WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean): TStringList;
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      St.Add(TGame(FGameList[I]).CacheYear);
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

function TGameDB.GetLanguageList(WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean): TStringList;
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      St.Add(TGame(FGameList[I]).CacheLanguage);
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

Function TGameDB.GetLicenseList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      St.Add(TGame(FGameList[I]).License);
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

Function TGameDB.GetWWWList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
Var I,J : Integer;
    St : TStringList;
    S : String;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      For J:=1 to 9 do begin
        S:=TGame(FGameList[I]).WWW[J];
        If (J=1) or (Trim(S)<>'') then St.Add(S);
      end;
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

Function TGameDB.GetWWWNameList(WithDefaultProfile : Boolean =True; const HideWindowsProfiles : Boolean = False) : TStringList;
Var I,J : Integer;
    St : TStringList;
    S : String;
begin
  St:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin
      If HideWindowsProfiles and WindowsExeMode(TGame(FGameList[I])) then continue;
      For J:=1 to 9 do begin
        S:=TGame(FGameList[I]).WWWNamePlain[J];
        If Trim(S)<>'' then St.Add(S);
      end;
    end;
    result:=GetList(St);
  finally
    St.Free;
  end;
end;

Function TGameDB.GetKeyValueList(const Key : String; WithDefaultProfile : Boolean =True) : TStringList;
Var StUpper,St,St2 : TStringList;
    I,J,K : Integer;
    S,T,KeyUpper,Val : String;
begin
  result:=TStringList.Create;
  StUpper:=TStringList.Create;
  St:=TStringList.Create;
  KeyUpper:=ExtUpperCase(Key);
  try
    For I:=0 to FGameList.Count-1 do If WithDefaultProfile or (TGame(FGameList[I]).Name<>DosBoxDOSProfile) then begin

      St2:=StringToStringList(TGame(FGameList[I]).CacheUserInfo);
      try
        Val:='';
        For K:=0 to St2.Count-1 do begin
          S:=St2[K]; J:=Pos('=',S); If J=0 then T:='' else begin T:=Trim(Copy(S,J+1,MaxInt)); S:=Trim(Copy(S,1,J-1)); end;
          If Trim(ExtUpperCase(S))=KeyUpper then begin Val:=Trim(T); break; end;
        end;
        If Val='' then Val:=LanguageSetup.NotSet;
        S:=Val;
        while S<>'' do begin
          J:=Pos(';',S);
          If J>0 then begin
            T:=Trim(Copy(S,1,J-1));
            S:=Trim(Copy(S,J+1,MaxInt));
          end else begin
            T:=S; S:='';
          end;
          If StUpper.IndexOf(ExtUpperCase(T))<0 then begin
            result.Add(T);
            StUpper.Add(ExtUpperCase(T));
          end;
        end;
      finally
        St2.Free;
      end;
    end;
  finally
    St.Free;
    StUpper.Free;
  end;
  result.Sort;
end;

Function TGameDB.GetUserKeys : TStringList;
Var StUpper,St : TStringList;
    I,J,K : Integer;
    S : String;
begin
  result:=TStringList.Create;
  StUpper:=TStringList.Create;
  try
    For I:=0 to FGameList.Count-1 do begin
      St:=StringToStringList(TGame(FGameList[I]).CacheUserInfo);
      try
        For K:=0 to St.Count-1 do begin
          S:=St[K]; J:=Pos('=',S); If J=0 then continue;
          S:=Trim(Copy(S,1,J-1));
          If StUpper.IndexOf(ExtUpperCase(S))>=0 then continue;
          result.Add(S);
          StUpper.Add(ExtUpperCase(S));
        end;
      finally
        St.Free;
      end;
    end;
  finally
    StUpper.Free;
  end;
  result.Sort;
end;

procedure TGameDB.GameChanged(Sender: TObject);
begin
  If Assigned(FOnChanged) then FOnChanged(self);
end;

procedure TGameDB.StoreAllValues;
Var I : Integer;
begin
  For I:=0 to FGameList.Count-1 do TGame(FGameList[I]).StoreAllValues;
end;

procedure TGameDB.LoadCache;
Var I : Integer;
begin
  For I:=0 to FGameList.Count-1 do TGame(FGameList[I]).LoadCache;
end;

Procedure TGameDB.StoreBinCache;
Var St,StFinal : TMemoryStream;
    Index : Array['A'..'Z'] of TStringList;
    IndexRest : TStringList;
    I,J : Integer;
    W : Word;
    G : TGame;
    C : Char;
    S : String;
begin
  St:=TMemoryStream.Create;
  IndexRest:=TStringList.Create;
  For C:='A' to 'Z' do Index[C]:=TStringList.Create;
  try
    {Store game data to temporary stream}
    For I:=0 to FGameList.Count-1 do begin
      G:=TGame(FGameList[I]);
      S:=ExtractFileName(G.SetupFile);
      S:=ExtUpperCase(S);
      If S<>'' then C:=S[1] else C:=' ';
      J:=St.Position;
      If (C>='A') and (C<='Z') then
      Index[C].AddObject(S,TObject(J)) else IndexRest.AddObject(S,TObject(J));
      J:=GetDOSFileDate(G.SetupFile);
      St.WriteBuffer(J,SizeOf(Integer));
      G.SaveToStream(St);
    end;

    {Store to output file}
    StFinal:=TMemoryStream.Create;
    try
      {Write ID}
      StFinal.WriteBuffer(CacheVersionString[1],length(CacheVersionString));
      StFinal.WriteBuffer(CacheInfoString[1],length(CacheInfoString));
      If FGameList.Count>0 then I:=TGame(FGameList[0]).GetBinaryVersionID else I:=0;
      StFinal.WriteBuffer(I,SizeOf(Integer));

      {Write index}
      For C:='A' to 'Z' do begin
        I:=Index[C].Count; StFinal.WriteBuffer(I,SizeOf(Integer));
        For I:=0 to Index[C].Count-1 do begin
          S:=ChangeFileExt(Index[C][I],'');
          W:=length(S); StFinal.WriteBuffer(W,SizeOf(Word)); StFinal.WriteBuffer(S[1],W);
          J:=Integer(Index[C].Objects[I]); StFinal.WriteBuffer(J,SizeOf(Integer));
        end;
      end;
      I:=IndexRest.Count; StFinal.WriteBuffer(I,SizeOf(Integer));
      For I:=0 to IndexRest.Count-1 do begin
        S:=ChangeFileExt(IndexRest[I],'');
        W:=length(S); StFinal.WriteBuffer(W,SizeOf(Word)); StFinal.WriteBuffer(S[1],W);
        J:=Integer(IndexRest.Objects[I]); StFinal.WriteBuffer(J,SizeOf(Integer));
      end;

      {Write data}
      StFinal.CopyFrom(St,0);

      StFinal.SaveToFile(FDir+CacheFile);
    finally
      StFinal.Free;
    end;
  finally
    IndexRest.Free;
    For C:='A' to 'Z' do Index[C].Free;
    St.Free;
  end;
end;

Procedure TGameDB.InitLoadBinCache;
Var C : Char;
    S : String;
    I,J,K : Integer;
    W : Word;
begin
  BinLoadCache:=TMemoryStream.Create;
  For C:='A' to 'Z' do BinLoadCacheIndex[C]:=TStringList.Create;
  BinLoadCacheIndexRest:=TStringList.Create;
  BinLoadCacheOffset:=0;

  If not FileExists(FDir+CacheFile) then exit;
  try BinLoadCache.LoadFromFile(FDir+CacheFile); except exit; end;

  try
    SetLength(S,length(CacheVersionString));
    BinLoadCache.ReadBuffer(S[1],length(S));
    If S<>CacheVersionString then exit;

    BinLoadCache.Position:=BinLoadCache.Position+length(CacheInfoString);

    BinLoadCache.ReadBuffer(I,SizeOf(Integer));
    If not CheckGameBinaryVersionID(I) then exit;

  except exit; end;

  try
    For C:='A' to 'Z' do begin
      BinLoadCache.ReadBuffer(I,SizeOf(Integer));
      For J:=0 to I-1 do begin
        BinLoadCache.ReadBuffer(W,SizeOf(Word));
        SetLength(S,W); BinLoadCache.ReadBuffer(S[1],W);
        BinLoadCache.ReadBuffer(K,SizeOf(Integer));
        BinLoadCacheIndex[C].AddObject(S,TObject(K));
      end;
    end;
    BinLoadCache.ReadBuffer(I,SizeOf(Integer));
    For J:=0 to I-1 do begin
      BinLoadCache.ReadBuffer(W,SizeOf(Word));
      SetLength(S,W); BinLoadCache.ReadBuffer(S[1],W);
      BinLoadCache.ReadBuffer(K,SizeOf(Integer));
      BinLoadCacheIndexRest.AddObject(S,TObject(K));
    end;
  except
    BurnLoadBinCache;
  end;

  BinLoadCacheOffset:=BinLoadCache.Position;
end;

Function TGameDB.CheckGameBinaryVersionID(const CacheVersionID : Integer) : Boolean;
Var G : TGame;
begin
  G:=TGame.Create(PrgSetup);
  try
    result:=(G.GetBinaryVersionID=CacheVersionID);
  finally
    G.Free;
  end;
end;

Procedure TGameDB.DoneLoadBinCache;
Var C : Char;
begin
  BinLoadCache.Free;
  For C:='A' to 'Z' do BinLoadCacheIndex[C].Free;
  BinLoadCacheIndexRest.Free;
end;

Procedure TGameDB.BurnLoadBinCache;
Var C : Char;
begin
  If FileExists(FDir+CacheFile) then DeleteFile(FDir+CacheFile);
  For C:='A' to 'Z' do BinLoadCacheIndex[C].Clear;
  BinLoadCacheIndexRest.Clear;
end;

Function TGameDB.GetLoadBinCacheOffset(const FileName : String; const DOSFileDate : Integer) : Boolean;
Var S : String;
    C : Char;
    I,J : Integer;
begin
  result:=False;

  try
    S:=ExtUpperCase(ChangeFileExt(ExtractFileName(FileName),''));
    If S<>'' then C:=S[1] else C:=' ';

    If (C>='A') and (C<='Z') then begin
      I:=-1;
      If (BinLoadCacheIndexLastIndex[C]>0) and (BinLoadCacheIndexLastIndex[C]<BinLoadCacheIndex[C].Count-1) then begin
        If BinLoadCacheIndex[C][BinLoadCacheIndexLastIndex[C]+1]=S then I:=BinLoadCacheIndexLastIndex[C]+1;
      end;
      If I<0 then I:=BinLoadCacheIndex[C].IndexOf(S);
      If I<0 then exit;
      BinLoadCacheIndexLastIndex[C]:=I;
      J:=Integer(BinLoadCacheIndex[C].Objects[I]);
    end else begin
      I:=-1;
      If (BinLoadCacheIndexRestLastIndex>0) and (BinLoadCacheIndexRestLastIndex<BinLoadCacheIndexRest.Count-1) then begin
        If BinLoadCacheIndexRest[BinLoadCacheIndexRestLastIndex+1]=S then I:=BinLoadCacheIndexRestLastIndex+1;
      end;
      If I<0 then I:=BinLoadCacheIndexRest.IndexOf(S);
      If I<0 then exit;
      BinLoadCacheIndexRestLastIndex:=I;
      J:=Integer(BinLoadCacheIndexRest.Objects[I]);
    end;

    BinLoadCache.Position:=BinLoadCacheOffset+J;

    BinLoadCache.ReadBuffer(I,SizeOf(Integer));
    if I<>DOSFileDate then exit;
  except
    exit;
  end;

  result:=True;
end;

initialization
  DefaultValueReaderGame:=TGame.Create('');
finalization
  If Assigned(DefaultValueReaderGame) then DefaultValueReaderGame.Free;
end.
