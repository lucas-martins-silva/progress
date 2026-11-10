/********************************************************************************
**
** IM9018.i
**
** Objetivo  : Respons vel pelas integra‡äes do m¢dulo de importa‡Æo
**             verifica se a cotacao requisitada para a aprova‡Æo possui um mapa
**             de despesas de importa‡Æo cadastrado ou informado.                  
********************************************************************************/

def input parameter r-cotacao-item as rowid no-undo.

{cdp/cd4300.i3}  /* variáveis utilizadas pelo cd4300.i4 */
{ccp/cc9019.i50} /* variáveis e informações utilizadas pelo cc9019.i51 */

{cdp/cdcfgmat.i} /* definicao pre-processadores importacao */

find cotacao-item where rowid(cotacao-item) = r-cotacao-item no-lock no-error.
if avail cotacao-item then do:
    &if defined(bf-mat-comex) &then
        assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
               c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
               i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
    &else
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    &endif
    find emitente where emitente.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
    if avail emitente and 
       &if defined(bf-mat-comex) &then
           (emitente.natureza = "E" or emitente.natureza = "T") and
           (emitente.identific = "F" or emitente.identific = "A") 
       &else
           (emitente.natureza = 3 or emitente.natureza = 4) and
           (emitente.identific = 2 or emitente.identific = 3)
       &endif then do:
        find first cotacao-item-cex where 
             cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem and
             cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente and
             cotacao-item-cex.it-codigo    = cotacao-item.it-codigo and
             &if defined(bf-mat-comex) &then
                 cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
             &else
                 cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac 
             &endif no-lock no-error.
        if avail cotacao-item-cex then do:
            find first cotacao-item-cex where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem and
                                              cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente and
                                              cotacao-item-cex.it-codigo    = cotacao-item.it-codigo and
                                              &if defined(bf-mat-comex) &then
                                                  cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao and
                                              &else
                                                  cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac and
                                              &endif 
                                              cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50 no-lock no-error.
            if not avail cotacao-item-cex then do:
                {utp/ut-liter.i informado mim L}
                run utp/ut-msgs.p (input "show",
                                   input 17168,
                                   input return-value).                                           
            end.                                               
        end.
        else do:                                    
            {utp/ut-liter.i cadastrado mim L}
            run utp/ut-msgs.p (input "show",
                               input 17168,
                               input return-value).                                           
        end.
    end.
end.     

