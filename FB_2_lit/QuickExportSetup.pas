unit QuickExportSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,save_lit_dialog;

type
  TQuickExportSetupForm = class(TForm)
    SkipImages: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    TOCDepthEdit: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WidthEditChange(Sender: TObject);
  private
    { Private declarations }
    ParentHandle:THandle;
    Key:String;
  public
    { Public declarations }
    constructor CreateWithForeighnParent(AParent:THandle;AKey:String);
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  QuickExportSetupForm: TQuickExportSetupForm;
const
  QuickSetupKey=RegistryKey+'\quick\';

implementation
uses Registry;
{$R *.dfm}

constructor TQuickExportSetupForm.CreateWithForeighnParent;
Begin
  ParentHandle:=AParent;
  Key:=QuickSetupKey+AKey;
  create(Nil);
end;
procedure TQuickExportSetupForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := ParentHandle;
end;

procedure TQuickExportSetupForm.FormCreate(Sender: TObject);
Var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Try
      if Reg.OpenKeyReadOnly(Key) then
      Begin
        SkipImages.Checked:=Reg.ReadBool('Skip images');
        TOCDepthEdit.Text:=IntToStr(Reg.ReadInteger('TOC deepness'));
      end;
    Finally
      Reg.Free;
    end;
  Except
  end;
end;

procedure TQuickExportSetupForm.Button1Click(Sender: TObject);
Var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create(KEY_ALL_ACCESS);
  Try
    if Reg.OpenKey(Key,True) then
    Begin
      Reg.WriteBool('Skip images',SkipImages.Checked);
      Reg.WriteInteger('TOC deepness',StrToInt(TOCDepthEdit.Text));
    end;
  Finally
    Reg.Free;
  end;

end;

procedure TQuickExportSetupForm.WidthEditChange(Sender: TObject);
begin
  try
    StrToInt(TOCDepthEdit.Text);
  except
    TOCDepthEdit.Text:='4';
  end;
end;

end.
