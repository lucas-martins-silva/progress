/*********************************************************************************
**
**   IM9023.i - Integracao Importacao Compras
**
**   Objetivo: Impress∆o das Despesas de Importaá∆o (Mapa Comparativo de Precos). 
**
*********************************************************************************/
def input parameter r-cotacao-item as rowid   no-undo.      /* rowid cotacao-item  */
def input parameter i-moeda        as integer no-undo.      /* moeda parametrizada */
def input parameter i-conversao    as integer no-undo.      /* data cotacao/atual  */
def input parameter da-data-conv as date format 99/99/9999. /* data conversao      */
def input parameter l-imprime-desp as logical no-undo.      /* detalha despesas    */

def buffer b-cotacao-item for cotacao-item.

{cdp/cdcfgmat.i} /* Pre-processador Magnus-EMS */

define temp-table tt-mapa NO-UNDO
    field mapa-cotacao      like cotacao-item-cex.mapa-cotacao
    field cod-itiner        like itinerario.cod-itiner
    field descricao         like itinerario.descricao
    field val-total         like cotacao-item-cex.val-desp
    field dt-chegada        as   date format "99/99/9999"
    index codigo is unique primary
        mapa-cotacao.
        
define temp-table tt-desp-mapa NO-UNDO
    field mapa-cotacao      like cotacao-item-cex.mapa-cotacao
    field cod-desp          like desp-imp.cod-desp
    field descricao         like desp-imp.descricao
    field cod-emitente-desp like emitente.cod-emitente
    field nome-abrev        like emitente.nome-abrev
    field val-desp          like cotacao-item-cex.val-desp
    field val-desp-tot      like cotacao-item-cex.val-desp
    index codigo is unique primary
        mapa-cotacao cod-desp.

def var c-lb-tit               as character format "x(25)" no-undo.
def var c-lb-mapa-cotacao      as character format "x(5)"  no-undo.
def var c-lb-cod-itiner        as character format "x(13)" no-undo.
def var c-lb-val-desp          as character format "x(16)" no-undo.
def var c-lb-val-desp-tot      as character format "x(16)" no-undo.
def var c-lb-val-total         as character format "x(14)" no-undo.
def var c-lb-dt-chegada        as character format "x(15)" no-undo.
def var c-lb-cod-desp          as character format "x(8)"  no-undo.
def var c-lb-cod-emitente-desp as character format "x(12)" no-undo.

{utp/ut-liter.i Mapa_Despesas_Importaá∆o * R}
assign c-lb-tit = trim(return-value).
{utp/ut-liter.i Mapa * R}
assign c-lb-mapa-cotacao = trim(return-value).
{utp/ut-liter.i Itinerario * R}
assign c-lb-cod-itiner = trim(return-value).
{utp/ut-liter.i Preáo_Desp_Unit * R}
assign c-lb-val-desp = trim(return-value).
{utp/ut-liter.i Preáo_Desp_Total * R}
assign c-lb-val-desp-tot = trim(return-value).
{utp/ut-liter.i Preáo_Total * R}
assign c-lb-val-total = trim(return-value).
{utp/ut-liter.i Prev_Chegada * R}
assign c-lb-dt-chegada = trim(return-value).
{utp/ut-liter.i Despesa * R}
assign c-lb-cod-desp = trim(return-value).
{utp/ut-liter.i Fornecedor * R}
assign c-lb-cod-emitente-desp = trim(return-value).

def var de-val-desp      like cotacao-item-cex.val-desp no-undo.
def var de-val-total     like cotacao-item-cex.val-desp no-undo.
def var l-imprime-cab    as   logical                   no-undo.
def var i-dias-total     as   integer                   no-undo.
def var de-preco-cotacao like cotacao-item.preco-unit   no-undo.
def var i-mapa           as   integer                   no-undo.
def var de-quantidade    like prazo-compra.quantidade   no-undo.

form skip
     "------------------" at 10
     c-lb-tit  
     "---------------------------------------------------------------------" skip
     c-lb-mapa-cotacao at 10
     c-lb-cod-itiner   
     c-lb-val-total    at 61
     c-lb-dt-chegada   skip
     c-lb-cod-desp     at 20
     c-lb-cod-emitente-desp at 60
     c-lb-val-desp     at 89 
     c-lb-val-desp-tot at 108 skip
     "------------------------------------------------------------------------------------------------------------------" at 10 skip
     with stream-io no-box no-label width 132 frame f-desp1.

form tt-mapa.mapa-cotacao at 10
     tt-mapa.cod-itiner   "-"  
     tt-mapa.descricao       
     tt-mapa.val-total    
     tt-mapa.dt-chegada   at 78 skip
     with stream-io no-box no-label width 132 frame f-desp2.
     
form tt-desp-mapa.cod-desp at 20 "-"
     tt-desp-mapa.descricao 
     tt-desp-mapa.cod-emitente-desp "-"
     tt-desp-mapa.nome-abrev
     tt-desp-mapa.val-desp 
     tt-desp-mapa.val-desp-tot skip
     with stream-io no-box no-label width 132 frame f-desp3.
    
find b-cotacao-item where rowid(b-cotacao-item) = r-cotacao-item no-lock no-error.
assign de-preco-cotacao = b-cotacao-item.preco-unit.
if b-cotacao-item.mo-codigo <> i-moeda then do:
    run cdp/cd0812.p (input  b-cotacao-item.mo-codigo,
                      input  i-moeda,
                      input  b-cotacao-item.preco-unit,
                      input  b-cotacao-item.data-cotacao,
                      output de-preco-cotacao).
    if de-preco-cotacao = ? or
       de-preco-cotacao = 0 then
        assign de-preco-cotacao = b-cotacao-item.preco-unit.
end.

for each prazo-compra
    where prazo-compra.numero-ordem = b-cotacao-item.numero-ordem no-lock:
    &IF DEFINED(bf-mat-comex) &THEN
        IF prazo-compra.situacao = "E" THEN /* Eliminada */
            NEXT.
    &ELSE
        IF prazo-compra.situacao = 4 THEN /* Eliminada */
            NEXT.
    &ENDIF
    assign de-quantidade = de-quantidade + prazo-compra.quantidade.
end.

for each cotacao-item-cex
    where cotacao-item-cex.numero-ordem = b-cotacao-item.numero-ordem
      and cotacao-item-cex.cod-emitente = b-cotacao-item.cod-emitente
      and cotacao-item-cex.it-codigo    = b-cotacao-item.it-codigo
    &if defined(bf-mat-comex) &then
      and cotacao-item-cex.data-cotacao = b-cotacao-item.data-cotacao
    &else
      and cotacao-item-cex.seq-cotac    = b-cotacao-item.seq-cotac
    &endif 
      no-lock:
      
    find desp-imp
        where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock no-error.
    if avail desp-imp then
        if not desp-imp.inc-val-seguro and
           not desp-imp.inc-val-frete  and
           not desp-imp.inc-val-embal  and
           not desp-imp.inc-val-outras-desp then
            next.

    find tt-mapa
        where tt-mapa.mapa-cotacao = cotacao-item-cex.mapa-cotacao no-error.
    if not avail tt-mapa then do:
        create tt-mapa.
        assign tt-mapa.mapa-cotacao = cotacao-item-cex.mapa-cotacao
               tt-mapa.cod-itiner   = cotacao-item-cex.cod-itiner   
               tt-mapa.val-total    = de-quantidade * de-preco-cotacao.
        find itinerario
            where itinerario.cod-itiner = cotacao-item-cex.cod-itiner no-lock no-error.
        if avail itinerario then
            assign tt-mapa.descricao = itinerario.descricao.
    end.
           
    create tt-desp-mapa.
    assign tt-desp-mapa.mapa-cotacao      = cotacao-item-cex.mapa-cotacao
           tt-desp-mapa.cod-desp          = cotacao-item-cex.cod-desp
           tt-desp-mapa.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp.
           
    if avail desp-imp then
        assign tt-desp-mapa.descricao = desp-imp.descricao.

    find emitente
        where emitente.cod-emitente = cotacao-item-cex.cod-emitente-desp no-lock no-error.
    if avail emitente then
        assign tt-desp-mapa.nome-abrev = emitente.nome-abrev.        
    
    if i-conversao = 1 then do:
        if cotacao-item-cex.mo-codigo <> i-moeda then
            run cdp/cd0812.p (input  cotacao-item-cex.mo-codigo,
                              input  i-moeda,
                              input  cotacao-item-cex.val-desp,
                              input  cotacao-item-cex.data-cotacao,
                              output de-val-desp).
        else 
            assign de-val-desp = cotacao-item-cex.val-desp.
    end.
    else do:
        run cdp/cd0812.p (input  cotacao-item-cex.mo-codigo,
                          input  i-moeda,
                          input  da-data-conv,
                          input  cotacao-item-cex.data-cotacao,
                          output de-val-desp).
    end.    
    if de-val-desp = ? or
       de-val-desp = 0 then
        assign de-val-desp = cotacao-item-cex.val-desp.        

    IF desp-imp.tipo = 1 THEN
        ASSIGN tt-desp-mapa.val-desp = de-val-desp / de-quantidade.
    ELSE
        ASSIGN tt-desp-mapa.val-desp = de-val-desp.

    ASSIGN tt-desp-mapa.val-desp-tot = tt-desp-mapa.val-desp * de-quantidade
           tt-mapa.val-total         = tt-mapa.val-total     + tt-desp-mapa.val-desp-tot.

end.

assign l-imprime-cab = yes.
for each tt-mapa by tt-mapa.mapa-cotacao:

    assign i-dias-total = 0.
    find itinerario 
        where itinerario.cod-itiner = tt-mapa.cod-itiner no-lock no-error.
    if avail itinerario then do:        
        assign tt-mapa.descricao = itinerario.descricao.
        for each pto-itiner 
            where pto-itiner.cod-itiner = itinerario.cod-itiner no-lock by pto-itiner.sequencia:
            assign i-dias-total = i-dias-total + pto-itiner.nr-dias.
            if pto-itiner.cod-pto-contr = itinerario.pto-chegada then
                leave.
        end.        
    end.
    
    if i-dias-total > 0  then
        assign tt-mapa.dt-chegada = today + i-dias-total.

    if l-imprime-cab then do:
        if l-imprime-desp then         
            disp c-lb-tit 
                 c-lb-mapa-cotacao 
                 c-lb-cod-itiner
                 c-lb-val-total
                 c-lb-dt-chegada        skip
                 c-lb-cod-desp
                 c-lb-cod-emitente-desp
                 c-lb-val-desp          
                 c-lb-val-desp-tot skip with frame f-desp1.
        else 
            disp c-lb-tit 
                 c-lb-mapa-cotacao 
                 c-lb-cod-itiner
                 c-lb-val-total
                 c-lb-dt-chegada skip with frame f-desp1.                     
        assign l-imprime-cab = no.                 
    end.                 
    
    disp tt-mapa.mapa-cotacao
         tt-mapa.cod-itiner
         tt-mapa.descricao
         tt-mapa.val-total
         tt-mapa.dt-chegada 
         with frame f-desp2.
    down with frame f-desp2.
    
    if not l-imprime-desp then next.
    
    for each tt-desp-mapa 
        where tt-desp-mapa.mapa-cotacao = tt-mapa.mapa-cotacao no-lock:
        disp tt-desp-mapa.cod-desp
             tt-desp-mapa.descricao
             tt-desp-mapa.cod-emitente-desp
             tt-desp-mapa.nome-abrev
             tt-desp-mapa.val-desp
             tt-desp-mapa.val-desp-tot
             with frame f-desp3.
        down with frame f-desp3.        
    end.
   put skip(1). 
end.

/*PUT "skip imp".*/
/*put skip(1).*/
