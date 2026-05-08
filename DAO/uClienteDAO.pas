unit uClienteDAO;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uClienteModel;

type
  TClienteDAO = class
  public
    procedure Inserir(mCliente: TCliente);
    procedure Alterar(mCliente: TCliente);
    procedure Excluir(mId: Integer);

    function Pesquisar(mNome: String): TFDQuery;
    function BuscarPorID(mId: Integer): TFDQuery;
    function ListarTodos: TFDQuery;
  end;

implementation

uses
  uConexao;

procedure TClienteDAO.Inserir(mCliente: TCliente);
var
  Qry: TFDQuery;
  Conn: TFDConnection;
begin
  Conn := TConexao.GetConnection;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;

    Conn.StartTransaction;

    try
      Qry.SQL.Text :=
        'INSERT INTO CLIENTE (' +
        'ID, NOME, CEP, CPF_CNPJ, ENDERECO, ' +
        'NUMERO, COMPLEMENTO, BAIRRO, CIDADE, DATANASCIMENTO' +
        ') VALUES (' +
        ':ID, :NOME, :CEP, :CPF_CNPJ, :ENDERECO, ' +
        ':NUMERO, :COMPLEMENTO, :BAIRRO, :CIDADE, :DATANASCIMENTO' +
        ')';

      Qry.ParamByName('ID').AsInteger := mCliente.ID;
      Qry.ParamByName('NOME').AsString := mCliente.Nome;
      Qry.ParamByName('CEP').AsString := mCliente.CEP;
      Qry.ParamByName('CPF_CNPJ').AsString := mCliente.CPFCNPJ;
      Qry.ParamByName('ENDERECO').AsString := mCliente.Endereco;
      Qry.ParamByName('NUMERO').AsString := mCliente.Numero;
      Qry.ParamByName('COMPLEMENTO').AsString := mCliente.Complemento;
      Qry.ParamByName('BAIRRO').AsString := mCliente.Bairro;
      Qry.ParamByName('CIDADE').AsInteger := mCliente.Cidade;
      Qry.ParamByName('DATANASCIMENTO').AsDate := mCliente.DataNascimento;

      Qry.ExecSQL;

      Conn.Commit;

    except
      on E: Exception do
      begin
        Conn.Rollback;

        raise Exception.Create(
          'Erro ao inserir cliente: ' +
          E.Message
        );
      end;
    end;

  finally
    Qry.Free;
  end;
end;

procedure TClienteDAO.Alterar(mCliente: TCliente);
var
  Qry: TFDQuery;
  Conn: TFDConnection;
begin
  Conn := TConexao.GetConnection;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;

    Conn.StartTransaction;

    try
      Qry.SQL.Text :=
        'UPDATE CLIENTE SET ' +
        'NOME = :NOME, ' +
        'CEP = :CEP, ' +
        'CPF_CNPJ = :CPF_CNPJ, ' +
        'ENDERECO = :ENDERECO, ' +
        'NUMERO = :NUMERO, ' +
        'COMPLEMENTO = :COMPLEMENTO, ' +
        'BAIRRO = :BAIRRO, ' +
        'CIDADE = :CIDADE, ' +
        'DATANASCIMENTO = :DATANASCIMENTO ' +
        'WHERE ID = :ID';

      Qry.ParamByName('ID').AsInteger          := mCliente.ID;
      Qry.ParamByName('NOME').AsString         := mCliente.Nome;
      Qry.ParamByName('CEP').AsString          := mCliente.CEP;
      Qry.ParamByName('CPF_CNPJ').AsString     := mCliente.CPFCNPJ;
      Qry.ParamByName('ENDERECO').AsString     := mCliente.Endereco;
      Qry.ParamByName('NUMERO').AsString       := mCliente.Numero;
      Qry.ParamByName('COMPLEMENTO').AsString  := mCliente.Complemento;
      Qry.ParamByName('BAIRRO').AsString       := mCliente.Bairro;
      Qry.ParamByName('CIDADE').AsInteger      := mCliente.Cidade;
      Qry.ParamByName('DATANASCIMENTO').AsDate := mCliente.DataNascimento;

      Qry.ExecSQL;

      Conn.Commit;

    except
      on E: Exception do
      begin
        Conn.Rollback;

        raise Exception.Create(
          'Erro ao alterar cliente: ' +
          E.Message
        );
      end;
    end;

  finally
    Qry.Free;
  end;
end;

procedure TClienteDAO.Excluir(mId: Integer);
var
  Qry: TFDQuery;
  Conn: TFDConnection;
begin
  Conn := TConexao.GetConnection;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;

    Conn.StartTransaction;
    try
      Qry.SQL.Text :=
        'DELETE FROM CLIENTE ' +
        'WHERE ID = :ID';

      Qry.ParamByName('ID').AsInteger := mId;

      Qry.ExecSQL;

      Conn.Commit;

    except
      on E: Exception do
      begin
        Conn.Rollback;

        raise Exception.Create(
          'Erro ao excluir cliente: ' +
          E.Message
        );
      end;
    end;

  finally
    Qry.Free;
  end;
end;

function TClienteDAO.Pesquisar(mNome: String): TFDQuery;
begin
  Result := TFDQuery.Create(nil);

  Result.Connection := TConexao.GetConnection;

  Result.SQL.Text :=
    'SELECT * FROM CLIENTE ' +
    'WHERE NOME CONTAINING :NOME ' +
    'ORDER BY NOME';

  Result.ParamByName('NOME').AsString := mNome;

  Result.Open;
end;

function TClienteDAO.BuscarPorID(mId: Integer): TFDQuery;
begin
  Result := TFDQuery.Create(nil);

  Result.Connection := TConexao.GetConnection;

  Result.SQL.Text :=
    'SELECT * FROM CLIENTE ' +
    'WHERE ID = :ID';

  Result.ParamByName('ID').AsInteger := mId;

  Result.Open;
end;

function TClienteDAO.ListarTodos: TFDQuery;
begin
  Result := TFDQuery.Create(nil);

  Result.Connection := TConexao.GetConnection;

  Result.SQL.Text :=
    'SELECT * FROM CLIENTE ' +
    'ORDER BY NOME';

  Result.Open;
end;

end.
