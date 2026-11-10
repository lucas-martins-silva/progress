/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX185 2.00.03.017 } /*** "010317" 30/09/2025 11:52:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx185 MUT}
&ENDIF

{include/i_fncrowid.i}

/*
**  BOCX185.P
**
**  PROCESSO-EXP    -  Processo Exporta‡Æo
**
**  Data............ : 11/03/1999 - GeraBO
**
**  Autor........... : Emerson Wessling
**
********************************************************************************/

/*******************************************************************************
**  BOCX185.i1    
**
**  PROCESSO-EXP    -  Processo Exporta‡Æo
**
********************************************************************************/
{cdp/cdcfgdis.i} /* Defini‡Æo de pr‚-processadores */
{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */
{cdp/cdcfgcex.i} /* Defini‡Æo de pr‚-processadores */

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif
  
DEFINE VAR c-cod-estabel        like processo-exp.cod-estabel  no-undo.
DEFINE VAR c-proc-exp           like processo-exp.nr-proc-exp  no-undo.
DEFINE var c-nr-proc-exp        like processo-exp.nr-proc-exp  no-undo.
DEFINE VAR c-processo-orig      LIKE processo-exp.nr-proc-exp  NO-UNDO.
define var c-cod-estabel-ini    like processo-exp.cod-estabel  no-undo.
define var c-cod-estabel-fim    like processo-exp.cod-estabel  no-undo.
define var c-nr-proc-exp-ini    like processo-exp.nr-proc-exp  no-undo.
define var c-nr-proc-exp-fim    like processo-exp.nr-proc-exp  no-undo.
DEFINE VAR i-ind-docum-fatura   like para-fat.ind-docum-fatura no-undo.
DEFINE VAR i-tipo-atend         LIKE it-nota-fisc.tipo-atend   NO-UNDO.
DEFINE VAR c-cod-idiom-usuar    like idioma.cod_idioma         no-undo.
DEFINE VAR d-dt-data-impl-ini   LIKE processo-exp.dat-impl-proces-export NO-UNDO.
DEFINE VAR d-dt-data-impl-fim   LIKE processo-exp.dat-impl-proces-export NO-UNDO.
define var i-ordena             as int                         no-undo.
define var c-proc-exp-ini       as char                        no-undo.
define var c-proc-exp-fim       as char                        no-undo.
DEFINE VAR i-nr-proc-exp        as integer                     no-undo.
DEFINE VAR i-moeda-p            as integer                     no-undo.
DEFINE VAR h-bocx115            as handle                      no-undo.
DEFINE VAR h-bocx180            as handle                      no-undo.
DEFINE VAR h-bocx190            as handle                      no-undo.
DEFINE VAR h-bocx200            as handle                      no-undo.
DEFINE VAR h-bocx215            as handle                      no-undo.
DEFINE VAR h-bocx240            as handle                      no-undo.
DEFINE VAR h-bocx175            as handle                      no-undo.
DEFINE VAR h-boad098            as handle                      no-undo.
DEFINE VAR h-bodi159            as handle                      no-undo.
DEFINE VAR h-bocx159            as handle                      no-undo.
DEFINE VAR h-bocx359            AS HANDLE                      NO-UNDO.
define var h-boun006            as handle                      no-undo.
DEFINE VAR h-exapi025           as handle                      no-undo.
DEFINE VAR c-label-proc         as char                        no-undo.
DEFINE VAR l-proc-canc          as log                         no-undo.
DEFINE VAR r-rowid              as row                         no-undo.
DEFINE VAR l-fatur-tot          as log                         no-undo.
DEFINE VAR l-fatur-par          as log                         no-undo.
DEFINE VAR l-n-fatur            as log                         no-undo.
DEFINE VAR i-conta-msg          as int    init 0               no-undo.
DEFINE VAR c-ped-venda          as char                        no-undo.
DEFINE VAR c-processo           as char                        no-undo.
DEFINE VAR l-todos-fat          as log                         no-undo.
/*DEFINE VAR l-erro               as log                         no-undo.*/
DEFINE VAR l-pri-ent            as log                         no-undo.
DEFINE VAR c-literal            AS CHAR   FORMAT "X(25)"       NO-UNDO.
DEFINE VAR l-valida-ex0201      as log    init yes             no-undo.
DEFINE VAR l-valida-aux         as log                         no-undo.
DEFINE VAR l-atualiza-peso       as log    init no             no-undo.
DEFINE VAR l-atualiza-preco      as log    init no             no-undo.
DEFINE VAR l-atualiza-quantidade as log    init no             no-undo.
DEFINE VAR l-atualiza-despesa    as log    init no             no-undo.
DEFINE VAR l-atualiza-todos      as log    init no             no-undo.
DEFINE VAR l-atualiza-pre-ped    AS LOG                        NO-UNDO.
DEFINE VAR l-considera-dif-preco AS LOGICAL INITIAL NO         NO-UNDO.     
DEFINE VAR de-qt-vinculada       AS DECIMAL                    NO-UNDO.
DEFINE VAR l-erro-exapi006       AS LOG                        NO-UNDO.
DEFINE VAR l-despesa-inclusa     AS LOG                        NO-UNDO.
DEFINE VAR de-val-dif-aceit-conv AS DECIMAL FORMAT "9.9999"    NO-UNDO.
DEFINE VAR r-chave 		         AS ROWID                      NO-UNDO.
DEFINE VARIABLE i-nivel           AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-programa        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ultimo-programa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lAlteracaoItinerario  AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE i-cod-itiner-anterior LIKE itinerario.cod-itiner NO-UNDO.
DEFINE VARIABLE l-gera-novo-titulo    AS   LOGICAL        INITIAL NO       NO-UNDO.
DEFINE VARIABLE l-nr-processo         AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE i-cod-portador        AS   INTEGER               NO-UNDO.
DEFINE VARIABLE i-gera-titulo         AS   INTEGER               NO-UNDO.
DEFINE VARIABLE l-erro                AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE i-nr-ultima-parcela-gerada  AS INTEGER           NO-UNDO.
DEFINE VARIABLE c-nr-sub-proc-exp     LIKE processo-exp.nr-proc-exp NO-UNDO.
DEFINE VARIABLE c-param1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-param2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-liter1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-liter2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-atualiza-cr AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-ft2089      AS HANDLE      NO-UNDO.
DEFINE VAR l-ex0200-proces-orig  AS LOGICAL INITIAL NO NO-UNDO.
def var i-prox-parcela as integer no-undo.


DEFINE VARIABLE c-lb-process-orig   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-processo-exp   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-estabelec-dif  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-importador-dif AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-itinerario-dif AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-situacao-dif   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-importador     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-itinerario     AS CHARACTER NO-UNDO.

{cxbo/bocx205.i tt-despesas-itinerario}
{cxbo/bocx205.i tt-despesas-itiner-aux}
{cxbo/bocx285.i tt-declaracoes-itinerario}
{cxbo/bocx285.i tt-declaracoes-itiner-aux}
/*{exp/exapi011.i}    */
{crp/crapi019.i}    
{btb/btb009za.i}

/*{ftp/ftapi001.i} /* Defini‡Æo das temp-tables utilizadas pela FTAPI001.p*/*/
/*temp-tables utilizadas pela ftapi001.p Foram replicadas para este programas devido 
    a duplicidade de variaveis, buffers e temp-tables em comuns da BO e da API*/

    def temp-table tt-nota-fiscal no-undo
        field atualizar     as log  init yes
        field referencia    as char format "x(10)"
        field r-nota-fiscal as rowid
        field emite-duplic  like nota-fiscal.emite-duplic
        field cod-estabel   like nota-fiscal.cod-estabel
        field serie         like nota-fiscal.serie
        field nr-fatura     like nota-fiscal.nr-fatura
        FIELD l-ecom        AS   LOG.

    def temp-table tt-retorno-nota-fiscal no-undo
        field tipo       as integer   /* 1- Nota Fiscal 2- T¡tulo 3- Nota de D‚bito/Cr‚dito */
        field cod-erro   as character format "x(10)"
        field referencia as character format "x(10)"
        field desc-erro  as character format "x(60)"
                            view-as editor max-chars 2000 
                            scrollbar-vertical size 50 by 4
        field situacao   as logical
        field cod-chave  as character
        INDEX ch-codigo  IS PRIMARY tipo
                                    cod-erro
                                    cod-chave.

    def temp-table tt-total-refer no-undo
        field referencia     as char format "x(10)"
        field nr-doctos      as int
        field vendas-a-vista as dec format '->>>,>>>,>>9.99'
        field vendas-a-prazo as dec format '->>>,>>>,>>9.99'
        field vl-total       as dec format '->>>,>>>,>>9.99'
        INDEX ch-codigo      IS PRIMARY referencia.

    /*Fim definicao temp-table ftapi001*/

DEFINE VARIABLE v_hdl_aux AS HANDLE      NO-UNDO.
DEFINE VARIABLE da-dt-emis-nota-mais-antiga LIKE nota-fiscal.dt-emis-nota          NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_matriz_trad_org_ext AS CHARACTER FORMAT "x(8)":U LABEL "Matriz UO" 
    COLUMN-LABEL "Matriz UO" NO-UNDO.

/* Defini‡Æo de temp-tables utilizadas tamb‚n na include ex0403b.i*/
/*** Defini‡Æo de Temp-tables utilizadas pelo programa acr902zc.py ***/
def temp-table tt_integr_acr_repres_comis_2 no-undo
    field ttv_rec_item_lote_impl_tit_acr   as &IF {&ROWID_READY} = YES &THEN ROWID &ELSE recid format ">>>>>>9" &ENDIF
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo Comis Externo" column-label "Tipo Comis Externo"
    field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Comis" column-label "Lib Comis"
    field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext" column-label "Sit Comis Ext".

def temp-table tt_integr_acr_item_lote_impl_8 no-undo
    field ttv_rec_lote_impl_tit_acr        as &IF {&ROWID_READY} = YES &THEN ROWID &ELSE recid format ">>>>>>9" initial ? &ENDIF    
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida‡Æo" column-label "Prev Liquida‡Æo"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc ria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L¡quido" column-label "Vl L¡quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi‡Æo Pagamento" column-label "Condi‡Æo Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Agˆncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field tta_log_liquidac_autom           as logical format "Sim/NÆo" initial no label "Liquidac Autom tica" column-label "Liquidac Autom tica"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C¢digo CartÆo" column-label "C¢digo CartÆo"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade CartÆo" column-label "Validade CartÆo"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C¢d Pr‚-Autoriza‡Æo" column-label "C¢d Pr‚-Autoriza‡Æo"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concession ria" column-label "Concession ria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/NÆo" initial no label "D‚bito Autom tico" column-label "D‚bito Autom tico"
    field tta_log_destinac_cobr            as logical format "Sim/NÆo" initial no label "Destin Cobran‡a" column-label "Destin Cobran‡a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Banc ria" column-label "Sit Banc ria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T¡tulo Banco" column-label "Num T¡tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agˆncia Cobran‡a" column-label "Agˆncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran‡a" column-label "Obs Cobran‡a"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_rec_item_lote_impl_tit_acr   as &IF {&ROWID_READY} = YES &THEN ROWID &ELSE recid format ">>>>>>9" initial ? &ENDIF
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
    field ttv_cod_comprov_vda              as character format "x(12)" label "Comprovante Venda" column-label "Comprovante Venda"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_cod_autoriz_bco_emissor      as character format "x(6)" label "Codigo Autoriza‡Æo" column-label "Codigo Autoriza‡Æo"
    field ttv_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    field ttv_cod_estab_vendor             as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi‡Æo Pagto" column-label "Condi‡Æo Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Carˆncia" column-label "Dias Carˆncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/NÆo" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/NÆo" initial no
    field ttv_cod_estab_portad             as character format "x(8)"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta‡Æo" column-label "Processo Exporta‡Æo"
    field ttv_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field ttv_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 label "Valor Cr‚dito COFINS" column-label "Credito COFINS"
    field ttv_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 label "Valor Cr‚dito CSLL" column-label "Credito CSLL"
    field tta_cod_indic_econ_desemb        as character format "x(8)" label "Moeda Desembolso" column-label "Moeda Desembolso"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/NÆo" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    FIELD ttv_cod_nota_fisc_faturam        AS character format "x(16)" LABEL "Nr.Nota Fiscal" COLUMN-LABEL "Nr.Nota Fiscal"  
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending
    .

DEF TEMP-TABLE tt_integr_acr_item_lote_impl NO-UNDO
    FIELD ttv_rec_lote_impl_tit_acr        AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" INITIAL ? &ENDIF
    FIELD tta_num_seq_refer                AS INTEGER FORMAT ">>>9" INITIAL 0 LABEL "Sequˆncia" COLUMN-LABEL "Seq"
    FIELD tta_cdn_cliente                  AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Cliente" COLUMN-LABEL "Cliente"
    FIELD tta_cod_espec_docto              AS CHARACTER FORMAT "x(3)" LABEL "Esp‚cie Documento" COLUMN-LABEL "Esp‚cie"
    FIELD tta_cod_ser_docto                AS CHARACTER FORMAT "x(3)" LABEL "S‚rie Documento" COLUMN-LABEL "S‚rie"
    FIELD tta_cod_tit_acr                  AS CHARACTER FORMAT "x(10)" LABEL "T¡tulo" COLUMN-LABEL "T¡tulo"
    FIELD tta_cod_parcela                  AS CHARACTER FORMAT "x(02)" LABEL "Parcela" COLUMN-LABEL "Parc"
    FIELD tta_cod_indic_econ               AS CHARACTER FORMAT "x(8)" LABEL "Moeda" COLUMN-LABEL "Moeda"
    FIELD tta_cod_finalid_econ_ext         AS CHARACTER FORMAT "x(8)" LABEL "Finalid Econ Externa" COLUMN-LABEL "Finalidade Externa"
    FIELD tta_cod_portador                 AS CHARACTER FORMAT "x(5)" LABEL "Portador" COLUMN-LABEL "Portador"
    FIELD tta_cod_portad_ext               AS CHARACTER FORMAT "x(8)" LABEL "Portador Externo" COLUMN-LABEL "Portador Externo"
    FIELD tta_cod_cart_bcia                AS CHARACTER FORMAT "x(3)" LABEL "Carteira" COLUMN-LABEL "Carteira"
    FIELD tta_cod_modalid_ext              AS CHARACTER FORMAT "x(8)" LABEL "Modalidade Externa" COLUMN-LABEL "Modalidade Externa"
    FIELD tta_cod_cond_cobr                AS CHARACTER FORMAT "x(8)" LABEL "Condi‡Æo Cobran‡a" COLUMN-LABEL "Cond Cobran‡a"
    FIELD tta_cod_motiv_movto_tit_acr      AS CHARACTER FORMAT "x(8)" LABEL "Motivo Movimento" COLUMN-LABEL "Motivo Movimento"
    FIELD tta_cod_histor_padr              AS CHARACTER FORMAT "x(8)" LABEL "Hist¢rico PadrÆo" COLUMN-LABEL "Hist¢rico PadrÆo"
    FIELD tta_cdn_repres                   AS INTEGER FORMAT ">>>,>>9" INITIAL 0 LABEL "Representante" COLUMN-LABEL "Representante"
    FIELD tta_dat_vencto_tit_acr           AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Vencimento" COLUMN-LABEL "Vencimento"
    FIELD tta_dat_prev_liquidac            AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Prev Liquida‡Æo" COLUMN-LABEL "Prev Liquida‡Æo"
    FIELD tta_dat_desconto                 AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Data Desconto" COLUMN-LABEL "Dt Descto"
    FIELD tta_dat_emis_docto               AS DATE FORMAT "99/99/9999" INITIAL today LABEL "Data  EmissÆo" COLUMN-LABEL "Dt EmissÆo"
    FIELD tta_val_tit_acr                  AS DECIMAL FORMAT ">>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Valor" COLUMN-LABEL "Valor"
    FIELD tta_val_desconto                 AS DECIMAL FORMAT "->>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Valor Desconto" COLUMN-LABEL "Valor Desconto"
    FIELD tta_val_perc_desc                AS DECIMAL FORMAT ">9.9999" decimals 4 INITIAL 0 LABEL "Percentual Desconto" COLUMN-LABEL "Perc Descto"
    FIELD tta_val_perc_juros_dia_atraso    AS DECIMAL FORMAT ">9.999999" decimals 6 INITIAL 00.00 LABEL "Perc Jur Dia Atraso" COLUMN-LABEL "Perc Dia"
    FIELD tta_val_perc_multa_atraso        AS DECIMAL FORMAT ">9.99" decimals 2 INITIAL 00.00 LABEL "Perc Multa Atraso" COLUMN-LABEL "Multa Atr"
    FIELD tta_val_base_calc_comis          AS DECIMAL FORMAT ">>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Base Calc Comis" COLUMN-LABEL "Base Calc Comis"
    FIELD tta_des_text_histor              AS CHARACTER FORMAT "x(2000)" LABEL "Hist¢rico" COLUMN-LABEL "Hist¢rico"
    FIELD tta_qtd_dias_carenc_multa_acr    AS DECIMAL FORMAT ">>9" INITIAL 0 LABEL "Dias Carenc Multa" COLUMN-LABEL "Dias Carenc Multa"
    FIELD tta_cod_banco                    AS CHARACTER FORMAT "x(8)" LABEL "Banco" COLUMN-LABEL "Banco"
    FIELD tta_cod_agenc_bcia               AS CHARACTER FORMAT "x(10)" LABEL "Agˆncia Banc ria" COLUMN-LABEL "Agˆncia Banc ria"
    FIELD tta_cod_cta_corren_bco           AS CHARACTER FORMAT "x(20)" LABEL "Conta Corrente Banco" COLUMN-LABEL "Conta Corrente Banco"
    FIELD tta_cod_digito_cta_corren        AS CHARACTER FORMAT "x(2)" LABEL "D¡gito Cta Corrente" COLUMN-LABEL "D¡gito Cta Corrente"
    FIELD tta_cod_instruc_bcia_1_movto     AS CHARACTER FORMAT "x(4)" LABEL "Instr Banc ria 1" COLUMN-LABEL "Instr Banc 1"
    FIELD tta_cod_instruc_bcia_2_movto     AS CHARACTER FORMAT "x(4)" LABEL "Instr Banc ria 2" COLUMN-LABEL "Instr Banc 2"
    FIELD tta_qtd_dias_carenc_juros_acr    AS DECIMAL FORMAT ">>9" INITIAL 0 LABEL "Dias Carenc Juros" COLUMN-LABEL "Dias Juros"
    FIELD tta_val_liq_tit_acr              AS DECIMAL FORMAT ">>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Vl L¡quido" COLUMN-LABEL "Vl L¡quido"
    FIELD tta_ind_tip_espec_docto          AS CHARACTER FORMAT "X(17)" INITIAL "Normal" LABEL "Tipo Esp‚cie" COLUMN-LABEL "Tipo Esp‚cie"
    FIELD tta_cod_cond_pagto               AS CHARACTER FORMAT "x(8)" LABEL "Condi‡Æo Pagamento" COLUMN-LABEL "Condi‡Æo Pagamento"
    FIELD ttv_cdn_agenc_fp                 AS INTEGER FORMAT ">>>9" LABEL "Agˆncia"
    FIELD tta_ind_sit_tit_acr              AS CHARACTER FORMAT "X(13)" INITIAL "Normal" LABEL "Situa‡Æo T¡tulo" COLUMN-LABEL "Situa‡Æo T¡tulo"
    FIELD tta_log_liquidac_autom           AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Liquidac Autom tica" COLUMN-LABEL "Liquidac Autom tica"
    FIELD tta_num_id_tit_acr               AS INTEGER FORMAT "9999999999" INITIAL 0 LABEL "Token Cta Receber" COLUMN-LABEL "Token Cta Receber"
    FIELD tta_num_id_movto_tit_acr         AS INTEGER FORMAT "9999999999" INITIAL 0 LABEL "Token Movto Tit  ACR" COLUMN-LABEL "Token Movto Tit  ACR"
    FIELD tta_num_id_movto_cta_corren      AS INTEGER FORMAT "9999999999" INITIAL 0 LABEL "ID Movto Conta" COLUMN-LABEL "ID Movto Conta"
    FIELD tta_cod_admdra_cartao_cr         AS CHARACTER FORMAT "x(5)" LABEL "Administradora" COLUMN-LABEL "Administradora"
    FIELD tta_cod_cartcred                 AS CHARACTER FORMAT "x(20)" LABEL "C¢digo CartÆo" COLUMN-LABEL "C¢digo CartÆo"
    FIELD tta_cod_mes_ano_valid_cartao     AS CHARACTER FORMAT "XX/XXXX" LABEL "Validade CartÆo" COLUMN-LABEL "Validade CartÆo"
    FIELD tta_cod_autoriz_cartao_cr        AS CHARACTER FORMAT "x(6)" LABEL "C¢digo Autoriza‡Æo" COLUMN-LABEL "C¢digo Autoriza‡Æo"
    FIELD tta_dat_compra_cartao_cr         AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Data Compra" COLUMN-LABEL "Data Compra"
    FIELD tta_cod_conces_telef             AS CHARACTER FORMAT "x(5)" LABEL "Concession ria" COLUMN-LABEL "Concession ria"
    FIELD tta_num_ddd_localid_conces       AS INTEGER FORMAT "999" INITIAL 0 LABEL "DDD" COLUMN-LABEL "DDD"
    FIELD tta_num_prefix_localid_conces    AS INTEGER FORMAT ">>>9" INITIAL 0 LABEL "Prefixo" COLUMN-LABEL "Prefixo"
    FIELD tta_num_milhar_localid_conces    AS INTEGER FORMAT "9999" INITIAL 0 LABEL "Milhar" COLUMN-LABEL "Milhar"
    FIELD tta_log_tip_cr_perda_dedut_tit   AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Credito com Garantia" COLUMN-LABEL "Cred Garant"
    FIELD tta_cod_refer                    AS CHARACTER FORMAT "x(10)" LABEL "Referˆncia" COLUMN-LABEL "Referˆncia"
    FIELD tta_ind_ender_cobr               AS CHARACTER FORMAT "X(15)" INITIAL "Cliente" LABEL "Endere‡o Cobran‡a" COLUMN-LABEL "Endere‡o Cobran‡a"
    FIELD tta_nom_abrev_contat             AS CHARACTER FORMAT "x(15)" LABEL "Abreviado Contato" COLUMN-LABEL "Abreviado Contato"
    FIELD tta_log_db_autom                 AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "D‚bito Autom tico" COLUMN-LABEL "D‚bito Autom tico"
    FIELD tta_log_destinac_cobr            AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Destin Cobran‡a" COLUMN-LABEL "Destin Cobran‡a"
    FIELD tta_ind_sit_bcia_tit_acr         AS CHARACTER FORMAT "X(12)" INITIAL "Liberado" LABEL "Sit Banc ria" COLUMN-LABEL "Sit Banc ria"
    FIELD tta_cod_tit_acr_bco              AS CHARACTER FORMAT "x(20)" LABEL "Num T¡tulo Banco" COLUMN-LABEL "Num T¡tulo Banco"
    FIELD tta_cod_agenc_cobr_bcia          AS CHARACTER FORMAT "x(10)" LABEL "Agˆncia Cobran‡a" COLUMN-LABEL "Agˆncia Cobr"
    FIELD tta_dat_abat_tit_acr             AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Abat" COLUMN-LABEL "Abat"
    FIELD tta_val_perc_abat_acr            AS DECIMAL FORMAT ">>9.9999" decimals 4 INITIAL 0 LABEL "Perc Abatimento" COLUMN-LABEL "Abatimento"
    FIELD tta_val_abat_tit_acr             AS DECIMAL FORMAT ">>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Vl Abatimento" COLUMN-LABEL "Vl Abatimento"
    FIELD tta_des_obs_cobr                 AS CHARACTER FORMAT "x(40)" LABEL "Obs Cobran‡a" COLUMN-LABEL "Obs Cobran‡a"
    INDEX tt_id                            IS PRIMARY UNIQUE
          ttv_rec_lote_impl_tit_acr        ASCENDING
          tta_num_seq_refer                ASCENDING
    .


DEF TEMP-TABLE tt_integr_acr_renegoc NO-UNDO
    FIELD  tta_cod_empresa                  AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa"
    FIELD  tta_cod_estab                    AS CHARACTER FORMAT "x(3)" LABEL "Estabelecimento" COLUMN-LABEL "Estab"
    FIELD  tta_num_renegoc_cobr_acr         AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 LABEL "Num. Renegoc" COLUMN-LABEL "Renegocia‡Æo"
    FIELD  tta_cdn_cliente                  AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Cliente" COLUMN-LABEL "Cliente"
    FIELD  tta_dat_transacao                AS DATE FORMAT "99/99/9999" INITIAL today LABEL "Data Transa‡Æo" COLUMN-LABEL "Dat Transac"
    FIELD  tta_cod_cond_pagto               AS CHARACTER FORMAT "x(8)" LABEL "Condi‡Æo Pagamento" COLUMN-LABEL "Condi‡Æo Pagamento"
    FIELD  tta_val_renegoc_cobr_acr         AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Valor" COLUMN-LABEL "Valor"
    FIELD  tta_num_id_renegoc_cobr_acr      AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 LABEL "Id Renegocia‡Æo" COLUMN-LABEL "Id Reneg"
    FIELD  tta_val_perc_juros_renegoc       AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Perc Juros" COLUMN-LABEL "Perc Juros"
    FIELD  tta_ind_tip_renegoc_acr          AS CHARACTER FORMAT "X(15)" INITIAL "Prorroga" LABEL "Tipo Renegocia‡Æo" COLUMN-LABEL "Tipo Renegocia‡Æo"
    FIELD  tta_log_renegoc_acr_estordo      AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Reneg Estornada" COLUMN-LABEL "Renegoc Estornada"
    FIELD  tta_cod_indic_econ_val_pres      AS CHARACTER FORMAT "x(8)" LABEL "Öndice Reajuste" COLUMN-LABEL "Öndice Reaj"
    FIELD  tta_val_perc_val_pres            AS DECIMAL FORMAT ">>9.99" decimals 2 INITIAL 0 LABEL "%" COLUMN-LABEL "%"
    FIELD  tta_cod_livre_1                  AS CHARACTER FORMAT "x(100)" LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_dat_livre_1                  AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_log_livre_1                  AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_num_livre_1                  AS INTEGER FORMAT ">>>>>9" INITIAL 0 LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_val_livre_1                  AS DECIMAL FORMAT ">>>,>>>,>>9.9999" decimals 4 INITIAL 0 LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_cod_livre_2                  AS CHARACTER FORMAT "x(100)" LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_dat_livre_2                  AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_log_livre_2                  AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_num_livre_2                  AS INTEGER FORMAT ">>>>>9" INITIAL 0 LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_val_livre_2                  AS DECIMAL FORMAT ">>>,>>>,>>9.9999" decimals 4 INITIAL 0 LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_log_consid_juros_renegoc     AS LOGICAL FORMAT "Sim/NÆo" INITIAL yes LABEL "Considera Juros" COLUMN-LABEL "Consid Juros"
    FIELD  tta_log_consid_multa_renegoc     AS LOGICAL FORMAT "Sim/NÆo" INITIAL yes LABEL "Considera Multa" COLUMN-LABEL "Considera Multa"
    FIELD  tta_log_consid_abat_renegoc      AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Considera Abatimento" COLUMN-LABEL "Consid Abatimento"
    FIELD  tta_log_consid_desc_renegoc      AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Considera Desconto" COLUMN-LABEL "Consid Desconto"
    FIELD  tta_val_perc_reaj_renegoc        AS DECIMAL FORMAT ">>9.99" decimals 2 INITIAL 0 LABEL "Reajuste" COLUMN-LABEL "Reaj"
    FIELD  tta_val_juros_renegoc_calcul     AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Juros Calculado" COLUMN-LABEL "Juros Calc"
    FIELD  tta_val_juros_renegoc_infor      AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Juros Informado" COLUMN-LABEL "Juros Inform"
    FIELD  tta_val_multa_renegoc_calcul     AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Multa Calculada" COLUMN-LABEL "Multa Calcul"
    FIELD  tta_val_multa_renegoc_infor      AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Multa Informada" COLUMN-LABEL "Multa Informada"
    FIELD  tta_val_tot_reaj_renegoc         AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Total Reajuste" COLUMN-LABEL "Total Reajuste"
    FIELD  tta_val_tot_ajust_renegoc        AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Total Ajuste" COLUMN-LABEL "Total Ajuste"
    FIELD  tta_ind_sit_renegoc_acr          AS CHARACTER FORMAT "X(10)" INITIAL "Pendente" LABEL "Situa‡Æo" COLUMN-LABEL "Situa‡Æo"
    FIELD  tta_cod_refer                    AS CHARACTER FORMAT "x(10)" LABEL "Referˆncia" COLUMN-LABEL "Referˆncia"
    FIELD  tta_cod_espec_docto              AS CHARACTER FORMAT "x(3)" LABEL "Esp‚cie Documento" COLUMN-LABEL "Esp‚cie"
    FIELD  tta_cod_ser_docto                AS CHARACTER FORMAT "x(3)" LABEL "S‚rie Documento" COLUMN-LABEL "S‚rie"
    FIELD  tta_cod_tit_acr                  AS CHARACTER FORMAT "x(10)" LABEL "T¡tulo" COLUMN-LABEL "T¡tulo"
    FIELD  tta_cod_parcela                  AS CHARACTER FORMAT "x(02)" LABEL "Parcela" COLUMN-LABEL "Parc"
    FIELD  tta_dat_vencto_tit_acr           AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Vencimento" COLUMN-LABEL "Vencimento"
    FIELD  tta_cod_portador                 AS CHARACTER FORMAT "x(5)" LABEL "Portador" COLUMN-LABEL "Portador"
    FIELD  tta_cod_cart_bcia                AS CHARACTER FORMAT "x(3)" LABEL "Carteira" COLUMN-LABEL "Carteira"
    FIELD  tta_cod_indic_econ               AS CHARACTER FORMAT "x(8)" LABEL "Moeda" COLUMN-LABEL "Moeda"
    FIELD  tta_cdn_repres                   AS INTEGER FORMAT ">>>,>>9" INITIAL 0 LABEL "Representante" COLUMN-LABEL "Representante"
    FIELD  tta_ind_base_calc_reaj           AS CHARACTER FORMAT "X(17)" INITIAL "Principal" LABEL "Base Calculo" COLUMN-LABEL "Base Calculo"
    FIELD  tta_val_tit_acr                  AS DECIMAL FORMAT ">>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Valor" COLUMN-LABEL "Valor"
    FIELD  tta_qtd_parc_renegoc             AS DECIMAL FORMAT ">9" INITIAL 1 LABEL "Qtd Parcelas" COLUMN-LABEL "Qtd Parcelas"
    FIELD  tta_ind_vencto_renegoc           AS CHARACTER FORMAT "X(10)" INITIAL "Di ria" LABEL "Periodicidade Vencto" COLUMN-LABEL "Vencimento"
    FIELD  tta_num_dia_mes_base_vencto      AS INTEGER FORMAT ">9" INITIAL 0 LABEL "Dia Base Vencto" COLUMN-LABEL "Dia Base Ven"
    FIELD  tta_num_dias_vencto_renegoc      AS INTEGER FORMAT ">9" INITIAL 0 LABEL "Dias Vencimentto" COLUMN-LABEL "Dias Vencimento"
    FIELD  tta_cod_indic_econ_reaj_renegoc  AS CHARACTER FORMAT "x(8)" LABEL "Ind Reajuste" COLUMN-LABEL "Öndice Reaj"
    FIELD  tta_dat_primei_vencto_renegoc    AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Primeiro Vencto" COLUMN-LABEL "Primeiro Vencto"
    FIELD  tta_ind_calc_juros_desc          AS CHARACTER FORMAT "X(08)" LABEL "Calculo Juros" COLUMN-LABEL "Calculo Juros"
    FIELD  tta_cod_cond_cobr                AS CHARACTER FORMAT "x(8)" LABEL "Condi‡Æo Cobran‡a" COLUMN-LABEL "Cond Cobran‡a"
    FIELD  tta_log_juros_param_estab_reaj   AS LOGICAL FORMAT "Sim/NÆo" INITIAL yes LABEL "Consid Juros PadrÆo" COLUMN-LABEL "Juros Pad"
    FIELD  ttv_rec_renegoc_acr              AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" INITIAL ? &ENDIF
    FIELD  ttv_log_atualiza_salario_admit   AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO
    FIELD  ttv_log_atualiza_renegoc         AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO
    FIELD  ttv_cod_usuar_corren             AS CHARACTER FORMAT "x(12)" LABEL "Usu rio Corrente" COLUMN-LABEL "Usu rio Corrente"
    FIELD  tta_log_soma_movto_cobr          AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Soma Movtos Cobr" COLUMN-LABEL "Soma Movtos Cobr"
    FIELD  tta_val_acresc_parc              AS DECIMAL FORMAT ">>9.99" decimals 2 INITIAL 0 LABEL "Acrescimo Parcela" COLUMN-LABEL "Acrescimo Parcela"
    INDEX tt_rngccr_id                     IS PRIMARY UNIQUE
          tta_cod_estab                    ASCENDING
          tta_num_renegoc_cobr_acr         ASCENDING.

DEF TEMP-TABLE tt_integr_acr_item_renegoc NO-UNDO
    FIELD  tta_cod_estab                    AS CHARACTER FORMAT "x(3)" LABEL "Estabelecimento" COLUMN-LABEL "Estab"
    FIELD  tta_num_renegoc_cobr_acr         AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 LABEL "Num. Renegoc" COLUMN-LABEL "Renegocia‡Æo"
    FIELD  tta_cod_estab_tit_acr            AS CHARACTER FORMAT "x(8)" LABEL "Estab T¡tulo ACR" COLUMN-LABEL "Estab T¡tulo ACR"
    FIELD  tta_num_id_tit_acr               AS INTEGER FORMAT "9999999999" INITIAL 0 LABEL "Token Cta Receber" COLUMN-LABEL "Token Cta Receber"
    FIELD  tta_dat_novo_vencto_tit_acr      AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Novo Vencimento" COLUMN-LABEL "Novo Vencimento"
    FIELD  tta_val_juros_renegoc_tit_acr    AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Valor Juros" COLUMN-LABEL "Valor Juros"
    FIELD  tta_val_multa_renegoc_tit_acr    AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Valor Multa" COLUMN-LABEL "Valor Multa"
    FIELD  tta_val_juros_renegoc_calcul     AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Juros Calculado" COLUMN-LABEL "Juros Calc"
    FIELD  tta_val_multa_renegoc_calcul     AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" decimals 2 INITIAL 0 LABEL "Multa Calculada" COLUMN-LABEL "Multa Calcul"
    FIELD  tta_cod_livre_1                  AS CHARACTER FORMAT "x(100)" LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_cod_livre_2                  AS CHARACTER FORMAT "x(100)" LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_log_livre_1                  AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_log_livre_2                  AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_num_livre_1                  AS INTEGER FORMAT ">>>>>9" INITIAL 0 LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_num_livre_2                  AS INTEGER FORMAT ">>>>>9" INITIAL 0 LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_val_livre_1                  AS DECIMAL FORMAT ">>>,>>>,>>9.9999" decimals 4 INITIAL 0 LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_val_livre_2                  AS DECIMAL FORMAT ">>>,>>>,>>9.9999" decimals 4 INITIAL 0 LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_dat_livre_1                  AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_dat_livre_2                  AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  ttv_rec_renegoc_acr              AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" INITIAL ? &ENDIF
    INDEX tt_rec_INDEX                    
          ttv_rec_renegoc_acr              ASCENDING.


DEF TEMP-TABLE tt_integr_acr_fiador_renegoc NO-UNDO
    FIELD  tta_cod_estab                    AS CHARACTER FORMAT "x(3)" LABEL "Estabelecimento" COLUMN-LABEL "Estab"
    FIELD  tta_num_renegoc_cobr_acr         AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 LABEL "Num. Renegoc" COLUMN-LABEL "Renegocia‡Æo"
    FIELD  tta_num_seq                      AS INTEGER FORMAT ">>>,>>9" INITIAL 0 LABEL "Sequˆncia" COLUMN-LABEL "NumSeq"
    FIELD  tta_ind_testem_fiador            AS CHARACTER FORMAT "X(08)" LABEL "Testem/Fiador" COLUMN-LABEL "Testem/Fiador"
    FIELD  tta_ind_tip_pessoa               AS CHARACTER FORMAT "X(08)" LABEL "Tipo Pessoa" COLUMN-LABEL "Tipo Pessoa"
    FIELD  tta_num_pessoa                   AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL ? LABEL "Pessoa" COLUMN-LABEL "Pessoa"
    FIELD  tta_nom_abrev                    AS CHARACTER FORMAT "x(15)" LABEL "Nome Abreviado" COLUMN-LABEL "Nome Abreviado"
    FIELD  tta_cod_livre_1                  AS CHARACTER FORMAT "x(100)" LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_cod_livre_2                  AS CHARACTER FORMAT "x(100)" LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_log_livre_1                  AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_log_livre_2                  AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_num_livre_1                  AS INTEGER FORMAT ">>>>>9" INITIAL 0 LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_num_livre_2                  AS INTEGER FORMAT ">>>>>9" INITIAL 0 LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_val_livre_1                  AS DECIMAL FORMAT ">>>,>>>,>>9.9999" decimals 4 INITIAL 0 LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_val_livre_2                  AS DECIMAL FORMAT ">>>,>>>,>>9.9999" decimals 4 INITIAL 0 LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  tta_dat_livre_1                  AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Livre 1" COLUMN-LABEL "Livre 1"
    FIELD  tta_dat_livre_2                  AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Livre 2" COLUMN-LABEL "Livre 2"
    FIELD  ttv_rec_renegoc_acr              AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" INITIAL ? &ENDIF
    FIELD  ttv_rec_pessoa_fisic_jurid       AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" &ENDIF
    INDEX tt_rec_renegoc_id               
          ttv_rec_renegoc_acr              ASCENDING.

DEF TEMP-TABLE tt_pessoa_fisic_integr NO-UNDO
    FIELD  tta_num_pessoa_fisic             AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Pessoa F¡sica" COLUMN-LABEL "Pessoa F¡sica"
    FIELD  tta_nom_pessoa                   AS CHARACTER FORMAT "x(40)" LABEL "Nome" COLUMN-LABEL "Nome"
    FIELD  tta_cod_id_feder                 AS CHARACTER FORMAT "x(20)" INITIAL ? LABEL "ID Federal" COLUMN-LABEL "ID Federal"
    FIELD  tta_cod_id_estad_fisic           AS CHARACTER FORMAT "x(20)" INITIAL ? LABEL "ID Estadual F¡sica" COLUMN-LABEL "ID Estadual F¡sica"
    FIELD  tta_cod_orgao_emis_id_estad      AS CHARACTER FORMAT "x(10)" LABEL "àrgÆo Emissor" COLUMN-LABEL "àrgÆo Emissor"
    FIELD  tta_cod_unid_federac_emis_estad  AS CHARACTER FORMAT "x(3)" LABEL "Estado EmissÆo" COLUMN-LABEL "UF Emis"
    FIELD  tta_nom_endereco                 AS CHARACTER FORMAT "x(40)" LABEL "Endere‡o" COLUMN-LABEL "Endere‡o"
    FIELD  tta_nom_ender_compl              AS CHARACTER FORMAT "x(10)" LABEL "Complemento" COLUMN-LABEL "Complemento"
    FIELD  tta_nom_bairro                   AS CHARACTER FORMAT "x(20)" LABEL "Bairro" COLUMN-LABEL "Bairro"
    FIELD  tta_nom_cidade                   AS CHARACTER FORMAT "x(32)" LABEL "Cidade" COLUMN-LABEL "Cidade"
    FIELD  tta_nom_condado                  AS CHARACTER FORMAT "x(32)" LABEL "Condado" COLUMN-LABEL "Condado"
    FIELD  tta_cod_pais_ext                 AS CHARACTER FORMAT "x(20)" LABEL "Pa¡s Externo" COLUMN-LABEL "Pa¡s Externo"
    FIELD  tta_cod_pais                     AS CHARACTER FORMAT "x(3)" LABEL "Pa¡s" COLUMN-LABEL "Pa¡s"
    FIELD  tta_cod_unid_federac             AS CHARACTER FORMAT "x(3)" LABEL "Unidade Federa‡Æo" COLUMN-LABEL "UF"
    FIELD  tta_cod_cep                      AS CHARACTER FORMAT "x(20)" LABEL "CEP" COLUMN-LABEL "CEP"
    FIELD  tta_cod_cx_post                  AS CHARACTER FORMAT "x(20)" LABEL "Caixa Postal" COLUMN-LABEL "Caixa Postal"
    FIELD  tta_cod_telefone                 AS CHARACTER FORMAT "x(20)" LABEL "Telefone" COLUMN-LABEL "Telefone"
    FIELD  tta_cod_ramal                    AS CHARACTER FORMAT "x(7)" LABEL "Ramal" COLUMN-LABEL "Ramal"
    FIELD  tta_cod_fax                      AS CHARACTER FORMAT "x(20)" LABEL "FAX" COLUMN-LABEL "FAX"
    FIELD  tta_cod_ramal_fax                AS CHARACTER FORMAT "x(07)" LABEL "Ramal Fax" COLUMN-LABEL "Ramal Fax"
    FIELD  tta_cod_telex                    AS CHARACTER FORMAT "x(7)" LABEL "TELEX" COLUMN-LABEL "TELEX"
    FIELD  tta_cod_modem                    AS CHARACTER FORMAT "x(20)" LABEL "Modem" COLUMN-LABEL "Modem"
    FIELD  tta_cod_ramal_modem              AS CHARACTER FORMAT "x(07)" LABEL "Ramal Modem" COLUMN-LABEL "Ramal Modem"
    FIELD  tta_cod_e_mail                   AS CHARACTER FORMAT "x(40)" LABEL "Internet E-Mail" COLUMN-LABEL "Internet E-Mail"
    FIELD  tta_dat_nasc_pessoa_fisic        AS DATE FORMAT "99/99/9999" INITIAL ? LABEL "Nascimento" COLUMN-LABEL "Data Nasc"
    FIELD  ttv_cod_pais_ext_nasc            AS CHARACTER FORMAT "x(20)" LABEL "Pa¡s Ext Nascimento" COLUMN-LABEL "Pa¡s Ext Nascimento"
    FIELD  ttv_cod_pais_nasc                AS CHARACTER FORMAT "x(3)" LABEL "Pa¡s Nascimento" COLUMN-LABEL "Pa¡s Nasc"
    FIELD  tta_cod_unid_federac_nasc        AS CHARACTER FORMAT "x(3)" LABEL "Estado Nascimento" COLUMN-LABEL "UF Nasc"
    FIELD  tta_des_anot_tab                 AS CHARACTER FORMAT "x(2000)" LABEL "Anota‡Æo Tabela" COLUMN-LABEL "Anota‡Æo Tabela"
    FIELD  tta_nom_mae_pessoa               AS CHARACTER FORMAT "x(40)" LABEL "MÆe Pessoa" COLUMN-LABEL "MÆe Pes"
    FIELD  tta_cod_imagem                   AS CHARACTER FORMAT "x(30)" LABEL "Imagem" COLUMN-LABEL "Imagem"
    FIELD  tta_log_ems_20_atlzdo            AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "2.0 Atualizado" COLUMN-LABEL "2.0 Atualizado"
    FIELD  ttv_num_tip_operac               AS INTEGER FORMAT ">9"
    FIELD  ttv_rec_fiador_renegoc           AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" INITIAL ? &ENDIF
    INDEX tt_pssfsca_id                    IS PRIMARY UNIQUE
          tta_num_pessoa_fisic             ASCENDING
          tta_cod_id_feder                 ASCENDING
          tta_cod_pais_ext                 ASCENDING
    INDEX tt_pssfsca_identpes             
          tta_nom_pessoa                   ASCENDING
          tta_cod_id_estad_fisic           ASCENDING
          tta_cod_unid_federac_emis_estad  ASCENDING
          tta_dat_nasc_pessoa_fisic        ASCENDING
          tta_nom_mae_pessoa               ASCENDING
    INDEX tt_pssfsca_nom_pessoa_word      
          tta_nom_pessoa                   ASCENDING
    INDEX tt_pssfsca_unid_federac         
          tta_cod_pais_ext                 ASCENDING
          tta_cod_unid_federac             ASCENDING.

DEF TEMP-TABLE tt_pessoa_jurid_integr NO-UNDO
    FIELD  tta_num_pessoa_jurid             AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Pessoa Jur¡dica" COLUMN-LABEL "Pessoa Jur¡dica"
    FIELD  tta_nom_pessoa                   AS CHARACTER FORMAT "x(40)" LABEL "Nome" COLUMN-LABEL "Nome"
    FIELD  tta_cod_id_feder                 AS CHARACTER FORMAT "x(20)" INITIAL ? LABEL "ID Federal" COLUMN-LABEL "ID Federal"
    FIELD  tta_cod_id_estad_jurid           AS CHARACTER FORMAT "x(20)" INITIAL ? LABEL "ID Estadual" COLUMN-LABEL "ID Estadual"
    FIELD  tta_cod_id_munic_jurid           AS CHARACTER FORMAT "x(20)" INITIAL ? LABEL "ID Municipal" COLUMN-LABEL "ID Municipal"
    FIELD  tta_cod_id_previd_social         AS CHARACTER FORMAT "x(20)" LABEL "Id Previdˆncia" COLUMN-LABEL "Id Previdˆncia"
    FIELD  tta_log_fins_lucrat              AS LOGICAL FORMAT "Sim/NÆo" INITIAL yes LABEL "Fins Lucrativos" COLUMN-LABEL "Fins Lucrativos"
    FIELD  tta_num_pessoa_jurid_matriz      AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Matriz" COLUMN-LABEL "Matriz"
    FIELD  tta_nom_endereco                 AS CHARACTER FORMAT "x(40)" LABEL "Endere‡o" COLUMN-LABEL "Endere‡o"
    FIELD  tta_nom_ender_compl              AS CHARACTER FORMAT "x(10)" LABEL "Complemento" COLUMN-LABEL "Complemento"
    FIELD  tta_nom_bairro                   AS CHARACTER FORMAT "x(20)" LABEL "Bairro" COLUMN-LABEL "Bairro"
    FIELD  tta_nom_cidade                   AS CHARACTER FORMAT "x(32)" LABEL "Cidade" COLUMN-LABEL "Cidade"
    FIELD  tta_nom_condado                  AS CHARACTER FORMAT "x(32)" LABEL "Condado" COLUMN-LABEL "Condado"
    FIELD  tta_cod_pais_ext                 AS CHARACTER FORMAT "x(20)" LABEL "Pa¡s Externo" COLUMN-LABEL "Pa¡s Externo"
    FIELD  tta_cod_pais                     AS CHARACTER FORMAT "x(3)" LABEL "Pa¡s" COLUMN-LABEL "Pa¡s"
    FIELD  tta_cod_unid_federac             AS CHARACTER FORMAT "x(3)" LABEL "Unidade Federa‡Æo" COLUMN-LABEL "UF"
    FIELD  tta_cod_cep                      AS CHARACTER FORMAT "x(20)" LABEL "CEP" COLUMN-LABEL "CEP"
    FIELD  tta_cod_cx_post                  AS CHARACTER FORMAT "x(20)" LABEL "Caixa Postal" COLUMN-LABEL "Caixa Postal"
    FIELD  tta_cod_telefone                 AS CHARACTER FORMAT "x(20)" LABEL "Telefone" COLUMN-LABEL "Telefone"
    FIELD  tta_cod_fax                      AS CHARACTER FORMAT "x(20)" LABEL "FAX" COLUMN-LABEL "FAX"
    FIELD  tta_cod_ramal_fax                AS CHARACTER FORMAT "x(07)" LABEL "Ramal Fax" COLUMN-LABEL "Ramal Fax"
    FIELD  tta_cod_telex                    AS CHARACTER FORMAT "x(7)" LABEL "TELEX" COLUMN-LABEL "TELEX"
    FIELD  tta_cod_modem                    AS CHARACTER FORMAT "x(20)" LABEL "Modem" COLUMN-LABEL "Modem"
    FIELD  tta_cod_ramal_modem              AS CHARACTER FORMAT "x(07)" LABEL "Ramal Modem" COLUMN-LABEL "Ramal Modem"
    FIELD  tta_cod_e_mail                   AS CHARACTER FORMAT "x(40)" LABEL "Internet E-Mail" COLUMN-LABEL "Internet E-Mail"
    FIELD  tta_des_anot_tab                 AS CHARACTER FORMAT "x(2000)" LABEL "Anota‡Æo Tabela" COLUMN-LABEL "Anota‡Æo Tabela"
    FIELD  tta_ind_tip_pessoa_jurid         AS CHARACTER FORMAT "X(08)" LABEL "Tipo Pessoa" COLUMN-LABEL "Tipo Pessoa"
    FIELD  tta_ind_tip_capit_pessoa_jurid   AS CHARACTER FORMAT "X(13)" LABEL "Tipo Capital" COLUMN-LABEL "Tipo Capital"
    FIELD  tta_cod_imagem                   AS CHARACTER FORMAT "x(30)" LABEL "Imagem" COLUMN-LABEL "Imagem"
    FIELD  tta_log_ems_20_atlzdo            AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO LABEL "2.0 Atualizado" COLUMN-LABEL "2.0 Atualizado"
    FIELD  ttv_num_tip_operac               AS INTEGER FORMAT ">9"
    FIELD  tta_num_pessoa_jurid_cobr        AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Pessoa Jur¡dica Cobr" COLUMN-LABEL "Pessoa Jur¡dica Cobr"
    FIELD  tta_nom_ender_cobr               AS CHARACTER FORMAT "x(40)" LABEL "Endere‡o Cobran‡a" COLUMN-LABEL "Endere‡o Cobran‡a"
    FIELD  tta_nom_ender_compl_cobr         AS CHARACTER FORMAT "x(10)" LABEL "Complemento" COLUMN-LABEL "Complemento"
    FIELD  tta_nom_bairro_cobr              AS CHARACTER FORMAT "x(20)" LABEL "Bairro Cobran‡a" COLUMN-LABEL "Bairro Cobran‡a"
    FIELD  tta_nom_cidad_cobr               AS CHARACTER FORMAT "x(32)" LABEL "Cidade Cobran‡a" COLUMN-LABEL "Cidade Cobran‡a"
    FIELD  tta_nom_condad_cobr              AS CHARACTER FORMAT "x(32)" LABEL "Condado Cobran‡a" COLUMN-LABEL "Condado Cobran‡a"
    FIELD  tta_cod_unid_federac_cobr        AS CHARACTER FORMAT "x(3)" LABEL "Unidade Federa‡Æo" COLUMN-LABEL "Unidade Federa‡Æo"
    FIELD  ttv_cod_pais_ext_cob             AS CHARACTER FORMAT "x(20)" LABEL "Pa¡s Externo" COLUMN-LABEL "Pa¡s Externo"
    FIELD  ttv_cod_pais_cobr                AS CHARACTER FORMAT "x(3)" LABEL "Pa¡s Cobran‡a" COLUMN-LABEL "Pa¡s Cobran‡a"
    FIELD  tta_cod_cep_cobr                 AS CHARACTER FORMAT "x(20)" LABEL "CEP Cobran‡a" COLUMN-LABEL "CEP Cobran‡a"
    FIELD  tta_cod_cx_post_cobr             AS CHARACTER FORMAT "x(20)" LABEL "Caixa Postal Cobran‡" COLUMN-LABEL "Caixa Postal Cobran‡"
    FIELD  tta_num_pessoa_jurid_pagto       AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Pessoa Jurid Pagto" COLUMN-LABEL "Pessoa Jurid Pagto"
    FIELD  tta_nom_ender_pagto              AS CHARACTER FORMAT "x(40)" LABEL "Endere‡o Pagamento" COLUMN-LABEL "Endere‡o Pagamento"
    FIELD  tta_nom_ender_compl_pagto        AS CHARACTER FORMAT "x(10)" LABEL "Complemento" COLUMN-LABEL "Complemento"
    FIELD  tta_nom_bairro_pagto             AS CHARACTER FORMAT "x(20)" LABEL "Bairro Pagamento" COLUMN-LABEL "Bairro Pagamento"
    FIELD  tta_nom_cidad_pagto              AS CHARACTER FORMAT "x(32)" LABEL "Cidade Pagamento" COLUMN-LABEL "Cidade Pagamento"
    FIELD  tta_nom_condad_pagto             AS CHARACTER FORMAT "x(32)" LABEL "Condado Pagamento" COLUMN-LABEL "Condado Pagamento"
    FIELD  tta_cod_unid_federac_pagto       AS CHARACTER FORMAT "x(3)" LABEL "Unidade Federa‡Æo" COLUMN-LABEL "Unidade Federa‡Æo"
    FIELD  ttv_cod_pais_ext_pag             AS CHARACTER FORMAT "x(20)" LABEL "Pa¡s Externo" COLUMN-LABEL "Pa¡s Externo"
    FIELD  ttv_cod_pais_pagto               AS CHARACTER FORMAT "x(3)" LABEL "Pa¡s Pagamento" COLUMN-LABEL "Pa¡s Pagamento"
    FIELD  tta_cod_cep_pagto                AS CHARACTER FORMAT "x(20)" LABEL "CEP Pagamento" COLUMN-LABEL "CEP Pagamento"
    FIELD  tta_cod_cx_post_pagto            AS CHARACTER FORMAT "x(20)" LABEL "Caixa Postal Pagamen" COLUMN-LABEL "Caixa Postal Pagamen"
    FIELD  ttv_rec_fiador_renegoc           AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" INITIAL ? &ENDIF
    INDEX tt_pssjrda_cobranca             
          tta_num_pessoa_jurid_cobr        ASCENDING
    INDEX tt_pssjrda_id                    IS PRIMARY UNIQUE
          tta_num_pessoa_jurid             ASCENDING
          tta_cod_id_feder                 ASCENDING
          tta_cod_pais_ext                 ASCENDING
    INDEX tt_pssjrda_id_previd_social     
          tta_cod_pais_ext                 ASCENDING
          tta_cod_id_previd_social         ASCENDING
    INDEX tt_pssjrda_matriz               
          tta_num_pessoa_jurid_matriz      ASCENDING
    INDEX tt_pssjrda_nom_pessoa_word      
          tta_nom_pessoa                   ASCENDING
    INDEX tt_pssjrda_pagto                
          tta_num_pessoa_jurid_pagto       ASCENDING
    INDEX tt_pssjrda_razao_social         
          tta_nom_pessoa                   ASCENDING
    INDEX tt_pssjrda_unid_federac         
          tta_cod_pais_ext                 ASCENDING
          tta_cod_unid_federac             ASCENDING.

DEF TEMP-TABLE tt_log_erros_renegoc_acr NO-UNDO
    FIELD  tta_cod_estab                    AS CHARACTER FORMAT "x(3)" LABEL "Estabelecimento" COLUMN-LABEL "Estab"
    FIELD  tta_num_renegoc_cobr_acr         AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 LABEL "Num. Renegoc" COLUMN-LABEL "Renegocia‡Æo"
    FIELD  tta_num_seq_item_renegoc_acr     AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 LABEL "Sequˆncia Item" COLUMN-LABEL "Sequˆncia Item"
    FIELD  tta_cdn_cliente                  AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Cliente" COLUMN-LABEL "Cliente"
    FIELD  tta_cod_espec_docto              AS CHARACTER FORMAT "x(3)" LABEL "Esp‚cie Documento" COLUMN-LABEL "Esp‚cie"
    FIELD  tta_cod_ser_docto                AS CHARACTER FORMAT "x(3)" LABEL "S‚rie Documento" COLUMN-LABEL "S‚rie"
    FIELD  tta_cod_tit_acr                  AS CHARACTER FORMAT "x(10)" LABEL "T¡tulo" COLUMN-LABEL "T¡tulo"
    FIELD  tta_cod_parcela                  AS CHARACTER FORMAT "x(02)" LABEL "Parcela" COLUMN-LABEL "Parc"
    FIELD  tta_cod_fiador                   AS CHARACTER FORMAT "x(8)" LABEL "Fiador" COLUMN-LABEL "Fiador"
    FIELD  tta_num_pessoa                   AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL ? LABEL "Pessoa" COLUMN-LABEL "Pessoa"
    FIELD  tta_num_mensagem                 AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 0 LABEL "Mensagem" COLUMN-LABEL "Mensagem"
    FIELD  ttv_des_msg                      AS CHARACTER FORMAT "x(40)".

/*** Defini‡Æo de Temp-tables utilizadas pelo c lculo dos vencimentos das novas parcelas ***/
DEF TEMP-TABLE tt-cond-pag NO-UNDO LIKE cond-pagto.

DEF TEMP-TABLE tt-cond-pag-parcela NO-UNDO
    FIELD cod-cond-pag    AS INTEGER
    FIELD parcela         AS INTEGER
    FIELD cod-ven-par     AS INTEGER
    FIELD prazos          AS INTEGER
    FIELD per-pg-dup      AS DECIMAL DECIMALS 10
    INDEX seq IS UNIQUE parcela.

/*** Defini‡Æo de temp-tables utilizadas na Integra‡Æo com CR do EMS 5 - Retorno dos t¡tulos ***/
def temp-table tt_leitura_tit_acr_proc_exp no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

/*** Defini‡Æo de temp-tables utilizadas na Integra‡Æo com o CR do EMS 2.00 - Retorno dos t¡tulos ***/
DEF TEMP-TABLE tt-selecao NO-UNDO
    FIELD cod-versao-integracao AS INTEGER   FORMAT '999'
    FIELD ep-codigo             LIKE empresa.ep-codigo
    FIELD cod-estabel           AS CHARACTER FORMAT 'x(03)'
    FIELD cod-emitente          AS INTEGER   FORMAT '>>>>>>>>9'
    FIELD nr-proc-exp           AS CHARACTER FORMAT 'x(12)'
    FIELD dt-emissao            AS DATE      FORMAT '99/99/9999'.

DEF TEMP-TABLE tt-titulo-aux NO-UNDO LIKE titulo 
    FIELD log-vincul-contrat-export AS LOGICAL INITIAL NO
    FIELD row-titulo                AS ROWID.

DEF TEMP-TABLE tt-retorno-erro-aux NO-UNDO /*verificar*/
    FIELD num-mensagem   AS INT  FORMAT '>>>>,>>9'
    FIELD des-mensagem   AS CHAR FORMAT 'x(52)'
    FIELD des-ajuda      AS CHAR FORMAT 'x(256)'
    FIELD cod-parameters AS CHAR FORMAT 'x(2000)'.

DEF TEMP-TABLE tt_log_erros_renegoc_acr_aux NO-UNDO LIKE tt_log_erros_renegoc_acr. 
    
DEF VAR l-ems-5 AS LOG NO-UNDO.
DEF VAR i-empresa LIKE param-global.empresa-prin NO-UNDO.
DEF VAR l-erro-integra5 AS LOG NO-UNDO.
DEF VAR l-ja-conec-emsuni AS LOG NO-UNDO.
DEF VAR l-ja-conec-emsbas AS LOG NO-UNDO.
DEF VAR l-ja-conec-emsfin AS LOG NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
def var c-cod-estab                    as character format "x(05)"          no-undo.
&ELSE
def var c-cod-estab                    as character format "x(3)"          no-undo.
&ENDIF
def var i-num-id-tit-acr               as integer format "9999999999"      no-undo.
def var d-dat-transacao                as date format "99/99/9999"         no-undo. 
def var i-num-seq-tit-acr              as integer format ">>>9"            no-undo. 
DEF VAR h_boacr711zv                   AS HANDLE                           NO-UNDO.

def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    .

def temp-table tt_log_erros_alter_tit_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          ttv_num_mensagem                 ascending
    .

def temp-table tt_alter_tit_acr_rat_desp_rec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria‡Æo" column-label "Tipo Apropria‡Æo"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_aprop_despes_recta    as integer format "9999999999" initial 0 label "Id Apropria‡Æo" column-label "Id Apropria‡Æo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    index tt_aprpdspa_id                   is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_num_id_aprop_despes_recta    ascending
    index tt_aprpdspa_token                is unique
          tta_cod_estab                    ascending
          tta_num_id_aprop_despes_recta    ascending
    .

def temp-table tt_alter_tit_acr_cobr_espec_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_num_id_cobr_especial_acr     as integer format "99999999" initial 0 label "Token Cobr Especial" column-label "Token Cobr Especial"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cartcred                 as character format "x(20)" label "C¢digo CartÆo" column-label "C¢digo CartÆo"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C¢d Pr‚-Autoriza‡Æo" column-label "C¢d Pr‚-Autoriza‡Æo"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade CartÆo" column-label "Validade CartÆo"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_log_alter_tip_cobr_acr       as logical format "Sim/NÆo" initial no label "Alter Tip Cobr" column-label "Alter Tip Cobr"
    field tta_ind_sit_tit_cobr_especial    as character format "X(15)" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field ttv_cod_comprov_vda              as character format "x(12)" label "Comprovante Venda" column-label "Comprovante Venda"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_val_tot_sdo_tit_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Val Total Parcelas" column-label "Val Total Parcelas"
    field tta_cod_autoriz_bco_emissor      as character format "x(6)" label "Autorizacao Venda" column-label "Autorizacao Venda"
    field tta_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_seq_tit_acr              ascending
    .

def temp-table tt_alter_tit_acr_impto_retid_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_impto_refer_tit_acr      as integer format ">>>>>9" initial 0 label "Impto Refer" column-label "Impto Refer"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_impto_refer_tit_acr      ascending
    .

def temp-table tt_alter_tit_acr_iva no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_seq                      ascending
    .

def temp-table tt_alter_tit_acr_ped_vda no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda"
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres"
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip"
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_ped_vda                  ascending
    .

def temp-table tt_alter_tit_acr_rateio no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_ind_tip_rat_tit_acr          as character format "X(12)" label "Tipo Rateio" column-label "Tipo Rateio"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_num_seq_aprop_ctbl_pend_acr  as integer format ">>>9" initial 0 label "Seq Aprop Pend" column-label "Seq Apro"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_log_impto_val_agreg          as logical format "Sim/NÆo" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
    .

def temp-table tt_tit_acr_num_id no-undo
    field tta_cod_estab                    as char format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as char format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as char format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as char format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as char format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_acr               as int  format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_cod_erro                     as char format "x(10)" column-label "Cod Erro"
    index tt_tit_acr                       is primary unique
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Sequˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .


def temp-table tt_alter_tit_acr_cheq no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data EmissÆo" column-label "Dt Emiss"
    field tta_dat_prev_apres_cheq_acr      as date format "99/99/9999" initial ? label "PrevisÆo Apresent" column-label "PrevisÆo Apresent"
    field tta_dat_prev_cr_cheq_acr         as date format "99/99/9999" initial ? label "PrevisÆo Cr‚dito" column-label "PrevisÆo Cr‚dito"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_log_cheq_terc                as logical format "Sim/NÆo" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field tta_ind_dest_cheq_acr            as character format "X(15)" initial "Dep¢sito" label "Destino Cheque" column-label "Destino Cheque"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren_bco           ascending
          tta_num_cheque                   ascending
    .

def temp-table tt_alter_tit_acr_comis_1 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% ComissÆo" column-label "% ComissÆo"
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis EmissÆo" column-label "% Comis EmissÆo"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/NÆo" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo ComissÆo" column-label "Tipo ComissÆo"
    field ttv_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo de ComissÆo" column-label "Tipo de ComissÆo"
    field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Pagto Comis" column-label "Lib Comis"
    field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext" column-label "Sit Comis Ext"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
    .

def temp-table tt_alter_tit_acr_base_5 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Altera‡Æo" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agˆncia Cobrança" column-label "Agˆncia Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T¡tulo Banco" column-label "Num T¡tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida‡Æo" column-label "Prev Liquida‡Æo"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran‡a" column-label "Tipo Cobran‡a"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endereço Cobran‡a" column-label "Endereço Cobran‡a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L¡quido" column-label "Vl L¡quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/NÆo" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran‡a" column-label "Obs Cobran‡a"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi‡Æo Pagto" column-label "Condi‡Æo Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Carˆncia" column-label "Dias Carˆncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/NÆo" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/NÆo" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/NÆo" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta‡Æo" column-label "Processo Exporta‡Æo"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending
    .

def temp-table tt_retorna_tit_acr_proc_exp no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_clien_matriz             as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Matriz" column-label "Cliente Matriz"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_num_fatur_acr                as integer format ">>>>,>>>,>>9" initial 0 label "Fatura" column-label "Fatura"
    field tta_num_id_movto_tit_acr_ult     as integer format ">>>>,>>9" initial 0 label "Token Ultimo Movimen" column-label "Token Ultimo Movimen"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_num_bord_acr                 as integer format ">>>>>9" initial 0 label "Border“" column-label "Border“"
    field tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field tta_ind_orig_tit_acr             as character format "X(8)" initial "ACREMS50" label "Origem Tit Cta Rec" column-label "Origem Tit Cta Rec"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Banc ria" column-label "Sit Banc ria"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran‡a" column-label "Tipo Cobran‡a"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida‡Æo" column-label "Prev Liquida‡Æo"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquida‡Æo" column-label "Ultima Liquida‡Æo"
    field tta_dat_ult_apurac_variac_val    as date format "99/99/9999" initial ? label "Ult Apur Variac Val" column-label "Ult Apur Variac Val"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquida‡Æo" column-label "Liquida‡Æo"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_dat_vencto_origin_tit_acr    as date format "99/99/9999" initial ? label "Dat Ven Orig Tit" column-label "Dat Ven Orig Tit"
    field tta_dat_ult_aprop_despes_financ  as date format "99/99/9999" initial ? label "‚lt Aprop Desp Fin" column-label "‚lt Aprop Desp Fin"
    field tta_dat_alter_portad             as date format "99/99/9999" initial ? label "Altera‡Æo Portador" column-label "Alter Portad"
    field tta_dat_indcao_perda_dedut       as date format "99/99/9999" initial ? label "Data Indica‡Æo" column-label "Data Indica‡Æo"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field ttv_cb1_calc_dat_term_carenc     as Integer format ">>>>>>>9"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T¡tulo" column-label "Vl Original T¡tulo"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L¡quido" column-label "Vl L¡quido"
    field tta_val_abat_negocdo             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Abat Negociado" column-label "Abat Negociado"
    field tta_val_desc_negocdo             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Desconto Negociado" column-label "Desconto Negociado"
    field tta_val_ajust_val_tit_acr        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Ajuste" column-label "Vl Ajuste"
    field tta_val_cm_tit_acr               as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_transf_estab             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saida Transf Estab" column-label "Saida Transf Estab"
    field tta_val_saida_subst_nf_dupl      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Saidas Subst" column-label "Saidas Subst"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_val_despes_financ            as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Despesa Financ" column-label "Val Desp Fin"
    field tta_val_impto_operac_financ      as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto Opera‡Æo" column-label "Imposto Opera‡Æo"
    field tta_log_tit_acr_cobr_bcia        as logical format "Sim/NÆo" initial no label "Cobr Banc ria" column-label "Cobr Banc ria"
    field tta_log_dupl_emitid              as logical format "Sim/NÆo" initial no label "Duplicata Emitida" column-label "Duplicata Emitida"
    field tta_log_emis_boleto              as logical format "Sim/NÆo" initial no label "EmissÆo Boleto" column-label "EmissÆo Boleto"
    field tta_log_aviso_db_emitid          as logical format "Sim/NÆo" initial no label "AD Emitido" column-label "AD Emitido"
    field tta_log_recibo_emitid            as logical format "Sim/NÆo" initial no label "Recibo Emitido" column-label "Recibo Emitido"
    field tta_log_npromis_emitid           as logical format "Sim/NÆo" initial no label "Nota Promis Emitida" column-label "Nota Promis Emit"
    field tta_log_tit_acr_estordo          as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field tta_log_tit_acr_destndo          as logical format "Sim/NÆo" initial no label "Destinado" column-label "Destinado"
    field tta_log_sdo_tit_acr              as logical format "Sim/NÆo" initial yes label "Tem Saldo" column-label "Tem Saldo"
    field tta_log_db_autom                 as logical format "Sim/NÆo" initial no label "D‚bito Autom tico" column-label "D‚bito Autom tico"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_estab_bord               as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T¡tulo Banco" column-label "Num T¡tulo Banco"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi‡Æo Pagamento" column-label "Condi‡Æo Pagamento"
    field tta_cod_contrat_vda              as character format "x(20)" label "Contrato Venda" column-label "Contrato Venda"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agˆncia Cobran‡a" column-label "Agˆncia Cobr"
    field tta_cod_movto_operac_financ      as character format "x(10)" label "C¢digo Movto" column-label "Cod Movto"
    field tta_cod_usuar_indcao_perda       as character format "x(12)" label "Usuario Indica‡Æo" column-label "Usuario Indica‡Æo"
    field tta_cod_indic_econ_juros         as character format "x(8)" label "Indic Econ Juros" column-label "Indic Econ Juros"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_qtd_dias_float_cobr          as decimal format ">>9" initial 0 label "Dias Float" column-label "Dias Float"
    field tta_qtd_dias_atraso_liquidac     as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field tta_hra_indcao_perda_dedut       as Character format "99:99:99" label "Hora Indica‡Æo" column-label "Hora Indica‡Æo"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran‡a" column-label "Obs Cobran‡a"
    field tta_des_observacao               as character format "x(2000)" label "Observa‡äes" column-label "Observa‡äes"
    field tta_log_integr_cfl_atlzdo        as logical format "Sim/NÆo" initial no label "CFL Atualizado" column-label "CFL Atualizado"
    field tta_cod_instruc_bcia_1_acr       as character format "x(4)" label "Instru‡Æo Bcia 1" column-label "Instru‡Æo 1"
    field tta_cod_instruc_bcia_2_acr       as character format "x(4)" label "Instru‡Æo Bcia 2" column-label "Instru‡Æo 2"
    field tta_val_abat_tit_acr_infor       as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Abatimento Informado" column-label "Abatimento Informado"
    field tta_log_tit_agrup_especial       as logical format "Sim/NÆo" initial no label "T¡tulo Agrupado" column-label "T¡tulo Agrupado"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta‡Æo" column-label "Processo Exporta‡Æo"
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito CSLL" column-label "Credito CSLL"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/NÆo" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_log_vincul_contrat_export    as logical format "Sim/NÆo" initial no
    field ttv_rec_tit_acr                  as &IF {&ROWID_READY} = YES &THEN ROWID &ELSE recid format ">>>>>>9" &ENDIF
    .

DEF TEMP-TABLE tt_retorna_tit_acr_proc_exp_aux NO-UNDO LIKE tt_retorna_tit_acr_proc_exp.


def temp-table tt_movto_comis_repres_export no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_num_seq_movto_comis          as integer format ">>>>,>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_cod_usuario                  as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_trans_origin             as date format "99/99/9999" initial ? label "Dt Trans Original" column-label "Dt Trans Original"
    field tta_dat_atualiz_movto_comis      as date format "99/99/9999" initial ? label "Atualiza‡Æo Movto" column-label "Atualiza‡Æo Movto"
    field tta_dat_gerac_movto              as date format "99/99/9999" initial ? label "Data Gera‡Æo Movto" column-label "Data Gera‡Æo Movto"
    field tta_hra_gerac_movto              as Character format "99:99:99" label "Hora Gera‡Æo Movto" column-label "Hora Gera‡Æo Movto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_ind_orig_movto_comis         as character format "X(10)" initial "Sistema" label "Origem Movto" column-label "Origem Movto"
    field tta_ind_sit_movto_comis          as character format "X(18)" initial "Liberado" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_ind_tip_movto                as character format "X(20)" label "Tipo Movimento" column-label "Tipo Movimento"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_ind_trans_comis              as character format "X(40)" label "Transa‡Æo ComissÆo" column-label "Transa‡Æo ComissÆo"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_val_movto_comis              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Movimento" column-label "Valor Movimento"
    field tta_log_movto_comis_envdo        as logical format "Sim/NÆo" initial no label "Enviado" column-label "Enviado"
    field tta_log_estorn_comis_atraso      as logical format "Sim/NÆo" initial no label "Estorno Atraso" column-label "Estorno Atraso"
    field tta_log_consid_movto_pagto       as logical format "Sim/NÆo" initial yes label "Considera Pagto" column-label "Considera Pagto"
    field tta_des_histor_movto_comis       as character format "x(40)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(5)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parcela"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_ind_trans_acr                as character format "X(29)" initial "Implanta‡Æo" label "Transa‡Æo" column-label "Transa‡Æo"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_cod_estab_tit_ap             as Character format "x(5)" label "Estabel APB" column-label "Estabel APB"
    field tta_num_id_tit_ap                as integer format "999999999" initial 0 label "Token T¡t AP" column-label "Token T¡t AP"
    field tta_num_id_tit_ap_prev           as integer format "9999999999" initial 0 label "Id Titulo APB Prev" column-label "Id Titulo APB Prev"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo Comis Externo" column-label "Tipo Comis Externo"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_num_proces_integr_comis      as integer format ">>>>,>>9" initial 0 label "Nro Proces Integr" column-label "Nro Proces Integr"
    field tta_cdn_motiv_movto_comis        as Integer format ">>>9" initial 0 label "C¢digo Motiv Movto" column-label "C¢digo Motiv"
    field tta_num_id_tit_ap_orig           as integer format "999999999" initial 0 label "ID Tit AP Orig" column-label "ID Tit AP Orig"
    field tta_num_id_tit_ap_prev_orig      as integer format "999999999" initial 0 label "ID Prev Ap Orig" column-label "ID Prev Ap Orig"
    field tta_cod_estab_tit_ap_orig        as character format "x(5)" label "Estab Tit AP Orig" column-label "Est Tit Orig"
    field tta_cod_estab_tit_ap_prev_orig   as character format "x(5)" label "Estab Prev AP Orig" column-label "Est Prev Orig"
    .

def temp-table tt_repres_tit_acr_export no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_comis_vda_estab          as character format "x(8)" label "ComissÆo Venda" column-label "ComissÆo Venda"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% ComissÆo" column-label "% ComissÆo"
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis EmissÆo" column-label "% Comis EmissÆo"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/NÆo" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_sit_comis_vda            as character format "X(10)" initial "Implantado" label "Situa‡Æo ComissÆo" column-label "Situa‡Æo ComissÆo"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo ComissÆo" column-label "Tipo ComissÆo"
    field tta_ind_forma_pagto_comis        as character format "X(15)" initial "Pagamento" label "Forma Pagamento" column-label "Forma Pagamento"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_val_perc_comis_renegoc       as decimal format ">>9.9999" decimals 4 initial 0 label "Percentual Comissao" column-label "Percentual Comissao"
    field tta_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo Comis Externo" column-label "Tipo Comis Externo"
    field tta_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Pagto ComissÆo" column-label "Lib Comis"
    field tta_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit ComissÆo Externa" column-label "Sit Comis Ex"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_log_sdo_tit_acr              as logical format "Sim/NÆo" initial yes label "Tem Saldo" column-label "Tem Saldo"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquida‡Æo" column-label "Ultima Liquida‡Æo"
    .


DEFINE TEMP-TABLE tt-erro-30683 NO-UNDO
        FIELD it-codigo   LIKE it-nota-fisc.it-codigo
        FIELD cod-estabel LIKE it-nota-fisc.cod-estabel
        FIELD serie       LIKE it-nota-fisc.serie      
        FIELD nr-nota-fis LIKE it-nota-fisc.nr-nota-fis.


define buffer b-emitente           for emitente.
define buffer b-proc-ped-ent-aux-2 for proc-ped-ent.
define buffer b-ped-ent            for ped-ent.
define buffer bf-ped-ent           for ped-ent.
DEFINE BUFFER bf-processo-exp      FOR processo-exp.
DEFINE BUFFER bf-nota-fiscal       FOR nota-fiscal.
DEFINE BUFFER bf-param-exp         FOR param-exp.

/************************* Defini‡Æo dos Preprocessadores ****************************/

&scoped-define CONDICAO processo-exp.cod-estabel >= c-cod-estabel and ~
                        processo-exp.nr-proc-exp >= c-nr-proc-exp 
&scoped-define FIRST-TABLE-IN-QUERY processo-exp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME processo-exp
&scoped-define OPEN-QUERY ~
  open query {&QUERY-NAME} for each {&TABLE-NAME} ~
       where {&CONDICAO} no-lock by processo-exp.cod-estabel by processo-exp.nr-proc-exp. 
 
&if defined(bf_comex206b-1) &then
    &if '{&bf_dis_versao_ems}' >= '2.07' &then                 
        &GLOBAL-DEFINE PARAM-EXP.CDN-MOTIVO param-exp.cdn-motivo
    &else               
        &GLOBAL-DEFINE PARAM-EXP.CDN-MOTIVO substring(param-exp.char-1,25,3)
    &endif
&endif

/*Integra‡Æo Mais Neg¢cios - Verifica‡Æo de fun‡Æo ativa*/
{dibo/bodi01076.i1}  /*v_log_integr_mng*/
DEFINE VARIABLE c-lit-help1              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lit-help2              AS CHARACTER   NO-UNDO.

/************************* Defini‡Æo das Temp-Table *********************************/

DEFINE temp-table tt-processo no-undo
       field cod-estabel   like processo-exp.cod-estabel
       field nr-proc-exp   like processo-exp.nr-proc-exp
       INDEX processo IS PRIMARY cod-estabel nr-proc-exp.

def temp-table tt-item-caixa no-undo
    field sigla-emb like item-caixa.sigla-emb
    field qt-item   like item-caixa.qt-item
    field nr-caixas as int extent 10
    index codigo 
          qt-item descending.

DEFINE TEMP-TABLE tt-proc-emb NO-UNDO LIKE proces-acond-item
        FIELD r-rowid  AS ROWID
        FIELD quantidade LIKE proc-ped-ent.quantidade.

def temp-table tt-proc-nota-fiscal no-undo
    field cod-estab-faturam like proc-nota-fiscal.cod-estab-faturam
    field serie             like proc-nota-fiscal.serie            
    field nr-nota-fis       like proc-nota-fiscal.nr-nota-fis      
    field log-nf-devolvid   like proc-nota-fiscal.log-nf-devolvid.
/* Registro de Exporta‡Æo */
define temp-table tt-reg-export-aux no-undo
        field cod-estabel        as char format "x(03)"
        field nr-proc-exp        as char format "x(12)"
        field nr-re-ems          as int  format ">>>,>>>,>>9"
        field nr-re-siscomex     as char format "x(15)"
        field dat-reg-export     as date format "99/99/9999"
        field sit-re             as char format "x(10)"
        field dat-envio          as date format "99/99/9999"
        field cod-solicit-despa  as char format "x(20)"
        field dat-solicit-despa  as date format "99/99/9999"
        field dat-averb          as date format "99/99/9999"
        field r-rowid            as rowid
     index ch-id is primary
           nr-re-ems.

DEFINE TEMP-TABLE tt-valores no-undo
       field cod-estabel    like processo-exp.cod-estabel 
       field nr-proc-exp    like processo-exp.nr-proc-exp
       field cod-itiner     like processo-exp.cod-itiner
       field sigla-moeda    like moeda.sigla
       field vl-tot-liq     as decimal format ">>,>>>,>>>,>>9.99"
       field vl-tot-desp    as decimal format ">>,>>>,>>>,>>9.99"
       field vl-incoterm    as decimal format ">>,>>>,>>>,>>9.99"
       field peso-liq-tot   as decimal format ">>>,>>>,>>9.99"
       field peso-bruto-tot as decimal format ">>>,>>>,>>9.99"
       field volume-tot     as decimal format ">>>,>>>,>>9.99"
       field desp-desc      as decimal format ">>>,>>>,>>9.99"       
       INDEX valor IS PRIMARY UNIQUE cod-estabel nr-proc-exp ASCENDING.    

DEFINE TEMP-TABLE tt-del-historico-proc-exp no-undo like processo-exp
    field r-rowid        as rowid.

def temp-table tt-ped-venda no-undo like ped-venda 
    field r-rowid  as rowid.
      
&if defined(bf_comex206b-1) &then

    def temp-table tt-ped-item-aux no-undo
        field nome-abrev   like ped-item.nome-abrev
        field nr-pedcli    like ped-item.nr-pedcli
        field nr-sequencia like ped-item.nr-sequencia
        field it-codigo    like ped-item.it-codigo
        field cod-refer    like ped-item.cod-refer
        field cod-estabel  like processo-exp.cod-estabel
        field nr-proc-exp  like processo-exp.nr-proc-exp
        index chave is primary unique nome-abrev  nr-pedcli  nr-sequencia it-codigo
                                      cod-refer  cod-estabel nr-proc-exp.
    
    def temp-table tt-ped-venda-aux no-undo
        field nr-pedido like ped-venda.nr-pedido
        field cod-estabel like processo-exp.cod-estabel
        field nr-proc-exp  like processo-exp.nr-proc-exp
        index chave is primary unique nr-pedido cod-estabel nr-proc-exp.

&endif

 
def stream s-log.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

{include/boini.i}
{cxbo/bocx185.i RowObject}
{cxbo/bocx185.i tt-processo-exp-orig}
{cxbo/bocx185.i2}
{cxbo/bocx115.i tt-itinerario}

&if defined(bf_dis_proc_ent) &then
   {include/i-epc200.i "bocx185"}
&endif

DEF TEMP-TABLE tt-bo-erro-5 NO-UNDO LIKE tt-bo-erro.
def temp-table tt-bo-erro2 no-undo like tt-bo-erro.

{utp/ut-glob.i}
{method/dbotterr.i}
{dibo/bodi154.i RowPedItem}  
{dibo/bodi159.i2 "RowParam"} 

def temp-table RowPedEnt no-undo like ped-ent 
   field r-rowid as rowid.

def var h-bocx195     as handle  no-undo.

def temp-table tt-ped-ent-novo no-undo like ped-ent
   field nr-sequencia-nova like ped-ent.nr-sequencia   
   field nr-entrega-nova   like ped-ent.nr-entrega       
   field r-rowid           as  rowid.

def temp-table tt-ped-ent-orig no-undo like ped-ent
   field qt-pedida-proc like proc-ped-ent.quantidade[1]
   field r-rowid as rowid.

def temp-table tt-ped-item-novo no-undo like ped-item
   field nr-sequencia-nova like ped-item.nr-sequencia
   field r-rowid           as rowid.

def temp-table tt-ped-item-orig no-undo like ped-item
   field r-rowid as rowid.

def temp-table tt-proc-ped-ent no-undo like proc-ped-ent
   field r-rowid as rowid.    
   
def temp-table tt-proc-ped-ent-aux no-undo like proc-ped-ent
   field r-rowid as rowid.    
   
def temp-table tt-proc-ped-ent-aux1 no-undo like proc-ped-ent
   field r-rowid as rowid.    
   
def temp-table tt-bo-erro-aux no-undo like tt-bo-erro.

DEF TEMP-TABLE tt-ped-msg NO-UNDO
    FIELD nr-pedcli AS CHAR. 

/************************* P R O C E D U R E S *************************************/

procedure setConstraint1:
 
end procedure.

procedure setConstraint2:    
    def input parameter p-cod-estabel like processo-exp.cod-estabel no-undo.
    def input parameter p-nr-proc-exp like processo-exp.nr-proc-exp no-undo.
    assign c-cod-estabel  = p-cod-estabel
           c-nr-proc-exp  = p-nr-proc-exp.
end procedure.

procedure setConstraint3:    
    def input parameter p-cod-estabel-ini like processo-exp.cod-estabel no-undo.
    def input parameter p-cod-estabel-fim like processo-exp.cod-estabel no-undo.
    assign c-cod-estabel-ini  = p-cod-estabel-ini
           c-cod-estabel-fim  = p-cod-estabel-fim.
end procedure.

procedure setConstraint4:    
    def input parameter p-nr-proc-exp-ini like processo-exp.nr-proc-exp no-undo.
    def input parameter p-nr-proc-exp-fim like processo-exp.nr-proc-exp no-undo.
    assign c-proc-exp-ini  = p-nr-proc-exp-ini
           c-proc-exp-fim  = p-nr-proc-exp-fim.
end procedure.

procedure setConstraint5:    
    def input parameter p-cod-estabel-ini like processo-exp.cod-estabel no-undo.
    def input parameter p-cod-estabel-fim like processo-exp.cod-estabel no-undo.
    def input parameter p-nr-proc-exp-ini like processo-exp.nr-proc-exp no-undo.
    def input parameter p-nr-proc-exp-fim like processo-exp.nr-proc-exp no-undo.
    def input parameter p-ordena  as int no-undo.
    assign c-cod-estabel-ini  = p-cod-estabel-ini
           c-cod-estabel-fim  = p-cod-estabel-fim
           c-nr-proc-exp-ini  = p-nr-proc-exp-ini
           c-nr-proc-exp-fim  = p-nr-proc-exp-fim
           i-ordena           = p-ordena.
end procedure.

PROCEDURE setConstraint6:
    /*
    Purpose:     Passagem de parƒmetros para a abertura das querys
    Parameters:  Input p-cod-estabel-ini  - C¢digo do Estabelecimento - CHARACTER
                 Input p-cod-estabel-fim  - C¢digo do Estabelecimento - CHARACTER
                 Input p-dt-data-impl-ini - Data de Implanta‡Æo       - DATA
                 Input p-dt-data-impl-fim - Data de Implanta‡Æo       - DATA
    
    
    */
    DEFINE INPUT PARAMETER p-cod-estabel-ini  LIKE processo-exp.cod-estabel            NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim  LIKE processo-exp.cod-estabel            NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-data-impl-ini LIKE processo-exp.dat-impl-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-data-impl-fim LIKE processo-exp.dat-impl-proces-export NO-UNDO.

    ASSIGN  c-cod-estabel-ini  = p-cod-estabel-ini 
            c-cod-estabel-fim  = p-cod-estabel-fim 
            d-dt-data-impl-ini = p-dt-data-impl-ini
            d-dt-data-impl-fim = p-dt-data-impl-fim.
	RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE setConstraint7:
    /*
    Purpose:     Passagem de parƒmetros para a abertura das querys
    Parameters:  Input p-nr-proc-exp-ini  - N£mero do Processo - CHARACTER
                 Input p-nr-proc-exp-fim  - N£mero do Processo - CHARACTER
                 Input p-dt-data-impl-ini - Data de Implanta‡Æo       - DATA
                 Input p-dt-data-impl-fim - Data de Implanta‡Æo       - DATA
    
    
    */
    DEFINE INPUT PARAMETER p-nr-proc-exp-ini  LIKE processo-exp.nr-proc-exp            NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-exp-fim  LIKE processo-exp.nr-proc-exp            NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-data-impl-ini LIKE processo-exp.dat-impl-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-data-impl-fim LIKE processo-exp.dat-impl-proces-export NO-UNDO.

    ASSIGN  c-proc-exp-ini  = p-nr-proc-exp-ini 
            c-proc-exp-fim  = p-nr-proc-exp-fim 
            d-dt-data-impl-ini = p-dt-data-impl-ini
            d-dt-data-impl-fim = p-dt-data-impl-fim.

	RETURN "OK":U.
END PROCEDURE.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock {&v9indrep}.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where &IF ("&EMSDBTYPE") <> "progress" &THEN
                                                                      ((processo-exp.cod-estabel > c-cod-estabel) OR 
                                                                      (processo-exp.cod-estabel = c-cod-estabel)) AND
                                                                      ((processo-exp.nr-proc-exp > c-nr-proc-exp) OR
                                                                      (processo-exp.nr-proc-exp = c-nr-proc-exp))
                                                                      no-lock by processo-exp.cod-estabel by processo-exp.nr-proc-exp.  
                                                                  &ELSE
                                                                      processo-exp.cod-estabel >= c-cod-estabel and 
                                                                      processo-exp.nr-proc-exp >= c-nr-proc-exp 
                                                                      no-lock by processo-exp.cod-estabel by processo-exp.nr-proc-exp {&v9indrep}.  
                                                                  &endif
         when 3 THEN DO :                                                                                                                                                                                      
         
             open query {&QUERY-NAME} for each {&TABLE-NAME} where &IF ("&EMSDBTYPE") <> "progress" &THEN                                                                                                 
                                                                       ((processo-exp.cod-estabel > c-cod-estabel-ini) OR                                                                                 
                                                                       (processo-exp.cod-estabel = c-cod-estabel-ini)) AND                                                                                
                                                                       ((processo-exp.cod-estabel < c-cod-estabel-fim) OR                                                                                 
                                                                       (processo-exp.cod-estabel = c-cod-estabel-fim)) NO-LOCK                                                                       
                                                                    by  processo-exp.cod-estabel by processo-exp.nr-proc-exp.
                                                                   &ELSE                                                                                                                                       
                                                                      processo-exp.cod-estabel >= c-cod-estabel-ini and                                                                                       
                                                                      processo-exp.cod-estabel <= c-cod-estabel-fim no-lock                                                                                   
                                                                      by processo-exp.cod-estabel by processo-exp.nr-proc-exp {&v9indrep}.
                                                                    &endif 
        END.
       when 4 then                                                                                                                                                                                         
           open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE &IF ("&EMSDBTYPE") <> "progress" &THEN                                                                                       
                                                                    ((processo-exp.nr-proc-exp > c-proc-exp-ini) OR                                                                           
                                                                    (processo-exp.nr-proc-exp = c-proc-exp-ini)) AND                                                                          
                                                                    ((processo-exp.nr-proc-exp < c-proc-exp-fim) OR                                                                           
                                                                    (processo-exp.nr-proc-exp = c-proc-exp-fim)) no-lock                                                                      
                                                                    by processo-exp.nr-proc-exp.
                                                                  &ELSE                                                                                                                                    
                                                                    processo-exp.nr-proc-exp >= c-proc-exp-ini and                                                                                         
                                                                    processo-exp.nr-proc-exp <= c-proc-exp-fim no-lock                                                                                     
                                                                    by processo-exp.nr-proc-exp {&v9indrep}.                                                                                                           
                                                                  &endif                                                                                                                                  
        when 5 then do:                                                                                                                                                                        
            if i-ordena = 1 then do:                                                                                                                                                           
                if c-cod-estabel-ini = c-cod-estabel-fim then                                                                                                                                  
                                                                                                                                                                                               
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                                                                                      
                                                      processo-exp.cod-estabel = c-cod-estabel-ini  AND                                                                                        
                                                      &IF ("&EMSDBTYPE") <> "progress" &THEN     
                                                          ((processo-exp.nr-proc-exp > c-nr-proc-exp-ini) OR                                                                                   
                                                          (processo-exp.nr-proc-exp = c-nr-proc-exp-ini)) and                                                                                  
                                                          ((processo-exp.nr-proc-exp < c-nr-proc-exp-fim) OR                                                                                   
                                                          (processo-exp.nr-proc-exp = c-nr-proc-exp-fim))
                                                          NO-LOCK use-index pk-proc-exp.                                                                                                       
                                                      &ELSE                                                                                                                                    
                                                          processo-exp.nr-proc-exp >= c-nr-proc-exp-ini and                                                                                    
                                                          processo-exp.nr-proc-exp <= c-nr-proc-exp-fim                                                                                        
                                                          NO-LOCK use-index pk-proc-exp {&v9indrep}.
                                                      &endif                                                                                                                                   
                                                                                                                                                                                               
             else do:                                                                                                                                                                             
                 if c-nr-proc-exp-ini = c-nr-proc-exp-fim then                                                                                                                         
                     open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                                                                             
                                                       processo-exp.nr-proc-exp  = c-nr-proc-exp-ini AND                                                                               
                                                      &IF ("&EMSDBTYPE") <> "progress" &THEN                                                                                           
                                                           ((processo-exp.cod-estabel > c-cod-estabel-ini)  OR                                                                         
                                                           (processo-exp.cod-estabel = c-cod-estabel-ini))  and                                                                        
                                                           ((processo-exp.cod-estabel < c-cod-estabel-fim)  OR                                                                         
                                                           (processo-exp.cod-estabel = c-cod-estabel-fim))
                                                           NO-LOCK use-index pk-proc-exp.                                                                                              
                                                       &ELSE                                                                                                                           
                                                           processo-exp.cod-estabel >= c-cod-estabel-ini  and                                                                          
                                                           processo-exp.cod-estabel <= c-cod-estabel-fim                                                                               
                                                           NO-LOCK use-index pk-proc-exp {&v9indrep}.                                                                                   
                                                      &endif                                                                                                                                      
                   else                                                                                                                                                                                    
                       open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                                                                                               
                                                         &IF ("&EMSDBTYPE") <> "progress" &THEN   
                                                             ((processo-exp.cod-estabel > c-cod-estabel-ini)  OR  
                                                             (processo-exp.cod-estabel = c-cod-estabel-ini))  and                                                                                             
                                                             ((processo-exp.cod-estabel < c-cod-estabel-fim)  OR                                                                                              
                                                             (processo-exp.cod-estabel = c-cod-estabel-fim))  and                                                                                             
                                                             ((processo-exp.nr-proc-exp > c-nr-proc-exp-ini)  OR                                                                                              
                                                             (processo-exp.nr-proc-exp = c-nr-proc-exp-ini))  and                                                                                             
                                                             ((processo-exp.nr-proc-exp < c-nr-proc-exp-fim)  OR                                                                                              
                                                             (processo-exp.nr-proc-exp = c-nr-proc-exp-fim)) 
                                                             NO-LOCK use-index pk-proc-exp.
                                                       &ELSE                                                                                                                                             
                                                             processo-exp.cod-estabel >= c-cod-estabel-ini  and                                                                                            
                                                             processo-exp.cod-estabel <= c-cod-estabel-fim  and                                                                                            
                                                             processo-exp.nr-proc-exp >= c-nr-proc-exp-ini  and                                                                                            
                                                             processo-exp.nr-proc-exp <= c-nr-proc-exp-fim                                                                                                 
                                                             NO-LOCK use-index pk-proc-exp {&v9indrep}.                                                                                                     
                                                       &endif                                                                                                                                            
                end.                                                                                                                                                                                        
            end.                                                                                                                                                                                            
          if i-ordena = 2 then do:                                                                                                                                                                     
              if c-nr-proc-exp-ini = c-nr-proc-exp-fim then                                                                                                                                            
                  open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                                                                                                
                                                     processo-exp.nr-proc-exp = c-nr-proc-exp-ini  and                                                                                                 
                                                     &IF ("&EMSDBTYPE") <> "progress" &THEN                                                                                                            
                                                         ((processo-exp.cod-estabel > c-cod-estabel-ini) OR                                                                                                 
                                                         (processo-exp.cod-estabel = c-cod-estabel-ini)) and                                                                                                
                                                         ((processo-exp.cod-estabel < c-cod-estabel-fim) OR                                                                                                 
                                                         (processo-exp.cod-estabel = c-cod-estabel-fim)) 
                                                         NO-LOCK use-index ch-proc-exp.
                                                     &ELSE                                                                                                                                            
                                                         processo-exp.cod-estabel >= c-cod-estabel-ini and                                                                                              
                                                         processo-exp.cod-estabel <= c-cod-estabel-fim                                                                                                  
                                                         NO-LOCK use-index ch-proc-exp {&v9indrep}.                                                                                                        
                                                     &endif                                                                                                                                             
               else do:                                                                                                                                                                                
                   if c-cod-estabel-ini = c-cod-estabel-fim then                                                                                                                                       
                        open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                                                                                          
                                                          processo-exp.cod-estabel  = c-cod-estabel-ini AND                                                                                            
                                                          &IF ("&EMSDBTYPE") <> "progress" &THEN                                                                                                         
                                                              ((processo-exp.nr-proc-exp > c-nr-proc-exp-ini) OR                                                                                          
                                                              (processo-exp.nr-proc-exp = c-nr-proc-exp-ini)) and                                                                                         
                                                              ((processo-exp.nr-proc-exp < c-nr-proc-exp-fim) OR                                                                                          
                                                              (processo-exp.nr-proc-exp = c-nr-proc-exp-fim)) 
                                                              NO-LOCK use-index ch-proc-exp.
                                                           &ELSE                                                                                                                                       
                                                              processo-exp.nr-proc-exp >= c-nr-proc-exp-ini and                                                                                        
                                                              processo-exp.nr-proc-exp <= c-nr-proc-exp-fim                                                                                             
                                                              NO-LOCK use-index ch-proc-exp {&v9indrep}.
                                                           &endif                                                                                                                                   
                     else                                                                                                                                                                            
                          open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                                                                                      
                                                            &IF ("&EMSDBTYPE") <> "progress" &THEN                                                             
                                                                ((processo-exp.nr-proc-exp > c-nr-proc-exp-ini) OR 
                                                                (processo-exp.nr-proc-exp = c-nr-proc-exp-ini)) and                                                                                       
                                                                ((processo-exp.nr-proc-exp < c-nr-proc-exp-fim) OR                                                                                        
                                                                (processo-exp.nr-proc-exp = c-nr-proc-exp-fim)) and                                                                                       
                                                                ((processo-exp.cod-estabel > c-cod-estabel-ini) OR                                                                                        
                                                                (processo-exp.cod-estabel = c-cod-estabel-ini)) and                                                                                       
                                                                ((processo-exp.cod-estabel < c-cod-estabel-fim) OR                                                                                        
                                                                (processo-exp.cod-estabel = c-cod-estabel-fim))
                                                                NO-LOCK use-index ch-proc-exp.              
                                                           &ELSE                                                                                                                                            
                                                                processo-exp.nr-proc-exp >= c-nr-proc-exp-ini and                                                                                             
                                                                processo-exp.nr-proc-exp <= c-nr-proc-exp-fim and                                                                                             
                                                                processo-exp.cod-estabel >= c-cod-estabel-ini and                                                                                             
                                                                processo-exp.cod-estabel <= c-cod-estabel-fim                                                                                                 
                                                                NO-LOCK use-index ch-proc-exp {&v9indrep}.                                                                                                       
                                                           &endif                                                                                                                                          
               end.                                                                                                                                                                                         
           end. 
       end. 
       when 6 THEN DO :  
            open query {&QUERY-NAME} for each {&TABLE-NAME} where &IF ("&EMSDBTYPE") <> "progress" &THEN                                                                                                 
                                                                       ((processo-exp.cod-estabel > c-cod-estabel-ini) OR                                                                                 
                                                                       (processo-exp.cod-estabel = c-cod-estabel-ini)) AND                                                                                
                                                                       ((processo-exp.cod-estabel < c-cod-estabel-fim) OR                                                                                 
                                                                       (processo-exp.cod-estabel = c-cod-estabel-fim)) AND 
                                                                       ((processo-exp.dat-impl-proces-export > d-dt-data-impl-ini) OR
                                                                        (processo-exp.dat-impl-proces-export = d-dt-data-impl-ini)) AND
                                                                       ((processo-exp.dat-impl-proces-export < d-dt-data-impl-fim) OR
                                                                        (processo-exp.dat-impl-proces-export = d-dt-data-impl-fim)) NO-LOCK
                                                                    by  processo-exp.cod-estabel by processo-exp.nr-proc-exp INDEXED-REPOSITION.
                                                                   &ELSE                                                                                                                                       
                                                                      processo-exp.cod-estabel >= c-cod-estabel-ini and                                                                                       
                                                                      processo-exp.cod-estabel <= c-cod-estabel-fim AND
                                                                      processo-exp.dat-impl-proces-export >= d-dt-data-impl-ini  
                                                                      processo-exp.dat-impl-proces-export <= d-dt-data-impl-fim  NO-LOCK
                                                                      by processo-exp.cod-estabel by processo-exp.nr-proc-exp  {&v9indrep}.
                                                                    &endif 
        END.
       when 7 THEN DO:                                                                                                                                                                                                           
           open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE &IF ("&EMSDBTYPE") <> "progress" &THEN
                                                                    ((processo-exp.nr-proc-exp > c-proc-exp-ini) OR
                                                                    (processo-exp.nr-proc-exp = c-proc-exp-ini)) AND
                                                                    ((processo-exp.nr-proc-exp < c-proc-exp-fim) OR
                                                                    (processo-exp.nr-proc-exp = c-proc-exp-fim)) AND
                                                                    ((processo-exp.dat-impl-proces-export > d-dt-data-impl-ini) OR
                                                                    (processo-exp.dat-impl-proces-export = d-dt-data-impl-ini)) AND
                                                                    ((processo-exp.dat-impl-proces-export < d-dt-data-impl-fim) OR
                                                                    (processo-exp.dat-impl-proces-export = d-dt-data-impl-fim)) no-lock
                                                                    by processo-exp.nr-proc-exp BY processo-exp.cod-estabel.
                                                                  &ELSE                                                                                                                                    
                                                                    processo-exp.nr-proc-exp >= c-proc-exp-ini and                                                                                         
                                                                    processo-exp.nr-proc-exp <= c-proc-exp-fim 
                                                                    processo-exp.dat-impl-proces-export >= d-dt-data-impl-ini  
                                                                    processo-exp.dat-impl-proces-export <= d-dt-data-impl-fim  no-lock 
                                                                    by processo-exp.nr-proc-exp BY processo-exp.cod-estabel {&v9indrep}.                                                                                                           
                                                                  &endif
           END.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
/*{include/boexecre.i}*/ /* executeCreate customizada abaixo */
/*{include/boexeupt.i}*/ /* executeUpdate customizada abaixo */
/*{include/boexedel.i}*/ /* executeDelete customizada abaixo */
/*{include/bovalupt.i}*/ /* validateUpdate customizada abaixo */
/*{include/bovaldel.i}*/ /* validateDelete customizada abaixo */
def new global shared var c-seg-usuario as char format "x(12)" no-undo.

procedure findPk_proc_exp:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-nr-proc-exp as char no-undo.
    def output parameter c-return     as char no-undo.

    find first processo-exp no-lock
         where processo-exp.cod-estabel = c-cod-estabel 
         and   processo-exp.nr-proc-exp = c-nr-proc-exp 
     use-index pk-proc-exp  no-error.
    if not avail {&TABLE-NAME} then do:
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */ 
        {utp/ut-table.i mgcex processo-exp 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
        run setCurrent.
    end.
    run endMethod ("find").
end procedure.

PROCEDURE find_ProcessoExp_EMS5:
/*------------------------------------------------------------------------------
  Recebe a chave do t¡tulo (prgfin\acr\acr040ea.p) e o processo de exporta‡Æo informado na tela do prgfin\acr\acr040aa.r.  
  Esse m‚todo deve localizar a nota fiscal e retornar se achou o processo de exporta‡Æo.
------------------------------------------------------------------------------*/

    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    DEF OUTPUT PARAM p-achou-proc    AS LOG     NO-UNDO.

    /*localizar a nota pelo titulo */

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = p-cod-estabel
           AND nota-fiscal.serie = p-serie
           AND nota-fiscal.nr-nota-fis = p-nr-docto NO-ERROR.

    IF NOT AVAIL nota-fiscal THEN
        RETURN "NOK".
    
    if can-find(first funcao 
                where funcao.cd-funcao = "spp-mex-alter-estab":U
                  and funcao.ativo     = yes) then do:
          find first processo-exp
               where processo-exp.cod-estabel = &IF '{&BF_MAT_VERSAO_EMS}' >= '2.071' &THEN
                                                 nota-fiscal.cod-estab-proces-export
                                                 &else
                                                 substring(nota-fiscal.char-1,124,3)
                                                 &endif
                 and processo-exp.nr-proc-exp = nota-fiscal.nr-proc-exp no-lock no-error.
    end.
    else do:
          find first processo-exp
               where processo-exp.cod-estabel = nota-fiscal.cod-estabel
                 and processo-exp.nr-proc-exp = nota-fiscal.nr-proc-exp no-lock no-error.
    end.
    
    ASSIGN p-achou-proc = AVAIL processo-exp.
    
END PROCEDURE.

PROCEDURE findPk_proc_exp_NF:
    /*-----------------------------------------------------------------------------
      Recebe o processo de exporta‡Æo e a chave da nota fiscal para localizar na nota fiscal 
      o estabelecimento correspondente ao processo de exporta‡Æo.
      Caso nao encontrar o processo de exporta‡Æo, retorna mensagem de erro padrao do EMS.
    ------------------------------------------------------------------------------*/

    run startMethod ("find").
    def input parameter p-cod-estabel as char no-undo. /* Estabelecimento da nota fiscal */
    def input parameter p-nr-proc-exp as char no-undo. /* Processo de Exporta‡Æo */
    def input parameter p-serie       as char no-undo. /* S‚rie da nota fiscal */
    def input parameter p-nr-docto    as char no-undo. /* N£mero da nota fiscal */
    def output parameter c-return     as char no-undo.

    FIND FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = p-cod-estabel
        AND   nota-fiscal.serie       = p-serie
        AND   nota-fiscal.nr-nota-fis = p-nr-docto NO-ERROR.
    IF  AVAIL nota-fiscal THEN
        find first processo-exp NO-LOCK
            where processo-exp.cod-estabel = nota-fiscal.cod-estab-proces-export
            and   processo-exp.nr-proc-exp = nota-fiscal.nr-proc-exp no-error.
    
    if  not avail processo-exp then do:
        {utp/ut-table.i mgcex processo-exp 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
        run setCurrent.
    end.
    run endMethod ("find").
END PROCEDURE.

PROCEDURE findCh_agente_cia:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-agente-cia as integer format ">>>>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-agente-cia = p-cod-agente-cia no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-agente-cia 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_apolice:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-nr-apolice   as char format "x(20)" no-undo.
    def input parameter p-nr-averbacao as char format "x(20)" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.nr-apolice   = p-nr-apolice
         and   processo-exp.nr-averbacao = p-nr-averbacao no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp nr-apolice 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_armador:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-armador as integer format ">>>>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-armador = p-cod-armador no-error.
    if not avail processo-exp  then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-liter.i mgcex processo-exp  cod-armador 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_consign:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-consign as integer format ">>>>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-consign = p-cod-consign no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex cod-consign 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_dt_embarque:
    /* ******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ******************************************** */

    def input parameter p-dt-embarque as date no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.dt-embarque = p-dt-embarque no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp dt-embarque 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_idioma:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-idioma as char format "x(12)" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-idioma = p-cod-idioma no-error.
    if not avail {&TABLE-NAME} then do:        
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-idioma 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_importador:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-emitente like processo-exp.cod-emitente no-undo.
    def input parameter p-cod-pais     like pais.cod-pais             no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-emitente = p-cod-emitente
         and   processo-exp.cod-pais     = p-cod-pais no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-emitente 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_incoterm:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-incoterm as char format "x(3)" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-incoterm = p-cod-incoterm no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-incoterm 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_invoice:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input  parameter p-nr-invoice as char format "x(12)" no-undo.
    def input  parameter p-nr-saque   as char format "x(12)" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.nr-invoice = p-nr-invoice
         and   processo-exp.nr-saque   = p-nr-saque no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp nr-invoice 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

procedure BeforeCreateRecord:

    find first param-exp no-lock
         where param-exp.cod-estabel = RowObject.cod-estabel no-error.

    if avail param-exp then do:
        &if defined(bf_dis_proc_ent) &then
            for each  tt-epc 
                where tt-epc.cod-event = "BEFORE-CREATE-RECORD": 
                delete tt-epc. 
            end.

            /*** Criacao do registro para temp-table tt-epc ***/
            {include/i-epc200.i2 &CodEvent       = '"BEFORE-CREATE-RECORD"'
                                 &CodParameter   = '"Rowid_param-exp"'
                                 &ValueParameter = string(rowid(param-exp))}
                                
            /*** Chamada do programa EPC ***/
            {include/i-epc201.i "BEFORE-CREATE-RECORD"}

            FIND FIRST tt-epc NO-LOCK 
                 WHERE tt-epc.cod-event     = "Before-Create-Record" 
                 AND   tt-epc.cod-parameter = "NUMBER-NEXT" NO-ERROR.
            IF  AVAILABLE tt-epc THEN
                assign RowObject.nr-proc-exp = tt-epc.val-parameter.
        &endif
    end.
end procedure.

PROCEDURE findCh_itiner:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-itiner as integer format ">>,>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-itiner = p-cod-itiner no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro =  i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-itiner 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_notif:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-notif as integer format ">>>>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-notif = p-cod-notif no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-notif 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_seguradora:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-seguradora as integer format ">>>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-seguradora = p-cod-seguradora no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex  cod-seguradora 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_transp-int:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-transp-init as integer format ">>>>9" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-transp-int = p-cod-transp-init no-error.
    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex processo-exp cod-transp-init 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 56,
                           input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findCh_via_transp:
    /*******************************************
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    ********************************************/
    def input parameter p-cod-via-transp as integer format "99" no-undo.
    def output parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    
    find first processo-exp no-lock
         where processo-exp.cod-via-transp = p-cod-via-transp no-error.
    if not avail {&TABLE-NAME} then do:
       assign i-seq-erro = i-seq-erro + 1.
       /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
          pre-processador em chamada de includes */
       {utp/ut-field.i mgcex processo-exp cod-via-transp 1}
       run utp/ut-msgs.p (input "msg":U,
                          input 56,
                          input return-value).
    end.
    else run setCurrent.
END PROCEDURE.

PROCEDURE findRowidShow:
    /*  Localiza registro pelo rowid e nao retorna o registro.*/
    def input parameter r-chave as rowid no-undo.
    def output parameter table for RowObject.
    find first {&TABLE-NAME} no-lock 
         where rowid({&TABLE-NAME}) = r-chave no-error.
    if avail {&TABLE-NAME} then
        run setCurrent.
END PROCEDURE.

PROCEDURE validateFields:   
    def input parameter l-tipo-trans as log. /* Inclusão/Modifica‡Æo */   
     
    run exp/exapi003.p (input  table rowObject, 
                        input  l-tipo-trans, 
                        output table tt-bo-erro).                                              
    find last tt-bo-erro no-error.
    if avail tt-bo-erro then
       i-seq-erro = tt-bo-erro.i-sequen.
       
    run validateNotif (input rowObject.cod-notif). 

    if RowObject.cod-notif2 > 0 then do:
        IF NOT CAN-FIND(FIRST emitente
                        WHERE emitente.cod-emitente = RowObject.cod-notif2) THEN DO:
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Notificado_2 * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
    end.
    IF  RowObject.cod-consign > 0 THEN do:
        IF NOT CAN-FIND(FIRST emitente
                        WHERE emitente.cod-emitente = RowObject.cod-consign) THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Consignat rio" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        END.
    end.
    if RowObject.cdn-emit-final > 0 then do:
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = RowObject.cdn-emit-final no-error.
        if not avail emitente or emitente.identific = 2 then do:
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Cliente_Final * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
    end.
    run validateCondPagto.

    IF  RowObject.cod-decl-padrao <> 0 THEN
        IF NOT CAN-FIND(FIRST decl-padrao
                        WHERE decl-padrao.de-codigo = RowObject.cod-decl-padrao) THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Declara‡Æo_PadrÆo" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.

    IF  RowObject.cdn-pto-transb[1] <> 0 THEN
        IF NOT CAN-FIND(FIRST pto-contr
                        WHERE pto-contr.cod-pto-contr = RowObject.cdn-pto-transb[1]) THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Local_Transbordo_1" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.

    IF  RowObject.cdn-pto-transb[2] <> 0 THEN
        IF NOT CAN-FIND(FIRST pto-contr
                        WHERE pto-contr.cod-pto-contr = RowObject.cdn-pto-transb[2]) THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Local_Transbordo_2" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        END. 

    IF  RowObject.cdn-pto-transb[3] <> 0 THEN
        IF NOT CAN-FIND(FIRST pto-contr
                        WHERE pto-contr.cod-pto-contr = RowObject.cdn-pto-transb[3]) THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Local_Transbordo_3" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        END.

    IF  RowObject.cdn-pto-transb[4] <> 0 THEN
        IF NOT CAN-FIND(FIRST pto-contr
                        WHERE pto-contr.cod-pto-contr = RowObject.cdn-pto-transb[4]) THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Local_Transbordo_4" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        END.

        if  rowObject.cod-agenc-carta-cr <> "" then
            if not can-find (first agencia
                             where agencia.agencia = rowObject.cod-agenc-carta-cr) then do:
               assign i-seq-erro = i-seq-erro + 1.
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "Ag._Carta_Cr‚dito" *}
               run utp/ut-msgs.p (input "msg":U,
                                  input 2,
                                  input RETURN-VALUE).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 2
                      tt-bo-erro.mensagem     = return-value.              
            end.
            
        if  rowObject.cod-agenc-entreg-docto <> "" then
            if not can-find (first agencia
                             where agencia.agencia = rowObject.cod-agenc-entreg-docto) then do:
               assign i-seq-erro = i-seq-erro + 1.
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "Ag._Entrega_Documentos" *}
               run utp/ut-msgs.p (input "msg":U,
                                  input 2,
                                  input RETURN-VALUE).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 2
                      tt-bo-erro.mensagem     = return-value.              
            end.    
        
        if  rowObject.cod-agenc-cobr <> "" then
            if not can-find (first agencia
                             where agencia.agencia = rowObject.cod-agenc-cobr) then do:
               assign i-seq-erro = i-seq-erro + 1.
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "Ag._Cobran‡a" *}
               run utp/ut-msgs.p (input "msg":U,
                                  input 2,
                                  input RETURN-VALUE).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 2
                      tt-bo-erro.mensagem     = return-value.              
            end.    
                
    if  rowObject.cdn-bco-cobr <> 0 then
        if not can-find(first banco 
                        where banco.cod-banco = rowObject.cdn-bco-cobr) then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Banco_Cobran‡a" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.

     if  rowObject.cdn-bco-entreg-docto <> 0 then
         if not can-find(first banco 
                         where banco.cod-banco = rowObject.cdn-bco-entreg-docto) then do:
             assign i-seq-erro = i-seq-erro + 1.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Banco_Entrega_Documentos" *}
             run utp/ut-msgs.p (input "msg":U,
                                input 2,
                                input RETURN-VALUE).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen     = i-seq-erro
                    tt-bo-erro.cd-erro      = 2
                    tt-bo-erro.mensagem     = return-value.
          end.

    if rowObject.cdn-bco-carta-cr <> 0 then do:
        if not can-find(first banco 
                        where banco.cod-banco = rowObject.cdn-bco-carta-cr) then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-table.i mgadm banco 1}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Banco_Carta_Cr‚dito" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input RETURN-VALUE).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.
    if (rowObject.carta-credito <> ""    and 
        rowObject.cdn-bco-carta-cr = 0 ) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
        pre-processador em chamada de includes */
        {utp/ut-table.i mgadm banco 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 19456,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 19456
               tt-bo-erro.mensagem     = return-value.
    end.

    /**************************************************************
    *          Valida‡äes do Sub-processo de Exporta‡Æo           *
    **************************************************************/
    IF substring(rowObject.char-2,1,1) = "1" THEN DO: /*Se marcado como Sub-processo*/
        {utp/ut-liter.i Importador_do_SubProcesso_deve_ser_igual_ao_Importador_do_Processo_de_Exporta‡Æo_de_Origem *}
        ASSIGN c-lb-importador-dif = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Itiner rio_do_SubProcesso_deve_ser_igual_ao_Itiner rio_do_Processo_de_Exporta‡Æo_de_Origem *}
        ASSIGN c-lb-itinerario-dif = TRIM(RETURN-VALUE).

        FIND FIRST bf-processo-exp 
             WHERE bf-processo-exp.cod-estabel = RowObject.cod-estabel
               AND bf-processo-exp.nr-proc-exp = c-processo-orig NO-LOCK NO-ERROR.
        IF AVAIL bf-processo-exp THEN DO:
            /*Se o importador do processo de origem for diferente do importador do subprocesso */
            IF bf-processo-exp.cod-emitente <> rowobject.cod-emitente THEN DO:
                /*158 - &1 inv lido(a). Informe um(a) &1 v lido(a). &2*/
                {utp/ut-liter.i Importador *}
                ASSIGN c-lb-importador = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg":U,
                                   input 158,
                                   input c-lb-importador).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                       tt-bo-erro.cd-erro      = 158
                       tt-bo-erro.mensagem     = return-value
                       tt-bo-erro.errorhelp    = c-lb-importador-dif.
            END.
            /*Se itiner rio do processo de origem for diferente do itinerario do subprocesso*/
            IF bf-processo-exp.cod-itiner <> rowobject.cod-itiner THEN DO:
                /*158 - &1 inv lido(a). Informe um(a) &1 v lido(a). &2*/
                {utp/ut-liter.i Itiner rio *}
                ASSIGN c-lb-itinerario = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg":U,
                                   input 158 ,
                                   input c-lb-itinerario).
                CREATE tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                       tt-bo-erro.cd-erro      = 158
                       tt-bo-erro.mensagem     = return-value
                       tt-bo-erro.errorhelp    = c-lb-itinerario-dif.
            END.
        END.
    END. /*validacoes subprocesso*/

    if rowObject.cod-idioma <> "" AND i-pais-impto-usuario = 2 then
        RUN pi-valida-cod-idioma-argentina.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateSituacao:

    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
    
    &if defined(bf_dis_proc_ent) &then
        /** EPC - Inicio **/
        for each tt-epc where tt-epc.cod-event = "before-Validate-Situacao": 
           delete tt-epc. 
        end.
        
        /* Criando registro da EPC */
        create tt-epc.
        assign tt-epc.cod-event = "before-Validate-Situacao" .
        /* {include/i-epc200.i2 &CodEvent="before-Validate-Situacao"
                             &CodParameter="no-error"
                             &ValueParameter="no-error" }     */
              
        /*** Chamada do programa EPC ***/
        {include/i-epc201.i "before-Validate-Situacao" }

        FIND FIRST tt-epc 
             WHERE tt-epc.cod-event     = "before-Validate-Situacao" 
             AND   tt-epc.cod-parameter = "no-error" NO-ERROR.

        IF NOT AVAIL tt-epc THEN DO:
    &endif
            find first {&TABLE-NAME} exclusive-lock
                 where rowid({&TABLE-NAME}) = r-chave no-error.
            if avail {&TABLE-NAME} then do:
                if {&table-name}.cod-sit-proc = 4 then do: 
                    assign i-seq-erro = i-seq-erro + 1.
                    run utp/ut-msgs.p (input "msg":U,
                                       input 25797,
                                       input return-value).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 25797
                           tt-bo-erro.mensagem     = return-value.
                end.
            end.
            assign r-chave = rowid({&TABLE-NAME}).
            &if defined(bf_dis_proc_ent) &then    
                end.    
            &endif
END PROCEDURE.

PROCEDURE validateDelete:
    /*******  Valida Delete  */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
    def var c-return as char no-undo.
    DEF VAR c-lb-process-exp AS CHAR NO-UNDO. 

    {utp/ut-liter.i "Processo_de_Exporta‡Æo" * R}
    ASSIGN c-lb-process-exp = TRIM(RETURN-VALUE).

    run InitializeValidate.
    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
     
    find first {&TABLE-NAME} exclusive-lock 
         where rowid({&TABLE-NAME}) = r-chave no-error.
    if avail {&TABLE-NAME} then do:    
        if {&table-name}.cod-sit-proc > 1 then do:      
            assign i-seq-erro =  i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Elimina‡Æo * R}
            run utp/ut-msgs.p (input "msg":U,
                               input 17148,
                               input return-value).

            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17148
                   tt-bo-erro.mensagem = return-value.
        end.
        else do:
            find first proc-ped-venda no-lock 
                 where proc-ped-venda.cod-estabel = {&TABLE-NAME}.cod-estabel
                 and   proc-ped-venda.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp no-error.
            if avail proc-ped-venda then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg":U,
                                   input 26212,
                                   input return-value).

                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 26212
                       tt-bo-erro.mensagem     = return-value.
            end.
            ELSE DO:
                FIND FIRST proces-export-relacdo NO-LOCK
                     WHERE proces-export-relacdo.cod-estabel-orig       = {&TABLE-NAME}.cod-estabel
                       AND proces-export-relacdo.cod-proces-export-orig = {&TABLE-NAME}.nr-proc-exp NO-ERROR.
                /*Se o processo a ser eliminado ‚ um processo pai nÆo deve permitir elimina‡Æo*/
                IF AVAIL proces-export-relacdo THEN DO:
                    {utp/ut-liter.i "Processo_de_Exporta‡Æo_Relacionados" * R}
                    run utp/ut-msgs.p (input "msg":U,
                                       input 54573,
                                       input c-lb-process-exp + "~~" + return-value).
        
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen = i-seq-erro + 1
                           tt-bo-erro.cd-erro  = 54573
                           tt-bo-erro.mensagem = c-lb-process-exp + "~~" + return-value.
                END.
                ELSE 
                  run executeDelete.
            END.
        end.
    end.
    if not can-find(first tt-bo-erro) then do:
        if l-query then
            get next {&QUERY-NAME} no-lock no-wait.
        else
            find next {&TABLE-NAME} no-lock no-error.

        if not avail {&TABLE-NAME} then do:
            if l-query then
                get prev {&QUERY-NAME} no-lock no-wait.
            else
                find prev {&TABLE-NAME} no-lock no-error.
        end.
        assign r-chave = rowid({&TABLE-NAME}).
        return "".
    end.
END PROCEDURE.

PROCEDURE pi-verifica-subprocesso:
    /**********************************************************************
    * Verifica se o processo ‚ um subprocesso                             *
    ***********************************************************************/
    def output parameter pl-subprocesso as LOGICAL.
    
    ASSIGN pl-subprocesso = CAN-FIND (FIRST proces-export-relacdo
                                      WHERE proces-export-relacdo.cod-estabel = {&TABLE-NAME}.cod-estabel
                                        AND proces-export-relacdo.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-processo-origem:
    /**********************************************************************
    * Verifica se o processo ‚ um processo de origem                      *
    ***********************************************************************/
    def output parameter pl-processo-origem as LOGICAL.
    
    ASSIGN pl-processo-origem = CAN-FIND (FIRST proces-export-relacdo
                                          WHERE proces-export-relacdo.cod-estabel = {&TABLE-NAME}.cod-estabel
                                            AND proces-export-relacdo.cod-proces-export-orig = {&TABLE-NAME}.nr-proc-exp).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE GenerateTable.
    /*  Valida cria‡Æo da tabela/duplicidade de registro.  */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    def output parameter i-nr-processo like processo-exp.nr-proc-exp.
    run initializeValidate.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find first rowObject exclusive-lock no-error.
    if avail rowObject then do:
        run validateEstabel         (input rowObject.cod-estabel).
        run validateProcExp         (input rowObject.cod-estabel,
                                     input-output rowObject.nr-proc-exp).
        run validateEmitente        (input rowObject.cod-emitente).
        run validateItinerario.
        run ExecuteCreateProcesso   (input  table rowObject,
                                     output table tt-bo-erro,
                                     output r-chave).
        find first processo-exp no-lock 
             where rowid(processo-exp) = r-chave no-error.
        if avail processo-exp then 
            assign i-nr-processo = processo-exp.nr-proc-exp.
    end.
END PROCEDURE.

PROCEDURE validateCreate:
    /*  Valida cria‡Æo da tabela/duplicidade de registro.  */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.

    run initializeValidate.         
    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find first rowObject exclusive-lock no-error.
    if avail rowObject then do:
        run validaFatProcExp    (input rowobject.nr-proc-exp).
        run validateEstabel     (input rowObject.cod-estabel). 
        run validateProcExp     (input rowObject.cod-estabel,
                                 input-output rowObject.nr-proc-exp).
        IF substring(rowObject.char-2,1,1) = "1" THEN /*Se marcado como Sub-processo*/
            RUN validateSubProcExp(INPUT rowObject.cod-estabel,
                                   INPUT c-processo-orig,
                                   INPUT YES). 

        run validateEmitente    (input rowObject.cod-emitente).
        run validateItinerario.

        find first tt-bo-erro no-error.
        if not avail tt-bo-erro then do:
            run validateFields (input yes). /* inclusão */
            run ExecuteCreateProcesso (input table rowObject,
                                       output table tt-bo-erro,
                                       output r-chave).
        end.
    end.
END PROCEDURE.

procedure validatenumeroprocesso:

    def input  parameter p-cod-estabel like processo-exp.cod-estabel no-undo.
    def input  parameter p-nr-proc-exp like processo-exp.nr-proc-exp no-undo.
    def output parameter l-altera-numero as logical no-undo.

    def var p-r-processo-exp as rowid no-undo.
    def buffer b-processo-exp for processo-exp.

    RUN getrowid (OUTPUT p-r-processo-exp).

    if CAN-FIND(first b-processo-exp 
                where b-processo-exp.cod-estabel = p-cod-estabel 
                and   b-processo-exp.nr-proc-exp = p-nr-proc-exp
                and   rowid(b-processo-exp)  <> p-r-processo-exp) then
        assign l-altera-numero = yes.
    else 
        assign l-altera-numero = no.

end procedure.

procedure validateUpdate:
    /* **  Valida Update */
    def input parameter table for RowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
    
    find first rowObject NO-LOCK NO-ERROR.
    run InitializeValidate.
    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    assign l-valida-aux = yes.
    
    find first rowObject EXCLUSIVE-LOCK NO-ERROR.
    if avail rowObject then do:

        assign l-valida-aux = l-valida-ex0201.

        if  l-valida-aux then
            run validateFields (input no). /* modifica‡Æo */

        run validateItinerario.
        
        IF lAlteracaoItinerario THEN /* Se alterou itiner rio: Valida os pontos do novo itiner rio */
            RUN pi-valida-pontos-itinerario.
    end.

    find first tt-bo-erro no-lock no-error.
    if not avail tt-bo-erro 
    OR (AVAIL tt-bo-erro AND tt-bo-erro.errorsubtype = "warning":U)then do:

        find first {&TABLE-NAME} exclusive-lock 
             where rowid({&TABLE-NAME}) = r-chave no-error.

        FOR FIRST param-exp
            WHERE param-exp.cod-estabel = rowObject.cod-estabel NO-LOCK: END.
        IF AVAIL param-exp THEN DO:

            /* Se o parƒmero de gerar log da tabela processo-exp estiver selecionada */
            IF TRIM(SUBSTRING(param-exp.char-1,33,1)) = "":U OR TRIM(SUBSTRING(param-exp.char-1,33,1)) = "1":U THEN DO:
                IF NOT VALID-HANDLE(h-exapi025) THEN
                    RUN exp/exapi025.p PERSISTENT SET h-exapi025.
                /* Salva o processo atual na temp-table tt-processo-exp-old (antes da altera‡Æo) */
                RUN pi-salva-valor-antigo IN h-exapi025(INPUT "processo-exp":U, INPUT rowObject.r-rowid). 
            END.
            
            IF lAlteracaoItinerario THEN DO:
               /* cria temp table para as despesas e declara‡äes do itiner rio novo */
                RUN pi-ttdesp-ttdecla-novo-itiner (INPUT RowObject.cod-estabel,
                                                   INPUT RowObject.nr-proc-exp,
                                                   INPUT RowObject.cod-itiner,
                                                   INPUT ?,
                                                   INPUT YES,
                                                   INPUT YES,
                                                   OUTPUT TABLE tt-despesas-itinerario,
                                                   OUTPUT TABLE tt-declaracoes-itinerario).
            END.

            run executeUpdate.
    
            IF lAlteracaoItinerario THEN DO:
                IF NOT VALID-HANDLE(h-bocx200) THEN
                    RUN cxbo/bocx200.p PERSISTENT SET h-bocx200.
        
                RUN pi-recebe-idioma IN h-bocx200 (INPUT c-cod-idiom-usuar).

                FOR FIRST processo-exp FIELDS(pto-despacho pto-embarque pto-desembarque pto-chegada) NO-LOCK
                    WHERE processo-exp.cod-estabel = RowObject.cod-estabel
                      AND processo-exp.nr-proc-exp   = RowObject.nr-proc-exp:
                END.                                                            
                RUN pi-seta-alteracao-itiner IN h-bocx200 (INPUT YES).
                RUN GenerateTable IN h-bocx200 (INPUT TABLE rowObject, OUTPUT TABLE tt-bo-erro).
                RUN pi-seta-alteracao-itiner IN h-bocx200 (INPUT NO). /* Volta valor da vari vel para NO */
            END.
    
            /* Se alterou itiner rio */
            IF lAlteracaoItinerario AND NOT CAN-FIND(FIRST tt-bo-erro) AND param-exp.log-permite-alter-itiner THEN DO:
               IF CAN-FIND(FIRST tt-despesas-itinerario) THEN
                  RUN pi-create-despesas-novo-itiner (INPUT TABLE tt-despesas-itinerario). 
               IF CAN-FIND(FIRST tt-declaracoes-itinerario) THEN
                  RUN pi-create-declaracoes-novo-itiner (INPUT TABLE tt-declaracoes-itinerario).                 
               RUN pi-elimina-historico-despesas-declaracoes.
            END.

            /* Se o parƒmero de gerar log da tabela processo-exp estiver selecionado */
            IF TRIM(SUBSTRING(param-exp.char-1,33,1)) = "":U OR TRIM(SUBSTRING(param-exp.char-1,33,1)) = "1":U THEN DO:
                {utp/ut-liter.i "Altera‡Æo"}
                RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
            END.
    
            find current {&TABLE-NAME} no-lock no-error.
        END.
    end.
end procedure.

PROCEDURE AtualizaPtoEmbarque:
    /*Quando o ponto de embarque for efetivado sera atualizada a situa‡Æo do
    processo para embarcado e a data de embarque   */
    def input parameter p-chave  as rowid no-undo.
    def input parameter p-dt-emb like processo-exp.dt-embarque no-undo.

    find processo-exp where rowid(processo-exp) = p-chave exclusive-lock no-error.
    if avail processo-exp then 
        assign processo-exp.cod-sit-proc = 4
               processo-exp.dt-embarque  = p-dt-emb. 
END PROCEDURE.

PROCEDURE AtualizaProcPedEnt:
    def input  parameter pc-cod-estabel like estabelec.cod-estabel        no-undo.
    def input  parameter pc-nr-proc-exp like processo-exp.nr-proc-exp     no-undo.
    def output parameter table          for tt-bo-erro.

    def var de-qt-faturada              like it-nota-fisc.qt-faturada     no-undo.
    def var de-peso-liq-fat             like it-nota-fisc.peso-liq-fat    no-undo.
    def var de-peso-bruto               like it-nota-fisc.peso-bruto      no-undo.
    def var de-vl-preuni                like it-nota-fisc.vl-preuni-e[1]  no-undo.
    def var de-vl-preori                like it-nota-fisc.vl-totitem-e[1] no-undo.
    def var de-vl-preuni-dif            like it-nota-fisc.vl-preuni-e[1]  no-undo.
    def var de-vl-preori-dif            like it-nota-fisc.vl-totitem-e[1] no-undo.
    DEF VAR de-vl-preuni-primeiro       LIKE it-nota-fisc.vl-preuni-e[1]  NO-UNDO.
    DEF VAR de-vl-preori-primeiro       LIKE it-nota-fisc.vl-totitem-e[1] NO-UNDO.
    def var l-atualiza                  as   logical                      no-undo.
    def var l-fatura                    as   logical                      no-undo.
    def var de-qt-baixada               like fat-ser-lote.qt-baixada      no-undo.
    def var i-mo-codigo                 like ped-venda.mo-codigo          no-undo.
    
    def var de-pct-qtde                 like proc-ped-ent.quantidade      no-undo.
    def var de-qt-anterior              like proc-ped-ent.quantidade      no-undo.
    def var de-tot-peso-bruto           like it-nota-fisc.peso-bruto      no-undo.
    def var de-tot-peso-liquido         like it-nota-fisc.peso-liq-fat    no-undo.
    def var de-tot-peso-bru-rat         like it-nota-fisc.peso-bruto      no-undo.
    def var de-tot-peso-liq-rat         like it-nota-fisc.peso-liq-fat    no-undo.
    
    def var h-boin245                   as handle                         no-undo.
    def var i-ind-entreg-futur          as int                            no-undo.
    def var i-oper-entrega-fatur        as int                            no-undo.
    def var l-ind-entfut                as log                            no-undo.
    def var l-ind-est-qtd               as log                            no-undo.
    DEFINE VARIABLE l-atualiza-proc-exp AS LOGICAL                INIT NO NO-UNDO.
    
    def var l-nota-devolvida            as log                            no-undo init yes.
    def var de-qtd-devol                like devol-cli.qt-devolvida       no-undo.

    DEF VAR c-msg                       AS CHARACTER                      NO-UNDO.

    EMPTY TEMP-TABLE tt-erro-30683.

    /* Para espec¡fico MOEDA - cfme FO 1859486*/
    def var l-valida-preco-unit as logical no-undo.
    /*Espec¡fico MOEDA*/

    if not valid-handle(h-boin245) then
        run inbo/boin245.p persistent set h-boin245.
    
    def buffer b-proc-ped-ent for proc-ped-ent.
    def buffer b-natur-oper   for natur-oper.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    empty temp-table tt-proc-nota-fiscal.

    FIND FIRST param-exp
         WHERE param-exp.cod-estabel = pc-cod-estabel NO-LOCK NO-ERROR.

    /* retorna se ‚ cidade-cif */
    IF NOT VALID-HANDLE(h-bocx359) THEN
        RUN cxbo/bocx359.p PERSISTENT SET h-bocx359.
    RUN piRetornaDespesaInclusa IN h-bocx359(INPUT pc-cod-estabel,
                                             INPUT pc-nr-proc-exp,
                                             OUTPUT l-despesa-inclusa).
    IF VALID-HANDLE(h-bocx359) THEN DO:
        DELETE PROCEDURE h-bocx359.
        ASSIGN h-bocx359 = ?.
    END.

    for each  proc-ped-ent exclusive-lock
        where proc-ped-ent.cod-estabel = pc-cod-estabel
          and proc-ped-ent.nr-proc-exp = pc-nr-proc-exp
          and proc-ped-ent.ind-componen <= 2:

        assign de-qt-faturada        = 0
               de-peso-liq-fat       = 0
               de-peso-bruto         = 0
               de-vl-preuni          = 0
               de-vl-preuni-primeiro = 0
               de-vl-preori-primeiro = 0
               de-vl-preori          = 0
               de-vl-preuni-dif      = 0
               de-vl-preori-dif      = 0
               l-atualiza            = yes
               l-fatura              = no.
               
        for first proc-ped-venda fields(nr-pedido) no-lock
            where proc-ped-venda.cod-estabel = proc-ped-ent.cod-estabel
              and proc-ped-venda.nr-proc-exp = proc-ped-ent.nr-proc-exp:
              
            for first ped-venda fields(mo-codigo) no-lock
                where ped-venda.nr-pedido = proc-ped-venda.nr-pedido:
                 assign i-mo-codigo = ped-venda.mo-codigo.
            END.
        END.
         
        assign de-qt-anterior[1] = proc-ped-ent.quantidade[1].
        
        for each  proc-it-nota-fisc EXCLUSIVE-LOCK
            where proc-it-nota-fisc.nome-abrev   = proc-ped-ent.nome-abrev
            and   proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli
            and   proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia 
            and   proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo
            and   proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer
            and   proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega:

            /* verificar se ‚ cidade-cif */
            IF l-despesa-inclusa THEN DO:
                ASSIGN OVERLAY(proc-it-nota-fisc.char-1,1,1) = "1"
                       proc-it-nota-fisc.dec-2 = param-exp.dec-2.
            END.

            if proc-it-nota-fisc.nr-proc-exp <> proc-ped-ent.nr-proc-exp then next.
            for first it-nota-fisc fields(qt-faturada peso-liq-fat peso-bruto it-nota-fisc.vl-preuni-e[1] it-nota-fisc.vl-preori-e[1] 
                                          cod-estabel serie nr-nota-fis vl-preuni vl-preori it-codigo nr-seq-fat dt-cancela nome-ab-cli nr-pedcli) NO-LOCK
                where it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam 
                and   it-nota-fisc.serie       = proc-it-nota-fisc.serie
                and   it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
                and   it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat
                and   it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo:
            END.
            if avail it-nota-fisc then do:

                 if  not avail proc-nota-fiscal 
                    or  proc-nota-fiscal.cod-estab-faturam <> it-nota-fisc.cod-estabel
                    or  proc-nota-fiscal.serie             <> it-nota-fisc.serie
                    or  proc-nota-fiscal.nr-nota-fis       <> it-nota-fisc.nr-nota-fis then
                    for first proc-nota-fiscal fields(cod-estabel serie nr-nota-fis 
                                                      log-nf-devolvid cod-estab-faturam ) no-lock
                        where proc-nota-fiscal.cod-estab-faturam = it-nota-fisc.cod-estabel
                        and   proc-nota-fiscal.serie             = it-nota-fisc.serie
                        and   proc-nota-fiscal.nr-nota-fis       = it-nota-fisc.nr-nota-fis:
                 END.
               
                for first nota-fiscal fields(nat-operacao dt-cancela cod-estabel serie nr-nota-fis dt-emis-nota ind-tip-nota log-var-cambial)
                    where nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                    and   nota-fiscal.serie       = proc-nota-fiscal.serie       
                    and   nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis no-lock:
                END.

                if not avail nota-fiscal then next.
                if  nota-fiscal.dt-cancela   <> ? then next.

                assign de-qtd-devol = 0.
                for each devol-cli fields(qt-devolvida serie-docto nro-docto cod-emitente nat-operacao) no-lock
                   where devol-cli.cod-estabel  = it-nota-fisc.cod-estabel
                     and devol-cli.serie        = it-nota-fisc.serie      
                     and devol-cli.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                     and devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat 
                     and devol-cli.it-codigo    = it-nota-fisc.it-codigo:
                    
                     FOR FIRST item-doc-est FIELDS(reabre-pd) NO-LOCK
                         where item-doc-est.serie-docto  = devol-cli.serie-docto 
                           and item-doc-est.nro-docto    = devol-cli.nro-docto 
                           and item-doc-est.cod-emitente = devol-cli.cod-emitente
                           and item-doc-est.nat-operacao = devol-cli.nat-operacao:
                     END.
                     if not avail item-doc-est then NEXT.

                     
                     assign de-qt-anterior[1] = de-qt-anterior[1] - IF item-doc-est.reabre-pd THEN devol-cli.qt-devolvida else 0 
                            de-qtd-devol      = de-qtd-devol      + IF item-doc-est.reabre-pd THEN devol-cli.qt-devolvida ELSE 0.
                END.
                
                if it-nota-fisc.qt-faturada[1] = de-qtd-devol and 
                   l-nota-devolvida = yes                     then
                   assign l-nota-devolvida = yes.
                else
                   assign l-nota-devolvida = no.
                 find first tt-proc-nota-fiscal
                     where tt-proc-nota-fiscal.cod-estab-faturam = proc-nota-fiscal.cod-estab-faturam 
                       and tt-proc-nota-fiscal.serie             = proc-nota-fiscal.serie             
                       and tt-proc-nota-fiscal.nr-nota-fis       = proc-nota-fiscal.nr-nota-fis       no-error.
                if not avail tt-proc-nota-fiscal then do:
                    create tt-proc-nota-fiscal.
                    assign tt-proc-nota-fiscal.cod-estab-faturam = proc-nota-fiscal.cod-estab-faturam  
                           tt-proc-nota-fiscal.serie             = proc-nota-fiscal.serie              
                           tt-proc-nota-fiscal.nr-nota-fis       = proc-nota-fiscal.nr-nota-fis.
                END.
                assign tt-proc-nota-fiscal.log-nf-devolvid = l-nota-devolvida.
                find first b-natur-oper no-lock
                     where b-natur-oper.nat-operacao = nota-fiscal.nat-operacao no-error.

                if  avail b-natur-oper then do:
                    assign i-ind-entreg-futur = if  substr(b-natur-oper.char-1,1,5) = "1    ":U
                                                then 1
                                                else 2
                           l-ind-entfut       = b-natur-oper.ind-entfut
                           l-ind-est-qtd      = b-natur-oper.ind-est-qtd.
                    IF NOT VALID-HANDLE(h-boin245) THEN
                        run inbo/boin245.p persistent set h-boin245.
                        
                    run convertOperationType in h-boin245 (input 2,
                                                           input-output i-oper-entrega-fatur,
                                                           input-output i-ind-entreg-futur,
                                                           input-output l-ind-entfut,
                                                           input-output l-ind-est-qtd).
                    /*desconsidera as notas fiscais de faturamento antecipado e faturamento com entrega futura*/
                    if i-oper-entrega-fatur = 2 or i-oper-entrega-fatur = 4 then next. 

                END.

                /* colocar a diferen‡a aceit vel na mesma moeda do pedido */
                FOR FIRST ped-venda FIELDS(mo-codigo)
                    WHERE ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli
                      AND ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli NO-LOCK:

                    IF ped-venda.mo-codigo <> 0 THEN DO:
                        run cdp/cd0812.p (input 0,
                                          input ped-venda.mo-codigo,
                                          input param-exp.dec-2,
                                          input nota-fiscal.dt-emis-nota,
                                          output de-val-dif-aceit-conv).
                    END.
                    ELSE
                        ASSIGN de-val-dif-aceit-conv = param-exp.dec-2.
                END.
                /* fim - colocar a diferen‡a aceit vel na mesma moeda do pedido */


                /*S¢ valida os dados se a nota nÆo for de Defiren‡a de pre‡o*/
                IF nota-fiscal.ind-tip-nota <> 3 THEN DO: /*ind-tip-nota <> 3*/

                    if i-mo-codigo = 0 then do:
                        if  de-vl-preuni-primeiro <> 0 and
                            de-vl-preuni-primeiro <> it-nota-fisc.vl-preuni and
                            l-atualiza THEN DO:
    
                            IF l-despesa-inclusa THEN DO:
                                IF abs(de-vl-preuni-primeiro - it-nota-fisc.vl-preuni) > de-val-dif-aceit-conv THEN DO:
                                    assign l-atualiza = no.
                                    CREATE tt-erro-30683.
                                    ASSIGN tt-erro-30683.it-codigo   = it-nota-fisc.it-codigo  
                                           tt-erro-30683.cod-estabel = it-nota-fisc.cod-estabel
                                           tt-erro-30683.serie       = it-nota-fisc.serie      
                                           tt-erro-30683.nr-nota-fis = it-nota-fisc.nr-nota-fis.
                                END.
                            END.
                        END.
                        ELSE
                            ASSIGN de-vl-preuni-primeiro = it-nota-fisc.vl-preuni WHEN de-vl-preuni = 0
                                   de-vl-preori-primeiro = it-nota-fisc.vl-preori WHEN de-vl-preori = 0.
                    END.
                    else do:
                        if  de-vl-preuni-primeiro <> 0 and 
                            de-vl-preuni-primeiro <> it-nota-fisc.vl-preuni-e[1] and 
                            l-atualiza THEN DO:
    
                            IF abs(de-vl-preuni-primeiro - it-nota-fisc.vl-preuni-e[1]) > de-val-dif-aceit-conv THEN DO:
                                assign l-atualiza = no.
                                CREATE tt-erro-30683.
                                ASSIGN tt-erro-30683.it-codigo   = it-nota-fisc.it-codigo  
                                       tt-erro-30683.cod-estabel = it-nota-fisc.cod-estabel
                                       tt-erro-30683.serie       = it-nota-fisc.serie      
                                       tt-erro-30683.nr-nota-fis = it-nota-fisc.nr-nota-fis.
                            END.
                        END.
                        ELSE
                            ASSIGN de-vl-preuni-primeiro = it-nota-fisc.vl-preuni-e[1] WHEN de-vl-preuni = 0
                                   de-vl-preori-primeiro = it-nota-fisc.vl-preori-e[1] WHEN de-vl-preori = 0.
                    END.                                 
                
                    IF it-nota-fisc.dt-cancela  = ? THEN                           
                      ASSIGN de-qt-faturada[1] = de-qt-faturada[1] + (it-nota-fisc.qt-faturada[1] - de-qtd-devol)
                             de-qt-faturada[2] = de-qt-faturada[2]  + it-nota-fisc.qt-faturada[2] - ((it-nota-fisc.qt-faturada[2] / it-nota-fisc.qt-faturada[1]) * de-qtd-devol).
                   
                    assign l-fatura = yes
                           de-peso-liq-fat   = de-peso-liq-fat    + it-nota-fisc.peso-liq-fat - ((it-nota-fisc.peso-liq-fat / it-nota-fisc.qt-faturada[1]) * de-qtd-devol)   
                           de-peso-bruto     = de-peso-bruto      + it-nota-fisc.peso-bruto - ((it-nota-fisc.peso-bruto / it-nota-fisc.qt-faturada[1]) * de-qtd-devol) 
                           de-vl-preuni      = if i-mo-codigo = 0 then it-nota-fisc.vl-preuni else it-nota-fisc.vl-preuni-e[1]
                           de-vl-preori      = if i-mo-codigo = 0 then it-nota-fisc.vl-preori else it-nota-fisc.vl-preori-e[1].
                    
                END. /*ind-tip-nota <> 3*/
                ELSE DO:
                    IF  NOT nota-fiscal.log-var-cambial THEN
                        IF  proc-ped-ent.idi-unid-fatur = 1 THEN /* Unidade do Item */
                            ASSIGN de-vl-preuni-dif = de-vl-preuni-dif + (it-nota-fisc.vl-preuni-e[1] * it-nota-fisc.qt-faturada[1])
                                   de-vl-preori-dif = de-vl-preori-dif + (it-nota-fisc.vl-preori-e[1] * it-nota-fisc.qt-faturada[1]).
                        ELSE 
                            ASSIGN de-vl-preuni-dif = de-vl-preuni-dif + (it-nota-fisc.vl-preuni-e[1] * it-nota-fisc.qt-faturada[2])
                                   de-vl-preori-dif = de-vl-preori-dif + (it-nota-fisc.vl-preori-e[1] * it-nota-fisc.qt-faturada[2]).
                    ASSIGN l-fatura = yes.
                END.
            END. /*it-nota-fisc*/
        END.
        RELEASE proc-it-nota-fisc.

        IF  l-considera-dif-preco THEN DO:
            IF  proc-ped-ent.idi-unid-fatur = 1 THEN
                ASSIGN de-vl-preuni-dif = de-vl-preuni-dif / de-qt-faturada[1]
                       de-vl-preori-dif = de-vl-preori-dif / de-qt-faturada[1].
            ELSE 
                ASSIGN de-vl-preuni-dif = de-vl-preuni-dif / de-qt-faturada[2]
                       de-vl-preori-dif = de-vl-preori-dif / de-qt-faturada[2].
        END.

        if  l-fatura then do:
            IF  l-atualiza-todos 
            OR (l-atualiza-quantidade AND l-atualiza-peso) THEN DO:
                assign proc-ped-ent.quantidade[1] = de-qt-faturada[1]
                       proc-ped-ent.quantidade[2] = de-qt-faturada[2]
                       proc-ped-ent.peso-bruto    = de-peso-bruto
                       proc-ped-ent.peso-liquido  = de-peso-liq-fat.
            END.
            ELSE DO:
                IF l-atualiza-quantidade THEN DO:
                    assign proc-ped-ent.quantidade[1] = de-qt-faturada[1]
                           proc-ped-ent.quantidade[2] = de-qt-faturada[2]. 
                END.
                ELSE DO:
                    IF l-atualiza-peso THEN DO:
                       assign proc-ped-ent.peso-bruto    = de-peso-bruto
                              proc-ped-ent.peso-liquido  = de-peso-liq-fat.
                    END.
                END.
            END.

            if  proc-ped-ent.ind-componen = 2 /* item pai */ then do: 

                assign de-pct-qtde[1] = trunc(proc-ped-ent.quantidade[1] / de-qt-anterior[1],4)
                       de-tot-peso-bruto   = 0
                       de-tot-peso-liquido = 0.

                for each  b-proc-ped-ent fields (it-codigo quantidade peso-bruto peso-liquido) exclusive-lock
                    where b-proc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel
                    and   b-proc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp
                    and   b-proc-ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                    and   b-proc-ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli   
                    and   b-proc-ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                    and   b-proc-ped-ent.nr-entrega   = proc-ped-ent.nr-entrega  
                    and   b-proc-ped-ent.ind-componen = 3,
                    first item fields(peso-bruto peso-liquido) no-lock
                    where item.it-codigo = b-proc-ped-ent.it-codigo:

                    assign de-qt-baixada[1] = 0
                           de-qt-baixada[2] = 0
                           l-fatura         = no.

                    for each  proc-it-nota-fisc EXCLUSIVE-LOCK
                        where proc-it-nota-fisc.nome-abrev   = proc-ped-ent.nome-abrev 
                        and   proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli
                        and   proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia
                        and   proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo
                        and   proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer
                        and   proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega:

                        /* verificar se ‚ cidade-cif */
                        IF l-despesa-inclusa THEN DO:
                            ASSIGN OVERLAY(proc-it-nota-fisc.char-1,1,1) = "1"
                                   proc-it-nota-fisc.dec-2 = param-exp.dec-2.
                        END.
                 

                        if proc-it-nota-fisc.nr-proc-exp <> proc-ped-ent.nr-proc-exp then next.

                        for first it-nota-fisc fields (cod-estabel serie nr-nota-fis nr-seq-fat peso-liq-fat peso-bruto it-codigo) no-lock
                            where it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
                            and   it-nota-fisc.serie       = proc-it-nota-fisc.serie
                            and   it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
                            and   it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat
                            and   it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo:
                        END.
                        if avail it-nota-fisc then do:
                            for each  fat-ser-lote fields (qt-baixada) no-lock
                                where fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                                and   fat-ser-lote.serie       = it-nota-fisc.serie
                                and   fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                and   fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                                and   fat-ser-lote.it-codigo   = b-proc-ped-ent.it-codigo:

                                assign l-fatura = yes
                                       de-qt-baixada[1] = de-qt-baixada[1] + fat-ser-lote.qt-baixada[1]
                                       de-qt-baixada[2] = de-qt-baixada[2] + fat-ser-lote.qt-baixada[2].

                            END.
                        END.
                        IF l-atualiza-quantidade  
                        OR l-atualiza-todos      THEN DO:
                            if  l-fatura THEN DO:
                                assign b-proc-ped-ent.quantidade[1] = de-qt-baixada[1]
                                       b-proc-ped-ent.quantidade[2] = de-qt-baixada[2].
                            END.
                            else
                                assign b-proc-ped-ent.quantidade[1] = b-proc-ped-ent.quantidade[1] * de-pct-qtde[1].
                        END.

                        IF l-atualiza-peso
                        OR l-atualiza-todos THEN DO:
                            assign b-proc-ped-ent.peso-bruto    = b-proc-ped-ent.quantidade[1] * item.peso-bruto
                                   b-proc-ped-ent.peso-liquido  = b-proc-ped-ent.quantidade[1] * item.peso-liquido
                                   de-tot-peso-bruto            = de-tot-peso-bruto   + b-proc-ped-ent.peso-bruto
                                   de-tot-peso-liquido          = de-tot-peso-liquido + b-proc-ped-ent.peso-liquido.
                        END.

                        IF b-proc-ped-ent.quantidade[1] = 0 THEN
                            DELETE b-proc-ped-ent.
                    END.
                    RELEASE proc-it-nota-fisc.
                END.

                assign de-tot-peso-bru-rat = 0
                       de-tot-peso-liq-rat = 0.

                if l-fatura = no then do:
                    for each  b-proc-ped-ent fields (it-codigo quantidade peso-bruto peso-liquido) exclusive-lock
                        where b-proc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel
                        and   b-proc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp
                        and   b-proc-ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                        and   b-proc-ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli   
                        and   b-proc-ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                        and   b-proc-ped-ent.nr-entrega   = proc-ped-ent.nr-entrega  
                        and   b-proc-ped-ent.ind-componen = 3 
                        break by b-proc-ped-ent.cod-estabel:

                        IF l-atualiza-peso
                        OR l-atualiza-todos THEN DO:
                            if  de-tot-peso-bruto <> 0 then
                                assign b-proc-ped-ent.peso-bruto   = trunc(b-proc-ped-ent.peso-bruto * proc-ped-ent.peso-bruto / de-tot-peso-bruto, 4).
    
                            if  de-tot-peso-liquido <> 0 then
                                assign b-proc-ped-ent.peso-liquido = trunc(b-proc-ped-ent.peso-liquido * proc-ped-ent.peso-liquido / de-tot-peso-liquido, 4).
    
                            assign de-tot-peso-bru-rat = de-tot-peso-bru-rat + b-proc-ped-ent.peso-bruto  
                                   de-tot-peso-liq-rat = de-tot-peso-liq-rat + b-proc-ped-ent.peso-liquido.
    
                            if  last(b-proc-ped-ent.cod-estabel) then do:
                                if  de-tot-peso-bru-rat <> proc-ped-ent.peso-bruto then
                                    assign b-proc-ped-ent.peso-bruto = b-proc-ped-ent.peso-bruto + (proc-ped-ent.peso-bruto - de-tot-peso-bru-rat).
    
                                if  de-tot-peso-liq-rat <> proc-ped-ent.peso-liquido then
                                    assign b-proc-ped-ent.peso-liquido = b-proc-ped-ent.peso-liquido + (proc-ped-ent.peso-liquido - de-tot-peso-liq-rat).
    
                            END.
                        END.
                    END.
                    ASSIGN l-fatura = YES.
                END.
            END.
        END.

        IF l-atualiza THEN DO:
            IF l-atualiza-pre-ped THEN DO:                
                FIND FIRST ped-item NO-LOCK
                    WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev
                    AND   ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli
                    AND   ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia
                    AND   ped-item.it-codigo     = proc-ped-ent.it-codigo
                    AND   ped-item.cod-refer     = proc-ped-ent.cod-refer NO-ERROR.
    
                IF AVAIL ped-item THEN DO:
                    IF ped-item.cod-sit-item <> 3 AND ped-item.cod-sit-item <> 4 THEN
                        ASSIGN proc-ped-ent.vl-preori = ped-item.vl-preori
                               proc-ped-ent.vl-preuni = ped-item.vl-preuni.
    
                END.
            END.
            ELSE DO:
                if  l-fatura then DO:
                    IF l-atualiza-preco
                    OR l-atualiza-todos THEN DO:
                        assign proc-ped-ent.vl-preori = de-vl-preori
                               proc-ped-ent.vl-preori = de-vl-preori-primeiro WHEN l-atualiza AND l-despesa-inclusa
                               proc-ped-ent.vl-preuni = de-vl-preuni
                               proc-ped-ent.vl-preuni = de-vl-preuni-primeiro WHEN l-atualiza AND l-despesa-inclusa.

                        IF l-considera-dif-preco THEN
                            assign proc-ped-ent.vl-preori = proc-ped-ent.vl-preori + de-vl-preori-dif
                                   proc-ped-ent.vl-preuni = proc-ped-ent.vl-preuni + de-vl-preuni-dif.
                    END.

                    IF proc-ped-ent.quantidade[1] = 0 THEN
                        DELETE proc-ped-ent.

                    ASSIGN l-atualiza-proc-exp = YES.

                END.
    
            END.
        END.
        ELSE DO:
            /*Para espec¡fico MAEDA - cfme FO 1859486 */
            assign l-valida-preco-unit = yes.   
            
            IF  c-nom-prog-dpc-mg97  <> "" OR 
                c-nom-prog-appc-mg97 <> "" OR
                c-nom-prog-upc-mg97  <> "" THEN DO:
        
                for each tt-epc where tt-epc.cod-event = "CalculateUnitPrice":
                    delete tt-epc.
                END.
            
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "CalculateUnitPrice":U
                       tt-epc.cod-parameter = "RowidProc-ped-ent":U
                       tt-epc.val-parameter = string(rowid(proc-ped-ent)).
                
                {include/i-epc201.i "CalculateUnitPrice"} 
                
                find first tt-epc no-lock
                   where tt-epc.cod-event = "CalculateUnitPrice":u and
                         tt-epc.cod-parameter = "Returnvl-preuni":u no-error.
                if avail tt-epc then assign proc-ped-ent.vl-preuni = dec(tt-epc.val-parameter).
                
                find first tt-epc no-lock
                     where tt-epc.cod-event = "CalculateUnitPrice":u and
                           tt-epc.cod-parameter = "Returnvl-preori":u no-error.
                if avail tt-epc then assign proc-ped-ent.vl-preori = dec(tt-epc.val-parameter).
                
                
                find first tt-epc no-lock
                     where tt-epc.cod-event = "CalculateUnitPrice":u and
                           tt-epc.cod-parameter = "ReturnCalc":u no-error.
                if avail tt-epc then do:
                    assign l-valida-preco-unit = tt-epc.val-parameter = "Yes":u.  
                END.
                
                /* Necess rio para atualizar a situa‡Æo do pedido */
                RUN atualizaSituacaoProcesso (INPUT pc-cod-estabel, 
                                              INPUT pc-nr-proc-exp).

            END.
            /*Fim do espec¡fico MAEDA - FO 1859486*/    
            
            if l-valida-preco-unit = yes then do:
                if not can-find(first tt-bo-erro
                                where tt-bo-erro.cd-erro = 30683) then do:
                    
                    FOR EACH tt-erro-30683:
                        ASSIGN c-msg = c-msg + "Item: " + tt-erro-30683.it-codigo + chr(13) + "Nota: " + tt-erro-30683.nr-nota-fis + ". S‚rie: " + tt-erro-30683.serie + ". Estabelecimento: " + tt-erro-30683.cod-estabel + "." + CHR(13) .
                    END.

                    run utp/ut-msgs.p (input "msg":U,
                                       input 30683,
                                       input c-msg).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = 1
                           tt-bo-erro.cd-erro      = 30683
                           tt-bo-erro.mensagem     = return-value
                           tt-bo-erro.parametros   = c-msg.        .
                        /* tt-bo-erro.errorsubtype = "warning":U. */
                END.
            END.
        END.

        FOR EACH  tt-proc-nota-fiscal
            WHERE tt-proc-nota-fiscal.log-nf-devolvid = YES,
            FIRST proc-nota-fiscal FIELDS(log-nf-devolvid) EXCLUSIVE-LOCK
            WHERE proc-nota-fiscal.cod-estab-faturam = tt-proc-nota-fiscal.cod-estab-faturam 
              AND proc-nota-fiscal.serie             = tt-proc-nota-fiscal.serie             
              AND proc-nota-fiscal.nr-nota-fis       = tt-proc-nota-fiscal.nr-nota-fis:
        
            ASSIGN proc-nota-fiscal.log-nf-devolvid = YES.
        
        END.
    
        if valid-handle(h-boin245) then do:
            delete procedure h-boin245.
            assign h-boin245 = ?.
        END.

    END. /*for each proc-ped-ent*/
    
    IF l-atualiza-proc-exp THEN
        RUN atualizaSituacaoProcesso (INPUT pc-cod-estabel, 
                                      INPUT pc-nr-proc-exp).

    for first processo-exp exclusive-lock
        where processo-exp.cod-estabel = pc-cod-estabel
          and processo-exp.nr-proc-exp = pc-nr-proc-exp:
        assign processo-exp.log-nf-atlzdo = yes.
    END.

    /*Maylon*/
END PROCEDURE.

PROCEDURE executeCreateProcesso.
     def input  parameter table for RowObject. 
     def output parameter table for tt-bo-erro.
     def output parameter r-chave as rowid.  

     DEFINE VARIABLE l-subprocesso AS LOGICAL     NO-UNDO.
     ASSIGN l-subprocesso = substring(rowObject.char-2,1,1) = "1".
     
     find first {&TABLE-NAME} no-lock 
          where {&TABLE-NAME}.cod-estabel = rowObject.cod-estabel 
          and   {&TABLE-NAME}.nr-proc-exp = rowObject.nr-proc-exp no-error.
     if avail {&TABLE-NAME} then do:
         assign i-seq-erro = i-seq-erro + 1.
         /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
         pre-processador em chamada de includes */
         {utp/ut-liter.i Processo_Exporta‡Æo * R}
         run utp/ut-msgs.p (input "msg":U,
                            input 8,
                            input return-value).
         create tt-bo-erro.
         assign tt-bo-erro.i-sequen     = i-seq-erro
                tt-bo-erro.cd-erro      = 8
                tt-bo-erro.mensagem     = return-value.
     end.
         
     IF NOT l-subprocesso THEN DO:
         if rowObject.cod-itiner > 0 then do:
             if not valid-handle(h-bocx115) then 
                 RUN cxbo/bocx115.p persistent set h-bocx115.
             run findCodigo in h-bocx115 (input rowObject.cod-itiner, output c-return).
             if c-return = "" then 
                 run getcurrent in h-bocx115 (output table tt-itinerario).
             else do:
                 assign i-seq-erro = i-seq-erro + 1.
                 create tt-bo-erro.
                 assign tt-bo-erro.i-sequen = i-seq-erro
                        tt-bo-erro.cd-erro  = 2
                        tt-bo-erro.mensagem = c-return.
             end.
    
             find first tt-itinerario no-lock no-error.
             if avail tt-itinerario
                  and tt-itinerario.pto-embarque    <> 0
                  and tt-itinerario.pto-despacho    <> 0
                  and tt-itinerario.pto-desembarque <> 0  
                  and tt-itinerario.pto-chegada     <> 0  then do:
    
                 assign rowObject.pto-embarque    = tt-itinerario.pto-embarque
                        rowObject.pto-despacho    = tt-itinerario.pto-despacho
                        rowObject.pto-desembarque = tt-itinerario.pto-desembarque
                        rowObject.pto-chegada     = tt-itinerario.pto-chegada.
             end.
             else do:
                 assign i-seq-erro = i-seq-erro + 1.
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "Ponto(s)_de_controle_do_Itiner rio_nÆo_informado(s)" *}
                 run utp/ut-msgs.p (input "msg":U,
                                    input 17006,
                                    input RETURN-VALUE + ".").
                 create tt-bo-erro.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                 ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-o-itinerario-nao-possui-um-dos AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "O_Itiner rio_nÆo_possui_um_dos_pontos_de_controles_(embarque,_despacho_ou_desembarque)_cadastrados" *}
                 ASSIGN c-lbl-liter-o-itinerario-nao-possui-um-dos = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-essa-informacao-pode-ser-consu AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Essa_informa‡Æo_pode_ser_consultada/cadastrada_no_programa_'Cadastro_Itiner rios'(cd2567)" *}
                 ASSIGN c-lbl-liter-essa-informacao-pode-ser-consu = TRIM(RETURN-VALUE).
                 assign tt-bo-erro.i-sequen   = i-seq-erro
                        tt-bo-erro.cd-erro    = 17006
                        tt-bo-erro.mensagem   = c-lbl-liter
                        tt-bo-erro.errorhelp  = c-lbl-liter-o-itinerario-nao-possui-um-dos + '.'
                                              + c-lbl-liter-essa-informacao-pode-ser-consu.
             end.
         end. /* if rowObject.cod-itiner ... */
     END.
     ELSE DO: /* subprocesso de exporta‡Æo */
         FOR FIRST {&table-name} FIELDS(pto-despacho pto-embarque pto-desembarque pto-chegada) NO-LOCK
             WHERE {&table-name}.cod-estabel = RowObject.cod-estabel 
               AND {&table-name}.nr-proc-exp = c-processo-orig
               AND {&table-name}.cod-itiner  = RowObject.cod-itiner:
            ASSIGN RowObject.pto-embarque    = {&table-name}.pto-embarque
                   RowObject.pto-despacho    = {&table-name}.pto-despacho
                   RowObject.pto-desembarque = {&table-name}.pto-desembarque
                   RowObject.pto-chegada     = {&table-name}.pto-chegada.
         END.
     END.

     /* Faz consistência na tabela controle de numera‡Æo dos processos
        de Exporta‡Æo, para ver se ‚ automático, se for, então  se não  
        for digitado nada, mostra a  próxima  sequência  e  atualiza a 
        última sequência e a próxima mais um. */
     
     /* Verifica se existe algum erro antes de gravar na tabela */

     find first tt-bo-erro no-lock no-error.
     if not avail tt-bo-erro then do:
         if not valid-handle(h-bocx180) then
             run cxbo/bocx180.p persistent set h-bocx180.

         run getNextSeq in h-bocx180 (input rowObject.cod-estabel,
                                      input-output rowObject.nr-proc-exp,
                                      output table tt-bo-erro).

         if  rowObject.nr-proc-exp = ? or rowObject.nr-proc-exp = "":U then do:
             assign i-seq-erro = i-seq-erro + 1.
             /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
             pre-processador em chamada de includes */
             {utp/ut-field.i mgcex processo-exp nr-proc-exp 1}
             /******************************************/
             create tt-bo-erro.
             assign tt-bo-erro.parametros = return-value.        
             run utp/ut-msgs.p (input "msg":U,
                                input 265,
                                input return-value).
             assign tt-bo-erro.i-sequen     = i-seq-erro
                    tt-bo-erro.cd-erro      = 265
                    tt-bo-erro.mensagem     = return-value.
         end.

         run beforeCreateRecord in this-procedure.
         if not can-find(first tt-bo-erro) then do:
             
             FOR FIRST param-exp
                 WHERE param-exp.cod-estabel = rowObject.cod-estabel NO-LOCK: END.
    
             IF AVAIL param-exp AND TRIM(SUBSTRING(param-exp.char-1,33,1)) = "":U OR TRIM(SUBSTRING(param-exp.char-1,33,1)) = "1":U THEN DO:
                 IF NOT VALID-HANDLE(h-exapi025) THEN
                     RUN exp/exapi025.p PERSISTENT SET h-exapi025.

                 RUN pi-salva-valor-antigo IN h-exapi025(INPUT "processo-exp":U, INPUT ?).
             END.
             
             RUN executeCreate.
             
             ASSIGN r-chave = to-rowid(return-value)
                    rowObject.r-rowid    = TO-ROWID(RETURN-VALUE) /* Seta o valor do campo Rowid com o rowid retornado da inser‡Æo */
                    lAlteracaoItinerario = YES. 

             IF AVAIL param-exp THEN DO:
                IF lAlteracaoItinerario AND NOT CAN-FIND(FIRST tt-bo-erro) AND param-exp.log-permite-alter-itiner THEN do: /* Se alterou itiner rio */
                    RUN pi-elimina-historico-despesas-declaracoes.					
				end.
    
                /* Se o parƒmero de gerar log da tabela processo-exp estiver selecionado */
                IF TRIM(SUBSTRING(param-exp.char-1,33,1)) = "":U OR TRIM(SUBSTRING(param-exp.char-1,33,1)) = "1":U THEN DO:
                    {utp/ut-liter.i "Cria‡Æo"}
                    RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
                END.
             END.

             if not valid-handle(h-bocx200) then
                 RUN cxbo/bocx200.p persistent set h-bocx200.
             run pi-recebe-idioma in h-bocx200 (input c-cod-idiom-usuar).
             IF l-subprocesso THEN DO:
                 RUN pi-seta-process-orig         IN h-bocx200 (INPUT c-processo-orig).
                 RUN pi-seta-l-ex0200-proces-orig IN h-bocx200 (INPUT l-ex0200-proces-orig).
             END.

             run GenerateTable in h-bocx200 (input table rowObject, output table tt-bo-erro).
             FIND FIRST tt-bo-erro NO-ERROR.
             
             IF AVAIL tt-bo-erro then DO:
                 /* tt-bo-erro.cd-erro = 2118 */                  
                 RUN executeDelete.
             END.

         end. /* if not can-find ... */        
     end.   /* if not avail tt-bo-erro */
END PROCEDURE.

PROCEDURE executeCreate:
     /*  Cria registro na tabela.  */
     create {&TABLE-NAME}.
     buffer-copy RowObject except r-rowid to {&TABLE-NAME}.

     /* Lê o Processo Exporta‡Æo que acabou de gravar na tabela
        e faz uma cópia para poder passar como parâmetro na cha-
        mada da bocx200, e gerar automáticamente os pontos do i-
        tinerário e as despesas dos pontos de itinerário.     */
     return string(rowid({&TABLE-NAME})).   
END PROCEDURE.

PROCEDURE executeUpdate:
    /*  Executa Update   */
    if {&TABLE-NAME}.cod-sit-proc <> 3 and
       {&TABLE-NAME}.cod-sit-proc <> 4 then do:
        buffer-copy RowObject except r-rowid cod-estabel nr-proc-exp 
            dt-aceita-prof to {&TABLE-NAME}. 
    end.
    else do:
        IF {&TABLE-NAME}.cod-sit-proc = 3 THEN DO:
            buffer-copy RowObject except r-rowid cod-estabel nr-proc-exp 
                cod-origem-proc cod-incoterm cod-idioma
                dt-val-prof dt-aceita-prof cod-fabric int-1 dec-1  to {&TABLE-NAME}.
        END.
        ELSE DO:
            buffer-copy RowObject except r-rowid cod-estabel nr-proc-exp 
                cod-origem-proc cod-incoterm cod-idioma dt-prev-ex-factory
                dt-val-prof dt-aceita-prof cod-fabric int-1 dec-1  to {&TABLE-NAME}.
        END.
    end.
    
    RETURN "OK":U.

END PROCEDURE.

procedure executeDelete:
    /***  Executa Delete*/
    for each  historico-proc-exp exclusive-lock
        where historico-proc-exp.cod-estabel = {&TABLE-NAME}.cod-estabel
        and   historico-proc-exp.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp
        and   historico-proc-exp.cod-itiner  = {&TABLE-NAME}.cod-itiner:
        for each  proc-desp-itiner exclusive-lock
            where proc-desp-itiner.cod-estabel   = historico-proc-exp.cod-estabel
            and   proc-desp-itiner.nr-proc-exp   = historico-proc-exp.nr-proc-exp
            and   proc-desp-itiner.cod-itiner    = historico-proc-exp.cod-itiner
            and   proc-desp-itiner.sequencia     = historico-proc-exp.sequencia
            and   proc-desp-itiner.cod-pto-contr = historico-proc-exp.cod-pto-contr:
            delete proc-desp-itiner.
        end.
        for each  decl-hist-proc-exp exclusive-lock
            where decl-hist-proc-exp.cod-estabel = historico-proc-exp.cod-estabel
            and   decl-hist-proc-exp.nr-proc-exp = historico-proc-exp.nr-proc-exp
            and   decl-hist-proc-exp.cod-itiner  = historico-proc-exp.cod-itiner
            and   decl-hist-proc-exp.sequencia   = historico-proc-exp.sequencia:
            delete decl-hist-proc-exp.
        end.
        delete historico-proc-exp.     
    end.
    for each proc-siscomex exclusive-lock
        where proc-siscomex.cod-estabel = {&TABLE-NAME}.cod-estabel
        and   proc-siscomex.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-siscomex.
    end.  
     
    for each proc-container exclusive-lock
        where proc-container.cod-estabel = {&TABLE-NAME}.cod-estabel
        and   proc-container.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
           
        delete proc-container.
    end.
    
    for each docs-processo-exp exclusive-lock
        where docs-processo-exp.cod-estabel = {&TABLE-NAME}.cod-estabel
        and   docs-processo-exp.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete docs-processo-exp.
    end.
    
    for each proc-docto-export exclusive-lock
        where proc-docto-export.cod-estabel = {&TABLE-NAME}.cod-estabel 
          and proc-docto-export.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-docto-export.
    end.
    
    for each proc-container-emb exclusive-lock
       where proc-container-emb.cod-estabel = {&TABLE-NAME}.cod-estabel  
         and proc-container-emb.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:      
         delete proc-container-emb.
    end.      
    
    for each proc-it-nota-fisc exclusive-lock
       where proc-it-nota-fisc.cod-estabel = {&TABLE-NAME}.cod-estabel  
         and proc-it-nota-fisc.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp: 
        delete proc-it-nota-fisc.
    end.    

    for each proc-nota-fiscal exclusive-lock
       where proc-nota-fiscal.cod-estabel = {&TABLE-NAME}.cod-estabel  
         and proc-nota-fiscal.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp: 
        delete proc-nota-fiscal.
    end.
    
    for each proc-ped-ent exclusive-lock
       where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-ped-ent.
    end.    
    
    for each proc-ped-venda exclusive-lock
       where proc-ped-venda.cod-estabel = {&TABLE-NAME}.cod-estabel  
         and proc-ped-venda.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp: 
        delete proc-ped-venda. 
    end.       

    for each proces-exp-adic exclusive-lock
        where proces-exp-adic.cod-estabel = {&TABLE-NAME}.cod-estabel
        and   proces-exp-adic.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
           
        delete proces-exp-adic.
    end.

    for each  proc-docto-export exclusive-lock
        where proc-docto-export.cod-estabel = {&TABLE-NAME}.cod-estabel   
          and proc-docto-export.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:  
        delete proc-docto-export.
    end.

    for each  proc-export-atualiz-exec exclusive-lock
        where proc-export-atualiz-exec.cod-estabel = {&TABLE-NAME}.cod-estabel  
          and proc-export-atualiz-exec.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp: 
        delete proc-export-atualiz-exec.
    end.

    for each  proc-export-atualiz-log exclusive-lock
        where proc-export-atualiz-log.cod-estabel = {&TABLE-NAME}.cod-estabel   
          and proc-export-atualiz-log.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:  
        delete proc-export-atualiz-log.
    end.

    for each  proc-export-atualiz-msg exclusive-lock
        where proc-export-atualiz-msg.cod-estabel = {&TABLE-NAME}.cod-estabel   
          and proc-export-atualiz-msg.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:  
        delete proc-export-atualiz-msg.
    end.

    for each  proc-export-ctbz exclusive-lock
        where proc-export-ctbz.cod-estabel = {&TABLE-NAME}.cod-estabel 
          and proc-export-ctbz.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-export-ctbz.
    end.

    for each  proc-export-ctbz-ifrs exclusive-lock
        where proc-export-ctbz-ifrs.cod-estabel       = {&TABLE-NAME}.cod-estabel 
          and proc-export-ctbz-ifrs.cod-proces-export = {&TABLE-NAME}.nr-proc-exp:
        delete proc-export-ctbz-ifrs.
    end.

    for each proc-it-nota-desp exclusive-lock
       where proc-it-nota-desp.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proc-it-nota-desp.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-it-nota-desp.
    end.

    for each proc-lote-ped-ent exclusive-lock
        where proc-lote-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel 
          and proc-lote-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-lote-ped-ent.
    end.

    for each proc-ped-ent-desp exclusive-lock
       where proc-ped-ent-desp.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proc-ped-ent-desp.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proc-ped-ent-desp.
    end.

    for each proces-acond exclusive-lock
       where proces-acond.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proces-acond.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proces-acond.
    end.

    for each proces-acond-item exclusive-lock
       where proces-acond-item.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proces-acond-item.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proces-acond-item.
    end.

    for each proces-acond-volum exclusive-lock
       where proces-acond-volum.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proces-acond-volum.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proces-acond-volum.
    end.

    for each proces-embal-resum exclusive-lock
       where proces-embal-resum.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proces-embal-resum.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proces-embal-resum.
    end.

    for each proces-embal-volum exclusive-lock
       where proces-embal-volum.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and proces-embal-volum.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete proces-embal-volum.
    end.

    for each reg-export exclusive-lock
       where reg-export.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and reg-export.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete reg-export.
    end.

    for each reg-export-item exclusive-lock
       where reg-export-item.cod-estabel = {&TABLE-NAME}.cod-estabel 
         and reg-export-item.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        delete reg-export-item.
    end.
    
    FOR EACH proces-export-relacdo EXCLUSIVE-LOCK
       WHERE proces-export-relacdo.cod-estabel = {&TABLE-NAME}.cod-estabel
         AND proces-export-relacdo.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:
        DELETE proces-export-relacdo.
    END.

    delete {&TABLE-NAME}.
END PROCEDURE.    

procedure getTtReProc:

    def input  param pcCodEstabel as char format "x(03)" no-undo.
    def input  param pcNrProcExp  as char format "x(12)" no-undo.
    def output param table for tt-reg-export-aux.

    empty temp-table tt-reg-export-aux.

    for each  proc-ped-ent fields(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega)
        where proc-ped-ent.cod-estabel = pcCodEstabel
          and proc-ped-ent.nr-proc-exp = pcNrProcExp no-lock,
        each  reg-export-item fields(nr-re-ems)
        where reg-export-item.cod-estabel = pcCodEstabel
          and reg-export-item.nr-proc-exp = pcNrProcExp
          and reg-export-item.nome-abrev  = proc-ped-ent.nome-abrev
          and reg-export-item.nr-pedcli   = proc-ped-ent.nr-pedcli
          and reg-export-item.num-seq     = proc-ped-ent.nr-sequencia
          and reg-export-item.it-codigo   = proc-ped-ent.it-codigo
          and reg-export-item.cod-refer   = proc-ped-ent.cod-refer
          and reg-export-item.nr-entrega  = proc-ped-ent.nr-entrega no-lock:
        if  not can-find(first tt-reg-export-aux
                         where tt-reg-export-aux.nr-re-ems = reg-export-item.nr-re-ems) then
            for first reg-export fields(nr-re-siscomex dat-reg-export idi-sit-reg-export dat-envio cod-solicit-despa dat-solicit-despa dat-averb)
                where reg-export.nr-re-ems = reg-export-item.nr-re-ems no-lock:
                create tt-reg-export-aux.
                assign tt-reg-export-aux.cod-estabel       = pcCodEstabel
                       tt-reg-export-aux.nr-proc-exp       = pcNrProcExp
                       tt-reg-export-aux.nr-re-ems         = reg-export-item.nr-re-ems
                       tt-reg-export-aux.nr-re-siscomex    = reg-export.nr-re-siscomex
                       tt-reg-export-aux.dat-reg-export    = reg-export.dat-reg-export
                       tt-reg-export-aux.sit-re            = {cxinc/i03cx347.i 04 reg-export.idi-sit-reg-export} 
                       tt-reg-export-aux.dat-envio         = reg-export.dat-envio
                       tt-reg-export-aux.cod-solicit-despa = reg-export.cod-solicit-despa
                       tt-reg-export-aux.dat-solicit-despa = reg-export.dat-solicit-despa
                       tt-reg-export-aux.dat-averb         = reg-export.dat-averb
                       tt-reg-export-aux.r-rowid           = rowid(reg-export).
            end.
    end.
end procedure.

PROCEDURE initializeValidate:
    /*  Inicializa Validate */
END PROCEDURE.

PROCEDURE validateinitialize:
    def input parameter p-estabel  like processo-exp.cod-estabel no-undo.
    def input parameter p-proc-exp like processo-exp.nr-proc-exp no-undo.
    def input parameter p-nome     like processo-exp.cod-emitente  no-undo.
    def input parameter p-notif    like processo-exp.cod-notif   no-undo.
    def input parameter p-consign  like processo-exp.cod-consign no-undo.
    def output parameter table for tt-bo-erro.

    run validateEstabel  (input p-estabel).
    run validateProcExp  (input p-estabel,
                          input-output p-proc-exp). 

    find first processo-exp no-lock
         where processo-exp.cod-estabel = p-estabel
         and   processo-exp.nr-proc-exp = p-proc-exp no-error.

    if avail processo-exp then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
        pre-processador em chamada de includes */ 
        {utp/ut-table.i mgcex processo-exp 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 8,
                           input return-value).   
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 8
               tt-bo-erro.mensagem = return-value.                            
    end.

    find first tt-bo-erro no-error.
    if not avail tt-bo-erro then do:
        run validateEmitente (input p-nome). 
        run validateNotif    (input p-notif). 
    end.
end procedure.

PROCEDURE initializeFields:
    def input-output  parameter table for RowObject.
END PROCEDURE.

PROCEDURE validateEstabel:
    def input parameter p-cod-estabel  like processo-exp.cod-estabel no-undo.
    if not can-find(estabelec where estabelec.cod-estabel = p-cod-estabel) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
        pre-processador em chamada de includes */
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
          
    end.
    else do:
        find first param-exp no-lock 
             where param-exp.cod-estabel = p-cod-estabel no-error.
        if not avail param-exp then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-field.i mgcex param-exp cod-estabel 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
            leave.
        end.
    end.
END PROCEDURE.

PROCEDURE validateProcExp:
    def input parameter p-cod-estabel  like processo-exp.cod-estabel no-undo.
    def input-output parameter p-proc-exp  like processo-exp.nr-proc-exp no-undo.

    find first rowObject NO-LOCK no-error.
    if avail rowObject then do:
        for each tt-bo-erro2:
            delete tt-bo-erro2.
        end.
        if not valid-handle(h-bocx180) then
            run cxbo/bocx180.p persistent set h-bocx180.
        run getNextSeq in h-bocx180 (input p-cod-estabel,
                                     input-output p-proc-exp,
                                     output table tt-bo-erro2).
        for each tt-bo-erro2:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = tt-bo-erro2.cd-erro
                   tt-bo-erro.mensagem = tt-bo-erro2.mensagem.
        end.
    end.
END PROCEDURE.

Procedure ValidateItinerario:
    if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
        pre-processador em chamada de includes */
        {utp/ut-liter.i Itinerario * R}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,  /* Não encontrado(a) &1, para a chave informada*/
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2  /* Não encontrado(a) &1, para a chave informada*/
               tt-bo-erro.mensagem = return-value.
    end.
END PROCEDURE.

Procedure ValidateCondPagto:

    if rowObject.cod-cond-pagto <> 0 and
       not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cod-cond-pagto) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
        pre-processador em chamada de includes */
        {utp/ut-liter.i Condi‡Æo_de_Pagamento * R}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,  /* Não encontrado(a) &1, para a chave informada*/
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2  /* Não encontrado(a) &1, para a chave informada*/
               tt-bo-erro.mensagem = return-value.
    end.
    IF NOT AVAIL bf-param-exp THEN
        FOR FIRST bf-param-exp FIELDS(char-1) NO-LOCK
            WHERE bf-param-exp.cod-estabel = rowObject.cod-estabel:
        END.

    IF AVAIL bf-param-exp THEN DO:

        /*Integra‡Æo Mais Neg¢cios*/    
        if v_log_integr_mng then do:
           IF bf-param-exp.log-ctblz-recta-embarq THEN DO:
              if can-find(first cond-pagto
                          where cond-pagto.cod-cond-pag = rowObject.cod-cond-pagto
                            and &IF "{&product_version}" >= "12.1.V" /* 12.1.32 */
                                &THEN cond-pagto.log-cond-pagto-mais-negoc
                                &ELSE TRIM(substring(cond-pagto.char-1,70,1)) = "S":U
                                &ENDIF ) then do:
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-liter.i Condi‡Æo_de_Pagamento *}
                 assign c-lit-help1 = trim(return-value).
                 {utp/ut-liter.i Somente_‚_permitido_informar_Condi‡Æo_de_Pagamento_Mais_Neg¢cios_quando_a_Contabiliza‡Æo_nÆo_‚_reconhecida_no_momento_do_embarque_da_mercadoria. *}
                 assign c-lit-help2 = trim(return-value).
                 create tt-bo-erro.
                 assign tt-bo-erro.i-sequen  = i-seq-erro
                        tt-bo-erro.cd-erro   = 31743
                        tt-bo-erro.mensagem  = c-lit-help1
                        tt-bo-erro.errorhelp = c-lit-help2.
              end.
           end.
        END.                    
        
        EMPTY TEMP-TABLE tt-ped-msg.
        FOR EACH proc-ped-venda NO-LOCK
           WHERE proc-ped-venda.cod-estabel = rowObject.cod-estabel
             AND proc-ped-venda.nr-proc-exp = rowObject.nr-proc-exp:
            FIND FIRST ped-venda
                 WHERE ped-venda.nome-abrev = proc-ped-venda.nome-abrev 
                   AND ped-venda.nr-pedcli  = proc-ped-venda.nr-pedcli  NO-LOCK NO-ERROR.
            IF AVAIL ped-venda
            AND ped-venda.cod-cond-pag <> rowObject.cod-cond-pagto THEN DO:
                IF NOT CAN-FIND(FIRST tt-ped-msg) THEN
                   CREATE tt-ped-msg.
                ASSIGN tt-ped-msg.nr-pedcli = tt-ped-msg.nr-pedcli + (IF tt-ped-msg.nr-pedcli <> "" THEN ", ":U ELSE "") + ped-venda.nr-pedcli.
            END.
        END.

        IF CAN-FIND(FIRST tt-ped-msg) THEN DO:
            {utp/ut-liter.i Cond_Pagto_do_Processo * }
            ASSIGN c-liter1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Cond_Pagto_do(s)_Pedido(s) * r}
            ASSIGN c-liter2 = TRIM(RETURN-VALUE).

            IF (SUBSTRING(bf-param-exp.char-1,22,1) = "1" OR SUBSTRING(bf-param-exp.char-1,22,1) = "") THEN DO: /*nÆo bloqueia condi‡Æo de pagamento diferente entre pedido x processo*/
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 55477,
                                   INPUT c-liter1 + "~~" + c-liter2).
                ASSIGN i-seq-erro = i-seq-erro + 1.
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 55477
                       tt-bo-erro.errorSubType = "WARNING":U
                       tt-bo-erro.mensagem     = RETURN-VALUE.

                FOR FIRST tt-ped-msg:
                END.
                RUN utp/ut-msgs.p (INPUT "help",
                                   INPUT 55477, 
                                   INPUT RETURN-VALUE + "~~~~" + tt-ped-msg.nr-pedcli).
            
                ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.


            END.
            ELSE DO: /*bloqueia condi‡Æo de pagamento do processo diferente do pedido de venda*/
                ASSIGN i-seq-erro = i-seq-erro + 1.
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 55478,
                                   INPUT c-liter1 + "~~" + c-liter2).
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro                   
                       tt-bo-erro.cd-erro  = 55478
                       tt-bo-erro.mensagem = RETURN-VALUE.   

                FOR FIRST tt-ped-msg:
                END.

                RUN utp/ut-msgs.p (INPUT "help",
                                   INPUT 55478, 
                                   INPUT RETURN-VALUE + "~~~~" + tt-ped-msg.nr-pedcli).
                ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE validateEmitente:
    def input parameter p-cod-emitente  like processo-exp.cod-emitente no-undo.
    def var c-impor   as char format "x(11)" no-undo.
    def var c-cliente as char format "x(07)" no-undo.

    find first emitente no-lock
         where emitente.cod-emitente = p-cod-emitente no-error.
    if avail emitente then do:
        if emitente.identific  = 2  then do:
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Importador * R}
            assign c-impor  = return-value.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
               pre-processador em chamada de includes */
            {utp/ut-liter.i Cliente * R}
            assign c-cliente = return-value.

            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 17167,
                               input c-impor + "~~" + c-cliente).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17167
                   tt-bo-erro.mensagem = return-value.
        end.
        if emitente.natureza = 1 or emitente.natureza = 2 then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Importador * R}
            assign c-impor  = return-value.
            run utp/ut-msgs.p (input "msg":U,
                               input 17122,
                               input c-impor).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17122
                   tt-bo-erro.mensagem = return-value.
        end.
    end.
    else do:
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
        pre-processador em chamada de includes */
        assign i-seq-erro = i-seq-erro + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_Importador" *}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input RETURN-VALUE).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.
end procedure.

PROCEDURE validateNotif:
    def input parameter p-cod-notif  like processo-exp.cod-notif no-undo.
    def var c-notif     as char format "x(12)" no-undo.
    def var c-cliente   as char format "x(08)" no-undo.

    if p-cod-notif > 0 then do:
        find first emitente no-lock
             where emitente.cod-emitente = p-cod-notif no-error.
        if not avail emitente then do:   
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
             {utp/ut-liter.i Notificado * R}
             assign i-seq-erro = i-seq-erro + 1.
             run utp/ut-msgs.p (input "msg":U,
                                input 2,
                                input return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.
        end.
    end.
end procedure.

PROCEDURE validateConsign:   
    def input parameter p-cod-consign  like processo-exp.cod-consign no-undo.
    def var c-consign  as char format "x(15)" no-undo.
    def var c-cliente as char format "x(12)" no-undo.

    if p-cod-consign > 0 then do:
        find first emitente no-lock
             where emitente.cod-emitente = p-cod-consign no-error.
        if avail emitente then do:
            if emitente.identific  = 2  then do:
                /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
                pre-processador em chamada de includes */
                {utp/ut-liter.i Consignat rio * R}
                assign c-consign  = return-value.
                /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
                   pre-processador em chamada de includes */
                {utp/ut-liter.i Cliente * R}
                assign c-cliente = return-value.
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg":U,
                                   input 17167,
                                   input c-consign + "~~" + c-cliente).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 17167
                       tt-bo-erro.mensagem = return-value.
            end.
            if emitente.natureza =  1  or emitente.natureza =  2  then do:
                assign i-seq-erro = i-seq-erro + 1.
                /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
                pre-processador em chamada de includes */
                {utp/ut-liter.i Consignat rio * R}
                run utp/ut-msgs.p (input "msg":U,
                                   input 17122,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 17122
                       tt-bo-erro.mensagem = return-value.
            end.
        end.
        else do:
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */ 
            {utp/ut-field.i mgcex processo-exp cod-consign 1}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
    end.
end procedure.

PROCEDURE UpdatePriceWeight:
    def input-output parameter table for tt-valores.
    def var de-peso-liq-tot   as decimal no-undo.
    def var de-peso-bruto-tot as decimal no-undo.

    find first tt-valores no-error.

    run exp/exapi004.p (input-output table tt-valores).
    
    find first tt-valores no-error.
    if avail tt-valores then do:

        if de-peso-liq-tot = 0 then  
            assign tt-valores.peso-liq-tot = tt-valores.peso-liq-tot.
        else
            assign tt-valores.peso-liq-tot = de-peso-liq-tot.

        if de-peso-bruto-tot = 0 then
            assign tt-valores.peso-bruto-tot   = tt-valores.peso-bruto-tot.
        else
            assign tt-valores.peso-bruto-tot = de-peso-bruto-tot.  
    end.
END PROCEDURE.

/*
 Calcula o peso dos acondicionamentos de um processo de exporta‡Æo
 Input: pc-cod-estabel: c¢digo estabelecimento
        pc-nr-proc-exp: n£mero do processo de exporta‡Æo
 Output: tt-valores-acond: temp-table com os pesos dos acondicionamentos do processo de exporta‡Æo
*/
PROCEDURE UpdateWeightAcond:

    DEF INPUT PARAM pc-cod-estabel  LIKE processo-exp.cod-estabel NO-UNDO.
    DEF INPUT PARAM pc-nr-proc-exp  LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-valores-acond.

    DEF VAR de-peso-liq-unit    LIKE ITEM.peso-liquido NO-UNDO.
    DEF VAR de-peso-bruto-unit  LIKE ITEM.peso-bruto   NO-UNDO.
    DEF VAR de-peso-total-acond-liq   LIKE ITEM.peso-liquido NO-UNDO.
    DEF VAR de-peso-total-acond-bruto LIKE ITEM.peso-bruto   NO-UNDO.

    EMPTY TEMP-TABLE tt-valores-acond.

    FOR EACH  processo-exp NO-LOCK
        WHERE processo-exp.cod-estabel = pc-cod-estabel
        AND   processo-exp.nr-proc-exp = pc-nr-proc-exp:
    
        FOR EACH  proces-acond NO-LOCK
            WHERE proces-acond.cod-estabel = processo-exp.cod-estabel
            AND   proces-acond.nr-proc-exp = processo-exp.nr-proc-exp
            BREAK BY proces-acond.cod-acond:
    
            IF FIRST-OF(proces-acond.cod-acond) THEN DO:
                CREATE tt-valores-acond.
                ASSIGN tt-valores-acond.cod-estabel     = proces-acond.cod-estabel
                       tt-valores-acond.nr-proc-exp     = proces-acond.nr-proc-exp
                       tt-valores-acond.cod-acond       = proces-acond.cod-acond
                       tt-valores-acond.peso-liq-tot    = 0
                       tt-valores-acond.peso-bruto-tot  = 0.
            END.
            
            FIND FIRST tt-valores-acond
                WHERE tt-valores-acond.cod-estabel     = proces-acond.cod-estabel
                AND   tt-valores-acond.nr-proc-exp     = proces-acond.nr-proc-exp
                AND   tt-valores-acond.cod-acond       = proces-acond.cod-acond NO-ERROR.
            IF AVAIL tt-valores-acond THEN DO:
            
                FOR EACH  proces-acond-volum NO-LOCK
                    WHERE proces-acond-volum.cod-estabel = proces-acond.cod-estabel
                    AND   proces-acond-volum.nr-proc-exp = proces-acond.nr-proc-exp
                    AND   proces-acond-volum.cod-acond   = proces-acond.cod-acond:
        
                    FOR EACH  proces-embal-resum NO-LOCK
                        WHERE proces-embal-resum.cod-estabel     = proces-acond-volum.cod-estabel
                        AND   proces-embal-resum.nr-proc-exp     = proces-acond-volum.nr-proc-exp
                        AND   proces-embal-resum.cod-acond       = proces-acond-volum.cod-acond
                        AND   proces-embal-resum.num-volum-acond = proces-acond-volum.num-volum-acond:
                        
                        FOR FIRST embalag NO-LOCK
                            WHERE embalag.sigla-emb = proces-embal-resum.sigla-emb
                            AND   NOT embalag.log-embal-oculta:
                            ASSIGN tt-valores-acond.peso-bruto-tot = tt-valores-acond.peso-bruto-tot + (embalag.peso-embal * proces-embal-resum.qti-volum).
                        END.
                    END.
        
                    FOR FIRST embalag NO-LOCK
                        WHERE embalag.sigla-emb = proces-acond-volum.sigla-emb-pai
                        AND   NOT embalag.log-embal-oculta:
                        ASSIGN tt-valores-acond.peso-bruto-tot = tt-valores-acond.peso-bruto-tot + embalag.peso-embal.
                    END.
		  END.
				
		  for each proc-ped-ent no-lock
		     where proc-ped-ent.cod-estabel  = proces-acond.cod-estabel
                     AND   proc-ped-ent.nr-proc-exp  = proces-acond.nr-proc-exp:
							
		     IF proc-ped-ent.ind-componen <> 3 THEN DO: /* Componente de Configurado */        
                         /* Calcula o peso unit rio dos itens do pedido. */
                         IF proc-ped-ent.idi-unid-fatur = 1 THEN
                             ASSIGN de-peso-liq-unit   = proc-ped-ent.peso-liquido / proc-ped-ent.quantidade[1]
                                    de-peso-bruto-unit = proc-ped-ent.peso-bruto   / proc-ped-ent.quantidade[1].
                         ELSE
                             ASSIGN de-peso-liq-unit   = proc-ped-ent.peso-liquido / proc-ped-ent.quantidade[2]
                                    de-peso-bruto-unit = proc-ped-ent.peso-bruto   / proc-ped-ent.quantidade[2].
                
    			 FOR EACH proces-embal-volum no-lock
    			     WHERE proces-embal-volum.nome-abrev   = proc-ped-ent.nome-abrev  
    			     AND   proces-embal-volum.nr-pedcli    = proc-ped-ent.nr-pedcli   
    			     AND   proces-embal-volum.nr-sequencia = proc-ped-ent.nr-sequencia
    			     AND   proces-embal-volum.it-codigo    = proc-ped-ent.it-codigo   
    			     AND   proces-embal-volum.cod-refer    = proc-ped-ent.cod-refer   
    			     AND   proces-embal-volum.nr-entrega   = proc-ped-ent.nr-entrega 
					 AND   proces-embal-volum.cod-acond    = proces-acond.cod-acond:
    			     ASSIGN tt-valores-acond.peso-liq-tot   = tt-valores-acond.peso-liq-tot   + (de-peso-liq-unit   * proces-embal-volum.qtd-embal).
                                    tt-valores-acond.peso-bruto-tot = tt-valores-acond.peso-bruto-tot + (de-peso-bruto-unit * proces-embal-volum.qtd-embal).
                         END.                           
		      END.
	          end.
	      END.
        END.
    END.
    /* Totaliza o peso do acondicionamento */
    FOR EACH tt-valores-acond:
        ASSIGN de-peso-total-acond-liq   = de-peso-total-acond-liq   + tt-valores-acond.peso-liq-tot  
               de-peso-total-acond-bruto = de-peso-total-acond-bruto + tt-valores-acond.peso-bruto-tot.
    END.
    /* Guarda o total geral do acondicionamento em todos os registros da tt-valores-acond */
    FOR EACH tt-valores-acond:
        ASSIGN tt-valores-acond.peso-liq-tot-acond   = de-peso-total-acond-liq
               tt-valores-acond.peso-bruto-tot-acond = de-peso-total-acond-bruto.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE reativaPedidos:  
    /* Valida a situa‡Æo do Processo Exporta‡Æo 
    antes de executar a reativa‡Æo */
    def input  parameter table for rowObject.
    def input  parameter c-usuario-corren as char.
    def output parameter table for tt-bo-erro.

    &if defined(bf_comex206b-1) &then   
        def var l-proc-ped-ent-susp as log no-undo.
    &endif
    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    assign c-seg-usuario = c-usuario-corren.

    IF NOT VALID-HANDLE(h-bocx195) THEN
       RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.

    run findTable.
    /* Para Reativar o Processo de Exporta‡Æo, a situa‡Æo 
    deverá estar igual a suspenso */
    if avail {&TABLE-NAME} and not l-proc-canc then do:
        if {&TABLE-NAME}.cod-sit-proc <> 5 then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i reativa‡Æo * l}
            run utp/ut-msgs.p (input "msg":U,
                               input 17148,
                               input return-value).

            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17148
                   tt-bo-erro.mensagem     = return-value
                   tt-bo-erro.parametros   = return-value.
        end.
        else do:             
            &if defined(bf_comex206b-1) &then
                find first tt-bo-erro no-error.
                 if not avail tt-bo-erro then /* Reativa o pedido */
                     run exp/exapi006.p (input table rowObject,
                                         output table tt-bo-erro,
                                         input 4).   /* Reativa */
            &else 
                for each  proc-ped-ent fields( nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega) no-lock
                    where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel 
                    and   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp :
                    /*TFMTNZ - Vipal*/
                    run calculaQuantidadeVinculada IN  h-bocx195 (INPUT  proc-ped-ent.nome-abrev   ,
                                                                  INPUT  proc-ped-ent.nr-pedcli    ,
                                                                  INPUT  proc-ped-ent.nr-sequencia ,
                                                                  INPUT  proc-ped-ent.it-codigo    ,
                                                                  INPUT  proc-ped-ent.cod-refer    ,
                                                                  INPUT  proc-ped-ent.nr-entrega   ,
                                                                  OUTPUT de-qt-vinculada).

                    IF NOT CAN-FIND (FIRST bf-ped-ent
                                     WHERE bf-ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                                       and bf-ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
                                       and bf-ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                                       and bf-ped-ent.it-codigo    = proc-ped-ent.it-codigo
                                       and bf-ped-ent.cod-refer    = proc-ped-ent.cod-refer
                                       and bf-ped-ent.nr-entrega   = proc-ped-ent.nr-entrega
                                       AND bf-ped-ent.qt-pedida    <> de-qt-vinculada) THEN DO:
                        ASSIGN l-erro-exapi006 = NO.
                    END.
                    ELSE DO:
                        assign i-seq-erro              = i-seq-erro + 1.
                        create tt-bo-erro.
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-pedido-de-venda-nao-foi-reativ AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Pedido_de_Venda_nÆo_foi_Reativado" *}
                        ASSIGN c-lbl-liter-pedido-de-venda-nao-foi-reativ = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-existem-quantidades-do-pedido AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Existem_quantidades_do_pedido_vinculadas_em_outros_processos_de_exporta‡Æo._A_reativa‡Æo_do_pedido_dever _ser_efetuada_pelas_rotinas_de_implanta‡Æo_de_pedidos" *}
                        ASSIGN c-lbl-liter-existem-quantidades-do-pedido = TRIM(RETURN-VALUE).
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 17006
                               tt-bo-erro.mensagem     = c-lbl-liter-pedido-de-venda-nao-foi-reativ
                               tt-bo-erro.errorhelp    = c-lbl-liter-existem-quantidades-do-pedido + "."
                               tt-bo-erro.errorsubtype = "Warning":U.
                        ASSIGN l-proc-ped-ent-susp  = NO
                               l-erro-exapi006 = YES.
                        LEAVE.
                    END.
                end.
                IF NOT l-erro-exapi006 THEN DO:
                    run exp/exapi006.p (input table rowObject,
                                        output table tt-bo-erro,
                                        input 4).   /* Reativa  */
                    IF  NOT CAN-FIND(FIRST tt-bo-erro) THEN
                        ASSIGN l-proc-ped-ent-susp  = NO.
                END.
                if not l-proc-ped-ent-susp then 
                    run atualizaSituacaoProcesso(input {&TABLE-NAME}.cod-estabel,
                                                 input {&TABLE-NAME}.nr-proc-exp).
            &endif
            find first tt-bo-erro no-lock no-error.
            if not avail tt-bo-erro
            OR (AVAIL tt-bo-erro AND tt-bo-erro.errorsubtype <> "warning":U )then do:
                /* Reativa o Processo de Exporta‡Æo */
                if  avail {&TABLE-NAME} then do:  
                    /* ----------- Chamada UPC ----------- */
                    &if defined(bf_dis_proc_ent) &then
                        for each  tt-epc
                            where tt-epc.cod-event = "GravaUsuarioReativaProc":U:
                            delete tt-epc.
                        end.
                        /*** Criacao do registro para temp-table tt-epc ***/
                        {include/i-epc200.i2 &CodEvent='"GravaUsuarioReativaProc"'
                                             &CodParameter='"row-processo"'
                                             &ValueParameter=string(ROWID(processo-exp))}
                        /*** Chamada do programa EPC ***/
                        {include/i-epc201.i "GravaUsuarioReativaProc"}
                    &endif
                    assign {&TABLE-NAME}.cod-sit-proc = 1.
                end.
            end.
        end.
    end.
    IF VALID-HANDLE(h-bocx195) THEN DO:
        DELETE PROCEDURE h-bocx195.
        ASSIGN h-bocx195 = ?.
    END.

    for each tt-ped-venda:
        delete tt-ped-venda.
    end.
END PROCEDURE.

PROCEDURE suspendePedidos:   
    /* Valida situa‡Æo antes de suspender */
    def input  parameter table for rowObject.
    def input  parameter c-usuario-corren as char.
    def output parameter table for tt-bo-erro.

    &if defined(bf_comex206b-1) &then   
        def var l-proc-ped-ent-susp as log no-undo.
    &endif

    assign i-seq-erro = 0. 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    assign c-seg-usuario = c-usuario-corren.
    run findTable.
    IF NOT VALID-HANDLE(h-bocx195) THEN
       RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.

    /* Para Suspender o Processo de Exporta‡Æo, a situa‡Æo 
    deverá estar em aberto, Aceito Cliente ou Faturado. */
    if avail {&TABLE-NAME} and not l-proc-canc then do:
        if {&TABLE-NAME}.cod-sit-proc > 2 then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i SuspensÆo * R}
            run utp/ut-msgs.p (input "msg":U,
                               input 17148,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.parametros   = return-value.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17148
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
            &if defined(bf_comex206b-1) &then
                /* Suspende o pedido */
                run exp/exapi006.p (input table rowObject,
                                    output table tt-bo-erro,
                                    input 5).   /* Suspende  */

                find first tt-bo-erro no-lock no-error.
                if not avail tt-bo-erro then do:
                    /* Suspende o Processo de Exporta‡Æo  */
                    if  avail {&TABLE-NAME} then do:
                        &if defined(bf_dis_proc_ent) &then
                            for each  tt-epc
                                where tt-epc.cod-event = "GravaUsuarioSuspendeProc":U:
                                delete tt-epc.
                            end.
                            /*** Criacao do registro para temp-table tt-epc ***/
                            {include/i-epc200.i2 &CodEvent='"GravaUsuarioSuspendeProc"'
                                                 &CodParameter='"row-processo"'
                                                 &ValueParameter=string(ROWID(processo-exp))}
                                                 
                            /*** Chamada do programa EPC ***/
                            {include/i-epc201.i "GravaUsuarioSuspendeProc"}
                        &endif
                        assign {&TABLE-NAME}.cod-sit-proc = 5.
                    end.
                end.
            &else
                /*TFMTNZ - Vipal*/
                for each  proc-ped-ent fields( nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega) no-lock
                    where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel 
                    and   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp :

                    run calculaQuantidadeVinculada IN h-bocx195 (INPUT  proc-ped-ent.nome-abrev   ,
                                                                 INPUT  proc-ped-ent.nr-pedcli    ,
                                                                 INPUT  proc-ped-ent.nr-sequencia ,
                                                                 INPUT  proc-ped-ent.it-codigo    ,
                                                                 INPUT  proc-ped-ent.cod-refer    ,
                                                                 INPUT  proc-ped-ent.nr-entrega   ,
                                                                 OUTPUT de-qt-vinculada).

                    IF NOT CAN-FIND (FIRST bf-ped-ent
                                     WHERE bf-ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                                       and bf-ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
                                       and bf-ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                                       and bf-ped-ent.it-codigo    = proc-ped-ent.it-codigo
                                       and bf-ped-ent.cod-refer    = proc-ped-ent.cod-refer
                                       and bf-ped-ent.nr-entrega   = proc-ped-ent.nr-entrega
                                       AND bf-ped-ent.qt-pedida    <> de-qt-vinculada) THEN DO:
                        ASSIGN l-erro-exapi006 = NO.
                    END.
                    ELSE DO:
                        ASSIGN l-proc-ped-ent-susp = NO
                               l-erro-exapi006 = YES.
                        LEAVE.
                    END.

                END.
                IF NOT l-erro-exapi006 THEN DO:

                    run exp/exapi006.p (input table rowObject,
                                        output table tt-bo-erro,
                                        input 5).   /* Suspende  */

                    IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                        ASSIGN l-proc-ped-ent-susp        = YES
                               {&TABLE-NAME}.cod-sit-proc = 5.
                    END.

                END.

                IF  NOT CAN-FIND(FIRST tt-bo-erro) 
                AND NOT l-proc-ped-ent-susp THEN DO:
                    assign {&TABLE-NAME}.cod-sit-proc = 5.

                    assign i-seq-erro              = i-seq-erro + 1.
                    create tt-bo-erro.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-pedido-de-venda-nao-foi-suspen AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Pedido_de_Venda_nÆo_foi_Suspenso" *}
                    ASSIGN c-lbl-liter-pedido-de-venda-nao-foi-suspen = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-existem-quantidades-do-pedido-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Existem_quantidades_do_pedido_vinculadas_em_outros_processos_de_exporta‡Æo._A_suspensÆo_do_pedido_dever _ser_efetuada_pelas_rotinas_de_implanta‡Æo_de_pedidos" *}
                    ASSIGN c-lbl-liter-existem-quantidades-do-pedido-2 = TRIM(RETURN-VALUE).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17006
                           tt-bo-erro.mensagem     = c-lbl-liter-pedido-de-venda-nao-foi-suspen
                           tt-bo-erro.errorhelp    = c-lbl-liter-existem-quantidades-do-pedido-2 + "."
                           tt-bo-erro.errorsubtype = "Warning":U.
                END.

            &endif
        end.
    end.
    IF VALID-HANDLE(h-bocx195) THEN DO:
        DELETE PROCEDURE h-bocx195.
        ASSIGN h-bocx195 = ?.
    END.
    for each tt-ped-venda:
        delete tt-ped-venda.
    end.
END PROCEDURE.

PROCEDURE cancelaPedidos: 
    /* executar o cancelamento */
    def input  parameter table for rowObject.
    def input  parameter c-usuario-corren as char.
    def output parameter table for tt-bo-erro.

    &if defined(bf_comex206b-1) &then
        def input parameter pc-cod-estabel like estabelec.cod-estabel    no-undo.
        def input parameter pc-nr-proc-exp like processo-exp.nr-proc-exp no-undo.
        define variable pde-quantidade     as decimal                    no-undo.
        define variable de-qt-alocada      as decimal                    no-undo.
        define variable l-embarque-alocado as log                        no-undo.

        if not valid-handle(h-bocx195) then
            run cxbo/bocx195.p persistent set h-bocx195.
    &endif
    
    EMPTY TEMP-TABLE tt-proc-ped-ent-aux1.
    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    assign c-seg-usuario = c-usuario-corren.
    run findTable.
    find first rowObject NO-LOCK no-error.

    cancelamento:
    do trans:
        if avail {&TABLE-NAME} and not l-proc-canc then do:
            if {&TABLE-NAME}.cod-sit-proc <> 1 and
               {&TABLE-NAME}.cod-sit-proc <> 7 then do:
                assign i-seq-erro = i-seq-erro + 1.
                /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
                pre-processador em chamada de includes */
                {utp/ut-liter.i cancelamento * l}
                run utp/ut-msgs.p (input "msg":U,
                                   input 17148,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 17148
                       tt-bo-erro.mensagem     = return-value.
            end.
            else do:
                &if defined(bf_comex206b-1) &then
                    for each  proc-ped-ent no-lock 
                        where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
                        and   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:

                        run calculaQuantidadeAlocada  in h-bocx195 (input  proc-ped-ent.nr-proc-exp,
                                                                    input  proc-ped-ent.nome-abrev,
                                                                    input  proc-ped-ent.nr-pedcli,
                                                                    input  proc-ped-ent.nr-sequencia,
                                                                    input  proc-ped-ent.it-codigo,
                                                                    input  proc-ped-ent.cod-refer,
                                                                    input  proc-ped-ent.nr-entrega,
                                                                    output de-qt-alocada).
                        run calculaQuantidadeAtendida in h-bocx195 (input  proc-ped-ent.cod-estabel,
                                                                    input  proc-ped-ent.nr-proc-exp,
                                                                    input  proc-ped-ent.nome-abrev,
                                                                    input  proc-ped-ent.nr-pedcli,
                                                                    input  proc-ped-ent.nr-sequencia,
                                                                    input  proc-ped-ent.it-codigo,
                                                                    input  proc-ped-ent.cod-refer,
                                                                    input  proc-ped-ent.nr-entrega,
                                                                    output pde-quantidade).

                        if de-qt-alocada > pde-quantidade then do:
                            run utp/ut-msgs.p (input "msg":U, input 6005, input "").
                            create tt-bo-erro.
                            assign i-seq-erro              = i-seq-erro + 1
                                   tt-bo-erro.i-sequen     = i-seq-erro
                                   tt-bo-erro.cd-erro      = 6005
                                   tt-bo-erro.mensagem     = return-value
                                   l-embarque-alocado      = yes.

                            leave.
                        end.
                    end.
                    find first param-exp no-lock 
                         where param-exp.cod-estabel = rowObject.cod-estabel no-error.
                    if avail param-exp then do:
                        if integer({&PARAM-EXP.CDN-MOTIVO}) = 0 then do:
                            run utp/ut-msgs.p (input "msg":U, input 32837, input "").
                            create tt-bo-erro.
                            assign i-seq-erro              = i-seq-erro + 1
                                   tt-bo-erro.i-sequen     = i-seq-erro
                                   tt-bo-erro.cd-erro      = 32837
                                   tt-bo-erro.mensagem     = return-value.
                            return "NOK":U.
                        end.
                    end.

                    if not l-embarque-alocado then
                        run piPreparaCancelamento in this-procedure (input rowid({&TABLE-NAME})).
                &endif
                
                /* Cancela o pedido  */    
                if return-value <> "NOK":U then
                    run exp/exapi006.p (input  table rowObject,
                                        output table tt-bo-erro,
                                        input  6).   /* Cancelado */

                &if defined(bf_comex206b-1) &then
                    find last tt-bo-erro no-error.
                    if avail tt-bo-erro then
                        assign i-seq-erro = tt-bo-erro.i-sequen.

                    for each tt-bo-erro-aux:   
                        assign i-seq-erro = i-seq-erro + 1.
                        create tt-bo-erro.
                        buffer-copy tt-bo-erro-aux except i-sequen to tt-bo-erro.
                        assign tt-bo-erro.i-sequen = i-seq-erro.
                    end.
                    if can-find(first tt-bo-erro) then
                        undo cancelamento, return "NOK":U.
                &endif

            end.

            find first tt-bo-erro no-lock no-error.
            if not avail tt-bo-erro then do:
                if avail  {&TABLE-NAME} then do:
                    /*
                    run atualizaSituacaoProcesso (input {&TABLE-NAME}.cod-estabel,
                                                  input {&TABLE-NAME}.nr-proc-exp).
                    */
                    assign l-fatur-tot = no
                           l-fatur-par = no
                           l-n-fatur   = no.

                    &if defined(bf_comex206b-1) &then
                        for each  proc-ped-ent no-lock 
                            where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
                            and   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp,
                            first ped-ent no-lock 
                            where ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                            and   ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
                            and   ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                            and   ped-ent.it-codigo    = proc-ped-ent.it-codigo
                            and   ped-ent.cod-refer    = proc-ped-ent.cod-refer
                            and   ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:

                            if ped-ent.cod-sit-ent = 2 then do:
                                assign l-fatur-par = yes.
                            end.
                            else
                                if ped-ent.cod-sit-ent = 3 then do:
                                    assign l-fatur-tot = yes.
                                end.
                                else
                                    if ped-ent.cod-sit-ent = 1 or 
                                       ped-ent.cod-sit-ent = 4 or
                                       ped-ent.cod-sit-ent = 5 or
                                       ped-ent.cod-sit-ent = 6 or 
                                       ped-ent.cod-sit-ent = 7 then do:
                                        assign l-n-fatur = yes.
                                    end.
                        end.
                    &else
                        /* Elimina a sequencia da proc-ped-ent que foi criada para cancelar o saldo do processo 
                        e para cancelar a sequencia da ped-item e ped-ent para enviar para exapi006 */
                        for each tt-proc-ped-ent-aux1: 
                            find first b-proc-ped-ent-aux-2 exclusive-lock 
                                 where b-proc-ped-ent-aux-2.cod-estabel  = tt-proc-ped-ent-aux1.cod-estabel
                                 and   b-proc-ped-ent-aux-2.nr-proc-exp  = tt-proc-ped-ent-aux1.nr-proc-exp
                                 and   b-proc-ped-ent-aux-2.nome-abrev   = tt-proc-ped-ent-aux1.nome-abrev  
                                 and   b-proc-ped-ent-aux-2.nr-pedcli    = tt-proc-ped-ent-aux1.nr-pedcli   
                                 and   b-proc-ped-ent-aux-2.nr-sequencia = tt-proc-ped-ent-aux1.nr-sequencia
                                 and   b-proc-ped-ent-aux-2.it-codigo    = tt-proc-ped-ent-aux1.it-codigo   
                                 and   b-proc-ped-ent-aux-2.cod-refer    = tt-proc-ped-ent-aux1.cod-refer   
                                 and   b-proc-ped-ent-aux-2.nr-entrega   = tt-proc-ped-ent-aux1.nr-entrega no-error.
                            if avail b-proc-ped-ent-aux-2 then
                                delete b-proc-ped-ent-aux-2.
                        end.
                        bloco:
                        for each  proc-ped-ent no-lock
                            where proc-ped-ent.cod-estabel  = pc-cod-estabel
                            and   proc-ped-ent.nr-proc-exp  = pc-nr-proc-exp,
                            first b-ped-ent no-lock
                            where b-ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                            and   b-ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli     
                            and   b-ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia   
                            and   b-ped-ent.it-codigo    = proc-ped-ent.it-codigo     
                            and   b-ped-ent.cod-refer    = proc-ped-ent.cod-refer     
                            and   b-ped-ent.nr-entrega   = proc-ped-ent.nr-entrega :

                            if valid-handle(h-bocx195) then
                                run calculaQuantidadeAtendida in h-bocx195 (input  proc-ped-ent.cod-estabel,
                                                                            input  proc-ped-ent.nr-proc-exp,
                                                                            input  proc-ped-ent.nome-abrev,
                                                                            input  proc-ped-ent.nr-pedcli,
                                                                            input  proc-ped-ent.nr-sequencia,
                                                                            input  proc-ped-ent.it-codigo,
                                                                            input  proc-ped-ent.cod-refer,
                                                                            input  proc-ped-ent.nr-entrega,
                                                                            output pde-quantidade).
                            if  pde-quantidade = 0 or ped-ent.cod-sit-ent = 5 then
                                assign l-n-fatur = yes. 
                            else
                                if  pde-quantidade > 0 and pde-quantidade < proc-ped-ent.quantidade[1] then do:
                                    assign l-fatur-par = yes.
                                    leave bloco.
                                end.
                                else
                                    if  pde-quantidade >= proc-ped-ent.quantidade[1] then do:
                                        assign l-fatur-tot = yes.
                                        leave bloco.
                                    end.
                        end.
                    &endif
                    if (l-fatur-par = no and l-fatur-tot = no and l-n-fatur = yes) or
                        (not can-find(first proc-ped-venda 
                                      where proc-ped-venda.cod-estabel = rowObject.cod-estabel 
                                      and   proc-ped-venda.nr-proc-exp = rowObject.nr-proc-exp)) then
                        assign {&TABLE-NAME}.cod-sit-proc = 6  /** Cancelado **/
                               {&TABLE-NAME}.dt-cancela   = today.
                    if (l-fatur-par = yes or l-fatur-tot = yes) and l-n-fatur = yes then
                        assign {&TABLE-NAME}.cod-sit-proc = 7   /** Faturado parcial **/
                               {&TABLE-NAME}.dt-cancela   = today.
                    if l-fatur-par = yes and l-fatur-tot = yes and l-n-fatur = no then
                        assign {&TABLE-NAME}.cod-sit-proc = 7   /** Faturado parcial **/
                               {&TABLE-NAME}.dt-cancela   = today.
                    if l-fatur-par = yes and l-fatur-tot = no and l-n-fatur = no then
                        assign {&TABLE-NAME}.cod-sit-proc = 7   /** Faturado parcial **/
                               {&TABLE-NAME}.dt-cancela   = today.
                    if l-fatur-tot = yes and l-fatur-par = no and l-n-fatur = no then
                        assign {&TABLE-NAME}.cod-sit-proc = 3   /** Faturado total **/
                               {&TABLE-NAME}.dt-cancela   = today.                       
                    if l-fatur-tot = yes and l-fatur-par = no and l-n-fatur = yes then
                        assign {&TABLE-NAME}.cod-sit-proc = 3   /** Faturado total **/
                               {&TABLE-NAME}.dt-cancela   = today.
                end.
            end.
        end.
        &if defined(bf_comex206b-1) &then
            run piGravarMotivoCancel (input table RowObject,
                                      input c-usuario-corren).
        &endif
        IF NOT VALID-HANDLE(h-bocx195) THEN
            RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
        
        /* buscar os itens cancelados no pedido de venda para desvincular do processo de exporta‡Æo */
        FOR EACH  proc-ped-ent NO-LOCK 
            WHERE proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
            AND   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp,
            FIRST ped-ent NO-LOCK 
            WHERE ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
            AND   ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
            AND   ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
            AND   ped-ent.it-codigo    = proc-ped-ent.it-codigo
            AND   ped-ent.cod-refer    = proc-ped-ent.cod-refer
            AND   ped-ent.nr-entrega   = proc-ped-ent.nr-entrega
            AND   ped-ent.cod-sit-ent  = 6: 
            
            ASSIGN r-chave = ROWID(proc-ped-ent).
    
            RUN validateDelete IN h-bocx195(INPUT-OUTPUT r-chave,
                                            OUTPUT TABLE rowerrors).

            FOR EACH rowerrors:
                create tt-bo-erro.
                assign i-seq-erro              = i-seq-erro + 1
                       tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = RowErrors.ErrorNumber
                       tt-bo-erro.mensagem     = RowErrors.ErrorDescription.
            END.

            if can-find(first rowerrors) then
                undo cancelamento, return "NOK":U.
        END.
    end. /* transaction cancelamento */
	
    IF  VALID-HANDLE(h-bocx195) THEN DO:
        DELETE PROCEDURE h-bocx195.
        ASSIGN h-bocx195 = ?.
    END.

    for each tt-ped-venda:
        delete tt-ped-venda.
    end.
END PROCEDURE.

PROCEDURE findTable:
    find first rowObject no-lock no-error.
    find first {&TABLE-NAME} exclusive-lock
         where {&TABLE-NAME}.cod-estabel = rowObject.cod-estabel 
         and   {&TABLE-NAME}.nr-proc-exp = rowObject.nr-proc-exp  no-error.

    if avail {&TABLE-NAME} then do:
        /* Verifica se a situa‡Æo do processo não esta cancelado   */
        if {&TABLE-NAME}.cod-sit-proc = 6 then do:
            assign i-seq-erro = i-seq-erro + 1
                   l-proc-canc = yes.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-field.i mgcex processo-exp nr-proc-exp 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 17230,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17230
                   tt-bo-erro.mensagem = return-value.
        end.
        else assign l-proc-canc = no.
    end.
END PROCEDURE.

PROCEDURE aceiteCliente:
    /* Valida situa‡Æo antes de executar o aceite */
    def input  parameter table for rowObject.
    def output parameter table for tt-bo-erro.
    def var c-return1 as char no-undo.

    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    run findTable.
    if avail {&TABLE-NAME} and not l-proc-canc then do:
        if {&TABLE-NAME}.cod-sit-proc <> 1 then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Aceite_Cliente * l}
            run utp/ut-msgs.p (input "msg":U,
                               input 17148,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17148
                   tt-bo-erro.mensagem     = return-value.
        end.
        if not can-find(first proc-ped-ent 
                        where proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp
                        and   proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel) then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* Processo sem entrega, não pode permitir o aceite do cliente */         
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-field.i mgcex processo-exp nr-proc-exp 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 17237,  
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17237
                   tt-bo-erro.mensagem = return-value.
        end.
        find first tt-bo-erro no-error.
        if not avail tt-bo-erro then do:
            /* ************************************************************ 
            Na implanta‡Æo do pedido, de acordo com o cliente, se for
            cliente estrangeiro ou trading e o módulo de Exporta‡Æo 
            estiver implantado,  o pd0508 iniciará o cod-sit-aval como
            "5 - pendente informa‡Æo". Nesta procedure qdo for aceite
            pedido, a situa‡Æo de avalia‡Æo de todos os pedidos deste
            processo,  ficarão como não avaliados.  Esta lógica só será
            liberada qdo o pd0508 estiver fazendo todas essas validações.
            ***************************************************************/
            /* ****** aguardar baixa de fo 
            FOR EACH  proc-ped-venda FIELDS () of {&TABLE-NAME},
                first ped-venda FIELDS (cod-sit-aval) 
                where ped-venda.nome-abrev = proc-ped-venda.nome-abrev
                and   ped-venda.nr-pedcli  = proc-ped-venda.nr-pedcli:
                assign ped-venda.cod-sit-aval = 1.
            END. */

            if avail {&TABLE-NAME} then
                assign {&TABLE-NAME}.cod-sit-proc = 2
                       {&TABLE-NAME}.dt-aceita-prof = today.
        end.
    end.
END PROCEDURE.

PROCEDURE reabreProforma:
    /* Valida situa‡Æo antes de executar a reabertura */
    def input  parameter table for rowObject.
    def output parameter table for tt-bo-erro.

    assign i-seq-erro = 0.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    run findTable.
    if avail {&TABLE-NAME} and not l-proc-canc then do:
        if {&TABLE-NAME}.dt-val-prof <= today then do:
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Proforma * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 17238,   /*Data de Validade do Proforma expirou */
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17238
                   tt-bo-erro.mensagem = return-value.
        end.

        if not can-find(first proc-ped-ent 
                        where proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp
                        and   proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel) then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-field.i mgcex processo-exp nr-proc-exp 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 17237,  /*  Processo sem entregas, não permiti alterar a situa‡Æo. */
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17237
                   tt-bo-erro.mensagem = return-value.
        end.
        if {&TABLE-NAME}.cod-sit-proc <> 2 then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
            pre-processador em chamada de includes */
            {utp/ut-liter.i Reabertura * R}
            run utp/ut-msgs.p (input "msg":U,
                               input 17148,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17148
                   tt-bo-erro.mensagem     = return-value.
        end.
        find first tt-bo-erro no-error.
        if not avail tt-bo-erro then do:
            if avail {&TABLE-NAME} then
                assign {&TABLE-NAME}.cod-sit-proc   = 1
                       {&TABLE-NAME}.dt-aceita-prof = ?.
        end.
    end.
END PROCEDURE.

PROCEDURE setaIniciopagto.
    def input parameter p-cod-estabel   like processo-exp.cod-estabel no-undo.
    def input parameter p-nr-proc-exp   like processo-exp.nr-proc-exp no-undo.
    def input parameter p-pto-ini-pagto like pto-contr.cod-pto-contr  no-undo.

    find first processo-exp exclusive-lock
         where processo-exp.cod-estabel = p-cod-estabel 
         and   processo-exp.nr-proc-exp = p-nr-proc-exp no-error.
    if avail processo-exp then 
        assign processo-exp.cod-pto-inicio-pagto = p-pto-ini-pagto.
END PROCEDURE.

PROCEDURE GenerateTable2.
    /*** Cria o registro atrav‚s do pr‚-faturamento ***/
    def input  parameter table for RowObject.
    def INPUT  parameter p-nr-pedcli  as char no-undo.
    def INPUT  parameter p-nome-abrev as char no-undo.
    def input  parameter i-nr-pedido  as int  no-undo.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    def output parameter i-nr-processo like processo-exp.nr-proc-exp.

    def var c-pais as char no-undo.
    def var i-pais as int  no-undo.

    run initializeValidate.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find first rowObject exclusive-lock no-error.
    if avail rowObject then do:
        run validateEstabel (input rowObject.cod-estabel).

        &if defined(bf_dis_proc_ent) &then
            /******************************
            ** EPC - Inicio
            ******************************/
            for each  tt-epc 
                where tt-epc.cod-event = "BEFORE-PARAM": 
                delete tt-epc. 
            end.
            /*** Criacao do registro para temp-table tt-epc ***/
            {include/i-epc200.i2 &CodEvent='"BEFORE-PARAM"'
                                 &CodParameter='"NUMBER-NEXT"'
                                 &ValueParameter=string(RowObject.cod-estabel) + 
                                                        Rowobject.nr-proc-exp}
            /*** Chamada do programa EPC ***/
            {include/i-epc201.i "BEFORE-PARAM"}

            FIND FIRST tt-epc NO-LOCK 
                 WHERE tt-epc.cod-event     = "BEFORE-PARAM" 
                 AND   tt-epc.cod-parameter = "NOT-SAVE" NO-ERROR.

            IF NOT AVAIL tt-epc THEN DO:
        &endif    
            /*** Gera numera‡Æo automática, pois foi gerado no pr‚-faturamento ***/
            if rowObject.nr-proc-exp = "" then do:
                find first param-exp exclusive-lock 
                     where param-exp.cod-estabel = rowObject.cod-estabel no-error.
                if avail param-exp then
                    assign rowObject.nr-proc-exp      = string(param-exp.nr-prox-proc-exp)
                           param-exp.nr-ult-proc-exp  = param-exp.nr-prox-proc-exp
                           param-exp.nr-prox-proc-exp = param-exp.nr-prox-proc-exp + param-exp.inc-num.
            end.
        &if defined(bf_dis_proc_ent) &then 
            end.   
        &endif
        
        find first emitente no-lock 
             where emitente.nome-abrev = p-nome-abrev no-error.
        if avail emitente then
            assign RowObject.cod-emitente = emitente.cod-emitente.

        run validateEmitente (input rowObject.cod-emitente).

        find first ped-venda-cex no-lock 
             where ped-venda-cex.nome-abrev = p-nome-abrev
             and   ped-venda-cex.nr-pedcli  = p-nr-pedcli  no-error.
        IF AVAIL ped-venda-cex THEN DO:
            assign rowObject.cod-itiner    = ped-venda-cex.cod-itiner
                   rowObject.cod-incoterm  = ped-venda-cex.cod-incoterm
                   rowObject.cod-idioma    = ped-venda-cex.cod-idioma
                   rowObject.marca-1       = ped-venda-cex.marca-1
                   rowObject.marca-2       = ped-venda-cex.marca-2
                   rowObject.marca-3       = ped-venda-cex.marca-3
                   rowObject.marca-4       = ped-venda-cex.marca-4
                   rowObject.marca-5       = ped-venda-cex.marca-5
                   rowObject.nome-completo = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                   rowObject.endereco      = IF AVAIL emitente THEN emitente.endereco  ELSE ""
                   rowObject.cep           = IF AVAIL emitente THEN string(emitente.cep)       ELSE ""
                   rowObject.bairro        = IF AVAIL emitente THEN emitente.bairro    ELSE ""
                   rowObject.estado        = IF AVAIL emitente THEN emitente.estado    ELSE ""
                   rowObject.cidade        = IF AVAIL emitente THEN emitente.cidade    ELSE ""
                   rowObject.pais          = IF AVAIL emitente THEN emitente.pais      ELSE ""
                   c-pais                  = IF AVAIL emitente THEN emitente.pais      ELSE "".

            if not valid-handle(h-boun006) then
                RUN unbo/boun006.p PERSISTENT SET h-boun006.
            Run findCh_nome in h-boun006 (input c-pais, output c-return).
            if c-return = "" then do:
                Run getIntField in h-boun006 (input "cod-pais", output i-pais).
                if i-pais <> 0 then do:
                    assign RowObject.cod-pais = i-pais.
                end.
            end.

            run ExecuteCreateProcesso (input table rowObject,
                                       output table tt-bo-erro,
                                       output r-chave).
            find first processo-exp no-lock 
                 where rowid(processo-exp) = r-chave no-error.
            if avail processo-exp then 
                assign i-nr-processo = processo-exp.nr-proc-exp.
        end.
    end.
END PROCEDURE.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1"       then c-value = RowObject.char-1.
        when "char-2"       then c-value = RowObject.char-2.
        when "check-sum"    then c-value = RowObject.check-sum.
        when "cod-idioma"  then c-value = RowObject.cod-idioma.
        when "nr-proc-exp"  then c-value = RowObject.nr-proc-exp.
        when "cod-estabel"  then c-value = RowObject.cod-estabel.
        otherwise return error.
    end case.
end procedure.

procedure getDateField:
    define input  parameter c-field  as char no-undo.
    define output parameter da-value as date no-undo.
    
    if not avail RowObject then
        return error.

    case c-field:
        when "dat-deadline"       then da-value = RowObject.dat-deadline.
        when "dat-entreg-docto"   then da-value = RowObject.dat-entreg-docto.
        when "dat-remes"          then da-value = RowObject.dat-remes.
        when "data-1"             then da-value = RowObject.data-1.
        when "data-2"             then da-value = RowObject.data-2.
        when "dt-aceita-prof"     then da-value = RowObject.dt-aceita-prof.
        when "dt-cancela"         then da-value = RowObject.dt-cancela.
        when "dt-cert-seguro"     then da-value = RowObject.dt-cert-seguro.
        when "dt-conhecimento"    then da-value = RowObject.dt-conhecimento.
        when "dt-courier"         then da-value = RowObject.dt-courier.
        when "dt-cruze"           then da-value = RowObject.dt-cruze.
        when "dt-embarque"        then da-value = RowObject.dt-embarque.
        when "dt-form-a"          then da-value = RowObject.dt-form-a.
        when "dt-invoice"         then da-value = RowObject.dt-invoice.
        when "dt-prev-embarque"   then da-value = RowObject.dt-prev-embarque.
        when "dt-prev-ex-factory" then da-value = RowObject.dt-prev-ex-factory.
        when "dt-saque"           then da-value = RowObject.dt-saque.
        when "dt-val-prof"        then da-value = RowObject.dt-val-prof.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "cod-pto-inicio-pagto" then c-value = RowObject.cod-pto-inicio-pagto.
        when "cod-sit-proc" then c-value = rowobject.cod-sit-proc.
        when "cod-itiner" then c-value = rowobject.cod-itiner.
        when "cod-pais" then c-value = rowobject.cod-pais.
        when "pto-embarque" then c-value = rowobject.pto-embarque.
        when "pto-despacho" then c-value = rowobject.pto-despacho.
        when "pto-desembarque" then c-value = rowobject.pto-desembarque.
        when "pto-chegada" then c-value = rowobject.pto-chegada.      
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        &IF DEFINED(bf_comex206b-1) &THEN
            when "log-atualiz-ctb" then c-value = RowObject.log-atualiz-ctb.
        &ENDIF
        otherwise return error.
    end case.
end procedure.

procedure pi-seta-idioma:
/*
** Procedure que seta o idioma do usuário.
*/
    def input parameter c_cod_idiom_usuar like idioma.cod_idioma.
    
    assign c-cod-idiom-usuar = c_cod_idiom_usuar.
end procedure.

PROCEDURE pi-seta-process-orig:
/*****************************************************************************
* Subprocesso - Seta o c¢digo do processo de origem para ser utilizado na BO *
******************************************************************************/
    def input parameter pc-processo-orig like processo-exp.nr-proc-exp.
    
    assign c-processo-orig = pc-processo-orig.
END PROCEDURE.

procedure atualizaSitProc:
    /* ** Procedure atualiza situa‡Æo do processo no Faturamento */
    def var de-volume as decimal INIT 0 no-undo.

    def input param rw-nota-fiscal as rowid no-undo.  

    find first nota-fiscal no-lock
         where rowid(nota-fiscal) = rw-nota-fiscal no-error.
    
    if avail nota-fiscal then
        run atualizaSituacaoProcesso (input &if '{&bf_mat_versao_ems}' >= '2.071' &then
                                            nota-fiscal.cod-estab-proces-export
                                            &else
                                            trim(substring(nota-fiscal.char-1,124,3))
                                            &endif ,
                                      input string(nota-fiscal.nr-proc-exp)).

    /*gravar volume no processo exporta‡Æo*/ 
    for each  proc-it-nota-fisc no-lock
        where proc-it-nota-fisc.cod-estab-faturam = nota-fiscal.cod-estabel
        and   proc-it-nota-fisc.serie             = nota-fiscal.serie
        and   proc-it-nota-fisc.nr-nota-fis       = nota-fiscal.nr-nota-fis:
        find first it-nota-fisc no-lock 
             where it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
             and   it-nota-fisc.serie       = proc-it-nota-fisc.serie
             and   it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
             and   it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat no-error.
        for each  item-embal of it-nota-fisc no-lock:
            find first embalag no-lock 
                 where embalag.sigla-emb = item-embal.sigla-emb no-error.
            assign de-volume = de-volume + embalag.volume.
        end.
    end.

     /* Integrado com GFE */
    IF  CAN-FIND(FIRST funcao NO-LOCK 
                 WHERE funcao.cd-funcao = "SPP_TOTVSGFE":U 
                   AND funcao.ativo = YES) 
         AND de-volume > 0 THEN
        /* Posiciona tab-generica */
        FOR  FIRST tab-generica NO-LOCK
             WHERE tab-generica.utilizacao = "SETUP" :
            
            IF SUBSTRING(tab-generica.char-2,231,1) = "Y":U THEN       /* CD0089 - Notas Fiscais de Sa­da */
               ASSIGN de-volume = de-volume / 1000000. // converte cmü para mü - volume informado na embalagem quando tem GFE deve ser em cms c£bicos, mas deve ser gravado em mü no processo
                                                         //Levamos em considera‡Æo o documento: https://centraldeatendimento.totvs.com/hc/pt-br/articles/360026471693-Log%C3%ADstica-Linha-Protheus-GFE-C%C3%A1lculo-do-volume-no-Item-do-Documento-de-Carga-GW8-VOLUME#:~:text=%C3%89%20considerada%20a%20Unidade%20de,*%20Comprimento%29%20*%20Quantidade%20Item
        END.    
        
    FIND FIRST processo-exp EXCLUSIVE-LOCK
         WHERE processo-exp.cod-estabel = &if '{&bf_mat_versao_ems}' >= '2.071' &then
                                          nota-fiscal.cod-estab-proces-export
                                          &else
                                          trim(substring(nota-fiscal.char-1,124,3))
                                          &endif
         AND   processo-exp.nr-proc-exp = nota-fiscal.nr-proc-exp         NO-ERROR.
         
         IF AVAIL processo-exp THEN DO:
            assign processo-exp.volume = processo-exp.volume + de-volume
                   de-volume = 0.
         END.

end procedure.

procedure atualizaSitProcbyPedido:
    /*
    ** Atualiza situa‡Æo do processo de exporta‡Æo por Pedido de Venda
    */
    def input parameter pr-ped-venda as rowid no-undo.
    
    def var c-nome-abrev  like emitente.nome-abrev no-undo.
    def var c-nr-pedcli   like ped-venda.nr-pedcli no-undo.
    def var c-cod-estabel like estabelec.cod-estabel no-undo.
    def var c-nr-proc-exp like processo-exp.nr-proc-exp no-undo.
    
    for first ped-venda fields(nome-abrev nr-pedcli)
        where rowid(ped-venda) = pr-ped-venda no-lock:
    end.        
        
    for each  proc-ped-venda fields(cod-estabel nr-proc-exp) no-lock
        where proc-ped-venda.nome-abrev = ped-venda.nome-abrev
        and   proc-ped-venda.nr-pedcli  = ped-venda.nr-pedcli:

        if c-nome-abrev  = ped-venda.nome-abrev       and
           c-nr-pedcli   = ped-venda.nr-pedcli        and
           c-cod-estabel = proc-ped-venda.cod-estabel and
           c-nr-proc-exp = proc-ped-venda.nr-proc-exp then next.

        assign c-nome-abrev  = ped-venda.nome-abrev
               c-nr-pedcli   = ped-venda.nr-pedcli
               c-cod-estabel = proc-ped-venda.cod-estabel
               c-nr-proc-exp = proc-ped-venda.nr-proc-exp.                                  
            
        run atualizaSituacaoProcesso (input proc-ped-venda.cod-estabel,
                                      input proc-ped-venda.nr-proc-exp).

    end.
    
    RETURN "OK":U.
end procedure.

procedure atualizaSituacaoProcesso:
    /*
    ** Atualiza situa‡Æo do processo de exporta‡Æo
    */
    def input parameter pc-cod-estabel like estabelec.cod-estabel    no-undo.
    def input parameter pc-nr-proc-exp like processo-exp.nr-proc-exp no-undo. 
    
    &if defined(bf_comex206b-1) &then
    define variable pde-quantidade  as decimal init 0        no-undo.
    &endif
    
    &if defined(bf_comex206b-1) &then
        IF NOT VALID-HANDLE(h-bocx195) THEN
           run cxbo/bocx195.p persistent set h-bocx195.
    &endif

    assign l-fatur-tot = no
           l-fatur-par = no
           l-n-fatur   = no.
           
    for each  proc-ped-ent no-lock 
        where proc-ped-ent.cod-estabel = pc-cod-estabel 
          and proc-ped-ent.nr-proc-exp = pc-nr-proc-exp,
        first ped-ent no-lock 
        where ped-ent.nome-abrev   = proc-ped-ent.nome-abrev   
          and ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli    
          and ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia 
          and ped-ent.it-codigo    = proc-ped-ent.it-codigo    
          and ped-ent.cod-refer    = proc-ped-ent.cod-refer    
          and ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:

        if proc-ped-ent.ind-componen > 2 then next.

        IF VALID-HANDLE(h-bocx195) THEN
            run calculaQuantidadeAtendida in h-bocx195 (input  proc-ped-ent.cod-estabel,
                                                        input  proc-ped-ent.nr-proc-exp,
                                                        input  proc-ped-ent.nome-abrev,
                                                        input  proc-ped-ent.nr-pedcli,
                                                        input  proc-ped-ent.nr-sequencia,
                                                        input  proc-ped-ent.it-codigo,
                                                        input  proc-ped-ent.cod-refer,
                                                        input  proc-ped-ent.nr-entrega,
                                                        output pde-quantidade).

        run retornaTipoAtend in h-bocx195 (output i-tipo-atend).
        if  pde-quantidade = 0 or ped-ent.cod-sit-ent = 5 then do:
            assign l-n-fatur = yes.
        end.
        else
            if  i-tipo-atend = 3 and pde-quantidade > 0 and pde-quantidade < proc-ped-ent.quantidade[1] then do: /*atendimento parcial cancela saldo*/
                assign l-fatur-tot = yes.
            end.
            else
                if  pde-quantidade > 0 and pde-quantidade < proc-ped-ent.quantidade[1] then do:
                    assign l-fatur-par = yes.
                end.
                else
                    if  pde-quantidade >= proc-ped-ent.quantidade[1] then do:
                        assign l-fatur-tot = yes.
                    end.
    end.
	
    IF  VALID-HANDLE(h-bocx195) THEN DO:
        DELETE PROCEDURE h-bocx195.
        ASSIGN h-bocx195 = ?.
    END.
    
    find first processo-exp exclusive-lock
         where processo-exp.cod-estabel = pc-cod-estabel
         and   processo-exp.nr-proc-exp = pc-nr-proc-exp no-error.
    if avail processo-exp then do:
        /*        
        if l-fatur-par = no and l-fatur-tot = no and l-n-fatur = yes then
            assign processo-exp.cod-sit-proc = 6  /** Cancelado **/
                   processo-exp.dt-cancela   = today.
        end.
        */
        if (l-fatur-par = yes or l-fatur-tot = yes) and l-n-fatur = yes then
            assign processo-exp.cod-sit-proc = 7.   /** Faturado parcial **/
        if l-fatur-par = yes and l-fatur-tot = yes and l-n-fatur = no then
            assign processo-exp.cod-sit-proc = 7.   /** Faturado parcial **/
        if l-fatur-par = yes and l-fatur-tot = no and l-n-fatur = no then
            assign processo-exp.cod-sit-proc = 7.   /** Faturado parcial **/
        if l-fatur-tot = yes and l-fatur-par = no and l-n-fatur = no then
            assign processo-exp.cod-sit-proc = 3.   /** Faturado total **/
        if l-fatur-par = no  and l-fatur-tot = no then
            assign processo-exp.cod-sit-proc = 1.

        if l-fatur-tot = yes and l-fatur-par = no and l-n-fatur = no then DO:
            FIND FIRST historico-proc-exp
                 WHERE historico-proc-exp.cod-estabel   = processo-exp.cod-estabel
                   AND historico-proc-exp.nr-proc-exp   = processo-exp.nr-proc-exp
                   AND historico-proc-exp.cod-itiner    = processo-exp.cod-itiner
                   AND historico-proc-exp.cod-pto-contr = processo-exp.pto-embarque NO-LOCK NO-ERROR.
            IF  AVAIL historico-proc-exp
            AND historico-proc-exp.dt-efetiva <> ? THEN
                ASSIGN processo-exp.cod-sit-proc = 4. /*embarcado*/
        END.

        /* ----------- Chamada UPC ----------- */
        &if defined(bf_dis_proc_ent) &then
            for each  tt-epc
                where tt-epc.cod-event = "AtualizaSitProc":
                delete tt-epc.
            end.
            /*** Criacao do registro para temp-table tt-epc ***/
            {include/i-epc200.i2 &CodEvent='"AtualizaSitProc"'
                                 &CodParameter='"row-processo"'
                                 &ValueParameter=string(ROWID(processo-exp))}
            
            /*** Chamada do programa EPC ***/
            {include/i-epc201.i "AtualizaSitProc"}            
        &endif
    end.
end procedure.

procedure criaEmbalagensProcessoExp:
    def input parameter pc-cod-estabel like estabelec.cod-estabel    no-undo.
    def input parameter pc-nr-proc-exp like processo-exp.nr-proc-exp no-undo.  
    
    def var i-ult-volume    as int                         no-undo.
    def var i-cont1         as int                         no-undo.
    def var i-cont2         as int                         no-undo.
    def var i-cont-tt-it-cx as int                         no-undo.
    def var i-nr-caixas     as int                         no-undo.
    def var i-nr-ocorr      as int                         no-undo.
    def var de-qt-restante  as dec                         no-undo.
    def var de-resto        as dec                         no-undo.
    def var de-melhor       as dec                         no-undo.
    def var de-sobra        as dec               extent 10 no-undo.
    def var c-it-codigo     like item.it-codigo  extent 4  no-undo.
    def var c-fm-codigo     like item.fm-codigo  extent 4  no-undo.
    def var c-fm-cod-com    like item.fm-cod-com extent 4  no-undo.
    def var c-nr-seq        as char                        no-undo.

    empty temp-table tt-proc-emb.

    for each proc-ped-ent no-lock
       where proc-ped-ent.cod-estabel   = pc-cod-estabel
         and proc-ped-ent.nr-proc-exp   = pc-nr-proc-exp
         and proc-ped-ent.ind-componen <= 2:

        FOR FIRST proces-acond-item
            WHERE proces-acond-item.nome-abrev   = proc-ped-ent.nome-abrev  
              AND proces-acond-item.nr-pedcli    = proc-ped-ent.nr-pedcli   
              AND proces-acond-item.nr-sequencia = proc-ped-ent.nr-sequencia
              AND proces-acond-item.it-codigo    = proc-ped-ent.it-codigo   
              AND proces-acond-item.cod-refer    = proc-ped-ent.cod-refer   
              AND proces-acond-item.nr-entrega   = proc-ped-ent.nr-entrega  
              AND proces-acond-item.cod-estabel  = proc-ped-ent.cod-estabel 
              AND proces-acond-item.nr-proc-exp  = proc-ped-ent.nr-proc-exp NO-LOCK:
        END.

        create tt-proc-emb.
        assign tt-proc-emb.cod-estabel     = proc-ped-ent.cod-estabel
               tt-proc-emb.nr-proc-exp     = proc-ped-ent.nr-proc-exp
               tt-proc-emb.cod-acond       = if avail proces-acond-item then proces-acond-item.cod-acond else ""
               tt-proc-emb.num-volum-acond = if avail proces-acond-item then proces-acond-item.num-volum-acond else 0
               tt-proc-emb.nome-abrev      = proc-ped-ent.nome-abrev  
               tt-proc-emb.nr-pedcli       = proc-ped-ent.nr-pedcli   
               tt-proc-emb.nr-sequencia    = proc-ped-ent.nr-sequencia
               tt-proc-emb.it-codigo       = proc-ped-ent.it-codigo   
               tt-proc-emb.cod-refer       = proc-ped-ent.cod-refer   
               tt-proc-emb.nr-entrega      = proc-ped-ent.nr-entrega
               tt-proc-emb.quantidade[1]   = proc-ped-ent.quantidade[1].
    END.
    
    for first item-caixa fields () no-lock: end.
    if  avail item-caixa then DO:
    
        assign i-ult-volume = 0.         

        for each tt-proc-emb
           break by tt-proc-emb.cod-acond:
           
            if tt-proc-emb.cod-acond <> "" then
               if first-of(tt-proc-emb.cod-acond) then
                  assign i-ult-volume = 0.

            for first item
                fields(item.it-codigo
                       item.fm-codigo
                       item.fm-cod-com)
                where item.it-codigo = tt-proc-emb.it-codigo no-lock:
            end.

            if not avail item then next.

            /* Motagem do vetor para busca das informacões no Item X Embalagem */
            /*-----------------------------------------------------------------+
             |       Essas variáveis receberão os seguintes valores:           |
             |                                                                 |
             | +-----+-----------------+-----------------+-------------------+ |
             | | Ext |   c-it-codigo   |   c-fm-codigo   |   c-fm-cod-com    | |
             | +-----+-----------------+-----------------+-------------------+ |
             | | [1] | Codigo do item  |        ?        |         ?         | |
             | | [2] |       ?         | Cod da Familia  | Familia Comercial | |
             | | [3] |       ?         |        ?        | Familia Comercial | |
             | | [4] |       ?         | Cod da Familia  |         ?         | |
             | +-----+-----------------+-----------------+-------------------+ |
             +-----------------------------------------------------------------*/

            assign c-it-codigo[1]    = item.it-codigo 
                   c-it-codigo[2]    = ?
                   c-it-codigo[3]    = ?
                   c-it-codigo[4]    = ?
                   c-fm-codigo[1]    = ?
                   c-fm-codigo[2]    = item.fm-codigo
                   c-fm-codigo[3]    = ?
                   c-fm-codigo[4]    = item.fm-codigo
                   c-fm-cod-com[1]   = ?
                   c-fm-cod-com[2]   = item.fm-cod-com
                   c-fm-cod-com[3]   = item.fm-cod-com
                   c-fm-cod-com[4]   = ?
                   de-qt-restante    = tt-proc-emb.quantidade[1] /* Quantidade a ser embalada */
                   i-cont-tt-it-cx   = 0  /* Contador de registros criados para tt-item-caixa */
                   i-cont1           = 1. /* Contador auxiliar                                */ 


            /* Eliminacao dos registros tt-item-caixa */
            for each tt-item-caixa:
                delete tt-item-caixa.
            end.

            /* Localiza o relacionamento Item/Embalagem(caixa), de acordo */
            /* com a tabela mostrada anteriormente                        */
            bloco-item-caixa:
            repeat:
                for each  item-caixa fields(item-caixa.sigla-emb item-caixa.qt-item) no-lock
                    where item-caixa.it-codigo  = c-it-codigo[i-cont1]
                    and   item-caixa.fm-codigo  = c-fm-codigo[i-cont1]
                    and   item-caixa.fm-cod-com = c-fm-cod-com[i-cont1]:
                    /* A cada sigla diferente, sera criado um tt-item-caixa, com um limite de 10 reg */
                    find first tt-item-caixa
                         where tt-item-caixa.sigla-emb = item-caixa.sigla-emb no-error.
                    if  not avail tt-item-caixa then do:
                        create tt-item-caixa.
                        assign tt-item-caixa.sigla-emb = item-caixa.sigla-emb
                               tt-item-caixa.qt-item   = item-caixa.qt-item
                               i-cont-tt-it-cx         = i-cont-tt-it-cx + 1.
                        if  i-cont-tt-it-cx = 10 then 
                            leave bloco-item-caixa.
                    end.
                end.
                assign i-cont1 = i-cont1 + 1.
                if  i-cont1 = 5 then 
                    leave.
            end.

            assign i-cont1 = 0.

            /* Seleciona Item/Embalagem criados p/ tab temp em ordem decrescente de qtde */
            for each  tt-item-caixa 
                break by tt-item-caixa.qt-item descending:

                assign i-cont1       = i-cont1 + 1
                       i-nr-caixas   = trunc(de-qt-restante / tt-item-caixa.qt-item,0)
                       de-resto      = de-qt-restante - tt-item-caixa.qt-item * i-nr-caixas.

                if  de-resto = 0 then do:
                    assign i-nr-ocorr              = i-cont1
                           tt-item-caixa.nr-caixas = i-nr-caixas.
                    leave.
                end.
                else do:
                    do  i-cont2 = i-cont1 to i-cont-tt-it-cx:
                        assign tt-item-caixa.nr-caixas[i-cont2] = 
                                   i-nr-caixas +
                                   if  i-cont2 = i-cont1
                                   then 1
                                   else 0.
                    end.
                    assign de-sobra[i-cont1] = /* Quanto sobra caso embale mais uma vez nessa embal */
                               tt-item-caixa.qt-item * (i-nr-caixas + 1) - de-qt-restante
                           de-qt-restante    = /* Qtdade restante que ainda precisa ser embalada    */
                               de-qt-restante - i-nr-caixas * tt-item-caixa.qt-item.
                end.
            end.

            /* Caso ainda exista ainda algo para ser embalado */
            if  de-resto <> 0 then do: 
                assign de-melhor  = de-sobra[1]
                       i-nr-ocorr = 1.
                do  i-cont1 = 1 to i-cont-tt-it-cx:
                    if  de-sobra[i-cont1] < de-melhor then 
                        assign de-melhor  = de-sobra[i-cont1]
                               i-nr-ocorr = i-cont1.
                end.
            end.

            /* Seleciona todos os tt-item-caixa onde foi embalado algo */
            for each  tt-item-caixa
                where tt-item-caixa.nr-caixas[i-nr-ocorr] <> 0
                break by tt-item-caixa.qt-item descending:
                find FIRST proces-embal-resum
                     WHERE proces-embal-resum.cod-estabel     = tt-proc-emb.cod-estabel
                       AND proces-embal-resum.nr-proc-exp     = tt-proc-emb.nr-proc-exp
                       AND proces-embal-resum.cod-acond       = tt-proc-emb.cod-acond
                       AND proces-embal-resum.num-volum-acond = tt-proc-emb.num-volum-acond
                       AND proces-embal-resum.sigla-emb       = tt-item-caixa.sigla-emb exclusive-lock NO-ERROR.
                if  not avail proces-embal-resum then do:
                    create proces-embal-resum.
                    assign proces-embal-resum.cod-estabel     = tt-proc-emb.cod-estabel
                           proces-embal-resum.nr-proc-exp     = tt-proc-emb.nr-proc-exp
                           proces-embal-resum.cod-acond       = tt-proc-emb.cod-acond
                           proces-embal-resum.num-volum-acond = tt-proc-emb.num-volum-acond
                           proces-embal-resum.sigla-emb       = tt-item-caixa.sigla-emb.
                end.
                assign proces-embal-resum.qti-volum = proces-embal-resum.qti-volum + 
                                                  tt-item-caixa.nr-caixas[i-nr-ocorr]
                       c-nr-seq                 = string(i-ult-volume + 1) + 
                                                  "-":U                    + 
                                                  string(i-ult-volume      + 
                                                  tt-item-caixa.nr-caixas[i-nr-ocorr])
                       proces-embal-resum.des-volum  = substr(if proces-embal-resum.des-volum = "":U 
                                                         then c-nr-seq            
                                                         else proces-embal-resum.des-volum + ",":U + 
                                                              c-nr-seq, 1, 76).

                if  not avail embalag 
                or  embalag.sigla-emb <> tt-item-caixa.sigla-emb then 
                    for first embalag
                        fields(embalag.sigla-emb embalag.ind-detemb)
                        where embalag.sigla-emb = tt-item-caixa.sigla-emb no-lock: 
                    end.

                do i-cont1 = 1 to tt-item-caixa.nr-caixas[i-nr-ocorr]:
                    create proces-embal-volum.
                    assign i-ult-volume                       = i-ult-volume + 1
                           proces-embal-volum.cod-estabel     = proces-embal-resum.cod-estabel
                           proces-embal-volum.nr-proc-exp     = proces-embal-resum.nr-proc-exp
                           proces-embal-volum.cod-acond       = proces-embal-resum.cod-acond
                           proces-embal-volum.num-volum-acond = proces-embal-resum.num-volum-acond
                           proces-embal-volum.num-volum-embal = i-ult-volume
                           proces-embal-volum.sigla-emb       = proces-embal-resum.sigla-emb
                           proces-embal-volum.nome-abrev      = tt-proc-emb.nome-abrev
                           proces-embal-volum.nr-pedcli       = tt-proc-emb.nr-pedcli
                           proces-embal-volum.it-codigo       = tt-proc-emb.it-codigo
                           proces-embal-volum.nr-sequencia    = tt-proc-emb.nr-sequencia
                           proces-embal-volum.cod-refer       = tt-proc-emb.cod-refer
                           proces-embal-volum.nr-entrega      = tt-proc-emb.nr-entrega
                           proces-embal-volum.qtd-embal       = 
                               if  i-cont1 = tt-item-caixa.nr-caixas[i-nr-ocorr]
                               and last(tt-item-caixa.qt-item) 
                               then (tt-item-caixa.qt-item - de-sobra[i-nr-ocorr])
                               else tt-item-caixa.qt-item.
                end.             

            end.

            assign de-sobra = 0.

        end.

    end.
end procedure.

PROCEDURE AtualizaDtPrevEmbarque:
    def input param c-cod-estabel      like processo-exp.cod-estabel no-undo.
    def input param i-nr-proc-exp      like processo-exp.nr-proc-exp no-undo.
    def input param i-pto-embarque     like processo-exp.pto-embarque no-undo.
    def input param d-dt-prev-embarque like processo-exp.dt-prev-embarque no-undo.
        
    for first processo-exp exclusive-lock
        where processo-exp.cod-estabel = c-cod-estabel
        and   processo-exp.nr-proc-exp = i-nr-proc-exp:
    end.
    if avail (processo-exp) and processo-exp.pto-embarque = i-pto-embarque then
        assign processo-exp.dt-prev-embarque = d-dt-prev-embarque.                

    return "OK":U.
END PROCEDURE.

procedure getDateFirstInvoice:

    def input  parameter p-c-cod-estabel     like processo-exp.cod-estabel  no-undo.
    def input  parameter p-c-nr-proc-exp     like processo-exp.nr-proc-exp  no-undo.
    def output parameter p-da-dt-corte       as   date                      no-undo initial today.
    
    for each  proc-nota-fiscal fields (proc-nota-fiscal.cod-estabel proc-nota-fiscal.serie proc-nota-fiscal.nr-nota-fis) no-lock
        where proc-nota-fiscal.cod-estabel     = p-c-cod-estabel
        and   proc-nota-fiscal.nr-proc-exp     = p-c-nr-proc-exp
        and   proc-nota-fiscal.log-nf-devolvid = no,
        each  nota-fiscal      fields (nota-fiscal.nat-operacao nota-fiscal.dt-emis-nota) no-lock
        where nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
        and   nota-fiscal.serie       = proc-nota-fiscal.serie
        and   nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis
        and   nota-fiscal.dt-cancela  = ?:

        if  nota-fiscal.dt-emis-nota < p-da-dt-corte then
            assign p-da-dt-corte = nota-fiscal.dt-emis-nota.
    
    end.

end procedure.

procedure destroy:

    if valid-handle(h-bocx115) then do:
        delete procedure h-bocx115.
        assign h-bocx115 = ?.
    end.
    if valid-handle(h-bocx180) then do:
        delete procedure h-bocx180.
        assign h-bocx180 = ?.
    end.
    if valid-handle(h-bocx200) then do:
        delete procedure h-bocx200.
        assign h-bocx200 = ?.
    end.
    if valid-handle(h-boun006) then do:
        DELETE PROCEDURE h-boun006.
        assign h-boun006 = ?.
    end.

    if valid-handle(h-exapi025) then do:
        delete procedure h-exapi025.
        assign h-exapi025 = ?.
    end.
    
    &if defined(bf_comex206b-1) &then
        if valid-handle(h-bocx195) then do:
           delete procedure h-bocx195.
           assign h-bocx195 = ?.
        end.
    &endif
    DELETE PROCEDURE THIS-PROCEDURE.

end procedure.

PROCEDURE piPreparaCancelamento:

    &if defined(bf_comex206b-1) &then
        def input param prw-rowid as rowid no-undo.
 
        find first {&TABLE-NAME} no-lock
             where rowid({&TABLE-NAME}) = prw-rowid no-error.
        if not avail {&TABLE-NAME} then
           return "OK":U.
        
        def buffer b-ped-ent for ped-ent.
        
        def var de-qt-faturada-1 like it-nota-fisc.qt-faturada[1] no-undo.

        DEFINE VARIABLE c-unid-conver       AS   CHAR              NO-UNDO.
        DEFINE VARIABLE de-qtd-conver       LIKE ped-ent.qt-pedida NO-UNDO.
        DEFINE VARIABLE i-idi-unid-fatur    AS INTEGER             NO-UNDO.

        empty temp-table tt-ped-ent-novo.
        empty temp-table tt-ped-ent-orig.
        empty temp-table tt-ped-item-novo.
        empty temp-table tt-ped-item-orig.
        empty temp-table tt-bo-erro-aux.
        empty temp-table RowErrors.

        if {&TABLE-NAME}.cod-sit-proc = 1 then do: /* Aberto */
            for each  proc-ped-ent no-lock 
                where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
                and   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:

                for first ped-ent no-lock
                    where ped-ent.nome-abrev   = proc-ped-ent.nome-abrev       
                    and   ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli         
                    and   ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia   
                    and   ped-ent.it-codigo    = proc-ped-ent.it-codigo         
                    and   ped-ent.cod-refer    = proc-ped-ent.cod-refer         
                    and   ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:

                    if proc-ped-ent.quantidade[1] < ped-ent.qt-pedida then do:
                        /* tt-ped-ent-novo */
                        create tt-ped-ent-novo.
                        buffer-copy ped-ent except qt-pedida qt-atendida to tt-ped-ent-novo.
                        assign tt-ped-ent-novo.qt-pedida    = proc-ped-ent.quantidade[1] 
                               tt-ped-ent-novo.qt-atendida  = 0.
                        /* tt-ped-ent-orig */
                        create tt-ped-ent-orig.
                        buffer-copy ped-ent except qt-pedida qt-atendida to tt-ped-ent-orig.
                        assign tt-ped-ent-orig.qt-pedida    = ped-ent.qt-pedida - proc-ped-ent.quantidade[1] 
                               tt-ped-ent-orig.qt-atendida  = ped-ent.qt-atendida
                               tt-ped-ent-orig.r-rowid      = rowid(ped-ent).

                        for first ped-item no-lock
                            where ped-item.nome-abrev   = proc-ped-ent.nome-abrev
                            and   ped-item.nr-pedcli    = proc-ped-ent.nr-pedcli         
                            and   ped-item.nr-sequencia = proc-ped-ent.nr-sequencia   
                            and   ped-item.it-codigo    = proc-ped-ent.it-codigo         
                            and   ped-item.cod-refer    = proc-ped-ent.cod-refer:
                            /* tt-ped-item-novo */
                            find first tt-ped-item-novo
                                 where tt-ped-item-novo.nome-abrev   = proc-ped-ent.nome-abrev       
                                 and   tt-ped-item-novo.nr-pedcli    = proc-ped-ent.nr-pedcli         
                                 and   tt-ped-item-novo.nr-sequencia = proc-ped-ent.nr-sequencia   
                                 and   tt-ped-item-novo.it-codigo    = proc-ped-ent.it-codigo         
                                 and   tt-ped-item-novo.cod-refer    = proc-ped-ent.cod-refer no-error.
                            if not avail tt-ped-item-novo then do:
                                create tt-ped-item-novo.
                                buffer-copy ped-item except qt-pedida qt-atendida to tt-ped-item-novo.                               
                            end.                
                            
                          ASSIGN i-idi-unid-fatur = IF tt-ped-item-novo.ind-fat-qtfam THEN 2 
                                               ELSE IF NOT tt-ped-item-novo.ind-fat-qtfam THEN 1 
                                                    ELSE 3.
                          assign tt-ped-item-novo.qt-pedida    = tt-ped-item-novo.qt-pedida + proc-ped-ent.quantidade[1]
                                 tt-ped-item-novo.qt-atendida  = 0.

                          RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-ped-ent-orig.it-codigo,
                                                                              INPUT  tt-ped-ent-orig.nome-abrev,
                                                                              INPUT  i-idi-unid-fatur,
                                                                              INPUT  tt-ped-item-novo.qt-pedida,
                                                                              INPUT  tt-ped-item-novo.des-un-medida,
                                                                              OUTPUT de-qtd-conver,
                                                                              OUTPUT c-unid-conver).
                        IF i-idi-unid-fatur = 1 THEN
                            ASSIGN tt-ped-item-novo.qt-un-fat    = tt-ped-item-novo.qt-pedida.
                        ELSE 
                            ASSIGN tt-ped-item-novo.qt-un-fat    = de-qtd-conver.

                          /* tt-ped-item-orig */
                          find first tt-ped-item-orig no-lock
                              where tt-ped-item-orig.nome-abrev   = proc-ped-ent.nome-abrev       
                                and tt-ped-item-orig.nr-pedcli    = proc-ped-ent.nr-pedcli         
                                and tt-ped-item-orig.nr-sequencia = proc-ped-ent.nr-sequencia   
                                and tt-ped-item-orig.it-codigo    = proc-ped-ent.it-codigo         
                                and tt-ped-item-orig.cod-refer    = proc-ped-ent.cod-refer no-error.
                          if not avail tt-ped-item-orig then do:
                              create tt-ped-item-orig.
                              buffer-copy ped-item except qt-pedida qt-atendida 
                                                         to tt-ped-item-orig.
                          end.                              
                          assign tt-ped-item-orig.qt-pedida    = tt-ped-item-orig.qt-pedida + (ped-ent.qt-pedida - proc-ped-ent.quantidade[1])
                                 tt-ped-item-orig.qt-un-fat    = tt-ped-item-orig.qt-un-fat + (ped-ent.qt-un-fat - proc-ped-ent.quantidade[2]) 
                                 tt-ped-item-orig.qt-atendida  = ped-item.qt-atendida
                                 tt-ped-item-orig.r-rowid      = rowid(ped-item).
                      
                        end.
                    end.
                end.
            end.
        end.
        else if {&TABLE-NAME}.cod-sit-proc = 7 then do: /* Faturado Parcial */
            for each  proc-ped-ent no-lock 
                where proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
                and   proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp,
                first ped-ent no-lock
                where ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                and   ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
                and   ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                and   ped-ent.it-codigo    = proc-ped-ent.it-codigo
                and   ped-ent.cod-refer    = proc-ped-ent.cod-refer
                and   ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:

                assign de-qt-faturada-1 = 0.
                for each  proc-it-nota-fisc no-lock
                    where proc-it-nota-fisc.nome-abrev   = proc-ped-ent.nome-abrev
                    and   proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli
                    and   proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia
                    and   proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo
                    and   proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer
                    and   proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega
                    and   proc-it-nota-fisc.nr-proc-exp  = proc-ped-ent.nr-proc-exp ,
                    first it-nota-fisc no-lock
                    where it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam 
                    and   it-nota-fisc.serie       = proc-it-nota-fisc.serie
                    and   it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
                    and   it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat
                    and   it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo:

                    FOR FIRST proc-nota-fiscal NO-LOCK
                        WHERE proc-nota-fiscal.cod-estabel       = proc-it-nota-fisc.cod-estabel
                        AND   proc-nota-fiscal.nr-proc-exp       = proc-it-nota-fisc.nr-proc-exp
                        and   proc-nota-fiscal.cod-estab-faturam = proc-it-nota-fisc.cod-estab-faturam
                        AND   proc-nota-fiscal.serie             = proc-it-nota-fisc.serie
                        AND   proc-nota-fiscal.nr-nota-fis       = proc-it-nota-fisc.nr-nota-fis: 
                    END.
                 
                    IF  AVAIL proc-nota-fiscal 
                    AND proc-nota-fiscal.log-nf-devolvid <> YES THEN DO:

                        find first nota-fiscal no-lock 
                                     where nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                                     and   nota-fiscal.serie       = proc-nota-fiscal.serie      
                                     and   nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis no-error.
                        if  avail nota-fiscal
                        AND nota-fiscal.dt-cancela = ? THEN do:
                            assign de-qt-faturada-1 = de-qt-faturada-1  + it-nota-fisc.qt-faturada[1].
                            for first devol-cli fields(qt-devolvida cod-estabel serie nr-nota-fis it-codigo) where
                                      devol-cli.cod-estabel = it-nota-fisc.cod-estabel and
                                      devol-cli.serie       = it-nota-fisc.serie       and
                                      devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis and
                                      devol-cli.it-codigo   = it-nota-fisc.it-codigo no-lock: 
                                 assign de-qt-faturada-1 = de-qt-faturada-1 - devol-cli.qt-devolvida.
                            end.
                        end.
                    END.
                end.

                IF  ped-ent.cod-sit-ent = 3 or         
                    ped-ent.cod-sit-ent = 5 or         
                    ped-ent.cod-sit-ent = 6 then NEXT. /*ped-ent faturados, cancelados ou suspensos */
               
                if  de-qt-faturada-1  = 0 and (proc-ped-ent.quantidade[1] = ped-ent.qt-pedida) then do:  /*proc-ped-ent nÆo faturado */
                     create tt-proc-ped-ent-aux1.
                     buffer-copy proc-ped-ent to tt-proc-ped-ent-aux1.
                end.

                if de-qt-faturada-1 <> 0 and (proc-ped-ent.quantidade[1] > de-qt-faturada-1) /*proc-ped-ent faturados parciais */ or
                   de-qt-faturada-1  = 0 and (proc-ped-ent.quantidade[1] <> ped-ent.qt-pedida) then do:
                    if de-qt-faturada-1 = 0 then
                        assign de-qt-faturada-1 = proc-ped-ent.quantidade[1].
                    /* tt-ped-ent-novo */
                    create tt-ped-ent-novo.
                    buffer-copy ped-ent except qt-pedida qt-atendida cod-sit-ent to tt-ped-ent-novo.
                    assign tt-ped-ent-novo.qt-pedida    = proc-ped-ent.quantidade[1] - de-qt-faturada-1 
                           tt-ped-ent-novo.qt-atendida  = 0
                           tt-ped-ent-novo.cod-sit-ent  = 1. /* o saldo não faturado das entregas deverá ser cancelado -> bodi149can (UpdateCancelation) */
                    /* tt-ped-ent-orig */
                    create tt-ped-ent-orig.
                    buffer-copy ped-ent except qt-pedida qt-atendida to tt-ped-ent-orig.
                    assign tt-ped-ent-orig.qt-pedida-proc = de-qt-faturada-1 
                           /* A quantidade pedida será alterada para: (quantidade faturada no processo + quantidade em aberto não relacionada ao processo de exporta‡Æo) */
                           tt-ped-ent-orig.qt-pedida      = de-qt-faturada-1  + (ped-ent.qt-pedida - proc-ped-ent.quantidade[1])
                           tt-ped-ent-orig.qt-atendida    = tt-ped-ent-orig.qt-pedida
                           tt-ped-ent-orig.r-rowid        = rowid(ped-ent).
                    for first ped-item no-lock
                        where ped-item.nome-abrev   = proc-ped-ent.nome-abrev
                        and   ped-item.nr-pedcli    = proc-ped-ent.nr-pedcli
                        and   ped-item.nr-sequencia = proc-ped-ent.nr-sequencia
                        and   ped-item.it-codigo    = proc-ped-ent.it-codigo
                        and   ped-item.cod-refer    = proc-ped-ent.cod-refer:

                        /* tt-ped-item-novo */
                        find first tt-ped-item-novo no-lock
                             where tt-ped-item-novo.nome-abrev   = proc-ped-ent.nome-abrev
                             and   tt-ped-item-novo.nr-pedcli    = proc-ped-ent.nr-pedcli
                             and   tt-ped-item-novo.nr-sequencia = proc-ped-ent.nr-sequencia
                             and   tt-ped-item-novo.it-codigo    = proc-ped-ent.it-codigo
                             and   tt-ped-item-novo.cod-refer    = proc-ped-ent.cod-refer no-error.
                        if not avail tt-ped-item-novo then do:
                            create tt-ped-item-novo.
                            buffer-copy ped-item except qt-pedida qt-atendida qt-alocada qt-un-fat to tt-ped-item-novo.
                        end.

                        ASSIGN i-idi-unid-fatur = IF tt-ped-item-novo.ind-fat-qtfam THEN 2 
                                                  ELSE IF NOT tt-ped-item-novo.ind-fat-qtfam THEN 1 
                                                       ELSE 3.

                        assign tt-ped-item-novo.qt-pedida    = tt-ped-item-novo.qt-pedida   + (proc-ped-ent.quantidade[1] - de-qt-faturada-1)
                               tt-ped-item-novo.qt-alocada   = 0
                               tt-ped-item-novo.qt-atendida  = 0.
                               
                        RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-ped-ent-orig.it-codigo,
                                                                            INPUT  tt-ped-ent-orig.nome-abrev,
                                                                            INPUT  i-idi-unid-fatur,
                                                                            INPUT  tt-ped-item-novo.qt-pedida,
                                                                            INPUT  tt-ped-item-novo.des-un-medida,
                                                                            OUTPUT de-qtd-conver,
                                                                            OUTPUT c-unid-conver).
                        IF i-idi-unid-fatur = 1 THEN
                            ASSIGN tt-ped-item-novo.qt-un-fat    = tt-ped-item-novo.qt-pedida.
                        ELSE 
                            ASSIGN tt-ped-item-novo.qt-un-fat    = de-qtd-conver.

                        find first tt-ped-item-orig no-lock
                             where tt-ped-item-orig.nome-abrev   = ped-ent.nome-abrev
                             and   tt-ped-item-orig.nr-pedcli    = ped-ent.nr-pedcli
                             and   tt-ped-item-orig.nr-sequencia = ped-ent.nr-sequencia
                             and   tt-ped-item-orig.it-codigo    = ped-ent.it-codigo
                             and   tt-ped-item-orig.cod-refer    = ped-ent.cod-refer no-error.

                        if not avail tt-ped-item-orig then do:
                            CREATE tt-ped-item-orig.
                            buffer-copy ped-item except qt-pedida qt-atendida to tt-ped-item-orig.
                        end.
                        assign tt-ped-item-orig.qt-pedida    = de-qt-faturada-1  + (ped-item.qt-pedida - proc-ped-ent.quantidade[1])
                               tt-ped-item-orig.qt-un-fat    = tt-ped-item-orig.qt-un-fat + (ped-ent.qt-un-fat - proc-ped-ent.quantidade[2]) 
                               tt-ped-item-orig.qt-atendida  = ped-item.qt-atendida /*Este não muda*/
                               tt-ped-item-orig.r-rowid      = rowid(ped-item).

                        ASSIGN i-idi-unid-fatur = IF tt-ped-item-orig.ind-fat-qtfam THEN 2 
                                                  ELSE IF NOT tt-ped-item-orig.ind-fat-qtfam THEN 1 
                                                       ELSE 3.
                        RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-ped-item-orig.it-codigo,
                                                                            INPUT  tt-ped-item-orig.nome-abrev,
                                                                            INPUT  i-idi-unid-fatur,
                                                                            INPUT  tt-ped-item-orig.qt-pedida,
                                                                            INPUT  tt-ped-item-orig.des-un-medida,
                                                                            OUTPUT de-qtd-conver,
                                                                            OUTPUT c-unid-conver).
                        IF i-idi-unid-fatur = 1 THEN
                            ASSIGN tt-ped-item-orig.qt-un-fat    = tt-ped-item-orig.qt-pedida.
                        ELSE 
                            ASSIGN tt-ped-item-orig.qt-un-fat    = de-qtd-conver.
                    end.
                end.
            end.
        end.
		
		IF  VALID-HANDLE(h-bocx195) THEN DO:
			DELETE PROCEDURE h-bocx195.
			ASSIGN h-bocx195 = ?.
		END.
		
        run pi-cria-nova-seq in this-procedure (input table tt-ped-item-novo,
                                                input table tt-ped-item-orig,
                                                input table tt-ped-ent-novo,
                                                input table tt-ped-ent-orig).
        if return-value = "NOK":U then 
            return "NOK":U.
        return "OK":U.
    &endif
END PROCEDURE.

PROCEDURE pi-cria-nova-seq:

    &if defined(bf_comex206b-1) &then    
        DEF INPUT PARAMETER TABLE FOR tt-ped-item-novo.
        DEF INPUT PARAMETER TABLE FOR tt-ped-item-orig.
        DEF INPUT PARAMETER TABLE FOR tt-ped-ent-novo.
        DEF INPUT PARAMETER TABLE FOR tt-ped-ent-orig.

        DEFINE VARIABLE i-sequencia         AS   INTEGER               NO-UNDO.
        DEFINE VARIABLE i-nr-sequencia-orig AS   INTEGER               NO-UNDO.
        DEFINE VARIABLE i-nr-entrega        AS   INTEGER               NO-UNDO.
        DEFINE VARIABLE h-bodi149           AS   HANDLE                NO-UNDO.
        DEFINE VARIABLE h-bodi154           AS   HANDLE                NO-UNDO.
        DEFINE VARIABLE h-bodi159com        AS   HANDLE                NO-UNDO.
        DEFINE VARIABLE r-chave             AS   ROWID                 NO-UNDO.
        DEFINE VARIABLE r-ped-item          AS   ROWID                 NO-UNDO.
        DEFINE VARIABLE r-rowid-ped-item    AS   ROWID                 NO-UNDO.
        DEFINE VARIABLE c-unid-conver       AS   CHAR                  NO-UNDO.
        DEFINE VARIABLE de-qtd-conver       LIKE ped-ent.qt-pedida     NO-UNDO.
        DEFINE VARIABLE i-cod-sit-ped       LIKE ped-venda.cod-sit-ped NO-UNDO.
        DEFINE VARIABLE i-entrega-nova      LIKE ped-ent.nr-entrega    NO-UNDO.        
        
        DEFINE BUFFER b-ped-item     FOR ped-item.
        DEFINE BUFFER b-ped-venda    FOR ped-venda.
        DEFINE BUFFER b-ped-ent      FOR ped-ent.
        DEFINE BUFFER b-proc-ped-ent FOR proc-ped-ent.

        DEFINE BUFFER b-tt-ped-item-novo     FOR tt-ped-item-novo.
    
        IF NOT VALID-HANDLE(h-bodi149)               OR
           h-bodi149:TYPE      <> "PROCEDURE":U      OR
           h-bodi149:FILE-NAME <> "dibo/bodi149.p":U THEN DO:
           RUN dibo/bodi149.p PERSISTENT SET h-bodi149.
        END.
        
        IF NOT VALID-HANDLE(h-bodi154)               OR
           h-bodi154:TYPE      <> "PROCEDURE":U      OR
           h-bodi154:FILE-NAME <> "dibo/bodi154.p":U THEN DO:
           RUN dibo/bodi154.p PERSISTENT SET h-bodi154.
        END.

        IF NOT VALID-HANDLE(h-bocx195) THEN
           RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
        
        EMPTY TEMP-TABLE RowParam.
        
        FOR EACH  tt-ped-item-novo,
            FIRST item FIELDS(peso-bruto peso-liquido) NO-LOCK
            WHERE item.it-codigo = tt-ped-item-novo.it-codigo:

            FIND FIRST b-ped-venda
                 WHERE b-ped-venda.nome-abrev = tt-ped-item-novo.nome-abrev 
                 AND   b-ped-venda.nr-pedcli  = tt-ped-item-novo.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
            IF  NOT AVAIL b-ped-venda THEN NEXT.
            ELSE DO:
                /****************************************************
                * Reabre o Pedido deixando seu status como 'Fatura- *
                * do Parcial'                                       *
                ****************************************************/
                IF b-ped-venda.cod-sit-ped <> 1 OR b-ped-venda.cod-sit-ped <> 2 THEN
                    ASSIGN i-cod-sit-ped           = b-ped-venda.cod-sit-ped
                           b-ped-venda.cod-sit-ped = 2.
            END.
          
            ASSIGN i-nr-sequencia-orig = tt-ped-item-novo.nr-sequencia.
    
            FIND LAST b-ped-item
                WHERE b-ped-item.nome-abrev = tt-ped-item-novo.nome-abrev 
                AND   b-ped-item.nr-pedcli  = tt-ped-item-novo.nr-pedcli  NO-LOCK NO-ERROR.
    
            IF  AVAIL b-ped-item THEN
                ASSIGN i-sequencia = b-ped-item.nr-sequencia + 10.
            ELSE
                ASSIGN i-sequencia = 10.
            
			repeat :
    			FIND LAST b-tt-ped-item-novo
                    WHERE b-tt-ped-item-novo.nome-abrev = tt-ped-item-novo.nome-abrev 
                    AND   b-tt-ped-item-novo.nr-pedcli  = tt-ped-item-novo.nr-pedcli
                    and	  b-tt-ped-item-novo.nr-sequencia-nova = i-sequencia			NO-LOCK NO-ERROR.	
    			if avail b-tt-ped-item-novo then
    			   assign i-sequencia = i-sequencia + 10.
    			else 
                    leave.			
	        end.
    
			
            ASSIGN tt-ped-item-novo.nr-sequencia-nova = i-sequencia.
            
            assign i-entrega-nova = 0.
            /*if b-ped-venda.esp-ped <> 1 then do:*/
                for each tt-ped-ent-novo 
                   where tt-ped-ent-novo.nome-abrev   = tt-ped-item-novo.nome-abrev
                     and tt-ped-ent-novo.nr-pedcli    = tt-ped-item-novo.nr-pedcli
                     and tt-ped-ent-novo.nr-sequencia = tt-ped-item-novo.nr-sequencia
                     and tt-ped-ent-novo.it-codigo    = tt-ped-item-novo.it-codigo
                     and tt-ped-ent-novo.cod-refer    = tt-ped-item-novo.cod-refer:
                     
                    assign i-entrega-nova                    = i-entrega-nova + 10
                           tt-ped-ent-novo.nr-sequencia-nova = i-sequencia
                           tt-ped-ent-novo.nr-entrega-nova   = i-entrega-nova.
                           
                    /*Retira a quantidade que está sendo cancelada do proc-ped-ent para não validar a mensagem 32439 EX3005.i*/
                    find FIRST b-proc-ped-ent exclusive-lock
                       where b-proc-ped-ent.cod-estabel  = {&TABLE-NAME}.cod-estabel
                         and b-proc-ped-ent.nr-proc-exp  = {&TABLE-NAME}.nr-proc-exp
                         and b-proc-ped-ent.nome-abrev   = tt-ped-ent-novo.nome-abrev
                         and b-proc-ped-ent.nr-pedcli    = tt-ped-ent-novo.nr-pedcli
                         and b-proc-ped-ent.nr-sequencia = tt-ped-ent-novo.nr-sequencia
                         and b-proc-ped-ent.it-codigo    = tt-ped-ent-novo.it-codigo
                         and b-proc-ped-ent.cod-refer    = tt-ped-ent-novo.cod-refer
                         and b-proc-ped-ent.nr-entrega   = tt-ped-ent-novo.nr-entrega no-error.
                    if avail b-proc-ped-ent then do:
                    
                       assign b-proc-ped-ent.quantidade[1] = b-proc-ped-ent.quantidade[1] - tt-ped-ent-novo.qt-pedida.
                                       
                       RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  b-proc-ped-ent.it-codigo,
                                                                           INPUT  b-proc-ped-ent.nome-abrev,
                                                                           INPUT  b-proc-ped-ent.idi-unid-fatur,
                                                                           INPUT  b-proc-ped-ent.quantidade[1],
                                                                           INPUT  tt-ped-item-novo.des-un-medida,
                                                                           OUTPUT b-proc-ped-ent.quantidade[2],
                                                                           OUTPUT b-proc-ped-ent.un-fatur).
                       
                       if b-proc-ped-ent.quantidade[1] < 0 then 
                          assign b-proc-ped-ent.quantidade[1] = 0 
                                 b-proc-ped-ent.quantidade[2] = 0.

                    end.
                end.
            /*end.*/

            EMPTY TEMP-TABLE rowpeditem.
            CREATE rowpeditem.
            BUFFER-COPY tt-ped-item-novo EXCEPT nr-sequencia r-rowid TO rowpeditem.
            ASSIGN rowpeditem.nr-sequencia = i-sequencia.
        
            CREATE RowParam.
   
            RUN openQueryStatic IN h-bodi154 (INPUT "Main":U).
            RUN emptyRowObject  IN h-bodi154.
            RUN inputRowParam   IN h-bodi154 (INPUT TABLE RowParam).
            RUN setRecord       IN h-bodi154 (INPUT TABLE rowpeditem).
            RUN emptyRowErrors  IN h-bodi154.
            RUN createRecord    IN h-bodi154.
            RUN getRowErrors    IN h-bodi154 (OUTPUT TABLE RowErrors APPEND).

            IF  CAN-FIND (FIRST RowErrors
                          WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                LEAVE.
            END. 
            
            RUN getRowid IN  h-bodi154 (OUTPUT r-rowid-ped-item).
            FOR EACH tt-ped-item-orig WHERE
                     tt-ped-item-orig.nome-abrev   = tt-ped-item-novo.nome-abrev AND
                     tt-ped-item-orig.nr-pedcli    = tt-ped-item-novo.nr-pedcli  AND
                     tt-ped-item-orig.nr-sequencia = i-nr-sequencia-orig         AND
                     tt-ped-item-orig.it-codigo    = tt-ped-item-novo.it-codigo  AND
                     tt-ped-item-orig.cod-refer    = tt-ped-item-novo.cod-refer:
        
                FOR EACH tt-ped-ent-orig WHERE 
                         tt-ped-ent-orig.nome-abrev   = tt-ped-item-orig.nome-abrev   AND
                         tt-ped-ent-orig.nr-pedcli    = tt-ped-item-orig.nr-pedcli    AND
                         tt-ped-ent-orig.nr-sequencia = tt-ped-item-orig.nr-sequencia AND
                         tt-ped-ent-orig.it-codigo    = tt-ped-item-orig.it-codigo    AND
                         tt-ped-ent-orig.cod-refer    = tt-ped-item-orig.cod-refer:
                    
                    RUN findPk_proc_pedent IN h-bocx195 (INPUT b-ped-venda.cod-estabel,
                                                         INPUT {&TABLE-NAME}.nr-proc-exp, 
                                                         INPUT tt-ped-ent-orig.nome-abrev,
                                                         INPUT tt-ped-ent-orig.nr-pedcli,   
                                                         INPUT tt-ped-ent-orig.nr-sequencia,
                                                         INPUT tt-ped-ent-orig.it-codigo,   
                                                         INPUT tt-ped-ent-orig.cod-refer,   
                                                         INPUT tt-ped-ent-orig.nr-entrega, 
                                                         OUTPUT c-return).
                    IF c-return = "" THEN DO: 
                       RUN getRowid  IN h-bocx195 (OUTPUT r-chave).
                       IF {&TABLE-NAME}.cod-sit-proc = 1 THEN DO: /* Será eliminado o relacionamento da entrega (proc-ped-ent) alocada parcialmente */
                          /*RUN validateDelete IN h-bocx195 (INPUT-OUTPUT r-chave,
                                                           OUTPUT TABLE tt-bo-erro-aux APPEND).*/
                       END.
                       ELSE DO: /* A quantidade relacionada ao processo de exporta‡Æo será alterada ( = quantidade faturada) */
                            EMPTY TEMP-TABLE tt-proc-ped-ent.                           
                            RUN getCurrent IN h-bocx195 (OUTPUT TABLE tt-proc-ped-ent). 
                            FIND FIRST tt-proc-ped-ent NO-ERROR.

                            ASSIGN tt-proc-ped-ent.quantidade[1]  = tt-ped-ent-orig.qt-pedida-proc
                                   tt-proc-ped-ent.peso-liquido   = TRUNC(tt-proc-ped-ent.quantidade[1] * item.peso-liquido,3)   
                                   tt-proc-ped-ent.peso-bruto     = TRUNC(tt-proc-ped-ent.quantidade[1] * item.peso-bruto,3) 
                                   tt-proc-ped-ent.idi-unid-fatur = IF tt-ped-item-novo.ind-fat-qtfam THEN 2 
                                                                       ELSE IF NOT tt-ped-item-novo.ind-fat-qtfam THEN 1 
                                                                            ELSE 3.
      
                            RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-ped-ent-orig.it-codigo,
                                                                                INPUT  tt-ped-ent-orig.nome-abrev,
                                                                                INPUT  tt-proc-ped-ent.idi-unid-fatur,
                                                                                INPUT  tt-proc-ped-ent.quantidade[1],
                                                                                INPUT  tt-ped-item-orig.des-un-medida,
                                                                                OUTPUT de-qtd-conver,
                                                                                OUTPUT c-unid-conver).
                            ASSIGN tt-proc-ped-ent.quantidade[2] = de-qtd-conver.
    
                            IF  tt-proc-ped-ent.idi-unid-fatur = 2 THEN DO:
                                IF  i-pais-impto-usuario  = 3 THEN
                                    ASSIGN tt-proc-ped-ent.vl-preori = ROUND(tt-proc-ped-ent.quantidade[1] * tt-ped-item-novo.vl-preori / tt-proc-ped-ent.quantidade[1], 5)
                                           tt-proc-ped-ent.vl-preuni = ROUND(tt-proc-ped-ent.quantidade[1] * tt-ped-item-novo.vl-preuni / tt-proc-ped-ent.quantidade[1], 5).
                                ELSE
                                    ASSIGN tt-proc-ped-ent.vl-preori = ROUND(tt-proc-ped-ent.quantidade[1] * tt-ped-item-novo.vl-preori / tt-proc-ped-ent.quantidade[2], 5)
                                           tt-proc-ped-ent.vl-preuni = ROUND(tt-proc-ped-ent.quantidade[1] * tt-ped-item-novo.vl-preuni / tt-proc-ped-ent.quantidade[2], 5).
                            END.
                            
                            RUN validateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                                             INPUT r-chave,
                                                             OUTPUT TABLE tt-bo-erro-aux APPEND).
                       END.
                       
                       IF CAN-FIND(FIRST tt-bo-erro-aux) THEN
                          RETURN "NOK":U.
                          
                       if b-ped-venda.esp-ped <> 1 then do:
                            EMPTY TEMP-TABLE rowpedent.
                            CREATE rowpedent.
                            BUFFER-COPY tt-ped-ent-orig except r-rowid TO rowpedent.
                                        
                            RUN openQueryStatic IN h-bodi149 (INPUT "Default":U).
                            RUN emptyRowObject  IN h-bodi149.
                            
                            RUN gotoKey         IN h-bodi149 (INPUT rowpedent.nome-abrev,
                                                              INPUT rowpedent.nr-pedcli,
                                                              INPUT rowpedent.nr-sequencia,
                                                              INPUT rowpedent.it-codigo,
                                                              INPUT rowpedent.cod-refer,
                                                              INPUT rowpedent.nr-entrega).
                            RUN inputRowParam   IN h-bodi149 (INPUT TABLE RowParam).
                            RUN emptyRowErrors  IN h-bodi149.
                            RUN getRowErrors    IN h-bodi149 (OUTPUT TABLE RowErrors APPEND).
                            RUN setRecord       IN h-bodi149 (INPUT TABLE rowpedent).
                            RUN updateRecord    IN h-bodi149.
                            RUN getRowErrors    IN h-bodi149 (OUTPUT TABLE RowErrors APPEND).
            
                            IF  CAN-FIND (FIRST RowErrors
                                          WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                                LEAVE.
                            END.                
                       END.

                    END.
                END.
                
                if b-ped-venda.esp-ped = 1 then do:
                
                    EMPTY TEMP-TABLE rowpeditem.
                    CREATE rowpeditem.
                    BUFFER-COPY tt-ped-item-orig except r-rowid TO rowpeditem.
    
                    RUN openQueryStatic IN h-bodi154 (INPUT "Main":U).
                    RUN emptyRowObject  IN h-bodi154.
                    RUN gotoKey         IN h-bodi154 (INPUT rowpeditem.nome-abrev,
                                                      INPUT rowpeditem.nr-pedcli,
                                                      INPUT rowpeditem.nr-sequencia,
                                                      INPUT rowpeditem.it-codigo,
                                                      INPUT rowpeditem.cod-refer).
                    RUN inputRowParam   IN h-bodi154 (INPUT TABLE RowParam).
                    RUN emptyRowErrors  IN h-bodi154.
                    RUN getRowErrors    IN h-bodi154 (OUTPUT TABLE RowErrors APPEND).
                    RUN setRecord       IN h-bodi154 (INPUT TABLE rowpeditem).
                    RUN updateRecord    IN h-bodi154.
                    RUN getRowErrors    IN h-bodi154 (OUTPUT TABLE RowErrors APPEND).
    
                    IF  CAN-FIND (FIRST RowErrors
                                  WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                        LEAVE.
                    END.
                end.
                else do:
                    EMPTY TEMP-TABLE rowpeditem.
                    CREATE rowpeditem.
                    BUFFER-COPY tt-ped-item-orig except r-rowid TO rowpeditem.
    
                    RUN openQueryStatic IN h-bodi154 (INPUT "Main":U).
                    RUN emptyRowObject  IN h-bodi154.
                    
                    RUN gotoKey         IN h-bodi154 (INPUT rowpeditem.nome-abrev,
                                                      INPUT rowpeditem.nr-pedcli,
                                                      INPUT rowpeditem.nr-sequencia,
                                                      INPUT rowpeditem.it-codigo,
                                                      INPUT rowpeditem.cod-refer).
                    RUN inputRowParam   IN h-bodi154 (INPUT TABLE RowParam).
                    RUN emptyRowErrors  IN h-bodi154.
                    RUN getRowErrors    IN h-bodi154 (OUTPUT TABLE RowErrors APPEND).
                    RUN setRecord       IN h-bodi154 (INPUT TABLE rowpeditem).
                    RUN updateRecord    IN h-bodi154.
                    RUN getRowErrors    IN h-bodi154 (OUTPUT TABLE RowErrors APPEND).
    
                    IF  CAN-FIND (FIRST RowErrors
                                  WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                        LEAVE.
                    END.                
                end.
            END. /*for each tt-ped-item-orig*/
            
            IF NOT AVAIL b-ped-venda THEN
               FOR FIRST b-ped-venda FIELDS(cod-sit-ped)
                   WHERE b-ped-venda.nome-abrev = tt-ped-item-novo.nome-abrev 
                   AND   b-ped-venda.nr-pedcli  = tt-ped-item-novo.nr-pedcli EXCLUSIVE-LOCK: END.
    
            IF NOT AVAIL b-ped-venda THEN DO:
               LEAVE.
            END.
            ELSE DO:
            /****************************************************
            * Desfaz o Pedido deixando-o com seu status original *
            *                                                    *
            ****************************************************/
               IF b-ped-venda.cod-sit-ped <> 1 OR b-ped-venda.cod-sit-ped <> 2 THEN
                     ASSIGN b-ped-venda.cod-sit-ped = i-cod-sit-ped.
            END.

        END. /*for each tt-ped-item-novo*/
        
        for each tt-ped-item-novo no-lock:
           assign l-pri-ent = yes.
           for each tt-ped-ent-novo no-lock
              where tt-ped-ent-novo.nome-abrev   = tt-ped-item-novo.nome-abrev
                and tt-ped-ent-novo.nr-pedcli    = tt-ped-item-novo.nr-pedcli
                and tt-ped-ent-novo.nr-sequencia = tt-ped-item-novo.nr-sequencia
                and tt-ped-ent-novo.it-codigo    = tt-ped-item-novo.it-codigo
                and tt-ped-ent-novo.cod-refer    = tt-ped-item-novo.cod-refer:
                if b-ped-venda.esp-ped <> 1 then do:
                    EMPTY TEMP-TABLE rowpedent.
                    CREATE rowpedent.
                    BUFFER-COPY tt-ped-ent-novo except r-rowid TO rowpedent.
                    ASSIGN rowpedent.nr-sequencia = tt-ped-ent-novo.nr-sequencia-nova 
                           rowpedent.nr-entrega   = tt-ped-ent-novo.nr-entrega-nova.
    
                    RUN openQueryStatic IN h-bodi149 (INPUT "Default":U).
                    RUN emptyRowObject  IN h-bodi149.
                    
                    IF l-pri-ent THEN
                        RUN gotoKey         IN h-bodi149 (INPUT rowpedent.nome-abrev,
                                                          INPUT rowpedent.nr-pedcli,
                                                          INPUT rowpedent.nr-sequencia,
                                                          INPUT rowpedent.it-codigo,
                                                          INPUT rowpedent.cod-refer,
                                                          INPUT rowpedent.nr-entrega).
                                                          
                    RUN inputRowParam   IN h-bodi149 (INPUT TABLE RowParam).
                    RUN emptyRowErrors  IN h-bodi149.
                    RUN getRowErrors    IN h-bodi149 (OUTPUT TABLE RowErrors APPEND).
                    RUN setRecord       IN h-bodi149 (INPUT TABLE rowpedent).
                    IF l-pri-ent THEN DO: 
                        RUN updateRecord    IN h-bodi149.
                        assign l-pri-ent = no.
                    END.    
                    ELSE DO:     
                        RUN createRecord IN h-bodi149.
                    END.
                    RUN getRowErrors IN h-bodi149 (OUTPUT TABLE RowErrors APPEND).
    
                    IF  CAN-FIND (FIRST RowErrors
                                  WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                        LEAVE.
                    END.  
                end.                
                ELSE DO:
                    RUN updateDelivery IN h-bodi149 (INPUT r-rowid-ped-item).
                END.

                /* Atualizar chave */
                find first proc-ped-ent exclusive-lock
                     where proc-ped-ent.cod-estabel  = {&TABLE-NAME}.cod-estabel
                       and proc-ped-ent.nr-proc-exp  = {&TABLE-NAME}.nr-proc-exp
                       and proc-ped-ent.nome-abrev   = tt-ped-ent-novo.nome-abrev
                       and proc-ped-ent.nr-pedcli    = tt-ped-ent-novo.nr-pedcli
                       and proc-ped-ent.nr-sequencia = tt-ped-ent-novo.nr-sequencia
                       and proc-ped-ent.it-codigo    = tt-ped-ent-novo.it-codigo
                       and proc-ped-ent.cod-refer    = tt-ped-ent-novo.cod-refer
                       and proc-ped-ent.nr-entrega   = tt-ped-ent-novo.nr-entrega no-error.
                if avail proc-ped-ent then do:
                    /*cria novo proc-ped-ent com a sequencia que tera seu saldo cancelado*/
                    create tt-proc-ped-ent-aux.
                    buffer-copy proc-ped-ent except nr-sequencia nr-entrega to tt-proc-ped-ent-aux.
                    assign tt-proc-ped-ent-aux.nr-sequencia  = tt-ped-ent-novo.nr-sequencia-nova
                           tt-proc-ped-ent-aux.nr-entrega    = tt-ped-ent-novo.nr-entrega-nova.
                           
                    run validateCreate in h-bocx195 (input  table tt-proc-ped-ent-aux,
                                                     output table tt-bo-erro,
                                                     output tt-proc-ped-ent-aux.r-rowid).
                                                     
                    for each tt-proc-ped-ent-aux:
                        create tt-proc-ped-ent-aux1.
                        buffer-copy tt-proc-ped-ent-aux to tt-proc-ped-ent-aux1.
                    end.
                     
                    EMPTY TEMP-TABLE tt-proc-ped-ent-aux.
                        
                    RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  proc-ped-ent.it-codigo,
                                                                        INPUT  proc-ped-ent.nome-abrev,
                                                                        INPUT  proc-ped-ent.idi-unid-fatur,
                                                                        INPUT  proc-ped-ent.quantidade[1],
                                                                        INPUT  tt-ped-item-novo.des-un-medida,
                                                                        OUTPUT proc-ped-ent.quantidade[2],
                                                                        OUTPUT proc-ped-ent.un-fatur).
                end.              
           end.
        end.
		
		IF  VALID-HANDLE(h-bocx195) THEN DO:
			DELETE PROCEDURE h-bocx195.
			ASSIGN h-bocx195 = ?.
		END.
        
        IF CAN-FIND (FIRST tt-ped-ent-novo) THEN DO:
        
            IF  VALID-HANDLE(h-bodi149) THEN DO:
                DELETE PROCEDURE h-bodi149.
                ASSIGN h-bodi149 = ?.
            END.
            
            IF  VALID-HANDLE(h-bodi154) THEN DO:
                DELETE PROCEDURE h-bodi154.
                ASSIGN h-bodi154 = ?.
            END.
            
            IF  NOT VALID-HANDLE(h-bodi159com)                  OR
                h-bodi159com:TYPE      <> "PROCEDURE":U         OR
                h-bodi159com:FILE-NAME <> "dibo/bodi159com.p":U THEN DO:
                RUN dibo/bodi159com.p PERSISTENT SET h-bodi159com.
            END.
    
            /****************************************************
            * Execucao de rotina para Completar o Pedido        *
            ****************************************************/
            
            RUN setNrInvoice  IN h-bodi159com (INPUT  b-ped-venda.nr-proc-exp).
            RUN completeOrder IN h-bodi159com (INPUT  ROWID(b-ped-venda),
                                               OUTPUT TABLE RowErrors APPEND).
    
            IF  VALID-HANDLE(h-bodi159com) THEN DO:
                DELETE PROCEDURE h-bodi159com.
                ASSIGN h-bodi159com = ?.
            END.
            IF  CAN-FIND (FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                FOR EACH RowErrors WHERE 
                         RowErrors.ErrorSubType = "ERROR":U:
                    CREATE tt-bo-erro-aux.
                    ASSIGN i-seq-erro = i-seq-erro + 1
                           tt-bo-erro-aux.i-sequen = i-seq-erro
                           tt-bo-erro-aux.cd-erro  = RowErrors.ErrorNumber
                           tt-bo-erro-aux.mensagem = RowErrors.ErrorDescription.
                END.
                RETURN "NOK":U.
            END.
        END.            
        RETURN "OK":U.
    &endif
END PROCEDURE.

PROCEDURE piGravarMotivoCancel:

    DEF INPUT PARAM TABLE FOR RowObject.
    DEF INPUT PARAM pc-usuario AS CHAR NO-UNDO.

    DEF BUFFER b-proc-ped-ent-cancel FOR proc-ped-ent.
    
    &IF DEFINED(bf_comex206b-1) &THEN
    
        FIND FIRST RowObject NO-LOCK NO-ERROR.
        
        FIND first param-exp NO-LOCK WHERE
             param-exp.cod-estabel = rowObject.cod-estabel NO-ERROR.
    
        FIND motivo NO-LOCK WHERE
             motivo.cod-motivo   = INTEGER({&PARAM-EXP.CDN-MOTIVO}) AND
             motivo.ind-tp-trans = 1 NO-ERROR.
        
        FOR EACH proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel = RowObject.cod-estabel
             AND proc-ped-ent.nr-proc-exp = RowObject.nr-proc-exp:
    
            FOR EACH ped-ent EXCLUSIVE-LOCK 
               WHERE ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                 AND ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
                 AND ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                 AND ped-ent.it-codigo    = proc-ped-ent.it-codigo
                 AND ped-ent.cod-refer    = proc-ped-ent.cod-refer
                 AND ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:            
                IF ped-ent.cod-sit-ent    = 6 THEN DO:
                    ASSIGN ped-ent.dt-canent    = today
                           ped-ent.desc-cancela = motivo.narrativa + "Cancelamento realizado pelo processo de exportaþÒo: " + proc-ped-ent.nr-proc-exp + " do estabelecimento: " + proc-ped-ent.cod-estabel
                           ped-ent.user-canc    = pc-usuario
                           ped-ent.dt-usercan   = today.
    
                    FIND FIRST ped-item OF ped-ent EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL ped-item AND ped-item.cod-sit-item = 6 THEN DO:
                                            
                        IF NOT CAN-FIND (FIRST tt-ped-item-aux NO-LOCK WHERE
                                               tt-ped-item-aux.nome-abrev   = ped-item.nome-abrev   AND
                                               tt-ped-item-aux.nr-pedcli    = ped-item.nr-pedcli    AND
                                               tt-ped-item-aux.nr-sequencia = ped-item.nr-sequencia AND
                                               tt-ped-item-aux.it-codigo    = ped-item.it-codigo    AND
                                               tt-ped-item-aux.cod-refer    = ped-item.cod-refer    AND
                                               tt-ped-item-aux.cod-estabel  = proc-ped-ent.cod-estabel and
                                               tt-ped-item-aux.nr-proc-exp  = proc-ped-ent.nr-proc-exp) THEN DO:
                                                   
                            CREATE tt-ped-item-aux.
                            ASSIGN tt-ped-item-aux.nome-abrev   = ped-item.nome-abrev   
                                   tt-ped-item-aux.nr-pedcli    = ped-item.nr-pedcli    
                                   tt-ped-item-aux.nr-sequencia = ped-item.nr-sequencia 
                                   tt-ped-item-aux.it-codigo    = ped-item.it-codigo    
                                   tt-ped-item-aux.cod-refer    = ped-item.cod-refer    
                                   tt-ped-item-aux.cod-estabel  = proc-ped-ent.cod-estabel
                                   tt-ped-item-aux.nr-proc-exp  = proc-ped-ent.nr-proc-exp. 
                                
                            ASSIGN ped-item.dt-canseq    = today
                                   ped-item.dt-usercan   = today
                                   ped-item.user-canc    = pc-usuario.                           
                            IF ped-item.cod-mot-canc-cot = 0 THEN 
                                ASSIGN ped-item.cod-mot-canc-cot = motivo.cod-motivo
                                       ped-item.desc-cancela     = motivo.narrativa + " Cancelamento realizado pelo(s) seguinte(s) processo(s) de exportaþÒo: " + chr(10) + "Est: " + proc-ped-ent.cod-estabel + " Proc: " + proc-ped-ent.nr-proc-exp.
                            ELSE 
                                ASSIGN ped-item.desc-cancela = ped-item.desc-cancela + chr(10) + " Est: " + proc-ped-ent.cod-estabel + " Proc: " + proc-ped-ent.nr-proc-exp.
                        END.                   

                        FIND FIRST ped-venda OF ped-item EXCLUSIVE-LOCK NO-ERROR.        
                        IF AVAIL ped-venda AND ped-venda.cod-sit-ped = 6 THEN DO:
                                    
                            FOR EACH b-proc-ped-ent-cancel WHERE 
                                     b-proc-ped-ent-cancel.nome-abrev = proc-ped-ent.nome-abrev and
                                     b-proc-ped-ent-cancel.nr-pedcli  = proc-ped-ent.nr-pedcli NO-LOCK:
                                     
                                IF NOT CAN-FIND (FIRST tt-ped-venda-aux NO-LOCK WHERE
                                                       tt-ped-venda-aux.nr-pedido   = b-proc-ped-ent-cancel.nr-pedido   AND
                                                       tt-ped-venda-aux.cod-estabel = b-proc-ped-ent-cancel.cod-estabel AND
                                                       tt-ped-venda-aux.nr-proc-exp = b-proc-ped-ent-cancel.nr-proc-exp) THEN DO:
    
                                    CREATE tt-ped-venda-aux.
                                    ASSIGN tt-ped-venda-aux.nr-pedido   = b-proc-ped-ent-cancel.nr-pedido
                                           tt-ped-venda-aux.cod-estabel = b-proc-ped-ent-cancel.cod-estabel
                                           tt-ped-venda-aux.nr-proc-exp = b-proc-ped-ent-cancel.nr-proc-exp.
                                           
                                    ASSIGN ped-venda.dt-cancela = today
                                           ped-venda.dt-usercan = today
                                           ped-venda.user-canc  = pc-usuario.       
                                                                   
                                    IF ped-venda.cod-mot-canc-cot = 0 THEN 
                                        ASSIGN ped-venda.cod-mot-canc-cot = motivo.cod-motivo
                                               ped-venda.desc-cancela     = motivo.narrativa + " Cancelamento realizado pelo(s) seguinte(s) processo(s) de exportaþÒo: " + chr(10) + "Est: " + b-proc-ped-ent-cancel.cod-estabel + " Proc: " + b-proc-ped-ent-cancel.nr-proc-exp.
                                    ELSE 
                                        ASSIGN ped-venda.desc-cancela = ped-venda.desc-cancela + chr(10) + " Est: " + b-proc-ped-ent-cancel.cod-estabel + " Proc: " + b-proc-ped-ent-cancel.nr-proc-exp.
                                END.
                            end.
                        END.
                    END.
                END.
            END.
        END.
        
    &ENDIF    

    RETURN "OK":U.
    
END PROCEDURE.

procedure atualizaDiscrepancias:
   define input parameter c-cod-estabel  like processo-exp.cod-estabel no-undo.
   define input parameter c-nr-processo  like processo-exp.nr-proc-exp no-undo.
   define input parameter c-nr-pedcli    like ped-venda-cex.nr-pedcli  no-undo.
   define input parameter c-nome-abrev   like ped-venda-cex.nome-abrev no-undo.
   
   find first ped-venda-cex
        where ped-venda-cex.nr-pedcli  = c-nr-pedcli
          and ped-venda-cex.nome-abrev = c-nome-abrev no-lock no-error.
        
   if avail ped-venda-cex then do:
      find first processo-exp
           where processo-exp.cod-estabel = c-cod-estabel
             and processo-exp.nr-proc-exp = c-nr-processo exclusive-lock no-error.
      if avail processo-exp then do:
         /* Somente atualiza quando nao tiver nada preenchido */
         if processo-exp.cod-consign    = 0 then
            assign processo-exp.cod-consign    = ped-venda-cex.cod-consign.
         if processo-exp.cod-notif      = 0 then
            assign processo-exp.cod-notif      = ped-venda-cex.cod-notif.
         if processo-exp.cod-notif2     = 0 then
            assign processo-exp.cod-notif2     = ped-venda-cex.cod-notif2.
         /* O cliente final ja ‚ atualizado na inclusão do processo de exporta‡Æo, porem caso o usuário
            informe outro cliente final no pedido, deve permanecer o cliente final do pedido e não do processo*/
         if  processo-exp.cdn-emit-final = 0 
         or  processo-exp.cdn-emit-final <> ped-venda-cex.cdn-emit-final
         and not can-find(first proc-ped-ent where proc-ped-ent.cod-estabel = processo-exp.cod-estabel
                                               and proc-ped-ent.nr-proc-exp = processo-exp.nr-proc-exp) then
             assign processo-exp.cdn-emit-final = ped-venda-cex.cdn-emit-final.
         if processo-exp.cod-transp-int = 0 then
            assign processo-exp.cod-transp-int = ped-venda-cex.cod-transp-int.
         
         run piAtualizaEndereco.
       end.
   end. 
   
   return "OK":U.
   
end procedure.

procedure piAtualizaEndereco:

    IF processo-exp.cod-notif = ped-venda-cex.cod-notif THEN DO:
        FIND FIRST b-emitente WHERE b-emitente.cod-emitente = ped-venda-cex.cod-notif NO-LOCK NO-ERROR.
        IF AVAIL b-emitente then do:
           if b-emitente.cod-emitente <> 0 THEN
              ASSIGN processo-exp.nome-notif     = b-emitente.nome-emit
                     processo-exp.end-notif      = b-emitente.endereco
                     processo-exp.bairro-notif   = b-emitente.bairro
                     processo-exp.cidade-notif   = b-emitente.cidade
                     processo-exp.estado-notif   = b-emitente.estado
                     processo-exp.cep-notif      = b-emitente.cep
                     processo-exp.pais-notif     = b-emitente.pais.
        end.
    END.

    IF processo-exp.cod-consign = ped-venda-cex.cod-consign THEN DO:
        FIND FIRST b-emitente WHERE b-emitente.cod-emitente = ped-venda-cex.cod-consign NO-LOCK NO-ERROR.
        IF AVAIL b-emitente then do:
           if b-emitente.cod-emitente <> 0 THEN
              ASSIGN processo-exp.nome-consign     = b-emitente.nome-emit
                     processo-exp.end-consign      = b-emitente.endereco
                     processo-exp.bairro-consign   = b-emitente.bairro
                     processo-exp.cidade-consign   = b-emitente.cidade
                     processo-exp.estado-consign   = b-emitente.estado
                     processo-exp.cep-consign      = b-emitente.cep
                     processo-exp.pais-consign     = b-emitente.pais.
        end.
    END.
        
    IF processo-exp.cod-transp-int = ped-venda-cex.cod-transp-int THEN DO:
        FOR FIRST b-emitente FIELDS(cod-emitente nome-emit endereco bairro cidade estado cep pais)  
            WHERE b-emitente.cod-emitente = ped-venda-cex.cod-transp-int NO-LOCK: END.
        IF AVAIL b-emitente then do:
           if b-emitente.cod-emitente <> 0 THEN DO:
                   ASSIGN &IF ("&EMSDBTYPE") <> "progress" &THEN
                            processo-exp.nome-transp     = substring(b-emitente.nome-emit,1,40)  
                          &ELSE
                            processo-exp.nome-transp     = b-emitente.nome-emit
                          &ENDIF
                     processo-exp.end-transp      = b-emitente.endereco
                     processo-exp.bairro-transp   = b-emitente.bairro
                     processo-exp.cidade-transp   = b-emitente.cidade
                     processo-exp.estado-transp   = b-emitente.estado
                     processo-exp.cep-transp      = b-emitente.cep
                     processo-exp.pais-transp     = b-emitente.pais.
           END.
        end.
    END.

    IF processo-exp.cod-notif2 = ped-venda-cex.cod-notif2 THEN DO:
        FOR FIRST b-emitente FIELDS(cod-emitente nome-emit endereco bairro cidade estado cep pais)  
            WHERE b-emitente.cod-emitente = ped-venda-cex.cod-notif2 NO-LOCK: END.
        IF AVAIL b-emitente then do:
           if b-emitente.cod-emitente <> 0 THEN
              ASSIGN processo-exp.nome-notif2     = b-emitente.nome-emit
                     processo-exp.end-notif2      = b-emitente.endereco
                     processo-exp.bairro-notif2   = b-emitente.bairro
                     processo-exp.cidade-notif2   = b-emitente.cidade
                     processo-exp.estado-notif2   = b-emitente.estado
                     processo-exp.cep-notif2      = b-emitente.cep
                     processo-exp.pais-notif2     = b-emitente.pais.
        end.
    END.
    
    FOR FIRST b-emitente FIELDS(cod-emitente nome-emit endereco bairro cidade estado cep pais)  
        WHERE b-emitente.cod-emitente = ped-venda-cex.cdn-emit-final NO-LOCK: END.
    IF AVAIL b-emitente then do:
       if b-emitente.cod-emitente <> 0 THEN
          ASSIGN processo-exp.nom-emit-final          = b-emitente.nome-emit
                 processo-exp.des-end-emit-final      = b-emitente.endereco
                 processo-exp.nom-bairro-emit-final   = b-emitente.bairro
                 processo-exp.nom-cidad-emit-final    = b-emitente.cidade
                 processo-exp.cod-estado-emit-final   = b-emitente.estado
                 processo-exp.cod-cep-emit-final      = b-emitente.cep
                 processo-exp.cod-pais-emit-final     = b-emitente.pais.
    end.

    return "OK":U.
end procedure.

procedure validaFatProcExp:
   /*
   ** No EMS5, quando a fatura esta para ser criada com o numero do processo 
   ** de exportacao (ft0301) devera ser permitido informar apenas 
   ** ate 10 caracteres devido ao tiulo no CR permitir ter apenas 10 caracteres
   ** No EMS2, o titulo no CR permite ter ate 16 caracteres
   */
    define input parameter pc-nr-proc-exp like processo-exp.nr-proc-exp no-undo.

    if can-find(first funcao 
                where funcao.cd-funcao = "adm-acr-ems-5.00":U
                   and funcao.ativo     = yes
                   and funcao.log-1     = yes) then do:
        find first para-fat no-lock no-error.
        if  avail para-fat 
        and para-fat.ind-docum-fatura = 2 then do:
        
            if length(pc-nr-proc-exp) > 10 then do:
               {utp/ut-liter.i Processo_de_Exporta‡Æo * L}
               assign c-literal  = trim(return-value)
                      i-seq-erro = i-seq-erro + 1.
               run utp/ut-msgs.p (input "msg":U,
                                  input 33294,
                                  input c-literal + " " + pc-nr-proc-exp).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 33294
                      tt-bo-erro.mensagem     = trim(return-value).
            end.
        end.
    end.
    
    return "OK":U.

end procedure.

procedure piVerificaTamanhoProcExp:
define input  parameter pc-nr-proc-exp like processo-exp.nr-proc-exp no-undo.
define output parameter l-erro         as   logical                  no-undo.
define output parameter l-existe       as   logical                  no-undo.
define output parameter i-cod-msg      as   integer                  no-undo.
define output parameter c-literal      as   char format "x(25)":U    no-undo.
                                                                   
    if can-find(first funcao 
                where funcao.cd-funcao = "adm-acr-ems-5.00":U 
                  and funcao.ativo     = yes
                  and funcao.log-1     = yes) then do:
            find first para-fat no-lock no-error.
            if  avail para-fat 
            and para-fat.ind-docum-fatura = 2 then do:
            
                if length(pc-nr-proc-exp) > 10 then do:
                   {utp/ut-liter.i Processo_de_Exporta‡Æo * L}
                   assign c-literal  = trim(return-value).
                   
                   assign l-existe  = yes
                          l-erro    = yes
                          i-cod-msg = 33294.
                end.
            end.
    end.
    
    return "OK":U.
end procedure.

procedure piSetaValidacao:

    define input parameter pl-valida as logical no-undo.
        
    assign l-valida-ex0201 = pl-valida.
    
    return "OK":U.
end procedure.

PROCEDURE atualizaProcessoPelaNotaFiscal:
    DEF INPUT PARAM p-cod-estabel  as char no-undo.
    DEF INPUT PARAM p-serie        as char no-undo.
    DEF INPUT PARAM p-nr-nota-fis  as char no-undo.
    DEF INPUT PARAM p-nr-proc-exp  AS CHAR FORMAT "x(12)" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR  tt-bo-erro-5.
    DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = p-cod-estabel
           AND nota-fiscal.serie       = p-serie    
           AND nota-fiscal.nr-nota-fis = p-nr-nota-fis NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        IF l-gera-novo-titulo 
        OR nota-fiscal.dt-atual-cr <> ? THEN DO:

            RUN atualizaProcessoTitulosCR (INPUT p-cod-estabel, 
                                           INPUT p-serie,      
                                           INPUT p-nr-nota-fis,
                                           INPUT p-nr-proc-exp,
                                           OUTPUT TABLE tt-bo-erro-5,
                                           INPUT-OUTPUT TABLE tt-bo-erro).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE atualizaProcessoPeloEmbarque:
    DEF INPUT PARAM p-Embarque AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-nr-proc-exp  AS CHAR FORMAT "x(12)" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR  tt-bo-erro-5.
    DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    FOR EACH nota-fiscal FIELDS(nat-operacao cod-estabel nr-nota-fis nr-proc-exp serie dt-atual-cr) NO-LOCK
       WHERE nota-fiscal.cdd-embarq   = p-Embarque
         AND (l-gera-novo-titulo OR nota-fiscal.dt-atual-cr <> ?):
         RUN atualizaProcessoTitulosCR (INPUT nota-fiscal.cod-estabel, 
                                        INPUT nota-fiscal.Serie,      
                                        INPUT nota-fiscal.nr-nota-fis,
                                        INPUT p-nr-proc-exp,
                                        OUTPUT TABLE tt-bo-erro-5,
                                        INPUT-OUTPUT TABLE tt-bo-erro).
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-processo:

    DEF INPUT  PARAM p-cod-estabel   as char no-undo.
    DEF INPUT  PARAM p-serie         as char no-undo.
    DEF INPUT  PARAM p-nr-nota-fis   as char no-undo.
    DEF INPUT  PARAM p-nr-proc-exp   AS CHAR FORMAT "x(12)" NO-UNDO.
    DEF OUTPUT PARAM pl-nr-processo  AS LOG  NO-UNDO.

    FOR FIRST nota-fiscal 
        WHERE nota-fiscal.cod-estabel = p-cod-estabel
        AND   nota-fiscal.serie       = p-serie       
        AND   nota-fiscal.nr-nota-fis = p-nr-nota-fis NO-LOCK:
    END.

    IF  AVAIL nota-fiscal THEN DO: 
        FOR FIRST processo-exp
            WHERE processo-exp.cod-estabel = nota-fiscal.cod-estab-proces-export
              AND processo-exp.nr-proc-exp = p-nr-proc-exp NO-LOCK:
        END.

        FOR FIRST emitente
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK:
        END.

        /*Identifica se gera o t¡tulo com o n£mero do processo de exporta‡Æo*/
        ASSIGN pl-nr-processo        = (   (   nota-fiscal.ind-tip-nota = 1
                                                or nota-fiscal.ind-tip-nota = 4
                                                or nota-fiscal.ind-tip-nota = 3)
                                            and (   emitente.natureza          = 3
                                                 or emitente.natureza          = 4)
                                            and nota-fiscal.nr-proc-exp > "0"
                                            and para-fat.ind-docum-fatura  = 2).        
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE atualizaProcessoTitulosCR:
    
    DEF INPUT PARAM p-cod-estabel  as char no-undo.
    DEF INPUT PARAM p-serie        as char no-undo.
    DEF INPUT PARAM p-nr-nota-fis  as char no-undo.
    DEF INPUT PARAM p-nr-proc-exp  AS CHAR FORMAT "x(12)" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR  tt-bo-erro-5.
    DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    EMPTY TEMP-TABLE tt-bo-erro-5.

    DEF VAR p-emp-5            AS CHAR NO-UNDO.
    DEF VAR p-estab-5          AS CHAR NO-UNDO.
    def var l-alt-dt-venc      as log init yes no-undo.
    DEF VAR i-cont             AS INTEGER NO-UNDO.
    DEF VAR l-conecta          AS LOGICAL NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    DEF VAR l-dupl-processo AS LOG NO-UNDO.

    FIND FIRST para-fat NO-LOCK NO-ERROR.

    /*** Verifica integracao com EMS 5 ***/
    IF  CAN-FIND(FIRST funcao WHERE
                funcao.cd-funcao = "adm-acr-ems-5.00":U AND
                funcao.ativo     = YES                  AND
                funcao.log-1     = YES) THEN
        ASSIGN l-ems-5 = YES.
    ELSE
        ASSIGN l-ems-5 = NO.   

    /*Tratamento para baixa do t¡tulo e nova implantacao quando 
      gerado o titulo pelo numero do processo de exporta‡Æo*/
    IF l-gera-novo-titulo THEN DO:
        RUN pi-verifica-processo (INPUT  p-cod-estabel,
                                  INPUT  p-serie,
                                  INPUT  p-nr-nota-fis,
                                  INPUT  p-nr-proc-exp,
                                  OUTPUT l-nr-processo).

        IF l-nr-processo THEN DO:
            IF AVAIL nota-fiscal THEN DO:
                ASSIGN da-dt-emis-nota-mais-antiga = nota-fiscal.dt-emis-nota.
    
                FOR EACH proc-nota-fiscal NO-LOCK
                   WHERE proc-nota-fiscal.cod-estabel = processo-exp.cod-estabel 
                     AND proc-nota-fiscal.nr-proc-exp = processo-exp.nr-proc-exp,
        
                    EACH bf-nota-fiscal 
                    FIELDS (nat-operacao cod-estabel nr-nota-fis serie dt-emis-nota) NO-LOCK 
                    WHERE bf-nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                    AND   bf-nota-fiscal.serie       = proc-nota-fiscal.serie       
                    AND   bf-nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis:
        
                    IF  bf-nota-fiscal.dt-emis-nota < da-dt-emis-nota-mais-antiga THEN
                        ASSIGN da-dt-emis-nota-mais-antiga = bf-nota-fiscal.dt-emis-nota.
        
                END.
            END.
        END.
    END.

    /*Busca empresa **********************************/
    ASSIGN i-empresa = param-global.empresa-prin.
    IF NOT AVAIL estabelec OR  estabelec.cod-estabel <> p-cod-estabel THEN  
        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.

    RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                      OUTPUT i-empresa).
    /***********************************************/

    /*conecta bancos*/
    ASSIGN l-conecta = YES.
    RUN pi-conecta-ems-5 (INPUT  l-conecta,
                          INPUT  i-empresa,
                          OUTPUT l-erro).  /* EMS5 */

        /*tradu‡Æo da empresa e estabelecimento para o EMS 5*/
    IF NOT l-erro THEN DO:
        RUN pi-traducao-ems5(INPUT i-empresa,
                             INPUT p-cod-estabel,
                             OUTPUT p-emp-5,
                             OUTPUT p-estab-5,
                             OUTPUT TABLE tt_log_erros).
        IF CAN-FIND(tt_log_erros) THEN DO:
            FOR EACH tt_log_erros:
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = tt_log_erros.ttv_num_cod_erro
                       tt-bo-erro.mensagem     = tt_log_erros.ttv_des_erro.                         

            END.
            RETURN "NOK":U.
        END.

        ASSIGN l-erro-integra5 = NO.
        IF l-nr-processo AND l-gera-novo-titulo AND c-nr-sub-proc-exp <> "" THEN DO:
            RUN prgfin/acr/acr923za.py PERSISTENT SET v_hdl_aux.
    
            FIND FIRST fat-duplic 
                 WHERE fat-duplic.cod-estabel  = p-cod-estabel
                   AND fat-duplic.serie        = p-serie
                   AND fat-duplic.nr-fatura    = p-nr-nota-fis NO-LOCK NO-ERROR.
    
            RUN pi-busca-titulos-ems5(INPUT v_hdl_aux,
                                      INPUT IF AVAIL fat-duplic THEN fat-duplic.cod-esp ELSE "").
    
            /*elimina os registros da tabela que referem-se …s notas fiscais que NÇO foram desvinculadas do processo
            ou que estÆo vinculadas ao subprocesso*/
            FOR EACH tt_retorna_tit_acr_proc_exp:
               FIND FIRST fat-duplic
                    WHERE fat-duplic.cod-estabel = p-cod-estabel
                      AND fat-duplic.serie       = p-serie
                      AND fat-duplic.nr-fatura   = p-nr-nota-fis
                      AND fat-duplic.parcela     = tt_retorna_tit_acr_proc_exp.tta_cod_parcela NO-LOCK NO-ERROR.
               IF NOT AVAIL fat-duplic THEN
                  DELETE tt_retorna_tit_acr_proc_exp.
               ELSE DO:
                   IF  nota-fiscal.nr-proc-exp = tt_retorna_tit_acr_proc_exp.tta_cod_tit_acr 
                   AND tt_retorna_tit_acr_proc_exp.tta_val_sdo_tit_acr = 0 THEN
                       DELETE tt_retorna_tit_acr_proc_exp.
               END.
            END.
            DELETE OBJECT v_hdl_aux.

            IF CAN-FIND(FIRST tt_retorna_tit_acr_proc_exp) THEN DO:
                /*API para altera‡Æo de titulo*/
                IF NOT VALID-HANDLE(h_boacr711zv) THEN
                   RUN prgfin/acr/acr711zv.py PERSISTENT SET h_boacr711zv.
            
                RUN pi-atualiza-cria-tit-ems5 (INPUT p-cod-estabel,
                                               INPUT p-serie,
                                               INPUT p-nr-nota-fis,
                                               OUTPUT TABLE tt-bo-erro-5,
                                               OUTPUT TABLE tt-bo-erro).
           
                IF RETURN-VALUE = "NOK" THEN 
                    ASSIGN l-erro-integra5 = YES.
              
                DELETE OBJECT h_boacr711zv.
           END.
        END.
        ELSE
        IF NOT l-nr-processo THEN DO:
            RUN pi-verifica-processo (INPUT  p-cod-estabel,
                                      INPUT  p-serie,
                                      INPUT  p-nr-nota-fis,
                                      INPUT  p-nr-proc-exp,
                                      OUTPUT l-dupl-processo).

            EMPTY TEMP-TABLE tt_tit_acr_num_id.
            FOR EACH fat-duplic FIELDS(cod-estabel cod-esp serie nr-fatura parcela dt-venciment dt-emissao dt-desconto)
                 WHERE fat-duplic.cod-estabel  = p-cod-estabel
                   AND fat-duplic.serie        = p-serie
                   AND fat-duplic.nr-fatura    = p-nr-nota-fis NO-LOCK:

                /*cria tabela temporaria*/
                CREATE tt_tit_acr_num_id.
                ASSIGN tt_tit_acr_num_id.tta_cod_estab       = p-estab-5
                       tt_tit_acr_num_id.tta_cod_espec_docto = fat-duplic.cod-esp
                       tt_tit_acr_num_id.tta_cod_ser_docto   = fat-duplic.serie 
                       tt_tit_acr_num_id.tta_cod_tit_acr     = (IF  l-dupl-processo THEN p-nr-proc-exp ELSE fat-duplic.nr-fatura)
                       tt_tit_acr_num_id.tta_cod_parcela     = fat-duplic.parcela.

                /*busca id do titulo*/
                RUN prgfin/acr/acr922za.py(INPUT 1,
                                           INPUT-OUTPUT TABLE tt_tit_acr_num_id).

                /*atualiza titulo no financeiro*/
                FIND FIRST tt_tit_acr_num_id 
                    WHERE tt_tit_acr_num_id.tta_cod_estab       = p-estab-5 
                      AND tt_tit_acr_num_id.tta_cod_espec_docto = fat-duplic.cod-esp     
                      AND tt_tit_acr_num_id.tta_cod_ser_docto   = fat-duplic.serie       
                      AND tt_tit_acr_num_id.tta_cod_tit_acr     = (IF  l-dupl-processo THEN p-nr-proc-exp ELSE fat-duplic.nr-fatura)
                      AND tt_tit_acr_num_id.tta_cod_parcela     = fat-duplic.parcela NO-LOCK NO-ERROR.

                IF AVAIL tt_tit_acr_num_id AND 
                    tt_tit_acr_num_id.tta_num_id_tit_acr > 0 THEN DO:
    
                    /*Atualiza o n£mero do Processo de Exporta‡Æo no t¡tulo do CR*/
                    IF NOT VALID-HANDLE(h_boacr711zv) THEN
                        RUN prgfin/acr/acr711zv.py PERSISTENT SET h_boacr711zv.
                    RUN pi-atualiza-tit-ems5 (INPUT p-estab-5, 
                                              INPUT tt_tit_acr_num_id.tta_num_id_tit_acr,
                                              INPUT p-nr-proc-exp).  
                    
                    IF RETURN-VALUE = "NOK" THEN 
                        ASSIGN l-erro-integra5 = YES.

                    DELETE OBJECT h_boacr711zv.
                END.
                ELSE DO:
                    create tt-bo-erro.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-titulo-nao-localizado-para-atu AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "T¡tulo_nÆo_localizado_para_atualiza‡Æo" *}
                    ASSIGN c-lbl-liter-titulo-nao-localizado-para-atu = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-o-titulo-nao-foi-encontrado-pa AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "O_t¡tulo_nÆo_foi_encontrado_para_atualiza‡Æo_de_Processo_de_Exporta‡Æo,_opera‡Æo_abortada" *}
                    ASSIGN c-lbl-liter-o-titulo-nao-foi-encontrado-pa = TRIM(RETURN-VALUE).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17006
                           tt-bo-erro.mensagem     = ""
                           tt-bo-erro.parametros   = c-lbl-liter-titulo-nao-localizado-para-atu + "! " + "~~" + c-lbl-liter-o-titulo-nao-foi-encontrado-pa + "!"
                           .    
                END.
            END.
        END.
        
        /*desconecta bancos*/
        ASSIGN l-conecta = NO.
        RUN pi-conecta-ems-5 (INPUT  l-conecta,
                              INPUT  i-empresa,
                              OUTPUT l-erro).  /* EMS5 */

        IF l-erro OR l-erro-integra5 THEN 
            RETURN "NOK":U.
    END.
    ELSE 
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-conecta-ems-5:
 
    DEF INPUT PARAM  l-conecta   AS LOGICAL                     NO-UNDO.
    DEF INPUT PARAM  p-empresa   LIKE param-global.empresa-prin NO-UNDO.
    DEF OUTPUT PARAM l-erro-ems5 AS LOGICAL                     NO-UNDO.

    DEF VAR h-btb009za           AS HANDLE                      NO-UNDO.

    ASSIGN l-erro-ems5 = NO.

    /*** Este programa ‚ utilizado para Conexão de bancos do EMS 5***/
    IF  l-ems-5 THEN
        if not valid-handle(h-btb009za) then
            RUN btb/btb009za.p PERSISTENT SET h-btb009za.

    IF  l-conecta THEN DO:

        IF  SEARCH("prgfin/acr/acr900zf.r":U)  = ? AND
            SEARCH("prgfin/acr/acr900zf.py":U) = ? THEN DO:

            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 6246,
                               INPUT "prgfin/acr/acr900zf.py":U).

            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 6246
                   tt-bo-erro.mensagem     = trim(return-value)
                   .                        


            ASSIGN l-erro-ems5 = YES.

        END.
        ELSE DO:

            IF  CONNECTED("emsuni") 
                THEN ASSIGN l-ja-conec-emsuni = YES.
                ELSE ASSIGN l-ja-conec-emsuni = NO.

            IF  CONNECTED("emsbas")
                THEN ASSIGN l-ja-conec-emsbas = YES.
                ELSE ASSIGN l-ja-conec-emsbas = NO.

            IF  CONNECTED("emsfin")
                THEN ASSIGN l-ja-conec-emsfin = YES.
                ELSE ASSIGN l-ja-conec-emsfin = NO.

            IF  l-ja-conec-emsuni = NO OR
                l-ja-conec-emsbas = NO OR
                l-ja-conec-emsfin = NO THEN DO:

                IF  VALID-HANDLE(h-btb009za) THEN
                    RUN pi-conecta-bco IN h-btb009za (INPUT 1, /* Versao API  */
                                                      INPUT 1, /* 1 - conexao, 2 - Desconexao */
                                                      INPUT p-empresa, /* Codigo da empresa */
                                                      INPUT "all":U, /* nome do banco */
                                                      OUTPUT TABLE tt_erros_conexao). /* temp-TABLE de erros */
                IF  RETURN-VALUE <> "OK":U THEN DO:
                    
                    FIND FIRST tt_erros_conexao NO-LOCK NO-ERROR.
                    IF  AVAIL tt_erros_conexao THEN DO:
                        
                        create tt-bo-erro.
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = tt_erros_conexao.cd-erro
                               tt-bo-erro.mensagem     = IF  tt_erros_conexao.param-1 = '' THEN 
                                                             tt_erros_conexao.mensagem 
                                                         ELSE 
                                                             tt_erros_conexao.param-1
                               .                                                                                         


                        ASSIGN l-erro-ems5 = YES.                                              
                    END.
                END.
            END.
        END.
    END.

    IF  NOT l-conecta OR l-erro-ems5 THEN DO:

        IF  l-ja-conec-emsuni = NO OR
            l-ja-conec-emsbas = NO OR
            l-ja-conec-emsfin = NO THEN DO:
            
            RUN pi-conecta-bco IN h-btb009za (INPUT 1, /* Versao API  */
                                              INPUT 2, /* 1 - conexao, 2 - Desconexao */
                                              INPUT p-empresa, /* Codigo da empresa */
                                              INPUT "all":U, /* nome do banco */
                                              OUTPUT TABLE tt_erros_conexao). /* temp-TABLE de erros */


            IF  RETURN-VALUE <> "OK":U THEN DO:
                
                FIND FIRST tt_erros_conexao NO-LOCK NO-ERROR.
                IF AVAIL tt_erros_conexao THEN DO:
                    
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = tt_erros_conexao.cd-erro
                           tt-bo-erro.mensagem     = IF  tt_erros_conexao.param-1 = '' THEN 
                                                         tt_erros_conexao.mensagem 
                                                     ELSE 
                                                         tt_erros_conexao.param-1
                           .                        


                    ASSIGN l-erro-ems5 = YES.                                              
                END.
            END.
        END.
    END.   

    IF  VALID-HANDLE(h-btb009za) THEN
        DELETE PROCEDURE h-btb009za.

    RETURN "OK":U.
END PROCEDURE.                     

PROCEDURE pi-atualiza-tit-ems5:
    /*Atualiza o n£mero do processo de Exporta‡Æo no T¡tulo do Contas a Receber*/

    DEF INPUT PARAM p-cod-estab   LIKE nota-fiscal.cod-estabel  NO-UNDO.
    DEF INPUT PARAM p-id-tit-acr  AS INT                        NO-UNDO.
    DEF INPUT PARAM p-nr-proc-exp AS CHAR FORMAT "X(12)"        NO-UNDO.
    
    DEF VAR p-cod-refer AS CHAR FORMAT 'X(10)':U NO-UNDO.
    DEF VAR p-num-tit-acr AS INT NO-UNDO.

    RUN ftp/ftapi016.p(INPUT "F",
                       INPUT p-cod-estab,
                       OUTPUT p-cod-refer).

    RUN pi-retorna-seq-tit-acr (INPUT p-cod-estab,
                                INPUT p-id-tit-acr,
                                INPUT TODAY,
                                OUTPUT p-num-tit-acr). 

    CREATE tt_alter_tit_acr_base_5.
    ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = p-cod-estab                    
           tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = p-id-tit-acr                   
           tt_alter_tit_acr_base_5.tta_dat_transacao               = TODAY                         
           tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_imp = ?                                            
           tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr             = ?                             
           tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_alt = ""                            
           tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val        = "Altera‡Æo"                    
           tt_alter_tit_acr_base_5.tta_cod_portador                = ?                              
           tt_alter_tit_acr_base_5.tta_cod_cart_bcia               = ?                              
           tt_alter_tit_acr_base_5.tta_val_despes_bcia             = ?                              
           tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia         = ?                              
           tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?                              
           tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr          = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
           tt_alter_tit_acr_base_5.tta_dat_prev_liquidac           = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
           tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr           = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
           tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr             = ?                             
           tt_alter_tit_acr_base_5.tta_cod_cond_cobr               = ?                             
           tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr            = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF                           
           tt_alter_tit_acr_base_5.tta_val_abat_tit_acr            = ?                             
           tt_alter_tit_acr_base_5.tta_val_perc_desc               = ?                             
           tt_alter_tit_acr_base_5.tta_val_desc_tit_acr            = ?                             
           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr   = ?                             
           tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso   = ?                             
           tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso       = ?                             
           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr   = ?                             
           tt_alter_tit_acr_base_5.tta_ind_ender_cobr              = ?                             
           tt_alter_tit_acr_base_5.tta_nom_abrev_contat            = ?                             
           tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = ?                             
           tt_alter_tit_acr_base_5.tta_log_tip_cr_perda_dedut_tit  = ?                             
           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1_movto    = ?                             
           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2_movto    = ?                             
           tt_alter_tit_acr_base_5.ttv_des_text_histor             = ?                             
           tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr            = "normal"                      
           tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo         = ?                             
           tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ?    
           tt_alter_tit_acr_base_5.tta_cdn_repres                  = ? 
           tt_alter_tit_acr_base_5.tta_val_perc_abat_acr           = ? 
           tt_alter_tit_acr_base_5.ttv_dat_base_fechto_vendor      = ?
           tt_alter_tit_acr_base_5.tta_cod_proces_export           = p-nr-proc-exp
           tt_alter_tit_acr_base_5.tta_cod_refer                   = p-cod-refer
           tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = p-num-tit-acr.                            

    RUN pi_main_code_integr_acr_alter_tit_acr_novo_10 IN h_boacr711zv (7,                                                                 
                                                                       INPUT  TABLE tt_alter_tit_acr_base_5,                              
                                                                       INPUT  TABLE tt_alter_tit_acr_rateio,                              
                                                                       INPUT  TABLE tt_alter_tit_acr_ped_vda,                             
                                                                       INPUT  TABLE tt_alter_tit_acr_comis_1,                               
                                                                       INPUT  TABLE tt_alter_tit_acr_cheq,                                
                                                                       INPUT  TABLE tt_alter_tit_acr_iva,                                                      
                                                                       Input  table tt_alter_tit_acr_impto_retid_2,
                                                                       Input  table tt_alter_tit_acr_cobr_espec_2,
                                                                       Input  table tt_alter_tit_acr_rat_desp_rec,
                                                                       Output table tt_log_erros_alter_tit_acr,
                                                                       INPUT YES).
    IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
        FOR EACH tt_log_erros_alter_tit_acr:

            FIND FIRST tt-bo-erro-5
                WHERE  tt-bo-erro-5.cd-erro = tt_log_erros_alter_tit_acr.ttv_num_mensagem NO-LOCK NO-ERROR.
            IF AVAIL tt-bo-erro-5 THEN
                NEXT.

            create tt-bo-erro-5.
            assign tt-bo-erro-5.i-sequen     = i-seq-erro
                   tt-bo-erro-5.cd-erro      = tt_log_erros_alter_tit_acr.ttv_num_mensagem
                   tt-bo-erro-5.mensagem     = tt_log_erros_alter_tit_acr.ttv_des_msg_erro
                   .                        
        END.
        RETURN "NOK":U.
    END.
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-retorna-seq-tit-acr:

    DEF INPUT PARAM p-cod-estabel      LIKE nota-fiscal.cod-estabel  NO-UNDO. 
    DEF INPUT PARAM p-id-tit-acr       AS INT    NO-UNDO.
    DEF INPUT PARAM p-dat-transacao    AS DATE   NO-UNDO.
    DEF OUTPUT PARAM p-num-seq-tit-acr AS INT    NO-UNDO.

    IF c-cod-estab = p-cod-estabel AND 
       i-num-id-tit-acr = p-id-tit-acr AND 
       d-dat-transacao = p-dat-transacao THEN 
       ASSIGN i-num-seq-tit-acr = i-num-seq-tit-acr + 1.
    ELSE  
       ASSIGN c-cod-estab       = p-cod-estabel
              i-num-id-tit-acr  = p-id-tit-acr
              d-dat-transacao   = p-dat-transacao
              i-num-seq-tit-acr = 1.

    ASSIGN p-num-seq-tit-acr = i-num-seq-tit-acr.        

    RETURN "OK":U.
END PROCEDURE.

procedure pi-traducao-ems5:
def input  param p-empresa     like empresa.ep-codigo        no-undo.
def input  param p-cod-estab   like nota-fiscal.cod-estabel  no-undo.
def output param p-empresa-5   as char                       no-undo.
def output param p-cod-estab-5 as char                       no-undo.
def output param table for tt_log_erros.


    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        empty temp-table tt_xml_input_output.
        empty temp-table tt_log_erros.
    &else
        FOR EACH tt_xml_input_output:
            DELETE tt_xml_input_output.
        END.
        FOR EACH tt_log_erros:
            DELETE tt_log_erros.
        END.
    &endif

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = "Fun" + CHR(231) + CHR(227) + "o"
           tt_xml_input_output.ttv_des_conteudo = "Faturamento 2.00"
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = "Produto"
           tt_xml_input_output.ttv_des_conteudo = "EMS 5"
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = "Empresa"
           tt_xml_input_output.ttv_des_conteudo = string(p-empresa)  /* codigo Empresa no EMS-2 */
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = "Estabel"
           tt_xml_input_output.ttv_des_conteudo = p-cod-estab  /* codigo Estabelecimento no EMS-2 */
           tt_xml_input_output.ttv_num_seq_1 = 1.

    run prgint/utb/utb786za.py (input-output table tt_xml_input_output,
                                output table tt_log_erros).

    FIND FIRST tt_log_erros EXCLUSIVE-LOCK NO-ERROR.
    IF not AVAIL tt_log_erros THEN DO:
        find first tt_xml_input_output
            where tt_xml_input_output.ttv_cod_label = "Estabel" /*l_estabel*/  no-lock no-error.
        if  avail tt_xml_input_output then
            assign p-cod-estab-5 = tt_xml_input_output.ttv_des_conteudo_aux.
        find first tt_xml_input_output
            where tt_xml_input_output.ttv_cod_label = "Empresa" /*l_empresa*/  no-lock no-error.
        if  avail tt_xml_input_output then
            assign p-empresa-5 = tt_xml_input_output.ttv_des_conteudo_aux.
    end.

    return "OK":U.
end procedure.


PROCEDURE setaAtualizaProcesso:
   /*
    1 = Peso L¡quido/ Bruto
    2 = Pre‡o Original/ Unit rio
    3 = Qt UN Item/ Fam
    4 = Despesas
    5 = Peso L¡quido/Bruto, Pre‡o Original/ Unit rio, Qt UN Item/ Fam e Despesas
    6 = Considera NF diferen‡a de Pre‡o
   */
    DEFINE INPUT PARAMETER pl-atualiza-peso       AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-atualiza-preco      AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-atualiza-quantidade AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-atualiza-despesa    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-atualiza-todos      AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-preco-pedido        AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-considera-dif-preco AS LOGICAL NO-UNDO.

    ASSIGN l-atualiza-peso       = pl-atualiza-peso
           l-atualiza-preco      = pl-atualiza-preco
           l-atualiza-quantidade = pl-atualiza-quantidade
           l-atualiza-despesa    = pl-atualiza-despesa
           l-atualiza-todos      = pl-atualiza-todos
           l-atualiza-pre-ped    = pl-preco-pedido
           l-considera-dif-preco = pl-considera-dif-preco.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE setLog1Processo:
    /*
        Procedure para atualizar o campo log-1 da tabela processo-exp
        pcod-estabel - C¢digo do Estabelecimento
        pnr-proc-exp - N£mero do Processo
        pLog-1       - Status do Log. YES/NO
    */
    DEFINE INPUT PARAMETER pcod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pLog-1       LIKE processo-exp.log-1       NO-UNDO.

    DEFINE BUFFER b-processo-exp FOR processo-exp.
    
    FIND FIRST b-processo-exp EXCLUSIVE-LOCK
        WHERE b-processo-exp.cod-estabel = pcod-estabel
        AND   b-processo-exp.nr-proc-exp = pnr-proc-exp NO-ERROR.
    IF AVAIL b-processo-exp THEN
        ASSIGN b-processo-exp.log-1 = pLog-1.

    RETURN "OK":U.

END PROCEDURE.

procedure pi-seta-alteracao-itiner:
/*-----------------------------------------------------------------------------------
    Purpose: Recebe um parƒmetro l¢gico indicando se o itiner rio foi alterado ou nÆo.
    Parameters: plAltItiner: YES = Itiner rio alterado; 
                              NO = Itiner rio nÆo sofreu altera‡Æo.
    Notes:   
-----------------------------------------------------------------------------------*/
     define input param pAltItiner as logical no-undo.
     
     assign lAlteracaoItinerario = pAltItiner.

    return "OK":U.
end procedure.

PROCEDURE pi-seta-itinerario-anterior:
/*-----------------------------------------------------------------------------------
    Purpose: Recebe um parƒmetro com o valor do itiner rio anterior a altera‡Æo.
    Parameters: plAltItiner: INPUT : C¢digo do itiner rio antes da altera‡Æo.
    Notes:   
-----------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-cod-itiner-anterior LIKE itinerario.cod-itiner     NO-UNDO.

    ASSIGN i-cod-itiner-anterior = pi-cod-itiner-anterior.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-valida-pontos-itinerario:
/*------------------------------------------------------------------------------------------
Purpose:    Valida se o itiner rio informado possui todos os pontos de controle obrigat¢rios.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
     if rowObject.cod-itiner > 0 then do:

         if not valid-handle(h-bocx115) then 
             RUN cxbo/bocx115.p persistent set h-bocx115.
         run findCodigo in h-bocx115 (input rowObject.cod-itiner, output c-return).
         if c-return = "" then 
             run getcurrent in h-bocx115 (output table tt-itinerario).
         else do:
             assign i-seq-erro = i-seq-erro + 1.
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = c-return.
         end.

         find first tt-itinerario no-lock no-error.
         if avail tt-itinerario
              and tt-itinerario.pto-embarque    <> 0
              and tt-itinerario.pto-despacho    <> 0
              and tt-itinerario.pto-desembarque <> 0  
              and tt-itinerario.pto-chegada     <> 0  then do:

             assign rowObject.pto-embarque    = tt-itinerario.pto-embarque
                    rowObject.pto-despacho    = tt-itinerario.pto-despacho
                    rowObject.pto-desembarque = tt-itinerario.pto-desembarque
                    rowObject.pto-chegada     = tt-itinerario.pto-chegada.
         end.
         else do:
             assign i-seq-erro = i-seq-erro + 1.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Ponto(s)_de_controle_do_Itiner rio_nÆo_informado(s)" *}
             run utp/ut-msgs.p (input "msg":U,
                                input 17006,
                                input RETURN-VALUE + ".").
             create tt-bo-erro.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
             ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-o-itinerario-nao-possui-um-dos AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "O_Itiner rio_nÆo_possui_um_dos_pontos_de_controles_(embarque,_despacho_ou_desembarque)_cadastrados" *}
             ASSIGN c-lbl-liter-o-itinerario-nao-possui-um-dos = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-essa-informacao-pode-ser-consu AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Essa_informa‡Æo_pode_ser_consultada/cadastrada_no_programa_'Cadastro_Itiner rios'(cd2567)" *}
             ASSIGN c-lbl-liter-essa-informacao-pode-ser-consu = TRIM(RETURN-VALUE).
             assign tt-bo-erro.i-sequen   = i-seq-erro
                    tt-bo-erro.cd-erro    = 17006
                    tt-bo-erro.mensagem   = c-lbl-liter
                    tt-bo-erro.errorhelp  = c-lbl-liter-o-itinerario-nao-possui-um-dos + '.'
                                          + c-lbl-liter-essa-informacao-pode-ser-consu.
         end.
     end. /* if rowObject.cod-itiner ... */

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-elimina-historico-despesas-declaracoes:
/*------------------------------------------------------------------------------------------
Purpose:    Elimina todos os registros de hist¢ricos, despesas e declara‡äes do itiner rio anterior.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
    for each historico-proc-exp 
       where historico-proc-exp.cod-estabel = rowObject.cod-estabel 
         and historico-proc-exp.nr-proc-exp = rowObject.nr-proc-exp
         and historico-proc-exp.cod-itiner  = i-cod-itiner-anterior exclusive-lock:                  
        for each proc-desp-itiner exclusive-lock
           where proc-desp-itiner.cod-estabel   = historico-proc-exp.cod-estabel
             and proc-desp-itiner.nr-proc-exp   = historico-proc-exp.nr-proc-exp
             and proc-desp-itiner.cod-itiner    = historico-proc-exp.cod-itiner:
            delete proc-desp-itiner.
        end.    
        for each decl-hist-proc-exp exclusive-lock
           where decl-hist-proc-exp.cod-estabel = historico-proc-exp.cod-estabel
             and decl-hist-proc-exp.nr-proc-exp = historico-proc-exp.nr-proc-exp
             and decl-hist-proc-exp.cod-itiner  = historico-proc-exp.cod-itiner:
            delete decl-hist-proc-exp.
        end.
        delete historico-proc-exp.     
    end.
    ASSIGN lAlteracaoItinerario = NO.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-cria-historico-criacao-alteracao:
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a cria‡Æo do hist¢rico de cria‡Æo/altera‡Æo.
Parameters: c-metodo       : INPUT  : M‚todo(Cria‡Æo, Altera‡Æo);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    /* Verifica qual o ‚ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = PROGRAM-NAME(i-nivel).
        ASSIGN i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*" THEN NEXT.
        IF c-programa MATCHES "*.w" THEN DO:
            ASSIGN c-ultimo-programa = c-programa                                               
                   c-ultimo-programa = TRIM(SUBSTRING(c-ultimo-programa,LENGTH(c-ultimo-programa) - 7,10)).
        END.
            
    END.
    /****************************************************************/

    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "processo-exp":U, INPUT rowObject.r-rowid, INPUT c-ultimo-programa).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-valida-despesa-declaracao:
/*------------------------------------------------------------------------------------------
Purpose:    Verifica se o novo itier rio informado pelo usu rio possui todos os pontos de controle
            do itiner rio antigo. Se nÆo existir retorna retorna "NO", para que o usu rio seja avisado
            das diferen‡as.
Parameters: c-cod-estabel       : INPUT  : Estabelecimento do processo de exporta‡Æo.
            c-nr-proc-exp       : INPUT  : N£mero do processo de exporta‡Æo
            i-cod-itiner-novo   : INPUT  : C¢digo do novo itiner rio do processo de exporta‡Æo.
            l-retorno           : OUTPUT : Retorna se existem diferen‡as entre os pontos de controle 
                NO  = Existem diferen‡as    do itiner rio antigo em rela‡Æo ao novo.
                YES = Os dois itiner rios possuem os mesmos pontos de controle.
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM c-cod-estabel     LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAM c-nr-proc-exp     LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE INPUT  PARAM i-cod-itiner-novo LIKE processo-exp.cod-itiner  NO-UNDO.
    DEFINE OUTPUT PARAM l-retorno         AS LOGICAL                    NO-UNDO.

    DEFINE BUFFER bf-itinerario FOR itinerario.

    ASSIGN l-retorno = YES.
    FOR FIRST processo-exp
        WHERE processo-exp.cod-estabel = c-cod-estabel
          AND processo-exp.nr-proc-exp = c-nr-proc-exp NO-LOCK:

        /* Valida‡Æo das despesas */
        FOR EACH proc-desp-itiner NO-LOCK
           WHERE proc-desp-itiner.cod-estabel = processo-exp.cod-estabel
             AND proc-desp-itiner.nr-proc-exp = processo-exp.nr-proc-exp
             AND proc-desp-itiner.cod-itiner  = processo-exp.cod-itiner:

            IF proc-desp-itiner.cod-pto-contr = processo-exp.pto-despacho
            OR proc-desp-itiner.cod-pto-contr = processo-exp.pto-embarque
            OR proc-desp-itiner.cod-pto-contr = processo-exp.pto-desembarque THEN NEXT.

            FOR FIRST itinerario
                WHERE itinerario.cod-itiner = processo-exp.cod-itiner NO-LOCK: END.
                                                                                                                                                                                                                                                                                              
            IF NOT AVAIL itinerario THEN NEXT.

            IF processo-exp.pto-chegada <> 0 THEN DO:
                IF proc-desp-itiner.cod-pto-contr = processo-exp.pto-chegada THEN NEXT.
            END.
            ELSE
                IF proc-desp-itiner.cod-pto-contr = itinerario.pto-chegada THEN NEXT.

            FOR FIRST bf-itinerario
                WHERE bf-itinerario.cod-itiner = i-cod-itiner-novo NO-LOCK: END.

            IF NOT AVAIL bf-itinerario THEN NEXT.

            ASSIGN l-retorno = CAN-FIND(FIRST pto-itiner 
                                        WHERE pto-itiner.cod-itiner    = bf-itinerario.cod-itiner
                                          AND pto-itiner.cod-pto-contr = proc-desp-itiner.cod-pto-contr).
            IF NOT l-retorno THEN LEAVE.
            
            /* Localiza o ponto de embarque do acompanhamento do processo (EX0200) */
            FOR FIRST historico-proc-exp
                WHERE historico-proc-exp.cod-estabel   = processo-exp.cod-estabel
                  AND historico-proc-exp.nr-proc-exp   = processo-exp.nr-proc-exp
                  AND historico-proc-exp.cod-itiner    = processo-exp.cod-itiner 
                  AND historico-proc-exp.cod-pto-contr = processo-exp.pto-embarque NO-LOCK: END.
            IF NOT AVAIL historico-proc-exp THEN NEXT.
            
            /* Procura o ponto de controle da despesa atual na estrutura do novo itiner rio */
            FOR FIRST pto-itiner NO-LOCK
                WHERE pto-itiner.cod-itiner    = bf-itinerario.cod-itiner
                  AND pto-itiner.cod-pto-contr = proc-desp-itiner.cod-pto-contr: END.
            IF NOT AVAIL pto-itiner THEN NEXT.

            /*Se a nova sequencia do ponto de controle for maior que a sequencia do ponto de embarque do acompanhamento, nÆo permite continuar 
              - Situa‡äes onde podem existir as despesas no ponto de embarque que podem influenciar na contabiliza‡Æo*/
            IF pto-itiner.sequencia > historico-proc-exp.sequencia THEN DO:
                ASSIGN l-retorno = NO.
                LEAVE.
            END.
        END.

        /* VALIDA€ÇO DECLARA€ÇO/COMUNICA€ÇO  */ 
        IF l-retorno THEN DO:
            FOR FIRST decl-hist-proc-exp
                WHERE decl-hist-proc-exp.cod-estabel = processo-exp.cod-estabel
                  AND decl-hist-proc-exp.nr-proc-exp = processo-exp.nr-proc-exp
                  AND decl-hist-proc-exp.cod-itiner  = processo-exp.cod-itiner NO-LOCK:
    
                FOR EACH historico-proc-exp NO-LOCK
                   WHERE historico-proc-exp.cod-estabel = decl-hist-proc-exp.cod-estabel
                     AND historico-proc-exp.nr-proc-exp = decl-hist-proc-exp.nr-proc-exp
                     AND historico-proc-exp.cod-itiner  = decl-hist-proc-exp.cod-itiner 
                     AND historico-proc-exp.sequencia   = decl-hist-proc-exp.sequencia:
    
                    IF historico-proc-exp.cod-pto-contr = processo-exp.pto-despacho
                    OR historico-proc-exp.cod-pto-contr = processo-exp.pto-embarque
                    OR historico-proc-exp.cod-pto-contr = processo-exp.pto-desembarque THEN NEXT.
    
                    FOR FIRST itinerario
                        WHERE itinerario.cod-itiner = processo-exp.cod-itiner NO-LOCK: END.

                    IF NOT AVAIL itinerario THEN NEXT.
    
                    IF processo-exp.pto-chegada <> 0 THEN DO:
                        IF historico-proc-exp.cod-pto-contr = processo-exp.pto-chegada THEN NEXT.
                    END.
                    ELSE
                        IF historico-proc-exp.cod-pto-contr = itinerario.pto-chegada THEN NEXT.
    
                    FOR FIRST bf-itinerario
                        WHERE bf-itinerario.cod-itiner = i-cod-itiner-novo NO-LOCK: END.

                    IF NOT AVAIL bf-itinerario THEN NEXT.
    
                    ASSIGN l-retorno = CAN-FIND(FIRST pto-itiner
                                                WHERE pto-itiner.cod-itiner    = bf-itinerario.cod-itiner
                                                  AND pto-itiner.cod-pto-contr = historico-proc-exp.cod-pto-contr).
                    IF NOT l-retorno THEN LEAVE.
                END. /* each historico-proc-exp */
            END. /* first decl-hist-proc-exp */
        END. /* if l-retorno */
    END. /* first processo-exp */

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-ttdesp-ttdecla-novo-itiner:
/*------------------------------------------------------------------------------------------
Purpose:    Verifica as despesas e declara‡äes do itiner rio antigo e cria temp-tables destas  
            despesas e declara‡äes para o novo itiner rio.
Parameters: pc-cod-estabel - Código do Estabelecimento
			pc-nr-proc-exp - Número do processo
			pi-cod-itiner  - Código etinerário
			pr-rowid-sub   - Rowid do subprocesso
			pl-gera-despesa    - Indica se gera despesa
			pl-gera-declaracao - Indica se gera declaração de exportação
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAM pc-cod-estabel     LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT   PARAM pc-nr-proc-exp     LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE INPUT   PARAM pi-cod-itiner      LIKE processo-exp.cod-itiner  NO-UNDO.
    DEFINE INPUT   PARAM pr-rowid-sub       AS ROWID    NO-UNDO.
    DEFINE INPUT   PARAM pl-gera-despesa    AS LOGICAL  NO-UNDO.
    DEFINE INPUT   PARAM pl-gera-declaracao AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT  PARAM TABLE FOR tt-despesas-itinerario.
    DEFINE OUTPUT  PARAM TABLE FOR tt-declaracoes-itinerario.    
 
    DEFINE BUFFER bf-novo-itinerario FOR itinerario.
    DEFINE BUFFER bf-processo-exp-sub FOR processo-exp.

    IF pr-rowid-sub <> ? THEN
        FIND FIRST bf-processo-exp-sub 
             WHERE ROWID(bf-processo-exp-sub) = pr-rowid-sub NO-LOCK NO-ERROR.

    /* Itiner rio antigo */
    FOR FIRST itinerario
        WHERE itinerario.cod-itiner = i-cod-itiner-anterior NO-LOCK: END.

    /* Novo itiner rio */
    FOR FIRST bf-novo-itinerario
        WHERE bf-novo-itinerario.cod-itiner = pi-cod-itiner: END.

    IF AVAIL itinerario AND AVAIL bf-novo-itinerario THEN DO:
    
        FOR FIRST processo-exp FIELDS(pto-despacho pto-embarque pto-desembarque pto-chegada) NO-LOCK
            WHERE processo-exp.cod-estabel = pc-cod-estabel
              AND processo-exp.nr-proc-exp = pc-nr-proc-exp:
        END.
        IF pl-gera-despesa THEN DO:
            EMPTY TEMP-TABLE tt-despesas-itinerario.
            /* Despesas */
            FOR EACH proc-desp-itiner NO-LOCK
               WHERE proc-desp-itiner.cod-estabel = pc-cod-estabel
                 AND proc-desp-itiner.nr-proc-exp = pc-nr-proc-exp
                 AND proc-desp-itiner.cod-itiner  = i-cod-itiner-anterior:

                /* Pontos de controle obrigat¢rios */
                IF proc-desp-itiner.cod-pto-contr = processo-exp.pto-despacho 
                OR proc-desp-itiner.cod-pto-contr = processo-exp.pto-embarque
                OR proc-desp-itiner.cod-pto-contr = processo-exp.pto-desembarque
                OR ((processo-exp.pto-chegada >  0 AND proc-desp-itiner.cod-pto-contr = processo-exp.pto-chegada) OR
                    (processo-exp.pto-chegada <= 0 AND proc-desp-itiner.cod-pto-contr = itinerario.pto-chegada)) THEN DO:

                    /* Verifica se existem todos os pontos de controle obrigat¢rios no itiner rio informado */
                    IF bf-novo-itinerario.pto-despacho    <> 0 AND
                       bf-novo-itinerario.pto-embarque    <> 0 AND
                       bf-novo-itinerario.pto-desembarque <> 0 and
                       bf-novo-itinerario.pto-chegada     <> 0 THEN DO:                        
                        CREATE tt-despesas-itinerario.
                        BUFFER-COPY proc-desp-itiner TO tt-despesas-itinerario.
                        ASSIGN tt-despesas-itinerario.cod-itiner = pi-cod-itiner.   /* novo itiner rio */
                        IF AVAIL bf-processo-exp-sub THEN
                            ASSIGN tt-despesas-itinerario.nr-proc-exp = bf-processo-exp-sub.nr-proc-exp.

                        /* Seta os c¢digos dos pontos de controle de acordo com o novo itiner rio */
                        CASE proc-desp-itiner.cod-pto-contr:
                            WHEN processo-exp.pto-despacho THEN
                                ASSIGN tt-despesas-itinerario.cod-pto-contr = bf-novo-itinerario.pto-despacho.
                            WHEN processo-exp.pto-embarque THEN
                                ASSIGN tt-despesas-itinerario.cod-pto-contr = bf-novo-itinerario.pto-embarque.
                            WHEN processo-exp.pto-desembarque THEN
                                ASSIGN tt-despesas-itinerario.cod-pto-contr = bf-novo-itinerario.pto-desembarque.
                        END CASE.

                        IF (processo-exp.pto-chegada >  0 AND processo-exp.pto-chegada = proc-desp-itiner.cod-pto-contr) OR
                           (processo-exp.pto-chegada <= 0 AND itinerario.pto-chegada = proc-desp-itiner.cod-pto-contr) THEN
                            ASSIGN tt-despesas-itinerario.cod-pto-contr = bf-novo-itinerario.pto-chegada.
                        
                        IF tt-despesas-itinerario.descricao = "":U THEN DO:
                            FOR FIRST desp-imp FIELDS(descricao) NO-LOCK
                                WHERE desp-imp.cod-desp = proc-desp-itiner.cod-desp:
                                ASSIGN tt-despesas-itinerario.descricao = desp-imp.descricao.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    IF CAN-FIND(FIRST pto-itiner
                                WHERE pto-itiner.cod-itiner    = pi-cod-itiner /* novo itiner rio */
                                  AND pto-itiner.cod-pto-contr = proc-desp-itiner.cod-pto-contr) THEN DO:
                        CREATE tt-despesas-itinerario.
                        BUFFER-COPY proc-desp-itiner TO tt-despesas-itinerario.
                        ASSIGN tt-despesas-itinerario.cod-itiner = pi-cod-itiner.
                        IF AVAIL bf-processo-exp-sub THEN
                            ASSIGN tt-despesas-itinerario.nr-proc-exp = bf-processo-exp-sub.nr-proc-exp.

                        IF tt-despesas-itinerario.descricao = "":U THEN DO:
                            FOR FIRST desp-imp FIELDS(descricao) NO-LOCK
                                WHERE desp-imp.cod-desp = proc-desp-itiner.cod-desp:
                                ASSIGN tt-despesas-itinerario.descricao = desp-imp.descricao.
                            END.
                        END.
                    END.

                END.
            END.
        END.

        IF pl-gera-declaracao THEN DO:
            EMPTY TEMP-TABLE tt-declaracoes-itinerario.
            /* Declara‡äes */
            FOR EACH decl-hist-proc-exp NO-LOCK
               WHERE decl-hist-proc-exp.cod-estabel = pc-cod-estabel
                 AND decl-hist-proc-exp.nr-proc-exp = pc-nr-proc-exp
                 AND decl-hist-proc-exp.cod-itiner  = i-cod-itiner-anterior:

                /* Posiciona historico-proc-exp para pegar o cod-pto-contr */
                FOR FIRST historico-proc-exp NO-LOCK
                    WHERE historico-proc-exp.cod-estabel = decl-hist-proc-exp.cod-estabel
                      AND historico-proc-exp.nr-proc-exp = decl-hist-proc-exp.nr-proc-exp
                      AND historico-proc-exp.cod-itiner  = decl-hist-proc-exp.cod-itiner 
                      AND historico-proc-exp.sequencia   = decl-hist-proc-exp.sequencia:
                END.
        
                IF AVAIL historico-proc-exp THEN DO:
                    /* Pontos de controle obrigat¢rios */
                    IF historico-proc-exp.cod-pto-contr = processo-exp.pto-despacho 
                    OR historico-proc-exp.cod-pto-contr = processo-exp.pto-embarque
                    OR historico-proc-exp.cod-pto-contr = processo-exp.pto-desembarque
                    OR ((processo-exp.pto-chegada >  0 AND historico-proc-exp.cod-pto-contr = processo-exp.pto-chegada) OR 
                        (processo-exp.pto-chegada <= 0 AND historico-proc-exp.cod-pto-contr = itinerario.pto-chegada)) THEN DO:
                        /* Verifica se existem todos os pontos de controle obrigat¢rios no itiner rio informado */
                        IF bf-novo-itinerario.pto-despacho    <> 0 AND
                           bf-novo-itinerario.pto-embarque    <> 0 AND
                           bf-novo-itinerario.pto-desembarque <> 0 AND
                           bf-novo-itinerario.pto-chegada     <> 0 THEN DO:                            
                            CREATE tt-declaracoes-itinerario.
                            BUFFER-COPY decl-hist-proc-exp TO tt-declaracoes-itinerario.
                            ASSIGN tt-declaracoes-itinerario.cod-itiner = pi-cod-itiner.   /* novo itiner rio */
                            IF AVAIL bf-processo-exp-sub THEN
                                ASSIGN tt-declaracoes-itinerario.nr-proc-exp = bf-processo-exp-sub.nr-proc-exp.

                            /* Seta os c¢digos dos pontos de controle de acordo com o novo itiner rio */
                            CASE historico-proc-exp.cod-pto-contr:
                                WHEN processo-exp.pto-despacho THEN
                                    FOR FIRST pto-itiner NO-LOCK
                                        WHERE pto-itiner.cod-itiner    = bf-novo-itinerario.cod-itiner
                                          AND pto-itiner.cod-pto-contr = bf-novo-itinerario.pto-despacho:
                                        ASSIGN tt-declaracoes-itinerario.sequencia = pto-itiner.sequencia.
                                    END.
                                WHEN processo-exp.pto-embarque THEN
                                    FOR FIRST pto-itiner NO-LOCK
                                        WHERE pto-itiner.cod-itiner    = bf-novo-itinerario.cod-itiner
                                          AND pto-itiner.cod-pto-contr = bf-novo-itinerario.pto-embarque:
                                        ASSIGN tt-declaracoes-itinerario.sequencia = pto-itiner.sequencia.
                                    END.
                                WHEN processo-exp.pto-desembarque THEN
                                    FOR FIRST pto-itiner NO-LOCK
                                        WHERE pto-itiner.cod-itiner    = bf-novo-itinerario.cod-itiner
                                          AND pto-itiner.cod-pto-contr = bf-novo-itinerario.pto-desembarque:
                                        ASSIGN tt-declaracoes-itinerario.sequencia = pto-itiner.sequencia.
                                    END.
                            END CASE.

                            IF (processo-exp.pto-chegada >  0 AND processo-exp.pto-chegada = historico-proc-exp.cod-pto-contr) OR
                               (processo-exp.pto-chegada <= 0 AND itinerario.pto-chegada = historico-proc-exp.cod-pto-contr) THEN DO:
                                FOR FIRST pto-itiner NO-LOCK
                                    WHERE pto-itiner.cod-itiner    = bf-novo-itinerario.cod-itiner
                                      AND pto-itiner.cod-pto-contr = bf-novo-itinerario.pto-chegada:
                                    ASSIGN tt-declaracoes-itinerario.sequencia = pto-itiner.sequencia.
                                END.
                            END.

                            IF tt-declaracoes-itinerario.descricao = "":U THEN DO:
                                FOR FIRST decl-padrao FIELDS(descricao) NO-LOCK
                                    WHERE decl-padrao.de-codigo = decl-hist-proc-exp.de-codigo:
                                    ASSIGN tt-declaracoes-itinerario.descricao = decl-padrao.descricao.
                                END.
                            END.                                            
                        END.
                    END.
                    ELSE DO:
                        IF CAN-FIND(FIRST pto-itiner
                                    WHERE pto-itiner.cod-itiner    = pi-cod-itiner /* novo itiner rio */
                                      AND pto-itiner.cod-pto-contr = historico-proc-exp.cod-pto-contr) THEN DO:
     
                            CREATE tt-declaracoes-itinerario.
                            BUFFER-COPY decl-hist-proc-exp TO tt-declaracoes-itinerario.
                            ASSIGN tt-declaracoes-itinerario.cod-itiner = pi-cod-itiner  /* novo itiner rio */
                                   tt-declaracoes-itinerario.sequencia  = historico-proc-exp.sequencia.  
                            IF AVAIL bf-processo-exp-sub THEN
                                ASSIGN tt-declaracoes-itinerario.nr-proc-exp = bf-processo-exp-sub.nr-proc-exp.

                            IF tt-declaracoes-itinerario.descricao = "":U THEN DO:
                                FOR FIRST decl-padrao FIELDS(descricao) NO-LOCK
                                    WHERE decl-padrao.de-codigo = decl-hist-proc-exp.de-codigo:
                                    ASSIGN tt-declaracoes-itinerario.descricao = decl-padrao.descricao.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-create-despesas-novo-itiner:
/*------------------------------------------------------------------------------------------
Purpose:    A partir da temp-table de despesas cria registros para o novo itiner rio.
Parameters: tt-despesas-itinerario - Processo de Exportação
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM TABLE FOR tt-despesas-itinerario.
    
    DEFINE VARIABLE h-bocx205   AS HANDLE      NO-UNDO. /* despesas */ 

    IF NOT VALID-HANDLE(h-bocx205) THEN
        RUN cxbo/bocx205.p PERSISTENT SET h-bocx205.

    FOR EACH tt-despesas-itinerario:
        IF CAN-FIND(FIRST proc-desp-itiner
                    WHERE proc-desp-itiner.cod-estabel = tt-despesas-itinerario.cod-estabel
                      AND proc-desp-itiner.nr-proc-exp = tt-despesas-itinerario.nr-proc-exp
                      AND proc-desp-itiner.cod-itiner  = tt-despesas-itinerario.cod-itiner
                      AND proc-desp-itiner.cod-desp    = tt-despesas-itinerario.cod-desp) THEN DO:

             FIND FIRST proc-desp-itiner                                                                               
                  WHERE proc-desp-itiner.cod-estabel   = tt-despesas-itinerario.cod-estabel                            
                    AND proc-desp-itiner.nr-proc-exp   = tt-despesas-itinerario.nr-proc-exp                            
                    AND proc-desp-itiner.cod-itiner    = tt-despesas-itinerario.cod-itiner                             
                    AND proc-desp-itiner.cod-desp      = tt-despesas-itinerario.cod-desp   EXCLUSIVE-LOCK NO-ERROR.           
             IF AVAIL proc-desp-itiner THEN                                                                                             
                DELETE proc-desp-itiner.                                                                               
             RELEASE proc-desp-itiner.                                                                                 
        END.
        EMPTY TEMP-TABLE tt-despesas-itiner-aux. 
        CREATE tt-despesas-itiner-aux.
        BUFFER-COPY tt-despesas-itinerario TO tt-despesas-itiner-aux.
        RUN openQuery       IN h-bocx205 (INPUT 1).                          
        RUN setModoExecucao IN h-bocx205(input YES).                         
        RUN validateCreate  IN h-bocx205(input table tt-despesas-itiner-aux, 
                                         output table tt-bo-erro,            
                                         output r-chave).                    
    END.
      
    IF VALID-HANDLE(h-bocx205) THEN DO:
        DELETE PROCEDURE h-bocx205.
        ASSIGN h-bocx205 = ?.
    END.   
   
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-create-declaracoes-novo-itiner:
/*------------------------------------------------------------------------------------------
Purpose:    A partir da temp-table de declara‡äes cria registros para o novo itiner rio.
Parameters: tt-declaracoes-itinerario  - Declara‡äes
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM TABLE FOR tt-declaracoes-itinerario.
    
    DEFINE VARIABLE h-bocx285   AS HANDLE      NO-UNDO. /* declaracoes */

    IF NOT VALID-HANDLE(h-bocx285) THEN
        RUN cxbo/bocx285.p PERSISTENT SET h-bocx285.

    FOR EACH tt-declaracoes-itinerario:
         IF CAN-FIND(FIRST decl-hist-proc-exp                                                             
                     WHERE decl-hist-proc-exp.cod-estabel   = tt-declaracoes-itinerario.cod-estabel          
                       AND decl-hist-proc-exp.nr-proc-exp   = tt-declaracoes-itinerario.nr-proc-exp          
                       AND decl-hist-proc-exp.cod-itiner    = tt-declaracoes-itinerario.cod-itiner           
                       AND decl-hist-proc-exp.de-codigo     = tt-declaracoes-itinerario.de-codigo) THEN DO:  
            FIND FIRST decl-hist-proc-exp                                                             
                 WHERE decl-hist-proc-exp.cod-estabel   = tt-declaracoes-itinerario.cod-estabel          
                   AND decl-hist-proc-exp.nr-proc-exp   = tt-declaracoes-itinerario.nr-proc-exp          
                   AND decl-hist-proc-exp.cod-itiner    = tt-declaracoes-itinerario.cod-itiner           
                   AND decl-hist-proc-exp.de-codigo     = tt-declaracoes-itinerario.de-codigo EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL decl-hist-proc-exp THEN
                DELETE decl-hist-proc-exp.
            RELEASE decl-hist-proc-exp. 
         END.
         EMPTY TEMP-TABLE tt-declaracoes-itiner-aux. 
         CREATE tt-declaracoes-itiner-aux.
         BUFFER-COPY tt-declaracoes-itinerario TO tt-declaracoes-itiner-aux.
         RUN openQuery       IN h-bocx285 (INPUT 1). 
         RUN validateCreate  IN h-bocx285(input table tt-declaracoes-itiner-aux, 
                                          output table tt-bo-erro, 
                                          output r-chave).
    END.

    IF VALID-HANDLE(h-bocx285) THEN DO:
        DELETE PROCEDURE h-bocx285.
        ASSIGN h-bocx285 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-seta-dados-cr:
/*------------------------------------------------------------------------------------------
Purpose:    Procedure respons vel por receber os dados de portador e da forma de geracao do titulo
            Essas informacoes sao recebidas atraves da tela ex3001c2 para ex3001c
Parameters: pi-cod-portador - Código do portador
			pi-geracao - Tipo da Geração
			pi-cod-itiner  - Código etinerário
			pc-nr-sub-proc-exp   - Número do Subprocesso
Notes: 
------------------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-cod-portador   AS   INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pi-geracao        AS   INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-sub-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.

    ASSIGN i-cod-portador    = pi-cod-portador 
           i-gera-titulo     = pi-geracao
           c-nr-sub-proc-exp = pc-nr-sub-proc-exp.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-seta-atualiza-tit-ems5:
/*------------------------------------------------------------------------------------------
Purpose:    Essa procedure ser  respons vel por identificar se dever  ou nÆo ser zerado o titulo original 
            para ser gerado novo titulo com o novo processo de exporta‡Æo com o saldo restante.
            Situa‡äes em que o t¡tulo ‚ gerado pelo n£mero do Processo de Exporta‡Æo
Parameters: pl-gera-novo-titulo - Indica se gera novo título
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-gera-novo-titulo AS LOGICAL NO-UNDO.

    ASSIGN l-gera-novo-titulo = pl-gera-novo-titulo.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-busca-titulos-ems5:
/*------------------------------------------------------------------------------------------
Purpose:    Essa procedure ser  respons vel por buscar todos os t¡tulos do processo de exporta‡Æo que possuem saldo
Parameters: p-v_hdl_aux - Handle do programa do contas a receber
			p-c-cod-esp - Codigo da especie
Notes: 
------------------------------------------------------------------------------------------*/
    /*
    ** Essa procedure ser  respons vel por buscar todos os t¡tulos do processo de exporta‡Æo que possuem saldo
    */

    DEF INPUT PARAM p-v_hdl_aux     AS   HANDLE                 NO-UNDO.
    DEF INPUT PARAM p-c-cod-esp     LIKE fat-duplic.cod-esp     NO-UNDO.

    /*** Limpa temp-tables ***/
    FOR EACH tt_leitura_tit_acr_proc_exp:
        DELETE tt_leitura_tit_acr_proc_exp.
    END.

    FOR EACH tt_retorna_tit_acr_proc_exp:
        DELETE tt_retorna_tit_acr_proc_exp.
    END.

    FOR EACH tt_log_erros:
        DELETE tt_log_erros.
    END.

    /* Criar os parƒmetros para API */
    {utp/ut-liter.i Empresa *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = "".

    {utp/ut-liter.i Empresa_Externa *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = STRING(i-empresa).

    {utp/ut-liter.i Estabelecimento *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = "".

    {utp/ut-liter.i Estabelecimento_Externo *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = fat-duplic.cod-estabel.

    {utp/ut-liter.i Numero_Processo *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = processo-exp.nr-proc-exp.

    {utp/ut-liter.i Cliente *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = STRING(processo-exp.cod-emitente).

    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = STRING(da-dt-emis-nota-mais-antiga).
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = "Data Emissao Inicial".

    {utp/ut-liter.i Especie *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = p-c-cod-esp.

    {utp/ut-liter.i Serie *}
    CREATE tt_leitura_tit_acr_proc_exp.
    ASSIGN tt_leitura_tit_acr_proc_exp.ttv_num_seq_1    = 1
           tt_leitura_tit_acr_proc_exp.ttv_cod_label    = RETURN-VALUE
           tt_leitura_tit_acr_proc_exp.ttv_des_conteudo = fat-duplic.serie.


    /*** Busca a Matriz de Tradu‡Æo ***/
    IF  param-global.modulo-mec THEN
        ASSIGN v_cod_matriz_trad_org_ext = "".
    ELSE DO:

        RUN prgint/ufn/ufn908za.py (INPUT "1":U,
                                    INPUT "15":U,
                                    OUTPUT v_cod_matriz_trad_org_ext).
    END.
    
    IF  NOT AVAIL para-fat THEN
        FIND FIRST para-fat NO-LOCK NO-ERROR.
    
    IF  VALID-HANDLE(p-v_hdl_aux) THEN 
        RUN pi_tit_acr_proc_exp_2 IN p-v_hdl_aux (INPUT  2,
                                                  INPUT  TABLE tt_leitura_tit_acr_proc_exp,
                                                  OUTPUT TABLE tt_retorna_tit_acr_proc_exp,
                                                  OUTPUT TABLE tt_log_erros,
                                                  INPUT v_cod_matriz_trad_org_ext,
                                                  INPUT para-fat.ind-docum-fatura,
                                                  OUTPUT TABLE tt_repres_tit_acr_export,
                                                  OUTPUT TABLE tt_movto_comis_repres_export,
                                                  INPUT NO). /*identica se retorna somente os titulos que possuem saldo em aberto. Neste caso deve retornar independente de ter ou nÆo*/

    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-atualiza-cria-tit-ems5:
/*------------------------------------------------------------------------------------------
Purpose:    respons vel por: - realizar as valida‡äes das situa‡äes dos t¡tulos no CR
                             - efetuar a liquidacao do titulo em aberto
                             - criar novo titulo com o novo numero do processo 
Parameters: p-cod-estab-2 - Código do estabelecimento
			p-nr-proc-exp-orig - Número do processo de origem
            p-nr-proc-exp-sub  - Número do subprocesso
			tt-bo-erro-5 - Temp-table de erro do EMS5
			tt-bo-erro   - Temp-table de erro
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-serie       LIKE nota-fiscal.serie       NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro-5.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEF VAR p-cod-refer   AS CHARACTER FORMAT 'X(10)':U NO-UNDO.
    DEF VAR p-num-tit-acr AS INTEGER                    NO-UNDO.

    DEF BUFFER bf-processo-exp     FOR processo-exp.
    DEF BUFFER bf-processo-exp-sub FOR processo-exp.

    bloco_atz_cria:
    DO TRANS:
        FIND FIRST nota-fiscal
             WHERE nota-fiscal.cod-estabel = pc-cod-estabel
               AND nota-fiscal.serie       = pc-serie
               AND nota-fiscal.nr-nota-fis = pc-nr-nota-fis NO-LOCK NO-ERROR.
    
    
        IF CAN-FIND(FIRST tt_retorna_tit_acr_proc_exp
                    WHERE tt_retorna_tit_acr_proc_exp.tta_val_sdo_tit_acr <> tt_retorna_tit_acr_proc_exp.tta_val_origin_tit_acr) THEN DO:
            /*Contas a Receber nÆo atualizado, j  foram realizadas liquidacoes parciais */
            {utp/ut-liter.i Contas_a_Receber * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 54581, 
                               input trim(return-value)).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 54581
                   tt-bo-erro.mensagem = return-value.
            
            {utp/ut-liter.i T¡tulo_j _possui_movimenta‡äes_de_valores._T¡tulo_dever _ser_atualizado_manualmente * R}.
            ASSIGN c-param2 = TRIM(RETURN-VALUE).
            
            run utp/ut-msgs.p (input "help",
                               input 54581, 
                               input c-param1 + "~~~~" + c-param2).
            
            ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
        END.
        
        IF CAN-FIND(FIRST tt_retorna_tit_acr_proc_exp
                    WHERE tt_retorna_tit_acr_proc_exp.ttv_log_vincul_contrat_export) THEN DO: /*vinculado a contrato de cambio*/
            /*Contas a Receber nÆo atualizado, titulo encontrase vinculado a contrato de cambio*/
            {utp/ut-liter.i Contas_a_Receber * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 54581, 
                               input trim(return-value)).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 54581
                   tt-bo-erro.mensagem = return-value.
            
            {utp/ut-liter.i T¡tulo_vinculado_a_contrato_de_cƒmbio._T¡tulo_dever _ser_atualizado_manualmente * R}.
            ASSIGN c-param2 = TRIM(RETURN-VALUE).
            
            run utp/ut-msgs.p (input "help",
                               input 54581, 
                               input c-param1 + "~~~~" + c-param2).
            
            ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
        END.
    
        IF CAN-FIND(FIRST tt_retorna_tit_acr_proc_exp
                    WHERE tt_retorna_tit_acr_proc_exp.tta_log_tit_acr_estordo)       THEN DO: /*titulo estornado*/
            /*Contas a Receber nÆo atualizado, titulo encontra-se estornado*/
            {utp/ut-liter.i Contas_a_Receber * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 54581, 
                               input trim(return-value)).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 54581
                   tt-bo-erro.mensagem = return-value.
            
            {utp/ut-liter.i T¡tulo_est _estornado._T¡tulo_dever _ser_atualizado_manualmente * R}.
            ASSIGN c-param2 = TRIM(RETURN-VALUE).
            
            run utp/ut-msgs.p (input "help",
                               input 54581, 
                               input c-param1 + "~~~~" + c-param2).
            
            ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
        END.
    
        IF CAN-FIND(FIRST tt_retorna_tit_acr_proc_exp
                    WHERE tt_retorna_tit_acr_proc_exp.tta_val_sdo_tit_acr = 0 OR NOT tt_retorna_tit_acr_proc_exp.tta_log_sdo_tit_acr) THEN DO:
            /*Contas a Receber nÆo atualizado, Saldo zerado*/
            {utp/ut-liter.i Contas_a_Receber * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 54581, 
                               input trim(return-value)).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 54581
                   tt-bo-erro.mensagem = return-value.
            
            {utp/ut-liter.i T¡tulo_nÆo_possui_saldo. * R}.
            ASSIGN c-param2 = TRIM(RETURN-VALUE).
            
            run utp/ut-msgs.p (input "help",
                               input 54581, 
                               input c-param1 + "~~~~" + c-param2).
            
            ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
        END.
    
    
        IF CAN-FIND(FIRST tt_movto_comis_repres_export
                    WHERE tt_movto_comis_repres_export.tta_log_movto_comis_envdo) THEN DO:
            /*Contas a Receber nÆo atualizado, comissao representante enviado ao AP*/
            {utp/ut-liter.i Contas_a_Receber * R}
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 54581, 
                               input trim(return-value)).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 54581
                   tt-bo-erro.mensagem = return-value.
            
            {utp/ut-liter.i ComissÆo_Representante_enviado_ao_AP._T¡tulo_dever _ser_atualizado_manualmente * R}.
            ASSIGN c-param2 = TRIM(RETURN-VALUE).
            
            run utp/ut-msgs.p (input "help",
                               input 54581, 
                               input c-param1 + "~~~~" + c-param2).
            
            ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
        END.
    
        /*Caso nao tenha sido encontrado nenhum erro, os titulos deverao ser 
          liquidados e gerados novos com o novo numero do processo de exportacao*/
        IF NOT CAN-FIND(FIRST tt-bo-erro where tt-bo-erro.cd-erro = 54581) THEN DO:
    
            bloco:
            DO TRANS:
                /*zera o saldo dos t¡tulos do Processo de Origem e do SubProcesso */
                FOR EACH tt_retorna_tit_acr_proc_exp:
    
                    PAUSE 1 NO-MESSAGE.
    
                    RUN pi-retorna-seq-tit-acr (INPUT tt_retorna_tit_acr_proc_exp.tta_cod_estab,
                                            	INPUT tt_retorna_tit_acr_proc_exp.tta_num_id_tit_acr,
                                           	    INPUT TODAY,
                                            	OUTPUT p-num-tit-acr). 
        
                    /*Liquidar os t¡tulos do processo Original*/
                    CREATE tt_alter_tit_acr_base_5.
                    ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = tt_retorna_tit_acr_proc_exp.tta_cod_estab
                           tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = tt_retorna_tit_acr_proc_exp.tta_num_id_tit_acr /*ID do titulo sendo zerado*/
                           tt_alter_tit_acr_base_5.tta_dat_transacao               = TODAY                         
                           tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_imp = ?                                            
                           tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr             = 0                             
                           tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_alt = ""                            
                           tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val        = "Altera‡Æo"                    
                           tt_alter_tit_acr_base_5.tta_cod_portador                = ?                              
                           tt_alter_tit_acr_base_5.tta_cod_cart_bcia               = ?                              
                           tt_alter_tit_acr_base_5.tta_val_despes_bcia             = ?                              
                           tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia         = ?                              
                           tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?                              
                           tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr          = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
                           tt_alter_tit_acr_base_5.tta_dat_prev_liquidac           = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
                           tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr           = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
                           tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr             = ?                             
                           tt_alter_tit_acr_base_5.tta_cod_cond_cobr               = ?                             
                           tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr            = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF                           
                           tt_alter_tit_acr_base_5.tta_val_abat_tit_acr            = ?                             
                           tt_alter_tit_acr_base_5.tta_val_perc_desc               = ?                             
                           tt_alter_tit_acr_base_5.tta_val_desc_tit_acr            = ?                             
                           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr   = ?                             
                           tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso   = ?                             
                           tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso       = ?                             
                           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr   = ?                             
                           tt_alter_tit_acr_base_5.tta_ind_ender_cobr              = ?                             
                           tt_alter_tit_acr_base_5.tta_nom_abrev_contat            = ?                             
                           tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = ?                             
                           tt_alter_tit_acr_base_5.tta_log_tip_cr_perda_dedut_tit  = ?                             
                           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1_movto    = ?                             
                           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2_movto    = ?                             
                           tt_alter_tit_acr_base_5.ttv_des_text_histor             = ?                             
                           tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr            = "normal"                      
                           tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo         = ?                             
                           tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ?    
                           tt_alter_tit_acr_base_5.tta_cdn_repres                  = ? 
                           tt_alter_tit_acr_base_5.tta_val_perc_abat_acr           = ? 
                           tt_alter_tit_acr_base_5.ttv_dat_base_fechto_vendor      = ?
                           tt_alter_tit_acr_base_5.tta_cod_proces_export           =  nota-fiscal.nr-proc-exp /*zera saldo do titulo que foi desvinculado do processo de origem*/
                           tt_alter_tit_acr_base_5.tta_cod_refer                   = STRING(DAY(TODAY),"99") + 
                                                                                     ( 
                                                                                       IF   MONTH(TODAY) < 10 
                                                                                       THEN STRING(MONTH(TODAY),"9") 
                                                                                       ELSE ENTRY(MONTH(TODAY) - 9,"A,B,C") 
                                                                                     ) +
                                                                                     SUBSTRING(STRING(YEAR(TODAY),"9999"),4,1) +
                                                                                     SUBSTR(STRING(TIME,"hh:mm"),1,2) +
                                                                                     SUBSTR(STRING(TIME,"hh:mm"),4,2) +
                                                                                     SUBSTR(STRING(TIME,"hh:mm:ss"),7,2)
                           tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = p-num-tit-acr.      
        
                    RUN pi_main_code_integr_acr_alter_tit_acr_novo_10 IN h_boacr711zv (7,                                                                 
                                                                                       INPUT  TABLE tt_alter_tit_acr_base_5,                              
                                                                                       INPUT  TABLE tt_alter_tit_acr_rateio,                              
                                                                                       INPUT  TABLE tt_alter_tit_acr_ped_vda,                             
                                                                                       INPUT  TABLE tt_alter_tit_acr_comis_1,                               
                                                                                       INPUT  TABLE tt_alter_tit_acr_cheq,                                
                                                                                       INPUT  TABLE tt_alter_tit_acr_iva,                                                      
                                                                                       Input  table tt_alter_tit_acr_impto_retid_2,
                                                                                       Input  table tt_alter_tit_acr_cobr_espec_2,
                                                                                       Input  table tt_alter_tit_acr_rat_desp_rec,
                                                                                       Output table tt_log_erros_alter_tit_acr,
                                                                                       INPUT YES).
    
                    IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
                        FOR EACH tt_log_erros_alter_tit_acr:
                
                            FIND FIRST tt-bo-erro-5
                                WHERE  tt-bo-erro-5.cd-erro = tt_log_erros_alter_tit_acr.ttv_num_mensagem NO-LOCK NO-ERROR.
                            IF AVAIL tt-bo-erro-5 THEN
                                NEXT.
                
                            create tt-bo-erro-5.
                            assign tt-bo-erro-5.i-sequen     = i-seq-erro
                                   tt-bo-erro-5.cd-erro      = tt_log_erros_alter_tit_acr.ttv_num_mensagem
                                   tt-bo-erro-5.mensagem     = tt_log_erros_alter_tit_acr.ttv_des_msg_erro
                                   .                        
                        END.
                        UNDO, LEAVE bloco.
                    END.
                END. /*for each tt_retorna_tit_acr_proc_exp*/
            END. /*do trans bloco*/
        
            IF  NOT CAN-FIND(FIRST tt-bo-erro-5) THEN DO: 
                RUN pi-recria-titulos-ftapi001 (INPUT nota-fiscal.cod-estabel,
                                                INPUT nota-fiscal.serie      ,
                                                INPUT nota-fiscal.nr-nota-fis,
                                                OUTPUT TABLE tt-bo-erro).
                IF CAN-FIND(FIRST tt-bo-erro) THEN
                    UNDO bloco_atz_cria.
            END.
        END. /*tt-bo-erro*/
    END. /*do trans*/



    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-recria-titulos-ftapi001:
    /*
    ** Procedure respons vel por recriar os t¡tulos no CR a partir das notas fiscais
    ** relacionadas ao processo de exporta‡Æo
    */
    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie       LIKE nota-fiscal.serie       NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE l-existe AS LOGICAL     NO-UNDO.

    IF NOT VALID-HANDLE(h-ft2089) THEN DO:
        RUN ftp/ft2089.p PERSISTENT SET h-ft2089.
    END.

    bloco:
    DO TRANS:
        FIND FIRST nota-fiscal
             WHERE nota-fiscal.cod-estabel = pc-cod-estabel 
               AND nota-fiscal.serie       = pc-serie       
               AND nota-fiscal.nr-nota-fis = pc-nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL nota-fiscal THEN DO:
            ASSIGN nota-fiscal.dt-atual-cr = ?. /*seta como nÆo atualizado no CR*/
    
            FOR EACH fat-duplic
               WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                 AND fat-duplic.serie       = nota-fiscal.serie
                 AND fat-duplic.nr-fatura   = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK
                BREAK BY fat-duplic.parcela:

                ASSIGN fat-duplic.flag-atualiz = NO. /*seta como nÆo atualizado no CR*/
    
                /* Verifica se existe t¡tulo no Contas a Receber com a parcela a ser criada no SubProcesso*/

                IF FIRST(fat-duplic.parcela) THEN DO:
                    run pi-verifica-parcela in h-ft2089(input fat-duplic.cod-estabel,
                                                        input fat-duplic.cod-esp,
                                                        input fat-duplic.serie,
                                                        input nota-fiscal.nr-proc-exp,
                                                        input fat-duplic.parcela).
                    ASSIGN l-existe = NO.
                    if return-value = "NOK":U THEN do:
                        /*encontrou titulo no ems5 com a parcela*/
                        ASSIGN l-existe = YES.
                        RUN pi-busca-qtd-duplicatas in h-ft2089 (INPUT nota-fiscal.cod-estabel,
                                                                 INPUT nota-fiscal.nr-proc-exp,
                                                                 OUTPUT i-prox-parcela).
                        
                    END.
                END.
                IF l-existe THEN DO:
                    ASSIGN i-prox-parcela     = i-prox-parcela + 1.

                    FOR EACH rateio-it-duplic
                        WHERE rateio-it-duplic.cod-estabel = fat-duplic.cod-estabel
                          AND rateio-it-duplic.serie       = fat-duplic.serie
                          AND rateio-it-duplic.nr-fatura   = fat-duplic.nr-fatura 
                          AND rateio-it-duplic.parcela     = fat-duplic.parcela EXCLUSIVE-LOCK:
                        ASSIGN rateio-it-duplic.parcela = string(i-prox-parcela, "99":U).
                    END.
                    RELEASE rateio-it-duplic.
                    ASSIGN fat-duplic.parcela = string(i-prox-parcela, "99":U).
                END.
            END.
            RELEASE fat-duplic.
    
            FIND FIRST tt-nota-fiscal
                 WHERE tt-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                   AND tt-nota-fiscal.serie       = nota-fiscal.serie
                   AND tt-nota-fiscal.nr-fatura   = nota-fiscal.nr-fatura NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-nota-fiscal THEN DO:
                CREATE tt-nota-fiscal.
                ASSIGN tt-nota-fiscal.r-nota-fiscal = rowid(nota-fiscal)
                       tt-nota-fiscal.atualizar     = yes
                       tt-nota-fiscal.emite-duplic  = nota-fiscal.emite-duplic
                       tt-nota-fiscal.cod-estabel   = nota-fiscal.cod-estabel
                       tt-nota-fiscal.serie         = nota-fiscal.serie
                       tt-nota-fiscal.nr-fatura     = nota-fiscal.nr-fatura.
                ASSIGN l-atualiza-cr = YES.
            END.
    
            run ftp/ftapi001.p (input  3, /*versao da api*/
                                input  i-pais-impto-usuario,
                                input  i-cod-portador, /*solicitado em tela do EX3001C2*/
                                input  i-gera-titulo, /*solicitado em tela do EX3001C2*/
                                input  SESSION:TEMP-DIRECTORY,
                                input  table tt-nota-fiscal,
                                output table tt-retorno-nota-fiscal,
                                output table tt-total-refer).
            
            FOR EACH tt-retorno-nota-fiscal
                WHERE tt-retorno-nota-fiscal.cod-erro <> "9999"
                AND   tt-retorno-nota-fiscal.cod-erro <> "0000"
                AND   tt-retorno-nota-fiscal.situacao  = YES:
                DELETE tt-retorno-nota-fiscal.
            END.
            IF CAN-FIND(FIRST tt-retorno-nota-fiscal
                        where tt-retorno-nota-fiscal.cod-erro <> "9999") THEN DO: /*9999: nota fiscal atualizada com exito*/
                FOR EACH tt-retorno-nota-fiscal:
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.cd-erro = INT(tt-retorno-nota-fiscal.cod-erro)
                           tt-bo-erro.mensagem  = tt-retorno-nota-fiscal.desc-erro
                           tt-bo-erro.errorhelp = tt-retorno-nota-fiscal.desc-erro.
                END.

                UNDO bloco.
            END.
        END.
    END.

    IF VALID-HANDLE(h-ft2089) THEN
        DELETE PROCEDURE h-ft2089.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piretornadados:
/*------------------------------------------------------------------------------------------
Purpose:    Retorna dados do processo
Parameters: pc-cod-estabel - Código do estabelecimento
			pc-nr-proc-exp - Número do processo de exportação
			tt-processo-exp-orig - Temp-table com o processo encontrado
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-processo-exp-orig.

    FOR EACH tt-processo-exp-orig:
        DELETE tt-processo-exp-orig.
    END.

    FIND FIRST processo-exp
         WHERE processo-exp.cod-estabel = pc-cod-estabel
           AND processo-exp.nr-proc-exp = pc-nr-proc-exp NO-LOCK NO-ERROR.
    IF AVAIL processo-exp THEN DO:
        IF NOT CAN-FIND(FIRST tt-processo-exp-orig
                         WHERE tt-processo-exp-orig.cod-estabel = processo-exp.cod-estabel
                           AND tt-processo-exp-orig.nr-proc-exp = processo-exp.nr-proc-exp) THEN DO:
            CREATE tt-processo-exp-orig.
            BUFFER-COPY processo-exp EXCEPT dat-impl-proces-export volume-inf dt-prev-ex-factory TO tt-processo-exp-orig .

        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateSubProcExp:
/*------------------------------------------------------------------------------------------
Purpose:    Valida os dados do subprocesso
Parameters: pc-cod-estabel      - C¢digo do estabelecimento
            pc-nr-proc-exp-orig - N£mero processo de exporta‡Æo origem
            pl-valida-situacao  - Valida situa‡Æo do processo origem
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pc-cod-estabel       LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAM pc-nr-proc-exp-orig  LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE INPUT  PARAM pl-valida-situacao   AS LOGICAL                    NO-UNDO.

    {utp/ut-liter.i Processo_de_Exporta‡Æo_de_Origem *}
    ASSIGN c-lb-process-orig = trim(RETURN-VALUE).
    {utp/ut-liter.i Processo_de_Exporta‡Æo *}
    ASSIGN c-lb-processo-exp = trim(RETURN-VALUE).
    {utp/ut-liter.i Estabelecimento_do_SubProcesso_deve_ser_igual_ao_Estabelecimento_do_Processo_de_Exporta‡Æo_de_Origem *}
    ASSIGN c-lb-estabelec-dif = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Dever _ser_informado_um_Processo_de_Exporta‡Æo_que_esteja_com_a_situa‡Æo:_Aberto,_Faturado_Parcial_ou_Faturado. *}
    ASSIGN c-lb-situacao-dif = TRIM(RETURN-VALUE).

    /*Se nÆo for informado processo de origem*/
    if pc-nr-proc-exp-orig = "" then do:
        create tt-bo-erro.
        ASSIGN tt-bo-erro.parametros   = c-lb-process-orig.
        /*265 - Processo de Exporta‡Æo de Origem deve ser informado*/
        run utp/ut-msgs.p (input "msg":U,
                           input 265,
                           input c-lb-process-orig).
        assign tt-bo-erro.i-sequen     = i-seq-erro + 1
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    ELSE DO:
        /*Se nÆo encontrar o processo de exporta‡Æo informado aqui ja valida se
          estabelecimento do processo de origem for diferente do estabelecimento do subprocesso*/
        IF NOT CAN-FIND (FIRST bf-processo-exp
                         WHERE bf-processo-exp.cod-estabel = pc-cod-estabel
                           AND bf-processo-exp.nr-proc-exp = pc-nr-proc-exp-orig) THEN DO:

            IF CAN-FIND(FIRST bf-processo-exp
                        WHERE bf-processo-exp.cod-estabel <> pc-cod-estabel
                          AND bf-processo-exp.nr-proc-exp = pc-nr-proc-exp-orig) THEN DO:
                /*158 - &1 inv lido(a). Informe um(a) &1 v lido(a). &2*/
                run utp/ut-msgs.p (input "msg":U,
                                   input 158,
                                   input c-lb-processo-exp).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                       tt-bo-erro.cd-erro      = 158
                       tt-bo-erro.mensagem     = RETURN-VALUE
                       tt-bo-erro.errorhelp    = c-lb-estabelec-dif
                       tt-bo-erro.parametros   = c-lb-processo-exp.
            END.
            ELSE DO:
                /*2 - NÆo encontrado Processo de Exporta‡Æo de Origem para chave informada*/
                {utp/ut-liter.i "Processo_de_Exporta‡Æo_de_Origem" *}
                create tt-bo-erro.
                ASSIGN tt-bo-erro.parametros = RETURN-VALUE.
                run utp/ut-msgs.p (input "msg":U,
                                   input 2,
                                   input RETURN-VALUE).
                
                assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                       tt-bo-erro.cd-erro      = 2
                       tt-bo-erro.mensagem     = return-value.
            END.
        END.
        ELSE DO:
            IF pl-valida-situacao THEN DO:
                FIND FIRST bf-processo-exp 
                     WHERE bf-processo-exp.cod-estabel = pc-cod-estabel
                       AND bf-processo-exp.nr-proc-exp = pc-nr-proc-exp-orig NO-LOCK NO-ERROR.
                IF AVAIL bf-processo-exp THEN DO:
                    /*Se processo tiver situa‡Æo diferente de "Aberto", "Faturado Parcial" ou "Faturado"*/
                    IF bf-processo-exp.cod-sit-proc <> 1 AND
                       bf-processo-exp.cod-sit-proc <> 3 AND
                       bf-processo-exp.cod-sit-proc <> 7 THEN DO:
        
                        /*158 - &1 inv lido(a). Informe um(a) &1 v lido(a). &2*/
                        run utp/ut-msgs.p (input "msg":U,
                                           input 158,
                                           input c-lb-process-orig).
                        create tt-bo-erro.
                        assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                               tt-bo-erro.cd-erro      = 158
                               tt-bo-erro.mensagem     = return-value
                               tt-bo-erro.errorhelp    = c-lb-situacao-dif
                               tt-bo-erro.parametros   = c-lb-process-orig.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
 
PROCEDURE pi-valida-desv-subprocesso :
/*------------------------------------------------------------------------------
  Purpose:     Valida se permite desvincular o processo executando o EX3001C
  Parameters:  pc-cod-estabel - Estabelecimento
               pc-nr-proc-exp - Processo de Exporta‡Æo
               pl-permite-desvinculo - indica se permite desvinculo ou nÆo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pc-cod-estabel       LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAM pc-nr-proc-exp       LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAM pl-permite-desvinculo AS LOG INITIAL YES            NO-UNDO.

    DEFINE VARIABLE c-return            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dt-geracao          AS DATE     NO-UNDO.
    DEFINE VARIABLE idi-tip-operac      AS INTEGER  NO-UNDO.
    DEFINE VARIABLE idi-situacao        AS INTEGER  NO-UNDO.
    DEFINE VARIABLE l-log-proc-efet     AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-possui-subproc    AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE h-bocx362           AS HANDLE   NO-UNDO.

    RUN cxbo/bocx362.p      PERSISTENT SET h-bocx362.

    ValidateBlock:
    DO  ON ERROR UNDO, LEAVE ValidateBlock
        ON STOP  UNDO, LEAVE ValidateBlock
        ON QUIT  UNDO, LEAVE ValidateBlock:
        /*Verifica se o usuÿrio possui permiss’o para desvincular*/
        FOR FIRST usuar-export FIELDS (log-livre-1)
             WHERE usuar-export.cod-usuar = c-seg-usuario NO-LOCK:
            IF NOT usuar-export.log-livre-1 THEN DO:
                ASSIGN pl-permite-desvinculo = NO.
                leave ValidateBlock.
            END.
        END.
    
        FIND FIRST processo-exp 
             WHERE processo-exp.cod-estabel = pc-cod-estabel
               AND processo-exp.nr-proc-exp = pc-nr-proc-exp NO-LOCK NO-ERROR.
    
        IF AVAIL processo-exp THEN DO:
            /*Processo de exporta»’o contabilizado*/
            IF processo-exp.log-atualiz-ctb THEN DO:
                ASSIGN pl-permite-desvinculo = NO.
                leave ValidateBlock.
            END.
                
            /*Verifica se processo tem log de gera»’o no CR*/
            FOR FIRST param-exp FIELDS (log-controla-dupl-export) 
                WHERE param-exp.cod-estabel = processo-exp.cod-estabel NO-LOCK:
                IF param-exp.log-controla-dupl-export THEN DO:
                    run piverificaLogProcessado in h-bocx362 (INPUT processo-exp.cod-estabel,
                                                              INPUT processo-exp.nr-proc-exp,
                                                              INPUT 3, /*Log de geracao de titulo no contas a receber*/
                                                              OUTPUT idi-tip-operac,
                                                              OUTPUT idi-situacao,
                                                              OUTPUT dt-geracao). 
                    
                    IF RETURN-VALUE <> "NOK":U THEN
                        ASSIGN l-log-proc-efet = (idi-tip-operac = 1). /*Efetiva»’o*/
                    ELSE
                        ASSIGN l-log-proc-efet = NO.
                END.
            END.
            IF l-log-proc-efet THEN DO:
                ASSIGN pl-permite-desvinculo = NO.
                leave ValidateBlock.
            END.
    
            FOR EACH proc-nota-fiscal 
               WHERE proc-nota-fiscal.cod-estabel = processo-exp.cod-estabel
                 AND proc-nota-fiscal.nr-proc-exp = processo-exp.nr-proc-exp NO-LOCK:
    
                /*Nota devolvida*/
                IF proc-nota-fiscal.log-nf-devolvid THEN DO:
                    ASSIGN pl-permite-desvinculo = NO.
                    leave ValidateBlock.
                END.
    
                FIND FIRST nota-fiscal 
                     WHERE nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                       AND nota-fiscal.serie = proc-nota-fiscal.serie
                       AND nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                IF AVAIL nota-fiscal THEN DO:
                    /*Nota Contabilizada ou Cancelada*/
                    IF nota-fiscal.ind-contabil OR nota-fiscal.dt-cancela <> ? THEN DO:
                        ASSIGN pl-permite-desvinculo = NO.
                        leave ValidateBlock.
                    END.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-bocx362) THEN DO:
       DELETE PROCEDURE h-bocx362.
       ASSIGN h-bocx362 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-processo-possui-nota-embarq :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se existe notas ou embarques vinculados ao processo 
  Parameters:  pc-cod-estabel - Estabelecimento
               pc-nr-proc-exp - Processo de Exporta‡Æo
               pl-possui-nota-embarque - indica se existe nota ou embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pc-cod-estabel       LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAM pc-nr-proc-exp       LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAM pl-possui-nota-embarque AS LOG                     NO-UNDO.

    ASSIGN pl-possui-nota-embarque = CAN-FIND (FIRST proc-nota-fiscal 
                                               WHERE proc-nota-fiscal.cod-estabel = pc-cod-estabel
                                                 AND proc-nota-fiscal.nr-proc-exp = pc-nr-proc-exp) OR
                                     CAN-FIND (FIRST embarque 
                                               WHERE embarque.cod-estabel = pc-cod-estabel 
                                                 AND embarque.nr-proc-exp = pc-nr-proc-exp).

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE getTTBoErro :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a temp-table de erros
  Parameters:  tt-bo-erro - Temp-table com os erros
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE deleteTTBoErro :
/*------------------------------------------------------------------------------
  Purpose:     Elimina os dados da tt-bo-erro
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   for each tt-bo-erro:
       delete tt-bo-erro.
   end.

   RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-seta-l-ex0200-proces-orig:
/*------------------------------------------------------------------------------
  Purpose:     Identifica a forma de gera‡Æo dos dados do acompanhamento do SubProcesso
  Parameters:  pl-ex0200-proces-orig
  Notes:       Quando  pl-ex0200-proces-orig = yes: Gera o Acompanhamento do SubProcesso 
                                   como "espelho" do Acompanhamento do Processo de Origem 
                       pl-ex0200-proces-orig = no: Gera o Acompanhamento do SubProcesso
                                   com base no Itiner rio do SubProcesso (forma atual)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-ex0200-proces-orig AS LOGICAL NO-UNDO.

    ASSIGN l-ex0200-proces-orig = pl-ex0200-proces-orig.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-valida-cod-idioma-argentina:
/*------------------------------------------------------------------------------
  Purpose:     Verifica se tem cadastrado o codigo idioma AFIP
  Parameters:  p-cod-idioma
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE v_cod_idioma_afip as INTEGER format ">>99" no-undo.
    DEFINE VARIABLE h-boar2109 AS HANDLE NO-UNDO.
  

    IF NOT VALID-HANDLE(h-boar2109) THEN DO:
        RUN local/arg/boar2109.p PERSISTENT SET h-boar2109.
        run openQueryStatic in h-boar2109 (INPUT "Main":U).
    END.

    IF VALID-HANDLE(h-boar2109) THEN 
        RUN buscaCampos IN h-boar2109 (INPUT  rowObject.cod-idioma,
                                       OUTPUT v_cod_idioma_afip).


  IF v_cod_idioma_afip = 0 THEN
  DO: 

      ASSIGN i-seq-erro = i-seq-erro + 1.
      RUN utp/ut-msgs.p (INPUT "msg":U,
                         INPUT 55612,
                         INPUT "").


      CREATE tt-bo-erro.
      ASSIGN tt-bo-erro.i-sequen = i-seq-erro                   
          tt-bo-erro.cd-erro  = 55612
          tt-bo-erro.mensagem = RETURN-VALUE.   
      

      RUN utp/ut-msgs.p (INPUT "help",
                         INPUT 55612, 
                         INPUT rowObject.cod-idioma).

      ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.

  END.
    
    IF VALID-HANDLE(h-boar2109) THEN DO:
        DELETE PROCEDURE h-boar2109.
        ASSIGN h-boar2109 = ?.
    END.


    RETURN "OK":U.
END PROCEDURE.
