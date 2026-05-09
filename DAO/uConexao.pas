unit uConexao;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.DApt,
  FireDAC.Stan.Factory;

type
  TConexao = class
  private
    class var FConnection: TFDConnection;

  public
    class function GetConnection: TFDConnection;
    class function GetNextID(ASequence: String): Integer;
    class procedure Conectar;
    class procedure Desconectar;
  end;

implementation

uses
  Vcl.Dialogs;

class procedure TConexao.Conectar;
begin
  if Assigned(FConnection) then
    Exit;

  FConnection := TFDConnection.Create(nil);

  try
    FConnection.Params.Clear;

    FConnection.Params.DriverID := 'FB';

    FConnection.Params.Add(
      'Database=D:\Repository\clientes-delphi\sql\CartSysClientes.fdb'
    );

    FConnection.Params.Add('User_Name=SYSDBA');
    FConnection.Params.Add('Password=root');

    FConnection.Params.Add('Server=localhost');
    FConnection.Params.Add('Protocol=TCPIP');
    FConnection.Params.Add('Port=3050');

    FConnection.LoginPrompt := False;

    FConnection.Connected := True;

  except
    on E: Exception do
    begin
      FreeAndNil(FConnection);

      raise Exception.Create(
        'Erro ao conectar no banco de dados: ' +
        E.Message
      );
    end;
  end;
end;

class procedure TConexao.Desconectar;
begin
  if Assigned(FConnection) then
  begin
    if FConnection.Connected then
      FConnection.Connected := False;

    FreeAndNil(FConnection);
  end;
end;

class function TConexao.GetConnection: TFDConnection;
begin
  if not Assigned(FConnection) then
    Conectar;

  Result := FConnection;
end;

class function TConexao.GetNextID(ASequence: String): Integer;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := GetConnection;

    Qry.SQL.Text :=
      'SELECT NEXT VALUE FOR ' +
      ASequence +
      ' AS ID FROM RDB$DATABASE';

    Qry.Open;

    Result := Qry.FieldByName('ID').AsInteger;

  finally
    Qry.Free;
  end;
end;

initialization

finalization
  TConexao.Desconectar;

end.
