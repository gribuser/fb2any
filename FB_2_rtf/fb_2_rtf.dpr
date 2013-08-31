library fb_2_rtf;

uses
  ComServ,
  FB2_to_RTF_TLB in 'FB2_to_RTF_TLB.pas',
  ExtDlgs,
  plugin in 'plugin.pas' {FB2_to_rtf: CoClass},
  save_rtf_dialog in 'save_rtf_dialog.pas',
  fb2rtf_engine in 'fb2rtf_engine.pas',
  fb2rtf_dispatch in 'fb2rtf_dispatch.pas' {FB2RTFExport: CoClass},
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
