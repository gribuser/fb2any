Set args = WScript.Arguments
if args.Count=0 then
  WScript.Echo "Usage: fb2iSilo_commandline.vbs <infile> [outfile] [options]" & vbCrLf & vbCrLf &_
		"Options available:" & vbCrLf &_
		"  -i   Skip ALL images" & vbCrLf &_
		"  -t0|-t1|-t3|-tall   TOC levels (0,1,3,all, 2 is default)" & vbCrLf & vbCrLf &_
		"You may also edit this script to accomplish more dedicated tasks"
  WScript.Quit 0
end if


On Error resume next
Set FBApp = CreateObject("FB2_to_iSilo.FB2iSiloExport")
If Err Then
  WScript.Echo "Unable to create ActiveX object ""FB2_to_iSilo.FB2iSiloExport"". This may be because of the incorrect setup."&_
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
  filefolder = regEx.Replace(args(0),"") & ".pdb"
else
  filefolder = args(1)
end if

xslpath=installFolder & "\FB2_2_html.xsl"
xslOEBpath=installFolder & "\FB2_2_iSilo_ixl.xsl"

NeedHyph=0
NeedIndent=0

On Error GoTo 0

for i=1 to args.Count-1
	Select Case args(i)
		Case "-i" FBApp.SkipImages = True
		Case "-t0" FBApp.TOCLevels = 0
		Case "-t1" FBApp.TOCLevels = 1
		Case "-t3" FBApp.TOCLevels = 3
		Case "-tall" FBApp.TOCLevels = 999
	End Select
next

set XSL = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
XSL.load(xslpath)
Set FBApp.XSL = XSL

set ixlXSL = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
ixlXSL.load(xslOEBpath)
Set FBApp.IXLXSL = ixlXSL

set InDoc =  WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
InDoc.load(args(0))

FBApp.convert InDoc, filefolder
