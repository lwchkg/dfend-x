unit ModernProfileEditorScummVMGraphicsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorScummVMGraphicsFrame = class(TFrame, IModernProfileEditorFrame)
    FilterLabel: TLabel;
    FilterComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    KeepAspectRatioCheckBox: TCheckBox;
    RenderModeLabel: TLabel;
    RenderModeComboBox: TComboBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorScummVMGraphicsFrame }

procedure TModernProfileEditorScummVMGraphicsFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(FilterComboBox);
  NoFlicker(RenderModeComboBox);
  NoFlicker(StartFullscreenCheckBox);
  NoFlicker(KeepAspectRatioCheckBox);

  FilterLabel.Caption:=LanguageSetup.ProfileEditorScummVMFilter;
  St:=ValueToList(InitData.GameDB.ConfOpt.ScummVMFilter,';,'); try FilterComboBox.Items.AddStrings(St); finally St.Free; end;
  RenderModeLabel.Caption:=LanguageSetup.ProfileEditorScummVMRenderMode;
  St:=ValueToList(InitData.GameDB.ConfOpt.ScummVMRenderMode,';,'); try RenderModeComboBox.Items.AddStrings(St); finally St.Free; end;

  AddDefaultValueHint(FilterComboBox);
  AddDefaultValueHint(RenderModeComboBox);

  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  KeepAspectRatioCheckBox.Caption:=LanguageSetup.GameAspectCorrection;

  HelpContext:=ID_ProfileEditGraphics;
end;

procedure TModernProfileEditorScummVMGraphicsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S,T : String;
    I : Integer;
begin
  S:=Trim(ExtUpperCase(Game.ScummVMFilter));
  FilterComboBox.ItemIndex:=0;
  For I:=0 to FilterComboBox.Items.Count-1 do begin
    T:=Trim(ExtUpperCase(FilterComboBox.Items[I]));
    If Pos('(',T)=0 then continue;
    T:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',T)=0 then continue;
    T:=Copy(T,1,Pos(')',T)-1);
    If Trim(T)=S then begin FilterComboBox.ItemIndex:=I; break; end;
  end;

  S:=Trim(ExtUpperCase(Game.ScummVMRenderMode));
  RenderModeComboBox.ItemIndex:=0;
  For I:=0 to RenderModeComboBox.Items.Count-1 do begin
    T:=Trim(ExtUpperCase(RenderModeComboBox.Items[I]));
    If Pos('(',T)=0 then begin
      If Trim(T)=S then begin RenderModeComboBox.ItemIndex:=I; break; end;
    end else begin
      T:=Copy(T,Pos('(',T)+1,MaxInt);
      If Pos(')',T)=0 then continue;
      T:=Copy(T,1,Pos(')',T)-1);
      If Trim(T)=S then begin RenderModeComboBox.ItemIndex:=I; break; end;
    end;
  end;

  StartFullscreenCheckBox.Checked:=Game.StartFullscreen;
  KeepAspectRatioCheckBox.Checked:=Game.AspectCorrection;
end;

procedure TModernProfileEditorScummVMGraphicsFrame.GetGame(const Game: TGame);
Var S : String;
begin
  S:=FilterComboBox.Text;
  If Pos('(',S)=0 then Game.ScummVMFilter:='' else begin
    S:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then Game.ScummVMFilter:=''  else Game.ScummVMFilter:=Copy(S,1,Pos(')',S)-1);
  end;

  S:=RenderModeComboBox.Text;
  If Pos('(',S)=0 then Game.ScummVMRenderMode:=S else begin
    S:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then Game.ScummVMRenderMode:=RenderModeComboBox.Text else Game.ScummVMRenderMode:=Copy(S,1,Pos(')',S)-1);
  end;

  Game.StartFullscreen:=StartFullscreenCheckBox.Checked;
  Game.AspectCorrection:=KeepAspectRatioCheckBox.Checked;
end;

end.
