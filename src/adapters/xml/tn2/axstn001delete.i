PROCEDURE PIUserDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM UserID_00 AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

    FIND FIRST usuar_mestre WHERE ROWID(usuar_mestre) = UserID_00 NO-LOCK.

        IF AVAIL usuar_mestre THEN DO:
      
            RUN PIDelete
            (
                 INPUT "":U,
                 INPUT "del":U,
                 OUTPUT TABLE tt_log_erro,
                 INPUT usuar_mestre.cod_usuario
             ).
            RETURN RETURN-VALUE.
        END.
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



