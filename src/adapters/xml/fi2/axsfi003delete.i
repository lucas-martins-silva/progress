PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM p-cod-moeda AS integer INITIAL ? NO-UNDO.  /*Código da Moeda da cotação (Uso Interno: emsuni.moeda.mo-codigo)*/
DEFINE INPUT PARAM p-ano-periodo AS CHAR INITIAL ? NO-UNDO.  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
DEF VAR i-ano AS INT NO-UNDO.
DEF VAR i-mes AS INT NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
ASSIGN i-ano = int(SUBSTR(p-ano-periodo, 1, 4))
       i-mes = int(SUBSTR(p-ano-periodo, 6, 2)).

FOR EACH tt_log_erro:
    DELETE tt_log_erro.
END.
RUN PIDelete (INPUT '',
              INPUT 'del',
              INPUT p-cod-moeda,
              INPUT i-mes,
              OUTPUT TABLE tt_log_erro,
              INPUT i-ano).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



