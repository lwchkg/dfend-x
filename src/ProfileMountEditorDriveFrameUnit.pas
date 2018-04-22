unit ProfileMountEditorDriveFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit,
  Menus;

type
  TProfileMountEditorDriveFrame = class(TFrame, TProfileMountEditorFrame)
    FolderEdit: TLabeledEdit;
    FolderButton: TSpeedButton;
    FolderDriveLetterLabel: TLabel;
    FolderDriveLetterComboBox: TComboBox;
    FolderDriveLetterWarningLabel: TLabel;
    FolderFreeSpaceLabel: TLabel;
    FolderFreeSpaceTrackBar: TTrackBar;
    MakeZipDriveButton: TBitBtn;
    SaveDialog: TSaveDialog;
    procedure FolderFreeSpaceTrackBarChange(Sender: TObject);
    procedure FolderButtonClick(Sender: TObject);
    procedure FolderDriveLetterComboBoxChange(Sender: TObject);
    procedure MakeZipDriveButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
    SpecialSettings : String;
    Function SelectZip : String;
    function UpdateGameExe(const OldPath, DriveLetter : String; var Name: String): Boolean;
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function CheckBeforeDone : Boolean;
    Function Done : String;
    Function GetName : String;
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, IconLoaderUnit,
     ModernProfileEditorBaseFrameUnit, ZipInfoFormUnit, PrgConsts;

{$R *.dfm}

{ TProfileMountEditorDriveFrame }

Function TProfileMountEditorDriveFrame.Init(const AInfoData: TInfoData) : Boolean;
Var C : Char;
    St : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;
  SpecialSettings:='';

  FolderFreeSpaceTrackBar.Position:=DefaultFreeHDSize;

  FolderEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  FolderDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  FolderDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  FolderButton.Hint:=LanguageSetup.ChooseFolder;

  FolderDriveLetterComboBox.Items.BeginUpdate;
  try
    FolderDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do FolderDriveLetterComboBox.Items.Add(C);
    FolderDriveLetterComboBox.ItemIndex:=2;
  finally
    FolderDriveLetterComboBox.Items.EndUpdate;
  end;

  MakeZipDriveButton.Caption:=LanguageSetup.ProfileMountingZipMakeFromNormalMount;
  MakeZipDriveButton.Hint:=LanguageSetup.ProfileMountingZipMakeFromNormalMountHint;
  MakeZipDriveButton.Visible:=(InfoData.BaseGameFrame<>nil) and (not InfoData.BaseGameFrame.GameRelPathCheckBox.Checked);

  UserIconLoader.DialogImage(DI_SelectFolder,FolderButton);
  UserIconLoader.DirectLoad('ModernProfileEditor',4,MakeZipDriveButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='DRIVE' then begin
      result:=True;
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      FolderEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=FolderDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FolderDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        try I:=StrToInt(St[5]); except I:=0; end;
        If (I>=10) and (I<=4000) then FolderFreeSpaceTrackBar.Position:=I;
      end;
    end else begin
      result:=False;
      For I:=2 to FolderDriveLetterComboBox.Items.Count-1 do begin
        If Pos(FolderDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin FolderDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  FolderDriveLetterComboBoxChange(self);
  FolderFreeSpaceTrackBarChange(self);
end;

procedure TProfileMountEditorDriveFrame.ShowFrame;
begin
end;

function TProfileMountEditorDriveFrame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

Function TProfileMountEditorDriveFrame.Done : String;
Var S,T : String;
begin
  If SpecialSettings<>'' then begin result:=SpecialSettings; exit; end;

  result:='';

  {RealFolder;DRIVE;Letter;False;;FreeSpace}
  S:=Trim(IncludeTrailingPathDelimiter(FolderEdit.Text));
  If (length(S)=3) and (Copy(S,2,2)=':\') then begin
    If MessageDlg(LanguageSetup.MessageRootDirMountWaring,mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
  end;
  T:=MakeRelPath(FolderEdit.Text,PrgSetup.BaseDir); if T='' then T:='.\';                                                    
  result:=StringReplace(T,';','<semicolon>',[rfReplaceAll])+';Drive;'+FolderDriveLetterComboBox.Text+';False;;';
  If FolderFreeSpaceTrackBar.Position<>DefaultFreeHDSize then result:=result+IntToStr(FolderFreeSpaceTrackBar.Position);
end;

function TProfileMountEditorDriveFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingFolderSheet;
end;

procedure TProfileMountEditorDriveFrame.FolderButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(FolderEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=FolderEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  FolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorDriveFrame.FolderDriveLetterComboBoxChange(Sender: TObject);
begin
  FolderDriveLetterWarningLabel.Visible:=(FolderDriveLetterComboBox.ItemIndex>=0) and (Pos(FolderDriveLetterComboBox.Items[FolderDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorDriveFrame.FolderFreeSpaceTrackBarChange(Sender: TObject);
begin
  FolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[FolderFreeSpaceTrackbar.Position]);
end;

function TProfileMountEditorDriveFrame.SelectZip: String;
begin
  result:='';

  SaveDialog.InitialDir:=PrgSetup.BaseDir;
  SaveDialog.Title:=LanguageSetup.ProfileMountingZipMakeFromNormalMountSaveTitle;
  SaveDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);

  if not SaveDialog.Execute then exit;
  If FileExists(SaveDialog.FileName) then begin
    If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[SaveDialog.FileName]),mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
  end;
  result:=SaveDialog.FileName;
end;

function TProfileMountEditorDriveFrame.UpdateGameExe(const OldPath, DriveLetter : String; var Name: String): Boolean;
Var Old,S : String;
begin
  Old:=IncludeTrailingPathDelimiter(MakeAbsPath(OldPath,PrgSetup.BaseDir));
  S:=IncludeTrailingPathDelimiter(MakeAbsPath(ExtractFilePath(Name),PrgSetup.BaseDir));
  result:=(ExtUpperCase(Copy(S,1,length(Old)))=ExtUpperCase(Old)); If not result then exit;
  Name:=DriveLetter+':\'+Copy(S,length(Old)+1)+ExtractFileName(Name);
end;

procedure TProfileMountEditorDriveFrame.MakeZipDriveButtonClick(Sender: TObject);
Var F : TModernProfileEditorBaseFrame;
    ThisGameDir,MountDir,ZipFile,S,T : String;
    I,J : Integer;
begin
  If (Trim(FolderEdit.Text)='') or (Trim(FolderEdit.Text)='\') then begin
    MessageDlg(LanguageSetup.MessageNoFolderName,mtError,[mbOK],0);
    exit;
  end;

  F:=InfoData.BaseGameFrame;

  MountDir:=IncludeTrailingPathDelimiter(MakeAbsPath(FolderEdit.Text,PrgSetup.BaseDir));

  If (Trim(F.GameExeEdit.Text)='') or F.GameRelPathCheckBox.Checked then ThisGameDir:='' else ThisGameDir:=IncludeTrailingPathDelimiter(MakeAbsPath(ExtractFilePath(F.GameExeEdit.Text),PrgSetup.BaseDir));

  If (ThisGameDir='') or (ExtUpperCase(Copy(ThisGameDir,1,length(MountDir)))<>ExtUpperCase(MountDir)) then begin
    {Pack entry folder; no hints from game file, no game file changing}
    If ExtUpperCase(MountDir)=ExtUpperCase(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir))) then begin
      MessageDlg(LanguageSetup.ProfileMountingZipMakeFromNormalMountErrorGameDir,mtError,[mbOK],0);
      exit;
    end;
    ZipFile:=SelectZip; If ZipFile='' then exit;
    If not BaseDirSecuriryCheckOnly(MountDir) then begin
      MessageDlg(Format(LanguageSetup.ProfileMountingZipMakeFromNormalMountSecurityError,[MountDir]),mtError,[mbOK],0);
      exit;
    end;
    If MessageDlg(Format(LanguageSetup.ProfileMountingZipMakeFromNormalMountConfirmation,[MountDir,ZipFile]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
    if not CreateZipFile(self,ZipFile,MountDir,dmFolder,GetCompressStrengthFromPrgSetup) then exit;
    {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder;no-norepack;files-norepack;folder-norepack)}
    SpecialSettings:=MakeRelPath(MountDir,PrgSetup.BaseDir)+'$'+MakeRelPath(ZipFile,PrgSetup.BaseDir)+';ZIP;'+FolderDriveLetterComboBox.Text+';False;;'+IntToStr(FolderFreeSpaceTrackBar.Position)+';folder';
    InfoData.CloseRequest(self);
    exit;
  end;

  {Pack game folder (=folder of GameExe), change game file path}
  If ExtUpperCase(ThisGameDir)=ExtUpperCase(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir))) then begin
    MessageDlg(LanguageSetup.ProfileMountingZipMakeFromNormalMountErrorGameDir,mtError,[mbOK],0);
    exit;
  end;
  ZipFile:=SelectZip;
  If not BaseDirSecuriryCheckOnly(ThisGameDir) then begin
    MessageDlg(Format(LanguageSetup.ProfileMountingZipMakeFromNormalMountSecurityError,[ThisGameDir]),mtError,[mbOK],0);
    exit;
  end;
  If MessageDlg(Format(LanguageSetup.ProfileMountingZipMakeFromNormalMountConfirmation,[ThisGameDir,ZipFile]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  if not CreateZipFile(self,ZipFile,ThisGameDir,dmFolder,GetCompressStrengthFromPrgSetup) then exit;

  S:=F.GameExeEdit.Text;
  If UpdateGameExe(ThisGameDir,FolderDriveLetterComboBox.Text,S) then begin
    F.GameExeEdit.Text:=S;
    F.GameRelPathCheckBox.Checked:=True;
  end;

  If (Trim(F.SetupExeEdit.Text)='') or F.SetupRelPathCheckBox.Checked then S:='' else S:=IncludeTrailingPathDelimiter(MakeAbsPath(ExtractFilePath(F.SetupExeEdit.Text),PrgSetup.BaseDir));
  If ExtUpperCase(Copy(S,1,length(MountDir)))=ExtUpperCase(MountDir) then begin
    S:=F.SetupExeEdit.Text;
    If UpdateGameExe(ThisGameDir,FolderDriveLetterComboBox.Text,S) then begin
      F.SetupExeEdit.Text:=S;
      F.SetupRelPathCheckBox.Checked:=True;
    end;
  end;

  For I:=0 to F.ExtraExeFiles.Count-1 do begin
    S:=F.ExtraExeFiles[I];
    J:=Pos(';',S);
    If J>0 then begin
      T:=Copy(S,J+1,MaxInt);
      If UpdateGameExe(ThisGameDir,FolderDriveLetterComboBox.Text,T) then S:=Copy(S,1,J)+'DOSBOX:'+T;
    end;
    F.ExtraExeFiles[I]:=S;
  end;

  {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder;no-norepack;files-norepack;folder-norepack)}
  SpecialSettings:=MakeRelPath(ThisGameDir,PrgSetup.BaseDir)+'$'+MakeRelPath(ZipFile,PrgSetup.BaseDir)+';ZIP;'+FolderDriveLetterComboBox.Text+';False;;'+IntToStr(FolderFreeSpaceTrackBar.Position)+';folder';
  InfoData.CloseRequest(self);
  exit;
end;

end.
