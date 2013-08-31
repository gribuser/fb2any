unit fb_2_rb_plugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FB2_to_RB_TLB, StdVcl;

type
  TFB2_2_RB_FBE_export = class(TTypedComObject, IFBEExportPlugin)
  protected
    function Export(hWnd: Integer; const filename: WideString;
      const document: IDispatch): HResult; stdcall;
  end;
  TOverridedComObjectFaactory=class(TTypedComObjectFactory)
    procedure UpdateRegistry(Register: Boolean); override;
  end;

implementation

uses ComServ,registry,fb_2_rb_dialog,MSXML2_TLB,SysUtils;

function TFB2_2_RB_FBE_export.Export(hWnd: Integer;
  const filename: WideString; const document: IDispatch): HResult;
begin
  Try
    Result:=ExportDOM(hWnd,IXMLDOMDocument2(document),filename);
  Except
    on E: Exception do
      Begin
        MessageBox(hWnd,PChar(E.Message),'Error',MB_OK or MB_ICONERROR);
        Result:=E_FAIL;
      end;
  end;
end;
Procedure TOverridedComObjectFaactory.UpdateRegistry;
Var
  FBEPluginKey,fb2batchKey:String;
  Reg:TRegistry;
  DLLPath:String;
Begin
  Inherited UpdateRegistry(Register);
  FBEPluginKey := 'SOFTWARE\Haali\FBE\Plugins\'+GUIDToString(CLASS_FB2_2_RB_FBE_export);
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
      Reg.WriteString('','"FB to rb v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Menu','&FB2->RB by GribUser');
      Reg.WriteString('Type','Export');
      Reg.WriteString('Icon',DLLPath+',0');
      Reg.CloseKey;
      Reg.OpenKey(fb2batchKey,True);
      Reg.WriteString('','"FB to rb v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Title','FB2->RB by GribUser');
      Reg.WriteString('ext','rb');
      Reg.WriteString('Icon',DLLPath+',0');
    end else Begin
      Reg.DeleteKey(FBEPluginKey);
      Reg.DeleteKey(fb2batchKey);
      Reg.RootKey:=HKEY_CURRENT_USER;
      Reg.DeleteKey('software\Grib Soft\FB2 to RB\1.0')
    end;
  finally
    Reg.Free;
  end;
end;

initialization
  TOverridedComObjectFaactory.Create(ComServer, TFB2_2_RB_FBE_export, Class_FB2_2_RB_FBE_export,
    ciMultiInstance, tmApartment);
end.
