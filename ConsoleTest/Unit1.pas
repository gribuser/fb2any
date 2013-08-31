unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure RunToInStrings(DosApp:String;Memo:TStrings) ;
  const
     ReadBuffer = 2400;
  var
   Security : TSecurityAttributes;
   ReadPipe,WritePipe : THandle;
   start : TStartUpInfo;
   ProcessInfo : TProcessInformation;
   Buffer : Pchar;
   BytesRead : DWord;
   Apprunning : DWord;
  begin
   With Security do begin
    nlength := SizeOf(TSecurityAttributes) ;
    binherithandle := true;
    lpsecuritydescriptor := nil;
   end;
   if Createpipe (ReadPipe, WritePipe,
                  @Security, 0) then begin
    Buffer := AllocMem(ReadBuffer + 1) ;
    FillChar(Start,Sizeof(Start),#0) ;
    start.cb := SizeOf(start) ;
    start.hStdOutput := WritePipe;
    start.hStdInput := ReadPipe;
    start.dwFlags := STARTF_USESTDHANDLES +
                         STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;

    if CreateProcess(nil,
           PChar(DosApp),
           @Security,
           @Security,
           true,
           NORMAL_PRIORITY_CLASS,
           nil,
           nil,
           start,
           ProcessInfo)
    then
    begin
     repeat
      Apprunning := WaitForSingleObject
                   (ProcessInfo.hProcess,100) ;
      Application.ProcessMessages;
     until (Apprunning <> WAIT_TIMEOUT) ;
      Repeat
        BytesRead := 0;
        ReadFile(ReadPipe,Buffer[0],
ReadBuffer,BytesRead,nil) ;
        Buffer[BytesRead]:= #0;
        OemToAnsi(Buffer,Buffer) ;
        Memo.Text := Memo.text + String(Buffer) ;
      until (BytesRead < ReadBuffer) ;
   end;
   FreeMem(Buffer) ;
   CloseHandle(ProcessInfo.hProcess) ;
   CloseHandle(ProcessInfo.hThread) ;
   CloseHandle(ReadPipe) ;
   CloseHandle(WritePipe) ;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
const
  ReadBuffer = 2400;
Var
  Security : TSecurityAttributes;
  hConsole:THandle;
  StartUpInfo:TStartupInfo;
  ProcInfo:TProcessInformation;
  ErrNo,I:Integer;
  Msg:PChar;
  E: Exception;
  Buffer : Pchar;
  ReadPipe,WritePipe : THandle;
  BytesRead,Apprunning:DWord;
  BufDone:String;
  ClearFlag:Boolean;
begin
  FillChar(StartUpInfo, SizeOf(StartUpInfo), 0);
  StartUpInfo.cb := SizeOf(StartUpInfo);
  FillChar(Security,SizeOf(Security),0);
  With Security do begin
    nlength := SizeOf(TSecurityAttributes) ;
    binherithandle := true;
  end;

  if not Createpipe (ReadPipe, WritePipe, @Security, 0) then
    raise Exception.Create('Error creating pipe to catch console output');
  try
    Buffer := AllocMem(ReadBuffer + 1) ;

    StartUpInfo.hStdOutput := WritePipe;
    StartUpInfo.hStdError := WritePipe;
    StartUpInfo.hStdInput := ReadPipe;
    StartUpInfo.dwFlags := STARTF_USESTDHANDLES +
                         STARTF_USESHOWWINDOW;
    StartUpInfo.wShowWindow := SW_HIDE;


    ClearFlag:=False;
    if CreateProcess(Nil,'c:\temp\rbmake.exe -h',@Security,@Security,True,0,Nil,'c:\temp',StartUpInfo,ProcInfo) then
    begin
      try
        repeat
          Apprunning := WaitForSingleObject
                       (ProcInfo.hProcess,20) ;
          Application.ProcessMessages;
          Repeat
            BytesRead := 0;
//            ReadFile(ReadPipe,Buffer[0], ReadBuffer,BytesRead,nil) ;
            Buffer[BytesRead]:= #0;
            OemToAnsi(Buffer,Buffer);
            BufDone:=String(Buffer);
            For I:=1 to Length(BufDone) do
            if BufDone[I]=#13 then
              ClearFlag:=true
            else if BufDone[I]=#10 then
              Memo1.Lines.Add('')
            else
            Begin
              if ClearFlag then Memo1.Lines[Memo1.Lines.Count-1]:='';
              ClearFlag:=False;
              Memo1.Lines[Memo1.Lines.Count-1]:=Memo1.Lines[Memo1.Lines.Count-1] + BufDone[I];
            end;
          until (BytesRead < ReadBuffer);
        until (Apprunning <> WAIT_TIMEOUT) ;
//        WaitForSingleObject(ProcInfo.hProcess,
//                              INFINITE);
      finally
        CloseHandle(ProcInfo.hThread);
        CloseHandle(ProcInfo.hProcess);
      end;
    end
    else
    begin
      ErrNo := GetLastError;
      Msg := AllocMem(4096);
      try
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,
                      nil,
                      ErrNo,
                      0,
                      Msg,
                      4096,
                      nil);
        E := Exception.Create('Create Process Error #'
                              + IntToStr(ErrNo)
                              + ': '
                              + string(Msg));
      finally
        FreeMem(Msg);
      end;
      raise E;
    end;
  finally
   CloseHandle(ReadPipe);
   CloseHandle(WritePipe);
  end;
end;

end.
