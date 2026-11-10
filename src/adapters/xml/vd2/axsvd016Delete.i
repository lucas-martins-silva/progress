PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pEmbalagRowID AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FIND FIRST embalag
     WHERE rowid(embalag) = pEmbalagRowID NO-LOCK NO-ERROR.
IF AVAIL embalag THEN DO:
    RUN PIDelete ( INPUT "del":U,
                   INPUT embalag.embalagem,
                   INPUT embalag.descricao,
                   OUTPUT TABLE tt_log_erro ).
END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.






