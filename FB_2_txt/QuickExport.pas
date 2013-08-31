unit QuickExport;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_TXT_TLB, StdVcl,fb2txt_engine;

type
  TFB2AnyQuickExport = class(TAutoObject, IFB2AnyQuickExport)
  public
    procedure AfterConstruction; Override;
    procedure BeforeDestruction; override;
  protected
    Converter:TTXTConverter;
    SettingsLoaded:Boolean;
    procedure Export(hWnd: Integer; filename: OleVariant;
      const document: IDispatch; appName: OleVariant); safecall;
    procedure Setup(hWnd: Integer; appName: OleVariant); safecall;
    { Protected declarations }
  end;

implementation

uses ComServ,Windows,QuickExportSetup, Forms,Registry,MSXML2_TLB,fb2_hyph_TLB,
SysUtils,save_txt_dialog;

procedure TFB2AnyQuickExport.AfterConstruction;
Begin
  inherited AfterConstruction;
  Converter:=TTXTConverter.Create;
  SettingsLoaded:=False;
end;

procedure TFB2AnyQuickExport.BeforeDestruction;
Begin
  inherited BeforeDestruction;
  Converter.Free;
end;

procedure TFB2AnyQuickExport.Export(hWnd: Integer; filename: OleVariant;
  const document: IDispatch; appName: OleVariant);
Var
  Reg:TRegistry;
  HyphDescrDOM:IXMLDOMDocument2;
begin
  if not SettingsLoaded then
  begin
    Reg:=TRegistry.Create(KEY_READ);
    Try
      if Reg.OpenKeyReadOnly(QuickSetupKey+appName) then
      Begin
        if Reg.ReadBool('Word wrap') then
          Converter.TextWidth:=Reg.ReadInteger('Text width')
        else
          Converter.TextWidth:=-1;
        Converter.SkipDescr:=Reg.ReadBool('Skip description');
        if Reg.ReadBool('Do indent para') then
          Converter.Indent:=Reg.ReadString('Indent text')
        else
          Converter.Indent:='';
        if Reg.ReadBool('Hyphenate') then
        Begin
          Converter.HyphControler:=CoFB2Hyphenator.Create;
          HyphDescrDOM:=CoFreeThreadedDOMDocument40.Create;
          HyphDescrDOM.preserveWhiteSpace:=True;
          HyphDescrDOM.loadXML('<device name="Fixed width text"><displays><display-mode name="Default" width="'+IntToStr(Reg.ReadInteger('Text width'))+'"/></displays><fonts><font name="Default"><font-size name="Default"><normal default-width="1"/><strong default-width="1"/><emphasis default-width="1"/><strongemphasis default-width="1"/></font-size></font></fonts></device>');
          Converter.HyphControler.deviceDescr:=HyphDescrDOM;
          Converter.HyphControler.currentDeviceSize:='Default';
          Converter.HyphControler.currentFont:='Default';
          Converter.HyphControler.currentFontSize:='Default';
          Converter.HyphControler.strPrefix:=Converter.Indent;
        end;
        Converter.CodePage:=Reg.ReadInteger('File codepage');
        Converter.BR:=BRTypes[Reg.ReadInteger('Line breaks type')+1].Chars;
        Converter.IgnoreBold:=Reg.ReadBool('Ignore strong');
        Converter.IgnoreItalic:=Reg.ReadBool('Ignore emphasis');
      end;
      SettingsLoaded:=True;
    Finally
      Reg.Free;
    end;
  end;
  Converter.Convert(document,filename);
end;

procedure TFB2AnyQuickExport.Setup(hWnd: Integer; appName: OleVariant);
begin
  with TQuickExportSetupForm.CreateWithForeighnParent(hWnd,appName) do
  Begin
    ShowModal;
    Free;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFB2AnyQuickExport, Class_FB2AnyQuickExport,
    ciMultiInstance, tmApartment);
end.
