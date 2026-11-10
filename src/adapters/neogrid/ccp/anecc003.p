/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANECC003 2.00.00.011} /*** "010011" 20/01/2025 15:16:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anecc003 MAN}
&ENDIF

/********************************************************************************
** Programa : anecc003.p
** Fun‡Æo   : Sender de Pedido de Compra
** Data     : 07/2000
** Autor    : Jean Renato Kormann/Sven Siegfried Imfeld
********************************************************************************/
{adapters/neogrid/include/anein004.i}
{cdp/cdcfgdis.i}
{ccp/cc0305d.i}

DEF INPUT PARAMETER TABLE FOR tt-pedido-compr.
DEF INPUT PARAMETER TABLE FOR tt-cond-especif.
DEF INPUT PARAMETER TABLE FOR tt-ordem-compra.
DEF INPUT PARAMETER TABLE FOR tt-despesas-ordem.
DEF INPUT PARAMETER TABLE FOR tt-prazo-compra.

DEF VAR c-root                   AS CHAR NO-UNDO.
DEF VAR c-campo                  AS CHAR NO-UNDO.
DEF VAR c-campo-aux              AS CHAR NO-UNDO.
DEF VAR c-message                AS CHAR NO-UNDO.
DEF VAR c-orderupdate            AS CHAR NO-UNDO.
DEF VAR c-order                  AS CHAR NO-UNDO.
DEF VAR c-paymentplan            AS CHAR NO-UNDO.
DEF VAR c-paymentcollection      AS CHAR NO-UNDO.
DEF VAR c-payment                AS CHAR NO-UNDO.
DEF VAR c-monetaryamount-payment AS CHAR NO-UNDO.
DEF VAR c-creditcardcollection   AS CHAR NO-UNDO.
DEF VAR i-quantidade             LIKE prazo-compra.quantidade NO-UNDO.
DEF VAR i-quant-saldo            LIKE prazo-compra.quantidade NO-UNDO.
DEF VAR de-preco-unit            LIKE ordem-compra.preco-unit DECIMALS 4 NO-UNDO.
DEF VAR de-total                 AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99" INIT 0 NO-UNDO.

FIND FIRST tt-prazo-compra NO-LOCK NO-ERROR.
IF NOT AVAIL tt-prazo-compra THEN 
    RETURN.

RUN pi-cria-pedido.

PROCEDURE pi-cria-pedido.
    FOR EACH tt-pedido-compr NO-LOCK:

        ASSIGN c-root = CreateNeoGridDoc("OrderUpdate","1.01.001",tt-pedido-compr.cod-estabel-orig).
        RUN pi-cria-cabecalho-pedido.
        RUN pi-cria-itens.
        RUN pi-cria-detalhes-pedido.
    END.
    WriteXML().
END.

PROCEDURE pi-cria-cabecalho-pedido.
    ASSIGN c-message = AddElement(c-root,"Message")
           c-orderupdate = AddElement(c-message,"OrderUpdate")
           c-campo = AddEleChar(c-orderupdate,"GlobalOrderChangeCode",tt-pedido-compr.changecode) 
           c-order = AddElement(c-orderupdate,"Order")
           c-campo = AddEleInt(c-order,"OrderIdentifier",tt-pedido-compr.num-pedido).

    IF tt-pedido-compr.comentarios  <> "" THEN 
        ASSIGN c-campo = AddEleChar(c-order,"Comment",tt-pedido-compr.comentarios ).

    ASSIGN c-campo = AddEleChar(c-order,"OrderTypeCode", IF ped-venda.tp-pedido <> "" THEN ped-venda.tp-pedido ELSE "1")
           c-paymentplan = AddElement(c-order,"PaymentPlan")
           c-campo = AddEleInt(c-paymentplan,"PaymentCode",tt-pedido-compr.cod-cond-pag).

    FIND FIRST tt-cond-especif NO-LOCK NO-ERROR.
    IF AVAIL tt-cond-especif THEN 
        ASSIGN c-paymentcollection = AddElement(c-paymentplan,"PaymentCollection").
    /*
    for each  tt-cond-especif no-lock
        where tt-cond-especif.num-pedido = tt-pedido-compr.num-pedido:
        assign
        c-payment  = AddElement(c-paymentcollection,"Payment")
           c-campo = AddEleDate(c-payment,"DueDate",tt-cond-especif.data-pagto,"").
           if  tt-cond-especif.perc-pagto > 0 then do:
               &if  "{&BF_DIS_VERSAO_EMS}" >= "2.04" &then
                    assign c-campo-aux = replace(string(tt-cond-especif.perc-pagto), ",", ".")
                           c-campo     = AddEleChar(c-payment,"Percent",c-campo-aux).
               &else
                   assign c-campo = AddEleInt(c-payment,"Percent",tt-cond-especif.perc-pagto).
               &endif
           end.
           else
               assign
               c-monetaryamount-payment = AddElement(c-payment,"MonetaryAmount")
                  c-campo-aux = replace(string(tt-cond-especif.valor-parcela), ",", ".")
                  c-campo     = AddEleChar(c-monetaryamount-payment,"Amount",c-campo-aux)
                  c-campo     = AddEleChar(c-monetaryamount-payment,"LegacyCurrencyCode","").
    end.
    */
END.

PROCEDURE pi-cria-itens.
    DEF VAR c-productlineitemcollection AS CHAR NO-UNDO.
    DEF VAR c-productlineitem           AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount-item       AS CHAR NO-UNDO.
    DEF VAR c-productshipcollection     AS CHAR NO-UNDO.
    DEF VAR c-productship               AS CHAR NO-UNDO.
    DEF VAR c-quantityamount            AS CHAR NO-UNDO.
    DEF VAR c-deliveryto                AS CHAR NO-UNDO.
    DEF VAR c-physicaladdress-ent       AS CHAR NO-UNDO. /* endereco de entrega */
    DEF VAR c-address-ent               AS CHAR NO-UNDO.
    DEF VAR c-quotecollection           AS CHAR NO-UNDO.
    DEF VAR c-quote                     AS CHAR NO-UNDO.
    DEF VAR c-carrierinformation        AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-transp AS CHAR NO-UNDO. /* contato do transportador */
    DEF VAR c-occollection              AS CHAR NO-UNDO.
    DEF VAR c-oc                        AS CHAR NO-UNDO.
    DEF VAR c-orderitemvaluecollection  AS CHAR NO-UNDO.
    DEF VAR c-orderitemvalue            AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount-orderitem  AS CHAR NO-UNDO.
    DEF VAR de-qt-ordem                 AS DEC  NO-UNDO.
    DEF VAR de-qt-do-forn               AS DEC  NO-UNDO.
    DEF VAR de-conver                   AS DEC  NO-UNDO.
    DEF VAR de-preco-unit               AS DEC  NO-UNDO.
    
    ASSIGN c-productlineitemcollection = AddElement(c-order,"ProductLineItemCollection")
           de-total = 0.
    
    FOR EACH tt-ordem-compra NO-LOCK 
        WHERE tt-ordem-compra.num-pedido = tt-pedido-compr.num-pedido:

        FIND FIRST tt-prazo-compra NO-LOCK 
            WHERE tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
        IF NOT AVAIL tt-prazo-compra THEN NEXT.

        ASSIGN c-productlineitem = AddElement(c-productlineitemcollection,"ProductLineItem")
               c-campo = AddEleChar(c-productlineitem,"POSequentialIdentification","")
               c-campo = AddEleChar(c-productlineitem,"LegacyProductIdentifier",tt-ordem-compra.it-codigo)
               c-campo = AddEleChar(c-productlineitem,"ProductDescription",tt-ordem-compra.descricao).

           IF tt-ordem-compra.referencia <> "" THEN 
               ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyProductReference",tt-ordem-compra.referencia).
               
        FOR FIRST tt-despesas-ordem NO-LOCK 
           WHERE tt-despesas-ordem.numero-ordem = tt-ordem-compra.numero-ordem
             AND tt-despesas-ordem.desc-despesa = "28" :
           FIND item-fornec 
               WHERE item-fornec.cod-emitente = tt-pedido-compr.cod-emitente-dest			   
                 AND item-fornec.it-codigo    = tt-ordem-compra.it-codigo   
                 AND item-fornec.ativo NO-LOCK NO-ERROR.
            IF AVAIL item-fornec THEN DO:
               FOR EACH tt-prazo-compra NO-LOCK 
                    WHERE tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:
                   ASSIGN de-qt-ordem = de-qt-ordem +  tt-prazo-compra.quantidade.
               END.
               ASSIGN de-conver = (1 / (exp(10,item-fornec.num-casa-dec))) * item-fornec.fator-conver.
               ASSIGN de-qt-do-forn  = de-qt-ordem * de-conver.       
               ASSIGN de-preco-unit  =  (tt-despesas-ordem.vl-despesa * de-qt-do-forn) / de-qt-ordem.
               ASSIGN tt-despesas-ordem.vl-despesa  = de-preco-unit.
            END.
           /*assign
           c-monetaryamount-item = AddElement(c-productlineitem,"MonetaryAmount")
              c-campo-aux = replace(string(de-preco-unit), ",", ".")
              c-campo     = AddEleChar(c-monetaryamount-item,"Amount",c-campo-aux)
              c-campo     = AddEleInt(c-monetaryamount-item,"LegacyCurrencyCode",tt-ordem-compra.mo-codigo)
              tt-despesas-ordem.vl-despesa  = de-preco-unit.*/                                              
        END.
        
        c-productshipcollection = AddElement(c-productlineitem,"ProductShipCollection").
        FOR EACH tt-prazo-compra NO-LOCK 
            WHERE tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:

         /* FOI ASSUMIDO QUE, ASSIM COMO O CC0305 SEMPRE IMPRIME OS PEDIDOS EM MOEDA CORRENTE, NO XML
            TAMBEM O VALOR DO PEDIDO IRA EM MOEDA CORRENTE. */
            IF tt-ordem-compra.mo-codigo = 0 THEN 
                ASSIGN de-preco-unit = tt-ordem-compra.preco-unit.
            ELSE 
                RUN "cdp/cd0812.p" (INPUT tt-ordem-compra.mo-codigo,
                                    INPUT 0,  /* moeda para conversao */
                                    INPUT tt-ordem-compra.preco-unit,
                                    INPUT TODAY,
                                    OUTPUT de-preco-unit).

            IF de-preco-unit = ? THEN 
                ASSIGN de-preco-unit = 0.

            ASSIGN de-total = de-total + tt-prazo-compra.quantidade * de-preco-unit.

            ASSIGN c-productship = AddElement(c-productshipcollection,"ProductShip")
                   c-campo       = AddEleInt(c-productship,"LegacyLocationIdentifier",tt-prazo-compra.cod-fornec-embarque)
                   c-campo       = AddEleDate(c-productship,"RequestDeliveryDate",tt-prazo-compra.data-entrega,"")
                   c-campo       = AddEleChar(c-productship,"LegacyShipmentTermsCode",IF tt-prazo-compra.frete = "CIF" THEN "FOB" ELSE "CIF")
                   c-campo       = AddEleInt(c-productship,"LegacyShippingMethodCode",tt-prazo-compra.via-transp).
            IF tt-prazo-compra.narrativa <> "" THEN 
                ASSIGN c-campo = AddEleChar(c-productlineitem,"ProductDetailing",tt-prazo-compra.narrativa).
            
            FIND prazo-compra NO-LOCK
                 WHERE prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                   AND prazo-compra.parcela      = tt-prazo-compra.parcela NO-ERROR.
            
            ASSIGN i-quant-saldo = prazo-compra.quant-saldo NO-ERROR.

            ASSIGN i-quantidade     = tt-prazo-compra.quantidade
                   c-quantityamount = AddElement(c-productship,"QuantityAmount")
                   c-campo-aux      = REPLACE(STRING(i-quantidade), ",", ".")
                   c-campo          = AddEleChar(c-quantityamount,"Quantity",c-campo-aux)
                   c-campo          = AddEleChar(c-quantityamount,"LegacyUnitOfMeasure",tt-prazo-compra.un)
                   c-quantityamount = AddElement(c-productship,"BackOrderQuantity")
                   c-campo-aux      = REPLACE(STRING(i-quant-saldo), ",", ".")
                   c-campo          = AddEleChar(c-quantityamount,"Quantity",c-campo-aux)
                   c-campo          = AddEleChar(c-quantityamount,"LegacyUnitOfMeasure",tt-prazo-compra.un)
                   c-deliveryto     = AddElement(c-productship,"DeliveryTo")
                   c-physicaladdress-ent = AddElement(c-deliveryto,"PhysicalAddress")
                   c-campo          = AddEleChar(c-physicaladdress-ent,"LegacyLocationIdentifier",tt-prazo-compra.cod-estabel-ent)
                   c-address-ent    = AddElement(c-physicaladdress-ent,"Address")
                   c-campo          = AddEleChar(c-address-ent,"AddressLine1",tt-prazo-compra.endereco1-ent)
                   c-campo          = AddEleChar(c-address-ent,"CityName",tt-prazo-compra.cidade-ent)
                   c-campo          = AddEleChar(c-address-ent,"DistrictName",tt-prazo-compra.bairro-ent)
                   c-campo          = AddEleChar(c-address-ent,"StateCode",tt-prazo-compra.estado-ent)
                   c-campo          = AddEleInt(c-address-ent,"NationalPostalCode",tt-prazo-compra.cep-ent)
                   c-campo          = AddEleChar(c-address-ent,"LegacyCountryCode",tt-prazo-compra.pais-ent)
                   c-campo          = AddEleChar(c-address-ent,"AddressCode","").

            IF tt-prazo-compra.nr-requisicao <> 0 THEN 
                ASSIGN c-quotecollection = AddElement(c-productship,"QuoteCollection")
                         c-quote = AddElement(c-quotecollection,"Quote")
                         c-campo = AddEleInt(c-quote,"QuoteIdentifier",tt-prazo-compra.nr-requisicao).

            ASSIGN c-carrierinformation = AddElement(c-productship,"CarrierInformation")
                   c-campo = AddEleInt(c-carrierinformation,"LegacyLocationIdentifier",tt-prazo-compra.cod-transp)
                   c-campo = AddEleChar(c-carrierinformation,"CarrierName",tt-prazo-compra.nome-transp).

            IF tt-prazo-compra.contato-transp <> "" THEN 
                ASSIGN c-contactinformation-transp = AddElement(c-carrierinformation,"ContactInformation")
                       c-campo = AddEleChar(c-contactinformation-transp,"ContactName",tt-prazo-compra.contato-transp)
                       c-campo = AddEleChar(c-contactinformation-transp,"EmailAddress",tt-prazo-compra.e-mail-transp)
                       c-campo = AddEleChar(c-contactinformation-transp,"TelephoneNumber",tt-prazo-compra.telefone-transp).

            ASSIGN c-occollection = AddElement(c-productship,"OCCollection")
                   c-oc = AddElement(c-occollection,"OC")
                   c-campo = AddEleInt(c-oc,"OCIdentifier",tt-prazo-compra.numero-ordem)
                   c-campo = AddEleInt(c-oc,"OCParcel",tt-prazo-compra.parcela).
        END.

        ASSIGN c-orderitemvaluecollection = AddElement(c-productlineitem,"OrderItemValueCollection").

        FOR EACH tt-despesas-ordem NO-LOCK 
            WHERE tt-despesas-ordem.numero-ordem = tt-ordem-compra.numero-ordem:
            ASSIGN c-orderitemvalue = AddElement(c-orderitemvaluecollection,"OrderItemValue")
                   c-campo          = AddEleChar(c-orderitemvalue,"ValuesIdentifier",tt-despesas-ordem.desc-despesa).
               
               IF tt-despesas-ordem.perc-despesa > 0 THEN 
                   ASSIGN c-campo-aux = REPLACE(STRING(tt-despesas-ordem.perc-despesa), ",", ".")
                          c-campo     = AddEleChar(c-orderitemvalue,"Percent",c-campo-aux).
               ELSE 
                   ASSIGN c-monetaryamount-orderitem = AddElement(c-orderitemvalue,"MonetaryAmount")
                          c-campo-aux = REPLACE(STRING(tt-despesas-ordem.vl-despesa), ",", ".")
                          c-campo     = AddEleChar(c-monetaryamount-orderitem,"Amount",c-campo-aux)
                          c-campo     = AddEleInt(c-monetaryamount-orderitem,"LegacyCurrencyCode",tt-despesas-ordem.moeda-despesa).
        END.
        FOR FIRST ordem-compra FIELDS(codigo-ipi)
             WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK:
            ASSIGN c-Campo = AddElechar(c-productlineitem,"IPIIncluded",STRING(ordem-compra.codigo-ipi,"true/false")).
        END.
        ASSIGN c-Campo = AddElechar(c-productlineitem,"ICMSIncluded","true").
    END.
END.

PROCEDURE pi-cria-detalhes-pedido.
    DEF VAR c-billto                    AS CHAR NO-UNDO.
    DEF VAR c-physicaladdress-cob       AS CHAR NO-UNDO. /*endereco de cobranca*/
    DEF VAR c-address-cob               AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-cob    AS CHAR NO-UNDO. /*contato do endereco de cobranca*/
    DEF VAR c-ordervaluecollection      AS CHAR NO-UNDO.
    DEF VAR c-ordervalue                AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount-ordervalue AS CHAR NO-UNDO.
    DEF VAR c-fromrole                  AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-orig   AS CHAR NO-UNDO. /*contato de quem originou o pedido*/
    DEF VAR c-address-orig              AS CHAR NO-UNDO. /*endereco de quem originou o pedido*/
    DEF VAR c-torole                    AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-dest   AS CHAR NO-UNDO. /*contato de quem recebera o pedido (destino)*/
    DEF VAR c-address-dest              AS CHAR NO-UNDO. /*endereco de quem recebera o pedido (destino)*/

    ASSIGN c-billto = AddElement(c-order,"BillTo")
           c-physicaladdress-cob = AddElement(c-billto,"PhysicalAddress")
           c-campo = AddEleChar(c-physicaladdress-cob,"LegacyLocationIdentifier",tt-pedido-compr.cod-estabel-cob)
           c-address-cob = AddElement(c-physicaladdress-cob,"Address")
           c-campo = AddEleChar(c-address-cob,"AddressLine1",tt-pedido-compr.endereco1-cob)
           c-campo = AddEleChar(c-address-cob,"CityName",tt-pedido-compr.cidade-cob)
           c-campo = AddEleChar(c-address-cob,"DistrictName",tt-pedido-compr.bairro-cob)
           c-campo = AddEleChar(c-address-cob,"StateCode",tt-pedido-compr.estado-cob)
           c-campo = AddEleInt(c-address-cob,"NationalPostalCode",tt-pedido-compr.cep-cob)
           c-campo = AddEleChar(c-address-cob,"LegacyCountryCode",tt-pedido-compr.pais-cob)
           c-contactinformation-cob = AddElement(c-billto,"ContactInformation")
           c-campo  = AddEleChar(c-contactinformation-cob,"ContactName",tt-pedido-compr.contato-cob)
           c-campo  = AddEleChar(c-contactinformation-cob,"EmailAddress",tt-pedido-compr.e-mail-cob)
           c-campo  = AddEleChar(c-contactinformation-cob,"TelephoneNumber",tt-pedido-compr.telefone-cob)
           c-ordervaluecollection = AddElement(c-order,"OrderValueCollection")
           c-ordervalue = AddElement(c-ordervaluecollection,"OrderValue")
           c-campo   = AddEleChar(c-ordervalue,"ValuesIdentifier","26")  /*Total do Pedido*/
           c-monetaryamount-ordervalue = AddElement(c-ordervalue,"MonetaryAmount")
           c-campo-aux = REPLACE(STRING(de-total), ",", ".")
           c-campo     = AddEleChar(c-monetaryamount-ordervalue,"Amount",c-campo-aux)
           c-campo     = AddEleChar(c-monetaryamount-ordervalue,"LegacyCurrencyCode","0").
    
    ASSIGN c-fromrole = AddElement(c-orderupdate,"FromRole")
           c-campo = AddEleChar(c-fromrole,"LegacyLocationIdentifier",tt-pedido-compr.cod-estabel-orig)
           c-campo = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","BUYER")
           c-contactinformation-orig = AddElement(c-fromrole,"ContactInformation")
           c-campo = AddEleChar(c-contactinformation-orig,"ContactName",tt-pedido-compr.contato-orig)
           c-campo = AddEleChar(c-contactinformation-orig,"EmailAddress",tt-pedido-compr.e-mail-orig)
           c-campo = AddEleChar(c-contactinformation-orig,"TelephoneNumber",tt-pedido-compr.telefone-orig)
           c-address-orig = AddElement(c-fromrole,"Address")
           c-campo = AddEleChar(c-address-orig,"AddressLine1",tt-pedido-compr.endereco1-orig)
           c-campo = AddEleChar(c-address-orig,"CityName",tt-pedido-compr.cidade-orig)
           c-campo = AddEleChar(c-address-orig,"DistrictName",tt-pedido-compr.bairro-orig)
           c-campo = AddEleChar(c-address-orig,"StateCode",tt-pedido-compr.estado-orig)
           c-campo = AddEleInt(c-address-orig,"NationalPostalCode",tt-pedido-compr.cep-orig)
           c-campo = AddEleChar(c-address-orig,"LegacyCountryCode",tt-pedido-compr.pais-orig)
           c-torole = AddElement(c-orderupdate,"ToRole")
           c-campo = AddEleInt(c-torole,"LegacyLocationIdentifier",tt-pedido-compr.cod-emitente-dest)
           c-campo = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","SELLER").
END.



