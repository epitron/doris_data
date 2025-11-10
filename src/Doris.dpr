program Doris;

uses
  Forms,
  spashScreenUnit in 'spashScreenUnit.pas' {SplashScreen},
  mainWindowUnit in 'mainWindowUnit.pas' {mainWindow},
  processThreadUnit in 'processThreadUnit.pas',
  rsyncUnit in 'rsyncUnit.pas' {rsync},
  SettingsUnit in 'SettingsUnit.pas',
  Grabag in 'Grabag.pas';

{$R *.res}

begin
  SplashScreen := TSplashScreen.Create(Application);
  SplashScreen.VersionLabel.Caption := SettingsUnit.Version;
  SplashScreen.Show;

  Application.Initialize;
  SplashScreen.Update;

  Application.Title := 'Doris Data';
  Application.CreateForm(TmainWindow, mainWindow);
  Application.CreateForm(Trsync, rsync);
  Application.ShowMainForm := False;

  SplashScreen.Hide;
  SplashScreen.Free;

  Application.Run;
end.
