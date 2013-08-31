unit fb2lit_plugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FB2_to_LIT_TLB, StdVcl;

type
  TFBELitExportPlugin = class(TTypedComObject, IFBELitExportPlugin)
  protected
    function Export(hWnd: Integer; const filename: WideString;
      const document: IDispatch): HResult; stdcall;
  end;
  TOverridedComObjectFaactory=class(TTypedComObjectFactory)
    procedure UpdateRegistry(Register: Boolean); override;
  end;


implementation
uses ComServ,Registry,SysUtils,save_lit_dialog,fb2lit_engine;

Procedure TOverridedComObjectFaactory.UpdateRegistry;
Var
  FBEPluginKey,fb2batchKey:String;
  Reg:TRegistry;
  DLLPath:String;
Begin
  Inherited UpdateRegistry(Register);
  FBEPluginKey := 'SOFTWARE\Haali\FBE\Plugins\'+GUIDToString(CLASS_FBELitExportPlugin);
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
      Reg.WriteString('','"FB to lit v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Menu','FB2->&LIT by GribUser');
      Reg.WriteString('Type','Export');
      Reg.WriteString('Icon',DLLPath+',0');
      Reg.CloseKey;
      Reg.OpenKey(fb2batchKey,True);
      Reg.WriteString('','"FB to LIT v0.1" plugin by GribUser grib@gribuser.ru');
      Reg.WriteString('Title','FB2->LIT by GribUser');
      Reg.WriteString('ext','lit');
      Reg.WriteString('Icon',DLLPath+',0');
    end else Begin
      Reg.DeleteKey(FBEPluginKey);
      Reg.DeleteKey(fb2batchKey);
      Reg.RootKey:=HKEY_CURRENT_USER;
      Reg.DeleteKey('software\Grib Soft\FB2 to lit\1.0')
    end;
  finally
    Reg.Free;
  end;
end;

function TFBELitExportPlugin.Export(hWnd: Integer;
  const filename: WideString; const document: IDispatch): HResult;
Var
  DLG:TOpenPictureDialog;
begin
  Result:=E_ABORT;
  try
    DLG:=TOpenPictureDialog.Create(Nil);
    if filename<>'' then
      DLG.FileName:=copy(filename,1,Length(filename)-Length(ExtractFileExt(filename)))+'.lit';
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
  TOverridedComObjectFaactory.Create(ComServer, TFBELitExportPlugin, Class_FBELitExportPlugin,
    ciMultiInstance, tmApartment);
end.
