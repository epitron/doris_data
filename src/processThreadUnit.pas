(**********************************************************************

Process Thread Unit
=============================================================
Initial work by Jos Krause © 2001 ;-)
Threadified and Tweaked by Chris Gahan (chris@ill-logic.com)

What this is:
-------------
This unit provides TprocessThread which spawns an executable file as a new
process, but connects its standard input and output to pipes so that all
text that's output to the console can be read into your program in realtime.

Example usage:
--------------
procedure RunRsync;
var
    processThread : TprocessThread;
begin
    processThread := TprocessThread.Create(True);
    with processThread do begin
        OnOutput := processThreadOnOutput;
        OnTerm := processThreadOnTerminate;
        WorkingDir := 'c:\cygwin\bin';
        FileName := 'rsync.exe';
        Parameters := '-avz /cygdrive/c/backup user@host.net:/';
    end;

    processThread.Resume;
end;

procedure processThreadOnOutput(Text:String);
begin
// Whatever you want to do when you recieve text
end;

procedure processThreadOnTerminate;
begin
// Whatever you want to do when the process terminates.
end;

---

All you're doing here is setting the OnOutput callback which gets called
every time a new line of text is recieved from the console, and the program
which should be\ run, as well as its parameters.        

**********************************************************************)

unit processThreadUnit;

interface

uses
  Windows, Classes, SysUtils, Dialogs, ExtCtrls;

type
  TOutEvent = procedure(Text: string) of object;
  TTermEvent = procedure of object;

  TprocessThread = class(TThread)
    FFileName: string;
    FParams: string;
    FWorkingDir: string;

    FLastError: string;
    FExitCode: DWord;
    FErrorCode: Integer;
    FStrBuffer: string;
    PInfo: TProcessInformation;
    FRunning: boolean;

    FOutEvent: TOutEvent;
    FTermEvent: TTermEvent;

    FTimeout: Cardinal;
    timeoutTimer : TTimer;

    function GetLastErr: string;
    procedure ParseBuffer(Buffer: PChar);
    procedure FlushBuffer;
    procedure OnTerminateHandler(Sender: TObject);
  public
    NextOutputString: String;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Execute; override;
    //function Execute: Boolean; override;
    procedure CallOutEvent;
    procedure KillProcess;   // Destroy the process
    procedure ResetTimeoutTimer;
    property LastError: string read GetLastErr;
    property ErrorCode: Integer read FErrorCode;
  published
    property FileName: string read FFileName write FFileName;
    property Parameters: string read FParams write FParams;
    property WorkingDir: string read FWorkingDir write FWorkingDir;

    property ExitCode: DWord read FExitCode write FExitCode;
    property Timeout: Cardinal read FTimeout write FTimeout;
    property Running: boolean read FRunning write FRunning;

    property OnOutput: TOutEvent read FOutEvent write FOutEvent;
    property OnTerm: TTermEvent read FTermEvent write FTermEvent;
  end;

implementation


{ Important: Methods and properties of objects in VCL or CLX can only be used
  in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure processThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ processThread }

procedure TprocessThread.KillProcess;
begin
  if TerminateProcess(PInfo.hProcess, 1) then
    OutputDebugString(PChar('Process terminated successfully!'))
  else
    OutputDebugString(PChar('Error! Process Not Terminated Right!'));
end;

procedure TprocessThread.ResetTimeoutTimer;
begin
//  timeoutTimer.Interval := FTimeout;
//  OutputDebugString(PChar('Timer reset .. new value: '+inttostr(ftimeout)));
end;

function TprocessThread.GetLastErr: string;
begin
  Result := FLastError;
  FLastError := '';
end;

procedure TprocessThread.ParseBuffer(Buffer: PChar);
var
  X, i, last: Integer;
begin
  FStrBuffer := FStrBuffer + string(Buffer);

  i := 1;
  last := 1;
  x := length(fstrbuffer);

  while (i <= x) do begin
    if FStrBuffer[i] in [#10,#13] then begin
         if (last = i) then
           NextOutputString := ''
         else
           NextOutputString := Copy(FStrBuffer, last, (i-last));
         last := i+1;
         if Assigned(FOutEvent) then begin
           Synchronize(CallOutEvent);
           Synchronize(ResetTimeoutTimer);
         end;
    end;
    i := i + 1;
  end;

  FStrBuffer := Copy(FStrBuffer, last, (i-last));
end;

procedure TprocessThread.FlushBuffer;
begin
  if (FStrBuffer <> '') and Assigned(FOutEvent) then begin
    NextOutputString := FStrBuffer;
    Synchronize(CallOutEvent);
  end;
  FStrBuffer := '';
end;

{ Environment Variable Functions }

function SetEnvVarValue(const VarName,
  VarValue: string): Integer;
begin
  // Simply call API function
  if SetEnvironmentVariable(PChar(VarName),
    PChar(VarValue)) then
    Result := 0
  else
    Result := GetLastError;
end;

function DeleteEnvVar(const VarName: string): Integer;
begin
  if SetEnvironmentVariable(PChar(VarName), nil) then
    Result := 0
  else
    Result := GetLastError;
end;

{ Main EXECUTE THREAD Procedure }

procedure TprocessThread.Execute;
var
  SInfo: TStartupInfo;

  Count: DWORD;
  ReadBuf: array[0..255 - 1] of char;
  WriteBuf: PString;

  Sa: TSecurityAttributes;
  hOutputReadTmp, hOutputRead, hOutputWrite,
    hInputWriteTmp, hInputRead, hInputWrite,
    hErrorWrite: THandle;

  ExecStr: string;
  ProcessExists: Boolean;
  PWorkingDir: PChar;

begin
  OnTerminate := OnTerminateHandler;
  FRunning := True;

  FStrBuffer := '';
  try
    ExecStr := Trim('"'+FFileName+'" ' + FParams);
    FWorkingDir := Trim(FWorkingDir);
    if FWorkingDir <> '' then
      PWorkingDir := PChar(FWorkingDir + #0)
    else
      PWorkingDir := nil;

    Sa.nLength := SizeOf(TSecurityAttributes);
    Sa.lpSecurityDescriptor := nil;
    Sa.bInheritHandle := True;

    CreatePipe(hOutputReadTmp, hOutputWrite, @sa, 0);
    DuplicateHandle(GetCurrentProcess(), hOutputWrite, GetCurrentProcess(),
      @hErrorWrite, 0, true, DUPLICATE_SAME_ACCESS);

    CreatePipe(hInputRead, hInputWriteTmp, @sa, 0);

   // duplicate handles, otherwise the pipe handle wont be closable afterwards..
    DuplicateHandle(GetCurrentProcess(), hOutputReadTmp, GetCurrentProcess(),
      @hOutputRead, 0, false, DUPLICATE_SAME_ACCESS);
    DuplicateHandle(GetCurrentProcess(), hInputWriteTmp, GetCurrentProcess(),
      @hInputWrite, 0, false, DUPLICATE_SAME_ACCESS);

    CloseHandle(hOutputReadTmp);
    CloseHandle(hInputWriteTmp);

    FillChar(SInfo, SizeOf(TStartupInfo), 0);
    SInfo.cb := SizeOf(TStartupInfo);
    SInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    SInfo.hStdInput := hInputRead;
    SInfo.hStdOutput := hOutputWrite;
    SInfo.hStdError := hErrorWrite;

    ProcessExists := CreateProcess(nil, PChar(ExecStr), @sa, @sa, true, 0, nil,
      PWorkingDir, SInfo, PInfo);
    if not ProcessExists then
    begin
      FErrorCode := GetLastError;
      FLastError := 'Unable to create process (code: ' + Inttostr(FErrorCode) +
        ')';
    end;

    CloseHandle(hOutputWrite);
    CloseHandle(hInputRead);
    CloseHandle(hErrorWrite);

    if ProcessExists then
    begin

      // Timeout Code
(*
      if FTimeout > 0 then begin
        TimeoutTimer := TTimer.Create(nil);
        with TimeoutTimer do begin
          Interval := FTimeout;
          Enabled := True;
          //OnTimer := KillProcess;
        end;
      end;
*)
      // Read Output Loop...
      repeat
        if (not ReadFile(hOutputRead, ReadBuf, 200, Count, nil)) or (Count = 0)
          then
        begin
          if (GetLastError = ERROR_BROKEN_PIPE) then
            break
          else
          begin
            FLastError := 'Error reading pipe';
            Exit;
          end;
        end;
        ReadBuf[Count] := #0;
        ParseBuffer(@ReadBuf);
      until False;

      WaitForSingleObject(Pinfo.hProcess, 10000);
      GetExitCodeProcess(PInfo.hProcess, FExitCode);
      //Result := True;
    end;

  except
    on E: Exception do begin
      FLastError := E.Message;
    end;
  end;

  FlushBuffer;
end;

constructor TprocessThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FFileName := '';
  FParams := '';
  FWorkingDir := '';
  FLastError := '';
  FExitCode := 0;
end;

destructor TprocessThread.Destroy;
begin
  inherited Destroy;
end;

procedure TprocessThread.CallOutEvent;
begin
    FOutEvent(NextOutputString);
end;

procedure TprocessThread.OnTerminateHandler(Sender: TObject);
begin
    FRunning := false;
    if Assigned(FTermEvent) then
        FTermEvent;
end;

end.
