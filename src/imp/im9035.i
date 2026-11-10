/*
**
** IM9035.I - Impressao integracao Importacao x Contratos 
**
*/

{cdp/cdcfgmat.i} /* include preprocessadores */

{cdp/cd4300.i3} /* include tratamento atributo livre */
{ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */

def input parameter p-num-pedido   like pedido-compr.num-pedido   no-undo.
def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
def input parameter p-parcela      like prazo-compra.parcela      no-undo.
def input parameter p-mo-codigo    like moeda.mo-codigo           no-undo.
def input parameter p-despesas-pag as integer                     no-undo. /*
                                                                         ** 1 - Pagas ao fornecedor material
                                                                         ** 2 - Todas as despesas 
                                                                         */
def input parameter p-despesas-inc as logical                   no-undo.
def output parameter p-val-desp like cotacao-item-cex.val-desp no-undo.

def temp-table tt-desp NO-UNDO
    field cod-desp  like desp-imp.cod-desp
    field descricao like desp-imp.descricao
    field val-desp  like cotacao-item-cex.val-desp
    index codigo is unique primary
        cod-desp.

def var de-val-desp       like cotacao-item-cex.val-desp no-undo.
def var c-lb-despesas-imp as char format "x(19)"         no-undo.
def var c-lb-cod-desp     as char format "x(6)"          no-undo.
def var c-lb-descricao    as char format "x(10)"         no-undo.
def var c-lb-val-desp     as char format "x(15)"         no-undo.
def var de-quantidade     like prazo-compra.quantidade   no-undo.

form
    c-lb-cod-desp  at 10
    c-lb-descricao at 17
    c-lb-val-desp  at 53 skip
    "------" at 10
    "------------------------------" at 17
    "------------------" at 48
     with stream-io no-box no-label width 132 frame f-despesas-cab.
     
{utp/ut-liter.i C¢digo * L}
assign c-lb-cod-desp = trim(return-value).
{utp/ut-liter.i Descri‡Æo * L}
assign c-lb-descricao = trim(return-value).
{utp/ut-liter.i Valor_Despesa * L}
assign c-lb-val-desp = trim(return-value).

form
    tt-desp.cod-desp  at 10
    tt-desp.descricao at 17
    tt-desp.val-desp  at 47
     with stream-io no-box no-label width 132 frame f-despesas.

for each ordem-compra
    where ordem-compra.num-pedido = p-num-pedido no-lock:
    
    assign de-quantidade = 0.
    
    if p-numero-ordem <> ? and p-numero-ordem <> ordem-compra.numero-ordem then
        next.
        
    for each prazo-compra
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
        if p-parcela <> ? and p-parcela <> prazo-compra.parcela then 
            next.
        assign de-quantidade = de-quantidade + prazo-compra.quantidade.            
    end.
    
    &if defined(bf-mat-comex) &then
      for each cotacao-item fields (cotacao-item.cot-aprovada cotacao-item.char-1 cotacao-item.data-cotacao)
    &else
      for each cotacao-item fields (cotacao-item.cot-aprovada cotacao-item.char-1 cotacao-item.seq-cotac)
    &endif  
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem
          and cotacao-item.cod-emitente = ordem-compra.cod-emitente
          and cotacao-item.data-cotacao = ordem-compra.data-cotacao no-lock:
        if cotacao-item.cot-aprovada then do:
            {cdp/cd4300.i4 "yes" cotacao-item.char-1}
            {ccp/cc9019.i51 "yes"}
            for each cotacao-item-cex
                where cotacao-item-cex.numero-ordem = ordem-compra.numero-ordem
                  and cotacao-item-cex.cod-emitente = ordem-compra.cod-emitente
                  and cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
                  &if defined(bf-mat-comex) &then
                  &else
                    and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                  &endif
                  and cotacao-item-cex.data-cotacao = ordem-compra.data-cotacao
                  and cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50
                  and cotacao-item-cex.cod-incoterm = c-cod-incoterm-i50
                  no-lock:
                if p-despesas-pag = 1 and ordem-compra.cod-emitente <> cotacao-item-cex.cod-emitente-desp then 
                    next.
                find tt-desp
                    where tt-desp.cod-desp = cotacao-item-cex.cod-desp no-lock no-error.
                if not avail tt-desp then do:                    
                    create tt-desp.
                    assign tt-desp.cod-desp = cotacao-item-cex.cod-desp.
                    find desp-imp
                        where desp-imp.cod-desp = tt-desp.cod-desp no-lock no-error.
                    if avail desp-imp then
                        assign tt-desp.descricao = desp-imp.descricao.
                end.
                run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                  input p-mo-codigo,
                                  input cotacao-item-cex.val-desp,
                                  input today,
                                  output de-val-desp).
                if de-val-desp = 0 or de-val-desp = ? then  
                    assign de-val-desp = cotacao-item-cex.val-desp.
                assign tt-desp.val-desp = tt-desp.val-desp + (de-val-desp * de-quantidade)
                       p-val-desp       = p-val-desp + (de-val-desp * de-quantidade).
                
            end.
        end.
    end.
end.

{utp/ut-liter.i Despesas_Importa‡Æo * L}
assign c-lb-despesas-imp = trim(return-value).

if can-find(first tt-desp) then do:
    put c-lb-despesas-imp at 5 ":" skip.
    disp c-lb-cod-desp 
         c-lb-descricao
         c-lb-val-desp
         with frame f-despesas-cab.
end.    
for each tt-desp:
    disp tt-desp.cod-desp
         tt-desp.descricao
         tt-desp.val-desp 
        with frame f-despesas.
    down with frame f-despesas.
end.
