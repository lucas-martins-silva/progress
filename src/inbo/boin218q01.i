/*
**  BOIN218.i
**
**  movto-estoq - Movimento de Estoque
**
**  Ultima altera‡Æo : 01/12/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1} like movto-estoq
    field r-rowid  as rowid
    field sequencial as int 
    index dep-estab 
          cod-depos
          cod-estabel
          dt-trans.
 
