unit fb2iSilo_dispatch;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_iSilo_TLB, StdVcl,fb2iSilo_engine,MSXML2_TLB,Windows;

type
  TFB2iSiloExport = class(TAutoObject, IFB2iSiloExport)
    procedure BeforeDestruction; override;
  private
    ConverterVar:TFB2iSiloConverter;
    Function GetConverter:TFB2iSiloConverter;
  protected
    procedure AfterConstruction; Override;
    function Get_SkipImages: WordBool; safecall;
    function Get_TOCLevels: Integer; safecall;
    function Get_XSL: IDispatch; safecall;
    procedure Convert(const document: IDispatch; filename: OleVariant);
      safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant;
      const document: IDispatch); safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    procedure Set_TOCLevels(Value: Integer); safecall;
    procedure Set_XSL(const Value: IDispatch); safecall;
    function Get_IXLXSL: IDispatch; safecall;
    procedure Set_IXLXSL(const Value: IDispatch); safecall;
    property Converter:TFB2iSiloConverter read GetConverter write ConverterVar;
    { Protected declarations }
  end;

implementation

uses ComServ,SysUtils,save_iSilo_dialog,Dialogs;

procedure TFB2iSiloExport.BeforeDestruction;
Begin
  inherited BeforeDestruction;
  if  ConverterVar<>Nil then
    ConverterVar.Free;
end;

Function TFB2iSiloExport.GetConverter;
Begin
  if ConverterVar=Nil then
    ConverterVar:=TFB2iSiloConverter.Create;
  Result:=ConverterVar;
end;

procedure TFB2iSiloExport.AfterConstruction;
Begin
  Converter:=Nil;
end;

function TFB2iSiloExport.Get_SkipImages: WordBool;
begin
  Result:=Converter.SkipImg;
end;

function TFB2iSiloExport.Get_TOCLevels: Integer;
begin
  Result:=Converter.TocDeep;
end;

function TFB2iSiloExport.Get_XSL: IDispatch;
begin
  Result:=Converter.DocumentXSL;
end;

procedure TFB2iSiloExport.Convert(const document: IDispatch;
  filename: OleVariant);
Var
  DOM:IXMLDOMDocument2;
begin
  if document.QueryInterface(IID_IXMLDOMDocument2,DOM) <> S_OK then
    Raise Exception.Create('Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2');
  Converter.Convert(DOM,filename);
end;

procedure TFB2iSiloExport.ConvertInteractive(hWnd: Integer;
  filename: OleVariant; const document: IDispatch);
Var
  DOM:IXMLDOMDocument2;
  DLG:TOpenPictureDialog;
  FN:String;
begin
  FN:=filename;
  if Document=Nil then
  With TOpenDialog.Create(Nil) do try
    Filter:='FictionBook 2.0 documents (*.fb2)|*.fb2|All files (*.*)|*.*';
    If not Execute then Exit;
    DOM:=CoFreeThreadedDOMDocument40.Create;
    if not DOM.load(FileName) then
      Raise Exception.Create('Opening fb2 file:'#10+DOM.parseError.reason);
    FN:=FileName;
  Finally
    Free;
  end else
    if document.QueryInterface(IID_IXMLDOMDocument2,DOM) <> S_OK then
      Raise Exception.Create('Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2');
  try
    DLG:=TOpenPictureDialog.Create(Nil);
    if FN<>'' then
      DLG.FileName:=copy(FN,1,Length(FN)-Length(ExtractFileExt(FN)))+'.pdb';
    with DLG do
    Begin
      if Execute then
        ExportDOM(DOM,DLG.FileName,DLG.TocDepth,DLG.DoSkipImages);
      Free;
    end;
  except
    on E: Exception do MessageBox(hWnd,PChar(E.Message),'Error',MB_OK or MB_ICONERROR);
  end;
end;

procedure TFB2iSiloExport.Set_SkipImages(Value: WordBool);
begin
  Converter.SkipImg:=Value;
end;

procedure TFB2iSiloExport.Set_TOCLevels(Value: Integer);
begin
  Converter.TocDeep:=Value;
end;

procedure TFB2iSiloExport.Set_XSL(const Value: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
begin
  if Value.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
    MessageBox(0,'Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2','Error',MB_OK or MB_ICONERROR)
  else
    Converter.DocumentXSL:=OutVar;
end;

function TFB2iSiloExport.Get_IXLXSL: IDispatch;
begin
  Result:=Converter.IXLXSL;
end;

procedure TFB2iSiloExport.Set_IXLXSL(const Value: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
begin
  if Value.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
    MessageBox(0,'Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2','Error',MB_OK or MB_ICONERROR)
  else
    Converter.IXLXSL:=OutVar;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFB2iSiloExport, CLASS_FB2iSiloExport,
    ciMultiInstance, tmApartment);
end.
