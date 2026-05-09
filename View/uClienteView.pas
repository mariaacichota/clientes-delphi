unit uClienteView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ComCtrls, REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON,
  uClienteController,
  uClienteDAO,
  uClienteModel, FireDAC.Comp.Client;

type
  TfrmCliente = class(TForm)
    pnlGeral: TPanel;
    edtNome: TEdit;
    edtEndereco: TEdit;
    edtCEP: TEdit;
    edtCPFCNPJ: TEdit;
    edtNumero: TEdit;
    cbCidade: TComboBox;
    cbUF: TComboBox;
    lblName: TLabel;
    lblCPFCNPJ: TLabel;
    lblEndereco: TLabel;
    lblNumero: TLabel;
    lblCEP: TLabel;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblCidade: TLabel;
    lblUF: TLabel;
    lblDataNascimento: TLabel;
    ckSemNumero: TCheckBox;
    edtDataNascimento: TDateTimePicker;
    pnlFooter: TPanel;
    btnSalvar: TButton;
    btnExcluir: TButton;
    btnBuscar: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure edtCEPExit(Sender: TObject);
    procedure edtCPFCNPJExit(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);

  private
    FIdCliente: Integer;

    procedure LimparCampos;
    procedure CarregarCliente(Qry: TFDQuery);
  public
    { Public declarations }
  end;

var
  frmCliente: TfrmCliente;

implementation

{$R *.dfm}

procedure TfrmCliente.btnExcluirClick(Sender: TObject);
var
  DAO: TClienteDAO;
begin
  if FIdCliente = 0 then
  begin
    ShowMessage('Nenhum cliente carregado.');
    Exit;
  end;

  if MessageDlg(
       'Deseja realmente excluir este cliente?',
       mtConfirmation,
       [mbYes, mbNo],
       0
     ) = mrNo then
    Exit;

  DAO := TClienteDAO.Create;

  try
    DAO.Excluir(FIdCliente);

    ShowMessage('Cliente excluído com sucesso.');

    LimparCampos;

  finally
    DAO.Free;
  end;
end;

procedure TfrmCliente.btnSalvarClick(Sender: TObject);
var
  Cliente: TCliente;
  DAO: TClienteDAO;
begin
  Cliente := TCliente.Create;
  DAO := TClienteDAO.Create;

  try
    Cliente.ID := FIdCliente;

    Cliente.Nome := edtNome.Text;
    Cliente.CEP := edtCEP.Text;
    Cliente.CPFCNPJ := edtCPFCNPJ.Text;
    Cliente.Endereco := edtEndereco.Text;
    Cliente.Numero := edtNumero.Text;
    Cliente.Complemento := '';
    Cliente.Bairro := edtBairro.Text;

    if cbCidade.Items.Count > 0 then
      Cliente.Cidade := Integer(
        cbCidade.Items.Objects[
          cbCidade.ItemIndex
        ]
      );

    Cliente.DataNascimento :=
      edtDataNascimento.Date;

    if Cliente.ID = 0 then
    begin
      Cliente.ID := Random(999999);

      DAO.Inserir(Cliente);

      ShowMessage('Cliente cadastrado com sucesso.');
    end
    else
    begin
      DAO.Alterar(Cliente);

      ShowMessage('Cliente alterado com sucesso.');
    end;

    LimparCampos;

  finally
    Cliente.Free;
    DAO.Free;
  end;
end;

procedure TfrmCliente.edtCEPExit(Sender: TObject);
var
  Controller: TClienteController;
  Endereco: TEnderecoDTO;
begin
  if (Trim(edtCEP.Text).IsEmpty) then
    Exit;

  Controller := TClienteController.Create;

  try
    if Controller.BuscarCEP(edtCEP.Text, Endereco) then
    begin
      edtEndereco.Text := Endereco.Logradouro;
      edtBairro.Text := Endereco.Bairro;
      cbCidade.Text := Endereco.Cidade;
      cbUF.Text := Endereco.UF;
    end
    else
    begin
      ShowMessage('CEP não encontrado.');
    end;

  finally
    Controller.Free;
  end;
end;

procedure TfrmCliente.edtCPFCNPJExit(Sender: TObject);
var
  Controller: TClienteController;
  Qry: TFDQuery;
  Resposta: Integer;
begin
  if (Trim(edtCPFCNPJ.Text).IsEmpty) then
    Exit;

  Controller := TClienteController.Create;

  try
    if not Controller.ValidarCPFCNPJ(edtCPFCNPJ.Text) then
    begin
      ShowMessage('CPF/CNPJ inválido.');

      edtCPFCNPJ.SetFocus;
    end;

    if Controller.ClienteExiste(edtCPFCNPJ.Text, Qry) then
    begin
      Resposta := MessageDlg(
        'Cliente já cadastrado.' + sLineBreak +
        'Deseja visualizar o cadastro?',
        mtConfirmation,
        [mbYes, mbNo],
        0
      );

      if Resposta = mrYes then
      begin
        CarregarCliente(Qry);
      end
      else
      begin
        edtCPFCNPJ.Clear;
        edtCPFCNPJ.SetFocus;
      end;

      Qry.Free;
    end;

  finally
    Controller.Free;
  end;
end;

procedure TfrmCliente.LimparCampos;
begin
  FIdCliente := 0;

  edtNome.Clear;
  edtCEP.Clear;
  edtCPFCNPJ.Clear;
  edtEndereco.Clear;
  edtNumero.Clear;
  edtBairro.Clear;

  cbCidade.ItemIndex := -1;
  cbUF.ItemIndex := -1;

  edtDataNascimento.Date := Date;
end;

procedure TfrmCliente.CarregarCliente(Qry: TFDQuery);
begin
  FIdCliente := Qry.FieldByName('ID').AsInteger;

  edtNome.Text := Qry.FieldByName('NOME').AsString;
  edtCEP.Text := Qry.FieldByName('CEP').AsString;
  edtCPFCNPJ.Text := Qry.FieldByName('CPF_CNPJ').AsString;
  edtEndereco.Text := Qry.FieldByName('ENDERECO').AsString;
  edtNumero.Text := Qry.FieldByName('NUMERO').AsString;
  edtBairro.Text := Qry.FieldByName('BAIRRO').AsString;
  cbCidade.Text := Qry.FieldByName('NOME_CIDADE').AsString;
  cbUF.Text := Qry.FieldByName('UF').AsString;
  edtDataNascimento.Date := Qry.FieldByName('DATANASCIMENTO').AsDateTime;
end;

end.
