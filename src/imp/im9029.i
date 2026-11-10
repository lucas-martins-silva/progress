
/********************************************************************************
** 
** IM9029.P - Valor Despesas + Valor Material
**
** Objetivo : Responsÿvel pelas integra»„es do m½dulo de importa»’o
**             Adiciona o valor das despesas de importa»’o ao valor do material
********************************************************************************/
def input  parameter r-chave as rowid no-undo.      /* rowid da cotacao do item            */
def output parameter de-valor-despesas as decimal.  /* retorna o valor das despesas        */

def var de-valor-despesas-aux like cotacao-item-cex.val-desp no-undo.
DEF VAR de-quantidade         LIKE prazo-compra.quantidade   NO-UNDO.

{cdp/cd4300.i3}  /* Include atributos livres */
{ccp/cc9019.i50} /* Atributo livre cotacao-item.char-1 */
{cdp/cdcfgmat.i} /* Pre-processador Magnus-EMS */

find cotacao-item 
    where rowid(cotacao-item) = r-chave no-lock no-error.
if avail cotacao-item then do:

    &if defined(bf-mat-comex) &then
        assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
               c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
               i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
    &else
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    &endif
    
    &IF DEFINED(bf-mat-comex) &THEN /* Magnus */
        FOR EACH prazo-compra WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK:
            IF prazo-compra.situacao = "E" THEN
                NEXT.
            ASSIGN de-quantidade = de-quantidade + prazo-compra.quantidade.
        END.

    &ELSE /* EMS */
    
        FIND ordem-compra
            WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK NO-ERROR.
        ASSIGN de-quantidade = ordem-compra.qt-solic.

    &ENDIF

    for each cotacao-item-cex where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem and
                                    cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente and
                                    cotacao-item-cex.it-codigo    = cotacao-item.it-codigo and
                                    &if defined(bf-mat-comex) &then
                                        cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao and
                                    &else
                                        cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac and
                                    &endif
                                    cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50 
                                    no-lock:
        find desp-imp 
            where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock no-error.
        if avail desp-imp then
            if desp-imp.inc-val-duplic or
               desp-imp.inc-val-embal or 
               desp-imp.inc-val-frete or 
               desp-imp.inc-val-outras-desp or 
               desp-imp.inc-val-seguro then do:
                
                run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                  input cotacao-item.mo-codigo,
                                  input cotacao-item-cex.val-desp,
                                  input today,
                                  output de-valor-despesas-aux).
                IF desp-imp.tipo = 1 THEN
                    ASSIGN de-valor-despesas-aux = de-valor-despesas-aux / de-quantidade.
                ASSIGN de-valor-despesas = de-valor-despesas + de-valor-despesas-aux.
            end.
    end.

end.


