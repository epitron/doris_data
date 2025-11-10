unit Grabag;

interface

uses SysUtils;

function ReadAStatistic(Line, Token : string; var Stat : String) : boolean;
Function FormatSize(I: Int64): String;

implementation

function ReadAStatistic(Line, Token : string; var Stat : String) : boolean;
begin
  if copy(line, 1, length(token)) = token then
  begin
    stat := copy(line, length(token)+1, length(line));
    result := true;
  end else
    result := false;
end;

Function FormatSize(I: Int64): String;
Const
  SizeSuffix: Array[0..4] Of String = ('', 'kB', 'mB', 'gB', 'tB');
Var
  ss: Integer;
Begin
  ss := 0;
  While (ss < 4) And (I Shr (10 * ss) >= 1024) Do
    Inc(ss);
  Result := Format('%0.4g %s', [I / (1 Shl (10 * ss)), SizeSuffix[ss]]);
End;

end.
