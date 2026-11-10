/********************************************************************************
***
*** app/ap506arp.i - Defini‡Æo TempTable.
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
    field estabel          like tit-ap.cod-estabel
    field espec            like tit-ap.cod-esp
    field serie-ini        like tit-ap.serie
    field serie-fim        like tit-ap.serie
    field docto-ini        like tit-ap.nr-docto
    field docto-fim        like tit-ap.nr-docto
    field parc-ini         like tit-ap.parcela
    field parc-fim         like tit-ap.parcela
    field forn-ini         like tit-ap.cod-fornec
    field forn-fim         like tit-ap.cod-fornec
    field emis-ini         like tit-ap.dt-emissao
    field emis-fim         like tit-ap.dt-emissao
    field ref-ini          like tit-ap.referencia
    field ref-fim          like tit-ap.referencia
    field elimina-ir       as log
    field elimina-iss      as log
    field elimina-estoque  as log
    field elimina-movto    as log.
 
def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

/* Fim de Include */

