/********************************************************************************
***
*** app/ap0521aa.i - Defini‡Æo Temp-table's / Variaveis.
***
********************************************************************************/

def temp-table tt-estabel
    field cod-estabel as char.

def temp-table tt-row-docto
    field cod-estabel as char
    field row-docto   as rowid.    

def var h-acomp as handle no-undo.
def var c-acomp as char   no-undo.

/* Fim de Include */
