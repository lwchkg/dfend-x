unit WizardTemplateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ExtCtrls, StdCtrls, Buttons;

type
  TWizardTemplateFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    TemplateType1: TRadioButton;
    TemplateType2: TRadioButton;
    TemplateType1List: TComboBox;
    TemplateType2List: TComboBox;
    TemplateType4: TRadioButton;
    TemplateType4List: TComboBox;
    TemplateType5: TRadioButton;
    TemplateType3: TRadioButton;
    TemplateType3List: TComboBox;
    HelpButton: TSpeedButton;
    InfoPanel: TPanel;
    PanelInfoLabel: TLabel;
    OKButton: TBitBtn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    OperationModeInfoButton: TBitBtn;
    TemplateType5GroupBox: TGroupBox;
    CPUComboBox: TComboBox;
    MoreRAMCheckBox: TCheckBox;
    CloseDosBoxOnExitCheckBox: TCheckBox;
    StartFullscreenCheckBox: TCheckBox;
    CPULabel: TLabel;
    procedure IndirectTypeChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure OperationModeInfoButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FGameDB, TemplateDB, AutoSetupDB : TGameDB;
    Function CreateGameFromTemplate(const Template : TGame; const GameName : String) : TGame;
  public
    { Public-Deklarationen }
    Procedure Init(const AGameDB, ATemplateDB, AAutoSetupDB : TGameDB);
    Procedure Done;
    Procedure SearchTemplates(const GameFile : String);
    Function CreateGame(const GameName : String) : TGame;
    Function CreateWindowsGame(const GameName : String) : TGame;
    Function SelectedProfileSecure : Boolean;
    Function GetTemplate : TGame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, PrgConsts, HashCalc,
     CommonTools, WizardFormUnit, OperationModeInfoFormUnit, IconLoaderUnit,
     ZipPackageUnit;

{$R *.dfm}

{ TWizardTemplateFrame }

procedure TWizardTemplateFrame.IndirectTypeChange(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : TemplateType1.Checked:=True;
    1 : TemplateType2.Checked:=True;
    2 : TemplateType3.Checked:=True;
    3 : TemplateType4.Checked:=True;
    4 : TemplateType5.Checked:=True;
  end;
end;

procedure TWizardTemplateFrame.Init(const AGameDB, ATemplateDB, AAutoSetupDB : TGameDB);
Var I : Integer;
    St : TStringList;
begin
  SetVistaFonts(self);

  FGameDB:=AGameDB;
  TemplateDB:=ATemplateDB;
  AutoSetupDB:=AAutoSetupDB;

  InfoLabel.Font.Style:=[fsBold];
  TemplateType1.Font.Style:=[fsBold];
  TemplateType2.Font.Style:=[fsBold];
  TemplateType3.Font.Style:=[fsBold];
  TemplateType4.Font.Style:=[fsBold];
  TemplateType5.Font.Style:=[fsBold];

  InfoLabel.Caption:=LanguageSetup.WizardFormPage3Info;
  TemplateType1.Caption:=LanguageSetup.WizardFormTemplateType1;
  TemplateType2.Caption:=LanguageSetup.WizardFormTemplateType2;
  TemplateType3.Caption:=LanguageSetup.WizardFormTemplateType3;
  TemplateType4.Caption:=LanguageSetup.WizardFormTemplateType4;
  TemplateType5.Caption:=LanguageSetup.WizardFormTemplateType5;
  TemplateType5GroupBox.Caption:=LanguageSetup.WizardFormTemplateType5Settings;
  CPULabel.Caption:=LanguageSetup.WizardFormCPU;
  CPUComboBox.Items[0]:=LanguageSetup.WizardFormCPUType1;
  CPUComboBox.Items[1]:=LanguageSetup.WizardFormCPUType2;
  CPUComboBox.Items[2]:=LanguageSetup.WizardFormCPUType3;
  CPUComboBox.Items[3]:=LanguageSetup.WizardFormCPUType4;
  CPUComboBox.ItemIndex:=1;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  CloseDosBoxOnExitCheckBox.Caption:=LanguageSetup.GameCloseDosBoxAfterGameExit;
  MoreRAMCheckBox.Caption:=LanguageSetup.WizardFormMoreRAM;

  St:=StringToStringList(LanguageSetup.WizardFormTemplateInfo);
  try PanelInfoLabel.Caption:=St.Text; finally St.Free; end;
  For I:=0 to AutoSetupDB.Count-1 do TemplateType3List.Items.AddObject(AutoSetupDB[I].CacheName,AutoSetupDB[I]);
  If TemplateType3List.Items.Count>0 then TemplateType3List.ItemIndex:=0;
  TemplateType3.Enabled:=(TemplateType3List.Items.Count>0);
  TemplateType3List.Enabled:=(TemplateType3List.Items.Count>0);

  TemplateType4List.Items.AddObject(LanguageSetup.TemplateFormDefault,nil);
  For I:=0 to TemplateDB.Count-1 do TemplateType4List.Items.AddObject(TemplateDB[I].CacheName,TemplateDB[I]);
  TemplateType4List.ItemIndex:=0;

  OKButton.Caption:=LanguageSetup.OK;
  OperationModeInfoButton.Caption:=LanguageSetup.WizardFormOperationModeInfo;

  UserIconLoader.DialogImage(DI_ToolbarHelp,HelpButton);
  UserIconLoader.DialogImage(DI_ToolbarHelp,SpeedButton1);
  UserIconLoader.DialogImage(DI_ToolbarHelp,SpeedButton2);
  UserIconLoader.DialogImage(DI_ToolbarHelp,SpeedButton3);
  UserIconLoader.DialogImage(DI_ToolbarHelp,SpeedButton4);
end;

procedure TWizardTemplateFrame.Done;
begin
  TemplateDB.Free;
  AutoSetupDB.Free;
end;

procedure TWizardTemplateFrame.SearchTemplates(const GameFile : String);
Var I,J,NeededForList1 : Integer;
    GameCheckSum, GameFileShort : String;
    ListNr, ListType : TList;
    CompleteMatch : Boolean;
begin
  TemplateType1List.Items.Clear;
  TemplateType2List.Items.Clear;

  GameCheckSum:=GetMD5Sum(MakeAbsPath(GameFile,PrgSetup.BaseDir),False);
  If Trim(GameFile)='' then GameFileShort:='' else GameFileShort:=Trim(ExtUpperCase(ExtractFileName(GameFile)));

  {Find matching auto setup templates}
  ListNr:=TList.Create;
  ListType:=TList.Create;
  try
    CompleteMatch:=False;
    If GameFileShort<>'' then For I:=0 to AutoSetupDB.Count-1 do begin
      If Trim(ExtUpperCase(ExtractFileName(AutoSetupDB[I].GameExe)))<>GameFileShort then continue;
      ListNr.Add(Pointer(I));
      ListType.Add(Pointer(0));
      If (AutoSetupDB[I].GameExeMD5='') or (AutoSetupDB[I].GameExeMD5<>GameCheckSum) then continue;
      ListType[ListType.Count-1]:=Pointer(1);
      If not AdditionalDataMatching(ExtractFilePath(MakeAbsPath(GameFile,PrgSetup.BaseDir)),AutoSetupDB[I]) then continue;
      ListType[ListType.Count-1]:=Pointer(2);
      CompleteMatch:=True;
    end;
    If CompleteMatch then NeededForList1:=2 else NeededForList1:=1;
    For I:=0 to ListNr.Count-1 do begin
      J:=Integer(ListNr[I]);
      If Integer(ListType[I])<NeededForList1
        then TemplateType2List.Items.AddObject(AutoSetupDB[J].CacheName,AutoSetupDB[J])
        else TemplateType1List.Items.AddObject(AutoSetupDB[J].CacheName,AutoSetupDB[J]);
    end;
  finally
    ListNr.Free;
    ListType.Free;
  end;

  If TemplateType1List.Items.Count>0 then TemplateType1List.ItemIndex:=0;
  If TemplateType2List.Items.Count>0 then TemplateType2List.ItemIndex:=0;

  TemplateType1.Enabled:=(TemplateType1List.Items.Count>0);
  TemplateType1List.Enabled:=(TemplateType1List.Items.Count>0);
  TemplateType2.Enabled:=(TemplateType2List.Items.Count>0);
  TemplateType2List.Enabled:=(TemplateType2List.Items.Count>0);

  If TemplateType1.Enabled then begin TemplateType1.Checked:=True; exit; end;
  If TemplateType2.Enabled then begin TemplateType2.Checked:=True; exit; end;
  TemplateType4.Checked:=True;
end;

Function IsEmpty(const S : String) : Boolean;
Var I : Integer;
    St : TStringList;
begin
  result:=False;
  St:=StringToStringList(S);
  try
    For I:=0 to St.Count-1 do If Trim(St[I])<>'' then exit;
  finally
    St.Free;
  end;
  result:=True;
end;


function TWizardTemplateFrame.SelectedProfileSecure: Boolean;
Var Template : TGame;
    I : Integer;
    S : String;
    St : TStringList;
begin
  result:=True;
  Template:=GetTemplate;
  If Template=nil then exit;

  result:=IsEmpty(Template.Autoexec) and IsEmpty(Template.AutoexecFinalization) and IsEmpty(Template.CustomSettings);
  If not result then exit;

  For I:=0 to Template.NrOfMounts-1 do begin
    S:=Template.Mount[I];
    St:=ValueToList(S);
    try
      {Types to check:
       RealFolder;DRIVE;Letter;False;;FreeSpace
       RealFolder;FLOPPY;Letter;False;;
       RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace
       all other are images or read-only}
      If St.Count<2 then continue;
      S:=Trim(ExtUpperCase(St[1]));
      If (S<>'DRIVE') and (S<>'FLOPPY') and (S<>'PHYSFS') then continue;
      If (S='PHYSFS') and (Pos('$',St[0])>0) then begin
        S:=Trim(St[0]); S:=Trim(Copy(S,1,Pos('$',S)-1));
      end else begin
        S:=Trim(St[0]);
      end;
      S:=MakeRelPath(S,PrgSetup.BaseDir,True);
      If Copy(S,2,3)=':\' then begin result:=False; exit; end;
    finally
      St.Free;
    end;
  end;
end;

function TWizardTemplateFrame.GetTemplate: TGame;
begin
  result:=nil;
  If TemplateType1.Checked then result:=TGame(TemplateType1List.Items.Objects[TemplateType1List.ItemIndex]);
  If TemplateType2.Checked then result:=TGame(TemplateType2List.Items.Objects[TemplateType2List.ItemIndex]);
  If TemplateType3.Checked then result:=TGame(TemplateType3List.Items.Objects[TemplateType3List.ItemIndex]);
  If TemplateType4.Checked then result:=TGame(TemplateType4List.Items.Objects[TemplateType4List.ItemIndex]);
end;

Function TWizardTemplateFrame.CreateGameFromTemplate(const Template : TGame; const GameName : String) : TGame;
Var DefaultTemplate : TGame;
begin
  result:=FGameDB[FGameDB.Add(GameName)];
  If Template=nil then begin
    DefaultTemplate:=TGame.Create(PrgSetup);
    try result.AssignFrom(DefaultTemplate); finally DefaultTemplate.Free; end;
  end else begin
    result.AssignFrom(Template);
  end;
  result.Name:=GameName;
end;

procedure TWizardTemplateFrame.OperationModeInfoButtonClick(Sender: TObject);
begin
  ShowOperationModeInfoDialog(self);
end;

function TWizardTemplateFrame.CreateGame(const GameName: String): TGame;
begin
  result:=nil;

  If TemplateType1.Checked then begin result:=CreateGameFromTemplate(TGame(TemplateType1List.Items.Objects[TemplateType1List.ItemIndex]),GameName); exit; end;
  If TemplateType2.Checked then begin result:=CreateGameFromTemplate(TGame(TemplateType2List.Items.Objects[TemplateType2List.ItemIndex]),GameName); exit; end;
  If TemplateType3.Checked then begin result:=CreateGameFromTemplate(TGame(TemplateType3List.Items.Objects[TemplateType3List.ItemIndex]),GameName); exit; end;
  If TemplateType4.Checked then begin result:=CreateGameFromTemplate(TGame(TemplateType4List.Items.Objects[TemplateType4List.ItemIndex]),GameName); exit; end;

  If TemplateType5.Checked then begin
    result:=FGameDB[FGameDB.Add(GameName)];
    result.StartFullscreen:=StartFullscreenCheckBox.Checked;
    result.CloseDosBoxAfterGameExit:=CloseDosBoxOnExitCheckBox.Checked;
    if MoreRAMCheckBox.Checked then result.Memory:=63;
    Case CPUComboBox.ItemIndex of
      0 : begin result.Core:='normal'; result.Cycles:='3000'; end;
      1 : begin result.Core:='normal'; result.Cycles:='10000'; end;
      2 : begin result.Core:='dynamic'; result.Cycles:='30000'; end;
    end;
  end;
end;

function TWizardTemplateFrame.CreateWindowsGame(const GameName: String): TGame;
Var DefaultTemplate : TGame;
begin
  result:=FGameDB[FGameDB.Add(GameName)];
  DefaultTemplate:=TGame.Create(PrgSetup);
  try
    result.AssignFrom(DefaultTemplate);
  finally
    DefaultTemplate.Free;
  end;
  result.ProfileMode:='Windows';
  result.Name:=GameName;
end;

procedure TWizardTemplateFrame.HelpButtonClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          HelpButton.Enabled:=False;
          SpeedButton1.Visible:=False;
          SpeedButton2.Visible:=False;
          SpeedButton3.Visible:=False;
          SpeedButton4.Visible:=False;
          CPULabel.Visible:=False;
          TemplateType5GroupBox.Visible:=False;
          InfoPanel.Width:=ClientWidth-2*InfoPanel.Left;
          InfoPanel.Height:=ClientHeight-8-InfoPanel.Top;
          PanelInfoLabel.Width:=InfoPanel.ClientWidth-32;
          PanelInfoLabel.Height:=OKButton.Top-32;
          InfoPanel.Visible:=True;
          (Parent as TWizardForm).BottomPanel.Visible:=False;
        end;
    1 : MessageDlg(LanguageSetup.WizardFormTemplateType1Info,mtInformation,[mbOK],0);
    2 : MessageDlg(LanguageSetup.WizardFormTemplateType2Info,mtInformation,[mbOK],0);
    3 : MessageDlg(LanguageSetup.WizardFormTemplateType3Info,mtInformation,[mbOK],0);
    4 : MessageDlg(LanguageSetup.WizardFormTemplateType4Info,mtInformation,[mbOK],0);
  end;
end;

procedure TWizardTemplateFrame.OKButtonClick(Sender: TObject);
begin
  InfoPanel.Visible:=False;
  HelpButton.Enabled:=True;
  CPULabel.Visible:=True;
  SpeedButton1.Visible:=True;
  SpeedButton2.Visible:=True;
  SpeedButton3.Visible:=True;
  SpeedButton4.Visible:=True;
  TemplateType5GroupBox.Visible:=True;
  (Parent as TWizardForm).BottomPanel.Visible:=True;
end;

end.
