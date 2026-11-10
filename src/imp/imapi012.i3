/********************************************************************************************/
/* Esta include serve para a defini‡Æo das temp-tables utilizadas na prgfin/acr/acr933zb.py */
/********************************************************************************************/

def temp-table tt_consult_antecip_pef_pend no-undo
    field ttv_num_tip_leitura              as integer format ">>>>,>>9"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_row_antecip_pef_pend         as Rowid
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Valor T¡tulo"
    .

def temp-table tt_consult_tit_acr no-undo
    field ttv_num_tip_leitura              as integer format ">>>>,>>9"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_row_tit_acr                  as Rowid
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field ttv_log_val_tit_acr              as logical format "Sim/NÆo" initial no label "Valores" column-label "Valores"
    field ttv_log_movto_tit_acr            as logical format "Sim/NÆo" initial no
    field ttv_log_val_movto_tit_acr        as logical format "Sim/NÆo" initial no
    field ttv_log_correc_movto             as logical format "Sim/NÆo" initial no
    .

def temp-table tt_consult_tit_ap no-undo
    field ttv_num_tip_leitura              as integer format ">>>>,>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_id_tit_ap                as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_row_tit_ap                   as Rowid
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_log_val_tit_ap               as logical format "Sim/NÆo" initial no label "Valores" column-label "Valores"
    field ttv_log_movto_tit_ap             as logical format "Sim/NÆo" initial no
    field ttv_log_val_movto_tit_ap         as logical format "Sim/NÆo" initial no
    .

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .

def temp-table tt_retorno_antecip_pef_pend no-undo
    field cb4_tit_ap_bco_cobdor            as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field cdn_fornecedor                   as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field cod_apol_seguro                  as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field cod_arrendador                   as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field cod_cart_bcia                    as character format "x(3)" label "Carteira" column-label "Carteira"
    field cod_contrat_leas                 as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field cod_cta_corren_mutuo             as character format "x(10)" label "Conta Corrente M£tuo" column-label "Conta Corrente M£tuo"
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_espec_docto                  as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_estab_portad_mutuo           as Character format "x(5)" label "Estab Portad M£tuo" column-label "Estab Portad M£tuo"
    field cod_finalid_econ                 as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field cod_finalid_econ_desemb          as character format "x(8)" label "Finalid Desembolso" column-label "Finalid Desembolso"
    field cod_forma_pagto                  as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field cod_histor_padr                  as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field cod_indic_econ                   as character format "x(8)" label "Moeda" column-label "Moeda"
    field cod_indic_econ_desemb            as character format "x(8)" label "Moeda Desembolso" column-label "Moeda Desembolso"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_parcela                      as character format "x(02)" label "Parcela" column-label "Parc"
    field cod_portador                     as character format "x(5)" label "Portador" column-label "Portador"
    field cod_portad_mutuo                 as character format "x(5)" label "Portador M£tuo" column-label "Portador M£tuo"
    field cod_refer                        as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_safra                        as character format "9999/9999" label "C¢digo Safra" column-label "Safra"
    field cod_seguradora                   as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field cod_ser_docto                    as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field cod_sist_nac_bcio_cobdor         as character format "x(8)" label "Banco Cobrador" column-label "Banco Cobrador"
    field cod_tit_ap                       as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field cod_tit_ap_bco_cobdor            as character format "x(20)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
    field cod_usuar_gerac_movto            as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field cod_usuar_pagto                  as character format "x(12)" label "Usuar Pagamento" column-label "Usu rio Pagto"
    field dat_desconto                     as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field dat_emis_docto                   as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field dat_prev_pagto                   as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field dat_vencto_tit_ap                as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field des_text_histor                  as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field dsl_obs_tit_ap                   as Character format "x(2000)" label "Observacao" column-label "Observacao"
    field ind_favorec_cheq                 as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field ind_natur_cta_ctbl               as character format "X(08)" initial "DB" label "Natureza Cont bil" column-label "Natureza Cont bil"
    field ind_origin_tit_ap                as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field ind_sit_pef_antecip              as character format "X(15)" label "Situa‡Æo" column-label "Situacao"
    field ind_tip_refer                    as character format "X(22)" label "Tipo Referˆncia" column-label "Tipo"
    field log_incid_despes_bcia            as logical format "Sim/NÆo" initial no label "Incide Desp Bancaria" column-label "Incide Desp Bancaria"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field log_zera_sdo_prev_provis         as logical format "Sim/NÆo" initial no label "Zera Sdo Prev/Prov" column-label "Zera Saldo"
    field nom_favorec_cheq                 as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field num_cheque                       as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field num_event_invest                 as integer format ">>>9" initial 0 label "Evento Investimento" column-label "Evento Investimento"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field num_ord_compra                   as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field num_ord_invest                   as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field num_ped_compra                   as integer format ">>>>,>>9" initial 0 label "Pedido Compra" column-label "Pedido Compra"
    field num_pessoa                       as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field num_talon_cheq                   as integer format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field val_cotac_indic_econ             as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_tit_ap                       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_portad_ext               as character format "x(8)"
    field ttv_cod_cart_bcia_ext            as character format "x(8)"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_correc_val_movto no-undo
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_finalid_econ                 as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field ind_forma_conver                 as character format "X(10)" initial "Direta" label "Forma ConversÆo" column-label "Forma ConversÆo"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field num_id_movto_tit_acr             as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field val_acerto_cmcac                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field val_cotac_cm_emis                as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field val_cotac_cm_pagto               as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field val_cotac_cm_vencto              as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field val_cotac_indic_econ             as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field val_cotac_tax_juros              as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field val_fatorf                       as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field val_fatorx                       as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field val_fatory                       as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field val_ganho_perda_cm               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field val_ganho_perda_projec           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_movto_tit_acr                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field val_prev_cotac_fasb              as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field val_variac_cambial               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    /*campos adicionais*/
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_movto_tit_acr no-undo
    field cdn_cliente                      as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field cdn_clien_fatur                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Fatura" column-label "Cliente Fatura"
    field cod_autoriz_bco                  as character format "x(8)" label "Autoriza‡Æo Bco" column-label "Autorizacao Bco"
    field cod_cart_bcia                    as character format "x(3)" label "Carteira" column-label "Carteira"
    field cod_contrat_cambio               as character format "x(15)" label "Contrato Cƒmbio" column-label "Contrato Cƒmbio"
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_espec_docto                  as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_estab_contrat_cambio         as Character format "x(5)" label "Estab Contr Cƒmbio" column-label "Estab Contr Cƒmbio"
    field cod_estab_enctro_cta             as Character format "x(5)" initial ? label "Estab Enct Cta" column-label "Estab Enct Cta"
    field cod_estab_proces_bxa             as Character format "x(5)" label "Estabel Proc. Baixa" column-label "Estab Proc Baixa"
    field cod_estab_reembol                as Character format "x(5)" label "Estab Reembolso" column-label "Estab Reemb"
    field cod_estab_tit_acr_pai            as Character format "x(5)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field cod_finalid_econ_motiv           as character format "x(10)" label "FE Motivo Movto" column-label "FE Motivo Movto"
    field cod_instruc_bcia_1_movto         as character format "x(4)" label "Instr Banc ria 1" column-label "Instr Banc 1"
    field cod_instruc_bcia_2_movto         as character format "x(4)" label "Instr Banc ria 2" column-label "Instr Banc 2"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_motiv_movto_tit_acr          as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field cod_portador                     as character format "x(5)" label "Portador" column-label "Portador"
    field cod_refer                        as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_refer_contrat_cambio         as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_usuario                      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field cod_usuar_gerac_ctbz             as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field dat_apurac_variac_val_ant        as date format "99/99/9999" initial ? label "Apurac Val Ant" column-label "Apurac Val Ant"
    field dat_contrat_cambio_export        as date format "99/99/9999" initial ? label "Dt Contrato Exp" column-label "Dt Contrato Exp"
    field dat_cr_movto_tit_acr             as date format "99/99/9999" initial ? label "Cr‚dito" column-label "Cr‚dito"
    field dat_fluxo_cx_movto               as date format "99/99/9999" initial ? label "Fluxo Caixa Movto" column-label "Fluxo Caixa Movto"
    field dat_gerac_ctbz                   as date format "99/99/9999" initial ? label "Gera‡Æo" column-label "Gera‡Æo"
    field dat_gerac_movto                  as date format "99/99/9999" initial ? label "Data Gera‡Æo Movto" column-label "Data Gera‡Æo Movto"
    field dat_liquidac_tit_acr             as date format "99/99/9999" initial ? label "Liquida‡Æo" column-label "Liquida‡Æo"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field dat_refer_contrat_cambio         as date format "99/99/9999" initial ? label "Dt Referˆncia" column-label "Dt Referˆncia"
    field dat_transacao                    as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field dat_vencto_ant_tit_acr           as date format "99/99/9999" initial ? label "Vencimento Anterior" column-label "Vencimento Anterior"
    field dat_vencto_tit_acr               as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field dat_vincul_contrat_cambio        as date format "99/99/9999" initial ? label "Data Vincula‡Æo" column-label "Dt Vincul"
    field hra_gerac_ctbz                   as Character format "99:99:99" label "Gera‡Æo" column-label "Gera‡Æo"
    field hra_gerac_movto                  as Character format "99:99:99" label "Hora Gera‡Æo Movto" column-label "Hora Gera‡Æo Movto"
    field ind_motiv_acerto_val             as character format "X(12)" initial "Altera‡Æo" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field ind_orig_alter_portad            as character format "X(15)" label "Origem Altera‡Æo" column-label "Origem Altera‡Æo"
    field ind_trans_acr                    as character format "X(29)" initial "Implanta‡Æo" label "Transa‡Æo" column-label "Transa‡Æo"
    field ind_trans_acr_abrev              as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field log_antecip_gerad                as logical format "Sim/NÆo" initial no label "Antecipa‡Æo Gerada" column-label "Antecipa‡Æo Gerada"
    field log_aprop_ctbl_ctbzda            as logical format "Sim/NÆo" initial no label "Contabilizada" column-label "Ctbzda"
    field log_ctbz_aprop_ctbl              as logical format "Sim/NÆo" initial no label "Contabiliza‡Æo" column-label "Ctbz"
    field log_estordo_impto_retid          as logical format "Sim/NÆo" initial yes label "Estorna Impto Ret" column-label "Estor Imp Ret"
    field log_import_tit_sdo               as logical format "Sim/NÆo" initial no label "Import T¡tulo Sdo" column-label "Imp Tit Sdo"
    field log_integr_cfl_atlzdo            as logical format "Sim/NÆo" initial no label "CFL Atualizado" column-label "CFL Atualizado"
    field log_liquidac_contra_antecip      as logical format "Sim/NÆo" initial no label "Liquidac AN" column-label "Liquidac AN"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field log_movto_comis_estordo          as logical format "Sim/NÆo" initial no label "Estorna ComissÆo" column-label "Estorna ComissÆo"
    field log_movto_envdo_bco              as logical format "Sim/NÆo" initial no label "Enviado Banco" column-label "Movto Envdo"
    field log_movto_estordo                as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field log_ndebito_gerad                as logical format "Sim/NÆo" initial no label "ND‚bito" column-label "ND‚bito"
    field log_recuper_perda                as logical format "Sim/NÆo" initial no label "Recupera‡Æo Perda" column-label "Recupera‡Æo Perda"
    field log_retenc_impto_liq             as logical format "Sim/NÆo" initial no label "Ret‚m na Liquida‡Æo" column-label "Ret na Liq"
    field num_contrat_id_cambio            as integer format "999999999" initial 0 label "Num Id Contrato" column-label "Num Id Contrato"
    field num_fatur_acr                    as integer format ">>>>,>>>,>>9" initial 0 label "Fatura" column-label "Fatura"
    field num_id_enctro_cta                as integer format ">>>>>9" initial 0 label "Encontro Conta" column-label "Encontro Conta"
    field num_id_movto_bxa                 as integer format "9999999999" initial 0 label "ID Movto Baixa" column-label "ID Movoto Baixa"
    field num_id_movto_cta_corren          as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field num_id_movto_tit_acr             as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field num_id_movto_tit_acr_pai         as integer format ">>>>,>>9" initial 0 label "Tok Mov Tit Pai" column-label "Tok Mov Tit Pai"
    field num_id_tit_acr                   as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field num_renegoc_cobr_acr             as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field val_abat_tit_acr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field val_cm_tit_acr                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_despes_bcia                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field val_despes_financ                as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Despesa Financ" column-label "Val Desp Fin"
    field val_impto_operac_financ          as decimal format "->>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Opera‡Æo" column-label "Imposto Opera‡Æo"
    field val_iva_retid                    as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "IVA Retido" column-label "IVA Retido"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_juros_calc                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros Calculado" column-label "Juros Calculado"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_motiv_movto_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Custo Motivo" column-label "Vl Custo Motivo"
    field val_movto_fluxo_cx_bco           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor FC/CB" column-label "Valor FC/CB"
    field val_movto_tit_acr                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field val_multa_tit_acr                as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field val_multa_tit_acr_calc           as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Multa Calculada" column-label "Multa Calculada"
    field val_retenc_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor COFINS" column-label "COFINS"
    field val_retenc_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CSLL" column-label "CSLL"
    field val_retenc_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor PIS" column-label "PIS"
    field val_sdo_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_portad_ext               as character format "x(8)"
    field ttv_cod_cart_bcia_ext            as character format "x(8)"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_movto_tit_ap no-undo
    field cb4_tit_ap_bco_cobdor            as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field cdn_fornecedor                   as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field cdn_fornec_fatur                 as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Fatura" column-label "Fornecedor Fatura"
    field cdn_fornec_pef                   as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor PEF" column-label "Fornecedor PEF"
    field cod_contrat_cambio               as character format "x(15)" label "Contrato Cƒmbio" column-label "Contrato Cƒmbio"
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_espec_docto                  as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_estab_contrat_cambio         as Character format "x(5)" label "Estab Contr Cƒmbio" column-label "Estab Contr Cƒmbio"
    field cod_estab_enctro_cta             as Character format "x(5)" initial ? label "Estab Enct Cta" column-label "Estab Enct Cta"
    field cod_estab_portad_mutuo           as Character format "x(5)" label "Estab Portad M£tuo" column-label "Estab Portad M£tuo"
    field cod_estab_proces_bxa             as Character format "x(5)" label "Estabel Proc. Baixa" column-label "Estab Proc Baixa"
    field cod_estab_reembol                as Character format "x(5)" label "Estab Reembolso" column-label "Estab Reemb"
    field cod_estab_tit_ap_pai             as Character format "x(5)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field cod_grp_fornec                   as character format "x(4)" label "Grupo Fornecedor" column-label "Grp Fornec"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_portador                     as character format "x(5)" label "Portador" column-label "Portador"
    field cod_portad_mutuo                 as character format "x(5)" label "Portador M£tuo" column-label "Portador M£tuo"
    field cod_refer                        as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_refer_contrat_cambio         as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_sist_nac_bcio_cobdor         as character format "x(8)" label "Banco Cobrador" column-label "Banco Cobrador"
    field cod_tit_ap_bco_cobdor            as character format "x(20)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
    field cod_usuario                      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field cod_usuar_gerac_ctbz             as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field dat_apurac_variac_val_ant        as date format "99/99/9999" initial ? label "Apurac Val Ant" column-label "Apurac Val Ant"
    field dat_contrat_cambio_import        as date format "99/99/9999" initial ? label "Dt Contrato Cƒmbio" column-label "Dt Contrato Cƒmbio"
    field dat_fluxo_cx_movto               as date format "99/99/9999" initial ? label "Fluxo Caixa Movto" column-label "Fluxo Caixa Movto"
    field dat_gerac_ctbz                   as date format "99/99/9999" initial ? label "Gera‡Æo" column-label "Gera‡Æo"
    field dat_gerac_movto                  as date format "99/99/9999" initial ? label "Data Gera‡Æo Movto" column-label "Data Gera‡Æo Movto"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field dat_refer_contrat_cambio         as date format "99/99/9999" initial ? label "Dt Referˆncia" column-label "Dt Referˆncia"
    field dat_transacao                    as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field hra_gerac_ctbz                   as Character format "99:99:99" label "Gera‡Æo" column-label "Gera‡Æo"
    field hra_gerac_movto                  as Character format "99:99:99" label "Hora Gera‡Æo Movto" column-label "Hora Gera‡Æo Movto"
    field ind_motiv_acerto_val             as character format "X(12)" initial "Altera‡Æo" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field ind_origin_tit_ap                as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field ind_trans_ap                     as character format "X(26)" initial "Implanta‡Æo" label "Transa‡Æo" column-label "Transa‡Æo"
    field ind_trans_ap_abrev               as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field log_aprop_ctbl_ctbzda            as logical format "Sim/NÆo" initial no label "Contabilizada" column-label "Ctbzda"
    field log_bxa_contra_antecip           as logical format "Sim/NÆo" initial no label "Bxa Contra Antecip" column-label "Bxa Contra Antecip"
    field log_ctbz_aprop_ctbl              as logical format "Sim/NÆo" initial no label "Contabiliza‡Æo" column-label "Ctbz"
    field log_import_tit_sdo               as logical format "Sim/NÆo" initial no label "Import T¡tulo Sdo" column-label "Imp Tit Sdo"
    field log_integr_cfl_atlzdo            as logical format "Sim/NÆo" initial no label "CFL Atualizado" column-label "CFL Atualizado"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field log_movto_estordo                as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field log_movto_tit_ap_cartcred        as logical format "Sim/NÆo" initial no label "Pagamento CartÆo" column-label "Pagamento CartÆo"
    field log_pagto_sem_desemb             as logical format "Sim/NÆo" initial no label "Pagto Sem Desemb" column-label "Pagto Sem Desemb"
    field log_reembol                      as logical format "Sim/NÆo" initial no label "Reembolso" column-label "Reembolso"
    field log_utiliza_iva_compens          as logical format "Sim/NÆo" initial no label "Utiliza IVA Compens" column-label "Utz IVA Comp"
    field num_contrat_id_cambio            as integer format "999999999" initial 0 label "Num Id Contrato" column-label "Num Id Contrato"
    field num_event_invest                 as integer format ">>>9" initial 0 label "Evento Investimento" column-label "Evento Investimento"
    field num_fatur_ap                     as integer format ">>>>,>>>,>>9" initial 0 label "N£mero  Fatura" column-label "Num Fatura"
    field num_id_enctro_cta                as integer format ">>>>>9" initial 0 label "Encontro Conta" column-label "Encontro Conta"
    field num_id_movto_bxa                 as integer format "9999999999" initial 0 label "ID Movto Baixa" column-label "ID Movoto Baixa"
    field num_id_movto_cta_corren          as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field num_id_movto_tit_ap              as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field num_id_movto_tit_ap_pai          as integer format "9999999999" initial 0 label "Tk Mv Tit Ap Pai" column-label "Tk Mv Tit Ap Pai"
    field num_id_tit_ap                    as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field num_ord_compra                   as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field num_ord_invest                   as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field num_ped_compra                   as integer format ">>>>,>>9" initial 0 label "Pedido Compra" column-label "Pedido Compra"
    field val_abat_tit_ap                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field val_cm_tit_ap                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Corre‡Æo Monet" column-label "Val Corr Monet"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_iva_retid                    as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "IVA Retido" column-label "IVA Retido"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_movto_ap                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Movimento" column-label "Valor Movto"
    field val_movto_fluxo_cx_bco           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor FC/CB" column-label "Valor FC/CB"
    field val_multa_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field val_sdo_apos_movto               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Sdo Apos Movto" column-label "Vl Sdo Apos Movto"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_portad_ext               as character format "x(8)"
    field ttv_cod_cart_bcia_ext            as character format "x(8)"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_tit_acr no-undo
    field cdn_cliente                      as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field cdn_clien_matriz                 as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Matriz" column-label "Cliente Matriz"
    field cdn_repres                       as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field cod_agenc_bcia                   as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field cod_agenc_cobr_bcia              as character format "x(10)" label "Agˆncia Cobran‡a" column-label "Agˆncia Cobr"
    field cod_banco                        as character format "x(8)" label "Banco" column-label "Banco"
    field cod_cart_bcia                    as character format "x(3)" label "Carteira" column-label "Carteira"
    field cod_cond_cobr                    as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a"
    field cod_cond_pagto                   as character format "x(8)" label "Condi‡Æo Pagamento" column-label "Condi‡Æo Pagamento"
    field cod_contrat_vda                  as character format "x(20)" label "Contrato Venda" column-label "Contrato Venda"
    field cod_cta_corren                   as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field cod_cta_corren_bco               as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field cod_digito_cta_corren            as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_espec_docto                  as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_estab_bord                   as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_grp_clien                    as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field cod_indic_econ                   as character format "x(8)" label "Moeda" column-label "Moeda"
    field cod_indic_econ_juros             as character format "x(8)" label "Indic Econ Juros" column-label "Indic Econ Juros"
    field cod_instruc_bcia_1_acr           as character format "x(4)" label "Instru‡Æo Bcia 1" column-label "Instru‡Æo 1"
    field cod_instruc_bcia_2_acr           as character format "x(4)" label "Instru‡Æo Bcia 2" column-label "Instru‡Æo 2"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_movto_operac_financ          as character format "x(10)" label "C¢digo Movto" column-label "Cod Movto"
    field cod_nota_fisc_faturam            as character format "x(16)" label "Nota Fiscal" column-label "Nota Fiscal"
    field cod_parcela                      as character format "x(02)" label "Parcela" column-label "Parc"
    field cod_parcela_faturam              as character format "x(2)" label "Parcela Nota" column-label "Parcela"
    field cod_portador                     as character format "x(5)" label "Portador" column-label "Portador"
    field cod_proces_export                as character format "x(12)" label "Processo Exporta‡Æo" column-label "Processo Exporta‡Æo"
    field cod_refer                        as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_safra                        as character format "9999/9999" label "C¢digo Safra" column-label "Safra"
    field cod_ser_docto                    as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field cod_tit_acr                      as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field cod_tit_acr_bco                  as character format "x(20)" label "Num T¡tulo Banco" column-label "Num T¡tulo Banco"
    field cod_usuar_indcao_perda           as character format "x(12)" label "Usuario Indica‡Æo" column-label "Usuario Indica‡Æo"
    field dat_abat_tit_acr                 as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field dat_alter_portad                 as date format "99/99/9999" initial ? label "Altera‡Æo Portador" column-label "Alter Portad"
    field dat_desconto                     as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field dat_emis_docto                   as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field dat_fluxo_tit_acr                as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field dat_indcao_perda_dedut           as date format "99/99/9999" initial ? label "Data Indica‡Æo" column-label "Data Indica‡Æo"
    field dat_liquidac_tit_acr             as date format "99/99/9999" initial ? label "Liquida‡Æo" column-label "Liquida‡Æo"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field dat_prev_liquidac                as date format "99/99/9999" initial ? label "Prev Liquida‡Æo" column-label "Prev Liquida‡Æo"
    field dat_transacao                    as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field dat_ult_aprop_despes_financ      as date format "99/99/9999" initial ? label "élt Aprop Desp Fin" column-label "élt Aprop Desp Fin"
    field dat_ult_apurac_variac_val        as date format "99/99/9999" initial ? label "Ult Apur Variac Val" column-label "Ult Apur Variac Val"
    field dat_ult_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Ultima Liquida‡Æo" column-label "Ultima Liquida‡Æo"
    field dat_vencto_origin_tit_acr        as date format "99/99/9999" initial ? label "Dat Ven Orig Tit" column-label "Dat Ven Orig Tit"
    field dat_vencto_tit_acr               as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field des_observacao                   as character format "x(2000)" label "Observa‡äes" column-label "Observa‡äes"
    field des_obs_cobr                     as character format "x(40)" label "Obs Cobran‡a" column-label "Obs Cobran‡a"
    field hra_indcao_perda_dedut           as Character format "99:99:99" label "Hora Indica‡Æo" column-label "Hora Indica‡Æo"
    field ind_ender_cobr                   as character format "X(15)" initial "Cliente" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field ind_orig_tit_acr                 as character format "X(8)" initial "ACREMS50" label "Origem Tit Cta Rec" column-label "Origem Tit Cta Rec"
    field ind_sit_bcia_tit_acr             as character format "X(12)" initial "Liberado" label "Sit Banc ria" column-label "Sit Banc ria"
    field ind_sit_tit_acr                  as character format "X(13)" initial "Normal" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field ind_tip_calc_juros               as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
    field ind_tip_cobr_acr                 as character format "X(10)" initial "Normal" label "Tipo Cobran‡a" column-label "Tipo Cobran‡a"
    field ind_tip_espec_docto              as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field log_aviso_db_emitid              as logical format "Sim/NÆo" initial no label "AD Emitido" column-label "AD Emitido"
    field log_db_autom                     as logical format "Sim/NÆo" initial no label "D‚bito Autom tico" column-label "D‚bito Autom tico"
    field log_dupl_emitid                  as logical format "Sim/NÆo" initial no label "Duplicata Emitida" column-label "Duplicata Emitida"
    field log_emis_boleto                  as logical format "Sim/NÆo" initial no label "EmissÆo Boleto" column-label "EmissÆo Boleto"
    field log_integr_cfl_atlzdo            as logical format "Sim/NÆo" initial no label "CFL Atualizado" column-label "CFL Atualizado"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field log_npromis_emitid               as logical format "Sim/NÆo" initial no label "Nota Promis Emitida" column-label "Nota Promis Emit"
    field log_recibo_emitid                as logical format "Sim/NÆo" initial no label "Recibo Emitido" column-label "Recibo Emitido"
    field log_retenc_impto_impl            as logical format "Sim/NÆo" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field log_sdo_tit_acr                  as logical format "Sim/NÆo" initial yes label "Tem Saldo" column-label "Tem Saldo"
    field log_tip_cr_perda_dedut_tit       as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant"
    field log_tit_acr_cobr_bcia            as logical format "Sim/NÆo" initial no label "Cobr Banc ria" column-label "Cobr Banc ria"
    field log_tit_acr_destndo              as logical format "Sim/NÆo" initial no label "Destinado" column-label "Destinado"
    field log_tit_acr_estordo              as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field log_tit_agrup_especial           as logical format "Sim/NÆo" initial no label "T¡tulo Agrupado" column-label "T¡tulo Agrupado"
    field nom_abrev                        as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field nom_abrev_contat                 as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field num_bord_acr                     as integer format ">>>>>9" initial 0 label "Border“" column-label "Border“"
    field num_fatur_acr                    as integer format ">>>>,>>>,>>9" initial 0 label "Fatura" column-label "Fatura"
    field num_id_movto_cta_corren          as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field num_id_movto_tit_acr_ult         as integer format ">>>>,>>9" initial 0 label "Token Ultimo Movimen" column-label "Token Ultimo Movimen"
    field num_id_tit_acr                   as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field num_pessoa                       as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field num_renegoc_cobr_acr             as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field qtd_dias_atraso_liquidac         as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field qtd_dias_carenc_juros_acr        as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field qtd_dias_carenc_multa_acr        as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field qtd_dias_float_cobr              as decimal format ">>9" initial 0 label "Dias Float" column-label "Dias Float"
    field val_abat_negocdo                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Abat Negociado" column-label "Abat Negociado"
    field val_abat_tit_acr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field val_abat_tit_acr_infor           as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Abatimento Informado" column-label "Abatimento Informado"
    field val_ajust_val_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Ajuste" column-label "Vl Ajuste"
    field val_base_calc_impto              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field val_cm_tit_acr                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field val_cr_cofins                    as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito COFINS" column-label "Credito COFINS"
    field val_cr_csll                      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito CSLL" column-label "Credito CSLL"
    field val_cr_pis                       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field val_desc_negocdo                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Desconto Negociado" column-label "Desconto Negociado"
    field val_desc_tit_acr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field val_despes_bcia                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field val_despes_financ                as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Despesa Financ" column-label "Val Desp Fin"
    field val_devol_cr_cofins              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Devol CR COFINS" column-label "Dev CR COFINS"
    field val_devol_cr_csll                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Devolu‡Æo CR CSLL" column-label "Dev CR CSLL"
    field val_devol_cr_pis                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Devolu‡Æo CR PIS" column-label "Dev CR PIS"
    field val_impto_operac_financ          as decimal format "->>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Opera‡Æo" column-label "Imposto Opera‡Æo"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_liq_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L¡quido" column-label "Vl L¡quido"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_multa_tit_acr                as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field val_origin_tit_acr               as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T¡tulo" column-label "Vl Original T¡tulo"
    field val_perc_abat_acr                as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field val_perc_desc                    as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field val_perc_desc_antecip            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Descto Antecip" column-label "Perc Desc AN"
    field val_perc_juros_dia_atraso        as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field val_perc_multa_atraso            as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field val_saida_subst_nf_dupl          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field val_sdo_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field val_transf_estab                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_portad_ext               as character format "x(8)"
    field ttv_cod_cart_bcia_ext            as character format "x(8)"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_tit_ap no-undo
    field cb4_tit_ap_bco_cobdor            as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field cdn_fornecedor                   as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field cod_apol_seguro                  as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field cod_arrendador                   as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field cod_contrat_leas                 as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_espec_docto                  as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_forma_pagto                  as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field cod_grp_fornec                   as character format "x(4)" label "Grupo Fornecedor" column-label "Grp Fornec"
    field cod_indic_econ                   as character format "x(8)" label "Moeda" column-label "Moeda"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_parcela                      as character format "x(02)" label "Parcela" column-label "Parc"
    field cod_portador                     as character format "x(5)" label "Portador" column-label "Portador"
    field cod_proces_import                as character format "x(12)" label "Processo Importa‡Æo" column-label "Processo Importa‡Æo"
    field cod_refer                        as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field cod_safra                        as character format "9999/9999" label "C¢digo Safra" column-label "Safra"
    field cod_seguradora                   as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field cod_ser_docto                    as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field cod_sist_nac_bcio_cobdor         as character format "x(8)" label "Banco Cobrador" column-label "Banco Cobrador"
    field cod_tit_ap                       as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field cod_tit_ap_bco                   as character format "x(20)" label "T¡tulo  Banco" column-label "T¡tulo Banco"
    field cod_tit_ap_bco_cobdor            as character format "x(20)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
    field dat_desconto                     as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field dat_emis_docto                   as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field dat_liquidac_tit_ap              as date format "99/99/9999" initial ? label "Data Liquida‡Æo" column-label "Data Liquida‡Æo"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field dat_prev_pagto                   as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field dat_transacao                    as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field dat_ult_apurac_variac_val        as date format "99/99/9999" initial ? label "Ult Apur Variac Val" column-label "Ult Apur Variac Val"
    field dat_ult_pagto                    as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
    field dat_vencto_tit_ap                as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field ind_origin_tit_ap                as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field ind_sit_tit_ap                   as character format "X(13)" label "Situa‡Æo" column-label "Situa‡Æo"
    field ind_tip_espec_docto              as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field log_calc_cmcac                   as logical format "Sim/NÆo" initial no label "Calcula CMCAC" column-label "Calc CMCAC"
    field log_calc_fasb                    as logical format "Sim/NÆo" initial no label "Calcula FASB" column-label "Calc FASB"
    field log_concil                       as logical format "Sim/NÆo" initial no label "Tit Conciliado" column-label "Tit Conciliado"
    field log_integr_cfl_atlzdo            as logical format "Sim/NÆo" initial no label "CFL Atualizado" column-label "CFL Atualizado"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field log_pagto_bloqdo                 as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field log_pagto_cartcred               as logical format "Sim/NÆo" initial no label "Pagamento CartÆo" column-label "Pagamento CartÆo"
    field log_sdo_tit_ap                   as logical format "Sim/NÆo" initial yes label "Tem Saldo" column-label "Tem Saldo"
    field log_tit_ap_estordo               as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field num_dias_atraso                  as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field num_fatur_ap                     as integer format ">>>>,>>>,>>9" initial 0 label "N£mero  Fatura" column-label "Num Fatura"
    field num_id_movto_cta_corren          as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field num_id_movto_tit_ap_ult          as integer format ">>>>,>>9" initial 0 label "éltimo Movimento" column-label "éltimo Movimento"
    field num_id_tit_ap                    as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field num_pessoa                       as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field num_seq_refer                    as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field val_abat_tit_ap                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field val_ajust_val_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Ajustes" column-label "Vl Ajustes"
    field val_cm_tit_ap                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Corre‡Æo Monet" column-label "Val Corr Monet"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_desc_tit_ap                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Vl Desconto"
    field val_entr_transf_estab            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Estab" column-label "Entr Transf Estab"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_juros_dia_atraso             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Vl Juros"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_multa_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field val_origin_tit_ap                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"
    field val_pagto_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagamentos" column-label "Vl Pagtos"
    field val_perc_desc                    as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field val_perc_juros_dia_atraso        as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field val_perc_multa_atraso            as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field val_saida_subst_nf_dupl          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field val_sdo_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field val_transf_estab                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_portad_ext               as character format "x(8)"
    field ttv_cod_cart_bcia_ext            as character format "x(8)"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_val_movto_tit_acr no-undo
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_finalid_econ                 as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_tip_fluxo_financ             as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field cod_unid_negoc                   as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field num_id_movto_tit_acr             as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field num_id_val_movto_tit_acr         as integer format ">>>>,>>9" initial 0 label "Id Val Movto" column-label "Id Val Movto"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field val_abat_tit_acr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field val_acerto_cmcac                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field val_ajust_val_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Ajuste" column-label "Vl Ajuste"
    field val_cm_tit_acr                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field val_comis_retid                  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Comissao Retido" column-label "Comissao Retido"
    field val_cr_cofins                    as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito COFINS" column-label "Credito COFINS"
    field val_cr_csll                      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito CSLL" column-label "Credito CSLL"
    field val_cr_pis                       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_despes_bcia                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field val_despes_financ                as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Despesa Financ" column-label "Val Desp Fin"
    field val_entr_transf_estab            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Estab" column-label "Entr Transf Estab"
    field val_entr_transf_unid_negoc       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Un" column-label "Entr Transf Un"
    field val_ganho_perda_cm               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field val_ganho_perda_projec           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field val_impto_operac_financ          as decimal format "->>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Opera‡Æo" column-label "Imposto Opera‡Æo"
    field val_impto_retid                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Retido" column-label "Imposto Retido"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_juros_calc                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros Calculado" column-label "Juros Calculado"
    field val_liquidac_perda_dedut         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Liquidacao Perda Ded" column-label "Liquidacao Perda Ded"
    field val_liquidac_tit_acr             as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquida‡Æo" column-label "Vl Liquida‡Æo"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_movto_tit_acr                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field val_multa_tit_acr                as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field val_multa_tit_acr_calc           as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Multa Calculada" column-label "Multa Calculada"
    field val_saida_subst_nf_dupl          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field val_saida_transf_unid_negoc      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Said Transf Un" column-label "Said Transf Un"
    field val_sdo_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field val_transf_estab                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field val_variac_cambial               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_val_movto_tit_ap no-undo
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_finalid_econ                 as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_tip_fluxo_financ             as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field cod_unid_negoc                   as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field num_id_movto_tit_ap              as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field num_id_val_movto_ap              as integer format ">>>>,>>9" initial 0 label "Id Valor Movimento C" column-label "Id Valor Movimento C"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field val_abat_tit_ap                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field val_acerto_cmcac                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field val_ajust_val_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Ajustes" column-label "Vl Ajustes"
    field val_cm_tit_ap                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Corre‡Æo Monet" column-label "Val Corr Monet"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_entr_transf_estab            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Estab" column-label "Entr Transf Estab"
    field val_entr_transf_unid_negoc       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Un" column-label "Entr Transf Un"
    field val_ganho_perda_cm               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field val_ganho_perda_projec           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field val_imposto                      as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_multa_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field val_pagto_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagamentos" column-label "Vl Pagtos"
    field val_saida_subst_nf_dupl          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field val_saida_transf_unid_negoc      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Said Transf Un" column-label "Said Transf Un"
    field val_sdo_apos_movto               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Sdo Apos Movto" column-label "Vl Sdo Apos Movto"
    field val_transf_estab                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field val_variac_cambial               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_val_tit_acr no-undo
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_finalid_econ                 as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_tip_fluxo_financ             as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field cod_unid_negoc                   as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field dat_cotac_indic_econ             as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field num_id_tit_acr                   as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field num_id_val_tit_acr               as integer format ">>>>,>>9" initial 0 label "Id Val Titulo ACR" column-label "Id Val Titulo ACR"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field val_abat_tit_acr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field val_acerto_cmcac                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field val_ajust_val_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Ajuste" column-label "Vl Ajuste"
    field val_cm_tit_acr                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field val_comis_retid                  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Comissao Retido" column-label "Comissao Retido"
    field val_cotac_indic_econ             as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field val_cotac_tax_juros              as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_despes_bcia                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field val_despes_financ                as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Despesa Financ" column-label "Val Desp Fin"
    field val_entr_transf_estab            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Estab" column-label "Entr Transf Estab"
    field val_entr_transf_unid_negoc       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Un" column-label "Entr Transf Un"
    field val_ganho_perda_cm               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field val_ganho_perda_projec           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field val_impto_operac_financ          as decimal format "->>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Opera‡Æo" column-label "Imposto Opera‡Æo"
    field val_impto_retid                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Retido" column-label "Imposto Retido"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_juros_calc                   as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros Calculado" column-label "Juros Calculado"
    field val_liquidac_perda_dedut         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Liquidacao Perda Ded" column-label "Liquidacao Perda Ded"
    field val_liquidac_tit_acr             as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquida‡Æo" column-label "Vl Liquida‡Æo"
    field val_liq_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L¡quido" column-label "Vl L¡quido"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_multa_tit_acr                as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field val_multa_tit_acr_calc           as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Multa Calculada" column-label "Multa Calculada"
    field val_origin_tit_acr               as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T¡tulo" column-label "Vl Original T¡tulo"
    field val_perc_rat                     as decimal format "->>9.9999999999" decimals 10 initial 0 label "Perc Rateio" column-label "Perc"
    field val_saida_subst_nf_dupl          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field val_saida_transf_unid_negoc      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Said Transf Un" column-label "Said Transf Un"
    field val_sdo_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field val_transf_estab                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field val_variac_cambial               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.

def temp-table tt_retorno_val_tit_ap no-undo
    field cod_empresa                      as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_estab                        as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field cod_finalid_econ                 as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field cod_livre_1                      as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field cod_livre_2                      as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field cod_tip_fluxo_financ             as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field cod_unid_negoc                   as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field dat_cotac_indic_econ             as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field dat_livre_1                      as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field dat_livre_2                      as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field log_livre_1                      as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field log_livre_2                      as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field num_id_movto_tit_ap              as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field num_id_tit_ap                    as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field num_id_val_tit_ap                as integer format ">>>>,>>9" initial 0 label "Id Valor Titulo Cont" column-label "Id Valor Titulo Cont"
    field num_livre_1                      as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field num_livre_2                      as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field val_abat_tit_ap                  as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field val_acerto_cmcac                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field val_ajust_val_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Ajustes" column-label "Vl Ajustes"
    field val_cm_tit_ap                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Corre‡Æo Monet" column-label "Val Corr Monet"
    field val_cotac_indic_econ             as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field val_cotac_tax_juros              as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field val_desconto                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field val_entr_transf_estab            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Estab" column-label "Entr Transf Estab"
    field val_entr_transf_unid_negoc       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Entr Transf Un" column-label "Entr Transf Un"
    field val_ganho_perda_cm               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field val_ganho_perda_projec           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field val_juros                        as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field val_livre_1                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field val_livre_2                      as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field val_multa_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field val_origin_tit_ap                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"
    field val_pagto_tit_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagamentos" column-label "Vl Pagtos"
    field val_perc_rat                     as decimal format "->>9.9999999999" decimals 10 initial 0 label "Perc Rateio" column-label "Perc"
    field val_saida_subst_nf_dupl          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field val_saida_transf_unid_negoc      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Said Transf Un" column-label "Said Transf Un"
    field val_sdo_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field val_transf_estab                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field val_variac_cambial               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_indic_econ_ext           as character format "x(8)"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_rec_table                    as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF.    

def temp-table tt_valores_xml no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_movto                    as decimal format "->,>>>,>>>,>>9.99" decimals 2 label "Movimento" column-label "Valor Movto"
    field ttv_qtd_movto                    as decimal format "->>>>,>>9.9999" decimals 4
    field ttv_cod_return                   as character format "x(40)"
    index tt_1                            
          ttv_num_seq                      ascending
          ttv_num_seq_2                    ascending
    index tt_2                            
          ttv_num_seq                      ascending
          tta_cod_finalid_econ             ascending
    .

def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    .

DEFINE TEMP-TABLE ttTitApb NO-UNDO
  FIELD cb4_tit_ap_bco_cobdor     AS CHARACTER FORMAT 'x(50)' LABEL 'Titulo Bco Cobrador' COLUMN-LABEL 'Titulo Bco Cobrador'
  FIELD cdn_fornecedor            AS INTEGER   FORMAT '>>>,>>>,>>9' LABEL 'Fornecedor' COLUMN-LABEL 'Fornecedor'
  FIELD cod_apol_seguro           AS CHARACTER FORMAT 'x(12)' LABEL 'Ap¢lice Seguro' COLUMN-LABEL 'Apolice Seguro'
  FIELD cod_arrendador            AS CHARACTER FORMAT 'x(6)' LABEL 'Arrendador' COLUMN-LABEL 'Arrendador'
  FIELD cod_contrat_leas          AS CHARACTER FORMAT 'x(12)' LABEL 'Contrato Leasing' COLUMN-LABEL 'Contr Leas'
  FIELD cod_empresa               AS CHARACTER FORMAT 'x(3)' LABEL 'Empresa' COLUMN-LABEL 'Empresa'
  FIELD cod_espec_docto           AS CHARACTER FORMAT 'x(3)' LABEL 'Esp‚cie Documento' COLUMN-LABEL 'Esp‚cie'
  FIELD cod_estab                 AS CHARACTER FORMAT 'x(5)' LABEL 'Estabelecimento' COLUMN-LABEL 'Estab'
  FIELD cod_estab_financ          AS CHARACTER FORMAT 'x(5)' LABEL 'Estabelecimento' COLUMN-LABEL 'Estab'
  FIELD cod_forma_pagto           AS CHARACTER FORMAT 'x(3)' LABEL 'Forma Pagamento' COLUMN-LABEL 'F Pagto'
  FIELD cod_grp_fornec            AS CHARACTER FORMAT 'x(4)' LABEL 'Grupo Fornecedor' COLUMN-LABEL 'Grp Fornec'
  FIELD cod_indic_econ            AS CHARACTER LABEL 'Moeda' COLUMN-LABEL 'Moeda'
  FIELD cod_livre_1               AS CHARACTER FORMAT 'x(100)' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD cod_livre_2               AS CHARACTER FORMAT 'x(100)' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD cod_parcela               AS CHARACTER FORMAT 'x(02)' LABEL 'Parcela' COLUMN-LABEL 'Parc'
  FIELD cod_portador              AS CHARACTER FORMAT 'x(5)' LABEL 'Portador' COLUMN-LABEL 'Portador'
  FIELD cod_proces_import         AS CHARACTER FORMAT 'x(12)' LABEL 'Processo Importa‡Æo' COLUMN-LABEL 'Processo Importa‡Æo'
  FIELD cod_refer                 AS CHARACTER FORMAT 'x(10)' LABEL 'Referˆncia' COLUMN-LABEL 'Referˆncia'
  FIELD cod_seguradora            AS CHARACTER LABEL 'Seguradora' COLUMN-LABEL 'Seguradora'
  FIELD cod_ser_docto             AS CHARACTER FORMAT 'x(3)' LABEL 'S‚rie Documento' COLUMN-LABEL 'S‚rie'
  FIELD cod_sist_nac_bcio_cobdor  AS CHARACTER LABEL 'Banco Cobrador' COLUMN-LABEL 'Banco Cobrador'
  FIELD cod_tit_ap                AS CHARACTER FORMAT 'x(10)' LABEL 'T¡tulo' COLUMN-LABEL 'T¡tulo'
  FIELD cod_tit_ap_bco            AS CHARACTER FORMAT 'x(20)' LABEL 'T¡tulo  Banco' COLUMN-LABEL 'T¡tulo Banco'
  FIELD cod_tit_ap_bco_cobdor     AS CHARACTER FORMAT 'x(20)' LABEL 'T¡tulo Banco Cobdor' COLUMN-LABEL 'T¡tulo Banco Cobdor'
  FIELD dat_desconto              AS DATE      FORMAT '99/99/9999' LABEL 'Data Desconto' COLUMN-LABEL 'Dt Descto'
  FIELD dat_emis_docto            AS DATE      FORMAT '99/99/9999' INITIAL today LABEL 'Data  EmissÆo' COLUMN-LABEL 'Dt EmissÆo'
  FIELD dat_liquidac_tit_ap       AS DATE      FORMAT '99/99/9999' INITIAL 12/31/9999 LABEL 'Data Liquidacao' COLUMN-LABEL 'Data Liquidacao'
  FIELD dat_livre_1               AS DATE      FORMAT '99/99/9999' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD dat_livre_2               AS DATE      FORMAT '99/99/9999' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD dat_prev_pagto            AS DATE      FORMAT '99/99/9999' INITIAL today LABEL 'Data Prevista Pgto' COLUMN-LABEL 'Dt Prev Pagto'
  FIELD dat_transacao             AS DATE      FORMAT '99/99/9999' INITIAL today LABEL 'Data Transa‡Æo' COLUMN-LABEL 'Dat Transac'
  FIELD dat_ult_apurac_variac_val AS DATE      FORMAT '99/99/9999' INITIAL today LABEL 'Ult Apur Variac Val' COLUMN-LABEL 'Ult Apur Variac Val'
  FIELD dat_ult_pagto             AS DATE      FORMAT '99/99/9999' LABEL 'Data éltimo Pagto' COLUMN-LABEL 'Data éltimo Pagto'
  FIELD dat_vencto_tit_ap         AS DATE      FORMAT '99/99/9999' INITIAL today LABEL 'Data Vencimento' COLUMN-LABEL 'Dt Vencto'
  FIELD ind_origin_tit_ap         AS CHARACTER FORMAT 'X(03)' LABEL 'Origem' COLUMN-LABEL 'Origem'
  FIELD ind_sit_tit_ap            AS CHARACTER FORMAT 'X(13)' LABEL 'Situa‡Æo' COLUMN-LABEL 'Situa‡Æo'
  FIELD ind_tip_espec_docto       AS CHARACTER FORMAT 'X(17)' LABEL 'Tipo Esp‚cie' COLUMN-LABEL 'Tipo Esp‚cie'
  FIELD log_calc_cmcac            AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Calcula CMCAC' COLUMN-LABEL 'Calc CMCAC'
  FIELD log_calc_fasb             AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Calcula FASB' COLUMN-LABEL 'Calc FASB'
  FIELD log_concil                AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Tit Conciliado' COLUMN-LABEL 'Tit Conciliado'
  FIELD log_integr_cfl_atlzdo     AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'CFL Atualizado' COLUMN-LABEL 'CFL Atualizado'
  FIELD log_livre_1               AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD log_livre_2               AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD log_pagto_bloqdo          AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Bloqueia Pagamento' COLUMN-LABEL 'Pagto Bloqdo'
  FIELD log_pagto_cartcred        AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Pagamento CartÆo' COLUMN-LABEL 'Pagamento CartÆo'
  FIELD log_sdo_tit_ap            AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Tem Saldo' COLUMN-LABEL 'Tem Saldo'
  FIELD log_tit_ap_estordo        AS LOGICAL   FORMAT 'Sim/NÆo' INITIAL TRUE LABEL 'Estornado' COLUMN-LABEL 'Estornado'
  FIELD num_dias_atraso           AS INTEGER   FORMAT '>9' LABEL 'Dias Carˆncia' COLUMN-LABEL 'Carˆncia'
  FIELD num_fatur_ap              AS INTEGER   FORMAT '>>>>,>>>,>>9' LABEL 'N£mero  Fatura' COLUMN-LABEL 'Num Fatura'
  FIELD num_id_movto_cta_corren   AS INTEGER   FORMAT '9999999999' LABEL 'ID Movto Conta' COLUMN-LABEL 'ID Movto Conta'
  FIELD num_id_movto_tit_ap_ult   AS INTEGER   FORMAT '>>>>,>>9' LABEL 'éltimo Movimento' COLUMN-LABEL 'éltimo Movimento'
  FIELD num_id_tit_ap             AS INTEGER   FORMAT '9999999999' LABEL 'Token Tit AP' COLUMN-LABEL 'Token Tit AP'
  FIELD num_livre_1               AS INTEGER   FORMAT '>>>>>9' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD num_livre_2               AS INTEGER   FORMAT '>>>>>9' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD num_pessoa                AS INTEGER   FORMAT '>>>,>>>,>>9' LABEL 'Pessoa' COLUMN-LABEL 'Pessoa'
  FIELD num_seq_refer             AS INTEGER   FORMAT '>>>9' LABEL 'Sequˆncia' COLUMN-LABEL 'Seq'
  FIELD rec_id_tit_ap             AS &IF {&ROWID_READY} = YES &THEN
                                        ROWID
                                     &ELSE
                                        RECID
                                     &ENDIF
  FIELD val_abat_tit_ap           AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Abatimento' COLUMN-LABEL 'Vl Abatimento'
  FIELD val_ajust_val_tit_ap      AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor  Ajustes' COLUMN-LABEL 'Vl Ajustes'
  FIELD val_cm_tit_ap             AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Val Corre‡Æo Monet' COLUMN-LABEL 'Val Corr Monet'
  FIELD val_desconto              AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Desconto' COLUMN-LABEL 'Valor Desconto'
  FIELD val_desc_tit_ap           AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Desconto' COLUMN-LABEL 'Vl Desconto'
  FIELD val_entr_transf_estab     AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Entr Transf Estab' COLUMN-LABEL 'Entr Transf Estab'
  FIELD val_juros                 AS DECIMAL   DECIMALS 2 FORMAT '>>>>,>>>,>>9.99' LABEL 'Valor Juros' COLUMN-LABEL 'Valor Juros'
  FIELD val_juros_dia_atraso      AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Juros' COLUMN-LABEL 'Vl Juros'
  FIELD val_livre_1               AS DECIMAL   DECIMALS 4 FORMAT '>>>,>>>,>>9.9999' LABEL 'Livre 1' COLUMN-LABEL 'Livre 1'
  FIELD val_livre_2               AS DECIMAL   DECIMALS 4 FORMAT '>>>,>>>,>>9.9999' LABEL 'Livre 2' COLUMN-LABEL 'Livre 2'
  FIELD val_multa_tit_ap          AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Multa' COLUMN-LABEL 'Valor Multa'
  FIELD val_origin_tit_ap         AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Original' COLUMN-LABEL 'Valor Original'
  FIELD val_pagto_tit_ap          AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Vl Pagamentos' COLUMN-LABEL 'Vl Pagtos'
  FIELD val_perc_desc             AS DECIMAL   DECIMALS 4 FORMAT '>9.9999' LABEL 'Percentual Desconto' COLUMN-LABEL 'Perc Descto'
  FIELD val_perc_juros_dia_atraso AS DECIMAL   DECIMALS 6 FORMAT '>9.999999' LABEL 'Perc Jur Dia Atraso' COLUMN-LABEL 'Perc Dia'
  FIELD val_perc_multa_atraso     AS DECIMAL   DECIMALS 2 FORMAT '>9.99' LABEL 'Perc Multa Atraso' COLUMN-LABEL 'Multa Atr'
  FIELD val_saida_subst_nf_dupl   AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Saidas Subst' COLUMN-LABEL 'Saidas Subst'
  FIELD val_sdo_tit_ap            AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Valor Saldo' COLUMN-LABEL 'Valor Saldo'
  FIELD val_transf_estab          AS DECIMAL   DECIMALS 2 FORMAT '->>>,>>>,>>9.99' LABEL 'Saida Transf Estab' COLUMN-LABEL 'Saida Transf Estab'
  .

