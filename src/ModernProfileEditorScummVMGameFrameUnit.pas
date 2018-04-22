unit ModernProfileEditorScummVMGameFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls, Spin;

type
  TModernProfileEditorScummVMGameFrame = class(TFrame, IModernProfileEditorFrame)
    AltIntroCheckBox: TCheckBox;
    AltIntroLabel: TLabel;
    GFXDetailsEditLabel: TLabel;
    GFXDetailsEdit: TSpinEdit;
    GFXDetailsLabel: TLabel;
    ObjectLabelsCheckBox: TCheckBox;
    ObjectLabelsLabel: TLabel;
    ReverseStereoCheckBox: TCheckBox;
    ReverseStereoLabel: TLabel;
    MusicMuteCheckBox: TCheckBox;
    MusicMuteLabel: TLabel;
    SFXMuteCheckBox: TCheckBox;
    SFXMuteLabel: TLabel;
    WalkspeedEditLabel: TLabel;
    WalkspeedEdit: TSpinEdit;
    WalkspeedLabel: TLabel;
  private
    { Private-Deklarationen }
    LastGameName : String;
    CurrentGameName : PString;
    EditingTemplate : Boolean;
    Function GameNames(const Games : Array of String) : String;
    Procedure ShowFrame(Sender : TObject);
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, ScummVMToolsUnit,
     HelpConsts;

{$R *.dfm}

{ TModernProfileEditorScummVMGameFrame }

procedure TModernProfileEditorScummVMGameFrame.InitGUI(var InitData: TModernProfileEditorInitData);
begin
  InitData.OnShowFrame:=ShowFrame;

  LastGameName:='';

  NoFlicker(AltIntroCheckBox);
  NoFlicker(GFXDetailsEdit);
  NoFlicker(ObjectLabelsCheckBox);
  NoFlicker(ReverseStereoCheckBox);
  NoFlicker(MusicMuteCheckBox);
  NoFlicker(SFXMuteCheckBox);
  NoFlicker(WalkspeedEdit);

  AltIntroCheckbox.Caption:=LanguageSetup.ProfileEditorScummVMAltIntro;
  GFXDetailsEditLabel.Caption:=LanguageSetup.ProfileEditorScummVMGFXDetails;
  ObjectLabelsCheckbox.Caption:=LanguageSetup.ProfileEditorScummVMObjectLabels;
  ReverseStereoCheckbox.Caption:=LanguageSetup.ProfileEditorScummVMReverseStereo;
  MusicMuteCheckbox.Caption:=LanguageSetup.ProfileEditorScummVMMusicMute;
  SFXMuteCheckbox.Caption:=LanguageSetup.ProfileEditorScummVMSFXMute;
  WalkspeedEditLabel.Caption:=LanguageSetup.ProfileEditorScummVMWalkspeed;
  AltIntroLabel.Caption:=GameNames(['sky','queen']);
  GFXDetailsLabel.Caption:=GameNames(['sword2']);
  ObjectLabelsLabel.Caption:=GameNames(['sword2']);
  ReverseStereoLabel.Caption:=GameNames(['sword2']);
  MusicMuteLabel.Caption:=GameNames(['sword2','queen','simon1','simon2']);
  SFXMuteLabel.Caption:=GameNames(['sword2','queen','simon1','simon2']);
  WalkspeedLabel.Caption:=GameNames(['kyra1']);

  CurrentGameName:=InitData.CurrentScummVMGameName;
  EditingTemplate:=InitData.EditingTemplate;

  HelpContext:=ID_ProfileEditScummVMGame;
end;

function TModernProfileEditorScummVMGameFrame.GameNames(const Games: array of String): String;
Var I,Nr : Integer;
begin
  result:='';
  For I:=Low(Games) to High(Games) do begin
    Nr:=ScummVMGamesList.NamesList.IndexOf(LowerCase(Games[I]));
    If Nr<0 then continue;
    If result=''
      then result:='("'+ScummVMGamesList.DescriptionList[Nr]+'"'
      else result:=result+', "'+ScummVMGamesList.DescriptionList[Nr]+'"';
  end;
  If result<>'' then result:=result+')';
end;

procedure TModernProfileEditorScummVMGameFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  AltIntroCheckBox.Checked:=Game.ScummVMAltIntro;
  GFXDetailsEdit.Value:=Max(0,Min(3,Game.ScummVMGFXDetails));
  ObjectLabelsCheckBox.Checked:=Game.ScummVMObjectLabels;
  ReverseStereoCheckBox.Checked:=Game.ScummVMReverseStereo;
  MusicMuteCheckBox.Checked:=Game.ScummVMMusicMute;
  SFXMuteCheckBox.Checked:=Game.ScummVMSFXMute;
  WalkspeedEdit.Value:=Max(0,Min(4,Game.ScummVMWalkspeed));
end;

procedure TModernProfileEditorScummVMGameFrame.ShowFrame(Sender : TObject);
begin
  If LastGameName=LowerCase(CurrentGameName^) then exit;
  LastGameName:=LowerCase(CurrentGameName^);

  AltIntroCheckBox.Enabled:=EditingTemplate or (LastGameName='sky') or (LastGameName='queen');
  GFXDetailsEdit.Enabled:=EditingTemplate or (LastGameName='sword2');
  ObjectLabelsCheckBox.Enabled:=EditingTemplate or (LastGameName='sword2');
  ReverseStereoCheckBox.Enabled:=EditingTemplate or (LastGameName='sword2');
  MusicMuteCheckBox.Enabled:=EditingTemplate or (LastGameName='sword2') or (LastGameName='queen') or (LastGameName='simon1') or (LastGameName='simon2');
  SFXMuteCheckBox.Enabled:=EditingTemplate or (LastGameName='sword2') or (LastGameName='queen') or (LastGameName='simon1') or (LastGameName='simon2');
  WalkspeedEdit.Enabled:=EditingTemplate or (LastGameName='kyra1');
end;

procedure TModernProfileEditorScummVMGameFrame.GetGame(const Game: TGame);
begin
  Game.ScummVMAltIntro:=AltIntroCheckBox.Checked;
  Game.ScummVMGFXDetails:=GFXDetailsEdit.Value;
  Game.ScummVMObjectLabels:=ObjectLabelsCheckBox.Checked;
  Game.ScummVMReverseStereo:=ReverseStereoCheckBox.Checked;
  Game.ScummVMMusicMute:=MusicMuteCheckBox.Checked;
  Game.ScummVMSFXMute:=SFXMuteCheckBox.Checked;
  Game.ScummVMWalkspeed:=WalkspeedEdit.Value;
end;

end.
