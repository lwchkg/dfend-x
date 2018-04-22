unit ProfileMountEditorZipFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ProfileMountEditorFormUnit, ComCtrls, StdCtrls, ExtCtrls, Buttons,
  Menus;

type
  TProfileMountEditorZipFrame = class(TFrame, TProfileMountEditorFrame)
    ZipFolderButton: TSpeedButton;
    ZipFolderDriveLetterLabel: TLabel;
    ZipFolderFreeSpaceLabel: TLabel;
    ZipFolderDriveLetterWarningLabel: TLabel;
    ZipFileButton: TSpeedButton;
    ZipFolderEdit: TLabeledEdit;
    ZipFolderDriveLetterComboBox: TComboBox;
    ZipFolderFreeSpaceTrackbar: TTrackBar;
    ZipFileEdit: TLabeledEdit;
    OpenDialog: TOpenDialog;
    RepackTypeLabel: TLabel;
    RepackTypeComboBox: TComboBox;
    InfoLabel: TLabel;
    ZipFolderCreateButton: TSpeedButton;
    MakeNormalDriveButton: TBitBtn;
    PopupMenu: TPopupMenu;
    PopupExtractHere: TMenuItem;
    PopupExtractInGamesFolder: TMenuItem;
    procedure ZipFolderButtonClick(Sender: TObject);
    procedure ZipFolderDriveLetterComboBoxChange(Sender: TObject);
    procedure ZipFolderFreeSpaceTrackbarChange(Sender: TObject);
    procedure ZipFileButtonClick(Sender: TObject);
    procedure ZipFolderCreateButtonClick(Sender: TObject);
    procedure MakeNormalDriveButtonClick(Sender: TObject);
    procedure RepackTypeComboBoxChange(Sender: TObject);
    procedure RepackTypeComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
    SpecialSettings : String;
    Function ChangeExtraExeFile(const NewFolder : String; var ExeName : String) : Boolean;
    Procedure UpdateGameExe(const NewFolder : String);
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function CheckBeforeDone : Boolean;
    Function Done : String;
    Function GetName : String;
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts, ZipInfoFormUnit,
     IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorZipFrame }

function TProfileMountEditorZipFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S,T : String;
    I : Integer;
begin
  InfoData:=AInfoData;
  SpecialSettings:='';

  ZipFolderFreeSpaceTrackbar.Position:=DefaultFreeHDSize;

  ZipFolderEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  ZipFolderDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  ZipFolderDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  ZipFileEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingZipFile;

  ZipFolderButton.Hint:=LanguageSetup.ChooseFolder;
  ZipFolderCreateButton.Hint:=LanguageSetup.ProfileMountingZipFileAutoSetupFolder;
  ZipFileButton.Hint:=LanguageSetup.ChooseFile;

  ZipFolderDriveLetterComboBox.Items.BeginUpdate;
  try
    ZipFolderDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do ZipFolderDriveLetterComboBox.Items.Add(C);
    ZipFolderDriveLetterComboBox.ItemIndex:=2;
  finally
    ZipFolderDriveLetterComboBox.Items.EndUpdate;
  end;

  RepackTypeLabel.Caption:=LanguageSetup.ProfileMountingZipRepack;
  RepackTypeComboBox.Items[0]:=LanguageSetup.ProfileMountingZipRepackNoDelete;
  RepackTypeComboBox.Items[1]:=LanguageSetup.ProfileMountingZipRepackDeleteFiles;
  RepackTypeComboBox.Items[2]:=LanguageSetup.ProfileMountingZipRepackDeleteFolder;
  RepackTypeComboBox.Items[3]:=LanguageSetup.ProfileMountingZipRepackNoDeleteNoRepack;
  RepackTypeComboBox.Items[4]:=LanguageSetup.ProfileMountingZipRepackDeleteFilesNoRepack;
  RepackTypeComboBox.Items[5]:=LanguageSetup.ProfileMountingZipRepackDeleteFolderNoRepack;
  RepackTypeComboBox.ItemIndex:=0;

  InfoLabel.Caption:=LanguageSetup.ProfileMountingZipInfo;

  MakeNormalDriveButton.Caption:=LanguageSetup.ProfileMountingZipMakeNormalMount;
  MakeNormalDriveButton.Hint:=LanguageSetup.ProfileMountingZipMakeNormalMountHint;
  PopupExtractHere.Caption:=LanguageSetup.ProfileMountingZipMakeNormalMountHere;
  PopupExtractInGamesFolder.Caption:=LanguageSetup.ProfileMountingZipMakeNormalMountGamesDir;

  UserIconLoader.DialogImage(DI_SelectFolder,ZipFolderButton);
  UserIconLoader.DialogImage(DI_Create,ZipFolderCreateButton);
  UserIconLoader.DialogImage(DI_SelectFile,ZipFileButton);
  UserIconLoader.DirectLoad('ModernProfileEditor',4,MakeNormalDriveButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='ZIP' then begin
      {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder;no-norepack;files-norepack;folder-norepack)}
      result:=True;
      S:=Trim(St[0]); I:=Pos('$',S); If I=0 then T:='' else begin T:=Trim(Copy(S,I+1,MaxInt)); S:=Trim(Copy(S,1,I-1)); end;
      ZipFolderEdit.Text:=S; ZipFileEdit.Text:=T;
      If St.Count>=3 then begin
        I:=ZipFolderDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        ZipFolderDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        try I:=StrToInt(St[5]); except I:=0; end;
        If (I>=10) and (I<=4000) then ZipFolderFreeSpaceTrackBar.Position:=I;
      end;
      If St.Count>=7 then begin
        S:=Trim(ExtUpperCase(St[6]));
        If S='NO' then RepackTypeComboBox.ItemIndex:=0;
        If S='FILES' then RepackTypeComboBox.ItemIndex:=1;
        If S='FOLDER' then RepackTypeComboBox.ItemIndex:=2;
        If S='NO-NOREPACK' then RepackTypeComboBox.ItemIndex:=3;
        If S='FILES-NOREPACK' then RepackTypeComboBox.ItemIndex:=4;
        If S='FOLDER-NOREPACK' then RepackTypeComboBox.ItemIndex:=5;
      end;
    end else begin
      result:=False;
      For I:=2 to ZipFolderDriveLetterComboBox.Items.Count-1 do begin
        If Pos(ZipFolderDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin ZipFolderDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  ZipFolderDriveLetterComboBoxChange(self);
  ZipFolderFreeSpaceTrackBarChange(self);
  RepackTypeComboBoxChange(self);
end;

procedure TProfileMountEditorZipFrame.ShowFrame;
begin
end;

function TProfileMountEditorZipFrame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

function TProfileMountEditorZipFrame.Done: String;
Var S,T : String;
    B : Boolean;
begin
  If SpecialSettings<>'' then begin result:=SpecialSettings; exit; end;

  If Trim(ZipFolderEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFolderNameForMounting,mtError,[mbOK],0);
    result:='';
    exit;
  end;

  If Trim(ZipFileEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    result:='';
    exit;
  end;

  B:=True;

  S:=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(MakeRelPath(ZipFolderEdit.Text,PrgSetup.BaseDir,True))));
  T:=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True))));
  If Copy(S,1,2)='.\' then S:=Trim(Copy(S,3,MaxInt));
  If Copy(T,1,2)='.\' then T:=Trim(Copy(T,3,MaxInt));

  If (RepackTypeComboBox.ItemIndex>0) and (S=T) then begin
    If MessageDlg(Format(LanguageSetup.ProfileMountingFolderDeleteWarning,[PrgSetup.GameDir]),mtWarning,[mbYes,mbNo],0)<>mrYes then B:=False;
  end;

  {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder;no-norepack;files-norepack;folder-norepack)}
  S:=StringReplace(MakeRelPath(ZipFolderEdit.Text,PrgSetup.BaseDir)+'$'+MakeRelPath(ZipFileEdit.Text,PrgSetup.BaseDir),';','<semicolon>',[rfReplaceAll])+';ZIP;'+ZipFolderDriveLetterComboBox.Text+';False;';
  S:=S+';'+IntToStr(ZipFolderFreeSpaceTrackBar.Position);
  Case RepackTypeComboBox.ItemIndex of
    0 : S:=S+';no';
    1 : S:=S+';files';
    2 : S:=S+';folder';
    3 : S:=S+';no-norepack';
    4 : S:=S+';files-norepack';
    5 : S:=S+';folder-norepack';
  end;

  If B then result:=S else result:='';
end;

function TProfileMountEditorZipFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingZipSheet;
end;

procedure TProfileMountEditorZipFrame.ZipFolderButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(ZipFolderEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=ZipFolderEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorZipFrame.ZipFolderDriveLetterComboBoxChange(Sender: TObject);
begin
  ZipFolderDriveLetterWarningLabel.Visible:=(ZipFolderDriveLetterComboBox.ItemIndex>=0) and (Pos(ZipFolderDriveLetterComboBox.Items[ZipFolderDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorZipFrame.ZipFolderFreeSpaceTrackbarChange(Sender: TObject);
begin
  ZipFolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[ZipFolderFreeSpaceTrackbar.Position]);
end;

procedure TProfileMountEditorZipFrame.ZipFileButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(ZipFileEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=ZipFileEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='zip';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingZipFile;
  OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
  if not OpenDialog.Execute then exit;
  ZipFileEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorZipFrame.ZipFolderCreateButtonClick(Sender: TObject);
const AllowedChars='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyz01234567890-_=';
Var S : String;
    I : Integer;
begin
  S:='';
  For I:=1 to length(InfoData.ProfileFileName) do if Pos(InfoData.ProfileFileName[I],AllowedChars)>0 then S:=S+InfoData.ProfileFileName[I];
  If S='' then S:='Game';

  S:=ExtUpperCase(S);
  If length(S)>8 then SetLength(S,8);

  S:=MakeAbsPath('.\'+ZipTempDir+'\'+S,PrgSetup.BaseDir);
  If not ForceDirectories(S) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
  end;

  ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorZipFrame.MakeNormalDriveButtonClick(Sender: TObject);
Var P : TPoint;
    ZipFolder,ZipFile,GamesDir,S : String;
begin
  If Trim(ZipFolderEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFolderNameForMounting,mtError,[mbOK],0);
    exit;
  end;

  If Trim(ZipFileEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    exit;
  end;

  ZipFolder:=IncludeTrailingPathDelimiter(MakeAbsPath(ZipFolderEdit.Text,PrgSetup.BaseDir));
  ZipFile:=MakeAbsPath(ZipFileEdit.Text,PrgSetup.BaseDir);
  GamesDir:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));

  If not FileExists(ZipFile) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[ZipFile]),mtError,[mbOk],0);
    exit;
  end;

  If Sender is TBitBtn then begin
    If ExtUpperCase(Copy(ZipFolder,1,length(GamesDir)))=ExtUpperCase(GamesDir) then begin
      Sender:=PopupExtractHere;
    end else begin
      P:=ClientToScreen(Point(MakeNormalDriveButton.Left,MakeNormalDriveButton.Top));
      PopupMenu.Popup(P.X,P.Y);
      exit;
    end;
  end;

  Case (Sender as TComponent).Tag of
    0 : begin
          If MessageDlg(Format(LanguageSetup.ProfileMountingZipMakeNormalMountConfirmation,[ZipFile,ZipFolder]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          {Extract here}
          ExtractZipDrive(self,ZipFile,ZipFolder,ZipFolder);
          {RealFolder;DRIVE;Letter;False;;FreeSpace}
          If ExtUpperCase(Copy(ZipFolder,1,length(GamesDir)))=ExtUpperCase(GamesDir) then S:=GamesDir else S:=ZipFolder;
          SpecialSettings:=MakeRelPath(S,PrgSetup.BaseDir)+';DRIVE;'+ZipFolderDriveLetterComboBox.Text+';False;;'+IntToStr(ZipFolderFreeSpaceTrackBar.Position);
          UpdateGameExe(MakeRelPath(ZipFolder,PrgSetup.BaseDir));
          InfoData.CloseRequest(self);
        end;
    1 : begin
          {Extract to games dir subfolder}
          S:=ZipFolder;
          If (S<>'') and (S[length(S)]='\') then SetLength(S,length(S)-1);
          While Pos('\',S)<>0 do S:=Copy(S,Pos('\',S)+1,MaxInt);
          repeat
            If not InputQuery(LanguageSetup.ProfileMountingZipMakeNormalMountWorkCaption,LanguageSetup.ProfileMountingZipMakeNormalMountWorkLabel,S) then exit;
            S:=MakeFileSysOKFolderName(S);
            If DirectoryExists(GamesDir+S) then begin MessageDlg(Format(LanguageSetup.MessageDirectoryAlreadyExists,[GamesDir+S]),mtError,[mbOK],0); exit; end;
          until not DirectoryExists(GamesDir+S);
          If MessageDlg(Format(LanguageSetup.ProfileMountingZipMakeNormalMountConfirmation,[ZipFile,GamesDir+S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          ExtractZipDrive(self,ZipFile,ZipFolder,GamesDir+S);
          {RealFolder;DRIVE;Letter;False;;FreeSpace}
          SpecialSettings:=MakeRelPath(GamesDir,PrgSetup.BaseDir)+';DRIVE;'+ZipFolderDriveLetterComboBox.Text+';False;;'+IntToStr(ZipFolderFreeSpaceTrackBar.Position);
          UpdateGameExe(MakeRelPath(GamesDir,PrgSetup.BaseDir));
          InfoData.CloseRequest(self);
        end;
  end;
end;

procedure TProfileMountEditorZipFrame.RepackTypeComboBoxChange(Sender: TObject);
begin
  SetComboHint(RepackTypeComboBox);
end;

procedure TProfileMountEditorZipFrame.RepackTypeComboBoxDropDown(Sender: TObject);
begin
  SetComboDropDownDropDownWidth(RepackTypeComboBox);
end;

Function TProfileMountEditorZipFrame.ChangeExtraExeFile(const NewFolder : String; var ExeName : String) : Boolean;
Var S : String;
begin
  result:=False;
  If Copy(Trim(ExtUpperCase(ExeName)),1,7)<>'DOSBOX:' then exit;
  S:=Copy(Trim(ExeName),8,MaxInt);
  If (length(S)>=3) and (ExtUpperCase(S[1])=ZipFolderDriveLetterComboBox.Text) and (Copy(S,2,2)=':\') then begin
    S:=Copy(S,4,MaxInt);
    ExeName:=IncludeTrailingPathDelimiter(NewFolder)+S+ExtractFileName(InfoData.BaseGameFrame.SetupExeEdit.Text);
    result:=True;
  end;
end;

procedure TProfileMountEditorZipFrame.UpdateGameExe(const NewFolder: String);
Var S,T : String;
    I,J : Integer;
begin
  If InfoData.BaseGameFrame=nil then exit;

  If InfoData.BaseGameFrame.GameRelPathCheckBox.Checked then begin
    S:=Trim(IncludeTrailingPathDelimiter(ExtractFilePath(InfoData.BaseGameFrame.GameExeEdit.Text)));
    If (length(S)>=3) and (ExtUpperCase(S[1])=ZipFolderDriveLetterComboBox.Text) and (Copy(S,2,2)=':\') then begin
      S:=Copy(S,4,MaxInt);
      InfoData.BaseGameFrame.GameExeEdit.Text:=IncludeTrailingPathDelimiter(NewFolder)+S+ExtractFileName(InfoData.BaseGameFrame.GameExeEdit.Text);
      InfoData.BaseGameFrame.GameRelPathCheckBox.Checked:=False;
      InfoData.BaseGameFrame.GameExeEditChange(InfoData.BaseGameFrame.GameExeEdit);
    end;
  end;

  If InfoData.BaseGameFrame.SetupRelPathCheckBox.Checked then begin
    S:=Trim(IncludeTrailingPathDelimiter(ExtractFilePath(InfoData.BaseGameFrame.SetupExeEdit.Text)));
    If (length(S)>=3) and (ExtUpperCase(S[1])=ZipFolderDriveLetterComboBox.Text) and (Copy(S,2,2)=':\') then begin
      S:=Copy(S,4,MaxInt);
      InfoData.BaseGameFrame.SetupExeEdit.Text:=IncludeTrailingPathDelimiter(NewFolder)+S+ExtractFileName(InfoData.BaseGameFrame.SetupExeEdit.Text);
      InfoData.BaseGameFrame.SetupRelPathCheckBox.Checked:=False;
      InfoData.BaseGameFrame.SetupExeEditChange(InfoData.BaseGameFrame.SetupExeEdit);
    end;
  end;

  For I:=0 to InfoData.BaseGameFrame.ExtraExeFiles.Count-1 do begin
    S:=InfoData.BaseGameFrame.ExtraExeFiles[I];
    J:=Pos(';',S);
    If J>0 then begin
      T:=Copy(S,J+1,MaxInt);
      If ChangeExtraExeFile(NewFolder,T) then S:=Copy(S,1,J)+T;
    end;
    InfoData.BaseGameFrame.ExtraExeFiles[I]:=S;
  end;
end;

end.
