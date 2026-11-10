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
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

IF NOT AVAIL b-param-nf-estab THEN
   RETURN "NOK":U.

/* Là conte£do do certificado digital */
IF  TRIM(b-param-nf-estab.cod-arq-certif) <> "":U THEN DO:
    ASSIGN m-cripto-arq = BASE64-DECODE(b-param-nf-estab.cod-arq-certif) NO-ERROR.
    COPY-LOB FROM FILE GET-STRING(m-cripto-arq,1) TO encdmptr NO-ERROR.
    encdlngc-arq = BASE64-ENCODE(encdmptr) NO-ERROR.
END.

IF  TRIM(b-param-nf-estab.cod-chave-certif) <> "":U THEN DO:
    ASSIGN m-cripto-chave = BASE64-DECODE(b-param-nf-estab.cod-chave-certif) NO-ERROR.
    COPY-LOB FROM FILE GET-STRING(m-cripto-chave,1) TO encdmptr NO-ERROR.
    encdlngc-chave = BASE64-ENCODE(encdmptr) NO-ERROR.
END.

RUN cdp/cd0360b.p (INPUT b-param-nf-estab.cod-estabel,
                   INPUT "":U,
                   OUTPUT cTpTrans).

    IF  LOOKUP("TSS",cTpTrans) > 0 OR LOOKUP("TC",cTpTrans) > 0 THEN
        RUN pi-Configura-Certificado-TSS-Sincrono (INPUT ROWID(b-param-nf-estab)).
    ELSE
        RUN PIUpsert (INPUT cTranAction,                
                      INPUT b-param-nf-estab.cod-estabel, 
                      INPUT b-param-nf-estab.ind-empresa,     
                      INPUT trim(encdlngc-arq),
                      INPUT b-param-nf-estab.cod-senha-certif ,
                      INPUT trim(encdlngc-chave),
                      INPUT IF b-param-nf-estab.idi-certif = 1 THEN "PEM":U ELSE "PFX":U,
                      OUTPUT TABLE tt_log_erro).


END PROCEDURE.

PROCEDURE pi-Configura-Certificado-TSS-Sincrono:
    DEFINE INPUT PARAMETER r-param-nf-estab        AS ROWID   NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI              AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCertificadoRetorno   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMetodoTSS            AS CHARACTER   NO-UNDO.
    
    /* Retirar coment†rio quando for liberada vers∆o do TSS que contemple */
    /* a tratativa do envio do certificado em base64 com quebras de linha */
    /*DEFINE VARIABLE mArquivoCertificado   AS MEMPTR      NO-UNDO.
    DEFINE VARIABLE mConteudoCertificado  AS MEMPTR      NO-UNDO.
    DEFINE VARIABLE mArquivoChave         AS MEMPTR      NO-UNDO.
    DEFINE VARIABLE mConteudoChave        AS MEMPTR      NO-UNDO.
    DEFINE VARIABLE mSenhaDecode          AS MEMPTR      NO-UNDO.*/
    
    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunicaá∆o com o TSS*/
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
        {utp/ut-liter.i "URL_WebService_do_TSS_n∆o_informada" *}
        ASSIGN c-lbl-liter-url-webservice-do-tss-nao-info = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-a-url-do-webservice-do-tss-dev AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_URL_do_WebService_do_TSS_deve_ser_previamente_informada_nos_parÉmetros_de_integraá∆o_com_o_TSS" *}
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
                                           
    /* Retirar coment†rio quando for liberada vers∆o do TSS que contemple */
    /* a tratativa do envio do certificado em base64 com quebras de linha */
    /*ASSIGN mArquivoCertificado = BASE64-DECODE(param-nf-estab.cod-arq-certif).
    COPY-LOB FROM FILE GET-STRING(mArquivoCertificado,1) TO mConteudoCertificado.
    ASSIGN SET-SIZE(mArquivoCertificado) = 0.
    
    ASSIGN mArquivoChave = BASE64-DECODE(param-nf-estab.cod-chave-certif).
    COPY-LOB FROM FILE GET-STRING(mArquivoChave,1) TO mConteudoChave.
    ASSIGN SET-SIZE(mArquivoChave) = 0.

    ASSIGN mSenhaDecode    = BASE64-DECODE(param-nf-estab.cod-senha-certif).

    IF  param-nf-estab.idi-certif = 1 THEN DO: /* "PEM" */
        ASSIGN cMetodoTSS = "CFGCERTIFICATE".
        RUN SPEDCFGNFE_CFGCERTIFICATE IN h-TSSAPI (INPUT param-nf-estab.ind-empresa,
                                                   INPUT mConteudoCertificado,
                                                   INPUT mConteudoChave,
                                                   INPUT mSenhaDecode,
                                                   OUTPUT cCertificadoRetorno).
    END.
    ELSE DO: /*"PFX" */
        ASSIGN cMetodoTSS = "CFGCERTIFICATEPFX".
        RUN SPEDCFGNFE_CFGCERTIFICATEPFX IN h-TSSAPI  (INPUT param-nf-estab.ind-empresa,
                                                       INPUT mConteudoCertificado,
                                                       INPUT mSenhaDecode,
                                                       OUTPUT cCertificadoRetorno). 
    END.*/

    /**** INICIO - RETIRAR ESSE C‡DIGO COM AP‡S LIBERAÄ«O ATUALIZACAO DO TSS ****/
    IF  param-nf-estab.idi-certif = 1 THEN DO: /* "PEM" */
        ASSIGN cMetodoTSS = "CFGCERTIFICATE":U.
        RUN SPEDCFGNFE_CFGCERTIFICATE_VIA_SOCKET IN h-TSSAPI (INPUT param-nf-estab.ind-empresa,
                                                              INPUT TRIM(encdlngc-arq),
                                                              INPUT TRIM(encdlngc-chave),
                                                              INPUT param-nf-estab.cod-senha-certif,
                                                              INPUT cMetodoTSS,
                                                              OUTPUT cCertificadoRetorno).
    END.
    ELSE IF param-nf-estab.idi-certif = 2 THEN DO: /* "PFX" */
        ASSIGN cMetodoTSS = "CFGCERTIFICATEPFX":U.
        RUN SPEDCFGNFE_CFGCERTIFICATE_VIA_SOCKET IN h-TSSAPI  (INPUT param-nf-estab.ind-empresa,
                                                               INPUT TRIM(encdlngc-arq),
                                                               INPUT TRIM(encdlngc-chave),
                                                               INPUT param-nf-estab.cod-senha-certif,
                                                               INPUT cMetodoTSS,
                                                               OUTPUT cCertificadoRetorno). 
    END.
    ELSE DO: /* "HSM" */
        ASSIGN cMetodoTSS = "CFGHSM":U.
        RUN recebeParametrosHSM IN h-TSSAPI (INPUT TRIM(SUBSTR(param-nf-estab.cod-livre-4,418,20)),  /* slot   */
                                             INPUT TRIM(SUBSTR(param-nf-estab.cod-livre-4,438,50)),  /* label  */
                                             INPUT TRIM(SUBSTR(param-nf-estab.cod-livre-4,488,200))). /* module */
        RUN SPEDCFGNFE_CFGCERTIFICATE_VIA_SOCKET IN h-TSSAPI  (INPUT param-nf-estab.ind-empresa,
                                                               INPUT TRIM(encdlngc-arq),
                                                               INPUT TRIM(encdlngc-chave),
                                                               INPUT param-nf-estab.cod-senha-certif,
                                                               INPUT cMetodoTSS,
                                                               OUTPUT cCertificadoRetorno). 
    END.
    /***** FIM - RETIRAR ESSE C‡DIGO COM AP‡S LIBERAÄ«O ATUALIZACAO DO TSS *****/

    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("SPEDCFGNFE":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS ":U + cMetodoTSS + "]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS ":U + cMetodoTSS + "]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.
