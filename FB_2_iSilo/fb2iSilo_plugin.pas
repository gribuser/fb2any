unit fb2iSilo_plugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FB2_to_iSilo_TLB, StdVcl,fb2iSilo_engine;

type
  TFB2iSiloPlugin = class(TTypedComObject, IFB2iSiloPlugin)
  protected
    function Export(hWnd: Integer; const filename: WideString;
      const document: IDispatch): HResult; stdcall;
  end;
  TOverridedComObjectFaactory=class(TTypedComObjectFactory)
    procedure UpdateRegistry(Register: Boolean); override;
  end;


implementation
uses ComServ,Registry,save_isilo_dialog,SysUtils;
Procedure TOverridedComObjectFaactory.UpdateRegistry;
Var
  FBEPluginKey,fb2batchKey:String;
  Reg:TRegistry;
  DLLPath:String;
Begin
  Inherited UpdateRegistry(Register);
  FBEPluginKey := 'SOFTWARE\Haali\FBE\Plugins\'+GUIDToString(CLASS_FB2iSiloPlugin);
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
      Reg.WriteString('','"FB to iSilo v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Menu','FB2->&iSilo by GribUser');
      Reg.WriteString('Type','Export');
      Reg.WriteString('Icon',DLLPath+',0');
      Reg.CloseKey;
      Reg.OpenKey(fb2batchKey,True);
      Reg.WriteString('','"FB to iSilo v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Title','FB2->iSilo by GribUser');
      Reg.WriteString('ext','isilo.pdb');
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


function TFB2iSiloPlugin.Export(hWnd: Integer; const filename: WideString;
  const document: IDispatch): HResult;
Var
  DLG:TOpenPictureDialog;
begin
  Result:=E_ABORT;
  try
    DLG:=TOpenPictureDialog.Create(Nil);
    if filename<>'' then
      DLG.FileName:=copy(filename,1,Length(filename)-Length(ExtractFileExt(filename)))+'.pdb';
    with DLG do
    Begin
      if Execute then
        Result:=ExportDOM(document,DLG.FileName,DLG.TocDepth,DLG.DoSkipImages)
      else
        Result:=S_FALSE;
      Free;
    end;
  except
    on E: Exception do
      Begin
        MessageBox(hWnd,PChar(E.Message),'Error',MB_OK or MB_ICONERROR);
        Result:=E_FAIL;
      end;
  end;
end;

initialization
  TOverridedComObjectFaactory.Create(ComServer, TFB2iSiloPlugin, Class_FB2iSiloPlugin,
    ciMultiInstance, tmApartment);
end.
