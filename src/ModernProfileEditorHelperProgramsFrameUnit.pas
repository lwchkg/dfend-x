unit ModernProfileEditorHelperProgramsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit, Buttons,
  Grids;

type
  TModernProfileEditorHelperProgramsFrame = class(TFrame, IModernProfileEditorFrame)
    Command1CheckBox: TCheckBox;
    Command2CheckBox: TCheckBox;
    RunMinimized1CheckBox: TCheckBox;
    Wait1CheckBox: TCheckBox;
    RunMinimized2CheckBox: TCheckBox;
    InOrder1CheckBox: TCheckBox;
    InOrder2CheckBox: TCheckBox;
    Command1Tab: TStringGrid;
    AddButton1: TSpeedButton;
    DelButton1: TSpeedButton;
    Command2Tab: TStringGrid;
    DelButton2: TSpeedButton;
    AddButton2: TSpeedButton;
    procedure ButtonWork(Sender: TObject);
    procedure Command1TabSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure Command2TabSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure FrameResize(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, HelpConsts, CommonTools, IconLoaderUnit;

{$R *.dfm}

{ TModernProfileEditorHelperProgramsFrame }

procedure TModernProfileEditorHelperProgramsFrame.InitGUI(var InitData: TModernProfileEditorInitData);
begin
  InitData.AllowDefaultValueReset:=False;

  NoFlicker(Command1CheckBox);
  NoFlicker(Command1Tab);
  NoFlicker(RunMinimized1CheckBox);
  NoFlicker(Wait1CheckBox);
  NoFlicker(Command2CheckBox);
  NoFlicker(Command2Tab);
  NoFlicker(RunMinimized2CheckBox);

  Command1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunBefore;
  Command1Tab.Cells[0,0]:=LanguageSetup.ProfileEditorHelperProgramsRunBeforeEditLabel;
  RunMinimized1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunMinimized;
  InOrder1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsInOrder;
  Wait1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunWait;
  Command2CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunAfter;
  Command2Tab.Cells[0,0]:=LanguageSetup.ProfileEditorHelperProgramsRunAfterEditLabel;
  RunMinimized2CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunMinimized;
  InOrder2CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsInOrder;

  AddButton1.Hint:=RemoveUnderline(LanguageSetup.Add);
  DelButton1.Hint:=RemoveUnderline(LanguageSetup.Del);
  AddButton2.Hint:=RemoveUnderline(LanguageSetup.Add);
  DelButton2.Hint:=RemoveUnderline(LanguageSetup.Del);

  UserIconLoader.DialogImage(DI_Add,AddButton1);
  UserIconLoader.DialogImage(DI_Delete,DelButton1);
  UserIconLoader.DialogImage(DI_Add,AddButton2);
  UserIconLoader.DialogImage(DI_Delete,DelButton2);

  FrameResize(self);

  HelpContext:=ID_ProfileEditHelperPrograms;
end;

procedure TModernProfileEditorHelperProgramsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
    St : TStringList;
    I,J : Integer;
    B : Boolean;
begin
  B:=False; J:=0;
  St:=StringToStringList(Trim(Game.CommandBeforeExecution));
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]); If S='' then continue;
      If J=0 then Command1Tab.Cells[0,1]:=S else begin
        Command1Tab.RowCount:=J+2; Command1Tab.Cells[0,J+1]:=S;
      end;
      B:=True; inc(J);
    end;
  finally
    St.Free;
  end;
  Command1CheckBox.Checked:=B;

  RunMinimized1CheckBox.Checked:=Game.CommandBeforeExecutionMinimized;
  InOrder1CheckBox.Checked:=not Game.CommandBeforeExecutionParallel;
  Wait1CheckBox.Checked:=Game.CommandBeforeExecutionWait;

  B:=False; J:=0;
  St:=StringToStringList(Trim(Game.CommandAfterExecution));
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]); If S='' then continue;
      If J=0 then Command2Tab.Cells[0,1]:=S else begin
        Command2Tab.RowCount:=J+2; Command2Tab.Cells[0,J+1]:=S;
      end;
      B:=True; inc(J);
    end;
  finally
    St.Free;
  end;
  Command2CheckBox.Checked:=B;

  RunMinimized2CheckBox.Checked:=Game.CommandAfterExecutionMinimized;
  InOrder2CheckBox.Checked:=not Game.CommandAfterExecutionParallel;
end;

procedure TModernProfileEditorHelperProgramsFrame.FrameResize(Sender: TObject);
begin
  Command1Tab.ColWidths[0]:=Command1Tab.ClientWidth-10;
  Command2Tab.ColWidths[0]:=Command2Tab.ClientWidth-10;
end;

procedure TModernProfileEditorHelperProgramsFrame.Command1TabSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  Command1CheckBox.Checked:=True;
end;

procedure TModernProfileEditorHelperProgramsFrame.Command2TabSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  Command2CheckBox.Checked:=True;
end;

procedure TModernProfileEditorHelperProgramsFrame.ButtonWork(Sender: TObject);
Var I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          Command1Tab.RowCount:=Command1Tab.RowCount+1;
          Command1Tab.Row:=Command1Tab.RowCount-1;
        end;
    1 : If Command1Tab.RowCount>2 then begin
          If Command1Tab.Row>0 then begin
            For I:=Command1Tab.Row+1 to Command1Tab.RowCount-1 do Command1Tab.Cells[0,I-1]:=Command1Tab.Cells[0,I];
            Command1Tab.RowCount:=Command1Tab.RowCount-1;
          end else begin
            Command1Tab.RowCount:=Command1Tab.RowCount-1;
            Command1Tab.Row:=Command1Tab.RowCount-1;
          end;
        end else Command1Tab.Cells[0,1]:='';
    2 : begin
          Command2Tab.RowCount:=Command2Tab.RowCount+1;
          Command2Tab.Row:=Command2Tab.RowCount-1;
        end;
    3 : If Command2Tab.RowCount>2 then begin
          If Command1Tab.Row>0 then begin
            For I:=Command2Tab.Row+1 to Command2Tab.RowCount-1 do Command2Tab.Cells[0,I-1]:=Command2Tab.Cells[0,I];
            Command2Tab.RowCount:=Command2Tab.RowCount-1;
          end else begin
            Command1Tab.RowCount:=Command1Tab.RowCount-1;
            Command1Tab.Row:=Command1Tab.RowCount-1;
          end;
        end else Command2Tab.Cells[0,1]:='';
  end;
end;

procedure TModernProfileEditorHelperProgramsFrame.GetGame(const Game: TGame);
Var St : TStringList;
    I : Integer;
begin
  If not Command1CheckBox.Checked then Game.CommandBeforeExecution:='' else begin
    St:=TStringList.Create;
    try
      For I:=1 to Command1Tab.RowCount-1 do If Trim(Command1Tab.Cells[0,I])<>'' then St.Add(Trim(Command1Tab.Cells[0,I]));
      Game.CommandBeforeExecution:=StringListToString(St);
    finally
      St.Free;
    end;
  end;
  Game.CommandBeforeExecutionMinimized:=RunMinimized1CheckBox.Checked;
  Game.CommandBeforeExecutionWait:=Wait1CheckBox.Checked;
  Game.CommandBeforeExecutionParallel:=not InOrder1CheckBox.Checked;

  If not Command2CheckBox.Checked then Game.CommandAfterExecution:='' else begin
    St:=TStringList.Create;
    try
      For I:=1 to Command2Tab.RowCount-1 do If Trim(Command2Tab.Cells[0,I])<>'' then St.Add(Trim(Command2Tab.Cells[0,I]));
      Game.CommandAfterExecution:=StringListToString(St);
    finally
      St.Free;
    end;
  end;
  Game.CommandAfterExecutionMinimized:=RunMinimized2CheckBox.Checked;
  Game.CommandAfterExecutionParallel:=not InOrder2CheckBox.Checked;
end;

end.
