/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANECC001 2.00.00.009} /*** "010009" 24/10/2023 14:27:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anecc001 MAN}
&ENDIF

/********************************************************************************
** Programa : anecc001.p
** FunçÆo   : Sender da Solicitacao de Cotacao
** Data     : 07/2000
** Autor    : Jean Renato Kormann
********************************************************************************/

{adapters/neogrid/include/anein008.i} /* Valida se b2b está implantado */
{adapters/neogrid/include/anein004.i}
/*************************************************************************
** 
**      CC0302f.I - Definicao Temp-Table TT-Cotacao - 
**      utilizada no envio B2B , e no adpter
** 
*************************************************************************/
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

&if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    {ocp/oc0502f.i}
&else
    {ccp/cc0302f.i}
&endif


DEF INPUT PARAM TABLE FOR tt-cotacao.
DEF INPUT PARAM TABLE FOR tt-prazo-compra.
DEF INPUT PARAM TABLE FOR tt-fornecedores-envio.

DEF VAR c-root                            AS CHAR NO-UNDO. 
DEF VAR c-message                         AS CHAR NO-UNDO.
DEF VAR c-campo                           AS CHAR NO-UNDO.
DEF VAR c-requestquote                    AS CHAR NO-UNDO.
DEF VAR c-quote                           AS CHAR NO-UNDO.
DEF VAR c-customercontactcollection       AS CHAR NO-UNDO.
DEF VAR c-customercontact                 AS CHAR NO-UNDO.
DEF VAR c-productlineitem                 AS CHAR NO-UNDO.
DEF VAR c-quotecollection                 AS CHAR NO-UNDO.
DEF VAR c-supplierinformationcollection   AS CHAR NO-UNDO.
DEF VAR c-supplierinformation             AS CHAR NO-UNDO.
DEF VAR c-address-supplier                AS CHAR NO-UNDO.

DEF WORK-TABLE wk-requis
    FIELD rec AS ROWID.

RUN sendrequestquote.

PROCEDURE sendrequestquote:
    FOR EACH tt-cotacao NO-LOCK
        BREAK BY tt-cotacao.numero-ordem:
        IF FIRST-OF(tt-cotacao.numero-ordem) THEN DO:
            FOR EACH tt-fornecedores-envio NO-LOCK
                WHERE tt-fornecedores-envio.numero-ordem = tt-cotacao.numero-ordem
                BREAK BY tt-fornecedores-envio.cod-emitente:
                IF FIRST-OF(tt-fornecedores-envio.cod-emitente) THEN DO:
                    FIND FIRST emitente 
                        WHERE emitente.cod-emitente = tt-fornecedores-envio.cod-emitente NO-LOCK NO-ERROR.
                    IF (AVAIL emitente 
                    AND SUBSTR(emitente.char-1,11,1) = "1")
                    OR tt-fornecedores-envio.cod-emitente = 1 THEN
                        RUN BuildQuoteHeader.
                END.
            END.
        END.
    END.
    WriteXML().
END.

PROCEDURE BuildQuoteHeader:

    ASSIGN c-root                = CreateNeoGridDoc("RequestQuote","1.01.001","")
           c-message             = AddElement(c-root,"Message")
           c-requestquote        = AddElement(c-message,"RequestQuote")
           c-quote               = AddElement(c-requestquote,"Quote")
           c-campo               = AddEleChar(c-quote,"ANECC001","")
           c-campo               = AddEleInt(c-quote,"QuoteIdentifier",tt-cotacao.numero-ordem)
           c-campo               = AddEleChar(c-quote,"LegacyOrderStatusCode","5")
           c-campo               = AddEleDate(c-quote,"RegisterDate",tt-cotacao.data-emissao,"")
           c-supplierinformation = AddElement(c-quote,"SupplierInformation")
           c-campo               = AddEleInt(c-supplierinformation,"LegacyLocationIdentifier",tt-fornecedores-envio.cod-emitente)
           c-campo               = AddEleChar(c-supplierinformation,"SupplierName",tt-fornecedores-envio.nome-abrev).

    RUN BuildQuoteItem.
    RUN BuildFromRole.
    RUN BuildToRole.

    AddEleChar(c-requestquote,"ResponseMode","").

END.

PROCEDURE BuildQuoteItem:
    DEF VAR c-productlineitemcollection AS CHAR NO-UNDO.
    
    ASSIGN c-productlineitemcollection = AddElement(c-quote,"ProductLineItemCollection")
           c-productlineitem = AddElement(c-productlineitemcollection,"ProductLineItem")
           c-campo = AddEleChar(c-productlineitem,"PQSequentialIdentification","1")
           c-campo = AddEleChar(c-productlineitem,"LegacyProductIdentifier",tt-cotacao.it-codigo).
        
    IF tt-cotacao.referencia <> "" THEN
        ASSIGN c-campo = AddEleChar(c-productlineitem,"LegacyProductReference",tt-cotacao.referencia).
    
    IF tt-cotacao.ean-code <> "" THEN
        ASSIGN c-campo = AddEleChar(c-quote,"EANCode",tt-cotacao.ean-code).

    ASSIGN c-campo = AddEleChar(c-productlineitem,"ProductDescription",tt-cotacao.desc-item)
           c-campo = AddEleChar(c-productlineitem,"ProductDetailing",tt-cotacao.narrativa).

    IF tt-cotacao.narrativa <> "" THEN
        ASSIGN c-campo = AddEleChar(c-productlineitem,"Comment",tt-cotacao.narrativa-item).

    RUN BuildDelivery.
END.

PROCEDURE BuildDelivery:
    DEF VAR c-productshipcollection      AS CHAR NO-UNDO.
    DEF VAR c-productship                AS CHAR NO-UNDO.
    DEF VAR c-quantityamount             AS CHAR NO-UNDO.
    DEF VAR c-deliveryaddress            AS CHAR NO-UNDO.
    DEF VAR c-physicaladdress            AS CHAR NO-UNDO.
    DEF VAR c-address                    AS CHAR NO-UNDO.
    DEF VAR c-carrierinformation         AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-carrier AS CHAR NO-UNDO.
    
    ASSIGN c-productshipcollection = AddElement(c-productlineitem,"ProductShipCollection").
    
    FOR EACH tt-prazo-compra NO-LOCK
        WHERE tt-prazo-compra.numero-ordem = tt-cotacao.numero-ordem:
        ASSIGN c-productship = AddElement(c-productshipcollection,"ProductShip")
               c-campo = AddEleInt(c-productship,"PQLineNumber",tt-prazo-compra.parcela)
               c-campo = AddEleDate(c-productship,"RequestDeliveryDate",tt-prazo-compra.data-entrega,"")
               c-campo = AddEleChar(c-productship,"LegacyShipmentTermsCode",tt-prazo-compra.frete).
        
        IF tt-prazo-compra.narrativa <> "" THEN
            ASSIGN c-campo = AddEleChar(c-productship,"Comment",tt-prazo-compra.narrativa).
    
        ASSIGN c-quantityamount = AddElement(c-productship,"QuantityAmount")
               c-campo = REPLACE(STRING(tt-prazo-compra.quantidade), ",", ".")
               c-campo = AddEleChar(c-quantityamount,"Quantity",c-campo)
               c-campo = AddEleChar(c-quantityamount,"LegacyUnitOfMeasure",tt-prazo-compra.un)
               c-deliveryaddress   = AddElement(c-productship,"DeliveryAddress")
               c-physicaladdress = AddElement(c-deliveryaddress,"PhysicalAddress")
               c-campo   = AddEleChar(c-physicaladdress,"LegacyLocationIdentifier",tt-cotacao.cod-estabel)
               c-address = AddElement(c-physicaladdress,"Address")
               c-campo = AddEleChar(c-address,"AddressLine1",tt-cotacao.endereco-orig)
               c-campo = AddEleChar(c-address,"CityName",tt-cotacao.cidade-orig)
               c-campo = AddEleChar(c-address,"DistrictName",tt-cotacao.bairro-orig)
               c-campo = AddEleChar(c-address,"StateCode",tt-cotacao.uf-orig)
               c-campo = AddEleChar(c-address,"LegacyCountryCode",tt-cotacao.pais-orig)
               c-campo = AddEleInt(c-address,"NationalPostalCode",tt-cotacao.cep-orig).
    END.
END.

PROCEDURE BuildFromRole:
    DEF VAR c-fromrole                    AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-fromrole AS CHAR NO-UNDO.
    DEF VAR c-address-fromrole            AS CHAR NO-UNDO.
        
    ASSIGN c-fromrole = AddElement(c-requestquote,"FromRole")
           c-campo  = AddEleChar(c-fromrole,"LegacyLocationIdentifier",tt-cotacao.cod-estabel)
           c-campo  = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","BUYER")
           c-contactinformation-fromrole = AddElement(c-fromrole,"ContactInformation")
           c-campo = AddEleChar(c-contactinformation-fromrole,"ContactName",tt-cotacao.contato-orig-nome)
           c-campo = AddEleChar(c-contactinformation-fromrole,"TelephoneNumber",tt-cotacao.contato-orig-fone)
           c-campo = AddEleChar(c-contactinformation-fromrole,"EmailAddress",tt-cotacao.contato-orig-email)
           c-address-fromrole = AddElement(c-fromrole,"Address")
           c-campo = AddEleChar(c-address-fromrole,"AddressLine1",tt-cotacao.endereco-orig)
           c-campo = AddEleChar(c-address-fromrole,"CityName",tt-cotacao.cidade-orig)
           c-campo = AddEleChar(c-address-fromrole,"DistrictName",tt-cotacao.bairro-orig)
           c-campo = AddEleChar(c-address-fromrole,"StateCode",tt-cotacao.uf-orig)
           c-campo = AddEleChar(c-address-fromrole,"LegacyCountryCode",tt-cotacao.pais-orig)
           c-campo = AddEleInt(c-address-fromrole,"NationalPostalCode",tt-cotacao.cep-orig).
END.

PROCEDURE BuildToRole:
    DEF VAR c-torole                    AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-torole AS CHAR NO-UNDO.
    DEF VAR c-address-torole            AS CHAR NO-UNDO.
        
    ASSIGN c-torole = AddElement(c-requestquote,"ToRole")
           c-campo  = AddEleInt(c-torole,"LegacyLocationIdentifier",tt-fornecedores-envio.cod-emitente)
           c-campo  = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-address-torole = AddElement(c-torole,"Address")
           c-campo = AddEleChar(c-address-torole,"AddressLine1",tt-fornecedores-envio.endereco)
           c-campo = AddEleChar(c-address-torole,"CityName",tt-fornecedores-envio.cidade)
           c-campo = AddEleChar(c-address-torole,"DistrictName",tt-fornecedores-envio.bairro)
           c-campo = AddEleChar(c-address-torole,"StateCode",tt-fornecedores-envio.estado)
           c-campo = AddEleChar(c-address-torole,"LegacyCountryCode",tt-fornecedores-envio.pais)
           c-campo = AddEleChar(c-address-torole,"NationalPostalCode",tt-fornecedores-envio.cep).
END.


