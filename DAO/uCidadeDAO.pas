unit uCidadeDAO;

interface

uses
  FireDAC.Comp.Client;

type
  TCidadeDAO = class
  public
    function ListarPorEstado(AUF: String): TFDQuery;

    function BuscarCidade(
      ANome,
      AUF: String
    ): Integer;

    function InserirCidade(
      ANome,
      AUF: String
    ): Integer;
  end;

implementation

uses
  System.SysUtils,
  uConexao;

function TCidadeDAO.ListarPorEstado(
  AUF: String
): TFDQuery;
begin
  Result := TFDQuery.Create(nil);

  Result.Connection := TConexao.GetConnection;

  Result.SQL.Text :=
    'SELECT C.ID, C.NOME ' +
    'FROM CIDADE C ' +
    'INNER JOIN ESTADO E ON E.ID = C.ESTADOID ' +
    'WHERE E.UF = :UF ' +
    'ORDER BY C.NOME';

  Result.ParamByName('UF').AsString := AUF;

  Result.Open;
end;

function TCidadeDAO.BuscarCidade(
  ANome,
  AUF: String
): Integer;
var
  Qry: TFDQuery;
begin
  Result := 0;

  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := TConexao.GetConnection;

    Qry.SQL.Text :=
      'SELECT C.ID ' +
      'FROM CIDADE C ' +
      'INNER JOIN ESTADO E ON E.ID = C.ESTADOID ' +
      'WHERE UPPER(C.NOME)=UPPER(:NOME) ' +
      'AND E.UF = :UF';

    Qry.ParamByName('NOME').AsString := ANome;
    Qry.ParamByName('UF').AsString := AUF;

    Qry.Open;

    if not Qry.IsEmpty then
      Result := Qry.FieldByName('ID').AsInteger;

  finally
    Qry.Free;
  end;
end;

function TCidadeDAO.InserirCidade(
  ANome,
  AUF: String
): Integer;
var
  Qry: TFDQuery;
  EstadoID: Integer;
begin
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := TConexao.GetConnection;

    Qry.SQL.Text :=
      'SELECT ID FROM ESTADO ' +
      'WHERE UF = :UF';

    Qry.ParamByName('UF').AsString := AUF;

    Qry.Open;

    if Qry.IsEmpty then
      raise Exception.Create(
        'UF não encontrada.'
      );

    EstadoID :=
      Qry.FieldByName('ID').AsInteger;

    Qry.Close;

    Result :=
      TConexao.GetNextID(
        'GEN_CIDADE_ID'
      );

    Qry.SQL.Text :=
      'INSERT INTO CIDADE (' +
      'ID, NOME, ESTADOID' +
      ') VALUES (' +
      ':ID, :NOME, :ESTADOID' +
      ')';

    Qry.ParamByName('ID').AsInteger := Result;
    Qry.ParamByName('NOME').AsString := ANome;
    Qry.ParamByName('ESTADOID').AsInteger := EstadoID;

    Qry.ExecSQL;

  finally
    Qry.Free;
  end;
end;

end.
