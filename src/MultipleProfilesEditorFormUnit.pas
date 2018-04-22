unit MultipleProfilesEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, CheckLst, ComCtrls, ImgList, ExtCtrls,
  GameDBUnit;

Type TControlData=record
  Control : TControl;
  RelTop : Integer;
end;

Type TSettingData=record
  ID : Integer;
  CheckBox : TCheckBox;
  RelTop : Integer;
  Values : Array of TControlData;
end;

Type TSectionData=record
  Open : Boolean;
  Caption : TLabel;
  Image : TImage;
  Info : TLabel;
  Settings : Array of TSettingData;
  LastRelY : Integer;
end;

type
  TMultipleProfilesEditorForm = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    TabSheet2: TTabSheet;
    ScrollBox: TScrollBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private-Deklarationen }
    Sections : Array of TSectionData;
    Procedure InitSettings;
    Procedure CaptionClick(Sender : TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    Procedure SelectFolderButtonClick(Sender: TObject);
    Procedure AddCaption(const Name : String);
    Procedure AddSetting(const ID : Integer; const Name : String; const Values : TStringList; const Editable : Boolean; const ValueWidth : Integer; const FreeValues : Boolean = False);
    Procedure AddEditSetting(const ID : Integer; const Name, Default : String; const ValueWidth : Integer);
    Procedure AddYesNoSetting(const ID : Integer; const Name : String);
    Procedure AddSettingWithEdit(const ID : Integer; const Name : String; const Values : TStringList; const Editable : Boolean; const ValueWidth : Integer; const FreeValues : Boolean = False);
    Procedure AddSpinSetting(const ID : Integer; const Name : String; const MinVal, MaxVal : Integer; const ValueWidth : Integer; const DefaultVal : Integer =-1);
    Procedure AddReplaceMountingSetting(const ID : Integer; const Name, FromLabel, ToLabel : String);
    function DefaultValueOnList(const List, Value: String): Boolean;
  public
    { Public-Deklarationen }
    TemplateMode : Boolean;
    GameDB : TGameDB;
  end;

var
  MultipleProfilesEditorForm: TMultipleProfilesEditorForm;

Function ShowMultipleProfilesEditorDialog(const AOwner : TComponent; const AGameDB : TGameDB; const TemplateMode : Boolean = False) : Boolean;  

implementation

uses Spin, Math, LanguageSetupUnit, CommonTools, VistaToolsUnit, IconLoaderUnit,
     GameDBToolsUnit, HelpConsts, PrgSetupUnit;

{$R *.dfm}

{ Tools }

const CheckboxWidth=315;
      ValueWidth=105;
      EditWidth=200;
      DefaultIndent=35;

Function GetAllUserInfoKeys(const GameDB : TGameDB) : TStringList;
Var I,J,K : Integer;
    St, Upper : TStringList;
    S : String;
begin
  Upper:=TStringList.Create;
  result:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do begin
      St:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St.Count-1 do begin
          S:=Trim(St[J]);
          K:=Pos('=',S); If K=0 then continue;
          S:=Trim(Copy(S,1,K-1));
          If S='' then continue;
          If Upper.IndexOf(ExtUpperCase(S))<0 then begin
            result.Add(S);
            Upper.Add(ExtUpperCase(S));
          end;
        end;
      finally
        St.Free;
      end;
    end;
  finally
    Upper.Free;
  end;
end;

Procedure SetUserInfo(const G : TGame; const Key, Value : String);
Var St : TStringList;
    ValueFound : Boolean;
    I,J : Integer;
    KeyUpper, S : String;
begin
  KeyUpper:=Trim(ExtUpperCase(Key));
  St:=StringToStringList(G.UserInfo);
  try
    ValueFound:=False;
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      J:=Pos('=',S); If J=0 then continue;
      S:=Trim(Copy(S,1,J-1));
      If ExtUpperCase(S)=KeyUpper then begin St[I]:=Key+'='+Value; ValueFound:=True; break; end;
    end;
    If not ValueFound then St.Add(Key+'='+Value);
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

Procedure DelUserInfo(const G : TGame; const Key : String);
Var St : TStringList;
    KeyUpper,S : String;
    I,J : Integer;
begin
  KeyUpper:=Trim(ExtUpperCase(Key));
  St:=StringToStringList(G.UserInfo);
  try
    I:=0;
    while I<St.Count do begin
      S:=Trim(St[I]);
      J:=Pos('=',S); If J=0 then begin inc(I); continue; end;
      S:=Trim(Copy(S,1,J-1));
      If ExtUpperCase(S)=KeyUpper then begin St.Delete(I); continue; end;
      inc(I);
    end;
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

Procedure ChangeMountSetting(const G : TGame; const SetDefault : Boolean);
Var I : Integer;
    AllGamesDir,GameDir,S : String;
    St : TStringList;
begin
  {Only process if normal start (not booting from image}
  If Trim(G.AutoexecBootImage)<>'' then exit;

  {Exit if mounting not used}
  If G.AutoexecOverrideMount then exit;

  AllGamesDir:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
  If (Trim(G.GameExe)='') or (Copy(Trim(ExtUpperCase(G.GameExe)),1,7)='DOSBOX:') then GameDir:='' else GameDir:=IncludeTrailingPathDelimiter(MakeAbsPath(ExtractFilePath(G.GameExe),PrgSetup.BaseDir));

  For I:=0 to 9 do begin
    St:=ValueToList(G.Mount[I]);
    try
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      If (St.Count<3) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') or (Trim(ExtUpperCase(St[2]))<>'C')  then continue;
      S:=IncludeTrailingPathDelimiter(MakeAbsPath(St[0],PrgSetup.BaseDir));
      If SetDefault then begin
        If Trim(ExtUpperCase(GameDir))=Trim(ExtUpperCase(S)) then begin
          St[0]:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir);
          G.Mount[I]:=ListToValue(St);
          G.StoreAllValues;
          exit;
        end;
      end else begin
        If (Trim(ExtUpperCase(AllGamesDir))=Trim(ExtUpperCase(S))) and (GameDir<>'') then begin
          St[0]:=MakeRelPath(GameDir,PrgSetup.BaseDir);
          G.Mount[I]:=ListToValue(St);
          G.StoreAllValues;
          exit;
        end;
      end;  
    finally
      St.Free;
    end;
  end;
end;

Function GetReplaceFolderList(const GameDB : TGameDB) : TStringList;
Var I,J : Integer;
    G : TGame;
    St,St2 : TStringList;
begin
  result:=TStringList.Create;
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do begin
      G:=GameDB[I];
      If ScummVMMode(G) or WindowsExeMode(G) then continue;
      For J:=0 to G.NrOfMounts-1 do begin
        {RealFolder;Type;Letter;IO;Label;FreeSpace; Type=DRIVE}
        St2:=ValueToList(G.Mount[J]);
        try
          If St2.Count<2 then continue;
          If Trim(ExtUpperCase(St2[1]))<>'DRIVE' then continue;
          If St.IndexOf(ExtUpperCase(IncludeTrailingPathDelimiter(St2[0])))>=0 then continue;
          St.Add(ExtUpperCase(IncludeTrailingPathDelimiter(St2[0])));
          result.Add(IncludeTrailingPathDelimiter(St2[0]));
        finally
          St2.Free;
        end;
      end;
    end;
  finally
    St.Free;
  end;
end;

procedure ReplaceFolderWork(const G: TGame; const FromValue, ToValue : String);
Var I : Integer;
    St : TStringList;
    S : String;
begin
  S:=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(FromValue)));

  For I:=0 to G.NrOfMounts-1 do begin
    {RealFolder;Type;Letter;IO;Label;FreeSpace; Type=DRIVE}
    St:=ValueToList(G.Mount[I]);
    try
      If St.Count<2 then continue;
      If Trim(ExtUpperCase(St[1]))<>'DRIVE' then continue;
      If IncludeTrailingPathDelimiter(Trim(ExtUpperCase(St[0])))=S then begin
        St[0]:=ToValue;
        G.Mount[I]:=ListToValue(St);
      end;
    finally
      St.Free;
    end;
  end;
end;

const PriorityForeground : Array[0..3] of String = ('lower','normal','higher','highest');
      PriorityBackground : Array[0..4] of String = ('pause','lower','normal','higher','highest');

{ TEditMultipleProfilesForm }

procedure TMultipleProfilesEditorForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  PageControl.ActivePageIndex:=0;
  TemplateMode:=False;
end;

procedure TMultipleProfilesEditorForm.FormShow(Sender: TObject);
begin
  If TemplateMode then begin
    Caption:=LanguageSetup.ChangeProfilesFormCaption2;
    TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet2;
    InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo2;
  end else begin
    Caption:=LanguageSetup.ChangeProfilesFormCaption;
    TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet;
    InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo;
  end;
  TabSheet2.Caption:=LanguageSetup.ChangeProfilesFormEditProfileSheet;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_SelectFolder,ImageList,0);
  UserIconLoader.DialogImage(DI_Expand,ImageList,1);
  UserIconLoader.DialogImage(DI_Collapse,ImageList,2);

  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);

  InitSettings;
  CaptionClick(nil);
  CheckBoxClick(nil);
end;

Procedure TMultipleProfilesEditorForm.AddCaption(const Name : String);
Var L,L2 : TLabel;
    M : TImage;
    I : Integer;
begin
  I:=length(Sections);

  M:=TImage.Create(self);
  with M do begin Parent:=ScrollBox; Left:=10; Width:=ImageList.Width; Height:=ImageList.Height; Tag:=I; OnClick:=CaptionClick; end;

  L:=TLabel.Create(self);
  with L do begin Parent:=ScrollBox; Left:=33; AutoSize:=True; Font.Size:=L.Font.Size+1; Font.Style:=[fsBold]; Tag:=I; OnClick:=CaptionClick; end;
  L.Caption:=Name;

  L2:=TLabel.Create(self);
  with L2 do begin Parent:=ScrollBox; Left:=DefaultIndent; AutoSize:=True; Visible:=False; end;

  SetLength(Sections,I+1);
  with Sections[I] do begin Caption:=L; Image:=M; Info:=L2; Open:=False; LastRelY:=0; end;
end;

procedure TMultipleProfilesEditorForm.AddSetting(const ID : Integer; const Name : String; const Values : TStringList; const Editable : Boolean; const ValueWidth : Integer; const FreeValues : Boolean);
Var CheckBox : TCheckBox;
    ComboBox : TComboBox;
    I : Integer;
    S : ^TSectionData;
begin
  S:=@Sections[length(Sections)-1];

  try
    inc(S^.LastRelY,6);

    CheckBox:=TCheckBox.Create(self);
    with CheckBox do begin Parent:=ScrollBox; Left:=DefaultIndent; Width:=CheckboxWidth; Checked:=False; OnClick:=CheckBoxClick; end;
    CheckBox.Caption:=Name;
    NoFlicker(CheckBox);

    ComboBox:=TComboBox.Create(self);
    with ComboBox do begin
      Parent:=ScrollBox; Left:=DefaultIndent+CheckboxWidth+2;
      If ValueWidth<0 then begin Width:=ScrollBox.ClientWidth-4-Left; Anchors:=[akLeft,akTop,akRight]; end else Width:=ValueWidth;
      If Editable then Style:=csDropDown else Style:=csDropDownList;
      If Values=nil then begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); end else Items.AddStrings(Values);
      If (not Editable) and (Items.Count>0) then ItemIndex:=0 else ItemIndex:=-1;
      Enabled:=False;
      OnDropDown:=ComboBoxDropDown;
      OnChange:=ComboBoxChange;
    end;
    NoFlicker(ComboBox);
    SetComboHint(ComboBox);

    I:=length(S^.Settings); SetLength(S^.Settings,I+1);
    S^.Settings[I].CheckBox:=CheckBox;
    S^.Settings[I].RelTop:=S^.LastRelY+2;

    SetLength(S^.Settings[I].Values,1);
    S^.Settings[I].Values[0].Control:=ComboBox;
    S^.Settings[I].Values[0].RelTop:=S^.LastRelY;
    S^.Settings[I].ID:=ID;

    inc(S^.LastRelY,ComboBox.Height);
  finally
    If FreeValues and Assigned(Values) then Values.Free;
  end;
end;

Procedure TMultipleProfilesEditorForm.AddEditSetting(const ID : Integer; const Name, Default : String; const ValueWidth : Integer);
Var CheckBox : TCheckBox;
    Edit : TEdit;
    I : Integer;
    S : ^TSectionData;
begin
  S:=@Sections[length(Sections)-1];

  inc(S^.LastRelY,6);

  CheckBox:=TCheckBox.Create(self);
  with CheckBox do begin Parent:=ScrollBox; Left:=DefaultIndent; Width:=CheckboxWidth; Checked:=False; OnClick:=CheckBoxClick; end;
  CheckBox.Caption:=Name;
  NoFlicker(CheckBox);

  Edit:=TEdit.Create(self);
  with Edit do begin
    Parent:=ScrollBox; Left:=DefaultIndent+CheckboxWidth+2;
    If ValueWidth<0 then begin Width:=ScrollBox.ClientWidth-4-Left; Anchors:=[akLeft,akTop,akRight]; end else Width:=ValueWidth;
    Text:=Default; Enabled:=False;
  end;
  NoFlicker(Edit);

  I:=length(S^.Settings); SetLength(S^.Settings,I+1);
  S^.Settings[I].CheckBox:=CheckBox;
  S^.Settings[I].RelTop:=S^.LastRelY+2;

  SetLength(S^.Settings[I].Values,1);
  S^.Settings[I].Values[0].Control:=Edit;
  S^.Settings[I].Values[0].RelTop:=S^.LastRelY;
  S^.Settings[I].ID:=ID;

  inc(S^.LastRelY,Edit.Height);
end;

Procedure TMultipleProfilesEditorForm.AddYesNoSetting(const ID : Integer; const Name : String);
begin
  AddSetting(ID,Name,nil,False,ValueWidth);
end;

procedure TMultipleProfilesEditorForm.AddSettingWithEdit(const ID : Integer; const Name: String; const Values: TStringList; const Editable: Boolean; const ValueWidth: Integer; const FreeValues: Boolean);
Var Edit : TEdit;
    I : Integer;
    C : TControl;
    S : ^TSettingData;
begin
  AddSetting(ID,Name,Values,Editable,ValueWidth,FreeValues);

  S:=@Sections[length(Sections)-1].Settings[length(Sections[length(Sections)-1].Settings)-1];

  I:=length(S^.Values);
  C:=S^.Values[I-1].Control;

  Edit:=TEdit.Create(self);
  with Edit do begin Parent:=ScrollBox; Left:=C.Left+C.Width+4; Width:=ScrollBox.ClientWidth-4-Left; Anchors:=[akLeft,akTop,akRight]; Enabled:=False; end;
  NoFlicker(Edit);

  SetLength(S^.Values,I+1);
  S^.Values[I].Control:=Edit;
  S^.Values[I].RelTop:=S^.Values[I-1].RelTop;
end;

Procedure TMultipleProfilesEditorForm.AddSpinSetting(const ID : Integer; const Name : String; const MinVal, MaxVal : Integer; const ValueWidth : Integer; const DefaultVal : Integer);
Var CheckBox : TCheckBox;
    SpinEdit : TSpinEdit;
    I : Integer;
    S : ^TSectionData;
begin
  S:=@Sections[length(Sections)-1];

  inc(S^.LastRelY,6);

  CheckBox:=TCheckBox.Create(self);
  with CheckBox do begin Parent:=ScrollBox; Left:=DefaultIndent; Width:=CheckboxWidth; Checked:=False; OnClick:=CheckBoxClick; end;
  CheckBox.Caption:=Name;
  NoFlicker(CheckBox);

  SpinEdit:=TSpinEdit.Create(self);
  with SpinEdit do begin
    Parent:=ScrollBox; Left:=DefaultIndent+CheckboxWidth+2;
    If ValueWidth<0 then begin Width:=ScrollBox.ClientWidth-4-Left; Anchors:=[akLeft,akTop,akRight]; end else Width:=ValueWidth;
    MinValue:=MinVal; MaxValue:=MaxVal;
    If DefaultVal=-1 then Value:=MinVal else Value:=DefaultVal;
    Enabled:=False;
  end;
  NoFlicker(SpinEdit);

  I:=length(S^.Settings); SetLength(S^.Settings,I+1);
  S^.Settings[I].CheckBox:=CheckBox;
  S^.Settings[I].RelTop:=S^.LastRelY+2;

  SetLength(S^.Settings[I].Values,1);
  S^.Settings[I].Values[0].Control:=SpinEdit;
  S^.Settings[I].Values[0].RelTop:=S^.LastRelY;
  S^.Settings[I].ID:=ID;

  inc(S^.LastRelY,SpinEdit.Height);
end;

function TMultipleProfilesEditorForm.DefaultValueOnList(const List, Value: String): Boolean;
Var St : TStringList;
    I : Integer;
    S : String;
begin
  result:=False;

  S:=Trim(ExtUpperCase(Value));
  St:=ValueToList(List,';,');
  try
    For I:=0 to St.Count-1 do If Trim(ExtUpperCase(St[I]))=S then begin result:=True; exit; end;
  finally
    St.Free;
  end;
end;

Procedure TMultipleProfilesEditorForm.AddReplaceMountingSetting(const ID : Integer; const Name, FromLabel, ToLabel : String);
Var CheckBox : TCheckBox;
    Label1, Label2 : TLabel;
    ComboBox : TComboBox;
    Edit : TEdit;
    Button : TSpeedButton;
    I : Integer;
    List : TStringList;
    S : ^TSectionData;
const Indent=20;
begin
  List:=GetReplaceFolderList(GameDB);
  try
    If List.Count=0 then exit;

    S:=@Sections[length(Sections)-1];

    inc(S^.LastRelY,6);

    CheckBox:=TCheckBox.Create(self);
    with CheckBox do begin Parent:=ScrollBox; Left:=DefaultIndent; Width:=CheckboxWidth; Checked:=False; OnClick:=CheckBoxClick; end;
    CheckBox.Caption:=Name;
    NoFlicker(CheckBox);

    Label1:=TLabel.Create(self);
    with Label1 do begin Parent:=ScrollBox; Left:=DefaultIndent+Indent; AutoSize:=True; Caption:=FromLabel; end;

    Label2:=TLabel.Create(self);
    with Label2 do begin Parent:=ScrollBox; Left:=DefaultIndent+Indent+EditWidth+10; AutoSize:=True; Caption:=ToLabel; end;

    ComboBox:=TComboBox.Create(self);
    with ComboBox do begin Parent:=ScrollBox; Left:=DefaultIndent+Indent; Width:=EditWidth; Style:=csDropDownList; Items.AddStrings(List); ItemIndex:=0; Enabled:=False; end;
    NoFlicker(ComboBox);
    SetComboHint(ComboBox);

    Edit:=TEdit.Create(self);
    with Edit do begin Parent:=ScrollBox; Left:=DefaultIndent+Indent+EditWidth+10; Anchors:=[akLeft,akTop,akRight]; Enabled:=False; end;
    NoFlicker(Edit);

    Button:=TSpeedButton.Create(self);
    with Button do begin Parent:=ScrollBox; Left:=ScrollBox.ClientWidth-10-Width; Anchors:=[akTop,akRight]; Tag:=ID; OnClick:=SelectFolderButtonClick; ShowHint:=True; Hint:=LanguageSetup.ChooseFolder; Enabled:=False; end;
    ImageList.GetBitmap(0,Button.Glyph);

    Edit.Width:=Button.Left-4-Edit.Left;
    Label1.FocusControl:=ComboBox;
    Label2.FocusControl:=Edit;

    I:=length(S^.Settings); SetLength(S^.Settings,I+1);

    S^.Settings[I].CheckBox:=CheckBox;
    S^.Settings[I].RelTop:=S^.LastRelY+2;

    inc(S^.LastRelY,CheckBox.Height+2+4);

    SetLength(S^.Settings[I].Values,5);
    S^.Settings[I].Values[0].Control:=ComboBox;
    S^.Settings[I].Values[0].RelTop:=S^.LastRelY+Label1.Height+2;
    S^.Settings[I].Values[1].Control:=Edit;
    S^.Settings[I].Values[1].RelTop:=S^.LastRelY+Label1.Height+2;
    S^.Settings[I].Values[2].Control:=Button;
    S^.Settings[I].Values[2].RelTop:=S^.LastRelY+Label1.Height+2;
    S^.Settings[I].Values[3].Control:=Label1;
    S^.Settings[I].Values[3].RelTop:=S^.LastRelY;
    S^.Settings[I].Values[4].Control:=Label2;
    S^.Settings[I].Values[4].RelTop:=S^.LastRelY;
    S^.Settings[I].ID:=ID;

    inc(S^.LastRelY,Label1.Height+2+ComboBox.Height);
  finally
    List.Free;
  end;
end;

procedure TMultipleProfilesEditorForm.InitSettings;
Var St : TStringList;
    I,J : Integer;
    S : String;
begin
  {Game info}
  AddCaption(LanguageSetup.ProfileEditorGameInfoSheet);
  AddSetting(1001,LanguageSetup.GameGenre,ExtGenreList(GetCustomGenreName(GameDB.GetGenreList)),True,-1,True);
  AddSetting(1002,LanguageSetup.GameDeveloper,GameDB.GetDeveloperList,True,-1,True);
  AddSetting(1003,LanguageSetup.GamePublisher,GameDB.GetPublisherList,True,-1,True);
  AddSetting(1004,LanguageSetup.GameYear,GameDB.GetYearList,True,-1,True);
  AddSetting(1005,LanguageSetup.GameLanguage,ExtLanguageList(GetCustomLanguageName(GameDB.GetLanguageList)),True,-1,True);
  AddSetting(1006,LanguageSetup.GameFavorite,nil,False,ValueWidth);
  St:=GetAllUserInfoKeys(GameDB);
  try
    AddSettingWithEdit(1007,LanguageSetup.ChangeProfilesFormSetUserInfo,St,True,ValueWidth);
    If St.Count>0 then AddSetting(1008,LanguageSetup.ChangeProfilesFormDelUserInfo,St,False,ValueWidth);
  finally
    St.Free;
  end;
  For J:=1 to 9 do begin
    AddSetting(1010+(J-1)*2,LanguageSetup.GameWWWName+' ('+IntToStr(J)+')',GameDB.GetWWWNameList,True,-1,True);
    AddSetting(1011+(J-1)*2,LanguageSetup.GameWWW+' ('+IntToStr(J)+')',GameDB.GetWWWList,True,-1,True);
  end;
  AddYesNoSetting(1100,LanguageSetup.CheckSumTurnOffForProfile);

  {DOSBox}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.GamePriorityLower);
    St.Add(LanguageSetup.GamePriorityNormal);
    St.Add(LanguageSetup.GamePriorityHigher);
    St.Add(LanguageSetup.GamePriorityHighest);
    AddSetting(2001,LanguageSetup.GamePriorityForeground,St,False,ValueWidth);
    St.Insert(0,LanguageSetup.GamePriorityPause);
    AddSetting(2002,LanguageSetup.GamePriorityBackground,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddYesNoSetting(2003,LanguageSetup.GameCloseDosBoxAfterGameExit);
  St:=TStringList.Create;
  try
    For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do St.Add(PrgSetup.DOSBoxSettings[I].Name);
    AddSetting(2004,LanguageSetup.GameDOSBoxVersionDefault,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddEditSetting(2005,LanguageSetup.GameDOSBoxVersionCustom,'',-1);

  {CPU}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorCPUSheet);
  AddSetting(3001,LanguageSetup.GameCore,ValueToList(GameDB.ConfOpt.Core,';,'),False,ValueWidth,True);
  AddSetting(3002,LanguageSetup.GameCPUType,ValueToList(GameDB.ConfOpt.CPUType,';,'),False,ValueWidth,True);
  AddSetting(3003,LanguageSetup.GameCycles,ValueToList(GameDB.ConfOpt.Cycles,';,'),False,ValueWidth,True);

  {Memory}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorMemorySheet);
  AddSetting(4001,LanguageSetup.GameMemory,ValueToList(GameDB.ConfOpt.Memory,';,'),False,ValueWidth,True);
  AddYesNoSetting(4002,LanguageSetup.GameXMS);
  AddYesNoSetting(4003,LanguageSetup.GameEMS);
  AddYesNoSetting(4004,LanguageSetup.GameUMB);
  AddYesNoSetting(4005,LanguageSetup.ProfileEditorLoadFix);
  AddSpinSetting(4006,LanguageSetup.ProfileEditorLoadFixMemory,1,512,ValueWidth,64);

  {Graphics}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorGraphicsSheet);
  AddSetting(5001,LanguageSetup.GameWindowResolution,ValueToList(GameDB.ConfOpt.ResolutionWindow,';,'),False,ValueWidth,True);
  AddSetting(5002,LanguageSetup.GameFullscreenResolution,ValueToList(GameDB.ConfOpt.ResolutionFullscreen,';,'),False,ValueWidth,True);
  AddYesNoSetting(5003,LanguageSetup.GameStartFullscreen);
  AddYesNoSetting(5004,LanguageSetup.GameUseDoublebuffering);
  AddYesNoSetting(5005,LanguageSetup.GameAspectCorrection);
  AddSetting(5006,LanguageSetup.GameRender,ValueToList(GameDB.ConfOpt.Render,';,'),False,ValueWidth,True);
  AddSetting(5007,LanguageSetup.GameVideoCard,ValueToList(GameDB.ConfOpt.Video,';,'),False,-1,True);
  AddSetting(5008,LanguageSetup.GameScale,ValueToList(GameDB.ConfOpt.Scale,';,'),False,-1,True);
  AddSpinSetting(5009,LanguageSetup.GameFrameskip,0,10,ValueWidth);
  If PrgSetup.AllowGlideSettings then begin

    St:=ValueToList(GameDB.ConfOpt.GlideEmulation,';,');
    try
      For I:=0 to St.Count-1 do begin
        S:=Trim(ExtUpperCase(St[I]));
        if S='FALSE' then St[I]:=LanguageSetup.Off;
        if S='TRUE' then St[I]:=LanguageSetup.On;
      end;
      AddSetting(5101,LanguageSetup.GameGlideEmulation,St,False,ValueWidth,False);
    finally
      St.Free;
    end;
    AddSetting(5102,LanguageSetup.GameGlideEmulationPort,ValueToList(GameDB.ConfOpt.GlideEmulationPort,';,'),True,ValueWidth,True);
    AddSetting(5103,LanguageSetup.GameGlideEmulationLFB,ValueToList(GameDB.ConfOpt.GlideEmulationLFB,';,'),False,ValueWidth,True);
  end;
  If PrgSetup.AllowVGAChipsetSettings then begin
    AddSetting(5301,LanguageSetup.GameVGAChipset,ValueToList(GameDB.ConfOpt.VGAChipsets,';,'),False,ValueWidth,True);
    AddSetting(5302,LanguageSetup.GameVideoRam,ValueToList(GameDB.ConfOpt.VGAVideoRAM,';,'),False,ValueWidth,True);
  end;
  If PrgSetup.AllowPixelShader then begin
    St:=GetPixelShaders(PrgSetup.DOSBoxSettings[0].DosBoxDir);
    AddSetting(5401,LanguageSetup.GamePixelShader,St,False,-1,True);
  end;
  If PrgSetup.AllowTextModeLineChange then begin
    AddSetting(5501,LanguageSetup.GameTextModeLines,ValueToList('25;28;50',';,'),False,ValueWidth,True);
  end;

  {Keyboard}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorKeyboardSheet);
  AddYesNoSetting(6001,LanguageSetup.GameUseScanCodes);
  AddSetting(6002,LanguageSetup.GameKeyboardLayout,ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'),False,-1,True);
  AddSetting(6003,LanguageSetup.GameKeyboardCodepage,ValueToList(GameDB.ConfOpt.Codepage,';,'),False,-1,True);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.DoNotChange);
    St.Add(LanguageSetup.Off);
    St.Add(LanguageSetup.On);
    AddSetting(6004,LanguageSetup.GameKeyboardNumLock,St,False,ValueWidth);
    AddSetting(6005,LanguageSetup.GameKeyboardCapsLock,St,False,ValueWidth);
    AddSetting(6006,LanguageSetup.GameKeyboardScrollLock,St,False,ValueWidth);
  finally
    St.Free;
  end;

  {Mouse}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorMouseSheet);
  AddYesNoSetting(7001,LanguageSetup.GameAutoLockMouse);
  AddSpinSetting(7002,LanguageSetup.GameMouseSensitivity,1,1000,ValueWidth,100);
  AddYesNoSetting(7003,LanguageSetup.GameForce2ButtonMouseMode);
  AddYesNoSetting(7004,LanguageSetup.GameSwapMouseButtons);

  {Sound}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundSheet);
  AddYesNoSetting(8001,LanguageSetup.ProfileEditorSoundEnableSound);
  AddSetting(8002,LanguageSetup.ProfileEditorSoundSampleRate,ValueToList(GameDB.ConfOpt.Rate,';,'),False,ValueWidth,True);
  AddSetting(8003,LanguageSetup.ProfileEditorSoundBlockSize,ValueToList(GameDB.ConfOpt.Blocksize,';,'),True,ValueWidth,True);
  St:=TStringList.Create;
  try
    with St do begin Add('1'); Add('5'); Add('10'); Add('15'); Add('20'); Add('25'); Add('30'); end;
    AddSetting(8004,LanguageSetup.ProfileEditorSoundPrebuffer,St,True,ValueWidth);
  finally
    St.Free;
  end;
  AddYesNoSetting(8005,LanguageSetup.ProfileEditorSoundMiscEnablePCSpeaker);
  AddSetting(8006,LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,ValueToList(GameDB.ConfOpt.PCRate,';,'),False,ValueWidth,True);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.ProfileEditorSoundMiscEnableTandyAuto);
    St.Add(LanguageSetup.On);
    St.Add(LanguageSetup.Off);
    AddSetting(8007,LanguageSetup.ProfileEditorSoundMiscEnableTandy,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddSetting(8008,LanguageSetup.ProfileEditorSoundMiscTandyRate,ValueToList(GameDB.ConfOpt.TandyRate,';,'),False,ValueWidth,True);
  AddYesNoSetting(8009,LanguageSetup.ProfileEditorSoundMiscEnableDisneySoundsSource);

  {Volume}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundVolumeSheet);
  AddSpinSetting(8051,LanguageSetup.ProfileEditorSoundMasterVolume+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8052,LanguageSetup.ProfileEditorSoundMasterVolume+' - '+LanguageSetup.Right,0,200,ValueWidth,100);
  AddSpinSetting(8053,LanguageSetup.ProfileEditorSoundMiscDisneySoundsSource+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8054,LanguageSetup.ProfileEditorSoundMiscDisneySoundsSource+' - '+LanguageSetup.Right,0,200,ValueWidth,100);
  AddSpinSetting(8055,LanguageSetup.ProfileEditorSoundMiscPCSpeaker+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8056,LanguageSetup.ProfileEditorSoundMiscPCSpeaker+' - '+LanguageSetup.Right,0,200,ValueWidth,100);
  AddSpinSetting(8057,LanguageSetup.ProfileEditorSoundGUS+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8058,LanguageSetup.ProfileEditorSoundGUS+' - '+LanguageSetup.Right,0,200,ValueWidth,100);
  AddSpinSetting(8059,LanguageSetup.ProfileEditorSoundSoundBlaster+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8060,LanguageSetup.ProfileEditorSoundSoundBlaster+' - '+LanguageSetup.Right,0,200,ValueWidth,100);
  AddSpinSetting(8061,LanguageSetup.ProfileEditorSoundFM+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8062,LanguageSetup.ProfileEditorSoundFM+' - '+LanguageSetup.Right,0,200,ValueWidth,100);
  AddSpinSetting(8063,LanguageSetup.ProfileEditorSoundCD+' - '+LanguageSetup.Left,0,200,ValueWidth,100);
  AddSpinSetting(8064,LanguageSetup.ProfileEditorSoundCD+' - '+LanguageSetup.Right,0,200,ValueWidth,100);

  {SoundBlaster}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundSoundBlaster);
  AddSetting(8101,LanguageSetup.ProfileEditorSoundSBType,ValueToList(GameDB.ConfOpt.Sblaster,';,'),False,ValueWidth,True);
  AddSetting(8102,LanguageSetup.ProfileEditorSoundSBAddress,ValueToList(GameDB.ConfOpt.SBBase,';,'),False,ValueWidth,True);
  AddSetting(8103,LanguageSetup.ProfileEditorSoundSBIRQ,ValueToList(GameDB.ConfOpt.IRQ,';,'),False,ValueWidth,True);
  AddSetting(8104,LanguageSetup.ProfileEditorSoundSBDMA,ValueToList(GameDB.ConfOpt.DMA,';,'),False,ValueWidth,True);
  AddSetting(8105,LanguageSetup.ProfileEditorSoundSBHDMA,ValueToList(GameDB.ConfOpt.HDMA,';,'),False,ValueWidth,True);
  AddSetting(8106,LanguageSetup.ProfileEditorSoundSBOplMode,ValueToList(GameDB.ConfOpt.Oplmode,';,'),False,ValueWidth,True);
  AddSetting(8107,LanguageSetup.GameOplemu,ValueToList(GameDB.ConfOpt.OPLEmu,';,'),False,ValueWidth,True);
  AddSetting(8108,LanguageSetup.ProfileEditorSoundSBOplRate,ValueToList(GameDB.ConfOpt.OPLRate,';,'),False,ValueWidth,True);
  AddYesNoSetting(8109,LanguageSetup.ProfileEditorSoundSBUseMixer);

  {GUS}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundGUS);
  AddYesNoSetting(8201,LanguageSetup.ProfileEditorSoundGUSEnabled);
  AddSetting(8202,LanguageSetup.ProfileEditorSoundGUSAddress,ValueToList(GameDB.ConfOpt.GUSBase,';,'),False,ValueWidth,True);
  AddSetting(8203,LanguageSetup.ProfileEditorSoundGUSRate,ValueToList(GameDB.ConfOpt.GUSRate,';,'),False,ValueWidth,True);
  AddSetting(8204,LanguageSetup.ProfileEditorSoundGUSIRQ,ValueToList(GameDB.ConfOpt.GUSIRQ,';,'),False,ValueWidth,True);
  AddSetting(8205,LanguageSetup.ProfileEditorSoundGUSDMA,ValueToList(GameDB.ConfOpt.GUSDma,';,'),False,ValueWidth,True);
  AddEditSetting(8206,LanguageSetup.ProfileEditorSoundGUSPath,'C:\ULTRASND',-1);

  {MIDI}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundMIDI);
  AddSetting(8301,LanguageSetup.ProfileEditorSoundMIDIType,ValueToList(GameDB.ConfOpt.MPU401,';,'),False,ValueWidth,True);
  AddSetting(8302,LanguageSetup.ProfileEditorSoundMIDIDevice,ValueToList(GameDB.ConfOpt.MIDIDevice,';,'),False,ValueWidth,True);
  AddEditSetting(8303,LanguageSetup.ProfileEditorSoundMIDIConfigInfo,'',-1);

  If DefaultValueOnList(GameDB.ConfOpt.MIDIDevice,'mt32') then begin
    AddSetting(8351,'MT32 '+LanguageSetup.ProfileEditorSoundMIDIMT32Mode,ValueToList(GameDB.ConfOpt.MT32ReverbMode,';,'),False,ValueWidth,True);
    AddSetting(8352,'MT32 '+LanguageSetup.ProfileEditorSoundMIDIMT32Time,ValueToList(GameDB.ConfOpt.MT32ReverbTime,';,'),False,ValueWidth,True);
    AddSetting(8353,'MT32 '+LanguageSetup.ProfileEditorSoundMIDIMT32Level,ValueToList(GameDB.ConfOpt.MT32ReverbLevel,';,'),False,ValueWidth,True);
  end;

  {Innova}
  If PrgSetup.AllowInnova then begin
    AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundInnova);
    AddYesNoSetting(8401,LanguageSetup.ProfileEditorSoundInnovaEnable);
    AddSetting(8402,LanguageSetup.ProfileEditorSoundInnovaSampleRate,ValueToList(GameDB.ConfOpt.InnovaEmulationSampleRate,';,'),False,ValueWidth,True);
    AddSetting(8403,LanguageSetup.ProfileEditorSoundInnovaBaseAddress,ValueToList(GameDB.ConfOpt.InnovaEmulationBaseAddress,';,'),False,ValueWidth,True);
    AddSetting(8404,LanguageSetup.ProfileEditorSoundInnovaQuality,ValueToList(GameDB.ConfOpt.InnovaEmulationQuality,';,'),False,ValueWidth,True);
  end;

  {Joystick}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.GameJoysticks);
  AddSetting(9001,LanguageSetup.ProfileEditorSoundJoystickType,ValueToList(GameDB.ConfOpt.Joysticks,';,'),False,ValueWidth,True);
  AddYesNoSetting(9002,LanguageSetup.ProfileEditorSoundJoystickTimed);
  AddYesNoSetting(9003,LanguageSetup.ProfileEditorSoundJoystickAutoFire);
  AddYesNoSetting(9004,LanguageSetup.ProfileEditorSoundJoystickSwap34);
  AddYesNoSetting(9005,LanguageSetup.ProfileEditorSoundJoystickButtonwrap);

  {Mounting}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorMountingSheet);
  AddReplaceMountingSetting(10000,LanguageSetup.ChangeProfilesReplaceFolder,LanguageSetup.ChangeProfilesReplaceFolderFrom,LanguageSetup.ChangeProfilesReplaceFolderTo);
  AddYesNoSetting(10001,LanguageSetup.ProfileEditorMountingAutoMountCDsShort);
  AddYesNoSetting(10002,LanguageSetup.ProfileEditorMountingSecureModeShort);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.ChangeProfilesMountingChangeSettingsGlobal);
    St.Add(LanguageSetup.ChangeProfilesMountingChangeSettingsLocal);
    AddSetting(10003,LanguageSetup.ChangeProfilesMountingChangeSettings,St,False,-1);
  finally
    St.Free;
  end;

  {DOS environment}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorDOSEnvironmentSheet);
  AddSetting(11001,LanguageSetup.GameReportedDOSVersion,ValueToList(GameDB.ConfOpt.ReportedDOSVersion,';,'),True,ValueWidth,True);
  AddYesNoSetting(11002,LanguageSetup.ProfileEditorAutoexecUse4DOS);

  {Starting}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorStartingSheet);
  AddYesNoSetting(12001,LanguageSetup.ProfileEditorAutoexecOverrideGameStart);
  AddYesNoSetting(12002,LanguageSetup.ProfileEditorAutoexecOverrideMounting);

  {Network}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorNetworkSheet);
  AddYesNoSetting(12501,LanguageSetup.GameIPX);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.GameIPXEstablishConnectionNone);
    St.Add(LanguageSetup.GameIPXEstablishConnectionClient);
    St.Add(LanguageSetup.GameIPXEstablishConnectionServer);
    AddSetting(12502,LanguageSetup.GameIPXEstablishConnection,St,False,ValueWidth,False);
  finally
    St.Free;
  end;
  AddEditSetting(12503,LanguageSetup.GameIPXAddress,'',-1);
  AddSpinSetting(12504,LanguageSetup.GameIPXPort,1,65535,ValueWidth);
  If PrgSetup.AllowNe2000 then begin
    AddYesNoSetting(12601,LanguageSetup.GameNE2000);
    AddSetting(12602,LanguageSetup.GameNE2000BaseAddress,ValueToList(GameDB.ConfOpt.NE2000EmulationBaseAddress,';,'),True,ValueWidth,True);
    AddSetting(12603,LanguageSetup.GameNE2000Interrupt,ValueToList(GameDB.ConfOpt.NE2000EmulationInterrupt,';,'),True,ValueWidth,True);
    AddEditSetting(12604,LanguageSetup.GameNE2000MACAddress,'AC:DE:48:88:99:AA',-1);
    AddEditSetting(12605,LanguageSetup.GameNE2000RealInterface,'',-1);
  end;

  {ScummVM}
  AddCaption(LanguageSetup.ProfileEditorScummVMSheet);
  AddSetting(13001,LanguageSetup.ProfileEditorScummVMPlatform,ValueToList(GameDB.ConfOpt.ScummVMPlatform,';,'),False,ValueWidth,True);
  AddSetting(13002,LanguageSetup.ProfileEditorScummVMFilter,ValueToList(GameDB.ConfOpt.ScummVMFilter,';,'),False,-1,True);
  AddSetting(13003,LanguageSetup.ProfileEditorScummVMRenderMode,ValueToList(GameDB.ConfOpt.ScummVMRenderMode,';,'),False,ValueWidth,True);
  AddYesNoSetting(13004,LanguageSetup.GameStartFullscreen);
  AddYesNoSetting(13005,LanguageSetup.GameAspectCorrection);
  AddEditSetting(13006,LanguageSetup.ProfileEditorScummVMCommandLine,'',-1);
  AddYesNoSetting(13007,LanguageSetup.ProfileEditorScummVMSubtitles);
  AddYesNoSetting(13008,LanguageSetup.ProfileEditorScummVMConfirmExit);
  AddSpinSetting(13009,LanguageSetup.ProfileEditorScummVMAutosave,1,86400,ValueWidth);
  AddSpinSetting(13010,LanguageSetup.ProfileEditorScummVMTextSpeed,1,1000,ValueWidth);

  {ScummVM sound}
  AddCaption(LanguageSetup.ProfileEditorScummVMSheet+' - '+LanguageSetup.ProfileEditorSoundSheet);
  AddSpinSetting(14001,LanguageSetup.ProfileEditorScummVMMusicVolume,0,255,ValueWidth,192);
  AddSpinSetting(14002,LanguageSetup.ProfileEditorScummVMSpeechVolume,0,255,ValueWidth,192);
  AddSpinSetting(14003,LanguageSetup.ProfileEditorScummVMSFXVolume,0,255,ValueWidth,192);
  AddSpinSetting(14004,LanguageSetup.ProfileEditorScummVMMIDIGain,0,1000,ValueWidth,100);
  St:=TStringList.Create;
  try
    with St do begin Add('11025'); Add('22050'); Add('44100'); end;
    AddSetting(14005,LanguageSetup.ProfileEditorSoundSampleRate,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddYesNoSetting(14006,LanguageSetup.ProfileEditorScummVMSpeechMute);
end;

Procedure TMultipleProfilesEditorForm.CaptionClick(Sender : TObject);
Var I,J,K,C,LastY,VertScrollBarPos : Integer;
    B : TBitmap;
begin
  VertScrollBarPos:=ScrollBox.VertScrollBar.Position;
  ScrollBox.AutoScroll:=False;

  If Sender<>nil then Sections[(Sender as TComponent).Tag].Open:=not Sections[(Sender as TComponent).Tag].Open;

  LastY:=0;

  For I:=0 to length(Sections)-1 do begin
    B:=Sections[I].Image.Picture.Bitmap;
    B.Width:=0; B.Height:=0;
    If Sections[I].Open then ImageList.GetBitmap(2,B) else ImageList.GetBitmap(1,B);

    Sections[I].Caption.Top:=LastY;
    Sections[I].Image.Top:=LastY+2;
    inc(LastY,Sections[I].Caption.Height+2);

    Sections[I].Info.Visible:=not Sections[I].Open;
    If Sections[I].Open then begin
      For J:=0 to length(Sections[I].Settings)-1 do begin
        Sections[I].Settings[J].CheckBox.Top:=LastY+Sections[I].Settings[J].RelTop;
        Sections[I].Settings[J].CheckBox.Visible:=True;
        For K:=0 to length(Sections[I].Settings[J].Values)-1 do begin
          Sections[I].Settings[J].Values[K].Control.Top:=LastY+Sections[I].Settings[J].Values[K].RelTop;
          Sections[I].Settings[J].Values[K].Control.Visible:=True;
        end;
      end;
      inc(LastY,Sections[I].LastRelY+8);
    end else begin
      Sections[I].Info.Top:=LastY;
      inc(LastY,Sections[I].Info.Height+6);
      C:=0; For J:=0 to length(Sections[I].Settings)-1 do If Sections[I].Settings[J].CheckBox.Checked then inc(C);
      Sections[I].Info.Caption:=Format(LanguageSetup.ChangeProfilesSectionInfo,[C,length(Sections[I].Settings)]);
      For J:=0 to length(Sections[I].Settings)-1 do begin
        Sections[I].Settings[J].CheckBox.Visible:=False;
        For K:=0 to length(Sections[I].Settings[J].Values)-1 do Sections[I].Settings[J].Values[K].Control.Visible:=False;
      end;
    end;
  end;

  ScrollBox.AutoScroll:=True;
  ScrollBox.VertScrollBar.Position:=VertScrollBarPos;
end;

procedure TMultipleProfilesEditorForm.CheckBoxClick(Sender: TObject);
Var I,J,K : Integer;
begin
  For I:=0 to length(Sections)-1 do For J:=0 to length(Sections[I].Settings)-1 do For K:=0 to length(Sections[I].Settings[J].Values)-1 do
    Sections[I].Settings[J].Values[K].Control.Enabled:=Sections[I].Settings[J].CheckBox.Checked;
end;

procedure TMultipleProfilesEditorForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

procedure TMultipleProfilesEditorForm.ComboBoxDropDown(Sender: TObject);
begin
  If Sender is TComboBox then SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TMultipleProfilesEditorForm.ComboBoxChange(Sender: TObject);
begin
  If Sender is TComboBox then SetComboHint(Sender as TComboBox);
end;

Procedure TMultipleProfilesEditorForm.SelectFolderButtonClick(Sender: TObject);
Var I,J,Nr1,Nr2 : Integer;
    S : String;
begin
  Nr1:=-1; Nr2:=-1;
  For I:=0 to length(Sections)-1 do For J:=0 to length(Sections[I].Settings)-1 do If Sections[I].Settings[J].ID=(Sender as TControl).Tag then begin Nr1:=I; Nr2:=J; break; end;
  If Nr1<0 then exit;

  S:=Trim(TEdit(Sections[Nr1].Settings[Nr2].Values[1].Control).Text);
  If S='' then S:=PrgSetup.GameDir;
  If S='' then S:=PrgSetup.BaseDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  If not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  TEdit(Sections[Nr1].Settings[Nr2].Values[1].Control).Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TMultipleProfilesEditorForm.OKButtonClick(Sender: TObject);
Var Nr1,Nr2 : Integer;
Function ValueActive(const ID : Integer) : Boolean;
Var I,J : Integer;
begin
  result:=False;
  For I:=0 to length(Sections)-1 do For J:=0 to length(Sections[I].Settings)-1 do If Sections[I].Settings[J].ID=ID then begin
    If Sections[I].Settings[J].CheckBox.Checked then begin Nr1:=I; Nr2:=J; result:=True; end;
    break;
  end;
end;
Function GetControl(const Nr : Integer) : TControl; begin result:=Sections[Nr1].Settings[Nr2].Values[Nr].Control; end;
Function GetComboIndex : Integer; begin result:=TComboBox(GetControl(0)).ItemIndex; end;
Function GetComboText : String; begin result:=TComboBox(GetControl(0)).Text; end;
Function GetEditText : String; begin result:=TEdit(GetControl(0)).Text; end;
Function GetYesNo : Boolean; begin result:=(TComboBox(GetControl(0)).ItemIndex=1); end;
Function GetSpinValue : Integer; begin result:=TSpinEdit(GetControl(0)).Value; end;
Var I,J : Integer;
    G : TGame;
    ScummVM,WindowsMode,B : Boolean;
    St : TStringList;
    S : String;
begin
  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    ScummVM:=ScummVMMode(G);
    WindowsMode:=WindowsExeMode(G);

    {Game info}
    If ValueActive(1001) then G.Genre:=GetEnglishGenreName(GetComboText);
    If ValueActive(1002) then G.Developer:=GetComboText;
    If ValueActive(1003) then G.Publisher:=GetComboText;
    If ValueActive(1004) then G.Year:=GetComboText;
    If ValueActive(1005) then G.Language:=GetEnglishLanguageName(GetComboText);
    If ValueActive(1006) then G.Favorite:=GetYesNo;
    If ValueActive(1007) then SetUserInfo(G,GetComboText,TEdit(GetControl(1)).Text);
    If ValueActive(1008) then DelUserInfo(G,GetComboText);
    For J:=1 to 9 do begin
      If ValueActive(1010+(J-1)*2) then G.WWWName[J]:=GetComboText;
      If ValueActive(1011+(J-1)*2) then G.WWW[J]:=GetComboText;
    end;
    If ValueActive(1100) then begin
      B:=GetYesNo;
      if B then G.GameExeMD5:='OFF' else begin if G.GameExeMD5='OFF' then G.GameExeMD5:=''; end;
      if B then G.SetupExeMD5:='OFF' else begin if G.SetupExeMD5='OFF' then G.SetupExeMD5:=''; end;
    end;

    If (not ScummVM) and (not WindowsMode) then begin

      {DOSBox}
      If ValueActive(2001) then begin
        St:=ValueToList(G.Priority,',');
        try While St.Count<2 do St.Add(''); St[0]:=PriorityForeground[Max(0,Min(3,GetComboIndex))]; G.Priority:=ListToValue(St,','); finally St.Free; end;
      end;
      If ValueActive(2002) then begin
        St:=ValueToList(G.Priority,',');
        try While St.Count<2 do St.Add(''); St[1]:=PriorityBackground[Max(0,Min(4,GetComboIndex))];
         G.Priority:=ListToValue(St,',');
         finally St.Free; end;
      end;
      If ValueActive(2003) then G.CloseDosBoxAfterGameExit:=GetYesNo;
      If ValueActive(2004) then G.CustomDOSBoxDir:=GetComboText;
      If ValueActive(2005) then G.CustomDOSBoxDir:=GetEditText;

      {CPU}
      If ValueActive(3001) then G.Core:=GetComboText;
      If ValueActive(3002) then G.CPUType:=GetComboText;
      If ValueActive(3003) then G.Cycles:=GetComboText;

      {Memory}
      If ValueActive(4001) then begin
        try J:=Min(63,Max(1,StrToInt(GetComboText))); except J:=32; end; G.Memory:=J;
      end;
      If ValueActive(4002) then G.XMS:=GetYesNo;
      If ValueActive(4003) then G.EMS:=GetYesNo;
      If ValueActive(4004) then G.UMB:=GetYesNo;
      If ValueActive(4005) then G.LoadFix:=GetYesNo;
      If ValueActive(4006) then G.LoadFixMemory:=Max(1,Min(512,GetSpinValue));

      {Graphics}
      If ValueActive(5001) then G.WindowResolution:=GetComboText;
      If ValueActive(5002) then G.FullscreenResolution:=GetComboText;
      If ValueActive(5003) then G.StartFullscreen:=GetYesNo;
      If ValueActive(5004) then G.UseDoublebuffering:=GetYesNo;
      If ValueActive(5005) then G.AspectCorrection:=GetYesNo;

      If ValueActive(5006) then G.Render:=GetComboText;
      If ValueActive(5007) then begin
        S:=GetComboText;
        If Pos('(',S)>0 then S:=Trim(Copy(S,1,Pos('(',S)-1));
        G.VideoCard:=S;
      end;
      If ValueActive(5008) then begin
        S:=GetComboText;
        If Pos('(',S)=0 then G.Scale:='' else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt); If Pos(')',S)=0 then G.Scale:=''  else G.Scale:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      If ValueActive(5009) then G.FrameSkip:=Max(0,Min(10,GetSpinValue));
      If PrgSetup.AllowGlideSettings then begin
        If ValueActive(5101) then begin
          S:=GetComboText;
          If S=LanguageSetup.On then S:='true';
          If S=LanguageSetup.Off then S:='false';
          G.GlideEmulation:=S;
        end;
        If ValueActive(5102) then G.GlidePort:=GetComboText;
        If ValueActive(5103) then G.GlideLFB:=GetComboText;
      end;
      If PrgSetup.AllowVGAChipsetSettings then begin
        If ValueActive(5301) then G.VGAChipset:=GetComboText;
        If ValueActive(5302) then begin try J:=StrToInt(GetComboText); except J:=512; end; G.VideoRam:=J; end;
      end;
      If PrgSetup.AllowPixelShader then begin
        If ValueActive(5401) then G.PixelShader:=GetComboText;
      end;
      If PrgSetup.AllowTextModeLineChange then begin
        If ValueActive(5501) then begin try J:=StrToInt(GetComboText); except J:=25; end; G.TextModeLines:=J; end;
      end;

      {Keyboard}
      If ValueActive(6001) then G.UseScanCodes:=GetYesNo;
      If ValueActive(6002) then G.KeyboardLayout:=GetComboText;
      If ValueActive(6003) then G.Codepage:=GetComboText;
      If ValueActive(6004) then Case GetComboIndex of
        0 : G.NumLockStatus:='';
        1 : G.NumLockStatus:='off';
        2 : G.NumLockStatus:='on';
      end;
      If ValueActive(6005) then Case GetComboIndex of
        0 : G.CapsLockStatus:='';
        1 : G.CapsLockStatus:='off';
        2 : G.CapsLockStatus:='on';
      end;
      If ValueActive(6006) then Case GetComboIndex of
        0 : G.ScrollLockStatus:='';
        1 : G.ScrollLockStatus:='off';
        2 : G.ScrollLockStatus:='on';
      end;

      {Mouse}
      If ValueActive(7001) then G.AutoLockMouse:=GetYesNo;
      If ValueActive(7002) then G.MouseSensitivity:=Max(1,Min(1000,GetSpinValue));
      If ValueActive(7003) then G.Force2ButtonMouseMode:=GetYesNo;
      If ValueActive(7004) then G.SwapMouseButtons:=GetYesNo;

      {Sound}
      If ValueActive(8001) then G.MixerNosound:=not GetYesNo;

      If ValueActive(8002) then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=22050; end; G.MixerRate:=J; end;
      If ValueActive(8003) then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=2048; end; G.MixerBlocksize:=J; end;
      If ValueActive(8004) then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=10; end; G.MixerPrebuffer:=J; end;
      If ValueActive(8005) then G.SpeakerPC:=GetYesNo;
      If ValueActive(8006) then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=10; end; G.SpeakerRate:=J; end;
      If ValueActive(8007) then Case GetComboIndex of
        0 : G.SpeakerTandy:='auto';
        1 : G.SpeakerTandy:='on';
        2 : G.SpeakerTandy:='off';
      end;
      If ValueActive(8006) then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=10; end; G.SpeakerTandyRate:=J; end;
      If ValueActive(8009) then G.SpeakerDisney:=GetYesNo;

      {Volume}
      If ValueActive(8051) then G.MixerVolumeMasterLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8052) then G.MixerVolumeMasterRight:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8053) then G.MixerVolumeDisneyLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8054) then G.MixerVolumeDisneyRight:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8055) then G.MixerVolumeSpeakerLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8056) then G.MixerVolumeSpeakerRight:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8057) then G.MixerVolumeGUSLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8058) then G.MixerVolumeGUSRight:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8059) then G.MixerVolumeSBLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8060) then G.MixerVolumeSBRight:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8061) then G.MixerVolumeFMLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8062) then G.MixerVolumeFMRight:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8063) then G.MixerVolumeCDLeft:=Max(0,Min(200,GetSpinValue));
      If ValueActive(8064) then G.MixerVolumeCDRight:=Max(0,Min(200,GetSpinValue));

      {SoundBlaster}
      If ValueActive(8101) then G.SBType:=GetComboText;
      If ValueActive(8102) then G.SBBase:=GetComboText;
      If ValueActive(8103) then begin try J:=StrToInt(GetComboText); except J:=7; end; G.SBIRQ:=J; end;
      If ValueActive(8104) then begin try J:=StrToInt(GetComboText); except J:=1; end; G.SBDMA:=J; end;
      If ValueActive(8105) then begin try J:=StrToInt(GetComboText); except J:=5; end; G.SBHDMA:=J; end;
      If ValueActive(8106) then G.SBOplMode:=GetComboText;
      If ValueActive(8107) then G.SBOplEmu:=GetComboText;
      If ValueActive(8108) then begin try J:=StrToInt(GetComboText); except J:=22050; end; G.SBOplRate:=J; end;
      If ValueActive(8109) then G.SBMixer:=GetYesNo;

      {GUS}
      If ValueActive(8201) then G.GUS:=GetYesNo;
      If ValueActive(8202) then G.GUSBase:=GetComboText;
      If ValueActive(8203) then begin try J:=StrToInt(GetComboText); except J:=22050; end; G.GUSRate:=J; end;
      If ValueActive(8204) then begin try J:=StrToInt(GetComboText); except J:=5; end; G.GUSIRQ:=J; end;
      If ValueActive(8205) then begin try J:=StrToInt(GetComboText); except J:=1; end; G.GUSDMA:=J; end;
      If ValueActive(8206) then G.GUSUltraDir:=GetEditText;

      {MIDI}
      If ValueActive(8301) then G.MIDIType:=GetComboText;
      If ValueActive(8302) then G.MIDIDevice:=GetComboText;
      If ValueActive(8303) then G.MIDIConfig:=GetEditText;

      If DefaultValueOnList(GameDB.ConfOpt.MIDIDevice,'mt32') then begin
        If ValueActive(8351) then G.MIDIMT32Mode:=GetComboText;
        If ValueActive(8352) then G.MIDIMT32Time:=GetComboText;
        If ValueActive(8353) then G.MIDIMT32Level:=GetComboText;
      end;

      {Innova}
      If PrgSetup.AllowInnova then begin
        If ValueActive(8401) then G.Innova:=GetYesNo;
        If ValueActive(8402) then begin If TryStrToInt(GetComboText,J) then G.InnovaRate:=J; end;
        If ValueActive(8403) then G.InnovaBase:=GetComboText;
        If ValueActive(8404) then begin If TryStrToInt(GetComboText,J) then G.InnovaQuality:=J; end;
      end;

      {Joystick}
      If ValueActive(9001) then G.JoystickType:=GetComboText;
      If ValueActive(9002) then G.JoystickTimed:=GetYesNo;
      If ValueActive(9003) then G.JoystickAutoFire:=GetYesNo;
      If ValueActive(9004) then G.JoystickSwap34:=GetYesNo;
      If ValueActive(9005) then G.JoystickButtonwrap:=GetYesNo;

      {Mounting}
      If ValueActive(10000) then ReplaceFolderWork(G,TComboBox(GetControl(0)).Text,TEdit(GetControl(1)).Text);
      If ValueActive(10001) then G.AutoMountCDs:=GetYesNo;
      If ValueActive(10002) then G.SecureMode:=GetYesNo;
      If ValueActive(10003) then ChangeMountSetting(G,GetComboIndex=0);

      {DOS environment}
      If ValueActive(11001) then G.ReportedDOSVersion:=GetComboText;
      If ValueActive(11002) then G.Use4DOS:=GetYesNo;

      {Starting}
      If ValueActive(12001) then G.AutoexecOverridegamestart:=GetYesNo;
      If ValueActive(12002) then G.AutoexecOverrideMount:=GetYesNo;

      {Network}
      If ValueActive(12501) then G.IPX:=GetYesNo;
      If ValueActive(12502) then Case GetComboIndex of
        0 : G.IPXType:='none';
        1 : G.IPXType:='client';
        2 : G.IPXType:='server';
      end;
      If ValueActive(12503) then G.IPXAddress:=GetEditText;
      If ValueActive(12504) then G.IPXPort:=IntToStr(GetSpinValue);
      If PrgSetup.AllowNe2000 then begin
        If ValueActive(12601) then G.NE2000:=GetYesNo;
        If ValueActive(12602) then G.NE2000Base:=GetComboText;
        If ValueActive(12603) then begin If TryStrToInt(GetComboText,J) then G.NE2000IRQ:=J; end;
        If ValueActive(12604) then G.NE2000MACAddress:=GetEditText;
        If ValueActive(12605) then G.NE2000RealInterface:=GetEditText;
      end;
    end;

    If ScummVM then begin
      {ScummVM}
      If ValueActive(13001) then G.ScummVMPlatform:=GetComboText;
      If ValueActive(13002) then begin
        S:=GetComboText;
        If Pos('(',S)=0 then G.ScummVMFilter:='' else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt);
          If Pos(')',S)=0 then G.ScummVMFilter:=''  else G.ScummVMFilter:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      If ValueActive(13003) then begin
        S:=GetComboText;
        If Pos('(',S)=0 then G.ScummVMRenderMode:=S else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt);
          If Pos(')',S)=0 then G.ScummVMRenderMode:=GetComboText else G.ScummVMRenderMode:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      If ValueActive(13004) then G.StartFullscreen:=GetYesNo;
      If ValueActive(13005) then G.AspectCorrection:=GetYesNo;
      If ValueActive(13006) then G.ScummVMParameters:=GetEditText;
      If ValueActive(13007) then G.ScummVMSubtitles:=GetYesNo;
      If ValueActive(13008) then G.ScummVMConfirmExit:=GetYesNo;
      If ValueActive(13009) then G.ScummVMAutosave:=GetSpinValue;
      If ValueActive(13010) then G.ScummVMTalkSpeed:=GetSpinValue;

      {ScummVM sound}
      If ValueActive(14001) then G.ScummVMMusicVolume:=GetSpinValue;
      If ValueActive(14002) then G.ScummVMSpeechVolume:=GetSpinValue;
      If ValueActive(14003) then G.ScummVMSFXVolume:=GetSpinValue;
      If ValueActive(14004) then G.ScummVMMIDIGain:=GetSpinValue;
      If ValueActive(14005) then G.ScummVMSampleRate:=StrToInt(GetComboText);
      If ValueActive(14006) then G.ScummVMSpeechMute:=GetYesNo;
    end;
  end;

  GameDB.StoreAllValues;
  GameDB.LoadCache;
end;

procedure TMultipleProfilesEditorForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasEditMultipleProfiles);
end;

procedure TMultipleProfilesEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TMultipleProfilesEditorForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
Var B : Boolean;
    C : TControl;
begin
  B:=(Screen.ActiveControl=ScrollBox) or ((Screen.ActiveControl<>nil) and (Screen.ActiveControl.Parent=ScrollBox));
  If (not B) and (PageControl.ActivePageIndex=1) then begin
    C:=ScrollBox.Parent.ControlAtPos(ScrollBox.Parent.ScreenToClient(MousePos),False,True);
    B:=(C=ScrollBox) or ((C<>nil) and (C.Parent=ScrollBox));
  end;
  If B then ScrollBox.VertScrollBar.Position:=Max(0,ScrollBox.VertScrollBar.Position-ScrollBox.VertScrollBar.Increment);
end;

procedure TMultipleProfilesEditorForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
Var B : Boolean;
    C : TControl;
begin
  B:=(Screen.ActiveControl=ScrollBox) or ((Screen.ActiveControl<>nil) and (Screen.ActiveControl.Parent=ScrollBox));
  If (not B) and (PageControl.ActivePageIndex=1) then begin
    C:=ScrollBox.Parent.ControlAtPos(ScrollBox.Parent.ScreenToClient(MousePos),False,True);
    B:=(C=ScrollBox) or ((C<>nil) and (C.Parent=ScrollBox));
  end;
  If B then ScrollBox.VertScrollBar.Position:=Min(ScrollBox.VertScrollBar.Range,ScrollBox.VertScrollBar.Position+ScrollBox.VertScrollBar.Increment);
end;

{ global }

Function ShowMultipleProfilesEditorDialog(const AOwner : TComponent; const AGameDB : TGameDB; const TemplateMode : Boolean) : Boolean;
begin
  MultipleProfilesEditorForm:=TMultipleProfilesEditorForm.Create(AOwner);
  try
    MultipleProfilesEditorForm.GameDB:=AGameDB;
    MultipleProfilesEditorForm.TemplateMode:=TemplateMode;
    result:=(MultipleProfilesEditorForm.ShowModal=mrOK);
  finally
    MultipleProfilesEditorForm.Free;
  end;
end;

end.
