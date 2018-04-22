unit ProfileMountEditorFloppyImage2FrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Grids, Menus, ProfileMountEditorFormUnit;

type
  TProfileMountEditorFloppyImage2Frame = class(TFrame, TProfileMountEditorFrame)
    FloppyImageTab: TStringGrid;
    FloppyImageLabel: TLabel;
    FloppyImageButton2: TSpeedButton;
    FloppyImageCreateButton2: TSpeedButton;
    FloppyImageDelButton: TSpeedButton;
    FloppyImageAddButton: TSpeedButton;
    FloppyImageSwitchLabel: TLabel;
    FloppyImageDriveLetterComboBox2: TComboBox;
    FloppyImageDriveLetterLabel2: TLabel;
    DriveLetterInfoLabel3: TLabel;
    FloppyImageDriveLetterWarningLabel2: TLabel;
    OpenDialog: TOpenDialog;
    FloppyPopupMenu: TPopupMenu;
    FloppyPopupCreateImage: TMenuItem;
    FloppyPopupReadImage: TMenuItem;
    procedure FloppyImageButton2Click(Sender: TObject);
    procedure FloppyImageCreateButton2Click(Sender: TObject);
    procedure FloppyImageAddButtonClick(Sender: TObject);
    procedure FloppyImageDelButtonClick(Sender: TObject);
    procedure FloppyImageDriveLetterComboBox2Change(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure FloppyPopupWork(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function CheckBeforeDone : Boolean;
    Function Done : String;
    Function GetName : String;
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, CreateISOImageFormUnit,
     CreateImageUnit, IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorFloppyImage2Frame }

procedure TProfileMountEditorFloppyImage2Frame.FrameResize(Sender: TObject);
begin
  FloppyImageTab.ColWidths[0]:=FloppyImageTab.ClientWidth-25;
end;

function TProfileMountEditorFloppyImage2Frame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St,St2 : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  FloppyImageLabel.Caption:=LanguageSetup.ProfileMountingFile;
  FloppyImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  FloppyImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;
  FloppyImageSwitchLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  FloppyImageDriveLetterLabel2.Caption:=LanguageSetup.ProfileMountingLetter;
  FloppyImageDriveLetterWarningLabel2.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  DriveLetterInfoLabel3.Caption:=LanguageSetup.ProfileMountingLetterInfo;
  FloppyImageButton2.Hint:=LanguageSetup.ChooseFile;
  FloppyImageCreateButton2.Hint:=LanguageSetup.ProfileMountingCreateImage;

  FloppyImageDriveLetterComboBox2.Items.BeginUpdate;
  try
    FloppyImageDriveLetterComboBox2.Items.Capacity:=30;
    For C:='A' to 'Y' do FloppyImageDriveLetterComboBox2.Items.Add(C);
    FloppyImageDriveLetterComboBox2.Items.Add('0');
    FloppyImageDriveLetterComboBox2.Items.Add('1');
    FloppyImageDriveLetterComboBox2.ItemIndex:=0;
  finally
    FloppyImageDriveLetterComboBox2.Items.EndUpdate;
  end;

  FloppyPopupCreateImage.Caption:=LanguageSetup.ProfileMountingFloppyImageCreate;
  FloppyPopupReadImage.Caption:=LanguageSetup.ProfileMountingFloppyImageRead;

  UserIconLoader.DialogImage(DI_SelectFile,FloppyImageButton2);
  UserIconLoader.DialogImage(DI_ImageFloppy,FloppyImageCreateButton2);
  UserIconLoader.DialogImage(DI_Add,FloppyImageAddButton);
  UserIconLoader.DialogImage(DI_Delete,FloppyImageDelButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='FLOPPYIMAGE' then begin
      {ImageFile1$ImageFile2;FLOPPYIMAGE;Letter;;;}
      result:=True;
      St2:=TStringList.Create;
      try
        S:=Trim(St[0]);
        I:=Pos('$',S);
        While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
        St2.Add(S);
        FloppyImageTab.RowCount:=St2.Count;
        For I:=0 to St2.Count-1 do FloppyImageTab.Cells[0,I]:=St2[I];
      finally
        St2.Free;
      end;
      If St.Count>=3 then begin
        I:=FloppyImageDriveLetterComboBox2.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FloppyImageDriveLetterComboBox2.ItemIndex:=I;
      end;
    end else begin
      result:=False;
      For I:=0 to FloppyImageDriveLetterComboBox2.Items.Count-1 do begin
        If Pos(FloppyImageDriveLetterComboBox2.Items[I],InfoData.UsedDriveLetters)=0 then begin FloppyImageDriveLetterComboBox2.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  FloppyImageDriveLetterComboBox2Change(self);
end;

procedure TProfileMountEditorFloppyImage2Frame.ShowFrame;
begin
end;

function TProfileMountEditorFloppyImage2Frame.CheckBeforeDone: Boolean;
begin
  result:=True;
end;

function TProfileMountEditorFloppyImage2Frame.Done: String;
Var S : String;
    I : Integer;
begin
  {ImageFile;FLOPPYIMAGE;Letter;;;}
  S:=MakeRelPath(FloppyImageTab.Cells[0,0],PrgSetup.BaseDir); For I:=1 to FloppyImageTab.RowCount-1 do S:=S+'$'+MakeRelPath(FloppyImageTab.Cells[0,I],PrgSetup.BaseDir);

  result:=StringReplace(S,';','<semicolon>',[rfReplaceAll])+';FloppyImage;'+FloppyImageDriveLetterComboBox2.Text+';;;';
end;

function TProfileMountEditorFloppyImage2Frame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingFloppyImageSheet;
end;

procedure TProfileMountEditorFloppyImage2Frame.FloppyImageButton2Click(Sender: TObject);
Var S : String;
begin
  If FloppyImageTab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
    exit;
  end;
  If Trim(FloppyImageTab.Cells[0,FloppyImageTab.Row])='' then S:=PrgSetup.BaseDir else S:=FloppyImageTab.Cells[0,FloppyImageTab.Row];
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='iso';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
  if not OpenDialog.Execute then exit;
  FloppyImageTab.Cells[0,FloppyImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorFloppyImage2Frame.FloppyImageCreateButton2Click(Sender: TObject);
Var P : TPoint;
begin
  If FloppyImageTab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
    exit;
  end;
  P:=ClientToScreen(Point(FloppyImageCreateButton2.Left,FloppyImageCreateButton2.Top));
  FloppyPopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TProfileMountEditorFloppyImage2Frame.FloppyImageAddButtonClick(Sender: TObject);
begin
  FloppyImageTab.RowCount:=FloppyImageTab.RowCount+1;
  FloppyImageTab.Row:=FloppyImageTab.RowCount-1;
end;

procedure TProfileMountEditorFloppyImage2Frame.FloppyImageDelButtonClick(Sender: TObject);
Var I : Integer;
begin
  If FloppyImageTab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
    exit;
  end;
  If FloppyImageTab.RowCount=1 then begin
    FloppyImageTab.Cells[0,0]:='';
  end else begin
    For I:=FloppyImageTab.Row+1 to FloppyImageTab.RowCount-1 do FloppyImageTab.Cells[0,I-1]:=FloppyImageTab.Cells[0,I];
    FloppyImageTab.RowCount:=FloppyImageTab.RowCount-1;
  end;
end;

procedure TProfileMountEditorFloppyImage2Frame.FloppyImageDriveLetterComboBox2Change(Sender: TObject);
begin
  FloppyImageDriveLetterWarningLabel2.Visible:=(FloppyImageDriveLetterComboBox2.ItemIndex>=0) and (Pos(FloppyImageDriveLetterComboBox2.Items[FloppyImageDriveLetterComboBox2.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorFloppyImage2Frame.FloppyPopupWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=ShowCreateImageFileDialog(self,True,False,InfoData.GameDB);
          If S='' then exit;
          FloppyImageTab.Cells[0,FloppyImageTab.Row]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    1 : begin
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          if not ShowCreateISOImageDialog(self,S,True) then exit;
          If S='' then exit;
          FloppyImageTab.Cells[0,FloppyImageTab.Row]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
  end;
end;

end.
