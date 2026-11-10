PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
    DEF INPUT PARAM pTranAction        AS CHAR  NO-UNDO. /* add/upd */
    DEF INPUT PARAM pSiteRowID         AS ROWID NO-UNDO.  
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
    EMPTY TEMP-TABLE tt_log_erro        NO-ERROR.
    EMPTY TEMP-TABLE tt-estabelec       NO-ERROR.
    
    FOR FIRST estabelec WHERE 
        ROWID(estabelec) = pSiteRowID NO-LOCK: END.

    IF AVAIL estabelec THEN DO:
        CREATE tt-estabelec.
        BUFFER-COPY estabelec TO tt-estabelec.
  
        FOR FIRST emitente FIELDS (ins-estadual) WHERE
            emitente.cod-emitente = estabelec.cod-emitente NO-LOCK: END.

        RUN PIUpsert ( INPUT "",
                       INPUT pTranAction,                
                       INPUT TABLE tt-estabelec,        
                       INPUT if avail emitente then emitente.ins-estadual else "",
                       OUTPUT TABLE tt_log_erro ).
    END.


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



