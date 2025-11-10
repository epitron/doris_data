unit mainWindowUnit;

{$WARN UNIT_PLATFORM OFF}

interface

uses
  SettingsUnit,
  rsyncUnit,
  processThreadUnit,
  Grabag,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ShellCtrls, ShellAPI, AppEvnts, ExtCtrls,
  Buttons, Menus, VirtualTrees, VirtualExplorerTree,
  VirtualShellUtilities, jpeg, Registry, rjPcreRegExp, lvkComponents,
  lvkSubclass, lvkTrayIcon, lvkEnabler, ImgList, DateUtils,
  VirtualShellToolBar, FileCtrl,
  typinfo;

type
  TmainWindow = class(TForm)

    backupPanel: TPanel;
    Label1: TLabel;
    btnBackupNow: TBitBtn;

    restorePanel: TPanel;
        filesToRestoreLabel: TLabel;
        ListFilesButton: TBitBtn;
        RestoreFilesButton: TBitBtn;
        restoreStatusLabel: TLabel;
        ListStatus: TPanel;

    configPanel: TPanel;
        configPanelLabel: TLabel;
        configUserLabel: TLabel;
        configPasswordLabel: TLabel;
        configServerLabel: TLabel;
        loginGroup: TGroupBox;
        configServer: TEdit;
        configUser: TEdit;
        configPassword: TEdit;
        backupOptionsGroup: TGroupBox;
        overwriteNewToggle: TCheckBox;
        registeredToLabel: TLabel;
        dorisLabel: TLabel;
        aboutGroup: TGroupBox;
        registeredToMemo: TMemo;
        versionLabel: TLabel;
    PopupMenu1: TPopupMenu;
    TrayEnable: TMenuItem;
    TrayDisable: TMenuItem;
    Exit: TMenuItem;
    PopupSeperator: TMenuItem;
    VET: TVirtualExplorerTreeview;
    BackupTimer: TTimer;
    saveSettingsButton: TBitBtn;
    restoreSettingsButton: TBitBtn;
    configCustomServerToggle: TCheckBox;
    RegEx: TPcreRegExp;
    lvkAnimatedTrayIcon1: TlvkAnimatedTrayIcon;
    Console: TMemo;
    backupSchedule: TGroupBox;
    backupEveryLabel: TLabel;
    BackupFrequencyScale: TComboBox;
    BackupFrequencyArrows: TUpDown;
    BackupFrequency: TEdit;
    chkAutoBackup: TCheckBox;
    chkAutorun: TCheckBox;
    AutomatedBackupEnabler: TlvkCheckBoxEnabler;
    BackupTimeleftLabelLabel: TLabel;
    BackupTimeleftLabel: TStaticText;
    RemoteTree: TVirtualStringTree;
    FileIcons: TImageList;
    LastBackupLabelLabel: TLabel;
    LastBackupLabel: TStaticText;
    SaveBackupDirsButton: TBitBtn;
    LoadBackupDirsButton: TBitBtn;
    StartingAtLabel: TLabel;
    StartingAtDatePicker: TDateTimePicker;
    StartingAtTimePicker: TDateTimePicker;
    Label2: TLabel;
    BackupTreeFilesCheckbox: TCheckBox;
    TrayIcons: TImageList;
    BackupTabButtonOff: TImage;
    BackupTabButtonOn: TImage;
    ConfigTabButtonOn: TImage;
    ConfigTabButtonOff: TImage;
    RestoreTabButtonOn: TImage;
    RestoreTabButtonOff: TImage;
    MinimizeButton: TImage;
    ExitButton: TImage;
    SetStartTime: TButton;
    SelectedSizeLabel: TLabel;
    FreeSpaceLabel: TLabel;
    FreeSpace: TStaticText;
    SelectedSize: TStaticText;
    Label4: TLabel;
    procedure configCustomServerToggleClick(Sender: TObject);
    procedure mainWindowCreate(Sender: TObject);
    procedure mainWindowDestroy(Sender: TObject);
    procedure CloseClick(Sender: TObject; var CanClose: Boolean);
    procedure ListFilesButtonClick(Sender: TObject);
    procedure ListSetCurrentDirNode(S:String);
    procedure listProcessThreadOnOutput(Text: String);
    procedure listProcessThreadOnTerminate;
    procedure TrayEnableClick(Sender: TObject);
    procedure TrayDisableClick(Sender: TObject);
    procedure VETEnumFolder(Sender: TCustomVirtualExplorerTree;
                Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure VETInitNode(Sender: TBaseVirtualTree; ParentNode,
                Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure SaveSettings;
    procedure RestoreSettings;
    procedure RestartTimer;
    procedure PauseTimer;
    procedure chkAutoBackupClick(Sender: TObject);
    procedure saveSettingsButtonClick(Sender: TObject);
    procedure restoreSettingsButtonClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure DisplayTimeLeft;
    procedure TimerUpdate(Sender: TObject);
    procedure RemoteTreeInitialize;
    procedure RemoteGetCheckedNodes(includefile : string);
    procedure RemoteTreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure RemoteTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure RemoteTreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure BackupFrequencyScaleChange(Sender: TObject);
    procedure RemoteTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RemoteTreeCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure chkAutoRunAtStartupClick(Sender: TObject);
    procedure URLClick(Sender: TObject);
    procedure configUserChange(Sender: TObject);
    procedure configPasswordChange(Sender: TObject);
    procedure configServerChange(Sender: TObject);
    procedure overwriteNewToggleClick(Sender: TObject);
    procedure RestoreFilesButtonClick(Sender: TObject);
    procedure SynchFieldsWithSettings;
    procedure SettingSynchedUpdate;
    procedure SettingChangedUpdate;
    procedure SaveBackupDirsButtonClick(Sender: TObject);
    procedure BackupFrequencyChange(Sender: TObject);
    procedure LoadBackupDirsButtonClick(Sender: TObject);
    procedure btnBackupNowClick(Sender: TObject);
    procedure VETChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VETChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure BackupTreeFilesCheckboxClick(Sender: TObject);
    procedure RemoteTreeHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure BackupTabButtonOffClick(Sender: TObject);
    procedure RestoreTabButtonOffClick(Sender: TObject);
    procedure ConfigTabButtonOffClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure MinimizeButtonClick(Sender: TObject);
    procedure StartingAtTimePickerChange(Sender: TObject);
    procedure StartingAtDatePickerChange(Sender: TObject);
    procedure SetStartTimeClick(Sender: TObject);
    procedure BackupComplete;
    procedure RestoreComplete;
  private
    { Private declarations }
    listProcessThread: TprocessThread;
    procedure BuildVETTree;
    procedure SaveVETTree;
    procedure LoadVETTree;
  public
    { Public declarations }
    //procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
  end;

var
  mainWindow: TmainWindow;
  BackingUpNow: boolean = false;

implementation

type
  rTreeData = record
    FileName: WideString;
    FullPath: WideString;
    isFile : Boolean;
    FileSize: LongInt;
    Date: TDateTime;
    isOpened: Boolean;
    ImageIndex: Integer;
  end;
  PTreeData = ^rTreeData;

const
  LocalVETFilename = 'BackupDirs.dat';

var
  Reg: TRegistry;
  SettingChanged : Boolean;

{$R *.dfm}

//------------------------------------------------------------------------------
// Panel Tab Buttons
//------------------------------------------------------------------------------

procedure TmainWindow.BackupTabButtonOffClick(Sender: TObject);
begin
    BackupTabButtonOn.Show;
    BackupTabButtonOff.Hide;

    RestoreTabButtonOff.Show;
    RestoreTabButtonOn.Hide;

    ConfigTabButtonOff.Show;
    ConfigTabButtonOn.Hide;

    backupPanel.Visible := True;
    restorePanel.Visible := False;
    configPanel.Visible := False;
end;

procedure TmainWindow.RestoreTabButtonOffClick(Sender: TObject);
begin
    BackupTabButtonOff.Show;
    BackupTabButtonOn.Hide;

    RestoreTabButtonOn.Show;
    RestoreTabButtonOff.Hide;

    ConfigTabButtonOff.Show;
    ConfigTabButtonOn.Hide;

    backupPanel.Visible := False;
    restorePanel.Visible := True;
    configPanel.Visible := False;
end;

procedure TmainWindow.ConfigTabButtonOffClick(Sender: TObject);
begin
    BackupTabButtonOff.Show;
    BackupTabButtonOn.Hide;

    RestoreTabButtonOff.Show;
    RestoreTabButtonOn.Hide;

    ConfigTabButtonOn.Show;
    ConfigTabButtonOff.Hide;

    backupPanel.Visible := False;
    restorePanel.Visible := False;
    configPanel.Visible := True;
end;

//------------------------------------------------------------------------------
// Backup Panel Functions
//------------------------------------------------------------------------------
procedure TmainWindow.BuildVETTree;
var
  MyComputer: PVirtualNode;
begin
  VET.BeginUpdate;
  try
    VET.Active := true;
    MyComputer := VET.FindNodeByPIDL(DrivesFolder.AbsolutePIDL);
    if MyComputer <> nil then
      VET.Expanded[MyComputer] := true;
  finally
    VET.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------
procedure TmainWindow.VETEnumFolder(Sender: TCustomVirtualExplorerTree;
  Namespace: TNamespace; var AllowAsChild: Boolean);
begin
  AllowAsChild := NameSpace.FileSystem or NameSpace.IsMyComputer;
end;

//------------------------------------------------------------------------------
procedure TmainWindow.VETInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
   Node.CheckType := ctTriStateCheckBox
end;

//------------------------------------------------------------------------------
procedure TmainWindow.SaveVETTree;
begin
  ViewManager.Snapshot('Backup Tree', VET);
  ViewManager.SaveToFile(LocalVETFilename);
end;

procedure TmainWindow.LoadVETTree;
begin
  if FileExists(LocalVETFilename) then begin
    ViewManager.LoadFromFile(LocalVETFilename);
    ViewManager.ShowView('Backup Tree', VET);
  end;
end;

procedure TmainWindow.SaveBackupDirsButtonClick(Sender: TObject);
begin
    SaveVETTree;
    SaveBackupDirsButton.Enabled := False;
    LoadBackupDirsButton.Enabled := False;
end;

procedure TmainWindow.LoadBackupDirsButtonClick(Sender: TObject);
begin
    LoadVETTree;
    SaveBackupDirsButton.Enabled := False;
    LoadBackupDirsButton.Enabled := False;
end;

procedure TmainWindow.btnBackupNowClick(Sender: TObject);
begin
  //console.Lines.Add(rsync.DosDirsToCygwinDirs(VET.Storage.CheckedFileNames));
  lvkAnimatedTrayIcon1.Animated := True;
  Settings.LastBackup := Now;

  BackingUpNow := True;
  PauseTimer;

  rsync.OnTerm := BackupComplete;
  rsync.DoBackup(VET.Storage.CheckedFileNames); // true = doBackup
end;

procedure TmainWindow.BackupComplete;
begin
  lvkAnimatedTrayIcon1.Animated := False;
  BackingUpNow := False;
  RestartTimer;
end;
//------------------------------------------------------------------------------
// Configuration Stuff
//------------------------------------------------------------------------------

procedure TmainWindow.configCustomServerToggleClick(Sender: TObject);
begin
    if configCustomServerToggle.Checked then begin
        configServerLabel.Enabled := True;
        configServer.Enabled := True;
    end
    else begin
        configServerLabel.Enabled := False;
        configServer.Enabled := False;
    end;
end;

//------------------------------------------------------------------------------
// System Tray Stuff
//------------------------------------------------------------------------------
procedure TmainWindow.TrayEnableClick(Sender: TObject);
begin
    with PopupMenu1 do begin
        Items[0].Checked := True;
        Items[0].Default := True;
        Items[1].Checked := False;
        Items[1].Default := False;
    end;

    chkAutoBackup.Checked := True;
end;

procedure TmainWindow.TrayDisableClick(Sender: TObject);
begin
    with PopupMenu1 do begin
        Items[0].Checked := False;
        Items[0].Default := False;
        Items[1].Checked := True;
        Items[1].Default := True;
    end;

    chkAutoBackup.Checked := False;
end;



//------------------------------------------------------------------------------
// Restore Panel Functions
//------------------------------------------------------------------------------

var
    CurrentDirNode : PVirtualNode;
    CurrentDirPath : String = '';
    FilesRecieved  : Integer;
    gotFreeSpace   : boolean = false;

//======================
// Reset the tree
//======================
procedure TmainWindow.RemoteTreeInitialize;
//var
//    Node : PVirtualNode;
begin
//    Node := RemoteTree.AddChild(nil);
    CurrentDirNode := NIL;
    RemoteTree.Clear;
end;

//======================
// List Thread Terminated...
//======================
procedure TmainWindow.listProcessThreadOnTerminate;
begin
//    RemoteTree.SortTree(0, sdAscending, False);

    ListStatus.Caption := 'Done!';
    //RemoteLastUpdated.Caption := FormatDateTime(LongDateFormat, Now);
    //RemoteLastUpdated.Refresh;
end;

//======================
// Start List Files Process
//======================
procedure TmainWindow.ListFilesButtonClick(Sender: TObject);
begin
  if Assigned(listProcessThread) and listProcessThread.Running then begin
    ShowMessage('Already getting list. Please wait.');
  end
  else begin
    RemoteTreeInitialize; // Clear the tree
    FilesRecieved := 0;

    listProcessThread := TprocessThread.Create(True);
    with listProcessThread do begin
        OnOutput := listProcessThreadOnOutput;
        OnTerm := listProcessThreadOnTerminate;
        Timeout := 15000;
        WorkingDir := Settings.WorkingDir;

        FileName := SettingsUnit.Doris_SSH;
        Parameters := '-l '+Settings.Username
                      +' -w '+Settings.Password
                      +' -K -C '
                      + Settings.Server
                      + ' ' + SettingsUnit.FileListCmd + ' '+serverbackupdir;
        //Console.Lines.Add('Executing: ' + Filename + ' ' + Parameters);
    end;

    // 1: Date, 2: Permissions, 3: Size, 4: Name
    //1035788852 289031    4 drwxr-xr-x   2 posdnuos posdnuos     4096 Oct 28 02:07 .
//    RegEx.Pattern := '^([\d]+)[\s]+[\d]+[\s]+[\d]+[\s]+([drwx\-]+)[\s]+[\d]+[\s]+.+[\s]+.+[\s]+([\d]+)[\s]+.+[\s].+[\s].+[\s]+\.(.+)$';

    // 3: Date, 1: Permissions, 2: Size, 4: Name
    //-rw-r--r--    1 root     root       460376 1037696139 CineManList1(JunDec01).htm
    RegEx.Pattern := '^([rwx\-]+)[\s]+[\d]+[\s]+.+[\s]+.+[\s]+([\d]+)[\s]+([\d]+)[\s]+(.+)$';
    gotFreeSpace := False;

    listProcessThread.Resume;
    ListStatus.Caption := 'Logging in and getting file list...';
  end;
end;

// Selects the node specified by the path.
// Precondition: S must be a valid path with a slash at the beginning.
procedure TMainWindow.ListSetCurrentDirNode(S:String);

    procedure FindOrInsertDir(var Parent : PVirtualNode; DirName : Widestring);
    var
      p : PVirtualNode;

    begin

      //debug
      //console.lines.add('  find/ins dir : '+dirname);

      // Find first subdirectory below parent
      p := Parent.FirstChild;
      // Walk through all subdirs
      while (p <> nil) do begin
        // If the subdir already exists, don't need to create it.

        if (RemoteTree.Text[p, 0] = DirName) then
          break;

        p := p.NextSibling;
      end;

      // If p = nil, directory doesn't exist, so create it.
      if (p = nil) then begin
        p := RemoteTree.AddChild(Parent);
        // Fill the NODE!
        with PTreeData(RemoteTree.GetNodeData(p))^ do
        begin
          // If it's the root dir, we don't want a slash.
          if (parent = RemoteTree.RootNode) then
            FullPath := DirName
          else
            FullPath := RemoteTree.Path(parent, 0, ttNormal, '/') + DirName;
          FileName := DirName;
          FileSize := -1;
          isFile := false;
        end;

        Parent := p;
      end

      // Otherwise, we found the directory!
      else
        Parent := p;

    end;

var
    lasti,
    i       : Integer;
    dir     : string;
    p       : PVirtualNode;

begin

    //console.Lines.add('Parsing directory: '+s);

    p := RemoteTree.RootNode;

    i := 2; lasti := 1;
    while (i <= length(S)) do begin
        // A directory that's between slashes
        if (S[i] = '/') then begin
            dir := Copy(S, lasti+1, i-lasti-1);
            lasti := i;

            FindOrInsertDir(p, dir);
        end;

        // A directory that's at the very end of the string
        if i = length(S) then begin
            dir := Copy(S, lasti+1, i-lasti);

            FindOrInsertDir(p, dir);
        end;

        inc(i);
    end;

    CurrentDirNode := p;

    if (p = RemoteTree.RootNode) then
      CurrentDirPath := ''
    else
      CurrentDirPath := RemoteTree.Path(p, 0, ttNormal, '/');
end;

// display number of files recieved.
procedure UpdateFilesRecieved;
begin
  FilesRecieved := FilesRecieved + 1;
    //if FilesRecieved mod 7 = 0 then
    with MainWindow.ListStatus do begin
      Caption := 'Files Recieved: ' + IntToStr(FilesRecieved);
      Refresh;
    end;
end;

// Removes escaped (\'ed) characters from a string
function unescape(s:string):string;
var i:integer;
    esc : boolean;
begin
  esc := false;
  for i := 1 to length(s) do begin
    if (s[i] = '\') and (not esc) then
      esc := true
    else begin
      result:=result + s[i];
      if esc then esc := false;
    end;
  end;
end;


//======================
// Do RegEx Matching for RSYNC Output
//======================
// 3: Date, 1: Permissions, 2: Size, 4: Name
const
  SSDate = 3;
  SSPerm = 1;
  SSSize = 2;
  SSName = 4;

procedure TmainWindow.listProcessThreadOnOutput(Text: String);
var
  NumResults  : Integer;
  Node        : PVirtualNode;
  temp,
  Stat        : String;

begin

  if not gotFreeSpace then begin
    if ReadAStatistic(text, '[Used]: ', stat) then begin
      SelectedSize.Caption := inttostr(strtoint(stat) div 1024) + 'kB';
    end

    else if ReadAStatistic(text, '[Available]: ', stat) then begin
      FreeSpace.Caption := stat + 'kB';
    end

    else if ReadAStatistic(text, '[Usage]: ', stat) then begin
      gotFreespace := true;
    end;
  end

  else begin

    if (Length(Text) >= 2) and (Text[1] = '.') and (Text[length(Text)] = ':') then
    begin
      temp := Copy(Text, 2, length(Text)-2);
      ListSetCurrentDirNode(temp);
      //console.lines.add('Adding new dir: '+temp);
    end

    else with RegEx do begin
        SetSubjectString (Text);
        NumResults := Match;

        if NumResults >= 0 then begin

            //console.Lines.Add('Stat=['+SubStrings[SSPerm]+'] Size=['+SubStrings[SSSize]+'] Date=['+SubStrings[SSDate]+'] File=['+SubStrings[SSName]+']');

            UpdateFilesRecieved;

            //PathName := Unescape(Substrings[SSName]);

            Node := RemoteTree.AddChild(CurrentDirNode);
            with PTreeData(RemoteTree.GetNodeData(Node))^ do
            begin
              FullPath := CurrentDirPath + Substrings[SSName];
              FileName := Substrings[SSName];
              FileSize := StrToInt(SubStrings[SSSize]);
              isFile := true;
              Date := UnixToDateTime(StrToInt(SubStrings[SSDate]));
            end;
        end
        else
          Console.Lines.Add('Nomatch: ' + Text);
    end;
  end;
end;
procedure TmainWindow.RemoteTreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
    NodeDataSize := SizeOf(rTreeData);
end;

procedure TmainWindow.RemoteTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
   NodeData: PTreeData;
begin
  NodeData := Sender.GetNodeData(Node);
  // return identifier of the node
  with NodeData^ do
      case column of
        0: CellText := FileName;
        1: if FileSize < 0 then
               CellText := ''
           else
               CellText := IntToStr(NodeData.FileSize);
        2: CellText := //FormatDateTime(LongDateFormat, NodeData.Date);
                       FormatDateTime(ShortDateFormat, NodeData.Date);
                       //DateTimeToStr(NodeData.Date);
      end;
end;

procedure TmainWindow.RemoteTreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
   NodeData: PTreeData;
begin
  NodeData := Sender.GetNodeData(Node);
  // return identifier of the node
  if column = 0 then
    if NodeData.isFile then
        ImageIndex := 2
    else
        if RemoteTree.Selected[Node] then
            ImageIndex := 1
        else
            ImageIndex := 0;
end;

procedure TmainWindow.RemoteTreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
    Sender.CheckType[Node] := ctTriStateCheckBox;
end;

// Compare two nodes for sorting.
procedure TmainWindow.RemoteTreeCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
   N1,
   N2   : PTreeData;
begin
  N1 := Sender.GetNodeData(Node1);
  N2 := Sender.GetNodeData(Node2);

  if N1.isFile <> N2.isFile then
  begin
    // one of both is a folder the other a file
    if N1.isFile then
      Result := 1
    else
      Result := -1;
  end
  else begin // both are of same type (folder or file)
    case Column of
      0: Result := CompareText(N1.FullPath, N2.FullPath);
      1: Result := N1.FileSize - N2.FileSize;
      2: Result := CompareDateTime(N1.Date, N2.Date);
    end;
  end;

end;

// Sort the tree when a column header is clicked.
procedure TmainWindow.RemoteTreeHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender do begin
    SortColumn := Column;
    if SortDirection = sdAscending then
      SortDirection := sdDescending
    else
      SortDirection := sdAscending;
  end;
end;

function getstatestring(n : PVirtualNode) : string;
var
  st:string;
begin
      st := '';

      if n.CheckState in
          [csUncheckedNormal] then st:=st+'csUncheckedNormal';  // unchecked and not pressed
      if n.CheckState in
          [csUncheckedPressed] then st:=st+'csUncheckedPressed'; // unchecked and pressed
      if n.CheckState in
          [csCheckedNormal] then st:=st+'csCheckedNormal';    // checked and not pressed
      if n.CheckState in
          [csCheckedPressed] then st:=st+'csCheckedPressed';   // checked and pressed
      if n.CheckState in
          [csMixedNormal] then st:=st+'csMixedNormal';      // 3-state check box and not pressed
      if n.CheckState in
          [csMixedPressed] then st:=st+'csMixedPressed';      // 3-state check box and pressed

    result := st;

end;

procedure TmainWindow.RemoteGetCheckedNodes(includefile : string);

  procedure RemoteGetCheckedNodesRecurse(n : PVirtualNode; s : TStrings);
  var
    p : PTreeData;
  begin
    while (n <> nil) (*and (n.NextSibling <> n)*) do begin
      p := RemoteTree.GetNodeData(n);
      if p = nil then begin
        //console.lines.Add('** P is nil?! WTF?! **');
      end
      else begin
        // debug
        //console.lines.Add('Node [state = '+ getstatestring(n) +']: ' + p.FullPath + ' | ' + p.FileName ) ;

        // Case 1: csMixedNormal (only available for dirs)
        //   - Want to add this directory and all checked subdirs,
        //     but then exclude the whole thing...
        if n.CheckState = csMixedNormal then begin
          assert(not p.isFile, 'Only dirs can be in state csmixednormal!');
          s.Add('+ '+p.FullPath);
            RemoteGetCheckedNodesRecurse(n.FirstChild, s);
          s.Add('- '+p.FullPath+'/*');
        end

        // Case 2: csCheckedNormal
        //    - Want to add this dir and all subdirs, or this file...
        else if n.CheckState = csCheckedNormal then begin
          // If this file is checked, add it.
          if p.isFile then begin
            s.Add('+ '+p.FullPath);
          end
          // It's a directory... we want the whole branch.
          // No more tree recusion necessary!
          else begin
            s.Add('+ '+p.FullPath);
            s.Add('+ '+p.FullPath+'/*');
          end;
        end;
      end; // p <> nil
      n := n.NextSibling;
    end;
  end;

var
  list : TStrings;
  f    : Textfile;
  i    : Integer;

begin
  list := TStringList.Create;
  try
    RemoteGetCheckedNodesRecurse(RemoteTree.RootNode.FirstChild, list);
    list.add('- *');

    AssignFile(f, includefile);
    Rewrite(f);
    for i := 0 to list.Count-1 do
      Write(f, list[i] + #10);
    CloseFile(f);

    console.Lines.AddStrings(list);
  finally
    list.Free;
  end;
end;

procedure TmainWindow.RestoreFilesButtonClick(Sender: TObject);
var
    Dir,
    IncludeFile : String;
begin
  Dir :='C:\';
  IncludeFile := Settings.WorkingDir + 'include.txt';

  SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt], 10000);

  RemoteGetCheckedNodes(includefile);
  lvkAnimatedTrayIcon1.Animated := True;

  //console.Lines.Add('Restoring to: ' + dir);
  rsync.OnTerm := RestoreComplete;
  rsync.DoRestore(IncludeFile, Dir);
end;

procedure TmainWindow.RestoreComplete;
begin
  lvkAnimatedTrayIcon1.Animated := False;
end;

//------------------------------------------------------------------------------
// Configuration Management
//------------------------------------------------------------------------------
const
    PAD1 = 'a#2jf89auw#JNmvZSD8fewj3M#RHNZSDFa8f@#H@$3q';
    PAD2 = '#@(8FGFdjdCXnsjQjzSHFDuef67ew4A##JraDSKHf76';
    CustomServer = False;
    shiftval = 65;

function chartostr(c:char):string;
begin
  result := chr((ord(c) shr 4) + shiftval) + chr((ord(c) and 15) + shiftval);
end;

function strtochar(c1, c2 : char):char;
begin
  result := chr( ((ord(c1)-shiftval) shl 4) or (ord(c2)-shiftval) );
end;

function CheapCrypt(S:String; Encrypt : Boolean):String;
var
    p1l,
    p2l,
    i   : integer;
    c : char;
    o : String;
begin
    p1l := length(PAD1);
    p2l := length(PAD2);

    o := '';
    c := ' ';

    if (encrypt) then begin
      for i := 1 to length(s) do begin
          c := Chr(Ord(s[i]) xor Ord(PAD1[i mod p1l]) xor Ord(PAD2[i mod p2l]));
          o := o + chartostr(c);
      end;
    end

    // Decrypt
    else begin
      for i := 1 to length(s) do begin
        if (i mod 2) = 0 then begin
          o := o + Chr(Ord(strtochar(c, s[i])) xor Ord(PAD1[(i div 2) mod p1l]) xor Ord(PAD2[(i div 2) mod p2l]));
        end
        else
          c := s[i];
      end;
    end;
    Result := o;
end;

procedure TmainWindow.SaveSettings;
begin
    try
     with Reg, Settings do begin
        RootKey := HKEY_CURRENT_USER;
        if OpenKey('\Software\Doris', True) then
        begin
          WriteString   ('Username',    Username);
//          WriteString   ('Password',    Password);
//          WriteString   ('Reserved',    Server);
          WriteString   ('Password',    CheapCrypt(Password, True));
          WriteString   ('Reserved',    CheapCrypt(Server, True));
          WriteBool     ('Overwrite',   Overwrite);
          WriteTime     ('LastBackup',  LastBackup);
          WriteTime     ('NextBackup',  NextBackup);
          WriteTime     ('StartingAt',  StartingAt);
          WriteInteger  ('Frequency',   Frequency);
          WriteInteger  ('FrequencyScale', FrequencyScale);
          WriteBool     ('Autorun',     Autorun);
          WriteBool     ('Autobackup',  Autobackup);
          RootKey := HKEY_CURRENT_USER;
          if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True) then           begin
            if Autorun then begin
              WriteString('DorisData','"' + ParamStr(0) + '" -hidden');
            end
            else begin
              DeleteValue('DorisData');
            end;
          end;
          CloseKey;
        end;

        SettingSynchedUpdate;

     end; // end With Reg,Settings
    except
//      MessageDlg('Whoops! Key''s not there. Too bad.', mtWarning, [mbOK], 0);
    end;
end;

procedure TmainWindow.RestoreSettings;
begin
    try
      with Reg, Settings do begin
        RootKey := HKEY_CURRENT_USER;
        if OpenKey('\Software\Doris', True) then
        begin

          if (ValueExists('Username')) then
            Username      := ReadString('Username');
          if (ValueExists('Password')) then
            Password      := CheapCrypt(ReadString('Password'), False);
          if (ValueExists('Reserved')) then
            Server        := CheapCrypt(ReadString('Reserved'), False);
          if (ValueExists('Overwrite')) then
            Overwrite     := ReadBool('Overwrite');
          if (ValueExists('LastBackup')) then
            LastBackup    := ReadTime('LastBackup');
          if (ValueExists('NextBackup')) then
            NextBackup    := ReadTime('NextBackup');
          if (ValueExists('StartingAt')) then
            StartingAt    := ReadTime('StartingAt');
          if (ValueExists('Frequency')) then
            Frequency     := ReadInteger('Frequency');
          if (ValueExists('FrequencyScale')) then
            FrequencyScale:= ReadInteger('FrequencyScale');
          if (ValueExists('Autorun')) then
            Autorun       := ReadBool('Autorun');
          if (ValueExists('Autobackup')) then
            Autobackup    := ReadBool('Autobackup');

          CloseKey;
        end;
        if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True) then
        begin
            chkAutoBackup.Checked := (ReadString('DorisData') <> '');
        end;

        SynchFieldsWithSettings;
        SettingSynchedUpdate;

      end; // with Reg,Settings do
    except
      on ERegistryException do
      MessageDlg('Whoops! Key''s not there. Too bad.', mtWarning, [mbOK], 0);
    end;
end;

procedure TmainWindow.SynchFieldsWithSettings;
begin
    with Settings do begin
        configUser.Text             := Username;
        configPassword.Text         := Password;
        configServer.Text           := Server;
        overwriteNewToggle.Checked  := Overwrite;

        if (NextBackup <> 0) and (not chkAutoBackup.Checked) then
            chkAutoBackup.Checked := True;

        BackupFrequency.Text            := IntToStr(Frequency);
        BackupFrequencyScale.ItemIndex  := FrequencyScale;

        chkAutorun.Checked              := Autorun;
    end;
end;

procedure TmainWindow.SettingChangedUpdate;
begin
    if not SettingChanged then begin
        saveSettingsButton.Enabled := True;
        restoreSettingsButton.Enabled := True;
        SettingChanged := True;
    end;
end;

//===============
// Auto-Backup Timer
//===============

procedure TmainWindow.RestartTimer;
var
    freq : Integer;
begin
  if (BackingUpNow) then
    ShowMessage('Can''t Restart Timer -- Backing Up!')
  else with Settings do begin
      NextBackup := Now;
      try
        freq := StrToInt(BackupFrequency.Text);
        case BackupFrequencyScale.ItemIndex of
            0: NextBackup := IncMinute(NextBackup, freq);
            1: NextBackup := IncHour(NextBackup, freq);
            2: NextBackup := IncDay(NextBackup, freq);
            3: NextBackup := IncWeek(NextBackup, freq);
            4: NextBackup := IncMonth(NextBackup, freq);
        end;
        StartingAtTimePicker.DateTime := NextBackup;
        StartingAtDatePicker.DateTime := NextBackup;
        DisplayTimeLeft;
        BackupTimer.Enabled := True;
      except
        on EConvertError do abort;
      end;
  end;
end;

procedure TmainWindow.PauseTimer;
begin
  BackupTimer.Enabled := False;
  BackingUpNow := True;
end;

procedure TmainWindow.chkAutoBackupClick(Sender: TObject);
begin
    if chkAutoBackup.Checked then begin
        // Button has been checked
        RestartTimer;
        SettingChanged := True;
        SaveSettings;
    end
    else begin
        // Button has been unchecked
        Settings.NextBackup := 0;
        BackupTimer.Enabled := False;
        DisplayTimeLeft;
        SaveSettings;
    end;
end;

procedure TmainWindow.DisplayTimeLeft;
const
    minute = 60;
    hour = minute * 60;
    day = hour * 24;
    week = day * 7;
var
    secs : integer;
    TimeLeftString : string;
begin
  with Settings do

    if NextBackup > 0 then begin
        secs := SecondsBetween(NextBackup, Now);
        TimeLeftString := '';

        if secs >= week then
            TimeLeftString := TimeLeftString + IntToStr(secs div week) + ' weeks, ';
        if secs >= day then
            TimeLeftString := TimeLeftString + IntToStr(secs mod week div day) + ' days, ';
        if secs >= hour then
            TimeLeftString := TimeLeftString + IntToStr(secs mod week mod day div hour) + ' hours, ';
        if secs >= minute then
            TimeLeftString := TimeLeftString + IntToStr(secs mod week mod day mod hour div minute) + ' mins, ';

        TimeLeftString := TimeLeftString + IntToStr(secs mod minute) + ' secs';
    end

    else
        TimeLeftString := 'never';

    BackupTimeLeftLabel.Caption := TimeLeftString;
    BackupTimeLeftLabel.Refresh;
    lvkAnimatedTrayIcon1.Hint := '[Doris Data] Next backup in: '+TimeLeftString;

end;

procedure TmainWindow.TimerUpdate(Sender: TObject);
begin
    DisplayTimeLeft;

    // Check if it's backup time!
    if Now >= Settings.NextBackup then begin
        Settings.LastBackup := Now;
        btnBackupNowClick(self);
    end;
end;

procedure TmainWindow.BackupFrequencyScaleChange(Sender: TObject);
begin
    RestartTimer;
    Settings.FrequencyScale := BackupFrequencyScale.ItemIndex;
    SettingChangedUpdate;
end;

procedure TmainWindow.StartingAtTimePickerChange(Sender: TObject);
begin
  //Settings.NextBackup := StartingAtTimePicker.DateTime;
//  StartingAtDatePicker.Time := StartingAtTimePicker.Time;
  StartingAtDatePicker.DateTime := StartingAtTimePicker.DateTime;
  //DisplayTimeLeft;
end;

procedure TmainWindow.StartingAtDatePickerChange(Sender: TObject);
begin
//  Settings.NextBackup := StartingAtDatePicker.DateTime;
  StartingAtTimePicker.DateTime := StartingAtDatePicker.DateTime;
//  StartingAtTimePicker.Date := StartingAtDatePicker.Date;
//  DisplayTimeLeft;
end;

procedure TmainWindow.SetStartTimeClick(Sender: TObject);
begin
  Settings.NextBackup := StartingAtTimePicker.DateTime;
  DisplayTimeLeft;
end;

//=================
// Executed when settings have been synched
// (to disable Save/Restore settings buttons
//=================
procedure TmainWindow.SettingSynchedUpdate;
begin
    saveSettingsButton.Enabled := False;
    restoreSettingsButton.Enabled := False;
    if SettingChanged then begin
        SettingChanged := False;
    end;
end;

// ----------
// Components Changed Callbacks
// ----------

procedure TmainWindow.configUserChange(Sender: TObject);
begin
    Settings.Username := configUser.Text;
    SettingChangedUpdate;
end;

procedure TmainWindow.configPasswordChange(Sender: TObject);
begin
    Settings.Password := configPassword.Text;
    SettingChangedUpdate;
end;

procedure TmainWindow.configServerChange(Sender: TObject);
begin
    Settings.Server := configServer.Text;
    SettingChangedUpdate;
end;

procedure TmainWindow.chkAutoRunAtStartupClick(Sender: TObject);
begin
    Settings.Autorun := chkAutorun.Checked;
    SettingChangedUpdate;
end;

procedure TmainWindow.overwriteNewToggleClick(Sender: TObject);
begin
    Settings.Overwrite := overwriteNewToggle.Checked;
    SettingChangedUpdate;
end;

procedure TmainWindow.BackupFrequencyChange(Sender: TObject);
begin
  try
    if StrToInt(BackupFrequency.Text) > 0 then begin
        Settings.Frequency := StrToInt(BackupFrequency.Text);
        RestartTimer;
        SettingChangedUpdate;
    end;
  except
    on EIntError do
      ShowMessage('HEY GUYS!');
//      BackupFrequency.Text := '0';
  end;
end;

procedure TmainWindow.saveSettingsButtonClick(Sender: TObject);
begin
    SaveSettings;
end;

procedure TmainWindow.restoreSettingsButtonClick(Sender: TObject);
begin
    RestoreSettings;
end;

procedure TmainWindow.URLClick(Sender: TObject);
begin
  If (Sender is TLabel) then
    with (Sender as Tlabel) do
      ShellExecute(Application.Handle,
                   PChar('open'),
                   PChar(Hint),
                   PChar(0),
                   nil,
                   SW_NORMAL);
end;

//------------------------------------------------------------------------------
// Main Window Events
//------------------------------------------------------------------------------
procedure TmainWindow.mainWindowCreate(Sender: TObject);
begin
    versionLabel.Caption := SettingsUnit.Version;

    StartingAtDatePicker.DateTime := Now;
    StartingAtTimePicker.DateTime := Now;

    RestoreSettings;
    BuildVETTree;
    LoadVETTree;

    if paramstr(1) = '-hidden' then
        mainWindow.Hide
    else
        mainWindow.Show;
end;

procedure TmainWindow.mainWindowDestroy(Sender: TObject);
begin
    SaveSettings;
    ShowMessage('Saved!');
end;

procedure TmainWindow.CloseClick(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := False;
    mainWindow.Hide;
end;


procedure TmainWindow.TrayIconClick(Sender: TObject);
begin
  if (mainWindow.Visible) then begin
    mainWindow.Hide;
  end
  else begin
    mainWindow.Show;
    SetForegroundWindow(mainWindow.Handle);
  end;
end;

procedure TmainWindow.VETChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
//    SaveBackupDirsButton.Enabled := True;
//    LoadBackupDirsButton.Enabled := True;
end;

procedure TmainWindow.VETChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    SaveBackupDirsButton.Enabled := True;
    LoadBackupDirsButton.Enabled := True;
end;

procedure TmainWindow.BackupTreeFilesCheckboxClick(Sender: TObject);
begin
  with VET do
  if BackupTreeFilesCheckbox.Checked then begin
    FileObjects := FileObjects + [foNonFolders];
    TreeOptions.VETMiscOptions := TreeOptions.VETMiscOptions - [toChangeNotifierThread];
  end else begin
    FileObjects := FileObjects - [foNonFolders];
    TreeOptions.VETMiscOptions := TreeOptions.VETMiscOptions + [toChangeNotifierThread];
  end;
end;


procedure TmainWindow.ExitButtonClick(Sender: TObject);
begin
    mainWindow.OnCloseQuery := nil;
    mainWindow.Close;
end;

procedure TmainWindow.MinimizeButtonClick(Sender: TObject);
begin
  mainWindow.Hide;
end;

initialization
    SettingChanged := false;
    Reg := TRegistry.Create;

end.



