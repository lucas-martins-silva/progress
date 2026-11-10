PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAMETER pPriceTableItemRowID AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

FIND FIRST preco-item
  WHERE ROWID(preco-item) = pPriceTableItemRowID NO-LOCK NO-ERROR.

IF AVAIL preco-item THEN DO:

    FOR FIRST tb-preco FIELDS(descricao) NO-LOCK 
        WHERE tb-preco.nr-tabpre = preco-item.nr-tabpre: END.

    FOR FIRST ITEM FIELDS(desc-item) NO-LOCK 
        WHERE ITEM.it-codigo = preco-item.it-codigo: END.
    
    RUN PIDelete (  INPUT "del":U, 		       
                    INPUT preco-item.cod-refer, 
                    INPUT preco-item.nr-tabpre, 
                    INPUT tb-preco.descricao,   
                    INPUT preco-item.it-codigo,     
                    INPUT preco-item.dt-inival,	   
                    INPUT ITEM.desc-item,
                    INPUT preco-item.quant-min, 	   
                    OUTPUT TABLE tt_log_erro ). 	   
        
END.
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

