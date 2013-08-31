unit FB2_to_RTF_TLB;

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
// File generated on 31.01.2005 22:15:44 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Work\FB_2_any\FB_2_rtf\fb_2_rtf.tlb (1)
// LIBID: {4AB983E8-77CF-4F1E-BCD8-EB579C2D529E}
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
  FB2_to_RTFMajorVersion = 1;
  FB2_to_RTFMinorVersion = 0;

  LIBID_FB2_to_RTF: TGUID = '{4AB983E8-77CF-4F1E-BCD8-EB579C2D529E}';

  IID_IFB2_to_rtf: TGUID = '{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}';
  CLASS_FB2_to_RTF_: TGUID = '{FAD27C9E-993E-47E3-B53E-974194CF1958}';
  IID_IFB2RTFExport: TGUID = '{92CA2D60-EEC9-4EFD-AF7B-2B60045FEF94}';
  CLASS_FB2RTFExport: TGUID = '{7797D18B-3D4D-42F7-AA82-BA7175E76026}';
  IID_IFB2AnyQuickExport: TGUID = '{72F1BD3E-8658-4C65-9804-5DCB684BBFE2}';
  CLASS_FB2AnyQuickExport: TGUID = '{889102DB-D7EC-461F-9882-FAB25AE30069}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFB2_to_rtf = interface;
  IFB2RTFExport = interface;
  IFB2RTFExportDisp = dispinterface;
  IFB2AnyQuickExport = interface;
  IFB2AnyQuickExportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FB2_to_RTF_ = IFB2_to_rtf;
  FB2RTFExport = IFB2RTFExport;
  FB2AnyQuickExport = IFB2AnyQuickExport;


// *********************************************************************//
// Interface: IFB2_to_rtf
// Flags:     (256) OleAutomation
// GUID:      {1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}
// *********************************************************************//
  IFB2_to_rtf = interface(IUnknown)
    ['{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}']
    function  Export(hWnd: Integer; const filename: WideString; const document: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFB2RTFExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92CA2D60-EEC9-4EFD-AF7B-2B60045FEF94}
// *********************************************************************//
  IFB2RTFExport = interface(IDispatch)
    ['{92CA2D60-EEC9-4EFD-AF7B-2B60045FEF94}']
    function  Get_SkipImages: WordBool; safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    function  Get_SkipDescr: WordBool; safecall;
    procedure Set_SkipDescr(Value: WordBool); safecall;
    function  Get_EncOptimise: WordBool; safecall;
    procedure Set_EncOptimise(Value: WordBool); safecall;
    function  Get_ImagesToBMP: WordBool; safecall;
    procedure Set_ImagesToBMP(Value: WordBool); safecall;
    procedure AddXSLParameter(baseName: OleVariant; parameter: OleVariant; namespaceURI: OleVariant); safecall;
    procedure Convert(const document: IDispatch; filename: OleVariant); safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); safecall;
    function  Get_SkipCover: WordBool; safecall;
    procedure Set_SkipCover(Value: WordBool); safecall;
    property SkipImages: WordBool read Get_SkipImages write Set_SkipImages;
    property SkipDescr: WordBool read Get_SkipDescr write Set_SkipDescr;
    property EncOptimise: WordBool read Get_EncOptimise write Set_EncOptimise;
    property ImagesToBMP: WordBool read Get_ImagesToBMP write Set_ImagesToBMP;
    property SkipCover: WordBool read Get_SkipCover write Set_SkipCover;
  end;

// *********************************************************************//
// DispIntf:  IFB2RTFExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92CA2D60-EEC9-4EFD-AF7B-2B60045FEF94}
// *********************************************************************//
  IFB2RTFExportDisp = dispinterface
    ['{92CA2D60-EEC9-4EFD-AF7B-2B60045FEF94}']
    property SkipImages: WordBool dispid 1;
    property SkipDescr: WordBool dispid 2;
    property EncOptimise: WordBool dispid 3;
    property ImagesToBMP: WordBool dispid 4;
    procedure AddXSLParameter(baseName: OleVariant; parameter: OleVariant; namespaceURI: OleVariant); dispid 5;
    procedure Convert(const document: IDispatch; filename: OleVariant); dispid 6;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); dispid 7;
    property SkipCover: WordBool dispid 8;
  end;

// *********************************************************************//
// Interface: IFB2AnyQuickExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {72F1BD3E-8658-4C65-9804-5DCB684BBFE2}
// *********************************************************************//
  IFB2AnyQuickExport = interface(IDispatch)
    ['{72F1BD3E-8658-4C65-9804-5DCB684BBFE2}']
    procedure Export(hWnd: Integer; filename: OleVariant; const document: IDispatch; 
                     appName: OleVariant); safecall;
    procedure Setup(hWnd: Integer; appName: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  IFB2AnyQuickExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {72F1BD3E-8658-4C65-9804-5DCB684BBFE2}
// *********************************************************************//
  IFB2AnyQuickExportDisp = dispinterface
    ['{72F1BD3E-8658-4C65-9804-5DCB684BBFE2}']
    procedure Export(hWnd: Integer; filename: OleVariant; const document: IDispatch; 
                     appName: OleVariant); dispid 1;
    procedure Setup(hWnd: Integer; appName: OleVariant); dispid 2;
  end;

// *********************************************************************//
// The Class CoFB2_to_RTF_ provides a Create and CreateRemote method to          
// create instances of the default interface IFB2_to_rtf exposed by              
// the CoClass FB2_to_RTF_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2_to_RTF_ = class
    class function Create: IFB2_to_rtf;
    class function CreateRemote(const MachineName: string): IFB2_to_rtf;
  end;

// *********************************************************************//
// The Class CoFB2RTFExport provides a Create and CreateRemote method to          
// create instances of the default interface IFB2RTFExport exposed by              
// the CoClass FB2RTFExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2RTFExport = class
    class function Create: IFB2RTFExport;
    class function CreateRemote(const MachineName: string): IFB2RTFExport;
  end;

// *********************************************************************//
// The Class CoFB2AnyQuickExport provides a Create and CreateRemote method to          
// create instances of the default interface IFB2AnyQuickExport exposed by              
// the CoClass FB2AnyQuickExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2AnyQuickExport = class
    class function Create: IFB2AnyQuickExport;
    class function CreateRemote(const MachineName: string): IFB2AnyQuickExport;
  end;

implementation

uses ComObj;

class function CoFB2_to_RTF_.Create: IFB2_to_rtf;
begin
  Result := CreateComObject(CLASS_FB2_to_RTF_) as IFB2_to_rtf;
end;

class function CoFB2_to_RTF_.CreateRemote(const MachineName: string): IFB2_to_rtf;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2_to_RTF_) as IFB2_to_rtf;
end;

class function CoFB2RTFExport.Create: IFB2RTFExport;
begin
  Result := CreateComObject(CLASS_FB2RTFExport) as IFB2RTFExport;
end;

class function CoFB2RTFExport.CreateRemote(const MachineName: string): IFB2RTFExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2RTFExport) as IFB2RTFExport;
end;

class function CoFB2AnyQuickExport.Create: IFB2AnyQuickExport;
begin
  Result := CreateComObject(CLASS_FB2AnyQuickExport) as IFB2AnyQuickExport;
end;

class function CoFB2AnyQuickExport.CreateRemote(const MachineName: string): IFB2AnyQuickExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2AnyQuickExport) as IFB2AnyQuickExport;
end;

end.
