/*************************************************
*** 
***   IM0664 - Defini‡Æo de temp-table 
***
**************************************************/

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field cod-estabel-ini     as char
    field cod-estabel-fim     as char 
    field embarque-ini        as char
    field embarque-fim        as char
    field processo-ini        as char
    field processo-fim        as char    
    field cod-pto-ini         as integer 
    field cod-pto-fim         as integer
    field it-codigo-ini       as char
    field it-codigo-fim       as char
    field dt-efetiva-eadi-ini as date format "99/99/9999"
    field dt-efetiva-eadi-fim as date format "99/99/9999"
    field fatura-ini          as char 
    field fatura-fim          as char
    field i-classificacao     as integer
    field i-sit-processo      as integer
    field l-parametros        as logical
    field i-opcao             as integer.

def temp-table tt-raw-digita
    field raw-digita as raw.

DEFINE TEMP-TABLE tt-embarque-imp-aux NO-UNDO 
    FIELD cod-estabel     like embarque-imp.cod-estabel
    FIELD embarque        like embarque-imp.embarque
    FIELD pto-eadi        like historico-embarque.cod-pto-contr
    FIELD it-codigo       like ordem-compra.it-codigo
    FIELD quant-a-nac     like ordens-embarque.quantidade
    FIELD r-Rowid AS ROWID.


DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
    FIELD pto-eadi        like historico-embarque.cod-pto-contr
    FIELD desc-eadi       like pto-contr.descricao
    FIELD dt-nacionaliz   like historico-embarque.dt-efetiva
    FIELD fatura          like invoice-emb-imp.nr-invoice
    FIELD dt-vencim       like invoice-emb-imp.dt-vencim 
    FIELD dt-efetiva-eadi like historico-embarque.dt-efetiva
    FIELD numero-ordem    like ordem-compra.numero-ordem
    FIELD nr-proc-imp     like processo-imp.nr-proc-imp
    FIELD num-pedido      like processo-imp.num-pedido
    FIELD it-codigo       like ordem-compra.it-codigo
    FIELD un              like item.un
    FIELD quantidade      like ordens-embarque.quantidade
    FIELD quant-a-nac     like ordens-embarque.quantidade
    FIELD observacao      as char format "x(25)"
    FIELD r-Rowid AS ROWID
    index ordem is primary unique
          cod-estabel 
          embarque 
          nr-proc-imp
          numero-ordem 
          it-codigo.
