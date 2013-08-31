unit com;
{$WARN SYMBOL_PLATFORM OFF}
interface
uses ComObj, ActiveX, FB2_hyph_TLB, StdVcl,MSXML2_TLB,Classes;

type
  TCharWidthTable=array of record
    Char:WideChar;
    Width:Integer;
  end;
  THyphState=(normal,strong,emphasis,strongemphasis);
  
  TFB2Hyphenator = class(TAutoObject, IFB2Hyphenator)
  protected
    procedure Hyphenate(const document: IDispatch); safecall;
    function Get_currentFont: OleVariant; safecall;
    function Get_fontList: OleVariant; safecall;
    function Get_fontSizeList: OleVariant; safecall;
    procedure Set_currentFont(Value: OleVariant); safecall;
    procedure Set_deviceDescr(const Value: IDispatch); safecall;
    function Get_currentFontSize: OleVariant; safecall;
    procedure Set_currentFontSize(Value: OleVariant); safecall;
    function Get_deviceSizeList: OleVariant; safecall;
    function Get_currentDeviceSize: OleVariant; safecall;
    procedure Set_currentDeviceSize(Value: OleVariant); safecall;
    function Get_hyphStr: OleVariant; safecall;
    function Get_plainOnly: WordBool; safecall;
    function Get_strPrefix: OleVariant; safecall;
    procedure Set_hyphStr(Value: OleVariant); safecall;
    procedure Set_plainOnly(Value: WordBool); safecall;
    procedure Set_strPrefix(Value: OleVariant); safecall;
    { Protected declarations }
  Private
    DefChars:array[normal..strongemphasis] of integer;
    KnownCharWidths:array[normal..strongemphasis] of TCharWidthTable;
    DeviceDescriptionXML:IXMLDOMDocument2;
    CurrentDevice,CurrentFont,CurrentFontSize:WideString;
    Spaces,Points,GlasCHAR,SoglChar,SpecSign,SofrHardSign:WideString;
    CurState:THyphState;
    TagStack:TStringList;
    ScreenWidth:Integer;
    HyphStr,Prefix:WideString;
    HyphWidth,PrefixWidth:Integer;
    MakeItPlain:Boolean;
    BoldStack,EmphasisStack:Integer;
    Function GetValuesAsString(pattern:WideString):WideString;
    Function CharWidth(const C:WideString;var Posit:Integer):Integer;
    Function SymbType(C:WideChar):Char;
    Function BreakPos(AWord:WideString;MaxL:Integer):Integer;
    procedure InsertHyphs(P:IXMLDOMNode;doc:IXMLDOMDocument2);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;
  
implementation
uses ComServ,Windows,SysUtils;
Const
  Undef='U';
  Glasn='V';
  Sogl='N';
  Spesial='S';
  SoftHard='Q';
  SpaceChar=' ';


Procedure TFB2Hyphenator.AfterConstruction;
Var
  CharDatPath:String;
  HyphCharsDataXML:IXMLDOMDocument2;
Begin
  DeviceDescriptionXML:=Nil;
  SetLength(CharDatPath,2000);
  GetModuleFileName(HInstance,@CharDatPath[1],1999);
  SetLength(CharDatPath,Pos(#0,CharDatPath)-1);
  CharDatPath:=ExtractFileDir(CharDatPath);
  CharDatPath:=IncludeTrailingPathDelimiter(CharDatPath)+'chardat.xml';
  HyphCharsDataXML:=CoFreeThreadedDOMDocument40.Create;
  HyphCharsDataXML.load(CharDatPath);
  HyphCharsDataXML.setProperty('SelectionLanguage','XPath');
  Spaces:=HyphCharsDataXML.selectSingleNode('//spacechars').text;
  Points:=HyphCharsDataXML.selectSingleNode('//punct').text;
  GlasCHAR:=HyphCharsDataXML.selectSingleNode('//vocalic').text;
  SoglChar:=HyphCharsDataXML.selectSingleNode('//non-vocalic').text;
  SpecSign:=HyphCharsDataXML.selectSingleNode('//spec').text;
  SofrHardSign:=HyphCharsDataXML.selectSingleNode('//softhard').text;
  HyphCharsDataXML:=nil;
  TagStack:=TStringList.Create;
  HyphStr:='- ';
  Prefix:=#160#160#160;
  MakeItPlain:=False;
end;

procedure TFB2Hyphenator.BeforeDestruction;
Begin
  DeviceDescriptionXML:=Nil;
  TagStack.Free;
end;

Function TFB2Hyphenator.GetValuesAsString;
Var
  I:Integer;
  objNodeList:IXMLDOMNodeList;
Begin
  Result:='';
  DeviceDescriptionXML.setProperty('SelectionLanguage', 'XPath');
  objNodeList:=DeviceDescriptionXML.selectNodes(pattern);
  For I:=0 to objNodeList.length-1 do
  Begin
    if Result<>'' then
      Result:=Result+#10;
    Result:=Result+objNodeList.item[I].Text;
  end;
  objNodeList:=Nil;
end;


procedure TFB2Hyphenator.Set_deviceDescr(const Value: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
begin
  if Value.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
    Exception.Create('Invalid XML description document interface on enter, should be called with IXMLDOMDocument2');
  DeviceDescriptionXML:=OutVar;
end;


procedure TFB2Hyphenator.Hyphenate(const document: IDispatch);
Var
  Doc:IXMLDOMDocument2;
  Pattern:WideString;
  NodeListToGo:IXMLDOMNodeList;
  I:Integer;
  
  Procedure LoadFontVariant(var DefCharW:Integer; var ChTab:TCharWidthTable; fontVar:WideString);
  Var
    objNodeList:IXMLDOMNodeList;
    I:Integer;
    Req:WideString;
  Begin
    DefCharW:=StrToInt(GetValuesAsString('//fonts/font[@name='''+CurrentFont+''']/font-size[@name='''+CurrentFontSize+''']/'+fontVar+'/@default-width'));
    Req:='//fonts/font[@name='''+CurrentFont+''']/font-size[@name='''+CurrentFontSize+''']/'+fontVar+'/c';
    objNodeList:=DeviceDescriptionXML.selectNodes(Req);
    if objNodeList.length=0 then Exit;
    SetLength(ChTab,objNodeList.length);
    for I:=0 to objNodeList.length-1 do
    Begin
      ChTab[I].Char:=objNodeList.item[I].attributes.getNamedItem('c').text[1];
      ChTab[I].Width:=StrToInt(objNodeList.item[I].text);
    end;
  end;
begin
  Doc:=IXMLDOMDocument2(document);
  doc.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0"');
  doc.setProperty('SelectionLanguage', 'XPath');
  DeviceDescriptionXML.setProperty('SelectionLanguage', 'XPath');

  if DeviceDescriptionXML=nil then
    Pattern:='//fb:p[name(./parent::*) != ''title'']//text()|//fb:v//text()|//fb:td//text()'
  else
    Begin
      ScreenWidth:=StrToInt(GetValuesAsString('//displays/display-mode[@name='''+CurrentDevice+''']/@width'));
      LoadFontVariant(DefChars[normal],KnownCharWidths[normal],'normal');
      if DefChars[normal]=0 then
        Exception.Create('Error loading char widths for font '+CurrentFont+', device '+CurrentDevice+'. Make shure all xml files are intact (may be you should reinstall FB2_2_any?)');
      If not(MakeItPlain) then
      Begin
        LoadFontVariant(DefChars[strong],KnownCharWidths[strong],'strong');
        LoadFontVariant(DefChars[emphasis],KnownCharWidths[emphasis],'emphasis');
        LoadFontVariant(DefChars[strongemphasis],KnownCharWidths[strongemphasis],'strongemphasis');
      end;
      if (DefChars[strong]=0) and (DefChars[emphasis]=0) and (DefChars[strongemphasis]=0) then
        Pattern:='//fb:p[name(./parent::*) != ''title'' and count(./fb:*)=0]'
      else if DefChars[strong]=0 then
        Pattern:='//fb:p[name(./parent::*) != ''title'' and count(.//fb:strong)=0]'
      else
        Pattern:='//fb:p[name(./parent::*) != ''title'' and count(.//fb:emphasis)=0]'
    end;
  HyphWidth:=0;
  I:=1;
  While I<=Length(HyphStr) do
    if (I<Length(HyphStr)) or (HyphStr[I]<>' ') then
      HyphWidth:=HyphWidth+CharWidth(HyphStr,I)
    else
      Inc(I);
//  Set_hyphStr(HyphStr);
  Set_strPrefix(Prefix);
  NodeListToGo:= Doc.selectNodes(Pattern);
  for I:=0 to NodeListToGo.length-1 do
    InsertHyphs(NodeListToGo.item[I],Doc);
end;


function TFB2Hyphenator.Get_fontList: OleVariant;
begin
  Result:=GetValuesAsString('//fonts/font/@name');
end;

function TFB2Hyphenator.Get_fontSizeList: OleVariant;
begin
  Result:=GetValuesAsString('//fonts/font[@name='''+CurrentFont+''']/font-size/@name');
end;

function TFB2Hyphenator.Get_currentFont: OleVariant;
begin
  Result:=CurrentFont;
end;

procedure TFB2Hyphenator.Set_currentFont(Value: OleVariant);
begin
  CurrentFont:=Value;
end;

function TFB2Hyphenator.Get_currentFontSize: OleVariant;
begin
  Result:=CurrentFontSize;
end;

procedure TFB2Hyphenator.Set_currentFontSize(Value: OleVariant);
begin
  CurrentFontSize:=Value;
end;

function TFB2Hyphenator.Get_deviceSizeList: OleVariant;
begin
  Result:=GetValuesAsString('//displays/display-mode/@name');
end;

function TFB2Hyphenator.Get_currentDeviceSize: OleVariant;
begin
  Result:=CurrentDevice;
end;

procedure TFB2Hyphenator.Set_currentDeviceSize(Value: OleVariant);
begin
  CurrentDevice:=Value;
end;

Function TFB2Hyphenator.CharWidth;
Var
  I:Integer;
Begin
  Result:=DefChars[CurState];
  For I:=0 to Length(KnownCharWidths[CurState])-1 do
    if KnownCharWidths[CurState,I].Char=C[Posit] then
    Begin
      Result:=KnownCharWidths[CurState,I].Width;
      break;
    end;
  Inc(Posit);
end;

Function TFB2Hyphenator.SymbType;
Var
  CStr:WideString;
Begin
  Result:=Undef;
  CStr:=C;
  If pos(CharUpperW(PWideChar(CStr)),SoglChar)>0 then Result:=Sogl else
  If pos(CharUpperW(PWideChar(CStr)),GlasChar)>0 then Result:=Glasn else
  If pos(CharUpperW(PWideChar(CStr)),SpecSign)>0 then Result:=Spesial else
  If pos(CharUpperW(PWideChar(CStr)),SofrHardSign)>0 then Result:=SoftHard else
  If pos(CharUpperW(PWideChar(CStr)),Spaces)>0 then Result:=SpaceChar;
end;

Function TFB2Hyphenator.BreakPos;
Var
  I,EndSeek:Integer;
  Word:String;
Begin
  Result:=0;
  If MaxL>=length(AWord) then exit;
  
//Преобразуем реальную строку в ее структурный эквивалент
  SetLength(Word,Length(AWord));
  For I:=1 to length(Word) do
    Word[I]:=SymbType(AWord[I]);
//Будем подбираться с тыла, решием с какого места можно начать
  EndSeek:=MaxL;
  If EndSeek>length(Word)-4 then
    EndSeek:=length(Word)-4;
//Если в активной части слова встречаются неизвестные символы - ну его нафиг...
  If (Pos(Undef,Word)>2) and (Pos(Undef,Word)<EndSeek) then exit;
//Если слово очень короткое, не разбиваем
//С зада наперед - ищем подходящие условия для переноса
  For I:= EndSeek downto 3 do
  if ((Word[i]=Sogl)and(Word[i-1]=Glasn)and(Word[i+1]=Sogl)and(Word[i+2]<>Spesial))
    or ((Word[i]=Glasn)and(Word[i-1]=Sogl)and(Word[i+1]=Sogl)and(Word[i+2]=Glasn))
    or ((Word[i]=Glasn)and(Word[i-1]=Sogl)and(Word[i+1]=Glasn)and(Word[i+2]=Sogl))
//    or ((Word[i-1]=Glasn)and(Word[i]=Sogl)and(Word[i+1]=Sogl)and(Word[i+2]=Sogl)and(Word[i+3]=Glasn))
    or ((Word[i]=SoftHard)and(Word[i+1]<>Spesial)) or
    ((Word[i] in [Sogl,Glasn])and(Word[i+1]=Word[i]))
    or (Word[i+1]=Spesial) then
    begin
      //Нашли!!!
      Result:=I;
      Exit;
    end;
end;

Procedure TFB2Hyphenator.InsertHyphs;
Var
  StartWidth:Integer;
  
{  Posit,Width,WordPosit,BrPos,TirPos:Integer;
  WordToBreake:WideString;
  MaxL:Integer;
  OldPosit:Integer;}
  
  Function LastWord(S:WideString;Var Posit:Integer):WideString;
  Var
    I:Integer;
  Begin
    Result:='';
    For I:=Posit+1 to Length(S) do
      If SymbType(S[I]) = SpaceChar then
      Begin
        If Pos(S[I],Points)>0 then
          Result:=Result+S[I];
        Break;
      end
      else
        Result:=Result+S[I];
    For I:= Posit downto 1 do
      If (SymbType(S[I]) = SpaceChar) or (I=1) then
      Begin
        Posit:=I+1;
        Break;
      end
      else
        Result:=S[I]+Result;
  end;
  function HyphText(S:WideString;var CollectedWidth:Integer):WideString;
  Var
    Width,Posit,WordPosit,MaxL,TirPos,BrPos,OldPosit:Integer;
    WordToBreake:WideString;
    Procedure CleanString(var S:WideString);
    Var
      I:Integer;
      Procedure ReplaceStr(var STR:WideString;SearchText,NewText:WideString);
      Var
        FoundPos:Integer;
        NewStr:WideString;
      Begin
        NewStr:='';
        FoundPos:=Pos(SearchText,STR);
        While FoundPos>0 do
        Begin
          NewStr:=NewStr+Copy(Str,1,FoundPos-1)+NewText;
          Str:=Copy(Str,FoundPos+Length(SearchText),MaxInt);
          FoundPos:=Pos(SearchText,STR);
        end;
        Str:=NewStr+Str;
      end;
    Begin
      For I:=1 to Length(S) do
        If pos(S[I],#9#10#13)>0 then
          S[I]:=' ';
      ReplaceStr(S,'  ',' ');
    end;
  Begin
    Width:=CollectedWidth;
    Posit:=1;
    OldPosit:=-1;
    CleanString(S);
    While Posit<Length(S) do
    Begin
      Repeat
//      While (Width<=ScreenWidth) and (Posit<Length(S)) do
        Width:=Width+CharWidth(S,Posit);
      Until (Width > ScreenWidth) or (Posit>=Length(S));
      If Posit>=Length(S) then Break;
      Dec(Posit);
      //Тэкс, вот за этой буквой надо делать обрыв строки
      //если тут и без нас разрыв - просто едем дальше
      If S[Posit-1] = ' ' then
      Begin
        Width:=0;
        Continue;
      end;
      If S[Posit] = ' ' then
      Begin
        Inc(Posit);
        Width:=0;
        Continue;
      end;
      //Теперь посмотрим, что у нас тут за слово попало на обрыв
      WordPosit:=Posit-2;
      WordToBreake:=LastWord(S,WordPosit);

      //Тэкс, нам нужно оставить от этого слова MaxL букв
      MaxL:=Posit-WordPosit-1;

      TirPos:=Pos('-',WordToBreake);
      //Некоторые девайсы, типа REB1100, не знают, что строки можно рвать по тире
      //для них снабдим тире - пробелом
      if (TirPos<>0) then
        if (TirPos<=MaxL) then
        Begin
          Posit:=WordPosit+TirPos+1;
          Insert(' ',S,WordPosit+TirPos);
        end else
          Begin
            Posit:=WordPosit;
            Continue;
          end
      else
        Begin
      // Ну, раз тут без нашего участия никаких брыков нет - вкрячим брык сами...
          BrPos:=BreakPos(WordToBreake,MaxL);
          If BrPos<>0 then
          Begin
            Posit:=WordPosit+BrPos+Length(HyphStr);
            if SymbType(S[WordPosit+BrPos-1])=SpecSign then
              Insert(HyphStr,S,WordPosit+BrPos)
            else
              Insert(' ',S,WordPosit+BrPos)
          end else
          If OldPosit <> WordPosit then
            Posit:=WordPosit;
          Width:=0;
        end;
      OldPosit:=WordPosit;
    end;
    CollectedWidth:=Width;
    result:=S;
  end;
  
  //Порубает текст в элементе и возвратит длинну остатка - последней строки
  Procedure HyphElement(Elem:IXMLDOMNode;var CollectedWidth:Integer);
  const
    NODE_TEXT=3;
    NODE_ELEMENT=1;
  Var
    CHild:IXMLDOMNode;
  Begin
    CHild:=Elem.firstChild;
    while CHild<>Nil do
    Begin
      if Child.nodeType=NODE_TEXT then
      Begin
        if (EmphasisStack=0) and (BoldStack=0) then
          CurState:=normal
        else if (EmphasisStack>0) and (BoldStack>0) then
          CurState:=strongemphasis
        else if EmphasisStack>0 then
          CurState:=emphasis
        else if BoldStack>0 then
          CurState:=strong;
        Child.text:=HyphText(Child.text,CollectedWidth);
      end else if Child.nodeType=NODE_ELEMENT then
      Begin
        if Child.nodeName='strong' then
          Inc(BoldStack)
        else if Child.nodeName='emphasis' then
          inc(EmphasisStack);
        HyphElement(Child,CollectedWidth);
        if Child.nodeName='strong' then
          Dec(BoldStack)
        else if Child.nodeName='emphasis' then
          Dec(EmphasisStack);
      end;
      Child:=Child.nextSibling;
    end;
  end;
  
Begin
  StartWidth:=PrefixWidth;
  BoldStack:=0;
  EmphasisStack:=0;
  CurState:=normal;
  if MakeItPlain then
    P.text:=HyphText(P.text,StartWidth)
  else
    HyphElement(P,StartWidth);
end;


function TFB2Hyphenator.Get_hyphStr: OleVariant;
begin
  Result:=HyphStr;
end;

function TFB2Hyphenator.Get_plainOnly: WordBool;
begin
  Result:=MakeItPlain;
end;

function TFB2Hyphenator.Get_strPrefix: OleVariant;
begin
  Result:=Prefix;
end;

procedure TFB2Hyphenator.Set_hyphStr(Value: OleVariant);
begin
  HyphStr:=Value;
end;

procedure TFB2Hyphenator.Set_plainOnly(Value: WordBool);
begin
  MakeItPlain:=Value;
end;

procedure TFB2Hyphenator.Set_strPrefix(Value: OleVariant);
Var
  I:Integer;
begin
  Prefix:=Value;
  PrefixWidth:=0;
  I:=1;
  While I<=Length(Prefix) do
    PrefixWidth:=PrefixWidth+CharWidth(Prefix,I)
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFB2Hyphenator, Class_FB2Hyphenator,
    ciMultiInstance, tmApartment);
end.
