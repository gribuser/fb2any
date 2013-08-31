unit fb2rtf_engine;

interface
uses MSXML2_TLB,Windows;

type
  TRTFConverter = class
  Private
    XSLVar,DOM:IXMLDOMDocument2;
    ProcessorVar:IXSLProcessor;
    Function GetXSL:IXMLDOMDocument2;
    Procedure SetXSL(AXSL:IXMLDOMDocument2);
    Function GetProcessor:IXSLProcessor;
    Function ConvertDOM:String;
  Public
    SkipImages, SkipCover, SkipDescr, EncCompat, ImgCompat:Boolean;
    property Processor:IXSLProcessor read GetProcessor;
    property XSL:IXMLDOMDocument2 read GetXSL write SetXsl;
    Constructor Create;
    Procedure Convert(ADOM:IDispatch;FN:String);
    Procedure EscapeText;
    Procedure ExtractImages;
  end;

Function ExportDOM(AParent:THandle;DOM:IDispatch;FN:String; SkipImages, SkipCover, SkipDescr, EncCompat, ImgCompat:boolean):HResult;
implementation
uses SysUtils, Classes, Variants, Graphics, pngimage, Jpeg;
Type
  TStoreArray=Array of byte;

Procedure TRTFConverter.EscapeText;
Const
  StartC=WideChar(#0);
  EndC=WideChar(#255);
Var
  NodeList,NodeList1:IXMLDOMNodeList;
  S:WideString;
  I:Integer;
  TranslatedChars:array[StartC..EndC] of WideString;
  IC:WideChar;

  Function Trim(S:WideString):WideString;
  Const
    TrimSym:WideString=' '#9#10#13;
  Begin
    if S='' then Exit;
    While (S<>'') and (Pos(S[1],TrimSym)<>0) do
      Delete(S,1,1);
    While (S<>'') and (Pos(S[Length(S)],TrimSym)<>0) do
      SetLength(S,Length(S)-1);
    Result:=S;
  end;
  Function LineEmpty(const S:WideString):Boolean;
  Begin
    Result:=False;
    if Trim(S)='' then
      Result:=True;
  end;
  Function CharToUTFTrans(C:WideChar):WideString;
  Var
    CharAsWord:Word absolute C;
  Begin
    if not EncCompat and (CharAsWord>=$410) and (CharAsWord<=$451) then
    Begin
      Result:=C;
      Exit;
    end;
    Result:=IntToStr(CharAsWord);
    While Length(Result)<4 do
      Result:='0'+Result;
    Result:='\uc1\u'+Result+'?';
  end;
  Function EscapeString(S:WideString):WideString;
  Var
    I:Integer;
  Begin
    Result:='';
    For I:=1 to Length(S) do
    Begin
      If (Word(S[I])>=$20) and (Word(S[I])<$7E) then
      Begin
        Result:=Result+S[I];
        Continue;
      end;
      If Word(S[I])<=255 then
        Result:=Result+TranslatedChars[S[I]]
      else
        Result:=Result+CharToUTFTrans(S[I]);
    end;
  end;
begin
  For IC:=#0 to #255 do
    TranslatedChars[IC]:=CharToUTFTrans(IC);
  For IC:=#32 to #126 do
    TranslatedChars[IC]:=IC;
  TranslatedChars[WideChar('\')]:='\''5c';
  TranslatedChars[WideChar('{')]:='\''7b';
  TranslatedChars[WideChar('}')]:='\''7d';
  TranslatedChars[WideChar(#10)]:=' ';
  TranslatedChars[WideChar(#13)]:=' ';
  TranslatedChars[WideChar(#9)]:='\tab ';
  TranslatedChars[WideChar('-')]:='\_';
  TranslatedChars[WideChar(#160)]:='\~';
  TranslatedChars[WideChar(#173)]:='\-';
  TranslatedChars[WideChar('–')]:='\endash';
  TranslatedChars[WideChar('—')]:='\endash';

  Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  NodeList:=Dom.selectNodes('//*[name()!=''binary'']/text()');
  if NodeList<>Nil then
    for I:=0 to NodeList.length-1 do
    Begin
      S:=NodeList.item[I].xml;
      if not LineEmpty(S) then
        NodeList.item[I].text:=EscapeString(S);
    end;
end;

Procedure TRTFConverter.ExtractImages;
Const
  JPG=0;
  PNG=1;
Var
  NodeList,NodeList1:IXMLDOMNodeList;
  I,I1:Integer;
  ItemID:WideString;
  ItemContentType:String;
  ImgType:Integer;
  F:TMemoryStream;
  ImgAsVar:Variant;
  TheArr:TStoreArray;
  ImgStr:String;

  Function ImgToStr(F:TStream;ImgType:Integer):String;
  Var
    PNGImg:TPngObject;
    JPegImg:TJPEGImage;
    Graph:TGraphic;
    BMP:TBitmap;
    I:Integer;
    B:Byte;
  Const
    ImgDescrs:array[JPG..PNG] of string=('jpeg','png');
    function BitmapToRTF(pict: TBitmap): string;
    var
      bi, bb, rtf: string;
      bis, bbs: Cardinal;
      achar: ShortString;
      hexpict: string;
      I: Integer;
    begin
      GetDIBSizes(pict.Handle, bis, bbs);
      SetLength(bi, bis);
      SetLength(bb, bbs);
      GetDIB(pict.Handle, pict.Palette, PChar(bi)^, PChar(bb)^);
      rtf := '{\rtf1 {\pict\dibitmap0 ';
      SetLength(hexpict, (Length(bb) + Length(bi)) * 2);
      I := 2;
      for bis := 1 to Length(bi) do
      begin
        achar := IntToHex(Integer(bi[bis]), 2);
        hexpict[I - 1] := achar[1];
        hexpict[I] := achar[2];
        Inc(I, 2);
      end;
      for bbs := 1 to Length(bb) do
      begin
        achar := IntToHex(Integer(bb[bbs]), 2);
        hexpict[I - 1] := achar[1];
        hexpict[I] := achar[2];
        Inc(I, 2);
      end;
      rtf := rtf + hexpict + ' }}';
      Result := rtf;
    end;
  Begin
    Result:='';
    If ImgType=JPG then
    Begin
      JPegImg:=TJPEGImage.Create;
      JpegImg.LoadFromStream(F);
      Graph:=JpegImg;
    end else if ImgType=PNG then
      Begin
        PNGImg:=TPngObject.Create;
        pngImg.LoadFromStream(F);
        Graph:=pngImg
      end else Exit;
    if not ImgCompat then
    Begin
      Result:='{\pict\'+ImgDescrs[ImgType]+'blip\picw'+IntToStr(Graph.Width)+'\pich'+IntToStr(Graph.Height)+
        '\picwgoal'+IntToStr(Graph.Width*15)+'\pichgoal'+IntToStr(Graph.Height*15)+#13;
      F.Seek(0,soFromBeginning);
      For I:=1 to F.Size do
      Begin
        F.Read(B,1);
        Result:=Result+IntToHex(B,2);
        if I mod 80 = 0 then Result:=Result+#10;
      end;
      Result:=Result+'}'
    end else
      Begin
//        Result:='{\pict\dibitmap0';
        BMP:=TBitmap.Create;
        bmp.Assign(Graph);

{        case bmp.PixelFormat of
          pf1bit:Result:=Result+'\wbmbitspixel1';
          pf8bit:Result:=Result+'\wbmbitspixel8';
          pf16bit:Result:=Result+'\wbmbitspixel16';
          pf24bit:Result:=Result+'\wbmbitspixel24';
          pf32bit:Result:=Result+'\wbmbitspixel32';
        end;
//         & \wbmplanes & \wbmwidthbytes
        Result:=Result+'\picw'+IntToStr(Graph.Width)+'\pich'+IntToStr(Graph.Height)+
        '\picwgoal'+IntToStr(Graph.Width*15)+'\pichgoal'+IntToStr(Graph.Height*15)+#13;}
        Result:=BitmapToRTF(bmp);
      end;
    Graph.Free;
  end;
Begin
  Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  NodeList:=Dom.selectNodes('//fb:binary');
  if NodeList<>Nil then
    for I:=0 to NodeList.length-1 do
    Begin
      ItemID:=NodeList.item[I].attributes.getNamedItem('id').text;
      ItemContentType:=NodeList.item[I].attributes.getNamedItem('content-type').text;
      if LowerCase(ItemContentType)='image/jpeg' then
        ImgType:=JPG
      else if LowerCase(ItemContentType)='image/png' then
        ImgType:=PNG
      else Continue;

      NodeList.item[I].Set_dataType('bin.base64');
      ImgAsVar:=NodeList.item[I].nodeTypedValue;
      DynArrayFromVariant(Pointer(TheArr),ImgAsVar,TypeInfo(TStoreArray));
      F:=TMemoryStream.Create;
      F.Write(TheArr[0],Length(TheArr));
      F.Seek(0,soFromBeginning);
      ImgStr:=ImgToStr(F,ImgType);
      F.Free;
      NodeList1:=Dom.selectNodes('//fb:image[@xlink:href=''#'+ItemID+''']');
      if NodeList1<>Nil then
        for I1:=0 to NodeList1.length-1 do
          NodeList1.item[I1].text:=ImgStr;
    end;
end;

Function TRTFConverter.ConvertDOM:String;
Var
  ImgUseDepth:Integer;
  XDoc1:IXMLDOMDocument2;
Begin
  // this thing is to fix strange DOM from FBE, not knowing that
  // http://www.gribuser.ru/xml/fictionbook/2.0 is a default namespace
  // for attributes %[ ]
  XDoc1:=CoFreeThreadedDOMDocument40.Create;
  XDoc1.loadXML(Dom.XML);
  Dom:=XDoc1;

  ImgUseDepth:=2;
  if SkipImages then ImgUseDepth:=0 else if SkipCover then ImgUseDepth:=1;
  Processor.addParameter('saveimages',ImgUseDepth,'');
  Processor.addParameter('skipannotation',Integer(SkipDescr),'');

  Dom.async:=False;
  Processor.input:= DOM;
  Processor.transform;
  Result:=Processor.output;
end;

Function ExportDOM;
Var
  Converter:TRTFConverter;
Begin
  Converter:=TRTFConverter.Create;
  Converter.SkipImages:=SkipImages;
  Converter.SkipCover:=SkipCover;
  Converter.SkipDescr:=SkipDescr;
  Converter.EncCompat:=EncCompat;
  Converter.ImgCompat:=ImgCompat;
  Converter.Convert(DOM,FN);
  Converter.Free;
end;

Constructor TRTFConverter.Create;
Begin
  XSLVar:=Nil;
end;

Procedure TRTFConverter.Convert;
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
    EscapeText;
    ExtractImages;
    ResultText:=ConvertDOM;
    F:=TFileStream.Create(FN,fmCreate);
    F.Write(ResultText[1],Length(ResultText));
    F.Free;
  except
    on E: Exception do MessageBox(0,PChar(E.Message),'Error',mb_ok or MB_ICONERROR);
  end
end;

Function TRTFConverter.GetXSL;
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
    if not XTmp.load(ModulePath+'FB2_2_rtf.xsl') then
      Raise Exception.Create(XTmp.parseError.reason);
    XSL:=XTmp;
  end;
  Result:=XSLVar;
end;
Procedure TRTFConverter.SetXSL;
Var
  Template:IXSLTemplate;
Begin
  XSLVar:=AXSL;
  Template := CoXSLTemplate40.Create;
  Template._Set_stylesheet(XSL);
  ProcessorVar:=Template.createProcessor;
end;
Function TRTFConverter.GetProcessor;
Var
  XTmp:IXMLDOMDocument2;
Begin
  if (ProcessorVar=Nil) then GetXSL;
  Result:=ProcessorVar;
end;


end.
