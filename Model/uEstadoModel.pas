unit uEstadoModel;

interface

type
  TEstado = class
  private
    FID: Integer;
    FNome: String;
    FUF: String;

  public
    property ID:   Integer   read FID   write FID;
    property Nome: String    read FNome write FNome;
    property UF:   String    read FUF   write FUF;
  end;

implementation

end.
