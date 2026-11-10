/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD005 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd005 MAN}
&ENDIF

/********************************************************************************
** Programa : anepd005.p
** Fun‡Æo   : Sender de Cancelamento de Pedido de Venda
** Data     : 06/2001
** Autor    : Sven Siegfried Imfeld
********************************************************************************/
{adapters/neogrid/include/anein008.i} /* Valida se b2b est  implantado */
{adapters/neogrid/include/anein004.i}
{cdp/cdcfgdis.i}

DEF INPUT PARAMETER r-ped-venda AS ROWID.

DEF VAR c-root        AS CHAR NO-UNDO.
DEF VAR c-campo       AS CHAR NO-UNDO.
DEF VAR c-message     AS CHAR NO-UNDO.
DEF VAR c-ordercancel AS CHAR NO-UNDO.

DEF BUFFER b-emitente FOR emitente.

FIND ped-venda   
     WHERE ROWID(ped-venda) = r-ped-venda NO-LOCK NO-ERROR.

IF AVAILABLE ped-venda THEN DO:
   ASSIGN c-root = CreateNeoGridDoc("SalesOrderCancel","1.01.001", ped-venda.cod-estabel).
   RUN pi-cancela-pedido.
   RUN pi-detalhes-pedido.
   WriteXML().
END.

PROCEDURE pi-cancela-pedido.
    ASSIGN c-message = AddElement(c-root,"Message")
           c-ordercancel = AddElement(c-message,"OrderCancel")
           c-campo = AddEleChar(c-ordercancel,"POIdentifier",ped-venda.nr-pedcli).
END. 

PROCEDURE pi-detalhes-pedido.
    DEF VAR c-fromrole                AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-orig AS CHAR NO-UNDO. /*contato de quem originou o pedido*/
    DEF VAR c-address-orig            AS CHAR NO-UNDO. /*endereco de quem originou o pedido*/
    DEF VAR c-torole                  AS CHAR NO-UNDO.
    DEF VAR c-contactinformation-dest AS CHAR NO-UNDO. /*contato de quem recebera o pedido (destino)*/
    DEF VAR c-address-dest            AS CHAR NO-UNDO. /*endereco de quem recebera o pedido (destino)*/
    DEF VAR c-messagetype             AS CHAR NO-UNDO.
    DEF VAR c-cod-emitente            AS CHAR NO-UNDO.
    
    FIND estabelec   
         WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
         
    FIND b-emitente   
        WHERE b-emitente.cod-emitente = estabelec.cod-emitente NO-LOCK NO-ERROR.
    
    FIND emitente  
        WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
         
    IF SUBSTRING(emitente.char-2,50,5) = "YES" THEN
        ASSIGN c-cod-emitente = SUBSTRING(emitente.char-2,55,13).
    ELSE 
        ASSIGN c-cod-emitente = STRING(emitente.cod-emitente).

    ASSIGN c-fromrole = AddElement(c-ordercancel,"FromRole")
           c-campo = AddEleChar(c-fromrole,"LegacyLocationIdentifier",ped-venda.cod-estabel)
           c-campo = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-contactinformation-orig = AddElement(c-fromrole,"ContactInformation")
           c-campo = AddEleChar(c-contactinformation-orig,"ContactName",b-emitente.contato[1])
           c-campo = AddEleChar(c-contactinformation-orig,"EmailAddress",b-emitente.e-mail)
           c-campo = AddEleChar(c-contactinformation-orig,"TelephoneNumber",b-emitente.telefone[1])
           c-address-orig = AddElement(c-fromrole,"Address")
           c-campo = AddEleChar(c-address-orig,"AddressLine1",b-emitente.endereco)
           c-campo = AddEleChar(c-address-orig,"CityName",b-emitente.cidade)
           c-campo = AddEleChar(c-address-orig,"DistrictName",b-emitente.bairro)
           c-campo = AddEleChar(c-address-orig,"StateCode",b-emitente.estado)
           c-campo = AddEleChar(c-address-orig,"NationalPostalCode",b-emitente.cep)
           c-campo = AddEleChar(c-address-orig,"LegacyCountryCode",b-emitente.pais)
           c-campo = AddEleChar(c-address-orig,"AddressCode","").
          
    ASSIGN c-torole = AddElement(c-ordercancel,"ToRole")
           c-campo = AddEleChar(c-torole,"LegacyLocationIdentifier",c-cod-emitente)
           c-campo = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","BUYER")
           c-contactinformation-dest = AddElement(c-torole,"ContactInformation")
           c-campo = AddEleChar(c-contactinformation-dest,"ContactName",emitente.contato[1])
           c-campo = AddEleChar(c-contactinformation-dest,"EmailAddress",emitente.e-mail)
           c-campo = AddEleChar(c-contactinformation-dest,"TelephoneNumber",emitente.telefone[1])
           c-address-dest = AddElement(c-torole,"Address")
           c-campo = AddEleChar(c-address-dest,"AddressLine1",emitente.endereco)
           c-campo = AddEleChar(c-address-dest,"CityName",emitente.cidade)
           c-campo = AddEleChar(c-address-dest,"DistrictName",emitente.bairro)
           c-campo = AddEleChar(c-address-dest,"StateCode",emitente.estado)
           c-campo = AddEleChar(c-address-dest,"NationalPostalCode",emitente.cep)
           c-campo = AddEleChar(c-address-dest,"LegacyCountryCode",emitente.pais)
           c-campo = AddEleChar(c-address-dest,"AddressCode","")
           c-messagetype = AddEleChar(c-ordercancel,"MessageType","SALE").
END.
