program rdbPoxy;

uses
  SysUtils,
  rdbProxy1 in 'rdbProxy1.pas';

{$R *.res}

begin
  if ParamCount=0 then
    raise Exception.Create('Define host in command line');
  TRDBProxy.Create.Perform;
end.
