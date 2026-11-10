PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT PARAM rw-ordem-compra AS ROWID .
DEF INPUT PARAM p-acao          AS CHAR  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro            NO-ERROR.
EMPTY TEMP-TABLE ttPurchaseOrderLine_00 NO-ERROR.
EMPTY TEMP-TABLE ttDeliveryScheduleInforma_00 NO-ERROR.
EMPTY TEMP-TABLE tt-un NO-ERROR.

FIND FIRST ordem-compra 
    WHERE ROWID(ordem-compra) = rw-ordem-compra NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:

  CREATE ttPurchaseOrderLine_00.

  FOR FIRST ITEM FIELDS (it-codigo desc-item narrativa fm-codigo ge-codigo)
      WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

  FOR FIRST cond-pagto FIELDS (descricao)
      WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK: END.

  FOR FIRST moeda FIELDS (descricao sigla)
      WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-LOCK: END.

  FOR FIRST emitente FIELDS (cgc e-mail nome-abrev nome-emit telefone[1])
      WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.

  FOR FIRST usuar-mater FIELDS (cod-usuar)
      WHERE usuar-mater.cod-usuario = ordem-compra.requisitante NO-LOCK: END.

  IF AVAIL usuar-mater THEN DO:
      ASSIGN ttPurchaseOrderLine_00.Requisitioner = usuar-mater.cod-usuario.
  END.
  ELSE DO:
      ASSIGN ttPurchaseOrderLine_00.Requisitioner = ordem-compra.requisitante WHEN ordem-compra.requisitante <> "".
  END.

  /* Necess†rio para buscar a UN diretamente no cadastro da tab-unidade, para efevitar problemas
     de diferenáa de caracteres especiais que o Progresse n∆o diferencia e case-sensitive */
  FOR EACH tab-unidade NO-LOCK:
      CREATE tt-un.
      ASSIGN tt-un.un = tab-unidade.un.
  END.

  IF l-integra-portal THEN DO:
      FIND FIRST param-global NO-LOCK NO-ERROR.
      
      FOR FIRST empresa 
          WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK: END.
  END.

  ASSIGN cEvent       = ""       
         cTranAction  = p-acao   /* add / upd  */
  
         ttPurchaseOrderLine_00.POLineNumber = ordem-compra.numero-ordem WHEN ordem-compra.numero-ordem <> 0

         ttPurchaseOrderLine_00.ItemCode                         = IF AVAIL ITEM THEN ITEM.it-codigo ELSE ordem-compra.it-codigo  
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

         IF l-integra-portal THEN DO:
             FOR FIRST familia
                 WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK: END.
                 ASSIGN ttPurchaseOrderLine_00.ItemFamilyDescription  = familia.descricao
                        ttPurchaseOrderLine_00.ItemComments           = ITEM.narrativa WHEN AVAIL ITEM
                        ttPurchaseOrderLine_00.ItemFamily             = ITEM.fm-codigo WHEN AVAIL ITEM.
         END.

         IF l-integra-portal-paradigma THEN DO:
            ASSIGN ttPurchaseOrderLine_00.InventoryGroupCode = item.ge-codigo.
         END.

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

         FOR FIRST ITEM FIELDS (desc-item narrativa fm-codigo)
             WHERE ITEM.it-codigo = ordem-compra.item-pai NO-LOCK: END.
          ASSIGN ttPurchaseOrderLine_00.ParentItemCode         = ordem-compra.item-pai   
                 ttPurchaseOrderLine_00.ParentItemDescription  = ITEM.desc-item WHEN AVAIL ITEM.

         IF ordem-compra.cod-comprado <> "" THEN DO:
            FOR FIRST comprador FIELDS (cod-comprado nome)
                WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-LOCK: END.

            ASSIGN ttPurchaseOrderLine_00.BuyerID   = IF AVAIL comprador THEN comprador.cod-comprado ELSE ordem-compra.cod-comprado
                   ttPurchaseOrderLine_00.BuyerName = comprador.nome WHEN AVAIL comprador.    
         END.

         IF ordem-compra.cod-estabel <> "" THEN DO:
            FOR FIRST estabelec FIELDS (cod-estabel nome endereco)
                WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
          
            ASSIGN ttPurchaseOrderLine_00.SiteID          = IF AVAIL estabelec THEN estabelec.cod-estabel ELSE ordem-compra.cod-estabel   
                   ttPurchaseOrderLine_00.SiteDescription = estabelec.nome WHEN AVAIL estabelec.

            IF l-integra-portal THEN DO:
                ASSIGN ttPurchaseOrderLine_00.SiteAdress      = estabelec.endereco.
            END.
         END.
         
         IF ordem-compra.cod-estab-gestor <> "" THEN DO:
            FOR FIRST estabelec FIELDS (nome)
                WHERE estabelec.cod-estabel = ordem-compra.cod-estab-gestor NO-LOCK: END.
           
            ASSIGN ttPurchaseOrderLine_00.SiteID_00          = ordem-compra.cod-estab-gestor
                   ttPurchaseOrderLine_00.SiteDescription_00 = estabelec.nome WHEN AVAIL estabelec.
         END.

         IF ordem-compra.conta-contabil <> "" THEN
            ASSIGN ttPurchaseOrderLine_00.AccountNumber              = ordem-compra.ct-codigo
                   ttPurchaseOrderLine_00.SubAccountNumber           = ordem-compra.sc-codigo   
                   ttPurchaseOrderLine_00.GeneralLedgerAccountNumber = ordem-compra.conta-contabil .

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
                  AND tb-pr-cc.mo-codigo    = ordem-compra.mo-codigo NO-LOCK: END.

            IF NOT AVAIL tb-pr-cc THEN
                FOR FIRST tb-pr-cc
                    WHERE tb-pr-cc.nr-tab       = ordem-compra.nr-tab
                      AND tb-pr-cc.cod-cond-pag = ordem-compra.cod-cond-pag
                      AND tb-pr-cc.cod-emitente = ordem-compra.cod-emitente
                      AND tb-pr-cc.cod-estabel  = ""
                      AND tb-pr-cc.mo-codigo    = ordem-compra.mo-codigo NO-LOCK: END.

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
         
         
         /*Maylon*/
         IF l-integra-portal THEN DO:
             &IF  "{&bf_mat_versao_ems}"  >=  "2.062"  &THEN
                 &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                    IF substring(ordem-compra.CHAR-1,90,1) = "S":U THEN 
                        ASSIGN ttPurchaseOrderLine_00.Freeze = "yes":U.
                    ELSE
                        ASSIGN ttPurchaseOrderLine_00.Freeze = "no":U.
        
                    IF substring(ordem-compra.CHAR-1,91,1) = "S":U THEN 
                        ASSIGN ttPurchaseOrderLine_00.PortalIntegration = "yes":U.
                    ELSE
                        ASSIGN ttPurchaseOrderLine_00.PortalIntegration = "no":U.
        
                    IF SUBSTRING(ordem-compra.CHAR-1,92,50) <> "":U THEN
                        ASSIGN ttPurchaseOrderLine_00.POLineNumberPortal = SUBSTRING(ordem-compra.CHAR-1,92,50). 
                 &ELSE
                    ASSIGN ttPurchaseOrderLine_00.Freeze             = STRING(ordem-compra.log-congela-orde)
                           ttPurchaseOrderLine_00.PortalIntegration  = STRING(ordem-compra.log-integr-portal).
        
                    IF STRING(ordem-compra.cod-ord-portal) <> "" THEN
                        ASSIGN ttPurchaseOrderLine_00.POLineNumberPortal = STRING(ordem-compra.cod-ord-portal).
                 &ENDIF
             
                 IF ordem-compra.loc-entrega <> "" THEN
                     ASSIGN ttPurchaseOrderLine_00.DeliveryLoc = ordem-compra.loc-entrega.
                 
                 IF ordem-compra.cod-entrega <> "" THEN
                     ASSIGN ttPurchaseOrderLine_00.DeliveryCod = ordem-compra.cod-entrega.
        
                 IF ordem-compra.estab-entrega <> "" THEN
                     ASSIGN ttPurchaseOrderLine_00.DeliverySite = ordem-compra.estab-entrega.
        
                 IF ordem-compra.local-entrega <> 0 THEN
                     ASSIGN ttPurchaseOrderLine_00.DeliveryLoc2 = ordem-compra.local-entrega.
    
                 &IF  "{&bf_mat_versao_ems}"  >=  "2.071"  &THEN
                    IF param-global.empresa-prin <> "" THEN
                        ASSIGN ttPurchaseOrderLine_00.CompanyCode = STRING(param-global.empresa-prin).
                 &ELSE
                     IF param-global.empresa-prin <> 0 THEN
                        ASSIGN ttPurchaseOrderLine_00.CompanyCode = STRING(param-global.empresa-prin).
                 &ENDIF
    
                 IF AVAIL empresa AND empresa.cgc <> "" THEN
                     ASSIGN ttPurchaseOrderLine_00.TaxId = empresa.cgc.
    
             
                 FOR EACH item-fornec
                      WHERE item-fornec.it-codigo = ordem-compra.it-codigo NO-LOCK:
        
                     FIND FIRST b-emitente
                          WHERE b-emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
                     IF AVAIL b-emitente THEN DO:

                         FIND FIRST ttVendorItem WHERE ttVendorItem.TaxId = b-emitente.cgc NO-LOCK NO-ERROR.

                         IF NOT AVAIL ttVendorItem THEN DO:
                             CREATE ttVendorItem.
                             ASSIGN ttVendorItem.CODE      = string(item-fornec.cod-emitente)
                                    ttVendorItem.ShortName = b-emitente.nome-abrev
                                    ttVendorItem.NAME      = b-emitente.nome-emit
                                    ttVendorItem.TaxId     = b-emitente.cgc.
                         END.
                     END.
                 END.
             &ENDIF  
         END.
         /*maylon*/
         
         FOR EACH prazo-compra OF ordem-compra NO-LOCK:
             
             /*Maylon*/
             IF l-integra-portal THEN DO:
                 IF prazo-compra.data-entrega > LastDelivery THEN
                     ASSIGN LastDelivery  = prazo-compra.data-entrega.
             END.

             FIND FIRST tt-un WHERE tt-un.un = prazo-compra.un NO-LOCK NO-ERROR.
          
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
                   ttDeliveryScheduleInforma_00.ItemUnitOfMeasure          = IF AVAIL tt-un THEN tt-un.un ELSE prazo-compra.un
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
            
            FOR FIRST ITEM FIELDS (it-codigo desc-item)
                WHERE ITEM.it-codigo = prazo-compra.item-cotacao NO-LOCK: END.

              ASSIGN ttDeliveryScheduleInforma_00.ItemCode        = prazo-compra.item-cotacao
                     ttDeliveryScheduleInforma_00.ItemDescription = desc-item WHEN AVAIL ITEM.

            IF prazo-compra.usuario-alt <> "" THEN DO:
               FOR FIRST usuar_mestre FIELDS (nom_usuario)
                   WHERE usuar_mestre.cod_usuario = prazo-compra.usuario-alt NO-LOCK: END.

               ASSIGN ttDeliveryScheduleInforma_00.cUserID  = prazo-compra.usuario-alt
                      ttDeliveryScheduleInforma_00.UserName = usuar_mestre.nom_usuario WHEN AVAIL usuar_mestre .
            END.

            IF prazo-compra.cod-refer <> "" THEN
                ASSIGN ttPurchaseOrderLine_00.ItemReferenceCode = prazo-compra.cod-refer
                       ordem-compra.cod-refer                   = prazo-compra.cod-refer.

         END. /* prazo-compra */


  RUN PIUpsert ( INPUT cEvent,
                 INPUT cTranAction,
                 INPUT TABLE ttPurchaseOrderLine_00,
                 INPUT TABLE ttDeliveryScheduleInforma_00,
                 OUTPUT TABLE tt_log_erro ).


END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

PROCEDURE piDestinationPartner:
    DEFINE INPUT PARAMETER p-destination-cod AS CHARACTER NO-UNDO.

    CREATE ttDestinationPartner.
    ASSIGN ttDestinationPartner.codDestination = p-destination-cod.

    RETURN "OK":U.
END PROCEDURE.



