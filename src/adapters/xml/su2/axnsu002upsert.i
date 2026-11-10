PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT  PARAM TABLE FOR tt-ordem-compra.
DEF INPUT  PARAM i-ordem-externa AS INTEGER.  
DEF INPUT  PARAM p-acao          AS CHARACTER.  
DEF OUTPUT PARAM TABLE FOR tt_log_erro.
  
/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro            NO-ERROR.
EMPTY TEMP-TABLE ttPurchaseOrderLine_00 NO-ERROR.
EMPTY TEMP-TABLE ttDeliveryScheduleInforma_00 NO-ERROR.

FOR FIRST tt-ordem-compra NO-LOCK:
    FIND FIRST ordem-compra 
        WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
END.

IF AVAIL ordem-compra THEN DO:

  CREATE ttPurchaseOrderLine_00.

  FOR FIRST ITEM FIELDS (desc-item)
      WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

  FOR FIRST cond-pagto FIELDS (descricao)
      WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK: END.

  FOR FIRST moeda FIELDS (descricao sigla)
      WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-LOCK: END.

  FOR FIRST emitente FIELDS (cgc e-mail nome-abrev nome-emit telefone[1])
      WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.

  ASSIGN cEvent       = ""       
         cTranAction  = p-acao   /* add / upd  */
  
         ttPurchaseOrderLine_00.POLineNumber = ordem-compra.numero-ordem WHEN ordem-compra.numero-ordem <> 0

         ttPurchaseOrderLine_00.ItemCode                         = ordem-compra.it-codigo  
         ttPurchaseOrderLine_00.ItemDescription                  = ITEM.desc-item WHEN AVAIL ITEM
         ttPurchaseOrderLine_00.ItemReferenceCode                = ordem-compra.cod-refer 
         ttPurchaseOrderLine_00.PurchaseProcessNumber            = ordem-compra.nr-processo  
         ttPurchaseOrderLine_00.IssueDate                        = ordem-compra.data-emissao   
         ttPurchaseOrderLine_00.QuantityRequested                = ordem-compra.qt-solic
         ttPurchaseOrderLine_00.AccumulatedNecessityQuantity     = ordem-compra.qt-acum-nec
         ttPurchaseOrderLine_00.AccumulatedReceivedQuantity      = ordem-compra.qt-acum-rec
         ttPurchaseOrderLine_00.AccumulatedReturnedQuantity      = ordem-compra.qt-acum-dev
         ttPurchaseOrderLine_00.ApprovalPriority                 = ordem-compra.prioridade-aprov
         ttPurchaseOrderLine_00.iStatus                          = ordem-compra.situacao
         ttPurchaseOrderLine_00.POLineIssued                     = ordem-compra.ordem-emitida
         ttPurchaseOrderLine_00.IsPurchaseExpectation            = ordem-compra.expectativa  
         ttPurchaseOrderLine_00.Requisitioner                    = ordem-compra.requisitante WHEN ordem-compra.requisitante <> ""
         ttPurchaseOrderLine_00.ProjectControlOrderNumber        = ordem-compra.num-ord-inv
         ttPurchaseOrderLine_00.iType                            = ordem-compra.natureza
         ttPurchaseOrderLine_00.iSource                          = ordem-compra.origem
         ttPurchaseOrderLine_00.PrintQuotationRecord             = ordem-compra.impr-ficha  
         ttPurchaseOrderLine_00.WorkOrder                        = ordem-compra.ordem-servic
         ttPurchaseOrderLine_00.OperationCode                    = ordem-compra.op-codigo   WHEN ordem-compra.op-codigo   <> 0
         ttPurchaseOrderLine_00.Comments                         = ordem-compra.narrativa   WHEN ordem-compra.narrativa   <> ""
         ttPurchaseOrderLine_00.Comments2                        = ordem-compra.comentarios WHEN ordem-compra.comentarios <> ""
         ttPurchaseOrderLine_00.VendorNumber                     = ordem-compra.cod-emitente
         ttPurchaseOrderLine_00.VendorTaxID                      = emitente.cgc        WHEN AVAIL emitente 
         ttPurchaseOrderLine_00.VendorShortName                  = emitente.nome-abrev WHEN AVAIL emitente 
         ttPurchaseOrderLine_00.VendorName                       = emitente.nome-emit  WHEN AVAIL emitente 
         ttPurchaseOrderLine_00.QuotationDate                    = ordem-compra.data-cotacao 
         ttPurchaseOrderLine_00.OriginalPrice                    = ordem-compra.preco-orig
         ttPurchaseOrderLine_00.NetUnitaryPrice                  = ordem-compra.preco-unit
         ttPurchaseOrderLine_00.VendorUnitaryPrice               = ordem-compra.pre-unit-for
         ttPurchaseOrderLine_00.VendorPrice                      = ordem-compra.preco-fornec
         ttPurchaseOrderLine_00.CurrencyID                       = ordem-compra.mo-codigo
         ttPurchaseOrderLine_00.CurrencyDescription              = moeda.descricao WHEN AVAIL moeda
         ttPurchaseOrderLine_00.CurrencySign                     = moeda.sigla     WHEN AVAIL moeda
         ttPurchaseOrderLine_00.IsIndustrializedProductTaxInc_00 = ordem-compra.codigo-ipi  
         ttPurchaseOrderLine_00.IndustrializedProductTaxPerc     = ordem-compra.aliquota-ipi
         ttPurchaseOrderLine_00.SalesTaxPercentage               = ordem-compra.aliquota-icm
         ttPurchaseOrderLine_00.ServiceTaxPercentage             = ordem-compra.aliquota-iss
         ttPurchaseOrderLine_00.ServicesAndProductsCirculatio_00 = ordem-compra.codigo-icm
         ttPurchaseOrderLine_00.IsFreightIncluded                = ordem-compra.frete
         ttPurchaseOrderLine_00.FreightValue                     = ordem-compra.valor-frete
         ttPurchaseOrderLine_00.IsFinancialRateIncluded          = ordem-compra.taxa-financ
         ttPurchaseOrderLine_00.FinancialRatePercentage          = ordem-compra.valor-taxa
         ttPurchaseOrderLine_00.FinancialRateDays                = ordem-compra.nr-dias-taxa
         ttPurchaseOrderLine_00.PaymentPlanCode                  = ordem-compra.cod-cond-pag
         ttPurchaseOrderLine_00.PaymentPlanDescription           = cond-pagto.descricao WHEN AVAIL cond-pagto
         ttPurchaseOrderLine_00.DeliveryTerm                     = ordem-compra.prazo-entreg
         ttPurchaseOrderLine_00.ContactName                      = ordem-compra.contato
         ttPurchaseOrderLine_00.PhoneNumber                      = emitente.telefone[1] WHEN AVAIL emitente
         ttPurchaseOrderLine_00.EmailAddress                     = emitente.e-mail      WHEN AVAIL emitente
         ttPurchaseOrderLine_00.UpdateDate                       = ordem-compra.data-atualiz
         ttPurchaseOrderLine_00.UpdateTime                       = ordem-compra.hora-atualiz
         ttPurchaseOrderLine_00.SourcePOLine                     = ordem-compra.nr-ord-orig
         ttPurchaseOrderLine_00.DiscountPercentage               = ordem-compra.perc-descto
         ttPurchaseOrderLine_00.DiscountAmount                   = ordem-compra.valor-descto
         ttPurchaseOrderLine_00.IsMasterProductionPlanConsidered = ordem-compra.cons-pmp
         ttPurchaseOrderLine_00.IsMRPconsidered                  = ordem-compra.cons-mrp
         ttPurchaseOrderLine_00.CompanyID                        = ordem-compra.ep-codigo
         ttPurchaseOrderLine_00.EventSequence                    = ordem-compra.seq-evento
         ttPurchaseOrderLine_00.POLinePendingApprovalCode        = ordem-compra.pend-aprov
         ttPurchaseOrderLine_00.ImportLicenseNumber              = ordem-compra.licenca-import WHEN ordem-compra.licenca-import <> "".

         IF ordem-compra.num-pedido <> 0 THEN
          ASSIGN ttPurchaseOrderLine_00.PONumber    = ordem-compra.num-pedido
                 ttPurchaseOrderLine_00.PODate      = ordem-compra.data-pedido.    
         
         IF ordem-compra.nr-contrato <> 0  THEN
          ASSIGN ttPurchaseOrderLine_00.SupplyContractNumber             = ordem-compra.nr-contrato
                 ttPurchaseOrderLine_00.SupplyContractSequenceNumber     = ordem-compra.num-seq-item
                 ttPurchaseOrderLine_00.SupplyContractPOLineRelations_00 = ordem-compra.dat-ordem  
                 ttPurchaseOrderLine_00.SupplyContractPOLineStatus       = ordem-compra.sit-ordem-contrat.

         IF ordem-compra.nr-requisicao <> 0 THEN
          ASSIGN ttPurchaseOrderLine_00.RequisitionNumber                = ordem-compra.nr-requisicao
                 ttPurchaseOrderLine_00.RequisitionLineSequence          = ordem-compra.sequencia .

         FOR FIRST ITEM FIELDS (desc-item)
             WHERE ITEM.it-codigo = ordem-compra.item-pai NO-LOCK: END.
          ASSIGN ttPurchaseOrderLine_00.ParentItemCode         = ordem-compra.item-pai   
                 ttPurchaseOrderLine_00.ParentItemDescription  = ITEM.desc-item WHEN AVAIL ITEM.

         IF ordem-compra.cod-comprado <> "" THEN DO:
            FOR FIRST comprador FIELDS (nome)
                WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-LOCK: END.

            ASSIGN ttPurchaseOrderLine_00.BuyerID   = ordem-compra.cod-comprado
                   ttPurchaseOrderLine_00.BuyerName = comprador.nome WHEN AVAIL comprador.    
         END.

         IF ordem-compra.cod-estabel <> "" THEN DO:
            FOR FIRST estabelec FIELDS (nome)
                WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
          
            ASSIGN ttPurchaseOrderLine_00.SiteID          = ordem-compra.cod-estabel   
                   ttPurchaseOrderLine_00.SiteDescription = estabelec.nome WHEN AVAIL estabelec.
         END.
         
         IF ordem-compra.cod-estab-gestor <> "" THEN DO:
            FOR FIRST estabelec FIELDS (nome)
                WHERE estabelec.cod-estabel = ordem-compra.cod-estab-gestor NO-LOCK: END.
           
            ASSIGN ttPurchaseOrderLine_00.SiteID_00          = ordem-compra.cod-estab-gestor
                   ttPurchaseOrderLine_00.SiteDescription_00 = estabelec.nome WHEN AVAIL estabelec.
         END.

         IF ordem-compra.ct-codigo <> "" THEN
            ASSIGN ttPurchaseOrderLine_00.AccountNumber    = ordem-compra.ct-codigo.

         IF ordem-compra.sc-codigo <> "" THEN
            ASSIGN ttPurchaseOrderLine_00.SubAccountNumber = ordem-compra.sc-codigo.

         IF ordem-compra.dep-almoxar <> "" THEN DO:
            FOR FIRST deposito FIELDS (nome)
                WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK: END.

            ASSIGN ttPurchaseOrderLine_00.WarehouseID          = ordem-compra.dep-almoxar
                   ttPurchaseOrderLine_00.WarehouseDescription = deposito.nome WHEN AVAIL deposito .
         END.

         IF ordem-compra.tp-despesa <> 0 THEN DO:
            FOR FIRST tipo-rec-desp FIELDS (descricao)
                WHERE tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa NO-LOCK: END.

            ASSIGN ttPurchaseOrderLine_00.ExpenseTypeCode       = ordem-compra.tp-despesa   
                   ttPurchaseOrderLine_00.ExpenseTypeDescription = tipo-rec-desp.descricao WHEN AVAIL tipo-rec-desp.
         END.

         IF ordem-compra.nr-tab <> "" THEN DO:
            FOR FIRST tb-pr-cc
                WHERE tb-pr-cc.nr-tab       = ordem-compra.nr-tab
                  AND tb-pr-cc.cod-cond-pag = ordem-compra.cod-cond-pag 
                  AND tb-pr-cc.cod-emitente = ordem-compra.cod-emitente
                  AND tb-pr-cc.cod-estabel  = ordem-compra.cod-estabel 
                  AND tb-pr-cc.mo-codigo    = ordem-compra.mo-codigo  NO-LOCK: END.
            IF NOT AVAIL tb-pr-cc THEN
                FOR FIRST tb-pr-cc 
                    WHERE tb-pr-cc.nr-tab       = ordem-compra.nr-tab
                      AND tb-pr-cc.cod-cond-pag = ordem-compra.cod-cond-pag 
                      AND tb-pr-cc.cod-emitente = ordem-compra.cod-emitente
                      AND tb-pr-cc.cod-estabel  = ""
                      AND tb-pr-cc.mo-codigo    = ordem-compra.mo-codigo  NO-LOCK: END.

            ASSIGN ttPurchaseOrderLine_00.PriceTableNumber      = ordem-compra.nr-tab
                   ttPurchaseOrderLine_00.PriceTableDescription = tb-pr-cc.descricao WHEN AVAIL tb-pr-cc.
            
         END.

         IF ordem-compra.cod-transp <> 0 THEN DO:
            FOR FIRST transporte FIELDS (contato e-mail nome telefone via-transp)
                WHERE transporte.cod-transp = ordem-compra.cod-transp NO-LOCK: END.        

            ASSIGN ttPurchaseOrderLine_00.CarrierID             = ordem-compra.cod-transp
                   ttPurchaseOrderLine_00.CarrierName           = transporte.nome       WHEN AVAIL transporte
                   ttPurchaseOrderLine_00.CarrierShippingMethod = transporte.via-transp WHEN AVAIL transporte
                   ttPurchaseOrderLine_00.ContactName_00        = transporte.contato    WHEN AVAIL transporte   
                   ttPurchaseOrderLine_00.PhoneNumber_00        = transporte.telefone   WHEN AVAIL transporte
                   ttPurchaseOrderLine_00.EmailAddress_00       = transporte.e-mail     WHEN AVAIL transporte.    
         END.
         
         FOR EACH prazo-compra OF ordem-compra NO-LOCK:
          
            CREATE ttDeliveryScheduleInforma_00.
            ASSIGN ttDeliveryScheduleInforma_00.DeliveryScheduleID         = prazo-compra.parcela
                   ttDeliveryScheduleInforma_00.Quantity                   = prazo-compra.quantidade
                   ttDeliveryScheduleInforma_00.OriginalQuantity           = prazo-compra.quantid-orig
                   ttDeliveryScheduleInforma_00.BalenceQuantity            = prazo-compra.quant-saldo
                   ttDeliveryScheduleInforma_00.ReturnedQuantity           = prazo-compra.quant-rejeit
                   ttDeliveryScheduleInforma_00.ReceivedQuantity           = prazo-compra.quant-receb
                   ttDeliveryScheduleInforma_00.VendorQuantity             = prazo-compra.qtd-do-forn
                   ttDeliveryScheduleInforma_00.VendorBalenceQuantity      = prazo-compra.qtd-sal-forn
                   ttDeliveryScheduleInforma_00.VendorReturnedQuantity     = prazo-compra.qtd-rej-forn
                   ttDeliveryScheduleInforma_00.VendorReceivedQuantity     = prazo-compra.qtd-rec-forn
                   ttDeliveryScheduleInforma_00.DeliveryDate               = prazo-compra.data-entrega
                   ttDeliveryScheduleInforma_00.ItemUnitOfMeasure          = prazo-compra.un
                   ttDeliveryScheduleInforma_00.ItemReferenceCode          = prazo-compra.cod-refer
                   ttDeliveryScheduleInforma_00.OriginalDeliveryDate       = prazo-compra.data-orig
                   ttDeliveryScheduleInforma_00.CustomerShortName          = prazo-compra.nome-abrev
                   ttDeliveryScheduleInforma_00.SalesOrderNumber           = prazo-compra.pedido-clien
                   ttDeliveryScheduleInforma_00.SalesOrderLineNumber       = prazo-compra.nr-sequencia
                   ttDeliveryScheduleInforma_00.SalesOrderDeliverySequence = prazo-compra.nr-entrega
                   ttDeliveryScheduleInforma_00.iStatus                    = prazo-compra.situacao
                   ttDeliveryScheduleInforma_00.iType                      = prazo-compra.natureza
                   ttDeliveryScheduleInforma_00.DeliveryTime               = prazo-compra.hora
                   ttDeliveryScheduleInforma_00.Concentration              = prazo-compra.concentracao
                   ttDeliveryScheduleInforma_00.Efficiency                 = prazo-compra.rendimento
                   ttDeliveryScheduleInforma_00.IsPOLineIssued             = prazo-compra.ordem-emitida
                   ttDeliveryScheduleInforma_00.StructureNumber            = prazo-compra.nr-estrut
                   ttDeliveryScheduleInforma_00.ChildStructureNumber       = prazo-compra.nr-estrut-filha
                   ttDeliveryScheduleInforma_00.UpdateDate                 = prazo-compra.data-alter 
                   ttDeliveryScheduleInforma_00.Component                  = prazo-compra.es-codigo WHEN prazo-compra.es-codigo <> ""
                   ttDeliveryScheduleInforma_00.ComponentSequenceNumber    = prazo-compra.sequencia WHEN prazo-compra.sequencia <> 0 .
            
            FOR FIRST ITEM FIELDS (desc-item)
                WHERE ITEM.it-codigo = prazo-compra.item-cotacao NO-LOCK: END.

              ASSIGN ttDeliveryScheduleInforma_00.ItemCode        = prazo-compra.item-cotacao
                     ttDeliveryScheduleInforma_00.ItemDescription = desc-item WHEN AVAIL ITEM.

            IF prazo-compra.usuario-alt <> "" THEN DO:
               FOR FIRST usuar_mestre FIELDS (nom_usuario)
                   WHERE usuar_mestre.cod_usuario = prazo-compra.usuario-alt NO-LOCK: END.

               ASSIGN ttDeliveryScheduleInforma_00.cUserID  = prazo-compra.usuario-alt
                      ttDeliveryScheduleInforma_00.UserName = usuar_mestre.nom_usuario WHEN AVAIL usuar_mestre .
            END.
         
         END. /* prazo-compra */

  RUN PIUpsert ( INPUT cEvent,
                 INPUT cTranAction,
                 INPUT TABLE ttPurchaseOrderLine_00,
                 INPUT TABLE ttDeliveryScheduleInforma_00,
                 INPUT i-ordem-externa,
                 OUTPUT TABLE tt_log_erro ).


END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



