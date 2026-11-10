/********************************************************************************************/
/* Esta include serve para a defini‡Æo das temp-tables utilizadas na prgfin/apb/apb905zd.py */
/********************************************************************************************/

def new shared temp-table tt_integr_apb_impto_impl_pend no-undo 
    field ttv_rec_integr_apb_item_lote     as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
     
    field ttv_rec_antecip_pef_pend         as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
     
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie" 
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_rendto_tribut            as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut" 
    field tta_val_deduc_inss               as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu‡Æo Inss" column-label "Dedu‡Æo Inss" 
    field tta_val_deduc_depend             as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu‡Æo Dependentes" column-label "Dedu‡Æo Dependentes" 
    field tta_val_deduc_pensao             as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deducao PensÆo" column-label "Deducao PensÆo" 
    field tta_val_outras_deduc_impto       as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Dedu‡äes" column-label "Outras Dedu‡äes" 
    field tta_val_base_liq_impto           as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L¡quida Imposto" column-label "Base L¡quida Imposto" 
    field tta_val_aliq_impto               as decimal   format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq" 
    field tta_val_impto_ja_recolhid        as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J  Recolhido" column-label "Imposto J  Recolhido" 
    field tta_val_imposto                  as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto" 
    field tta_dat_vencto_tit_ap            as date      format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_val_impto_indic_econ_impto   as decimal   format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto" 
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico" 
    field tta_cdn_fornec_favorec           as Integer   format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido" 
    field tta_val_deduc_faixa_impto        as decimal   format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Dedu‡Æo" 
    field tta_num_id_tit_ap                as integer   format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP" 
    field tta_num_id_movto_tit_ap          as integer   format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP" 
    field tta_num_id_movto_cta_corren      as integer   format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    index tt_impto_impl_pend_ap_integr     is primary unique 
          ttv_rec_integr_apb_item_lote     ascending 
          tta_cod_pais                     ascending 
          tta_cod_unid_federac             ascending 
          tta_cod_imposto                  ascending 
          tta_cod_classif_impto            ascending 
    index tt_impto_impl_pend_ap_integr_ant is unique 
          ttv_rec_antecip_pef_pend         ascending 
          tta_cod_pais                     ascending 
          tta_cod_unid_federac             ascending 
          tta_cod_imposto                  ascending 
          tta_cod_classif_impto            ascending
    .


def temp-table tt_integr_apb_antecip_pef_p1 no-undo
    field tta_cod_empresa                  as character format "x(3)"  label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(5)"  label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_espec_docto              as character format "x(3)"  label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)"  label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer   format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)"  label "Portador" column-label "Portador"
    field tta_cod_indic_econ               as character format "x(8)"  label "Moeda" column-label "Moeda"
    field tta_num_talon_cheq               as integer   format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field tta_num_cheque                   as integer   format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_val_tit_ap                   as decimal   format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field tta_val_cotac_indic_econ         as decimal   format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_dat_emis_docto               as date      format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date      format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_ind_tip_refer                as character format "X(22)" label "Tipo Referˆncia" column-label "Tipo"
    field tta_cod_seguradora               as character format "x(8)"  label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)"  label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_cod_histor_padr              as character format "x(8)"  label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_natur_cta_ctbl           as character format "X(08)" initial "DB" label "Natureza Cont bil" column-label "Natureza Cont bil"
    field tta_cod_usuar_gerac_movto        as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field ttv_cod_empresa_ext              as character format "x(3)"  label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_estab_ext                as character format "x(8)"  label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)"  label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)"  label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_rec_antecip_pef_pend         as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_ind_tip_cod_barra            as character format "X(01)"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
    index tt_antcppfp_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_antcppfp_tip_refer           
          tta_cod_empresa                  ascending
          tta_ind_tip_refer                ascending
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_recid                        
          ttv_rec_antecip_pef_pend         ascending
    .


def temp-table tt_integr_apb_aprop_ctbl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field ttv_rec_antecip_pef_pend         as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field ttv_rec_integr_apb_impto_pend    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field tta_cod_plano_cta_ctbl           as character format "x(8)"                                       label "Plano Contas"         column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)"                                      label "Conta Cont bil"       column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)"                                       label "Unid Neg¢cio"         column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)"                                       label "Plano Centros Custo"  column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)"                                      label "Centro Custo"         column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)"                                      label "Tipo Fluxo Financ"    column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal   format "->>>,>>>,>>9.99" decimals 2 initial 0       label "Valor Aprop Ctbl"     column-label "Vl Aprop Ctbl"
    field tta_cod_pais                     as character format "x(3)"                                       label "Pa¡s"                 column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)"                                       label "Unidade Federa‡Æo"    column-label "UF"
    field tta_cod_imposto                  as character format "x(5)"                                       label "Imposto"              column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)"                      initial "00000" label "Class Imposto"        column-label "Class Imposto"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)"                                      label "Tipo Fluxo Financ"    column-label "Tipo Fluxo Financ"
    field tta_cod_cta_ctbl_ext             as character format "x(20)"                                      label "Conta Contab Extern"  column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)"                                      label "Sub Conta Externa"    column-label "Sub Conta Externa"
    field tta_cod_ccusto_ext               as character format "x(8)"                                       label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)"                                       label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    index tt_aprop_ctbl_pend_ap_integr_ant
          ttv_rec_antecip_pef_pend         ascending
          ttv_rec_integr_apb_impto_pend    ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
    index tt_aprop_ctbl_pend_ap_integr_id 
          ttv_rec_integr_apb_item_lote     ascending
          ttv_rec_integr_apb_impto_pend    ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
    .


def temp-table tt_integr_apb_abat_prev_provis no-undo
    field ttv_rec_integr_apb_item_lote     as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field ttv_rec_antecip_pef_pend         as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer   format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal   format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    index tt_integr_apb_abat_prev          is unique
          ttv_rec_antecip_pef_pend         ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_integr_apb_abat_prev_provis   is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .


def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field ttv_val_1099                     as decimal   format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
    .


def temp-table tt_ord_compra_tit_ap_pend_1 no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer   format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_ord_compra               as character format "x(8)" label "Ordem Compra" column-label "Ordem Compra"
    field tta_val_perc_ord_compra          as decimal   format ">>9.99" decimals 2 initial 0 label "Perc Ordem Compra" column-label "Perc Ordem Compra"
    field tta_val_origin_ord_compra        as decimal   format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Original Ordem Compr" column-label "Original Ordem Compr"
    field tta_val_sdo_ord_compra           as decimal   format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Ordem Compra" column-label "Saldo Ordem Compra"
    index tt_codigo                        is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_ord_compra               ascending
    .


def temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(25)" label "Campo"  column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)"  label "Valor"  column-label "Valor"
    index tt_idx_param_generic             is primary   unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending
    .


DEFINE TEMP-TABLE tt-gg-seq-titulo NO-UNDO
    FIELD cod-estab       AS CHARACTER 
    FIELD cod-espec-docto AS CHARACTER
    FIELD num-seq         AS INTEGER
    .

DEFINE TEMP-TABLE ttAntecipPefPend NO-UNDO
  FIELD cb4_tit_ap_bco_cobdor    AS CHARACTER   FORMAT 'x(50)' LABEL 'Titulo Bco Cobrador' COLUMN-LABEL 'Titulo Bco Cobrador'
  FIELD cdn_fornecedor           AS INTEGER     FORMAT '>>>,>>>,>>9' LABEL 'Fornecedor' COLUMN-LABEL 'Fornecedor'
  FIELD cod_apol_seguro          AS CHARACTER   FORMAT 'x(12)' LABEL 'Ap¢lice Seguro' COLUMN-LABEL 'Apolice Seguro'
  FIELD cod_arrendador           AS CHARACTER   FORMAT 'x(6)' LABEL 'Arrendador' COLUMN-LABEL 'Arrendador'
  FIELD cod_cart_bcia            AS CHARACTER   FORMAT 'x(3)' LABEL 'Carteira' COLUMN-LABEL 'Carteira'
  FIELD cod_contrat_leas         AS CHARACTER   FORMAT 'x(12)' LABEL 'Contrato Leasing' COLUMN-LABEL 'Contr Leas'
  FIELD cod_cta_corren_mutuo     AS CHARACTER   FORMAT 'x(10)' LABEL 'Conta Corrente M£tuo' COLUMN-LABEL 'Conta Corrente M£tuo'
  FIELD cod_empresa              AS CHARACTER   FORMAT 'x(3)' LABEL 'Empresa' COLUMN-LABEL 'Empresa'
  FIELD cod_espec_docto          AS CHARACTER   FORMAT 'x(3)' LABEL 'Esp‚cie Documento' COLUMN-LABEL 'Esp‚cie'
  FIELD cod_estab                AS CHARACTER   FORMAT 'x(3)' LABEL 'Estabelecimento' COLUMN-LABEL 'Estab'
  FIELD cod_estab_portad_mutuo   AS CHARACTER   FORMAT 'x(3)' LABEL 'Estab Portad M£tuo' COLUMN-LABEL 'Estab Portad M£tuo'
  FIELD cod_finalid_econ         AS CHARACTER   FORMAT 'x(10)' LABEL 'Finalidade' COLUMN-LABEL 'Finalidade'
  FIELD cod_finalid_econ_desemb  AS CHARACTER   LABEL 'Finalid Desembolso' COLUMN-LABEL 'Finalid Desembolso'
  FIELD cod_forma_pagto          AS CHARACTER   FORMAT 'x(3)' LABEL 'Forma Pagamento' COLUMN-LABEL 'F Pagto'
  FIELD cod_histor_padr          AS CHARACTER   LABEL 'Hist¢rico PadrÆo' COLUMN-LABEL 'Hist¢rico PadrÆo'
  FIELD cod_indic_econ           AS CHARACTER   LABEL 'Moeda' COLUMN-LABEL 'Moeda'
  FIELD cod_indic_econ_desemb    AS CHARACTER   LABEL 'Moeda Desembolso' COLUMN-LABEL 'Moeda Desembolso'
  FIELD cod_livre_1              AS CHARACTER   FORMAT 'x(100)' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD cod_livre_2              AS CHARACTER   FORMAT 'x(100)' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD cod_parcela              AS CHARACTER   FORMAT 'x(02)' LABEL 'Parcela' COLUMN-LABEL 'Parc'
  FIELD cod_portador             AS CHARACTER   FORMAT 'x(5)' LABEL 'Portador' COLUMN-LABEL 'Portador'
  FIELD cod_portad_mutuo         AS CHARACTER   FORMAT 'x(5)' LABEL 'Portador M£tuo' COLUMN-LABEL 'Portador M£tuo'
  FIELD cod_refer                AS CHARACTER   FORMAT 'x(10)' LABEL 'Referˆncia' COLUMN-LABEL 'Referˆncia'
  FIELD cod_seguradora           AS CHARACTER   LABEL 'Seguradora' COLUMN-LABEL 'Seguradora'
  FIELD cod_ser_docto            AS CHARACTER   FORMAT 'x(3)' LABEL 'S‚rie Documento' COLUMN-LABEL 'S‚rie'
  FIELD cod_sist_nac_bcio_cobdor AS CHARACTER   LABEL 'Banco Cobrador' COLUMN-LABEL 'Banco Cobrador'
  FIELD cod_tit_ap               AS CHARACTER   FORMAT 'x(10)' LABEL 'T¡tulo' COLUMN-LABEL 'T¡tulo'
  FIELD cod_tit_ap_bco_cobdor    AS CHARACTER   FORMAT 'x(20)' LABEL 'T¡tulo Banco Cobdor' COLUMN-LABEL 'T¡tulo Banco Cobdor'
  FIELD cod_usuar_gerac_movto    AS CHARACTER   FORMAT 'x(12)' LABEL 'Usuario Gerac Movto' COLUMN-LABEL 'Usuario Gerac'
  FIELD cod_usuar_pagto          AS CHARACTER   FORMAT 'x(12)' LABEL 'Usuar Pagamento' COLUMN-LABEL 'Usu rio Pagto'
  FIELD dat_desconto             AS DATE        FORMAT '99/99/9999' LABEL 'Data Desconto' COLUMN-LABEL 'Dt Descto'
  FIELD dat_emis_docto           AS DATE        FORMAT '99/99/9999' INITIAL today LABEL 'Data  EmissÆo' COLUMN-LABEL 'Dt EmissÆo'
  FIELD dat_livre_1              AS DATE        FORMAT '99/99/9999' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD dat_livre_2              AS DATE        FORMAT '99/99/9999' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD dat_prev_pagto           AS DATE        FORMAT '99/99/9999' LABEL 'Data Prevista Pgto' COLUMN-LABEL 'Dt Prev Pagto'
  FIELD dat_vencto_tit_ap        AS DATE        FORMAT '99/99/9999' INITIAL today LABEL 'Data Vencimento' COLUMN-LABEL 'Dt Vencto'
  FIELD des_text_histor          AS CHARACTER   FORMAT 'x(2000)' LABEL 'Hist¢rico' COLUMN-LABEL 'Hist¢rico'
  FIELD dsl_obs_tit_ap           AS CHARACTER   FORMAT 'x(2000)' LABEL 'Observacao' COLUMN-LABEL 'Observacao'
  FIELD ind_favorec_cheq         AS CHARACTER   FORMAT 'X(15)' LABEL 'Favorecido' COLUMN-LABEL 'Favorecido'
  FIELD ind_natur_cta_ctbl       AS CHARACTER   FORMAT 'X(08)' LABEL 'Natureza Cont bil' COLUMN-LABEL 'Natureza Cont bil'
  FIELD ind_origin_tit_ap        AS CHARACTER   FORMAT 'X(03)' INITIAL 'APB' LABEL 'Origem' COLUMN-LABEL 'Origem'
  FIELD ind_sit_pef_antecip      AS CHARACTER   FORMAT 'X(15)' LABEL 'Situa‡Æo' COLUMN-LABEL 'Situacao'
  FIELD ind_tip_refer            AS CHARACTER   FORMAT 'X(22)' LABEL 'Tipo Referˆncia' COLUMN-LABEL 'Tipo Ref'
  FIELD log_incid_despes_bcia    AS LOGICAL     FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Incide Desp Bancaria' COLUMN-LABEL 'Incide Desp Bancaria'
  FIELD log_livre_1              AS LOGICAL     FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD log_livre_2              AS LOGICAL     FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD nom_favorec_cheq         AS CHARACTER   FORMAT 'x(40)' LABEL 'Nome Favorecido' COLUMN-LABEL 'Nome Favorecido'
  FIELD num_cheque               AS INTEGER     FORMAT '>>>>,>>>,>>9' LABEL 'Num Cheque' COLUMN-LABEL 'Num Cheque'
  FIELD num_event_invest         AS INTEGER     FORMAT '>>>9' LABEL 'Evento Investimento' COLUMN-LABEL 'Evento Investimento'
  FIELD num_livre_1              AS INTEGER     FORMAT '>>>>>9' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD num_livre_2              AS INTEGER     FORMAT '>>>>>9' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD num_ord_compra           AS INTEGER     FORMAT '>>>>>9,99' LABEL 'Ordem Compra' COLUMN-LABEL 'Ordem Compra'
  FIELD num_ord_invest           AS INTEGER     FORMAT '>>>>,>>9' LABEL 'Ordem Investimento' COLUMN-LABEL 'Ordem Investimento'
  FIELD num_ped_compra           AS INTEGER     FORMAT '>>>>,>>9' LABEL 'Pedido Compra' COLUMN-LABEL 'Pedido Compra'
  FIELD num_pessoa               AS INTEGER     FORMAT '>>>,>>>,>>9' LABEL 'Pessoa' COLUMN-LABEL 'Pessoa'
  FIELD num_talon_cheq           AS INTEGER     FORMAT '>>>,>>>,>>9' LABEL 'Talon rio Cheques' COLUMN-LABEL 'Talon rio Cheques'
  FIELD val_cotac_indic_econ     AS DECIMAL     DECIMALS 10 FORMAT '>>>>,>>9.9999999999' LABEL 'Cota‡Æo' COLUMN-LABEL 'Cota‡Æo'
  FIELD val_livre_1              AS DECIMAL     DECIMALS 4 FORMAT '>>>,>>>,>>9.9999' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD val_livre_2              AS DECIMAL     DECIMALS 4 FORMAT '>>>,>>>,>>9.9999' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD val_tit_ap               AS DECIMAL     DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor T¡tulo' COLUMN-LABEL 'Valor T¡tulo'.
