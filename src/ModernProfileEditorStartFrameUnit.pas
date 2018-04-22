unit ModernProfileEditorStartFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, Grids, ComCtrls, ExtCtrls, GameDBUnit,
  ModernProfileEditorFormUnit;

type
  TModernProfileEditorStartFrame = class(TFrame, IModernProfileEditorFrame)
    AutoexecOverrideGameStartCheckBox: TCheckBox;
    AutoexecOverrideMountingCheckBox: TCheckBox;
    AutoexecBootNormal: TRadioButton;
    AutoexecBootHDImage: TRadioButton;
    AutoexecBootFloppyImage: TRadioButton;
    AutoexecBootFloppyImageInfoLabel: TLabel;
    AutoexecBootFloppyImageTab: TStringGrid;
    AutoexecBootHDImageComboBox: TComboBox;
    AutoexecBootFloppyImageButton: TSpeedButton;
    AutoexecBootFloppyImageAddButton: TSpeedButton;
    AutoexecBootFloppyImageDelButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    AutoexecPageControl: TPageControl;
    AutoexecSheet1: TTabSheet;
    AutoexecSheet2: TTabSheet;
    Panel12: TPanel;
    Panel1: TPanel;
    AutoexecMemo: TRichEdit;
    AutoexecClearButton: TBitBtn;
    AutoexecLoadButton: TBitBtn;
    AutoexecSaveButton: TBitBtn;
    FinalizationClearButton: TBitBtn;
    FinalizationLoadButton: TBitBtn;
    FinalizationSaveButton: TBitBtn;
    FinalizationMemo: TRichEdit;
    procedure ButtonWork(Sender: TObject);
    procedure AutoexecBootHDImageComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, HelpConsts,
     IconLoaderUnit, TextEditPopupUnit;

{$R *.dfm}

{ TModernProfileEditorStartFrame }

procedure TModernProfileEditorStartFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var S : String;
begin
  NoFlicker(AutoexecOverrideGameStartCheckBox);
  NoFlicker(AutoexecOverrideMountingCheckBox);
  NoFlicker(AutoexecPageControl);
  {NoFlicker(AutoexecMemo); - will hide text in Memo}
  NoFlicker(AutoexecClearButton);
  NoFlicker(AutoexecLoadButton);
  NoFlicker(AutoexecSaveButton);
  NoFlicker(AutoexecBootNormal);
  NoFlicker(AutoexecBootHDImage);
  NoFlicker(AutoexecBootFloppyImage);
  NoFlicker(AutoexecBootHDImageComboBox);
  NoFlicker(AutoexecBootFloppyImageTab);

  SetRichEditPopup(AutoexecMemo);
  SetRichEditPopup(FinalizationMemo);

  AutoexecOverrideGameStartCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideGameStart;
  AutoexecOverrideMountingCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideMounting;
  S:=LanguageSetup.ProfileEditorAutoexecBat;
  If (S<>'') and (S[length(S)]=':') then S:=Trim(Copy(S,1,length(S)-1));
  AutoexecSheet1.Caption:=S;
  AutoexecMemo.Font.Name:='Courier New';
  AutoexecClearButton.Caption:=LanguageSetup.Del;
  AutoexecLoadButton.Caption:=LanguageSetup.Load;
  AutoexecSaveButton.Caption:=LanguageSetup.Save;
  AutoexecSheet2.Caption:=LanguageSetup.ProfileEditorFinalization;
  FinalizationMemo.Font.Name:='Courier New';
  FinalizationClearButton.Caption:=LanguageSetup.Del;
  FinalizationLoadButton.Caption:=LanguageSetup.Load;
  FinalizationSaveButton.Caption:=LanguageSetup.Save;
  AutoexecBootNormal.Caption:=LanguageSetup.ProfileEditorAutoexecBootNormal;
  AutoexecBootHDImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootHDImage;
  AutoexecBootFloppyImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootFloppyImage;
  AutoexecBootFloppyImageInfoLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  AutoexecBootFloppyImageButton.Hint:=LanguageSetup.ChooseFile;
  AutoexecBootFloppyImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  AutoexecBootFloppyImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;

  UserIconLoader.DialogImage(DI_Clear,AutoexecClearButton);
  UserIconLoader.DialogImage(DI_Load,AutoexecLoadButton);
  UserIconLoader.DialogImage(DI_Save,AutoexecSaveButton);
  UserIconLoader.DialogImage(DI_Clear,FinalizationClearButton);
  UserIconLoader.DialogImage(DI_Load,FinalizationLoadButton);
  UserIconLoader.DialogImage(DI_Save,FinalizationSaveButton);
  UserIconLoader.DialogImage(DI_SelectFile,AutoexecBootFloppyImageButton);
  UserIconLoader.DialogImage(DI_Add,AutoexecBootFloppyImageAddButton);
  UserIconLoader.DialogImage(DI_Delete,AutoexecBootFloppyImageDelButton);

  AutoexecBootFloppyImageTab.ColWidths[0]:=AutoexecBootFloppyImageTab.ClientWidth-25;

  HelpContext:=ID_ProfileEditStarting;
end;

procedure TModernProfileEditorStartFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St, St2 : TStringList;
    S : String;
    I : Integer;
begin
  AutoexecOverrideGameStartCheckBox.Checked:=Game.AutoexecOverridegamestart;
  AutoexecOverrideMountingCheckBox.Checked:=Game.AutoexecOverrideMount;
  St:=StringToStringList(Game.Autoexec); try AutoexecMemo.Lines.Assign(St); finally St.Free; end;
  St:=StringToStringList(Game.AutoexecFinalization); try FinalizationMemo.Lines.Assign(St); finally St.Free; end;
  S:=Trim(Game.AutoexecBootImage);
  If (S='2') or (S='3') then begin
    AutoexecBootHDImage.Checked:=True;
    If S='2' then AutoexecBootHDImageComboBox.ItemIndex:=0 else AutoexecBootHDImageComboBox.ItemIndex:=1;
  end else If S<>'' then begin
    AutoexecBootFloppyImage.Checked:=True;
    St2:=TStringList.Create;
    try
      S:=Trim(S);
      I:=Pos('$',S);
      While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
      St2.Add(S);
      AutoexecBootFloppyImageTab.RowCount:=St2.Count;
      For I:=0 to St2.Count-1 do AutoexecBootFloppyImageTab.Cells[0,I]:=St2[I];
    finally
      St2.Free;
    end;
  end;
end;

procedure TModernProfileEditorStartFrame.AutoexecBootHDImageComboBoxChange(Sender: TObject);
begin
  AutoexecBootHDImage.Checked:=True;
end;

procedure TModernProfileEditorStartFrame.ButtonWork(Sender: TObject);
Var I : Integer;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : AutoexecMemo.Lines.Clear;
    1 : begin
          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorAutoexecLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir;
          if not OpenDialog.Execute then exit;
          try
            AutoexecMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    2 : begin
          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorAutoexecSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir;
          if not SaveDialog.Execute then exit;
          try
            AutoexecMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    3 : begin
          If AutoexecBootFloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=MakeAbsPath(AutoexecBootFloppyImageTab.Cells[0,AutoexecBootFloppyImageTab.Row],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='img';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          AutoexecBootFloppyImageTab.Cells[0,AutoexecBootFloppyImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          AutoexecBootFloppyImage.Checked:=True;
        end;
    4 : begin
          AutoexecBootFloppyImageTab.RowCount:=AutoexecBootFloppyImageTab.RowCount+1;
          AutoexecBootFloppyImageTab.Row:=AutoexecBootFloppyImageTab.RowCount-1;
        end;
    5 : begin
          If AutoexecBootFloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          If AutoexecBootFloppyImageTab.RowCount=1 then begin
            AutoexecBootFloppyImageTab.Cells[0,0]:='';
          end else begin
            For I:=AutoexecBootFloppyImageTab.Row+1 to AutoexecBootFloppyImageTab.RowCount-1 do AutoexecBootFloppyImageTab.Cells[0,I-1]:=AutoexecBootFloppyImageTab.Cells[0,I];
            AutoexecBootFloppyImageTab.RowCount:=AutoexecBootFloppyImageTab.RowCount-1;
          end;
        end;
    6 : FinalizationMemo.Lines.Clear;
    7 : begin
          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorFinalizationLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir;
          if not OpenDialog.Execute then exit;
          try
            FinalizationMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    8 : begin
          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorFinalizationSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir;
          if not SaveDialog.Execute then exit;
          try
            FinalizationMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
  end;
end;

procedure TModernProfileEditorStartFrame.GetGame(const Game: TGame);
Var S : String;
    I : Integer;
begin
  Game.AutoexecOverridegamestart:=AutoexecOverrideGameStartCheckBox.Checked;
  Game.AutoexecOverrideMount:=AutoexecOverrideMountingCheckBox.Checked;
  Game.Autoexec:=StringListToString(AutoexecMemo.Lines);
  Game.AutoexecFinalization:=StringListToString(FinalizationMemo.Lines);
  If AutoexecBootNormal.Checked then Game.AutoexecBootImage:='';
  If AutoexecBootHDImage.Checked then begin
    If AutoexecBootHDImageComboBox.ItemIndex=0 then Game.AutoexecBootImage:='2' else Game.AutoexecBootImage:='3';
  end;
  If AutoexecBootFloppyImage.Checked then begin
    S:=AutoexecBootFloppyImageTab.Cells[0,0];
    For I:=1 to AutoexecBootFloppyImageTab.RowCount-1 do S:=S+'$'+AutoexecBootFloppyImageTab.Cells[0,I];
    Game.AutoexecBootImage:=S;
  end;
end;

end.
