/*******************************************************************************
***
*** app/ap0777x.i - 
***
*******************************************************************************/

DEF TEMP-TABLE tt-espec-impto NO-UNDO LIKE espec-ap
    FIELD ind-tipo AS CHAR.
        
DEF {1} TEMP-TABLE tt-dirf NO-UNDO
    FIELD qtde-registros AS INTEGER FORMAT ">>>>>>9" COLUMN-LABEL "Qtde Registros"
    FIELD situacao       AS CHAR    FORMAT "x(20)"   COLUMN-LABEL "Situa‡Æo"
    FIELD ind-situacao   AS CHAR    FORMAT "x(20)"   COLUMN-LABEL "Indicador Situa‡Æo"
    FIELD valor-multa    AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99" COLUMN-LABEL "Valor Multa"
    FIELD ep-codigo      LIKE empresa.ep-codigo
    FIELD razao-social   LIKE empresa.razao-social
    FIELD cgc            LIKE empresa.cgc
    INDEX codigo ep-codigo situacao.

/* Fim Include */

