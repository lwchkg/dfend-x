unit FileNameConvertor;
interface

uses Classes;

Type

 TFileNameInfo = record
    ShortName: String;
    LongName: String;
    isDir: Boolean;
    shortNumber:  Integer;
 end;
 PFilenameInfo = ^TFileNameInfo;

 TFileNameConvertor = class(TObject)
 private
    ItemList: TList;
 protected
    function GetItem(Index: Integer): TFileNameInfo;
    procedure NewItem(LongName: String; isDir: Boolean);
    procedure SortItems;
    function GetItemsCount: Integer;
    procedure CreateShortName(var Item: TFileNameInfo);
    function CreateShortNameNumber(ShortName: String): Integer;
    function CompareShortName(ComparedName: String; ListedName: String): Integer;
    function RemoveSpaces(var S: String): Boolean;
    procedure RemoveTrailingDot(Name: String);
 public
    LinuxMode: Boolean;
    constructor Create; overload;
    constructor Create(ParentDir: String; UseLinuxeMode: Boolean); overload;
    constructor Create(ParentDir: String; ReadUpToFile: String; UseLinuxeMode: Boolean); overload;
    destructor Destroy; override;
    procedure Clear;
    procedure ReadDir(ParentDir: String); overload;
    procedure ReadDir(ParentDir: String; ReadUpToFile: String); overload;
    property ItemsCount: Integer read GetItemsCount;
    property Items[Index: Integer]: TFileNameInfo read GetItem;
    function IndexofShortName(ShortName: String): Integer;
    function IndexofLongName(LongName: String): Integer;
    function FindLongName(ShortName: String): String;
    function FindShortName(LongName: String): String;
 end;

Type TConvertResult = (tcrErrParentNotFound, tcrErrDelimiterInFileName, tcrErrFileNotFound,
        tcrWarnInvalidChars, tcrWarnSystemShort, tcrWarnSystemShortAlreadyUsed,
        tcrOkExternal, tcrOk);

function ConvertLongFileNameToShort(ParentDir:String; LongName: String; UseLinuxMode: Boolean; UseSystemShortName: Boolean; UseSystemFallback: Boolean; UseExtendedAscii:Boolean; var ShortName:String; var isDir: Boolean):TConvertResult;

function WinExtractShortPathName(ParentDir: String; LongName: String): String;
function WinExpandLongPathName(ParentDir: String; ShortName: String): String;

implementation

{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
{$WARN UNIT_PLATFORM OFF}

uses Windows, SysUtils, FileCtrl;

constructor TFileNameConvertor.Create;
begin
    ItemList:=TList.Create;
    LinuxMode:=False;
end;

constructor TFileNameConvertor.Create(ParentDir: String; UseLinuxeMode: Boolean);
begin
    Create;
    LinuxMode:=UseLinuxeMode;
    ReadDir(ParentDir);
end;

constructor TFileNameConvertor.Create(ParentDir: String; ReadUpToFile: String; UseLinuxeMode: Boolean);
begin
    Create;
    LinuxMode:=UseLinuxeMode;
    ReadDir(ParentDir, ReadUpToFile);
end;

destructor TFileNameConvertor.Destroy;
begin
  Clear;
  ItemList.Free;
end;

procedure TFileNameConvertor.Clear;
var
    I: Integer;
begin
    if ItemList<>nil then
    begin
        for I:=0 to ItemList.Count-1 do
          if ItemList[I]<>nil then
            Dispose(PFileNameInfo(ItemList[I]));
        ItemList.Clear;
    end;
end;

procedure TFileNameConvertor.ReadDir(ParentDir: String);
begin
    ReadDir(ParentDir, '');
end;

function WinExpandLongPathName(ParentDir: String; ShortName: String): String;
var
    Rec : TSearchRec;
    I: Integer;
begin
    ParentDir:=IncludeTrailingBackslash(ParentDir);
    I:=FindFirst(ParentDir+ShortName,faAnyFile or not faVolumeID,Rec);
    if I=0 then
        Result:=Rec.Name
    else Result:=ShortName;
    FindClose(Rec);
end;

function WinExtractShortPathName(ParentDir: String; LongName: String): String;
var
    Buffer: array[0..MAX_PATH - 1] of Char;
    S: String;
    Len: DWORD;
begin
    ParentDir:=IncludeTrailingBackslash(ParentDir);
    Len:=GetShortPathName(PChar(ParentDir+LongName), Buffer, SizeOf(Buffer));
    if Len=0 then
        Result:=LongName
    else
    begin
        SetString(S, Buffer, Len);
        Result:=ExtractFileName(S);
    end;
end;

procedure TFileNameConvertor.ReadDir(ParentDir: String; ReadUpToFile: String);
Var
    Rec : TSearchRec;
    I : Integer;
begin
    Clear;
    ParentDir:=IncludeTrailingBackslash(ParentDir);
    if not DirectoryExists(ParentDir) then Exit;

    if (not LinuxMode) and (ReadupToFile<>'') then
        ReadUpToFile:=WinExpandLongPathName(ParentDir,ReadUpToFile);

    I:=FindFirst(ParentDir+'*.*',faAnyFile or not faVolumeID,Rec);
    try
        While (I=0) and (I<MaxListSize)  do
        begin
            NewItem(Rec.Name, (Rec.Attr and faDirectory)>0);
            SortItems;
            I:=FindNext(Rec);
            if (ReadUpToFile<>'') and
                (
                  ((not LinuxMode) and (AnsiCompareFileName(Rec.Name,ReadUpToFile)=0))
                   or
                  (LinuxMode and (CompareStr(Rec.Name,ReadUpToFile)=0))
                )
                then I:=1;
        end;
    finally
        FindClose(Rec);
    end;
end;

function CompareItems(Item1: Pointer; Item2: Pointer): Integer;
begin
    if Item1 = nil then
    begin
        if Item2=nil then Result:=0 else Result:=-1;
    end
    else if Item2 = nil then
        Result:=-1
    else Result:= CompareStr(PFileNameInfo(Item1).ShortName,PFileNameInfo(Item2).ShortName);
end;

procedure TFileNameConvertor.SortItems;
begin
    ItemList.Sort(CompareItems);
end;

function TFileNameConvertor.GetItemsCount;
begin
    Result:=ItemList.Count;
end;

function TFileNameConvertor.GetItem(Index: Integer): TFileNameInfo;
begin
    Result := PFileNameInfo(ItemList[Index])^;

end;

procedure TFileNameConvertor.RemoveTrailingDot(Name: String);
begin
    if (Length(Name)>0) and (Name<>'.') and (Name<>'..') and (Name[Length(Name)]='.') then
        Delete(Name,Length(Name),1);
end;

function TFileNameConvertor.FindLongName(ShortName: String): String;
var
    I: Integer;
begin
    I:=IndexofShortName(ShortName);
    if (I>=0) and (I<ItemList.Count) then
        Result:=PFileNameInfo(ItemList[I]).LongName
    else Result:='';
end;

function TFileNameConvertor.FindShortName(LongName: String): String;
var
    I: Integer;
begin
    I:=IndexofLongName(LongName);
    if (I>=0) and (I<ItemList.Count) then
        Result:=PFileNameInfo(ItemList[I]).ShortName
    else Result:='';
end;

function TFileNameConvertor.IndexofShortName(ShortName: String): Integer;
var
    low, high, mid, res: Integer;
begin
    Result:=-1;
	RemoveTrailingDot(ShortName);
    low:=0;
    high:=ItemList.Count-1;
    while low<=high do
    begin
        mid:= (low+high) div 2;
        res:=CompareStr(ShortName,PFileNameInfo(ItemList[mid]).ShortName);
        if res>0 then low:=mid+1
        else if res<0 then high:=mid-1
        else
        begin
            Result:=mid;
            exit;
        end;
    end;
end;

function TFileNameConvertor.IndexofLongName(LongName: String): Integer;
var
    low, high, mid, res: Integer;
begin
    Result:=-1;
    low:=0;
    high:=ItemList.Count-1;
    while low<=high do
    begin
        mid:= (low+high) div 2;
        if LinuxMode then
            res:=CompareStr(LongName,PFileNameInfo(ItemList[mid]).LongName)
        else
            res:=AnsiCompareFileName(LongName,PFileNameInfo(ItemList[mid]).LongName);
        if res>0 then low:=mid+1
        else if res<0 then high:=mid-1
        else
        begin
            Result:=mid;
            exit;
        end;
    end;
end;


procedure TFileNameConvertor.NewItem(LongName: String; isDir: Boolean);
var
    Item: TFileNameInfo;
    PItem: PFileNameInfo;
begin
    Item.LongName:=LongName;
    Item.ShortName:='';
    Item.isDir:=isDir;
    Item.shortNumber:=0;
    CreateShortName(Item);
    New(PItem);
    PItem^:=Item;
    ItemList.Add(PItem);
end;

function TFileNameConvertor.RemoveSpaces(var S: String): Boolean;
Var
    I : Integer;
    S1: String;
begin
    S1:='';
    For I:=1 to Length(S) do if S[I]<>' ' then S1:=S1+S[I];
    Result:=S1<>S;
    S:=S1;
end;

function TFileNameConvertor.CompareShortName(ComparedName: String; ListedName: String): Integer;
var
    cps, compareCount1, numberSize, compareCount2: Integer;
begin
    cps:=Pos('~',ListedName);
    if cps>0 then
    begin
        compareCount1:=cps-1;
        numberSize:=Pos('.',Copy(ListedName,cps,MaxInt))-1;
        if numberSize<0 then numberSize:=Length(ListedName)-cps+1;
        compareCount2:=Pos('.',ComparedName)-1;
        if compareCount2<0 then compareCount2:=Length(ComparedName);
        if compareCount2>8 then compareCount2:=8;
        if compareCount2>(compareCount1+numberSize) then
            compareCount1:=compareCount2-numberSize;
        Result:=CompareStr(Copy(ComparedName,1,compareCount1),copy(ListedName,1,compareCount1));
    end
    else
        Result:=CompareStr(ComparedName,ListedName);
end;

function TFileNameConvertor.CreateShortNameNumber(ShortName: String): Integer;
var
    low, high, mid, res: Integer;
begin
    Result:=0;
    low:=0;
    high:=ItemList.Count-1;
    while low<=high do
    begin
        mid:= (low+high) div 2;
        res:=CompareShortName(ShortName,PFileNameInfo(ItemList[mid]).ShortName);
        if res>0 then low:=mid+1
        else if res<0 then high:=mid-1
        else
        begin
            while (mid<ItemList.Count) and (CompareShortName(ShortName,PFileNameInfo(ItemList[mid]).ShortName)=0)
            do
            begin
                Result:=PFileNameInfo(ItemList[mid]).shortNumber;
                Inc(mid);
            end;
            Break;
        end;
    end;
    Inc(Result);
end;

procedure TFileNameConvertor.CreateShortName(var Item: TFileNameInfo);
var
    len, lenExt, ps: Integer;
    createShort: Boolean;
    tmpName, numStr: String;
begin
    tmpName:=UpperCase(Item.LongName);
    createShort:=RemoveSpaces(tmpName);
    ps:=Pos('.',tmpName);
    if ps>0 then
    begin
        lenExt:=Length(tmpName)-ps;
        if lenExt>3 then
        begin
            while (tmpName<>'') and (tmpName[1]='.') do
                Delete(tmpName,1,1);
            createShort:=true;
        end;
        ps:=Pos('.',tmpName);
        if ps>0 then len:=ps-1 else len:=Length(tmpName);
    end
    else len:=Length(tmpName);

    createShort := createShort or (len>8);
    if not createShort then
        createShort := FindLongName(tmpName)<>'';

    if createShort then
    begin
        Item.shortNumber:=CreateShortNameNumber(tmpName);
        numStr:=IntToStr(Item.shortNumber);
        if (len+Length(numStr)+1)>8 then
            Item.ShortName:=Copy(tmpName,1, 8-1-Length(numStr))
        else
            Item.ShortName:=Copy(tmpName,1, len);
        Item.ShortName:=Item.ShortName+'~'+numStr;
        if ps>0 then
        begin
            ps:=LastDelimiter('.',tmpName);
            if ps>0 then
                Item.ShortName:=Item.ShortName+Copy(tmpName, ps, 4);
        end
    end
    else Item.ShortName:=tmpName;
    RemoveTrailingDot(Item.ShortName);
end;


function HasForbiddenChars(FileName : String; UseExtendedAscii:Boolean) : Boolean;
const AllowedDOSBoxFileNameChars=
   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'+
   'abcdefghijklmnopqrstuvwxyz'+
   '01234567890'+
   '$#@()'+
   '!%{}`~'+
   '_-.&''+^'+
   chr(246)+chr(255)+chr($a0)+chr($e5);
Var I : Integer;
begin
  Result:=False;
  For I:=1 to length(FileName) do
  begin
  if (Pos(FileName[I],AllowedDOSBoxFileNameChars)<=0) and
     ((Ord(FileName[I])<$80) or (not UseExtendedAscii))
  then
  begin
    Result:=True;
    Exit;
  end;
  end;
end;

function ConvertLongFileNameToShort(ParentDir:String; LongName: String; UseLinuxMode: Boolean; UseSystemShortName: Boolean; UseSystemFallback: Boolean; UseExtendedAscii:Boolean; var ShortName:String; var isDir: Boolean):TConvertResult;
var
    RealLongName: String;
    RealShortName: String;
    TestLongName: String;
    Dir: TFileNameConvertor;
begin
    ShortName:=LongName;
    isDir:=False;
    ParentDir:=IncludeTrailingBackslash(ParentDir);
    if not DirectoryExists(ParentDir) then
    begin
        Result:=tcrErrParentNotFound;
        exit;
    end;
    if (Pos('\',LongName)>0) or (Pos('/',LongName)>0) or (Pos(':',LongName)>0) then
    begin
        Result:=tcrErrDelimiterInFileName;
        exit;
    end;
    if not FileExists(ParentDir+LongName) then
        if not DirectoryExists(ParentDir+Longname) then
        begin
            Result:=tcrErrFileNotFound;
            exit;
        end
        else isDir:=true;

    RealLongName:=WinExpandLongPathName(ParentDir,LongName);

    if UseSystemShortName then
    begin
     if UseLinuxMode then ShortName:=LongName
     else ShortName:=WinExtractShortPathName(ParentDir,RealLongName);
     Result:=tcrOkExternal;
     exit;
    end;

    Dir:=TFileNameConvertor.Create(ParentDir, UseLinuxMode);
    try
        ShortName:=Dir.FindShortName(RealLongName);
        if not HasForbiddenChars(ShortName,UseExtendedAscii) then
            Result:=tcrOk
        else if UseLinuxMode or not UseSystemFallback then
            Result:=tcrWarnInvalidChars
        else
        begin
            RealShortName:=WinExtractShortPathName(ParentDir,LongName);
            TestLongName:=Dir.FindLongName(RealShortName);
            if (TestLongName='') or (TestLongName=RealLongName) then
            begin
                ShortName:=RealShortName;
                Result:=tcrWarnSystemShort;
            end
            else Result:=tcrWarnSystemShortAlreadyUsed;
        end;
    finally
        Dir.Free;
    end;
end;

{UseLinuxMode
UseSystemFallback}

end.
