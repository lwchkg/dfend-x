unit ZipInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ZipMstr, ZMDelZip, SevenZipVCL, Buttons,
  System.UITypes;

Type TZipMode=(zmExtract, zmCreate, zmAdd, zmCreateAndDelete, zmAddAndDelete, zmDeleteOnly);

Type TDeleteMode=(dmNo, dmFiles, dmFolder, dmNoNoWarning, dmFilesNoWarning, dmFolderNoWarning); {Warning = Overwrite zip files warining}

type
  TZipInfoForm = class(TForm)
    ProgressBar: TProgressBar;
    InfoLabel: TLabel;
    CancelButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Zip : TZipMaster;
    SevenZip : TSevenZip;

    Start : Cardinal;
    ZipFile, Folder : String;
    Mode : TZipMode;
    FCompressStrength : TCompressStrength;
    FDeleteMode : TDeleteMode;
    FProcessingCanceled : Boolean;

    SevenZipLastError : Integer;
    SevenZipMaxProgress : Int64;

    Procedure PostShow(var Msg : TMessage); message WM_USER+1;
    Function ZipWork : Boolean;
    Procedure ZipExtract;
    Procedure ZipCreate;
    Procedure ZipAdd;
    Procedure ZipPassword(Sender: TObject; IsZipAction: Boolean; var NewPassword: String; const ForFile: String; var RepeatCount: LongWord; var Action: TMsgDlgBtn);
    Procedure ZipProgress(Sender: TObject; Details: TZMProgressDetails);
    Function SevenZipWork : Boolean;
    Procedure SevenZipExtract;
    Procedure SevenZipCreate;
    Procedure SevenZipPreProgress(Sender: TObject; MaxProgress: Int64);
    Procedure SevenZipProgress(Sender: TObject; Filename: WideString; FilePosArc, FilePosFile: Int64);
    Procedure SevenZipExtractOverwrite(Sender: TObject; FileName: WideString; var DoOverwrite: Boolean);
    Procedure SevenZipMessage( Sender: TObject; ErrCode: Integer; Message: string;Filename:Widestring );
    Function ExternalWork(const Nr : Integer) : Boolean;
    Function DeleteFolder(Folder : String; const ThisIsMainFolder : Boolean) : Boolean;
    Function DeleteFiles : Boolean;
  public
    { Public-Deklarationen }
    Function Init(const AMode : TZipMode; const AZipFile, AFolder : String) : Boolean;
    property CompressStrength : TCompressStrength read FCompressStrength write FCompressStrength;
    property DeleteMode : TDeleteMode read FDeleteMode write FDeleteMode;
  end;

var
  ZipInfoForm: TZipInfoForm;

Function ExtractZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String) : Boolean;
Function CreateZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode = dmNo; const CompressStrength : TCompressStrength = MAXIMUM) : Boolean;
Function AddToZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode = dmNo; const CompressStrength : TCompressStrength = MAXIMUM) : Boolean;
Function DeleteUnpackedFiles(const AOwner : TComponent; const ADestFolder : String; const DeleteMode : TDeleteMode = dmNo) : Boolean;

Function ExtractZipDrive(const AOwner : TComponent; const AZipFile, AZipAddFolder, ADestFolder : String) : Boolean;

Function CheckExtensionsList(Extensions : String) : String;
Function ExtensionInList(Extension, List : String) : Boolean;

Function ProcessFileNameFilter(Filter, ArchiveFiles : String) : String;

Function GetCompressStrengthFromPrgSetup : TCompressStrength;

implementation

uses Math, LanguageSetupUnit, PrgSetupUnit, CommonTools, DOSBoxUnit, PrgConsts,
     GameDBToolsUnit, VistaToolsUnit;

{$R *.dfm}

procedure TZipInfoForm.FormCreate(Sender: TObject);
begin
  FProcessingCanceled:=false;
  DoubleBuffered:=True;
  FCompressStrength:=MAXIMUM;
end;

function TZipInfoForm.Init(const AMode: TZipMode; const AZipFile, AFolder: String): Boolean;
begin
  result:=False;

  Mode:=AMode;
  ZipFile:=AZipFile;
  Folder:=IncludeTrailingPathDelimiter(AFolder);

  If (Mode=zmExtract) or (Mode=zmAdd) or (Mode=zmAddAndDelete) then begin
    If not FileExists(ZipFile) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[ZipFile]),mtError,[mbOK],0);
      exit;
    end;
  end;

  If (Mode=zmCreate) or (Mode=zmCreateAndDelete) then begin
    If FileExists(ZipFile) then begin
      If (FDeleteMode<>dmNoNoWarning) and (FDeleteMode<>dmFilesNoWarning) and (FDeleteMode<>dmFolderNoWarning) then begin
        If MessageDlg(Format(LanguageSetup.ZipFormOverwriteWarning,[ZipFile]),mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
      end;
      If not ExtDeleteFileWithPause(ZipFile,ftZipOperation) then begin MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ZipFile]),mtError,[mbOK],0); exit; end;
    end;
  end;

  InfoLabel.Caption:='';
  Refresh;

  If Mode=zmExtract then begin
    If not ForceDirectories(Folder) then begin MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Folder]),mtError,[mbOK],0); exit; end;
  end;

  If (Mode=zmCreate) or (Mode=zmAdd) or (Mode=zmCreateAndDelete) or (Mode=zmAddAndDelete) then begin
    If not DirectoryExists(Folder) then begin MessageDlg(Format(LanguageSetup.MessageDirectoryNotFound,[Folder]),mtError,[mbOK],0); exit; end;
  end;

  result:=True;

  Case Mode of
    zmExtract                   : Caption:=LanguageSetup.ZipFormCaptionExtract;
    zmCreate, zmCreateAndDelete : Caption:=LanguageSetup.ZipFormCaptionCreate;
    zmAdd, zmAddAndDelete       : Caption:=LanguageSetup.ZipFormCaptionAdd;
    zmDeleteOnly                : Caption:=LanguageSetup.ZipFormCaptionDelete;
  end;
end;

procedure TZipInfoForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  CancelButton.Caption:=LanguageSetup.Cancel;

  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TZipInfoForm.PostShow(var Msg: TMessage);
Var Ext,SaveDir : String;
    Ok, Handled : Boolean;
    I : Integer;
begin
  Start:=GetTickCount;

  SaveDir:=GetCurrentDir;
  try
    SetCurrentDir(ExtractFilePath(ExpandFileName(Application.ExeName)));

    if Mode=zmDeleteOnly then
      Ok:=True
    else begin
      Ext:=Trim(UpperCase(ExtractFileExt(ZipFile)));

      If (Mode in [zmCreate, zmAdd, zmCreateAndDelete, zmAddAndDelete]) and (not DirectoryExists(Folder)) then begin
        MessageDlg(Format(LanguageSetup.MessageDirectoryNotFound,[Folder]),mtError,[mbOk],0);
        ModalResult:=mrCancel;
        PostMessage(Handle,WM_CLOSE,0,0);
        exit;
      end;

      Handled:=False; Ok:=False;
      For I:=0 to PrgSetup.PackerSettingsCount-1 do begin
        If ExtensionInList(Ext,PrgSetup.PackerSettings[I].FileExtensions) then begin
          Handled:=True;
          Ok:=ExternalWork(I);
        end;
      end;

      If not Handled then begin
        If Ext='.ZIP' then begin Handled:=True; Ok:=ZipWork; end;
        If Ext='.7Z' then begin Handled:=True; Ok:=SevenZipWork; end;
      end;

      If not Handled then begin
        MessageDlg(Format(LanguageSetup.ZipFormUnknownExtension,[Ext]),mtError,[mbOK],0);
      end;
    end;

    If Ok and ((Mode=zmCreateAndDelete) or (Mode=zmAddAndDelete) or (Mode=zmDeleteOnly)) then Ok:=DeleteFiles;
  finally
    SetCurrentDir(SaveDir);
  end;

  If Ok then ModalResult:=mrOK else ModalResult:=mrCancel;
  PostMessage(Handle,WM_CLOSE,0,0);
end;

Function TZipInfoForm.ZipWork : Boolean;
Var S : String;
begin
  result:=True;

  If FileExists(PrgDir + DelZipDll_Name) then begin
    Zip:=TZipMaster.Create(self);
  end else begin
    S:=GetCurrentDir;
    SetCurrentDir(PrgDir+BinFolder);
    Zip:=TZipMaster.Create(self);
    Zip.Dll_Load:=True;
    Zip.Unattended:=True;
    SetCurrentDir(S);
  end;

  try
    Zip.OnPasswordError := ZipPassword;
    Zip.OnProgress := ZipProgress;
    Zip.ZipFileName := ZipFile;
    Zip.RootDir := Folder;

    CancelButton.Enabled:=True;

    try case Mode of
      zmExtract                   : ZipExtract;
      zmCreate, zmCreateAndDelete : ZipCreate;
      zmAdd, zmAddAndDelete       : ZipAdd;
    end except end;

    while Zip.State = ZsBusy do begin
      Sleep(500);
      Application.ProcessMessages;
      if FProcessingCanceled then begin Zip.Cancel:=True; result:=false; break; end;
    end;

    If Zip.ErrCode<>0 then begin
      result:=False;
      If Mode=zmExtract
        then MessageDlg(LanguageSetup.ZipFormErrorExtract,mtError,[mbOK],0)
        else MessageDlg(LanguageSetup.ZipFormErrorCompress,mtError,[mbOK],0);
    end;
  finally
    Zip.Free;
  end;
end;

procedure TZipInfoForm.ZipExtract;
begin
  Zip.ExtrOptions:=[ExtrDirNames,ExtrOverWrite];
  Zip.ExtrBaseDir:=Folder;

  Zip.Extract;
end;

procedure TZipInfoForm.ZipCreate;
begin
  Case FCompressStrength of
    SAVE    : Zip.AddCompLevel:=0;
    FAST    : Zip.AddCompLevel:=3;
    NORMAL  : Zip.AddCompLevel:=7;
    MAXIMUM : Zip.AddCompLevel:=8;
    ULTRA   : Zip.AddCompLevel:=9;
  end;

  Zip.AddOptions := [AddHiddenFiles, AddDirNames {* , AddSeparateDirs *} ];
  Zip.FSpecArgs.Add('>*.*');

  Zip.Add;
end;

procedure TZipInfoForm.ZipAdd;
Var Rec : TSearchRec;
    I : Integer;
    B : Boolean;
begin
  Case FCompressStrength of
    SAVE    : Zip.AddCompLevel:=0;
    FAST    : Zip.AddCompLevel:=3;
    NORMAL  : Zip.AddCompLevel:=7;
    MAXIMUM : Zip.AddCompLevel:=8;
    ULTRA   : Zip.AddCompLevel:=9;
  end;

  Zip.AddOptions:=[AddHiddenFiles,AddDirNames, {* AddSeparateDirs, *} AddUpdate];
  Zip.FSpecArgs.Add('>*.*');

  B:=False;
  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Name<>'.') and (Rec.Name<>'..') then begin B:=True; break; end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If B then Zip.Add;
end;

procedure TZipInfoForm.ZipPassword(Sender: TObject; IsZipAction: Boolean;
    var NewPassword: String; const ForFile: String; var RepeatCount: LongWord;
    var Action: TMsgDlgBtn);
begin
  If InputQuery(LanguageSetup.ZipFormCaptionExtract,LanguageSetup.ZipFormPasswordPrompt,NewPassword) then Action:=mbOK else Action:=mbAbort;
end;

procedure TZipInfoForm.ZipProgress(Sender: TObject; Details: TZMProgressDetails);
Var S : String;
begin
  ProgressBar.Position:=Details.TotalPerCent;

  Case Mode of
    zmExtract                   : S:=LanguageSetup.ZipFormProgressExtract;
    zmCreate, zmCreateAndDelete : S:=LanguageSetup.ZipFormProgressCreate;
    zmAdd, zmAddAndDelete       : S:=LanguageSetup.ZipFormProgressAdd;
  end;

  InfoLabel.Caption:=
    Format(S,[ExtractFileName(ZipFile)])+#13+#13+Folder+#13+#13+
    Format(LanguageSetup.ZipFormProgress,[Details.TotalPerCent,Details.TotalPosition div 1024 div 1024,1000*Details.TotalPosition div 1024 div 1024 div Max(1,(GetTickCount-Start))]);

  if FProcessingCanceled then Zip.Cancel:=True;
end;

function TZipInfoForm.SevenZipWork: Boolean;
Var S : String;
begin
  result:=True;
  SevenZipLastError:=0;

  If FileExists(PrgDir+'7za.dll') then begin
    SevenZip:=TSevenZip.Create(self);
  end else begin
    S:=GetCurrentDir;
    SetCurrentDir(PrgDir+BinFolder);
    SevenZip:=TSevenZip.Create(self);
    SetCurrentDir(S);
  end;

  CancelButton.Enabled:=True;
  try
    SevenZip.SZFileName:=ZipFile;
    SevenZip.OnPreProgress:=SevenZipPreProgress;
    SevenZip.OnProgress:=SevenZipProgress;
    SevenZip.OnExtractOverwrite:=SevenZipExtractOverwrite;
    SevenZip.OnMessage:=SevenZipMessage;
    SevenZip.AddRootDir:=Folder;
    SevenZip.ExtrBaseDir:=Folder;

    Case Mode of
      zmExtract                   : SevenZipExtract;
      zmCreate, zmCreateAndDelete : SevenZipCreate;
      zmAdd, zmAddAndDelete       : begin
                                      MessageDlg(LanguageSetup.ZipFormErrorNoRepack7ZipSupport,mtError,[mbOK],0);
                                      result:=False;
                                      exit;
                                    end;
    end;

    If (SevenZip.ErrCode<>0) or (SevenZipLastError<>0) then begin
      result:=False;
      If Mode=zmExtract
        then MessageDlg(LanguageSetup.ZipFormErrorExtract,mtError,[mbOK],0)
        else MessageDlg(LanguageSetup.ZipFormErrorCompress,mtError,[mbOK],0);
    end;
    if FProcessingCanceled then result:=False;
  finally
    SevenZip.Free;
  end;
end;

Procedure TZipInfoForm.SevenZipExtract;
begin
  SevenZip.ExtractOptions:=SevenZip.ExtractOptions+[ExtractOverwrite];
  SevenZip.Files.Clear;

  SevenZip.Extract;
end;

Procedure TZipInfoForm.SevenZipCreate;
begin
  SevenZip.LZMACompressStrength:=FCompressStrength;
  SevenZip.AddOptions:=[AddRecurseDirs];
  SevenZip.Files.Clear;
  SevenZip.Files.AddString(Folder+'*.*');

  SevenZip.Add;
end;

procedure TZipInfoForm.SevenZipPreProgress(Sender: TObject; MaxProgress: Int64);
begin
  SevenZipMaxProgress:=MaxProgress;
end;

procedure TZipInfoForm.SevenZipProgress(Sender: TObject; Filename: WideString; FilePosArc, FilePosFile: Int64);
Var S : String;
begin
  ProgressBar.Position:=100*FilePosArc div SevenZipMaxProgress;

  Case Mode of
    zmExtract                   : S:=LanguageSetup.ZipFormProgressExtract;
    zmCreate, zmCreateAndDelete : S:=LanguageSetup.ZipFormProgressCreate;
    zmAdd, zmAddAndDelete       : S:=LanguageSetup.ZipFormProgressAdd;
  end;

  InfoLabel.Caption:=
    Format(S,[ExtractFileName(ZipFile)])+#13+#13+Folder+#13+#13+
    Format(LanguageSetup.ZipFormProgress,[100*FilePosArc div SevenZipMaxProgress,FilePosArc div 1024 div 1024,1000*FilePosArc div 1024 div 1024 div Max(1,(GetTickCount-Start))]);

  Application.ProcessMessages;
  if FProcessingCanceled then SevenZip.Cancel;
end;

procedure TZipInfoForm.SevenZipExtractOverwrite(Sender: TObject; FileName: WideString; var DoOverwrite: Boolean);
begin
  DoOverwrite:=True;
end;

procedure TZipInfoForm.SevenZipMessage(Sender: TObject; ErrCode: Integer; Message: string; Filename: Widestring);
begin
  If ErrCode=FDataError then begin
    MessageDlg(LanguageSetup.ZipFormErrorNoPassword7ZipSupport,mtError,[mbOK],0);
    SevenZipLastError:=ErrCode;
    SevenZip.Cancel;
    exit;
  end;

  If ErrCode in [FFileNotFound, FDataError, FCRCError, FUnsupportedMethod, FIndexOutOfRange, FSFXModuleError] then begin
    SevenZipLastError:=ErrCode;
    SevenZip.Cancel;
    exit;
  end;
end;

Function TZipInfoForm.ExternalWork(const Nr : Integer) : Boolean;
Var PrgName,Parameters,ParametersOrig : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    I : Integer;
begin
  result:=True;

  PrgName:=PrgSetup.PackerSettings[Nr].ZipFileName;
  If not FileExists(PrgName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[PrgName]),mtError,[mbOK],0);
    result:=False;
    exit;
  end;

  Case Mode of
    zmExtract : Parameters:=PrgSetup.PackerSettings[Nr].ExtractFile;
    zmCreate, zmCreateAndDelete : Parameters:=PrgSetup.PackerSettings[Nr].CreateFile;
    zmAdd, zmAddAndDelete : Parameters:=PrgSetup.PackerSettings[Nr].UpdateFile;
  end;
  ParametersOrig:=Parameters;

  I:=Pos('%1',Parameters);
  If I=0 then begin
    MessageDlg(Format(LanguageSetup.ZipFormInvalidParameters,[ParametersOrig]),mtError,[mbOK],0);
    result:=False;
    exit;
  end;
  Parameters:=Copy(Parameters,1,I-1)+ZipFile+Copy(Parameters,I+2,MaxInt);

  I:=Pos('%2',Parameters);
  If I=0 then begin
    MessageDlg(Format(LanguageSetup.ZipFormInvalidParameters,[ParametersOrig]),mtError,[mbOK],0);
    result:=False;
    exit;
  end;
  If PrgSetup.PackerSettings[Nr].TrailingBackslash then begin
    Parameters:=Copy(Parameters,1,I-1)+IncludeTrailingPathDelimiter(Folder)+Copy(Parameters,I+2,MaxInt);
  end else begin
    Parameters:=Copy(Parameters,1,I-1)+ExcludeTrailingPathDelimiter(Folder)+Copy(Parameters,I+2,MaxInt);
  end;

  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;

  If not CreateProcess(PChar(PrgName),PChar('"'+PrgName+'" '+Parameters),nil,nil,False,0,nil,nil,StartupInfo,ProcessInformation) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[PrgName]),mtError,[mbOK],0);
    exit;
  end;

  InfoLabel.Caption:=Caption;
  Paint;

  try
    While not (WaitForSingleObject(ProcessInformation.hProcess,0)=WAIT_OBJECT_0) do begin
      Application.ProcessMessages;
      Sleep(100);
    end;
  finally
    CloseHandle(ProcessInformation.hThread);
    CloseHandle(ProcessInformation.hProcess);
  end;
end;

Function TZipInfoForm.DeleteFolder(Folder : String; const ThisIsMainFolder : Boolean) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;
  Folder:=IncludeTrailingPathDelimiter(Folder);
  If length(Folder)=3 then exit;

  If not DirectoryExists(Folder) then begin result:=True; exit; end;

  If not BaseDirSecuriryCheck(Folder) then exit;

  I:=FindFirst(Folder+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
          if not DeleteFolder(Folder+Rec.Name,False) then exit;
        end;
      end else begin
        If not ExtDeleteFile(Folder+Rec.Name,ftZipOperation) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[Folder+Rec.Name]),mtError,[mbOK],0);
          exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If (not ThisIsMainFolder) or (FDeleteMode=dmFolder) or (FDeleteMode=dmFolderNoWarning) then begin
    if not ExtDeleteFolder(Folder,ftZipOperation) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Folder]),mtError,[mbOK],0);
      exit;
    end;
  end;

  result:=True;
end;

procedure TZipInfoForm.CancelButtonClick(Sender: TObject);
begin
  CancelButton.Enabled:=False;
  FProcessingCanceled:=true;
end;

function TZipInfoForm.DeleteFiles: Boolean;
begin
  DeleteFolder(Folder,True);
  result:=True;
end;

{ global }

Function ZipDialogWork(const AOwner : TComponent; const AZipFile, ADestFolder : String; const AZipMode : TZipMode; const ACompressStrength : TCompressStrength; const ADeleteMode : TDeleteMode) : Boolean;
begin
  result:=False;
  ZipInfoForm:=TZipInfoForm.Create(AOwner);
  try
    ZipInfoForm.CompressStrength:=ACompressStrength;
    ZipInfoForm.DeleteMode:=ADeleteMode;
    if not ZipInfoForm.Init(AZipMode,AZipFile,ADestFolder) then exit;
    result:=(ZipInfoForm.ShowModal=mrOK);
  finally
    ZipInfoForm.Free;
  end;
end;

Function ExtractZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String) : Boolean;
begin
  result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmExtract,MAXIMUM,dmNo);
end;

Function CreateZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode; const CompressStrength : TCompressStrength) : Boolean;
begin
  If (DeleteMode<>dmNo) and (DeleteMode<>dmNoNoWarning)
    then result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmCreateAndDelete,CompressStrength,DeleteMode)
    else result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmCreate,CompressStrength,DeleteMode);
end;

Function AddToZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode; const CompressStrength : TCompressStrength) : Boolean;
begin
  If (DeleteMode<>dmNo) and (DeleteMode<>dmNoNoWarning)
    then result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmAddAndDelete,CompressStrength,DeleteMode)
    else result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmAdd,CompressStrength,DeleteMode);
end;

Function DeleteUnpackedFiles(const AOwner : TComponent; const ADestFolder : String; const DeleteMode : TDeleteMode = dmNo) : Boolean;
begin
  If (DeleteMode=dmNo) or (DeleteMode=dmNoNoWarning) then begin result:=True; exit; end;
  result:=ZipDialogWork(AOwner,'',ADestFolder,zmDeleteOnly,SAVE,DeleteMode);
end;

Function ExtractZipDrive(const AOwner : TComponent; const AZipFile, AZipAddFolder, ADestFolder : String) : Boolean;
begin
  If AZipAddFolder=ADestFolder then begin
    {DestFolder->TempFolder}
    result:=ExtDeleteFolder(TempDir+ZipTempDir,ftTemp); if not result then exit;
    ForceDirectories(TempDir+ZipTempDir);
    try
      CopyFiles(ADestFolder,TempDir+ZipTempDir,True,True);
      {ZipFile+TempFolder -> DestFolder}
      result:=ExtractZipFile(AOwner,AZipFile,ADestFolder); if not result then exit;
      result:=CopyFiles(TempDir+ZipTempDir,ADestFolder,True,True);
    finally
      {Delete TempFolder}
      ExtDeleteFolder(TempDir+ZipTempDir,ftTemp);
    end;
  end else begin
    {ZipFile+ZipAddFolder -> DestFolder}
    result:=ExtractZipFile(AOwner,AZipFile,ADestFolder);
    if not result then exit;
    result:=CopyFiles(AZipAddFolder,ADestFolder,True,True);
  end;
end;

Function CheckExtension(Extension : String) : String;
begin
  result:='';

  If Extension='' then exit;
  If Extension[1]='*' then Delete(Extension,1,1);

  If Extension='' then exit;
  If Extension[1]='.' then Delete(Extension,1,1);

  result:=Extension;
end;

Function CheckExtensionsList(Extensions : String) : String;
Var I : Integer;
    S : String;
begin
  result:='';
  Extensions:=Trim(Extensions);

  repeat
    I:=Pos(';',Extensions);
    If I>0 then begin
      S:=CheckExtension(Trim(Copy(Extensions,1,I-1)));
      Extensions:=Trim(Copy(Extensions,I+1,MaxInt));
    end else begin
      S:=CheckExtension(Extensions);
      Extensions:='';
    end;
    If S<>'' then begin
      If result<>'' then result:=result+';';
      result:=result+S;
    end;
  until I=0;
end;

Function ExtensionInList(Extension, List : String) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  Extension:=Trim(ExtUpperCase(CheckExtension(Extension)));

  List:=Trim(List);
  repeat
    I:=Pos(';',List);
    If I>0 then begin
      S:=CheckExtension(Trim(Copy(List,1,I-1)));
      List:=Trim(Copy(List,I+1,MaxInt));
    end else begin
      S:=CheckExtension(List);
      List:='';
    end;
    If Trim(ExtUpperCase(S))=Extension then begin result:=True; exit; end;
  until I=0;
end;

Function ProcessFileNameFilter(Filter, ArchiveFiles : String) : String;
Var I,J : Integer;
    St : TStringList;
    S,T,U : String;
begin
  result:=Filter;

  I:=Pos('%s',Filter); If I=0 then exit;
  S:=Copy(Filter,I+2,MaxInt); I:=Pos('%s',S); If I=0 then exit;
  S:=Copy(S,I+2,MaxInt); I:=Pos('%s',S); If I=0 then exit;

  St:=TStringList.Create;
  try
    For I:=0 to PrgSetup.PackerSettingsCount-1 do begin
      S:=Trim(PrgSetup.PackerSettings[I].FileExtensions);
      while S<>'' do begin
        J:=Pos(';',S);
        If J>0 then begin T:=Copy(S,1,J-1); S:=Copy(S,J+1,MaxInt); end else begin T:=S; S:=''; end;
        T:=ExtUpperCase(T);
        If St.IndexOf(T)<0 then St.Add(T);
      end;
    end;
    S:=''; For I:=0 to St.Count-1 do S:=S+', *.'+ExtLowerCase(St[I]);
    U:=''; For I:=0 to St.Count-1 do U:=U+';*.'+ExtLowerCase(St[I]);
    T:=''; For I:=0 to St.Count-1 do T:=T+Format(ArchiveFiles,[ExtLowerCase(St[I])])+' (*.'+ExtLowerCase(St[I])+')|*.'+ExtLowerCase(St[I])+'|';
    result:=Format(Filter,[S,U,T]);
  finally
    St.Free;
  end;
end;

Function GetCompressStrengthFromPrgSetup : TCompressStrength;
begin
  Case PrgSetup.CompressionLevel of
    0 : result:=SAVE;
    1 : result:=FAST;
    2 : result:=NORMAL;
    3 : result:=MAXIMUM;
    4 : result:=ULTRA;
    else result:=MAXIMUM;
  end;
end;

end.
