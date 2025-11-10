unit spashScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls;

type
  TSplashScreen = class(TForm)
    SplashImage: TImage;
    VersionLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashScreen : TSplashScreen;

implementation

{$R *.dfm}

end.
