unit ExtraExeEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ValEdit;

type
  TExtraExeEditForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    InfoLabel: TLabel;
    HelpButton: TBitBtn;
    Tab: TStringGrid;
    SelectButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SelectButtonClick(Sender: TObject);
    procedure TabClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ExeFiles, Parameters : TStringList;
    WindowsMode : Boolean;
    GameExe, SetupExe : String;
  end;

var
  ExtraExeEditForm: TExtraExeEditForm;

Function ShowExtraExeEditDialog(const AOwner : TComponent; const AExeFiles, AParameters : TStringList; const AWindowsMode : Boolean; const AGameExe, AGameSetup : String) : Boolean;

implementation

uses Math, LanguageSetupUnit, CommonTools, VistaToolsUnit, PrgSetupUnit,
     HelpConsts, IconLoaderUnit, GameDBToolsUnit;

{$R *.dfm}

{ TExtraExeEditForm }

procedure TExtraExeEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ExtraExeEditCaption;
  Tab.Cells[0,0]:=LanguageSetup.ExtraExeEditDescription;
  Tab.Cells[1,0]:=LanguageSetup.ExtraExeEditFileName;
  Tab.Cells[2,0]:=LanguageSetup.ExtraExeEditParameters;
  SelectButton.Caption:=LanguageSetup.ExtraExeEditFileNameSelect;
  InfoLabel.Caption:=LanguageSetup.ExtraExeEditInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  Tab.ColWidths[0]:=(Tab.ClientWidth-10)*2 div 7;
  Tab.ColWidths[1]:=(Tab.ClientWidth-10)*4 div 7;
  Tab.ColWidths[2]:=(Tab.ClientWidth-10)*1 div 7;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_SelectFile,SelectButton);

  WindowsMode:=False;
  GameExe:='';
  SetupExe:='';
end;

procedure TExtraExeEditForm.FormShow(Sender: TObject);
Var I,J,K : Integer;
    S : String;
begin
  J:=1;
  For I:=0 to Min(Tab.RowCount-2,ExeFiles.Count-1) do begin
    S:=Trim(ExeFiles[I]);
    If S<>'' then begin
      K:=Pos(';',S);
      If K>0 then begin
         Tab.Cells[0,J]:=Copy(S,1,K-1);
         Tab.Cells[1,J]:=Copy(S,K+1,MaxInt);
         Tab.Cells[2,J]:=Parameters[I];
         inc(J);
       end;
    end;
  end;
end;

procedure TExtraExeEditForm.TabClick(Sender: TObject);
begin
  SelectButton.Enabled:=(Tab.Row>=1);
end;

procedure TExtraExeEditForm.SelectButtonClick(Sender: TObject);
Var S : String;
begin
  if Tab.Row<1 then exit;
  S:=MakeAbsPath(Tab.Cells[1,Tab.Row],PrgSetup.BaseDir);
  If SelectProgramFile(S,GameExe,SetupExe,WindowsMode,-1,self) then Tab.Cells[1,Tab.Row]:=S;
end;

procedure TExtraExeEditForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S,T : String;
begin
  ExeFiles.Clear;
  Parameters.Clear;
  For I:=1 to Tab.RowCount-1 do begin
    S:=Trim(Tab.Cells[0,I]);
    T:=Trim(Tab.Cells[1,I]);
    If (S<>'') and (T<>'') then begin
      ExeFiles.Add(S+';'+T);
      Parameters.Add(Tab.Cells[2,I]);
    end;
  end;
end;

procedure TExtraExeEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileEditProfile);
end;

procedure TExtraExeEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowExtraExeEditDialog(const AOwner : TComponent; const AExeFiles, AParameters : TStringList; const AWindowsMode : Boolean; const AGameExe, AGameSetup : String) : Boolean;
begin
  ExtraExeEditForm:=TExtraExeEditForm.Create(AOwner);
  try
    ExtraExeEditForm.ExeFiles:=AExeFiles;
    ExtraExeEditForm.Parameters:=AParameters;
    ExtraExeEditForm.WindowsMode:=AWindowsMode;
    ExtraExeEditForm.GameExe:=AGameExe;
    ExtraExeEditForm.SetupExe:=AGameSetup;
    result:=(ExtraExeEditForm.ShowModal=mrOK);
  finally
    ExtraExeEditForm.Free;
  end;
end;

end.
