/********************************************************************************
** 
** im9020.i - eliminacao das despesas adicionais de importacao da cotacao do item
**
** Ultima alteracao: 06/09/1999 - bre18074
** 
********************************************************************************/

/* Parametros ******************************************************************
r-chave - rowid da cotacao-item que est  sendo eliminada
********************************************************************************/

def input parameter r-chave as rowid no-undo.
{cdp/cd4300.i3}
{ccp/cc9019.i50}
{cdp/cdcfgmat.i} 
    
find cotacao-item where rowid(cotacao-item) = r-chave no-lock no-error.
if avail cotacao-item then do:
    &if defined(bf-mat-comex) &then
        assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
               c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
               i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
    &else
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    &endif    
    for each cotacao-item-cex where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem and
                                     cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente and
                                     cotacao-item-cex.it-codigo    = cotacao-item.it-codigo and
                                     &if defined(bf-mat-comex) &then
                                         cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
                                     &else   
                                         cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                                     &endif
                                     EXCLUSIVE-LOCK.

        delete cotacao-item-cex.                  
    end.
end.        
