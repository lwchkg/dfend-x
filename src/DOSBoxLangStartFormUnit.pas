unit DOSBoxLangStartFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TDOSBoxLangStartForm = class(TForm)
    NewFileRadioButton: TRadioButton;
    NewFileLabel: TLabel;
    NewFileComboBox: TComboBox;
    EditFileRadioButton: TRadioButton;
    EditFileComboBox: TComboBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    NewFileEdit: TLabeledEdit;
    HelpButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NewFileEditChange(Sender: TObject);
    procedure EditFileComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    Names, NamesWithEnglish, Files : TStringList;
  public
    { Public-Deklarationen }
    LoadFileName, SaveFileName : String;
  end;

var
  DOSBoxLangStartForm: TDOSBoxLangStartForm;

Function ShowDOSBoxLangStartDialog(const AOwner : TComponent; var LoadFileName, SaveFileName : String) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit,
     PrgSetupUnit, DOSBoxLangTools, PrgConsts, HelpConsts;

{$R *.dfm}

procedure TDOSBoxLangStartForm.FormCreate(Sender: TObject);
begin
  LoadFileName:='';
  SaveFileName:='';
end;

procedure TDOSBoxLangStartForm.FormShow(Sender: TObject);
Var S : String;
    I,J : Integer;
    B : Boolean;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.DOSBoxLangEditor;
  NewFileRadioButton.Caption:=LanguageSetup.DOSBoxLangEditorStartNew;
  NewFileEdit.EditLabel.Caption:=LanguageSetup.DOSBoxLangEditorStartNewName;
  NewFileLabel.Caption:=LanguageSetup.DOSBoxLangEditorStartNewTemplate;
  EditFileRadioButton.Caption:=LanguageSetup.DOSBoxLangEditorStartEdit;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  Names:=TStringList.Create;
  NamesWithEnglish:=TStringList.Create;
  Files:=TStringList.Create;
  GetDOSBoxLangNamesAndFiles(PrgSetup.DOSBoxSettings[0].DOSBoxDir,Names,Files,False);

  For I:=0 to Names.count-1 do Names.Objects[I]:=TObject(I);
  NamesWithEnglish.AddStrings(Names);
  B:=False;
  For I:=0 to NamesWithEnglish.Count-1 do if ExtUpperCase(NamesWithEnglish[I])='ENGLISH' then begin B:=True; break; end;
  if not B then NamesWithEnglish.AddObject('English',TObject(-1));

  Names.Sort;
  NamesWithEnglish.Sort;

  NewFileComboBox.Items.AddStrings(NamesWithEnglish);
  EditFileComboBox.Items.AddStrings(Names);

  If NewFileComboBox.Items.Count=0 then begin
    MessageDlg(LanguageSetup.DOSBoxLangEditorStartNoFiles,mtError,[mbOK],0);
    PostMessage(Handle,WM_CLOSE,0,0);
    exit;
  end;

  S:=ExtUpperCase(ExtractFileName(PrgSetup.DOSBoxSettings[0].DosBoxLanguage));
  J:=-1; for I:=0 to Names.Count-1 do if ExtUpperCase(ExtractFileName(Files[I]))=S then begin J:=I; break; end;
  If J>=0 then begin
    For I:=0 to Names.Count-1 do if Names.Objects[I]=TObject(J) then begin EditFileComboBox.ItemIndex:=I; break; end;
    For I:=0 to NamesWithEnglish.Count-1 do if NamesWithEnglish.Objects[I]=TObject(J) then begin NewFileComboBox.ItemIndex:=I; break; end;
  end else begin
    For I:=0 to NamesWithEnglish.Count-1 do if NamesWithEnglish.Objects[I]=TObject(-1) then begin NewFileComboBox.ItemIndex:=I; break; end;
    EditFileComboBox.ItemIndex:=0;
  end;
end;

procedure TDOSBoxLangStartForm.OKButtonClick(Sender: TObject);
Var S : String;
    I : Integer;
begin
  If NewFileRadioButton.Checked then begin
    I:=Integer(NamesWithEnglish.Objects[NewFileComboBox.ItemIndex]);
    If I>=0 then LoadFileName:=Files[I] else LoadFileName:='';
    S:=RemoveIllegalFileNameChars(Trim(NewFileEdit.Text));
    If S='' then begin
      MessageDlg(LanguageSetup.DOSBoxLangEditorStartNoName,mtError,[mbOK],0);
      ModalResult:=mrNone;
      exit;
    end;
    SaveFileName:=PrgDataDir+LanguageSubDir+'\'+S+'.lng';
  end else begin
    I:=Integer(NamesWithEnglish.Objects[NewFileComboBox.ItemIndex]);
    LoadFileName:=Files[I];
    If (OperationMode=omUserDir) and (Copy(ExtUpperCase(LoadFileName),1,length(PrgDataDir))<>ExtUpperCase(PrgDataDir)) then begin
      SaveFileName:=PrgDataDir+LanguageSubDir+'\'+ExtractFileName(LoadFileName);
    end else begin
      SaveFileName:=LoadFileName;
    end;
  end;
end;

procedure TDOSBoxLangStartForm.FormDestroy(Sender: TObject);
begin
  Names.Free;
  NamesWithEnglish.Free;
  Files.Free;
end;

procedure TDOSBoxLangStartForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasDOSBoxLanguageEditor);
end;

procedure TDOSBoxLangStartForm.NewFileEditChange(Sender: TObject);
begin
  NewFileRadioButton.Checked:=True;
end;

procedure TDOSBoxLangStartForm.EditFileComboBoxChange(Sender: TObject);
begin
  EditFileRadioButton.Checked:=True;
end;

procedure TDOSBoxLangStartForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowDOSBoxLangStartDialog(const AOwner : TComponent; var LoadFileName, SaveFileName : String) : Boolean;
Var DOSBoxLangStartForm : TDOSBoxLangStartForm;
begin
  DOSBoxLangStartForm:=TDOSBoxLangStartForm.Create(AOwner);
  try
    result:=(DOSBoxLangStartForm.ShowModal=mrOK);
    if result then begin
      LoadFileName:=DOSBoxLangStartForm.LoadFileName;
      SaveFileName:=DOSBoxLangStartForm.SaveFileName;
    end;
  finally
    DOSBoxLangStartForm.Free;
  end;
end;

end.
