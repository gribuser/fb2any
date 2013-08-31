Set args = WScript.Arguments
usageText="Usage: fb2txt_interactive.vbs [infile]"
FN=""
if args.Count>0 then
	if args(0)="/?" then
	  WScript.Echo usageText
	  WScript.Quit 0
	end if
	if args.Count>1 then
	  WScript.Echo "Only one parameter supported in interactive mode. Non-GUI script fb2rtf_commandline.vbs supports all settings via parameters"
	  WScript.Quit 0
	end if
  FN=args(0)
end if


On Error resume next

Set XMLDoc = WScript.CreateObject("Msxml2.FreeThreadedDOMDocument.4.0")
If Err Then
Dim MsgText, Btns, oWShellExt
	msgText="Unable to create ActiveX object ""Msxml2.FreeThreadedDOMDocument.4.0"". This may be because of missing MSXML 4.0."&_
		vbCrLf & "You must install MSXML 4.0 or later to use Any2FB. You can manually download MSXML from"&_
		vbCrLf & vbCrLf & "http://msdn.microsoft.com/xml/"
	Btns=48
	Err.Clear
	Set oWShellExt = WScript.CreateObject("Shell.Application")
	if Err<>0 then
	else
		msgText=msgText+vbCrLf & vbCrLf & "Or you can download (~5MB) and install MSXML 4.0 from our mirror NOW."&_
			vbCrLf & vbCrLf & "Do you want to install MSXML now?"
		Btns=Btns or 4
	end if
	
	msgBoxResult = msgbox(msgText, Btns)
	if msgBoxResult=6 then
		oWShellExt.ShellExecute "http://www.gribuser.ru/xml/fictionbook/2.0/software/msxml_4.0_sp2.msi"
	end if
  WScript.Quit 1
end if

On Error GoTo 0

Set FBApp = CreateObject("FB2_to_iSilo.FB2iSiloExport")

If Err Then
  WScript.Echo "Unable to create ActiveX object ""FB2_to_iSilo.FB2iSiloExport"". This may be because of the incorrect setup."&_
		vbCrLf & vbCrLf & "Please reinstall FB2Any and try rinning this script again."
  WScript.Quit 1
end if

if FN="" then
  set XMLDoc = nothing
else
  XMLDoc.load FN
end if

FBApp.ConvertInteractive 0, FN, XMLDoc