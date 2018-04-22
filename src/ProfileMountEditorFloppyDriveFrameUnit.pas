unit ProfileMountEditorFloppyDriveFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit;

type
  TProfileMountEditorFloppyDriveFrame = class(TFrame, TProfileMountEditorFrame)
    FloppyEdit: TLabeledEdit;
    FloppyButton: TSpeedButton;
    FloppyDriveLetterComboBox: TComboBox;
    FloppyDriveLetterLabel: TLabel;
    FloppyDriveLetterWarningLabel: TLabel;
    procedure FloppyDriveLetterComboBoxChange(Sender: TObject);
    procedure FloppyButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function CheckBeforeDone : Boolean;
    Function Done : String;
    Function GetName : String;
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorFloppyDriveFrame }

function TProfileMountEditorFloppyDriveFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  FloppyEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  FloppyDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  FloppyDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  FloppyButton.Hint:=LanguageSetup.ChooseFolder;

  FloppyDriveLetterComboBox.Items.BeginUpdate;
  try
    FloppyDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do FloppyDriveLetterComboBox.Items.Add(C);
    FloppyDriveLetterComboBox.ItemIndex:=0;
  finally
    FloppyDriveLetterComboBox.Items.EndUpdate;
  end;

  UserIconLoader.DialogImage(DI_SelectFolder,FloppyButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='FLOPPY' then begin
      result:=True;
      {RealFolder;FLOPPY;Letter;False;;}
      FloppyEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=FloppyDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FloppyDriveLetterComboBox.ItemIndex:=I;
      end;
    end else begin
      result:=False;
      For I:=0 to FloppyDriveLetterComboBox.Items.Count-1 do begin
        If Pos(FloppyDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin FloppyDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  FloppyDriveLetterComboBoxChange(self);
end;

procedure TProfileMountEditorFloppyDriveFrame.ShowFrame;
begin
end;

function TProfileMountEditorFloppyDriveFrame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

function TProfileMountEditorFloppyDriveFrame.Done: String;
begin
  {RealFolder;FLOPPY;Letter;False;;}
  result:=StringReplace(MakeRelPath(FloppyEdit.Text,PrgSetup.BaseDir),';','<semicolon>',[rfReplaceAll])+';Floppy;'+FloppyDriveLetterComboBox.Text+';False;;';
end;

function TProfileMountEditorFloppyDriveFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingFloppySheet;
end;

procedure TProfileMountEditorFloppyDriveFrame.FloppyButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(FloppyEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=FloppyEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  FloppyEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorFloppyDriveFrame.FloppyDriveLetterComboBoxChange(Sender: TObject);
begin
  FloppyDriveLetterWarningLabel.Visible:=(FloppyDriveLetterComboBox.ItemIndex>=0) and (Pos(FloppyDriveLetterComboBox.Items[FloppyDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

end.
