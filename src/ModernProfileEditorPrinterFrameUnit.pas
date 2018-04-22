unit ModernProfileEditorPrinterFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorPrinterFrame = class(TFrame, IModernProfileEditorFrame)
    EnablePrinterEmulationCheckBox: TCheckBox;
    ResolutionLabel: TLabel;
    ResolutionEdit: TSpinEdit;
    PaperWidthLabel: TLabel;
    PaperHeightLabel: TLabel;
    PaperWidthEdit: TSpinEdit;
    PaperHeightEdit: TSpinEdit;
    PaperSizeInfoLabel: TLabel;
    OutputFormatLabel: TLabel;
    OutputFormatComboBox: TComboBox;
    MultiPageCheckBox: TCheckBox;
    OutputFormatInfoLabel: TLabel;
    MultiPageInfoLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TFrame1 }

procedure TModernProfileEditorPrinterFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  NoFlicker(EnablePrinterEmulationCheckBox);
  NoFlicker(ResolutionEdit);
  NoFlicker(PaperWidthEdit);
  NoFlicker(PaperHeightEdit);
  NoFlicker(OutputFormatComboBox);
  NoFlicker(MultiPageCheckBox);

  EnablePrinterEmulationCheckBox.Caption:=LanguageSetup.GameEnablePrinterEmulation;
  ResolutionLabel.Caption:=LanguageSetup.GamePrinterResolution;
  PaperWidthLabel.Caption:=LanguageSetup.GamePaperWidth;
  PaperHeightLabel.Caption:=LanguageSetup.GamePaperHeight;
  PaperSizeInfoLabel.Caption:=LanguageSetup.GamePaperSizeInfo;
  OutputFormatLabel.Caption:=LanguageSetup.GamePrinterOutputFormat;
  OutputFormatInfoLabel.Caption:=LanguageSetup.GamePrinterOutputFormatInfo;
  with OutputFormatComboBox.Items do begin Add('png'); Add('ps'); Add('bmp'); Add('printer'); end;
  MultiPageCheckBox.Caption:=LanguageSetup.GamePrinterMultiPage;
  MultiPageInfoLabel.Caption:=LanguageSetup.GamePrinterMultiPageInfo;

  HelpContext:=ID_ProfileEditPrinter;
end;

procedure TModernProfileEditorPrinterFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
    S : String;
begin
  EnablePrinterEmulationCheckBox.Checked:=Game.EnablePrinterEmulation;
  ResolutionEdit.Value:=Game.PrinterResolution;
  PaperWidthEdit.Value:=Game.PaperWidth;
  PaperHeightEdit.Value:=Game.PaperHeight;

  S:=Trim(ExtUpperCase(Game.PrinterOutputFormat));
  OutputFormatComboBox.ItemIndex:=1;
  For I:=0 to OutputFormatComboBox.Items.Count-1 do If Trim(ExtUpperCase(OutputFormatComboBox.Items[I]))=S then begin
    OutputFormatComboBox.ItemIndex:=I;
    break;
  end;

  MultiPageCheckBox.Checked:=Game.PrinterMultiPage;
end;

procedure TModernProfileEditorPrinterFrame.GetGame(const Game: TGame);
begin
  Game.EnablePrinterEmulation:=EnablePrinterEmulationCheckBox.Checked;
  Game.PrinterResolution:=ResolutionEdit.Value;
  Game.PaperWidth:=PaperWidthEdit.Value;
  Game.PaperHeight:=PaperHeightEdit.Value;
  Game.PrinterOutputFormat:=OutputFormatComboBox.Text;
  Game.PrinterMultiPage:=MultiPageCheckBox.Checked;
end;

end.
