/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD016 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd016 MAN}
&ENDIF


/********************************************************************************
** Programa : anepd016.p
** Funcao   : Sender de Inclusao/Alteracao do Pedido de Venda
** Data     : 06/2001
** Autor    : Sven Siegfried Imfeld
********************************************************************************/

{cdp/cdcfgdis.i}

{include/i-epc200.i anepd016} /* Temp-table tt-epc */

{adapters/neogrid/pdp/anepd016.i} /* Temp-table tt-pd-vendor */

&IF '{&bf_dis_versao_ems}' begins '2.04' 
&THEN
    &GLOBAL-DEFINE ped-venda.nr-pedido-crm    int(substr(ped-venda.char-2,1,9))
&ELSE
    &IF '{&bf_dis_versao_ems}' >= '2.05' 
    &THEN
        &GLOBAL-DEFINE ped-venda.nr-pedido-crm    ped-venda.nr-pedido-crm   
    &ELSE ""
    &ENDIF
&ENDIF

def input parameter r-ped-venda as rowid no-undo.
def input parameter changecode  as char  no-undo.

def var c-root                      as char no-undo.
def var c-campo                     as char no-undo.
def var c-campo-aux                 as char no-undo.
def var c-message                   as char no-undo.
def var c-orderupdate               as char no-undo.
def var c-order                     as char no-undo.
def var c-vendor                    as char no-undo.
def var c-colecao-representante     as char no-undo.
def var c-representante             as char no-undo.
def var c-colecao-antecipacao       as char no-undo.
def var c-antecipacao               as char no-undo.
def var c-paymentplan               as char no-undo.
def var c-paymentcollection         as char no-undo.
def var c-payment                   as char no-undo.
def var c-monetaryamount-payment    as char no-undo.
def var c-creditcardcollection      as char no-undo.
def var c-carrierinformation        as char no-undo.
def var c-via-transp                as char no-undo.
def var c-contactinformation-transp as char no-undo. /* contato do transportador */
def var c-quotecollection           as char no-undo.
def var c-quote                     as char no-undo.

def var i-cont                      as int  no-undo.
def var de-total                    as decimal format ">>>,>>>,>>>,>>>,>>9.99" init 0 no-undo.
def var de-preco-unit               as decimal decimals 4                      init 0 no-undo.
DEF VAR l-tp-pedido                 AS LOG NO-UNDO.


find ped-venda where rowid(ped-venda) = r-ped-venda no-lock no-error.
{adapters/neogrid/include/anein004.i}

if  not avail ped-venda THEN
    return.

find first param-global no-lock no-error.

IF changecode = "DELETE" THEN
    assign c-root = CreateNeoGridDocElimina("StandardOrderUpdateSales","1.01.001",ped-venda.cod-estabel).
   
ELSE 
    assign c-root = CreateNeoGridDoc("StandardOrderUpdateSales","1.01.001",ped-venda.cod-estabel).
   

ASSIGN l-tp-pedido       = CAN-FIND(FIRST funcao
                           WHERE funcao.cd-funcao = "spp-tp-pedido":U
                           AND   funcao.ativo).   


run pi-cria-cabecalho-pedido.
run pi-cria-itens.
run pi-cria-detalhes-pedido.
WriteXML().

/*************************** Chamada EPC ******************************/
IF  c-nom-prog-upc-mg97  <> "" THEN DO:
    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "EndSenderOrderB2B":
        DELETE tt-epc.
    END.
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event = "EndSenderOrderB2B"
           tt-epc.cod-parameter = "rowid-ped-venda"
           tt-epc.val-parameter = STRING(ROWID(ped-venda)).

    {include/i-epc201.i "EndSenderOrderB2B"}
END.
/********************* Final Chamada EPC ******************************/

procedure pi-cria-cabecalho-pedido.
    def var c-sit-ped     as char no-undo.
    def var c-tp-preco    as char no-undo.
    def var c-sit-pre     as char no-undo.
    def var c-sit-aval    as char no-undo.
    def var c-sit-com     as char no-undo.
    def var c-sit-preco   as char no-undo.
    def var c-esp-ped     as char no-undo.
    def var c-des-merc    as char no-undo.
    def var c-cob-desp    as char no-undo.
    def var c-modalidade  as char no-undo.
    def var c-vencto      as char no-undo.

    for first dist-emitente fields(int-1)
        where dist-emitente.cod-emitente = ped-venda.cod-emitente no-lock:
    end.

    assign
    c-message = AddElement(c-root,"CRM")
    c-message = AddElement(c-root,"Message")
      c-orderupdate = AddElement(c-message,"OrderUpdate")
        c-campo = AddEleChar(c-orderupdate,"GlobalOrderChangeCode",changecode) 
          c-order = AddElement(c-orderupdate,"Order")
            c-campo = AddEleChar(c-order,"OrderIdentifier",ped-venda.nr-pedcli)
            c-campo = AddEleChar(c-order,"nome-abrev",ped-venda.nome-abrev)
            c-campo = AddEleChar(c-order,"cod-emit-externo",if avail dist-emitente
                                                            then string(dist-emitente.int-1)
                                                            else "":U).

    if  changecode = "DELETE":U then
        assign c-sit-ped = "Eliminado":U.
    else
        assign c-sit-ped = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.

    assign
    c-tp-preco   = {diinc/i01di145.i 04 ped-venda.tp-preco}
    c-sit-pre    = {diinc/i04di149.i 04 ped-venda.cod-sit-pre}
    c-sit-aval   = {diinc/i03di159.i 04 ped-venda.cod-sit-aval}
    c-sit-com    = {diinc/i05di154.i 04 ped-venda.cod-sit-com}
    c-sit-preco  = {diinc/i05di154.i 04 ped-venda.cod-sit-preco}
    c-esp-ped    = {diinc/i04di154.i 04 ped-venda.esp-ped}
    c-des-merc   = {diinc/i02di159.i 04 ped-venda.cod-des-merc}
    c-cob-desp   = {diinc/i04di072.i 04 ped-venda.tip-cob-desp}
    c-modalidade = {adinc/i03ad209.i 04 ped-venda.modalidade}.

    assign
    c-campo = AddEleInt(c-order,"OrderNumber",ped-venda.nr-pedido)
    c-campo = AddEleInt(c-order,"nr-pedido-crm",{&ped-venda.nr-pedido-crm})
    c-campo = AddEleChar(c-order,"OrderStatus",c-sit-ped)
    c-campo = AddEleChar(c-order,"InventoryAllocationStatus",c-sit-pre)
    c-campo = AddEleChar(c-order,"CreditEvaluationStatus",c-sit-aval)
    c-campo = AddEleChar(c-order,"CommercialEvaluationStatus",c-sit-com)
    c-campo = AddEleChar(c-order,"PriceEvaluationStatus",c-sit-preco)
    c-campo = AddEleChar(c-order,"dsp-pre-fat", if ped-venda.dsp-pre-fat then "Sim"
                                                                         else "NÆo")
    c-campo = AddEleDate(c-order,"RegisterDate",ped-venda.dt-emissao,"")
    c-campo = AddEleDate(c-order,"dt-inivig",ped-venda.dt-inivig,"")
    c-campo = AddEleDate(c-order,"ValidityEndDate",ped-venda.dt-fimvig,"").

    if  ped-venda.observacoes <> "" then
        assign c-campo   = AddEleChar(c-order,"Comment",ped-venda.observacoes).

    

    IF l-tp-pedido THEN 
        ASSIGN c-campo = AddEleChar(c-order,"tp-pedido",ped-venda.tp-pedido).

    ASSIGN
    c-campo = AddEleChar(c-order,"OrderPriceType",c-tp-preco)
    c-campo = AddEleChar(c-order,"FiscalOperation",ped-venda.nat-operacao)
    c-campo = AddEleChar(c-order,"AdditionUser",ped-venda.user-impl)
    c-campo = AddEleDate(c-order,"AdditionDate",ped-venda.dt-implant,"")
    c-campo = AddEleDate(c-order,"DeliveryDate",ped-venda.dt-entrega,"").

    find cond-pagto where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-lock no-error.

    if  ped-venda.tab-ind-fin   = 0
    and ped-venda.nr-ind-finan <> 0 then
        find tab-finan
             where tab-finan.nr-tab-finan = cond-pagto.nr-tab-finan
             and   tab-finan.dt-ini-val  <= today
             and   tab-finan.dt-fim-val  >= today
             no-lock no-error. 

    assign
    c-campo = AddEleDeci(c-order,"OrderTax",if  ped-venda.tab-ind-fin <> 0
                                            then ped-venda.tab-ind-fin
                                            else if  avail tab-finan
                                                 and ped-venda.tp-preco > 1
                                                 and cond-pagto.nr-ind-finan > 0
                                                 then tab-finan.tab-ind-fin[cond-pagto.nr-ind-finan]
                                                 else 1)
    c-campo = AddEleChar(c-order,"esp-ped",c-esp-ped)
    c-campo = AddEleInt(c-order,"cod-canal-venda",ped-venda.cod-canal-venda)
    c-campo = AddEleInt(c-order,"nr-tab-finan",ped-venda.nr-tab-finan)
    c-campo = AddEleInt(c-order,"nr-ind-finan",ped-venda.nr-ind-finan)
    c-campo = AddEleChar(c-order,"nr-tabpre",ped-venda.nr-tabpre)
    c-campo = AddEleInt(c-order,"mo-codigo",ped-venda.mo-codigo)
    c-campo = AddEleDeci(c-order,"val-pct-desconto-tab-preco",ped-venda.val-pct-desconto-tab-preco)
    c-campo = AddEleChar(c-order,"log-usa-tabela-desconto", if ped-venda.log-usa-tabela-desconto
                                                            then "Sim"
                                                            else "NÆo")
    c-campo-aux = replace(ped-venda.des-pct-desconto-inform, ",", ".")
      c-campo = AddEleChar(c-order,"des-pct-desconto-inform",c-campo-aux)
    c-campo = AddEleDeci(c-order,"perc-desco1",ped-venda.perc-desco1)
    c-campo = AddEleDeci(c-order,"perc-desco2",ped-venda.perc-desco2)
    c-campo = AddEleChar(c-order,"no-ab-reppri",ped-venda.no-ab-reppri)
    c-campo = AddEleChar(c-order,"nr-pedrep",ped-venda.nr-pedrep)
    c-campo = AddEleChar(c-order,"contato",ped-venda.contato)
    c-campo = AddEleChar(c-order,"nome-abrev-tri",ped-venda.nome-abrev-tri)
    c-campo = AddEleChar(c-order,"cod-des-merc",c-des-merc)
    c-campo = AddEleDate(c-order,"dt-entorig",ped-venda.dt-entorig,"")
    c-campo = AddEleChar(c-order,"cod-rota",ped-venda.cod-rota)
    c-campo = AddEleChar(c-order,"uf-placa",ped-venda.uf-placa)
    c-campo = AddEleChar(c-order,"placa",ped-venda.placa).

    find transporte where transporte.nome-abrev = ped-venda.nome-transp no-lock no-error.

    assign
    c-carrierinformation = AddElement(c-order,"CarrierInformation")
      c-campo = AddEleInt(c-carrierinformation,"LegacyLocationIdentifier",if avail transporte then transporte.cod-transp else 0)
      c-campo = AddEleChar(c-carrierinformation,"CarrierName",ped-venda.nome-transp).

    if  avail transporte then
        assign c-via-transp = {adinc/i01ad268.i 04 transporte.via-transp}
               c-campo      = AddEleChar(c-carrierinformation,"LegacyShippingMethodCode",c-via-transp).

    if  avail transporte
    and transporte.contato <> "" then
        assign
        c-contactinformation-transp = AddElement(c-carrierinformation,"ContactInformation")
          c-campo = AddEleChar(c-contactinformation-transp,"ContactName",transporte.contato)
          c-campo = AddEleChar(c-contactinformation-transp,"TelephoneNumber",transporte.telefone)
          c-campo = AddEleChar(c-contactinformation-transp,"EmailAddress",transporte.e-mail).

    assign
    c-campo = AddEleChar(c-order,"nome-tr-red",ped-venda.nome-tr-red)
    c-campo = AddEleChar(c-order,"cidade-cif",ped-venda.cidade-cif)
    c-campo = AddEleInt(c-order,"cod-mensagem",ped-venda.cod-mensagem)
    c-campo = AddEleInt(c-order,"portador",ped-venda.cod-portador)
    c-campo = AddEleChar(c-order,"modalidade",c-modalidade) 
    c-campo = AddEleDate(c-order,"dt-minfat",ped-venda.dt-minfat,"")
    c-campo = AddEleDate(c-order,"dt-lim-fat",ped-venda.dt-lim-fat,"")
    c-campo = AddEleChar(c-order,"estab-central",ped-venda.estab-central)
    c-campo = AddEleChar(c-order,"estab-atend",ped-venda.estab-atend).

    IF l-tp-pedido THEN
        ASSIGN c-campo = AddEleChar(c-order,"tp-pedido",ped-venda.tp-pedido).

    ASSIGN
    c-campo = AddEleInt(c-order,"cod-priori",ped-venda.cod-priori)
    c-campo = AddEleChar(c-order,"ind-lib-nota",if ped-venda.ind-lib-nota
                                                  then "Sim"
                                                  else "NÆo")
    c-campo = AddEleChar(c-order,"ind-antecip",if ped-venda.ind-antecip
                                                  then "Sim"
                                                  else "NÆo")
    c-campo = AddEleChar(c-order,"ind-fat-par",if ped-venda.ind-fat-par
                                                  then "Sim"
                                                  else "NÆo")
    c-campo = AddEleDeci(c-order,"per-max-canc",ped-venda.per-max-can)
    c-campo = AddEleInt(c-order,"cod-mot-canc-cot",ped-venda.cod-mot-canc-cot)
    c-campo = AddEleChar(c-order,"desc-cancela",ped-venda.desc-cancela)
    c-campo = AddEleDate(c-order,"dt-cancela",ped-venda.dt-cancela,"")
    c-campo = AddEleChar(c-order,"user-canc",ped-venda.user-canc)
    c-campo = AddEleChar(c-order,"desc-suspend",ped-venda.desc-suspend)
    c-campo = AddEleDate(c-order,"dt-suspensao",ped-venda.dt-suspensao,"")
    c-campo = AddEleChar(c-order,"user-susp",ped-venda.user-susp)
    c-campo = AddEleChar(c-order,"desc-reativa",ped-venda.desc-reativa)
    c-campo = AddEleChar(c-order,"user-reat",ped-venda.user-reat)
    c-campo = AddEleChar(c-order,"user-alt",ped-venda.user-alt)
    c-campo = AddEleChar(c-order,"tip-cob-desp",c-cob-desp)
    c-campo = AddEleChar(c-order,"cond-redespa",ped-venda.cond-redespa)
    c-campo = AddEleChar(c-order,"cond-espec",ped-venda.cond-espec).

    if  ped-venda.nr-ped-cot-orig <> "" then
        assign
        c-quotecollection = AddElement(c-order,"QuoteCollection")
          c-quote = AddElement(c-quotecollection,"Quote")
            c-campo = AddEleChar(c-quote,"QuoteIdentifier",ped-venda.nr-ped-cot-orig).

    assign c-paymentplan = AddElement(c-order,"PaymentPlan")
             c-campo = AddEleInt(c-paymentplan,"PaymentCode",ped-venda.cod-cond-pag).

    find first cond-ped where cond-ped.nr-pedido = ped-venda.nr-pedido no-lock no-error.

    if  avail cond-ped then
        assign c-paymentcollection = AddElement(c-paymentplan,"PaymentCollection").

    for each  cond-ped no-lock 
        where cond-ped.nr-pedido = ped-venda.nr-pedido:

        assign 
        c-vencto  = {diinc/i02di165.i 04 cond-ped.cod-vencto} 
        c-payment = AddElement(c-paymentcollection,"Payment")
          c-campo = AddEleInt(c-payment,"nr-sequencia",cond-ped.nr-sequencia)
          c-campo = AddEleChar(c-payment,"cod-vencto",c-vencto)
          c-campo = AddEleChar(c-payment,"observacoes",cond-ped.observacoes).

        if  cond-ped.data-pagto <> ? then
            assign c-campo = AddEleDate(c-payment,"DueDate",cond-ped.data-pagto,"").
        else
            assign c-campo = AddEleInt(c-payment,"DueDays",cond-ped.nr-dias-venc).

        if  cond-ped.perc-pagto > 0 then do:
            &if  "{&BF_DIS_VERSAO_EMS}" >= "2.04" &then
                assign c-campo-aux = replace(string(cond-ped.perc-pagto), ",", ".")
                       c-campo = AddEleChar(c-payment,"Percent",c-campo-aux).
            &else
                assign c-campo = AddEleInt(c-payment,"Percent",cond-ped.perc-pagto).
            &endif
        end.
        else
            assign
            c-monetaryamount-payment = AddElement(c-payment,"MonetaryAmount")
              c-campo-aux = replace(string(cond-ped.vl-pagto), ",", ".")
              c-campo = AddEleChar(c-monetaryamount-payment,"Amount",c-campo-aux)
              c-campo = AddEleint(c-monetaryamount-payment,"LegacyCurrencyCode",ped-venda.mo-codigo).
    end.


    find first ped-repre where ped-repre.nr-pedido = ped-venda.nr-pedido no-lock no-error.

    if  avail ped-repre then
        assign c-colecao-representante = AddElement(c-order,"colecao-representante").

    for each ped-repre no-lock
        where ped-repre.nr-pedido = ped-venda.nr-pedido:

        assign
        c-representante = AddElement(c-colecao-representante,"representante")            
          c-campo = AddEleChar(c-representante,"nome-abrev",ped-repre.nome-ab-rep)
          c-campo = AddEleChar(c-representante,"ind-repbase",if ped-repre.ind-repbase
                                                                 then "Sim"
                                                                 else "NÆo")
          c-campo = AddEleDeci(c-representante,"perc-comis",ped-repre.perc-comis)
          c-campo = AddEleInt(c-representante,"comis-emis",ped-repre.comis-emis).
    end.

    find first ped-antecip where ped-antecip.nr-pedido = ped-venda.nr-pedido no-lock no-error.

    if  avail ped-antecip then 
        assign c-colecao-antecipacao = AddElement(c-order,"colecao-antecipacao").


    for each ped-antecip no-lock
        where ped-antecip.nr-pedido = ped-venda.nr-pedido:

        do  i-cont = 1 to 6 :
            if  string(ped-antecip.data-antecip[i-cont]) <> ""
            and string(ped-antecip.data-antecip[i-cont]) <> ? then
                assign
                c-antecipacao = AddElement( c-colecao-antecipacao,"antecipacao")
                  c-campo = AddEleDate( c-antecipacao,"data-antecip",ped-antecip.data-antecip[i-cont],"") 
                  c-campo = AddEleDeci( c-antecipacao,"vl-antecip",ped-antecip.vl-antecip[i-cont]).
        end.

        assign c-campo = AddEleChar(c-order,"observacoes-antecipacao",ped-antecip.observacoes).
    end.
end.

procedure pi-cria-itens.
    def var c-productlineitemcollection as char no-undo.
    def var c-productlineitem           as char no-undo.
    def var c-monetaryamount-item       as char no-undo.
    def var c-productshipcollection     as char no-undo.
    def var c-productship               as char no-undo.
    def var c-quantityamount            as char no-undo.
    def var c-invoicedamount            as char no-undo.
    def var c-deliveryto                as char no-undo.
    def var c-physicaladdress-ent       as char no-undo. /* endereco de entrega */
    def var c-address-ent               as char no-undo.
    def var c-occollection              as char no-undo.
    def var c-oc                        as char no-undo.
    def var c-orderitemvaluecollection  as char no-undo.
    def var c-orderitemvalue            as char no-undo.
    def var c-monetaryamount-orderitem  as char no-undo.
    def VAR c-MonetaryAmount            as char no-undo.
    def var c-freighttype               as char no-undo.
    def var i-freightmethod             as int  no-undo.
    def var c-endereco                  as char no-undo.
    def var c-bairro                    as char no-undo.
    def var c-cidade                    as char no-undo.
    def var c-estado                    as char no-undo.
    def var c-cep                       as char no-undo.
    def var c-pais                      as char no-undo.
    def var c-sit-item                  as char no-undo.
    def var c-sit-pre-it                as char no-undo.
    def var c-sit-com-it                as char no-undo.
    def var c-sit-preco-it              as char no-undo.
    def var c-tipo-atend                as char no-undo.
    def var c-businessunitcollection    as char no-undo.
    def var c-businessunit              as char no-undo.


    assign c-productlineitemcollection = AddElement(c-order,"ProductLineItemCollection")
           de-total                    = 0
           c-freighttype               = if  ped-venda.cidade-cif <> ""
                                         then "CIF"
                                         else "FOB".   

    for each  ped-item no-lock
        where ped-item.nome-abrev = ped-venda.nome-abrev
        and   ped-item.nr-pedcli  = ped-venda.nr-pedcli:

        find item where item.it-codigo = ped-item.it-codigo no-lock no-error.

        find loc-entr
             where loc-entr.nome-abrev  = ped-venda.nome-abrev
             and   loc-entr.cod-entrega = ped-item.cod-entrega
             no-lock no-error.

        if  avail loc-entr then
            assign c-endereco = loc-entr.endereco
                   c-bairro   = loc-entr.bairro
                   c-cidade   = loc-entr.cidade
                   c-estado   = loc-entr.estado
                   c-cep      = loc-entr.cep
                   c-pais     = loc-entr.pais.
        else 
            assign c-endereco = ped-venda.local-entreg
                   c-bairro   = ped-venda.bairro
                   c-cidade   = ped-venda.cidade
                   c-estado   = ped-venda.estado
                   c-cep      = ped-venda.cep
                   c-pais     = ped-venda.pais. 

        assign c-sit-item     = {diinc/i03di149.i 04 ped-item.cod-sit-item}
               c-sit-pre-it   = {diinc/i04di149.i 04 ped-item.cod-sit-pre}
               c-sit-com-it   = {diinc/i05di154.i 04 ped-item.cod-sit-com}
               c-sit-preco-it = {diinc/i05di154.i 04 ped-item.cod-sit-preco}
               c-tipo-atend   = {diinc/i05di149.i 04 ped-item.tipo-atend}.

        assign
        c-productlineitem = AddElement(c-productlineitemcollection,"ProductLineItem")
          c-campo = AddEleInt(c-productlineitem,"SOSequentialIdentification",ped-item.nr-sequencia)
          c-campo = AddEleChar(c-productlineitem,"LegacyProductIdentifier",ped-item.it-codigo)
          c-campo = AddEleChar(c-productlineitem,"ProductDescription",ITEM.desc-item).

        if  ped-item.cod-refer <> "" then
            assign c-campo = AddEleChar(c-productlineitem,"LegacyProductReference",ped-item.cod-refer).

        assign
        c-campo = AddEleChar(c-productlineitem,"OrderItemStatus",c-sit-item)
        c-campo = AddEleChar(c-productlineitem,"desc-cancela", ped-item.desc-cancela)
        c-campo = AddEleInt(c-productlineitem,"cod-mot-canc-cot", ped-item.cod-mot-canc-cot)
        c-campo = AddEleDate(c-productlineitem,"dt-canseq",ped-item.dt-canseq,"")
        c-campo = AddEleChar(c-productlineitem,"user-canc",ped-item.user-canc)
        c-campo = AddEleChar(c-productlineitem,"InventoryAllocationStatus",c-sit-pre-it)
        c-campo = AddEleChar(c-productlineitem,"CommercialEvaluationStatus",c-sit-com-it)
        c-campo = AddEleChar(c-productlineitem,"PriceEvaluationStatus",c-sit-preco-it)
        c-campo = AddEleDate(c-productlineitem,"ValidityEndDate",ped-item.dt-max-fat,"")
        c-campo = AddEleDeci(c-productlineitem,"qt-pedida",ped-item.qt-pedida)
        c-campo = AddEleDeci(c-productlineitem,"qt-atendida",ped-item.qt-atendida)
        c-campo = AddEleChar(c-productlineitem,"PriceTable",ped-item.nr-tabpre)   
        c-campo = AddEleDeci(c-productlineitem,"TotalNetWeight",ITEM.peso-liquido)
        c-campo = AddEleChar(c-productlineitem,"nat-operacao",ped-item.nat-operacao)
        c-campo = AddEleChar(c-productlineitem,"cod-entrega",ped-item.cod-entrega)
        c-campo = AddEleChar(c-productlineitem,"log-usa-tabela-desconto",if ped-item.log-usa-tabela-desconto
                                                                         then "Sim"
                                                                         else "NÆo")
        c-campo = AddEleDeci(c-productlineitem,"val-pct-desconto-tab-preco",ped-item.val-pct-desconto-tab-preco)
        c-campo-aux = replace(ped-item.des-pct-desconto-inform, ",", ".")
          c-campo = AddEleChar(c-productlineitem,"des-pct-desconto-inform",c-campo-aux)
        /*c-campo = AddEleDeci(c-productlineitem,"val-desconto-inform",ped-item.val-desconto-inform)*/
        c-campo = AddEleChar(c-productlineitem,"conta-contabil",substr(ped-item.char-2,11,17))
        c-campo = AddEleChar(c-productlineitem,"custo-contabil",substr(ped-item.char-2,29,12))
        c-campo = AddEleChar(c-productlineitem,"class-fiscal",substr(ped-item.char-2,1,8))
        c-campo = AddEleChar(c-productlineitem,"tipo-atend",c-tipo-atend)
        c-campo = AddEleDate(c-productlineitem,"dt-entrega",ped-item.dt-entrega,"")
        c-campo = AddEleDate(c-productlineitem,"dt-entorig",ped-item.dt-entorig,"")
        c-campo = AddEleChar(c-productlineitem,"inf-fat-qtfam",if ped-item.ind-fat-qtfam = no
                                                               then "Unidade do Item"
                                                               else if ped-item.ind-fat-qtfam = yes
                                                                    then "Unidade Família Materiais"
                                                                    else "Unidade do Cliente")
        c-campo = AddEleDate(c-productlineitem,"dt-min-fat",ped-item.dt-min-fat,"")
        c-campo = AddEleDeci(c-productlineitem,"per-minfat",ped-item.per-minfat)
        c-campo = AddEleChar(c-productlineitem,"ind-icm-ret",if ped-item.ind-icm-ret
                                                             then "Sim"
                                                             else "NÆo")
        c-campo = AddEleDeci(c-productlineitem,"per-des-icms",ped-item.per-des-icms)
        c-campo = AddEleChar(c-productlineitem,"observacao",ped-item.observacao).

        assign
        c-occollection = AddElement(c-productlineitem,"OCCollection")
         c-oc          = AddElement(c-occollection,"OC")
           c-campo     = AddEleChar(c-oc,"OCIdentifier",ped-item.cod-ord-compra)
           c-campo     = AddEleInt(c-oc,"OCParcel",ped-item.parcela).

      /*c-monetaryamount-item = AddElement(c-productlineitem,"MonetaryAmount")
          c-campo-aux         = replace(string(ped-item.vl-preuni), ",", ".")
          c-campo             = AddEleChar(c-monetaryamount-item,"Amount",c-campo-aux)
          c-campo             = AddEleInt(c-monetaryamount-item,"LegacyCurrencyCode",ped-venda.mo-codigo)*/

        for each  ped-ent no-lock
            where ped-ent.nr-pedcli    = ped-item.nr-pedcli
            and   ped-ent.it-codigo    = ped-item.it-codigo 
            and   ped-ent.cod-refer    = ped-item.cod-refer 
            and   ped-ent.nr-sequencia = ped-item.nr-sequencia
            and   ped-ent.nome-abrev   = ped-item.nome-abrev:

         /* FOI ASSUMIDO QUE, ASSIM COMO O CC0305 SEMPRE IMPRIME OS PEDIDOS EM MOEDA CORRENTE, NO XML
            TAMBEM O VALOR DO PEDIDO IRA EM MOEDA CORRENTE. */
            if  ped-venda.mo-codigo = 0 then
                assign de-preco-unit = ped-item.vl-preuni.
            else
                run "cdp/cd0812.p" (input ped-venda.mo-codigo,
                                    input 0,  /* moeda para conversao */
                                    input ped-item.vl-preuni,
                                    input today,
                                    output de-preco-unit).

            if  de-preco-unit = ? then
                assign de-preco-unit = 0.

            assign
            de-total = de-total + ped-ent.qt-pedida * de-preco-unit
            c-productshipcollection = AddElement(c-productlineitem,"ProductShipCollection")
              c-productship = AddElement(c-productshipcollection,"ProductShip")
                c-campo = AddEleChar(c-productship,"LegacyLocationIdentifier",ped-venda.cod-estabel)
                c-campo = AddEleInt(c-productship,"nr-programa",ped-ent.nr-programa)
                c-campo = AddEleChar(c-productship,"nr-progcli",ped-ent.nr-progcli)
                c-campo = AddEleInt(c-productship,"nr-versao",ped-ent.nr-versao )
                c-campo = AddEleInt(c-productship,"nr-entrega",ped-ent.nr-entrega )
                c-campo = AddEleDate(c-productship,"RequestDeliveryDate",ped-ent.dt-entrega-prim,"")
                /*c-campo = AddEleChar(c-productship,"LegacyShipmentTermsCode",c-freighttype)*/ .

            if  ped-ent.observacao <> "" then
                assign c-campo = AddEleChar(c-productship,"Comment",ped-ent.observacao).

            assign
            c-quantityamount = AddElement(c-productship,"QuantityAmount")
              c-campo-aux = replace(string(ped-ent.qt-pedida), ",", ".")
              c-campo = AddEleChar(c-quantityamount,"Quantity",c-campo-aux)
              c-campo = AddEleChar(c-quantityamount,"LegacyUnitOfMeasure",item.un)
            /*c-invoicedamount = AddElement(c-productship,"InvoicedAmount")
              c-campo-aux = replace(string(ped-ent.qt-atendida), ",", ".")
              c-campo = AddEleChar(c-invoicedamount,"Quantity",c-campo-aux)
              c-campo = AddEleChar(c-invoicedamount,"LegacyUnitOfMeasure",item.un)*/
            c-deliveryto = AddElement(c-productship,"DeliveryTo")
              c-physicaladdress-ent = AddElement(c-deliveryto,"PhysicalAddress")
                c-campo = AddEleInt(c-physicaladdress-ent,"LegacyLocationIdentifier",ped-venda.cod-emitente)
                c-address-ent = AddElement(c-physicaladdress-ent,"Address")
                  c-campo = AddEleChar(c-address-ent,"AddressLine1",c-endereco)
                  c-campo = AddEleChar(c-address-ent,"CityName",c-cidade)
                  c-campo = AddEleChar(c-address-ent,"DistrictName",c-bairro)
                  c-campo = AddEleChar(c-address-ent,"StateCode",c-estado)
                  c-campo = AddEleChar(c-address-ent,"NationalPostalCode",c-cep)
                  c-campo = AddEleChar(c-address-ent,"LegacyCountryCode",c-pais)
                  c-campo = AddEleChar(c-address-ent,"AddressCode",ped-item.cod-entrega).

            /* Alterado para ficar abaixo da Tag Order
            assign
            c-carrierinformation = AddElement(c-productship,"CarrierInformation")
              c-campo = AddEleInt(c-carrierinformation,"LegacyLocationIdentifier",IF AVAIL transporte THEN transporte.cod-transp ELSE 0)
              c-campo = AddEleChar(c-carrierinformation,"CarrierName",ped-venda.nome-transp).

            if AVAIL transporte AND transporte.contato <> "" then
                assign
                c-contactinformation-transp = AddElement(c-carrierinformation,"ContactInformation")
                  c-campo = AddEleChar(c-contactinformation-transp,"ContactName",transporte.contato)
                  c-campo = AddEleChar(c-contactinformation-transp,"TelephoneNumber",transporte.telefone)
                  c-campo = AddEleChar(c-contactinformation-transp,"EmailAddress",transporte.e-mail).
            */

            /* Alterado para ficar abaixo da Tag ProductLineItem
            assign
            c-occollection = AddElement(c-productship,"OCCollection")
              c-oc = AddElement(c-occollection,"OC")
                c-campo = AddEleChar(c-oc,"OCIdentifier",ped-item.cod-ord-compra)
                c-campo = AddEleInt(c-oc,"OCParcel",ped-item.parcela).
            */
        end.

        /* Unidade de Neg¢cio do Item */
        ASSIGN c-businessunitcollection = AddElement(c-productlineitem,"BusinessUnitCollection").

        FOR EACH  unid-neg-ped NO-LOCK
            WHERE unid-neg-ped.nome-abrev   = ped-item.nome-abrev   
            AND   unid-neg-ped.nr-pedcli    = ped-item.nr-pedcli    
            AND   unid-neg-ped.nr-sequencia = ped-item.nr-sequencia 
            AND   unid-neg-ped.it-codigo    = ped-item.it-codigo
            AND   unid-neg-ped.cod-refer    = ped-item.cod-refer:

   		    ASSIGN c-businessunit = AddElement(c-businessunitcollection, "BusinessUnit")
                   c-campo        = AddEleChar(c-businessunit, "BusinessUnitCode"     , unid-neg-ped.cod_unid_negoc)
                   c-campo        = AddEleDeci(c-businessunit, "BusinessUnitRate"     , unid-neg-ped.perc-unid-neg)
                   c-campo        = AddEleDeci(c-businessunit, "BusinessUnitValue"    , unid-neg-ped.val-unid-neg)
                   c-campo        = AddEleDeci(c-businessunit, "BusinessUnitQuantity" , unid-neg-ped.qtd-unid-neg).
        END.

        assign c-orderitemvaluecollection = AddElement(c-productlineitem,"OrderItemValueCollection").

        /* 2 - % de Desconto */
        if  ped-item.per-des-item > 0 then
            assign 
            c-orderitemvalue = AddElement(c-orderitemvaluecollection,"OrderItemValue")    
              c-campo = AddEleChar(c-orderitemvalue,"ValuesIdentifier","2")
              c-campo = AddEleDeci(c-orderitemvalue,"Percent",ped-item.per-des-item).

        /* 4 - Valor do Desconto */
        if  ped-item.val-desconto-inform > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")    
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","4")
              c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.val-desconto-inform)
                c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        /* 15 - Alíquota IPI*/
        if  ped-item.aliquota-ipi > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")    
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","15")
              c-campo = AddEleDeci(c-orderitemvalue,"Percent",ped-item.aliquota-ipi).

        /* 17 - Alíquota ISS*/
        if  ped-item.dec-2 > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")    
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","17")
              c-campo = AddEleDeci(c-orderitemvalue,"Percent",ped-item.dec-2).

        /* 46 - Preço de Tabela FOB (sem frete incluso) */
        if  ped-item.vl-pretab > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")     
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","46")
              c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-pretab)
                c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        /* 53 - Preço de Tabela + Taxa Financeira */  
        if  ped-item.vl-preori > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")     
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","53")
              c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
                c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-preori)
                c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        /* 28 - Preço de Tabela + Taxa Financeira - Descontos - Impostos */
        if  ped-item.vl-preuni > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")    
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","28")
              c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount") 
              c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-preuni)
              c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).

        /* 29 - (Valor Total do Item = (Preço Unitário + Impostos) * Quantidade */ 
        if  ped-item.vl-tot-it > 0 then
            assign 
            c-OrderItemValue = AddElement(c-OrderItemValueCollection,"OrderItemValue")    
              c-campo = AddEleChar(c-OrderItemValue,"ValuesIdentifier","29")
              c-MonetaryAmount = AddElement(c-OrderItemValue,"MonetaryAmount")
              c-campo = AddEleDeci(c-MonetaryAmount,"Amount",ped-item.vl-tot-it)
              c-campo = AddEleInt(c-MonetaryAmount,"LegacyCurrencyCode",ped-venda.mo-codigo).
    end.
end.

procedure pi-cria-detalhes-pedido.
    def var c-billto                    as char no-undo.
    def var c-physicaladdress-cob       as char no-undo. /*endereco de cobranca*/
    def var c-address-cob               as char no-undo.
    def var c-contactinformation-cob    as char no-undo. /*contato do endereco de cobranca*/
    def var c-ordervaluecollection      as char no-undo.
    def var c-ordervalue                as char no-undo.
    def var c-monetaryamount-ordervalue as char no-undo.
    def var c-fromrole                  as char no-undo.
    def var c-contactinformation-orig   as char no-undo. /*contato de quem originou o pedido*/
    def var c-address-orig              as char no-undo. /*endereco de quem originou o pedido*/
    def var c-torole                    as char no-undo.
    def var c-contactinformation-dest   as char no-undo. /*contato de quem recebera o pedido (destino)*/
    def var c-address-dest              as char no-undo. /*endereco de quem recebera o pedido (destino)*/
    def var i-cobranca                  as int  no-undo.
    def var c-endereco                  as char no-undo.
    def var c-cidade                    as char no-undo.
    def var c-bairro                    as char no-undo.
    def var c-estado                    as char no-undo.
    def var c-cep                       as char no-undo.
    def var c-pais                      as char no-undo.
    def var c-contato                   as char no-undo.
    def var c-e-mail                    as char no-undo.
    def var c-telefone                  as char no-undo.
    def var c-origem                    as char no-undo.

    find emitente where emitente.cod-emitente = ped-venda.cod-emitente no-lock no-error.

    if  emitente.end-cobranca > 0 then do:
        assign i-cobranca = emitente.end-cobranca.

       find emitente where emitente.cod-emitente = i-cobranca no-lock no-error.

       assign c-endereco = emitente.endereco
              c-cidade   = emitente.cidade
              c-bairro   = emitente.bairro
              c-estado   = emitente.estado
              c-cep      = emitente.cep
              c-pais     = emitente.pais     
              c-contato  = emitente.contato[1]
              c-e-mail   = emitente.e-mail
              c-telefone = emitente.telefone[1].
    end.
    else 
        assign i-cobranca = ped-venda.cod-emitente
               c-endereco = emitente.endereco-cob
               c-cidade   = emitente.cidade-cob
               c-bairro   = emitente.bairro-cob
               c-estado   = emitente.estado-cob
               c-cep      = emitente.cep-cob
               c-pais     = emitente.pais-cob     
               c-contato  = emitente.contato[1]
               c-e-mail   = emitente.e-mail
               c-telefone = emitente.telefone[1].

    assign        
    c-billto = AddElement(c-order,"BillTo")
      c-physicaladdress-cob = AddElement(c-billto,"PhysicalAddress")
        c-campo = AddEleInt(c-physicaladdress-cob,"LegacyLocationIdentifier",i-cobranca)
        c-address-cob = AddElement(c-physicaladdress-cob,"Address")
          c-campo = AddEleChar(c-address-cob,"AddressLine1",c-endereco)
          c-campo = AddEleChar(c-address-cob,"CityName",c-cidade)
          c-campo = AddEleChar(c-address-cob,"DistrictName",c-bairro)
          c-campo = AddEleChar(c-address-cob,"StateCode",c-estado)
          c-campo = AddEleChar(c-address-cob,"NationalPostalCode",c-cep)
          c-campo = AddEleChar(c-address-cob,"LegacyCountryCode",c-pais)
          c-campo = AddEleChar(c-address-cob,"AddressCode","")
      c-contactinformation-cob = AddElement(c-billto,"ContactInformation")
        c-campo = AddEleChar(c-contactinformation-cob,"ContactName",c-contato)
        c-campo = AddEleChar(c-contactinformation-cob,"EmailAddress",c-e-mail)
        c-campo = AddEleChar(c-contactinformation-cob,"TelephoneNumber",c-telefone).

    assign c-ordervaluecollection = AddElement(c-order,"OrderValueCollection").

    /* 26 - Valor Total do Pedido*/
    if  ped-venda.vl-tot-ped > 0 then
        assign
        c-ordervalue = AddElement(c-ordervaluecollection,"OrderValue")
          c-campo = AddEleChar(c-ordervalue,"ValuesIdentifier","26")  
          c-monetaryamount-ordervalue = AddElement(c-ordervalue,"MonetaryAmount") /*c-campo-aux = replace(string(de-total), ",", ".")*/ /*NeoGrid*/ /*c-campo = AddEleChar(c-monetaryamount-ordervalue,"Amount",c-campo-aux)*/ /*NeoGrid*/
            c-campo = AddEleDeci(c-monetaryamount-ordervalue,"Amount",ped-venda.vl-tot-ped)
            c-campo = AddEleInt(c-monetaryamount-ordervalue,"LegacyCurrencyCode",ped-venda.mo-codigo).

    /* 1 - Valor Total das Mercadorias sem IPI*/
    if  ped-venda.vl-liq-ped > 0 then
        assign
        c-ordervalue = AddElement(c-ordervaluecollection,"OrderValue")
          c-campo = AddEleChar(c-ordervalue,"ValuesIdentifier","1")  
          c-monetaryamount-ordervalue = AddElement(c-ordervalue,"MonetaryAmount")
            c-campo = AddEleDeci(c-monetaryamount-ordervalue,"Amount",ped-venda.vl-liq-ped)
            c-campo = AddEleInt(c-monetaryamount-ordervalue,"LegacyCurrencyCode",ped-venda.mo-codigo).

    assign c-origem = {diinc/i07di159.i 04 ped-venda.ind-orig-entrada}.
           c-campo  = AddEleChar(c-order,"OrderOrigin",c-origem).

    /* Dados Vendor */
    /* LOHMANN 13/12/2007 - FO 1796.060 
       O programa estava lendo a tabela pd-vendor, e isso estava impactando os clientes que nÆo
       possuem o m¢dulo de Vendor. Foi criado um sub-programa (ANEPD016A) para retornar uma temp-table
       com as informa‡äes, caso o m¢dulo de vendor esteja implantado */
    IF  AVAIL param-global AND param-global.modulo-05 THEN DO:

        EMPTY TEMP-TABLE tt-pd-vendor.

        RUN "adapters/neogrid/pdp/anepd016a.p" (INPUT  ROWID(ped-venda),
                                                OUTPUT TABLE tt-pd-vendor).

        FOR FIRST tt-pd-vendor NO-LOCK:
            ASSIGN
                c-vendor = AddElement(c-order   , "VendorInformation")
                c-campo  = AddEleDeci(c-vendor  , "CustomerTax"         , tt-pd-vendor.taxa-cliente)
                c-campo  = AddEleInt (c-vendor  , "PaymentCondition"    , tt-pd-vendor.cod-cond-cli)
                c-campo  = AddEleInt (c-vendor  , "DaysBase"            , tt-pd-vendor.dias-base)
                c-campo  = AddEleDate(c-vendor  , "BaseDate"            , tt-pd-vendor.data-base, "")
                c-campo  = AddEleDeci(c-vendor  , "ProvisionEquation"   , tt-pd-vendor.vl-equal-prov)
                c-campo  = AddEleInt (c-vendor  , "PaymentConditionAux" , tt-pd-vendor.cod-cond-cli-aux)
                c-campo  = AddEleInt (c-vendor  , "Portador"            , ped-venda.cod-portador)
                c-campo  = AddEleInt (c-vendor  , "Modalidade"          , ped-venda.modalidade).
        END.
    END.

    find estabelec where estabelec.cod-estabel = ped-venda.cod-estabel  no-lock no-error.
    find emitente  where emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.

    assign
    c-fromrole = AddElement(c-orderupdate,"FromRole")
      c-campo = AddEleChar(c-fromrole,"LegacyLocationIdentifier",ped-venda.cod-estabel)
      c-campo = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","SELLER")
      c-contactinformation-orig = AddElement(c-fromrole,"ContactInformation")
        c-campo = AddEleChar(c-contactinformation-orig,"ContactName",emitente.contato[1])
        c-campo = AddEleChar(c-contactinformation-orig,"EmailAddress",emitente.e-mail)
        c-campo = AddEleChar(c-contactinformation-orig,"TelephoneNumber",emitente.telefone[1])
      c-address-orig = AddElement(c-fromrole,"Address")
        c-campo = AddEleChar(c-address-orig,"AddressLine1",emitente.endereco)
        c-campo = AddEleChar(c-address-orig,"CityName",emitente.cidade)
        c-campo = AddEleChar(c-address-orig,"DistrictName",emitente.bairro)
        c-campo = AddEleChar(c-address-orig,"StateCode",emitente.estado)
        c-campo = AddEleChar(c-address-orig,"NationalPostalCode",emitente.cep)
        c-campo = AddEleChar(c-address-orig,"LegacyCountryCode",emitente.pais)
        c-campo = AddEleChar(c-address-orig,"AddressCode","").

    find emitente where emitente.cod-emitente = ped-venda.cod-emitente no-lock no-error.

    assign c-torole = AddElement(c-orderupdate,"ToRole")
             c-campo = AddEleInt(c-torole,"LegacyLocationIdentifier",ped-venda.cod-emitente)
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
               c-campo = AddEleChar(c-address-dest,"AddressCode",ped-venda.cod-entrega).
end.

/* Fim */
