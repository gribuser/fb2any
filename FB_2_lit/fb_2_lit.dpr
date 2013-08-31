library fb_2_lit;

uses
  ComServ,
  FB2_to_LIT_TLB in 'FB2_to_LIT_TLB.pas',
  fb2lit_plugin in 'fb2lit_plugin.pas' {FBELitExportPlugin: CoClass},
  LITGen_TLB in '..\..\..\Program Files\Borland\Delphi6\Imports\LITGen_TLB.pas',
  fb2lit_engine in 'fb2lit_engine.pas',
  save_lit_dialog in 'save_lit_dialog.pas',
  fb2lit_dispatch in 'fb2lit_dispatch.pas' {FB2LITExport: CoClass},
  QuickExport in 'QuickExport.pas' {FB2AnyQuickExport: CoClass},
  QuickExportSetup in 'QuickExportSetup.pas' {QuickExportSetupForm},
  MSXML2_TLB in '..\..\..\Program Files\Borland\Delphi6\Imports\MSXML2_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
