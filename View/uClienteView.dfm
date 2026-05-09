object frmCliente: TfrmCliente
  Left = 0
  Top = 0
  Caption = 'frmCliente'
  ClientHeight = 550
  ClientWidth = 1098
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlGeral: TPanel
    Left = 0
    Top = 0
    Width = 1098
    Height = 480
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 16
    ExplicitHeight = 550
    object lblName: TLabel
      Left = 24
      Top = 27
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object lblCPFCNPJ: TLabel
      Left = 678
      Top = 27
      Width = 53
      Height = 15
      Caption = 'CPF/CNPJ'
    end
    object lblEndereco: TLabel
      Left = 24
      Top = 99
      Width = 49
      Height = 15
      Caption = 'Endere'#231'o'
    end
    object lblNumero: TLabel
      Left = 583
      Top = 99
      Width = 44
      Height = 15
      Caption = 'N'#250'mero'
    end
    object lblCEP: TLabel
      Left = 24
      Top = 163
      Width = 21
      Height = 15
      Caption = 'CEP'
    end
    object lblBairro: TLabel
      Left = 223
      Top = 163
      Width = 31
      Height = 15
      Caption = 'Bairro'
    end
    object lblCidade: TLabel
      Left = 502
      Top = 163
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object lblUF: TLabel
      Left = 781
      Top = 163
      Width = 14
      Height = 15
      Caption = 'UF'
    end
    object lblDataNascimento: TLabel
      Left = 511
      Top = 27
      Width = 107
      Height = 15
      Caption = 'Data de Nascimento'
    end
    object edtNome: TEdit
      Left = 24
      Top = 48
      Width = 465
      Height = 23
      TabOrder = 0
    end
    object edtEndereco: TEdit
      Left = 24
      Top = 120
      Width = 537
      Height = 23
      TabOrder = 1
    end
    object edtCEP: TEdit
      Left = 24
      Top = 184
      Width = 177
      Height = 23
      TabOrder = 2
      OnExit = edtCEPExit
    end
    object edtCPFCNPJ: TEdit
      Left = 678
      Top = 48
      Width = 217
      Height = 23
      TabOrder = 3
      OnExit = edtCPFCNPJExit
    end
    object edtNumero: TEdit
      Left = 583
      Top = 120
      Width = 81
      Height = 23
      TabOrder = 4
    end
    object cbCidade: TComboBox
      Left = 502
      Top = 184
      Width = 257
      Height = 23
      TabOrder = 5
    end
    object cbUF: TComboBox
      Left = 781
      Top = 184
      Width = 114
      Height = 23
      TabOrder = 6
    end
    object edtBairro: TEdit
      Left = 223
      Top = 184
      Width = 257
      Height = 23
      TabOrder = 7
    end
    object ckSemNumero: TCheckBox
      Left = 670
      Top = 123
      Width = 97
      Height = 17
      Caption = 'S/N'
      TabOrder = 8
    end
    object edtDataNascimento: TDateTimePicker
      Left = 511
      Top = 48
      Width = 145
      Height = 23
      Date = 46151.000000000000000000
      Time = 0.144554016202164300
      TabOrder = 9
    end
    object btnBuscar: TButton
      Left = 912
      Top = 47
      Width = 129
      Height = 25
      Caption = 'Buscar'
      TabOrder = 10
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 480
    Width = 1098
    Height = 70
    Align = alBottom
    ShowCaption = False
    TabOrder = 1
    object btnSalvar: TButton
      Left = 24
      Top = 24
      Width = 129
      Height = 25
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 176
      Top = 24
      Width = 129
      Height = 25
      Caption = 'Excluir'
      TabOrder = 1
      OnClick = btnExcluirClick
    end
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 544
    Top = 280
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 464
    Top = 280
  end
  object RESTResponse1: TRESTResponse
    Left = 368
    Top = 280
  end
end
