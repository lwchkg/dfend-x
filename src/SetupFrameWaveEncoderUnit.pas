unit SetupFrameWaveEncoderUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameWaveEncoder = class(TFrame, ISetupFrame)
    WaveEncMp3Button1: TSpeedButton;
    WaveEncMp3Button2: TSpeedButton;
    WaveEncOggButton1: TSpeedButton;
    WaveEncOggButton2: TSpeedButton;
    WaveEncMp3Edit: TLabeledEdit;
    WaveEncOggEdit: TLabeledEdit;
    PrgOpenDialog: TOpenDialog;
    WaveEncMp3ParameterEdit: TLabeledEdit;
    WaveEncOggParameterEdit: TLabeledEdit;
    procedure ButtonWork(Sender: TObject);
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

Function UpdateEncoderParameters(const S : String) : String;
Function ProcessEncoderParameters(const ParameterString, InFile, OutFile : String) : String;

implementation

uses ShlObj, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     SetupDosBoxFormUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ global }

Function UpdateEncoderParameters(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  If (Pos('%1',result)>0) and (Pos('%2',result)>0) then exit;

  I:=Pos('%s',result); If I>0 then result:=Copy(result,1,I-1)+'%1'+Copy(result,I+2,MaxInt);
  I:=Pos('%s',result); If I>0 then result:=Copy(result,1,I-1)+'%2'+Copy(result,I+2,MaxInt);
end;

Function ProcessEncoderParameters(const ParameterString, InFile, OutFile : String) : String;
Var I : Integer;
begin
  result:=UpdateEncoderParameters(ParameterString);
  I:=Pos('%1',result); If I>0 then result:=Copy(result,1,I-1)+InFile+Copy(result,I+2,MaxInt);
  I:=Pos('%2',result); If I>0 then result:=Copy(result,1,I-1)+OutFile+Copy(result,I+2,MaxInt);
end;

{ TSetupFrameWaveEncoder }

function TSetupFrameWaveEncoder.GetName: String;
begin
  result:=LanguageSetup.SetupFormWaveEnc;
end;

procedure TSetupFrameWaveEncoder.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  NoFlicker(WaveEncMp3Edit);
  NoFlicker(WaveEncOggEdit);

  WaveEncMp3Edit.Text:=PrgSetup.WaveEncMp3;
  WaveEncMp3ParameterEdit.Text:=UpdateEncoderParameters(PrgSetup.WaveEncMp3Parameters);
  WaveEncOggEdit.Text:=PrgSetup.WaveEncOgg;
  WaveEncOggParameterEdit.Text:=UpdateEncoderParameters(PrgSetup.WaveEncOggParameters);

  UserIconLoader.DialogImage(DI_SelectFile,WaveEncMp3Button1);
  UserIconLoader.DialogImage(DI_FindFile,WaveEncMp3Button2);
  UserIconLoader.DialogImage(DI_SelectFile,WaveEncOggButton1);
  UserIconLoader.DialogImage(DI_FindFile,WaveEncOggButton2);
end;

procedure TSetupFrameWaveEncoder.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameWaveEncoder.LoadLanguage;
begin
  WaveEncMp3Edit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncMp3;
  WaveEncMp3Button1.Hint:=LanguageSetup.ChooseFile;
  WaveEncMp3Button2.Hint:=LanguageSetup.SetupFormSearchLame;
  WaveEncMp3ParameterEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncMp3Parameters;
  WaveEncOggEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncOgg;
  WaveEncOggButton1.Hint:=LanguageSetup.ChooseFile;
  WaveEncOggButton2.Hint:=LanguageSetup.SetupFormSearchOggEnc;
  WaveEncOggParameterEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncOggParameters;

  HelpContext:=ID_FileOptionsWaveEncoder;
end;

procedure TSetupFrameWaveEncoder.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameWaveEncoder.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameWaveEncoder.HideFrame;
begin
end;

procedure TSetupFrameWaveEncoder.RestoreDefaults;
begin
  WaveEncMp3ParameterEdit.Text:='-h -V 0 "%1" "%2"';
  WaveEncOggParameterEdit.Text:='"%1" --output="%2" --quality=10';
end;

procedure TSetupFrameWaveEncoder.SaveSetup;
begin
  PrgSetup.WaveEncMp3:=WaveEncMp3Edit.Text;
  PrgSetup.WaveEncMp3Parameters:=UpdateEncoderParameters(WaveEncMp3ParameterEdit.Text);
  PrgSetup.WaveEncOgg:=WaveEncOggEdit.Text;
  PrgSetup.WaveEncOggParameters:=UpdateEncoderParameters(WaveEncOggParameterEdit.Text);
end;

procedure TSetupFrameWaveEncoder.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
   10 : begin
          S:=Trim(WaveEncMp3Edit.Text); If S<>'' then S:=ExtractFilePath(S);
          If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
          PrgOpenDialog.Title:=LanguageSetup.SetupFormWaveEncMp3;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            WaveEncMp3Edit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   11 : if SearchLame(self) then WaveEncMp3Edit.Text:=PrgSetup.WaveEncMp3;
   12 : begin
          S:=Trim(WaveEncOggEdit.Text); If S<>'' then S:=ExtractFilePath(S);
          If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
          PrgOpenDialog.Title:=LanguageSetup.SetupFormWaveEncOgg;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            WaveEncOggEdit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   13 : if SearchOggEnc(self) then WaveEncOggEdit.Text:=PrgSetup.WaveEncOgg;
  end;
end;

end.
