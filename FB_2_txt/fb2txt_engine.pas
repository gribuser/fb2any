unit fb2txt_engine;

interface
uses MSXML2_TLB, Windows,fb2_hyph_TLB,Classes;

Type
  TData= Array of byte;
  TTXTConverter = class
  Private
    XSLVar,DOM:IXMLDOMDocument2;
    ProcessorVar:IXSLProcessor;
    HyphControlerVar:IFB2Hyphenator;
    Function GetXSL:IXMLDOMDocument2;
    Procedure SetXSL(AXSL:IXMLDOMDocument2);
    Function GetProcessor:IXSLProcessor;
    Function ConvertDOM:TData;
    Function WrapText(S,Before:WideString):WideString;
  Public
    SkipDescr:Boolean;
    TextWidth,CodePage:Integer;
    Indent,BR:String;
    WrapList,SpacePositions:TStringList;
    WideUsed:Bool;
    IgnoreBold,IgnoreItalic:Boolean;
    property Processor:IXSLProcessor read GetProcessor;
    property XSL:IXMLDOMDocument2 read GetXSL write SetXsl;
    property HyphControler:IFB2Hyphenator read HyphControlerVar write HyphControlerVar;
    Constructor Create;
    Procedure Convert(ADOM:IDispatch;FN:String);
    destructor Destroy; override;
  end;

Function ExportDOM(AParent:THandle;DOM:IDispatch;FN,BR:String; SkipDescr, Hyphenate:Boolean;
    TextWidth,IndentCount,CodePage:Integer;AIgnoreBold,AIgnoreItalic:Boolean):HResult;

implementation
uses SysUtils,EncodingWarn,save_txt_dialog;
Const
  TrimSym:WideString=' '#9#10#13;
  Wrapchars:WideString=',;;:.?!=…';

Function LineEmpty(const S:WideString):Boolean;
Var
  I:Integer;
Begin
  Result:=True;
  for I:=1 to Length(S) do
    if Pos(S[I],TrimSym)=0 then
    Begin
      Result:=False;
      exit;
    end;
end;


Function SimplifyString(S:WideString;safe:boolean):WideString;
Var
  I:Integer;
  StartSpace,EndSpace:Boolean;
Begin
  Result:='';
  StartSpace:=Pos(S[1],TrimSym)<>0;
  if StartSpace and LineEmpty(S) then
  begin
    if Safe then
      Result:=' ';
    Exit;
  end;
  EndSpace:=Pos(S[Length(S)],TrimSym)<>0;
  While Pos(S[1],TrimSym)<>0 do
    Delete(S,1,1);
  While Pos(S[Length(S)],TrimSym)<>0 do
    SetLength(S,Length(S)-1);
  I:=1;
  While I<length(S) do
  Begin
    if (Pos(S[I],TrimSym)<>0) then
      Begin
        S[I]:=' ';
        while (I<length(S)) and (Pos(S[I+1],TrimSym)<>0) do
          Delete(S,I+1,1);
      end;
    Inc(I);
  end;
  if StartSpace and safe then S:=' '+S;
  if EndSpace and safe then S:=S+' ';
  Result:=S;
end;


Function UnderlineText(S:WideString):WideString;
Var
  I:Integer;
  StartSpace,EndSpace:Boolean;
Begin
  StartSpace:=Pos(S[1],TrimSym)<>0;
  EndSpace:=Pos(S[Length(S)],TrimSym)<>0;
  S:=SimplifyString(S,false);
  For I:=1 to Length(S) do
    if S[I]=' ' then S[I]:='_';
  S:='_'+S+'_';
  if StartSpace then S:=' '+S;
  if EndSpace then S:=S+' ';
  Result:=S;
end;

Function TTXTConverter.WrapText;
var
  LastWrapPos,PrevWrapPos,I:Integer;
  Function FitString(S:String):String;
  Var
    MustAddSpaces,FloatingSpaces,StandingSpaces:Integer;
    I,I1,R:Integer;
  Begin
    Result:=S;
    MustAddSpaces:=TextWidth-Length(S);
    if MustAddSpaces = 0 then exit;
    SpacePositions.Clear;
    For I:=Length(Before)+1 to Length(S) do
      if S[I]=' ' then
        SpacePositions.AddObject('',Pointer(I));
    if SpacePositions.Count=0 then exit;
    FloatingSpaces:= MustAddSpaces mod SpacePositions.Count;
    StandingSpaces:= MustAddSpaces div SpacePositions.Count;
    While FloatingSpaces>0 do
    Begin
      R:=Random(SpacePositions.Count);
      if SpacePositions[R]='' then
      Begin
        SpacePositions[R]:=' ';
        Dec(FloatingSpaces);
      end;
    end;
    For I:=0 to SpacePositions.Count-1 do
      For I1:=1 to StandingSpaces do
        SpacePositions[I]:=SpacePositions[I]+' ';
    For I:= SpacePositions.Count-1 downto 0 do
      Insert(SpacePositions[I],Result,Integer(SpacePositions.Objects[I]));
  end;
Begin
  S:=SimplifyString(S,false);
  S:=Before+S;
  if TextWidth<=0 then
  Begin
    Result:=S;
    Exit;
  end;
  WrapList.Clear;
  Result:='';
  PrevWrapPos:=1;
  LastWrapPos:=1;
  For I:=Length(Before)+1 to Length(S) do
  Begin
    if (S[I]= ' ') or ((I>1) and (Pos(S[I-1],Wrapchars)>0)) then
      LastWrapPos:=I;
    if I-PrevWrapPos>=TextWidth then
    Begin
      if LastWrapPos>PrevWrapPos then
      Begin
        WrapList.Add(Result+Copy(S,PrevWrapPos,LastWrapPos-PrevWrapPos));
      end else
        Begin
          WrapList.Add(Result+Copy(S,PrevWrapPos,I-PrevWrapPos));
          LastWrapPos:=I-1;
        end;
      PrevWrapPos:=LastWrapPos+1;
    end;
  end;
  For I:=0 to WrapList.Count-1 do
    Result:=Result+FitString(WrapList[I])+BR;
  Result:=Result+Copy(S,PrevWrapPos,MaxInt);
end;


Function TTXTConverter.GetXSL;
Var
  ModulePath:String;
  XTmp:IXMLDOMDocument2;
Begin
  If XSLVar=Nil then
  Begin
    SetLength(ModulePath,2000);
    GetModuleFileName(HInstance,@ModulePath[1],1999);
    SetLength(ModulePath,Pos(#0,ModulePath)-1);
    ModulePath:=ExtractFileDir(ModulePath);
    ModulePath:=IncludeTrailingPathDelimiter(ModulePath);
    XTmp:=CoFreeThreadedDOMDocument40.Create;
    if not XTmp.load(ModulePath+'FB2_2_txt.xsl') then
      Raise Exception.Create(XTmp.parseError.reason);
    XSL:=XTmp;
  end;
  Result:=XSLVar;
end;
Procedure TTXTConverter.SetXSL;
Var
  Template:IXSLTemplate;
Begin
  XSLVar:=AXSL;
  Template := CoXSLTemplate40.Create;
  Template._Set_stylesheet(XSL);
  ProcessorVar:=Template.createProcessor;
end;
Function TTXTConverter.GetProcessor;
Begin
  if (ProcessorVar=Nil) then GetXSL;
  Result:=ProcessorVar;
end;

Constructor TTXTConverter.Create;
Begin
  XSLVar:=Nil;
  HyphControlerVar:=Nil;
  SkipDescr:=False;
  TextWidth:=-1;
  Indent:='';
  CodePage:=CP_ACP;
  BR:=#10;
  WrapList:=TStringList.Create;
  SpacePositions:=TStringList.Create;
  IgnoreBold:=False;
  IgnoreItalic:=False;
end;
destructor TTXTConverter.Destroy;
Begin
  WrapList.Free;
  SpacePositions.Free;
end;

Function TTXTConverter.ConvertDOM;
Var
  NodeList,NoteNodes:IXMLDOMNodeList;
  NoteNode,NoteSectionTitle,NoteSectionBody:IXMLDOMNode;
  I,I1:Integer;
  S,LinkTarget:WideString;
  XDoc1:IXMLDOMDocument2;
  Function NoteMeaningLess(S:String):String;
  const
    MLessChars:WideString=' ,.;:''"?!01234567890@#$%^&*()-_+=[]{}|\/~'#160#10#13#9;
  Var
    I:Integer;
  Begin
    Result:='';
    For I:=1 to Length(S) do
      if pos(S[I],MLessChars)=0 then
      Begin
        Result:=S;
        Exit;
      end;
  end;
Begin
  // this thing is to fix strange DOM from FBE, not knowing that
  // http://www.gribuser.ru/xml/fictionbook/2.0 is a default namespace
  // for attributes %[ ]
  XDoc1:=CoFreeThreadedDOMDocument40.Create;
  XDoc1.loadXML(Dom.XML);
  Dom:=XDoc1;

  Dom.async:=False;
  Dom.setProperty('SelectionLanguage','XPath');
  Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  if not IgnoreItalic then
  Begin
    NodeList:=Dom.selectNodes('//fb:emphasis');
    if NodeList<>Nil then
      for I:=0 to NodeList.length-1 do
      Begin
        S:=NodeList.item[I].text;
        if not LineEmpty(S) then
          NodeList.item[I].text:=UnderlineText(S);
      end;
  end;
  if not IgnoreBold then
  Begin
    NodeList:=Dom.selectNodes('//fb:strong');
    if NodeList<>Nil then
      for I:=0 to NodeList.length-1 do
      Begin
        S:=NodeList.item[I].text;
        if not LineEmpty(S) then
          NodeList.item[I].text:=WideUpperCase(S);
      end;
  end;
  NodeList:=Dom.selectNodes('//fb:a[@type = ''note'']');
  if NodeList<>Nil then
    for I:=0 to NodeList.length-1 do
    Begin
//      NoteNode:=NodeList.item[I].attributes.getNamedItem('xlink:href');
//      NodeList.item[I].setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
      NoteNode:=NodeList.item[I].selectSingleNode('@xlink:href');
      If (NoteNode<>Nil) then
      Begin
        LinkTarget:=NoteNode.text;
        if LinkTarget[1]='#' then LinkTarget:=Copy(LinkTarget,2,MaxInt);

        NoteNodes:=Dom.selectNodes('//fb:body[@name=''notes'']//fb:section[@id = '''+LinkTarget+''']/*[name() !=''title'']');
        NoteSectionTitle:=Dom.selectSingleNode('//fb:body[@name=''notes'']//fb:section[@id = '''+LinkTarget+''']/fb:title');
        S:='';
        if (NoteNodes<>Nil) and (NoteNodes.length>0) or (NoteSectionTitle<>Nil) then
        Begin
          if NoteSectionTitle<> Nil then
            S:=NoteMeaningLess(NoteSectionTitle.text);
          if (S<>'') and (NoteNodes<>Nil) and (NoteNodes.length>0) then
            S:=S+ ': ';
          if NoteNodes<>Nil then
            For I1:=0 to NoteNodes.length-1 do
            Begin
              if S<>'' then S:=S+' ';
              S:=S + NoteNodes[I1].text;
            end;
          if not LineEmpty(S) then
            NodeList.item[I].text:=NoteMeaningLess(NodeList.item[I].text)+'['+S+'] ';
        end;
      end;
    end;


  if HyphControler<>Nil then
    HyphControler.Hyphenate(DOM);

  NodeList:=Dom.selectNodes('//*[name()!=''binary'' and name()!=''strong'' and name()!=''emphasis'' and name()!=''a'' and name()!=''p'']/text()|//fb:title/fb:p');
  if NodeList<>Nil then
    for I:=0 to NodeList.length-1 do
    Begin
      S:=NodeList.item[I].text;
      if not LineEmpty(S) then
        NodeList.item[I].text:=WrapText(S,'');
    end;
  if TextWidth > 0 then
  begin
    NodeList:=Dom.selectNodes('//fb:p[not(parent::fb:title)]|//fb:v|//fb:td');
    if NodeList<>Nil then
      for I:=0 to NodeList.length-1 do
      Begin
        S:=NodeList.item[I].text;
        if not LineEmpty(S) then
          NodeList.item[I].text:=WrapText(S,Indent)
        else
          if TextWidth > 0 then
            NodeList.item[I].text:='';
      end;
  end else
    Begin
      NodeList:=Dom.selectNodes('//fb:p[not(parent::fb:title)]/text()|//fb:v/text()|//fb:td/text()|//fb:strong/text()|//fb:emphasis/text()|//fb:style/text()|//fb:sub/text()|//fb:strikethrough/text()|//fb:sup/text()');
      if NodeList<>Nil then
        for I:=0 to NodeList.length-1 do
          NodeList.item[I].text:=SimplifyString(NodeList.item[I].xml,True);
    end;


  Processor.addParameter('skipannotation',Integer(SkipDescr),'');
  Processor.addParameter('brstr',BR,'');
  Processor.addParameter('dblbr',Integer(Indent=''),'');
  if TextWidth <= 0 then
    Processor.addParameter('indent-str',Indent,'');
  Processor.input:=DOM;
  Processor.transform;
  S:=Processor.output;
  WideUsed:=False;
  if CodePage = CP_UTF8 then
  Begin
    SetLength(Result,WideCharToMultiByte(CodePage,0,PWideChar(S),-1,@Result[0],0,Nil,Nil));
    WideCharToMultiByte(CodePage,0,PWideChar(S),Length(S),@Result[0],Length(Result),Nil,Nil)
  end else if CodePage <> CP_UTF16 then
  Begin
    SetLength(Result,WideCharToMultiByte(CodePage,WC_COMPOSITECHECK or WC_DEFAULTCHAR,PWideChar(S),-1,@Result[0],0,Nil,@WideUsed));
    WideCharToMultiByte(CodePage,WC_COMPOSITECHECK or WC_DEFAULTCHAR,PWideChar(S),Length(S),@Result[0],Length(Result),Nil,@WideUsed)
  end else
    Begin
      SetLength(Result,Length(S)*2);
      Move(S[1],Result[1],Length(S)*SizeOf(WideChar));
    end;
end;

Procedure TTXTConverter.Convert;
Var
  F:TFileStream;
  ResultText:TData;
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
    ResultText:=ConvertDOM;
    F:=TFileStream.Create(FN,fmCreate);
    F.Write(ResultText[0],Length(ResultText));
    F.Free;
  except
    on E: Exception do MessageBox(0,PChar(E.Message),'Error',mb_ok or MB_ICONERROR);
  end
end;
Function ExportDOM;
Var
  Converter:TTXTConverter;
  I:Integer;
  HyphDescrDOM:IXMLDOMDocument2;
Begin
  Converter:=TTXTConverter.Create;
  Converter.SkipDescr:=SkipDescr;
  For I:=1 to IndentCount do
    Converter.Indent:=Converter.Indent+' ';
  if Hyphenate then
  Begin
    Converter.HyphControler:=CoFB2Hyphenator.Create;
    HyphDescrDOM:=CoFreeThreadedDOMDocument40.Create;
    HyphDescrDOM.preserveWhiteSpace:=True;
    HyphDescrDOM.loadXML('<device name="Fixed width text"><displays><display-mode name="Default" width="'+IntToStr(TextWidth)+'"/></displays><fonts><font name="Default"><font-size name="Default"><normal default-width="1"/><strong default-width="1"/><emphasis default-width="1"/><strongemphasis default-width="1"/></font-size></font></fonts></device>');
    Converter.HyphControler.deviceDescr:=HyphDescrDOM;
    Converter.HyphControler.currentDeviceSize:='Default';
    Converter.HyphControler.currentFont:='Default';
    Converter.HyphControler.currentFontSize:='Default';
    Converter.HyphControler.strPrefix:=Converter.Indent;
  end;
  Converter.TextWidth:=TextWidth;
  Converter.CodePage:=CodePage;
  Converter.BR:=BR;
  Converter.IgnoreBold:=AIgnoreBold;
  Converter.IgnoreItalic:=AIgnoreItalic;
  Converter.Convert(DOM,FN);
  if Converter.WideUsed then with TEncWarn.Create(Nil) do
  Begin
    ShowModal;
  end;
  Converter.Free;
end;

end.
