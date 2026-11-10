PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE PARAM BUFFER b-param-nf-estab FOR param-nf-estab.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

DEFINE VARIABLE i-tipo-emissao-a-enviar AS INTEGER     NO-UNDO.
DEFINE VARIABLE cTpTrans                AS CHARACTER   NO-UNDO.

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.

IF NOT AVAIL b-param-nf-estab THEN
   RETURN "NOK":U.

/*------------------------------------
   TIPO DE EMISSÇO - PADRÇO SEFAZ
--------------------------------------
1 Normal
2 Contingˆncia FS
3 Contingˆncia SCAN
4 Contingˆncia EPEC
5 Contingˆncia FS-DA
6 Contingˆncia SVC-AN, emissÆo em contingˆncia na SEFAZ Virtual do Ambiente Nacional
7 Contingˆncia SVC-RS, emissÆo em contingˆncia na SEFAZ Virtual do RS
------------------------------------*/

/*------------------------------------
   TIPO DE EMISSÇO - PADRÇO TSS
--------------------------------------
1 Normal
2 Contingˆncia
3 SCAN
4 Ambiente Nacional
5 Contigˆncia Eletr“nica-EPEC
6 Sefaz Virtual - RS
7 Contingˆncia FS-DA
8 Contingˆncia SVC - AN
9 Contingˆncia SVC - RS
------------------------------------*/

/*Fazer os ajustes, pois o padrÆo SEFAZ ‚ diferente do padrÆo TSS*/

CASE b-param-nf-estab.idi-tip-emis-nf-eletro:

    /*PadrÆo SEFAZ (FT0912 {Contingˆncia NF-e})*/

    WHEN 1 THEN DO:

        ASSIGN i-tipo-emissao-a-enviar = 1.

        CASE &if "{&bf_dis_versao_ems}" >= "2.09" &then
               b-param-nf-estab.idi-tip-amb-transm
             &else
               b-param-nf-estab.num-livre-2
             &endif :
        
            /*Outras op‡äes espec¡ficas para TSS sobre ambientes de TransmissÆo (gravados no cd0403b.w) 1 SEFAZ Origem
                                                                                                        2 Ambiente Nacional
                                                                                                        3 SEFAZ Virtual (RS)  */
        
            WHEN 1 THEN
                ASSIGN i-tipo-emissao-a-enviar = 1.
            WHEN 2 THEN
                ASSIGN i-tipo-emissao-a-enviar = 4.
            WHEN 3 THEN
                ASSIGN i-tipo-emissao-a-enviar = 6.
        END CASE.
    END.
    WHEN 2 THEN
        ASSIGN i-tipo-emissao-a-enviar = 2.
    WHEN 3 THEN
        ASSIGN i-tipo-emissao-a-enviar = 3.
    WHEN 4 THEN
        ASSIGN i-tipo-emissao-a-enviar = 5.
    WHEN 5 THEN
        ASSIGN i-tipo-emissao-a-enviar = 7.
    WHEN 6 THEN
        ASSIGN i-tipo-emissao-a-enviar = 8.
    WHEN 7 THEN
        ASSIGN i-tipo-emissao-a-enviar = 9.

    OTHERWISE
        ASSIGN i-tipo-emissao-a-enviar = 1.
END CASE.

RUN cdp/cd0360b.p (INPUT b-param-nf-estab.cod-estabel,
                   INPUT "":U,
                   OUTPUT cTpTrans).

IF  LOOKUP("TSS",cTpTrans) > 0 OR LOOKUP("TC",cTpTrans) > 0 THEN
    RUN pi-Configura-Modalidade-TSS-Sincrono (INPUT ROWID(b-param-nf-estab),
                                              INPUT i-tipo-emissao-a-enviar).
ELSE
    RUN PIUpsert (INPUT cTranAction,                
                  INPUT b-param-nf-estab.cod-estabel, 
                  INPUT b-param-nf-estab.ind-empresa,     
                  INPUT i-tipo-emissao-a-enviar,
                  OUTPUT TABLE tt_log_erro).

END PROCEDURE.

PROCEDURE pi-Configura-Modalidade-TSS-Sincrono:
    DEFINE INPUT PARAMETER r-param-nf-estab        AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER i-tipo-emissao-a-enviar AS INTEGER NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cModalidadeRetorno       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cModalidade              AS CHARACTER   NO-UNDO.

    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunica»’o com o TSS*/
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
                                   
    ASSIGN cModalidade =  STRING(i-tipo-emissao-a-enviar).

    RUN SPEDCFGNFE_CFGMODALIDADE IN h-TSSAPI (INPUT param-nf-estab.ind-empresa, 
                                              INPUT cModalidade,
                                              OUTPUT cModalidadeRetorno).

    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("SPEDCFGNFE":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS CFGMODALIDADE]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS CFGMODALIDADE]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.
