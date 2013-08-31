unit exec_external;

interface
Uses Classes;
Function ExecApplication(CommandLine,Dir:String;Lines:TStrings):Boolean;

implementation
uses Windows, SysUtils,Forms;
Function ExecApplication;
const
  ReadBuffer = 2000;
Var
  Security : TSecurityAttributes;
  StartUpInfo:TStartupInfo;
  ProcInfo:TProcessInformation;
  ErrNo,I,NumRead:Integer;
  Msg:PChar;
  E: Exception;
  Buffer : Pchar;
  ReadPipe,WritePipe:THandle;
  BytesRead,Apprunning:DWord;
  BufDone,CharCollect:String;
  ClearFlag:Boolean;
  Return:Cardinal;
begin
  Result:=False;
  FillChar(StartUpInfo, SizeOf(StartUpInfo), 0);
  StartUpInfo.cb := SizeOf(StartUpInfo);
  FillChar(Security,SizeOf(Security),0);
  With Security do begin
    nlength := SizeOf(TSecurityAttributes) ;
    binherithandle := true;
  end;

  if not Createpipe (ReadPipe, WritePipe, @Security, 0) then
    RaiseLastOSError;
  try
    Buffer := AllocMem(ReadBuffer + 1) ;

    StartUpInfo.hStdOutput := WritePipe;
    StartUpInfo.hStdError := WritePipe;
    StartUpInfo.hStdInput := ReadPipe;
    StartUpInfo.dwFlags := STARTF_USESTDHANDLES +
                         STARTF_USESHOWWINDOW;
    StartUpInfo.wShowWindow := SW_HIDE;


    ClearFlag:=False;
    if CreateProcess(Nil,PChar(CommandLine),@Security,@Security,True,CREATE_NEW_CONSOLE ,Nil,PChar(Dir),StartUpInfo,ProcInfo) then
    begin
      try
        repeat
          Apprunning := WaitForSingleObject
                       (ProcInfo.hProcess,Infinite) ;
          Application.ProcessMessages;
          if Lines<>Nil then
          Repeat
            PeekNamedPipe(ReadPipe, nil, 0, nil,
              @NumRead, nil);
            if NumRead > 0 then
            Begin
              BytesRead := 0;
              ReadFile(ReadPipe,Buffer[0], ReadBuffer,BytesRead,nil) ;
              Buffer[BytesRead]:= #0;
              OemToAnsi(Buffer,Buffer);
              BufDone:=String(Buffer);
              OemToChar(PChar(BufDone),PChar(BufDone));
              I:=1;
              While I< Length(BufDone) do
              Begin
                if BufDone[I]=#13 then
                  ClearFlag:=true
                else if BufDone[I]=#10 then
                  Lines.Add('')
                else
                Begin
                  if ClearFlag then Lines[Lines.Count-1]:='';
                  ClearFlag:=False;
                  CharCollect:=BufDone[I];
                  While (I< Length(BufDone)) and not (BufDone[I+1] in [#10,#13]) do
                  Begin
                    CharCollect:=CharCollect+BufDone[I+1];
                    Inc(I);
                  end;
                  Lines[Lines.Count-1]:=Lines[Lines.Count-1] + CharCollect;
                end;
                Inc(I);
              end;
            end;
          until (BytesRead < ReadBuffer);
        until (Apprunning <> WAIT_TIMEOUT) ;
//        WaitForSingleObject(ProcInfo.hProcess,
//                              INFINITE);
        GetExitCodeProcess(procInfo.hProcess, return);
        Result := (return = 0);

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
