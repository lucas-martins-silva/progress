PROCEDURE PITransDelete:
    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAMETER pEmbarqueRowID AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
    /*LOCAL VARIABLES - BEGIN*/
    /*LOCAL VARIABLES - END*/
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    FIND FIRST embarque
         WHERE rowid(embarque) = pEmbarqueRowID NO-LOCK NO-ERROR.
    IF AVAIL embarque THEN DO:
        RUN PIDelete ( INPUT "del":U,
                       INPUT embarque.cdd-embarq,
                       OUTPUT TABLE tt_log_erro ).
    END.
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



