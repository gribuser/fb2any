Set args = WScript.Arguments
if args.Count=0 then
  WScript.Echo "Usage: fb2rb_commandline.vbs <infile> [filename|:REBINT|:REBSM] [options]" & vbCrLf & vbCrLf &_
	  "Second paremeter may be a file name or a special parameter :REBINT or :REBSM" & vbCrLf & vbCrLf &_
		"Options available:" & vbCrLf &_
		"  -i   Skip ALL images" & vbCrLf &_
		"  -c   Skip cover page" & vbCrLf &_
		"  -d   skip description" & vbCrLf &_
		"  -tt   translit title" & vbCrLf &_
		"  -st   short TOC items" & vbCrLf &_
		"  -t0|-t1|-t3|-tall   TOC levels (0,1,3,all, 2 is default)" & vbCrLf &_
		"  -pb0|-pb1|-pb3|-pball   insert page-breaks for n-level headers" & vbCrLf &_
		"  -xpath <xslpath>    custom xsl file" & vbCrLf &_
		"  -hf <hyphfontname>   hyphenate for this font (see reb.xml file for available values)" & vbCrLf &_
		"  -hlandscape   hyphenate for Landscape mode (Portrait is default)" & vbCrLf &_
		"  -hLARGE   Hyphenate for Large font size (small is default)" & vbCrLf  & vbCrLf &_
		"You may also edit this script to accomplish more dedicated tasks"
  WScript.Quit 0
end if

On Error resume next
Set FBApp = CreateObject("FB2_to_RB.FB2RBExport")
If Err Then
  WScript.Echo "Unable to create ActiveX object ""FB2_to_RB.FB2RBExport"". This may be because of the incorrect setup."&_
		vbCrLf & vbCrLf & "Please reinstall the program and try rinning this script again."
  WScript.Quit 1
end if

FBApp.LoadLastSettingsFromReg

installFolder=WScript.ScriptFullName
Set regEx = New RegExp
regEx.Pattern = "\\[^\\]+\.vbs$"
regEx.IgnoreCase = True
installFolder = regEx.Replace(installFolder, "")

dim filefolder

if args.Count=1 or Left(args(1),1)="-" then
  regEx.Pattern = "\.[^\.]+$"
  filefolder = regEx.Replace(args(0),"") & ".rb"
else
  filefolder = args(1)
end if

xslpath=installFolder & "\FB2_2_rb.xsl"
hyphFont=""
hyphOrientation="Portrait"
hyphLarge="Small"


for i=2 to args.Count-1
	Select Case args(i)
		Case "-i" FBApp.SkipImages = True
		Case "-c" FBApp.SkipCover = True
		Case "-d" FBApp.SkipDescr = True
		Case "-tt" FBApp.TransLitTitle = True
		Case "-st" FBApp.ShortTOCLines = True
		Case "-t0" FBApp.TOCLevels = 0
		Case "-t1" FBApp.TOCLevels = 1
		Case "-t3" FBApp.TOCLevels = 3
		Case "-tall" FBApp.TOCLevels = 4
		Case "-pb0" FBApp.PageBreaksForLevels = 0
		Case "-pb1" FBApp.PageBreaksForLevels = 1
		Case "-pb3" FBApp.PageBreaksForLevels = 3
		Case "-pball" FBApp.PageBreaksForLevels = 4
		Case "-xpath" xslpath = args(i+1)
		Case "-hf" hyphFont = args(i+1)
		Case "-hlandscape" hyphOrientation = "Landscape"
		Case "-hLARGE" hyphLarge = "Large"
	End Select
next

if hyphFont <> "" then
  Set DevDescr = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
	DevDescr.preserveWhiteSpace = true
	DevDescr.load(installFolder+"\reb.xml")
	Set FBApp.Hyphenator = CreateObject("fb2_hyph.FB2Hyphenator")
	set FBApp.Hyphenator.deviceDescr=DevDescr
  FBApp.Hyphenator.plainOnly = False
  FBApp.Hyphenator.plainOnly = False
	FBApp.Hyphenator.hyphStr = "- "
	FBApp.Hyphenator.currentFont = hyphFont
	FBApp.Hyphenator.currentDeviceSize = hyphOrientation
	FBApp.Hyphenator.currentFontSize = hyphLarge
end if

On Error GoTo 0

Set FBApp.XSL = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
FBApp.XSL.load(xslpath)

if filefolder = ":REBSM" then
  FBApp.SaveTo = 2
else
  if filefolder = ":REBINT" then
    FBApp.SaveTo = 1
	else
    FBApp.SaveTo = 0
		FBApp.FileName = filefolder
	end if
end if

set InDoc =  WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
InDoc.load(args(0))

FBApp.convert(InDoc)