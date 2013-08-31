unit EncodingWarn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEncWarn = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowModal:Integer;override;
  end;

var
  EncWarn: TEncWarn;

implementation
uses Registry,save_txt_dialog;
{$R *.dfm}
function TEncWarn.ShowModal;
Var
  Reg:TRegistry;
Begin
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Try
      if Reg.OpenKeyReadOnly(RegistryKey) and
        Reg.ValueExists('No encoding warning') and
        Reg.ReadBool('No encoding warning') then
          exit;
      Inherited ShowModal;
    Finally
      Reg.Free;
      Free;
    end;
  Except
  end;
end;

procedure TEncWarn.Button1Click(Sender: TObject);
Var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create(KEY_ALL_ACCESS);
  Try
    if Reg.OpenKey(RegistryKey,True) then
      Reg.WriteBool('No encoding warning',CheckBox1.Checked);
  Finally
    Reg.Free;
  end;
end;

end.
