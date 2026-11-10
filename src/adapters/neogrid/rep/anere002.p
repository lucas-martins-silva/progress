/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANERE002 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anere002 MAN}
&ENDIF

/********************************************************************************
**  Programa    : anere002.p
**  Funá∆o      : Sender da Mensagem de Confirmacao de Recebimento da Nota
**  Data        : 01/2001
**  Autor       : Jean Renato Kormann
**  Vers∆o      :
**  2.00.00.001 - 19/03/2002 - Jurandir Steffens
**                Passa a retornar as ordens e as respectivas quantidades baixadas.
**  2.00.00.002 - 21/03/2002 - Jurandir Steffens
**                Estava gerando o conjunto de itens de forma incorreta.
********************************************************************************/
{adapters/neogrid/include/anein008.i} /* Valida se b2b est† implantado */
{adapters/neogrid/include/anein004.i}

DEF INPUT PARAM r-docum-est  AS ROWID. 

DEF VAR c-root               AS CHAR.
DEF VAR c-message            AS CHAR.
DEF VAR c-invoicedelivery    AS CHAR.
DEF VAR c-invoiceidentifier  AS CHAR.
DEF VAR c-invoicepartnerlist AS CHAR.
DEF VAR c-fromrole           AS CHAR.
DEF VAR c-torole             AS CHAR.
DEF VAR c-campo              AS CHAR.
DEF VAR c-productcollection  AS CHAR.
DEF VAR c-product            AS CHAR.
DEF VAR c-pocollection       AS CHAR.
DEF VAR c-po                 AS CHAR.
DEF VAR c-poquantity         AS CHAR.
DEF VAR c-quantity           AS CHAR.
DEF VAR c-element-aux        AS CHAR.
DEF VAR i-fornec             AS INT.
DEF VAR h-acomp              AS HANDLE NO-UNDO.
DEF VAR c-class-from         AS CHAR FORMAT "x(08)".
DEF VAR c-class-to           AS CHAR FORMAT "x(08)".

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "").
RUN pi-seta-titulo IN h-acomp (INPUT "Enviando XML.").
RUN pi-finalizar   IN h-acomp.

FOR FIRST docum-est FIELDS(cod-estabel
                           serie-docto
                           nro-docto
                           cod-emitente)
    WHERE ROWID(docum-est) = r-docum-est NO-LOCK:
END.

ASSIGN c-class-from = "RECEIVER"
       c-class-to   = "INVOICER".
IF  AVAIL docum-est
AND docum-est.cod-observ = 3 THEN
    ASSIGN c-class-from = "INVOICER"
           c-class-to   = "RECEIVER".

ASSIGN c-root               = CreateNeoGridDoc("InvoiceDelivery","1.01.001",docum-est.cod-estabel)
       c-message            = AddElement(c-root,"Message")
       c-invoicedelivery    = AddElement(c-message,"InvoiceDelivery")
       c-invoiceidentifier  = AddElement(c-invoicedelivery,"InvoiceIdentifier")
       c-campo              = AddEleChar(c-invoiceidentifier,"SerialNumber",docum-est.serie-docto)
       c-campo              = AddEleChar(c-invoiceidentifier,"InvoiceNumber",docum-est.nro-docto)
       c-invoicepartnerlist = AddElement(c-invoicedelivery,"InvoicePartnerList")
       c-fromrole           = AddElement(c-invoicepartnerlist,"FromRole")
       c-campo              = AddEleChar(c-fromrole,"LegacyLocationIdentifier",docum-est.cod-estabel)
       c-campo              = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode",c-class-from)
       c-torole             = AddElement(c-invoicepartnerlist,"ToRole")
       c-campo              = AddEleInt(c-torole,"LegacyLocationIdentifier",docum-est.cod-emitente)
       c-campo              = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode",c-class-to)
       c-campo              = AddEleDate(c-invoicedelivery,"DeliveryDate",TODAY,STRING(TIME,"HH:MM:SS"))
       c-productcollection  = AddElement(c-invoicedelivery,"ProductLineItemCollection").

FOR EACH item-doc-est FIELDS(it-codigo
                             num-pedido
                             numero-ordem
                             parcela
                             quantidade
                             un) 
    OF docum-est NO-LOCK:
    ASSIGN c-product        = AddElement(c-productcollection,"ProductLineItem")
           c-campo          = AddEleChar(c-product,"LegacyProductIdentifier",item-doc-est.it-codigo)
           c-pocollection   = AddElement(c-product,"POAttendanceCollection")
           c-po             = AddElement(c-pocollection,"POAttendance")
           c-campo          = IF  item-doc-est.num-pedido   <> 0 THEN AddEleInt(c-po,"POIdentifier",item-doc-est.num-pedido) ELSE ""
           c-campo          = IF  item-doc-est.numero-ordem <> 0 THEN AddEleInt(c-po,"PONumber",item-doc-est.numero-ordem)   ELSE ""
           c-campo          = IF  item-doc-est.parcela      <> 0 THEN AddEleInt(c-po,"POParcelNumber",item-doc-est.parcela)  ELSE ""
           c-poquantity     = AddElement(c-po,"POFulfilledQuantity")
           c-quantity       = AddElement(c-poquantity,"QuantityAmount")
           c-element-aux    = REPLACE(STRING(item-doc-est.quantidade), ",", ".")
           c-campo          = AddEleChar(c-quantity,"Quantity",c-element-aux)
           c-campo          = AddEleChar(c-quantity,"LegacyUnitOfMeasure",item-doc-est.un).
END.

WriteXML().
