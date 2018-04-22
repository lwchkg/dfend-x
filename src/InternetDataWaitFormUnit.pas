unit InternetDataWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DataReaderBaseUnit, DataReaderMobyUnit;

type
  TInternetDataWaitForm = class(TForm)
    Animate: TAnimate;
    Timer: TTimer;
    InfoLabel: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Thread : TThread;
    ThreadList : TList;
    Constructor Create(AOwner : TComponent); override;
  end;

var
  InternetDataWaitForm: TInternetDataWaitForm;

Function ShowDataReaderInternetConfigWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const AForceUpdate : Boolean; const ACaption, AInfo, AError : String) : Boolean;
Function ShowDataReaderInternetListWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const AName : String; const ACaption, AInfo, AError : String) : Boolean;
Function ShowDataReaderInternetDataWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ANr : Integer; const AFullImages: Boolean; const ACaption, AInfo, AError : String) : TDataReaderGameDataThread;
Procedure ShowDataReaderInternetCoverWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ADownloadURL, ADestFolder : String; const ACaption, AInfo, AError : String); overload;
Procedure ShowDataReaderInternetCoverWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ADownloadURLs : TStringList; const ADestFolder : String; const ACaption, AInfo, AError : String); overload;

Function DomainOnly(const S : String) : String;

implementation

uses ShellAnimations, VistaToolsUnit, CommonTools, LanguageSetupUnit, PrgConsts,
     PrgSetupUnit;

{$R *.dfm}

constructor TInternetDataWaitForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Thread:=nil;
  ThreadList:=nil;
end;

procedure TInternetDataWaitForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
end;

procedure TInternetDataWaitForm.TimerTimer(Sender: TObject);
Var B : Boolean;
    I : Integer;
begin
  If Assigned(Thread) and (WaitForSingleObject(Thread.Handle,0)=WAIT_OBJECT_0) then ModalResult:=mrOK;
  If ThreadList<>nil then begin
    B:=True;
    For I:=0 to ThreadList.Count-1 do If WaitForSingleObject(TThread(ThreadList[I]).Handle,0)<>WAIT_OBJECT_0 then begin B:=False; break; end;
    If B then ModalResult:=mrOK;
  end;
end;

{ global }

Procedure ShowInternetWaitDialog(const AOwner : TComponent; const AThread : TThread; const ACaption, AInfo : String); overload;
begin
  InternetDataWaitForm:=TInternetDataWaitForm.Create(AOwner);
  try
    InternetDataWaitForm.Caption:=ACaption;
    InternetDataWaitForm.InfoLabel.Caption:=AInfo;
    InternetDataWaitForm.Thread:=AThread;
    InternetDataWaitForm.ShowModal;
  finally
    InternetDataWaitForm.Free;
  end;
end;

Procedure ShowInternetWaitDialog(const AOwner : TComponent; const AThread : TList; const ACaption, AInfo : String); overload;
begin
  InternetDataWaitForm:=TInternetDataWaitForm.Create(AOwner);
  try
    InternetDataWaitForm.Caption:=ACaption;
    InternetDataWaitForm.InfoLabel.Caption:=AInfo;
    InternetDataWaitForm.ThreadList:=AThread;
    InternetDataWaitForm.ShowModal;
  finally
    InternetDataWaitForm.Free;
  end;
end;

Function ShowDataReaderInternetWaitDialog(const AOwner : TComponent; const AThread : TDataReaderThread; const ACaption, AInfo, AError : String) : Boolean; overload;
begin
  ShowInternetWaitDialog(AOwner,AThread,ACaption,AInfo);
  result:=AThread.Success;
  If not result then MessageDlg(AError,mtError,[mbOK],0);
end;

Function ShowDataReaderInternetWaitDialog(const AOwner : TComponent; const AThread : TList; const ACaption, AInfo, AError : String) : Boolean; overload;
Var I : Integer;
begin
  ShowInternetWaitDialog(AOwner,AThread,ACaption,AInfo);
  result:=True;
  For I:=0 to AThread.Count-1 do If not TDataReaderThread(AThread[I]).Success then result:=false;
  If not result then MessageDlg(AError,mtError,[mbOK],0);
end;

Function ShowDataReaderInternetConfigWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const AForceUpdate : Boolean; const ACaption, AInfo, AError : String) : Boolean;
Var DataReaderLoadConfigThread : TDataReaderLoadConfigThread;
begin
  DataReaderLoadConfigThread:=TDataReaderLoadConfigThread.Create(ADataReader,AForceUpdate);
  try
    result:=ShowDataReaderInternetWaitDialog(AOwner,DataReaderLoadConfigThread,ACaption,Format(AInfo,[DomainOnly(DataReaderUpdateURL)]),Format(AError,[DomainOnly(DataReaderUpdateURL)]));
  finally
    DataReaderLoadConfigThread.Free;
  end;
end;

Function ShowDataReaderInternetListWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const AName : String; const ACaption, AInfo, AError : String) : Boolean;
Var DataReaderGameListThread : TDataReaderGameListThread;
    URL : String;
begin
  DataReaderGameListThread:=TDataReaderGameListThread.Create(ADataReader,AName);
  try
    URL:=ADataReader.GetListURL(PrgSetup.DataReaderAllPlatforms);
    result:=ShowDataReaderInternetWaitDialog(AOwner,DataReaderGameListThread,ACaption,Format(AInfo,[DomainOnly(URL)]),Format(AError,[DomainOnly(URL)]));
  finally
    DataReaderGameListThread.Free;
  end;
end;

Function ShowDataReaderInternetDataWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ANr : Integer; const AFullImages: Boolean; const ACaption, AInfo, AError : String) : TDataReaderGameDataThread;
begin
  result:=TDataReaderGameDataThread.Create(ADataReader,ANr,AFullImages);
  If not ShowDataReaderInternetWaitDialog(AOwner,result,ACaption,Format(AInfo,[ADataReader.DataDomain]),Format(AError,[ADataReader.DataDomain])) then FreeAndNil(result);
end;

Procedure ShowDataReaderInternetCoverWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ADownloadURL, ADestFolder : String; const ACaption, AInfo, AError : String);
Var DataReaderGameCoverThread : TDataReaderGameCoverThread;
begin
  DataReaderGameCoverThread:=TDataReaderGameCoverThread.Create(ADataReader,ADownloadURL,ADestFolder);
  try
    ShowDataReaderInternetWaitDialog(AOwner,DataReaderGameCoverThread,ACaption,Format(AInfo,[ADataReader.DataDomain]),Format(AError,[ADataReader.DataDomain]));
  finally
    DataReaderGameCoverThread.Free;
  end;
end;

Procedure ShowDataReaderInternetCoverWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ADownloadURLs : TStringList; const ADestFolder : String; const ACaption, AInfo, AError : String); overload;
const ThreadCount=8;
Var DataReaderGameCoverThread : Array[0..ThreadCount-1] of TDataReaderGameCoverThread;
    URLList : Array[0..ThreadCount-1] of TStringList;
    ThreadList : TList;
    I : Integer;
begin
  For I:=0 to ThreadCount-1 do begin URLList[I]:=TStringList.Create; DataReaderGameCoverThread[I]:=nil; end;
  try
    For I:=0 to ADownloadURLs.Count-1 do URLList[I mod ThreadCount].Add(ADownloadURLs[I]);
    For I:=0 to ThreadCount-1 do if URLList[I].Count>0 then DataReaderGameCoverThread[I]:=TDataReaderGameCoverThread.Create(ADataReader,URLList[I],ADestFolder);
    try
      ThreadList:=TList.Create;
      try
        For I:=0 to ThreadCount-1 do if DataReaderGameCoverThread[I]<>nil then ThreadList.Add(DataReaderGameCoverThread[I]);
        ShowDataReaderInternetWaitDialog(AOwner,ThreadLIst,ACaption,Format(AInfo,[ADataReader.DataDomain]),Format(AError,[ADataReader.DataDomain]));
      finally
        ThreadList.Free;
      end;
    finally
      For I:=0 to ThreadCount-1 do if DataReaderGameCoverThread[I]<>nil then DataReaderGameCoverThread[I].Free;
    end;
  finally
    For I:=0 to ThreadCount-1 do URLList[I].Free;
  end;
end;

Function DomainOnly(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  I:=Pos(':/'+'/',result); If I>0 then result:=Copy(result,I+3,MaxInt);
  I:=Pos('/',result); If I>0 then result:=Copy(result,1,I-1);
end;

end.
