unit TextEditPopupUnit;
interface

uses ComCtrls;

Procedure SetRichEditPopup(const Edit : TRichEdit);

implementation

uses Windows, Classes, Controls, Menus, ClipBrd, LanguageSetupUnit, MainUnit,
     IconLoaderUnit;

Type TPopupDummyObject=class
  private
    Procedure PopupOpenWork(Sender : TObject);
    Procedure PopupItemWork(Sender : TObject);
end;

Var PopupDummyObject : TPopupDummyObject;
    PopupImageList : TImageList;

Procedure TPopupDummyObject.PopupOpenWork(Sender : TObject);
Var P : TPopupMenu;
    E : TRichEdit;
begin
  If not (Sender is TPopupMenu) then exit;
  P:=TPopupMenu(Sender);
  E:=TRichEdit(P.Tag);

  P.Items[0].Enabled:=E.CanUndo;
  P.Items[3].Enabled:=Clipboard.HasFormat(CF_TEXT);
  P.Items[4].Enabled:=(E.SelLength>0);
end;

Procedure TPopupDummyObject.PopupItemWork(Sender : TObject);
var M : TMenuItem;
    P : TPopupMenu;
    E : TRichEdit;
begin
  If not (Sender is TMenuItem) then exit;
  M:=TMenuItem(Sender);
  P:=TPopupMenu(M.Tag);
  E:=TRichEdit(P.Tag);
  Case M.MenuIndex of
    0 : E.Undo;
    1 : E.CutToClipboard;
    2 : E.CopyToClipboard;
    3 : E.PasteFromClipboard;
    4 : E.ClearSelection;
    5 : E.SelectAll;
  end;
end;

Procedure AddItem(const PopupMenu : TPopupMenu; const Title : String; const ShortCut : TShortCut; const ImageIndex : Integer);
Var M : TMenuItem;
begin
  M:=TMenuItem.Create(PopupMenu);
  M.Tag:=Integer(PopupMenu);
  M.Caption:=Title;
  M.ShortCut:=ShortCut;
  M.ImageIndex:=ImageIndex;
  M.OnClick:=PopupDummyObject.PopupItemWork;
  PopupMenu.Items.Add(M);
end;

Procedure SetRichEditPopup(const Edit : TRichEdit);
begin
  If Assigned(Edit.PopupMenu) then Edit.PopupMenu.Items.Clear else Edit.PopupMenu:=TPopupMenu.Create(Edit);
  Edit.PopupMenu.Tag:=Integer(Edit);
  Edit.PopupMenu.OnPopup:=PopupDummyObject.PopupOpenWork;
  Edit.PopupMenu.Images:=PopupImageList;

  PopupImageList.Assign(DFendReloadedMainForm.GameNotesImageList);

  UserIconLoader.DialogImage(DI_Undo,PopupImageList,0);
  UserIconLoader.DialogImage(DI_CutToClipboard,PopupImageList,1);
  UserIconLoader.DialogImage(DI_CopyToClipboard,PopupImageList,2);
  UserIconLoader.DialogImage(DI_PasteFromClipboard,PopupImageList,3);

  AddItem(Edit.PopupMenu,LanguageSetup.Undo,ShortCut(Ord('Z'),[ssCtrl]),0);
  AddItem(Edit.PopupMenu,LanguageSetup.Cut,ShortCut(Ord('X'),[ssCtrl]),1);
  AddItem(Edit.PopupMenu,LanguageSetup.Copy,ShortCut(Ord('C'),[ssCtrl]),2);
  AddItem(Edit.PopupMenu,LanguageSetup.Paste,ShortCut(Ord('V'),[ssCtrl]),3);
  AddItem(Edit.PopupMenu,LanguageSetup.Del,ShortCut(VK_Delete,[ssCtrl]),4);
  AddItem(Edit.PopupMenu,LanguageSetup.SelectAll,ShortCut(Ord('A'),[ssCtrl]),5);
end;

initialization
  PopupDummyObject:=TPopupDummyObject.Create;
  PopupImageList:=TImageList.Create(nil);
finalization
  PopupDummyObject.Free;
  PopupImageList.Free;
end.
