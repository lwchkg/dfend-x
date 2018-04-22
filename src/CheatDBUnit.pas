unit CheatDBUnit;
interface

uses Classes, Forms, XMLIntf;

{DEFINE DebugCheatDB}

Type TIntegerArray=Array of Integer;

Type TCheatBaseClass=class
  private
    FOwner : TCheatBaseClass;
  public
    Constructor Create(const AOwner : TCheatBaseClass);
    Procedure SetChanged; virtual;
    property Owner : TCheatBaseClass read FOwner write FOwner;
end;

Type TCheatActionStep=class(TCheatBaseClass)
  protected
    class Function GetXMLNodeName : String; virtual; abstract;
  public
    Constructor Create(const AOwner : TCheatBaseClass); virtual;
    Function LoadFromXML(const XML : IXMLNode) : Boolean; virtual; abstract;
    Procedure SaveToXML(const XML : IXMLNode); virtual; abstract;
    Procedure CopyFrom(const ACheatActionStep : TCheatActionStep); virtual; abstract;
    Function Apply(const St : TFileStream) : Boolean; virtual; abstract;
    property XMLNodeName : String read GetXMLNodeName;
end;

Type TCheatActionStepClass=class of TCheatActionStep;

Type TCheatActionStepChangeAddress=class(TCheatActionStep)
  {<ChangeAddress Addresses="..." Bytes="..." NewValue="..."/>}
  private
    FAddresses, FNewValue : String;
    FAddressesInt : TIntegerArray;
    FBytes, FNewValueInt : Integer;
    Procedure SetString(Index : Integer; const S : String);
    procedure SetBytes(const Value: Integer);
  protected
    class Function GetXMLNodeName : String; override;
  public
    Constructor Create(const AOwner : TCheatBaseClass); override;
    Function LoadFromXML(const XML : IXMLNode) : Boolean; override;
    Procedure SaveToXML(const XML : IXMLNode); override;
    Procedure CopyFrom(const ACheatActionStep : TCheatActionStep); override;
    Function Apply(const St : TFileStream) : Boolean; override;
    property Addresses : String index 0 read FAddresses write SetString;
    property Bytes : Integer read FBytes write SetBytes;
    property NewValue : String index 1 read FNewValue write SetString;
end;

Type TCheatActionStepChangeAddressWithDialog=class(TCheatActionStep)
  {<ChangeAddressWithDialog Addresses="..." Bytes="..." DefaultValue="..."/DefaultValueAddress="..." Prompt="..." [MinValue="..."] [MaxValue="..."]/>}
  private
    FAddresses, FDefaultValue, FDefaultValueAddress, FPrompt, FMinValue, FMaxValue : String;
    FAddressesInt : TIntegerArray;
    FBytes, FDefaultValueAddressInt, FMinValueInt, FMaxValueInt : Integer;
    Procedure SetString(Index : Integer; const S : String);
    procedure SetBytes(const Value: Integer);
  protected
    class Function GetXMLNodeName : String; override;
  public
    Constructor Create(const AOwner : TCheatBaseClass); override;
    Function LoadFromXML(const XML : IXMLNode) : Boolean; override;
    Procedure SaveToXML(const XML : IXMLNode); override;
    Procedure CopyFrom(const ACheatActionStep : TCheatActionStep); override;
    Function Apply(const St : TFileStream) : Boolean; override;
    property Addresses : String index 0 read FAddresses write SetString;
    property Bytes : Integer read FBytes write SetBytes;
    property DefaultValue : String index 1 read FDefaultValue write SetString;
    property DefaultValueAddress : String index 2 read FDefaultValueAddress write SetString;
    property DialogPrompt : String read FPrompt write FPrompt;
    property MinValue : String index 3 read FMinValue write SetString;
    property MaxValue : String index 4 read FMaxValue write SetString;
end;

Type TCheatActionStepInternal=class(TCheatActionStep)
  {<Internal Nr="..."/>}
  private
    FNr : Integer;
    procedure SetNr(const Value: Integer);
  protected
    class Function GetXMLNodeName : String; override;
  public
    Constructor Create(const AOwner : TCheatBaseClass); override;
    Function LoadFromXML(const XML : IXMLNode) : Boolean; override;
    Procedure SaveToXML(const XML : IXMLNode); override;
    Procedure CopyFrom(const ACheatActionStep : TCheatActionStep); override;
    Function Apply(const St : TFileStream) : Boolean; override;
    property Nr : Integer read FNr write SetNr;
end;

Type TCheatAction=class(TCheatBaseClass)
  {<Action Name="..." FileMask="..."> ... </Action>}
  private
    FName, FFileMask : String;
    FActionSteps : TList;
    Procedure SetString(Index : Integer; const S : String);
    Function GetCount : Integer;
    function GetActionStep(I: Integer): TCheatActionStep;
  public
    Constructor Create(const AOwner : TCheatBaseClass);
    Destructor Destroy; override;
    Function LoadFromXML(const XML : IXMLNode) : Boolean;
    Procedure SaveToXML(const XML : IXMLNode);
    Procedure CopyFrom(const ACheatAction : TCheatAction);
    Function Apply(const St : TFileStream) : Boolean; overload;
    Function Apply(const FileName : String; const BackupBefore : Boolean) : Boolean; overload;
    Function Add(const ACheatActionStep : TCheatActionStep) : Integer;
    Procedure Delete(const Nr : Integer); overload;
    Procedure Delete(const ACheatActionStep : TCheatActionStep); overload;
    Procedure Clear;
    Function IndexOf(const ACheatActionStep : TCheatActionStep) : Integer;
    Function SetNewActionStep(const ACheatActionStep : TCheatActionStep; const APosition : Integer) : Boolean;
    Procedure CompressActionSteps;
    property Name : String index 0 read FName write SetString;
    property FileMask : String index 1 read FFileMask write SetString;
    property Count : Integer read GetCount;
    property ActionStep[I : Integer] : TCheatActionStep read GetActionStep; default;
end;

Type TCheatGameRecord=class(TCheatBaseClass)
  {<GameRecord Name="..."> ... </GameRecord>}
  private
    FName : String;
    FActions : TList;
    function GetAction(I: Integer): TCheatAction;
    function GetCount: Integer;
    procedure SetName(const Value: String);
  public
    Constructor Create(const AOwner : TCheatBaseClass);
    Destructor Destroy; override;
    Function LoadFromXML(const XML : IXMLNode) : Boolean;
    Procedure SaveToXML(const XML : IXMLNode);
    Procedure CopyFrom(const ACheatGameRecord : TCheatGameRecord);
    Function Add(const ACheatAction : TCheatAction) : Integer;
    Procedure Delete(const Nr : Integer); overload;
    Procedure Delete(const ACheatAction : TCheatAction); overload;
    Procedure Clear;
    Function IndexOf(const ACheatAction : TCheatAction) : Integer; overload;
    Function IndexOf(const ACheatActionName : String) : Integer; overload;
    Procedure CompressActionSteps;
    property Name : String read FName write SetName;
    property Count : Integer read GetCount;
    property Action[I : Integer] : TCheatAction read GetAction; default;
end;

Type TCheatDB=class(TCheatBaseClass)
  {<CheatDB> ... </CheatDB>}
  private
    FGameRecords : TList;
    FChanged : Boolean;
    FVersion : Integer;
    function GetCount: Integer;
    function GetGameRecord(I: Integer): TCheatGameRecord;
    procedure SetVersion(const Value: Integer);
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadFromXML(const FileName : String) : Boolean;
    Procedure SaveToXML(const FileName : String; const ParentForm : TForm);
    Function Add(const AGameRecord : TCheatGameRecord) : Integer;
    Procedure Delete(const Nr : Integer); overload;
    Procedure Delete(const AGameRecord : TCheatGameRecord); overload;
    Procedure Clear;
    Function IndexOf(const AGameRecord : TCheatGameRecord) : Integer; overload;
    Function IndexOf(const AGameName : String) : Integer; overload;
    Procedure SetChanged; override;
    Procedure CompressActionSteps;
    property Count : Integer read GetCount;
    property Game[I : Integer] : TCheatGameRecord read GetGameRecord; default;
    property Changed : Boolean read FChanged write FChanged;
    property Version : Integer read FVersion write SetVersion;
end;

implementation

uses SysUtils, XMLDoc, MSXMLDOM, Dialogs, Math, CheatDBToolsUnit, PrgConsts,
     CheatDBInternalUnit, PackageDBToolsUnit, LanguageSetupUnit;

{ global }

Var CheatActionStepClasses : Array of TCheatActionStepClass;

Procedure RegisterCheatActionStep(const CheatActionStepClass : TCheatActionStepClass);
Var I : Integer;
begin
  I:=length(CheatActionStepClasses); SetLength(CheatActionStepClasses,I+1);
  CheatActionStepClasses[I]:=CheatActionStepClass;
end;

Procedure RegisterCheatActionSteps;
begin
  RegisterCheatActionStep(TCheatActionStepChangeAddress);
  RegisterCheatActionStep(TCheatActionStepChangeAddressWithDialog);
  RegisterCheatActionStep(TCheatActionStepInternal);
end;

{ TCheatBaseClass }

constructor TCheatBaseClass.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create;
  FOwner:=AOwner;
end;

procedure TCheatBaseClass.SetChanged;
begin
  If FOwner<>nil then FOwner.SetChanged;
end;

{ TCheatActionStep }

constructor TCheatActionStep.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create(AOwner);
end;

{ TCheatActionStepChangeAddress }

constructor TCheatActionStepChangeAddress.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create(AOwner);
  SetLength(FAddressesInt,0);
  FBytes:=-1;
end;

class function TCheatActionStepChangeAddress.GetXMLNodeName: String;
begin
  result:='ChangeAddress';
end;

procedure TCheatActionStepChangeAddress.SetString(Index: Integer; const S: String);
Var I : Integer;
begin
  Case Index of
    0 : begin
          If FAddresses=S then exit;
          If not LoadAddresses(S,FAddressesInt) then exit;
          FAddresses:=S;
        end;
    1 : begin
          If FNewValue=S then exit;
          if not ExtTryStrToInt(S,I) then exit;
          FNewValue:=S; FNewValueInt:=I;
        end;
  end;
  SetChanged;
end;

procedure TCheatActionStepChangeAddress.SetBytes(const Value: Integer);
begin
  If (Value<>1) and (Value<>2) and (Value<>4) then exit;
  If Value=FBytes then exit;
  FBytes:=Value;
  SetChanged;
end;

function TCheatActionStepChangeAddress.LoadFromXML(const XML: IXMLNode) : Boolean;
begin
  result:=False;
  If XML.NodeName<>'ChangeAddress' then exit;
  If (not XML.HasAttribute('Addresses')) or (not XML.HasAttribute('Bytes')) or (not XML.HasAttribute('NewValue')) then exit;

  FAddresses:=XML.Attributes['Addresses']; if not LoadAddresses(FAddresses,FAddressesInt) then exit;
  if not ExtTryStrToInt(XML.Attributes['Bytes'],FBytes) then exit;
  If (FBytes<1) or (FBytes>4) or (FBytes=3) then exit;
  FNewValue:=XML.Attributes['NewValue']; if not ExtTryStrToInt(FNewValue,FNewValueInt) then exit;
  result:=True;
end;

procedure TCheatActionStepChangeAddress.SaveToXML(const XML: IXMLNode);
Var N : IXMLNode;
begin
  N:=XML.AddChild('ChangeAddress');
  N.Attributes['Addresses']:=FAddresses;
  N.Attributes['Bytes']:=IntToStr(FBytes);
  N.Attributes['NewValue']:=FNewValue;
end;

Procedure TCheatActionStepChangeAddress.CopyFrom(const ACheatActionStep : TCheatActionStep);
begin
  if not (ACheatActionStep is TCheatActionStepChangeAddress) then exit;
  FAddresses:=TCheatActionStepChangeAddress(ACheatActionStep).Addresses;
  FNewValue:=TCheatActionStepChangeAddress(ACheatActionStep).NewValue;
  FAddressesInt:=TCheatActionStepChangeAddress(ACheatActionStep).FAddressesInt;
  FBytes:=TCheatActionStepChangeAddress(ACheatActionStep).Bytes;
  FNewValueInt:=TCheatActionStepChangeAddress(ACheatActionStep).FNewValueInt;
end;

Function TCheatActionStepChangeAddress.Apply(const St: TFileStream) : Boolean;
Var I : Integer;
begin
  result:=False;
  If FBytes<0 then exit;

  For I:=0 to length(FAddressesInt)-1 do begin
    If not ExtSeek(St,FAddressesInt[I],FBytes) then exit;
    St.WriteBuffer(FNewValueInt,FBytes); {lower order byte first so it's ok just to write the first FBytesInt Bytes}
  end;

  result:=True;
end;

{ TCheatActionStepChangeAddressWithDialog }

constructor TCheatActionStepChangeAddressWithDialog.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create(AOwner);
  SetLength(FAddressesInt,0);
  FBytes:=-1;
  FDefaultValueAddressInt:=-1;
  FMinValueInt:=-1;
  FMaxValueInt:=-1;
end;

class function TCheatActionStepChangeAddressWithDialog.GetXMLNodeName: String;
begin
  result:='ChangeAddressWithDialog';
end;

procedure TCheatActionStepChangeAddressWithDialog.SetString(Index: Integer; const S: String);
Var I : Integer;
begin
  Case Index of
    0 : begin
          If FAddresses=S then exit;
          If not LoadAddresses(S,FAddressesInt) then exit;
          FAddresses:=S;
        end;
    1 : If FDefaultValue=S then exit else begin FDefaultValue:=S; FDefaultValueAddress:=''; FDefaultValueAddressInt:=-1; end;
    2 : If (FDefaultValueAddress=S) or (not ExtTryStrToInt(S,I)) then exit else begin FDefaultValueAddress:=S; FDefaultValueAddressInt:=I; FDefaultValue:=''; end;
    3 : begin
          If FMinValue=S then exit;
          If Trim(S)='' then begin FMinValueInt:=-1; FMinValue:=''; end else begin
            If not ExtTryStrToInt(S,I) then exit;
            FMinValue:=S; FMinValueInt:=I;
          end;
        end;
    4 : begin
          If FMaxValue=S then exit;
          If Trim(S)='' then begin FMaxValueInt:=-1; FMaxValue:=''; end else begin
            If not ExtTryStrToInt(S,I) then exit;
            FMaxValue:=S; FMaxValueInt:=I;
          end;
        end;
  end;
  SetChanged;
end;

procedure TCheatActionStepChangeAddressWithDialog.SetBytes(const Value: Integer);
begin
  If (Value<>1) and (Value<>2) and (Value<>4) then exit;
  If Value=FBytes then exit;
  FBytes:=Value;
  SetChanged;
end;

function TCheatActionStepChangeAddressWithDialog.LoadFromXML(const XML: IXMLNode): Boolean;
begin
  result:=False;
  If XML.NodeName<>'ChangeAddressWithDialog' then exit;
  If (not XML.HasAttribute('Addresses')) or (not XML.HasAttribute('Bytes')) or (not XML.HasAttribute('Prompt')) then exit;
  If (not XML.HasAttribute('DefaultValue')) and (not XML.HasAttribute('DefaultValueAddress')) then exit;

  FAddresses:=XML.Attributes['Addresses']; if not LoadAddresses(FAddresses,FAddressesInt) then exit;
  if not ExtTryStrToInt(XML.Attributes['Bytes'],FBytes) then exit;
  If (FBytes<1) or (FBytes>4) or (FBytes=3) then exit;
  If XML.HasAttribute('DefaultValue') then begin
    FDefaultValue:=XML.Attributes['DefaultValue'];
  end else begin
    FDefaultValueAddress:=XML.Attributes['DefaultValueAddress']; if not ExtTryStrToInt(FDefaultValueAddress,FDefaultValueAddressInt) then exit;
  end;
  FPrompt:=XML.Attributes['Prompt'];
  If XML.HasAttribute('MinValue') then begin
    FMinValue:=XML.Attributes['MinValue']; if not ExtTryStrToInt(FMinValue,FMinValueInt) then exit;
  end;
  If XML.HasAttribute('MaxValue') then begin
    FMaxValue:=XML.Attributes['MaxValue']; if not ExtTryStrToInt(FMaxValue,FMaxValueInt) then exit;
  end;
  result:=True;
end;

procedure TCheatActionStepChangeAddressWithDialog.SaveToXML(const XML: IXMLNode);
Var N : IXMLNode;
begin
  N:=XML.AddChild('ChangeAddressWithDialog');
  N.Attributes['Addresses']:=FAddresses;
  N.Attributes['Bytes']:=IntToStr(FBytes);
  If FDefaultValue<>'' then N.Attributes['DefaultValue']:=FDefaultValue else N.Attributes['DefaultValueAddress']:=FDefaultValueAddress;
  N.Attributes['Prompt']:=FPrompt;
  If Trim(FMinValue)<>'' then N.Attributes['MinValue']:=FMinValue;
  If Trim(FMaxValue)<>'' then N.Attributes['MaxValue']:=FMaxValue;
end;

Procedure TCheatActionStepChangeAddressWithDialog.CopyFrom(const ACheatActionStep : TCheatActionStep);
begin
  if not (ACheatActionStep is TCheatActionStepChangeAddressWithDialog) then exit;

  FAddresses:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).Addresses;
  FDefaultValue:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).DefaultValue;
  FDefaultValueAddress:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).DefaultValueAddress;
  FPrompt:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).DialogPrompt;
  FMinValue:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).MinValue;
  FMaxValue:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).MaxValue;
  FAddressesInt:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).FAddressesInt;
  FBytes:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).Bytes;
  FDefaultValueAddressInt:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).FDefaultValueAddressInt;
  FMinValueInt:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).FMinValueInt;
  FMaxValueInt:=TCheatActionStepChangeAddressWithDialog(ACheatActionStep).FMaxValueInt;
end;

function TCheatActionStepChangeAddressWithDialog.Apply(const St: TFileStream): Boolean;
Var Value : String;
    I,J : Integer;
begin
  result:=False;
  If FBytes<0 then exit;

  If Trim(FDefaultValue)<>'' then begin
    Value:=FDefaultValue;
  end else begin
    If not ExtSeek(St,FDefaultValueAddressInt,FBytes) then exit;
    I:=0; St.ReadBuffer(I,FBytes); Value:=IntToStr(I);
  end;

  If not InputQuery((FOwner.FOwner as TCheatGameRecord).Name+' - '+(FOwner as TCheatAction).Name,FPrompt,Value) Then Exit;

  If (not ExtTryStrToInt(Value,I)) or ((Trim(FMinValue)<>'') and (I<FMinValueInt)) or ((Trim(FMaxValue)<>'') and (I>FMaxValueInt)) then begin
    MessageDlg(LanguageSetup.ApplyCheatInvalidValue,mtError,[mbOK],0);
    exit;
  end;

  If FBytes=1 then begin
    If (I<0) or (I>255) then begin MessageDlg(LanguageSetup.ApplyCheatInvalidValue,mtError,[mbOK],0); exit; end;
  end;
  If FBytes=2 then begin
    If (I<0) or (I>65535) then begin MessageDlg(LanguageSetup.ApplyCheatInvalidValue,mtError,[mbOK],0); exit; end;
  end;

  For J:=0 to length(FAddressesInt)-1 do begin
    If not ExtSeek(St,FAddressesInt[J],FBytes) then exit;
    St.WriteBuffer(I,FBytes); {lower order byte first so it's ok just to write the first FBytesInt Bytes}
  end;

  result:=True;
end;

{ TCheatActionStepInternal }

constructor TCheatActionStepInternal.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create(AOwner);
  Nr:=-1;
end;

class function TCheatActionStepInternal.GetXMLNodeName: String;
begin
  result:='Internal';
end;

function TCheatActionStepInternal.LoadFromXML(const XML: IXMLNode): Boolean;
begin
  result:=False;
  If XML.NodeName<>'Internal' then exit;
  If not XML.HasAttribute('Nr') then exit;

  if not ExtTryStrToInt(XMl.Attributes['Nr'],FNr) then exit;
  result:=True;
end;

procedure TCheatActionStepInternal.SaveToXML(const XML: IXMLNode);
Var N : IXMLNode;
begin
  N:=XML.AddChild('Internal');
  N.Attributes['Nr']:=IntToStr(FNr);
end;

Procedure TCheatActionStepInternal.CopyFrom(const ACheatActionStep : TCheatActionStep);
begin
  if not (ACheatActionStep is TCheatActionStepInternal) then exit;
  FNr:=TCheatActionStepInternal(ACheatActionStep).Nr;
end;

procedure TCheatActionStepInternal.SetNr(const Value: Integer);
begin
  If FNr=Value then exit;
  FNr:=Value;
  SetChanged
end;

Function TCheatActionStepInternal.Apply(const St: TFileStream) : Boolean;
begin
  result:=ApplyBinaryCheat(FNr,St);
end;

{ TCheatAction }

constructor TCheatAction.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create(AOwner);
  FActionSteps:=TList.Create;
end;

destructor TCheatAction.Destroy;
begin
  Clear;
  FActionSteps.Free;
  inherited Destroy;
end;

function TCheatAction.LoadFromXML(const XML: IXMLNode) : Boolean;
Var I,J : Integer;
    S : String;
    A : TCheatActionStep;
begin
  result:=False;
  Clear;
  If XML.NodeName<>'Action' then exit;
  If (not XML.HasAttribute('Name')) or (not XML.HasAttribute('FileMask')) then exit;
  FName:=XML.Attributes['Name'];
  FFileMask:=XML.Attributes['FileMask'];

  For I:=0 to XML.ChildNodes.Count-1 do begin
    S:=XML.ChildNodes[I].NodeName;
    For J:=Low(CheatActionStepClasses) to High(CheatActionStepClasses) do If CheatActionStepClasses[J].GetXMLNodeName=S then begin
      A:=CheatActionStepClasses[J].Create(self);
      if A.LoadFromXML(XML.ChildNodes[I]) then FActionSteps.Add(A) else begin
        A.Free;
        {$IFDEF DebugCheatDB} ShowMessage('Failed to load ActionStep '+IntToStr(I)+' (Action="'+FName+'")'); {$ENDIF}
      end;
    end;
  end;
  result:=True;
end;

procedure TCheatAction.SaveToXML(const XML: IXMLNode);
Var N : IXMLNode;
    I : Integer;
begin
  N:=XML.AddChild('Action');
  N.Attributes['Name']:=FName;
  N.Attributes['FileMask']:=FFileMask;

  For I:=0 to FActionSteps.Count-1 do TCheatActionStep(FActionSteps[I]).SaveToXML(N);
end;

Procedure TCheatAction.CopyFrom(const ACheatAction : TCheatAction);
Var I,J : Integer;
    A : TCheatActionStep;
begin
  FName:=ACheatAction.Name;
  FFileMask:=ACheatAction.FileMask;
  For I:=0 to ACheatAction.Count-1 do begin
    For J:=0 to length(CheatActionStepClasses)-1 do if ACheatAction[I] is CheatActionStepClasses[J] then begin
      A:=CheatActionStepClasses[J].Create(nil);
      (A as CheatActionStepClasses[J]).CopyFrom(ACheatAction[I]);
      Add(A);
      break;
    end;
  end;
end;

Function TCheatAction.Apply(const St : TFileStream) : Boolean;
Var I : Integer;
begin
  result:=False;
  For I:=0 to FActionSteps.Count-1 do if not TCheatActionStep(FActionSteps[I]).Apply(St) then exit;
  result:=True;
end;

Function TCheatAction.Apply(const FileName : String; const BackupBefore : Boolean) : Boolean;
Var St : TFileStream;
begin
  If BackupBefore then BackupFileBeforeApplyingCheat(FileName);
  St:=TFileStream.Create(FileName,fmOpenReadWrite);
  try
    result:=Apply(St);
  finally
    St.Free;
  end;
end;

procedure TCheatAction.SetString(Index: Integer; const S: String);
begin
  Case Index of
    0 : If S=FName then exit else FName:=S;
    1 : If S=FFileMask then exit else FFileMask:=S;
  end;
  SetChanged;
end;

function TCheatAction.GetCount: Integer;
begin
  result:=FActionSteps.Count;
end;

function TCheatAction.GetActionStep(I: Integer): TCheatActionStep;
begin
  If (I<0) or (I>=FActionSteps.Count) then result:=nil else result:=TCheatActionStep(FActionSteps[I]);
end;

function TCheatAction.Add(const ACheatActionStep: TCheatActionStep): Integer;
begin
  result:=FActionSteps.Add(ACheatActionStep);
  ACheatActionStep.Owner:=self;
  SetChanged;
end;

procedure TCheatAction.Delete(const Nr: Integer);
begin
  If (Nr<0) or (Nr>=FActionSteps.Count) then exit;
  TCheatActionStep(FActionSteps[Nr]).Free;
  FActionSteps.Delete(Nr);
  SetChanged;
end;

procedure TCheatAction.Delete(const ACheatActionStep: TCheatActionStep);
begin
  Delete(FActionSteps.IndexOf(ACheatActionStep));
end;

procedure TCheatAction.Clear;
Var I : Integer;
begin
  For I:=0 to FActionSteps.Count-1 do TCheatActionStep(FActionSteps[I]).Free;
  SetChanged;
end;

procedure TCheatAction.CompressActionSteps;
Var I : Integer;
    A0,A1 : TCheatActionStepChangeAddress;
    S : String;
begin
  I:=0;
  while I<FActionSteps.Count-1 do begin

    If not (TCheatActionStep(FActionSteps[I]) is TCheatActionStepChangeAddress) then begin inc(I); continue; end;
    A0:=TCheatActionStepChangeAddress(FActionSteps[I]);

    While FActionSteps.Count>I+1 do begin
      If not (TCheatActionStep(FActionSteps[I+1]) is TCheatActionStepChangeAddress) then break;
      A1:=TCheatActionStepChangeAddress(FActionSteps[I+1]);
      If (A1.Bytes<>A0.Bytes) or (A1.NewValue<>A0.NewValue) then break;
      S:=A1.Addresses;
      If (S<>'') and ((S[1]=';') or (S[1]=',')) then S:=Copy(S,2,MaxInt);
      If (S<>'') and ((S[length(S)]=';') or (S[length(S)]=',')) then S:=Copy(S,1,length(S)-1);
      A0.Addresses:=A0.Addresses+';'+S;
      Delete(I+1);
    end;

    inc(I);
  end;
end;

function TCheatAction.IndexOf(const ACheatActionStep: TCheatActionStep): Integer;
begin
  result:=FActionSteps.IndexOf(ACheatActionStep);
end;

Function TCheatAction.SetNewActionStep(const ACheatActionStep : TCheatActionStep; const APosition : Integer) : Boolean;
begin
  result:=False;
  If (APosition<0) or (APosition>=FActionSteps.Count) then exit;
  If ACheatActionStep=nil then exit;
  TCheatActionStep(FActionSteps[APosition]).Free;
  FActionSteps[APosition]:=ACheatActionStep;
  ACheatActionStep.Owner:=self;
  result:=True;
  SetChanged;
end;

{ TCheatGameRecord }

constructor TCheatGameRecord.Create(const AOwner: TCheatBaseClass);
begin
  inherited Create(AOwner);
  FActions:=TList.Create;
end;

destructor TCheatGameRecord.Destroy;
begin
  Clear;
  FActions.Free;
  inherited Destroy;
end;

function TCheatGameRecord.LoadFromXML(const XML: IXMLNode): Boolean;
Var I : Integer;
    A : TCheatAction;
begin
  result:=False;
  Clear;
  If XML.NodeName<>'GameRecord' then exit;
  If not XML.HasAttribute('Name') then exit;

  FName:=XML.Attributes['Name'];
  For I:=0 to XML.ChildNodes.Count-1 do begin
    A:=TCheatAction.Create(self);
    If A.LoadFromXML(XML.ChildNodes[I]) then FActions.Add(A) else begin
      A.Free;
      {$IFDEF DebugCheatDB} ShowMessage('Failed to load Action '+IntToStr(I)+' Name="'+XML.ChildNodes[I].Attributes['Name']+'" (Game="'+FName+'")'); {$ENDIF}
    end;
  end;
  result:=True;
end;

procedure TCheatGameRecord.SaveToXML(const XML: IXMLNode);
Var N : IXMLNode;
    I : Integer;
begin
  N:=XML.AddChild('GameRecord');
  N.Attributes['Name']:=FName;
  For I:=0 to FActions.Count-1 do TCheatAction(FActions[I]).SaveToXML(N);
end;

Procedure TCheatGameRecord.CopyFrom(const ACheatGameRecord: TCheatGameRecord);
Var I : Integer;
    A : TCheatAction;
begin
  FName:=ACheatGameRecord.Name;
  For I:=0 to ACheatGameRecord.Count-1 do begin
    A:=TCheatAction.Create(nil);
    A.CopyFrom(ACheatGameRecord[I]);
    Add(A);
  end;
end;

procedure TCheatGameRecord.SetName(const Value: String);
begin
  If FName=Value then exit;
  FName:=Value;
  SetChanged;
end;

function TCheatGameRecord.GetCount: Integer;
begin
  result:=FActions.Count;
end;

function TCheatGameRecord.GetAction(I: Integer): TCheatAction;
begin
  If (I<0) or (I>=FActions.Count) then result:=nil else result:=TCheatAction(FActions[I]);
end;

function TCheatGameRecord.Add(const ACheatAction: TCheatAction): Integer;
begin
  result:=FActions.Add(ACheatAction);
  ACheatAction.Owner:=self;
  SetChanged;
end;

procedure TCheatGameRecord.Delete(const Nr: Integer);
begin
  If (Nr<0) or (Nr>=FActions.Count) then exit;
  TCheatAction(FActions[Nr]).Free;
  FActions.Delete(Nr);
  SetChanged;
end;

procedure TCheatGameRecord.Delete(const ACheatAction: TCheatAction);
begin
  Delete(FActions.IndexOf(ACheatAction));
end;

procedure TCheatGameRecord.Clear;
Var I : Integer;
begin
  For I:=0 to FActions.Count-1 do TCheatAction(FActions[I]).Free;
  SetChanged;
end;

function TCheatGameRecord.IndexOf(const ACheatAction: TCheatAction): Integer;
begin
  result:=FActions.IndexOf(ACheatAction);
end;

Function TCheatGameRecord.IndexOf(const ACheatActionName : String) : Integer;
Var I : Integer;
begin
  result:=-1;
  For I:=0 to FActions.Count-1 do If TCheatAction(FActions[I]).Name=ACheatActionName then begin
    result:=I; exit;
  end;
end;

procedure TCheatGameRecord.CompressActionSteps;
Var I : Integer;
begin
  For I:=0 to FActions.Count-1 do TCheatAction(FActions[I]).CompressActionSteps;
end;

{ TCheatsDB }

constructor TCheatDB.Create;
begin
  inherited Create(nil);
  FGameRecords:=TList.Create;
  FChanged:=False;
end;

destructor TCheatDB.Destroy;
begin
  Clear;
  FGameRecords.Free;
  inherited Destroy;
end;

Function TCheatDB.LoadFromXML(const FileName: String) : Boolean;
Var XMLDoc : TXMLDocument;
    I : Integer;
    G : TCheatGameRecord;
begin
  result:=False;
  If not FileExists(FileName) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[FileName]),mtError,[mbOK],0);
    exit;
  end;
  XMLDoc:=LoadXMLDoc(FileName,FileName); if XMLDoc=nil then exit;
  Clear;
  try
    If XMLDoc.DocumentElement.NodeName<>'CheatDB' then exit;

    FVersion:=0;
    If XMLDoc.DocumentElement.HasAttribute('Version') then begin
      TryStrToInt(XMLDoc.DocumentElement.Attributes['Version'],FVersion);
    end;

    For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
      G:=TCheatGameRecord.Create(self);
      If G.LoadFromXML(XMLDoc.DocumentElement.ChildNodes[I]) then FGameRecords.Add(G) else begin
        G.Free;
        {$IFDEF DebugCheatDB} ShowMessage('Failed to load GameRecord '+IntToStr(I)+' Name="'+XMLDoc.DocumentElement.ChildNodes[I].Attributes['Name']+'"'); {$ENDIF}
      end;
    end;
  finally
    XMLDoc.Free;
  end;
  FChanged:=False;
  result:=true;
end;

procedure TCheatDB.SaveToXML(const FileName: String; const ParentForm : TForm);
Var XMLDoc : TXMLDocument;
    I : Integer;
begin
  XMLDoc:=TXMLDocument.Create(ParentForm);
  try
    try
      XMLDoc.DOMVendor:=MSXML_DOM;
      XMLDoc.Active:=True;
    except
      on E : Exception do begin MessageDlg(E.Message,mtError,[mbOK],0); exit; end;
    end;
    XMLDoc.DocumentElement:=XMLDoc.CreateNode('CheatDB');
    If FVersion>=0 then XMLDoc.DocumentElement.Attributes['Version']:=IntToStr(FVersion);
    For I:=0 to FGameRecords.Count-1 do TCheatGameRecord(FGameRecords[I]).SaveToXML(XMLDoc.DocumentElement);
    SaveXMLDoc(XMLDoc,['<!DOCTYPE CheatDB SYSTEM "'+DFRHomepage+'Packages/Cheats.dtd">'],FileName,False);
  finally
    XMLDoc.Free;
  end;
  FChanged:=False;
end;

function TCheatDB.Add(const AGameRecord: TCheatGameRecord): Integer;
begin
  result:=FGameRecords.Add(AGameRecord);
  AGameRecord.Owner:=self;
  FChanged:=True;
end;

procedure TCheatDB.Delete(const Nr: Integer);
begin
  If (Nr<0) or (Nr>=FGameRecords.Count) then exit;
  TCheatGameRecord(FGameRecords[Nr]).Free;
  FGameRecords.Delete(Nr);
  FChanged:=True;
end;

procedure TCheatDB.Delete(const AGameRecord: TCheatGameRecord);
begin
  Delete(FGameRecords.IndexOf(AGameRecord));
end;

procedure TCheatDB.Clear;
Var I : Integer;
begin
  For I:=0 to FGameRecords.Count-1 do TCheatGameRecord(FGameRecords[I]).Free;
  FVersion:=-1;
  FChanged:=False;
end;

procedure TCheatDB.CompressActionSteps;
Var I : Integer;
begin
  For I:=0 to FGameRecords.Count-1 do TCheatGameRecord(FGameRecords[I]).CompressActionSteps;
end;

function TCheatDB.IndexOf(const AGameRecord: TCheatGameRecord): Integer;
begin
  result:=FGameRecords.IndexOf(AGameRecord);
end;

function TCheatDB.IndexOf(const AGameName: String): Integer;
Var I : Integer;
begin
  result:=-1;
  For I:=0 to FGameRecords.Count-1 do if TCheatGameRecord(FGameRecords[I]).Name=AGameName then begin
    result:=I; exit;
  end;
end;

function TCheatDB.GetCount: Integer;
begin
  result:=FGameRecords.Count;
end;

function TCheatDB.GetGameRecord(I: Integer): TCheatGameRecord;
begin
  If (I<0) or (I>=FGameRecords.Count) then result:=nil else result:=TCheatGameRecord(FGameRecords[I]);
end;

procedure TCheatDB.SetChanged;
begin
  FChanged:=True;
end;

procedure TCheatDB.SetVersion(const Value: Integer);
begin
  If FVersion=Value then exit;
  FVersion:=Value;
  FChanged:=True;
end;

initialization
  RegisterCheatActionSteps;
end.
