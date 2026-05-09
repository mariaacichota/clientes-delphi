unit RelatorioDAO;

interface

uses
  FireDAC.Comp.Client;

type
  TRelatorioDAO = class
  public
    function GerarSQLRelatorio(mIdInicial, mIdFinal: Integer;
                               mCidades, mUFs: String; mTodos: Boolean): String;
  end;

implementation

uses
  System.SysUtils,
  uConexao;

function TRelatorioDAO.GerarSQLRelatorio(mIdInicial, mIdFinal: Integer;
  mCidades, mUFs: String; mTodos: Boolean): String;
begin
  Result :=
    'SELECT ' +
    '  C.ID, ' +
    '  C.NOME, ' +
    '  C.CPF_CNPJ, ' +
    '  TRIM( ' +
    '    COALESCE(C.ENDERECO, '''') || ' +

    '    IIF(C.NUMERO IS NOT NULL AND C.NUMERO <> '''', ' +
    '      '', '' || C.NUMERO, ' +
    '      '''' ' +
    '    ) || ' +

    '    IIF(C.BAIRRO IS NOT NULL AND C.BAIRRO <> '''', ' +
    '      '' - '' || C.BAIRRO, ' +
    '      '''' ' +
    '    ) ' +
    '  ) AS ENDERECO_COMPLETO, ' +
    '  CID.NOME AS CIDADE, ' +
    '  EST.UF ' +
    'FROM CLIENTE C ' +
    '  LEFT JOIN CIDADE CID ON CID.ID = C.CIDADE ' +
    '  LEFT JOIN ESTADO EST ON EST.ID = CID.ESTADOID ' +
    'WHERE 1=1 ';

  if not mTodos then
  begin
    if mIdInicial > 0 then
      Result := Result + 'AND C.ID >= ' + IntToStr(mIdInicial) + ' ';

    if mIdFinal > 0 then
      Result := Result + 'AND C.ID <= ' + IntToStr(mIdFinal) + ' ';

    if Trim(mUFs) <> '' then
      Result := Result + 'AND EST.UF IN (' + mUFs + ') ';

    if Trim(mCidades) <> '' then
      Result := Result + 'AND CID.NOME IN (' + mCidades + ') ';
  end;

  Result := Result + 'ORDER BY C.NOME';
end;

end.
