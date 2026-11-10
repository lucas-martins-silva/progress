PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    DEF INPUT  PARAM pr-rowid AS ROWID NO-UNDO.
    DEF INPUT  PARAM pc-acao  AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/

    /*LOCAL VARIABLES - BEGIN*/
    DEF VAR i-cont AS INTEGER NO-UNDO.

    DEFINE VARIABLE h-cdapi995   AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE de-pc-pis    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEFINE VARIABLE de-pc-cofins AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    /*LOCAL VARIABLES - END*/

    EMPTY TEMP-TABLE ttVendorItem.
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */    
    FIND FIRST item-fornec NO-LOCK
         WHERE ROWID(item-fornec) = pr-rowid NO-ERROR.
    IF AVAIL item-fornec THEN DO:
        
        FOR FIRST pais FIELDS (nome-pais)
            WHERE pais.cod-pais = item-fornec.cdn-pais-orig NO-LOCK. END.

        FOR FIRST emitente FIELDS (nome-emit cgc char-2)
            WHERE emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK. END.

        FOR FIRST item FIELDS (it-codigo desc-item)
            WHERE item.it-codigo = item-fornec.it-codigo NO-LOCK. END.

        FOR FIRST tab-unidade FIELDS (un)
            WHERE tab-unidade.un = item-fornec.unid-med-for NO-LOCK. END.

        IF NOT VALID-HANDLE(h-cdapi995) THEN
            RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

        RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-fornec", 
                                              INPUT item-fornec.it-codigo + "/" + string(item-fornec.cod-emitente), 
                                              OUTPUT de-pc-pis,    
                                              OUTPUT de-pc-cofins).
        
        IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = item-fornec.val-aliq-pis.
        IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = item-fornec.val-aliq-cofins.

        CREATE ttVendorItem.
        ASSIGN ttVendorItem.IsVendorActive	                = item-fornec.ativo               
               ttVendorItem.ReferenceCode                   = item-fornec.cd-referencia
               ttVendorItem.ManufacturingCode               = item-fornec.cdn-fabrican
               ttVendorItem.CountryCode                     = item-fornec.cdn-pais-orig
               ttVendorItem.CountryName                     = IF AVAIL pais THEN pais.nome-pais ELSE ""
               ttVendorItem.CheckSum                        = item-fornec.check-sum
               ttVendorItem.ReschedulingClass               = item-fornec.classe-repro
               ttVendorItem.PaymentCode                     = item-fornec.cod-cond-pag
               ttVendorItem.PackageCode                     = item-fornec.cod-embal
               ttVendorItem.VendorNumber                    = item-fornec.cod-emitente
               ttVendorItem.VendorName                      = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
               ttVendorItem.VendorTaxID                     = IF AVAIL emitente THEN emitente.cgc       ELSE ""
               ttVendorItem.MessageCode                     = item-fornec.cod-mensagem
               ttVendorItem.Concept                         = item-fornec.conceito
               ttVendorItem.Concentrate                     = item-fornec.concentracao
               ttVendorItem.IsSupplyVendorContract          = item-fornec.contr-forn
               ttVendorItem.AutomaticQuotation              = item-fornec.cot-aut
               ttVendorItem.Criticality                     = item-fornec.criticidade
               ttVendorItem.ConvFactor                      = item-fornec.fator-conver
               ttVendorItem.DeliveryEndTime                 = item-fornec.hora-fim
               ttVendorItem.DeliveryStartTime               = item-fornec.hora-ini
               ttVendorItem.FixedHorizon                    = item-fornec.horiz-fixo
               ttVendorItem.SocialSecurContributCode        = item-fornec.idi-tributac-cofins
               ttVendorItem.SocialIntegrProgramCode         = item-fornec.idi-tributac-pis
               ttVendorItem.PunctualityIndex                = item-fornec.ind-pont
               ttVendorItem.ItemCode                        = IF AVAIL ITEM THEN item.it-codigo ELSE item-fornec.it-codigo            
               ttVendorItem.ItemDescription                 = IF AVAIL item THEN item.desc-item ELSE ""
               ttVendorItem.VendorItem                      = item-fornec.item-do-forn
               ttVendorItem.MinimumLot                      = item-fornec.lote-minimo
               ttVendorItem.MultipleLot                     = item-fornec.lote-mul-for
               ttVendorItem.cText                           = item-fornec.narrativa
               ttVendorItem.InspectLevel                    = item-fornec.niv-inspecao
               ttVendorItem.AcceptableQualityLevel          = item-fornec.niv-qua-ac
               ttVendorItem.DecimalQuantity                 = item-fornec.num-casa-dec
               ttVendorItem.LastReceivedDocument            = item-fornec.numero-nota
               ttVendorItem.Comments                        = item-fornec.observacao
               ttVendorItem.VendorOrder                     = item-fornec.ped-fornec
               ttVendorItem.PurchasePercent                 = item-fornec.perc-compra
               ttVendorItem.ReturnVendorPercent             = item-fornec.perc-dev-forn
               ttVendorItem.PontualVendorPercent            = item-fornec.perc-pont-forn
               ttVendorItem.QuantityMaxOrder                = item-fornec.qt-max-ordem
               ttVendorItem.ReadjustTable                   = item-fornec.reaj-tabela
               ttVendorItem.Yield                           = item-fornec.rendimento
               ttVendorItem.DocumentSeries                  = item-fornec.serie-nota
               ttVendorItem.LeadTime                        = item-fornec.tempo-ressup
               ttVendorItem.TypeInspect                     = item-fornec.tp-inspecao               
               ttVendorItem.VendorUnitOfMeasure             = IF AVAIL tab-unidade THEN tab-unidade.un ELSE item-fornec.unid-med-for
               ttVendorItem.IsContractDelivery              = item-fornec.usa-contrato
               ttVendorItem.SocialSecurContributTaxValue    = de-pc-cofins    
               ttVendorItem.SocialIntegrProgramTaxValue     = de-pc-pis    
               ttVendorItem.SocialSecContribDecreasePercent = item-fornec.val-reduc-cofins-normal
               ttVendorItem.SocialIntegProgDecreasePercent  = item-fornec.val-reduc-pis-normal
               ttVendorItem.SocialSecurContributUnitValue   = item-fornec.val-unit-cofins
               ttVendorItem.SocialIntegrProgramUnitValue    = item-fornec.val-unit-pis.

        IF AVAIL emitente THEN
            ASSIGN ttVendorItem.CodIntegrationParadigma =
               &if '{&BF_DIS_VERSAO_EMS}' >= '2.09' &then
                   emitente.log-portal-paradigma
               &else
                   IF SUBSTRING(emitente.char-2,76,1) = "S" THEN YES ELSE NO
               &endif.

        DO i-cont = 1 TO 30:
            ASSIGN ttVendorItem.ReceiptBatchStatus[i-cont] = item-fornec.aval-insp[i-cont]
                   ttVendorItem.BatchRoute[i-cont]         = item-fornec.ult-ficha[i-cont].
        END.
    END.


    IF VALID-HANDLE(h-cdapi995) THEN DO:
        RUN pi-finalizar in h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.

    RUN PIUpsert(INPUT "", 	
                 INPUT pc-acao, 	
                 INPUT  TABLE ttVendorItem,
                 OUTPUT TABLE tt_log_erro).
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



