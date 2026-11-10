/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT051 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i aneft051 MAN}
&ENDIF

/********************************************************************************
** Programa : aneft051.p
** Fun‡Æo   : Sender da nota Fiscal
** Data     : 15/07/2000
** Autor    : Lutz - Planner / Sven Siegfried Imfeld - Neogrid
********************************************************************************/
/*
{adapters/neogrid/include/anein008.i} /* Valida se b2b est  implantado */
***** Comentado, pois j  valida se ‚ b2b e/ou CRM no ft2100rp.p *****
*/

{ftp/ft2100d.i}
{adapters/neogrid/include/anein004.i} /*include com as fun‡äes de cria‡Æo do Xml*/
{cdp/cdcfgdis.i}

def input param table for tt-nota-fiscal.
def input param table for tt-it-nota-fisc.
def input param table for tt-fat-duplic.
def input param table for tt-val-nota.
def input param table for tt-val-item.
def input param table for tt-nota-embal.
def input param table for tt-fat-ser-lote.
def input param table for tt-it-beneficiado.

def var c-root                      as char.
def var c-message                   as char.
def var c-invoice                   as char.
def var c-invoiceidentifier         as char.
def var c-campo                     as char.
def var c-invoicepartnerlist        as char.
def var c-fromrole                  as char.
def var c-contactinformation        as char.
def var c-address                   as char.
def var c-torole                    as char.
def var c-invoicecarrier            as char.
def var c-invoicethirdparty         as char.
def var c-commentcollection         as char.
def var c-invoicepaymentinformation as char.
def var c-invoicepaymentplan        as char.
def var c-invoicepaymentcollection  as char.
def var c-invoiceaddresslist        as char.
def var c-shipplace                 as char.
def var c-deliveryplace             as char.
def var c-invoiceinstructions       as char.
def var c-instructioncollection     as char.
def var c-invoiceshipment           as char.
def var c-vehicleinformation        as char.
def var c-productlineitemcollection as char.
def var c-packaginginformation      as char.
def var c-invoicevaluecollection    as char.
DEFINE VARIABLE l-EmbarkmentDate    AS LOG        NO-UNDO.
DEFINE VARIABLE dt-EmbarkmentDate   LIKE tt-nota-fiscal.dt-embarque.


ASSIGN l-EmbarkmentDate  = CAN-FIND(FIRST funcao
                           WHERE funcao.cd-funcao = "spp-EmbarkDate":U
                           AND   funcao.ativo).

find first param-global no-lock no-error.

for each tt-nota-fiscal no-lock:
    assign c-root = CreateNeoGridDoc("Invoice","1.01.001",tt-nota-fiscal.cod-estabel)
             c-message = addelement(c-root,"CRM")
             c-message = addelement(c-root,"Message")
               c-invoice = addelement(c-message,"Invoice")
                 c-invoiceidentifier = addelement(c-invoice,"InvoiceIdentifier")
                   c-campo = addelechar(c-invoiceidentifier,"SerialNumber",tt-nota-fiscal.serie)
                   c-campo = addelechar(c-invoiceidentifier,"InvoiceNumber",tt-nota-fiscal.nr-nota-fis)
                 c-campo = addeleint(c-invoice,"InvoiceType",tt-nota-fiscal.id-tipo)
                 c-campo = addeleint(c-invoice,"CommercialInvoice",tt-nota-fiscal.id-comercial)
                 c-campo = addeleint(c-invoice,"ExternalImprovement",tt-nota-fiscal.id-beneficiamento)
                 c-campo = addeleint(c-invoice,"RepresentativeCode",tt-nota-fiscal.cod-rep)
                 c-invoicepartnerlist = addelement(c-invoice,"InvoicePartnerList")
                   c-fromrole = addelement(c-invoicepartnerlist,"FromRole")
                     &IF "{&mguni_version}" >= "2.071" &then
                        c-campo = addelechar(c-fromrole,"CompanyCode",param-global.empresa-prin)
                     &else
                        c-campo = addeleint(c-fromrole,"CompanyCode",param-global.empresa-prin)   
                     &ENDIF
                     c-campo = addelechar(c-fromrole,"LegacyLocationIdentifier",tt-nota-fiscal.cod-estabel)
                     c-campo = addelechar(c-fromrole,"GlobalPartnerRoleClassificationCode","INVOICER").

    if  tt-nota-fiscal.contato-for <> "" then
        assign c-contactinformation = addelement(c-fromrole,"ContactInformation")
                 c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-for)
                 c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-for)
                 c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-for).

    assign c-address = addelement(c-fromrole,"Address")
             c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-for)
             c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-for)
             c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-for)
             c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-for)
             c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-for)
             c-campo = addelechar(c-address,"NationalPostalCode", string(tt-nota-fiscal.cep-for))
             c-campo = addelechar(c-address,"AddressCode", "").

    assign c-torole = addelement(c-invoicepartnerlist,"ToRole")
             c-campo = addeleint(c-torole,"LegacyLocationIdentifier",tt-nota-fiscal.cod-cliente)
             c-campo = addelechar(c-torole,"GlobalPartnerRoleClassificationCode","RECEIVER").

    if  tt-nota-fiscal.contato-cli <> "" then
        assign c-contactinformation = addelement(c-torole,"ContactInformation")
                 c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-cli)
                 c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-cli)
                 c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-cli).

    assign c-address = addelement(c-torole,"Address")
             c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-cli)
             c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-cli)
             c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-cli)
             c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-cli)
             c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-cli)
             c-campo = addelechar(c-address,"NationalPostalCode", tt-nota-fiscal.cep-cli)
             c-campo = addelechar(c-address,"AddressCode", "").

    assign c-invoicecarrier = addelement(c-invoicepartnerlist,"InvoiceCarrier")
             c-campo = addeleint(c-invoicecarrier,"LegacyLocationIdentifier",tt-nota-fiscal.cod-transp)
             c-campo = addelechar(c-invoicecarrier,"CarrierName", tt-nota-fiscal.nome-transp)
             c-contactinformation = addelement(c-invoicecarrier,"ContactInformation")
               c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-transp)
               c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-transp)
               c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-transp).

    if  tt-nota-fiscal.cod-beneficiador <> 0 then
        assign c-invoicethirdparty = addelement(c-invoicepartnerlist,"InvoiceThirdParty")
                 c-campo = addeleint(c-invoicethirdparty,"LegacyLocationIdentifier",tt-nota-fiscal.cod-beneficiador)
                 c-campo = addelechar(c-invoicethirdparty,"GlobalPartnerRoleClassificationCode","BUYER")
                 c-contactinformation = addelement(c-invoicethirdparty,"ContactInformation")
                   c-campo = addelechar(c-contactinformation,"ContactName",tt-nota-fiscal.contato-ben)
                   c-campo = addelechar(c-contactinformation,"EmailAddress",tt-nota-fiscal.email-ben)
                   c-campo = addelechar(c-contactinformation,"TelephoneNumber",tt-nota-fiscal.telefone-ben).

    if  tt-nota-fiscal.observ-nota <> "" then
        assign c-commentcollection = addelement(c-invoice,"CommentCollection")
               c-campo = addelechar(c-commentcollection,"Comment",tt-nota-fiscal.observ-nota).

    find first tt-fat-duplic
         where tt-fat-duplic.cod-estabel = tt-nota-fiscal.cod-estabel
         and   tt-fat-duplic.serie       = tt-nota-fiscal.serie
         and   tt-fat-duplic.nr-fatura   = tt-nota-fiscal.nr-fatura
         no-lock no-error.

    if  avail tt-fat-duplic then do:
        assign c-invoicepaymentinformation = addelement(c-invoice,"InvoicePaymentInformation")
                 c-invoicepaymentplan = addelement(c-invoicepaymentinformation,"InvoicePaymentPlan")
                   c-campo = addeleint(c-invoicepaymentplan,"PaymentCode",tt-nota-fiscal.cod-cond-pag).

        if  tt-nota-fiscal.des-cond-pag <> "" then
            assign c-campo = addelechar(c-invoicepaymentplan,"Comment",tt-nota-fiscal.des-cond-pag).

        assign c-invoicepaymentcollection = addelement(c-invoicepaymentplan,"InvoicePaymentCollection").
    end.

    assign c-invoiceaddresslist = addelement(c-invoice,"InvoiceAddressList")
             c-shipplace = addelement(c-invoiceaddresslist,"ShipPlace")
               c-address = addelement(c-shipplace,"Address")
                 c-campo = addelechar(c-address,"AddressLine1", tt-nota-fiscal.endereco-for)
                 c-campo = addelechar(c-address,"CityName", tt-nota-fiscal.cidade-for)
                 c-campo = addelechar(c-address,"DistrictName", tt-nota-fiscal.bairro-for)
                 c-campo = addelechar(c-address,"StateCode", tt-nota-fiscal.estado-for)
                 c-campo = addelechar(c-address,"LegacyCountryCode", tt-nota-fiscal.pais-for)
                 c-campo = addelechar(c-address,"NationalPostalCode", string(tt-nota-fiscal.cep-for))
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

    if  tt-nota-fiscal.narrativa-ben <> "" then
        assign c-invoiceinstructions = addelement(c-invoice,"InvoiceInstructions")
                 c-instructioncollection = addelement(c-invoiceinstructions,"InstructionCollection")
                   c-campo = addelechar(c-instructioncollection,"Instruction",tt-nota-fiscal.narrativa-ben).

    assign c-campo = addelechar(c-invoice,"FiscalOperation",tt-nota-fiscal.nat-operacao)
           c-campo = addelechar(c-invoice,"InvoiceStatus",IF tt-nota-fiscal.dt-cancela <> ? THEN "Cancelada" ELSE "Emitida")
           c-campo = addeledate(c-invoice,"CancelDate",tt-nota-fiscal.dt-cancela,"")
           c-campo = addeledate(c-invoice,"EmissionDate",tt-nota-fiscal.dt-emis-nota,"")
           c-campo = addeledate(c-invoice,"RegisterDate",tt-nota-fiscal.dt-emis-nota,"").
    
    IF l-EmbarkmentDate THEN 
        ASSIGN dt-EmbarkmentDate = tt-nota-fiscal.dt-saida.
    
    ELSE 
        ASSIGN dt-EmbarkmentDate = tt-nota-fiscal.dt-embarque.
    
    if  dt-EmbarkmentDate <> ? then
        assign c-campo = addeledate(c-invoice,"EmbarkmentDate",dt-EmbarkmentDate,"").

    assign c-invoiceshipment = addelement(c-invoice,"InvoiceShipment")
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
           c-invoicevaluecollection = addelement(c-invoice,"InvoiceValueCollection").

    run pi-gera-duplic.
    run pi-gera-itens.
    run pi-gera-embal.
    run pi-gera-val-invoice.
end.

WriteXML().

procedure pi-gera-duplic:
    def var c-invoicepayment as char.
    def var c-parcelvalue    as char.
    def var c-discountvalue  as char.
    def var c-monetaryamount as char.

    for each  tt-fat-duplic no-lock
        where tt-fat-duplic.cod-estabel = tt-nota-fiscal.cod-estabel
        and   tt-fat-duplic.serie       = tt-nota-fiscal.serie
        and   tt-fat-duplic.nr-fatura   = tt-nota-fiscal.nr-fatura:
        assign c-invoicepayment = addelement(c-invoicepaymentcollection,"InvoicePayment")
                 c-campo = addelechar(c-invoicepayment,"DocumentNumber", tt-fat-duplic.nr-fatura)
                 c-campo = addelechar(c-invoicepayment,"DocumentTypeCode",tt-fat-duplic.cod-esp)
                 c-campo = addelechar(c-invoicepayment,"ParcelNumber", tt-fat-duplic.parcela)
                 c-campo = addeledate(c-invoicepayment,"DueDate",tt-fat-duplic.dt-venciment,"").

        if  tt-fat-duplic.dt-desconto <> ? then
            assign c-campo = addeledate(c-invoicepayment,"DiscountDueDate",tt-fat-duplic.dt-desconto,"").

        assign c-parcelvalue = addelement(c-invoicepayment,"ParcelValue")
                 c-monetaryamount = addelement(c-parcelvalue,"MonetaryAmount")
                   c-campo = replace(string(tt-fat-duplic.vl-parcela), ",", ".")
                   c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
                   c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode",tt-nota-fiscal.mo-codigo)
               c-discountvalue =  addelement(c-invoicepayment,"DiscountValue")
                 c-monetaryamount = addelement(c-discountvalue,"MonetaryAmount")
                   c-campo = replace(string(tt-fat-duplic.per-des-pgan), ",", ".")
                   c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
                   c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode",tt-nota-fiscal.mo-codigo).
    end.
end procedure.

procedure pi-gera-itens:
    def var c-productlineitem            as char.
    def var c-orderattendance            as char.
    def var c-poattendancecollection     as char.
    def var c-poattendance               as char.
    def var c-pofulfilledquantity        as char.
    def var c-quantityamount             as char.
    def var c-soattendancecollection     as char.
    def var c-soattendance               as char.
    def var c-sofulfilledquantity        as char.
    def var c-productquantity            as char.
    def var c-invoiceitemvaluecollection as char.
    def var c-itemlotcollection          as char.
    def var c-associatedinvoiceitems     as char.
    def var c-iteminstructions           as char.
    def var c-itemnetweight              as char.
    def var c-itemgrossweight            as char.

    for each  tt-it-nota-fisc NO-LOCK
        where tt-it-nota-fisc.cod-estabel = tt-nota-fiscal.cod-estabel
        and   tt-it-nota-fisc.serie       = tt-nota-fiscal.serie
        and   tt-it-nota-fisc.nr-nota-fis = tt-nota-fiscal.nr-nota-fis :

        assign c-productlineitem = addelement(c-productlineitemcollection,"ProductLineItem")
                 c-campo = addelechar(c-productlineitem,"LegacyProductIdentifier",tt-it-nota-fisc.it-codigo)
                 c-campo = addelechar(c-productlineitem,"LegacyProductReference",tt-it-nota-fisc.cod-refer)
                 c-campo = addeleint(c-productlineitem,"DeliveryNumber",tt-it-nota-fisc.nr-entrega)
                 c-campo = addelechar(c-productlineitem,"ProductDescription",tt-it-nota-fisc.desc-item)
                 c-campo = addelechar(c-productlineitem,"PriceTable",tt-it-nota-fisc.nr-tabpre)
                 c-orderattendance = addelement(c-productlineitem,"OrderAttendance")
                   c-poattendancecollection = addelement(c-orderattendance,"POAttendanceCollection")
                     c-poattendance = addelement(c-poattendancecollection,"POAttendance")
                       c-campo = addelechar(c-poattendance,"PONumber",tt-it-nota-fisc.cod-ord-compra)
                       c-campo = addeleint(c-poattendance,"POParcelNumber",tt-it-nota-fisc.parcela)
                       c-pofulfilledquantity = addelement(c-poattendance,"POFulfilledQuantity")
                         c-quantityamount = addelement(c-pofulfilledquantity,"QuantityAmount")
                           c-campo = replace(string(tt-it-nota-fisc.qt-faturada[1]), ",", ".")
                           c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                           c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1])
                   c-soattendancecollection = addelement(c-orderattendance,"SOAttendanceCollection")
                     c-soattendance = addelement(c-soattendancecollection,"SOAttendance")
                       c-campo = addeleint(c-soattendance,"SOIdentifier",tt-it-nota-fisc.nr-pedido)
                       c-campo = addelechar(c-soattendance,"SONumber",tt-it-nota-fisc.nr-pedcli)
                       c-campo = addeleint(c-soattendance,"SOParcelNumber",tt-it-nota-fisc.nr-seq-ped)
                       c-sofulfilledquantity = addelement(c-soattendance,"SOFulfilledQuantity")
                         c-quantityamount = addelement(c-sofulfilledquantity,"QuantityAmount")
                           c-campo = replace(string(tt-it-nota-fisc.qt-faturada[1]), ",", ".")
                           c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                           c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1])
                 c-campo = addeleint(c-productlineitem,"ItemNumber",tt-it-nota-fisc.nr-seq-fat).

        if  tt-it-nota-fisc.narrativa <> "" then
            assign c-campo = addelechar(c-productlineitem,"ProductDetailing",tt-it-nota-fisc.narrativa).

        assign c-campo = addelechar(c-productlineitem,"FiscalOperation",tt-it-nota-fisc.nat-operacao)
               c-campo = addelechar(c-productlineitem,"FiscalClassification",tt-it-nota-fisc.class-fiscal)
               c-campo = addelechar(c-productlineitem,"UseStatistical",IF tt-it-nota-fisc.atual-estat THEN "True" ELSE "False")
               c-productquantity = addelement(c-productlineitem,"ProductQuantity")
                 c-quantityamount  = addelement(c-productquantity,"QuantityAmount")
                   c-campo = replace(string(tt-it-nota-fisc.qt-faturada[1]), ",", ".")
                   c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                   c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1])
               c-invoiceitemvaluecollection = addelement(c-productlineitem,"InvoiceItemValueCollection").

        find first tt-fat-ser-lote
             where tt-fat-ser-lote.cod-estabel = tt-it-nota-fisc.cod-estabel
             and   tt-fat-ser-lote.serie       = tt-it-nota-fisc.serie
             and   tt-fat-ser-lote.nr-nota-fis = tt-it-nota-fisc.nr-nota-fis
             and   tt-fat-ser-lote.nr-seq-fat  = tt-it-nota-fisc.nr-seq-fat
             no-lock no-error.

        if  avail tt-fat-ser-lote then
            assign c-itemlotcollection = addelement(c-productlineitem,"ItemLotCollection").

        find first tt-it-beneficiado
             where tt-it-beneficiado.cod-estabel = tt-it-nota-fisc.cod-estabel
             and   tt-it-beneficiado.serie       = it-nota-fisc.serie
             and   tt-it-beneficiado.nr-nota-fis = it-nota-fisc.nr-nota-fis
             and   tt-it-beneficiado.nr-seq-fat  = it-nota-fisc.nr-seq-fat
             and   tt-it-beneficiado.it-codigo   = it-nota-fisc.it-codigo
             no-lock no-error.

        if  avail tt-it-beneficiado then do:
            assign c-associatedinvoiceitems = addelement(c-productlineitem,"AssociatedInvoiceItems").
            if  tt-it-beneficiado.narrativa <> "" then
                assign c-iteminstructions = addelement(c-productlineitem,"ItemInstructions").
        end.

        assign c-itemnetweight = addelement(c-productlineitem,"ItemNetWeight")
                 c-quantityamount = addelement(c-itemnetweight,"QuantityAmount")
                   c-campo = replace(string(tt-it-nota-fisc.peso-liq-fat), ",", ".")
                   c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                   c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure", "KG")
               c-itemgrossweight = addelement(c-productlineitem,"ItemGrossWeight")
                 c-quantityamount =  addelement(c-itemgrossweight,"QuantityAmount")
                   c-campo = replace(string(tt-it-nota-fisc.peso-bruto), ",", ".")
                   c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                   c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure", "KG").

       run pi-gera-val-items(input c-invoiceitemvaluecollection).
       run pi-gera-lotes(input c-itemlotcollection).
       run pi-gera-item-associado(input c-associatedinvoiceitems, input c-iteminstructions).
    end.
end procedure.

procedure pi-gera-embal:
    def var c-totalnetweight    as char.
    def var c-totalgrossweight  as char.
    def var c-quantityamount    as char.
    def var c-packagecollection as char.
    def var c-package           as char.
    def var c-volumesquantity   as char.
    def var c-volume            as char.

    assign c-totalnetweight = addelement(c-packaginginformation,"TotalNetWeight")
             c-quantityamount = addelement(c-totalnetweight,"QuantityAmount")
               c-campo = replace(string(tt-nota-fiscal.peso-liq-tot), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure","KG")
           c-totalgrossweight = addelement(c-packaginginformation,"TotalGrossWeight")
             c-quantityamount = addelement(c-totalgrossweight,"QuantityAmount")
               c-campo = replace(string(tt-nota-fiscal.peso-bru-tot), ",", ".")
               c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
               c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure","KG").

    find first tt-nota-embal
         where tt-nota-embal.cod-estabel = tt-nota-fiscal.cod-estabel
         and   tt-nota-embal.serie       = tt-nota-fiscal.serie
         and   tt-nota-embal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis
         no-lock no-error.

    if  avail tt-nota-embal then
        assign c-packagecollection = addelement(c-packaginginformation,"PackageCollection").

    for each  tt-nota-embal no-lock
        where tt-nota-embal.cod-estabel = tt-nota-fiscal.cod-estabel
        and   tt-nota-embal.serie       = tt-nota-fiscal.serie
        and   tt-nota-embal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis:
        assign c-package  = addelement(c-packagecollection,"Package")
                 c-volumesquantity = addelement(c-package,"VolumesQuantity")
                   c-quantityamount = addelement(c-volumesquantity,"QuantityAmount")
                     c-campo = addeleint(c-quantityamount,"Quantity",tt-nota-embal.qt-volumes)
                     c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-nota-embal.sigla-emb)
                 c-volume = addelement(c-package,"Volume")
                   c-quantityamount = addelement(c-volume,"QuantityAmount")
                     c-campo = replace(string(tt-nota-embal.volume), ",", ".")
                     c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                     c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure","m3").

        if  tt-nota-embal.desc-vol <> "" then
            assign c-campo = addelechar(c-package,"PackageIdentification",tt-nota-embal.desc-vol).
    end.
end procedure.

procedure pi-gera-val-invoice:
    def var c-invoicevalue   as char.
    def var c-monetaryamount as char.

    for each  tt-val-nota NO-LOCK
        where tt-val-nota.cod-estabel = tt-nota-fiscal.cod-estabel
        and   tt-val-nota.serie       = tt-nota-fiscal.serie
        and   tt-val-nota.nr-nota-fis = tt-nota-fiscal.nr-nota-fis:
        assign c-invoicevalue = addelement(c-invoicevaluecollection,"InvoiceValue")
                 c-campo = addelechar(c-invoicevalue,"ValueIdentifier", tt-val-nota.ind-tip-val).

        if  tt-val-nota.de-perc > 0 then
            assign c-campo = replace(string(tt-val-nota.de-perc), ",", ".")
                   c-campo = addelechar(c-invoicevalue,"Percent",c-campo).
        else
            assign c-monetaryamount = addelement(c-invoicevalue,"MonetaryAmount")
                     c-campo = replace(string(tt-val-nota.de-valor), ",", ".")
                     c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
                     c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode",tt-val-nota.mo-codigo).
    end.
end procedure.

procedure pi-gera-val-items:
    def input param p-invoiceitemvaluecollection as char.

    def var c-invoiceitemvalue as char.
    def var c-monetaryamount   as char.

    for each  tt-val-item NO-LOCK
        where tt-val-item.cod-estabel = tt-it-nota-fisc.cod-estabel
        and   tt-val-item.serie       = tt-it-nota-fisc.serie
        and   tt-val-item.nr-nota-fis = tt-it-nota-fisc.nr-nota-fis
        and   tt-val-item.nr-seq-fat  = tt-it-nota-fisc.nr-seq-fat
        and   tt-val-item.it-codigo   = tt-it-nota-fisc.it-codigo:
        assign c-invoiceitemvalue = addelement(p-invoiceitemvaluecollection,"InvoiceItemValue")
                 c-campo = addelechar(c-invoiceitemvalue,"ValueIdentifier", tt-val-item.ind-tip-val).

        if  tt-val-item.de-perc > 0 then
            assign c-campo = replace(string(tt-val-item.de-perc), ",", ".")
                   c-campo = addelechar(c-invoiceitemvalue,"Percent",c-campo).
        else
            assign c-monetaryamount = addelement(c-invoiceitemvalue,"MonetaryAmount")
                     c-campo = replace(string(tt-val-item.de-valor), ",", ".")
                     c-campo = addelechar(c-monetaryamount,"Amount",c-campo)
                     c-campo = addelechar(c-monetaryamount,"LegacyCurrencyCode", tt-val-item.mo-codigo).
    end.
end procedure.

procedure pi-gera-lotes:
    def input param p-itemlotcollection as char.

    def var c-itemlot        as char.
    def var c-quantityamount as char.

    for each  tt-fat-ser-lote no-lock
        where tt-fat-ser-lote.cod-estabel = tt-it-nota-fisc.cod-estabel
        and   tt-fat-ser-lote.serie       = tt-it-nota-fisc.serie
        and   tt-fat-ser-lote.nr-nota-fis = tt-it-nota-fisc.nr-nota-fis
        and   tt-fat-ser-lote.nr-seq-fat  = tt-it-nota-fisc.nr-seq-fat:

        assign c-itemlot = addelement(p-itemlotcollection,"ItemLot")
                 c-campo = addelechar(c-itemlot,"LotNumber", tt-fat-ser-lote.nr-serlote)
                 c-campo = addeledate(c-itemlot,"ValidityDate",tt-fat-ser-lote.dt-validade,"")
                 c-quantityamount = addelement(c-itemlot,"QuantityAmount")
                   c-campo = replace(string(tt-fat-ser-lote.qt-baixada[1]), ",", ".")
                   c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                   c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-nota-fisc.un-fatur[1]).
    end.
end procedure.

procedure pi-gera-item-associado:
    def input param p-associatedinvoiceitems as char.
    def input param p-iteminstructions       as char.

    def var c-invoiceitemidentifiercollect as char. /* nome de variavel nao pode ultrapassar 32 caracteres */
    def var c-invoiceitemidentifier        as char.
    def var c-quantityamount               as char.
    def var c-instructioncollection        as char.

    if  avail tt-it-beneficiado then do:
        assign c-invoiceitemidentifiercollect = addelement(p-associatedinvoiceitems,"InvoiceItemIdentifierCollection")
                 c-invoiceitemidentifier = addelement(c-invoiceitemidentifiercollect,"InvoiceItemIdentifier")
                   c-campo = addelechar(c-invoiceitemidentifier,"SerialNumber",tt-it-beneficiado.serie)
                   c-campo = addelechar(c-invoiceitemidentifier,"InvoiceNumber",tt-it-beneficiado.nr-nota-fis)
                   c-campo = addeleint(c-invoiceitemidentifier,"ItemNumber",tt-it-beneficiado.nr-seq-fat)
                   c-campo = addelechar(c-invoiceitemidentifier,"LegacyProductIdentifier",tt-it-beneficiado.it-codigo)
                   c-campo = addelechar(c-invoiceitemidentifier,"LegacyProductReference",tt-it-beneficiado.cod-refer)
                   c-campo = addelechar(c-invoiceitemidentifier,"DrawerRole","INVOICER")
                   c-campo = addelechar(c-invoiceitemidentifier,"AddresseeRole","RECEIVER")
                   c-quantityamount = addelement(c-invoiceitemidentifier,"QuantityAmount")
                     c-campo = replace(string(tt-it-beneficiado.qt-item), ",", ".")
                     c-campo = addelechar(c-quantityamount,"Quantity",c-campo)
                     c-campo = addelechar(c-quantityamount,"LegacyUnitOfMeasure",tt-it-beneficiado.un).

       if  tt-it-beneficiado.narrativa <> "" then
           assign c-instructioncollection = addelement(p-iteminstructions,"InstructionCollection")
                    c-campo = addelechar(c-instructioncollection,"Instruction",tt-it-beneficiado.narrativa).
    end.
end procedure.
