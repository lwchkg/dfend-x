unit ModernProfileEditorDOSBoxFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls, ExtCtrls, Buttons,
  ComCtrls;

type
  TModernProfileEditorDOSBoxFrame = class(TFrame, IModernProfileEditorFrame)
    CloseDOSBoxOnExitCheckBox: TCheckBox;
    DefaultDOSBoxInstallationRadioButton: TRadioButton;
    CustomDOSBoxInstallationRadioButton: TRadioButton;
    CustomDOSBoxInstallationEdit: TEdit;
    CustomDOSBoxInstallationButton: TSpeedButton;
    CustomSetsClearButton: TBitBtn;
    CustomSetsLoadButton: TBitBtn;
    CustomSetsSaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    CustomSetsMemo: TRichEdit;
    CustomSetsLabel: TLabel;
    DOSBoxInstallationComboBox: TComboBox;
    UserLanguageCheckBox: TCheckBox;
    UserLanguageComboBox: TComboBox;
    DOSBoxForegroundPriorityComboBox: TComboBox;
    DOSBoxBackgroundPriorityComboBox: TComboBox;
    DOSBoxForegroundPriorityLabel: TLabel;
    DOSBoxBackgroundPriorityLabel: TLabel;
    UserConsoleCheckBox: TCheckBox;
    UserConsoleComboBox: TComboBox;
    RunAsAdminCheckBox: TCheckBox;
    procedure CustomDOSBoxInstallationButtonClick(Sender: TObject);
    procedure CustomDOSBoxInstallationEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure DOSBoxInstallationComboBoxChange(Sender: TObject);
    procedure DOSBoxInstallationTypeClick(Sender: TObject);
    procedure UserLanguageCheckBoxClick(Sender: TObject);
    procedure UserConsoleCheckBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
    ProfileName,ProfileExe,ProfileSetup,ProfileDOSBoxInstallation,ProfileCaptureDir : PString;
    FOnProfileNameChange : TTextEvent;
    Procedure UpdateLanguageList;
    Procedure SelectInLanguageList(const LangName : String);
    Procedure SelectInConsoleList;
    Procedure UpdateDOSBoxInstallationString;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     PrgConsts, HelpConsts, IconLoaderUnit, TextEditPopupUnit;

{$R *.dfm}

const FPriority : Array[0..3] of String = ('lower','normal','higher','highest');
const BPriority : Array[0..4] of String = ('pause','lower','normal','higher','highest');

{ TModernProfileEditorDOSBoxFrame }

constructor TModernProfileEditorDOSBoxFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DosBoxLang:=TStringList.Create;
end;

destructor TModernProfileEditorDOSBoxFrame.Destroy;
begin
  DosBoxLang.Free;
  inherited Destroy;
end;

procedure TModernProfileEditorDOSBoxFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var I : Integer;
    S : String;
begin
  NoFlicker(DOSBoxForegroundPriorityComboBox);
  NoFlicker(DOSBoxBackgroundPriorityComboBox);
  NoFlicker(CloseDOSBoxOnExitCheckBox);
  NoFlicker(DefaultDOSBoxInstallationRadioButton);
  NoFlicker(DOSBoxInstallationComboBox);
  NoFlicker(CustomDOSBoxInstallationRadioButton);
  NoFlicker(CustomDOSBoxInstallationEdit);
  NoFlicker(UserLanguageCheckBox);
  NoFlicker(UserLanguageComboBox);
  NoFlicker(UserConsoleCheckBox);
  NoFlicker(UserConsoleComboBox);
  {NoFlicker(CustomSetsMemo); - will hide text in Memo}
  NoFlicker(CustomSetsClearButton);
  NoFlicker(CustomSetsLoadButton);
  NoFlicker(CustomSetsSaveButton);

  SetRichEditPopup(CustomSetsMemo);

  DOSBoxForegroundPriorityLabel.Caption:=LanguageSetup.GamePriorityForeground;
  with DOSBoxForegroundPriorityComboBox.Items do begin
    Clear;
    Add(LanguageSetup.GamePriorityLower);
    Add(LanguageSetup.GamePriorityNormal);
    Add(LanguageSetup.GamePriorityHigher);
    Add(LanguageSetup.GamePriorityHighest);
  end;
  DOSBoxBackgroundPriorityLabel.Caption:=LanguageSetup.GamePriorityBackground;
  with DOSBoxBackgroundPriorityComboBox.Items do begin
    Clear;
    Add(LanguageSetup.GamePriorityPause);
    Add(LanguageSetup.GamePriorityLower);
    Add(LanguageSetup.GamePriorityNormal);
    Add(LanguageSetup.GamePriorityHigher);
    Add(LanguageSetup.GamePriorityHighest);
  end;
  CloseDOSBoxOnExitCheckBox.Caption:=LanguageSetup.GameCloseDosBoxAfterGameExit;
  RunAsAdminCheckBox.Caption:=LanguageSetup.ProfileEditorRunAsAdmin;
  RunAsAdminCheckBox.Visible:=PrgSetup.OfferRunAsAdmin;
  DefaultDOSBoxInstallationRadioButton.Caption:=LanguageSetup.GameDOSBoxVersionDefault;
  CustomDOSBoxInstallationRadioButton.Caption:=LanguageSetup.GameDOSBoxVersionCustom;
  CustomDOSBoxInstallationButton.Hint:=LanguageSetup.ChooseFolder;
  UserLanguageCheckBox.Caption:=LanguageSetup.GameDOSBoxLanguageCustom;
  UserConsoleCheckBox.Caption:=LanguageSetup.GameDOSBoxConsole;
  with UserConsoleComboBox.Items do begin
    Clear;
    Add(LanguageSetup.GameDOSBoxConsoleHide);
    Add(LanguageSetup.GameDOSBoxConsoleShow);
  end;
  CustomSetsLabel.Caption:=LanguageSetup.ProfileEditorCustomSetsSheet;
  CustomSetsMemo.Font.Name:='Courier New';
  CustomSetsClearButton.Caption:=LanguageSetup.Del;
  CustomSetsLoadButton.Caption:=LanguageSetup.Load;
  CustomSetsSaveButton.Caption:=LanguageSetup.Save;
  UserIconLoader.DialogImage(DI_SelectFolder,CustomDOSBoxInstallationButton);
  UserIconLoader.DialogImage(DI_Clear,CustomSetsClearButton);
  UserIconLoader.DialogImage(DI_Load,CustomSetsLoadButton);
  UserIconLoader.DialogImage(DI_Save,CustomSetsSaveButton);

  For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do begin
    If I=0 then S:=LanguageSetup.Default else S:=PrgSetup.DOSBoxSettings[I].Name;
    DOSBoxInstallationComboBox.Items.Add(S+' ('+MakeRelPath(PrgSetup.DOSBoxSettings[I].DosBoxDir,PrgSetup.BaseDir,True)+')');
  end;
  DOSBoxInstallationComboBox.ItemIndex:=0;

  ProfileName:=InitData.CurrentProfileName;
  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileDOSBoxInstallation:=InitData.CurrentDOSBoxInstallation;
  ProfileCaptureDir:=InitData.CurrentCaptureDir;
  FOnProfileNameChange:=InitData.OnProfileNameChange;

  HelpContext:=ID_ProfileEditDOSBox;
end;

procedure TModernProfileEditorDOSBoxFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    S,T : String;
    I : Integer;
    B : Boolean;
begin
  St:=ValueToList(Game.Priority,',');
  try
    If (St.Count>=1) and (St[0]<>'') then S:=St[0] else S:=FPriority[2];
    If (St.Count>=2) and (St[1]<>'') then T:=St[1] else T:=BPriority[2];
  finally
    St.Free;
  end;
  S:=Trim(ExtUpperCase(S));
  DOSBoxForegroundPriorityComboBox.ItemIndex:=1;
  For I:=0 to DOSBoxForegroundPriorityComboBox.Items.Count-1 do If ExtUpperCase(FPriority[I])=S then begin
    DOSBoxForegroundPriorityComboBox.ItemIndex:=I;
    break;
  end;
  T:=Trim(ExtUpperCase(T));
  DOSBoxBackgroundPriorityComboBox.ItemIndex:=2;
  For I:=0 to DOSBoxBackgroundPriorityComboBox.Items.Count-1 do If ExtUpperCase(BPriority[I])=T then begin
    DOSBoxBackgroundPriorityComboBox.ItemIndex:=I;
    break;
  end;

  CloseDOSBoxOnExitCheckBox.Checked:=Game.CloseDosBoxAfterGameExit;
  RunAsAdminCheckBox.Checked:=Game.RunAsAdmin;

  S:=Trim(ExtUpperCase(Game.CustomDOSBoxDir)); B:=False;
  If S='' then S:='DEFAULT';
  For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do begin
    If I=0 then T:='DEFAULT' else T:=PrgSetup.DOSBoxSettings[I].Name;
    If S=Trim(ExtUpperCase(T)) then begin
      B:=True;
      DefaultDOSBoxInstallationRadioButton.Checked:=True;
      DOSBoxInstallationComboBox.ItemIndex:=I;
      break;
    end;
  end;
  If not B then begin
    CustomDOSBoxInstallationRadioButton.Checked:=True;
    CustomDOSBoxInstallationEdit.Text:=Game.CustomDOSBoxDir;
  end;

  Case Game.ShowConsoleWindow of
    0 : begin UserConsoleCheckBox.Checked:=True; UserConsoleComboBox.ItemIndex:=0; end;
    2 : begin UserConsoleCheckBox.Checked:=True; UserConsoleComboBox.ItemIndex:=1; end;
    else {1 :} UserConsoleCheckBox.Checked:=False;
  End;
  UserConsoleCheckBoxClick(self);
  If not UserConsoleCheckBox.Checked then SelectInConsoleList;

  UpdateLanguageList;
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxLanguage));
  If (S='') or (S='DEFAULT') then begin
    UserLanguageCheckBox.Checked:=False;
    SelectInLanguageList('');
  end else begin
    UserLanguageCheckBox.Checked:=True;
    SelectInLanguageList(ChangeFileExt(ExtractFileName(Game.CustomDOSBoxLanguage),''));
  end;
  UserLanguageCheckBoxClick(self);

  St:=StringToStringList(Game.CustomSettings);
  try
    CustomSetsMemo.Lines.Assign(St);
  finally
    St.Free;
  end;
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

procedure TModernProfileEditorDOSBoxFrame.UpdateDOSBoxInstallationString;
begin
  If DefaultDOSBoxInstallationRadioButton.Checked then begin
    ProfileDOSBoxInstallation^:=PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].Name;
  end else begin
    ProfileDOSBoxInstallation^:=CustomDOSBoxInstallationEdit.Text;
  end;
end;

procedure TModernProfileEditorDOSBoxFrame.UpdateLanguageList;
Var Save,DosBoxDir : String;
begin
  If DefaultDOSBoxInstallationRadioButton.Checked then begin
    DosBoxDir:=IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].DosBoxDir);
    FOnProfileNameChange(self,ProfileName^,ProfileExe^,ProfileSetup^,'','',PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].Name,ProfileCaptureDir^);
  end else begin
    DosBoxDir:=IncludeTrailingPathDelimiter(CustomDOSBoxInstallationEdit.Text);
    FOnProfileNameChange(self,ProfileName^,ProfileExe^,ProfileSetup^,'','',CustomDOSBoxInstallationEdit.Text,ProfileCaptureDir^);
  end;

  If UserLanguageComboBox.ItemIndex>=0 then Save:=UserLanguageComboBox.Items[UserLanguageComboBox.ItemIndex] else Save:='';
  UserLanguageComboBox.Items.BeginUpdate;
  try
    UserLanguageComboBox.Items.Clear;
    DosBoxLang.Clear;

    UserLanguageComboBox.Items.Add('English');
    DosBoxLang.Add('English');

    FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxDir),UserLanguageComboBox.Items,DosBoxLang);
    FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',UserLanguageComboBox.Items,DosBoxLang);
    UserLanguageComboBox.ItemIndex:=Max(0,UserLanguageComboBox.Items.IndexOf(Save));
  finally
    UserLanguageComboBox.Items.EndUpdate;
  end;

  SelectInLanguageList(Save);
end;

procedure TModernProfileEditorDOSBoxFrame.UserLanguageCheckBoxClick(Sender: TObject);
begin
  UserLanguageComboBox.Enabled:=UserLanguageCheckBox.Checked;
end;

procedure TModernProfileEditorDOSBoxFrame.UserConsoleCheckBoxClick(Sender: TObject);
begin
  UserConsoleComboBox.Enabled:=UserConsoleCheckBox.Checked;
end;

Procedure TModernProfileEditorDOSBoxFrame.SelectInLanguageList(const LangName : String);
Var I : Integer;
    S : String;
begin
  If Trim(LangName)<>'' then begin
    I:=UserLanguageComboBox.Items.IndexOf(LangName);
    If I>=0 then begin UserLanguageComboBox.ItemIndex:=I; exit; end;
  end;

  UserLanguageComboBox.ItemIndex:=0;
  If not DefaultDOSBoxInstallationRadioButton.Checked then exit;

  S:=ChangeFileExt(ExtractFileName(PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].DosBoxLanguage),'');
  UserLanguageComboBox.ItemIndex:=Max(0,UserLanguageComboBox.Items.IndexOf(S));
end;

procedure TModernProfileEditorDOSBoxFrame.SelectInConsoleList;
begin
  UserConsoleComboBox.ItemIndex:=0;
  If not DefaultDOSBoxInstallationRadioButton.Checked then exit;

  If PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].HideDosBoxConsole
    then UserConsoleComboBox.ItemIndex:=0
    else UserConsoleComboBox.ItemIndex:=1;
end;

procedure TModernProfileEditorDOSBoxFrame.GetGame(const Game: TGame);
begin
  Game.Priority:=FPriority[DOSBoxForegroundPriorityComboBox.ItemIndex]+','+BPriority[DOSBoxBackgroundPriorityComboBox.ItemIndex];
  Game.CloseDosBoxAfterGameExit:=CloseDOSBoxOnExitCheckBox.Checked;
  Game.RunAsAdmin:=RunAsAdminCheckBox.Checked;
  If DefaultDOSBoxInstallationRadioButton.Checked then begin
    Game.CustomDOSBoxDir:=PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].Name;
  end else begin
    Game.CustomDOSBoxDir:=CustomDOSBoxInstallationEdit.Text;
  end;

  If UserLanguageCheckBox.Checked then Game.CustomDOSBoxLanguage:=ExtractFileName(DosBoxLang[UserLanguageComboBox.ItemIndex]) else Game.CustomDOSBoxLanguage:='default';
  If UserConsoleCheckBox.Checked then begin
    If UserConsoleComboBox.ItemIndex=1 then Game.ShowConsoleWindow:=2 else Game.ShowConsoleWindow:=0;
  end else Game.ShowConsoleWindow:=1;

  Game.CustomSettings:=StringListToString(CustomSetsMemo.Lines);
end;

procedure TModernProfileEditorDOSBoxFrame.CustomDOSBoxInstallationButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(CustomDOSBoxInstallationEdit.Text);
  If S='' then S:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  S:=MakeRelPath(S,PrgSetup.BaseDir,True);
  If S='' then exit;
  CustomDOSBoxInstallationEdit.Text:=IncludeTrailingPathDelimiter(S);
end;

procedure TModernProfileEditorDOSBoxFrame.DOSBoxInstallationTypeClick(Sender: TObject);
begin
  UpdateLanguageList;
  If not UserLanguageCheckBox.Checked then SelectInLanguageList('');
  If not UserConsoleCheckBox.Checked then SelectInConsoleList;
  UpdateDOSBoxInstallationString;
end;

procedure TModernProfileEditorDOSBoxFrame.DOSBoxInstallationComboBoxChange(Sender: TObject);
begin
  DefaultDOSBoxInstallationRadioButton.Checked:=True;
  UpdateLanguageList;
  If not UserLanguageCheckBox.Checked then SelectInLanguageList('');
  If not UserConsoleCheckBox.Checked then SelectInConsoleList;
  UpdateDOSBoxInstallationString;
end;

procedure TModernProfileEditorDOSBoxFrame.CustomDOSBoxInstallationEditChange(Sender: TObject);
begin
  CustomDOSBoxInstallationRadioButton.Checked:=True;
  UpdateLanguageList;
  If not UserLanguageCheckBox.Checked then SelectInLanguageList('');
  UpdateDOSBoxInstallationString;
end;

procedure TModernProfileEditorDOSBoxFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : CustomSetsMemo.Lines.Clear;
    1 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorCustomSetsLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not OpenDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    2 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorCustomSetsSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not SaveDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
  end;
end;

end.
