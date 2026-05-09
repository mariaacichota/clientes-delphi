unit uClienteView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ComCtrls, REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON,
  uClienteController,
  uClienteDAO,
  uClienteModel,
  FireDAC.Comp.Client,
  System.MaskUtils,
  System.Character;

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
    procedure FormCreate(Sender: TObject);
    procedure edtCPFCNPJChange(Sender: TObject);
    procedure edtCEPChange(Sender: TObject);
    procedure edtNumeroKeyPress(Sender: TObject; var Key: Char);
    procedure ckSemNumeroClick(Sender: TObject);
    procedure edtDataNascimentoExit(Sender: TObject);
    procedure cbUFChange(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);

  private
    FIdCliente: Integer;

    procedure LimparCampos;
    procedure CarregarCliente(Qry: TFDQuery);
    procedure CarregarUFs;
    procedure CarregarCidades(AUF: String);
    procedure VerificaESalvaCidade(mCliente: TCliente);
  public
    { Public declarations }
  end;

var
  frmCliente: TfrmCliente;

implementation

uses
  uEstadoDAO, uCidadeDAO, uConexao;

{$R *.dfm}

procedure TfrmCliente.btnBuscarClick(Sender: TObject);
var
  DAO: TClienteDAO;
  Qry: TFDQuery;
  TextoBusca: String;
begin
  DAO := TClienteDAO.Create;

  try
//    TextoBusca :=
//      Trim(edtCPFCNPJ.Text);
//
//    if TextoBusca <> '' then
//    begin
//      Qry := DAO.BuscarPorCPFCNPJ(ApenasNumeros(TextoBusca));
//    end
//    else
    begin
      TextoBusca :=
        Trim(edtNome.Text);

      if TextoBusca = '' then
      begin
        ShowMessage(
          'Informe um Nome ou CPF/CNPJ.'
        );

        Exit;
      end;

      Qry := DAO.BuscarPorNome(
        TextoBusca
      );
    end;

    try
      if Qry.IsEmpty then
      begin
        ShowMessage(
          'Cliente não encontrado.'
        );

        Exit;
      end;

      if Qry.RecordCount = 1 then
      begin
        CarregarCliente(Qry);
      end
      else
      begin
        ShowMessage(
          'Mais de um cliente encontrado. Refinar pesquisa.'
        );
      end;

    finally
      Qry.Free;
    end;

  finally
    DAO.Free;
  end;
end;

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
  Controller: TClienteController;
begin
  Cliente := TCliente.Create;
  DAO := TClienteDAO.Create;

  VerificaESalvaCidade(Cliente);

  try
    Cliente.ID := FIdCliente;

    Cliente.Nome := edtNome.Text;

    Controller := TClienteController.Create;
    try
      Cliente.CEP := Controller.ApenasNumeros(edtCEP.Text);
      Cliente.CPFCNPJ := Controller.ApenasNumeros(edtCPFCNPJ.Text);
    finally
      Controller.Free;
    end;

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
      Cliente.ID := TConexao.GetNextID('GEN_CLIENTE_ID');

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

procedure TfrmCliente.edtCEPChange(Sender: TObject);
var
  Texto: String;
  Controller: TClienteController;
begin

  Controller := TClienteController.Create;
  try
    Texto := Controller.ApenasNumeros(
      edtCEP.Text
    );

    edtCEP.OnChange := nil;

    try
      edtCEP.Text :=
        FormatMaskText(
          '00000\-000;0',
          Texto
        );

      edtCEP.SelStart :=
        Length(edtCEP.Text);

    finally
      edtCEP.OnChange :=
        edtCEPChange;
    end;

  finally
    Controller.Free;
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

procedure TfrmCliente.edtCPFCNPJChange(Sender: TObject);
var
  Texto: String;
  Controller: TClienteController;
begin

  Controller := TClienteController.Create;
  try
    Texto := Controller.ApenasNumeros(edtCPFCNPJ.Text);

    edtCPFCNPJ.OnChange := nil;
    try
      if Length(Texto) <= 11 then
        begin
          edtCPFCNPJ.Text := FormatMaskText('000\.000\.000\-00;0', Texto);
        end
      else
        begin
          edtCPFCNPJ.Text := FormatMaskText('00\.000\.000\/0000\-00;0', Texto);
        end;

      edtCPFCNPJ.SelStart := Length(edtCPFCNPJ.Text);

    finally
      edtCPFCNPJ.OnChange := edtCPFCNPJChange;
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

procedure TfrmCliente.edtDataNascimentoExit(Sender: TObject);
begin
  if edtDataNascimento.Date > Date then
    begin
      ShowMessage('A data de nascimento não pode ser maior que hoje.');
      edtDataNascimento.Date := Date;

      Abort;
    end;
end;

procedure TfrmCliente.edtNumeroKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmCliente.FormCreate(Sender: TObject);
begin
  edtDataNascimento.MaxDate := Date;

  CarregarUFs;
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

procedure TfrmCliente.VerificaESalvaCidade(mCliente: TCliente);
var
  CidadeDAO: TCidadeDAO;
  CidadeID: Integer;
begin
  CidadeDAO := TCidadeDAO.Create;

  try
    CidadeID := CidadeDAO.BuscarCidade(cbCidade.Text, cbUF.Text);

    if CidadeID = 0 then
      CidadeID := CidadeDAO.InserirCidade(cbCidade.Text, cbUF.Text);

    mCliente.Cidade := CidadeID;

  finally
    CidadeDAO.Free;
  end;
end;

procedure TfrmCliente.CarregarCidades(AUF: String);
var
  DAO: TCidadeDAO;
  Qry: TFDQuery;
begin
  DAO := TCidadeDAO.Create;
  try
    Qry := DAO.ListarPorEstado(AUF);
    try
      cbCidade.Items.Clear;

      while not Qry.Eof do
        begin
          cbCidade.Items.AddObject(
            Qry.FieldByName('NOME').AsString,
            TObject(Qry.FieldByName('ID').AsInteger));

          Qry.Next;
        end;

    finally
      Qry.Free;
    end;

  finally
    DAO.Free;
  end;
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

procedure TfrmCliente.CarregarUFs;
var
  DAO: TEstadoDAO;
  Qry: TFDQuery;
begin
  DAO := TEstadoDAO.Create;
  try
    Qry := DAO.ListarEstados;
    try
      cbUF.Items.Clear;

      while not Qry.Eof do
        begin
          cbUF.Items.Add(Qry.FieldByName('UF').AsString);
          Qry.Next;
        end;

    finally
      Qry.Free;
    end;

  finally
    DAO.Free;
  end;
end;

procedure TfrmCliente.cbUFChange(Sender: TObject);
begin
  if cbUF.ItemIndex >= 0 then
    CarregarCidades(cbUF.Items[cbUF.ItemIndex]);
end;

procedure TfrmCliente.ckSemNumeroClick(Sender: TObject);
begin
  edtNumero.Enabled :=
    not ckSemNumero.Checked;

  if ckSemNumero.Checked then
    edtNumero.Text := 'S/N'
  else
    edtNumero.Clear;
end;

end.
