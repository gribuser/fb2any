library fb_2_rb;

uses
  ComServ,
  FB2_to_RB_TLB in 'FB2_to_RB_TLB.pas',
  fb_2_rb_plugin in 'fb_2_rb_plugin.pas' {FB2_2_RB_FBE_export: CoClass},
  fb_2_rb_dialog in 'fb_2_rb_dialog.pas' {ExportToRBDialog},
  hyph_control in '..\FB_hyph\hyph_control.pas',
  fb2_hyph_TLB in '..\FB_hyph\fb2_hyph_TLB.pas',
  fb2rb_engine in 'fb2rb_engine.pas',
  ProgressForm in 'ProgressForm.pas' {ScrolForm},
  fb2rb_dispatch in 'fb2rb_dispatch.pas' {FB2RBExport: CoClass},
  extractimages in '..\misk\extractimages.pas',
  exec_external in '..\misk\exec_external.pas',
  QuickExport in 'QuickExport.pas' {FB2AnyQuickExport: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
