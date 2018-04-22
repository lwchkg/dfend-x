unit SetupFrameWineUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, SetupFormUnit;

type
  TSetupFrameWine = class(TFrame, ISetupFrame)
    MainCheckBox: TCheckBox;
    MainInfoLabel: TLabel;
    ListInfoLabel: TLabel;
    List: TValueListEditor;
    RemapMountsCheckBox: TCheckBox;
    RemapScreenshotFolderCheckBox: TCheckBox;
    RemapMapperFileCheckBox: TCheckBox;
    RemapDOSBoxFolderCheckBox: TCheckBox;
    LinuxLinkModeCheckBox: TCheckBox;
    ShellScriptPreambleEdit: TLabeledEdit;
  private
    { Private-Deklarationen }
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameWineFrame }

function TSetupFrameWine.GetName: String;
begin
  result:=LanguageSetup.SetupFormWine;
end;

procedure TSetupFrameWine.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
begin
  NoFlicker(MainCheckBox);
  NoFlicker(List);
  NoFlicker(RemapMountsCheckBox);
  NoFlicker(RemapScreenshotFolderCheckBox);
  NoFlicker(RemapMapperFileCheckBox);
  NoFlicker(RemapDOSBoxFolderCheckBox);
  NoFlicker(LinuxLinkModeCheckBox);
  NoFlicker(ShellScriptPreambleEdit);

  MainCheckBox.Checked:=PrgSetup.EnableWineMode;
  For I:=0 to 25 do List.Strings.Add(chr(ord('A')+I)+':='+PrgSetup.LinuxRemap[chr(ord('A')+I)]);
  RemapMountsCheckBox.Checked:=PrgSetup.RemapMounts;
  RemapScreenshotFolderCheckBox.Checked:=PrgSetup.RemapScreenShotFolder;
  RemapMapperFileCheckBox.Checked:=PrgSetup.RemapMapperFile;
  RemapDOSBoxFolderCheckBox.Checked:=PrgSetup.RemapDOSBoxFolder;
  LinuxLinkModeCheckBox.Checked:=PrgSetup.LinuxLinkMode;
  ShellScriptPreambleEdit.Text:=PrgSetup.LinuxShellScriptPreamble;
end;

procedure TSetupFrameWine.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameWine.LoadLanguage;
begin
  MainCheckBox.Caption:=LanguageSetup.SetupFormWineEnable;
  MainInfoLabel.Caption:=LanguageSetup.SetupFormWineEnableInfo;

  ListInfoLabel.Caption:=LanguageSetup.SetupFormWineRemap;
  List.TitleCaptions[0]:=LanguageSetup.SetupFormWineRemapDriveLetter;
  List.TitleCaptions[1]:=LanguageSetup.SetupFormWineRemapLinuxPath;

  RemapMountsCheckBox.Caption:=LanguageSetup.SetupFormWineRemapMounts;
  RemapScreenshotFolderCheckBox.Caption:=LanguageSetup.SetupFormWineRemapScreenshots;
  RemapMapperFileCheckBox.Caption:=LanguageSetup.SetupFormWineRemapMapperFile;
  RemapDOSBoxFolderCheckBox.Caption:=LanguageSetup.SetupFormWineRemapDOSBox;

  LinuxLinkModeCheckBox.Caption:=LanguageSetup.SetupFormWineLinuxLinkMode;
  ShellScriptPreambleEdit.EditLabel.Caption:=LanguageSetup.SetupFormWineShellPreamble;

  HelpContext:=ID_FileOptionsWineSupport;
end;

procedure TSetupFrameWine.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameWine.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameWine.HideFrame;
begin
end;

procedure TSetupFrameWine.RestoreDefaults;
Var I : Integer;
begin
  MainCheckBox.Checked:=False;
  For I:=0 to 25 do List.Strings[I]:=(chr(ord('A')+I)+':=');
  RemapMountsCheckBox.Checked:=False;
  RemapScreenshotFolderCheckBox.Checked:=False;
  RemapMapperFileCheckBox.Checked:=False;
  RemapDOSBoxFolderCheckBox.Checked:=False;
  LinuxLinkModeCheckBox.Checked:=False;
  ShellScriptPreambleEdit.Text:='#!/bin/bash';
end;

procedure TSetupFrameWine.SaveSetup;
Var I : Integer;
begin
  PrgSetup.EnableWineMode:=MainCheckBox.Checked;
  For I:=0 to 25 do PrgSetup.LinuxRemap[chr(ord('A')+I)]:=List.Strings.ValueFromIndex[I];
  PrgSetup.RemapMounts:=RemapMountsCheckBox.Checked;
  PrgSetup.RemapScreenShotFolder:=RemapScreenshotFolderCheckBox.Checked;
  PrgSetup.RemapMapperFile:=RemapMapperFileCheckBox.Checked;
  PrgSetup.RemapDOSBoxFolder:=RemapDOSBoxFolderCheckBox.Checked;
  PrgSetup.LinuxLinkMode:=LinuxLinkModeCheckBox.Checked;
  PrgSetup.LinuxShellScriptPreamble:=ShellScriptPreambleEdit.Text;
end;

end.
