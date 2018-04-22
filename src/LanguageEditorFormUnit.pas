unit LanguageEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, ComCtrls, Menus;

type
  TLanguageEditorForm = class(TForm)
    Panel1: TPanel;
    CloseButton: TBitBtn;
    SectionComboBox: TComboBox;
    Tab: TStringGrid;
    StatusBar: TStatusBar;
    ShowComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SectionComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TabDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure ShowComboBoxChange(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    DefaultLanguageFile : String;
    LastSection : Integer;
    ViewMode : Integer;
    Procedure LoadSection(const Section : String);
    Procedure SaveSection(const Section : String);
  public
    { Public-Deklarationen }
    LanguageFile : String;
  end;

var
  LanguageEditorForm: TLanguageEditorForm;

Procedure ShowLanguageEditorDialog(const AOwner : TComponent; const ALanguageFile : String);

implementation

uses Math, IniFiles, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, PrgConsts,
     CommonTools, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TLanguageEditorForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(CloseButton);
  NoFlicker(ShowComboBox);
  NoFlicker(SectionComboBox);
  NoFlicker(Tab);

  Caption:=LanguageSetup.LanguageEditorCaption;

  CloseButton.Caption:=LanguageSetup.Close;

  ShowComboBox.OnChange:=nil;
  ShowComboBox.Items.Clear;
  ShowComboBox.Items.Add(RemoveUnderline(LanguageSetup.LanguageEditorShowAll));
  ShowComboBox.Items.Add(RemoveUnderline(LanguageSetup.LanguageEditorShowUntranslatedOnly));
  ViewMode:=Min(1,Max(0,PrgSetup.LanguageEditorViewMode));
  ShowComboBox.ItemIndex:=ViewMode;
  ShowComboBox.OnChange:=ShowComboBoxChange;

  UserIconLoader.DialogImage(DI_Close,CloseButton);

  DefaultLanguageFile:=PrgDir+LanguageSubDir+'\English.ini';
  LastSection:=-1;

  SetComboHint(ShowComboBox);
  SetComboHint(SectionComboBox);
end;

procedure TLanguageEditorForm.FormShow(Sender: TObject);
Var Ini : TIniFile;
    St,St2,St3 : TStringList;
    I : Integer;
begin
  Caption:=Caption+' ['+LanguageFile+']';

  {Init table}
  FormResize(Sender);
  Tab.Cells[0,0]:=LanguageSetup.LanguageEditorIdentifier;
  Tab.Cells[1,0]:=LanguageSetup.LanguageEditorEnglish;
  Tab.Cells[2,0]:=ChangeFileExt(ExtractFileName(LanguageFile),'');

  {Init sections}
  St:=TStringList.Create;
  St2:=TStringList.Create;
  St3:=TStringList.Create;
  try
    Ini:=TIniFile.Create(DefaultLanguageFile);
    try
      St3.Clear; Ini.ReadSections(St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;
    finally
      Ini.Free;
    end;

    Ini:=TIniFile.Create(LanguageFile);
    try
      St3.Clear; Ini.ReadSections(St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;
    finally
      Ini.Free;
    end;

    St.Sort;
    SectionComboBox.Items.AddStrings(St);
  finally
    St.Free;
    St2.Free;
    St3.Free;
  end;

  {Load first section}
  If SectionComboBox.Items.Count>=0 then begin
    SectionComboBox.ItemIndex:=0;
    SectionComboBoxChange(Sender);
  end;
end;

procedure TLanguageEditorForm.FormResize(Sender: TObject);
Var I : Integer;
begin
  I:=Tab.ClientWidth-10;
  Tab.ColWidths[0]:=I*1 div 5;
  Tab.ColWidths[1]:=I*2 div 5;
  Tab.ColWidths[2]:=I*2 div 5;
end;

procedure TLanguageEditorForm.TabDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 if (ARow>0) and (ACol<2) then begin
   Tab.Canvas.Brush.Color:=$F7F7F7;
   Tab.Canvas.FillRect(Rect);
   Tab.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, Tab.Cells[ACol, ARow]);
 end
end;

procedure TLanguageEditorForm.ComboBoxDropDown(Sender: TObject);
begin
  SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TLanguageEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SectionComboBoxChange(Sender);
end;

procedure TLanguageEditorForm.LoadSection(const Section: String);
Var Ini1, Ini2 : TIniFile;
    St,St2,St3 : TStringList;
    I,J,Untranslated : Integer;
    S,T : String;
begin
  Untranslated:=0;
  Ini1:=TIniFile.Create(DefaultLanguageFile); try Ini2:=TIniFile.Create(LanguageFile);
  try
    St:=TStringList.Create;
    St2:=TStringList.Create;
    St3:=TStringList.Create;
    try
      St3.Clear; Ini1.ReadSection(Section,St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;
      St3.Clear; Ini2.ReadSection(Section,St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;

      For I:=0 to St.Count-1 do begin
        S:=Ini1.ReadString(Section,St[I],'');
        If (ExtUpperCase(Section)='AUTHOR') and (ExtUpperCase(St[I])='NAME') then S:=LanguageSetup.NotSet;
        T:=Ini2.ReadString(Section,St[I],S);
        If S=T then inc(Untranslated);
      end;

      If ViewMode=0 then Tab.RowCount:=Max(2,St.Count+1) else Tab.RowCount:=Max(2,Untranslated+1);
      Tab.Cells[0,1]:=''; Tab.Cells[1,1]:=''; Tab.Cells[2,1]:='';
      J:=1;
      For I:=0 to St.Count-1 do begin
        S:=Ini1.ReadString(Section,St[I],'');
        If (ExtUpperCase(Section)='AUTHOR') and (ExtUpperCase(St[I])='NAME') then S:=LanguageSetup.NotSet;
        T:=Ini2.ReadString(Section,St[I],S);
        If (S<>T) and (ViewMode=1) then continue;
        Tab.Cells[0,J]:=St[I]; Tab.Cells[2,J]:=T; Tab.Cells[1,J]:=S; inc(J);
      end;
      Tab.Enabled:=(J>1);
    finally
      St.Free;
      St2.Free;
      St3.Free;
    end;
  finally Ini2.Free; end; finally Ini1.Free; end;

  Case Untranslated of
    0 : StatusBar.SimpleText:=LanguageSetup.LanguageEditorInfoAllTranslated;
    1 : StatusBar.SimpleText:=LanguageSetup.LanguageEditorInfoOneTranslationMissing;
    else StatusBar.SimpleText:=Format(LanguageSetup.LanguageEditorInfoTranslationsMissing,[Untranslated]);
  end;
end;

procedure TLanguageEditorForm.SaveSection(const Section: String);
Var Ini : TIniFile;
    I : Integer;
begin
  Ini:=TIniFile.Create(LanguageFile);
  try
    For I:=1 to Tab.RowCount-1 do If Tab.Cells[0,I]<>'' then
      Ini.WriteString(Section,Tab.Cells[0,I],Tab.Cells[2,I]);
  finally
    Ini.Free;
  end;
end;

procedure TLanguageEditorForm.SectionComboBoxChange(Sender: TObject);
begin
  If LastSection>=0 then SaveSection(SectionComboBox.Items[LastSection]);

  LastSection:=SectionComboBox.ItemIndex;
  LoadSection(SectionComboBox.Items[LastSection]);

  SetComboHint(ShowComboBox);
  SetComboHint(SectionComboBox);
end;

procedure TLanguageEditorForm.ShowComboBoxChange(Sender: TObject);
begin
  ViewMode:=ShowComboBox.ItemIndex;
  SectionComboBoxChange(Sender);
end;

procedure TLanguageEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then Application.HelpCommand(HELP_CONTEXT,ID_ExtrasLanguageEditor);
end;

{ global }

Procedure ShowLanguageEditorDialog(const AOwner : TComponent; const ALanguageFile : String);
begin
  LanguageEditorForm:=TLanguageEditorForm.Create(AOwner);
  try
    LanguageEditorForm.LanguageFile:=ALanguageFile;
    LanguageEditorForm.ShowModal;
  finally
    LanguageEditorForm.Free;
  end;
end;

end.
