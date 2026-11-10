FIND FIRST param-global NO-LOCK.
FIND FIRST param-aprov NO-LOCK.
FIND FIRST param-compra NO-LOCK.

/* Integra‡Æo com portal de Compras */
IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-COMPRA":U AND funcao.ativo) THEN DO:

    IF &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
       SUBSTRING(param-compra.CHAR-2,102,1) = "s":U
    &ELSE
       param-compra.log-integr-portal
    &ENDIF AND CAN-FIND(FIRST ttDestinationPartner WHERE ttDestinationPartner.CodDestination = "Webb":U) THEN DO:	

        ASSIGN l-integra-webb = YES.
    
        IF cTranAction = "add":U THEN DO:
            IF NOT VALID-HANDLE(h-boin295) THEN
                RUN inbo/boin295.p PERSISTENT SET h-boin295.
            
            IF VALID-HANDLE(h-boin295) THEN
                RUN geraNumeroPedidoCompra IN h-boin295 (output PONumber).
            
            ASSIGN ManagerSiteID = "":U
                   SiteId = "":U.
            
        END.
        ELSE IF cTranAction = "upd":U THEN DO:
            FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = PONumber NO-LOCK NO-ERROR.
            
            IF AVAIL pedido-compr THEN DO:
            
                CREATE tt-pedido-compr.
                BUFFER-COPY pedido-compr TO tt-pedido-compr.
            END.
            ELSE DO:
                run utp/ut-msgs.p (INPUT 'msg':U,
                                   INPUT 6363,
                                   INPUT STRING(PONumber)).                   
                
                CREATE tt_log_erro.                  
                ASSIGN tt_log_erro.ttv_num_cod_erro = 6363
                       tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).
            
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Pedido_de_compra_inexistente" *}
                RUN setError IN hMessageHandler (INPUT 6363,
                                                 INPUT "business_error":U,
                                                 INPUT RETURN-VALUE).
            
                RETURN "NOK":U.
            END.
        
        END.

        IF VendorNumber = ? OR VendorNumber = 0 THEN DO:
        
            FIND FIRST emitente WHERE emitente.cgc = VendorTaxId NO-LOCK NO-ERROR.
        
            IF AVAIL emitente THEN DO:
                ASSIGN VendorNumber = emitente.cod-emitente. 
            END. 
            ELSE DO:
                FOR EACH ttPurchaseOrderLine:             
                    FIND FIRST ttDeliveryScheduleInforma_00 WHERE ttDeliveryScheduleInforma_00.POLineNumber = ttPurchaseOrderLine.POLineNumber NO-ERROR.
            
                    CREATE ttPurchaseOrderLine012.
                    BUFFER-COPY ttPurchaseOrderLine TO ttPurchaseOrderLine012.
                    ASSIGN ttPurchaseOrderLine012.POLineNumberWebb = ttPurchaseOrderLine.POLineNumberPortal
                           ttPurchaseOrderLine012.DeliveryDate     = ttDeliveryScheduleInforma_00.DeliveryDate     
                           ttPurchaseOrderLine012.ItemCode         = ttPurchaseOrderLine.ItemCode       
                           ttPurchaseOrderLine012.ItemDescription  = ttPurchaseOrderLine.ItemDescription     
                           ttPurchaseOrderLine012.POLineNumber     = ttPurchaseOrderLine.POLineNumber     
                           ttPurchaseOrderLine012.PriceVendor      = ttPurchaseOrderLine.VendorUnitPrice      
                           ttPurchaseOrderLine012.Quantity         = ttDeliveryScheduleInforma_00.Quantity       
                           ttPurchaseOrderLine012.UnitPrice        = ttPurchaseOrderLine.VendorUnitPrice    
                           ttPurchaseOrderLine012.UnitPriceVendor  = ttPurchaseOrderLine.VendorUnitPrice     
                           ttPurchaseOrderLine012.POLineNumberWebb = ttPurchaseOrderLine.POLineNumberPortal      
                           ttPurchaseOrderLine012.CurrencyID       = ttPurchaseOrderLine.CurrencyId.             
                END.

                FOR EACH tt-pedido-compr-approve:
                    DELETE tt-pedido-compr-approve.
                END.
                
                CREATE tt-pedido-compr-approve.    
                
                &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                    ASSIGN overlay(tt-pedido-compr-approve.char-1, 3, 50) = PONumberWebb
                &ELSE
                    ASSIGN tt-pedido-compr-approve.cod-ped-portal = PONumberWebb
                &ENDIF            
                           tt-pedido-compr-approve.num-pedido   = PONumber
                           tt-pedido-compr-approve.end-entrega  = FromRoleSiteId
                           tt-pedido-compr-approve.end-cobranca = BillToSiteId
                           tt-pedido-compr-approve.comentarios  = Comment
                           tt-pedido-compr-approve.cod-emitente = VendorNumber.
                
                FIND FIRST ttPurchaseOrderLine012 NO-ERROR.
                
                if AVAIL ttPurchaseOrderLine012 then do:
                    run adapters/xml/su2/axssu012.p (input "add":u,
                                                     input "axrsu004.p":u,
                                                     input "suspension":U,
                                                     input "Fornecedor inexistente":U,
                                                     input table tt-pedido-compr-approve,
                                                     input table ttPurchaseOrderLine012,
                                                     output table tt_log_erro APPEND).
                    
                end.

                run utp/ut-msgs.p (input 'msg':u,
                                   INPUT 38206,
                                   input '').                    
                
                RUN setError IN hMessageHandler (INPUT 38206,
                                                 INPUT "business_error":U,
                                                 INPUT return-value).
                
                RETURN "NOK":U.

            END.
        END.
    END.
END.
