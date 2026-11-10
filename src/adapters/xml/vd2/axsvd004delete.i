PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM pPriceTableRowID  AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

FIND FIRST tb-preco WHERE ROWID(tb-preco) = pPriceTableRowID NO-LOCK NO-ERROR.

IF AVAIL tb-preco THEN DO:

    RUN PIDelete ( INPUT "",                       /* Event */
	               INPUT "del":U,                  /* TranAction */
		           INPUT tb-preco.descricao,	   /* PriceTableDescription	*/
		           INPUT tb-preco.nr-tabpre, 	   /* PriceTableNumber 	*/
                   OUTPUT TABLE tt_log_erro ).     /* Mensagens de Erro */

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.







