/*******************************************************************************
***
*** app/ap0740.i - Defini‡Æo tt-param.
***
*******************************************************************************/

def temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field ep-codigo           as integer
    field i-pais-usuario      as integer
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)"
    field ind-tipo-rel        as integer
    field des-tipo-rel        as char format "x(40)"
    field i-margem-dias       as integer
    field da-data-base        as date
    field i-opcao-moeda       as integer
    field i-cod-moeda         as integer
    field de-cotacao-dia      as decimal format ">>>,>9.99999999"
    field des-moeda           as character
    field ind-tipo-resumo     as integer
    field des-tipo-resumo     as char format "x(40)"
    field da-corte            as date
    field da-conversao        as date
    field da-calc-resumo      as date
    field log-lis-antec       as logical
    field log-lis-prev        as logical
    field log-lis-prov        as logical
    field log-lis-hist-prev   as logical
    field log-lis-hist-docto  as logical
    field log-param-prazo     as logical
    field log-cons-mo-orig    as logical
    field log-pag-parametros  as logical
    field i-venc-31           as integer
    field i-venc-60           as integer
    field i-venc-61           as integer
    field i-venc-90           as integer
    field i-a-venc-31         as integer
    field i-a-venc-60         as integer
    field i-a-venc-61         as integer
    field i-a-venc-90         as integer
    field i-a-venc-91         as integer
    field i-a-venc-120        as integer
    field cod-est-ini         as character
    field cod-est-fim         as character
    field cod-esp-ini         as character
    field cod-esp-fim         as character
    field cod-fornec-ini      as integer format ">>>>>>>>9"
    field cod-fornec-fim      as integer format ">>>>>>>>9"
    field cod-grupo-ini       as integer
    field cod-grupo-fim       as integer
    field cod-port-ini        as integer
    field cod-port-fim        as integer
    field cod-matriz-ini      as integer format ">>>>>>>>9"
    field cod-matriz-fim      as integer format ">>>>>>>>9"
    field cod-moeda-ini       as integer
    field cod-moeda-fim       as integer
    field c-conta-ini         like conta-ap.conta-saldo
    field c-conta-fim         like conta-ap.conta-saldo.
        
/* Fim de Include */
