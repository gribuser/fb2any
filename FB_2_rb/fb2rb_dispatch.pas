unit fb2rb_dispatch;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_RB_TLB, StdVcl,fb2rb_engine,fb2_hyph_TLB,MSXML2_TLB;

type
  TFB2RBExport = class(TAutoObject, IFB2RBExport)
  protected
    function Get_PageBreaksForLevels: Integer; safecall;
    function Get_ShortTOCLines: WordBool; safecall;
    function Get_SkipCover: WordBool; safecall;
    function Get_SkipDescr: WordBool; safecall;
    function Get_SkipImages: WordBool; safecall;
    function Get_TOCLevels: Integer; safecall;
    function Get_TransLitTitle: WordBool; safecall;
    procedure Set_PageBreaksForLevels(Value: Integer); safecall;
    procedure Set_ShortTOCLines(Value: WordBool); safecall;
    procedure Set_SkipCover(Value: WordBool); safecall;
    procedure Set_SkipDescr(Value: WordBool); safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    procedure Set_TOCLevels(Value: Integer); safecall;
    procedure Set_TransLitTitle(Value: WordBool); safecall;
    function Get_HOwner: Integer; safecall;
    function Get_Hyphenator: IDispatch; safecall;
    function Get_RBMakePath: OleVariant; safecall;
    function Get_SaveTo: OleVariant; safecall;
    function Get_XSL: IDispatch; safecall;
    procedure Set_HOwner(Value: Integer); safecall;
    procedure Set_Hyphenator(const Value: IDispatch); safecall;
    procedure Set_RBMakePath(Value: OleVariant); safecall;
    procedure Set_SaveTo(Value: OleVariant); safecall;
    procedure Set_XSL(const Value: IDispatch); safecall;
    procedure Convert(const Document: IDispatch); safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant;
      const document: IDispatch); safecall;
    function Get_FileName: OleVariant; safecall;
    procedure Set_FileName(Value: OleVariant); safecall;
    procedure LoadLastSettingsFromReg; safecall;
    procedure LoadLastSettingsFromReg_(key: OleVariant); safecall;
    procedure LoadSettingsFromRegEngine(key: String); safecall;
    { Protected declarations }
  public
    Params:TFB2RBConverterSettings;
    ModulePath:String;
    procedure AfterConstruction;override;
  end;
{DEFINE DEBUG}

implementation

uses ComServ,Windows,SysUtils,fb_2_rb_dialog,Registry,Classes,Dialogs;
procedure TFB2RBExport.AfterConstruction;
Begin
  FillChar(Params,SizeOf(Params),#0);
  Params.TOCLevel:=2;
  Params.PageBreakLeve:=2;
  Params.Target:=SaveToFile;
  SetLength(ModulePath,2000);
  GetModuleFileName(HInstance,@ModulePath[1],1999);
  SetLength(ModulePath,Pos(#0,ModulePath)-1);
  ModulePath:=IncludeTrailingPathDelimiter(ExtractFileDir(ModulePath));
  Params.RBMakePath:=ModulePath+'rbmake.exe';
end;
function TFB2RBExport.Get_PageBreaksForLevels: Integer;
begin
  Result:=Params.PageBreakLeve;
end;

function TFB2RBExport.Get_ShortTOCLines: WordBool;
begin
  Result:=Params.SHortenTOCLines;
end;

function TFB2RBExport.Get_SkipCover: WordBool;
begin
  Result:=Params.SkipCOver;
end;

function TFB2RBExport.Get_SkipDescr: WordBool;
begin
  Result:=Params.SKipDescr;
end;

function TFB2RBExport.Get_SkipImages: WordBool;
begin
  Result:=Params.SkipImages;
end;

function TFB2RBExport.Get_TOCLevels: Integer;
begin
  Result:=Params.TOCLevel;
end;

function TFB2RBExport.Get_TransLitTitle: WordBool;
begin
  Result:=Params.TransLitTitle;
end;

procedure TFB2RBExport.Set_PageBreaksForLevels(Value: Integer);
begin
  Params.PageBreakLeve:=Value;
end;

procedure TFB2RBExport.Set_ShortTOCLines(Value: WordBool);
begin
  Params.SHortenTOCLines:=Value;
end;

procedure TFB2RBExport.Set_SkipCover(Value: WordBool);
begin
  Params.SkipCOver:=Value;
end;

procedure TFB2RBExport.Set_SkipDescr(Value: WordBool);
begin
  Params.SKipDescr:=Value;
end;

procedure TFB2RBExport.Set_SkipImages(Value: WordBool);
begin
  Params.SkipImages:=Value;
end;

procedure TFB2RBExport.Set_TOCLevels(Value: Integer);
begin
  Params.TOCLevel:=Value;
end;

procedure TFB2RBExport.Set_TransLitTitle(Value: WordBool);
begin
  Params.TransLitTitle:=Value;
end;

function TFB2RBExport.Get_HOwner: Integer;
begin
  Result:=Params.HParent;
end;

function TFB2RBExport.Get_Hyphenator: IDispatch;
begin
  Result:=Params.HyphControler;
end;

function TFB2RBExport.Get_RBMakePath: OleVariant;
begin
  Result:=Params.RBMakePath;
end;

function TFB2RBExport.Get_SaveTo: OleVariant;
begin
  Result:=Params.Target;
end;

function TFB2RBExport.Get_XSL: IDispatch;
begin
  Result:=Params.XSL;
end;

procedure TFB2RBExport.Set_HOwner(Value: Integer);
begin
  Params.HParent:=Value;
end;

procedure TFB2RBExport.Set_Hyphenator(const Value: IDispatch);
Var
  HC:IFB2Hyphenator;
begin
  if Value.QueryInterface(IID_IFB2Hyphenator,HC) <> S_OK then
    Exception.Create('Invalid hyphenator interface on enter, should be called with IFB2Hyphenator');
  Params.HyphControler:=HC;
end;

procedure TFB2RBExport.Set_RBMakePath(Value: OleVariant);
begin
  Params.RBMakePath:=Value;
end;

procedure TFB2RBExport.Set_SaveTo(Value: OleVariant);
begin
  Params.Target:=Value;
end;

procedure TFB2RBExport.Set_XSL(const Value: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
begin
  if Value.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
    MessageBox(0,'Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2','Error',MB_OK or MB_ICONERROR)
  else
    Params.XSL:=OutVar;
end;

procedure TFB2RBExport.Convert(const Document: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
begin
  if Document=Nil then
    MessageBox(0,'NILL document value, please provide valid IXMLDOMDocument2 on input.','Error',mb_ok or MB_ICONERROR)
  else
    try

      if Params.XSL=Nil then
      Begin
        Params.XSL:=CoFreeThreadedDOMDocument40.Create;
        Params.XSL.load(ModulePath+'FB2_2_rb.xsl');
       end;
      if document.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK then
        MessageBox(0,'Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2','Error',MB_OK or MB_ICONERROR)
      else Begin
        Params.DOM:=IXMLDOMDocument2(OutVar);
        fb2rb_engine.TransFormToReb(Params);
      end;
    except
      on E: Exception do MessageBox(0,PChar(E.Message),'Error',mb_ok or MB_ICONERROR);
    end
end;

procedure TFB2RBExport.ConvertInteractive(hWnd: Integer;
  filename: OleVariant; const document: IDispatch);
Var
  OutVar:IXMLDOMDocument2;
  B:Integer;
begin
  Try
    if (document<>Nil) and (document.QueryInterface(IID_IXMLDOMDocument2,OutVar) <> S_OK) then
      MessageBox(hWnd,'Invalid IDispatch interface on enter, should be called with IXMLDOMDocument2','Error',MB_OK or MB_ICONERROR)
    else
      ExportDOM(hWnd,OutVar,filename);
  except
    on E: Exception do MessageBox(0,PChar(E.Message),'Error',mb_ok or MB_ICONERROR);
  end
end;

function TFB2RBExport.Get_FileName: OleVariant;
begin
  Result:=Params.FileName;
end;

procedure TFB2RBExport.Set_FileName(Value: OleVariant);
begin
  Params.FileName:=Value;
end;

procedure TFB2RBExport.LoadLastSettingsFromReg;
Begin
  LoadSettingsFromRegEngine(RegistryKey);
end;

procedure TFB2RBExport.LoadLastSettingsFromReg_(key: OleVariant);
Begin
  LoadSettingsFromRegEngine(Key);
end;
procedure TFB2RBExport.LoadSettingsFromRegEngine;
Var
  Reg:TRegistry;
  SL:TStringList;
  DOM:IXMLDOMDocument2;
Begin
  Try
    Reg:=TRegistry.Create;
    Try
      if Reg.OpenKeyReadOnly(Key) then
    Begin
      Params.SkipImages:=Reg.ReadBool('remove images');
      Params.SKipDescr:=Reg.ReadBool('no description');
      Params.SkipCOver:=Reg.ReadBool('skip coverpage');
      Params.TransLitTitle:=Reg.ReadBool('translit author');
      Params.SHortenTOCLines:=Reg.ReadBool('short section titles');
      Params.TOCLevel:=Reg.ReadInteger('TOC deepness');
      Params.PageBreakLeve:=Reg.ReadInteger('Page breaks level');
      if Reg.ReadBool('save to disk') then
        Params.Target:=SaveToFile
      else if Reg.ReadInteger('REB media')=0 then
        Params.Target:=storeOnRebInt
      else
        Params.Target:=StoreOnRebSM;
      If Reg.ReadInteger('font name')<>0 then
      Begin
        SL:=TStringList.Create;
        Try
          Params.HyphControler:=CoFB2Hyphenator.Create;
          DOM:=CoFreeThreadedDOMDocument40.Create;
          DOM.preserveWhiteSpace:=True;
          DOM.load(ModulePath+'reb.xml');
          Params.HyphControler.deviceDescr:=DOM;
          SL.Text:=Params.HyphControler.deviceSizeList;
          Params.HyphControler.currentDeviceSize:=SL[Reg.ReadInteger('device orientation')];
          SL.Text:=Params.HyphControler.fontList;
          Params.HyphControler.currentFont:=SL[Reg.ReadInteger('font name')-1];
          SL.Text:=Params.HyphControler.fontSizeList;
          Params.HyphControler.currentFontSize:=SL[Reg.ReadInteger('font size')];
        finally
          SL.Free;
        end;
      end;
    end;
    FInally
      Reg.Free;
    end;
  except
  end;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TFB2RBExport, Class_FB2RBExport,
    ciMultiInstance, tmApartment);
end.
