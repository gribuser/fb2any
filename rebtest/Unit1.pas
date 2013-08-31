unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
      RebHandle:THandle;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses SetupApi;
{$R *.dfm}
Const
  GUID_REB1100:TGUID ='{3bb1df43-b2d4-11d3-bf85-00105a0a47b3}';
  IOCTL_RocketReadFile          = $222004;
  IOCTL_RocketWriteFile         = $222008;
  IOCTL_RocketWriteCodeSet      = $22200C;
  IOCTL_RocketReadDebug         = $222010;
  IOCTL_RocketReadSerialNumber  = $222014;
  IOCTL_RocketReadInitiate      = $222018;
  IOCTL_RocketReadContinue      = $22201C;
  IOCTL_RocketWriteInitiate     = $222020;
  IOCTL_RocketWriteContinue     = $222024;
  IOCTL_RocketSendCommand       = $222028;
  IOCTL_RocketWriteDebug        = $22202C;

procedure TForm1.Button1Click(Sender: TObject);
Var
  HReb:HDEVINFO;
  InterFaceData:TSPDeviceInterfaceData;
  Len,newlen:Cardinal;
  PIdDD:PSPDeviceInterfaceDetailData;
  DevicePath:String;
  Serial:Array[0..$32] of AnsiChar;
begin
  HReb:=SetupDiGetClassDevs(@GUID_REB1100,Nil,Handle,DIGCF_PRESENT or DIGCF_INTERFACEDEVICE);
  if (HReb = Nil) then
    Memo1.Lines.Add('REB1100 driver missing')  //Device unknown
  else
    Memo1.Lines.Add('REB1100 driver detected');
  InterFaceData.cbSize:=SizeOf(InterFaceData);
  if SetupDiEnumDeviceInterfaces(HReb,0,GUID_REB1100,0,InterFaceData) then
    Memo1.Lines.Add('REB1100 connected')
  else
    Begin
      Memo1.Lines.Add('REB1100 is not connected or is turned off'); //device is off
      Exit;
    end;
		SetupDiGetInterfaceDeviceDetail(HReb, @InterFaceData, Nil, 0, @Len, Nil);
   PIdDD:=AllocMem(Len);
   PIdDD^.cbSize:=SizeOf(TSPDeviceInterfaceDetailData);
   if not SetupDiGetInterfaceDeviceDetail(HReb, @InterFaceData, PIdDD, Len, @Len, Nil) then
     RaiseLastWin32Error;
   DevicePath:=PChar(@PIdDD.DevicePath);
   FreeMem(PIdDD,Len);
   Memo1.Lines.Add(DevicePath);
   RebHandle:=CreateFile(PChar(DevicePath),GENERIC_READ or GENERIC_WRITE,
                          FILE_SHARE_READ or FILE_SHARE_WRITE,
                          Nil,OPEN_EXISTING, 0,0);
   if RebHandle=INVALID_HANDLE_VALUE then RaiseLastWin32Error;
   FillChar(Serial,SizeOf(Serial),#0);
   Len:=0;
   if not DeviceIoControl(RebHandle,IOCTL_RocketReadSerialNumber,Nil,0,@Serial,
      $32,Len,Nil) then
     RaiseLastWin32Error;
   Memo1.Lines.Add('Serial: '+Serial);
end;

procedure TForm1.Button2Click(Sender: TObject);
Const
  REB_BLOCK_SZ=4096;
	 haveRead:Integer = 0;
	 total:LongInt = 0;
	 toRead:Integer = REB_BLOCK_SZ;
  Operation='__STATUS'#0;
Var
  BytesRead:Cardinal;
  internalBuffer:array [1..REB_BLOCK_SZ * 16] of AnsiChar;
  S:String;
begin

	if (RebHandle = INVALID_HANDLE_VALUE) then
		Exit;

	if not DeviceIoControl(RebHandle, IOCTL_RocketReadInitiate,
		PChar(Operation), Length(Operation),
		@internalBuffer,SizeOf(internalBuffer), BytesRead, Nil) then
     RaiseLastWin32Error;
 internalBuffer[BytesRead+1]:=#0;
 S:=PChar(@internalBuffer[1]);
 Memo1.Lines.Add(S);
 if pos('SM_PRESENT="Yes"',S)>0 then
    SHowMessage('a');
end;

end.
	{
#ifdef REB_DEBUG
		fprintf (stderr, "UNEXPECTED IOCTL ERROR #%d\n", GetLastError ());
#endif
		// there was an error, chances are the REB went offline
		setDisconnState ();
		return (FAILURE);
	}

	if (!haveRead) 
	{
#ifdef REB_DEBUG
		fprintf (stderr, "IOCTL RETURNED %d bytes \n", haveRead);
#endif
		eBookClose ();
		return (FAILURE);
	}

	total = haveRead;

	while ((haveRead == REB_BLOCK_SZ) && (total < * bufSize))
	{
		if ((total + REB_BLOCK_SZ) > (* bufSize))
			toRead = total - (* bufSize);
		else
			toRead = REB_BLOCK_SZ;

#ifdef REB_DEBUG
		printf ("%d OCTETS READ.\n", total);
#endif
		if (DeviceIoControl (hDev, IOCTL_RocketReadContinue, 
			NULL, 0, buffer+total, toRead, (LPDWORD) &haveRead, NULL) < 0)
		{
#ifdef REB_DEBUG
			fprintf (stderr, "UNEXPECTED IOCTL ERROR #%d\n", GetLastError ());
#endif
			// there was an error, chances are the REB went offline
			setDisconnState ();
			return (FAILURE);
		}

		total += haveRead;
	}
	
	eBookClose ();
	* bufSize = total;

	return (SUCCESS);
}

end;

end.


int eBookComm::eWriteFileFromBuffer (char * buffer, int sendSize, int fnameSz, PctDoneFnc * fnc)
{
	int octets;
	DWORD status;
	char *p;
	int origSize;

	eBookOpen ();

	if (hDev == INVALID_HANDLE_VALUE)
		return (FAILURE);

	p = buffer;
	octets = sendSize;
	sendSize += fnameSz;
	origSize = sendSize;

	if (DeviceIoControl (hDev, IOCTL_RocketWriteInitiate, p, 
		sendSize, NULL, 0, &status, NULL) < 0) 
	{
#ifdef REB_DEBUG
		fprintf (stderr, "UNEXPECTED IOCTL ERROR #%d\n", GetLastError ());
#endif
		setDisconnState ();
		return (FAILURE);
	}

	if (octets > REB_BLOCK_SZ)
		octets = REB_BLOCK_SZ;

	sendSize -= (octets + fnameSz);
	p += (octets + fnameSz);
	
	if (fnc)
		fnc ((origSize - sendSize) * 100 / origSize);

	while (sendSize > 0) 
	{
		octets = sendSize;
		if (octets > REB_BLOCK_SZ)
			octets = REB_BLOCK_SZ;

		if (DeviceIoControl (hDev, IOCTL_RocketWriteContinue, 
			p, octets, NULL, 0, &status, NULL) < 0) 
		{
			setDisconnState ();
			return (FAILURE);
		}
		sendSize -= octets;
		p += octets;
		if (fnc)
			fnc ((origSize - sendSize) * 100 / origSize);

#ifdef REB_DEBUG
		printf ("%d OCTETS REMAINING.\n", sendSize);
#endif
	}

	eBookClose ();
	return (SUCCESS);
}

