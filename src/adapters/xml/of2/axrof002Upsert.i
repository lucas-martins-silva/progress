/* Doc Fiscal */
IF NOT VALID-HANDLE(h-bodi037)
    OR h-bodi037:TYPE      <> "PROCEDURE":U 
    OR h-bodi037:FILE-NAME <> "dibo/bodi037.p":U THEN RUN dibo/bodi037.p PERSISTENT SET h-bodi037.

/* Item Doc Fiscal */
IF NOT VALID-HANDLE(h-bodi084)
    OR h-bodi084:TYPE      <> "PROCEDURE":U 
    OR h-bodi084:FILE-NAME <> "dibo/bodi084.p":U THEN RUN dibo/bodi084.p PERSISTENT SET h-bodi084.

/* Dcocumento Fiscal Adicional */
IF NOT VALID-HANDLE(h-bodi515)
    OR h-bodi515:TYPE      <> "PROCEDURE":U 
    OR h-bodi515:FILE-NAME <> "dibo/bodi515.p":U THEN RUN dibo/bodi515.p PERSISTENT SET h-bodi515.

RUN openQueryStatic IN h-bodi037 (INPUT "Main").
RUN emptyRowErrors  IN h-bodi037.     
RUN PI_gera_tt_log_erro.
RUN newRecord       IN h-bodi037.
 
/*Dar Assign de todas a TAGs aqui*/
CREATE tt-doc-fiscal.
ASSIGN tt-doc-fiscal.cod-emitente                      = CustomerNumber                  
       tt-doc-fiscal.nr-doc-fis                        = DocumentNumber                  
       tt-doc-fiscal.serie                             = DocumentSeries                  
       tt-doc-fiscal.nat-operacao                      = FiscalOperationCode
       tt-doc-fiscal.cod-estabel                       = Site
       tt-doc-fiscal.dt-emis-doc                       = PrintDate
       tt-doc-fiscal.dt-docto                          = DocumentDate
       tt-doc-fiscal.esp-docto                         = DocumentClass
       tt-doc-fiscal.cod-mensagem                      = CodeMessage
       tt-doc-fiscal.log-bxa-estoq                     = IsInventoryIssued         
       tt-doc-fiscal.perc-red-icm                      = TaxReductionPercentage
       tt-doc-fiscal.perc-red-iss                      = ISSReductionPercentage
       tt-doc-fiscal.vl-icms-com                       = TaxSupplementaryValue
       tt-doc-fiscal.cod-des-merc                      = GoodsTarget
       tt-doc-fiscal.ind-ori-doc                       = DocumentSource
       tt-doc-fiscal.manut-icm-it                      = ICMSMaintenence
       tt-doc-fiscal.manut-ipi-it                      = IPIMaintenence
       tt-doc-fiscal.cod-observa                       = CommentsCode
       tt-doc-fiscal.int-1                             = EndVoucherNumber
       tt-doc-fiscal.nivel-restituicao                 = ReturnLevel
       tt-doc-fiscal.pc-restituicao                    = ReturnPercentage
       tt-doc-fiscal.ind-icm-ret                       = RetainsICMSSource
       tt-doc-fiscal.cod-cfop                          = FiscalOperationCFOP
       tt-doc-fiscal.endereco                          = StreetAddress
       tt-doc-fiscal.bairro                            = DistrictName
       tt-doc-fiscal.cidade                            = CityName
       tt-doc-fiscal.cep                               = ZipCode
       tt-doc-fiscal.cgc                               = CustomerTaxID
       tt-doc-fiscal.ins-estadual                      = CustomerStateTaxID
       tt-doc-fiscal.pais                              = CountryName
       tt-doc-fiscal.estado                            = StateCode
       tt-doc-fiscal.observacao                        = Narrative
       tt-doc-fiscal.nr-re                             = ExportRecord
       tt-doc-fiscal.dat-reg-export                    = ExportRecordDate
       tt-doc-fiscal.des-decla-import                  = ExportDeclaration
       tt-doc-fiscal.dat-solicit-despch                = ExportDeclarationDate
       tt-doc-fiscal.cod-comprov-export                = ExportVoucher    
       tt-doc-fiscal.dat-comprov-export                = ExportVoucherDate
       tt-doc-fiscal.log-averb                         = Amount
       tt-doc-fiscal.val-despch                        = ShipmentValue
       tt-doc-fiscal.cod-conhecto                      = BillOfLading
       tt-doc-fiscal.cdn-tip-conhecto                  = BillOfLadingType
       tt-doc-fiscal.dat-conhecto                      = BillOfLadingDate
       tt-doc-fiscal.cdn-moed-siscomex                 = ForeignTradeCurrency
       tt-doc-fiscal.cod-pais-siscomex                 = ContryTradeCurrency
       tt-doc-fiscal.des-decla-import                  = ImportationStatement
       .

ASSIGN tt-doc-fiscal.nome-transp                       = CarrierName         
       tt-doc-fiscal.cod-cnpj-transpdor                = CarrierTaxID        
       tt-doc-fiscal.cod-uf-transpdor                  = StateCode           
       tt-doc-fiscal.cod-inscr-estad-transpdor         = CarrierStateTaxID   
       tt-doc-fiscal.cdn-modalid-transp                = ShippingMethod      
       tt-doc-fiscal.ind-cifob                         = FreightType         
       tt-doc-fiscal.cod-placa[1]                      = LicensePlateId1     
       tt-doc-fiscal.cod-uf-placa[1]                   = StateLicensePlateId1
       tt-doc-fiscal.cod-placa[2]                      = LicensePlateId2     
       tt-doc-fiscal.cod-uf-placa[2]                   = StateLicensePlateId2
       tt-doc-fiscal.cod-placa[3]                      = LicensePlateId3     
       tt-doc-fiscal.cod-uf-placa[3]                   = StateLicensePlateId3
       .

FIND FIRST emitente WHERE emitente.cod-emitente = tt-doc-fiscal.cod-emitente NO-LOCK NO-ERROR.
IF AVAIL   emitente THEN DO:
    ASSIGN tt-doc-fiscal.nome-ab-emi = emitente.nome-abrev.

    IF tt-doc-fiscal.bairro       = ? THEN ASSIGN tt-doc-fiscal.bairro       = emitente.bairro.
    IF tt-doc-fiscal.cep          = ? THEN ASSIGN tt-doc-fiscal.cep          = emitente.cep.
    IF tt-doc-fiscal.cidade       = ? THEN ASSIGN tt-doc-fiscal.cidade       = emitente.cidade. 
    IF tt-doc-fiscal.endereco     = ? THEN ASSIGN tt-doc-fiscal.endereco     = emitente.endereco.    
    IF tt-doc-fiscal.ins-estadual = ? THEN ASSIGN tt-doc-fiscal.ins-estadual = emitente.ins-estadual.
    IF tt-doc-fiscal.pais         = ? THEN ASSIGN tt-doc-fiscal.pais         = emitente.pais.
    IF tt-doc-fiscal.estado       = ? THEN ASSIGN tt-doc-fiscal.estado       = emitente.estado.
    IF tt-doc-fiscal.cgc          = ? THEN ASSIGN tt-doc-fiscal.cgc          = emitente.cgc.
END.

IF tt-doc-fiscal.esp-docto = ? THEN DO:
    FIND FIRST natur-oper WHERE natur-oper.nat-operacao = tt-doc-fiscal.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL   natur-oper THEN
        ASSIGN tt-doc-fiscal.esp-docto = natur-oper.especie-doc.
END.

IF tt-doc-fiscal.perc-red-icm              = ? THEN ASSIGN tt-doc-fiscal.perc-red-icm              =  0.       
IF tt-doc-fiscal.perc-red-iss              = ? THEN ASSIGN tt-doc-fiscal.perc-red-iss              =  0.       
IF tt-doc-fiscal.val-despch                = ? THEN ASSIGN tt-doc-fiscal.val-despch                =  0.       
IF tt-doc-fiscal.vl-icms-com               = ? THEN ASSIGN tt-doc-fiscal.vl-icms-com               =  0.       
IF tt-doc-fiscal.cod-pais-siscomex         = ? THEN ASSIGN tt-doc-fiscal.cod-pais-siscomex         = "".       
IF tt-doc-fiscal.des-decla-import          = ? THEN ASSIGN tt-doc-fiscal.des-decla-import          = "".       
IF tt-doc-fiscal.cdn-moed-siscomex         = ? THEN ASSIGN tt-doc-fiscal.cdn-moed-siscomex         =  0.       
IF tt-doc-fiscal.cdn-modalid-transp        = ? THEN ASSIGN tt-doc-fiscal.cdn-modalid-transp        =  1.
IF tt-doc-fiscal.cdn-tip-conhecto          = ? THEN ASSIGN tt-doc-fiscal.cdn-tip-conhecto          =  0.
IF tt-doc-fiscal.cod-comprov-export        = ? THEN ASSIGN tt-doc-fiscal.cod-comprov-export        = "".
IF tt-doc-fiscal.cod-conhecto              = ? THEN ASSIGN tt-doc-fiscal.cod-conhecto              = "".
IF tt-doc-fiscal.cod-observa               = ? THEN ASSIGN tt-doc-fiscal.cod-observa               =  1.
IF tt-doc-fiscal.observacao                = ? THEN ASSIGN tt-doc-fiscal.observacao                = "".
IF tt-doc-fiscal.dt-docto                  = ? THEN ASSIGN tt-doc-fiscal.dt-docto                  = TODAY.
IF tt-doc-fiscal.cod-mensagem              = ? THEN ASSIGN tt-doc-fiscal.cod-mensagem              = 1.
IF tt-doc-fiscal.log-bxa-estoq             = ? THEN ASSIGN tt-doc-fiscal.log-bxa-estoq             = NO.
IF tt-doc-fiscal.cod-des-merc              = ? THEN ASSIGN tt-doc-fiscal.cod-des-merc              = 1.
IF tt-doc-fiscal.ind-ori-doc               = ? THEN ASSIGN tt-doc-fiscal.ind-ori-doc               = 1.
IF tt-doc-fiscal.manut-icm-it              = ? THEN ASSIGN tt-doc-fiscal.manut-icm-it              = YES.
IF tt-doc-fiscal.manut-ipi-it              = ? THEN ASSIGN tt-doc-fiscal.manut-ipi-it              = YES.
IF tt-doc-fiscal.int-1                     = ? THEN ASSIGN tt-doc-fiscal.int-1                     = 0.
IF tt-doc-fiscal.nivel-restituicao         = ? THEN ASSIGN tt-doc-fiscal.nivel-restituicao         = "".
IF tt-doc-fiscal.pc-restituicao            = ? THEN ASSIGN tt-doc-fiscal.pc-restituicao            = 0.
IF tt-doc-fiscal.ind-icm-ret               = ? THEN ASSIGN tt-doc-fiscal.ind-icm-ret               = NO.
IF tt-doc-fiscal.cod-cfop                  = ? THEN ASSIGN tt-doc-fiscal.cod-cfop                  = "".
IF tt-doc-fiscal.cgc                       = ? THEN ASSIGN tt-doc-fiscal.cgc                       = "".
IF tt-doc-fiscal.nr-re                     = ? THEN ASSIGN tt-doc-fiscal.nr-re                     = "".
/*IF tt-doc-fiscal.dat-reg-export            = ? THEN ASSIGN tt-doc-fiscal.dat-reg-export            = */
/*IF tt-doc-fiscal.dat-solicit-despch        = ? THEN ASSIGN tt-doc-fiscal.dat-solicit-despch        = */
/*IF tt-doc-fiscal.dat-comprov-export        = ? THEN ASSIGN tt-doc-fiscal.dat-comprov-export        = */
IF tt-doc-fiscal.log-averb                 = ? THEN ASSIGN tt-doc-fiscal.log-averb                 = NO.
/*IF tt-doc-fiscal.dat-conhecto              = ? THEN ASSIGN tt-doc-fiscal.dat-conhecto              = */
IF tt-doc-fiscal.des-decla-import          = ? THEN ASSIGN tt-doc-fiscal.des-decla-import          = "".
IF tt-doc-fiscal.nome-transp               = ? THEN ASSIGN tt-doc-fiscal.nome-transp               = "".
IF tt-doc-fiscal.cod-cnpj-transpdor        = ? THEN ASSIGN tt-doc-fiscal.cod-cnpj-transpdor        = "".
IF tt-doc-fiscal.cod-uf-transpdor          = ? THEN ASSIGN tt-doc-fiscal.cod-uf-transpdor          = "".
IF tt-doc-fiscal.cod-inscr-estad-transpdor = ? THEN ASSIGN tt-doc-fiscal.cod-inscr-estad-transpdor = "".
IF tt-doc-fiscal.ind-cifob                 = ? THEN ASSIGN tt-doc-fiscal.ind-cifob                 = 1.
IF tt-doc-fiscal.cod-placa[1]              = ? THEN ASSIGN tt-doc-fiscal.cod-placa[1]              = "".
IF tt-doc-fiscal.cod-uf-placa[1]           = ? THEN ASSIGN tt-doc-fiscal.cod-uf-placa[1]           = "".
IF tt-doc-fiscal.cod-placa[2]              = ? THEN ASSIGN tt-doc-fiscal.cod-placa[2]              = "".
IF tt-doc-fiscal.cod-uf-placa[2]           = ? THEN ASSIGN tt-doc-fiscal.cod-uf-placa[2]           = "".
IF tt-doc-fiscal.cod-placa[3]              = ? THEN ASSIGN tt-doc-fiscal.cod-placa[3]              = "".
IF tt-doc-fiscal.cod-uf-placa[3]           = ? THEN ASSIGN tt-doc-fiscal.cod-uf-placa[3]           = "".
IF tt-doc-fiscal.tipo-nat                    = ? THEN ASSIGN tt-doc-fiscal.tipo-nat                = 1.

/* Comentado pois a engenharia que contempla esse desenvolvimento pela  rea de distribuicao ainda nÆo foi realizada, quando realizado, descomentar */
&if "{&bf_dis_versao_ems}" >= "2.09" &then
    ASSIGN tt-doc-fiscal.cod-chave-aces-nf-eletro = NFEletroAcessKey.     
&ELSE ASSIGN overlay(tt-doc-fiscal.CHAR-2,155,60) = NFEletroAcessKey.
&endif 

RUN setRecord      IN h-bodi037(input table tt-doc-fiscal).
RUN createRecord   IN h-bodi037.
RUN getRowErrors   IN h-bodi037(OUTPUT TABLE RowErrors).

RUN PI_gera_tt_log_erro.
IF RETURN-VALUE = 'NOK' THEN 
    RETURN 'NOK'.

RUN getRecord      IN h-bodi037(OUTPUT TABLE tt-doc-fiscal).

FIND FIRST tt-doc-fiscal NO-LOCK NO-ERROR.
IF AVAIL tt-doc-fiscal THEN
    ASSIGN gr-doc-fiscal = tt-doc-fiscal.r-rowid.

ASSIGN d-vl-icm-com = 0.

IF AVAIL tt-doc-fiscal 
AND FreightNature <> 0 THEN DO:

    CREATE tt-nota-fisc-adc.
    ASSIGN tt-nota-fisc-adc.cod-estab        = tt-doc-fiscal.cod-estabel
           tt-nota-fisc-adc.cod-serie        = tt-doc-fiscal.serie
           tt-nota-fisc-adc.cod-nota-fisc    = tt-doc-fiscal.nr-doc-fis
           tt-nota-fisc-adc.cdn-emitente     = tt-doc-fiscal.cod-emitente
           tt-nota-fisc-adc.cod-natur-operac = tt-doc-fiscal.nat-operacao
           tt-nota-fisc-adc.idi-tip-dado     = 13 /*NF de Servi‡o de Transporte - Aquisi‡Æo (07-08-09-10-11-26-27-57)*/
           &if "{&bf_dis_versao_ems}" < "2.09" &then
                OVERLAY(tt-nota-fisc-adc.cod-livre-2,9,2) = string(FreightNature)
           &else
                tt-nota-fisc-adc.idi-natur-frete = FreightNature
           &endif
           .
    
    RUN openQueryStatic IN h-bodi515 (INPUT "Main").           
    RUN emptyRowErrors  IN h-bodi515.  
    RUN setRecord       IN h-bodi515(input table tt-nota-fisc-adc).
    RUN createRecord    IN h-bodi515.
    RUN getRowErrors    IN h-bodi515(OUTPUT TABLE RowErrors).    
    
    RUN PI_gera_tt_log_erro.

END.

FOR EACH ttDocumentItemsType:
    
    /*Dar Assign de todas a TAGs aqui*/
    CREATE tt-it-doc-fisc.
    ASSIGN tt-it-doc-fisc.cod-emitente           = ttDocumentItemsType.CustomerNumber     
           tt-it-doc-fisc.nr-doc-fis             = ttDocumentItemsType.DocumentNumber     
           tt-it-doc-fisc.serie                  = ttDocumentItemsType.DocumentSeries     
           tt-it-doc-fisc.nat-operacao           = ttDocumentItemsType.FiscalOperationCode
           tt-it-doc-fisc.cod-estabel            = ttDocumentItemsType.Site     
           tt-it-doc-fisc.dt-docto               = DocumentDate
           tt-it-doc-fisc.nr-seq-doc             = ttDocumentItemsType.Sequence                                                
           tt-it-doc-fisc.it-codigo              = ttDocumentItemsType.Item                                                              
           tt-it-doc-fisc.aliquota-iss           = ttDocumentItemsType.ISSPercentage                                           
           tt-it-doc-fisc.class-fiscal           = ttDocumentItemsType.FiscalClassification                              
           tt-it-doc-fisc.aliquota-ipi           = ttDocumentItemsType.IPIPercentage                                           
           tt-it-doc-fisc.quantidade             = ttDocumentItemsType.Quantity                                                      
           tt-it-doc-fisc.aliquota-icm           = ttDocumentItemsType.ICMSPercentage           
           tt-it-doc-fisc.un                     = ttDocumentItemsType.Unit                                                             
           tt-it-doc-fisc.cod-servico            = ttDocumentItemsType.ServiceCode                                                
           tt-it-doc-fisc.nivel-restituicao      = ttDocumentItemsType.ReturnLevel                                                
           tt-it-doc-fisc.pc-restituicao         = ttDocumentItemsType.ReturnPercentage
           tt-it-doc-fisc.perc-red-ipi           = ttDocumentItemsType.IPIReductionPercentage                          
           tt-it-doc-fisc.peso-liq               = ttDocumentItemsType.NetWeight
           tt-it-doc-fisc.cd-vin-ipi             = ttDocumentItemsType.LinkingIPICode
           tt-it-doc-fisc.conta-contabil         = ttDocumentItemsType.Account
           tt-it-doc-fisc.cd-trib-icm            = ttDocumentItemsType.ICMSTaxationCode
           tt-it-doc-fisc.cd-trib-ipi            = ttDocumentItemsType.IPITaxationCode
           tt-it-doc-fisc.cd-trib-iss            = ttDocumentItemsType.ISSTaxationCode
           tt-it-doc-fisc.idi-tip-apurac-ipi     = ttDocumentItemsType.IPICalculationType
           tt-it-doc-fisc.vl-merc-liq            = ttDocumentItemsType.NetPrice
           tt-it-doc-fisc.vl-despes-it           = ttDocumentItemsType.ExpenseValue            
           tt-it-doc-fisc.vl-bipi-it             = ttDocumentItemsType.IPICalculationBasis
           tt-it-doc-fisc.vl-ipi-it              = ttDocumentItemsType.IPIValue
           tt-it-doc-fisc.vl-ipi-devol           = ttDocumentItemsType.ReturnIPIValue
           tt-it-doc-fisc.vl-ipint-it            = ttDocumentItemsType.NotTaxedIPIValue
           tt-it-doc-fisc.vl-ipiou-it            = ttDocumentItemsType.OtherIPIValue
           tt-it-doc-fisc.vl-biss-it             = ttDocumentItemsType.ISSCalculationBasis     
           tt-it-doc-fisc.vl-iss-it              = ttDocumentItemsType.ISSValue
           tt-it-doc-fisc.val-inss-retid         = ttDocumentItemsType.WithheldSSValue
           tt-it-doc-fisc.vl-bicms-it            = ttDocumentItemsType.ICMSCalculationBasis
           tt-it-doc-fisc.vl-icms-it             = ttDocumentItemsType.ICMSValue
           tt-it-doc-fisc.vl-icmsnt-it           = ttDocumentItemsType.NotTaxedICMSValue
           tt-it-doc-fisc.vl-icmsou-it           = ttDocumentItemsType.OtherICMSValue
           tt-it-doc-fisc.vl-bsubs-it            = ttDocumentItemsType.ICMSTributarySubstitutionBasis
           tt-it-doc-fisc.vl-icmsub-it           = ttDocumentItemsType.ICMSTributarySubstitutionValue
           tt-it-doc-fisc.val-icms-subst-entr    = ttDocumentItemsType.ReceiptICMSSubstitutionValue
           tt-it-doc-fisc.vl-tot-item            = ttDocumentItemsType.TotalPrice              
           tt-it-doc-fisc.val-retenc-csll        = ttDocumentItemsType.CSLLRetentionValue
           tt-it-doc-fisc.val-retenc-pis         = ttDocumentItemsType.PISPASEPRetentionValue
           tt-it-doc-fisc.val-retenc-cofins      = ttDocumentItemsType.COFINSRetentionValue
           tt-it-doc-fisc.val-base-calc-pis      = ttDocumentItemsType.PISCalculationBasis
           tt-it-doc-fisc.val-pis                = ttDocumentItemsType.PISValue
           tt-it-doc-fisc.val-base-calc-cofins   = ttDocumentItemsType.COFINSCalculationBasis
           tt-it-doc-fisc.val-cofins             = ttDocumentItemsType.COFINSValue
           OVERLAY(tt-it-doc-fisc.char-1,159,14) = STRING(ttDocumentItemsType.ISSRetentionValue)
           tt-it-doc-fisc.descricao-db           = ttDocumentItemsType.DirectDebitDescription
           tt-it-doc-fisc.idi-tip-apurac-ipi     = ttDocumentItemsType.IPIDeterminationType
           tt-it-doc-fisc.tipo-nat               = INT(ttDocumentItemsType.FiscalOperationType)
           tt-it-doc-fisc.dt-emis-doc            = ttDocumentItemsType.PrintDate
           tt-it-doc-fisc.vl-merc-sicm           = ttDocumentItemsType.PriceWithoutICMS
           &if "{&bf_dis_versao_ems}" < "2.09" &then
               OVERLAY(tt-it-doc-fisc.char-2,22,8)  = STRING(ttDocumentItemsType.PISPercentage) 
               OVERLAY(tt-it-doc-fisc.char-2,30,8)  = STRING(ttDocumentItemsType.COFINSPercentage)
           &else
               tt-it-doc-fisc.aliq-pis              = ttDocumentItemsType.PISPercentage   
               tt-it-doc-fisc.aliq-cofins           = ttDocumentItemsType.COFINSPercentage
           &endif 
           .
   
    IF tt-it-doc-fisc.conta-contabil = ?
    OR tt-it-doc-fisc.un             = ?
    OR tt-it-doc-fisc.cod-servico    = ?
    OR tt-it-doc-fisc.class-fiscal   = ? THEN DO:

        FIND FIRST ITEM WHERE ITEM.it-codigo = tt-it-doc-fisc.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            IF tt-it-doc-fisc.conta-contabil = ? THEN ASSIGN tt-it-doc-fisc.conta-contabil = ITEM.conta-aplicacao 
                                                             tt-it-doc-fisc.ct-codigo      = ITEM.ct-codigo 
                                                             tt-it-doc-fisc.sc-codigo      = ITEM.sc-codigo. 
            IF tt-it-doc-fisc.un = ?             THEN ASSIGN tt-it-doc-fisc.un             = ITEM.un.
            IF tt-it-doc-fisc.cod-servico = ?    THEN ASSIGN tt-it-doc-fisc.cod-servico    = ITEM.cod-servico.
            IF tt-it-doc-fisc.class-fiscal = ?   THEN ASSIGN tt-it-doc-fisc.class-fiscal   = ITEM.class-fiscal.
        END.
    END.

    IF tt-it-doc-fisc.aliquota-iss           = ? THEN ASSIGN tt-it-doc-fisc.aliquota-iss           = 0.
    IF tt-it-doc-fisc.aliquota-ipi           = ? THEN ASSIGN tt-it-doc-fisc.aliquota-ipi           = 0.
    IF tt-it-doc-fisc.quantidade             = ? THEN ASSIGN tt-it-doc-fisc.quantidade             = 0.
    IF tt-it-doc-fisc.aliquota-icm           = ? THEN ASSIGN tt-it-doc-fisc.aliquota-icm           = 0.
    /*IF tt-it-doc-fisc.nivel-restituicao      = ? THEN ASSIGN tt-it-doc-fisc.nivel-restituicao      = */
    IF tt-it-doc-fisc.pc-restituicao         = ? THEN ASSIGN tt-it-doc-fisc.pc-restituicao         = 0.
    IF tt-it-doc-fisc.perc-red-ipi           = ? THEN ASSIGN tt-it-doc-fisc.perc-red-ipi           = 0.
    IF tt-it-doc-fisc.peso-liq               = ? THEN ASSIGN tt-it-doc-fisc.peso-liq               = 0.
    IF tt-it-doc-fisc.cd-trib-icm            = ? THEN ASSIGN tt-it-doc-fisc.cd-trib-icm            = 2.
    IF tt-it-doc-fisc.cd-trib-ipi            = ? THEN ASSIGN tt-it-doc-fisc.cd-trib-ipi            = 2.
    IF tt-it-doc-fisc.cd-trib-iss            = ? THEN ASSIGN tt-it-doc-fisc.cd-trib-iss            = 2.
    IF tt-it-doc-fisc.vl-merc-liq            = ? THEN ASSIGN tt-it-doc-fisc.vl-merc-liq            = 0.
    IF tt-it-doc-fisc.vl-despes-it           = ? THEN ASSIGN tt-it-doc-fisc.vl-despes-it           = 0.
    IF tt-it-doc-fisc.vl-bipi-it             = ? THEN ASSIGN tt-it-doc-fisc.vl-bipi-it             = 0.
    IF tt-it-doc-fisc.vl-ipi-it              = ? THEN ASSIGN tt-it-doc-fisc.vl-ipi-it              = 0.
    IF tt-it-doc-fisc.vl-ipi-devol           = ? THEN ASSIGN tt-it-doc-fisc.vl-ipi-devol           = 0.
    IF tt-it-doc-fisc.vl-ipint-it            = ? THEN ASSIGN tt-it-doc-fisc.vl-ipint-it            = 0.
    IF tt-it-doc-fisc.vl-ipiou-it            = ? THEN ASSIGN tt-it-doc-fisc.vl-ipiou-it            = 0.
    IF tt-it-doc-fisc.vl-biss-it             = ? THEN ASSIGN tt-it-doc-fisc.vl-biss-it             = 0.
    IF tt-it-doc-fisc.vl-iss-it              = ? THEN ASSIGN tt-it-doc-fisc.vl-iss-it              = 0.
    IF tt-it-doc-fisc.val-inss-retid         = ? THEN ASSIGN tt-it-doc-fisc.val-inss-retid         = 0.
    IF tt-it-doc-fisc.vl-bicms-it            = ? THEN ASSIGN tt-it-doc-fisc.vl-bicms-it            = 0.
    IF tt-it-doc-fisc.vl-icms-it             = ? THEN ASSIGN tt-it-doc-fisc.vl-icms-it             = 0.
    IF tt-it-doc-fisc.vl-icmsnt-it           = ? THEN ASSIGN tt-it-doc-fisc.vl-icmsnt-it           = 0.
    IF tt-it-doc-fisc.vl-icmsou-it           = ? THEN ASSIGN tt-it-doc-fisc.vl-icmsou-it           = 0.
    IF tt-it-doc-fisc.vl-bsubs-it            = ? THEN ASSIGN tt-it-doc-fisc.vl-bsubs-it            = 0.
    IF tt-it-doc-fisc.vl-icmsub-it           = ? THEN ASSIGN tt-it-doc-fisc.vl-icmsub-it           = 0.
    IF tt-it-doc-fisc.val-icms-subst-entr    = ? THEN ASSIGN tt-it-doc-fisc.val-icms-subst-entr    = 0.
    IF tt-it-doc-fisc.vl-tot-item            = ? THEN ASSIGN tt-it-doc-fisc.vl-tot-item            = 0.
    IF tt-it-doc-fisc.val-retenc-csll        = ? THEN ASSIGN tt-it-doc-fisc.val-retenc-csll        = 0.
    IF tt-it-doc-fisc.val-retenc-pis         = ? THEN ASSIGN tt-it-doc-fisc.val-retenc-pis         = 0.
    IF tt-it-doc-fisc.val-retenc-cofins      = ? THEN ASSIGN tt-it-doc-fisc.val-retenc-cofins      = 0.
    IF tt-it-doc-fisc.val-base-calc-pis      = ? THEN ASSIGN tt-it-doc-fisc.val-base-calc-pis      = 0.
    IF tt-it-doc-fisc.val-pis                = ? THEN ASSIGN tt-it-doc-fisc.val-pis                = 0.
    IF tt-it-doc-fisc.val-base-calc-cofins   = ? THEN ASSIGN tt-it-doc-fisc.val-base-calc-cofins   = 0.
    IF tt-it-doc-fisc.val-cofins             = ? THEN ASSIGN tt-it-doc-fisc.val-cofins             = 0.
    IF SUBSTRING(tt-it-doc-fisc.char-1,159,14) = ? THEN ASSIGN OVERLAY(tt-it-doc-fisc.char-1,159,14) = "".
    IF tt-it-doc-fisc.descricao-db           = ? THEN ASSIGN tt-it-doc-fisc.descricao-db           = "".
    IF tt-it-doc-fisc.idi-tip-apurac-ipi     = ? THEN ASSIGN tt-it-doc-fisc.idi-tip-apurac-ipi     = 1.
    IF tt-it-doc-fisc.tipo-nat               = ? THEN ASSIGN tt-it-doc-fisc.tipo-nat               = 1.
    IF tt-it-doc-fisc.dt-emis-doc            = ? THEN ASSIGN tt-it-doc-fisc.dt-emis-doc            = TODAY.
    IF tt-it-doc-fisc.vl-merc-sicm           = ? THEN ASSIGN tt-it-doc-fisc.vl-merc-sicm           = 0.


    IF tt-it-doc-fisc.idi-tip-apurac-ipi = 0 THEN DO:
        FIND FIRST classif-fisc NO-LOCK
             WHERE classif-fisc.class-fiscal = tt-it-doc-fisc.class-fiscal NO-ERROR.
    
        IF AVAIL classif-fisc THEN
            ASSIGN tt-it-doc-fisc.idi-tip-apurac-ipi = classif-fisc.idi-tip-apurac-ipi.
        ELSE
            ASSIGN tt-it-doc-fisc.idi-tip-apurac-ipi = 1.            
    END.

    FIND FIRST natur-oper WHERE natur-oper.nat-operacao = tt-it-doc-fisc.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL natur-oper THEN DO:

        IF tt-it-doc-fisc.cd-vin-ipi = ? THEN ASSIGN tt-it-doc-fisc.cd-vin-ipi = natur-oper.cd-vinc-ipi.
        
        /*IPI*/
        IF natur-oper.usa-pick THEN DO:  /* Escritura IPI */
            ASSIGN tt-it-doc-fisc.cd-trib-ipi = natur-oper.cd-trib-ipi.
            
            IF natur-oper.cd-trib-ipi = 3 THEN  /*Outros*/
                 ASSIGN tt-it-doc-fisc.vl-ipiou-it = tt-it-doc-fisc.vl-tot-item.
             IF natur-oper.cd-trib-ipi = 2 THEN /*Isento*/
                 ASSIGN tt-it-doc-fisc.vl-ipint-it = tt-it-doc-fisc.vl-tot-item.
        END.
        /*realiza tratamento de ICMS Complementar*/
        IF (SUBSTRING(natur-oper.nat-operacao,1,1) = "2") THEN DO:
            IF (natur-oper.cd-trib-icm = 3) AND (natur-oper.consum-final = YES) THEN DO:  /* Tipo de Trib = Outros E Consumidor final*/
                /*verifica se foi informado o campo aliq icms compl*/
                IF natur-oper.aliq-icm-com > 0 THEN 
                    /*aplica a al¡quota complementar*/
                    ASSIGN d-vl-icm-com = d-vl-icm-com + ((natur-oper.aliq-icm-com / 100 ) * tt-it-doc-fisc.vl-bicms-it).
            END.
        END. 
    END.
    RUN openQueryStatic IN h-bodi084 (INPUT "Main").           
    RUN emptyRowErrors  IN h-bodi084.  
    RUN setRecord       IN h-bodi084(input table tt-it-doc-fisc).

    RUN validateInput  IN h-bodi084(INPUT tt-it-doc-fisc.cod-estabel,             
                                    INPUT tt-it-doc-fisc.serie,                    
                                    INPUT tt-it-doc-fisc.nr-doc-fis,                    
                                    INPUT tt-it-doc-fisc.cod-emitente,            
                                    INPUT tt-it-doc-fisc.nat-operacao,            
                                    INPUT tt-it-doc-fisc.nr-seq-doc,               
                                    INPUT tt-it-doc-fisc.it-codigo,                 
                                    OUTPUT TABLE RowErrors).  
    IF RETURN-VALUE = 'OK' THEN DO:
        RUN createRecord   IN h-bodi084.
        RUN getRowErrors   IN h-bodi084(OUTPUT TABLE RowErrors).
        RUN getRecord      IN h-bodi084(OUTPUT TABLE tt-it-doc-fisc).

        /*RUN pi-total-docto.*/
    END.

    /* Convenio 15 */
    IF  FiscalOperationCode BEGINS "7" THEN DO:
        FIND FIRST ext-doc-fiscal EXCLUSIVE-LOCK
             WHERE ext-doc-fiscal.cod-estabel  = Site                  
             AND   ext-doc-fiscal.serie        = DocumentSeries        
             AND   ext-doc-fiscal.nr-doc-fis   = DocumentNumber        
             AND   ext-doc-fiscal.cod-emitente = CustomerNumber        
             AND   ext-doc-fiscal.nat-operacao = FiscalOperationCode NO-ERROR.
        IF   AVAIL ext-doc-fiscal  THEN
            ASSIGN ext-doc-fiscal.dat-averb        = AmountDate
                   ext-doc-fiscal.cdn-natur-export = INT(FiscalOperationExport).
        ELSE DO:
            CREATE ext-doc-fiscal.
            ASSIGN ext-doc-fiscal.cod-estabel      = Site 
                   ext-doc-fiscal.serie            = DocumentSeries       
                   ext-doc-fiscal.nr-doc-fis       = DocumentNumber
                   ext-doc-fiscal.cod-emitente     = CustomerNumber
                   ext-doc-fiscal.nat-operacao     = FiscalOperationCode
                   ext-doc-fiscal.dat-averb        = AmountDate
                   ext-doc-fiscal.cdn-natur-export = INT(FiscalOperationExport).
        END.
    END.

    FOR EACH tt-it-doc-fisc:
        DELETE tt-it-doc-fisc.
    END. 
END.

IF d-vl-icm-com > 0 THEN DO:
    find doc-fiscal where rowid(doc-fiscal) = gr-doc-fiscal exclusive-lock no-error.
    if avail doc-fiscal then 
        ASSIGN doc-fiscal.vl-icms-com = d-vl-icm-com.
END.
RUN pi-total-docto.


