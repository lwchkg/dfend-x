unit SetupFrameDOSBoxUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Buttons, SetupFormUnit, PrgSetupUnit, GameDBUnit;

type
  TSetupFrameDOSBox = class(TFrame, ISetupFrame)
    DosBoxButton: TSpeedButton;
    FindDosBoxButton: TSpeedButton;
    DosBoxDirEdit: TLabeledEdit;
    DosBoxTxtOpenDialog: TOpenDialog;
    DOSBoxDownloadURLInfo: TLabel;
    DOSBoxDownloadURL: TLabel;
    DOSBoxInstallationLabel: TLabel;
    DOSBoxInstallationComboBox: TComboBox;
    DOSBoxAddButton: TSpeedButton;
    DOSBoxDeleteButton: TSpeedButton;
    DOSBoxDownButton: TSpeedButton;
    DOSBoxUpButton: TSpeedButton;
    MoreSettingsButton: TBitBtn;
    DOSBoxEditButton: TSpeedButton;
    PortableModeInfoButton: TBitBtn;
    WarningButton: TSpeedButton;
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure DOSBoxDownloadURLClick(Sender: TObject);
    procedure DOSBoxInstallationComboBoxChange(Sender: TObject);
    procedure PortableModeInfoButtonClick(Sender: TObject);
    procedure WarningButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DOSBoxData : Array of TDOSBoxData;
    PDosBoxDir, PDOSBoxLang : PString;
    DosBoxDirChange : TSimpleEvent;
    LastIndex : Integer;
    GameDB : TGameDB;
    OrigPortableModeInfoButtonTop : Integer;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
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

uses ShellAPI, ShlObj, Math, LanguageSetupUnit, VistaToolsUnit, CommonTools,
     SetupDosBoxFormUnit, SetupFrameDOSBoxFormUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameDOSBox }

constructor TSetupFrameDOSBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OrigPortableModeInfoButtonTop:=-1;
end;

function TSetupFrameDOSBox.GetName: String;
begin
  result:=LanguageSetup.SetupFormDosBoxSheet;
end;

procedure TSetupFrameDOSBox.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
begin
  PDosBoxDir:=InitData.PDosBoxDir;
  PDOSBoxLang:=InitData.PDOSBoxLang;
  DosBoxDirChange:=InitData.DosBoxDirChangeNotify;
  GameDB:=InitData.GameDB;

  NoFlicker(DOSBoxInstallationComboBox);
  NoFlicker(DosBoxDirEdit);
  NoFlicker(MoreSettingsButton);

  SetLength(DOSBoxData,PrgSetup.DOSBoxSettingsCount);
  For I:=0 to length(DOSBoxData)-1 do begin
    DOSBoxSettingToDOSBoxData(PrgSetup.DOSBoxSettings[I],DOSBoxData[I]);
    If I=0
      then DOSBoxInstallationComboBox.Items.Add(LanguageSetup.Default)
      else DOSBoxInstallationComboBox.Items.Add(DOSBoxData[I].Name);
  end;

  LastIndex:=-1;
  DOSBoxInstallationComboBox.ItemIndex:=0;
  DOSBoxInstallationComboBoxChange(self);

  UserIconLoader.DialogImage(DI_Edit,DOSBoxEditButton);
  UserIconLoader.DialogImage(DI_Add,DOSBoxAddButton);
  UserIconLoader.DialogImage(DI_Delete,DOSBoxDeleteButton);
  UserIconLoader.DialogImage(DI_Up,DOSBoxUpButton);
  UserIconLoader.DialogImage(DI_Down,DOSBoxDownButton);
  UserIconLoader.DialogImage(DI_SelectFolder,DosBoxButton);
  UserIconLoader.DialogImage(DI_FindFile,FindDosBoxButton);

  HelpContext:=ID_FileOptionsDOSBox;
end;

procedure TSetupFrameDOSBox.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDOSBox.LoadLanguage;
begin
  DOSBoxInstallationLabel.Caption:=LanguageSetup.SetupFormDOSBoxInstallation;
  DOSBoxEditButton.Hint:=LanguageSetup.SetupFormDOSBoxInstallationEdit;
  DOSBoxAddButton.Hint:=LanguageSetup.SetupFormDOSBoxInstallationAdd;
  DOSBoxDeleteButton.Hint:=LanguageSetup.SetupFormDOSBoxInstallationDelete;
  DOSBoxUpButton.Hint:=LanguageSetup.SetupFormDOSBoxInstallationUp;
  DOSBoxDownButton.Hint:=LanguageSetup.SetupFormDOSBoxInstallationDown;
  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  WarningButton.Hint:=LanguageSetup.MsgDlgWarning;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;
  FindDosBoxButton.Hint:=LanguageSetup.SetupFormSearchDosBox;
  MoreSettingsButton.Caption:=LanguageSetup.SetupFormDOSBoxInstallationMoreSettings;
  PortableModeInfoButton.Caption:=LanguageSetup.SetupFormDOSBoxPortableModeInfo;

  DOSBoxDownloadURLInfo.Caption:=LanguageSetup.SetupFormDOSBoxDownloadURL;
  DOSBoxDownloadURL.Caption:='http:/'+'/www.dosbox.com/download.php?main=1';
  with DOSBoxDownloadURL.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  DOSBoxDownloadURL.Cursor:=crHandPoint;
end;

procedure TSetupFrameDOSBox.PortableModeInfoButtonClick(Sender: TObject);
begin
  MessageDlg(LanguageSetup.FirstRunWizardInfoDOSBox3,mtInformation,[mbOK],0);
end;

procedure TSetupFrameDOSBox.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDOSBox.ShowFrame(const AdvancedMode: Boolean);
begin
  MoreSettingsButton.Visible:=AdvancedMode;
  PortableModeInfoButton.Visible:=(OperationMode=omPortable);

  if OrigPortableModeInfoButtonTop<0
    then OrigPortableModeInfoButtonTop:=PortableModeInfoButton.Top
    else PortableModeInfoButton.Top:=OrigPortableModeInfoButtonTop;

  If AdvancedMode then begin
    If PortableModeInfoButton.Visible
      then DOSBoxDownloadURLInfo.Top:=PortableModeInfoButton.Top+PortableModeInfoButton.Height+10
      else DOSBoxDownloadURLInfo.Top:=MoreSettingsButton.Top+MoreSettingsButton.Height+10;
  end else begin
    PortableModeInfoButton.Top:=MoreSettingsButton.Top;
    If PortableModeInfoButton.Visible
      then DOSBoxDownloadURLInfo.Top:=PortableModeInfoButton.Top+PortableModeInfoButton.Height+10
      else DOSBoxDownloadURLInfo.Top:=DosBoxDirEdit.Top+DosBoxDirEdit.Height+15;
  end;
  DOSBoxDownloadURL.Top:=DOSBoxDownloadURLInfo.Top+19;

  DosBoxDirEditChange(self);
end;

procedure TSetupFrameDOSBox.HideFrame;
begin
end;

procedure TSetupFrameDOSBox.RestoreDefaults;
begin
end;

procedure TSetupFrameDOSBox.SaveSetup;
Var I : Integer;
begin
  DOSBoxInstallationComboBox.ItemIndex:=-1;
  DOSBoxInstallationComboBoxChange(self);
  While PrgSetup.DOSBoxSettingsCount>length(DOSBoxData) do PrgSetup.DeleteDOSBoxSettings(PrgSetup.DOSBoxSettingsCount-1);
  While PrgSetup.DOSBoxSettingsCount<length(DOSBoxData) do PrgSetup.AddDOSBoxSettings('');
  DOSBoxData[0].DosBoxLanguage:=PDOSBoxLang^;
  For I:=0 to length(DOSBoxData)-1 do DOSBoxDataToDOSBoxSetting(DOSBoxData[I],PrgSetup.DOSBoxSettings[I]);
  For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do PrgSetup.DOSBoxSettings[I].Nr:=I;
end;

procedure TSetupFrameDOSBox.DOSBoxInstallationComboBoxChange(Sender: TObject);
begin
  If LastIndex>=0 then begin
    DOSBoxData[LastIndex].DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxDirEdit.Text);
  end;

  LastIndex:=DOSBoxInstallationComboBox.ItemIndex;

  If LastIndex>=0 then begin
    DosBoxDirEdit.Text:=DOSBoxData[LastIndex].DosBoxDir;
  end else begin
    DosBoxDirEdit.Text:='';
  end;
  DosBoxDirEditChange(self);

  DOSBoxEditButton.Enabled:=(LastIndex>=1);
  DOSBoxDeleteButton.Enabled:=(LastIndex>=1);
  DOSBoxUpButton.Enabled:=(LastIndex>=2);
  DOSBoxDownButton.Enabled:=(LastIndex>=1) and (LastIndex<length(DOSBoxData)-1);
end;

procedure TSetupFrameDOSBox.DosBoxDirEditChange(Sender: TObject);
begin
  If (PDosBoxDir^<>DosBoxDirEdit.Text) and (DOSBoxInstallationComboBox.ItemIndex=0) then begin
    PDosBoxDir^:=DosBoxDirEdit.Text;
    DosBoxDirChange;
  end;

  WarningButton.Visible:=OldDOSBoxVersion(CheckDOSBoxVersion(-1,DosBoxDirEdit.Text));
  DosBoxDirEdit.Width:=IfThen(WarningButton.Visible,WarningButton.Left-4,WarningButton.Left+WarningButton.Width)-DosBoxDirEdit.Left;
end;

procedure TSetupFrameDOSBox.ButtonWork(Sender: TObject);
Var S : String;
    I,J : Integer;
    D : TDOSBoxData;
begin
  Case (Sender as TComponent).Tag of
    0 : If DOSBoxInstallationComboBox.ItemIndex>=1 then begin
          S:=DOSBoxData[DOSBoxInstallationComboBox.ItemIndex].Name;
          If not InputQuery(LanguageSetup.SetupFormDOSBoxInstallationEditCaption,LanguageSetup.SetupFormDOSBoxInstallationEditInfo,S) then exit;
          I:=DOSBoxInstallationComboBox.ItemIndex;
          DOSBoxData[DOSBoxInstallationComboBox.ItemIndex].Name:=S;
          DOSBoxInstallationComboBox.Items[DOSBoxInstallationComboBox.ItemIndex]:=S;
          DOSBoxInstallationComboBox.ItemIndex:=I;
        end;
    1 : begin
          S:='';
          If not InputQuery(LanguageSetup.SetupFormDOSBoxInstallationAddCaption,LanguageSetup.SetupFormDOSBoxInstallationEditInfo,S) then exit;
          I:=length(DOSBoxData);
          SetLength(DOSBoxData,I+1);
          InitDOSBoxData(DOSBoxData[I]);
          DOSBoxData[I].Name:=S;
          DOSBoxInstallationComboBox.Items.Add(S);
          DOSBoxInstallationComboBox.ItemIndex:=I;
          DOSBoxInstallationComboBoxChange(self);
        end;
    2 : If DOSBoxInstallationComboBox.ItemIndex>=1 then begin
          I:=DOSBoxInstallationComboBox.ItemIndex;
          If MessageDlg(Format(LanguageSetup.SetupFormDOSBoxInstallationDeleteConfirm,[DOSBoxData[I].Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          DOSBoxInstallationComboBox.ItemIndex:=I-1;
          DOSBoxInstallationComboBoxChange(Sender);
          DOSBoxInstallationComboBox.Items.Delete(I);
          For J:=I+1 to length(DOSBoxData)-1 do DOSBoxData[J-1]:=DOSBoxData[J];
          SetLength(DOSBoxData,length(DOSBoxData)-1);
          DOSBoxInstallationComboBoxChange(Sender);
        end;
    3 : If DOSBoxInstallationComboBox.ItemIndex>=2 then begin
          I:=DOSBoxInstallationComboBox.ItemIndex;
          DOSBoxInstallationComboBox.Items.Exchange(I,I-1);
          D:=DOSBoxData[I]; DOSBoxData[I]:=DOSBoxData[I-1]; DOSBoxData[I-1]:=D;
          LastIndex:=I-1;
          DOSBoxInstallationComboBox.ItemIndex:=I-1;
          DOSBoxInstallationComboBoxChange(Sender);
        end;
    4 : If (DOSBoxInstallationComboBox.ItemIndex>=0) and (DOSBoxInstallationComboBox.ItemIndex<length(DOSBoxData)-1) then begin
          I:=DOSBoxInstallationComboBox.ItemIndex;
          DOSBoxInstallationComboBox.Items.Exchange(I,I+1);
          D:=DOSBoxData[I]; DOSBoxData[I]:=DOSBoxData[I+1]; DOSBoxData[I+1]:=D;
          LastIndex:=I+1;
          DOSBoxInstallationComboBox.ItemIndex:=I+1;
          DOSBoxInstallationComboBoxChange(Sender);
        end;
    5 : If DOSBoxInstallationComboBox.ItemIndex>=0 then begin
          S:=DosBoxDirEdit.Text;
          If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
          if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then begin
            DosBoxDirEdit.Text:=S;
            DosBoxDirEditChange(Sender);
          end;
        end;
    6 : If DOSBoxInstallationComboBox.ItemIndex>=0 then begin
          if SearchDosBox(self,S) then begin
            DosBoxDirEdit.Text:=S;
            DosBoxDirEditChange(Sender);
          end;
        end;
    7 : If DOSBoxInstallationComboBox.ItemIndex>=0 then begin
          If DOSBoxInstallationComboBox.ItemIndex=0 then DOSBoxData[0].DosBoxLanguage:=PDOSBoxLang^;
          DOSBoxData[DOSBoxInstallationComboBox.ItemIndex].DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxDirEdit.Text);
          ShowSetupFrameDOSBoxDialog(self,DOSBoxData[DOSBoxInstallationComboBox.ItemIndex],DOSBoxInstallationComboBox.ItemIndex=0,GameDB);
          DosBoxDirEdit.Text:=DOSBoxData[DOSBoxInstallationComboBox.ItemIndex].DosBoxDir;
          If DOSBoxInstallationComboBox.ItemIndex=0 then PDOSBoxLang^:=DOSBoxData[0].DosBoxLanguage;
        end;
  end;
end;

procedure TSetupFrameDOSBox.DOSBoxDownloadURLClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

procedure TSetupFrameDOSBox.WarningButtonClick(Sender: TObject);
begin
  DOSBoxOutdatedWarning(DosBoxDirEdit.Text);
end;

end.
