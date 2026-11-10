/**********************************************************************************
***
*** app/ap0570.i - Defini‡Æo TempTable tt-variacao-monetaria.
***
**********************************************************************************/

def temp-table tt-variacao-monetaria NO-UNDO
    field dt-calculo  as date
    field dt-inicial  as date
    field dt-final    as date
    field vl-variacao as decimal
    field cotacao-dia as decimal format ">>>,>9.99999999" initial 0
    field sequencia   as integer
    INDEX codigo IS UNIQUE PRIMARY sequencia ASCENDING
    INDEX data   IS UNIQUE dt-calculo ASCENDING.

/* Fim de Include */

