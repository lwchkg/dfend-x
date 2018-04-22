unit ModernProfileEditorHardwareFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls;

type
  TModernProfileEditorHardwareFrame = class(TFrame, IModernProfileEditorFrame)
    InfoLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses LanguageSetupUnit;

{$R *.dfm}

{ TModernProfileEditorHardwareFrame }

procedure TModernProfileEditorHardwareFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  InitData.AllowDefaultValueReset:=False;
  
  InfoLabel.Caption:=LanguageSetup.ProfileEditorHardwareInfo;
end;

procedure TModernProfileEditorHardwareFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
end;

procedure TModernProfileEditorHardwareFrame.GetGame(const Game: TGame);
begin
end;

end.
