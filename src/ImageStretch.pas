unit ImageStretch;
interface

uses Graphics;

{PrgSetup.ImageFilter: 0..8, 0=off, 1=simple&slow, 2=Box, 3=Triangle, 4=Hermite, 5=Bell, 6=B-Spline, 7=Lanczos3, 8=Mitchell}

Function ScaleImage(const SourcePic : TPicture; const Factor : Double) : TBitmap; overload;
Procedure ScaleImage(const Source, Dest : TBitmap; const DestW, DestH : Integer; const UseFiltering : Boolean = True); overload;
Procedure ScaleImage(const Source, Dest : TBitmap; const UseFiltering : Boolean = True); overload;
Procedure ScaleImage(const Source : TPicture; const Dest : TBitmap; const UseFiltering : Boolean = True); overload;
Procedure ScaleImage(const Source : TIcon; const Dest : TBitmap; const UseFiltering : Boolean = True); overload;

implementation

uses Classes, Math, Resample, PrgSetupUnit;

Procedure SimpleStretch(const Source,Dest : TBitmap);
Type TScanLine=Array[0..MaxInt div 4-1] of TColor;
Var I,J,C,K0,L0,K1,L1,H,W : Integer;
    F,X,Y : Double;
    XVec, YVec : Array[0..1] of Double;
    C1,C2,C3 : Array of Byte;
    NewC1, NewC2, NewC3 : Byte;
begin
  W:=Source.Width;
  H:=Source.Height;

  SetLength(C1,W*H);
  SetLength(C2,W*H);
  SetLength(C3,W*H);
  For I:=0 to W-1 do For J:=0 to H-1 do begin
    C:=Source.Canvas.Pixels[I,J];
    C3[H*I+J]:=C and $FF; C:=C shr 8;
    C2[H*I+J]:=C and $FF; C:=C shr 8;
    C1[H*I+J]:=C and $FF;
  end;

  F:=W/Dest.Width;
  For I:=0 to Dest.Width-1 do For J:=0 to Dest.Height-1 do begin
    X:=I*F; Y:=J*F; K0:=Round(X); L0:=Round(Y); K1:=Min(K0+1,W-1); L1:=Min(L0+1,H-1);
    XVec[1]:=Frac(X); XVec[0]:=1-XVec[1]; YVec[1]:=Frac(Y); YVec[0]:=1-YVec[1];
    NewC1:=Round(C1[K0*H+L0]*XVec[0]*YVec[0]+C1[K1*H+L0]*XVec[1]*YVec[0]+C1[K0*H+L1]*XVec[0]*YVec[1]+C1[K1*H+L1]*XVec[1]*YVec[1]);
    NewC2:=Round(C2[K0*H+L0]*XVec[0]*YVec[0]+C2[K1*H+L0]*XVec[1]*YVec[0]+C2[K0*H+L1]*XVec[0]*YVec[1]+C2[K1*H+L1]*XVec[1]*YVec[1]);
    NewC3:=Round(C3[K0*H+L0]*XVec[0]*YVec[0]+C3[K1*H+L0]*XVec[1]*YVec[0]+C3[K0*H+L1]*XVec[0]*YVec[1]+C3[K1*H+L1]*XVec[1]*YVec[1]);
    Dest.Canvas.Pixels[I,J]:=TColor(Integer(NewC3)+256*Integer(NewC2)+256*256*Integer(NewC1));
  end;
end;

Function ScaleImage(const SourcePic : TPicture; const Factor : Double) : TBitmap;
Var Source : TBitmap;
var UseFilter : Integer;
begin
  UseFilter:=PrgSetup.ImageFilter-1;

  Source:=TBitmap.Create;
  try
    Source.Width:=SourcePic.Width;
    Source.Height:=SourcePic.Height;
    Source.Canvas.Draw(0,0,SourcePic.Graphic);
    result:=TBitmap.Create;
    result.Width:=Round(SourcePic.Width*Factor);
    result.Height:=Round(SourcePic.Height*Factor);
    If (UseFilter<1) or (UseFilter>7) then begin
      If (Factor<1) and (UseFilter=0) then begin
        SimpleStretch(Source,result);
      end else begin
        result.Canvas.StretchDraw(Rect(0,0,result.Width,result.Height),Source);
      end;
    end else begin
      Strecth(Source,result,ResampleFilters[Min(6,Max(0,UseFilter-1))].Filter,ResampleFilters[Min(6,Max(0,UseFilter-1))].Width);
    end;
  finally
    Source.Free;
  end;
end;

Procedure ScaleImage(const Source, Dest : TBitmap; const DestW, DestH : Integer; const UseFiltering : Boolean);
Var TempDest : TBitmap;
    W,H,UseFilter : Integer;
begin
  If UseFiltering then UseFilter:=PrgSetup.ImageFilter-1 else UseFilter:=0;

  TempDest:=TBitmap.Create;
  try
    TempDest.Width:=Min(DestW,Dest.Width);
    TempDest.Height:=Min(DestH,Dest.Height);

    If (UseFilter<1) or (UseFilter>7) then begin
      If (TempDest.Width<Source.Width) and (UseFilter=0) then begin
        SimpleStretch(Source,TempDest);
      end else begin
        TempDest.Canvas.StretchDraw(Rect(0,0,TempDest.Width,TempDest.Height),Source);
      end;
    end else begin
      Strecth(Source,TempDest,ResampleFilters[Min(6,Max(0,UseFilter-1))].Filter,ResampleFilters[Min(6,Max(0,UseFilter-1))].Width);
    end;

    W:=Dest.Width-TempDest.Width;
    H:=Dest.Height-TempDest.Height;

    Dest.Canvas.StretchDraw(Rect(W div 2,H div 2,Dest.Width-(W div 2),Dest.Height-(H div 2)),TempDest);
  finally
    TempDest.Free;
  end;
end;

Procedure ScaleImage(const Source, Dest : TBitmap; const UseFiltering : Boolean);
begin
  ScaleImage(Source,Dest,Dest.Width,Dest.Height,UseFiltering);
end;


Procedure ScaleImage(const Source : TPicture; const Dest : TBitmap; const UseFiltering : Boolean);
Var Temp : TBitmap;
begin
  Temp:=TBitmap.Create;
  try
    Temp.SetSize(Source.Width,Source.Height);
    Temp.Canvas.Draw(0,0,Source.Graphic);
    ScaleImage(Temp,Dest,UseFiltering);
  finally
    Temp.Free;
  end;
end;

Procedure ScaleImage(const Source : TIcon; const Dest : TBitmap; const UseFiltering : Boolean);
Var Temp : TBitmap;
begin
  Temp:=TBitmap.Create;
  try
    Temp.SetSize(Source.Width,Source.Height);
    Temp.Canvas.Draw(0,0,Source);
    ScaleImage(Temp,Dest,UseFiltering);
  finally
    Temp.Free;
  end;
end;

end.
