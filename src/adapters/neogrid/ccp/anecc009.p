/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANECC009 2.00.00.003} /*** "010003" 20/01/2025 15:16:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anecc009 MAN}
&ENDIF

/********************************************************************************
** Programa : anecc009.p
** Fun‡Æo   : Altera‡Æo do Pedido de Compra
** Data     : 09/2001
** Autor    : NeoGrid S.A. (Fausto Maciel)
********************************************************************************/

/* Temp Tables Recebidas do Receiver */
{inbo/boin295.i tt-pedido-compr}
{inbo/boin274.i tt-ordem-compra}
{inbo/boin356.i tt-prazo-compra}
{inbo/boin082.i tt-cotacao-item}
{inbo/boin057.i tt-cond-especif}
{inbo/boin356.i tt-prazo-compra-aux}

DEF INPUT PARAM TABLE FOR tt-pedido-compr. 
DEF INPUT PARAM TABLE FOR tt-ordem-compra. 
DEF INPUT PARAM TABLE FOR tt-prazo-compra. 
DEF INPUT PARAM TABLE FOR tt-cotacao-item. 
DEF INPUT PARAM TABLE FOR tt-cond-especif. 

/* Temp Tables de Parametros dos Metodos das BOïs */
{inbo/boin295.i tt-pedido-compr-bo}
{inbo/boin274.i tt-ordem-compra-bo}
{inbo/boin274.i tt-ordem-compra-aux}
{inbo/boin356.i tt-prazo-compra-bo}
{inbo/boin082.i tt-cotacao-item-bo}
{inbo/boin057.i tt-cond-especif-bo}

{include/boerrtab.i}

/* Handles das BOïs */
DEF VAR h-boin082    AS HANDLE NO-UNDO.
DEF VAR h-boin082vl  AS HANDLE NO-UNDO.
DEF VAR h-boin274    AS HANDLE NO-UNDO.
DEF VAR h-boin274vl  AS HANDLE NO-UNDO.
DEF VAR h-boin295    AS HANDLE NO-UNDO.
DEF VAR h-boin356    AS HANDLE NO-UNDO.
DEF VAR h-boin356vl  AS HANDLE NO-UNDO.
DEF VAR h-boin057    AS HANDLE NO-UNDO.
DEF VAR h-boin356aux AS HANDLE NO-UNDO.

def var i-nro-rows      as integer      no-undo.
DEF SHARED VAR c-docidentifier AS CHAR NO-UNDO.

{method/dbotterr.i}  
               
{cdp/cdapi300.i1}                       /* Temp-Table tt-erros-geral */
{adapters/neogrid/ftp/aneft002.i}       /* Temp-Table tt-erro-neogrid */
{utp/ut-glob.i}
                 

/* CRIAR UMA INCLUDE PARA O BLOCO ABAIXO */

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field estabel-ini     like ped-venda.cod-estabel
    field estabel-fim     like ped-venda.cod-estabel
    field cliente-ini     like ped-venda.nome-abrev
    field cliente-fim     like ped-venda.nome-abrev
    field pedido-ini      like ped-venda.nr-pedcli
    field pedido-fim      like ped-venda.nr-pedcli
    field entrega-ini     like ped-venda.dt-entrega
    field entrega-fim     like ped-venda.dt-entrega
    field nome-repres-ini like ped-venda.no-ab-reppri
    field nome-repres-fim like ped-venda.no-ab-reppri
    field nr-invoice-ini  like ped-venda.nr-invoice
    field nr-invoice-fim  like ped-venda.nr-invoice
    field pais            as integer.

define temp-table tt-digita
    field ordem   as integer   format ">>>>9"
    field exemplo as character format "x(30)"
    index id is primary unique
        ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param as raw no-undo.

def temp-table tt-raw-digita
    field raw-digita as raw.

/* FIM BLOCO */

/* Chamada e abertura das queryïs das BOïs */
RUN inbo/boin082.p      PERSISTENT SET h-boin082.
RUN inbo/boin082.p      PERSISTENT SET h-boin082vl.
RUN inbo/boin274.p      PERSISTENT SET h-boin274.
RUN inbo/boin274vl.p    PERSISTENT SET h-boin274vl.
RUN inbo/boin295.p      PERSISTENT SET h-boin295.
RUN inbo/boin356.p      PERSISTENT SET h-boin356.
RUN inbo/boin356vl.p    PERSISTENT SET h-boin356vl.
RUN inbo/boin057.p      PERSISTENT SET h-boin057.

RUN openquery IN h-boin082 (INPUT 1).
RUN openQuery IN h-boin274 (INPUT 1).
RUN openQuery IN h-boin295 (INPUT 1).
RUN openQuery IN h-boin356 (INPUT 1).
RUN openQueryMain IN h-boin057.
/* Fim Chamada e abertura das queryïs das BOïs */

def stream s-anecc004.
run PurchaseOrderAcceptance.

procedure PurchaseOrderAcceptance:
    def var c-lista                     as char no-undo.
    def var de-perc-ind                 as dec  no-undo.
    def var i-repres-ind                as int  no-undo.
    def var c-lista-r-alt-ped           as char no-undo.
    def var i-rep-indireto              like repres.cod-rep                no-undo.
    def var i-cod-maq-origem            like tt-erros-geral.cod-maq-origem no-undo.
    def var i-num-processo              like tt-erros-geral.num-processo   no-undo.
    def var de-vl-financto              like ordem-compra.pre-unit-for     no-undo.
    def var de-vl-merc-liq              like ordem-compra.pre-unit-for     no-undo.
    def var de-vl-desconto              like ordem-compra.pre-unit-for     no-undo.
    def var c-cod-estabel               like tt-pedido-compr.cod-estabel   no-undo.
    DEF VAR l-inform-cond-especif       AS LOGICAL INIT NO NO-UNDO.
    DEF VAR i-x                         AS INT INIT 0 NO-UNDO.
                                    
    assign c-seg-usuario             = "Neogrid".  
   
    /* Atualiza os Registros utilizando as BOs */
    
    /* Pedido Compra */
    for each tt-pedido-compr NO-LOCK:
        RUN goToKey in h-boin295 (INPUT tt-pedido-compr.num-pedido).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN GetRecord in h-boin295 (OUTPUT TABLE tt-pedido-compr-bo).
            find first tt-pedido-compr-bo EXCLUSIVE-LOCK NO-ERROR.
            assign tt-pedido-compr-bo.cod-emitente = tt-pedido-compr.cod-emitente
                   tt-pedido-compr-bo.cod-estabel  = tt-pedido-compr.cod-estabel
                   tt-pedido-compr-bo.data-pedido  = tt-pedido-compr.data-pedido
                   tt-pedido-compr-bo.situacao     = tt-pedido-compr.situacao
                   tt-pedido-compr-bo.comentarios  = tt-pedido-compr.comentarios
                   tt-pedido-compr-bo.end-entrega  = tt-pedido-compr.end-entrega
                   tt-pedido-compr-bo.end-cobranca = tt-pedido-compr.end-cobranca
                   tt-pedido-compr-bo.frete        = tt-pedido-compr.frete.
            RUN emptyRowObject  IN h-boin295.
            RUN setRecord IN h-boin295 (INPUT TABLE tt-pedido-compr-bo).
            run validateUpdatePedEmerg in h-boin295 (input tt-pedido-compr-bo.r-rowid, input c-seg-usuario, output c-lista-r-alt-ped).
            RUN getRowErrors IN h-boin295 (output table RowErrors).
        END.
        find first RowErrors no-lock no-error.
        if avail RowErrors then do:
           for each RowErrors no-lock:
               create tt-erro-neogrid.
               assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
                      tt-erro-neogrid.c-cod-estabel = tt-pedido-compr.cod-estabel
                      tt-erro-neogrid.i-cod-erro    = RowErrors.ErrorNumber
                      tt-erro-neogrid.c-desc-erro   = RowErrors.ErrorDescription. 
           end.
        end.        
        assign c-cod-estabel = tt-pedido-compr.cod-estabel.
        
    end.
    /* Ordem Compra */
    for each tt-ordem-compra NO-LOCK:
        RUN goToKey in h-boin274 (INPUT tt-ordem-compra.numero-ordem).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN GetRecord in h-boin274 (OUTPUT TABLE tt-ordem-compra-bo).
            find first tt-ordem-compra-bo EXCLUSIVE-LOCK no-error.
            assign tt-ordem-compra-bo.it-codigo    = tt-ordem-compra.it-codigo
                   tt-ordem-compra-bo.mo-codigo    = tt-ordem-compra.mo-codigo
                   tt-ordem-compra-bo.preco-unit   = tt-ordem-compra.preco-unit
                   tt-ordem-compra-bo.cod-refer    = tt-ordem-compra.cod-refer
                   tt-ordem-compra-bo.narrativa    = tt-ordem-compra.narrativa
                   tt-ordem-compra-bo.numero-ordem = tt-ordem-compra.numero-ordem.
            RUN emptyRowObject  IN h-boin274.
            RUN setRecord IN h-boin274 (INPUT TABLE tt-ordem-compra-bo).

            RUN validateUpdatePedEmerg in h-boin274vl (input table tt-ordem-compra-bo, 
                                                       input tt-ordem-compra-bo.r-rowid,
                                                       output table tt-bo-erro).
            RUN executeUpdatePedEmerg IN h-boin274vl.
               
            RUN getRowErrors IN h-boin274 (output table RowErrors).
        END.
        find first RowErrors no-lock no-error.
        if avail RowErrors then do:
           for each RowErrors no-lock:
               create tt-erro-neogrid.
               assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
                      tt-erro-neogrid.c-cod-estabel = c-cod-estabel
                      tt-erro-neogrid.i-cod-erro    = RowErrors.ErrorNumber
                      tt-erro-neogrid.c-desc-erro   = RowErrors.ErrorDescription. 
           end.
        end.
    end.
    /* Prazo Compra */

    for each tt-prazo-compra NO-LOCK:
        RUN goToKey in h-boin356 (INPUT tt-prazo-compra.numero-ordem, INPUT tt-prazo-compra.parcela).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN GetRecord in h-boin356 (OUTPUT TABLE tt-prazo-compra-bo).
            find first tt-prazo-compra-bo EXCLUSIVE-LOCK NO-ERROR.
            assign tt-prazo-compra-bo.data-entrega = tt-prazo-compra.data-entrega
                   tt-prazo-compra-bo.quantidade   = tt-prazo-compra.quantidade
                   tt-prazo-compra-bo.un           = tt-prazo-compra.un.
            RUN emptyRowObject  IN h-boin356.
            RUN setRecord IN h-boin356 (INPUT TABLE tt-prazo-compra-bo).
            for each tt-ordem-compra-aux EXCLUSIVE-LOCK:
                delete tt-ordem-compra-aux.
            end.
            find first tt-ordem-compra where
                       tt-ordem-compra.numero-ordem = tt-prazo-compra.numero-ordem
                       no-lock no-error.
            if  avail tt-ordem-compra then do:
                create tt-ordem-compra-aux.
                buffer-copy tt-ordem-compra to tt-ordem-compra-aux.
                run inputTableOrdemCompra in h-boin356vl (input table tt-ordem-compra-aux).

                RUN inbo/boin356.p PERSISTENT SET h-boin356aux.
                RUN setConstraintNumOrdem in h-boin356aux (input tt-ordem-compra.numero-ordem).
                RUN openQueryStatic       in h-boin356aux (input "byNumOrdembyParcela").
                RUN getFirst              IN h-boin356aux.
                RUN getBatchRecords       IN h-boin356aux 
                    (?, no, ?, output i-nro-rows, output table tt-prazo-compra-aux).
                DELETE PROCEDURE h-boin356aux.

                run validateUpdateManutOrdCompra in h-boin356vl (input  table tt-prazo-compra-bo,
                                                                 input  table tt-prazo-compra-aux,
                                                                 "mod",
                                                                 input  tt-prazo-compra-bo.r-rowid,
                                                                 input  string(today, "99/99/9999"),
                                                                 "31/12/9999",
                                                                 "", /* usu rio corrente ser  pego na BO */
                                                                 yes,
                                                                 no,
                                                                 yes, 
                                                                 yes,
                                                                 output table tt-bo-erro).
                RUN executeUpdateManutOrdCompra IN h-boin356vl (input tt-prazo-compra-bo.r-rowid).
                RUN getRowErrors IN h-boin356 (output table RowErrors).
            END.
        END.
        find first RowErrors no-lock no-error.
        if avail RowErrors then do:
            for each RowErrors no-lock:
                create tt-erro-neogrid.
                assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
                       tt-erro-neogrid.c-cod-estabel = c-cod-estabel
                       tt-erro-neogrid.i-cod-erro    = RowErrors.ErrorNumber
                       tt-erro-neogrid.c-desc-erro   = RowErrors.ErrorDescription. 
            end.
        end.
    end.
    /* Cotacao */
    for each tt-cotacao-item NO-LOCK:
        RUN goToCotacaoAprovada in h-boin082 (input tt-cotacao-item.numero-ordem).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN GetRecord in h-boin082 (OUTPUT TABLE tt-cotacao-item-bo).
            find first tt-cotacao-item-bo EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN tt-cotacao-item-bo.it-codigo       = tt-cotacao-item.it-codigo
                   tt-cotacao-item-bo.numero-ordem    = tt-cotacao-item.numero-ordem
                   tt-cotacao-item-bo.cod-emitente    = tt-cotacao-item.cod-emitente.
            IF  tt-cotacao-item.perc-descto <> 0 THEN
                ASSIGN tt-cotacao-item-bo.perc-descto = tt-cotacao-item.perc-descto.
            IF  tt-cotacao-item.valor-descto <> 0 THEN
                ASSIGN tt-cotacao-item-bo.valor-descto = tt-cotacao-item.valor-descto.
            IF  tt-cotacao-item.valor-frete <> 0 THEN
                ASSIGN tt-cotacao-item-bo.valor-frete = tt-cotacao-item.valor-frete.
            IF  tt-cotacao-item.valor-taxa <> 0 THEN
                ASSIGN tt-cotacao-item-bo.valor-taxa = tt-cotacao-item.valor-taxa.
            IF  tt-cotacao-item.aliquota-icm <> 0 THEN
                ASSIGN tt-cotacao-item-bo.aliquota-icm = tt-cotacao-item.aliquota-icm.
            IF  tt-cotacao-item.aliquota-ipi <> 0 THEN
                ASSIGN tt-cotacao-item-bo.aliquota-ipi = tt-cotacao-item.aliquota-ipi.
            IF  tt-cotacao-item.aliquota-iss <> 0 THEN
                ASSIGN tt-cotacao-item-bo.aliquota-iss = tt-cotacao-item.aliquota-iss.
            IF  tt-cotacao-item.preco-unit <> 0 THEN
                ASSIGN tt-cotacao-item-bo.preco-unit = tt-cotacao-item.preco-unit.
            RUN emptyRowObject  IN h-boin082.
            RUN setRecord IN h-boin082 (INPUT TABLE tt-cotacao-item-bo). 
            RUN updateRecord IN h-boin082.
            RUN getRowErrors IN h-boin082 (output table RowErrors).
        END.
        find first RowErrors no-lock no-error.
        if avail RowErrors then do:
            for each RowErrors no-lock:
                create tt-erro-neogrid.
                assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
                       tt-erro-neogrid.c-cod-estabel = c-cod-estabel
                       tt-erro-neogrid.i-cod-erro    = RowErrors.ErrorNumber
                       tt-erro-neogrid.c-desc-erro   = RowErrors.ErrorDescription. 
            end.
        end.
    end.
    
    /* Condi‡Æo Espec¡fica */
    FOR EACH tt-pedido-compr NO-LOCK: /* Valida‡Æo por Pedido */
        run validaCondicaoEspecifica in h-boin295 (input  yes,
                                                   input  tt-pedido-compr.num-pedido,
                                                   input  tt-pedido-compr.cod-cond-pag,
                                                   input  yes,
                                                   output l-inform-cond-especif).
        IF  l-inform-cond-especif = YES THEN DO:
            for each tt-cond-especif NO-LOCK WHERE tt-cond-especif.num-pedido = tt-pedido-compr.num-pedido:
                RUN goToKey in h-boin057 (INPUT tt-cond-especif.num-pedido).
                IF  RETURN-VALUE = "OK":U THEN DO:
                    RUN GetRecord in h-boin057 (OUTPUT TABLE tt-cond-especif-bo).
                    find first tt-cond-especif-bo no-error.
                    assign tt-cond-especif-bo.num-pedido = tt-cond-especif.num-pedido.
                    DO  i-x = 1 TO 12:
                        ASSIGN tt-cond-especif-bo.data-pagto[i-x] = tt-cond-especif.data-pagto[i-x]
                               tt-cond-especif-bo.perc-pagto[i-x] = tt-cond-especif.perc-pagto[i-x]
                               tt-cond-especif-bo.comentarios[i-x] = tt-cond-especif.comentarios[i-x].
                    END.
                    RUN emptyRowObject  IN h-boin057.
                    RUN setRecord       IN h-boin057 (INPUT TABLE tt-cond-especif-bo).
                    RUN updateRecord    IN h-boin057.
                    RUN getRowErrors    IN h-boin057 (output table RowErrors).
                END.
                find first RowErrors no-lock no-error.
                if avail RowErrors then do:
                    for each RowErrors no-lock:
                        create tt-erro-neogrid.
                        assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
                               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
                               tt-erro-neogrid.i-cod-erro    = RowErrors.ErrorNumber
                               tt-erro-neogrid.c-desc-erro   = RowErrors.ErrorDescription. 
                    end.
                end.
            end.
        END.
    END.
    /* Fim da Atualiza‡Æo */       
   
    find first tt-erro-neogrid no-lock no-error.
    if  avail tt-erro-neogrid then do:    
        run adapters/neogrid/ftp/aneft002.p (INPUT table tt-erro-neogrid).
    end.

end.

DELETE PROCEDURE h-boin082.
DELETE PROCEDURE h-boin082vl.
delete procedure h-boin274.
delete procedure h-boin274vl.
delete procedure h-boin295.
delete procedure h-boin356.
delete procedure h-boin356vl.
DELETE PROCEDURE h-boin057.
