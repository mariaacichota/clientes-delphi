unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus,
  uClienteView, uRelatorioView, FireDAC.Phys.FBDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TfrmPrincipal = class(TForm)
    mnPrincipal: TMainMenu;
    mnSistema: TMenuItem;
    subSair: TMenuItem;
    mnCadastros: TMenuItem;
    subCliente: TMenuItem;
    mnRelatorios: TMenuItem;
    subRelatorio: TMenuItem;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;

    procedure subSairClick(Sender: TObject);
    procedure subClienteClick(Sender: TObject);
    procedure subRelatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  frmCliente: TfrmCliente;
  frmRelatorio: TfrmRelatorio;

implementation

{$R *.dfm}

procedure TfrmPrincipal.subClienteClick(Sender: TObject);
begin
  frmCliente := TfrmCliente.Create(nil);

  try
    frmCliente.ShowModal;
  finally
    frmCliente.Free;
  end;
end;

procedure TfrmPrincipal.subRelatorioClick(Sender: TObject);
begin
  frmRelatorio := TfrmRelatorio.Create(nil);

  try
    frmRelatorio.ShowModal;
  finally
    frmRelatorio.Free;
  end;
end;

procedure TfrmPrincipal.subSairClick(Sender: TObject);
begin
  Close;
end;

end.
