/*
**
** BOCX300A.I - Definicao temp-table tt-cotacao usada para browser de formacao para inclusao de ordens
** 
*/

def temp-table tt-cotacao no-undo
    field numero-ordem like cotacao-item.numero-ordem
    field cod-emitente like cotacao-item.cod-emitente
    field it-codigo    like cotacao-item.it-codigo
    field data-cotacao like cotacao-item.data-cotacao    
    &if defined(bf-mat-comex) &then 
    &else
        field seq-cotac like cotacao-item.seq-cotac
    &endif
    field cod-cond-pag  like cotacao-item.cod-cond-pag
    field mo-codigo     like cotacao-item.mo-codigo
    field quantidade    like prazo-compra.quantidade
    field qtd-do-forn   like prazo-compra.qtd-do-forn
    field un            like cotacao-item.un
    field un-fornec     like cotacao-item.un
    field preco-unit    like cotacao-item.preco-unit
    field pre-unit-for  like cotacao-item.pre-unit-for
    field r-rowid      as rowid
    index codigo is unique primary 
        numero-ordem cod-emitente it-codigo data-cotacao
    &if defined(bf-mat-comex) &then 
    &else
        seq-cotac    
    &endif 
    .

/* BOCX300A.I */
