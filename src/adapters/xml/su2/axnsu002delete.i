PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM rw-ordem-compra AS ROWID .
DEF INPUT PARAM p-acao          AS CHAR  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

FIND FIRST ordem-compra 
    WHERE ROWID(ordem-compra) = rw-ordem-compra NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:

    ASSIGN cEvent          = ""
           cTranAction     = p-acao /* del */
           PONumber        = ordem-compra.num-pedido WHEN ordem-compra.num-pedido <> 0
           POLineNumber_00 = ordem-compra.numero-ordem 
           VendorNumber_00 = ordem-compra.cod-emitente .

       FOR FIRST emitente FIELDS (nome-emit cgc)
           WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: 

           ASSIGN VendorName_00   = emitente.nome-emit 
                  VendorTaxID_00  = emitente.cgc      .
       END.
              
    RUN PIDelete (INPUT cEvent,
                  INPUT cTranAction,
                  INPUT PONumber,
                  INPUT POLineNumber_00,
                  INPUT VendorNumber_00, 
                  INPUT VendorName_00, 
                  INPUT VendorTaxID_00, 
                  OUTPUT TABLE tt_log_erro ).

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



