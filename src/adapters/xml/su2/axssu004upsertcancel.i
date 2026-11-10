PROCEDURE PITransUpsertCancel:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAMETER rw-pedido-compr AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/


                                              
    /*LOCAL VARIABLES - BEGIN*/
    DEFINE BUFFER bf-estabgestor FOR estabelec.
    DEFINE BUFFER bf-estab-cob   FOR estabelec.
    DEFINE BUFFER bf-estab-ent   FOR estabelec.
    DEFINE BUFFER bf-estab-fisc  FOR estabelec.
    DEFINE VAR i-cont AS INTEGER NO-UNDO.
    DEFINE VAR i-ID   AS INTEGER NO-UNDO.
    /*LOCAL VARIABLES - END*/


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

        FIND FIRST param-global NO-LOCK NO-ERROR.

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
               ttPurchaseOrder.StatusPO              = pedido-compr.situacao
               ttPurchaseOrder.SiteDescription       = IF AVAIL estabelec      THEN estabelec.nome           ELSE ""
               ttPurchaseOrder.SiteDescription_00    = IF AVAIL bf-estabgestor THEN bf-estabgestor.nome      ELSE ""
               ttPurchaseOrder.SiteID                = pedido-compr.cod-estabel
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
               ttPurchaseOrder.CountryCode_01        = IF AVAIL emitente       THEN emitente.pais            ELSE ""
               ttPurchaseOrder.PurchaseDate          = pedido-compr.data-pedido. /* --- Knupp - Alteracoes para envio da data do pedido na chave do SGT --- */
            IF pedido-compr.emergencial THEN
                ASSIGN ttPurchaseOrder.Emergency     = 1.
            ELSE  
                ASSIGN ttPurchaseOrder.Emergency     = 0.

        ASSIGN i-ID = 0.
        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
             AND ordem-compra.situacao <> 6:

            FIND FIRST cont-emit NO-LOCK WHERE cont-emit.nome = ordem-compra.contato NO-ERROR.

            FIND item NO-LOCK WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

            ASSIGN i-ID = i-ID + 1.

            CREATE ttPurchaseOrderLine. 
            ASSIGN ttPurchaseOrderLine.ttPurchaseOrderLineID   = i-ID
                   ttPurchaseOrderLine.CurrencyId              = ordem-compra.mo-codigo
                   ttPurchaseOrderLine.ItemCode                = ordem-compra.it-codigo
                   ttPurchaseOrderLine.ItemDescription         = IF AVAIL item THEN item.desc-item ELSE ""
                   ttPurchaseOrderLine.ItemReferenceCode       = ordem-compra.cod-refer
                   ttPurchaseOrderLine.POLineNumber            = ordem-compra.numero-ordem
                   ttPurchaseOrderLine.PONumber                = ordem-compra.num-pedido
                   ttPurchaseOrderLine.statusID                = ordem-compra.situacao
                   ttPurchaseOrderLine.VendorUnitaryPrice      = ordem-compra.pre-unit-for
                   ttPurchaseOrderLine.ContactName_01          = ordem-compra.contato
                   ttPurchaseOrderLine.ContactNumber           = IF AVAIL cont-emit THEN cont-emit.cod-emitente ELSE 0
                   ttPurchaseOrderLine.EmailAddress_01         = IF AVAIL cont-emit THEN cont-emit.e-mail       ELSE ""
                   ttPurchaseOrderLine.TelephoneNumber_01      = IF AVAIL cont-emit THEN cont-emit.telefone     ELSE "".

            FOR EACH prazo-compra NO-LOCK
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                 AND prazo-compra.situacao <> 4
                 AND prazo-compra.situacao <> 6:

                FIND transporte NO-LOCK WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.

                ASSIGN i-ID = i-ID + 1.

                CREATE ttDeliveryScheduleInforma_00.
                ASSIGN ttDeliveryScheduleInforma_00.ttDeliveryScheduleInforma_00ID = i-ID 
                       ttDeliveryScheduleInforma_00.DeliveryScheduleID             = prazo-compra.parcela
                       ttDeliveryScheduleInforma_00.ComponentSequenceNumber        = prazo-compra.sequencia
                       ttDeliveryScheduleInforma_00.ttPurchaseOrderLineID          = ttPurchaseOrderLine.ttPurchaseOrderLineID
                       ttDeliveryScheduleInforma_00.CarrierName                    = transporte.nome
                       ttDeliveryScheduleInforma_00.CarrierNumber                  = pedido-compr.cod-transp
                       ttDeliveryScheduleInforma_00.DeliveryDate                   = prazo-compra.data-entrega
                       ttDeliveryScheduleInforma_00.ItemReferenceCode              = prazo-compra.cod-refer
                       ttDeliveryScheduleInforma_00.ItemUnitOfMeasure              = prazo-compra.un
                       ttDeliveryScheduleInforma_00.POLineNumber                   = prazo-compra.numero-ordem
                       ttDeliveryScheduleInforma_00.Quantity                       = prazo-compra.quantidade
                       ttDeliveryScheduleInforma_00.RequisitionNumber              = ordem-compra.nr-requisicao
                       ttDeliveryScheduleInforma_00.ShipmentTermsCode              = IF ordem-compra.frete THEN "FOB" ELSE "CIF"
                       ttDeliveryScheduleInforma_00.ShippingMethodCode             = pedido-compr.via-transp.
                       
            END.

            FOR EACH cotacao-item NO-LOCK
               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                 AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                 AND cotacao-item.it-codigo    = ordem-compra.it-codigo:

                FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = cotacao-item.usuario NO-ERROR.
                    
                ASSIGN i-ID = i-ID + 1.

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
                       ttQuotationLine.UnitOfMeasureCode                = cotacao-item.un
                       ttQuotationLine.UpdateDate                       = cotacao-item.data-atualiz
                       ttQuotationLine.UpdateTime                       = cotacao-item.hora-atualiz
                       ttQuotationLine.cUserID                          = cotacao-item.usuario           
                       ttQuotationLine.UserName                         = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
                       ttQuotationLine.VendorNumber                     = cotacao-item.cod-emitente
                       ttQuotationLine.ImporSystem                      = INTEGER(SUBSTRING(cotacao-item.char-2,61,2)).


                IF param-global.modulo-07 AND CONNECTED("mgcex":U) THEN DO:

                    FIND emitente NO-LOCK WHERE emitente.cod-emitente = INTEGER(SUBSTRING(cotacao-item.char-2,41,9)) NO-ERROR.

                    FIND classif-fisc NO-LOCK WHERE classif-fisc.class-fiscal = SUBSTRING(cotacao-item.char-1,81,8) NO-ERROR.

                &if "{&bf_mat_versao_ems}" >= "2.062" &then
                    FIND FIRST pais NO-LOCK 
                         WHERE pais.cod-pais = cotacao-item.cdn-pais-orig NO-ERROR.
                &endif

                    ASSIGN i-ID = i-ID + 1.

                    CREATE ttImportInformation.
                    ASSIGN ttImportInformation.ttImportInformationID           = i-ID
                           ttImportInformation.ControlPoint                    = INTEGER(SUBSTRING(cotacao-item.char-1,41,5))
                           ttImportInformation.ImportationTaxPercentage        = DEC(SUBSTRING(cotacao-item.char-1,61,6))
                           ttImportInformation.QuoteMap                        = SUBSTRING(cotacao-item.char-1,1,2)
                           ttImportInformation.ttQuotationLineID               = ttQuotationLine.ttQuotationLineID
                           ttImportInformation.CountryName                     = IF AVAIL pais THEN pais.nome-pais ELSE ""
                           ttImportInformation.FiscalClassificationDescription = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE ""
                           ttImportInformation.FiscalClassificationID          = SUBSTRING(cotacao-item.char-1,81,10)
                           ttImportInformation.Incoterm                        = SUBSTRING(cotacao-item.char-1,21,3)
                           ttImportInformation.ItineraryCode                   = cotacao-item.int-1
                           ttImportInformation.ManufacturerName                = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                           ttImportInformation.ManufacturerNumber              = INTEGER(SUBSTRING(cotacao-item.char-2,41,9))
                           ttImportInformation.ShipmentDate                    = DATE(SUBSTRING(cotacao-item.char-2,81,8)).

                    &if "{&bf_mat_versao_ems}" >= "2.062" &then
                        ASSIGN ttImportInformation.CountryCode                 = cotacao-item.cdn-pais-orig
                               ttImportInformation.DeliveryDate                = cotacao-item.dt-entrega
                    &endif

                END.
            END.
        END.

        IF param-global.modulo-07 AND CONNECTED("mgcex":U) THEN DO:
            RUN imp/im0004.p (INPUT pedido-compr.num-pedido,
                              OUTPUT TABLE ttImportProcess).

            FIND FIRST ttImportProcess NO-ERROR.

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


