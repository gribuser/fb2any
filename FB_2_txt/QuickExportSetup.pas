unit QuickExportSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,save_txt_dialog;

type
  TQuickExportSetupForm = class(TForm)
    SkipDescr: TCheckBox;
    WordWrap: TCheckBox;
    IndentEdit: TEdit;
    Hyph: TCheckBox;
    Indent: TCheckBox;
    WidthEdit: TEdit;
    EncodingsList: TComboBox;
    BRTypeList: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    IgnoreStrongC: TCheckBox;
    IgnoreItalicC: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure WordWrapClick(Sender: TObject);
    procedure WordWrapKeyPress(Sender: TObject; var Key: Char);
    procedure IndentClick(Sender: TObject);
    procedure IndentKeyPress(Sender: TObject; var Key: Char);
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
  I:Integer;
  VerInfo:TOSVersionInfo;
  Reg:TRegistry;
begin
  EncodingsList.AddItem('ANSI system default codepage',Pointer(CP_ACP));
  EncodingsList.AddItem('OEM system default codepage',Pointer(CP_OEMCP));
  EncodingsList.AddItem('MAC system default codepage',Pointer(CP_MACCP));
  VerInfo.dwOSVersionInfoSize:=SizeOf(VerInfo);
  GetVersionEx(VerInfo);
  if VerInfo.dwPlatformId=VER_PLATFORM_WIN32_NT	then
    EncodingsList.AddItem('UTF-8',Pointer(CP_UTF8));// For WinNT only
  EncodingsList.AddItem('UTF-16',Pointer(CP_UTF16));
  For I:=1 to EncCount do
    EncodingsList.AddItem(IntToStr(SupportedEncodings[i].CP)+' - '+SupportedEncodings[i].Name,
      Pointer(SupportedEncodings[i].CP));
  For I:=1 to BrCount do
    BRTypeList.AddItem(BRTypes[I].Name,Nil);
  BRTypeList.ItemIndex:=0;
  EncodingsList.ItemIndex:=0;
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Try
      if Reg.OpenKeyReadOnly(Key) then
      Begin
        WordWrap.Checked:=Reg.ReadBool('Word wrap');
        SkipDescr.Checked:=Reg.ReadBool('Skip description');
        Indent.Checked:=Reg.ReadBool('Do indent para');
        Hyph.Checked:=Reg.ReadBool('Hyphenate');
        WidthEdit.Text:=IntToStr(Reg.ReadInteger('Text width'));
        IndentEdit.Text:=Reg.ReadString('Indent text');
        EncodingsList.ItemIndex:=EncodingsList.Items.IndexOfObject(Pointer(Reg.ReadInteger('File codepage')));
        BRTypeList.ItemIndex:=Reg.ReadInteger('Line breaks type');
        IgnoreStrongC.Checked:=Reg.ReadBool('Ignore strong');
        IgnoreItalicC.Checked:=Reg.ReadBool('Ignore emphasis');
      end;
    Finally
      Reg.Free;
    end;
  Except
  end;
  WordWrapClick(Nil);
  IndentClick(Nil);
end;

procedure TQuickExportSetupForm.WordWrapClick(Sender: TObject);
begin
  WidthEdit.Enabled:=WordWrap.Checked;
  Hyph.Enabled:=WordWrap.Checked;
end;

procedure TQuickExportSetupForm.WordWrapKeyPress(Sender: TObject;
  var Key: Char);
begin
  WordWrapClick(Nil);
end;

procedure TQuickExportSetupForm.IndentClick(Sender: TObject);
begin
  IndentEdit.Enabled:=Indent.Checked;
end;

procedure TQuickExportSetupForm.IndentKeyPress(Sender: TObject;
  var Key: Char);
begin
  IndentClick(Nil);
end;

procedure TQuickExportSetupForm.Button1Click(Sender: TObject);
Var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create(KEY_ALL_ACCESS);
  Try
    if Reg.OpenKey(Key,True) then
    Begin
      Reg.WriteBool('Word wrap',WordWrap.Checked);
      Reg.WriteBool('Skip description',SkipDescr.Checked);
      Reg.WriteBool('Do indent para',Indent.Checked);
      Reg.WriteBool('Hyphenate',Hyph.Checked);
      Reg.WriteInteger('Text width',StrToInt(WidthEdit.Text));
      Reg.WriteString('Indent text',IndentEdit.Text);
      Reg.WriteInteger('File codepage',Integer(EncodingsList.Items.Objects[EncodingsList.ItemIndex]));
      Reg.WriteInteger('Line breaks type',BRTypeList.ItemIndex);
      Reg.WriteBool('Ignore strong',IgnoreStrongC.Checked);
      Reg.WriteBool('Ignore emphasis',IgnoreItalicC.Checked);
    end;
  Finally
    Reg.Free;
  end;

end;

procedure TQuickExportSetupForm.WidthEditChange(Sender: TObject);
begin
  try
    StrToInt(WidthEdit.Text);
  except
    WidthEdit.Text:='80';
  end;
end;

end.
