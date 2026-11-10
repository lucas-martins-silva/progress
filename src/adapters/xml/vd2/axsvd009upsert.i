PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT  PARAM pTranAction          AS CHAR  NO-UNDO. /* add/upd */
DEF INPUT  PARAM pRepresentativeRowid AS ROWID NO-UNDO.  
DEF OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
EMPTY TEMP-TABLE tt-repres   NO-ERROR.

FIND FIRST repres WHERE
    ROWID(repres) = pRepresentativeRowid NO-LOCK NO-ERROR.

IF AVAIL repres THEN DO:

    CREATE tt-repres.
    BUFFER-COPY repres TO tt-repres.

    RUN PIUpsert (INPUT  pTranAction,     /* add / upd             */
                  INPUT  TABLE tt-repres, /* Dados do Representante */
                  OUTPUT TABLE tt_log_erro ).
END.

END PROCEDURE.

