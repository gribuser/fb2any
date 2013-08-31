library fb_2_txt;

uses
  ComServ,
  FB2_to_TXT_TLB in 'FB2_to_TXT_TLB.pas',
  fbeplugin in 'fbeplugin.pas' {FB2_to_TXT: CoClass},
  save_txt_dialog in 'save_txt_dialog.pas',
  fb2txt_engine in 'fb2txt_engine.pas',
  MSXML2_TLB in '..\..\..\Program Files\Borland\Delphi6\Imports\MSXML2_TLB.pas',
  fb2_hyph_TLB in '..\FB_hyph\fb2_hyph_TLB.pas',
  fb2txt_dispatch in 'fb2txt_dispatch.pas' {FB2TXTExport: CoClass},
  EncodingWarn in 'EncodingWarn.pas' {EncWarn},
  QuickExport in 'QuickExport.pas' {FB2AnyQuickExport: CoClass},
  QuickExportSetup in 'QuickExportSetup.pas' {QuickExportSetupForm};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{R *.RES}
{$R Icon.res}

begin
end.
