/******************************************************************************
**
**  APP/AP0711.I - Objetivo: Defini‡Æo Temp-TAble tt-param.
**
*******************************************************************************/

def temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field usuario             as char
    field i-ep-codigo         like empresa.ep-codigo
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field text-classif        as char    format "x(30)"
    field matriz-ini          like emitente.nome-matriz
    field matriz-fim          like emitente.nome-matriz
    field est-ini             like mov-ap.cod-estabel
    field est-fim             like mov-ap.cod-estabel
    field esp-ini             like mov-ap.cod-esp
    field esp-fim             like mov-ap.cod-esp
    field grupo-ini           like emitente.cod-gr-forn
    field grupo-fim           like emitente.cod-gr-forn
    field for-ini             like mov-ap.cod-fornec
    field for-fim             like mov-ap.cod-fornec
    field da-ini              as date    format "99/99/9999"
    field da-fim              as date    format "99/99/9999"
    field bordero-ini         like tit-ap.nr-bordero
    field bordero-fim         like tit-ap.nr-bordero
    field nr-cheque-ini       as integer
    field nr-cheque-fim       as integer
    field moeda               as integer format "99"
    field dt-conversao        as date    format "99/99/9999"
    field acerto              as logical format "Sim/NÆo"
    field tipo                as integer
    field text-tipo           as char format "x(30)"
    field lista               as logical format "Sim/NÆo"
    field transf              as logical format "Sim/NÆo"
    field portador-ini        as integer
    field portador-fim        as integer
    field log-pag-parametros  as logical.

/* Fim de Include */
