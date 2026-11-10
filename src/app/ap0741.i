/*******************************************************************************
***
*** app/ap0741.i - Defini‡Æo tt-param.
***
*******************************************************************************/

def temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field ep-codigo           as CHAR FORMAT "x(3)"
    field i-pais-usuario      as integer
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field desc-classif        as char format "x(40)"
    field des-tipo-emissao    as char format "x(40)"
    field des-cal-atraso      as char format "x(40)"
    field tp-relatorio        as integer
    field atraso-medio        as integer
    field log-esp-ctbl        like tit-ap.log-1
    field log-razao-ficha     like tit-ap.log-1
    field log-vinculado       like tit-ap.log-1
    field log-salt-linha      like tit-ap.log-1
    field log-prev-saldo      like tit-ap.log-1
    field log-prev-perfil     like tit-ap.log-1
    field log-saldo-movto     like tit-ap.log-1
    field log-ordem-pagto     like tit-ap.log-1
    field log-pag-parametros  like tit-ap.log-1
    field log-cons-mo-orig    like tit-ap.log-1
    field log-lista-variacao  like tit-ap.log-1    
    field i-opcao-moeda       as integer
    field i-cod-moeda         as integer   format ">9"
    field de-cotacao-dia      as decimal   format ">>>,>9.99999999"
    field des-moeda           as character format "x(20)"
    field da-conversao        as date
    field cod-estabel-ini     as CHAR FORMAT "x(5)"
    field cod-estabel-fim     as CHAR FORMAT "x(5)"
    field cod-esp-ini         as char
    field cod-esp-fim         as char
    field grupo-ini           as integer
    field grupo-fim           as integer
    field cod-forn-ini        as integer
    field cod-forn-fim        as integer
    field matriz-ini          as integer
    field matriz-fim          as integer
    field dt-trans-ini        as date
    field dt-trans-fim        as date
    field moeda-ini           as integer
    field moeda-fim           as integer.
    
/* Fim de Include */
