PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM pTipoVersao AS CHARACTER INITIAL ? NO-UNDO. /* versaoNFe ou versaoEPEC */
DEFINE PARAM BUFFER b-param-nf-estab FOR param-nf-estab.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

DEFINE VARIABLE c-versao-a-enviar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTpTrans          AS CHARACTER   NO-UNDO.

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.

IF NOT AVAIL b-param-nf-estab THEN
   RETURN "NOK":U.

FOR FIRST b-estabelec FIELDS(&if "{&bf_dis_versao_ems}" >= "2.071" &then des-vers-layout &else char-1 &endif) 
    WHERE b-estabelec.cod-estabel = b-param-nf-estab.cod-estabel NO-LOCK: 

    ASSIGN cTipoVersao = pTipoVersao.

    /**************************************************************************
                              ==== OBSERVA€ÇO ====
    O ENVIO DA VERSÇO DE LAYOUT EPEC  POSSÖVEL SOMENTE NA INTEGRA€ÇO SÖNCRONA.
    ASSÖNCRONA NÇO  POSSÖVEL DEVIDO · ALTERA€åES DE MAPA E CONFIG DO ESB.
    **************************************************************************/
    RUN cdp/cd0360b.p (INPUT b-estabelec.cod-estabel,
                       INPUT "":U,
                       OUTPUT cTpTrans).
    
    IF  LOOKUP("TSS",cTpTrans) > 0 OR LOOKUP("TC",cTpTrans) > 0 THEN
        RUN pi-Configura-VersaoSEFAZ-TSS-Sincrono (INPUT ROWID(b-param-nf-estab)).
    ELSE DO:

       ASSIGN c-versao-a-enviar = (&if  "{&bf_dis_versao_ems}" >= "2.071" &then
                                      b-estabelec.des-vers-layout
                                   &else
                                      TRIM(SUBSTRING(b-estabelec.char-1,173,10))
                                   &endif).

       RUN PIUpsert (INPUT cTranAction,
                     INPUT b-param-nf-estab.cod-estabel,
                     INPUT b-param-nf-estab.ind-empresa,
                     INPUT c-versao-a-enviar,
                     OUTPUT TABLE tt_log_erro).
    END.
END.

END PROCEDURE.

PROCEDURE pi-Configura-VersaoSEFAZ-TSS-Sincrono:
    DEFINE INPUT PARAMETER r-param-nf-estab AS ROWID NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cVersaoRetorno       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cVersaoAEnviar       AS CHARACTER   NO-UNDO.

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
                                                       
    /* Foi alterado para EPEC */
    IF  cTipoVersao = "versaoDPEC":U THEN DO:

        ASSIGN cVersaoAEnviar =  &if  "{&bf_dis_versao_ems}" >= "2.08" &then                                                                 
                                    param-nf-estab.cod-vers-dpec                                                                           
                                 &else                                                                                                       
                                    TRIM(SUBSTRING(param-nf-estab.cod-livre-1,106,10))                                                     
                                 &endif.
    
        RUN SPEDCFGNFE_CFGVERSAODPEC IN h-TSSAPI (INPUT param-nf-estab.ind-empresa,
                                                  INPUT cVersaoAEnviar,
                                                  OUTPUT cVersaoRetorno).
    END.
    ELSE DO:

        ASSIGN cVersaoAEnviar =  &if  "{&bf_dis_versao_ems}" >= "2.071" &then 
                                    b-estabelec.des-vers-layout
                                 &else 
                                    TRIM(SUBSTRING(b-estabelec.char-1,173,10))
                                 &endif.
    
        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
            IF l-conversor-entrada THEN DO:
    
                IF &if  "{&bf_dis_versao_ems}" >= "2.09" &then 
                       param-nf-estab.des-vers-layout <> "" AND param-nf-estab.des-vers-layout <> ?
                   &else 
                       TRIM(SUBSTRING(param-nf-estab.cod-livre-4,272,10)) <> "" AND TRIM(SUBSTRING(param-nf-estab.cod-livre-4,272,10)) <> ?
                   &ENDIF THEN DO:
                                         
                    ASSIGN cVersaoAEnviar =  &if  "{&bf_dis_versao_ems}" >= "2.09" &then 
                                                param-nf-estab.des-vers-layout
                                             &else 
                                                TRIM(SUBSTRING(param-nf-estab.cod-livre-4,272,10))
                                             &endif
                                             .
                END.
            END.
        END.
        RUN SPEDCFGNFE_CFGVERSAO     IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                                  INPUT cVersaoAEnviar,
                                                  OUTPUT cVersaoRetorno).
    END.
    
    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("SPEDCFGNFE":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS CFGVERSAO]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS CFGVERSAO]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.


