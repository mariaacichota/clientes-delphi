unit uRelatorioView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ppDB, ppDBPipe, ppComm, ppRelatv, ppProd, ppClass,
  ppReport, ppVar, ppCtrls, ppPrnabl, ppBands, ppCache, ppDesignLayer,
  ppParameter;

type
  TfrmRelatorio = class(TForm)
    pnlGeral: TPanel;
    edtIdInicial: TEdit;
    edtIdFinal: TEdit;
    ckTodos: TCheckBox;
    pnlFooter: TPanel;
    btnGerar: TButton;
    btnFechar: TButton;
    lblIdInicial: TLabel;
    lblIdFinal: TLabel;
    lblCidade: TLabel;
    lblUF: TLabel;
    ckcbCidade: TCheckListBox;
    ckcbUF: TCheckListBox;
    ppReport1: TppReport;
    ppDBPipeline1: TppDBPipeline;
    dsRelatorio: TDataSource;
    qryRelatorio: TFDQuery;
    ppParameterList1: TppParameterList;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLabel7: TppLabel;
    ppLabel1: TppLabel;
    ppLine1: TppLine;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppDBText1: TppDBText;
    ppDBText6: TppDBText;
    ppDBText5: TppDBText;
    ppDBText4: TppDBText;
    ppDBText3: TppDBText;
    ppDBText2: TppDBText;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    procedure btnGerarClick(Sender: TObject);
    procedure ckcbUFClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    procedure CarregarUFs;
    procedure CarregarCidades(mUF: String);
    function ItensMarcados(mCheck: TCheckListBox): String;
  public
    { Public declarations }
  end;

var
  frmRelatorio: TfrmRelatorio;

implementation

uses
  uEstadoDAO, uCidadeDAO, RelatorioDAO, uConexao;

{$R *.dfm}

procedure TfrmRelatorio.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRelatorio.btnGerarClick(Sender: TObject);
var
  DAO: TRelatorioDAO;
begin
  DAO := TRelatorioDAO.Create;

  try
    qryRelatorio.Close;

    qryRelatorio.SQL.Text :=
      DAO.GerarSQLRelatorio(
        StrToIntDef(edtIdInicial.Text, 0),
        StrToIntDef(edtIdFinal.Text, 0),
        ItensMarcados(ckcbCidade),
        ItensMarcados(ckcbUF),
        ckTodos.Checked
      );

    qryRelatorio.Open;
    ppReport1.Print;

  finally
    DAO.Free;
  end;
end;

procedure TfrmRelatorio.CarregarCidades(mUF: String);
var
  DAO: TCidadeDAO;
  Qry: TFDQuery;
begin
  DAO := TCidadeDAO.Create;
  try
    Qry := DAO.ListarPorEstado(mUF);
    try
      if ckcbUF.SelCount = 1 then
        ckcbCidade.Items.Clear;

      while not Qry.Eof do
        begin
          ckcbCidade.Items.AddObject(
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

procedure TfrmRelatorio.CarregarUFs;
var
  DAO: TEstadoDAO;
  Qry: TFDQuery;
begin
  DAO := TEstadoDAO.Create;

  try
    Qry := DAO.ListarEstados;
    try
      ckcbUF.Items.Clear;

      while not Qry.Eof do
        begin
          ckcbUF.Items.Add(Qry.FieldByName('UF').AsString);
          Qry.Next;
        end;

    finally
      Qry.Free;
    end;

  finally
    DAO.Free;
  end;
end;

procedure TfrmRelatorio.ckcbUFClickCheck(Sender: TObject);
var
  DAO: TCidadeDAO;
  Qry: TFDQuery;
  I: Integer;
begin
  if ckcbUF.SelCount = 1 then
    ckcbCidade.Items.Clear;

  DAO := TCidadeDAO.Create;
  try
    for I := 0 to ckcbUF.Count - 1 do
    begin
      if ckcbUF.Checked[I] then
      begin
        Qry := DAO.ListarPorEstado(ckcbUF.Items[I]);
        try
          while not Qry.Eof do
            begin
              if ckcbCidade.Items.IndexOf(Qry.FieldByName('NOME').AsString) = -1 then
                ckcbCidade.Items.Add(Qry.FieldByName('NOME').AsString);
              
              Qry.Next;
            end;

        finally
          Qry.Free;
        end;
      end;
    end;

  finally
    DAO.Free;
  end;
end;

procedure TfrmRelatorio.FormCreate(Sender: TObject);
begin
  qryRelatorio.Connection := TConexao.GetConnection;
  CarregarUFs;
end;

function TfrmRelatorio.ItensMarcados(mCheck: TCheckListBox): String;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to mCheck.Count - 1 do
  begin
    if mCheck.Checked[I] then
    begin
      if Result <> '' then
        Result := Result + ',';

      Result :=
        Result +
        QuotedStr(
          mCheck.Items[I]
        );
    end;
  end;
end;

end.
