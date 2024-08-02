program Base64;

uses
  System.StartUpCopy,
  FMX.Forms,
  API.Base64 in '..\API\API.Base64.pas',
  API.Types in '..\API\API.Types.pas',
  Main.View in 'Main.View.pas' {MainView};

{$R *.res}

var
  MainView: TMainView;
begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
