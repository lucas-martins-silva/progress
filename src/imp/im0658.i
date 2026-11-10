 /*************************************************
*** 
***   IM0658 - Defini‡Æo da temp-table
***
**************************************************/

define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field cod-estabel-ini    as char
    field cod-estabel-fim    as char 
    field nome-exportador-ini as char
    field nome-exportador-fim as char
    field it-codigo-ini      as char
    field it-codigo-fim      as char
    field desc-item-ini      as char 
    field desc-item-fim      as char
    field data-chegada-ini   as date format "99/99/9999"
    field data-chegada-fim   as date format "99/99/9999"
    field cod-itiner-ini     as integer 
    field cod-itiner-fim     as integer
    field i-classificacao    as integer
    field i-sit-importacao   as integer
    field i-un-quantidade    as integer
    field l-parametros       as logical.

def temp-table tt-raw-digita
    field raw-digita as raw.

def temp-table tt-imprime-registro NO-UNDO
    field cod-estabel     like estabelec.cod-estabel
    field embarque        like embarque-imp.embarque
    field proc-imp        like processo-imp.nr-proc-imp
    field ped-compr       like processo-imp.num-pedido    
    field dt-ped          as   DATE format "99/99/99"
    field it-codigo       like ordem-compra.item
  &if defined(bf-mat-comex) &then
    field desc-item       as   char format "x(36)"
  &else    
    field desc-item       as   char format "x(36)"
  &endif
    field quant-prazo     like prazo-compra.quantidade
    field un              like prazo-compra.un
    field nome-exportador as   char format "x(12)" 
    field nome-fabricante as   char format "x(12)" 
    field n-fab           as   DATE format "99/99/99"
    field dt-prev-embar   as   DATE format "99/99/99"
    field dt-ult-embar    as   DATE format "99/99/99"
    field dt-efet-embar   as   DATE format "99/99/99"
    field dt-prev-desem   as   DATE format "99/99/99"
    field dt-ult-desem    as   DATE format "99/99/99"
    field dt-efet-desem   as   DATE format "99/99/99"
    field dt-prev-cheg    as   DATE format "99/99/99"
    field dt-ult-cheg     as   DATE format "99/99/99"
    field dt-efet-cheg    as   DATE format "99/99/99"
    field local           like pto-contr.descricao
    field quant-embarque  like ordens-embarque.quantidade
    index codigo is unique
        cod-estabel
        embarque
        proc-imp
        it-codigo.
    
/* IM0658 */    
         
