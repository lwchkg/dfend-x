unit SimpleXMLUnit;
interface

uses Classes, GameDBUnit;

Type TSimpleXMLFileStyle=(sxfsDOG, sxfsDBGL);

Function WriteProfilesToXML(const GamesList : TList; const FileName : String; const FileStyle : TSimpleXMLFileStyle) : Boolean;
Function ImportXMLFile(const GameDB : TGameDB; const FileName : String) : String;

implementation

uses XMLDoc, XMLIntf, SysUtils, Forms, Math, CommonTools, PrgSetupUnit,
     DOSBoxUnit, GameDBToolsUnit, LanguageSetupUnit;

Procedure WriteProfilesToDOGXML(const St : TStringList; const GamesList : TList);
Var I,J,K,L : Integer;
    G : TGame;
    St2 : TStringList;
    S : String;
begin
  St.Add('<Document>');
  St.Add('<Export>');
  St.Add('<Version>1.0</Version>');
  St.Add('<Generator>D.O.G.</Generator>');
  St.Add('<RealGenerator>D-Fend Reloaded '+GetNormalFileVersionAsString+'</RealGenerator>');
  St.Add('</Export>');

  For I:=0 to GamesList.Count-1 do begin
    G:=TGame(GamesList[I]);

    St.Add('');
    St.Add('<Profile>');

    St.Add('  <Emulator>');
    St.Add('    <Type>DOSBox</Type>');
    St.Add('    <Version>0.72</Version>');
    If G.CustomDOSBoxDir='' then begin
      St.Add('    <Path>'+IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.DOSBoxSettings[0].DosBoxDir,PrgSetup.BaseDir))+'DOSBox.exe</Path>');
      St.Add('    <Name>DOSBox 0.72</Name>');
    end else begin
      St.Add('    <Path>'+IncludeTrailingPathDelimiter(MakeAbsPath(G.CustomDOSBoxDir,PrgSetup.BaseDir))+'DOSBox.exe</Path>');
      St.Add('    <Name>DOSBox 0.72 (Custom build)</Name>');
    end;
    St.Add('    <Configuration>');

    St.Add('      <Glide>0</Glide>');
    St.Add('      <Innovation>0</Innovation>');
    St.Add('      <MT32SoundQuality>0</MT32SoundQuality>');
    St.Add('      <OverScan>0</OverScan>');
    St.Add('      <VGAChipSet>0</VGAChipSet>');
    St.Add('      <VSync>0</VSync>');
    St.Add('      <Printer>0</Printer>');
    St.Add('      <Pixelshader>0</Pixelshader>');
    St.Add('      <Scalers>');
    St.Add('       <Display>"No Scaler","Normal 2x","Normal 3x","Advanced MAME 2x","Advanced MAME 3x","High-Quality 2x Magnification","High-Quality 3x Magnification","Scale and Interpolation 2x","Super Scale and Interpolation 2x","Super Eagle",'+'"Advanced Interpolation 2x","Advanced Interpolation 3x","TV Interlacing 2x","TV Interlacing 3x","RGB 2x","RGB 3x","Scan 2x","Scan 3x"</Display>');
    St.Add('       <Values>none,normal2x,normal3x,advmame2x,advmame3x,hq2x,hq3x,sai2x,super2xsai,supereagle,advinterp2x,advinterp3x,tv2x,tv3x,rgb2x,rgb3x,scan2x,scan3x</Values>');
    St.Add('      </Scalers>');
    St.Add('      <OutputDevices>');
    St.Add('       <Display>Surface,Overlay,OpenGL,"OpenGL NB","Direct Draw"</Display>');
    St.Add('       <Values>surface,overlay,opengl,openglnb,ddraw</Values>');
    St.Add('      </OutputDevices>');
    St.Add('      <Machines>');
    St.Add('       <Display>Hercules,CGA,Tandy,"IBM PCjr",VGA</Display>');
    St.Add('       <Values>hercules,cga,tandy,pcjr,vga</Values>');
    St.Add('      </Machines>');
    St.Add('      <Memory>');
    St.Add('       <Display>1MB,2MB,4MB,8MB,16MB,24MB,32MB,63MB</Display>');
    St.Add('       <Values>1,2,4,8,16,24,32,63</Values>');
    St.Add('      </Memory>');
    St.Add('      <Core>');
    St.Add('       <Display>Auto,Normal,Full,Dynamic</Display>');
    St.Add('       <Values>auto,normal,full,dynamic</Values>');
    St.Add('      </Core>');
    St.Add('      <JoystickType>');
    St.Add('       <Display>None,"2 axis","4 axis",Thrustmaster,Flightstick,Auto</Display>');
    St.Add('       <Values>none,2axis,4axis,fcs,ch,auto</Values>');
    St.Add('      </JoystickType>');
    St.Add('      <SoundQuality>');
    St.Add('       <Display>"8000 Hz","11025 Hz","22050 Hz","32000 Hz","44100 Hz"</Display>');
    St.Add('       <Values>8000,11025,22050,32000,44100</Values>');
    St.Add('      </SoundQuality>');
    St.Add('      <VGAChipset>');
    St.Add('       <Display>None,"Paradise PVGA1A","Tseng Labs ET3000","New Tseng Labs ET4000","Tseng Labs ET4000",S3</Display>');
    St.Add('       <Values>none,pvga1a,et3000,et4000new,et4000,s3</Values>');
    St.Add('      </VGAChipset>');
    St.Add('      <Pixelshader>');
    St.Add('       <Display>None,"Point Shader","Bilinear Shader","Scale 2x Shader","Sai 2x Shader"</Display>');
    St.Add('       <Values>none,point.fx,bilinear.fx,scale2x.fx,2xsai.fx</Values>');
    St.Add('      </Pixelshader>');
    St.Add('      <VSyncMode>');
    St.Add('       <Display>Off,On,Force,Host</Display>');
    St.Add('       <Values>off,on,force,host</Values>');
    St.Add('      </VSyncMode>');
    St.Add('      <VSyncRate>');
    St.Add('       <Display>60,65,70,75,80</Display>');
    St.Add('       <Values>60,65,70,75,80</Values>');
    St.Add('      </VSyncRate>');
    St.Add('      <PrintOutput>');
    St.Add('       <Display>"Bitmap Image","PNG Image","Postscript Document",Printer</Display>');
    St.Add('       <Values>bmp,png,ps,printer</Values>');
    St.Add('      </PrintOutput>');
    St.Add('      <PrinterDPIList>');
    St.Add('       <Display>300,360,600,800,1200,2400</Display>');
    St.Add('       <Values>300,300,600,800,1200,2400</Values>');
    St.Add('      </PrinterDPIList>');
    St.Add('      <InnovationQuality>');
    St.Add('       <Display>"Very Low",Low,Medium,High</Display>');
    St.Add('       <Values>0,1,2,3</Values>');
    St.Add('      </InnovationQuality>');
    St.Add('      <FullResolutions>');
    St.Add('       <Display>"Original Resolution",320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Display>');
    St.Add('       <Values>original,320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Values>');
    St.Add('      </FullResolutions>');
    St.Add('      <WindowResolutions>');
    St.Add('       <Display>"Original Resolution",320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Display>');
    St.Add('       <Values>original,320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Values>');
    St.Add('      </WindowResolutions>}');
    St.Add('    </Configuration>');
    St.Add('  </Emulator>');
    St.Add('  <Configuration>');
    St.Add('    <Information>');
    St.Add('      <Name>'+G.Name+'</Name>');
    S:=Trim(G.GameExe); If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    St.Add('      <ExeFilename>'+S+'</ExeFilename>');
    S:=Trim(G.SetupExe); If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    St.Add('      <SetupFilename>'+S+'</SetupFilename>');
    St.Add('      <EXECommandLine>'+G.GameParameters+'</EXECommandLine>');
    St.Add('      <SetupCommandLine>'+G.SetupParameters+'</SetupCommandLine>');
    St.Add('      <ExeStartDrive>Z</ExeStartDrive>');
    St.Add('      <SetupStartDrive>Z</SetupStartDrive>');
    St.Add('      <Develloper>'+G.Developer+'</Develloper>');
    St.Add('      <Developer>'+G.Developer+'</Developer>');
    St.Add('      <Publisher>'+G.Publisher+'</Publisher>');
    St.Add('      <Genre>'+G.Genre+'</Genre>');
    St.Add('      <Year>'+G.Year+'</Year>');
    St.Add('      <Working>1</Working>');
    St.Add('      <ConfFile>&lt;DOGHOME&gt;confs\'+ExtractFileName(G.SetupFile)+'</ConfFile>');
    St.Add('      <ProfileFile></ProfileFile>');
    St.Add('      <Language>'+G.Language+'</Language>');
    S:=Trim(G.Icon); If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    St.Add('      <Icon>'+S+'</Icon>');
    St.Add('      <Note>');
    St2:=StringToStringList(G.Notes);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Note>');
    St.Add('      <CustomInformation>');
    St2:=StringToStringList(G.UserInfo);
    try
      For J:=0 to St2.Count-1 do begin
        S:=St2[J]; K:=Pos('=',S);
        If K=0 then begin
          St.Add('<Title'+IntToStr(K)+'></Title'+IntToStr(K)+'>');
          St.Add('<Custom0'+IntToStr(K)+'>'+S+'</Custom0'+IntToStr(K)+'>');
        end else begin
          St.Add('<Title'+IntToStr(K)+'>'+Copy(S,1,K-1)+'</Title'+IntToStr(K)+'>');
          St.Add('<Custom0'+IntToStr(K)+'>'+Copy(S,K+1,MaxInt)+'</Custom0'+IntToStr(K)+'>');
        end;
      end;
    finally
      St2.Free;
    end;
    St.Add('      </CustomInformation>');
    St.Add('      <LinkedFiles>');
    For L:=1 to 9 do If Trim(G.WWW[L])<>'' then begin
       St.Add('        <Title'+IntToStr(L-1)+'>'+G.WWWName[L]+'</Title'+IntToStr(L-1)+'>');
       St.Add('      <Link'+IntToStr(L-1)+'>'+G.WWW[L]+'</Link'+IntToStr(L-1)+'>');
    end;
    St.Add('      </LinkedFiles>');
    St.Add('    </Information>');
    St.Add('    <Settings>');
    St.Add('      <Full-Configuration>');
    St2:=BuildConfFile(G,False,False,-1,nil,false); if St2=nil then exit;
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Full-Configuration>');
    St.Add('      <Manual-Configuration>');
    St2:=StringToStringList(G.CustomSettings);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Manual-Configuration>');
    St.Add('      <Manual-AutoExec>');
    St.Add('      <![CDATA[#INITIALIZATION');
    St2:=StringToStringList(G.Autoexec);
    try St.AddStrings(St2); finally St2.Free; end;
    St.Add('#FINALIZATION]]>');
    St2:=StringToStringList(G.AutoexecFinalization);
    try St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Manual-AutoExec>');
    St.Add('      <Addons>');
    St.Add('        <DOS32A>');
    If G.UseDOS32A then St.Add('          <Used>1</Used>') else St.Add('          <Used>0</Used>');
    St.Add('        </DOS32A>');
    St.Add('        <i4DOS>');
    If G.Use4DOS then St.Add('          <Used>1</Used>') else St.Add('          <Used>0</Used>');
    St.Add('        </i4DOS>');
    St.Add('        <CWSDPMI>');
    St.Add('          <Used>0</Used>');
    St.Add('          <SwapFile>0</SwapFile>');
    St.Add('          <DPMI10>0</DPMI10>');
    St.Add('        </CWSDPMI>');
    St.Add('        <Mouse>');
    If G.AutoLockMouse then St.Add('          <AutoLock>1</AutoLock>') else St.Add('          <AutoLock>0</AutoLock>');
    St.Add('        </Mouse>');
    St.Add('        <Screen>');
    St.Add('          <RenderFix>0</RenderFix>');
    St.Add('        </Screen>');
    St.Add('      </Addons>');
    St.Add('    </Settings>');
    St.Add('    <AttachedFiles/>');
    St.Add('    <DataFiles/>');
    St.Add('  </Configuration>');
    St.Add('</Profile>');
  end;

  St.Add('</Document>');
end;

Procedure WriteProfilesToDBGLXML(const St : TStringList; const GamesList : TList);
Var I,J,K : Integer;
    G : TGame;
    S : String;
    St2 : TStringList;
begin
  St.Add('<profiles>');
  St.Add('<export>');
  St.Add('<format-version>1.0</format-version>');
  St.Add('<title>D-Fend exported games</title>');
  If GamesList.Count>0 then S:=TGame(GamesList[0]).Name;
  For I:=1 to GamesList.Count-1 do S:=S+', '+TGame(GamesList[I]).Name;
  St.Add('<notes><![CDATA['+S+']]></notes>');
  St.Add('<generator-title>DOSBox Game Launcher</generator-title>');
  St.Add('<generator-version>0.62</generator-version>');
  St.Add('<RealGenerator>D-Fend Reloaded '+GetNormalFileVersionAsString+'</RealGenerator>');
  St.Add('<captures-available>false</captures-available>');
  St.Add('<gamedata-available>false</gamedata-available>');
  St.Add('</export>');

  For I:=0 to GamesList.Count-1 do begin
    G:=TGame(GamesList[I]);

    St.Add('');
    St.Add('<Profile>');
    St.Add('  <title>'+G.Name+'</title>');
    St.Add('  <meta-info>');

    St.Add('    <developer>'+G.Developer+'</developer>');
    St.Add('    <publisher>'+G.Publisher+'</publisher>');
    St.Add('    <year>'+G.Year+'</year>');
    St.Add('    <genre>'+G.Genre+'</genre>');
    St.Add('    <status></status>');
    St.Add('    <ConfFile>&lt;DOGHOME&gt;confs\'+ExtractFileName(G.SetupFile)+'</ConfFile>');
    St.Add('      <ProfileFile></ProfileFile>');
    St.Add('      <Language>'+G.Language+'</Language>');
    St.Add('      <notes>');
    St2:=StringToStringList(G.Notes);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </notes>');
    St2:=StringToStringList(G.UserInfo);
    try
      For J:=0 to Min(St2.Count,10)-1 do
        St.Add('      <custom'+IntToStr(J)+'>'+St2[J]+'</custom'+IntToStr(J)+'>');
    finally
      St2.Free;
    end;
    For K:=1 to 9 do If Trim(G.WWW[K])<>'' then begin
      St.Add('    <link'+IntToStr(K)+'>'+G.WWW[K]+'</link'+IntToStr(K)+'>');
    end;
    St.Add('  </meta-info>');
    St.Add('  <full-configuration>');
    St2:=BuildConfFile(G,False,False,-1,nil,false); if St2=nil then exit;
    try If St2.Count>0 then begin St2[0]:='    <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('  </full-configuration>');
    St.Add('  <incremental-configuration>');
    St2:=BuildConfFile(G,False,False,-1,nil,false); if St2=nil then exit;
    try If St2.Count>0 then begin St2[0]:='    <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('  </incremental-configuration>');
    St.Add('  <dosbox>');
    St.Add('    <title>DOSBox v0.72</title>');
    St.Add('    <version>0.72</version>');
    St.Add('    <captures>'+G.CaptureFolder+'</captures>');
    St.Add('    <game>'+G.GameExe+'</game>');
    St.Add('    <game-parameters>'+G.GameParameters+'</game-parameters>');
    St.Add('    <setup>'+G.SetupExe+'</setup>');
    St.Add('    <setup-parameters>'+G.SetupParameters+'</setup-parameters>');
    If G.GameExe='' then S:='' else begin
      S:=MakeRelPath(ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir)),PrgSetup.BaseDir);
      If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    end;
    St.Add('    <game-dir>'+S+'</game-dir>');
    St.Add('  </dosbox>');
    St.Add('</profile>');
  end;
  St.Add('</profiles>');
end;

Function WriteProfilesToXML(const GamesList : TList; const FileName : String; const FileStyle : TSimpleXMLFileStyle) : Boolean;
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    St.Add('<?xml version="1.0" encoding="UTF-8"?>');
    St.Add('');
    Case FileStyle of
      sxfsDOG  : WriteProfilesToDOGXML(St,GamesList);
      sxfsDBGL : WriteProfilesToDBGLXML(St,GamesList);
      else result:=false; exit;
    end;
    result:=True;
    try St.SaveToFile(FileName); except result:=False; end;
  finally
    St.Free;
  end;
end;

Type TXMLType=(xtDOG, xtDBGL);

Function MakeGameProfileFromXML(const GameDB : TGameDB; Profile : IXMLNode; const XMLType : TXMLType) : TGame;
Var N : IXMLNode;
    S : String;
begin
  result:=nil;

  Case XMLType of
    xtDBGL : N:=Profile.ChildNodes['title'];
    xtDOG : begin
              N:=Profile.ChildNodes['Configuration'];
              If N<>nil then N:=N.ChildNodes['Information'];
              If N<>nil then N:=N.ChildNodes['Name'];
            end;
    else exit;
  end;
  If N=nil then S:='Game' else S:=N.NodeName;
  result:=GameDB[GameDB.Add(S)];
end;

Procedure LoadMetaInfoFromXML(const G : TGame; Profile : IXMLNode; const XMLType : TXMLType);
Var St : TStringList;
    N,N2,N3 : IXMLNode;
    I,J,K : Integer;
    S : String;
begin
  St:=TStringList.Create;
  try
    If XMLType=xtDBGL then begin
      N:=Profile.ChildNodes['meta-info'];
      If N<>nil then For I:=0 to N.ChildNodes.Count-1 do begin
        N2:=N.ChildNodes[I];
        S:=Trim(ExtUpperCase(N2.NodeName));
        If S='DEVELOPER' then begin G.Developer:=N2.Text; continue; end;
        If S='PUBLISHER' then begin G.Publisher:=N2.Text; continue; end;
        If S='YEAR' then begin G.Year:=N2.Text; continue; end;
        If S='GENRE' then begin G.Genre:=N2.Text; continue; end;
        If S='NOTES' then begin G.Notes:=N2.Text; continue; end;
        For K:=1 to 9 do If S='LINK'+IntToStr(K) then begin G.WWW[K]:=N2.Text; continue; end;
        St.Add(N2.NodeName+'='+N2.Text);
      end;
    end;
    If XMLType=xtDOG then begin
      N:=Profile.ChildNodes['Configuration'];
      If N<>nil then N:=N.ChildNodes['Information'];
      If N<>nil then For I:=0 to N.ChildNodes.Count-1 do begin
        N2:=N.ChildNodes[I];
        S:=Trim(ExtUpperCase(N2.NodeName));
        If S='DEVELOPER' then begin G.Developer:=N2.Text; continue; end;
        If S='PUBLISHER' then begin G.Publisher:=N2.Text; continue; end;
        If S='YEAR' then begin G.Year:=N2.Text; continue; end;
        If S='GENRE' then begin G.Genre:=N2.Text; continue; end;
        If S='NOTES' then begin G.Notes:=N2.Text; continue; end;
        If S='LANGUAGE' then begin G.Language:=N2.Text; continue; end;
        If S='ICON' then begin G.Icon:=N2.Text; continue; end;
        If S='WORKING' then begin St.Add(N2.NodeName+'='+N2.Text); continue; end;
        If S='CUSOMINFORMATION' then For J:=0 to N2.ChildNodes.Count-1 do begin N3:=N2.ChildNodes[J]; St.Add(N3.NodeName+'='+N3.Text); end;
      end;
    end;
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

Procedure LoadFullConfiguration(const AGameDB : TGameDB; const G : TGame; Profile : IXMLNode; const XMLType : TXMLType);
Var N : IXMLNode;
begin
  If XMLType=xtDBGL then begin
    N:=Profile.ChildNodes['full-configuration'];
  end;

  If XMLType=xtDOG then begin
    N:=Profile.ChildNodes['Configuration'];
    If N<>nil then N:=N.ChildNodes['Settings'];
    If N<>nil then N:=N.ChildNodes['Full-Configuration'];
  end;

  If N<>nil then begin
    ImportConfData(AGameDB,G,N.Text);
  end;  
end;

Procedure LoadSpecialDBGLData(const G : TGame; Profile : IXMLNode);
Var N,N2 : IXMLNode;
    I : Integer;
    S : String;
begin
  N:=Profile.ChildNodes['dosbox'];
  If N=nil then exit;

  For I:=0 to N.ChildNodes.Count-1 do begin
    N2:=N.ChildNodes[I];
    S:=Trim(ExtUpperCase(N2.NodeName));
    If S='CAPTURES' then begin
      S:=N2.Text;
      If (length(S)<2) or (S[2]<>':') then begin
        if length(S)>=1 then begin
          If S[1]='\' then S:='.'+S;
          If S[1]<>'.' then S:='.\'+S;
        end;
      end;
      G.CaptureFolder:=S;
      continue;
    end;
    If S='SETUP' then begin G.SetupExe:=N2.Text; continue; end;
    If S='SETUP-PARAMETERS' then begin G.SetupParameters:=N2.Text; continue; end;
  end;
end;

Function DOGFileNameToFileName(const DOGFileName : String) : String;
const DOGString1='&lt;DOGDRIVE&gt;';
      DOGString2='<DOGDRIVE>';
begin
  result:=Trim(DOGFileName);
  If ExtUpperCase(Copy(result,1,length(DOGString1)))=ExtUpperCase(DOGString1) then result:=Trim(Copy(result,length(DOGString1)+1,MaxInt));
  If ExtUpperCase(Copy(result,1,length(DOGString2)))=ExtUpperCase(DOGString2) then result:=Trim(Copy(result,length(DOGString2)+1,MaxInt));
  if length(result)>=1 then begin
    If result[1]='\' then result:='.'+result;
    If result[1]<>'.' then result:='.\'+result;
  end;
end;

Function ReadValue(const N : IXMLNode; const IntegerKey, DataKey : String; var Data : String) : Boolean;
Var I,ValNr : Integer;
    N2,Values : IXMLNode;
    St : TStringList;
begin
  result:=False;

  ValNr:=-1;
  For I:=0 to N.ChildNodes.Count-1 do begin
    N2:=N.ChildNodes[I];
    If Trim(ExtUpperCase(N2.NodeName))=ExtUpperCase(IntegerKey) then begin
      try ValNr:=StrToInt(N2.Text); except continue; end;
      break;
    end;
  end;
  If ValNr<0 then exit;

  For I:=0 to N.ChildNodes.Count-1 do begin
    N2:=N.ChildNodes[I];
    If Trim(ExtUpperCase(N2.NodeName))=ExtUpperCase(DataKey) then begin
      Values:=N2.ChildNodes['Values'];
      If Values<>nil then begin
        St:=ValueToList(Values.Text,',');
        try
          result:=(St.Count>ValNr);
          if result then Data:=Trim(St[ValNr]);
          exit;
        finally
          St.Free;
        end;
      end;
    end;
  end;
end;

Procedure LoadSpecialDOGData(const G : TGame; Profile : IXMLNode);
Var N,N2,N3 : IXMLNode;
    S : String;
begin
  N:=Profile.ChildNodes['Emulator'];
  If N<>nil then begin

    N2:=N.ChildNodes['Path'];
    If N2<>nil then G.CustomDOSBoxDir:=MakeRelPath(N2.Text,PrgSetup.BaseDir,True);

    N2:=N.ChildNodes['Configuration'];
    If N2<>nil then begin
      N3:=N2.ChildNodes['Glide'];
      If N3<>nil then begin
        if N3.Text='0' then G.GlideEmulation:='flase' else G.GlideEmulation:='true';
      end;
      If ReadValue(N2,'VGAChipSet','VGAChipset',S) then G.VGAChipset:=S;
      If ReadValue(N2,'Printer','PrintOutput',S) then begin
        G.PrinterOutputFormat:=S;
        G.EnablePrinterEmulation:=(ExtUpperCase(S)<>'NONE');
      end;
    end;

  end;

  N:=Profile.ChildNodes['Configuration'];
  If N<>nil then begin

    N2:=N.ChildNodes['Information'];
    If N2<>nil then begin
      N3:=N2.ChildNodes['ExeFilename'];
      If N3<>nil then G.GameExe:=DOGFileNameToFileName(N3.Text);
      N3:=N2.ChildNodes['SetupFilename'];
      If N3<>nil then G.SetupExe:=DOGFileNameToFileName(N3.Text);
      N3:=N2.ChildNodes['EXECommandLine'];
      If N3<>nil then G.GameParameters:=N3.Text;
      N3:=N2.ChildNodes['SetupCommandLine'];
      If N3<>nil then G.SetupParameters:=N3.Text;
    end;

    N2:=N.ChildNodes['Settings'];
    If N2<>nil then N2:=N2.ChildNodes['Addons'];
    If N2<>nil then begin
      N3:=N2.ChildNodes['DOS32A'];
      If N3<>nil then begin
        N3:=N3.ChildNodes['Used'];
        If (N3<>nil) and (N3.Text<>'0') then G.UseDOS32A:=True;
      end;
      N3:=N2.ChildNodes['i4DOS'];
      If N3<>nil then begin
        N3:=N3.ChildNodes['Used'];
        If (N3<>nil) and (N3.Text<>'0') then G.Use4DOS:=True;
      end;
      N3:=N2.ChildNodes['Mouse'];
      If N3<>nil then begin
        N3:=N3.ChildNodes['AutoLock'];
        If (N3<>nil) and (N3.Text<>'0') then G.AutoLockMouse:=True;
      end;
    end;

  end;
end;

Function ImportProfileFromXML(const GameDB : TGameDB; Profile : IXMLNode; const XMLType : TXMLType) : String;
Var G : TGame;
begin
  result:='';

  G:=MakeGameProfileFromXML(GameDB,Profile,XMLType);
  If G=nil then exit;

  LoadMetaInfoFromXML(G,Profile,XMLType);
  LoadFullConfiguration(GameDB,G,Profile,XMLType);

  If XMLType=xtDBGL then LoadSpecialDBGLData(G,Profile);
  If XMLType=xtDOG then LoadSpecialDOGData(G,Profile);

  G.StoreAllValues;
  G.LoadCache;
end;

Function ImportXMLFileIntern(const GameDB : TGameDB; Root : IXMLNode; const XMLType : TXMLType) : String;
Var I : Integer;
begin
  result:='';

  For I:=0 to Root.ChildNodes.Count-1 do If Trim(ExtUpperCase(Root.ChildNodes[I].NodeName))='PROFILE' then begin
    result:=ImportProfileFromXML(GameDB,Root.ChildNodes[I],XMLType);
    If result<>'' then exit;
  end;
end;

Function ImportXMLFile(const GameDB : TGameDB; const FileName : String) : String;
Var XMLDoc : TXMLDocument;
    MSt : TMemoryStream;
    S : String;
begin
  result:='';

  XMLDoc:=TXMLDocument.Create(Application.MainForm);
  try
    MSt:=TMemoryStream.Create;
    try
      try MSt.LoadFromFile(FileName); except result:=Format(LanguageSetup.MessageCouldNotOpenFile,[FileName]); exit; end;
      XMLDoc.LoadFromStream(MSt);
    finally
      MSt.Free;
    end;
    XMLDoc.FileName:=FileName;

    If not XMLDoc.Active then begin
      {result:=LanguageSetup.MessageCouldNotActivateXMLDocument;}
      result:='Could not activte the XML document.';
      exit;
    end;

    S:=Trim(ExtUpperCase(XMLDoc.DocumentElement.NodeName));
    If S='DOCUMENT' then begin result:=ImportXMLFileIntern(GameDB,XMLDoc.DocumentElement,xtDOG); exit; end;
    If S='PROFILES' then begin result:=ImportXMLFileIntern(GameDB,XMLDoc.DocumentElement,xtDBGL); exit; end;
    {result:=Format(LanguageSetup.MessageUnknownXMLType,[XMLDoc.DocumentElement.NodeName]);}
    result:=Format('Unknown document type "%s".',[XMLDoc.DocumentElement.NodeName]);
  finally
    XMLDoc.Free;
  end;
end;

end.
