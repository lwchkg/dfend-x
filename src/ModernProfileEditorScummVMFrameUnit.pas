unit ModernProfileEditorScummVMFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, Buttons, GameDBUnit, ModernProfileEditorFormUnit,
  ComCtrls, ExtCtrls;

type
  TModernProfileEditorScummVMFrame = class(TFrame, IModernProfileEditorFrame)
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    SubtitlesCheckBox: TCheckBox;
    AutosaveLabel: TLabel;
    AutosaveEdit: TSpinEdit;
    TalkSpeedEdit: TSpinEdit;
    TalkSpeedLabel: TLabel;
    SavePathGroupBox: TGroupBox;
    SavePathDefaultRadioButton: TRadioButton;
    SavePathCustomRadioButton: TRadioButton;
    SavePathEditButton: TSpeedButton;
    SavePathEdit: TEdit;
    ConfirmExitCheckBox: TCheckBox;
    CustomSetsLabel: TLabel;
    CustomSetsMemo: TRichEdit;
    CustomSetsClearButton: TBitBtn;
    CustomSetsLoadButton: TBitBtn;
    CustomSetsSaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ExtraDirCheckBox: TCheckBox;
    ExtraDirEdit: TEdit;
    ExtraDirButton: TSpeedButton;
    CustomLanguageEdit: TEdit;
    CommandLineEdit: TLabeledEdit;
    RunAsAdminCheckBox: TCheckBox;
    procedure SavePathEditButtonClick(Sender: TObject);
    procedure SavePathEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ExtraDirEditChange(Sender: TObject);
    procedure ExtraDirButtonClick(Sender: TObject);
    procedure LanguageComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    LastGameName, SaveLang : String;
    CurrentGameName, CurrentScummVMPath : PString;
    ConfOpt : TConfOpt;
    Procedure ShowFrame(Sender: TObject);
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts,
     PrgSetupUnit, PrgConsts, IconLoaderUnit, TextEditPopupUnit;

{$R *.dfm}

{ TModernProfileEditorScummVMFrame }

procedure TModernProfileEditorScummVMFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  InitData.OnShowFrame:=ShowFrame;

  LastGameName:='';

  NoFlicker(LanguageComboBox);
  NoFlicker(AutosaveEdit);
  NoFlicker(TalkSpeedEdit);
  NoFlicker(SubtitlesCheckBox);
  NoFlicker(SavePathGroupBox);
  NoFlicker(SavePathDefaultRadioButton);
  NoFlicker(SavePathCustomRadioButton);
  NoFlicker(SavePathEdit);
  NoFlicker(ExtraDirCheckBox);
  NoFlicker(ExtraDirEdit);
  NoFlicker(CommandLineEdit);
  {NoFlicker(CustomSetsMemo); - will hide text in Memo}
  NoFlicker(CustomSetsClearButton);
  NoFlicker(CustomSetsLoadButton);
  NoFlicker(CustomSetsSaveButton);

  SetRichEditPopup(CustomSetsMemo);

  LanguageLabel.Caption:=LanguageSetup.ProfileEditorScummVMLanguage;
  AutosaveLabel.Caption:=LanguageSetup.ProfileEditorScummVMAutosave;
  TalkSpeedLabel.Caption:=LanguageSetup.ProfileEditorScummVMTextSpeed;
  SubtitlesCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMSubtitles;
  ConfirmExitCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMConfirmExit;
  RunAsAdminCheckBox.Caption:=LanguageSetup.ProfileEditorRunAsAdmin;
  RunAsAdminCheckBox.Visible:=PrgSetup.OfferRunAsAdmin;
  SavePathGroupBox.Caption:=LanguageSetup.ProfileEditorScummVMSavePath;
  SavePathDefaultRadioButton.Caption:=LanguageSetup.ProfileEditorScummVMSavePathGameDir+' ('+LanguageSetup.Default+')';
  SavePathCustomRadioButton.Caption:=LanguageSetup.ProfileEditorScummVMSavePathCustom;
  SavePathEditButton.Hint:=LanguageSetup.ChooseFolder;
  ExtraDirCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMExtraPath;
  ExtraDirButton.Hint:=LanguageSetup.ChooseFolder;
  CommandLineEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorScummVMCommandLine;
  CustomSetsLabel.Caption:=LanguageSetup.ProfileEditorCustomSetsSheet;
  CustomSetsMemo.Font.Name:='Courier New';
  CustomSetsClearButton.Caption:=LanguageSetup.Del;
  CustomSetsLoadButton.Caption:=LanguageSetup.Load;
  CustomSetsSaveButton.Caption:=LanguageSetup.Save;
  UserIconLoader.DialogImage(DI_SelectFolder,SavePathEditButton);
  UserIconLoader.DialogImage(DI_SelectFolder,ExtraDirButton);
  UserIconLoader.DialogImage(DI_Clear,CustomSetsClearButton);
  UserIconLoader.DialogImage(DI_Load,CustomSetsLoadButton);
  UserIconLoader.DialogImage(DI_Save,CustomSetsSaveButton);

  CurrentGameName:=InitData.CurrentScummVMGameName;
  CurrentScummVMPath:=InitData.CurrentScummVMPath;
  ConfOpt:=InitData.GameDB.ConfOpt;

  HelpContext:=ID_ProfileEditScummVM;
end;

procedure TModernProfileEditorScummVMFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
begin
  AutosaveEdit.Value:=Min(86400,Max(1,Game.ScummVMAutosave));
  TalkSpeedEdit.Value:=Min(1000,Max(1,Game.ScummVMTalkSpeed));
  SubtitlesCheckBox.Checked:=Game.ScummVMSubtitles;
  ConfirmExitCheckBox.Checked:=Game.ScummVMConfirmExit;
  RunAsAdminCheckBox.Checked:=Game.RunAsAdmin;

  SavePathEdit.Text:=Game.ScummVMSavePath;
  SavePathEditChange(self);

  ExtraDirEdit.Text:=Game.ScummVMExtraPath;
  ExtraDirEditChange(self);

  SaveLang:=Game.ScummVMLanguage;

  CommandLineEdit.Text:=Game.ScummVMParameters;

  St:=StringToStringList(Game.CustomSettings);
  try
    CustomSetsMemo.Lines.Assign(St);
  finally
    St.Free;
  end;
end;

procedure TModernProfileEditorScummVMFrame.ShowFrame;
Var Save,S : String;
    I,J : Integer;
    St,St2 : TStringList;
begin
  If LastGameName=CurrentGameName^ then exit;
  LastGameName:=CurrentGameName^;

  If LanguageComboBox.ItemIndex>=0 then begin
    Save:=Trim(ExtUpperCase(LanguageComboBox.Text));
    If Save=Trim(ExtUpperCase(LanguageSetup.Custom)) then Save:=Trim(ExtUpperCase(CustomLanguageEdit.Text));
    If Save=Trim(ExtUpperCase(LanguageSetup.Default)) then Save:='';
  end else begin
    Save:=Trim(ExtUpperCase(SaveLang));
  end;

  LanguageComboBox.Items.BeginUpdate;
  try
    LanguageComboBox.Items.Clear;

    St:=ValueToList(ConfOpt.ScummVMLanguages,';,');
    try
      S:=Trim(ExtUpperCase(LastGameName));
      For I:=0 to St.Count-1 do begin
        J:=Pos(':',St[I]);
        If J=0 then continue;
        If Trim(ExtUpperCase(Copy(St[I],1,J-1)))=S then begin
          St2:=ValueToList(Copy(St[I],J+1,MaxInt),'-');
          try
            LanguageComboBox.Items.AddStrings(St2);
          finally
            St2.Free;
          end;
          break;
        end;
      end;
    finally
      St.Free;
    end;

    If LanguageComboBox.Items.Count=0 then LanguageComboBox.Items.Add(LanguageSetup.Default);

    LanguageComboBox.Items.Add(LanguageSetup.Custom);
  finally
    LanguageComboBox.Items.EndUpdate;
  end;

  If Save='' then LanguageComboBox.ItemIndex:=0 else begin
    I:=-1;
    For J:=0 to LanguageComboBox.Items.Count-1 do If Trim(ExtUpperCase(LanguageComboBox.Items[J]))=Save then begin I:=J; break; end;
    If I>=0 then begin
      LanguageComboBox.ItemIndex:=I;
      CustomLanguageEdit.Text:='';
    end else begin
      LanguageComboBox.ItemIndex:=LanguageComboBox.Items.Count-1;
      CustomLanguageEdit.Text:=ExtLowerCase(Save);
    end;
  end;

  LanguageComboBoxChange(self);
end;

procedure TModernProfileEditorScummVMFrame.GetGame(const Game: TGame);
begin
  If LanguageComboBox.ItemIndex>=0 then begin
    Game.ScummVMLanguage:=Trim(ExtUpperCase(LanguageComboBox.Text));
    If Game.ScummVMLanguage=Trim(ExtUpperCase(LanguageSetup.Custom)) then Game.ScummVMLanguage:=Trim(ExtUpperCase(CustomLanguageEdit.Text));
    If Game.ScummVMLanguage=Trim(ExtUpperCase(LanguageSetup.Default)) then Game.ScummVMLanguage:='';
  end else begin
    Game.ScummVMLanguage:=Trim(ExtUpperCase(SaveLang));
  end;
  Game.ScummVMLanguage:=ExtLowerCase(Game.ScummVMLanguage);

  Game.ScummVMAutosave:=AutosaveEdit.Value;
  Game.ScummVMTalkSpeed:=TalkSpeedEdit.Value;
  Game.ScummVMSubtitles:=SubtitlesCheckBox.Checked;
  Game.ScummVMConfirmExit:=ConfirmExitCheckBox.Checked;
  Game.RunAsAdmin:=RunAsAdminCheckBox.Checked;
  If SavePathDefaultRadioButton.Checked then Game.ScummVMSavePath:='' else Game.ScummVMSavePath:=Trim(SavePathEdit.Text);
  If ExtraDirCheckBox.Checked then Game.ScummVMExtraPath:=Trim(ExtraDirEdit.Text) else Game.ScummVMExtraPath:='';
  Game.ScummVMParameters:=CommandLineEdit.Text; 
  Game.CustomSettings:=StringListToString(CustomSetsMemo.Lines);
end;

procedure TModernProfileEditorScummVMFrame.LanguageComboBoxChange(Sender: TObject);
begin
  CustomLanguageEdit.Visible:=(LanguageComboBox.ItemIndex=LanguageComboBox.Items.Count-1);
end;

procedure TModernProfileEditorScummVMFrame.SavePathEditChange(Sender: TObject);
begin
  SavePathDefaultRadioButton.Checked:=(Trim(SavePathEdit.Text)='');
  SavePathCustomRadioButton.Checked:=(Trim(SavePathEdit.Text)<>'');
end;

procedure TModernProfileEditorScummVMFrame.SavePathEditButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(SavePathEdit.Text);
  If S='' then S:=Trim(CurrentScummVMPath^);
  If S='' then S:=PrgSetup.GameDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  SavePathEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
  SavePathEditChange(Sender);
end;

procedure TModernProfileEditorScummVMFrame.ExtraDirEditChange(Sender: TObject);
begin
  ExtraDirCheckBox.Checked:=(Trim(ExtraDirEdit.Text)<>'');
end;

procedure TModernProfileEditorScummVMFrame.ExtraDirButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(ExtraDirEdit.Text);
  If S='' then S:=Trim(CurrentScummVMPath^);
  If S='' then S:=PrgSetup.GameDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  ExtraDirEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
  ExtraDirEditChange(Sender);
end;

procedure TModernProfileEditorScummVMFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : CustomSetsMemo.Lines.Clear;
    1 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorCustomSetsLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not OpenDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    2 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorCustomSetsSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not SaveDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
  end;
end;

end.
