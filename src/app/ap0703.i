/*******************************************************************************
***
*** app/ap0703.i - Defini‡Æo Temp-Table.
***
*******************************************************************************/

def temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)"
    field est-ini             like tit-ap.cod-estabel
    field est-fim             like tit-ap.cod-estabel
    field esp-ini             like tit-ap.cod-esp
    field esp-fim             like tit-ap.cod-esp
    field for-ini             like tit-ap.cod-fornec
    field for-fim             like tit-ap.cod-fornec
    field i-ep-codigo         like empresa.ep-codigo
    field grupo-ini           as integer
    field grupo-fim           as integer
    field port-ini            like portador.cod-portador
    field port-fim            like portador.cod-portador
    field matriz-ini          like tit-ap.matriz
    field matriz-fim          like tit-ap.matriz
    field fim-per             as date format "99/99/9999"
    field escolha             as integer
    field text-escolha        as char format "x(40)"
    field desej-praz          as logical
    field venc-31             as integer format "99"
    field venc-60             as integer format "99"
    field venc-61             as integer format "99"
    field venc-90             as integer format "99"
    field a-venc-31           as integer format "99"
    field a-venc-60           as integer format "99"
    field a-venc-61           as integer format "99"
    field a-venc-90           as integer format "99"
    field a-venc-91           as integer format "99"
    field a-venc-120          as integer format "999"
    field moeda               as integer
    field antec               as logical
    field considera           as logical
    field provisao            as logical
    field lista               as logical
    field lista1              as logical
    field fasb                as integer
    field text-fasb           as char format "x(40)"
    field chave               as integer
    field text-chave          as char format "x(40)"
    field da-conversao        as date format "99/99/9999"
    field resumo              as date format "99/99/9999"
    field conv-prev           as date format "99/99/9999"
    field base                as date format "99/99/9999"
    field dias                as integer
    field log-pag-parametros  as logical.
 
/* Fim de Include */


