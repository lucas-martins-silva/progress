/*****************************************************************************
**
** IM9006 - Integra‡Æo entre os m¢dulos Caixa e Bancos e Importa‡Æo. (EMS)
**
** Objetivo: Ajuste da data de partida.
**
******************************************************************************/
def input        parameter rw-ordem-compra as rowid no-undo.
def input        parameter rw-prazo-compra as rowid no-undo.
def input        parameter da-inicio-fluxo as date  no-undo.
def input-output parameter da-partida      as date format "99/99/9999" no-undo.

{cdp/cdcfgmat.i} /* definicao pre-processador para integracao Magnus */
{cdp/cd4300.i3}  /* include desmembramento cotacao-item.char-1 */
{ccp/cc9019.i50} /* definicoes variaveis usadas cc9019.i51 */

def buffer b-historico-proc-imp for historico-proc-imp.

find ordem-compra
    where rowid(ordem-compra) = rw-ordem-compra no-lock no-error.

find prazo-compra
    where rowid(prazo-compra) = rw-prazo-compra no-lock no-error.

for first cotacao-item fields (char-1)
    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
      and cotacao-item.it-codigo    = ordem-compra.it-codigo
      and cotacao-item.cot-aprovada = yes no-lock:
end.

if avail cotacao-item then do:
    &if defined(bf-mat-comex) &then
        assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
               c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
               i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
    &else
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    &endif
    
    find processo-imp 
        where processo-imp.num-pedido = ordem-compra.num-pedido no-lock no-error.
    if avail processo-imp then do:
        find first ordens-embarque
            where ordens-embarque.numero-ordem = ordem-compra.numero-ordem
              and ordens-embarque.parcela      = prazo-compra.parcela no-lock no-error.    
        if not available ordens-embarque then do:
            find historico-proc-imp
                where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
                  and historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
                  and historico-proc-imp.cod-itiner    = processo-imp.cod-itiner
                  and historico-proc-imp.cod-pto-contr = i-cod-pto-contr-i50 no-lock no-error.                    
            if avail historico-proc-imp then do:
                if historico-proc-imp.dt-efetiva <> ? then 
                    assign da-partida = historico-proc-imp.dt-efetiva.
                else
                    assign da-partida = historico-proc-imp.dt-ult-previsao.
            end.
        end.
        else do:
            find historico-embarque
                where historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                  and historico-embarque.embarque      = ordens-embarque.embarque
                  and historico-embarque.cod-itiner    = processo-imp.cod-itiner
                  and historico-embarque.cod-pto-contr = i-cod-pto-contr-i50 no-lock no-error.
            if avail historico-embarque then do:
                if historico-embarque.dt-efetiva <> ? then 
                    assign da-partida = historico-embarque.dt-efetiva.
                else
                    assign da-partida = historico-embarque.dt-ult-previsao.
            end.
        end.    
    end.
end.

/* IM9006.I */
