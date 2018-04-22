unit CheatDBInternalUnit;
interface

uses Classes;

Function ApplyBinaryCheat(const Nr : Integer; const St : TFileStream) : Boolean;

implementation

uses Controls, Dialogs, Forms, CheatDBInternalPrivateerPositionUnit,
     LanguageSetupUnit;

Function SearchString(const S : String; const St : TFileStream) : Integer;
Var C : Char;
    Nr : Byte;
    L : Integer;
begin
  Nr:=0; L:=-1; result:=-1;
  While St.Position<St.Size do begin
    St.ReadBuffer(C,1);
    If C=S[Nr+1] then begin
      If Nr=0 then L:=St.Position-1;
      Inc(Nr);
      IF Nr=length(S) Then begin result:=L; Exit; end;
    end else begin
      Nr:=0;
    end;
  end;
end;

Function GetNumber(const W : Word; const  St : TFileStream) : Integer;
Var B : Array[1..2] of Byte;
begin
  result:=-1;
  B[1]:=255;
  While St.Position<St.Size do begin
    B[2]:=B[1];
    St.ReadBuffer(B[1],1);
    If Word(B)=W Then begin result:=St.Position-2; Exit; end;
  end;
end;

Function DarkSideOfXeenPosition(const St : TFileStream) : Boolean;
Var X,B,Y : Byte;
    S,T,U,V : String;
    I : Integer;
    H : Boolean;
begin
  result:=False;
  St.Position:=$3788; St.ReadBuffer(X,1); St.ReadBuffer(B,1); Str(X,S); Str(B,T);
  St.Position:=$378A; St.ReadBuffer(Y,1);
  H:=False;
  if (Y>112) or (Y>24) and (Y<89) then
  begin
    Str(Y,V);
    U:='('+V+')';
  end
  else
  begin
  if Y>=88 Then begin
    H:=True;
    Y:=Y-88;
  end;
  Str(Y mod 4,V);
  if V='0' then   begin V:='4';Y:=Y-1; end;
  U:='?';
  Case Y div 4 of
    0 : U:='A';
    1 : U:='B';
    2 : U:='C';
    3 : U:='D';
    4 : U:='E';
    5 : U:='F';
  end;
  U:=U+V;
  end;

  If not InputQuery(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionX,LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionPrompt,S) then exit;
  Val(S,X,I); IF I<>0 Then begin MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit; end;
  If not InputQuery(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionY,LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionPrompt,T) then exit;
  Val(T,B,I); IF I<>0 Then begin MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit; end;
  If not InputQuery(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionQuadrant,LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionPrompt,U) Then Exit;

  if (Length(U)>2) and (U[1]='(') and (U[Length(U)]=')') then
  begin
    Val(Copy(U,2,Length(U)-2),Y,I);
    if (I<>0) or (Y>112) then begin MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit; end;
  end
  else
  begin
  Case UpCase(U[1]) of
    'A' : Y:=0;
    'B' : Y:=4;
    'C' : Y:=8;
    'D' : Y:=12;
    'E' : Y:=16;
    'F' : Y:=20;
    else MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit;
  end;
  Case U[2] of
    '1' : Inc(Y);
    '2' : Inc(Y,2);
    '3' : Inc(Y,3);
    '4' : Inc(Y,4);
    else MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit;
  end;
  IF H Then
    H:=(MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionSkySet,mtConfirmation,[mbYes,mbNo],0)=mrYes)
  else
    H:=(MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionSkyNotSet,mtConfirmation,[mbYes,mbNo],0)=mrYes);
  If H Then Inc(Y,88);
  end;
  result:=True;
  St.Position:=$3788;
  St.WriteBuffer(X,1); St.WriteBuffer(B,1);
  St.Position:=$378A;
  St.WriteBuffer(Y,1);
end;

{Function DarkSideOfXeenPosition(const St : TFileStream) : Boolean;
Var X,B,Y : Byte;
    S,T,U,V : String;
    I : Integer;
    H : Boolean;
begin
  result:=False;
  St.Position:=$3788; St.ReadBuffer(X,1); St.ReadBuffer(B,1); Str(X,S); Str(B,T);
  St.Position:=$378A; St.ReadBuffer(Y,1);
  IF Y>=88 Then begin
    H:=True; Str((Y-88) div 4,V);
    Case (Y-88) Mod 4 of
      0 : U:='A';
      1 : U:='B';
      2 : U:='C';
      3 : U:='D';
    end;
    U:=U+V;
  end else begin
    H:=False; Str(Y div 4,V);
    Case Y Mod 4 of
      0 : U:='A';
      1 : U:='B';
      2 : U:='C';
      3 : U:='D';
    end;
    U:=U+V;
  end;
  If not InputQuery(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionX,LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionPrompt,S) then exit;
  Val(S,X,I); IF I<>0 Then begin MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit; end;
  If not InputQuery(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionY,LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionPrompt,T) then exit;
  Val(T,B,I); IF I<>0 Then begin MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit; end;
  If not InputQuery(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionQuadrant,LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionPrompt,U) Then Exit;
  Case UpCase(U[1]) of
    'A' : Y:=0;
    'B' : Y:=4;
    'C' : Y:=8;
    'D' : Y:=12;
    else MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit;
  end;
  Case U[2] of
    '1' : Inc(Y);
    '2' : Inc(Y,2);
    '3' : Inc(Y,3);
    '4' : Inc(Y,4);
    else MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionInvalid,mtError,[mbOK],0); Exit;
  end;
  IF H Then
    H:=(MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionSkyNotSet,mtConfirmation,[mbYes,mbNo],0)=mrYes)
  else
    H:=(MessageDlg(LanguageSetup.EditCheatsInternalDarkSideOfXeenPositionSkySet,mtConfirmation,[mbYes,mbNo],0)=mrYes);
  If H Then Inc(Y,88);
  result:=True;
  St.Position:=$3788;
  St.WriteBuffer(X,1); St.WriteBuffer(B,1);
  St.Position:=$378A;
  St.WriteBuffer(Y,1);
end;}

Function PrivateerMoney(const St : TFileStream) : Boolean;
Var X,B : Byte;
begin
  result:=False;
  If SearchString('CCRGI'#0#0#0#8,St)<0 then begin
    MessageDlg(LanguageSetup.EditCheatsInternalPrivateerMoneyNotFound,mtError,[mbOK],0); exit;
  end;
  X:=$FF; B:=$5F; result:=True;
  St.WriteBuffer(X,1); St.WriteBuffer(X,1);
  St.WriteBuffer(B,1); St.WriteBuffer(B,1);
end;

Function SimCity2000Money(const St : TFileStream) : Boolean;
Var B : Byte;
    S : String;
    I : Integer;
    W : Word;
    L : Longint;
begin
  result:=False;
  S:='';
  IF not InputQuery(LanguageSetup.EditCheatsInternalSimCity2000,LanguageSetup.EditCheatsInternalSimCity2000Prompt,S) Then Exit;
  Val(S,W,I);
  IF (I<>0) OR (W=0) Then begin
    MessageDlg(LanguageSetup.EditCheatsInternalSimCity2000InvalidValue,mtError,[mbOK],0); Exit;
  end;
  L:=GetNumber(W,St); If L<0 then exit;
  St.Position:=L-2; B:=$7F; St.WriteBuffer(B,1);
  St.Position:=L; B:=$FF; St.WriteBuffer(B,1);
  St.Position:=L+1; B:=$FF; St.WriteBuffer(B,1);
  result:=True;
end;

Procedure BetrayalAtKrondorCharacters(const St : TFileStream);
Var X,B,Y : Byte;
    W : Word;
    L : Longint;
begin
  L:=$E3;
  For Y:=0 To 5 do begin
    W:=L+(Y*95);
    St.Position:=W; B:=255; St.WriteBuffer(B,1); St.WriteBuffer(B,1); St.WriteBuffer(B,1);
    St.Position:=W+5; B:=255; St.WriteBuffer(B,1); St.WriteBuffer(B,1); St.WriteBuffer(B,1);
    St.Position:=W+10; B:=$7F; St.WriteBuffer(B,1); St.WriteBuffer(B,1); St.WriteBuffer(B,1);
    St.Position:=W+15; B:=$7F; St.WriteBuffer(B,1); St.WriteBuffer(B,1); St.WriteBuffer(B,1);
    For X:=1 To 12 do begin
      St.Position:=W+15+(X*5); St.ReadBuffer(B,1); IF B<>0 Then begin
        St.Position:=W+15+(X*5); B:=$64; St.WriteBuffer(B,1); St.WriteBuffer(B,1); St.WriteBuffer(B,1);
      end;
    end;
  end;
end;

Procedure AdvantedTennisParameters(const St : TFileStream);
Var X : Byte;
    W : Word;
    L : Longint;
    A : Array[1..60] of Byte;
begin
  St.Position:=$1CF2;
  While St.Position<St.Size do begin
    L:=St.Position;
    W:=St.Read(A,Sizeof(A));
    IF W<Sizeof(A) then break;
    If A[34]=137 Then begin
      For X:=1 To 6 do A[41+(X*2)]:=255;
      St.Position:=L; St.ReadBuffer(A,Sizeof(A));
    end;
  end;
end;

Procedure PatchCC1(const St : TFileStream);
Var L : Longint;
    I : Integer;
begin
  L:=2000000;
  St.Position:=$580; St.WriteBuffer(L,4);
  St.Position:=$584; St.WriteBuffer(L,4);
  I:=SearchString('Computer',St)-$46;
  If I>=0 then begin St.Position:=I; St.WriteBuffer(L,4); end;
end;

Procedure UfoBuildingTime(const St : TFileStream);
Var X,B : Byte;
begin
  For X:=1 To 36 do begin
    St.Position:=$D10+X; St.ReadBuffer(B,1);
    IF (B<>0) and (B<>255) then begin St.Position:=$D10+X; B:=1; St.WriteBuffer(B,1); end;
  end;
end;

Function PrivateerShip(const St : TFileStream) : Boolean;
Var X,B : Byte;
    S : String;
    I : Integer;
begin
  result:=False;
  S:='';
  If not InputQuery(LanguageSetup.EditCheatsInternalPrivateerShipMissions,LanguageSetup.EditCheatsInternalPrivateerShipMissionsPrompt,S) Then Exit;
  Val(S,B,I);
  If (I<>0) Or (B>3) then begin MessageDlg(LanguageSetup.ApplyCheatInvalidValue,mtError,[mbOK],0); exit; end;
  St.Position:=$28+(B*8); St.ReadBuffer(X,1); Str(X,S);
  If not InputQuery(LanguageSetup.EditCheatsInternalPrivateerShip,LanguageSetup.EditCheatsInternalPrivateerShipPrompt,S) Then Exit;
  Val(S,X,I);
  If (I<>0) Or (X>4) then begin MessageDlg(LanguageSetup.ApplyCheatInvalidValue,mtError,[mbOK],0); exit; end;
  St.Position:=$28+(B*8); St.WriteBuffer(X,1); result:=True;
end;

function PrivateerPosition(const AOwner : TComponent; const St : TFileStream) : Boolean;
Var X,B : Byte;
    S : String;
    I : Integer;
begin
  result:=False;
  S:='';
  If not InputQuery(LanguageSetup.EditCheatsInternalPrivateerPositionMissions,LanguageSetup.EditCheatsInternalPrivateerPositionMissionsPrompt,S) Then Exit;
  Val(S,B,I);
  If (I<>0) Or (B>3) then begin MessageDlg(LanguageSetup.ApplyCheatInvalidValue,mtError,[mbOK],0); exit; end;
  St.Position:=$2A+(B*8); St.ReadBuffer(X,1);
  If ShowCheatDBInternalPrivateerPositionDialog(AOwner,X) then begin
    St.Position:=$2A+(B*8); St.WriteBuffer(X,1); result:=True;
  end;
end;

Function ApplyBinaryCheat(const Nr : Integer; const St : TFileStream) : Boolean;
begin
  {Translated from DOS Pascal code from 1997}
  result:=False;
  Case Nr of
    1 : result:=DarkSideOfXeenPosition(St);
    2 : result:=PrivateerMoney(St);
    3 : result:=SimCity2000Money(St);
    4 : begin BetrayalAtKrondorCharacters(St); result:=True; end;
    5 : begin AdvantedTennisParameters(St); result:=True; end;
    6 : begin UfoBuildingTime(St); result:=True; end;
    7 : result:=PrivateerShip(St);
    8 : result:=PrivateerPosition(Application.MainForm,St);
    9 : begin PatchCC1(St); result:=true; end;
  end;
end;

end.
