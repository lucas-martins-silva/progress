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
    field cod-estabel-ini     as char
    field cod-estabel-fim     as char 
    field nome-exportador-ini as char
    field nome-exportador-fim as char
    field it-codigo-ini       as char
    field it-codigo-fim       as char
    field desc-item-ini       as char 
    field desc-item-fim       as char
    field mo-codigo           as int
    field data-periodo-ini    as date format "99/99/9999"
    field data-periodo-fim    as date format "99/99/9999"    
    field data-cotacao        as date format "99/99/9999"
    field l-imprime-parametro as logical
    FIELD l-dtnacion          AS LOGICAL
    FIELD dt-nacionalizacao   AS DATE FORMAT "99/99/9999"
    field i-opcao             as integer.
    
def temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-item NO-UNDO
       field nro-docto     like item-doc-est.nro-docto
       field it-codigo     like item-doc-est.it-codigo
       field cod-emitente  like item-doc-est.cod-emitente
       field quantidade    like item-doc-est.quantidade
       field dt-emissao    like docum-est.dt-emissao
       field preco         like item-doc-est.preco-total[1]
       field nome-abrev    like emitente.nome-abrev
       field desc-item     as char format "x(36)"
       field sigla         like moeda.sigla
       field un            like item-doc-est.un
       field mo-codigo     like moeda.mo-codigo
       FIELD embarque      LIKE embarque-imp.embarque
       FIELD cod-estabel   LIKE embarque-imp.cod-estabel.


         
