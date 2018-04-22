unit WizardBaseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, ValEdit, ExtCtrls,
  GameDBUnit;

type
  TWizardBaseFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    EmulationTypeLabel: TLabel;
    EmulationTypeComboBox: TComboBox;
    WizardModeLabel: TLabel;
    WizardModeComboBox: TComboBox;
    ListScummGamesLabel: TLabel;
    ShowInfoLabel: TLabel;
    InfoLabelInstallationSupport: TLabel;
    InfoLabelInstallationSupportLink: TLabel;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    FDialog : TForm;
    Function GetEmulationType : Integer;
    Procedure SetEmulationType(I : Integer);
  public
    { Public-Deklarationen }
    Procedure BeforeClose;
    Procedure Init(const GameDB : TGameDB; const ADialog : TForm);
    Procedure WriteDataToGame(const Game : TGame);
    property EmulationType : Integer read GetEmulationType write SetEmulationType;
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     PrgSetupUnit, ListScummVMGamesFormUnit, TextViewerFormUnit, IconLoaderUnit,
     WizardFormUnit;

{$R *.dfm}

{ TWizardBaseFrame }

procedure TWizardBaseFrame.BeforeClose;
begin
  PrgSetup.LastWizardMode:=WizardModeComboBox.ItemIndex;
end;

procedure TWizardBaseFrame.Init(const GameDB : TGameDB; const ADialog : TForm);
Var I : Integer;
begin
  SetVistaFonts(self);
  FDialog:=ADialog;

  InfoLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage1Info;
  EmulationTypeLabel.Caption:=LanguageSetup.WizardFormEmulationType;
  EmulationTypeComboBox.Items[0]:=LanguageSetup.WizardFormEmulationTypeDOSBox;
  EmulationTypeComboBox.Items[1]:=LanguageSetup.WizardFormEmulationTypeScummVM;
  EmulationTypeComboBox.Items[2]:=LanguageSetup.WizardFormEmulationTypeWindows;
  EmulationTypeComboBox.Items.Objects[0]:=TObject(-1);
  EmulationTypeComboBox.Items.Objects[1]:=TObject(-2);
  EmulationTypeComboBox.Items.Objects[2]:=TObject(-3);
  ListScummGamesLabel.Caption:=LanguageSetup.WizardFormEmulationTypeListScummVMGames;
  ShowInfoLabel.Caption:=LanguageSetup.WizardFormMainInfo;
  InfoLabelInstallationSupport.Caption:=LanguageSetup.WizardFormInstallationSupportInfo1;
  InfoLabelInstallationSupportLink.Caption:=LanguageSetup.WizardFormInstallationSupportInfo2;
  WizardModeLabel.Caption:=LanguageSetup.WizardFormWizardMode;
  WizardModeComboBox.Items[0]:=LanguageSetup.WizardFormWizardModeAlwaysAutomatically;
  WizardModeComboBox.Items[1]:=LanguageSetup.WizardFormWizardModeAutomaticallyIfAutoSetupTemplateExists;
  WizardModeComboBox.Items[2]:=LanguageSetup.WizardFormWizardModeAlwaysAllPages;

  For I:=0 to PrgSetup.WindowsBasedEmulatorsNames.Count-1 do
    EmulationTypeComboBox.Items.AddObject(Format(LanguageSetup.MenuProfileAddOtherBasedGameDialog,[PrgSetup.WindowsBasedEmulatorsNames[I]]),TObject(I));
  EmulationTypeComboBox.ItemIndex:=0;
  WizardModeComboBox.ItemIndex:=Max(0,Min(2,PrgSetup.LastWizardMode));

  If Trim(PrgSetup.ScummVMPath)='' then EmulationTypeComboBox.Items.Delete(1);
  ListScummGamesLabel.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  If not ListScummGamesLabel.Visible then begin
    ShowInfoLabel.Top:=ListScummGamesLabel.Top;
  end;

  with ListScummGamesLabel.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  ListScummGamesLabel.Cursor:=crHandPoint;
  with ShowInfoLabel.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  ShowInfoLabel.Cursor:=crHandPoint;
  with InfoLabelInstallationSupportLink.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  InfoLabelInstallationSupportLink.Cursor:=crHandPoint;
end;

Function TWizardBaseFrame.GetEmulationType : Integer;
begin
  If EmulationTypeComboBox.ItemIndex<0 then result:=-1 else result:=Integer(EmulationTypeComboBox.Items.Objects[EmulationTypeComboBox.ItemIndex]);
end;

Procedure TWizardBaseFrame.SetEmulationType(I : Integer);
Var J : Integer;
begin
  For J:=0 to EmulationTypeComboBox.Items.Count-1 do If Integer(EmulationTypeComboBox.Items.Objects[J])=I then begin
    EmulationTypeComboBox.ItemIndex:=J; break;
  end;
end;

procedure TWizardBaseFrame.WriteDataToGame(const Game: TGame);
Var S : String;
    I : Integer;
begin
  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(Game.Name)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    Inc(I);
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(Game.Name)+IntToStr(I)+'\';
  end;
  Game.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
  CreateDir(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));
end;

procedure TWizardBaseFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : ShowListScummVMGamesDialog(self);
    1 : ShowTextViewerDialog(
          self,
          LanguageSetup.WizardFormMainInfo,
          LanguageSetup.WizardFormMainInfo1+#13+#13+LanguageSetup.WizardFormMainInfo2+#13+#13+LanguageSetup.WizardFormMainInfo3
        );
    2 : begin
          TWizardForm(FDialog).OpenInstallationSupportDialog:=True;
          PostMessage(FDialog.Handle,WM_CLOSE,0,0);
        end;
  end;
end;

end.
