unit ModernProfileEditorKeyboardFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Buttons, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorKeyboardFrame = class(TFrame, IModernProfileEditorFrame)
    KeyboardLayoutLabel: TLabel;
    KeyboardLayoutComboBox: TComboBox;
    UseScancodesCheckBox: TCheckBox;
    KeyboardLayoutInfoLabel: TLabel;
    NumLockRadioGroup: TRadioGroup;
    CapsLockRadioGroup: TRadioGroup;
    ScrollLockRadioGroup: TRadioGroup;
    KeyLockInfoLabel: TLabel;
    CodepageComboBox: TComboBox;
    CodepageLabel: TLabel;
    DefaultKeyMapperFileRadioButton: TRadioButton;
    CustomKeyMapperFileRadioButton: TRadioButton;
    CustomKeyMapperEdit: TEdit;
    CustomKeyMapperButton: TSpeedButton;
    DosBoxTxtOpenDialog: TOpenDialog;
    procedure CustomKeyMapperButtonClick(Sender: TObject);
    procedure CustomKeyMapperEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    Function CheckIsDOSBOXDefaultMapperFile(const Game: TGame; const MapperFile : String) : Boolean;
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit, HelpConsts,
     IconLoaderUnit, GameDBToolsUnit;

{$R *.dfm}

{ TModernProfileEditorKeyboardFrame }

procedure TModernProfileEditorKeyboardFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(UseScancodesCheckBox);
  NoFlicker(KeyboardLayoutComboBox);
  NoFlicker(CodepageComboBox);
  NoFlicker(NumLockRadioGroup);
  NoFlicker(CapsLockRadioGroup);
  NoFlicker(ScrollLockRadioGroup);
  NoFlicker(DefaultKeyMapperFileRadioButton);
  NoFlicker(CustomKeyMapperFileRadioButton);
  NoFlicker(CustomKeyMapperEdit);

  KeyboardLayoutLabel.Caption:=LanguageSetup.GameKeyboardLayout;
  St:=ValueToList(InitData.GameDB.ConfOpt.KeyboardLayout,';,'); try KeyboardLayoutComboBox.Items.AddStrings(St); finally St.Free; end;
  CodepageLabel.Caption:=LanguageSetup.GameKeyboardCodepage;
  St:=ValueToList(InitData.GameDB.ConfOpt.Codepage,';,'); try CodepageComboBox.Items.AddStrings(St); finally St.Free; end;
  KeyboardLayoutInfoLabel.Caption:=LanguageSetup.GameKeyboardLayoutInfo;
  UseScancodesCheckBox.Caption:=LanguageSetup.GameUseScanCodes;
  with NumLockRadioGroup do begin
    Caption:=LanguageSetup.GameKeyboardNumLock;
    Items[0]:=LanguageSetup.DoNotChange;
    Items[1]:=LanguageSetup.Off;
    Items[2]:=LanguageSetup.On;
  end;
  with CapsLockRadioGroup do begin
    Caption:=LanguageSetup.GameKeyboardCapsLock;
    Items[0]:=LanguageSetup.DoNotChange;
    Items[1]:=LanguageSetup.Off;
    Items[2]:=LanguageSetup.On;
  end;
  with ScrollLockRadioGroup do begin
    Caption:=LanguageSetup.GameKeyboardScrollLock;
    Items[0]:=LanguageSetup.DoNotChange;
    Items[1]:=LanguageSetup.Off;
    Items[2]:=LanguageSetup.On;
  end;
  KeyLockInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    KeyLockInfoLabel.Font.Color:=clGrayText;
  end else begin
    KeyLockInfoLabel.Font.Color:=clRed;
  end;

  DefaultKeyMapperFileRadioButton.Caption:=LanguageSetup.GameKeyMapperDefault;
  CustomKeyMapperFileRadioButton.Caption:=LanguageSetup.GameKeyMapperCustom;
  CustomKeyMapperButton.Hint:=LanguageSetup.ChooseFile;
  UserIconLoader.DialogImage(DI_SelectFile,CustomKeyMapperButton);

  AddDefaultValueHint(KeyboardLayoutComboBox);
  AddDefaultValueHint(CodepageComboBox);

  HelpContext:=ID_ProfileEditKeyboard;
end;

Function TModernProfileEditorKeyboardFrame.CheckIsDOSBOXDefaultMapperFile(const Game: TGame; const MapperFile : String) : Boolean;
Var I : Integer;
    S : String;
begin
  I:=GetDOSBoxNr(Game);
  S:=PrgSetup.DOSBoxSettings[I].DosBoxMapperFile;
  If (Copy(S,1,2)='.\') and (Copy(MapperFile,1,2)<>'.\') then S:=Copy(S,3,MaxInt); 
  result:=ExtUpperCase(MapperFile)=ExtUpperCase(S);
end;

procedure TModernProfileEditorKeyboardFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S,T : String;
    I : Integer;
begin
  If KeyboardLayoutComboBox.Items.Count>0 then begin
    If Trim(ExtUpperCase(KeyboardLayoutComboBox.Items[0]))='DEFAULT'
      then KeyboardLayoutComboBox.ItemIndex:=0
      else KeyboardLayoutComboBox.ItemIndex:=1;
  end;
  If CodepageComboBox.Items.Count>0 then CodepageComboBox.ItemIndex:=0;

  If Game.KeyboardLayout<>'' then S:=Game.KeyboardLayout else S:='default';
  S:=Trim(ExtUpperCase(S));
  For I:=0 to KeyboardLayoutComboBox.Items.Count-1 do begin
    If Trim(ExtUpperCase(KeyboardLayoutComboBox.Items[I]))=S then begin KeyboardLayoutComboBox.ItemIndex:=I; break; end;
    T:=KeyboardLayoutComboBox.Items[I];
    If Pos('(',T)>0 then begin
      T:=Copy(T,Pos('(',T)+1,MaxInt);
      If Pos(')',T)<>0 then T:=Copy(T,1,Pos(')',T)-1);
      If Trim(ExtUpperCase(T))=S then begin KeyboardLayoutComboBox.ItemIndex:=I; break; end;
    end;
  end;

  If Game.Codepage<>'' then S:=Game.Codepage else S:='default';
  S:=Trim(ExtUpperCase(S));
  For I:=0 to CodepageComboBox.Items.Count-1 do begin
    If Trim(ExtUpperCase(CodepageComboBox.Items[I]))=S then begin CodepageComboBox.ItemIndex:=I; break; end;
    T:=CodepageComboBox.Items[I];
    If Pos('(',T)>0 then begin
      If Trim(Copy(T,1,Pos('(',T)-1))=S then begin CodepageComboBox.ItemIndex:=I; break; end;
    end;
  end;

  UseScancodesCheckBox.Checked:=Game.UseScanCodes;

  S:=Trim(ExtUpperCase(Game.NumLockStatus));
  with NumLockRadioGroup do begin
    ItemIndex:=0;
    If (S='OFF') or (S='0') or (S='FALSE') then ItemIndex:=1;
    If (S='ON') or (S='1') or (S='TRUE') then ItemIndex:=2;
  end;

  S:=Trim(ExtUpperCase(Game.CapsLockStatus));
  with CapsLockRadioGroup do begin
    ItemIndex:=0;
    If (S='OFF') or (S='0') or (S='FALSE') then ItemIndex:=1;
    If (S='ON') or (S='1') or (S='TRUE') then ItemIndex:=2;
  end;
  
  S:=Trim(ExtUpperCase(Game.ScrollLockStatus));
  with ScrollLockRadioGroup do begin
    ItemIndex:=0;
    If (S='OFF') or (S='0') or (S='FALSE') then ItemIndex:=1;
    If (S='ON') or (S='1') or (S='TRUE') then ItemIndex:=2;
  end;

  S:=Trim(ExtUpperCase(Game.CustomKeyMappingFile));
  If (S<>'') and (S<>'DEFAULT') then begin
    If CheckIsDOSBOXDefaultMapperFile(Game,S) then S:='';
  end;
  If (S='') or (S='DEFAULT') then begin
    DefaultKeyMapperFileRadioButton.Checked:=True;
  end else begin
    CustomKeyMapperFileRadioButton.Checked:=True;
    CustomKeyMapperEdit.Text:=Game.CustomKeyMappingFile;
  end;
end;

procedure TModernProfileEditorKeyboardFrame.GetGame(const Game: TGame);
begin
  Game.KeyboardLayout:=KeyboardLayoutComboBox.Text;
  Game.Codepage:=CodepageComboBox.Text;
  Game.UseScanCodes:=UseScancodesCheckBox.Checked;
  Case NumLockRadioGroup.ItemIndex of
    0 : Game.NumLockStatus:='';
    1 : Game.NumLockStatus:='off';
    2 : Game.NumLockStatus:='on';
  end;
  Case CapsLockRadioGroup.ItemIndex of
    0 : Game.CapsLockStatus:='';
    1 : Game.CapsLockStatus:='off';
    2 : Game.CapsLockStatus:='on';
  end;
  Case ScrollLockRadioGroup.ItemIndex of
    0 : Game.ScrollLockStatus:='';
    1 : Game.ScrollLockStatus:='off';
    2 : Game.ScrollLockStatus:='on';
  end;
  If DefaultKeyMapperFileRadioButton.Checked
    then Game.CustomKeyMappingFile:='default'
    else Game.CustomKeyMappingFile:=CustomKeyMapperEdit.Text;
end;

procedure TModernProfileEditorKeyboardFrame.CustomKeyMapperButtonClick(Sender: TObject);
begin
  DosBoxTxtOpenDialog.Title:=LanguageSetup.SetupFormDosBoxMapperFileTitle;
  DosBoxTxtOpenDialog.Filter:=LanguageSetup.SetupFormDosBoxMapperFileFilter;
  If Trim(CustomKeyMapperEdit.Text)=''
    then DosBoxTxtOpenDialog.InitialDir:=PrgDataDir
    else DosBoxTxtOpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(CustomKeyMapperEdit.Text,PrgSetup.BaseDir));
  if not DosBoxTxtOpenDialog.Execute then exit;
  CustomKeyMapperEdit.Text:=MakeRelPath(DosBoxTxtOpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TModernProfileEditorKeyboardFrame.CustomKeyMapperEditChange(Sender: TObject);
begin
  CustomKeyMapperFileRadioButton.Checked:=True;
end;

end.
