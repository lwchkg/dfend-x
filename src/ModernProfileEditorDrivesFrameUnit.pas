unit ModernProfileEditorDrivesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ComCtrls, GameDBUnit, ModernProfileEditorFormUnit,
  Menus, ImgList;

type
  TModernProfileEditorDrivesFrame = class(TFrame, IModernProfileEditorFrame)
    AutoMountCheckBox: TCheckBox;
    MountingListView: TListView;
    MountingAddButton: TBitBtn;
    MountingEditButton: TBitBtn;
    MountingDelButton: TBitBtn;
    MountingDeleteAllButton: TBitBtn;
    MountingAutoCreateButton: TBitBtn;
    SecureModeCheckBox: TCheckBox;
    PopupMenu: TPopupMenu;
    PopupAdd: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDelete: TMenuItem;
    ImageList: TImageList;
    procedure ButtonWork(Sender: TObject);
    procedure MountingListViewDblClick(Sender: TObject);
    procedure MountingListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
    Mounting : TStringList;
    ProfileExe, ProfileSetup, ProfileName : PString;
    FGetFrame : TGetFrameFunction;
    GameDB : TGameDB;
    Procedure LoadMountingList;
    function NextFreeDriveLetter: Char;
    Function UsedDriveLetters(const AllowedNr : Integer = -1) : String;
    function CanReachFile(const FileName: String): Boolean;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     ProfileMountEditorFormUnit, HelpConsts, GameDBToolsUnit, IconLoaderUnit,
     ModernProfileEditorBaseFrameUnit, PrgConsts;

{$R *.dfm}

{ TModernProfileEditorDrivesFrame }

constructor TModernProfileEditorDrivesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Mounting:=nil;
end;

procedure TModernProfileEditorDrivesFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  NoFlicker(MountingListView);
  NoFlicker(MountingAddButton);
  NoFlicker(MountingEditButton);
  NoFlicker(MountingDelButton);
  NoFlicker(MountingDeleteAllButton);
  NoFlicker(MountingAutoCreateButton);
  NoFlicker(AutoMountCheckBox);
  NoFlicker(SecureModeCheckBox);

  MountingAddButton.Caption:=LanguageSetup.ProfileEditorMountingAdd;
  MountingEditButton.Caption:=LanguageSetup.ProfileEditorMountingEdit;
  MountingDelButton.Caption:=LanguageSetup.ProfileEditorMountingDel;
  MountingDeleteAllButton.Caption:=LanguageSetup.ProfileEditorMountingDelAll;
  MountingAutoCreateButton.Caption:=LanguageSetup.ProfileEditorMountingAutoCreate;
  InitMountingListView(MountingListView);
  AutoMountCheckBox.Caption:=LanguageSetup.ProfileEditorMountingAutoMountCDs;
  SecureModeCheckBox.Caption:=LanguageSetup.ProfileEditorMountingSecureMode;
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

  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileName:=InitData.CurrentProfileName;

  FGetFrame:=InitData.GetFrame;

  GameDB:=InitData.GameDB;

  HelpContext:=ID_ProfileEditDrives;
end;

procedure TModernProfileEditorDrivesFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
begin
  if Assigned(Mounting) then FreeAndNil(Mounting);
  Mounting:=TStringList.Create;
  For I:=0 to 9 do
    If Game.NrOfMounts>=I+1 then Mounting.Add(Game.Mount[I]) else break;
  LoadMountingList;
  AutoMountCheckBox.Checked:=Game.AutoMountCDs;
  SecureModeCheckBox.Checked:=Game.SecureMode;
end;

procedure TModernProfileEditorDrivesFrame.LoadMountingList;
begin
  LoadMountingListView(MountingListView,Mounting);
end;

function TModernProfileEditorDrivesFrame.NextFreeDriveLetter: Char;
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

function TModernProfileEditorDrivesFrame.UsedDriveLetters(const AllowedNr : Integer): String;
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

Function ShortName(const LongName : String) : String;
begin
  SetLength(result,MAX_PATH+10);
  if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
    then result:=LongName
    else SetLength(result,StrLen(PChar(result)));
end;

function TModernProfileEditorDrivesFrame.CanReachFile(const FileName: String): Boolean;
Var S,FilePath : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;
  FilePath:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(ExtractFilePath(FileName),PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      {Types to check:
       RealFolder;DRIVE;Letter;False;;FreeSpace
       RealFolder;FLOPPY;Letter;False;;
       RealFolder;CDROM;Letter;IO;Label;
       all other are images}
      If St.Count<2 then continue;
      S:=Trim(ExtUpperCase(St[1]));
      If (S<>'DRIVE') and (S<>'FLOPPY') and (S<>'CDROM') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));

      result:=(Copy(FilePath,1,length(S))=S);
      if result then exit;
    finally
      St.Free;
    end;
  end;
end;

procedure TModernProfileEditorDrivesFrame.ButtonWork(Sender: TObject);
Var S,InitialDir : String;
    I : Integer;
    St : TStringList;
    F : TModernProfileEditorBaseFrame;
begin
  F:=FGetFrame(TModernProfileEditorBaseFrame) as TModernProfileEditorBaseFrame;
  If F.GameRelPathCheckBox.Checked or (Trim(ProfileExe^)='')
    then InitialDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)
    else InitialDir:=IncludeTrailingPathDelimiter(ExtractFilePath(ProfileExe^));

  Case (Sender as TComponent).Tag of
    0 : If Mounting.Count<10 then begin
          S:='';
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters,InitialDir,ProfileName^,GameDB,F,NextFreeDriveLetter) then exit;
          Mounting.Add(S);
          LoadMountingList;
          MountingListView.ItemIndex:=MountingListView.Items.Count-1;
        end;
    1 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          S:=Mounting[I];
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters(I),InitialDir,ProfileName^,GameDB,F) then exit;
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
          I:=0;
          while I<Mounting.Count do begin
            St:=ValueToList(Mounting[I]);
            try
              If (St.Count>=3) and (St[2]='C') then begin Mounting.Delete(I); continue; end;
              inc(I);
            finally
              St.Free;
            end;
          end;
          {Add VirtualHD dir}
          If Mounting.Count<10 then Mounting.Insert(0,MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;');
          {Add game dir if needed}
          If (Mounting.Count<10) and (Trim(ProfileExe^)<>'') and (not CanReachFile(ProfileExe^)) and (ExtUpperCase(Copy(ProfileExe^,1,7))<>'DOSBOX:') then begin
            S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(ProfileExe^),PrgSetup.BaseDir));
            Mounting.Add(S+';DRIVE;'+NextFreeDriveLetter+';False;;'+IntToStr(DefaultFreeHDSize));
          end;
          {Add setup dir if needed}
          If (Mounting.Count<10) and (Trim(ProfileSetup^)<>'') and (not CanReachFile(ProfileSetup^)) and (ExtUpperCase(Copy(ProfileSetup^,1,7))<>'DOSBOX:') then begin
            S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(ProfileSetup^),PrgSetup.BaseDir));
            Mounting.Add(S+';DRIVE;'+NextFreeDriveLetter+';False;;'+IntToStr(DefaultFreeHDSize));
          end;
          LoadMountingList;
        end;
  end;
end;

procedure TModernProfileEditorDrivesFrame.MountingListViewDblClick(Sender: TObject);
begin
  ButtonWork(MountingEditButton);
end;

procedure TModernProfileEditorDrivesFrame.MountingListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin ButtonWork(MountingEditButton); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(MountingAddButton);
    VK_RETURN : ButtonWork(MountingEditButton);
    VK_DELETE : ButtonWork(MountingDelButton);
  end;
end;

procedure TModernProfileEditorDrivesFrame.GetGame(const Game: TGame);
Var I : Integer;
begin
  Game.NrOfMounts:=Mounting.Count;
  For I:=0 to 9 do
    If Mounting.Count>I then Game.Mount[I]:=Mounting[I] else Game.Mount[I]:='';
  Game.AutoMountCDs:=AutoMountCheckBox.Checked;
  Game.SecureMode:=SecureModeCheckBox.Checked;
end;

Destructor TModernProfileEditorDrivesFrame.Destroy;
begin
  if Assigned(Mounting) then Mounting.Free;
  inherited Destroy;
end;

end.
