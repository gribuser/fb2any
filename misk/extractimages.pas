unit extractimages;
interface
Uses MSXML2_TLB,Classes;

Type
  TCallBackProc=procedure(message:string;percent:Integer) of object;


Procedure ExtractImagesToFolder(DOM:IXMLDOMDocument2;Path:WideString;CallBack:TCallBackProc;FilesToClean:TStringList);


implementation
uses SysUtils,Variants;

Procedure ExtractImagesToFolder;
Type
  TStoreArray=Array of byte;
Var
  NodeList,NodeList1:IXMLDOMNodeList;
  I,I1:Integer;
  ItemID,ItemContentType,newExt:WideString;
  ImgAsVar:Variant;
  TheArr:TStoreArray;
  F:TFileStream;
Begin
  Dom.setProperty('SelectionLanguage','XPath');
  Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');
  NodeList:=Dom.selectNodes('//fb:binary');
  if NodeList<>Nil then
  Begin
    if @CallBack <> Nil then
      CallBack('Extracting images...',10);
    for I:=0 to NodeList.length-1 do
    Begin
      ItemID:=NodeList.item[I].attributes.getNamedItem('id').text;
      ItemContentType:=NodeList.item[I].attributes.getNamedItem('content-type').text;
      if WideLowerCase(ItemContentType)='image/jpeg' then
        newExt:='jpg'
      else if LowerCase(ItemContentType)='image/png' then
        newExt:='png'
      else Continue;

      if @CallBack <> Nil then
        CallBack('  '+ItemID,15+I*3);

      newExt:='fb2torbconvtempimage'+IntToStr(I)+'.tmp.'+newExt;
      NodeList.item[I].attributes.getNamedItem('id').text:=newExt;
      NodeList1:=Dom.selectNodes('//fb:image/@xlink:href[.=''#'+ItemID+''']');
      if NodeList1<>Nil then
        for I1:=0 to NodeList1.length-1 do
          NodeList1.item[I1].text:='#'+newExt;
      NodeList.item[I].Set_dataType('bin.base64');
      ImgAsVar:=NodeList.item[I].nodeTypedValue;
      DynArrayFromVariant(Pointer(TheArr),ImgAsVar,TypeInfo(TStoreArray));
      F:=TFileStream.Create(Path+newExt,fmCreate);
      F.Write(TheArr[0],Length(TheArr));
      F.Free;
      FilesToClean.Add(newExt);
    end;
  end;
end;
end.
