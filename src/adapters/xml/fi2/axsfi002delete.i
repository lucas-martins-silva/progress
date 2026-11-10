PROCEDURE PITransDelete:
/*PARAMETERS - BEGIN*/
DEF INPUT PARAM p-cod-moeda AS INT NO-UNDO.
DEF INPUT PARAM p-des-moeda AS CHAR NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
CREATE ttCurrency_00.
ASSIGN ttCurrency_00.CODE = p-cod-moeda
       ttCurrency_00.DESCRIPTION = p-des-moeda
       ttCurrency_00.ttCurrency_00ID = 0.

FOR EACH tt_log_erro:
    DELETE tt_log_erro.
END.
RUN PIDelete (INPUT '',
              INPUT 'del',
              OUTPUT TABLE tt_log_erro,
              INPUT TABLE ttCurrency_00).

FOR EACH ttCurrency_00.
    DELETE ttCurrency_00.
END.


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



