# clientes-delphi
Projeto Delphi 12 Community Edition que demonstra o CRUD da tabela de clientes para criação de relatórios e manipulação de dados dentro do Firebird 3.0.

# Boas Práticas Implementadas

O projeto também utiliza recursos importantes para garantir:

- qualidade do código;
- controle de memória;
- estabilidade da aplicação;
- integridade das transações no banco de dados.

_Pontos importantes que garantem a integridade e qualidade do código implementado são os reports de memory leak (perda de memória) e o rollback de transações mal-sucedidas no banco de dados._

# Estrutura do projeto 

``bash 
CartSysClientes/
│
├── Projeto/
│   └── CartSysClientes.dpr
│
├── Model/
│   ├── uClienteModel.pas
│   ├── uCidadeModel.pas
│   └── uEstadoModel.pas
│
├── Controller/
│   └── uClienteController.pas
│
├── View/
│   ├── uPrincipal.pas
│   ├── uPrincipal.dfm
│   ├── uClienteView.pas
│   ├── uClienteView.dfm
│   ├── uRelatorioView.pas
│   └── uRelatorioView.dfm
│
├── DAO/
│   ├── uConexao.pas
│   └── uClienteDAO.pas
│
└── SQL/
    └── banco.sql
``

# Tecnologias Utilizadas

- Delphi 12.0
- Firebird 3.0
- FireDAC
- MVC
- FastReport

# Instruções para Executar o Projeto Localmente

Necessário o download do Delphi (no projeto foi usada a versão 12.0) e Firebird (utilizada a versão 3.0).

## Criação do Banco de Dados

1. Dentro do Firebird ISQL Tool, execute o comando ``isql -user SYSDBA -password root`` (o usuário e a senha são definidos durante a instalação do Firebird);
2. Depois, execute as tabelas que serão utilizadas:

`` 
CREATE DATABASE 'C:\Firebird\CartSysClientes.fdb'
USER 'SYSDBA'
PASSWORD 'root';

CREATE TABLE ESTADO (
    ID INTEGER NOT NULL,
    NOME VARCHAR(50),
    UF CHAR(2),
    CONSTRAINT PK_ESTADO PRIMARY KEY (ID)
);

CREATE TABLE CIDADE (
    ID INTEGER NOT NULL,
    NOME VARCHAR(50),
    ESTADOID INTEGER,
    CONSTRAINT PK_CIDADE PRIMARY KEY (ID),
    CONSTRAINT FK_CIDADE_ESTADO
        FOREIGN KEY (ESTADOID)
        REFERENCES ESTADO(ID)
);

CREATE TABLE CLIENTE (
    ID INTEGER NOT NULL,
    NOME VARCHAR(80),
    CEP CHAR(8),
    CPF_CNPJ VARCHAR(14),
    ENDERECO VARCHAR(100),
    NUMERO VARCHAR(20),
    COMPLEMENTO VARCHAR(60),
    BAIRRO VARCHAR(100),
    CIDADE INTEGER,
    DATANASCIMENTO DATE,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (ID),
    CONSTRAINT FK_CLIENTE_CIDADE
        FOREIGN KEY (CIDADE)
        REFERENCES CIDADE(ID)
);

COMMIT;
``

4. Dentro do seu arquivo de conexão, informe o caminho do banco de dados. Nesse caso, o arquivo é o ``DAO/uConexao.pas``, a linha a ser inserida é algo como ``Result.Params.Values['Database'] := 'C:\Firebird\CartSysClientes.fdb';``;
5. Gere o executável do projeto para que esse possa ser acessado de outra forma, além de dentro da IDE.
_O formulário e configurações do relatório serão feitas conforme as exigências do projeto._
