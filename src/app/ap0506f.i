/*********************************************************************************
***
*** app/ap0506f.i - Defini‡Æo Temp_Table.
***
*********************************************************************************/

def temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field referencia       like nota-dup.referencia
    field dt-transacao     like nota-dup.dt-transacao.  
       
def temp-table tt-raw-digita
    field raw-digita as raw.
    
/* Fim de Include */
