unit SettingsUnit;

interface

uses SysUtils;

const
  ServerBackupDir = 'backup';       // Directory, relative to user's home dir, to store files in.
  Version = 'v1.2a';
  Doris_Rsync = 'doris-rsync.exe';  // Name of the custom RSYNC binary
  Doris_SSH = 'doris-ssh.exe';      // Name of the custom SSH binary
  FileListCmd = '/usr/scripts/filelist'; // Command to execute on unix server to list files


type
    TSettingsRec = record
        Username,
        Password        : String;

        Server          : String;

        Overwrite       : Boolean;

        LastBackup,
        NextBackup,
        StartingAt      : TDateTime;

        Frequency,
        FrequencyScale  : Integer;

        AutoBackup      : Boolean;
        AutoRun         : Boolean;

        WorkingDir      : String;
    end;

var
    Settings : TSettingsRec;

implementation

initialization
    with Settings do begin
        Username := 'doris';
        Password := 'doris';
        Server := 'meat.kicks-ass.net';
        Overwrite := false;
        LastBackup := 0;
        NextBackup := 0;
        StartingAt := 0;

        WorkingDir := ExtractFilePath(ParamStr(0));

        Frequency := 60;
        FrequencyScale := 0;

        Autorun := true;
        Autobackup := false;
    end;

end.
