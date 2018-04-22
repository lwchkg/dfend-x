unit ZipWaitInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList;

type
  TZipWaitInfoForm = class(TForm)
    BottomPanel: TPanel;
    TopPanel: TPanel;
    CloseButton: TBitBtn;
    InfoLabel: TLabel;
    Tree: TTreeView;
    ImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    SaveInfoBarNotify : TNotifyEvent;
    Procedure InfoBarEvent(Sender : TObject);
    Procedure UpdateTree;
  public
    { Public-Deklarationen }
  end;

var
  ZipWaitInfoForm: TZipWaitInfoForm;

Procedure ShowZipWaitInfoDialog(const AOwner : TComponent);

implementation

uses CommonTools, LanguageSetupUnit, VistaToolsUnit, ZipManagerUnit,
     PrgSetupUnit, IconLoaderUnit;

{$R *.dfm}

Procedure ShowZipWaitInfoDialog(const AOwner : TComponent);
begin
  ZipWaitInfoForm:=TZipWaitInfoForm.Create(AOwner);
  try
    ZipWaitInfoForm.ShowModal;
  finally
    ZipWaitInfoForm.Free;
  end;
end;

procedure TZipWaitInfoForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ZipWaitInfoForm;
  InfoLabel.Caption:=LanguageSetup.ZipWaitInfoFormInfo;
  CloseButton.Caption:=LanguageSetup.Close;

  UserIconLoader.DialogImage(DI_ImageHD,ImageList,1);
  UserIconLoader.DialogImage(DI_ZipFile,ImageList,2);
  UserIconLoader.DialogImage(DI_SelectFolder,ImageList,3);
  UserIconLoader.DialogImage(DI_Close,CloseButton);

  SaveInfoBarNotify:=nil;
end;

procedure TZipWaitInfoForm.FormShow(Sender: TObject);
begin
  If not Assigned(SaveInfoBarNotify) then begin
    SaveInfoBarNotify:=ZipManager.OnInfoBarNotify;
    ZipManager.OnInfoBarNotify:=InfoBarEvent;
  end;
  UpdateTree;
end;

procedure TZipWaitInfoForm.FormHide(Sender: TObject);
begin
  If Assigned(SaveInfoBarNotify) then begin
    ZipManager.OnInfoBarNotify:=SaveInfoBarNotify;
    SaveInfoBarNotify:=nil; 
  end;
end;

procedure TZipWaitInfoForm.InfoBarEvent(Sender: TObject);
begin
  UpdateTree;
  If Assigned(SaveInfoBarNotify) then SaveInfoBarNotify(Sender);

  If Tree.Items.Count=0 then Close;
end;

procedure TZipWaitInfoForm.UpdateTree;
Var I,J : Integer;
    R : TZipRecord;
    N,N2,N3 : TTreeNode;
    S,T : String;
begin
  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    For I:=0 to ZipManager.Count-1 do begin
      R:=ZipManager.Data[I];

      If R.IsScummVM then begin
        S:=LanguageSetup.ZipWaitInfoFormDriveScummVM;
        T:=LanguageSetup.ZipWaitInfoFormScummVM;
      end else begin
        S:=LanguageSetup.ZipWaitInfoFormDriveDOSBox;
        T:=LanguageSetup.ZipWaitInfoFormDOSBox;
      end;

      N:=Tree.Items.AddChild(nil,T+': $'+IntToHex(R.DOSBoxHandle,8));
      N.ImageIndex:=0; N.SelectedIndex:=0;
      For J:=0 to R.ZipDrives-1 do begin
        N2:=Tree.Items.AddChild(N,S+' '+R.DriveLetter[J]);
        N2.ImageIndex:=1; N2.SelectedIndex:=1;
        N3:=Tree.Items.AddChild(N2,LanguageSetup.ZipWaitInfoFormZipFile+': '+MakeRelPath(R.ZipFile[J],PrgSetup.BaseDir));
        N3.ImageIndex:=2; N3.SelectedIndex:=2;
        N3:=Tree.Items.AddChild(N2,LanguageSetup.ZipWaitInfoFormFolder+': '+MakeRelPath(R.Folder[J],PrgSetup.BaseDir,True));
        N3.ImageIndex:=3; N3.SelectedIndex:=3;
      end;
    end;
    Tree.FullExpand;
  finally
    Tree.Items.EndUpdate;
  end;
end;

end.
