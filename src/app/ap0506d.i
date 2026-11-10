/********************************************************************************
***
*** app/ap0506d.i - Defini‡Æo TempTable.
***
********************************************************************************/

def temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field portador         like che-emit.portador
    field nr-cheque        like che-emit.nr-cheque
    field dt-emissao       like che-emit.dt-emissao.

def temp-table tt-raw-digita
    field raw-digita      as raw.
                    
/* Fim de Include */

