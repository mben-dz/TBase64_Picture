program Base64;

uses
  Vcl.Forms,
  API.Base64 in '..\API\API.Base64.pas',
  API.Types in '..\API\API.Types.pas',
  Main.View in 'Main.View.pas' {MainView};

{$R *.res}

var
  MainView: TMainView;
begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
