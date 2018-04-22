unit CreateImageToolsUnit;
interface

uses Classes, GameDBUnit;

{Floppy image} Function DiskImageCreator(const Cylinders, Heads, SPT : Integer; const ImageFileName : String; const CompressImage, FAT : Boolean) : Boolean; overload;
{Default floppy image} Function DiskImageCreator(const ImageFileName : String) : Boolean; overload;
{HD image} Function DiskImageCreator(const HDSize : Integer; const ImageFileName : String; const CompressImage, FAT : Boolean) : Boolean; overload;

Type TDiskImageCreatorUpgrade=(dicuMakeBootable,dicuKeyboardDriver,dicuMouseDriver,dicuMemoryManager,dicuDiskTools,dicuEditor,dicuDoszip,dicuAutoexecAddLines,dicuCopyFolder,dicuSwapMouseButtons,dicuForce2ButtonMouseMode,dicuUseFD11Tools);
Type TDiskImageCreatorUpgrades=set of TDiskImageCreatorUpgrade;

Function DiskImageCreatorUpgrade(const ImageFileName : String; const IsHDImage : Boolean; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders : TStringList =nil; const CopyFoldersDest : TStringList =nil; const AutoexecAdd : TStringList =nil; const Game : TGame = nil; const FloppyCylinders : Integer = 80; const FloppyHeads : Integer = 2; const FloppySPT : Integer = 18) : Boolean;
Function DiskImageCreatorUpgradeSize(const IsHDImage : Boolean; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders : TStringList =nil; const AddMB : Integer =0) : Integer;

Function FD11ToolsAvailable : Boolean;
Function DosZipAvailable : Boolean;

implementation

uses Windows, SysUtils, Math, Dialogs, CommonTools, PrgConsts, PrgSetupUnit,
     LanguageSetupUnit, DOSBoxUnit, ImageTools, DOSBoxTempUnit, MainUnit;

{Creating plain and fat disk images}

Function DiskImageCreatorFATAvailable : Boolean;
begin
  result:=FileExists(PrgDir+MakeDOSFilesystemFileName) or FileExists(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName);
end;

const COMPRESSION_FORMAT_NONE    = 0;
      COMPRESSION_FORMAT_DEFAULT = 1;
      FILE_DEVICE_FILE_SYSTEM    = 9;
      METHOD_BUFFERED            = 0;
      FILE_READ_DATA             = 1;
      FILE_WRITE_DATA            = 2;
      FSCTL_SET_COMPRESSION      = (FILE_DEVICE_FILE_SYSTEM shl 16) or ((FILE_READ_DATA or FILE_WRITE_DATA) shl 14) or (16 shl 2) or METHOD_BUFFERED;

Procedure CompressFile(const FileName : String);
Var hFile : THandle;
    Mode : Short;
    C : Cardinal;
begin
  hFile:=CreateFile(PChar(Filename),GENERIC_WRITE or GENERIC_READ,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if hFile=INVALID_HANDLE_VALUE then exit;
  try
    Mode:=COMPRESSION_FORMAT_DEFAULT;
    DeviceIoControl(hFile, FSCTL_SET_COMPRESSION,@Mode,sizeof(Mode),nil,0,C,nil);
  finally
    CloseHandle(hFile);
  end;
end;

Function DiskImageCreatorPlainInt(const SecCount : Integer; const ImageFileName : String; const CompressImage : Boolean) : Boolean;
Var hFile : THandle;
    Buffer : Array[0..511] of Byte;
    C : Cardinal;
    I1, I2 : Integer;
    Mode : Short;
begin
  FillChar(Buffer,SizeOf(Buffer),0);

  hFile:=CreateFile(PChar(ImageFileName),GENERIC_WRITE or GENERIC_READ,0,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
  result:=(hFile<>INVALID_HANDLE_VALUE); if not result then exit;
  try
    result:=WriteFile(hFile,Buffer,SizeOf(Buffer),C,nil) and (C=SizeOf(Buffer)); if not result then exit;

    If CompressImage then begin
      Mode:=COMPRESSION_FORMAT_DEFAULT;
      DeviceIoControl(hFile, FSCTL_SET_COMPRESSION,@Mode,sizeof(Mode),nil,0,C,nil);
    end;

    I1:=((SecCount-1) shl 9);
    I2:=((SecCount-1) shr 23);
    result:=(SetFilePointer(hFile,I1,@I2,FILE_BEGIN)<>$ffffffff);

    result:=WriteFile(hFile,Buffer,SizeOf(Buffer),C,nil) and (C=SizeOf(Buffer));
  finally
    CloseHandle(hFile);
    if not result then MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[ImageFileName]),mtError,[mbOK],0);
  end;
end;

Function DiskImageCreatorPlain(const Cylinders, Heads, SPT : Integer; const ImageFileName : String; const CompressImage : Boolean) : Boolean; overload;
begin
  result:=DiskImageCreatorPlainInt(Cylinders*Heads*SPT,ImageFileName,CompressImage);
end;

Function DiskImageCreatorPlain(const HDSize : Integer; const ImageFileName : String; const CompressImage : Boolean) : Boolean; overload;
Var I : Integer;
begin
  result:=False;
  try I:=HDSize*128 div 63; {512*63*16*X=Bytes => X=MBytes*128/63} except I:=-1; end;
  If I<=0 then begin
    MessageDlg(LanguageSetup.MessageWrongDiskSize,mtError,[mbOK],0);
    exit;
  end;
  I:=I*16*63;
  result:=DiskImageCreatorPlainInt(I,ImageFileName,CompressImage);
end;

Procedure DiskImageCreatorFATInt(const Data : TStringList; const ImageFileName : String; const CompressImage : Boolean);
begin
  If FileExists(PrgDir+MakeDOSFilesystemFileName) then begin
    if not RunWithInput(PrgDir+MakeDOSFilesystemFileName,'',False,Data) then exit;
  end else begin
    if not RunWithInput(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName,'',False,Data) then exit;
  end;
  If CompressImage then CompressFile(ImageFileName);
end;

Function DiskImageCreatorFAT(const Cylinders, Heads, SPT : Integer; const ImageFileName : String; const CompressImage : Boolean) : Boolean; overload;
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    {type} St.Add('fd');
    {filename} St.Add(ImageFileName);
    {sectors/tracks} St.Add(IntToStr(SPT));
    {heads} St.Add(IntToStr(Heads));
    {cylinders} St.Add(IntToStr(Cylinders));
    {sectors/cluster} If (SPT=36) and (Heads=2) and (Cylinders=80) then St.Add('2') else St.Add('1');
    {number of fats} St.Add('2');
    {fat size} St.Add('12');
    DiskImageCreatorFATInt(St,ImageFileName,CompressImage);
  finally
    St.Free;
  end;
  result:=True;
end;

Function DiskImageCreatorFAT(const HDSize : Integer; const ImageFileName : String; const CompressImage : Boolean) : Boolean; overload;
Var St : TStringList;
    I : Integer;
begin
  result:=False;
  St:=TStringList.Create;
  try
      I:=HDSize;
      If (I<=0) or (I>1000) then begin
        MessageDlg(LanguageSetup.MessageWrongDiskSize,mtError,[mbOK],0);
        exit;
      end;
      I:=(I*1024) div 1000;
      {type} St.Add('hd');
      {create MBR} St.Add('y');
      {filename} St.Add(ImageFileName);
      {size (in MB)} St.Add(IntToStr(I));
      {sectors/track} Case I of
        1.. 32 : St.Add('1');
       33.. 64 : St.Add('2');
       65..128 : St.Add('4');
      129..256 : St.Add('8');
      257..512 : St.Add('16');
      else       St.Add('32');
      End;
      {number of fats} St.Add('2');
      {fat size} St.Add('16');
      DiskImageCreatorFATInt(St,ImageFileName,CompressImage);
  finally
    St.Free;
  end;
  result:=True;
end;

Function DiskImageCreator(const Cylinders, Heads, SPT : Integer; const ImageFileName : String; const CompressImage, FAT : Boolean) : Boolean;
begin
  If FAT and DiskImageCreatorFATAvailable
    then result:=DiskImageCreatorFAT(Cylinders,Heads,SPT,ImageFileName,CompressImage)
    else result:=DiskImageCreatorPlain(Cylinders,Heads,SPT,ImageFileName,CompressImage);
end;

Function DiskImageCreator(const ImageFileName : String) : Boolean;
begin
  result:=DiskImageCreatorFATAvailable and DiskImageCreator(80,2,18,ImageFileName,False,True);
end;

Function DiskImageCreator(const HDSize : Integer; const ImageFileName : String; const CompressImage, FAT : Boolean) : Boolean;
begin
  If FAT and DiskImageCreatorFATAvailable
    then result:=DiskImageCreatorFAT(HDSize,ImageFileName,CompressImage)
    else result:=DiskImageCreatorPlain(HDSize,ImageFileName,CompressImage);
end;

{Making images bootable and copy files}

const BootSec : Array[0..511] of Byte = (
  $EB, $3C, $90, $46, $52, $44, $4F, $53, $34, $2E, $31, $00, $02, $01, $01, $00, $02, $E0, $00, $40, $0B, $F0, $09, $00,
  $12, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $29, $0B, $60, $F5, $37, $46, $52, $45, $45, $44,
  $4F, $53, $32, $30, $30, $30, $46, $41, $54, $31, $32, $20, $20, $20, $FA, $FC, $31, $C0, $8E, $D8, $BD, $00, $7C, $B8,
  $E0, $1F, $8E, $C0, $89, $EE, $89, $EF, $B9, $00, $01, $F3, $A5, $EA, $5E, $7C, $E0, $1F, $00, $00, $60, $00, $8E, $D8,
  $8E, $D0, $8D, $66, $A0, $FB, $80, $7E, $24, $FF, $75, $03, $88, $56, $24, $C7, $46, $C0, $10, $00, $C7, $46, $C2, $01,
  $00, $8C, $5E, $C6, $C7, $46, $C4, $A0, $63, $8B, $76, $1C, $8B, $7E, $1E, $03, $76, $0E, $83, $D7, $00, $89, $76, $D2,
  $89, $7E, $D4, $8A, $46, $10, $98, $F7, $66, $16, $01, $C6, $11, $D7, $89, $76, $D6, $89, $7E, $D8, $8B, $5E, $0B, $B1,
  $05, $D3, $EB, $8B, $46, $11, $31, $D2, $F7, $F3, $50, $01, $C6, $83, $D7, $00, $89, $76, $DA, $89, $7E, $DC, $8B, $46,
  $D6, $8B, $56, $D8, $5F, $C4, $5E, $5A, $E8, $98, $00, $C4, $7E, $5A, $B9, $0B, $00, $BE, $F1, $7D, $57, $F3, $A6, $5F,
  $26, $8B, $45, $1A, $74, $0B, $83, $C7, $20, $26, $80, $3D, $00, $75, $E7, $72, $68, $50, $C4, $5E, $5A, $8B, $7E, $16,
  $8B, $46, $D2, $8B, $56, $D4, $E8, $6A, $00, $58, $1E, $07, $8E, $5E, $5C, $BF, $00, $20, $AB, $89, $C6, $01, $F6, $01,
  $C6, $D1, $EE, $AD, $73, $04, $B1, $04, $D3, $E8, $80, $E4, $0F, $3D, $F8, $0F, $72, $E8, $31, $C0, $AB, $0E, $1F, $C4,
  $5E, $5A, $BE, $00, $20, $AD, $09, $C0, $75, $05, $88, $D3, $FF, $6E, $5A, $48, $48, $8B, $7E, $0D, $81, $E7, $FF, $00,
  $F7, $E7, $03, $46, $DA, $13, $56, $DC, $E8, $20, $00, $EB, $E0, $5E, $AC, $56, $B4, $0E, $CD, $10, $3C, $2E, $75, $F5,
  $C3, $E8, $F1, $FF, $45, $72, $72, $6F, $72, $21, $2E, $30, $E4, $CD, $13, $CD, $16, $CD, $19, $56, $89, $46, $C8, $89,
  $56, $CA, $8C, $86, $9E, $E7, $89, $9E, $9C, $E7, $E8, $D0, $FF, $2E, $B4, $41, $BB, $AA, $55, $8A, $56, $24, $84, $D2,
  $74, $19, $CD, $13, $72, $15, $D1, $E9, $81, $DB, $54, $AA, $75, $0D, $8D, $76, $C0, $89, $5E, $CC, $89, $5E, $CE, $B4,
  $42, $EB, $26, $8B, $4E, $C8, $8B, $56, $CA, $8A, $46, $18, $F6, $66, $1A, $91, $F7, $F1, $92, $F6, $76, $18, $89, $D1,
  $88, $C6, $86, $E9, $D0, $C9, $D0, $C9, $08, $E1, $41, $C4, $5E, $C4, $B8, $01, $02, $8A, $56, $24, $CD, $13, $72, $89,
  $8B, $46, $0B, $57, $BE, $A0, $63, $C4, $BE, $9C, $E7, $89, $C1, $F3, $A4, $5F, $B1, $04, $D3, $E8, $01, $86, $9E, $E7,
  $83, $46, $C8, $01, $83, $56, $CA, $00, $4F, $75, $8B, $C4, $9E, $9C, $E7, $5E, $C3, $4B, $45, $52, $4E, $45, $4C, $20,
  $20, $53, $59, $53, $00, $00, $55, $AA
);

Procedure WriteFloppyBootSector(const Cylinders, Heads, SPT : Integer; const ImageFile : String);
Var MSt : TMemoryStream;
    B : Byte;
begin
  MSt:=TMemoryStream.Create;
  try
    MSt.LoadFromFile(ImageFile);
    MSt.Position:=62;
    MSt.WriteBuffer(BootSec[62],512-62);

    {mediaType}
    B:=$F0;
    If (Heads=2) and ((SPT=9) or (SPT=15)) and (Cylinders=80) then B:=$F9;
    If (Heads=2) and (SPT=9) and (Cylinders=40) then B:=$FD;
    If (Heads=2) and (SPT=8) and (Cylinders=40) then B:=$FF;
    If (Heads=1) and (SPT=9) and (Cylinders=40) then B:=$FC;
    If (Heads=1) and (SPT=8) and (Cylinders=40) then B:=$FE;
    MSt.Position:=$15; MSt.WriteBuffer(B,1);
    MSt.Position:=1*512; MSt.WriteBuffer(B,1); {beginning of sector 1 = beginning of fat 1}
    MSt.Position:=10*512; MSt.WriteBuffer(B,1); {beginning of sector 10 = beginning of fat 1}

    {fix fats}
    MSt.Position:=1*512+2; B:=$FF; MSt.WriteBuffer(B,1);
    MSt.Position:=1*512+4; B:=$00; MSt.WriteBuffer(B,1);
    MSt.Position:=1*512+5; B:=$00; MSt.WriteBuffer(B,1);
    MSt.Position:=10*512+2; B:=$FF; MSt.WriteBuffer(B,1);
    MSt.Position:=10*512+4; B:=$00; MSt.WriteBuffer(B,1);
    MSt.Position:=10*512+5; B:=$00; MSt.WriteBuffer(B,1);

    MSt.SaveToFile(ImageFile);
  finally
    MSt.Free;
  end;
end;

Function GetCPIFileName : String;
const EGA : Array[1..6] of Integer = (437,850,858,852,853,857);
      EGA2 : Array[1..6] of Integer = (859,775,1116,1117,1118,1119);
      EGA3 : Array[1..6] of Integer = (771,772,855,872,866,808);
      EGA4 : Array[1..6] of Integer = (61282,30010,1125,848,1131,849);
      EGA5 : Array[1..6] of Integer = (737,851,869,858,113,852);
      EGA6 : Array[1..6] of Integer = (59829,60853,30008,899,60258,58210);
      EGA7 : Array[1..6] of Integer = (30011,30013,30014,30017,30018,30019);
      EGA8 : Array[1..6] of Integer = (770,773,774,775,777,778);
      EGA9 : Array[1..6] of Integer = (858,860,861,863,865,867);
      EGA10 : Array[1..6] of Integer = (667,668,790,991,852,57781);
      EGA11 : Array[1..6] of Integer = (858,30000,30001,30004,30007,30009);
      EGA12 : Array[1..6] of Integer = (858,852,58335,30003,30029,30030);
      EGA13 : Array[1..6] of Integer = (852,895,58152,59234,62306,30002);
      EGA14 : Array[1..6] of Integer = (30006,30012,30015,30016,30020,30021);
      EGA15 : Array[1..6] of Integer = (30023,30024,30025,30026,30027,30028);
      EGA16 : Array[1..3] of Integer = (858,30005,30022);
Function Check(const CP : Integer; const A : Array of Integer) : Boolean; Var I : Integer; begin result:=True; For I:=Low(A) to High(A) do If CP=A[I] then exit; result:=False; end;
Var CP : Integer;
begin
  result:='EGA';

  If not TryStrToInt(LanguageSetup.GameKeyboardCodepageDefault,CP) then exit;
  If Check(CP,EGA) then begin result:='EGA'; exit; end;
  If Check(CP,EGA2) then begin result:='EGA2'; exit; end;
  If Check(CP,EGA3) then begin result:='EGA3'; exit; end;
  If Check(CP,EGA4) then begin result:='EGA4'; exit; end;
  If Check(CP,EGA5) then begin result:='EGA5'; exit; end;
  If Check(CP,EGA6) then begin result:='EGA6'; exit; end;
  If Check(CP,EGA7) then begin result:='EGA7'; exit; end;
  If Check(CP,EGA8) then begin result:='EGA8'; exit; end;
  If Check(CP,EGA9) then begin result:='EGA9'; exit; end;
  If Check(CP,EGA10) then begin result:='EGA10'; exit; end;
  If Check(CP,EGA11) then begin result:='EGA11'; exit; end;
  If Check(CP,EGA12) then begin result:='EGA12'; exit; end;
  If Check(CP,EGA13) then begin result:='EGA13'; exit; end;
  If Check(CP,EGA14) then begin result:='EGA14'; exit; end;
  If Check(CP,EGA15) then begin result:='EGA15'; exit; end;
  If Check(CP,EGA16) then begin result:='EGA16'; exit; end;
end;

Function GetKeyaboardLayout : String;
Var S : String;
begin
  result:=LanguageSetup.GameKeyboardLayoutDefault;
  If Pos('(',result)>0 then begin
    S:=Copy(result,Pos('(',result)+1,MaxInt);
    If Pos(')',S)>0 then begin S:=Trim(Copy(S,1,Pos(')',S)-1)); If S<>'' then result:=S; end;
  end;

  If ExtUpperCase(result)='NONE' then result:='us';
end;

Function GetFreeDOSDir : String;
begin
  result:=Trim(PrgSetup.PathToFREEDOS);
  If result<>'' then result:=IncludeTrailingPathDelimiter(MakeAbsPath(result,PrgSetup.BaseDir));
  If (result='') or (not DirectoryExists(result)) then begin
    MessageDlg(LanguageSetup.ProfileEditorNeedFreeDOS,mtError,[mbOK],0);
    result:='';
    exit;
  end;
end;

Function GetDoszipDir : String;
begin
  result:=Trim('.\VirtualHD\Doszip\');
  result:=IncludeTrailingPathDelimiter(MakeAbsPath(result,PrgSetup.BaseDir));
  If (result='') or (not DirectoryExists(result) or (not FileExists(result+'dz.exe'))) then begin
    result:='';
    exit;
  end;
end;

Function GetCodepage : String;
begin
  result:=LanguageSetup.GameKeyboardCodepageDefault;
end;

Function DiskImageCreatorRunDOSBoxCommandsOnFloppyImage(const ImageFileName : String; const Autoexec, AdditionalFolders : TStringList) : Boolean;
Var FreeDOSDir,DoszipDir : String;
    TempGame : TTempGame;
    I,Add : Integer;
begin
  result:=False;
  FreeDOSDir:=GetFreeDOSDir; If FreeDOSDir='' then exit;
  DoszipDir:=GetDoszipDir;

  TempGame:=TTempGame.Create;
  try
    TempGame.Game.Mount0:=FreeDOSDir+';DRIVE;C;False;;'+IntToStr(DefaultFreeHDSize);
    TempGame.Game.Mount1:=ImageFileName+';FLOPPYIMAGE;A;;;';
    If (DoszipDir<>'') then TempGame.Game.Mount2:=DoszipDir+';DRIVE;D;False;;'+IntToStr(DefaultFreeHDSize);
    if (DoszipDir<>'') then Add:=1 else Add:=0;
    If AdditionalFolders<>nil then begin
      TempGame.Game.NrOfMounts:=2+Add+AdditionalFolders.Count;
      For I:=0 to AdditionalFolders.Count-1 do
        TempGame.Game.Mount[2+Add+I]:=AdditionalFolders[I]+';DRIVE;'+Chr(Ord('D')+I+Add)+';False;;1000';
    end else begin
      TempGame.Game.NrOfMounts:=2+Add;
    end;
    TempGame.Game.Autoexec:=StringListToString(Autoexec);

    TempGame.Game.Cycles:='max';
    TempGame.Game.StoreAllValues;
    RunCommandAndWait(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',True);
  finally
    TempGame.Free;
  end;
  result:=True;
end;

Function DiskImageCreatorRunDOSBoxCommandsOnHDImage(const ImageFileName : String; const Autoexec, AdditionalFolders : TStringList) : Boolean;
Var FreeDOSDir,DoszipDir : String;
    TempGame : TTempGame;
    I,Add : Integer;
begin
  result:=False;
  FreeDOSDir:=GetFreeDOSDir; If FreeDOSDir='' then exit;
  DoszipDir:=GetDoszipDir;

  TempGame:=TTempGame.Create;
  try
    TempGame.Game.Mount0:=FreeDOSDir+';DRIVE;C;False;;'+IntToStr(DefaultFreeHDSize);
    TempGame.Game.Mount1:=ImageFileName+';IMAGE;D;;;'+GetGeometryFromFile(ImageFileName);
    If (DoszipDir<>'') then TempGame.Game.Mount2:=DoszipDir+';DRIVE;E;False;;'+IntToStr(DefaultFreeHDSize);
    if (DoszipDir<>'') then Add:=1 else Add:=0;
    If AdditionalFolders<>nil then begin
      TempGame.Game.NrOfMounts:=2+Add+AdditionalFolders.Count;
      For I:=0 to AdditionalFolders.Count-1 do
        TempGame.Game.Mount[2+I+Add]:=AdditionalFolders[I]+';DRIVE;'+Chr(Ord('E')+I+Add)+';False;;1000';
    end else begin
      TempGame.Game.NrOfMounts:=2+Add;
    end;
    TempGame.Game.Autoexec:=StringListToString(Autoexec);

    TempGame.Game.Cycles:='max';
    TempGame.Game.StoreAllValues;
    RunCommandAndWait(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',True);
  finally
    TempGame.Free;
  end;
  result:=True;
end;

Procedure AddSoundConfig(const St : TStringList; const Pre, Add : String; const Game : TGame);
Var G : TGame;
begin
  If Game=nil then begin
    G:=TGame.Create(PrgSetup); try AddSoundConfig(St,Pre,Add,G); finally G.Free; end;
    exit;
  end;
  If Game.MixerNosound then exit;
  St.Add(Pre+'SET BLASTER=A'+Game.SBBase+' I'+IntToStr(Game.SBIRQ)+' D'+IntToStr(Game.SBDMA)+' H'+IntToStr(Game.SBHDMA)+' P330 T6'+Add);
  If Game.GUS then St.Add(Pre+'SET ULTRASND='+Game.GUSBase+','+IntToStr(Game.GUSDMA)+','+IntToStr(Game.GUSDMA)+','+IntToStr(Game.GUSIRQ)+','+IntToStr(Game.GUSIRQ)+Add);
end;

Function DiskImageCreatorUpgradeFloppy(const Cylinders, Heads, SPT : Integer; const ImageFileName : String; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders, CopyFoldersDest : TStringList; const AutoexecAdd : TStringList; const Game : TGame) : Boolean;
Var St : TStringList;
    lh,CtMouseParameters : String;
    I : Integer;
    C : Char;
begin
  result:=False;

  If dicuMakeBootable in Upgrades then begin
    try WriteFloppyBootSector(Cylinders,Heads,SPT,ImageFileName); except exit; end;
  end;

  St:=TStringList.Create;
  try
    If (dicuCopyFolder in Upgrades) and (CopyFolders<>nil) then begin
      For I:=0 to CopyFolders.Count-1 do begin
        C:=Chr(Ord('D')+I);
        If (CopyFoldersDest<>nil) and (CopyFoldersDest.Count>I) then begin
          St.Add('mkdir A:\'+CopyFoldersDest[I]);
          St.Add('C:\4DOS.COM /C COPY '+C+':\*.* A:\'+CopyFoldersDest[I]+'\ /S');
        end else begin
          St.Add('C:\4DOS.COM /C COPY '+C+':\*.* A:\ /S');
        end;
      end;
    end;
    If dicuMakeBootable in Upgrades then begin
      St.Add('copy C:\kernel.sys A:\');
      St.Add('copy C:\command.com A:\');
      St.Add('echo LASTDRIVE=Z > A:\config.sys');
      AddSoundConfig(St,'echo ',' >> A:\config.sys',Game);
      St.Add('echo BUFFERS=20 >> A:\config.sys');
      St.Add('echo FILES=40 >> A:\config.sys');
      St.Add('echo country='+LanguageSetup.GameKeyboardCountryDefault+' >> A:\config.sys');
      St.Add('echo set COMSPEC=C:\COMMAND.COM > A:\autoexec.bat');
      St.Add('echo set temp=A:\ >> A:\autoexec.bat');
      St.Add('echo set tmp=A:\ >> A:\autoexec.bat');
      St.Add('echo set dircmd=/ogn >> A:\autoexec.bat');
      If dicuMemoryManager in Upgrades then begin
        if (dicuUseFD11Tools in Upgrades) then begin
          St.Add('copy C:\jemmex.exe A:\');
        end else begin
          St.Add('copy C:\himem.exe A:\');
          St.Add('copy C:\emm386.exe A:\');
        end;
        St.Add('copy C:\mem.exe A:\');
        St.Add('echo dos=high,umb >> A:\config.sys');
        St.Add('echo DOSDATA=UMB >> A:\config.sys');
        if (dicuUseFD11Tools in Upgrades) then begin
          St.Add('echo devicehigh=jemmex.exe I=c800-dfff >> A:\config.sys');
        end else begin
          St.Add('echo device=himem.exe >> A:\config.sys');
          St.Add('echo devicehigh=emm386.exe >> A:\config.sys');
        end;
        St.Add('echo SHELLHIGH=A:\COMMAND.COM /E:256 /P >> A:\config.sys');
        lh:='lh ';
      end else begin
        lh:='';
        St.Add('echo. > A:\config.sys');
      end;
      If dicuKeyboardDriver in Upgrades then begin
        St.Add('copy C:\display.exe A:\');
        St.Add('copy C:\mode.com A:\');
        St.Add('copy C:\CPI\'+GetCPIFileName+'.CPX A:\');
        St.Add('echo '+lh+'display CON=(EGA,'+GetCodepage+',1) >> A:\Autoexec.bat');
        St.Add('echo mode CON CP PREP=(('+GetCodepage+') '+GetCPIFileName+'.CPX) >> A:\Autoexec.bat');
        St.Add('echo '+lh+'mode CON CP SEL='+GetCodepage+' >> A:\Autoexec.bat');
        St.Add('echo '+lh+'keyb '+GetKeyaboardLayout+','+GetCodepage+' >> A:\Autoexec.bat');
        St.Add('copy C:\keyb.exe A:\');
        St.Add('copy C:\keyboard.sys A:\');
        St.Add('copy C:\keybrd2.sys A:\');
        St.Add('copy C:\keybrd3.sys A:\');
      end;
      If dicuMouseDriver in Upgrades then begin
        CtMouseParameters:='';
        If dicuSwapMouseButtons in Upgrades then CtMouseParameters:=CtMouseParameters+' /L';
        If dicuForce2ButtonMouseMode in Upgrades then CtMouseParameters:=CtMouseParameters+' /Y';
        St.Add('echo '+lh+'ctmouse.exe'+CtMouseParameters+' >> A:\Autoexec.bat');
        St.Add('copy C:\ctmouse.exe A:\');
      end;
    end;
    If dicuDiskTools in Upgrades then begin
      St.Add('copy C:\chkdsk.exe A:\');
      St.Add('copy C:\fdisk.exe A:\');
      St.Add('copy C:\format.exe A:\');
      St.Add('copy C:\sys.com A:\');
      St.Add('copy C:\bootlace.com A:\');
      St.Add('copy C:\grldr A:\');
      St.Add('copy C:\bootfix.com A:\');
    end;
    If (dicuAutoexecAddLines in Upgrades) and (AutoexecAdd<>nil) then begin
      For I:=0 to AutoexecAdd.Count-1 do St.Add('echo '+AutoexecAdd[I]+' >> A:\Autoexec.bat');
    end;
    if dicuEditor in Upgrades then begin
      St.Add('copy C:\edit.* A:\');
    end;
    If dicuDoszip in Upgrades then begin
      St.Add('copy D:\dz.exe A:\');
      St.Add('copy D:\dz.dll A:\');
      St.Add('copy D:\doszip.txt A:\');
    end;
    St.Add('exit');
    result:=DiskImageCreatorRunDOSBoxCommandsOnFloppyImage(ImageFileName,St,CopyFolders);
  finally
    St.Free;
  end;
end;

Function DiskImageCreatorFloppyForHDSetup(const ImageFileName : String) : Boolean;
Var St : TStringList;
begin
  result:=False;

  if not DiskImageCreator(ImageFileName) then exit;
  try WriteFloppyBootSector(80,2,18,ImageFileName); except exit; end;

  St:=TStringList.Create;
  try
    St.Add('copy C:\kernel.sys A:\');
    St.Add('copy C:\command.com A:\');
    St.Add('copy C:\fdisk.exe A:\');
    St.Add('copy C:\sys.com A:\');
    St.Add('copy C:\bootlace.com A:\');
    St.Add('copy C:\grldr A:\');

    St.Add('echo default 0 > A:\menu.lst');
    St.Add('echo timeout 0 >> A:\menu.lst');
    St.Add('echo title FreeDOS >> A:\menu.lst');
    St.Add('echo root (hd0,0) >> A:\menu.lst');
    St.Add('echo chainloader (hd0,0)/kernel.sys >> A:\menu.lst');
    St.Add('echo boot >> A:\menu.lst');

    St.Add('echo. > A:\config.sys');

    St.Add('echo bootlace 0x80 > A:\Autoexec.bat');
    St.Add('echo sys C: >> A:\Autoexec.bat');
    St.Add('echo copy grldr C: >> A:\Autoexec.bat');
    St.Add('echo copy menu.lst C: >> A:\Autoexec.bat');
    St.Add('echo fdisk /reboot >> A:\Autoexec.bat');

    St.Add('exit');

    result:=DiskImageCreatorRunDOSBoxCommandsOnFloppyImage(ImageFileName,St,nil);
  finally
    St.Free;
  end;
end;

Function DiskImageCreatorRunBootdiskOnHD(const ImageFileName, FloppyFileName : String) : Boolean;
Var TempGame : TTempGame;
begin
  TempGame:=TTempGame.Create;
  try
    TempGame.Game.NrOfMounts:=1;
    TempGame.Game.Mount0:=ImageFileName+';IMAGE;2;;;'+GetGeometryFromFile(ImageFileName);
    TempGame.Game.AutoexecBootImage:=FloppyFileName;

    TempGame.Game.Cycles:='max';
    TempGame.Game.StoreAllValues;
    RunCommandAndWait(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',True);
  finally
    TempGame.Free;
  end;
  result:=True;
end;

Function DiskImageCreatorUpgradeHD(const ImageFileName : String; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders, CopyFoldersDest : TStringList; const AutoexecAdd : TStringList; const Game : TGame) : Boolean;
Var TempFloppyImage : String;
    St,St2 : TStringList;
    lh,CtMouseParameters : String;
    I,J,Add : Integer;
    C : Char;
begin
  result:=False;

  {Make bootable}
  if dicuMakeBootable in Upgrades then begin
    TempFloppyImage:=TempDir+'DFR-Floppy-Bootimage.img';
    if not DiskImageCreatorFloppyForHDSetup(TempFloppyImage) then exit;
    try
      DiskImageCreatorRunBootdiskOnHD(ImageFileName,TempFloppyImage);
    finally
      ExtDeleteFile(TempFloppyImage,ftTemp);
    end;
  end;

  {Copy files to image}
  St:=TStringList.Create;
  try
    If dicuMakeBootable in Upgrades then begin
      St.Add('echo LASTDRIVE=Z > D:\config.sys');
      AddSoundConfig(St,'echo ',' >> D:\config.sys',Game);
      St.Add('echo BUFFERS=20 >> D:\config.sys');
      St.Add('echo FILES=40 >> D:\config.sys');
      St.Add('echo country='+LanguageSetup.GameKeyboardCountryDefault+' >> D:\config.sys');
      St.Add('echo set COMSPEC=C:\COMMAND.COM > D:\autoexec.bat');
      St.Add('echo set temp=C:\ >> D:\autoexec.bat');
      St.Add('echo set tmp=C:\ >> D:\autoexec.bat');
      St.Add('echo set dircmd=/ogn >> D:\autoexec.bat');
      If dicuMemoryManager in Upgrades then begin
        if (dicuUseFD11Tools in Upgrades) then begin
          St.Add('copy C:\jemmex.exe D:\');
        end else begin
          St.Add('copy C:\himem.exe D:\');
          St.Add('copy C:\emm386.exe D:\');
        end;
        St.Add('copy C:\mem.exe D:\');
        St.Add('echo dos=high,umb >> D:\config.sys');
        St.Add('echo DOSDATA=UMB >> D:\config.sys');
        if (dicuUseFD11Tools in Upgrades) then begin
          St.Add('echo devicehigh=jemmex.exe I=c800-dfff >> D:\config.sys');
        end else begin
          St.Add('echo device=himem.exe >> D:\config.sys');
          St.Add('echo devicehigh=emm386.exe >> D:\config.sys');
        end;
        St.Add('echo SHELLHIGH=C:\COMMAND.COM /E:256 /P >> D:\config.sys');
        lh:='lh ';
      end else begin
        lh:='';
      end;
      If dicuKeyboardDriver in Upgrades then begin
        St.Add('copy C:\display.exe D:\');
        St.Add('copy C:\mode.com D:\');
        St.Add('copy C:\CPI\'+GetCPIFileName+'.CPX D:\');
        St.Add('echo '+lh+'display CON=(EGA,'+GetCodepage+',1) >> D:\Autoexec.bat');
        St.Add('echo mode CON CP PREP=(('+GetCodepage+') '+GetCPIFileName+'.CPX) >> D:\Autoexec.bat');
        St.Add('echo '+lh+'mode CON CP SEL='+GetCodepage+' >> D:\Autoexec.bat');
        St.Add('echo '+lh+'keyb '+GetKeyaboardLayout+','+GetCodepage+' >> D:\Autoexec.bat');
        St.Add('copy C:\keyb.exe D:\');
        St.Add('copy C:\keyboard.sys D:\');
        St.Add('copy C:\keybrd2.sys D:\');
        St.Add('copy C:\keybrd3.sys D:\');
      end;
      If dicuMouseDriver in Upgrades then begin
        CtMouseParameters:='';
        If dicuSwapMouseButtons in Upgrades then CtMouseParameters:=CtMouseParameters+' /L';
        If dicuForce2ButtonMouseMode in Upgrades then CtMouseParameters:=CtMouseParameters+' /Y';
        St.Add('echo '+lh+'ctmouse.exe'+CtMouseParameters+' >> D:\Autoexec.bat');
        St.Add('copy C:\ctmouse.exe D:\');
      end;
    end;
    If (dicuAutoexecAddLines in Upgrades) and (AutoexecAdd<>nil) then begin
      For I:=0 to AutoexecAdd.Count-1 do St.Add('echo '+AutoexecAdd[I]+' >> D:\Autoexec.bat');
    end;
    If dicuDiskTools in Upgrades then begin
      St.Add('copy C:\chkdsk.exe D:\');
      St.Add('copy C:\fdisk.exe D:\');
      St.Add('copy C:\format.exe D:\');
      St.Add('copy C:\sys.com D:\');
      St.Add('copy C:\bootlace.com D:\');
      St.Add('copy C:\grldr D:\');
      St.Add('copy C:\bootfix.com D:\');
    end;
    if dicuEditor in Upgrades then begin
      St.Add('copy C:\edit.* D:\');
    end;
    if dicuDoszip in Upgrades then begin
      St.Add('copy E:\dz.exe D:\');
      St.Add('copy E:\dz.dll D:\');
      St.Add('copy E:\doszip.txt D:\');
    end;
    St2:=TStringList.Create;
    try
      if (GetDoszipDir<>'') then Add:=1 else Add:=0;
      If (dicuCopyFolder in Upgrades) and (CopyFolders<>nil) and (CopyFoldersDest<>nil) then begin
        For I:=0 to Min(7,CopyFolders.Count-1) do begin
          C:=Chr(Ord('E')+I+Add);
          St2.Add(CopyFolders[I]);
          If (CopyFoldersDest<>nil) and (CopyFoldersDest.Count>I) then begin
            St.Add('mkdir D:\'+CopyFoldersDest[I]);
            St.Add('C:\4DOS.COM /C COPY '+C+':\*.* D:\'+CopyFoldersDest[I]+'\ /S');
          end else begin
            St.Add('C:\4DOS.COM /C COPY '+C+':\*.* D:\ /S');
          end;
        end;
      end;
      If St.Count>0 then begin
        St.Add('exit');
        DiskImageCreatorRunDOSBoxCommandsOnHDImage(ImageFileName,St,St2);
      end;
      if (CopyFolders<>nil) and (CopyFoldersDest<>nil) then begin
        J:=8;
        While CopyFolders.Count>J do begin
          St.Clear; St2.Clear;
          For I:=J to Min(7+J,CopyFolders.Count-1) do begin
            C:=Chr(Ord('E')+I-J+Add);
            St2.Add(CopyFolders[I]);
            If (CopyFoldersDest<>nil) and (CopyFoldersDest.Count>I) then begin
              St.Add('mkdir D:\'+CopyFoldersDest[I]);
              St.Add('C:\4DOS.COM /C COPY '+C+':\*.* D:\'+CopyFoldersDest[I]+'\ /S');
            end else begin
              St.Add('C:\4DOS.COM /C COPY '+C+':\*.* D:\ /S');
            end;
          end;
          St.Add('exit');
          DiskImageCreatorRunDOSBoxCommandsOnHDImage(ImageFileName,St,St2);
          inc(J,8);
        end;
      end;
    finally
      St2.Free;
    end;
  finally
    St.Free;
  end;

  result:=True;
end;

Function DiskImageCreatorUpgrade(const ImageFileName : String; const IsHDImage : Boolean; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders, CopyFoldersDest : TStringList; const AutoexecAdd : TStringList; const Game : TGame; const FloppyCylinders : Integer; const FloppyHeads : Integer; const FloppySPT : Integer) : Boolean;
begin
  If IsHDImage
    then result:=DiskImageCreatorUpgradeHD(ImageFileName,Upgrades,CopyFolders,CopyFoldersDest,AutoexecAdd,Game)
    else result:=DiskImageCreatorUpgradeFloppy(FloppyCylinders,FloppyHeads,FloppySPT,ImageFileName,Upgrades,CopyFolders,CopyFoldersDest,AutoexecAdd,Game);
end;

Function CalcSektorByteSize(const Dir : String; const Files : Array of String; const ClusterSize : Integer) : Integer;
Var I,J : Integer;
    Rec : TSearchRec;
begin
  result:=0;
  For I:=Low(Files) to High(Files) do begin
    J:=FindFirst(IncludeTrailingPathDelimiter(Dir)+Files[I],faAnyFile,Rec);
    try
      If J=0 then begin
        inc(result,(Rec.Size div ClusterSize)*ClusterSize);
        If Rec.Size mod ClusterSize<>0 then inc(result,ClusterSize);
      end;
    finally
      FindClose(Rec);
    end;
  end;
end;

function FolderSize(const Folder: String; const ClusterSize : Integer): Integer;
Var I : Integer;
    Rec : TSearchRec;
begin
  result:=0;

  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If (Rec.Name<>'') and (Rec.Name<>'.') and (Rec.Name<>'..') then inc(result,FolderSize(IncludeTrailingPathDelimiter(Folder)+Rec.Name,ClusterSize));
      end else begin
        inc(result,(Rec.Size div ClusterSize)*ClusterSize);
        If Rec.Size mod ClusterSize<>0 then inc(result,ClusterSize);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetClusterSize(const Size : Integer) : Integer;
begin
  Case Size div 1024 div 1024 of
    1.. 32 : result:=1;
   33.. 64 : result:=2;
   65..128 : result:=4;
  129..256 : result:=8;
  257..512 : result:=16;
    else     result:=32;
  end;
  result:=result*512;
end;

Function DiskImageCreatorUpgradeSizeInt(const IsHDImage : Boolean; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders : TStringList; const ClusterSize : Integer) : Integer;
Var FreeDOS,Doszip : String;
    I : Integer;
begin
  result:=0;

  FreeDOS:=Trim(PrgSetup.PathToFREEDOS);
  If FreeDOS<>'' then FreeDOS:=IncludeTrailingPathDelimiter(MakeAbsPath(FreeDOS,PrgSetup.BaseDir));
  If (FreeDOS<>'') and DirectoryExists(FreeDOS) then begin
    if dicuMakeBootable in Upgrades then begin
      inc(result,CalcSektorByteSize(FreeDOS,['kernel.sys','command.com'],ClusterSize));
      If IsHDImage then inc(result,CalcSektorByteSize(FreeDOS,['grldr'],ClusterSize)+ClusterSize); {menu.lst}
      inc(result,ClusterSize); {config.sys}
      If dicuUseFD11Tools in Upgrades then begin
        If dicuMemoryManager in Upgrades then inc(result,CalcSektorByteSize(FreeDOS,['jemmex.exe','mem.exe'],ClusterSize));
      end else begin
        If dicuMemoryManager in Upgrades then inc(result,CalcSektorByteSize(FreeDOS,['himem.exe','emm386.exe','mem.exe'],ClusterSize));
      end;
      if dicuKeyboardDriver in Upgrades then inc(result,CalcSektorByteSize(FreeDOS,['keyb.exe','keyboard.sys','keybrd2.sys','keybrd3.sys','mode.com','display.exe','CPI/'+GetCPIFileName+'.CPX'],ClusterSize));
      If dicuMouseDriver in Upgrades then inc(result,CalcSektorByteSize(FreeDOS,['ctmouse.exe'],ClusterSize));
      if (dicuKeyboardDriver in Upgrades) or (dicuMouseDriver in Upgrades) then inc(result,ClusterSize); {autoexec.bat}
    end;
    If dicuDiskTools in Upgrades then begin
      inc(result,CalcSektorByteSize(FreeDOS,['chkdsk.exe','fdisk.exe','format.exe','sys.com','bootlace.com','bootfix.com'],ClusterSize));
      If (not IsHDImage) or (not (dicuMakeBootable in Upgrades)) then inc(result,CalcSektorByteSize(FreeDOS,['grldr'],ClusterSize));
    end;
    If dicuEditor in Upgrades then inc(result,CalcSektorByteSize(FreeDOS,['edit.exe','edit.hlp','edit.cfg'],ClusterSize));
  end;

  Doszip:=Trim('.\VirtualHD\Doszip\');
  If Doszip<>'' then Doszip:=IncludeTrailingPathDelimiter(MakeAbsPath(Doszip,PrgSetup.BaseDir));
  If (Doszip<>'') and DirectoryExists(Doszip) then begin
    If dicuDoszip in Upgrades then inc(result,CalcSektorByteSize(Doszip,['doszip.txt','dz.dll','dz.exe'],ClusterSize));
  end;

  If (dicuCopyFolder in Upgrades) and (CopyFolders<>nil) then For I:=0 to CopyFolders.Count-1 do
    inc(result,FolderSize(MakeAbsPath(CopyFolders[I],PrgSetup.BaseDir),ClusterSize));
end;

Function DiskImageCreatorUpgradeSize(const IsHDImage : Boolean; const Upgrades : TDiskImageCreatorUpgrades; const CopyFolders : TStringList; const AddMB : Integer) : Integer;
Var ClusterSize : Integer;
begin
  ClusterSize:=512;
  result:=DiskImageCreatorUpgradeSizeInt(IsHDImage,Upgrades,CopyFolders,ClusterSize)+AddMB*1024*1024;
  If not IsHDImage then exit;

  While ClusterSize<GetClusterSize(result) do begin
    ClusterSize:=GetClusterSize(result);
    result:=DiskImageCreatorUpgradeSizeInt(IsHDImage,Upgrades,CopyFolders,ClusterSize)+AddMB*1024*1024;
  end;
end;

Function FD11ToolsAvailable : Boolean;
Var Dir : String;
begin
  result:=false;
  Dir:=Trim(PrgSetup.PathToFREEDOS); If Dir='' then exit;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(Dir,PrgSetup.BaseDir));
  If not DirectoryExists(Dir) then exit;
  result:=FileExists(Dir+'jemmex.exe');
end;

Function DosZipAvailable : Boolean;
Var Dir : String;
begin
  result:=false;
  Dir:=Trim('.\VirtualHD\Doszip\'); If Dir='' then exit;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(Dir,PrgSetup.BaseDir));
  If not DirectoryExists(Dir) then exit;
  result:=FileExists(Dir+'dz.exe');
end;

end.
