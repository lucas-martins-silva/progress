/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD020RP 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd020rp MAN}
&ENDIF


{utp/ut-glob.i}
/* ---------------------[ VERSAO ]-------------------- */
/*******************************************************************************
**
**  Programa: ANEPD020RP
**
**  Data....: Mar‡o 2006
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Simula‡Æo de Saldo do Item
**
*******************************************************************************/

{adapters/neogrid/pdp/anepd020.i}    /* Definicao tt-param */     

def var da-data-aux as date   no-undo.

def temp-table tt-digita NO-UNDO
    field cod-estabel like estabelec.cod-estabel                      
    field cod-depos   like deposito.cod-depos.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

def input parameter raw-param  as raw no-undo.
def input parameter TABLE FOR tt-raw-digita.

create tt-param. 
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

FIND FIRST para-ped NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE tt-h-item NO-UNDO
    FIELD cod-estabel    LIKE estabelec.cod-estabel       /* SiteID */
    FIELD nome           LIKE estabelec.nome              /* SiteDescription */
    FIELD it-codigo      LIKE ITEM.it-codigo              /* ItemCode */
    FIELD desc-item      LIKE ITEM.desc-item              /* ItemDescription */
    FIELD cod-refer      LIKE item.cod-refer              /* ReferenceCode */
    FIELD ref-descr      LIKE referencia.descricao        /* ReferenceDescription */
    FIELD un             LIKE ITEM.un                     /* UnitOfMeasureCode */
    FIELD descricao      LIKE tab-unidade.descricao       /* UnitOfMeasureDescription */
    FIELD saldo-est      LIKE saldo-estoq.qtidade-atu     /* StartBalance */
    FIELD estoq-segur    LIKE saldo-estoq.qtidade-atu     /* SecurityStockQuantity */
    FIELD qt-alocada     LIKE saldo-estoq.qt-alocada      /* AllocationQuantity */
    FIELD saldo-ini      LIKE saldo-estoq.qtidade-atu     /* InventoryBalance */
    FIELD lote-economi   LIKE ITEM.lote-economi           /* EconomicStockQuantity */
    FIELD ressup-comp    LIKE ITEM.res-int-comp           /* ReplenishmentDays */
    FIELD ressup-fabri   LIKE ITEM.ressup-fabri           /* ProductionDays */
    FIELD remessa-benef  LIKE saldo-estoq.qtidade-atu     /* RemittanceForImproviment */
    FIELD entrada-benef  LIKE saldo-estoq.qtidade-atu     /* EntranceForImproviment */
    FIELD transferencia  LIKE saldo-estoq.qtidade-atu     /* TransferenciaOfMaterial */
    FIELD remessa-consig LIKE saldo-estoq.qtidade-atu     /* RemittanceConsignementContract */
    FIELD entrada-consig LIKE saldo-estoq.qtidade-atu.    /* EntranceConsignementContract */

/* Temp-table com as Informações dos Itens */
DEFINE TEMP-TABLE tt-item NO-UNDO 
    FIELD it-codigo      LIKE ITEM.it-codigo              /* C¢digo do Item */
    FIELD cod-refer      LIKE ITEM.cod-refer              /* C¢digo Referˆncia */
    field data           AS DATE                          /* DateSimulation */ 
    field producao       as decimal                       /* QuantityProductionOrder */
    field compras        as decimal                       /* QuantityPurchase */
    field reservas       as decimal                       /* QuantityReserve */
    field pedidos        as decimal                       /* QuantitySalesOrder */
    field disponivel     LIKE prazo-compra.quant-saldo.   /* QuantityAvailable */

/* Temp-table com as Informações relativas as Ordens de Produção dos Itens */
DEFINE TEMP-TABLE tt-ord-prod NO-UNDO 
   FIELD it-codigo      LIKE ITEM.it-codigo          /* C¢digo do Item */
   FIELD cod-refer      LIKE ITEM.cod-refer          /* C¢digo Referˆncia */
   FIELD dt-termino     AS DATE                      /* ProductionOrderEndDate */
   FIELD nr-ord-produ   LIKE ord-prod.nr-ord-produ   /* ProductionOrderNumber */
   FIELD qt-ordem       LIKE ord-prod.qt-ordem       /* QuantityOfOrder */
   FIELD qt-produzida   LIKE ord-prod.qt-produzida   /* QuantityProduced */
   FIELD estado         LIKE ord-prod.estado.        /* vStatus */

/* Temp-table com as Informações relativas as Ordens de Compras dos itens */
DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO
   FIELD it-codigo       LIKE ITEM.it-codigo             /* C¢digo do Item */
   FIELD cod-refer       LIKE ITEM.cod-refer             /* C¢digo Referˆncia */
   FIELD quant-saldo     LIKE prazo-compra.quant-saldo   /* BalanceQuantity */
   FIELD data-entrega    AS DATE                         /* DeliveryDate */
   FIELD numero-ordem    LIKE prazo-compra.numero-ordem  /* DeliveryOrderNumber */
   FIELD num-pedido      LIKE ordem-compra.num-pedido    /* PurchaseDeliveryNumber */
   FIELD parcela         LIKE prazo-compra.parcela       /* PurchaseParcelOrder */
   FIELD quantidade      LIKE prazo-compra.quantidade.   /* PurchaseQuantityItem */

/* Temp-table com as Informações relativas aos pedidos dos clientes */
DEFINE TEMP-TABLE tt-pedidos NO-UNDO
   FIELD it-codigo       LIKE ITEM.it-codigo           /* C¢digo do Item */
   FIELD cod-refer       LIKE ITEM.cod-refer           /* C¢digo Referˆncia */
   FIELD nome-abrev      LIKE ped-venda.nome-abrev     /* CustomerName */
   FIELD nr-pedcli       LIKE ped-venda.nr-pedcli      /* CustomerOrder */
   FIELD dt-entrega      AS DATE                       /* DeliveryDate */ 
   FIELD saldo-ped       LIKE ped-item.qt-pedida       /* QuantityBalanceOfOrder */
   FIELD cod-sit-ped     LIKE ped-venda.cod-sit-ped.   /* StatusOfOrder */

/* Temp-table com as Informações relativas as Resevas dos itens */
DEFINE TEMP-TABLE tt-reservas NO-UNDO
   FIELD it-codigo        LIKE ITEM.it-codigo          /* C¢digo do Item */
   FIELD cod-refer        LIKE ITEM.cod-refer          /* C¢digo Referˆncia */
   FIELD quant-atend      LIKE reservas.quant-atend    /* ProcessedQuantity */
   FIELD nr-ord-prod      LIKE reservas.nr-ord-prod    /* ProductionOrderNumber */
   FIELD quant-orig       LIKE reservas.quant-orig     /* QuantityOfReserve */
   FIELD dt-reserva       AS DATE.                     /* ReserveDate */

define buffer b-item for item.

DEFINE TEMP-TABLE tt-h-item-aux       NO-UNDO like tt-h-item.
DEFINE TEMP-TABLE tt-item-aux         NO-UNDO like tt-item.
DEFINE TEMP-TABLE tt-ord-prod-aux     NO-UNDO like tt-ord-prod.
DEFINE TEMP-TABLE tt-ordem-compra-aux NO-UNDO like tt-ordem-compra.
DEFINE TEMP-TABLE tt-reservas-aux     NO-UNDO like tt-reservas.
DEFINE TEMP-TABLE tt-pedidos-aux      NO-UNDO like tt-pedidos.

DEFINE VARIABLE de-saldo-est   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-quant-segur AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-qt-alocada  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-saldo-inic  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-disponivel  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE da-dt-corte    AS DATE       NO-UNDO.
DEFINE VARIABLE da-op-corte    AS DATE       NO-UNDO.
DEFINE VARIABLE da-dt-plan     AS DATE       NO-UNDO.
DEFINE VARIABLE dt-auxiliar    AS DATE       NO-UNDO.
DEFINE VARIABLE c-tab-sit-ped  AS CHARACTER  INIT "" NO-UNDO.
DEFINE VARIABLE c-tab-sit-aval AS CHARACTER  INIT "" NO-UNDO.
DEFINE VARIABLE dt-aux-1900    AS DATE       NO-UNDO.
DEFINE VARIABLE de-aux-saldo-item AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-aux-saldo-aloc AS DECIMAL NO-UNDO.
define variable c-lista-sit    as char format "X(80)" no-undo.
DEFINE VARIABLE i-cont         AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont2        AS INTEGER    NO-UNDO.
DEFINE VARIABLE dt-aux-inicio  AS DATE       NO-UNDO.
DEFINE VARIABLE h-eai          AS HANDLE NO-UNDO.
DEFINE VARIABLE c-benefic      AS CHARACTER  FORMAT "x(13)" NO-UNDO.
DEFINE VARIABLE cEvent         AS CHARACTER  NO-UNDO INIT "1".
DEFINE VARIABLE cTranAction    AS CHARACTER  NO-UNDO INIT "add".

DEFINE VARIABLE dt-dados AS DATE  NO-UNDO.

DEF VAR c-estab-ini AS CHAR FORMAT "x(3)" NO-UNDO.
DEF VAR c-estab-fim AS CHAR FORMAT "x(3)" NO-UNDO.

/* variaveis MRP */
def var i-tam-per    as INT  no-undo.
def var da-inicio    as date    no-undo format "99/99/9999".
def var da-termino   as date    no-undo format "99/99/9999".
def var da-termino-f as date    no-undo format "99/99/9999".
def var da-dat       as date format "99/99/9999" no-undo.
def var da-dat-in    as date format "99/99/9999" no-undo.
def var i-res-var    as integer no-undo.
def var i-nr-dias    as integer no-undo.
def var i-ressup     as integer no-undo.
def var i-resto      as integer no-undo.
def var i-ind        as integer no-undo.
def var de-qt-min    as decimal no-undo.
def var de-qt-dlt    as decimal no-undo.
def var i-dias-dlt   as integer no-undo.
def var de-vezes     as decimal no-undo.
DEF BUFFER b-periodo FOR periodo.

{cdp/cdcfgman.i}
/********/

def var c-sel   as char format "x(40)".
def var c-par   as char format "x(40)".
def var c-imp   as char format "x(40)".
def var c-des   as char format "x(40)".                  
def var c-saida as char format "x(40)".

def var  c-cab            as char extent 30 format "x(25)" no-undo.
def var  i-cab            as int.
DEF VAR  l-item-atual     AS LOGICAL NO-UNDO.

def var h-acomp as handle no-undo.
ASSIGN l-item-atual = CAN-FIND(FIRST funcao
                               WHERE funcao.cd-funcao = "spp-item-atual":U
                               AND   funcao.ativo).

/* Definicao de Frames */

form header
     SKIP
     with stream-io width 132 no-box no-labels frame f-cabecalho.

FORM skip(1) c-sel    at    1  no-label skip(1)
     c-estab-ini      colon 49 space(16) "|< >|" c-estab-fim   no-label
     item-ini         colon 49 space(3)  "|< >|" item-fim      no-label
     fam-com-ini      colon 49 space(11) "|< >|" fam-com-fim   no-label
     ge-codigo-ini    colon 49 space(17) "|< >|" ge-codigo-fim NO-LABEL skip(1) 
     
     c-par    at    1  no-label skip(1)
     pa-ord-comp           colon 49
     pa-ord-prod           colon 49
     pa-planejada          COLON 49
     pa-res-comp           COLON 49
     pa-res-plan           COLON 49
     pa-sald-est           colon 49
     pa-item-fatur         colon 49
     pa-wf-desconto        colon 49
     pa-depositos          colon 49
     pa-dep-cq             colon 49
     pa-cod-plano          COLON 49
     pa-dt-plan            COLON 49
     pa-dt-corte           colon 49
     c-benefic             colon 49
     pa-t-pedidos          colon 49
     pa-t-ord-prod         colon 49
     pa-t-reservas         colon 49
     pa-t-compras          colon 49 SKIP(1)
     pa-pedidos            colon 49
     pa-cred-aprov         colon 49
     pa-ped-n-av           colon 49
     pa-ped-aval           colon 49
     pa-ped-apro           colon 49
     pa-ped-repr           colon 49
     pa-cons-qt-aba        colon 49
     pa-abertos            colon 49
     pa-at-parcial         colon 49 SKIP(1)
     pa-sald-terc          colon 49
     pa-remessa-benef      colon 49
     pa-entrada-benef      colon 49
     pa-transferencia      colon 49
     pa-remessa-consig     colon 49
     pa-entrada-consig     colon 49

     skip(1) 
     c-imp    at    1  no-label skip(1)
     c-saida          colon 49
     tt-param.usuario colon 49
     with side-labels stream-io width 132 frame f-parametros.
                                                            
{utp/ut-liter.i Considera_Ordens_de_Compra                       MPD L} pa-ord-comp:label    in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Ordens_de_Produ‡Æo                     MPD L} pa-ord-prod:LABEL    in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Ordens_Planejadas?                     MPD r} pa-planejada:label   IN FRAME f-parametros = trim(return-value).     
{utp/ut-liter.i Considera_Reservas_Comprometidas?                MPD r} pa-res-comp:LABEL    IN FRAME f-parametros = trim(return-value).     
{utp/ut-liter.i Considera_Reservas_Planejadas?                   MPD r} pa-res-plan:label    IN FRAME f-parametros = trim(return-value).     
{utp/ut-liter.i Considera_Saldo_em_Estoque                       MPD L} pa-sald-est:label    in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Somente_Itens_Fatur veis               MPD L} pa-item-fatur:label  in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Somente_Pedidos_Aprovados_WF_Desconto? MPD L} pa-wf-desconto:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Plano_de_Produ‡Æo                                MPD r} pa-cod-plano:label   IN FRAME f-parametros = trim(return-value).
{utp/ut-liter.i N£mero_Dias_para_Data_de_Corte                   MPD L} pa-dt-corte:label    in frame f-parametros = trim(return-value).
{utp/ut-liter.i N£mero_Dias_para_Ordens_Planejadas               MPD r} pa-dt-plan:LABEL     IN FRAME f-parametros = trim(return-value).

{utp/ut-liter.i Informa_Depositos      MPD L} pa-depositos:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Dep¢sitos_CQ MPD L} pa-dep-cq:label    in frame f-parametros = trim(return-value).

{utp/ut-liter.i Ordens_de_Compras_de_Beneficiamento MPD L} c-benefic:LABEL IN FRAME f-parametros = trim(return-value).

{utp/ut-liter.i Detalhar_Pedidos            MPD L} pa-t-pedidos:label  in frame f-parametros = trim(return-value).
{utp/ut-liter.i Detalhar_Ordens_de_Produ‡Æo MPD L} pa-t-ord-prod:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Detalhar_Reservas           MPD L} pa-t-reservas:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Detalhar_Ordens_de_Compra   MPD L} pa-t-compras:label  in frame f-parametros = trim(return-value).

{utp/ut-liter.i Estabelecimento  MPD L} c-estab-ini:label     in frame f-parametros = trim(return-value).
{utp/ut-liter.i Item             MPD L} item-ini:label      in frame f-parametros = trim(return-value).
{utp/ut-liter.i Fam¡lia_Comercial}      fam-com-ini:label   in frame f-parametros = trim(return-value).
{utp/ut-liter.i Grupo_de_Estoque MPD L} ge-codigo-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Abertos                MPD r} pa-abertos:label    in frame f-parametros = trim(return-value).
{utp/ut-liter.i Atendidos_Parcialmente MPD r} pa-at-parcial:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i NÆo_Avaliados MPD r} pa-ped-n-av:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Avaliados     MPD r} pa-ped-aval:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Aprovados     MPD r} pa-ped-apro:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Reprovados    MPD r} pa-ped-repr:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Pedidos_Carteira         MPD r} pa-pedidos:label     in frame f-parametros = trim(return-value).
{utp/ut-liter.i Apenas_Pedidos_Cr‚dito_Aprovado    MPD r} pa-cred-aprov:LABEL  in frame f-parametros = trim(return-value).
{utp/ut-liter.i Abate_Dispon¡vel_Quantidade_Pedido MPD r} pa-cons-qt-aba:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Considera_Saldo_em_Terceiros MPD r} pa-sald-terc:label      in frame f-parametros = trim(return-value).
{utp/ut-liter.i Remessa_p/_Beneficiamento    MPD r} pa-remessa-benef:LABEL  in frame f-parametros = trim(return-value).
{utp/ut-liter.i Entrada_p/_Beneficiamento    MPD r} pa-entrada-benef:label  in frame f-parametros = trim(return-value).
{utp/ut-liter.i Transferˆncia                MPD r} pa-transferencia:label  in frame f-parametros = trim(return-value).
{utp/ut-liter.i Entrada_em_Consigna‡Æo       MPD r} pa-entrada-consig:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Remessa_em_Consigna‡Æo       MPD r} pa-remessa-consig:label in frame f-parametros = trim(return-value).

/* Prepara cabecalho */
{include/i-rpvar.i}

{utp/ut-liter.i Exporta‡Æo_Simula‡Æo_Estoque C} c-cab[20] = trim(return-value).
{utp/ut-liter.i PEDIDOS                      C} c-cab[21] = trim(return-value).

FIND FIRST param-global NO-LOCK NO-ERROR.
find empresa
    WHERE empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

assign c-programa      = "ESP001"
       c-versao        = "1.00"
       c-revisao       = "000"
       c-empresa       = empresa.razao-social
       c-titulo-relat  = c-cab[20]
       c-sistema       = c-cab[21].

run utp/ut-trfrrp.p (input frame f-cabecalho:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

find first tt-param no-lock no-error.

IF AVAIL tt-param THEN DO: 

    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i Processando_Itens *}
    run pi-inicializar in h-acomp (input RETURN-VALUE).

    ASSIGN c-estab-ini = tt-param.estab-ini
           c-estab-fim = tt-param.estab-fim.

    FOR EACH estabelec
        WHERE estabelec.cod-estabel >= c-estab-ini
          AND estabelec.cod-estabel <= c-estab-fim NO-LOCK:

        ASSIGN tt-param.estab-ini = estabelec.cod-estabel
               tt-param.estab-fim = estabelec.cod-estabel.

        /* limpa as temp-table utilizadas no programa */
        EMPTY TEMP-TABLE tt-h-item.
        EMPTY TEMP-TABLE tt-item.
        EMPTY TEMP-TABLE tt-pedidos.
        EMPTY TEMP-TABLE tt-ord-prod.
        EMPTY TEMP-TABLE tt-ordem-compra.
        EMPTY TEMP-TABLE tt-reservas.

        RUN pi-processamento.
    
        RUN pi-gera-mensagem-envio.
    END.
    
    RUN pi-encerra-execucao.
    
    run pi-finalizar in h-acomp.

    {include/i-rpclo.i}

    RETURN "OK".
 END. 
    
PROCEDURE pi-processamento:

    /* Le os itens da faixa selecionada */
    FOR EACH ITEM NO-LOCK
        WHERE ITEM.ge-codigo    >= tt-param.ge-codigo-ini
          AND ITEM.ge-codigo    <= tt-param.ge-codigo-fim
          AND ITEM.it-codigo    >= tt-param.item-ini
          AND ITEM.it-codigo    <= tt-param.item-fim
          AND ITEM.fm-cod-com   >= tt-param.fam-com-ini
          AND ITEM.fm-cod-com   <= tt-param.fam-com-fim
          AND ITEM.tipo-contr   <> 4:

        IF  tt-param.pa-item-fatur THEN
            IF  NOT ITEM.ind-item-fat  THEN
                NEXT.

        run pi-acompanhar in h-acomp("Item: " + item.it-codigo).
        run pi-seta-titulo in h-acomp(input "Processando Item").

        ASSIGN da-dt-corte = tt-param.pa-dt-corte + TODAY.

        ASSIGN de-saldo-inic = 0
               de-disponivel = 0.
        
        RUN pi-cria-tt-h-item.    
    
    END.

    RETURN "OK":U.
END PROCEDURE.
    
PROCEDURE pi-cria-tt-h-item:
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-tt-h-item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  ITEM.tipo-con-est = 4 THEN DO:
        FOR EACH ref-item NO-LOCK
            WHERE ref-item.it-codigo = ITEM.it-codigo:
            /* Cria temp-table header dos itens */
            FIND FIRST tt-h-item
                WHERE tt-h-item.it-codigo = ITEM.it-codigo
                  AND tt-h-item.cod-refer = ref-item.cod-refer NO-ERROR.
            
            IF NOT AVAIL tt-h-item THEN DO:
                CREATE tt-h-item.
                ASSIGN tt-h-item.cod-estabel    = estabelec.cod-estabel
                       tt-h-item.nome           = estabelec.nome
                       tt-h-item.it-codigo      = item.it-codigo
                       tt-h-item.desc-item      = ITEM.desc-item
                       tt-h-item.cod-refer      = ref-item.cod-refer
                       tt-h-item.un             = ITEM.un
                       tt-h-item.descricao      = ""
                       tt-h-item.saldo-est      = 0
                       tt-h-item.estoq-segur    = 0
                       tt-h-item.qt-alocada     = 0
                       tt-h-item.saldo-ini      = 0
                       tt-h-item.lote-economi   = ITEM.lote-economi
                       tt-h-item.ressup-comp    = IF  item.compr-fabric = 1 THEN (ITEM.res-int-comp + ITEM.res-for-comp) ELSE 0
                       tt-h-item.ressup-fabri   = IF  item.compr-fabric = 2 THEN (ITEM.ressup-fabri + ITEM.res-cq-fab) ELSE 0
                       tt-h-item.remessa-benef  = 0
                       tt-h-item.entrada-benef  = 0
                       tt-h-item.transferencia  = 0
                       tt-h-item.remessa-consig = 0
                       tt-h-item.entrada-consig = 0.
            END.

            FIND FIRST referencia  NO-LOCK WHERE referencia.cod-refer = ref-item.cod-refer NO-ERROR.
            FIND FIRST tab-unidade NO-LOCK WHERE tab-unidade.un = ITEM.un NO-ERROR.

            ASSIGN tt-h-item.ref-descr = IF  AVAIL referencia  THEN referencia.descricao  ELSE ""
                   tt-h-item.descricao = IF  AVAIL tab-unidade THEN tab-unidade.descricao ELSE "".
            
            /* Verifica-saldo-inicial */
            RUN pi-verifica-saldo-item.

            /* Faz a simula‡Æo do saldo do item no estoque */
            RUN pi-simula-saldo-item.
        END.
    END.
    ELSE DO:
        /* Cria temp-table dos itens */
        FIND FIRST tt-h-item
            WHERE tt-h-item.it-codigo = ITEM.it-codigo
              AND tt-h-item.cod-refer = "" NO-ERROR.
        IF  NOT AVAIL tt-h-item THEN DO:
            CREATE tt-h-item.
            ASSIGN tt-h-item.cod-estabel    = estabelec.cod-estabel
                   tt-h-item.nome           = estabelec.nome
                   tt-h-item.it-codigo      = item.it-codigo
                   tt-h-item.desc-item      = ITEM.desc-item
                   tt-h-item.cod-refer      = ""
                   tt-h-item.ref-descr      = ""
                   tt-h-item.un             = ITEM.un
                   tt-h-item.descricao      = ""
                   tt-h-item.saldo-est      = 0
                   tt-h-item.estoq-segur    = 0
                   tt-h-item.qt-alocada     = 0
                   tt-h-item.saldo-ini      = 0
                   tt-h-item.lote-economi   = ITEM.lote-economi
                   tt-h-item.ressup-comp    = IF  item.compr-fabric = 1 THEN (ITEM.res-int-comp + ITEM.res-for-comp) ELSE 0
                   tt-h-item.ressup-fabri   = IF  item.compr-fabric = 2 THEN (ITEM.ressup-fabri + ITEM.res-cq-fab) ELSE 0
                   tt-h-item.remessa-benef  = 0
                   tt-h-item.entrada-benef  = 0
                   tt-h-item.transferencia  = 0
                   tt-h-item.remessa-consig = 0
                   tt-h-item.entrada-consig = 0.
        END.

        FIND FIRST tab-unidade NO-LOCK WHERE tab-unidade.un = ITEM.un NO-ERROR.
        ASSIGN tt-h-item.descricao = IF  AVAIL tab-unidade THEN tab-unidade.descricao ELSE "".
        
        /* Verifica-saldo-inicial */
        RUN pi-verifica-saldo-item.

        /* Faz a simula‡Æo do saldo do item no estoque */
        RUN pi-simula-saldo-item.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-verifica-saldo-item :
/*------------------------------------------------------------------------------
  Purpose:     pi-verifica-saldo-item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    
    /* Faz o c clculo dos saldos */
    if  param-global.modulo-ce then do:
        find first tt-digita no-lock no-error.
        if  not avail tt-digita then do:

            for each deposito no-lock 
                WHERE deposito.ind-dep-rej  = no 
                  AND deposito.cons-saldo   = yes 
                  AND ((deposito.ind-dep-cq = YES and tt-param.pa-dep-cq  = yes)
                     or deposito.ind-dep-cq   = no),
                each saldo-estoq use-index item 
                    WHERE saldo-estoq.it-codigo    = item.it-codigo      
                      AND saldo-estoq.cod-refer    = tt-h-item.cod-refer   
                      AND saldo-estoq.cod-depos    = deposito.cod-depos  
                      AND saldo-estoq.cod-estabel >= tt-param.estab-ini 
                      AND saldo-estoq.cod-estabel <= tt-param.estab-fim no-lock:
                     
                if  item.tipo-con-est        >= 3 /*refer e lote*/ 
                AND saldo-estoq.dt-vali-lote < today then
                    next.

                IF  tt-param.pa-sald-est THEN
                    assign tt-h-item.saldo-ini = tt-h-item.saldo-ini + saldo-estoq.qtidade-atu.
                ASSIGN tt-h-item.qt-alocada = tt-h-item.qt-alocada + saldo-estoq.qt-alocada + 
                                                                     saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped.
            end.
        end.
        else do:
            for each tt-digita,
                FIRST deposito no-lock 
                    WHERE deposito.cod-depos    = tt-digita.cod-depos 
                      AND deposito.cons-saldo   = yes 
                      AND deposito.ind-dep-rej  = no  
                      AND ((deposito.ind-dep-cq = yes
                      and tt-param.pa-dep-cq    = yes)
                       or deposito.ind-dep-cq   = no),
                each saldo-estoq use-index item 
                    WHERE saldo-estoq.it-codigo    = item.it-codigo      
                      AND saldo-estoq.cod-refer    = tt-h-item.cod-refer   
                      AND saldo-estoq.cod-depos    = deposito.cod-depos  
                      AND saldo-estoq.cod-estabel  = tt-digita.cod-estabel no-lock:

                if  item.tipo-con-est        >= 3 /*refer e lote*/ 
                and saldo-estoq.dt-vali-lote < today then
                    next.

                IF  tt-param.pa-sald-est THEN
                    assign tt-h-item.saldo-ini  = tt-h-item.saldo-ini + saldo-estoq.qtidade-atu.
                ASSIGN tt-h-item.qt-alocada = tt-h-item.qt-alocada + saldo-estoq.qt-alocada + 
                                                                     saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped.
            end.
        end.

        assign tt-h-item.estoq-segur = if  item.tipo-est-seg = 2
                                       then (item.consumo-prev / 30) * item.tempo-segur
                                       else item.quant-segur.
    
        if  not(item.fraciona) and tt-h-item.estoq-segur <> integer(tt-h-item.estoq-segur) then
            assign tt-h-item.estoq-segur = truncate(tt-h-item.estoq-segur,0) + 1.

        assign tt-h-item.saldo-est = tt-h-item.saldo-ini
               tt-h-item.saldo-ini = tt-h-item.saldo-ini - (tt-h-item.estoq-segur + tt-h-item.qt-alocada).
    end.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-simula-saldo-item:
/*------------------------------------------------------------------------------
Purpose:     pi-simula-saldo-item
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
    assign de-saldo-inic  = 0
           de-quant-segur = 0.

    assign da-dt-corte = tt-param.pa-dt-corte + TODAY
           da-op-corte = da-dt-corte
           da-dt-plan  = TODAY + tt-param.pa-dt-plan.

    /*---------------------------------------------------------------------------*/
    if  param-global.modulo-ce then do:
        if  tt-param.pa-sald-est 
        OR  tt-param.pa-remessa-benef  
        or  tt-param.pa-entrada-benef 
        or  tt-param.pa-transfer 
        or  tt-param.pa-remessa-consig 
        OR  tt-param.pa-entrada-consig then do:

            find first tt-digita no-lock no-error.
            if  avail tt-digita
            and (tt-param.pa-sald-est or tt-param.pa-remessa-benef  or tt-param.pa-entrada-benef
              or tt-param.pa-transfer or tt-param.pa-remessa-consig or tt-param.pa-entrada-consig) then do:
                IF tt-param.pa-sald-est THEN DO:
                    for each  saldo-estoq fields (it-codigo   cod-estabel   cod-depos   qtidade-atu
                                                  qt-alocada  qt-aloc-prod  qt-aloc-ped cod-refer)
                        where saldo-estoq.it-codigo = tt-h-item.it-codigo
                          and saldo-estoq.cod-refer = tt-h-item.cod-refer no-lock,
                        first tt-digita
                            where tt-digita.cod-estabel = saldo-estoq.cod-estabel
                              and tt-digita.cod-depos = saldo-estoq.cod-depos no-lock:

                        assign de-saldo-inic = de-saldo-inic +
                                              (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada -
                                               saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).
                    end.
                END.
    
                IF  tt-param.pa-sald-terc then do:
                    for each  saldo-terc fields (it-codigo     cod-estabel   cod-refer tipo-sal-terc quantidade)
                        where saldo-terc.it-codigo = tt-h-item.it-codigo
                          and saldo-terc.cod-refer = tt-h-item.cod-refer no-lock:

                        CASE saldo-terc.tipo-sal-terc:
                            WHEN 1 THEN assign tt-h-item.remessa-benef  = tt-h-item.remessa-benef  + saldo-terc.quantidade.
                            WHEN 2 then assign tt-h-item.entrada-benef  = tt-h-item.entrada-benef  + saldo-terc.quantidade.
                            WHEN 3 then assign tt-h-item.transferencia  = tt-h-item.transferencia  + saldo-terc.quantidade.
                            WHEN 4 then assign tt-h-item.remessa-consig = tt-h-item.remessa-consig + saldo-terc.quantidade.
                            WHEN 5 then assign tt-h-item.entrada-consig = tt-h-item.entrada-consig + saldo-terc.quantidade.
                        END CASE.
                    end.
                end.                         
            end. /* if  avail tt-digita */
            ELSE DO:
                if  tt-param.pa-sald-est
                or  tt-param.pa-remessa-benef
                or  tt-param.pa-entrada-benef
                or  tt-param.pa-transferencia
                or  tt-param.pa-remessa-consig
                or  tt-param.pa-entrada-consig then do:
                    IF tt-param.pa-sald-est THEN DO:
                        for each  saldo-estoq fields (it-codigo   cod-estabel   cod-depos   qtidade-atu
                                                      qt-alocada  qt-aloc-prod  qt-aloc-ped cod-refer)
                            where saldo-estoq.it-codigo    = tt-h-item.it-codigo
                              and saldo-estoq.cod-refer    = tt-h-item.cod-refer
                              and saldo-estoq.cod-estabel >= tt-param.estab-ini
                              and saldo-estoq.cod-estabel <= tt-param.estab-fim no-lock,
                            each  deposito fields (cod-depos   cons-saldo)
                                where deposito.cod-depos = saldo-estoq.cod-depos
                                  and deposito.cons-saldo no-lock:
                            assign de-saldo-inic = de-saldo-inic +
                                                  (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada -
                                                   saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).
                        end.
                    END.

                    if tt-param.pa-sald-terc then do:
                        for each  saldo-terc fields (it-codigo     cod-estabel   cod-refer
                                                     tipo-sal-terc quantidade)
                            where saldo-terc.it-codigo  = ITEM.it-codigo
                              and saldo-terc.cod-refer  = tt-h-item.cod-refer
                              and saldo-terc.cod-estabel >= tt-param.estab-ini
                              and saldo-terc.cod-estabel <= tt-param.estab-fim no-lock:

                            CASE saldo-terc.tipo-sal-terc:
                                WHEN 1 THEN assign tt-h-item.remessa-benef = tt-h-item.remessa-benef + saldo-terc.quantidade.
                                WHEN 2 then assign tt-h-item.entrada-benef = tt-h-item.entrada-benef + saldo-terc.quantidade.
                                WHEN 3 then assign tt-h-item.transferencia = tt-h-item.transferencia + saldo-terc.quantidade.
                                WHEN 4 then assign tt-h-item.remessa-consig = tt-h-item.remessa-consig + saldo-terc.quantidade.
                                WHEN 5 then assign tt-h-item.entrada-consig = tt-h-item.entrada-consig + saldo-terc.quantidade.
                            END CASE.
                        end.
                    end.
                end.
            END. /* else do if  avail tt-digita */
        END. /* if  tt-param.pa-sald-est */
        assign de-quant-segur = if  item.tipo-est-seg = 2 THEN (item.consumo-prev / 30) * item.tempo-segur
                                                          ELSE  item.quant-segur.
    end. /* if  param-global.modulo-ce */

    if  not(ITEM.fraciona) 
    and de-quant-segur <> integer(de-quant-segur) then
        assign de-quant-segur = truncate(de-quant-segur,0) + 1.   
              
    if  tt-param.pa-dt-corte = 0 then
        assign dt-auxiliar = TODAY.
    else
        assign dt-auxiliar = today + tt-param.pa-dt-corte.

    run pi-calcula-saldo-item.

    /* Somente ir  gerar o detalhe da consulta se foi parametrizado que exporta o item tamb‚m.
       Para nÆo gerar duplicidade com MRP */

     /* Faz o detalhamento dos pedidos de vendas que foram consideradas na Simula‡Æo do Saldo do Item no Estoque */
    IF  tt-param.pa-t-pedidos 
    AND tt-param.pa-pedidos THEN
        RUN pi-cria-tt-pedidos.
        
    /* Faz o detalhamento das Ordens de Produ‡Æo que foram consideradas na Simula‡Æo do Saldo do Item no Estoque */
    IF  tt-param.pa-t-ord-prod
    AND tt-param.pa-ord-prod THEN
        RUN pi-cria-tt-ord-prod.

    /* Faz o detalhamento das Reservas que foram consideradas na Simula‡Æo do Saldo do Item no Estoque */
    IF  tt-param.pa-t-reservas
    AND tt-param.pa-res-comp THEN
        RUN pi-cria-tt-reservas.

    /* Faz o detalhamento das Ordens de Produ‡Æo que foram consideradas na Simula‡Æo do Saldo do Item no Estoque */
    IF  tt-param.pa-t-compras
    AND tt-param.pa-ord-comp THEN
        RUN pi-cria-tt-ordem-compra.

    RETURN "OK":U.        
    
END PROCEDURE.
              

PROCEDURE pi-calcula-saldo-item :
/*------------------------------------------------------------------------------
  Purpose:  pi-calcula-saldo-item     
  Parameters:  <none>
  Notes:  Ler os saldos do item "antes" e "a cada dia" depois de hoje

------------------------------------------------------------------------------*/
    DEFINE VARIABLE d-data-ref AS DATE       NO-UNDO.
    DEF VAR i-eusei AS INT.
    find first param-global no-lock no-error.
    
    assign c-tab-sit-ped  = ""
           c-tab-sit-aval = ""
           dt-aux-1900    = date("01/01/1900").

    IF l-item-atual THEN
      ASSIGN d-data-ref     = 12/31/9999. 
    ELSE
      ASSIGN d-data-ref     = TODAY + tt-param.pa-dt-corte. 
    
    if  tt-param.pa-abertos    then assign c-tab-sit-ped  = "1".
    if  tt-param.pa-at-parcial THEN assign c-tab-sit-ped = c-tab-sit-ped + "2".

    if  tt-param.pa-ped-n-av   then assign c-tab-sit-aval = "1".
    if  tt-param.pa-ped-aval   then assign c-tab-sit-aval = c-tab-sit-aval + "2".
    if  tt-param.pa-ped-apro   then assign c-tab-sit-aval = c-tab-sit-aval + "3".
    if  tt-param.pa-ped-repr   then assign c-tab-sit-aval = c-tab-sit-aval + "4".

    if  item.baixa-estoq 
    AND tt-param.pa-pedidos then do:
        DO i-cont2 = 1 TO 2:

            FOR EACH ped-ent fields (it-codigo cod-refer cod-sit-ent dt-entrega
                                     nome-abrev nr-pedcli nr-sequencia 
                                     qt-pedida qt-atendida qt-alocada)
               where ped-ent.it-codigo     = item.it-codigo 
                 and ped-ent.cod-refer     = tt-h-item.cod-refer    
                 and ped-ent.cod-sit-ent   = i-cont2
                 AND ped-ent.dt-entrega   >= dt-aux-1900
                 and ped-ent.dt-entrega   <= d-data-ref no-lock,
    
               first ped-item fields (nome-abrev nr-pedcli nr-sequencia it-codigo
                                      cod-refer nat-operacao) of ped-ent no-lock,
    
               first natur-oper fields (nat-operacao baixa-estoq) no-lock 
               where natur-oper.nat-operacao = ped-item.nat-operacao
                 and natur-oper.baixa-estoq  = yes,
    
               first ped-venda fields (nome-abrev nr-pedcli cod-estabel
                                       cod-sit-ped cod-sit-aval log-aprov-workflow)    
               where ped-venda.nome-abrev  = ped-item.nome-abrev
                 and ped-venda.nr-pedcli   = ped-item.nr-pedcli
                 and ped-venda.cod-estabel >= tt-param.estab-ini
                 AND ped-venda.cod-estabel <= tt-param.estab-fim
                 AND ped-venda.log-cotacao = NO 
                AND index(c-tab-sit-ped,string(ped-venda.cod-sit-ped)) <> 0 
                AND index(c-tab-sit-aval,string(ped-venda.cod-sit-aval)) <> 0 NO-LOCK,
              FIRST item OF ped-item
              WHERE item.baixa-estoq = yes  NO-LOCK:

                /* Desconsidera os pedidos aprovados no WF de desconto */
                IF para-ped.log-usa-aprovac-workflow THEN
                   IF (tt-param.pa-wf-desconto = YES) AND (ped-venda.log-aprov-workflow = NO) THEN
                      NEXT. 

                ASSIGN dt-dados = (IF ped-ent.dt-entrega < (TODAY - 1)
                                  THEN (TODAY - 1)
                                  ELSE ped-ent.dt-entrega).

                RUN pi-cria-tt-item  (INPUT tt-h-item.it-codigo,
                                      INPUT tt-h-item.cod-refer,
                                      INPUT dt-dados).

                assign de-aux-saldo-item = 0
                       de-aux-saldo-aloc = 0  
                       de-aux-saldo-item = if (ped-ent.qt-pedida - ped-ent.qt-atendida) > 0
                                           then (ped-ent.qt-pedida - ped-ent.qt-atendida)
                                           else 0
                       de-aux-saldo-aloc = if (ped-ent.qt-alocada - ped-ent.qt-atendida) > 0
                                           then (ped-ent.qt-alocada - ped-ent.qt-atendida)
                                           else 0
                       tt-item.pedidos  = tt-item.pedidos + if de-aux-saldo-item > de-aux-saldo-aloc 
                                                            then (de-aux-saldo-item - de-aux-saldo-aloc)
                                                            else 0.
            end. /* end for each ped-ent */
        END.
    end.
        
    if  param-global.modulo-cp then do:

        IF  tt-param.pa-ord-prod THEN DO:

            find first ord-prod use-index item 
                 where ord-prod.it-codigo    = item.it-codigo                 
                  and (ord-prod.dt-termino  + item.res-cq-fabri) <= dt-auxiliar
                  and  ord-prod.estado       < 7                           
                  and  ord-prod.cod-refer    = tt-h-item.cod-refer                 
                  and  ord-prod.cod-estabel >= tt-param.estab-ini
                  AND  ord-prod.cod-estabel <= tt-param.estab-fim
                  and (ord-prod.qt-ordem - ord-prod.qt-produzida) > 0 
                       no-lock no-error.           
    
            assign dt-aux-inicio = if avail ord-prod then ord-prod.dt-termino + item.res-cq-fabri
                                   else dt-auxiliar  + 1.
                                                    
            /* da-auxiliar ² a data que varia em fun»’o da tada informada nos par³metros */
            /* da-aux-inicio serve para buscar as OP */
    
            do  dt-aux-inicio = dt-aux-inicio to dt-auxiliar:
                for each ord-prod fields (it-codigo dt-termino estado cod-refer
                                          cod-estabel qt-ordem qt-produzida)
                                  use-index item no-lock
                   where ord-prod.it-codigo    = item.it-codigo                 
                    and (ord-prod.dt-termino  + item.res-cq-fabri) = dt-aux-inicio 
                    and  ord-prod.estado      < 7                             
                    and  ord-prod.cod-refer    = tt-h-item.cod-refer
                    and  ord-prod.cod-estabel >= tt-param.estab-ini
                    AND ord-prod.cod-estabel  <= tt-param.estab-fim
                    and (ord-prod.qt-ordem - ord-prod.qt-produzida) > 0:
    
                    ASSIGN dt-dados = (IF ord-prod.dt-termino < (TODAY - 1)
                                       THEN (TODAY - 1)
                                       ELSE ord-prod.dt-termino + item.res-cq-fabri).
    
                    RUN pi-cria-tt-item (INPUT ord-prod.it-codigo,
                                         INPUT ord-prod.cod-refer,
                                         INPUT dt-dados).
                    assign tt-item.producao = tt-item.producao + (ord-prod.qt-ordem - ord-prod.qt-produzida).
                end.
            end.
        END.

        /* Considera reservas comprometidas */
        IF  tt-param.pa-res-comp THEN DO:
            find first reservas use-index planejamento
                 where reservas.it-codigo   = item.it-codigo 
                   and reservas.estado      = 1          
                   and reservas.dt-reserva <= dt-auxiliar
                   and reservas.cod-refer   = tt-h-item.cod-refer    
                   and (reservas.quant-orig - reservas.quant-atend) > 0 no-lock no-error.    
    
            assign dt-aux-inicio = if avail reservas then reservas.dt-reserva
                                   else dt-auxiliar + 1.                       
    
            do  dt-aux-inicio = dt-aux-inicio to dt-auxiliar:
                for each reservas fields (it-codigo dt-reserva estado cod-refer quant-orig quant-atend) use-index data no-lock 
                    where reservas.it-codigo  = item.it-codigo 
                      and reservas.dt-reserva = dt-aux-inicio      
                      and reservas.estado     = 1    
                      and reservas.cod-refer  = tt-h-item.cod-refer
                      and (reservas.quant-orig - reservas.quant-atend) > 0:
                    
                    ASSIGN dt-dados = (IF reservas.dt-reserva < (TODAY - 1)
                                       THEN (TODAY - 1)
                                       ELSE reservas.dt-reserva).
                    
                    RUN pi-cria-tt-item (INPUT reservas.it-codigo,
                                         INPUT reservas.cod-refer,
                                         INPUT dt-dados).
                    
                    assign tt-item.reserva = tt-item.reserva + (reservas.quant-orig - reservas.quant-atend).
                end.
            end.
        END.
    end.
    
    if  param-global.modulo-cc 
    AND tt-param.pa-ord-comp then do:
        for each prazo-compra fields (it-codigo data-entrega situacao cod-refer quant-saldo numero-ordem) use-index entrega-pl NO-LOCK
           where prazo-compra.it-codigo     = item.it-codigo
            and  prazo-compra.data-entrega >= dt-aux-1900
            and  prazo-compra.data-entrega <= d-data-ref
            and  prazo-compra.situacao     <> 4
            and  prazo-compra.situacao     <> 6
            and  prazo-compra.cod-refer     = tt-h-item.cod-refer
            and  prazo-compra.quant-saldo   > 0,
            first ordem-compra fields (numero-ordem cod-estabel ordem-servic natureza origem) NO-LOCK
            where ordem-compra.numero-ordem  = prazo-compra.numero-ordem
            and   ordem-compra.cod-estabel  >= tt-param.estab-ini
            AND   ordem-compra.cod-estabel  <= tt-param.estab-fim:

            If ordem-compra.ordem-servic    <> 0 and
               ordem-compra.natureza        =  3 and
               ordem-compra.origem          =  2 then next.       
            IF  tt-param.pa-benefic   = 2 
            AND ordem-compra.natureza = 3 
                THEN NEXT.
            
            ASSIGN dt-dados = (IF prazo-compra.data-entrega < (TODAY - 1)
                               THEN (TODAY - 1)
                               ELSE prazo-compra.data-entrega +  item.res-cq-fabri).

            RUN pi-cria-tt-item (INPUT prazo-compra.it-codigo,
                                 INPUT prazo-compra.cod-refer,
                                 INPUT dt-dados).

            assign tt-item.compras = tt-item.compras + prazo-compra.quant-saldo.
        end.
    end.

    /* Faz a simula‡Æo das ordens e reservas planejadas */
    IF   param-global.modulo-pl 
    AND (tt-param.pa-planejada OR tt-param.pa-res-plan) 
    AND tt-param.pa-cod-plano > 0 THEN DO:

        RUN pi-simular-ordens-planejadas.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-simular-ordens-planejadas:

    DEF BUFFER b-estabelec FOR estabelec.

    for first pl-prod  fields (cd-plano pl-estado cd-tipo tp-seg-comp tp-seg-fabr log-multi-estabel num-calc-plano)
        where pl-prod.cd-plano = tt-param.pa-cod-plano no-lock:

        {cdp/cd0501.i}

        for first pl-it-calc fields (it-codigo  cd-plano nr-dias-desl   res-cq-fabri
                                     tempo-segur ressup-fabri   char-1)
            where pl-it-calc.cd-plano  = pl-prod.cd-plano 
              AND pl-it-calc.it-codigo = ITEM.it-codigo no-lock:
                
            if  pl-prod.log-multi-estabel  then do:

                for each  b-estabelec FIELDS (cod-estabel) 
                    where b-estabelec.cod-estabel >= c-estab-ini 
                      and b-estabelec.cod-estabel <= c-estab-fim no-lock:

                    RUN pi-it-periodo (INPUT b-estabelec.cod-estabel).
                END.
            end.
            else do:
                RUN pi-it-periodo (INPUT "").
            end.
        end.
    end.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-it-periodo:

    DEF INPUT PARAM p-cod-estab AS CHAR NO-UNDO.

    FIND FIRST param-cp NO-LOCK NO-ERROR.

    for each it-periodo
        where it-periodo.num-calc-plano = pl-prod.num-calc-plano                
        and   it-periodo.cod-estabel    = p-cod-estab
        and   it-periodo.it-codigo      = pl-it-calc.it-codigo
        and   it-periodo.cod-refer      = tt-h-item.cod-refer NO-LOCK:

        IF NOT ((it-periodo.qt-ord-plan > 0 and tt-param.pa-planejada) 
        or     ((it-periodo.qt-res-plan - it-periodo.qt-pedidos > 0) and tt-param.pa-res-plan)) THEN 
            NEXT.

        FIND first periodo where
            periodo.nr-periodo = it-periodo.periodo and
            periodo.ano        = it-periodo.ano     and
            periodo.cd-tipo    = pl-prod.cd-tipo NO-LOCK NO-ERROR.
        IF AVAIL periodo THEN DO:
            if  periodo.dt-inicio <= da-dt-plan then do:

                if  ITEM.compr-fabr = 1 then do:
                    {cdp/cd0901.i4 item} /*calcula da-inicio da-termino - compras*/
                    assign da-dat    = da-termino
                           da-dat-in = da-inicio.
                    for first calen-prod fields (cod-estabel   data   tipo-dia)
                        where calen-prod.cod-estabel = param-cp.cod-estabel
                        and   calen-prod.data        = da-dat no-lock: end.
                
                    if avail calen-prod then
                    repeat:
                        if calen-prod.tipo-dia = 1 then
                            leave.
                        else do:
                            assign da-inicio = da-inicio - 1
                                   da-dat    = da-dat - 1.
                            for first calen-prod fields (cod-estabel   data   tipo-dia)
                                where calen-prod.cod-estabel = param-cp.cod-estabel 
                                and   calen-prod.data        = da-dat no-lock: end.
                        end.
                    end.
                    assign da-termino = da-dat.
                end.
                else do:
                    {cdp/cd0901.i5 item}
                end.

                /*** Atualiza simula‡Æo Ordens Planejadas */
                if  it-periodo.qt-ord-plan > 0 
                AND da-termino <= da-op-corte  
                AND tt-param.pa-planejada then do:

                    /* solange */

                    ASSIGN dt-dados = (IF da-termino < (TODAY - 1)
                                       THEN (TODAY - 1)
                                       ELSE da-termino).

                    RUN pi-cria-tt-item (INPUT it-periodo.it-codigo,
                                         INPUT it-periodo.cod-refer,
                                         INPUT dt-dados).

                    IF  ITEM.compr-fabric = 1 THEN DO:

                        /* Item comprado - atualiza quantidade a comprar */
                        assign tt-item.compras = tt-item.compras + it-periodo.qt-ord-plan.

                        /* Se detalha ordens de compra, cria tt de detalhe */
                        IF  tt-param.pa-t-compras THEN DO:
                            FOR EACH ord-aber
                                WHERE ord-aber.num-id-it-periodo = it-periodo.num-id-it-periodo
                                  AND ord-aber.tipo-ordem        = 3 /* ordem planejada */ NO-LOCK:

                                FIND FIRST tt-ordem-compra
                                    WHERE tt-ordem-compra.it-codigo    = tt-h-item.it-codigo
                                      AND tt-ordem-compra.cod-refer    = tt-h-item.cod-refer
                                      AND tt-ordem-compra.data-entrega = da-termino
                                      AND tt-ordem-compra.numero-ordem = ord-aber.nr-ord-aber
                                      AND tt-ordem-compra.num-pedido   = 0 NO-ERROR.
                                IF NOT AVAIL tt-ordem-compra THEN DO:
                                    CREATE tt-ordem-compra.
                                    ASSIGN tt-ordem-compra.it-codigo       = tt-h-item.it-codigo
                                           tt-ordem-compra.cod-refer       = tt-h-item.cod-refer
                                           tt-ordem-compra.quant-saldo     = 0
                                           tt-ordem-compra.data-entrega    = da-termino
                                           tt-ordem-compra.numero-ordem    = ord-aber.nr-ord-aber
                                           tt-ordem-compra.num-pedido      = 0
                                           tt-ordem-compra.parcela         = 1 /* Passa fixo a parcela 1 p/ ordem planejada */
                                           tt-ordem-compra.quantidade      = 0.
                                END.
                                ASSIGN tt-ordem-compra.quant-saldo = tt-ordem-compra.quant-saldo + ord-aber.quantidade
                                       tt-ordem-compra.quantidade  = tt-ordem-compra.quantidade + ord-aber.quantidade.
                            END.
                        END.
                    END.
                    ELSE DO:
                        /* Item Fabricado - Atualiza quantidade a produzir. */
                        assign tt-item.producao = tt-item.producao + it-periodo.qt-ord-plan.

                        /* Se detalha ordens de produ‡Æo, cria tt de detalhe */
                        IF  tt-param.pa-t-ord-prod THEN DO:
                            FOR EACH ord-aber
                                WHERE ord-aber.num-id-it-periodo = it-periodo.num-id-it-periodo
                                  AND ord-aber.tipo-ordem        = 3 /* ordem planejada */  NO-LOCK:

                                FIND FIRST tt-ord-prod
                                    WHERE tt-ord-prod.it-codigo    = tt-h-item.it-codigo
                                      AND tt-ord-prod.cod-refer    = tt-h-item.cod-refer
                                      AND tt-ord-prod.dt-termino   = da-termino
                                      AND tt-ord-prod.nr-ord-produ = ord-aber.nr-ord-aber NO-ERROR.
                                IF NOT AVAIL tt-ord-prod THEN DO:
                                    CREATE tt-ord-prod.
                                    ASSIGN tt-ord-prod.it-codigo      = tt-h-item.it-codigo
                                           tt-ord-prod.cod-refer      = tt-h-item.cod-refer 
                                           tt-ord-prod.dt-termino     = da-termino
                                           tt-ord-prod.nr-ord-produ   = ord-aber.nr-ord-aber
                                           tt-ord-prod.qt-ordem       = 0
                                           tt-ord-prod.qt-produzida   = 0
                                           tt-ord-prod.estado         = 1. /* Passa fixo 1 (Nƒo iniciada) p/ ordem planejada */
                                END.
                                ASSIGN tt-ord-prod.qt-ordem = tt-ord-prod.qt-ordem + ord-aber.quantidade.
                            END.
                        END.
                    END.
                end.

                /* Reservas Planejadas */
                if (it-periodo.qt-res-plan - it-periodo.qt-pedidos) > 0
                AND periodo.dt-inicio <= da-op-corte 
                AND tt-param.pa-res-plan then do:

                    bl_res_aber:
                    for each  res-aber fields (it-codigo cod-refer ano periodo nr-pedcli nome-abrev quantidade item-pai
                                               num-id-it-periodo   cod-estabel tipo-res  nr-ord-orig)
                        where res-aber.num-id-it-periodo = it-periodo.num-id-it-periodo 
                          and res-aber.it-codigo  = it-periodo.it-codigo
                          and res-aber.cod-refer  = it-periodo.cod-refer
                          and res-aber.ano        = it-periodo.ano       
                          and res-aber.periodo    = it-periodo.periodo   
                          AND res-aber.cod-estabel = p-cod-estab NO-LOCK:

                    /*  RES-ABER.TIPO-RES    = 1 RESERVAS DO PLANO 
                                             = 2 RESERVAS DE PEDIDO DE VENDA 
                                             = 3 RESERVAS COMPROMETIDA DE UMA ORDEM DE PRODUCAO
                                             = 4 RESERVAS PLANEJADA PARA ATENDER UMA ORDEM DE PRODUCAO
                                             = 5 RESERVAS PARA ATENDER ESTOQUE DE SEGURANCA
                                             = 6 RESERVAS COMPROMETIDAS DE ITENS FABRICADOS EM OUTRO ESTABELECIMENTO
                                                 (CORRESPONDE AO 4 E UMA RESERVA PLANEJADA DE UM ITEM QUE E FABRICADO EM OUTRO)
                                             = 7 RESERVAS PLANEJADAS/COMPROMETIDADES QUE PROVEM DE OUTRO ESTABELECIMENTO
                                             = 8 RESERVAS REPROGRAMADAS, DE ITENS FABRICADOS FEITO EM OUTRO ESTABELECIMENTO
                                             = 9 RESERVAS DE RESERVAS COMPROMETIDAS(RESERVAS), A SER FEITA EM OUTRO ESTABELECIMENTO
                                             = 0 RESERVAS DE PEDIDO DE VENDA (PED-ENT) A SER FEITO EM OUTRO ESTABELECIMENTO */

                        IF  NOT (res-aber.tipo-res = 4 OR res-aber.tipo-res = 7) THEN 
                            next.

                        ASSIGN dt-dados = (IF periodo.dt-inicio /* da-termino */ < (TODAY - 1)
                                           THEN (TODAY - 1)
                                           ELSE periodo.dt-inicio). /*da-termino).*/

                        RUN pi-cria-tt-item (INPUT it-periodo.it-codigo,
                                             INPUT it-periodo.cod-refer,
                                             INPUT dt-dados).

                        assign tt-item.reserva = tt-item.reserva + res-aber.quantidade.

                        /* Faz o detalhamento das Reservas que foram consideradas na Simula‡Æo do Saldo do Item no Estoque */
                        IF  tt-param.pa-t-reservas THEN DO:

                            FIND FIRST tt-reservas
                                WHERE tt-reservas.it-codigo   = tt-h-item.it-codigo
                                  AND tt-reservas.cod-refer   = tt-h-item.cod-refer
                                  AND tt-reservas.dt-reserva  = periodo.dt-inicio /*da-termino*/
                                  AND tt-reservas.nr-ord-prod = res-aber.nr-ord-orig NO-ERROR.
                            IF  NOT AVAIL tt-reservas THEN DO:
                                CREATE tt-reservas.
                                ASSIGN tt-reservas.it-codigo      = tt-h-item.it-codigo
                                       tt-reservas.cod-refer      = tt-h-item.cod-refer
                                       tt-reservas.quant-atend    = 0
                                       tt-reservas.nr-ord-prod    = res-aber.nr-ord-orig
                                       tt-reservas.quant-orig     = 0
                                       tt-reservas.dt-reserva     = periodo.dt-inicio. /* da-termino. */
                            END.

                            ASSIGN tt-reservas.quant-orig = tt-reservas.quant-orig + res-aber.quantidade.
                        END.
                    end.
                end.
            end.
        end.   
    end.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-tt-pedidos:
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-tt-pedidos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    define variable d-data       as   date           no-undo.
    define variable de-qt-saldo  as   dec  init 0    no-undo.
    define variable c-sit-ped    as   char           no-undo.
    define variable c-sit-aval   as   char           no-undo.

    define variable c-situacao   as char format "x(12)" no-undo.

    define variable c-lista-sit  as char format "X(80)" no-undo.
    
    assign c-lista-sit = {diinc/i03di149.i 03}.

    ASSIGN d-data = TODAY + tt-param.pa-dt-corte.
    
    if  item.baixa-estoq 
    AND tt-param.pa-pedidos THEN do: 
        FOR EACH ped-ent                        
            WHERE ped-ent.it-codigo    = tt-h-item.it-codigo  
              AND ped-ent.cod-refer    = tt-h-item.cod-refer
              AND ped-ent.cod-sit-ent <= 2
              AND ped-ent.dt-entrega  >= dt-aux-1900
              AND ped-ent.dt-entrega  <= d-data  NO-LOCK,
            FIRST ped-item OF ped-ent NO-LOCK,
            FIRST natur-oper OF ped-item
                WHERE natur-oper.nat-operacao = ped-item.nat-operacao 
                  AND natur-oper.baixa-estoq  = yes NO-LOCK,
            FIRST ped-venda OF ped-item
                WHERE ped-venda.nome-abrev  = ped-item.nome-abrev 
                  AND ped-venda.nr-pedcli   = ped-item.nr-pedcli  
                  and ped-venda.cod-estabel >= tt-param.estab-ini
                  AND ped-venda.cod-estabel <= tt-param.estab-fim             
                  AND ped-venda.log-cotacao = NO 
                  AND index(c-tab-sit-ped,string(ped-venda.cod-sit-ped)) <> 0 
                  AND index(c-tab-sit-aval,string(ped-venda.cod-sit-aval)) <> 0 NO-LOCK,
            FIRST b-item OF ped-item
                WHERE b-item.baixa-estoq = yes  NO-LOCK
            BY ped-ent.hr-entrega
            BY ped-venda.nr-pedido:
            
            /* Desconsidera os pedidos aprovados no WF de desconto */
            IF para-ped.log-usa-aprovac-workflow THEN
               IF (tt-param.pa-wf-desconto = YES) AND (ped-venda.log-aprov-workflow = NO) THEN
                  NEXT. 
     
            ASSIGN dt-dados = ped-ent.dt-entrega.
            FIND FIRST tt-pedidos
                WHERE tt-pedidos.it-codigo  = tt-h-item.it-codigo
                  AND tt-pedidos.cod-refer  = tt-h-item.cod-refer
                  AND tt-pedidos.dt-entrega = dt-dados 
                  AND tt-pedidos.nome-abrev = ped-venda.nome-abrev
                  AND tt-pedidos.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.
            IF NOT AVAIL tt-pedidos THEN DO:
                CREATE tt-pedidos.
                ASSIGN tt-pedidos.it-codigo    = tt-h-item.it-codigo
                     tt-pedidos.cod-refer      = tt-h-item.cod-refer
                     tt-pedidos.nome-abrev     = ped-venda.nome-abrev
                     tt-pedidos.nr-pedcli      = ped-venda.nr-pedcli
                     tt-pedidos.dt-entrega     = dt-dados
                     tt-pedidos.cod-sit-ped    = ped-ent.cod-sit-ent
                     tt-pedidos.saldo-ped      = 0.
            END.                
            RUN pi-calc-qt-saldo (OUTPUT de-qt-saldo).
            ASSIGN tt-pedidos.saldo-ped = tt-pedidos.saldo-ped + de-qt-saldo.

        END.
    END.
    RETURN "OK":U.
END PROCEDURE.
                              

PROCEDURE pi-cria-tt-ord-prod:
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-tt-ord-prod
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE d-data-ref     AS DATE       FORMAT "99/99/9999" NO-UNDO.
    define variable i-res-cq-fabri as int no-undo.

    ASSIGN d-data-ref = TODAY + tt-param.pa-dt-corte.
    
    FOR EACH ord-prod 
        WHERE ord-prod.it-codigo    = tt-h-item.it-codigo  and 
              ord-prod.estado      <> 8                  AND 
              ord-prod.estado      <> 7                  and 
              ord-prod.cod-refer    = tt-h-item.cod-refer  and 
              ord-prod.cod-estabel >= tt-param.estab-ini and
              ord-prod.cod-estabel <= tt-param.estab-fim and 
             (ord-prod.qt-ordem - ord-prod.qt-produzida) > 0 and 
              ord-prod.dt-termino  >= dt-aux-1900            AND
              ord-prod.dt-termino  <= d-data-ref  NO-LOCK :

        ASSIGN dt-dados = ord-prod.dt-termino + item.res-cq-fabri.

        FIND FIRST tt-ord-prod
            WHERE tt-ord-prod.it-codigo    = tt-h-item.it-codigo
              AND tt-ord-prod.cod-refer    = tt-h-item.cod-refer
              AND tt-ord-prod.dt-termino   = dt-dados 
              AND tt-ord-prod.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.
        IF NOT AVAIL tt-ord-prod THEN DO:
            CREATE tt-ord-prod.
            ASSIGN tt-ord-prod.it-codigo      = tt-h-item.it-codigo
                   tt-ord-prod.cod-refer      = tt-h-item.cod-refer 
                   tt-ord-prod.dt-termino     = dt-dados
                   tt-ord-prod.nr-ord-produ   = ord-prod.nr-ord-produ
                   tt-ord-prod.qt-ordem       = 0
                   tt-ord-prod.qt-produzida   = 0
                   tt-ord-prod.estado         = ord-prod.estado.
        END.
        ASSIGN tt-ord-prod.qt-ordem     = tt-ord-prod.qt-ordem + ord-prod.qt-ordem
               tt-ord-prod.qt-produzida = tt-ord-prod.qt-produzida + ord-prod.qt-produzida.
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cria-tt-reservas:
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-tt-reservas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define VARIABLE d-data as date no-undo.
    ASSIGN d-data = TODAY + tt-param.pa-dt-corte.
   
    FOR EACH reservas 
        WHERE reservas.it-codigo                          = tt-h-item.it-codigo and 
              reservas.estado                             = 1                 and 
              reservas.cod-refer                          = tt-h-item.cod-refer and 
             (reservas.quant-orig - reservas.quant-atend) > 0                 and 
              reservas.dt-reserva                         >= dt-aux-1900      AND
              reservas.dt-reserva                         <= d-data           NO-LOCK:
        
        ASSIGN dt-dados = reservas.dt-reserva.
        FIND FIRST tt-reservas
            WHERE tt-reservas.it-codigo  = tt-h-item.it-codigo
              AND tt-reservas.cod-refer  = tt-h-item.cod-refer
              AND tt-reservas.dt-reserva = dt-dados 
              AND tt-reservas.nr-ord-prod = reservas.nr-ord-prod NO-ERROR.
        IF NOT AVAIL tt-reservas THEN DO:
            CREATE tt-reservas.
            ASSIGN tt-reservas.it-codigo      = tt-h-item.it-codigo
                   tt-reservas.cod-refer      = tt-h-item.cod-refer
                   tt-reservas.quant-atend    = 0
                   tt-reservas.nr-ord-prod    = reservas.nr-ord-prod
                   tt-reservas.quant-orig     = 0
                   tt-reservas.dt-reserva     = dt-dados.
        END.
        ASSIGN tt-reservas.quant-atend  = tt-reservas.quant-atend + reservas.quant-atend
               tt-reservas.quant-orig   = tt-reservas.quant-orig + reservas.quant-orig.
    END.
    RETURN "OK":U.
END PROCEDURE.
                    

PROCEDURE pi-cria-tt-ordem-compra:
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-tt-ordem-compra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable d-data-ref    as date no-undo.
    define variable i-res-cq-comp as int  no-undo.


    /* se for igual a anterior tt-param.pa-dt-corte = 0 */
    IF l-item-atual THEN
        assign d-data-ref    = 12/31/9999.
    ELSE
        assign d-data-ref    = tt-param.pa-dt-corte + TODAY.

    FOR EACH prazo-compra NO-LOCK
        WHERE prazo-compra.it-codigo = tt-h-item.it-codigo and 
              prazo-compra.situacao <> 4                 and 
              prazo-compra.situacao <> 6                 and 
              prazo-compra.cod-refer = tt-h-item.cod-refer and 
              prazo-compra.data-entrega >= dt-aux-1900   AND
              prazo-compra.data-entrega <= d-data-ref    and
              prazo-compra.quantidade    > 0,
        FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem  = prazo-compra.numero-ordem 
              AND ordem-compra.cod-estabel  >= tt-param.estab-ini
              AND ordem-compra.cod-estabel  <= tt-param.estab-fim:
        
        If ordem-compra.ordem-servic    <> 0 and
           ordem-compra.natureza        =  3 and
           ordem-compra.origem          =  2 then next.   

        IF  tt-param.pa-benefic   = 2 
        AND ordem-compra.natureza = 3 
            THEN NEXT.

        ASSIGN dt-dados = prazo-compra.data-entrega + item.res-cq-fabri.
        FIND FIRST tt-ordem-compra
            WHERE tt-ordem-compra.it-codigo    = prazo-compra.it-codigo
              AND tt-ordem-compra.cod-refer    = tt-h-item.cod-refer
              AND tt-ordem-compra.data-entrega = dt-dados 
              AND tt-ordem-compra.numero-ordem = prazo-compra.numero-ordem
              AND tt-ordem-compra.num-pedido   = ordem-compra.num-pedido NO-ERROR.
        IF NOT AVAIL tt-ordem-compra THEN DO:
            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.it-codigo       = tt-h-item.it-codigo
                   tt-ordem-compra.cod-refer       = tt-h-item.cod-refer
                   tt-ordem-compra.quant-saldo     = 0
                   tt-ordem-compra.data-entrega    = dt-dados
                   tt-ordem-compra.numero-ordem    = prazo-compra.numero-ordem
                   tt-ordem-compra.num-pedido      = ordem-compra.num-pedido
                   tt-ordem-compra.parcela         = prazo-compra.parcela
                   tt-ordem-compra.quantidade      = 0.
        END.
        ASSIGN tt-ordem-compra.quant-saldo   = tt-ordem-compra.quant-saldo + prazo-compra.quant-saldo
               tt-ordem-compra.quantidade    = tt-ordem-compra.quantidade + prazo-compra.quantidade.

    END. /* end for each prazo-compra */
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-calc-qt-saldo:
/*------------------------------------------------------------------------------
  Purpose:     pi-calc-qt-saldo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER de-qt-saldo  as dec  init 0         no-undo.
    if avail ped-ent then do: 
       assign de-aux-saldo-item = 0
              de-aux-saldo-aloc = 0
              de-aux-saldo-item = if (ped-ent.qt-pedida - ped-ent.qt-atendida) > 0 
                                  then (ped-ent.qt-pedida - ped-ent.qt-atendida)
                                  else 0
              de-aux-saldo-aloc = if (ped-ent.qt-alocada - ped-ent.qt-atendida) > 0
                                  then (ped-ent.qt-alocada - ped-ent.qt-atendida)
                                  else 0
              de-qt-saldo       = if de-aux-saldo-item > de-aux-saldo-aloc
                                  then (de-aux-saldo-item - de-aux-saldo-aloc)
                                  else 0.
    END.
    RETURN "OK":U.
END PROCEDURE.
    
PROCEDURE pi-cria-tt-item:
    DEFINE INPUT PARAMETER p-it-codigo    LIKE ITEM.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-refer    LIKE ITEM.cod-refer    NO-UNDO.
    DEFINE INPUT PARAMETER p-data         AS DATE                NO-UNDO.
    
    FIND FIRST tt-item
        WHERE tt-item.it-codigo      = p-it-codigo
          AND tt-item.cod-refer      = p-cod-refer
          AND tt-item.data           = p-data  NO-ERROR.    
    IF  NOT AVAIL tt-item THEN DO:
        CREATE tt-item.
        ASSIGN tt-item.it-codigo      = p-it-codigo
               tt-item.cod-refer      = p-cod-refer
               tt-item.data           = p-data
               tt-item.producao       = 0
               tt-item.compras        = 0
               tt-item.reservas       = 0
               tt-item.pedidos        = 0
               tt-item.disponivel     = 0.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-gera-mensagem-envio:

    def var c-it-codigo like tt-h-item.it-codigo no-undo.
    DEFINE VARIABLE c-cod-refer LIKE ITEM.cod-refer  NO-UNDO.

    EMPTY TEMP-TABLE tt-item-aux.
                
    EMPTY TEMP-TABLE tt-ord-prod-aux.
    EMPTY TEMP-TABLE tt-ordem-compra-aux.
    EMPTY TEMP-TABLE tt-reservas-aux.
    EMPTY TEMP-TABLE tt-pedidos-aux.
    EMPTY TEMP-TABLE tt-h-item-aux.        

    FOR EACH tt-h-item break by tt-h-item.it-codigo:
                             
        IF  c-it-codigo = "" then
            assign c-it-codigo = tt-h-item.it-codigo
                   c-cod-refer = tt-h-item.cod-refer.

        if  tt-h-item.it-codigo <> c-it-codigo 
        OR  tt-h-item.cod-refer <> c-cod-refer then do:

            RUN adapters/neogrid/pdp/anepd020c.p (INPUT  TABLE tt-h-item-aux,
                                                  input  table tt-item-aux,        
                                                  input  table tt-ord-prod-aux,    
                                                  input  table tt-ordem-compra-aux,
                                                  INPUT  TABLE tt-pedidos-aux,     
                                                  INPUT  TABLE tt-reservas-aux).

            EMPTY TEMP-TABLE tt-item-aux.
            EMPTY TEMP-TABLE tt-ord-prod-aux.
            EMPTY TEMP-TABLE tt-ordem-compra-aux.
            EMPTY TEMP-TABLE tt-reservas-aux.
            EMPTY TEMP-TABLE tt-pedidos-aux.
            EMPTY TEMP-TABLE tt-h-item-aux.        

            assign c-it-codigo = tt-h-item.it-codigo
                   c-cod-refer = tt-h-item.cod-refer.
        end.
        CREATE tt-h-item-aux.
        BUFFER-COPY tt-h-item TO tt-h-item-aux.

        ASSIGN de-disponivel = tt-h-item.saldo-est - tt-h-item.qt-alocada. 

        FOR EACH tt-item
            WHERE tt-item.it-codigo = tt-h-item.it-codigo
              and tt-item.cod-refer = tt-h-item.cod-refer break by tt-item.it-codigo
                                                                by tt-item.data:

            CREATE tt-item-aux.
            BUFFER-COPY tt-item TO tt-item-aux.

            ASSIGN de-disponivel = de-disponivel - (if tt-param.pa-cons-qt-aba
                                                    then tt-item-aux.pedidos
                                                    else 0)  - tt-item-aux.reserva + tt-item-aux.compras
                                                             + tt-item-aux.producao
                   tt-item-aux.disponivel = de-disponivel.

            if  first-of (tt-item.it-codigo) AND tt-param.pa-sald-terc THEN DO:
                
                if  tt-param.pa-remessa-benef  THEN
                    assign tt-item-aux.disponivel = tt-item-aux.disponivel + tt-h-item.remessa-benef.

                if  tt-param.pa-transferencia  THEN
                    assign tt-item-aux.disponivel = tt-item-aux.disponivel + tt-h-item.transferencia.

                IF  tt-param.pa-remessa-consig  THEN
                    assign tt-item-aux.disponivel = tt-item-aux.disponivel + tt-h-item.remessa-consig.

                IF  not tt-param.pa-entrada-benef  THEN                                            
                    assign tt-item-aux.disponivel = tt-item-aux.disponivel - tt-h-item.entrada-benef.

                if  not tt-param.pa-entrada-consig  THEN
                    assign tt-item-aux.disponivel = tt-item-aux.disponivel - tt-h-item.entrada-consig.
                ASSIGN de-disponivel = tt-item-aux.disponivel.
            END.
            
            IF  tt-item.data < TODAY THEN DO:
                FOR EACH tt-pedidos
                    WHERE tt-pedidos.it-codigo    = tt-h-item.it-codigo
                      AND tt-pedidos.cod-refer    = tt-h-item.cod-refer
                       AND tt-pedidos.dt-entrega  < TODAY
                            BREAK BY tt-pedidos.dt-entrega:  
                    CREATE tt-pedidos-aux.
                    BUFFER-COPY tt-pedidos TO tt-pedidos-aux. 
                END.

                FOR EACH tt-ord-prod
                    WHERE tt-ord-prod.it-codigo     = tt-item.it-codigo
                      AND tt-ord-prod.cod-refer     = tt-item.cod-refer
                      AND tt-ord-prod.dt-termino    < TODAY
                          BREAK BY tt-ord-prod.nr-ord-produ:  
                    CREATE tt-ord-prod-aux.
                    BUFFER-COPY tt-ord-prod TO tt-ord-prod-aux.
                END.

                FOR EACH tt-ordem-compra
                    WHERE tt-ordem-compra.it-codigo      = tt-item.it-codigo
                      AND tt-ordem-compra.cod-refer      = tt-item.cod-refer
                       AND tt-ordem-compra.data-entrega  < TODAY
                            BREAK BY tt-ordem-compra.num-pedido:  
                    CREATE tt-ordem-compra-aux.
                    BUFFER-COPY tt-ordem-compra TO tt-ordem-compra-aux.
                END.

                FOR EACH tt-reservas
                    WHERE tt-reservas.it-codigo    = tt-item.it-codigo
                      AND tt-reservas.cod-refer    = tt-item.cod-refer
                       AND tt-reservas.dt-reserva  < TODAY
                            BREAK BY tt-reservas.nr-ord-prod:  
                    CREATE tt-reservas-aux.
                    BUFFER-COPY tt-reservas TO tt-reservas-aux.
                END.

            END. /* if today - 1 */
            ELSE DO:
                FOR EACH tt-pedidos
                    WHERE tt-pedidos.it-codigo    = tt-h-item.it-codigo
                      AND tt-pedidos.cod-refer    = tt-h-item.cod-refer
                       AND tt-pedidos.dt-entrega  = tt-item.data
                            BREAK BY tt-pedidos.dt-entrega:  
                    CREATE tt-pedidos-aux.
                    BUFFER-COPY tt-pedidos TO tt-pedidos-aux. 
                END.

                FOR EACH tt-ord-prod
                    WHERE tt-ord-prod.it-codigo     = tt-item.it-codigo
                      AND tt-ord-prod.cod-refer     = tt-item.cod-refer
                       AND tt-ord-prod.dt-termino   = tt-item.data
                            BREAK BY tt-ord-prod.nr-ord-produ:  
                    CREATE tt-ord-prod-aux.
                    BUFFER-COPY tt-ord-prod TO tt-ord-prod-aux.
                END.

                FOR EACH tt-ordem-compra
                    WHERE tt-ordem-compra.it-codigo     = tt-item.it-codigo
                      AND tt-ordem-compra.cod-refer     = tt-item.cod-refer
                       AND tt-ordem-compra.data-entrega = tt-item.data
                            BREAK BY tt-ordem-compra.num-pedido: 
                    CREATE tt-ordem-compra-aux.
                    BUFFER-COPY tt-ordem-compra TO tt-ordem-compra-aux.
                END.

                FOR EACH tt-reservas
                    WHERE tt-reservas.it-codigo    = tt-item.it-codigo
                      AND tt-reservas.cod-refer    = tt-item.cod-refer
                       AND tt-reservas.dt-reserva  = tt-item.data
                            BREAK BY tt-reservas.nr-ord-prod:  
                    CREATE tt-reservas-aux.
                    BUFFER-COPY tt-reservas TO tt-reservas-aux.
                END.
            END. /* else do today - 1 */                        

        END. /* end for each tt-item */ 
    END. /* end for each tt-h-item */ 

    /* Roda o adapter para gerar a mensagem de envio */
    RUN adapters/neogrid/pdp/anepd020c.p (INPUT  TABLE tt-h-item-aux,      
                                          input  table tt-item-aux,        
                                          input  table tt-ord-prod-aux,    
                                          input  table tt-ordem-compra-aux,
                                          INPUT  TABLE tt-pedidos-aux,     
                                          INPUT  TABLE tt-reservas-aux).
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-encerra-execucao:

    DEF VAR c-sim AS CHAR FORMAT "x(3)" NO-UNDO.
    DEF VAR c-nao AS CHAR FORMAT "x(3)" NO-UNDO.

    {utp/ut-liter.i Destino *} c-saida:label in frame f-parametros = trim(return-value).
    {utp/ut-liter.i Usu rio *} tt-param.usuario:label in frame f-parametros = trim(return-value).

    {utp/ut-liter.i SELE€ÇO    MPD L}  c-sel = trim(return-value).
    {utp/ut-liter.i PAR¶METROS MPD L}  c-par = trim(return-value).
    {utp/ut-liter.i IMPRESSÇO  MPD L}  c-imp = trim(return-value).
                                        
    case tt-param.destino:
       when 1 then do:
          {utp/ut-liter.i Impressora *} c-des = trim(return-value).
       end.

       when 2 then do:
          {utp/ut-liter.i Arquivo *} c-des = trim(return-value).
       end.

       when 3 then do:
           {utp/ut-liter.i Terminal *} c-des = trim(return-value).
       end.
    end.

    CASE tt-param.pa-benefic:
        WHEN 1 THEN DO:
            {utp/ut-liter.i Considera *} c-benefic = TRIM(RETURN-VALUE).
        END.
        WHEN 2 THEN DO:
            {utp/ut-liter.i NÆo_Considera *} c-benefic = TRIM(RETURN-VALUE).
        END.
        WHEN 3 THEN DO:
            {utp/ut-liter.i Demonstra *} c-benefic = TRIM(RETURN-VALUE).
        END.
    END CASE.

    {utp/ut-liter.i Sim * R} c-sim = TRIM(RETURN-VALUE).
    {utp/ut-liter.i NÆo * R} c-nao = TRIM(RETURN-VALUE).

    disp c-sel
         c-estab-ini
         c-estab-fim
         item-ini
         item-fim
         fam-com-ini
         fam-com-fim
         ge-codigo-ini
         ge-codigo-fim

         c-par
         IF tt-param.pa-ord-comp    THEN c-sim ELSE c-nao @ pa-ord-comp
         IF tt-param.pa-ord-prod    THEN c-sim ELSE c-nao @ pa-ord-prod
         IF tt-param.pa-planejada   THEN c-sim ELSE c-nao @ pa-planejada
         IF tt-param.pa-res-comp    THEN c-sim ELSE c-nao @ pa-res-comp 
         IF tt-param.pa-res-plan    THEN c-sim ELSE c-nao @ pa-res-plan
         IF tt-param.pa-sald-est    THEN c-sim ELSE c-nao @ pa-sald-est
         IF tt-param.pa-item-fatur  THEN c-sim ELSE c-nao @ pa-item-fatur
         IF tt-param.pa-wf-desconto THEN c-sim ELSE c-nao @ pa-wf-desconto
         IF tt-param.pa-depositos   THEN c-sim ELSE c-nao @ pa-depositos
         IF tt-param.pa-dep-cq      THEN c-sim ELSE c-nao @ pa-dep-cq

         pa-cod-plano
         pa-dt-plan
         pa-dt-corte

         c-benefic

         IF tt-param.pa-t-pedidos  THEN c-sim ELSE c-nao @ pa-t-pedidos
         IF tt-param.pa-t-ord-prod THEN c-sim ELSE c-nao @ pa-t-ord-prod
         IF tt-param.pa-t-reservas THEN c-sim ELSE c-nao @ pa-t-reservas
         IF tt-param.pa-t-compras  THEN c-sim ELSE c-nao @ pa-t-compras

         IF tt-param.pa-pedidos     THEN c-sim ELSE c-nao @ pa-pedidos
         IF tt-param.pa-cred-aprov  THEN c-sim ELSE c-nao @ pa-cred-aprov
         IF tt-param.pa-ped-n-av    THEN c-sim ELSE c-nao @ pa-ped-n-av
         IF tt-param.pa-ped-aval    THEN c-sim ELSE c-nao @ pa-ped-aval
         IF tt-param.pa-ped-apro    THEN c-sim ELSE c-nao @ pa-ped-apro
         IF tt-param.pa-ped-repr    THEN c-sim ELSE c-nao @ pa-ped-repr
         IF tt-param.pa-cons-qt-aba THEN c-sim ELSE c-nao @ pa-cons-qt-aba
         IF tt-param.pa-abertos     THEN c-sim ELSE c-nao @ pa-abertos
         IF tt-param.pa-at-parcial  THEN c-sim ELSE c-nao @ pa-at-parcial

         IF tt-param.pa-sald-terc      THEN c-sim ELSE c-nao @ pa-sald-terc
         IF tt-param.pa-remessa-benef  THEN c-sim ELSE c-nao @ pa-remessa-benef
         IF tt-param.pa-entrada-benef  THEN c-sim ELSE c-nao @ pa-entrada-benef
         IF tt-param.pa-transferencia  THEN c-sim ELSE c-nao @ pa-transferencia
         IF tt-param.pa-remessa-consig THEN c-sim ELSE c-nao @ pa-remessa-consig
         IF tt-param.pa-entrada-consig THEN c-sim ELSE c-nao @ pa-entrada-consig

         c-imp
         trim(c-des) + '   -   ' + tt-param.arquivo @ c-saida
         tt-param.usuario
         with frame f-parametros.

    page.

    RETURN "OK":U.

END PROCEDURE.

/* Fim */
