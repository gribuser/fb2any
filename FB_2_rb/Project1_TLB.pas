unit Project1_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision: 1.1.1.1 $
// File generated on 05.02.2004 12:45:58 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Work\FB_2_any\FB_2_rb\fb_2_rb.tlb (1)
// LIBID: {7917C17F-2D4A-48F0-93BB-90B43621E1E2}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, StdVCL, Variants, Windows;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  Project1MajorVersion = 1;
  Project1MinorVersion = 0;

  LIBID_Project1: TGUID = '{7917C17F-2D4A-48F0-93BB-90B43621E1E2}';

  IID_IFBEExportPlugin: TGUID = '{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}';
  CLASS_FB2_2_RB_FBE_export: TGUID = '{AF1DCC45-F1E2-424C-A20A-30516168ADE3}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFBEExportPlugin = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FB2_2_RB_FBE_export = IFBEExportPlugin;


// *********************************************************************//
// Interface: IFBEExportPlugin
// Flags:     (256) OleAutomation
// GUID:      {1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}
// *********************************************************************//
  IFBEExportPlugin = interface(IUnknown)
    ['{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}']
    function  Export(hWnd: Integer; const filename: WideString; const document: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoFB2_2_RB_FBE_export provides a Create and CreateRemote method to          
// create instances of the default interface IFBEExportPlugin exposed by              
// the CoClass FB2_2_RB_FBE_export. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2_2_RB_FBE_export = class
    class function Create: IFBEExportPlugin;
    class function CreateRemote(const MachineName: string): IFBEExportPlugin;
  end;

implementation

uses ComObj;

class function CoFB2_2_RB_FBE_export.Create: IFBEExportPlugin;
begin
  Result := CreateComObject(CLASS_FB2_2_RB_FBE_export) as IFBEExportPlugin;
end;

class function CoFB2_2_RB_FBE_export.CreateRemote(const MachineName: string): IFBEExportPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2_2_RB_FBE_export) as IFBEExportPlugin;
end;

end.
