unit ProfileMountEditorCDDriveFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit, Spin;

type
  TProfileMountEditorCDDriveFrame = class(TFrame, TProfileMountEditorFrame)
    CDROMEdit: TLabeledEdit;
    CDROMLabelEdit: TLabeledEdit;
    CDROMButton: TSpeedButton;
    CDROMDriveAccessComboBox: TComboBox;
    CDROMDriveAccessLabel: TLabel;
    CDROMDriveLetterLabel: TLabel;
    CDROMDriveLetterComboBox: TComboBox;
    CDROMDriveLetterWarningLabel: TLabel;
    CDMountTypeComboBox: TComboBox;
    CDDriveNumberEdit: TSpinEdit;
    CDDriveNumberLabel: TLabel;
    CDMountTypeLabel: TLabel;
    CDLabelEdit: TLabeledEdit;
    procedure CDROMButtonClick(Sender: TObject);
    procedure CDROMDriveLetterComboBoxChange(Sender: TObject);
    procedure CDMountTypeComboBoxChange(Sender: TObject);
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

uses Math, LanguageSetupUnit, CommonTools, PrgSetupUnit, IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorCDDriveFrame }

function TProfileMountEditorCDDriveFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S,T : String;
    I : Integer;
    OK : Boolean;
begin
  InfoData:=AInfoData;

  CDMountTypeLabel.Caption:=LanguageSetup.ProfileMountingCDDriveType;
  CDMountTypeComboBox.Items.Clear;
  CDMountTypeComboBox.Items.Add(LanguageSetup.ProfileMountingCDDriveTypeFixedPath);
  CDMountTypeComboBox.Items.Add(LanguageSetup.ProfileMountingCDDriveTypeNumber);
  CDMountTypeComboBox.Items.Add(LanguageSetup.ProfileMountingCDDriveTypeAsk);
  CDMountTypeComboBox.Items.Add(LanguageSetup.ProfileMountingCDDriveTypeLabel);
  CDMountTypeComboBox.Items.Add(LanguageSetup.ProfileMountingCDDriveTypeFile);
  CDMountTypeComboBox.Items.Add(LanguageSetup.ProfileMountingCDDriveTypeFolder);
  CDMountTypeComboBox.ItemIndex:=0;
  CDDriveNumberLabel.Caption:=LanguageSetup.ProfileMountingCDDriveTypeNumberLabel;
  CDDriveNumberLabel.Left:=CDDriveNumberEdit.Left;
  CDROMEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  CDROMLabelEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingLabel;

  CDROMDriveAccessLabel.Caption:=LanguageSetup.ProfileMountingCDROMAccess;
  while CDROMDriveAccessComboBox.Items.Count<6 do CDROMDriveAccessComboBox.Items.Add('');
  CDROMDriveAccessComboBox.Items[0]:=LanguageSetup.ProfileMountingCDROMAccessNormal;
  CDROMDriveAccessComboBox.Items[1]:=LanguageSetup.ProfileMountingCDROMAccessIOCTL;
  CDROMDriveAccessComboBox.Items[2]:=LanguageSetup.ProfileMountingCDROMAccessIOCTL_DX;
  CDROMDriveAccessComboBox.Items[3]:=LanguageSetup.ProfileMountingCDROMAccessIOCTL_DIO;
  CDROMDriveAccessComboBox.Items[4]:=LanguageSetup.ProfileMountingCDROMAccessIOCTL_MCI;
  CDROMDriveAccessComboBox.Items[5]:=LanguageSetup.ProfileMountingCDROMAccessNOIOCTL;
  CDROMDriveAccessComboBox.ItemIndex:=0;

  UserIconLoader.DialogImage(DI_SelectFolder,CDROMButton);

  CDROMDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  CDROMDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  CDROMButton.Hint:=LanguageSetup.ChooseFolder;

  CDROMDriveLetterComboBox.Items.BeginUpdate;
  try
    CDROMDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do CDROMDriveLetterComboBox.Items.Add(C);
    CDROMDriveLetterComboBox.ItemIndex:=3;
  finally
    CDROMDriveLetterComboBox.Items.EndUpdate;
  end;

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='CDROM' then begin
      result:=True;
      {RealFolder;CDROM;Letter;IO;Label; (ASK /  NUMBER:x /  LABEL:x / FILE:x / FOLDER:x)}

      OK:=False;
      S:=Trim(ExtUpperCase(St[0]));

      If S='ASK' then begin
        CDMountTypeComboBox.ItemIndex:=2;
        OK:=True;
      end;

      If Pos(':',S)<>0 then begin
        S:=Trim(Copy(S,1,Pos(':',S)-1));
        T:=St[0]; T:=Trim(Copy(T,Pos(':',T)+1,MaxInt));

        If S='NUMBER' then begin
          If TryStrToInt(T,I) then begin
            CDDriveNumberEdit.Value:=Max(1,Min(10,I));
            CDMountTypeComboBox.ItemIndex:=1;
            OK:=True;
          end;
        end;
        If S='LABEL' then begin
          CDLabelEdit.Text:=T;
          CDMountTypeComboBox.ItemIndex:=3;
          OK:=True;
        end;
        If S='FILE' then begin
          CDLabelEdit.Text:=T;
          CDMountTypeComboBox.ItemIndex:=4;
          OK:=True;
        end;
        If S='FOLDER' then begin
          CDLabelEdit.Text:=T;
          CDMountTypeComboBox.ItemIndex:=5;
          OK:=True;
        end;
      end;
      If not OK then begin
        CDMountTypeComboBox.ItemIndex:=0;
        CDROMEdit.Text:=St[0];
      end;
      CDMountTypeComboBoxChange(self);

      If St.Count>=3 then begin
        I:=CDROMDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        CDROMDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=4 then begin
        S:=Trim(ExtUpperCase(St[3]));
        CDROMDriveAccessComboBox.ItemIndex:=0;
        If S='TRUE' then CDROMDriveAccessComboBox.ItemIndex:=1;
        If S='DX' then CDROMDriveAccessComboBox.ItemIndex:=2;
        If S='DIO' then CDROMDriveAccessComboBox.ItemIndex:=3;
        If S='MCI' then CDROMDriveAccessComboBox.ItemIndex:=4;
        If S='NOIOCTL' then CDROMDriveAccessComboBox.ItemIndex:=5;
      end;
      If St.Count>=5 then begin
        CDROMLabelEdit.Text:=St[4];
      end;
    end else begin
      result:=False;
      For I:=2 to CDROMDriveLetterComboBox.Items.Count-1 do begin
        If Pos(CDROMDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin CDROMDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  CDROMDriveLetterComboBoxChange(self);
end;

procedure TProfileMountEditorCDDriveFrame.ShowFrame;
begin
  CDMountTypeComboBoxChange(self);
end;

function TProfileMountEditorCDDriveFrame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

function TProfileMountEditorCDDriveFrame.Done: String;
Var S,T : String;
begin
  {RealFolder;CDROM;Letter;IO;Label; (ASK /  NUMBER:x /  LABEL:x / FILE:x / FOLDER:x)}
  Case CDROMDriveAccessComboBox.ItemIndex of
    1 : S:='true';
    2 : S:='dx';
    3 : S:='dio';
    4 : S:='mci';
    5 : S:='NoIOCTL';
    else S:='false';
  end;
  Case CDMountTypeComboBox.ItemIndex of
    0 : T:=MakeRelPath(CDROMEdit.Text,PrgSetup.BaseDir);
    1 : T:='NUMBER:'+IntToStr(CDDriveNumberEdit.Value);
    2 : T:='ASK';
    3 : T:='LABEL:'+CDLabelEdit.Text;
    4 : T:='FILE:'+CDLabelEdit.Text;
    5 : T:='FOLDER:'+CDLabelEdit.Text;
    else T:=CDROMEdit.Text;
  End;
  result:=StringReplace(T,';','<semicolon>',[rfReplaceAll])+';CDROM;'+CDROMDriveLetterComboBox.Text+';'+S+';'+CDROMLabelEdit.Text+';';
end;

function TProfileMountEditorCDDriveFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingCDROMSheet;
end;

procedure TProfileMountEditorCDDriveFrame.CDMountTypeComboBoxChange(Sender: TObject);
begin
  {To avoid problems when frame gets visible}
  CDROMEdit.Visible:=True;
  CDROMButton.Visible:=True;
  CDDriveNumberEdit.Visible:=True;
  CDDriveNumberLabel.Visible:=True;
  CDLabelEdit.Visible:=True;

  CDROMEdit.Visible:=(CDMountTypeComboBox.ItemIndex=0);
  CDROMButton.Visible:=(CDMountTypeComboBox.ItemIndex=0);
  CDDriveNumberEdit.Visible:=(CDMountTypeComboBox.ItemIndex=1);
  CDDriveNumberLabel.Visible:=(CDMountTypeComboBox.ItemIndex=1);
  CDLabelEdit.Visible:=(CDMountTypeComboBox.ItemIndex>=3);

  Case CDMountTypeComboBox.ItemIndex of
    3 : CDLabelEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingCDDriveTypeLabelLabel;
    4 : CDLabelEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingCDDriveTypeFileLabel;
    5 : CDLabelEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingCDDriveTypeFolderLabel;
  End;
end;

procedure TProfileMountEditorCDDriveFrame.CDROMButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(CDROMEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=CDROMEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  CDROMEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorCDDriveFrame.CDROMDriveLetterComboBoxChange(Sender: TObject);
begin
  CDROMDriveLetterWarningLabel.Visible:=(CDROMDriveLetterComboBox.ItemIndex>=0) and (Pos(CDROMDriveLetterComboBox.Items[CDROMDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

end.
