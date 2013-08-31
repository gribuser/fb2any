unit fb2lit_engine;

interface
uses MSXML2_TLB,Windows,LITGen_TLB,ComObj;
Type
  TFB2LITConverter=class
  Private
    XSLVar1,XSLVar2,DOM:IXMLDOMDocument2;
    ProcessorVar1,ProcessorVar2:IXSLProcessor;
    ModulePath:String;
    Function GetDocumentXSL:IXMLDOMDocument2;
    Procedure SetDocumentXSL(AXSL:IXMLDOMDocument2);
    Function GetOPFXSL:IXMLDOMDocument2;
    Procedure SetOPFXSL(AXSL:IXMLDOMDocument2);
    Function GetDocumentProcessor:IXSLProcessor;
    Function GetOPFProcessor:IXSLProcessor;
    Procedure ConvertDOM(FN:WideString);
  Public
    TocDeep:Integer;
    SkipImg:Boolean;
    property DocumentProcessor:IXSLProcessor read GetDocumentProcessor;
    property DocumentXSL:IXMLDOMDocument2 read GetDocumentXSL write SetDocumentXSL;
    property OPFProcessor:IXSLProcessor read GetOPFProcessor;
    property OPFXSL:IXMLDOMDocument2 read GetOPFXSL write SetOPFXSL;
    Constructor Create;
    Procedure Convert(ADOM:IDispatch;FN:WideString);
    Procedure WalkTree(Node:IXMLDOMNode;LitParser:ILITParserHost);
  end;
  TMyLITCallback = class(TTypedComObject,ILITCallback)
    function  Message(iType: Integer; iMessageCode: Integer; pwszMessage: PWideChar): HResult; stdcall;
  end;

  function ExportDOM(document:IDispatch;FileName:String; TocDeep:Integer; SkipImg:Boolean):HResult;
Const
  Class_TMyLITCallback:TGUID = '{090F3507-3C0D-45AE-8F73-1AC7CED810F3}';
implementation
uses SysUtils,Classes,ComServ,Variants,ActiveX;

Constructor TFB2LITConverter.Create;
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

Function TFB2LITConverter.GetDocumentXSL;
Var
  XTmp:IXMLDOMDocument2;
Begin
  If XSLVar1=Nil then
  Begin
    XTmp:=CoFreeThreadedDOMDocument40.Create;
    if not XTmp.load(ModulePath+'FB2_2_lit_xhtml.xsl') then
      Raise Exception.Create(XTmp.parseError.reason);
    DocumentXSL:=XTmp;
  end;
  Result:=XSLVar1;
end;
Function TFB2LITConverter.GetOPFXSL;
Var
  XTmp:IXMLDOMDocument2;
Begin
  If XSLVar2=Nil then
  Begin
    XTmp:=CoFreeThreadedDOMDocument40.Create;
    if not XTmp.load(ModulePath+'FB2_2_lit_opf.xsl') then
      Raise Exception.Create(XTmp.parseError.reason);
    OPFXSL:=XTmp;
  end;
  Result:=XSLVar2;
end;

Procedure TFB2LITConverter.SetDocumentXSL;
Var
  Template:IXSLTemplate;
Begin
  XSLVar1:=AXSL;
  Template := CoXSLTemplate40.Create;
  Template._Set_stylesheet(DocumentXSL);
  ProcessorVar1:=Template.createProcessor;
end;

Procedure TFB2LITConverter.SetOPFXSL;
Var
  Template:IXSLTemplate;
Begin
  XSLVar2:=AXSL;
  Template := CoXSLTemplate40.Create;
  Template._Set_stylesheet(OPFXSL);
  ProcessorVar2:=Template.createProcessor;
end;

Function TFB2LITConverter.GetDocumentProcessor;
Begin
  if (ProcessorVar1=Nil) then GetDocumentXSL;
  Result:=ProcessorVar1;
end;
Function TFB2LITConverter.GetOPFProcessor;
Begin
  if (ProcessorVar2=Nil) then GetOPFXSL;
  Result:=ProcessorVar2;
end;

Procedure TFB2LITConverter.ConvertDOM;
Type
  TCreateWriterFunc=function (var Writer:IUnknown):HResult;safecall;
  TStoreArray=Array of byte;
Var
  ImgUseDepth:Integer;
  hLitgen:THandle;
  LibFileName:String;
  CreateWriter:TCreateWriterFunc;
  IUnc:IUnknown;
  SelectedNode:IXMLDOMNode;
  DocAuth,CurFileName:WideString;
  I:Integer;

  hr:HResult;
  LitWriter:ILITWriter;
  PackageHost,ContentHost:ILITParserHost;
  ImageHost:ILITImageHost;
  XDoc,XDoc1:IXMLDOMDocument2;
  CallBack:TMyLITCallback;
  F:TFileStream;
  ImgAsVar:Variant;
  TheArr:TStoreArray;
  BWritten,BWritten1:Cardinal;
  AL:LongWord;
  P:Pointer;
  Buf:Array[0..511] of byte;
Begin
  // this thing is to fix strange DOM from FBE, not knowing that
  // http://www.gribuser.ru/xml/fictionbook/2.0 is a default namespace
  // for attributes %[ ]
  XDoc1:=CoFreeThreadedDOMDocument40.Create;
  XDoc1.loadXML(Dom.XML);
  Dom:=XDoc1;


  DocumentProcessor.addParameter('saveimages',Integer(not SkipImg),'');
  DocumentProcessor.addParameter('tocdepth',TocDeep,'');

  DocumentProcessor.input:= DOM;
  if not DocumentProcessor.transform then
    Raise Exception.Create('Error preparing xhtml doc:');


  OPFProcessor.addParameter('saveimages',Integer(not SkipImg),'');
  OPFProcessor.addParameter('tocdepth',TocDeep,'');

  OPFProcessor.input:= DOM;
  if not OPFProcessor.transform then
    Raise Exception.Create('Error preparing OPF doc:');

  Dom.setProperty('SelectionLanguage','XPath');
  Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  SelectedNode:=Dom.selectSingleNode('//fb:description/fb:title-info/fb:author/fb:last-name');
  if SelectedNode<>Nil then
    DocAuth:=SelectedNode.text
  else
    DocAuth:='fb2lit';

  TComObjectFactory.Create(ComServer, TMyLITCallback, Class_TMyLITCallback, 'fb2lit callback','ho-ho',
    ciMultiInstance, tmApartment);
  CallBack:=TMyLITCallback.Create;
  LibFileName:=ModulePath+'litgen.dll';
  hLitgen:= LoadLibrary(PChar(LibFileName));
  CreateWriter:= GetProcAddress(hLitGen, 'CreateWriter');
  CreateWriter(IUnc);
  if IUnc.QueryInterface(IID_ILITWriter,LitWriter) <> S_OK then
    Raise Exception.Create('Invalid interface returned from litgen.dll');
  if LitWriter.Create(PWideChar(FN),'c:\',PWideChar(DocAuth),0) <> S_OK then
    Raise Exception.Create('Unable to create file');
  Try
    I:=0;
    LitWriter.SetCallback(CallBack);
    LitWriter.GetPackageHost(I,IUnc);
    if IUnc.QueryInterface(IID_ILITParserHost,PackageHost) <> S_OK then
      Raise Exception.Create('Unable to get ILITParserHost interface for Package file!');

    XDoc:=CoFreeThreadedDOMDocument40.Create;
    XDoc.loadXML(OPFProcessor.output);
//    XDoc.save('h:\temp\opf.xml');

    WalkTree(XDoc,PackageHost);
    hr:=PackageHost.Finish;
    if hr <> S_OK then
      Raise Exception.Create('Error '+IntToStr(hr)+' finishing opf part!');
    LitWriter.GetNextCSSHost(IUnc);
    While IUnc <> Nil do
      LitWriter.GetNextCSSHost(IUnc);
    LitWriter.GetNextContentHost(IUnc);
    if IUnc=Nil then
      Raise Exception.Create('GetNextContentHost returned nil, lit generation aborted!');
    if IUnc.QueryInterface(IID_ILITParserHost,ContentHost) <> S_OK then
      Raise Exception.Create('Unable to get ILITParserHost interface for content file!');
    ContentHost.GetFilename(CurFileName);
    While (CurFileName <> 'file://c:\index.html') do
    Begin
      LitWriter.GetNextContentHost(IUnc);
      if IUnc=Nil then
        Raise Exception.Create('GetNextContentHost returned nil, lit generation aborted!');
      if IUnc.QueryInterface(IID_ILITParserHost,ContentHost) <> S_OK then
        Raise Exception.Create('Unable to get ILITParserHost interface for content file!');
      ContentHost.GetFilename(CurFileName);
    end;
    XDoc:=CoFreeThreadedDOMDocument40.Create;
    if not XDoc.loadXML(DocumentProcessor.output) then
      Raise Exception.Create('Error loading xhtml doc:'#10+XDoc.parseError.reason);
//    XDoc.save('h:\temp\123.html');
    WalkTree(XDoc,ContentHost);
    hr:=ContentHost.Finish;
    if hr <> S_OK then
      Raise Exception.Create('Error '+IntToStr(hr)+' finishing xhtml part!');
    hr:=LitWriter.GetNextImageHost(IUnc);
    if not(hr in [S_OK,s_false]) then
      Raise Exception.Create('Error '+IntToStr(hr)+' starting image part!');
    While IUnc<>Nil do
    Begin
      if IUnc.QueryInterface(IID_ILITImageHost,ImageHost) <> S_OK then
        Raise Exception.Create('Unable to get ILITImageHost interface!');
      ImageHost.GetFilename(CurFileName);
      CurFileName:=Copy(CurFileName,11,MaxInt);
      SelectedNode:=Dom.selectSingleNode('//fb:binary[@id='''+CurFileName+''']');
      if SelectedNode<>Nil then
      Begin
        SelectedNode.Set_dataType('bin.base64');
        ImgAsVar:=SelectedNode.nodeTypedValue;
        DynArrayFromVariant(Pointer(TheArr),ImgAsVar,TypeInfo(TStoreArray));
        hr:=ImageHost.Write(TheArr[0],Length(TheArr),BWritten);
        if hr <> S_OK then
          Raise Exception.Create('Error storing image '+CurFileName+'!');

        if BWritten<>Length(TheArr) then
          MessageBox(0,'Error occurred while storing images, some images could be missing.','Error',mb_ok or MB_ICONWARNING);
      end else
        MessageBox(0,PChar('Image id '+CurFileName+' is missing'),'Error',mb_Ok or mb_iconerror);
      ImageHost:=Nil;
      hr:=LitWriter.GetNextImageHost(IUnc);
      if hr = s_false then Break;
      if hr <> S_OK then
        Raise Exception.Create('Error storing images (internal litgen.dll error)!');
    end;
    LitWriter.Finish();
  Except
    on E: Exception do
      Begin
        LitWriter.Fail;
        MessageBox(0,PChar(E.Message),'Error',mb_ok and MB_ICONERROR);
      end;
  end;
end;

Procedure TFB2LITConverter.Convert;
Var
  F:TFileStream;
  ResultText:String;
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

Procedure TFB2LITConverter.WalkTree(Node:IXMLDOMNode;LitParser:ILITParserHost);
Var
  NodeType:DOMNodeType;
  Child:IXMLDOMNode;
  IUnc:IUnknown;
  LitNode:ILITTag;
  Attrs:IXMLDOMNamedNodeMap;
  Attr:IXMLDOMNode;
  NodeName,NodeValue:WideString;
  PWS,PWS1:PWideChar;
  fake:Smallint absolute PWS;
  hr:HResult;
  I:Integer;
Begin
  NodeType:=Node.nodeType;
  Case NodeType of
  NODE_DOCUMENT:Begin
                  // The NODE_DOCUMENT node can have multiple children - e.g. the
                  // DTD.  We only want the root element, which must be the only one
                  // of type NODE_ELEMENT.
                  Child:=Node.firstChild;
                  While (Child<>Nil) and (Child.nodeType <> NODE_ELEMENT) do
                    Child:= Child.nextSibling;
                  if Child<>Nil then WalkTree(Child,LitParser)
                end;
  NODE_ELEMENT: Begin
                  LitParser.NewTag(IUnc);
                  IUnc.QueryInterface(IID_ILITTag,LitNode);
                  IUnc:=Nil;
                  NodeName:=Node.nodeName;
                  PWS:=PWideChar(NodeName);
                  hr:=LitNode.SetName(NodeName[1],Length(NodeName));
                  if hr <> S_OK then
                    Raise exception.Create(Format('Error 0x%x setting tag attribute %S',[hr,NodeName]));
                  Attrs:=Node.attributes;
                  if Attrs<>Nil then
                    For I:=0 to Attrs.length-1 do
                    Begin
                      NodeName:=Attrs[I].NodeName;
                      if Pos(':',NodeName)<>0 then
                        Continue;
                      PWS:=PWideChar(NodeName);
                      NodeValue:=Attrs[I].nodeValue;
                      PWS1:=PWideChar(nodeValue);
                      hr:=LitNode.AddAttribute(NodeName[1],Length(NodeName),nodeValue[1],Length(nodeValue));
                      if hr <> S_OK then
                        Raise exception.Create(Format('Error 0x%x setting tag attribute %S',[hr,NodeName]));
                    end;
                  Child:= Node.firstChild;
                  LitParser.Tag(LitNode,Integer(CHild <> Nil));
                  if Child<>Nil then
                  Begin
                    Repeat
                      WalkTree(Child,LitParser);
                      Child:=Child.nextSibling;
                    Until Child=Nil;
                    hr:=LitParser.EndChildren;
                      if hr <> S_OK then
                        Raise exception.Create(Format('Error 0x%x closing tag %S',[hr]));
                  end;
                end;
  NODE_TEXT,NODE_CDATA_SECTION,NODE_ENTITY_REFERENCE:
                Begin
                  if NodeType=NODE_TEXT then
                    nodeValue:=Node.xml
                  else
                    nodeValue:=Node.text;
                  PWS:=PWideChar(nodeValue);
                  if nodeValue <>'' then
                  Begin
                    LitParser.Text(nodeValue[1], length(nodeValue));
                    if hr <> S_OK then
                      Raise exception.Create(Format('Error 0x%x entering text %S',[hr,nodeValue]));
                  end;
                end
  end;
end;


function TMyLITCallback.Message(iType: Integer; iMessageCode: Integer; pwszMessage: PWideChar): HResult;
Begin
  If (iType=0) or (iType=1) then                   
    MessageBoxW(0,pwszMessage,'Warning',mb_Ok);
end;


function ExportDOM;
Var
  Converter:TFB2LITConverter;
Begin
//(document:IXMLDOMDocument2;FileName:String; TocDeep:Integer; SkipImg:Boolean):HResult
  Result:=E_FAIL;
  Converter:=TFB2LITConverter.Create;
  Converter.TocDeep:=TocDeep;
  Converter.SkipImg:=SkipImg;
  Converter.Convert(document,FileName);
  Result:=S_OK;
end;
end.
