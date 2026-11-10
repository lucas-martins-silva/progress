PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM r-rowid  AS ROWID.
DEF INPUT PARAM pcAction AS CHAR.  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

EMPTY TEMP-TABLE tt_log_erro.
EMPTY TEMP-TABLE ttDeliveryScheduling.
EMPTY TEMP-TABLE ttItensDeliveryScheduling.
EMPTY TEMP-TABLE ttScheduleItemDelivery.

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FIND FIRST prog-for 
    WHERE ROWID(prog-for) = r-rowid NO-LOCK NO-ERROR.

IF AVAIL prog-for THEN DO:

  FOR FIRST emitente FIELDS(nome-abrev nome-emit cgc)  WHERE
            emitente.cod-emitente = prog-for.cod-emitente NO-LOCK: END.

  CREATE ttDeliveryScheduling.
  ASSIGN ttDeliveryScheduling.DSNumber             = prog-for.nr-programa
         ttDeliveryScheduling.CheckSum             = prog-for.check-sum
         ttDeliveryScheduling.VendorNumber	       = prog-for.cod-emitente
         ttDeliveryScheduling.VendorShortName      = emitente.nome-abrev WHEN AVAIL emitente
         ttDeliveryScheduling.VendorName	       = emitente.nome-emit  WHEN AVAIL emitente
         ttDeliveryScheduling.VendorTaxId          = emitente.cgc        WHEN AVAIL emitente
         ttDeliveryScheduling.GenerationDate       = prog-for.dt-geracao
         ttDeliveryScheduling.GenEdiProcess	       = prog-for.gera-edi
         ttDeliveryScheduling.ReceiptSource	       = prog-for.ind-orig-entrada
         ttDeliveryScheduling.DispatchSending      = prog-for.ind-via-envio
         ttDeliveryScheduling.ProcessEdiNumber     = prog-for.nr-processo-edi
         ttDeliveryScheduling.ProcessReceiptNumber = prog-for.nro-proc-entrada
         ttDeliveryScheduling.ProcessIssueNumber   = prog-for.nro-proc-saida
         ttDeliveryScheduling.iStatus	           = prog-for.situacao.

   /* Itens da programa‡Æo de entrega */
   FOR EACH it-prog-for WHERE 
            it-prog-for.nr-programa = prog-for.nr-programa NO-LOCK:

       FOR FIRST estabelec FIELDS(endereco cidade bairro estado cep pais)
           WHERE estabelec.cod-estab = it-prog-for.end-entrega NO-LOCK: END.

       FOR FIRST item FIELDS(desc-item)
           WHERE item.it-codigo = it-prog-for.it-codigo NO-LOCK: END.
       
       FOR FIRST tab-unidade FIELDS(descricao)
           WHERE tab-unidade.un = it-prog-for.un NO-LOCK: END.
       
       CREATE ttItensDeliveryScheduling.
       ASSIGN ttItensDeliveryScheduling.DSNumber	               = it-prog-for.nr-programa
              ttItensDeliveryScheduling.CheckSum	               = it-prog-for.check-sum
              ttItensDeliveryScheduling.ItemReferenceCode          = it-prog-for.cod-refer
              ttItensDeliveryScheduling.ItemStatus                 = it-prog-for.cod-sit-item
              ttItensDeliveryScheduling.DeliverySuplement          = it-prog-for.compl-entrega
              ttItensDeliveryScheduling.PrintDate                  = it-prog-for.dt-emissao
              ttItensDeliveryScheduling.PreviousGenDate            = it-prog-for.dt-ger-ant
              ttItensDeliveryScheduling.MaterialReleaseDate        = it-prog-for.dt-lib-mat
              ttItensDeliveryScheduling.ProductionReleaseDate      = it-prog-for.dt-lib-prod
              ttItensDeliveryScheduling.LastDeliveryDate           = it-prog-for.dt-ult-ent
              ttItensDeliveryScheduling.DeliverySiteId             = it-prog-for.end-entrega
              ttItensDeliveryScheduling.DeliveryAddress            = estabelec.endereco    WHEN AVAIL estabelec
              ttItensDeliveryScheduling.DeliveryCityName           = estabelec.cidade      WHEN AVAIL estabelec
              ttItensDeliveryScheduling.DeliveryDistrictName       = estabelec.bairro      WHEN AVAIL estabelec
              ttItensDeliveryScheduling.DeliveryStateCode          = estabelec.estado      WHEN AVAIL estabelec
              ttItensDeliveryScheduling.DeliveryNationalPostalCode = estabelec.cep         WHEN AVAIL estabelec
              ttItensDeliveryScheduling.DeliveryCountryCode        = estabelec.pais        WHEN AVAIL estabelec
              ttItensDeliveryScheduling.ItemCode                   = it-prog-for.it-codigo
              ttItensDeliveryScheduling.ItemDescription            = item.desc-item        WHEN AVAIL item
              ttItensDeliveryScheduling.SupplyContractNumber       = it-prog-for.nr-contrato
              ttItensDeliveryScheduling.DeliveryPreviousNumber     = it-prog-for.nr-prog-ant
              ttItensDeliveryScheduling.DocumentNumber             = it-prog-for.nro-docto
              ttItensDeliveryScheduling.QuantityAccumDelivery      = it-prog-for.qt-ent-acum
              ttItensDeliveryScheduling.QuantityAccumNeed          = it-prog-for.qt-nec-acum
              ttItensDeliveryScheduling.QuantityLastReceipt        = it-prog-for.qtidade-ent
              ttItensDeliveryScheduling.DocumentSeries             = it-prog-for.serie-docto
              ttItensDeliveryScheduling.UnitOfMeasureCode          = it-prog-for.un
              ttItensDeliveryScheduling.UnitOfMeasureDescription   = tab-unidade.descricao WHEN AVAIL tab-unidade.

       /* Prazos de Entrega */
       FOR EACH prazo-it-prog OF it-prog-for NO-LOCK:

           CREATE ttScheduleItemDelivery.
           ASSIGN ttScheduleItemDelivery.DSNumber	                   = prazo-it-prog.nr-programa
                  ttScheduleItemDelivery.ItemCode	                   = prazo-it-prog.it-codigo
                  ttScheduleItemDelivery.ItemReferenceCode	           = prazo-it-prog.cod-refer
                  ttScheduleItemDelivery.DeliverySiteId                = prazo-it-prog.end-entrega
                  ttScheduleItemDelivery.SupplyContractNumber	       = prazo-it-prog.nr-contrato
                  ttScheduleItemDelivery.CheckSum                      = prazo-it-prog.check-sum
                  ttScheduleItemDelivery.DeliveryDate	               = prazo-it-prog.dt-entrega
                  ttScheduleItemDelivery.DeliveryTime	               = prazo-it-prog.hora-entrega
                  ttScheduleItemDelivery.PurchaseRequisitionNumber     = prazo-it-prog.numero-ordem
                  ttScheduleItemDelivery.PurchaseRequisitionScheduleID = prazo-it-prog.parcela
                  ttScheduleItemDelivery.QuantityDelivery              = prazo-it-prog.quantidade.
       END.

   END.

END.

IF CAN-FIND(FIRST ttDeliveryScheduling) THEN
   RUN PIUpsert (INPUT "",
                 INPUT "upd":U,
                 INPUT TABLE ttDeliveryScheduling,
                 INPUT TABLE ttItensDeliveryScheduling,
                 INPUT TABLE ttScheduleItemDelivery,
                 OUTPUT TABLE tt_log_erro).

    
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



