unit QuickExportSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,save_rtf_dialog;

type
  TQuickExportSetupForm = class(TForm)
    SkipImages: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    SkipCover: TCheckBox;
    SkipDescr: TCheckBox;
    EncCompat: TCheckBox;
    ImgCompat: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SkipImagesClick(Sender: TObject);
    procedure SkipImagesKeyPress(Sender: TObject; var Key: Char);
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
        SkipCover.Checked:=Reg.ReadBool('Skip cover');
        SkipDescr.Checked:=Reg.ReadBool('Skip description');
        EncCompat.Checked:=Reg.ReadBool('Encoding compat');
        ImgCompat.Checked:=Reg.ReadBool('Image compat');
        SkipImagesClick(Nil);
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
      Reg.WriteBool('Skip cover',SkipCover.Checked);
      Reg.WriteBool('Skip description',SkipDescr.Checked);
      Reg.WriteBool('Encoding compat',EncCompat.Checked);
      Reg.WriteBool('Image compat',ImgCompat.Checked);
    end;
  Finally
    Reg.Free;
  end;

end;

procedure TQuickExportSetupForm.SkipImagesClick(Sender: TObject);
begin
  SkipCover.Enabled:=not SkipImages.Checked;
end;

procedure TQuickExportSetupForm.SkipImagesKeyPress(Sender: TObject;
  var Key: Char);
begin
  SkipImagesClick(self);
end;

end.
