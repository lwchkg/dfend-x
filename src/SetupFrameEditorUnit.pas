unit SetupFrameEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, SetupFormUnit;

type
  TSetupFrameEditor = class(TFrame, ISetupFrame)
    RadioButtonDefault: TRadioButton;
    FallbackCheckBox: TCheckBox;
    RadioButtonNotepad: TRadioButton;
    RadioButtonCustom: TRadioButton;
    CustomEdit: TEdit;
    FixLineWrapCheckBox: TCheckBox;
    CustomButton: TSpeedButton;
    PrgOpenDialog: TOpenDialog;
    procedure CustomEditChange(Sender: TObject);
    procedure CustomButtonClick(Sender: TObject);
    procedure RadioButtonClick(Sender: TObject);
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

uses ShlObj, CommonTools, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ TSetupFrameEditor }

function TSetupFrameEditor.GetName: String;
begin
  result:=LanguageSetup.SetupFormTextEditor;
end;

procedure TSetupFrameEditor.InitGUIAndLoadSetup(var InitData: TInitData);
Var S : String;
begin
  NoFlicker(RadioButtonDefault);
  NoFlicker(FallbackCheckBox);
  NoFlicker(RadioButtonNotepad);
  NoFlicker(RadioButtonCustom);
  NoFlicker(CustomEdit);
  NoFlicker(FixLineWrapCheckBox);

  S:=Trim(ExtUpperCase(PrgSetup.TextEditor));
  If S='' then RadioButtonDefault.Checked:=True else begin
    If (S='NOTEPAD') or (S='NOTEPAD.EXE') then RadioButtonNotepad.Checked:=True else begin
      RadioButtonCustom.Checked:=True;
      CustomEdit.Text:=MakeRelPath(PrgSetup.TextEditor,PrgSetup.BaseDir);
    end;
  end;
  FallbackCheckBox.Checked:=PrgSetup.FileTypeFallbackForEditor;
  FixLineWrapCheckBox.Checked:=PrgSetup.AutoFixLineWrap;

  UserIconLoader.DialogImage(DI_SelectFile,CustomButton);

  RadioButtonClick(self);
end;

procedure TSetupFrameEditor.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameEditor.LoadLanguage;
begin
  RadioButtonDefault.Caption:=LanguageSetup.SetupFormTextEditorDefault;
  FallbackCheckBox.Caption:=LanguageSetup.SetupFormTextEditorDefaultFallback;
  RadioButtonNotepad.Caption:=LanguageSetup.SetupFormTextEditorNotepad;
  RadioButtonCustom.Caption:=LanguageSetup.SetupFormTextEditorCustom;
  CustomButton.Hint:=LanguageSetup.ChooseFile;
  FixLineWrapCheckBox.Caption:=LanguageSetup.SetupFormTextEditorFixLineWrap;
  PrgOpenDialog.Title:=LanguageSetup.SetupFormTextEditorCustomOpenCaption;
  PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;

  HelpContext:=ID_FileOptionsTextEditor;
end;

procedure TSetupFrameEditor.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameEditor.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameEditor.HideFrame;
begin
end;

procedure TSetupFrameEditor.RestoreDefaults;
begin
  CustomEdit.Text:='';
  RadioButtonDefault.Checked:=True;
  FallbackCheckBox.Checked:=True;
  FixLineWrapCheckBox.Checked:=False;
  RadioButtonClick(self);
end;

procedure TSetupFrameEditor.SaveSetup;
begin
  If RadioButtonDefault.Checked then PrgSetup.TextEditor:='';
  If RadioButtonNotepad.Checked then PrgSetup.TextEditor:='Notepad.exe';
  If RadioButtonCustom.Checked then PrgSetup.TextEditor:=MakeRelPath(CustomEdit.Text,PrgSetup.BaseDir);
  PrgSetup.FileTypeFallbackForEditor:=FallbackCheckBox.Checked;
  PrgSetup.AutoFixLineWrap:=FixLineWrapCheckBox.Checked;
end;

procedure TSetupFrameEditor.RadioButtonClick(Sender: TObject);
begin
  FallbackCheckBox.Enabled:=RadioButtonDefault.Checked;
end;

procedure TSetupFrameEditor.CustomEditChange(Sender: TObject);
begin
  RadioButtonCustom.Checked:=True;
  RadioButtonClick(Sender);
end;

procedure TSetupFrameEditor.CustomButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(CustomEdit.Text); If S<>'' then S:=ExtractFilePath(S);
  If S='' then S:=GetSpecialFolder(Handle,CSIDL_PROGRAM_FILES); 
  If S<>'' then PrgOpenDialog.InitialDir:=S;
  If PrgOpenDialog.Execute then begin
    RadioButtonCustom.Checked:=True;
    CustomEdit.Text:=PrgOpenDialog.FileName;
  end;
end;

end.
