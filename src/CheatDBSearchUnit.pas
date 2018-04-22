unit CheatDBSearchUnit;
interface

uses Classes;

Type TValueChangeType=(vctUp,vctDown);

Type TResultStatus=(rsNoResultsYet, rsNoAddress, rsFound, rsMultipleAddresses);

Type TAddressSearcher=class
  private
    FLastSavedGameFileName, FName : String;
    FCompleteFile : TMemoryStream;
    FAddressList, FAddressSizeList, FAddressLastValue : TList;
    FSearchDataFileName : String;
    Procedure SearchAddressWholeFile(const AMSt : TMemoryStream; const AValue : Integer);
    Procedure SearchAddressInList(const AMSt : TMemoryStream; const AValue : Integer);
    Procedure SearchAddressIndirectAgainstWholeFile(const AMSt : TMemoryStream; const AValueChangeType : TValueChangeType);
    Procedure SearchAddressIndirectAgainstAddressList(const AMSt : TMemoryStream; const AValueChangeType : TValueChangeType);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear(const AKeepName : Boolean);
    Function LoadFromFile(const AFileName : String) : Boolean;
    Procedure SaveToFile(const AFileName : String);
    Function LoadSavedGameFile(const ASavedGameFile : String) : Boolean;
    Procedure SearchAddress(const ASavedGameFile : String; const AValue : Integer);
    Procedure SearchAddressIndirect(const ASavedGameFile : String; const AValueChangeType : TValueChangeType);
    Function NoResults : Boolean;
    Function GetResult(var AAddress, ASize : Integer) : TResultStatus;
    Function GetResultNr(const ANr : Integer; var AAddress, ASize : Integer) : Boolean;
    Function GetList : TStringList;
    property Name : String read FName write FName;
    property LastSavedGameFileName : String read FLastSavedGameFileName write FLastSavedGameFileName;
    property SearchDataFileName : String read FSearchDataFileName;
end;

Procedure GetAddressSearchFiles(const AFiles, ANames : TStringList);
Function GetNewAddressSearchFile : String;

implementation

uses SysUtils, Math, PrgSetupUnit, PrgConsts, LanguageSetupUnit;

const DFRSearch='DFRAddressSearchFile';

Function SearchFileOK(const AFileName : String; var AName : String) : Boolean;
Var FSt : TFileStream;
    S : String;
    I : Integer;
begin
  result:=False;
  try
    FSt:=TFileStream.Create(AFileName,fmOpenRead);
    try
      If FSt.Size<length(DFRSearch)+4 then exit;
      SetLength(S,length(DFRSearch));
      FSt.ReadBuffer(S[1],length(DFRSearch));
      result:=(S=DFRSearch);
      If result then begin
        FSt.ReadBuffer(I,4);
        SetLength(AName,I); FSt.ReadBuffer(AName[1],I);
      end;
    finally
      FSt.Free;
    end;
  except
    result:=False; exit;
  end;
end;

Procedure GetAddressSearchFiles(const AFiles, ANames : TStringList);
Var I : Integer;
    Rec : TSearchRec;
    S : String;
begin
  I:=FindFirst(PrgDataDir+CheatDBSearchSubFolder+'\*.dat',faAnyFile,Rec);
  try
    While I=0 do begin
      If SearchFileOK(PrgDataDir+CheatDBSearchSubFolder+'\'+Rec.Name,S) then begin
        AFiles.Add(PrgDataDir+CheatDBSearchSubFolder+'\'+Rec.Name);
        ANames.Add(S);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetNewAddressSearchFile : String;
Var I : Integer;
begin
  I:=0;
  While FileExists(PrgDataDir+CheatDBSearchSubFolder+'\Search'+IntToStr(I)+'.dat') do inc(I);
  result:=PrgDataDir+CheatDBSearchSubFolder+'\Search'+IntToStr(I)+'.dat';
end;

{ TAddressSearcher }

constructor TAddressSearcher.Create;
begin
  inherited Create;
  FName:='';
  FLastSavedGameFileName:='';
  FCompleteFile:=nil;
  FAddressList:=nil;
  FAddressSizeList:=nil;
  FAddressLastValue:=nil;
  FSearchDataFileName:='';
end;

destructor TAddressSearcher.Destroy;
begin
  Clear(False);
  inherited Destroy;
end;

procedure TAddressSearcher.Clear(const AKeepName : Boolean);
begin
  If Assigned(FCompleteFile) then FreeAndNil(FCompleteFile);
  If Assigned(FAddressList) then FreeAndNil(FAddressList);
  If Assigned(FAddressSizeList) then FreeAndNil(FAddressSizeList);
  If Assigned(FAddressLastValue) then FreeAndNil(FAddressLastValue);
  If not AKeepName then begin FName:=''; FLastSavedGameFileName:=''; end;
end;

function TAddressSearcher.LoadFromFile(const AFileName: String): Boolean;
Var FSt : TFileStream;
    S : String;
    I,J,K : Integer;
    Mode : Byte;
begin
  result:=False;
  Clear(False);
  FSearchDataFileName:=AFileName;

  try
    FSt:=TFileStream.Create(AFileName,fmOpenRead);
    try
      If FSt.Size<length(DFRSearch)+5 then exit;
      SetLength(S,length(DFRSearch));
      FSt.ReadBuffer(S[1],length(DFRSearch));
      If S<>DFRSearch then exit;
      FSt.ReadBuffer(I,4); SetLength(FName,I); FSt.ReadBuffer(FName[1],I);
      FSt.ReadBuffer(I,4); SetLength(FLastSavedGameFileName,I); FSt.ReadBuffer(FLastSavedGameFileName[1],I);
      FSt.ReadBuffer(Mode,1);
      If Mode=0 then begin
        {Whole saved game stored}
        FCompleteFile:=TMemoryStream.Create;
        FCompleteFile.CopyFrom(FSt,FSt.Size-FSt.Position);
      end else begin
        {Load address list}
        FAddressList:=TList.Create;
        FAddressSizeList:=TList.Create;
        FAddressLastValue:=TList.Create;
        FSt.ReadBuffer(I,4);
        FAddressList.Capacity:=Max(FAddressList.Capacity,I);
        FAddressSizeList.Capacity:=Max(FAddressSizeList.Capacity,I);
        FAddressLastValue.Capacity:=Max(FAddressLastValue.Capacity,I);
        For J:=0 to I-1 do begin FSt.ReadBuffer(K,4); FAddressList.Add(Pointer(K)); end;
        For J:=0 to I-1 do begin FSt.ReadBuffer(K,4); FAddressSizeList.Add(Pointer(K)); end;
        For J:=0 to I-1 do begin FSt.ReadBuffer(K,4); FAddressLastValue.Add(Pointer(K)); end;
      end;
    finally
      FSt.Free;
    end;
  except
    result:=False; exit;
  end;
end;

procedure TAddressSearcher.SaveToFile(const AFileName: String);
Var FSt : TFileStream;
    S : String;
    I,J : Integer;
    Mode : Byte;
begin
  try
    If Trim(AFileName)='' then begin
      If Trim(FSearchDataFileName)='' then FSearchDataFileName:=GetNewAddressSearchFile;
      ForceDirectories(ExtractFilePath(FSearchDataFileName));
      FSt:=TFileStream.Create(FSearchDataFileName,fmCreate);
    end else begin
      ForceDirectories(ExtractFilePath(AFileName));
      FSt:=TFileStream.Create(AFileName,fmCreate);
    end;
    try
      S:=DFRSearch; FSt.WriteBuffer(S[1],length(DFRSearch));
      I:=length(FName); FSt.WriteBuffer(I,4); FSt.WriteBuffer(FName[1],length(FName));
      I:=length(FLastSavedGameFileName); FSt.WriteBuffer(I,4); FSt.WriteBuffer(FLastSavedGameFileName[1],length(FLastSavedGameFileName));
      If Assigned(FCompleteFile) then begin
        {Store whole saved game}
        Mode:=0; FSt.WriteBuffer(Mode,1);
        FSt.CopyFrom(FCompleteFile,0);
      end else begin
        {Store address list}
        Mode:=1; FSt.WriteBuffer(Mode,1);
        I:=FAddressList.Count; FSt.WriteBuffer(I,4);
        For I:=0 to FAddressList.Count-1 do begin J:=Integer(FAddressList[I]); FSt.WriteBuffer(J,4); end;
        For I:=0 to FAddressSizeList.Count-1 do begin J:=Integer(FAddressSizeList[I]); FSt.WriteBuffer(J,4); end;
        For I:=0 to FAddressLastValue.Count-1 do begin J:=Integer(FAddressLastValue[I]); FSt.WriteBuffer(J,4); end;
      end;
    finally
      FSt.Free;
    end;
  except
    exit;
  end;
end;

function TAddressSearcher.LoadSavedGameFile(const ASavedGameFile: String) : Boolean;
begin
  result:=False;
  Clear(True);

  If not FileExists(ASavedGameFile) then exit;
  FCompleteFile:=TMemoryStream.Create;
  try
    FCompleteFile.LoadFromFile(ASavedGameFile);
  except
    FreeAndNil(FCompleteFile); result:=False; exit;
  end;
  FLastSavedGameFileName:=ASavedGameFile;
  result:=True;
end;

procedure TAddressSearcher.SearchAddressWholeFile(const AMSt: TMemoryStream; const AValue: Integer);
Var Address : Integer;
Procedure AddAddress(const ASize : Integer); begin FAddressList.Add(Pointer(Address)); FAddressSizeList.Add(Pointer(ASize)); FAddressLastValue.Add(Pointer(AValue)); end;
Var I : Integer;
    W : Word;
    B : Byte;
begin
  For Address:=0 to AMSt.Size-4 do begin
    AMSt.Position:=Address;
    AMSt.ReadBuffer(I,4);
    If I=AValue then AddAddress(4);
  end;
  If (AValue div $10000)=0 then begin
    {Check word sized values}
    For Address:=0 to AMSt.Size-2 do begin
      AMSt.Position:=Address;
      AMSt.ReadBuffer(W,2);
      If W=AValue then AddAddress(2);
    end;
  end;
  If (AValue div $100)=0 then begin
    {Check byte sized values}
    For Address:=0 to AMSt.Size-1 do begin
      AMSt.Position:=Address;
      AMSt.ReadBuffer(B,1);
      If B=AValue then AddAddress(1);
    end;
  end;
end;

procedure TAddressSearcher.SearchAddressInList(const AMSt: TMemoryStream; const AValue: Integer);
Var I,J,S : Integer;
    W : Word;
    B : Byte;
begin
  I:=0;
  While I<FAddressList.Count do begin
    S:=Integer(FAddressSizeList[I]);
    If Integer(FAddressList[I])+S>AMSt.Size then begin
      FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I);
      continue;
    end;
    AMSt.Position:=Integer(FAddressList[I]);
    If S=4 then begin
      AMSt.ReadBuffer(J,4);
      If J=AValue then begin FAddressLastValue[I]:=Pointer(AValue); inc(I); end else begin FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I); end;
      continue;
    end;
    If S=2 then begin
      AMSt.ReadBuffer(W,2);
      If W=AValue then begin FAddressLastValue[I]:=Pointer(AValue); inc(I); end else begin FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I); end;
      continue;
    end;
    If S=1 then begin
      AMSt.ReadBuffer(B,1);
      If B=AValue then begin FAddressLastValue[I]:=Pointer(AValue); inc(I); end else begin FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I); end;
      continue;
    end;
  end;
end;

procedure TAddressSearcher.SearchAddress(const ASavedGameFile: String; const AValue: Integer);
Var MSt : TMemoryStream;
begin
  MSt:=TMemoryStream.Create;
  try
    try MSt.LoadFromFile(ASavedGameFile); except exit; end;
    If Assigned(FCompleteFile) then FreeAndNil(FCompleteFile); {Complete old file is useless on exact value search}
    If Assigned(FAddressList) then begin
      {Only search on already found addresses}
      SearchAddressInList(MSt,AValue);
    end else begin
      {Search whole file}
      FAddressList:=TList.Create;
      FAddressSizeList:=TList.Create;
      FAddressLastValue:=TList.Create;
      SearchAddressWholeFile(MSt,AValue);
    end;
  finally
    MSt.Free;
  end;
  FLastSavedGameFileName:=ASavedGameFile;
end;

procedure TAddressSearcher.SearchAddressIndirectAgainstWholeFile(const AMSt: TMemoryStream; const AValueChangeType: TValueChangeType);
Var Address : Integer;
Procedure SetAddress; begin AMSt.Position:=Address; FCompleteFile.Position:=Address; end;
Procedure AddAddress(const ASize, AValue : Integer); begin FAddressList.Add(Pointer(Address)); FAddressSizeList.Add(Pointer(ASize)); FAddressLastValue.Add(Pointer(AValue)); end;
Var I1,I2 : Integer;
    W1,W2 : Word;
    B1,B2 : Byte;
begin
  For Address:=0 to Min(FCompleteFile.Size,AMSt.Size)-4 do begin
    SetAddress;
    FCompleteFile.ReadBuffer(I1,4); AMSt.ReadBuffer(I2,4);
    If ((AValueChangeType=vctUp) and (I2>I1)) or ((AValueChangeType=vctDown) and (I2<I1)) then AddAddress(4,I2);
  end;
  For Address:=0 to Min(FCompleteFile.Size,AMSt.Size)-2 do begin
    SetAddress;
    FCompleteFile.ReadBuffer(W1,2); AMSt.ReadBuffer(W2,2);
    If ((AValueChangeType=vctUp) and (W2>W1)) or ((AValueChangeType=vctDown) and (W2<W1)) then AddAddress(2,W2);
  end;
  For Address:=0 to Min(FCompleteFile.Size,AMSt.Size)-1 do begin
    SetAddress;
    FCompleteFile.ReadBuffer(B1,1); AMSt.ReadBuffer(B2,1);
    If ((AValueChangeType=vctUp) and (B2>B1)) or ((AValueChangeType=vctDown) and (B2<B1)) then AddAddress(1,B2);
  end;
end;

procedure TAddressSearcher.SearchAddressIndirectAgainstAddressList(const AMSt: TMemoryStream; const AValueChangeType: TValueChangeType);
Var I,J,S,OldValue : Integer;
    W : Word;
    B : Byte;
begin
  I:=0;
  While I<FAddressList.Count do begin
    S:=Integer(FAddressSizeList[I]);
    OldValue:=Integer(FAddressLastValue[I]);
    If Integer(FAddressList[I])+S>AMSt.Size then begin
      FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I);
      continue;
    end;
    AMSt.Position:=Integer(FAddressList[I]);
    If S=4 then begin
      AMSt.ReadBuffer(J,4);
      If ((AValueChangeType=vctUp) and (J>OldValue)) or ((AValueChangeType=vctDown) and (J<OldValue)) then begin FAddressLastValue[I]:=Pointer(J); inc(I); end else begin FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I); end;
      continue;
    end;
    If S=2 then begin
      AMSt.ReadBuffer(W,2);
      If ((AValueChangeType=vctUp) and (W>OldValue)) or ((AValueChangeType=vctDown) and (W<OldValue)) then begin J:=W; FAddressLastValue[I]:=Pointer(J); inc(I); end else begin FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I); end;
      continue;
    end;
    If S=1 then begin
      AMSt.ReadBuffer(B,1);
      If ((AValueChangeType=vctUp) and (B>OldValue)) or ((AValueChangeType=vctDown) and (B<OldValue)) then begin J:=B; FAddressLastValue[I]:=Pointer(J); inc(I); end else begin FAddressList.Delete(I); FAddressSizeList.Delete(I); FAddressLastValue.Delete(I); end;
      continue;
    end;
  end;
end;

procedure TAddressSearcher.SearchAddressIndirect(const ASavedGameFile: String; const AValueChangeType: TValueChangeType);
Var MSt : TMemoryStream;
begin
  MSt:=TMemoryStream.Create;
  try
    try MSt.LoadFromFile(ASavedGameFile); except exit; end;
    If Assigned(FCompleteFile) then begin
      {Match changes against whole file}
      FAddressList:=TList.Create;
      FAddressSizeList:=TList.Create;
      FAddressLastValue:=TList.Create;
      SearchAddressIndirectAgainstWholeFile(MSt,AValueChangeType);
      FreeAndNil(FCompleteFile);
    end else begin
      {Match changes against adress list}
      SearchAddressIndirectAgainstAddressList(MSt,AValueChangeType);
    end;
  finally
    MSt.Free;
  end;
  FLastSavedGameFileName:=ASavedGameFile;
end;

function TAddressSearcher.NoResults: Boolean;
begin
  result:=not Assigned(FAddressList) or (FAddressList.Count=0);
end;

function TAddressSearcher.GetResult(var AAddress, ASize: Integer): TResultStatus;
Var I,MaxBytes,MaxNr : Integer;
begin
  If not Assigned(FAddressList) then begin result:=rsNoResultsYet; exit; end;
  If FAddressList.Count=0 then begin result:=rsNoAddress; exit; end;
  result:=rsMultipleAddresses;

  MaxNr:=0;
  MaxBytes:=Integer(FAddressSizeList[0]);
  For I:=1 to FAddressList.Count-1 do begin
    If Integer(FAddressList[0])<>Integer(FAddressList[I]) then exit;
    If Integer(FAddressSizeList[I])>MaxBytes then begin
      MaxNr:=I;
      MaxBytes:=Integer(FAddressSizeList[I]);
    end;
  end;

  result:=rsFound;
  AAddress:=Integer(FAddressList[MaxNr]);
  ASize:=MaxBytes;
end;

Function TAddressSearcher.GetResultNr(const ANr : Integer; var AAddress, ASize : Integer) : Boolean;
begin
  result:=False;
  if (not Assigned(FAddressList)) or (FAddressList.Count=0) or (ANr<0) or (ANr>=FAddressList.Count) then exit;
  ASize:=Integer(FAddressSizeList[ANr]);
  AAddress:=Integer(FAddressList[ANr]);
  result:=True;
end;

function TAddressSearcher.GetList: TStringList;
Var I : Integer;
    Addresses : TList;
begin
  result:=TStringList.Create;
  Addresses:=TList.Create;
  try
    For I:=0 to FAddressList.Count-1 do begin
      If Addresses.IndexOf(FAddressList[I])>=0 then continue;
      Addresses.Add(FAddressList[I]);
      result.AddObject(
        IntToHex(Integer(FAddressList[I]),1)+'h='+IntToStr(Integer(FAddressList[I]))+'d '+
        '('+IntToStr(Integer(FAddressSizeList[I]))+' '+LanguageSetup.Bytes+', '+
        LanguageSetup.SearchAddressResultMessageMultipleAddressesCurrentValue+': '+IntToStr(Integer(FAddressLastValue[I]))+')',TObject(I));
    end;
  finally
    Addresses.Free;
  end;
end;

end.
