unit ProfileMountEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls, ImgList, Grids, Menus,
  ModernProfileEditorBaseFrameUnit, GameDBUnit;

Type TInfoData=record
  Data : String;
  UsedDriveLetters : String;
  DefaultInitialDir : String;
  ProfileFileName : String;
  CloseRequest : TNotifyEvent;
  BaseGameFrame : TModernProfileEditorBaseFrame;
  GameDB : TGameDB;
end;

Type TProfileMountEditorFrame=interface
  Function Init(const AInfoData : TInfoData) : Boolean;
  Function CheckBeforeDone : Boolean; 
  Function Done : String;
  Function GetName : String;
  Procedure ShowFrame;
end;

Type TFrameInfoRec=record
  Frame : TFrame;
  FrameI : TProfileMountEditorFrame;
end;

type
  TProfileMountEditorForm = class(TForm)
    MainPanel: TPanel;
    TopPanel: TPanel;
    TypeComboBox: TComboBox;
    TypeLabel: TLabel;
    BottomPanel: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure TypeComboBoxChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    LastVisible : Integer;
    FrameInfoRec : Array of TFrameInfoRec;
    Procedure AddFrame(const Frame : TFrame; const FrameI : TProfileMountEditorFrame);
    Procedure CloseRequest(Sender : TObject);
  public
    { Public-Deklarationen }
    Data : String;
    BaseGameFrame : TModernProfileEditorBaseFrame;
    UsedDriveLetters : String;
    DefaultInitialDir : String;
    ProfileFileName : String;
    GameDB : TGameDB;
  end;

var
  ProfileMountEditorForm: TProfileMountEditorForm;

Function ShowProfileMountEditorDialog(const AOwner : TComponent; var AData : String; const AUsedDriveLetters : String; const ADefaultInitialDir : String; const AProfileFileName : String; const AGameDB : TGameDB; const Frame : TModernProfileEditorBaseFrame =nil; const NextFreeDriveLetter : String ='' {for adding new drives}) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit,
     ProfileMountEditorDriveFrameUnit, ProfileMountEditorFloppyDriveFrameUnit,
     ProfileMountEditorCDDriveFrameUnit, ProfileMountEditorFloppyImage1FrameUnit,
     ProfileMountEditorFloppyImage2FrameUnit, ProfileMountEditorCDImageFrameUnit,
     ProfileMountEditorHDImageFrameUnit, ProfileMountEditorPhysFSFrameUnit,
     ProfileMountEditorZipFrameUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TProfileMountEditorForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  UsedDriveLetters:='';

  TypeLabel.Caption:=LanguageSetup.ProfileMountingDriveType+':';
  Caption:=LanguageSetup.ProfileMounting;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
end;

procedure TProfileMountEditorForm.AddFrame(const Frame : TFrame; const FrameI: TProfileMountEditorFrame);
Var I : Integer;
    InfoData : TInfoData;
begin
  Frame.DoubleBuffered:=True;
  SetVistaFonts(Frame);
  Frame.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Frame.Parent:=MainPanel;
  Frame.Align:=alClient;
  Frame.Visible:=False;

  I:=length(FrameInfoRec);
  SetLength(FrameInfoRec,I+1);
  FrameInfoRec[I].Frame:=Frame;
  FrameInfoRec[I].FrameI:=FrameI;

  InfoData.Data:=Data;
  InfoData.UsedDriveLetters:=UsedDriveLetters;
  InfoData.CloseRequest:=CloseRequest;
  InfoData.BaseGameFrame:=BaseGameFrame;
  If ExtUpperCase(Copy(DefaultInitialDir,1,7))='DOSBOX:'
    then InfoData.DefaultInitialDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)
    else InfoData.DefaultInitialDir:=MakeAbsPath(DefaultInitialDir,PrgSetup.BaseDir);
  If not DirectoryExists(InfoData.DefaultInitialDir) then InfoData.DefaultInitialDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
  InfoData.ProfileFileName:=ProfileFileName;
  InfoData.GameDB:=GameDB;

  If FrameI.Init(InfoData) then LastVisible:=I;

  TypeComboBox.Items.AddObject(FrameI.GetName,TObject(I));
end;

procedure TProfileMountEditorForm.FormShow(Sender: TObject);
Var St : TStringList;
    I : Integer;
    F : TFrame;
begin
  {general: RealFolder;Type;Letter;IO;Label;FreeSpace}
  St:=ValueToList(Data);
  try
    If St.Count<2 then begin
      St.Add('');
      St.Add('Drive');
      Data:=ListToValue(St);
    end;
  finally
    St.Free;
  end;

  LastVisible:=-1;

  F:=TProfileMountEditorDriveFrame.Create(self); AddFrame(F,TProfileMountEditorDriveFrame(F));
  F:=TProfileMountEditorFloppyDriveFrame.Create(self); AddFrame(F,TProfileMountEditorFloppyDriveFrame(F));
  F:=TProfileMountEditorCDDriveFrame.Create(self); AddFrame(F,TProfileMountEditorCDDriveFrame(F));
  If PrgSetup.AllowMultiFloppyImagesMount then begin
    F:=TProfileMountEditorFloppyImage2Frame.Create(self); AddFrame(F,TProfileMountEditorFloppyImage2Frame(F));
  end else begin
    F:=TProfileMountEditorFloppyImage1Frame.Create(self); AddFrame(F,TProfileMountEditorFloppyImage1Frame(F));
  end;
  F:=TProfileMountEditorCDImageFrame.Create(self); AddFrame(F,TProfileMountEditorCDImageFrame(F));
  F:=TProfileMountEditorHDImageFrame.Create(self); AddFrame(F,TProfileMountEditorHDImageFrame(F));
  F:=TProfileMountEditorZipFrame.Create(self); AddFrame(F,TProfileMountEditorZipFrame(F));
  If PrgSetup.AllowPhysFSUsage or (LastVisible=-1) then begin
    F:=TProfileMountEditorPhysFSFrame.Create(self); AddFrame(F,TProfileMountEditorPhysFSFrame(F));
  end;

  I:=LastVisible; LastVisible:=-1;
  TypeComboBox.ItemIndex:=I;
  TypeComboBoxChange(Sender);
end;

procedure TProfileMountEditorForm.CloseRequest(Sender: TObject);
begin
  ModalResult:=mrOK;
  OKButtonClick(Sender);
end;

procedure TProfileMountEditorForm.OKButtonClick(Sender: TObject);
Var S : String;
begin
  If LastVisible<0 then begin ModalResult:=mrNone; exit; end;
  If not FrameInfoRec[LastVisible].FrameI.CheckBeforeDone then begin ModalResult:=mrNone; exit; end;
  S:=FrameInfoRec[LastVisible].FrameI.Done;
  If S='' then begin ModalResult:=mrNone; exit; end;
  Data:=S;
end;

procedure TProfileMountEditorForm.TypeComboBoxChange(Sender: TObject);
begin
  If LastVisible>=0 then begin
    FrameInfoRec[LastVisible].Frame.Visible:=False;
  end;

  LastVisible:=TypeComboBox.ItemIndex;

  If TypeComboBox.ItemIndex>=0 then begin
    FrameInfoRec[TypeComboBox.ItemIndex].Frame.Visible:=True;
    FrameInfoRec[TypeComboBox.ItemIndex].FrameI.ShowFrame;
  end;
end;

procedure TProfileMountEditorForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileEditDrives);
end;

procedure TProfileMountEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowProfileMountEditorDialog(const AOwner : TComponent; var AData : String; const AUsedDriveLetters : String; const ADefaultInitialDir : String; const AProfileFileName : String; const AGameDB : TGameDB; const Frame : TModernProfileEditorBaseFrame; const NextFreeDriveLetter : String) : Boolean;
Var S : String;
begin
  If AData='' then begin
    S:=Trim(PrgSetup.LastAddedDriveType); If S='' then S:='Drive';
    AData:=';'+S+';'+NextFreeDriveLetter+';';
  end;
  ProfileMountEditorForm:=TProfileMountEditorForm.Create(AOwner);
  try
    ProfileMountEditorForm.Data:=AData;
    ProfileMountEditorForm.BaseGameFrame:=Frame;
    If Trim(ADefaultInitialDir)<>'\'
      then ProfileMountEditorForm.DefaultInitialDir:=ADefaultInitialDir
      else ProfileMountEditorForm.DefaultInitialDir:=PrgSetup.GameDir;
    ProfileMountEditorForm.UsedDriveLetters:=AUsedDriveLetters;
    ProfileMountEditorForm.ProfileFileName:=AProfileFileName;
    result:=(ProfileMountEditorForm.ShowModal=mrOK);
    if result then begin
      AData:=ProfileMountEditorForm.Data;
      S:=Trim(AData);
      If Pos(';',S)>0 then begin
        S:=Trim(Copy(S,Pos(';',S)+1,MaxInt));
        If Pos(';',S)>0 then S:=Trim(Copy(S,1,Pos(';',S)-1));
        PrgSetup.LastAddedDriveType:=S;
      end;
    end;
  finally
    ProfileMountEditorForm.Free;
  end;
end;

end.
