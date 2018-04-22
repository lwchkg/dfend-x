unit CheatDBEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, CheatDBUnit, Menus;

type
  TCheatDBEditForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    GameLabel: TLabel;
    GameComboBox: TComboBox;
    GameAddButton: TSpeedButton;
    GameEditButton: TSpeedButton;
    GameDeleteButton: TSpeedButton;
    ActionLabel: TLabel;
    ActionComboBox: TComboBox;
    ActionAddButton: TSpeedButton;
    ActionEditButton: TSpeedButton;
    ActionDeleteButton: TSpeedButton;
    ActionStepLabel: TLabel;
    FileMaskEdit: TLabeledEdit;
    ActionStepComboBox: TComboBox;
    ActionStepAddButton: TSpeedButton;
    ActionStepDeleteButton: TSpeedButton;
    Notebook: TNotebook;
    ChangeAddressAddressEdit: TLabeledEdit;
    ChangeAddressBytesLabel: TLabel;
    ChangeAddressNewValueEdit: TLabeledEdit;
    ChangeAddressBytesComboBox: TComboBox;
    InternalLabel: TLabel;
    InternalEdit: TSpinEdit;
    ChangeAddressWithDialogAddressEdit: TLabeledEdit;
    ChangeAddressWithDialogDefaultAddressRadioButton: TRadioButton;
    ChangeAddressWithDialogDefaultFixedRadioButton: TRadioButton;
    ChangeAddressWithDialogDefaultAddressEdit: TEdit;
    ChangeAddressWithDialogDefaultFixedEdit: TEdit;
    ChangeAddressWithDialogPromptEdit: TLabeledEdit;
    ChangeAddressWithDialogMinValueEdit: TLabeledEdit;
    ChangeAddressWithDialogMaxValueEdit: TLabeledEdit;
    ChangeAddressWithDialogBytesLabel: TLabel;
    ChangeAddressWithDialogBytesComboBox: TComboBox;
    ChangeAddressWithDialogInfoLabel: TLabel;
    ChangeAddressAddressLabel: TLabel;
    ChangeAddressWithDialogAddressLabel: TLabel;
    AddActionStepPopupMenu: TPopupMenu;
    AddActionStepPopupChangeAddress: TMenuItem;
    AddActionStepPopupChangeAddressWithDialog: TMenuItem;
    ChangeAddressInfoLabel: TLabel;
    ChangeAddressWithDialogInfoLabel2: TLabel;
    Bevel1: TBevel;
    UpdateButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure GameComboBoxChange(Sender: TObject);
    procedure ActionComboBoxChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionStepComboBoxChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ChangeAddressWithDialogDefaultEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure ActionStepComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    LastGame, LastAction, LastActionStep : Integer;
    GamesListUpdating, ActionListUpdating, ActionStepsListUpdating : Boolean;
    CheatDB : TCheatDB;
    Procedure LoadGamesList;
    Procedure SelectGame(const G : TCheatGameRecord);
    Procedure SelectAction(const A : TCheatAction);
  public
    { Public-Deklarationen }
    SearchForUpdates : Boolean;
  end;

var
  CheatDBEditForm: TCheatDBEditForm;

Function ShowCheatDBEditDialog(const AOwner : TComponent; var SearchForUpdates : Boolean) : Boolean;

implementation

uses PrgConsts, CheatDBToolsUnit, PrgSetupUnit, VistaToolsUnit, CommonTools,
     LanguageSetupUnit, IconLoaderUnit, HelpConsts;

{$R *.dfm}

procedure TCheatDBEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  SearchForUpdates:=False;

  Caption:=LanguageSetup.EditCheats;
  GameLabel.Caption:=LanguageSetup.EditCheatsGameName;
  GameAddButton.Hint:=LanguageSetup.EditCheatsGameAdd;
  GameEditButton.Hint:=LanguageSetup.EditCheatsGameEdit;
  GameDeleteButton.Hint:=LanguageSetup.EditCheatsGameDelete;
  ActionLabel.Caption:=LanguageSetup.EditCheatsActionName;
  ActionAddButton.Hint:=LanguageSetup.EditCheatsActionAdd;
  ActionEditButton.Hint:=LanguageSetup.EditCheatsActionEdit;
  ActionDeleteButton.Hint:=LanguageSetup.EditCheatsActionDelete;
  FileMaskEdit.EditLabel.Caption:=LanguageSetup.EditCheatsFileMask;
  ActionStepLabel.Caption:=LanguageSetup.EditCheatsActionStepName;
  ActionStepAddButton.Hint:=LanguageSetup.EditCheatsActionStepAdd;
  ActionStepDeleteButton.Hint:=LanguageSetup.EditCheatsActionStepDelete;
  AddActionStepPopupChangeAddress.Caption:=LanguageSetup.EditCheatsActionStepAddChangeAddress;
  AddActionStepPopupChangeAddressWithDialog.Caption:=LanguageSetup.EditCheatsActionStepAddChangeAddressWithDialog;

  ChangeAddressAddressEdit.EditLabel.Caption:=LanguageSetup.EditCheatsChangeAddress;
  ChangeAddressAddressLabel.Caption:=LanguageSetup.EditCheatsChangeAddressInfo;
  ChangeAddressNewValueEdit.EditLabel.Caption:=LanguageSetup.EditCheatsChangeAddressNewValue;
  ChangeAddressBytesLabel.Caption:=LanguageSetup.EditCheatsChangeAddressBytes;
  ChangeAddressInfoLabel.Caption:=LanguageSetup.EditCheatsHexInfo;

  ChangeAddressWithDialogAddressEdit.EditLabel.Caption:=LanguageSetup.EditCheatsChangeAddress;
  ChangeAddressWithDialogAddressLabel.Caption:=LanguageSetup.EditCheatsChangeAddressInfo;
  ChangeAddressWithDialogDefaultAddressRadioButton.Caption:=LanguageSetup.EditCheatsChangeAddressDefaultAdress;
  ChangeAddressWithDialogDefaultFixedRadioButton.Caption:=LanguageSetup.EditCheatsChangeAddressDefaultFixedValue;
  ChangeAddressWithDialogPromptEdit.EditLabel.Caption:=LanguageSetup.EditCheatsChangeAddressDialogPrompt;
  ChangeAddressWithDialogMinValueEdit.EditLabel.Caption:=LanguageSetup.EditCheatsChangeAddressNewValueMin;
  ChangeAddressWithDialogMaxValueEdit.EditLabel.Caption:=LanguageSetup.EditCheatsChangeAddressNewValueMAx;
  ChangeAddressWithDialogBytesLabel.Caption:=LanguageSetup.EditCheatsChangeAddressBytes;
  ChangeAddressWithDialogInfoLabel.Caption:=LanguageSetup.EditCheatsChangeAddressNewValueInfo;
  ChangeAddressWithDialogInfoLabel2.Caption:=LanguageSetup.EditCheatsHexInfo;

  InternalLabel.Caption:=LanguageSetup.EditCheatsApplyInternal;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  UpdateButton.Caption:=LanguageSetup.EditCheatsSearchForUpdates;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Update,UpdateButton);

  UserIconLoader.DialogImage(DI_Add,GameAddButton);
  UserIconLoader.DialogImage(DI_Edit,GameEditButton);
  UserIconLoader.DialogImage(DI_Delete,GameDeleteButton);
  UserIconLoader.DialogImage(DI_Add,ActionAddButton);
  UserIconLoader.DialogImage(DI_Edit,ActionEditButton);
  UserIconLoader.DialogImage(DI_Delete,ActionDeleteButton);
  UserIconLoader.DialogImage(DI_Add,ActionStepAddButton);
  UserIconLoader.DialogImage(DI_Delete,ActionStepDeleteButton);

  CheatDB:=SmartLoadCheatsDB;
  If CheatDB=nil then exit;

  LastGame:=-1; GamesListUpdating:=False;
  LastAction:=-1; ActionListUpdating:=False;
  LastActionStep:=-1; ActionStepsListUpdating:=False;
  LoadGamesList;
end;

procedure TCheatDBEditForm.FormDestroy(Sender: TObject);
begin
  If Assigned(CheatDB) then CheatDB.Free;
end;

procedure TCheatDBEditForm.FormShow(Sender: TObject);
begin
  If CheatDB=nil then begin
    MessageDlg(LanguageSetup.ApplyCheatDataBaseError,mtError,[mbOK],0);
    PostMessage(Handle,WM_Close,0,0);
    exit;
  end;
end;

procedure TCheatDBEditForm.LoadGamesList;
Var I : Integer;
    St : TStringList;
begin
  If LastGame>0 then begin
    GameComboBox.ItemIndex:=-1;
    GameComboBoxChange(self);
  end;
  LastGame:=-1;

  GameComboBox.Items.BeginUpdate;
  GamesListUpdating:=True;
  try
    St:=TStringList.Create;
    try
      For I:=0 to CheatDB.Count-1 do St.AddObject(CheatDB[I].Name,CheatDB[I]);
      St.Sort;
      GameComboBox.Items.Clear;
      GameComboBox.Items.AddStrings(St);
    finally
      St.Free;
    end;
  finally
    GameComboBox.Items.EndUpdate;
    GamesListUpdating:=False;
  end;

  If GameComboBox.Items.Count>0 then GameComboBox.ItemIndex:=0;
  ActionAddButton.Enabled:=(GameComboBox.Items.Count>0);
  GameComboBoxChange(self);
end;

Procedure TCheatDBEditForm.SelectGame(const G : TCheatGameRecord);
Var I : Integer;
begin
  For I:=0 to GameComboBox.Items.Count-1 do If TCheatGameRecord(GameComboBox.Items.Objects[I])=G then begin
    GameComboBox.ItemIndex:=I;
    GameComboBoxChange(self);
    break;
  end;
end;

procedure TCheatDBEditForm.GameComboBoxChange(Sender: TObject);
Var I : Integer;
    St : TStringList;
    G : TCheatGameRecord;
begin
  If GamesListUpdating then exit;

  If LastGame>=0 then begin
    ActionComboBox.ItemIndex:=-1;
    ActionComboBoxChange(Sender);
  end;

  If GameComboBox.ItemIndex>=0 then LastGame:=CheatDB.IndexOf(TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex])) else LastGame:=-1; 
  GameEditButton.Enabled:=(GameComboBox.ItemIndex>=0);
  GameDeleteButton.Enabled:=(GameComboBox.ItemIndex>=0);

  ActionComboBox.Items.BeginUpdate;
  ActionListUpdating:=True;
  try
    St:=TStringList.Create;
    try
      If LastGame>=0 then begin
        G:=CheatDB[LastGame];
        For I:=0 to G.Count-1 do St.AddObject(G[I].Name,G[I]);
      end;
      St.Sort;
      ActionComboBox.Items.Clear;
      ActionComboBox.Items.AddStrings(St);
    finally
      St.Free;
    end;

  finally
    ActionComboBox.Items.EndUpdate;
    ActionListUpdating:=False;
  end;

  If ActionComboBox.Items.Count>0 then ActionComboBox.ItemIndex:=0;
  ActionStepAddButton.Enabled:=(ActionComboBox.Items.Count>0);
  ActionComboBoxChange(Sender);
end;

Procedure TCheatDBEditForm.SelectAction(const A : TCheatAction);
Var I : Integer;
begin
  For I:=0 to ActionComboBox.Items.Count-1 do If TCheatAction(ActionComboBox.Items.Objects[I])=A then begin
    ActionComboBox.ItemIndex:=I;
    ActionComboBoxChange(self);
    break;
  end;
end;

procedure TCheatDBEditForm.ActionComboBoxChange(Sender: TObject);
Var I : Integer;
    St : TStringList;
    A : TCheatAction;
    S : String;
begin
  If ActionListUpdating then exit;

  If (LastGame>=0) and (LastAction>=0) then begin
    CheatDB[LastGame][LastAction].FileMask:=FileMaskEdit.Text;
    ActionStepComboBox.ItemIndex:=-1;
    ActionStepComboBoxChange(Sender);
  end;

  If (LastGame>=0) and (ActionComboBox.ItemIndex>=0) then LastAction:=CheatDB[LastGame].IndexOf(TCheatAction(ActionComboBox.Items.Objects[ActionComboBox.ItemIndex])) else LastAction:=-1;
  ActionEditButton.Enabled:=(ActionComboBox.ItemIndex>=0);
  ActionDeleteButton.Enabled:=(ActionComboBox.ItemIndex>=0);

  ActionStepComboBox.Items.BeginUpdate;
  ActionStepsListUpdating:=True;
  try
    St:=TStringList.Create;
    try
      If (LastGame>=0) and (LastAction>=0) then begin
        A:=CheatDB[LastGame][LastAction];
        For I:=0 to A.Count-1 do begin
          S:='';
          If A[I] is TCheatActionStepChangeAddress then begin
            S:=LanguageSetup.EditCheatsActionStepAddChangeAddress;
            S:=S+' ('+TCheatActionStepChangeAddress(A[I]).Addresses+')';
          end;
          If A[I] is TCheatActionStepChangeAddressWithDialog then begin
            S:=LanguageSetup.EditCheatsActionStepAddChangeAddressWithDialog;
            S:=S+' ('+TCheatActionStepChangeAddressWithDialog(A[I]).Addresses+')';
          end;
          If A[I] is TCheatActionStepInternal then begin
            S:=LanguageSetup.EditCheatsActionStepInternal;
            S:=S+' ('+IntToStr(TCheatActionStepInternal(A[I]).Nr)+')';
          end;
          St.AddObject(S,A[I]);
        end;
      end;
      ActionStepComboBox.Items.Clear;
      ActionStepComboBox.Items.AddStrings(St);
    finally
      St.Free;
    end;
  finally
    ActionStepComboBox.Items.EndUpdate;
    ActionStepsListUpdating:=False;
  end;

  FileMaskEdit.Enabled:=(LastAction>=0);

  If LastAction<0 then begin
    FileMaskEdit.Text:='';
  end else begin
    FileMaskEdit.Text:=CheatDB[LastGame][LastAction].FileMask;
  end;

  If ActionStepComboBox.Items.Count>0 then ActionStepComboBox.ItemIndex:=0;
  ActionStepComboBoxChange(Sender);
end;

procedure TCheatDBEditForm.ActionStepComboBoxChange(Sender: TObject);
Var A : TCheatActionStep;
    B : Boolean;
    I : Integer;
begin
  If ActionStepsListUpdating then exit;

  SetComboHint(ActionStepComboBox);

  If (LastGame>=0) and (LastAction>=0) and (LastActionStep>=0) then begin
    A:=CheatDB[LastGame][LastAction][LastActionStep];
    Case Notebook.PageIndex of
      0 : B:=(A is TCheatActionStepChangeAddress);
      1 : B:=(A is TCheatActionStepChangeAddressWithDialog);
      2 : B:=(A is TCheatActionStepInternal);
      else B:=True;
    end;
    If not B then A:=nil;

    Case Notebook.PageIndex of
      0 : begin
            {<ChangeAddress Addresses="..." Bytes="..." NewValue="..."/>}
            If A=nil then A:=TCheatActionStepChangeAddress.Create(nil);
            TCheatActionStepChangeAddress(A).Addresses:=ChangeAddressAddressEdit.Text;
            TCheatActionStepChangeAddress(A).NewValue:=ChangeAddressNewValueEdit.Text;
            Case ChangeAddressBytesComboBox.ItemIndex of
              0 : TCheatActionStepChangeAddress(A).Bytes:=1;
              1 : TCheatActionStepChangeAddress(A).Bytes:=2;
              2 : TCheatActionStepChangeAddress(A).Bytes:=4;
            end;
          end;
      1 : begin
            {<ChangeAddressWithDialog Addresses="..." Bytes="..." DefaultValue="..."/DefaultValueAddress="..." Prompt="..." [MinValue="..."] [MaxValue="..."]/>}
            If A=nil then A:=TCheatActionStepChangeAddressWithDialog.Create(nil);
            TCheatActionStepChangeAddressWithDialog(A).Addresses:=ChangeAddressWithDialogAddressEdit.Text;
            If ChangeAddressWithDialogDefaultFixedRadioButton.Checked then begin
              TCheatActionStepChangeAddressWithDialog(A).DefaultValueAddress:='';
              TCheatActionStepChangeAddressWithDialog(A).DefaultValue:=ChangeAddressWithDialogDefaultFixedEdit.Text;
            end else begin
              TCheatActionStepChangeAddressWithDialog(A).DefaultValue:='';
              TCheatActionStepChangeAddressWithDialog(A).DefaultValueAddress:=ChangeAddressWithDialogDefaultAddressEdit.Text;
            end;
            TCheatActionStepChangeAddressWithDialog(A).DialogPrompt:=ChangeAddressWithDialogPromptEdit.Text;
            TCheatActionStepChangeAddressWithDialog(A).MinValue:=Trim(ChangeAddressWithDialogMinValueEdit.Text);
            TCheatActionStepChangeAddressWithDialog(A).MaxValue:=Trim(ChangeAddressWithDialogMaxValueEdit.Text);
            Case ChangeAddressWithDialogBytesComboBox.ItemIndex of
              0 : TCheatActionStepChangeAddressWithDialog(A).Bytes:=1;
              1 : TCheatActionStepChangeAddressWithDialog(A).Bytes:=2;
              2 : TCheatActionStepChangeAddressWithDialog(A).Bytes:=4;
            end;
          end;
      2 : begin
            {<Internal Nr="..."/>}
            If A=nil then A:=TCheatActionStepInternal.Create(nil);
            TCheatActionStepInternal(A).Nr:=InternalEdit.Value;
          end;
      else A:=nil;
    end;
    If not B then begin
      For I:=0 to ActionStepComboBox.Items.Count-1 do If ActionStepComboBox.Items.Objects[I]=CheatDB[LastGame][LastAction][LastActionStep] then begin
        ActionStepComboBox.Items.Objects[I]:=A; break;
      end;
      CheatDB[LastGame][LastAction].SetNewActionStep(A,LastActionStep);
    end;
  end;

  If (LastGame>=0) and (LastAction>=0) and (ActionStepComboBox.ItemIndex>=0) then LastActionStep:=CheatDB[LastGame][LastAction].IndexOf(TCheatActionStep(ActionStepComboBox.Items.Objects[ActionStepComboBox.ItemIndex])) else LastActionStep:=-1;
  ActionStepDeleteButton.Enabled:=(ActionStepComboBox.ItemIndex>=0);

  Notebook.Visible:=(LastActionStep>=0);
  If LastActionStep>=0 then begin
    A:=CheatDB[LastGame][LastAction][LastActionStep];

    If A is TCheatActionStepChangeAddress then begin
      {<ChangeAddress Addresses="..." Bytes="..." NewValue="..."/>}
      Notebook.PageIndex:=0;
      ChangeAddressAddressEdit.Text:=TCheatActionStepChangeAddress(A).Addresses;
      ChangeAddressNewValueEdit.Text:=TCheatActionStepChangeAddress(A).NewValue;
      ChangeAddressBytesComboBox.ItemIndex:=2;
      Case TCheatActionStepChangeAddress(A).Bytes of
        1 : ChangeAddressBytesComboBox.ItemIndex:=0;
        2 : ChangeAddressBytesComboBox.ItemIndex:=1;
        3 : ChangeAddressBytesComboBox.ItemIndex:=2;
      end;
    end;

    If A is TCheatActionStepChangeAddressWithDialog then begin
      {<ChangeAddressWithDialog Addresses="..." Bytes="..." DefaultValue="..."/DefaultValueAddress="..." Prompt="..." [MinValue="..."] [MaxValue="..."]/>}
      Notebook.PageIndex:=1;
      ChangeAddressWithDialogAddressEdit.Text:=TCheatActionStepChangeAddressWithDialog(A).Addresses;
      If Trim(TCheatActionStepChangeAddressWithDialog(A).DefaultValue)<>'' then begin
        ChangeAddressWithDialogDefaultAddressEdit.Text:='';
        ChangeAddressWithDialogDefaultFixedRadioButton.Checked:=True;
        ChangeAddressWithDialogDefaultFixedEdit.Text:=TCheatActionStepChangeAddressWithDialog(A).DefaultValue;
      end else begin
        ChangeAddressWithDialogDefaultFixedEdit.Text:='';
        ChangeAddressWithDialogDefaultAddressRadioButton.Checked:=True;
        ChangeAddressWithDialogDefaultAddressEdit.Text:=TCheatActionStepChangeAddressWithDialog(A).DefaultValueAddress;
      end;
      ChangeAddressWithDialogPromptEdit.Text:=TCheatActionStepChangeAddressWithDialog(A).DialogPrompt;
      ChangeAddressWithDialogMinValueEdit.Text:=TCheatActionStepChangeAddressWithDialog(A).MinValue;
      ChangeAddressWithDialogMaxValueEdit.Text:=TCheatActionStepChangeAddressWithDialog(A).MaxValue;
      Case TCheatActionStepChangeAddressWithDialog(A).Bytes of
        1 : ChangeAddressWithDialogBytesComboBox.ItemIndex:=0;
        2 : ChangeAddressWithDialogBytesComboBox.ItemIndex:=1;
        3 : ChangeAddressWithDialogBytesComboBox.ItemIndex:=2;
      end;
    end;

    If A is TCheatActionStepInternal then begin
      {<Internal Nr="..."/>}
      Notebook.PageIndex:=2;
      InternalEdit.Value:=TCheatActionStepInternal(A).Nr;
    end;
  end;
end;

procedure TCheatDBEditForm.ActionStepComboBoxDropDown(Sender: TObject);
begin
  SetComboDropDownDropDownWidth(ActionStepComboBox);
end;

procedure TCheatDBEditForm.ChangeAddressWithDialogDefaultEditChange(Sender: TObject);
begin
  If Sender=ChangeAddressWithDialogDefaultAddressEdit then ChangeAddressWithDialogDefaultAddressRadioButton.Checked:=True;
  If Sender=ChangeAddressWithDialogDefaultFixedEdit then ChangeAddressWithDialogDefaultFixedRadioButton.Checked:=True;
end;

procedure TCheatDBEditForm.ButtonWork(Sender: TObject);
Var S : String;
    G : TCheatGameRecord;
    A : TCheatAction;
    A2 : TCheatActionStep;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0 : begin {Add game}
          If not InputQuery(LanguageSetup.EditCheatsGameAdd,LanguageSetup.EditCheatsGameAddPrompt,S) then exit;
          G:=TCheatGameRecord.Create(nil); G.Name:=S; CheatDB.Add(G);
          LoadGamesList; SelectGame(G);
        end;
    1 : begin {Edit game}
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          S:=G.Name; If not InputQuery(LanguageSetup.EditCheatsGameEdit,LanguageSetup.EditCheatsGameEditPrompt,S) then exit;
          G.Name:=S; LoadGamesList; SelectGame(G);
        end;
    2 : begin {Delete game}
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If MessageDlg(Format(LanguageSetup.EditCheatsGameDeletePrompt,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          CheatDB.Delete(G); LastGame:=-1; LoadGamesList;
        end;
    3 : begin {Add action}
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If not InputQuery(LanguageSetup.EditCheatsActionAdd,LanguageSetup.EditCheatsActionAddPrompt,S) then exit;
          A:=TCheatAction.Create(nil); A.Name:=S; G.Add(A);
          LoadGamesList; SelectGame(G); SelectAction(A);
        end;
    4 : begin {Edit action}
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If ActionComboBox.ItemIndex<0 then exit;
          A:=TCheatAction(ActionComboBox.Items.Objects[ActionComboBox.ItemIndex]);
          S:=A.Name; If not InputQuery(LanguageSetup.EditCheatsActionEdit,LanguageSetup.EditCheatsActionEditPrompt,S) then exit;
          A.Name:=S; LoadGamesList; SelectGame(G); SelectAction(A);
        end;
    5 : begin {Delete action}
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If ActionComboBox.ItemIndex<0 then exit;
          A:=TCheatAction(ActionComboBox.Items.Objects[ActionComboBox.ItemIndex]);
          If MessageDlg(Format(LanguageSetup.EditCheatsActionDeletePrompt,[A.Name,G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          G.Delete(A); LastAction:=-1; LoadGamesList; SelectGame(G);
        end;
    6 : begin {Add action step}
          If ActionComboBox.ItemIndex<0 then exit;
          P:=ClientToScreen(Point(ActionStepAddButton.Left,ActionStepAddButton.Top));
          AddActionStepPopupMenu.Popup(P.X+5,P.Y+5);
        end;
    7 : begin {Delete action step}
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If ActionComboBox.ItemIndex<0 then exit;
          A:=TCheatAction(ActionComboBox.Items.Objects[ActionComboBox.ItemIndex]);
          If ActionStepComboBox.ItemIndex<0 then exit;
          If MessageDlg(LanguageSetup.EditCheatsActionStepDeletePrompt,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          A.Delete(ActionStepComboBox.ItemIndex); LastActionStep:=-1; LoadGamesList; SelectGame(G); SelectAction(A);
        end;
    8 : begin
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If ActionComboBox.ItemIndex<0 then exit;
          A:=TCheatAction(ActionComboBox.Items.Objects[ActionComboBox.ItemIndex]);
          A2:=TCheatActionStepChangeAddress.Create(nil); A.Add(A2);
          LoadGamesList; SelectGame(G); SelectAction(A);
          ActionStepComboBox.ItemIndex:=ActionStepComboBox.Items.Count-1; ActionStepComboBoxChange(Sender);
        end;
    9 : begin
          If GameComboBox.ItemIndex<0 then exit;
          G:=TCheatGameRecord(GameComboBox.Items.Objects[GameComboBox.ItemIndex]);
          If ActionComboBox.ItemIndex<0 then exit;
          A:=TCheatAction(ActionComboBox.Items.Objects[ActionComboBox.ItemIndex]);
          A2:=TCheatActionStepChangeAddressWithDialog.Create(nil); A.Add(A2);
          LoadGamesList; SelectGame(G); SelectAction(A);
          ActionStepComboBox.ItemIndex:=ActionStepComboBox.Items.Count-1; ActionStepComboBoxChange(Sender);
        end;
  end;
end;

procedure TCheatDBEditForm.OKButtonClick(Sender: TObject);
begin
  GameComboBox.ItemIndex:=-1;
  GameComboBoxChange(Sender);
  SmartSaveCheatsDB(CheatDB,self);
end;

procedure TCheatDBEditForm.UpdateButtonClick(Sender: TObject);
begin
  OKButtonClick(Sender);
  SearchForUpdates:=True;
  ModalResult:=mrOK;
end;

procedure TCheatDBEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasEditCheatDB);
end;

procedure TCheatDBEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCheatDBEditDialog(const AOwner : TComponent; var SearchForUpdates : Boolean) : Boolean;
begin
  SearchForUpdates:=False;
  CheatsDBUpdateCheckIfSetup(Application.MainForm);
  CheatDBEditForm:=TCheatDBEditForm.Create(AOwner);
  try
    result:=(CheatDBEditForm.ShowModal=mrOK);
    SearchForUpdates:=CheatDBEditForm.SearchForUpdates;
  finally
    CheatDBEditForm.Free;
  end;
end;

end.
