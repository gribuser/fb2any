program TestHyph;

uses
  Forms,
  TestHyphWnd in 'TestHyphWnd.pas' {Form1},
  fb2_hyph_TLB in 'fb2_hyph_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
