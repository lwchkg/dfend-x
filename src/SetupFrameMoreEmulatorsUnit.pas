unit SetupFrameMoreEmulatorsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameMoreEmulators = class(TFrame, ISetupFrame)
    ComboBox: TComboBox;
    OpenDialog: TOpenDialog;
    ExtensionsEdit: TLabeledEdit;
    ParametersEdit: TLabeledEdit;
    ProgramEdit: TLabeledEdit;
    ProgramButton: TSpeedButton;
    InterpreterLabel: TLabel;
    DownButton: TSpeedButton;
    UpButton: TSpeedButton;
    DelButton: TSpeedButton;
    AddButton: TSpeedButton;
    NameEdit: TLabeledEdit;
    InfoLabel: TLabel;
    procedure NameEditChange(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    Names, Programs, Extensions, Parameters : TStringList;
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

uses ShlObj, Math, LanguageSetupUnit, CommonTools, VistaToolsUnit, PrgSetupUnit,
     IconLoaderUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameMoreEmulators }

destructor TSetupFrameMoreEmulators.Destroy;
begin
  Names.Free;
  Programs.Free;
  Extensions.Free;
  Parameters.Free;
  inherited Destroy;
end;

function TSetupFrameMoreEmulators.GetName: String;
begin
  result:=LanguageSetup.SetupFormMoreEmulators;
end;

procedure TSetupFrameMoreEmulators.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  Names:=TStringList.Create;
  Programs:=TStringList.Create;
  Extensions:=TStringList.Create;
  Parameters:=TStringList.Create;

  Names.Assign(PrgSetup.WindowsBasedEmulatorsNames);
  Programs.Assign(PrgSetup.WindowsBasedEmulatorsPrograms);
  Extensions.Assign(PrgSetup.WindowsBasedEmulatorsExtensions);
  Parameters.Assign(PrgSetup.WindowsBasedEmulatorsParameters);

  NoFlicker(ComboBox);
  NoFlicker(NameEdit);
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

  HelpContext:=ID_FileOptionsMoreEmulator;
end;

procedure TSetupFrameMoreEmulators.LoadLanguage;
begin
  InterpreterLabel.Caption:=LanguageSetup.SetupFormMoreEmulators;

  AddButton.Hint:=LanguageSetup.SetupFormMoreEmulatorsAdd;
  DelButton.Hint:=LanguageSetup.SetupFormMoreEmulatorsDelete;
  UpButton.Hint:=LanguageSetup.MoveUp;
  DownButton.Hint:=LanguageSetup.MoveDown;
  ProgramButton.Hint:=LanguageSetup.ChooseFile;
  NameEdit.EditLabel.Caption:=LanguageSetup.SetupFormMoreEmulatorsName;
  ProgramEdit.EditLabel.Caption:=LanguageSetup.SetupFormMoreEmulatorsProgram;
  ParametersEdit.EditLabel.Caption:=LanguageSetup.SetupFormMoreEmulatorsParameters;
  ExtensionsEdit.EditLabel.Caption:=LanguageSetup.SetupFormMoreEmulatorsExtensions;
  InfoLabel.Caption:=LanguageSetup.SetupFormMoreEmulatorsInfo;
end;

procedure TSetupFrameMoreEmulators.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameMoreEmulators.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameMoreEmulators.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameMoreEmulators.HideFrame;
begin
end;

procedure TSetupFrameMoreEmulators.RestoreDefaults;
begin
end;

procedure TSetupFrameMoreEmulators.SaveSetup;
begin
  ComboBoxChange(self);
  PrgSetup.WindowsBasedEmulatorsNames.Assign(Names);
  PrgSetup.WindowsBasedEmulatorsPrograms.Assign(Programs);
  PrgSetup.WindowsBasedEmulatorsParameters.Assign(Parameters);
  PrgSetup.WindowsBasedEmulatorsExtensions.Assign(Extensions);
end;

procedure TSetupFrameMoreEmulators.LoadList;
Var I : Integer;
begin
  LastItem:=-1;
  ComboBox.Items.BeginUpdate;
  try
    ComboBox.Items.Clear;
    For I:=0 to Names.Count-1 do ComboBox.Items.Add(Names[I]);
  finally
    ComboBox.Items.EndUpdate;
  end;
end;

procedure TSetupFrameMoreEmulators.NameEditChange(Sender: TObject);
Var I : Integer;
begin
  If JustChanging then exit;
  I:=ComboBox.ItemIndex;
  ComboBox.Items[I]:=ExtractFileName(Trim(NameEdit.Text));
  ComboBox.ItemIndex:=I;
end;

procedure TSetupFrameMoreEmulators.ComboBoxChange(Sender: TObject);
begin
  If LastItem>=0 then begin
    If Trim(NameEdit.Text)<>''
      then Names[LastItem]:=Trim(NameEdit.Text)
      else Names[LastItem]:=Trim(ChangeFileExt(ExtractFileName(ProgramEdit.Text),''));
    ComboBox.Items[LastItem]:=Names[LastItem];
    Programs[LastItem]:=Trim(ProgramEdit.Text);
    Parameters[LastItem]:=Trim(ParametersEdit.Text);
    Extensions[LastItem]:=Trim(ExtensionsEdit.Text);
  end;

  LastItem:=ComboBox.ItemIndex;

  DelButton.Enabled:=(LastItem>=0);
  UpButton.Enabled:=(LastItem>=1);
  DownButton.Enabled:=(LastItem>=0) and (LastItem<ComboBox.Items.Count-1);

  NameEdit.Enabled:=(LastItem>=0);
  ProgramEdit.Enabled:=(LastItem>=0);
  ParametersEdit.Enabled:=(LastItem>=0);
  ExtensionsEdit.Enabled:=(LastItem>=0);
  ProgramButton.Enabled:=(LastItem>=0);

  JustChanging:=True;
  try
    If LastItem<0 then begin
      NameEdit.Text:='';
      ProgramEdit.Text:='';
      ParametersEdit.Text:='';
      ExtensionsEdit.Text:='';
      exit;
    end;

    NameEdit.Text:=Names[LastItem];
    ProgramEdit.Text:=Programs[LastItem];
    ParametersEdit.Text:=Parameters[LastItem];
    ExtensionsEdit.Text:=Extensions[LastItem];
  finally
    JustChanging:=False;
  end;
end;

procedure TSetupFrameMoreEmulators.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          Names.Add('');
          Programs.Add('');
          Parameters.Add('"%s"');
          Extensions.Add('');
          ComboBox.ItemIndex:=-1; ComboBoxChange(Sender);
          LoadList;
          ComboBox.ItemIndex:=ComboBox.Items.Count-1; ComboBoxChange(Sender);
        end;
    1 : begin
          I:=LastItem;
          If MessageDlg(Format(LanguageSetup.SetupFormMoreEmulatorsDeleteWarning,[ComboBox.Items[I]]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          Names.Delete(I);
          Programs.Delete(I);
          Parameters.Delete(I);
          Extensions.Delete(I);
          LoadList;
          If ComboBox.Items.Count>0 then ComboBox.ItemIndex:=Max(0,I-1);
          ComboBoxChange(Sender);
        end;
    2 : begin
          ComboBox.Items.Exchange(LastItem,LastItem-1);
          Names.Exchange(LastItem,LastItem-1);
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
          Names.Exchange(LastItem,LastItem+1);
          Programs.Exchange(LastItem,LastItem+1);
          Parameters.Exchange(LastItem,LastItem+1);
          Extensions.Exchange(LastItem,LastItem+1);
          inc(LastItem);
          ComboBox.ItemIndex:=LastItem;
          UpButton.Enabled:=(LastItem>=1);
          DownButton.Enabled:=(LastItem>=0) and (LastItem<ComboBox.Items.Count-1);
        end;
    4 : begin
          S:=MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir); If S<>'' then S:=ExtractFilePath(S);
          If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
          OpenDialog.Title:=LanguageSetup.SetupFormMoreEmulatorsProgramTitle;
          OpenDialog.Filter:=LanguageSetup.SetupFormMoreEmulatorsProgramFilter;
          If S<>'' then OpenDialog.InitialDir:=S;
          If OpenDialog.Execute then begin
            ProgramEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
            If Trim(NameEdit.Text)='' then NameEdit.Text:=ChangeFileExt(ExtractFileName(ProgramEdit.Text),'');
          end;
        end;
  end;
end;

end.
