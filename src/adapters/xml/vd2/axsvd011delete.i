PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
    DEF INPUT  PARAM pSiteRowID AS ROWID NO-UNDO.  
    DEF OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

    FOR FIRST estabelec FIELDS (nome cod-estabel) WHERE ROWID(estabelec) = pSiteRowID NO-LOCK. END.
    IF AVAIL estabelec THEN
        RUN PIDelete (INPUT ""  	              ,
                	  INPUT "del"                 ,
                	  INPUT estabelec.nome        ,
                	  INPUT estabelec.cod-estabel ,
                	  OUTPUT TABLE tt_log_erro).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.
