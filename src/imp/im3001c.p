/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3001C 2.00.00.003 } /*** "010003" 14/06/2024 09:32:14  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3001c MIM}
&ENDIF


/****************************************************************************
**
**    IM3001C.P - V¡nculo da ProvissÆo.
**
****************************************************************************/
{btb/btb009za.i}
{app/apapi001b.i}
{cdp/cd0666.i} /**** Defini‡Æo da temp-table tt-erro ****/

/*** Sempre que a apapi001.i for utilizada junto com a apapi201.i, a apapi001.i sempre dever  ser
     definida primeiro e a vari vel abaixo c-apapi001-inc dever  ser definida(com &scoped-define).
     Este procedimento ‚ obrigat¢rio pois as includes definem temp-tables com os mesmos nomes, o
     que ocasionar  erro de compila‡Æo caso este procedimento nÆo seja efetuado.
 ***/
&scoped-define c-apapi001-inc 

/** DEFINI€ÇO TEMP-TABLES **/
DEF TEMP-TABLE tt_msg_erros NO-UNDO
    FIELD ttv_num_seq                      AS INTEGER FORMAT ">>>,>>9" LABEL "Seqˆncia" COLUMN-LABEL "Seq" 
    FIELD ttv_num_msg_erro                 AS INTEGER FORMAT ">>>>>>9" LABEL "Mensagem"  COLUMN-LABEL "Mensagem" 
    FIELD ttv_dsl_msg_erro                 AS CHARACTER format "x(255)" .

DEF TEMP-TABLE tt-embarque-aux NO-UNDO
    FIELD embarque AS CHAR 
    INDEX i-embarque IS PRIMARY UNIQUE embarque.

DEF TEMP-TABLE tt_log_erros NO-UNDO
    FIELD ttv_num_seq                      AS INTEGER   FORMAT ">>>,>>9"  LABEL "Seqˆncia"      COLUMN-LABEL "Seq"
    FIELD ttv_num_cod_erro                 AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero"         COLUMN-LABEL "N£mero"
    FIELD ttv_des_erro                     AS CHARACTER FORMAT "x(50)"    LABEL "Inconsistˆncia" COLUMN-LABEL "Inconsistˆncia"
    FIELD ttv_des_ajuda                    AS CHARACTER FORMAT "x(50)"    LABEL "Ajuda"          COLUMN-LABEL "Ajuda"
    INDEX tt_id                           
          ttv_num_seq                      ASCENDING
          ttv_num_cod_erro                 ASCENDING.

DEF TEMP-TABLE tt_xml_input_output NO-UNDO
    FIELD ttv_cod_label                    AS CHARACTER FORMAT "x(8)"  LABEL "Label" COLUMN-LABEL "Label"
    FIELD ttv_des_conteudo                 AS CHARACTER FORMAT "x(40)" LABEL "Texto" COLUMN-LABEL "Texto"
    FIELD ttv_des_conteudo_aux             AS CHARACTER FORMAT "x(40)"
    FIELD ttv_num_seq_1                    AS INTEGER   FORMAT ">>>,>>9".
/***************************/

DEF INPUT        PARAMETER r-rowid-doc AS ROWID NO-UNDO.
DEF INPUT        PARAMETER i-sequencia AS INTEGER.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-lin-i-ap.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-l-pre-ap.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
    
{imp/im9024.i1} /* Defini‡Æo das temp-tables do EMS5 */
{cdp/cd4300.i3} /* Variaveis para CD4300.I4  */
{rep/re1001a.i50}  /* variaveis e informacoes utilizadas pelo re1001a.i51 */

DEF VAR l-erro-ems50         AS LOGICAL INIT NO.
DEF VAR l-existe             AS LOGICAL INIT NO.
DEF VAR c-msg                AS CHARACTER EXTENT 2    NO-UNDO.
DEF VAR c-ref-aux            LIKE lin-i-ap.referencia NO-UNDO.
DEF VAR de-disponivel        AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INIT 0.
DEF VAR de-disponivel-aux    AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INIT 0.
DEF VAR de-vl-previsao-me    AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INIT 0.
DEF VAR de-vl-prov           AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INIT 0.
DEF VAR de-vl-orig-me        AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INIT 0.
DEF VAR l-erro               AS LOG     NO-UNDO.
DEF VAR l-ja-conec-emsuni    AS LOG     NO-UNDO.
DEF VAR l-ja-conec-emsbas    AS LOG     NO-UNDO.
DEF VAR l-ja-conec-emsfin    AS LOG     NO-UNDO.
DEF VAR c-parcela            AS CHAR    NO-UNDO.
DEF VAR i-parc-cont          AS INT     NO-UNDO.
DEF VAR i-num-id-tit-acr-apb AS INT     NO-UNDO.
DEF VAR h-btb009za           AS HANDLE  NO-UNDO.
DEF VAR c-cod-estabel        AS CHAR    NO-UNDO.

DEF BUFFER bf-docum-est     FOR docum-est.
DEF BUFFER bf-docum-est-aux FOR docum-est.

FIND docum-est NO-LOCK
WHERE ROWID(docum-est) = r-rowid-doc NO-ERROR.

FIND FIRST tt-lin-i-ap NO-LOCK
     WHERE tt-lin-i-ap.cod-fornec = docum-est.cod-emitente NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.

IF  AVAIL tt-lin-i-ap AND AVAIL docum-est THEN DO:
    
    IF docum-est.nat-operacao <> "":U THEN DO:
        IF CAN-FIND(FIRST embarq-import-docto
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
                
                RUN carregarTabelas (INPUT ROWID(bf-docum-est)).
            END.
        END.
    END.
END.


/* ********** PROCEDUTES INTERNAS ********** */

PROCEDURE pi-limpa-tabelas:
    FOR EACH tt_tit_ap_vl_compdo:
        DELETE tt_tit_ap_vl_compdo.
    END.
    
    FOR EACH tt_tit_ap_alteracao_base_1:
        DELETE tt_tit_ap_alteracao_base_1.
    END.
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
         WHERE param-imp.cod-estabel = tt-lin-i-ap.cod-estabel NO-ERROR.
    
    IF  AVAIL param-imp THEN DO:
        FIND embarque-imp NO-LOCK
             WHERE embarque-imp.cod-estabel = tt-lin-i-ap.cod-estabel
               AND embarque-imp.embarque    = c-embarque NO-ERROR.   
    
        IF  AVAIL embarque-imp AND embarque-imp.contabilizado = YES THEN DO:      
    
            FIND tt-embarque-aux where tt-embarque-aux.embarque = c-embarque no-error.
            IF  NOT AVAIL tt-embarque-aux THEN DO:
                CREATE tt-embarque-aux.
                ASSIGN tt-embarque-aux.embarque = c-embarque.
            END.
            ELSE NEXT.
    
            /*CONECTA NO EMS5*/
            RUN pi-conecta-ems-5 (INPUT YES,
                                  INPUT param-global.empresa-prin,
                                  OUTPUT l-erro).
            
            ASSIGN l-erro-ems50 = NO.
            
            IF  NOT l-erro THEN DO:
                RUN prgint/dcf/dcf903za.py (INPUT  001,
                                            INPUT  "1", /* "APB" */
                                            INPUT  STRING(docum-est.cod-estabel)    + "," +
                                                   STRING(tt-lin-i-ap.cod-fornec)   + "," +
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
    
            RUN pi-traduz-ems2-ems5.
    
            ASSIGN c-cod-estabel = tt-lin-i-ap.cod-estabel.
            IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
                FIND FIRST tt_xml_input_output
                     WHERE tt_xml_input_output.ttv_cod_label    = "Estabel":U
                       AND tt_xml_input_output.ttv_des_conteudo = tt-lin-i-ap.cod-estabel NO-ERROR.
                IF  AVAIL  tt_xml_input_output THEN
                    ASSIGN c-cod-estabel = tt_xml_input_output.ttv_des_conteudo_aux.
            END.
            
            /*DESCONECTA DO EMS5*/
            RUN pi-conecta-ems-5 (INPUT NO,
                                  INPUT param-global.empresa-prin,
                                  OUTPUT l-erro).
    
            DO i-parc-cont = 1 TO INT(c-parcela):
    
                CREATE tt_tit_ap_vl_compdo.
                ASSIGN tt_tit_ap_vl_compdo.tta_cod_estab           = tt-lin-i-ap.cod-estabel   
                       tt_tit_ap_vl_compdo.tta_cdn_fornecedor      = tt-lin-i-ap.cod-fornec
                       tt_tit_ap_vl_compdo.tta_cod_espec_docto     = param-imp.esp-tit-transit 
                       tt_tit_ap_vl_compdo.tta_cod_ser_docto       = " "
                       tt_tit_ap_vl_compdo.tta_cod_tit_ap          = embarque-imp.embarque
                       tt_tit_ap_vl_compdo.tta_cod_parcela         = STRING(i-parc-cont,"99")
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
                    ASSIGN i-sequencia = i-sequencia + 1.
                    ASSIGN tt-erro.i-sequen = i-sequencia
                           tt-erro.cd-erro  = 6246
                           tt-erro.mensagem = RETURN-VALUE.                                               
            END.
            ELSE DO:                            
                IF  NOT l-erro-ems50 THEN
                    RUN prgfin/apb/apb908za.py (INPUT 1,
                                                INPUT-OUTPUT TABLE tt_tit_ap_vl_compdo) .
    
                ASSIGN de-disponivel-aux = 0.
                FOR EACH tt_tit_ap_vl_compdo:       
                    ASSIGN de-disponivel-aux = de-disponivel-aux + (tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap -
                                                                    tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap).
                END.
    
                FOR EACH tt_tit_ap_vl_compdo NO-LOCK:

                    IF tt_tit_ap_vl_compdo.ttv_log_existe_tit = YES THEN DO:

                        ASSIGN de-disponivel = tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap
                                             - tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap
                               de-vl-prov    = de-disponivel.
                    
                        IF  de-disponivel > 0 THEN DO:

                            bloco_1:
                            FOR EACH  tt-lin-i-ap
                                WHERE tt-lin-i-ap.cod-fornec = docum-est.cod-emitente
                                   BY tt-lin-i-ap.parcela:
                                
                                ASSIGN de-vl-orig-me = (tt-lin-i-ap.vl-liquido-me * de-disponivel) / de-disponivel-aux.
                                
                                CREATE tt-l-pre-ap.
                                ASSIGN tt-l-pre-ap.ep-codigo      = tt-lin-i-ap.ep-codigo
                                       tt-l-pre-ap.cod-estabel    = tt-lin-i-ap.cod-estabel
                                       tt-l-pre-ap.cod-esp        = tt-lin-i-ap.cod-esp
                                       tt-l-pre-ap.serie	      = tt-lin-i-ap.serie
                                       tt-l-pre-ap.nr-docto       = tt-lin-i-ap.nr-docto
                                       tt-l-pre-ap.parcela	      = tt-lin-i-ap.parcela                   
                                       tt-l-pre-ap.ep-cod-pre     = param-global.empresa-prin                   
                                       tt-l-pre-ap.cod-est-pre    = c-cod-estabel
                                       tt-l-pre-ap.cod-esp-pre    = tt_tit_ap_vl_compdo.tta_cod_espec_docto 
                                       tt-l-pre-ap.serie-pre      = tt_tit_ap_vl_compdo.tta_cod_ser_docto  
                                       tt-l-pre-ap.nr-docto-pre   = tt_tit_ap_vl_compdo.tta_cod_tit_ap        
                                       tt-l-pre-ap.parcela-pre    = tt_tit_ap_vl_compdo.tta_cod_parcela   
                                       tt-l-pre-ap.moeda-pre      = tt-lin-i-ap.mo-codigo
                                       tt-l-pre-ap.cod-fornec     = tt_tit_ap_vl_compdo.tta_cdn_fornecedor  
                                       tt-l-pre-ap.vl-previsao    = 0
                                       tt-l-pre-ap.vl-previsao-me = IF  de-disponivel < de-vl-orig-me THEN
                                                                        de-disponivel
                                                                    ELSE 
                                                                        de-vl-orig-me.
                                
                                IF  tt-l-pre-ap.vl-previsao-me > de-vl-prov THEN DO:
                                    ASSIGN tt-l-pre-ap.vl-previsao-me = de-vl-prov.
                                    LEAVE bloco_1.
                                END.
                                
                                ASSIGN tt-l-pre-ap.vl-previsao-me = ROUND(tt-l-pre-ap.vl-previsao-me, 2)
                                       de-vl-prov                 = ROUND(de-vl-prov - tt-l-pre-ap.vl-previsao-me, 2).
                            END.
                        END.
                    END.
                END.
                
                FOR EACH tt-l-pre-ap
                    WHERE tt-l-pre-ap.vl-previsao-me = 0:
                    DELETE tt-l-pre-ap.
                END.
            END.
            
            RUN pi-limpa-tabelas.
    
        END.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-traduz-ems2-ems5:
    EMPTY TEMP-TABLE tt_xml_input_output.
    EMPTY TEMP-TABLE tt_log_erros.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label        = "Fun‡Æo":U
           tt_xml_input_output.ttv_des_conteudo     = "Recebimento 2.00":U
           tt_xml_input_output.ttv_num_seq_1        = 1.
    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label        = "Produto":U
           tt_xml_input_output.ttv_des_conteudo     = "EMS 5"
           tt_xml_input_output.ttv_num_seq_1        = 1.
    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label        = "Empresa":U
           tt_xml_input_output.ttv_des_conteudo     = string(tt-lin-i-ap.ep-codigo)
           tt_xml_input_output.ttv_num_seq_1        = 1.
    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label        = "Estabel":U
           tt_xml_input_output.ttv_des_conteudo     = tt-lin-i-ap.cod-estabel
           tt_xml_input_output.ttv_num_seq_1        = 1.
    
    RUN prgint/utb/utb786za.py (INPUT-OUTPUT TABLE tt_xml_input_output,
                                      OUTPUT TABLE tt_log_erros).
    
    IF  CAN-FIND(FIRST tt_log_erros) THEN DO:
        FOR EACH tt_log_erros:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = tt_log_erros.ttv_num_seq 
                   tt-erro.cd-erro  = tt_log_erros.ttv_num_cod_erro
                   tt-erro.mensagem = tt_log_erros.ttv_des_erro.
        END.
        
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
END PROCEDURE.
