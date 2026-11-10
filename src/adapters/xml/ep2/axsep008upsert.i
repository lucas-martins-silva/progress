PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE PARAM BUFFER b-param-nf-estab FOR param-nf-estab.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

DEFINE VARIABLE cTpTrans AS CHARACTER NO-UNDO.
/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.

IF NOT AVAIL b-param-nf-estab THEN
   RETURN "NOK":U.

RUN cdp/cd0360b.p (INPUT b-param-nf-estab.cod-estabel,
                   INPUT "":U,
                   OUTPUT cTpTrans).
/* FOR FIRST b-estabelec FIELDS(char-1)                                      */
/*     WHERE b-estabelec.cod-estabel = b-param-nf-estab.cod-estabel NO-LOCK: */

    ASSIGN i-ambiente = &if '{&bf_dis_versao_ems}' >= '2.08':U
                        &then b-param-nf-estab.idi-tip-emis-amb-sefaz.
                        &else b-param-nf-estab.num-livre-1. &endif /*Configura‡Æo no TSS -> 1 = Produ‡Æo | 2 = Homologa‡Æo*/
    
    IF  LOOKUP("TSS",cTpTrans) > 0 OR LOOKUP("TC",cTpTrans) > 0 THEN
        RUN pi-Configura-AmbienteSEFAZ-TSS-Sincrono (INPUT ROWID(b-param-nf-estab)).
    ELSE
        RUN PIUpsert (INPUT cTranAction,                
                      INPUT b-param-nf-estab.cod-estabel,     
                      INPUT b-param-nf-estab.ind-empresa,     
                      INPUT i-ambiente,
                      OUTPUT TABLE tt_log_erro).

/*END.*/

END PROCEDURE.

PROCEDURE pi-Configura-AmbienteSEFAZ-TSS-Sincrono:
    DEFINE INPUT PARAMETER r-param-nf-estab AS ROWID NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAmbienteRetorno     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAmbiente            AS CHARACTER   NO-UNDO.

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
                               
    RUN setTSSAuthParam IN h-TSSAPI(INPUT 1,
                                    INPUT "*",
                                    INPUT param-nf-estab.cod-estabel,
                                    INPUT param-nf-estab.cod-url-ws-tss).
                                       
    ASSIGN cAmbiente = STRING(i-ambiente).

    RUN SPEDCFGNFE_CFGAMBIENTE IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                            INPUT cAmbiente,
                                            OUTPUT cAmbienteRetorno).

    ASSIGN cReturnValue = RETURN-VALUE.

    /*envio de configuracao ambiente modelos consulta de chave (65 57 e 67)*/
    /*65*/
    IF SUBSTRING(param-nf-estab.cod-livre-2,201,5) <> "":U THEN DO:
        RUN SPEDCFGNFE_CFGAMBIENTE_MOD IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                                    INPUT STRING(param-nf-estab.idi-tip-emis-amb-sefaz), /*Ambiente 1 - Produ‡Æo 2 - Homologa‡Æo*/
                                                    INPUT "65",                                          /*Modelo*/    
                                                    OUTPUT cAmbienteRetorno).
    END.
    /****/
    /*57*/
    IF SUBSTRING(param-nf-estab.cod-livre-2,206,5) <> "":U THEN DO:
        RUN SPEDCFGNFE_CFGAMBIENTE_MOD IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                                    INPUT STRING(param-nf-estab.idi-tip-emis-amb-sefaz), /*Ambiente 1 - Produ‡Æo 2 - Homologa‡Æo*/
                                                    INPUT "57",                                          /*Modelo*/    
                                                    OUTPUT cAmbienteRetorno).
    END.
    /****/
    /*67*/
    IF SUBSTRING(param-nf-estab.cod-livre-2,211,5) <> "":U THEN DO:
        RUN SPEDCFGNFE_CFGAMBIENTE_MOD IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                                    INPUT STRING(param-nf-estab.idi-tip-emis-amb-sefaz), /*Ambiente 1 - Produ‡Æo 2 - Homologa‡Æo*/
                                                    INPUT "67",                                          /*Modelo*/    
                                                    OUTPUT cAmbienteRetorno).
    END.
    /****/
    /**********************************************************************/
    
    RUN disconnectTss IN h-TSSAPI ("SPEDCFGNFE":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS CFGAMBIENTE]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS CFGAMBIENTE]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.
