unit GameDBFilterUnit;
interface

uses Classes, GameDBUnit;

Type TFilterBase=class
  private
    FNotPrefix : Boolean;  
  protected
    Procedure ProcessStringList(const ASt : TStringList); virtual; abstract;
    property NotPrefix : Boolean read FNotPrefix write FNotPrefix;
  public
    Constructor Create(const ASt : TStringList; const ANotPrefix : Boolean);
    Function FilterOk(const AGame : TGame) : Boolean; virtual; abstract;
    Function Print(const Indent : String) : TStringList; virtual; abstract;
end;

Type TFilterType=(ftAll,ftName,ftGenre,ftDeveloper,ftPublisher,ftYear,ftNotes,ftWWW,ftLanguage,ftLicense,ftUserData);
Type TCompareType=(ftEqual,ftNotEqual,ftBigger,ftSmaller,ftBiggerOrEqual,ftSmallerOrEqual);
Type TSpecialProcessingType=(sptNone,sptNumber,sptGenre,sptLanguage,sptLicense);

Type TFilterElement=class(TFilterBase)
  private
    FFilterType : TFilterType;
    FFilterValueUpper : String;
    FFilterValueNumber : Integer;
    FFilterValueNumberOk : Boolean;
    FCompareType : TCompareType;
    FUserKeyUpper : String;
    function Compare(const GameValue : String; ProcessingType : TSpecialProcessingType = sptNone): Boolean;
    Function GetUserData(const AGame : TGame) : String;
  protected
    Procedure ProcessStringList(const ASt : TStringList); override;
  public
    Function FilterOk(const AGame : TGame) : Boolean; override;
    Function Print(const Indent : String) : TStringList; override;
end;

Type TFilterListType=(fltOr,fltAnd);

Type TFilterList=class(TFilterBase)
  private
    FFilterListType : TFilterListType;
    FList : TList;
  protected
    Procedure ProcessStringList(const ASt : TStringList); override;
  public
    Destructor Destroy; override;
    Function FilterOk(const AGame : TGame) : Boolean; override;
    Function Print(const Indent : String) : TStringList; override;
end;

Type TGamesListFilter=class
  private
    FFilter : TFilterList;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure SetFilterString(const S : String);
    Function FilterOk(const AGame : TGame) : Boolean;
    property Filter : TFilterList read FFilter;
end;

implementation

uses SysUtils, CommonTools, GameDBFilterToolsUnit, LanguageSetupUnit;

{ TFilterBase }

constructor TFilterBase.Create(const ASt : TStringList; const ANotPrefix : Boolean);
begin
  inherited Create;
  FNotPrefix:=ANotPrefix;
  ProcessStringList(ASt);
end;

{ TFilterElement }

procedure TFilterElement.ProcessStringList(const ASt: TStringList);
begin
  If ASt.Count=3 then begin
    FFilterType:=ftUserData;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameName)) or (ASt[0]='NAME') then FFilterType:=ftName;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameGenre)) or (ASt[0]='GENRE') then FFilterType:=ftGenre;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameDeveloper)) or (ASt[0]='DEVELOPER') then FFilterType:=ftDeveloper;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GamePublisher)) or (ASt[0]='PUBLISHER') then FFilterType:=ftPublisher;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameYear)) or (ASt[0]='YEAR') then FFilterType:=ftYear;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameNotes)) or (ASt[0]='NOTES') then FFilterType:=ftNotes;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameWWW)) or (ASt[0]='WWW') then FFilterType:=ftWWW;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameLanguage)) or (ASt[0]='LANGUAGE') then FFilterType:=ftLanguage;
    If (ASt[0]=ExtUpperCase(LanguageSetup.GameLicense)) or (ASt[0]='LICENSE') then FFilterType:=ftLicense;
    If FFilterType=ftUserData then FUserKeyUpper:=ASt[0];

    FCompareType:=ftEqual;
    If (ASt[1]='<>') or (ASt[1]='!=') or (ASt[1]='=!') then FCompareType:=ftNotEqual;
    If ASt[1]='>' then FCompareType:=ftBigger;
    If ASt[1]='<' then FCompareType:=ftSmaller;
    If (ASt[1]='>=') or (ASt[1]='=>') then FCompareType:=ftBiggerOrEqual;
    If (ASt[1]='<=') or (ASt[1]='=<') then FCompareType:=ftSmallerOrEqual;
  end else begin
    FFilterType:=ftAll;
    FCompareType:=ftEqual;
  end;
  If ASt.Count>0 then FFilterValueUpper:=ASt[ASt.Count-1] else FFilterValueUpper:='';
  FFilterValueNumberOk:=TryStrToInt(FFilterValueUpper,FFilterValueNumber);
end;

function TFilterElement.Compare(const GameValue : String; ProcessingType : TSpecialProcessingType): Boolean;
Function Contains(const S : String) : Boolean; begin result:=(Pos(FFilterValueUpper,S)>0); end;
Var GameValueNumber : Integer;
    B : Boolean;
    S : String;
begin
  If FFilterValueUpper='' then begin result:=True; exit; end;

  If (not FFilterValueNumberOk) and (ProcessingType=sptNumber) then ProcessingType:=sptNone;
  If ProcessingType=sptNumber then begin
    B:=TryStrToInt(GameValue,GameValueNumber);
    if not B then ProcessingType:=sptNone;
  end;

  If ProcessingType=sptNumber then begin
    Case FCompareType of
      ftEqual : result:=(FFilterValueNumber=GameValueNumber);
      ftNotEqual : result:=(FFilterValueNumber<>GameValueNumber);
      ftBigger : result:=(FFilterValueNumber<GameValueNumber);
      ftSmaller : result:=(FFilterValueNumber>GameValueNumber);
      ftBiggerOrEqual : result:=(FFilterValueNumber<=GameValueNumber);
      ftSmallerOrEqual : result:=(FFilterValueNumber>=GameValueNumber);
      else result:=(FFilterValueNumber=GameValueNumber);
    end;
    exit;
  end;

  If ProcessingType<>sptNone then begin
    Case ProcessingType of
      sptGenre : S:=GetCustomGenreName(GameValue);
      sptLanguage : S:=GetCustomLanguageName(GameValue);
      sptLicense : S:=GetCustomLicenseName(GameValue);
      else S:=GetCustomGenreName(GameValue);
    end;
    Case FCompareType of
      ftEqual,ftBiggerOrEqual,ftSmallerOrEqual : result:=Contains(ExtUpperCase(GameValue)) or Contains(ExtUpperCase(S));
      ftNotEqual,ftBigger,ftSmaller : result:=not (Contains(ExtUpperCase(GameValue)) or Contains(ExtUpperCase(S)));
      else result:=Contains(ExtUpperCase(GameValue)) or Contains(ExtUpperCase(S));
    end;
    exit;
  end;

  {if ProcessingType=sptNone: GameValue already upper cased by caller}
  Case FCompareType of
    ftEqual,ftBiggerOrEqual,ftSmallerOrEqual : result:=Contains(GameValue);
    ftNotEqual,ftBigger,ftSmaller : result:=not Contains(GameValue);
    else result:=Contains(GameValue);
  end;
end;

function TFilterElement.GetUserData(const AGame: TGame): String;
Var I : Integer;
    St : TStringList;
begin
  result:='';
  St:=StringToStringList(AGame.UserInfo);
  try
    For I:=0 to St.Count-1 do If ExtUpperCase(Copy(Trim(St[I]),1,8))=FUserKeyUpper+'=' then begin result:=Copy(Trim(St[I]),length(FUserKeyUpper)+2,MaxInt); break; end;
  finally
    St.Free;
  end;
end;

function TFilterElement.FilterOk(const AGame: TGame): Boolean;
Var St : TStringList;
begin
  Case FFilterType of
    ftAll       : begin
                    result:=not NotPrefix;
                    if Compare(AGame.CacheNameUpper) then exit;
                    if Compare(AGame.CacheGenre,sptGenre) then exit;
                    if Compare(AGame.CacheDeveloperUpper) then exit;
                    if Compare(AGame.CachePublisherUpper) then exit;
                    if Compare(AGame.CacheYearUpper,sptNumber) then exit;
                    if Compare(AGame.CacheLanguage,sptLanguage) then exit;
                    if Compare(AGame.License,sptLicense) then exit;
                    result:=NotPrefix;
                  end;
    ftName      : result:=NotPrefix xor Compare(AGame.CacheNameUpper);
    ftGenre     : result:=NotPrefix xor Compare(AGame.CacheGenre,sptGenre);
    ftDeveloper : result:=NotPrefix xor Compare(AGame.CacheDeveloperUpper);
    ftPublisher : result:=NotPrefix xor Compare(AGame.CachePublisherUpper);
    ftYear      : result:=NotPrefix xor Compare(AGame.CacheYearUpper,sptNumber);
    ftNotes     : begin St:=StringToStringList(AGame.Notes); try result:=NotPrefix xor Compare(St.Text); finally St.Free; end; end;
    ftWWW       : result:=NotPrefix xor (Compare(ExtUpperCase(AGame.WWW[1])) or Compare(ExtUpperCase(AGame.WWW[2])) or Compare(ExtUpperCase(AGame.WWW[3])) or Compare(ExtUpperCase(AGame.WWW[4])) or Compare(ExtUpperCase(AGame.WWW[5])) or Compare(ExtUpperCase(AGame.WWW[6])) or Compare(ExtUpperCase(AGame.WWW[7])) or Compare(ExtUpperCase(AGame.WWW[8])) or Compare(ExtUpperCase(AGame.WWW[9])));
    ftLanguage  : result:=NotPrefix xor Compare(AGame.CacheLanguage,sptLanguage);
    ftLicense   : result:=NotPrefix xor Compare(AGame.License,sptLicense);
    ftUserData  : result:=NotPrefix xor Compare(ExtUpperCase(GetUserData(AGame)));
    else result:=NotPrefix xor Compare(AGame.CacheNameUpper);
  end;
end;

function TFilterElement.Print(const Indent: String): TStringList;
Var S : String;
begin
  S:='"'+IntToStr(Integer(FFilterType))+'", "'+FFilterValueUpper+'", "'+IntToStr(Integer(FCompareType))+'"';
  If NotPrefix then S:='"not", '+S;
  result:=TStringList.Create;
  result.Add(Indent+'Element ('+S+')');
end;

{ TFilterList }

procedure TFilterList.ProcessStringList(const ASt: TStringList);
Var I : Integer;
    FilterList : TFilterList;
    FilterElement : TFilterElement;
begin
  FList:=TList.Create;

  If ASt.Count<2 then exit;
  If (ASt[0]<>'AND') and (ASt[0]<>'OR') then exit;
  If ASt[0]='AND' then FFilterListType:=fltAnd else FFilterListType:=fltOr;

  For I:=1 to ASt.Count-1 do begin
    If (ASt[I]='()') or (ASt[I]='!()') then begin
      FilterList:=TFilterList.Create(TStringList(ASt.Objects[I]),ASt[I]='!()');
      FList.Add(FilterList);
    end else begin
      FilterElement:=TFilterElement.Create(TStringList(ASt.Objects[I]),ASt[I]='!');
      FList.Add(FilterElement);
    end;
  end;
end;

destructor TFilterList.Destroy;
Var I : Integer;
begin
  For I:=0 to FList.Count-1 do TFilterBase(FList[I]).Free;
  FList.Free;
  inherited Destroy;
end;

function TFilterList.FilterOk(const AGame: TGame): Boolean;
Var I : Integer;
begin
  if FFilterListType=fltOr then begin
    result:=not NotPrefix;
    For I:=0 to FList.Count-1 do If TFilterBase(FList[I]).FilterOk(AGame) then exit;
    result:=NotPrefix;
  end else begin
    result:=NotPrefix;
    For I:=0 to FList.Count-1 do If not TFilterBase(FList[I]).FilterOk(AGame) then exit;
    result:=not NotPrefix;
  end;
end;

function TFilterList.Print(const Indent: String): TStringList;
Var S : String;
    I : Integer;
    St : TStringList;
begin
  result:=TStringList.Create;
  If FFilterListType=fltOr then S:='"or"' else S:='"and"';
  If FNotPrefix then S:='"not", '+S;
  result.Add(Indent+'List ('+S+')');
  For I:=0 to FList.Count-1 do begin
    St:=TFilterBase(FList[I]).Print(Indent+'  ');
    try result.AddStrings(St); finally St.Free; end;
  end;
end;

{ TGamesListFilter }

constructor TGamesListFilter.Create;
begin
  inherited Create;
  FFilter:=nil;
end;

destructor TGamesListFilter.Destroy;
begin
  if Assigned(FFilter) then FFilter.Free;
  inherited Destroy;
end;

function TGamesListFilter.FilterOk(const AGame: TGame): Boolean;
begin
  If Assigned(FFilter) then result:=FFilter.FilterOk(AGame) else result:=True;
end;

procedure TGamesListFilter.SetFilterString(const S: String);
Var St1,St2 : TStringList;
    OperatorNames : TLanguageLocalOperatorNames;
begin
  if Assigned(FFilter) then FreeAndNil(FFilter);

  OperatorNames.NameAnd:=LanguageSetup.SearchAnd;
  OperatorNames.NameOr:=LanguageSetup.SearchOr;
  OperatorNames.NameNot:=LanguageSetup.SearchNot;

  try
    St1:=nil; St2:=nil;
    try
      St1:=SplitSearchString(S);
      St2:=ProcessSearchElements(St1,OperatorNames); FreeNestedStringList(St1); St1:=nil;
      St1:=ProcessNotOperators(St2); FreeNestedStringList(St2); St2:=nil;
      St2:=ProcessSearchOperators1(St1); FreeNestedStringList(St1); St1:=nil;
      St1:=ProcessSearchOperators2(St2); FreeNestedStringList(St2); St2:=nil;
      St2:=ProcessQuotes(St1); FreeNestedStringList(St1); St1:=nil;
      FFilter:=TFilterList.Create(St2,False);
    finally
      If Assigned(St1) then FreeNestedStringList(St1);
      If Assigned(St2) then FreeNestedStringList(St2);
    end;
  except
    If Assigned(FFilter) then FreeAndNil(FFilter);
    St1:=TStringList.Create;
    try
      St1.Add(S); St2:=TStringList.Create;
      try
        St2.AddObject('',St1); FFilter:=TFilterList.Create(St2,False);
      finally St2.Free; end;
    finally St1.Free; end;
  end;
end;

end.
