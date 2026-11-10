PROCEDURE PITransUpsert:


    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM cTranAction   AS CHAR  NO-UNDO.
    DEFINE INPUT PARAM r-saldo-estoq AS ROWID NO-UNDO.
    DEFINE INPUT PARAM dt-vali-atual AS DATE  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
     FIND FIRST saldo-estoq NO-LOCK
          WHERE ROWID(saldo-estoq) = r-saldo-estoq NO-ERROR.
     IF AVAIL saldo-estoq THEN DO:
         
         CREATE tt-alt-lote. 
         ASSIGN tt-alt-lote.it-codigo    = saldo-estoq.it-codigo
                tt-alt-lote.lote         = saldo-estoq.lote
                tt-alt-lote.dt-vali-old  = saldo-estoq.dt-vali-lote
                tt-alt-lote.dt-vali-lote = dt-vali-atual.    

     END.
             
     RUN PIUpsert ( INPUT "",
                    INPUT cTranAction,
                    INPUT TABLE tt-alt-lote,
                    OUTPUT TABLE tt_log_erro).
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



