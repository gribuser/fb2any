usageHelp= "Usage: any2rb_interactive.vbs <infile> [outfile]"
Set args = WScript.Arguments

Set regEx = New RegExp
regEx.Pattern = "^http://.+(\/([^\/]+))$"
outFileName = regEx.Replace(args(0),"$2")
regEx.Pattern = "\.[^\.]+$"
outFileName = regEx.Replace(outFileName,"") & ".rb"

if args.Count>0 then
	if args.Count>2 then
	  WScript.Echo "Only two parameters are supported in interactive mode." & vbCrLf & vbCrLf & usageHelp
	  WScript.Quit 0
	end if
	if args(0)="/?" then
	  WScript.Echo usageHelp
	  WScript.Quit 0
	end if
	Dim objShell
	Set objShell = CreateObject("WScript.Shell")
	objShell.RegWrite "HKCU\Software\Grib Soft\Any to FB2\1.0\LastOpenURI", args(0)
	if args.Count=2 then
		outFileName=args(1)
	end if
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


Set FBApp = CreateObject("any_2_fb2.any2fb2")

If Err Then
  WScript.Echo "Unable to create ActiveX object ""any_2_fb2.any2fb2"". This may be because of the incorrect setup."&_
		vbCrLf & vbCrLf & "Please reinstall the program and try rinning this script again."
  WScript.Quit 1
end if
FBApp.LoadLastSettingsFromReg

set DOM = FBApp.ConvertInteractive(0,False)


if DOM is Nothing then
   WScript.Quit 0
end if

err.clear

Set FB2RBApp = CreateObject("FB2_to_RB.FB2RBExport")

If Err Then
  WScript.Echo "Unable to create ActiveX object ""FB2_to_RB.FB2RBExport"". This may be because of the incorrect setup."&_
		vbCrLf & vbCrLf & "Please reinstall the program and try rinning this script again."
  WScript.Quit 1
end if

FB2RBApp.LoadLastSettingsFromReg

FB2RBApp.FileName = outFileName

FB2RBApp.Convert DOM
