unit SetupFrameServiceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Menus, ImgList, SetupFormUnit, GameDBUnit,
  LinkFileUnit;

type
  TSetupFrameService = class(TFrame, ISetupFrame)
    Service3Button: TBitBtn;
    Service4Button: TBitBtn;
    Service1Button: TBitBtn;
    Service2Button: TBitBtn;
    Service5Button: TBitBtn;
    Service6Button: TBitBtn;
    Service7Button: TBitBtn;
    Service8Button: TBitBtn;
    Service9Button: TBitBtn;
    RenamePopupMenu: TPopupMenu;
    RenameScreenshots: TMenuItem;
    RenameSounds: TMenuItem;
    RenameVideos: TMenuItem;
    ImageList: TImageList;
    Service10Button: TBitBtn;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    GameDB : TGameDB;
    SearchLinkFile : TLinkFile;
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvancedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, GameDBToolsUnit, PrgConsts, HelpConsts,
     IconLoaderUnit, PackageDBToolsUnit, PrgSetupUnit, CommonTools,
     RenameAllScreenshotsFormUnit, ResetProfilesFormUnit;

{$R *.dfm}

{ TSetupFrameService }

function TSetupFrameService.GetName: String;
begin
  result:=LanguageSetup.SetupFormServiceSheet;
end;

procedure TSetupFrameService.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  GameDB:=InitData.GameDB;
  SearchLinkFile:=InitData.SearchLinkFile;

  NoFlicker(Service1Button);
  NoFlicker(Service2Button);
  NoFlicker(Service3Button);
  NoFlicker(Service4Button);
  NoFlicker(Service5Button);
  NoFlicker(Service6Button);
  NoFlicker(Service7Button);
  NoFlicker(Service8Button);
  NoFlicker(Service9Button);
  NoFlicker(Service10Button);

  UserIconLoader.DialogImage(DI_ResetProfile,Service3Button);
  UserIconLoader.DialogImage(DI_ResetProfile,Service4Button);
  UserIconLoader.DialogImage(DI_Clear,Service1Button);
  UserIconLoader.DialogImage(DI_Folders,Service2Button);
  UserIconLoader.DialogImage(DI_Calculator,Service5Button);
  UserIconLoader.DialogImage(DI_Delete,Service6Button);
  UserIconLoader.DialogImage(DI_Folders,Service7Button);
  UserIconLoader.DialogImage(DI_Folders,Service8Button);
  UserIconLoader.DialogImage(DI_Edit,Service9Button);
  UserIconLoader.DialogImage(DI_Edit,Service10Button);

  UserIconLoader.DialogImage(DI_Image,ImageList,0);
  UserIconLoader.DialogImage(DI_Sound,ImageList,1);
  UserIconLoader.DialogImage(DI_Video,ImageList,2);
end;

procedure TSetupFrameService.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameService.LoadLanguage;
begin
  Service1Button.Caption:=LanguageSetup.SetupFormService1;
  Service2Button.Caption:=LanguageSetup.SetupFormService2;
  Service3Button.Caption:=LanguageSetup.SetupFormService3;
  Service4Button.Caption:=LanguageSetup.SetupFormService4;
  Service5Button.Caption:=LanguageSetup.SetupFormService5;
  Service6Button.Caption:=LanguageSetup.SetupFormService6;
  Service7Button.Caption:=LanguageSetup.SetupFormService7;
  Service8Button.Caption:=LanguageSetup.SetupFormService8;
  Service9Button.Caption:=LanguageSetup.SetupFormService9;
  Service10Button.Caption:=LanguageSetup.SetupFormService10;
  RenameScreenshots.Caption:=LanguageSetup.CaptureScreenshots;
  RenameSounds.Caption:=LanguageSetup.CaptureSounds;
  RenameVideos.Caption:=LanguageSetup.CaptureVideos;

  HelpContext:=ID_FileOptionsService;
end;

procedure TSetupFrameService.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameService.ShowFrame(const AdvancedMode: Boolean);
begin
  Service1Button.Visible:=AdvancedMode;
  Service2Button.Visible:=AdvancedMode;
  Service5Button.Visible:=AdvancedMode;
  Service6Button.Visible:=AdvancedMode;
  Service7Button.Visible:=AdvancedMode;
  Service8Button.Visible:=AdvancedMode;
  Service9Button.Visible:=AdvancedMode;
  Service10Button.Visible:=AdvancedMode;
end;

procedure TSetupFrameService.HideFrame;
begin
end;

procedure TSetupFrameService.RestoreDefaults;
begin
end;

procedure TSetupFrameService.SaveSetup;
begin
end;

procedure TSetupFrameService.ButtonWork(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0 : DeleteOldFiles;
    1 : ReplaceAbsoluteDirs(GameDB);
    2 : begin
          Enabled:=False;
          try
            I:=GameDB.IndexOf(DosBoxDOSProfile);
            If I>=0 then begin
              If MessageDlg(LanguageSetup.SetupFormService3Confirmation,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
              GameDB.Delete(I);
            end;
            BuildDefaultDosProfile(GameDB);
          finally
            Enabled:=True;
          end;
        end;
    3 : begin
          BuildDefaultProfile;
          ReBuildTemplates(False);
        end;
    4 : CreateCheckSumsForAllGames(GameDB);
    5 : ClearPackageCache;
    6 : CreateFoldersForAllGames(GameDB,ftCapture);
    7 : CreateFoldersForAllGames(GameDB,ftGameData);
    8 : begin
          P:=ClientToScreen(Point(Service9Button.Left,Service9Button.Top));
          RenamePopupMenu.Popup(P.X+5,P.Y+5);
        end;
    9 : ShowResetProfilesDialog(self,GameDB,SearchLinkFile);
    81 : RenameMediaFiles(self,nil,GameDB,rfScreenshots);
    82 : RenameMediaFiles(self,nil,GameDB,rfSounds);
    83 : RenameMediaFiles(self,nil,GameDB,rfVideos);
  end;
end;

end.
