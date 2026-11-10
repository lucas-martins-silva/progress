/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD004 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd004 MAN}
&ENDIF

/********************************************************************************
** Programa : anepd004.p
** Funcao   : Sender de Inclusao/Alteracao do Pedido de Venda
** Data     : 06/2001
** Autor    : Sven Siegfried Imfeld
** VersÆo   : 30/01/2007 - Anderson Silvano
********************************************************************************/

{adapters/neogrid/include/anein004.i}
{cdp/cdcfgdis.i}

DEF INPUT PARAMETER r-ped-venda AS ROWID NO-UNDO.
DEF INPUT PARAMETER changecode  AS CHAR  NO-UNDO.

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

DEF VAR de-total                 AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99" INIT 0 NO-UNDO.
DEF VAR de-preco-unit            AS DECIMAL DECIMALS 4                      INIT 0 NO-UNDO.

FIND ped-venda 
    WHERE ROWID(ped-venda) = r-ped-venda NO-LOCK NO-ERROR.

IF NOT AVAIL ped-venda THEN
    RETURN.

FIND emitente 
    WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

&IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
    IF SUBSTR(emitente.char-1,11,1) <> "1" THEN NEXT.
&ELSE
    FOR FIRST dist-emitente FIELDS (cod-emitente)
        WHERE dist-emitente.cod-emitente = emitente.cod-emitente
        AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
    END.
    IF NOT AVAIL dist-emitente THEN NEXT.
&ENDIF

ASSIGN c-root = CreateNeoGridDoc("SalesOrder","1.01.001",ped-venda.cod-estabel).

RUN pi-cria-cabecalho-pedido.
RUN pi-cria-itens.
RUN pi-cria-detalhes-pedido.
WriteXML().

PROCEDURE pi-cria-cabecalho-pedido.
    DEF VAR c-sit-ped   AS CHAR NO-UNDO.
    DEF VAR c-tp-preco  AS CHAR NO-UNDO.
    DEF VAR c-sit-pre   AS CHAR NO-UNDO.
    DEF VAR c-sit-aval  AS CHAR NO-UNDO.
    DEF VAR c-sit-com   AS CHAR NO-UNDO.
    DEF VAR c-sit-preco AS CHAR NO-UNDO.
    
    ASSIGN c-message = AddElement(c-root,"Message")
           c-orderupdate = AddElement(c-message,"OrderUpdate")
           c-campo = AddEleChar(c-orderupdate,"GlobalOrderChangeCode",changecode) 
           c-order = AddElement(c-orderupdate,"Order")
           c-campo = AddEleChar(c-order,"ANEPD004","")
           c-campo = AddEleChar(c-order,"OrderIdentifier",ped-venda.nr-pedcli).

    IF ped-venda.observacoes <> "" THEN 
        ASSIGN c-campo = AddEleChar(c-order,"Comment",ped-venda.observacoes).

    IF changecode = "DELETE":U THEN 
        ASSIGN c-sit-ped = "Eliminado":U.
    ELSE 
        ASSIGN c-sit-ped = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.

    ASSIGN c-campo = AddEleInt(c-order,"SOIdentifier",ped-venda.nr-pedido)
           c-campo = AddEleChar(c-order,"OrderTypeCode", IF ped-venda.tp-pedido <> "" THEN ped-venda.tp-pedido ELSE "6").

    FOR FIRST repres FIELDS(cod-rep) NO-LOCK 
        WHERE repres.nome-abrev  = ped-venda.no-ab-reppri:
        ASSIGN c-campo = AddEleInt(c-order,"SalesRepresentative",repres.cod-rep).
    END.

    ASSIGN c-campo = AddEleInt(c-order,"LegacyOrderStatusCode",1).
 
    FIND cond-pagto 
        WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
    IF ped-venda.nr-ind-finan <> 0 THEN
        FIND tab-finan
            WHERE tab-finan.nr-tab-finan = cond-pagto.nr-tab-finan
              AND tab-finan.dt-ini-val  <= TODAY 
              AND tab-finan.dt-fim-val  >= TODAY NO-LOCK NO-ERROR. 
    
    ASSIGN c-paymentplan = AddElement(c-order,"PaymentPlan")
           c-campo = AddEleInt(c-paymentplan,"PaymentCode",ped-venda.cod-cond-pag).

    FIND FIRST cond-ped 
        WHERE cond-ped.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

    IF AVAIL cond-ped THEN  
        ASSIGN c-paymentcollection = AddElement(c-paymentplan,"PaymentCollection").
    
    FOR EACH cond-ped NO-LOCK 
        WHERE cond-ped.nr-pedido = ped-venda.nr-pedido:
          
        ASSIGN c-payment = AddElement(c-paymentcollection,"Payment").
        IF cond-ped.data-pagto <> ? THEN 
            ASSIGN c-campo = AddEleDate(c-payment,"DueDate",cond-ped.data-pagto,"").
        ELSE 
            ASSIGN c-campo = AddEleInt(c-payment,"DueDays",cond-ped.nr-dias-venc).
          
        IF cond-ped.perc-pagto > 0 THEN DO:
            &IF  "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN  
                ASSIGN c-campo-aux = REPLACE(STRING(cond-ped.perc-pagto), ",", ".")
                       c-campo = AddEleChar(c-payment,"Percent",c-campo-aux).
            &ELSE 
                ASSIGN c-campo = AddEleInt(c-payment,"Percent",cond-ped.perc-pagto).
            &ENDIF
        END.
        ELSE 
            ASSIGN c-monetaryamount-payment = AddElement(c-payment,"MonetaryAmount")
                   c-campo-aux = REPLACE(STRING(cond-ped.vl-pagto), ",", ".")
                   c-campo = AddEleChar(c-monetaryamount-payment,"Amount",c-campo-aux)
                   c-campo = AddEleint(c-monetaryamount-payment,"LegacyCurrencyCode",ped-venda.mo-codigo).
    END.
END.

PROCEDURE pi-cria-itens.
    DEF VAR c-productlineitemcollection AS CHAR NO-UNDO.
    DEF VAR c-productlineitem           AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount-item       AS CHAR NO-UNDO.
    DEF VAR c-productshipcollection     AS CHAR NO-UNDO.
    DEF VAR c-productship               AS CHAR NO-UNDO.
    DEF VAR c-quantityamount            AS CHAR NO-UNDO.
    DEF VAR c-invoicedamount            AS CHAR NO-UNDO.
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
    DEF VAR c-MonetaryAmount            AS CHAR NO-UNDO.
    DEF VAR c-freighttype               AS CHAR NO-UNDO.
    DEF VAR i-freightmethod             as int  no-undo.
    DEF VAR c-endereco                  AS CHAR NO-UNDO.
    DEF VAR c-bairro                    AS CHAR NO-UNDO.
    DEF VAR c-cidade                    AS CHAR NO-UNDO.
    DEF VAR c-estado                    AS CHAR NO-UNDO.
    DEF VAR c-cep                       AS CHAR NO-UNDO.
    DEF VAR c-pais                      AS CHAR NO-UNDO.
    DEF VAR c-via-transp                AS CHAR NO-UNDO.
    DEF VAR c-sit-item                  AS CHAR NO-UNDO.
    DEF VAR c-sit-pre-it                AS CHAR NO-UNDO.
    DEF VAR c-sit-com-it                AS CHAR NO-UNDO.
    DEF VAR c-sit-preco-it              AS CHAR NO-UNDO.
    
    ASSIGN c-productlineitemcollection = AddElement(c-order,"ProductLineItemCollection")
           de-total      = 0
           c-freighttype = IF ped-venda.cidade-cif <> "" THEN "CIF"
                           ELSE "FOB".   
    
    FIND transporte 
        WHERE transporte.nome-abrev = ped-venda.nome-transp NO-LOCK NO-ERROR.

    FOR EACH ped-item NO-LOCK 
        WHERE ped-item.nome-abrev = ped-venda.nome-abrev
          AND ped-item.nr-pedcli  = ped-venda.nr-pedcli:
        
        FIND item 
            WHERE item.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
       
        FIND loc-entr
            WHERE loc-entr.nome-abrev  = ped-venda.nome-abrev
              AND loc-entr.cod-entrega = ped-item.cod-entrega NO-LOCK NO-ERROR.
        
        IF AVAIL loc-entr THEN 
            ASSIGN c-endereco = loc-entr.endereco
                   c-bairro   = loc-entr.bairro
                   c-cidade   = loc-entr.cidade
                   c-estado   = loc-entr.estado
                   c-cep      = loc-entr.cep
                   c-pais     = loc-entr.pais.
        ELSE 
            ASSIGN c-endereco = ped-venda.local-entreg
                   c-bairro   = ped-venda.bairro
                   c-cidade   = ped-venda.cidade
                   c-estado   = ped-venda.estado
                   c-cep      = ped-venda.cep
                   c-pais     = ped-venda.pais. 

        ASSIGN c-productlineitem = AddElement(c-productlineitemcollection,"ProductLineItem")
               c-campo = AddEleInt(c-productlineitem,"SOSequentialIdentification",ped-item.nr-sequencia).

        FOR FIRST emitente FIELDS(char-2)
            WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK:
        END.

        IF AVAIL ITEM THEN DO:
            IF SUBSTRING(emitente.char-2,50,5) = "YES" AND ITEM.codigo-refer <> "" THEN
                ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyProductIdentifier",ITEM.codigo-refer).
            ELSE
                ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyProductIdentifier",ped-item.it-codigo).
        END.
        ELSE
            ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyProductIdentifier",ped-item.it-codigo).

        ASSIGN c-campo = AddEleChar(c-productlineitem,"ProductDescription",ITEM.desc-item).
          
        IF ped-item.cod-refer <> "" THEN 
            ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyProductReference",ped-item.cod-refer).
               
        FOR EACH ped-ent  
            WHERE ped-ent.nr-pedcli    = ped-item.nr-pedcli
              AND ped-ent.it-codigo    = ped-item.it-codigo 
              AND ped-ent.cod-refer    = ped-item.cod-refer 
              AND ped-ent.nr-sequencia = ped-item.nr-sequencia
              AND ped-ent.nome-abrev   = ped-item.nome-abrev NO-LOCK:
            
         /* FOI ASSUMIDO QUE, ASSIM COMO O CC0305 SEMPRE IMPRIME OS PEDIDOS EM MOEDA CORRENTE, NO XML
            TAMBEM O VALOR DO PEDIDO IRA EM MOEDA CORRENTE. */
            IF ped-venda.mo-codigo = 0 THEN 
                ASSIGN de-preco-unit = ped-item.vl-preuni.
            ELSE 
                RUN "cdp/cd0812.p" (INPUT ped-venda.mo-codigo,
                                    INPUT 0,  /* moeda para conversao */
                                    INPUT ped-item.vl-preuni,
                                    INPUT TODAY,
                                    OUTPUT de-preco-unit).

            IF de-preco-unit = ? THEN 
                ASSIGN de-preco-unit = 0.

            ASSIGN de-total = de-total + ped-ent.qt-pedida * de-preco-unit
                   c-productshipcollection = AddElement(c-productlineitem,"ProductShipCollection")
                   c-productship = AddElement(c-productshipcollection,"ProductShip")
                   c-campo = AddEleChar(c-productship,"LegacyLocationIdentifier",ped-venda.cod-estabel)
                   c-campo = AddEleDate(c-productship,"RequestDeliveryDate",ped-item.dt-entrega,"").

            IF ped-item.cod-sit-item = 6 THEN
                ASSIGN c-campo = AddEleChar(c-productship,"LegacyOrderShipmentStatusCode","7").

            ASSIGN c-campo = AddEleChar(c-productship,"LegacyShipmentTermsCode",c-freighttype).

            IF AVAIL transporte THEN
                assign c-via-transp = STRING(transporte.via-transp) 
                       c-campo      = AddEleChar(c-productship,"LegacyShippingMethodCode",c-via-transp).
            
            IF ped-ent.observacao <> "" THEN 
                ASSIGN c-campo = AddEleChar(c-productship,"Comment",ped-ent.observacao).
                
            ASSIGN c-quantityamount = AddElement(c-productship,"QuantityAmount")
                   c-campo-aux = REPLACE(STRING(ped-ent.qt-pedida), ",", ".")
                   c-campo = AddEleChar(c-quantityamount,"Quantity",c-campo-aux)
                   c-campo = AddEleChar(c-quantityamount,"LegacyUnitOfMeasure",item.un)
                   c-deliveryto = AddElement(c-productship,"DeliveryTo")
                   c-physicaladdress-ent = AddElement(c-deliveryto,"PhysicalAddress")
                   c-campo = AddEleInt(c-physicaladdress-ent,"LegacyLocationIdentifier",ped-venda.cod-emitente).

            IF ped-venda.nr-ped-cot-orig <> "" THEN DO:
                ASSIGN c-quotecollection = AddElement(c-productship,"QuoteCollection")
                       c-quote = AddElement(c-quotecollection,"Quote")
                       c-campo = AddEleChar(c-quote,"QuoteIdentifier",ped-venda.nr-ped-cot-orig).
            END.
            ASSIGN c-carrierinformation = AddElement(c-productship,"CarrierInformation")
                   c-campo = AddEleInt(c-carrierinformation,"LegacyLocationIdentifier",IF AVAIL transporte THEN transporte.cod-transp ELSE 0)
                   c-campo = AddEleChar(c-carrierinformation,"CarrierName",ped-venda.nome-transp).

            IF AVAIL transporte AND transporte.contato <> "" THEN 
                ASSIGN c-contactinformation-transp = AddElement(c-carrierinformation,"ContactInformation")
                       c-campo = AddEleChar(c-contactinformation-transp,"ContactName",transporte.contato)
                       c-campo = AddEleChar(c-contactinformation-transp,"TelephoneNumber",transporte.telefone)
                       c-campo = AddEleChar(c-contactinformation-transp,"EmailAddress",transporte.e-mail).

            ASSIGN c-occollection = AddElement(c-productship,"OCCollection")
                   c-oc = AddElement(c-occollection,"OC")
                   c-campo = AddEleChar(c-oc,"OCIdentifier",ped-item.cod-ord-compra)
                   c-campo = AddEleInt(c-oc,"OCParcel",ped-item.parcela).
        END.

        ASSIGN c-orderitemvaluecollection = AddElement(c-productlineitem,"OrderItemValueCollection").
        
        /* 2 - % de Desconto */
        IF ped-item.per-des-item > 0 THEN 
            ASSIGN c-orderitemvalue = AddElement(c-orderitemvaluecollection,"OrderItemValue")    
                   c-campo = AddEleChar(c-orderitemvalue,"ValuesIdentifier","2")
                   c-campo = AddEleDeci(c-orderitemvalue,"Percent",ped-item.per-des-item).

        /* 15 - % de IPI */
        IF ped-item.aliquota-ipi > 0 THEN 
            ASSIGN c-orderitemvalue = AddElement(c-orderitemvaluecollection,"OrderItemValue")    
                   c-campo = AddEleChar(c-orderitemvalue,"ValuesIdentifier","15")
                   c-campo = AddEleDeci(c-orderitemvalue,"Percent",ped-item.aliquota-ipi).
        
        /* 4 - Valor do Desconto */
        IF ped-item.vl-desconto > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")    
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","4")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-desconto)
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).
          
        /* 28 - Pre‡o de Tabela */
        IF ped-item.vl-pretab > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")     
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","28")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-pretab)
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).
        
        /* 46 - Pre‡o de Tabela + Taxa Financeira */
        IF ped-item.vl-preori > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")     
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","46")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-preori)
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).
                
        /* 47 - Pre‡o de Tabela + Taxa Financeira - Descontos - Impostos */
        IF ped-item.vl-preuni > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","47")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-preuni)
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).
                
        /* 29 - (Valor Total do Item = (Pre‡o Unit rio + Impostos) * Quantidade */
        IF ped-item.vl-tot-it > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","29")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-tot-it / ped-item.qt-pedida)
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        /* 72 - (Valor Liquido + IPI) */
        IF ped-item.vl-liq-abe > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","72")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-liq-abe)
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        IF ped-item.vl-tot-it > 0 THEN 
            ASSIGN c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")
                   c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","1")
                   c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-tot-it )
                   c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        IF ped-item.cod-sit-item = 6 THEN
            ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyOrderItemStatusCode","7").
    END.
END.

PROCEDURE pi-cria-detalhes-pedido.
    DEF VAR c-billto                    AS CHAR NO-UNDO.
    DEF VAR c-physicaladdress-cob       AS CHAR NO-UNDO. /*endereco de cobranca*/
    DEF VAR c-address-cob               AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-cob    AS CHAR NO-UNDO. /*contato do endereco de cobranca*/
    DEF VAR c-ordervaluecollection      AS CHAR NO-UNDO.
    DEF VAR c-cod-emitente              AS CHAR NO-UNDO.
    DEF VAR c-ordervalue                AS CHAR NO-UNDO.
    DEF VAR c-monetaryamount-ordervalue AS CHAR NO-UNDO.
    DEF VAR c-fromrole                  AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-orig   AS CHAR NO-UNDO. /*contato de quem originou o pedido*/
    DEF VAR c-address-orig              AS CHAR NO-UNDO. /*endereco de quem originou o pedido*/
    DEF VAR c-torole                    AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-dest   AS CHAR NO-UNDO. /*contato de quem recebera o pedido (destino)*/
    DEF VAR c-address-dest              AS CHAR NO-UNDO. /*endereco de quem recebera o pedido (destino)*/
    DEF VAR i-cobranca                  AS INT  NO-UNDO.
    DEF VAR c-endereco                  AS CHAR NO-UNDO.
    DEF VAR c-cidade                    AS CHAR NO-UNDO.
    DEF VAR c-bairro                    AS CHAR NO-UNDO.
    DEF VAR c-estado                    AS CHAR NO-UNDO.
    DEF VAR c-cep                       AS CHAR NO-UNDO.
    DEF VAR c-pais                      AS CHAR NO-UNDO.
    DEF VAR c-contato                   AS CHAR NO-UNDO.
    DEF VAR c-e-mail                    AS CHAR NO-UNDO.
    DEF VAR c-telefone                  AS CHAR NO-UNDO.
    

    FIND emitente 
        WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
    
    IF emitente.end-cobranca > 0 THEN DO:
        ASSIGN i-cobranca = emitente.end-cobranca.

       FIND emitente 
           WHERE emitente.cod-emitente = i-cobranca NO-LOCK NO-ERROR.

       ASSIGN c-endereco = emitente.endereco
              c-cidade   = emitente.cidade
              c-bairro   = emitente.bairro
              c-estado   = emitente.estado
              c-cep      = emitente.cep
              c-pais     = emitente.pais     
              c-contato  = emitente.contato[1]
              c-e-mail   = emitente.e-mail
              c-telefone = emitente.telefone[1].
    END.
    ELSE  
        ASSIGN i-cobranca = ped-venda.cod-emitente
               c-endereco = emitente.endereco-cob
               c-cidade   = emitente.cidade-cob
               c-bairro   = emitente.bairro-cob
               c-estado   = emitente.estado-cob
               c-cep      = emitente.cep-cob
               c-pais     = emitente.pais-cob     
               c-contato  = emitente.contato[1]
               c-e-mail   = emitente.e-mail
               c-telefone = emitente.telefone[1].

    ASSIGN c-billto = AddElement(c-order,"BillTo")
           c-physicaladdress-cob = AddElement(c-billto,"PhysicalAddress")
           c-campo = AddEleInt(c-physicaladdress-cob,"LegacyLocationIdentifier",i-cobranca).

    ASSIGN c-ordervaluecollection = AddElement(c-order,"OrderValueCollection").
    
    /* 26 - Valor Total do Pedido*/
    IF ped-venda.vl-tot-ped > 0 THEN 
        ASSIGN c-ordervalue = AddElement(c-ordervaluecollection,"OrderValue")
               c-campo = AddEleChar(c-ordervalue,"ValuesIdentifier","26")  
               c-monetaryamount-ordervalue = AddElement(c-ordervalue,"MonetaryAmount") /*c-campo-aux = replace(string(de-total), ",", ".")*/ /*NeoGrid*/ /*c-campo = AddEleChar(c-monetaryamount-ordervalue,"Amount",c-campo-aux)*/ /*NeoGrid*/
               c-campo = AddEleDeci(c-monetaryamount-ordervalue,"Amount",ped-venda.vl-tot-ped)
               c-campo = AddEleInt(c-monetaryamount-ordervalue,"LegacyCurrencyCode",ped-venda.mo-codigo).
            
    /* 1 - Valor Total das Mercadorias sem IPI*/
    IF ped-venda.vl-liq-ped > 0 THEN 
        ASSIGN c-ordervalue = AddElement(c-ordervaluecollection,"OrderValue")
               c-campo = AddEleChar(c-ordervalue,"ValuesIdentifier","1")  
               c-monetaryamount-ordervalue = AddElement(c-ordervalue,"MonetaryAmount")
               c-campo = AddEleDeci(c-monetaryamount-ordervalue,"Amount",ped-venda.vl-liq-ped)
               c-campo = AddEleInt(c-monetaryamount-ordervalue,"LegacyCurrencyCode",ped-venda.mo-codigo).

    FIND estabelec 
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
    FIND emitente  
        WHERE emitente.cod-emitente = estabelec.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN c-fromrole = AddElement(c-orderupdate,"FromRole")
           c-campo = AddEleChar(c-fromrole,"LegacyLocationIdentifier",ped-venda.cod-estabel)
           c-campo = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","SELLER").

    FOR FIRST emitente FIELDS(cod-emitente char-2) NO-LOCK
        WHERE emitente.cod-emitente = ped-venda.cod-emitente:
    END.

    IF SUBSTRING(emitente.char-2,50,5) = "YES" THEN
        ASSIGN c-cod-emitente = SUBSTRING(emitente.char-2,55,13).
    ELSE
        ASSIGN c-cod-emitente = STRING(emitente.cod-emitente).
    
    ASSIGN c-torole = AddElement(c-orderupdate,"ToRole")
           c-campo = AddEleChar(c-torole,"LegacyLocationIdentifier",c-cod-emitente)
           c-campo = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","BUYER").
END.

/* Fim */
