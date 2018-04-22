unit SetupFrameSurfaceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit, CheckLst, ExtCtrls;

type
  TSetupFrameSurface = class(TFrame, ISetupFrame)
    StartSizeLabel: TLabel;
    StartSizeComboBox: TComboBox;
    IconSetLabel: TLabel;
    IconSetListbox: TCheckListBox;
    IconSetAuthorLabel: TLabel;
    IconSetAuthorNameLabel: TLabel;
    IconSetPreviewLabel: TLabel;
    IconSetImage: TImage;
    IconCustomizeLabel: TLabel;
    procedure IconSetListboxClick(Sender: TObject);
    procedure IconSetListboxClickCheck(Sender: TObject);
    procedure IconCustomizeLabelClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ShortName, LongName, Author : TStringList;
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
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

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts, IconLoaderUnit, PrgConsts;

{$R *.dfm}

{ TSetupFrameSurface }

destructor TSetupFrameSurface.Destroy;
begin
  ShortName.Free;
  LongName.Free;
  Author.Free;
  inherited Destroy;
end;

function TSetupFrameSurface.GetName: String;
begin
  result:=LanguageSetup.SetupFormGUI;
end;

procedure TSetupFrameSurface.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
    S : String;
begin
  NoFlicker(StartSizeComboBox);
  {NoFlicker(IconSetListbox); - will cause trouble}

  StartSizeComboBox.ItemIndex:=Max(0,Min(StartSizeComboBox.Items.Count-1,PrgSetup.StartWindowSize));

  ShortName:=TStringList.Create;
  LongName:=TStringList.Create;
  Author:=TStringList.Create;
  ListOfIconSets(ShortName,LongName,Author,nil);
  IconSetListbox.Items.AddStrings(LongName);
  If IconSetListbox.Items.Count>0 then IconSetListbox.ItemIndex:=0;
  S:=ExtUpperCase(PrgSetup.IconSet);
  For I:=0 to ShortName.Count-1 do If S=ExtUpperCase(ShortName[I]) then begin
    IconSetListbox.Checked[I]:=True; IconSetListbox.ItemIndex:=I; break;
  end;
  IconSetListboxClick(self);

  with IconCustomizeLabel.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  IconCustomizeLabel.Cursor:=crHandPoint;
end;

procedure TSetupFrameSurface.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameSurface.LoadLanguage;
Var I : Integer;
begin
  StartSizeLabel.Caption:=LanguageSetup.SetupFormStartSizeLabel;
  I:=StartSizeComboBox.ItemIndex;
  StartSizeComboBox.Items[0]:=LanguageSetup.SetupFormStartSizeNormal;
  StartSizeComboBox.Items[1]:=LanguageSetup.SetupFormStartSizeLast;
  StartSizeComboBox.Items[2]:=LanguageSetup.SetupFormStartSizeMinimized;
  StartSizeComboBox.Items[3]:=LanguageSetup.SetupFormStartSizeMaximized;
  StartSizeComboBox.Items[4]:=LanguageSetup.SetupFormStartSizeFullscreen;
  StartSizeComboBox.ItemIndex:=I;
  
  IconSetLabel.Caption:=LanguageSetup.SetupFormIconSet;
  IconSetPreviewLabel.Caption:=LanguageSetup.SetupFormIconSetPreview;
  IconSetAuthorLabel.Caption:=LanguageSetup.SetupFormIconSetAuthor;

  IconCustomizeLabel.Caption:=LanguageSetup.SetupFormIconSetCustomize;

  HelpContext:=ID_FileOptionsUserInterface;
end;

procedure TSetupFrameSurface.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameSurface.ShowFrame(const AdvancedMode: Boolean);
begin
end;

procedure TSetupFrameSurface.HideFrame;
begin
end;

procedure TSetupFrameSurface.RestoreDefaults;
begin
  StartSizeComboBox.ItemIndex:=0;
end;

procedure TSetupFrameSurface.SaveSetup;
Var S : String;
    I : Integer;
begin
  PrgSetup.StartWindowSize:=StartSizeComboBox.ItemIndex;
  
  S:='';
  For I:=0 to IconSetListbox.Items.Count-1 do If IconSetListbox.Checked[I] then begin S:=ShortName[I]; break; end;
  If S<>'' then PrgSetup.IconSet:=S;
end;

procedure TSetupFrameSurface.IconSetListboxClick(Sender: TObject);
Var B : TBitmap;
begin
  If IconSetListbox.ItemIndex>=0 then begin
    IconSetAuthorNameLabel.Caption:=Author[IconSetListbox.ItemIndex];
    B:=GetExampleImage(ShortName[IconSetListbox.ItemIndex]);
    If B=nil then begin
      IconSetImage.Picture.Bitmap.Height:=0;
    end else begin
      IconSetImage.Picture.Assign(B);
      B.Free;
    end;
  end else begin
    IconSetAuthorNameLabel.Caption:='';
    IconSetImage.Picture.Bitmap.Height:=0;
  end;
end;

procedure TSetupFrameSurface.IconSetListboxClickCheck(Sender: TObject);
Var I,J : Integer;
    B : Boolean;
begin
  {No entry checked}
  B:=False;
  For I:=0 to IconSetListbox.Items.Count-1 do If IconSetListbox.Checked[I] then begin B:=True; break; end;
  If not B then begin
    If IconSetListbox.ItemIndex>=0 then IconSetListbox.Checked[IconSetListbox.ItemIndex]:=True else begin
      If IconSetListbox.Items.Count>0 then IconSetListbox.Checked[0]:=True;
    end;
    exit;
  end;

  {Remove multiple checks}
  J:=0; For I:=0 to IconSetListbox.Items.Count-1 do If IconSetListbox.Checked[I] then inc(J);
  If J>1 then begin
    If (IconSetListbox.ItemIndex>=0) and IconSetListbox.Checked[IconSetListbox.ItemIndex] then begin
      For I:=0 to IconSetListbox.Items.Count-1 do IconSetListbox.Checked[I]:=(I=IconSetListbox.ItemIndex);
    end else begin
      B:=False;
      For I:=0 to IconSetListbox.Items.Count-1 do If IconSetListbox.Checked[I] then begin
        If B then IconSetListbox.Checked[I]:=False else B:=True;
      end;
    end;
  end;
end;

procedure TSetupFrameSurface.IconCustomizeLabelClick(Sender: TObject);
begin
  If FileExists(PrgDataDir+SettingsFolder+'\'+IconsConfFile)
    then OpenFileInEditor(PrgDataDir+SettingsFolder+'\'+IconsConfFile)
    else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[PrgDataDir+SettingsFolder+'\'+IconsConfFile]),mtError,[mbOK],0);
end;

end.
