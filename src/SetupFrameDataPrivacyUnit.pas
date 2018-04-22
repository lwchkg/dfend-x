unit SetupFrameDataPrivacyUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameDataPrivacy = class(TFrame, ISetupFrame)
    StoreHistoryCheckBox: TCheckBox;
    ShowHistoryButton: TBitBtn;
    DeleteHistoryButton: TBitBtn;
    OpenFileLabel: TLabel;
    InfoLabel: TLabel;
    procedure ShowHistoryButtonClick(Sender: TObject);
    procedure DeleteHistoryButtonClick(Sender: TObject);
    procedure OpenFileLabelClick(Sender: TObject);
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts,
     IconLoaderUnit, HistoryFormUnit, GameDBToolsUnit, CommonTools, PrgConsts,
     HistoryUnit;

{$R *.dfm}

{ TSetupFrameDataPrivacy }

function TSetupFrameDataPrivacy.GetName: String;
begin
  result:=LanguageSetup.SetupFormDataPrivacy;
end;

procedure TSetupFrameDataPrivacy.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  UserIconLoader.DirectLoad('Main',26,ShowHistoryButton);
  UserIconLoader.DialogImage(DI_Delete,DeleteHistoryButton);

  with OpenFileLabel.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  OpenFileLabel.Cursor:=crHandPoint;

  StoreHistoryCheckBox.Checked:=PrgSetup.StoreHistory;
end;

procedure TSetupFrameDataPrivacy.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDataPrivacy.LoadLanguage;
begin
  NoFlicker(StoreHistoryCheckBox);

  StoreHistoryCheckBox.Caption:=LanguageSetup.SetupFormDataPrivacyStoreHistory;
  ShowHistoryButton.Caption:=LanguageSetup.SetupFormDataPrivacyShowHistory;
  DeleteHistoryButton.Caption:=LanguageSetup.SetupFormDataPrivacyDeleteHistory;
  OpenFileLabel.Caption:=LanguageSetup.SetupFormDataPrivacyOpenHistoryFile;
  InfoLabel.Caption:=LanguageSetup.SetupFormDataPrivacyInfo;

  HelpContext:=ID_FileOptionsDataPrivacy;
end;

procedure TSetupFrameDataPrivacy.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDataPrivacy.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameDataPrivacy.HideFrame;
begin
end;

procedure TSetupFrameDataPrivacy.RestoreDefaults;
begin
  StoreHistoryCheckBox.Checked:=True;
end;

procedure TSetupFrameDataPrivacy.SaveSetup;
begin
  PrgSetup.StoreHistory:=StoreHistoryCheckBox.Checked;
end;

procedure TSetupFrameDataPrivacy.ShowHistoryButtonClick(Sender: TObject);
begin
  ShowHistoryDialog(self);
end;

procedure TSetupFrameDataPrivacy.DeleteHistoryButtonClick(Sender: TObject);
begin
  If History.Clear then MessageDlg(LanguageSetup.SetupFormDataPrivacyDeleteHistoryDone,mtInformation,[mbOK],0);
end;

procedure TSetupFrameDataPrivacy.OpenFileLabelClick(Sender: TObject);
begin
  OpenFileInEditor(PrgDataDir+SettingsFolder+'\'+HistoryFileName);
end;

end.
