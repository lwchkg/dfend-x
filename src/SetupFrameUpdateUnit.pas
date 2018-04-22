unit SetupFrameUpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, SetupFormUnit, PackageDBUnit, GameDBUnit,
  LinkFileUnit;

type
  TSetupFrameUpdate = class(TFrame, ISetupFrame)
    UpdateCheckBox: TCheckBox;
    DataReaderInfoLabel: TLabel;
    DataReaderComboBox: TComboBox;
    PackagesLabel: TLabel;
    PackagesComboBox: TComboBox;
    UpdateButton: TBitBtn;
    CheatsLabel: TLabel;
    CheatsComboBox: TComboBox;
    ProgramUpdateInfoLabel: TLabel;
    ProgramUpdateComboBox: TComboBox;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    GameDB : TGameDB;
    SearchLinkFile : TLinkFile;
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

uses ShellAPI, Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, PrgConsts,
     HelpConsts, IconLoaderUnit, InternetDataWaitFormUnit, DataReaderMobyUnit,
     CommonTools, MainUnit, DownloadWaitFormUnit, ProgramUpdateCheckUnit,
     CheatDBToolsUnit, UpdateCheckFormUnit;

{$R *.dfm}

{ TSetupFrameUpdate }

function TSetupFrameUpdate.GetName: String;
begin
  result:=LanguageSetup.MenuHelpUpdates;
  While (result<>'') and (result[length(result)]='.') do SetLength(result,length(result)-1);
end;

procedure TSetupFrameUpdate.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  UpdateCheckBox.Checked:=PrgSetup.VersionSpecificUpdateCheck;

  UserIconLoader.DialogImage(DI_Update,UpdateButton);

  ProgramUpdateComboBox.Items.Clear;
  While ProgramUpdateComboBox.Items.Count<4 do ProgramUpdateComboBox.Items.Add('');

  DataReaderComboBox.Items.Clear;
  While DataReaderComboBox.Items.Count<4 do DataReaderComboBox.Items.Add('');

  PackagesComboBox.Items.Clear;
  While PackagesComboBox.Items.Count<4 do PackagesComboBox.Items.Add('');

  CheatsComboBox.Items.Clear;
  While CheatsComboBox.Items.Count<3 do CheatsComboBox.Items.Add('');

  ProgramUpdateComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.CheckForUpdates));
  DataReaderComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.DataReaderCheckForUpdates));
  PackagesComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.PackageListsCheckForUpdates));
  CheatsComboBox.ItemIndex:=Max(0,Min(2,PrgSetup.CheatsDBCheckForUpdates));

  GameDB:=InitData.GameDB;
  SearchLinkFile:=InitData.SearchLinkFile;
end;

procedure TSetupFrameUpdate.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameUpdate.LoadLanguage;
Var I : Integer;
begin
  UpdateCheckBox.Caption:=LanguageSetup.SetupFormUpdateVersionSpecific;
  UpdateButton.Caption:=LanguageSetup.SetupFormUpdateButton;

  TForm(Owner).Canvas.Font:=UpdateButton.Font;
  UpdateButton.Width:=Max(169,40+TForm(Owner).Canvas.TextWidth(LanguageSetup.SetupFormUpdateButton));

  ProgramUpdateInfoLabel.Caption:=LanguageSetup.SetupFormUpdateProgram;
  I:=ProgramUpdateComboBox.ItemIndex;
  try
    ProgramUpdateComboBox.Items[0]:=LanguageSetup.SetupFormUpdate0;
    ProgramUpdateComboBox.Items[1]:=LanguageSetup.SetupFormUpdate1;
    ProgramUpdateComboBox.Items[2]:=LanguageSetup.SetupFormUpdate2;
    ProgramUpdateComboBox.Items[3]:=LanguageSetup.SetupFormUpdate3;
  finally
    ProgramUpdateComboBox.ItemIndex:=I;
  end;

  DataReaderInfoLabel.Caption:=LanguageSetup.SetupFormUpdateDataReader;
  I:=DataReaderComboBox.ItemIndex;
  try
    DataReaderComboBox.Items[0]:=LanguageSetup.SetupFormUpdateDataReader0;
    DataReaderComboBox.Items[1]:=LanguageSetup.SetupFormUpdateDataReader1;
    DataReaderComboBox.Items[2]:=LanguageSetup.SetupFormUpdateDataReader2;
    DataReaderComboBox.Items[3]:=LanguageSetup.SetupFormUpdateDataReader3;
  finally
    DataReaderComboBox.ItemIndex:=I;
  end;

  PackagesLabel.Caption:=LanguageSetup.SetupFormUpdatePackages;
  I:=PackagesComboBox.ItemIndex;
  try
    PackagesComboBox.Items[0]:=LanguageSetup.SetupFormUpdatePackages0;
    PackagesComboBox.Items[1]:=LanguageSetup.SetupFormUpdatePackages1;
    PackagesComboBox.Items[2]:=LanguageSetup.SetupFormUpdatePackages2;
    PackagesComboBox.Items[3]:=LanguageSetup.SetupFormUpdatePackages3;
  finally
    PackagesComboBox.ItemIndex:=I;
  end;

  CheatsLabel.Caption:=LanguageSetup.SetupFormUpdateCheats;
  I:=CheatsComboBox.ItemIndex;
  try
    CheatsComboBox.Items[0]:=LanguageSetup.SetupFormUpdateCheats0;
    CheatsComboBox.Items[1]:=LanguageSetup.SetupFormUpdateCheats1;
    CheatsComboBox.Items[2]:=LanguageSetup.SetupFormUpdateCheats2;
  finally
    CheatsComboBox.ItemIndex:=I;
  end;

  HelpContext:=ID_FileOptionsSearchForUpdates;
end;

procedure TSetupFrameUpdate.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameUpdate.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameUpdate.HideFrame;
begin
end;

procedure TSetupFrameUpdate.RestoreDefaults;
begin
  UpdateCheckBox.Checked:=True;

  ProgramUpdateComboBox.ItemIndex:=0;
  DataReaderComboBox.ItemIndex:=2;
  PackagesComboBox.ItemIndex:=0;
  CheatsComboBox.ItemIndex:=0;
end;

procedure TSetupFrameUpdate.SaveSetup;
begin
  PrgSetup.VersionSpecificUpdateCheck:=UpdateCheckBox.Checked;

  PrgSetup.CheckForUpdates:=ProgramUpdateComboBox.ItemIndex;
  PrgSetup.DataReaderCheckForUpdates:=DataReaderComboBox.ItemIndex;
  PrgSetup.PackageListsCheckForUpdates:=PackagesComboBox.ItemIndex;
  PrgSetup.CheatsDBCheckForUpdates:=CheatsComboBox.ItemIndex;
end;

procedure TSetupFrameUpdate.ButtonWork(Sender: TObject);
begin
  ShowUpdateCheckDialog(self,GameDB,SearchLinkFile,True);
end;

end.
