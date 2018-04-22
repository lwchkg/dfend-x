unit ViewImageFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, ExtCtrls, Menus;

type
  TViewImageForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ToolButton2: TToolButton;
    CopyButton: TToolButton;
    SaveButton: TToolButton;
    ClearButton: TToolButton;
    ImageList: TImageList;
    Image: TImage;
    SaveDialog: TSaveDialog;
    ToolButton1: TToolButton;
    BackgroundButton: TToolButton;
    PreviousButton: TToolButton;
    NextButton: TToolButton;
    StatusBar: TStatusBar;
    ZoomButton: TToolButton;
    ZoomPopupMenu: TPopupMenu;
    ZoomMenuItem1: TMenuItem;
    ZoomMenuItem2: TMenuItem;
    ZoomMenuItem3: TMenuItem;
    ZoomMenuItem4: TMenuItem;
    ZoomMenuItem5: TMenuItem;
    ZoomMenuItem6: TMenuItem;
    ZoomMenuItem7: TMenuItem;
    ZoomMenuItem8: TMenuItem;
    ZoomMenuItem9: TMenuItem;
    ZoomMenuItem10: TMenuItem;
    ZoomMenuItem11: TMenuItem;
    ZoomMenuItem12: TMenuItem;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ZoomPopupMenuPopup(Sender: TObject);
    procedure StatusBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    IntPicture : TPicture;
    IntBitmap100 : TBitmap;
    Procedure CenterWindow;
    Procedure LoadImage(const MoveWindow : Boolean);
    Procedure Zoom(const ZoomDirection : Integer);
  public
    { Public-Deklarationen }
    ImageFile : String;
    PrevImages, NextImages : TStringList;
    NonModal : Boolean;
    Procedure LoadLanguage;
    Procedure UpdateImageList;
  end;

var
  ViewImageForm: TViewImageForm = nil;

Procedure ShowNonModalImageDialog(const AOwner : TComponent; const AImageFile : String; APrevImages, ANextImages : TStringList);
Procedure ShowImageDialog(const AOwner : TComponent; const AImageFile : String; const APrevImages, ANextImages : TStringList);

implementation

uses Math, ClipBrd, VistaToolsUnit, LanguageSetupUnit, PNGImage, CommonTools,
     WallpaperStyleFormUnit, PrgSetupUnit, IconLoaderUnit, ImageStretch;

{$R *.dfm}

{ TViewImageForm }

procedure TViewImageForm.CenterWindow;
Var P : TForm;
    F : TFrame;
begin
  If Owner is TForm then begin
    P:=Owner as TForm;
    Left:=Max(0,(P.Left+P.Width div 2)-Width div 2);
    Top:=Max(0,(P.Top+P.Height div 2)-Height div 2);
  end;

  If Owner is TFrame then begin
    F:=Owner as TFrame;
    Left:=Max(0,(F.Left+F.Width div 2)-Width div 2);
    Top:=Max(0,(F.Top+F.Height div 2)-Height div 2);
  end;
end;

procedure TViewImageForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Action=caHide) and NonModal then Action:=caFree;
end;

procedure TViewImageForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  DoubleBuffered:=True;

  PrevImages:=TStringList.Create;
  NextImages:=TStringList.Create;

  NonModal:=False;
end;

procedure TViewImageForm.FormShow(Sender: TObject);
begin
  LoadLanguage;
  LoadImage(True);
end;

procedure TViewImageForm.LoadLanguage;
begin
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  Caption:=LanguageSetup.ViewImageForm;
  PreviousButton.Caption:=LanguageSetup.Previous;
  PreviousButton.Hint:=LanguageSetup.PreviousHintMediaViewer;
  NextButton.Caption:=LanguageSetup.Next;
  NextButton.Hint:=LanguageSetup.NextHintMediaViewer;
  CopyButton.Caption:=LanguageSetup.Copy;
  CopyButton.Hint:=LanguageSetup.CopyHintImageViewer;
  SaveButton.Caption:=LanguageSetup.Save;
  SaveButton.Hint:=LanguageSetup.SaveHintImageViewer;
  ClearButton.Caption:=LanguageSetup.Clear;
  ClearButton.Hint:=LanguageSetup.ClearMediaViewer;
  ZoomButton.Caption:=LanguageSetup.ViewImageFormZoomButton;
  ZoomButton.Hint:=LanguageSetup.ViewImageFormZoomButtonHint;
  BackgroundButton.Caption:=LanguageSetup.ViewImageFormBackgroundButton;
  BackgroundButton.Hint:=LanguageSetup.ViewImageFormBackgroundButtonHint;

  CoolBar.Font.Size:=PrgSetup.ToolbarFontSize;

  UserIconLoader.DialogImage(DI_CopyToClipboard,ImageList,0);
  UserIconLoader.DialogImage(DI_Save,ImageList,1);
  UserIconLoader.DialogImage(DI_Clear,ImageList,2);
  UserIconLoader.DialogImage(DI_BackgroundImage,ImageList,3);
  UserIconLoader.DialogImage(DI_Previous,ImageList,4);
  UserIconLoader.DialogImage(DI_Next,ImageList,5);
  UserIconLoader.DialogImage(DI_Zoom,ImageList,6);
end;

procedure TViewImageForm.LoadImage(const MoveWindow: Boolean);
Var W,H : Integer;
begin
  If IntPicture<>nil then FreeAndNil(IntPicture);
  If IntBitmap100<>nil then FreeAndNil(IntBitmap100);

  PreviousButton.Enabled:=(PrevImages.Count>0);
  NextButton.Enabled:=(NextImages.Count>0);

  If ImageFile='' then IntPicture:=nil else IntPicture:=LoadImageFromFile(ImageFile);
  if IntPicture=nil then begin
    IntPicture:=TPicture.Create;
    IntPicture.Bitmap.Width:=10;
    IntPicture.Bitmap.Height:=10;
  end;
  Image.Picture.Assign(IntPicture);
  Caption:=LanguageSetup.ViewImageForm+' ['+MakeRelPath(ImageFile,PrgSetup.BaseDir)+']';

  W:=Image.Picture.Width; H:=Image.Picture.Height;
  If (H<Screen.Height div 3) and (W<Screen.Width div 3) then begin W:=W*2; H:=H*2; end;
  ClientHeight:=Min(Max(100,H+(ClientHeight-Image.Height)),Screen.WorkAreaHeight-10-(Height-Image.ClientHeight));
  ClientWidth:=Min(Max(640,W),Screen.WorkAreaWidth-10-(Width-Image.ClientWidth));

  If MoveWindow or (Left+Width>=Screen.WorkAreaWidth-10) or (Top+Height>=Screen.WorkAreaHeight-10) then CenterWindow;

  FormResize(self);
  TimerTimer(self);
end;

procedure TViewImageForm.UpdateImageList;
begin
  LoadImage(False);
end;

procedure TViewImageForm.StatusBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var P : TPoint;
begin
  If X>StatusBar.Panels[0].Width+StatusBar.Panels[1].Width then exit;
  P:=StatusBar.ClientToScreen(Point(X,Y));
  ZoomPopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TViewImageForm.Zoom(const ZoomDirection: Integer);
Var I,J : Integer;
    F : Double;
begin
  I:=Round(Image.ClientWidth/IntPicture.Width*100);
  J:=Round(Image.ClientHeight/IntPicture.Height*100);

  I:=Round(Min(I,J)/25)*25;
  If ZoomDirection=0 then I:=100 else begin
    If ZoomDirection<0 then I:=Max(10,I-25) else I:=Max(10,I+25);
  end;

  F:=I/100;
  ClientHeight:=Min(Max(100,Round(F*IntPicture.Height)+(ClientHeight-Image.Height)),Screen.WorkAreaHeight-10);
  ClientWidth:=Min(Max(850,Round(F*IntPicture.Width)),Screen.WorkAreaWidth-10);
  CenterWindow;
end;

procedure TViewImageForm.ZoomPopupMenuPopup(Sender: TObject);
Var I,J,Z,M : Integer;
    S : String;
begin
  I:=Round(Image.ClientWidth/IntPicture.Width*100);
  J:=Round(Image.ClientHeight/IntPicture.Height*100);
  Z:=Min(I,J);

  For I:=0 to ZoomPopupMenu.Items.Count-1 do begin
    ZoomPopupMenu.Items[I].ShortCut:=0;
    S:=RemoveUnderline(ZoomPopupMenu.Items[I].Caption);
    M:=StrToInt(Copy(S,1,length(S)-1));
    ZoomPopupMenu.Items[I].Enabled:=(M<>Z);
    If (M<Z) and (M+25>=Z) then ZoomPopupMenu.Items[I].ShortCut:=ShortCut(VK_OEM_MINUS,[]);
    If (M>Z) and (M-25<=Z) then ZoomPopupMenu.Items[I].ShortCut:=ShortCut(VK_OEM_PLUS,[]);
    If M=100 then ZoomPopupMenu.Items[I].ShortCut:=ShortCut(ord('0'),[]);
  end;
end;

procedure TViewImageForm.ButtonWork(Sender: TObject);
Var WPStype : TWallpaperStyle;
    S : String;
    F : Double;
begin
  Case (Sender as TComponent).Tag of
    1 : Clipboard.Assign(IntPicture);
    2 : begin
          SaveDialog.FileName:='';
          SaveDialog.Title:=LanguageSetup.ViewImageFormSaveTitle;
          SaveDialog.Filter:=LanguageSetup.ViewImageFormSaveFilter;
          if not SaveDialog.Execute then exit;
          SaveImageToFile(ImageFile,SaveDialog.FileName);
        end;
    3 : begin
          if not ExtDeleteFile(ImageFile,ftMediaViewer) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ImageFile]),mtError,[mbOK],0);
            exit;
          end;
          Close;
        end;
    4 : begin
          If not ShowWallpaperStyleDialog(self,WPStype) then exit;
          SetDesktopWallpaper(ImageFile,WPStype);
        end;
    5 : If PrevImages.Count>0 then begin
          NextImages.Insert(0,ImageFile);
          ImageFile:=PrevImages[PrevImages.Count-1];
          PrevImages.Delete(PrevImages.Count-1);
          LoadImage(False);
        end;
    6 : if NextImages.Count>0 then begin
          PrevImages.Add(ImageFile);
          ImageFile:=NextImages[0];
          NextImages.Delete(0);
          LoadImage(False);
        end;
    7 : begin
          If WindowState=wsMaximized then WindowState:=wsNormal;
          S:=RemoveUnderline((Sender as TMenuItem).Caption);
          F:=StrToInt(Copy(S,1,length(S)-1))/100;
          ClientHeight:=Min(Max(100,Round(F*IntPicture.Height)+(ClientHeight-Image.Height)),Screen.WorkAreaHeight-10);
          ClientWidth:=Min(Max(850,Round(F*IntPicture.Width)),Screen.WorkAreaWidth-10);
          CenterWindow;
          TimerTimer(self);
        end;
  end;
end;

procedure TViewImageForm.FormDestroy(Sender: TObject);
begin
  PrevImages.Free;
  NextImages.Free;
  If IntPicture<>nil then FreeAndNil(IntPicture);
  If IntBitmap100<>nil then FreeAndNil(IntBitmap100);
  If NonModal then ViewImageForm:=nil;
end;

procedure TViewImageForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift=[] then Case Key of
    VK_LEFT, VK_UP, VK_PRIOR : ButtonWork(PreviousButton);
    VK_RIGHT, VK_DOWN, VK_NEXT : ButtonWork(NextButton);
    VK_ADD, VK_OEM_PLUS : Zoom(1);
    VK_SUBTRACT, VK_OEM_MINUS  : Zoom(-1);
    ord('0'), VK_MULTIPLY, VK_NUMPAD0 : Zoom(0);
    VK_ESCAPE : Close;
  end;
end;

procedure TViewImageForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  If Shift=[] then begin
    If WheelDelta>0 then ButtonWork(PreviousButton) else ButtonWork(NextButton);
  end else begin
    If WheelDelta>0 then Zoom(-1) else Zoom(1);
  end;
end;

procedure TViewImageForm.TimerTimer(Sender: TObject);
Var D : Double;
    B : TBitmap;
begin
  Timer.Enabled:=False;
  If (IntPicture=nil) or (IntPicture.Width=0) then exit;

  D:=Min(Image.ClientWidth/IntPicture.Width,Image.ClientHeight/IntPicture.Height);

  If (D<1) or (IntBitmap100=nil) then begin
    B:=ScaleImage(IntPicture,D);
    Image.Picture.Bitmap.Assign(B);
    If D=1 then begin
      If IntBitmap100<>nil then FreeAndNil(IntBitmap100);
      IntBitmap100:=B;
    end else begin
      B.Free;
    end;
    exit;
  end;

  If Assigned(IntBitmap100) then
    Image.Picture.Bitmap.Assign(IntBitmap100);
end;

procedure TViewImageForm.FormResize(Sender: TObject);
Var D : Double;
begin
  If IntPicture=nil then exit;

  StatusBar.Panels[0].Text:=IntToStr(IntPicture.Width)+'x'+IntToStr(IntPicture.Height);
  D:=Min(Image.ClientWidth/IntPicture.Width,Image.ClientHeight/IntPicture.Height);
  StatusBar.Panels[1].Text:=IntToStr(Round(D*100))+'%';
  StatusBar.Panels[2].Text:=ImageFile;

  Timer.Enabled:=False;
  Timer.Enabled:=True;
end;

{ global }

Procedure ShowNonModalImageDialog(const AOwner : TComponent; const AImageFile : String; APrevImages, ANextImages : TStringList);
begin
  If AImageFile<>'' then begin
    If OpenMediaFile(PrgSetup.ImageViewer,AImageFile) then exit;
  end;

  If not Assigned(ViewImageForm) then ViewImageForm:=TViewImageForm.Create(AOwner);
  ViewImageForm.ImageFile:=AImageFile;
  If APrevImages<>nil then ViewImageForm.PrevImages.Assign(APrevImages);
  If ANextImages<>nil then ViewImageForm.NextImages.Assign(ANextImages);
  ViewImageForm.NonModal:=True;
  If ViewImageForm.Visible then ViewImageForm.UpdateImageList else ViewImageForm.Show;
end;

Procedure ShowImageDialog(const AOwner : TComponent; const AImageFile : String; const APrevImages, ANextImages : TStringList);
begin
  If OpenMediaFile(PrgSetup.ImageViewer,AImageFile) then exit;
  If Assigned(ViewImageForm) then FreeAndNil(ViewImageForm);

  ViewImageForm:=TViewImageForm.Create(AOwner);
  try
    ViewImageForm.ImageFile:=AImageFile;
    If APrevImages<>nil then ViewImageForm.PrevImages.Assign(APrevImages);
    If ANextImages<>nil then ViewImageForm.NextImages.Assign(ANextImages);
    If (APrevImages=nil) and (ANextImages=nil) then begin
      ViewImageForm.PreviousButton.Visible:=False;
      ViewImageForm.NextButton.Visible:=False;
      ViewImageForm.ToolButton2.Visible:=False;
    end;
    ViewImageForm.ShowModal;
  finally
    FreeAndNil(ViewImageForm);
  end;
end;

end.
