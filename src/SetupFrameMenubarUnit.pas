unit SetupFrameMenubarUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFrameMenubar = class(TFrame, ISetupFrame)
    ShowMenubarCheckBox: TCheckBox;
    ShowMenubarLabel: TLabel;
  private
    { Private-Deklarationen }
    FGetFrame : TGetFrameFunction;
    Procedure CloseCheck(var CloseOK : Boolean);
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts, SetupFrameToolbarUnit;

{$R *.dfm}

{ TSetupFrameMenubar }

function TSetupFrameMenubar.GetName: String;
begin
  result:=LanguageSetup.SetupFormShowMenubar;
end;

procedure TSetupFrameMenubar.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(ShowMenubarCheckBox);

  ShowMenubarCheckBox.Checked:=PrgSetup.ShowMainMenu;

  InitData.CloseCheckEvent:=CloseCheck;
  FGetFrame:=InitData.GetFrame;
end;

procedure TSetupFrameMenubar.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameMenubar.LoadLanguage;
begin
  ShowMenubarCheckBox.Caption:=LanguageSetup.MenuViewShowMenubar;
  ShowMenubarLabel.Caption:=LanguageSetup.MenuViewShowMenubarRestoreInfo;

  HelpContext:=ID_FileOptionsMenubar;
end;

procedure TSetupFrameMenubar.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameMenubar.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameMenubar.HideFrame;
begin
end;

procedure TSetupFrameMenubar.RestoreDefaults;
begin
  ShowMenubarCheckBox.Checked:=True;
end;

Procedure TSetupFrameMenubar.CloseCheck(var CloseOK : Boolean);
Var F : TSetupFrameToolbar;
begin
  If not ShowMenubarCheckBox.Checked then begin
    F:=FGetFrame(TSetupFrameToolbar) as TSetupFrameToolbar;
    if not F.ShowToolbarCheckBox.Checked then begin
      MessageDlg(LanguageSetup.SetupFormShowMenubarError,mtError,[mbOK],0);
      CloseOK:=False;
    end;
  end;
end;

procedure TSetupFrameMenubar.SaveSetup;
begin
  PrgSetup.ShowMainMenu:=ShowMenubarCheckBox.Checked;
end;

end.
