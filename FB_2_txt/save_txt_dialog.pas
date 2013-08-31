unit save_txt_dialog;

interface
uses Messages, Windows, SysUtils, Classes, Controls, StdCtrls, Graphics,
  ExtCtrls, Buttons, Dialogs;

type
  TOpenPictureDialog = class(TSaveDialog)
  private
    SkipDescr, WordWrap,Indent,Hyph,IgnoreStrongC,IgnoreItalicC:TCheckBox;
    WidthEdit,IndentEdit:TEdit;
    EncodingsList,BRTypeList:TComboBox;
    FChecksPanel: TPanel;
    TextWidth,IndentWidth,CodePage,BrType:Integer;
    function GetSkipDescr:boolean;
    function GetTextWidth:integer;
    function GetIndent:integer;
    function GetHyphenate:boolean;
    function GetCodePage:Integer;
    function GetBr:string;
    function GetItalicIgnore:boolean;
    function GetStrongIgnore:boolean;
  protected
    procedure DoClose; override;
    procedure DoShow; override;
    Procedure OnWWClick(sender: TObject);
    Procedure OnWWKey(Sender: TObject; var Key: Char);
    Procedure OnIndentClick(sender: TObject);
    Procedure OnIndentKey(Sender: TObject; var Key: Char);
    Procedure TextWidthChange(sender: TObject);
    Procedure IndentWidthChange(sender: TObject);
    Procedure OnDialogShow(sender: TObject);
    Procedure OnCodePageChange(sender: TObject);
    Procedure OnBrTypeChange(sender: TObject);
  public
    property DoSkipDescr:boolean read GetSkipDescr;
    property TextFixedWidth:integer read GetTextWidth;
    property ParaIndent:integer read GetIndent;
    property Hyphenate:boolean read GetHyphenate;
    property OutCodePage:Integer read GetCodePage;
    property ItalicIgnore:boolean read GetItalicIgnore;
    property StrongIgnore:boolean read GetStrongIgnore;
    property LnBr:string read GetBr;
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
    function ProducePanel(Parent:TComponent):TPanel;
  end;

const
  EncCount=40;
  BrCount=3;
  CP_UTF16=3;
Type
  TEncCollection=Array[1..EncCount] of record
    CP:Integer;
    Name:String;
  end;
  TBrTypes=Array[1..BrCount] of record
    Chars:string;
    Name:String;
  end;
const
  RegistryKey='Software\Grib Soft\FB to TXT\1.0';
  BRTypes:TBrTypes=(
    (Chars:#13#10; Name: 'Windows line breaks (CR,LF)'),
    (Chars:#10; Name: 'UNIX line breaks (LF)'),
    (Chars:#13; Name: 'Macintosh line breaks (CR)')
  );
  SupportedEncodings:TEncCollection=(
    (CP: 1250; Name: 'Windows 3.1 Eastern European'),
    (CP: 1251; Name: 'Windows 3.1 Cyrillic'),
    (CP: 1252; Name: 'Windows 3.1 US (ANSI)'),
    (CP: 1253; Name: 'Windows 3.1 Greek'),
    (CP: 1254; Name: 'Windows 3.1 Turkish'),
    (CP: 1255; Name: 'Hebrew'),
    (CP: 1256; Name: 'Arabic'),
    (CP: 1257; Name: 'Baltic'),
    (CP: 437; Name: 'MS-DOS United States'),
    (CP: 708; Name: 'Arabic (ASMO 708)'),
    (CP: 709; Name: 'Arabic (ASMO 449+, BCON V4)'),
    (CP: 710; Name: 'Arabic (Transparent Arabic)'),
    (CP: 720; Name: 'Arabic (Transparent ASMO)'),
    (CP: 737; Name: 'Greek (formerly 437G)'),
    (CP: 775; Name: 'Baltic'),
    (CP: 850; Name: 'MS-DOS Multilingual (Latin I)'),
    (CP: 852; Name: 'MS-DOS Slavic (Latin II)'),
    (CP: 855; Name: 'IBM Cyrillic'),
    (CP: 857; Name: 'IBM Turkish'),
    (CP: 860; Name: 'MS-DOS Portuguese'),
    (CP: 861; Name: 'MS-DOS Icelandic'),
    (CP: 862; Name: 'Hebrew'),
    (CP: 863; Name: 'MS-DOS Canadian-French'),
    (CP: 864; Name: 'Arabic'),
    (CP: 865; Name: 'MS-DOS Nordic'),
    (CP: 866; Name: 'MS-DOS Russian (USSR)'),
    (CP: 869; Name: 'IBM Modern Greek'),
    (CP: 874; Name: 'Thai'),
    (CP: 932; Name: 'Japan'),
    (CP: 936; Name: 'Chinese (PRC, Singapore)'),
    (CP: 949; Name: 'Korean'),
    (CP: 950; Name: 'Chinese (Taiwan, Hong Kong)'),
    (CP: 874; Name: 'Thai'),
    (CP: 10000; Name: 'Macintosh Roman'),
    (CP: 10001; Name: 'Macintosh Japanese'),
    (CP: 10006; Name: 'Macintosh Greek I'),
    (CP: 10007; Name: 'Macintosh Cyrillic'),
    (CP: 10029; Name: 'Macintosh Latin 2'),
    (CP: 10079; Name: 'Macintosh Icelandic'),
    (CP: 10081; Name: 'Macintosh Turkish')
  );
implementation
uses Consts, Math, Forms, CommDlg, Dlgs,Registry;
{$R MyExtdlg.res}

function TOpenPictureDialog.GetSkipDescr;
Begin
  result:= SkipDescr.checked;
end;

function TOpenPictureDialog.GetItalicIgnore:boolean;
Begin
  result:= IgnoreItalicC.checked;
end;

function TOpenPictureDialog.GetStrongIgnore:boolean;
Begin
  result:= IgnoreStrongC.checked;
end;

Function TOpenPictureDialog.GetTextWidth:integer;
Begin
  if WordWrap.Checked then
    result:=TextWidth
  else
    Result:=-1;
end;

Function TOpenPictureDialog.GetIndent:integer;
Begin
  if Indent.Checked then
    result:=IndentWidth
  else
    Result:=-1;
end;

Function TOpenPictureDialog.GetHyphenate:boolean;
Begin
  result:=Hyph.Checked and WordWrap.Checked;
end;

Function TOpenPictureDialog.GetCodePage:Integer;
Begin
  result:=CodePage;
end;

Function TOpenPictureDialog.GetBr:string;
Begin
  result:=BRTypes[BrType+1].Chars;
end;


Procedure TOpenPictureDialog.OnBrTypeChange;
Begin
  BrType:=BRTypeList.ItemIndex;
end;

Procedure TOpenPictureDialog.OnCodePageChange;
Begin
  CodePage:=Integer(EncodingsList.Items.Objects[EncodingsList.ItemIndex]);
end;


procedure TOpenPictureDialog.OnWWClick;
Begin
  WidthEdit.Enabled:=WordWrap.Checked;
  Hyph.Enabled:=WordWrap.Checked;
end;


Procedure TOpenPictureDialog.TextWidthChange(sender: TObject);
Begin
  try
    TextWidth:=StrToInt(WidthEdit.Text);
  except
    TextWidth:=80;
    WidthEdit.Text:=IntToStr(TextWidth);
  end;
end;

Procedure TOpenPictureDialog.IndentWidthChange(sender: TObject);
Begin
  try
    IndentWidth:=StrToInt(IndentEdit.text);
  except
    IndentWidth:=3;
    IndentEdit.Text:=IntToStr(IndentWidth);
  end;
end;

procedure TOpenPictureDialog.OnWWKey;
Begin
  OnWWClick(Nil);
end;

Procedure TOpenPictureDialog.OnIndentClick(sender: TObject);
Begin
  IndentEdit.Enabled:=Indent.Checked;
end;
Procedure TOpenPictureDialog.OnIndentKey(Sender: TObject; var Key: Char);
Begin
  OnIndentClick(Nil);
end;

Function TOpenPictureDialog.ProducePanel(Parent:TComponent):TPanel;
Var
  FChecksPanel:TPanel;
Begin
  FChecksPanel:=TPanel.Create(Parent);
  Result:=FChecksPanel;
  with FChecksPanel do
  Begin
    Name := 'PicturePanel';
    Caption := '';
    SetBounds(10, 150, 200, 200);
    BevelOuter := bvNone;
    BorderWidth := 6;
    TabOrder := 1;

    SkipDescr:=TCheckBox.Create(Self);
    With SkipDescr do Begin
      Name := 'SkipDescr';
      Caption := 'Skip description';
      Left:=0;
      Top:=3;
      TabOrder := 1;
      Width:=200;
      Parent:=FChecksPanel;
    end;

    WordWrap:=TCheckBox.Create(Self);
    With WordWrap do Begin
      Name := 'WordWrap';
      Caption := 'Fixed-width';
      Left:=130;
      Top:=3;
      TabOrder := 2;
      Width:=95;
      Parent:=FChecksPanel;
    end;
    WordWrap.OnClick:=OnWWClick;
    WordWrap.OnKeyPress:=OnWWKey;
    WidthEdit:=TEdit.Create(Self);
    with WidthEdit do Begin
      Name := 'WrapEdit';
      Left:=225;
      Top:=0;
      Width:=20;
      Height:=10;
      Text:='80';
      Parent:=FChecksPanel;
      TabOrder:=3;
    end;
    WidthEdit.OnChange:=TextWidthChange;
    Hyph:=TCheckBox.Create(Self);
    With Hyph do Begin
      Name := 'Hyphenate';
      Caption := 'Hyphenate';
      Left:=270;
      Top:=3;
      TabOrder:= 6;
      Width:=90;
      Parent:=FChecksPanel;
    end;



    Indent:=TCheckBox.Create(Self);
    With Indent do Begin
      Name := 'Indent';
      Caption := 'Paragraph indent';
      Left:=375;
      Top:=3;
      TabOrder:= 4;
      Width:=130;
      Parent:=FChecksPanel;
    end;
    Indent.OnClick:=OnIndentClick;
    Indent.OnKeyPress:=OnIndentKey;

    IndentEdit:=TEdit.Create(Self);
    with IndentEdit do Begin
      Name := 'IndentEdit';
      Left:=505;
      Top:=0;
      Width:=20;
      Height:=10;
      Text:='4';
      Parent:=FChecksPanel;
      TabOrder:=5;
    end;
    IndentEdit.OnChange:=IndentWidthChange;

    EncodingsList:=TComboBox.Create(Self);
    With EncodingsList do Begin
      Name := 'EncBox';
      Top:=28;
      Left:=0;
      Width:=246;
      TabOrder:=7;
      Style:=csDropDownList;
      Parent:=FChecksPanel;
    end;
    BRTypeList:=TComboBox.Create(Self);
    With BRTypeList do Begin
      Name := 'LineBrBox';
      Top:=28;
      Left:=270;
      Width:=256;
      TabOrder:=8;
      Style:=csDropDownList;
      Parent:=FChecksPanel;
    end;
    IgnoreStrongC:=TCheckBox.Create(Self);
    With IgnoreStrongC do Begin
      Name := 'IgnoreStrongC';
      Caption := 'No strong to UPPERCASE';
      Left:=0;
      Top:=61;
      TabOrder:= 9;
      Width:=200;
      Parent:=FChecksPanel;
    end;

    IgnoreItalicC:=TCheckBox.Create(Self);
    With IgnoreItalicC do Begin
      Name := 'IgnoreItalicC';
      Caption := 'No emphasis to _emphasis_';
      Left:=270;
      Top:=61;
      TabOrder:= 9;
      Width:=200;
      Parent:=FChecksPanel;
    end;

  end;
end;
constructor TOpenPictureDialog.Create(AOwner: TComponent);
Var
  Reg:TRegistry;
begin
  inherited Create(AOwner);
  Options:=[ofOverwritePrompt,ofEnableSizing];
  FChecksPanel:=ProducePanel(Self);
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Try
      if Reg.OpenKeyReadOnly(RegistryKey) then
      Begin
        WordWrap.Checked:=Reg.ReadBool('Word wrap');
        SkipDescr.Checked:=Reg.ReadBool('Skip description');
        Indent.Checked:=Reg.ReadBool('Do indent para');
        Hyph.Checked:=Reg.ReadBool('Hyphenate');
        WidthEdit.Text:=IntToStr(Reg.ReadInteger('Text width'));
        IndentEdit.Text:=IntToStr(Reg.ReadInteger('Indent width'));
        CodePage:=Reg.ReadInteger('File codepage');
        BrType:=Reg.ReadInteger('Line breaks type');
        IgnoreStrongC.Checked:=Reg.ReadBool('Ignore strong');
        IgnoreItalicC.Checked:=Reg.ReadBool('Ignore emphasis');
      end;
    Finally
      Reg.Free;
    end;
  Except
  end;
  OnWWClick(Nil);
  OnIndentClick(Nil);
  TextWidthChange(Nil);
  IndentWidthChange(Nil);
  Filter:='Text files (*.txt)|*.txt|All files (*.*)|*.*';
  Title:='FB2 to txt v0.17b by GribUser';
  OnShow:=OnDialogShow;
  DefaultExt:='txt';
end;


procedure TOpenPictureDialog.OnDialogShow;
Var
  I:Integer;
  VerInfo:TOSVersionInfo;
Begin
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
  EncodingsList.ItemIndex:=EncodingsList.Items.IndexOfObject(Pointer(CodePage));
  EncodingsList.OnChange:=OnCodePageChange;
  For I:=1 to BrCount do
    BRTypeList.AddItem(BRTypes[I].Name,Nil);
  BRTypeList.ItemIndex:=BrType;
  BRTypeList.OnChange:=OnBrTypeChange;
end;

procedure TOpenPictureDialog.DoShow;
var
  PreviewRect, StaticRect: TRect;
begin
  GetClientRect(Handle, PreviewRect);
  StaticRect := GetStaticRect;
  { Move preview area to right of static area }
  PreviewRect.Top:= StaticRect.Top + (StaticRect.Bottom - StaticRect.Top);
  Inc(PreviewRect.Left, 10);
  FChecksPanel.BoundsRect := PreviewRect;
  FChecksPanel.ParentWindow := Handle;
  inherited DoShow;
end;
procedure TOpenPictureDialog.DoClose;
begin
  inherited DoClose;
  { Hide any hint windows left behind }
  Application.HideHint;
end;
function TOpenPictureDialog.Execute;
Var
  Reg:TRegistry;
begin
  Template := 'DLGTEMPLATE2';
  Options:=[ofOverwritePrompt,ofEnableSizing];
  Result := inherited Execute;
  if Result then
  Begin
    Reg:=TRegistry.Create(KEY_ALL_ACCESS);
    Try
      if Reg.OpenKey(RegistryKey,True) then
      Begin
        Reg.WriteBool('Word wrap',WordWrap.Checked);
        Reg.WriteBool('Skip description',SkipDescr.Checked);
        Reg.WriteBool('Do indent para',Indent.Checked);
        Reg.WriteBool('Hyphenate',Hyph.Checked);
        Reg.WriteInteger('Text width',TextWidth);
        Reg.WriteInteger('Indent width',IndentWidth);
        Reg.WriteInteger('File codepage',CodePage);
        Reg.WriteInteger('Line breaks type',BrType);
        Reg.WriteBool('Ignore strong',IgnoreStrongC.Checked);
        Reg.WriteBool('Ignore emphasis',IgnoreItalicC.Checked);
      end;
    Finally
      Reg.Free;
    end;
  end;
end;

end.
