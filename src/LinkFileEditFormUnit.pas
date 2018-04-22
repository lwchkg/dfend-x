unit LinkFileEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ExtCtrls;

type
  TLinkFileEditForm = class(TForm)
    Tab: TStringGrid;
    TopPanel: TPanel;
    AddButton: TBitBtn;
    DeleteButton: TBitBtn;
    MoveUpButton: TBitBtn;
    MoveDownButton: TBitBtn;
    BottomPanel: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    InfoPanel: TPanel;
    InfoLabel: TLabel;
    ImportButton: TBitBtn;
    ExportButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TabClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    Function GetLinks : TStringList;
  public
    { Public-Deklarationen }
    Names, Links : TStringList;
    AllowLinesAndSubs, FixedNumber : Boolean;
    HelpID : Integer;
  end;

var
  LinkFileEditForm: TLinkFileEditForm;

Function ShowLinkFileEditDialog(const AOwner : TComponent; const ANames, ALinks : TStringList; const AAllowLinesAndSubs, AFixedNumber : Boolean; const AHelpID : Integer) : Boolean;

implementation

uses ShlObj, Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

{ TLinkFileEditForm }

procedure TLinkFileEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  NoFlicker(TopPanel);
  NoFlicker(BottomPanel);
  NoFlicker(InfoPanel);

  Caption:=LanguageSetup.EditLinkCaption;
  AddButton.Caption:=LanguageSetup.Add;
  DeleteButton.Caption:=LanguageSetup.Del;
  MoveUpButton.Caption:=LanguageSetup.MoveUp;
  MoveDownButton.Caption:=LanguageSetup.MoveDown;
  ImportButton.Caption:=LanguageSetup.EditLinkImport;
  ExportButton.Caption:=LanguageSetup.EditLinkExport;
  Tab.Cells[0,0]:=LanguageSetup.EditLinkName;
  Tab.Cells[1,0]:=LanguageSetup.EditLinkLink;
  InfoLabel.Caption:=LanguageSetup.EditLinkInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  OpenDialog.Title:=LanguageSetup.EditLinkImportTitle;
  OpenDialog.Filter:=LanguageSetup.EditLinkImportFilter;
  SaveDialog.Title:=LanguageSetup.EditLinkExportTitle;
  SaveDialog.Filter:=LanguageSetup.EditLinkExportFilter;

  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton);
  UserIconLoader.DialogImage(DI_Up,MoveUpButton);
  UserIconLoader.DialogImage(DI_Down,MoveDownButton);
  UserIconLoader.DialogImage(DI_Import,ImportButton);
  UserIconLoader.DialogImage(DI_Export,ExportButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  FormResize(Sender);
end;

procedure TLinkFileEditForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  If not AllowLinesAndSubs then InfoPanel.Visible:=False;

  Tab.RowCount:=Max(2,Links.Count+1);
  If Links.Count=0 then exit;
  For I:=0 to Names.Count-1 do begin
    Tab.Cells[0,I+1]:=Names[I];
    Tab.Cells[1,I+1]:=Links[I];
  end;
  TabClick(Sender);

  HelpButton.Visible:=(HelpID>=0);
  AddButton.Enabled:=not FixedNumber;
  DeleteButton.Enabled:=not FixedNumber;
end;

procedure TLinkFileEditForm.TabClick(Sender: TObject);
begin
  DeleteButton.Enabled:=(Tab.RowCount>2) and (not FixedNumber);
  MoveUpButton.Enabled:=(Tab.Row>1);
  MoveDownButton.Enabled:=(Tab.Row<Tab.RowCount-1);
end;

procedure TLinkFileEditForm.ButtonWork(Sender: TObject);
Var I,J : Integer;
    S : String;
    St : TStringList;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          Tab.RowCount:=Tab.RowCount+1;
          Tab.Col:=0;
          Tab.Row:=Tab.RowCount-1;
          TabClick(Sender);
        end;
    1 : begin
          For I:=Tab.Row+1 to Tab.RowCount-1 do begin
            Tab.Cells[0,I-1]:=Tab.Cells[0,I];
            Tab.Cells[1,I-1]:=Tab.Cells[1,I];
          end;
          I:=Tab.Row; J:=Tab.Col;
          Tab.RowCount:=Tab.RowCount-1;
          Tab.Row:=Max(1,I-1);
          Tab.Col:=J;
          TabClick(Sender);
          Tab.Repaint;
        end;
    2 : begin
          I:=Tab.Row; J:=Tab.Col;
          S:=Tab.Cells[0,I]; Tab.Cells[0,I]:=Tab.Cells[0,I-1]; Tab.Cells[0,I-1]:=S;
          S:=Tab.Cells[1,I]; Tab.Cells[1,I]:=Tab.Cells[1,I-1]; Tab.Cells[1,I-1]:=S;
          Tab.Row:=I-1;
          Tab.Col:=J;
          TabClick(Sender);
        end;
    3 : begin
          I:=Tab.Row; J:=Tab.Col;
          S:=Tab.Cells[0,I]; Tab.Cells[0,I]:=Tab.Cells[0,I+1]; Tab.Cells[0,I+1]:=S;
          S:=Tab.Cells[1,I]; Tab.Cells[1,I]:=Tab.Cells[1,I+1]; Tab.Cells[1,I+1]:=S;
          Tab.Row:=I+1;
          Tab.Col:=J;
          TabClick(Sender);
        end;
    4 : begin
          OpenDialog.InitialDir:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
          If not OpenDialog.Execute then exit;
          St:=TStringList.Create;
          try
            try St.LoadFromFile(OpenDialog.FileName); except MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0); end;
            If St.Count=0 then exit;
            I:=Tab.RowCount;
            Tab.RowCount:=I+St.Count;
            For J:=0 to St.Count-1 do begin
              S:=Trim(St[J]);
              If (S<>'') and (Pos(';',S)>0) then begin
                Tab.Cells[0,J+I]:=Trim(Copy(S,1,Pos(';',S)-1));;
                Tab.Cells[1,J+I]:=Trim(Copy(S,Pos(';',S)+1,MaxInt));;
              end;
            end;
            TabClick(Sender);
          finally
            St.Free;
          end;
        end;
    5 : begin
          SaveDialog.InitialDir:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
          If not SaveDialog.Execute then exit;
          St:=GetLinks;
          try
            try St.SaveToFile(SaveDialog.FileName); except MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0); end;
          finally
            St.Free;
          end;
        end;
  end;
  Tab.SetFocus;
end;

function TLinkFileEditForm.GetLinks: TStringList;
Var I : Integer;
begin
  result:=TStringList.Create;

  For I:=1 to Tab.RowCount-1 do If (Trim(Tab.Cells[0,I])='') and (Trim(Tab.Cells[1,I])='')
    then result.Add('')
    else result.Add(Trim(Tab.Cells[0,I])+';'+Trim(Tab.Cells[1,I]));
end;

procedure TLinkFileEditForm.OKButtonClick(Sender: TObject);
Var I : Integer;
begin
  Names.Clear;
  Links.Clear;
  For I:=1 to Tab.RowCount-1 do begin
    Names.Add(Trim(Tab.Cells[0,I]));
    Links.Add(Trim(Tab.Cells[1,I]));
  end;
end;

procedure TLinkFileEditForm.HelpButtonClick(Sender: TObject);
begin
  If HelpID>=0 then Application.HelpCommand(HELP_CONTEXT,HelpID);
end;

procedure TLinkFileEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TLinkFileEditForm.FormResize(Sender: TObject);
begin
  Tab.ColWidths[0]:=(Tab.ClientWidth-5)*2 div 5;
  Tab.ColWidths[1]:=(Tab.ClientWidth-5)*3 div 5;
end;

{ global }

Function ShowLinkFileEditDialog(const AOwner : TComponent; const ANames, ALinks : TStringList; const AAllowLinesAndSubs, AFixedNumber : Boolean; const AHelpID : Integer) : Boolean;
begin
  LinkFileEditForm:=TLinkFileEditForm.Create(AOwner);
  try
    LinkFileEditForm.Names:=ANames;
    LinkFileEditForm.Links:=ALinks;
    LinkFileEditForm.AllowLinesAndSubs:=AAllowLinesAndSubs;
    LinkFileEditForm.FixedNumber:=AFixedNumber;
    LinkFileEditForm.HelpID:=AHelpID;
    result:=(LinkFileEditForm.ShowModal=mrOK);
  finally
    LinkFileEditForm.Free;
  end;
end;

end.
