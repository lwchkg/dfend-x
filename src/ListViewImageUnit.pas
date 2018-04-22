unit ListViewImageUnit;
interface

uses ComCtrls;

Procedure SetListViewImage(const ListView : TListView; const FileName : String);

implementation

uses Windows, Classes, SysUtils, Messages, Controls, CommCtrl;

Type TDummyClass=class
  private
    FListView : TListView;
    FListViewOldWndProc : TWndMethod;
    procedure ListViewWindowProc(var Msg: TMessage);
  public
    Constructor Create(const AListView : TListView);
    Destructor Destroy; override;
    property ListView : TListView read FListView write FListView;
end;

constructor TDummyClass.Create(const AListView: TListView);
begin
  inherited Create;
  FListView:=AListView;
  FListViewOldWndProc:=FListView.WindowProc;
  FListView.WindowProc:=ListViewWindowProc;
end;

destructor TDummyClass.Destroy;
begin
  If FListView<>nil then FListView.WindowProc:=FListViewOldWndProc;
  inherited Destroy;
end;

procedure TDummyClass.ListViewWindowProc(var Msg: TMessage);
begin
  Case Msg.Msg of
    WM_ERASEBKGND: FListView.DefaultHandler(Msg);
    else FListViewOldWndProc(Msg);
  end;
end;

Var DummyClassList : TList=nil;

Procedure ListViewSetImage(const ListView : TListView; const FileName : String);
var LVBkImg: TLVBkImage;
begin
  if (not Assigned(ListView)) or (not ListView.HandleAllocated) then exit;

  if Filename='' then LVBkImg.ulFlags:=LVBKIF_SOURCE_NONE else LVBkImg.ulFlags:=LVBKIF_SOURCE_URL;
  LVBkImg.ulFlags:=LVBkImg.ulFlags or LVBKIF_STYLE_TILE;
  LVBkImg.hbm:=0;
  LVBkImg.pszImage:=PChar(Filename);
  LVBkImg.cchImageMax:=length(Filename);
  LVBkImg.xOffsetPercent:=0;
  LVBkImg.yOffsetPercent:=0;
  ListView_SetBkImage(ListView.Handle, @LVBkImg);
end;

Procedure SetListViewImage(const ListView : TListView; const FileName : String);
Var I,Nr : Integer;
begin
  Nr:=-1;
  For I:=0 to DummyClassList.Count-1 do If TDummyClass(DummyClassList[I]).ListView=ListView then begin Nr:=I; break; end;

  If FileName='' then begin
    If Nr>=0 then begin TDummyClass(DummyClassList[Nr]).Free; DummyClassList.Delete(Nr); end;
    ListViewSetImage(ListView,'');
  end else begin
    If Nr<0 then DummyClassList.Add(TDummyClass.Create(ListView));
    ListViewSetImage(ListView,FileName);
  end;
end;

Procedure FreeDummyClassListWithoutUninit;
Var I : Integer;
begin
  If DummyClassList=nil then exit;
  For I:=0 to DummyClassList.Count-1 do begin
    TDummyClass(DummyClassList[I]).ListView:=nil;
    TDummyClass(DummyClassList[I]).Free;
  end;
  FreeAndNil(DummyClassList);
end;

initialization
  DummyClassList:=TList.Create;
finalization
  FreeDummyClassListWithoutUninit;
end.
