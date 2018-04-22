unit BuildInstallerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, CheckLst, GameDBUnit, Menus, ComCtrls;

type
  TBuildInstallerForm = class(TForm)
    SaveDialog: TSaveDialog;
    PopupMenu: TPopupMenu;
    PageControl: TPageControl;
    GamesSheet: TTabSheet;
    AutoSetupSheet: TTabSheet;
    InfoLabel: TLabel;
    DestFileButton: TSpeedButton;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    DestFileEdit: TLabeledEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    InstTypeRadioGroup: TRadioGroup;
    GroupGamesCheckBox: TCheckBox;
    SelectGenreButton: TBitBtn;
    OKButton2: TBitBtn;
    CancelButton2: TBitBtn;
    InfoLabel2: TLabel;
    ListBox2: TCheckListBox;
    SelectAllButton2: TBitBtn;
    SelectNoneButton2: TBitBtn;
    SelectGenreButton2: TBitBtn;
    GroupGamesCheckBox2: TCheckBox;
    InstTypeRadioGroup2: TRadioGroup;
    DestFileEdit2: TLabeledEdit;
    DestFileButton2: TSpeedButton;
    PopupMenu2: TPopupMenu;
    TemplatesSheet: TTabSheet;
    InfoLabel3: TLabel;
    ListBox3: TCheckListBox;
    SelectAllButton3: TBitBtn;
    SelectNoneButton3: TBitBtn;
    SelectGenreButton3: TBitBtn;
    GroupGamesCheckBox3: TCheckBox;
    InstTypeRadioGroup3: TRadioGroup;
    DestFileButton3: TSpeedButton;
    PopupMenu3: TPopupMenu;
    OKButton3: TBitBtn;
    CancelButton3: TBitBtn;
    DestFileEdit3: TLabeledEdit;
    HelpButton3: TBitBtn;
    HelpButton: TBitBtn;
    HelpButton2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure DestFileButtonClick(Sender: TObject);
    procedure OKButton3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectButtonClick2(Sender: TObject);
    procedure OKButton2Click(Sender: TObject);
    procedure DestFileButton2Click(Sender: TObject);
    procedure SelectButtonClick3(Sender: TObject);
    procedure DestFileButton3Click(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    TemplateDB, AutoSetupDB : TGameDB;
    Function GetNSIFileName(var NSIFileName : String; const Mode : Integer) : Boolean;
    Function BuildNSIScript : Boolean;
    Function BuildNSIScript2 : Boolean;
    function BuildNSIScript3: Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  BuildInstallerForm: TBuildInstallerForm;

Function BuildInstaller(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

function CheckPath(NSIPath: String): Boolean;
function AddTemplateToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
function AddAutoSetupToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
function AddGameToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
function BuildEXEInstaller(const Handle : THandle; const FileName : String) : Boolean;
Function GetNSISPath : String;

implementation

uses Registry, ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit,
     CommonTools, PrgConsts, GameDBToolsUnit, UninstallFormUnit, HelpConsts,
     IconLoaderUnit;

{$R *.dfm}

procedure TBuildInstallerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.BuildInstaller;

  { Games }

  GamesSheet.Caption:=LanguageSetup.BuildInstallerTypeCompleteGames;
  InfoLabel.Caption:=LanguageSetup.BuildInstallerInfo;
  DestFileEdit.EditLabel.Caption:=LanguageSetup.BuildInstallerDestFile;
  DestFileButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  GroupGamesCheckBox.Caption:=LanguageSetup.BuildInstallerGroupGames;
  InstTypeRadioGroup.Caption:=LanguageSetup.BuildInstallerInstType;
  InstTypeRadioGroup.Items[0]:=LanguageSetup.BuildInstallerInstTypeScriptOnly;
  InstTypeRadioGroup.Items[1]:=LanguageSetup.BuildInstallerInstTypeFullInstaller;
  UserIconLoader.DialogImage(DI_SelectFile,DestFileButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  { AutoSetup templates }

  AutoSetupSheet.Caption:=LanguageSetup.BuildInstallerTypeAutoSetupProfiles;
  InfoLabel2.Caption:=LanguageSetup.BuildInstallerInfoAutoSetupTemplates;
  DestFileEdit2.EditLabel.Caption:=LanguageSetup.BuildInstallerDestFile;
  DestFileButton2.Hint:=LanguageSetup.ChooseFile;
  OKButton2.Caption:=LanguageSetup.OK;
  CancelButton2.Caption:=LanguageSetup.Cancel;
  HelpButton2.Caption:=LanguageSetup.Help;
  SelectAllButton2.Caption:=LanguageSetup.All;
  SelectNoneButton2.Caption:=LanguageSetup.None;
  SelectGenreButton2.Caption:=LanguageSetup.GameBy;
  GroupGamesCheckBox2.Caption:=LanguageSetup.BuildInstallerGroupGames;
  InstTypeRadioGroup2.Caption:=LanguageSetup.BuildInstallerInstType;
  InstTypeRadioGroup2.Items[0]:=LanguageSetup.BuildInstallerInstTypeScriptOnly;
  InstTypeRadioGroup2.Items[1]:=LanguageSetup.BuildInstallerInstTypeFullInstaller;
  UserIconLoader.DialogImage(DI_SelectFile,DestFileButton2);
  UserIconLoader.DialogImage(DI_OK,OKButton2);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton2);
  UserIconLoader.DialogImage(DI_Help,HelpButton2);

  { AutoSetup templates }

  TemplatesSheet.Caption:=LanguageSetup.BuildInstallerTypeTemplates;
  InfoLabel3.Caption:=LanguageSetup.BuildInstallerInfoTemplates;
  DestFileEdit3.EditLabel.Caption:=LanguageSetup.BuildInstallerDestFile;
  DestFileButton3.Hint:=LanguageSetup.ChooseFile;
  OKButton3.Caption:=LanguageSetup.OK;
  CancelButton3.Caption:=LanguageSetup.Cancel;
  HelpButton3.Caption:=LanguageSetup.Help;
  SelectAllButton3.Caption:=LanguageSetup.All;
  SelectNoneButton3.Caption:=LanguageSetup.None;
  SelectGenreButton3.Caption:=LanguageSetup.GameBy;
  GroupGamesCheckBox3.Caption:=LanguageSetup.BuildInstallerGroupGames;
  InstTypeRadioGroup3.Caption:=LanguageSetup.BuildInstallerInstType;
  InstTypeRadioGroup3.Items[0]:=LanguageSetup.BuildInstallerInstTypeScriptOnly;
  InstTypeRadioGroup3.Items[1]:=LanguageSetup.BuildInstallerInstTypeFullInstaller;
  UserIconLoader.DialogImage(DI_SelectFile,DestFileButton3);
  UserIconLoader.DialogImage(DI_OK,OKButton3);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton3);
  UserIconLoader.DialogImage(DI_Help,HelpButton3);

  { Dialog }

  SaveDialog.Title:=LanguageSetup.BuildInstallerDestFileTitle;
  SaveDialog.Filter:=LanguageSetup.BuildInstallerDestFileFilter;

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
end;

procedure TBuildInstallerForm.FormDestroy(Sender: TObject);
begin
  TemplateDB.Free;
  AutoSetupDB.Free;
end;

procedure TBuildInstallerForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,False,False,True);
  BuildCheckList(ListBox3,TemplateDB,False,False,True);
  BuildCheckList(ListBox2,AutoSetupDB,False,False,True);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False,True);
  BuildSelectPopupMenu(PopupMenu3,TemplateDB,SelectButtonClick3,False);
  BuildSelectPopupMenu(PopupMenu2,AutoSetupDB,SelectButtonClick2,False);
end;

procedure TBuildInstallerForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

procedure TBuildInstallerForm.SelectButtonClick2(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox2.Count-1 do ListBox2.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton2.Left,SelectGenreButton2.Top));
              PopupMenu2.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox2);
end;

procedure TBuildInstallerForm.SelectButtonClick3(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox3.Count-1 do ListBox3.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton3.Left,SelectGenreButton3.Top));
              PopupMenu3.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox3);
end;

Function TBuildInstallerForm.GetNSIFileName(var NSIFileName : String; const Mode : Integer) : Boolean;
Var S : String;
begin
  result:=False;

  Case Mode of
    0 : S:=DestFileEdit.Text;
    1 : S:=DestFileEdit3.Text;
    2 : S:=DestFileEdit2.Text;
    else S:='';
  end;

  NSIFileName:=Trim(S);
  If NSIFileName='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    exit;
  end;
  NSIFileName:=ChangeFileExt(NSIFileName,'.nsi');

  if not CheckPath(ExtractFilePath(NSIFileName)) then exit;

  If FileExists(NSIFileName) then begin
    If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[NSIFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  end;

  result:=True;
end;

function TBuildInstallerForm.BuildNSIScript: Boolean;
Var NSIFileName : String;
    St,GenreList : TStringList;
    I,J : Integer;
    S : String;
begin
  result:=False;
  if not GetNSIFileName(NSIFileName,0) then exit;

  St:=TStringList.Create;
  try
    St.Add('OutFile "'+ExtractFileName(DestFileEdit.Text)+'"');
    St.Add('!include ".\'+SettingsFolder+'\'+NSIInstallerHelpFile+'"');

    if GroupGamesCheckBox.Checked then begin
      GenreList:=TStringList.Create;
      try
        For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
          S:=Trim(ExtUpperCase(TGame(ListBox.Items.Objects[I]).Genre));
          If GenreList.IndexOf(S)<0 then begin
            GenreList.Add(S);
            St.Add('');
            St.Add('SectionGroup "'+TGame(ListBox.Items.Objects[I]).Genre+'"');
            For J:=I to ListBox.Items.Count-1 do If ListBox.Checked[J] and (Trim(ExtUpperCase(TGame(ListBox.Items.Objects[J]).Genre))=S) then begin
              if not AddGameToNSIScript(St,TGame(ListBox.Items.Objects[J])) then exit;
            end;
            St.Add('SectionGroupEnd');
          end;
        end;
      finally
        GenreList.Free;
      end;
    end else begin
      For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
        if not AddGameToNSIScript(St,TGame(ListBox.Items.Objects[I])) then exit;
      end;
    end;

    try
      St.SaveToFile(NSIFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NSIFileName]),mtError,[mbOK],0);
      exit;
    end;

  finally
    St.Free;
  end;
  result:=True;
end;

function TBuildInstallerForm.BuildNSIScript2: Boolean;
Var NSIFileName : String;
    St,GenreList : TStringList;
    I,J : Integer;
    S : String;
begin
  result:=False;
  if not GetNSIFileName(NSIFileName,2) then exit;

  St:=TStringList.Create;
  try
    St.Add('OutFile "'+ExtractFileName(DestFileEdit2.Text)+'"');
    St.Add('!include ".\'+SettingsFolder+'\'+NSIInstallerHelpFile+'"');

    if GroupGamesCheckBox2.Checked then begin
      GenreList:=TStringList.Create;
      try
        For I:=0 to ListBox2.Items.Count-1 do If ListBox2.Checked[I] then begin
          S:=Trim(ExtUpperCase(TGame(ListBox2.Items.Objects[I]).Genre));
          If GenreList.IndexOf(S)<0 then begin
            GenreList.Add(S);
            St.Add('');
            St.Add('SectionGroup "'+TGame(ListBox2.Items.Objects[I]).Genre+'"');
            For J:=I to ListBox2.Items.Count-1 do If ListBox2.Checked[J] and (Trim(ExtUpperCase(TGame(ListBox2.Items.Objects[J]).Genre))=S) then begin
              if not AddAutoSetupToNSIScript(St,TGame(ListBox2.Items.Objects[J])) then exit;
            end;
            St.Add('SectionGroupEnd');
          end;
        end;
      finally
        GenreList.Free;
      end;
    end else begin
      For I:=0 to ListBox2.Items.Count-1 do If ListBox2.Checked[I] then begin
        if not AddAutoSetupToNSIScript(St,TGame(ListBox2.Items.Objects[I])) then exit;
      end;
    end;

    try
      St.SaveToFile(NSIFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NSIFileName]),mtError,[mbOK],0);
      exit;
    end;

  finally
    St.Free;
  end;
  result:=True;
end;

function TBuildInstallerForm.BuildNSIScript3: Boolean;
Var NSIFileName : String;
    St,GenreList : TStringList;
    I,J : Integer;
    S : String;
begin
  result:=False;
  if not GetNSIFileName(NSIFileName,1) then exit;

  St:=TStringList.Create;
  try
    St.Add('OutFile "'+ExtractFileName(DestFileEdit3.Text)+'"');
    St.Add('!include ".\'+SettingsFolder+'\'+NSIInstallerHelpFile+'"');

    if GroupGamesCheckBox3.Checked then begin
      GenreList:=TStringList.Create;
      try
        For I:=0 to ListBox3.Items.Count-1 do If ListBox3.Checked[I] then begin
          S:=Trim(ExtUpperCase(TGame(ListBox3.Items.Objects[I]).Genre));
          If GenreList.IndexOf(S)<0 then begin
            GenreList.Add(S);
            St.Add('');
            St.Add('SectionGroup "'+TGame(ListBox3.Items.Objects[I]).Genre+'"');
            For J:=I to ListBox3.Items.Count-1 do If ListBox3.Checked[J] and (Trim(ExtUpperCase(TGame(ListBox3.Items.Objects[J]).Genre))=S) then begin
              if not AddTemplateToNSIScript(St,TGame(ListBox3.Items.Objects[J])) then exit;
            end;
            St.Add('SectionGroupEnd');
          end;
        end;
      finally
        GenreList.Free;
      end;
    end else begin
      For I:=0 to ListBox3.Items.Count-1 do If ListBox3.Checked[I] then begin
        if not AddTemplateToNSIScript(St,TGame(ListBox3.Items.Objects[I])) then exit;
      end;
    end;

    try
      St.SaveToFile(NSIFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NSIFileName]),mtError,[mbOK],0);
      exit;
    end;

  finally
    St.Free;
  end;
  result:=True;
end;

procedure TBuildInstallerForm.DestFileButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(DestFileEdit.Text);
  If (S='') or (Trim(ExtractFilePath(S))='') then SaveDialog.InitialDir:=PrgDataDir else SaveDialog.InitialDir:=Trim(ExtractFilePath(S));
  If not SaveDialog.Execute then exit;
  DestFileEdit.Text:=SaveDialog.FileName;
end;

procedure TBuildInstallerForm.DestFileButton2Click(Sender: TObject);
Var S : String;
begin
  S:=Trim(DestFileEdit2.Text);
  If (S='') or (Trim(ExtractFilePath(S))='') then SaveDialog.InitialDir:=PrgDataDir else SaveDialog.InitialDir:=Trim(ExtractFilePath(S));
  If not SaveDialog.Execute then exit;
  DestFileEdit2.Text:=SaveDialog.FileName;
end;

procedure TBuildInstallerForm.DestFileButton3Click(Sender: TObject);
Var S : String;
begin
  S:=Trim(DestFileEdit3.Text);
  If (S='') or (Trim(ExtractFilePath(S))='') then SaveDialog.InitialDir:=PrgDataDir else SaveDialog.InitialDir:=Trim(ExtractFilePath(S));
  If not SaveDialog.Execute then exit;
  DestFileEdit3.Text:=SaveDialog.FileName;
end;

procedure TBuildInstallerForm.OKButtonClick(Sender: TObject);
begin
  If (Trim(ExtractFilePath(DestFileEdit.Text))='') and (Trim(DestFileEdit.Text)<>'') then
    DestFileEdit.Text:=PrgDataDir+DestFileEdit.Text;
  If Trim(DestFileEdit.Text)<>'' then DestFileEdit.Text:=ChangeFileExt(DestFileEdit.Text,'.exe');

  If not BuildNSIScript then begin ModalResult:=mrNone; exit; end;
  If InstTypeRadioGroup.ItemIndex=1 then begin
    If not BuildEXEInstaller(Handle,DestFileEdit.Text) then begin ModalResult:=mrNone; exit; end;
  end;
end;

procedure TBuildInstallerForm.OKButton2Click(Sender: TObject);
begin
  If (Trim(ExtractFilePath(DestFileEdit2.Text))='') and (Trim(DestFileEdit2.Text)<>'') then
    DestFileEdit2.Text:=PrgDataDir+DestFileEdit2.Text;
  If Trim(DestFileEdit2.Text)<>'' then DestFileEdit2.Text:=ChangeFileExt(DestFileEdit2.Text,'.exe');

  If not BuildNSIScript2 then begin ModalResult:=mrNone; exit; end;
  If InstTypeRadioGroup2.ItemIndex=1 then begin
    If not BuildEXEInstaller(Handle,DestFileEdit2.Text) then begin ModalResult:=mrNone; exit; end;
  end;
end;

procedure TBuildInstallerForm.OKButton3Click(Sender: TObject);
begin
  If (Trim(ExtractFilePath(DestFileEdit3.Text))='') and (Trim(DestFileEdit3.Text)<>'') then
    DestFileEdit3.Text:=PrgDataDir+DestFileEdit3.Text;
  If Trim(DestFileEdit3.Text)<>'' then DestFileEdit3.Text:=ChangeFileExt(DestFileEdit3.Text,'.exe');

  If not BuildNSIScript3 then begin ModalResult:=mrNone; exit; end;
  If InstTypeRadioGroup3.ItemIndex=1 then begin
    If not BuildEXEInstaller(Handle,DestFileEdit3.Text) then begin ModalResult:=mrNone; exit; end;
  end;
end;

procedure TBuildInstallerForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileExportBuildInstallers);
end;

procedure TBuildInstallerForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function BuildInstaller(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  BuildInstallerForm:=TBuildInstallerForm.Create(AOwner);
  try
    BuildInstallerForm.GameDB:=AGameDB;
    result:=(BuildInstallerForm.ShowModal=mrOK);
  finally
    BuildInstallerForm.Free;
  end;
end;

function CheckPath(NSIPath: String): Boolean;
Var S,T : String;
begin
  S:=Trim(IncludeTrailingPathDelimiter(ExtUpperCase(NSIPath)));
  T:=Trim(IncludeTrailingPathDelimiter(ExtUpperCase(PrgDataDir)));
  If S=T then begin result:=True; exit; end;
  result:=(MessageDlg(Format(LanguageSetup.BuildInstallerPathWarning,[ExcludeTrailingPathDelimiter(PrgDataDir),ExcludeTrailingPathDelimiter(NSIPath)]),mtConfirmation,[mbYes,mbNo],0)=mrYes);
end;

function AddTemplateToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
begin
  Game.StoreAllValues;

  NSI.Add('');
  NSI.Add('Section "'+LanguageSetup.BuildInstallerShortInfoTemplate+': '+Game.Name+'"');
  NSI.Add('  SetOutPath "$DataInstDir\Confs"');
  NSI.Add('  File ".\'+TemplateSubDir+'\'+ExtractFileName(Game.SetupFile)+'"');
  NSI.Add('SectionEnd');

  result:=True;
end;

function AddAutoSetupToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
begin
  Game.StoreAllValues;

  NSI.Add('');
  NSI.Add('Section "'+LanguageSetup.BuildInstallerShortInfoAutoSetupTemplate+': '+Game.Name+'"');
  NSI.Add('  SetOutPath "$DataInstDir\Confs"');
  NSI.Add('  File ".\'+AutoSetupSubDir+'\'+ExtractFileName(Game.SetupFile)+'"');
  NSI.Add('SectionEnd');

  result:=True;
end;

function AddGameToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
Procedure AddFiles(S : String);
Var T : String;
begin
  S:=MakeRelPath(IncludeTrailingPathDelimiter(S),PrgDataDir); T:=S;
  If Copy(T,1,2)='.\' then T:=Copy(T,3,MaxInt);
  If Copy(T,1,1)='\' then T:=Copy(T,2,MaxInt);
  NSI.Add('  SetOutPath "$DataInstDir\'+T+'"');
  NSI.Add('  File /nonfatal /r "'+IncludeTrailingPathDelimiter(S)+'*.*"');
end;
Var S,T : String;
    I : Integer;
    St, Files, Folders : TStringList;
begin
  Game.StoreAllValues;

  NSI.Add('');
  NSI.Add('Section "'+Game.Name+'"');
  NSI.Add('  SetOutPath "$DataInstDir\Confs"');
  NSI.Add('  File ".\'+GameListSubDir+'\'+ExtractFileName(Game.SetupFile)+'"');

  If ScummVMMode(Game) then begin
    S:=Trim(Game.ScummVMPath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      AddFiles(S);
    end;
    S:=Trim(Game.ScummVMZip);
    If S<>'' then begin
      S:=MakeRelPath(S,PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      If (T<>'') and (T[1]='.') then Delete(T,1,1);
      If (T<>'') and (T[1]='\') then Delete(T,1,1);
      If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
      NSI.Add('  SetOutPath "$DataInstDir\'+T+'"');
      If (S<>'') and (S[1]='\') then S:='.'+S;
      NSI.Add('  File /nonfatal "'+S+'"');
    end;
    S:=Trim(Game.ScummVMSavePath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      AddFiles(S);
    end;
  end else begin
    S:=Trim(Game.GameExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S='' then S:=Trim(Game.SetupExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(S),PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      AddFiles(S);
    end;
  end;

  S:=Trim(Game.CaptureFolder);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
    If Copy(S,2,2)=':\' then begin
      MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
      result:=False; exit;
    end;
    AddFiles(S);
  end;

  S:=MakeAbsIconName(Game.Icon);
  If (S<>'') and FileExists(S) then begin
    If ExtractFilePath(Game.Icon)='' then begin
      NSI.Add('  SetOutPath "$DataInstDir\'+IconsSubDir+'"');
      NSI.Add('  File /nonfatal ".\'+IconsSubDir+'\'+Trim(Game.Icon)+'"');
    end else begin
      S:=MakeRelPath(S,PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      If (T<>'') and (T[1]='.') then Delete(T,1,1);
      If (T<>'') and (T[1]='\') then Delete(T,1,1);
      If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
      NSI.Add('  SetOutPath "$DataInstDir\'+T+'"');
      If (S<>'') and (S[1]='\') then S:='.'+S;
      NSI.Add('  File /nonfatal "'+S+'"');
    end;
  end;

  S:=Trim(Game.DataDir);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
    If Copy(S,2,2)=':\' then begin
      MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
      result:=False; exit;
    end;
    AddFiles(S);
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=MakeRelPath(St[I],PrgSetup.BaseDir);
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        T:=ExtractFilePath(S);
        If (T<>'') and (T[1]='.') then Delete(T,1,1);
        If (T<>'') and (T[1]='\') then Delete(T,1,1);
        If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
        NSI.Add('  SetOutPath "$DataInstDir\'+T+'"');
        If (S<>'') and (S[1]='\') then S:='.'+S;
        NSI.Add('  File /nonfatal "'+S+'"');
      end;
    finally
      St.Free;
    end;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(St[I]),PrgSetup.BaseDir));
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        AddFiles(S);
      end;
    finally
      St.Free;
    end;
  end;

  FileAndFoldersFromDrives(Game,Files,Folders);
  try
    For I:=0 to Files.Count-1 do begin
      S:=MakeRelPath(Files[I],PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      If (T<>'') and (T[1]='.') then Delete(T,1,1);
      If (T<>'') and (T[1]='\') then Delete(T,1,1);
      If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
      NSI.Add('  SetOutPath "$DataInstDir\'+T+'"');
      If (S<>'') and (S[1]='\') then S:='.'+S;
      NSI.Add('  File /nonfatal "'+S+'"');
    end;
    For I:=0 to Folders.Count-1 do begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(Folders[I]),PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      AddFiles(S);
    end;
  finally
    Files.Free;
    Folders.Free;
  end;

  NSI.Add('SectionEnd');

  result:=True;
end;

Function GetNSISPath : String;
Var Reg : TRegistry;
begin
  result:='';
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.Access:=KEY_QUERY_VALUE;
    if Reg.OpenKey('SOFTWARE\NSIS',False) then begin
      result:=Reg.ReadString('');
      If not FileExists(IncludeTrailingPathDelimiter(result)+'makensisw.exe') then result:='';
    end;
  finally
    Reg.Free;
  end;
end;

function BuildEXEInstaller(const Handle : THandle; const FileName : String) : Boolean;
Var S : String;
begin
  result:=False;

  {Check if NSIS is installed}
  S:=GetNSISPath;

  If S='' then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,['makensisw.exe'])+#13+LanguageSetup.BuildInstallerNeedNSIS,mtError,[mbOK],0);
    exit;
  end;

  {Copy D-Fend Reloaded DataInstaller.nsi to PrgDataDir if missing}
  If not FileExists(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile) then begin
    If FileExists(PrgDir+NSIInstallerHelpFile) then begin
      CopyFile(PChar(PrgDir+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False);
    end else begin
      If FileExists(PrgDir+BinFolder+'\'+NSIInstallerHelpFile) then begin
        CopyFile(PChar(PrgDir+BinFolder+'\'+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False);
      end;
    end;
  end;

  {Execute NSIS}
  ShellExecute(Handle,'open',PChar(IncludeTrailingPathDelimiter(S)+'makensisw.exe'),PChar('"'+ChangeFileExt(Trim(FileName),'.nsi')+'"'),nil,SW_SHOW);

  result:=True;
end;

end.
