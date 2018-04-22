unit WizardScummVMSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, GameDBUnit, Buttons;

type
  TWizardScummVMSettingsFrame = class(TFrame)
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    InfoLabel: TLabel;
    Bevel: TBevel;
    LanguageInfoLabel: TLabel;
    SavePathGroupBox: TGroupBox;
    SavePathEditButton: TSpeedButton;
    SavePathDefaultRadioButton: TRadioButton;
    SavePathCustomRadioButton: TRadioButton;
    SavePathEdit: TEdit;
    CustomLanguageEdit: TEdit;
    procedure SavePathEditChange(Sender: TObject);
    procedure SavePathEditButtonClick(Sender: TObject);
    procedure LanguageComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    FGameDB : TGameDB;
    ScummVMPath : String;
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure SetScummVMGameName(const Name, Path : String);
    Function CreateGame(const GameName : String) : TGame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     IconLoaderUnit;

{$R *.dfm}

{ TWizardScummVMSettingsFrame }

procedure TWizardScummVMSettingsFrame.Init(const GameDB: TGameDB);
begin
  SetVistaFonts(self);
  FGameDB:=GameDB;

  InfoLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage6Info;
  LanguageLabel.Caption:=LanguageSetup.ProfileEditorScummVMLanguage;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  SavePathGroupBox.Caption:=LanguageSetup.ProfileEditorScummVMSavePath;
  SavePathDefaultRadioButton.Caption:=LanguageSetup.ProfileEditorScummVMSavePathGameDir+' ('+LanguageSetup.Default+')';
  SavePathCustomRadioButton.Caption:=LanguageSetup.ProfileEditorScummVMSavePathCustom;
  LanguageInfoLabel.Caption:=LanguageSetup.WizardFormScummVMLanguageInfo;

  UserIconLoader.DialogImage(DI_SelectFolder,SavePathEditButton);
end;

procedure TWizardScummVMSettingsFrame.LanguageComboBoxChange(Sender: TObject);
begin
  CustomLanguageEdit.Visible:=(LanguageComboBox.ItemIndex=LanguageComboBox.Items.Count-1);
end;

procedure TWizardScummVMSettingsFrame.SetScummVMGameName(const Name, Path : String);
Var S : String;
    I,J : Integer;
    St,St2 : TStringList;
begin
  LanguageComboBox.Items.BeginUpdate;
  try
    LanguageComboBox.Items.Clear;

    St:=ValueToList(FGameDB.ConfOpt.ScummVMLanguages,';,');
    try
      S:=Trim(ExtUpperCase(Name));
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

  LanguageComboBox.ItemIndex:=0;
  LanguageComboBoxChange(self);

  ScummVMPath:=Path;
end;

function TWizardScummVMSettingsFrame.CreateGame(const GameName: String): TGame;
begin
  result:=FGameDB[FGameDB.Add(GameName)];
  result.ProfileMode:='ScummVM';
  result.Name:=GameName;

  If LanguageComboBox.ItemIndex>=0 then begin
    result.ScummVMLanguage:=Trim(ExtUpperCase(LanguageComboBox.Text));
    If result.ScummVMLanguage=Trim(ExtUpperCase(LanguageSetup.Custom)) then result.ScummVMLanguage:=Trim(ExtUpperCase(CustomLanguageEdit.Text));
    If result.ScummVMLanguage=Trim(ExtUpperCase(LanguageSetup.Default)) then result.ScummVMLanguage:='';
  end else begin
    result.ScummVMLanguage:='';
  end;
  result.ScummVMLanguage:=ExtLowerCase(result.ScummVMLanguage);

  result.StartFullscreen:=StartFullscreenCheckBox.Checked;

  If SavePathDefaultRadioButton.Checked then result.ScummVMSavePath:='' else result.ScummVMSavePath:=Trim(SavePathEdit.Text);
end;

procedure TWizardScummVMSettingsFrame.SavePathEditChange(Sender: TObject);
begin
  SavePathDefaultRadioButton.Checked:=(Trim(SavePathEdit.Text)='');
  SavePathCustomRadioButton.Checked:=(Trim(SavePathEdit.Text)<>'');
end;

procedure TWizardScummVMSettingsFrame.SavePathEditButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(SavePathEdit.Text);
  If S='' then S:=Trim(ScummVMPath);
  If S='' then S:=PrgSetup.GameDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  SavePathEdit.Text:=S;
  SavePathEditChange(Sender);
end;

end.
