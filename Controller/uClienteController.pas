unit uClienteController;

interface

uses
  System.SysUtils,
  System.JSON,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Types,
  FireDAC.Comp.Client,
  uClienteDAO;

type
  TEnderecoDTO = record
    CEP: String;
    Logradouro: String;
    Bairro: String;
    Cidade: String;
    UF: String;
  end;

type
  TClienteController = class
  public
    function BuscarCEP(const mCEP: String; out mEndereco: TEnderecoDTO): Boolean;
    function ValidarCPFCNPJ(const mDocumento: String): Boolean;
    function ClienteExiste(mCPFCNPJ: String; out mQry: TFDQuery): Boolean;
    function ApenasNumeros(const mTexto: String): String;
  private
    function ValidarCNPJAPI(const mCNPJ: String): Boolean;
    function ValidarCPF(const mCPF: String): Boolean;
  end;

implementation

{ TClienteController }

function TClienteController.ApenasNumeros(const mTexto: String): String;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(mTexto) do
    begin
      if mTexto[I] in ['0'..'9'] then
        Result := Result + mTexto[I];
    end;
end;

function TClienteController.BuscarCEP(const mCEP: String; out mEndereco: TEnderecoDTO): Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSON: TJSONObject;
  CEP: String;
begin
  Result := False;

  CEP := ApenasNumeros(mCEP);
  if Length(CEP) <> 8 then
    Exit;

  RESTClient := TRESTClient.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);

  try
    RESTClient.BaseURL :=
      'https://viacep.com.br/ws/' +
      CEP +
      '/json/';

    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    RESTRequest.Method := rmGET;

    RESTRequest.Execute;

    JSON := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
    try
      if Assigned(JSON) then
        begin
          if JSON.GetValue('erro') <> nil then
            Exit;

          mEndereco.CEP := JSON.GetValue<String>('cep');
          mEndereco.Logradouro := JSON.GetValue<String>('logradouro');
          mEndereco.Bairro := JSON.GetValue<String>('bairro');
          mEndereco.Cidade := JSON.GetValue<String>('localidade');
          mEndereco.UF := JSON.GetValue<String>('uf');

          Result := True;
        end;

    finally
      JSON.Free;
    end;

  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TClienteController.ValidarCNPJAPI(const mCNPJ: String): Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSON: TJSONObject;
  CNPJ: String;
begin
  Result := False;

  CNPJ := ApenasNumeros(mCNPJ);
  if Length(CNPJ) <> 14 then
    Exit;

  RESTClient := TRESTClient.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);

  try
    RESTClient.BaseURL :=
      'https://brasilapi.com.br/api/cnpj/v1/' +
      CNPJ;

    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    RESTRequest.Method := rmGET;

    try
      RESTRequest.Execute;

      if RESTResponse.StatusCode = 200 then
        begin
          JSON := TJSONObject.ParseJSONValue(
            RESTResponse.Content
          ) as TJSONObject;

          try
            Result := Assigned(JSON);
          finally
            JSON.Free;
          end;
        end
      else
        Result := False;

    except
      Result := False;
    end;

  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TClienteController.ValidarCPF(const mCPF: String): Boolean;
var
  Soma: Integer;
  Resto: Integer;
  I: Integer;
  Dig1: Integer;
  Dig2: Integer;
begin
  Result := False;

  if Length(mCPF) <> 11 then
    Exit;

  if mCPF = StringOfChar(mCPF[1], 11) then
    Exit;

  Soma := 0;

  for I := 1 to 9 do
    Soma := Soma +
      StrToInt(mCPF[I]) * (11 - I);

  Resto := (Soma * 10) mod 11;

  if Resto = 10 then
    Resto := 0;

  Dig1 := Resto;

  Soma := 0;

  for I := 1 to 10 do
    Soma := Soma +
      StrToInt(mCPF[I]) * (12 - I);

  Resto := (Soma * 10) mod 11;

  if Resto = 10 then
    Resto := 0;

  Dig2 := Resto;

  Result :=
    (Dig1 = StrToInt(mCPF[10])) and
    (Dig2 = StrToInt(mCPF[11]));
end;

function TClienteController.ValidarCPFCNPJ(const mDocumento: String): Boolean;
var
  Doc: String;
begin
  Doc := ApenasNumeros(mDocumento);

  if Length(Doc) = 11 then
    Result := ValidarCPF(Doc)
  else if Length(Doc) = 14 then
    Result := ValidarCNPJAPI(Doc)
  else
    Result := False;
end;

function TClienteController.ClienteExiste(mCPFCNPJ: String; out mQry: TFDQuery): Boolean;
var
  DAO: TClienteDAO;
begin
  DAO := TClienteDAO.Create;

  try
    mQry := DAO.BuscarPorCPFCNPJ(ApenasNumeros(mCPFCNPJ));
    Result := not mQry.IsEmpty;

  finally
    DAO.Free;
  end;
end;

end.
