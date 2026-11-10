object FrmDecl_Imp: TFrmDecl_Imp
  Left = 428
  Top = 303
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Declara'#231#227'o de Importa'#231#227'o'
  ClientHeight = 84
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LblAgua: TLabel
    Left = 109
    Top = 16
    Width = 60
    Height = 16
    Caption = 'Aguarde...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object LblStat: TLabel
    Left = 45
    Top = 62
    Width = 39
    Height = 13
    Caption = 'Status...'
  end
  object Progress: TGauge
    Left = 45
    Top = 33
    Width = 185
    Height = 26
    ForeColor = clGradientActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Progress = 0
  end
  object Db: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\import.mdb;Persi' +
      'st Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
  end
  object QrDecl_Import: TADOQuery
    Connection = Db
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from declara'#231#227'o_importa'#231#227'o')
    Left = 32
    object QrDecl_ImportNR_DECL_IMP_MICRO: TWideStringField
      FieldName = 'NR_DECL_IMP_MICRO'
      Size = 8
    end
    object QrDecl_ImportNR_IDENT_USUARIO: TWideStringField
      FieldName = 'NR_IDENT_USUARIO'
      Size = 15
    end
    object QrDecl_ImportNR_DECL_IMP_PROT: TWideStringField
      FieldName = 'NR_DECL_IMP_PROT'
      Size = 10
    end
    object QrDecl_ImportNR_DECLARACAO_IMP: TWideStringField
      FieldName = 'NR_DECLARACAO_IMP'
      Size = 10
    end
    object QrDecl_ImportDT_PROCESSAMENTO: TWideStringField
      FieldName = 'DT_PROCESSAMENTO'
      Size = 8
    end
    object QrDecl_ImportDT_TRANSMISSAO: TWideStringField
      FieldName = 'DT_TRANSMISSAO'
      Size = 8
    end
    object QrDecl_ImportDT_REGISTRO_DI: TWideStringField
      FieldName = 'DT_REGISTRO_DI'
      Size = 8
    end
    object QrDecl_ImportCD_TIPO_DECLARACAO: TWideStringField
      FieldName = 'CD_TIPO_DECLARACAO'
      Size = 2
    end
    object QrDecl_ImportCD_MOTIVO_TRANS: TWideStringField
      FieldName = 'CD_MOTIVO_TRANS'
      Size = 1
    end
    object QrDecl_ImportCD_TIPO_IMPORTADOR: TWideStringField
      FieldName = 'CD_TIPO_IMPORTADOR'
      Size = 1
    end
    object QrDecl_ImportNR_IMPORTADOR: TWideStringField
      FieldName = 'NR_IMPORTADOR'
      Size = 14
    end
    object QrDecl_ImportCD_PAIS_IMPORTADOR: TWideStringField
      FieldName = 'CD_PAIS_IMPORTADOR'
      Size = 3
    end
    object QrDecl_ImportNM_IMPORTADOR: TWideStringField
      FieldName = 'NM_IMPORTADOR'
      Size = 60
    end
    object QrDecl_ImportNR_TEL_IMPORTADOR: TWideStringField
      FieldName = 'NR_TEL_IMPORTADOR'
      Size = 15
    end
    object QrDecl_ImportED_LOGR_IMPORTADOR: TWideStringField
      FieldName = 'ED_LOGR_IMPORTADOR'
      Size = 40
    end
    object QrDecl_ImportED_NR_IMPORTADOR: TWideStringField
      FieldName = 'ED_NR_IMPORTADOR'
      Size = 6
    end
    object QrDecl_ImportED_COMPL_IMPO: TWideStringField
      FieldName = 'ED_COMPL_IMPO'
      Size = 21
    end
    object QrDecl_ImportED_BA_IMPORTADOR: TWideStringField
      FieldName = 'ED_BA_IMPORTADOR'
      Size = 25
    end
    object QrDecl_ImportED_MUN_IMPORTADOR: TWideStringField
      FieldName = 'ED_MUN_IMPORTADOR'
      Size = 25
    end
    object QrDecl_ImportED_UF_IMPORTADOR: TWideStringField
      FieldName = 'ED_UF_IMPORTADOR'
      Size = 2
    end
    object QrDecl_ImportED_CEP_IMPORTADOR: TWideStringField
      FieldName = 'ED_CEP_IMPORTADOR'
      Size = 8
    end
    object QrDecl_ImportNR_CPF_REPR_LEGAL: TWideStringField
      FieldName = 'NR_CPF_REPR_LEGAL'
      Size = 11
    end
    object QrDecl_ImportCD_MODALIDADE_DESP: TWideStringField
      FieldName = 'CD_MODALIDADE_DESP'
      Size = 1
    end
    object QrDecl_ImportIN_OPERACAO_FUNDAP: TBooleanField
      FieldName = 'IN_OPERACAO_FUNDAP'
    end
    object QrDecl_ImportCD_URF_ENTR_CARGA: TWideStringField
      FieldName = 'CD_URF_ENTR_CARGA'
      Size = 7
    end
    object QrDecl_ImportCD_URF_DESPACHO: TWideStringField
      FieldName = 'CD_URF_DESPACHO'
      Size = 7
    end
    object QrDecl_ImportCD_TIPO_CONSIG: TWideStringField
      FieldName = 'CD_TIPO_CONSIG'
      Size = 1
    end
    object QrDecl_ImportNR_CONSIGNATARIO: TWideStringField
      FieldName = 'NR_CONSIGNATARIO'
      Size = 14
    end
    object QrDecl_ImportNM_CONSIGNATARIO: TWideStringField
      FieldName = 'NM_CONSIGNATARIO'
      Size = 60
    end
    object QrDecl_ImportCD_PAIS_PROC_CARGA: TWideStringField
      FieldName = 'CD_PAIS_PROC_CARGA'
      Size = 3
    end
    object QrDecl_ImportCD_VIA_TRANSP_CARG: TWideStringField
      FieldName = 'CD_VIA_TRANSP_CARG'
      Size = 2
    end
    object QrDecl_ImportIN_MULTIMODAL: TBooleanField
      FieldName = 'IN_MULTIMODAL'
    end
    object QrDecl_ImportNR_VEICULO_TRANSP: TWideStringField
      FieldName = 'NR_VEICULO_TRANSP'
      Size = 15
    end
    object QrDecl_ImportNM_VEICULO_TRANSP: TWideStringField
      FieldName = 'NM_VEICULO_TRANSP'
      Size = 30
    end
    object QrDecl_ImportNM_TRANSPORTADOR: TWideStringField
      FieldName = 'NM_TRANSPORTADOR'
      Size = 60
    end
    object QrDecl_ImportCD_BANDEIRA_TRANSP: TWideStringField
      FieldName = 'CD_BANDEIRA_TRANSP'
      Size = 3
    end
    object QrDecl_ImportCD_TIPO_AG_CARGA: TWideStringField
      FieldName = 'CD_TIPO_AG_CARGA'
      Size = 1
    end
    object QrDecl_ImportNR_AGENTE_CARGA: TWideStringField
      FieldName = 'NR_AGENTE_CARGA'
      Size = 14
    end
    object QrDecl_ImportCD_TIPO_DCTO_CARGA: TWideStringField
      FieldName = 'CD_TIPO_DCTO_CARGA'
      Size = 2
    end
    object QrDecl_ImportNR_DCTO_CARGA: TWideStringField
      FieldName = 'NR_DCTO_CARGA'
      Size = 18
    end
    object QrDecl_ImportNR_DCTO_CARGA_MAST: TWideStringField
      FieldName = 'NR_DCTO_CARGA_MAST'
      Size = 18
    end
    object QrDecl_ImportNM_LOCAL_EMBARQUE: TWideStringField
      FieldName = 'NM_LOCAL_EMBARQUE'
      Size = 50
    end
    object QrDecl_ImportDT_EMBARQUE: TWideStringField
      FieldName = 'DT_EMBARQUE'
      Size = 8
    end
    object QrDecl_ImportCD_UTIL_DCTO_CARGA: TWideStringField
      FieldName = 'CD_UTIL_DCTO_CARGA'
      Size = 1
    end
    object QrDecl_ImportPB_CARGA: TWideStringField
      FieldName = 'PB_CARGA'
      Size = 15
    end
    object QrDecl_ImportPL_CARGA: TWideStringField
      FieldName = 'PL_CARGA'
      Size = 15
    end
    object QrDecl_ImportDT_CHEGADA_CARGA: TWideStringField
      FieldName = 'DT_CHEGADA_CARGA'
      Size = 8
    end
    object QrDecl_ImportCD_TIPO_MANIFESTO: TWideStringField
      FieldName = 'CD_TIPO_MANIFESTO'
      Size = 1
    end
    object QrDecl_ImportNR_MANIFESTO: TWideStringField
      FieldName = 'NR_MANIFESTO'
      Size = 15
    end
    object QrDecl_ImportCD_RECINTO_ALFAND: TWideStringField
      FieldName = 'CD_RECINTO_ALFAND'
      Size = 7
    end
    object QrDecl_ImportCD_SETOR_ARMAZENAM: TWideStringField
      FieldName = 'CD_SETOR_ARMAZENAM'
      Size = 3
    end
    object QrDecl_ImportCD_MOEDA_FRETE: TWideStringField
      FieldName = 'CD_MOEDA_FRETE'
      Size = 3
    end
    object QrDecl_ImportVL_TOT_FRT_PREPAID: TFloatField
      FieldName = 'VL_TOT_FRT_PREPAID'
    end
    object QrDecl_ImportVL_TOT_FRT_COLLECT: TFloatField
      FieldName = 'VL_TOT_FRT_COLLECT'
    end
    object QrDecl_ImportVL_FRETE_TNAC_MNEG: TFloatField
      FieldName = 'VL_FRETE_TNAC_MNEG'
    end
    object QrDecl_ImportVL_TOTAL_FRETE_MN: TFloatField
      FieldName = 'VL_TOTAL_FRETE_MN'
    end
    object QrDecl_ImportCD_MOEDA_SEGURO: TWideStringField
      FieldName = 'CD_MOEDA_SEGURO'
      Size = 3
    end
    object QrDecl_ImportVL_TOT_SEGURO_MNEG: TFloatField
      FieldName = 'VL_TOT_SEGURO_MNEG'
    end
    object QrDecl_ImportVL_TOTAL_SEG_MN: TFloatField
      FieldName = 'VL_TOTAL_SEG_MN'
    end
    object QrDecl_ImportCD_MOEDA_DESPESAS: TWideStringField
      FieldName = 'CD_MOEDA_DESPESAS'
      Size = 3
    end
    object QrDecl_ImportVL_TOT_DESPS_MNEG: TFloatField
      FieldName = 'VL_TOT_DESPS_MNEG'
    end
    object QrDecl_ImportVL_TOT_DESPS_MN: TFloatField
      FieldName = 'VL_TOT_DESPS_MN'
    end
    object QrDecl_ImportCD_MOEDA_MLE: TWideStringField
      FieldName = 'CD_MOEDA_MLE'
      Size = 3
    end
    object QrDecl_ImportVL_TOT_MLE_MNEG: TFloatField
      FieldName = 'VL_TOT_MLE_MNEG'
    end
    object QrDecl_ImportVL_TOTAL_MLE_MN: TFloatField
      FieldName = 'VL_TOTAL_MLE_MN'
    end
    object QrDecl_ImportIN_MOEDA_UNICA: TBooleanField
      FieldName = 'IN_MOEDA_UNICA'
    end
    object QrDecl_ImportTX_INFO_COMPL: TMemoField
      FieldName = 'TX_INFO_COMPL'
      BlobType = ftMemo
    end
    object QrDecl_ImportCD_TIPO_PGTO_TRIB: TWideStringField
      FieldName = 'CD_TIPO_PGTO_TRIB'
      Size = 1
    end
    object QrDecl_ImportNR_CONTA_PGTO_TRIB: TWideStringField
      FieldName = 'NR_CONTA_PGTO_TRIB'
      Size = 19
    end
  end
  object QrAdicao: TADOQuery
    Connection = Db
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from OP_ADI'#199#195'O_DE_IMPORTA'#199#195'O')
    Left = 64
    object QrAdicaoNR_DECL_IMP_MICRO: TWideStringField
      FieldName = 'NR_DECL_IMP_MICRO'
      Size = 8
    end
    object QrAdicaoNR_OP_IMP_MICRO: TWideStringField
      FieldName = 'NR_OP_IMP_MICRO'
      Size = 3
    end
    object QrAdicaoCD_URF_ENTR_MERC: TWideStringField
      FieldName = 'CD_URF_ENTR_MERC'
      Size = 7
    end
    object QrAdicaoCD_VIA_TRANSPORTE: TWideStringField
      FieldName = 'CD_VIA_TRANSPORTE'
      Size = 2
    end
    object QrAdicaoIN_MULTIMODAL: TBooleanField
      FieldName = 'IN_MULTIMODAL'
    end
    object QrAdicaoNM_FORN_ESTR: TWideStringField
      FieldName = 'NM_FORN_ESTR'
      Size = 60
    end
    object QrAdicaoED_LOGR_FORN_ESTR: TWideStringField
      FieldName = 'ED_LOGR_FORN_ESTR'
      Size = 40
    end
    object QrAdicaoED_NR_FORN_ESTR: TWideStringField
      FieldName = 'ED_NR_FORN_ESTR'
      Size = 6
    end
    object QrAdicaoED_COMPL_FORN_ESTR: TWideStringField
      FieldName = 'ED_COMPL_FORN_ESTR'
      Size = 21
    end
    object QrAdicaoED_CIDAD_FORN_ESTR: TWideStringField
      FieldName = 'ED_CIDAD_FORN_ESTR'
      Size = 25
    end
    object QrAdicaoED_ESTAD_FORN_ESTR: TWideStringField
      FieldName = 'ED_ESTAD_FORN_ESTR'
      Size = 25
    end
    object QrAdicaoCD_PAIS_AQUIS_MERC: TWideStringField
      FieldName = 'CD_PAIS_AQUIS_MERC'
      Size = 3
    end
    object QrAdicaoCD_MERCADORIA_NCM: TWideStringField
      FieldName = 'CD_MERCADORIA_NCM'
      Size = 8
    end
    object QrAdicaoCD_PAIS_PROC_MERC: TWideStringField
      FieldName = 'CD_PAIS_PROC_MERC'
      Size = 3
    end
    object QrAdicaoCD_AUSENCIA_FABRIC: TWideStringField
      FieldName = 'CD_AUSENCIA_FABRIC'
      Size = 1
    end
    object QrAdicaoNM_FABRICANTE_MERC: TWideStringField
      FieldName = 'NM_FABRICANTE_MERC'
      Size = 60
    end
    object QrAdicaoED_LOGR_FABRIC: TWideStringField
      FieldName = 'ED_LOGR_FABRIC'
      Size = 40
    end
    object QrAdicaoED_NR_FABRIC: TWideStringField
      FieldName = 'ED_NR_FABRIC'
      Size = 6
    end
    object QrAdicaoED_COMPL_FABRIC: TWideStringField
      FieldName = 'ED_COMPL_FABRIC'
      Size = 21
    end
    object QrAdicaoED_CIDAD_FABRIC: TWideStringField
      FieldName = 'ED_CIDAD_FABRIC'
      Size = 25
    end
    object QrAdicaoED_ESTADO_FABRIC: TWideStringField
      FieldName = 'ED_ESTADO_FABRIC'
      Size = 25
    end
    object QrAdicaoCD_PAIS_ORIG_MERC: TWideStringField
      FieldName = 'CD_PAIS_ORIG_MERC'
      Size = 3
    end
    object QrAdicaoCD_MERC_NBM_SH: TWideStringField
      FieldName = 'CD_MERC_NBM_SH'
      Size = 10
    end
    object QrAdicaoCD_MERC_NALADI_NCC: TWideStringField
      FieldName = 'CD_MERC_NALADI_NCC'
      Size = 7
    end
    object QrAdicaoCD_MERC_NALADI_SH: TWideStringField
      FieldName = 'CD_MERC_NALADI_SH'
      Size = 8
    end
    object QrAdicaoPL_MERCADORIA: TWideStringField
      FieldName = 'PL_MERCADORIA'
      Size = 15
    end
    object QrAdicaoQT_UN_ESTATISTICA: TWideStringField
      FieldName = 'QT_UN_ESTATISTICA'
      Size = 14
    end
    object QrAdicaoCD_APLICACAO_MERC: TWideStringField
      FieldName = 'CD_APLICACAO_MERC'
      Size = 1
    end
    object QrAdicaoVL_MERC_EMB_MN: TFloatField
      FieldName = 'VL_MERC_EMB_MN'
    end
    object QrAdicaoCD_MOEDA_NEGOCIADA: TWideStringField
      FieldName = 'CD_MOEDA_NEGOCIADA'
      Size = 3
    end
    object QrAdicaoCD_INCOTERMS_VENDA: TWideStringField
      FieldName = 'CD_INCOTERMS_VENDA'
      Size = 3
    end
    object QrAdicaoNM_LOC_COND_VENDA: TWideStringField
      FieldName = 'NM_LOC_COND_VENDA'
      Size = 60
    end
    object QrAdicaoVL_MERC_COND_VENDA: TFloatField
      FieldName = 'VL_MERC_COND_VENDA'
    end
    object QrAdicaoVL_MERC_VENDA_MN: TFloatField
      FieldName = 'VL_MERC_VENDA_MN'
    end
    object QrAdicaoVL_FRETE_MERC_MNEG: TFloatField
      FieldName = 'VL_FRETE_MERC_MNEG'
    end
    object QrAdicaoCD_MD_FRETE_MERC: TWideStringField
      FieldName = 'CD_MD_FRETE_MERC'
      Size = 3
    end
    object QrAdicaoVL_FRETE_MERC_MN: TFloatField
      FieldName = 'VL_FRETE_MERC_MN'
    end
    object QrAdicaoVL_SEG_MERC_MNEG: TFloatField
      FieldName = 'VL_SEG_MERC_MNEG'
    end
    object QrAdicaoCD_MOEDA_SEG_MERC: TWideStringField
      FieldName = 'CD_MOEDA_SEG_MERC'
      Size = 3
    end
    object QrAdicaoVL_SEG_MERC_MN: TFloatField
      FieldName = 'VL_SEG_MERC_MN'
    end
    object QrAdicaoVL_UNID_LOC_EMP: TFloatField
      FieldName = 'VL_UNID_LOC_EMP'
    end
    object QrAdicaoCD_METOD_VALORACAO: TWideStringField
      FieldName = 'CD_METOD_VALORACAO'
      Size = 2
    end
    object QrAdicaoCD_VINC_IMPO_EXPO: TWideStringField
      FieldName = 'CD_VINC_IMPO_EXPO'
      Size = 1
    end
    object QrAdicaoCD_TIPO_ACORDO_TAR: TWideStringField
      FieldName = 'CD_TIPO_ACORDO_TAR'
      Size = 1
    end
    object QrAdicaoCD_ACORDO_ALADI: TWideStringField
      FieldName = 'CD_ACORDO_ALADI'
      Size = 3
    end
    object QrAdicaoCD_REGIME_TRIBUTAR: TWideStringField
      FieldName = 'CD_REGIME_TRIBUTAR'
      Size = 1
    end
    object QrAdicaoCD_FUND_LEG_REGIME: TWideStringField
      FieldName = 'CD_FUND_LEG_REGIME'
      Size = 2
    end
    object QrAdicaoCD_MOTIVO_ADM_TEMP: TWideStringField
      FieldName = 'CD_MOTIVO_ADM_TEMP'
      Size = 2
    end
    object QrAdicaoNR_DCTO_REDUCAO: TWideStringField
      FieldName = 'NR_DCTO_REDUCAO'
      Size = 8
    end
    object QrAdicaoVL_DESPESAS_MNEG: TFloatField
      FieldName = 'VL_DESPESAS_MNEG'
    end
    object QrAdicaoCD_MOEDAS_DESPESAS: TWideStringField
      FieldName = 'CD_MOEDAS_DESPESAS'
      Size = 3
    end
    object QrAdicaoVL_DESPESAS_MN: TFloatField
      FieldName = 'VL_DESPESAS_MN'
    end
    object QrAdicaoPC_COEF_REDUC_II: TFloatField
      FieldName = 'PC_COEF_REDUC_II'
    end
    object QrAdicaoVL_CALC_DCR_DOLAR: TFloatField
      FieldName = 'VL_CALC_DCR_DOLAR'
    end
    object QrAdicaoVL_II_CALC_DCR_MN: TFloatField
      FieldName = 'VL_II_CALC_DCR_MN'
    end
    object QrAdicaoVL_II_DEVIDO_ZFM: TFloatField
      FieldName = 'VL_II_DEVIDO_ZFM'
    end
    object QrAdicaoVL_II_A_REC_ZFM: TFloatField
      FieldName = 'VL_II_A_REC_ZFM'
    end
    object QrAdicaoCD_COBERT_CAMBIAL: TWideStringField
      FieldName = 'CD_COBERT_CAMBIAL'
      Size = 1
    end
    object QrAdicaoCD_MODALIDADE_PGTO: TWideStringField
      FieldName = 'CD_MODALIDADE_PGTO'
      Size = 2
    end
    object QrAdicaoCD_ORGAO_FIN_INTER: TWideStringField
      FieldName = 'CD_ORGAO_FIN_INTER'
      Size = 2
    end
    object QrAdicaoCD_MOTIVO_SEM_COB: TWideStringField
      FieldName = 'CD_MOTIVO_SEM_COB'
      Size = 2
    end
    object QrAdicaoQT_PARC_FINANC_360: TWideStringField
      FieldName = 'QT_PARC_FINANC_360'
      Size = 3
    end
    object QrAdicaoCD_PERIOD_PGTO_360: TWideStringField
      FieldName = 'CD_PERIOD_PGTO_360'
      Size = 1
    end
    object QrAdicaoQT_PERIOD_PGTO_360: TWideStringField
      FieldName = 'QT_PERIOD_PGTO_360'
      Size = 3
    end
    object QrAdicaoVL_TOT_FINANC_360: TFloatField
      FieldName = 'VL_TOT_FINANC_360'
    end
    object QrAdicaoPC_TAXA_JUROS: TFloatField
      FieldName = 'PC_TAXA_JUROS'
    end
    object QrAdicaoCD_TAXA_JUROS: TWideStringField
      FieldName = 'CD_TAXA_JUROS'
      Size = 4
    end
    object QrAdicaoVL_FINANC_SUP_360: TFloatField
      FieldName = 'VL_FINANC_SUP_360'
    end
    object QrAdicaoNR_ROF: TWideStringField
      FieldName = 'NR_ROF'
      Size = 8
    end
    object QrAdicaoIN_PGTO_VARIAV_360: TBooleanField
      FieldName = 'IN_PGTO_VARIAV_360'
    end
    object QrAdicaoIN_JUROS_ATE_360: TBooleanField
      FieldName = 'IN_JUROS_ATE_360'
    end
    object QrAdicaoPC_COMISSAO_AG_IMP: TFloatField
      FieldName = 'PC_COMISSAO_AG_IMP'
    end
    object QrAdicaoVL_COMISSAO_AG_IMP: TFloatField
      FieldName = 'VL_COMISSAO_AG_IMP'
    end
    object QrAdicaoCD_TIPO_AGENTE_IMP: TWideStringField
      FieldName = 'CD_TIPO_AGENTE_IMP'
      Size = 1
    end
    object QrAdicaoNR_AGENTE_IMP: TWideStringField
      FieldName = 'NR_AGENTE_IMP'
      Size = 14
    end
    object QrAdicaoCD_BANC_AGENTE_IMP: TWideStringField
      FieldName = 'CD_BANC_AGENTE_IMP'
      Size = 5
    end
    object QrAdicaoCD_AGENC_AGENT_IMP: TWideStringField
      FieldName = 'CD_AGENC_AGENT_IMP'
      Size = 4
    end
    object QrAdicaoIN_BEM_ENCOMENDA: TBooleanField
      FieldName = 'IN_BEM_ENCOMENDA'
    end
    object QrAdicaoIN_MATERIAL_USADO: TBooleanField
      FieldName = 'IN_MATERIAL_USADO'
    end
    object QrAdicaoTX_COMPL_VL_ADUAN: TWideStringField
      FieldName = 'TX_COMPL_VL_ADUAN'
      Size = 250
    end
    object QrAdicaoIN_IPI_NAO_TRIBUT: TBooleanField
      FieldName = 'IN_IPI_NAO_TRIBUT'
    end
    object QrAdicaovl_merc_loc_emb_mn: TFloatField
      FieldName = 'vl_merc_loc_emb_mn'
    end
    object QrAdicaovl_base_calculo_mn: TFloatField
      FieldName = 'vl_base_calculo_mn'
    end
    object QrAdicaoNR_OPER_TRAT_PREV: TWideStringField
      FieldName = 'NR_OPER_TRAT_PREV'
      Size = 10
    end
  end
  object QrParcelas: TADOQuery
    Connection = Db
    Parameters = <>
    SQL.Strings = (
      'Select * from Pagamento_Previsto')
    Left = 184
    object QrParcelasNR_DECL_IMP_MICRO: TWideStringField
      FieldName = 'NR_DECL_IMP_MICRO'
      Size = 8
    end
    object QrParcelasNR_OP_IMP_MICRO: TWideStringField
      FieldName = 'NR_OP_IMP_MICRO'
      Size = 3
    end
    object QrParcelasNU_SEQ_PAG_PREV: TWordField
      FieldName = 'NU_SEQ_PAG_PREV'
    end
    object QrParcelasDT_PREV_PGTO_360: TWideStringField
      FieldName = 'DT_PREV_PGTO_360'
      Size = 6
    end
    object QrParcelasVL_PREV_PGTO_360: TFloatField
      FieldName = 'VL_PREV_PGTO_360'
    end
  end
  object QrTributos: TADOQuery
    Connection = Db
    Parameters = <>
    SQL.Strings = (
      'Select * from Tributo')
    Left = 216
    object QrTributosNR_DECL_IMP_MICRO: TWideStringField
      FieldName = 'NR_DECL_IMP_MICRO'
      Size = 8
    end
    object QrTributosNR_OP_IMP_MICRO: TWideStringField
      FieldName = 'NR_OP_IMP_MICRO'
      Size = 3
    end
    object QrTributosCD_RECEITA_IMPOSTO: TWideStringField
      FieldName = 'CD_RECEITA_IMPOSTO'
      Size = 4
    end
    object QrTributosCD_TIPO_ALIQ_IPT: TWideStringField
      FieldName = 'CD_TIPO_ALIQ_IPT'
      Size = 1
    end
    object QrTributosVL_BASE_CALC_ADVAL: TFloatField
      FieldName = 'VL_BASE_CALC_ADVAL'
    end
    object QrTributosPC_ALIQ_NORM_ADVAL: TFloatField
      FieldName = 'PC_ALIQ_NORM_ADVAL'
    end
    object QrTributosVL_CALC_IPT_ADVAL: TFloatField
      FieldName = 'VL_CALC_IPT_ADVAL'
    end
    object QrTributosNM_UN_ALIQ_ESP_IPT: TWideStringField
      FieldName = 'NM_UN_ALIQ_ESP_IPT'
      Size = 15
    end
    object QrTributosCD_TIPO_RECIPIENTE: TWideStringField
      FieldName = 'CD_TIPO_RECIPIENTE'
      Size = 2
    end
    object QrTributosQT_ML_RECIPIENTE: TFloatField
      FieldName = 'QT_ML_RECIPIENTE'
    end
    object QrTributosQT_MERC_UN_ALIQ_ES: TFloatField
      FieldName = 'QT_MERC_UN_ALIQ_ES'
    end
    object QrTributosVL_ALIQ_ESPEC_IPT: TFloatField
      FieldName = 'VL_ALIQ_ESPEC_IPT'
    end
    object QrTributosVL_CALC_IPT_ESPEC: TFloatField
      FieldName = 'VL_CALC_IPT_ESPEC'
    end
    object QrTributosCD_TIPO_BENEF_IPI: TWideStringField
      FieldName = 'CD_TIPO_BENEF_IPI'
      Size = 1
    end
    object QrTributosPC_ALIQ_REDUZIDA: TFloatField
      FieldName = 'PC_ALIQ_REDUZIDA'
    end
    object QrTributosPC_REDUCAO_IPT_BLI: TFloatField
      FieldName = 'PC_REDUCAO_IPT_BLI'
    end
    object QrTributosPC_ALIQ_ACOR_TARIF: TFloatField
      FieldName = 'PC_ALIQ_ACOR_TARIF'
    end
    object QrTributosVL_CALC_II_AC_TARI: TFloatField
      FieldName = 'VL_CALC_II_AC_TARI'
    end
    object QrTributosVL_IMPOSTO_DEVIDO: TFloatField
      FieldName = 'VL_IMPOSTO_DEVIDO'
    end
    object QrTributosVL_IPT_A_RECOLHER: TFloatField
      FieldName = 'VL_IPT_A_RECOLHER'
    end
    object QrTributosCD_TIPO_DIREITO: TWideStringField
      FieldName = 'CD_TIPO_DIREITO'
      Size = 1
    end
    object QrTributosNR_NOTA_COMPL_TIPI: TWideStringField
      FieldName = 'NR_NOTA_COMPL_TIPI'
      Size = 2
    end
  end
  object QrDetMercad: TADOQuery
    Connection = Db
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Detalhe_Mercadoria')
    Left = 248
    object QrDetMercadNR_DECL_IMP_MICRO: TWideStringField
      FieldName = 'NR_DECL_IMP_MICRO'
      Size = 8
    end
    object QrDetMercadNR_OP_IMP_MICRO: TWideStringField
      FieldName = 'NR_OP_IMP_MICRO'
      Size = 3
    end
    object QrDetMercadNU_SEQ_DETALHE: TWordField
      FieldName = 'NU_SEQ_DETALHE'
    end
    object QrDetMercadTX_DESC_DET_MERC: TMemoField
      FieldName = 'TX_DESC_DET_MERC'
      BlobType = ftMemo
    end
    object QrDetMercadQT_MERC_UN_COMERC: TWideStringField
      FieldName = 'QT_MERC_UN_COMERC'
      Size = 14
    end
    object QrDetMercadNM_UN_MEDID_COMERC: TWideStringField
      FieldName = 'NM_UN_MEDID_COMERC'
    end
    object QrDetMercadVL_UNID_LOC_EMB: TFloatField
      FieldName = 'VL_UNID_LOC_EMB'
    end
    object QrDetMercadVL_UNID_COND_VENDA: TWideStringField
      FieldName = 'VL_UNID_COND_VENDA'
    end
    object QrDetMercadCD_PRODUTO: TWideStringField
      FieldName = 'CD_PRODUTO'
      Size = 15
    end
  end
end
