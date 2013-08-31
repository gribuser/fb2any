Set args = WScript.Arguments
if args.Count=0 then
  WScript.Echo "Usage: fb2rtf_commandline.vbs <infile> [outfile] [options]" & vbCrLf & vbCrLf &_
		"Options available:" & vbCrLf &_
		"  -i   Skip ALL images" & vbCrLf &_
		"  -c   Skip cover page" & vbCrLf &_
		"  -d   skip description" & vbCrLf &_
		"  -utf   escape 1251 symbols as unicode" & vbCrLf &_
		"  -bmp   convert all images to DIB bitmaps" & vbCrLf &_
		"  -xparam <paramname> <paramval>   XSL Paramaters" & vbCrLf &_
		"  -xpath <xslpath>    custom xsl file" & vbCrLf & vbCrLf &_
		"You may also edit this script to accomplish more dedicated tasks"
  WScript.Quit 0
end if

On Error resume next
Set FBApp = CreateObject("FB2_to_RTF.FB2RTFExport")
If Err Then
  WScript.Echo "Unable to create ActiveX object ""FB2_to_RTF.FB2RTFExport"". This may be because of the incorrect setup."&_
		vbCrLf & vbCrLf & "Please reinstall FB2Any and try rinning this script again."
  WScript.Quit 1
end if

dim filefolder
Set regEx = New RegExp
regEx.IgnoreCase = True


if args.Count=1 or Left(args(1),1)="-" then
  regEx.Pattern = "\.[^.]+$"
  filefolder = regEx.Replace(args(0),"") & ".rtf"
else
  filefolder = args(1)
end if

xslpath=""

for i=2 to args.Count-1
	Select Case args(i)
		Case "-i" FBApp.SkipImages = True
		Case "-c" FBApp.SkipCover = True
		Case "-d" FBApp.SkipDescr = True
		Case "-xpath" xslpath = args(i+1)
		Case "-utf" FBApp.EncOptimise = True
		Case "-bmp" FBApp.ImagesToBMP = True
		Case "-xparam" FBApp.AddXSLParameter args(i+1), args(i+2), ""
	End Select
next

On Error GoTo 0
if xslpath <> "" then
	Set FBApp.XSL = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
	FBApp.XSL.load(xslpath)
end if

set InDoc =  WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
InDoc.load(args(0))

FBApp.convert InDoc, filefolder