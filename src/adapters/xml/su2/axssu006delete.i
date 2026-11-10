PROCEDURE PITransDelete:

    /*PARAMETERS - BEGIN*/
    DEF INPUT  PARAM pr-rowid AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/


    /*LOCAL VARIABLES - BEGIN*/
    /*LOCAL VARIABLES - END*/


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */    
    FIND FIRST item-fornec NO-LOCK
         WHERE ROWID(item-fornec) = pr-rowid NO-ERROR.
    IF AVAIL item-fornec THEN DO:
        
        FOR FIRST emitente FIELDS (nome-emit cgc)
            WHERE emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK. END.

        FOR FIRST item FIELDS (desc-item)
            WHERE item.it-codigo = item-fornec.it-codigo NO-LOCK. END.
    
        CREATE ttVendorItem.
        ASSIGN ttVendorItem.VendorNumber                    = item-fornec.cod-emitente
               ttVendorItem.VendorName                      = IF AVAIL emitente THEN emitente.nome-emit ELSE "" 
               ttVendorItem.VendorTaxID                     = IF AVAIL emitente THEN emitente.cgc       ELSE ""
               ttVendorItem.ItemCode                        = item-fornec.it-codigo             
               ttVendorItem.ItemDescription                 = IF AVAIL item THEN item.desc-item ELSE ""
               ttVendorItem.ReferenceCode                   = item-fornec.cd-referencia.
    END.
    
    RUN PIDelete(INPUT "",
                 INPUT "del",
                 INPUT  TABLE ttVendorItem,
                 OUTPUT TABLE tt_log_erro).
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



