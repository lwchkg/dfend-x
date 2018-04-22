unit SetupFrameImageScalingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFrameImageScaling = class(TFrame, ISetupFrame)
    ImageScalerLabel: TLabel;
    ImageScalerComboBox: TComboBox;
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

uses LanguageSetupUnit, PrgSetupUnit, VistaToolsUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TSetupFrameImageScaling }

function TSetupFrameImageScaling.GetName: String;
begin
  result:=LanguageSetup.SetupFormImageScaling;
end;

procedure TSetupFrameImageScaling.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(ImageScalerComboBox);

  {PrgSetup.ImageFilter: 0..8, 0=off, 1=simple&slow, 2=Box, 3=Triangle, 4=Hermite, 5=Bell, 6=B-Spline, 7=Lanczos3, 8=Mitchell}
  While ImageScalerComboBox.Items.Count<8 do ImageScalerComboBox.Items.Add('');
  Case PrgSetup.ImageFilter of
    0..1 : ImageScalerComboBox.ItemIndex:=PrgSetup.ImageFilter;
    2..8 : ImageScalerComboBox.ItemIndex:=PrgSetup.ImageFilter-1;
    else ImageScalerComboBox.ItemIndex:=1;
  End;

  HelpContext:=ID_FileOptionsImageScaling;
end;

procedure TSetupFrameImageScaling.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameImageScaling.LoadLanguage;
Var I : Integer;
begin
  ImageScalerLabel.Caption:=LanguageSetup.SetupFormImageScalingLabel;

  I:=ImageScalerComboBox.ItemIndex;
  with ImageScalerComboBox do begin
    Items[0]:=LanguageSetup.Off;
    Items[1]:=LanguageSetup.SetupFormImageScalingAlgorithmBox;
    Items[2]:=LanguageSetup.SetupFormImageScalingAlgorithmTriangle;
    Items[3]:=LanguageSetup.SetupFormImageScalingAlgorithmHermite;
    Items[4]:=LanguageSetup.SetupFormImageScalingAlgorithmBell;
    Items[5]:=LanguageSetup.SetupFormImageScalingAlgorithmBSpline;
    Items[6]:=LanguageSetup.SetupFormImageScalingAlgorithmLanczos3;
    Items[7]:=LanguageSetup.SetupFormImageScalingAlgorithmMitchell;
  end;
  ImageScalerComboBox.ItemIndex:=I;
end;

procedure TSetupFrameImageScaling.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameImageScaling.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameImageScaling.HideFrame;
begin
end;

procedure TSetupFrameImageScaling.RestoreDefaults;
begin
  ImageScalerComboBox.ItemIndex:=5;
end;

procedure TSetupFrameImageScaling.SaveSetup;
begin
  Case ImageScalerComboBox.ItemIndex of
    0 : PrgSetup.ImageFilter:=0;
    1..7 : PrgSetup.ImageFilter:=ImageScalerComboBox.ItemIndex+1;
  End;
end;

end.
