unit DataReaderToolsUnit;
interface

uses Classes;

Function DownloadTextFile(const URL: String; var Lines : String; const Referer : String =''): Boolean;
Function DownloadFileToDisk(const URL, FileName : String; const Referer : String ='') : Boolean;

Function EncodeName(const Name : String) : String;
Function DecodeName(const Name : String) : String;

Function GetTagContents(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const RequestAttributeName : String =''; const RequestAttributeValue : TStringList = nil; const RequestTextContent : String ='') : TStringList; overload;
Function GetTagContents(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const TagNr : Integer) : String; overload; {Nr=1,2,...: number from start; Nr=-1,-2,...: number from last}

Function GetJavascriptURLs(const Lines : String; const RequestTextContent : String) : TStringList;

Function GetTag(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const RequestAttributeName : String =''; const RequestAttributeValue : TStringList = nil) : TStringList; overload;
Function GetTag(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const TagNr : Integer) : String; overload; {Nr=1,2,...: number from start; Nr=-1,-2,...: number from last}

Function GetPlainText(const Lines : String; const IgnoreTags : TStrings = nil; StartTokens : TStrings = nil; const StoppTokens : TStrings = nil) : TStringList;

Function GetPlainDecodedText(Lines : String) : String;

implementation

uses SysUtils, Forms, IdHTTP, Math, CommonTools;

function DownloadFile(const URL, Referer: String): TMemoryStream;
Var HTTP: TIdHTTP;
begin
  if (LowerCase(Copy(URL,1,7))<>'http://') and (LowerCase(Copy(URL,1,8))<>'https://') and (LowerCase(Copy(URL,1,6))<>'ftp://') then begin result:=nil; exit; end;
                                                                                                                                                                 
  HTTP:=TIdHTTP.Create(Application.MainForm);
  try
    result:=TMemoryStream.Create;
    try
      HTTP.Request.UserAgent:='User-Agent=Mozilla/5.0 (Windows; U; Windows NT 6.0)';
      HTTP.Request.AcceptLanguage:='en';
      HTTP.Request.Referer:=Referer;
      HTTP.Get(URL,result);
    except
      FreeAndNil(result);
    end;
  finally
    HTTP.Free;
  end;
end;

Function RemoveLineBreaks(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  For I:=1 to length(S) do If (S[I]=#10) or (S[I]=#13) then result[I]:=' ';
end;

function DownloadTextFile(const URL: String; var Lines : String; const Referer : String): Boolean;
Var MSt : TMemoryStream;
begin
  MSt:=DownloadFile(URL,Referer);
  result:=(MSt<>nil); If not result then exit;
  try
    SetLength(Lines,MSt.Size);
    Move(MSt.Memory^,Lines[1],MSt.Size);
    Lines:=RemoveLineBreaks(Lines);
  finally
    MSt.Free;
  end;
end;

Function DownloadFileToDisk(const URL, FileName : String; const Referer : String) : Boolean;
Var MSt : TMemoryStream;
begin
  result:=False;
  MSt:=DownloadFile(URL,Referer); If MSt=nil then exit;
  result:=True;
  try
    try MSt.SaveToFile(FileName); except exit; end;
  finally
    MSt.Free;
  end;
end;

Function FindNext(const Lines : String; const Search : String; const From : Integer =1) : Integer;
Var S,T : String;
    I : Integer;
begin
  result:=0;
  If  Search=' ' then S:=' ' else S:=ExtUpperCase(Search);
  For I:=From to length(Lines)-length(S)+1 do begin
    T:=ExtUpperCase(Lines[I]); If T='' then T:=' ';
    If T[1]=S[1] then begin
      If ExtUpperCase(Copy(Lines,I+1,length(S)-1))=Copy(S,2,MaxInt) then begin
       result:=I; exit;
        end;
    end;
  end;
end;

Function EncodeName(const Name : String) : String;
Var I : Integer;
begin
  For I:=1 to length(Name) do Case Name[I] of
    ' ' : result:=result+'+';
    '/' : result:=result+'%2F';
    '#' : result:=result+'%23';
    '+' : result:=result+'%2B';
    '?' : result:=result+'%3F';
    '&' : result:=result+'%26';
    else result:=result+Name[I];
  end;
end;

Function TryHexStrToInt(const S : String; var Value : Integer) : Boolean;
Var I : Integer;
    T : String;
begin
  result:=True;
  Value:=0;
  T:=ExtUpperCase(S);
  For I:=1 to length(T) do Case T[I] of
    '0'..'9' : Value:=Value*16+(ord(T[I])-ord('0'));
    'A'..'F' : Value:=Value*16+(ord(T[I])-ord('A')+10);
    else result:=False; exit;
  End;
end;

Function DecodeName(const Name : String) : String;
const ReplaceFrom : Array[0..1] of String =('&nbsp;',Char($C3)+Char($B8));
      ReplaceTo : Array[0..1] of String =(' ',Char($F8));
Var S,T : String;
    I,J,K : Integer;
begin
  S:=Name; result:='';
  While S<>'' do begin
    I:=FindNext(S,'&#x'); If I=0 then begin result:=result+S; break; end;
    J:=FindNext(S,';',I+3); If J=0 then begin result:=result+S; break; end;
    T:=Copy(S,I+3,J-(I+3));
    If not TryHexStrToInt(T,K) then begin result:=result+Copy(S,1,J); S:=Copy(S,J+1,MaxInt); continue; end;
    result:=result+Copy(S,1,I-1)+Chr(K);
    S:=Copy(S,J+1,MaxInt);
  end;

  For J:=Low(ReplaceFrom) to High(ReplaceFrom) do begin
    S:=result; result:='';
    While S<>'' do begin
      I:=FindNext(S,ReplaceFrom[J]);
      If I=0 then begin result:=result+S; break; end;
      result:=result+copy(S,1,I-1)+ReplaceTo[J];
      S:=Copy(S,I+length(ReplaceFrom[J]),MaxInt);
    end;
  end;
end;

Function GetTagContents(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const RequestAttributeName : String =''; const RequestAttributeValue : TStringList = nil; const RequestTextContent : String ='') : TStringList;
Var Position,I,J,TagContentStart,Count,TagContentEnd : Integer;
    C : Char;
    Ok : Boolean;
    RequestValue,S : String;
begin
  result:=TStringList.Create;
  Position:=StartPosition;

  {Find "<Tag"}
  I:=FindNext(Lines,'<'+Tag,Position);
  While I>0 do begin
    Position:=I+length('<'+Tag);
    If Position>length(Lines) then exit;

    {Check if "<Tag" has a DataKey="DataValue" or DataKey='DataValue' attribute}
    If (Trim(TagAttributeName)='') and (Trim(RequestAttributeName)='') then begin
      while Position<length(Lines) do begin
        If Lines[Position]='>' then begin inc(Position); break; end;
        inc(Position);
      end;
      Ok:=True;
    end else begin
      RequestValue:='';
      Ok:=(Trim(TagAttributeName)='');
      while Position<length(Lines) do begin
        If Lines[Position]<>' ' then begin
          If (Trim(TagAttributeName)<>'') and (ExtUpperCase(Copy(Lines,Position,length(TagAttributeName)))=ExtUpperCase(TagAttributeName)) then begin
            inc(Position,length(TagAttributeName));
            If (Position>length(Lines)) or (Lines[Position]<>'=') then continue;
            inc(Position);
            If (Position>length(Lines)) or ((Lines[Position]<>'"') and (Lines[Position]<>'''')) then continue;
            C:=Lines[Position];
            inc(Position);
            If ExtUpperCase(Copy(Lines,Position,length(TagAttributeValue+C)))=ExtUpperCase(TagAttributeValue+C) then begin inc(Position,length(TagAttributeValue+C)); Ok:=True; end;
            continue;
          end;
          If (Trim(RequestAttributeName)<>'') and (ExtUpperCase(Copy(Lines,Position,length(RequestAttributeName)))=ExtUpperCase(RequestAttributeName)) then begin
            inc(Position,length(RequestAttributeName));
            If (Position>length(Lines)) or (Lines[Position]<>'=') then continue;
            inc(Position);
            If (Position>length(Lines)) or ((Lines[Position]<>'"') and (Lines[Position]<>'''')) then continue;
            C:=Lines[Position];
            inc(Position);
            I:=FindNext(Lines,C,Position);
            If I=0 then RequestValue:=Copy(Lines,Position,MaxInt) else begin
              RequestValue:=Copy(Lines,Position,(I-1)-Position+1);
              Position:=I+1;
            end;
            continue;
          end;
        end;
        If Lines[Position]='>' then begin inc(Position); break; end;
        inc(Position);
      end;
    end;

    {Find "</Tag", count open and closing tag to get the right one}
    If Ok then begin
      TagContentStart:=Position;
      TagContentEnd:=length(Lines);
      Count:=1;
      While (Count>0) and (Position<length(Lines)) do begin
        I:=FindNext(Lines,'<'+Tag,Position);
        J:=FindNext(Lines,'</'+Tag,Position);
        If (I=0) and (J=0) then break;
        If (I=0) or (J=0) then begin
          If I>0 then inc(Count) else dec(Count);
          TagContentEnd:=Max(I,J)-1;
          Position:=Max(I,J)+length(Tag);
        end else begin
          If I<J then inc(Count) else dec(Count);
          TagContentEnd:=Min(I,J)-1;
          Position:=Min(I,J)+length(Tag);
        end;
        While (Position<=length(Lines)) and (Lines[Position]<>'>') do inc(Position);
      end;

      S:=Copy(Lines,TagContentStart,TagContentEnd-TagContentStart+1);
      if RequestTextContent<>'' then begin
        if Pos(ExtUpperCase(RequestTextContent),ExtUpperCase(S))=0 then Ok:=False;
      end;
      if Ok then begin
        result.Add(S);
        If Assigned(RequestAttributeValue) then RequestAttributeValue.Add(RequestValue);
      end;
    end;

    I:=FindNext(Lines,'<'+Tag,Position);
  end;
end;

Function GetTagContents(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const TagNr : Integer) : String;
Var St : TStringList;
begin
  result:='';
  St:=GetTagContents(Lines,StartPosition,Tag,TagAttributeName,TagAttributeValue);
  try
    If (TagNr>0) and (St.Count>=TagNr) then result:=St[TagNr-1];
    If (TagNr<0) and (St.Count>=-TagNr) then result:=St[St.Count-TagNr];
  finally
    St.Free;
  end;
end;

Function GetJavascriptURLs(const Lines : String; const RequestTextContent : String) : TStringList;
Var S : String;
    St : TStringList;
    I,J : Integer;
begin
  result:=TStringList.Create;
  St:=GetTagContents(Lines,1,'script','type','text/javascript','',nil,RequestTextContent);
  try
    if St.Count=0 then exit;
    S:=St[0];
    While S<>'' do begin
      I:=FindNext(S,'http:/'+'/'); if I=0 then exit;
      S:=Copy(S,I,MaxInt);
      I:=FindNext(S,'"'); J:=FindNext(S,''''); if (I=0) and (J=0) then exit;
      if I=0 then I:=J else begin
        if J<>0 then I:=Min(I,J);
      end;
      result.add(Copy(S,1,I-1));
      S:=Copy(S,I+1,MaxInt);
    end;
  finally
    St.Free;
  end;
end;

Function GetTag(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const RequestAttributeName : String =''; const RequestAttributeValue : TStringList = nil) : TStringList;
Var Position,I,J,TagStart,Count,TagEnd : Integer;
    C : Char;
    Ok : Boolean;
    RequestValue : String;
begin
  result:=TStringList.Create;
  Position:=StartPosition;

  {Find "<Tag"}
  I:=FindNext(Lines,'<'+Tag,Position);
  While I>0 do begin
    TagStart:=I;
    Position:=I+length('<'+Tag);
    If Position>length(Lines) then exit;

    {Check if "<Tag" has a DataKey="DataValue" or DataKey='DataValue' attribute}
    If (Trim(TagAttributeName)='') and (Trim(RequestAttributeName)='') then begin
      while Position<length(Lines) do begin
        If Lines[Position]='>' then begin inc(Position); break; end;
        inc(Position);
      end;
      Ok:=True;
    end else begin
      RequestValue:='';
      Ok:=(Trim(TagAttributeName)='');
      while Position<length(Lines) do begin
        If Lines[Position]<>' ' then begin
          If (Trim(TagAttributeName)<>'') and (ExtUpperCase(Copy(Lines,Position,length(TagAttributeName)))=ExtUpperCase(TagAttributeName)) then begin
            inc(Position,length(TagAttributeName));
            If (Position>length(Lines)) or (Lines[Position]<>'=') then continue;
            inc(Position);
            If (Position>length(Lines)) or ((Lines[Position]<>'"') and (Lines[Position]<>'''')) then continue;
            C:=Lines[Position];
            inc(Position);
            If ExtUpperCase(Copy(Lines,Position,length(TagAttributeValue+C)))=ExtUpperCase(TagAttributeValue+C) then begin inc(Position,length(TagAttributeValue+C)); Ok:=True; end;
            continue;
          end;
          If (Trim(RequestAttributeName)<>'') and (ExtUpperCase(Copy(Lines,Position,length(RequestAttributeName)))=ExtUpperCase(RequestAttributeName)) then begin
            inc(Position,length(RequestAttributeName));
            If (Position>length(Lines)) or (Lines[Position]<>'=') then continue;
            inc(Position);
            If (Position>length(Lines)) or ((Lines[Position]<>'"') and (Lines[Position]<>'''')) then continue;
            C:=Lines[Position];
            inc(Position);
            I:=FindNext(Lines,C,Position);
            If I=0 then RequestValue:=Copy(Lines,Position,MaxInt) else begin
              RequestValue:=Copy(Lines,Position,(I-1)-Position+1);
              Position:=I+1;
            end;
            continue;
          end;
        end;
        If Lines[Position]='>' then begin inc(Position); break; end;
        inc(Position);
      end;
    end;

    {Find "</Tag", count open and closing tag to get the right one}
    If Ok then begin
      TagEnd:=length(Lines);
      Count:=1;
      While (Count>0) and (Position<length(Lines)) do begin
        I:=FindNext(Lines,'<'+Tag,Position);
        J:=FindNext(Lines,'</'+Tag,Position);
        If (I=0) and (J=0) then break;
        If (I=0) or (J=0) then begin
          If I>0 then inc(Count) else dec(Count);
          Position:=Max(I,J)+length(Tag);
        end else begin
          If I<J then inc(Count) else dec(Count);
          Position:=Min(I,J)+length(Tag);
        end;
        While (Position<=length(Lines)) and (Lines[Position]<>'>') do inc(Position);
        TagEnd:=Position;
      end;
      result.Add(Copy(Lines,TagStart,TagEnd-TagStart+1));
      If Assigned(RequestAttributeValue) then RequestAttributeValue.Add(RequestValue);
    end;

    I:=FindNext(Lines,'<'+Tag,Position);
  end;
end;

Function GetTag(const Lines : String; const StartPosition : Integer; Tag, TagAttributeName, TagAttributeValue : String; const TagNr : Integer) : String;
Var St : TStringList;
begin
  result:='';
  St:=GetTag(Lines,StartPosition,Tag,TagAttributeName,TagAttributeValue);
  try
    If (TagNr>0) and (St.Count>=TagNr) then result:=St[TagNr-1];
    If (TagNr<0) and (St.Count>=-TagNr) then result:=St[St.Count-TagNr];
  finally
    St.Free;
  end;
end;

Procedure GetTokens(const Lines : String; const Data : TStringList; const IsTag : TList);
Var P : Integer;
    InTag : Boolean;
    I,J : Integer;
begin
  P:=1;
  InTag:=False;

  While P<length(Lines) do begin

    if InTag then begin
      I:=FindNext(Lines,'>',P);
      If I=0 then exit;
      J:=FindNext(Lines,' ',P);
      If (J=0) or (J>I) then J:=I;
      Data.Add(ExtUpperCase(Copy(Lines,P,J-P)));
      IsTag.Add(TObject(1));
    end else begin
      I:=FindNext(Lines,'<',P);
      If I=0 then begin Data.Add(Copy(Lines,I,MaxInt)); IsTag.Add(TObject(0)); exit; end;
      If I>P then begin Data.Add(Copy(Lines,P,I-P)); IsTag.Add(TObject(0)); end;
    end;

    P:=I+1;
    InTag:=not InTag;
  end;
end;

Function GetPlainText(const Lines : String; const IgnoreTags : TStrings = nil; StartTokens : TStrings = nil; const StoppTokens : TStrings = nil) : TStringList;
Var Data : TStringList;
    IsTag : TList;
    InIgnoreMode : String;
    Started : Boolean;
    I : Integer;
    Token, S : String;
begin
  result:=TStringList.Create;
  result.Add('');

  If IgnoreTags<>nil then For I:=0 To IgnoreTags.Count-1 do IgnoreTags[I]:=ExtUpperCase(IgnoreTags[I]);
  If StartTokens<>nil then For I:=0 To StartTokens.Count-1 do StartTokens[I]:=ExtUpperCase(StartTokens[I]);
  If StoppTokens<>nil then For I:=0 To StoppTokens.Count-1 do StoppTokens[I]:=ExtUpperCase(StoppTokens[I]);

  Started:=(StartTokens=nil);

  Data:=TStringList.Create;
  IsTag:=TLIst.Create;
  try
    GetTokens(Lines,Data,IsTag);

    InIgnoreMode:='';
    For I:=0 To Data.Count-1 do begin
      Token:=Trim(Data[I]);
      If Token='' then  continue;
      if Integer(IsTag[I])=1 then begin
        {Tag}
        if (InIgnoreMode='') then begin
          if (IgnoreTags<>nil) and (IgnoreTags.IndexOf(Token)>=0) then InIgnoreMode:=Token;
          If (InIgnoreMode='') and Started then begin
            if (Token='BR') or (Token='BR/') or (Token='P') or (Token='DIV') or (Token='LI') then result.Add('');
          end;
        end else begin
          If Token='/'+InIgnoreMode then InIgnoreMode:='';
        end;
      end else begin
        {Text}
        If (StartTokens<>nil) and (StartTokens.IndexOf(ExtUpperCase(Token))>=0) then begin
           Started:=true;
           continue;
        end;
        If (StoppTokens<>nil) and (StoppTokens.IndexOf(ExtUpperCase(Token))>=0) then begin
           break;
        end;
        If (InIgnoreMode='') and Started then begin
          S:=result[result.Count-1];
          If (S<>'') and (S[length(S)]<>' ') and (Pos(Token[1],'.,;:')=0) then S:=S+' ';
          S:=S+Token;
          result[result.Count-1]:=S;
        end;
      end;
    end;
    
  finally
    Data.Free;
    IsTag.Free;
  end;

end;
{Var I,J : Integer;
    InTag : Boolean;
begin
  result:=TStringList.Create;
  I:=1; InTag:=False;
  While I<length(Lines) do begin
    If InTag then begin
      J:=FindNext(Lines,'>',I);
      If J=0 then exit;
    end else begin
      J:=FindNext(Lines,'<',I);
      If J=0 then begin result.Add(Copy(Lines,I,MaxInt)); exit; end;
      If J>I then result.Add(Copy(Lines,I,J-I));
    end;
    I:=J+1; InTag:=not InTag;
  end;
end;}

Function GetPlainDecodedText(Lines : String) : String;
Var S : String;
    I,J,Count : Integer;
    St : TStringList;
begin
  S:='';
  Count:=0;

  While Lines<>'' do begin
    I:=FindNext(Lines,'<div',1);
    J:=FindNext(Lines,'</div',1);

    If (I=0) and (J=0) then break;

    If (J=0) or ((I>0) and (I<J)) then begin
      If Count=0 then S:=Trim(S+' '+Copy(Lines,1,I-1));
      inc(Count);
      Lines:=Copy(Lines,I+4,MaxInt);
      continue;
    end;

    if (I=0) or ((J>0) and (J<I)) then begin
      J:=FindNext(Lines,'>',J+4);
      if J=0 then Lines:='' else begin
        If Count>0 then dec(Count);
        Lines:=Copy(Lines,J+1,MaxInt);
      end;
      continue;
    end;
  end;

  If Count=0 then S:=Trim(S+' '+Lines);

  St:=GetPlainText(S);
  try
    result:=Trim(St.Text);
  finally
    St.Free;
  end;

  if (length(result)>length('View History')) and (Copy(result,length(result)-length('View History')+1,MaxInt)='View History') then result:=Trim(Copy(result,1,length(result)-length('View History')));
  if (length(result)>length('Edit')) and (Copy(result,length(result)-length('Edit')+1,MaxInt)='Edit') then result:=Trim(Copy(result,1,length(result)-length('Edit')));
end;


end.
