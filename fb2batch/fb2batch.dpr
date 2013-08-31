program fb2batch;

uses
  Forms,
  main_wnd in 'main_wnd.pas' {Form1},
  FB2_to_TXT_TLB in '..\FB_2_txt\FB2_to_TXT_TLB.pas',
  fb2batch_TLB in 'fb2batch_TLB.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FB2Batch';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
