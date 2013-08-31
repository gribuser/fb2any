unit FB2_hyph_TLB;

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
// File generated on 19.09.2004 17:24:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Work\FB_2_any\FB_hyph\fb2_hyph.tlb (1)
// LIBID: {ADCE713C-38A2-46E6-B80B-00B76E05F20B}
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
  FB2_hyphMajorVersion = 1;
  FB2_hyphMinorVersion = 0;

  LIBID_FB2_hyph: TGUID = '{ADCE713C-38A2-46E6-B80B-00B76E05F20B}';

  IID_IFB2Hyphenator: TGUID = '{0DF85F57-4C29-4F0B-9EED-E1EB6A2C3D67}';
  CLASS_FB2Hyphenator: TGUID = '{B49622FB-3D5C-40EC-B838-107E4871BC8C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFB2Hyphenator = interface;
  IFB2HyphenatorDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FB2Hyphenator = IFB2Hyphenator;


// *********************************************************************//
// Interface: IFB2Hyphenator
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0DF85F57-4C29-4F0B-9EED-E1EB6A2C3D67}
// *********************************************************************//
  IFB2Hyphenator = interface(IDispatch)
    ['{0DF85F57-4C29-4F0B-9EED-E1EB6A2C3D67}']
    procedure Hyphenate(const document: IDispatch); safecall;
    procedure Set_deviceDescr(const Param1: IDispatch); safecall;
    function  Get_fontList: OleVariant; safecall;
    function  Get_currentFont: OleVariant; safecall;
    procedure Set_currentFont(Value: OleVariant); safecall;
    function  Get_fontSizeList: OleVariant; safecall;
    function  Get_currentFontSize: OleVariant; safecall;
    procedure Set_currentFontSize(Value: OleVariant); safecall;
    function  Get_deviceSizeList: OleVariant; safecall;
    function  Get_currentDeviceSize: OleVariant; safecall;
    procedure Set_currentDeviceSize(Value: OleVariant); safecall;
    function  Get_hyphStr: OleVariant; safecall;
    procedure Set_hyphStr(Value: OleVariant); safecall;
    function  Get_strPrefix: OleVariant; safecall;
    procedure Set_strPrefix(Value: OleVariant); safecall;
    function  Get_plainOnly: WordBool; safecall;
    procedure Set_plainOnly(Value: WordBool); safecall;
    property deviceDescr: IDispatch write Set_deviceDescr;
    property fontList: OleVariant read Get_fontList;
    property currentFont: OleVariant read Get_currentFont write Set_currentFont;
    property fontSizeList: OleVariant read Get_fontSizeList;
    property currentFontSize: OleVariant read Get_currentFontSize write Set_currentFontSize;
    property deviceSizeList: OleVariant read Get_deviceSizeList;
    property currentDeviceSize: OleVariant read Get_currentDeviceSize write Set_currentDeviceSize;
    property hyphStr: OleVariant read Get_hyphStr write Set_hyphStr;
    property strPrefix: OleVariant read Get_strPrefix write Set_strPrefix;
    property plainOnly: WordBool read Get_plainOnly write Set_plainOnly;
  end;

// *********************************************************************//
// DispIntf:  IFB2HyphenatorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0DF85F57-4C29-4F0B-9EED-E1EB6A2C3D67}
// *********************************************************************//
  IFB2HyphenatorDisp = dispinterface
    ['{0DF85F57-4C29-4F0B-9EED-E1EB6A2C3D67}']
    procedure Hyphenate(const document: IDispatch); dispid 1;
    property deviceDescr: IDispatch writeonly dispid 4;
    property fontList: OleVariant readonly dispid 5;
    property currentFont: OleVariant dispid 6;
    property fontSizeList: OleVariant readonly dispid 7;
    property currentFontSize: OleVariant dispid 8;
    property deviceSizeList: OleVariant readonly dispid 9;
    property currentDeviceSize: OleVariant dispid 10;
    property hyphStr: OleVariant dispid 2;
    property strPrefix: OleVariant dispid 3;
    property plainOnly: WordBool dispid 11;
  end;

// *********************************************************************//
// The Class CoFB2Hyphenator provides a Create and CreateRemote method to          
// create instances of the default interface IFB2Hyphenator exposed by              
// the CoClass FB2Hyphenator. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFB2Hyphenator = class
    class function Create: IFB2Hyphenator;
    class function CreateRemote(const MachineName: string): IFB2Hyphenator;
  end;

implementation

uses ComObj;

class function CoFB2Hyphenator.Create: IFB2Hyphenator;
begin
  Result := CreateComObject(CLASS_FB2Hyphenator) as IFB2Hyphenator;
end;

class function CoFB2Hyphenator.CreateRemote(const MachineName: string): IFB2Hyphenator;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FB2Hyphenator) as IFB2Hyphenator;
end;

end.
