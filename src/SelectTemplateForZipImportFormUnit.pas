unit SelectTemplateForZipImportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons, ExtCtrls;

type
  TSelectTemplateForZipImportForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    TemplateType1RadioButton: TRadioButton;
    TemplateType2RadioButton: TRadioButton;
    TemplateType3RadioButton: TRadioButton;
    ProfileNameEdit: TLabeledEdit;
    TemplateComboBox: TComboBox;
    TemplateLabel: TLabel;
    ProgramFileLabel: TLabel;
    ProgramFileComboBox: TComboBox;
    FolderEdit: TLabeledEdit;
    SetupFileComboBox: TComboBox;
    SetupFileLabel: TLabel;
    WarningLabel: TLabel;
    InstallSupportButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure TypeSelectClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TemplateComboBoxChange(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
    procedure FolderEditChange(Sender: TObject);
    procedure ProfileNameEditChange(Sender: TObject);
    procedure InstallSupportButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
    Procedure InitialFolderCheck;
    Procedure SelectFilesFromAutoSetupTemplate;
    Function GetProfileNameFromFile(TempFolder: String; const FileName : String) : String;
    Function GetProfileNameFromFileIdDiz(TempFolder : String) : String;
  public
    { Public-Deklarationen }
    ProfileNameChanged, UseInstallSupport : Boolean;
    ArchivFileName, AlternateProfileNameSource : String;
    AutoSetupDB, TemplateDB : TGameDB;
    PrgFiles, Templates : TStringList;
    FileToStart, SetupFileToStart, ProfileName, ProfileFolder : String;
    TemplateNr : Integer;
    Procedure Prepare(const DoNotCopyFolder : Boolean; const TempFolder : String);
  end;

Function ShowSelectTemplateForZipImportDialog(const AOwner : TComponent; const AAutoSetupDB, ATemplateDB : TGameDB; const APrgFiles, ATemplates : TStringList; const AArchivFileName, AAlternateProfileNameSource, ATempFolder : String; var AProfileName, AFileToStart, ASetupFileToStart, AFolder : String; var ATemplateNr : Integer; const NoDialogIfAutoSetupIsAvailable, DoNotCopyFolder : Boolean; var UseInstallSupport : Boolean) : Boolean;

var
  SelectTemplateForZipImportForm: TSelectTemplateForZipImportForm;

implementation

uses Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, IconLoaderUnit,
     HelpConsts, PrgSetupUnit, PrgConsts;

{$R *.dfm}

procedure TSelectTemplateForZipImportForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  WarningLabel.Font.Color:=clRed;

  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.AutoDetectProfileEditProfileName;
  FolderEdit.EditLabel.Caption:=LanguageSetup.MenuFileImportZIPDestinationFolder;
  WarningLabel.Caption:=LanguageSetup.MenuFileImportZIPDestinationFolderWarning;
  TemplateType1RadioButton.Caption:=LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup2;
  TemplateType2RadioButton.Caption:=LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup1;
  TemplateType3RadioButton.Caption:=LanguageSetup.AutoDetectProfileEditTemplateTypeUser;
  TemplateLabel.Caption:=LanguageSetup.AutoDetectProfileEditTemplate;
  ProgramFileLabel.Caption:=LanguageSetup.ProfileEditorGameEXE;
  SetupFileLabel.Caption:=LanguageSetup.ProfileEditorSetupEXE;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  InstallSupportButton.Caption:=LanguageSetup.InstallationSupportZipImportUse;
  InstallSupportButton.Hint:=LanguageSetup.InstallationSupportZipImportUseHint;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DirectLoad('Main',0,InstallSupportButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  JustChanging:=False;
  ProfileNameChanged:=False;
  UseInstallSupport:=False;
end;

procedure TSelectTemplateForZipImportForm.FormShow(Sender: TObject);
Var S : String;
begin
  If Trim(ArchivFileName)='' then S:=LanguageSetup.MenuFileImportFolder else S:=LanguageSetup.MenuFileImportZIPCaption;
  While (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1); Caption:=S;
end;

Function AvoidSomeNames(const St : TStringList; const SetupNumber : Integer) : String;
var I,J : Integer;
    OK : Boolean;
    S : String;
begin
  result:='';

  For I:=0 to St.Count-1 do if I<>SetupNumber then begin
    OK:=True; S:=ExtUpperCase(ChangeFileExt(St[I],''));
    For J:=Low(IgnoreGameExeFilesIgnore) to High(IgnoreGameExeFilesIgnore) do if S=IgnoreGameExeFilesIgnore[J] then begin OK:=False; break; end;
    if not OK then continue;

    for J:=Low(ProgramExeFiles) to High(ProgramExeFiles) do if S=ProgramExeFiles[J] then begin
      result:=St[I]; exit;
    end;
  end;

  For I:=0 to St.Count-1 do if I<>SetupNumber then begin
    OK:=True; S:=ExtUpperCase(ChangeFileExt(St[I],''));
    For J:=Low(IgnoreGameExeFilesIgnore) to High(IgnoreGameExeFilesIgnore) do if S=IgnoreGameExeFilesIgnore[J] then begin OK:=False; break; end;
    If OK then result:=St[I]; {File is ok in level 1}

    If OK then for J:=Low(SetupExeFilesLevel1) to High(SetupExeFilesLevel1) do if S=SetupExeFilesLevel1[J] then begin OK:=False; break; end;
    If OK then for J:=Low(SetupExeFilesLevel2) to High(SetupExeFilesLevel2) do if S=SetupExeFilesLevel2[J] then begin OK:=False; break; end;
    If OK then for J:=Low(SetupExeFilesLevel3) to High(SetupExeFilesLevel3) do if S=SetupExeFilesLevel3[J] then begin OK:=False; break; end;
    If OK then for J:=Low(SetupExeFilesLevel4) to High(SetupExeFilesLevel4) do if S=SetupExeFilesLevel4[J] then begin OK:=False; break; end;

    If OK then exit; {File is ok in level 2}
  end;
  If result<>'' then exit; {File was ok in level 1}

  For I:=0 to St.Count-1 do if I<>SetupNumber then begin result:=St[I]; exit; end;

  If St.Count>0 then result:=St[0];
end;

Function TSelectTemplateForZipImportForm.GetProfileNameFromFile(TempFolder: String; const FileName : String) : String;
Var S,T : String;
    St : TStringList;
    I,J : Integer;
begin
  result:='';
  S:=IncludeTrailingPathDelimiter(TempFolder)+FileName;
  If not FileExists(S) then exit;
  St:=TStringList.Create;
  try
    try St.LoadFromFile(S); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      T:='';
      For J:=1 to length(S) do if (S[J]>=#32) and (S[J]<=#127) and (S[J]<>'=') and (S[J]<>'|') then T:=T+S[J];
      T:=Trim(T);
      If length(T)>5 then begin result:=T; exit; end;
    end;
  finally
    St.Free;
  end;
end;

function TSelectTemplateForZipImportForm.GetProfileNameFromFileIdDiz(TempFolder: String) : String;
Var St : TStringList;
    I : Integer;
begin
  St:=ValueToList(PrgSetup.ArchiveIDFiles);
  try
    For I:=0 to St.Count-1 do begin
      result:=GetProfileNameFromFile(TempFolder,St[I]);
      If result<>'' then break;
    end;
  finally
    St.Free;
  end;
end;

Procedure TSelectTemplateForZipImportForm.Prepare(const DoNotCopyFolder : Boolean; const TempFolder : String);
Var I,J,Nr : Integer;
    S : String;
begin
  JustChanging:=True;
  try
    If DoNotCopyFolder then begin
      FolderEdit.Visible:=False;
      ClientHeight:=ClientHeight-40;
    end;

    ProgramFileComboBox.Items.AddStrings(PrgFiles);
    If ProgramFileComboBox.Items.Count>0 then ProgramFileComboBox.ItemIndex:=0;

    SetupFileComboBox.Items.Add('');
    SetupFileComboBox.Items.AddStrings(PrgFiles);
    SetupFileComboBox.ItemIndex:=0;

    If Templates.Count>0 then begin
      TemplateType1RadioButton.Checked:=True;
      ProfileNameEdit.Text:=AutoSetupDB[Integer(Templates.Objects[0])].Name;
      FileToStart:=Templates[0];
      TemplateNr:=0;

      SelectFilesFromAutoSetupTemplate;
      I:=ProgramFileComboBox.Items.IndexOf(FileToStart); If I>=0 then ProgramFileComboBox.ItemIndex:=I;
      I:=SetupFileComboBox.Items.IndexOf(SetupFileToStart); If I>=0 then SetupFileComboBox.ItemIndex:=I;
    end else begin
      TemplateType1RadioButton.Enabled:=False;
      TemplateType3RadioButton.Checked:=True;
      S:=GetProfileNameFromFileIdDiz(TempFolder);
      If S<>'' then ProfileNameEdit.Text:=S else begin
        If Trim(ArchivFileName)<>''
          then ProfileNameEdit.Text:=ChangeFileExt(ExtractFileName(ArchivFileName),'')
          else ProfileNameEdit.Text:=AlternateProfileNameSource;
      end;

      If PrgFiles.Count>0 then begin
        If PrgFiles.Count=1 then begin
          FileToStart:=PrgFiles[0];
          SetupFileToStart:='';
        end else begin
          Nr:=-1;
          For I:=0 to PrgFiles.Count-1 do begin
            S:=ExtUpperCase(ChangeFileExt(PrgFiles[I],''));
            For J:=Low(SetupExeFilesLevel1) to High(SetupExeFilesLevel1) do if S=SetupExeFilesLevel1[J] then begin Nr:=I; break; end;
            If Nr>=0 then break;
          end;
          If Nr<0 then For I:=0 to PrgFiles.Count-1 do begin
            S:=ExtUpperCase(ChangeFileExt(PrgFiles[I],''));
            For J:=Low(SetupExeFilesLevel2) to High(SetupExeFilesLevel2) do if S=SetupExeFilesLevel2[J] then begin Nr:=I; break; end;
            If Nr>=0 then break;
          end;
          If Nr<0 then For I:=0 to PrgFiles.Count-1 do begin
            S:=ExtUpperCase(ChangeFileExt(PrgFiles[I],''));
            For J:=Low(SetupExeFilesLevel3) to High(SetupExeFilesLevel3) do if S=SetupExeFilesLevel3[J] then begin Nr:=I; break; end;
            If Nr>=0 then break;
          end;
          If Nr<0 then For I:=0 to PrgFiles.Count-1 do begin
            S:=ExtUpperCase(ChangeFileExt(PrgFiles[I],''));
            For J:=Low(SetupExeFilesLevel4) to High(SetupExeFilesLevel4) do if S=SetupExeFilesLevel4[J] then begin Nr:=I; break; end;
            If Nr>=0 then break;
          end;

          FileToStart:=AvoidSomeNames(PrgFiles,-1);
          If Nr<0 then SetupFileToStart:='' else SetupFileToStart:=PrgFiles[Nr];

          I:=ProgramFileComboBox.Items.IndexOf(FileToStart);
          If I>=0 then ProgramFileComboBox.ItemIndex:=I;
          I:=SetupFileComboBox.Items.IndexOf(SetupFileToStart);
          If I>=0 then SetupFileComboBox.ItemIndex:=I;
        end;
      end;
      TemplateNr:=-1;
    end;
    InitialFolderCheck;
    FolderEdit.Text:=ProfileFolder;
  finally
    JustChanging:=False;
  end;

  FolderEditChange(self);
  TypeSelectClick(self);
  ProfileNameChanged:=False;
end;

procedure TSelectTemplateForZipImportForm.ProfileNameEditChange(Sender: TObject);
begin
  ProfileNameChanged:=True;
end;

procedure TSelectTemplateForZipImportForm.SelectFilesFromAutoSetupTemplate;
Var I : Integer;
    S : String;
    St : TStringList;
begin
  FileToStart:=Templates[0];
  SetupFileToStart:='';
  S:=AutoSetupDB[Integer(Templates.Objects[0])].SetupExe;
  If Trim(S)<>'' then begin
    S:=ExtUpperCase(S);
    For I:=0 to PrgFiles.Count-1 do If ExtUpperCase(PrgFiles[I])=S then begin SetupFileToStart:=PrgFiles[I]; exit; end;
  end;

  St:=TStringList.Create;
  try
    St.AddStrings(PrgFiles);
    S:=ExtUpperCase(FileToStart);
    For I:=0 to St.Count-1 do If ExtUpperCase(St[I])=S then begin St.Delete(I); exit; end;
    If St.Count>0 then SetupFileToStart:=St[0];
  finally
    St.Free;
  end;
end;

procedure TSelectTemplateForZipImportForm.InitialFolderCheck;
Var GamesDir : String;
    I : Integer;
begin
  ProfileFolder:=MakeFileSysOKFolderName(ProfileNameEdit.Text);
  GamesDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);

  If (not DirectoryExists(GamesDir+ProfileFolder)) or PrgSetup.IgnoreDirectoryCollisions then exit;
  I:=0; repeat inc(I); until not DirectoryExists(GamesDir+ProfileFolder+IntToStr(I));
  ProfileFolder:=ProfileFolder+IntToStr(I);
end;

procedure TSelectTemplateForZipImportForm.FolderEditChange(Sender: TObject);
Var B : Boolean;
begin
  If JustChanging then exit;
  B:=DirectoryExists(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)+MakeFileSysOKFolderName(FolderEdit.Text));
  OKButton.Enabled:=not (FolderEdit.Visible and B);
  WarningLabel.Visible:=FolderEdit.Visible and B;
end;

procedure TSelectTemplateForZipImportForm.ComboBoxDropDown(Sender: TObject);
begin
  If Sender is TComboBox then SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TSelectTemplateForZipImportForm.TypeSelectClick(Sender: TObject);
Var I,J,K : Integer;
begin
  If JustChanging then exit;

  JustChanging:=True;
  try

    If TemplateType1RadioButton.Checked then begin
      TemplateComboBox.Items.BeginUpdate;
      try
        TemplateComboBox.Items.Clear;
        J:=0;
        For I:=0 to Templates.Count-1 do begin
          K:=Integer(Templates.Objects[I]);
          TemplateComboBox.Items.AddObject(AutoSetupDB[K].CacheName,Pointer(K));
          If K=TemplateNr then J:=I;
        end;
        TemplateComboBox.ItemIndex:=J;
      finally
        TemplateComboBox.Items.EndUpdate;
      end;
      TemplateComboBox.Visible:=(TemplateComboBox.Items.Count>1);
      ProgramFileComboBox.Visible:=False;
      SetupFileComboBox.Visible:=False;
    end;

    If TemplateType2RadioButton.Checked then begin
      TemplateComboBox.Items.BeginUpdate;
      try
        TemplateComboBox.Items.Clear;
        For I:=0 to AutoSetupDB.Count-1 do If TemplateComboBox.Items.IndexOf(AutoSetupDB[I].CacheName)<0 then
          TemplateComboBox.Items.AddObject(AutoSetupDB[I].CacheName,Pointer(I));
        If TemplateNr<0 then begin
          If Templates.Count>0 then TemplateNr:=Integer(Templates.Objects[0]) else TemplateNr:=0;
        end;
        TemplateComboBox.ItemIndex:=Min(TemplateComboBox.Items.Count-1,Max(0,TemplateNr));
      finally
        TemplateComboBox.Items.EndUpdate;
      end;
      TemplateComboBox.Visible:=True;
      ProgramFileComboBox.Visible:=(ProgramFileComboBox.Items.Count>1);
      SetupFileComboBox.Visible:=(SetupFileComboBox.Items.Count>2);
    end;

    If TemplateType3RadioButton.Checked then begin
      TemplateComboBox.Items.BeginUpdate;
      try
        TemplateComboBox.Items.Clear;
        TemplateComboBox.Items.Add(LanguageSetup.TemplateFormDefault);
        For I:=0 to TemplateDB.Count-1 do TemplateComboBox.Items.Add(TemplateDB[I].CacheName);
        TemplateComboBox.ItemIndex:=Min(TemplateComboBox.Items.Count-1,Max(0,-TemplateNr-1));
      finally
        TemplateComboBox.Items.EndUpdate;
      end;
      TemplateComboBox.Visible:=True;
      ProgramFileComboBox.Visible:=(ProgramFileComboBox.Items.Count>1);
      SetupFileComboBox.Visible:=(SetupFileComboBox.Items.Count>2);
    end;

  finally
    JustChanging:=False;
  end;

  TemplateLabel.Visible:=TemplateComboBox.Visible;
  ProgramFileLabel.Visible:=ProgramFileComboBox.Visible;
  SetupFileLabel.Visible:=SetupFileComboBox.Visible;

  TemplateComboBoxChange(Sender);
end;

procedure TSelectTemplateForZipImportForm.TemplateComboBoxChange(Sender: TObject);
begin
  If JustChanging then exit;

  If TemplateType3RadioButton.Checked then begin
    TemplateNr:=-TemplateComboBox.ItemIndex-1;
  end else begin
    TemplateNr:=Integer(TemplateComboBox.Items.Objects[TemplateComboBox.ItemIndex]);
  end;

  If (not TemplateType3RadioButton.Checked) and (not ProfileNameChanged) then begin
    ProfileNameEdit.Text:=TemplateComboBox.Text;
    ProfileNameChanged:=False;
  end;
end;

procedure TSelectTemplateForZipImportForm.OKButtonClick(Sender: TObject);
begin
  ProfileName:=ProfileNameEdit.Text;
  ProfileFolder:=FolderEdit.Text;
  If TemplateType1RadioButton.Checked then begin
    SelectFilesFromAutoSetupTemplate;
  end else begin
    FileToStart:=ProgramFileComboBox.Text;
    SetupFileToStart:=SetupFileComboBox.Text;
  end;

  If TemplateType3RadioButton.Checked then begin
    TemplateNr:=-TemplateComboBox.ItemIndex-1;
  end else begin
    TemplateNr:=Integer(TemplateComboBox.Items.Objects[TemplateComboBox.ItemIndex]);
  end;
end;

procedure TSelectTemplateForZipImportForm.InstallSupportButtonClick(Sender: TObject);
begin
  UseInstallSupport:=True;
  ModalResult:=mrOK;
end;

procedure TSelectTemplateForZipImportForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileImportZip);
end;

procedure TSelectTemplateForZipImportForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowSelectTemplateForZipImportDialog(const AOwner : TComponent; const AAutoSetupDB, ATemplateDB : TGameDB; const APrgFiles, ATemplates : TStringList; const AArchivFileName, AAlternateProfileNameSource, ATempFolder : String; var AProfileName, AFileToStart, ASetupFileToStart, AFolder : String; var ATemplateNr : Integer; const NoDialogIfAutoSetupIsAvailable, DoNotCopyFolder : Boolean; var UseInstallSupport : Boolean) : Boolean;
begin
  UseInstallSupport:=False;
  SelectTemplateForZipImportForm:=TSelectTemplateForZipImportForm.Create(AOwner);
  try
    SelectTemplateForZipImportForm.ArchivFileName:=AArchivFileName;
    SelectTemplateForZipImportForm.AlternateProfileNameSource:=AAlternateProfileNameSource;
    SelectTemplateForZipImportForm.AutoSetupDB:=AAutoSetupDB;
    SelectTemplateForZipImportForm.TemplateDB:=ATemplateDB;
    SelectTemplateForZipImportForm.PrgFiles:=APrgFiles;
    SelectTemplateForZipImportForm.Templates:=ATemplates;
    SelectTemplateForZipImportForm.Prepare(DoNotCopyFolder,ATempFolder);
    If SelectTemplateForZipImportForm.TemplateType1RadioButton.Checked and (NoDialogIfAutoSetupIsAvailable or PrgSetup.ImportZipWithoutDialogIfPossible) then begin
      result:=True;
      SelectTemplateForZipImportForm.OKButtonClick(SelectTemplateForZipImportForm);
    end else begin
      result:=(SelectTemplateForZipImportForm.ShowModal=mrOK);
      UseInstallSupport:=SelectTemplateForZipImportForm.UseInstallSupport;
    end;
    if result and not UseInstallSupport then begin
      AFileToStart:=SelectTemplateForZipImportForm.FileToStart;
      ASetupFileToStart:=SelectTemplateForZipImportForm.SetupFileToStart;
      ATemplateNr:=SelectTemplateForZipImportForm.TemplateNr;
      AProfileName:=SelectTemplateForZipImportForm.ProfileName;
      AFolder:=SelectTemplateForZipImportForm.ProfileFolder;
    end;
  finally
    SelectTemplateForZipImportForm.Free;
  end;
end;

end.
