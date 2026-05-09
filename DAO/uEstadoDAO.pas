unit uEstadoDAO;

interface

uses
  FireDAC.Comp.Client;

type
  TEstadoDAO = class
  public
    function ListarEstados: TFDQuery;
  end;

implementation

uses
  uConexao;

function TEstadoDAO.ListarEstados: TFDQuery;
begin
  Result := TFDQuery.Create(nil);

  Result.Connection := TConexao.GetConnection;

  Result.SQL.Text :=
    'SELECT ID, UF, NOME ' +
    'FROM ESTADO ' +
    'ORDER BY UF';

  Result.Open;
end;

end.
