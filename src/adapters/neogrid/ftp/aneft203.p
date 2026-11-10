/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT203 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft203 MAN}
&ENDIF

/********************************************************************************
** Programa : aneft003.p
** Fun‡Æo   : Sender de Mensagens de Cancelamento de Nota Fiscal
** Data     : 08/2001
** Autor    : Jurandir Steffens
********************************************************************************/

{adapters/neogrid/include/anein004.i}

DEF INPUT PARAM r-rowid AS ROWID NO-UNDO.

DEF VAR c-root                      AS CHAR. 
DEF VAR c-message                   AS CHAR.
DEF VAR c-campo                     AS CHAR.
DEF VAR c-invoicestatus             AS CHAR.
DEF VAR c-invoiceidentifier         AS CHAR.
DEF VAR c-invoicepartnerlist        AS CHAR.
DEF VAR c-fromrole                  AS CHAR.
DEF VAR c-contactinformation-from   AS CHAR.
DEF VAR c-address                   AS CHAR.
DEF VAR c-torole                    AS CHAR.
DEF VAR c-contactinformation-to     AS CHAR.
DEF VAR c-contactname-from          AS CHAR.
DEF VAR c-telephonenumber-from      AS CHAR.
DEF VAR c-emailaddress-from         AS CHAR.
DEF VAR c-contactname-to            AS CHAR.
DEF VAR c-telephonenumber-to        AS CHAR.
DEF VAR c-emailaddress-to           AS CHAR.

RUN sendinvoicecancel.

PROCEDURE sendinvoicecancel:
    FIND FIRST nota-fiscal NO-LOCK
        WHERE ROWID(nota-fiscal) = r-rowid NO-ERROR.
    IF  AVAIL nota-fiscal 
    AND nota-fiscal.dt-cancela <> ? THEN DO:
        RUN BuildInvoiceCancel.
        WriteXML().
    END.
END.

PROCEDURE BuildInvoiceCancel:
    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    ASSIGN c-root                    = CreateNeoGridDoc("InvoiceStatus","1.01.001",nota-fiscal.cod-estabel)
           c-message                 = AddElement(c-root,"Message")
           c-invoicestatus           = AddElement(c-message,"InvoiceStatus")
           c-invoiceidentifier       = AddElement(c-invoicestatus,"InvoiceIdentifier")
           c-campo                   = AddEleChar(c-invoiceidentifier,"SerialNumber",nota-fiscal.serie)
           c-campo                   = AddEleChar(c-invoiceidentifier,"InvoiceNumber",nota-fiscal.nr-nota-fis)
           c-invoicepartnerlist      = AddElement(c-invoicestatus,"InvoicePartnerList")
           c-fromrole                = AddElement(c-invoicepartnerlist,"FromRole")
           c-campo                   = AddEleChar(c-fromrole,"LegacyLocationIdentifier",ped-venda.cod-estabel)
           c-campo                   = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-contactinformation-from = AddElement(c-fromrole,"ContactInformation")
           c-campo                   = AddEleChar(c-contactinformation-from,"ContactName",c-contactname-from)
           c-campo                   = AddEleChar(c-contactinformation-from,"TelephoneNumber",c-telephonenumber-from)
           c-campo                   = AddEleChar(c-contactinformation-from,"EmailAddress",c-emailaddress-from)
           c-campo                   = AddEleChar(c-address,"AddressLine1",estabelec.endereco)
           c-campo                   = AddEleChar(c-address,"CityName",estabelec.cidade)
           c-campo                   = AddEleChar(c-address,"DistrictName",estabelec.bairro)
           c-campo                   = AddEleChar(c-address,"StateCode",estabelec.estado)
           c-campo                   = AddEleChar(c-address,"LegacyCountryCode",estabelec.pais)
           c-campo                   = AddEleInt(c-address,"NationalPostalCode",estabelec.cep)
           c-torole                  = AddElement(c-invoicepartnerlist,"ToRole")
           c-campo                   = AddEleInt(c-torole,"LegacyLocationIdentifier",ped-venda.cod-emitente)
           c-campo                   = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","BUYER")
           c-contactinformation-to   = AddElement(c-torole,"ContactInformation")
           c-campo                   = AddEleChar(c-contactinformation-to,"ContactName",c-contactname-to)
           c-campo                   = AddEleChar(c-contactinformation-to,"TelephoneNumber",c-telephonenumber-to)
           c-campo                   = AddEleChar(c-contactinformation-to,"EmailAddress",c-emailaddress-to)
           c-address                 = AddElement(c-torole,"Address")
           c-campo                   = AddEleChar(c-address,"AddressLine1",emitente.endereco)
           c-campo                   = AddEleChar(c-address,"CityName",emitente.cidade)
           c-campo                   = AddEleChar(c-address,"DistrictName",emitente.bairro)
           c-campo                   = AddEleChar(c-address,"StateCode",emitente.estado)
           c-campo                   = AddEleChar(c-address,"LegacyCountryCode",emitente.pais)
           c-campo                   = AddEleChar(c-address,"NationalPostalCode",emitente.cep)
           c-campo                   = AddEleDate(c-invoicestatus,"StatusDate",nota-fiscal.dt-cancela,"")
           c-campo                   = AddEleInt(c-invoicestatus,"Status",16)
           c-campo                   = AddEleChar(c-invoicestatus,"UserDescription",nota-fiscal.desc-cancela).
END PROCEDURE.
