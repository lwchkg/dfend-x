unit InstallationSupportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit;

type
  TInstallationSupportForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    InstallTypeComboBox: TComboBox;
    ListBox: TListBox;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    DropInfoLabel: TLabel;
    AlwaysMountSourceCheckBox: TCheckBox;
    OpenDialog: TOpenDialog;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    InsertMediaLabel: TLabel;
    CDImageTypeLabel: TLabel;
    AlwaysMountSourceComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure InstallTypeComboBoxChange(Sender: TObject);
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonWork(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LastInstallType : Integer;
    Function EntryInList(const S : String) : Boolean;
  public
    { Public-Deklarationen }
  end;

var
  InstallationSupportForm: TInstallationSupportForm;

Function ShowInstallationSupportDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
Function RunInstallationFromFolder(const AOwner : TComponent; const AGameDB : TGameDB; const FolderName : String) : TGame;
Function RunInstallationFromDiskImage(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String) : TGame;
Function RunInstallationFromCDImage(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String) : TGame;
Function RunInstallationFromZipFile(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String; const FilesAlreadyInTempDir : String = '') : TGame;
Function TestInstallationSupportNeeded(const AFolder : String) : Boolean;

implementation

uses LanguageSetupUnit, CommonTools, VistaToolsUnit, IconLoaderUnit, HelpConsts,
     ClassExtensions, ZipInfoFormUnit, InstallationRunFormUnit, ZipPackageUnit,
     PrgConsts, ImageTools, PrgSetupUnit, SmallWaitFormUnit;

{$R *.dfm}

Function SystemHasFloppyDiskDrive : Boolean;
Var C : Char;
begin
  result:=False;
  For C:='A' to 'Z' do begin
    If GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin result:=True; exit; end;
  end;
end;

procedure TInstallationSupportForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.InstallationSupport;
  With InstallTypeComboBox.Items do begin
    Clear;
    If SystemHasFloppyDiskDrive then AddObject(LanguageSetup.InstallationSupportSourceFloppy,TObject(0));
    AddObject(LanguageSetup.InstallationSupportSourceFolder,TObject(1));
    AddObject(LanguageSetup.InstallationSupportSourceArchive,TObject(2));
    AddObject(LanguageSetup.InstallationSupportSourceFloppyImage,TObject(3));
    AddObject(LanguageSetup.InstallationSupportSourceCD,TObject(4));
    AddObject(LanguageSetup.InstallationSupportSourceCDImage,TObject(5));
  end;
  AlwaysMountSourceCheckBox.Caption:=LanguageSetup.InstallationSupportAlwaysMountSource;
  with AlwaysMountSourceComboBox.Items do begin
    Clear;
    Add(LanguageSetup.InstallationSupportAlwaysMountSourceCopy);
    Add(LanguageSetup.InstallationSupportAlwaysMountSourceLink);
  end;
  AlwaysMountSourceComboBox.ItemIndex:=0;

  UpButton.Hint:=LanguageSetup.MoveUp;
  DownButton.Hint:=LanguageSetup.MoveDown;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  CDImageTypeLabel.Caption:=LanguageSetup.ProfileMountingImageTypeInfo;

  OpenDialog.Title:=LanguageSetup.ChooseFile;

  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);
  UserIconLoader.DialogImage(DI_Up,UpButton);
  UserIconLoader.DialogImage(DI_Down,DownButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  If InstallTypeComboBox.Items.Count=6 then InstallTypeComboBox.ItemIndex:=2 else InstallTypeComboBox.ItemIndex:=1;
  LastInstallType:=-1;
  InstallTypeComboBoxChange(self);
end;

procedure TInstallationSupportForm.FormShow(Sender: TObject);
begin
  ListBox:=TListBox(NewWinControlType(ListBox,TListBoxAcceptingFiles,ctcmDangerousMagic));
  TListBoxAcceptingFiles(ListBox).ActivateAcceptFiles;
end;

procedure TInstallationSupportForm.InstallTypeComboBoxChange(Sender: TObject);
Var I : Integer;
begin
  FormShow(Sender);

  If (LastInstallType>=0) and (InstallTypeComboBox.ItemIndex<>LastInstallType) and ListBox.Visible and (ListBox.Items.Count>0) then begin
    If MessageDlg(LanguageSetup.InstallationSupportSourceClearList,mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      InstallTypeComboBox.ItemIndex:=LastInstallType; exit;
    end;
    ListBox.Items.Clear;
  end;
  If LastInstallType=InstallTypeComboBox.ItemIndex then exit;
  LastInstallType:=InstallTypeComboBox.ItemIndex;

  If InstallTypeComboBox.ItemIndex<0 then begin
    ListBox.Visible:=False;
    AddButton.Visible:=False;
    DelButton.Visible:=False;
    CDImageTypeLabel.Visible:=False;
    DropInfoLabel.Visible:=False;
    AlwaysMountSourceCheckBox.Visible:=False;
    OKButton.Enabled:=False;
    exit;
  end;

  I:=Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]);

  ListBox.Visible:=(I<>0) and (I<>4);
  AddButton.Visible:=(I<>0) and (I<>4);
  DelButton.Visible:=(I<>0) and (I<>4);
  UpButton.Visible:=(I<>0) and (I<>4);
  DownButton.Visible:=(I<>0) and (I<>4);
  DropInfoLabel.Visible:=(I<>0) and (I<>4);
  AlwaysMountSourceCheckBox.Visible:=(I=4) or (I=5);
  AlwaysMountSourceComboBox.Visible:=(I=5);
  InsertMediaLabel.Visible:=(I=0) or (I=4);
  CDImageTypeLabel.Visible:=(I=5);

  OKButton.Enabled:=not ListBox.Visible;
  UpButton.Enabled:=False;
  DownButton.Enabled:=False;

  Case I of
    0 : begin {Install from real floppy disks}
          InsertMediaLabel.Caption:=LanguageSetup.InstallationSupportInsertFirstFloppy;
        end;
    1 : begin {Install from folder}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddFolder;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelFolder;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropFolder;
          DropInfoLabel.Top:=AlwaysMountSourceComboBox.Top;
          ListBox.Height:=DropInfoLabel.Top-2-ListBox.Top;
        end;
    2 : begin {Install from archive files}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddArchive;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelArchive;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropArchive;
          DropInfoLabel.Top:=AlwaysMountSourceComboBox.Top;
          ListBox.Height:=DropInfoLabel.Top-2-ListBox.Top;
        end;
    3 : begin {Install from floppy image}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddFloppyImage;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelFloppyImage;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropFloppyImage;
          DropInfoLabel.Top:=AlwaysMountSourceComboBox.Top;
          ListBox.Height:=DropInfoLabel.Top-2-ListBox.Top;
        end;
    4 : begin {Install from CD drive}
          InsertMediaLabel.Caption:=LanguageSetup.InstallationSupportInsertFirstCD;
        end;
    5 : begin {Install from CD image}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddCDImage;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelCDImage;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropCDImage;
          DropInfoLabel.Top:=AlwaysMountSourceCheckBox.Top-5-DropInfoLabel.Height;
          CDImageTypeLabel.Top:=DropInfoLabel.Top-CDImageTypeLabel.Height;
          ListBox.Height:=CDImageTypeLabel.Top-2-ListBox.Top;
        end;
  end;

  ListBoxClick(Sender);
end;

procedure TInstallationSupportForm.ListBoxClick(Sender: TObject);
begin
  DelButton.Enabled:=(ListBox.ItemIndex>=0);
  UpButton.Enabled:=(ListBox.ItemIndex>=1);
  DownButton.Enabled:=(ListBox.ItemIndex>=0) and (ListBox.ItemIndex<ListBox.Items.Count-1);
end;

procedure TInstallationSupportForm.ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift=[] then Case Key of
    VK_INSERT : begin ButtonWork(AddButton); Key:=0; end;
    VK_DELETE : begin ButtonWork(DelButton); Key:=0; end;
  end;
end;

procedure TInstallationSupportForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S : String;
begin
  I:=Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]);

  Case I of
    3 : begin {Install from floppy image}
          If (ListBox.Items.Count>1) and (not PrgSetup.AllowMultiFloppyImagesMount) then begin
            MessageDlg(LanguageSetup.InstallationSupportMultiDiskError,mtError,[mbOK],0);
            ModalResult:=mrNone; exit;
          end;
        end;
    5 : begin {Install from CD image}
          For I:=0 to ListBox.Items.Count-1 do begin
            S:=MakeAbsPath(ListBox.Items[I],PrgSetup.BaseDir);
            If not CheckCDImage(S) then begin
              If MessageDlg(Format(LanguageSetup.ProfileMountingImageTypeWarning,[S]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin ModalResult:=mrNone; exit; end;
            end;
          end;
        end;
  end;
end;

procedure TInstallationSupportForm.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : Case Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]) of
          1 : begin {Install from folder}
                If SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then begin
                  If not EntryInList(S) then begin
                    ListBox.Items.Add(S);
                    ListBox.ItemIndex:=ListBox.Items.Count-1;
                  end;
                end;
              end;
          2 : begin {Install from archive files}
                OpenDialog.DefaultExt:='zip';
                OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
                If OpenDialog.Execute and not EntryInList(OpenDialog.FileName) then begin
                  ListBox.Items.Add(OpenDialog.FileName);
                  ListBox.ItemIndex:=ListBox.Items.Count-1;
                end;
              end;
          3 : begin {Install from floppy image}
                OpenDialog.DefaultExt:='img';
                OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilterImgOnly;
                If OpenDialog.Execute and not EntryInList(OpenDialog.FileName) then begin
                  ListBox.Items.Add(OpenDialog.FileName);
                  ListBox.ItemIndex:=ListBox.Items.Count-1;
                end;
              end;
          5 : begin {Install from CD image}
                OpenDialog.DefaultExt:='iso';
                OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
                If OpenDialog.Execute and not EntryInList(OpenDialog.FileName) then begin
                  ListBox.Items.Add(OpenDialog.FileName);
                  ListBox.ItemIndex:=ListBox.Items.Count-1;
                end;
              end;
        end;
    1 : If ListBox.ItemIndex>=0 then begin ListBox.Items.Delete(ListBox.ItemIndex); ListBoxClick(Sender); end;
    2 : If ListBox.ItemIndex>=1 then begin
          I:=ListBox.ItemIndex;
          S:=ListBox.Items[I-1]; ListBox.Items[I-1]:=ListBox.Items[I]; ListBox.Items[I]:=S;
          ListBox.ItemIndex:=I-1;
        end;
    3 : If (ListBox.ItemIndex>=0) and (ListBox.ItemIndex<ListBox.Items.Count-1) then begin
          I:=ListBox.ItemIndex;
          S:=ListBox.Items[I+1]; ListBox.Items[I+1]:=ListBox.Items[I]; ListBox.Items[I]:=S;
          ListBox.ItemIndex:=I+1;
        end;
  end;
  OKButton.Enabled:=(not ListBox.Visible) or (ListBox.Items.Count>0);
  ListBoxClick(Sender);
end;

procedure TInstallationSupportForm.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
Var I,J,Nr : Integer;
    St : TStringList;
    S : String;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  St:=Source as TStringList;

  If (St.Count>0) and (ListBox.Items.Count=0) then begin
    S:=St[0]; Nr:=-1;
    If DirectoryExists(S) then Nr:=1 else begin
      S:=ExtUpperCase(ExtractFileExt(S));
      If (Nr<0) and ((S='.ISO') or (S='.BIN') or (S='.CUE')) then Nr:=5;
      If (Nr<0) and ((S='.IMG') or (S='.IMA')) then Nr:=3;
      If (Nr<0) and ((S='.ZIP') or (S='.7Z')) then Nr:=2;
      If Nr<0 then For I:=0 to PrgSetup.PackerSettingsCount-1 do If ExtensionInList(S,PrgSetup.PackerSettings[I].FileExtensions) then begin Nr:=2; break; end;
    end;
    For I:=0 to InstallTypeComboBox.Items.Count-1 do if Integer(InstallTypeComboBox.Items.Objects[I])=Nr then begin
      If I<>InstallTypeComboBox.ItemIndex then begin
        InstallTypeComboBox.ItemIndex:=I;
        InstallTypeComboBoxChange(Sender);
      end;
      break;
    end;
  end;

  For I:=0 to St.Count-1 do if not EntryInList(St[I]) then begin
    If InstallTypeComboBox.ItemIndex>=0 then begin
      J:=Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]);
      Case J of
        1 : begin {Install from folder}
              If not DirectoryExists(St[I]) then continue;
            end;
        2 : begin {Install from archive files}
              If DirectoryExists(St[I]) then continue;
              If not FileExists(St[I]) then continue;
            end;
        3 : begin {Install from floppy image}
              If DirectoryExists(St[I]) then continue;
              If not FileExists(St[I]) then continue;
            end;
        5 : begin {Install from CD image}
              If DirectoryExists(St[I]) then continue;
              If not FileExists(St[I]) then continue;
            end;
      end;
    end;
    ListBox.Items.Add(St[I]);
  end;
  If ListBox.Items.Count>=0 then ListBox.ItemIndex:=ListBox.Items.Count-1;
  OKButton.Enabled:=(not ListBox.Visible) or (ListBox.Items.Count>0);
  ListBoxClick(Sender);
end;

function TInstallationSupportForm.EntryInList(const S: String): Boolean;
Var I : Integer;
    T : String;
begin
  result:=False;
  T:=ExtUpperCase(S);
  For I:=0 to ListBox.Items.Count-1 do If ExtUpperCase(ListBox.Items[I])=T then begin result:=True; exit; end;
end;

procedure TInstallationSupportForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileInstallationSupport);
end;

procedure TInstallationSupportForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure AddDriveToGame(const Game : TGame; const DriveSetup : String);
Var I,J,K : Integer;
    S : String;
    St : TStringList;
    FreeLetters : String;
begin
  FreeLetters:='CDEFGHIJKLMNOPQRSTUVWXYZ';

  J:=Game.NrOfMounts;

  For I:=0 to J-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count<3 then continue;
      K:=Pos(St[2],FreeLetters); If K>0 then FreeLetters[K]:='-';
    finally
      St.Free;
    end;
  end;

  For I:=1 to length(FreeLetters) do If FreeLetters[I]<>'-' then begin S:=FreeLetters[I]; break; end;

  Game.NrOfMounts:=J+1;
  Game.Mount[J]:=Format(DriveSetup,[S]);

  Game.StoreAllValues;
  Game.LoadCache;
end;

Procedure AddCDDrive(const Game : TGame);
begin
  AddDriveToGame(Game,'ASK;CDROM;%s;true;;');
end;

Procedure AddCDImages(const Game : TGame; const St : TStringList; const CopyFiles : Boolean);
Var Path : String;
    I,J : Integer;
    Images,S,T : String;
begin
  Images:='';

  If CopyFiles then begin
    Path:=IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir)))+'CDImages\';
    If not ForceDirectories(Path) then exit;
    LoadAndShowSmallWaitForm(LanguageSetup.InstallationSupportAlwaysMountSourceWait);
    try
      For I:=0 to St.Count-1 do begin
        T:=ExtractFileName(St[I]);
        S:=Path+T;

        {Check if destination file already exists, choose other destination name in this case}
        J:=1;
        While FileExists(S) do begin
          S:=Path+ChangeFileExt(T,'-'+IntToStr(J)+'.'+Copy(ExtractFileExt(T),2,MaxInt));
          inc(J);
        end;

        {Copy image file}
        CopyFile(PChar(St[I]),PChar(S),False);

        {One cue/bin images copy other file}
        If (ExtUpperCase(ExtractFileExt(St[I]))='.CUE') and FileExists(ChangeFileExt(St[I],'.bin')) then begin
          CopyFile(PChar(ChangeFileExt(St[I],'.bin')),PChar(ChangeFileExt(S,'.bin')),False);
        end;
        If (ExtUpperCase(ExtractFileExt(St[I]))='.BIN') and FileExists(ChangeFileExt(St[I],'.cue')) then begin
          CopyFile(PChar(ChangeFileExt(St[I],'.cue')),PChar(ChangeFileExt(S,'.cue')),False);
        end;

        {Add to mount command}
        S:=MakeRelPath(S,PrgSetup.BaseDir);
        If Images='' then Images:=S else Images:=Images+'$'+S;
      end;
    finally
      FreeSmallWaitForm;
    end;
  end else begin
    For I:=0 to St.Count-1 do begin
      S:=MakeRelPath(St[I],PrgSetup.BaseDir);
      If Images='' then Images:=S else Images:=Images+'$'+S;
    end;
  end;

  AddDriveToGame(Game,Images+';CDROMIMAGE;%s;;;');
end;

Function ShowInstallationSupportDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
Var I : Integer;
begin
  result:=nil;
  InstallationSupportForm:=TInstallationSupportForm.Create(AOwner);
  try
    If InstallationSupportForm.ShowModal=mrOK then begin
      InstallationRunForm:=TInstallationRunForm.Create(AOwner);
      try
        I:=Integer(InstallationSupportForm.InstallTypeComboBox.Items.Objects[InstallationSupportForm.InstallTypeComboBox.ItemIndex]);
        Case I of
          0 : InstallationRunForm.InstallType:=itFloppy;
          1 : InstallationRunForm.InstallType:=itFolder;
          2 : InstallationRunForm.InstallType:=itArchive;
          3 : InstallationRunForm.InstallType:=itFloppyImage;
          4 : InstallationRunForm.InstallType:=itCD;
          5 : InstallationRunForm.InstallType:=itCDImage;
        end;
        InstallationRunForm.Sources.AddStrings(InstallationSupportForm.ListBox.Items);
        If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
        if (result<>nil) and ((I=4) or (I=5)) and InstallationSupportForm.AlwaysMountSourceCheckBox.Checked then begin
          Case I of
            4 : AddCDDrive(result);
            5 : AddCDImages(result,InstallationRunForm.Sources,InstallationSupportForm.AlwaysMountSourceComboBox.ItemIndex=0);
          End;
        end;
      finally
        InstallationRunForm.Free;
      end;
    end;
  finally
    InstallationSupportForm.Free;
  end;
end;

Function RunInstallationFromFolder(const AOwner : TComponent; const AGameDB : TGameDB; const FolderName : String) : TGame;
begin
  result:=nil;
  InstallationRunForm:=TInstallationRunForm.Create(AOwner);
  try
    InstallationRunForm.InstallType:=itFolder;
    InstallationRunForm.Sources.Add(FolderName);
    If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
  finally
    InstallationRunForm.Free;
  end;
end;

Function RunInstallationFromDiskImage(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String) : TGame;
begin
  result:=nil;
  InstallationRunForm:=TInstallationRunForm.Create(AOwner);
  try
    InstallationRunForm.InstallType:=itFloppyImage;
    InstallationRunForm.Sources.Add(FileName);
    If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
  finally
    InstallationRunForm.Free;
  end;
end;

Function RunInstallationFromCDImage(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String) : TGame;
begin
  result:=nil;
  InstallationRunForm:=TInstallationRunForm.Create(AOwner);
  try
    InstallationRunForm.InstallType:=itCDImage;
    InstallationRunForm.Sources.Add(FileName);
    If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
    if result<>nil then AddCDImages(result,InstallationRunForm.Sources,True);
  finally
    InstallationRunForm.Free;
  end;
end;

Function RunInstallationFromZipFile(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String; const FilesAlreadyInTempDir : String) : TGame;
begin
  result:=nil;
  InstallationRunForm:=TInstallationRunForm.Create(AOwner);
  try
    InstallationRunForm.InstallType:=itArchive;
    InstallationRunForm.Sources.Add(FileName);
    InstallationRunForm.FilesAlreadyInTempDir:=FilesAlreadyInTempDir;
    If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
  finally
    InstallationRunForm.Free;
  end;
end;

Procedure FindProgramFiles(const Dir : String; const St : TStringList);
Var Rec : TSearchRec;
    I,J : Integer;
begin
  For J:=Low(ProgramExts) to high(ProgramExts) do begin
     I:=FindFirst(Dir+'*.'+ProgramExts[J],faAnyFile,Rec);
     try While I=0 do begin If ((Rec.Attr and faDirectory)=0) then St.Add(ExtUpperCase(ChangeFileExt(Rec.Name,''))); I:=FindNext(Rec); end;
     finally FindClose(Rec); end;
  end;
end;

Function TestInstallationSupportNeeded(const AFolder : String) : Boolean;
Var St,Names : TStringList;
    I,J : Integer;
    B : Boolean;
begin
  St:=TStringList.Create;
  try
    result:=False;
    FindProgramFiles(IncludeTrailingPathDelimiter(AFolder),St);
    I:=0; while I<St.Count do begin
      B:=True; For J:=Low(IgnoreGameExeFilesIgnore) to High(IgnoreGameExeFilesIgnore) do If St[I]=IgnoreGameExeFilesIgnore[J] then begin B:=False; break; end;
      If B then inc(I) else St.Delete(I);
    end;
    if St.Count<>1 then exit;
    Names:=ValueToList(PrgSetup.InstallerNames);
    try
      For I:=0 to Names.Count-1 do If ExtUpperCase(Names[I])=St[0] then begin result:=True; exit; end;
    finally
      Names.Free;
    end;
  finally
    St.Free;
  end;
end;

end.
