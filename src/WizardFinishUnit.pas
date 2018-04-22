unit WizardFinishUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, GameDBUnit, ComCtrls, Buttons, ImgList, Menus;

type
  TWizardFinishFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    DriveSetupLabel: TLabel;
    MountingListView: TListView;
    ProfileEditorCheckBox: TCheckBox;
    ProfileEditorLabel: TLabel;
    MountingAddButton: TBitBtn;
    MountingEditButton: TBitBtn;
    MountingDelButton: TBitBtn;
    MountingDeleteAllButton: TBitBtn;
    MountingAutoCreateButton: TBitBtn;
    PopupMenu: TPopupMenu;
    PopupAdd: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDelete: TMenuItem;
    ImageList: TImageList;
    procedure MountingListViewDblClick(Sender: TObject);
    procedure MountingListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    Mounting, MountingSave : TStringList;
    CurrentGameFile, CurrentGameName : String;
    GameDB : TGameDB;
    function NextFreeDriveLetter: Char;
    function UsedDriveLetters(const AllowedNr : Integer = -1): String;
    procedure LoadMountingList;
  public
    { Public-Deklarationen }
    Procedure Init(const AGameDB : TGameDB);
    Procedure Done;
    Procedure SetInsecureStatus(const Insecure : Boolean);
    procedure LoadData(const Template: TGame; const GameFile, SetupFile, GameName : String);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     ProfileMountEditorFormUnit, GameDBToolsUnit, IconLoaderUnit;

{$R *.dfm}

{ TWizardFinishFrame }

procedure TWizardFinishFrame.Init(const AGameDB: TGameDB);
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  ProfileEditorLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage5Info;
  DriveSetupLabel.Caption:=LanguageSetup.WizardFormDriveSetupLabel;
  MountingAddButton.Caption:=LanguageSetup.ProfileEditorMountingAdd;
  MountingEditButton.Caption:=LanguageSetup.ProfileEditorMountingEdit;
  MountingDelButton.Caption:=LanguageSetup.ProfileEditorMountingDel;
  MountingDeleteAllButton.Caption:=LanguageSetup.ProfileEditorMountingDelAll;
  MountingAutoCreateButton.Caption:=LanguageSetup.ProfileEditorMountingAutoCreate;
  InitMountingListView(MountingListView);
  ProfileEditorCheckBox.Caption:=LanguageSetup.WizardFormOpenProfileEditor;
  ProfileEditorLabel.Caption:=LanguageSetup.WizardFormOpenProfileEditorInfo;
  UserIconLoader.DialogImage(DI_Add,MountingAddButton);
  UserIconLoader.DialogImage(DI_Edit,MountingEditButton);
  UserIconLoader.DialogImage(DI_Delete,MountingDelButton);
  UserIconLoader.DialogImage(DI_Wizard,MountingAutoCreateButton);

  PopupAdd.Caption:=LanguageSetup.ProfileEditorMountingAdd;
  PopupEdit.Caption:=LanguageSetup.ProfileEditorMountingEdit;
  PopupDelete.Caption:=LanguageSetup.ProfileEditorMountingDel;
  PopupEdit.ShortCut:=ShortCut(VK_Return,[]);
  UserIconLoader.DialogImage(DI_Add,ImageList,0);
  UserIconLoader.DialogImage(DI_Edit,ImageList,1);
  UserIconLoader.DialogImage(DI_Delete,ImageList,2);

  Mounting:=TStringList.Create;
  MountingSave:=TStringList.Create;

  GameDB:=AGameDB;
end;

procedure TWizardFinishFrame.Done;
begin
  Mounting.Free;
  MountingSave.Free;
end;

procedure TWizardFinishFrame.SetInsecureStatus(const Insecure: Boolean);
begin
  If Insecure then begin
    ProfileEditorCheckBox.Checked:=True;
    ProfileEditorCheckBox.Enabled:=False;
    ProfileEditorLabel.Visible:=True;
  end else begin
    ProfileEditorCheckBox.Enabled:=True;
    ProfileEditorLabel.Visible:=False;
  end;
end;

Function ShortName(const LongName : String) : String;
begin
  SetLength(result,MAX_PATH+10);
  if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
    then result:=LongName
    else SetLength(result,StrLen(PChar(result)));
end;

procedure TWizardFinishFrame.LoadData(const Template: TGame; const GameFile, SetupFile, GameName : String);
Var S,T : String;
begin
  CurrentGameName:=GameName;
  CurrentGameFile:=GameFile;

  Mounting.Free;
  If Trim(GameFile)<>'' then S:=ExtractFilePath(GameFile) else S:='';
  If ExtUpperCase(Copy(Trim(S),1,7))='DOSBOX:' then S:='';
  If Trim(SetupFile)<>'' then T:=ExtractFilePath(SetupFile) else T:='';
  If ExtUpperCase(Copy(Trim(T),1,7))='DOSBOX:' then T:='';
  Mounting:=BuildGameDirMountData(Template,S,T);

  MountingSave.Assign(Mounting);
  LoadMountingList;
end;

procedure TWizardFinishFrame.LoadMountingList;
begin
  LoadMountingListView(MountingListView,Mounting);
end;

function TWizardFinishFrame.NextFreeDriveLetter: Char;
Var I : Integer;
    B : Boolean;
    St : TStringList;
begin
  result:='C';
  repeat
    B:=True;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        If St.Count<3 then continue;
        if UpperCase(St[2])=result then begin inc(result); B:=False; break; end;
      finally
        St.Free;
      end;
    end;
  until B;
end;

function TWizardFinishFrame.UsedDriveLetters(const AllowedNr : Integer): String;
Var I : Integer;
    St : TStringList;
begin
  result:='';
  For I:=0 to Mounting.Count-1 do If I<>AllowedNr then begin
    St:=ValueToList(Mounting[I]);
    try
      If St.Count>=3 then result:=result+UpperCase(St[2]);
    finally
      St.Free;
    end;
  end;
end;

procedure TWizardFinishFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : If Mounting.Count<10 then begin
          S:='';
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters,IncludeTrailingPathDelimiter(ExtractFilePath(CurrentGameFile)),CurrentGameName,GameDB,nil,NextFreeDriveLetter) then exit;
          Mounting.Add(S);
          LoadMountingList;
          MountingListView.ItemIndex:=MountingListView.Items.Count-1;
        end;
    1 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          S:=Mounting[I];
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters(I),IncludeTrailingPathDelimiter(ExtractFilePath(CurrentGameFile)),CurrentGameName,GameDB) then exit;
          Mounting[I]:=S;
          LoadMountingList;
          MountingListView.ItemIndex:=I;
        end;
    2 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          Mounting.Delete(I);
          LoadMountingList;
          If Mounting.Count>0 then MountingListView.ItemIndex:=Max(0,I-1);
        end;
    3 : If (Mounting.Count>0) and (Messagedlg(LanguageSetup.ProfileEditorMountingDeleteAllMessage,mtConfirmation,[mbYes,mbNo],0)=mrYes) then begin
          Mounting.Clear;
          LoadMountingList;
        end;
    4 : begin
          Mounting.Assign(MountingSave);
          LoadMountingList;
        end;
  end;
end;

procedure TWizardFinishFrame.MountingListViewDblClick(Sender: TObject);
begin
  ButtonWork(MountingEditButton);
end;

procedure TWizardFinishFrame.MountingListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(MountingAddButton);
    VK_RETURN : ButtonWork(MountingEditButton);
    VK_DELETE : ButtonWork(MountingDelButton);
  end;
end;

procedure TWizardFinishFrame.WriteDataToGame(const Game: TGame);
Var I : Integer;
begin
  Game.NrOfMounts:=Mounting.Count;
  For I:=0 to 9 do
    If Mounting.Count>I then Game.Mount[I]:=Mounting[I] else Game.Mount[I]:='';
  Game.AutoMountCDs:=False;
end;

end.
