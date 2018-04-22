unit IconLoaderUnit;
interface

uses Classes, Controls, Graphics, Buttons, IniFiles;

{Number of main icons}
var MI_Count : Integer;

{Dialog icons}
const DI_OK=0;
      DI_Cancel=1;
      DI_Close=2;
      DI_Help=3;
      DI_Abort=4;
      DI_Yes=5;
      DI_No=6;
      DI_All=7;
      DI_SelectFolder=8;
      DI_SelectFile=9;
      DI_ExploreFolder=10;
      DI_ImageFloppy=11;
      DI_ImageHD=12;
      DI_ImageCD=13;
      DI_Add=14;
      DI_Delete=15;
      DI_Up=16;
      DI_Down=17;
      DI_Import=18;
      DI_Export=19;
      DI_ExtraPrgFiles=20;
      DI_Internet=21;
      DI_Edit=22;
      DI_Screenshot=23;
      DI_Clear=24;
      DI_Load=25;
      DI_Save=26;
      DI_Create=27;
      DI_Wizard=28;
      DI_Previous=29;
      DI_Next=30;
      DI_ViewFile=31;
      DI_Run=32;
      DI_Zoom=33;
      DI_ZipFile=34;
      DI_ResetDefault=35;
      DI_FindFile=36;
      DI_ScummVM=37;
      DI_Table=38;
      DI_Folders=39;
      DI_Calculator=40;
      DI_Update=41;

      DI_CutToClipboard=42;
      DI_CopyToClipboard=43;
      DI_PasteFromClipboard=44;
      DI_Undo=45;

      DI_BackgroundImage=46;
      DI_Image=47;
      DI_Sound=48;
      DI_Video=49;
      DI_InternetPage=50;
      DI_Folder=51;
      DI_TextFile=52;
      DI_CloseWindow=53;
      DI_UseTemplate=54;
      DI_ToolbarHelp=55;
      DI_NameType=56;
      DI_More=57;
      DI_ResetProfile=58;
      DI_CloseX=59;
      DI_Tools=60;
      DI_DOSBox=61;
      DI_Activate=62;
      DI_Expand=63;
      DI_Collapse=64;
      DI_Warning=65;
      DI_Information=66;

Type TImageListRec=record
  ImageList, OriginalImageList : TImageList;
  IconsFromPath : TStringList;
  IconsFromPathDefault : Integer;
  ImageLoaded : TList;
  Name : String;
  AddImages, NeedReinit : Boolean;
end;

Type TUserIconLoader=class
  private
    ImageListList : Array of TImageListRec;
    DialogImageList : TImageList;
    DialogImageLoaded : TList;
    FIconsLoaded : Boolean;
    FIconSet : String;
    FIconSetPath : String;
    Function CreateMask(const B : TBitmap) : TBitmap;
    Function LoadIconToImageList(const ImageList : TImageList; const Nr : Integer; const FileName : String) : Boolean;
    Procedure LoadUserIconsForList(const ImageList : TImageList; const IniSectionName : String; const AddImages : Boolean; const ImageLoaded : TList; const Ini : TIniFile; const RelBase : String);
    Procedure AddEmptyImages(const ImageList : TImageList; const ImageLoaded : TList; const MaxNr : Integer);
    procedure SetIconSet(const Value: String);
    Function GetButtonBitmap(const ImageList : TImageList; const ImageListLoaded : TList;  const Nr : Integer) : TBitmap;
    Function GetDialogButtonBitmap(const Nr : Integer) : TBitmap;
    Function IsImageEmpty(const B : TBitmap) : Boolean;
    Function GetOriginalOfMainIconList : TImageList; {for use in GetExampleImage}
    Procedure LoadIconsFromPath(const ImageList : TImageList; const IconsFromPath : TStringList; IconsFromPathDefault : Integer);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure RegisterImageList(const ImageList : TImageList; const Name : String; const AddImages : Boolean = False); overload;
    Procedure RegisterImageList(const ImageList : TImageList; const Name : String; const IconsFromPath : TStringList; const IconsFromPathDefault : Integer); overload;
    Procedure UnRegisterImageList(const ImageList : TImageList);
    Procedure UpdateIconsFromPath(const ImageList : TImageList; const IconsFromPath : TStringList);
    Procedure DirectLoad(const ImageList : TImageList; const Name : String; const AddImages : Boolean = False; const ImageLoaded : TList = nil); overload;
    Procedure DirectLoad(const Name : String; Nr : Integer; const BitBtn : TBitBtn); overload;
    Procedure LoadIcons;
    Procedure DialogImage(const Nr : Integer; const SpeedButton : TSpeedButton); overload;
    Procedure DialogImage(const Nr : Integer; const BitBtn : TBitBtn); overload;
    Procedure DialogImage(const Nr : Integer; const ImageList : TImageList; const NrInImageList : Integer); overload;
    property IconSet : String read FIconSet write SetIconSet;
    property IconSetPath : String read FIconSetPath;
    property IconsLoaded : Boolean read FIconsLoaded;
end;

var UserIconLoader : TUserIconLoader;

Procedure ListOfIconSets(const ShortName, LongName, Author, FolderName : TStringList); {LongName, Author and FolderName can be nil}
Function GetExampleImage(const ShortName : String) : TBitmap;

implementation

uses SysUtils, CommonTools, PrgSetupUnit, PrgConsts, ImageStretch;

{ global }

Procedure ListOfIconSets(const ShortName, LongName, Author, FolderName : TStringList);
Procedure AddRec(const Dir, Sub : String);
Var Ini : TIniFile;
begin
  Ini:=TIniFile.Create(Dir+IconSetsFolder+'\'+Sub+'\'+IconsConfFile);
  try
    ShortName.Add(Sub);
    If LongName<>nil then LongName.Add(Ini.ReadString('Information','Name',Sub));
    If Author<>nil then Author.Add(Ini.ReadString('Information','Author',''));
    If FolderName<>nil then FolderName.Add(Dir+IconSetsFolder+'\'+Sub+'\');
  finally
    Ini.Free;
  end;
end;
Var Rec : TSearchRec;
    I,J : Integer;
    B : Boolean;
    S : String;
begin
  I:=FindFirst(PrgDataDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') and FileExists(PrgDataDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile) then AddRec(PrgDataDir,Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If PrgDir=PrgDataDir then exit;

  I:=FindFirst(PrgDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') and FileExists(PrgDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile) then begin
        B:=True; S:=ExtUpperCase(Rec.Name);
        For J:=0 to ShortName.Count-1 do If ExtUpperCase(ShortName[J])=S then begin B:=False; break; end;
        If B then AddRec(PrgDir,Rec.Name);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetExampleImage(const ShortName : String) : TBitmap;
Var TempUserIconLoader : TUserIconLoader;
    ImageList : TImageList;
    B : TBitmap;
    I,X,Y : Integer;
    C : TColor;
begin
  TempUserIconLoader:=TUserIconLoader.Create;
  try
    ImageList:=TImageList.Create(nil);
    try
      ImageList.AddImages(UserIconLoader.GetOriginalOfMainIconList);
      TempUserIconLoader.IconSet:=ShortName;
      TempUserIconLoader.DirectLoad(ImageList,'Main');
      result:=TBitmap.Create;
      result.Height:=ImageList.Height;
      result.Width:=6*ImageList.Width;
      B:=TBitmap.Create;
      try
        For I:=0 to 5 do begin
          B.Height:=0;
          ImageList.GetBitmap(I,B);
          C:=B.Canvas.Pixels[0,B.Height-1];
          For X:=0 to B.Width-1 do For Y:=0 to B.Height-1 do if B.Canvas.Pixels[X,Y]=C then B.Canvas.Pixels[X,Y]:=clWhite;
          result.Canvas.Draw(B.Width*I,0,B);
        end;
      finally
        B.Free;
      end;
    finally
      ImageList.Free;
    end;
  finally
    TempUserIconLoader.Free;
  end;
end;

{ TUserIconLoader }

constructor TUserIconLoader.Create;
begin
  inherited Create;
  FIconsLoaded:=False;
  FIconSet:='';
  DialogImageList:=TImageList.Create(nil);
  RegisterImageList(DialogImageList,'Dialogs',True);
  DialogImageLoaded:=ImageListList[0].ImageLoaded;
end;

destructor TUserIconLoader.Destroy;
begin
  While length(ImageListList)>0 do UnRegisterImageList(ImageListList[length(ImageListList)-1].ImageList);
  DialogImageList.Free;
  inherited Destroy;
end;

procedure TUserIconLoader.RegisterImageList(const ImageList: TImageList; const Name: String; const AddImages : Boolean);
Var I : Integer;
    PILRec : ^TImageListRec;
begin
  I:=length(ImageListList);
  SetLength(ImageListList,I+1);
  PILRec:=@ImageListList[I];
  PILRec^.ImageList:=ImageList;
  PILRec^.Name:=Name;
  PILRec^.AddImages:=AddImages;
  PILRec^.OriginalImageList:=TImageList.Create(nil);
  PILRec^.OriginalImageList.AddImages(ImageList);
  PILRec^.IconsFromPath:=nil;
  PILRec^.NeedReinit:=False;
  PILRec^.ImageLoaded:=TList.Create;

  If FIconsLoaded then begin
    DirectLoad(PILRec^.ImageList,PILRec^.Name,PILRec^.AddImages);
    PILRec^.NeedReinit:=True;
  end;
end;

Procedure TUserIconLoader.RegisterImageList(const ImageList : TImageList; const Name : String; const IconsFromPath : TStringList; const IconsFromPathDefault : Integer);
Var I : Integer;
    PILRec : ^TImageListRec;
    B : TBitmap;
begin
  B:=TBitmap.Create;
  try
    B.Width:=ImageList.Width; B.Height:=ImageList.Height;
    For I:=0 to IconsFromPath.Count-1 do ImageList.Add(B,B);
  finally
    B.Free;
  end;

  I:=length(ImageListList);
  SetLength(ImageListList,I+1);
  PILRec:=@ImageListList[I];
  PILRec^.ImageList:=ImageList;
  PILRec^.Name:=Name;
  PILRec^.AddImages:=False;
  PILRec^.OriginalImageList:=TImageList.Create(nil);
  PILRec^.OriginalImageList.AddImages(ImageList);
  PILRec^.IconsFromPath:=TStringList.Create;
  PILRec^.IconsFromPath.AddStrings(IconsFromPath);
  PILRec^.IconsFromPathDefault:=IconsFromPathDefault;
  PILRec^.NeedReinit:=False;
  PILRec^.ImageLoaded:=TList.Create;

  If FIconsLoaded then begin
    DirectLoad(PILRec^.ImageList,PILRec^.Name,PILRec^.AddImages);
    LoadIconsFromPath(ImageList,IconsFromPath,IconsFromPathDefault);
    PILRec^.NeedReinit:=True;
  end;
end;

Procedure TUserIconLoader.UpdateIconsFromPath(const ImageList : TImageList; const IconsFromPath : TStringList);
Var I,J,OldLength : Integer;
    B : TBitmap;
begin
  For I:=0 to length(ImageListList)-1 do if ImageListList[I].ImageList=ImageList then begin
    If ImageListList[I].IconsFromPath<>nil then OldLength:=ImageListList[I].IconsFromPath.Count else OldLength:=0;

    If ImageListList[I].IconsFromPath=nil then ImageListList[I].IconsFromPath:=TStringList.Create;
    ImageListList[I].IconsFromPath.Clear;
    ImageListList[I].IconsFromPath.AddStrings(IconsFromPath);

    B:=TBitmap.Create;
    try
      B.Width:=ImageList.Width; B.Height:=ImageList.Height;
      For J:=OldLength+1 to IconsFromPath.Count do begin
        ImageListList[I].ImageList.Add(B,B);
        ImageListList[I].OriginalImageList.Add(B,B);
      end;
    finally
      B.Free;
    end;

    LoadIconsFromPath(ImageListList[I].ImageList,ImageListList[I].IconsFromPath,ImageListList[I].IconsFromPathDefault);
  end;
end;

procedure TUserIconLoader.SetIconSet(const Value: String);
begin
  If FIconSet=Value then exit;
  FIconSet:=Value;
  LoadIcons;
end;

procedure TUserIconLoader.UnRegisterImageList(const ImageList: TImageList);
Var I,J : Integer;
begin
  For I:=0 to length(ImageListList)-1 do If ImageListList[I].ImageList=ImageList then begin
    If ImageListList[I].OriginalImageList<>nil then ImageListList[I].OriginalImageList.Free;
    If ImageListList[I].ImageLoaded<>nil then ImageListList[I].ImageLoaded.Free;
    If ImageListList[I].IconsFromPath<>nil then ImageListList[I].IconsFromPath.Free; 
    For J:=I to length(ImageListList)-2 do ImageListList[J]:=ImageListList[J+1];
    SetLength(ImageListList,length(ImageListList)-1);
    exit;
  end;
end;

procedure TUserIconLoader.DirectLoad(const ImageList: TImageList; const Name: String; const AddImages : Boolean; const ImageLoaded : TList);
Var Ini : TIniFile;
    IL : TImageList;
begin
  If FIconSetPath<>'' then begin
    Ini:=TIniFile.Create(FIconSetPath+IconsConfFile);
    try
      IL:=TImageList.Create(nil);
      try
        IL.Assign(ImageList);
        LoadUserIconsForList(IL,Name,AddImages,ImageLoaded,Ini,FIconSetPath);
        ImageList.Assign(IL);
      finally
        IL.Free;
      end;
    finally
      Ini.Free;
    end;
  end;

  Ini:=TIniFile.Create(PrgDataDir+SettingsFolder+'\'+IconsConfFile);
  try
    LoadUserIconsForList(ImageList,Name,AddImages,ImageLoaded,Ini,PrgDataDir+SettingsFolder+'\');
  finally
    Ini.Free;
  end;
end;

Procedure TUserIconLoader.DirectLoad(const Name : String; Nr : Integer; const BitBtn : TBitBtn);
Var ImageList : TImageList;
    B : TBitmap;
    List : TList;
begin
  ImageList:=TImageList.Create(nil);
  List:=TList.Create;
  try
    DirectLoad(ImageList,Name,True,List);
    If (Nr<0) or (NR>=ImageList.Count) then exit;
    B:=GetButtonBitmap(ImageList,List,Nr);
    If B=nil then exit;
    try
      If not IsImageEmpty(B) then BitBtn.Glyph:=B;
    finally
      B.Free;
    end;
  finally
    ImageList.Free;
    List.Free;
  end;
end;

Procedure TUserIconLoader.AddEmptyImages(const ImageList : TImageList; const ImageLoaded : TList; const MaxNr : Integer);
Var B : TBitmap;
begin
  B:=TBitmap.Create;
  try
    B.Width:=ImageList.Width; B.Height:=ImageList.Height;
    While ImageList.Count<MaxNr+1 do ImageList.Add(B,B);
  finally
    B.Free;
  end;

  While ImageLoaded.Count<MaxNr+1 do ImageLoaded.Add(Pointer(0));
end;

Function TUserIconLoader.CreateMask(const B : TBitmap) : TBitmap;
Type TIntegerArray=Array[0..MaxInt div 4-1] of Integer;
Var C : TColor;
    X,Y : Integer;
    Can1,Can2 : TCanvas;
begin
  result:=TBitmap.Create;
  result.SetSize(B.Width,B.Height);
  Can1:=B.Canvas;
  If B.Transparent then begin
    C:=clWhite;
  end else begin
    C:=Can1.Pixels[0,B.Height-1];
  end;
  Can2:=result.Canvas;
  For X:=0 to B.Width-1 do For Y:=0 to B.Height-1 do If Can1.Pixels[X,Y]=C then Can2.Pixels[X,Y]:=$FFFFFF else Can2.Pixels[X,Y]:=clGray;
end;

Function TUserIconLoader.LoadIconToImageList(const ImageList : TImageList; const Nr : Integer; const FileName : String) : Boolean;
Var P : TPicture;
    B,B2 : TBitmap;
begin
  result:=False;
  if not FileExists(FileName) then exit;
  P:=LoadImageFromFile(FileName);
  If P=nil then exit;
  try
    If Trim(ExtUpperCase(ExtractFileExt(FileName)))='.BMP' then begin
      try
        B2:=CreateMask(P.Bitmap);
        try
          ImageList.Insert(Nr,P.Bitmap,B2);
        finally
          B2.Free;
        end;
        ImageList.Delete(Nr+1);
      except end;
    end else begin
      B:=TBitmap.Create;
      try
        B.SetSize(P.Width,P.Height);
        B.Canvas.Draw(0,0,P.Graphic);
        If (B.Width<>ImageList.Width) or (B.Height<>ImageList.Height) then begin
          B2:=TBitmap.Create;
          try
            B2.Width:=ImageList.Width; B2.Height:=ImageList.Height;
            ScaleImage(B,B2);
            B.Free; B:=B2; B2:=nil;
          finally
            B2.Free;
          end;
        end;
        try
          B.TransparentColor:=clWhite;
          B.Transparent:=True;
          B2:=CreateMask(B);
          try
            ImageList.Replace(Nr,B,B2);
          finally
            B2.Free;
          end;
        except end;
      finally
        B.Free;
      end;
    end;
  finally
    P.Free;
  end;
  result:=True;
end;

Procedure TUserIconLoader.LoadUserIconsForList(const ImageList : TImageList; const IniSectionName : String; const AddImages : Boolean; const ImageLoaded : TList; const Ini : TIniFile; const RelBase : String);
Var I,J : Integer;
    St : TStringList;
    IL : TImageList;
begin
  St:=TStringList.Create;
  try
    IL:=TImageList.Create(nil);
    try
      IL.Assign(ImageList);
      Ini.ReadSection(IniSectionName,St);
      For I:=0 to St.Count-1 do begin
        if not TryStrToInt(St[I],J) then continue;
        If J<1 then continue;
        If J>IL.Count then begin
          If not AddImages then continue;
          AddEmptyImages(IL,ImageLoaded,J-1);
        end;
        LoadIconToImageList(IL,J-1,MakeExtAbsPath(Ini.ReadString(IniSectionName,IntToStr(J),''),RelBase));
        If AddImages then ImageLoaded[J-1]:=Pointer(1);
      end;
      ImageList.Assign(IL);
    finally
      IL.Free;
    end;
  finally
    St.Free;
  end;
end;

Procedure TUserIconLoader.LoadIconsFromPath(const ImageList : TImageList; const IconsFromPath : TStringList; IconsFromPathDefault : Integer);
Var I,Nr : Integer;
    B,Mask : TBitmap;
begin
  If IconsFromPath=nil then exit;

  for I:=0 to IconsFromPath.Count-1 do begin
    Nr:=ImageList.Count-IconsFromPath.Count+I;

    {Load default icon}
    B:=TBitmap.Create;
    try
      B.Width:=ImageList.Width; B.Height:=ImageList.Height;
      If ImageList.GetBitmap(IconsFromPathDefault,B) then begin
        Mask:=CreateMask(B);
        try
          ImageList.Replace(Nr,B,Mask);
        finally
          Mask.Free;
        end;
      end;
    finally
      B.Free;
    end;

    {load icon from path}
    LoadIconToImageList(ImageList,Nr,IconsFromPath[I]);
  end;
end;

procedure TUserIconLoader.LoadIcons;
Procedure CheckDir(const Name : String);
begin
  If DirectoryExists(PrgDataDir+IconSetsFolder+'\'+Name) then begin FIconSetPath:=IncludeTrailingPathDelimiter(PrgDataDir+IconSetsFolder+'\'+Name); exit; end;
  If DirectoryExists(PrgDir+IconSetsFolder+'\'+Name) then begin FIconSetPath:=IncludeTrailingPathDelimiter(PrgDir+IconSetsFolder+'\'+Name); exit; end;
end;
Var Ini : TIniFile;
    I : Integer;
begin
  If FIconSet='' then FIconSet:='Modern';

  FIconSetPath:='';
  CheckDir(FIconSet);
  If FIconSetPath='' then CheckDir('Modern');
  If FIconSetPath='' then CheckDir('Classic');

  For I:=0 to Length(ImageListList)-1 do If ImageListList[I].NeedReinit then begin
    ImageListList[I].ImageList.Clear;
    If not ImageListList[I].AddImages then ImageListList[I].ImageList.Assign(ImageListList[I].OriginalImageList);
  end;

  If FIconSetPath<>'' then begin
    Ini:=TIniFile.Create(FIconSetPath+IconsConfFile);
    try
      For I:=0 to Length(ImageListList)-1 do begin
        LoadUserIconsForList(ImageListList[I].ImageList,ImageListList[I].Name,ImageListList[I].AddImages,ImageListList[I].ImageLoaded,Ini,FIconSetPath);
      end;
    finally
      Ini.Free;
    end;
  end;

  Ini:=TIniFile.Create(PrgDataDir+SettingsFolder+'\'+IconsConfFile);
  try
    For I:=0 to Length(ImageListList)-1 do begin
      LoadUserIconsForList(ImageListList[I].ImageList,ImageListList[I].Name,ImageListList[I].AddImages,ImageListList[I].ImageLoaded,Ini,PrgDataDir+SettingsFolder+'\');
      LoadIconsFromPath(ImageListList[I].ImageList,ImageListList[I].IconsFromPath,ImageListList[I].IconsFromPathDefault);
    end;
  finally
    Ini.Free;
  end;

  For I:=0 to Length(ImageListList)-1 do  ImageListList[I].NeedReinit:=True;

  FIconsLoaded:=True;
end;

Function TUserIconLoader.GetButtonBitmap(const ImageList : TImageList; const ImageListLoaded : TList; const Nr : Integer) : TBitmap;
Var B1,B2 : TBitmap;
begin
  result:=nil;
  If (Nr<0) or (Nr>=ImageList.Count) then exit;
  If (Nr>=ImageListLoaded.Count) or (Integer(ImageListLoaded[Nr])=0) then exit;

  B1:=TBitmap.Create;
  try
    B1.Width:=ImageList.Width; B1.Height:=ImageList.Height;
    ImageList.GetBitmap(Nr,B1);
    B2:=CreateMask(B1);
    try
      result:=TBitmap.Create;
      result.SetSize(2*B1.Width,B1.Height);
      result.PixelFormat:=pf8bit;
      result.Canvas.Draw(0,0,B1);
      result.Canvas.Draw(16,0,B2);
    finally
      B2.Free;
    end;
  finally
    B1.Free;
  end;
end;

Function TUserIconLoader.GetDialogButtonBitmap(const Nr : Integer) : TBitmap;
begin
  result:=GetButtonBitmap(DialogImageList,DialogImageLoaded,Nr);
end;

Type TByteArray=Array[0..MaxInt-1] of Byte;

function TUserIconLoader.IsImageEmpty(const B: TBitmap) : Boolean;
Var I,J,X,Y : Integer;
begin
  result:=False;
  Y:=B.Height; X:=B.Width div 2;
  For I:=0 to Y-1 do begin
    For J:=0 to X-1 do If TByteArray(B.ScanLine[I]^)[J]<>0 then exit;
    For J:=B.Width div 2 to B.Width-1 do If TByteArray(B.ScanLine[I]^)[J]<>255 then exit;
  end;
  result:=True;
end;

procedure TUserIconLoader.DialogImage(const Nr: Integer; const SpeedButton: TSpeedButton);
Var B : TBitmap;
begin
  B:=GetDialogButtonBitmap(Nr);
  If B=nil then exit;
  try
    If not IsImageEmpty(B) then SpeedButton.Glyph:=B;
  finally
    B.Free;
  end;
end;

Procedure TUserIconLoader.DialogImage(const Nr : Integer; const BitBtn : TBitBtn);
Var B : TBitmap;
begin
  B:=GetDialogButtonBitmap(Nr);
  If B=nil then exit;
  try
    If not IsImageEmpty(B) then BitBtn.Glyph:=B;
  finally
    B.Free;
  end;
end;

Procedure TUserIconLoader.DialogImage(const Nr : Integer; const ImageList : TImageList; const NrInImageList : Integer);
Var B : TBitmap;
begin
  If (Nr<0) or (Nr>=DialogImageList.Count) then exit;
  B:=GetDialogButtonBitmap(Nr);
  If B=nil then exit;
  ImageList.AddImage(DialogImageList,Nr);
  try If IsImageEmpty(B) then exit; finally B.Free; end;
  ImageList.Move(ImageList.Count-1,NrInImageList);
  ImageList.Delete(NrInImageList+1);
end;

function TUserIconLoader.GetOriginalOfMainIconList: TImageList;
Var I : Integer;
begin
  result:=nil;
  For I:=0 to length(ImageListList)-1 do If ExtUpperCase(ImageListList[I].Name)='MAIN' then begin
    result:=ImageListList[I].OriginalImageList;
    break;
  end;
end;

initialization
  UserIconLoader:=TUserIconLoader.Create;
finalization
  UserIconLoader.Free;
end.
