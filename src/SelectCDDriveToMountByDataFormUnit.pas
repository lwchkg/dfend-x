unit SelectCDDriveToMountByDataFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

Type TMountByData=(mbLabel,mbFile,mbFolder);

type
  TSelectCDDriveToMountByDataForm = class(TForm)
    InfoLabel: TLabel;
    CancelButton: TBitBtn;
    Timer: TTimer;
    StartLabel1: TLabel;
    StartLabel2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ProfileName : String;
    MountByDataType : TMountByData;
    Data : String;
    LetterToMountAt : String;
    ChosenDrive : String;
  end;

var
  SelectCDDriveToMountByDataForm: TSelectCDDriveToMountByDataForm;

Function ShowSelectCDDriveToMountByDataDialog(const AOwner : TComponent; const MountByDataType : TMountByData; const Data : String; const LetterToMountAt : String; const ProfileName : String; var ChosenDrive : String) : Boolean;
Function CheckDriveData(const MountByDataType : TMountByData; const Data : String) : String;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, SelectCDDriveToMountFormUnit,
     IconLoaderUnit;

{$R *.dfm}

procedure TSelectCDDriveToMountByDataForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.SelectCDDriveCaption;
  StartLabel1.Caption:=LanguageSetup.SelectCDDriveProfileToStart;
  StartLabel2.Caption:=ProfileName;
  StartLabel2.Font.Style:=[fsBold];
  Case MountByDataType of
    mbLabel  : InfoLabel.Caption:=Format(LanguageSetup.SelectCDDriveLabel,[Data,LetterToMountAt]);
    mbFile   : InfoLabel.Caption:=Format(LanguageSetup.SelectCDDriveFile,[Data,LetterToMountAt]);
    mbFolder : InfoLabel.Caption:=Format(LanguageSetup.SelectCDDriveFolder,[Data,LetterToMountAt]);
  End;

  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  Timer.Enabled:=True;
end;

procedure TSelectCDDriveToMountByDataForm.TimerTimer(Sender: TObject);
Var S : String;
begin
  Timer.Enabled:=False;

  S:=CheckDriveData(MountByDataType,Data);
  If S<>'' then begin
    ChosenDrive:=S;
    ModalResult:=mrOK;
    exit;
  end;

  Timer.Enabled:=True;
end;

{ global }

Function ShowSelectCDDriveToMountByDataDialog(const AOwner : TComponent; const MountByDataType : TMountByData; const Data : String; const LetterToMountAt : String; const ProfileName : String; var ChosenDrive : String) : Boolean;
Var S : String;
    LocalSelectCDDriveToMountByDataForm: TSelectCDDriveToMountByDataForm;
begin
  S:=CheckDriveData(MountByDataType,Data);
  result:=(S<>'');
  If result then begin ChosenDrive:=S; exit; end;

  LocalSelectCDDriveToMountByDataForm:=TSelectCDDriveToMountByDataForm.Create(AOwner);
  try
    LocalSelectCDDriveToMountByDataForm.ProfileName:=ProfileName;
    LocalSelectCDDriveToMountByDataForm.MountByDataType:=MountByDataType;
    LocalSelectCDDriveToMountByDataForm.Data:=Data;
    LocalSelectCDDriveToMountByDataForm.LetterToMountAt:=LetterToMountAt;

    ForceForegroundWindow(Application.Handle);
    Application.BringToFront;

    result:=(LocalSelectCDDriveToMountByDataForm.ShowModal=mrOK);
    if result then ChosenDrive:=LocalSelectCDDriveToMountByDataForm.ChosenDrive;
  finally
    LocalSelectCDDriveToMountByDataForm.Free;
  end;
end;

Function CheckDriveData(const MountByDataType : TMountByData; const Data : String) : String;
Var C : Char;
    S : String;
begin
  result:='';

  For C:='A' to 'Z' do If GetDriveType(PChar(C+':\'))=DRIVE_CDROM then begin
    if not GetDriveLabel(C,S) then continue;
    Case MountByDataType of
      mbLabel  : If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(Data)) then begin result:=C; break; end;
      mbFile   : If FileExists(C+':\'+Data) then begin result:=C; break; end;
      mbFolder : If DirectoryExists(C+':\'+Data) then begin result:=C; break; end;
    end;
  end;
end;

end.
