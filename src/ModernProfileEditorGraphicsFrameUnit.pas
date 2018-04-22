unit ModernProfileEditorGraphicsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorGraphicsFrame = class(TFrame, IModernProfileEditorFrame)
    WindowResolutionLabel: TLabel;
    WindowResolutionComboBox: TComboBox;
    FullscreenResolutionLabel: TLabel;
    FullscreenResolutionComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    DoublebufferingCheckBox: TCheckBox;
    KeepAspectRatioCheckBox: TCheckBox;
    RenderLabel: TLabel;
    RenderComboBox: TComboBox;
    VideoCardLabel: TLabel;
    VideoCardComboBox: TComboBox;
    ScaleLabel: TLabel;
    ScaleComboBox: TComboBox;
    FrameSkipLabel: TLabel;
    FrameSkipEdit: TSpinEdit;
    TextModeLinesRadioGroup: TRadioGroup;
    VGASettingsGroupBox: TGroupBox;
    VGAChipsetLabel: TLabel;
    VGAChipsetComboBox: TComboBox;
    VideoRamLabel: TLabel;
    VideoRamComboBox: TComboBox;
    VGASettingsLabel: TLabel;
    FullscreenInfoLabel: TLabel;
    PixelShaderComboBox: TComboBox;
    PixelShaderLabel: TLabel;
    ResolutionInfoLabel: TLabel;
    GlideEmulationLabel: TLabel;
    GlideEmulationComboBox: TComboBox;
    GlideEmulationPortLabel: TLabel;
    GlideEmulationPortComboBox: TComboBox;
    GlideEmulationLFBLabel: TLabel;
    GlideEmulationLFBComboBox: TComboBox;
    procedure PixelShaderComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    ProfileDOSBoxInstallation : PString;
    LastPixelShader : String;
    PixelShaderChanged :  Boolean;
    Function GetDOSBoxDir : String;
    Procedure ShowFrame(Sender : TObject);
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     HelpConsts, GameDBToolsUnit;

{$R *.dfm}

{ TModernProfileEditorGraphicsFrame }

procedure TModernProfileEditorGraphicsFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
    I : Integer;
    S : String;
begin
  InitData.OnShowFrame:=ShowFrame;

  NoFlicker(WindowResolutionComboBox);
  NoFlicker(FullscreenResolutionComboBox);
  NoFlicker(StartFullscreenCheckBox);
  NoFlicker(DoublebufferingCheckBox);
  NoFlicker(KeepAspectRatioCheckBox);
  NoFlicker(GlideEmulationComboBox);
  NoFlicker(GlideEmulationPortComboBox);
  NoFlicker(GlideEmulationLFBComboBox);
  NoFlicker(RenderComboBox);
  NoFlicker(VideoCardComboBox);
  NoFlicker(PixelShaderComboBox);
  NoFlicker(VGASettingsGroupBox);
  NoFlicker(VGAChipsetComboBox);
  NoFlicker(VideoRamComboBox);
  NoFlicker(ScaleComboBox);
  NoFlicker(FrameSkipEdit);
  NoFlicker(TextModeLinesRadioGroup);

  WindowResolutionLabel.Caption:=LanguageSetup.GameWindowResolution;
  FullscreenResolutionLabel.Caption:=LanguageSetup.GameFullscreenResolution;
  St:=ValueToList(InitData.GameDB.ConfOpt.ResolutionWindow,';,');
  try WindowResolutionComboBox.Items.AddStrings(St); finally St.Free; end;
  St:=ValueToList(InitData.GameDB.ConfOpt.ResolutionFullscreen,';,');
  try FullscreenResolutionComboBox.Items.AddStrings(St); finally St.Free; end;
  ResolutionInfoLabel.Caption:=LanguageSetup.GameResolutionInfo;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  FullscreenInfoLabel.Caption:='('+LanguageSetup.GameStartFullscreenInfo+')';
  DoublebufferingCheckBox.Caption:=LanguageSetup.GameUseDoublebuffering;
  KeepAspectRatioCheckBox.Caption:=LanguageSetup.GameAspectCorrection;
  GlideEmulationLabel.Caption:=LanguageSetup.GameGlideEmulation;
  GlideEmulationPortLabel.Caption:=LanguageSetup.GameGlideEmulationPort;
  GlideEmulationLFBLabel.Caption:=LanguageSetup.GameGlideEmulationLFB;

  St:=ValueToList(InitData.GameDB.ConfOpt.GlideEmulation,';,');
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      if S='FALSE' then St[I]:=LanguageSetup.Off;
      if S='TRUE' then St[I]:=LanguageSetup.On;
    end;
    GlideEmulationComboBox.Items.Clear;
    GlideEmulationComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  St:=ValueToList(InitData.GameDB.ConfOpt.GlideEmulationPort,';,');
  try
    GlideEmulationPortComboBox.Items.Clear;
    GlideEmulationPortComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  St:=ValueToList(InitData.GameDB.ConfOpt.GlideEmulationLFB,';,');
  try
    GlideEmulationLFBComboBox.Items.Clear;
    GlideEmulationLFBComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  RenderLabel.Caption:=LanguageSetup.GameRender;
  St:=ValueToList(InitData.GameDB.ConfOpt.Render,';,'); try RenderComboBox.Items.AddStrings(St); finally St.Free; end;
  VideoCardLabel.Caption:=LanguageSetup.GameVideoCard;
  St:=ValueToList(InitData.GameDB.ConfOpt.Video,';,'); try VideoCardComboBox.Items.AddStrings(St); finally St.Free; end;
  VGASettingsGroupBox.Caption:=LanguageSetup.GameVGASettings;
  VGAChipsetLabel.Caption:=LanguageSetup.GameVGAChipset;
  St:=ValueToList(InitData.GameDB.ConfOpt.VGAChipsets,';,'); try VGAChipsetComboBox.Items.AddStrings(St); finally St.Free; end;
  VideoRamLabel.Caption:=LanguageSetup.GameVideoRam;
  St:=ValueToList(InitData.GameDB.ConfOpt.VGAVideoRAM,';,'); try VideoRamComboBox.Items.AddStrings(St); finally St.Free; end;
  VGASettingsLabel.Caption:=LanguageSetup.GameVGASettingsInfo;
  ScaleLabel.Caption:=LanguageSetup.GameScale;
  St:=ValueToList(InitData.GameDB.ConfOpt.Scale,';,'); try ScaleComboBox.Items.AddStrings(St); finally St.Free; end;
  FrameSkipLabel.Caption:=LanguageSetup.GameFrameskip;
  TextModeLinesRadioGroup.Caption:=LanguageSetup.GameTextModeLines;
  PixelShaderLabel.Caption:=LanguageSetup.GamePixelShader;

  ProfileDOSBoxInstallation:=InitData.CurrentDOSBoxInstallation;

  AddDefaultValueHint(WindowResolutionComboBox);
  AddDefaultValueHint(FullscreenResolutionComboBox);
  AddDefaultValueHint(RenderComboBox);
  AddDefaultValueHint(VideoCardComboBox);
  AddDefaultValueHint(VGAChipsetComboBox);
  AddDefaultValueHint(VideoRamComboBox);
  AddDefaultValueHint(ScaleComboBox);

  HelpContext:=ID_ProfileEditGraphics;
end;

procedure TModernProfileEditorGraphicsFrame.PixelShaderComboBoxChange(Sender: TObject);
begin
  PixelShaderChanged:=True;
end;

procedure TModernProfileEditorGraphicsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
    S,T : String;
begin
  S:=Trim(ExtUpperCase(Game.WindowResolution));
  WindowResolutionComboBox.ItemIndex:=0;
  For I:=0 to WindowResolutionComboBox.Items.Count-1 do If Trim(ExtUpperCase(WindowResolutionComboBox.Items[I]))=S then begin
    WindowResolutionComboBox.ItemIndex:=I; break;
  end;

  S:=Trim(ExtUpperCase(Game.FullscreenResolution));
  FullscreenResolutionComboBox.ItemIndex:=0;
  For I:=0 to FullscreenResolutionComboBox.Items.Count-1 do If Trim(ExtUpperCase(FullscreenResolutionComboBox.Items[I]))=S then begin
    FullscreenResolutionComboBox.ItemIndex:=I; break;
  end;

  StartFullscreenCheckBox.Checked:=Game.StartFullscreen;
  DoublebufferingCheckBox.Checked:=Game.UseDoublebuffering;
  KeepAspectRatioCheckBox.Checked:=Game.AspectCorrection;
  GlideEmulationLabel.Visible:=PrgSetup.AllowGlideSettings;
  GlideEmulationComboBox.Visible:=PrgSetup.AllowGlideSettings;
  GlideEmulationPortLabel.Visible:=PrgSetup.AllowGlideSettings;
  GlideEmulationPortComboBox.Visible:=PrgSetup.AllowGlideSettings;
  GlideEmulationLFBLabel.Visible:=PrgSetup.AllowGlideSettings;
  GlideEmulationLFBComboBox.Visible:=PrgSetup.AllowGlideSettings;
  If PrgSetup.AllowGlideSettings then begin
    S:=Trim(ExtUpperCase(Game.GlideEmulation));
    If (S='0') or (S='FALSE') then S:=LanguageSetup.Off;
    If (S='1') or (S='TRUE') then S:=LanguageSetup.On;
    S:=ExtUpperCase(S);
    GlideEmulationComboBox.ItemIndex:=0;
    For I:=0 to GlideEmulationComboBox.Items.Count-1 do If Trim(ExtUpperCase(GlideEmulationComboBox.Items[I]))=S then begin
      GlideEmulationComboBox.ItemIndex:=I; break;
    end;
    S:=Trim(ExtUpperCase(Game.GlidePort));
    GlideEmulationPortComboBox.ItemIndex:=0;
    For I:=0 to GlideEmulationPortComboBox.Items.Count-1 do If Trim(ExtUpperCase(GlideEmulationPortComboBox.Items[I]))=S then begin
      GlideEmulationPortComboBox.ItemIndex:=I; break;
    end;
    S:=Trim(ExtUpperCase(Game.GlideLFB));
    GlideEmulationLFBComboBox.ItemIndex:=0;
    For I:=0 to GlideEmulationLFBComboBox.Items.Count-1 do If Trim(ExtUpperCase(GlideEmulationLFBComboBox.Items[I]))=S then begin
      GlideEmulationLFBComboBox.ItemIndex:=I; break;
    end;
  end;

  S:=Trim(ExtUpperCase(Game.Render));
  RenderComboBox.ItemIndex:=0;
  For I:=0 to RenderComboBox.Items.Count-1 do If Trim(ExtUpperCase(RenderComboBox.Items[I]))=S then begin
    RenderComboBox.ItemIndex:=I; break;
  end;

  S:=Trim(ExtUpperCase(Game.VideoCard));
  VideoCardComboBox.ItemIndex:=VideoCardComboBox.Items.Count-1;
  For I:=0 to VideoCardComboBox.Items.Count-1 do begin
    T:=Trim(ExtUpperCase(VideoCardComboBox.Items[I]));
    If Pos('(',T)>0 then T:=Trim(Copy(T,1,Pos('(',T)-1));
    If T=S then begin VideoCardComboBox.ItemIndex:=I; break; end;
  end;

  LastPixelShader:=Game.PixelShader;
  PixelShaderComboBox.Items.Clear;

  VGASettingsGroupBox.Visible:=PrgSetup.AllowVGAChipsetSettings;
  If PrgSetup.AllowVGAChipsetSettings then begin
    If VGAChipsetComboBox.Items.Count>0 then VGAChipsetComboBox.ItemIndex:=0;
    S:=Trim(ExtUpperCase(Game.VGAChipset));
    For I:=0 to VGAChipsetComboBox.Items.Count-1 do If Trim(ExtUpperCase(VGAChipsetComboBox.Items[I]))=S then begin
      VGAChipsetComboBox.ItemIndex:=I;
      break;
    end;
    If VideoRamComboBox.Items.Count>0 then VideoRamComboBox.ItemIndex:=0;
    S:=Trim(ExtUpperCase(IntToStr(Game.VideoRam)));
    For I:=0 to VideoRamComboBox.Items.Count-1 do begin
      T:=Trim(ExtUpperCase(VideoRamComboBox.Items[I]));
      If T=S then begin VideoRamComboBox.ItemIndex:=I; break; end;
      If T='2048' then VideoRamComboBox.ItemIndex:=I;
    end;
  end;  

  S:=Trim(ExtUpperCase(Game.Scale));
  ScaleComboBox.ItemIndex:=0;
  For I:=0 to ScaleComboBox.Items.Count-1 do begin
    T:=Trim(ExtUpperCase(ScaleComboBox.Items[I]));
    If Pos('(',T)=0 then continue;
    T:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',T)=0 then continue;
    T:=Copy(T,1,Pos(')',T)-1);
    If Trim(T)=S then begin ScaleComboBox.ItemIndex:=I; break; end;
  end;

  FrameSkipEdit.Value:=Game.FrameSkip;

  TextModeLinesRadioGroup.Visible:=PrgSetup.AllowTextModeLineChange;
  If PrgSetup.AllowTextModeLineChange then Case Game.TextModeLines of
    28 : TextModeLinesRadioGroup.ItemIndex:=1;
    50 : TextModeLinesRadioGroup.ItemIndex:=2;
    else TextModeLinesRadioGroup.ItemIndex:=0;
  end;

  PixelShaderChanged:=LoadFromTemplate;
end;

function TModernProfileEditorGraphicsFrame.GetDOSBoxDir: String;
Var S : String;
    I : Integer;
begin
  result:='';

  S:=Trim(ExtUpperCase(ProfileDOSBoxInstallation^));
  If (S='') or (S='DEFAULT') then begin
    result:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  end else begin
    For I:=1 to PrgSetup.DOSBoxSettingsCount-1 do If Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[I].Name))=S then begin result:=PrgSetup.DOSBoxSettings[I].DosBoxDir; break; end;
  end;

  If result='' then result:=ProfileDOSBoxInstallation^;

  result:=IncludeTrailingPathDelimiter(MakeAbsPath(result,PrgSetup.BaseDir));
end;

procedure TModernProfileEditorGraphicsFrame.ShowFrame;
Var I : Integer;
    S : String;
    St : TStringList;
begin
  PixelShaderLabel.Visible:=PrgSetup.AllowPixelShader;
  PixelShaderComboBox.Visible:=PrgSetup.AllowPixelShader;

  If PixelShaderComboBox.Items.Count>0 then LastPixelShader:=PixelShaderComboBox.Text;
  PixelShaderComboBox.Items.Clear;

  St:=GetPixelShaders(GetDOSBoxDir);
  try
    PixelShaderComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  PixelShaderComboBox.ItemIndex:=0;
  S:=Trim(ExtUpperCase(LastPixelShader));
  For I:=0 to PixelShaderComboBox.Items.Count-1 do If Trim(ExtUpperCase(PixelShaderComboBox.Items[I]))=S then begin
    PixelShaderComboBox.ItemIndex:=I; break;
  end;

  PixelShaderChanged:=False;
end;

procedure TModernProfileEditorGraphicsFrame.GetGame(const Game: TGame);
Var S : String;
begin
  Game.WindowResolution:=WindowResolutionComboBox.Text;
  Game.FullscreenResolution:=FullscreenResolutionComboBox.Text;

  Game.StartFullscreen:=StartFullscreenCheckBox.Checked;
  Game.UseDoublebuffering:=DoublebufferingCheckBox.Checked;
  Game.AspectCorrection:=KeepAspectRatioCheckBox.Checked;
  If PrgSetup.AllowGlideSettings then begin
    S:=GlideEmulationComboBox.Items[GlideEmulationComboBox.ItemIndex];
    If S=LanguageSetup.On then S:='true';
    If S=LanguageSetup.Off then S:='false';
    Game.GlideEmulation:=S;
    Game.GlidePort:=GlideEmulationPortComboBox.Text;
    Game.GlideLFB:=GlideEmulationLFBComboBox.Items[max(0,GlideEmulationLFBComboBox.ItemIndex)];
  end;
  Game.Render:=RenderComboBox.Text;
  S:=Trim(VideoCardComboBox.Text);
  If Pos('(',S)<>0 then S:=Trim(Copy(S,1,Pos('(',S)-1));
  Game.VideoCard:=S;

  If PixelShaderChanged then Game.PixelShader:=PixelShaderComboBox.Text;

  If PrgSetup.AllowVGAChipsetSettings then begin
    Game.VGAChipset:=VGAChipsetComboBox.Text;
    try Game.VideoRam:=StrToInt(VideoRamComboBox.Text); except Game.VideoRam:=2048; end;
  end;  

  S:=ScaleComboBox.Text;
  If Pos('(',S)=0 then Game.Scale:='' else begin
    S:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then Game.Scale:=''  else Game.Scale:=Copy(S,1,Pos(')',S)-1);
  end;
  Game.FrameSkip:=Min(100,Max(0,FrameSkipEdit.Value));

  If PrgSetup.AllowTextModeLineChange then Case TextModeLinesRadioGroup.ItemIndex of
    0 : Game.TextModeLines:=25;
    1 : Game.TextModeLines:=28;
    2 : Game.TextModeLines:=50;
  end;
end;

end.
