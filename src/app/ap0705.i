/******************************************************************************
***
***  app/ap0705.i - Defini‡Æo TempTable.
***
******************************************************************************/

def temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field usuario             as char
    field data-exec           as date
    field hora-exec           as integer
    field cod-emi-ini         like emit-estat.cod-gr-emit
    field cod-emi-fim         like emit-estat.cod-gr-emit
    field est-ini             like tit-ap.cod-estab
    field est-fim             like tit-ap.cod-estab
    field esp-ini             like espec-ap.cod-esp
    field esp-fim             like espec-ap.cod-esp
    field relato              as integer
    field desc-relat          as char format "x(40)" 
    field mes-per             as integer format "99"
    field ano-per             as integer format "9999"
    field da-referencia       as date format "99/99/9999"
    field moeda               as integer format "9"
    field da-conversao        as date 
    field cotacao-dia         like tit-ap.cotacao-dia
    field meses               as integer format "99"
    field curva               as integer
    field desc-curva          as char format "x(40)"
    field previsao            as logical
    field nome-moeda          as char format "x(10)"
    field i-ep-codigo         like empresa.ep-codigo
    field log-pag-parametros  as logical  .

/* Fim de Include */

