PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM p-class-fiscal LIKE classif-fisc.class-fiscal NO-UNDO  .  
DEF INPUT PARAM p-descricao    LIKE classif-fisc.descricao    NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

    RUN PIDelete ( INPUT "del":U, 
                   INPUT p-class-fiscal,
                   INPUT p-descricao,
                   OUTPUT TABLE tt_log_erro ).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


