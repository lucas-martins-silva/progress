/******************************************************************************
***
*** app/ap5520.i - Defini‡Æo Temp-Table.
***
*******************************************************************************/

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field bordero-ini      like bord-tit.nr-bordero
    field bordero-fim      like bord-tit.nr-bordero
    field port-ini         like bord-tit.portador
    field port-fim         like bord-tit.portador
    field sit              as log
    field ep-codigo        like bord-tit.ep-codigo
    field dt-emissao-ini   like bord-rec.dt-emissao
    field dt-emissao-fim   like bord-rec.dt-emissao
    field bxa-bord-impr    as logical.

/* Fim de Include */
