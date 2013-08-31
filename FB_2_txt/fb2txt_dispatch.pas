unit fb2txt_dispatch;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_TXT_TLB, StdVcl, fb2txt_engine;

type
  TFB2TXTExport = class(TAutoObject, IFB2TXTExport)
  public
    procedure AfterConstruction; Override;
    procedure BeforeDestruction; override;
  protected
    function Get_Encoding: Integer; safecall;
    function Get_FixedWidth: Integer; safecall;
    function Get_Hyphenator: IDispatch; safecall;
    function Get_LineBr: OleVariant; safecall;
    function Get_ParaIndent: OleVariant; safecall;
    function Get_SkipDescr: WordBool; safecall;
    function Get_XSL: IDispatch; safecall;
    procedure Convert(const document: IDispatch; FileName: OleVariant);
      safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant;
      const document: IDispatch); safecall;
    procedure Set_Encoding(Value: Integer); safecall;
    procedure Set_FixedWidth(Value: Integer); safecall;
    procedure Set_Hyphenator(const Value: IDispatch); safecall;
    procedure Set_LineBr(Value: OleVariant); safecall;
    procedure Set_ParaIndent(Value: OleVariant); safecall;
    procedure Set_SkipDescr(Value: WordBool); safecall;
    procedure Set_XSL(const Value: IDispatch); safecall;
    function Get_IgnoreEmphasis: WordBool; safecall;
    function Get_IgnoreStrong: WordBool; safecall;
    procedure Set_IgnoreEmphasis(Value: WordBool); safecall;
    procedure Set_IgnoreStrong(Value: WordBool); safecall;
    { Protected declarations }
  private
    Converter:TTXTConverter;
  end;

implementation

uses ComServ,fb2_hyph_TLB,MSXML2_TLB,Dialogs,SysUtils;

procedure TFB2TXTExport.AfterConstruction;
Begin
  inherited AfterConstruction;
  Converter:=TTXTConverter.Create;
end;

procedure TFB2TXTExport.BeforeDestruction;
Begin
  inherited BeforeDestruction;
  Converter.Free;
end;


function TFB2TXTExport.Get_Encoding: Integer;
begin
  Result:=Converter.CodePage;
end;


function TFB2TXTExport.Get_FixedWidth: Integer;
begin
  Result:=Converter.TextWidth;
end;

function TFB2TXTExport.Get_Hyphenator: IDispatch;
begin
  Result:=Converter.HyphControler;
end;

function TFB2TXTExport.Get_LineBr: OleVariant;
begin
  Result:=Converter.BR;
end;

function TFB2TXTExport.Get_ParaIndent: OleVariant;
begin
  Result:=Converter.Indent;
end;

function TFB2TXTExport.Get_SkipDescr: WordBool;
begin
  Result:=Converter.SkipDescr;
end;

function TFB2TXTExport.Get_XSL: IDispatch;
begin
  Result:=Converter.XSL;
end;

procedure TFB2TXTExport.Convert(const document: IDispatch;
  FileName: OleVariant);
begin
  Converter.Convert(document,FileName);
end;

procedure TFB2TXTExport.ConvertInteractive(hWnd: Integer;
  filename: OleVariant; const document: IDispatch);
Var
  ExpI:IFBEExportPlugin;
  FN:String;
  XDoc:IXMLDOMDocument2;
begin
  FN:=filename;
  if Document=Nil then
  Begin
    With TOpenDialog.Create(Nil) do try
      Filter:='FictionBook 2.0 documents (*.fb2)|*.fb2|All files (*.*)|*.*';
      If not Execute then Exit;
      XDoc:=CoFreeThreadedDOMDocument40.Create;
      if not XDoc.load(FileName) then
        Raise Exception.Create('Opening fb2 file:'#10+XDoc.parseError.reason);
      FN:=FileName;
    Finally
      Free;
    end;
  end else
    if document.QueryInterface(IID_IXMLDOMDocument2,XDoc) <> S_OK then
      Exception.Create('Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2');

  ExpI:=CoFB2_to_TXT_.Create;
  ExpI.Export(hWnd,FN,XDoc);
end;

procedure TFB2TXTExport.Set_Encoding(Value: Integer);
begin
  Converter.CodePage:=Value;
end;


procedure TFB2TXTExport.Set_FixedWidth(Value: Integer);
begin
  Converter.TextWidth:=Value;
end;

procedure TFB2TXTExport.Set_Hyphenator(const Value: IDispatch);
Var
  HC:IFB2Hyphenator;
begin
  if Value.QueryInterface(IID_IFB2Hyphenator,HC) <> S_OK then
    Exception.Create('Invalid hyphenator interface on enter, should be called with IFB2Hyphenator');
  Converter.HyphControler:=HC;
end;

procedure TFB2TXTExport.Set_LineBr(Value: OleVariant);
begin
  Converter.BR:=Value;
end;

procedure TFB2TXTExport.Set_ParaIndent(Value: OleVariant);
begin
  Converter.Indent:=Value;
end;

procedure TFB2TXTExport.Set_SkipDescr(Value: WordBool);
begin
  Converter.SkipDescr:=Value;
end;

procedure TFB2TXTExport.Set_XSL(const Value: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
begin
  if Value.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
    Exception.Create('Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2')
  else
    Converter.XSL:=OutVar;
end;

function TFB2TXTExport.Get_IgnoreEmphasis: WordBool;
begin
  result:=Converter.IgnoreItalic;
end;

function TFB2TXTExport.Get_IgnoreStrong: WordBool;
begin
  result:=Converter.IgnoreBold;
end;

procedure TFB2TXTExport.Set_IgnoreEmphasis(Value: WordBool);
begin
  Converter.IgnoreItalic:=Value;
end;

procedure TFB2TXTExport.Set_IgnoreStrong(Value: WordBool);
begin
  Converter.IgnoreBold:=Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFB2TXTExport, Class_FB2TXTExport,
    ciMultiInstance, tmApartment);
end.
