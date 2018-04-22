unit SetupFrameUserInterpreterFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameUserInterpreterFrame = class(TFrame, ISetupFrame)
    ComboBox: TComboBox;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    InterpreterLabel: TLabel;
    ProgramEdit: TLabeledEdit;
    ParametersEdit: TLabeledEdit;
    ExtensionsEdit: TLabeledEdit;
    ProgramButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    InfoLabel: TLabel;
    procedure ComboBoxChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ProgramEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    PBaseDir : PString;
    Programs, Extensions, Parameters : TStringList;
    LastItem : Integer;
    JustChanging : Boolean;
    Procedure LoadList;
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
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

uses ShlObj, Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     IconLoaderUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameUserInterpreterFrame }

destructor TSetupFrameUserInterpreterFrame.Destroy;
begin
  Programs.Free;
  Extensions.Free;
  Parameters.Free;
  inherited Destroy;
end;

function TSetupFrameUserInterpreterFrame.GetName: String;
begin
  result:=LanguageSetup.SetupFormUserDefinedInterpreters;
end;

procedure TSetupFrameUserInterpreterFrame.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  Programs:=TStringList.Create;
  Extensions:=TStringList.Create;
  Parameters:=TStringList.Create;

  Programs.Assign(PrgSetup.DOSBoxBasedUserInterpretersPrograms);
  Extensions.Assign(PrgSetup.DOSBoxBasedUserInterpretersExtensions);
  Parameters.Assign(PrgSetup.DOSBoxBasedUserInterpretersParameters);

  PBaseDir:=InitData.PBaseDir;

  NoFlicker(ComboBox);
  NoFlicker(ProgramEdit);
  NoFlicker(ParametersEdit);
  NoFlicker(ExtensionsEdit);


  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);
  UserIconLoader.DialogImage(DI_Up,UpButton);
  UserIconLoader.DialogImage(DI_Down,DownButton);
  UserIconLoader.DialogImage(DI_SelectFile,ProgramButton);

  JustChanging:=False;
  LoadList;
  If ComboBox.Items.Count>0 then ComboBox.ItemIndex:=0;
  ComboBoxChange(self);

  HelpContext:=ID_FileOptionsUserInterpreters;
end;

procedure TSetupFrameUserInterpreterFrame.LoadLanguage;
begin
  InterpreterLabel.Caption:=LanguageSetup.SetupFormUserDefinedInterpretersLabel;

  AddButton.Hint:=LanguageSetup.SetupFormUserDefinedInterpretersAdd;
  DelButton.Hint:=LanguageSetup.SetupFormUserDefinedInterpretersDelete;
  UpButton.Hint:=LanguageSetup.MoveUp;
  DownButton.Hint:=LanguageSetup.MoveDown;
  ProgramButton.Hint:=LanguageSetup.ChooseFile;
  ProgramEdit.EditLabel.Caption:=LanguageSetup.SetupFormUserDefinedInterpretersProgram;
  ParametersEdit.EditLabel.Caption:=LanguageSetup.SetupFormUserDefinedInterpretersParameters;
  ExtensionsEdit.EditLabel.Caption:=LanguageSetup.SetupFormUserDefinedInterpretersExtensions;
  InfoLabel.Caption:=LanguageSetup.SetupFormUserDefinedInterpretersInfo;
end;

procedure TSetupFrameUserInterpreterFrame.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameUserInterpreterFrame.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameUserInterpreterFrame.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameUserInterpreterFrame.HideFrame;
begin
end;

procedure TSetupFrameUserInterpreterFrame.RestoreDefaults;
begin
end;

procedure TSetupFrameUserInterpreterFrame.SaveSetup;
begin
  ComboBoxChange(self);
  PrgSetup.DOSBoxBasedUserInterpretersPrograms.Assign(Programs);
  PrgSetup.DOSBoxBasedUserInterpretersParameters.Assign(Parameters);
  PrgSetup.DOSBoxBasedUserInterpretersExtensions.Assign(Extensions);
end;

procedure TSetupFrameUserInterpreterFrame.LoadList;
Var I : Integer;
begin
  LastItem:=-1;
  ComboBox.Items.BeginUpdate;
  try
    ComboBox.Items.Clear;
    For I:=0 to Programs.Count-1 do ComboBox.Items.Add(ExtractFileName(Programs[I]));
  finally
    ComboBox.Items.EndUpdate;
  end;
end;

procedure TSetupFrameUserInterpreterFrame.ProgramEditChange(Sender: TObject);
Var I : Integer;
begin
  If JustChanging then exit;
  I:=ComboBox.ItemIndex;
  ComboBox.Items[I]:=ExtractFileName(Trim(ProgramEdit.Text));
  ComboBox.ItemIndex:=I;
end;

procedure TSetupFrameUserInterpreterFrame.ComboBoxChange(Sender: TObject);
begin
  If LastItem>=0 then begin
    Programs[LastItem]:=Trim(ProgramEdit.Text);
    Parameters[LastItem]:=Trim(ParametersEdit.Text);
    Extensions[LastItem]:=Trim(ExtensionsEdit.Text);
    ComboBox.Items[LastItem]:=ExtractFileName(Trim(ProgramEdit.Text));
  end;

  LastItem:=ComboBox.ItemIndex;

  DelButton.Enabled:=(LastItem>=0);
  UpButton.Enabled:=(LastItem>=1);
  DownButton.Enabled:=(LastItem>=0) and (LastItem<ComboBox.Items.Count-1);

  ProgramEdit.Enabled:=(LastItem>=0);
  ParametersEdit.Enabled:=(LastItem>=0);
  ExtensionsEdit.Enabled:=(LastItem>=0);
  ProgramButton.Enabled:=(LastItem>=0);

  JustChanging:=True;
  try
    If LastItem<0 then begin
      ProgramEdit.Text:='';
      ParametersEdit.Text:='';
      ExtensionsEdit.Text:='';
      exit;
    end;

    ProgramEdit.Text:=Programs[LastItem];
    ParametersEdit.Text:=Parameters[LastItem];
    ExtensionsEdit.Text:=Extensions[LastItem];
  finally
    JustChanging:=False;
  end;
end;

procedure TSetupFrameUserInterpreterFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          Programs.Add('');
          Parameters.Add('%s');
          Extensions.Add('');
          ComboBox.ItemIndex:=-1; ComboBoxChange(Sender);
          LoadList;
          ComboBox.ItemIndex:=ComboBox.Items.Count-1; ComboBoxChange(Sender);
        end;
    1 : begin
          I:=LastItem;
          If MessageDlg(Format(LanguageSetup.SetupFormUserDefinedInterpretersDeleteWarning,[ComboBox.Items[I]]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          Programs.Delete(I);
          Parameters.Delete(I);
          Extensions.Delete(I);
          LoadList;
          If ComboBox.Items.Count>0 then ComboBox.ItemIndex:=Max(0,I-1);
          ComboBoxChange(Sender);
        end;
    2 : begin
          ComboBox.Items.Exchange(LastItem,LastItem-1);
          Programs.Exchange(LastItem,LastItem-1);
          Parameters.Exchange(LastItem,LastItem-1);
          Extensions.Exchange(LastItem,LastItem-1);
          dec(LastItem);
          ComboBox.ItemIndex:=LastItem;
          UpButton.Enabled:=(LastItem>=1);
          DownButton.Enabled:=(LastItem>=0) and (LastItem<ComboBox.Items.Count-1);
        end;
    3 : begin
          ComboBox.Items.Exchange(LastItem,LastItem+1);
          Programs.Exchange(LastItem,LastItem-1);
          Parameters.Exchange(LastItem,LastItem-1);
          Extensions.Exchange(LastItem,LastItem-1);
          inc(LastItem);
          ComboBox.ItemIndex:=LastItem;
          UpButton.Enabled:=(LastItem>=1);
          DownButton.Enabled:=(LastItem>=0) and (LastItem<ComboBox.Items.Count-1);
        end;
    4 : begin
          S:=MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir); If S<>'' then S:=ExtractFilePath(S);
          {If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);}
          If Trim(S)='' then S:=IncludeTrailingPathDelimiter(PBaseDir^);
          S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(PBaseDir^));
          OpenDialog.Title:=LanguageSetup.SetupFormUserDefinedInterpretersProgramTitle;
          OpenDialog.Filter:=LanguageSetup.SetupFormUserDefinedInterpretersProgramFilter;
          If S<>'' then OpenDialog.InitialDir:=S;
          If OpenDialog.Execute then ProgramEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
        end;
  end;
end;

end.
