unit InstallationRunFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GameDBUnit, CheckLst;

Type TInstallType=(itFloppy,itFolder,itArchive,itFloppyImage,itCD,itCDImage);

type
  TInstallationRunForm = class(TForm)
    InfoLabel: TLabel;
    SourceLabel: TLabel;
    SourceListBox: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SourceListBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    GamesDir : TStringList;
    TempFolder : String;
    LastFolder : Integer;
    AbortSetup, SecondTry : Boolean;
    Procedure PostShow(var Msg : TMessage); message WM_USER+1;
    Function InitialScanDir(const Dir : String) : TStringList;
    Function FindNewDir(const OldDir : TStringList; const NewDir : String) : String;
    Procedure FreeGamesDirData(const St : TStringList);
    Procedure RunInstaller;
    Procedure BuildMountCommand(const Game : TGame; var FileToStart : String; const StartUpCmds : TStringList);
    Procedure HideSourceSection;
    Function FindFileToStart(const Dir : String) : String;
  public
    { Public-Deklarationen }
    InstallType : TInstallType;
    Sources : TStringList;
    FilesAlreadyInTempDir : String;
    NewGameDir : String;
  end;

var
  InstallationRunForm: TInstallationRunForm;

implementation

uses VistaToolsUnit, CommonTools, LanguageSetupUnit, PrgSetupUnit, DOSBoxUnit,
     DOSBoxTempUnit, ZipInfoFormUnit, PrgConsts, GameDBToolsUnit, MainUnit;

{$R *.dfm}

procedure TInstallationRunForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  InstallType:=itArchive;
  Sources:=TStringList.Create;
  NewGameDir:='';
  FilesAlreadyInTempDir:='';
  AbortSetup:=False;
  SecondTry:=False;

  Caption:=LanguageSetup.InstallationSupportRun;
  InfoLabel.Caption:=LanguageSetup.InstallationSupportRunInfoStarting;
  SourceLabel.Caption:=LanguageSetup.InstallationSupportRunSource;

  TempFolder:='';
end;

procedure TInstallationRunForm.FormShow(Sender: TObject);
begin
  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TInstallationRunForm.FormDestroy(Sender: TObject);
begin
  Sources.Free;
end;

procedure TInstallationRunForm.PostShow(var Msg: TMessage);
begin
  GamesDir:=InitialScanDir(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
  try
    repeat
      SourceListBox.Items.Clear;
      AbortSetup:=False;
      InfoLabel.Caption:=LanguageSetup.InstallationSupportRunInfoRunning;
      RunInstaller;
      If AbortSetup then begin ModalResult:=mrCancel; exit; end;
      InfoLabel.Caption:=LanguageSetup.InstallationSupportRunInfoNewGameScan;
      NewGameDir:=FindNewDir(GamesDir,MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
      If NewGameDir<>'' then begin
        ModalResult:=mrOK;
      end else begin
        If MessageDlg(LanguageSetup.InstallationSupportRunInfoNewGameScanError,mtError,[mbYes,mbNo],0)<>mrYes then begin
          ModalResult:=mrCancel; break;
        end;
        SecondTry:=True;
      end;
    until ModalResult=mrOK;
  finally
    FreeGamesDirData(GamesDir);
  end;
end;

function TInstallationRunForm.InitialScanDir(const Dir: String): TStringList;
Var Rec : TSearchRec;
    I,J : Integer;
    St : TStringList;
begin
  result:=TStringList.Create;
  J:=0;
  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        inc(J); If J=10 then Application.ProcessMessages;
        St:=InitialScanDir(IncludeTrailingPathDelimiter(Dir)+Rec.Name);
        If St.Count=0 then FreeAndNil(St);
        result.AddObject(ExtUpperCase(Rec.Name),St);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

function TInstallationRunForm.FindNewDir(const OldDir: TStringList; const NewDir: String): String;
Var Rec : TSearchRec;
    I,J,K : Integer;
begin
  result:='';
  J:=0;
  I:=FindFirst(IncludeTrailingPathDelimiter(NewDir)+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        inc(J); If J=10 then Application.ProcessMessages;
        If OldDir=nil then begin
          result:=IncludeTrailingPathDelimiter(NewDir)+Rec.Name+'\'; exit;
        end;
        K:=OldDir.IndexOf(ExtUpperCase(Rec.Name));
        If K<0 then begin
          result:=IncludeTrailingPathDelimiter(NewDir)+Rec.Name+'\'; exit;
        end else begin
          result:=FindNewDir(TStringList(OldDir.Objects[K]),IncludeTrailingPathDelimiter(NewDir)+Rec.Name);
          if result<>'' then exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TInstallationRunForm.FreeGamesDirData(const St: TStringList);
Var I : Integer;
begin
  For I:=0 to St.Count-1 do If St.Objects[I]<>nil then FreeGamesDirData(TStringList(St.Objects[I]));
  St.Free;
end;

procedure TInstallationRunForm.HideSourceSection;
begin
  ClientHeight:=2*InfoLabel.Top+InfoLabel.Height;
  SourceListBox.Visible:=False;
end;

function TInstallationRunForm.FindFileToStart(const Dir: String): String;
Var S : String;
    I,J : Integer;
    Rec : TSearchRec;
    St,Names : TStringList;
begin
  result:='';
  S:=IncludeTrailingPathDelimiter(Dir);

  Names:=ValueToList(PrgSetup.InstallerNames);
  try
    For I:=0 to Names.Count-1 do For J:=Low(ProgramExts) to High(ProgramExts) do
      If FileExists(S+Names[I]+'.'+ProgramExts[J]) then begin result:=S+Names[I]+'.'+ProgramExts[J]; exit; end;
  finally
    Names.Free;
  end;

  St:=TStringList.Create;
  try
    For I:=Low(ProgramExts) to High(ProgramExts) do begin
      J:=FindFirst(S+'*.'+ProgramExts[I],faAnyFile,Rec);
      try
        While J=0 do begin
          St.Add(Rec.Name);
          J:=FindNext(Rec);
        end;
      finally
        FindClose(Rec);
      end;
    end;
    If St.Count=1 then result:=S+St[0];
  finally
    St.Free;
  end;
end;

Function FloppyDriveLetter : Char;
Var C : Char;
begin
  result:='A';
  if PrgSetup.DefaultFloppyDrive<>'' then result:=PrgSetup.DefaultFloppyDrive[1];
  For C:='A' to 'Z' do if GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin result:=C; exit; end;
end;

Function GetCDDriveWithMedia : Char;
Var C : Char;
    I : Integer;
    Rec : TSearchRec;
begin
  result:='D';

  For C:='A' to 'Z' do if GetDriveType(PChar(C+':\'))=DRIVE_CDROM then begin
    I:=FindFirst(C+':\*.*',faAnyFile,Rec); FindClose(Rec);
    If I=0 then begin result:=C; exit; end;
  end;

  For C:='A' to 'Z' do if GetDriveType(PChar(C+':\'))=DRIVE_CDROM then begin result:=C; exit; end;
end;

procedure TInstallationRunForm.BuildMountCommand(const Game: TGame; var FileToStart: String; const StartUpCmds : TStringList);
Var S : String;
    I : Integer;
begin
  Game.NrOfMounts:=2;
  Game.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;';

  Case InstallType of
         itFloppy : begin
                      Game.Mount1:=FloppyDriveLetter+':\;FLOPPY;A;False;;';
                      If SecondTry then FileToStart:='' else FileToStart:=FindFileToStart(FloppyDriveLetter+':\');
                      If FileToStart='' then StartUpCmds.Add('A:');
                      HideSourceSection;
                    end;
         itFolder : begin
                       If Sources.Count=1 then begin
                         Game.Mount1:=Sources[0]+';Drive;A;false;';
                         FileToStart:=FindFileToStart(Sources[0]);
                         If FileToStart='' then StartUpCmds.Add('A:');
                         HideSourceSection;
                       end else begin
                         TempFolder:=TempDir+TempSubFolder;
                         Game.Mount1:=TempFolder+';Drive;A;false;';
                         SourceListBox.Items.AddStrings(Sources);
                         SourceListBox.Checked[0]:=True;
                         SourceListBox.ItemIndex:=0;
                         LastFolder:=-1;
                         SourceListBoxClick(self);
                         If SecondTry then FileToStart:='' else FileToStart:=FindFileToStart(TempFolder);
                         If FileToStart='' then StartUpCmds.Add('A:');
                       end;
                    end;
        itArchive : begin
                      If FilesAlreadyInTempDir<>'' then TempFolder:=FilesAlreadyInTempDir else TempFolder:=TempDir+TempSubFolder;
                      Game.Mount1:=TempFolder+';Drive;A;false;';
                      If FilesAlreadyInTempDir='' then begin
                        If not ExtractZipFile(self,Sources[0],TempFolder) then AbortSetup:=True;
                      end;
                      If SecondTry then FileToStart:='' else FileToStart:=FindFileToStart(TempFolder);
                      If FileToStart='' then StartUpCmds.Add('A:');
                      If Sources.Count=1 then begin
                        HideSourceSection;
                      end else begin
                        SourceListBox.Items.AddStrings(Sources);
                        SourceListBox.Checked[0]:=True;
                        LastFolder:=0;
                      end;
                    end;
    itFloppyImage : begin
                      StartUpCmds.Add('A:');
                        If PrgSetup.AllowMultiFloppyImagesMount then begin
                        S:=Sources[0];
                        For I:=1 to Sources.Count-1 do S:=S+'$'+Sources[I];
                        Game.Mount1:=S+';FLOPPYIMAGE;A;;;';
                        HideSourceSection;
                      end else begin
                        If Sources.Count=1 then begin
                           Game.Mount1:=Sources[0]+';FLOPPYIMAGE;A;;;';
                           HideSourceSection;
                        end else begin
                          TempFolder:=TempDir+TempSubFolder;
                          ForceDirectories(TempFolder);
                          Game.Mount1:=TempFolder+'\Temp.img;FLOPPYIMAGE;A;false;';
                          SourceListBox.Items.AddStrings(Sources);
                          SourceListBox.Checked[0]:=True;
                          SourceListBox.ItemIndex:=0;
                          LastFolder:=-1;
                          SourceListBoxClick(self);
                        end;
                      end;
                    end;
             itCD : begin
                      S:=GetCDDriveWithMedia+':\';
                      Game.Mount1:=S+';CDROM;D;false;;';
                      If SecondTry then FileToStart:='' else FileToStart:=FindFileToStart(S);
                      If FileToStart='' then StartUpCmds.Add('D:');
                      HideSourceSection;
                    end;
        itCDImage : begin
                      S:=Sources[0];
                      For I:=1 to Sources.Count-1 do S:=S+'$'+Sources[I];
                      Game.Mount1:=S+';CDROMIMAGE;D;;;';
                      StartUpCmds.Add('D:');
                      HideSourceSection;
                    end;
  end;
end;

Procedure SplitText(const St : TStringList; const Lines : String);
Var I : Integer;
    S : String;
begin
  SetLength(S,length(Lines)*2);
  CharToOEM(PChar(Lines),PChar(S));
  SetLength(S,StrLen(PChar(S)));

  While length(S)>75 do begin
    I:=75;
    While (I>1) and (S[I]<>' ') do dec(I);
    If S[I]=' ' then begin
      {space in first 75 chars}
      St.Add('echo '+Trim(Copy(S,1,I-1)));
      S:=Trim(Copy(S,I+1,MaxInt));
    end else begin
      {no space in 1..75}
      I:=76;
      While (I<length(S)) and (S[I]<>' ') do inc(I);
      If I=length(S) then begin
        {no space at all}
        St.Add('echo '+Trim(S));
        exit;
      end else begin
        {space after 75}
        St.Add('echo '+Trim(Copy(S,1,I-1)));
        S:=Trim(Copy(S,I+1,MaxInt));
      end;
    end;
  end;
  St.Add('echo '+Trim(S));
end;

procedure TInstallationRunForm.RunInstaller;
Var TempGame : TTempGame;
    St,St2,St3 : TStringList;
    FileToStart : String;
    DOSBoxHandle : THandle;
    I : Integer;
begin
  TempGame:=TTempGame.Create;
  try
    TempGame.Game.StartFullscreen:=False;
    TempGame.Game.CloseDosBoxAfterGameExit:=False;
    If (ExtUpperCase(TempGame.Game.Cycles)='AUTO') or (TryStrToInt(TempGame.Game.Cycles,I) and (I<20000)) then TempGame.Game.Cycles:='20000';
    FileToStart:='';
    St2:=TStringList.Create;
    try
      BuildMountCommand(TempGame.Game,FileToStart,St2);
      If AbortSetup then exit;
      St:=StringToStringList(TempGame.Game.Autoexec);
      try
        St.AddStrings(St2);
        St.Add('cls');
        If FileToStart='' then begin
          SplitText(St,LanguageSetup.InstallationSupportRunNoGameFile);
        end else begin
          SplitText(St,LanguageSetup.InstallationSupportRunStartGameFile1);
          St.Add('echo.');
          SplitText(St,LanguageSetup.InstallationSupportRunStartGameFile2);
          TempGame.Game.GameExe:=FileToStart;
          St3:=TStringList.Create;
          try
            St3.Add('echo.');
            SplitText(St3,LanguageSetup.InstallationSupportRunStartGameFile3);
            St3.Add('echo.');
            SplitText(St3,LanguageSetup.InstallationSupportRunStartGameFile2);
            St3.Add('echo.');
            TempGame.Game.AutoexecFinalization:=StringListToString(St3);
          finally
            St3.Free;
          end;
        end;
        St.Add('echo.');
        SplitText(St,LanguageSetup.InstallationSupportRunInstallationStart1);
        St.Add('echo.');
        SplitText(St,LanguageSetup.InstallationSupportRunInstallationStart2);
        If (InstallType=itCDImage) and (Sources.Count>1) then begin
          St.Add('echo.');
          SplitText(St,LanguageSetup.InstallationSupportRunInstallationStart3);
        end;
        If (InstallType=itFloppyImage) and (Sources.Count>1) and PrgSetup.AllowMultiFloppyImagesMount then begin
          St.Add('echo.');
          SplitText(St,LanguageSetup.InstallationSupportRunInstallationStart4);
        end;
        If FileToStart<>'' then begin
          St.Add('echo.');
          St.Add('pause');
        end;
        TempGame.Game.Autoexec:=StringListToString(St);
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    TempGame.Game.StoreAllValues;
    DOSBoxHandle:=RunCommandAndGetHandle(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',True);
    try
      While not (WaitForSingleObject(DOSBoxHandle,0)=WAIT_OBJECT_0) do begin
        Sleep(100);
        Application.ProcessMessages;
      end;
    finally
      CloseHandle(DOSBoxHandle);
    end;
    If (TempFolder<>'') and (FilesAlreadyInTempDir='') then ExtDeleteFolder(TempFolder,ftTemp);
  finally
    TempGame.Free;
  end;
end;

procedure TInstallationRunForm.SourceListBoxClick(Sender: TObject);
Var I : Integer;
    InitialChange : Boolean;
begin
  If SourceListBox.ItemIndex<0 then exit;
  For I:=0 to SourceListBox.Items.Count-1 do SourceListBox.Checked[I]:=(I=SourceListBox.ItemIndex);
  If SourceListBox.ItemIndex=LastFolder then exit;
  InitialChange:=(LastFolder=-1);
  LastFolder:=SourceListBox.ItemIndex;

  If InstallType=itFolder then begin
    ExtDeleteFolder(TempFolder,ftTemp);
    CopyFiles(IncludeTrailingPathDelimiter(Sources[LastFolder]),TempFolder,False,False);
  end;

  If InstallType=itArchive then begin
    ExtDeleteFolder(TempFolder,ftTemp);
    ExtractZipFile(self,Sources[LastFolder],TempFolder);
  end;

  If InstallType=itFloppyImage then begin
    ExtDeleteFile(TempFolder+'\Temp.img',ftTemp);
    CopyFile(PChar(Sources[LastFolder]),PChar(TempFolder+'\Temp.img'),False);
  end;

  If not InitialChange then MessageDlg(LanguageSetup.InstallationSupportRunUpdateDirectoryInformation,mtInformation,[mbOK],0);
end;

end.
