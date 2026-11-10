/*
**  BOAD003A.i
**
**  acum-ap-emi - Movimentos acumulados do Contas a Pagar para o Caixa e Bancos
**
**  Ultima altera»’o : 28/04/99 - bre17663
*/
 
DEFINE TEMP-TABLE {1}
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field empresa     LIKE empresa.ep-codigo
    &ELSE
    field empresa     as integer format ">>9"
    &ENDIF
    field data        as date format "99/99/9999"
    field da-atraso   as date format "99/99/9999"
    field vl-cr       as decimal format "->>,>>>,>>>,>>9.99"
    field vl-ap       as decimal format "->>,>>>,>>>,>>9.99"
    field vl-aplic    as decimal format "->>,>>>,>>>,>>9.99"
    field vl-emp      as decimal format "->>,>>>,>>>,>>9.99"
    field vl-rec-pag  as decimal format "->>,>>>,>>>,>>9.99"
    field vl-original as decimal format "->>>,>>>,>>>,>>9.99"
    field vl-fluxo    as decimal format "->>,>>>,>>>,>>9.99"
    field linha       as integer
    field r-rowid     as rowid.
