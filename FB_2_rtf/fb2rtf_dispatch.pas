unit fb2rtf_dispatch;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_RTF_TLB, fb2rtf_engine,StdVcl;

type
  TFB2RTFExport = class(TAutoObject, IFB2RTFExport)
  protected
    procedure AfterConstruction; Override;
    function Get_SkipDescr: WordBool; safecall;
    function Get_SkipImages: WordBool; safecall;
    procedure Set_SkipDescr(Value: WordBool); safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    function Get_ImagesToBMP: WordBool; safecall;
    function Get_EncOptimise: WordBool; safecall;
    procedure Set_ImagesToBMP(Value: WordBool); safecall;
    procedure Set_EncOptimise(Value: WordBool); safecall;
    procedure AddXSLParameter(baseName, parameter, namespaceURI: OleVariant);
      safecall;
    procedure Convert(const Document: IDispatch; FileName: OleVariant);
      safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant;
      const Document: IDispatch); safecall;
    function Get_SkipCover: WordBool; safecall;
    procedure Set_SkipCover(Value: WordBool); safecall;
    { Protected declarations }
  private
    Converter:TRTFConverter;
  end;

implementation

uses ComServ,save_rtf_dialog,SysUtils,MSXML2_TLB,Dialogs;
procedure TFB2RTFExport.AfterConstruction;
Begin
  Converter:=TRTFConverter.Create;
end;

function TFB2RTFExport.Get_SkipDescr: WordBool;
begin
  Result:=Converter.SkipDescr;
end;

function TFB2RTFExport.Get_SkipImages: WordBool;
begin
  Result:=Converter.SkipImages;
end;

procedure TFB2RTFExport.Set_SkipDescr(Value: WordBool);
begin
  Converter.SkipDescr:=Value;
end;

procedure TFB2RTFExport.Set_SkipImages(Value: WordBool);
begin
  Converter.SkipImages:=Value;
end;

function TFB2RTFExport.Get_ImagesToBMP: WordBool;
begin
  Result:=Converter.ImgCompat;
end;

function TFB2RTFExport.Get_EncOptimise: WordBool;
begin
  Result:=Converter.EncCompat;
end;

procedure TFB2RTFExport.Set_ImagesToBMP(Value: WordBool);
begin
  Converter.ImgCompat:=Value;
end;

procedure TFB2RTFExport.Set_EncOptimise(Value: WordBool);
begin
  Converter.EncCompat:=Value;
end;

procedure TFB2RTFExport.AddXSLParameter(baseName, parameter,
  namespaceURI: OleVariant);
begin
  Converter.Processor.addParameter(baseName, parameter, namespaceURI);
end;

procedure TFB2RTFExport.Convert(const Document: IDispatch;
  FileName: OleVariant);
begin
  Converter.Convert(Document,FileName);
end;

procedure TFB2RTFExport.ConvertInteractive(hWnd: Integer;
  filename: OleVariant; const Document: IDispatch);
Var
  DLG:TOpenPictureDialog;
  XDoc:IXMLDOMDocument2;
  FN:String;
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
  end else XDoc:=IXMLDOMDocument2(Document);
  DLG:=TOpenPictureDialog.Create(Nil);
  Try
    if FN<>'' then
      DLG.FileName:=copy(FN,1,Length(FN)-Length(ExtractFileExt(FN)))+'.rtf';
    if DLG.Execute then
      ExportDOM(hWnd,XDoc,DLG.FileName, DLG.DoSkipImages, DLG.DoSkipCover, DLG.DoSkipDescr, DLG.DoEncCompat, DLG.DoImgCompat);
  Finally
    DLG.Free;
  end;
end;

function TFB2RTFExport.Get_SkipCover: WordBool;
begin
  result:=Converter.SkipCover;
end;

procedure TFB2RTFExport.Set_SkipCover(Value: WordBool);
begin
  Converter.SkipCover:=Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFB2RTFExport, Class_FB2RTFExport,
    ciMultiInstance, tmApartment);
end.
