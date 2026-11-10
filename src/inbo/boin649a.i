/*
**  BOIN649.i
**
**  it-pedido-imp - 
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1} 
    field cod-imposto   like it-pedido-imp.cod-taxa
    field descricao     like tipo-tax.descricao
    field aliquota      like it-pedido-imp.aliquota
    field valor-imposto like it-pedido-imp.vl-imposto
    field r-rowid  as rowid.
 
