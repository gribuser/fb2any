unit fb_2_iSilo_TLB;

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

// PASTLWTR : $Revision:   1.130  $
// File generated on 25.09.2004 22:22:13 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Work\FB_2_any\FB_2_iSilo\fb_2_iSilo.tlb (1)
// LIBID: {BCD610FF-7210-455F-9E20-8BBB7E615C32}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (H:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (H:\WINDOWS\system32\stdvcl40.dll)
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
  fb_2_iSiloMajorVersion = 1;
  fb_2_iSiloMinorVersion = 0;

  LIBID_fb_2_iSilo: TGUID = '{BCD610FF-7210-455F-9E20-8BBB7E615C32}';

  IID_IFB2iSiloPlugin: TGUID = '{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}';
  CLASS_FB2iSiloPlugin: TGUID = '{A4B663F2-B73E-4005-B841-D61F17CBD473}';
  IID_IFB2iSiloExport: TGUID = '{40C3F3A8-1263-4FA2-AEEE-6200450DF7B0}';
  CLASS_FB2iSiloExport: TGUID = '{FCF63692-5E3B-4E76-8D61-47F9FCDF8514}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFB2iSiloPlugin = interface;
  IFB2iSiloExport = interface;
  IFB2iSiloExportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FB2iSiloPlugin = IFB2iSiloPlugin;
  FB2iSiloExport = IFB2iSiloExport;


// *********************************************************************//
// Interface: IFB2iSiloPlugin
// Flags:     (256) OleAutomation
// GUID:      {1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}
// *********************************************************************//
  IFB2iSiloPlugin = interface(IUnknown)
    ['{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}']
    function  Export(hWnd: Integer; const filename: WideString; const document: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFB2iSiloExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {40C3F3A8-1263-4FA2-AEEE-6200450DF7B0}
// *********************************************************************//
  IFB2iSiloExport = interface(IDispatch)
    ['{40C3F3A8-1263-4FA2-AEEE-6200450DF7B0}']
    function  Get_XSL: IDispatch; safecall;
    procedure Set_XSL(const Value: IDispatch); safecall;
    function  Get_SkipImages: WordBool; safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    function  Get_TOCLevels: Integer; safecall;
    procedure Set_TOCLevels(Value: Integer); safecall;
    procedure Convert(const document: IDispatch; filename: OleVariant); safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); safecall;
    function  Get_IXSXSL: IDispatch; safecall;
    procedure Set_IXSXSL(const Value: IDispatch); safecall;
    property XSL: IDispatch read Get_XSL write Set_XSL;
    property SkipImages: WordBool read Get_SkipImages write Set_SkipImages;
    property TOCLevels: Integer read Get_TOCLevels write Set_TOCLevels;
    property IXSXSL: IDispatch read Get_IXSXSL write Set_IXSXSL;
  end;

// *********************************************************************//
// DispIntf:  IFB2iSiloExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {40C3F3A8-1263-4FA2-AEEE-6200450DF7B0}
// *********************************************************************//
  IFB2iSiloExportDisp = dispinterface
    ['{40C3F3A8-1263-4FA2-AEEE-6200450DF7B0}']
    property XSL: IDispatch dispid 1;
    property SkipImages: WordBool dispid 2;
    property TOCLevels: Integer dispid 3;
    procedure Convert(const document: IDispatch; filename: OleVariant); dispid 4;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); dispid 5;
    property IXSXSL: IDispatch dispid 6;
  end;

// *********************************************************************//
// The Class CoFB2iSiloPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IFB2iSiloPlugin exposed by              
// the CoClass FB2iSiloPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2iSiloPlugin = class
    class function Create: IFB2iSiloPlugin;
    class function CreateRemote(const MachineName: string): IFB2iSiloPlugin;
  end;

// *********************************************************************//
// The Class CoFB2iSiloExport provides a Create and CreateRemote method to          
// create instances of the default interface IFB2iSiloExport exposed by              
// the CoClass FB2iSiloExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2iSiloExport = class
    class function Create: IFB2iSiloExport;
    class function CreateRemote(const MachineName: string): IFB2iSiloExport;
  end;

implementation

uses ComObj;

class function CoFB2iSiloPlugin.Create: IFB2iSiloPlugin;
begin
  Result := CreateComObject(CLASS_FB2iSiloPlugin) as IFB2iSiloPlugin;
end;

class function CoFB2iSiloPlugin.CreateRemote(const MachineName: string): IFB2iSiloPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2iSiloPlugin) as IFB2iSiloPlugin;
end;

class function CoFB2iSiloExport.Create: IFB2iSiloExport;
begin
  Result := CreateComObject(CLASS_FB2iSiloExport) as IFB2iSiloExport;
end;

class function CoFB2iSiloExport.CreateRemote(const MachineName: string): IFB2iSiloExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2iSiloExport) as IFB2iSiloExport;
end;

end.
