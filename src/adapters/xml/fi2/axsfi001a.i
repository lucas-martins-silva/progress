/***** INTEGRA€AO EAI EMITENTE - INFORMA€OES LOGISTICA     */                     

{cdp/cdcfgdis.i}

/* Carrega temp-table ttLogisticsInformation */
CREATE ttLogisticsInformation.

FIND FIRST emitente-cex NO-LOCK
     WHERE emitente-cex.cod-emitente = emitente.cod-emitente NO-ERROR.

IF AVAIL emitente-cex THEN
    FIND FIRST idioma NO-LOCK
         WHERE idioma.cod_idioma = emitente-cex.cod-idioma NO-ERROR.

IF emitente.nome-tr-red <> "" THEN DO:
     FIND FIRST transporte WHERE transporte.nome-abrev = emitente.nome-tr-red NO-LOCK NO-ERROR.
      ASSIGN ttLogisticsInformation.ReshipmentCarrierShortName = emitente.nome-tr-red
             ttLogisticsInformation.ReshipmentCarrierCode      = IF AVAIL transporte THEN transporte.cod-transp ELSE 0
             ttLogisticsInformation.ReshipmentCarrierName      = IF AVAIL transporte THEN transporte.nome ELSE "".
END.

ASSIGN ttLogisticsInformation.StandardCarrierCode             = emitente.cod-transp.
     FIND FIRST transporte WHERE transporte.cod-transp        = emitente.cod-transp NO-LOCK NO-ERROR.
       ASSIGN ttLogisticsInformation.StandardCarrierShortName = IF AVAIL transporte THEN transporte.nome-abrev ELSE ""
              ttLogisticsInformation.StandardCarrierName      = IF AVAIL transporte THEN transporte.nome ELSE ""
              ttLogisticsInformation.RepresentativeRegion     = emitente.nome-mic-reg
              ttLogisticsInformation.MarketActivity           = emitente.atividade
              ttLogisticsInformation.PrintLabel               = emitente.emite-etiq
              ttLogisticsInformation.ProductLine              = emitente.linha-produt.

IF emitente.identific = 1 OR emitente.identific = 3 THEN DO:  /* 1- Cliente 3- Ambos -> CustomerInformations */

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = emitente.nat-operacao NO-ERROR.

    FIND FIRST tb-preco NO-LOCK
         WHERE tb-preco.nr-tabpre = emitente.nr-tabpre NO-ERROR.

    FIND FIRST canal-venda NO-LOCK 
         WHERE canal-venda.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.

    FIND FIRST dist-emitente NO-LOCK
         WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF AVAIL dist-emitente THEN DO:
        FIND FIRST moeda NO-LOCK 
             WHERE moeda.mo-codigo = dist-emitente.mo-fatur NO-ERROR.

        ASSIGN ttLogisticsInformation.codActive = dist-emitente.idi-sit-fornec.
    END.

    ASSIGN ttLogisticsInformation.CodIntegrationParadigma =
           &if '{&BF_DIS_VERSAO_EMS}' >= '2.09' &then
               emitente.log-portal-paradigma
           &else
               IF SUBSTRING(emitente.char-2,76,1) = "S" THEN YES ELSE NO
           &endif.

    IF AVAIL emitente-cex THEN DO: 
       FIND FIRST itinerario NO-LOCK
            WHERE itinerario.cod-itiner = emitente-cex.cod-itiner-exp   NO-ERROR.
       FIND FIRST inco-cx    NO-LOCK
            WHERE inco-cx.cod-incoterm  = emitente-cex.cod-incoterm-exp NO-ERROR.
    END.

    ASSIGN ttLogisticsInformation.Category                   = emitente.categoria
           ttLogisticsInformation.FiscalOperationCode        = emitente.nat-operacao
           ttLogisticsInformation.FiscalOperationDescription = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "".

    IF emitente.nat-ope-ext <> "" THEN DO:
       ASSIGN ttLogisticsInformation.InterstateFiscalOperationCode = emitente.nat-ope-ext.
       FIND FIRST natur-oper WHERE natur-oper.nat-operacao         = emitente.nat-ope-ext NO-LOCK NO-ERROR.
         ASSIGN ttLogisticsInformation.InterstateFiscalOperationDesc_00 = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "".
    END.

    &IF '{&BF_DIS_VERSAO_EMS}' >= "2.06" &THEN
        ASSIGN ttLogisticsInformation.IsOptingSuspendExciseTax = emitente.log-optan-suspens-ipi.
    &ELSE
        IF substr(emitente.char-1,21,1) = "1" THEN 
             ASSIGN ttLogisticsInformation.IsOptingSuspendExciseTax = FALSE.
        ELSE ASSIGN ttLogisticsInformation.IsOptingSuspendExciseTax = TRUE.
    &ENDIF

    ASSIGN ttLogisticsInformation.IsRetentionAgent         = emitente.agente-retencao
           ttLogisticsInformation.IsTaxPayer               = emitente.contrib-icms
           ttLogisticsInformation.PriceTableCode_00        = emitente.nr-tabpre
           ttLogisticsInformation.PriceTableDescription_00 = IF AVAIL tb-preco THEN tb-preco.descricao ELSE ""
           ttLogisticsInformation.PartialInvoicing         = emitente.ind-fat-par
           ttLogisticsInformation.PartialInvoicingMin      = emitente.per-minfat
           ttLogisticsInformation.BalanceCancMax           = emitente.per-max-canc
           ttLogisticsInformation.OrderInvoicingMax        = emitente.perc-fat-ped.

    IF emitente.esp-pd-venda >= 1 AND emitente.esp-pd-venda <= 3  THEN
         ASSIGN ttLogisticsInformation.SalesOrderStdClass = emitente.esp-pd-venda.
    ELSE ASSIGN ttLogisticsInformation.SalesOrderStdClass = 1. 

    IF emitente.cod-canal-venda <> 0 THEN DO:
       ASSIGN ttLogisticsInformation.DistributionChannelCode        = emitente.cod-canal-venda
              ttLogisticsInformation.DistributionChannelDescription = IF AVAIL canal-venda THEN canal-venda.descricao ELSE "".
    END.

    IF emitente.tp-qt-prg = 1 OR emitente.tp-qt-prg = 2 THEN
       ASSIGN ttLogisticsInformation.QuantityType = emitente.tp-qt-prg.
   IF emitente.tip-cob-desp >= 1 AND emitente.tip-cob-desp <= 4  THEN
        ASSIGN ttLogisticsInformation.ExpenseCollectionType = emitente.tip-cob-desp.
   ELSE ASSIGN ttLogisticsInformation.ExpenseCollectionType = 1.
    ASSIGN ttLogisticsInformation.SUFRAMACode = emitente.cod-suframa
           ttLogisticsInformation.CACEXCode   = emitente.cod-cacex
           ttLogisticsInformation.AuxiliaryNumberForTributarySubst = emitente.insc-subs-trib
           ttLogisticsInformation.LateIndicator = emitente.ind-atraso.

    /* Carrega temp-table ttShipToLocation */
    IF emitente.cod-entrega <> "" THEN DO:
       ASSIGN ttLogisticsInformation.StdShipToLocationCode = emitente.cod-entrega.
       FOR EACH loc-entr WHERE loc-entr.nome-abrev = emitente.nome-abrev NO-LOCK:
           CREATE ttShipToLocationInformation.
           ASSIGN ttShipToLocationInformation.ShipToLocationCode        = loc-entr.cod-entrega
                  ttShipToLocationInformation.ShipToLocationDescription = loc-entr.endereco
                  ttShipToLocationInformation.District                  = loc-entr.bairro
                  ttShipToLocationInformation.City                      = loc-entr.cidade
                  ttShipToLocationInformation.State                     = loc-entr.estado
                  ttShipToLocationInformation.Country                   = loc-entr.pais
                  ttShipToLocationInformation.ZipCode                   = loc-entr.cep
                  ttShipToLocationInformation.POBox                     = loc-entr.caixa-postal
                  ttShipToLocationInformation.StateTaxID                = loc-entr.ins-estadual
                  ttShipToLocationInformation.TaxID                     = loc-entr.cgc.
              &IF '{&BF_DIS_VERSAO_EMS}' >= '2.05' &THEN
                  ASSIGN ttShipToLocationInformation.FullAddress        = loc-entr.endereco_text.
              &ENDIF
              &IF '{&BF_DIS_VERSAO_EMS}' <= "2.05" &THEN
                  ASSIGN ttShipToLocationInformation.CarrierShortName   = substr(loc-entr.char-1,1,12)
                         ttShipToLocationInformation.RouteCode          = substr(loc-entr.char-1,13,12)
                         ttShipToLocationInformation.CIFCityName        = substr(loc-entr.char-1,25,25).
              &ELSE
                 ASSIGN ttShipToLocationInformation.CarrierShortName    = loc-entr.nome-transp
                        ttShipToLocationInformation.RouteCode           = loc-entr.cod-rota
                        ttShipToLocationInformation.CIFCityName         = loc-entr.nom-cidad-cif.
              &ENDIF
              
            /* ---   Operacional Textil - Exportacao Cliente ou fornecedor   --- */
            FOR FIRST pais WHERE pais.nome-pais = loc-entr.pais NO-LOCK:
                    ASSIGN ttShipToLocationInformation.CountrySiscomex = &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN integer(pais.cod-pais-siscomex) 
                                                                         &ELSE integer(substring(pais.char-1,1,5)) &ENDIF.
                    IF ttShipToLocationInformation.CountrySiscomex = 0 THEN
                        ASSIGN ttShipToLocationInformation.CountrySiscomex = ?.
                             
            END.
              
       END.
    END.

    ASSIGN ttLogisticsInformation.CustomerStdDiscount = emitente.bonificacao.
    &IF '{&BF_DIS_VERSAO_EMS}' >= "2.06" &THEN
       ASSIGN ttLogisticsInformation.SSTaxationCode   = emitente.idi-tributac-cofins
              ttLogisticsInformation.ProfitTaxCode    = emitente.idi-tributac-pis
              ttLogisticsInformation.IsProfitTaxAndSSTax_00 = IF emitente.log-calcula-pis-cofins-unid <> ? THEN emitente.log-calcula-pis-cofins-unid ELSE TRUE.
    &ELSE
        ASSIGN ttLogisticsInformation.SSTaxationCode  = dec(SUBSTR(emitente.char-1,28,1))
               ttLogisticsInformation.ProfitTaxCode   = dec(SUBSTR(emitente.char-1,22,1))
               ttLogisticsInformation.IsProfitTaxAndSSTax_00 = IF substr(emitente.char-1,29,1) = "N":U THEN NO ELSE YES.
    &ENDIF

    IF AVAIL dist-emitente THEN DO:
         ASSIGN ttLogisticsInformation.InvoicingCurrencyCode        = dist-emitente.mo-fatur
                ttLogisticsInformation.InvoicingCurrencyDescription = IF AVAIL moeda THEN moeda.descricao ELSE "".
         IF dist-emitente.ind-geracao-ped-bonif = 1 OR dist-emitente.ind-geracao-ped-bonif = 2 THEN
            ASSIGN ttLogisticsInformation.DiscountOrderGenerationType = dist-emitente.ind-geracao-ped-bonif.
         IF dist-emitente.log-fatur-ped-bonif <> ? THEN
              ASSIGN ttLogisticsInformation.DiscountAfterInvoicing = dist-emitente.log-fatur-ped-bonif.
         ELSE ASSIGN ttLogisticsInformation.DiscountAfterInvoicing = FALSE.
         IF dist-emitente.ind-atua-bonif-canc-saldo <> 0 THEN
            ASSIGN ttLogisticsInformation.BalanceCancelationDiscountUpdate = dist-emitente.ind-atua-bonif-canc-saldo.
         IF dist-emitente.log-libera-venda-sem-bonif <> ? THEN
              ASSIGN ttLogisticsInformation.ReleaseSaleWithoutDiscount = dist-emitente.log-libera-venda-sem-bonif.
         ELSE ASSIGN ttLogisticsInformation.ReleaseSaleWithoutDiscount = FALSE.
         ASSIGN ttLogisticsInformation.TaxPriceTable         = dist-emitente.nr-tb-pauta
                ttLogisticsInformation.ExternalWarehouseCode = dist-emitente.cod-dep-ext
                ttLogisticsInformation.StandardWarehouseCode = dist-emitente.cod-dep-pad.

         &IF '{&BF_DIS_VERSAO_EMS}' >= "2.05" &THEN
               ASSIGN ttLogisticsInformation.IsCreditLimitIncluded = dist-emitente.log-consid-ap-lim-cr.
         &ELSE IF substr(dist-emitente.char-1,1,1) = "2" THEN 
                  ASSIGN ttLogisticsInformation.IsCreditLimitIncluded = FALSE.
             ELSE ASSIGN ttLogisticsInformation.IsCreditLimitIncluded = TRUE.
         &ENDIF
    END.

    IF AVAIL emitente-cex THEN DO:
          IF emitente-cex.cod-idioma <> "" THEN 
             ASSIGN ttLogisticsInformation.LanguageCode_00        = emitente-cex.cod-idioma
                    ttLogisticsInformation.LanguageDescription_00 = IF AVAIL idioma THEN idioma.des_idioma ELSE "".

          IF emitente-cex.cod-itiner-exp <> 0 THEN 
             ASSIGN ttLogisticsInformation.ItineraryCode_00        = emitente-cex.cod-itiner-exp
                    ttLogisticsInformation.ItineraryDescription_00 = IF AVAIL itinerario THEN itinerario.descricao ELSE "".

          IF emitente-cex.cod-incoterm-exp <> "" THEN 
             ASSIGN ttLogisticsInformation.IncotermCode_00 = emitente-cex.cod-incoterm-exp
                    ttLogisticsInformation.IncotermDescription_00 = IF AVAIL inco-cx THEN inco-cx.descricao ELSE "".

         &IF '{&BF_DIS_VERSAO_EMS}' >= "2.06" &THEN                                     
            ASSIGN ttLogisticsInformation.OriginalProformaInvoiceLayout   = emitente-cex.des-layout-origin-proform-invoi
                   ttLogisticsInformation.OriginalCommercialInvoiceLayout = emitente-cex.des-layout-origin-comerc-invoi
                   ttLogisticsInformation.OriginalPackingListLayout       = emitente-cex.des-layout-origin-packing-list.
         &ELSE
           ASSIGN ttLogisticsInformation.OriginalProformaInvoiceLayout   = substr(emitente-cex.char-1,17,40)
                  ttLogisticsInformation.OriginalCommercialInvoiceLayout = substr(emitente-cex.char-2,1,40)
                  ttLogisticsInformation.OriginalPackingListLayout       = substr(emitente-cex.char-2,41,40).
         &ENDIF
    END. 

    IF emitente.ind-cre-cli >= 1 AND emitente.ind-cre-cli <= 5 THEN
         ASSIGN ttLogisticsInformation.CreditIndicator = emitente.ind-cre-cli.
    ELSE ASSIGN ttLogisticsInformation.CreditIndicator = 1.

    IF emitente.ind-aval >= 1 AND emitente.ind-aval <= 3 THEN
         ASSIGN ttLogisticsInformation.CreditEvaluation = emitente.ind-aval.
    ELSE ASSIGN ttLogisticsInformation.CreditEvaluation = 1.

    IF emitente.ind-aval-embarque >= 1 AND emitente.ind-aval-embarque <= 3 THEN
         ASSIGN ttLogisticsInformation.ShipmentCreditEvaluation = emitente.ind-aval-embarque.
    ELSE ASSIGN ttLogisticsInformation.ShipmentCreditEvaluation = 1.

    IF emitente.ind-abrange-aval = 1 OR emitente.ind-abrange-aval = 2 THEN
       ASSIGN ttLogisticsInformation.EvaluationScope = emitente.ind-abrange-aval.

    ASSIGN ttLogisticsInformation.CreditLimit                      = emitente.lim-credito
           ttLogisticsInformation.CreditLimitCurrency              = emitente.moeda-libcre
           ttLogisticsInformation.CreditLimitDate                  = emitente.dt-lim-cred
           ttLogisticsInformation.AdditionalCreditLimit            = emitente.lim-adicional
           ttLogisticsInformation.AdditionalCreditLimitDate        = emitente.dt-fim-cred
           ttLogisticsInformation.LatePeriods                      = emitente.nr-peratr
           ttLogisticsInformation.InactiveMonths                   = emitente.nr-mesina
           ttLogisticsInformation.ReturnCheckMaxNumber             = emitente.nr-cheque-devol
           ttLogisticsInformation.ReturnCheckMaxAmount             = emitente.vl-max-devol
           ttLogisticsInformation.ReturnedCheckPeriod              = emitente.periodo-devol
           ttLogisticsInformation.ReleaseInventoryWithoutReleas_00 = emitente.ind-lib-estoque.
END.

IF emitente.identific = 2 OR emitente.identific = 3 THEN DO: /* 2-Fornecedor 3-Ambos -> VendorInformations*/

    FIND FIRST dist-emitente NO-LOCK
         WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF AVAIL dist-emitente THEN
        ASSIGN ttLogisticsInformation.codActive = dist-emitente.idi-sit-fornec.

    ASSIGN ttLogisticsInformation.CodIntegrationParadigma =
           &if '{&BF_DIS_VERSAO_EMS}' >= '2.09' &then
               emitente.log-portal-paradigma
           &else
               IF SUBSTRING(emitente.char-2,76,1) = "S" THEN YES ELSE NO
           &endif.

   IF AVAIL emitente-cex THEN DO:
        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = emitente-cex.cod-itiner-imp   NO-ERROR.
        FIND FIRST inco-cx   NO-LOCK
             WHERE inco-cx.cod-incoterm  = emitente-cex.cod-incoterm-imp NO-ERROR.
        FIND FIRST repres    NO-LOCK 
             WHERE repres.cod-rep        = emitente-cex.cod-repres       NO-ERROR.
   END.

   IF emitente.emissao-ped >= 1 AND emitente.emissao-ped <= 3 THEN
      ASSIGN ttLogisticsInformation.PrintPOMediaType = emitente.emissao-ped.
     &IF '{&BF_DIS_VERSAO_EMS}' >= "2.06" &THEN
          ASSIGN ttLogisticsInformation.IsPresumedCreditTaxReplacement = emitente.log-optan-cr-presmdo-subst.
     &ELSE IF emitente.int-1 = 1 THEN
                ASSIGN ttLogisticsInformation.IsPresumedCreditTaxReplacement = TRUE.
           ELSE ASSIGN ttLogisticsInformation.IsPresumedCreditTaxReplacement = FALSE.
     &ENDIF
     
   /* define se o emitente ‚ um transportador */
   FIND FIRST transporte
       WHERE transporte.cgc = emitente.cgc NO-LOCK NO-ERROR.
   IF AVAIL transporte THEN
       ASSIGN ttLogisticsInformation.IsCarrier = TRUE.
   ELSE ASSIGN ttLogisticsInformation.IsCarrier = FALSE.
   
   IF AVAIL emitente-cex THEN DO:
        ASSIGN ttLogisticsInformation.ABACode = emitente-cex.cod-aba.

        IF emitente-cex.cod-itiner-imp <> 0 THEN
         ASSIGN ttLogisticsInformation.ItineraryCode        = emitente-cex.cod-itiner-imp
                ttLogisticsInformation.ItineraryDescription = IF AVAIL itinerario THEN itinerario.descricao ELSE "".

        IF emitente-cex.cod-incoterm-imp <> "" THEN 
         ASSIGN ttLogisticsInformation.IncotermCode        = emitente-cex.cod-incoterm-imp
                ttLogisticsInformation.IncotermDescription = IF AVAIL inco-cx THEN inco-cx.descricao ELSE "".

        ASSIGN ttLogisticsInformation.RepresentativeCode_00 = emitente-cex.cod-repres
               ttLogisticsInformation.RepresentativeName_00 = IF AVAIL repres THEN repres.nome ELSE "". 

        IF emitente-cex.cod-idioma <> "" THEN
           ASSIGN ttLogisticsInformation.LanguageCode        = emitente-cex.cod-idioma
                  ttLogisticsInformation.LanguageDescription = IF AVAIL idioma THEN idioma.des_idioma ELSE "".

        ASSIGN ttLogisticsInformation.IsIncotermExpensesIncluded = emitente-cex.log-1.

        &IF '{&BF_DIS_VERSAO_EMS}' >= "2.05" &THEN
            IF emitente-cex.nr-tab <> "" THEN DO:
               ASSIGN ttLogisticsInformation.PriceTableCode         = emitente-cex.nr-tab.
               FIND FIRST tb-preco WHERE tb-preco.nr-tabpre         = emitente-cex.nr-tab NO-LOCK NO-ERROR.
                ASSIGN ttLogisticsInformation.PriceTableDescription = IF AVAIL tb-preco THEN tb-preco.descricao ELSE "".
            END.
            IF emitente-cex.cod-pto-contr <> 0 THEN DO:
               ASSIGN ttLogisticsInformation.ControlPointCode         = emitente-cex.cod-pto-contr.
               FIND FIRST pto-contr WHERE pto-contr.cod-pto-contr     = emitente-cex.cod-pto-contr NO-LOCK NO-ERROR.
                ASSIGN ttLogisticsInformation.ControlPointDescription = IF AVAIL pto-contr THEN pto-contr.descricao ELSE "".
            END.

        &ELSE
            IF substr(emitente-cex.char-1,1,10) <> "" THEN DO:
               ASSIGN ttLogisticsInformation.PriceTableCode          = substr(emitente-cex.char-1,1,8).
               FIND FIRST tb-preco WHERE tb-preco.nr-tabpre          = substr(emitente-cex.char-1,1,8) NO-LOCK NO-ERROR.
                 ASSIGN ttLogisticsInformation.PriceTableDescription = IF AVAIL tb-preco THEN tb-preco.descricao ELSE "".
            END.
            IF substr(emitente-cex.char-1,11,6) <> "" THEN DO:
               ASSIGN ttLogisticsInformation.ControlPointCode     = int(substr(emitente-cex.char-1,11,6)).
               FIND FIRST pto-contr WHERE pto-contr.cod-pto-contr = int(substr(emitente-cex.char-1,11,6)) NO-LOCK NO-ERROR.
                ASSIGN ttLogisticsInformation.ControlPointDescription = IF AVAIL pto-contr THEN pto-contr.descricao ELSE "".
            END.
        &ENDIF
   END. 
END.     
