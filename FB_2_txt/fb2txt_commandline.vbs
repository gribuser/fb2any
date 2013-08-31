Set args = WScript.Arguments
if args.Count=0 then
  WScript.Echo "Usage: fb2txt_commandline.vbs <infile> [outfile] [options]" & vbCrLf & vbCrLf &_
		"Options available:" & vbCrLf &_
		"  -d  Skip description" & vbCrLf &_
		"  -strong  No strong->STRONG conversion" & vbCrLf &_
		"  -em  No emphasis->_emphasis_ conversion" & vbCrLf &_
		"  -f <#>  Wrap text at max # chars" & vbCrLf &_
		"  -fh <#>  Wrap text at max # chars and hyphenate" & vbCrLf &_
		"  -i <#>  Indent lines with # spaces" & vbCrLf &_
		"  -e <#>  Save as <#> code page" & vbCrLf &_
		"(see http://msdn.microsoft.com/library/en-us/act/htm/actml_ref_scpg.asp)" & vbCrLf &_
		"  -lrn|-lr  Line breaks type (LF is default)" & vbCrLf  & vbCrLf &_
		"You may also edit this script to accomplish more dedicated tasks"
  WScript.Quit 0
end if


On Error resume next
Set FBApp = CreateObject("FB2_to_TXT.FB2TXTExport")
If Err Then
  WScript.Echo "Unable to create ActiveX object ""FB2_to_TXT.FB2TXTExport"". This may be because of the incorrect setup."&_
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
  filefolder = regEx.Replace(args(0),"") & ".txt"
else
  filefolder = args(1)
end if

xslpath=installFolder & "\FB2_2_txt.xsl"

NeedHyph=0
NeedIndent=0

On Error GoTo 0

for i=1 to args.Count-1
	Select Case args(i)
		Case "-d" FBApp.SkipDescr = True
		Case "-strong" FBApp.IgnoreStrong = True
		Case "-em" FBApp.IgnoreEmphasis = True
		Case "-f" FBApp.FixedWidth = args(i+1)
		Case "-fh" NeedHyph = args(i+1)
		Case "-i" NeedIndent = args(i+1)
		Case "-e" FBApp.Encoding = args(i+1)
		Case "-lrn" FBApp.LineBr = vbCrLf
		Case "-lr" FBApp.LineBr = vbCr
	End Select
next

if NeedHyph <> 0 then
	FBApp.FixedWidth = NeedHyph
  Set DevDescr = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
	DevDescr.preserveWhiteSpace = true
	DevDescr.loadXML("<device name=""Fixed width text""><displays><display-mode name=""Default"" width=""" & NeedHyph & """/></displays><fonts><font name=""Default""><font-size name=""Default""><normal default-width=""1""/></font-size></font></fonts></device>")
	Set FBApp.Hyphenator = CreateObject("FB2_hyph.FB2Hyphenator")
	set FBApp.Hyphenator.deviceDescr=DevDescr
  FBApp.Hyphenator.plainOnly = True
	FBApp.Hyphenator.hyphStr = "- "
	FBApp.Hyphenator.currentFont = "Default"
	FBApp.Hyphenator.currentDeviceSize = "Default"
	FBApp.Hyphenator.currentFontSize = "Default"
end if

if NeedIndent <> 0 then
	prefix=""
	for i=1 to NeedIndent
		prefix=prefix & " "
	next
	FBApp.ParaIndent=prefix
end if


set XSL = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
XSL.load(xslpath)
Set FBApp.XSL = XSL

set InDoc =  WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
InDoc.load(args(0))

FBApp.convert InDoc, filefolder
