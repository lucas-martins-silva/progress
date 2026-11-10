/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD015 2.00.01.005 } /*** "010105" 14/07/2026 15:13:26  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd015 MAN}
&ENDIF

/********************************************************************************
** Programa : anepd015.p
** Funá∆o   : Receiver de Pedido de Venda
** Data     : 07/2003 (nova vers∆o para EMS 2.04)
********************************************************************************/
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

&IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
  &GLOBAL-DEFINE ped-venda.nr-pedido-crm    ped-venda.nr-pedido-crm
  &GLOBAL-DEFINE tt-ped-venda.nr-pedido-crm tt-ped-venda.nr-pedido-crm
&ELSE
  &GLOBAL-DEFINE ped-venda.nr-pedido-crm    substring(ped-venda.char-2,1,9)
  &GLOBAL-DEFINE tt-ped-venda.nr-pedido-crm substring(tt-ped-venda.char-2,1,9)
&ENDIF

{adapters/neogrid/include/anein005.i}
{adapters/neogrid/ftp/aneft002.i} /* Definiá∆o temp-table tt-erro-neogrid */

{dibo/bodi159.i tt-ped-venda}
{dibo/bodi159.i tt-ped-venda-sdf}
{dibo/bodi159.i tt-ped-venda-xml}
{dibo/bodi154.i tt-ped-item}
{dibo/bodi154.i tt-ped-item-sdf}
{dibo/bodi154.i tt-ped-item-xml}
{dibo/bodi154.i tt-ped-item-bo}
{dibo/bodi018.i tt-cond-ped}
{dibo/bodi018.i tt-cond-ped-aux}
{dibo/bodi018.i tt-cond-ped-bo}
{dibo/bodi149.i tt-ped-ent}
{dibo/bodi149.i tt-ped-ent-bo}
{dibo/bodi157.i tt-ped-repre}
{dibo/bodi157.i tt-ped-repre-bo}
{dibo/bodi157.i tt-ped-repre-consiste}
{dibo/bodi154.i tt-ped-item-consiste}
{dibo/bodi018.i tt-cond-ped-consiste}
{dibo/bodi291.i tt-unid-neg-ped}

/*EMS2 X EMS5 */
{btb/btb009za.i}

def temp-table tt-pd-vendor no-undo
    field data-base    as date
    field dias-base    as int format ">>>9"
    field cod-cond-pag as int format ">9"
    field taxa-cliente as dec format ">>9,9999".

{method/dbotterr.i} /* RowErrors */

define temp-table RowErrorsItem       no-undo like RowErrors.
define temp-table RowErrorsPedRepre   no-undo like RowErrors.
define temp-table RowErrorsPedEnt     no-undo like RowErrors.
define temp-table RowErrorsCondPed    no-undo like RowErrors.

define variable h-bodi154sdf as handle no-undo.
define variable h-bodi159sdf as handle no-undo.
define variable h-bodi159    as handle no-undo.
define variable h-bodi154    as handle no-undo.
define variable h-bodi157    as handle no-undo.
define variable h-bodi149    as handle no-undo.
define variable h-bodi757    as handle no-undo.
define variable h-bodi154can as handle no-undo.
define variable h-bodi159rct as handle no-undo.
define variable h-bodi159sus as handle no-undo.
define variable h-bodi159can as handle no-undo.
define variable h-bodi018    as handle no-undo.
define variable h-bodi159com as handle no-undo.
define variable h-bodi159ven as handle no-undo.
define variable h-btb009za   as handle no-undo.

define variable i-nr-pedido             as int   no-undo.
define variable r-ped-venda             as rowid no-undo.
define variable r-ped-item              as rowid no-undo.
define variable c-DocIdentifier         as char  no-undo.
define variable c-GlobalOrderChangeCode as char  no-undo.
define variable c-modalidade            as char  no-undo.
define variable i-cod-emit-ext          as int   no-undo.
define variable i-perc                  as dec   no-undo.
define variable c-unid-negoc            as char  no-undo.
define variable l-achou-reg             as log   no-undo.
DEFINE VARIABLE l-tp-pedido             AS LOG   NO-UNDO.

DEF BUFFER b-ped-venda FOR ped-venda.
ASSIGN l-tp-pedido       = CAN-FIND(FIRST funcao
                           WHERE funcao.cd-funcao = "spp-tp-pedido":U
                           AND   funcao.ativo).

find first param-global no-lock no-error.
run pi-limpa-tt.
create tt-ped-venda.
run ReadXML.

procedure pi-limpa-tt:
    for each tt-ped-venda:
        delete tt-ped-venda.
    end.
    for each tt-ped-item:
        delete tt-ped-item.
    end.
    for each tt-cond-ped:
        delete tt-cond-ped.
    end.
    for each tt-cond-ped-aux:
        delete tt-cond-ped-aux.
    end.
    for each tt-ped-ent:
        delete tt-ped-ent.
    end.
    for each tt-ped-repre:
        delete tt-ped-repre.
    end.
    for each tt-pd-vendor:
        delete tt-pd-vendor.
    end.
    for each RowErrorsItem:
        delete RowErrorsItem.
    end.
    for each RowErrorsPedRepre:
        delete RowErrorsPedRepre.
    end.
    for each RowErrorsPedEnt:
        delete RowErrorsPedEnt.
    end.
    for each RowErrorsCondPed:
        delete RowErrorsCondPed.
    end.
    for each tt-erro-neogrid:
        delete tt-erro-neogrid.
    end.
    FOR EACH tt-unid-neg-ped:
        DELETE tt-unid-neg-ped.
    END.
end procedure.

procedure ReadXML:
    def var i-cont                          as int  no-undo.
    def var i-cont-1                        as int  no-undo.
    def var i-cont-2                        as int  no-undo.
    def var i-cont-3                        as int  no-undo.
    def var i-cont-4                        as int  no-undo.
    def var c-root                          as char no-undo.
    def var c-message                       as char no-undo.
    def var c-OrderUpdate                   as char no-undo.
    def var c-Order                         as char no-undo.
    def var i-nr-pedido-crm                 as int  no-undo.
    def var c-OrderStatus                   as char no-undo.
    def var c-InventoryAllocationStatus     as char no-undo.
    def var c-CreditEvaluationStatus        as char no-undo.
    def var c-CommercialEvaluationStatus    as char no-undo.
    def var c-PriceEvaluationStatus         as char no-undo.
    def var c-OrderPriceType                as char no-undo.
    def var c-esp-ped                       as char no-undo.
    def var c-cod-des-merc                  as char no-undo.
    def var c-OrderIdentifier               as char no-undo.
    def var c-tip-cob-desp                  as char no-undo.
    def var c-vendor                        as char no-undo.
    def var c-PaymentPlan                   as char no-undo.
    def var c-PaymentCollection             as char no-undo.
    def var c-num-PaymentCollection         as char no-undo.
    def var c-Payment                       as char no-undo.
    def var c-cod-vencto                    as char no-undo.
    def var c-MonetaryAmount                as char no-undo.
    def var c-colecao-representante         as char no-undo.
    def var c-num-colecao-representante     as char no-undo.
    def var c-representante                 as char no-undo.
    def var i-cont-aux                      as int  no-undo.
    def var c-ProductLineItemCollection     as char no-undo.
    def var c-num-ProductLineItemCollection as char no-undo.
    def var c-ProductLineItem               as char no-undo.
    def var c-cod-sit-item                  as char no-undo.
    def var c-tipo-atend                    as char no-undo.
    def var c-ProductShipCollection         as char no-undo.
    def var c-num-ProductShipCollection     as char no-undo.
    def var c-ProductShip                   as char no-undo.
    def var c-QuantityAmount                as char no-undo.
    def var c-InvoicedAmount                as char no-undo.
    def var c-DeliveryTo                    as char no-undo.
    def var c-PhysicalAddress               as char no-undo.
    def var c-Address                       as char no-undo.
    def var c-QuoteCollection               as char no-undo.
    def var c-num-QuoteCollection           as char no-undo.
    def var c-Quote                         as char no-undo.
    def var c-numQuoteCollection            as char no-undo.
    def var c-CarrierInformation            as char no-undo.
    def var c-OCCollection                  as char no-undo.
    def var num-c-OCCollection              as char no-undo.
    def var c-OC                            as char no-undo.
    def var c-OrderItemValueCollection      as char no-undo.
    def var num-c-OrderItemValueCollection  as char no-undo.
    def var c-OrderItemValue                as char no-undo.
    def var c-OrderValueCollection          as char no-undo.
    def var num-c-OrderValueCollection      as char no-undo.
    def var c-OrderValue                    as char no-undo.
    def var c-FromRole                      as char no-undo.
    def var c-ToRole                        as char no-undo.
    def var c-OrderOrigin                   as char no-undo.
    def var i-cod-transp                    as int  no-undo.
    def var c-BusinessUnitCollection        as char no-undo.
    def var c-num-BusinessUnitCollection    as char no-undo.
    def var c-BusinessUnit                  as char no-undo.

    assign
    c-root = GetRoot()
      c-DocIdentifier = Getsonval(c-root,"DocIdentifier")
      c-message       = Get(c-root,"Message")
        c-OrderUpdate = Get(c-message,"OrderUpdate")
          c-GlobalOrderChangeCode = Getsonval(c-OrderUpdate,"GlobalOrderChangeCode")
          c-Order     = Get(c-OrderUpdate,"Order").

    assign tt-ped-venda.nome-abrev = Getsonval(c-Order,"nome-abrev").
    assign i-cod-emit-ext          = int(Getsonval(c-Order,"cod-emit-externo")).
    assign tt-ped-venda.nr-pedcli  = Getsonval(c-Order,"OrderIdentifier").
    assign i-nr-pedido-crm         = int(Getsonval(c-Order,"nr-pedido-crm")).

    find ped-venda
         where ped-venda.nome-abrev = tt-ped-venda.nome-abrev
         and   ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
         no-lock no-error.

    /* Na situaá∆o de Eliminaá∆o de Pedido de Venda, n∆o Ç necess†rio ler todo o xml, 
       somente a chave da ped-venda para ent∆o eliminar o pedido */
    if  c-GlobalOrderChangeCode <> 'DELETE':U then do:

        assign
        c-OrderStatus            = Getsonval(c-Order,"OrderStatus")
        tt-ped-venda.cod-sit-ped = if avail ped-venda 
                                   then if c-OrderStatus <> "":U
                                        then {diinc/i03di149.i 06 c-OrderStatus}
                                        else ped-venda.cod-sit-ped
                                   else if  c-OrderStatus = "":U  /* Situaá∆o do Pedido */
                                        then 0
                                        else {diinc/i03di149.i 06 c-OrderStatus}.
        assign
        c-InventoryAllocationStatus = Getsonval(c-Order,"InventoryAllocationStatus")
        tt-ped-venda.cod-sit-pre    = if avail ped-venda
                                      then if c-InventoryAllocationStatus <> "":U
                                           then {diinc/i04di149.i 06 c-InventoryAllocationStatus}
                                           else ped-venda.cod-sit-pre
                                      else if c-InventoryAllocationStatus = "":U  /* Situaá∆o Alocaá∆o */
                                           then tt-ped-venda.cod-sit-pre
                                           else {diinc/i04di149.i 06 c-InventoryAllocationStatus}
        c-CreditEvaluationStatus    = Getsonval(c-Order,"CreditEvaluationStatus")
        tt-ped-venda.cod-sit-aval   = if avail ped-venda
                                      then if c-CreditEvaluationStatus <> "":U
                                           then {diinc/i03di159.i 06 c-CreditEvaluationStatus}
                                           else ped-venda.cod-sit-aval
                                      else if c-CreditEvaluationStatus = "":U  /* Situaá∆o Avaliaá∆o CrÇdito */
                                           then tt-ped-venda.cod-sit-aval
                                           else {diinc/i03di159.i 06 c-CreditEvaluationStatus}.
        assign
        c-CommercialEvaluationStatus = Getsonval(c-Order,"CommercialEvaluationStatus")
        tt-ped-venda.cod-sit-com     = if avail ped-venda
                                       then if c-CommercialEvaluationStatus <> "":U
                                            then {diinc/i05di154.i 06 c-CommercialEvaluationStatus}
                                            else ped-venda.cod-sit-com
                                       else if c-CommercialEvaluationStatus = "":U  /* Situaá∆o Avaliaá∆o Comercial */
                                            then 0
                                            else {diinc/i05di154.i 06 c-CommercialEvaluationStatus}.
        assign
        c-PriceEvaluationStatus      = Getsonval(c-Order,"PriceEvaluationStatus")
        tt-ped-venda.cod-sit-preco   = if avail ped-venda
                                       then if c-PriceEvaluationStatus <> "":U
                                            then {diinc/i05di154.i 06 c-PriceEvaluationStatus}
                                            else ped-venda.cod-sit-preco
                                       else if c-PriceEvaluationStatus = "":U  /* Situaá∆o Avaliaá∆o Preáo */
                                            then tt-ped-venda.cod-sit-preco
                                            else {diinc/i05di154.i 06 c-PriceEvaluationStatus}.
        assign
        tt-ped-venda.dt-emissao = Getsondate(c-Order,"RegisterDate")
        tt-ped-venda.dt-inivig  = Getsondate(c-Order,"dt-inivig")
        tt-ped-venda.dt-fimvig  = Getsondate(c-Order,"ValidityEndDate").

        if  AvailTag(c-Order,"Comment") then
            assign tt-ped-venda.observacoes = Getsonval(c-Order,"Comment"). /* Opcional */
    
        IF  l-tp-pedido THEN
            ASSIGN tt-ped-venda.tp-pedido = Getsonval(c-Order,"tp-pedido").
              
        ASSIGN
        c-OrderPriceType       = Getsonval(c-Order,"OrderPriceType")
        tt-ped-venda.tp-preco  = if  c-OrderPriceType = "":U  /* Tipo Preáo */
                                 then 0
                                 else {diinc/i01di145.i 06 c-OrderPriceType}.
        assign
        tt-ped-venda.nat-operacao = Getsonval(c-Order,"FiscalOperation").

        assign
        tt-ped-venda.user-impl  = if not avail ped-venda 
                                  then Getsonval(c-Order,"AdditionUser")
                                  else ped-venda.user-impl
        tt-ped-venda.dt-implant = Getsondate(c-Order,"AdditionDate").

        assign
        tt-ped-venda.dt-entrega = Getsondate(c-Order,"DeliveryDate").

        assign
        tt-ped-venda.tab-ind-fin     = dec(Getsondec(c-Order,"OrderTax"))
        c-esp-ped                    = Getsonval(c-Order,"esp-ped")
        tt-ped-venda.esp-ped         = if avail ped-venda
                                       then if c-esp-ped <> "":U
                                            then {diinc/i04di154.i 06 c-esp-ped}
                                            else ped-venda.esp-ped
                                       else if  c-esp-ped = "":U  /* EspÇcie do Pedido */
                                            then tt-ped-venda.esp-ped
                                            else {diinc/i04di154.i 06 c-esp-ped}
        tt-ped-venda.cod-canal-venda = if avail ped-venda
                                       then ped-venda.cod-canal-venda
                                       else int(Getsonval(c-Order,"cod-canal-venda")).

        assign tt-ped-venda.nr-tab-finan = if avail ped-venda
                                           then if Getsonval(c-Order,"nr-tab-finan") <> "":U
                                                then int(Getsonval(c-Order,"nr-tab-finan"))
                                                else ped-venda.nr-tab-finan
                                           else if Getsonval(c-Order,"nr-tab-finan") = "":U
                                                then 0
                                                else int(Getsonval(c-Order,"nr-tab-finan")).
        assign tt-ped-venda.nr-ind-finan = if avail ped-venda
                                           then if Getsonval(c-Order,"nr-ind-finan") <> "":U
                                                then int(Getsonval(c-Order,"nr-ind-finan"))
                                                else ped-venda.nr-ind-finan
                                           else if Getsonval(c-Order,"nr-ind-finan") = "":U
                                                then 0
                                                else int(Getsonval(c-Order,"nr-ind-finan")).
        assign tt-ped-venda.nr-tabpre    = Getsonval(c-Order,"nr-tabpre").
        assign tt-ped-venda.mo-codigo    = int(Getsonval(c-Order,"mo-codigo")).

        assign
        tt-ped-venda.val-pct-desconto-tab-preco = dec(Getsondec(c-Order,"val-pct-desconto-tab-preco"))
        tt-ped-venda.log-usa-tabela-desconto    = if  Getsonval(c-Order,"log-usa-tabela-desconto") = "Sim":U
                                                  then yes
                                                  else
                                                      if  Getsonval(c-Order,"log-usa-tabela-desconto") = "N∆o":U
                                                      then no
                                                      else if avail ped-venda
                                                           then ped-venda.log-usa-tabela-desconto
                                                           else ?
        tt-ped-venda.des-pct-desconto-inform    = Getsonval(c-Order,"des-pct-desconto-inform")
        tt-ped-venda.perc-desco1                = dec(Getsondec(c-Order,"perc-desco1"))
        tt-ped-venda.no-ab-reppri               = if avail ped-venda
                                                  then ped-venda.no-ab-reppri
                                                  else Getsonval(c-Order,"no-ab-reppri").

        if  session:numeric-format = "EUROPEAN" then
            assign tt-ped-venda.des-pct-desconto-inform = replace(string(tt-ped-venda.des-pct-desconto-inform), ".", ",").

        assign
        tt-ped-venda.nr-pedrep = Getsonval(c-Order,"nr-pedrep")
        tt-ped-venda.contato   = Getsonval(c-Order,"contato").

        find natur-oper where natur-oper.nat-operacao = tt-ped-venda.nat-operacao no-lock no-error.

        if  avail natur-oper
        and natur-oper.log-oper-triang = yes then
            assign tt-ped-venda.nome-abrev-tri = Getsonval(c-Order,"nome-abrev-tri").

        assign
        c-cod-des-merc            = Getsonval(c-Order,"cod-des-merc")
        tt-ped-venda.cod-des-merc = if avail ped-venda
                                    then if c-cod-des-merc <> "":U
                                         then {diinc/i02di159.i 06 c-cod-des-merc}
                                         else ped-venda.cod-des-merc
                                    else if c-cod-des-merc = "":U  /* Destino Mercadoria */
                                         then 0
                                         else {diinc/i02di159.i 06 c-cod-des-merc}
        tt-ped-venda.dt-entorig   = if avail ped-venda
                                    then if string(Getsondate(c-Order,"dt-entorig")) <> "":U
                                         then Getsondate(c-Order,"dt-entorig")
                                         else ped-venda.dt-entorig
                                    else if string(Getsondate(c-Order,"dt-entorig")) <> "":U
                                         then Getsondate(c-Order,"dt-entorig")
                                         else ?
        tt-ped-venda.cod-rota     = Getsonval(c-Order,"cod-rota").

        assign
        tt-ped-venda.uf-placa = Getsonval(c-Order,"uf-placa")
        tt-ped-venda.placa    = Getsonval(c-Order,"placa")
        c-CarrierInformation  = Get(c-Order,"CarrierInformation")
          i-cod-transp        = int(getsonval(c-CarrierInformation,"LegacyLocationIdentifier")).

        for first transporte fields (nome-abrev) no-lock
            where transporte.cod-transp = i-cod-transp:
        end.

        if  avail transporte then
            assign tt-ped-venda.nome-transp = transporte.nome-abrev.
        else do:
            assign tt-ped-venda.nome-transp = getsonval(c-CarrierInformation,"CarrierName").

            for first transporte fields (nome-abrev) no-lock
                where transporte.nome-abrev = tt-ped-venda.nome-transp:
            end.

            if  not avail transporte then
                assign tt-ped-venda.nome-transp = "":U.
        end.

        assign
        tt-ped-venda.nome-tr-red  = if avail ped-venda
                                    then if Getsonval(c-Order,"nome-tr-red") <> "":U
                                         then Getsonval(c-Order,"nome-tr-red")
                                         else ped-venda.nome-tr-red
                                    else Getsonval(c-Order,"nome-tr-red").

        ASSIGN
        tt-ped-venda.cidade-cif   = Getsonval(c-Order,"cidade-cif")
        tt-ped-venda.cod-mensagem = if avail ped-venda
                                    then if Getsonval(c-Order,"cod-mensagem") <> "":U
                                         then int(Getsonval(c-Order,"cod-mensagem")) 
                                         else ped-venda.cod-mensagem
                                    else int(Getsonval(c-Order,"cod-mensagem"))
        tt-ped-venda.cod-portador = if avail ped-venda
                                    then if Getsonval(c-Order,"portador") <> "":U
                                         then int(Getsonval(c-Order,"portador"))
                                         else ped-venda.cod-portador
                                    else int(Getsonval(c-Order,"portador")).

        assign
        c-modalidade            = Getsonval(c-Order,"modalidade")
        tt-ped-venda.modalidade = if avail ped-venda
                                  then if c-modalidade <> "":U
                                       then int(c-modalidade)
                                       else ped-venda.modalidade
                                  else if c-modalidade = "":U
                                       then 0
                                       else int(c-modalidade).

/*         tt-ped-venda.modalidade = if avail ped-venda
                          then if c-modalidade <> "":U
                               then {adinc/i03ad209.i 06 c-modalidade}
                               else ped-venda.modalidade
                          else if c-modalidade = "":U
                               then 0
                               else {adinc/i03ad209.i 06 c-modalidade}.
*/
        ASSIGN tt-ped-venda.dt-minfat     = Getsondate(c-Order,"dt-minfat").
        ASSIGN tt-ped-venda.dt-lim-fat    = Getsondate(c-Order,"dt-lim-fat")
        tt-ped-venda.estab-central = Getsonval(c-Order,"estab-central")
        tt-ped-venda.estab-atend   = Getsonval(c-Order,"estab-atend").

        IF l-tp-pedido THEN
            ASSIGN tt-ped-venda.tp-pedido     = Getsonval(c-Order,"tp-pedido").

        ASSIGN
        tt-ped-venda.cod-priori    = if avail ped-venda
                                     then if Getsonval(c-Order,"cod-priori") <> "":U
                                          then int(Getsonval(c-Order,"cod-priori"))
                                          else ped-venda.cod-priori
                                     else int(Getsonval(c-Order,"cod-priori")).

        assign
        tt-ped-venda.ind-lib-nota     = if Getsonval(c-Order,"ind-lib-nota") = "Sim":U
                                           then yes
                                           else if Getsonval(c-Order,"ind-lib-nota") = "N∆o":U
                                                then no
                                                else if avail ped-venda
                                                     then ped-venda.ind-lib-nota
                                                     else ?
        tt-ped-venda.ind-fat-par      = if Getsonval(c-Order,"ind-fat-par") = "Sim":U
                                        then yes
                                        else if Getsonval(c-Order,"ind-fat-par") = "N∆o":U
                                             then no
                                             else if avail ped-venda 
                                                  then ped-venda.ind-fat-par
                                                  else ?
        tt-ped-venda.per-max-canc     = if availTag(c-Order,"per-max-canc")
                                        then dec(Getsondec(c-Order,"per-max-canc"))
                                        else if avail ped-venda
                                             then ped-venda.per-max-canc
                                             else ?.

        if  c-GlobalOrderChangeCode = 'CANCEL':U then
            assign tt-ped-venda.cod-mot-canc-cot = int(Getsonval(c-Order,"cod-mot-canc-cot"))
                   tt-ped-venda.desc-cancela     = Getsonval(c-Order,"desc-cancela")
                   tt-ped-venda.dt-cancela       = Getsondate(c-Order,"dt-cancela")
                   tt-ped-venda.user-canc        = Getsonval(c-Order,"user-canc").

        if  c-GlobalOrderChangeCode = 'SUSPEND':U then
            assign tt-ped-venda.desc-suspend     = Getsonval(c-Order,"desc-suspend")
                   tt-ped-venda.dt-suspensao     = Getsondate(c-Order,"dt-suspensao")
                   tt-ped-venda.user-susp        = Getsonval(c-Order,"user-susp").

        if  c-GlobalOrderChangeCode = 'REACTIVATE':U then
            assign tt-ped-venda.desc-reativa     = Getsonval(c-Order,"desc-reativa")
                   tt-ped-venda.user-reat        = Getsonval(c-Order,"user-reat").

        assign
        tt-ped-venda.user-alt         = if  Getsonval(c-Order,"user-alt") <> ""
                                        then Getsonval(c-Order,"user-alt")
                                        else if  c-GlobalOrderChangeCode = 'INSERT':U
                                             then tt-ped-venda.user-impl
                                             else if  avail ped-venda
                                                  then if  ped-venda.user-alt <> ""
                                                       then ped-venda.user-alt
                                                       else ped-venda.user-impl
                                                  else tt-ped-venda.user-impl
        c-tip-cob-desp                = Getsonval(c-Order,"tip-cob-desp")
        tt-ped-venda.tip-cob-desp     = if avail ped-venda
                                        then if c-tip-cob-desp <> "":U 
                                             then {diinc/i04di072.i 06 c-tip-cob-desp}
                                             else ped-venda.tip-cob-desp
                                        else if c-tip-cob-desp = "":U
                                             then 0
                                             else {diinc/i04di072.i 06 c-tip-cob-desp}
        tt-ped-venda.cond-redespa     = Getsonval(c-Order,"cond-redespa")
        tt-ped-venda.cond-espec       = Getsonval(c-Order,"cond-espec").

        if  AvailTag(c-Order,"QuoteCollection") then
            assign c-QuoteCollection       = Get(c-Order,"QuoteCollection")
                     c-num-QuoteCollection = GetElements(c-QuoteCollection).

        do  i-cont-3 = 1 to num-entries(c-num-QuoteCollection):
            assign c-Quote                        = entry(i-cont-3,c-numQuoteCollection)
                     tt-ped-venda.nr-ped-cot-orig = Getsonval(c-Quote,"QuoteIdentifier").
        end.

        if  AvailTag(c-Order,"vendor") then do:
            assign c-vendor = Get(c-Order,"vendor").

            create tt-pd-vendor.
            assign
            tt-pd-vendor.taxa-cliente = dec(Getsondec(c-vendor,"taxa-cliente"))
            tt-pd-vendor.cod-cond-pag = int(Getsonval(c-vendor,"cod-cond-cli"))
            tt-pd-vendor.dias-base    = int(Getsonval(c-vendor,"dias-base"))
            tt-pd-vendor.data-base    = Getsondate(c-vendor,"data-base").
        end.

        assign
        c-PaymentPlan               = Get(c-Order,"PaymentPlan")
          tt-ped-venda.cod-cond-pag = int(Getsonval(c-PaymentPlan,"PaymentCode")).

        if  AvailTag(c-PaymentPlan,"PaymentCollection")
        and tt-ped-venda.cod-cond-pag = 0 then do:
            assign
            c-PaymentCollection       = Get(c-PaymentPlan,"PaymentCollection")
              c-num-PaymentCollection = GetElements(c-PaymentCollection).

            do  i-cont = 1 to num-entries(c-num-PaymentCollection):
                create tt-cond-ped.
                assign
                c-Payment                  = entry(i-cont,c-num-PaymentCollection)
                  tt-cond-ped.nr-sequencia = int(Getsonval(c-Payment,"nr-sequencia")).

                assign
                c-cod-vencto            = Getsonval(c-Payment,"cod-vencto")
                tt-cond-ped.cod-vencto  = if  c-cod-vencto = "":U
                                          then tt-cond-ped.cod-vencto
                                          else {diinc/i02di165.i 06 c-cod-vencto} 
                tt-cond-ped.observacoes = Getsonval(c-Payment,"observacoes").

                if  AvailTag(c-Payment,"DueDate") then
                    assign tt-cond-ped.data-pagto = Getsondate(c-Payment,"DueDate").
                if  AvailTag(c-Payment,"DueDays") then
                    assign tt-cond-ped.nr-dias-venc = int(Getsonval(c-Payment,"DueDays")).
                if  AvailTag(c-Payment,"Percent") then
                    assign tt-cond-ped.perc-pagto = dec(Getsondec(c-Payment,"Percent")).

                if  AvailTag(c-Payment,"MonetaryAmount") then
                    assign
                    c-MonetaryAmount       = Get(c-Payment,"MonetaryAmount")
                      tt-cond-ped.vl-pagto = dec(Getsondec(c-MonetaryAmount,"Amount")).
            end.
        end.

        if  AvailTag(c-Order,"colecao-representante") then do:
            assign
            c-colecao-representante     = Get(c-Order,"colecao-representante")
            c-num-colecao-representante = GetElements(c-colecao-representante).

            do  i-cont = 1 to num-entries(c-num-colecao-representante):
                create tt-ped-repre.
                assign
                c-representante            = entry(i-cont,c-num-colecao-representante)
                  tt-ped-repre.nome-ab-rep = Getsonval(c-representante,"nome-abrev").

                assign
                tt-ped-repre.ind-repbase = if Getsonval(c-representante,"ind-repbase") = "Sim":U then yes else if Getsonval(c-representante,"ind-repbase") = "N∆o":U then no else ?
                tt-ped-repre.perc-comis  = dec(Getsondec(c-representante,"perc-comis"))
                tt-ped-repre.comis-emis  = int(Getsonval(c-representante,"comis-emis")).
            end.
        end.

        assign
        c-ProductLineItemCollection       = Get(c-Order,"ProductLineItemCollection")
          c-num-ProductLineItemCollection = GetElements(c-ProductLineItemCollection).

        do  i-cont-1 = 1 to num-entries(c-num-ProductLineItemCollection):
            create tt-ped-item.

            assign
            c-ProductLineItem      = entry(i-cont-1,c-num-ProductLineItemCollection)
            tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
            tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli.

            assign tt-ped-item.nr-sequencia = int(Getsonval(c-ProductLineItem,"SOSequentialIdentification")).
            assign tt-ped-item.it-codigo    = Getsonval(c-ProductLineItem,"LegacyProductIdentifier").

            if  AvailTag(c-ProductLineItem,"LegacyProductReference") then
                assign tt-ped-item.cod-refer = Getsonval(c-ProductLineItem,"LegacyProductReference").

            find ped-item
                 where ped-item.nome-abrev   = tt-ped-item.nome-abrev
                 and   ped-item.nr-pedcli    = tt-ped-item.nr-pedcli
                 and   ped-item.nr-sequencia = tt-ped-item.nr-sequencia
                 and   ped-item.it-codigo    = tt-ped-item.it-codigo
                 and   ped-item.cod-refer    = tt-ped-item.cod-refer
                 no-lock no-error.

            assign
            substring(tt-ped-item.char-1,1,2) = "14" /*Origem do item do pedido (idàntido ao ped-venda.ind-orig-entrada)*/
            c-cod-sit-item           = Getsonval(c-ProductLineItem,"OrderItemStatus")
            tt-ped-item.cod-sit-item = if avail ped-item
                                       then if  c-cod-sit-item <> "":U
                                            then {diinc/i03di149.i 06 c-cod-sit-item}
                                            else ped-item.cod-sit-item
                                       else if  c-cod-sit-item = "":U
                                            then tt-ped-item.cod-sit-item
                                            else {diinc/i03di149.i 06 c-cod-sit-item}.
            assign
            tt-ped-item.desc-cancela     = if availTag(c-ProductLineItem,"desc-cancela")
                                           then Getsonval(c-ProductLineItem,"desc-cancela")
                                           else "":U
            tt-ped-item.cod-mot-canc-cot = int(Getsonval(c-ProductLineItem,"cod-mot-canc-cot"))
            tt-ped-item.dt-canseq        = if availTag(c-ProductLineItem,"dt-canseq")
                                           then Getsondate(c-ProductLineItem,"dt-canseq")
                                           else ?
            tt-ped-item.user-canc        = if availTag(c-ProductLineItem,"user-canc")
                                           then Getsonval(c-ProductLineItem,"user-canc")
                                           else "":U
            c-InventoryAllocationStatus  = Getsonval(c-ProductLineItem,"InventoryAllocationStatus")
            tt-ped-item.cod-sit-pre      = if avail ped-item
                                           then if  c-InventoryAllocationStatus <> "":U
                                                then {diinc/i04di149.i 06 c-InventoryAllocationStatus}
                                                else ped-item.cod-sit-pre
                                           else if  c-InventoryAllocationStatus = "":U
                                                then tt-ped-item.cod-sit-pre
                                                else {diinc/i04di149.i 06 c-InventoryAllocationStatus}
            c-CommercialEvaluationStatus = Getsonval(c-ProductLineItem,"CommercialEvaluationStatus")
            tt-ped-item.cod-sit-com      = if avail ped-item
                                           then if c-CommercialEvaluationStatus <> "":U
                                                then {diinc/i05di154.i 06 c-CommercialEvaluationStatus}
                                                else ped-item.cod-sit-com
                                           else if c-CommercialEvaluationStatus = "":U
                                                then 0
                                                else {diinc/i05di154.i 06 c-CommercialEvaluationStatus}
            c-PriceEvaluationStatus      = Getsonval(c-ProductLineItem,"PriceEvaluationStatus")
            tt-ped-item.cod-sit-preco    = if avail ped-item   /* guerbet */
                                           then if c-PriceEvaluationStatus <> "":U
                                                then {diinc/i05di154.i 06 c-PriceEvaluationStatus}
                                                else ped-item.cod-sit-preco
                                           else if c-PriceEvaluationStatus = "":U
                                                then tt-ped-item.cod-sit-preco
                                                else {diinc/i05di154.i 06 c-PriceEvaluationStatus}
            tt-ped-item.dt-max-fat       = Getsondate(c-ProductLineItem,"ValidityEndDate")
            tt-ped-item.qt-pedida        = dec(Getsondec(c-ProductLineItem,"qt-pedida")).

            &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
                 if  AvailTag(c-Order,"QuantityUnitSales") then
                     ASSIGN tt-ped-item.qt-un-fat = if Getsondec(c-ProductLineItem,"QuantityUnitSales") <> "":U
                                                       then dec(Getsondec(c-ProductLineItem,"QuantityUnitSales"))
                                                       else tt-ped-item.qt-pedida.
                  ELSE
                     ASSIGN tt-ped-item.qt-un-fat = tt-ped-item.qt-pedida.

                 if  AvailTag(c-Order,"UnitSales") then
                     ASSIGN tt-ped-item.des-un-medida = Getsondec(c-ProductLineItem,"UnitSales").
            &endif


            ASSIGN tt-ped-item.nr-tabpre = Getsonval(c-ProductLineItem,"PriceTable").

            ASSIGN tt-ped-item.nat-operacao = Getsonval(c-ProductLineItem,"nat-operacao")
                   tt-ped-item.cod-entrega  = Getsonval(c-ProductLineItem,"cod-entrega").

            assign
            tt-ped-item.log-usa-tabela-desconto    = if  Getsonval(c-ProductLineItem,"log-usa-tabela-desconto") = "Sim":U
                                                     then yes
                                                     else
                                                         if  Getsonval(c-ProductLineItem,"log-usa-tabela-desconto") = "N∆o":U
                                                         then no
                                                         else if avail ped-item
                                                              then ped-item.log-usa-tabela-desconto
                                                              else ?
            tt-ped-item.val-pct-desconto-tab-preco = if Getsondec(c-ProductLineItem,"val-pct-desconto-tab-preco") <> "":U
                                                     then dec(Getsondec(c-ProductLineItem,"val-pct-desconto-tab-preco"))
                                                     else if avail ped-item
                                                          then ped-item.val-pct-desconto-tab-preco
                                                          else 0
            tt-ped-item.des-pct-desconto-inform    = Getsonval(c-ProductLineItem,"des-pct-desconto-inform")
            substr(tt-ped-item.char-2,11,17)       = Getsonval(c-ProductLineItem,"conta-contabil")
            substr(tt-ped-item.char-2,29,12)       = Getsonval(c-ProductLineItem,"custo-contabil")
            substr(tt-ped-item.char-2,1,8)         = Getsonval(c-ProductLineItem,"class-fiscal")
            c-tipo-atend                           = Getsonval(c-ProductLineItem,"tipo-atend")
            tt-ped-item.tipo-atend                 = if avail ped-item
                                                     then if  c-tipo-atend <> "":U
                                                          then {diinc/i05di149.i 06 c-tipo-atend}
                                                          else ped-item.tipo-atend
                                                     else if  c-tipo-atend = "":U
                                                          then 0
                                                          else {diinc/i05di149.i 06 c-tipo-atend}
            tt-ped-item.dt-entrega                 = Getsondate(c-ProductLineItem,"dt-entrega").

            if  session:numeric-format = "EUROPEAN" then
                assign tt-ped-item.des-pct-desconto-inform = replace(string(tt-ped-item.des-pct-desconto-inform), ".", ",").

            assign
            tt-ped-item.dt-entorig        = Getsondate(c-ProductLineItem,"dt-entorig")
            tt-ped-item.ind-fat-qtfam     = if Getsonval(c-ProductLineItem,"inf-fat-qtfam") = "Sim":U 
                                            then yes 
                                            else if Getsonval(c-ProductLineItem,"inf-fat-qtfam") = "N∆o":U 
                                                 then no 
                                                 else if avail ped-item
                                                      then ped-item.ind-fat-qtfam
                                                      else ?
            tt-ped-item.dt-min-fat        = if avail ped-item 
                                            then if string(Getsondate(c-ProductLineItem,"dt-min-fat")) <> "":U
                                                 then Getsondate(c-ProductLineItem,"dt-min-fat")
                                                 else ped-item.dt-min-fat
                                            else if string(Getsondate(c-ProductLineItem,"dt-min-fat")) <> "":U
                                                 then Getsondate(c-ProductLineItem,"dt-min-fat")
                                                 else ?
            tt-ped-item.per-minfat        = dec(Getsondec(c-ProductLineItem,"per-minfat"))
            tt-ped-item.ind-icm-ret       = if Getsonval(c-ProductLineItem,"ind-icm-ret") = "Sim":U 
                                            then yes 
                                            else if Getsonval(c-ProductLineItem,"ind-icm-ret") = "N∆o":U 
                                                 then no 
                                                 else if avail ped-item
                                                      then ped-item.ind-icm-ret
                                                      else ?
            tt-ped-item.per-des-icms      = if availTag(c-ProductLineItem,"per-des-icms")
                                            then dec(Getsondec(c-ProductLineItem,"per-des-icms"))
                                            else if avail ped-item
                                                 then ped-item.per-des-icms
                                                 else ?
            tt-ped-item.observacao        = if availTag(c-ProductLineItem,"observacao")
                                            then Getsonval(c-ProductLineItem,"observacao")
                                            else if avail ped-item
                                                 then ped-item.observacao
                                                 else "":U.

            if  AvailTag(c-ProductLineItem,"OCCollection") then do:
                assign c-OCCollection       = Get(c-ProductLineItem,"OCCollection")
                         num-c-OCCollection = GetElements(c-OCCollection).

                do  i-cont-4 = 1 to num-entries(num-c-OCCollection):
                    assign c-OC                       = Get(c-OCCollection,"OC")
                           tt-ped-item.cod-ord-compra = Getsonval(c-OC,"OCIdentifier")
                           tt-ped-item.parcela        = int(Getsonval(c-OC,"OCParcel")).
                end.
            end.

            if  availTag(c-ProductLineItem,"ProductShipCollection") then do:
                assign
                c-ProductShipCollection       = Get(c-ProductLineItem,"ProductShipCollection")
                  c-num-ProductShipCollection = GetElements(c-ProductShipCollection).

                do  i-cont-2 = 1 to num-entries(c-num-ProductShipCollection):
                    create tt-ped-ent.
                    assign
                    c-ProductShip           = entry(i-cont-2,c-num-ProductShipCollection)
                    tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
                    tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
                    tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
                    tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
                    tt-ped-ent.cod-refer    = tt-ped-item.cod-refer.

                    assign tt-ped-ent.nr-programa = int(Getsonval(c-ProductShip,"nr-programa")).

                    assign
                    tt-ped-ent.nr-progcli = Getsonval(c-ProductShip,"nr-progcli")
                    tt-ped-ent.nr-versao  = int(Getsonval(c-ProductShip,"nr-versao"))
                    tt-ped-ent.nr-entrega = int(Getsonval(c-ProductShip,"nr-entrega")).

                    assign tt-ped-ent.dt-entrega-prim = Getsondate(c-ProductShip,"RequestDeliveryDate").

                    if  AvailTag(c-ProductShip,"Comment") then
                        assign tt-ped-ent.observacao = Getsonval(c-ProductShip,"Comment").

                    assign
                    c-DeliveryTo              = Get(c-ProductShip,"DeliveryTo")
                      c-PhysicalAddress       = Get(c-DeliveryTo,"PhysicalAddress")
                        c-Address             = Get(c-PhysicalAddress,"Address").
                end.
            end.

            /* Unidade de Negocio */
            &IF "{&bf_dis_versao_ems}" < "2.062" &THEN
                IF availTag(c-ProductLineItem,"BusinessUnitCollection") THEN DO:
                    ASSIGN c-BusinessUnitCollection      = Get(c-ProductLineItem,"BusinessUnitCollection")
                           c-num-BusinessUnitCollection  = GetElements(c-BusinessUnitCollection).
                    DO  i-cont-2 = 1 TO NUM-ENTRIES(c-num-BusinessUnitCollection):
                        CREATE  tt-unid-neg-ped.
                        ASSIGN  tt-unid-neg-ped.nome-abrev      = tt-ped-item.nome-abrev
                                tt-unid-neg-ped.nr-pedcli       = tt-ped-item.nr-pedcli
                                tt-unid-neg-ped.nr-sequencia    = tt-ped-item.nr-sequencia
                                &IF "{&ems_dbtype}" <> "progress":U &THEN 
                                tt-unid-neg-ped.char-1          = tt-ped-item.it-codigo
                                &ELSE
                                tt-unid-neg-ped.it-codigo       = tt-ped-item.it-codigo
                                &ENDIF
                                tt-unid-neg-ped.cod-refer       = tt-ped-item.cod-refer.
                        ASSIGN  c-BusinessUnit                  = ENTRY(i-cont-2,c-num-BusinessUnitCollection)
                                tt-unid-neg-ped.cod_unid_negoc  = Getsonval(c-BusinessUnit,"BusinessUnitCode").
                        ASSIGN  tt-unid-neg-ped.perc-unid-neg   = DECIMAL(Getsonval(c-BusinessUnit,"BusinessUnitRate"))
                                tt-unid-neg-ped.val-unid-neg    = DECIMAL(Getsonval(c-BusinessUnit,"BusinessUnitValue"))
                                tt-unid-neg-ped.qtd-unid-neg    = DECIMAL(Getsonval(c-BusinessUnit,"BusinessUnitQuantity")).
                    END.
                END.    
            &ENDIF

            assign 
            c-OrderItemValueCollection = Get(c-ProductLineItem,"OrderItemValueCollection")
              num-c-OrderItemValueCollection = GetElements(c-OrderItemValueCollection).

            do  i-cont = 1 to num-entries(num-c-OrderItemValueCollection):
                assign c-OrderItemValue = entry(i-cont,num-c-OrderItemValueCollection).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "2"
                and AvailTag(c-OrderItemValue,"Percent") then
                    assign tt-ped-item.per-des-item = dec(Getsondec(c-OrderItemValue,"Percent")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "4"
                and AvailTag(c-OrderItemValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderItemValue,"MonetaryAmount")
                           tt-ped-item.val-desconto-inform = dec(Getsondec(c-MonetaryAmount,"Amount")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "15"
                and AvailTag(c-OrderItemValue,"Percent") then
                    assign tt-ped-item.aliquota-ipi = dec(Getsondec(c-OrderItemValue,"Percent")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "17"
                and AvailTag(c-OrderItemValue,"Percent") then
                    assign tt-ped-item.dec-2 = dec(Getsondec(c-OrderItemValue,"Percent")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "46"
                and AvailTag(c-OrderItemValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderItemValue,"MonetaryAmount")
                           tt-ped-item.vl-pretab = dec(Getsondec(c-MonetaryAmount,"Amount")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "53"
                and AvailTag(c-OrderItemValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderItemValue,"MonetaryAmount")
                           tt-ped-item.vl-preori = dec(Getsondec(c-MonetaryAmount,"Amount")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "28"
                and AvailTag(c-OrderItemValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderItemValue,"MonetaryAmount")
                           tt-ped-item.vl-preuni = dec(Getsondec(c-MonetaryAmount,"Amount")).

                if  Getsonval(c-OrderItemValue,"ValuesIdentifier") = "29"
                and AvailTag(c-OrderItemValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderItemValue,"MonetaryAmount")
                           tt-ped-item.vl-tot-it = dec(Getsondec(c-MonetaryAmount,"Amount")).
            end.
        end.

        if  AvailTag(c-Order,"OrderValueCollection") then do:
            assign
            c-OrderValueCollection = Get(c-Order,"OrderValueCollection")
              num-c-OrderValueCollection = GetElements(c-OrderValueCollection).

            do  i-cont = 1 to num-entries(num-c-OrderValueCollection):
                assign c-OrderValue = entry(i-cont,num-c-OrderValueCollection).

                if  Getsonval(c-OrderValue,"ValuesIdentifier") = "26"
                and AvailTag(c-OrderValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderValue,"MonetaryAmount")
                             tt-ped-venda.vl-tot-ped = dec(Getsondec(c-MonetaryAmount,"Amount")).

                if  Getsonval(c-OrderValue,"ValuesIdentifier") = "1"
                and AvailTag(c-OrderValue,"MonetaryAmount") then
                    assign c-MonetaryAmount = Get(c-OrderValue,"MonetaryAmount")
                             tt-ped-venda.vl-liq-ped = dec(Getsondec(c-MonetaryAmount,"Amount")).

                if  Getsonval(c-OrderValue,"ValuesIdentifier") = "2"
                and AvailTag(c-OrderValue,"Percent") then
                    assign tt-ped-venda.perc-desco2 = dec(Getsondec(c-OrderValue,"Percent")).
            end.
        end.
    end. /* fim c-GlobalOrderChangeCode <> 'DELETE' */

    assign 
    c-OrderOrigin                 = Getsonval(c-Order,"OrderOrigin")
    tt-ped-venda.ind-orig-entrada = if c-OrderOrigin = "":U
                                    then 14
                                    else {diinc/i07di159.i 06 c-OrderOrigin}
    tt-ped-venda.origem           = tt-ped-venda.ind-orig-entrada
    c-FromRole                    = Get(c-OrderUpdate,"FromRole")
      tt-ped-venda.cod-estabel    = Getsonval(c-FromRole,"LegacyLocationIdentifier").

    assign
    c-ToRole                    = Get(c-OrderUpdate,"ToRole")
      tt-ped-venda.cod-emitente = int(Getsonval(c-ToRole,"LegacyLocationIdentifier"))
    c-Address                   = Get(c-ToRole,"Address")
      tt-ped-venda.cod-entrega  = Getsonval(c-Address,"AddressCode").

    &IF '{&bf_dis_versao_ems}' begins '2.04' &THEN
        assign substring(tt-ped-venda.char-2,1,9) = string(i-nr-pedido-crm).
    &ELSE
        &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
            assign tt-ped-venda.nr-pedido-crm = i-nr-pedido-crm.
        &ELSE
        &ENDIF
    &ENDIF

end procedure.

/* -------------------------- Bloco principal -------------------------*/

find first tt-ped-venda no-error.

for first ped-venda fields(log-1 &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN nr-pedido-crm &ELSE char-2 &ENDIF)
    where ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
    and   ped-venda.nome-abrev = tt-ped-venda.nome-abrev no-lock:
end.

if  avail ped-venda
and {&ped-venda.nr-pedido-crm} <> {&tt-ped-venda.nr-pedido-crm} then do:
    run utp/ut-msgs.p (input 'msg':U,
                       input 25997,
                       input 'Pedidos de Venda distintos criados com mesmo nome abreviado e n£mero de pedido do cliente no CRM e ERP ' +
                             tt-ped-venda.nome-abrev + ' - ':U + tt-ped-venda.nr-pedcli).

    create tt-erro-neogrid.
    assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
           tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
           tt-erro-neogrid.i-cod-erro    = 25997
           tt-erro-neogrid.c-desc-erro   = trim(return-value).
end.

/* ----- Verificaá∆o do emitente (se confere ERP -> CRM) ---- */
for first emitente fields(cod-emitente) 
    where emitente.nome-abrev = tt-ped-venda.nome-abrev no-lock:
end.
if  avail emitente then do:

    for first dist-emitente fields(int-1)
        where dist-emitente.cod-emitente = emitente.cod-emitente
        and   dist-emitente.int-1       <> i-cod-emit-ext no-lock:
    end.
    if  avail dist-emitente and dist-emitente.int-1 <> 0 then do:

        run utp/ut-msgs.p (input 'msg':U,
                           input 25997,
                           input 'Clientes distintos criados com mesmo nome abreviado no CRM e ERP ' + tt-ped-venda.nome-abrev).

        create tt-erro-neogrid.
        assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
               tt-erro-neogrid.i-cod-erro    = 25997
               tt-erro-neogrid.c-desc-erro   = trim(return-value).
    end.
end.

find first tt-erro-neogrid no-error.
if  avail tt-erro-neogrid then do:
    run adapters/neogrid/ftp/aneft052.p (input table tt-erro-neogrid).
    return.
end.

run pi-valida-estrutura-repres.

case c-GlobalOrderChangeCode:
    when 'INSERT':U     then run pi-cria-pedido.
    when 'CHANGE':U     then run pi-altera-pedido.
    when 'DELETE':U     then run pi-elimina-pedido.
    when 'CANCEL':U     then run pi-cancela-pedido.
    when 'SUSPEND':U    then run pi-suspende-pedido.
    when 'REACTIVATE':U then run pi-reativa-pedido.
end case.

find first tt-erro-neogrid no-error.

if  avail tt-erro-neogrid then
    run adapters/neogrid/ftp/aneft052.p (input table tt-erro-neogrid).

if  valid-handle(h-bodi159com) then do:
    run destroyBO in h-bodi159com.
    delete procedure h-bodi159com.
    assign h-bodi159com = ?.
end.

if  valid-handle(h-bodi159) then do:
    run destroyBO in h-bodi159.

    delete procedure h-bodi159.
    assign h-bodi159 = ?.

end.

if  valid-handle(h-bodi159can) then do:
    delete procedure h-bodi159can.
    assign h-bodi159can = ?.
end.

if  valid-handle(h-bodi159sdf) then do:
    delete procedure h-bodi159sdf.
    assign h-bodi159sdf = ?.
end.

if  valid-handle(h-bodi159sus) then do:
    delete procedure h-bodi159sus.
    assign h-bodi159sus = ?.
end.

if  valid-handle(h-bodi159rct) then do:
    delete procedure h-bodi159rct.
    assign h-bodi159rct = ?.
end.                   

if  valid-handle(h-bodi154) then do:
    run destroyBO in h-bodi154.
    delete procedure h-bodi154.
    assign h-bodi154 = ?.
end.

if  valid-handle(h-bodi154can) then do:
    delete procedure h-bodi154can.
    assign h-bodi154can = ?.
end.

if  valid-handle(h-bodi154sdf) then do:
    delete procedure h-bodi154sdf.
    assign h-bodi154sdf = ?.
end.

if  valid-handle(h-bodi157) then do:
    delete procedure h-bodi157.
    assign h-bodi157 = ?.
end.

if  valid-handle(h-bodi149) then do:
    delete procedure h-bodi149.
    assign h-bodi149 = ?.
end.

if  valid-handle(h-bodi757) then do:
    delete procedure h-bodi757.
    assign h-bodi757 = ?.
end.
if  valid-handle(h-bodi018) then do:
    delete procedure h-bodi018.
    assign h-bodi018 = ?.
end.

procedure pi-SetDefaultPedido:
  /*tt-ped-venda     - temp-table oficial
    tt-ped-venda-sdf - temp-table com os defaults setados
    tt-ped-venda-xml - temp-table com o original vindo do xml*/

    if  not valid-handle(h-bodi159sdf)
    or  h-bodi159sdf:TYPE       <> "PROCEDURE":U
    or  h-bodi159sdf:FILE-NAME  <> "dibo/bodi159sdf.p":U then
        run dibo/bodi159sdf.p persistent set h-bodi159sdf.

    for each tt-ped-venda-xml:
        delete tt-ped-venda-xml.
    end.
    for each tt-ped-venda-sdf:
        delete tt-ped-venda-sdf.
    end.

    find first tt-ped-venda no-error.

    /* Incialmente a tt de default e a tt vinda do xml s∆o c¢pia da original(tt-ped-venda), 
       que recebeu os conte£dos das tag's no in°cio do adapter */
    create tt-ped-venda-xml.
    buffer-copy tt-ped-venda to tt-ped-venda-xml.

    create tt-ped-venda-sdf.
    buffer-copy tt-ped-venda to tt-ped-venda-sdf.

    run setUserLog             in h-bodi159sdf(input  tt-ped-venda.user-alt).
    run inputTable             in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultCustomerName in h-bodi159sdf.
    run outputTable            in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    /* se a ped-venda do xml Ç "":U ent∆o a original recebe o default, sen∆o a default recebe o que est† no xml */
    if tt-ped-venda-xml.cod-estabel = "":U           then assign tt-ped-venda.cod-estabel             = tt-ped-venda-sdf.cod-estabel.             else assign tt-ped-venda-sdf.cod-estabel             = tt-ped-venda-xml.cod-estabel.
    if tt-ped-venda-xml.dt-validade = ?              then assign tt-ped-venda.dt-validade             = tt-ped-venda-sdf.dt-validade.             else assign tt-ped-venda-sdf.dt-validade             = tt-ped-venda-xml.dt-validade.
    if  tt-ped-venda-xml.tp-preco        = 0         then assign tt-ped-venda.tp-preco                = tt-ped-venda-sdf.tp-preco.                else assign tt-ped-venda-sdf.tp-preco                = tt-ped-venda-xml.tp-preco.
    if  tt-ped-venda-xml.nr-tabpre       = "":U
    and tt-ped-venda-xml.tp-preco       <> 1         then assign tt-ped-venda.nr-tabpre               = tt-ped-venda-sdf.nr-tabpre.               else assign tt-ped-venda-sdf.nr-tabpre               = tt-ped-venda-xml.nr-tabpre.
    if  tt-ped-venda-xml.ind-lib-nota    = ?         then assign tt-ped-venda.ind-lib-nota            = tt-ped-venda-sdf.ind-lib-nota.            else assign tt-ped-venda-sdf.ind-lib-nota            = tt-ped-venda-xml.ind-lib-nota.
    if  tt-ped-venda-xml.log-usa-tabela-desconto = ? then assign tt-ped-venda.log-usa-tabela-desconto = tt-ped-venda-sdf.log-usa-tabela-desconto. else assign tt-ped-venda-sdf.log-usa-tabela-desconto = tt-ped-venda-xml.log-usa-tabela-desconto.
    if  tt-ped-venda-xml.nome-abrev      = "":U      then assign tt-ped-venda.nome-abrev              = tt-ped-venda-sdf.nome-abrev.              else assign tt-ped-venda-sdf.nome-abrev              = tt-ped-venda-xml.nome-abrev.
    if  tt-ped-venda-xml.nat-operacao    = "":U      then assign tt-ped-venda.nat-operacao            = tt-ped-venda-sdf.nat-operacao.            else assign tt-ped-venda-sdf.nat-operacao            = tt-ped-venda-xml.nat-operacao.
    if  tt-ped-venda-xml.esp-ped         = 0         then assign tt-ped-venda.esp-ped                 = tt-ped-venda-sdf.esp-ped.                 else assign tt-ped-venda-sdf.esp-ped                 = tt-ped-venda-xml.esp-ped.
    if  tt-ped-venda-xml.cod-portador    = 0         then assign tt-ped-venda.cod-portador            = tt-ped-venda-sdf.cod-portador.            else assign tt-ped-venda-sdf.cod-portador            = tt-ped-venda-xml.cod-portador.
    if  tt-ped-venda-xml.modalidade      = 0         then assign tt-ped-venda.modalidade              = tt-ped-venda-sdf.modalidade.              else assign tt-ped-venda-sdf.modalidade              = tt-ped-venda-xml.modalidade.
    if  tt-ped-venda-xml.cod-canal-venda = 0         then assign tt-ped-venda.cod-canal-venda         = tt-ped-venda-sdf.cod-canal-venda.         else assign tt-ped-venda-sdf.cod-canal-venda         = tt-ped-venda-xml.cod-canal-venda.
/*     if  tt-ped-venda-xml.nome-tr-red     = "":U      then assign tt-ped-venda.nome-tr-red             = tt-ped-venda-sdf.nome-tr-red.             else assign tt-ped-venda-sdf.nome-tr-red             = tt-ped-venda-xml.nome-tr-red.  */
    if  tt-ped-venda-xml.cod-entrega     = "":U      then assign tt-ped-venda.cod-entrega             = tt-ped-venda-sdf.cod-entrega.             else assign tt-ped-venda-sdf.cod-entrega             = tt-ped-venda-xml.cod-entrega.
    if  tt-ped-venda-xml.ind-fat-par     = ?         then assign tt-ped-venda.ind-fat-par             = tt-ped-venda-sdf.ind-fat-par.             else assign tt-ped-venda-sdf.ind-fat-par             = tt-ped-venda-xml.ind-fat-par.
    if  tt-ped-venda-xml.per-max-canc    = ?         then assign tt-ped-venda.per-max-canc            = tt-ped-venda-sdf.per-max-canc.            else assign tt-ped-venda-sdf.per-max-canc            = tt-ped-venda-xml.per-max-canc.
    if  tt-ped-venda-xml.tip-cob-desp    = 0         then assign tt-ped-venda.tip-cob-desp            = tt-ped-venda-sdf.tip-cob-desp.            else assign tt-ped-venda-sdf.tip-cob-desp            = tt-ped-venda-xml.tip-cob-desp.
    if  tt-ped-venda-xml.dt-entrega      = ?         then assign tt-ped-venda.dt-entrega              = tt-ped-venda-sdf.dt-entrega.              else assign tt-ped-venda-sdf.dt-entrega              = tt-ped-venda-xml.dt-entrega.
    if  tt-ped-venda-xml.dt-entorig      = ?         then assign tt-ped-venda.dt-entorig              = tt-ped-venda-sdf.dt-entorig.              else assign tt-ped-venda-sdf.dt-entorig              = tt-ped-venda-xml.dt-entorig.
    if  tt-ped-venda-xml.dt-emissao      = ?         then assign tt-ped-venda.dt-emissao              = tt-ped-venda-sdf.dt-emissao.              else assign tt-ped-venda-sdf.dt-emissao              = tt-ped-venda-xml.dt-emissao.
    if  tt-ped-venda-xml.dt-implant      = ?         then assign tt-ped-venda.dt-implant              = tt-ped-venda-sdf.dt-implant.              else assign tt-ped-venda-sdf.dt-implant              = tt-ped-venda-xml.dt-implant.
    if  tt-ped-venda-xml.user-impl       = "":U      then assign tt-ped-venda.user-impl               = tt-ped-venda-sdf.user-impl.               else assign tt-ped-venda-sdf.user-impl               = tt-ped-venda-xml.user-impl.
    if  tt-ped-venda-xml.dt-userimp      = ?         then assign tt-ped-venda.dt-userimp              = tt-ped-venda-sdf.dt-userimp.              else assign tt-ped-venda-sdf.dt-userimp              = tt-ped-venda-xml.dt-userimp.
    if  tt-ped-venda-xml.cod-emitente    = 0         then assign tt-ped-venda.cod-emitente            = tt-ped-venda-sdf.cod-emitente.            else assign tt-ped-venda-sdf.cod-emitente            = tt-ped-venda-xml.cod-emitente.
    if  tt-ped-venda-xml.cod-gr-cli      = 0         then assign tt-ped-venda.cod-gr-cli              = tt-ped-venda-sdf.cod-gr-cli.              else assign tt-ped-venda-sdf.cod-gr-cli              = tt-ped-venda-xml.cod-gr-cli.
    if  tt-ped-venda-xml.ind-imp-ped     = 0         then assign tt-ped-venda.ind-imp-ped             = tt-ped-venda-sdf.ind-imp-ped.             else assign tt-ped-venda-sdf.ind-imp-ped             = tt-ped-venda-xml.ind-imp-ped.
    if  tt-ped-venda-xml.cod-sit-ped     = 0         then assign tt-ped-venda.cod-sit-ped             = tt-ped-venda-sdf.cod-sit-ped.             else assign tt-ped-venda-sdf.cod-sit-ped             = tt-ped-venda-xml.cod-sit-ped.
    if  tt-ped-venda-xml.tp-faturam      = 0         then assign tt-ped-venda.tp-faturam              = tt-ped-venda-sdf.tp-faturam.              else assign tt-ped-venda-sdf.tp-faturam              = tt-ped-venda-xml.tp-faturam.
    if  tt-ped-venda-xml.inc-desc-txt    = ?         then assign tt-ped-venda.inc-desc-txt            = tt-ped-venda-sdf.inc-desc-txt.            else assign tt-ped-venda-sdf.inc-desc-txt            = tt-ped-venda-xml.inc-desc-txt.
    if  tt-ped-venda-xml.cod-priori      = 0         then assign tt-ped-venda.cod-priori              = tt-ped-venda-sdf.cod-priori.              else assign tt-ped-venda-sdf.cod-priori              = tt-ped-venda-xml.cod-priori.
    if  tt-ped-venda-xml.cod-sit-com     = 0         then assign tt-ped-venda.cod-sit-com             = tt-ped-venda-sdf.cod-sit-com.             else assign tt-ped-venda-sdf.cod-sit-com             = tt-ped-venda-xml.cod-sit-com.
    if  tt-ped-venda-xml.no-ab-reppri    = "":U      then assign tt-ped-venda.no-ab-reppri            = tt-ped-venda-sdf.no-ab-reppri.            else assign tt-ped-venda-sdf.no-ab-reppri            = tt-ped-venda-xml.no-ab-reppri.
    if  tt-ped-venda-xml.nome-transp     = "":U      then assign tt-ped-venda.nome-transp             = tt-ped-venda-sdf.nome-transp.             else assign tt-ped-venda-sdf.nome-transp             = tt-ped-venda-xml.nome-transp.
    if  tt-ped-venda-xml.nat-operacao    = "":U      then assign tt-ped-venda.nat-operacao            = tt-ped-venda-sdf.nat-operacao.            else assign tt-ped-venda-sdf.nat-operacao            = tt-ped-venda-xml.nat-operacao.
    if  tt-ped-venda-xml.cod-rota        = "":U      then assign tt-ped-venda.cod-rota                = tt-ped-venda-sdf.cod-rota.                else assign tt-ped-venda-sdf.cod-rota                = tt-ped-venda-xml.cod-rota.
   

    find first tt-cond-ped no-error.
    if  not avail tt-cond-ped then
        if  tt-ped-venda-xml.cod-cond-pag = 0 then assign tt-ped-venda.cod-cond-pag = tt-ped-venda-sdf.cod-cond-pag. else assign tt-ped-venda-sdf.cod-cond-pag = tt-ped-venda-xml.cod-cond-pag.

    run inputTable     in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run SetDefaultSite in h-bodi159sdf.
    run outputTable    in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.dec-1        = 0    then assign tt-ped-venda.dec-1        = tt-ped-venda-sdf.dec-1.        else assign tt-ped-venda-sdf.dec-1        = tt-ped-venda-xml.dec-1.  
    if  tt-ped-venda-xml.nat-operacao = "":U then assign tt-ped-venda.nat-operacao = tt-ped-venda-sdf.nat-operacao. else assign tt-ped-venda-sdf.nat-operacao = tt-ped-venda-xml.nat-operacao.
    if  tt-ped-venda-xml.cod-rota     = "":U then assign tt-ped-venda.cod-rota     = tt-ped-venda-sdf.cod-rota.     else assign tt-ped-venda-sdf.cod-rota     = tt-ped-venda-xml.cod-rota.
    if  tt-ped-venda-xml.nome-transp  = "":U then assign tt-ped-venda.nome-transp  = tt-ped-venda-sdf.nome-transp.  else assign tt-ped-venda-sdf.nome-transp  = tt-ped-venda-xml.nome-transp.

    run inputTable             in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultPaymentTerm  in h-bodi159sdf.
    run outputTable            in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.nr-tab-finan = 0 then assign tt-ped-venda.nr-tab-finan = tt-ped-venda-sdf.nr-tab-finan. else assign tt-ped-venda-sdf.nr-tab-finan = tt-ped-venda-xml.nr-tab-finan.
    if  tt-ped-venda-xml.nr-ind-finan = 0 then assign tt-ped-venda.nr-ind-finan = tt-ped-venda-sdf.nr-ind-finan. else assign tt-ped-venda-sdf.nr-ind-finan = tt-ped-venda-xml.nr-ind-finan.

    find first tt-cond-ped no-error.
    if  not avail tt-cond-ped then
        if  tt-ped-venda-xml.cod-cond-pag = 0 then assign tt-ped-venda.cod-cond-pag = tt-ped-venda-sdf.cod-cond-pag. else assign tt-ped-venda-sdf.cod-cond-pag = tt-ped-venda-xml.cod-cond-pag.

    run inputTable                in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultTransactionType in h-bodi159sdf.
    run outputTable               in h-bodi159sdf(output table tt-ped-venda-sdf).

    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.cod-canal-venda = 0 then assign tt-ped-venda.cod-canal-venda = tt-ped-venda-sdf.cod-canal-venda. else assign tt-ped-venda-sdf.cod-canal-venda = tt-ped-venda-xml.cod-canal-venda.
    if  tt-ped-venda-xml.cod-mensagem    = 0 then assign tt-ped-venda.cod-mensagem    = tt-ped-venda-sdf.cod-mensagem.    else assign tt-ped-venda-sdf.cod-mensagem    = tt-ped-venda-xml.cod-mensagem.
    if  tt-ped-venda-xml.cod-des-merc    = 0 then assign tt-ped-venda.cod-des-merc    = tt-ped-venda-sdf.cod-des-merc.    else assign tt-ped-venda-sdf.cod-des-merc    = tt-ped-venda-xml.cod-des-merc.

    run inputTable           in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultDstChannel in h-bodi159sdf.
    run outputTable          in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    find first tt-cond-ped no-error.
    if  not avail tt-cond-ped then
        if  tt-ped-venda-xml.cod-cond-pag = 0 then assign tt-ped-venda.cod-cond-pag = tt-ped-venda-sdf.cod-cond-pag. else assign tt-ped-venda-sdf.cod-cond-pag = tt-ped-venda-xml.cod-cond-pag.

    if  tt-ped-venda-xml.no-ab-reppri = "":U then assign tt-ped-venda.no-ab-reppri = tt-ped-venda-sdf.no-ab-reppri. else assign tt-ped-venda-sdf.no-ab-reppri = tt-ped-venda-xml.no-ab-reppri.
    if  tt-ped-venda-xml.nome-transp  = "":U then assign tt-ped-venda.nome-transp  = tt-ped-venda-sdf.nome-transp.  else assign tt-ped-venda-sdf.nome-transp  = tt-ped-venda-xml.nome-transp.
    if  tt-ped-venda-xml.nr-tabpre    = "":U
    and tt-ped-venda-xml.tp-preco    <> 1    then assign tt-ped-venda.nr-tabpre    = tt-ped-venda-sdf.nr-tabpre.    else assign tt-ped-venda-sdf.nr-tabpre    = tt-ped-venda-xml.nr-tabpre.

    run inputTable         in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultDelivery in h-bodi159sdf.
    run outputTable        in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.local-entreg = "":U then assign tt-ped-venda.local-entreg = tt-ped-venda-sdf.local-entreg. else assign tt-ped-venda-sdf.local-entreg = tt-ped-venda-xml.local-entreg.
    if  tt-ped-venda-xml.bairro       = "":U then assign tt-ped-venda.bairro       = tt-ped-venda-sdf.bairro.       else assign tt-ped-venda-sdf.bairro       = tt-ped-venda-xml.bairro.
    if  tt-ped-venda-xml.cidade       = "":U then assign tt-ped-venda.cidade       = tt-ped-venda-sdf.cidade.       else assign tt-ped-venda-sdf.cidade       = tt-ped-venda-xml.cidade.
    if  tt-ped-venda-xml.pais         = "":U then assign tt-ped-venda.pais         = tt-ped-venda-sdf.pais.         else assign tt-ped-venda-sdf.pais         = tt-ped-venda-xml.pais.
    if  tt-ped-venda-xml.estado       = "":U then assign tt-ped-venda.estado       = tt-ped-venda-sdf.estado.       else assign tt-ped-venda-sdf.estado       = tt-ped-venda-xml.estado.
    if  tt-ped-venda-xml.cep          = "":U then assign tt-ped-venda.cep          = tt-ped-venda-sdf.cep.          else assign tt-ped-venda-sdf.cep          = tt-ped-venda-xml.cep.
    if  tt-ped-venda-xml.caixa-postal = "":U then assign tt-ped-venda.caixa-postal = tt-ped-venda-sdf.caixa-postal. else assign tt-ped-venda-sdf.caixa-postal = tt-ped-venda-xml.caixa-postal.
    if  tt-ped-venda-xml.cgc          = "":U then assign tt-ped-venda.cgc          = tt-ped-venda-sdf.cgc.          else assign tt-ped-venda-sdf.cgc          = tt-ped-venda-xml.cgc.
    if  tt-ped-venda-xml.ins-estadual = "":U then assign tt-ped-venda.ins-estadual = tt-ped-venda-sdf.ins-estadual. else assign tt-ped-venda-sdf.ins-estadual = tt-ped-venda-xml.ins-estadual.
    if  tt-ped-venda-xml.e-mail       = "":U then assign tt-ped-venda.e-mail       = tt-ped-venda-sdf.e-mail.       else assign tt-ped-venda-sdf.e-mail       = tt-ped-venda-xml.e-mail.
    if  tt-ped-venda-xml.nome-transp  = "":U then assign tt-ped-venda.nome-transp  = tt-ped-venda-sdf.nome-transp.  else assign tt-ped-venda-sdf.nome-transp  = tt-ped-venda-xml.nome-transp.
    if  tt-ped-venda-xml.cod-rota     = "":U then assign tt-ped-venda.cod-rota     = tt-ped-venda-sdf.cod-rota.     else assign tt-ped-venda-sdf.cod-rota     = tt-ped-venda-xml.cod-rota.

    run inputTable           in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultPriceTable in h-bodi159sdf.
    run outputTable          in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.nr-tabpre = "":U
    and tt-ped-venda-xml.tp-preco <> 1 then assign tt-ped-venda.nr-tabpre = tt-ped-venda-sdf.nr-tabpre. else assign tt-ped-venda-sdf.nr-tabpre = tt-ped-venda-xml.nr-tabpre.

    run inputTable                   in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultPriceTableContents in h-bodi159sdf.
    run outputTable                  in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.mo-codigo = 0 then assign tt-ped-venda.mo-codigo = tt-ped-venda-sdf.mo-codigo. else assign tt-ped-venda-sdf.mo-codigo = tt-ped-venda-xml.mo-codigo.

    run inputTable             in h-bodi159sdf(input  table tt-ped-venda-sdf).
    run setDefaultCentralSales in h-bodi159sdf.
    run outputTable            in h-bodi159sdf(output table tt-ped-venda-sdf).
    find first tt-ped-venda-sdf no-error.

    if  tt-ped-venda-xml.estab-atend   = "":U then assign tt-ped-venda.estab-atend   = tt-ped-venda-sdf.estab-atend.   else assign tt-ped-venda-sdf.estab-atend   = tt-ped-venda-xml.estab-atend.
    if  tt-ped-venda-xml.estab-central = "":U then assign tt-ped-venda.estab-central = tt-ped-venda-sdf.estab-central. else assign tt-ped-venda-sdf.estab-central = tt-ped-venda-xml.estab-central.
    IF l-tp-pedido THEN
        if  tt-ped-venda-xml.tp-pedido     = "":U then assign tt-ped-venda.tp-pedido     = tt-ped-venda-sdf.tp-pedido.     else assign tt-ped-venda-sdf.tp-pedido     = tt-ped-venda-xml.tp-pedido.
end procedure.

procedure pi-SetDefaultItem:
    /*
    tt-ped-item     - temp-table oficial
    tt-ped-item-sdf - temp-table com os defaults setados
    tt-ped-item-xml - temp-table com o original vindo do xml
    */


    if  not valid-handle(h-bodi154sdf)
    or  h-bodi154sdf:TYPE       <> "PROCEDURE":U
    or  h-bodi154sdf:FILE-NAME  <> "dibo/bodi154sdf.p":U then
        run dibo/bodi154sdf.p persistent set h-bodi154sdf.

    for each tt-ped-item-xml:
        delete tt-ped-item-xml.
    end.
    for each tt-ped-item-sdf:
        delete tt-ped-item-sdf.
    end.

    find first tt-ped-venda no-error.

    /* Incialmente a tt de default e a tt vinda do xml s∆o c¢pia da original(tt-ped-item), 
       que recebeu os conte£dos das tag's no in°cio do adapter */
    create tt-ped-item-xml.
    buffer-copy tt-ped-item to tt-ped-item-xml.

    create tt-ped-item-sdf.
    buffer-copy tt-ped-item to tt-ped-item-sdf.

    run setUserLog       in h-bodi154sdf(input  tt-ped-venda.user-alt).
    run inputParentTable in h-bodi154sdf(input  table tt-ped-venda).
    run inputTable       in h-bodi154sdf(input  table tt-ped-item-sdf).
    run setDefaultItem   in h-bodi154sdf.
    run outputTable      in h-bodi154sdf(output table tt-ped-item-sdf).
    find first tt-ped-item-sdf no-error.

    /* se a ped-item do xml Ç "" ent∆o a original recebe o default, sen∆o a default recebe o que est† no xml */
    if  tt-ped-item-xml.tp-preco                = 0
    or  tt-ped-item-xml.tp-preco                = ?    then assign tt-ped-item.tp-preco                = tt-ped-item-sdf.tp-preco.                else assign tt-ped-item-sdf.tp-preco                = tt-ped-item-xml.tp-preco.
    if  tt-ped-item-xml.nr-tabpre               = "":U
    and tt-ped-item-xml.tp-preco               <> 1    then assign tt-ped-item.nr-tabpre               = tt-ped-item-sdf.nr-tabpre.               else assign tt-ped-item-sdf.nr-tabpre               = tt-ped-item-xml.nr-tabpre.
    if  tt-ped-item-xml.dt-entrega              = ?    then assign tt-ped-item.dt-entrega              = tt-ped-item-sdf.dt-entrega.              else assign tt-ped-item-sdf.dt-entrega              = tt-ped-item-xml.dt-entrega.
    if  tt-ped-item-xml.cod-entrega             = "":U then assign tt-ped-item.cod-entrega             = tt-ped-item-sdf.cod-entrega.             else assign tt-ped-item-sdf.cod-entrega             = tt-ped-item-xml.cod-entrega.
    if  tt-ped-item-xml.dt-min-fat              = ?    then assign tt-ped-item.dt-min-fat              = tt-ped-item-sdf.dt-min-fat.              else assign tt-ped-item-sdf.dt-min-fat              = tt-ped-item-xml.dt-min-fat.
    if  tt-ped-item-xml.nat-operacao            = "":U then assign tt-ped-item.nat-operacao            = tt-ped-item-sdf.nat-operacao.            else assign tt-ped-item-sdf.nat-operacao            = tt-ped-item-xml.nat-operacao.
    if  tt-ped-item-xml.dt-entorig              = ?    then assign tt-ped-item.dt-entorig              = tt-ped-item-sdf.dt-entorig.              else assign tt-ped-item-sdf.dt-entorig              = tt-ped-item-xml.dt-entorig.
    if  tt-ped-item-xml.esp-ped                 = 0    then assign tt-ped-item.esp-ped                 = tt-ped-item-sdf.esp-ped.                 else assign tt-ped-item-sdf.esp-ped                 = tt-ped-item-xml.esp-ped.
    if  tt-ped-item-xml.tipo-atend              = 0    then assign tt-ped-item.tipo-atend              = tt-ped-item-sdf.tipo-atend.              else assign tt-ped-item-sdf.tipo-atend              = tt-ped-item-xml.tipo-atend.
    if  tt-ped-item-xml.dt-userimp              = ?    then assign tt-ped-item.dt-userimp              = tt-ped-item-sdf.dt-userimp.              else assign tt-ped-item-sdf.dt-userimp              = tt-ped-item-xml.dt-userimp.
    if  tt-ped-item-xml.user-impl               = "":U then assign tt-ped-item.user-impl               = tt-ped-item-sdf.user-impl.               else assign tt-ped-item-sdf.user-impl               = tt-ped-item-xml.user-impl.
    if  tt-ped-item-xml.log-usa-tabela-desconto = ?    then assign tt-ped-item.log-usa-tabela-desconto = tt-ped-item-sdf.log-usa-tabela-desconto. else assign tt-ped-item-sdf.log-usa-tabela-desconto = tt-ped-item-xml.log-usa-tabela-desconto.
    if  tt-ped-item-xml.cd-origem               = 0    then assign tt-ped-item.cd-origem               = tt-ped-item-sdf.cd-origem.               else assign tt-ped-item-sdf.cd-origem               = tt-ped-item-xml.cd-origem.
    if  tt-ped-item-xml.nr-sequencia            = 0    then assign tt-ped-item.nr-sequencia            = tt-ped-item-sdf.nr-sequencia.            else assign tt-ped-item-sdf.nr-sequencia            = tt-ped-item-xml.nr-sequencia.
    &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
        if  tt-ped-item-xml.des-un-medida   = "":U then assign tt-ped-item.des-un-medida               = tt-ped-item-sdf.des-un-medida.           else assign tt-ped-item-sdf.des-un-medida           = tt-ped-item-xml.des-un-medida.
    &else
        if  substring(tt-ped-item-xml.char-2,9,2)   = "":U then assign substring(tt-ped-item.char-2,9,2)= substr(tt-ped-item-sdf.char-2,9,2).     else assign substring(tt-ped-item-sdf.char-2,9,2)   = substring(tt-ped-item-xml.char-2,9,2).
    &endif
    
    &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
        assign tt-ped-item.dec-ftconv-unest     = tt-ped-item-sdf.dec-ftconv-unest.
        assign tt-ped-item.num-casa-dec-unest   = tt-ped-item-sdf.num-casa-dec-unest.
        assign tt-ped-item.ind-origem-fator     = tt-ped-item-sdf.ind-origem-fator.
    &endif

    if  tt-ped-item-xml.ind-fat-qtfam           = ?    then assign tt-ped-item.ind-fat-qtfam           = tt-ped-item-sdf.ind-fat-qtfam.           else assign tt-ped-item-sdf.ind-fat-qtfam           = tt-ped-item-xml.ind-fat-qtfam.
    if  substring(tt-ped-item-xml.char-2,11,17) = "":U then assign substring(tt-ped-item.char-2,11,17) = substring(tt-ped-item-sdf.char-2,11,17). else assign substring(tt-ped-item-sdf.char-2,11,17) = substring(tt-ped-item-xml.char-2,11,17).
    if  substring(tt-ped-item-xml.char-2,1,8)   = "":U then assign substring(tt-ped-item.char-2,1,8)   = substring(tt-ped-item-sdf.char-2,1,8).   else assign substring(tt-ped-item-sdf.char-2,1,8)   = substring(tt-ped-item-xml.char-2,1,8).
    if  tt-ped-item-xml.ind-icm-ret             = ?    then assign tt-ped-item.ind-icm-ret             = tt-ped-item-sdf.ind-icm-ret.             else assign tt-ped-item-sdf.ind-icm-ret             = tt-ped-item-xml.ind-icm-ret.

    &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
        IF tt-ped-item-xml.cod-unid-negoc = "" THEN
           assign tt-ped-item.cod-unid-negoc = tt-ped-item-sdf.cod-unid-negoc.
        ELSE
           assign tt-ped-item.cod-unid-negoc = tt-ped-item-xml.cod-unid-negoc.
    &ENDIF

    run inputTable                in h-bodi154sdf(input  table tt-ped-item-sdf).
    run inputParentTable          in h-bodi154sdf(input  table tt-ped-venda).
    run setDefaultDescontoICMS    in h-bodi154sdf.
    run setDefaultTransactionType in h-bodi154sdf.
    run outputTable               in h-bodi154sdf(output table tt-ped-item-sdf).
    find first tt-ped-item-sdf no-error.

    if  tt-ped-item-xml.cod-sit-com = 0 then assign tt-ped-item.cod-sit-com = tt-ped-item-sdf.cod-sit-com. else assign tt-ped-item-sdf.cod-sit-com = tt-ped-item-xml.cod-sit-com.

    if tt-ped-item-xml.per-des-icms = ? then assign tt-ped-item.per-des-icms = tt-ped-item-sdf.per-des-icms. else assign tt-ped-item-sdf.per-des-icms = tt-ped-item-xml.per-des-icms.

    /*
    n∆o executar esta procedure quando tt-ped-venda.ind-orig-entrada = 14 (CRM), pois trata a tabela de descontos, 
    sendo que assumiremos o valor vindo do CRM. No caso do B2B ser∆o efetuados todos os descontos.
    */
    if  tt-ped-venda.ind-orig-entrada <> 14 /* CRM */ then do:
        run inputTable         in h-bodi154sdf(input  table tt-ped-item-sdf).
        run setDefaultDiscount in h-bodi154sdf.
        run outputTable        in h-bodi154sdf(output table tt-ped-item-sdf).
        find first tt-ped-item-sdf no-error.

        if  tt-ped-item-xml.val-desconto[1]          = 0 then assign tt-ped-item.val-desconto[1]          = tt-ped-item-sdf.val-desconto[1].          else assign tt-ped-item-sdf.val-desconto[1]          = tt-ped-item-xml.val-desconto[1].
        if  tt-ped-item-xml.val-desconto[2]          = 0 then assign tt-ped-item.val-desconto[2]          = tt-ped-item-sdf.val-desconto[2].          else assign tt-ped-item-sdf.val-desconto[2]          = tt-ped-item-xml.val-desconto[2].
        if  tt-ped-item-xml.val-desconto[3]          = 0 then assign tt-ped-item.val-desconto[3]          = tt-ped-item-sdf.val-desconto[3].          else assign tt-ped-item-sdf.val-desconto[3]          = tt-ped-item-xml.val-desconto[3].
        if  tt-ped-item-xml.val-desconto[4]          = 0 then assign tt-ped-item.val-desconto[4]          = tt-ped-item-sdf.val-desconto[4].          else assign tt-ped-item-sdf.val-desconto[4]          = tt-ped-item-xml.val-desconto[4].
        if  tt-ped-item-xml.val-desconto[5]          = 0 then assign tt-ped-item.val-desconto[5]          = tt-ped-item-sdf.val-desconto[5].          else assign tt-ped-item-sdf.val-desconto[5]          = tt-ped-item-xml.val-desconto[5].
        if  tt-ped-item-xml.val-pct-desconto-periodo = 0 then assign tt-ped-item.val-pct-desconto-periodo = tt-ped-item-sdf.val-pct-desconto-periodo. else assign tt-ped-item-sdf.val-pct-desconto-periodo = tt-ped-item-xml.val-pct-desconto-periodo.
        if  tt-ped-item-xml.val-pct-desconto-prazo   = 0 then assign tt-ped-item.val-pct-desconto-prazo   = tt-ped-item-sdf.val-pct-desconto-prazo.   else assign tt-ped-item-sdf.val-pct-desconto-prazo   = tt-ped-item-xml.val-pct-desconto-prazo.
        if  tt-ped-item-xml.log-concede-bonif-qtd    = ? then assign tt-ped-item.log-concede-bonif-qtd    = tt-ped-item-sdf.log-concede-bonif-qtd.    else assign tt-ped-item-sdf.log-concede-bonif-qtd    = tt-ped-item-xml.log-concede-bonif-qtd.
    end.

    run inputTable        in h-bodi154sdf(input  table tt-ped-item-sdf).
    run setDefaultItemTax in h-bodi154sdf.
    run outputTable       in h-bodi154sdf(output table tt-ped-item-sdf).
    find first tt-ped-item-sdf no-error.

    if  tt-ped-item-xml.cod-vat = 0 then assign tt-ped-item.cod-vat = tt-ped-item-sdf.cod-vat. else assign tt-ped-item-sdf.cod-vat = tt-ped-item-xml.cod-vat.

    run inputTable           in h-bodi154sdf(input  table tt-ped-item-sdf).
    run setDefaultPriceTable in h-bodi154sdf.
    run outputTable          in h-bodi154sdf(output table tt-ped-item-sdf).
    find first tt-ped-item-sdf no-error.

    if  tt-ped-item-xml.nr-tabpre = "":U
    and tt-ped-item-xml.tp-preco <> 1 then assign tt-ped-item.nr-tabpre = tt-ped-item-sdf.nr-tabpre. else assign tt-ped-item-sdf.nr-tabpre = tt-ped-item-xml.nr-tabpre.
end procedure.

procedure pi-valida-estrutura-repres:

    def var c-no-ab-reppri-retornado like ped-venda.no-ab-reppri no-undo.

    if  tt-ped-venda.no-ab-reppri = "" then do:
        if  not valid-handle(h-bodi159sdf)
        or  h-bodi159sdf:type      <> "PROCEDURE":U
        or  h-bodi159sdf:file-name <> "dibo/bodi159sdf.p":U then
            run dibo/bodi159sdf.p persistent set h-bodi159sdf.

        run setDefaultRepresentative in h-bodi159sdf (input  tt-ped-venda.no-ab-reppri,
                                                      output c-no-ab-reppri-retornado).

        /* A procedure setDefaultRepresentative pesquisar† o representante pelo nome-abreviado e, se n∆o encontrar, pesquisar† pelo c¢digo.
           Se n∆o encontrar nenhum registro mesmo assim, o parÉmetro c-no-ab-reppri-retornado retornar† igual a brancos.
           Se encontrar, o parÉmetro retornar† com o conte£do de tt-ped-venda.no-ab-reppri. */

        assign tt-ped-venda.no-ab-reppri = c-no-ab-reppri-retornado.
    end.
end procedure.

procedure pi-cria-estrutura-repres:
    find first tt-ped-venda no-error.
    find first tt-ped-repre where tt-ped-repre.nome-ab-rep = tt-ped-venda.no-ab-reppri no-error.

    if  not avail tt-ped-repre then do:
        run getRowid in h-bodi159 (output r-ped-venda).

        if  not valid-handle(h-bodi157)
        or  h-bodi157:type      <> "PROCEDURE":U
        or  h-bodi157:file-name <> "dibo/bodi157.p":U then
            run dibo/bodi157.p persistent set h-bodi157.

        run createOrdersRepresentatives in h-bodi157 (input r-ped-venda).
    end.
end procedure.

procedure pi-cria-pedido:
    define variable l-enableVendor as logical no-undo.

    if  not can-find (first ped-venda
                      where ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                      and   ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli) then do:

        for each tt-erro-neogrid:
            delete tt-erro-neogrid.
        end.

        if  not valid-handle(h-bodi159)
        or  h-bodi159:type      <> "PROCEDURE":U
        or  h-bodi159:file-name <> "dibo/bodi159.p":U then
            run dibo/bodi159.p persistent set h-bodi159.

        if  not valid-handle(h-bodi154)
        or  h-bodi154:type      <> "PROCEDURE":U
        or  h-bodi154:file-name <> "dibo/bodi154.p":U then
            run dibo/bodi154.p persistent set h-bodi154.

        if  not valid-handle(h-bodi154can)
        or  h-bodi154can:type      <> "PROCEDURE":U
        or  h-bodi154can:file-name <> "dibo/bodi154can.p" then
            run dibo/bodi154can.p persistent set h-bodi154can.

        if  not valid-handle(h-bodi157)
        or  h-bodi157:type      <> "PROCEDURE":U
        or  h-bodi157:file-name <> "dibo/bodi157.p":U then
            run dibo/bodi157.p persistent set h-bodi157.

        if  not valid-handle(h-bodi149)
        or  h-bodi149:type      <> "PROCEDURE":U
        or  h-bodi149:file-name <> "dibo/bodi149.p":U then
            run dibo/bodi149.p persistent set h-bodi149.

        if  not valid-handle(h-bodi757)
        or  h-bodi757:type      <> "PROCEDURE":U
        or  h-bodi757:file-name <> "dibo/bodi757.p":U then
            run dibo/bodi757.p persistent set h-bodi757.

        if  not valid-handle(h-bodi018)
        or  h-bodi018:type      <> "PROCEDURE":U
        or  h-bodi018:file-name <> "dibo/bodi018.p":U then
            run dibo/bodi018.p persistent set h-bodi018.

        if  not valid-handle(h-bodi159com)
        or  h-bodi159com:type      <> "PROCEDURE":U
        or  h-bodi159com:file-name <> "dibo/bodi159com.p":U then
            run dibo/bodi159com.p persistent set h-bodi159com.

        if  param-global.modulo-05 then  /*Vendor*/
            if  not valid-handle(h-bodi159ven)
            or  h-bodi159ven:type      <> "PROCEDURE":U
            or  h-bodi159ven:file-name <> "dibo/bodi159ven.p":U then
                run dibo/bodi159ven.p persistent set h-bodi159ven.

        CRIA-PEDIDO:
        do  transaction:
            find first tt-ped-venda no-error.
            find first tt-pd-vendor no-error.

            run pi-SetDefaultPedido.
            run openQueryStatic in h-bodi159 (input "Main").

            if  param-global.modulo-05 then do: /*Vendor*/
                run enableVendorInformation in h-bodi159ven (input IF int(c-modalidade) = 7 THEN "Vendor" ELSE "0",
                                                             input tt-ped-venda.cod-cond-pag,
                                                             output l-enableVendor).
                if  l-enableVendor then
                    run inputRowVendor in h-bodi159 (input table tt-pd-vendor).
            end.

            run setUserLog     in h-bodi159(input  tt-ped-venda.user-alt).
            run emptyRowObject in h-bodi159.
            run setRecord      in h-bodi159 (input table tt-ped-venda).
            run emptyRowErrors in h-bodi159.
            run createRecord   in h-bodi159.

            if  return-value = "NOK":U then do:
                run getRowErrors   in h-bodi159 (output table RowErrors).

                for each  RowErrors
                    where RowErrors.errorType    = "INTERNAL":U 
                    or    RowErrors.ErrorSubType = "WARNING":U 
                    or    RowErrors.ErrorSubType = "INFORMATION":U :
                    delete RowErrors.
                end.

                {adapters/neogrid/pdp/anepd015.i RowErrors}
            end.
            else do: /* S¢ implanta as tabelas relacionadas se conseguir implantar a ped-venda (conforme PD4000) */
                run getIntField in h-bodi159 (input "nr-pedido":U, output i-nr-pedido).

                /* Repasse do nr-pedido Ös tabelas relacionadas */
                for each tt-ped-repre:
                    assign tt-ped-repre.nr-pedido = i-nr-pedido.
                end.
                for each tt-cond-ped:
                    assign tt-cond-ped.nr-pedido = i-nr-pedido.
                end.

                run pi-cria-estrutura-repres.

                /* Grava ped-repre */
                for each tt-ped-repre:
                    run pi-ped-repre.
                end.
                /* Grava ped-item */
                for each tt-ped-item:
                    run pi-item.
                end.
                /* Grava cond-ped */
                if  tt-ped-venda.cod-cond-pag = 0 then do:
                    for each tt-cond-ped:
                        run pi-cond-ped.
                    end.
                end.

                run pi-completa-pedido.

                find first tt-erro-neogrid no-error.
                if  avail tt-erro-neogrid then
                    undo CRIA-PEDIDO, leave.
            end. /* fim return-value */
        end. /* fim transaá∆o CRIA-PEDIDO */

    /********************************************************************/
    /*  Retirada a alocacao fisica/logica do completeorder para retirar */
    /*  da transacao de inclusao/completa do pedido.                    */
    /*  Assim a transacao tera escopo reduzido pois ira ser item a item */
    /********************************************************************/

        FIND FIRST b-ped-venda NO-LOCK
             WHERE ROWID(b-ped-venda) = r-ped-venda NO-ERROR.
        IF AVAIL b-ped-venda THEN
           RUN pi-aloca.

    end.

end procedure.

procedure pi-altera-pedido:
    define variable l-enableVendor as logical no-undo.

    if  can-find (first ped-venda
                  where ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                  and   ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli) then do:
        for each tt-erro-neogrid:
            delete tt-erro-neogrid.
        end.

        if  not valid-handle(h-bodi159)
        or  h-bodi159:type      <> "PROCEDURE":U
        or  h-bodi159:file-name <> "dibo/bodi159.p":U then
            run dibo/bodi159.p persistent set h-bodi159.

        if  not valid-handle(h-bodi154)
        or  h-bodi154:type      <> "PROCEDURE":U
        or  h-bodi154:file-name <> "dibo/bodi154.p":U then
            run dibo/bodi154.p persistent set h-bodi154.

        if  not valid-handle(h-bodi157)
        or  h-bodi157:type      <> "PROCEDURE":U
        or  h-bodi157:file-name <> "dibo/bodi157.p":U then
            run dibo/bodi157.p persistent set h-bodi157.

        if  not valid-handle(h-bodi149)
        or  h-bodi149:type      <> "PROCEDURE":U
        or  h-bodi149:file-name <> "dibo/bodi149.p":U then
            run dibo/bodi149.p persistent set h-bodi149.

        if  not valid-handle(h-bodi757)
        or  h-bodi757:type      <> "PROCEDURE":U
        or  h-bodi757:file-name <> "dibo/bodi757.p":U then
            run dibo/bodi757.p persistent set h-bodi757.

        if  not valid-handle(h-bodi154can)
        or  h-bodi154can:type      <> "PROCEDURE":U
        or  h-bodi154can:file-name <> "dibo/bodi154can.p" then
            run dibo/bodi154can.p persistent set h-bodi154can.

        if  not valid-handle(h-bodi018)
        or  h-bodi018:type      <> "PROCEDURE":U
        or  h-bodi018:file-name <> "dibo/bodi018.p":U then
            run dibo/bodi018.p persistent set h-bodi018.

        if  not valid-handle(h-bodi159com)
        or  h-bodi159com:type      <> "PROCEDURE":U
        or  h-bodi159com:file-name <> "dibo/bodi159com.p":U then
            run dibo/bodi159com.p persistent set h-bodi159com.

        if  param-global.modulo-05 then  /*Vendor*/
            if  not valid-handle(h-bodi159ven)
            or  h-bodi159ven:type      <> "PROCEDURE":U
            or  h-bodi159ven:file-name <> "dibo/bodi159ven.p":U then
                run dibo/bodi159ven.p persistent set h-bodi159ven.

        ALT-PEDIDO:
        do  transaction:
            find first tt-ped-venda no-error.
            find first tt-pd-vendor no-error.

            run pi-SetDefaultPedido.
            run openQueryStatic in h-bodi159 (input "Main").
            run goToKey         in h-bodi159 (input tt-ped-venda.nome-abrev, input tt-ped-venda.nr-pedcli).

            if  param-global.modulo-05 then do:  /*Vendor*/
                run enableVendorInformation in h-bodi159ven (input {adinc/i03ad209.i 06 c-modalidade},
                                                             input tt-ped-venda.cod-cond-pag,
                                                             output l-enableVendor).

                if  l-enableVendor then
                    run inputRowVendor in h-bodi159 (input table tt-pd-vendor).
            end.

            run setUserLog     in h-bodi159 (input  tt-ped-venda.user-alt).
            run emptyRowObject in h-bodi159.
            run setRecord      in h-bodi159 (input table tt-ped-venda).
            run emptyRowErrors in h-bodi159.
            run updateRecord   in h-bodi159. 

            if  return-value = "NOK":U then do:
                run getRowErrors in h-bodi159 (output table RowErrors).

                for each  RowErrors
                    where RowErrors.errorType    = "INTERNAL":U 
                    or    RowErrors.ErrorSubType = "WARNING":U 
                    or    RowErrors.ErrorSubType = "INFORMATION":U :
                    delete RowErrors.
                end.
                {adapters/neogrid/pdp/anepd015.i RowErrors}
            end.
            else do:
                run getIntField in h-bodi159 (input "nr-pedido":U, output i-nr-pedido).

                /* Repasse do nr-pedido Ös tabelas relacionadas */
                for each tt-ped-repre:
                    assign tt-ped-repre.nr-pedido = i-nr-pedido.
                end.
                for each tt-cond-ped:
                    assign tt-cond-ped.nr-pedido = i-nr-pedido.
                end.

                run pi-cria-estrutura-repres.

                run pi-consiste-eliminacao.

                /* Grava ped-repre */
                for each tt-ped-repre:
                    run pi-ped-repre.
                end.
                /* Grava ped-item */
                for each tt-ped-item:
                    run pi-item.
                end.

                /* Grava cond-ped */
                if  tt-ped-venda.cod-cond-pag = 0 then do:
                    for each tt-cond-ped:
                        run pi-cond-ped.
                    end.
                end.

                run pi-completa-pedido.

                find first tt-erro-neogrid no-error.
                if  avail tt-erro-neogrid then
                    undo ALT-PEDIDO, leave.
            end. /* fim return-value */
        end. /* fim transaá∆o ALT-PEDIDO */
    end.
    else
        run pi-cria-pedido.
end procedure.

procedure pi-elimina-pedido:
    if  can-find (first ped-venda
                  where ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                  and   ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli) then do:
        for each tt-erro-neogrid:
            delete tt-erro-neogrid.
        end.

        if  not valid-handle(h-bodi159)
        or  h-bodi159:type      <> "PROCEDURE":U
        or  h-bodi159:file-name <> "dibo/bodi159.p":U then
            run dibo/bodi159.p persistent set h-bodi159.

        DEL-PEDIDO:
        do  transaction:
            find first tt-ped-venda no-error.
            run emptyRowErrors  in h-bodi159.
            run openQueryStatic in h-bodi159 (input "Main").
            run goToKey         in h-bodi159 (input tt-ped-venda.nome-abrev, input tt-ped-venda.nr-pedcli).
            run deleteRecord    in h-bodi159. 
            run getRowErrors    in h-bodi159 (output table RowErrors).

            for each RowErrors
                where RowErrors.errorType    = "INTERNAL":U 
                or    RowErrors.ErrorSubType = "WARNING":U 
                or    RowErrors.ErrorSubType = "INFORMATION":U :
                delete RowErrors.
            end.

            {adapters/neogrid/pdp/anepd015.i RowErrors}

            find first tt-erro-neogrid no-error.
            if  avail tt-erro-neogrid then
                undo DEL-PEDIDO, leave.
        end. /* fim transaá∆o DEL-PEDIDO */
    end.
end procedure.

procedure pi-cancela-pedido:
    run pi-altera-pedido.

    find first tt-ped-venda no-error.

    if  not valid-handle(h-bodi159can)
    or  h-bodi159can:type      <> "PROCEDURE":U
    or  h-bodi159can:file-name <> "dibo/bodi159can.p" then
        run dibo/bodi159can.p persistent set h-bodi159can.

    CAN-PEDIDO:
    do transaction:
        run setUserLog          in h-bodi159can (input tt-ped-venda.user-canc).  
        run emptyRowErrors      in h-bodi159.
        run emptyRowErrors      in h-bodi159can.
        run openQueryStatic     in h-bodi159    (input "Main").
        run goToKey             in h-bodi159    (input tt-ped-venda.nome-abrev, input tt-ped-venda.nr-pedcli).
        run getRowid            in h-bodi159    (output r-ped-venda).
        run validateCancelation in h-bodi159can (input r-ped-venda,
                                                 output table RowErrors).

        for each  RowErrors
            where RowErrors.errorType    = "INTERNAL":U 
            or    RowErrors.ErrorSubType = "WARNING":U 
            or    RowErrors.ErrorSubType = "INFORMATION":U :
            delete RowErrors.
        end.

        {adapters/neogrid/pdp/anepd015.i RowErrors}

        run updateCancelation in h-bodi159can (input r-ped-venda,
                                               input tt-ped-venda.desc-cancela,
                                               input tt-ped-venda.dt-cancela,
                                               input tt-ped-venda.cod-mot-canc-cot).
        run getRowErrors      in h-bodi159can (output table RowErrors).

        for each  RowErrors
            where RowErrors.errorType    = "INTERNAL":U 
            or    RowErrors.ErrorSubType = "WARNING":U 
            or    RowErrors.ErrorSubType = "INFORMATION":U :
            delete RowErrors.
        end.

        {adapters/neogrid/pdp/anepd015.i RowErrors}

        find first tt-erro-neogrid no-error.
        if  avail tt-erro-neogrid then
            undo CAN-PEDIDO, leave.
    end.  /* fim transaá∆o CAN-PEDIDO */
end procedure.

PROCEDURE pi-suspende-pedido:
    RUN pi-altera-pedido.

    FIND FIRST tt-ped-venda NO-ERROR.

    IF  tt-ped-venda.cod-sit-ped <> 5 THEN DO:
        IF  NOT VALID-HANDLE(h-bodi159sus)
        OR  h-bodi159sus:TYPE      <> "PROCEDURE":U
        OR  h-bodi159sus:FILE-NAME <> "dibo/bodi159sus.p":U THEN
            RUN dibo/bodi159sus.p PERSISTENT SET h-bodi159sus.

        SUS-PEDIDO:
        DO TRANSACTION:
            RUN setUserLog         IN h-bodi159sus (INPUT tt-ped-venda.user-susp). /* Ver como recebe o usuario pelo xml */
            RUN emptyRowErrors     IN h-bodi159.
            RUN emptyRowErrors     IN h-bodi159sus.
            RUN openQueryStatic    IN h-bodi159    (INPUT "Main").
            RUN goToKey            IN h-bodi159    (INPUT tt-ped-venda.nome-abrev, INPUT tt-ped-venda.nr-pedcli).
            RUN getRowid           IN h-bodi159    (OUTPUT r-ped-venda).
            RUN getRowErrors       IN h-bodi159    (OUTPUT TABLE RowErrors).
            RUN validateSuspension IN h-bodi159sus (INPUT r-ped-venda,
                                                    OUTPUT TABLE RowErrors).

            FOR EACH  RowErrors
                WHERE RowErrors.errorType    = "INTERNAL":U 
                OR    RowErrors.ErrorSubType = "WARNING":U 
                OR    RowErrors.ErrorSubType = "INFORMATION":U :
                DELETE RowErrors.
            END.

            {adapters/neogrid/pdp/anepd015.i RowErrors}

            RUN updateSuspension IN h-bodi159sus (INPUT r-ped-venda,
                                                  INPUT tt-ped-venda.cod-mot-canc-cot,
                                                  INPUT tt-ped-venda.desc-suspend).

            FIND FIRST tt-erro-neogrid NO-ERROR.
            IF  AVAIL tt-erro-neogrid THEN
                UNDO SUS-PEDIDO, LEAVE.
        END. /* fim transaá∆o SUS-PEDIDO */
    end.
END PROCEDURE.

PROCEDURE pi-reativa-pedido:

    FOR EACH tt-erro-neogrid:
        DELETE tt-erro-neogrid.
    END.

    FIND FIRST tt-ped-venda NO-ERROR.

    IF  tt-ped-venda.cod-sit-ped = 5 THEN DO:
        IF  NOT VALID-HANDLE(h-bodi159rct)
        OR  h-bodi159rct:TYPE      <> "PROCEDURE":U
        OR  h-bodi159rct:FILE-NAME <> "dibo/bodi159rct.p":U THEN
            RUN dibo/bodi159rct.p PERSISTENT SET h-bodi159rct.

        IF  NOT VALID-HANDLE(h-bodi159)
        OR  h-bodi159:TYPE      <> "PROCEDURE":U
        OR  h-bodi159:FILE-NAME <> "dibo/bodi159.p":U THEN
            RUN dibo/bodi159.p PERSISTENT SET h-bodi159.

        REAT-PEDIDO:
        DO TRANSACTION:

            RUN setUserLog           IN h-bodi159rct (INPUT tt-ped-venda.user-reat).
            RUN emptyRowErrors       IN h-bodi159.
            RUN emptyRowErrors       IN h-bodi159rct.
            RUN openQueryStatic      IN h-bodi159    (INPUT "Main").
            RUN goToKey              IN h-bodi159    (INPUT tt-ped-venda.nome-abrev, INPUT tt-ped-venda.nr-pedcli).
            RUN getRowid             IN h-bodi159    (OUTPUT r-ped-venda).
            RUN getRowErrors         IN h-bodi159    (OUTPUT TABLE RowErrors).
            RUN validateReactivation IN h-bodi159rct (INPUT r-ped-venda,
                                                      OUTPUT TABLE RowErrors).
            FOR EACH  RowErrors
                WHERE RowErrors.errorType    = "INTERNAL":U 
                OR    RowErrors.ErrorSubType = "WARNING":U 
                OR    RowErrors.ErrorSubType = "INFORMATION":U :
                DELETE RowErrors.
            END.

            {adapters/neogrid/pdp/anepd015.i RowErrors}

            RUN updateReactivation IN h-bodi159rct (INPUT r-ped-venda,
                                                    INPUT tt-ped-venda.cod-mot-canc-cot,
                                                    INPUT tt-ped-venda.desc-reativa).

            FIND FIRST tt-erro-neogrid NO-ERROR.
            IF  AVAIL tt-erro-neogrid then DO:
                UNDO REAT-PEDIDO, LEAVE.
            END.
        END. /* fim transaá∆o REAT-PEDIDO */
    END.
END PROCEDURE.

procedure pi-item:
    run pi-SetDefaultItem.

    for each RowErrorsItem:
        delete RowErrorsItem.
    end.

    for each tt-ped-item-bo:
        delete tt-ped-item-bo.
    end.
    create tt-ped-item-bo.
    buffer-copy tt-ped-item to tt-ped-item-bo.
    find first tt-ped-item-bo no-error.
    find first tt-ped-venda   no-error.

    run setConstraintKey in h-bodi154(input tt-ped-item-bo.nome-abrev,
                                      input tt-ped-item-bo.nr-pedcli,
                                      input tt-ped-item-bo.nr-sequencia,
                                      input tt-ped-item-bo.it-codigo,
                                      input tt-ped-item-bo.cod-refer).
    run openQueryStatic in h-bodi154(input "Key":U).
    run goToKey         in h-bodi154 (input tt-ped-item-bo.nome-abrev,
                                      input tt-ped-item-bo.nr-pedcli,
                                      input tt-ped-item-bo.nr-sequencia,
                                      input tt-ped-item-bo.it-codigo,
                                      input tt-ped-item-bo.cod-refer).
    if  return-value = "NOK":U then do:
        run setUserLog     in h-bodi154 (input  tt-ped-venda.user-alt).
        run emptyRowObject in h-bodi154.
        run setRecord      in h-bodi154 (input table tt-ped-item-bo).
        run emptyRowErrors in h-bodi154.
        run createRecord   in h-bodi154.
    end.
    else do:
        run setUserLog     in h-bodi154 (input  tt-ped-venda.user-alt).
        run emptyRowObject in h-bodi154.
        run setRecord      in h-bodi154 (input table tt-ped-item-bo).
        run emptyRowErrors in h-bodi154.
        run updateRecord   in h-bodi154.
    end.

    run getRowErrors   in h-bodi154 (output table RowErrorsItem).

    for each  RowErrorsItem
        where RowErrorsItem.errorType    = "INTERNAL":U 
        or    RowErrorsItem.ErrorSubType = "WARNING":U 
        or    RowErrorsItem.ErrorSubType = "INFORMATION":U :
        delete RowErrorsItem.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsItem}

    /* Grava ped-ent */
    if  tt-ped-venda.esp-ped <> 1 then
        for each tt-ped-ent of tt-ped-item:
            run pi-ped-ent.
        end.

    /* Grava unid-neg-ped */
    &IF "{&bf_dis_versao_ems}" < "2.062" &THEN
        FIND FIRST para-dis NO-LOCK NO-ERROR.
        IF   AVAIL para-dis AND para-dis.log-unid-neg AND tt-ped-item-bo.ind-componen <> 3 THEN
             RUN pi-unid-neg-ped.
    &ENDIF

    /* Cancelamento de Item */
    if  tt-ped-item-bo.dt-canseq <> ? then
        run pi-cancela-item.
    
end procedure.

procedure pi-cancela-item:
    run emptyRowErrors      in h-bodi154.
    run emptyRowErrors      in h-bodi154can.
    run setUserLog          in h-bodi154can (input tt-ped-item-bo.user-canc).
    run getRowid            in h-bodi154    (output r-ped-item).
    run getRowErrors        in h-bodi154    (output table RowErrorsItem).
    run validateCancelation in h-bodi154can (input r-ped-item,
                                             input tt-ped-item-bo.desc-cancela,
                                             input-output table RowErrorsItem).

    for each  RowErrorsItem
        where RowErrorsItem.errorType    = "INTERNAL":U 
        or    RowErrorsItem.ErrorSubType = "WARNING":U 
        or    RowErrorsItem.ErrorSubType = "INFORMATION":U :
        delete RowErrorsItem.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsItem}

    run updateCancelation in h-bodi154can (input  r-ped-item,
                                           input  tt-ped-item-bo.desc-cancela,
                                           input  tt-ped-item-bo.dt-canseq,
                                           input  tt-ped-item-bo.cod-mot-canc-cot).
end procedure.

procedure pi-ped-ent:
    for each RowErrorsPedEnt:
        delete RowErrorsPedEnt.
    end.

    assign tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
           tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
           tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
           tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
           tt-ped-ent.cod-refer    = tt-ped-item.cod-refer.

    for each tt-ped-ent-bo:
        delete tt-ped-ent-bo.
    end.
    create tt-ped-ent-bo.
    buffer-copy tt-ped-ent to tt-ped-ent-bo.

    run openQueryStatic in h-bodi149 (input "Default":U).
    run goToKey         in h-bodi149 (input tt-ped-ent.nome-abrev,
                                      input tt-ped-ent.nr-pedcli,
                                      input tt-ped-ent.nr-sequencia,
                                      input tt-ped-ent.it-codigo,
                                      input tt-ped-ent.cod-refer,
                                      input tt-ped-ent.nr-entrega).

    if  return-value = "NOK":U  then do:
        run emptyRowObject  in h-bodi149.
        run setRecord       in h-bodi149(input table tt-ped-ent-bo).
        run emptyRowErrors  in h-bodi149.
        run createRecord    in h-bodi149.
    end.
    else do:
        run emptyRowObject in h-bodi149.
        run setRecord      in h-bodi149 (input table tt-ped-ent-bo).
        run emptyRowErrors in h-bodi149.
        run updateRecord   in h-bodi149.
    end.

    run getRowErrors    in h-bodi149 (output table RowErrorsPedEnt).

    for each  RowErrorsPedEnt
        where RowErrorsPedEnt.errorType    = "INTERNAL":U 
        or    RowErrorsPedEnt.ErrorSubType = "WARNING":U 
        or    RowErrorsPedEnt.ErrorSubType = "INFORMATION":U :
        delete RowErrorsPedEnt.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsPedEnt}
end procedure.

procedure pi-ped-repre:
    for each RowErrorsPedRepre:
        delete RowErrorsPedRepre.
    end.

    for each tt-ped-repre-bo:
        delete tt-ped-repre-bo.
    end.
    create tt-ped-repre-bo.
    buffer-copy tt-ped-repre to tt-ped-repre-bo.

    run openQueryStatic in h-bodi157 (input "Default":U).
    run goToKey         in h-bodi157 (input tt-ped-repre.nr-pedido, input tt-ped-repre.nome-ab-rep).

    if  return-value = "NOK":U then do:
        run emptyRowObject  in h-bodi157.
        run setRecord       in h-bodi157(input table tt-ped-repre-bo).
        run emptyRowErrors  in h-bodi157.
        run createRecord    in h-bodi157.
    end.
    else do:
        run emptyRowObject in h-bodi157.
        run setRecord      in h-bodi157 (input table tt-ped-repre-bo).
        run emptyRowErrors in h-bodi157.
        run updateRecord   in h-bodi157.
    end.

    run getRowErrors    in h-bodi157(output table RowErrorsPedRepre).

    for each  RowErrorsPedRepre
        where RowErrorsPedRepre.errorType    = "INTERNAL":U 
        or    RowErrorsPedRepre.ErrorSubType = "WARNING":U 
        or    RowErrorsPedRepre.ErrorSubType = "INFORMATION":U :
        delete RowErrorsPedRepre.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsPedRepre}
end procedure.

procedure pi-cond-ped:
    for each RowErrorsCondPed:
        delete RowErrorsCondPed.
    end.

    for each tt-cond-ped-bo:
        delete tt-cond-ped-bo.
    end.
    create tt-cond-ped-bo.
    buffer-copy tt-cond-ped to tt-cond-ped-bo.

    run openQueryStatic in h-bodi018 (input "DefaultPD4000":U).
    run goToKey         in h-bodi018 (input tt-cond-ped.nr-pedido, input tt-cond-ped.nr-sequencia).

    if  return-value = "NOK":U then do:
        run emptyRowObject  in h-bodi018.
        run setRecord       in h-bodi018 (input table tt-cond-ped-bo).
        run emptyRowErrors  in h-bodi018.
        run createRecord    in h-bodi018.
    end.
    else do:
        run emptyRowObject in h-bodi018.
        run setRecord      in h-bodi018 (input table tt-cond-ped-bo).
        run emptyRowErrors in h-bodi018.
        run updateRecord   in h-bodi018.
    end.

    run getRowErrors    in h-bodi018 (output table RowErrorsCondPed).

    for each  RowErrorsCondPed
        where RowErrorsCondPed.errorType    = "INTERNAL":U 
        or    RowErrorsCondPed.ErrorSubType = "WARNING":U 
        or    RowErrorsCondPed.ErrorSubType = "INFORMATION":U :
        delete RowErrorsCondPed.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsCondPed}
end procedure.

procedure pi-consiste-eliminacao:
    def var i-PedRepre-nr-pedido   as int  no-undo.
    def var c-PedRepre-nome-ab-rep as char no-undo.
    def var c-PedItem-nome-abrev   as char no-undo. 
    def var c-PedItem-nr-pedcli    as char no-undo.
    def var i-PedItem-nr-sequencia as int  no-undo. 
    def var c-PedItem-it-codigo    as char no-undo. 
    def var c-PedItem-cod-refer    as char no-undo.
    def var i-CondPed-nr-pedido    as int  no-undo.
    def var i-CondPed-nr-sequencia as int  no-undo.

    find first tt-ped-venda no-error.

    /* ped-repre */
    for each tt-ped-repre-consiste:
        delete tt-ped-repre-consiste.
    end.
    for each  ped-repre no-lock
        where ped-repre.nr-pedido = tt-ped-venda.nr-pedido:
        create tt-ped-repre-consiste.
        buffer-copy ped-repre to tt-ped-repre-consiste.
    end.

    for each tt-ped-repre-consiste:
        find first tt-ped-repre
             where tt-ped-repre.nr-pedido   = tt-ped-repre-consiste.nr-pedido
             and   tt-ped-repre.nome-ab-rep = tt-ped-repre-consiste.nome-ab-rep no-error.
        if  not avail tt-ped-repre then do:
            run openQueryStatic in h-bodi157 (input "Default":U).
            run goToKey         in h-bodi157 (input tt-ped-repre-consiste.nr-pedido,
                                              input tt-ped-repre-consiste.nome-ab-rep).
            if  return-value = "OK":U then
                run deleteRecord in h-bodi157.

            run getRowErrors in h-bodi157 (output table RowErrorsPedRepre).
        end.
    end.

    for each  RowErrorsPedRepre
        where RowErrorsPedRepre.errorType    = "INTERNAL":U 
        or    RowErrorsPedRepre.ErrorSubType = "WARNING":U 
        or    RowErrorsPedRepre.ErrorSubType = "INFORMATION":U :
        delete RowErrorsPedRepre.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsPedRepre}

    /* ped-item */
    for each tt-ped-item-consiste:
        delete tt-ped-item-consiste.
    end.
    for each  ped-item no-lock
        where ped-item.nome-abrev = tt-ped-venda.nome-abrev
        and   ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli:
        create tt-ped-item-consiste.
        buffer-copy ped-item to tt-ped-item-consiste.
    end.

    for each tt-ped-item-consiste:
        find first tt-ped-item
             where tt-ped-item.nome-abrev   = tt-ped-item-consiste.nome-abrev
             and   tt-ped-item.nr-pedcli    = tt-ped-item-consiste.nr-pedcli
             and   tt-ped-item.nr-sequencia = tt-ped-item-consiste.nr-sequencia
             and   tt-ped-item.it-codigo    = tt-ped-item-consiste.it-codigo
             and   tt-ped-item.cod-refer    = tt-ped-item-consiste.cod-refer no-error.
        if  not avail tt-ped-item then do:
            run openQueryStatic in h-bodi154 (input "Default":U).
            run goToKey         in h-bodi154 (input tt-ped-item-consiste.nome-abrev,
                                              input tt-ped-item-consiste.nr-pedcli,
                                              input tt-ped-item-consiste.nr-sequencia,
                                              input tt-ped-item-consiste.it-codigo,
                                              input tt-ped-item-consiste.cod-refer).
            if  return-value = "OK":U then
                run deleteRecord in h-bodi154.

            run getRowErrors in h-bodi154 (output table RowErrorsItem).
        end.
    end.

    for each  RowErrorsItem
        where RowErrorsItem.errorType    = "INTERNAL":U 
        or    RowErrorsItem.ErrorSubType = "WARNING":U 
        or    RowErrorsItem.ErrorSubType = "INFORMATION":U :
        delete RowErrorsItem.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsItem}

    /* ped-ent */
    /* A BO do item j† exclui os ped-ent da ped-item excluida */

    /* cond-ped */
    for each tt-cond-ped-consiste:
        delete tt-cond-ped-consiste.
    end.
    for each  cond-ped no-lock
        where cond-ped.nr-pedido = tt-ped-venda.nr-pedido:
        create tt-cond-ped-consiste.
        buffer-copy cond-ped to tt-cond-ped-consiste.
    end.

    for each tt-cond-ped-consiste:
        find first tt-cond-ped
             where tt-cond-ped.nr-pedido = tt-cond-ped-consiste.nr-pedido
             and   tt-cond-ped.nr-sequencia = tt-cond-ped-consiste.nr-sequencia no-error.
        if  not avail tt-cond-ped then do:
            run openQueryStatic in h-bodi018 (input "Default":U).
            run goToKey         in h-bodi018 (input tt-cond-ped-consiste.nr-pedido, 
                                              input tt-cond-ped-consiste.nr-sequencia).
            if  return-value = "OK":U then
                run deleteRecord in h-bodi018.

            run getRowErrors in h-bodi018 (output table RowErrorsCondPed).
        end.
    end.

    for each  RowErrorsCondPed
        where RowErrorsCondPed.errorType    = "INTERNAL":U 
        or    RowErrorsCondPed.ErrorSubType = "WARNING":U 
        or    RowErrorsCondPed.ErrorSubType = "INFORMATION":U :
        delete RowErrorsCondPed.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrorsCondPed}
end procedure.

procedure pi-completa-pedido:
    for each RowErrors:
        delete RowErrors.
    end.

    run setUserLog      in h-bodi159com(input tt-ped-venda.user-alt).  
    run openQueryStatic in h-bodi159   (input "Main").
    run goToKey         in h-bodi159   (input tt-ped-venda.nome-abrev, input tt-ped-venda.nr-pedcli).
    run getRowid        in h-bodi159   (output r-ped-venda).
    run EmptyRowErrors  in h-bodi159com.
    
    RUN pi-desliga-alocacao in h-bodi159com.

    run completeOrder   in h-bodi159com(input r-ped-venda,
                                        output table RowErrors).

    for each  RowErrors
        where RowErrors.errorType    = "INTERNAL":U 
        or    RowErrors.ErrorSubType = "WARNING":U 
        or    RowErrors.ErrorSubType = "INFORMATION":U :
        delete RowErrors.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrors}
end procedure.

procedure pi-aloca:
    for each RowErrors:
        delete RowErrors.
    end.

    FIND emitente WHERE emitente.nome-abrev = b-ped-venda.nome-abrev NO-LOCK NO-ERROR.

    if  emitente.ind-lib-estoque
    or  (not emitente.ind-lib-estoque
         and b-ped-venda.cod-sit-aval <> 4) then do:
 
         run pi-alocacao-pedido   in h-bodi159com(input r-ped-venda).
         run getRowErrors         in h-bodi159com(output table RowErrors).
    END.

    for each  RowErrors
        where RowErrors.errorType    = "INTERNAL":U 
        or    RowErrors.ErrorSubType = "WARNING":U 
        or    RowErrors.ErrorSubType = "INFORMATION":U :
        delete RowErrors.
    end.

    {adapters/neogrid/pdp/anepd015.i RowErrors}
end procedure.

&IF "{&bf_dis_versao_ems}" < "2.062" &THEN

PROCEDURE pi-unid-neg-ped:
    
    /*  Inicializa API integracao unidade de neg¢cio */
    IF  NOT VALID-HANDLE(h-btb009za)
    OR  h-btb009za:TYPE       <> "PROCEDURE":U
    OR  h-btb009za:FILE-NAME  <> "btb/btb009za.p":U THEN
        RUN btb/btb009za.p PERSISTENT SET h-btb009za.

    /* Conecta Bases EMS 5 p/ verificar se unidade de neg¢cio est† cadastrada */ 
    RUN pi-conecta-bco IN h-btb009za (INPUT  1, /* Versao API  */
                                      INPUT  1, /* Conectar */
                                      INPUT  i-ep-codigo-usuario,
                                      INPUT  "all":U,
                                      OUTPUT TABLE tt_erros_conexao).

    IF  NOT CAN-FIND (FIRST tt_erros_conexao) THEN DO:
        RUN pi-cria-estrutura-negoc. /* Estrutura default */
        RUN pi-valida-unid-neg-ped.

        FOR EACH tt-unid-neg-ped OF tt-ped-item:
            
            FOR FIRST unid-neg-ped EXCLUSIVE-LOCK 
                WHERE unid-neg-ped.nome-abrev   = tt-unid-neg-ped.nome-abrev
                AND unid-neg-ped.nr-pedcli      = tt-unid-neg-ped.nr-pedcli
                AND unid-neg-ped.nr-sequencia   = tt-unid-neg-ped.nr-sequencia
                AND unid-neg-ped.it-codigo      = tt-unid-neg-ped.it-codigo
                AND unid-neg-ped.cod-refer      = tt-unid-neg-ped.cod-refer
                AND unid-neg-ped.cod_unid_negoc = tt-unid-neg-ped.cod_unid_negoc: END.

            IF AVAIL unid-neg-ped THEN DO: /* Alteraá∆o */
               IF para-dis.log-alt-unid-ped THEN
                  ASSIGN unid-neg-ped.perc-unid-neg  = tt-unid-neg-ped.perc-unid-neg
                         unid-neg-ped.qtd-unid-neg   = tt-unid-neg-ped.qtd-unid-neg
                         unid-neg-ped.val-unid-neg   = tt-unid-neg-ped.val-unid-neg.
             END.
             ELSE DO: /* Inclus∆o */
                 CREATE unid-neg-ped.
                 BUFFER-COPY tt-unid-neg-ped TO unid-neg-ped.
             END.
        END.
    END.

    /* Desconecta Bases EMS 5 */
    RUN pi-conecta-bco IN h-btb009za (INPUT  1, /* Versao API  */
                                      INPUT  2, /* Desconectar */
                                      INPUT  i-ep-codigo-usuario,
                                      INPUT  "all":U,
                                      OUTPUT TABLE tt_erros_conexao).

    FOR EACH tt_erros_conexao:
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT tt_erros_conexao.cd-erro,
                           INPUT tt_erros_conexao.param-1).
        CREATE tt-erro-neogrid.
        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
               tt-erro-neogrid.i-cod-erro    = tt_erros_conexao.cd-erro
               tt-erro-neogrid.c-desc-erro   = tt_erros_conexao.param-1. 
    END.

    /*  Finaliza API integracao unidade de neg¢cio */
    IF  valid-handle(h-btb009za) THEN DO:
        DELETE PROCEDURE h-btb009za.
        ASSIGN h-btb009za = ?.
    END.

END.

PROCEDURE pi-cria-estrutura-negoc:

    /* Eliminaá∆o */
    FOR EACH  unid-neg-ped
        WHERE unid-neg-ped.nr-pedcli  = tt-ped-venda.nr-pedcli
        AND   unid-neg-ped.nome-abrev = tt-ped-venda.nome-abrev EXCLUSIVE-LOCK:

        FIND FIRST tt-unid-neg-ped
             WHERE tt-unid-neg-ped.nr-pedcli      = unid-neg-ped.nr-pedcli 
             AND   tt-unid-neg-ped.nome-abrev     = unid-neg-ped.nome-abrev 
             AND   tt-unid-neg-ped.nr-sequencia   = unid-neg-ped.nr-sequencia
             AND   tt-unid-neg-ped.it-codigo      = unid-neg-ped.it-codigo
             AND   tt-unid-neg-ped.cod-refer      = unid-neg-ped.cod-refer
             AND   tt-unid-neg-ped.cod_unid_negoc = unid-neg-ped.cod_unid_negoc NO-ERROR.

         IF  NOT AVAIL tt-unid-neg-ped THEN
             DELETE unid-neg-ped .
    END.

    /* Default */
    IF NOT CAN-FIND(FIRST tt-unid-neg-ped
                    WHERE tt-unid-neg-ped.nome-abrev   = tt-ped-item.nome-abrev
                    AND   tt-unid-neg-ped.nr-pedcli    = tt-ped-item.nr-pedcli
                    AND   tt-unid-neg-ped.nr-sequencia = tt-ped-item.nr-sequencia
                    &IF "{&ems_dbtype}" <> "progress":U &THEN 
                    AND   tt-unid-neg-ped.char-1       = tt-ped-item.it-codigo
                    &ELSE
                    AND   tt-unid-neg-ped.it-codigo    = tt-ped-item.it-codigo
                    &ENDIF
                    AND   tt-unid-neg-ped.cod-refer    = tt-ped-item.cod-refer) THEN DO:

       /* Unidade de Neg¢cio Default do Item */
       FOR EACH  unid-neg-item FIELDS (cod_unid_negoc perc-unid-neg) NO-LOCK
           WHERE unid-neg-item.it-codigo = tt-ped-item.it-codigo USE-INDEX item-unid:

            CREATE tt-unid-neg-ped.
            ASSIGN tt-unid-neg-ped.nome-abrev     = tt-ped-item.nome-abrev
                   tt-unid-neg-ped.nr-pedcli      = tt-ped-item.nr-pedcli
                   tt-unid-neg-ped.nr-sequencia   = tt-ped-item.nr-sequencia
                   &IF "{&ems_dbtype}" <> "progress":U &THEN 
                   tt-unid-neg-ped.char-1         = tt-ped-item.it-codigo
                   &else  
                   tt-unid-neg-ped.it-codigo      = tt-ped-item.it-codigo
                   &ENDIF
                   tt-unid-neg-ped.cod-refer      = tt-ped-item.cod-refer
                   tt-unid-neg-ped.cod_unid_negoc = unid-neg-item.cod_unid_negoc
                   tt-unid-neg-ped.perc-unid-neg  = unid-neg-item.perc-unid-neg.
       END.

       /* Unidade de Neg¢cio Default da Familia Comercial */
       IF  NOT CAN-FIND(FIRST tt-unid-neg-ped
                        WHERE tt-unid-neg-ped.nome-abrev   = tt-ped-item.nome-abrev
                        AND   tt-unid-neg-ped.nr-pedcli    = tt-ped-item.nr-pedcli
                        AND   tt-unid-neg-ped.nr-sequencia = tt-ped-item.nr-sequencia
                        &IF "{&ems_dbtype}" <> "progress":U &THEN 
                        AND   tt-unid-neg-ped.char-1       = tt-ped-item.it-codigo
                        &ELSE
                        AND   tt-unid-neg-ped.it-codigo    = tt-ped-item.it-codigo
                        &ENDIF
                        AND   tt-unid-neg-ped.cod-refer    = tt-ped-item.cod-refer) THEN DO:

           FOR FIRST ITEM FIELDS (it-codigo fm-cod-com un fraciona)
               WHERE item.it-codigo = tt-ped-item.it-codigo NO-LOCK USE-INDEX codigo: END.

           FOR EACH  unid-neg-fam-com FIELDS (cod_unid_negoc perc-unid-neg) NO-LOCK
               WHERE unid-neg-fam-com.fm-codigo = ITEM.fm-cod-com USE-INDEX fam-unid:

               CREATE tt-unid-neg-ped.
               ASSIGN tt-unid-neg-ped.nome-abrev     = tt-ped-item.nome-abrev
                      tt-unid-neg-ped.nr-pedcli      = tt-ped-item.nr-pedcli
                      tt-unid-neg-ped.nr-sequencia   = tt-ped-item.nr-sequencia
                      &IF "{&ems_dbtype}" <> "progress":U &THEN 
                      tt-unid-neg-ped.char-1         = tt-ped-item.it-codigo
                      &ELSE
                      tt-unid-neg-ped.it-codigo      = tt-ped-item.it-codigo
                      &ENDIF
                      tt-unid-neg-ped.cod-refer      = tt-ped-item.cod-refer
                      tt-unid-neg-ped.cod_unid_negoc = unid-neg-fam-com.cod_unid_negoc
                      tt-unid-neg-ped.perc-unid-neg  = unid-neg-fam-com.perc-unid-neg.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-valida-unid-neg-ped:

    ASSIGN i-perc = 0.

    FOR EACH tt-unid-neg-ped OF tt-ped-item:

        IF SEARCH("prgint/utb/utb714za.py") = ? AND SEARCH("prgint/utb/utb714za.r") = ? THEN DO:
           RUN utp/ut-msgs.p (INPUT "MSG":U,
                              INPUT 6246,
                              INPUT "prgint/utb/utb714za.py":U).
           
           CREATE tt-erro-neogrid.
           ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
                  tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
                  tt-erro-neogrid.i-cod-erro    = 6246
                  tt-erro-neogrid.c-desc-erro   = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            ASSIGN c-unid-negoc = tt-unid-neg-ped.cod_unid_negoc.
            RUN prgint/utb/utb714za.py (INPUT 1,
                                        INPUT no,
                                        INPUT-OUTPUT c-unid-negoc,
                                        OUTPUT l-achou-reg).

            IF l-achou-reg = NO THEN DO:
                /* Unidade neg¢cio n∆o cadastrada */
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 25590,
                                   INPUT "").

                CREATE tt-erro-neogrid.
                ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
                       tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
                       tt-erro-neogrid.i-cod-erro    = 25590
                       tt-erro-neogrid.c-desc-erro   = TRIM(RETURN-VALUE).

            END.
        END.

        IF tt-unid-neg-ped.perc-unid-ne = ? THEN ASSIGN tt-unid-neg-ped.perc-unid-neg = 0.
        IF tt-unid-neg-ped.qtd-unid-neg = ? THEN ASSIGN tt-unid-neg-ped.qtd-unid-neg  = 0.
        IF tt-unid-neg-ped.val-unid-neg = ? THEN ASSIGN tt-unid-neg-ped.val-unid-neg  = 0.

        ASSIGN i-perc = i-perc + tt-unid-neg-ped.perc-unid-neg.

        IF  tt-unid-neg-ped.perc-unid-neg = 0 THEN do:
              {utp/ut-liter.i Percentual_da_unidade_de_neg¢cio * r}
              RUN utp/ut-msgs.p (INPUT "MSG":U,
                                 INPUT 2333,
                                 INPUT TRIM(RETURN-VALUE)).

              CREATE tt-erro-neogrid.
              ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
                     tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
                     tt-erro-neogrid.i-cod-erro    = 2333
                     tt-erro-neogrid.c-desc-erro   = TRIM(RETURN-VALUE).
              
        END.
    END.

    IF  i-perc <> 0 THEN DO:
        IF  i-perc <> 100 THEN DO:
            IF  i-perc < 100 THEN DO:
                {utp/ut-liter.i menor * r}
            END.
            IF  i-perc > 100 THEN DO:
                {utp/ut-liter.i maior * r}
            END.
            
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 17068,
                               INPUT TRIM(RETURN-VALUE)).

            CREATE tt-erro-neogrid.
            ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
                   tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
                   tt-erro-neogrid.i-cod-erro    = 17068
                   tt-erro-neogrid.c-desc-erro   = TRIM(RETURN-VALUE).

        END.
    END.
END PROCEDURE.

&ENDIF
