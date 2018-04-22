unit SmallWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSmallWaitForm = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  SmallWaitForm: TSmallWaitForm = nil;

Procedure LoadAndShowSmallWaitForm(Info : String ='');
Procedure FreeSmallWaitForm;

implementation

uses VistaToolsUnit, CommonTools, LanguageSetupUnit;

{$R *.dfm}

procedure TSmallWaitForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
end;

Procedure LoadAndShowSmallWaitForm(Info : String);
begin
  If Application.MainForm.WindowState=wsMinimized then exit;
  SmallWaitForm:=TSmallWaitForm.Create(Application.MainForm);
  If Trim(Info)='' then Info:=LanguageSetup.ProgressFormCaption;
  SmallWaitForm.Label1.Caption:=Info;
  SmallWaitForm.Show;
  SmallWaitForm.BringToFront;
  Application.ProcessMessages;
  SmallWaitForm.Repaint;
end;

Procedure FreeSmallWaitForm;
begin
  If Assigned(SmallWaitForm) then FreeAndNil(SmallWaitForm);
end;

end.
