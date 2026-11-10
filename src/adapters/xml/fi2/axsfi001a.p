
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSFI001A 2.00.00.013 } /*** 010013 ***/

/* TEMP-TABLE DEFINITION - BEGIN */

/* A defini‡Æo das temp-tables abaixo foram copiadas do programa
** AXSFI001.P o qual foram geradas pelo WizardAdapter.
*/

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    .


DEFINE TEMP-TABLE ttContactClassInformation NO-UNDO
     FIELD ContactClassCode AS CHARACTER INITIAL ?  /*Codigo da Classe ( campo =  emsuni.contat_clas.cod_clas_contat)*/
     FIELD ContactClassDescription AS CHARACTER INITIAL ?  /*Descricao da Classe ( campo = emsuni.clas_contat.des_clas_contat)*/
     FIELD ttContactClassInformationID AS INTEGER INITIAL ?
     FIELD ttCustomerVendorContactIn_00ID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttContactLanguageInformation NO-UNDO
     FIELD ContactLanguageCode AS CHARACTER INITIAL ?  /*Idioma ( campo = emsuni.idiom_contat.cod_idioma)*/
     FIELD ContactMainLanguage AS LOGICAL INITIAL ?  /*Idioma Principal ( campo = emsuni.idiom_contat.log_idiom_princ)*/
     FIELD ttContactLanguageInformationID AS INTEGER INITIAL ?
     FIELD ttCustomerVendorContactIn_00ID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttCorporateActivityInform_00 NO-UNDO
     FIELD CorporateActivityCode AS CHARACTER INITIAL ?  /*Codigo da Atividade ( campo = emsuni.pessoa_jurid_ativ.cod_ativid_pessoa_jurid)*/
     FIELD CorporateActivityDescription AS CHARACTER INITIAL ?  /*Descricao da Atividade ( campo = emsuni.ativid_pessoa_jurid.des_ativid_pessoa_jurid)*/
     FIELD MainCorporateActivity AS LOGICAL INITIAL ?  /*Atividade Principal ( campo = emsuni.pessoa_jurid_ativ.log_ativid_pessoa_princ)*/
     FIELD ttCorporateActivityInform_00ID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecificaPJID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttCorporateMarketActivity_00 NO-UNDO
     FIELD CorporateMarketActivityCode AS CHARACTER INITIAL ?  /*Codigo do Ramo de Negocio ( campo = emsuni.pessoa_jurid_ramo_negoc.cod_ramo_negoc)*/
     FIELD CorporateMarketActivityDescri_00 AS CHARACTER INITIAL ?  /*Descricao do Ramo de Negocio ( campo = emsuni.ramo_negoc.des_ramo_negoc)*/
     FIELD MainCorporateMarketActivity AS LOGICAL INITIAL ?  /*Ramo de Negocio Principal ( campo = emsuni.pessoa_jurid_ramo_negoc.log_ramo_negoc_princ)*/
     FIELD ttCorporateMarketActivity_00ID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecificaPJID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttCorporateShipToAddressI_00 NO-UNDO
     FIELD Address AS CHARACTER INITIAL ?  /*Endere‡o ( campo = endereco ou nom_endereco )*/
     FIELD Address2 AS CHARACTER INITIAL ?  /*Bairro ( campo = bairro ou nom_bairro)*/
     FIELD AddressSuplement AS CHARACTER INITIAL ?  /*Complemento ( campo = nom_ender_compl )*/
     FIELD City AS CHARACTER INITIAL ?  /*Cidade ( campo = cidade ou nom_cidade)*/
     FIELD CorporateFullShipToAddress AS CHARACTER INITIAL ?  /*Endere‡o Completo de Entrega ( campo = emsuni.ender_entreg.nom_ender_entreg_text)*/
     FIELD CorporateShipToAddressCode AS CHARACTER INITIAL ?  /*C¢digo do Endere‡o de Entrega ( campo = emsuni.ender_entreg.cod_ender_entreg)*/
     FIELD Country AS CHARACTER INITIAL ?  /*Pais ( campo = pais ou cod_pais)*/
     FIELD County AS CHARACTER INITIAL ?  /*Condado ( campo = nom_condado)*/
     FIELD POBox AS CHARACTER INITIAL ?  /*Caixa Postal ( campo = caixa-postal ou cod_cx_post)*/
     FIELD State AS CHARACTER INITIAL ?  /*Estado ( campo = estado ou cod_unid_federac)*/
     FIELD ttCorporateShipToAddressI_00ID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecificaPJID AS INTEGER INITIAL ?
     FIELD Zip AS CHARACTER INITIAL ?  /*CEP ( campo = cep ou cod_cep)*/
     FIELD ZipCode AS CHARACTER INITIAL ?  /*ZipCode ( campo = zip-code)*/
.


DEFINE TEMP-TABLE ttCorporateSizeInformation NO-UNDO
     FIELD CorporateSizeDate AS date INITIAL ?  /*Data do Porte ( campo = emsuni.porte_pessoa_jurid.dat_porte_pessoa_jurid)*/
     FIELD CorporateSizeSales AS decimal INITIAL ?  /*Valor das Vendas ( campo = emsuni.porte_pessoa_jurid.val_vendas)*/
     FIELD CurrencyCode AS CHARACTER INITIAL ?  /*Moeda ( campo = emsuni.porte_pessoa_jurid.cod_indic_econ)*/
     FIELD EmployeeSales AS decimal INITIAL ?  /*Vendas por Funcionario ( campo = emsuni.porte_pessoa_jurid.val_vendas_func)*/
     FIELD GeneralIndebtedness AS decimal INITIAL ?  /*Endividamento Geral ( campo = emsuni.porte_pessoa_jurid.val_endivto_geral)*/
     FIELD LongIndebtedness AS decimal INITIAL ?  /*Endividamento Longo Prazo ( campo = emsuni.porte_pessoa_jurid.val_endivto_longo_praz)*/
     FIELD NetAssets AS decimal INITIAL ?  /*Patrimonio Liquido ( campo = emsuni.porte_pessoa_jurid.val_patrim_liq)*/
     FIELD NetProfit AS decimal INITIAL ?  /*Lucro Liquido ( campo = emsuni.porte_pessoa_jurid.val_lucro_liq)*/
     FIELD NumberOfEmployess AS integer INITIAL ?  /*Numero de Funcionarios ( campo = emsuni.porte_pessoa_jurid.qtd_funcionario)*/
     FIELD OwnWorkingCapital AS decimal INITIAL ?  /*Capital de Giro Proprio ( campo = emsuni.porte_pessoa_jurid.val_capit_giro_proprio)*/
     FIELD SortKey AS CHARACTER INITIAL ?  /*Classificacao Pessoa Juridica ( campo = emsuni.porte_pessoa_jurid.cod_classif_pessoa_jurid)*/
     FIELD TableNotes AS CHARACTER INITIAL ?  /*Anotacoes ( campo = emsuni.porte_pessoa_jurid.des_anot_tab)*/
     FIELD ttCorporateSizeInformationID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecificaPJID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttCustomerHistoryInformation NO-UNDO
     FIELD History AS CHARACTER INITIAL ?  /*Historico (campo = emsuni.histor_clien.des_histor_clien)*/
     FIELD HistoryDataShort AS CHARACTER INITIAL ?  /*Descricao Abreviada do Historico (campo = emsuni.histor_clien.des_abrev_histor_clien)*/
     FIELD HistorySequence AS integer INITIAL ?  /*Sequencia (campo = emsuni.histor_clien.num_seq_histor_clien)*/
     FIELD ttCustomerHistoryInformationID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecifClienteID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttCustomerVendorContactIn_00 NO-UNDO
     FIELD Address AS CHARACTER INITIAL ?  /*Endere‡o ( campo = endereco ou nom_endereco )*/
     FIELD Address2 AS CHARACTER INITIAL ?  /*Bairro ( campo = bairro ou nom_bairro)*/
     FIELD AddressSuplement AS CHARACTER INITIAL ?  /*Complemento ( campo = nom_ender_compl )*/
     FIELD City AS CHARACTER INITIAL ?  /*Cidade ( campo = cidade ou nom_cidade)*/
     FIELD Comment AS CHARACTER INITIAL ?  /*Observacao ( campo = mgadm.cont-emit.observacao )*/
     FIELD ContactArea AS CHARACTER INITIAL ?  /*Area ou Departamento ( campo = mgadm.cont-emit.area)*/
     FIELD ContactCode AS integer INITIAL ?  /*C¢digo do Contato ( campo = emsuni.contato.num_pessoa_fisic)*/
     FIELD ContactEMail AS CHARACTER INITIAL ?  /*E-mail ( campo = emsuni.contato.cod_e_mail_contat)*/
     FIELD ContactFaxExtention AS CHARACTER INITIAL ?  /*Ramal do Fax ( campo = mgadm.cont-emit.ramal-fax ou emsuni.contato.cod_ramal_fax_contat)*/
     FIELD ContactFaxNumber AS CHARACTER INITIAL ?  /*Numero do Fax ( campo = mgadm.cont-emit.telefax ou emsuni.contato.cod_fax_contat)*/
     FIELD ContactModemExtention AS CHARACTER INITIAL ?  /*Ramal do Modem ( campo = emsuni.contato.cod_ramal_modem_contat)*/
     FIELD ContactModemNumber AS CHARACTER INITIAL ?  /*Numero do Modem ( campo = emsuni.contato.cod_modem_contat )*/
     FIELD ContactName AS CHARACTER INITIAL ?  /*Nome do Contato ( campo = mgadm.cont-emit.nome ou emsuni.contato.nom_pessoa)*/
     FIELD ContactPhone AS CHARACTER INITIAL ?  /*Telefone ( campo = mgadm.cont-emit.telefone ou emsuni.contato.cod_telef_contat)*/
     FIELD ContactPhoneExtention AS CHARACTER INITIAL ?  /*Ramal ( campo = mgadm.cont-emit.ramal ou emsuni.contato.cod_ramal_contat)*/
     FIELD ContactSequence AS integer INITIAL ?  /*Sequencia ( campo = mgadm.cont-emit.sequencia )*/
     FIELD ContactTitle AS CHARACTER INITIAL ?  /*Cargo do Contato ( campo = mgadm.cont-emit.cargo )*/
     FIELD Country AS CHARACTER INITIAL ?  /*Pais ( campo = pais ou cod_pais)*/
     FIELD County AS CHARACTER INITIAL ?  /*Condado ( campo = nom_condado)*/
     FIELD POBox AS CHARACTER INITIAL ?  /*Caixa Postal ( campo = caixa-postal ou cod_cx_post)*/
     FIELD SendPriority AS integer INITIAL ?  /*Prioridade no Envio ( campo = emsuni.contato.ind_priorid_envio   Valores Possiveis = 1- E-mail / Fax    2- Fax / E-mail)*/
     FIELD State AS CHARACTER INITIAL ?  /*Estado ( campo = estado ou cod_unid_federac)*/
     FIELD ttCustomerVendorContactIn_00ID AS INTEGER INITIAL ?
     FIELD Zip AS CHARACTER INITIAL ?  /*CEP ( campo = cep ou cod_cep)*/
     FIELD ZipCode AS CHARACTER INITIAL ?  /*ZipCode ( campo = zip-code)*/
     INDEX ixttCustomerVendorContactIn_00ID IS PRIMARY UNIQUE ttCustomerVendorContactIn_00ID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoBancarias NO-UNDO
     FIELD BankCode AS CHARACTER INITIAL ?  /*Codigo do Banco (cod-banco ou cod_banco)*/
     FIELD BankInstructionCode1 AS CHARACTER INITIAL ?  /*Instrucao Bancaria 1 ( campo = mgadm.emitente.ins-banc[1] ou emsfin.clien_finan.cod_instruc_bcia_1_acr)*/
     FIELD BankInstructionCode2 AS CHARACTER INITIAL ?  /*Instrucao Bancaria 2 ( campo = mgadm.emitente.ins-banc[2] ou emsfin.clien_finan.cod_instruc_bcia_2_acr)*/
     FIELD BankName AS CHARACTER INITIAL ?  /*Nome do Banco (nome-banco ou nom_banco)*/
     FIELD BranchCode AS CHARACTER INITIAL ?  /*Agencia ( campo = mgadm.emitente.agencia ou emsfin.clien_finan.cod_agenc_bcia )*/
     FIELD BranchKey AS CHARACTER INITIAL ?  /*Digito da Agencia ( campo =  emsfin.clien_finan.cod_digito_agenc_bcia )*/
     FIELD CheckingAccountKey AS CHARACTER INITIAL ?  /*Digito Conta Corrente ( campo = emsfin.clien_finan.cod_digito_cta_corren)*/
     FIELD CheckingAccountNumber AS CHARACTER INITIAL ?  /*Conta Corrente ( campo = mgadm.emitente.conta-corren ou emsfin.clien_finan.cod_cta_corren_bco)*/
     FIELD CollectionMessageClassificati_00 AS CHARACTER INITIAL ?  /*Codigo de Classificacao da Mensagem de Cobranca ( campo = emsfin.clien_finan.cod_classif_msg_cobr)*/
     FIELD CollectionMessageClassificati_01 AS CHARACTER INITIAL ?  /*Descricao da Classficacao da Mensagem de Cobranca ( campo = emsfin.classif_msg_cobr.des_classif_msg_cobr)*/
     FIELD ttInformacaoBancariasID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecifClienteID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoBancFornec NO-UNDO
     FIELD BankCode AS CHARACTER INITIAL ?  /*C¢digo do Banco (cod-banco ou cod_banco)*/
     FIELD BankName AS CHARACTER INITIAL ?  /*Nome do Banco (nome-banco ou nom_banco)*/
     FIELD BranchCode AS CHARACTER INITIAL ?  /*Agencia ( campo = mgadm.emitente.agencia ou emsfin.clien_finan.cod_agenc_bcia ou emsfin.fornec_finan.cod_agenc_bcia ou mgadm.cta-emitente.agencia ou emsfin.cta_corren_fornec.cod_agenc_bcia )*/
     FIELD BranchKey AS CHARACTER INITIAL ?  /*Digito da Agencia ( campo = emsfin.clien_finan.cod_digito_agenc_bcia ou emsfin.fornec_finan.cod_digito_agenc_bcia ou emsfin.cta_corren_fornec.digito_agenc_bcia)*/
     FIELD CheckingAccountDescription AS CHARACTER INITIAL ?  /*Descri‡Æo da Conta Corrente ( campo = mgadm.cta-emitente.descricao ou emsfin.cta_corren_fornec.des_cta_corren)*/
     FIELD CheckingAccountKey AS CHARACTER INITIAL ?  /*Digito Conta Corrente ( campo = emsfin.clien_finan.cod_digito_cta_corren ou emsfin.fornec_finan.cod_digito_cta_corren ou emsfin.cta_corren_fornec.cod_digito_cta_corren)*/
     FIELD CheckingAccountNumber AS CHARACTER INITIAL ?  /*Conta Corrente ( campo = mgadm.emitente.conta-corren ou emsfin.clien_finan.cod_cta_corren_bco ou emsfin.fornec_finan.cod_cta_corren_bco ou mgadm.cta-emitente.conta-corrente ou emsfin.cta_corren_fornec.cod_cta_corren_bco)*/
     FIELD CheckingAccountPreferred AS LOGICAL INITIAL ?  /*Conta Corrente Preferencial ( campo = mgadm.cta-emitente.preferencial ou emsfin.cta_corren_fornec.log_cta_corren_prefer)*/
     FIELD ttInformacaoBancFornecID AS INTEGER INITIAL ?
     FIELD ttInformacaoEspecifFornecID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoComunicCliFornec NO-UNDO
     FIELD EDIPartner AS CHARACTER INITIAL ?  /*Codigo do Parceiro cadastrado no EDI para utilizar na integracao com este modulo ( campo = mgadm.emitente.cod-parceiro-edi)*/
     FIELD EMail AS CHARACTER INITIAL ?  /*E-mail ( campo = mgadm.emitente.e-mail ou emsuni.pessoa_jurid.cod_e_mail ou emsuni.pessoa_fisic.cod_e_mail)*/
     FIELD FaxExtention AS CHARACTER INITIAL ?  /*Ramal do Fax ( campo = mgadm.emitente.ramal-fax ou emsuni.pessoa_jurid.cod_ramal_fax ou emsuni.pessoa_fisic.cod_ramal_fax)*/
     FIELD FaxNumber AS CHARACTER INITIAL ?  /*Numero do Fax ( campo = mgadm.emitente.telefax ou emsuni.pessoa_jurid.cod_fax ou emsuni.pessoa_fisic.cod_fax)*/
     FIELD HomePage AS CHARACTER INITIAL ?  /*Home Page ( campo = mgadm.emitente.home-page ou emsuni.pessoa_jurid.nom_home_page ou emsuni.pessoa_fisic.nom_home_page)*/
     FIELD ModemExtention AS CHARACTER INITIAL ?  /*Ramal do Modem ( campo = mgadm.emitente.ramal-modem ou emsuni.pessoa_jurid.cod_ramal_modem ou emsuni.pessoa_fisic.cod_ramal_modem)*/
     FIELD ModemNumber AS CHARACTER INITIAL ?  /*Numero do Modem ( campo = mgadm.emitente.telef-modem ou emsuni.pessoa_jurid.cod_modem ou emsuni.pessoa_fisic.cod_modem)*/
     FIELD PhoneExtention1 AS CHARACTER INITIAL ?  /*Ramal 1 ( campo = mgadm.emitente.ramal[1] ou emsuni.pessoa_jurid.cod_ramal ou emsuni.pessoa_fisic.cod_ramal)*/
     FIELD PhoneExtention2 AS CHARACTER INITIAL ?  /*Ramal 2 ( campo = mgadm.emitente.ramal[2] )*/
     FIELD PhoneNumber1 AS CHARACTER INITIAL ?  /*Telefone 1 ( campo = mgadm.emitente.telefone[1] ou emsuni.pessoa_jurid.cod_telefone ou emsuni.pessoa_fisic.cod_telefone)*/
     FIELD PhoneNumber2 AS CHARACTER INITIAL ?  /*Telefone 2 ( campo = mgadm.emitente.telefone[2] )*/
     FIELD TelexNumber AS CHARACTER INITIAL ?  /*Telex ( campo = emsuni.pessoa_jurid.cod_telex ou emsuni.pessoa_fisic.cod_telex)*/
     FIELD ttInformacaoComunicCliFornecID AS INTEGER INITIAL ?
     INDEX ixttInformacaoComunicCliFornecID IS PRIMARY UNIQUE ttInformacaoComunicCliFornecID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoEndCliFornec NO-UNDO
     FIELD Address AS CHARACTER INITIAL ?  /*Endere‡o ( campo = endereco ou nom_endereco )*/
     FIELD Address2 AS CHARACTER INITIAL ?  /*Bairro ( campo = bairro ou nom_bairro)*/
     FIELD AddressSuplement AS CHARACTER INITIAL ?  /*Complemento ( campo = nom_ender_compl )*/
     FIELD City AS CHARACTER INITIAL ?  /*Cidade ( campo = cidade ou nom_cidade)*/
     FIELD Country AS CHARACTER INITIAL ?  /*Pais ( campo = pais ou cod_pais)*/
     FIELD County AS CHARACTER INITIAL ?  /*Condado ( campo = nom_condado)*/
     FIELD POBox AS CHARACTER INITIAL ?  /*Caixa Postal ( campo = caixa-postal ou cod_cx_post)*/
     FIELD State AS CHARACTER INITIAL ?  /*Estado ( campo = estado ou cod_unid_federac)*/
     FIELD ttInformacaoEndCliFornecID AS INTEGER INITIAL ?
     FIELD Zip AS CHARACTER INITIAL ?  /*CEP ( campo = cep ou cod_cep)*/
     FIELD ZipCode AS CHARACTER INITIAL ?  /*ZipCode ( campo = zip-code)*/
     INDEX ixttInformacaoEndCliFornecID IS PRIMARY UNIQUE ttInformacaoEndCliFornecID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoEndCobr NO-UNDO
     FIELD Address_00 AS CHARACTER INITIAL ?  /*Endere‡o ( campo = endereco ou nom_endereco )*/
     FIELD Address2_00 AS CHARACTER INITIAL ?  /*Bairro ( campo = bairro ou nom_bairro)*/
     FIELD AddressSuplement_00 AS CHARACTER INITIAL ?  /*Complemento ( campo = nom_ender_compl )*/
     FIELD BillToCustomerCode AS integer INITIAL ?  /*C¢digo do Cliente de Cobran‡a ( campo = mgadm.emitente.end-cobranca ou emsuni.pessoa_jurid.num_pessoa_jurid_cobr)*/
     FIELD City_00 AS CHARACTER INITIAL ?  /*Cidade ( campo = cidade ou nom_cidade)*/
     FIELD Country_00 AS CHARACTER INITIAL ?  /*Pais ( campo = pais ou cod_pais)*/
     FIELD County_00 AS CHARACTER INITIAL ?  /*Condado ( campo = nom_condado)*/
     FIELD POBox_00 AS CHARACTER INITIAL ?  /*Caixa Postal ( campo = caixa-postal ou cod_cx_post)*/
     FIELD State_00 AS CHARACTER INITIAL ?  /*Estado ( campo = estado ou cod_unid_federac)*/
     FIELD ttInformacaoEndCobrID AS INTEGER INITIAL ?
     FIELD Zip_00 AS CHARACTER INITIAL ?  /*CEP ( campo = cep ou cod_cep)*/
     FIELD ZipCode_00 AS CHARACTER INITIAL ?  /*ZipCode ( campo = zip-code)*/
     INDEX ixttInformacaoEndCobrID IS PRIMARY UNIQUE ttInformacaoEndCobrID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoEspecifCliente NO-UNDO
     FIELD AutomaticDebit AS LOGICAL INITIAL ?  /*Debito Automatico ( campo = emsfin.clien_finan.log_habilit_db_autom)*/
     FIELD CRServiceRequirement AS LOGICAL INITIAL ?  /*Necessita Acompanhamento do SPC ( campo = emsfin.clien_analis_cr.log_neces_acompto_spc)*/
     FIELD CustomerStatus AS integer INITIAL ?  /*Situacao do Cliente ( campo = emsfin.clien_finan.ind_sit_clien_perda_dedut    Valores Possiveis = 1- Normal  2- Falido   - Concordatario   4- Insolvencia Declarada)*/
     FIELD CustomerType AS CHARACTER INITIAL ?  /*Tipo de Cliente ( campo = emsfin.clien_analis_cr.cod_tip_clien)*/
     FIELD DaysLate AS integer INITIAL ?  /*Dias Atraso para Aviso de Debito ( campo = mgadm.emitente.dias-atraso ou emsfin.clien_finan.num_dias_atraso_avdeb)*/
     FIELD GenerateDebitMemo AS LOGICAL INITIAL ?  /*Gera AD ( campo = mgadm.emitente.gera-ad ou emsfin.clien_finan.log_habilit_gera_avdeb)*/
     FIELD MinimumAmount AS decimal INITIAL ?  /*Valor Minimo para geracao de Aviso de Debito ( campo = mgadm.emitente.valor-minimo ou emsfin.clien_finan.val_min_avdeb)*/
     FIELD PaymentTerms AS CHARACTER INITIAL ?  /*Condicao de Pagamento ( campo = mgadm.emitente.cod-cond-pag)*/
     FIELD PaymentTermsDescription AS CHARACTER INITIAL ?  /*Descricao da Condicao de Pagamento ( campo = mgadm.cond-pagto.descricao)*/
     FIELD PenaltyCalculation AS LOGICAL INITIAL ?  /*Calcula Multa ( campo = mgadm.emitente.calcula-multa ou emsfin.clien_finan.log_calc_multa)*/
     FIELD PublicityAmountPercentage AS decimal INITIAL ?  /*Percentual de Verba de Publicidade ( campo = emsfin.clien_finan.val_perc_verb)*/
     FIELD QuantityOpenDocuments AS integer INITIAL ?  /*Quantidade de Titulos em Aberto ( campo = emsfin.clien_finan.num_tit_acr_aber)*/
     FIELD ReceiveInformation AS LOGICAL INITIAL ?  /*Recebe Informacoes SCI ( campo = mgadm.emitente.recebe-inf-sci)*/
     FIELD RiskClass AS CHARACTER INITIAL ?  /*Classificacao do Risco ( campo = emsfin.clien_analis_cr.cod_clas_risco_clien)*/
     FIELD StandardRevenueCode AS integer INITIAL ?  /*Tipo de Receita Padrao ( campo = mgadm.emitente.tp-rec-padrao )*/
     FIELD StandardRevenueDescription AS CHARACTER INITIAL ?  /*Descricao do Tipo de Receita Padrao ( campo = mgadm.tp-rec-desp.descricao)*/
     FIELD StatementPrint AS LOGICAL INITIAL ?  /*Emite Boleto ( campo = mgadm.emitente.emite-bloq ou emsfin.clien_finan.log_habilit_emis_boleto)*/
     FIELD ttInformacaoEspecifClienteID AS INTEGER INITIAL ?
     FIELD UsePublicityAmount AS LOGICAL INITIAL ?  /*Usa Verba de Publicidade (campo = emsfin.clien_finan.log_utiliz_verb)*/
     FIELD WithholdTax AS LOGICAL INITIAL ?  /*Retem Imposto ( campo = emsfin.clien_finan.log_retenc_impto)*/
     INDEX ixttInformacaoEspecifClienteID IS PRIMARY UNIQUE ttInformacaoEspecifClienteID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoEspecifFornec NO-UNDO
     FIELD ClearanceDays AS integer INITIAL ?  /*Dias Compensacao ( campo = mgadm.emitente.dias-comp ou emsfin.fornec_finan.num_dias_compcao)*/
     FIELD ControlSSMaximumAmount AS LOGICAL INITIAL ?  /*Controla Valor Maximo INSS ( campo = p/ 2.04 entry(1,mgadm.emitente.char-2,chr(10)) ou p/ 2.05 mgadm.log-controla-val-max-inss ou emsfin.fornec_finan.log_control_inss)*/
     FIELD CreditTaxCOFINS AS LOGICAL INITIAL ?  /*Credita COFINS ( campo = p/ 5.04 emsuni.fornecedor.num_livre_1 ou p/ 5.06 emsuni.fornecedor.log_cr_cofins)*/
     FIELD CreditTaxPIS AS LOGICAL INITIAL ?  /*Credita PIS ( campo = p/ 5.04 emsuni.fornecedor.log_livre_1 ou p/ 5.06 emsuni.fornecedor.log_cr_pis)*/
     FIELD DiscountPercentage AS decimal INITIAL ?  /*Percentual de Desconto ( campo = mgadm.emitente.bonificacao ou emsfin.fornec_finan.val_percent_bonif)*/
     FIELD DueEqualFlowDate AS LOGICAL INITIAL ?  /*Vencimento em Dia Nao util (campo = mgadm.emitente.vencto-dia-nao-util ou emsfin.fornec_finan.log_vencto_dia_nao_util)*/
     FIELD DueHoliday AS integer INITIAL ?  /*Vencimento Feriado. Indica qual tratamento dado quando o vencimento cai num feriado. ( campo = mgadm.emitente.ven-feriado ou emsfin.fornec_finan.ind_tratam_vencto_fer     Valores possiveis = 1- Prorroga   2- Antecipa    - Mantem)*/
     FIELD DueSaturday AS integer INITIAL ?  /*Vencimento Sabado. Indica qual tratamento dado quando o vencimento cai num sabado. ( campo = mgadm.emitente.ven-sabado ou emsfin.fornec_finan.ind_tratam_vencto_sab     Valores possiveis = 1- Prorroga   2- Antecipa    - Mantem)*/
     FIELD DueSunday AS integer INITIAL ?  /*Vencimento Domingo. Indica qual tratamento dado quando o vencimento cai num domingo. ( campo = mgadm.emitente.ven-domingo ou emsfin.fornec_finan.ind_tratam_vencto_dom     Valores possiveis = 1- Prorroga   2- Antecipa    - Mantem)*/
     FIELD ExportVendor AS LOGICAL INITIAL ?  /*Fornecedor Exportacao ( campo = emsfin.fornec_finan.log_fornec_serv_export)*/
     FIELD FinancialRate AS decimal INITIAL ?  /*Taxa Financeira ( campo = mgadm.emitente.taxa-financ)*/
     FIELD FinancialRateDays AS integer INITIAL ?  /*Dias Taxa Financeira ( campo = mgadm.emitente.nr-dias-taxa)*/
     FIELD GreatestAmountDocumentAdditio_00 AS date INITIAL ?  /*Data da Maior Implantacao ( campo = emsfin.fornec_finan.dat_impl_maior_tit_ap)*/
     FIELD HoldPayment AS LOGICAL INITIAL ?  /*Pagamento Bloqueado ( campo = emsfin.fornec_finan.log_pagto_bloqdo)*/
     FIELD InsterestPayment AS integer INITIAL ?  /*Pagamento de Juros ( campo = emsfin.fornec_finan.ind_pagto_juros_fornec_ap     valores possiveis = 1- Pago   2- Nao Pago)*/
     FIELD LastAdditionAmount AS decimal INITIAL ?  /*Valor da ultima Implantacao ( campo = emsfin.fornec_finan.val_ult_impl_tit_ap)*/
     FIELD LastAdditionDocumentDate AS date INITIAL ?  /*Data da Ultima Implantacao ( campo = emsfin.fornec_finan.dat_ult_impl_tit_ap)*/
     FIELD LastPaymentDate AS date INITIAL ?  /*Data do Ultimo Pagamento ( campo = emsfin.fornec_finan.dat_ult_pagto)*/
     FIELD OpenDocumentQuantity AS integer INITIAL ?  /*Quantidade de Titulos em Aberto ( campo = emsfin.fornec_finan.num_tit_ap_aber)*/
     FIELD OpenPrepaymentQuantity AS integer INITIAL ?  /*Quantidade de Antecipacoes em Aberto (campo = emsfin.fornec_finan.num_antecip_aber)*/
     FIELD PaymentType AS CHARACTER INITIAL ?  /*Tipo de Pagamento ( campo = mgadm.emitente.tp-pagto   {adinc/i22ad098.i} ou  fornec_finan.cod_forma_pagto)*/
     FIELD PaymentTypeDescription AS CHARACTER INITIAL ?  /*Descricao da Forma de Pagamento ( campo = emsfin.forma_pagto.des_forma_pagto)*/
     FIELD PrintLabel AS LOGICAL INITIAL ?  /*Emite Etiqueta ( campo = mgadm.emitente.emit-etiq)*/
     FIELD PrintPO AS integer INITIAL ?  /*Emissao Pedido ( campo = mgadm.emitente.emissao-ped     Valores possiveis = 1- Formulario   2- Magnetico    - Telex)*/
     FIELD Revenue AS LOGICAL INITIAL ?  /*Rendimento ( campo = mgadm.emitente.ind-rendimen ou emsfin.fornec_finan.log_indic_rendto)*/
     FIELD SSTaxRegistration AS CHARACTER INITIAL ?  /*Inscricao INSS ( campo = p/ 2.04 entry(2,mgadm.emitente.char-2,chr(10)) ou p/ 2.05 mgadm.emitente.cod-inscr-inss ou emsuni.pessoa_jurid.cod_id_previd_social)*/
     FIELD StandardExpenseDescription AS CHARACTER INITIAL ?  /*Descricao do Tipo de Despesa Padrao (campo = mgadm.tp-rec-desp.descricao)*/
     FIELD StandardExpenseType AS integer INITIAL ?  /*Tipo de Despesa Padrao (campo = mgadm.emitente.tp-desp-padrao)*/
     FIELD StorePaymentAmount AS integer INITIAL ?  /*Armazena Valor de Pagamento ( campo = emsfin.fornec_finan.ind_armaz_val_pagto     valores possiveis = 1- Implantacao   2- Pagamento     - Nao Armazena)*/
     FIELD TaxableRevenue AS decimal INITIAL ?  /*Rendimento Tributavel ( campo = mgadm.emitente.rend-tribut ou emsfin.fornec_finan.num_rendto_tribut)*/
     FIELD ttInformacaoEspecifFornecID AS INTEGER INITIAL ?
     FIELD VendorType AS integer INITIAL ?  /*Tipo de Fornecedor ( campo = emsfin.fornec_finan.ind_tip_fornecto    valores possiveis = 1- Produtos   2- Servicos    - Ambos)*/
     FIELD WithholdTax_00 AS LOGICAL INITIAL ?  /*Retém Imposto fornec_financ.log_retem_impto*/
     INDEX ixttInformacaoEspecifFornecID IS PRIMARY UNIQUE ttInformacaoEspecifFornecID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoEspecificaPF NO-UNDO
     FIELD ContryBirth AS CHARACTER INITIAL ?  /*Pais de Nascimento ( campo = emsuni.pessoa_fisic.cod_pais_nasc)*/
     FIELD DateOfBirth AS date INITIAL ?  /*Data de Nascimento ( campo = emsuni.pessoa_fisic.dat_nasc_pessoa_fisic)*/
     FIELD FullAddress AS CHARACTER INITIAL ?  /*Endereco Completo ( campo = emsuni.pessoa_fisic.nom_ender_text)*/
     FIELD MaritalStatus AS integer INITIAL ?  /*Estado Civil ( campo = emsuni.pessoa_fisic.ind_estado_civil_pessoa     valores possiveis = 1-solteiro  2-casado    -separado   4-divorciado    5-viuvo    6-outros)*/
     FIELD MotherName AS CHARACTER INITIAL ?  /*Nome da Mae ( campo = emsuni.pessoa_fisic.des_mae_pessoa)*/
     FIELD Nacionality AS CHARACTER INITIAL ?  /*Nacionalidade ( campo = emsuni.pessoa_fisic.nom_nacion_pessoa_fisic)*/
     FIELD Profession AS CHARACTER INITIAL ?  /*Profissao ( campo = emsuni.pessoa_fisic.nom_profis_pessoa_fisic)*/
     FIELD TableNotes_00 AS CHARACTER INITIAL ?  /*Anotacoes ( campo = emsuni.pessoa_fisic.des_anot_tab)*/
     FIELD ttInformacaoEspecificaPFID AS INTEGER INITIAL ?
     INDEX ixttInformacaoEspecificaPFID IS PRIMARY UNIQUE ttInformacaoEspecificaPFID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoEspecificaPJ NO-UNDO
     FIELD Address_01 AS CHARACTER INITIAL ?  /*Endere‡o ( campo = endereco ou nom_endereco )*/
     FIELD Address2_01 AS CHARACTER INITIAL ?  /*Bairro ( campo = bairro ou nom_bairro)*/
     FIELD AddressSuplement_01 AS CHARACTER INITIAL ?  /*Complemento ( campo = nom_ender_compl )*/
     FIELD CapitalType AS integer INITIAL ?  /*Tipo de Capital ( campo = emsuni.pessoa_jurid.ind_tip_capit_pessoa_jurid      valores possiveis = 1-Domestico   2- Multinacional    3- Municipal    4- Estadual    5- Federal)*/
     FIELD City_01 AS CHARACTER INITIAL ?  /*Cidade ( campo = cidade ou nom_cidade)*/
     FIELD CorporateEntityClassification AS integer INITIAL ?  /*Natureza da pessoa jur¡dica (Campo = pessoa_jurid.ind_nat_pessoa_jurid valores possiveis: 1 -Nacional 2-Estrangeira 3 - Trading)*/
     FIELD CorporateEntityType AS integer INITIAL ?  /*Tipo de Empresa ( campo = emsuni.pessoa_jurid.ind_tip_pessoa_jurid     valores possiveis = 1-Privada  2-Publica   3-Mista)*/
     FIELD Country_01 AS CHARACTER INITIAL ?  /*Pais ( campo = pais ou cod_pais)*/
     FIELD County_01 AS CHARACTER INITIAL ?  /*Condado ( campo = nom_condado)*/
     FIELD PaymentCorporateEntityCode AS integer INITIAL ?  /*Pessoa Jur¡dica para Pagamento ( campo = emsuni.pessoa_jurid.num_pessoa_jurid_pagto)*/
     FIELD POBox_01 AS CHARACTER INITIAL ?  /*Caixa Postal ( campo = caixa-postal ou cod_cx_post)*/
     FIELD Profit AS LOGICAL INITIAL ?  /*Fins Lucrativos ( campo = emsuni.pessoa_jurid.log_fins_lucrat)*/
     FIELD State_01 AS CHARACTER INITIAL ?  /*Estado ( campo = estado ou cod_unid_federac)*/
     FIELD TableNotes AS CHARACTER INITIAL ?  /*Anota‡äes ( campo = emsuni.pessoa_jurid.des_anot_tab)*/
     FIELD ttInformacaoEspecificaPJID AS INTEGER INITIAL ?
     FIELD Zip_01 AS CHARACTER INITIAL ?  /*CEP ( campo = cep ou cod_cep)*/
     FIELD ZipCode_01 AS CHARACTER INITIAL ?  /*ZipCode ( campo = zip-code)*/
     INDEX ixttInformacaoEspecificaPJID IS PRIMARY UNIQUE ttInformacaoEspecificaPJID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoGrupoCliente NO-UNDO
     FIELD CustomerGroupCode AS CHARACTER INITIAL ?  /*Codigo do Grupo ( campo = mgadm.emitente.cod-gr-cli ou emsuni.cliente.cod_grp_clien)*/
     FIELD CustomerGroupDescription AS CHARACTER INITIAL ?  /*Descricao do Grupo ( campo = mgadm.gr-cli.descricao  ou  emsuni.grp_clien.des_grp_clien)*/
     FIELD ttInformacaoGrupoClienteID AS INTEGER INITIAL ?
     INDEX ixttInformacaoGrupoClienteID IS PRIMARY UNIQUE ttInformacaoGrupoClienteID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoGrupoFornec NO-UNDO
     FIELD ttInformacaoGrupoFornecID AS INTEGER INITIAL ?
     FIELD VendorGroupCode AS CHARACTER INITIAL ?  /*Codigo do Grupo ( campo = emsuni.fornecedor.cod_grp_fornec)*/
     FIELD VendorGroupDescription AS CHARACTER INITIAL ?  /*Descricao do Grupo ( campo =emsuni.grp_fornec.des_grp_fornec)*/
     INDEX ixttInformacaoGrupoFornecID IS PRIMARY UNIQUE ttInformacaoGrupoFornecID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoIDICliFornec NO-UNDO
     FIELD Registration AS CHARACTER INITIAL ?  /*ID Municipal ( campo = mgadm.emitente.ins-municipal ou emsuni.pessoa_jurid.cod_id_munic_jurid)*/
     FIELD TaxExemptionIssuedBy AS CHARACTER INITIAL ?  /*Orgao Emissor ID Estadual ( campo = emsuni.pessoa_fisic.cod_orgao_emis_id_estad)*/
     FIELD TaxExemptionIssuedState AS CHARACTER INITIAL ?  /*Estado do Orgao Emissor ( campo = emsuni.pessoa_fisic.cod_unid_federac_estad)*/
     FIELD TaxExemptionNumber AS CHARACTER INITIAL ?  /*ID Estadual ( campo = mgadm.emitente.ins-estadual ou emsuni.pessoa_jurid.cod_id_estad_jurid ou emsuni.pessoa_fisic.id_estadual_fisic)*/
     FIELD TaxID AS CHARACTER INITIAL ?  /*Identificacao Federal ( campo = mgadm.emitente.cgc ou emsuni.cliente.cod_id_feder ou emsuni.fornecedor.cod_id_feder)*/
     FIELD ttInformacaoIDICliFornecID AS INTEGER INITIAL ?
     INDEX ixttInformacaoIDICliFornecID IS PRIMARY UNIQUE ttInformacaoIDICliFornecID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoMatrizCliFornec NO-UNDO
     FIELD CustomerVendorMatrixCode AS integer INITIAL ?  /*Codigo da Matriz ( campo = mgadm.emitente.cod-emit ou emsuni.pessoa_jurid.num_pessoa_jurid_matriz) . Obrigatorio para pessoa juridica no EMS 5*/
     FIELD CustomerVendorMatrixName AS CHARACTER INITIAL ?  /*Nome da Matriz ( campo = mgadm.emitente.nome-emit ou emsuni.pessoa_jurid.nom_pessoa)*/
     FIELD CustomerVendorMatrixShortName AS CHARACTER INITIAL ?  /*Nome Abreviado Matriz ( campo = mgadm.emitente.nome-matriz ou emsuni.pessoa_jurid.nom_abrev_pessoa) Obrigatorio no EMS 2*/
     FIELD ttInformacaoMatrizCliFornecID AS INTEGER INITIAL ?
     INDEX ixttInformacaoMatrizCliFornecID IS PRIMARY UNIQUE ttInformacaoMatrizCliFornecID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoPortador NO-UNDO
     FIELD CollectorCode AS CHARACTER INITIAL ?  /*Codigo do Portador (cod-portador ou cod_portador)*/
     FIELD CollectorDescription AS CHARACTER INITIAL ?  /*Nome do Portador (portador.nome ou portador.nom_pessoa)*/
     FIELD ModalityCode AS CHARACTER INITIAL ?  /*Modadlidade Externa (modalidade ou cod_modalidade_ext)*/
     FIELD PortfolioCode AS CHARACTER INITIAL ?  /*Codigo da Carteira (cod_cart_bcia)*/
     FIELD PortfolioDescription AS CHARACTER INITIAL ?  /*Descricao da Carteira (des_cart_bcia)*/
     FIELD ttInformacaoEspecifClienteID AS INTEGER INITIAL ?
     FIELD ttInformacaoPortadorID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoPortFornec NO-UNDO
     FIELD CollectorCode AS CHARACTER INITIAL ?  /*Codigo do Portador (cod-portador ou cod_portador)*/
     FIELD CollectorDescription AS CHARACTER INITIAL ?  /*Nome do Portador (portador.nome ou portador.nom_pessoa)*/
     FIELD ModalityCode AS CHARACTER INITIAL ?  /*Modadlidade Externa (modalidade ou cod_modalidade_ext)*/
     FIELD PortfolioCode AS CHARACTER INITIAL ?  /*Codigo da Carteira (cod_cart_bcia)*/
     FIELD PortfolioDescription AS CHARACTER INITIAL ?  /*Descricao da Carteira (des_cart_bcia)*/
     FIELD ttInformacaoEspecifFornecID AS INTEGER INITIAL ?
     FIELD ttInformacaoPortFornecID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoPortPreferencial NO-UNDO
     FIELD CollectorCode_00 AS CHARACTER INITIAL ?  /*Codigo do Portador (cod-portador ou cod_portador)*/
     FIELD CollectorDescription_00 AS CHARACTER INITIAL ?  /*Nome do Portador (portador.nome ou portador.nom_pessoa)*/
     FIELD ModalityCode_00 AS CHARACTER INITIAL ?  /*Modadlidade Externa (modalidade ou cod_modalidade_ext)*/
     FIELD PortfolioCode_00 AS CHARACTER INITIAL ?  /*Codigo da Carteira (cod_cart_bcia)*/
     FIELD PortfolioDescription_00 AS CHARACTER INITIAL ?  /*Descricao da Carteira (des_cart_bcia)*/
     FIELD ttInformacaoEspecifClienteID AS INTEGER INITIAL ?
     FIELD ttInformacaoPortPreferencialID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoRepres NO-UNDO
     FIELD RepresentativeCode AS CHARACTER INITIAL ?  /*Codigo do Representante ( campo = mgadm.emitente.cod-rep ou emsfin.clien_finan.cdn_repres)*/
     FIELD RepresentativeName AS CHARACTER INITIAL ?  /*Nome do Representante ( campo = mgadm.repres.nome ou emsuni.representante.nom_pessoa)*/
     FIELD ttInformacaoRepresID AS INTEGER INITIAL ?
     INDEX ixttInformacaoRepresID IS PRIMARY UNIQUE ttInformacaoRepresID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoTipoCliente NO-UNDO
     FIELD CustomerTypeCode AS CHARACTER INITIAL ?  /*Tipo de Emitente ( campo = emsuni.cliente.cod_tip_clien)*/
     FIELD CustomerTypeDescription AS CHARACTER INITIAL ?  /*Descricao do Tipo de Emitente ( campo = emsuni.tip_clien.des_tip_clien)*/
     FIELD ttInformacaoTipoClienteID AS INTEGER INITIAL ?
     INDEX ixttInformacaoTipoClienteID IS PRIMARY UNIQUE ttInformacaoTipoClienteID ASCENDING
.


DEFINE TEMP-TABLE ttInformacaoTipoFluxoFinanc NO-UNDO
     FIELD FinancialFlowTypeCode AS CHARACTER INITIAL ?  /*Codigo do Tipo de Fluxo Financeiro (cod_tip_fluxo_financ)*/
     FIELD FinancialFlowTypeDescription AS CHARACTER INITIAL ?  /*Descricao do Tipo de Fluxo Financeiro (des_tip_fluxo_financ)*/
     FIELD ttInformacaoEspecifClienteID AS INTEGER INITIAL ?
     FIELD ttInformacaoTipoFluxoFinancID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoTipoFluxoFornec NO-UNDO
     FIELD FinancialFlowTypeCode AS CHARACTER INITIAL ?  /*Codigo do Tipo de Fluxo Financeiro (cod_tip_fluxo_financ)*/
     FIELD FinancialFlowTypeDescription AS CHARACTER INITIAL ?  /*Descricao do Tipo de Fluxo Financeiro (des_tip_fluxo_financ)*/
     FIELD ttInformacaoEspecifFornecID AS INTEGER INITIAL ?
     FIELD ttInformacaoTipoFluxoFornecID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttInformacaoTipoFornec NO-UNDO
     FIELD ttInformacaoTipoFornecID AS INTEGER INITIAL ?
     FIELD VendorTypeCode AS CHARACTER INITIAL ?  /*Tipo de Emitente ( campo = emsuni.fornecedor.cod_tip_fornec)*/
     FIELD VendorTypeDescription AS CHARACTER INITIAL ?  /*Descricao do Tipo de Emitente ( campo =  emsuni.tip_fornec.des_tip_fornec)*/
     INDEX ixttInformacaoTipoFornecID IS PRIMARY UNIQUE ttInformacaoTipoFornecID ASCENDING
.


DEFINE TEMP-TABLE ttLogisticsInformation NO-UNDO
     FIELD ABACode AS CHARACTER INITIAL ?  /*Informe codigo do ABA.  (Uso interno: Campo = mgcex.emitente-cex.cod-aba)*/
     FIELD AdditionalCreditLimit AS decimal INITIAL ?  /*Limite de cra dito adicional (Uso interno: Campo = mgadm.emitente.lim-adicional)*/
     FIELD AdditionalCreditLimitDate AS date INITIAL ?  /*Data final de validade do limite de cra dito adicional  (Uso interno: Campo = mgadm.emitente.dt-fim-cred)*/
     FIELD AuxiliaryNumberForTributarySubst AS CHARACTER INITIAL ?  /*Inscricao auxiliar para substituicao tributaria (Uso interno: Campo = mgadm.emitente.insc-subs-trib)*/
     FIELD BalanceCancelationDiscountUpdate AS integer INITIAL ?  /*Forma de geracao do pedido de bonificacao quando esta for feita automaticamente pelo sistema. Valores : 1 Nao Cancela, 2 Cancela na Mesma Proporcao,   Cancela Totalmente (Uso interno: Campo = mgadm.dist-emitente.ind-atua-bonif-canc-saldo - Include =  {diinc/i02di275.i})*/
     FIELD BalanceCancMax AS decimal INITIAL ?  /*Percentual que podera ser faturado a mais nas seq dos pedidos (Uso interno: Campo = mgadm.emitente.per-max-canc)*/
     FIELD CACEXCode AS CHARACTER INITIAL ?  /*Codigo CACEX (Uso interno: Campo = mgadm.emitente.cod-cacex)*/
     FIELD Category AS CHARACTER INITIAL ?  /*Categoria do Cliente  (Uso interno: Campo = mgadm.emitente.categoria)*/
     FIELD ControlPointCode AS integer INITIAL ?  /*Codigo do Ponto de Controle.  (Uso interno: EMS2.04 Atributo Livre = Posicao 11 a 16 do campo mgcex.emitente-cex.char-1 - EMS2.06 Campo = emitente-cex.cod-pto-contr*/
     FIELD ControlPointDescription AS CHARACTER INITIAL ?  /*Descricao Ponto de Controle    (Uso interno: Campo = mgcex.pto-contr.descricao)*/
     FIELD CreditEvaluation AS integer INITIAL ?  /*Indica tipo avaliaa a o de cradito na implantaa a o do pedido. Valores : 1 Na o Avalia, 2 Somente Atrasos Duplicatas,   Limites e Atrasos Duplicatas (Uso interno: Campo = mgadm.emitente.ind-aval - Include =  {adinc/i09ad098.i})*/
     FIELD CreditIndicator AS integer INITIAL ?  /*Credito. Valores : 1 Normal, 2 Automatico,  S Imp Ped,4 Suspenso, 5 Pg a Vista (Uso interno: Campo = mgadm.emitente.ind-cre-cli - Include =  {adinc/i10ad098.i})*/
     FIELD CreditLimit AS decimal INITIAL ?  /*Credito maximo a disposiacao do cliente (Uso interno: Campo = mgadm.emitente.lim-credito)*/
     FIELD CreditLimitCurrency AS integer INITIAL ?  /*Credito maximo a disposiacao do cliente (Uso interno: Campo = mgadm.emitente.moeda-libcred)*/
     FIELD CreditLimitDate AS date INITIAL ?  /*Data final de validade do limite de cra dito (Uso interno: Campo = mgadm.emitente.dt-lim-cred)*/
     FIELD CustomerStdDiscount AS decimal INITIAL ?  /*Percentual de desconto padrao do cliente (Uso Interno: Campo = mgadm.emitente.bonificacao)*/
     FIELD DiscountAfterInvoicing AS LOGICAL INITIAL ?  /*Indica que o cliente so permite que a bonificacao seja faturada apos o faturamento total do item do pedido de venda original (Uso interno: Campo = mgadm.dist-emitente.log-fatur-ped-bonif)*/
     FIELD DiscountOrderGenerationType AS integer INITIAL ?  /*Forma de geracao do pedido de bonificacao quando esta for feita automaticamente pelo sistema. Valores : 1 On-Line, 2 Batch (Uso interno: Campo = mgadm.dist-emitente.ind-geracao-ped-bonif  - Include =  {diinc/i06di272.i})*/
     FIELD DistributionChannelCode AS integer INITIAL ?  /*Codigo do canal de venda. (Uso interno: Campo = mgadm.emitente.cod-canal-venda)*/
     FIELD DistributionChannelDescription AS CHARACTER INITIAL ?  /*Descricao do canal de venda (Uso interno: Campo = mgind.canal-venda.cod-canal-venda)*/
     FIELD EvaluationScope AS integer INITIAL ?  /*Abrangencia da avaliacao de credito. Valores - Cliente, 2 Matriz (Uso interno: Campo = mgadm.emitente.ind-abrange-aval - Include =  {adinc/i24ad098.i})*/
     FIELD ExpenseCollectionType AS INTEGER INITIAL ?  /*Tipo Cobran‡a Despesas  (Uso interno: Campo = mgadm.emitente.tipo-cob-desp - diinc/i04di072.i)*/
     FIELD ExternalWarehouseCode AS CHARACTER INITIAL ?  /*Deposito Externo  (Uso Interno: Campo = mgadm.dist-emitente.cod-depos-ext)*/
     FIELD FiscalOperationCode AS CHARACTER INITIAL ?  /*Codigo da Natureza de Operacao. (Uso interno: Campo = mgadm.emitente.nat-operacao)*/
     FIELD FiscalOperationDescription AS CHARACTER INITIAL ?  /*Descricao Natureza de Operacao (Uso interno: Campo = mgind.natur-oper.denominacao)*/
     FIELD InactiveMonths AS integer INITIAL ?  /*Numero maximo de meses a ser aceito sem compras do cliente  (Uso interno: Campo = mgadm.emitente.nr-mesina)*/
     FIELD IncotermCode AS CHARACTER INITIAL ?  /*Incoterm padrao para Importacao. (Uso interno: Campo = mgcex.emitente-cex.cod-incoterm-imp)*/
     FIELD IncotermCode_00 AS CHARACTER INITIAL ?  /*Incoterm padrao para Importacao. (Uso interno: Campo = mgcex.emitente-cex.cod-incoterm-ext)*/
     FIELD IncotermDescription AS CHARACTER INITIAL ?  /*Descricao Codigo de Incoterm (Uso interno: Campo = mgcex.itinerario.descricao)*/
     FIELD IncotermDescription_00 AS CHARACTER INITIAL ?  /*Descricao Codigo de Incoterm (Uso interno: Campo = mgcex.itinerario.descricao)*/
     FIELD InterstateFiscalOperationCode AS CHARACTER INITIAL ?  /*Codigo da Natureza de Operacao Interestadual. (Uso interno: Campo = mgadm.emitente.nat-operacao)*/
     FIELD InterstateFiscalOperationDesc_00 AS CHARACTER INITIAL ?  /*Descricao Natureza de Operacao Interestadual (Uso interno: Campo = mgind.natur-oper.denominacao)*/
     FIELD InvoicingCurrencyCode AS integer INITIAL ?  /*Codigo da Moeda do Faturamento  (Uso Interno: Campo = mgadm.dist-emitente.mo-fatur)*/
     FIELD InvoicingCurrencyDescription AS CHARACTER INITIAL ?  /*Descricao da moeda (Uso interno: Campo = mguni.moeda.descricao)*/
     FIELD IsCarrier AS LOGICAL INITIAL ?  /* Indica se o fornecedor ‚ um transportador */
     FIELD IsCreditLimitIncluded AS LOGICAL INITIAL ?  /*Considera AP Limite Cra dito.  (Uso interno: EMS2.04 Atributo Livre = Oculpa a posia a o 1 do campo dist-emitente.char-1  - EMS2.05 Campo = dist-emitente.log-consid-ap-lim-cr)*/
     FIELD IsIncotermExpensesIncluded AS LOGICAL INITIAL ?
     FIELD IsOptingSuspendExciseTax AS LOGICAL INITIAL ?  /*Optante de suspensa o de IPI (Uso interno: EMS2.04 Atributo Livre = Oculpa a posia a o 21 do campo emitente.char-1  - EMS2.05 Campo = emitente.log-optan-suspens-ipi)*/
     FIELD IsPresumedCreditTaxReplacement AS LOGICAL INITIAL ?  /*Optante de credito presumido substituiacao tributaria*/
     FIELD IsProfitTaxAndSSTax_00 AS LOGICAL INITIAL ?  /*PIS/COFINS calculado por unidade (Uso interno: EMS2.04 Atributo Livre = Ocupa a posi‡Æo 29 do campo emitente.char-1  - EMS2.06 Campo = emitente.log-calcula-pis-cofins-unid)*/
     FIELD IsRetentionAgent AS LOGICAL INITIAL ?  /*Indica se o emitente e agente de retencao  (Uso interno: Campo = mgadm.emitente.agente-retencao)*/
     FIELD IsTaxPayer AS LOGICAL INITIAL ?  /*Indica se o Cliente e Contribuinte ICMS  (Uso interno: Campo = mgadm.emitente.contrib-icms)*/
     FIELD ItineraryCode AS integer INITIAL ?  /*Itinerario Padrao para Importacao. (Uso interno: Campo = mgcex.emitente-cex.cod-itiner-imp)*/
     FIELD ItineraryCode_00 AS integer INITIAL ?  /*Itinerario Padrao para Importacao. (Uso interno: Campo = mgcex.emitente-cex.cod-itiner-exp)*/
     FIELD ItineraryDescription AS CHARACTER INITIAL ?  /*Descricao Codigo de Itinerario (Uso interno: Campo = mgcex.itinerario.descricao)*/
     FIELD ItineraryDescription_00 AS CHARACTER INITIAL ?  /*Descricao Codigo de Itinerario (Uso interno: Campo = mgcex.itinerario.descricao)*/
     FIELD LanguageCode AS CHARACTER INITIAL ?  /*Idioma Padrao para o Emitente (Uso interno: Campo = mgcex.emitente-cex.cod-idioma)*/
     FIELD LanguageCode_00 AS CHARACTER INITIAL ?  /*Idioma Padrao para o Emitente (Uso interno: Campo = mgcex.emitente-cex.cod-idioma)*/
     FIELD LanguageDescription AS CHARACTER INITIAL ?  /*Descricao do Idioma (Uso interno: Campo = mguni.idioma.des_idioma)*/
     FIELD LanguageDescription_00 AS CHARACTER INITIAL ?  /*Descricao do Idioma (Uso interno: Campo = mguni.idioma.des_idioma)*/
     FIELD LateIndicator AS integer INITIAL ?  /*Indicador de Atraso. Valores : 1 Nao informa, 2 Informa,   Sumariza  (Uso interno: Campo = mgadm.emitente.ind-atraso - Include =  {adinc/i18ad098.i})*/
     FIELD LatePeriods AS integer INITIAL ?  /*Durante quantos periodos nao deve haver atraso nos pagtos (Uso interno: Campo = mgadm.emitente.nr-peratr)*/
     FIELD MarketActivity AS CHARACTER INITIAL ?  /*Ramo de Atividade. (Uso interno: Campo = mgadm.emitente.atividade)*/
     FIELD OrderInvoicingMax AS integer INITIAL ?  /*Percentual a ser faturado a mais nas sequencias do pedido (Uso interno: Campo = mgadm.emitente.perc-fat-ped)*/
     FIELD OriginalCommercialInvoiceLayout AS CHARACTER INITIAL ?  /*Layout original para emissao da Commercial Invoice.  (Uso interno: EMS2.04 Atributo Livre = Oculpa, a partir da posicao 1(inclusive), 40 posicoes do campo emitente-cex.char-2  - EMS2.06 Campo = emitente-cex.des-layout-origin-comerc-inv)*/
     FIELD OriginalPackingListLayout AS CHARACTER INITIAL ?  /*Layout original para emissao da Commercial Invoice.  (Uso interno: EMS2.04 Atributo Livre = Oculpa, a partir da posicao 41(inclusive), 40 posicoes do campo emitente-cex.char-2 - EMS2.06 Campo = emitente-cex.des-layout-origin-packing-list)*/
     FIELD OriginalProformaInvoiceLayout AS CHARACTER INITIAL ?  /*Layout original para emissao da Proforma Invoice.  (Uso interno: EMS2.04 Atributo Livre = Oculpa, a partir da posicao 17(inclusive), 40 posicoes do campo emitente-cex.char-1  - EMS2.06 Campo = emitente-cex.des-layout-origin-proforma-invoi)*/
     FIELD PartialInvoicing AS LOGICAL INITIAL ?  /*Indica se pode haver atendimento parcial dos pedidos do cliente (Uso interno: Campo = mgadm.emitente.ind-fat-par)*/
     FIELD PartialInvoicingMin AS decimal INITIAL ?  /*Percentual minimo aceito para faturamento parcial  (Uso interno: Campo = mgadm.emitente.per-minfat)*/
     FIELD PriceTableCode AS CHARACTER INITIAL ?  /*Codigo da tabela de precos das despesas/impostos padrao. (Uso interno: EMS2.04 Atributo Livre = Posicao 1 a 10 do campo mgcex.emitente-cex.char-1 - EMS2.06 Campo = emitente-cex.nr-tab*/
     FIELD PriceTableCode_00 AS CHARACTER INITIAL ?  /*Codigo da tabela de precos. (Uso interno: Campo = mgadm.emitente.nr-tabpre)*/
     FIELD PriceTableDescription AS CHARACTER INITIAL ?  /*Descricao da Tabela de Preco (Uso interno: Campo = mgdis.tb-preco.descricao)*/
     FIELD PriceTableDescription_00 AS CHARACTER INITIAL ?  /*Descricao da tabela de precos (Uso interno: Campo = mgind.tb-preco.descricao)*/
     FIELD PrintLabel_00 AS LOGICAL INITIAL ?  /*Informa se deve ser emitida etiqueta para correspondencia. (Uso interno: Campo = mgadm.emitente.emite-etiq)*/
     FIELD PrintPOmediaType AS integer INITIAL ?  /*Tipo de midia na qual sera gerada emissao pedido de compra. Valores: 1 Formulario,2 Magnetico,  Fax  (uso interno: mgadm.emitente.emissao-ped - include {adinc/i01ae098.i})*/
     FIELD ProductLine AS CHARACTER INITIAL ?  /*Linha de Produto (Uso interno: Campo = mgadm.emitente.linha-produt)*/
     FIELD ProfitTaxCode AS integer INITIAL ?  /*Codigo de Tributacao PIS  (Uso interno: EMS2.04 Atributo Livre = Oculpa a posicao 22 do campo emitente.char-1  - EMS2.06 Campo = emitente.idi-tributac-cofins)*/
     FIELD QuantityType AS integer INITIAL ?  /*Tipo de quantidade utilizado na atualizacao dos programas de entrega. Valores : 1 Liquida, 2 Acumulada (Uso interno: Campo = mgadm.emitente.tp-qt-prg - Include = {adinc/i2 ad098.i})*/
     FIELD ReleaseInventoryWithoutReleas_00 AS LOGICAL INITIAL ?  /*Libera estoque para alocar no pedido sem avaliar cra dito? (Uso interno: Campo = mgadm.emitente.ind-lib-estoque)*/
     FIELD ReleaseSaleWithoutDiscount AS LOGICAL INITIAL ?  /*Utilizado para indicar se a venda pode ser faturada se nao houver estoque disponivel para faturar a bonificacao (Uso interno: Campo = mgadm.dist-emitente.log-libera-venda-sem-bonif)*/
     FIELD RepresentativeCode_00 AS integer INITIAL ?  /*Codigo Representante do Fornecedor  (Uso interno: Campo = mgcex.emitente-cex.cod-repres)*/
     FIELD RepresentativeName_00 AS CHARACTER INITIAL ?  /*Nome do Representante  (Uso interno: Campo = mgadm.repres.nome)*/
     FIELD RepresentativeRegion AS CHARACTER INITIAL ?  /*Micro Regiao de Atuacao do Representante. (Uso interno: Campo = mgadm.emitente.nome-mic-reg)*/
     FIELD ReshipmentCarrierCode AS integer INITIAL ?  /*Codigo do Transportador Redespacho (Uso interno: Campo = mgadm.transporte.cod-transp)*/
     FIELD ReshipmentCarrierName AS CHARACTER INITIAL ?  /*Nome do Transportador Redespacho. (Uso interno: Campo = mgadm.transporte.nome)*/
     FIELD ReshipmentCarrierShortName AS CHARACTER INITIAL ?  /*Nome Abreviado da Transportadora de Redespacho. (Uso interno: Campo = mgadm.emitente.nome-tr-red)*/
     FIELD ReturnCheckMaxAmount AS decimal INITIAL ?  /*Valor ma ximo a ser aceito para cheque devolvido  (Uso interno: Campo = mgadm.emitente.vl-max-devol)*/
     FIELD ReturnCheckMaxNumber AS integer INITIAL ?  /*Numero maximo de cheque devolvido (Uso interno: Campo = mgadm.emitente.nr-cheque-devol)*/
     FIELD ReturnedCheckPeriod AS integer INITIAL ?  /*Periodo Cheque Devolvido   (Uso interno: Campo = mgadm.emitente.periodo-devol)*/
     FIELD SalesOrderStdClass AS integer INITIAL ?  /*Especie padrao de pedido de venda. Valores: 1 Pedido Simples, 2 Programacao Entrega,   Contrato Fornecimento (Uso interno: Campo = mgadm.emitente.esp-pd-venda - Include = {adinc/i06ad098.i})*/
     FIELD ShipmentCreditEvaluation AS integer INITIAL ?  /*Indica tipo avaliaa a o de cra dito no embarque do pedido. Valores : 1 Na o Avalia, 2 Somente Atrasos Duplicatas,   Limites e Atrasos Duplicatas (Uso interno: Campo = mgadm.emitente.ind-aval-embarque - Include =  {adinc/i09ad098.i})*/
     FIELD SSTaxationCode AS integer INITIAL ?  /*Codigo de Tributacao COFINS  (Uso interno: EMS2.04 Atributo Livre = Oculpa a posicao 28 do campo emitente.char-1  - EMS2.06 Campo = emitente.idi-tributac-cofins)*/
     FIELD StandardCarrierCode AS integer INITIAL ?  /*Codigo do Transportador Padrao. (Uso interno: Campo = mgadm.emitente.cod-transp)*/
     FIELD StandardCarrierName AS CHARACTER INITIAL ?  /*Nome do Transportador. (Uso interno: Campo = mgadm.transporte.nome)*/
     FIELD StandardCarrierShortName AS CHARACTER INITIAL ?  /*Nome Abreviado do Transportador. (Uso interno: Campo = mgadm.transporte.nome-abrev)*/
     FIELD StandardWarehouseCode AS CHARACTER INITIAL ?  /*Codigo do deposito padrao para faturamento (Uso Interno: Campo = mgadm.dist-emitente.cod-depos-pad)*/
     FIELD StdShipToLocationCode AS CHARACTER INITIAL ?  /*Codigo do endereco de entrega padrao do cliente. (Uso interno: Campo = mgadm.emitente.cod-entrega)*/
     FIELD SUFRAMACode AS CHARACTER INITIAL ?  /*Codigo SUFRAMA (Uso interno: Campo = mgadm.emitente.cod-suframa)*/
     FIELD TaxPriceTable AS CHARACTER INITIAL ?  /*Numero da tabela de precos de pauta (Uso interno: Campo = mgadm.dist-emitente.nr-tb-pauta)*/
     FIELD ttLogisticsInformationID AS INTEGER INITIAL ?
     FIELD codActive AS INTEGER INITIAL ? /* mitente de Distribui‡Æo. (Uso interno: Campo = dist-emitente.idi-sit-fornec)*/
     FIELD CodIntegrationParadigma AS LOGICAL INITIAL NO
     INDEX ixttLogisticsInformationID IS PRIMARY UNIQUE ttLogisticsInformationID ASCENDING
.


DEFINE TEMP-TABLE ttPhysicalEntityLanguageI_00 NO-UNDO
     FIELD LanguageCode AS CHARACTER INITIAL ?  /*Idioma ( campo = emsuni.idiom_contat.cod_idioma)*/
     FIELD MainLanguage AS LOGICAL INITIAL ?  /*Idioma Principal ( campo = emsuni.idiom_contat.log_idiom_princ)*/
     FIELD ttInformacaoEspecificaPFID AS INTEGER INITIAL ?
     FIELD ttPhysicalEntityLanguageI_00ID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttPhysicalEntityPhoneInfo_00 NO-UNDO
     FIELD Phone AS CHARACTER INITIAL ?  /*Telefone ( campo = emsuni.telef.cod_telef_sem_edic)*/
     FIELD PhoneCode AS CHARACTER INITIAL ?  /*Codigo do Telefone ( campo = emsuni.telef_pessoa.cod_telefone)*/
     FIELD PhoneDescription AS CHARACTER INITIAL ?  /*Descricao ( campo = emsuni.telef_pessoa.des_telefone)*/
     FIELD PhoneType AS integer INITIAL ?  /*Tipo de Telefone ( campo = emsuni.telef.ind_tip_telef_pessoa)*/
     FIELD ttInformacaoEspecificaPFID AS INTEGER INITIAL ?
     FIELD ttPhysicalEntityPhoneInfo_00ID AS INTEGER INITIAL ?
.


DEFINE TEMP-TABLE ttShipToLocationInformation NO-UNDO
     FIELD CarrierShortName AS CHARACTER INITIAL ?  /*Nome abreviado da transportadora (Uso interno: EMS2.04 Atributo Livre = Oculpa, a partir da posiacao 1(inclusive), 12 posiacoes do campo loc-entr.char-1 - EMS2.05 Campo = loc-entr.nome-transp)*/
     FIELD CIFCityName AS CHARACTER INITIAL ?  /*Nome da cidade - Ate que cidade o frete corre por conta do emitente (Uso interno: EMS2.04 Atributo Livre = Oculpa, a partir da posia a o 25(inclusive), 25 posia a es do campo loc-entr.char-1 - EMS2.05 Campo = loc-entr.nom-cidad-cif) */
     FIELD City AS CHARACTER INITIAL ?  /*Cidade para a entrega do pedido. (Uso interno: Campo = mgadm.loc-entr.cidade)*/
     FIELD Country AS CHARACTER INITIAL ?  /*Pais para a entrega do pedido. (Uso interno: Campo = mgadm.loc-entr.pais)*/
     FIELD CountrySiscomex  AS INTEGER INITIAL ?
     FIELD District AS CHARACTER INITIAL ?  /*Bairro para a entrega do pedido. (Uso interno: Campo = mgadm.loc-entr.bairro)*/
     FIELD FullAddress AS CHARACTER INITIAL ?  /*Enderea o completo (Uso interno: Campo = mgadm.loc-entr.endereco_text) */
     FIELD POBox AS CHARACTER INITIAL ?  /*Caixa postal do endereco de entrega (Uso interno: Campo = mgadm.loc-entr.caixa-postal)*/
     FIELD RouteCode AS CHARACTER INITIAL ?  /*Codigo da Rota (Uso interno: EMS2.04 Atributo Livre = Oculpa, a partir da posia a o 1 (inclusive), 12 posia a es do campo loc-entr.char-1 - EMS2.05 Campo = loc-entr.cod-rota)*/
     FIELD ShipToLocationCode AS CHARACTER INITIAL ?  /*Codigo do endereco de entrega. (Uso interno: Campo = mgadm.loc-entr.cod-entrega)*/
     FIELD ShipToLocationDescription AS CHARACTER INITIAL ?  /*Endereco por extenso (Uso interno: Campo = mgadm.loc-entr.endereco)*/
     FIELD State AS CHARACTER INITIAL ?  /*Unidade de Federacao. (Uso interno: Campo = mgadm.loc-entr.estado)*/
     FIELD StateTaxID AS CHARACTER INITIAL ?  /*Inscria a o Estadual do local de entrega (Uso interno: Campo = mgadm.loc-entr.ins-estadual) */
     FIELD TaxID AS CHARACTER INITIAL ?  /*CGC/MF do local de entrega (Uso interno: Campo = mgadm.loc-entr.cgc)  */
     FIELD ttLogisticsInformationID AS INTEGER INITIAL ?
     FIELD ttShipToLocationInformationID AS INTEGER INITIAL ?
     FIELD ZipCode AS CHARACTER INITIAL ?  /*CEP para a entrega do pedido. (Uso interno: Campo = mgadm.loc-entr.cep)*/
.


DEFINE TEMP-TABLE ttVendorHistoryInformation NO-UNDO
     FIELD History AS CHARACTER INITIAL ?  /*Historico (campo = emsuni.histor_fornec.des_histor_fornec)*/
     FIELD HistoryDataShort AS CHARACTER INITIAL ?  /*Descricao Abreviada do Historico (campo = emsuni.histor_fornec.des_abrev_histor_fornec)*/
     FIELD HistorySequence AS integer INITIAL ?  /*Sequencia (campo = emsuni.histor_fornec.num_seq_histor_fornec)*/
     FIELD ttInformacaoEspecifFornecID AS INTEGER INITIAL ?
     FIELD ttVendorHistoryInformationID AS INTEGER INITIAL ?
.

/* TEMP-TABLE DEFINITION - END */

/* PARAMETERS - BEGIN */
DEFINE INPUT PARAM cEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM Comment AS CHARACTER INITIAL ? NO-UNDO.  /*Observações ( campo = mgadm.emitente.observacoes)*/
DEFINE INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM CustomerVendorCode AS integer INITIAL ? NO-UNDO.  /*Código do Emitente (Uso interno: campo=mgadm.emitente.cod-emitente ou emsuni.cliente.cdn_cliente ou emsuni.fornecedor.cdn_fornecedor)  */
DEFINE INPUT PARAM CustomerVendorIdentification AS integer INITIAL ? NO-UNDO.  /*Tipo de Emitente (Cliente ou Fornecedor). (Uso interno: campo=mgadm.emitente.identific   Valores possíveis= 1- Cliente  2- Fornecedor   3- Ambos)*/
DEFINE INPUT PARAM CustomerVendorName AS CHARACTER INITIAL ? NO-UNDO.  /*Nome do Emitente (Uso Interno: campo=mgadm.emtiente.nome-emit ou emsuni.cliente.nom_pessoa ou emsuni.fornecedor.nom_pessoa)*/
DEFINE INPUT PARAM CustomerVendorShortName AS CHARACTER INITIAL ? NO-UNDO.  /*Nome Abreviado do Emitente (Uso interno: campo=mgadm.emitente.nome-abrev ou emsuni.cliente.nom_abrev ou emsuni.fornecedor.nom_abrev)*/
DEFINE INPUT PARAM DateAdded AS date INITIAL ? NO-UNDO.  /*Data de Implantação do Emitente ( campo = emitente.data-implant ou emsuni.cliente.dat_impl_clien ou emsuni.fornecedor.dat_impl_fornec)*/
DEFINE INPUT PARAM EntityCode AS integer INITIAL ? NO-UNDO.  /*Código da Pessoa ( campo= cliente.num_pessoa ou fornecedor.num_pessoa)*/
DEFINE INPUT PARAM EntityType AS integer INITIAL ? NO-UNDO.  /*Tipo da Pessoa (campo= mgadm.emitente.natureza  ou  cliente.ind_pessoa  ou  fornecedor.ind_pessoa     Valores possiveis= 1- Fisica  2- Juridica)*/
DEFINE INPUT PARAM Image AS CHARACTER INITIAL ? NO-UNDO.  /*Imagem ( campo = emsuni.pessoa_jurid.cod_imagem ou emsuni.pessoa_fisic.cod_imagem)*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttContactClassInformation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttContactLanguageInformation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttCorporateActivityInform_00.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttCorporateMarketActivity_00.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttCorporateShipToAddressI_00.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttCorporateSizeInformation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttCustomerHistoryInformation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttCustomerVendorContactIn_00.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoBancarias.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoBancFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoComunicCliFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoEndCliFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoEndCobr.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoEspecifCliente.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoEspecifFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoEspecificaPF.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoEspecificaPJ.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoGrupoCliente.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoGrupoFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoIDICliFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoMatrizCliFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoPortador.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoPortFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoPortPreferencial.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoRepres.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoTipoCliente.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoTipoFluxoFinanc.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoTipoFluxoFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttInformacaoTipoFornec.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttLogisticsInformation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttPhysicalEntityLanguageI_00.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttPhysicalEntityPhoneInfo_00.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttShipToLocationInformation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttVendorHistoryInformation.
DEFINE INPUT PARAM VendorClassification AS integer INITIAL ? NO-UNDO.  /*Classificação do Fornecedor ( campo = a partir da 5.04 emsuni.fornecedor.num_livre_1 ou p/ 5.06 emsuni.fornecedor.cdn_classif_fornec       valores possiveis = 1- MP   2- SA)*/
/*PARAMETERS - END*/


find first emitente no-lock
     where emitente.cod-emitente = CustomerVendorCode no-error.
if  avail emitente then do:
    assign Comment = emitente.observacoes.

    for each ttInformacaoEspecifCliente:
        assign ttInformacaoEspecifCliente.PaymentTerms        = string(emitente.cod-cond-pag)
               ttInformacaoEspecifCliente.StandardRevenueCode = emitente.tp-rec-padrao
               ttInformacaoEspecifCliente.ReceiveInformation  = emitente.recebe-inf-sci.
    end.

    for each ttInformacaoEspecifFornec:
        assign ttInformacaoEspecifFornec.PrintLabel                 = emitente.emite-etiq
               ttInformacaoEspecifFornec.PrintPO                    = emitente.emissao-ped
               ttInformacaoEspecifFornec.FinancialRate              = emitente.taxa-financ
               ttInformacaoEspecifFornec.FinancialRateDays          = emitente.nr-dias-taxa
               ttInformacaoEspecifFornec.StandardExpenseType        = emitente.tp-desp-padrao.
    end.

    for each ttInformacaoEspecificaPJ:
        assign ttInformacaoEspecificaPJ.ZipCode_01 = emitente.zip-code.
    end.

    for each ttCorporateShipToAddressI_00:
        assign ttCorporateShipToAddressI_00.ZipCode = emitente.zip-code.
    end.

    for each ttInformacaoEndCliFornec:
        assign ttInformacaoEndCliFornec.ZipCode = emitente.zip-code.
    end.

    for each ttInformacaoComunicCliFornec:
        assign ttInformacaoComunicCliFornec.PhoneNumber2    = string(emitente.telefone[2])
               ttInformacaoComunicCliFornec.PhoneExtention2 = string(emitente.ramal[2])
               ttInformacaoComunicCliFornec.EDIPartner      = string(emitente.cod-parceiro-edi).
    end.

    for each ttCustomerVendorContactIn_00:
        assign ttCustomerVendorContactIn_00.ZipCode  = emitente.zip-code.

        find last cont-emit no-lock
            where cont-emit.cod-emitente = emitente.cod-emitente no-error.
        if avail cont-emit then
           assign ttCustomerVendorContactIn_00.ContactSequence = cont-emit.sequencia
                  ttCustomerVendorContactIn_00.ContactArea     = cont-emit.area
                  ttCustomerVendorContactIn_00.ContactTitle    = cont-emit.cargo
                  ttCustomerVendorContactIn_00.Comment         = cont-emit.observacao.
    end.

    for each ttInformacaoEndCobr:
        assign ttInformacaoEndCobr.ZipCode_00 = emitente.zip-code.
    end.

    {adapters/xml/fi2/axsfi001a.i}
end.

