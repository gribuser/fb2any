library fb_2_iSilo;

uses
  ComServ,
  FB2_to_iSilo_TLB in 'FB2_to_iSilo_TLB.pas',
  fb2iSilo_plugin in 'fb2iSilo_plugin.pas' {FB2iSiloPlugin: CoClass},
  save_iSilo_dialog in 'save_iSilo_dialog.pas',
  fb2iSilo_engine in 'fb2iSilo_engine.pas',
  extractimages in '..\misk\extractimages.pas',
  exec_external in '..\misk\exec_external.pas',
  fb2iSilo_dispatch in 'fb2iSilo_dispatch.pas' {FB2iSiloExport: CoClass},
  QuickExport in 'QuickExport.pas' {FB2AnyQuickExport: CoClass},
  QuickExportSetup in 'QuickExportSetup.pas' {QuickExportSetupForm};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
