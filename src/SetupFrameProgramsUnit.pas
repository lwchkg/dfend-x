unit SetupFrameProgramsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFramePrograms = class(TFrame, ISetupFrame)
    InfoLabel: TLabel;
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

uses LanguageSetupUnit;

{$R *.dfm}

{ TSetupFramePrograms }

function TSetupFramePrograms.GetName: String;
begin
  result:=LanguageSetup.SetupFormProgramsSheet;
end;

procedure TSetupFramePrograms.InitGUIAndLoadSetup(var InitData: TInitData);
begin
end;

procedure TSetupFramePrograms.BeforeChangeLanguage;
begin
end;

procedure TSetupFramePrograms.LoadLanguage;
begin
  InfoLabel.Caption:=LanguageSetup.SetupFormProgramsInfo;
end;

procedure TSetupFramePrograms.DOSBoxDirChanged;
begin
end;

procedure TSetupFramePrograms.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFramePrograms.HideFrame;
begin
end;

procedure TSetupFramePrograms.RestoreDefaults;
begin
end;

procedure TSetupFramePrograms.SaveSetup;
begin
end;

end.
