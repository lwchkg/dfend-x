unit CheatSearchFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CheatDBSearchUnit, CheatDBUnit;

type
  TCheatSearchForm = class(TForm)
    Notebook: TNotebook;
    SearchStartLabel: TLabel;
    SearchStartRadioButton1: TRadioButton;
    SearchNameEdit: TLabeledEdit;
    SearchStartRadioButton2: TRadioButton;
    SearchNameComboBox: TComboBox;
    NextButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    DoSearchLabel: TLabel;
    ValueTypeRadioButton1: TRadioButton;
    ValueEdit: TLabeledEdit;
    ValueTypeRadioButton2: TRadioButton;
    ValueComboBox: TComboBox;
    FileNameEdit: TLabeledEdit;
    FileNameButton: TSpeedButton;
    ActionLabel: TLabel;
    OpenDialog: TOpenDialog;
    AddressEdit: TLabeledEdit;
    BytesComboBox: TComboBox;
    BytesLabel: TLabel;
    GameNameLabel: TLabel;
    GameNameComboBox: TComboBox;
    DescriptionEdit: TLabeledEdit;
    FileMaskEdit: TLabeledEdit;
    NewValueEdit: TLabeledEdit;
    UseDialogCheckBox: TCheckBox;
    UseDialogEdit: TLabeledEdit;
    SearchNameDeleteButton: TBitBtn;
    SelectActionRadioGroup: TRadioGroup;
    SelectActionLabel: TLabel;
    SelectActionListBox: TListBox;
    LastSavedGameHintLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchNameChange(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchValueChange(Sender: TObject);
    procedure FileNameButtonClick(Sender: TObject);
    procedure UseDialogEditChange(Sender: TObject);
    procedure SearchNameDeleteButtonClick(Sender: TObject);
    procedure BytesComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    SearchFiles, SearchNames : TStringList;
    AddressSearcher : TAddressSearcher;
    ResultAddress,ResultSize : Integer;
    DeleteSearch : Boolean;
    CheatDB : TCheatDB;
    Procedure InitPage(const Nr : Integer);
    Procedure InitGameListAndCheatDB;
    Function ValueCheck : Boolean;
    Procedure RunSearch;
    Procedure StoreActionToDB(const DeleteSearch : Boolean);
  public
    { Public-Deklarationen }
  end;

var
  CheatSearchForm: TCheatSearchForm;

Procedure ShowCheatSearchDialog(const AOwner : TComponent);

implementation

uses CommonTools, VistaToolsUnit, LanguageSetupUnit, IconLoaderUnit, HelpConsts,
     PrgSetupUnit, CheatDBToolsUnit, StatisticsFormUnit;

{$R *.dfm}

procedure TCheatSearchForm.FormCreate(Sender: TObject);
begin
  SearchFiles:=TStringList.Create;
  SearchNames:=TStringList.Create;
  GetAddressSearchFiles(SearchFiles,SearchNames);
  AddressSearcher:=nil;
  CheatDB:=nil;
end;

procedure TCheatSearchForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.SearchAddress;
  SearchStartLabel.Caption:=LanguageSetup.SearchAddressStart;
  SearchStartRadioButton1.Caption:=LanguageSetup.SearchAddressStartNew;
  SearchNameEdit.EditLabel.Caption:=LanguageSetup.SearchAddressStartNewName;
  SearchStartRadioButton2.Caption:=LanguageSetup.SearchAddressStartContinue;

  DoSearchLabel.Caption:=LanguageSetup.SearchAddressData;
  ValueTypeRadioButton1.Caption:=LanguageSetup.SearchAddressDataKnown;
  ValueEdit.EditLabel.Caption:=LanguageSetup.SearchAddressDataKnownValue;
  ValueEdit.Hint:=LanguageSetup.SearchAddressResultNewValueHint;
  ValueTypeRadioButton2.Caption:=LanguageSetup.SearchAddressDataUnknown;
  ValueComboBox.Items.Clear;
  ValueComboBox.Items.Add(LanguageSetup.SearchAddressDataUnknownIncreased);
  ValueComboBox.Items.Add(LanguageSetup.SearchAddressDataUnknownDescreased);
  FileNameEdit.EditLabel.Caption:=LanguageSetup.SearchAddressDataFileName;
  OpenDialog.Filter:=LanguageSetup.SearchAddressDataFileNameFilter;
  OpenDialog.Title:=LanguageSetup.SearchAddressDataFileNameTitle;
  FileNameButton.Hint:=LanguageSetup.ChooseFile;
  ActionLabel.Caption:=LanguageSetup.SearchAddressResult;
  AddressEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultAddress;
  NewValueEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultNewValue;
  NewValueEdit.Hint:=LanguageSetup.SearchAddressResultNewValueHint;
  BytesLabel.Caption:=LanguageSetup.SearchAddressResultBytes;
  GameNameLabel.Caption:=LanguageSetup.SearchAddressResultGameName;
  DescriptionEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultDescription;
  FileMaskEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultFileMask;
  UseDialogCheckBox.Caption:=LanguageSetup.SearchAddressResultUseDialog;
  UseDialogEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultUseDialogPrompt;
  SelectActionLabel.Caption:=LanguageSetup.SearchAddressResultMessageMultipleAddresses;
  SelectActionRadioGroup.Caption:=LanguageSetup.SearchAddressResultMessageMultipleAddressesActions;
  While SelectActionRadioGroup.Items.Count>3 do SelectActionRadioGroup.Items.Delete(0);
  While SelectActionRadioGroup.Items.Count<3 do SelectActionRadioGroup.Items.Add('');
  SelectActionRadioGroup.Items[0]:=LanguageSetup.SearchAddressResultMessageMultipleAddressesAction1;
  SelectActionRadioGroup.Items[1]:=LanguageSetup.SearchAddressResultMessageMultipleAddressesAction2;
  SelectActionRadioGroup.Items[2]:=LanguageSetup.SearchAddressResultMessageMultipleAddressesAction3;
  SelectActionRadioGroup.ItemIndex:=0;
  SearchNameDeleteButton.Caption:=LanguageSetup.SearchAddressStartDeleteButton;
  NextButton.Caption:=LanguageSetup.Next;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  
  UserIconLoader.DialogImage(DI_Next,NextButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Delete,SearchNameDeleteButton);
  UserIconLoader.DialogImage(DI_SelectFile,FileNameButton);

  InitPage(0);
end;

procedure TCheatSearchForm.FormDestroy(Sender: TObject);
begin
  SearchFiles.Free;
  SearchNames.Free;
  If Assigned(AddressSearcher) then AddressSearcher.Free;
  If Assigned(CheatDB) then CheatDB.Free;
end;

Procedure TCheatSearchForm.InitGameListAndCheatDB;
Var I : Integer;
begin
  CheatDB:=SmartLoadCheatsDB;
  GameNameComboBox.Items.BeginUpdate;
  try
    GameNameComboBox.Items.Clear;
    For I:=0 to CheatDB.Count-1 do GameNameComboBox.Items.AddObject(CheatDB[I].Name,CheatDB[I]);
  finally
    GameNameComboBox.Items.EndUpdate;
  end;
  GameNameComboBox.Text:=AddressSearcher.Name;
end;

procedure TCheatSearchForm.InitPage(const Nr: Integer);
Var St : TStringList;
begin
  Notebook.PageIndex:=Nr;
  Case Nr of
    0 : begin {New search / continue search}
          SearchNameComboBox.Items.Clear;
          SearchNameComboBox.Items.AddStrings(SearchNames);
          If SearchNames.Count>0 then begin
            SearchNameComboBox.ItemIndex:=0;
            SearchStartRadioButton2.Checked:=True;
          end else begin
            SearchStartRadioButton2.Enabled:=False;
            SearchNameDeleteButton.Enabled:=False;
            SearchNameComboBox.Enabled:=False;
            SearchStartRadioButton1.Checked:=True;
          end;
        end;
    1 : begin {Select file and value}
          If SearchStartRadioButton2.Checked then begin
            AddressSearcher:=TAddressSearcher.Create;
            AddressSearcher.LoadFromFile(SearchFiles[SearchNameComboBox.ItemIndex]);
            FileNameEdit.Text:=AddressSearcher.LastSavedGameFileName;
            ValueComboBox.ItemIndex:=0;
          end else begin
            ValueComboBox.ItemIndex:=-1;
            ValueComboBox.Enabled:=False;
          end;
          ValueTypeRadioButton1.Checked:=True;
        end;
    2 : begin {Store result to DB}
          InitGameListAndCheatDB;
          with BytesComboBox.Items do begin
            Clear; Add('1');
            If ResultSize>=2 then Add('2');
            If ResultSize=4 then Add('4');
          end;
          BytesComboBox.ItemIndex:=BytesComboBox.Items.Count-1;
          AddressEdit.Text:=IntToStr(ResultAddress)+'d='+IntToHex(ResultAddress,1)+'h';
          AddressEdit.Color:=Color;
          Case ResultSize of
            1 : NewValueEdit.Text:='$FF';
            2 : NewValueEdit.Text:='$FFFF';
            4 : NewValueEdit.Text:='$7EFFFFFF';
          End;
          LastSavedGameHintLabel.Caption:=Format(LanguageSetup.SearchAddressResultFileMaskHint,[ExtractFileName(FileNameEdit.Text)]);
        end;
    3 : begin {Multiple addresses found}
          St:=AddressSearcher.GetList;
          try
            SelectActionListBox.Items.BeginUpdate;
            try
              SelectActionListBox.Items.Clear;
              SelectActionListBox.Items.AddStrings(St);
            finally
              SelectActionListBox.Items.EndUpdate;
            end;
            SelectActionListBox.ItemIndex:=0;
          finally
            St.Free;
          end;
        end;
  end;
end;

procedure TCheatSearchForm.SearchNameChange(Sender: TObject);
begin
  If Sender=SearchNameEdit then SearchStartRadioButton1.Checked:=True;
  If Sender=SearchNameComboBox then SearchStartRadioButton2.Checked:=True;
end;

procedure TCheatSearchForm.SearchNameDeleteButtonClick(Sender: TObject);
begin
  If SearchNameComboBox.ItemIndex<0 then exit;

  ExtDeleteFile(SearchFiles[SearchNameComboBox.ItemIndex],ftTemp);
  SearchFiles.Delete(SearchNameComboBox.ItemIndex);
  SearchNames.Delete(SearchNameComboBox.ItemIndex);

  InitPage(0);
end;

procedure TCheatSearchForm.SearchValueChange(Sender: TObject);
begin
  If Sender=ValueEdit then ValueTypeRadioButton1.Checked:=True;
  If Sender=ValueComboBox then ValueTypeRadioButton2.Checked:=True;
end;

procedure TCheatSearchForm.UseDialogEditChange(Sender: TObject);
begin
  UseDialogCheckBox.Checked:=True;
end;

procedure TCheatSearchForm.BytesComboBoxChange(Sender: TObject);
Var I,J : Integer;
begin
  I:=StrToInt(BytesComboBox.Text);
  If not TryStrToInt(NewValueEdit.Text,J) then exit;
  Case I of
    1 : If J>$FF then NewValueEdit.Text:='$FF';
    2 : If J>$FFFF then NewValueEdit.Text:='$FFFF';
  end;
end;

procedure TCheatSearchForm.FileNameButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(FileNameEdit.Text)<>'' then S:=ExtractFilePath(FileNameEdit.Text) else S:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
  OpenDialog.InitialDir:=S;
  If not OpenDialog.Execute then exit;
  FileNameEdit.Text:=OpenDialog.FileName;
end;

Function TCheatSearchForm.ValueCheck : Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  Case Notebook.PageIndex of
    0 : begin {New search / continue search}
          If SearchStartRadioButton1.Checked and (Trim(SearchNameEdit.Text)='') then begin MessageDlg(LanguageSetup.SearchAddressStartNewNameMessage,mtError,[mbOK],0); exit; end;
        end;
    1 : begin {Select file and value}
          If ValueTypeRadioButton1.Checked and not TryStrToInt(ValueEdit.Text,I) then begin MessageDlg(LanguageSetup.SearchAddressDataKnownValueMessage,mtError,[mbOK],0); exit; end;
          If Trim(FileNameEdit.Text)='' then begin MessageDlg(LanguageSetup.SearchAddressDataFileNameMessage,mtError,[mbOK],0); exit; end;
          S:=MakeAbsPath(FileNameEdit.Text,PrgSetup.BaseDir);
          If not FileExists(S) then begin MessageDlg(Format(LanguageSetup.MessageFileNotFound,[S]),mtError,[mbOK],0); exit; end;
        end;
    2 : begin {Store result to DB}
          If Trim(GameNameComboBox.Text)='' then begin MessageDlg(LanguageSetup.SearchAddressResultGameNameMessage,mtError,[mbOK],0); exit; end;
          If Trim(DescriptionEdit.Text)='' then begin MessageDlg(LanguageSetup.SearchAddressResultDescriptionMessage,mtError,[mbOK],0); exit; end;
          If Trim(NewValueEdit.Text)='' then begin MessageDlg(LanguageSetup.SearchAddressResultNewValueMessage,mtError,[mbOK],0); exit; end;
          If not ExtTryStrToInt(NewValueEdit.Text,I) then begin MessageDlg(LanguageSetup.SearchAddressResultNewValueMessageInvalid,mtError,[mbOK],0); exit; end;
          If Trim(FileMaskEdit.Text)='' then begin MessageDlg(LanguageSetup.SearchAddressResultFileMaskMessage,mtError,[mbOK],0); exit; end;
          If Trim(FileMaskEdit.Text)='*.*' then begin If MessageDlg(LanguageSetup.SearchAddressResultFileMaskMessageAllFiles,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit; end;
        end;
    3 : begin {Multiple addresses found}
        end;
  end;
  result:=True;
end;

procedure TCheatSearchForm.RunSearch;
Var SavedGameFileName : String;
    ValueChangeType : TValueChangeType;
begin
  SavedGameFileName:=MakeAbsPath(FileNameEdit.Text,PrgSetup.BaseDir);

  If not Assigned(AddressSearcher) then begin
    AddressSearcher:=TAddressSearcher.Create;
    AddressSearcher.Name:=SearchNameEdit.Text;
  end;
  If ValueTypeRadioButton1.Checked then begin
    AddressSearcher.SearchAddress(SavedGameFileName,StrToInt(ValueEdit.Text));
  end else begin
    If ValueComboBox.Enabled then begin
      If ValueComboBox.ItemIndex=0 then ValueChangeType:=vctUp else ValueChangeType:=vctDown;
      AddressSearcher.SearchAddressIndirect(SavedGameFileName,ValueChangeType);
    end else begin
      AddressSearcher.LoadSavedGameFile(SavedGameFileName)
    end;
  end;
end;

procedure TCheatSearchForm.StoreActionToDB(const DeleteSearch : Boolean);
Var GameRecord : TCheatGameRecord;
    CheatAction : TCheatAction;
    CheatActionStep : TCheatActionStep;
begin
  If GameNameComboBox.ItemIndex<0 then begin
    GameRecord:=TCheatGameRecord.Create(nil);
    CheatDB.Add(GameRecord);
    GameRecord.Name:=GameNameComboBox.Text;
  end else begin
    GameRecord:=TCheatGameRecord(GameNameComboBox.Items.Objects[GameNameComboBox.ItemIndex]);
  end;

  CheatAction:=TCheatAction.Create(nil);
  GameRecord.Add(CheatAction);
  CheatAction.Name:=DescriptionEdit.Text;
  CheatAction.FileMask:=FileMaskEdit.Text;

  If UseDialogCheckBox.Checked then begin
    CheatActionStep:=TCheatActionStepChangeAddressWithDialog.Create(nil);
    with TCheatActionStepChangeAddressWithDialog(CheatActionStep) do begin
      Addresses:=IntToStr(ResultAddress);
      Bytes:=StrToInt(BytesComboBox.Text);
      DefaultValue:=Trim(NewValueEdit.Text);
      DialogPrompt:=UseDialogEdit.Text;
    end;
  end else begin
    CheatActionStep:=TCheatActionStepChangeAddress.Create(nil);
    with TCheatActionStepChangeAddress(CheatActionStep) do begin
      Addresses:=IntToStr(ResultAddress);
      Bytes:=ResultSize;
      NewValue:=Trim(NewValueEdit.Text);
    end;
  end;
  CheatAction.Add(CheatActionStep);

  SmartSaveCheatsDB(CheatDB,self);
  If DeleteSearch then ExtDeleteFile(AddressSearcher.SearchDataFileName,ftTemp);

  MessageDlg(LanguageSetup.SearchAddressResultSuccess,mtInformation,[mbOK],0);
end;

procedure TCheatSearchForm.NextButtonClick(Sender: TObject);
Var R : TResultStatus;
begin
  if not ValueCheck then exit;

  Case Notebook.PageIndex of
    0 : begin {New search / continue search}
          InitPage(1);
        end;
    1 : begin {Select file and value}
          RunSearch;
          R:=AddressSearcher.GetResult(ResultAddress,ResultSize);
          If (R=rsNoResultsYet) or (R=rsMultipleAddresses) then AddressSearcher.SaveToFile('');
          Case R of
            rsNoResultsYet      : MessageDlg(LanguageSetup.SearchAddressResultMessageStart,mtInformation,[mbOK],0);
            rsMultipleAddresses : InitPage(3);
            rsNoAddress         : begin
                                    MessageDlg(LanguageSetup.SearchAddressResultMessageNotFound,mtInformation,[mbOK],0);
                                    ExtDeleteFile(AddressSearcher.SearchDataFileName,ftTemp);
                                  end;
            rsFound             : begin DeleteSearch:=True; InitPage(2); end;
          End;
          if (R=rsNoResultsYet) or (R=rsNoAddress) then Close;
        end;
    2 : begin {Store result to DB}
          StoreActionToDB(DeleteSearch);
          Close;
        end;
    3 : begin {Multiple addresses found}
          Case SelectActionRadioGroup.ItemIndex of
            0 : begin Close; exit; {Search results already stored in NextButtonClick for page 1} end;
            1 : DeleteSearch:=True;
            2 : DeleteSearch:=False;
          End;
          AddressSearcher.GetResultNr(Integer(SelectActionListBox.Items.Objects[SelectActionListBox.ItemIndex]),ResultAddress,ResultSize);
          InitPage(2);
        end;
  end;
end;

procedure TCheatSearchForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasSearchAddress);
end;

procedure TCheatSearchForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure ShowCheatSearchDialog(const AOwner : TComponent);
begin
  CheatsDBUpdateCheckIfSetup(Application.MainForm);
  CheatSearchForm:=TCheatSearchForm.Create(AOwner);
  try
    CheatSearchForm.ShowModal;
  finally
    CheatSearchForm.Free;
  end;
end;

end.
