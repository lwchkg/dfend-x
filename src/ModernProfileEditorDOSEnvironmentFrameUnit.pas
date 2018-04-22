unit ModernProfileEditorDOSEnvironmentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Grids, ValEdit, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorDOSEnvironmentFrame = class(TFrame, IModernProfileEditorFrame)
    ReportedDOSVersionLabel: TLabel;
    ReportedDOSVersionComboBox: TComboBox;
    Use4DOSCheckBox: TCheckBox;
    CustomSetsEnvLabel: TLabel;
    CustomSetsValueListEditor: TValueListEditor;
    CustomSetsEnvAdd: TBitBtn;
    CustomSetsEnvDel: TBitBtn;
    Use4DOSInfoLabel: TLabel;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, HelpConsts,
     IconLoaderUnit;

{$R *.dfm}

{ TModernProfileEditorDOSEnvironmentFrame }

procedure TModernProfileEditorDOSEnvironmentFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(ReportedDOSVersionComboBox);
  NoFlicker(Use4DOSCheckBox);
  NoFlicker(CustomSetsValueListEditor);
  NoFlicker(CustomSetsEnvAdd);
  NoFlicker(CustomSetsEnvDel);

  ReportedDOSVersionLabel.Caption:=LanguageSetup.GameReportedDOSVersion;
  St:=ValueToList(InitData.GameDB.ConfOpt.ReportedDOSVersion,';,'); try ReportedDOSVersionComboBox.Items.AddStrings(St); finally St.Free; end;
  Use4DOSCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecUse4DOS;
  Use4DOSInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    Use4DOSInfoLabel.Font.Color:=clGrayText;
  end else begin
    Use4DOSInfoLabel.Font.Color:=clRed;
  end;
  CustomSetsEnvLabel.Caption:=LanguageSetup.ProfileEditorCustomSetsEnvironment;
  CustomSetsValueListEditor.TitleCaptions.Clear;
  CustomSetsValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  CustomSetsValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  CustomSetsEnvAdd.Caption:=LanguageSetup.Add;
  CustomSetsEnvDel.Caption:=LanguageSetup.Del;
  UserIconLoader.DialogImage(DI_Add,CustomSetsEnvAdd);
  UserIconLoader.DialogImage(DI_Delete,CustomSetsEnvDel);

  AddDefaultValueHint(ReportedDOSVersionComboBox);

  HelpContext:=ID_ProfileEditDOSEnvironment;
end;

procedure TModernProfileEditorDOSEnvironmentFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    I : Integer;
begin
  ReportedDOSVersionComboBox.Text:=Game.ReportedDOSVersion;
  Use4DOSCheckBox.Checked:=Game.Use4DOS;
  CustomSetsValueListEditor.Strings.Clear;
  If (Game.Environment='') and LoadFromTemplate then begin
    CustomSetsValueListEditor.Strings.Add('PATH=Z:\');
  end else begin
    St:=StringToStringList(Game.Environment);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then
        CustomSetsValueListEditor.Strings.Add(Replace(St[I],'['+IntToStr(ord('='))+']','='));
    finally
      St.Free;
    end;
  end;
end;

procedure TModernProfileEditorDOSEnvironmentFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : CustomSetsValueListEditor.Strings.Add('Key=');
    1 : if (CustomSetsValueListEditor.Row>0) and (CustomSetsValueListEditor.RowCount>2) then CustomSetsValueListEditor.Strings.Delete(CustomSetsValueListEditor.Row-1);
  end;
end;

procedure TModernProfileEditorDOSEnvironmentFrame.GetGame(const Game: TGame);
Var St : TStringList;
    I : Integer;
begin
  Game.ReportedDOSVersion:=ReportedDOSVersionComboBox.Text;
  Game.Use4DOS:=Use4DOSCheckBox.Checked;
  St:=TStringList.Create;
  try
    For I:=0 to CustomSetsValueListEditor.Strings.Count-1 do St.Add(Replace(CustomSetsValueListEditor.Strings[I],'=','['+IntToStr(ord('='))+']'));
    Game.Environment:=StringListToString(St);
  finally
    St.Free;
  end;
end;

end.
