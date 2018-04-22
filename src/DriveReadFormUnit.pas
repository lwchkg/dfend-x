unit DriveReadFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ReadDriveUnit;

type
  TDriveReadForm = class(TForm)
    ProgressBar: TProgressBar;
    StatusBar: TStatusBar;
    AbortButton: TBitBtn;
    procedure AbortButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    Aborted : Boolean;
    procedure ReadProgress(const BytesRead, TotalBytesToRead : Cardinal; var ContinueReading : Boolean);
    Procedure AfterOnShow(var Msg : TMessage); message WM_USER+1;
  public
    { Public-Deklarationen }
    ReadResult : TReadDataResult;
    Drive : Char;
    FileName : String;
    Count : Integer;
    WriteMode : Boolean;
  end;

var
  DriveReadForm: TDriveReadForm;

Function ShowDriveReadDialog(const AOwner : TComponent; const ADrive : Char; const AFileName : String) : TReadDataResult;
Function ShowDriveWriteDialog(const AOwner : TComponent; const ADrive : Char; const AFileName : String) : TReadDataResult;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TDriveReadForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  WriteMode:=False;
  Count:=0;
  Aborted:=False;
  ProgressBar.DoubleBuffered:=True;
  StatusBar.DoubleBuffered:=True;

  AbortButton.Caption:=LanguageSetup.Abort;

  UserIconLoader.DialogImage(DI_Abort,AbortButton);
end;

procedure TDriveReadForm.FormShow(Sender: TObject);
begin
  If WriteMode then begin
    Caption:=LanguageSetup.WriteImageCaptionIMG;
  end else begin
    If GetDriveType(PChar(Drive+':\'))=DRIVE_CDROM
      then Caption:=LanguageSetup.ReadImageCaptionISO
      else Caption:=LanguageSetup.ReadImageCaptionIMG;
  end;

  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TDriveReadForm.AfterOnShow(var Msg: TMessage);
begin
  If WriteMode then begin
    ReadResult:=WriteFloppyData(Drive,FileName,ReadProgress);
  end else begin
    If GetDriveType(PChar(Drive+':\'))=DRIVE_CDROM
      then ReadResult:=ReadCDData(Drive,FileName,ReadProgress)
      else ReadResult:=ReadFloppyData(Drive,FileName,ReadProgress);
  end;
  ModalResult:=mrOK;
  PostMessage(Handle,WM_Close,0,0);
end;

procedure TDriveReadForm.AbortButtonClick(Sender: TObject);
begin
  Aborted:=True;
end;

procedure TDriveReadForm.ReadProgress(const BytesRead, TotalBytesToRead : Cardinal; var ContinueReading : Boolean);
Var S : String;
begin
  inc(Count);
  If Count mod 10 =0 then begin
    If WriteMode then begin
      StatusBar.SimpleText:=Format(LanguageSetup.WriteImageInfo,[IntToStr(BytesRead div 1024),IntToStr(TotalBytesToRead div 1024)]);
    end else begin
      If TotalBytesToRead>0 then S:=Format(' ('+LanguageSetup.ReadImageInfo2+')',[IntToStr(TotalBytesToRead div 1024)]) else S:='';
      StatusBar.SimpleText:=Format(LanguageSetup.ReadImageInfo1,[IntToStr(BytesRead div 1024)])+S;
    end;
  end;
  If TotalBytesToRead>0
    then ProgressBar.Position:=Round(BytesRead/TotalBytesToRead*1000)
    else ProgressBar.Position:=Round(BytesRead/(1440*1024)*1000);
  ProgressBar.Repaint;
  Application.ProcessMessages;
  ContinueReading:=not Aborted;
end;

{ global }

Function ShowDriveReadDialog(const AOwner : TComponent; const ADrive : Char; const AFileName : String) : TReadDataResult;
begin
  DriveReadForm:=TDriveReadForm.Create(AOwner);
  try
    DriveReadForm.Drive:=ADrive;
    DriveReadForm.FileName:=AFileName;
    DriveReadForm.ShowModal;
    result:=DriveReadForm.ReadResult;
  finally
    DriveReadForm.Free;
  end;
end;

Function ShowDriveWriteDialog(const AOwner : TComponent; const ADrive : Char; const AFileName : String) : TReadDataResult;
begin
  DriveReadForm:=TDriveReadForm.Create(AOwner);
  try
    DriveReadForm.WriteMode:=True;
    DriveReadForm.Drive:=ADrive;
    DriveReadForm.FileName:=AFileName;
    DriveReadForm.ShowModal;
    result:=DriveReadForm.ReadResult;
  finally
    DriveReadForm.Free;
  end;
end;

end.
