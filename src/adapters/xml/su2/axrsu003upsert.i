IF NOT CAN-FIND(first ttDestinationPartner where ttDestinationPartner.Cod = "Paradigma":u) THEN DO:
    ASSIGN l-paradigma = NO.
END.

/* axrsu003Upsert.i - Retorno processo de compras - Preg∆o  */
    if (l-portal AND can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u) AND cTranAction = "upd":U) OR
       (NOT l-portal) OR
       (NOT CAN-FIND(FIRST ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u)) then do:

        IF SEARCH("ocp/ocapi002.p":U) <> ? OR SEARCH("ocp/ocapi002.r":U) <> ? THEN DO:

            FIND FIRST ttPurchaseProcess NO-LOCK NO-ERROR.

            CREATE tt-parametros.
            ASSIGN tt-parametros.cod-versao-integracao = 1
                   tt-parametros.i-opcao               = 1. 

            /*
            ** Tratamento exclusivo BBM
            */
            FIND FIRST ttQuotationLine NO-LOCK.
            IF ttQuotationLine.VendorNumber <> 0 AND ttQuotationLine.VendorNumber <> ? THEN
                    ASSIGN tt-parametros.i-opcao = 2.
            IF tt-parametros.i-opcao = 1 THEN DO:
                FIND proc-compra
                    WHERE trim(substring(proc-compra.char-2,1,100)) = ttPurchaseProcess.ProclaimNumber NO-LOCK NO-ERROR.
                FOR EACH ordem-compra 
                    WHERE ordem-compra.nr-processo = proc-compra.nr-processo NO-LOCK:
                    FIND campo-lote-pregao-ord
                        WHERE campo-lote-pregao-ord.numero-ordem = ordem-compra.numero-ordem
                          AND campo-lote-pregao-ord.cod-campo    = "BBM-NR-LOTE":U NO-LOCK NO-ERROR.
                        IF AVAIL campo-lote-pregao-ord THEN DO:
                            FIND ttLote
                                WHERE ttLote.nr-lote = campo-lote-pregao-ord.dsl-conteudo NO-LOCK NO-ERROR.
                            IF AVAIL ttLote THEN
                                ASSIGN lAgrupaLote = YES.
                            ELSE DO:
                                CREATE ttLote.
                                ASSIGN ttLote.nr-lote            = string(integer(campo-lote-pregao-ord.dsl-conteudo)).
                            END.
                            CREATE ttLoteOrdem.
                            ASSIGN ttLoteOrdem.nr-lote           = string(integer(campo-lote-pregao-ord.dsl-conteudo))
                                   ttLoteOrdem.numero-ordem      = campo-lote-pregao-ord.numero-ordem.
                    END.
                END.
                FOR EACH bttQuotationLine NO-LOCK:
                    FIND FIRST ttLoteOrdem
                        WHERE ttLoteOrdem.nr-lote = string(bttQuotationLine.POLineNumber) NO-LOCK NO-ERROR.
                    IF NOT AVAIL ttLoteOrdem THEN
                        LEAVE.
                    FIND ttQuotationLine 
                        WHERE ttQuotationLine.ttQuotationLineId = bttQuotationLine.ttQuotationLineId NO-LOCK.
                    ASSIGN ttQuotationLine.POLineNumber = ttLoteOrdem.numero-ordem
                           iNumeroOrdem                 = ttLoteOrdem.numero-ordem
                           iLote                        = ttLoteOrdem.nr-lote.
                    FOR EACH ttLoteOrdem
                        WHERE ttLoteOrdem.nr-lote      =  iLote
                          AND ttLoteORdem.numero-ordem <> iNumeroOrdem NO-LOCK:
                        CREATE ttQuotationLine.
                        ASSIGN ttQuotationLine.ttQuotationLineId = iId + 1
                               ttQuotationLine.POLineNumber = ttLoteOrdem.numero-ordem.
                        BUFFER-COPY bttQuotationLine EXCEPT ttQuotationLineId POLineNumber TO ttQuotationLine.
                    END.
                END.
            END.

            FOR EACH ttQuotationLine NO-LOCK:

                /* Criaá∆o de pacote de compra - Paradigma */
                IF l-paradigma THEN DO:

                   /* Fornecedor n∆o cadastrado no EMS */
                   if ttQuotationLine.VendorNumber = ? or
                      ttQuotationLine.VendorNumber = 0 then do:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Fornecedor" *}
                        ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="47"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-fornecedor"}  
                        LEAVE.                                                                                
                    end.
                    ELSE DO:
                        RUN pi-cria-processo-compra.
                    END.             
                END.

                IF  ttQuotationLine.VendorNumber <> 0 AND ttQuotationLine.VendorNumber <> ? then
                    ASSIGN tt-parametros.i-opcao = 2.
                ELSE DO:

                    if (l-portal AND can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u)) OR l-paradigma then
                        assign tt-parametros.i-opcao = 2.

                    /* carga temp-table tt-edital */
                    CREATE tt-edital.
                    ASSIGN tt-edital.cod-edital               = ttPurchaseProcess.ProclaimNumber WHEN AVAIL ttPurchaseProcess
                           tt-edital.numero-ordem             = ttQuotationLine.POLineNumber
                           tt-edital.cgc                      = ttQuotationLine.VendorTaxID.
                END.

                /* Localiza as informaá‰es de importaá∆o relacionadas a cotaá∆o corrente */
                FIND FIRST ttImportInformation
                     WHERE ttImportInformation.ttQuotationLineID = ttQuotationLine.ttQuotationLineID NO-LOCK NO-ERROR.   

                /* carga temp-table tt-cotacao-item-venc */
                CREATE tt-cotacao-item-venc.
                ASSIGN tt-cotacao-item-venc.numero-ordem       = ttQuotationLine.POLineNumber                                                            /*N£mero da ordem de compra. (Uso interno: Campo = movind.cotacao-item.numero-ordem) */
                       tt-cotacao-item-venc.motivo-apr         = ttQuotationLine.ApprovalReason                                                          /*Motivo aprovaá∆o / rejeiá∆o da cotaá∆o. (Uso interno: Campo = mgind.cotacao-item.motivo-apr)*/
                       tt-cotacao-item-venc.prazo-entreg       = ttQuotationLine.DeliveryTerm                                                            /*Prazo Entrega. (Uso interno: Campo = movind.cotacao-item.prazo-entreg) */
                       tt-cotacao-item-venc.valor-descto       = ttQuotationLine.DiscountAmount                                                          /*Valor de Desconto. (Uso Interno: Campo = movind.cotacao-item.valor-descto)*/
                       tt-cotacao-item-venc.perc-descto        = ttQuotationLine.DiscountPercentage                                                      /*Percentual de Desconto. (Uso Interno: Campo =  movind.cotacao-item.perc-descto)*/
                       tt-cotacao-item-venc.nr-dias-taxa       = ttQuotationLine.FinancialRateDays                                                       /*N£mero de dias da taxa financeira (Uso Interno: Campo = movind.cotacao-item.nr-dias-taxa)*/
                       tt-cotacao-item-venc.valor-taxa         = ttQuotationLine.FinancialRatePercentage                                                 /*Define o percentual da taxa financeira. (Uso Interno: Campo =  movind.cotacao-item.valor-taxa)*/
                       tt-cotacao-item-venc.valor-frete        = ttQuotationLine.FreightValue                                                            /*Valor do Frete. (Uso Interno: Campo = movind.cotacao-item.valor-frete)*/
                       tt-cotacao-item-venc.aliquota-ipi       = ttQuotationLine.IndustrializedProductTaxPerce_00                                        /*Al°quota de IPI. (Uso Interno: Campo =  movind.cotacao-item.aliquota-ipi)*/
                       tt-cotacao-item-venc.taxa-financ        = ttQuotationLine.IsFinancialRateIncluded                                                 /*Define se os encargos financeiros est∆o inclusos. (Uso Interno: Campo =  movind.cotacao-item.taxa-financ)*/
                       tt-cotacao-item-venc.frete              = ttQuotationLine.IsFreightIncluded                                                       /*Frete Incluso? Valores: YES = "FOB", NO = "CIF". (Uso Interno: Campo = movind.cotacao-item.frete)*/
                       tt-cotacao-item-venc.codigo-ipi         = ttQuotationLine.IsIndustrializedProductTaxInc_00                                        /*IPI Incluso? (Uso Interno: Campo = movind.cotacao-item.codigo-ipi)*/
                       tt-cotacao-item-venc.cot-aprovada       = ttQuotationLine.IsQuoteApproved                                                         /*Cotaá∆o aprovada Sim/N∆o. (Uso Interno: Campo = mgind.cotacao-item.cot-aprovada)*/
                       tt-cotacao-item-venc.ind-ret-cotacao    = ttQuotationLine.IsQuoteReturned                                                         /*Indica se hove retorno da cotaá∆o do fornecedor (via edi ou por meios normais fax, telex, etc ...). (Uso interno: Campo = movind.cotacao-item.ind-ret-cotacao)*/
                       tt-cotacao-item-venc.preco-unit         = ttQuotationLine.NetUnitaryPrice                                                         /*Preáo unit†rio interno incluso impostos, desconto, ipi e taxa. (Uso Interno: Campo = movind.cotacao-item.preco-unit)*/
                       tt-cotacao-item-venc.data-cotacao       = ttQuotationLine.QuotationDate                                                           /*Data de Emiss∆o. (Uso interno: Campo = movind.cotacao-item.data-cotacao)*/
                       tt-cotacao-item-venc.ind-via-envio      = ttQuotationLine.QuotationSending                                                        /*Via de envio da cotaá∆o (Uso interno: Campo = movind.cotacao-item.ind-via-envio - Include = diinc/i07di159.i)*/
                       tt-cotacao-item-venc.ind-orig-entrada   = ttQuotationLine.QuotationSource                                                         /*Origem de entrada da cotaá∆o (Uso interno: Campo = movind.cotacao-item.ind-orig-entrada - Include = diinc/i07di159.i)*/
                       tt-cotacao-item-venc.num-proc-envio-edi = ttQuotationLine.QuoteDispatchProcessNumber                                              /*N£mero do processo de envio da cotaá∆o. (Uso interno: Campo = movind.cotacao-item.num-proc-envio-edi)*/
                       tt-cotacao-item-venc.num-proc-entr-edi  = ttQuotationLine.QuoteEntryProcessNumber                                                 /*N£mero do processo de entrada da cotaá∆o. (Uso interno: Campo = movind.cotacao-item.num-proc-entr-edi)*/
                       tt-cotacao-item-venc.seq-cotac          = ttQuotationLine.QuoteSequence                                                           /*Sequencia da cotaá∆o de preáos. (Uso interno: Campo = movind.cotacao-item.seq-cotac)*/
                       tt-cotacao-item-venc.narrativa          = ttQuotationLine.QuoteText                                                               /*Narrativa. (Uso Interno: Campo = movind.cotacao-item.narrativa)*/
                       tt-cotacao-item-venc.reajusta-cotacao   = ttQuotationLine.ReadjustQuote                                                           /*Reajusta cotaá∆o. (Uso Interno: Campo =  movind.cotacao-item.reajusta-cotacao)*/
                       tt-cotacao-item-venc.valor-taxa         = ttQuotationLine.ReadjustRatePercentage                                                  /*Define o percentual da taxa financeira. (Uso Interno: Campo =  movind.cotacao-item.valor-taxa)*/
                       tt-cotacao-item-venc.aliquota-icm       = ttQuotationLine.ServicesAndProductsCirculatio_00                                        /*Al°quota de ICMS. (Uso Interno: Campo =  movind.cotacao-item.aliquota-icm)*/
                       tt-cotacao-item-venc.codigo-icm         = ttQuotationLine.ServicesAndProductsCirculatio_01                                        /*C¢digo do ICMS. Valores: 1 - Consumo, 2 - Industrializaá∆o. (Uso interno: Campo = mguni.cotacao-item.codigo-icms - Include = ininc/i01in082.i)*/
                       tt-cotacao-item-venc.aliquota-iss       = ttQuotationLine.ServiceTaxPercentage                                                    /*Aliquota ISS (Uso Interno: Campo =  movind.cotacao-item.aliquota-iss)*/
                       tt-cotacao-item-venc.data-atualiz       = ttQuotationLine.UpdateDate                                                              /*Data em que foi efetuada a £ltima alteraá∆o na ordem de compra. (Uso Interno: Campo = movind.cotacao-item.data-atualiz) */
                       tt-cotacao-item-venc.hora-atualiz       = IF ttQuotationLine.UpdateTime = ? THEN "":U ELSE ttQuotationLine.UpdateTime             /*Hora em que foi efetuada a £ltima alteraá∆o na ordem de compra. (Uso Interno: Campo = movind.cotacao-item.hora-atualiz)*/
                       tt-cotacao-item-venc.dias-validade      = ttQuotationLine.ValidityDays                                                            /*Dias de validade da cotaá∆o (Uso interno: Campo = movind.cotacao-item.dias-validade)*/
                       tt-cotacao-item-venc.preco-fornec       = ttQuotationLine.VendorPrice                                                             /*Preáo do Fornecedor. (Uso Interno: Campo = movind.cotacao-item.preco-fornec)*/
                       tt-cotacao-item-venc.pre-unit-for       = ttQuotationLine.VendorUnitaryPrice                                                      /*Preáo unit†rio fornecedor incluso impostos, desconto, ipi e taxa. (Uso Interno: Campo = movind.cotacao-item.pre-uni-for)*/
                       tt-cotacao-item-venc.cod-emitente       = ttQuotationLine.VendorNumber                                                            /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.cod-emitente)*/
                       tt-cotacao-item-venc.contato            = ttQuotationLine.ContactName                                                             /*Contato. Deve ser um contato relacionado ao fornecedor do pedido (ordem-compra.cod-emitente) (Uso Interno: Campo = mgadm.cont-emit.nome)*/
                       tt-cotacao-item-venc.it-codigo          = ttQuotationLine.ItemCode                                                                /*C¢digo do Item. (Uso Interno: Campo = mgind.item.it-codigo)*/
                       tt-cotacao-item-venc.un                 = ttQuotationLine.UnitOfMeasureCode_00                                                    /*C¢digo da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.un)*/
                       tt-cotacao-item-venc.nr-tab             = IF ttQuotationLine.PriceTableNumber = ? THEN "":U ELSE ttQuotationLine.PriceTableNumber /*Numero da tabela de preáos. (Uso Interno: Campo = mgind.tb-pr-cc.nr-tab)*/
                       tt-cotacao-item-venc.mo-codigo          = ttQuotationLine.CurrencyID                                                              /*C¢digo da moeda (Uso Interno: Campo =  mguni.moeda.mo-codigo)*/
                       tt-cotacao-item-venc.aprovador          = ttQuotationLine.ApproverID                                                              /*C¢digo do comprador do item. (Uso interno: Campo = mgind.aprovador.cod-aprov)*/
                       tt-cotacao-item-venc.cod-comprado       = ttQuotationLine.BuyerID                                                                 /*C¢digo do comprador do item. (Uso interno: Campo = mgind.comprador.cod-comprado)*/
                       tt-cotacao-item-venc.usuario            = ttQuotationLine.cUserID                                                                 /*Identificador do usu†rio (Uso Interno: Campo = usuar_mestre.cod_usuario)*/
                       tt-cotacao-item-venc.cod-transp         = ttQuotationLine.CarrierID                                                               /*C¢digo de identificaá∆o da transportadora (Uso Interno: Campo =  transporte.cod-transp)*/
                       tt-cotacao-item-venc.cod-cond-pag       = ttQuotationLine.PaymentPlanCode                                                        
                       tt-cotacao-item-venc.cdn-pto-control    = ttImportInformation.ControlPointCode         WHEN AVAIL ttImportInformation             /*C¢digo do ponto de controle. (Uso interno: Campo = mgcex.pto-contr.cod-pto-contr)*/
                       tt-cotacao-item-venc.cod-pto-contr-base = ttImportInformation.ControlPointCode_00      WHEN AVAIL ttImportInformation             /*C¢digo do ponto de controle. (Uso interno: Campo = mgcex.pto-contr.cod-pto-contr)*/
                       tt-cotacao-item-venc.cdn-pais-orig      = ttImportInformation.CountryCode              WHEN AVAIL ttImportInformation             /*C¢digo identificador do pa°s. (Uso interno: Campo = mguni.pais.cod-pais)*/
                       tt-cotacao-item-venc.dt-entrega         = ttImportInformation.DeliveryDate             WHEN AVAIL ttImportInformation             /*Data de entrega da mercadoria. (Uso interno: Campo = movind.cotacao-item.dt-entrega)*/
                       tt-cotacao-item-venc.class-fiscal       = ttImportInformation.FiscalClassificationID   WHEN AVAIL ttImportInformation             /*C¢digo da classificaá∆o fiscal. (Uso interno: Campo = mgind.classif-fisc.class-fiscal)*/
                       tt-cotacao-item-venc.aliquota-ii        = ttImportInformation.ImportationTaxPercentage WHEN AVAIL ttImportInformation             /*Aliquota do imposto de importaá∆o. (Uso interno: Campo = movind.cotacao-item.aliquota-ii)*/
                       tt-cotacao-item-venc.cod-incoterm       = ttImportInformation.Incoterm                 WHEN AVAIL ttImportInformation             /*Incoterm para importaá∆o. (Uso interno: Campo = movind.cotacao-item.cod-incoterm)*/
                       tt-cotacao-item-venc.itinerario         = ttImportInformation.ItineraryCode            WHEN AVAIL ttImportInformation             /*C¢digo Itiner†rio. (Uso interno: Campo = mgcex.itinerario.cod-itiner)*/
                       tt-cotacao-item-venc.cdn-fabrican       = ttImportInformation.ManufacturerNumber       WHEN AVAIL ttImportInformation             /*C¢digo do Fabricante. ( Uso Interno: Campo= emitente.cod-emitente)*/
                       tt-cotacao-item-venc.mapa-cotacao       = ttImportInformation.QuoteMap                 WHEN AVAIL ttImportInformation             /*Mapa cotaá∆o. (Uso interno: Campo = movind.cotacao-item.mapa-cotacao)*/
                       tt-cotacao-item-venc.dt-embarque        = ttImportInformation.ShipmentDate             WHEN AVAIL ttImportInformation             /*Data de embarque da mercadoria. (Uso interno: Campo = movind.cotacao-item.dt-embarque*/.

                if (l-portal and can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u)) OR l-paradigma then do:

                    find first ordem-compra where ordem-compra.numero-ordem = ttQuotationLine.POLineNumber no-lock no-error.

                    &if '{&bf_mat_versao_ems}' < '2.09' &then
                      assign overlay(tt-cotacao-item-venc.char-2,101,1)  = if ttQuotationLine.Freeze = ? then "":U else ttQuotationLine.Freeze
                             overlay(tt-cotacao-item-venc.char-2,102,1)  = if ttQuotationLine.PortalIntegration = ? then "":U else ttQuotationLine.PortalIntegration
                             OVERLAY(tt-cotacao-item-venc.char-2,157,17) = STRING(ttQuotationLine.NetUnitaryPrice).
    
                    &else
                      assign tt-cotacao-item-venc.log-congela-cotac    = if ttQuotationLine.Freeze = "S":U then yes else no
                             tt-cotacao-item-venc.log-integr-portal    = if ttQuotationLine.PortalIntegration = "S":U then yes else no
                             tt-cotacao-item-venc.cod-cotac-portal     = ttQuotationLine.QuotationNumberPortal
                             tt-cotacao-item-venc.cod-respos-fornec    = ttQuotationLine.FornecQuotationNumberPortal
                             tt-cotacao-item-venc.cod-cotac-pai-portal = ttQuotationLine.QuotationParentNumberPortal
                             tt-cotacao-item-venc.val-preco-liq-item   = ttQuotationLine.NetUnitaryPrice.
    
                    &endif             
                       
                    &if '{&bf_mat_versao_ems}' < '2.09' &then
                        IF l-portal THEN DO:
                            ASSIGN overlay(tt-cotacao-item-venc.char-2,103,18) = if ttQuotationLine.QuotationNumberPortal = ? then "":U else ttQuotationLine.QuotationNumberPortal
                                   overlay(tt-cotacao-item-venc.char-2,139,18) = if ttQuotationLine.QuotationParentNumberPortal = ? then "":U else ttQuotationLine.QuotationParentNumberPortal
                                   overlay(tt-cotacao-item-venc.char-2,121,18) = if ttQuotationLine.FornecQuotationNumberPortal = ? then "":U else ttQuotationLine.FornecQuotationNumberPortal.
                        END.
                        ELSE DO:                                                                                                                                             
                            ASSIGN overlay(tt-cotacao-item-venc.char-2,174,50) = if ttQuotationLine.QuotationNumberPortal = ? then "":U else ttQuotationLine.QuotationNumberPortal
                                   overlay(tt-cotacao-item-venc.char-2,224,50) = if ttQuotationLine.QuotationParentNumberPortal = ? then "":U else ttQuotationLine.QuotationParentNumberPortal
                                   overlay(tt-cotacao-item-venc.char-2,324,50) = if ttQuotationLine.FornecQuotationNumberPortal = ? then "":U else ttQuotationLine.FornecQuotationNumberPortal
                                   OVERLAY(tt-cotacao-item-venc.char-2,274,50) = if ttQuotationLine.QuotationItemNumberPortal = ? then "":U else ttQuotationLine.QuotationItemNumberPortal
                                   OVERLAY(tt-cotacao-item-venc.char-2,374,50) = IF ttQuotationLine.QuotationProcessPortal = ? THEN "":U ELSE ttQuotationLine.QuotationProcessPortal.
                        END.
                    &ELSE
                        IF l-paradigma THEN DO:
                            ASSIGN tt-cotacao-item-venc.cod-item-cotac-portal = if ttQuotationLine.QuotationItemNumberPortal = ? then "":U else ttQuotationLine.QuotationItemNumberPortal
                                   tt-cotacao-item-venc.cod-proces-portal     = IF ttQuotationLine.QuotationProcessPortal = ? THEN "":U ELSE ttQuotationLine.QuotationProcessPortal.
                        END.
                    &ENDIF

                    if avail ordem-compra THEN DO:
                        assign tt-cotacao-item-venc.numero-ordem = ordem-compra.numero-ordem
                               tt-cotacao-item-venc.it-codigo    = ordem-compra.it-codigo
                               tt-cotacao-item-venc.codigo-icm   = ordem-compra.codigo-icm.

                        /* Ordem de compra j∆ confirmada */
                        IF l-paradigma AND ordem-compra.situacao = 2 THEN DO:
                            {method/svc/errors/inserr.i &ErrorNumber="1919"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="''"}
                            LEAVE.
                        END.
                    END.
                    else do:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-ordem-compra AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Ordem_Compra" *}
                        ASSIGN c-lbl-liter-ordem-compra = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="2"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-ordem-compra + string(ttQuotationLine.POLineNumber)"}
                    end.

                    ASSIGN tt-cotacao-item-venc.contato       = IF ttQuotationLine.Contact = ? THEN "":U ELSE ttQuotationLine.Contact
                           tt-cotacao-item-venc.valor-taxa    = ttQuotationLine.FinancialRatePercentage.

                    IF l-portal THEN DO:
                        assign tt-cotacao-item-venc.prazo-entreg  = ttQuotationLine.DeliveryTerm.                             
                    END.
                    ELSE DO:
                        assign tt-cotacao-item-venc.prazo-entreg       = ttQuotationLine.DeliveryDate - today
                               tt-cotacao-item-venc.dias-validade      = ttQuotationLine.ExpirationDate - ttQuotationLine.QuotationDate
                               ttQuotationLine.POLineQuantityRequested = 0. /* Quantidade Ç atualizada com a soma das quantidades das parcelas */

                        EMPTY TEMP-TABLE tt-prazo-compra.


                        FOR EACH ttDeliveryScheduleInforma_00 WHERE ttDeliveryScheduleInforma_00.ttQuotationLineID = ttQuotationLine.ttQuotationLineID NO-LOCK:
                            CREATE tt-prazo-compra.

                            FIND FIRST prazo-compra WHERE prazo-compra.parcela      = ttDeliveryScheduleInforma_00.DeliveryScheduleID AND
                                                          prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.

                            IF NOT AVAIL prazo-compra THEN DO:                          
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-parcela AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Parcela" *}
                                ASSIGN c-lbl-liter-parcela = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="5313"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-parcela"}                                                                       
                            END.
                            ELSE DO:
                                BUFFER-COPY prazo-compra TO tt-prazo-compra.
                                ASSIGN tt-prazo-compra.data-entrega = ttDeliveryScheduleInforma_00.DeliveryDate
                                       ttQuotationLine.POLineQuantityRequested = ttQuotationLine.POLineQuantityRequested + ttDeliveryScheduleInforma_00.Quantity.
                            END.
                        END.
                    END.

                    if ttQuotationLine.VendorNumber = ? or
                       ttQuotationLine.VendorNumber = 0 then do:

                        find first emitente where emitente.cgc = ttQuotationLine.VendorTaxID no-lock no-error.
                        if avail emitente THEN DO:
                            assign tt-cotacao-item-venc.cod-emitente = emitente.cod-emitente.
    
                            IF emitente.identific = 1 THEN
                                {method/svc/errors/inserr.i &ErrorNumber="51594"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(emitente.cod-emitente) + '~~~~' + string(emitente.cgc)"}
                        END.
                        else do:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Emitente" *}
                            ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
                            DEFINE VARIABLE c-lbl-liter-cnpj AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "CNPJ" *}
                            ASSIGN c-lbl-liter-cnpj = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="16381"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-lbl-liter-emitente + '~~~~' + c-lbl-liter-cnpj + ': ' + string(ttQuotationLine.VendorTaxID)"}                                           
                        end.  

                    end.
                    else
                        assign tt-cotacao-item-venc.cod-emitente = ttQuotationLine.VendorNumber.

                    IF tt-cotacao-item-venc.seq-cotac <> ? THEN
                        assign ttDestinationPartner.numero-ordem = tt-cotacao-item-venc.numero-ordem
                               ttDestinationPartner.cod-emitente = tt-cotacao-item-venc.cod-emitente
                               ttDestinationPartner.it-codigo    = tt-cotacao-item-venc.it-codigo   
                               ttDestinationPartner.seq-cotac    = tt-cotacao-item-venc.seq-cotac. 
                    ELSE DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-codigo-da-cotacao-no-portal AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "C¢digo_da_cotaá∆o_no_portal" *}
                        ASSIGN c-lbl-liter-codigo-da-cotacao-no-portal = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="2"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-codigo-da-cotacao-no-portal"} 
                    END.

                    IF ttQuotationLine.POLineQuantityRequested <> ordem-compra.qt-solic THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="51309"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="''"} 
                    END.

                    for first item-fornec
                        where item-fornec.cod-emitente = tt-cotacao-item-venc.cod-emitente
                        and item-fornec.it-codigo    = tt-cotacao-item-venc.it-codigo NO-LOCK:
                        ASSIGN tt-cotacao-item-venc.un = item-fornec.unid-med-for.
                    end.

                    
                    /* Validaá∆o de formatos */

                    IF l-portal THEN DO:              
                        /* Preáo forncedor */
                        IF LENGTH(string(TRUNCATE(ttQuotationLine.NetUnitaryPrice,0))) > 11   OR
                           LENGTH(substring(string(ttQuotationLine.NetUnitaryPrice - TRUNCATE(ttQuotationLine.NetUnitaryPrice,0)),2,
                                  LENGTH(STRING(ttQuotationLine.NetUnitaryPrice - TRUNCATE(ttQuotationLine.NetUnitaryPrice,0))))) > 5 THEN DO:
    
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-preco-fornecedor AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Preáo_fornecedor" *}
                            ASSIGN c-lbl-liter-preco-fornecedor = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-lbl-liter-preco-fornecedor + '~~~~' + string(ttQuotationLine.NetUnitaryPrice) + '~~~~99999,999,999.99999'"}
    
                        END.
                    END.
                    ELSE DO:                       
                        /* Preáo forncedor */
                        IF LENGTH(string(TRUNCATE(ttQuotationLine.VendorPrice,0))) > 11   OR
                           LENGTH(substring(string(ttQuotationLine.VendorPrice - TRUNCATE(ttQuotationLine.VendorPrice,0)),2,
                                  LENGTH(STRING(ttQuotationLine.VendorPrice - TRUNCATE(ttQuotationLine.VendorPrice,0))))) > 5 THEN DO:
    
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-preco-fornecedor-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Preáo_fornecedor" *}
                            ASSIGN c-lbl-liter-preco-fornecedor-2 = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-lbl-liter-preco-fornecedor-2 + '~~~~' + string(ttQuotationLine.VendorPrice) + '~~~~99999,999,999.99999'"}
    
                        END.
                    END.

                    /* Percentual de desconto */
                    IF LENGTH(string(TRUNCATE(ttQuotationLine.DiscountPercentage,0))) > 2   OR
                       LENGTH(substring(string(ttQuotationLine.DiscountPercentage - TRUNCATE(ttQuotationLine.DiscountPercentage,0)),2,
                              LENGTH(STRING(ttQuotationLine.DiscountPercentage - TRUNCATE(ttQuotationLine.DiscountPercentage,0))))) > 5 THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-percentual-de-desconto AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Percentual_de_desconto" *}
                        ASSIGN c-lbl-liter-percentual-de-desconto = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-percentual-de-desconto + '~~~~' + string(ttQuotationLine.DiscountPercentage) + '~~~~99.99999'"}

                    END.

                    /* Taxa financeira */
                    IF LENGTH(string(TRUNCATE(ttQuotationLine.FinancialRatePercentage,0))) > 3   OR
                       LENGTH(substring(string(ttQuotationLine.FinancialRatePercentage - TRUNCATE(ttQuotationLine.FinancialRatePercentage,0)),2,
                              LENGTH(STRING(ttQuotationLine.FinancialRatePercentage - TRUNCATE(ttQuotationLine.FinancialRatePercentage,0))))) > 4 THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-taxa-financeira AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Taxa_financeira" *}
                        ASSIGN c-lbl-liter-taxa-financeira = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-taxa-financeira + '~~~~' + string(ttQuotationLine.FinancialRatePercentage) + '~~~~999.9999'"}

                    END.

                    /* Dias Taxa financeira */
                    IF LENGTH(string(ttQuotationLine.FinancialRateDays)) > 3 THEN DO:    

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-dias-taxa-financeira AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Dias_Taxa_financeira" *}
                        ASSIGN c-lbl-liter-dias-taxa-financeira = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-dias-taxa-financeira + '~~~~' + string(ttQuotationLine.FinancialRateDays) + '~~~~999'"}

                    END.

                    /* Al°quota IPI */
                    IF LENGTH(string(TRUNCATE(ttQuotationLine.IndustrializedProductTaxPerce_00,0))) > 3   OR
                       LENGTH(substring(string(ttQuotationLine.IndustrializedProductTaxPerce_00 - TRUNCATE(ttQuotationLine.IndustrializedProductTaxPerce_00,0)),2,
                              LENGTH(STRING(ttQuotationLine.IndustrializedProductTaxPerce_00 - TRUNCATE(ttQuotationLine.IndustrializedProductTaxPerce_00,0))))) > 2 THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-aliquota-ipi AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Al°quota_IPI" *}
                        ASSIGN c-lbl-liter-aliquota-ipi = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-aliquota-ipi + '~~~~' + string(ttQuotationLine.IndustrializedProductTaxPerce_00) + '~~~~999.99'"}

                    END.

                    /* Valor frete */
                    IF LENGTH(string(TRUNCATE(ttQuotationLine.FreightValue,0))) > 9   OR
                       LENGTH(substring(string(ttQuotationLine.FreightValue - TRUNCATE(ttQuotationLine.FreightValue,0)),2,
                              LENGTH(STRING(ttQuotationLine.FreightValue - TRUNCATE(ttQuotationLine.FreightValue,0))))) > 4 THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-valor-de-frete AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Valor_de_frete" *}
                        ASSIGN c-lbl-liter-valor-de-frete = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-valor-de-frete + '~~~~' + string(ttQuotationLine.FreightValue) + '~~~~999999999.9999'"}

                    END.

                    /* Al°quota ICMS */
                    IF LENGTH(string(TRUNCATE(ttQuotationLine.ServicesAndProductsCirculatio_00,0))) > 3   OR
                       LENGTH(substring(string(ttQuotationLine.ServicesAndProductsCirculatio_00 - TRUNCATE(ttQuotationLine.ServicesAndProductsCirculatio_00,0)),2,
                              LENGTH(STRING(ttQuotationLine.ServicesAndProductsCirculatio_00 - TRUNCATE(ttQuotationLine.ServicesAndProductsCirculatio_00,0))))) > 2 THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-aliquota-icms AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Al°quota_ICMS" *}
                        ASSIGN c-lbl-liter-aliquota-icms = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-aliquota-icms + '~~~~' + string(ttQuotationLine.ServicesAndProductsCirculatio_00) + '~~~~999.99'"}

                    END.

                    /* Al°quota ISS */
                    IF LENGTH(string(TRUNCATE(ttQuotationLine.ServiceTaxPercentage,0))) > 3   OR
                       LENGTH(substring(string(ttQuotationLine.ServiceTaxPercentage - TRUNCATE(ttQuotationLine.ServiceTaxPercentage,0)),2,
                              LENGTH(STRING(ttQuotationLine.ServiceTaxPercentage - TRUNCATE(ttQuotationLine.ServiceTaxPercentage,0))))) > 2 THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-aliquota-iss AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Al°quota_ISS" *}
                        ASSIGN c-lbl-liter-aliquota-iss = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="51338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-aliquota-iss + '~~~~' + string(ttQuotationLine.ServiceTaxPercentage) + '~~~~999.99'"}

                    END.

                    /*Fim validaá∆o de valores*/
                end.

                /* Teste para encontrar algum registro do tipo erro na RowErrors, se encontrar nao criar a cotaá∆o, caso
                   seja apenas advertencia, deixara criar a cotaá∆o */
                IF l-paradigma THEN DO:
                    ASSIGN l-tipo-erro-encontrado = NO.
                    FOR EACH RowErrors,
                       FIRST cadast_msg NO-LOCK
                       WHERE cadast_msg.cdn_msg   = RowErrors.ErrorNumber
                         AND cadast_msg.idi_tip_msg = 1 /*Erro*/:
                        ASSIGN l-tipo-erro-encontrado = YES.
                    END.
                END.

                if (l-portal AND can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u) AND not can-find(first rowErrors)) OR
                   (NOT l-portal AND NOT l-paradigma) OR
                   (NOT can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u) AND NOT l-paradigma) OR
                   (l-paradigma AND NOT l-tipo-erro-encontrado) then do:

                    IF l-paradigma THEN DO:
                        RUN pi-verifica-cria-cotacao.

                    END. 
                    ELSE DO:
                        /* Execuá∆o da API de Efetivaá∆o */
                        RUN ocp/ocapi002.p (input        table ttDestinationPartner,
                                            INPUT        TABLE tt-parametros,
                                            INPUT        TABLE tt-cotacao-item-venc,
                                            INPUT        TABLE tt-prazo-compra,
                                            INPUT-OUTPUT TABLE tt-edital,
                                            OUTPUT       TABLE rowErrors).
                    END.
                end.

                IF (NOT l-portal AND NOT l-paradigma) OR
                   (NOT can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u) AND NOT l-paradigma) THEN 

                    FOR EACH rowErrors:
                        DELETE rowErrors.
                    END.

                EMPTY TEMP-TABLE tt-cotacao-item-venc.
                EMPTY TEMP-TABLE tt-edital.

            END.
        END.
        ELSE 
            /* Programa de efetivaá∆o n∆o localizado */
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'ocp/ocapi002.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu003.p" *}
            RUN setError IN hMessageHandler (INPUT 0,
                                             INPUT "enviroment_error":U,
                                             INPUT RETURN-VALUE + '.').
            END. 

    end.
    else do: /*add*/

        if l-portal and
           can-find(first ttDestinationPartner where ttDestinationPartner.Cod = "Webb":u) then do:

            def buffer bf-cotacao-item for cotacao-item.

            for each ttQuotationLine no-lock:

                create tt-cotacao-item-venc.
                assign tt-cotacao-item-venc.it-codigo = ttQuotationLine.ItemCode.

                find first ordem-compra where ordem-compra.numero-ordem = ttQuotationLine.POLineNumber no-lock no-error.

                &if '{&bf_mat_versao_ems}' < '2.09' &then                  

                    assign overlay(tt-cotacao-item-venc.char-2,103,18) = if ttQuotationLine.QuotationNumberPortal = ? then "":U else ttQuotationLine.QuotationNumberPortal
                           overlay(tt-cotacao-item-venc.char-2,101,1)  = if ttQuotationLine.Freeze = ? then "":U else ttQuotationLine.Freeze
                           overlay(tt-cotacao-item-venc.char-2,102,1)  = if ttQuotationLine.PortalIntegration = ? then "":U else ttQuotationLine.PortalIntegration
                           overlay(tt-cotacao-item-venc.char-2,121,18) = if ttQuotationLine.FornecQuotationNumberPortal = ? then "":U else ttQuotationLine.FornecQuotationNumberPortal.
                &else

                    assign tt-cotacao-item-venc.cod-cotac-portal  = ttQuotationLine.QuotationNumberPortal
                           tt-cotacao-item-venc.log-congela-cotac = if ttQuotationLine.Freeze = "S":U then yes else no
                           tt-cotacao-item-venc.log-integr-portal = if ttQuotationLine.PortalIntegration = "S":U then yes else no
                           tt-cotacao-item-venc.cod-respos-fornec = ttQuotationLine.FornecQuotationNumberPortal.
                &endif

                if avail ordem-compra then
                    assign tt-cotacao-item-venc.numero-ordem = ordem-compra.numero-ordem
                           tt-cotacao-item-venc.codigo-icm   = ordem-compra.codigo-icm
                           tt-cotacao-item-venc.it-codigo    = ordem-compra.it-codigo.
                else do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-ordem-compra-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Ordem_Compra" *}
                    ASSIGN c-lbl-liter-ordem-compra-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-ordem-compra-2 + string(ttQuotationLine.POLineNumber)"}                                               
                end.

                if ttQuotationLine.VendorNumber = ? or
                   ttQuotationLine.VendorNumber = 0 then do:

                    find first emitente where emitente.cgc = ttQuotationLine.VendorTaxID no-lock no-error.
                    if avail emitente THEN DO:
                        assign tt-cotacao-item-venc.cod-emitente = emitente.cod-emitente.
                        
                        IF emitente.identific = 1 THEN
                            {method/svc/errors/inserr.i &ErrorNumber="51594"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="string(emitente.cod-emitente) + '~~~~' + string(emitente.cgc)"}
                           
                    END.
                    else do:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-emitente-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Emitente" *}
                        ASSIGN c-lbl-liter-emitente-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-cnpj-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "CNPJ" *}
                        ASSIGN c-lbl-liter-cnpj-2 = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="16381"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-emitente-2 + '~~~~' + c-lbl-liter-cnpj-2 + ': ' + string(ttQuotationLine.VendorTaxID)"}
                    end.
                end.
                else
                    assign tt-cotacao-item-venc.cod-emitente = ttQuotationLine.VendorNumber.

                find last bf-cotacao-item where bf-cotacao-item.numero-ordem = tt-cotacao-item-venc.numero-ordem and
                                                bf-cotacao-item.cod-emitente = tt-cotacao-item-venc.cod-emitente and
                                                bf-cotacao-item.it-codigo    = tt-cotacao-item-venc.it-codigo no-lock no-error.
                if avail bf-cotacao-item then
                    assign tt-cotacao-item-venc.seq-cotac = bf-cotacao-item.seq-cotac + 1.
                ELSE
                    assign i-seq-cotac = i-seq-cotac + 1
                           tt-cotacao-item-venc.seq-cotac = i-seq-cotac.

                &if "{&ems_dbtype}":U = "MSS":U &then
                    if ttQuotationLine.QuotationDate = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF  then
                        assign ttQuotationLine.QuotationDate = 01/01/1800.
                &endif           

                assign tt-cotacao-item-venc.ind-orig-entrada = ttQuotationLine.QuotationSource
                       tt-cotacao-item-venc.data-atualiz     = ttQuotationLine.UpdateDate
                       tt-cotacao-item-venc.dias-validade    = ttQuotationLine.ExpirationDate - ttQuotationLine.UpdateDate
                       tt-cotacao-item-venc.prazo-entreg     = ttQuotationLine.DeliveryTerm
                       tt-cotacao-item-venc.mo-codigo        = ttQuotationLine.CurrencyID
                       tt-cotacao-item-venc.data-cotacao     = ttQuotationLine.QuotationDate
                       tt-cotacao-item-venc.un               = ttQuotationLine.UnitOfMeasureCode
                       tt-cotacao-item-venc.cod-comprado     = ordem-compra.cod-comprado when avail ordem-compra.

            end.

            if not can-find(first rowErrors) THEN DO:
                run ocp/ocapi003.p (input table tt-cotacao-item-venc,
                                    output table rowErrors append).
            END.
        end.
    end.

