unit TestHyphWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MSXml2_TLB, StdCtrls,fb2_hyph_TLB, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    RichEdit1: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Hypher:IFB2Hyphenator;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  XD1:TFreeThreadedDOMDocument40;
Begin
  XD1:=TFreeThreadedDOMDocument40.Create(Self);
  XD1.DefaultInterface.preserveWhiteSpace:=True;
  XD1.DefaultInterface.load('C:\Temp\123.fb2');
  Hypher.currentFontSize:=ComboBox3.Text;
  Hypher.Hyphenate(XD1.DefaultInterface);
  RichEdit1.Text:=XD1.DefaultInterface.xml;
  XD1.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  XD2:TFreeThreadedDOMDocument40;
begin
  XD2:=TFreeThreadedDOMDocument40.Create(Self);
  XD2.DefaultInterface.load('F:\More\FB_2_any\FB_hyph\reb.xml');
  Hypher:=CoFB2Hyphenator.Create;
  Hypher.deviceDescr:=XD2.DefaultInterface;
  ComboBox1.Items.Text:=Hypher.deviceSizeList;
  ComboBox1.ItemIndex:=0;
  ComboBox2.Items.Text:=Hypher.fontList;
  ComboBox2.ItemIndex:=0;
  ComboBox1Change(Self);
  ComboBox2Change(self);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Hypher.currentDeviceSize:=ComboBox1.Text;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  Hypher.currentFont:=ComboBox2.Text;
  ComboBox3.Items.Text:=Hypher.fontSizeList;
  ComboBox3.ItemIndex:=0;
end;

end.
