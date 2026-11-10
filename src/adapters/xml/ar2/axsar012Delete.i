PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM pCodEstabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pItCodigo   LIKE movto-estoq.it-codigo   NO-UNDO.
    DEFINE INPUT PARAM pLote       LIKE movto-estoq.lote        NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/

/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */


     RUN PIDelete
     (
          INPUT "ItemLote",
          INPUT "del",
          INPUT pItCodigo,
          INPUT pLote,
          INPUT pCodEstabel,
          OUTPUT TABLE tt_log_erro
      ).


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



