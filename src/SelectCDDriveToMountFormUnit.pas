unit SelectCDDriveToMountFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TSelectCDDriveToMountForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    InfoLabel: TLabel;
    DriveComboBox: TComboBox;
    StartLabel1: TLabel;
    StartLabel2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ProfileName : String;
    AvailableDrives, LetterToMountAt, ChosenDrive : String;
  end;

var
  SelectCDDriveToMountForm: TSelectCDDriveToMountForm;

Function ShowSelectCDDriveToMountDialog(const AOwner : TComponent; const AvailableDrives, LetterToMountAt : String; const ProfileName : String; var ChosenDrive : String) : Boolean;
Function GetDriveLabel(const DriveLetter : String; var DriveLabel : String) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TSelectCDDriveToMountForm.FormShow(Sender: TObject);
Var I : Integer;
    S : String;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.SelectCDDriveCaption;
  StartLabel1.Caption:=LanguageSetup.SelectCDDriveProfileToStart;
  StartLabel2.Caption:=ProfileName;
  StartLabel2.Font.Style:=[fsBold];
  InfoLabel.Caption:=Format(LanguageSetup.SelectCDDriveFreeSelect,[LetterToMountAt]);

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  DriveComboBox.Items.Clear;
  For I:=1 to length(AvailableDrives) do begin
    If GetDriveLabel(AvailableDrives[I],S) then begin
      DriveComboBox.Items.Add(AvailableDrives[I]+':\ ('+S+')');
    end else begin
      DriveComboBox.Items.Add(AvailableDrives[I]+':\');
    end;
  end;
  DriveComboBox.ItemIndex:=0;
end;

procedure TSelectCDDriveToMountForm.OKButtonClick(Sender: TObject);
begin
  ChosenDrive:=Copy(DriveComboBox.Items[DriveComboBox.ItemIndex],1,3);
end;

{ global }

Function ShowSelectCDDriveToMountDialog(const AOwner : TComponent; const AvailableDrives, LetterToMountAt : String; const ProfileName : String; var ChosenDrive : String) : Boolean;
Var LocalSelectCDDriveToMountForm: TSelectCDDriveToMountForm;
begin
  LocalSelectCDDriveToMountForm:=TSelectCDDriveToMountForm.Create(AOwner);
  try
    LocalSelectCDDriveToMountForm.ProfileName:=ProfileName;
    LocalSelectCDDriveToMountForm.AvailableDrives:=AvailableDrives;
    LocalSelectCDDriveToMountForm.LetterToMountAt:=LetterToMountAt;

    ForceForegroundWindow(Application.Handle);
    Application.BringToFront;

    result:=(LocalSelectCDDriveToMountForm.ShowModal=mrOK);
    if result then ChosenDrive:=LocalSelectCDDriveToMountForm.ChosenDrive;
  finally
    LocalSelectCDDriveToMountForm.Free;
  end;
end;

Function GetDriveLabel(const DriveLetter : String; var DriveLabel : String) : Boolean;
Var C1,C2,C3 : Cardinal;
    S1,S2 : String;
begin
  SetLength(S1,512); SetLength(S2,512);
  result:=GetVolumeInformation(PChar(DriveLetter+':\'),@S1[1],510,@C1,C2,C3,@S2[1],510);
  if result then begin
    SetLength(S1,StrLen(PChar(S1)));
    DriveLabel:=S1;
  end;
end;

end.
