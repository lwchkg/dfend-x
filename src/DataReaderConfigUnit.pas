unit DataReaderConfigUnit;
interface

uses Classes, XMLIntf;

Type THTMLStructureElement=class(TObject)
  protected
    FLoadOK : Boolean;
  public
    Constructor Create;
    property LoadOK : Boolean read FLoadOK;
end;

Type TLink=class(THTMLStructureElement)
  private
    FAttributeKey, FAttributeValue : String;
    FNr : Integer;
    FHrefSubstring : String;
  public
    Constructor Create(const Node : IXMLNode);
    property AttributeKey : String read FAttributeKey;
    property AttributeValue : String read FAttributeValue;
    property Nr : Integer read FNr;
    property HrefSubstring : String read FHrefSubstring;
end;

Type TImg=class(THTMLStructureElement)
  private
    FAttributeKey, FAttributeValue : String;
    FNr : Integer;
  public
    Constructor Create(const Node : IXMLNode);
    property AttributeKey : String read FAttributeKey;
    property AttributeValue : String read FAttributeValue;
    property Nr : Integer read FNr;
end;

Type TElementWithSub=class(THTMLStructureElement)
  private
    FChild : THTMLStructureElement;
    FChildren : TList;
    function GetChildCount: Integer;
    function GetChildren(I: Integer): THTMLStructureElement;
  public
    Constructor Create(const Node : IXMLNode; const AllowMultipleChildren : Boolean);
    Destructor Destroy; override;
    property Child : THTMLStructureElement read FChild;
    property ChildCount : Integer read GetChildCount;
    property Children[I : Integer] : THTMLStructureElement read GetChildren;
end;

Type TElement=class(TElementWithSub)
  private
    FElementType, FAttributeKey, FAttributeValue, FContainsText : String;
    FNr : Integer;
  public
    Constructor Create(const Node : IXMLNode; const AllowMultipleChildren : Boolean);
    property ElementType : String read FElementType;
    property AttributeKey : String read FAttributeKey;
    property AttributeValue : String read FAttributeValue;
    property Nr : Integer read FNr;
    property ContainsText : String read FContainsText;
end;

Type TJavascript=class(THTMLStructureElement)
  private
    FContainsText : String;
  public
    Constructor Create(const Node : IXMLNode);
    property ContainsText : String read FContainsText;
end;

Type TPerGameBlock=class(TElementWithSub)
  private
    FElementType, FAttributeKey, FAttributeValue : String;
  public
    Constructor Create(const Node : IXMLNode);
    property ElementType : String read FElementType;
    property AttributeKey : String read FAttributeKey;
    property AttributeValue : String read FAttributeValue;
end;

Type TSearchGameData=class(THTMLStructureElement)
  private
    FGenre, FDeveloper, FPublisher, FYear, FNotes : String;
    FIgnoreTags, FStartTokens, FStoppTokens : TStringList;
  public
    Constructor Create(const Node : IXMLNode);
    Destructor Destroy; override;
    property Genre : String read FGenre;
    property Developer : String read FDeveloper;
    property Publisher : String read FPublisher;
    property Year : String read FYear;
    property Notes : String read FNotes;
    property IgnoreTags : TStringList read FIgnoreTags;
    property StartTokens : TStringList read FStartTokens;
    property StoppTokens : TStringList read FStoppTokens;
end;

Type TDataReaderConfig=class
  private
    FConfigOK : Boolean;
    FConfigFile : String;
    FVersion : Integer;
    FGamesListURL, FGamesListAllPlatformsURL, FGameRecordBaseURL, FCoverRecordBaseURL : String;
    FGamesList, FGameRecord, FCoverRecord : THTMLStructureElement;
  public
    Constructor Create(const AConfigFile : String);
    Destructor Destroy; override;
    property ConfigOK : Boolean read FConfigOK;
    property ConfigFile : String read FConfigFile;
    property Version : Integer read FVersion;
    property GamesListURL : String read FGamesListURL;
    property GamesListAllPlatformsURL : String read FGamesListAllPlatformsURL;
    property GamesList : THTMLStructureElement read FGamesList;
    property GameRecordBaseURL : String read FGameRecordBaseURL;
    property GameRecord : THTMLStructureElement read FGameRecord;
    property CoverRecordBaseURL : String read FCoverRecordBaseURL;
    property CoverRecord : THTMLStructureElement read FCoverRecord;
end;

implementation

uses SysUtils, XMLDom, XMLDoc, MSXMLDOM, CommonTools, PackageDBToolsUnit;

{ global }

Function HTMLStructElementFromXMLNode(const Node : IXMLNode; const AllowMultipleChildrenInNextLevel : Boolean) : THTMLStructureElement; overload;
Var N : IXMLNode;
begin
  result:=nil;
  If Node.ChildNodes.Count<>1 then exit;
  N:=Node.ChildNodes[0];
  If N.NodeName='Element' then result:=TElement.Create(N,AllowMultipleChildrenInNextLevel);
  If N.NodeName='PerGameBlock' then result:=TPerGameBlock.Create(N);
  If N.NodeName='Link' then result:=TLink.Create(N);
  If N.NodeName='Img' then result:=TImg.Create(N);
  If N.NodeName='Javascript' then result:=TJavascript.Create(N);
  If Assigned(result) then begin
    If not result.LoadOK then FreeAndNil(result);
  end;
end;

Function HTMLStructElementFromXMLNode(const Node : IXMLNode; const List : TList) : Boolean; overload;
Var N : IXMLNode;
    I : Integer;
    E : THTMLStructureElement;
begin
  result:=False;
  For I:=0 to Node.ChildNodes.Count-1 do begin
    N:=Node.ChildNodes[I];
    E:=nil;
    If N.NodeName='Element' then E:=TElement.Create(N,True);
    If N.NodeName='PerGameBlock' then E:=TPerGameBlock.Create(N);
    If N.NodeName='Link' then E:=TLink.Create(N);
    If N.NodeName='SearchGameData' then E:=TSearchGameData.Create(N);
    if E=nil then exit else List.Add(E);
  end;
  result:=True;
end;

{ THTMLStructureElement }

constructor THTMLStructureElement.Create;
begin
  inherited Create;
  FLoadOK:=True;
end;

{ TLink }

constructor TLink.Create(const Node: IXMLNode);
begin
  inherited Create;

  If Node.HasAttribute('Key') then FAttributeKey:=Node.Attributes['Key'] else FAttributeKey:='';
  If Node.HasAttribute('Value') then FAttributeValue:=Node.Attributes['Value'] else FAttributeValue:='';
  If Node.HasAttribute('Nr') then begin FLoadOK:=TryStrToInt(Node.Attributes['Nr'],FNr); If not FLoadOK then exit; end else FNr:=0;
  If Node.HasAttribute('HrefSubstring') then FHrefSubstring:=Node.Attributes['HrefSubstring'] else FHrefSubstring:='';
end;

{ TImg }

constructor TImg.Create(const Node: IXMLNode);
begin
  inherited Create;

  If Node.HasAttribute('Key') then FAttributeKey:=Node.Attributes['Key'] else FAttributeKey:='';
  If Node.HasAttribute('Value') then FAttributeValue:=Node.Attributes['Value'] else FAttributeValue:='';
  If Node.HasAttribute('Nr') then begin FLoadOK:=TryStrToInt(Node.Attributes['Nr'],FNr); If not FLoadOK then exit; end else FNr:=0;
end;

{ TElementWithSub }

constructor TElementWithSub.Create(const Node: IXMLNode; const AllowMultipleChildren : Boolean);
begin
  inherited Create;
  FChildren:=TList.Create;
  If AllowMultipleChildren then begin
    FLoadOK:=HTMLStructElementFromXMLNode(Node,FChildren);
  end else begin
    FChild:=HTMLStructElementFromXMLNode(Node,False); FChildren.Add(FChild);
    FLoadOK:=(FChild<>nil);
  end;
end;

destructor TElementWithSub.Destroy;
Var I : Integer;
begin
  For I:=0 to FChildren.Count-1 do THTMLStructureElement(FChildren[I]).Free;
  FChildren.Free;
  inherited Destroy;
end;

function TElementWithSub.GetChildCount: Integer;
begin
  result:=FChildren.Count;
end;

function TElementWithSub.GetChildren(I: Integer): THTMLStructureElement;
begin
  If (I<0) or (I>=FChildren.Count) then result:=nil else result:=THTMLStructureElement(FChildren[I]);
end;

{ TElement }

constructor TElement.Create(const Node: IXMLNode; const AllowMultipleChildren : Boolean);
begin
  inherited Create(Node,AllowMultipleChildren);
  If not LoadOK then exit;

  If Node.HasAttribute('Type') then FElementType:=Node.Attributes['Type'] else FElementType:='';
  If Node.HasAttribute('Key') then FAttributeKey:=Node.Attributes['Key'] else FAttributeKey:='';
  If Node.HasAttribute('Value') then FAttributeValue:=Node.Attributes['Value'] else FAttributeValue:='';
  If Node.HasAttribute('Nr') then begin FLoadOK:=TryStrToInt(Node.Attributes['Nr'],FNr); If not FLoadOK then exit; end else FNr:=0;
  If Node.HasAttribute('ContainsText') then FContainsText:=Node.Attributes['ContainsText'] else FContainsText:='';
end;

{ TJavascript }

constructor TJavascript.Create(const Node: IXMLNode);
begin
  inherited Create;

  If Node.HasAttribute('ContainsText') then FContainsText:=Node.Attributes['ContainsText'] else FContainsText:='';
end;

{ TPerGameBlock }

constructor TPerGameBlock.Create(const Node: IXMLNode);
begin
  inherited Create(Node,False);
  If not LoadOK then exit;

  If Node.HasAttribute('Type') then FElementType:=Node.Attributes['Type'] else FElementType:='';
  If Node.HasAttribute('Key') then FAttributeKey:=Node.Attributes['Key'] else FAttributeKey:='';
  If Node.HasAttribute('Value') then FAttributeValue:=Node.Attributes['Value'] else FAttributeValue:='';
end;

{ TSearchGameData }

constructor TSearchGameData.Create(const Node: IXMLNode);
begin
  inherited Create;

  If Node.HasAttribute('Genre') then FGenre:=Node.Attributes['Genre'] else FGenre:='';
  If Node.HasAttribute('Developer') then FDeveloper:=Node.Attributes['Developer'] else FDeveloper:='';
  If Node.HasAttribute('Publisher') then FPublisher:=Node.Attributes['Publisher'] else FPublisher:='';
  If Node.HasAttribute('Year') then FYear:=Node.Attributes['Year'] else FYear:='';
  If Node.HasAttribute('Notes') then FNotes:=Node.Attributes['Notes'] else FNotes:='';

  If Node.HasAttribute('IgnoreTags') then begin
    FIgnoreTags:=ValueToList(Node.Attributes['IgnoreTags']);
  end else begin
    FIgnoreTags:=TStringList.Create;
  end;

    If Node.HasAttribute('StartTokens') then begin
    FStartTokens:=ValueToList(Node.Attributes['StartTokens']);
  end else begin
    FStartTokens:=TStringList.Create;
  end;

  If Node.HasAttribute('StoppTokens') then begin
    FStoppTokens:=ValueToList(Node.Attributes['StoppTokens']);
  end else begin
    FStoppTokens:=TStringList.Create;
  end;
end;

Destructor TSearchGameData.Destroy;
begin
  FIgnoreTags.Free;
  FStartTokens.Free;
  FStoppTokens.Free;
  inherited Destroy;
end;

{ TDataReaderConfig }

constructor TDataReaderConfig.Create(const AConfigFile: String);
Var XMLDoc : TXMLDocument;
    N : IXMLNode;
    I : Integer;
begin
  inherited Create;
  FConfigOK:=False;
  FConfigFile:=AConfigFile;
  FVersion:=0;
  FGamesListURL:='';
  FGamesListAllPlatformsURL:='';
  FGamesList:=nil;
  FGameRecordBaseURL:='';
  FGameRecord:=nil;
  FCoverRecordBaseURL:='';
  FCoverRecord:=nil;

  XMLDoc:=LoadXMLDoc(FConfigFile,FConfigFile); if XMLDoc=nil then exit;
  try
    If XMLDoc.DocumentElement.NodeName<>'DataReader' then exit;
    If not XMLDoc.DocumentElement.HasAttribute('Version') then exit;
    if not TryStrToInt(XMLDoc.DocumentElement.Attributes['Version'],FVersion) then exit;

    For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
      N:=XMLDoc.DocumentElement.ChildNodes[I];
      If N.NodeName='GamesList' then begin
        If Assigned(FGamesList) then exit;
        If N.HasAttribute('URL') then FGamesListURL:=N.Attributes['URL'] else exit;
        FGamesList:=HTMLStructElementFromXMLNode(N,True); If FGamesList=nil then exit;
        If N.HasAttribute('AllPlatformsURL')
          then FGamesListAllPlatformsURL:=N.Attributes['AllPlatformsURL']
          else FGamesListAllPlatformsURL:=FGamesListURL;
      end;
      If N.NodeName='GamePage' then begin
        If Assigned(FGameRecord) then exit;
        If N.HasAttribute('URL') then FGameRecordBaseURL:=N.Attributes['URL'] else exit;
        FGameRecord:=HTMLStructElementFromXMLNode(N,True); If FGameRecord=nil then exit;
      end;
      If N.NodeName='CoverPage' then begin
        If Assigned(FCoverRecord) then exit;
        If N.HasAttribute('URL') then FCoverRecordBaseURL:=N.Attributes['URL'] else exit;
        FCoverRecord:=HTMLStructElementFromXMLNode(N,False); If FCoverRecord=nil then exit;
      end;
    end;
    FConfigOK:=Assigned(FGamesList) and Assigned(FGameRecord) and Assigned(FCoverRecord);
  finally
    XMLDoc.Free;
  end;
  FConfigOK:=True;
end;

destructor TDataReaderConfig.Destroy;
begin
  If Assigned(FGamesList) then FGamesList.Free;
  If Assigned(FGameRecord) then FGameRecord.Free;
  If Assigned(FCoverRecord) then FCoverRecord.Free;
  inherited Destroy;
end;

end.
