unit QuickExport;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FB2_to_RB_TLB, StdVcl,fb2rb_engine;

type
  TFB2AnyQuickExport = class(TAutoObject, IFB2AnyQuickExport)
    Converter:IFB2RBExport;
  protected
    procedure Export(hWnd: Integer; filename: OleVariant;
      const document: IDispatch; appName: OleVariant); safecall;
    procedure Setup(hWnd: Integer; appName: OleVariant); safecall;
    { Protected declarations }
  end;

implementation

uses ComServ,fb_2_rb_dialog,Registry,Windows,fb2rb_dispatch;

procedure TFB2AnyQuickExport.Export(hWnd: Integer; filename: OleVariant;
  const document: IDispatch; appName: OleVariant);
Var
  S:String;
begin
  if Converter=Nil then
    Converter:=CoFB2RBExport.Create;
  Converter.LoadLastSettingsFromReg_(RegistryKey+'\quick\'+appName);
  Converter.SaveTo:=0;
  Converter.filename:=filename;
  Converter.Convert(document);
end;

procedure TFB2AnyQuickExport.Setup(hWnd: Integer; appName: OleVariant);
begin
  with TExportToRBDialog.CreateWithForeighnParent(hWnd,'\quick\'+appName) do
  Begin
    ShowModal;
    Free;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFB2AnyQuickExport, Class_FB2AnyQuickExport,
    ciMultiInstance, tmApartment);
end.
