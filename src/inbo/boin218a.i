/*
**  BOIN218a.i
**
**  t-conta
**
**  Ultima altera‡Æo : 26/01/00 - GeraBO
*/
 
DEFINE TEMP-TABLE {1} 
    field r-rowid  as rowid
    field ct-codigo      like movto-estoq.ct-codigo
    field sc-codigo      like movto-estoq.sc-codigo
    field titulo         like conta-contab.titulo
    field conta          as char format "x(15)" 
    field it-codigo      like movto-estoq.it-codigo
    field vl-debito      as decimal format ">>>,>>>,>>>,>>9.99" 
    field vl-credito     as decimal format ">>>,>>>,>>>,>>9.99" 
    index codigo   
        ct-codigo 
        sc-codigo
        it-codigo.
