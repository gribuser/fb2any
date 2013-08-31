unit fbeplugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FB2_to_TXT_TLB, StdVcl;

type
  TFB2_to_TXT = class(TTypedComObject, IFBEExportPlugin)
  protected
    function Export(hWnd: Integer; const filename: WideString;
      const document: IDispatch): HResult; stdcall;
  end;
  TOverridedComObjectFaactory=class(TTypedComObjectFactory)
    procedure UpdateRegistry(Register: Boolean); override;
  end;

implementation

uses ComServ,Registry,save_txt_dialog,SysUtils,fb2txt_engine,MSXML2_TLB;

function TFB2_to_TXT.Export(hWnd: Integer; const filename: WideString;
  const document: IDispatch): HResult;
Var
  DLG:TOpenPictureDialog;
begin
  DLG:=TOpenPictureDialog.Create(Nil);
  if filename<>'' then
    DLG.FileName:=copy(filename,1,Length(filename)-Length(ExtractFileExt(filename)))+'.txt';
  with DLG do
  Begin
    if Execute then
      ExportDOM(hWnd,IXMLDOMDocument2(document),DLG.FileName,
      DLG.LnBr,DLG.DoSkipDescr,DLG.Hyphenate,DLG.TextFixedWidth,DLG.ParaIndent,DLG.OutCodePage,DLG.ItalicIgnore,DLG.StrongIgnore);
    Free;
  end;
end;
Procedure TOverridedComObjectFaactory.UpdateRegistry;
Var
  FBEPluginKey,fb2batchKey:String;
  Reg:TRegistry;
  DLLPath:String;
Begin
  Inherited UpdateRegistry(Register);
  FBEPluginKey := 'SOFTWARE\Haali\FBE\Plugins\'+GUIDToString(CLASS_FB2_to_TXT_);
  fb2batchKey:= 'Software\Grib Soft\FB2Batch\Plugins\'+GUIDToString(CLASS_FB2AnyQuickExport);
  Reg:=TRegistry.Create;
  Try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    If Register then
    Begin
      SetLength(DLLPath,2000);
      GetModuleFileName(HInstance,@DLLPath[1],1999);
      SetLength(DLLPath,Pos(#0,DLLPath)-1);

      Reg.OpenKey(FBEPluginKey,True);
      Reg.WriteString('','"FB to TXT v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Menu','FB2->&TXT by GribUser');
      Reg.WriteString('Type','Export');
      Reg.WriteString('Icon',DLLPath+',0');
      Reg.CloseKey;
      Reg.OpenKey(fb2batchKey,True);
      Reg.WriteString('','"FB to TXT v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Title','FB2->TXT by GribUser');
      Reg.WriteString('ext','txt');
      Reg.WriteString('Icon',DLLPath+',0');
    end else Begin
      Reg.DeleteKey(FBEPluginKey);
      Reg.DeleteKey(fb2batchKey);
      Reg.RootKey:=HKEY_CURRENT_USER;
      Reg.DeleteKey(RegistryKey)
    end;
  finally
    Reg.Free;
  end;
end;

initialization
  TOverridedComObjectFaactory.Create(ComServer, TFB2_to_TXT, Class_FB2_to_TXT_,
    ciMultiInstance, tmApartment);
end.
