unit uCidadeModel;

interface

uses
  uEstadoModel;

type
  TCidade = class
  private
    FID: Integer;
    FNome: String;
    FEstadoID: Integer;

  public
    property ID:       Integer read FID       write FID;
    property Nome:     String  read FNome     write FNome;
    property EstadoID: Integer read FEstadoID write FEstadoID;
  end;

implementation

end.
