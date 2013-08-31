unit plugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FB2_to_RTF_TLB, StdVcl;

type
  TFB2_to_rtf = class(TTypedComObject, IFB2_to_rtf)
  protected
    function Export(hWnd: Integer; const filename: WideString;
      const document: IDispatch): HResult; stdcall;
  end;
  TOverridedComObjectFaactory=class(TTypedComObjectFactory)
    procedure UpdateRegistry(Register: Boolean); override;
  end;

implementation

uses ComServ,Registry,save_rtf_dialog,MSXML2_TLB,fb2rtf_engine,SySUtils;

function TFB2_to_rtf.Export(hWnd: Integer; const filename: WideString;
  const document: IDispatch): HResult;
Var
  DLG:TOpenPictureDialog;
begin
  DLG:=TOpenPictureDialog.Create(Nil);
  if filename<>'' then
    DLG.FileName:=copy(filename,1,Length(filename)-Length(ExtractFileExt(filename)))+'.rtf';
  with DLG do
  Begin
    if Execute then
      ExportDOM(hWnd,IXMLDOMDocument2(document),FileName,DoSkipImages, DoSkipCover, DoSkipDescr, DoEncCompat, DoImgCompat);
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
  FBEPluginKey := 'SOFTWARE\Haali\FBE\Plugins\'+GUIDToString(CLASS_FB2_to_rtf_);
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
      Reg.WriteString('','"FB to rtf v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Menu','FB2->&RTF by GribUser');
      Reg.WriteString('Type','Export');
      Reg.WriteString('Icon',DLLPath+',0');
      Reg.CloseKey;
      Reg.OpenKey(fb2batchKey,True);
      Reg.WriteString('','"FB to rtf v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Title','FB2->RTF by GribUser');
      Reg.WriteString('ext','rtf');
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
  TOverridedComObjectFaactory.Create(ComServer, TFB2_to_rtf, Class_FB2_to_rtf_,
    ciMultiInstance, tmApartment);
end.
