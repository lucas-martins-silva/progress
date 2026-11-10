/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3001D 2.00.00.002 } /*** "010002" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3001d MIM}
&ENDIF

/****************************************************************************
**
**    IM3001D.P - Baixa Saldo Material em TrÉnsito
**
****************************************************************************/
{btb/btb009za.i}
{app/apapi001b.i}
{cdp/cd0666.i} /**** Definiá∆o da temp-table tt-erro ****/

/*** Sempre que a apapi001.i for utilizada junto com a apapi201.i, a apapi001.i sempre dever† ser
     definida primeiro e a vari†vel abaixo c-apapi001-inc dever† ser definida(com &scoped-define).
     Este procedimento Ç obrigat¢rio pois as includes definem temp-tables com os mesmos nomes, o
     que ocasionar† erro de compilaá∆o caso este procedimento n∆o seja efetuado.
 ***/
&scoped-define c-apapi001-inc 

/** DEFINIÄ«O TEMP-TABLES **/
DEF TEMP-TABLE tt_msg_erros NO-UNDO
    FIELD ttv_num_seq                      AS INTEGER FORMAT ">>>,>>9" LABEL "SeqÅància" COLUMN-LABEL "Seq" 
    FIELD ttv_num_msg_erro                 AS INTEGER FORMAT ">>>>>>9" LABEL "Mensagem"  COLUMN-LABEL "Mensagem" 
    FIELD ttv_dsl_msg_erro                 AS CHARACTER format "x(255)" .

DEF INPUT        PARAMETER r-rowid-doc AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
    
{imp/im9024.i1} /* Definiá∆o das temp-tables do EMS5 */
{cdp/cd4300.i3} /* Variaveis para CD4300.I4  */
{rep/re1001a.i50}  /* variaveis e informacoes utilizadas pelo re1001a.i51 */

DEF VAR l-erro-ems50         AS LOGICAL INIT NO.
DEF VAR l-existe             AS LOGICAL INIT NO.
DEF VAR c-msg                AS CHARACTER EXTENT 2    NO-UNDO.
DEF VAR c-ref-aux            LIKE lin-i-ap.referencia NO-UNDO.
DEF VAR l-erro               AS LOG     NO-UNDO.
DEF VAR l-ja-conec-emsuni    AS LOG     NO-UNDO.
DEF VAR l-ja-conec-emsbas    AS LOG     NO-UNDO.
DEF VAR l-ja-conec-emsfin    AS LOG     NO-UNDO.
DEF VAR c-parcela            AS CHAR    NO-UNDO.
DEF VAR i-parc-cont          AS INT     NO-UNDO.
DEF VAR i-num-id-tit-acr-apb AS INT     NO-UNDO.
DEF VAR h-btb009za           AS HANDLE  NO-UNDO.

DEF BUFFER bf-docum-est     FOR docum-est.
DEF BUFFER bf-docum-est-aux FOR docum-est.

FIND FIRST param-global NO-LOCK                                      NO-ERROR.
FIND FIRST docum-est    NO-LOCK WHERE ROWID(docum-est) = r-rowid-doc NO-ERROR.

IF  AVAIL docum-est THEN DO:

    IF docum-est.nat-operacao <> "":U THEN DO:
        IF  docum-est.sit-docum = 1
        AND CAN-FIND(FIRST embarq-import-docto
                     WHERE embarq-import-docto.cod-docto        = docum-est.nro-docto
                       AND embarq-import-docto.cdn-emitente     = docum-est.cod-emitente
                       AND embarq-import-docto.cod-natur-operac = docum-est.nat-operacao
                       AND embarq-import-docto.cod-ser-docto    = docum-est.serie-docto) THEN
            RUN carregarTabelas(INPUT ROWID(docum-est)).
    END.
    ELSE DO:
        FOR FIRST item-doc-est FIELDS (serie-comp nro-comp cod-emitente nat-comp)
            WHERE item-doc-est.serie-docto  = docum-est.serie-docto 
              AND item-doc-est.nro-docto    = docum-est.nro-docto   
              AND item-doc-est.cod-emitente = docum-est.cod-emitente
              AND item-doc-est.nat-operacao = docum-est.nat-operacao NO-LOCK:

            FOR FIRST bf-docum-est FIELDS (log-1)
                WHERE bf-docum-est.serie-docto  = item-doc-est.serie-comp
                  AND bf-docum-est.nro-docto    = item-doc-est.nro-comp   
                  AND bf-docum-est.cod-emitente = item-doc-est.cod-emitente
                  AND bf-docum-est.nat-operacao = item-doc-est.nat-comp     NO-LOCK:

                IF  bf-docum-est.sit-docum = 1 THEN
                    RUN carregarTabelas (INPUT ROWID(bf-docum-est)).
            END.
        END.
    END.
END.

/* ********** PROCEDUTES INTERNAS ********** */
PROCEDURE pi-acerta-dif-prov-tit:
    
    /* Criar AVA na Provis∆o para zerar o saldo se o mesmo for maior do que o do t°tulo */    
    IF  SEARCH("prgfin/apb/apb767ze.r")  = ? AND
        SEARCH("prgfin/apb/apb767ze.py") = ? THEN DO:   

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 6246,
                           INPUT "prgfin/apb/apb767ze.py").
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 6246
               tt-erro.mensagem = RETURN-VALUE.
    END.
    ELSE DO:
        RUN pi-monta-referencia.
        
        CREATE tt_tit_ap_alteracao_base_aux_1.
        ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = docum-est.usuario         
               tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = ?
               tt_tit_ap_alteracao_base_aux_1.tta_cod_estab_ext                 = docum-est.cod-estabel 
               tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor                = docum-est.cod-emitente                  
               tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto               = param-imp.esp-tit-transit
               tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                 = " " 
               tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                    = c-embarque 
               tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                   = tt_tit_ap_vl_compdo.tta_cod_parcela
               tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = 0
               tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = ?
               tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = docum-est.dt-trans
               tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = c-ref-aux 
               tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = 0 
               tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = ?
               tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = ?
               tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = ?
               tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = ?
               tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = 0
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = 0
               tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = 0
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = 0
               tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = ?
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = 0
               tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = 0
               tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                  = ""
               tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto           = ""
               tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = ""
               tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = ?
               tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "ALTERAÄ«O"
               tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = ""
               tt_tit_ap_alteracao_base_aux_1.tta_cb4_tit_ap_bco_cobdor         = ""
               tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto               = "".
        
        CREATE tt_tit_ap_alteracao_rateio.
        ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = ?
               tt_tit_ap_alteracao_rateio.tta_cod_estab             = ""
               tt_tit_ap_alteracao_rateio.tta_cod_refer             = ""
               tt_tit_ap_alteracao_rateio.tta_num_seq_refer         = 0
               tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ  = ""
               tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl    = ""
               tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl          = ""
               tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc        = ""
               tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto      = ""
               tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap         = 0
               tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap  = ?
               tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat           = "Valor".

        RELEASE tt_tit_ap_alteracao_base_aux_1.
        RELEASE tt_tit_ap_alteracao_rateio.
    END.


    RETURN "OK":U.
END PROCEDURE.      

PROCEDURE pi-monta-referencia:  
    ASSIGN c-ref-aux = STRING(DAY(TODAY),"99") +
                       IF  MONTH(TODAY) < 10 THEN
                           STRING(MONTH(TODAY),"9")
                                 + SUBSTR(STRING(TIME,"hh:mm"),1,2)
                                 + SUBSTR(STRING(TIME,"hh:mm"),4,2)
                                 + SUBSTR(STRING(TIME,"hh:mm:ss"),7,2)
                                 + "1"
                       ELSE
                           ENTRY(MONTH(TODAY) - 9,"A,B,C")
                                + SUBSTR(STRING(TIME,"hh:mm"),1,2)
                                + SUBSTR(STRING(TIME,"hh:mm"),4,2)
                                + SUBSTR(STRING(TIME,"hh:mm:ss"),7,2)
                                + "1".
END PROCEDURE.

PROCEDURE pi-conecta-ems-5:
    DEF INPUT  PARAM l-conecta   AS LOGICAL NO-UNDO.
    DEF INPUT  PARAM p-empresa LIKE param-global.empresa-prin NO-UNDO.
    DEF OUTPUT PARAM l-erro-ems5 AS LOGICAL NO-UNDO.

    ASSIGN l-erro-ems5 = NO.

    IF  l-conecta THEN DO:
        IF  SEARCH("prgfin/acr/acr900zf.r":U)  = ? 
        AND SEARCH("prgfin/acr/acr900zf.py":U) = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 6246,
                               INPUT "prgfin/acr/acr900zf.py":U).
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

                RUN btb/btb009za.p PERSISTENT SET h-btb009za.

                IF  VALID-HANDLE(h-btb009za) THEN
                    RUN pi-conecta-bco IN h-btb009za (INPUT 1, /* Versao API  */
                                                      INPUT 1, /* 1 - conexao, 2 - Desconexao */
                                                      INPUT p-empresa, /* Codigo da empresa */
                                                      INPUT "all":U, /* nome do banco */
                                                      OUTPUT TABLE tt_erros_conexao). /* temp-table de erros */
                IF  RETURN-VALUE <> "OK":U THEN DO:
                    FIND FIRST tt_erros_conexao NO-LOCK NO-ERROR.
                    IF  AVAIL tt_erros_conexao THEN
                        ASSIGN l-erro-ems5 = YES.
                END.

                IF  VALID-HANDLE(h-btb009za) THEN DO:
                    DELETE PROCEDURE h-btb009za.
                    ASSIGN h-btb009za = ?.
                END.
            END.
        END.
    END.
    
    IF  NOT l-conecta OR l-erro-ems5 THEN DO:
        IF l-ja-conec-emsuni = NO
        OR l-ja-conec-emsbas = NO
        OR l-ja-conec-emsfin = NO THEN DO: 
            
            RUN btb/btb009za.p PERSISTENT SET h-btb009za.
            
            RUN pi-conecta-bco IN h-btb009za (INPUT 1, /* Versao API  */
                                              INPUT 2, /* 1 - conexao, 2 - Desconexao */
                                              INPUT p-empresa, /* Codigo da empresa */
                                              INPUT "all":U, /* nome do banco */
                                              OUTPUT TABLE tt_erros_conexao). /* temp-table de erros */
            IF  RETURN-VALUE <> "OK":U THEN DO:
                FIND FIRST tt_erros_conexao NO-LOCK NO-ERROR.
                IF  AVAIL tt_erros_conexao THEN
                    ASSIGN l-erro-ems5 = YES.
            END.
            IF  VALID-HANDLE(h-btb009za) THEN DO:                
                DELETE procedure h-btb009za.
                ASSIGN h-btb009za = ?.
            END.
        END.
    END.
    RETURN "OK":U.
END.

PROCEDURE carregarTabelas:

    DEF INPUT PARAM r-rowid AS ROWID NO-UNDO.

    FIND bf-docum-est-aux NO-LOCK
         WHERE ROWID(bf-docum-est-aux) = r-rowid NO-ERROR.

    FIND FIRST embarq-import-docto NO-LOCK
         WHERE embarq-import-docto.cod-docto        = bf-docum-est-aux.nro-docto
           AND embarq-import-docto.cdn-emitente     = bf-docum-est-aux.cod-emitente
           AND embarq-import-docto.cod-natur-operac = bf-docum-est-aux.nat-operacao
           AND embarq-import-docto.cod-ser-docto    = bf-docum-est-aux.serie-docto NO-ERROR.
    IF  AVAIL embarq-import-docto THEN
        ASSIGN c-embarque = embarq-import-docto.cod-embarq.
    ELSE
        ASSIGN c-embarque = ''.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = docum-est.cod-estabel NO-ERROR.

    IF  AVAIL param-imp THEN DO:
        FIND embarque-imp NO-LOCK
             WHERE embarque-imp.cod-estabel = docum-est.cod-estabel
               AND embarque-imp.embarque    = c-embarque NO-ERROR.

        IF  AVAIL embarque-imp AND embarque-imp.contabilizado = YES THEN DO:      

            /*CONECTA NO EMS5*/
            RUN pi-conecta-ems-5 (INPUT YES,
                                  INPUT param-global.empresa-prin,
                                  OUTPUT l-erro).
            
            ASSIGN l-erro-ems50 = NO.
            
            IF  NOT l-erro THEN DO:
                RUN prgint/dcf/dcf903za.py (INPUT  001,
                                            INPUT  "1", /* "APB" */
                                            INPUT  STRING(docum-est.cod-estabel)    + "," +
                                                   STRING(docum-est.cod-emitente)   + "," +
                                                   STRING(param-imp.esp-tit-transit)+ "," +
                                                   STRING(" ")                      + "," +
                                                   STRING(embarque-imp.embarque)    + "," +
                                                   STRING(0),
                                            INPUT  YES, /* Procura pela £ltima parcela */
                                            OUTPUT l-existe,
                                            OUTPUT c-parcela,
                                            INPUT-OUTPUT TABLE tt_msg_erros,
                                            OUTPUT l-erro-ems50,
                                            OUTPUT i-num-id-tit-acr-apb).
                
                FOR EACH tt_msg_erros:
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = tt_msg_erros.ttv_num_seq
                           tt-erro.cd-erro  = tt_msg_erros.ttv_num_msg_erro
                           tt-erro.mensagem = tt_msg_erros.ttv_dsl_msg_erro.
                END.
            END.

            /*DESCONECTA DO EMS5*/
            RUN pi-conecta-ems-5 (INPUT NO,
                                  INPUT param-global.empresa-prin,
                                  OUTPUT l-erro).

            DO i-parc-cont = 1 TO INT(c-parcela):

                CREATE tt_tit_ap_vl_compdo.
                ASSIGN tt_tit_ap_vl_compdo.tta_cod_estab           = docum-est.cod-estabel   
                       tt_tit_ap_vl_compdo.tta_cdn_fornecedor      = docum-est.cod-emitente
                       tt_tit_ap_vl_compdo.tta_cod_espec_docto     = param-imp.esp-tit-transit 
                       tt_tit_ap_vl_compdo.tta_cod_ser_docto       = " "
                       tt_tit_ap_vl_compdo.tta_cod_tit_ap          = embarque-imp.embarque
                       tt_tit_ap_vl_compdo.tta_cod_parcela         = STRING(i-parc-cont)
                       tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap = 0
                       tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap      = 0.
            END.
            
            IF  SEARCH("prgfin/apb/apb908za.r")  = ? AND
                SEARCH("prgfin/apb/apb908za.py") = ? THEN DO:
                    RUN utp/ut-msgs.p (INPUT "msg",
                                       INPUT 6246,
                                       INPUT "prgfin/apb/apb908za.py").
                    ASSIGN l-erro-ems50 = YES.
                    CREATE tt-erro.
                    ASSIGN tt-erro.cd-erro  = 6246
                           tt-erro.mensagem = RETURN-VALUE.                                               
            END.
            ELSE DO:                            
                IF  NOT l-erro-ems50 THEN
                    RUN prgfin/apb/apb908za.py (INPUT 1,
                                                INPUT-OUTPUT TABLE tt_tit_ap_vl_compdo) .

                FOR EACH tt_tit_ap_vl_compdo NO-LOCK:
                    IF  tt_tit_ap_vl_compdo.ttv_log_existe_tit  = YES 
                    AND tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap <> 0 THEN
                        RUN pi-acerta-dif-prov-tit.
                END.
            END.

            IF CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1) THEN DO:
                RUN prgfin/apb/apb767ze.py(INPUT 1,
                                           INPUT "Rep",
                                           INPUT "",
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                           OUTPUT TABLE tt_log_erros_tit_ap_alteracao).
                
                FOR EACH tt_log_erros_tit_ap_alteracao:
        
                    IF  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6542 THEN
                        NEXT.
        
                    {utp/ut-field.i mgind dupli-apagar nro-docto 1} 
                    ASSIGN c-msg[1] = RETURN-VALUE.
                    {utp/ut-liter.i EMS5 MRE R}
                    ASSIGN c-msg[1] = c-msg[1] + " " + RETURN-VALUE.
                    
                    CREATE tt-erro.
                    ASSIGN tt-erro.cd-erro  = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem 
                           tt-erro.mensagem =  c-msg[1] + " " 
                                            + tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap
                                            + " " 
                                            + tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro.
                END.
        
                EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_1.
                EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
            END.

            EMPTY TEMP-TABLE tt_tit_ap_vl_compdo.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
