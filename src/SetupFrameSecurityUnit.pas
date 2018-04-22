unit SetupFrameSecurityUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, CheckLst, SetupFormUnit;

type
  TSetupFrameSecurity = class(TFrame, ISetupFrame)
    AskBeforeDeleteCheckBox: TCheckBox;
    DeleteProectionCheckBox: TCheckBox;
    DeleteProectionLabel: TLabel;
    UseChecksumsCheckBox: TCheckBox;
    UseChecksumsLabel: TLabel;
    RecycleBinLabel: TLabel;
    RecycleBinListBox: TCheckListBox;
    OfferRunAsAdminCheckBox: TCheckBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts, CommonTools;

{$R *.dfm}

{ TSetupFrameSecurity }

function TSetupFrameSecurity.GetName: String;
begin
  result:=LanguageSetup.SetupFormSecuritySheet;
end;

procedure TSetupFrameSecurity.InitGUIAndLoadSetup(var InitData: TInitData);
Var S : String;
begin
  AskBeforeDeleteCheckBox.Checked:=PrgSetup.AskBeforeDelete;
  DeleteProectionCheckBox.Checked:=PrgSetup.DeleteOnlyInBaseDir;
  UseChecksumsCheckBox.Checked:=PrgSetup.UseCheckSumsForProfiles;

  while RecycleBinListBox.Items.Count<7 do RecycleBinListBox.Items.Add('');
  S:=Copy(PrgSetup.DeleteToRecycleBin,1,7);
  S:=S+Copy('1011110',length(S)+1,MaxInt);

  RecycleBinListBox.Checked[0]:=(S[Integer(ftProfile)+1]='1');
  RecycleBinListBox.Checked[1]:=(S[Integer(ftMediaViewer)+1]='1');
  RecycleBinListBox.Checked[2]:=(S[Integer(ftDataViewer)+1]='1');
  RecycleBinListBox.Checked[3]:=(S[Integer(ftUninstall)+1]='1');
  RecycleBinListBox.Checked[4]:=(S[Integer(ftQuickStart)+1]='1');
  RecycleBinListBox.Checked[5]:=(S[Integer(ftZipOperation)+1]='1');
  RecycleBinListBox.Checked[6]:=(S[Integer(ftTemp)+1]='1');

  OfferRunAsAdminCheckBox.Checked:=PrgSetup.OfferRunAsAdmin;
end;

procedure TSetupFrameSecurity.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameSecurity.LoadLanguage;
begin
  NoFlicker(AskBeforeDeleteCheckBox);
  NoFlicker(DeleteProectionCheckBox);
  NoFlicker(UseChecksumsCheckBox);
  {NoFlicker(RecycleBinListBox);}

  AskBeforeDeleteCheckBox.Caption:=LanguageSetup.SetupFormAskBeforeDelete;
  DeleteProectionCheckBox.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDir;
  DeleteProectionLabel.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDirLabel;
  UseChecksumsCheckBox.Caption:=LanguageSetup.SetupFormUseChecksums;
  UseChecksumsLabel.Caption:=LanguageSetup.SetupFormUseChecksumsInfo;
  RecycleBinLabel.Caption:=LanguageSetup.SetupFormRecycleBin;
  while RecycleBinListBox.Items.Count<7 do RecycleBinListBox.Items.Add('');
  RecycleBinListBox.Items[0]:=LanguageSetup.SetupFormRecycleBinProfile;
  RecycleBinListBox.Items[1]:=LanguageSetup.SetupFormRecycleBinMediaViewer;
  RecycleBinListBox.Items[2]:=LanguageSetup.SetupFormRecycleBinDataViewer;
  RecycleBinListBox.Items[3]:=LanguageSetup.SetupFormRecycleBinUninstall;
  RecycleBinListBox.Items[4]:=LanguageSetup.SetupFormRecycleBinQuickStart;
  RecycleBinListBox.Items[5]:=LanguageSetup.SetupFormRecycleBinZipOperation;
  RecycleBinListBox.Items[6]:=LanguageSetup.SetupFormRecycleBinTemp;

  OfferRunAsAdminCheckBox.Caption:=LanguageSetup.SetupFormOfferRunAsAdmin;

  HelpContext:=ID_FileOptionsSecurity;
end;

procedure TSetupFrameSecurity.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameSecurity.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameSecurity.HideFrame;
begin
end;

procedure TSetupFrameSecurity.RestoreDefaults;
Var I : Integer;
begin
  AskBeforeDeleteCheckBox.Checked:=True;
  DeleteProectionCheckBox.Checked:=True;
  UseChecksumsCheckBox.Checked:=True;
  while RecycleBinListBox.Items.Count<7 do RecycleBinListBox.Items.Add('');
  For I:=0 to 4 do RecycleBinListBox.Checked[I]:=True;
  For I:=5 to 6 do RecycleBinListBox.Checked[I]:=False;
  OfferRunAsAdminCheckBox.Checked:=False;
end;

procedure TSetupFrameSecurity.SaveSetup;
Var S : String;
begin
  PrgSetup.AskBeforeDelete:=AskBeforeDeleteCheckBox.Checked;
  PrgSetup.DeleteOnlyInBaseDir:=DeleteProectionCheckBox.Checked;
  PrgSetup.UseCheckSumsForProfiles:=UseChecksumsCheckBox.Checked;

  while RecycleBinListBox.Items.Count<7 do RecycleBinListBox.Items.Add('');
  S:='1111111';
  If not RecycleBinListBox.Checked[0] then S[Integer(ftProfile)+1]:='0';
  If not RecycleBinListBox.Checked[1] then S[Integer(ftMediaViewer)+1]:='0';
  If not RecycleBinListBox.Checked[2] then S[Integer(ftDataViewer)+1]:='0';
  If not RecycleBinListBox.Checked[3] then S[Integer(ftUninstall)+1]:='0';
  If not RecycleBinListBox.Checked[4] then S[Integer(ftQuickStart)+1]:='0';
  If not RecycleBinListBox.Checked[5] then S[Integer(ftZipOperation)+1]:='0';
  If not RecycleBinListBox.Checked[6] then S[Integer(ftTemp)+1]:='0';
  PrgSetup.DeleteToRecycleBin:=S;

  PrgSetup.OfferRunAsAdmin:=OfferRunAsAdminCheckBox.Checked;
end;

end.
