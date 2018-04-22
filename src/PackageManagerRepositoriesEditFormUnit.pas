unit PackageManagerRepositoriesEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, ImgList, ToolWin, Menus,
  PackageDBUnit;

type
  TPackageManagerRepositoriesEditForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ActivateButton: TToolButton;
    AddButton: TToolButton;
    RemoveButton: TToolButton;
    ImageList: TImageList;
    BottomPanel: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    EditButton: TToolButton;
    PopupMenu: TPopupMenu;
    PopupActivate: TMenuItem;
    N1: TMenuItem;
    PopupAdd: TMenuItem;
    PopupEdit: TMenuItem;
    PopupRemove: TMenuItem;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListView: TListView;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ButtonWork(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControlChange(Sender: TObject);
  private
    { Private-Deklarationen }
    DBDir : String;
    MainPackageList, UserPackageList : TPackageListFile;
    JustLoading : Boolean;
    Procedure LoadLists;
    Function GetDescription(const URL : String) : String;
  public
    { Public-Deklarationen }
  end;

var
  PackageManagerRepositoriesEditForm: TPackageManagerRepositoriesEditForm;

Function ShowPackageManagerRepositoriesEditDialog(const AOwner : TComponent) : Boolean;

implementation

uses Math, CommonTools, PrgSetupUnit, VistaToolsUnit, LanguageSetupUnit,
     IconLoaderUnit, HelpConsts, PrgConsts, PackageDBToolsUnit,
     PackageManagerRepositoriesEditURLFormUnit;

{$R *.dfm}

procedure TPackageManagerRepositoriesEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  JustLoading:=False;

  Caption:=LanguageSetup.RepositoriesEditor;
  ActivateButton.Caption:=LanguageSetup.RepositoriesEditorActivateSource;
  AddButton.Caption:=LanguageSetup.RepositoriesEditorAddSource;
  EditButton.Caption:=LanguageSetup.RepositoriesEditorEditSource;
  RemoveButton.Caption:=LanguageSetup.RepositoriesEditorRemoveSource;
  TabSheet1.Caption:=LanguageSetup.RepositoriesEditorSourceOfficial;
  TabSheet2.Caption:=LanguageSetup.RepositoriesEditorSourceUserDefined;
  PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupActivateSource;
  PopupAdd.Caption:=LanguageSetup.RepositoriesEditorPopupAddSource;
  PopupEdit.Caption:=LanguageSetup.RepositoriesEditorPopupEditSource;
  PopupRemove.Caption:=LanguageSetup.RepositoriesEditorPopupRemoveSource;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_Activate,ImageList,0);
  UserIconLoader.DialogImage(DI_Add,ImageList,1);
  UserIconLoader.DialogImage(DI_Edit,ImageList,2);
  UserIconLoader.DialogImage(DI_Delete,ImageList,3);

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  DBDir:=IncludeTrailingPathDelimiter(PrgDataDir+PackageDBSubFolder);

  MainPackageList:=TPackageListFile.Create(True);
  MainPackageList.LoadFromFile(DBDir+PackageDBMainFile);
  If MainPackageList.Count=0 then MainPackageList.UpdateFromServer(Format(PackageDBMainFileURL,[GetNormalFileVersionAsString]),DBDir+PackageDBTempFile,False,False);

  UserPackageList:=TPackageListFile.Create(False);
  UserPackageList.LoadFromFile(DBDir+PackageDBUserFile);
end;

procedure TPackageManagerRepositoriesEditForm.FormShow(Sender: TObject);
Var C : TListColumn;
begin
  C:=ListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.RepositoriesEditorColumnURL;
  C:=ListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.RepositoriesEditorColumnDescription;

  C:=ListView1.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.RepositoriesEditorColumnURL;
  C:=ListView1.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.RepositoriesEditorColumnDescription;

  LoadLists;
end;

procedure TPackageManagerRepositoriesEditForm.FormDestroy(Sender: TObject);
begin
  JustLoading:=True;
  FreeAndNil(MainPackageList);
  FreeAndNil(UserPackageList);
end;

Function TPackageManagerRepositoriesEditForm.GetDescription(const URL : String) : String;
Var PackageList : TPackageList;
    FileName : String;
begin
  result:='';

  FileName:=DBDir+ExtractFileNameFromURL(URL,'.xml',False);
  If not FileExists(FileName) then begin
    If (ExtUpperCase(Copy(URL,1,4))<>'HTTP') and (FileExists(URL) or FileExists(Replace(URL,'%20',' '))) then begin
      If FileExists(URL) then CopyFile(PChar(URL),PChar(FileName),True) else CopyFile(PChar(Replace(URL,'%20',' ')),PChar(FileName),True);
      If not FileExists(FileName) then exit;
    end else begin
      exit;
    end;
  end;

  PackageList:=TPackageList.Create(URL);
  try
    PackageList.LoadFromFile(FileName);
    result:=PackageList.Name;
  finally
    PackageList.Free;
  end;
end;

procedure TPackageManagerRepositoriesEditForm.LoadLists;
Var I : Integer;
    L : TListItem;
begin
  JustLoading:=True;
  try
    {Official}
    ListView1.Items.BeginUpdate;
    try
      ListView1.Items.Clear;
      For I:=0 to MainPackageList.Count-1 do begin
        L:=ListView1.Items.Add;
        L.Caption:=MainPackageList.URL[I];
        L.Checked:=MainPackageList.Active[I];
        L.SubItems.Add(GetDescription(MainPackageList.URL[I]));
        L.Data:=Pointer(I);
      end;
    finally
      ListView1.Items.EndUpdate;
    end;

    For I:=0 to ListView1.Columns.Count-1 do If ListView1.Items.Count>0 then begin
      ListView1.Column[I].Width:=-2;
      ListView1.Column[I].Width:=-1;
    end else begin
      ListView1.Column[I].Width:=-2;
    end;
    If ListView1.Items.Count>0 then ListView1.Selected:=ListView1.Items[0];


    {User}
    ListView.Items.BeginUpdate;
    try
      ListView.Items.Clear;
      For I:=0 to UserPackageList.Count-1 do begin
        L:=ListView.Items.Add;
        L.Caption:=UserPackageList.URL[I];
        L.Checked:=UserPackageList.Active[I];
        L.SubItems.Add(GetDescription(UserPackageList.URL[I]));
        L.Data:=Pointer(I);
      end;
    finally
      ListView.Items.EndUpdate;
    end;

    For I:=0 to ListView.Columns.Count-1 do If ListView.Items.Count>0 then begin
      ListView.Column[I].Width:=-2;
      ListView.Column[I].Width:=-1;
    end else begin
      ListView.Column[I].Width:=-2;
    end;
    If ListView.Items.Count>0 then ListView.Selected:=ListView.Items[0];

    {Common}
    ListViewChange(self,ListView.Selected,ctState);
  finally
    JustLoading:=False;
  end;
end;

procedure TPackageManagerRepositoriesEditForm.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  If (MainPackageList=nil) or (UserPackageList=nil) then exit;

  If (not JustLoading) and (Item<>nil) and (Change=ctState) then begin
    If Item.Owner=ListView1.Items
      then MainPackageList.Active[Integer(Item.Data)]:=Item.Checked
      else UserPackageList.Active[Integer(Item.Data)]:=Item.Checked;
  end;

  If PageControl.ActivePageIndex=0 then begin
    If ListView1.Selected=nil then begin
      ActivateButton.Enabled:=False;
      ActivateButton.Caption:=LanguageSetup.RepositoriesEditorActivateSource;
      PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupActivateSource;
    end else begin
      ActivateButton.Enabled:=True;
      If MainPackageList.Active[Integer(ListView1.Selected.Data)] then begin
        ActivateButton.Caption:=LanguageSetup.RepositoriesEditorDeactivateSource;
        PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupDeactivateSource;
      end else begin
        ActivateButton.Caption:=LanguageSetup.RepositoriesEditorActivateSource;
        PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupActivateSource;
      end;
    end;
  end else begin
    If ListView.Selected=nil then begin
      ActivateButton.Enabled:=False;
      ActivateButton.Caption:=LanguageSetup.RepositoriesEditorActivateSource;
      PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupActivateSource;
    end else begin
      ActivateButton.Enabled:=True;
      If UserPackageList.Active[Integer(ListView.Selected.Data)] then begin
        ActivateButton.Caption:=LanguageSetup.RepositoriesEditorDeactivateSource;
        PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupDeactivateSource;
      end else begin
        ActivateButton.Caption:=LanguageSetup.RepositoriesEditorActivateSource;
        PopupActivate.Caption:=LanguageSetup.RepositoriesEditorPopupActivateSource;
      end;
    end;
  end;

  PopupActivate.Enabled:=ActivateButton.Enabled;
  EditButton.Enabled:=(PageControl.ActivePageIndex=1) and (ListView.Selected<>nil);
  PopupEdit.Enabled:=(PageControl.ActivePageIndex=1) and (ListView.Selected<>nil);
  RemoveButton.Enabled:=(PageControl.ActivePageIndex=1) and (ListView.Selected<>nil);
  PopupRemove.Enabled:=(PageControl.ActivePageIndex=1) and (ListView.Selected<>nil);
end;

procedure TPackageManagerRepositoriesEditForm.PageControlChange(Sender: TObject);
begin
  ListViewChange(Sender,ListView.Selected,ctState);
end;

procedure TPackageManagerRepositoriesEditForm.ButtonWork(Sender: TObject);
Var I : Integer;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : If PageControl.ActivePageIndex=0 then begin
          If ListView1.Selected<>nil then begin
            ListView1.Selected.Checked:=not ListView1.Selected.Checked;
            I:=Integer(ListView1.Selected.Data);
            MainPackageList.Active[I]:=not MainPackageList.Active[I];
            ListViewChange(self,ListView1.Selected,ctState);
          end;
        end else begin
          If ListView.Selected<>nil then begin
            ListView.Selected.Checked:=not ListView.Selected.Checked;
            I:=Integer(ListView.Selected.Data);
            UserPackageList.Active[I]:=not UserPackageList.Active[I];
            ListViewChange(self,ListView.Selected,ctState);
          end;
        end;
    1 : begin
          PageControl.ActivePageIndex:=1;
          S:='';
          if not ShowPackageManagerRepositoriesEditURLDialog(self,S) then exit;
          UserPackageList.Add(S,True);
          LoadLists;
          ListView.Selected:=ListView.Items[ListView.Items.Count-1];
        end;
    2 : If (PageControl.ActivePageIndex=1) and (ListView.Selected<>nil) then begin
          I:=Integer(ListView.Selected.Data);
          S:=UserPackageList.URL[I];
          if not ShowPackageManagerRepositoriesEditURLDialog(self,S) then exit;
          UserPackageList.URL[I]:=S;
          ListView.Selected.Caption:=S;
          ListView.Selected.SubItems[0]:=GetDescription(S);
        end;
    3 : If (PageControl.ActivePageIndex=1) and (ListView.Selected<>nil) then begin
          If MessageDlg(LanguageSetup.RepositoriesEditorRemoveSourceConfirm,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          I:=ListView.ItemIndex;
          S:=DBDir+ExtractFileNameFromURL(UserPackageList.URL[Integer(ListView.Selected.Data)],'.xml',False);
          If FileExists(S) then ExtDeleteFile(S,ftTemp);
          UserPackageList.Delete(Integer(ListView.Selected.Data));
          LoadLists;
          If ListView.Items.Count>0 then ListView.ItemIndex:=Max(0,I-1);
          ListViewChange(self,ListView.Selected,ctState);
        end;
  end;
end;

procedure TPackageManagerRepositoriesEditForm.ListViewDblClick(Sender: TObject);
begin
  ButtonWork(EditButton);
end;

procedure TPackageManagerRepositoriesEditForm.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : ButtonWork(EditButton);
    VK_INSERT : ButtonWork(AddButton);
    VK_DELETE : ButtonWork(RemoveButton);
  end;
end;

procedure TPackageManagerRepositoriesEditForm.OKButtonClick(Sender: TObject);
begin
  MainPackageList.SaveToFile(self);
  UserPackageList.UpdateDate:=Now;
  UserPackageList.SaveToFile(self);
end;

procedure TPackageManagerRepositoriesEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TPackageManagerRepositoriesEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileImportDownload);
end;

{ global }

Function ShowPackageManagerRepositoriesEditDialog(const AOwner : TComponent) : Boolean;
begin
  PackageManagerRepositoriesEditForm:=TPackageManagerRepositoriesEditForm.Create(AOwner);
  try
    result:=(PackageManagerRepositoriesEditForm.ShowModal=mrOK);
  finally
    PackageManagerRepositoriesEditForm.Free;
  end;
end;

end.
