unit main_wnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst, ExtCtrls, ImgList;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Panel5: TPanel;
    Panel6: TPanel;
    Button6: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    ListView1: TListView;
    ProgressBar1: TProgressBar;
    Panel4: TPanel;
    Button3: TButton;
    Button2: TButton;
    ImageList2: TImageList;
    ListView2: TListView;
    Button1: TButton;
    Panel7: TPanel;
    Button4: TButton;
    GroupBox1: TGroupBox;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    Edit1: TEdit;
    Button5: TButton;
    Panel8: TPanel;
    Edit2: TEdit;
    Button8: TButton;
    CheckBox1: TRadioButton;
    Button7: TButton;
    ImageList3: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton2KeyPress(Sender: TObject; var Key: Char);
    procedure Button7Click(Sender: TObject);
    procedure ListView2Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Button8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    InvalidExtWarningShown:Boolean;
    AbortRequired:Boolean;
    procedure SearchForFB2Files(Path:String);
    procedure AddFile(Path:String);
    Procedure HandleDropFiles(var HDrop:TMessage);message WM_DROPFILES;
    function FileAlreadyAdded(FN:String):Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
const
  RegKey='SOFTWARE\Grib Soft\FB2Batch';

implementation
uses ShlObj,ShellApi,Registry,CommCtrl,ComObj,MSXML2_TLB,FB2_to_TXT_TLB;
{$R *.dfm}
const
  QuickExportGUID:TGUID='{72F1BD3E-8658-4C65-9804-5DCB684BBFE2}';
  AppName='FB2Batch';

Procedure ReplaceStr(var STR:String;SearchText,NewText:string);
Var
  FoundPos:Integer;
  NewStr:String;
Begin
  NewStr:='';
  FoundPos:=Pos(SearchText,STR);
  While FoundPos>0 do
  Begin
    NewStr:=NewStr+Copy(Str,1,FoundPos-1)+NewText;
    Str:=Copy(Str,FoundPos+Length(SearchText),MaxInt);
    FoundPos:=Pos(SearchText,STR);
  end;
  Str:=NewStr+Str;
end;

function GetImageIndex(Filename: String): Integer;
var
  Fileinfo: TSHFileInfo;
begin
  if SHGetFileInfo(PChar(FileName), 0, Fileinfo, sizeof(TSHFileInfo),
      SHGFI_ICON or SHGFI_SYSICONINDEX ) <> 0 then
      Result := Fileinfo.IIcon
  else
      Result := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  Fileinfo: TSHFileInfo;
  Reg:TRegistry;
  Keys:TStringList;
  I,I1:Integer;
  NewItem:TListItem;
  FN,Buf:String;
Const
  PluginsKey=RegKey+'\Plugins';
begin
  iMAGElIST1.Handle := SHGetFileInfo('',
      0, Fileinfo, sizeof(TSHFileInfo),
      SHGFI_SMALLICON or SHGFI_SYSICONINDEX );
  iMAGElIST1.ShareImages := True;
  DragAcceptFiles(Handle,True);
  InvalidExtWarningShown:=False;
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    if not Reg.OpenKeyReadOnly(PluginsKey) or not Reg.HasSubKeys then
    Begin
      MessageBox(Handle,'No quick export plugins found! Reinstall fb2any and any other eport plugins you need.'#13'Fb2batch can not continue and will exit now!','Error',MB_ICONERROR or MB_OK);
      Application.Terminate;
      Exit;
    end;
    Keys:=TStringList.Create;
    try
      Reg.GetKeyNames(Keys);
      for I:=0 to Keys.Count-1 do
      Begin
        Reg.CloseKey;
        Reg.OpenKeyReadOnly(PluginsKey+'\'+Keys[I]);
        NewItem:=ListView2.Items.Add;
        NewItem.Caption:=Reg.ReadString('Title')+' (*.'+Reg.ReadString('ext')+')';
        FN:=Reg.ReadString('Icon');
        Buf:='';
        For I1:=Length(FN) downto 1 do
        if FN[I1]<>',' then
          Buf:=FN[I1]+Buf
        else
          Begin
            FN:=Copy(FN,1,I1-1);
            break;
          end;
        NewItem.ImageIndex:=ImageList_ReplaceIcon(ImageList2.Handle,-1,ExtractIcon(HInstance,PChar(FN), StrToInt(Buf)));
        NewItem.SubItems.Add(Keys[I]);
        NewItem.SubItems.Add(Reg.ReadString('ext'));
      end;
      Reg.CloseKey;
      Reg.RootKey:=HKEY_CURRENT_USER;
      if Reg.OpenKeyReadOnly(RegKey) then
      Begin
        Edit1.Text:=Reg.ReadString('Output path');
        Edit2.Text:=Reg.ReadString('File create pattern');
{        case Reg.ReadInteger('SaveMethod') of
          1:Begin RadioButton2.Checked:= true; RadioButton1.Checked:=False;end;
          2:Begin CheckBox1.Checked:= true; RadioButton1.Checked:=False;end;
        end;}
      end;
    finally
      Keys.Free;
    end;
  finally
    Reg.Free;
  end;
end;

function CheckDirWritableCallback(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
Var
  TMPFileName:String;
  NewHile:HFIle;
  DirName:PChar;
  S:String;
Const
  ReadOnly:PChar='Read only folder';
  Inexistent:PChar='This folder does not seem to exists';
Begin
  Result:=0;
  if (Wnd<>0) and (uMsg<>BFFM_SELCHANGED) then exit;
  GetMem(DirName,MAX_PATH);
  try
    if Wnd<>0 then
    Begin
      SHGetPathFromIDList(PItemIDList(lParam),DirName);
      S:=DirName;
    end else
      S:=PChar(lpData);
    If not DirectoryExists(S) then
    Begin
      if Wnd<>0 then
      Begin
        SendMessage(Wnd,BFFM_ENABLEOK,0,0);
        SendMessage(Wnd,BFFM_SETSTATUSTEXT,0,integer(Inexistent));
      end;
      Exit;
    end;
    repeat
      TMPFileName:=IncludeTrailingPathDelimiter(S)+IntToStr(Random(99999999))+'.'+IntToStr(Random(999));
    until not FileExists(TMPFileName);
    NewHile:=CreateFile(PChar(TMPFileName),0,FILE_SHARE_READ,Nil,CREATE_NEW,FILE_FLAG_DELETE_ON_CLOSE,0);
    if NewHile=INVALID_HANDLE_VALUE then
    Begin
      if Wnd<>0 then
      Begin
        SendMessage(Wnd,BFFM_ENABLEOK,0,0);
        SendMessage(Wnd,BFFM_SETSTATUSTEXT,0,integer(ReadOnly));
      end;
      Exit;
    end;
    CloseHandle(NewHile);
    if Wnd<>0 then
      SendMessage(Wnd,BFFM_ENABLEOK,1,1)
    else
      Result:=1;
  finally
    FreeMem(DirName,MAX_PATH);
  end;
end;
procedure TForm1.Button3Click(Sender: TObject);
var
  DirName:PChar;
  DialogData:  TBrowseInfoA;
  DirRes:PItemIDList;
  OldCursor:TCursor;
begin
  GetMem(DirName,MAX_PATH);
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  ListView1.Items.BeginUpdate;
  try
    FillChar(DialogData,SizeOf(DialogData),0);
    With DialogData do
    Begin
      hwndOwner:= Handle;
      pszDisplayName:= DirName;  { Return display name of item selected. }
      lpszTitle:='Choose a folder to scan tor *.fb2 files';      { text to go in the banner over the tree. }
      ulFlags:=BIF_RETURNONLYFSDIRS;
//      lpfn:=CheckDirWritableCallback;           { Flags that control the return stuff }
    end;
    DirRes:=SHBrowseForFolder(DialogData);
    If DirRes=Nil then
      exit;
    SHGetPathFromIDList(DirRes,DirName);
    SearchForFB2Files(IncludeTrailingPathDelimiter(DirName));
  Finally
    ListView1.Items.EndUpdate;
    FreeMem(DirName,MAX_PATH);
    Screen.Cursor:=OldCursor;
    Button6.Enabled:=Button7.Enabled and (ListView1.Items.Count>0);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  AbortRequired:=true;
  Close;
end;

procedure TForm1.SearchForFB2Files(Path:String);
Var
  F: TSearchRec;
  procedure ProcessRecord(var F:TSearchRec);
  Var
    NewItem:TListItem;
  Begin
    If (f.Name='.') or (f.Name='..') then exit;
    If F.Attr and faDirectory <>0 then
      SearchForFB2Files(IncludeTrailingPathDelimiter(Path+F.Name))
    Else
      if (UpperCase(ExtractFileExt(F.Name)) = '.FB2') and not FileAlreadyAdded(Path+F.Name) then
      Begin
        NewItem:=ListView1.Items.Add;
        NewItem.Caption:=F.Name;
        NewItem.SubItems.Add(IntToStr(round(F.Size/1024))+'k');
        NewItem.SubItems.Add(Path);
        NewItem.ImageIndex:=GetImageIndex(Path+F.Name);
      end;
  end;
Begin
  if FindFirst(Path+'*.*', faAnyFile or faDirectory	or faSysFile or
    faHidden or faReadOnly or faArchive, F) = 0 then
    ProcessRecord(F);
  while FindNext(F) = 0 do
    ProcessRecord(F);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then exit;
  AddFile(OpenDialog1.FileName)
end;
procedure TForm1.AddFile(Path:String);
Var
  NewItem:TListItem;
  Function FileSize(FN:String):String;
  Var
    HFile:THandle;
  Begin
    result:='0';
    HFile:=CreateFile( PChar(FN), GENERIC_READ, FILE_SHARE_READ, Nil, OPEN_EXISTING, 0,0);
    if hFile = INVALID_HANDLE_VALUE then exit;
    Result:=IntToStr(round(GetFileSize(hFile,Nil)/1024));
    CloseHandle(HFile);
  end;
Begin
  if FileAlreadyAdded(Path) then exit;
  NewItem:=ListView1.Items.Add;
  NewItem.Caption:=ExtractFileName(Path);
  NewItem.SubItems.Add(FileSize(Path)+'k');
  NewItem.SubItems.Add(IncludeTrailingPathDelimiter(ExtractFilePath(Path)));
  NewItem.ImageIndex:=GetImageIndex(Path);
  Button6.Enabled:=Button7.Enabled and (ListView1.Items.Count>0);
end;

procedure TForm1.Button6Click(Sender: TObject);
Var
  I,I1:Integer;
  Lib:IUnknown;
  ExportPlugin:IFB2AnyQuickExport;
  PluginsList:Array of record I:IFB2AnyQuickExport;Ext:String;end;
  OutPath:String;
  XTmp:IXMLDOMDocument2;
  WarningShown,OverrideShown:Integer;
  OldCursor:TCursor;
  var1, var2, var3, var4, vart, varf, vars, varl, var5, var6, vary, vard, varv:string;
  PluginsCount:Integer;
  Function GetNodeValue(XPath:String):String;
  Var
    NodeList:IXMLDOMNodeList;
    I:Integer;
  const
    DisabledChars='/\?*:"<>|';
  Begin
    Result:='';
    NodeList:=XTmp.selectNodes(XPath);
    if (NodeList=Nil) or (NodeList.length=0) then exit;
    Result:=NodeList.item[0].text;
    For I:=1 to Length(Result) do
      If pos(Result[I],DisabledChars)<>0 then
        Result[I]:='-';
  end;
  Procedure ToggleControls(B:Boolean);
  Begin
    Panel1.Enabled:=B;
    Button7.Enabled:=B;
    GroupBox1.Enabled:=B;
    Button2.Enabled:=B;
    Button3.Enabled:=B;
    Button4.Enabled:=B;
  end;
begin
  if ListView2.SelCount=0 then
  Begin
    MessageBox(handle,'No export formats selected!','Error',MB_ICONERROR);
    exit;
  end;
  if RadioButton2.Checked and (CheckDirWritableCallback(0,0,0,Integer(PChar(Edit1.Text)))=0) then
  Begin
    MessageBox(handle,'Unable to write to output directory!','Error',MB_ICONERROR);
    exit;
  end;
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  ProgressBar1.Max:=ListView1.Items.Count;
  ProgressBar1.Visible:=True;
  ToggleControls(false);
  WarningShown:=0;
  OverrideShown:=0;
  Button6.Enabled:=False;
  AbortRequired:=False;
  try
    SetLength(PluginsList,ListView2.SelCount);
    I1:=0;
    For I:=0 to ListView2.Items.Count-1 do
      if ListView2.Items[I].Selected then
      Begin
        Lib:=CreateComObject(StringToGUID(ListView2.Items[I].SubItems[0]));
        Try
          OleCheck(Lib.QueryInterface(QuickExportGUID,ExportPlugin));
          PluginsList[I1].I:=ExportPlugin;
          PluginsList[I1].Ext:=ListView2.Items[I].SubItems[1];
          Inc(I1);
        except
          MessageBox(handle,pchar('Error loading plugin "'+ListView2.Items[I].Caption+'" - try reinstalling fb2any or contact plugin author'),'Error',MB_ICONERROR);
        end;
      end;
    PluginsCount:=I1-1;
    for I:= 0 to ListView1.Items.Count-1 do
    Begin
      Try
        if AbortRequired then exit;
        XTmp:=CoFreeThreadedDOMDocument40.Create;
        if not XTmp.load(ListView1.Items[I].SubItems[1]+ListView1.Items[I].Caption) then
          Raise Exception.Create(XTmp.parseError.reason);

        var4:=Copy(ListView1.Items[I].Caption,1,Length(ListView1.Items[I].Caption)-Length(ExtractFileExt(ListView1.Items[I].Caption)));
        if RadioButton1.Checked then
          OutPath:=ListView1.Items[I].SubItems[1]+var4
        else
          Begin
            if CheckBox1.Checked then
            Begin
              var1:=ExtractFileDrive(ListView1.Items[I].SubItems[1]);
              if Length(var1)<>2 then
                var1:='net'
              else
                var1:=var1[1];
              Var2:=ExcludeTrailingPathDelimiter(copy(ListView1.Items[I].SubItems[1],Length(ExtractFileDrive(ListView1.Items[I].SubItems[1]))+1,MaxInt));
              Var3:=Var2;
              While Pos('\',Var3)<>0 do
                Var3:=Copy(Var3,Pos('\',Var3)+1,MaxInt);
              XTmp.setProperty('SelectionLanguage','XPath');
              XTmp.setProperty('SelectionNamespaces', 'xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:xlink="http://www.w3.org/1999/xlink"');

              VarT:=GetNodeValue('//fb:description/fb:title-info/fb:book-title');
              VarF:=GetNodeValue('//fb:description/fb:title-info/fb:author/fb:first-name');
              Vars:=GetNodeValue('//fb:description/fb:title-info/fb:author/fb:middle-name');
              Varl:=GetNodeValue('//fb:description/fb:title-info/fb:author/fb:last-name');

              Var5:=GetNodeValue('//fb:description/fb:title-info/fb:lang');
              Var6:=GetNodeValue('//fb:description/fb:title-info/fb:src-lang');
              Vary:=GetNodeValue('//fb:description/fb:title-info/fb:date');
              Vard:=GetNodeValue('//fb:description/fb:document-info/fb:id');
              Varv:=GetNodeValue('//fb:description/fb:document-info/fb:version');
              OutPath:=Edit2.Text;
              ReplaceStr(OutPath,'%1',Var1);
              ReplaceStr(OutPath,'%2',Var2);
              ReplaceStr(OutPath,'%3',Var3);
              ReplaceStr(OutPath,'%4',Var4);
              ReplaceStr(OutPath,'%t',Vart);
              ReplaceStr(OutPath,'%f',Varf);
              ReplaceStr(OutPath,'%s',Vars);
              ReplaceStr(OutPath,'%l',Varl);
              ReplaceStr(OutPath,'%5',Var5);
              ReplaceStr(OutPath,'%6',Var6);
              ReplaceStr(OutPath,'%y',Vary);
              ReplaceStr(OutPath,'%d',Vard);
              ReplaceStr(OutPath,'%v',Varv);
              ForceDirectories(ExtractFilePath(OutPath));
            end else
              OutPath:=IncludeTrailingPathDelimiter(Edit1.Text)+var4;
          end;
        Application.Title:='FB2Batch - '+ ListView1.Items[I].Caption;
        For I1:=0 to PluginsCount do
        Begin
          if AbortRequired then exit;
          if (OverrideShown=0) and FileExists(OutPath+'.'+PluginsList[I1].Ext) then
          Begin
            case MessageBox(Handle,pChar('File "'+OutPath+'.'+PluginsList[I1].Ext+'" already exists. Would you like to overwrite ALL existing files?'),'Batch process',MB_ICONQUESTION or MB_YESNOCANCEL or MB_DEFBUTTON2) of
              ID_YES:OverrideShown:=1;
              ID_NO:Continue;
              ID_CANCEL:exit;
            end;
          end;
          Application.ProcessMessages;
          PluginsList[I1].I.Export(Handle,OutPath+'.'+PluginsList[I1].Ext,XTmp,AppName);
          if I1<>PluginsCount then
          Begin
            XTmp:=CoFreeThreadedDOMDocument40.Create;
            if not XTmp.load(ListView1.Items[I].SubItems[1]+ListView1.Items[I].Caption) then
              Raise Exception.Create(XTmp.parseError.reason);
          end;

        end;
      Except
        on E: Exception do
          Begin
            if WarningShown < 2 then
              MessageBox(Handle,PChar(E.Message),'Error',MB_ICONERROR);
            if WarningShown = 0 then
              case MessageBox(Handle,'There was an error. Would you like to view all the error messages during this batch action?','Batch process',MB_ICONQUESTION or MB_YESNOCANCEL) of
                ID_YES:WarningShown:=1;
                ID_NO:WarningShown:=2;
                ID_CANCEL:exit;
              end {case};
          end;
      end;
      ProgressBar1.Position:=I;
      ListView1.Items[I].StateIndex:=0;
      If I<ListView1.Items.Count-3 then
      ListView1.Items[I+2].MakeVisible(False);
      Application.ProcessMessages;
    end;
    ListView1.Items.BeginUpdate;
    ListView1.Items.Clear;
    ListView1.Items.EndUpdate;
  Finally
    ToggleControls(True);
    Screen.Cursor:=OldCursor;
    ProgressBar1.Visible:=False;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
Var
  I:Integer;
begin
  ListView1.Items.BeginUpdate;
  For I:=ListView1.Items.Count-1 downto 0 do
    if ListView1.Items[I].Selected then
       ListView1.Items.Delete(I);
  ListView1.Items.EndUpdate;
  Button6.Enabled:=Button7.Enabled and (ListView1.Items.Count>0);
end;

procedure TForm1.Panel3Resize(Sender: TObject);
begin
  Edit1.Width:=GroupBox1.Width-TPanel(Sender).BorderWidth*2-Button5.Width-12;
  Edit2.Width:=Edit1.Width-23;
  Button5.Left:=GroupBox1.Width-TPanel(Sender).BorderWidth*2-Button5.Width-5;
  Button8.Left:=Button5.Left-23;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  DirName:PChar;
  DialogData:  TBrowseInfoA;
  DirRes:PItemIDList;
  OldCursor:TCursor;
begin
  GetMem(DirName,MAX_PATH);
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  ListView1.Items.BeginUpdate;
  try
    FillChar(DialogData,SizeOf(DialogData),0);
    With DialogData do
    Begin
      hwndOwner:= Handle;
      pszDisplayName:= DirName;  { Return display name of item selected. }
      lpszTitle:='Choose a folder to store output files';      { text to go in the banner over the tree. }
      ulFlags:=BIF_RETURNONLYFSDIRS;
      lpfn:=CheckDirWritableCallback;           { Flags that control the return stuff }
    end;
    DirRes:=SHBrowseForFolder(DialogData);
    If DirRes=Nil then
      exit;
    SHGetPathFromIDList(DirRes,DirName);
    Edit1.Text:=IncludeTrailingPathDelimiter(DirName);
  Finally
    ListView1.Items.EndUpdate;
    FreeMem(DirName,MAX_PATH);
    Screen.Cursor:=OldCursor;
  end;

end;

Procedure TForm1.HandleDropFiles(var HDrop:TMessage);
//  Drug'nDrop файла обработаем здесь.
Var
  S:String;
  I:Integer;
  OldCursor:TCursor;
Begin
  Screen.Cursor:=crHourGlass;
  try
    I:=DragQueryFile(HDrop.WParam,$FFFFFFFF,@S[1],255);
    for I:=0 to I-1 do
    Begin
      SetLength(S,MAX_PATH);
      DragQueryFile(HDrop.WParam,I,@S[1],MAX_PATH);
      SetLength(S,Pos(#0,S)-1);
      if DirectoryExists(S) then
        SearchForFB2Files(IncludeTrailingPathDelimiter(S))
      else
        Begin
          if (UpperCase(ExtractFileExt(S)) <> '.FB2') and not InvalidExtWarningShown then
          Begin
            if MessageBox(Handle,'Non - *.fb2 file(s) dropped. Are you sure it''s ok?','Warning',MB_ICONWARNING or MB_OKCANCEL) <> id_OK then
              Exit
            else
              InvalidExtWarningShown:=True;
          end;
          AddFile(S);
        end;
    end;
  finally
    DragFinish(HDrop.WParam);
    Screen.Cursor:=OldCursor;
  end;
  Button6.Enabled:=Button7.Enabled and (ListView1.Items.Count>0);
end;

function TForm1.FileAlreadyAdded(FN:String):Boolean;
Var
  Path:String;
  I:Integer;
Begin
  result:=False;
  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(FN));
  FN:=ExtractFileName(FN);
  for I:=0 to ListView1.Items.Count-1 do
    if (ListView1.Items[I].Caption = FN) and (ListView1.Items[I].SubItems[1] = Path) then
    Begin
      Result:=True;
      Exit;
    end;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  Edit1.Enabled:=RadioButton2.Checked;
  Button5.Enabled:=RadioButton2.Checked;
  Edit2.Enabled:=CheckBox1.Checked;
end;

procedure TForm1.RadioButton2KeyPress(Sender: TObject; var Key: Char);
begin
  RadioButton2Click(Self);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  Lib:IUnknown;
  ExportPlugin:IFB2AnyQuickExport;
begin
  Lib:=CreateComObject(StringToGUID(ListView2.Selected.SubItems[0]));
  OleCheck(Lib.QueryInterface(QuickExportGUID,ExportPlugin));
  ExportPlugin.Setup(Handle,AppName);
end;

procedure TForm1.ListView2Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  Button7.Enabled:=ListView2.SelCount>0;
  Button6.Enabled:=Button7.Enabled and (ListView1.Items.Count>0);
end;

procedure TForm1.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  Button4.Enabled:=ListView1.SelCount>0;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  MessageBox(Handle,'You can use the following patterns:'#10#10+
  '(For example file "c:\temp\books\foo.fb2", Stephen King''s book "Thinner")'#10#10+
  '%1'#9'Drive letter of source fb2 file ("c")'#10+
  '%2'#9'Path of source fb2 file ("temp\books")'#10+
  '%3'#9'Source fb2 file folder ("books")'#10+
  '%4'#9'Source fb2 file name ("foo")'#10+
  '%t'#9'Book title ("Thinner")'#10+
  '%f'#9'Book author''s first name ("Stephen")'#10+
  '%s'#9'Book author''s middle name (empty in our example)'#10+
  '%l'#9'Book author''s last name ("King")'#10+
  '%5'#9'Book''s language ("en")'#10+
  '%6'#9'Book''s src-lang (empty in our example)'#10+
  '%y'#9'Book''s year-written ("1984")'#10+
  '%d'#9'Book''s id ("7539E335-30DA-49EC-B5B9-36697DB55C48")'#10+
  '%v'#9'Book''s version ("1.0")'#10
  ,'Help',MB_ICONINFORMATION);


end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create(KEY_ALL_ACCESS);
  Try
    if Reg.OpenKey(RegKey,True) then
    Begin
      Reg.WriteString('Output path', Edit1.Text);
      Reg.WriteString('File create pattern',Edit2.Text);
    end;
  FInally
    Reg.Free;
  end;
end;

end.
