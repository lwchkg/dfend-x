unit DOSBoxOutputTestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, GameDBUnit;

type
  TDOSBoxOutputTestForm = class(TForm)
    TestButton: TBitBtn;
    CloseButton: TBitBtn;
    HelpButton: TBitBtn;
    InfoLabel: TLabel;
    Tab: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Function SingleCheck(const Renderer : String; const Fullscreen : Boolean) : Boolean;
    Procedure CheckRenderer(const Renderer : String; var Window, Fullscreen : Boolean);
  public
    { Public-Deklarationen }
    ConfOpt : TConfOpt;
  end;

var
  DOSBoxOutputTestForm: TDOSBoxOutputTestForm;

Function ShowDOSBoxOutputTestDialog(const AOwner : TComponent; const ConfOpt : TConfOpt) : Boolean;

implementation

uses CommonTools, LanguageSetupUnit, VistaToolsUnit, DOSBoxUnit, MainUnit,
     SmallWaitFormUnit, DOSBoxTempUnit, PrgConsts, IconLoaderUnit, HelpConsts;

{$R *.dfm}

procedure TDOSBoxOutputTestForm.FormShow(Sender: TObject);
Var St : TStringList;
    I : Integer;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.DOSBoxOutputTest;
  InfoLabel.Caption:=LanguageSetup.DOSBoxOutputTestInfo;

  St:=ValueToList(ConfOpt.Render,';,');
  try
    Tab.RowCount:=1+St.Count;
    Tab.Cells[0,0]:=LanguageSetup.GameRender;
    Tab.Cells[1,0]:=LanguageSetup.DOSBoxOutputTestWindow;
    Tab.Cells[2,0]:=LanguageSetup.DOSBoxOutputTestFullscreen;
    For I:=0 to St.Count-1 do begin
      Tab.Cells[0,I+1]:=St[I];
      Tab.Cells[1,I+1]:=LanguageSetup.DOSBoxOutputTestNotChecked;
      Tab.Cells[2,I+1]:=LanguageSetup.DOSBoxOutputTestNotChecked;
    end;
  finally
    St.Free;
  end;
  Tab.ColWidths[0]:=125;
  Tab.ColWidths[1]:=(Tab.ClientWidth-Tab.ColWidths[0]-5) div 2;
  Tab.ColWidths[2]:=(Tab.ClientWidth-Tab.ColWidths[0]-5) div 2;

  TestButton.Caption:=LanguageSetup.DOSBoxOutputTestStart;
  CloseButton.Caption:=LanguageSetup.Close;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,TestButton);
  UserIconLoader.DialogImage(DI_Close,CloseButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

function TDOSBoxOutputTestForm.SingleCheck(const Renderer: String; const Fullscreen: Boolean): Boolean;
Var TempGame : TTempGame;
    Handle : THandle;
    St : TStringList;
begin
  DeleteFile(TempDir+RenderTestTempFile);

  TempGame:=TTempGame.Create;
  try
    TempGame.Game.StartFullscreen:=Fullscreen;
    St:=TStringList.Create;
    try
      St.Add('dir');
      St.Add('dir > C:\'+RenderTestTempFile);
      St.Add('exit');
      TempGame.Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    TempGame.Game.NrOfMounts:=1;
    TempGame.Game.Mount[0]:=TempDir+';Drive;C;false;';
    TempGame.Game.GameExe:='';
    TempGame.Game.CloseDosBoxAfterGameExit:=false;
    TempGame.Game.StoreAllValues;
    Handle:=RunCommandAndGetHandle(TempGame.Game,DFendReloadedMainForm.DeleteOnExit,'',False);
    try
      WaitForSingleObject(Handle,10000);
      result:=(WaitForSingleObject(Handle,0)=WAIT_OBJECT_0);
      if not result then TerminateProcess(Handle,0);
      If result then result:=FileExists(TempDir+RenderTestTempFile);
      if result then result:=(GetFileSize(TempDir+RenderTestTempFile)>0);
      DeleteFile(TempDir+RenderTestTempFile);
    finally
      CloseHandle(Handle);
    end;
  finally
    TempGame.Free;
  end;
end;

Procedure TDOSBoxOutputTestForm.CheckRenderer(const Renderer : String; var Window, Fullscreen : Boolean);
begin
  Window:=SingleCheck(Renderer,false);
  Fullscreen:=SingleCheck(Renderer,true);
end;

procedure TDOSBoxOutputTestForm.TestButtonClick(Sender: TObject);
Var I : Integer;
    B1, B2 : Boolean;
begin
  LoadAndShowSmallWaitForm(LanguageSetup.DOSBoxOutputTestRunning);
  try
    For I:=1 to Tab.RowCount-1 do begin
      CheckRenderer(Tab.Cells[0,I],B1,B2);
      If B1 then Tab.Cells[1,I]:=LanguageSetup.DOSBoxOutputTestSuccess else Tab.Cells[1,I]:=LanguageSetup.DOSBoxOutputTestFailed;
      If B2 then Tab.Cells[2,I]:=LanguageSetup.DOSBoxOutputTestSuccess else Tab.Cells[2,I]:=LanguageSetup.DOSBoxOutputTestFailed;
    end;
  finally
    FreeSmallWaitForm;
  end;
end;

procedure TDOSBoxOutputTestForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_RunDOSBoxOutputTest);
end;

procedure TDOSBoxOutputTestForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{global}

Function ShowDOSBoxOutputTestDialog(const AOwner : TComponent; const ConfOpt : TConfOpt) : Boolean;
begin
  DOSBoxOutputTestForm:=TDOSBoxOutputTestForm.Create(AOwner);
  try
    DOSBoxOutputTestForm.ConfOpt:=ConfOpt;
    result:=(DOSBoxOutputTestForm.ShowModal=mrOK);
  finally
    DOSBoxOutputTestForm.Free;
  end;
end;

end.
