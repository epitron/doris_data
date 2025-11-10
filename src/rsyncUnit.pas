unit rsyncUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, processThreadUnit, SettingsUnit,
  rjPcreRegExp, Grabag;

type
  //TTermEvent = procedure of object;
  Trsync = class(TForm)
    ProgressLabel: TLabel;
    captureOutput: TMemo;
    closeButton: TBitBtn;
    ProgressBar: TProgressBar;
    FilesRemainingLabelLabel: TLabel;
    cancelButton: TBitBtn;
    SpeedLabelLabel: TLabel;
    FilesRemainingLabel: TStaticText;
    SpeedLabel: TStaticText;
    lvTransfers: TListView;
    regexProgress: TPcreRegExp;
    Status: TStaticText;
    procedure closeButtonClick(Sender: TObject);
    procedure resetWindow;
    procedure DoBackup(Files: TStrings);
    procedure DoRestore(includefile, target : string);
    procedure RunRsync(SyncParams : WideString);
    procedure processThreadOnOutput(Text: String);
    procedure processThreadOnTerminate;
    procedure cancelButtonClick(Sender: TObject);
  private
    { Private declarations }
    processThread: TprocessThread;
    isBackup : Boolean;
    procedure HideStatLabels;
    procedure ShowStatLabels;
  public
    { Public declarations }
    FTermEvent: TTermEvent;
    function DosDirsToCygwinDirs(Dirs : TStrings) : WideString;
  published
    property OnTerm: TTermEvent read FTermEvent write FTermEvent;
  end;

var
  rsync: Trsync;
  bytesTransferred: Integer;

implementation

//uses mainWindowUnit;

{$R *.dfm}

procedure Trsync.closeButtonClick(Sender: TObject);
begin
   rsync.Hide;
   rsync.Caption := '';
   captureOutput.Lines.Clear;
   closeButton.Enabled := False;
end;

function DosDirToCygwinDir(Dir : String):String;
var
  s   : string;
  c   : integer;

begin
  s := '';
  if (Dir[1] in ['A'..'Z', 'a'..'z']) and
     (Dir[2] = ':') then begin

     s := s + '"/cygdrive/' + dir[1] + Copy(dir, 3, Length(dir)) + '"';

     for c := 1 to length(s) do
       if s[c] = '\' then s[c] := '/';
  end;

  result := s;
end;

function Trsync.DosDirsToCygwinDirs(Dirs : TStrings) : WideString;
var
    i : integer;
begin
    for i := 0 to Dirs.Count-1 do begin
      result := result + DosDirToCygwinDir(Dirs[i]) + ' ';
    end;
end;

procedure Trsync.HideStatLabels;
begin
  SpeedLabelLabel.Hide;
  SpeedLabel.Hide;
  FilesRemainingLabelLabel.Hide;
  FilesRemainingLabel.Hide;
end;

procedure Trsync.ShowStatLabels;
begin
  SpeedLabelLabel.Show;
  SpeedLabel.Show;
  FilesRemainingLabelLabel.Show;
  FilesRemainingLabel.Show;
end;

var
  cancelled : boolean = false;

procedure Trsync.resetWindow;
begin

  cancelled := false;
  
  closeButton.Enabled := False;
  cancelButton.Enabled := True;

  SpeedLabel.Caption := '';
  FilesRemainingLabel.Caption := '';
  HideStatLabels;

  Status.Caption := '';
  lvTransfers.Clear;

  ProgressBar.Position := 0;
  ProgressBar.Max := 100;

end;

procedure Trsync.DoBackup(Files: TStrings);
var
    SyncParams : WideString;
begin
  isBackup := true;

  if (Files.Count = 0) then begin
    ShowMessage('Error: No Files Selected!');
    exit;
  end
  else begin
    Status.Caption := 'Starting Backup...';

    SyncParams := DosDirsToCygwinDirs(Files)
                  + ' '
                  + Settings.Username
                  + '@'+Settings.server+':~/'+serverbackupdir+'/';

    RunRsync(SyncParams);
  end;
end;

procedure Trsync.DoRestore(includefile, target : string);
var
    SyncParams : WideString;

begin
  isBackup := false;

  // Restore
  if not FileExists(includefile) then begin
    ShowMessage('Error: Cannot find include file. Program bug. Please contact vendor.');
    exit;
  end
  else begin
    Status.Caption := 'Starting Restore...';

    SyncParams := '--include-from=' + DosDirToCygwinDir(includefile) + ' '
                  + Settings.Username
                  + '@'+Settings.server+':~/'+serverbackupdir+'/ '
                  + DosDirToCygwinDir(target);

    RunRsync(SyncParams);
  end;
end;

procedure Trsync.RunRsync(SyncParams : WideString);
begin

  resetWindow; // Clear the state of the backup window

  if Assigned(processThread) and processThread.Running then begin
    ShowMessage('Backup already in progress! Wait for it to finish...');
  end

  else begin
    rsync.show;

    processThread := TprocessThread.Create(True);
    with processThread do begin
        OnOutput := processThreadOnOutput;
        OnTerm := processThreadOnTerminate;
        WorkingDir := Settings.WorkingDir;
        FileName := SettingsUnit.Doris_Rsync;
        Parameters := '--times -v --recursive --progress --compress '
                    + '-e ''./'+SettingsUnit.doris_ssh+' -w '+Settings.Password+' -K'' '
                    //+ '--log-format="%o [%t] (%P/%m) %f [size: %b/%l]" '
                    //+ '--dry-run '
                    //+ '--modify-window=2 '
                    + syncparams;

        with captureOutput.Lines do begin
            Add('Running:');
            Add(FileName+' '+Parameters);
            Add('==============================================');
            Add('Running RSYNC...');
            Add('==============================================');
            Add(' ');
        end;
    end;

    // 1: Bytes transferred, 2: Percent Complete, 3: Speed, 4: Time Left
    regexProgress.Pattern := '^[\s]+([\d]+)[\s]+([\S]+)%[\s]+([\S]+)[\s]+([\S]+)$';


    if isBackup then
      Status.Caption := 'Preparing to backup files...'
    else
      Status.Caption := 'Preparing to restore files...';

    processThread.Resume;
  end;
end;

var
  totalfiles : integer;

// 1: Bytes transferred, 2: Percent Complete, 3: Speed, 4: Time Left
const
  SSBytes     = 1;
  SSPercent   = 2;
  SSSpeed     = 3;
  SSTimeLeft  = 4;

procedure Trsync.processThreadOnOutput(Text: String);

var
  NumResults  : Integer;
  theItem  : TListItem;
  stat  : String;
  bytestr : string;

begin

  if ReadAStatistic(text, '[Transferring]: ', stat) then
  begin
    with lvTransfers do begin
      if Items.Count > 0 then begin
        Items.Item[0].SubItems[1] := 'Done';
      end;
      theItem := lvTransfers.Items.AddItem(NIL, 0);
      theItem.Caption := stat;
      theItem.SubItems.Add(' ');
      theItem.SubItems.Add(' ');
    end;
  end
  else if ReadAStatistic(text, '[List Position]: ', stat) then
  begin
    FilesRemainingLabel.Caption := IntToStr(totalfiles-StrToInt(stat));
  end
  else if ReadAStatistic(text, '[Total Files]: ', stat) then
  begin
    totalfiles := StrToInt(stat);
    FilesRemainingLabel.Caption := stat;
    if isBackup then
      Status.Caption := 'Backing up files...'
    else
      Status.Caption := 'Restoring files...';
  end
  else if ReadAStatistic(text, '[File Count]: ', stat) then
  begin
    Status.Caption := 'Gathering files: ' + stat + ' found...';
  end

  // otherwise, regex-match the transfer stats string
  else begin
    with regexProgress do begin
      SetSubjectString (Text);
      NumResults := Match;
    end; // with regexProgress

    if NumResults >= 0 then begin
      with lvTransfers.Items, regexProgress do begin
        ProgressBar.Position := StrToInt(SubStrings[SSPercent]);
        bytestr := inttostr(strtoint(SubStrings[SSBytes]) div 1024) + 'kB';
        with Item[0] do begin
          if SubItems.Count = 2 then begin
            SubItems[0] := bytestr;
            SubItems[1] := SubStrings[SSTimeLeft];
          end
          else begin
            SubItems.Add( bytestr );
            SubItems.Add( SubStrings[SSTimeLeft] );
          end;
        end;

        if (not SpeedLabel.Visible) then
          ShowStatLabels;
        SpeedLabel.Caption := SubStrings[SSSpeed];
      end;
    end;
  end;

  captureOutput.Lines.Add(Text);
end;

procedure Trsync.cancelButtonClick(Sender: TObject);
begin
    if Assigned(processThread) and processThread.Running then begin
      //TerminateProcess(processThread.PInfo.hProcess, 1);
      processThread.KillProcess;
      cancelled := true;
    end
    else
      ShowMessage('You somehow were able to push Cancel when there wasn''t anything to cancel! Curious, that.');
    closeButton.Enabled := True;
    HideStatLabels;
    FTermEvent;
end;

procedure Trsync.processThreadOnTerminate;
begin
    captureOutput.Lines.Add(' ');
    captureOutput.Lines.Add('==== Backup Complete ===');


    if isBackup then
      Status.Caption := 'Backup '
    else
      Status.Caption := 'Restore ';

    if cancelled then
      Status.Caption := Status.Caption + 'Cancelled!'
    else begin
      Status.Caption := Status.Caption + 'Complete!';

      with lvTransfers do
        if Items.Count > 0 then
          Items.Item[0].SubItems[1] := 'Done';
    end;

    HideStatLabels;
    ProgressBar.Position := ProgressBar.Max;
    closeButton.Enabled := True;
    cancelButton.Enabled := False;
    FTermEvent;
end;

end.
