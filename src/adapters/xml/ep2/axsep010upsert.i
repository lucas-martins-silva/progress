PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAMETER pTranAction     AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pTranEvent      AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttConsStatServ_ENV.
    DEFINE OUTPUT PARAMETER TABLE FOR ttConsStatServ_RET.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
    DEFINE VARIABLE cVersaoLayoutNFe AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTpTrans         AS CHARACTER NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    EMPTY TEMP-TABLE ttConsStatServ_RET.
    EMPTY TEMP-TABLE tt_log_erro.

    FOR FIRST ttConsStatServ_ENV :

        FOR FIRST unid-feder FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf-ibge &else char-1 &endif) NO-LOCK
            WHERE unid-feder.pais   = ttConsStatServ_ENV.pais
              AND unid-feder.estado = ttConsStatServ_ENV.UF:
        END.

        IF  NOT AVAIL unid-feder THEN
            RETURN "OK":U.

        IF  NOT AVAIL estabelec
        OR (AVAIL estabelec
        AND estabelec.cod-estabel <> ttConsStatServ_ENV.CodEstabel) THEN
            FOR FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = ttConsStatServ_ENV.CodEstabel: 
            END.
        
        ASSIGN cVersaoLayoutNFe = &if "{&bf_dis_versao_ems}" >= "2.071" &then 
                                     estabelec.des-vers-layout
                                  &else 
                                     TRIM(SUBSTRING(estabelec.char-1,173,10))
                                  &endif WHEN AVAIL estabelec NO-ERROR.

        ASSIGN ttConsStatServ_ENV.versao     = (IF cVersaoLayoutNFe = "1.10":U THEN "1.07":U
                                                                               ELSE cVersaoLayoutNFe)
               ttConsStatServ_ENV.cUF        = STRING(IF  ttConsStatServ_ENV.pais = "Brasil":U
                                                      THEN (&if '{&bf_dis_versao_ems}' >= '2.07':U
                                                            &then IF AVAIL unid-feder THEN STRING(unid-feder.cod-uf-ibge)           ELSE ?
                                                            &else IF AVAIL unid-feder THEN STRING(SUBSTRING(unid-feder.char-1,1,2)) ELSE ? &endif)
                                                      ELSE "99":U)
               ttConsStatServ_ENV.xServ      = "STATUS":U.

        IF  ttConsStatServ_ENV.cUF = ? THEN RETURN "OK":U.
        
    END.

    RUN cdp/cd0360b.p (INPUT ttConsStatServ_ENV.CodEstabel,
                       INPUT "NF-e":U,
                       OUTPUT cTpTrans).

    IF  LOOKUP(cTpTrans, "TSS,TC":U) > 0 THEN
        RUN pi-Busca-Status-SEFAZ-TSS-Sincrono.
    ELSE
        RUN PIUpsert ( INPUT  pTranAction         , /* add / upd */
                       INPUT  pTranEvent          , /* Evento    */
                       INPUT  TABLE ttConsStatServ_ENV,
                       OUTPUT TABLE ttConsStatServ_RET,
                       OUTPUT TABLE tt_log_erro).

   EMPTY TEMP-TABLE ttConsStatServ_ENV.



/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

PROCEDURE pi-Busca-Status-SEFAZ-TSS-Sincrono:
    
    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE lBuscaStatusSEFAZOK  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cStatusSEFAZ         AS CHARACTER   NO-UNDO.
    
    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunica»’o com o TSS*/
    END.
    
    FIND FIRST ttConsStatServ_ENV NO-LOCK NO-ERROR.

    IF NOT AVAIL param-nf-estab OR param-nf-estab.cod-estabel <> ttConsStatServ_ENV.CodEstabel THEN
        FOR FIRST param-nf-estab NO-LOCK
            WHERE param-nf-estab.cod-estabel = ttConsStatServ_ENV.CodEstabel: END.
    
    IF  NOT AVAIL param-nf-estab THEN
        RETURN "NOK":U.

    RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                 TRIM(param-nf-estab.cod-url-ws-tss)
                               &else
                                 TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                               &endif).
                                     
    RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                     INPUT "*",
                                     INPUT param-nf-estab.cod-estabel,
                                     INPUT param-nf-estab.cod-url-ws-tss).
                             
    RUN NFESBRA_MONITORSEFAZ IN h-TSSAPI (INPUT  param-nf-estab.ind-empresa, 
                                          OUTPUT cStatusSEFAZ).

    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("NFESBRA":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS MONITORSEFAZ]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS MONITORSEFAZ]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE ttConsStatServ_RET.
      
        CREATE ttConsStatServ_RET.
        ASSIGN ttConsStatServ_RET.CodEstabel = ttConsStatServ_ENV.CodEstabel
               ttConsStatServ_RET.UF         = ttConsStatServ_ENV.UF
               ttConsStatServ_RET.tpAmb      = "":U
               ttConsStatServ_RET.verAplic   = "":U
               ttConsStatServ_RET.cStat      = "":U
               ttConsStatServ_RET.xMotivo    = cStatusSEFAZ
               ttConsStatServ_RET.cUF        = "":U
               ttConsStatServ_RET.dhRecbto   = "":U
               ttConsStatServ_RET.tMed       = "":U
               ttConsStatServ_RET.dhRetorno  = "":U
               ttConsStatServ_RET.xObs       = "":U .
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF
       
END PROCEDURE.


