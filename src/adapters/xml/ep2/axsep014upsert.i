PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE PARAM BUFFER b-param-nf-estab FOR param-nf-estab.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

DEF VAR cTpTrans AS CHAR NO-UNDO.
/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.

IF NOT AVAIL b-param-nf-estab THEN
   RETURN "NOK":U.

    RUN cdp/cd0360b.p (INPUT b-param-nf-estab.cod-estabel,
                       INPUT "":U,
                       OUTPUT cTpTrans).

    IF  cTpTrans = "TSS":U THEN DO:
        RUN pi-Configura-TempoEspera-TSS-Sincrono (INPUT ROWID(b-param-nf-estab)).
        
    END.
    ELSE DO:
        IF  cTpTrans = "TC":U THEN DO:
    
                    RUN PIUpsert (INPUT "",                
                      INPUT b-param-nf-estab.cod-estabel,     
                      INPUT b-param-nf-estab.ind-empresa,     
                      INPUT b-param-nf-estab.num-tempo-espera,
                      OUTPUT TABLE tt_log_erro).

        END.

    END.

END PROCEDURE.

PROCEDURE pi-Configura-TempoEspera-TSS-Sincrono:
    DEFINE INPUT PARAMETER r-param-nf-estab AS ROWID NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cTempoEsperaRetorno       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cTempoEspera              AS CHARACTER   NO-UNDO.

    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunica‡Æo com o TSS*/
    END.
    
    IF  NOT AVAIL param-nf-estab THEN
        FOR FIRST param-nf-estab NO-LOCK
            WHERE ROWID(param-nf-estab) = r-param-nf-estab: END.

    IF  NOT AVAIL param-nf-estab OR 
        &if "{&bf_dis_versao_ems}" >= "2.08" &then
           TRIM(param-nf-estab.cod-url-ws-tss) = "":U OR
           TRIM(param-nf-estab.cod-url-ws-tss) = "http://":U
        &else
           TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100)) = "":U OR
           TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100)) = "http://":U
        &endif
        THEN DO:

        CREATE TT_LOG_ERRO.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-url-webservice-do-tss-nao-info AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "URL_WebService_do_TSS_nÆo_informada" *}
        ASSIGN c-lbl-liter-url-webservice-do-tss-nao-info = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-a-url-do-webservice-do-tss-dev AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_URL_do_WebService_do_TSS_deve_ser_previamente_informada_nos_parƒmetros_de_integra‡Æo_com_o_TSS" *}
        ASSIGN c-lbl-liter-a-url-do-webservice-do-tss-dev = TRIM(RETURN-VALUE).
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006
               TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-url-webservice-do-tss-nao-info + "!"
               TT_LOG_ERRO.TTV_DES_MSG_AJUDA = c-lbl-liter-a-url-do-webservice-do-tss-dev + ".".

        RETURN "NOK":U.
    END.

    RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                 TRIM(param-nf-estab.cod-url-ws-tss)
                               &else
                                 TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                               &endif).
                                       
    RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                     INPUT "*",
                                     INPUT param-nf-estab.cod-estabel,
                                     INPUT param-nf-estab.cod-url-ws-tss).
                               
    ASSIGN cTempoEspera =  STRING(param-nf-estab.num-tempo-espera).

    RUN SPEDCFGNFE_CFGTEMPOESPERA IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                               INPUT cTempoEspera,
                                               OUTPUT cTempoEsperaRetorno).

    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("SPEDCFGNFE":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS CFGTEMPOESPERA]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS CFGTEMPOESPERA]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.
