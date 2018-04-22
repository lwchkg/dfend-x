unit DOSBoxLangEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TDOSBoxLangEditForm = class(TForm)
    Panel: TPanel;
    LanguageStringLabel: TLabel;
    LanguageStringComboBox: TComboBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Memo: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LanguageStringComboBoxChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private-Deklarationen }
    LastID : Integer;
    Changed : Boolean;
  public
    { Public-Deklarationen }
    LangIDStrings, LangValueStrings : TStringList;
  end;

var
  DOSBoxLangEditForm: TDOSBoxLangEditForm;

Function ShowDOSBoxLangEditDialog(const AOwner : TComponent; const ALoadDOSBoxLangFile, ASaveDOSBoxLangFile : String) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit,
     DOSBoxLangTools;

{$R *.dfm}

procedure TDOSBoxLangEditForm.FormCreate(Sender: TObject);
begin
  LangIDStrings:=TStringList.Create;
  LangValueStrings:=TStringList.Create;
  Changed:=False;
end;

procedure TDOSBoxLangEditForm.FormDestroy(Sender: TObject);
begin
  LangIDStrings.Free;
  LangValueStrings.Free;
end;

procedure TDOSBoxLangEditForm.FormShow(Sender: TObject);
Var I : Integer;
    S : String;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  NoFlicker(LanguageStringComboBox);
  NoFlicker(OKButton);
  NoFlicker(CancelButton);

  Caption:=LanguageSetup.DOSBoxLangEditor;
  LanguageStringLabel.Caption:=LanguageSetup.DOSBoxLangEditorKey;
  OKButton.Caption:=LanguageSetup.DOSBoxLangEditorSave;
  CancelButton.Caption:=LanguageSetup.DOSBoxLangEditorCancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  LastID:=-1;
  with LanguageStringComboBox.Items do begin
    BeginUpdate;
    try
      Clear;
      For I:=0 to LangIDStrings.Count-1 do begin
        S:=LangIDStrings[I]; If Trim(S)='' then continue;
        AddObject(S,TObject(I));
      end;
    finally
      EndUpdate
    end;
  end;

  If LanguageStringComboBox.Items.Count>0 then begin
    LanguageStringComboBox.ItemIndex:=0;
    LanguageStringComboBoxChange(Sender);
  end;
end;

procedure TDOSBoxLangEditForm.LanguageStringComboBoxChange(Sender: TObject);
Var S,T : String;
begin
  If LastID>=0 then begin
    S:=Memo.Text;
    T:=LangValueStrings[Integer(LanguageStringComboBox.Items.Objects[LastID])];
    If Pos(#13#10,T)=0 then S:=Replace(S,#13#10,#13);
    If (S<>'') and (T<>'') and (S[length(S)]=#13) and (T[length(T)]<>#13) then SetLength(S,length(S)-1);
    If (S<>'') and (T<>'') and (S[1]=#13) and (T[1]<>#13) then S:=Copy(S,2,MaxInt);
    If S<>T then begin
      Changed:=True;
      LangValueStrings[Integer(LanguageStringComboBox.Items.Objects[LastID])]:=S;
    end;
  end;

  LastID:=LanguageStringComboBox.ItemIndex;
  If LastID<0 then exit;
  Memo.Text:=LangValueStrings[Integer(LanguageStringComboBox.Items.Objects[LastID])];
end;

procedure TDOSBoxLangEditForm.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : ModalResult:=mrOK;
    1 : ModalResult:=mrCancel;
  End;
end;

procedure TDOSBoxLangEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  LanguageStringComboBoxChange(Sender);

  If Changed and (ModalResult<>mrOK) then begin
    If MessageDlg(LanguageSetup.DOSBoxLangEditorCancelConfirmation,mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
      ModalResult:=mrNone; CanClose:=False;
    end;
  end;
end;

{ global }

Function ShowDOSBoxLangEditDialog(const AOwner : TComponent; const ALoadDOSBoxLangFile, ASaveDOSBoxLangFile : String) : Boolean;
Var DOSBoxLangEditForm : TDOSBoxLangEditForm;
    LangFile : String;
    IsTemp : Boolean;
begin
  result:=False;
  DOSBoxLangEditForm:=TDOSBoxLangEditForm.Create(AOwner);
  try
    If ALoadDOSBoxLangFile='' then begin
      IsTemp:=True;
      LangFile:=GetTempDOSBoxEnglishLangFile;
    end else begin
      IsTemp:=False;
      LangFile:=ALoadDOSBoxLangFile;
    end;
    try
      If not LoadDOSBoxLangFile(LangFile,DOSBoxLangEditForm.LangIDStrings,DOSBoxLangEditForm.LangValueStrings) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[LangFile]),mtError,[mbOK],0);
        exit;
      end;
    finally
      If IsTemp then ExtDeleteFile(LangFile,ftTemp);
    end;
    result:=(DOSBoxLangEditForm.ShowModal=mrOK);
    If result then begin
      If not SaveDOSBoxLangFile(ASaveDOSBoxLangFile,DOSBoxLangEditForm.LangIDStrings,DOSBoxLangEditForm.LangValueStrings) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[ASaveDOSBoxLangFile]),mtError,[mbOK],0);
        result:=False;
      end;
    end;
  finally
    DOSBoxLangEditForm.Free;
  end;
end;

end.
