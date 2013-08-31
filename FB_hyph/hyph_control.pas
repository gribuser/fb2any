unit hyph_control;
interface
uses StdCtrls,MSXML2_TLB,fb2_hyph_TLB;
type
  THypher=class
  public
    Hyphenator:IFB2Hyphenator;
    constructor Create(AFontNameBox,AFontSizeBox,ADevicePropBox:TComboBox;
      DeviceDescr:WideString);
    destructor Destroy; override;
  private
    FontNameBox,FontSizeBox,DevicePropBox:TComboBox;
    procedure onFontNameChange(Sender: TObject);
    procedure onFontSizeChange(Sender: TObject);
    procedure onDevicePropChange(Sender: TObject);
  end;
implementation
constructor THypher.Create;
Var
  XD2:TFreeThreadedDOMDocument40;
Begin
  FontNameBox:=AFontNameBox;
  FontSizeBox:=AFontSizeBox;
  DevicePropBox:=ADevicePropBox;
  FontNameBox.OnChange:=onFontNameChange;
  FontSizeBox.OnChange:=onFontSizeChange;
  DevicePropBox.OnChange:=onDevicePropChange;
  XD2:=TFreeThreadedDOMDocument40.Create(Nil);
  XD2.DefaultInterface.preserveWhiteSpace:=True;
  XD2.DefaultInterface.load(DeviceDescr);
  Hyphenator:=CoFB2Hyphenator.Create;
  Hyphenator.deviceDescr:=XD2.DefaultInterface;
  DevicePropBox.Items.Text:=Hyphenator.deviceSizeList;
  DevicePropBox.ItemIndex:=0;
  FontNameBox.Items.Text:='<no hyphenation>'#10+Hyphenator.fontList;
  FontNameBox.ItemIndex:=0;
  DevicePropBox.OnChange(Self);
  FontNameBox.OnChange(self);
  Hyphenator.plainOnly:=False;
  Hyphenator.hyphStr:='- ';
  Hyphenator.strPrefix:=#160#160#160;
end;
destructor THypher.Destroy;
Begin
  Hyphenator:=Nil;
end;
procedure THypher.onFontNameChange(Sender: TObject);
Var
  BufBul:Boolean;
  BufStr,BufStr1:WideString;
Begin
  Hyphenator.currentFont:=FontNameBox.Text;
  BufStr1:=FontSizeBox.Text;
  BufStr:=Hyphenator.fontSizeList;
  if BufStr<>'' then
    FontSizeBox.Items.Text:=BufStr;
  If FontSizeBox.Items.IndexOf(BufStr1)>-1 then
    FontSizeBox.ItemIndex:=FontSizeBox.Items.IndexOf(BufStr1)
  else
    FontSizeBox.ItemIndex:=0;
  BufBul:=FontNameBox.ItemIndex>0;
  FontSizeBox.Enabled:=BufBul;
  DevicePropBox.Enabled:=BufBul;
end;
procedure THypher.onFontSizeChange(Sender: TObject);
Begin
  Hyphenator.currentFontSize:=FontSizeBox.Text;
end;
procedure THypher.onDevicePropChange(Sender: TObject);
Begin
  Hyphenator.currentDeviceSize:=DevicePropBox.Text;
end;

end.
