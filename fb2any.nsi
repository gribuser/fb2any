SetCompressor bzip2
; Icon c:\icon.ico
; Default names
!define NAME "FB2 to Any"
!define NSPNAME "FB2ANY"
!define VENDOR "GribUser"
!define VERSION "1.0"

!define MUI_PRODUCT "FB2Any"
!define MUI_VERSION "1.0" ;Define your own software version here

; The name of the installer
;Name "${NAME}"
!include "MUI.nsh"

  !define MUI_LICENSEPAGE
  !define MUI_COMPONENTSPAGE
  !define MUI_DIRECTORYPAGE
  
  !define MUI_ABORTWARNING
  
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  !insertmacro MUI_LANGUAGE English

; The file to write
OutFile "FB2Any.exe"

; License text
;LicenseText "You must read the following license before installing:"
LicenseData "LICENSE.txt"

; The default installation directory
InstallDir "$PROGRAMFILES\${VENDOR}\${NAME}"
InstallDirRegKey HKLM "SOFTWARE\${VENDOR}\${NSPNAME}" "InstallDir"

; The text to prompt the user to enter a directory
;DirText "Please select a location to install ${NAME} (or use the default):"

; other settings
ShowInstDetails hide
ShowUninstDetails show

LangString DESC_SubSecFB2RTFscr ${LANG_ENGLISH} 'FB to RTF scripts.$\n$\nThis will allow you to run FB2RTF indirectly from "Start" menu. This will also add "Convert to *.rtf..." shell menu'
LangString DESC_Secfb2rtfscript ${LANG_ENGLISH} 'FB to RTF interactive$\n$\nThis will allow you to convert *.fb2 to rtf interactively'
LangString DESC_Secfb2rtfShell1 ${LANG_ENGLISH} 'Quick FB to RTF$\n$\nThis will add *.fb2 context menu "Quick convert to *.rtf" - two clicks to get rtf file'

LangString DESC_SubSecfb2txt ${LANG_ENGLISH} 'FB to TXT scripts.$\n$\nThis will allow you to run FB2TXT indirectly from "Start" menu. This will also add "Convert to *.txt..." shell menu'
LangString DESC_Secfb2txtscript ${LANG_ENGLISH} 'FB to TXT interactive$\n$\nThis will allow you to convert *.fb2 to txt interactively'
LangString DESC_Secfb2txtShell1 ${LANG_ENGLISH} 'Quick FB to TXT$\n$\nThis will add *.fb2 context menu "Quick convert to *.txt" - two clicks to get txt file'

LangString DESC_SubSecfb2lit ${LANG_ENGLISH} 'FB to LIT scripts.$\n$\nThis will allow you to run FB2LIT indirectly from "Start" menu. This will also add "Convert to *.lit..." shell menu'
LangString DESC_Secfb2litscript ${LANG_ENGLISH} 'FB to LIT interactive$\n$\nThis will allow you to convert *.fb2 to lit interactively'
LangString DESC_Secfb2litShell1 ${LANG_ENGLISH} 'Quick FB to LIT$\n$\nThis will add *.fb2 context menu "Quick convert to *.lit" - two clicks to get lit book'

LangString DESC_SubSecfb2iSilo ${LANG_ENGLISH} 'FB to iSilo scripts.$\n$\nThis will allow you to run FB2iSilo indirectly from "Start" menu. This will also add "Convert to iSilo *.pdb..." shell menu'
LangString DESC_Secfb2iSiloscript ${LANG_ENGLISH} 'FB to iSilo interactive$\n$\nThis will allow you to convert *.fb2 to iSilo pdb interactively'
LangString DESC_Secfb2iSiloShell1 ${LANG_ENGLISH} 'Quick FB to iSilo$\n$\nThis will add *.fb2 context menu "Quick convert to iSilo *.pdb" - two clicks to get lit book'


LangString DESC_SecFB2RB ${LANG_ENGLISH} 'Rocket/REB1100.$\n$\nThis will install tools to create *.rb-files and upload them to REB1100. Also you will be able to export from FictionBook editor to *.rb indirectly'


LangString DESC_SubSecFB2RBscr ${LANG_ENGLISH} 'FB to RB scripts.$\n$\nThis will allow you to run FB2RB indirectly from "Start" menu. This will also add "Convert to rb interactive" shell menu'
LangString DESC_SubSecShell1 ${LANG_ENGLISH} 'This will add *.fb2 context menu "Convert to RB" - two clicks to get RB file'
LangString DESC_SubSecShell2 ${LANG_ENGLISH} 'This will add *.fb2 context menu "Send to REB1100 (int)" - two clicks to send a book to your REB1100 device’s internal storage'
LangString DESC_SubSecShell3 ${LANG_ENGLISH} 'This will add *.fb2 context menu "Send to REB1100 (SM)" - two clicks to send a book to your REB1100 device’s smart media card in place'
LangString DESC_SubSecShell4 ${LANG_ENGLISH} 'This will add *.txt context menu "Convert to *.rb" - two clicks to get *.rb-file from text document. THIS FUTURE REQUIRES Any2FB'
LangString DESC_SubSecShell5 ${LANG_ENGLISH} 'This will add *.html context menu "Convert to *.rb" - two clicks to get *.rb-file from html document. THIS FUTURE REQUIRES Any2FB'
LangString DESC_SubSecShell6 ${LANG_ENGLISH} 'This will add *.doc context menu "Convert to *.rb" - two clicks to get *.rb-file from MSWord document. THIS FUTURE REQUIRES Any2FB'
LangString DESC_fb2BatchGroup ${LANG_ENGLISH} 'This will install flexible and powerful batch processor.'

Function .onInit
	GetDLLVersion "$SYSDIR\msxml4.dll" $R0 $R1
	IntOp $R2 $R0 / 0x00010000
	IntOp $R3 $R0 & 0x0000FFFF
	IntCmpU 4 $R2 MSXMLIsOK1 MSXMLIsOK1 MSXMLIsTooOld
	MSXMLIsOK1:
	IntCmpU 10 $R3 MSXMLIsOK MSXMLIsOK MSXMLIsTooOld
	MSXMLIsTooOld:
		MessageBox MB_YESNO "Your MSXML version is too old ($R2.$R3). You must have at least 4.10. Please install the latest MSXML and then install FB2Any$\n$\nShould installer now start downloading 'MSXML 4.0 sp2' (~5.0Mb) for you? " IDNO no
		ExecShell "" "http://www.gribuser.ru/xml/fictionbook/2.0/software/msxml_4.0_sp2.msi" SW_SHOWNORMAL
	no:
	MessageBox MB_OK|MB_ICONSTOP "Installation aborted!$\nPlease install MSXML 4.0 and retry."
	Quit
	MSXMLIsOK:
FunctionEnd

InstType "Generic"
InstType "Microsoft reader (*.lit)"
InstType "iSilo (iSilo *.pdb)"
InstType "REB1100/Rocket (*.rb)"
InstType "Full"


Section ""
  ; prepare install env
	SetShellVarContext All
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\${NAME}"
	SetShellVarContext All

	StrCpy $0 "0" ;reb1100 is off by default
	StrCpy $1 "0" ;rtf is off by default
	StrCpy $2 "0" ;hyphenator not required by default
	StrCpy $3 "0" ;TXT is off by default
	StrCpy $4 "0" ;LIT is off by default
	StrCpy $9 "$\n" ;Any2FB not required by default
	DeleteRegKey HKCR "FictionBook.2\shell\ToRBSM"
	DeleteRegKey HKCR "FictionBook.2\shell\ToREBInt"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRB"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRBInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRTF"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRTFInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToTXT"
	DeleteRegKey HKCR "FictionBook.2\shell\ToTXTInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToLIT"
	DeleteRegKey HKCR "FictionBook.2\shell\ToLITInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToiSilo"
	DeleteRegKey HKCR "FictionBook.2\shell\ToiSiloInteractive"
	DeleteRegKey HKCR "txtfile\shell\ToRB"
	DeleteRegKey HKCR "htmlfile\shell\ToRB"

	ReadRegStr $R0 HKCR ".doc" ""
	DeleteRegKey HKCR "$R0\shell\ToRB"
	WriteRegStr HKCR '.fb2' "" "FictionBook.2"
	WriteRegStr HKCR '.fb2' "Content Type" "text/xml"
	WriteRegStr HKCR '.fb2' "PerceivedType" "Text"
	SetOutPath "$SYSDIR"
	File "wscript.exe.manifest"
  SetOutPath $INSTDIR
	File "fb_2_any_readme.html"
	CreateShortCut "$SMPROGRAMS\${NAME}\ReadMe.lnk" "$INSTDIR\fb_2_any_readme.html"
SectionEnd

Function HyphInstall
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\fb2_hyph.dll" 0 nodll
    UnRegDll "$INSTDIR\fb2_hyph.dll"
  nodll:
  File "FB_hyph\fb2_hyph.dll"
  File "FB_hyph\chardat.xml"
  RegDll "$INSTDIR\fb2_hyph.dll"
FunctionEnd


Function REBCore
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\fb_2_rb.dll" 0 nodll1
    UnRegDll "$INSTDIR\fb_2_rb.dll"
  nodll1:
  File "FB_2_rb\fb_2_rb.dll"
	RegDll "$INSTDIR\fb_2_rb.dll"
  File "FB_2_rb\rbmake.exe"
	File "FB_2_rb\reb.xml"
	File "FB_2_rb\FB2_2_rb.xsl"
	File "FB_2_rb\FB2_2_html_basics.xsl"
	File "FB_2_rb\fb2rb_interactive.vbs"
	File "FB_2_rb\fb2rb_commandline.vbs"
	File "FB_2_rb\any2rb_interactive.vbs"
	CreateDirectory "$INSTDIR\MoreXSL"
  SetOutPath "$INSTDIR\MoreXSL"
	File "MoreXSL\readme.txt"
	CreateDirectory "$INSTDIR\MoreXSL\REB1100 by Shaman"
  SetOutPath "$INSTDIR\MoreXSL\REB1100 by Shaman"
	File "MoreXSL\REB1100 by Shaman\FB2_2_html_basics.xsl"
	File "MoreXSL\REB1100 by Shaman\FB2_2_rb.xsl"
FunctionEnd

Function RTFCore
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\fb_2_rtf.dll" 0 nodll2
    UnRegDll "$INSTDIR\fb_2_rtf.dll"
  nodll2:
  File "FB_2_rtf\fb_2_rtf.dll"
	RegDll "$INSTDIR\fb_2_rtf.dll"
	File "FB_2_rtf\FB2_2_rtf.xsl"
	File "FB_2_rtf\fb2rtf_interactive.vbs"
	File "FB_2_rtf\fb2rtf_commandline.vbs"
FunctionEnd

Function TXTCore
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\fb_2_txt.dll" 0 nodll3
    UnRegDll "$INSTDIR\fb_2_txt.dll"
  nodll3:
  File "FB_2_txt\fb_2_txt.dll"
	RegDll "$INSTDIR\fb_2_txt.dll"
	File "FB_2_txt\FB2_2_txt.xsl"
	File "FB_2_txt\fb2txt_interactive.vbs"
	File "FB_2_txt\fb2txt_commandline.vbs"
FunctionEnd

Function LITCore
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\fb_2_lit.dll" 0 nodll4
    UnRegDll "$INSTDIR\fb_2_lit.dll"
  nodll4:
  File "FB_2_lit\fb_2_lit.dll"
	RegDll "$INSTDIR\fb_2_lit.dll"
	File "FB_2_lit\litgen.dll"
	File "FB_2_lit\FB2_2_lit_opf.xsl"
	File "FB_2_lit\FB2_2_lit_xhtml.xsl"
	File "FB_2_lit\FB2_2_xhtml_basics.xsl"
	File "FB_2_lit\fb2lit_interactive.vbs"
	File "FB_2_lit\fb2lit_commandline.vbs"
FunctionEnd

Function iSiloCore
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\fb_2_iSilo.dll" 0 nodll4
    UnRegDll "$INSTDIR\fb_2_iSilo.dll"
  nodll4:
  File "FB_2_iSilo\fb_2_iSilo.dll"
	RegDll "$INSTDIR\fb_2_iSilo.dll"
	File "FB_2_iSilo\iSiloXC.exe"
	File "FB_2_iSilo\FB2_2_html.xsl"
	File "FB_2_iSilo\FB2_2_html_basics.xsl"
	File "FB_2_iSilo\FB2_2_iSilo_ixl.xsl"
	File "FB_2_iSilo\fb2iSilo_interactive.vbs"
	File "FB_2_iSilo\fb2iSilo_commandline.vbs"
FunctionEnd

SubSection "FB2 to RTF" SubSecfb2rtf
	Section "!FB2RTF interactive" Secfb2rtfscript
		SetShellVarContext All
	  CreateShortCut "$SMPROGRAMS\${NAME}\FB to RTF.lnk" "$INSTDIR\fb2rtf_interactive.vbs" "" "$INSTDIR\fb_2_rtf.dll"
		WriteRegStr HKCR "FictionBook.2\shell\ToRTFInteractive" "" "&Convert to *.rtf..."
		WriteRegStr HKCR "FictionBook.2\shell\ToRTFInteractive\command" "" 'wscript.exe "$INSTDIR\fb2rtf_interactive.vbs" "%L"'
    StrCpy $1 "1"
		SectionIn 1
		SectionIn 5
	SectionEnd
	Section 'FB2RTF Quick' Secfb2rtfShell1
		SetShellVarContext All
		WriteRegStr HKCR "FictionBook.2\shell\ToRTF" "" "Quick convert to *.rtf"
		WriteRegStr HKCR "FictionBook.2\shell\ToRTF\command" "" 'wscript.exe "$INSTDIR\fb2rtf_commandline.vbs" "%L"'
    StrCpy $1 "1"
		SectionIn 5
	SectionEnd
SubSectionEnd

SubSection "FB2 to TXT" SubSecfb2txt
	Section "!FB2TXT interactive" Secfb2txtscript
		SetShellVarContext All
	  SetOutPath $INSTDIR
	  CreateShortCut "$SMPROGRAMS\${NAME}\FB to TXT.lnk" "$INSTDIR\fb2txt_interactive.vbs" "" "$INSTDIR\fb_2_txt.dll"
		WriteRegStr HKCR "FictionBook.2\shell\ToTXTInteractive" "" "&Convert to *.txt..."
		WriteRegStr HKCR "FictionBook.2\shell\ToTXTInteractive\command" "" 'wscript.exe "$INSTDIR\fb2txt_interactive.vbs" "%L"'
    StrCpy $3 "1"
    StrCpy $2 "1"
		SectionIn 1
		SectionIn 5
	SectionEnd
	Section 'FB2TXT Quick' Secfb2txtShell1
		SetShellVarContext All
		WriteRegStr HKCR "FictionBook.2\shell\ToTXT" "" "Quick convert to *.txt"
		WriteRegStr HKCR "FictionBook.2\shell\ToTXT\command" "" 'wscript.exe "$INSTDIR\fb2txt_commandline.vbs" "%L"'
    StrCpy $3 "1"
    StrCpy $2 "1"
		SectionIn 5
	SectionEnd
SubSectionEnd

SubSection "FB2 to LIT" SubSecfb2lit
	Section "!FB2LIT interactive" Secfb2litscript
		SetShellVarContext All
	  CreateShortCut "$SMPROGRAMS\${NAME}\FB to LIT.lnk" "$INSTDIR\fb2lit_interactive.vbs" "" "$INSTDIR\fb_2_lit.dll"
		WriteRegStr HKCR "FictionBook.2\shell\ToLITInteractive" "" "&Convert to *.lit..."
		WriteRegStr HKCR "FictionBook.2\shell\ToLITInteractive\command" "" 'wscript.exe "$INSTDIR\fb2lit_interactive.vbs" "%L"'
    StrCpy $4 "1"
		SectionIn 1
		SectionIn 2
		SectionIn 5
	SectionEnd
	Section 'FB2LIT Quick' Secfb2litShell1
		SetShellVarContext All
		WriteRegStr HKCR "FictionBook.2\shell\ToLIT" "" "Quick convert to *.lit"
		WriteRegStr HKCR "FictionBook.2\shell\ToLIT\command" "" 'wscript.exe "$INSTDIR\fb2lit_commandline.vbs" "%L"'
    StrCpy $4 "1"
		SectionIn 2
		SectionIn 5
	SectionEnd
SubSectionEnd

SubSection "FB2 to iSilo" SubSecfb2iSilo
	Section "!FB2iSolo interactive" Secfb2iSiloscript
		SetShellVarContext All
	  CreateShortCut "$SMPROGRAMS\${NAME}\FB to iSilo.lnk" "$INSTDIR\fb2iSilo_interactive.vbs" "" "$INSTDIR\fb_2_iSilo.dll"
		WriteRegStr HKCR "FictionBook.2\shell\ToiSiloInteractive" "" "&Convert to iSilo *.pdb..."
		WriteRegStr HKCR "FictionBook.2\shell\ToiSiloInteractive\command" "" 'wscript.exe "$INSTDIR\fb2iSilo_interactive.vbs" "%L"'
    StrCpy $5 "1"
		SectionIn 1
		SectionIn 3
		SectionIn 5
	SectionEnd
	Section 'FB2iSilo Quick' Secfb2iSiloShell1
		SetShellVarContext All
		WriteRegStr HKCR "FictionBook.2\shell\ToiSilo" "" "Quick convert to iSilo *.pdb"
		WriteRegStr HKCR "FictionBook.2\shell\ToiSilo\command" "" 'wscript.exe "$INSTDIR\fb2iSilo_commandline.vbs" "%L"'
    StrCpy $5 "1"
		SectionIn 3
		SectionIn 5
	SectionEnd
SubSectionEnd


SubSection "FB2 to RB" SubSecfb2rb
	Section "!FB2RB interactive" Secfb2rbscript
		SetShellVarContext All
	  CreateShortCut "$SMPROGRAMS\${NAME}\FB to RB.lnk" "$INSTDIR\fb2rb_interactive.vbs" "" "$INSTDIR\fb_2_rb.dll"
		WriteRegStr HKCR "FictionBook.2\shell\ToRBInteractive" "" "&Convert to *.rb..."
		WriteRegStr HKCR "FictionBook.2\shell\ToRBInteractive\command" "" 'wscript.exe "$INSTDIR\fb2rb_interactive.vbs" "%L"'
    StrCpy $0 "1"
    StrCpy $2 "1"
		SectionIn 1
		SectionIn 4
		SectionIn 5
	SectionEnd
	Section 'fb2: "Send to REB1100 (SM)"' Secfb2rbShell3
		SetShellVarContext All
		File "FB_2_rb\fb2rb_commandline.vbs"
		WriteRegStr HKCR "FictionBook.2\shell\ToRBSM" "" "&Send to REB1100 (SM)"
		WriteRegStr HKCR "FictionBook.2\shell\ToRBSM\command" "" 'wscript.exe "$INSTDIR\fb2rb_commandline.vbs" "%L" :REBSM'
    StrCpy $0 "1"
    StrCpy $2 "1"
		SectionIn 4
		SectionIn 5
	SectionEnd
	Section 'fb2: "Send to REB1100 (int)"' Secfb2rbShell2
		SetShellVarContext All
		File "FB_2_rb\fb2rb_commandline.vbs"
		WriteRegStr HKCR "FictionBook.2\shell\ToREBInt" "" "Send to REB1100 (&int)"
		WriteRegStr HKCR "FictionBook.2\shell\ToREBInt\command" "" 'wscript.exe "$INSTDIR\fb2rb_commandline.vbs" "%L" :REBINT'
    StrCpy $0 "1"
    StrCpy $2 "1"
		SectionIn 4
		SectionIn 5
	SectionEnd
	Section 'fb2: item "Convert to RB"' Secfb2rbShell1
		SetShellVarContext All
		WriteRegStr HKCR "FictionBook.2\shell\ToRB" "" "Quick convert to *.rb"
		WriteRegStr HKCR "FictionBook.2\shell\ToRB\command" "" 'wscript.exe "$INSTDIR\fb2rb_commandline.vbs" "%L"'
    StrCpy $0 "1"
    StrCpy $2 "1"
		SectionIn 4
		SectionIn 5
	SectionEnd
	Section 'txt: item "Convert to RB"' Secfb2rbShell4
		SetShellVarContext All
		WriteRegStr HKCR "txtfile\shell\ToRB" "" "&Convert to *rb..."
		WriteRegStr HKCR "txtfile\shell\ToRB\command" "" 'wscript.exe "$INSTDIR\any2rb_interactive.vbs" "%L"'
    StrCpy $0 "1"
    StrCpy $2 "1"
    StrCpy $9 "$\n- txt shell menu: item 'Convert to RB'$9"
		SectionIn 5
	SectionEnd
	Section 'html: item "Convert to RB"' Secfb2rbShell5
		SetShellVarContext All
		WriteRegStr HKCR "htmlfile\shell\ToRB" "" "&Convert to *.rb..."
		WriteRegStr HKCR "htmlfile\shell\ToRB\command" "" 'wscript.exe "$INSTDIR\any2rb_interactive.vbs" "%L"'
    StrCpy $0 "1"
    StrCpy $2 "1"
    StrCpy $9 "$\n- html shell menu: item 'Convert to RB'$9"
		SectionIn 5
	SectionEnd
	Section 'doc: item "Convert to RB"' Secfb2rbShell6
		SetShellVarContext All
		ReadRegStr $R0 HKCR ".doc" ""
		WriteRegStr HKCR "$R0\shell\ToRB" "" "&Convert to *.rb..."
		WriteRegStr HKCR "$R0\shell\ToRB\command" "" 'wscript.exe "$INSTDIR\any2rb_interactive.vbs" "%L"'
    StrCpy $0 "1"
    StrCpy $2 "1"
    StrCpy $9 "$\n- doc shell menu: item 'Convert to RB'$9"
		SectionIn 5
	SectionEnd
SubSectionEnd

Section 'FB2Batch' fb2BatchGroup
	SetShellVarContext All
  SetOutPath $INSTDIR
	File "fb2batch\fb2batch.exe"
  CreateShortCut "$SMPROGRAMS\${NAME}\FB2Batch.lnk" "$INSTDIR\fb2batch.exe" "" "$INSTDIR\fb2batch.exe"
	SectionIn 1
	SectionIn 2
	SectionIn 3
	SectionIn 4
	SectionIn 5
SectionEnd



Section "" ;; finalize install 3 0
	StrCmp $0 '0' noREb
		Call REBCore
	noREb:
	StrCmp $1 '0' noRTF
		Call RTFCore
	noRTF:
	StrCmp $2 '0' noHYPH
		Call HyphInstall
	noHYPH:
	StrCmp $3 '0' noTXT
		Call TXTCore
	noTXT:
	StrCmp $3 '0' noLIT
		Call LITCore
	noLIT:
	StrCmp $4 '0' noiSilo
		Call iSiloCore
	noiSilo:

	ClearErrors
	StrCmp $9 "$\n" noReqAny2FB
		ReadRegStr $R0 HKCR "any_2_fb2.Any2FB2" ""
		IfErrors NoAny2FB Any2FBHere
		NoAny2FB:
			MessageBox MB_YESNO|MB_ICONQUESTION "You have selected the following Any2FB-dependent components:$\n$9$\n$\nYou will have to install Any2FB to use them. Would you like do download it now?" IDNO noAny2FBInstall
			ExecShell "" "http://www.gribuser.ru/xml/fictionbook/2.0/software/Any2FB2.exe" SW_SHOWNORMAL
			noAny2FBInstall:
		Any2FBHere:
	noReqAny2FB:
  SetOutPath $INSTDIR
	SetShellVarContext All
  ; Uninstall shortcut
  CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${VENDOR}\${NSPNAME}" "InstallDir" "$INSTDIR"
  ; Uninstall info
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "DisplayName" "${VENDOR} ${NAME} ${VERSION} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  ; uninstall program
  WriteUninstaller "uninstall.exe"

	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "NoRepair" 1
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "DisplayVersion" '${MUI_VERSION}'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "URLInfoAbout" 'http://www.gribuser.ru'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "Publisher" '${VENDOR}'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}" "URLUpdateInfo" 'http://www.gribuser.ru/xml/fictionbook/2.0/software/'
SectionEnd

; Uninstall support
;UninstallText "This will uninstall ${VENDOR} ${NAME}. Hit Uninstall to continue."


Section "Uninstall"
  ; remove plugin
	SetShellVarContext All
  UnRegDll "$INSTDIR\fb_2_rb.dll"
  UnRegDll "$INSTDIR\fb_2_rtf.dll"
  UnRegDll "$INSTDIR\fb2_hyph.dll"
  UnRegDll "$INSTDIR\fb_2_txt.dll"
  UnRegDll "$INSTDIR\fb_2_lit.dll"
	UnRegDll "$INSTDIR\fb_2_iSilo.dll"
  Delete "$INSTDIR\fb_2_rb.dll"
  Delete "$INSTDIR\fb_2_rtf.dll"
  Delete "$INSTDIR\fb_2_txt.dll"
  Delete "$INSTDIR\fb2_hyph.dll"
  Delete "$INSTDIR\chardat.xml"
  Delete "$INSTDIR\rbmake.exe"
	Delete "$INSTDIR\reb.xml"
	Delete "$INSTDIR\FB2_2_rb.xsl"
	Delete "$INSTDIR\FB2_2_rtf.xsl"
	Delete "$INSTDIR\FB2_2_txt.xsl"
	Delete "$INSTDIR\FB2_2_html_basics.xsl"
	Delete "$INSTDIR\fb2rb_commandline.vbs"
	Delete "$INSTDIR\fb2rb_interactive.vbs"
	Delete "$INSTDIR\any2rb_interactive.vbs"
	Delete "$INSTDIR\fb2rtf_commandline.vbs"
	Delete "$INSTDIR\fb2rtf_interactive.vbs"
	Delete "$INSTDIR\fb2txt_commandline.vbs"
	Delete "$INSTDIR\fb2txt_interactive.vbs"

	Delete "$INSTDIR\fb_2_lit.dll"
	Delete "$INSTDIR\litgen.dll"
	Delete "$INSTDIR\FB2_2_lit_opf.xsl"
	Delete "$INSTDIR\FB2_2_lit_xhtml.xsl"
	Delete "$INSTDIR\FB2_2_xhtml_basics.xsl"
	Delete "$INSTDIR\fb2lit_interactive.vbs"
	Delete "$INSTDIR\fb2lit_commandline.vbs"

  Delete "$INSTDIR\fb_2_iSilo.dll"
	Delete "$INSTDIR\iSiloXC.exe"
	Delete "$INSTDIR\FB2_2_html.xsl"
	Delete "$INSTDIR\FB2_2_html_basics.xsl"
	Delete "$INSTDIR\FB2_2_iSilo_ixl.xsl"
	Delete "$INSTDIR\fb2iSilo_interactive.vbs"
	Delete "$INSTDIR\fb2iSilo_commandline.vbs"
	Delete "$INSTDIR\fb2batch.exe"
	
;	RMDir /r "$INSTDIR\src"

  ; MUST REMOVE UNINSTALLER, too
  Delete "$INSTDIR\uninstall.exe"

  ; remove shortcuts, if any.
;  Delete "$SMPROGRAMS\${NAME}\*.*"

  ; remove directories used.
  RMDir /r "$SMPROGRAMS\${NAME}"
  RMDir "$INSTDIR"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VENDOR} ${NSPNAME}"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRBSM"
	DeleteRegKey HKCR "FictionBook.2\shell\ToREBInt"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRB"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRBInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRTF"
	DeleteRegKey HKCR "FictionBook.2\shell\ToRTFInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToTXT"
	DeleteRegKey HKCR "FictionBook.2\shell\ToTXTInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToLIT"
	DeleteRegKey HKCR "FictionBook.2\shell\ToLITInteractive"
	DeleteRegKey HKCR "FictionBook.2\shell\ToiSilo"
	DeleteRegKey HKCR "FictionBook.2\shell\ToiSiloInteractive"
	DeleteRegKey HKCR "txtfile\shell\ToRB"
	DeleteRegKey HKCR "htmlfile\shell\ToRB"
	ReadRegStr $R0 HKCR ".doc" ""
	DeleteRegKey HKCR "$R0\shell\ToRB"
SectionEnd

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SubSecfb2rtf} $(DESC_SubSecFB2RTFscr)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rtfscript} $(DESC_Secfb2rtfscript)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rtfShell1} $(DESC_Secfb2rtfShell1)
	!insertmacro MUI_DESCRIPTION_TEXT ${SubSecfb2txt} $(DESC_SubSecfb2txt)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2txtscript} $(DESC_Secfb2txtscript)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2txtShell1} $(DESC_Secfb2txtShell1)
	!insertmacro MUI_DESCRIPTION_TEXT ${SubSecfb2lit} $(DESC_SubSecfb2lit)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2litscript} $(DESC_Secfb2litscript)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2litShell1} $(DESC_Secfb2litShell1)

	!insertmacro MUI_DESCRIPTION_TEXT ${SubSecfb2iSilo} $(DESC_SubSecfb2iSilo)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2iSiloscript} $(DESC_Secfb2iSiloscript)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2iSiloShell1} $(DESC_Secfb2iSiloShell1)

  !insertmacro MUI_DESCRIPTION_TEXT ${SubSecfb2rb} $(DESC_SecFB2RB)
	!insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rtfShell1} $(DESC_Secfb2rtfShell1)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbscript} $(DESC_SubSecFB2RBscr)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbShell1} $(DESC_SubSecShell1)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbShell2} $(DESC_SubSecShell2)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbShell3} $(DESC_SubSecShell3)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbShell4} $(DESC_SubSecShell4)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbShell5} $(DESC_SubSecShell5)
  !insertmacro MUI_DESCRIPTION_TEXT ${Secfb2rbShell6} $(DESC_SubSecShell6)
  !insertmacro MUI_DESCRIPTION_TEXT ${fb2BatchGroup} $(DESC_fb2BatchGroup)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END
