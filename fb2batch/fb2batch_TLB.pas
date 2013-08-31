unit fb2batch_TLB;

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
// File generated on 31.01.2005 16:57:56 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Work\FB_2_any\fb2batch\fb2batch.tlb (1)
// LIBID: {7539E335-30DA-49EC-B5B9-36697DB55C48}
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
  fb2batchMajorVersion = 1;
  fb2batchMinorVersion = 0;

  LIBID_fb2batch: TGUID = '{7539E335-30DA-49EC-B5B9-36697DB55C48}';

  IID_Iasasad: TGUID = '{7B40AC5E-A2CC-415C-8D8B-8757FDF5C406}';
  CLASS_asasad: TGUID = '{636721A5-39EF-4D24-A3C4-9670E192A525}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  Iasasad = interface;
  IasasadDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  asasad = Iasasad;


// *********************************************************************//
// Interface: Iasasad
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B40AC5E-A2CC-415C-8D8B-8757FDF5C406}
// *********************************************************************//
  Iasasad = interface(IDispatch)
    ['{7B40AC5E-A2CC-415C-8D8B-8757FDF5C406}']
  end;

// *********************************************************************//
// DispIntf:  IasasadDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B40AC5E-A2CC-415C-8D8B-8757FDF5C406}
// *********************************************************************//
  IasasadDisp = dispinterface
    ['{7B40AC5E-A2CC-415C-8D8B-8757FDF5C406}']
  end;

// *********************************************************************//
// The Class Coasasad provides a Create and CreateRemote method to          
// create instances of the default interface Iasasad exposed by              
// the CoClass asasad. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Coasasad = class
    class function Create: Iasasad;
    class function CreateRemote(const MachineName: string): Iasasad;
  end;

implementation

uses ComObj;

class function Coasasad.Create: Iasasad;
begin
  Result := CreateComObject(CLASS_asasad) as Iasasad;
end;

class function Coasasad.CreateRemote(const MachineName: string): Iasasad;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_asasad) as Iasasad;
end;

end.
