/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so pod\\jvd004277\compilados IRM1516 960973era ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT001 2.00.00.021}  /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft001 MAN}
&ENDIF

/********************************************************************************
** Programa : aneft001.p
** Fun‡Æo   : Sender da nota Fiscal
** Data     : 15/07/2000
** Autor    : Lutz - Planner / Sven Siegfried Imfeld - Neogrid
********************************************************************************/
/*
{adapters/neogrid/include/anein008.i} /* Valida se b2b est  implantado */
***** Comentado, pois j  valida se ‚ b2b e/ou CRM no ft2100rp.p *****
*/

{ftp/ft2100d.i}

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}

{adapters/neogrid/include/anein004.i} /*include com as fun‡äes de cria‡Æo do Xml*/

DEF INPUT PARAM TABLE FOR tt-nota-fiscal.
DEF INPUT PARAM TABLE FOR tt-it-nota-fisc.
DEF INPUT PARAM TABLE FOR tt-fat-duplic.
DEF INPUT PARAM TABLE FOR tt-val-nota.
DEF INPUT PARAM TABLE FOR tt-val-item.
DEF INPUT PARAM TABLE FOR tt-nota-embal.
DEF INPUT PARAM TABLE FOR tt-fat-ser-lote.
DEF INPUT PARAM TABLE FOR tt-it-beneficiado.

DEF VAR c-root                      AS CHAR NO-UNDO.
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-invoice                   AS CHAR NO-UNDO.
DEF VAR c-cod-emitente              AS CHAR NO-UNDO.
DEF VAR c-invoiceidentifier         AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-invoicepartnerlist        AS CHAR NO-UNDO.
DEF VAR c-fromrole                  AS CHAR NO-UNDO.
DEF VAR c-contactinformation        AS CHAR NO-UNDO.
DEF VAR c-address                   AS CHAR NO-UNDO.
DEF VAR c-torole                    AS CHAR NO-UNDO.
DEF VAR c-invoicecarrier            AS CHAR NO-UNDO.
DEF VAR c-invoicethirdparty         AS CHAR NO-UNDO.
DEF VAR c-commentcollection         AS CHAR NO-UNDO.
DEF VAR c-invoicepaymentinformation AS CHAR NO-UNDO.
DEF VAR c-invoicepaymentplan        AS CHAR NO-UNDO.
DEF VAR c-invoicepaymentcollection  AS CHAR NO-UNDO.
DEF VAR c-invoiceaddresslist        AS CHAR NO-UNDO.
DEF VAR c-shipplace                 AS CHAR NO-UNDO.
DEF VAR c-deliveryplace             AS CHAR NO-UNDO.
DEF VAR c-invoiceinstructions       AS CHAR NO-UNDO.
DEF VAR c-instructioncollection     AS CHAR NO-UNDO.
DEF VAR c-invoiceshipment           AS CHAR NO-UNDO.
DEF VAR c-vehicleinformation        AS CHAR NO-UNDO.
DEF VAR c-productlineitemcollection AS CHAR NO-UNDO.
DEF VAR c-packaginginformation      AS CHAR NO-UNDO.
DEF VAR c-invoicevaluecollection    AS CHAR NO-UNDO.

DEF VAR de-cotacao                  AS  DECIMAL NO-UNDO.
FIND FIRST param-global NO-LOCK NO-ERROR.

FOR EACH tt-nota-fiscal NO-LOCK:
    ASSIGN c-root = CreateNeoGridDoc("Invoice","1.01.001",tt-nota-fiscal.cod-estabel)
           c-message = addelement(c-root,"Message")
           c-invoice = addelement(c-message,"Invoice")
           c-invoiceidentifier = addelement(c-invoice,"InvoiceIdentifier")
           c-campo = addelechar(c-invoiceidentifier,"SerialNumber",tt-nota-fiscal.serie)
           c-campo = addelechar(c-invoiceidentifier,"InvoiceNumber",tt-nota-fiscal.nr-nota-fis)
           c-campo = addeleint(c-invoice,"InvoiceType",tt-nota-fiscal.id-tipo)
           c-campo = addeleint(c-invoice,"CommercialInvoice",tt-nota-fiscal.id-comercial)
           c-campo = addeleint(c-invoice,"ExternalImprovement",tt-nota-fiscal.id-beneficiamento)
           c-invoicepartnerlist = addelement(c-invoice,"InvoicePartnerList")
           c-fromrole = addelement(c-invoicepartnerlist,"FromRole")
           /*c-campo = addeleint(c-fromrole,"CompanyCode",param-global.empresa-prin)*/
           c-campo = addelechar(c-fromrole,"LegacyLocationIdentifier",tt-nota-fiscal.cod-estabel)
           c-campo = addelechar(c-fromrole,"GlobalPartnerRoleClassificationCode","INVOICER").

    IF tt-nota-fiscal.contato-for <> "" THEN 
        ASSIGN c-contactinformation = addelement(c-fromrole,"ContactInformation")
               c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-for)
               c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-for)
               c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-for).

    ASSIGN c-address = addelement(c-fromrole,"Address")
           c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-for)
           c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-for)
           c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-for)
           c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-for)
           c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-for)
           c-campo = addelechar(c-address,"NationalPostalCode", STRING(tt-nota-fiscal.cep-for))
           c-campo = addelechar(c-address,"AddressCode", "").
    
    /* ************************************************************ */
    FOR FIRST estabelec FIELDS(cgc) NO-LOCK
        WHERE estabelec.cod-estabel = tt-nota-fiscal.cod-estabel:
        ASSIGN c-campo = addelechar(c-fromrole,"PartnerId", estabelec.cgc).
    END.
    /* ************************************************************ */
    

    FOR FIRST emitente FIELDS(char-2 cgc) NO-LOCK
        WHERE emitente.cod-emitente = tt-nota-fiscal.cod-cliente:
    END.

    IF SUBSTRING(emitente.char-2,50,5) = "YES" THEN
        ASSIGN c-cod-emitente = SUBSTRING(emitente.char-2,55,13).
    ELSE 
        ASSIGN c-cod-emitente = STRING(tt-nota-fiscal.cod-cliente).

    ASSIGN c-torole = addelement(c-invoicepartnerlist,"ToRole")
           c-campo = addelechar(c-torole,"LegacyLocationIdentifier",c-cod-emitente)
           c-campo = addelechar(c-torole,"GlobalPartnerRoleClassificationCode","RECEIVER").

    IF tt-nota-fiscal.contato-cli <> "" THEN 
        ASSIGN c-contactinformation = addelement(c-torole,"ContactInformation")
               c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-cli)
               c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-cli)
               c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-cli).

    ASSIGN c-address = addelement(c-torole,"Address")
           c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-cli)
           c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-cli)
           c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-cli)
           c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-cli)
           c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-cli)
           c-campo = addelechar(c-address,"NationalPostalCode", tt-nota-fiscal.cep-cli)
           c-campo = addelechar(c-address,"AddressCode", "").
    
    /* ******************************************************************* */
    
    ASSIGN c-campo = addelechar(c-torole,"PartnerId", emitente.cgc).
    
    /* ******************************************************************* */

    ASSIGN c-invoicecarrier = addelement(c-invoicepartnerlist,"InvoiceCarrier")
           c-campo = addeleint(c-invoicecarrier,"LegacyLocationIdentifier",tt-nota-fiscal.cod-transp)
           c-campo = addelechar(c-invoicecarrier,"CarrierName", tt-nota-fiscal.nome-transp)
           c-contactinformation = addelement(c-invoicecarrier,"ContactInformation")
           c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-transp)
           c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-transp)
           c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-transp).

    IF tt-nota-fiscal.cod-beneficiador <> 0 THEN 
        ASSIGN c-invoicethirdparty = addelement(c-invoicepartnerlist,"InvoiceThirdParty")
               c-campo = addeleint(c-invoicethirdparty,"LegacyLocationIdentifier",tt-nota-fiscal.cod-beneficiador)
               c-campo = addelechar(c-invoicethirdparty,"GlobalPartnerRoleClassificationCode","BUYER")
               c-contactinformation = addelement(c-invoicethirdparty,"ContactInformation")
               c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-ben)
               c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-ben)
               c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-ben).

    IF tt-nota-fiscal.observ-nota <> "" THEN 
        ASSIGN c-commentcollection = addelement(c-invoice,"CommentCollection")
               c-campo = addelechar(c-commentcollection,"Comment",tt-nota-fiscal.observ-nota).

    FIND FIRST tt-fat-duplic
         WHERE tt-fat-duplic.cod-estabel = tt-nota-fiscal.cod-estabel
           AND tt-fat-duplic.serie       = tt-nota-fiscal.serie
           AND tt-fat-duplic.nr-fatura   = tt-nota-fiscal.nr-fatura NO-LOCK NO-ERROR.

    IF AVAIL tt-fat-duplic THEN DO:
        ASSIGN c-invoicepaymentinformation = addelement(c-invoice,"InvoicePaymentInformation")
               c-invoicepaymentplan = addelement(c-invoicepaymentinformation,"InvoicePaymentPlan")
               c-campo = addeleint(c-invoicepaymentplan,"PaymentCode",tt-nota-fiscal.cod-cond-pag).

        IF tt-nota-fiscal.des-cond-pag <> "" THEN 
            ASSIGN c-campo = addelechar(c-invoicepaymentplan,"Comment",tt-nota-fiscal.des-cond-pag).

        ASSIGN c-invoicepaymentcollection = addelement(c-invoicepaymentplan,"InvoicePaymentCollection").
    END.

    ASSIGN c-invoiceaddresslist = addelement(c-invoice,"InvoiceAddressList")
           c-shipplace = addelement(c-invoiceaddresslist,"ShipPlace")
           c-address = addelement(c-shipplace,"Address")
           c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-for)
           c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-for)
           c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-for)
           c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-for)
           c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-for)
           c-campo = addelechar(c-address,"NationalPostalCode", STRING(tt-nota-fiscal.cep-for))
           c-campo = addelechar(c-address,"AddressCode", "")
           c-contactinformation = addelement(c-shipplace,"ContactInformation")
           c-campo = addelechar(c-contactinformation,"ContactName", tt-nota-fiscal.contato-for)
           c-campo = addelechar(c-contactinformation,"TelephoneNumber", tt-nota-fiscal.telefone-for)
           c-campo = addelechar(c-contactinformation,"EmailAddress", tt-nota-fiscal.email-for)
           c-deliveryplace = addelement(c-invoiceaddresslist,"DeliveryPlace")
           c-address = addelement(c-deliveryplace,"Address")
           c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-ent)
           c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-ent)
           c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-ent)
           c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-ent)
           c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-ent)
           c-campo = addelechar(c-address,"NationalPostalCode", tt-nota-fiscal.cep-ent)
           c-campo = addelechar(c-address,"AddressCode", tt-nota-fiscal.cod-entrega)
           c-contactinformation = addelement(c-deliveryplace,"ContactInformation")
           c-campo = addelechar(c-contactinformation,"ContactName", tt-nota-fiscal.contato-cli)
           c-campo = addelechar(c-contactinformation,"TelephoneNumber", tt-nota-fiscal.telefone-cli)
           c-campo = addelechar(c-contactinformation,"EmailAddress", tt-nota-fiscal.email-cli).

    IF tt-nota-fiscal.narrativa-ben <> "" THEN 
        ASSIGN c-invoiceinstructions = addelement(c-invoice,"InvoiceInstructions")
               c-instructioncollection = addelement(c-invoiceinstructions,"InstructionCollection")
               c-campo = addelechar(c-instructioncollection,"Instruction",tt-nota-fiscal.narrativa-ben).

    ASSIGN c-campo = addelechar(c-invoice,"FiscalOperation",tt-nota-fiscal.nat-operacao).
           
    FOR FIRST natur-oper NO-LOCK                                                            
        WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao:               

        &IF DEFINED(bf_dis_formato_CFOP) &THEN 
           ASSIGN c-campo = addelechar(c-invoice,"CFOP", IF natur-oper.cod-cfop = "" THEN ""         
                                                         ELSE TRIM(natur-oper.cod-cfop)).            
        &ELSE 
           ASSIGN c-campo = addelechar(c-invoice,"CFOP", IF SUBSTR(natur-oper.char-1,45,10) = "" THEN ""         
                                                         ELSE TRIM(SUBSTR(natur-oper.char-1,45,10))).            
        &ENDIF  
    END.                                                                                                      

    ASSIGN c-campo = addelechar(c-invoice,"InvoiceStatus",IF tt-nota-fiscal.dt-cancela <> ? THEN "7" ELSE "9")
           c-campo = addeledate(c-invoice,"EmissionDate",tt-nota-fiscal.dt-emis-nota,"")
           c-campo = addeledate(c-invoice,"RegisterDate",tt-nota-fiscal.dt-emis-nota,"").

    IF tt-nota-fiscal.dt-embarque <> ? THEN 
        ASSIGN c-campo = addeledate(c-invoice,"EmbarkmentDate",tt-nota-fiscal.dt-embarque,"").

    ASSIGN c-invoiceshipment = addelement(c-invoice,"InvoiceShipment")
           c-vehicleinformation = addelement(c-invoiceshipment,"VehicleInformation")
           c-campo = addelechar(c-vehicleinformation,"VehicleDescription","")
           c-campo = addelechar(c-vehicleinformation,"VehicleLegalIdentification",tt-nota-fiscal.placa)
           c-campo = addelechar(c-vehicleinformation,"DriverName","")
           c-campo = addelechar(c-vehicleinformation,"DriverLegalIdentification","")
           c-campo = addelechar(c-vehicleinformation,"DriverLicense","")
           c-campo = addelechar(c-invoiceshipment,"LegacyShipmentTermsCode", tt-nota-fiscal.cif)
           c-campo = addelechar(c-invoiceshipment,"LegacyShipmentMethodCode",tt-nota-fiscal.metodo-transp)
           c-productlineitemcollection = addelement(c-invoice,"ProductLineItemCollection")
           c-packaginginformation = addelement(c-invoice,"PackagingInformation")
           c-invoicevaluecollection = addelement(c-invoice,"InvoiceValueCollection")
           c-campo = addeledate(c-invoice,"ForeseenDeliveryDate",tt-nota-fiscal.dt-saida,"").

    RUN pi-gera-duplic.
    RUN pi-gera-itens.
    RUN pi-gera-embal.
    RUN pi-gera-val-invoice.

END.

WriteXML().

PROCEDURE pi-gera-duplic:
    DEF VAR c-invoicepayment AS CHAR.
    DEF VAR c-parcelvalue    AS CHAR.
    DEF VAR c-discountvalue  AS CHAR.
    DEF VAR c-monetaryamount AS CHAR.

    FOR EACH tt-fat-duplic NO-LOCK 
        WHERE tt-fat-duplic.cod-estabel = tt-nota-fiscal.cod-estabel
          AND tt-fat-duplic.serie       = tt-nota-fiscal.serie
          AND tt-fat-duplic.nr-fatura   = tt-nota-fiscal.nr-fatura:
        ASSIGN c-invoicepayment = addelement(c-invoicepaymentcollection,"InvoicePayment")
               c-campo = addelechar(c-invoicepayment,"DocumentNumber", tt-fat-duplic.nr-fatura)
               c-campo = addelechar(c-invoicepayment,"DocumentTypeCode",tt-fat-duplic.cod-esp)
               c-campo = addelechar(c-invoicepayment,"ParcelNumber", tt-fat-duplic.parcela)
               c-campo = addeledate(c-invoicepayment,"DueDate",tt-fat-duplic.dt-venciment,"").

        IF tt-fat-duplic.dt-desconto <> ? THEN 
            ASSIGN c-campo = addeledate(c-invoicepayment,"DiscountDueDate",tt-fat-duplic.dt-desconto,"").

        /**  Funcao p/ Converter valores da nota para moeda do pedido de venda  **/
        IF CAN-FIND(funcao WHERE 
                    funcao.cd-funcao = "spp-conv-val-NF" AND 
                    funcao.ativo     = YES) THEN DO:
            
            FIND ped-venda
                WHERE ped-venda.nr-pedcli = tt-nota-fiscal.nr-pedcli
                  AND ped-venda.nome-abrev = tt-nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
            
            IF AVAIL ped-venda 
                AND ped-venda.mo-codigo <> 0 
                AND SUBSTR(tt-nota-fiscal.nat-operacao,1,1) = "7" THEN DO:
                RUN cdp/cd0812.p (INPUT 0,                              /* Moeda origem     */
                                  INPUT ped-venda.mo-codigo,            /* Moeda destino    */
                                  INPUT tt-fat-duplic.vl-parcela,       /* Valor origem     */
                                  INPUT tt-nota-fiscal.dt-emis-nota,    /* Data da cotacao  */
                                  OUTPUT de-cotacao).                   /* Valor convertido */
                IF de-cotacao > 0 THEN
                    ASSIGN tt-fat-duplic.vl-parcela = de-cotacao
                           tt-nota-fiscal.mo-codigo = STRING(ped-venda.mo-codigo)
                           de-cotacao = 0.
            END.
        
        END.
        /** Fim Funcao **/
        ASSIGN c-parcelvalue = addelement(c-invoicepayment,"ParcelValue")
               c-monetaryamount = addelement(c-parcelvalue,"MonetaryAmount")
               c-campo = REPLACE(STRING(tt-fat-duplic.vl-parcela), ",", ".")
               c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
               c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode",tt-nota-fiscal.mo-codigo)
               c-discountvalue =  addelement(c-invoicepayment,"DiscountValue")
               c-monetaryamount = addelement(c-discountvalue,"MonetaryAmount")
               c-campo = REPLACE(STRING(tt-fat-duplic.per-des-pgan), ",", ".")
               c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
               c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode",tt-nota-fiscal.mo-codigo).
    END.
END PROCEDURE.

PROCEDURE pi-gera-itens:
    DEF VAR c-productlineitem            AS CHAR NO-UNDO.
    DEF VAR c-orderattendance            AS CHAR NO-UNDO.
    DEF VAR c-poattendancecollection     AS CHAR NO-UNDO.
    DEF VAR c-poattendance               AS CHAR NO-UNDO.
    DEF VAR c-pofulfilledquantity        AS CHAR NO-UNDO.
    DEF VAR c-quantityamount             AS CHAR NO-UNDO.
    DEF VAR c-soattendancecollection     AS CHAR NO-UNDO.
    DEF VAR c-soattendance               AS CHAR NO-UNDO.
    DEF VAR c-sofulfilledquantity        AS CHAR NO-UNDO.
    DEF VAR c-productquantity            AS CHAR NO-UNDO.
    DEF VAR c-invoiceitemvaluecollection AS CHAR NO-UNDO.
    DEF VAR c-itemlotcollection          AS CHAR NO-UNDO.
    DEF VAR c-associatedinvoiceitems     AS CHAR NO-UNDO.
    DEF VAR c-iteminstructions           AS CHAR NO-UNDO.
    DEF VAR c-itemnetweight              AS CHAR NO-UNDO.
    DEF VAR c-itemgrossweight            AS CHAR NO-UNDO.

    FIND FIRST ngadapterparms NO-LOCK NO-ERROR.

    FOR EACH tt-it-nota-fisc NO-LOCK
        WHERE tt-it-nota-fisc.cod-estabel = tt-nota-fiscal.cod-estabel
          AND tt-it-nota-fisc.serie       = tt-nota-fiscal.serie
          AND tt-it-nota-fisc.nr-nota-fis = tt-nota-fiscal.nr-nota-fis:

        ASSIGN c-productlineitem = addelement(c-productlineitemcollection,"ProductLineItem").
        
        FIND FIRST ITEM 
            WHERE item.it-codigo = tt-it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            FOR FIRST emitente FIELDS(char-2)
                WHERE emitente.cod-emitente = tt-nota-fiscal.cod-cliente NO-LOCK:
            END.
            IF SUBSTRING(emitente.char-2,50,5) = "YES" AND ITEM.codigo-refer <> "" THEN
                ASSIGN c-campo = addelechar(c-productlineitem,"LegacyProductIdentifier",ITEM.codigo-refer).
            ELSE
                ASSIGN c-campo = addelechar(c-productlineitem,"LegacyProductIdentifier",tt-it-nota-fisc.it-codigo).
        END.
        ELSE
            ASSIGN c-campo = addelechar(c-productlineitem,"LegacyProductIdentifier",tt-it-nota-fisc.it-codigo).

        ASSIGN c-campo = addelechar(c-productlineitem,"LegacyProductReference",tt-it-nota-fisc.cod-refer)
               c-campo = addeleint(c-productlineitem,"DeliveryNumber",tt-it-nota-fisc.nr-entrega)
               c-campo = addelechar(c-productlineitem,"ProductDescription",tt-it-nota-fisc.desc-item)
               c-campo = addelechar(c-productlineitem,"PriceTable",tt-it-nota-fisc.nr-tabpre)
               c-orderattendance = addelement(c-productlineitem,"OrderAttendance")
               c-poattendancecollection = addelement(c-orderattendance,"POAttendanceCollection")
               c-poattendance = addelement(c-poattendancecollection,"POAttendance")
               c-campo = addelechar(c-poattendance,"POIdentifier",tt-it-nota-fisc.nr-pedcli)
               c-campo = addelechar(c-poattendance,"PONumber",tt-it-nota-fisc.cod-ord-compra)
               c-campo = addeleint(c-poattendance,"POParcelNumber",tt-it-nota-fisc.parcela)
               c-pofulfilledquantity = addelement(c-poattendance,"POFulfilledQuantity")
               c-quantityamount = addelement(c-pofulfilledquantity,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-it-nota-fisc.qt-faturada[1]), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1])
               c-soattendancecollection = addelement(c-orderattendance,"SOAttendanceCollection")
               c-soattendance = addelement(c-soattendancecollection,"SOAttendance")
               c-campo = addeleint(c-soattendance,"SOIdentifier",tt-it-nota-fisc.nr-pedido)
               c-campo = addeleint(c-soattendance,"SOParcelNumber",tt-it-nota-fisc.nr-seq-ped)
               c-sofulfilledquantity = addelement(c-soattendance,"SOFulfilledQuantity")
               c-quantityamount = addelement(c-sofulfilledquantity,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-it-nota-fisc.qt-faturada[1]), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1])
               c-campo = addeleint(c-productlineitem,"ItemNumber",tt-it-nota-fisc.nr-seq-fat).

        IF tt-it-nota-fisc.narrativa <> "" THEN 
            ASSIGN c-campo = addelechar(c-productlineitem,"ProductDetailing",tt-it-nota-fisc.narrativa).

        ASSIGN c-campo = addelechar(c-productlineitem,"FiscalOperation",tt-it-nota-fisc.nat-operacao).
                                                
        FOR FIRST natur-oper FIELDS(char-1) NO-LOCK                                  
            WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao:                   
            ASSIGN c-campo = addelechar(c-productlineitem,"CFOP", IF SUBSTR(natur-oper.char-1,45,10) = "" THEN ""
                                                                  ELSE TRIM(SUBSTR(natur-oper.char-1,45,10))).        
        END.                                                                                

        ASSIGN c-campo = addelechar(c-productlineitem,"FiscalClassification",tt-it-nota-fisc.class-fiscal)
               c-campo = addelechar(c-productlineitem,"FiscalClassification",tt-it-nota-fisc.class-fiscal)
               c-productquantity = addelement(c-productlineitem,"ProductQuantity")
               c-quantityamount  = addelement(c-productquantity,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-it-nota-fisc.qt-faturada[1]), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1])
               c-invoiceitemvaluecollection = addelement(c-productlineitem,"InvoiceItemValueCollection").

        FIND FIRST tt-fat-ser-lote
             WHERE tt-fat-ser-lote.cod-estabel = tt-it-nota-fisc.cod-estabel
               AND tt-fat-ser-lote.serie       = tt-it-nota-fisc.serie
               AND tt-fat-ser-lote.nr-nota-fis = tt-it-nota-fisc.nr-nota-fis
               AND tt-fat-ser-lote.nr-seq-fat  = tt-it-nota-fisc.nr-seq-fat NO-LOCK NO-ERROR.

        IF AVAIL tt-fat-ser-lote THEN 
            ASSIGN c-itemlotcollection = addelement(c-productlineitem,"ItemLotCollection").

        FIND FIRST tt-it-beneficiado
             WHERE tt-it-beneficiado.cod-estabel = tt-it-nota-fisc.cod-estabel
               AND tt-it-beneficiado.serie       = it-nota-fisc.serie
               AND tt-it-beneficiado.nr-nota-fis = it-nota-fisc.nr-nota-fis
               AND tt-it-beneficiado.nr-seq-fat  = it-nota-fisc.nr-seq-fat
               AND tt-it-beneficiado.it-codigo   = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL tt-it-beneficiado THEN DO:
            ASSIGN c-associatedinvoiceitems = addelement(c-productlineitem,"AssociatedInvoiceItems").
            IF tt-it-beneficiado.narrativa <> "" THEN 
                ASSIGN c-iteminstructions = addelement(c-productlineitem,"ItemInstructions").
        END.

        ASSIGN c-itemnetweight = addelement(c-productlineitem,"ItemNetWeight")
               c-quantityamount = addelement(c-itemnetweight,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-it-nota-fisc.peso-liq-fat), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure", "KG")
               c-itemgrossweight = addelement(c-productlineitem,"ItemGrossWeight")
               c-quantityamount =  addelement(c-itemgrossweight,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-it-nota-fisc.peso-bruto), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure", "KG").

       RUN pi-gera-val-items(INPUT c-invoiceitemvaluecollection).
       RUN pi-gera-lotes(INPUT c-itemlotcollection).
       RUN pi-gera-item-associado(INPUT c-associatedinvoiceitems, 
                                  INPUT c-iteminstructions).

       IF tt-nota-fiscal.no-ab-reppri <> "" THEN DO:
           FOR FIRST repres NO-LOCK 
               WHERE repres.nome-abrev = tt-nota-fiscal.no-ab-reppri:
               ASSIGN c-campo = addeleint(c-productlineitem,"SalesRepresentative",repres.cod-rep).
           END.
       END.

    END.
END PROCEDURE.

PROCEDURE pi-gera-embal:
    DEF VAR c-totalnetweight    AS CHAR NO-UNDO.
    DEF VAR c-totalgrossweight  AS CHAR NO-UNDO.
    DEF VAR c-quantityamount    AS CHAR NO-UNDO.
    DEF VAR c-packagecollection AS CHAR NO-UNDO.
    DEF VAR c-package           AS CHAR NO-UNDO.
    DEF VAR c-volumesquantity   AS CHAR NO-UNDO.
    DEF VAR c-volume            AS CHAR NO-UNDO.

    ASSIGN c-totalnetweight = addelement(c-packaginginformation,"TotalNetWeight")
           c-quantityamount = addelement(c-totalnetweight,"QuantityAmount")
           c-campo = REPLACE(STRING(tt-nota-fiscal.peso-liq-tot), ",", ".")
           c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
           c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure","KG")
           c-totalgrossweight = addelement(c-packaginginformation,"TotalGrossWeight")
           c-quantityamount = addelement(c-totalgrossweight,"QuantityAmount")
           c-campo = REPLACE(STRING(tt-nota-fiscal.peso-bru-tot), ",", ".")
           c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
           c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure","KG").

    FIND FIRST tt-nota-embal
         WHERE tt-nota-embal.cod-estabel = tt-nota-fiscal.cod-estabel
           AND tt-nota-embal.serie       = tt-nota-fiscal.serie
           AND tt-nota-embal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

    IF AVAIL tt-nota-embal THEN 
        ASSIGN c-packagecollection = addelement(c-packaginginformation,"PackageCollection").

    FOR EACH tt-nota-embal NO-LOCK 
        WHERE tt-nota-embal.cod-estabel = tt-nota-fiscal.cod-estabel
          AND tt-nota-embal.serie       = tt-nota-fiscal.serie
          AND tt-nota-embal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis:
        ASSIGN c-package  = addelement(c-packagecollection,"Package")
               c-volumesquantity = addelement(c-package,"VolumesQuantity")
               c-quantityamount = addelement(c-volumesquantity,"QuantityAmount")
               c-campo = addeleint(c-quantityamount,"Quantity",tt-nota-embal.qt-volumes)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-nota-embal.sigla-emb)
               c-volume = addelement(c-package,"Volume")
               c-quantityamount = addelement(c-volume,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-nota-embal.volume), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure","m3").

        IF tt-nota-embal.desc-vol <> "" THEN 
            ASSIGN c-campo = addelechar(c-package,"PackageIdentification",tt-nota-embal.desc-vol).
    END.
END PROCEDURE.

PROCEDURE pi-gera-val-invoice:
    DEF VAR c-invoicevalue   AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount AS CHAR NO-UNDO.

    FOR EACH tt-val-nota NO-LOCK
        WHERE tt-val-nota.cod-estabel = tt-nota-fiscal.cod-estabel
          AND tt-val-nota.serie       = tt-nota-fiscal.serie
          AND tt-val-nota.nr-nota-fis = tt-nota-fiscal.nr-nota-fis:
        ASSIGN c-invoicevalue = addelement(c-invoicevaluecollection,"InvoiceValue")
               c-campo = addelechar(c-invoicevalue,"ValueIdentifier", tt-val-nota.ind-tip-val).
        /**  Funcao p/ Converter valores da nota para moeda do pedido de venda  **/
        IF CAN-FIND(funcao WHERE 
                    funcao.cd-funcao = "spp-conv-val-NF" AND 
                    funcao.ativo     = YES) THEN DO:
            
            FIND ped-venda
                WHERE ped-venda.nr-pedcli = tt-nota-fiscal.nr-pedcli
                  AND ped-venda.nome-abrev = tt-nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
        
            IF AVAIL ped-venda 
                AND ped-venda.mo-codigo <> 0 
                AND SUBSTR(tt-nota-fiscal.nat-operacao,1,1) = "7" THEN DO:
                RUN cdp/cd0812.p (INPUT 0,                              /* Moeda origem     */
                                  INPUT ped-venda.mo-codigo,            /* Moeda destino    */
                                  INPUT tt-val-nota.de-valor,           /* Valor origem     */
                                  INPUT tt-nota-fiscal.dt-emis-nota,    /* Data da cotacao  */
                                  OUTPUT de-cotacao).                   /* Valor convertido */
                IF de-cotacao > 0 THEN
                    ASSIGN tt-val-nota.de-valor = de-cotacao
                           tt-val-nota.mo-codigo = STRING(ped-venda.mo-codigo)
                           de-cotacao = 0.
            END.
        
        END.
        /** Fim Funcao **/

        IF tt-val-nota.de-perc > 0 THEN 
            ASSIGN c-campo = REPLACE(STRING(tt-val-nota.de-perc), ",", ".")
                   c-campo = addelechar(c-invoicevalue,"Percent",c-campo).
        ELSE 
            ASSIGN c-monetaryamount = addelement(c-invoicevalue,"MonetaryAmount")
                   c-campo = REPLACE(STRING(tt-val-nota.de-valor), ",", ".")
                   c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
                   c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode",tt-val-nota.mo-codigo).
    END.
END PROCEDURE.

PROCEDURE pi-gera-val-items:
    DEF INPUT PARAM p-invoiceitemvaluecollection AS CHAR NO-UNDO.

    DEF VAR c-invoiceitemvalue AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount   AS CHAR NO-UNDO.

    FOR EACH tt-val-item NO-LOCK
        WHERE tt-val-item.cod-estabel = tt-it-nota-fisc.cod-estabel
          AND tt-val-item.serie       = tt-it-nota-fisc.serie
          AND tt-val-item.nr-nota-fis = tt-it-nota-fisc.nr-nota-fis
          AND tt-val-item.nr-seq-fat  = tt-it-nota-fisc.nr-seq-fat
          AND tt-val-item.it-codigo   = tt-it-nota-fisc.it-codigo:

        IF tt-val-item.de-valor = ? OR tt-val-item.de-perc = ? THEN 
            NEXT.
        IF tt-val-item.de-valor = 0 AND tt-val-item.de-perc = 0 THEN 
            NEXT.

        /**  Funcao p/ Converter valores da nota para moeda do pedido de venda  **/
        IF CAN-FIND(funcao WHERE 
                    funcao.cd-funcao = "spp-conv-val-NF" AND 
                    funcao.ativo     = YES) THEN DO:
            
            FIND ped-venda
                WHERE ped-venda.nr-pedido = tt-it-nota-fisc.nr-pedido NO-LOCK NO-ERROR.
            IF AVAIL ped-venda 
                AND ped-venda.mo-codigo <> 0 
                AND SUBSTR(tt-nota-fiscal.nat-operacao,1,1) = "7" THEN DO:
                
                RUN cdp/cd0812.p (INPUT 0,                            /* Moeda origem     */
                                  INPUT ped-venda.mo-codigo,          /* Moeda destino    */
                                  INPUT tt-val-item.de-valor,         /* Valor origem     */
                                  INPUT tt-it-nota-fisc.dt-emis-nota, /* Data da cotacao  */
                                  OUTPUT de-cotacao).                 /* Valor convertido */

                IF de-cotacao > 0 THEN
                    ASSIGN tt-val-item.de-valor = de-cotacao
                           tt-val-item.mo-codigo = STRING(ped-venda.mo-codigo) 
                           de-cotacao = 0.
            END.
        
        END.
        /** Fim Funcao **/

        ASSIGN c-invoiceitemvalue = addelement(p-invoiceitemvaluecollection,"InvoiceItemValue")
               c-campo = addelechar(c-invoiceitemvalue,"ValueIdentifier", tt-val-item.ind-tip-val).

        IF tt-val-item.de-perc > 0 THEN 
            ASSIGN c-campo = REPLACE(STRING(tt-val-item.de-perc), ",", ".")
                   c-campo = addelechar(c-invoiceitemvalue,"Percent",c-campo).
        ELSE 
            ASSIGN c-monetaryamount = addelement(c-invoiceitemvalue,"MonetaryAmount")
                   c-campo = REPLACE(STRING(tt-val-item.de-valor), ",", ".")
                   c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
                   c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode", tt-val-item.mo-codigo).
    END.
END PROCEDURE.

PROCEDURE pi-gera-lotes:
    DEF INPUT PARAM p-itemlotcollection AS CHAR NO-UNDO.

    DEF VAR c-itemlot        AS CHAR NO-UNDO.
    DEF VAR c-quantityamount AS CHAR NO-UNDO.

    FOR EACH tt-fat-ser-lote NO-LOCK 
        WHERE tt-fat-ser-lote.cod-estabel = tt-it-nota-fisc.cod-estabel
          AND tt-fat-ser-lote.serie       = tt-it-nota-fisc.serie
          AND tt-fat-ser-lote.nr-nota-fis = tt-it-nota-fisc.nr-nota-fis
          AND tt-fat-ser-lote.nr-seq-fat  = tt-it-nota-fisc.nr-seq-fat:
        
        ASSIGN c-itemlot = addelement(p-itemlotcollection,"ItemLot")
               c-campo = addelechar(c-itemlot,"LotNumber", tt-fat-ser-lote.nr-serlote)
               c-campo = addeledate(c-itemlot,"ValidityDate",tt-fat-ser-lote.dt-validade,"")
               c-quantityamount = addelement(c-itemlot,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-fat-ser-lote.qt-baixada[1]), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1]).
    END.
END PROCEDURE.

PROCEDURE pi-gera-item-associado:
    DEF INPUT PARAM p-associatedinvoiceitems AS CHAR NO-UNDO.
    DEF INPUT PARAM p-iteminstructions       AS CHAR NO-UNDO.

    DEF VAR c-invoiceitemidentifiercollect AS CHAR NO-UNDO. /* nome de variavel nao pode ultrapassar 32 caracteres */
    DEF VAR c-invoiceitemidentifier        AS CHAR NO-UNDO.
    DEF VAR c-quantityamount               AS CHAR NO-UNDO.
    DEF VAR c-instructioncollection        AS CHAR NO-UNDO.

    IF AVAIL tt-it-beneficiado THEN DO:
        ASSIGN c-invoiceitemidentifiercollect = addelement(p-associatedinvoiceitems,"InvoiceItemIdentifierCollection")
               c-invoiceitemidentifier = addelement(c-invoiceitemidentifiercollect,"InvoiceItemIdentifier")
               c-campo = addelechar(c-invoiceitemidentifier,"SerialNumber",tt-it-beneficiado.serie)
               c-campo = addelechar(c-invoiceitemidentifier,"InvoiceNumber",tt-it-beneficiado.nr-nota-fis)
               c-campo = addeleint(c-invoiceitemidentifier,"ItemNumber",tt-it-beneficiado.nr-seq-fat).

        FIND FIRST ITEM 
            WHERE item.it-codigo = tt-it-beneficiado.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:

            FOR FIRST emitente FIELDS(char-2)
                WHERE emitente.cod-emitente = tt-nota-fiscal.cod-cliente NO-LOCK:
            END.

            IF SUBSTRING(emitente.char-2,50,5) = "YES" AND ITEM.codigo-refer <> "" THEN
                ASSIGN c-campo = AddEleChar(c-invoiceitemidentifier,"LegacyProductIdentifier",item.codigo-refer).
            ELSE
                ASSIGN c-campo = addelechar(c-invoiceitemidentifier,"LegacyProductIdentifier",tt-it-beneficiado.it-codigo).
        END.
        ELSE
            ASSIGN c-campo = addelechar(c-invoiceitemidentifier,"LegacyProductIdentifier",tt-it-beneficiado.it-codigo).

        ASSIGN c-campo = addelechar(c-invoiceitemidentifier,"LegacyProductReference",tt-it-beneficiado.cod-refer)
               c-campo = addelechar(c-invoiceitemidentifier,"DrawerRole","INVOICER")
               c-campo = addelechar(c-invoiceitemidentifier,"AddresseeRole","RECEIVER")
               c-quantityamount = addelement(c-invoiceitemidentifier,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-it-beneficiado.qt-item), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-beneficiado.un).

       IF tt-it-beneficiado.narrativa <> "" THEN 
           ASSIGN c-instructioncollection = addelement(p-iteminstructions,"InstructionCollection")
                  c-campo = addelechar(c-instructioncollection,"Instruction",tt-it-beneficiado.narrativa).
    END.
END PROCEDURE.
