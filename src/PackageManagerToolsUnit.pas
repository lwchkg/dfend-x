unit PackageManagerToolsUnit;
interface

uses Windows, Classes, Menus, ComCtrls, PackageDBUnit, ChecksumScanner,
     PackageDBCacheUnit, GameDBUnit;

{Games and AutoSetups TListView}

Function GetPackageManagerToolTip(const DownloadData : TDownloadData) : String;

Type TFilterKey=(fkNoFilter,fkName,fkLicense,fkGenre,fkDeveloper,fkPublisher,fkYear,fkLanguage);

Type TFilter=record
  Key : TFilterKey;
  UpperValue : String;
end;

Procedure InitPackageManagerListView(const AListView : TListView; const AutoSetups : Boolean);
Procedure InitPackageManagerIconsListView(const AListView : TListView);
Procedure InitPackageManagerIconSetsListView(const AListView : TListView);
Procedure InitPackageManagerLanguagessListView(const AListView : TListView);
Procedure LoadListView(const AListView : TListView; const PackageDB : TPackageDB; const Filter : TFilter; const AutoSetupChecksumScanner : TChecksumScanner; const AutoSetups : Boolean; const GameDB, AutoSetupDB : TGameDB; const HideIfAlreadyInstalled : Boolean);
Procedure LoadIconsListView(const AListView : TListView; const PackageDB : TPackageDB; const IconChecksumScanner : TChecksumScanner; const HideIfAlreadyInstalled : Boolean);
Procedure LoadIconSetsListView(const AListView : TListView; const PackageDB : TPackageDB; HideIfAlreadyInstalled : Boolean);
Procedure LoadLanguagesListView(const AListView : TListView; const PackageDB : TPackageDB; HideIfAlreadyInstalled : Boolean; const LanguageChecksumScanner1, LanguageChecksumScanner2 : TChecksumScanner);

Var FilterSelectLicense : TStringList = nil;
    FilterSelectGenre : TStringList = nil;
    FilterSelectDeveloper : TStringList = nil;
    FilterSelectPublisher : TStringList = nil;
    FilterSelectYear : TStringList = nil;
    FilterSelectLanguage : TStringList = nil;

procedure OpenFilterPopup(const OpenPos : TPoint; const AutoSetups : Boolean; const PopupMenu : TPopupMenu; const PackageDB : TPackageDB; const OnClick : TNotifyEvent; const HideIfAlreadyInstalled : Boolean; const AutoSetupChecksumScanner : TChecksumScanner; const GameDB : TGameDB);

Procedure SortListView(const AListView : TListView; const ColNr : Integer; const Reverse, IsSize : Boolean);

{ExePackages info memo}

Function ExePackageInfo(const AObject : TObject; const PackageDBCache : TPackageDBCache) : TStringList;

implementation

uses SysUtils, IniFiles, PackageDBToolsUnit, CommonTools, LanguageSetupUnit,
     PrgSetupUnit, PrgConsts;

Function GetPackageManagerToolTip2(const DownloadAutoSetupData : TDownloadAutoSetupData) : String;
begin
  {Had to split this otherwise the compiler says "the return value is may not defined"}
  result:='';
  result:=result+#13+LanguageSetup.GameGenre+': '+GetCustomGenreName(DownloadAutoSetupData.Genre)
    +#13+LanguageSetup.GameDeveloper+': '+DownloadAutoSetupData.Developer
    +#13+LanguageSetup.GamePublisher+': '+DownloadAutoSetupData.Publisher
    +#13+LanguageSetup.GameYear+': '+DownloadAutoSetupData.Year
    +#13+LanguageSetup.GameLanguage+': '+GetCustomLanguageName(DownloadAutoSetupData.Language)
    +#13+LanguageSetup.PackageManagerDownloadSize+': '+GetNiceFileSize(DownloadAutoSetupData.Size);
end;

Function GetPackageManagerToolTip3(const DownloadLanguageData : TDownloadLanguageData) : String;
begin
  result:=
    DownloadLanguageData.Name+#13+
    LanguageSetup.PackageManagerListDescription+': '+DownloadLanguageData.Description+#13+
    LanguageSetup.PackageManagerListAuthor+': '+DownloadLanguageData.Author+#13+
    LanguageSetup.PackageManagerDownloadSize+': '+GetNiceFileSize(DownloadLanguageData.Size);
end;

Function GetPackageManagerToolTip(const DownloadData : TDownloadData) : String;
Var DownloadAutoSetupData : TDownloadAutoSetupData;
begin
  result:='';

  If DownloadData is TDownloadAutoSetupData then begin
    DownloadAutoSetupData:=DownloadData as TDownloadAutoSetupData;
    result:=DownloadAutoSetupData.Name;
    If DownloadAutoSetupData is TDownloadZipData then result:=result+#13+LanguageSetup.PackageManagerListLicense+': '+TDownloadZipData(DownloadAutoSetupData).License;
    result:=result+GetPackageManagerToolTip2(DownloadAutoSetupData);
    If Trim(DownloadAutoSetupData.PackageList.ProviderText)<>'' then begin
      result:=result+#13#13+Format(LanguageSetup.PackageManagerProviderProfileString,[DownloadAutoSetupData.PackageList.ProviderName]);
    end;
  end;

  If DownloadData is TDownloadLanguageData then begin
    result:=GetPackageManagerToolTip3(DownloadData as TDownloadLanguageData);
  end;
end;

Procedure InitPackageManagerListView(const AListView : TListView; const AutoSetups : Boolean);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  if not AutoSetups then begin C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.PackageManagerListLicense; end;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameGenre;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.PackageManagerDownloadSize;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameDeveloper;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GamePublisher;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameYear;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameLanguage;
end;

Procedure InitPackageManagerIconsListView(const AListView : TListView);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.PackageManagerDownloadSize;
end;

Procedure InitPackageManagerIconSetsListView(const AListView : TListView);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.PackageManagerDownloadSize;
end;

Procedure InitPackageManagerLanguagessListView(const AListView : TListView);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.PackageManagerListDescription;
end;

Function GameAlreadyInstalled(const Data : TDownloadAutoSetupData; const GameDB : TGameDB) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=True;
  S:=ExtUpperCase(Data.Name);
  For I:=0 to GameDB.Count-1 do If ExtUpperCase(GameDB[I].CacheName)=S then begin
    If (Data.GameExeChecksum<>'') and (GameDB[I].GameExeMD5<>'') then begin
      If Data.GameExeChecksum=GameDB[I].GameExeMD5 then exit;
    end else begin
      exit;
    end;
  end;
  result:=False;
end;

Function SpecialCheck(const Data : TDownloadAutoSetupData) : Boolean;
Function GetLocalInfo(const Info: Cardinal):string; Var I : integer; begin I:=GetLocaleInfo(LOCALE_USER_DEFAULT,Info,nil,0); SetLength(result,I); GetLocaleinfo(LOCALE_USER_DEFAULT,Info,PChar(result),I); end; const Filter='DEUTSCH';
Var S,T : String;
begin
  result:=False; S:=ExtUpperCase(Data.URL); If (Copy(S,1,7)<>'HTTP:/'+'/') and (Copy(S,1,8)<>'HTTPS:/'+'/') and (Copy(S,1,6)<>'FTP:/'+'/') then exit; S:=ExtUpperCase(GetLocalInfo(LOCALE_SLANGUAGE)); T:=ExtUpperCase(LanguageSetup.LocalLanguageName); If (Pos(Filter,S)=0) and (Pos(Filter,T)=0) then exit; result:=True; S:=ExtUpperCase(Data.Genre); T:=ExtUpperCase(Data.Name); If (Pos('FIRST PERSON',S)<>0) or (Pos('DOOM',T)<>0) or (Pos('DUKE NUKE',T)<>0) or (Pos('QUAKE',T)<>0) or (Pos('WOLFENSTEIN',T)<>0) then exit; result:=False;
end;

Procedure LoadListView(const AListView : TListView; const PackageDB : TPackageDB; const Filter : TFilter; const AutoSetupChecksumScanner : TChecksumScanner; const AutoSetups : Boolean; const GameDB, AutoSetupDB : TGameDB; const HideIfAlreadyInstalled : Boolean);
Var I,J,K : Integer;
    St : TStringList;
    Item : TListItem;
    Data : TDownloadAutoSetupData;
    S : String;
    Selected : TStringList;
    Ver : Integer;
begin
  Ver:=VersionToInt(GetNormalFileVersionAsString);
  Selected:=TStringList.Create;
  try
    Selected.Capacity:=AListView.Items.Count;
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      AListView.Columns.BeginUpdate;
      try
        For I:=0 to AListView.Columns.Count-1 do AListView.Column[I].Width:=1;
      finally
        AListView.Columns.EndUpdate;
      end;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do begin
          If AutoSetups then K:=PackageDB[I].AutoSetupCount else K:=PackageDB[I].GamesCount;
          For J:=0 to K-1 do begin
            If AutoSetups then Data:=PackageDB[I].AutoSetup[J] else begin Data:=PackageDB[I].Game[J]; if SpecialCheck(Data) then continue; end;
            {Already installed ?}
            If HideIfAlreadyInstalled then begin
              If AutoSetups then begin
                If AutoSetupChecksumScanner.GetChecksum(ExtractFileNameFromURL(Data.URL,'.prof',True))=Data.PackageChecksum then continue;
                If GameAlreadyInstalled(Data,AutoSetupDB) then continue;
                If Trim(Data.MaxVersion)<>'' then begin
                  If VersionToInt(Data.MaxVersion)<Ver then continue;
                end;
              end else begin
                If GameAlreadyInstalled(Data,GameDB) then continue;
              end;
            end;
            {Filter}
            Case Filter.Key of
              fkName : S:=Data.Name;
              fkLicense : S:=TDownloadZipData(Data).License;
              fkGenre : S:=Data.Genre;
              fkPublisher : S:=Data.Publisher;
              fkDeveloper : S:=Data.Developer;
              fkYear : S:=Data.Year;
              fkLanguage : S:=Data.Language;
              else S:='';
            End;
            If (Filter.Key<>fkNoFilter) and (S<>'') and (Pos(Filter.UpperValue,ExtUpperCase(S))=0) then continue;
            {Add to string list}
            If AutoSetups
              then St.AddObject(PackageDB[I].AutoSetup[J].Name,TObject(I*65536+J))
              else St.AddObject(PackageDB[I].Game[J].Name,TObject(I*65536+J));
          end;
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;

          Item.SubItems.BeginUpdate;
          try
            If AutoSetups then begin
              Data:=PackageDB[J].AutoSetup[K];
            end else begin
              Data:=PackageDB[J].Game[K];
              Item.SubItems.Add(PackageDB[J].Game[K].License);
            end;

            with Item.SubItems do begin
              Add(GetCustomGenreName(Data.Genre));
              Add(GetNiceFileSize(Data.Size));
              Add(Data.Developer);
              Add(Data.Publisher);
              Add(Data.Year);
              Add(GetCustomLanguageName(Data.Language));
            end;
          finally
            Item.SubItems.EndUpdate;
          end;

          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;
    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  AListView.Columns.BeginUpdate;
  try
    For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
      AListView.Column[I].Width:=-2;
      AListView.Column[I].Width:=-1;
    end else begin
      AListView.Column[I].Width:=-2;
    end;
  finally
    AListView.Columns.EndUpdate;
  end;

  AListView.Invalidate;
end;

Procedure LoadIconsListView(const AListView : TListView; const PackageDB : TPackageDB; const IconChecksumScanner : TChecksumScanner; const HideIfAlreadyInstalled : Boolean);
Var I,J,K : Integer;
    Selected,St : TStringList;
    Item : TListItem;
    Data : TDownloadIconData;
begin
  Selected:=TStringList.Create;
  try
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB[I].IconCount-1 do begin
          Data:=PackageDB[I].Icon[J];
          {Already installed ?}
          If HideIfAlreadyInstalled then begin
            If IconChecksumScanner.GetChecksum(ExtractFileNameFromURL(Data.URL,'.ico',True))=Data.PackageChecksum then continue;
          end;
          {Add to string list}
          St.AddObject(Data.Name,TObject(I*65536+J))
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;
          Data:=PackageDB[J].Icon[K];
          Item.SubItems.Add(GetNiceFileSize(Data.Size));
          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;

    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
    AListView.Column[I].Width:=-2;
    AListView.Column[I].Width:=-1;
  end else begin
    AListView.Column[I].Width:=-2;
  end;
end;

Function IconSetAlreadyInstalled(const Name, MinVersion, MaxVersion : String) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
    Ini : TIniFile;
    S1,S2,S3 : String;
begin
  result:=False;

  S1:=Trim(ExtUpperCase(Name));
  S2:=Trim(ExtUpperCase(MinVersion));
  S3:=Trim(ExtUpperCase(MaxVersion));

  I:=FindFirst(PrgDataDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        Ini:=TIniFile.Create(PrgDataDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile);
        try
          If (S1=Trim(ExtUpperCase(Ini.ReadString('Information','Name','')))) and (S2=Trim(ExtUpperCase(Ini.ReadString('Information','MinVersion','')))) and (S3=Trim(ExtUpperCase(Ini.ReadString('Information','MaxVersion','')))) then begin
            result:=True; exit;
          end;
        finally
          Ini.Free;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If PrgDir=PrgDataDir then exit;

  I:=FindFirst(PrgDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        Ini:=TIniFile.Create(PrgDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile);
        try
          If (S1=Trim(ExtUpperCase(Ini.ReadString('Information','Name','')))) and (S2=Trim(ExtUpperCase(Ini.ReadString('Information','MinVersion','')))) and (S3=Trim(ExtUpperCase(Ini.ReadString('Information','MaxVersion','')))) then begin
            result:=True; exit;
          end;
        finally
          Ini.Free;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure LoadIconSetsListView(const AListView : TListView; const PackageDB : TPackageDB; HideIfAlreadyInstalled : Boolean);
Var I,J,K : Integer;
    Selected : TStringList;
    St : TStringList;
    Data : TDownloadIconSetData;
    Item : TListItem;
begin
  Selected:=TStringList.Create;
  try
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB[I].IconSetCount-1 do begin
          Data:=PackageDB[I].IconSet[J];
          If (VersionToInt(Data.MinVersion)>VersionToInt(GetNormalFileVersionAsString)) or (VersionToInt(Data.MaxVersion)<VersionToInt(GetNormalFileVersionAsString)) then continue;
          {Already installed ?}
          If HideIfAlreadyInstalled then begin
            If IconSetAlreadyInstalled(Data.Name,Data.MinVersion,Data.MaxVersion) then continue;
          end;
          {Add to string list}
          St.AddObject(Data.Name,TObject(I*65536+J));
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;
          Data:=PackageDB[J].IconSet[K];
          Item.SubItems.Add(GetNiceFileSize(Data.Size));
          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;

    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
    AListView.Column[I].Width:=-2;
    AListView.Column[I].Width:=-1;
  end else begin
    AListView.Column[I].Width:=-2;
  end;
end;

Procedure LoadLanguagesListView(const AListView : TListView; const PackageDB : TPackageDB; HideIfAlreadyInstalled : Boolean; const LanguageChecksumScanner1, LanguageChecksumScanner2 : TChecksumScanner);
Var I,J,K : Integer;
    Selected : TStringList;
    St : TStringList;
    Data : TDownloadLanguageData;
    Item : TListItem;
begin
  Selected:=TStringList.Create;
  try
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB[I].LanguageCount-1 do begin
          Data:=PackageDB[I].Language[J];
          If (VersionToInt(Data.MinVersion)>VersionToInt(GetNormalFileVersionAsString)) or (VersionToInt(Data.MaxVersion)<VersionToInt(GetNormalFileVersionAsString)) then continue;
          If HideIfAlreadyInstalled then begin
            if LanguageChecksumScanner1.GetChecksum(ExtractFileNameFromURL(Data.URL,'.ini',True))=Data.PackageChecksum then continue;
            if (LanguageChecksumScanner2<>nil) and (LanguageChecksumScanner2.GetChecksum(ExtractFileNameFromURL(Data.URL,'.ini',True))=Data.PackageChecksum) then continue;
          end;
          {Add to string list}
          St.AddObject(Data.Name,TObject(I*65536+J));
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;
          Data:=PackageDB[J].Language[K];
          Item.SubItems.Add(Data.Description);
          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;

    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
    AListView.Column[I].Width:=-2;
    AListView.Column[I].Width:=-1;
  end else begin
    AListView.Column[I].Width:=-2;
  end;
end;

Procedure AddSubMenuItems(const PopupMenu : TPopupMenu; const Parent : TMenuItem; const St : TStringList; const OnClick : TNotifyEvent; const UseObjectAsTag : Boolean = False);
Var M : TMenuItem;
    I : Integer;
begin
  For I:=0 to St.Count-1 do begin
    M:=TMenuItem.Create(PopupMenu);
    Parent.Add(M);
    If UseObjectAsTag then M.Tag:=Integer(St.Objects[I]) else M.Tag:=I;
    M.OnClick:=OnClick;
    M.Caption:=St[I];
  end;
end;

Procedure CheckAndAdd(const S : String; const ListUpper, List : TStringList);
Var I : Integer;
    T,U : String;
begin
  T:=S;
  I:=Pos(';',T);
  While T<>'' do begin
    If I>0 then begin
      U:=Trim(Copy(T,1,I-1)); T:=Trim(Copy(T,I+1,MaxInt));
    end else begin
      U:=T; T:='';
    end;
    I:=Pos(';',T);
    If ListUpper.IndexOf(ExtUpperCase(U))<0 then begin List.Add(U); ListUpper.Add(ExtUpperCase(U)); end;
  end;
end;

procedure OpenFilterPopup(const OpenPos : TPoint; const AutoSetups : Boolean; const PopupMenu : TPopupMenu; const PackageDB : TPackageDB; const OnClick : TNotifyEvent; const HideIfAlreadyInstalled : Boolean; const AutoSetupChecksumScanner : TChecksumScanner; const GameDB : TGameDB);
Var I,J,K : Integer;
    FilterSelectLicenseUpper, FilterSelectGenreUpper, FilterSelectDeveloperUpper, FilterSelectPublisherUpper, FilterSelectYearUpper, FilterSelectLanguageUpper : TStringList;
    FilterSelectGenreTranslated, FilterSelectLanguageTranslated : TStringList;
    Data : TDownloadAutoSetupData;
    M : TMenuItem;
begin
  PopupMenu.Items.Clear;

  If Assigned(FilterSelectLicense) then FilterSelectLicense.Clear else FilterSelectLicense:=TStringList.Create;
  If Assigned(FilterSelectGenre) then FilterSelectGenre.Clear else FilterSelectGenre:=TStringList.Create;
  If Assigned(FilterSelectDeveloper) then FilterSelectDeveloper.Clear else FilterSelectDeveloper:=TStringList.Create;
  If Assigned(FilterSelectPublisher) then FilterSelectPublisher.Clear else FilterSelectPublisher:=TStringList.Create;
  If Assigned(FilterSelectYear) then FilterSelectYear.Clear else FilterSelectYear:=TStringList.Create;
  If Assigned(FilterSelectLanguage) then FilterSelectLanguage.Clear else FilterSelectLanguage:=TStringList.Create;

  FilterSelectLicenseUpper:=TStringList.Create;
  FilterSelectGenreUpper:=TStringList.Create;
  FilterSelectDeveloperUpper:=TStringList.Create;
  FilterSelectPublisherUpper:=TStringList.Create;
  FilterSelectYearUpper:=TStringList.Create;
  FilterSelectLanguageUpper:=TStringList.Create;
  try
    For I:=0 to PackageDB.Count-1 do begin
      If AutoSetups then K:=PackageDB[I].AutoSetupCount else K:=PackageDB[I].GamesCount;
      For J:=0 to K-1 do begin
        If AutoSetups then Data:=PackageDB[I].AutoSetup[J] else Data:=PackageDB[I].Game[J];
        {Only add records to filter list that are available in unfiltered list}
        If HideIfAlreadyInstalled then begin
          If AutoSetups then begin
            If AutoSetupChecksumScanner.GetChecksum(ExtractFileNameFromURL(Data.URL,'.prof',True))=Data.PackageChecksum then continue;
          end;
          If GameAlreadyInstalled(Data,GameDB) then continue;
        end;
        If not AutoSetups then CheckAndAdd(TDownloadZipData(Data).License,FilterSelectLicenseUpper,FilterSelectLicense);
        CheckAndAdd(Data.Genre,FilterSelectGenreUpper,FilterSelectGenre);
        CheckAndAdd(Data.Developer,FilterSelectDeveloperUpper,FilterSelectDeveloper);
        CheckAndAdd(Data.Publisher,FilterSelectPublisherUpper,FilterSelectPublisher);
        CheckAndAdd(Data.Year,FilterSelectYearUpper,FilterSelectYear);
        CheckAndAdd(Data.Language,FilterSelectLanguageUpper,FilterSelectLanguage);
      end;
    end;

    FilterSelectGenreTranslated:=TStringList.Create;
    FilterSelectLanguageTranslated:=TStringList.Create;
    try

      For I:=0 to FilterSelectGenre.Count-1 do FilterSelectGenreTranslated.Add(GetCustomGenreName(FilterSelectGenre[I]));
      For I:=0 to FilterSelectLanguage.Count-1 do FilterSelectLanguageTranslated.Add(GetCustomLanguageName(FilterSelectLanguage[I]));

      If AutoSetups then PopupMenu.Tag:=1 else PopupMenu.Tag:=0;

      M:=TMenuItem.Create(PopupMenu);
      PopupMenu.Items.Add(M);
      M.Caption:=LanguageSetup.PackageManagerNoFilter;
      M.Tag:=-1;
      M.OnClick:=OnClick;

      M:=TMenuItem.Create(PopupMenu);
      PopupMenu.Items.Add(M);
      M.Caption:='-';

      If (not AutoSetups) and (FilterSelectLicense.Count>1) then begin
        FilterSelectLicense.Sort;
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=1;
        M.Caption:=LanguageSetup.PackageManagerListLicense;
        AddSubMenuItems(PopupMenu,M,FilterSelectLicense,OnClick);
      end;

      If FilterSelectGenre.Count>1 then begin
        For I:=0 to FilterSelectGenreTranslated.Count-1 do FilterSelectGenreTranslated.Objects[I]:=TObject(I);
        FilterSelectGenreTranslated.Sort;
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=2;
        M.Caption:=LanguageSetup.GameGenre;
        AddSubMenuItems(PopupMenu,M,FilterSelectGenreTranslated,OnClick,True);
      end;

      If FilterSelectDeveloper.Count>1 then begin
        FilterSelectDeveloper.Sort;
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=3;
        M.Caption:=LanguageSetup.GameDeveloper;
        AddSubMenuItems(PopupMenu,M,FilterSelectDeveloper,OnClick);
      end;

      If FilterSelectPublisher.Count>1 then begin
        FilterSelectPublisher.Sort;
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=4;
        M.Caption:=LanguageSetup.GamePublisher;
        AddSubMenuItems(PopupMenu,M,FilterSelectPublisher,OnClick);
      end;

      If FilterSelectYear.Count>1 then begin
        FilterSelectYear.Sort;
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=5;
        M.Caption:=LanguageSetup.GameYear;
        AddSubMenuItems(PopupMenu,M,FilterSelectYear,OnClick);
      end;

      If FilterSelectLanguage.Count>1 then begin
        For I:=0 to FilterSelectLanguageTranslated.Count-1 do FilterSelectLanguageTranslated.Objects[I]:=TObject(I);
        FilterSelectLanguageTranslated.Sort;
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=6;
        M.Caption:=LanguageSetup.GameLanguage;
        AddSubMenuItems(PopupMenu,M,FilterSelectLanguageTranslated,OnClick,True);
      end;
    finally
      FilterSelectGenreTranslated.Free;
      FilterSelectLanguageTranslated.Free;
    end;
  finally
    FilterSelectLicenseUpper.Free;
    FilterSelectGenreUpper.Free;
    FilterSelectDeveloperUpper.Free;
    FilterSelectPublisherUpper.Free;
    FilterSelectYearUpper.Free;
    FilterSelectLanguageUpper.Free;
  end;

  PopupMenu.Popup(OpenPos.X+5,OpenPos.Y+5);
end;

Function ExePackageInfo(const AObject : TObject; const PackageDBCache : TPackageDBCache) : TStringList;
Var DownloadExeData : TDownloadExeData;
    CachedPackage : TCachedPackage;
    S : String;
begin
  result:=TStringList.Create;

  If AObject is TDownloadExeData then begin
    DownloadExeData:=TDownloadExeData(AObject);
    result.Text:=ReplaceBRs(DownloadExeData.Description);
    result.Add('');
    result.Add(LanguageSetup.PackageManagerDownloadSize+': '+GetNiceFileSize(DownloadExeData.Size));
    S:=PackageDBCache.FindChecksum(DownloadExeData.Name);
    If S<>'' then begin
      result.Add('');
      If S=DownloadExeData.PackageChecksum then begin
        result.Add(LanguageSetup.PackageManagerPackageAlreadyDownloaded);
      end else begin
        result.Add(LanguageSetup.PackageManagerOldPackageAlreadyDownloaded);
      end;
    end;
  end else begin
    CachedPackage:=TCachedPackage(AObject);
    result.Text:=ReplaceBRs(CachedPackage.Description);
    result.Add('');
    result.Add(LanguageSetup.PackageManagerDownloadSize+': '+GetNiceFileSize(CachedPackage.Size));
    result.Add('');
    result.Add(LanguageSetup.PackageManagerPackageOnlyInCache);
  end;
end;

Type TListRec=record
  Checked : Boolean;
  Selected : Boolean;
  Cols : Array of String;
  Data : Pointer;
end;

Procedure SortListView(const AListView : TListView; const ColNr : Integer; const Reverse, IsSize : Boolean);
Var St : TStringList;
    Data : Array of TListRec;
    I,J,Nr,NewSelIndex : Integer;
    Item : TListItem;
    B,Rebuild : Boolean;
    S,T : String;
begin
  {Save list}
  SetLength(Data,AListView.Items.Count);
  for I:=0 to AListView.Items.Count-1 do begin
    Data[I].Checked:=AListView.Items[I].Checked;
    Data[I].Selected:=False;
    SetLength(Data[I].Cols,AListView.Items[I].SubItems.Count+1);
    Data[I].Cols[0]:=AListView.Items[I].Caption;
    for J:=1 to length(Data[I].Cols)-1 do Data[I].Cols[J]:=AListView.Items[I].SubItems[J-1];
    Data[I].Data:=AListView.Items[I].Data;
  end;
  If AListView.ItemIndex>=0 then Data[AListView.ItemIndex].Selected:=True;

  St:=TStringList.Create;
  try
    {Build list to sort}
    for I:=0 to length(Data)-1 do begin
      S:=Data[I].Cols[ColNr];
      if IsSize then begin
        T:=Copy(S,length(S)-1,MaxInt);
        If TryStrToInt(Trim(Copy(S,1,length(S)-2)),J) then begin
          if T='KB' then J:=J*1024;
          if T='MB' then J:=J*1024*1024;
          if T='GB' then J:=J*1024*1024*1024;
        end;
        S:=IntToStr(J);
        while length(S)<10 do S:='0'+S;
      end;
      St.AddObject(S,TObject(I));
    end;

    {Sort}
    St.Sort;

    {Rebuild needed?}
    B:=False;
    if Reverse then begin
      for I:=0 to St.Count-1 do if Integer(St.Objects[I])<>(St.Count-1)-I then begin B:=True; break; end;
    end else begin
      for I:=0 to St.Count-1 do if Integer(St.Objects[I])<>I then begin B:=True; break; end;
    end;
    if not B then exit;

    {Create new list}
    NewSelIndex:=-1;
    AListView.Items.BeginUpdate;
    try
      AListView.Columns.BeginUpdate;
      try
        For I:=0 to AListView.Columns.Count-1 do AListView.Column[I].Width:=1;
      finally
        AListView.Columns.EndUpdate;
      end;

      Rebuild:=AListView.Items.Count=St.Count;
      if not Rebuild then AListView.Items.Clear;
      for I:=0 to St.Count-1 do begin
        if Reverse then  Nr:=Integer(St.Objects[(St.Count-1)-I]) else Nr:=Integer(St.Objects[I]);
        if Rebuild then begin
          Item:=AListView.Items[I];
          Item.Checked:=Data[Nr].Checked;
          Item.Caption:=Data[Nr].Cols[0];
          for J:=1 to length(Data[Nr].Cols)-1 do Item.SubItems[J-1]:=Data[Nr].Cols[J];
        end else begin
          Item:=AListView.Items.Add;
          Item.Checked:=Data[Nr].Checked;
          Item.Caption:=Data[Nr].Cols[0];
          for J:=1 to length(Data[Nr].Cols)-1 do Item.SubItems.Add(Data[Nr].Cols[J]);
        end;
        if Data[Nr].Selected then NewSelIndex:=I;
      end;
    finally
      AListView.Items.EndUpdate;

      AListView.Columns.BeginUpdate;
      try
        For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
          AListView.Column[I].Width:=-2;
          AListView.Column[I].Width:=-1;
        end else begin
          AListView.Column[I].Width:=-2;
        end;
      finally
        AListView.Columns.EndUpdate;
      end;
      AListView.Invalidate;
    end;
    if NewSelIndex>=0 then AListView.ItemIndex:=NewSelIndex;
  finally
    St.Free;
  end;
end;

initialization
finalization
  If Assigned(FilterSelectLicense) then FilterSelectLicense.Free;
  If Assigned(FilterSelectGenre) then FilterSelectGenre.Free;
  If Assigned(FilterSelectDeveloper) then FilterSelectDeveloper.Free;
  If Assigned(FilterSelectPublisher) then FilterSelectPublisher.Free;
  If Assigned(FilterSelectYear) then FilterSelectYear.Free;
  If Assigned(FilterSelectLanguage) then FilterSelectLanguage.Free;
end.
