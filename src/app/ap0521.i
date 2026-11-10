/**********************************************************************************
***
*** app/ap0521.i - Defini‡Æo Temp-Table.
***
**********************************************************************************/

def temp-table tt-param
    field usuario          as char
    field ep-codigo        as integer
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field l-inf-bordero    as logical
    field dt-transacao     like tit-ap.dt-transacao
    field i-portador       like tit-ap.portador
    field i-nr-bordero     like tit-ap.nr-bordero   
    field i-nr-bordero-ini like tit-ap.nr-bordero   
    field i-nr-bordero-fim like tit-ap.nr-bordero   
    field da-ven-ini       like tit-ap.dt-vencimen
    field da-ven-fim       like tit-ap.dt-vencimen
    field i-for-ini        like tit-ap.cod-fornec
    field i-for-fim        like tit-ap.cod-fornec.

def temp-table tt-digita
    field ep-codigo     as integer.

/* Fim de Include */
