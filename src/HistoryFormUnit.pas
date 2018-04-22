unit HistoryFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  THistoryForm = class(TForm)
    CloseButton: TBitBtn;
    ClearButton: TBitBtn;
    HelpButton: TBitBtn;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListView: TListView;
    ListView2: TListView;
    procedure FormShow(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    { Private-Deklarationen }
    List1CompareMode, List2CompareMode : Integer;
  public
    { Public-Deklarationen }
  end;

var
  HistoryForm: THistoryForm;

Procedure ShowHistoryDialog(const AOwner : TComponent);

implementation

uses GameDBToolsUnit, LanguageSetupUnit, VistaToolsUnit, CommonTools,
     HelpConsts, PrgSetupUnit, IconLoaderUnit, HistoryUnit;

{$R *.dfm}

procedure THistoryForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(PageControl);
  NoFlicker(ListView);
  NoFlicker(ListView2);

  Caption:=LanguageSetup.HistoryForm;

  TabSheet1.Caption:=LanguageSetup.HistoryForm;
  TabSheet2.Caption:=LanguageSetup.StatisticsCaption;

  CloseButton.Caption:=LanguageSetup.Close;
  ClearButton.Caption:=LanguageSetup.Clear;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_Close,CloseButton);
  UserIconLoader.DialogImage(DI_Clear,ClearButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  History.LoadHistory(ListView);
  History.LoadStatistics(ListView2);

  List1CompareMode:=0; List2CompareMode:=0;
end;

procedure THistoryForm.ClearButtonClick(Sender: TObject);
begin
  History.Clear;
  Close;
end;

procedure THistoryForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasViewHistory);
end;

procedure THistoryForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  If Sender=ListView then begin
    If Abs(List1CompareMode)=Column.Index+1 then List1CompareMode:=-List1CompareMode else List1CompareMode:=Column.Index+1;
    ListView.AlphaSort;
  end;

  If Sender=ListView2 then begin
    If Abs(List2CompareMode)=Column.Index+1 then List2CompareMode:=-List2CompareMode else List2CompareMode:=Column.Index+1;
    ListView2.AlphaSort;
  end;
end;

procedure THistoryForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
Var I : Integer;
    J1,J2 : Integer;
    D1,D2 : TDateTime;
begin
  If Sender=ListView then I:=List1CompareMode else I:=List2CompareMode;
  Compare:=0;
  Case Abs(I) of
    0 : exit;
    1 : begin
          {Name}
          If Item1.Caption>Item2.Caption then Compare:=1*I;
          If Item1.Caption<Item2.Caption then Compare:=-1*I;
        end;
    2 : If Sender=ListView then begin
          {Start date&time}
          D1:=History.StartDateTime[Integer(Item1.Data)];
          D2:=History.StartDateTime[Integer(Item2.Data)];
          If D1>D2 then Compare:=1*I;
          If D1<D2 then Compare:=-1*I;
        end else begin
          {Number of starts}
          J1:=History.StartCount[Integer(Item1.Data)];
          J2:=History.StartCount[Integer(Item2.Data)];
          If J1>J2 then Compare:=1*I;
          If J1<J2 then Compare:=-1*I;
        end;
    3 : If Sender=ListView then begin
          {Number of starts}
          J1:=History.StartCount[Integer(Item1.Data)];
          J2:=History.StartCount[Integer(Item2.Data)];
          If J1>J2 then Compare:=1*I;
          If J1<J2 then Compare:=-1*I;
        end else begin
          {First start}
          D1:=History.StartDateTimeFirst[Integer(Item1.Data)];
          D2:=History.StartDateTimeFirst[Integer(Item2.Data)];
          If D1>D2 then Compare:=1*I;
          If D1<D2 then Compare:=-1*I;
        end;
    4 : If Sender<>ListView then begin
          {Last start}
          D1:=History.StartDateTimeLast[Integer(Item1.Data)];
          D2:=History.StartDateTimeLast[Integer(Item2.Data)];
          If D1>D2 then Compare:=1*I;
          If D1<D2 then Compare:=-1*I;
        end;
  End;
end;

procedure THistoryForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure ShowHistoryDialog(const AOwner : TComponent);
begin
  HistoryForm:=THistoryForm.Create(AOwner);
  try
    HistoryForm.ShowModal;
  finally
    HistoryForm.Free;
  end;
end;

end.
