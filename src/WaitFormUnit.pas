unit WaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TWaitForm = class(TForm)
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FCaption : String;
  public
    { Public-Deklarationen }
    Constructor CreateWaitForm(const AOwner : TComponent; const ACaption : String; const AMaxPos : Integer);
    Procedure Step(const Pos : Integer);
    Procedure StepIt;
  end;

var
  WaitForm: TWaitForm = nil;

Function CreateWaitForm(const AOwner : TComponent; const ACaption : String; const AMaxPos : Integer) : TWaitForm;

Procedure InitProgressWindow(const AOwner : TComponent; const Steps : Integer);
Procedure StepProgressWindow;
Procedure DoneProgressWindow;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

{ TWaitForm }

constructor TWaitForm.CreateWaitForm(const AOwner: TComponent; const ACaption : String; const AMaxPos: Integer);
begin
  If AOwner=nil then begin
    If Application.MainForm<>nil then inherited Create(Application.MainForm) else inherited Create(nil);
  end else begin
    inherited Create(AOwner);
  end;

  FCaption:=ACaption;
  Caption:=ACaption;

  ProgressBar.Position:=0;
  ProgressBar.Max:=AMaxPos;

  DoubleBuffered:=True;
  ProgressBar.DoubleBuffered:=True;
end;

procedure TWaitForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
end;

procedure TWaitForm.Step(const Pos: Integer);
begin
  ProgressBar.Position:=Pos;
  Caption:=FCaption+' ['+IntToStr(100*Pos div ProgressBar.Max)+'%]';
  ProgressBar.Repaint;
  Repaint;
  Application.ProcessMessages;
end;

procedure TWaitForm.StepIt;
begin
  Step(ProgressBar.Position+1);
end;

{ global }

Function CreateWaitForm(const AOwner : TComponent; const ACaption : String; const AMaxPos : Integer) : TWaitForm;
begin
  result:=TWaitForm.CreateWaitForm(AOwner,ACaption,AMaxPos);
  result.Show;
  result.Invalidate;
  result.Paint;
  Application.ProcessMessages;
end;

Procedure InitProgressWindow(const AOwner : TComponent; const Steps : Integer);
begin
  If Assigned(WaitForm) then FreeAndNil(WaitForm);
  WaitForm:=CreateWaitForm(AOwner,LanguageSetup.ProgressFormCaption,Steps);
  WaitForm.BringToFront;
  Application.ProcessMessages;
end;

Procedure StepProgressWindow;
begin
  If Assigned(WaitForm) then WaitForm.StepIt;
end;

Procedure DoneProgressWindow;
begin
  If Assigned(WaitForm) then FreeAndNil(WaitForm);
end;

end.
