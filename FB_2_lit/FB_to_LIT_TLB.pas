unit FB_to_LIT_TLB;

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
// File generated on 22.09.2004 13:03:40 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Work\FB_2_any\FB_2_lit\fb_2_lit.tlb (1)
// LIBID: {AC04CAB3-0820-4BD2-BD12-6BD374D6FEA2}
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
  FB_to_LITMajorVersion = 1;
  FB_to_LITMinorVersion = 0;

  LIBID_FB_to_LIT: TGUID = '{AC04CAB3-0820-4BD2-BD12-6BD374D6FEA2}';

  IID_IFBELitExportPlugin: TGUID = '{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}';
  CLASS_FBELitExportPlugin: TGUID = '{F59704D2-D36C-4F45-9532-4E5D944ED43F}';
  IID_IFB2LITExport: TGUID = '{125D65F3-D809-46B4-BF39-EFCE444A74B4}';
  CLASS_FB2LITExport: TGUID = '{2024E800-E9AF-418D-A4DA-0B7763C40A4D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFBELitExportPlugin = interface;
  IFB2LITExport = interface;
  IFB2LITExportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FBELitExportPlugin = IFBELitExportPlugin;
  FB2LITExport = IFB2LITExport;


// *********************************************************************//
// Interface: IFBELitExportPlugin
// Flags:     (256) OleAutomation
// GUID:      {1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}
// *********************************************************************//
  IFBELitExportPlugin = interface(IUnknown)
    ['{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}']
    function  Export(hWnd: Integer; const filename: WideString; const document: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFB2LITExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {125D65F3-D809-46B4-BF39-EFCE444A74B4}
// *********************************************************************//
  IFB2LITExport = interface(IDispatch)
    ['{125D65F3-D809-46B4-BF39-EFCE444A74B4}']
    function  Get_XSL: IDispatch; safecall;
    procedure Set_XSL(const Value: IDispatch); safecall;
    function  Get_SkipImages: WordBool; safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    function  Get_TOCLevels: Integer; safecall;
    procedure Set_TOCLevels(Value: Integer); safecall;
    procedure Convert(const document: IDispatch; filename: OleVariant); safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); safecall;
    function  Get_OPFXSL: IDispatch; safecall;
    procedure Set_OPFXSL(const Value: IDispatch); safecall;
    property XSL: IDispatch read Get_XSL write Set_XSL;
    property SkipImages: WordBool read Get_SkipImages write Set_SkipImages;
    property TOCLevels: Integer read Get_TOCLevels write Set_TOCLevels;
    property OPFXSL: IDispatch read Get_OPFXSL write Set_OPFXSL;
  end;

// *********************************************************************//
// DispIntf:  IFB2LITExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {125D65F3-D809-46B4-BF39-EFCE444A74B4}
// *********************************************************************//
  IFB2LITExportDisp = dispinterface
    ['{125D65F3-D809-46B4-BF39-EFCE444A74B4}']
    property XSL: IDispatch dispid 1;
    property SkipImages: WordBool dispid 2;
    property TOCLevels: Integer dispid 3;
    procedure Convert(const document: IDispatch; filename: OleVariant); dispid 4;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); dispid 5;
    property OPFXSL: IDispatch dispid 6;
  end;

// *********************************************************************//
// The Class CoFBELitExportPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IFBELitExportPlugin exposed by              
// the CoClass FBELitExportPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFBELitExportPlugin = class
    class function Create: IFBELitExportPlugin;
    class function CreateRemote(const MachineName: string): IFBELitExportPlugin;
  end;

// *********************************************************************//
// The Class CoFB2LITExport provides a Create and CreateRemote method to          
// create instances of the default interface IFB2LITExport exposed by              
// the CoClass FB2LITExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2LITExport = class
    class function Create: IFB2LITExport;
    class function CreateRemote(const MachineName: string): IFB2LITExport;
  end;

implementation

uses ComObj;

class function CoFBELitExportPlugin.Create: IFBELitExportPlugin;
begin
  Result := CreateComObject(CLASS_FBELitExportPlugin) as IFBELitExportPlugin;
end;

class function CoFBELitExportPlugin.CreateRemote(const MachineName: string): IFBELitExportPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FBELitExportPlugin) as IFBELitExportPlugin;
end;

class function CoFB2LITExport.Create: IFB2LITExport;
begin
  Result := CreateComObject(CLASS_FB2LITExport) as IFB2LITExport;
end;

class function CoFB2LITExport.CreateRemote(const MachineName: string): IFB2LITExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2LITExport) as IFB2LITExport;
end;

end.
