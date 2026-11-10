PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM  p-cod-transp LIKE transporte.cod-transp NO-UNDO.
DEF INPUT PARAM  p-nome-abrev LIKE transporte.nome-abrev NO-UNDO.   
DEF INPUT PARAM  p-nome       LIKE transporte.nome       NO-UNDO.         
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

         RUN PIDelete (INPUT "del":U,
                       INPUT p-cod-transp,
                       INPUT p-nome-abrev,
                       INPUT p-nome,
                       OUTPUT TABLE tt_log_erro).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.
