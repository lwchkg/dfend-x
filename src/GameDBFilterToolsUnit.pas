unit GameDBFilterToolsUnit;
interface

uses Classes;

Type TLanguageLocalOperatorNames=record NameAnd, NameOr, NameNot : String; end;

function SplitSearchString(S : String) : TStringList;
function ProcessSearchElements(const St : TStringList; const OperatorNames : TLanguageLocalOperatorNames) : TStringList;
function ProcessNotOperators(const St : TStringList) : TStringList;
function ProcessSearchOperators1(const St : TStringList) : TStringList;
function ProcessSearchOperators2(const St : TStringList) : TStringList;
function ProcessQuotes(const St : TStringList) : TStringList;

procedure FreeNestedStringList(const St : TStringList);
Function NestedStringListToString(const St : TStringList) : String;

implementation

uses SysUtils, CommonTools;

Procedure AddNestedStrings(const St,ListToAdd : TStringList; const StartNr, EndNr : Integer); overload;
Var I : Integer;
    St2 : TStringList;
begin
  for I:=StartNr to EndNr do If ListToAdd.Objects[I]=nil then St.Add(ListToAdd[I]) else begin
    St2:=TStringList.Create;
    AddNestedStrings(St2,TStringList(ListToAdd.Objects[I]),0,TStringList(ListToAdd.Objects[I]).Count-1);
    St.AddObject(ListToAdd[I],St2);
  end;
end;

Procedure AddNestedStrings(const St,ListToAdd : TStringList); overload;
begin
  AddNestedStrings(St,ListToAdd,0,ListToAdd.Count-1);
end;

Procedure AddNestedString(const St,ListToAdd : TStringList; const Nr : Integer);
begin
  AddNestedStrings(St,ListToAdd,Nr,Nr);
end;

const TwoLetterOps : array[1..8] of String = ('==','<>','!=','=!','<=','>=','=<','=>');
      OneLetterOps : array[1..3] of Char = ('=','<','>');

function SplitSearchString(S : String) : TStringList;
Var I,J,Start,QuoteEnd,Count : Integer;
    Found,InText : Boolean;
    TextStart : Char;
begin
  S:=Trim(ExtUpperCase(S));

  result:=TStringList.Create;
  if length(S)=0 then exit;

  Start:=1;
  I:=1; while I<=length(S) do begin

    {Quoted text}
    If (S[I]='"') or (S[I]='''') then begin
      If Start<I then begin result.Add(Trim(Copy(S,Start,(I-1)-Start+1))); end;
      QuoteEnd:=length(S);
      For J:=I+1 to length(S) do If S[J]=S[I] then begin QuoteEnd:=J-1; break; end;
      result.Add('"'+Trim(Copy(S,I+1,QuoteEnd-(I+1)+1))+'"');
      I:=QuoteEnd+2; Start:=I; continue;
    end;

    {Two letter symbols}
    If I+1<=length(S) then begin
      Found:=False;
      For J:=Low(TwoLetterOps) to High(TwoLetterOps) do if (S[I]=TwoLetterOps[J][1]) and (S[I+1]=TwoLetterOps[J][2]) then begin
        If Start<I then begin result.Add(Trim(Copy(S,Start,(I-1)-Start+1))); end;
        result.Add(TwoLetterOps[J]); inc(I,2); Start:=I; Found:=True; break;
      end;
      If Found then continue;
    end;

    {One letter symbols}
    Found:=False;
    For J:=Low(OneLetterOps) to High(OneLetterOps) do if S[I]=OneLetterOps[J] then begin
      If Start<I then begin result.Add(Trim(Copy(S,Start,(I-1)-Start+1))); end;
      result.Add(OneLetterOps[J]); inc(I); Start:=I; Found:=True; break;
    end;
    If Found then continue;

    {"!" and "-" symbol; only if not in plain text string}
    If (Start=I) and ((S[I]='!') or (S[I]='-')) then begin
      result.Add(S[I]); inc(I); Start:=I; continue;
    end;

    {Sub elements}
    If (S[I]='(') or (S[I]='[') or (S[I]='{') then begin
      If Start<I then begin result.Add(Trim(Copy(S,Start,(I-1)-Start+1))); end;
      InText:=False; TextStart:='"'; Count:=1;
      For J:=I+1 to length(S) do begin
        If not InText then begin
          If (S[J]='(') or (S[J]='[') or (S[J]='{') then inc(Count);
          If (S[J]=')') or (S[J]=']') or (S[J]='}') then dec(Count);
          If (S[J]='"') or (S[J]='''') then begin InText:=True; TextStart:=S[J]; end;
        end else begin
          If S[J]=TextStart then InText:=False;
        end;
        If Count=0 then begin
          result.AddObject('()',SplitSearchString(Copy(S,I+1,(J-1)-(I+1)+1)));
          I:=J+1; Found:=True; break;
        end;
      end;
      If not Found then begin
        result.AddObject('()',SplitSearchString(Copy(S,I+1,MaxInt)));
        I:=length(S)+1;
      end;
      Start:=I; continue;
    end;

    {Spaces}
    If S[I]=' ' then begin
      If Start<I then begin result.Add(Trim(Copy(S,Start,(I-1)-Start+1))); end;
      inc(I); Start:=I; continue;
    end;

    {Plain text}
    inc(I);
  end;

  {Add last plain string}
  If Start<length(S)+1 then result.Add(Trim(Copy(S,Start,MaxInt)));
end;

function ProcessSearchElements(const St : TStringList; const OperatorNames : TLanguageLocalOperatorNames) : TStringList;
Var I,J,Position : Integer;
    Temp : TStringList;
    Found : Boolean;
Procedure AddTemp; var St2 : TStringList; begin If Temp.Count=0 then exit; St2:=TStringList.Create; St2.AddStrings(Temp); result.AddObject('',St2); Temp.Clear; end;
begin
  result:=TStringList.Create;
  Temp:=TStringList.Create;

  try
    if St.Count=1 then begin
      If St.Objects[0]=nil then begin Temp.Add(St[0]); AddTemp; end else begin FreeAndNil(result); result:=ProcessSearchElements(TStringList(St.Objects[0]),OperatorNames); end;
      exit;
    end;

    Position:=0;
    For I:=0 to St.Count-1 do begin
      {Logical ops}
      if (St[I]='AND') or (St[I]='OR') then begin AddTemp; result.Add(St[I]); Position:=0; continue; end;
      If (OperatorNames.NameAnd<>'') and (St[I]=ExtUpperCase(OperatorNames.NameAnd)) then begin AddTemp; result.Add('AND'); Position:=0; continue; end;
      If (OperatorNames.NameOr<>'') and (St[I]=ExtUpperCase(OperatorNames.NameOr)) then begin AddTemp; result.Add('OR'); Position:=0; continue; end;
      If (OperatorNames.NameNot<>'') and (St[I]=ExtUpperCase(OperatorNames.NameNot)) then begin AddTemp; result.Add('!'); Position:=0; continue; end;
      if (St[I]='!') or (St[I]='-') or (St[I]='NOT') then begin AddTemp; result.Add('!'); Position:=0; continue; end;
      If (St[I]='&') or (St[I]='&&') then begin AddTemp; result.Add('AND'); Position:=0; continue; end;
      If (St[I]='|') or (St[I]='||') then begin AddTemp; result.Add('OR'); Position:=0; continue; end;

      {Subs}
      If St[I]='()' then begin
        AddTemp;
        result.AddObject('()',ProcessSearchElements(TStringList(St.Objects[I]),OperatorNames));
        continue;
      end;

      {[0] String [1] CompOp [2] String}
      If Position=0 then begin
        Temp.Add(St[I]); Position:=1; continue;
      end;

      If Position=1 then begin
        Found:=False;
        For J:=Low(TwoLetterOps) to High(TwoLetterOps) do if St[I]=TwoLetterOps[J] then begin Found:=True; break; end;
        if not Found then For J:=Low(OneLetterOps) to High(OneLetterOps) do if St[I]=OneLetterOps[J] then begin Found:=True; break; end;
        If Found then begin Temp.Add(St[I]); Position:=2; end else begin AddTemp; Temp.Add(St[I]); Position:=1; end;
        continue;
      end;

      If Position=2 then begin
        Temp.Add(St[I]); AddTemp; Position:=0; continue;
      end;
    end;

    AddTemp;
  finally
    Temp.Free;
  end;
end;

function ProcessNotOperators(const St : TStringList) : TStringList;
Var I : Integer;
    S : String;
    St2 : TStringList;
begin
  result:=TStringList.Create;

  I:=0; While I<St.Count do begin
    If St[I]='!' then begin
      If (I=St.Count-1) or (St.Objects[I+1]=nil) then begin inc(I); continue; end;
      If St[I+1]='()' then begin
        St2:=ProcessNotOperators(TStringList(St.Objects[I+1])); result.AddObject('()',St2);
      end else begin
        AddNestedString(result,St,I+1);
      end;
      inc(I,2);
      if St[I-1]='()' then S:='!()' else S:='!';
      result[result.count-1]:=S;
    end else begin
      If (St.Objects[I]<>nil) and (St[I]='()') then begin
        St2:=ProcessNotOperators(TStringList(St.Objects[I])); result.AddObject('()',St2);
      end else begin
        AddNestedString(result,St,I);
      end;
      inc(I);
    end;
  end;
end;

function ProcessSearchOperators1(const St : TStringList) : TStringList;
Var I,J : Integer;
    LastWasOp : Boolean;
    St2,St3 : TStringList;
begin
  result:=TStringList.Create;

  LastWasOp:=True;
  I:=0; while (I<St.Count) and (St[I]<>'') and (St[I]<>'!') do inc(I);

  For J:=I to St.Count-1 do begin
    If LastWasOp then begin
      If St.Objects[J]=nil then continue;
      LastWasOp:=False;
    end else begin
      If St.Objects[J]=nil then begin result.Add(St[J]); LastWasOp:=True; continue; end;
      result.Add('AND');
    end;
    St2:=TStringList(St.Objects[J]);
    If (St2.Count=0) or (St[J]='') or (St[J]='!') then begin
      St3:=TStringList.Create; St3.AddStrings(St2);
    end else begin
      St3:=ProcessSearchOperators1(St2);
    end;
    result.AddObject(St[J],St3);
  end;
end;

function ProcessSearchOperators2(const St : TStringList) : TStringList;
Procedure AddToResult(const Nr : Integer);
begin
  If (St[Nr]='()') or (St[Nr]='!()') then result.AddObject(St[Nr],ProcessSearchOperators2(TStringList(St.Objects[Nr])));
  If (St[Nr]='') or (St[Nr]='!') then AddNestedString(result,St,Nr);
end;
Var Op : String;
    I : Integer;
    NextIsOp : Boolean;
    St2 : TStringList;
begin
  result:=TStringList.Create;

  If St.Count<3 then begin result.Add('AND'); If St.Count>0 then AddToResult(0); exit; end;

  Op:=St[1]; result.Add(Op); AddToResult(0); AddToResult(2); NextIsOp:=True;
  For I:=3 to St.Count-1 do begin
    If NextIsOp then begin
      If St.Objects[I]<>nil then begin AddToResult(I); continue; end;
      If St[I]=Op then NextIsOp:=False else begin
        {Wrong operator needing sub list}
        FreeNestedStringList(TStringList(result.Objects[result.count-1]));
        result.Delete(result.count-1);
        St2:=TStringList.Create;
        try
          AddNestedStrings(St2,St,I-1,St.Count-1);
          result.AddObject('()',ProcessSearchOperators2(St2));
        finally
          FreeNestedStringList(St2);
        end;
        break;
      end;
    end else begin
      If St.Objects[I]<>nil then AddToResult(I);
      NextIsOp:=True;
    end;
  end;
end;

function ProcessQuotes(const St : TStringList) : TStringList;
Var I : Integer;
begin
  result:=TStringList.Create;

  For I:=0 to St.Count-1 do begin
    If (St[I]<>'') and ((St[I][1]='"') or (St[I][1]='''')) then begin
      result.Add(Copy(St[I],2,length(St[I])-2));
    end else begin
      If St.Objects[I]<>nil then result.AddObject(St[I],ProcessQuotes(TStringList(St.Objects[I]))) else result.Add(St[I]);
    end;
  end;
end;

procedure FreeNestedStringList(const St : TStringList);
Var I : Integer;
begin
  If St=nil then exit;
  For I:=0 to St.Count-1 do If St.Objects[I]<>nil then FreeNestedStringList(TStringList(St.Objects[I]));
  St.Free;
end;

Function FlatNestedStringList(const St : TStringList; const Indent : String) : TStringList;
Var I : Integer;
    St2 : TStringList;
begin
  result:=TStringList.Create;
  For I:=0 to St.Count-1 do begin
    If St.Objects[I]<>nil then begin
      result.Add(Indent+'  List element ['+St[I]+']:');
      St2:=FlatNestedStringList(TStringList(St.Objects[I]),Indent+'    ');
      try result.AddStrings(St2); finally St2.Free; end;
    end else begin
      result.Add(Indent+St[I]);
    end;
  end;
end;

Function NestedStringListToString(const St : TStringList) : String;
Var St2 : TStringList;
begin
  St2:=FlatNestedStringList(St,'');
  try result:=St2.Text; finally St2.Free; end;
end;

end.
