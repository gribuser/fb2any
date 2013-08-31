unit ProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls;

type
  TScrolForm = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    ParentHandle:THandle;
    procedure CreateParams(var Params: TCreateParams); override;
    Constructor CreateParented(AParent:THandle);
    { Public declarations }
  end;

var
  ScrolForm: TScrolForm;

implementation

{$R *.dfm}
procedure TScrolForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := ParentHandle;
end;
Constructor TScrolForm.CreateParented(AParent:THandle);
Begin
  ParentHandle:=AParent;
  create(nil);
end;

end.
