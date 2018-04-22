unit ModernProfileEditorMemoryFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit, ExtCtrls,
  ImgList, Buttons;

type
  TModernProfileEditorMemoryFrame = class(TFrame, IModernProfileEditorFrame)
    MemoryLabel: TLabel;
    MemoryEdit: TSpinEdit;
    XMSCheckBox: TCheckBox;
    EMSCheckBox: TCheckBox;
    UMBCheckBox: TCheckBox;
    LoadFixCheckBox: TCheckBox;
    LoadFixLabel: TLabel;
    LoadFixEdit: TSpinEdit;
    DOS32ACheckBox: TCheckBox;
    DOS32AInfoLabel: TLabel;
    Timer: TTimer;
    DOS32AInfoButton: TSpeedButton;
    ImageList: TImageList;
    FreeMemLabel: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure DOS32AInfoButtonClick(Sender: TObject);
    procedure LoadFixCheckBoxClick(Sender: TObject);
    procedure LoadFixEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    LastProfileExe : String;
    ProfileExe : PString;
    Procedure SetFreeMemInfo;
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorMemoryFrame }

procedure TModernProfileEditorMemoryFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  NoFlicker(MemoryEdit);

  MemoryLabel.Caption:=LanguageSetup.GameMemory;
  XMSCheckBox.Caption:=LanguageSetup.GameXMS;
  EMSCheckBox.Caption:=LanguageSetup.GameEMS;
  UMBCheckBox.Caption:=LanguageSetup.GameUMB;
  LoadFixCheckBox.Caption:=LanguageSetup.ProfileEditorLoadFix;
  LoadFixLabel.Caption:=LanguageSetup.ProfileEditorLoadFixMemory;
  DOS32ACheckBox.Caption:=LanguageSetup.GameDOS32A;
  DOS32AInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    DOS32AInfoLabel.Font.Color:=clGrayText;
  end else begin
    DOS32AInfoLabel.Font.Color:=clRed;
  end;
  LastProfileExe:='-';
  ProfileExe:=InitData.CurrentProfileExe;

  HelpContext:=ID_ProfileEditMemory;
end;

procedure TModernProfileEditorMemoryFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  MemoryEdit.Value:=Game.Memory;
  XMSCheckBox.Checked:=Game.XMS;
  EMSCheckBox.Checked:=Game.EMS;
  UMBCheckBox.Checked:=Game.UMB;
  LoadFixCheckBox.Checked:=Game.LoadFix;
  LoadFixEdit.Value:=Game.LoadFixMemory;
  DOS32ACheckBox.Checked:=Game.UseDOS32A;
  Timer.Enabled:=True;
  SetFreeMemInfo;
end;

procedure TModernProfileEditorMemoryFrame.SetFreeMemInfo;
Var I : Integer;
begin
  If LoadFixCheckBox.Checked then I:=632-1-Min(512,Max(0,LoadFixEdit.Value)) else I:=632;
  FreeMemLabel.Caption:=Format(LanguageSetup.GameMemoryFree,[I]);
end;

procedure TModernProfileEditorMemoryFrame.GetGame(const Game: TGame);
begin
  Game.Memory:=Min(63,Max(1,MemoryEdit.Value));
  Game.XMS:=XMSCheckBox.Checked;
  Game.EMS:=EMSCheckBox.Checked;
  Game.UMB:=UMBCheckBox.Checked;
  Game.LoadFix:=LoadFixCheckBox.Checked;
  Game.LoadFixMemory:=Min(512,Max(0,LoadFixEdit.Value));
  Game.UseDOS32A:=DOS32ACheckBox.Checked;
  Timer.Enabled:=False;
end;

procedure TModernProfileEditorMemoryFrame.TimerTimer(Sender: TObject);
Var B : Boolean;
    S : String;
begin
  If ProfileExe^=LastProfileExe then exit;
  LastProfileExe:=ProfileExe^;

  If Trim(ProfileExe^)='' then B:=False else begin
    S:=MakeAbsPath(ProfileExe^,PrgSetup.BaseDir);
    B:=FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(S))+'DOS4GW.EXE');
    If not B then B:=FindStringInFile(MakeAbsPath(ProfileExe^,PrgSetup.BaseDir),'DOS4GW');
  end;
  If B then begin
    ImageList.GetBitmap(0,DOS32AInfoButton.Glyph);
    DOS32AInfoButton.Hint:=LanguageSetup.GameDOS32AUseable;
  end else begin
    ImageList.GetBitmap(1,DOS32AInfoButton.Glyph);
    DOS32AInfoButton.Hint:=LanguageSetup.GameDOS32ANotUseable;;
  end;
end;

procedure TModernProfileEditorMemoryFrame.LoadFixCheckBoxClick(Sender: TObject);
begin
  SetFreeMemInfo;
end;

procedure TModernProfileEditorMemoryFrame.LoadFixEditChange(Sender: TObject);
begin
  SetFreeMemInfo;
end;

procedure TModernProfileEditorMemoryFrame.DOS32AInfoButtonClick(Sender: TObject);
begin
MessageDlg(DOS32AInfoButton.Hint,mtInformation,[mbOK],0);
end;

end.
