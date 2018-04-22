unit WizardFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, ValEdit, ExtCtrls, GameDBUnit,
  WizardBaseUnit, WizardPrgFileUnit, WizardTemplateUnit, WizardGameInfoUnit,
  WizardFinishUnit, WizardScummVMUnit, WizardScummVMSettingsUnit, LinkFileUnit;

type
  TWizardForm = class(TForm)
    BottomPanel: TPanel;
    PreviousButton: TBitBtn;
    NextButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StepButtonWork(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    ActivePage : Integer;
    WizardBaseFrame : TWizardBaseFrame;
    WizardPrgFileFrame : TWizardPrgFileFrame;
    WizardTemplateFrame : TWizardTemplateFrame;
    WizardGameInfoFrame : TWizardGameInfoFrame;
    WizardFinishFrame : TWizardFinishFrame;
    WizardScummVMFrame : TWizardScummVMFrame;
    WizardScummVMSettingsFrame : TWizardScummVMSettingsFrame;
    InsecureTemplate : Boolean;
    ScummVM, WindowsMode : Boolean;
    WizardMode : Integer;
    DoOKButtonClick : Boolean;
    TemplateDB, AutoSetupDB : TGameDB;
    Procedure SetActivePage(NewPage : Integer);
    Function CalcProfileName : String;
    Function CalcProfileNameFromFile : String;
    Function DoubleProfileCheck(const GameFileName : String) : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
    ExeFile : String;
    WindowsExe : Boolean;
    OpenEditorNow : Boolean;
    LinkFile : TLinkFile;
    OpenInstallationSupportDialog : Boolean;
  end;

var
  WizardForm: TWizardForm;

Function ShowWizardDialog(const AOwner : TComponent; const AGameDB : TGameDB; const AExeFile : String; const AWindowsExe : Boolean; var AGame : TGame; var OpenEditorNow, OpenInstallationSupport : Boolean; const ASearchLinkFile : TLinkFile) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     GameDBToolsUnit, DOSBoxUnit, HelpConsts, IconLoaderUnit, PrgConsts;

{$R *.dfm}

function TWizardForm.CalcProfileName: String;
begin
  If ScummVM then begin
    result:=WizardScummVMFrame.GameNameComboBox.Text;
    exit;
  end;

  If WindowsMode then begin
    result:=CalcProfileNameFromFile;
    exit;
  end;

  If WizardTemplateFrame.TemplateType1.Checked then begin result:=WizardTemplateFrame.TemplateType1List.Text; exit; end;
  If WizardTemplateFrame.TemplateType2.Checked then begin result:=WizardTemplateFrame.TemplateType2List.Text; exit; end;
  If WizardTemplateFrame.TemplateType3.Checked then begin result:=WizardTemplateFrame.TemplateType3List.Text; exit; end;
  result:=CalcProfileNameFromFile;
end;

function TWizardForm.CalcProfileNameFromFile: String;
Var S : String;
    I : Integer;
begin
  S:=Trim(WizardPrgFileFrame.ProgramEdit.Text);
  If S='' then S:=Trim(WizardPrgFileFrame.SetupEdit.Text);

  If S='' then begin result:='Game'; exit; end;

  S:=ChangeFileExt(ExtractFileName(S),'');
  For I:=1 to length(S) do If S[I]<>' ' then begin
    If I=1
      then S[I]:=ExtUpperCase(S[I])[1]
     else S[I]:=ExtLowerCase(S[I])[1];
  end;
  result:=S;
end;

procedure TWizardForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WizardBaseFrame.BeforeClose;
end;

procedure TWizardForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);

  Caption:=LanguageSetup.WizardForm;
  PreviousButton.Caption:=LanguageSetup.WizardFormButtonPrevious;
  NextButton.Caption:=LanguageSetup.WizardFormButtonNext;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_Previous,PreviousButton);
  UserIconLoader.DialogImage(DI_Next,NextButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  DoOKButtonClick:=False;
  ActivePage:=0;
  InsecureTemplate:=False;
  OpenEditorNow:=False;
  OpenInstallationSupportDialog:=False;
end;

procedure TWizardForm.FormShow(Sender: TObject);
begin
  WizardBaseFrame:=TWizardBaseFrame.Create(self); WizardBaseFrame.Parent:=self;
  with WizardBaseFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB,self); end;

  WizardPrgFileFrame:=TWizardPrgFileFrame.Create(self); WizardPrgFileFrame.Parent:=self;
  with WizardPrgFileFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardTemplateFrame:=TWizardTemplateFrame.Create(self); WizardTemplateFrame.Parent:=self;
  with WizardTemplateFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB,TemplateDB,AutoSetupDB); end;

  WizardGameInfoFrame:=TWizardGameInfoFrame.Create(self); WizardGameInfoFrame.Parent:=self;
  with WizardGameInfoFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB,LinkFile); end;

  WizardFinishFrame:=TWizardFinishFrame.Create(self); WizardFinishFrame.Parent:=self;
  with WizardFinishFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardScummVMFrame:=TWizardScummVMFrame.Create(self); WizardScummVMFrame.Parent:=self;
  with WizardScummVMFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardScummVMSettingsFrame:=TWizardScummVMSettingsFrame.Create(self); WizardScummVMSettingsFrame.Parent:=self;
  with WizardScummVMSettingsFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardBaseFrame.TabOrder:=0;
  WizardPrgFileFrame.TabOrder:=1;
  WizardTemplateFrame.TabOrder:=2;
  WizardGameInfoFrame.TabOrder:=3;
  WizardFinishFrame.TabOrder:=4;
  WizardScummVMFrame.TabOrder:=5;
  WizardScummVMSettingsFrame.TabOrder:=6;
  BottomPanel.TabOrder:=7;

  If Trim(ExeFile)<>'' then begin
    WizardPrgFileFrame.ProgramEdit.Text:=MakeRelPath(ExeFile,PrgSetup.BaseDir);
    If WindowsExe then WizardBaseFrame.EmulationType:=-3;
    WizardBaseFrame.EmulationTypeComboBox.Enabled:=False;
    WizardBaseFrame.ListScummGamesLabel.Visible:=False;
  end else begin
    WizardBaseFrame.EmulationTypeComboBox.ItemIndex:=0;
  end;

  SetActivePage(0);
end;

procedure TWizardForm.FormHide(Sender: TObject);
begin
  WizardTemplateFrame.Done;
  WizardFinishFrame.Done;
end;

procedure TWizardForm.SetActivePage(NewPage: Integer);
Var S : String;
begin
  Case ActivePage of
    0 : begin
          {Start page}
          ScummVM:=(WizardBaseFrame.EmulationType=-2);
          WindowsMode:=(WizardBaseFrame.EmulationType=-3) or (WizardBaseFrame.EmulationType>=0);
          If ScummVM then WizardScummVMFrame.ShowScummVMFrame;
          WizardMode:=WizardBaseFrame.WizardModeComboBox.ItemIndex;
        end;
    1 : If NewPage=2 then begin
          {Progam file page -> next page (template or ScummVM settings)}
          If not ScummVM then begin
            If Trim(WizardPrgFileFrame.ProgramEdit.Text)='' then begin
              If MessageDlg(LanguageSetup.MessageNoGameFileNameWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
            end;
            If WindowsMode then begin
              If WizardBaseFrame.EmulationType<0 then begin
                If Trim(WizardPrgFileFrame.ProgramEdit.Text)<>'' then begin
                  S:=MakeAbsPath(WizardPrgFileFrame.ProgramEdit.Text,PrgSetup.BaseDir);
                  If IsDOSExe(S) then begin
                    If MessageDlg(Format(LanguageSetup.MessageDOSExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                  end;
                end;
                If Trim(WizardPrgFileFrame.SetupEdit.Text)<>'' then begin
                  S:=MakeAbsPath(WizardPrgFileFrame.SetupEdit.Text,PrgSetup.BaseDir);
                  If IsDOSExe(S) then begin
                    If MessageDlg(Format(LanguageSetup.MessageDOSExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                  end;
                end;
              end;
              WizardGameInfoFrame.SetGameName(CalcProfileName,nil);
              NewPage:=3;
              If WizardMode<2 then DoOKButtonClick:=True;
            end else begin
              If not DoubleProfileCheck(Trim(WizardPrgFileFrame.ProgramEdit.Text)) then exit;
              If Trim(WizardPrgFileFrame.ProgramEdit.Text)<>'' then begin
                S:=MakeAbsPath(WizardPrgFileFrame.ProgramEdit.Text,PrgSetup.BaseDir);
                If IsWindowsExe(S) then begin
                  If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                end;
              end;
              If Trim(WizardPrgFileFrame.SetupEdit.Text)<>'' then begin
                S:=MakeAbsPath(WizardPrgFileFrame.SetupEdit.Text,PrgSetup.BaseDir);
                If IsWindowsExe(S) then begin
                  If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                end;
              end;
              WizardTemplateFrame.SearchTemplates(WizardPrgFileFrame.ProgramEdit.Text);

              If (WizardMode=0) or ((WizardTemplateFrame.TemplateType1List.Items.Count>0) and (WizardMode=1)) then begin
                If WizardTemplateFrame.TemplateType1List.Items.Count>0 then begin WizardTemplateFrame.TemplateType1List.ItemIndex:=0; WizardTemplateFrame.TemplateType1.Checked:=True; end;
                DoOKButtonClick:=True;
              end;
            end;
          end else begin
            If not DoubleProfileCheck(Trim(WizardScummVMFrame.ProgramEdit.Text)) then exit;
            If Trim(WizardScummVMFrame.ProgramEdit.Text)='' then begin
              If MessageDlg(LanguageSetup.MessageNoGameFileNameWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
            end;
            WizardScummVMSettingsFrame.SetScummVMGameName(WizardScummVMFrame.GetScummVMGameName,WizardScummVMFrame.ProgramEdit.Text);
          end;
        end;
    2 : If NewPage=3 then begin
          {Template or ScummVM settings page -> game info page}
          If not ScummVM then begin
             InsecureTemplate:=not WizardTemplateFrame.SelectedProfileSecure;
            if InsecureTemplate then begin
              If MessageDlg(LanguageSetup.MessageTemplateInsecureWarning,mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
            end;
          end;
          WizardGameInfoFrame.SetGameName(CalcProfileName,WizardTemplateFrame.GetTemplate);
        end;
    3 : If NewPage=4 then begin
          {Game info page -> mount page}
          WizardFinishFrame.SetInsecureStatus(InsecureTemplate);
          WizardFinishFrame.LoadData(WizardTemplateFrame.GetTemplate,WizardPrgFileFrame.ProgramEdit.Text,WizardPrgFileFrame.SetupEdit.Text,WizardGameInfoFrame.BaseName.Text);
        end;
  end;

  If (NewPage=2) and WindowsMode then NewPage:=1; 

  WizardBaseFrame.Visible:=(NewPage=0);
  WizardPrgFileFrame.Visible:=(NewPage=1) and (not ScummVM);
  If (NewPage=1) and (not ScummVM) then begin
    WizardPrgFileFrame.GamesFolderEdit.Visible:=not WindowsMode;
    WizardPrgFileFrame.GamesFolderButton.Visible:=not WindowsMode;
    WizardPrgFileFrame.FolderInfoButton.Visible:=not WindowsMode;
    WizardPrgFileFrame.OtherEmulator:=WizardBaseFrame.EmulationType;
    If WindowsMode
      then  WizardPrgFileFrame.InfoLabel.Caption:=LanguageSetup.WizardFormPage2InfoWindows
      else WizardPrgFileFrame.InfoLabel.Caption:=LanguageSetup.WizardFormPage2Info;
  end;
  WizardScummVMFrame.Visible:=(NewPage=1) and ScummVM;
  WizardTemplateFrame.Visible:=(NewPage=2) and (not ScummVM);
  WizardScummVMSettingsFrame.Visible:=(NewPage=2) and ScummVM;
  WizardGameInfoFrame.Visible:=(NewPage=3);
  WizardFinishFrame.Visible:=(NewPage=4);

  ActivePage:=NewPage;

  PreviousButton.Enabled:=(ActivePage>0);
  If ScummVM then begin
    NextButton.Enabled:=(ActivePage<3);
    OKButton.Enabled:=(ActivePage>=2);
  end else begin
    If WindowsMode then begin
      NextButton.Enabled:=(ActivePage<3);
      OKButton.Enabled:=(ActivePage>=1);
    end else begin
      NextButton.Enabled:=(ActivePage<4);
      OKButton.Enabled:=(ActivePage>=2);
    end;
  end;
end;

Procedure RedrawFrameIfVisible(const F : TFrame);
begin
  If not F.Visible then exit;

  F.Visible:=False;
  F.Visible:=True;
  F.Invalidate;
  F.Repaint;
end;

procedure TWizardForm.StepButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : SetActivePage(ActivePage-1);
    1 : SetActivePage(ActivePage+1);
  end;
  If DoOKButtonClick then begin
    OKButtonClick(Sender);
    ModalResult:=mrOK;
  end;

  RedrawFrameIfVisible(WizardBaseFrame);
  RedrawFrameIfVisible(WizardPrgFileFrame);
  RedrawFrameIfVisible(WizardTemplateFrame);
  RedrawFrameIfVisible(WizardGameInfoFrame);
  RedrawFrameIfVisible(WizardFinishFrame);
  RedrawFrameIfVisible(WizardScummVMFrame);
  RedrawFrameIfVisible(WizardScummVMSettingsFrame);
end;

procedure TWizardForm.OKButtonClick(Sender: TObject);
Var S : String;
begin
  if NextButton.Enabled and (not ScummVM) and (not WindowsMode) then begin
    If ActivePage=2 then begin
      {Template page -> game info page}
      InsecureTemplate:=not WizardTemplateFrame.SelectedProfileSecure;
      if InsecureTemplate then begin
        If MessageDlg(LanguageSetup.MessageTemplateInsecureWarning,mtWarning,[mbYes,mbNo],0)<>mrYes then begin ModalResult:=mrNone; exit; end;
      end;
      WizardGameInfoFrame.SetGameName(CalcProfileName,WizardTemplateFrame.GetTemplate);
    end;
    {Game info page -> mount page}
    WizardFinishFrame.SetInsecureStatus(InsecureTemplate);
    WizardFinishFrame.LoadData(WizardTemplateFrame.GetTemplate,WizardPrgFileFrame.ProgramEdit.Text,WizardPrgFileFrame.SetupEdit.Text,WizardGameInfoFrame.BaseName.Text);
  end;

  If ScummVM then begin
    S:=WizardGameInfoFrame.BaseName.Text;
    If S='' then S:=CalcProfileName;
    Game:=WizardScummVMSettingsFrame.CreateGame(S);
  end else begin
    S:=WizardGameInfoFrame.BaseName.Text;
    If S='' then S:=CalcProfileName;
    If WindowsMode
      then Game:=WizardTemplateFrame.CreateWindowsGame(S)
      else Game:=WizardTemplateFrame.CreateGame(S);
  end;
  WizardBaseFrame.WriteDataToGame(Game);
  If ScummVM then begin
    WizardScummVMFrame.WriteDataToGame(Game);
  end
    else WizardPrgFileFrame.WriteDataToGame(Game);
  If (Trim(Game.Name)='') and (WizardScummVMFrame.GameNameComboBox.ItemIndex>=0) then begin
    Game.Name:=CalcProfileName;
  end;
  WizardGameInfoFrame.WriteDataToGame(Game);

  WizardFinishFrame.WriteDataToGame(Game);
  OpenEditorNow:=WizardFinishFrame.ProfileEditorCheckBox.Checked;
  If not ScummVM then begin
    CreateGameCheckSum(Game,True);
    CreateSetupCheckSum(Game,True);
  end;
  Game.LoadCache;
  Game.StoreAllValues;
end;

function TWizardForm.DoubleProfileCheck(const GameFileName: String): Boolean;
Var I : Integer;
    S,T : String;
begin
  result:=True;
  If GameFileName='' then exit;
  S:=ExtUpperCase(MakeRelPath(GameFileName,PrgSetup.BaseDir));
  For I:=0 to GameDB.Count-1 do If not WindowsExeMode(GameDB[I]) then begin
    T:=Trim(GameDB[I].GameExe);
    If T='' then continue;
    If S=ExtUpperCase(MakeRelPath(T,PrgSetup.BaseDir)) then begin
      If MessageDlg(Format(LanguageSetup.WizardFormDoubleProfile,[GameDB[I].Name]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin result:=False; exit; end;
      break;
    end;
  end;
end;

procedure TWizardForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileWithWizard);
end;

procedure TWizardForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowWizardDialog(const AOwner : TComponent; const AGameDB : TGameDB; const AExeFile : String; const AWindowsExe : Boolean; var AGame : TGame; var OpenEditorNow, OpenInstallationSupport : Boolean; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  OpenEditorNow:=False;
  OpenInstallationSupport:=False;

  WizardForm:=TWizardForm.Create(AOwner);
  try
    WizardForm.GameDB:=AGameDB;
    WizardForm.LinkFile:=ASearchLinkFile;
    WizardForm.ExeFile:=AExeFile;
    WizardForm.WindowsExe:=AWindowsExe;
    result:=(WizardForm.ShowModal=mrOK);
    if (not result) and WizardForm.OpenInstallationSupportDialog then begin
      OpenInstallationSupport:=True;
    end;
    if result then begin
      AGame:=WizardForm.Game;
      OpenEditorNow:=WizardForm.OpenEditorNow;
    end;
  finally
    WizardForm.Free;
  end;
end;

end.

