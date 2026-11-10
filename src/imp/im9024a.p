/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9024A 2.00.00.008 } /*** "010008" 03/09/2026 19:01:28  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9024a MIM}
&ENDIF

/****************************************************************************
**
**    IM9024.P - V°nculo da proviss∆o.
**
****************************************************************************/

&if defined(bf-mat-comex) &then
&else

{app/apapi001b.i}
/***  Sempre que a apapi001.i for utilizada junto com a apapi201.i, a apapi001.i sempre dever† ser definida 
      primeiro e a vari†vel abaixo c-apapi001-inc dever† ser definida(com &scoped-define). Este procedimento
      Ç obrigat¢rio pois as includes definem temp-tables com os mesmos nomes, o que ocasionar† erro de 
      compilaá∆o caso este procedimento n∆o seja efetuado 
 ***/
&scoped-define c-apapi001-inc 

{cdp/cd0666.i} /**** Definiá∆o da temp-table tt-erro ****/

{utp/ut-glob.i} /* Definiá∆o Vari†veis Globais */
{include/boerrtab.i} /* Definiá∆o Temp-table de Erros */

def input parameter p-cod-estabel   like estabelec.cod-estabel no-undo.
def input parameter p-embarque      like embarque-imp.embarque no-undo.

/*
** p-fator-atualiz: fator de atualizaá∆o do valor do t°tulo do embarque original  
                    p-fator-atualiz * valor do t°tulo = valor do ava
*/
def input parameter p-fator-atualiz as   decimal               no-undo.
def output parameter table for tt-bo-erro.

{imp/im9024.i1} /* Definiá∆o das temp-tables do EMS5 */
{btb/btb009za.i} /*Definiá∆o da tt_erros_conexao */

def temp-table tt_tit_ap_vl_compdo_aux NO-UNDO like tt_tit_ap_vl_compdo.
    
def var l-erro-ems50  as   logical init no                           no-undo.
def var c-msg         as   character extent 2                        no-undo.
def var c-ref-aux     like lin-i-ap.referencia                       no-undo.
def var de-disponivel as   decimal format "->>>>>,>>>,>>9.99" init 0 no-undo.
def var de-valor-ava  as   decimal format "->>>>>,>>>,>>9.99" init 0 no-undo.
def var i-parcelas    as   integer                                   no-undo.
def var i-sequencia   as   integer                                   no-undo.
DEF VAR c-help        AS   CHAR                                      NO-UNDO.

def var l-conec-bas   as   logical no-undo.
def var l-conec-fin   as   logical no-undo.
def var l-conec-uni   as   logical no-undo.
def var l-erro        as   logical no-undo.

def var l-ja-conectado as logical      no-undo.
def var l-ems50        as logical      no-undo.
DEF VAR h-btb009za     AS HANDLE       NO-UNDO.


DEFINE VARIABLE h-buf-tit-ap    AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-qry-tit-ap    AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-cod-estab-tit AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-num-id-tit-ap AS INT64     NO-UNDO.

DEFINE VARIABLE h-buf-movto-tit-ap    AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-qry-movto-tit-ap    AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-buf-aprop-ctbl-ap   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-qry-aprop-ctbl-ap   AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-num-id-movto-tit-ap AS INT64     NO-UNDO.
DEFINE VARIABLE c-cod-plano-cta-ctbl  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-cta-ctbl        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-plano-ccusto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-ccusto          AS CHARACTER NO-UNDO.


find first param-global no-lock no-error.

find embarque-imp
    where embarque-imp.cod-estabel = p-cod-estabel
      and embarque-imp.embarque    = p-embarque no-lock no-error.      
      
if not avail embarque-imp or not embarque-imp.contabilizado then
    RETURN "OK":U.    
    
for first param-imp fields(esp-tit-transit)
    where param-imp.cod-estabel = p-cod-estabel no-lock:
end.

for first ordens-embarque fields(numero-ordem)
    where ordens-embarque.cod-estabel = p-cod-estabel
      and ordens-embarque.embarque    = p-embarque no-lock:
    for first ordem-compra fields(cod-emitente cod-cond-pag)
        where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock:
    end.
end.

for first cond-pagto fields(num-parcelas)
    where cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock:
end.

do i-parcelas = 1 to cond-pagto.num-parcelas:
            
    create tt_tit_ap_vl_compdo_aux.
    assign tt_tit_ap_vl_compdo_aux.tta_cod_estab           = p-cod-estabel
           tt_tit_ap_vl_compdo_aux.tta_cdn_fornecedor      = ordem-compra.cod-emitente
           tt_tit_ap_vl_compdo_aux.tta_cod_espec_docto     = param-imp.esp-tit-transit
           tt_tit_ap_vl_compdo_aux.tta_cod_ser_docto       = " "
           tt_tit_ap_vl_compdo_aux.tta_cod_tit_ap          = p-embarque
           tt_tit_ap_vl_compdo_aux.tta_cod_parcela         = string(i-parcelas,"99")
           tt_tit_ap_vl_compdo_aux.tta_val_comprtdo_tit_ap = 0
           tt_tit_ap_vl_compdo_aux.tta_val_sdo_tit_ap      = 0.           

end.

assign l-erro-ems50 = no.

if  search("prgfin/apb/apb908za.r")  = ? and
    search("prgfin/apb/apb908za.py") = ? then do:
        run utp/ut-msgs.p (input "msg",
                           input 6246,
                           input "prgfin/apb/apb908za.py").
        assign l-erro-ems50 = yes.
        create tt-erro.
        assign i-sequencia = i-sequencia + 1.
        assign tt-erro.i-sequen     = i-sequencia
               tt-erro.cd-erro      = 6246
               tt-erro.mensagem     = return-value.
    RETURN "NOK":U.                       
end.
else do:

    run pi-conecta-ems50 (input yes).
    
    for each tt_tit_ap_vl_compdo_aux:    
        
        ASSIGN c-cod-plano-cta-ctbl = ""
               c-cod-cta-ctbl       = ""               
               c-cod-plano-ccusto   = ""
               c-cod-ccusto         = "".
    
        create tt_tit_ap_vl_compdo.
        buffer-copy tt_tit_ap_vl_compdo_aux to tt_tit_ap_vl_compdo.            
        
        CREATE BUFFER h-buf-tit-ap FOR TABLE "tit_ap".
        CREATE QUERY h-qry-tit-ap.
        h-qry-tit-ap:SET-BUFFERS(h-buf-tit-ap).
        h-qry-tit-ap:QUERY-PREPARE("FOR EACH tit_ap NO-LOCK WHERE " +
            "cod_estab = '"       + tt_tit_ap_vl_compdo.tta_cod_estab       + "' AND " +
            "cod_espec_docto = '" + tt_tit_ap_vl_compdo.tta_cod_espec_docto + "' AND " +
            "cdn_fornecedor = "   + STRING(tt_tit_ap_vl_compdo.tta_cdn_fornecedor) + " AND " +
            "cod_tit_ap = '"      + tt_tit_ap_vl_compdo.tta_cod_tit_ap      + "' AND " +
            "cod_parcela = '"     + tt_tit_ap_vl_compdo.tta_cod_parcela     + "'").
        h-qry-tit-ap:QUERY-OPEN().
        h-qry-tit-ap:GET-FIRST().

        IF NOT h-qry-tit-ap:QUERY-OFF-END THEN
            ASSIGN c-cod-estab-tit = h-buf-tit-ap:BUFFER-FIELD("cod_estab"):BUFFER-VALUE
                   i-num-id-tit-ap = h-buf-tit-ap:BUFFER-FIELD("num_id_tit_ap"):BUFFER-VALUE.
        ELSE
            ASSIGN c-cod-estab-tit = ""
                   i-num-id-tit-ap = 0.

        h-qry-tit-ap:QUERY-CLOSE().
        DELETE OBJECT h-qry-tit-ap.
        DELETE OBJECT h-buf-tit-ap.

        IF i-num-id-tit-ap <> 0 THEN DO:

            // acha o movto_tit_ap do t°tulo (chave de ligaá∆o para a apropriaá∆o)
            CREATE BUFFER h-buf-movto-tit-ap FOR TABLE "movto_tit_ap".
            CREATE QUERY h-qry-movto-tit-ap.
            h-qry-movto-tit-ap:SET-BUFFERS(h-buf-movto-tit-ap).
            h-qry-movto-tit-ap:QUERY-PREPARE("FOR EACH movto_tit_ap NO-LOCK WHERE " +
                "cod_estab = '"    + c-cod-estab-tit + "' AND " +
                "num_id_tit_ap = " + STRING(i-num-id-tit-ap)).
            h-qry-movto-tit-ap:QUERY-OPEN().
            h-qry-movto-tit-ap:GET-FIRST().

            IF NOT h-qry-movto-tit-ap:QUERY-OFF-END THEN
                ASSIGN i-num-id-movto-tit-ap = h-buf-movto-tit-ap:BUFFER-FIELD("num_id_movto_tit_ap"):BUFFER-VALUE.
            ELSE
                ASSIGN i-num-id-movto-tit-ap = 0.

            h-qry-movto-tit-ap:QUERY-CLOSE().
            DELETE OBJECT h-qry-movto-tit-ap.
            DELETE OBJECT h-buf-movto-tit-ap.

            // acha a apropriaá∆o cont†bil j† usada por esse movto (linha "Despesa") 
            IF i-num-id-movto-tit-ap <> 0 THEN DO:

                CREATE BUFFER h-buf-aprop-ctbl-ap FOR TABLE "aprop_ctbl_ap".
                CREATE QUERY h-qry-aprop-ctbl-ap.
                h-qry-aprop-ctbl-ap:SET-BUFFERS(h-buf-aprop-ctbl-ap).
                h-qry-aprop-ctbl-ap:QUERY-PREPARE("FOR EACH aprop_ctbl_ap NO-LOCK WHERE " +
                    "cod_estab = '"           + c-cod-estab-tit + "' AND " +
                    "num_id_movto_tit_ap = "  + STRING(i-num-id-movto-tit-ap) + " AND " +
                    "ind_tip_aprop_ctbl = 'Despesa'").
                h-qry-aprop-ctbl-ap:QUERY-OPEN().
                h-qry-aprop-ctbl-ap:GET-FIRST().

                IF h-qry-aprop-ctbl-ap:QUERY-OFF-END THEN DO:
                    /* n∆o achou linha "Despesa" -> pega a primeira apropriaá∆o existente do movto */
                    h-qry-aprop-ctbl-ap:QUERY-CLOSE().
                    h-qry-aprop-ctbl-ap:QUERY-PREPARE("FOR EACH aprop_ctbl_ap NO-LOCK WHERE " +
                        "cod_estab = '"          + c-cod-estab-tit + "' AND " +
                        "num_id_movto_tit_ap = " + STRING(i-num-id-movto-tit-ap)).
                    h-qry-aprop-ctbl-ap:QUERY-OPEN().
                    h-qry-aprop-ctbl-ap:GET-FIRST().
                END.

                IF NOT h-qry-aprop-ctbl-ap:QUERY-OFF-END THEN
                    ASSIGN c-cod-plano-cta-ctbl = h-buf-aprop-ctbl-ap:BUFFER-FIELD("cod_plano_cta_ctbl"):BUFFER-VALUE
                           c-cod-cta-ctbl       = h-buf-aprop-ctbl-ap:BUFFER-FIELD("cod_cta_ctbl"):BUFFER-VALUE                           
                           c-cod-plano-ccusto   = h-buf-aprop-ctbl-ap:BUFFER-FIELD("cod_plano_ccusto"):BUFFER-VALUE
                           c-cod-ccusto         = h-buf-aprop-ctbl-ap:BUFFER-FIELD("cod_ccusto"):BUFFER-VALUE.

                h-qry-aprop-ctbl-ap:QUERY-CLOSE().
                DELETE OBJECT h-qry-aprop-ctbl-ap.
                DELETE OBJECT h-buf-aprop-ctbl-ap.
            END.
        END.
    
        if  not l-erro-ems50 then
            run prgfin/apb/apb908za.py (input 1,
                                        input-output table tt_tit_ap_vl_compdo).
                                                    
        find first tt_tit_ap_vl_compdo no-error.
                    
        if  avail tt_tit_ap_vl_compdo and   
            tt_tit_ap_vl_compdo.ttv_log_existe_tit = yes then do:
                    
            assign de-disponivel = tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap
                                 - tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap.                                 
                    
            if de-disponivel > 0 then do:
            
                assign de-valor-ava = tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap * p-fator-atualiz.
            
                /* 
                ** Criar AVA na Provis∆o para zerar o saldo se o mesmo for maior do que o do t°tulo 
                */
                
                run pi-monta-referencia.
                                                
                create tt_tit_ap_alteracao_base_1.    
                assign tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren            = c-seg-usuario
                       tt_tit_ap_alteracao_base_1.tta_cod_empresa                 = ? 
                       tt_tit_ap_alteracao_base_1.tta_cod_estab_ext               = tt_tit_ap_vl_compdo.tta_cod_estab                   
                       tt_tit_ap_alteracao_base_1.tta_num_id_tit_ap               = ?
                       tt_tit_ap_alteracao_base_1.ttv_rec_tit_ap                  = ?
                       tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor              = tt_tit_ap_vl_compdo.tta_cdn_fornecedor                   
                       tt_tit_ap_alteracao_base_1.tta_cod_espec_docto             = param-imp.esp-tit-transit 
                       tt_tit_ap_alteracao_base_1.tta_cod_ser_docto               = tt_tit_ap_vl_compdo.tta_cod_ser_docto      //" " 
                       tt_tit_ap_alteracao_base_1.tta_cod_tit_ap                  = p-embarque
                       tt_tit_ap_alteracao_base_1.tta_cod_parcela                 = tt_tit_ap_vl_compdo.tta_cod_parcela 
                       tt_tit_ap_alteracao_base_1.ttv_dat_transacao               = today
                       tt_tit_ap_alteracao_base_1.ttv_cod_refer                   = c-ref-aux 
                       tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap              = de-valor-ava
                       tt_tit_ap_alteracao_base_1.tta_dat_emis_docto              = ?
                       tt_tit_ap_alteracao_base_1.tta_dat_vencto_tit_ap           = ?
                       tt_tit_ap_alteracao_base_1.tta_dat_prev_pagto              = ?
                       tt_tit_ap_alteracao_base_1.tta_dat_ult_pagto               = ?
                       tt_tit_ap_alteracao_base_1.tta_num_dias_atraso             = ?
                       tt_tit_ap_alteracao_base_1.tta_val_perc_multa_atraso       = ?
                       tt_tit_ap_alteracao_base_1.tta_val_juros_dia_atraso        = ?
                       tt_tit_ap_alteracao_base_1.tta_val_perc_juros_dia_atraso   = ?
                       tt_tit_ap_alteracao_base_1.tta_dat_desconto                = ?
                       tt_tit_ap_alteracao_base_1.tta_val_perc_desc               = ?
                       tt_tit_ap_alteracao_base_1.tta_val_desconto                = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_portador                = ?
                       tt_tit_ap_alteracao_base_1.ttv_cod_portador_mov            = ""
                       tt_tit_ap_alteracao_base_1.tta_log_pagto_bloqdo            = ?             
                       tt_tit_ap_alteracao_base_1.tta_cod_seguradora              = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_apol_seguro             = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_arrendador              = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_contrat_leas            = ?
                       tt_tit_ap_alteracao_base_1.tta_ind_tip_espec_docto         = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_indic_econ              = ?
                       tt_tit_ap_alteracao_base_1.tta_num_seq_refer               = ?
                       tt_tit_ap_alteracao_base_1.ttv_ind_motiv_alter_val_tit_ap  = "ALTERACAO"
                       tt_tit_ap_alteracao_base_1.ttv_wgh_lista                   = ?
                       tt_tit_ap_alteracao_base_1.ttv_log_gera_ocor_alter_valores = yes
                       tt_tit_ap_alteracao_base_1.tta_cb4_tit_ap_bco_cobdor       = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_histor_padr             = " "
                       tt_tit_ap_alteracao_base_1.tta_des_histor_padr             = " "
                       tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap              = ?
                       tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto             = " ".                   
            
                create tt_tit_ap_alteracao_rateio.
                assign tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap           = ?
                       tt_tit_ap_alteracao_rateio.tta_cod_estab            = c-cod-estab-tit
                       tt_tit_ap_alteracao_rateio.tta_cod_refer            = " "
                       tt_tit_ap_alteracao_rateio.tta_num_seq_refer        = 0
                       tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ = " "                       
                       tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl   = c-cod-plano-cta-ctbl
                       tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl         = c-cod-cta-ctbl                        
                       tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto     = c-cod-plano-ccusto
                       tt_tit_ap_alteracao_rateio.tta_cod_ccusto           = c-cod-ccusto                       
                       tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc       = " "                       
                       tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl       = tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap - de-valor-ava
                       tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat          = "Valor"
                       tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap        =  i-num-id-tit-ap
                       tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap = 0.                    
                 
                run prgfin/apb/apb767zc.py(input 1,
                                           input "Rep",
                                           input " ",
                                           input-output table tt_tit_ap_alteracao_base_1,
                                           input-output table tt_tit_ap_alteracao_rateio,
                                           output table tt_log_erros_tit_ap_alteracao).

                for each tt_log_erros_tit_ap_alteracao:
                    {utp/ut-field.i mgind dupli-apagar nro-docto 1} 
                    assign c-msg[1] = return-value.
                    {utp/ut-liter.i EMS5 MRE R}
                    assign c-msg[1] = c-msg[1] + " " + return-value.

                    {utp/ut-liter.i "Importante!_A_baixa_do_t°tulo_dever†_ser_gerada_manualmente_pois_ocorreram_inconsistàncias_na integraá∆o_com_o_EMS5."}
                    ASSIGN c-help = RETURN-VALUE.

                    assign i-sequencia = i-sequencia + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen = i-sequencia
                           tt-bo-erro.cd-erro  = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem 
                           tt-bo-erro.mensagem =  c-msg[1] + " " 
                                               + tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap
                                               + " " 
                                               + tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro
                           tt-bo-erro.errorsubtype = tt_log_erros_tit_ap_alteracao.ttv_cod_tip_msg_dwb
                           tt-bo-erro.errorhelp = tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda_1.

                end.                
            end.            
        end.
        
        EMPTY TEMP-TABLE tt_tit_ap_vl_compdo.
        EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_1.
                
    end.
    
    run pi-conecta-ems50 (input no).
    
end.


Procedure pi-monta-referencia:

    assign c-ref-aux = string(day(today),"99") +
                       if  month(today) < 10 then 
                           string(month(today),"9")
                                 + substr(string(time,"hh:mm"),1,2)
                                 + substr(string(time,"hh:mm"),4,2)
                                 + substr(string(time,"hh:mm:ss"),7,2)
                                 + "1"
                       else 
                           entry(month(today) - 9,"A,B,C")
                                + substr(string(time,"hh:mm"),1,2)
                                + substr(string(time,"hh:mm"),4,2)
                                + substr(string(time,"hh:mm:ss"),7,2)
                                + "1".
                                
end procedure.

/*
** Procedures conex∆o EMS 5.0
*/
{rep/re1005.i14}


&endif
