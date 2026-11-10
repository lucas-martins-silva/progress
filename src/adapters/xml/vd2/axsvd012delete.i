PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM r-rowid  AS ROWID.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

EMPTY TEMP-TABLE tt_log_erro.
EMPTY TEMP-TABLE ttCustomerItem.


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FIND FIRST item-cli 
    WHERE ROWID(item-cli) = r-rowid NO-LOCK NO-ERROR.

IF AVAIL item-cli THEN DO:

   FOR FIRST emitente FIELDS(cgc nome-emit)  WHERE
             emitente.cod-emitente = item-cli.cod-emitente NO-LOCK: END.

   FOR FIRST item FIELDS(desc-item)
       WHERE item.it-codigo = item-cli.it-codigo NO-LOCK: END.


   CREATE ttCustomerItem.
   ASSIGN ttCustomerItem.CustomerNumber	   = item-cli.cod-emitente
          ttCustomerItem.CustomerShortName = item-cli.nome-abrev
          ttCustomerItem.CustomerName	   = emitente.nome-emit WHEN AVAIL emitente
          ttCustomerItem.CustomerTaxId	   = emitente.cgc       WHEN AVAIL emitente
          ttCustomerItem.ItemCode          = item-cli.it-codigo
          ttCustomerItem.ItemDescription   = item.desc-item     WHEN AVAIL item
          ttCustomerItem.ClientMeasureUnit = item-cli.unid-med-cli
          .
             

END.

IF CAN-FIND(FIRST ttCustomerItem) THEN
   RUN PIDelete (INPUT "":U,
                 INPUT "del":U,               
                 INPUT TABLE ttCustomerItem,  
                 OUTPUT TABLE tt_log_erro ).  

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



