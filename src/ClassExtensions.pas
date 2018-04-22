unit ClassExtensions;
interface

uses Windows, Classes, Messages, ComCtrls, Controls, Forms, Grids, StdCtrls;

Type TTreeViewAcceptingFiles=class(TTreeView)
  private
    procedure WMDropFiles(var Message: TWMDROPFILES); message WM_DROPFILES;
  public
    Procedure ActivateAcceptFiles;
end;

Type TListViewAcceptingFiles=class(TListView)
  private
    procedure WMDropFiles(var Message: TWMDROPFILES); message WM_DROPFILES;
  public
    Procedure ActivateAcceptFiles;
end;

Type TListViewSpecialHint=class(TListView)
  private
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
end;

Type TListViewAcceptingFilesAndSpecialHint=class(TListViewAcceptingFiles)
  private
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
end;

Type TListForCellEvent=Procedure(ACol, ARow: Integer; var UseDropdownListForCell : Boolean) of object;
Type TGetListForCellEvent=Procedure(ACol, ARow: Integer; DropdownListForCell : TStrings) of object;

Type TStringGridEx=class(TStringGrid)
  private
    FOnListForCell : TListForCellEvent;
    FOnGetListForCell : TGetListForCellEvent;
    procedure EditListGetItems(ACol, ARow: Integer; Items: TStrings);
  protected
    function CreateEditor : TInplaceEdit; override;
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; override;
  published
    property OnListForCell : TListForCellEvent read FOnListForCell write FOnListForCell;
    property OnGetListForCell : TGetListForCellEvent read FOnGetListForCell write FOnGetListForCell;
end;

Type TListBoxAcceptingFiles=class(TListBox)
  private
    procedure WMDropFiles(var Message: TWMDROPFILES); message WM_DROPFILES;
  public
    Procedure ActivateAcceptFiles;
end;

Type TWinControlClass=class of TWinControl;
Type TWinControlTypeChangeMethod=(ctcmDangerousMagic, ctcmStoreAndRestore, ctcmCopyProperties);

Function NewWinControlType(const OldControl : TWinControl; const NewControlClass : TWinControlClass; const ChangeMethod : TWinControlTypeChangeMethod) : TWinControl;

implementation

uses SysUtils, TypInfo, ShellAPI, CommonTools, VistaToolsUnit, LanguageSetupUnit;

{ TTreeViewAcceptingFiles }

procedure TTreeViewAcceptingFiles.ActivateAcceptFiles;
begin
  DragAcceptFiles(Handle,True);
end;

procedure TTreeViewAcceptingFiles.WMDropFiles(var Message: TWMDROPFILES);
var FileCount : longint;
    S : String;
    I : Integer;
    St : TStringList;
    P : TPoint;
begin
  FileCount:=DragQueryFile(Message.Drop,$FFFFFFFF,nil,0);
  DragQueryPoint(Message.Drop,P);
  St:=TStringList.Create;
  try
    For I:=0 to FileCount-1 do begin
      SetLength(S,520);
      DragQueryFile(Message.Drop,I,PChar(S),512);
      SetLength(S,StrLen(PChar(S)));
      St.Add(S);
    end;
    If Assigned(OnDragDrop) then OnDragDrop(self,St,P.X,P.Y);
  finally
    St.Free;
  end;
end;

{ TListViewAcceptingFiles }

procedure TListViewAcceptingFiles.ActivateAcceptFiles;
begin
  DragAcceptFiles(Handle,True);
end;

procedure TListViewAcceptingFiles.WMDropFiles(var Message: TWMDROPFILES);
var FileCount : longint;
    S : String;
    I : Integer;
    St : TStringList;
begin
  FileCount:=DragQueryFile(Message.Drop,$FFFFFFFF,nil,0);
  St:=TStringList.Create;
  try
    For I:=0 to FileCount-1 do begin
      SetLength(S,520);
      DragQueryFile(Message.Drop,I,PChar(S),512);
      SetLength(S,StrLen(PChar(S)));
      St.Add(S);
    end;
    If Assigned(OnDragDrop) then OnDragDrop(self,St,-1,-1);
  finally
    St.Free;
  end;
end;

{ TDFRHintWindow }

Type TDFRHintWindow = class(THintWindow)
  protected
    procedure Paint; override;
end;

procedure TDFRHintWindow.Paint;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  inherited Paint;
end;

{ TListViewSpecialHint }

procedure TListViewSpecialHint.CMHintShow(var Message: TCMHintShow);
Var Item : TListItem;
    InfoTip : String;
    ItemRect: TRect;
    P : TPoint;    
begin
  Message.Result:=1;
  Item:=GetItemAt(Message.HintInfo^.CursorPos.X,Message.HintInfo^.CursorPos.Y);
  If (Item=nil) then exit;

  If not Assigned(OnInfoTip) then exit;
  OnInfoTip(self,Item,InfoTip);
  If InfoTip='' then exit;

  ItemRect := Item.DisplayRect(drBounds);
  ItemRect.TopLeft := ClientToScreen(ItemRect.TopLeft);
  ItemRect.BottomRight := ClientToScreen(ItemRect.BottomRight);

  P:=ClientToScreen(Point(Left,Top));

  with Message.HintInfo^ do begin
    CursorRect := ItemRect;
    HintStr:=InfoTip;
    {HintPos.Y := CursorRect.Top + GetSystemMetrics(SM_CYCURSOR);
    HintPos.X := CursorRect.Left + GetSystemMetrics(SM_CXCURSOR);}
    HintPos.X:=P.X+CursorPos.X;
    HintPos.Y:=P.Y+CursorPos.Y+(GetSystemMetrics(SM_CYCURSOR) div 2);

    HintMaxWidth:=Screen.DesktopLeft+Screen.DesktopWidth-HintPos.x;
    HideTimeout:=100000;
    HintWindowClass:=TDFRHintWindow;
  end;
  Message.Result:=0;
end;

{ TListViewAcceptingFilesAndSpecialHint }

procedure TListViewAcceptingFilesAndSpecialHint.CMHintShow(var Message: TCMHintShow);
Var Item : TListItem;
    InfoTip : String;
    ItemRect: TRect;
    P : TPoint;
begin
  Message.Result:=1;
  Item:=GetItemAt(Message.HintInfo^.CursorPos.X,Message.HintInfo^.CursorPos.Y);
  If (Item=nil) then exit;

  If not Assigned(OnInfoTip) then exit;
  OnInfoTip(self,Item,InfoTip);
  If InfoTip='' then exit;

  ItemRect := Item.DisplayRect(drBounds);
  ItemRect.TopLeft := ClientToScreen(ItemRect.TopLeft);
  ItemRect.BottomRight := ClientToScreen(ItemRect.BottomRight);

  P:=ClientToScreen(Point(Left,Top));

  with Message.HintInfo^ do begin
    CursorRect:=ItemRect;
    HintStr:=InfoTip;

    {HintPos.X:=CursorRect.Left+GetSystemMetrics(SM_CXCURSOR);
    HintPos.Y:=CursorRect.Top+GetSystemMetrics(SM_CYCURSOR);
    If HintPos.X<P.X then HintPos.X:=P.X+GetSystemMetrics(SM_CXCURSOR);
    If HintPos.X>P.X+Width then HintPos.X:=P.X+Width-GetSystemMetrics(SM_CXCURSOR);
    If HintPos.Y<P.Y then HintPos.Y:=P.Y+GetSystemMetrics(SM_CYCURSOR);
    If HintPos.Y>P.Y+Height then HintPos.Y:=P.Y+Height-GetSystemMetrics(SM_CYCURSOR);}

    HintPos.X:=P.X+CursorPos.X;
    HintPos.Y:=P.Y+CursorPos.Y+(GetSystemMetrics(SM_CYCURSOR) div 2);

    HintMaxWidth:=Screen.DesktopLeft+Screen.DesktopWidth-HintPos.X;
    HideTimeout:=100000;
    HintWindowClass:=TDFRHintWindow;
  end;

  Message.Result:=0;
end;

{ global }

Procedure ChangeControlClassType(const Control : TWinControl; const NewControlClass : TWinControlClass);
begin
  If Control.InstanceSize<>NewControlClass.InstanceSize then raise Exception.Create(Format('Changing class type: Sizes do not match while changing from %s to %s',[Control.ClassName,NewControlClass.ClassName]));
  If not NewControlClass.InheritsFrom(Control.ClassType) then raise Exception.Create(Format('Changing class type: %s is not a parent class of %s',[Control.ClassName,NewControlClass.ClassName]));
  
  PPointer(Control)^:=Pointer(NewControlClass);
end;

Function NewWinControlTypeStoreAndRestoreControl(const OldControl : TWinControl; const NewControlClass : TWinControlClass) : TWinControl;
Var MSt,MSt2 : TMemoryStream;
    Owner : TComponent;
    S : String;
    T,U : ShortString;
begin
  MSt:=TMemoryStream.Create;
  try
    Owner:=OldControl.Owner;

    MSt.WriteDescendent(OldControl,Owner);

    result:=NewControlClass.Create(OldControl.Owner);
    result.Parent:=OldControl.Parent;

    S:=OldControl.Name;
    T:=OldControl.ClassName;
    OldControl.Free;

    MSt.Position:=0;
    result.Name:=S;

    MSt2:=TMemoryStream.Create;
    try
      MSt2.CopyFrom(MSt,5);
      U:=NewControlClass.ClassName;
      MSt2.WriteBuffer(U,length(U)+1);
      MSt.Seek(1+length(T),soCurrent);
      MSt2.CopyFrom(MSt,MSt.Size-MSt.Position);
      MSt2.Position:=0;

      result:=TWinControl(MSt2.ReadComponent(result));
    finally
      MSt2.Free;
    end;
  finally
    MSt.Free;
  end;
end;

Procedure CopyProperties(const OldControl, NewControl : TWinControl);
const tkCopyProperties=[tkInteger, tkEnumeration, tkFloat, tkString, tkSet, tkClass, tkMethod, tkWString, tkVariant, tkInterface, tkInt64, tkDynArray];
Var Count,I : Integer;
    PropInfos : PPropList;
    S : String;
begin
  Count:=GetPropList(OldControl.ClassInfo,tkCopyProperties,nil);
  GetMem(PropInfos,Count*SizeOf(PPropInfo));
  try
    GetPropList(OldControl.ClassInfo,tkCopyProperties,PropInfos);
    For I:=0 to Count-1 do begin
      S:=PropInfos^[I]^.Name;
      If ExtUpperCase(S)='NAME' then continue;
      If PropInfos^[I]^.SetProc=nil then continue;
      try
        Case PropInfos^[I]^.PropType^.Kind of
          tkInteger     : SetOrdProp(NewControl,S,GetOrdProp(OldControl,S));
          tkEnumeration : SetEnumProp(NewControl,S,GetEnumProp(OldControl,S));
          tkFloat       : SetFloatProp(NewControl,S,GetFloatProp(OldControl,S));
          tkString      : SetStrProp(NewControl,S,GetStrProp(OldControl,S));
          tkSet         : SetSetProp(NewControl,S,GetSetProp(OldControl,S));
          tkClass       : SetObjectProp(NewControl,S,GetObjectProp(OldControl,S));
          tkMethod      : SetMethodProp(NewControl,S,GetMethodProp(OldControl,S));
          tkWString     : SetWideStrProp(NewControl,S,GetWideStrProp(OldControl,S));
          tkVariant     : SetVariantProp(NewControl,S,GetVariantProp(OldControl,S));
          tkInterface   : SetInterfaceProp(NewControl,S,GetInterfaceProp(OldControl,S));
          tkInt64       : SetInt64Prop(NewControl,S,GetInt64Prop(OldControl,S));
          tkDynArray    : SetDynArrayProp(NewControl,S,GetDynArrayProp(OldControl,S));
        end;
      except
      end;
    end;
  finally
    FreeMem(PropInfos);
  end;
end;

Function NewWinControlTypeCopyProperties(const OldControl : TWinControl; const NewControlClass : TWinControlClass) : TWinControl;
Var S : String;
begin
  result:=NewControlClass.Create(OldControl.Owner);
  result.Parent:=OldControl.Parent;
  S:=OldControl.Name;

  CopyProperties(OldControl,result);
    
  OldControl.Free;
  result.Name:=S;
end;

Function NewWinControlType(const OldControl : TWinControl; const NewControlClass : TWinControlClass; const ChangeMethod : TWinControlTypeChangeMethod) : TWinControl; 
begin
  result:=nil;
  Case ChangeMethod of
    ctcmDangerousMagic : begin ChangeControlClassType(OldControl,NewControlClass); result:=OldControl; end;
    ctcmStoreAndRestore : result:=NewWinControlTypeStoreAndRestoreControl(OldControl,NewControlClass);
    ctcmCopyProperties : result:=NewWinControlTypeCopyProperties(OldControl,NewControlClass);
  end;
end;

{ TStringGridEx }

function TStringGridEx.CreateEditor: TInplaceEdit;
begin
  result:=TInplaceEditList.Create(Self);
  TInplaceEditList(result).OnGetPickListitems:=EditListGetItems;
end;

procedure TStringGridEx.EditListGetItems(ACol, ARow: Integer; Items: TStrings);
begin
  If Assigned(FOnGetListForCell) then FOnGetListForCell(ACol,ARow,Items);
end;

function TStringGridEx.GetEditStyle(ACol, ARow: Integer): TEditStyle;
Var B : Boolean;
begin
  B:=False;
  If Assigned(FOnListForCell) then FOnListForCell(ACol,ARow,B);
  If B then result:=esPickList else result:=esSimple;
end;

{ TListBoxAcceptingFiles }

procedure TListBoxAcceptingFiles.ActivateAcceptFiles;
begin
  DragAcceptFiles(Handle,True);
end;

procedure TListBoxAcceptingFiles.WMDropFiles(var Message: TWMDROPFILES);
var FileCount : longint;
    S : String;
    I : Integer;
    St : TStringList;
    P : TPoint;
begin
  FileCount:=DragQueryFile(Message.Drop,$FFFFFFFF,nil,0);
  DragQueryPoint(Message.Drop,P);
  St:=TStringList.Create;
  try
    For I:=0 to FileCount-1 do begin
      SetLength(S,520);
      DragQueryFile(Message.Drop,I,PChar(S),512);
      SetLength(S,StrLen(PChar(S)));
      St.Add(S);
    end;
    If Assigned(OnDragDrop) then OnDragDrop(self,St,P.X,P.Y);
  finally
    St.Free;
  end;
end;

end.
