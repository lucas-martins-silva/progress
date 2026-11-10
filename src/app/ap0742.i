/*******************************************************************************
***
*** app/ap0741.i - Defini‡Æo tt-param.
***
*******************************************************************************/

def temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field ep-codigo           as integer
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as char
    field classifica          as integer
    field desc-classif        as char format "x(40)"
    field i-moeda             as integer format ">9"
    field desc-moeda          as char
    field tipo-variacao       as integer format ">9"
    field des-tipo-variacao   as char
    field i-titulo-bxa        as integer format ">9"
    field des-titulo-bxa      as char
    field log-imp-param       like tit-ap.enviado
    field cod-estabel-ini     as char
    field cod-estabel-fim     as char
    field cod-esp-ini         as char
    field cod-esp-fim         as char
    field serie-ini           as char
    field serie-fim           as char
    field docto-ini           as char
    field docto-fim           as char
    field cod-forn-ini        as integer
    field cod-forn-fim        as integer
    field grupo-ini           as integer
    field grupo-fim           as integer
    field dt-trans-ini        as date
    field dt-trans-fim        as date.
    
/* Fim de Include */
