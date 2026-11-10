/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM7778 2.00.00.008 } /*** "010008" 09/07/2026 16:01:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im7778 MIM}
&ENDIF

{include/i_fncrowid.i}
{cdp/cdcfgmat.i}     /* Definicao de pre-processadores   */
{cdp/cdcfgdis.i}     /* Definicao de pre-processadores   */
{include/boerrtab.i} /* Definicao tt-bo-erro             */
{cdp/cd0666.i}       /* Defini‡Æo da temp-table de erros */   
{cdp/cd9900.i5}      /* Procedure pi-busca-portador-modalidade */

{cdp/cd4305.i1}

{inbo/boin090.i ttDocumEst}
{inbo/boin176.i ttItemDocEst}
{inbo/boin176.i ttItemDocEstAux}
{cxbo/bocx100.i ttItemDocEstCex}

def temp-table ttItemDocEstCopy    no-undo like ttItemDocEst.
def temp-table ttItemDocEstCexCopy no-undo like ttItemDocEstCex.

def temp-table tt-base-ii no-undo 
    field sequencia like item-doc-est.sequencia
    field base-ii   as decimal.

def temp-table tt-it-base-icm no-undo
    field nro-docto like item-doc-est.nro-docto
    field it-codigo like item-doc-est.it-codigo
    field sequencia like item-doc-est.sequencia
    field base-icm  as decimal.



def var h-boin090         as handle                     no-undo.
def var h-boin176         as handle                     no-undo.
def var h-bocx100         as handle                     no-undo.

def var de-frete          like item-doc-est.valor-frete no-undo.
def var de-seguro         like item-doc-est.valor-frete no-undo.
def var de-embal          like item-doc-est.valor-frete no-undo.
def var de-outras         like item-doc-est.valor-frete no-undo.
def var de-base-ipi       like item-doc-est.valor-frete no-undo.
def var de-base-icm       like item-doc-est.valor-frete no-undo.
def var i-seq-aux         as integer                    no-undo.

def var de-tot-frete      like item-doc-est.valor-frete no-undo.
def var de-tot-seguro     like item-doc-est.valor-frete no-undo.
def var de-tot-embal      like item-doc-est.valor-frete no-undo.

def var de-tot-outras         like desp-embarque.val-desp no-undo.
def var de-tot-outras-aux     like desp-embarque.val-desp no-undo.

def var de-tot-base-ipi    as decimal init 0 no-undo.
def var de-tot-vl-ipi      as decimal init 0 no-undo.
def var de-total-desp      as decimal init 0 no-undo.
def var de-valor-ii        as decimal init 0 no-undo.
def var de-tot-base-icm    as decimal init 0 no-undo.
def var l-desp             as logical init no no-undo.


{cdp/cd4300.i3}    /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */         
/*
def temp-table tt-it-docto-aux   no-undo like tt-it-docto.
def temp-table tt-it-imposto-aux no-undo like tt-it-imposto.
*/

/**NOVO**/
def var de-trib-pis                as INTEGER init 2                   no-undo.
def var de-trib-cofins             as INTEGER init 2                   no-undo.
def var de-aliquota-pis            as DECIMAL format ">9.99":U         no-undo.
def var de-val-unit-pis            as decimal format ">>>9.99999":U    no-undo.
def var de-val-vol-pis             as decimal format ">>>9.99999":U    no-undo.
def var de-aliquota-cofins         as DECIMAL format ">9.99":U         no-undo.
def var de-val-unit-cofins         as decimal format ">>>9.99999":U    no-undo.
def var de-val-vol-cofins          as decimal format ">>>9.99999":U    no-undo.
DEF VAR i-trib-ii                  AS INTEGER                          NO-UNDO.
DEF VAR de-aliq-ii                 AS DECIMAL FORMAT ">>9.9999"        NO-UNDO.
DEF VAR de-aliq-icms-imp           AS DECIMAL FORMAT ">>9.99"          NO-UNDO.
DEF VAR de-aliq-ipi-imp            AS DECIMAL FORMAT ">>9.99"          NO-UNDO.
DEF VAR de-base-ipi-aux            LIKE docum-est.base-ipi             NO-UNDO.
def var de-valor-pis               as decimal format ">>>>>>>>>9.99":U no-undo.
def var de-valor-cofins            as decimal format ">>>>>>>>>9.99":U no-undo.
def var de-base-pis                as decimal format ">>>>>>>>>9.99":U no-undo.
DEF VAR de-volume-item             AS DECIMAL FORMAT ">>>>>>>>>9.99"   NO-UNDO.
def var de-base-cofins             as decimal format ">>>>>>>>>9.99":U no-undo.
def var de-tot-despesa             like docum-est.despesa-nota         NO-UNDO.
DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.
DEFINE VARIABLE h-cd4337 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cd4338 AS HANDLE      NO-UNDO.
/**NOVO**/
DEFINE VARIABLE i-trib-icm AS integer     NO-UNDO.
DEFINE VARIABLE i-trib-ipi AS integer     NO-UNDO.
def var de-vl-icm          as decimal no-undo.
DEF VAR de-tot-icms        AS DECIMAL           NO-UNDO.

define new global shared variable gc-peso-bruto-tot as CHAR no-undo.


def buffer b-emit-estab for emitente.

def var i-seq-erro                as   integer                no-undo.

DEF INPUT  PARAMETER p-rw-docum-est AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.

FIND docum-est
     WHERE ROWID(docum-est) = p-rw-docum-est NO-LOCK NO-ERROR.

create ttDocumEst.
buffer-copy docum-est to ttDocumEst.
assign ttDocumEst.r-rowid = rowid(docum-est).

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST param-cq     NO-LOCK NO-ERROR.

FIND emitente 
     WHERE emitente.cod-emitente   = docum-est.cod-emitente 
     NO-LOCK NO-ERROR.

FIND natur-oper
     WHERE natur-oper.nat-operacao = docum-est.nat-operacao 
     NO-LOCK NO-ERROR.

FIND estabelec
     WHERE estabelec.cod-estabel = docum-est.cod-estabel 
     NO-LOCK NO-ERROR.

find b-emit-estab
     where b-emit-estab.cod-emitente = estabelec.cod-emitente 
     no-lock no-error.
     
FIND param-re
     WHERE param-re.usuario = docum-est.usuario 
     NO-LOCK NO-ERROR.

FIND serie
     WHERE serie.serie = docum-est.serie-docto 
     NO-LOCK NO-ERROR.

FIND param-imp
     WHERE param-imp.cod-estabel = docum-est.cod-estabel 
     NO-LOCK NO-ERROR.

/*run pi-cria-tt-docto.*/



/*Maylon*/
/*Verifica se existe ao menos uma despesa*/
if can-find(first docum-est-cex
            where docum-est-cex.serie-docto  = docum-est.serie-docto
              and docum-est-cex.nro-docto    = docum-est.nro-docto
              and docum-est-cex.cod-emitente = docum-est.cod-emitente
              and docum-est-cex.nat-operacao = docum-est.nat-operacao) then
    run pi-gera-tt-despesas.
else
    run pi-calcula-impostos.



/******************************************/
run inbo/boin090.p persistent set h-boin090.
run inbo/boin176.p persistent set h-boin176.
run cxbo/bocx100.p persistent set h-bocx100.

blk-trans:
do transaction on error undo blk-trans, leave blk-trans
               on stop  undo blk-trans, leave blk-trans:

    run emptyRowObject   in h-boin090.
    run openQueryStatic  in h-boin090 (input "Main").
    run repositionRecord in h-boin090 (input ttDocumEst.r-rowid).
    assign gc-peso-bruto-tot = string(ttDocumEst.tot-peso).
    run setRecord        in h-boin090 (input table ttDocumEst).
    run updateRecord     in h-boin090.
    if return-value = "NOK":U then do:
       run getRowErrors IN h-boin090 (output table tt-bo-erro).
       undo blk-trans, leave blk-trans.
    end.

    run emptyRowObject   in h-boin176.
    run setConstraintOfDocumEst in h-boin176(input ttDocumEst.cod-emitente,
                                             input ttDocumEst.serie-docto,
                                             input ttDocumEst.nro-docto,
                                             input ttDocumEst.nat-operacao).
    run openQueryStatic  in h-boin176 (input "Main").

    for each ttItemDocEst EXCLUSIVE-LOCK:

        EMPTY TEMP-TABLE ttItemDocEstAux.
        CREATE ttItemDocEstAux.
        BUFFER-COPY ttItemDocEst TO ttItemDocEstAux. 
        
        run repositionRecord in h-boin176 (input ttItemDocEst.r-rowid).
        run setRecord        in h-boin176 (input table ttItemDocEstAux).
        run updateRecord     in h-boin176.

        if return-value = "NOK":U then do:
           run getRowErrors IN h-boin176 (output table tt-bo-erro).
           undo blk-trans, leave blk-trans.
        end.
    end.

    for each ttItemDocEstCex EXCLUSIVE-LOCK:

        empty temp-table ttItemDocEstCexCopy.
        create ttItemDocEstCexCopy.
        buffer-copy ttItemDocEstCex to ttItemDocEstCexCopy.

        RUN emptyRowObject  IN h-bocx100.
        RUN openQueryStatic IN h-bocx100 (INPUT "Main").
        RUN emptyRowErrors  IN h-bocx100.
        RUN setRecord       IN h-bocx100 (INPUT TABLE ttItemDocEstCexCopy).
        RUN gotokey         IN h-bocx100 (INPUT ttItemDocEstCexCopy.serie-docto,
                                          INPUT ttItemDocEstCexCopy.nro-docto,
                                          INPUT ttItemDocEstCexCopy.cod-emitente,
                                          INPUT ttItemDocEstCexCopy.nat-operacao,
                                          INPUT ttItemDocEstCexCopy.sequencia,
                                          INPUT ttItemDocEstCexCopy.cod-emitente-desp,
                                          INPUT ttItemDocEstCexCopy.cod-desp).
        
        IF RETURN-VALUE <> "NOK":U THEN DO:
            RUN updateRecord    in h-bocx100.
            IF return-value = "NOK":U then do:
               run getRowErrors IN h-bocx100 (output table tt-bo-erro).
                undo blk-trans, leave blk-trans.
            END.
        END.
        ELSE DO:

            RUN createRecord    in h-bocx100.
            IF return-value = "NOK":U then do:
               run getRowErrors IN h-bocx100 (output table tt-bo-erro).
                undo blk-trans, leave blk-trans.
            END.
        END.
    END.

END.

delete procedure h-bocx100.
delete procedure h-boin176.
delete procedure h-boin090.

if can-find (first tt-bo-erro
             WHERE  tt-bo-erro.errortype  <> "internal") then
    return "NOK":U.


/******************************************/

procedure pi-gera-tt-despesas:

    def var de-tot-desp          like cotacao-item-cex.val-desp no-undo.
    def var de-val-desp          like cotacao-item-cex.val-desp no-undo.

    def var de-preco-total       like item-doc-est.preco-total[1]  no-undo.
    def var de-quantidade        like item-doc-est.quantidade      no-undo.
    def var de-peso-liquido      like item-doc-est.peso-liquido    no-undo.
    def var de-cubagem           like item-doc-est.quantidade      no-undo.
    def var de-volume-total      like embalag.volume               no-undo.

    empty temp-table ttItemDocEst.
    empty temp-table ttItemDocEstCex.

    run cdp/cd4337.p   persistent set h-cd4337.
    run cdp/cd4338.p   persistent set h-cd4338.


    FOR EACH item-doc-est-cex
       where item-doc-est-cex.serie-docto = docum-est.serie-docto
        &if defined(bf-mat-comex) &then
        and item-doc-est-cex.nro-docto         = string(docum-est.nro-docto)
        &else
        and item-doc-est-cex.nro-docto         = docum-est.nro-docto
        &endif
        and   item-doc-est-cex.cod-emitente    = docum-est.cod-emitente
        and   item-doc-est-cex.nat-operacao    = docum-est.nat-operacao exclusive-lock:
        DELETE  item-doc-est-cex.
    END.

    for each docum-est-cex no-lock
       where docum-est-cex.serie-docto  = docum-est.serie-docto
         and docum-est-cex.nro-docto    = docum-est.nro-docto
         and docum-est-cex.cod-emitente = docum-est.cod-emitente
         and docum-est-cex.nat-operacao = docum-est.nat-operacao,
       first desp-imp no-lock
       where desp-imp.cod-desp = docum-est-cex.cod-desp,
       first param-imp no-lock
       where param-imp.cod-estabel = docum-est.cod-estabel:

        assign de-peso-liquido = 0
               de-quantidade   = 0
               de-preco-total  = 0
               de-cubagem      = 0
               de-tot-desp     = 0.

        /*Acumula Totais*/
        for each item-doc-est fields(it-codigo peso-liquido  quantidade  preco-total[1]) no-lock
           where item-doc-est.serie-docto  = docum-est.serie-docto
             and item-doc-est.nro-docto    = docum-est.nro-docto
             and item-doc-est.cod-emitente = docum-est.cod-emitente
             and item-doc-est.nat-operacao = docum-est.nat-operacao,
           first item fields(peso-bruto altura largura comprim) no-lock
           where item.it-codigo = item-doc-est.it-codigo:
            assign de-peso-liquido = de-peso-liquido + item-doc-est.peso-liquido
                   de-quantidade   = de-quantidade   + item-doc-est.quantidade
                   de-preco-total  = de-preco-total  + item-doc-est.preco-total[1]
                   de-cubagem      = de-cubagem      + (item-doc-est.quantidade * (item.altura * item.largura * item.comprim)).
        end.

        /*Cria Rateio*/
        for each item-doc-est exclusive-lock
           where item-doc-est.serie-docto  = docum-est-cex.serie-docto
             and item-doc-est.nro-docto    = docum-est-cex.nro-docto
             and item-doc-est.cod-emitente = docum-est-cex.cod-emitente
             and item-doc-est.nat-operacao = docum-est-cex.nat-operacao,
           first item fields(peso-bruto altura largura comprim cd-trib-icm cd-trib-ipi) no-lock
           where item.it-codigo = item-doc-est.it-codigo:
            assign de-val-desp              = 0
                   item-doc-est.despesas[1] = 0
                   item-doc-est.valor-frete = 0.

            /*Maylon*/
            /*Melhorias de Ecporta‡Æo - tratamento tributa‡Æo apenas p/ devolu‡Æo de cliente e cliente estrangeiro*/
            if docum-est.cod-observa = 3 and emitente.natureza = 3 and avail item and avail natur-oper and param-global.modulo-ex then do:

                /*Retorna tributa‡Æo ICMS*/
                run cdp/cd4302.p (input item.cd-trib-icm,
                                  input natur-oper.cd-trib-icm,
                                  output i-trib-icm).

                /*Retorna tributa‡Æo IPI*/
                run cdp/cd4303.p (input item.cd-trib-ipi,
                                  input natur-oper.cd-trib-ipi,
                                  output i-trib-ipi).

                assign item-doc-est.cd-trib-icm  = i-trib-icm
                       item-doc-est.cd-trib-ipi  = i-trib-ipi.

            end.
            /*Maylon*/

            find first ttItemDocEst
                 where ttItemDocEst.serie-docto       = item-doc-est.serie-docto
                   and ttItemDocEst.nro-docto         = item-doc-est.nro-docto
                   and ttItemDocEst.cod-emitente      = item-doc-est.cod-emitente
                   and ttItemDocEst.nat-operacao      = item-doc-est.nat-operacao
                   and ttItemDocEst.sequencia         = item-doc-est.sequencia no-error.
            if not avail ttItemDocEst then do:
               create ttItemDocEst.
               buffer-copy item-doc-est to ttItemDocEst.
               assign ttItemDocEst.r-rowid = rowid(item-doc-est).
            end.


            /*Rateio*/
            case desp-imp.tipo:
                /* Peso */
                when 3 then do:
                    IF de-peso-liquido = 0 THEN 
                       ASSIGN de-val-desp = 0.
                    ELSE
                       assign de-val-desp    = (item-doc-est.peso-liquido * docum-est-cex.val-desp) / de-peso-liquido.
                end.
                /* Quantidade */
                when 6 then do:
                    IF de-quantidade = 0 THEN 
                       ASSIGN de-val-desp = 0.
                    ELSE
                       assign de-val-desp    = (item-doc-est.quantidade * docum-est-cex.val-desp) / de-quantidade.
                end.
                /* Cubagem */
                when 9 then do:
                   assign de-volume-total = (item-doc-est.quantidade * (item.altura * item.largura * item.comprim)).
                   IF de-cubagem = 0 THEN 
                       ASSIGN de-val-desp = 0.
                   ELSE
                       ASSIGN de-val-desp     = (de-volume-total * docum-est-cex.val-desp) / de-cubagem.
                end.
                /* Valor */
                otherwise do:
                    IF de-preco-total = 0 THEN 
                        ASSIGN de-val-desp = 0.
                    ELSE
                        assign de-val-desp    = (item-doc-est.preco-total[1] * docum-est-cex.val-desp) / de-preco-total.
                end.
            end case.


            if de-val-desp = 0 then next.


            if not can-find(first ttItemDocEstCex 
                            where ttItemDocEstCex.serie-docto       = item-doc-est.serie-docto
                              and ttItemDocEstCex.nro-docto         = item-doc-est.nro-docto
                              and ttItemDocEstCex.cod-emitente      = item-doc-est.cod-emitente
                              and ttItemDocEstCex.nat-operacao      = item-doc-est.nat-operacao
                              and ttItemDocEstCex.sequencia         = item-doc-est.sequencia
                              and ttItemDocEstCex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                              and ttItemDocEstCex.cod-desp          = docum-est-cex.cod-desp) then do:

                
                create ttItemDocEstCex.
                assign ttItemDocEstCex.serie-docto       = item-doc-est.serie-docto
                       ttItemDocEstCex.nro-docto         = item-doc-est.nro-docto
                       ttItemDocEstCex.cod-emitente      = item-doc-est.cod-emitente
                       ttItemDocEstCex.nat-operacao      = item-doc-est.nat-operacao
                       ttItemDocEstCex.sequencia         = item-doc-est.sequencia
                       ttItemDocEstCex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                       ttItemDocEstCex.cod-desp          = docum-est-cex.cod-desp
                       ttItemDocEstCex.mo-codigo         = 0
                       ttItemDocEstCex.cotacao           = 1
                       ttItemDocEstCex.val-desp          = de-val-desp.

                assign de-tot-desp                       = de-tot-desp  + de-val-desp.

            end.

        end.

        /*Cria Rateio*/
        for each ttItemDocEst EXCLUSIVE-LOCK
           where ttItemDocEst.serie-docto          = docum-est-cex.serie-docto
             and ttItemDocEst.nro-docto            = docum-est-cex.nro-docto
             and ttItemDocEst.cod-emitente         = docum-est-cex.cod-emitente
             and ttItemDocEst.nat-operacao         = docum-est-cex.nat-operacao,
           first item no-lock
           where item.it-codigo = ttItemDocEst.it-codigo:

            for each ttItemDocEstCex EXCLUSIVE-LOCK
               where ttItemDocEstCex.serie-docto       = ttItemDocEst.serie-docto
                 and ttItemDocEstCex.nro-docto         = ttItemDocEst.nro-docto
                 and ttItemDocEstCex.cod-emitente      = ttItemDocEst.cod-emitente
                 and ttItemDocEstCex.nat-operacao      = ttItemDocEst.nat-operacao
                 and ttItemDocEstCex.sequencia         = ttItemDocEst.sequencia
                 and ttItemDocEstCex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                 and ttItemDocEstCex.cod-desp          = docum-est-cex.cod-desp:
                 run pi-rateio-item-desp.
            end.

        end.

        /* Acerto Diferenca */
        if de-tot-desp <> docum-est-cex.val-desp then do:
            find last ttItemDocEstCex
                where ttItemDocEstCex.serie-docto       = docum-est-cex.serie-docto
                  and ttItemDocEstCex.nro-docto         = docum-est-cex.nro-docto
                  and ttItemDocEstCex.cod-emitente      = docum-est-cex.cod-emitente
                  and ttItemDocEstCex.nat-operacao      = docum-est-cex.nat-operacao
                  and ttItemDocEstCex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                  and ttItemDocEstCex.cod-desp          = docum-est-cex.cod-desp no-error.
            if avail ttItemDocEstCex then do:
                assign ttItemDocEstCex.val-desp = ttItemDocEstCex.val-desp + (docum-est-cex.val-desp - de-tot-desp).

                find last ttItemDocEst
                    where ttItemDocEst.serie-docto       = ttItemDocEstCex.serie-docto
                      and ttItemDocEst.nro-docto         = ttItemDocEstCex.nro-docto
                      and ttItemDocEst.cod-emitente      = ttItemDocEstCex.cod-emitente
                      and ttItemDocEst.nat-operacao      = ttItemDocEstCex.nat-operacao
                      and ttItemDocEst.sequencia         = ttItemDocEstCex.sequencia  no-error.
                if avail ttItemDocEst then do:
                   assign ttItemDocEst.despesas[1]    = ttItemDocEst.despesas[1]  + (docum-est-cex.val-desp - de-tot-desp).
                   if desp-imp.inc-val-frete then
                      assign ttItemDocEst.valor-frete = ttItemDocEst.valor-frete  + (docum-est-cex.val-desp - trunc(de-tot-desp,2))
                             de-tot-frete  = de-tot-frete    + (docum-est-cex.val-desp - trunc(de-tot-desp,2)).
                   if desp-imp.inc-val-seguro THEN 
                      assign de-tot-seguro = de-tot-seguro  + (docum-est-cex.val-desp - trunc(de-tot-desp,2)).
                   if desp-imp.inc-val-outras-desp then
                      assign de-tot-outras = de-tot-outras  + (docum-est-cex.val-desp - trunc(de-tot-desp,2)).
                   if desp-imp.inc-val-embal then
                      assign de-tot-embal = de-tot-embal  + (docum-est-cex.val-desp - trunc(de-tot-desp,2)).
                end.
            end.
        end.

    end.

    run pi-calcula-impostos.

    if valid-handle(h-cd4338) then
        delete procedure h-cd4338.

    if valid-handle(h-cd4337) then
        delete procedure h-cd4337.

end procedure.

procedure pi-rateio-item-desp:

    if desp-imp.inc-val-frete       or
       desp-imp.inc-val-seguro      or
       desp-imp.inc-val-embal       or
       desp-imp.inc-val-outras-desp then do:

        assign ttItemDocEst.despesas[1] = ttItemDocEst.despesas[1] + ttItemDocEstCex.val-desp.

        if desp-imp.inc-val-frete then
           assign ttItemDocEst.valor-frete = ttItemDocEst.valor-frete + ttItemDocEstCex.val-desp
                  de-frete                 = ttItemDocEstCex.val-desp
                  de-tot-frete             = de-tot-frete  + de-frete.
        if desp-imp.inc-val-seguro then
           assign de-seguro     = ttItemDocEstCex.val-desp
                  de-tot-seguro = de-tot-seguro + de-seguro.

        if desp-imp.inc-val-embal then
           assign de-embal      = ttItemDocEstCex.val-desp
                  de-tot-embal  = de-tot-embal  + de-embal.

        if desp-imp.inc-val-outras-desp then
           assign de-outras     = ttItemDocEstCex.val-desp
                  de-tot-outras = de-tot-outras + de-outras.

    end.


    if desp-imp.inc-base-ipi then
       assign de-base-ipi    = de-base-ipi + ttItemDocEstCex.val-desp.

    if desp-imp.inc-base-icms then do:
        find first tt-it-base-icm
            where  tt-it-base-icm.nro-docto = ttItemDocEst.nro-docto
              and  tt-it-base-icm.it-codigo = ttItemDocEst.it-codigo
              and  tt-it-base-icm.sequencia = ttItemDocEst.sequencia no-error.
        if not avail tt-it-base-icm then  do:
            create tt-it-base-icm.
            assign tt-it-base-icm.nro-docto = ttItemDocEst.nro-docto
                   tt-it-base-icm.it-codigo = ttItemDocEst.it-codigo
                   tt-it-base-icm.sequencia = ttItemDocEst.sequencia
                   tt-it-base-icm.base-icm  = ttItemDocEstCex.val-desp.
        end.
        else
            assign tt-it-base-icm.base-icm  = ttItemDocEstCex.val-desp.
    end.
end procedure.         

procedure pi-calcula-pis-cofins-imp:


    /******************************************************
    * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
    ******************************************************/
    DEFINE VARIABLE de-va-pis                  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Valor Aduaneiro PIS        */
    DEFINE VARIABLE de-da-pis                  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Despesas Aduaneiras PIS    */
    DEFINE VARIABLE de-va-cofins               AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Valor Aduaneiro COFINS     */
    DEFINE VARIABLE de-da-cofins               AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Despesas Aduaneiras COFINS */
    DEFINE VARIABLE de-red-pis                 AS DECIMAL FORMAT ">>9.99"                 NO-UNDO. /* Valor Reducao PIS          */
    DEFINE VARIABLE de-red-cofins              AS DECIMAL FORMAT ">>9.99"                 NO-UNDO. /* Valor Reducao COFINS       */
    DEFINE VARIABLE de-val-reduc-pis-normal    AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-val-reduc-cofins-normal AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE l-ordens-embarque          AS LOGICAL INITIAL NO                      NO-UNDO.


    if avail param-global and
       param-global.modulo-07 then do:
        /** Integracao Modulo de Importacao - Tratamento PIS-COFINS **/
        /* busca aliquota e tributacao pis */
        RUN pi-tributa-aliquota-pis-importacao IN h-cd4337 (BUFFER natur-oper,
                                                            BUFFER ITEM,
                                                            INPUT ttDocumEst.cod-estabel,
                                                            INPUT ttDocumEst.dt-emissao,
                                                            INPUT no /*YES*/,
                                                            INPUT ttDocumEst.embarque,
                                                            INPUT 0 /*ttItemDocEst.numero-ordem*/,
                                                            INPUT 0 /*ttItemDocEst.parcela*/,
                                                            OUTPUT de-trib-pis,
                                                            OUTPUT de-aliquota-pis,
                                                            OUTPUT de-val-unit-pis,
                                                            OUTPUT de-val-vol-pis,
                                                            OUTPUT de-red-pis).


        /* busca aliquota e tributacao cofins */
        RUN pi-tributa-aliquota-cofins-importacao IN h-cd4337 (BUFFER natur-oper,
                                                               BUFFER ITEM,
                                                               INPUT ttDocumEst.cod-estabel,
                                                               INPUT ttDocumEst.dt-emissao,
                                                               INPUT no /*YES*/,
                                                               INPUT ttDocumEst.embarque,
                                                               INPUT 0 /*ttItemDocEst.numero-ordem*/,
                                                               INPUT 0 /*ttItemDocEst.parcela*/,
                                                               OUTPUT de-trib-cofins,
                                                               OUTPUT de-aliquota-cofins,
                                                               OUTPUT de-val-unit-cofins,
                                                               OUTPUT de-val-vol-cofins,
                                                               OUTPUT de-red-cofins).

        /*Maylon*/
        /*Melhorias de Ecporta‡Æo - Busca imposto de importa‡Æo do item*/
        if docum-est.cod-observa = 3 and emitente.natureza = 3 and avail item and avail natur-oper and param-global.modulo-ex then
            assign i-trib-ii  = int(substring(item.char-2,20,2))
                   de-aliq-ii = dec(substring(item.char-2,22,6)).
        else
            RUN pi-tributa-aliquota-ii IN h-cd4337 (BUFFER item-doc-est,
                                                    BUFFER natur-oper,
                                                    BUFFER ITEM,
                                                    INPUT ttDocumEst.cod-estabel,
                                                    INPUT ttDocumEst.embarque,
                                                    OUTPUT i-trib-ii,
                                                    OUTPUT de-aliq-ii).

        /*Maylon*/
/*         find first tt-base-ii                                              */
/*              where tt-base-ii.sequencia = ttItemDocEst.sequencia no-error. */
/*         if avail tt-base-ii then                                           */
/*             run pi-geraDespII (input i-trib-ii,                            */
/*                                input de-aliq-ii,                           */
/*                                input tt-base-ii.base-ii,                   */
/*                                input item-doc-est.it-codigo).              */

        ASSIGN de-aliq-icms-imp = ttItemDocEst.aliquota-icm
               de-aliq-ipi-imp  = ttItemDocEst.aliquota-ipi.


        /*
        ** Conforme Engenharia: FO_1032539_IPI_BEBIDAS_CALCULO_PIS_COFINS
        ** Tratamento realizado para recalcular a aliquota do IPI para as
        ** situacoes onde o item possui IPI bebidas, para que seja incluso
        ** no calculo do PIS e do COFINS
        */
        IF AVAIL ITEM THEN DO:
            IF ITEM.valor-ipi-beb > 0 THEN DO:
                IF ITEM.cd-trib-ipi = 1 OR   /* Tributado */
                   ITEM.cd-trib-ipi = 4 THEN /* Reduzido */
                    ASSIGN de-base-ipi-aux = ttItemDocEst.base-ipi[1].
                ELSE
                    IF ITEM.cd-trib-ipi = 3 THEN /* Outros */
                        ASSIGN de-base-ipi-aux = ttItemDocEst.ipi-outras[1].

               IF de-base-ipi-aux > 0 AND /* Tratamento realizado para tributacao Isento */
                  ttItemDocEst.valor-ipi[1] > 0 THEN
                    ASSIGN de-aliq-ipi-imp = (ttItemDocEst.valor-ipi[1] / de-base-ipi-aux) * 100.
            END.
        END.

        /** tratamento do parametro do im0100, aliquota 0 icms diferido **/
        IF ttItemDocEst.aliquota-icm = 0 THEN DO:
            RUN pi-retorna-icms-ordens-embarque IN h-cd4337 (INPUT ttDocumEst.cod-estabel,
                                                             INPUT ttDocumEst.embarque,
                                                             BUFFER item-doc-est,
                                                             OUTPUT l-ordens-embarque,
                                                             OUTPUT de-aliq-icms-imp).
            IF NOT l-ordens-embarque THEN DO:
                run cdp/cd4301.p ( (if  AVAIL b-emit-estab then
                                            b-emit-estab.contrib-icms
                                    else
                                        yes),
                                   (if  AVAIL b-emit-estab then
                                        b-emit-estab.natureza
                                    else 2 /*"J"*/),
                                    estabelec.estado /*estabelec.estado*/,
                                    estabelec.pais,
                                    estabelec.estado,
                                    ttItemDocEst.it-codigo,
                                    natur-oper.aliquota-icm,
                                    OUTPUT de-aliq-icms-imp ).
            END.
        END.

        /******************************************************
        * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
        ******************************************************/
        IF  NOT AVAIL param-global THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.

        IF  CONNECTED("mgcex":U)
        AND ttItemDocEst.aliquota-ipi = 0 THEN
            RUN pi-busca-aliquota-IPI IN h-cd4337 (BUFFER item-doc-est,
                                                   BUFFER natur-oper,
                                                   BUFFER item,
                                                   INPUT  ttDocumEst.cod-estabel,
                                                   INPUT  ttDocumEst.embarque,
                                                   OUTPUT de-aliq-ipi-imp).

        /** Quando a tributacao for isenta, a aliquota para a formula e 0 **/
        IF ttItemDocEst.cd-trib-icm = 2 THEN /* isento */
            ASSIGN de-aliq-icms-imp = 0.
        IF ttItemDocEst.cd-trib-ipi = 2 THEN /* isento */
            ASSIGN de-aliq-ipi-imp  = 0.

        /** tratamento icms/ipi reduzido **/
        IF (ttItemDocEst.cd-trib-icm = 4 OR    /* Reduzido */
            ttItemDocEst.cd-trib-icm = 3)       /* Outros */ THEN
            ASSIGN de-aliq-icms-imp = de-aliq-icms-imp - (de-aliq-icms-imp * (natur-oper.perc-red-icm / 100)).

        IF ttItemDocEst.cd-trib-ipi = 4 THEN /* Reduzido */
            ASSIGN de-aliq-ipi-imp  = de-aliq-ipi-imp  - (de-aliq-ipi-imp  * (natur-oper.perc-red-ipi / 100)).

        RUN pi-calcula-base-pis IN h-cd4337 (INPUT ttDocumEst.cod-estabel,
                                             BUFFER item-doc-est,
                                             INPUT de-aliq-ii,
                                             INPUT de-aliq-ipi-imp,
                                             INPUT de-aliquota-pis,
                                             INPUT de-aliquota-cofins,
                                             INPUT de-aliq-icms-imp,
                                             OUTPUT de-valor-pis,
                                             OUTPUT de-va-pis,
                                             OUTPUT de-da-pis,
                                             OUTPUT TABLE tt-erro-aux).

        FOR EACH tt-erro-aux EXCLUSIVE-LOCK:
            RUN pi-gera-erro (INPUT tt-erro-aux.cd-erro, INPUT tt-erro-aux.mensagem, INPUT "").
        END.

        RUN pi-calcula-base-cofins IN h-cd4337 (INPUT ttDocumEst.cod-estabel,
                                                BUFFER item-doc-est,
                                                INPUT de-aliq-ii,
                                                INPUT de-aliq-ipi-imp,
                                                INPUT de-aliquota-pis,
                                                INPUT de-aliquota-cofins,
                                                INPUT de-aliq-icms-imp,
                                                OUTPUT de-valor-cofins,
                                                OUTPUT de-va-cofins,
                                                OUTPUT de-da-cofins,
                                                OUTPUT TABLE tt-erro-aux).
        FOR EACH tt-erro-aux EXCLUSIVE-LOCK:
            RUN pi-gera-erro (INPUT tt-erro-aux.cd-erro, INPUT tt-erro-aux.mensagem, INPUT "").
        END.

        
        IF de-trib-pis = 1 OR       /* Tributado */
           de-trib-pis = 3 THEN DO: /* Outros */
            ASSIGN de-base-pis  = ROUND((de-valor-pis * 100) / de-aliquota-pis,2).
            IF de-val-unit-pis <> 0 THEN
                ASSIGN de-valor-pis = round(de-val-unit-pis * ttItemDocEst.quantidade,2)
                       de-base-pis  = 0.
            IF de-val-vol-pis <> 0 THEN DO:
                ASSIGN de-volume-item = (ITEM.altura * ITEM.largura * ITEM.comprim) * ttItemDocEst.quantidade.
                ASSIGN de-valor-pis = round(de-val-vol-pis * de-volume-item,2)
                       de-base-pis  = 0.
            END.
            ASSIGN de-valor-pis = ROUND(de-valor-pis,2).
        END.
        ELSE
            ASSIGN de-valor-pis = 0
                   de-base-pis  = 0.

        IF de-trib-cofins = 1 OR       /* Tributado */
           de-trib-cofins = 3 THEN DO: /* Outros */
            ASSIGN de-base-cofins  = ROUND((de-valor-cofins * 100) / de-aliquota-cofins,2).
            IF de-val-unit-cofins <> 0 THEN
                ASSIGN de-valor-cofins = round(de-val-unit-cofins * ttItemDocEst.quantidade,2)
                       de-base-cofins  = 0.
            IF de-val-vol-cofins <> 0 THEN DO:
                ASSIGN de-volume-item = (ITEM.altura * ITEM.largura * ITEM.comprim) * ttItemDocEst.quantidade.
                ASSIGN de-valor-cofins = round(de-val-vol-cofins * de-volume-item,2)
                       de-base-cofins  = 0.
            END.
            ASSIGN de-valor-cofins = ROUND(de-valor-cofins,2).
        END.
        ELSE
           ASSIGN de-valor-cofins = 0
                  de-base-cofins = 0.

           
        ASSIGN ttItemDocEst.despesas[1] = (IF ttItemDocEst.despesas[1] = ? THEN 0 ELSE ttItemDocEst.despesas[1]) + de-valor-pis + de-valor-cofins


               de-tot-outras = de-tot-outras + de-valor-pis + de-valor-cofins
               de-tot-despesa           = de-tot-despesa + de-valor-pis + de-valor-cofins
               de-base-icm              = de-valor-pis + de-valor-cofins.


        /******************************************************
        * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
        * Gravacao Variaveis Utilizadas no Calculo PIS COFINS *
        ******************************************************/
        IF  NOT AVAIL param-global THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.

        ASSIGN ttItemDocEst.val-aduana-pis             = de-va-pis
               ttItemDocEst.val-despes-aduana-pis      = de-da-pis
               ttItemDocEst.val-aliq-impto-import      = de-aliq-ii
               ttItemDocEst.val-aliq-ext-ipi           = de-aliq-ipi-imp
               ttItemDocEst.val-aliq-ext-pis           = de-aliquota-pis
               ttItemDocEst.val-aliq-ext-cofins        = de-aliquota-cofins
               ttItemDocEst.val-aliq-ext-icms          = de-aliq-icms-imp
               ttItemDocEst.val-unit-pis-import        = de-val-unit-pis
               ttItemDocEst.val-unit-vol-pis-import    = de-val-vol-pis
               ttItemDocEst.val-reduc-pis-import       = de-red-pis
               ttItemDocEst.val-aduana-cofins          = de-va-cofins
               ttItemDocEst.val-despes-aduana-cofins   = de-da-cofins
               ttItemDocEst.val-unit-cofins-import     = de-val-unit-cofins
               ttItemDocEst.val-unit-vol-cofins-import = de-val-vol-cofins
               ttItemDocEst.val-reduc-cofins-import    = de-red-cofins.

    end.
    else do:
            /** Tratamento PIS-COFINS - Mercado Nacional - Modulo de Importacao nao Implantado **/
            /* Busca aliquota e tributacao de PIS */
            run pi-tributa-aliquota-pis in h-cd4337 ( buffer estabelec,
                                                      buffer item,
                                                      buffer emitente,
                                                      buffer natur-oper,
                                                      input  ttDocumEst.dt-emissao,
                                                      output de-trib-pis,
                                                      output de-aliquota-pis,
                                                      output de-val-unit-pis,
                                                      output de-val-reduc-pis-normal).

            /* Busca aliquota e tributacao de PIS */
            run pi-tributa-aliquota-cofins in h-cd4337 ( buffer estabelec,
                                                         buffer item,
                                                         buffer emitente,
                                                         buffer natur-oper,
                                                         input  ttDocumEst.dt-emissao,
                                                         output de-trib-cofins,
                                                         output de-aliquota-cofins,
                                                         output de-val-unit-cofins,
                                                         output de-val-reduc-cofins-normal).

            run pi-calcula-pis in h-cd4338 (input  de-trib-pis,
                                            input  de-aliquota-pis,
                                            input  de-val-unit-pis,
                                            input  de-val-reduc-pis-normal,
                                            input  ttItemDocEst.cd-trib-ipi,
                                            input  ttItemDocEst.valor-ipi[1],
                                            input  ttItemDocEst.preco-total[1],
                                            input  ttItemDocEst.despesas[1],
                                            input  ttItemDocEst.desconto[1],
                                            input  ttItemDocEst.quantidade,
                                            buffer natur-oper,
                                            output de-base-pis,
                                            output de-valor-pis).

            run pi-calcula-cofins in h-cd4338 (input  de-trib-cofins,
                                               input  de-aliquota-cofins,
                                               input  de-val-unit-cofins,
                                               input  de-val-reduc-cofins-normal,
                                               input  ttItemDocEst.cd-trib-ipi,
                                               input  ttItemDocEst.valor-ipi[1],
                                               input  ttItemDocEst.preco-total[1],
                                               input  ttItemDocEst.despesas[1],
                                               input  ttItemDocEst.desconto[1],
                                               input  ttItemDocEst.quantidade,
                                               buffer natur-oper,
                                               OUTPUT de-base-cofins,
                                               OUTPUT de-valor-cofins).
    end.

    return "OK":U.

end procedure.


PROCEDURE pi-calcula-icms-importacao:
    DEF VAR i-seq-aux          AS INTEGER INITIAL 0 NO-UNDO.
    DEF VAR de-aliq-icm        AS DECIMAL           NO-UNDO.

    
    /* Calcula a base e o valor do ICMS */
    run rep/re1906.p ( tt-docto.seq-tt-docto,
                       yes,                /* ICMS */
                       no,                 /* Subst. Tributaria */
                       no,                 /* ICMS Complementar */
                       input        table tt-docto,
                       input        table tt-it-docto,
                       input-OUTPUT table tt-it-imposto).

    find first tt-docto no-error.

    FOR EACH tt-it-docto EXCLUSIVE-LOCK:
        find first tt-it-imposto
             WHERE tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto NO-ERROR.
        if avail tt-it-imposto then do:
            find first ttItemDocEst
                 WHERE ttItemDocEst.cod-emitente = tt-it-docto.cod-emitente
                   and ttItemDocEst.nro-docto    = tt-it-docto.nr-nota
                   and ttItemDocEst.serie-docto  = tt-it-docto.serie
                   and ttItemDocEst.nat-operacao = tt-it-docto.nat-operacao
                   and ttItemDocEst.sequencia    = tt-it-docto.nr-sequencia  NO-ERROR.
            if avail ttItemDocEst then do:
                ASSIGN ttItemDocEst.base-icm[1]    = tt-it-imposto.vl-bicms-it
                       ttItemDocEst.valor-icm[1]   = tt-it-imposto.vl-icms-it
                       ttItemDocEst.icm-ntrib[1]   = tt-it-imposto.vl-icmsnt-it
                       ttItemDocEst.icm-outras[1]  = tt-it-imposto.vl-icmsou-it
                       de-total-desp               = de-total-desp + ttItemDocEst.despesas[1] + tt-it-imposto.vl-icms-it + de-valor-ii
                       ttItemDocEst.despesas[1]    = ttItemDocEst.despesas[1] + tt-it-imposto.vl-icms-it + de-valor-ii
                       de-tot-icms                 = de-tot-icms + tt-it-imposto.vl-icms-it
                       de-vl-icm                   = de-vl-icm   + tt-it-imposto.vl-icms-it
                       de-tot-base-icm                 = de-tot-base-icm
                                                   +  (ttItemDocEst.base-icm[1]
                                                   *  int(can-do("1,4,5", STRING(ttItemDocEst.cd-trib-icm))))
                                                   +  (ttItemDocEst.icm-outras[1]
                                                   *  int(ttItemDocEst.cd-trib-icm = 3)).
            end.
        end.
    END.
    
    /*Repassa os totais para docum-est*/
    find first ttDocumEst
         WHERE ttDocumEst.cod-emitente = tt-docto.cod-emitente
           AND ttDocumEst.nro-docto    = tt-docto.nr-nota
           AND ttDocumEst.serie-docto  = tt-docto.serie
           AND ttDocumEst.nat-operacao = tt-docto.nat-operacao  NO-ERROR.
    if avail ttDocumEst then
        ASSIGN ttDocumEst.valor-outras   = de-tot-outras + de-tot-icms + de-valor-ii
               ttDocumEst.valor-seguro   = de-tot-seguro
               ttDocumEst.valor-frete    = de-tot-frete
               ttDocumEst.valor-embal    = de-tot-embal
               ttDocumEst.despesa-nota   = de-total-desp
               ttDocumEst.base-ipi       = IF de-tot-base-ipi = ? THEN 0 ELSE de-tot-base-ipi
               ttDocumEst.ipi-deb-cre    = de-tot-vl-ipi
               ttDocumEst.base-icm       = de-tot-base-icm
               ttDocumEst.icm-deb-cre    = de-vl-icm
               ttDocumEst.tot-valor      = ttDocumEst.valor-mercad + de-tot-vl-ipi + de-total-desp.

END PROCEDURE.

procedure pi-gera-erro.
    def input param p-cod-msg as int  no-undo.
    def input param p-des-msg as char no-undo.
    def input param p-c-char  as char no-undo.

    assign i-seq-erro = i-seq-erro + 1.

    run utp/ut-msgs.p (input "msg",input p-cod-msg,input p-des-msg).

    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = p-cod-msg
           tt-bo-erro.mensagem = return-value + p-c-char.

end procedure.

procedure pi-calcula-impostos:
    DEFINE VARIABLE de-base-ii AS DECIMAL     NO-UNDO.

    if not valid-handle(h-cd4337) then
        run cdp/cd4337.p   persistent set h-cd4337.

    if not valid-handle(h-cd4338) then
        run cdp/cd4338.p   persistent set h-cd4338.

    for each item-doc-est exclusive-lock
       where item-doc-est.serie-docto  = docum-est.serie-docto
         and item-doc-est.nro-docto    = docum-est.nro-docto
         and item-doc-est.cod-emitente = docum-est.cod-emitente
         and item-doc-est.nat-operacao = docum-est.nat-operacao,
       first item fields(peso-bruto altura largura comprim cd-trib-icm cd-trib-ipi) no-lock
       where item.it-codigo = item-doc-est.it-codigo:
        ASSIGN item-doc-est.despesas[1] = 0.

        /*Maylon*/
        /*Melhorias de Ecporta‡Æo - tratamento tributa‡Æo apenas p/ devolu‡Æo de cliente e cliente estrangeiro*/
        if docum-est.cod-observa = 3 and emitente.natureza = 3 and avail item and avail natur-oper and param-global.modulo-ex then do:

            /*Retorna tributa‡Æo ICMS*/
            run cdp/cd4302.p (input item.cd-trib-icm,
                              input natur-oper.cd-trib-icm,
                              output i-trib-icm).

            /*Retorna tributa‡Æo IPI*/
            run cdp/cd4303.p (input item.cd-trib-ipi,
                              input natur-oper.cd-trib-ipi,
                              output i-trib-ipi).

            assign item-doc-est.cd-trib-icm  = i-trib-icm
                   item-doc-est.cd-trib-ipi  = i-trib-ipi.

        end.
        /*Maylon*/

        find first ttItemDocEst
             where ttItemDocEst.serie-docto       = item-doc-est.serie-docto
               and ttItemDocEst.nro-docto         = item-doc-est.nro-docto
               and ttItemDocEst.cod-emitente      = item-doc-est.cod-emitente
               and ttItemDocEst.nat-operacao      = item-doc-est.nat-operacao
               and ttItemDocEst.sequencia         = item-doc-est.sequencia no-error.
        if not avail ttItemDocEst then do:
           create ttItemDocEst.
           buffer-copy item-doc-est to ttItemDocEst.
           assign ttItemDocEst.r-rowid = rowid(item-doc-est).
        end.
    end.

    for each ttItemDocEst EXCLUSIVE-LOCK
       where ttItemDocEst.serie-docto          = docum-est.serie-docto
         and ttItemDocEst.nro-docto            = docum-est.nro-docto
         and ttItemDocEst.cod-emitente         = docum-est.cod-emitente
         and ttItemDocEst.nat-operacao         = docum-est.nat-operacao,
       first item no-lock
       where item.it-codigo = ttItemDocEst.it-codigo:

        find item-doc-est
             where rowid(item-doc-est) = ttItemDocEst.r-rowid
             exclusive-lock no-error.

        run pi-calcula-pis-cofins-imp.

        /** Tratamento para nao gravar ? **/
        IF de-trib-pis = ? THEN
            ASSIGN de-trib-pis = 0.
        IF de-trib-cofins = ? THEN
            ASSIGN de-trib-cofins = 0.
        IF de-aliquota-pis = ? THEN
            ASSIGN de-aliquota-pis = 0.
        IF de-aliquota-cofins = ? THEN
            ASSIGN de-aliquota-cofins = 0.
        IF de-base-pis = ? THEN
            ASSIGN de-base-pis = 0.
        IF de-base-cofins = ? THEN
            ASSIGN de-base-cofins = 0.
        IF de-valor-pis = ? THEN
            ASSIGN de-valor-pis = 0.
        IF de-valor-cofins = ? THEN
            ASSIGN de-valor-cofins = 0.

        /* Gravacao valores PIS-COFINS na Nota Fiscal */
        ASSIGN ttItemDocEst.idi-tributac-pis     = de-trib-pis
               ttItemDocEst.val-aliq-pis         = de-aliquota-pis
               ttItemDocEst.base-pis             = de-base-pis
               ttItemDocEst.valor-pis            = de-valor-pis
               ttItemDocEst.idi-tributac-cofins  = de-trib-cofins
               ttItemDocEst.val-aliq-cofins      = de-aliquota-cofins
               ttItemDocEst.val-base-calc-cofins = de-base-cofins
               ttItemDocEst.val-cofins           = de-valor-cofins.

        /*Maylon*/
        /*C lculo imposto de importa‡Æo*/
        find first tt-base-ii
             where tt-base-ii.sequencia = item-doc-est.sequencia no-error.
        if avail tt-base-ii then
            assign de-base-ii = tt-base-ii.base-ii + item-doc-est.preco-total[1].
        else
            assign de-base-ii = item-doc-est.preco-total[1].

        run pi-geraDespII (input i-trib-ii,
                           input de-aliq-ii,
                           input de-base-ii,
                           input item-doc-est.it-codigo).

        run pi-cria-tt-docto.
        run pi-gera-tt-it-docto.
        run pi-gera-tt-it-imposto.

        find last tt-it-docto   no-error.
        find last tt-it-imposto no-error.
        find last tt-docto      no-error.

         /* Calculo da base e o valor do IPI */
        run cdp/cd4306.p ( input tt-it-docto.seq-tt-it-docto,
                           input 1,                  /* Natureza Entrada */
                           input natur-oper.char-2,  /* Frete Base IPI   */
                           input no,                 /* Nota Comercio    */
                           input        table tt-docto,
                           input        table tt-it-docto,
                           input-output table tt-it-imposto).

        find tt-it-imposto 
          &if defined(bf-mat-comex) &then
            where tt-it-imposto.r-tt-it-docto   = &IF {&ROWID_READY} = YES &THEN 
                                                        ROWID(tt-it-docto)
                                                  &ELSE 
                                                        recid(tt-it-docto)
                                                  &ENDIF 
                                                  no-error.
          &else
            where tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto no-error.
          &endif


        assign ttItemDocEst.base-ipi    = tt-it-imposto.vl-bipi-it
               ttItemDocEst.valor-ipi   = tt-it-imposto.vl-ipi-it
               ttItemDocEst.ipi-ntrib   = tt-it-imposto.vl-ipint-it
               ttItemDocEst.ipi-outras  = tt-it-imposto.vl-ipiou-it
               de-tot-vl-ipi            = de-tot-vl-ipi   + tt-it-imposto.vl-ipi-it
               de-tot-base-ipi    =  de-tot-base-ipi                
                                      +  (ttItemDocEst.base-ipi[1]
                                      *  int(can-do("1,4", STRING(ttItemDocEst.cd-trib-ipi))))
                                      +  (ttItemDocEst.ipi-outras[1]
                                      *  int( ttItemDocEst.cd-trib-ipi = 3
                                         or ( ttItemDocEst.cd-trib-ipi = 1
                                         and ttItemDocEst.aliquota-ipi = 0))).

        run pi-calcula-icms-importacao.

    end.

    if valid-handle(h-cd4337) then
        delete procedure h-cd4337.

    if valid-handle(h-cd4338) then
        delete procedure h-cd4338.
end procedure.

/*Maylon*/
/*Calcula imposto de importa‡Æo*/
procedure pi-geraDespII:

    define input parameter i-trib-ii          as integer no-undo.
    define input parameter de-aliq-ii         as DECIMAL FORMAT ">>9.9999".
    define input parameter de-base-ii         as decimal no-undo.
    define input parameter c-it-codigo       like item.it-codigo.

    def var i-cod-cond-pag  like cond-pagto.cod-cond-pag   no-undo.
    def var l-suspensao-ii as logical no-undo.

    def buffer b-emitente for emitente.
    def buffer b-desp-imp for desp-imp.

    {cxbo/bocx250.i50} /* include tratamento atributo livre */

    if i-trib-ii = 2 or de-aliq-ii = 0  then leave.

    assign de-valor-ii = 0.

    IF  NOT AVAIL param-imp THEN
        FIND param-imp
        WHERE param-imp.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.

    if  avail param-imp then do:
        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"} /* Include que alimenta o i-desp-ii-i50 e o i-emitente-ii-i50 com o c¢digo da despesa de II e seu emitente*/
    END.

    find b-emitente
        where b-emitente.cod-emitente = i-emitente-ii-i50 no-lock no-error.

    if (not avail b-emitente) or (avail b-emitente and b-emitente.cod-emitente = 0) then do:
        {utp/ut-liter.i Fornecedor_Imposto_Importacao * L}
        run utp/ut-msgs.p (input "show":U,
                           input 2,
                           input return-value + "~~" + string(i-emitente-ii-i50)).

        leave.
    end.

    assign i-cod-cond-pag  = b-emitente.cod-cond-pag
           l-suspensao-ii = no.

    /******************************************************
    * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
    ******************************************************/
    &IF DEFINED(bf-mat-comex) &THEN
          IF  AVAIL natur-oper THEN DO:
              &IF  "{&bf_mat_versao_ems}" >= "2.06" &THEN
                   ASSIGN l-suspensao-ii = natur-oper.log-suspens-impto-import.
              &ELSE
                   IF  SUBSTRING(natur-oper.char-1,102,001) = "1":U THEN
                       ASSIGN l-suspensao-ii = YES.
                   ELSE
                       ASSIGN l-suspensao-ii = NO.
              &ENDIF
          END.

          IF  NOT l-suspensao-ii  THEN DO:
              &IF  "{&bf_mat_versao_ems}" >= "2.06" &THEN
                   FIND FIRST item-mat
                        WHERE item-mat.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

                   IF  AVAIL item-mat THEN DO:
                       IF  NOT l-suspensao-ii THEN
                           ASSIGN l-suspensao-ii = item-mat.log-suspens-impto-import.
                   END.
              &ELSE
                   IF  NOT l-suspensao-ii
                   AND SUBSTRING(item.char-1,229,001) = "1":U THEN
                       ASSIGN l-suspensao-ii = YES.
              &ENDIF
          END.
    &ENDIF

    if l-suspensao-ii then leave.

    assign de-valor-ii = de-base-ii * (de-aliq-ii / 100).

    /*Verifica se o imposto de importa‡Æo incide na base do IPI e ICMS*/
    find first b-desp-imp
         where b-desp-imp.cod-desp = i-desp-ii-i50 no-lock no-error.
   if avail b-desp-imp then do:

       if  b-desp-imp.inc-base-ipi then
           assign de-base-ipi = de-base-ipi + de-valor-ii.

       if b-desp-imp.inc-base-icm then do:
            find first tt-it-base-icm 
                where  tt-it-base-icm.nro-docto = ttItemDocEst.nro-docto
                  and  tt-it-base-icm.it-codigo = ttItemDocEst.it-codigo
                  and  tt-it-base-icm.sequencia = ttItemDocEst.sequencia no-error.
            if not avail tt-it-base-icm then  do:
                create tt-it-base-icm.
                assign tt-it-base-icm.nro-docto = ttItemDocEst.nro-docto
                       tt-it-base-icm.it-codigo = ttItemDocEst.it-codigo
                       tt-it-base-icm.sequencia = ttItemDocEst.sequencia
                       tt-it-base-icm.base-icm  = de-valor-ii.
            end.
            else
                assign tt-it-base-icm.base-icm  = tt-it-base-icm.base-icm + de-valor-ii.
       end.

    end.

    find FIRST docum-est-cex
        where docum-est-cex.serie-docto       = item-doc-est.serie-docto
        &if defined(bf-mat-comex) &then
          and docum-est-cex.nro-docto         = string(item-doc-est.nro-docto)
        &else
          and docum-est-cex.nro-docto         = item-doc-est.nro-docto
        &endif
          and docum-est-cex.cod-emitente      = item-doc-est.cod-emitente
          and docum-est-cex.nat-operacao      = item-doc-est.nat-operacao
          and docum-est-cex.cod-emitente-desp = i-emitente-ii-i50
          and docum-est-cex.cod-desp          = i-desp-ii-i50  exclusive-lock no-error.
    if not avail docum-est-cex then do:
        create docum-est-cex.
        assign docum-est-cex.serie-docto       = item-doc-est.serie-docto
             &if defined(bf-mat-comex) &then
               docum-est-cex.nro-docto         = string(item-doc-est.nro-docto)
             &else
               docum-est-cex.nro-docto         = item-doc-est.nro-docto
             &endif
               docum-est-cex.cod-emitente      = item-doc-est.cod-emitente
               docum-est-cex.nat-operacao      = item-doc-est.nat-operacao
               docum-est-cex.cod-emitente-desp = i-emitente-ii-i50
               docum-est-cex.cod-desp          = i-desp-ii-i50
               docum-est-cex.mo-codigo         = 0
               docum-est-cex.cod-cond-pag      = i-cod-cond-pag
               docum-est-cex.cotacao           = 1.
    end.
        assign docum-est-cex.val-desp          = docum-est-cex.val-desp + de-valor-ii.


    find first item-doc-est-cex
         where item-doc-est-cex.serie-docto = item-doc-est.serie-docto
         &if defined(bf-mat-comex) &then
          and item-doc-est-cex.nro-docto         = string(item-doc-est.nro-docto)
        &else
          and item-doc-est-cex.nro-docto         = item-doc-est.nro-docto
        &endif
        and   item-doc-est-cex.cod-emitente      = item-doc-est.cod-emitente
        and   item-doc-est-cex.cod-desp          = i-desp-ii-i50 exclusive-lock no-error.
    if not avail  item-doc-est-cex then do:
        create item-doc-est-cex.
        assign item-doc-est-cex.serie-docto       = item-doc-est.serie-docto
             &if defined(bf-mat-comex) &then
               item-doc-est-cex.nro-docto         = string(item-doc-est.nro-docto)
             &else
               item-doc-est-cex.nro-docto         = item-doc-est.nro-docto
             &endif
               item-doc-est-cex.cod-emitente      = item-doc-est.cod-emitente
               item-doc-est-cex.nat-operacao      = item-doc-est.nat-operacao
               item-doc-est-cex.sequencia         = item-doc-est.sequencia
               item-doc-est-cex.cod-emitente-desp = i-emitente-ii-i50
               item-doc-est-cex.cod-desp          = i-desp-ii-i50
               item-doc-est-cex.mo-codigo         = 0
               item-doc-est-cex.cotacao           = 1
               item-doc-est-cex.val-desp          = item-doc-est-cex.val-desp + de-valor-ii.
    end.
    else
       assign item-doc-est-cex.val-desp          = item-doc-est-cex.val-desp + de-valor-ii.

    RETURN "OK":U.
end procedure.

/*Maylon*/
procedure pi-cria-tt-docto:

    DEFINE VARIABLE i-portador-emit   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-modalidade-emit AS INTEGER     NO-UNDO.

    empty temp-table tt-docto.
    empty temp-table tt-it-docto.
    empty temp-table tt-it-imposto.

    run pi-busca-portador-modalidade (buffer emitente,
                                      output i-portador-emit,
                                      output i-modalidade-emit).

    create tt-docto.
    assign tt-docto.seq-tt-docto    = 1
           tt-docto.dt-trans        = docum-est.dt-trans
           tt-docto.ind-tip-nota    = 8
           tt-docto.cod-portador    = i-portador-emit
           tt-docto.modalidade      = i-modalidade-emit
           tt-docto.cod-estabel     = docum-est.cod-estabel
           tt-docto.serie           = docum-est.serie-docto
           tt-docto.nr-nota         = docum-est.nro-docto
           tt-docto.cod-emitente    = docum-est.cod-emitente
           tt-docto.nat-operacao    = docum-est.nat-operacao
           tt-docto.dt-emis-nota    = docum-est.dt-trans
           tt-docto.nome-abrev      = emitente.nome-abrev
           tt-docto.usuario         = docum-est.usuario
           tt-docto.inc-seq         = param-re.inc-seq
           tt-docto.seq-item-um     = param-re.seq-item-um
           tt-docto.estado          = estabelec.estado
           tt-docto.cidade          = estabelec.cidade
           tt-docto.pais            = estabelec.pais
           tt-docto.cod-des-merc    = if natur-oper.consum-final then 2 /* Consumo */
                                                                 else 1 /* Industralizacao */
           tt-docto.esp-docto       = docum-est.esp-docto
           tt-docto.cod-msg         = natur-oper.cod-mensagem
           tt-docto.ind-lib-nota    = yes
           tt-docto.perc-desco1     = if docum-est.tot-desconto <> 0 then 1 else 0.

    RETURN "OK":U.
end procedure.

/*Maylon*/
procedure pi-gera-tt-it-docto.

    create tt-it-docto.
    assign tt-it-docto.seq-tt-it-docto = i-seq-aux
           /*tt-it-docto.conta-contabil  = ttItemDocEst.conta-contabil*/
           tt-it-docto.ct-codigo       = ttItemDocEst.ct-codigo
           tt-it-docto.sc-codigo       = ttItemDocEst.sc-codigo
        .
    assign tt-it-docto.cod-emitente    = docum-est.cod-emitente
           tt-it-docto.nr-nota         = docum-est.nro-docto
           tt-it-docto.serie           = docum-est.serie
           tt-it-docto.cod-estabel     = docum-est.cod-estabel
           tt-it-docto.nat-operacao    = docum-est.nat-operacao
           tt-it-docto.calcula         = yes
           i-seq-aux                   = i-seq-aux + 1
           tt-it-docto.nr-sequencia    = ttItemDocEst.sequencia
           tt-it-docto.quantidade      = ttItemDocEst.quantidade
           tt-it-docto.vl-frete        = ttItemDocEst.valor-frete
           tt-it-docto.vl-despes-it    = ttItemDocEst.despesas[1]
           tt-it-docto.vl-embalagem    = de-embal
           tt-it-docto.calcula         = yes
           tt-it-docto.it-codigo       = ttItemDocEst.it-codigo
           tt-it-docto.nro-comp        = ttItemDocEst.nro-comp
           tt-it-docto.serie-comp      = ttItemDocEst.serie-comp
           tt-it-docto.nat-comp        = ttItemDocEst.nat-comp
           tt-it-docto.seq-comp        = ttItemDocEst.seq-comp
           tt-it-docto.class-fiscal    = ttItemDocEst.class-fiscal
           tt-it-docto.data-comp       = ttItemDocEst.data-comp
           tt-it-docto.nr-ord-prod     = ttItemDocEst.nr-ord-prod
           tt-it-docto.numero-ordem    = ttItemDocEst.numero-ordem
           tt-it-docto.parcela         = ttItemDocEst.parcela
           tt-it-docto.cod-refer       = ttItemDocEst.cod-refer
           tt-it-docto.encerra-pa      = ttItemDocEst.encerra-pa
           tt-it-docto.item-pai        = ttItemDocEst.item-pai
           tt-it-docto.cod-roteiro     = ttItemDocEst.cod-roteiro
           tt-it-docto.op-codigo       = ttItemDocEst.op-codigo
           tt-it-docto.narrativa       = ttItemDocEst.narrativa
           tt-it-docto.desconto        = ttItemDocEst.desconto[1]
           tt-it-docto.per-des-item    = int(ttItemDocEst.desconto[1] > 0)
           tt-it-docto.vl-preuni       = ttItemDocEst.preco-unit[1] - ttItemDocEst.desconto[1]
           tt-it-docto.vl-preori       = ttItemDocEst.preco-unit[1]
           tt-it-docto.vl-merc-liq     = ttItemDocEst.preco-total[1] - ttItemDocEst.desconto[1]
           tt-it-docto.vl-merc-ori     = ttItemDocEst.preco-total[1]
           tt-it-docto.vl-seguro       = de-seguro
           tt-it-docto.char-1          = "im7777":U.

   return "OK":U.

end procedure.

/*Maylon*/
/* Temp-table para c lculo dos impostos*/
procedure pi-gera-tt-it-imposto:

    create tt-it-imposto.
    assign tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto
           tt-it-imposto.ind-icm-ret     = no
           tt-it-imposto.cd-trib-icm     = ttItemDocEst.cd-trib-icm
           tt-it-imposto.cd-trib-ipi     = ttItemDocEst.cd-trib-ipi
           tt-it-imposto.aliquota-icm    = ttItemDocEst.aliquota-icm
           tt-it-imposto.aliquota-ipi    = ttItemDocEst.aliquota-ipi
           tt-it-imposto.perc-red-ipi    = natur-oper.perc-red-ipi
           tt-it-imposto.perc-red-icm    = natur-oper.perc-red-icm
           tt-it-imposto.vl-bipi-it      = de-base-ipi
           tt-it-imposto.vl-bicms-it     = if avail tt-it-base-icm then tt-it-base-icm.base-icm + de-base-icm else de-base-icm.

    return "OK":U.

end procedure.

