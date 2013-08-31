unit FB2_to_RB_TLB;

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
// File generated on 31.01.2005 21:15:02 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Work\FB_2_any\FB_2_rb\fb_2_rb.tlb (1)
// LIBID: {7917C17F-2D4A-48F0-93BB-90B43621E1E2}
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
  FB2_to_RBMajorVersion = 1;
  FB2_to_RBMinorVersion = 0;

  LIBID_FB2_to_RB: TGUID = '{7917C17F-2D4A-48F0-93BB-90B43621E1E2}';

  IID_IFBEExportPlugin: TGUID = '{1AFAAB7F-6F66-4EF6-B199-16FA49CC5B52}';
  CLASS_FB2_2_RB_FBE_export: TGUID = '{AF1DCC45-F1E2-424C-A20A-30516168ADE3}';
  IID_IFB2RBExport: TGUID = '{1CE40DB5-942C-4223-9B6A-004D84B3E3F8}';
  CLASS_FB2RBExport: TGUID = '{FBC7F975-3725-490E-B1E1-FB9F92F2B727}';
  IID_IFB2AnyQuickExport: TGUID = '{72F1BD3E-8658-4C65-9804-5DCB684BBFE2}';
  CLASS_FB2AnyQuickExport: TGUID = '{C545EE63-4548-4C42-BF4E-3688D873C6C0}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFBEExportPlugin = interface;
  IFB2RBExport = interface;
  IFB2RBExportDisp = dispinterface;
  IFB2AnyQuickExport = interface;
  IFB2AnyQuickExportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FB2_2_RB_FBE_export = IFBEExportPlugin;
  FB2RBExport = IFB2RBExport;
  FB2AnyQuickExport = IFB2AnyQuickExport;


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
// Interface: IFB2RBExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CE40DB5-942C-4223-9B6A-004D84B3E3F8}
// *********************************************************************//
  IFB2RBExport = interface(IDispatch)
    ['{1CE40DB5-942C-4223-9B6A-004D84B3E3F8}']
    function  Get_SkipDescr: WordBool; safecall;
    procedure Set_SkipDescr(Value: WordBool); safecall;
    function  Get_SkipImages: WordBool; safecall;
    procedure Set_SkipImages(Value: WordBool); safecall;
    function  Get_SkipCover: WordBool; safecall;
    procedure Set_SkipCover(Value: WordBool); safecall;
    function  Get_TransLitTitle: WordBool; safecall;
    procedure Set_TransLitTitle(Value: WordBool); safecall;
    function  Get_ShortTOCLines: WordBool; safecall;
    procedure Set_ShortTOCLines(Value: WordBool); safecall;
    function  Get_TOCLevels: Integer; safecall;
    procedure Set_TOCLevels(Value: Integer); safecall;
    function  Get_PageBreaksForLevels: Integer; safecall;
    procedure Set_PageBreaksForLevels(Value: Integer); safecall;
    function  Get_SaveTo: OleVariant; safecall;
    procedure Set_SaveTo(Value: OleVariant); safecall;
    function  Get_Hyphenator: IDispatch; safecall;
    procedure Set_Hyphenator(const Value: IDispatch); safecall;
    function  Get_XSL: IDispatch; safecall;
    procedure Set_XSL(const Value: IDispatch); safecall;
    function  Get_RBMakePath: OleVariant; safecall;
    procedure Set_RBMakePath(Value: OleVariant); safecall;
    function  Get_HOwner: Integer; safecall;
    procedure Set_HOwner(Value: Integer); safecall;
    procedure Convert(const document: IDispatch); safecall;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); safecall;
    function  Get_filename: OleVariant; safecall;
    procedure Set_filename(Value: OleVariant); safecall;
    procedure LoadLastSettingsFromReg; safecall;
    procedure LoadLastSettingsFromReg_(key: OleVariant); safecall;
    property SkipDescr: WordBool read Get_SkipDescr write Set_SkipDescr;
    property SkipImages: WordBool read Get_SkipImages write Set_SkipImages;
    property SkipCover: WordBool read Get_SkipCover write Set_SkipCover;
    property TransLitTitle: WordBool read Get_TransLitTitle write Set_TransLitTitle;
    property ShortTOCLines: WordBool read Get_ShortTOCLines write Set_ShortTOCLines;
    property TOCLevels: Integer read Get_TOCLevels write Set_TOCLevels;
    property PageBreaksForLevels: Integer read Get_PageBreaksForLevels write Set_PageBreaksForLevels;
    property SaveTo: OleVariant read Get_SaveTo write Set_SaveTo;
    property Hyphenator: IDispatch read Get_Hyphenator write Set_Hyphenator;
    property XSL: IDispatch read Get_XSL write Set_XSL;
    property RBMakePath: OleVariant read Get_RBMakePath write Set_RBMakePath;
    property HOwner: Integer read Get_HOwner write Set_HOwner;
    property filename: OleVariant read Get_filename write Set_filename;
  end;

// *********************************************************************//
// DispIntf:  IFB2RBExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CE40DB5-942C-4223-9B6A-004D84B3E3F8}
// *********************************************************************//
  IFB2RBExportDisp = dispinterface
    ['{1CE40DB5-942C-4223-9B6A-004D84B3E3F8}']
    property SkipDescr: WordBool dispid 1;
    property SkipImages: WordBool dispid 2;
    property SkipCover: WordBool dispid 3;
    property TransLitTitle: WordBool dispid 4;
    property ShortTOCLines: WordBool dispid 5;
    property TOCLevels: Integer dispid 6;
    property PageBreaksForLevels: Integer dispid 7;
    property SaveTo: OleVariant dispid 8;
    property Hyphenator: IDispatch dispid 9;
    property XSL: IDispatch dispid 10;
    property RBMakePath: OleVariant dispid 11;
    property HOwner: Integer dispid 12;
    procedure Convert(const document: IDispatch); dispid 13;
    procedure ConvertInteractive(hWnd: Integer; filename: OleVariant; const document: IDispatch); dispid 14;
    property filename: OleVariant dispid 15;
    procedure LoadLastSettingsFromReg; dispid 16;
    procedure LoadLastSettingsFromReg_(key: OleVariant); dispid 17;
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

// *********************************************************************//
// The Class CoFB2RBExport provides a Create and CreateRemote method to          
// create instances of the default interface IFB2RBExport exposed by              
// the CoClass FB2RBExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2RBExport = class
    class function Create: IFB2RBExport;
    class function CreateRemote(const MachineName: string): IFB2RBExport;
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

class function CoFB2_2_RB_FBE_export.Create: IFBEExportPlugin;
begin
  Result := CreateComObject(CLASS_FB2_2_RB_FBE_export) as IFBEExportPlugin;
end;

class function CoFB2_2_RB_FBE_export.CreateRemote(const MachineName: string): IFBEExportPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2_2_RB_FBE_export) as IFBEExportPlugin;
end;

class function CoFB2RBExport.Create: IFB2RBExport;
begin
  Result := CreateComObject(CLASS_FB2RBExport) as IFB2RBExport;
end;

class function CoFB2RBExport.CreateRemote(const MachineName: string): IFB2RBExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2RBExport) as IFB2RBExport;
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
