/*************************************************************************
***
***  app/ap1004.i - Defini‡Æo TempTable.
***
*************************************************************************/

def temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field est-ini          like tit-ap.cod-estabel
    field est-fim          like tit-ap.cod-estabel
    field esp-ini          like tit-ap.cod-esp
    field esp-fim          like tit-ap.cod-esp
    field docto-ini        like tit-ap.nr-docto
    field docto-fim        like tit-ap.nr-docto
    field dt-trans-ini     like tit-ap.dt-transacao
    field dt-trans-fim     like tit-ap.dt-transacao
    field dt-vencto-ini    like tit-ap.dt-vencimen
    field dt-vencto-fim    like tit-ap.dt-vencimen
    field bord-ini         like tit-ap.nr-bordero
    field bord-fim         like tit-ap.nr-bordero
    field portador         like tit-ap.portador
    field ordem            as integer
    field i-documento      as integer
    field i-cod-barras     as integer.

def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique ordem.

/* Fim da Include */
