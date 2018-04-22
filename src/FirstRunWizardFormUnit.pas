unit FirstRunWizardFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

Type TDOSBoxWarningType=(wtNoDir,wtOld);

type
  TFirstRunWizardForm = class(TForm)
    Image: TImage;
    OKButton: TBitBtn;
    HelpButton: TBitBtn;
    StartLabel: TLabel;
    ProgramLanguageLabel: TLabel;
    ProgramLanguageComboBox: TComboBox;
    DOSBoxLabel: TLabel;
    DOSBoxLanguageLabel: TLabel;
    DOSBoxLanguageComboBox: TComboBox;
    UpdatesCheckBox: TCheckBox;
    UpdatesLabel: TLabel;
    DOSBoxComboBox: TComboBox;
    DOSBoxButton: TSpeedButton;
    ProgramLanguageWarningButton: TSpeedButton;
    DOSBoxEdit: TEdit;
    DOSBoxWarningButton: TSpeedButton;
    PortableOKButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ProgramLanguageComboBoxChange(Sender: TObject);
    procedure ProgramLanguageButtonClick(Sender: TObject);
    procedure DOSBoxComboBoxChange(Sender: TObject);
    procedure DOSBoxEditChange(Sender: TObject);
    procedure DOSBoxButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    JustLoadingLanguage,DefaultDOSBoxAvailable : Boolean;
    DosBoxLang : TStringList;
    DOSBoxWarningType : TDOSBoxWarningType;
    Procedure SetDOSBoxWarningLanguage;
    procedure LoadAndSetupLanguageList;
    Procedure LoadGUILanguage;
    procedure LoadAndSetupDOSBoxLanguages(const ResetLang : Boolean);
    Function ExtendLanguageName(const ShortName : String) : String;
  public
    { Public-Deklarationen }
  end;

var
  FirstRunWizardForm: TFirstRunWizardForm;

Function ShowFirstRunWizardDialog(const AOwner : TComponent; var SearchForUpdatesNow : Boolean) : Boolean;

implementation

uses Registry, Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, HelpConsts,
     PrgSetupUnit, IconLoaderUnit, PrgConsts, MainUnit, LoggingUnit, DOSBoxLangTools;

{$R *.dfm}

procedure TFirstRunWizardForm.FormCreate(Sender: TObject);
begin
  LogInfo('First run wizard: FormCreate');

  DosBoxLang:=TStringList.Create;
  JustLoadingLanguage:=False;
  DefaultDOSBoxAvailable:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)))=Trim(ExtUpperCase(PrgDir+'DOSBox\'));

  SetVistaFonts(self);

  UserIconLoader.LoadIcons;
  UserIconLoader.DialogImage(DI_Warning,ProgramLanguageWarningButton);
  UserIconLoader.DialogImage(DI_Warning,DOSBoxWarningButton);
  UserIconLoader.DialogImage(DI_Information,PortableOKButton);
  UserIconLoader.DialogImage(DI_SelectFolder,DOSBoxButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  LoadGUILanguage;
end;

procedure TFirstRunWizardForm.FormShow(Sender: TObject);
begin
  LogInfo('First run wizard: FormShow');

  LoadAndSetupLanguageList;

  DOSBoxEdit.Text:=MakeRelPath(PrgSetup.DOSBoxSettings[0].DosBoxDir,PrgSetup.BaseDir);
  DOSBoxEditChange(Sender);

  LoadAndSetupDOSBoxLanguages(True);
end;

procedure TFirstRunWizardForm.FormDestroy(Sender: TObject);
begin
  DosBoxLang.Free;
end;

procedure TFirstRunWizardForm.LoadGUILanguage;
Var I : Integer;
begin
  JustLoadingLanguage:=True;
  try
    LogInfo('First run wizard: LoadGUILanguage');

    {General GUI elements}
    ProgramLanguageLabel.ParentFont:=True;
    DOSBoxLabel.ParentFont:=True;
    DOSBoxLanguageLabel.ParentFont:=True;
    UpdatesCheckBox.ParentFont:=True;
    Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
    ProgramLanguageLabel.Font.Style:=[fsBold];
    DOSBoxLabel.Font.Style:=[fsBold];
    DOSBoxLanguageLabel.Font.Style:=[fsBold];
    UpdatesCheckBox.Font.Style:=[fsBold];

    Caption:=LanguageSetup.FirstRunWizard;
    StartLabel.Caption:=LanguageSetup.FirstRunWizardInfoOverview;
    ProgramLanguageLabel.Caption:=LanguageSetup.FirstRunWizardProgramLanguage;
    ProgramLanguageWarningButton.Caption:=LanguageSetup.LanguageOutdatedShort;
    DOSBoxLabel.Caption:=LanguageSetup.FirstRunWizardDOSBoxDir;
    DOSBoxButton.Hint:=LanguageSetup.ChooseFolder;
    DOSBoxLanguageLabel.Caption:=LanguageSetup.FirstRunWizardDOSBoxLanguage;
    UpdatesCheckBox.Caption:=LanguageSetup.FirstRunWizardAutoUpdate;
    UpdatesLabel.Caption:=LanguageSetup.FirstRunWizardAutoUpdateInfo;
    OKButton.Caption:=LanguageSetup.OK;
    HelpButton.Caption:=LanguageSetup.Help;

    {DOSBox selection}
    I:=DOSBoxComboBox.ItemIndex;
    DOSBoxComboBox.Items.BeginUpdate;
    try
      DOSBoxComboBox.Items.Clear;
      DOSBoxComboBox.Items.Add(LanguageSetup.FirstRunWizardDOSBoxDirDefault);
      DOSBoxComboBox.Items.Add(LanguageSetup.FirstRunWizardDOSBoxDirCustom);
    finally
      DOSBoxComboBox.Items.EndUpdate;
    end;
    DOSBoxComboBox.ItemIndex:=Max(0,I);
    DOSBoxEdit.Enabled:=(DOSBoxComboBox.Items.Count=0) or (DOSBoxComboBox.ItemIndex=1);
    DOSBoxButton.Enabled:=(DOSBoxComboBox.Items.Count=0) or (DOSBoxComboBox.ItemIndex=1);

    {Special labels}
    PortableOKButton.Caption:=LanguageSetup.FirstRunWizardDOSBoxDirPortableOKShort;
    PortableOKButton.Hint:=LanguageSetup.FirstRunWizardDOSBoxDirPortableOK;
    SetDOSBoxWarningLanguage;
  finally
    JustLoadingLanguage:=False;
  end;
end;

procedure TFirstRunWizardForm.SetDOSBoxWarningLanguage;
Var I : Integer;
    DOSBoxVersion,S : String;
begin
  if DOSBoxWarningType=wtNoDir then begin
    DOSBoxWarningButton.Caption:=LanguageSetup.FirstRunWizardDOSBoxDirNoDOSBoxShort;
    DOSBoxWarningButton.Hint:=LanguageSetup.FirstRunWizardDOSBoxDirNoDOSBox;
  end;

  If DOSBoxWarningType=wtOld then begin
      DOSBoxVersion:=CheckDOSBoxVersion(-1,DosBoxEdit.Text);
      DOSBoxWarningButton.Caption:=LanguageSetup.MessageDOSBoxOutdatedShort;
      S:=FloatToStr(MinSupportedDOSBoxVersion);
      For I:=1 to length(S) do If S[I]=',' then S[I]:='.';
      DOSBoxWarningButton.Hint:=Format(LanguageSetup.MessageDOSBoxOutdated,[DOSBoxVersion,S]);
  end;
end;

procedure TFirstRunWizardForm.LoadAndSetupLanguageList;
Var I,J : Integer;
    St : TStringList;
    Reg : TRegistry;
    InstallerLanguageOK : Boolean;
begin
  JustLoadingLanguage:=True;
  try
    LogInfo('First run wizard: LoadAndSetupLanguageList');

    {Load language list}
    St:=GetLanguageList;
    try
      ProgramLanguageComboBox.Items.AddStrings(St);
    finally
      St.Free;
    end;

    {Read installer language}
    J:=1033; InstallerLanguageOK:=False;
    Reg:=TRegistry.Create;
    try
      Reg.Access:=KEY_READ;
      Reg.RootKey:=HKEY_LOCAL_MACHINE;
      If Reg.OpenKey('\Software\D-Fend Reloaded',False) and Reg.ValueExists('Installer Language') then begin
        try J:=StrToInt(Reg.ReadString('Installer Language')); InstallerLanguageOK:=True; except end;
      end;
    finally
      Reg.Free;
    end;

    {Set program language to installer language}
    ProgramLanguageComboBox.ItemIndex:=0;
    For I:=0 to ProgramLanguageComboBox.Items.Count-1 do If Integer(ProgramLanguageComboBox.Items.Objects[I])=J then begin
      ProgramLanguageComboBox.ItemIndex:=I; break;
    end;

    {Set program language to system language}
    If not InstallerLanguageOK then begin
      J:=GetSystemDefaultLangID;
      For I:=0 to ProgramLanguageComboBox.Items.Count-1 do If Integer(ProgramLanguageComboBox.Items.Objects[I])=J then begin
        ProgramLanguageComboBox.ItemIndex:=I; break;
      end;
    end;
  finally
    JustLoadingLanguage:=False;
  end;

  ProgramLanguageComboBoxChange(self);
end;

Function MainVersionStringToInt(S : String) : Integer;
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
end;

procedure TFirstRunWizardForm.ProgramLanguageComboBoxChange(Sender: TObject);
Var S : String;
begin
  if JustLoadingLanguage then exit;

  LoadLanguage(ShortLanguageName(ProgramLanguageComboBox.Text)+'.ini');
  DFendReloadedMainForm.SelectHelpFile;
  LoadGUILanguage;

  ProgramLanguageWarningButton.Visible:=False;
  S:=Trim(LanguageSetup.MaxVersion);
  If (S='') or (S='0') then begin
    ProgramLanguageWarningButton.Visible:=True;
    ProgramLanguageWarningButton.Hint:=LanguageSetup.LanguageNoVersion;
  end else begin
    If MainVersionStringToInt(S)<MainVersionStringToInt(GetNormalFileVersionAsString) then begin
      ProgramLanguageWarningButton.Visible:=True;
      ProgramLanguageWarningButton.Hint:=Format(LanguageSetup.LanguageOutdated,[LanguageSetup.MaxVersion,GetNormalFileVersionAsString]);
    end;
  end;

  LoadAndSetupDOSBoxLanguages(True);
end;

procedure TFirstRunWizardForm.ProgramLanguageButtonClick(Sender: TObject);
begin
  If (Sender=ProgramLanguageWarningButton) or (Sender=DOSBoxWarningButton)
    then MessageDlg((Sender as TSpeedButton).Hint,mtWarning,[mbOK],0)
    else MessageDlg((Sender as TSpeedButton).Hint,mtInformation,[mbOK],0);
end;

procedure TFirstRunWizardForm.DOSBoxButtonClick(Sender: TObject);
Var S : String;
begin
  S:=MakeAbsPath(DosBoxEdit.Text,PrgSetup.BaseDir);
  if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then DosBoxEdit.Text:=MakeRelPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir);
end;

procedure TFirstRunWizardForm.DOSBoxComboBoxChange(Sender: TObject);
begin
  If JustLoadingLanguage then exit;
  If DOSBoxComboBox.Items.Count=0 then exit;
  DOSBoxEdit.Enabled:=(DOSBoxComboBox.ItemIndex=1);
  DOSBoxButton.Enabled:=(DOSBoxComboBox.ItemIndex=1);

  If DOSBoxComboBox.ItemIndex=0 then begin
    DOSBoxEdit.Text:=MakeRelPath(PrgSetup.DOSBoxSettings[0].DosBoxDir,PrgSetup.BaseDir);
    DOSBoxEditChange(Sender);
  end;
end;

procedure TFirstRunWizardForm.DOSBoxEditChange(Sender: TObject);
Var S,T,DOSBoxVersion : String;
begin
  DOSBoxWarningButton.Visible:=False;
  PortableOKButton.Visible:=False;

  S:=IncludeTrailingPathDelimiter(MakeAbsPath(DOSBoxEdit.Text,PrgSetup.BaseDir));
  If not FileExists(S+DosBoxFileName) then begin
    DOSBoxWarningButton.Visible:=True;
    DOSBoxWarningType:=wtNoDir;
    SetDOSBoxWarningLanguage;
  end else begin
    DOSBoxVersion:=CheckDOSBoxVersion(-1,DosBoxEdit.Text);
    DOSBoxWarningButton.Visible:=OldDOSBoxVersion(DOSBoxVersion);
    If DOSBoxWarningButton.Visible then SetDOSBoxWarningLanguage else begin
      S:=IncludeTrailingPathDelimiter(ExtUpperCase(MakeAbsPath(DOSBoxEdit.Text,PrgSetup.BaseDir)));
      T:=IncludeTrailingPathDelimiter(ExtUpperCase(PrgDir));
      If (OperationMode=omPortable) and (Copy(S,1,length(T))=T) then begin
        PortableOKButton.Visible:=True;
      end;
    end;
  end;

  LoadAndSetupDOSBoxLanguages(False);
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

Function TFirstRunWizardForm.ExtendLanguageName(const ShortName : String) : String;
Var I : Integer;
    ShortNameUpper : String;
    S,T : String;
begin
  ShortNameUpper:=ExtUpperCase(ShortName);
  For I:=0 to ProgramLanguageComboBox.Items.Count-1 do begin
    S:=ProgramLanguageComboBox.Items[I];
    If Pos('(',S)=0 then continue;
    T:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then continue;
    T:=Copy(T,1,Pos(')',T)-1);
    If ExtUpperCase(T)=ShortNameUpper then begin result:=S; exit; end;
  end;

  result:=ShortName;
end;

procedure TFirstRunWizardForm.LoadAndSetupDOSBoxLanguages(const ResetLang : Boolean);
Var I,J : Integer;
    S,Save : String;
    St,St2 : TStringList;
begin
  Save:=DOSBoxLanguageComboBox.Text;
  If Pos('(',Save)>0 then begin
    S:=Copy(Save,Pos('(',Save)+1);
    If Pos(')',S)>0 then S:=Copy(S,1,Pos(')',S)-1);
    If S<>'' then Save:=S;
  end;

  I:=-1;

  DosBoxLang.Clear;
  DOSBoxLanguageComboBox.Items.Clear;
  St:=TStringList.Create;
  try
    GetDOSBoxLangNamesAndFiles(IncludeTrailingPathDelimiter(MakeAbsPath(DosBoxEdit.Text,PrgSetup.BaseDir)),St,DosBoxLang,True);

    {Restore old value}
    If (Save<>'') and not ResetLang then I:=St.IndexOf(Save);

    {Get value from program language list}
    If I<0 then begin
      S:=ShortLanguageName(ProgramLanguageComboBox.Items[ProgramLanguageComboBox.ItemIndex]);
      I:=St.IndexOf(S);
      If (I<0) and (Pos(' ',S)>0) then begin
        St2:=ValueToList(S,' ');
        try
          For J:=0 to St2.Count-1 do begin
            I:=St.IndexOf(St2[J]);
            If I>=0 then break;
          end;
        finally
          St2.Free;
        end;
      end;
    end;

    {Get value from program language list for language name "German"}
    If (I<0) and (ExtUpperCase(S)='GERMAN') then I:=St.IndexOf('Deutsch');

    {Fall back to "English"}
    If I<0 then I:=St.IndexOf('English');


    For J:=0 to St.Count-1 do DOSBoxLanguageComboBox.Items.Add(ExtendLanguageName(St[J]));
    DOSBoxLanguageComboBox.ItemIndex:=I;
  finally
    St.Free;
  end;

  If I>=0 then begin DOSBoxLanguageComboBox.ItemIndex:=I; exit; end;

  If (Save<>'') and not ResetLang then begin
    I:=DOSBoxLanguageComboBox.Items.IndexOf(Save);
    If I>=0 then begin DOSBoxLanguageComboBox.ItemIndex:=I; exit; end;
  end;

  S:=ShortLanguageName(ProgramLanguageComboBox.Items[ProgramLanguageComboBox.ItemIndex]);
  I:=DOSBoxLanguageComboBox.Items.IndexOf(S);
  If (I<0) and (Pos(' ',S)>0) then begin
    St:=ValueToList(S,' ');
    try
      For J:=0 to St.Count-1 do begin
        I:=DOSBoxLanguageComboBox.Items.IndexOf(St[J]);
        If I>=0 then break;
      end;
    finally
      St.Free;
    end;
  end;

  If (I<0) and (ExtUpperCase(S)='GERMAN') then I:=DOSBoxLanguageComboBox.Items.IndexOf('Deutsch');

  If I<0 then I:=DOSBoxLanguageComboBox.Items.IndexOf('English');

  DOSBoxLanguageComboBox.ItemIndex:=I;
end;

procedure TFirstRunWizardForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PrgSetup.Language:=ShortLanguageName(ProgramLanguageComboBox.Text)+'.ini';
  PrgSetup.DOSBoxSettings[0].DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxEdit.Text);
  PrgSetup.DOSBoxSettings[0].DosBoxLanguage:=DosBoxLang[DOSBoxLanguageComboBox.ItemIndex];
  PrgSetup.GameDir:=PrgDataDir+'VirtualHD\';

  PrgSetup.VersionSpecificUpdateCheck:=True;
  If UpdatesCheckBox.Checked then begin
    PrgSetup.CheckForUpdates:=1;
    PrgSetup.DataReaderCheckForUpdates:=2;
  end else begin
    PrgSetup.CheckForUpdates:=0;
    PrgSetup.DataReaderCheckForUpdates:=0;
  end;
  PrgSetup.PackageListsCheckForUpdates:=0;
  PrgSetup.CheatsDBCheckForUpdates:=0;

  PrgSetup.ValueForNotSet:=LanguageSetup.NotSetLanguageDefault;
end;

procedure TFirstRunWizardForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FirstRunWizard);
end;

procedure TFirstRunWizardForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowFirstRunWizardDialog(const AOwner : TComponent; var SearchForUpdatesNow : Boolean) : Boolean;
begin
  FirstRunWizardForm:=TFirstRunWizardForm.Create(AOwner);
  try
    result:=(FirstRunWizardForm.ShowModal=mrOK);
    if not result then LoadLanguage(PrgSetup.Language);
    SearchForUpdatesNow:=result and FirstRunWizardForm.UpdatesCheckBox.Checked;
  finally
    FirstRunWizardForm.Free;
  end;
end;

end.
