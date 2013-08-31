unit fb2rb_engine;

interface
uses MSXML2_TLB,Classes,hyph_control,fb2_hyph_TLB,extractimages;
Type
  TCallBackProc=procedure(message:string;percent:Integer) of object;
  TFB2RBConverterSettings=record
    SKipDescr,SkipImages,SkipCOver,TransLitTitle,SHortenTOCLines:Boolean;
    TOCLevel,PageBreakLeve:Integer;
    Target:Integer;
    FileName:String;
    ProgressProc:TCallBackProc;
    DOM,XSL:IXMLDOMDocument2;
    HyphControler:IFB2Hyphenator;
    RBMakePath:String;
    EXELines:TStrings;
    HParent:THandle;
  end;
  TRebData=record
    RebInstalled,RebConnected,SMPresent:Boolean;
    SMFree,IntFree:Integer;
    RebHandle:THandle;
    HOwner:THandle;
  end;

  Function TransFormToReb(Params:TFB2RBConverterSettings):Boolean;
  Procedure OpenREB(var RebData:TRebData);
  Procedure CloseReb(var RebData:TRebData);

Const
  storeOnRebInt=1;
  StoreOnRebSM=2;
  SaveToFile=0;
implementation
uses ShellAPI,Windows,SysUtils,Variants,exec_external,SetupApi;
Function UuidCreate(var GUID:TGUID):HResult;stdcall; external 'RPCRT4.DLL';
Const
  GUID_REB1100:TGUID ='{3bb1df43-b2d4-11d3-bf85-00105a0a47b3}';
  IOCTL_RocketWriteContinue     = $222024;
  IOCTL_RocketReadInitiate      = $222018;
  IOCTL_RocketWriteInitiate     = $222020;
  REB_BLOCK_SZ=4096;

Procedure OpenREB;
Const
  Operation='__STATUS'#0;
Var
  HReb:HDEVINFO;
  InterFaceData:TSPDeviceInterfaceData;
  Len:Cardinal;
  PIdDD:PSPDeviceInterfaceDetailData;
  DevicePath:String;
  internalBuffer:array [1..REB_BLOCK_SZ * 16] of AnsiChar;
  BytesRead:Cardinal;
  SettingsStrings:TStringList;
  Function ValToInt(S:String):Integer;
  Begin
    Result:=StrToInt(Copy(S,2,Length(S)-2));
  end;
Begin
  RebData.RebInstalled:=False;
  RebData.RebConnected:=False;
  RebData.RebHandle:=INVALID_HANDLE_VALUE;
  HReb:=SetupDiGetClassDevs(@GUID_REB1100,Nil,RebData.HOwner,DIGCF_PRESENT or DIGCF_INTERFACEDEVICE);
  if (HReb = Nil) then
    Exit;
  RebData.RebInstalled:=True;
  InterFaceData.cbSize:=SizeOf(InterFaceData);
  if not SetupDiEnumDeviceInterfaces(HReb,Nil,GUID_REB1100,0,InterFaceData) then
    Exit;
  SetupDiGetInterfaceDeviceDetail(HReb, @InterFaceData, Nil, 0, @Len, Nil);
  PIdDD:=AllocMem(Len);
  PIdDD^.cbSize:=SizeOf(TSPDeviceInterfaceDetailData);
  if not SetupDiGetInterfaceDeviceDetail(HReb, @InterFaceData, PIdDD, Len, @Len, Nil) then
  Begin
    RebData.RebConnected:=False;
    RaiseLastOSError;
  end;
  DevicePath:=PChar(@PIdDD.DevicePath);
  FreeMem(PIdDD,Len);
  RebData.RebHandle:=CreateFile(PChar(DevicePath),GENERIC_READ or GENERIC_WRITE,
                        FILE_SHARE_READ or FILE_SHARE_WRITE,
                        Nil,OPEN_EXISTING, 0,0);
  if RebData.RebHandle=INVALID_HANDLE_VALUE then
  Begin
    RebData.RebConnected:=False;
    RaiseLastOSError;
  end;

  if DeviceIoControl(RebData.RebHandle, IOCTL_RocketReadInitiate,
   PChar(Operation), Length(Operation),
   @internalBuffer,SizeOf(internalBuffer), BytesRead, Nil) then
  Begin
    internalBuffer[BytesRead+1]:=#0;
    SettingsStrings:=TStringList.Create;
    SettingsStrings.Text:=PChar(@internalBuffer[1]);
    RebData.SMPresent:=SettingsStrings.Values['SM_PRESENT']='"Yes"';
    RebData.IntFree:=ValToInt(SettingsStrings.Values['FLASHFREE']);
    if RebData.SMPresent then
      RebData.SMFree:=ValToInt(SettingsStrings.Values['SM_FLASHFREE']);
    RebData.RebConnected:=True;
  end;
end;
Procedure CloseReb(var RebData:TRebData);
Begin
  if RebData.RebHandle<>INVALID_HANDLE_VALUE then
  Begin
    CloseHandle(RebData.RebHandle);
    RebData.RebHandle:=INVALID_HANDLE_VALUE;
  end;
end;
Procedure SendFileToREB(FN,RebFN:String;RebHandle:THandle);
Type
  TArr=Array[0..0] of byte;
Var
  octets:Integer;
  status:Cardinal;
  p:^TArr;
  sendSize:Integer;
  FileSize:Int64;
  F:TFileStream;
Begin
  if RebHandle=INVALID_HANDLE_VALUE then
    Raise Exception.Create('Device is not connected!');
  F:=TFileStream.Create(FN,fmOpenRead,fmShareDenyWrite);
  FileSize:=F.Size;
  octets:=FileSize;
  sendSize:=FileSize+Length(RebFN)+1;
  GetMem(P,sendSize);
  StrPCopy(PChar(P),RebFN);
  F.ReadBuffer(P^[Length(RebFN)+1],FileSize);
  F.Free;
  if not DeviceIoControl(RebHandle, IOCTL_RocketWriteInitiate, p,
    sendSize, Nil, 0, status, Nil) then RaiseLastOSError;
  if (octets > REB_BLOCK_SZ) then
	 	 octets:= REB_BLOCK_SZ;
	 sendSize:= sendSize- (octets + Length(RebFN)+1);
	 Inc(p,(octets + Length(RebFN)+1));
	 while (sendSize > 0) do
  Begin
 	octets:= sendSize;
		if (octets > REB_BLOCK_SZ) then
			octets:= REB_BLOCK_SZ;

		if not DeviceIoControl(RebHandle, IOCTL_RocketWriteContinue,
			p, octets, Nil, 0, status, Nil) then RaiseLastOSError;
		sendSize:=sendSize-octets;
		Inc(p,octets);
  end;
end;

Function Translit(S:String):String;
// Переводит русский текст в латиницу, типа latinica
Const
  Eng:Array ['А'..'я'] of Char='ABVGDESZIJKLMNOPRSTUFHCCHH''I_AUJabvgdeszijklmnoprstufhcchh''i_avj';
Var
  I:Integer;
Begin
  Result:=S;
  For I:=1 to Length(Result) do
    If (Result[I]>='А') and (Result[I]<='я') then
      Result[I]:=Eng[Result[I]];
end;

Function TransFormToReb;
Type
  TStoreArray=Array of byte;
Var
  Template:IXSLTemplate;
  Processor:IXSLProcessor;
  NodeList,NodeList1:IXMLDOMNodeList;
  S:String;
  FN:WideString;
  F:TFileStream;
  BookTitle,AuthLast:WideString;
  NewBookTitle:String;
  I,I1:Integer;
  ItemID,ItemContentType:String;
  newExt:String;
  TheArr:TStoreArray;
  ImgAsVar:Variant;
  FilesToClean:TStringList;
  Author:String;
  FileOperation: TSHFileOpStruct;
  RebFileName:String;
  SRCFileName:String;
  REbRunData:TRebData;
  FileSize:Integer;
  RBMAkeCoverStr:String;
  SelectedNode:IXMLDOMNode;
  XDoc1:IXMLDOMDocument2;
  GUID:TGUID;
Begin
  // this thing is to fix strange DOM from FBE, not knowing that
  // http://www.gribuser.ru/xml/fictionbook/2.0 is a default namespace
  // for attributes %[ ]
  XDoc1:=CoFreeThreadedDOMDocument40.Create;
  XDoc1.loadXML(Params.Dom.XML);
  Params.Dom:=XDoc1;
  
  Result:=False;
  Params.Dom.setProperty('SelectionLanguage','XPath');
  Params.Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  SelectedNode:=Params.Dom.selectSingleNode('//fb:description/fb:title-info/fb:book-title');
  if SelectedNode<>Nil then
    BookTitle:=SelectedNode.text
  else
    BookTitle:='';
  SelectedNode:=Params.Dom.selectSingleNode('//fb:description/fb:title-info/fb:author/fb:last-name');
  if SelectedNode<> nil then
    AuthLast:=SelectedNode.text
  else
    AuthLast:='';
  SelectedNode:=Params.Dom.selectSingleNode('//fb:description/fb:title-info/fb:author/fb:first-name');
  if SelectedNode<> nil then
    Author:= SelectedNode.text+' '+AuthLast
  else
    Author:='<NoName>';
  if AuthLast='' then
  Begin
    SelectedNode:=Params.Dom.selectSingleNode('fb:description/fb:title-info/fb:author/fb:nickname');
    if SelectedNode<>Nil then
      AuthLast:=SelectedNode.text
    else
      AuthLast:='<NoName>';
  end;
  If BookTitle='' then
    BookTitle:='<Untitled>';
  NewBookTitle:= Copy(AuthLast,1,8) + ' '+BookTitle;
  if Params.TransLitTitle then
  Begin
    NewBookTitle:= TransLit(NewBookTitle);
    Author:= TransLit(Author);
  end;

  if @Params.ProgressProc <> Nil then
    Params.ProgressProc('Processing hyphenation..',5);
  if Params.HyphControler<>Nil then
    Params.HyphControler.Hyphenate(Params.DOM);
  Params.Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  FilesToClean:=TStringList.Create;
  SetLength(FN,501);
  GetTempPathW(500,PWideChar(FN));
  SetLength(FN,Pos(#0,FN)-1);
  FN:=IncludeTrailingPathDelimiter(FN);
  UUIDCreate(GUID);
  FN:=FN+GUIDToString(GUID);
  MkDir(FN);
  FN:=IncludeTrailingPathDelimiter(FN);
  try
    if not params.SkipImages then
      ExtractImagesToFolder(Params.DOM,FN,Params.ProgressProc,FilesToClean);
    
    if @Params.ProgressProc <> Nil then
      Params.ProgressProc('Loading FB2_2_rb.xsl',35);
    Template := CoXSLTemplate40.Create;
    Template._Set_stylesheet(Params.XSL);
    Processor:=Template.createProcessor;
    Params.Dom.async:=False;
    Processor.input:= Params.DOM;
    if params.SkipImages then
      Processor.addParameter('saveimages',0,'')
    else
      Processor.addParameter('saveimages',1,'');

    Processor.addParameter('tocdepth',params.TOCLevel,'');
    Processor.addParameter('pagebreaks',params.PageBreakLeve,'');

    if params.SHortenTOCLines then
      Processor.addParameter('toccut',1,'')
    else
      Processor.addParameter('toccut',0,'');

    if params.SKipDescr then
      Processor.addParameter('skipannotation',1,'')
    else
      Processor.addParameter('skipannotation',0,'');

    RBMAkeCoverStr:='';
    if not params.SkipCOver then
    Begin
      if Params.Dom.selectSingleNode('//fb:description/fb:title-info/fb:coverpage/fb:image') <> Nil then
      RBMAkeCoverStr:=' -c '+Copy(params.Dom.selectSingleNode('//fb:description/fb:title-info/fb:coverpage/fb:image/@xlink:href').text,2,MaxInt);
    end;
    if @Params.ProgressProc <> Nil then Params.ProgressProc('Transforming xml with xslt...',45);
    Processor.transform;
    S:=Processor.output;
    Params.XSL:=nil;
    if @Params.ProgressProc <> Nil then Params.ProgressProc('Saving temporary file..',50);
    F:=TFileStream.Create(FN+'fb2torbconvertertempfile.tmp.html',fmCreate);
    F.Write(S[1],Length(s));
    F.Free;                              
    FilesToClean.Add('fb2torbconvertertempfile.tmp.html');
    if @Params.ProgressProc <> Nil then Params.ProgressProc('Invoking RBMake.exe:'#10#10,55);

    if not ExecApplication(Params.RBMakePath+' -a "'+Author+'" -o fb2torbconvertertempfile.tmp.rb -z -i -t "'+NewBookTitle+'"'+RBMAkeCoverStr+' fb2torbconvertertempfile.tmp.html',FN,Params.EXELines) then
       Raise Exception.Create('rbmake.exe returned error, aborted!');
    if @Params.ProgressProc <> Nil then Params.ProgressProc(#10#10,75);
  Finally
    if @Params.ProgressProc <> Nil then Params.ProgressProc('Removing temporary files...',80);
    For I:=0 to FilesToClean.Count-1 do
    Begin
       if @Params.ProgressProc <> Nil then Params.ProgressProc('  '+FilesToClean[I],80+I);
      DeleteFile(FN+FilesToClean[I]);
    end;
    FilesToClean.Free;
  end;
  If (Params.Target=SaveToFile) then
  Begin
    FillChar(FileOperation, sizeof(FileOperation),#0);
    FileOperation.Wnd:= Params.HParent;
    FileOperation.wFunc  := FO_MOVE;
    SRCFileName:=FN+'fb2torbconvertertempfile.tmp.rb'#0#0;
    FileOperation.pFrom  := PChar(SRCFileName);
    FileOperation.pTo    := PChar(Params.FileName);
    FileOperation.fFlags:=FOF_NOCONFIRMATION;
    if ((SHFileOperation(FileOperation)=0) and (FileOperation.fAnyOperationsAborted = false)) then
       Result:=True;
  end else
    Begin
      REbRunData.HOwner:=Params.HParent;
      OpenREB(REbRunData);
      if not REbRunData.RebConnected then
      Begin
        MessageBox(Params.HParent,'REB1100 not found','Error',0);
        Result:=False;
        Exit;
      end;
      RebFileName:='books\fb2rb'+IntToStr(Round(time*24*60*60*100))+IntToStr(Random(99))+'.rb';
      F:=TFileStream.Create(FN+'fb2torbconvertertempfile.tmp.rb',fmOpenRead);
      FileSize:=F.Size;
      F.Free;
      if (Params.Target=storeOnRebInt) and
      (REbRunData.IntFree<FileSize) then
      Begin
        if not REbRunData.SMPresent or (REbRunData.SMFree<FileSize)
        or (MessageBox(Params.HParent,'Internal memory is full, save new file to SmartMedia?','Not enough space',MB_YESNO or MB_ICONEXCLAMATION)<>idYes) then
          Raise Exception.Create('Not enough free memory on your REB1100 device, remove some books and then retry');
        Params.Target:=storeOnRebSM;
      end;
      if (Params.Target=storeOnRebSM) and (not REbRunData.SMPresent or (REbRunData.SMFree<FileSize)) then
      Begin
        if (REbRunData.IntFree<FileSize) or  (MessageBox(Params.HParent,'No free space found on your SM card, save new file to internal memory?','No free SM space',MB_YESNO or MB_ICONEXCLAMATION)<>idYes) then
          Raise Exception.Create('Not enough free memory on your REB1100 device, remove some books and then retry');
        Params.Target:=storeOnRebInt;
      end;

      if Params.Target=storeOnRebSM then
        RebFileName:='SM\'+RebFileName
      else
        RebFileName:='\'+RebFileName;
      if @Params.ProgressProc <> Nil then
        Params.ProgressProc('Transfering data to reb'#10'(may take a while)...',90);
      SendFileToREB(FN+'fb2torbconvertertempfile.tmp.rb',RebFileName,REbRunData.RebHandle);
      CloseReb(REbRunData);
      DeleteFile(FN+'fb2torbconvertertempfile.tmp.rb');
      Result:=True;
    end;
  RmDir(ExcludeTrailingPathDelimiter(FN));
end;
end.
