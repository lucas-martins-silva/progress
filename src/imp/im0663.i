{include/i_dbvers.i}
/*************************************************
*** 
***   IM0658 - Defini‡Æo da temp-table
***
**************************************************/

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field embarque-ini        as char
    field embarque-fim        as char
    field cod-estabel-ini     as char
    field cod-estabel-fim     as char 
    field nome-fornecedor-ini as char
    field nome-fornecedor-fim as char
    field pto-desembarque-ini as integer
    field pto-desembarque-fim as integer
    field it-codigo-ini       as char
    field it-codigo-fim       as char
    field desc-item-ini       as char 
    field desc-item-fim       as char
    field data-desembarque-ini as date format "99/99/9999"
    field data-desembarque-fim as date format "99/99/9999"
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    FIELD veiculo-ini         AS  CHAR FORMAT "x(12)"
    FIELD veiculo-fim         AS  CHAR FORMAT "x(12)"
    FIELD data-entrada-ini    AS DATE FORMAT "99/99/9999"
    FIELD data-entrada-fim    AS DATE FORMAT "99/99/9999"
    &endif
    field i-considera-nacionalizacao as integer
    field l-imprime-parametro as logical
    field i-opcao             as integer.


def temp-table tt-raw-digita
    field raw-digita as raw.


define temp-table tt-embarque NO-UNDO
       field embarque      as char format "x(12)"
&IF "{&mguni_version}" >= "2.071" &THEN
       field cod-estabel   as char format "x(05)"
&ELSE
       field cod-estabel   as char format "x(3)"
&ENDIF
       field it-codigo     as char format "x(16)"
       field desc-item     as char format "x(36)"
       field quantidade    as decimal format ">>>>>,>>9.9999"
       field unidade       as char format "x(3)"
       field nome-fornec   as char format "x(12)"
       field dt-prev-des   as date format "99/99/99"
       field dt-efet-des   as date format "99/99/99"
       field dt-prev-emb   as date format "99/99/99"
       field dt-efet-emb   as date format "99/99/99"
       field veiculo-tra   as char format "x(20)"
       field local         as char format "x(30)"
       field numero-ordem  like ordens-embarque.numero-ordem
       field parcela       like ordens-embarque.parcela.
       
       
         
