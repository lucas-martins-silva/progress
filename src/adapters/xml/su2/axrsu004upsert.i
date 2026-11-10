/* Aceite/Recusa de fornecedor - Paradigma */
{adapters/xml/su2/axrsu004.i10}

IF SEARCH("ccp/ccapi303.r":U) <> ? THEN DO:
    
    /* Integraá∆o com o portal de compras */
    {adapters/xml/su2/axrsu004.i}
	
    FIND FIRST tt-pedido-compr
         WHERE tt-pedido-compr.num-pedido = PONumber EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-pedido-compr THEN DO:
        CREATE tt-pedido-compr.
        ASSIGN tt-pedido-compr.num-pedido   = PONumber
               tt-pedido-compr.cod-estabel  = siteid
               tt-pedido-compr.situacao     = Status_00
               tt-pedido-compr.comentarios  = Comment
               tt-pedido-compr.end-entrega  = FromRoleSiteId
               tt-pedido-compr.end-cobranca = BillToSiteId
               tt-pedido-compr.responsavel  = FromRoleContactName
               tt-pedido-compr.cod-cond-pag = PaymentCode
               tt-pedido-compr.cod-estab-gestor = ManagerSiteID
               tt-pedido-compr.data-pedido  = PurchaseDate
               tt-pedido-compr.emergencial  = IF Emergency = 1 THEN YES ELSE NO
               tt-pedido-compr.l-tipo-ped   = OrderTypeCode
               tt-pedido-compr.cod-emitente = VendorNumber.

    END.

    IF cTranAction = "add" THEN
        ASSIGN tt-pedido-compr.ind-tipo-movto = 1.
    ELSE IF cTranAction = "upd" THEN
        ASSIGN tt-pedido-compr.ind-tipo-movto = 2.
    ELSE DO:
        ASSIGN tt-pedido-compr.ind-tipo-movto = 3.

        /*Seta motivo padr∆o para eliminaá∆o de pedido via Integraá∆o*/
        {utp/ut-liter.i "ELIMINADO VIA INTEGRAÄ«O"}
        ASSIGN tt-pedido-compr.mot-elimina = RETURN-VALUE.
    END.
    
    /* Integraá∆o com o portal de compras */
    RUN pi-seta-dados-portal.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
    
    FOR EACH  ttPurchaseOrderLine
        WHERE ttPurchaseOrderLine.PONumber  = tt-pedido-compr.num-pedido:

        IF ttPurchaseOrderLine.RequisitionNumber = ? THEN
           ASSIGN ttPurchaseOrderLine.RequisitionNumber = 0.

        IF ttPurchaseOrderLine.RequisitionLineSequence = ? THEN
           ASSIGN ttPurchaseOrderLine.RequisitionLineSequence = 0.

        IF CAN-FIND (FIRST it-requisicao
                     WHERE it-requisicao.nr-requisicao  = ttPurchaseOrderLine.RequisitionNumber
                     AND   it-requisicao.sequencia      = ttPurchaseOrderLine.RequisitionLineSequence 
                     AND   it-requisicao.numero-ordem  <> 0)  THEN DO:
            
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-sequencia AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Sequencia" *}
               ASSIGN c-lbl-liter-sequencia = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-da-requisicao AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "da_requisiá∆o" *}
               ASSIGN c-lbl-liter-da-requisicao = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-ja-esta-relacionada-uma-ordem AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "j†_est†_relacionada_uma_ordem_de_compra" *}
               ASSIGN c-lbl-liter-ja-esta-relacionada-uma-ordem = TRIM(RETURN-VALUE).
               run utp/ut-msgs.p (INPUT 'msg',
                                  INPUT 17006,
                                  INPUT c-lbl-liter-sequencia + ' ' + string(ttPurchaseOrderLine.RequisitionLineSequence)  + ' ' + c-lbl-liter-da-requisicao + ' ' + string(ttPurchaseOrderLine.RequisitionNumber) + ' ' + c-lbl-liter-ja-esta-relacionada-uma-ordem).
    
              CREATE tt_log_erro.                  
              ASSIGN tt_log_erro.ttv_num_cod_erro = 17006
                     tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).

              RETURN "NOK":U.
        END.

        RUN pi-validate-ordem-compra.
        IF RETURN-VALUE = "NOK" THEN
            RETURN "NOK".
   
        FIND FIRST tt-ordem-compra
             WHERE tt-ordem-compra.num-pedido   = ttPurchaseOrderLine.PONumber
             AND   tt-ordem-compra.numero-ordem = ttPurchaseOrderLine.POLineNumber NO-ERROR.
        IF NOT AVAIL tt-ordem-compra THEN DO:
           CREATE tt-ordem-compra.

           IF l-integra-webb THEN DO:
               BUFFER-COPY ordem-compra TO tt-ordem-compra.

               ASSIGN tt-ordem-compra.num-pedido    = ttPurchaseOrderLine.PONumber           
                      tt-ordem-compra.cod-emitente  = tt-pedido-compr.cod-emitente. 
           END. 
           ELSE DO:
               ASSIGN tt-ordem-compra.num-pedido    = ttPurchaseOrderLine.PONumber     
                      tt-ordem-compra.numero-ordem  = ttPurchaseOrderLine.POLineNumber 
                      tt-ordem-compra.cod-emitente  = tt-pedido-compr.cod-emitente
                      tt-ordem-compra.it-codigo     = ttPurchaseOrderLine.ItemCode
                      tt-ordem-compra.cod-estabel   = tt-pedido-compr.cod-estabel
                      tt-ordem-compra.cod-estab-gestor = tt-pedido-compr.cod-estab-gestor.
           END.
        END.
  
        ASSIGN
        &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
        	OVERLAY(tt-ordem-compra.char-1,92,50) 	= ttPurchaseOrderLine.POLineNumberPortal
        &ELSE
        	tt-ordem-compra.cod-ord-portal          = ttPurchaseOrderLine.POLineNumberPortal
        &ENDIF
        .
   
        FIND FIRST item-uni-estab
             WHERE item-uni-estab.cod-estabel = tt-ordem-compra.cod-estabel
             AND   item-uni-estab.it-codigo   = tt-ordem-compra.it-codigo  NO-LOCK NO-ERROR.
        IF AVAIL item-uni-estab THEN DO:
             IF NOT l-integra-webb THEN DO:
                ASSIGN tt-ordem-compra.cod-comprado = item-uni-estab.cod-comprado
                       tt-ordem-compra.dep-almoxar  = item-uni-estab.deposito-pad.
             END.
        END.
    
        IF l-integra-webb THEN DO:
            IF cTranAction = "add":U THEN DO:
                ASSIGN tt-ordem-compra.ind-tipo-movto = 2
                       tt-ordem-compra.situacao       = 5
                       tt-ordem-compra.data-cotacao   = TODAY.
            END.
            ELSE DO:
                ASSIGN tt-ordem-compra.ind-tipo-movto = 2
                       tt-ordem-compra.data-cotacao   = TODAY.
            END.
        END.      
        ELSE DO:
            ASSIGN tt-ordem-compra.mo-codigo        = ttPurchaseOrderLine.CurrencyId   
                   tt-ordem-compra.cod-refer        = ttPurchaseOrderLine.ItemReferenceCode
                   tt-ordem-compra.situacao         = 2
                   tt-ordem-compra.contato          = ttPurchaseOrderLine.VendorContactName
                   tt-ordem-compra.pre-unit-for     = ttPurchaseOrderLine.VendorUnitPrice
                   tt-ordem-compra.preco-fornec     = ttPurchaseOrderLine.VendorUnitPrice
                   tt-ordem-compra.preco-unit       = ttPurchaseOrderLine.VendorUnitPrice
                   tt-ordem-compra.preco-orig       = ttPurchaseOrderLine.VendorUnitPrice
                   tt-ordem-compra.data-cotacao     = TODAY
                   tt-ordem-compra.nr-requisicao    = ttPurchaseOrderLine.RequisitionNumber      
                   tt-ordem-compra.sequencia        = ttPurchaseOrderLine.RequisitionLineSequence
                   tt-ordem-compra.aliquota-ipi     = 0
                   tt-ordem-compra.aliquota-icm     = 0
                   tt-ordem-compra.aliquota-iss     = 0
                   tt-ordem-compra.ind-tipo-movto   = tt-pedido-compr.ind-tipo-movto			   			   
    			   .
        END.

        IF ttPurchaseOrderLine.RequisitionNumber  <> 0 THEN DO:
            FIND FIRST requisicao
                 WHERE requisicao.nr-requisicao = ttPurchaseOrderLine.RequisitionNumber NO-LOCK NO-ERROR.
            IF AVAIL requisicao THEN DO:
                ASSIGN tt-pedido-compr.end-entrega = requisicao.cod-estabel.
    
                FIND FIRST it-requisicao NO-LOCK
                     WHERE it-requisicao.nr-requisicao = tt-ordem-compra.nr-requisicao
                     AND   it-requisicao.sequencia     = tt-ordem-compra.sequencia NO-ERROR.
                IF NOT AVAIL it-requisicao THEN DO:
                
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-sequencia-do-item-da-ordem-de AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Sequencia_do_Item_da_ordem_de_compra" *}
                    ASSIGN c-lbl-liter-sequencia-do-item-da-ordem-de = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-nao-pertence-a-requisicao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "n∆o_pertence_a_requisicao" *}
                    ASSIGN c-lbl-liter-nao-pertence-a-requisicao = TRIM(RETURN-VALUE).
                    run utp/ut-msgs.p (INPUT 'msg',
                                       INPUT 17006,
                                       INPUT c-lbl-liter-sequencia-do-item-da-ordem-de + ' ' + string(tt-ordem-compra.sequencia)  + ' ' + c-lbl-liter-nao-pertence-a-requisicao + ' ' + STRING(tt-ordem-compra.nr-requisicao)).
            
                    CREATE tt_log_erro.                  
                    ASSIGN tt_log_erro.ttv_num_cod_erro = 17006
                           tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).

                    RETURN "NOK":U.
                END.
                ELSE DO:
                    IF it-requisicao.it-codigo <> tt-ordem-compra.it-codigo THEN DO:
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-item-da-ordem-de-compra AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "Item_da_ordem_de_compra" *}
                       ASSIGN c-lbl-liter-item-da-ordem-de-compra = TRIM(RETURN-VALUE).
                       DEFINE VARIABLE c-lbl-liter-nao-pertence-a-requisicao-2 AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "n∆o_pertence_a_requisiá∆o" *}
                       ASSIGN c-lbl-liter-nao-pertence-a-requisicao-2 = TRIM(RETURN-VALUE).
                       run utp/ut-msgs.p (INPUT 'msg',
                                          INPUT 17006,
                                          INPUT c-lbl-liter-item-da-ordem-de-compra + ' ' + tt-ordem-compra.it-codigo  + ' ' + c-lbl-liter-nao-pertence-a-requisicao-2 + ' ' + STRING(tt-ordem-compra.nr-requisicao)).
            
                       CREATE tt_log_erro.                  
                       ASSIGN tt_log_erro.ttv_num_cod_erro = 17006
                              tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).

                       RETURN "NOK":U.
                    END.
                
                    ASSIGN tt-ordem-compra.ct-codigo = it-requisicao.ct-codigo
                           tt-ordem-compra.sc-codigo = it-requisicao.sc-codigo.
                END.
                ASSIGN tt-ordem-compra.requisitante = requisicao.nome-abrev WHEN AVAIL requisicao.
            END.
            ELSE DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-requisicao AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Requisiá∆o" *}
                 ASSIGN c-lbl-liter-requisicao = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-nao-esta-cadastrada-no-requisi AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "n∆o_est†_cadastrada_no_requisicao_EMS" *}
                 ASSIGN c-lbl-liter-nao-esta-cadastrada-no-requisi = TRIM(RETURN-VALUE).
                 run utp/ut-msgs.p (INPUT 'msg',
                                    INPUT 17006,
                                    INPUT c-lbl-liter-requisicao + ' ' + string(ttPurchaseOrderLine.RequisitionNumber) + ' ' + c-lbl-liter-nao-esta-cadastrada-no-requisi).

                 CREATE tt_log_erro.                  
                 ASSIGN tt_log_erro.ttv_num_cod_erro = 17006
                        tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).

                 RETURN "NOK":U.
            END.
        END.

        FIND FIRST item-uni-estab
             WHERE item-uni-estab.cod-estabel = tt-ordem-compra.cod-estabel
             AND   item-uni-estab.it-codigo   = tt-ordem-compra.it-codigo  NO-LOCK NO-ERROR.
        IF AVAIL item-uni-estab THEN DO:
        
            IF NOT l-integra-webb THEN DO:
                 ASSIGN tt-ordem-compra.cod-comprado = item-uni-estab.cod-comprado
                        tt-ordem-compra.dep-almoxar  = item-uni-estab.deposito-pad.
            END.
        END.

        IF NOT l-integra-webb THEN
            ASSIGN tt-pedido-compr.responsavel = tt-ordem-compra.cod-comprado.

        FIND FIRST requisicao
             WHERE requisicao.nr-requisicao = ttPurchaseOrderLine.RequisitionNumber  EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL requisicao THEN DO:
            IF CAN-FIND (FIRST it-requisicao
                         WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao 
                         AND   it-requisicao.situacao      = 1) THEN
                ASSIGN requisicao.situacao = 1.
            ELSE
                ASSIGN requisicao.situacao = 4.
    
        END.
 
        FOR EACH  ttDeliveryScheduleInforma_00
            WHERE ttDeliveryScheduleInforma_00.POLineNumber = ttPurchaseOrderLine.POLineNumber:
    
            IF l-integra-webb THEN DO:

                RUN pi-seta-dados-parcela.

                IF RETURN-VALUE = "NOK" THEN
                    RETURN "NOK".
            END.
            ELSE DO:
                FIND FIRST tt-prazo-compra
                     WHERE tt-prazo-compra.numero-ordem = ttDeliveryScheduleInforma_00.POLineNumber       
                     AND   tt-prazo-compra.parcela      = ttDeliveryScheduleInforma_00.DeliveryScheduleID  NO-ERROR.
                IF NOT AVAIL tt-prazo-compra THEN DO:
                    CREATE tt-prazo-compra.
                    ASSIGN tt-prazo-compra.numero-ordem            = ttDeliveryScheduleInforma_00.POLineNumber      
                           tt-prazo-compra.parcela                 = ttDeliveryScheduleInforma_00.DeliveryScheduleID.
                END.
                ASSIGN tt-prazo-compra.situacao      =  2
                       tt-prazo-compra.sequencia     =  ttDeliveryScheduleInforma_00.ComponentSequenceNumber
                       tt-prazo-compra.data-entrega  =  ttDeliveryScheduleInforma_00.DeliveryDate
                       tt-prazo-compra.cod-refer     =  ttDeliveryScheduleInforma_00.ItemReferenceCode
                       tt-prazo-compra.un            =  ttDeliveryScheduleInforma_00.ItemUnitOfMeasure
                       tt-prazo-compra.quantidade    =  ttDeliveryScheduleInforma_00.Quantity
                       tt-prazo-compra.qtd-do-forn   =  ttDeliveryScheduleInforma_00.Quantity
                       tt-prazo-compra.quant-saldo   =  ttDeliveryScheduleInforma_00.Quantity
                       tt-prazo-compra.qtd-sal-forn  =  ttDeliveryScheduleInforma_00.Quantity
                       tt-pedido-compr.via-transp =  ttDeliveryScheduleInforma_00.ShippingMethodCode
                       tt-ordem-compra.frete      =  IF ttDeliveryScheduleInforma_00.ShipmentTermsCode  = 'yes' THEN YES ELSE NO
                       tt-prazo-compra.ind-tipo-movto = tt-pedido-compr.ind-tipo-movto.
            END.
        END.

        /* Integraá∆o com o portal de compras */
        RUN pi-seta-dados-cotacao-portal.
        IF RETURN-VALUE = "NOK" THEN
            RETURN "NOK".

        FOR EACH  ttQuotationLine
            WHERE ttQuotationLine.POLineNumber = ttPurchaseOrderLine.POLineNumber: 
    
            FIND FIRST tt-cotacao-item
                 WHERE tt-cotacao-item.numero-ordem = ttQuotationLine.POLineNumber            
                 AND   tt-cotacao-item.it-codigo    = ttQuotationLine.ItemCode NO-ERROR.
            IF NOT AVAIL tt-cotacao-item THEN DO:
    
                CREATE tt-cotacao-item. 
                ASSIGN tt-cotacao-item.numero-ordem             = ttQuotationLine.POLineNumber      
                       tt-cotacao-item.cod-emitente             = tt-pedido-compr.cod-emitente
                       tt-cotacao-item.it-codigo                = ttQuotationLine.ItemCode          
                       tt-cotacao-item.seq-cotac                = ttQuotationLine.QuoteSequence.
    
            END.

            /* Integraá∆o com o portal de compras */
            IF l-integra-webb THEN DO:

                RUN pi-valida-formatos.
                IF RETURN-VALUE = "NOK" THEN
                    RETURN "NOK".

                FIND FIRST cotacao-item WHERE cotacao-item.numero-ordem = ttQuotationLine.POLineNumber  AND
                                              cotacao-item.cod-emitente = tt-pedido-compr.cod-emitente  AND
                                              cotacao-item.seq-cotac    = ttQuotationLine.QuoteSequence AND
                                              cotacao-item.it-codigo    = ttQuotationLine.ItemCode NO-LOCK NO-ERROR.
            
                RUN pi-atualiza-dados-cotacao.

                IF RETURN-VALUE = "NOK" THEN
                    RETURN "NOK".
            END.
            ELSE DO: 
                ASSIGN tt-cotacao-item.motivo-apr       = ttQuotationLine.ApprovalReason
                       tt-cotacao-item.aprovador        = ttQuotationLine.ApproverID            
                       tt-cotacao-item.cod-comprado     = ttQuotationLine.Buyer                 
                       tt-cotacao-item.cod-transp       = ttQuotationLine.CarrierID
                       tt-cotacao-item.mo-codigo        = ttPurchaseOrderLine.CurrencyId
                       tt-ordem-compra.mo-codigo        = tt-cotacao-item.mo-codigo  
                       tt-cotacao-item.prazo-entreg     = ttQuotationLine.DeliveryTerm          
                       tt-cotacao-item.valor-descto     = ttQuotationLine.DiscountAmount        
                       tt-cotacao-item.perc-descto      = ttQuotationLine.DiscountPercentage   
                       tt-cotacao-item.nr-dias-taxa     = ttQuotationLine.FinancialRateDays      
                       tt-cotacao-item.valor-taxa       = ttQuotationLine.FinancialRatePercentage
                       tt-cotacao-item.valor-frete      = ttQuotationLine.FreightValue          
                       tt-cotacao-item.aliquota-ipi     = ttQuotationLine.IndustrializedProductTaxPerce_00 
                       tt-cotacao-item.taxa-financ      = ttQuotationLine.IsFinancialRateIncluded 
                       tt-cotacao-item.frete            = ttQuotationLine.IsFreightIncluded           
                       tt-cotacao-item.codigo-ipi       = ttQuotationLine.IsIndustrializedProductTaxInc_00
                       tt-cotacao-item.cot-aprovada     = ttQuotationLine.IsQuoteApproved
                       tt-cotacao-item.it-codigo        = ttQuotationLine.ItemCode
                       tt-cotacao-item.int-1            = ttQuotationLine.ItineraryCode
                       tt-cotacao-item.preco-unit       = ttQuotationLine.NetUnitaryPrice 
                       tt-cotacao-item.pre-unit-for     = ttQuotationLine.VendorUnitaryPrice
                       tt-cotacao-item.preco-fornec     = ttQuotationLine.VendorUnitaryPrice
                       tt-cotacao-item.cod-cond-pag     = ttQuotationLine.PaymentPlanCode
                       tt-ordem-compra.cod-cond-pag     = ttQuotationLine.PaymentPlanCode 
                       tt-ordem-compra.qt-solic         = ttQuotationLine.POLineQuantityRequested
                       tt-cotacao-item.nr-tab           = ttQuotationLine.PriceTableNumber      
                       tt-cotacao-item.data-cotacao     = ttQuotationLine.QuotationDate
                       tt-cotacao-item.narrativa        = IF ttQuotationLine.QuoteText <> ? THEN ttQuotationLine.QuoteText ELSE "":U
                       tt-cotacao-item.reajusta-cotacao = ttQuotationLine.ReadjustQuote
                       tt-cotacao-item.valor-taxa       = ttQuotationLine.ReadjustRatePercentage          
                       tt-cotacao-item.valor-taxa       = ttQuotationLine.ServicesAndProductsCirculatio_00
                       tt-ordem-compra.aliquota-icm     = ttQuotationLine.ServicesAndProductsCirculatio_01
                       tt-cotacao-item.aliquota-iss     = ttQuotationLine.ServiceTaxPercentage
                       tt-cotacao-item.un               = ttQuotationLine.UnitOfMeasureCode       
                       tt-cotacao-item.data-atualiz     = ttQuotationLine.UpdateDate
                       tt-cotacao-item.hora-atualiz     = ttQuotationLine.UpdateTime
                       tt-cotacao-item.dias-validade    = ttQuotationLine.ValidityDays 
                       tt-cotacao-item.preco-fornec     = ttQuotationLine.VendorPrice
                       tt-ordem-compra.pre-unit-for     = ttQuotationLine.VendorUnitaryPrice
                       tt-cotacao-item.hora-atualiz     = string(TIME,"hh:mm:ss")
                       tt-cotacao-item.data-atualiz     = TODAY
                       tt-cotacao-item.data-cotacao     = TODAY
                       tt-cotacao-item.ind-tipo-movto   = tt-pedido-compr.ind-tipo-movto
                       i-cod-transp-aux                 = tt-cotacao-item.cod-transp
                       c-cod-comprador-aux              = tt-cotacao-item.cod-comprado
                       tt-cotacao-item.preco-fornec     = ttQuotationLine.VendorPrice.   	 
            END.
        END.
    
    END.
 
    CREATE tt-versao-integr.
    ASSIGN tt-versao-integr.cod-versao-integracao = 001
           tt-versao-integr.ind-origem-msg        = 01.


    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF NOT VALID-HANDLE(h-boin295) THEN
       RUN inbo/boin295.p PERSISTENT SET h-boin295.
    
    /*** BO para seta Defaults ***/
    IF NOT VALID-HANDLE(h-boin274sd) THEN
       RUN inbo/boin274sd.p PERSISTENT SET h-boin274sd.
    
    /*** BO para busca de descriá‰es ***/
    IF NOT VALID-HANDLE(h-boin295desc) THEN
       RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc.
    
    IF NOT VALID-HANDLE(h-boin356ca) THEN
       run inbo/boin356ca.p persistent set h-boin356ca.
    
    IF NOT VALID-HANDLE(hboin082ca) THEN
       run inbo/boin082ca.p persistent set hboin082ca.

    FOR EACH tt-pedido-compr:

        IF tt-pedido-compr.num-pedido = 0  THEN DO:
            FIND LAST pedido-compr
                 WHERE pedido-compr.num-pedido >= param-compra.num-pedido-ini
                 AND   pedido-compr.num-pedido <= param-compra.num-pedido-fim NO-LOCK NO-ERROR.
            IF AVAIL pedido-compr THEN
                ASSIGN tt-pedido-compr.num-pedido = pedido-compr.num-pedido + 1.
    
            IF tt-pedido-compr.data-pedido = ? THEN
                ASSIGN tt-pedido-compr.data-pedido = TODAY.
            &IF  "{&bf_mat_versao_ems}":U < "2.08":U &THEN
             FIND LAST  ordem-compra NO-LOCK
                  WHERE ordem-compra.numero-ordem >= param-compra.prim-ord-man
                  AND   ordem-compra.numero-ordem <= (param-compra.ult-ord-man * 100) NO-ERROR.
             IF AVAIL ordem-compra  THEN 
                 ASSIGN i-ordem-aux = ordem-compra.numero-ordem.
           &ELSE
              RUN ccp/ccapi333.p (INPUT YES,
                        OUTPUT i-ordem-aux).
              ASSIGN i-ordem-aux = i-ordem-aux - 1.   
           &ENDIF
        
            FOR EACH tt-ordem-compra:
                IF tt-ordem-compra.numero-ordem = 0 THEN DO:

                    ASSIGN i-ordem-ant                  = tt-ordem-compra.numero-ordem.
                    &IF  "{&bf_mat_versao_ems}":U < "2.08":U &THEN
                        ASSIGN tt-ordem-compra.numero-ordem = i-ordem-aux + 100
                           i-ordem-aux                  = i-ordem-aux + 100.
                    &ELSE
                        ASSIGN tt-ordem-compra.numero-ordem = i-ordem-aux + 1
                               i-ordem-aux                  = i-ordem-aux + 1. 
                    &ENDIF
                    ASSIGN tt-cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
                           tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem.

                    FOR EACH tt-prazo-compra
                        WHERE tt-prazo-compra.numero-ordem = i-ordem-ant:
                        ASSIGN tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem.
                    END.

                    FOR EACH tt-cotacao-item
                        WHERE tt-cotacao-item.numero-ordem = i-ordem-ant:
                        ASSIGN tt-cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem.
                    END.
            
                END.
    
                ASSIGN tt-ordem-compra.num-pedido  = tt-pedido-compr.num-pedido
                       tt-ordem-compra.data-pedido = tt-pedido-compr.data-pedido.
            END.
        END.

        RUN pi-prepara-pedido.
        IF RETURN-VALUE = "NOK" THEN
            RETURN "NOK".

        FOR EACH tt-ordem-compra:

            IF NOT l-integra-webb THEN DO:
                IF VALID-HANDLE(h-boin274sd) THEN
                  run buscaInfOrdemLeaveItem in h-boin274sd (input  tt-ordem-compra.it-codigo,
                                                             input  tt-ordem-compra.cod-estabel,
                                                             input  tt-ordem-compra.num-pedido,
                                                             output c-cod-comprador,
                                                             output c-ct-codigo,
                                                             output c-sc-codigo,
                                                             output c-deposito,
                                                             output i-tp-desp).
                IF tt-ordem-compra.ct-codigo = "" THEN
                   ASSIGN tt-ordem-compra.ct-codigo = c-ct-codigo.
                IF tt-ordem-compra.sc-codigo = "" THEN
                   ASSIGN tt-ordem-compra.sc-codigo = c-sc-codigo.

                ASSIGN tt-ordem-compra.tp-despesa = i-tp-desp
                       tt-ordem-compra.cod-transp = tt-pedido-compr.cod-transp.
                
                IF c-cod-comprador-aux <> "" THEN
                    ASSIGN tt-ordem-compra.cod-comprado = c-cod-comprador-aux.
            END.
        END.

    END.

    IF l-integra-webb AND cTranAction = "upd":U THEN DO:
        RUN pi-grava-dados-portal.
    END.
    ELSE DO:
        run ccp/ccapi303.p (input  table tt-versao-integr,
                            output table tt-erros-geral,
                            input  table tt-pedido-compr,
                            input  table tt-cond-especif,
                            input  table tt-ordem-compra,
                            input  table tt-prazo-compra,
                            input  table tt-cotacao-item
                            &if defined(bf_mat_despesa_fase_II) &then
                                 , input table tt-desp-cotacao-item
                            &endif).

        IF NOT CAN-FIND(FIRST tt-erros-geral) THEN DO:
        
            FOR EACH tt-ordem-compra:
                IF tt-ordem-compra.nr-requisicao  <> 0 THEN DO:
                    FIND FIRST it-requisicao
                         WHERE it-requisicao.nr-requisicao = tt-ordem-compra.nr-requisicao
                         AND   it-requisicao.sequencia     = tt-ordem-compra.sequencia
                         AND   it-requisicao.it-codigo     = tt-ordem-compra.it-codigo  EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL it-requisicao THEN DO:
                        assign it-requisicao.numero-ordem = tt-ordem-compra.numero-ordem 
                              it-requisicao.qt-atendida   = it-requisicao.qt-requisitada
                              it-requisicao.qt-a-atender  = it-requisicao.qt-requisitada
                                                          - it-requisicao.qt-atendida
                              it-requisicao.qt-a-devolver = it-requisicao.qt-atendida
                              it-requisicao.dt-atend      = today
                              it-requisicao.situacao      = 4.  
                        IF it-requisicao.qt-a-atender < 0 THEN
                            ASSIGN it-requisicao.qt-a-atender = 0.
                    END.
                    IF NOT CAN-FIND (FIRST it-requisicao 
                                     WHERE it-requisicao.nr-requisicao = tt-ordem-compra.nr-requisicao
                                       AND it-requisicao.situacao <> 4) THEN DO:
                        FIND FIRST requisicao
                             WHERE requisicao.nr-requisicao = tt-ordem-compra.nr-requisicao EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL requisicao THEN DO:           
                            ASSIGN requisicao.situacao = 4.
                            RELEASE requisicao.
                        END.
                    END.
                END.
    
            END.
        END.
    END.

    /* Integraá∆o com o portal de compras */
    IF NOT CAN-FIND(FIRST tt-erros-geral) THEN
        RUN pi-aprovacao-pedido.

    IF NOT l-integra-webb THEN DO:
    
        IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
          DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
             cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
          END.

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-erro_ao_executar_programa AS CHARACTER FORMAT "X(177)" NO-UNDO.
            {utp/ut-liter.i "Erro de integraá∆o. Erro ao executar o programa 'ccp/ccapi303.p' pelo programa adapters/xml/su2/axrsu004.p. Durante sua execu˛“o ocorreu o(s) seguinte(s) erro(s) Progress: " *}
            ASSIGN c-erro_ao_executar_programa = TRIM(RETURN-VALUE).

          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT c-erro_ao_executar_programa + cErrorText).
          CREATE tt_log_erro.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'ccp/ccapi303.p'_pelo_programa_adapters/xml/su2/axrsu004.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress" *}
          ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                 tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ': ' + cErrorText.
        END.
        ELSE DO: /* Erros ocorridos durante efetivaá∆o do registro */
            FOR EACH tt-erros-geral:
                 RUN setError IN hMessageHandler (INPUT tt-erros-geral.cod-erro,
                                                  INPUT "business_error":U,  /* Erro de neg¢cio */
                                                  INPUT tt-erros-geral.des-erro).
                 CREATE tt_log_erro.
                 ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erros-geral.cod-erro
                        tt_log_erro.ttv_des_msg_erro = tt-erros-geral.des-erro.
            END.
        END.
    END.
END.
ELSE DO:
    CREATE tt_log_erro.
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'ccp/ccapi303.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu002.p" *}
       ASSIGN tt_log_erro.ttv_num_cod_erro = 0
              tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + '.'.

       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'ccp/ccapi303.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu002.p" *}
       RUN setError IN hMessageHandler (INPUT 0,
                                        INPUT "enviroment_error":U,
                                        INPUT RETURN-VALUE + '.').

END.


/* ---- Seta para o Adapter que a transacao contem Erro --- */
FOR EACH tt-erros-geral:
     RUN setError IN hMessageHandler (INPUT tt-erros-geral.cod-erro,
                                      INPUT "business_error":U,  /* Erro de neg¢cio */
                                      INPUT tt-erros-geral.des-erro).
     CREATE tt_log_erro.
     ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erros-geral.cod-erro
            tt_log_erro.ttv_des_msg_erro = tt-erros-geral.des-erro.
END.

/* --- Knupp - Seta para o Adapter que a transacao contem Erro --- */
IF CAN-FIND(FIRST tt_log_erro) THEN 
        ASSIGN lSuccessProcess = NO
               cReturnValue   = "NOK".

