unit uClienteModel;

interface

type
  TCliente = class
  private
    FID: Integer;
    FNome: String;
    FCEP: String;
    FCPFCNPJ: String;
    FEndereco: String;
    FNumero: String;
    FComplemento: String;
    FBairro: String;
    FCidade: Integer;
    FDataNascimento: TDate;

  public

    property ID:             Integer read FID             write FID;
    property Nome:           String  read FNome           write FNome;
    property CEP:            String  read FCEP            write FCEP;
    property CPFCNPJ:        String  read FCPFCNPJ        write FCPFCNPJ;
    property Endereco:       String  read FEndereco       write FEndereco;
    property Numero:         String  read FNumero         write FNumero;
    property Complemento:    String  read FComplemento    write FComplemento;
    property Bairro:         String  read FBairro         write FBairro;
    property Cidade:         Integer read FCidade         write FCidade;
    property DataNascimento: TDate   read FDataNascimento write FDataNascimento;
  end;

implementation

end.
