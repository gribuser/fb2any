unit QuickExport;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_RTF_TLB, StdVcl,fb2rtf_engine;

type
  TFB2AnyQuickExport = class(TAutoObject, IFB2AnyQuickExport)
    procedure AfterConstruction; Override;
    procedure BeforeDestruction; override;
  protected
    Converter:TRTFConverter;
    SettingsLoaded:Boolean;
    procedure Export(hWnd: Integer; filename: OleVariant;
      const document: IDispatch; appName: OleVariant); safecall;
    procedure Setup(hWnd: Integer; appName: OleVariant); safecall;
    { Protected declarations }
  end;

implementation

uses ComServ,QuickExportSetup,Registry,Windows;
procedure TFB2AnyQuickExport.AfterConstruction;
Begin
  inherited AfterConstruction;
  Converter:=TRTFConverter.Create;
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
begin
  if not SettingsLoaded then
  begin
    Reg:=TRegistry.Create(KEY_READ);
    Try
      if Reg.OpenKeyReadOnly(QuickSetupKey+appName) then
      Begin
        Converter.SkipImages:=Reg.ReadBool('Skip images');
        Converter.SkipCover:=Reg.ReadBool('Skip cover');
        Converter.SkipDescr:=Reg.ReadBool('Skip description');
        Converter.EncCompat:=Reg.ReadBool('Encoding compat');
        Converter.ImgCompat:=Reg.ReadBool('Image compat');
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
