object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 466
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mnPrincipal
  WindowState = wsMaximized
  TextHeight = 15
  object mnPrincipal: TMainMenu
    Left = 300
    Top = 186
    object mnSistema: TMenuItem
      Caption = 'Sistema'
      object subSair: TMenuItem
        Caption = 'Sair'
        OnClick = subSairClick
      end
    end
    object mnCadastros: TMenuItem
      Caption = 'Cadastros'
      object subCliente: TMenuItem
        Caption = 'Cliente'
        OnClick = subClienteClick
      end
    end
    object mnRelatorios: TMenuItem
      Caption = 'Relat'#243'rios'
      object subRelatorio: TMenuItem
        Caption = 'Relat'#243'rio'
        OnClick = subRelatorioClick
      end
    end
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 304
    Top = 248
  end
end
