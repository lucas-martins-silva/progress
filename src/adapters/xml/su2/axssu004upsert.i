PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAMETER rw-pedido-compr AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/

                                              
    /*LOCAL VARIABLES - BEGIN*/
    DEFINE BUFFER bf-estabgestor FOR estabelec.
    DEFINE BUFFER bf-estab-cob   FOR estabelec.
    DEFINE BUFFER bf-estab-ent   FOR estabelec.
    DEFINE BUFFER bf-estab-fisc  FOR estabelec.
    DEFINE VAR i-cont    AS INT NO-UNDO.
    DEFINE VAR i-ID      AS INT NO-UNDO.
    DEFINE VAR de-indice AS INT NO-UNDO.
    /*LOCAL VARIABLES - END*/

    /* Necess†rio para buscar a UN diretamente no cadastro da tab-unidade, para efevitar problemas
    de diferenáa de caracteres especiais que o Progresse n∆o diferencia e case-sensitive */
    FOR EACH tab-unidade NO-LOCK:
        CREATE tt-un.
        ASSIGN tt-un.un = tab-unidade.un.
    END.

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    FIND pedido-compr NO-LOCK WHERE ROWID(pedido-compr) = rw-pedido-compr NO-ERROR.
    IF AVAIL pedido-compr THEN DO:

        FIND estabelec      NO-LOCK WHERE estabelec.cod-estabel      = pedido-compr.cod-estabel      NO-ERROR.

        FIND bf-estabgestor NO-LOCK WHERE bf-estabgestor.cod-estabel = pedido-compr.cod-estab-gestor NO-ERROR.
                                                                                                     
        FIND bf-estab-cob   NO-LOCK WHERE bf-estab-cob.cod-estabel   = pedido-compr.end-cobranca     NO-ERROR.

        FIND bf-estab-ent   NO-LOCK WHERE bf-estab-ent.cod-estabel   = pedido-compr.end-entrega      NO-ERROR.
        
        FIND usuar-mater    NO-LOCK WHERE usuar-mater.cod-usuario    = pedido-compr.responsavel      NO-ERROR.

        FIND emitente       NO-LOCK WHERE emitente.cod-emitente      = pedido-compr.cod-emitente     NO-ERROR.

        FIND FIRST mensagem NO-LOCK WHERE mensagem.cod-mensagem      = pedido-compr.cod-mensagem     NO-ERROR.
        FIND FIRST param-global NO-LOCK NO-ERROR.
        
        IF l-integra-portal THEN DO:
            FIND FIRST empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.
            FIND cond-pagto     NO-LOCK WHERE cond-pagto.cod-cond-pag    = pedido-compr.cod-cond-pag     NO-ERROR.
        END.

        CREATE ttPurchaseOrder.
        ASSIGN ttPurchaseOrder.ttPurchaseOrderID     = 1
               ttPurchaseOrder.PONumber              = pedido-compr.num-pedido
               ttPurchaseOrder.Address               = IF AVAIL bf-estab-cob   THEN bf-estab-cob.endereco    ELSE ""
               ttPurchaseOrder.Address_00            = IF AVAIL bf-estab-ent   THEN bf-estab-ent.endereco    ELSE ""
               ttPurchaseOrder.CityName              = IF AVAIL bf-estab-cob   THEN bf-estab-cob.cidade      ELSE ""
               ttPurchaseOrder.CityName_00           = IF AVAIL bf-estab-ent   THEN bf-estab-ent.cidade      ELSE ""
               ttPurchaseOrder.Comment               = pedido-compr.comentarios
               ttPurchaseOrder.ContactName           = IF AVAIL usuar-mater    THEN usuar-mater.cod-usuario  ELSE ""
               ttPurchaseOrder.ContactName_00        = IF AVAIL usuar-mater    THEN usuar-mater.cod-usuario  ELSE ""
               ttPurchaseOrder.CountryCode           = IF AVAIL bf-estab-cob   THEN bf-estab-cob.pais        ELSE ""
               ttPurchaseOrder.CountryCode_00        = IF AVAIL bf-estab-ent   THEN bf-estab-ent.pais        ELSE ""              
               ttPurchaseOrder.DistrictName          = IF AVAIL bf-estab-cob   THEN bf-estab-cob.bairro      ELSE ""
               ttPurchaseOrder.DistrictName_00       = IF AVAIL bf-estab-ent   THEN bf-estab-ent.bairro      ELSE ""
               ttPurchaseOrder.EmailAddress          = IF AVAIL usuar-mater    THEN usuar-mater.e-mail       ELSE ""
               ttPurchaseOrder.EmailAddress_00       = IF AVAIL usuar-mater    THEN usuar-mater.e-mail       ELSE ""
               ttPurchaseOrder.NationalPostalCode    = IF AVAIL bf-estab-cob   THEN bf-estab-cob.cep         ELSE 0
               ttPurchaseOrder.NationalPostalCode_00 = IF AVAIL bf-estab-ent   THEN bf-estab-ent.cep         ELSE 0
               ttPurchaseOrder.OrderTypeCode         = pedido-compr.l-tipo-ped
               ttPurchaseOrder.PaymentCode           = pedido-compr.cod-cond-pag
               ttPurchaseOrder.SiteDescription       = IF AVAIL estabelec      THEN estabelec.nome           ELSE ""
               ttPurchaseOrder.SiteDescription_00    = IF AVAIL bf-estabgestor THEN bf-estabgestor.nome      ELSE ""
               ttPurchaseOrder.SiteID                = IF AVAIL estabelec      THEN estabelec.cod-estabel    ELSE pedido-compr.cod-estabel
               ttPurchaseOrder.SiteID_00             = pedido-compr.cod-estab-gestor
               ttPurchaseOrder.SiteId_01             = IF AVAIL bf-estab-cob   THEN bf-estab-cob.cod-estabel ELSE ""
               ttPurchaseOrder.SiteId_02             = IF AVAIL bf-estab-ent   THEN bf-estab-ent.cod-estabel ELSE "" 
               ttPurchaseOrder.StateCode             = IF AVAIL bf-estab-cob   THEN bf-estab-cob.estado      ELSE ""
               ttPurchaseOrder.StateCode_00          = IF AVAIL bf-estab-ent   THEN bf-estab-ent.estado      ELSE ""
               ttPurchaseOrder.TelephoneNumber       = IF AVAIL usuar-mater    THEN usuar-mater.telefone[1]  ELSE ""
               ttPurchaseOrder.TelephoneNumber_00    = IF AVAIL usuar-mater    THEN usuar-mater.telefone[1]  ELSE ""
               ttPurchaseOrder.VendorNumber          = pedido-compr.cod-emitente
               ttPurchaseOrder.Address_01            = IF AVAIL emitente       THEN emitente.endereco        ELSE ""
               ttPurchaseOrder.CityName_01           = IF AVAIL emitente       THEN emitente.cidade          ELSE ""
               ttPurchaseOrder.DistrictName_01       = IF AVAIL emitente       THEN emitente.bairro          ELSE ""
               ttPurchaseOrder.StateCode_01          = IF AVAIL emitente       THEN emitente.estado          ELSE ""
               ttPurchaseOrder.NationalPostalCode_01 = IF AVAIL emitente       THEN emitente.cep             ELSE ""
               ttPurchaseOrder.CountryCode_01                  = IF AVAIL emitente       THEN emitente.pais            ELSE ""

               ttPurchaseOrder.SubcontractOrder	               = pedido-compr.num-ped-benef
               ttPurchaseOrder.i-Type	                       = pedido-compr.natureza          /*(1 - Compra, 2 - Serviáo, 3 - Beneficiamento)*/
               ttPurchaseOrder.OrderDate	                   = pedido-compr.data-pedido
               ttPurchaseOrder.ind-Status	                   = pedido-compr.situacao
               ttPurchaseOrder.Freight	                       = pedido-compr.frete             /*(1 - Pago, 2 - A Pagar)*/
               ttPurchaseOrder.MessageCode	                   = pedido-compr.cod-mensagem
               ttPurchaseOrder.MessageDescription	           = Mensagem.descricao             /*(acessar a tabela mensagem onde mensagem.cod-mensagem = pedido-compr.cod-mensagem)*/
               ttPurchaseOrder.PrintOrder	                   = pedido-compr.impr-pedido
               ttPurchaseOrder.ExclusionReason	               = pedido-compr.mot-elimina
               ttPurchaseOrder.SubscriberName	               = pedido-compr.nome-ass[1]
               ttPurchaseOrder.SubscriberTitle	               = pedido-compr.cargo-ass[1]
               ttPurchaseOrder.UrgentOrder	                   = pedido-compr.emergencial
               ttPurchaseOrder.NextPurchaseOrder	           = pedido-compr.nr-prox-ped
               ttPurchaseOrder.SupplyContract	               = pedido-compr.contr-forn
               ttPurchaseOrder.ProcessNumber	               = pedido-compr.nr-processo
               ttPurchaseOrder.DeliveryLocationSuplement	   = pedido-compr.compl-entrega
               ttPurchaseOrder.SortKey	                       = pedido-compr.l-classificacao
               ttPurchaseOrder.ProformaIndicator	           = pedido-compr.l-ind-prof
               ttPurchaseOrder.ImporterCode	                   = pedido-compr.i-importador
               ttPurchaseOrder.StatusPurchaseOrder     	       = pedido-compr.i-situacao
               ttPurchaseOrder.PriceTableCode	               = pedido-compr.c-cod-tabela
               ttPurchaseOrder.CurrencyCode	                   = pedido-compr.i-moeda
               ttPurchaseOrder.PaymentType	                   = pedido-compr.i-cod-forma
               ttPurchaseOrder.TransportViaCode	               = pedido-compr.i-cod-via
               ttPurchaseOrder.ShipmentTerm	                   = pedido-compr.c-prazo
               ttPurchaseOrder.GoodsDescription                = pedido-compr.c-descr-merc[1]
               ttPurchaseOrder.HarborCode	                   = pedido-compr.i-cod-porto
               ttPurchaseOrder.FOBAmount	                   = pedido-compr.de-vl-fob
               ttPurchaseOrder.Packaging	                   = pedido-compr.c-embalagem[1]
               ttPurchaseOrder.Comments	                       = pedido-compr.c-observaá∆o[1]
               ttPurchaseOrder.ExporterCode	                   = pedido-compr.i-exportador
               ttPurchaseOrder.InternalDescriptionPaymentForm  = pedido-compr.desc-forma
               ttPurchaseOrder.InternalDescriptionCarriageMode = pedido-compr.desc-via
               ttPurchaseOrder.InternalFreig	               = pedido-compr.de-vl-frete-i
               ttPurchaseOrder.ReceiptSource	               = pedido-compr.ind-orig-entrada
               ttPurchaseOrder.TransportSenderVia	           = pedido-compr.ind-via-envio
               ttPurchaseOrder.ProcessReceipts	               = pedido-compr.nro-proc-entrada
               ttPurchaseOrder.ProcessIssue	                   = pedido-compr.nro-proc-saida
               ttPurchaseOrder.ProcessUpdating	               = pedido-compr.nro-proc-alteracao
               ttPurchaseOrder.SourceMachineCode	           = pedido-compr.cod-maq-origem
               ttPurchaseOrder.MultiPlantProcessNumber	       = pedido-compr.nr-processo
               ttPurchaseOrder.CharacterFree1	               = pedido-compr.char-1
               ttPurchaseOrder.CharacterFree2	               = pedido-compr.char-2
               ttPurchaseOrder.DecimalFree1	                   = pedido-compr.dec-1
               ttPurchaseOrder.DecimalFree2	                   = pedido-compr.dec-2
               ttPurchaseOrder.NumericFree1	                   = pedido-compr.int-1
               ttPurchaseOrder.NumericFree2	                   = pedido-compr.int-2
               ttPurchaseOrder.LogicalFree1	                   = pedido-compr.log-1
               ttPurchaseOrder.LogicalFree2	                   = pedido-compr.log-2
               ttPurchaseOrder.DateFree1	                   = pedido-compr.data-1
               ttPurchaseOrder.DateFree2	                   = pedido-compr.data-2
               ttPurchaseOrder.RecordIdentifyingDocument	   = pedido-compr.num-id-documento
               ttPurchaseOrder.ContractNumber	               = pedido-compr.nr-contrato
               ttPurchaseOrder.Check-Sum	                   = pedido-compr.check-sum
               ttPurchaseOrder.GenerateEDIProcess	           = pedido-compr.gera-edi
               ttPurchaseOrder.GoodsDeliveryCustVendor	       = pedido-compr.cod-emit-terc
               ttPurchaseOrder.CustOrderNumber	               = pedido-compr.nr-ped-venda
               ttPurchaseOrder.MaterialsDeliveryCode	       = pedido-compr.cod-entrega
               ttPurchaseOrder.FullAddress	                   = pedido-compr.endereco_text
               ttPurchaseOrder.Address2                        = pedido-compr.endereco
               ttPurchaseOrder.DistrictName2                   = pedido-compr.bairro
               ttPurchaseOrder.City	                           = pedido-compr.cidade
               ttPurchaseOrder.State	                       = pedido-compr.estado
               ttPurchaseOrder.Country	                       = pedido-compr.pais
               ttPurchaseOrder.ZipCode	                       = pedido-compr.cep.
               
        IF l-integra-portal THEN DO:
            ASSIGN
                   /*Maylon*/
                   &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                   ttPurchaseOrder.Freeze                          = IF substring(pedido-compr.char-1,1,1) = "s":U THEN "yes":U ELSE "no":U
                   ttPurchaseOrder.PortalIntegration               = IF substring(pedido-compr.char-1,2,1) = "s":U THEN "yes":U ELSE "no":U
                   ttPurchaseOrder.PONumberPortal                  = substring(pedido-compr.char-1,3,50)
                   &ELSE
                   ttPurchaseOrder.Freeze                          = string(pedido-compr.log-congela-ped) 
                   ttPurchaseOrder.PortalIntegration               = string(pedido-compr.log-integr-portal)
                   ttPurchaseOrder.POLineNumberPortal              = pedido-compr.cod-ped-portal
                   &ENDIF
                   ttPurchaseOrder.DeliveryLoc                     = pedido-compr.local-entrega
                   ttPurchaseOrder.CompanyCode                     = string(param-global.empresa-prin)
                   ttPurchaseOrder.TaxID                           = empresa.cgc
                   ttPurchaseOrder.VendorTaxId                     = emitente.cgc
                   ttPurchaseOrder.PaymentDescription              = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "":U. 
        END.           

        ASSIGN i-ID = 0.
        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
             AND ordem-compra.situacao <> 4:

            FIND FIRST cont-emit NO-LOCK WHERE cont-emit.nome = ordem-compra.contato NO-ERROR.

            FIND item NO-LOCK WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

            IF l-integra-portal THEN DO:
                FIND familia WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
    
                FIND FIRST moeda WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-LOCK NO-ERROR.
            END.

            ASSIGN i-ID = i-ID + 1.

            CREATE ttPurchaseOrderLine. 
            ASSIGN ttPurchaseOrderLine.ttPurchaseOrderLineID   = i-ID
                   ttPurchaseOrderLine.CurrencyId              = ordem-compra.mo-codigo
                   ttPurchaseOrderLine.ItemCode                = IF AVAIL ITEM THEN item.it-codigo ELSE ordem-compra.it-codigo
                   ttPurchaseOrderLine.ItemDescription         = IF AVAIL item THEN item.desc-item ELSE ""
                   ttPurchaseOrderLine.ItemReferenceCode       = ordem-compra.cod-refer
                   ttPurchaseOrderLine.POLineNumber            = ordem-compra.numero-ordem
                   ttPurchaseOrderLine.PONumber                = ordem-compra.num-pedido
                   ttPurchaseOrderLine.VendorUnitaryPrice      = ordem-compra.pre-unit-for
                   ttPurchaseOrderLine.ContactName_01          = ordem-compra.contato
                   ttPurchaseOrderLine.ContactNumber           = IF AVAIL cont-emit THEN cont-emit.cod-emitente ELSE 0
                   ttPurchaseOrderLine.EmailAddress_01         = IF AVAIL cont-emit THEN cont-emit.e-mail       ELSE ""
                   ttPurchaseOrderLine.TelephoneNumber_01               = IF AVAIL cont-emit THEN cont-emit.telefone     ELSE ""

                   ttPurchaseOrderLine.i-Status	                        =    ordem-compra.situacao /*(1-N∆o Confirmada, 2-Confirmada, 3-Cotada, 4-Eliminada, 5- Em Cotaá∆o, 6-Recebida)*/
                   ttPurchaseOrderLine.i-Source	                        =    ordem-compra.origem /*(1- Manual, 2-Dependente, 3- Independente)*/
                   ttPurchaseOrderLine.OperationCode	                =    ordem-compra.op-codigo
                   ttPurchaseOrderLine.PrintDate	                    =    ordem-compra.data-emissao
                   ttPurchaseOrderLine.Account	                        =    ordem-compra.ct-codigo
                   ttPurchaseOrderLine.SubAccount	                    =    ordem-compra.sc-codigo
                   ttPurchaseOrderLine.Req	                            =    ordem-compra.requisitante
                   ttPurchaseOrderLine.WareHouse	                    =    ordem-compra.dep-almoxar
                   ttPurchaseOrderLine.WorksOrder	                    =    ordem-compra.ordem-servic
                   ttPurchaseOrderLine.BuyerCode	                    =    ordem-compra.cod-comprado
                   ttPurchaseOrderLine.c-Text	                        =    ordem-compra.narrativa
                   ttPurchaseOrderLine.PriceDate	                    =    ordem-compra.data-cotacao
                   ttPurchaseOrderLine.OriginalPrice	                =    ordem-compra.preco-orig
                   ttPurchaseOrderLine.UnitPrice	                    =    ordem-compra.preco-unit
                   ttPurchaseOrderLine.VendorPrice	                    =    ordem-compra.preco-fornec
                   ttPurchaseOrderLine.IndustrializedProductTaxCode	    =    ordem-compra.codigo-ipi
                   ttPurchaseOrderLine.IndustrializedProductTaxPercent  =    ordem-compra.aliquota-ipi
                   ttPurchaseOrderLine.SAndProdCirculationTaxCode       =    ordem-compra.codigo-icm
                   ttPurchaseOrderLine.SAndProdCirculationTaxPercent    =    ordem-compra.aliquota-icm
                   ttPurchaseOrderLine.ServiceTaxPercent	            =    ordem-compra.aliquota-iss
                   ttPurchaseOrderLine.FreightAmount	                =    ordem-compra.valor-frete
                   ttPurchaseOrderLine.FinancialCharges	                =    ordem-compra.taxa-financ
                   ttPurchaseOrderLine.FinancialChargesAmount	        =    ordem-compra.valor-taxa
                   ttPurchaseOrderLine.ShipmentBalance	                =    ordem-compra.saldo-emb
                   ttPurchaseOrderLine.DiscountPercentage	            =    ordem-compra.perc-descto
                   ttPurchaseOrderLine.InvGrpBalance	                =    ordem-compra.saldo-gi
                   ttPurchaseOrderLine.PaymentTermsCode	                =    ordem-compra.cod-cond-pag
                   ttPurchaseOrderLine.DeliveryTerm	                    =    ordem-compra.prazo-entreg
                   ttPurchaseOrderLine.QuotePrint	                    =    ordem-compra.impr-ficha
                   ttPurchaseOrderLine.Comments	                        =    ordem-compra.comentarios
                   ttPurchaseOrderLine.UserCode	                        =    ordem-compra.usuario
                   ttPurchaseOrderLine.UpdateDate	                    =    ordem-compra.data-atualiz
                   ttPurchaseOrderLine.UpdateTime	                    =    ordem-compra.hora-atualiz
                   ttPurchaseOrderLine.SourceOrderNumber	            =    ordem-compra.nr-ord-orig
                   ttPurchaseOrderLine.UpdateIndex	                    =    ordem-compra.ind-reajuste
                   ttPurchaseOrderLine.ProcessNumber                    =    ordem-compra.nr-processo
                   ttPurchaseOrderLine.DiscountAmount	                =    ordem-compra.valor-descto
                   ttPurchaseOrderLine.FinancialRateDays	            =    ordem-compra.nr-dias-taxa
                   ttPurchaseOrderLine.ExpenseType	                    =    ordem-compra.tp-despesa
                   ttPurchaseOrderLine.QuantityAccumulatedNeed	        =    ordem-compra.qt-acum-nec
                   ttPurchaseOrderLine.QuantityReceivedAccumulated	    =    ordem-compra.qt-acum-rec
                   ttPurchaseOrderLine.QuantityAccumulatedReturn	    =    ordem-compra.qt-acum-dev
                   ttPurchaseOrderLine.ProjectOrderNumber               =    ordem-compra.num-ord-inv
                   ttPurchaseOrderLine.MaterialRequisitionSequence	    =    ordem-compra.sequencia
                   ttPurchaseOrderLine.PriceTableNumber	                =    ordem-compra.nr-tab
                   ttPurchaseOrderLine.Company	                        =    ordem-compra.ep-codigo
                   ttPurchaseOrderLine.Accounts  	                    =    ordem-compra.conta-contabil
                   ttPurchaseOrderLine.printedOrder  	                =    ordem-compra.ordem-emitida
                   ttPurchaseOrderLine.Expectation 	                    =    ordem-compra.expectativa
                   ttPurchaseOrderLine.QuantityRequested	            =    ordem-compra.qt-solic
                   ttPurchaseOrderLine.ContractNumber	                =    ordem-compra.nr-contrato
                   ttPurchaseOrderLine.ItemSequence	                    =    ordem-compra.num-seq-item
                   ttPurchaseOrderLine.OrderStatusOnContract	        =    ordem-compra.sit-ordem-contrat
                   ttPurchaseOrderLine.OrderDate	                    =    ordem-compra.dat-ordem
                   ttPurchaseOrderLine.ApprovalPriority	                =    ordem-compra.prioridade-aprov
                   ttPurchaseOrderLine.AutomApprovalSource	            =    ordem-compra.origem-aprov
                   ttPurchaseOrderLine.ManagerSiteCode	                =    ordem-compra.cod-estab-gestor
                   ttPurchaseOrderLine.DeliveryPlace  	                =    ordem-compra.loc-entrega
                   ttPurchaseOrderLine.DeliveryCode	                    =    ordem-compra.cod-entrega
                   ttPurchaseOrderLine.DeliverySiteCode	                =    ordem-compra.estab-entrega
                   ttPurchaseOrderLine.CustomerOrderNumber	            =    ordem-compra.nr-pedcli
                   ttPurchaseOrderLine.ShipToAddress                    =    ordem-compra.local-entrega
                   ttPurchaseOrderLine.ContractSiteCode	                =    ordem-compra.cod-estab-ctr
                   ttPurchaseOrderLine.ContractItemSequence             =    ordem-compra.nr-seq-contr-it
                   ttPurchaseOrderLine.SalesContractNumber	            =    ordem-compra.nr-contrato-venda
                   ttPurchaseOrderLine.BusinessUnitCode	                =    ordem-compra.cod-unid-negoc.

            IF l-integra-portal THEN DO:
                ASSIGN ttPurchaseOrderLine.ItemComments                     =    ITEM.narrativa
                       ttPurchaseOrderLine.ItemFamily                       =    string(ITEM.fm-codigo)
                       ttPurchaseOrderLine.ItemFamilyDescription            =    familia.descricao
                       ttPurchaseOrderLine.Comment                          =    ordem-compra.comentarios.
            END.

            IF l-integra-paradigma THEN DO:
                ASSIGN ttPurchaseOrderLine.InventoryGroupCode = item.ge-codigo
                       c-dados-medicao = "".

                IF pedido-compr.nr-contrato <> 0 THEN DO:
                    ASSIGN c-dados-c-text = "CONTRATO: " + STRING(pedido-compr.nr-contrato) + CHR(13) + ttPurchaseOrderLine.c-Text
                           ttPurchaseOrderLine.c-Text = "CONTRATO: " + STRING(pedido-compr.nr-contrato) + " ".
                    FIND FIRST contrato-for NO-LOCK
                         WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato NO-ERROR.
                    IF AVAIL contrato-for
                         AND contrato-for.ind-control-rec = 1 THEN DO:

                        ASSIGN c-dados-medicao = CHR(13) + "Dados Mediá‰es" + CHR(13).
                        FOR EACH medicao-contrat NO-LOCK
                           WHERE medicao-contrat.nr-contrato  = ordem-compra.nr-contrato
                             AND medicao-contrat.numero-ordem = ordem-compra.numero-ordem:

                            IF medicao-contrat.ind-sit-medicao = 1 THEN
                                ASSIGN c-desc-situcao = "Pendente":U.
                            ELSE
                                ASSIGN c-desc-situcao = "Liberada":U.

                            ASSIGN c-dados-medicao = c-dados-medicao
                                                   + "C¢d Item: "      + ordem-compra.it-codigo                   + chr(13)
                                                   + "Seq Med: "       + STRING(medicao-contrat.num-seq-medicao)  + chr(13)
                                                   + "Evento: "        + STRING(medicao-contrat.num-seq-event)    + chr(13)
                                                   + "Previs∆o: "      + STRING(medicao-contrat.dat-prev-medicao) + chr(13)
                                                   + "Qtde Prevista: " + STRING(medicao-contrat.qtd-prevista)     + chr(13)
                                                   + "Un: "            + medicao-contrat.un                       + chr(13)
                                                   + "Vl Mediá∆o: "    + STRING(medicao-contrat.val-medicao)      + chr(13)
                                                   + "Mediá∆o %: "     + STRING(medicao-contrat.perc-medicao)     + chr(13)
                                                   + "Valor Saldo: "   + STRING(medicao-contrat.sld-val-medicao)  + chr(13)
                                                   + "Situaá∆o: "      + c-desc-situcao                           + chr(13) + chr(13).
                        END.

                    END.
                    ELSE DO:
                    
                        FIND FIRST item-contrat NO-LOCK
                             WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato
                               AND  item-contrat.num-seq-item = ordem-compra.num-seq-item
                               /*AND item-contrat.num-seq-item = ordem-compra.nr-seq-contr-it*/
                               /*AND item-contrat.it-codigo   = ordem-compra.it-codigo*/ NO-ERROR.
                        IF AVAIL item-contrat THEN DO:
                            IF (item-contrat.ind-tipo-control  = 1 OR item-contrat.log-control-event) THEN DO:

                                ASSIGN c-dados-medicao = CHR(13) + "Dados Mediá‰es" + CHR(13).
                                FOR EACH medicao-contrat NO-LOCK
                                   WHERE medicao-contrat.nr-contrato  = ordem-compra.nr-contrato
                                     AND medicao-contrat.num-seq-item = item-contrat.num-seq-item
                                     AND medicao-contrat.numero-ordem = ordem-compra.numero-ordem
                                    /* num-seq-event e num-seq-medicao */ :

                                    IF medicao-contrat.ind-sit-medicao = 1 THEN
                                        ASSIGN c-desc-situcao = "Pendente":U.
                                    ELSE
                                        ASSIGN c-desc-situcao = "Liberada":U.

                                    ASSIGN c-dados-medicao = c-dados-medicao
                                                           + "C¢d Item: "      + ordem-compra.it-codigo                   + chr(13)
                                                           + "Seq Med: "       + STRING(medicao-contrat.num-seq-medicao)  + chr(13)
                                                           + "Evento: "        + STRING(medicao-contrat.num-seq-event)    + chr(13)
                                                           + "Previs∆o: "      + STRING(medicao-contrat.dat-prev-medicao) + chr(13)
                                                           + "Qtde Prevista: " + STRING(medicao-contrat.qtd-prevista)     + chr(13)
                                                           + "Un: "            + medicao-contrat.un                       + chr(13)
                                                           + "Vl Mediá∆o: "    + STRING(medicao-contrat.val-medicao)      + chr(13)
                                                           + "Mediá∆o %: "     + STRING(medicao-contrat.perc-medicao)     + chr(13)
                                                           + "Valor Saldo: "   + STRING(medicao-contrat.sld-val-medicao)  + chr(13)
                                                           + "Situaá∆o: "      + c-desc-situcao                           + chr(13) + chr(13).
                                END.
                            END.
                        END.
                    END.

                    IF c-dados-medicao <> "" THEN DO:
                        IF (LENGTH(ttPurchaseOrderLine.c-Text) + LENGTH(c-dados-medicao)) < 4000 THEN DO:
                            ASSIGN ttPurchaseOrderLine.c-Text = ttPurchaseOrderLine.c-Text + c-dados-medicao.
                        END.
                        ELSE DO:
                            ASSIGN ttPurchaseOrderLine.c-Text = ttPurchaseOrderLine.c-Text +
                                   "Esta requisiá∆o se refere a um contrato por mediá∆o ou evento, o detalhamento dessas informaá‰es pode ser consultado no ERP.".
                        END.
                    END.
                    ELSE
                        ASSIGN ttPurchaseOrderLine.c-Text = c-dados-c-text.
                END.
            END.

            FOR EACH prazo-compra NO-LOCK
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                 AND prazo-compra.situacao <> 4
                 AND prazo-compra.situacao <> 6:

                /*Maylon*/
                IF l-integra-portal THEN DO:
                    IF prazo-compra.data-entrega > LastDeliveryDate THEN
                        ASSIGN LastDeliveryDate = prazo-compra.data-entrega.
                END.

                FIND transporte NO-LOCK WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.

                ASSIGN i-ID = i-ID + 1.

                FIND FIRST tt-un WHERE tt-un.un = prazo-compra.un NO-LOCK NO-ERROR.

                CREATE ttDeliveryScheduleInforma_00.
                ASSIGN ttDeliveryScheduleInforma_00.ttDeliveryScheduleInforma_00ID = i-ID 
                       ttDeliveryScheduleInforma_00.DeliveryScheduleID             = prazo-compra.parcela
                       ttDeliveryScheduleInforma_00.ComponentSequenceNumber        = prazo-compra.sequencia
                       ttDeliveryScheduleInforma_00.ttPurchaseOrderLineID          = ttPurchaseOrderLine.ttPurchaseOrderLineID
                       ttDeliveryScheduleInforma_00.CarrierName                    = transporte.nome
                       ttDeliveryScheduleInforma_00.CarrierNumber                  = pedido-compr.cod-transp
                       ttDeliveryScheduleInforma_00.DeliveryDate                   = prazo-compra.data-entrega
                       ttDeliveryScheduleInforma_00.ItemReferenceCode              = prazo-compra.cod-refer
                       ttDeliveryScheduleInforma_00.ItemUnitOfMeasure              = IF AVAIL tt-un THEN tt-un.un ELSE prazo-compra.un
                       ttDeliveryScheduleInforma_00.POLineNumber                   = prazo-compra.numero-ordem
                       ttDeliveryScheduleInforma_00.Quantity                       = prazo-compra.quantidade
                       ttDeliveryScheduleInforma_00.RequisitionNumber              = ordem-compra.nr-requisicao
                       ttDeliveryScheduleInforma_00.ShipmentTermsCode              = IF ordem-compra.frete THEN "FOB" ELSE "CIF"
                       ttDeliveryScheduleInforma_00.ShippingMethodCode             = pedido-compr.via-transp

                       ttDeliveryScheduleInforma_00.OriginalQuantity	           = prazo-compra.quantid-orig
                       ttDeliveryScheduleInforma_00.BalanceQuantity 	           = prazo-compra.quant-saldo
                       ttDeliveryScheduleInforma_00.QuantityReturned	           = prazo-compra.quant-rejeit
                       ttDeliveryScheduleInforma_00.QuantityReceived	           = prazo-compra.quant-receb
                       ttDeliveryScheduleInforma_00.QuantityVendor	               = prazo-compra.qtd-do-forn
                       ttDeliveryScheduleInforma_00.VendorBalanceQuantity	       = prazo-compra.qtd-sal-forn
                       ttDeliveryScheduleInforma_00.QuantityReturnedVendor         = prazo-compra.qtd-rej-forn
                       ttDeliveryScheduleInforma_00.QuantityAllocatedVendor        = prazo-compra.qtd-rec-forn
                       ttDeliveryScheduleInforma_00.RequestDate	                   = prazo-compra.data-orig
                       ttDeliveryScheduleInforma_00.CustomerOrderNumber	           = prazo-compra.pedido-clien
                       ttDeliveryScheduleInforma_00.i-Status	                   = prazo-compra.situacao
                       ttDeliveryScheduleInforma_00.QuantityToOrder	               = prazo-compra.quant-a-ped
                       ttDeliveryScheduleInforma_00.QuantityToVendorOrder	       = prazo-compra.qtd-a-ped-forn
                       ttDeliveryScheduleInforma_00.Concentrate	                   = prazo-compra.concentracao
                       ttDeliveryScheduleInforma_00.Revenue	                       = prazo-compra.rendimento
                       ttDeliveryScheduleInforma_00.SequenceNumber	               = prazo-compra.nr-sequencia
                       ttDeliveryScheduleInforma_00.QuantityAllocatedOfVendor      = prazo-compra.qtd-aloc-forn
                       ttDeliveryScheduleInforma_00.QuantityAllocated              = prazo-compra.quant-alocada.
                       
            END.

            FOR EACH cotacao-item NO-LOCK
               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                 AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                 AND cotacao-item.it-codigo    = ordem-compra.it-codigo:
				 
                if l-integra-paradigma and not cotacao-item.cot-aprovada then next.

                FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = cotacao-item.usuario NO-ERROR.
                    
                ASSIGN i-ID = i-ID + 1.

                FIND FIRST tt-un WHERE tt-un.un = cotacao-item.un NO-LOCK NO-ERROR.

                CREATE ttQuotationLine.
                ASSIGN ttQuotationLine.ttQuotationLineID                = i-ID
                       ttQuotationLine.CurrencyID                       = cotacao-item.mo-codigo
                       ttQuotationLine.ValidityDays                     = cotacao-item.dias-validade
                       ttQuotationLine.ReadjustRatePercentage           = cotacao-item.valor-taxa
                       ttQuotationLine.DiscountAmount                   = cotacao-item.valor-descto
                       ttQuotationLine.DiscountPercentage               = cotacao-item.perc-descto
                       ttQuotationLine.FinancialRateDays                = cotacao-item.nr-dias-taxa
                       ttQuotationLine.FinancialRatePercentage          = cotacao-item.valor-taxa
                       ttQuotationLine.IndustrializedProductTaxPerce    = cotacao-item.aliquota-ipi 
                       ttQuotationLine.ServicesAndProductsCirculatio_00 = cotacao-item.aliquota-icm 
                       ttQuotationLine.ServicesAndProductsCirculatio_01 = cotacao-item.codigo-icm
                       ttQuotationLine.ServiceTaxPercentage             = cotacao-item.aliquota-iss
                       ttQuotationLine.QuoteSequence                    = cotacao-item.seq-cotac
                       ttQuotationLine.FreightValue                     = cotacao-item.valor-frete
                       ttQuotationLine.NetUnitaryPrice                  = cotacao-item.preco-unit 
                       ttQuotationLine.VendorUnitaryPrice               = cotacao-item.pre-unit-for
                       ttQuotationLine.VendorPrice                      = cotacao-item.preco-fornec
                       ttQuotationLine.ApprovalReason                   = cotacao-item.motivo-apr 
                       ttQuotationLine.ApproverID                       = cotacao-item.aprovador 
                       ttQuotationLine.Buyer                            = cotacao-item.cod-comprado
                       ttQuotationLine.CarrierID                        = cotacao-item.cod-transp
                       ttQuotationLine.DeliveryTerm                     = cotacao-item.prazo-entreg 
                       ttQuotationLine.IsFinancialRateIncluded          = cotacao-item.taxa-financ
                       ttQuotationLine.IsFreightIncluded                = cotacao-item.frete
                       ttQuotationLine.IsIndustrializedProductTaxInc_00 = cotacao-item.codigo-ipi
                       ttQuotationLine.IsQuoteApproved                  = cotacao-item.cot-aprovada      
                       ttQuotationLine.ItemCode                         = cotacao-item.it-codigo
                       ttQuotationLine.PaymentPlanCode                  = cotacao-item.cod-cond-pag
                       ttQuotationLine.POLineNumber                     = cotacao-item.numero-ordem      
                       ttQuotationLine.PriceTableNumber                 = cotacao-item.nr-tab
                       ttQuotationLine.QuotationDate                    = cotacao-item.data-cotacao      
                       ttQuotationLine.QuoteText                        = cotacao-item.narrativa         
                       ttQuotationLine.ReadjustQuote                    = cotacao-item.reajusta-cotacao                             
                       ttQuotationLine.UnitOfMeasureCode                = IF AVAIL tt-un THEN tt-un.un ELSE cotacao-item.un 
                       ttQuotationLine.UpdateDate                       = cotacao-item.data-atualiz
                       ttQuotationLine.UpdateTime                       = cotacao-item.hora-atualiz
                       ttQuotationLine.cUserID                          = cotacao-item.usuario           
                       ttQuotationLine.UserName                         = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
                       ttQuotationLine.VendorNumber                     = cotacao-item.cod-emitente
                       ttQuotationLine.ImporSystem                      = INTEGER(SUBSTRING(cotacao-item.char-2,61,2)).

                IF  l-integra-paradigma THEN DO: /* Se for processo com a Paradigma */
                    IF (item.tipo-contr = 4 OR
                        item.it-codigo = "":U) THEN DO:
                        FIND FIRST prazo-compra NO-LOCK
                             WHERE prazo-compra.numero-ordem = ttQuotationLine.POLineNumber NO-ERROR.

                        IF ttQuotationLine.UnitOfMeasureCode <> prazo-compra.un THEN DO:
                            FIND FIRST tab-conv-un NO-LOCK
                                 WHERE tab-conv-un.un = prazo-compra.un
                                   AND tab-conv-un.unid-med-for = ttQuotationLine.UnitOfMeasureCode NO-ERROR.
                    
                            ASSIGN de-indice = IF AVAIL tab-conv-un THEN
                                                   tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec)
                                               ELSE 1.
                        END.
                        ELSE 
                            ASSIGN de-indice = 1.
                    END.
                    ELSE DO:
                        FIND FIRST item-fornec NO-LOCK
                             WHERE item-fornec.it-codigo    = ttQuotationLine.ItemCode
                               AND item-fornec.cod-emitente = ttQuotationLine.VendorNumber NO-ERROR.

                        ASSIGN de-indice = IF AVAIL item-fornec THEN
                                               item-fornec.fator-conver / exp(10, item-fornec.num-casa-dec)
                                           ELSE 1.
                    END.
                    ASSIGN ttQuotationLine.VendorPrice     = ttQuotationLine.VendorPrice * de-indice
                           ttPurchaseOrderLine.VendorPrice = ttQuotationLine.VendorPrice.
                END.

                IF l-integra-portal OR l-integra-paradigma THEN DO:
                    run ccp/ccapi341.p (input  cotacao-item.numero-ordem,
                                        input  cotacao-item.cod-emitente,
                                        input  cotacao-item.seq-cotac,
                                        input  cotacao-item.it-codigo,
                                        output ttQuotationLine.NetUnitaryPrice).
                END.
				
                IF l-integra-paradigma THEN do:
                    /* Soma de todos os preco-fornec retirando o desconto */
                    assign ttPurchaseOrder.TotalValue = ttPurchaseOrder.TotalValue + ((ttQuotationLine.VendorPrice - ((ttQuotationLine.VendorPrice * ttQuotationLine.DiscountPercentage) / 100)) * ttPurchaseOrderLine.QuantityRequested).

                    assign &IF "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                                ttQuotationLine.QuotationNumberPortal      = substring(cotacao-item.char-2,174,50)
                                ttQuotationLine.QuotationItemNumberPortal  = substring(cotacao-item.char-2,274,50).
                           &ELSE
                                ttQuotationLine.QuotationNumberPortal      = cotacao-item.cod-cotac-portal.
                                ttQuotationLine.QuotationItemNumberPortal  = cotacao-item.cod-item-cotac-portal.
                           &ENDIF

                    find first b-cotacao-item exclusive-lock
                         where b-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                           and b-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                           and b-cotacao-item.seq-cotac    = cotacao-item.seq-cotac
                           and b-cotacao-item.it-codigo    = cotacao-item.it-codigo no-error.
                    if avail b-cotacao-item then do:
                        assign &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                                    overlay(b-cotacao-item.char-2,157,17) = STRING(ttQuotationLine.NetUnitaryPrice).
                               &ELSE
                                    b-cotacao-item.val-preco-liq-item = ttQuotationLine.NetUnitaryPrice.
                               &ENDIF
                    end.
                    RELEASE b-cotacao-item.
                end.

                IF param-global.modulo-07 AND CONNECTED("mgcex":U) THEN DO:

                    FIND emitente NO-LOCK WHERE emitente.cod-emitente = INTEGER(SUBSTRING(cotacao-item.char-2,41,9)) NO-ERROR.

                    FIND classif-fisc NO-LOCK WHERE classif-fisc.class-fiscal = SUBSTRING(cotacao-item.char-1,81,8) NO-ERROR.

                    FIND FIRST pais NO-LOCK 
                         WHERE pais.cod-pais = cotacao-item.cdn-pais-orig NO-ERROR.

                    ASSIGN i-ID = i-ID + 1.

                    CREATE ttImportInformation.
                    ASSIGN ttImportInformation.ttImportInformationID           = i-ID
                           ttImportInformation.ControlPoint                    = INTEGER(SUBSTRING(cotacao-item.char-1,41,5))
                           ttImportInformation.CountryCode                     = cotacao-item.cdn-pais-orig
                           ttImportInformation.ImportationTaxPercentage        = DEC(SUBSTRING(cotacao-item.char-1,61,6))
                           ttImportInformation.QuoteMap                        = SUBSTRING(cotacao-item.char-1,1,2)
                           ttImportInformation.ttQuotationLineID               = ttQuotationLine.ttQuotationLineID
                           ttImportInformation.CountryName                     = IF AVAIL pais THEN pais.nome-pais ELSE ""
                           ttImportInformation.DeliveryDate                    = cotacao-item.dt-entrega
                           ttImportInformation.FiscalClassificationDescription = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE ""
                           ttImportInformation.FiscalClassificationID          = SUBSTRING(cotacao-item.char-1,81,10)
                           ttImportInformation.Incoterm                        = SUBSTRING(cotacao-item.char-1,21,3)
                           ttImportInformation.ItineraryCode                   = cotacao-item.int-1
                           ttImportInformation.ManufacturerName                = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                           ttImportInformation.ManufacturerNumber              = INTEGER(SUBSTRING(cotacao-item.char-2,41,9))
                           ttImportInformation.ShipmentDate                    = DATE(SUBSTRING(cotacao-item.char-2,81,8)).


                END.
            END.
        END.

        FIND FIRST processo-imp NO-LOCK WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-ERROR.
        IF AVAIL processo-imp THEN DO:
        
            FIND estabelec NO-LOCK WHERE estabelec.cod-estabel = processo-imp.cod-estabel NO-ERROR.
        
            FIND bf-estab-fisc NO-LOCK WHERE bf-estab-fisc.cod-estabel = processo-imp.estab-fisc NO-ERROR.
        
            CREATE ttImportProcess.
            ASSIGN ttImportProcess.LetterOfCredit                = processo-imp.carta-credito
                   ttImportProcess.ImportStockBrokerExchange     = processo-imp.cdn-corretor-cambio-import
                   ttImportProcess.ImportStockBroker             = processo-imp.cdn-corretor-import
                   ttImportProcess.ImportForwardingAgentExtern   = processo-imp.cdn-despa-exter-import
                   ttImportProcess.ImportInsuranceCode	         = processo-imp.cdn-segurad-import
                   ttImportProcess.CheckSum	                     = processo-imp.check-sum
                   ttImportProcess.Agent                         = processo-imp.cod-agente
                   ttImportProcess.BankCode	                     = processo-imp.cod-banco
                   ttImportProcess.ShippedCode	                 = processo-imp.cod-consignatario
                   ttImportProcess.ForwardingAgent	             = processo-imp.cod-despachante
                   ttImportProcess.SiteId	                     = processo-imp.cod-estabel
                   ttImportProcess.SiteName	                     = IF AVAIL estabelec THEN estabelec.nome ELSE ""
                   ttImportProcess.ExportCode                    = processo-imp.cod-exportador
                   ttImportProcess.ManufacturingCode	         = processo-imp.cod-fabricante
                   ttImportProcess.LanguageCode	                 = processo-imp.cod-idioma
                   ttImportProcess.Incoterm	                     = processo-imp.cod-incoterm
                   ttImportProcess.ItineraryCode	             = processo-imp.cod-itiner
                   ttImportProcess.MessageCode	                 = processo-imp.cod-mensagem
                   ttImportProcess.ProductShippingCode	         = processo-imp.cod-transportador
                   ttImportProcess.ExchangeContract	             = processo-imp.contrato-cambio
                   ttImportProcess.ImportDeclaration	         = processo-imp.declaracao-import
                   ttImportProcess.DocumentationTarget	         = processo-imp.destino-documentacao
                   ttImportProcess.LibertyDate	                 = processo-imp.dt-autorizacao
                   ttImportProcess.PrintDate	                 = processo-imp.dt-emissao
                   ttImportProcess.IntroduceDate	             = processo-imp.dt-implantacao
                   ttImportProcess.FiscalSiteId	                 = processo-imp.estab-fisc
                   ttImportProcess.FiscalSiteName	             = IF AVAIL bf-estab-fisc THEN bf-estab-fisc.nome ELSE ""
                   ttImportProcess.ImportLicense	             = processo-imp.licenca-import
                   ttImportProcess.OriginalMarket	             = processo-imp.merc-orig
                   ttImportProcess.Comments	                     = processo-imp.narrativa
                   ttImportProcess.AcquirementsNumber	         = processo-imp.nr-conhecimento
                   ttImportProcess.ImportProcessNumber	         = processo-imp.nr-proc-imp
                   ttImportProcess.RofNumber	                 = processo-imp.nr-rof
                   ttImportProcess.PONumber_01                   = processo-imp.num-pedido
                   ttImportProcess.ModeImport	                 = processo-imp.regime-import
                   ttImportProcess.iStatus	                     = processo-imp.situacao
                   ttImportProcess.MessageDescription	         = processo-imp.texto-mensag
                   ttImportProcess.ProductShipShippingMethodCode = processo-imp.via-transp.
        END.

        FIND cond-especif NO-LOCK WHERE cond-especif.num-pedido = pedido-compr.num-pedido NO-ERROR.
        IF AVAIL cond-especif THEN DO:
        
            DO i-cont = 1 TO 12:
        
                ASSIGN i-ID = i-ID + 1.
        
                IF cond-especif.data-pagto[i-cont] <> ? AND cond-especif.perc-pagto[i-cont] > 0 THEN DO:
                    CREATE ttSpecificPaymentCondition.               
                    ASSIGN ttSpecificPaymentCondition.ttSpecificPaymentConditionID = i-ID
                           ttSpecificPaymentCondition.PONumber       = cond-especif.num-pedido
                           ttSpecificPaymentCondition.checkSum       = cond-especif.check-sum                               
                           ttSpecificPaymentCondition.contractNumber = cond-especif.nr-contrato
                           ttSpecificPaymentCondition.comment        = cond-especif.comentarios[i-cont]
                           ttSpecificPaymentCondition.paymentDate    = cond-especif.data-pagto[i-cont]
                           ttSpecificPaymentCondition.paymentPercent = cond-especif.perc-pagto[i-cont].
                END.        
            END.
        END.        
    END.

    RUN PIUpsert (INPUT  "":U,                                                                       
                  INPUT  "upd":U,                                   
                  INPUT  TABLE ttPurchaseOrder,                     
                  INPUT  TABLE ttPurchaseOrderLine,                 
                  INPUT  TABLE ttDeliveryScheduleInforma_00,        
                  INPUT  TABLE ttQuotationLine,   
                  INPUT  TABLE ttImportInformation,
                  INPUT  TABLE ttSpecificPaymentCondition,
                  INPUT  TABLE ttImportProcess,
                  OUTPUT TABLE tt_log_erro).                        
                                                                          
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

