/***********************************************************************
***
*** app/ap0717.i - Defini‡Æo TempTable tt-param.
***
***********************************************************************/

def temp-table tt-param NO-UNDO
    field ep-codigo           as integer
    field destino             as integer
    field arquivo             as char
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)"
    field c-est-ini           like tit-ap.cod-estabel
    field c-est-fim           like tit-ap.cod-estabel
    field c-esp-ir            like tit-ap.cod-esp
    field i-ret-ini           like tit-ap.cod-retencao
    field i-ret-fim           like tit-ap.cod-retencao 
    field dt-venc-ini         like tit-ap.dt-vencimen
    field dt-venc-fim         like tit-ap.dt-vencimen
    field log-pag-parametros  as logical
    FIELD l-apenas-recolher   AS LOGICAL FORMAT "Sim/NÆo"
    FIELD l-considera-saldo   AS LOGICAL FORMAT "Sim/NÆo"
    FIELD de-valores-acima    AS DECIMAL.

/* Fim de Include */
