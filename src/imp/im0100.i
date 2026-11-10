/**********************************************************************************
**
** IM0100.I - include definicao temp-tables comuns im0100/im0100a 
**          - utilizado ambientes Magnus/EMS - repassar alteracoes
**
**********************************************************************************/

DEFINE TEMP-TABLE tt-recebe no-undo
    field numero-ordem          like item-doc-est.numero-ordem
    field parcela               like item-doc-est.parcela
    field quantidade-informada  like ordens-embarque.quantidade
    field quantidade-total      like ordens-embarque.quantidade
    field quantidade-a-informar like ordens-embarque.quantidade
    FIELD preco-total           LIKE item-doc-est.preco-total[1]
    FIELD preco-total-mo        LIKE item-doc-est.preco-total-me[1]   
    FIELD peso-liquido-total    LIKE item-doc-est.peso-liquido
    field verifica-quantidade   as   logical
       index ordem is primary unique
          numero-ordem
          parcela.
          
define temp-table tt-param  no-undo
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as DATE.

/* IM0100.I */          
