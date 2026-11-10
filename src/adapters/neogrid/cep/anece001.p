/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANECE001 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANECE001 MCE}
&ENDIF


/********************************************************************************
** Programa : anece001.p
** Fun‡Æo   : Solicitacao de Posicao de Estoque
** Data     : 10/2000
** Autor    : Jean Renato Kormann/Sven Siegfried Imfeld
********************************************************************************/
{cdp/cdcfgdis.i}
{adapters/neogrid/include/anein004.i}
{adapters/neogrid/include/anein005.i}

def temp-table tt-situacao
    field situacao as integer
    index situacao is primary unique
          situacao.

def temp-table tt-saldo-estoq
    field cod-estabel       like saldo-estoq.cod-estabel
    field it-codigo         like saldo-estoq.it-codigo
    field cod-refer         like saldo-estoq.cod-refer
    field quantityonorder   as decimal
    field quantitysaleable  as decimal
    field quantitydefective as decimal
    field quantityopenbox   as decimal
    field quantityreserved  as decimal
    field quantitycommited  as decimal
    field quantityconsigned as decimal
    field quantitydemand    as decimal
    index item is primary
          it-codigo   ascending
          cod-estabel ascending
          cod-refer   ascending.

def var i-cont                       as integer no-undo.
def var c-cod-estabel       like saldo-estoq.cod-estabel    no-undo.
def var i-cod-emitente-orig like emitente.cod-emitente      no-undo.
def var c-cod-estabel-prin  like estab-mat.cod-estabel-prin no-undo.
def var c-fromroleclassificationcode as char no-undo.
def var c-contactinformation         as char no-undo.
def var c-address                    as char no-undo.
def var c-fromcontactname            as char no-undo.
def var c-fromtelephonenumber        as char no-undo.
def var c-fromemailaddress           as char no-undo.
def var c-fromaddressline1           as char no-undo.
def var c-fromaddressline2           as char no-undo.
def var c-fromaddressline3           as char no-undo.
def var c-fromcityname               as char no-undo.
def var c-fromdistrictname           as char no-undo.
def var c-fromstatecode              as char no-undo.
def var c-fromlegacycountrycode      as char no-undo.
def var c-fromnationalpostalcode     as char no-undo.
def var c-fromregionname             as char no-undo.
def var c-fromaddresscode            as char no-undo.
def var c-toroleclassificationcode   as char no-undo.
def var c-tocontactname              as char no-undo.
def var c-totelephonenumber          as char no-undo.
def var c-toemailaddress             as char no-undo.
def var c-toaddressline1             as char no-undo.
def var c-toaddressline2             as char no-undo.
def var c-toaddressline3             as char no-undo.
def var c-tocityname                 as char no-undo.
def var c-todistrictname             as char no-undo.
def var c-tostatecode                as char no-undo.
def var c-tolegacycountrycode        as char no-undo.
def var c-tonationalpostalcode       as char no-undo.
def var c-toregionname               as char no-undo.
def var c-toaddresscode              as char no-undo.

run ReceiveInventoryRequest.
run InventoryConsulting.
run SendInventoryPosition.

procedure ReceiveInventoryRequest:
    def var c-root                       as char no-undo.
    def var c-message                    as char no-undo.
    def var c-requestinventoryreporting  as char no-undo.
    def var c-fromrole                   as char no-undo.
    def var c-torole                     as char no-undo.
    def var c-inventoryreport            as char no-undo.
    def var c-productlineitemcollection  as char no-undo.
    def var c-productlineitem            as char no-undo.
    def var c-root-productlineitem       as char no-undo.
    def var c-it-codigo like saldo-estoq.it-codigo no-undo.
    def var c-cod-refer like saldo-estoq.cod-refer no-undo.

    assign
    c-root  = GetRoot()
      c-message = Get(c-root,"Message")
        c-requestinventoryreporting = Get(c-message,"RequestInventoryReporting")
          c-fromrole = Get(c-requestinventoryreporting,"FromRole")
            i-cod-emitente-orig = int(Getsonval(c-fromrole,"LegacyLocationIdentifier"))
            c-fromroleclassificationcode = Getsonval(c-fromrole,"GlobalPartnerRoleClassificationCode")
            c-contactinformation = Get(c-fromrole, "ContactInformation")
              c-fromcontactname     = Getsonval(c-contactinformation, "ContactName")
              c-fromtelephonenumber = Getsonval(c-contactinformation, "TelephoneNumber")
              c-fromemailaddress    = Getsonval(c-contactinformation, "EmailAddress")
            c-address = Get(c-fromrole, "Address")
              c-fromaddressline1       = Getsonval(c-address, "AddressLine1")
              c-fromaddressline2       = Getsonval(c-address, "AddressLine2")
              c-fromaddressline3       = Getsonval(c-address, "AddressLine3")
              c-fromcityname           = Getsonval(c-address, "CityName")
              c-fromdistrictname       = Getsonval(c-address, "DistrictName")       
              c-fromstatecode          = Getsonval(c-address, "StateCode")       
              c-fromlegacycountrycode  = Getsonval(c-address, "LegacyCountryCode")       
              c-fromnationalpostalcode = Getsonval(c-address, "NationalPostalCode")       
              c-fromregionname         = Getsonval(c-address, "RegionName")
              c-fromaddresscode        = Getsonval(c-address, "AddressCode").       

          assign           
          c-torole          = Get(c-requestinventoryreporting,"ToRole")
            c-cod-estabel   = Getsonval(c-torole,"LegacyLocationIdentifier")
            c-toroleclassificationcode = Getsonval(c-torole,"GlobalPartnerRoleClassificationCode")
            c-contactinformation = Get(c-torole, "ContactInformation")
              c-tocontactname     = Getsonval(c-contactinformation, "ContactName")
              c-totelephonenumber = Getsonval(c-contactinformation, "TelephoneNumber")
              c-toemailaddress    = Getsonval(c-contactinformation, "EmailAddress")
            c-address = Get(c-torole, "Address")
              c-toaddressline1       = Getsonval(c-address, "AddressLine1")
              c-toaddressline2       = Getsonval(c-address, "AddressLine2")
              c-toaddressline3       = Getsonval(c-address, "AddressLine3")
              c-tocityname           = Getsonval(c-address, "CityName")
              c-todistrictname       = Getsonval(c-address, "DistrictName")       
              c-tostatecode          = Getsonval(c-address, "StateCode")       
              c-tolegacycountrycode  = Getsonval(c-address, "LegacyCountryCode")       
              c-tonationalpostalcode = Getsonval(c-address, "NationalPostalCode")       
              c-toregionname         = Getsonval(c-address, "RegionName")
              c-toaddresscode        = Getsonval(c-address, "AddressCode")       
          c-inventoryreport = Get(c-requestinventoryreporting,"InventoryReport")
            c-productlineitemcollection = Get(c-inventoryreport,"ProductLineItemCollection")
              c-root-productlineitem    = GetElements(c-productlineitemcollection).

    do  i-cont = 1 to num-entries(c-root-productlineitem):
        create tt-saldo-estoq.
        assign
        c-productlineitem = entry(i-cont, c-root-productlineitem)
           c-it-codigo    = Getsonval(c-productlineitem,"LegacyProductIdentifier")
           tt-saldo-estoq.it-codigo   = c-it-codigo
           tt-saldo-estoq.cod-estabel = c-cod-estabel.

        for first item fields(it-codigo)
            where item.it-codigo = c-it-codigo no-lock:
        end.

        if  not avail item then
            undo, next.

        if  AvailTag(c-productlineitem,"LegacyProductReference") = yes then
            assign c-cod-refer = Getsonval(c-productlineitem,"LegacyProductReference")
                   tt-saldo-estoq.cod-refer = c-cod-refer.
    end.

end.

procedure InventoryConsulting:
    for each tt-situacao:
       delete tt-situacao.
    end.

    create tt-situacao.
    assign tt-situacao.situacao = 2.  /* Confirmada */
    create tt-situacao.
    assign tt-situacao.situacao = 6.   /* Recebida */

    for each tt-saldo-estoq no-lock:
        for first item fields (tipo-con-est
			       consumo-prev)
            where item.it-codigo = tt-saldo-estoq.it-codigo no-lock:
        end.

        for each saldo-estoq fields (cod-depos
                                     dt-vali-lote
                                     qtidade-atu
                                     qt-alocada
                                     qt-aloc-ped
                                     qt-aloc-prod) no-lock
            where saldo-estoq.it-codigo   = tt-saldo-estoq.it-codigo
            and   saldo-estoq.cod-estabel = tt-saldo-estoq.cod-estabel
            and   saldo-estoq.cod-refer   = tt-saldo-estoq.cod-refer:

            for first deposito fields (ind-acabado ind-dep-rej ind-dep-cq cod-depos)
                where deposito.cod-depos = saldo-estoq.cod-depos no-lock:
            end.

            if  deposito.ind-dep-rej = yes then
                assign tt-saldo-estoq.quantitydefective = tt-saldo-estoq.quantitydefective + saldo-estoq.qtidade-atu.
            else
                if  deposito.ind-dep-cq = yes then
                    assign tt-saldo-estoq.quantityopenbox = tt-saldo-estoq.quantityopenbox + saldo-estoq.qtidade-atu.

            if  deposito.ind-acabado = no then next.

            if  (item.tipo-con-est = 3 or  item.tipo-con-est = 4)
            and saldo-estoq.dt-vali-lote < today then
                next.

            assign tt-saldo-estoq.quantitycommited = tt-saldo-estoq.quantitycommited
                                                   + saldo-estoq.qt-aloc-ped
                   tt-saldo-estoq.quantitysaleable = saldo-estoq.qtidade-atu
                                                   - saldo-estoq.qt-alocada
                                                   - saldo-estoq.qt-aloc-ped
                                                   - saldo-estoq.qt-aloc-prod
                   tt-saldo-estoq.quantityreserved = tt-saldo-estoq.quantityreserved 
                                                   + saldo-estoq.qt-aloc-ped.                                                   
        end.

        for first param-estoq fields (cons-prev-estab) no-lock:
        end.

        if param-estoq.cons-prev-estab = no then
           assign tt-saldo-estoq.quantitydemand = item.consumo-prev / 30.
        else do:
           find estab-mat where estab-mat.cod-estabel = tt-saldo-estoq.cod-estabel no-lock no-error.

           assign c-cod-estabel-prin = if  avail estab-mat
                                       then estab-mat.cod-estabel-prin
                                       else tt-saldo-estoq.cod-estabel.

           if  avail estab-mat then
               for each  estab-mat fields (cod-estabel-prin) no-lock
                   where estab-mat.cod-estabel-prin = c-cod-estabel-prin,
                   &if '{&BF_DIS_VERSAO_EMS}' < '2.04' &then
                       first item-mat-estab fields (item-mat-estab.consumo-prev) no-lock
                       where item-mat-estab.it-codigo   = tt-saldo-estoq.it-codigo
                       and   item-mat-estab.cod-estabel = estab-mat.cod-estabel:

                       assign tt-saldo-estoq.quantitydemand = item-mat-estab.consumo-prev / 30.
                   &else
                       first item-uni-estab fields (item-uni-estab.consumo-prev) no-lock
                       where item-uni-estab.it-codigo   = tt-saldo-estoq.it-codigo
                       and   item-uni-estab.cod-estabel = estab-mat.cod-estabel:
                       assign tt-saldo-estoq.quantitydemand = item-uni-estab.consumo-prev / 30.
                   &endif
               end.
           else
               &if '{&BF_DIS_VERSAO_EMS}' < '2.04' &then
                   for first item-mat-estab fields (item-mat-estab.consumo-prev)
                       where item-mat-estab.it-codigo   = tt-saldo-estoq.it-codigo
                       and   item-mat-estab.cod-estabel = estab-mat.cod-estabel no-lock:
                       assign tt-saldo-estoq.quantitydemand = item-mat-estab.consumo-prev / 30.
                   end.
               &else
                   for first item-uni-estab fields (item-uni-estab.consumo-prev)
                       where item-uni-estab.it-codigo   = tt-saldo-estoq.it-codigo
                       and   item-uni-estab.cod-estabel = estab-mat.cod-estabel no-lock:

                       assign tt-saldo-estoq.quantitydemand = item-uni-estab.consumo-prev / 30.
                   end.
               &endif 
        end.

        for each  saldo-terc fields (quantidade) no-lock use-index &if '{&BF_DIS_VERSAO_EMS}' < '2.04' &then
                                                                       fornec
                                                                   &else
                                                                       estab-fornec
                                                                   &endif  
            where saldo-terc.cod-estabel   = tt-saldo-estoq.cod-estabel
            and   saldo-terc.cod-emitente  = i-cod-emitente-orig
            and   saldo-terc.it-codigo     = tt-saldo-estoq.it-codigo
            and   saldo-terc.tipo-sal-terc = 5
            and   saldo-terc.cod-refer     = tt-saldo-estoq.cod-refer:

            assign tt-saldo-estoq.quantityconsigned = tt-saldo-estoq.quantityconsigned + saldo-terc.quantidade.
        end.

        for each  tt-situacao,
            each  ordem-compra use-index emitente no-lock
            where ordem-compra.cod-emitente = i-cod-emitente-orig
            and   ordem-compra.cod-estabel  = tt-saldo-estoq.cod-estabel
            and   ordem-compra.it-codigo    = tt-saldo-estoq.it-codigo
            /*and   ordem-compra.cod-refer    = tt-saldo-estoq.cod-refer --> hoje nao ha referencia na ordem, mas sera aberto para o B2B*/
            and   ordem-compra.situacao     = tt-situacao.situacao,
            each  prazo-compra
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
            assign tt-saldo-estoq.quantityonorder = tt-saldo-estoq.quantityonorder + prazo-compra.quant-saldo.
        end.
    end.

end.

procedure SendInventoryPosition:
    def var c-root                         as char no-undo.
    def var c-message                      as char no-undo.
    def var c-responseinventoryreporting   as char no-undo.
    def var c-fromrole                     as char no-undo.
    def var c-torole                       as char no-undo.
    def var c-inventoryreport              as char no-undo.
    def var c-campo                        as char no-undo.
    def var c-campo-aux                    as char no-undo.
    def var c-productlineitemcollection    as char no-undo.
    def var c-productlineitem              as char no-undo.
    def var c-productinventoryreportingcol as char no-undo.
    def var c-productinventoryreporting    as char no-undo.
    def var c-quantityamount               as char no-undo.
    def var c-quantity                     as char no-undo.
    def var c-quantitytype                 as char no-undo.
    def var c-legacyunitofmeasure          as char no-undo.
    def var i-index                        as int  no-undo.
    def var quantity                       as dec extent 13 no-undo.    

    assign
    c-root = CreateNeoGridDoc("ResponseInventoryReporting","1.01.001",c-cod-estabel)
      c-message = AddElement(c-root,"Message")
        c-responseinventoryreporting = AddElement(c-message,"ResponseInventoryReporting")
          c-inventoryreport = AddElement(c-responseinventoryreporting,"InventoryReport")
            c-campo = AddEleDate(c-inventoryreport,"ReportDateTime",today,string(time,"HH:MM:SS"))
            c-productlineitemcollection = AddElement(c-inventoryreport,"ProductLineItemCollection").

    for each tt-saldo-estoq no-lock:
        for first item fields (desc-item
                               un 
                               consumo-prev)
            where item.it-codigo = tt-saldo-estoq.it-codigo no-lock:
        end.

        assign c-productlineitem = AddElement(c-productlineitemcollection,"ProductLineItem")
                 c-campo         = AddEleChar(c-productlineitem,"LegacyProductIdentifier",tt-saldo-estoq.it-codigo).

        if  tt-saldo-estoq.cod-refer <> "" then
            assign c-campo = AddEleChar(c-productlineitem,"LegacyProductReference",tt-saldo-estoq.cod-refer).

        if  item.desc-item <> "" then
            assign c-campo = AddEleChar(c-productlineitem,"ProductDescription",item.desc-item).

        assign
        c-productinventoryreportingcol = AddElement(c-productlineitem,"ProductInventoryReportingCollection")
        quantity[1]  = tt-saldo-estoq.quantityonorder
        quantity[2]  = tt-saldo-estoq.quantitysaleable
        quantity[3]  = 0
        quantity[4]  = 0
        quantity[5]  = 0
        quantity[6]  = tt-saldo-estoq.quantitydefective
        quantity[7]  = tt-saldo-estoq.quantityopenbox
        quantity[8]  = tt-saldo-estoq.quantityreserved
        quantity[9]  = tt-saldo-estoq.quantitycommited
        quantity[10] = 0
        quantity[12] = tt-saldo-estoq.quantitydemand
        quantity[11] = tt-saldo-estoq.quantityconsigned
        quantity[13] = 0.

        do i-index = 1 to 13:
          assign c-productinventoryreporting = AddElement(c-productinventoryreportingcol,"ProductInventoryReporting")
                    c-quantitytype   = AddEleInt(c-productinventoryreporting, "QuantityType", i-index)
                    c-quantityamount = AddElement(c-productinventoryreporting, "QuantityAmount")
                      c-campo-aux           = replace(string(quantity[i-index]), ",", ".")
                      c-quantity            = AddEleChar(c-quantityamount, "Quantity", c-campo-aux)
                      c-legacyunitofmeasure = AddEleChar(c-quantityamount, "LegacyUnitOfMeasure", item.un).
        end.
    end.

    assign c-torole   = AddElement(c-responseinventoryreporting,"FromRole")
             c-campo  = AddEleChar(c-torole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo  = AddEleChar(c-torole, "GlobalPartnerRoleClassificationCode", c-toroleclassificationcode)
             c-contactinformation = AddElement(c-torole, "ContactInformation")
               c-campo = AddEleChar(c-contactinformation, "ContactName", c-tocontactname) 
               c-campo = AddEleChar(c-contactinformation, "TelephoneNumber", c-totelephonenumber) 
               c-campo = AddEleChar(c-contactinformation, "EmailAddress", c-toemailaddress) 
             c-address = AddElement(c-torole, "Address") 
               c-campo = AddEleChar(c-address, "AddressLine1", c-toaddressline1) 
               c-campo = AddEleChar(c-address, "AddressLine2", c-toaddressline2) 
               c-campo = AddEleChar(c-address, "AddressLine3", c-toaddressline3) 
               c-campo = AddEleChar(c-address, "CityName", c-tocityname) 
               c-campo = AddEleChar(c-address, "DistrictName", c-todistrictname) 
               c-campo = AddEleChar(c-address, "StateCode", c-tostatecode) 
               c-campo = AddEleChar(c-address, "LegacyCountryCode", c-tolegacycountrycode) 
               c-campo = AddEleChar(c-address, "NationalPostalCode", c-tonationalpostalcode) 
               c-campo = AddEleChar(c-address, "RegionName", c-toregionname) 
               c-campo = AddEleChar(c-address, "AddressCode", c-toaddresscode).

    assign c-fromrole = AddElement(c-responseinventoryreporting,"ToRole")
             c-campo  = AddEleInt(c-fromrole, "LegacyLocationIdentifier", i-cod-emitente-orig)
             c-campo  = AddEleChar(c-fromrole, "GlobalPartnerRoleClassificationCode", c-fromroleclassificationcode)
             c-contactinformation = AddElement(c-fromrole, "ContactInformation")
               c-campo  = AddEleChar(c-contactinformation, "ContactName", c-fromcontactname) 
               c-campo  = AddEleChar(c-contactinformation, "TelephoneNumber", c-fromtelephonenumber) 
               c-campo  = AddEleChar(c-contactinformation, "EmailAddress", c-fromemailaddress) 
             c-address = AddElement(c-fromrole, "Address") 
               c-campo  = AddEleChar(c-address, "AddressLine1", c-fromaddressline1) 
               c-campo  = AddEleChar(c-address, "AddressLine2", c-fromaddressline2) 
               c-campo  = AddEleChar(c-address, "AddressLine3", c-fromaddressline3) 
               c-campo  = AddEleChar(c-address, "CityName", c-fromcityname) 
               c-campo  = AddEleChar(c-address, "DistrictName", c-fromdistrictname) 
               c-campo  = AddEleChar(c-address, "StateCode", c-fromstatecode) 
               c-campo  = AddEleChar(c-address, "LegacyCountryCode", c-fromlegacycountrycode) 
               c-campo  = AddEleChar(c-address, "NationalPostalCode", c-fromnationalpostalcode) 
               c-campo  = AddEleChar(c-address, "RegionName", c-fromregionname) 
               c-campo  = AddEleChar(c-address, "AddressCode", c-fromaddresscode).

    WriteXML().
end.
