PROCEDURE PIUpsertByPurchaseProcess:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM rw-proc-compra AS ROWID .
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    
    /*PARAMETERS - END*/
    
    /*LOCAL VARIABLES - BEGIN*/
    /*LOCAL VARIABLES - END*/
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    ASSIGN cEvent      = ""
           cTranAction = "upd"
           iQuoteLine  = 0
           iExtraInfo  = 0.

    /* Limpa temp-tables */
    EMPTY TEMP-TABLE ttPurchaseProcess.
    EMPTY TEMP-TABLE ttVendor.
    EMPTY TEMP-TABLE ttQuotationLine.
    EMPTY TEMP-TABLE ttDeliveryScheduleInforma_00.
    EMPTY TEMP-TABLE ttExtraInformation.
    EMPTY TEMP-TABLE ttImportInformation.

    /* Carga dos dados do processo - BEGIN */
    FIND FIRST proc-compra WHERE ROWID(proc-compra) = rw-proc-compra NO-LOCK NO-ERROR.
    RUN PILoadPurchaseProcessInfo.
    
    /* Carga das cotaá‰es do processo - BEGIN */
    FOR EACH  ordem-compra FIELDS (numero-ordem qt-solic narrativa cod-estabel)
        WHERE ordem-compra.nr-processo = proc-compra.nr-processo NO-LOCK,
        EACH  cotacao-item
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
        RUN PILoadQuotationLineInfo.
    END.
    
    RUN PIUpsert
    (
        INPUT cEvent,
        INPUT cTranAction,
        OUTPUT TABLE tt_log_erro,
        INPUT TABLE ttDeliveryScheduleInforma_00,
        INPUT TABLE ttExtraInformation,
        INPUT TABLE ttImportInformation,
        INPUT TABLE ttPurchaseProcess,
        INPUT TABLE ttQuotationLine,
        INPUT TABLE ttVendor 
    ).
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

PROCEDURE PIUpsertByQuoteList:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM TABLE FOR ttQuotation.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
    /*LOCAL VARIABLES - BEGIN*/
    /*LOCAL VARIABLES - END*/
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    ASSIGN cEvent      = ""
           cTranAction = "upd"
           iQuoteLine  = 0
           iExtraInfo  = 0
           iLastProcess = ?.

    /* Limpa temp-tables */
    EMPTY TEMP-TABLE ttPurchaseProcess.
    EMPTY TEMP-TABLE ttVendor.
    EMPTY TEMP-TABLE ttQuotationLine.
    EMPTY TEMP-TABLE ttDeliveryScheduleInforma_00.
    EMPTY TEMP-TABLE ttExtraInformation.
    EMPTY TEMP-TABLE ttImportInformation.

    /* Carga das cotaá‰es do processo - BEGIN */
    FOR EACH ttQuotation:
        
        FIND FIRST cotacao-item 
             WHERE ROWID(cotacao-item) = ttQuotation.rw-cotacao-item 
             NO-LOCK NO-ERROR.
        
        FOR FIRST ordem-compra FIELDS (numero-ordem qt-solic narrativa cod-estabel nr-processo)
            WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.
        
        ASSIGN  lSameProcess = IF iLastProcess = ? OR iLastProcess = ordem-compra.nr-processo THEN TRUE ELSE FALSE
                iLastProcess = ordem-compra.nr-processo.

        RUN PILoadQuotationLineInfo.
        /*
        ** Verifica se a cotaá∆o Ç da BBM
        */
        IF cotacao-item.ind-via-envio = 17 THEN
            ASSIGN lBBM = YES.

    END.

    IF  lSameProcess THEN DO:
        FIND FIRST proc-compra WHERE proc-compra.nr-processo = ordem-compra.nr-processo NO-LOCK NO-ERROR.
        IF AVAIL proc-compra THEN
            RUN PILoadPurchaseProcessInfo.
    END.
    ELSE
        CREATE ttPurchaseProcess.

    /*
    ** Agrupa as cotaá‰es em um lote quando mais de uma ordem de compra tiver o mesmo lote informado para a BBM
    */
    IF lBBM THEN DO:
        IF lAgrupaLote THEN DO:
            FOR EACH ttLote NO-LOCK:
    
                CREATE ttQuotationLineAux.
                FIND bttQuotationLine
                    WHERE bttQuotationLine.ttQuotationLineID = ttLote.ttQuotationLineID NO-ERROR.
                BUFFER-COPY bttQuotationLine TO ttQuotationLineAux.
                ASSIGN bttQuotationLine.POLineNumber = integer(ttLote.nr-lote).
    
                FOR EACH ttLoteOrdem 
                    WHERE ttLoteOrdem.nr-lote = ttLote.nr-lote
                      AND ttLoteOrdem.ttQuotationLineID <> ttLote.ttQuotationLineID:
                    
                    FIND ttQuotationLine
                        WHERE ttQuotationLine.ttQuotationLineID = ttLoteOrdem.ttQuotationLineID NO-ERROR.
    
                    ASSIGN bttQuotationLine.POLineQuantityRequested = bttQuotationLine.POLineQuantityRequested + ttQuotationLine.POLineQuantityRequested.

                    FIND ttExtraInformation
                        WHERE ttExtraInformation.ttQuotationLineID = bttQuotationLine.ttQuotationLineID
                          AND ttExtraInformation.infoKey = "BBM-VAL-ESTIMADO" NO-LOCK.
                    IF AVAIL ttExtraInformation THEN DO:
                        FIND bttExtraInformation
                            WHERE bttExtraInformation.ttQuotationLineID = ttQuotationLine.ttQuotationLineID
                              AND bttExtraInformation.infoKey           = "BBM-VAL-ESTIMADO" NO-LOCK. 
                        ASSIGN ttExtraInformation.infoValue = STRING(DECIMAL(ttExtraInformation.infoValue) + DECIMAL(bttExtraInformation.infoValue) ).
                    END.
    
                    DELETE ttQuotationLine.
                    FOR EACH ttExtraInformation
                        WHERE ttExtraInformation.ttQuotationLineID = ttLoteORdem.ttQuotationLineID NO-LOCK:
                        DELETE ttExtraInformation.
                    END.
                    FOR EACH ttImportInformation
                        WHERE ttImportInformation.ttQuotationLineID = ttLoteORdem.ttQuotationLineID NO-LOCK:
                        DELETE ttImportInformation.
                    END.
                    FOR EACH bttDeliveryScheduleInforma_00
                        WHERE bttDeliveryScheduleInforma_00.ttQuotationLineID = ttLoteOrdem.ttQuotationLineID NO-LOCK:
                        ASSIGN ttDeliveryScheduleInforma_00.ttQuotationLineID = ttLote.ttQuotationLineID.
                    END.
                    ASSIGN iDeliveryID = 1.
                    FOR EACH ttDeliveryScheduleInforma_00 
                        WHERE ttDeliveryScheduleInforma_00.ttQuotationLineID = ttLote.ttQuotationLineID
                           BY ttDeliveryScheduleInforma_00.DeliveryDate:
                        ASSIGN ttDeliveryScheduleInforma_00.DeliveryScheduleID = iDeliveryID.
                        ASSIGN iDeliveryID = iDeliveryID + 1.
                    END.
                END.
                
            END.
        END.
        ELSE DO:
            FOR EACH ttLoteOrdem:
                FIND ttQuotationLine
                    WHERE ttQuotationLine.ttQuotationLineID = ttLoteOrdem.ttQuotationLineID NO-ERROR.
                ASSIGN ttQuotationLine.POLineNumber = integer(ttLoteOrdem.nr-lote).
            END.
        END.
    END.

    RUN PIUpsert
    (
        INPUT cEvent,
        INPUT cTranAction,
        OUTPUT TABLE tt_log_erro,
        INPUT TABLE ttDeliveryScheduleInforma_00,
        INPUT TABLE ttExtraInformation,
        INPUT TABLE ttImportInformation,
        INPUT TABLE ttPurchaseProcess,
        INPUT TABLE ttQuotationLine,
        INPUT TABLE ttVendor
    ).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

/* PI de Carga dos dados do processo - BEGIN  */
PROCEDURE PILoadPurchaseProcessInfo:
    
    DEF VAR l-process-pregao AS LOG NO-UNDO.

    /* Busca o comprador do processo */
    FOR FIRST comprador FIELDS (nome e-mail telefone)
        WHERE comprador.cod-comprado = proc-compra.cod-comprado NO-LOCK: END.

    CREATE  ttPurchaseProcess.
    ASSIGN  ttPurchaseProcess.ttPurchaseProcessID   = 1
            ttPurchaseProcess.ProcessDescription    = proc-compra.descricao             /*Descriá∆o do Processo de Compra (Uso interno: campo = mgind.proc-compra.descricao)*/
            ttPurchaseProcess.ProcessText           = proc-compra.narrativa             /*Narrativa do processo de compra (Uso interno: campo = mgind.proc-compra.narrativa)*/
            &IF "{&bf_mat_versao_ems}":U >= "2.07":U &then
                ttPurchaseProcess.ProclaimNumber    = proc-compra.cod-edital            /*N£mero do edital de compra - Preg∆o Eletronico (Uso interno: Campo = mgind.proc-compra.cod-edital)*/
            &ELSE
                ttPurchaseProcess.ProclaimNumber    = SUBSTR(proc-compra.char-2,1,100)  /*N£mero do edital de compra - Preg∆o Eletronico (Uso interno: Campo = mgind.proc-compra.cod-edital)*/
            &ENDIF
            ttPurchaseProcess.PurchaseProcessNumber = proc-compra.nr-processo           /*N£mero do Processo de Compra. (Uso interno: Campo = mgind.proc-compra.nr-processo) */
            ttPurchaseProcess.StartDate             = proc-compra.dt-inicio             /*Data de In°cio do Processo de Compra (Uso interno: campo = mgind.proc-compra.dt-inicio)*/
            ttPurchaseProcess.BuyerID               = proc-compra.cod-comprado          /*C¢digo do comprador do item. (Uso interno: Campo = mgind.comprador.cod-comprado)*/
            ttPurchaseProcess.BuyerName             = comprador.nome                    /*Nome do comprador do item. (Uso interno: Campo = mgind.comprador.nome)*/
            ttPurchaseProcess.EmailAddress          = comprador.e-mail                  /*Endereáo eletronico do comprador (Uso Interno: Campo = mgind.comprador.e-mail)*/
            ttPurchaseProcess.PhoneNumber           = comprador.telefone[1].            /*Telefone do comprador. (Uso interno: Campo = mgind.comprador.telefone[1])*/

    /* Carrega os fornecedores do processo */
    FOR EACH  proc-fornec
        WHERE proc-fornec.nr-processo = proc-compra.nr-processo NO-LOCK:
        
        /* Busca o emitente relacionado ao processo */
        FOR FIRST emitente FIELDS (nome-emit nome-abrev cgc telefone e-mail)
            WHERE emitente.cod-emitente = proc-fornec.cod-emitente NO-LOCK: END.

        CREATE  ttVendor.
        ASSIGN  ttVendor.ttPurchaseProcessID        = 1
                ttVendor.ttVendorID                 = proc-fornec.cod-emitente
                ttVendor.VendorNumber               = proc-fornec.cod-emitente  /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.cod-emitente)*/
                ttVendor.VendorName                 = emitente.nome-emit        /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.nome-emit)*/
                ttVendor.VendorShortName            = emitente.nome-abrev       /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.nome-abrev)*/
                ttVendor.VendorTaxID                = emitente.cgc.             /*CGC ou CPF do fornecedor (Uso Interno: Campo = emitente.cgc)*/
    END.

    &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
        ASSIGN l-process-pregao = IF INT(SUBSTRING(proc-compra.char-1,4,1)) = 1 THEN YES ELSE NO.
    &ELSE
        ASSIGN l-process-pregao = proc-compra.log-proces-pregao.
    &ENDIF
    
    IF l-process-pregao THEN DO:
        CREATE  ttVendor.
        ASSIGN  ttVendor.ttPurchaseProcessID = 1
                ttVendor.ttVendorID          = 0
                ttVendor.VendorTaxID         = "".
    END.

END.
/* PI de Carga dos dados do processo - END    */

PROCEDURE PILoadQuotationLineInfo:

    /* Fornecedor */
    FOR FIRST emitente FIELDS (nome-emit nome-abrev cgc telefone e-mail)
        WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-LOCK: END.

    /* Item */
    FOR FIRST ITEM FIELDS (desc-item)
        WHERE ITEM.it-codigo = cotacao-item.it-codigo NO-LOCK: END.

    /* Item Materiais */
    FOR FIRST item-mat FIELDS (cod-ean)
        WHERE item-mat.it-codigo = cotacao-item.it-codigo NO-LOCK: END.

    /* Item do Fornecedor */
    FOR FIRST item-fornec FIELDS (item-do-forn)
        WHERE item-fornec.it-codigo    = cotacao-item.it-codigo 
        AND   item-fornec.cod-emitente = cotacao-item.cod-emitente NO-LOCK: END.

    /* Localiza a primeira parcela de compra para pegar a unidade de medida e a referencia */
    FOR FIRST prazo-compra FIELDS (un cod-refer)
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK: END.

    /* Localiza a unidade de medida da parcela de compra */
    IF AVAIL prazo-compra THEN
       FOR FIRST tab-unidade FIELDS (descricao)
           WHERE tab-unidade.un = prazo-compra.un NO-LOCK: END.

    /* Localiza a unidade de medida da cotaá∆o */
    DEFINE BUFFER tab-und-cot FOR tab-unidade.
    FOR FIRST tab-und-cot FIELDS (descricao)
        WHERE tab-und-cot.un = cotacao-item.un NO-LOCK: END.

    /* Localiza a tabela de preáo */
    IF cotacao-item.nr-tab <> "" THEN DO:
       FOR FIRST tb-pr-cc
           WHERE tb-pr-cc.nr-tab       = cotacao-item.nr-tab
             AND tb-pr-cc.cod-cond-pag = cotacao-item.cod-cond-pag
             AND tb-pr-cc.cod-emitente = cotacao-item.cod-emitente
             AND tb-pr-cc.cod-estabel  = ordem-compra.cod-estabel 
             AND tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo NO-LOCK: END.

        IF NOT AVAIL tb-pr-cc THEN
           FOR FIRST tb-pr-cc
               WHERE tb-pr-cc.nr-tab       = cotacao-item.nr-tab
                 AND tb-pr-cc.cod-cond-pag = cotacao-item.cod-cond-pag
                 AND tb-pr-cc.cod-emitente = cotacao-item.cod-emitente
                 AND tb-pr-cc.cod-estabel  = ""
                 AND tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo NO-LOCK: END.
    END.

    /* Localiza a condiá∆o de pagamento */
    FOR FIRST cond-pagto FIELDS (descricao)
        WHERE cond-pagto.cod-cond-pag = cotacao-item.cod-cond-pag NO-LOCK: END.

    /* Localiza a moeda */
    FOR FIRST moeda FIELDS (descricao sigla)
        WHERE moeda.mo-codigo = cotacao-item.mo-codigo NO-LOCK: END.

    /* Localiza o comprador */
    IF cotacao-item.cod-comprado <> "" THEN
        FOR FIRST comprador FIELDS (nome e-mail telefone)
            WHERE comprador.cod-comprado = cotacao-item.cod-comprado NO-LOCK: END.

    /* Localiza o aprovador */
    IF cotacao-item.aprovador <> "" THEN
       FOR FIRST usuar-mater FIELDS (nome-usuar)
           WHERE usuar-mater.cod-usuario = cotacao-item.aprovador NO-LOCK: END.

    /* Localiza o usuario que implantou a cotaá∆o */
    IF cotacao-item.usuario <> "" THEN
        FOR FIRST usuar_mestre FIELDS (nom_usuario)
            WHERE usuar_mestre.cod_usuario = cotacao-item.usuario NO-LOCK: END.

    /* Localiza a transportadora */
    IF cotacao-item.cod-transp <> 0 THEN
       FOR FIRST transporte FIELDS (contato e-mail nome telefone via-transp)
           WHERE transporte.cod-transp = cotacao-item.cod-transp NO-LOCK: END.

    /* Estabelecimento da Ordem de Compra */
    IF ordem-compra.cod-estabel <> ? THEN
       FOR FIRST estabelec FIELDS (estado)
           WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
    
    CREATE  ttQuotationLine.
    ASSIGN  iQuoteLine                                       = iQuoteLine + 1
            ttQuotationLine.ttQuotationLineID                = iQuoteLine
            ttQuotationLine.POLineNumber                     = ordem-compra.numero-ordem                            /*N£mero da ordem de compra. (Uso interno: Campo = movind.cotacao-item.numero-ordem) */
            ttQuotationLine.POLineQuantityRequested          = ordem-compra.qt-solic                                /*Quantidade interna total solicitada na ordem de compra. (Uso Interno: Campo = movind.ordem-compra.qt-solic)*/
            ttQuotationLine.ApprovalReason                   = cotacao-item.motivo-apr                              /*Motivo aprovaá∆o / rejeiá∆o da cotaá∆o. (Uso interno: Campo = mgind.cotacao-item.motivo-apr)*/
            ttQuotationLine.DeliveryTerm                     = cotacao-item.prazo-entreg                            /*Prazo Entrega. (Uso interno: Campo = movind.cotacao-item.prazo-entreg) */
            ttQuotationLine.DiscountAmount                   = cotacao-item.valor-descto                            /*Valor de Desconto. (Uso Interno: Campo = movind.cotacao-item.valor-descto)*/
            ttQuotationLine.DiscountPercentage               = cotacao-item.perc-descto                             /*Percentual de Desconto. (Uso Interno: Campo =  movind.cotacao-item.perc-descto)*/
            ttQuotationLine.FinancialRateDays                = cotacao-item.nr-dias-taxa                            /*N£mero de dias da taxa financeira (Uso Interno: Campo = movind.cotacao-item.nr-dias-taxa)*/
            ttQuotationLine.FinancialRatePercentage          = cotacao-item.valor-taxa                              /*Define o percentual da taxa financeira. (Uso Interno: Campo =  movind.cotacao-item.valor-taxa)*/
            ttQuotationLine.FreightValue                     = cotacao-item.valor-frete                             /*Valor do Frete. (Uso Interno: Campo = movind.cotacao-item.valor-frete)*/
            ttQuotationLine.IndustrializedProductTaxPerce_00 = cotacao-item.aliquota-ipi                            /*Al°quota de IPI. (Uso Interno: Campo =  movind.cotacao-item.aliquota-ipi)*/
            ttQuotationLine.IsFinancialRateIncluded          = cotacao-item.taxa-financ                             /*Define se os encargos financeiros est∆o inclusos. (Uso Interno: Campo =  movind.cotacao-item.taxa-financ)*/
            ttQuotationLine.IsFreightIncluded                = cotacao-item.frete                                   /*Frete Incluso? Valores: YES = "FOB", NO = "CIF". (Uso Interno: Campo = movind.cotacao-item.frete)*/
            ttQuotationLine.IsIndustrializedProductTaxInc_00 = cotacao-item.codigo-ipi                              /*IPI Incluso? (Uso Interno: Campo = movind.cotacao-item.codigo-ipi)*/
            ttQuotationLine.IsQuoteApproved                  = cotacao-item.cot-aprovada                            /*Cotaá∆o aprovada Sim/N∆o. (Uso Interno: Campo = mgind.cotacao-item.cot-aprovada)*/
            ttQuotationLine.IsQuoteReturned                  = cotacao-item.ind-ret-cotacao                         /*Indica se hove retorno da cotaá∆o do fornecedor (via edi ou por meios normais fax, telex, etc ...). (Uso interno: Campo = movind.cotacao-item.ind-ret-cotacao)*/
            ttQuotationLine.NetUnitaryPrice                  = cotacao-item.preco-unit                              /*Preáo unit†rio interno incluso impostos, desconto, ipi e taxa. (Uso Interno: Campo = movind.cotacao-item.preco-unit)*/
            ttQuotationLine.QuotationDate                    = cotacao-item.data-cotacao                            /*Data de Emiss∆o. (Uso interno: Campo = movind.cotacao-item.data-cotacao)*/
            ttQuotationLine.QuotationSending                 = cotacao-item.ind-via-envio                           /*Via de envio da cotaá∆o (Uso interno: Campo = movind.cotacao-item.ind-via-envio - Include = diinc/i07di159.i)*/
            ttQuotationLine.QuotationSource                  = cotacao-item.ind-orig-entrada                        /*Origem de entrada da cotaá∆o (Uso interno: Campo = movind.cotacao-item.ind-orig-entrada - Include = diinc/i07di159.i)*/
            ttQuotationLine.QuoteDispatchProcessNumber       = cotacao-item.num-proc-envio-edi                      /*N£mero do processo de envio da cotaá∆o. (Uso interno: Campo = movind.cotacao-item.num-proc-envio-edi)*/
            ttQuotationLine.QuoteEntryProcessNumber          = cotacao-item.num-proc-entr-edi                       /*N£mero do processo de entrada da cotaá∆o. (Uso interno: Campo = movind.cotacao-item.num-proc-entr-edi)*/
            ttQuotationLine.QuoteSequence                    = cotacao-item.seq-cotac                               /*Sequencia da cotaá∆o de preáos. (Uso interno: Campo = movind.cotacao-item.seq-cotac)*/
            ttQuotationLine.QuoteText                        = cotacao-item.narrativa                               /*Narrativa. (Uso Interno: Campo = movind.cotacao-item.narrativa)*/
            ttQuotationLine.ReadjustQuote                    = cotacao-item.reajusta-cotacao                        /*Reajusta cotaá∆o. (Uso Interno: Campo =  movind.cotacao-item.reajusta-cotacao)*/
            ttQuotationLine.ReadjustRatePercentage           = cotacao-item.valor-taxa                              /*Define o percentual da taxa financeira. (Uso Interno: Campo =  movind.cotacao-item.valor-taxa)*/
            ttQuotationLine.ServicesAndProductsCirculatio_00 = cotacao-item.aliquota-icm                            /*Al°quota de ICMS. (Uso Interno: Campo =  movind.cotacao-item.aliquota-icm)*/
            ttQuotationLine.ServicesAndProductsCirculatio_01 = cotacao-item.codigo-icm                              /*C¢digo do ICMS. Valores: 1 - Consumo, 2 - Industrializaá∆o. (Uso interno: Campo = mguni.cotacao-item.codigo-icms - Include = ininc/i01in082.i)*/
            ttQuotationLine.ServiceTaxPercentage             = cotacao-item.aliquota-iss                            /*Aliquota ISS (Uso Interno: Campo =  movind.cotacao-item.aliquota-iss)*/
            ttQuotationLine.UpdateDate                       = cotacao-item.data-atualiz                            /*Data em que foi efetuada a £ltima alteraá∆o na ordem de compra. (Uso Interno: Campo = movind.cotacao-item.data-atualiz) */
            ttQuotationLine.UpdateTime                       = cotacao-item.hora-atualiz                            /*Hora em que foi efetuada a £ltima alteraá∆o na ordem de compra. (Uso Interno: Campo = movind.cotacao-item.hora-atualiz)*/
            ttQuotationLine.ValidityDays                     = cotacao-item.dias-validade                           /*Dias de validade da cotaá∆o (Uso interno: Campo = movind.cotacao-item.dias-validade)*/
            ttQuotationLine.VendorPrice                      = cotacao-item.preco-fornec                            /*Preáo do Fornecedor. (Uso Interno: Campo = movind.cotacao-item.preco-fornec)*/
            ttQuotationLine.VendorUnitaryPrice               = cotacao-item.pre-unit-for                            /*Preáo unit†rio fornecedor incluso impostos, desconto, ipi e taxa. (Uso Interno: Campo = movind.cotacao-item.pre-uni-for)*/
            ttQuotationLine.VendorNumber                     = cotacao-item.cod-emitente                            /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.cod-emitente)*/
            ttQuotationLine.ContactName                      = cotacao-item.contato                                 /*Contato. Deve ser um contato relacionado ao fornecedor do pedido (ordem-compra.cod-emitente) (Uso Interno: Campo = mgadm.cont-emit.nome)*/
            ttQuotationLine.VendorName                       = emitente.nome-emit        WHEN AVAIL emitente        /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.nome-emit)*/
            ttQuotationLine.VendorShortName                  = emitente.nome-abrev       WHEN AVAIL emitente        /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.nome-abrev)*/
            ttQuotationLine.VendorTaxID                      = emitente.cgc              WHEN AVAIL emitente        /*CGC ou CPF do fornecedor (Uso Interno: Campo = emitente.cgc)*/
            ttQuotationLine.PhoneNumber                      = emitente.telefone[1]      WHEN AVAIL emitente        /*Telefone da pessoa de contato (Uso Interno: Campo = mgadm.cont-emit.telefone)*/    
            ttQuotationLine.EmailAddress                     = emitente.e-mail           WHEN AVAIL emitente        /*Endereáo de e-mail da pessoa de contato (uso Interno: Campo = mgadm.cont-emit.e-mail)*/
            ttQuotationLine.ItemCode                         = cotacao-item.it-codigo                               /*C¢digo do Item. (Uso Interno: Campo = mgind.item.it-codigo)*/
            ttQuotationLine.ItemDescription                  = ITEM.desc-item            WHEN AVAIL ITEM            /*Descriá∆o do item. (Uso Interno: Campo = mgind.item.desc-item)*/
            ttQuotationLine.EANCode                          = item-mat.cod-ean          WHEN AVAIL item-mat        /*Codificaá∆o internacional EAN do Item. (Uso Interno: Campo = mgind.item-mat.cod-ean)*/
            ttQuotationLine.VendorCode                       = item-fornec.item-do-forn  WHEN AVAIL item-fornec     /*C¢digo do item fornecedor / fabricante (Uso Interno: Campo = mgind.item-fornec.item-do-forn)*/    
            ttQuotationLine.ItemReferenceCode                = prazo-compra.cod-refer    WHEN AVAIL prazo-compra    /*C¢digo de referància do item. (Uso Interno: Campo = mgind.referencia.cod-refer)*/
            ttQuotationLine.UnitOfMeasureCode                = prazo-compra.un           WHEN AVAIL prazo-compra    /*C¢digo da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.un)*/
            ttQuotationLine.UnitOfMeasureDescription         = tab-unidade.descricao     WHEN AVAIL tab-unidade     /*Descriá∆o da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.desc)*/
            ttQuotationLine.UnitOfMeasureCode_00             = cotacao-item.un                                      /*C¢digo da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.un)*/
            ttQuotationLine.UnitOfMeasureDescription_00      = tab-und-cot.descricao     WHEN AVAIL tab-und-cot     /*Descriá∆o da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.desc)*/
            ttQuotationLine.PriceTableNumber                 = cotacao-item.nr-tab                                  /*Numero da tabela de preáos. (Uso Interno: Campo = mgind.tb-pr-cc.nr-tab)*/
            ttQuotationLine.PriceTableDescription            = tb-pr-cc.descricao        WHEN AVAIL tb-pr-cc        /*Descriá∆o da tabela financeira. (Uso Interno: Campo = mgind.tb-pr-cc.descricao - Descricao) */
            ttQuotationLine.PaymentPlanCode                  = cotacao-item.cod-cond-pag                            /*C¢digo da condiá∆o de pagamento. (Uso Interno: Campo =   mgadm.cond-pagto.cod-cond-pag )*/
            ttQuotationLine.PaymentPlanDescription           = cond-pagto.descricao      WHEN AVAIL cond-pagto      /*Descriá∆o da condiá∆o de pagamento (Uso Interno: Campo = mgadm.cond-pagto.descricao)*/    
            ttQuotationLine.CurrencyID                       = cotacao-item.mo-codigo                               /*C¢digo da moeda (Uso Interno: Campo =  mguni.moeda.mo-codigo)*/
            ttQuotationLine.CurrencyDescription              = moeda.descricao           WHEN AVAIL moeda           /*Nome da moeda (Uso Interno: Campo =  mguni.moeda.descricao)*/
            ttQuotationLine.CurrencySign                     = moeda.sigla               WHEN AVAIL moeda           /*Sigla da moeda. (Uso Interno: Campo = mguni.moeda.sigla)*/
            ttQuotationLine.ApproverID                       = cotacao-item.aprovador                               /*C¢digo do comprador do item. (Uso interno: Campo = mgind.aprovador.cod-aprov)*/
            ttQuotationLine.ApproverName                     = usuar-mater.nome-usuar    WHEN AVAIL usuar-mater     /*Nome do comprador do item. (Uso interno: Campo = mgind.aprovador.nome)*/
            ttQuotationLine.BuyerID                          = cotacao-item.cod-comprado                            /*C¢digo do comprador do item. (Uso interno: Campo = mgind.comprador.cod-comprado)*/
            ttQuotationLine.BuyerEmailAddress                = comprador.e-mail          WHEN AVAIL comprador       /*Endereáo eletronico do comprador (Uso Interno: Campo = mgind.comprador.e-mail)*/
            ttQuotationLine.BuyerName                        = comprador.nome            WHEN AVAIL comprador       /*Nome do comprador do item. (Uso interno: Campo = mgind.comprador.nome)*/
            ttQuotationLine.BuyerPhoneNumber                 = comprador.telefone[1]     WHEN AVAIL comprador       /*Telefone do comprador. (Uso interno: Campo = mgind.comprador.telefone[1])*/
            ttQuotationLine.cUserID                          = cotacao-item.usuario                                 /*Identificador do usu†rio (Uso Interno: Campo = usuar_mestre.cod_usuario)*/
            ttQuotationLine.UserName                         = usuar_mestre.nom_usuario  WHEN AVAIL usuar_mestre    /*Nome usu†rio (Uso Interno: Campo = usuar_mestre.nom_usuario)*/
            ttQuotationLine.CarrierID                        = cotacao-item.cod-transp                              /*C¢digo de identificaá∆o da transportadora (Uso Interno: Campo =  transporte.cod-transp)*/
            ttQuotationLine.CarrierContactEmail              = transporte.e-mail         WHEN AVAIL transporte      /*Endereáo de e-mail da pessoa de contato (uso Interno: Campo = mgadm.cont-emit.e-mail)*/
            ttQuotationLine.CarrierContactName               = transporte.contato        WHEN AVAIL transporte      /*Contato. Deve ser um contato relacionado ao fornecedor do pedido (ordem-compra.cod-emitente) (Uso Interno: Campo = mgadm.cont-emit.nome)*/
            ttQuotationLine.CarrierContactPhone              = transporte.telefone       WHEN AVAIL transporte      /*Telefone da pessoa de contato (Uso Interno: Campo = mgadm.cont-emit.telefone)*/
            ttQuotationLine.CarrierName                      = transporte.nome           WHEN AVAIL transporte      /*Nome do transportador (Uso Interno: Campo = transporte.nome)*/
            ttQuotationLine.CarrierShippingMethod            = transporte.via-transp     WHEN AVAIL transporte      /*MÇtodo de transporte do transportador (Uso Interno: Campo = transporte.via-transp -  Include: adinc/i01ad268.i)*/
            ttQuotationLine.POLineText                       = ordem-compra.narrativa                               /*Narrativa da ordem de compra. (Uso Interno: Campo = movind.orde-compra.narrativa)*/                                                                                                               
            ttQuotationLine.DestineState                     = estabelec.estado          WHEN AVAIL estabelec.      /*Estado do estabelecimento da ordem de compra (Uso interno: Campo = mgadm.estabelec.estado)*/

    /* Carrega as parcelas de compra */
    FOR EACH prazo-compra OF ordem-compra NO-LOCK:
        CREATE  ttDeliveryScheduleInforma_00.
        ASSIGN  ttDeliveryScheduleInforma_00.ttQuotationLineID              = ttQuotationLine.ttQuotationLineID
                ttDeliveryScheduleInforma_00.ttDeliveryScheduleInforma_00ID = prazo-compra.parcela
                ttDeliveryScheduleInforma_00.DeliveryScheduleID             = prazo-compra.parcela                                            /*Parcela da Ordem de Compra (Uso Interno: Campo = prazo-compra.parcela)*/
                ttDeliveryScheduleInforma_00.Quantity                       = prazo-compra.quantidade   WHEN prazo-compra.quantidade   <> 0   /*Quantidade.  (Uso Interno: Campo = prazo-compra.quantidade)*/
                ttDeliveryScheduleInforma_00.OriginalQuantity               = prazo-compra.quantid-orig WHEN prazo-compra.quantid-orig <> 0   /*Quantidade Original. (Uso Interno: Campo = prazo-compra.quant-orig)*/
                ttDeliveryScheduleInforma_00.BalenceQuantity                = prazo-compra.quant-saldo  WHEN prazo-compra.quant-saldo  <> 0   /*Quantidade Saldo. (Uso Interno: Campo = prazo-compra.quant-saldo)*/
                ttDeliveryScheduleInforma_00.ReturnedQuantity               = prazo-compra.quant-rejeit WHEN prazo-compra.quant-rejeit <> 0   /*Quantidade Rejeitada. (Uso Interno: Campo = prazo-compra.quant-rejeit)*/
                ttDeliveryScheduleInforma_00.ReceivedQuantity               = prazo-compra.quant-receb  WHEN prazo-compra.quant-receb  <> 0   /*Quantidade Recebida. (Uso Interno: Campo = prazo-compra.quant-receb)*/
                ttDeliveryScheduleInforma_00.VendorQuantity                 = prazo-compra.qtd-do-forn  WHEN prazo-compra.qtd-do-forn  <> 0   /*Quantidade do Fornecedor. (Uso Interno: Campo = prazo-compra.qtd-do-forn)*/
                ttDeliveryScheduleInforma_00.VendorBalenceQuantity          = prazo-compra.qtd-sal-forn WHEN prazo-compra.qtd-sal-forn <> 0   /*Quantidade de Saldo do Fornecedor. (Uso Interno: Campo = prazo-compra.qtd-sal-forn)*/
                ttDeliveryScheduleInforma_00.VendorReturnedQuantity         = prazo-compra.qtd-rej-forn WHEN prazo-compra.qtd-rej-forn <> 0   /*Quantidade Devolvida p/ o Fornecedor. (Uso Interno: Campo = prazo-compra.qtd-rej-forn)*/
                ttDeliveryScheduleInforma_00.VendorReceivedQuantity         = prazo-compra.qtd-rec-forn WHEN prazo-compra.qtd-rec-forn <> 0   /*Quantidade Recebida do Fornecedor. (Uso Interno: Campo = prazo-compra.qtd-rec-forn)*/
                ttDeliveryScheduleInforma_00.DeliveryDate                   = prazo-compra.data-entrega                                       /*Data Entrega. (Uso Interno: Campo = prazo-compra.data-entrega) */
                ttDeliveryScheduleInforma_00.OriginalDeliveryDate           = prazo-compra.data-orig                                          /*Data Entrega Original. (Uso Interno: Campo = prazo-compra.data-orig) */
                ttDeliveryScheduleInforma_00.DeliveryTime                   = STRING(prazo-compra.hora)                                       /*Hora a ser efetuada entrega. (Uso Interno: Campo = prazo-compra.hora)*/
                ttDeliveryScheduleInforma_00.Concentration                  = prazo-compra.concentracao WHEN prazo-compra.concentracao <> 0   /*Concentraá∆o do Item.  (Uso Interno: Campo = prazo-compra.concentracao)*/
                ttDeliveryScheduleInforma_00.Efficiency                     = prazo-compra.rendimento   WHEN prazo-compra.concentracao <> 0   /*Rendimento.  (Uso Interno: Campo = prazo-compra.rendimento)*/
                ttDeliveryScheduleInforma_00.UpdateDate                     = prazo-compra.data-alter                                         /*Data Entrega. (Uso Interno: Campo = prazo-compra.data-alter) */
                ttDeliveryScheduleInforma_00.DeliveryScheduleStatus         = prazo-compra.situacao.                                          /*Situaá∆o da Parcela. Valores: 1 - N∆o Confirmada, 2 - Confirmada, 3 - Cotada, 4 - Eliminada, 5 - Em Cotaá∆o, 6 - Recebida. (Uso interno: Campo = ordem-compra.natureza - Include = ininc/i02in274.i)*/
    END.

    /* Informaá‰es do M¢dulo de Importaá∆o */
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF param-global.modulo-07 AND CONNECTED("mgcex") THEN DO:

        FIND emitente
            WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente and
           (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:
        /* Localiza o pais */
        FOR FIRST pais FIELDS (nome-pais)
            WHERE pais.cod-pais = cotacao-item.cdn-pais-orig NO-LOCK: END.

        /* Localiza a classificaá∆o fiscal */
        FOR FIRST classif-fisc FIELD (descricao)
            WHERE classif-fisc.class-fiscal = cotacao-item.class-fiscal NO-LOCK: END.

        /* Localiza o Fabricante */
        RELEASE emitente.
        IF cotacao-item.cdn-fabrican <> ? AND cotacao-item.cdn-fabrican <> 0 THEN
           FOR FIRST emitente FIELDS (nome-emit)
               WHERE emitente.cod-emitente = cotacao-item.cdn-fabrican NO-LOCK: END.
        
        CREATE  ttImportInformation.
        ASSIGN  ttImportInformation.ttImportInformationID                    = 1
                ttImportInformation.ttQuotationLineID                        = ttQuotationLine.ttQuotationLineID
                ttImportInformation.ControlPointCode                         = cotacao-item.cdn-pto-control           /*C¢digo do ponto de controle. (Uso interno: Campo = mgcex.pto-contr.cod-pto-contr)*/
                ttImportInformation.ControlPointCode_00                      = cotacao-item.cod-pto-contr-base        /*C¢digo do ponto de controle. (Uso interno: Campo = mgcex.pto-contr.cod-pto-contr)*/
                ttImportInformation.ControlPointDescription                  = ?                                      /*Descriá∆o do ponto de despacho. (Uso interno: Campo = Campo: mgcex.pto-contr.descricao)*/
                ttImportInformation.ControlPointDescription_00               = ?                                      /*Descriá∆o do ponto de despacho. (Uso interno: Campo = Campo: mgcex.pto-contr.descricao)*/
                ttImportInformation.CountryCode                              = cotacao-item.cdn-pais-orig             /*C¢digo identificador do pa°s. (Uso interno: Campo = mguni.pais.cod-pais)*/
                ttImportInformation.CountryName                              = pais.nome-pais WHEN AVAIL pais         /*Nome do pa°s. (Uso interno: Campo = mguni.pais.nome-pais)*/
                ttImportInformation.DeliveryDate                             = cotacao-item.dt-entrega                /*Data de entrega da mercadoria. (Uso interno: Campo = movind.cotacao-item.dt-entrega)*/
                ttImportInformation.FiscalClassificationDescription          = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE ""                 /*Descriá∆o da classificaá∆o fiscal. (Uso interno: Campo = mgind.classif-fisc.descricao)*/
                ttImportInformation.FiscalClassificationID                   = cotacao-item.class-fiscal              /*C¢digo da classificaá∆o fiscal. (Uso interno: Campo = mgind.classif-fisc.class-fiscal)*/
                ttImportInformation.ImportationRulesCode                     = ?                                      /*C¢digo do regime de importaá∆o. (Uso interno: Campo = mgcex.pais-aliquota.regime-import)*/
                ttImportInformation.ImportationRulesDescription              = ?                                      /*Descriá∆o do regime de importaá∆o. (Uso interno: Campo = mgcex.pais-aliquota.des-regim-import)*/
                ttImportInformation.ImportationTaxPercentage                 = cotacao-item.aliquota-ii               /*Aliquota do imposto de importaá∆o. (Uso interno: Campo = movind.cotacao-item.aliquota-ii)*/
                ttImportInformation.Incoterm                                 = cotacao-item.cod-incoterm              /*Incoterm para importaá∆o. (Uso interno: Campo = movind.cotacao-item.cod-incoterm)*/
                ttImportInformation.ItineraryCode                            = cotacao-item.itinerario                /*C¢digo Itiner†rio. (Uso interno: Campo = mgcex.itinerario.cod-itiner)*/
                ttImportInformation.ItineraryDescription                     = ?                                      /*Descriá∆o do Itiner†rio. (Uso interno: Campo = mgcex.itinerario.descricao)*/
                ttImportInformation.ManufacturerName                         = emitente.nome-emit WHEN AVAIL emitente /*Nome do Fabricante. ( Uso Interno: Campo= emitente.nome-emit)*/
                ttImportInformation.ManufacturerNumber                       = cotacao-item.cdn-fabrican              /*C¢digo do Fabricante. ( Uso Interno: Campo= emitente.cod-emitente)*/
                ttImportInformation.QuoteMap                                 = cotacao-item.mapa-cotacao              /*Mapa cotaá∆o. (Uso interno: Campo = movind.cotacao-item.mapa-cotacao)*/
                ttImportInformation.ShipmentDate                             = cotacao-item.dt-embarque.              /*Data de embarque da mercadoria. (Uso interno: Campo = movind.cotacao-item.dt-embarque*/
        END.
    END.
        
    /* Informaá‰es Extras do Preg∆o */
    FOR EACH  campo-lote-pregao-ord
        WHERE campo-lote-pregao-ord.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

        FOR FIRST campo-lote-pregao FIELDS (cdn-tip-dado log-envia-pregao)
            WHERE campo-lote-pregao.cdn-tip-lote-pregao = campo-lote-pregao-ord.cdn-tip-lote-pregao
            AND   campo-lote-pregao.cod-campo           = campo-lote-pregao-ord.cod-campo NO-LOCK: END.

        IF NOT campo-lote-pregao.log-envia-pregao THEN NEXT.

        CREATE ttExtraInformation.
        ASSIGN iExtraInfo                              = iExtraInfo + 1
               ttExtraInformation.ttExtraInformationID = iExtraInfo
               ttExtraInformation.ttQuotationLineID    = ttQuotationLine.ttQuotationLineID
               ttExtraInformation.InfoKey              = campo-lote-pregao-ord.cod-campo        /*Chave da informaá∆o extra*/
               ttExtraInformation.InfoValue            = campo-lote-pregao-ord.dsl-conteudo.
    
        /*Tipo de dado da informaá∆o extra. Tipo de dado da informaá∆o extra. Valores: 1 - AlfanumÇrico, 2 - NumÇrico, 3 - Decimal, 4 - L¢gico, 5 - Data, 6 - Bin†rio*/
        IF campo-lote-pregao-ord.cod-campo = "BBM-ANEXO-ARQ":U THEN 
            ASSIGN ttExtraInformation.InfoType  = 6.
        ELSE 
            ASSIGN ttExtraInformation.InfoType  = campo-lote-pregao.cdn-tip-dado.

        IF campo-lote-pregao-ord.cod-campo = "BBM-NR-LOTE":U THEN DO:
            FIND ttLote
                WHERE ttLote.nr-lote = campo-lote-pregao-ord.dsl-conteudo NO-LOCK NO-ERROR.
            IF AVAIL ttLote THEN
                ASSIGN lAgrupaLote = YES.
            ELSE DO:
                CREATE ttLote.
                ASSIGN ttLote.nr-lote           = campo-lote-pregao-ord.dsl-conteudo
                       ttLote.ttQuotationLineID = ttQuotationLine.ttQuotationLineID.

            END.
            CREATE ttLoteOrdem.
            ASSIGN ttLoteOrdem.nr-lote           = campo-lote-pregao-ord.dsl-conteudo
                   ttLoteOrdem.numero-ordem      = campo-lote-pregao-ord.numero-ordem
                   ttLoteOrdem.ttQuotationLineID = ttQuotationLine.ttQuotationLineID.
        END.
                   
    END.

    IF cotacao-item.ind-orig-entrada = 18 THEN
        ASSIGN cEvent = "check".
    
    IF cEvent = "" THEN
        ASSIGN cEvent = "send".

END.
