unit PackageDBUnit;
interface

uses Classes, XMLIntf, Forms;

Type TPackageList=class;

     TDownloadData=class
  protected
    FName, FURL, FPackageChecksum : String;
    FSize : Int64;
    FChecksumXMLName : String;
    FPackageFileURL : String;
    FPackageList : TPackageList;
    Function CheckAttributes(const N : IXMLNode; const Attr : Array of String) : Boolean;
  public
    Constructor Create(const APackageList : TPackageList);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; virtual;
    Procedure SaveToXMLNode(const N : IXMLNode); virtual;
    property Name : String read FName;
    property URL : String read FURL;
    property Size : Int64 read FSize;
    property PackageChecksum : String read FPackageChecksum;
    property PackageFileURL : String read FPackageFileURL;
    property PackageList : TPackageList read FPackageList;
end;

     TDownloadIconData=class(TDownloadData)
  public
    Constructor Create(const APackageList : TPackageList);
end;

     TDownloadAutoSetupData=class(TDownloadData)
  private
    FGenre, FDeveloper, FPublisher, FYear, FLanguage, FGameExeChecksum, FMaxVersion : String;
  public
    Constructor Create(const APackageList : TPackageList);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    Procedure SaveToXMLNode(const N : IXMLNode); override;
    property MaxVersion : String read FMaxVersion;
    property Genre : String read FGenre;
    property Developer : String read FDeveloper;
    property Publisher : String read FPublisher;
    property Year : String read FYear;
    property Language : String read FLanguage;
    property GameExeChecksum : String read FGameExeChecksum;
end;

     TDownloadZipData=class(TDownloadAutoSetupData)
  private
    FLicense : String;
    FMetaLink : Boolean;
    FAutoSetupForZipURL, FAutoSetupForZipURLMaxVersion : String;
  public
    Constructor Create(const APackageList : TPackageList);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    Procedure SaveToXMLNode(const N : IXMLNode); override;
    property License : String read FLicense;
    property MetaLink : Boolean read FMetaLink;
    property AutoSetupForZipURL : String read FAutoSetupForZipURL;
    property AutoSetupForZipURLMaxVersion : String read FAutoSetupForZipURLMaxVersion;

end;

     TDownloadLanguageData=class(TDownloadData)
  private
    FDescription, FMinVersion, FMaxVersion, FAuthor : String;
  public
    Constructor Create(const APackageList : TPackageList);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    Procedure SaveToXMLNode(const N : IXMLNode); override;
    property Author : String read FAuthor;
    property MinVersion : String read FMinVersion;
    property MaxVersion : String read FMaxVersion;
    property Description : String read FDescription;
end;

     TDownloadExeData=class(TDownloadData)
  private
    FDescription : String;
  public
    Constructor Create(const APackageList : TPackageList);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    Procedure SaveToXMLNode(const N : IXMLNode); override;
    property Description : String read FDescription;
end;

     TDownloadIconSetData=class(TDownloadData)
  private
    FMinVersion, FMaxVersion, FAuthor : String;
  public
    Constructor Create(const APackageList : TPackageList);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    Procedure SaveToXMLNode(const N : IXMLNode); override;
    property MinVersion : String read FMinVersion;
    property MaxVersion : String read FMaxVersion;
    property Author : String read FAuthor;
end;

     TProviderAction=(paNothing, paWriteInfoToProfile, paInfoDialog, paOpenURL);
     TProviderActions=set of TProviderAction;

     TPackageList=class
  private
    FUpdateDate : TDateTime;
    FName : String;
    FFileName, FURL : String;
    FGame, FAutoSetup, FLanguage, FExePackage, FIcon, FIconSet : TList;
    FProviderName, FProviderText, FProviderURL, FReferer : String;
    FProviderActions : TProviderActions;
    HasProviderInfo : Boolean;
    function GetCount(const Index: Integer): Integer;
    Function AddGame(const N : IXMLNode) : Boolean;
    Function AddAutoSetup(const N : IXMLNode) : Boolean;
    Function AddLanguage(const N : IXMLNode) : Boolean;
    Function AddExePackage(const N : IXMLNode) : Boolean;
    Function AddIcon(const N : IXMLNode) : Boolean;
    Function AddIconSet(const N : IXMLNode) : Boolean;
    Procedure SetProviderInfo(const N : IXMLNode);
    function GetAutoSetup(I: Integer): TDownloadAutoSetupData;
    function GetExePackage(I: Integer): TDownloadExeData;
    function GetGame(I: Integer): TDownloadZipData;
    function GetLanguage(I: Integer): TDownloadLanguageData;
    function GetIcon(I: Integer): TDownloadIconData;
    function GetIconSet(I: Integer): TDownloadIconSetData;
  public
    Constructor Create(const AURL : String);
    Destructor Destroy; override;
    Procedure Clear;
    Function LoadFromFile(const AFileName : String; const AOrigFileName : String ='') : Boolean;
    Function SaveToFile(const ParentForm : TForm) : Boolean;
    Function FindAndRemoveGame(const AGame : TDownloadZipData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveAutoSetup(const AAutoSetup : TDownloadAutoSetupData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveIcon(const AIcon : TDownloadIconData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveIconSet(const AIconSet : TDownloadIconSetData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveLanguage(const ALanguage : TDownloadLanguageData; const ParentForm : TForm) : Boolean;
    property FileName : String read FFileName;
    property URL : String read FURL;
    property Name : String read FName;
    property UpdateDate : TDateTime read FUpdateDate;
    property GamesCount : Integer index 0 read GetCount;
    property AutoSetupCount : Integer index 1 read GetCount;
    property LanguageCount : Integer index 2 read GetCount;
    property ExePackageCount : Integer index 3 read GetCount;
    property IconCount : Integer index 4 read GetCount;
    property IconSetCount : Integer index 5 read GetCount;
    property Game[I : Integer] : TDownloadZipData read GetGame;
    property AutoSetup[I : Integer] : TDownloadAutoSetupData read GetAutoSetup;
    property Language[I : Integer] : TDownloadLanguageData read GetLanguage;
    property ExePackage[I : Integer] : TDownloadExeData read GetExePackage;
    property Icon[I : Integer] : TDownloadIconData read GetIcon;
    property IconSet[I : Integer] : TDownloadIconSetData read GetIconSet;
    property ProviderName : String read FProviderName;
    property ProviderText : String read FProviderText;
    property ProviderURL : String read FProviderURL;
    property Referer : String read FReferer;
    property ProviderActions : TProviderActions read FProviderActions;
end;

Type TPackageListFile=class
  private
    FUpdateDate : TDateTime;
    FURL : TStringList;
    FActive : TList;
    FFileName : String;
    FIsMasterList : Boolean;
    function GetCount: Integer;
    function GetURL(I: Integer): String;
    function GetActive(I: Integer): Boolean;
    procedure SetActive(I: Integer; const Value: Boolean);
    procedure SetURL(I: Integer; const Value: String);
    Procedure SpecialLoadActiveState;
    Procedure SpecialSaveActiveState;
  public
    Constructor Create(const AIsMasterList : Boolean);
    Destructor Destroy; override;
    Procedure Clear;
    Function LoadFromFile(const AFileName : String; const AOrigFileName : String ='') : Boolean;
    Procedure SaveToFile(const ParentForm : TForm);
    Function UpdateFromServer(const URL, TempFile : String; const UpdateAnyway, UpdateErrorQuite : Boolean) : Boolean;
    Procedure Add(const AURL : String; const AActive : Boolean);
    Procedure Delete(const Nr : Integer);
    property FileName : String read FFileName;
    property UpdateDate : TDateTime read FUpdateDate write FUpdateDate;
    property Count : Integer read GetCount;
    property URL[I : Integer] : String read GetURL write SetURL; default;
    property Active[I : Integer] : Boolean read GetActive write SetActive;
end;

Type TDownloadStatus=(dsStart,dsProgress,dsDone);
Type TDownloadEvent=Procedure(Sender : TObject; const Progress, Size : Int64; const Status : TDownloadStatus; var ContinueDownload : Boolean) of object;

Type TPackageDB=class
  private
    FPackageList : TList;
    FDBDir : String;
    FOnDownload : TDownloadEvent;
    Function InitDBDir : Boolean;
    Function InitPackageFiles(const MainFile, UserFile : TPackageListFile; const Update, UpdateAll, UpdateRemoteOnly, UpdateErrorQuite : Boolean) : Boolean;
    Function InitPackageFile(const URL : String; const Update, UpdateAll, UpdateRemoteOnly, UpdateErrorQuite : Boolean) : TPackageList;
    Function GetCount: Integer;
    Function GetPackageList(I: Integer): TPackageList;
    Function FileInUse(FileName : String) : Boolean;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear;
    Function LoadDB(const Update, UpdateAll, UpdateErrorQuite : Boolean) : Boolean;
    Procedure UpdateRemoteFiles(const UpdateErrorQuite : Boolean);
    Function FindAndRemoveGame(const AGame : TDownloadZipData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveAutoSetup(const AAutoSetup : TDownloadAutoSetupData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveIcon(const AIcon : TDownloadIconData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveIconSet(const AIconSet : TDownloadIconSetData; const ParentForm : TForm) : Boolean;
    Function FindAndRemoveLanguage(const ALanguage : TDownloadLanguageData; const ParentForm : TForm) : Boolean;
    property Count : Integer read GetCount;
    property List[I : Integer] : TPackageList read GetPackageList; default;
    property DBDir : String read FDBDir;
    property OnDownload : TDownloadEvent read FOnDownload write FOnDownload;
end;

implementation

uses Windows, SysUtils, Dialogs, XMLDom, XMLDoc, MSXMLDOM, PackageDBToolsUnit,
     CommonTools, PrgConsts, PrgSetupUnit, LanguageSetupUnit, GameDBToolsUnit;

{ TDownloadData }

constructor TDownloadData.Create(const APackageList : TPackageList);
begin
  inherited Create;
  FName:='';
  FURL:='';
  FPackageChecksum:='';
  FSize:=0;
  FPackageList:=APackageList;
  FPackageFileURL:=FPackageList.URL;

  FChecksumXMLName:='PackageChecksum';
end;

Function TDownloadData.CheckAttributes(const N : IXMLNode; const Attr : Array of String) : Boolean;
Var I : Integer;
begin
  result:=False;
  For I:=Low(Attr) to High(Attr) do If not N.HasAttribute(Attr[I]) then exit;
  result:=True;
end;

function TDownloadData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not CheckAttributes(N,['Name',FChecksumXMLName,'Size']) then exit;
  FName:=DecodeHTMLSymbols(N.Attributes['Name']);
  FPackageChecksum:=N.Attributes[FChecksumXMLName];
  if not TryStrToInt64(N.Attributes['Size'],FSize) then FSize:=0;
  FURL:=N.NodeValue; If (FURL='') then exit;
  result:=True;
end;

Procedure TDownloadData.SaveToXMLNode(const N : IXMLNode);
begin
  N.Attributes['Name']:=EncodeHTMLSymbols(FName);
  N.Attributes[FChecksumXMLName]:=FPackageChecksum;
  N.Attributes['Size']:=IntToStr(FSize);
  N.NodeValue:=FURL;
end;

{ TDownloadIconData }

constructor TDownloadIconData.Create(const APackageList : TPackageList);
begin
  inherited Create(APackageList);
  FChecksumXMLName:='FileChecksum';
end;

{ TDownloadAutoSetupData }

constructor TDownloadAutoSetupData.Create(const APackageList : TPackageList);
begin
  inherited Create(APackageList);
  FGenre:='';
  FDeveloper:='';
  FPublisher:='';
  FYear:='';
  FLanguage:='';
  FMaxVersion:='';
end;

function TDownloadAutoSetupData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  if not CheckAttributes(N,['Genre','Developer','Publisher','Year','Language']) then exit;
  FGenre:=DecodeHTMLSymbols(N.Attributes['Genre']);
  FDeveloper:=DecodeHTMLSymbols(N.Attributes['Developer']);
  FPublisher:=DecodeHTMLSymbols(N.Attributes['Publisher']);
  FYear:=DecodeHTMLSymbols(N.Attributes['Year']);
  FLanguage:=DecodeHTMLSymbols(N.Attributes['Language']);
  If N.HasAttribute('GameExeChecksum') then FGameExeChecksum:=N.Attributes['GameExeChecksum'] else FGameExeChecksum:='';
  If N.HasAttribute('MaxVersion') then FMaxVersion:=N.Attributes['MaxVersion'] else FMaxVersion:='';
  result:=True;
end;

Procedure TDownloadAutoSetupData.SaveToXMLNode(const N : IXMLNode);
begin
  inherited SaveToXMLNode(N);
  N.Attributes['Genre']:=EncodeHTMLSymbols(FGenre);
  N.Attributes['Developer']:=EncodeHTMLSymbols(FDeveloper);
  N.Attributes['Publisher']:=EncodeHTMLSymbols(FPublisher);
  N.Attributes['Year']:=EncodeHTMLSymbols(FYear);
  N.Attributes['Language']:=EncodeHTMLSymbols(FLanguage);
  If FGameExeChecksum<>'' then N.Attributes['GameExeChecksum']:=FGameExeChecksum;
  if FMaxVersion<>'' then N.Attributes['MaxVersion']:=FMaxVersion;
end;

{ TDownloadZipData }

constructor TDownloadZipData.Create(const APackageList : TPackageList);
begin
  inherited Create(APackageList);
  FLicense:='';
  FMetaLink:=False;
  FAutoSetupForZipURL:=''; FAutoSetupForZipURLMaxVersion:='';
end;

function TDownloadZipData.LoadFromXMLNode(const N: IXMLNode): Boolean;
Var S : String;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  if not CheckAttributes(N,['License']) then exit;
  FLicense:=DecodeHTMLSymbols(N.Attributes['License']);

  If N.HasAttribute('MetaLink') then begin
    S:=ExtUpperCase(N.Attributes['MetaLink']);
    FMetaLink:=(S='YES') or (S='ON') or (S='TRUE');
  end;

  If N.HasAttribute('AutoSetupURL') then begin
    FAutoSetupForZipURL:=N.Attributes['AutoSetupURL'];
    If N.HasAttribute('AutoSetupURLMaxVersion') then FAutoSetupForZipURLMaxVersion:=N.Attributes['AutoSetupURLMaxVersion'];
  end;

  result:=True;
end;

Procedure TDownloadZipData.SaveToXMLNode(const N : IXMLNode);
begin
  inherited SaveToXMLNode(N);

  N.Attributes['License']:=EncodeHTMLSymbols(FLicense);
  if FMetaLink then N.Attributes['MetaLink']:='Yes';
  If FAutoSetupForZipURL<>'' then begin
    N.Attributes['AutoSetupURL']:=FAutoSetupForZipURL;
    If FAutoSetupForZipURLMaxVersion<>'' then N.Attributes['AutoSetupURLMaxVersion']:=FAutoSetupForZipURLMaxVersion;
  end;
end;

{ TDownloadLanguage }

constructor TDownloadLanguageData.Create(const APackageList : TPackageList);
begin
  inherited Create(APackageList);
  FMinVersion:=''; FMaxVersion:=''; FAuthor:=''; FDescription:='';
end;

function TDownloadLanguageData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  If not CheckAttributes(N,['MinVersion','MaxVersion','Author']) then exit;
  If N.HasAttribute('Description') then FDescription:=N.Attributes['Description'];
  FMinVersion:=N.Attributes['MinVersion'];
  FMaxVersion:=N.Attributes['MaxVersion'];
  FAuthor:=DecodeHTMLSymbols(N.Attributes['Author']);
  result:=True;
end;

Procedure TDownloadLanguageData.SaveToXMLNode(const N : IXMLNode);
begin
  inherited SaveToXMLNode(N);
  If FDescription<>'' then N.Attributes['Description']:=FDescription;
  N.Attributes['MinVersion']:=FMinVersion;
  N.Attributes['MaxVersion']:=FMaxVersion;
  N.Attributes['Author']:=EncodeHTMLSymbols(FAuthor);
end;

{ TDownloadExeData }

constructor TDownloadExeData.Create(const APackageList : TPackageList);
begin
  inherited Create(APackageList);
  FDescription:='';
end;

function TDownloadExeData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  If not inherited LoadFromXMLNode(N) then exit;
  if not CheckAttributes(N,['Description']) then exit;
  FDescription:=DecodeHTMLSymbols(N.Attributes['Description']);
  result:=True;
end;

Procedure TDownloadExeData.SaveToXMLNode(const N : IXMLNode);
begin
  inherited SaveToXMLNode(N);
  N.Attributes['Description']:=EncodeHTMLSymbols(FDescription);
end;

{ TDownloadIconSetData }

constructor TDownloadIconSetData.Create(const APackageList : TPackageList);
begin
  inherited Create(APackageList);
  FChecksumXMLName:='FileChecksum';
  FMinVersion:=''; FMaxVersion:=''; FAuthor:='';
end;

function TDownloadIconSetData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  If not CheckAttributes(N,['MinVersion','MaxVersion','Author']) then exit;
  FMinVersion:=N.Attributes['MinVersion'];
  FMaxVersion:=N.Attributes['MaxVersion'];
  FAuthor:=DecodeHTMLSymbols(N.Attributes['Author']);
  result:=True;
end;

Procedure TDownloadIconSetData.SaveToXMLNode(const N : IXMLNode);
begin
  inherited SaveToXMLNode(N);
  N.Attributes['MinVersion']:=FMinVersion;
  N.Attributes['MaxVersion']:=FMaxVersion;
  N.Attributes['Author']:=EncodeHTMLSymbols(FAuthor);
end;

{ TPackageList }

constructor TPackageList.Create(const AURL : String);
begin
  inherited Create;
  FUpdateDate:=0;
  FFileName:='';
  FURL:=AURL;
  FGame:=TList.Create;
  FAutoSetup:=TList.Create;
  FLanguage:=TList.Create;
  FExePackage:=TList.Create;
  FIcon:=TList.Create;
  FIconSet:=TList.Create;
  FProviderName:='';
  FProviderText:='';
  FProviderURL:='';
  FProviderActions:=[];
  FReferer:='automatic';
end;

destructor TPackageList.Destroy;
begin
  Clear;
  FGame.Free;
  FAutoSetup.Free;
  FLanguage.Free;
  FExePackage.Free;
  FIcon.Free;
  FIconSet.Free;
  inherited Destroy;
end;

Procedure TPackageList.Clear;
Var I : Integer;
begin
  For I:=0 to FGame.Count-1 do TDownloadZipData(FGame[I]).Free;
  FGame.Clear;
  For I:=0 to FAutoSetup.Count-1 do TDownloadAutoSetupData(FAutoSetup[I]).Free;
  FAutoSetup.Clear;
  For I:=0 to FLanguage.Count-1 do TDownloadLanguageData(FLanguage[I]).Free;
  FLanguage.Clear;
  For I:=0 to FExePackage.Count-1 do TDownloadExeData(FExePackage[I]).Free;
  FExePackage.Clear;
  For I:=0 to FIcon.Count-1 do TDownloadIconData(FIcon[I]).Free;
  FIcon.Clear;
  For I:=0 to FIconSet.Count-1 do TDownloadIconSetData(FIconSet[I]).Free;
  FIconSet.Clear;
  FProviderName:='';
  FProviderText:='';
  FProviderURL:='';
  FProviderActions:=[];
  HasProviderInfo:=False;
end;

function TPackageList.GetCount(const Index: Integer): Integer;
begin
  Case Index of
    0 : result:=FGame.Count;
    1 : result:=FAutoSetup.Count;
    2 : result:=FLanguage.Count;
    3 : result:=FExePackage.Count;
    4 : result:=FIcon.Count;
    5 : result:=FIconSet.Count;
    else result:=0;
  end;
end;

function TPackageList.GetGame(I: Integer): TDownloadZipData;
begin
  If (I<0) or (I>=FGame.Count) then result:=nil else result:=TDownloadZipData(FGame[I]);
end;

function TPackageList.GetAutoSetup(I: Integer): TDownloadAutoSetupData;
begin
  If (I<0) or (I>=FAutoSetup.Count) then result:=nil else result:=TDownloadAutoSetupData(FAutoSetup[I]);
end;

function TPackageList.GetLanguage(I: Integer): TDownloadLanguageData;
begin
  If (I<0) or (I>=FLanguage.Count) then result:=nil else result:=TDownloadLanguageData(FLanguage[I]);
end;

function TPackageList.GetExePackage(I: Integer): TDownloadExeData;
begin
  If (I<0) or (I>=FExePackage.Count) then result:=nil else result:=TDownloadExeData(FExePackage[I]);
end;

function TPackageList.GetIcon(I: Integer): TDownloadIconData;
begin
  If (I<0) or (I>=FIcon.Count) then result:=nil else result:=TDownloadIconData(FIcon[I]);
end;

function TPackageList.GetIconSet(I: Integer): TDownloadIconSetData;
begin
  If (I<0) or (I>=FIconSet.Count) then result:=nil else result:=TDownloadIconSetData(FIconSet[I]);
end;

Function TPackageList.AddGame(const N : IXMLNode) : Boolean;
Var DownloadZipData : TDownloadZipData;
begin
  DownloadZipData:=TDownloadZipData.Create(self);
  result:=DownloadZipData.LoadFromXMLNode(N);
  if result then FGame.Add(DownloadZipData) else DownloadZipData.Free;
end;

Function TPackageList.AddAutoSetup(const N : IXMLNode) : Boolean;
Var DownloadAutoSetupData : TDownloadAutoSetupData;
begin
  DownloadAutoSetupData:=TDownloadAutoSetupData.Create(self);
  result:=DownloadAutoSetupData.LoadFromXMLNode(N);
  if result then FAutoSetup.Add(DownloadAutoSetupData) else DownloadAutoSetupData.Free;
end;

Function TPackageList.AddLanguage(const N : IXMLNode) : Boolean;
Var DownloadLanguageData : TDownloadLanguageData;
begin
  DownloadLanguageData:=TDownloadLanguageData.Create(self);
  result:=DownloadLanguageData.LoadFromXMLNode(N);
  if result then FLanguage.Add(DownloadLanguageData) else DownloadLanguageData.Free;
end;

Function TPackageList.AddExePackage(const N : IXMLNode) : Boolean;
Var DownloadExeData : TDownloadExeData;
begin
  DownloadExeData:=TDownloadExeData.Create(self);
  result:=DownloadExeData.LoadFromXMLNode(N);
  if result then FExePackage.Add(DownloadExeData) else DownloadExeData.Free;
end;

Function TPackageList.AddIcon(const N : IXMLNode) : Boolean;
Var DownloadIconData : TDownloadIconData;
begin
  DownloadIconData:=TDownloadIconData.Create(self);
  result:=DownloadIconData.LoadFromXMLNode(N);
  if result then FIcon.Add(DownloadIconData) else DownloadIconData.Free;
end;

Function TPackageList.AddIconSet(const N : IXMLNode) : Boolean;
Var DownloadIconSetData : TDownloadIconSetData;
begin
  DownloadIconSetData:=TDownloadIconSetData.Create(self);
  result:=DownloadIconSetData.LoadFromXMLNode(N);
  if result then FIconSet.Add(DownloadIconSetData) else DownloadIconSetData.Free;
end;

Procedure TPackageList.SetProviderInfo(const N : IXMLNode);
begin
  HasProviderInfo:=True;
  If (N.HasAttribute('WriteToProfile')) and (Trim(ExtUpperCase(N.Attributes['WriteToProfile']))='YES') then FProviderActions:=FProviderActions+[paWriteInfoToProfile];
  If (N.HasAttribute('Dialog')) and (Trim(ExtUpperCase(N.Attributes['Dialog']))='YES') then FProviderActions:=FProviderActions+[paInfoDialog];
  If (N.HasAttribute('OpenURL')) and (Trim(ExtUpperCase(N.Attributes['OpenURL']))='YES') then FProviderActions:=FProviderActions+[paOpenURL];
  If N.HasAttribute('Name') then FProviderName:=DecodeHTMLSymbols(N.Attributes['Name']);
  If N.HasAttribute('Text') then FProviderText:=DecodeHTMLSymbols(N.Attributes['Text']);
  If N.HasAttribute('URL') then FProviderURL:=N.Attributes['URL'];
  If N.HasAttribute('Referer') then FReferer:=N.Attributes['Referer'];
end;

function TPackageList.LoadFromFile(const AFileName: String; const AOrigFileName : String): Boolean;
Var XMLDoc : TXMLDocument;
    I : Integer;
    N : IXMLNode;
begin
  result:=False;
  FFileName:=AFileName;
  Clear;

  XMLDoc:=LoadXMLDoc(AFileName,AOrigFileName); if XMLDoc=nil then exit;
  try
    If XMLDoc.DocumentElement.NodeName<>'DFRPackagesFile' then exit;
    If not XMLDoc.DocumentElement.HasAttribute('Name') then exit;
    FName:=DecodeHTMLSymbols(XMLDoc.DocumentElement.Attributes['Name']);
    If not XMLDoc.DocumentElement.HasAttribute('LastUpdateDate') then FUpdateDate:=0 else begin
      FUpdateDate:=DecodeUpdateDate(XMLDoc.DocumentElement.Attributes['LastUpdateDate']);
    end;
    For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
      N:=XMLDoc.DocumentElement.ChildNodes[I];
      If N.NodeName='Game' then AddGame(N);
      If N.NodeName='AutoSetup' then AddAutoSetup(N);
      If N.NodeName='Language' then AddLanguage(N);
      If N.NodeName='ExePackage' then AddExePackage(N);
      If N.NodeName='Icon' then AddIcon(N);
      If N.NodeName='IconSet' then AddIconSet(N);
      If N.NodeName='Provider' then SetProviderInfo(N);
    end;
  finally
    XMLDoc.Free;
  end;

  result:=True;
end;

Function TPackageList.SaveToFile(const ParentForm : TForm) : Boolean;
Var Doc : TXMLDocument;
    I : Integer;
    Node : IXMLNode;
begin
  result:=False;
  If FFileName='' then exit;

   Doc:=TXMLDocument.Create(ParentForm);
  try
    try
      Doc.DOMVendor:=MSXML_DOM;
      Doc.Active:=True;
    except
      on E : Exception do begin MessageDlg(E.Message,mtError,[mbOK],0); exit; end;
    end;

    Doc.DocumentElement:=Doc.CreateNode('DFRPackagesFile');
    Doc.DocumentElement.Attributes['Name']:=FName;
    Doc.DocumentElement.Attributes['LastUpdateDate']:=EncodeUpdateDate(FUpdateDate);

    For I:=0 to FExePackage.Count-1 do TDownloadExeData(FExePackage[I]).SaveToXMLNode(Doc.DocumentElement.AddChild('ExePackage'));
    For I:=0 to FGame.Count-1 do TDownloadZipData(FGame[I]).SaveToXMLNode(Doc.DocumentElement.AddChild('Game'));
    For I:=0 to FAutoSetup.Count-1 do TDownloadAutoSetupData(FAutoSetup[I]).SaveToXMLNode(Doc.DocumentElement.AddChild('AutoSetup'));
    For I:=0 to FIcon.Count-1 do TDownloadIconData(FIcon[I]).SaveToXMLNode(Doc.DocumentElement.AddChild('Icon'));
    For I:=0 to FIconSet.Count-1 do TDownloadIconSetData(FIconSet[I]).SaveToXMLNode(Doc.DocumentElement.AddChild('IconSet'));
    For I:=0 to FLanguage.Count-1 do TDownloadLanguageData(FLanguage[I]).SaveToXMLNode(Doc.DocumentElement.AddChild('Language'));

    if HasProviderInfo then begin
      Node:=Doc.DocumentElement.AddChild('Provider');
      If paWriteInfoToProfile in FProviderActions then Node.Attributes['WriteToProfile']:='Yes';
      If paInfoDialog in FProviderActions then Node.Attributes['Dialog']:='Yes';
      If paOpenURL in FProviderActions then Node.Attributes['OpenURL']:='Yes';
      If FProviderName<>'' then Node.Attributes['Name']:=EncodeHTMLSymbols(FProviderName);
      If FProviderText<>'' then Node.Attributes['Text']:=EncodeHTMLSymbols(FProviderText);
      If FProviderURL<>'' then Node.Attributes['URL']:=FProviderURL;
      If FReferer<>'' then Node.Attributes['Referer']:=FReferer;
    end;

    SaveXMLDoc(Doc,['<!DOCTYPE DFRPackagesFile SYSTEM "'+DFRHomepage+'Packages/DFRPackagesFile.dtd">'],FFileName,False);
  finally
    Doc.Free;
  end;
  result:=True;
end;

Function TPackageList.FindAndRemoveGame(const AGame : TDownloadZipData; const ParentForm : TForm) : Boolean;
Var I, Index : Integer;
begin
  Result:=False;
  Index:=-1;
  For I:=0 to FGame.Count-1 do if AGame=FGame[I] then begin Index:=I; break; end;
  if Index<0 then exit;

  TDownloadZipData(FGame[Index]).Free;
  FGame.Delete(Index);

  result:=True;
  SaveToFile(ParentForm);
end;

Function TPackageList.FindAndRemoveAutoSetup(const AAutoSetup : TDownloadAutoSetupData; const ParentForm : TForm) : Boolean;
Var I, Index : Integer;
begin
  Result:=False;
  Index:=-1;
  For I:=0 to FAutoSetup.Count-1 do if AAutoSetup=FAutoSetup[I] then begin Index:=I; break; end;
  if Index<0 then exit;

  TDownloadAutoSetupData(FAutoSetup[Index]).Free;
  FAutoSetup.Delete(Index);
  
  result:=True;
  SaveToFile(ParentForm);
end;

Function TPackageList.FindAndRemoveIcon(const AIcon : TDownloadIconData; const ParentForm : TForm) : Boolean;
Var I, Index : Integer;
begin
  Result:=False;
  Index:=-1;
  For I:=0 to FIcon.Count-1 do if AIcon=FIcon[I] then begin Index:=I; break; end;
  if Index<0 then exit;

  TDownloadIconData(FIcon[Index]).Free;
  FIcon.Delete(Index);
  
  result:=True;
  SaveToFile(ParentForm);
end;


Function TPackageList.FindAndRemoveIconSet(const AIconSet : TDownloadIconSetData; const ParentForm : TForm) : Boolean;
Var I, Index : Integer;
begin
  Result:=False;
  Index:=-1;
  For I:=0 to FIconSet.Count-1 do if AIconSet=FIconSet[I] then begin Index:=I; break; end;
  if Index<0 then exit;

  TDownloadIconSetData(FIconSet[Index]).Free;
  FIconSet.Delete(Index);
  
  result:=True;
  SaveToFile(ParentForm);
end;

Function TPackageList.FindAndRemoveLanguage(const ALanguage : TDownloadLanguageData; const ParentForm : TForm) : Boolean;
Var I, Index : Integer;
begin
  Result:=False;
  Index:=-1;
  For I:=0 to FLanguage.Count-1 do if ALanguage=FLanguage[I] then begin Index:=I; break; end;
  if Index<0 then exit;

  TDownloadLanguageData(FIconSet[Index]).Free;
  FLanguage.Delete(Index);
  
  result:=True;
  SaveToFile(ParentForm);
end;

{ TMainPackageFile }

constructor TPackageListFile.Create(const AIsMasterList : Boolean);
begin
  inherited Create;
  FIsMasterList:=AIsMasterList;
  FUpdateDate:=0;
  FURL:=TStringList.Create;
  FActive:=TList.Create;
  FFileName:='';
end;

destructor TPackageListFile.Destroy;
begin
  FURL.Free;
  FActive.Free;
  inherited Destroy;
end;

Procedure TPackageListFile.Clear;
begin
  FURL.Clear;
  FActive.Clear;
end;

function TPackageListFile.GetCount: Integer;
begin
  result:=FURL.Count;
end;

function TPackageListFile.GetURL(I: Integer): String;
begin
  If (I<0) or (I>=FURL.Count) then result:='' else result:=FURL[I];
end;

procedure TPackageListFile.SetURL(I: Integer; const Value: String);
begin
  If (I<0) or (I>=FURL.Count) then exit;
  FURL[I]:=Value;
end;

function TPackageListFile.GetActive(I: Integer): Boolean;
begin
  If (I<0) or (I>=FURL.Count) then result:=False else result:=(Integer(FActive[I])<>0);
end;

procedure TPackageListFile.SetActive(I: Integer; const Value: Boolean);
begin
  If (I<0) or (I>=FURL.Count) then exit;
  If Value then FActive[I]:=Pointer(1) else FActive[I]:=Pointer(0);
end;

procedure TPackageListFile.Add(const AURL: String; const AActive: Boolean);
begin
  FURL.Add(AURL);
  If AActive then FActive.Add(Pointer(1)) else FActive.Add(Pointer(0));
end;

procedure TPackageListFile.Delete(const Nr: Integer);
begin
  If (Nr<0) or (Nr>=FURL.Count) then exit;
  FURL.Delete(Nr);
  FActive.Delete(Nr);
end;

function TPackageListFile.LoadFromFile(const AFileName: String; const AOrigFileName : String): Boolean;
Var XMLDoc : TXMLDocument;
    I : Integer;
begin
  Clear;
  FFileName:=AFileName;
  result:=False;

  XMLDoc:=LoadXMLDoc(AFileName,AOrigFileName);
  try
    If (XMLDoc=nil) or (XMLDoc.DocumentElement.NodeName<>'DFRPackagesList') then exit;
    If not XMLDoc.DocumentElement.HasAttribute('LastUpdateDate') then FUpdateDate:=0 else begin
      FUpdateDate:=DecodeUpdateDate(XMLDoc.DocumentElement.Attributes['LastUpdateDate']);
    end;
    For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do If XMLDoc.DocumentElement.ChildNodes[I].NodeName='DFRPackagesFile' then begin
      If XMLDoc.DocumentElement.ChildNodes[I].HasAttribute('URL') then FURL.Add(XMLDoc.DocumentElement.ChildNodes[I].Attributes['URL']);
      If XMLDoc.DocumentElement.ChildNodes[I].HasAttribute('Active') then begin
        If Trim(ExtUpperCase(XMLDoc.DocumentElement.ChildNodes[I].Attributes['Active']))='YES' then FActive.Add(Pointer(1)) else FActive.Add(Pointer(0));
      end else begin
        FActive.Add(Pointer(1));
      end; 
    end;
  finally
    XMLDoc.Free;
  end;

  If FIsMasterList then SpecialLoadActiveState;

  result:=True;
end;

procedure TPackageListFile.SaveToFile(const ParentForm : TForm);
Var Doc : TXMLDocument;
    I : Integer;
    N : IXMLNode;
begin
  Doc:=TXMLDocument.Create(ParentForm);
  try
    try
      Doc.DOMVendor:=MSXML_DOM;
      Doc.Active:=True;
    except
      on E : Exception do begin MessageDlg(E.Message,mtError,[mbOK],0); exit; end;
    end;
    Doc.DocumentElement:=Doc.CreateNode('DFRPackagesList');
    Doc.DocumentElement.Attributes['LastUpdateDate']:=EncodeUpdateDate(FUpdateDate);
    For I:=0 to FURL.Count-1 do begin
      N:=Doc.DocumentElement.AddChild('DFRPackagesFile');
      N.Attributes['URL']:=FURL[I];
      If Integer(FActive[I])<>0 then N.Attributes['Active']:='Yes' else N.Attributes['Active']:='No';
    end;
    SaveXMLDoc(Doc,['<!DOCTYPE DFRPackagesList SYSTEM "'+DFRHomepage+'Packages/DFRPackagesList.dtd">'],FFileName,False);
  finally
    Doc.Free;
  end;

  If FIsMasterList then SpecialSaveActiveState;
end;

Function TPackageListFile.UpdateFromServer(const URL, TempFile : String; const UpdateAnyway, UpdateErrorQuite : Boolean) : Boolean;
Var TempMainFile : TPackageListFile;
begin
  result:=DownloadFile(URL,TempFile,UpdateErrorQuite);
  if not result then exit;

  TempMainFile:=TPackageListFile.Create(FIsMasterList);
  try
    if not TempMainFile.LoadFromFile(TempFile) then exit;
    If (TempMainFile.UpdateDate<=UpdateDate) and (not UpdateAnyway) then exit;
    Clear;
    ExtDeleteFile(FileName,ftTemp);
    RenameFile(TempFile,FileName);
    LoadFromFile(FileName);
  finally
    TempMainFile.Free;
    ExtDeleteFile(TempFile,ftTemp);
  end;
end;

Procedure TPackageListFile.SpecialLoadActiveState;
Var ActiveStateFileName : String;
    St : TStringList;
    I,J : Integer;
    S : String;
begin
  ActiveStateFileName:=ChangeFileExt(FFileName,'.txt');

  If not FileExists(ActiveStateFileName) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(ActiveStateFileName); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=St[I];
      If (S<>'') and (S[1]=';') then continue;
      J:=FURL.IndexOf(S);
      If J>=0 then FActive[J]:=TObject(0);
    end;
  finally
    St.Free;
  end;
end;

Procedure TPackageListFile.SpecialSaveActiveState;
Var ActiveStateFileName : String;
    St : TStringList;
    I : Integer;
begin

  ActiveStateFileName:=ChangeFileExt(FFileName,'.txt');

  St:=TStringList.Create;
  try
    For I:=0 to FActive.Count-1 do If Integer(FActive[I])=0 then St.Add(FURL[I]);
    If St.Count=0 then begin
      DeleteFile(ActiveStateFileName);
    end else begin
      St.Insert(0,'; Deactivated main package lists');
      try St.SaveToFile(ActiveStateFileName); except end;
    end;  
  finally
    St.Free;
  end;
end;

{ TPackageDB }

constructor TPackageDB.Create;
begin
  inherited Create;
  FOnDownload:=nil;
  FPackageList:=TList.Create;
 end;

destructor TPackageDB.Destroy;
begin
  inherited Destroy;
  Clear;
  FPackageList.Free;
end;

procedure TPackageDB.Clear;
Var I : Integer;
begin
  for I:=0 to FPackageList.Count-1 do TPackageList(FPackageList[I]).Free;
  FPackageList.Clear;
end;

function TPackageDB.GetCount: Integer;
begin
  result:=FPackageList.Count;
end;

function TPackageDB.GetPackageList(I: Integer): TPackageList;
begin
  If (I<0) or (I>=FPackageList.Count) then result:=nil else result:=TPackageList(FPackageList[I]);
end;

function TPackageDB.InitDBDir: Boolean;
begin
  result:=False;

  FDBDir:=IncludeTrailingPathDelimiter(PrgDataDir+PackageDBSubFolder);

  If not DirectoryExists(FDBDir) then begin
    if not ForceDirectories(FDBDir) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[FDBDir]),mtError,[mbOK],0);
      exit;
    end;
  end;

  result:=True;
end;

function TPackageDB.InitPackageFile(const URL: String; const Update, UpdateAll, UpdateRemoteOnly, UpdateErrorQuite : Boolean): TPackageList;
Var TempList : TPackageList;
begin
  result:=TPackageList.Create(URL);
  result.LoadFromFile(DBDir+ExtractFileNameFromURL(URL,'.xml',False));

  If not Update then exit;
  If UpdateRemoteOnly and (ExtUpperCase(Copy(URL,1,7))<>'HTTP:/'+'/') then exit;

  if not DownloadFile(URL,DBDir+PackageDBTempFile,UpdateErrorQuite) then exit;

  TempList:=TPackageList.Create(URL);
  try
    if not TempList.LoadFromFile(DBDir+PackageDBTempFile,DBDir+ExtractFileNameFromURL(URL,'.xml',False)) then exit;
    If (TempList.UpdateDate<=result.UpdateDate) and (not UpdateAll) then exit;

    result.Free;
    FreeAndNil(TempList);
    ExtDeleteFile(DBDir+ExtractFileNameFromURL(URL,'.xml',False),ftTemp);
    RenameFile(DBDir+PackageDBTempFile,DBDir+ExtractFileNameFromURL(URL,'.xml',False));
    result:=TPackageList.Create(URL);
    result.LoadFromFile(DBDir+ExtractFileNameFromURL(URL,'.xml',False));
  finally
    TempList.Free;
    ExtDeleteFile(DBDir+PackageDBTempFile,ftTemp);
  end;
end;

Function TPackageDB.FileInUse(FileName : String) : Boolean;
Var I : Integer;
begin
  result:=True;
  FileName:=ExtUpperCase(ExtractFileName(FileName));
  If FileName=ExtUpperCase(PackageDBMainFile) then exit;
  If FileName=ExtUpperCase(PackageDBUserFile) then exit;
  For I:=0 to FPackageList.Count-1 do begin
    If FileName=ExtUpperCase(ExtractFileName(TPackageList(FPackageList[I]).FileName)) then exit;
  end;
  result:=False;
end;

Function TPackageDB.InitPackageFiles(const MainFile, UserFile: TPackageListFile; const Update, UpdateAll, UpdateRemoteOnly, UpdateErrorQuite : Boolean) : Boolean;
Var I,C1,C2 : Integer;
    P : TPackageList;
    Rec : TSearchRec;
    ContinueDownload : Boolean;
begin
  If Assigned(FOnDownload) then FOnDownload(self,0,MainFile.Count+UserFile.Count,dsStart,ContinueDownload);
  ContinueDownload:=True;
  try
    {Load and update files}

    C1:=0; For I:=0 to MainFile.Count-1 do If MainFile.Active[I] then inc(C1);
    C2:=0; For I:=0 to UserFile.Count-1 do If UserFile.Active[I] then inc(C2);

    For I:=0 to MainFile.Count-1 do If MainFile.Active[I] then begin
      If Assigned(FOnDownload) then FOnDownload(self,I,C1+C2,dsProgress,ContinueDownload);
      P:=InitPackageFile(MainFile[I],Update,UpdateAll,UpdateRemoteOnly,UpdateErrorQuite);
      If P<>nil then FPackageList.Add(P);
      If not ContinueDownload then break;
    end;
    If ContinueDownload then For I:=0 to UserFile.Count-1 do If UserFile.Active[I] then begin
      ContinueDownload:=True;
      If Assigned(FOnDownload) then FOnDownload(self,C1+I,C1+C2,dsProgress,ContinueDownload);
      P:=InitPackageFile(UserFile[I],Update,UpdateAll,UpdateRemoteOnly,UpdateErrorQuite);
      If P<>nil then FPackageList.Add(P);
      If not ContinueDownload then break;
    end;
  finally
    If Assigned(FOnDownload) then FOnDownload(self,MainFile.Count+UserFile.Count,MainFile.Count+UserFile.Count,dsDone,ContinueDownload);
  end;
  result:=ContinueDownload;

  {Delete unused files}
  I:=FindFirst(DBDir+'*.xml',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        If not FileInUse(Rec.Name) then ExtDeleteFile(DBDir+Rec.Name,ftTemp);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function TPackageDB.LoadDB(const Update, UpdateAll, UpdateErrorQuite : Boolean) : Boolean;
Var MainFile, UserFile : TPackageListFile;
    B : Boolean;
begin
  Clear;
  result:=True;
  If not InitDBDir then exit;

  MainFile:=TPackageListFile.Create(True);
  try
    MainFile.LoadFromFile(DBDir+PackageDBMainFile);
    If Update
      then result:=MainFile.UpdateFromServer(Format(PackageDBMainFileURL,[GetNormalFileVersionAsString]),DBDir+PackageDBTempFile,UpdateAll,UpdateErrorQuite)
      else result:=True;
    UserFile:=TPackageListFile.Create(False);
    try
      UserFile.LoadFromFile(DBDir+PackageDBUserFile);
      B:=InitPackageFiles(MainFile,UserFile,result and Update,result and UpdateAll,False,UpdateErrorQuite);
      result:=result and B;
    finally
      UserFile.Free;
    end;
  finally
    MainFile.Free;
  end;
end;

procedure TPackageDB.UpdateRemoteFiles(const UpdateErrorQuite : Boolean);
Var MainFile, UserFile : TPackageListFile;
begin
  Clear;
  If not InitDBDir then exit;

  MainFile:=TPackageListFile.Create(True);
  try
    MainFile.LoadFromFile(DBDir+PackageDBMainFile);
    MainFile.UpdateFromServer(Format(PackageDBMainFileURL,[GetNormalFileVersionAsString]),DBDir+PackageDBTempFile,False,UpdateErrorQuite);
    UserFile:=TPackageListFile.Create(False);
    try
      UserFile.LoadFromFile(DBDir+PackageDBUserFile);
      InitPackageFiles(MainFile,UserFile,True,False,True,UpdateErrorQuite);
    finally
      UserFile.Free;
    end;
  finally
    MainFile.Free;
  end;
end;

Function TPackageDB.FindAndRemoveGame(const AGame : TDownloadZipData; const ParentForm : TForm) : Boolean;
Var I : Integer;
begin
  result:=True;
  For I:=0 to FPackageList.Count-1 do If TPackageList(FPackageList[I]).FindAndRemoveGame(AGame,ParentForm) then exit;
  result:=False;
end;

Function TPackageDB.FindAndRemoveAutoSetup(const AAutoSetup : TDownloadAutoSetupData; const ParentForm : TForm) : Boolean;
Var I : Integer;
begin
  result:=True;
  For I:=0 to FPackageList.Count-1 do If TPackageList(FPackageList[I]).FindAndRemoveAutoSetup(AAutoSetup,ParentForm) then exit;
  result:=False;
end;

Function TPackageDB.FindAndRemoveIcon(const AIcon : TDownloadIconData; const ParentForm : TForm) : Boolean;
Var I : Integer;
begin
  result:=True;
  For I:=0 to FPackageList.Count-1 do If TPackageList(FPackageList[I]).FindAndRemoveIcon(AIcon,ParentForm) then exit;
  result:=False;
end;

Function TPackageDB.FindAndRemoveIconSet(const AIconSet : TDownloadIconSetData; const ParentForm : TForm) : Boolean;
Var I : Integer;
begin
  result:=True;
  For I:=0 to FPackageList.Count-1 do If TPackageList(FPackageList[I]).FindAndRemoveIconSet(AIconSet,ParentForm) then exit;
  result:=False;
end;

Function TPackageDB.FindAndRemoveLanguage(const ALanguage : TDownloadLanguageData; const ParentForm : TForm) : Boolean;
Var I : Integer;
begin
  result:=True;
  For I:=0 to FPackageList.Count-1 do If TPackageList(FPackageList[I]).FindAndRemoveLanguage(ALanguage,ParentForm) then exit;
  result:=False;
end;

end.
