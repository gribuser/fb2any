unit fb2iSilo_engine;

interface
uses MSXML2_TLB,Windows,LITGen_TLB,ComObj,extractimages,exec_external;
Type
  TFB2iSiloConverter=class
  Private
    XSLVar1,XSLVar2,DOM:IXMLDOMDocument2;
    ProcessorVar1,ProcessorVar2:IXSLProcessor;
    ModulePath:String;
    Function GetDocumentXSL:IXMLDOMDocument2;
    Procedure SetDocumentXSL(AXSL:IXMLDOMDocument2);
    Function GetIXLXSL:IXMLDOMDocument2;
    Procedure SetIXLXSL(AXSL:IXMLDOMDocument2);
    Function GetDocumentProcessor:IXSLProcessor;
    Function GetIXLProcessor:IXSLProcessor;
    Procedure ConvertDOM(FN:WideString);
  Public
    TocDeep:Integer;
    SkipImg:Boolean;
    property DocumentProcessor:IXSLProcessor read GetDocumentProcessor;
    property DocumentXSL:IXMLDOMDocument2 read GetDocumentXSL write SetDocumentXSL;
    property IXLProcessor:IXSLProcessor read GetIXLProcessor;
    property IXLXSL:IXMLDOMDocument2 read GetIXLXSL write SetIXLXSL;
    Constructor Create;
    Procedure Convert(ADOM:IDispatch;FN:WideString);
  end;

  function ExportDOM(document:IDispatch;FileName:String; TocDeep:Integer; SkipImg:Boolean):HResult;

implementation
uses SysUtils,Classes,ComServ,Variants,ActiveX;
Function UuidCreate(var GUID:TGUID):HResult;stdcall; external 'RPCRT4.DLL';

Constructor TFB2iSiloConverter.Create;
Begin
  XSLVar1:=Nil;
  XSLVar2:=Nil;
  SetLength(ModulePath,2000);
  GetModuleFileName(HInstance,@ModulePath[1],1999);
  SetLength(ModulePath,Pos(#0,ModulePath)-1);
  ModulePath:=ExtractFileDir(ModulePath);
  ModulePath:=IncludeTrailingPathDelimiter(ModulePath);
  TocDeep:=2;
end;

Function TFB2iSiloConverter.GetDocumentXSL;
Var
  XTmp:IXMLDOMDocument2;
Begin
  If XSLVar1=Nil then
  Begin
    XTmp:=CoFreeThreadedDOMDocument40.Create;
    if not XTmp.load(ModulePath+'FB2_2_html.xsl') then
      Raise Exception.Create(XTmp.parseError.reason);
    DocumentXSL:=XTmp;
  end;
  Result:=XSLVar1;
end;
Function TFB2iSiloConverter.GetIXLXSL;
Var
  XTmp:IXMLDOMDocument2;
Begin
  If XSLVar2=Nil then
  Begin
    XTmp:=CoFreeThreadedDOMDocument40.Create;
    if not XTmp.load(ModulePath+'FB2_2_iSilo_ixl.xsl') then
      Raise Exception.Create(XTmp.parseError.reason);
    IXLXSL:=XTmp;
  end;
  Result:=XSLVar2;
end;

Procedure TFB2iSiloConverter.SetDocumentXSL;
Var
  Template:IXSLTemplate;
Begin
  XSLVar1:=AXSL;
  Template := CoXSLTemplate40.Create;
  Template._Set_stylesheet(DocumentXSL);
  ProcessorVar1:=Template.createProcessor;
end;

Procedure TFB2iSiloConverter.SetIXLXSL;
Var
  Template:IXSLTemplate;
Begin
  XSLVar2:=AXSL;
  Template := CoXSLTemplate40.Create;
  Template._Set_stylesheet(IXLXSL);
  ProcessorVar2:=Template.createProcessor;
end;

Function TFB2iSiloConverter.GetDocumentProcessor;
Begin
  if (ProcessorVar1=Nil) then GetDocumentXSL;
  Result:=ProcessorVar1;
end;
Function TFB2iSiloConverter.GetIXLProcessor;
Begin
  if (ProcessorVar2=Nil) then GetIXLXSL;
  Result:=ProcessorVar2;
end;

Procedure TFB2iSiloConverter.ConvertDOM;
Var
  I:Integer;
  XDoc1:IXMLDOMDocument2;
  FilesToClean:TStringList;
  TmpPathN,HTMName:WideString;
  GUID:TGUID;
  S:String;
  F:TFileStream;
  IsOut:TStringList;
Begin
  // this thing is to fix strange DOM from FBE, not knowing that
  // http://www.gribuser.ru/xml/fictionbook/2.0 is a default namespace
  // for attributes %[ ]
  XDoc1:=CoFreeThreadedDOMDocument40.Create;
  XDoc1.loadXML(Dom.XML);
  Dom:=XDoc1;

  SetLength(TmpPathN,501);
  GetTempPathW(500,PWideChar(TmpPathN));
  SetLength(TmpPathN,Pos(#0,TmpPathN)-1);
  TmpPathN:=IncludeTrailingPathDelimiter(TmpPathN);
  UUIDCreate(GUID);
  TmpPathN:=TmpPathN+GUIDToString(GUID);
  MkDir(TmpPathN);
  TmpPathN:=IncludeTrailingPathDelimiter(TmpPathN);

  IXLProcessor.addParameter('output-path',FN,'');
  HTMName:=TmpPathN+'fb2iSiloConvert_index.html';
  IXLProcessor.addParameter('src-name',HTMName,'');

  IXLProcessor.input:=DOM;

  if not IXLProcessor.transform then
    Raise Exception.Create('Error preparing IXL doc:');
  FilesToClean:=TStringList.Create;

  try
    if not SkipImg then
      ExtractImagesToFolder(DOM,TmpPathN,Nil,FilesToClean);
    DocumentProcessor.addParameter('saveimages',Integer(not SkipImg),'');
    DocumentProcessor.addParameter('tocdepth',TocDeep,'');

    DocumentProcessor.input:= DOM;
    if not DocumentProcessor.transform then
      Raise Exception.Create('Error preparing html doc');

    S:=DocumentProcessor.output;
    F:=TFileStream.Create(HTMName,fmCreate);
    F.Write(S[1],Length(s));
    F.Free;
    FilesToClean.Add('fb2iSiloConvert_index.html');
    S:=IXLProcessor.output;
    F:=TFileStream.Create(TmpPathN+'fb2iSiloConvert_ixl.ixl',fmCreate);
    F.Write(S[1],Length(s));
    F.Free;
    FilesToClean.Add('fb2iSiloConvert_ixl.ixl');
//    IsOut:=TStringList.Create;
    if not ExecApplication(ModulePath+'iSiloXC.exe -q -x '+TmpPathN+'fb2iSiloConvert_ixl.ixl',ExcludeTrailingPathDelimiter(TmpPathN),Nil) then
      MessageBox(0,PChar('Errors during iSiloX run'{#10+IsOut.Text}),'Error',0);
    IsOut.Free;
  finally
    For I:=0 to FilesToClean.Count-1 do
      DeleteFile(TmpPathN+FilesToClean[I]);
    RmDir(ExcludeTrailingPathDelimiter(TmpPathN));
    FilesToClean.Free;
  end;
end;

Procedure TFB2iSiloConverter.Convert;
Var
  OutVar:IXMLDOMDocument2;
Begin
  if ADOM=Nil then
  Begin
    MessageBox(0,'NILL document value, please provide valid IXMLDOMDocument2 on input.','Error',mb_ok or MB_ICONERROR);
    Exit;
  end;
  if ADOM.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
  Begin
    MessageBox(0,'Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2','Error',MB_OK or MB_ICONERROR);
    exit;
  end;
  DOM:=OutVar;
  Try
    ConvertDOM(FN);
  except
    on E: Exception do MessageBox(0,PChar(E.Message),'Error',mb_ok or MB_ICONERROR);
  end
end;


function ExportDOM;
Var
  Converter:TFB2iSiloConverter;
Begin
//(document:IXMLDOMDocument2;FileName:String; TocDeep:Integer; SkipImg:Boolean):HResult
  Result:=E_FAIL;
  Converter:=TFB2iSiloConverter.Create;
  Converter.TocDeep:=TocDeep;
  Converter.SkipImg:=SkipImg;
  Converter.Convert(document,FileName);
  Result:=S_OK;
end;
end.
