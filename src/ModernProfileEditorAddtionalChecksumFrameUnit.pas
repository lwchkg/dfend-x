unit ModernProfileEditorAddtionalChecksumFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorAddtionalChecksumFrame = class(TFrame, IModernProfileEditorFrame)
    FilenameEdit1: TEdit;
    ChecksumEdit1: TEdit;
    FilenameLabel: TLabel;
    ChecksumLabel: TLabel;
    SelectButton1: TSpeedButton;
    DeleteButton1: TSpeedButton;
    FilenameEdit2: TEdit;
    ChecksumEdit2: TEdit;
    FilenameEdit3: TEdit;
    ChecksumEdit3: TEdit;
    FilenameEdit4: TEdit;
    ChecksumEdit4: TEdit;
    FilenameEdit5: TEdit;
    ChecksumEdit5: TEdit;
    AddAllButton: TBitBtn;
    ClearAllButton: TBitBtn;
    SelectButton2: TSpeedButton;
    DeleteButton2: TSpeedButton;
    SelectButton3: TSpeedButton;
    DeleteButton3: TSpeedButton;
    SelectButton4: TSpeedButton;
    DeleteButton4: TSpeedButton;
    SelectButton5: TSpeedButton;
    DeleteButton5: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    FGame : TGame;
    LastDir : String;
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses CommonTools, LanguageSetupUnit, VistaToolsUnit, HelpConsts,
     IconLoaderUnit, GameDBToolsUnit, PrgSetupUnit, HashCalc;

{$R *.dfm}

{ TModernProfileEditorAddtionalChecksumFrame }

procedure TModernProfileEditorAddtionalChecksumFrame.InitGUI(var InitData: TModernProfileEditorInitData);
begin
  NoFlicker(FilenameEdit1);
  NoFlicker(FilenameEdit2);
  NoFlicker(FilenameEdit3);
  NoFlicker(FilenameEdit4);
  NoFlicker(FilenameEdit5);
  NoFlicker(ChecksumEdit1);
  NoFlicker(ChecksumEdit2);
  NoFlicker(ChecksumEdit3);
  NoFlicker(ChecksumEdit4);
  NoFlicker(ChecksumEdit5);
  NoFlicker(AddAllButton);
  NoFlicker(ClearAllButton);

  FilenameLabel.Caption:=LanguageSetup.ProfileEditorAdditionalChecksumsFiles;
  ChecksumLabel.Caption:=LanguageSetup.ProfileEditorAdditionalChecksumsChecksums;
  SelectButton1.Hint:=LanguageSetup.ChooseFile;
  SelectButton2.Hint:=LanguageSetup.ChooseFile;
  SelectButton3.Hint:=LanguageSetup.ChooseFile;
  SelectButton4.Hint:=LanguageSetup.ChooseFile;
  SelectButton5.Hint:=LanguageSetup.ChooseFile;
  DeleteButton1.Hint:=LanguageSetup.ProfileEditorAdditionalChecksumsDelete;
  DeleteButton2.Hint:=LanguageSetup.ProfileEditorAdditionalChecksumsDelete;
  DeleteButton3.Hint:=LanguageSetup.ProfileEditorAdditionalChecksumsDelete;
  DeleteButton4.Hint:=LanguageSetup.ProfileEditorAdditionalChecksumsDelete;
  DeleteButton5.Hint:=LanguageSetup.ProfileEditorAdditionalChecksumsDelete;
  AddAllButton.Caption:=LanguageSetup.ProfileEditorAdditionalChecksumsAddAll;
  ClearAllButton.Caption:=LanguageSetup.ProfileEditorAdditionalChecksumsDeleteAll;
  OpenDialog.Title:=LanguageSetup.ChooseFile;
  OpenDialog.Filter:=LanguageSetup.ProfileEditorAdditionalChecksumsSelectFileFilter;
  UserIconLoader.DialogImage(DI_SelectFile,SelectButton1);
  UserIconLoader.DialogImage(DI_SelectFile,SelectButton2);
  UserIconLoader.DialogImage(DI_SelectFile,SelectButton3);
  UserIconLoader.DialogImage(DI_SelectFile,SelectButton4);
  UserIconLoader.DialogImage(DI_SelectFile,SelectButton5);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton1);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton2);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton3);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton4);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton5);
  UserIconLoader.DialogImage(DI_Load,AddAllButton);
  UserIconLoader.DialogImage(DI_Delete,ClearAllButton);

  HelpContext:=ID_ProfileEditAdditionalChecksums;

  LastDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
end;

procedure TModernProfileEditorAddtionalChecksumFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  FilenameEdit1.Text:=Game.AddtionalChecksumFile1;
  FilenameEdit2.Text:=Game.AddtionalChecksumFile2;
  FilenameEdit3.Text:=Game.AddtionalChecksumFile3;
  FilenameEdit4.Text:=Game.AddtionalChecksumFile4;
  FilenameEdit5.Text:=Game.AddtionalChecksumFile5;
  ChecksumEdit1.Text:=Game.AddtionalChecksumFile1Checksum;
  ChecksumEdit2.Text:=Game.AddtionalChecksumFile2Checksum;
  ChecksumEdit3.Text:=Game.AddtionalChecksumFile3Checksum;
  ChecksumEdit4.Text:=Game.AddtionalChecksumFile4Checksum;
  ChecksumEdit5.Text:=Game.AddtionalChecksumFile5Checksum;

  FGame:=Game;
end;

procedure TModernProfileEditorAddtionalChecksumFrame.ButtonWork(Sender: TObject);
Var I,J,K : Integer;
    Files,Checksums : T5StringArray;
    Path : String;
begin
  Case (Sender as TComponent).Tag of
    0..4 : begin
             OpenDialog.InitialDir:=LastDir;
             if not OpenDialog.Execute then exit;
             LastDir:=ExtractFilePath(OpenDialog.FileName);
             TEdit(FindComponent('FilenameEdit'+IntToStr((Sender as TComponent).Tag+1))).Text:=ExtractFileName(OpenDialog.FileName);
             TEdit(FindComponent('ChecksumEdit'+IntToStr((Sender as TComponent).Tag+1))).Text:=GetMD5Sum(OpenDialog.FileName,False);
           end;
    5..9 : begin
             TEdit(FindComponent('FilenameEdit'+IntToStr((Sender as TComponent).Tag-4))).Text:='';
             TEdit(FindComponent('ChecksumEdit'+IntToStr((Sender as TComponent).Tag-4))).Text:='';
           end;
    -1 :   begin
             I:=0;
             For J:=1 to 5 do if TEdit(FindComponent('FilenameEdit'+IntToStr(J))).Text='' then inc(I);
             If I=0 then exit;
             Path:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
             if not SelectDirectory(Handle,LanguageSetup.ProfileEditorAdditionalChecksumsSelectFolder,Path) then exit;
             I:=GetAdditionalChecksumData(FGame,Path,I,Files,Checksums);
             K:=0;
             For J:=1 to 5 do if TEdit(FindComponent('FilenameEdit'+IntToStr(J))).Text='' then begin
               If K>=I then break;
               TEdit(FindComponent('FilenameEdit'+IntToStr(J))).Text:=Files[K];
               TEdit(FindComponent('ChecksumEdit'+IntToStr(J))).Text:=Checksums[K];
               inc(K);
             end;
           end;
    -2 :   For I:=1 to 5 do begin
             TEdit(FindComponent('FilenameEdit'+IntToStr(I))).Text:='';
             TEdit(FindComponent('ChecksumEdit'+IntToStr(I))).Text:='';
           end;
  End;
end;

procedure TModernProfileEditorAddtionalChecksumFrame.GetGame(const Game: TGame);
begin
  Game.AddtionalChecksumFile1:=FilenameEdit1.Text;
  Game.AddtionalChecksumFile2:=FilenameEdit2.Text;
  Game.AddtionalChecksumFile3:=FilenameEdit3.Text;
  Game.AddtionalChecksumFile4:=FilenameEdit4.Text;
  Game.AddtionalChecksumFile5:=FilenameEdit5.Text;
  Game.AddtionalChecksumFile1Checksum:=ChecksumEdit1.Text;
  Game.AddtionalChecksumFile2Checksum:=ChecksumEdit2.Text;
  Game.AddtionalChecksumFile3Checksum:=ChecksumEdit3.Text;
  Game.AddtionalChecksumFile4Checksum:=ChecksumEdit4.Text;
  Game.AddtionalChecksumFile5Checksum:=ChecksumEdit5.Text;
end;

end.
