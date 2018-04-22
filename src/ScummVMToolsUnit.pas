unit ScummVMToolsUnit;
interface

uses Classes, PrgSetupUnit; {need to init PrgSetupUnit before init of this unit}

Type TScummVMGamesList=class
  private
    FName, FLongName : TStringList;
    FScummVMIniFile : String;
    Procedure LoadConfig;
    Procedure SaveConfig;
    function GetCount: Integer;
    Function LoadListFromScummVMFile(const ScummVMPrgFile : String) : Boolean;
    Function LoadListFromScummVMStringList(const St : TStringList) : Boolean;
    function GetScummVMIniFile: String;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadListFromScummVM(const WarnIfScummVMNotFound : Boolean; const CustomScummVMPath : String ='') : Boolean;
    Function NameFromDescription(const Description : String) : String;
    property Count : Integer read GetCount;
    property NamesList : TStringList read FName;
    property DescriptionList : TStringList read FLongName;
    property ScummVMIniFile : String read GetScummVMIniFile;
end;

Var ScummVMGamesList : TScummVMGamesList;

implementation

uses Windows, SysUtils, Dialogs, IniFiles, PrgConsts, LanguageSetupUnit,
     CommonTools;

{ TScummVMGamesList }

constructor TScummVMGamesList.Create;
begin
  inherited Create;

  FName:=TStringList.Create;
  FLongName:=TStringList.Create;
  LoadConfig;
  FScummVMIniFile:='';
end;

destructor TScummVMGamesList.Destroy;
begin
  SaveConfig;
  FName.Free;
  FLongName.Free;
  inherited Destroy;
end;

procedure TScummVMGamesList.LoadConfig;
Var Ini : TIniFile;
    I : Integer;
begin
  Ini:=TIniFile.Create(PrgDataDir+SettingsFolder+'\'+ScummVMConfOptFile);
  try
    Ini.ReadSections(FName);
    For I:=0 to FName.Count-1 do FLongName.Add(Ini.ReadString(FName[I],'Description',''));
  finally
    Ini.Free;
  end;
end;

procedure TScummVMGamesList.SaveConfig;
Var Ini : TIniFile;
    I : Integer;
begin
  If FName.Count=0 then begin
    ExtDeleteFile(PrgDataDir+SettingsFolder+'\'+ScummVMConfOptFile,ftProfile);
    exit;
  end;

  Ini:=TIniFile.Create(PrgDataDir+SettingsFolder+'\'+ScummVMConfOptFile);
  try
    For I:=0 to FName.Count-1 do Ini.WriteString(FName[I],'Description',FLongName[I]);
  finally
    Ini.Free;
  end;
end;

function TScummVMGamesList.GetCount: Integer;
begin
  result:=FName.Count;
end;

function TScummVMGamesList.GetScummVMIniFile: String;
begin
  result:=FScummVMIniFile;
  If result<>'' then exit;
  LoadListFromScummVM(False);
  result:=FScummVMIniFile;
end;

Function TScummVMGamesList.LoadListFromScummVM(const WarnIfScummVMNotFound : Boolean; const CustomScummVMPath : String) : Boolean;
Var S : String;
begin
  result:=False;

  FName.Clear;
  FLongName.Clear;

  If Trim(CustomScummVMPath)<>'' then begin
    S:=IncludeTrailingPathDelimiter(Trim(CustomScummVMPath))+ScummPrgFile;
  end else begin
    S:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile;
  end;
  If not FileExists(S) then begin
    if WarnIfScummVMNotFound then MessageDlg(Format(LanguageSetup.MessageFileNotFound,[S]),mtError,[mbOK],0);
    exit;
  end;

  result:=LoadListFromScummVMFile(S);
end;

function TScummVMGamesList.LoadListFromScummVMFile(const ScummVMPrgFile: String): Boolean;
Var St : TStringList;
begin
  result:=False;

  St:=RunAndGetOutput(ScummVMPrgFile,'-z',True);
  If St=nil then exit;
  try
    result:=LoadListFromScummVMStringList(St);
  finally
    St.Free;
  end;
end;

function TScummVMGamesList.LoadListFromScummVMStringList(const St: TStringList): Boolean;
Var I,Mode,J,K : Integer;
begin
  Mode:=0; J:=10;
  For I:=0 to St.Count-1 do Case Mode of
    0 : begin
          If I=0 then begin
            K:=Pos(':\',St[I]);
            If K>0 then FScummVMIniFile:=Copy(St[I],K-1,MaxInt);;
          end;
          If Copy(St[I],1,3)='---' then begin J:=Pos(' ',St[I]); Mode:=1; end;
        end;
    1 : begin FName.Add(Trim(Copy(St[I],1,J-1))); FLongName.Add(Trim(Copy(St[I],J+1,MaxInt))); end;
  end;
  result:=(Mode=1);
end;

function TScummVMGamesList.NameFromDescription(const Description: String): String;
Var I : Integer;
begin
  result:='';
  I:=FLongName.IndexOf(Description);
  If I>=0 then result:=FName[I];
end;

end.
