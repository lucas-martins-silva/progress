PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT PARAM pTranAction        AS CHAR  NO-UNDO . /* add/upd */
DEF INPUT PARAM pFiscalClassRowID  AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro        NO-ERROR.
EMPTY TEMP-TABLE tt-classif-fisc    NO-ERROR.

FOR FIRST classif-fisc WHERE 
    ROWID(classif-fisc) = pFiscalClassRowID NO-LOCK: END.

IF AVAIL classif-fisc THEN DO:

  CREATE tt-classif-fisc.
  BUFFER-COPY classif-fisc TO tt-classif-fisc.
  
        RUN PIUpsert ( INPUT pTranAction,                /* add / upd               */
                       INPUT  TABLE tt-classif-fisc,     /* Dados da class fiscal   */
                       OUTPUT TABLE tt_log_erro ).
END.

END PROCEDURE.

