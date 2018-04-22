unit CheatDBInternalPrivateerPositionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TCheatDBInternalPrivateerPositionForm = class(TForm)
    PositionLabel: TLabel;
    PositionComboBox: TComboBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  CheatDBInternalPrivateerPositionForm: TCheatDBInternalPrivateerPositionForm;

Function ShowCheatDBInternalPrivateerPositionDialog(const AOwner : TComponent; var APosition : Byte) : Boolean;

implementation

uses VistaToolsUnit, CommonTools, LanguageSetupUnit, IconLoaderUnit;

{$R *.dfm}

const StarCount=59;

Type TStar=record
       Name : String;
       pos : Byte;
     end;
     TStars=Array[1..StarCount] of TStar;

Const Planets : TStars = (
      (Name:'Aldebran  Matahari(Pleasure)';Pos:$19),
      (Name:'Auriga  Beaconsfield(Refinery)';Pos:$04),
      (Name:'Auriga  Elysia(Agricular)';Pos:$0B),
      (Name:'Capella  -(Pirates)';Pos:$08),
      (Name:'Castor  Romulus(Mining)';Pos:$2D),
      (Name:'DN-N1921  N1912-1(Pleasure)';Pos:$1E),
      (Name:'Hind''s Variable N  Meadow(Refinery)';Pos:$1A),
      (Name:'Hind''s Variable N  Oresville(Agricular)';Pos:$26),
      (Name:'Hyades  Charon(Mining';Pos:$07),
      (Name:'Junction  Burton(Agricular)';Pos:$06),
      (Name:'Junction  Speke(Pleasure)';Pos:$32),
      (Name:'Junction  Victoria(Agricular)';Pos:$38),
      (Name:'KM252  -(Pirates)';Pos:$31),
      (Name:'Lisacc  Lisacc(Mining)';Pos:$15),
      (Name:'Manchester  Thisbury(Refinery)';Pos:$34),
      (Name:'Manchester  Wickerton(Refinery)';Pos:$3A),
      (Name:'Midgard  Heimdel(Agricular)';Pos:$10),
      (Name:'ND-57  New Reno(Pleasure)';Pos:$22),
      (Name:'New Caledonia  Edinburgh(Refinery)';Pos:$09),
      (Name:'New Caledonia  Glasgow(Refinery)';Pos:$0D),
      (Name:'Newcastle  Liverpool(Refinery)';Pos:$16),
      (Name:'New Constantinople  Edam(Agricular)';Pos:$0A),
      (Name:'New Constantinople  New Const.(Base)';Pos:$1F),
      (Name:'New Detroit  New Detroit';Pos:$20),
      (Name:'Nexus  Macabee(Mining)';Pos:$17),
      (Name:'Nitir  Nitir(Agricular)';Pos:$23),
      (Name:'Oxford  Oxford(Base)';Pos:$27),
      (Name:'Padre  Magdalina(Pleasure)';Pos:$18),
      (Name:'Palan  Basra(Refinery)';Pos:$03),
      (Name:'Palan  Palan';Pos:$28),
      (Name:'Pentonville  -(Pirates)';Pos:$24),
      (Name:'Perry  Anapolis(Refinery)';Pos:$01),
      (Name:'Perry  Perry Naval(Base))';Pos:$29),
      (Name:'Pollux  Remus(Refinery)';Pos:$2A),
      (Name:'Prosepe  Savatov(Mining)';Pos:$2F),
      (Name:'Pyrenees  Basque(Mining)';Pos:$02),
      (Name:'Pyrenees  New Iberia(Agricular)';Pos:$21),
      (Name:'Ragnarok  Mjolnar(Agricular)';Pos:$1C),
      (Name:'Raxis  Gracchus(Refinery)';Pos:$0E),
      (Name:'Raxis  Trinsic(Agricular)';Pos:$35),
      (Name:'Regallis  Kronecker(Mining)';Pos:$14),
      (Name:'Rikel  Siva(Agricular)';Pos:$30),
      (Name:'Rikel  Vishnu(Mining)';Pos:$39),
      (Name:'Rygannon  Rygannon(Mining)';Pos:$2E),
      (Name:'Saxtogue  Olympus(Pleasure)';Pos:$25),
      (Name:'Shangri-La  Erwhon(Pleasure)';Pos:$0C),
      (Name:'Sherwood  -(Pirates)';Pos:$36),
      (Name:'Surtur  Surtur(Agricular)';Pos:$33),
      (Name:'Telar  -(Pirates)';Pos:$1B),
      (Name:'Tingerhoff  Bodensee(Agricular)';Pos:$05),
      (Name:'Tingerhoff  Munchen(Refinery)';Pos:$1D),
      (Name:'Troy  Achilles(Mining)';Pos:$00),
      (Name:'Troy  Hector(Mining)';Pos:$0F),
      (Name:'Troy  Helen(Agricular)';Pos:$11),
      (Name:'Valhalla  Valkyrie(Mining)';Pos:$37),
      (Name:'Varnus  Rodin(Agricular)';Pos:$2C),
      (Name:'Varnus  Rilke(Refinery)';Pos:$2B),
      (Name:'XXN-1927  Jalson(Pleasure)';Pos:$12),
      (Name:'XXN-1927  Joplin(Refinery)';Pos:$13) );

procedure TCheatDBInternalPrivateerPositionForm.FormCreate(Sender: TObject);
Var I : Integer;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.EditCheatsInternalPrivateerPosition;
  PositionLabel.Caption:=LanguageSetup.EditCheatsInternalPrivateerPositionPrompt;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  For I:=1 to StarCount do PositionComboBox.Items.AddObject(Planets[I].Name,TObject(Planets[I].Pos));
  PositionComboBox.ItemIndex:=0;
end;

{ global }

Function ShowCheatDBInternalPrivateerPositionDialog(const AOwner : TComponent; var APosition : Byte) : Boolean;
Var I : Integer;
begin
  CheatDBInternalPrivateerPositionForm:=TCheatDBInternalPrivateerPositionForm.Create(AOwner);
  try
    For I:=0 to CheatDBInternalPrivateerPositionForm.PositionComboBox.Items.Count-1 do If Integer(CheatDBInternalPrivateerPositionForm.PositionComboBox.Items.Objects[I])=APosition then begin
      CheatDBInternalPrivateerPositionForm.PositionComboBox.ItemIndex:=I; break;
    end;
    result:=(CheatDBInternalPrivateerPositionForm.ShowModal=mrOK) and (CheatDBInternalPrivateerPositionForm.PositionComboBox.ItemIndex>=0);
    if result then APosition:=CheatDBInternalPrivateerPositionForm.PositionComboBox.ItemIndex;
  finally
    CheatDBInternalPrivateerPositionForm.Free;
  end;
end;

end.
