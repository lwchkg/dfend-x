unit ModernProfileEditorSerialPortsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorSerialPortsFrame = class(TFrame, IModernProfileEditorFrame)
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

uses LanguageSetupUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorSerialPortsFrame }

procedure TModernProfileEditorSerialPortsFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  InitData.AllowDefaultValueReset:=False;

  InfoLabel.Caption:=LanguageSetup.ProfileEditorSerialPortsInfo;

  HelpContext:=ID_ProfileEditSerialPorts;
end;

procedure TModernProfileEditorSerialPortsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
end;

procedure TModernProfileEditorSerialPortsFrame.GetGame(const Game: TGame);
begin
end;

end.
