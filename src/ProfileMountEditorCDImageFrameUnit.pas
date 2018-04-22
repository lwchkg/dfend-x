unit ProfileMountEditorCDImageFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Grids, ProfileMountEditorFormUnit;

type
  TProfileMountEditorCDImageFrame = class(TFrame, TProfileMountEditorFrame)
    CDROMImageLabel: TLabel;
    CDROMImageTab: TStringGrid;
    CDROMImageButton: TSpeedButton;
    CDROMImageAddButton: TSpeedButton;
    CDROMImageDelButton: TSpeedButton;
    ISOImageCreateButton: TSpeedButton;
    CDROMImageSwitchLabel: TLabel;
    CDROMImageDriveLetterLabel: TLabel;
    CDROMImageDriveLetterComboBox: TComboBox;
    CDImageDriveLetterWarningLabel: TLabel;
    OpenDialog: TOpenDialog;
    ImageTypeInfoLabel: TLabel;
    procedure CDROMImageButtonClick(Sender: TObject);
    procedure ISOImageCreateButtonClick(Sender: TObject);
    procedure CDROMImageAddButtonClick(Sender: TObject);
    procedure CDROMImageDelButtonClick(Sender: TObject);
    procedure CDROMImageDriveLetterComboBoxChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
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
     IconLoaderUnit, ImageTools;

{$R *.dfm}

{ TProfileMountEditorCDImageFrame }

procedure TProfileMountEditorCDImageFrame.FrameResize(Sender: TObject);
begin
  CDROMImageTab.ColWidths[0]:=CDROMImageTab.ClientWidth-25;
end;

function TProfileMountEditorCDImageFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St,St2 : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  CDROMImageLabel.Caption:=LanguageSetup.ProfileMountingFile;
  CDROMImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  CDROMImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;
  CDROMImageSwitchLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  CDROMImageDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  CDImageDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  CDROMImageButton.Hint:=LanguageSetup.ChooseFile;
  ISOImageCreateButton.Hint:=LanguageSetup.ProfileMountingCreateImage;

  CDROMImageDriveLetterComboBox.Items.BeginUpdate;
  try
    CDROMImageDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do CDROMImageDriveLetterComboBox.Items.Add(C);
    CDROMImageDriveLetterComboBox.ItemIndex:=3;
  finally
    CDROMImageDriveLetterComboBox.Items.EndUpdate;
  end;
  ImageTypeInfoLabel.Caption:=LanguageSetup.ProfileMountingImageTypeInfo;

  UserIconLoader.DialogImage(DI_SelectFile,CDROMImageButton);
  UserIconLoader.DialogImage(DI_ImageCD,ISOImageCreateButton);
  UserIconLoader.DialogImage(DI_Add,CDROMImageAddButton);
  UserIconLoader.DialogImage(DI_Delete,CDROMImageDelButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='CDROMIMAGE' then begin
      {ImageFile;CDROMIMAGE;Letter;;;}
      result:=True;
      St2:=TStringList.Create;
      try
        S:=Trim(St[0]);
        I:=Pos('$',S);
        While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
        St2.Add(S);
        CDROMImageTab.RowCount:=St2.Count;
        For I:=0 to St2.Count-1 do CDROMImageTab.Cells[0,I]:=St2[I];
      finally
        St2.Free;
      end;
      If St.Count>=3 then begin
        I:=CDROMImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        CDROMImageDriveLetterComboBox.ItemIndex:=I;
      end;
    end else begin
      result:=False;
      For I:=2 to CDROMImageDriveLetterComboBox.Items.Count-1 do begin
        If Pos(CDROMImageDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin CDROMImageDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  CDROMImageDriveLetterComboBoxChange(self);
end;

function TProfileMountEditorCDImageFrame.Done: String;
Var I : Integer;
    S : String;
begin
  {ImageFile;CDROMIMAGE;Letter;;;}
  S:=MakeRelPath(CDROMImageTab.Cells[0,0],PrgSetup.BaseDir); For I:=1 to CDROMImageTab.RowCount-1 do S:=S+'$'+MakeRelPath(CDROMImageTab.Cells[0,I],PrgSetup.BaseDir);
  result:=StringReplace(S,';','<semicolon>',[rfReplaceAll])+';CDROMImage;'+CDROMImageDriveLetterComboBox.Text+';;;';
end;

function TProfileMountEditorCDImageFrame.CheckBeforeDone: Boolean;
Var I : Integer;
    S : String;
begin
  result:=True;
  For I:=0 to CDROMImageTab.RowCount-1 do begin
    S:=MakeAbsPath(CDROMImageTab.Cells[0,I],PrgSetup.BaseDir);
    If not CheckCDImage(S) then begin
      If MessageDlg(Format(LanguageSetup.ProfileMountingImageTypeWarning,[S]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin result:=False; exit; end;
    end;
  end;
end;

function TProfileMountEditorCDImageFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingCDROMImageSheet;
end;

procedure TProfileMountEditorCDImageFrame.CDROMImageButtonClick(Sender: TObject);
Var S : String;
begin
  If CDROMImageTab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
    exit;
  end;
  If Trim(CDROMImageTab.Cells[0,CDROMImageTab.Row])='' then S:=PrgSetup.BaseDir else S:=CDROMImageTab.Cells[0,CDROMImageTab.Row];
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='iso';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
  if not OpenDialog.Execute then exit;
  CDROMImageTab.Cells[0,CDROMImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorCDImageFrame.ISOImageCreateButtonClick(Sender: TObject);
Var S : String;
begin
  If CDROMImageTab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
    exit;
  end;
  if not ShowCreateISOImageDialog(self,S,False) then exit;
  If S='' then exit;
  CDROMImageTab.Cells[0,CDROMImageTab.Row]:=MakeRelPath(S,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorCDImageFrame.ShowFrame;
begin
end;

procedure TProfileMountEditorCDImageFrame.CDROMImageAddButtonClick(Sender: TObject);
begin
  CDROMImageTab.RowCount:=CDROMImageTab.RowCount+1;
  CDROMImageTab.Row:=CDROMImageTab.RowCount-1;
end;

procedure TProfileMountEditorCDImageFrame.CDROMImageDelButtonClick(Sender: TObject);
Var I : Integer;
begin
  If CDROMImageTab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
    exit;
  end;
  If CDROMImageTab.RowCount=1 then begin
    CDROMImageTab.Cells[0,0]:='';
  end else begin
    For I:=CDROMImageTab.Row+1 to CDROMImageTab.RowCount-1 do CDROMImageTab.Cells[0,I-1]:=CDROMImageTab.Cells[0,I];
    CDROMImageTab.RowCount:=CDROMImageTab.RowCount-1;
  end;
end;

procedure TProfileMountEditorCDImageFrame.CDROMImageDriveLetterComboBoxChange(Sender: TObject);
begin
  CDImageDriveLetterWarningLabel.Visible:=(CDROMImageDriveLetterComboBox.ItemIndex>=0) and (Pos(CDROMImageDriveLetterComboBox.Items[CDROMImageDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

end.
