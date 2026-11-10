/**********************************************************************************
***
*** app/ap0570rp.i - Defini‡Æo tt-param.
***
**********************************************************************************/

def temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field dt-corte         as date
    field log-listagem     as logical
    field i-ep-codigo      like empresa.ep-codigo.
        
def temp-table tt-raw-digita
    field raw-digita      as raw.
    
/* Fim de Programa */
