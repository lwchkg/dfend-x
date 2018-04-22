unit SetupFrameLanguageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameLanguage = class(TFrame, ISetupFrame)
    LanguageLabel: TLabel;
    DosBoxLangLabel: TLabel;
    LanguageInfoLabel: TLabel;
    InstallerLangLabel: TLabel;
    InstallerLangInfoLabel: TLabel;
    LanguageComboBox: TComboBox;
    DosBoxLangEditComboBox: TComboBox;
    LanguageOpenEditor: TBitBtn;
    LanguageNew: TBitBtn;
    InstallerLangEditComboBox: TComboBox;
    Timer: TTimer;
    procedure LanguageComboBoxChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure InstallerLangEditComboBoxChange(Sender: TObject);
    procedure DosBoxLangEditComboBoxChange(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
    JustLoading : Boolean;
    PDosBoxDir, PDOSBoxLang : PString;
    BeforeLanguageChangeNotify, LanguageChangeNotify : TSimpleEvent;
    OpenLanguageEditor : TOpenLanguageEditorEvent;
    InstallerLang : Integer;
    LangTimerCounter : Integer;
    procedure ReadCurrentInstallerLanguage;
    Function ExtendLanguageName(const ShortName : String) : String;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Registry, ShellAPI, Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     CommonTools, PrgConsts, HelpConsts;

{$R *.dfm}

{ TSetupFrameLanguage }

constructor TSetupFrameLanguage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DosBoxLang:=TStringList.Create;
  JustLoading:=False;
end;

destructor TSetupFrameLanguage.Destroy;
begin
  DosBoxLang.Free;
  inherited Destroy;
end;

function TSetupFrameLanguage.GetName: String;
begin
  result:=LanguageSetup.SetupFormLanguageSheet;
end;

procedure TSetupFrameLanguage.InitGUIAndLoadSetup(var InitData: TInitData);
Var St : TStringList;
    I : Integer;
begin
  NoFlicker(LanguageComboBox);
  NoFlicker(LanguageOpenEditor);
  NoFlicker(LanguageNew);
  NoFlicker(DosBoxLangEditComboBox);
  NoFlicker(InstallerLangEditComboBox);

  PDosBoxDir:=InitData.PDosBoxDir;
  PDOSBoxLang:=InitData.PDOSBoxLang;
  BeforeLanguageChangeNotify:=InitData.BeforeLanguageChangeNotify;
  LanguageChangeNotify:=InitData.LanguageChangeNotify;
  OpenLanguageEditor:=InitData.OpenLanguageEditorEvent;

  JustLoading:=True;
  try
    St:=GetLanguageList;
    try
      LanguageComboBox.Items.AddStrings(St);
      InstallerLangEditComboBox.Items.AddStrings(St);
    finally
      St.Free;
    end;
    I:=FindLanguageInList(ChangeFileExt(PrgSetup.Language,''),LanguageComboBox.Items);
    If I>=0 then LanguageComboBox.ItemIndex:=I else begin
      I:=FindEnglishInList(LanguageComboBox.Items);
      If I>=0 then LanguageComboBox.ItemIndex:=I else begin
        If LanguageComboBox.Items.Count>0 then LanguageComboBox.ItemIndex:=0;
      end;
    end;

    LanguageComboBoxChange(self); {to set up outdated warning}

    ShowFrame(True); {set DOSBox languag combo box}

    ReadCurrentInstallerLanguage;
  finally
    JustLoading:=False;
  end;

  SetComboHint(LanguageComboBox);
  SetComboHint(DosBoxLangEditComboBox);
  SetComboHint(InstallerLangEditComboBox);
end;

procedure TSetupFrameLanguage.ComboBoxDropDown(Sender: TObject);
begin
  SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TSetupFrameLanguage.InstallerLangEditComboBoxChange(Sender: TObject);
Var I : Integer;
begin
  Timer.Enabled:=False;
  If InstallerLangEditComboBox.ItemIndex<0 then exit;
  I:=Integer(InstallerLangEditComboBox.Items.Objects[InstallerLangEditComboBox.ItemIndex]);
  If (I=InstallerLang) or (I=-1) then exit;

  If FileExists(PrgDir+'SetInstallerLanguage.exe') then begin
    ShellExecute(Handle,'open',PChar(PrgDir+'SetInstallerLanguage.exe'),PChar(IntToStr(I)),nil,SW_SHOW);
  end else begin
    ShellExecute(Handle,'open',PChar(PrgDir+BinFolder+'\'+'SetInstallerLanguage.exe'),PChar(IntToStr(I)),nil,SW_SHOW);
  end;
  SetComboHint(InstallerLangEditComboBox);
  LangTimerCounter:=10;
  Timer.Enabled:=True;
end;

procedure TSetupFrameLanguage.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameLanguage.LoadLanguage;
begin
  LanguageLabel.Caption:=LanguageSetup.SetupFormLanguage;
  LanguageOpenEditor.Caption:=LanguageSetup.SetupFormLanguageOpenEditor;
  LanguageNew.Caption:=LanguageSetup.SetupFormLanguageOpenEditorNew;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;
  DosBoxLangEditComboBox.Hint:=LanguageSetup.SetupFormDosBoxLangHint;
  InstallerLangLabel.Caption:=LanguageSetup.SetupFormInstallerLang;
  InstallerLangInfoLabel.Caption:=LanguageSetup.SetupFormInstallerLangInfo;

  HelpContext:=ID_FileOptionsLanguage;
end;

Procedure FindAndAddLngFiles(const Dir : String; const St, St2 : TStrings);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(Dir+'*.lng',faAnyFile,Rec);
  try
    while I=0 do begin
      St.Add(ChangeFileExt(Rec.Name,''));
      St2.Add(Dir+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function TSetupFrameLanguage.ExtendLanguageName(const ShortName : String) : String;
Var I : Integer;
    ShortNameUpper : String;
    S,T : String;
begin
  ShortNameUpper:=ExtUpperCase(ShortName);
  For I:=0 to LanguageComboBox.Items.Count-1 do begin
    S:=LanguageComboBox.Items[I];
    If Pos('(',S)=0 then continue;
    T:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then continue;
    T:=Copy(T,1,Pos(')',T)-1);
    If ExtUpperCase(T)=ShortNameUpper then begin result:=S; exit; end;
  end;

  result:=ShortName;
end;

procedure TSetupFrameLanguage.DOSBoxDirChanged;
Var S,S2 : String;
    St : TStringList;
    I,J : Integer;
begin
  S:=DosBoxLangEditComboBox.Text;
  If Pos('(',S)>0 then begin
    S2:=Copy(S,Pos('(',S)+1);
    If Pos(')',S2)>0 then S2:=Copy(S2,1,Pos(')',S2)-1);
    If S2<>'' then S:=S2;
  end;

  DosBoxLangEditComboBox.Items.Clear;
  DosBoxLang.Clear;

  St:=TStringList.Create;
  try
    St.Add('English'); DosBoxLang.Add('');
    FindAndAddLngFiles(IncludeTrailingPathDelimiter(PDosBoxDir^),St,DosBoxLang);
    FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',St,DosBoxLang);

    I:=St.IndexOf(S);
    If I<0 then I:=St.IndexOf('English');

    For J:=0 to St.Count-1 do DosBoxLangEditComboBox.Items.Add(ExtendLanguageName(St[J]));
    If St.Count>0 then DosBoxLangEditComboBox.ItemIndex:=Max(0,I);
  finally
    St.Free;
  end;
end;

procedure TSetupFrameLanguage.DosBoxLangEditComboBoxChange(Sender: TObject);
begin
  PDOSBoxLang^:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];
  SetComboHint(DosBoxLangEditComboBox);
end;

procedure TSetupFrameLanguage.ShowFrame(const AdvancedMode: Boolean);
Var I,J : Integer;
    S : String;
begin
  DOSBoxDirChanged;
  I:=-1; S:=ExtractFileName(PDOSBoxLang^);
  For J:=0 to DosBoxLang.Count-1 do if S=ExtractFileName(DosBoxLang[J]) then begin I:=J; break; end;
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
end;

procedure TSetupFrameLanguage.HideFrame;
begin
end;

procedure TSetupFrameLanguage.RestoreDefaults;
begin
end;

procedure TSetupFrameLanguage.SaveSetup;
begin
  PrgSetup.Language:=ShortLanguageName(LanguageComboBox.Text)+'.ini';
  PrgSetup.DOSBoxSettings[0].DosBoxLanguage:=PDOSBoxLang^;
end;

Function VersionStringToInt(S : String) : Integer;
Var I : Integer;
    T : String;
begin
  result:=0;
  S:=Trim(S);

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256*256; except end;

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256; except end;

  try result:=result+StrToInt(S); except end;
end;

procedure TSetupFrameLanguage.LanguageComboBoxChange(Sender: TObject);
Var S : String;
begin
  If not JustLoading then begin
    BeforeLanguageChangeNotify;
    LanguageSetupUnit.LoadLanguage(ShortLanguageName(LanguageComboBox.Text)+'.ini');
    LanguageChangeNotify;
  end;

  S:=Trim(LanguageSetup.MaxVersion);
  If (S='') or (S='0') then begin
    LanguageInfoLabel.Visible:=True;
    LanguageInfoLabel.Caption:=LanguageSetup.LanguageNoVersion;
  end else begin
    If (VersionStringToInt(S) div 256)<(VersionStringToInt(GetNormalFileVersionAsString) div 256) then begin
      LanguageInfoLabel.Visible:=True;
      LanguageInfoLabel.Caption:=Format(LanguageSetup.LanguageOutdated,[LanguageSetup.MaxVersion,GetNormalFileVersionAsString]);
    end else begin
      LanguageInfoLabel.Visible:=False;
    end;
  end;

  SetComboHint(LanguageComboBox);
end;

procedure TSetupFrameLanguage.ButtonWork(Sender: TObject);
begin
  If MessageDlg(LanguageSetup.SetupFormLanguageOpenEditorConfirmation,mtConfirmation,[mbOK,mbCancel],0)=mrOK then
    OpenLanguageEditor((Sender as TComponent).Tag+1);
end;

procedure TSetupFrameLanguage.ReadCurrentInstallerLanguage;
Var Reg : TRegistry;
    I, SelLang : Integer;
begin
  InstallerLang:=-1;
  Reg:=TRegistry.Create;
  try
    Reg.Access:=KEY_READ;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    If Reg.OpenKey('\Software\D-Fend Reloaded',False) and Reg.ValueExists('Installer Language') then begin
      try InstallerLang:=StrToInt(Reg.ReadString('Installer Language')); except end;
    end;
  finally
    Reg.Free;
  end;

  InstallerLangEditComboBox.OnChange:=nil;

  If InstallerLang>=0 then begin
    SelLang:=-1;
    For I:=0 to InstallerLangEditComboBox.Items.Count-1 do If Integer(InstallerLangEditComboBox.Items.Objects[I])=InstallerLang then begin
      SelLang:=I; break;
    end;
  end else begin
    SelLang:=-1;
  end;

  If (InstallerLangEditComboBox.Items.Count>0) and (Integer(InstallerLangEditComboBox.Items.Objects[InstallerLangEditComboBox.Items.Count-1])=-1) then begin
    InstallerLangEditComboBox.Items.Delete(InstallerLangEditComboBox.Items.Count-1);
  end;

  If SelLang=-1 then begin
    InstallerLangEditComboBox.Items.AddObject('?',TObject(-1));
    InstallerLangEditComboBox.ItemIndex:=InstallerLangEditComboBox.Items.Count-1;
  end else begin
    InstallerLangEditComboBox.ItemIndex:=SelLang;
  end;

  InstallerLangEditComboBox.OnChange:=InstallerLangEditComboBoxChange;
end;

procedure TSetupFrameLanguage.TimerTimer(Sender: TObject);
begin
  dec(LangTimerCounter);
  If LangTimerCounter=0 then Timer.Enabled:=False;
  ReadCurrentInstallerLanguage;
end;


end.
