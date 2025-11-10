![](https://raw.githubusercontent.com/epitron/doris_data/master/screenshots/doris-splashscreen.png)

## Summary

Doris Data is a Windows GUI application that lets you flag folders and files for backup, then automatically backs them up to any `ssh`-enabled server.  Plus, if you're backing up large files that have small changes in them (eg. databases), only the changed segments of those files are backed up (thanks to `rsync`'s rolling CRC check).

It's simple, fast, and effective.

## Technology

Doris was written in Borland Delphi 6.0. Internally, it uses the opensource programs `ssh` and `rsync` which I modified (source code available) to communicate the progress of the file transfers to the GUI.

## Download

  * [Doris Data](https://raw.githubusercontent.com/epitron/doris_data/master/releases/doris-win32.zip) (alpha version)

_Just unzip this to any directory and run Doris.exe_

## Screenshots

__Backup configuration screen...__
![](https://raw.githubusercontent.com/epitron/doris_data/master/screenshots/doris-screenshot1.png)

__Restore previously backed up files...__
![](https://raw.githubusercontent.com/epitron/doris_data/master/screenshots/doris-screenshot2.png)

__Setup servers...__
![](https://raw.githubusercontent.com/epitron/doris_data/master/screenshots/doris-screenshot3.png)

__System tray icon (the little wrench spins when a backup is in progress)__
![](https://raw.githubusercontent.com/epitron/doris_data/master/screenshots/doris-screenshot4.png)
