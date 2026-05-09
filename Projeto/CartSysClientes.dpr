program CartSysClientes;

uses
  Vcl.Forms,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  uClienteDAO in '..\DAO\uClienteDAO.pas',
  uConexao in '..\DAO\uConexao.pas',
  uCidadeModel in '..\Model\uCidadeModel.pas',
  uClienteModel in '..\Model\uClienteModel.pas',
  uEstadoModel in '..\Model\uEstadoModel.pas',
  uClienteController in '..\Controller\uClienteController.pas',
  uClienteView in '..\View\uClienteView.pas' {frmCliente},
  uPrincipal in '..\View\uPrincipal.pas' {frmPrincipal},
  uRelatorioView in '..\View\uRelatorioView.pas' {frmRelatorio},
  uEstadoDAO in '..\DAO\uEstadoDAO.pas',
  uCidadeDAO in '..\DAO\uCidadeDAO.pas',
  RelatorioDAO in '..\DAO\RelatorioDAO.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCliente, frmCliente);
  Application.CreateForm(TfrmRelatorio, frmRelatorio);
  Application.Run;
end.
