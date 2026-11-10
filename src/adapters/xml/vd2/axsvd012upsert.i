PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM r-rowid  AS ROWID.
DEF INPUT PARAM pcAction AS CHAR.  
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
   ASSIGN ttCustomerItem.CustomerNumber	            = item-cli.cod-emitente
          ttCustomerItem.CustomerShortName	        = item-cli.nome-abrev
          ttCustomerItem.CustomerName	            = emitente.nome-emit WHEN AVAIL emitente
          ttCustomerItem.CustomerTaxId	            = emitente.cgc       WHEN AVAIL emitente
          ttCustomerItem.CheckSum	                = item-cli.check-sum
          ttCustomerItem.GreatestValueDate	        = item-cli.dt-mai-coml
          ttCustomerItem.LastPurchaseDate	        = item-cli.dt-ult-com
          ttCustomerItem.ConvFactor	                = item-cli.fat-conver
          ttCustomerItem.ConvFactor00               = item-cli.fator-conversao
          ttCustomerItem.iStatus	                = item-cli.ind-sit-relac
          ttCustomerItem.ItemCode                   = item-cli.it-codigo
          ttCustomerItem.ItemDescription	        = item.desc-item     WHEN AVAIL item
          ttCustomerItem.CustomerItem	            = item-cli.item-do-cli
          ttCustomerItem.IsReportPrint              = item-cli.laudo-no-fat
          ttCustomerItem.PreferredUnitMeasure	    = item-cli.log-unid-prefer
          ttCustomerItem.SalesMultipleLot           = item-cli.lote-mulven
          ttCustomerItem.cText                      = item-cli.narrativa
          ttCustomerItem.WarrantyTermDays           = item-cli.nr-dias-gar
          ttCustomerItem.DecimalQuantity            = item-cli.num-casa-dec
          ttCustomerItem.MinPercentPartialInvoicing = item-cli.per-minfat
          ttCustomerItem.QuantityOfLargerPurchase   = item-cli.qt-mai-com
          ttCustomerItem.QuantityLastPurchase       = item-cli.qt-ult-com
          ttCustomerItem.QuantityShelfDays          = item-cli.qtd-dias-prateleira
          ttCustomerItem.QuantityCarriageDays       = item-cli.qtd-dias-transporte
          ttCustomerItem.PoliticLotAdministration   = item-cli.tp-adm-lote
          ttCustomerItem.TypeAllotmentLot           = item-cli.tp-aloc-lote
          ttCustomerItem.TypeInspect	            = item-cli.tp-inspecao
          ttCustomerItem.TypeCurrent	            = item-cli.tp-moeda
          ttCustomerItem.ClientMeasureUnit          = item-cli.unid-med-cli
          ttCustomerItem.GreaterCommercialAmt       = item-cli.vl-mai-coml
          ttCustomerItem.AmountOverPurchase         = item-cli.vl-maior-com
          ttCustomerItem.ConsumerPrice              = item-cli.vl-precon
          ttCustomerItem.LastPurchaseValue	        = item-cli.vl-ult-com
          .
             

END.

IF CAN-FIND(FIRST ttCustomerItem) THEN
   RUN PIUpsert (INPUT "":U,
                 INPUT pcAction,               
                 INPUT TABLE ttCustomerItem,  
                 OUTPUT TABLE tt_log_erro ). 

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



