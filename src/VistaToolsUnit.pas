unit VistaToolsUnit;
interface

uses Forms, Buttons, Graphics, Controls, ComCtrls;

procedure SetVistaFonts(const Font: TFont); overload;
procedure SetVistaFonts(const AForm: TCustomForm); overload;
procedure SetVistaFonts(const AFrame: TFrame); overload;
procedure SetVistaFonts(const ASpeedButton: TSpeedButton); overload;
procedure SetVistaFonts(const AToolbar: TToolbar); overload;
procedure SetVistaFonts(const AHintWindow: THintWindow); overload;

procedure SetVistaFontsOnly(const Font: TFont); overload;

var IsWindowsVista : Boolean;

Procedure NoFlicker(const AWinControl : TWinControl);

const
  VistaFont = 'Segoe UI';
  XPFont = 'Tahoma';

implementation

uses Windows, SysUtils;

procedure SetVistaFonts(const Font: TFont);
var Size: Integer;
begin
  if not SameText(Font.Name,VistaFont) then begin
    Size:=Font.Size;
    if not SameText(Font.Name,VistaFont) then Inc(Size,1);
    Font.Name:=VistaFont;
    if not SameText(Font.Name,VistaFont) then Font.Name:=XPFont else Font.Size:=Size;
  end;
end;

procedure SetVistaFonts(const AForm: TCustomForm);
begin
  SetVistaFonts(AForm.Font);
end;

procedure SetVistaFonts(const AFrame: TFrame);
begin
  SetVistaFonts(AFrame.Font);
end;

procedure SetVistaFonts(const ASpeedButton: TSpeedButton);
begin
  SetVistaFonts(ASpeedButton.Font);
end;

procedure SetVistaFonts(const AToolbar: TToolbar);
begin
  SetVistaFonts(AToolbar.Font);
end;

procedure SetVistaFonts(const AHintWindow: THintWindow); overload;
begin
  SetVistaFonts(AHintWindow.Font);
end;

procedure SetVistaFontsOnly(const Font: TFont);
begin
  if not SameText(Font.Name,VistaFont) then begin
    Font.Name:=VistaFont;
    if not SameText(Font.Name,VistaFont) then Font.Name:=XPFont;
  end;
end;

function GetIsWindowsVista: Boolean;
var VerInfo: TOSVersioninfo;
begin
  VerInfo.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  Result:=VerInfo.dwMajorVersion>=6;
end;

Procedure NoFlicker(const AWinControl : TWinControl);
begin
  if not IsWindowsVista then exit;
  AWinControl.DoubleBuffered:=True;
  AWinControl.ControlStyle:=AWinControl.ControlStyle+[csOpaque]-[csParentBackground];
end;

initialization
  IsWindowsVista:=GetIsWindowsVista;
end.
