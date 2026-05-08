program CartSysClientes;

uses
  Vcl.Forms,
  uClienteDAO in '..\DAO\uClienteDAO.pas',
  uConexao in '..\DAO\uConexao.pas',
  uCidadeModel in '..\Model\uCidadeModel.pas',
  uClienteModel in '..\Model\uClienteModel.pas',
  uEstadoModel in '..\Model\uEstadoModel.pas',
  uClienteController in '..\Controller\uClienteController.pas',
  uClienteView in '..\View\uClienteView.pas' {frmCliente},
  uPrincipal in '..\View\uPrincipal.pas' {frmPrincipal},
  uRelatorioView in '..\View\uRelatorioView.pas' {frmRelatorio};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCliente, frmCliente);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmRelatorio, frmRelatorio);
  Application.Run;
end.
