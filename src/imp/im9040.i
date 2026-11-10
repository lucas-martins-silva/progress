{include/i_dbvers.i}
/*************************************************
*** 
***   IM9040 - Defini‡Æo da temp-table
***
**************************************************/
/********************** old ********
define temp-table tt-despesas-importacao no-undo
       field embarque      like embarque-imp.embarque
       field numero-ordem  like ordens-embarque.numero-ordem
       field parcela       like ordens-embarque.parcela
       field dt-fluxo      as date format "99/99/9999"
       field tp-codigo     like item.tp-desp-padrao
       field nome-abrev    like emitente.nome-abrev
       field vl-preco      as decimal
       field val-desp      like cotacao-item-cex.val-desp
       field quantidade    like prazo-compra.quant-saldo.
***************************************************/


def temp-table tt-despesas-importacao NO-UNDO
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel            as char    format "x(05)"
&ELSE
    field cod-estabel            as char    format "x(03)"
&ENDIF
    field data-movto             as date    format "99/99/9999"
    field tp-codigo              as integer format ">>9"
    field cod-desp               as integer
    field cod-gr-forn            as integer format ">9"
    field cod-emitente           as integer format "999999999"
    field tipo-fluxo             as integer format "9"    /* 1-Entrada, 2-Saida */
    field tipo-movto             as integer format "9"    /* 1-Previsto, 2-Realizado */
    field origem                 as integer format "9"
    field mo-codigo              as integer format ">9"
    field cod_unid_negoc         as char    format "x(03)"
    field numero-ordem           as char    format "x(16)" 
    field parcela                as char    format "x(02)"
    field sit-ordem              as integer format ">9" 
    field vl-fluxo               as decimal format "->>>,>>>,>>>,>>9.99"
    field data-fluxo             as date    format "99/99/9999" /* campo novo */
    field it-codigo              as char    format "x(16)"     /* campo novo */
    field embarque               LIKE embarque-imp.embarque
    field nome-abrev             like emitente.nome-abrev.       
