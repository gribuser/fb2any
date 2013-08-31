unit fb_2_rb_dialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, ComCtrls,MSXML2_TLB,hyph_control;

type
  TExportToRBDialog = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Panel4: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    CheckBox9: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    GroupBox3: TGroupBox;
    ComboBox2: TComboBox;
    CheckBox17: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBox3: TCheckBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    CheckBox4: TCheckBox;
    Button1: TButton;
    Timer1: TTimer;
    GroupBox5: TGroupBox;
    ComboBox1: TComboBox;
    ProgressBar1: TProgressBar;
    OpenDialog1: TOpenDialog;
    procedure Button4Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox9KeyPress(Sender: TObject; var Key: Char);
    procedure Copy1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    ParentHandle:THandle;
    HyphControler:THypher;
    ModulePath:String;
    SavedToDisk:Boolean;
    ASettingsKey:String;
    procedure LoadSettings(Key:String);
    Procedure StoreSettings(Key:String);
    Function DoTransForm(SendToReb:Boolean):Boolean;
    Procedure InformAdded(S:String);
    Procedure ProgressProc(S:String;Percent:Integer);
  public
    DOM:IXMLDOMDocument2;
    procedure CreateParams(var Params: TCreateParams); override;
    constructor CreateWithForeighnParent(AParent:THandle;SettingEditorKey:String);
    Function DoConvert:HResult;
    { Public declarations }
  end;
{DEFINE DEBUG}
Function ExportDOM(AParent:THandle;DOM:IXMLDOMDocument2;FN:String):HResult;
const
 RegistryKey='Software\Grib Soft\FB to RB\1.0';
implementation
uses Registry,ShellAPI,SetupApi,fb2rb_engine,ProgressForm;


Function ExportDOM;
Var
  Wnd:TExportToRBDialog;
Begin
  Result:=E_ABORT;
  Wnd:=TExportToRBDialog.CreateWithForeighnParent(AParent,'');
  Try
    if DOM=Nil then
    Begin
      Result:=S_FALSE;
      if not Wnd.OpenDialog1.Execute then Exit;
      DOM:=CoFreeThreadedDOMDocument40.Create;
      if not DOM.load(Wnd.OpenDialog1.FileName) then Raise Exception.Create(DOM.parseError.reason);
      FN:=Wnd.OpenDialog1.FileName;
    end;
    Wnd.DOM:=DOM;

    Dom.setProperty('SelectionLanguage','XPath');
    Dom.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0"');
    if Dom.selectSingleNode('//fb:section/fb:p')=Nil then
    Begin
      MessageBox(AParent,'Unable to export empty document.','Export failed',MB_OK or MB_ICONERROR);
      Result:=E_ABORT;
      Exit;
    end;
    Wnd.SaveDialog1.FileName:=ExtractFileName(FN)+'.rb';
    Result:=Wnd.DoConvert;
  Finally
    Wnd.Free;
  end;
end;

{$R *.dfm}



procedure TExportToRBDialog.StoreSettings;
Var
  Reg:TRegistry;
Begin
  Reg:=TRegistry.Create;
  Try
    Reg.OpenKey(Key,true);
    Reg.WriteBool('remove images',CheckBox9.Checked);
    Reg.WriteBool('skip coverpage',CheckBox2.Checked);
    Reg.WriteBool('translit author',CheckBox1.Checked);
    Reg.WriteBool('short section titles',CheckBox17.Checked);
    Reg.WriteBool('skip dialog',CheckBox3.Checked);
    Reg.WriteBool('no description',CheckBox4.Checked);
    Reg.WriteInteger('TOC deepness',ComboBox2.ItemIndex);
    Reg.WriteInteger('Page breaks level',ComboBox3.ItemIndex);
    Reg.WriteInteger('device orientation',ComboBox6.ItemIndex);
    Reg.WriteInteger('font name',ComboBox4.ItemIndex);
    Reg.WriteInteger('font size',ComboBox5.ItemIndex);
    Reg.WriteInteger('REB media',ComboBox1.ItemIndex);
    Reg.WriteBool('save to disk',SavedToDisk)
  FInally
    Reg.Free;
  end;
end;
procedure TExportToRBDialog.LoadSettings;
Var
  Reg:TRegistry;
Begin
  Reg:=TRegistry.Create;
  Try
    if Reg.OpenKeyReadOnly(Key) then
    Begin
      CheckBox9.Checked:=Reg.ReadBool('remove images');
      CheckBox9Click(self);
      CheckBox2.Checked:=Reg.ReadBool('skip coverpage');
      CheckBox1.Checked:=Reg.ReadBool('translit author');
      CheckBox4.Checked:=Reg.ReadBool('no description');
      CheckBox17.Checked:=Reg.ReadBool('short section titles');
      CheckBox3.Checked:=Reg.ReadBool('skip dialog');
      ComboBox2.ItemIndex:=Reg.ReadInteger('TOC deepness');
      ComboBox2Change(self);
      ComboBox3.ItemIndex:=Reg.ReadInteger('Page breaks level');
      ComboBox6.ItemIndex:=Reg.ReadInteger('device orientation');
      ComboBox6.OnChange(Self);
      ComboBox4.ItemIndex:=Reg.ReadInteger('font name');
      ComboBox4.OnChange(Self);
      ComboBox5.ItemIndex:=Reg.ReadInteger('font size');
      ComboBox5.OnChange(Self);
      ComboBox1.ItemIndex:=Reg.ReadInteger('REB media');
      SavedToDisk:=Reg.ReadBool('save to disk');
    end;
  FInally
    Reg.Free;
  end;
end;
constructor TExportToRBDialog.CreateWithForeighnParent;
Begin
  ParentHandle:=AParent;
  ASettingsKey:=SettingEditorKey;
  create(Nil);
end;
procedure TExportToRBDialog.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := ParentHandle;
end;
procedure TExportToRBDialog.Button4Click(Sender: TObject);
begin
  MessageBox(Handle,'FB2 to RB ActiveX control and FBE Plug-in by GribUser'#10'v 0.17 beta','About FB2 to RB',mb_Ok or MB_ICONINFORMATION);
end;
Function TExportToRBDialog.DoConvert;
Var
  FormResult:Integer;
Begin
  Result:=E_FAIL;
  if CheckBox3.Checked and DoTransForm(not SavedToDisk) then
    FormResult:=mrOk
  else
    FormResult:=ShowModal;
  if FormResult=mrOk then
    Result:=S_OK
  else If FormResult=mrCancel then
    Result:=S_FALSE;
end;
procedure TExportToRBDialog.ComboBox2Change(Sender: TObject);
begin
  CheckBox17.Enabled:=ComboBox2.ItemIndex>0;
  
end;
procedure TExportToRBDialog.CheckBox9Click(Sender: TObject);
begin
  CheckBox2.Enabled:=not CheckBox9.Checked;
  
end;
procedure TExportToRBDialog.CheckBox9KeyPress(Sender: TObject;
  var Key: Char);
  
begin
  CheckBox9Click(Self);
  
end;
procedure TExportToRBDialog.Copy1Click(Sender: TObject);
begin
  RichEdit1.SelectAll;
	 RichEdit1.CopyToClipboard;
end;
procedure TExportToRBDialog.FormCreate(Sender: TObject);
begin
  SetLength(ModulePath,2000);
	GetModuleFileName(HInstance,@ModulePath[1],1999);
  SetLength(ModulePath,Pos(#0,ModulePath)-1);
  ModulePath:=ExtractFileDir(ModulePath);
  ModulePath:=IncludeTrailingPathDelimiter(ModulePath);
  HyphControler:=THypher.Create(ComboBox4,ComboBox5,ComboBox6,ModulePath+'reb.xml');
  if ASettingsKey<>'' then
  Begin
    Panel6.Parent:=Self;
    PageControl1.Visible:=False;
    GroupBox5.Visible:=False;
    Width:=Width-Panel4.BorderWidth*2-8;
    CheckBox3.Visible:=False;
    Button1.Visible:=False;
    Panel2.Height:=Panel2.Height-20;
    ClientHeight:=GroupBox4.Top+GroupBox4.Height+Panel2.Height+8;
    Button2.Caption:='&Ok';
  end;
  try
    LoadSettings(RegistryKey+ASettingsKey);
  except
  end;
  Timer1Timer(Self);
end;
procedure TExportToRBDialog.FormDestroy(Sender: TObject);
begin
  HyphControler.Free;
end;
procedure TExportToRBDialog.Button2Click(Sender: TObject);
begin
  if ASettingsKey<>'' then
  Begin
    StoreSettings(RegistryKey+ASettingsKey);
    ModalResult:=mrOk;
    Close;
    Exit;
  end;
  PageControl1.ActivePageIndex:=1;
  Screen.Cursor:=crHourGlass;
  SavedToDisk:=Sender=Button2;
  try
    if DoTransForm(not SavedToDisk) then
    Begin
      StoreSettings(RegistryKey+ASettingsKey);
      ModalResult:=mrOk;
      Close;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;
Procedure TExportToRBDialog.InformAdded(S:String);
Begin
  RichEdit1.SelAttributes.Color:=clWindowText;
  RichEdit1.lines.Add(S);
  Update;
end;

Function TExportToRBDialog.DoTransForm;
Var
  Params:TFB2RBConverterSettings;
Begin
  Result:=False;
  If not SendToReb and not SaveDialog1.Execute then Exit;
  if not Visible then
  Begin
    ScrolForm:=TScrolForm.CreateParented(ParentHandle);
    ScrolForm.Show;
  end else ScrolForm:=Nil;
  Try
    RichEdit1.Lines.Clear;
    Params.TransLitTitle:=CheckBox1.Checked;
    params.SkipImages:=CheckBox9.Checked;
    params.TOCLevel:=ComboBox2.ItemIndex;
    params.PageBreakLeve:=ComboBox3.ItemIndex;
    params.SHortenTOCLines:=CheckBox17.Checked;
    params.SKipDescr:=CheckBox4.Checked;
    Params.SkipCOver:=CheckBox2.Checked;
    If not SendToReb then
      Params.Target:=SaveToFile
    else Begin
      If ComboBox1.Enabled and (ComboBox1.ItemIndex=1) then
        Params.Target:=storeOnRebSM
      else
        Params.Target:=storeOnRebInt;
    end;
    Params.FileName:=SaveDialog1.FileName;
    Params.ProgressProc:=ProgressProc;
    Params.DOM:=DOM;
    if  ComboBox4.ItemIndex>0 then
      Params.HyphControler:=HyphControler.Hyphenator
    else
      Params.HyphControler:=Nil;
    Params.XSL:=CoFreeThreadedDOMDocument40.Create;
    if not Params.XSL.load(ModulePath+'FB2_2_rb.xsl') then
      Raise Exception.Create(Params.XSL.parseError.reason);
    Params.RBMakePath:=ModulePath+'rbmake.exe';
    Params.EXELines:=RichEdit1.Lines;
    Params.HParent:=Handle;
    Result:=TransFormToReb(Params);
  Finally
    if ScrolForm<>Nil then
      ScrolForm.Free;
  end;
end;
procedure TExportToRBDialog.Timer1Timer(Sender: TObject);
Var
  Params:TRebData;
begin
  Params.HOwner:=Handle;
  OpenREB(Params);
  CloseReb(Params);
  if Params.SMPresent then
  Begin
    If ComboBox1.Items.Count=3 then
    Begin
      ComboBox1.Items.Delete(0);
      ComboBox1.ItemIndex:=0;
    end;
    ComboBox1.Enabled:=True;
  end else
    Begin
      ComboBox1.Enabled:=False;
      If ComboBox1.Items.Count=2 then
      Begin
        ComboBox1.Items.Insert(0,'No Smart Media on device');
        ComboBox1.ItemIndex:=0;
      end;
    end;
  if not Params.RebInstalled or not Params.RebConnected then
  Begin
    ComboBox1.Enabled:=False;
    Button1.Enabled:=False;
  end;
  if not Params.RebInstalled then
  Begin
    Button1.Visible:=False;
    if GroupBox5.Visible then
      Height:=Height-GroupBox5.Height;
    GroupBox5.Visible:=False;
    COmboBox1.Enabled:=False;
  end else if not Params.RebConnected then
    Begin
      Button1.Caption:='No REB1100';
      Button1.Default:=False;
      Button2.Default:=True;
      COmboBox1.Enabled:=False;
    end else
      Begin
        If not Button1.Enabled then
        Begin
          Button1.Default:=True;
          Button1.Enabled:=True;
          Button1.SetFocus;
          Button1.Default:=True;
        end;
        Button2.Default:=False;
        Button1.Caption:='To REB1100';
        COmboBox1.Enabled:=True;
      end;
end;
Procedure TExportToRBDialog.ProgressProc(S:String;Percent:Integer);
Begin
  InformAdded(S);
  ProgressBar1.Position:=Percent;
  if ScrolForm<>Nil then
    ScrolForm.ProgressBar1.Position:=Percent;
  Application.ProcessMessages;
end;

end.


