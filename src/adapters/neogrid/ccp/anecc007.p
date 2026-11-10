/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANECC007 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anecc007 MAN}
&ENDIF

/********************************************************************************
** Programa : anecc007.p
** Fun‡Æo   : Sender de Cancelamento de Pedido de Compra
** Data     : 06/2001
** Autor    : Sven Siegfried Imfeld
********************************************************************************/
{adapters/neogrid/include/anein008.i} /* Valida se b2b est  implantado */
{adapters/neogrid/include/anein004.i}
{cdp/cdcfgdis.i}

def input parameter r-pedido-compr as rowid.

def var c-root                   as char no-undo.
def var c-campo                  as char no-undo.
def var c-message                as char no-undo.
def var c-ordercancel            as char no-undo.

find pedido-compr no-lock 
     where rowid(pedido-compr) = r-pedido-compr no-error.

if available pedido-compr then do:
   assign c-root = CreateNeoGridDoc("PurchaseOrderCancel","1.01.001", pedido-compr.cod-estabel).
   run pi-cancela-pedido.
   run pi-detalhes-pedido.
   WriteXML().
end.

procedure pi-cancela-pedido.
    assign
    c-message = AddElement(c-root,"Message")
       c-ordercancel = AddElement(c-message,"PurchaseOrderCancel")
          c-campo = AddEleInt(c-ordercancel,"POIdentifier",pedido-compr.num-pedido).
end.

procedure pi-detalhes-pedido.
    def var c-fromrole                  as char no-undo.
    def var c-contactinformation-orig   as char no-undo. /*contato de quem originou o pedido*/
    def var c-address-orig              as char no-undo. /*endereco de quem originou o pedido*/
    def var c-torole                    as char no-undo.
    def var c-contactinformation-dest   as char no-undo. /*contato de quem recebera o pedido (destino)*/
    def var c-address-dest              as char no-undo. /*endereco de quem recebera o pedido (destino)*/
    def var c-messagetype               as char no-undo.
    def var c-contato-dest              as char no-undo.
    def var c-e-mail-dest               as char no-undo.
    def var c-telefone-dest             as char no-undo.
    def var c-contato-orig              as char no-undo.
    def var c-e-mail-orig               as char no-undo.
    def var c-telefone-orig             as char no-undo.
    
    for first estabelec fields (cod-emitente
                                cod-estabel
                                endereco
                                cidade
                                bairro
                                estado
                                cep
                                pais)
        where estabelec.cod-estabel = pedido-compr.end-entrega no-lock:
    end.
    
    for first emitente fields (cod-emitente
                               endereco
                               cidade
                               bairro
                               estado
                               cep
                               pais)
        where emitente.cod-emitente = pedido-compr.cod-emitente no-lock:
    end.
    
    for first ordem-compra fields (num-pedido
                                   contato)
        use-index pedido no-lock
        where ordem-compra.num-pedido = pedido-compr.num-pedido:
    end.
    
    if available ordem-compra then do:        
       for first cont-emit fields (nome e-mail telefone)
          where cont-emit.nome = ordem-compra.contato no-lock:
       end.
       if available cont-emit then
          assign c-contato-dest  = cont-emit.nome
                 c-e-mail-dest   = cont-emit.e-mail
                 c-telefone-dest = cont-emit.telefone.
    end.   
 
    for first usuar-mater fields (cod-usuario e-mail telefone)
        where usuar-mater.cod-usuario = pedido-compr.responsavel no-lock:
    end.

    if available usuar-mater then 
       assign c-contato-orig  = usuar-mater.cod-usuario 
              c-e-mail-orig   = usuar-mater.e-mail
              c-telefone-orig = usuar-mater.telefone[1].
 
    ASSIGN
    c-fromrole = AddElement(c-ordercancel,"FromRole")
       c-campo = AddEleChar(c-fromrole,"LegacyLocationIdentifier",pedido-compr.cod-estabel)
       c-campo = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","BUYER")
       c-contactinformation-orig = AddElement(c-fromrole,"ContactInformation")
          c-campo = AddEleChar(c-contactinformation-orig,"ContactName",c-contato-orig)
          c-campo = AddEleChar(c-contactinformation-orig,"EmailAddress",c-e-mail-orig)
          c-campo = AddEleChar(c-contactinformation-orig,"TelephoneNumber",c-telefone-orig)
       c-address-orig = AddElement(c-fromrole,"Address")
          c-campo = AddEleChar(c-address-orig,"AddressLine1",estabelec.endereco)
          c-campo = AddEleChar(c-address-orig,"CityName",estabelec.cidade)
          c-campo = AddEleChar(c-address-orig,"DistrictName",estabelec.bairro)
          c-campo = AddEleChar(c-address-orig,"StateCode",estabelec.estado)
          c-campo = AddEleInt(c-address-orig,"NationalPostalCode",estabelec.cep)
          c-campo = AddEleChar(c-address-orig,"LegacyCountryCode",estabelec.pais)
          c-campo = AddEleChar(c-address-orig,"AddressCode","")
          
    c-torole = AddElement(c-ordercancel,"ToRole")
       c-campo = AddEleInt(c-torole,"LegacyLocationIdentifier",emitente.cod-emitente)
       c-campo = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","SELLER")
       c-contactinformation-dest = AddElement(c-torole,"ContactInformation")
          c-campo = AddEleChar(c-contactinformation-dest,"ContactName",c-contato-dest)
          c-campo = AddEleChar(c-contactinformation-dest,"EmailAddress",c-e-mail-dest)
          c-campo = AddEleChar(c-contactinformation-dest,"TelephoneNumber",c-telefone-dest)
        c-address-dest = AddElement(c-torole,"Address")
          c-campo = AddEleChar(c-address-dest,"AddressLine1",emitente.endereco)
          c-campo = AddEleChar(c-address-dest,"CityName",emitente.cidade)
          c-campo = AddEleChar(c-address-dest,"DistrictName",emitente.bairro)
          c-campo = AddEleChar(c-address-dest,"StateCode",emitente.estado)
          c-campo = AddEleChar(c-address-dest,"NationalPostalCode",emitente.cep)
          c-campo = AddEleChar(c-address-dest,"LegacyCountryCode",emitente.pais)
          c-campo = AddEleChar(c-address-dest,"AddressCode","")
          
    c-messagetype = AddEleChar(c-ordercancel,"MessageType","PURCHASE").
end.
