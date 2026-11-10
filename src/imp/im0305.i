/*
** IM0305.I5 - Defini‡Æo de Temp-tables de parƒmetros de entrada
*/

define temp-table tt-param
    field destino                 as integer
    field arquivo                 as char
    field diretorio               as char
    field usuario                 as char
    field data-exec               as date
    field hora-exec               as integer
    field i-pedi-i                as integer   format ">>>>>,>>9":U
    field i-pedi-f                as integer   format ">>>>>,>>9":U
    field l-envia-docto-fornec    as logical
    field c-arquivo-copia         as character format "x(100)":U
    field l-layout-pad-fornec     as logical
    field c-layout-pad-fornec     as character format "x(60)":U
    field l-sobrepor              as logical
    field c-dir-destino           as character format "x(60)":U
    field l-traducao              as logical
    field l-minuta                as logical
    field decimais                as integer
    field i-moeda                 as integer
    field i-orientacao            as integer
    field i-formato-data          as integer
    field l-bus-to-bus            as logical.

DEFINE TEMP-TABLE tt-documentos-erros NO-UNDO
       FIELD seq           AS INTEGER
       FIELD cod-estabel   LIKE estabelec.cod-estabel
       FIELD nome-emit-exp LIKE emitente.nome-emit
       FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
       FIELD num-pedido    LIKE pedido-compr.num-pedido
       FIELD cod-erro      AS INT
       FIELD mensagem      AS CHAR  
       INDEX ch-chave seq.

DEFINE TEMP-TABLE tt-documentos-impressos NO-UNDO
       FIELD cod-estabel   LIKE estabelec.cod-estabel
       FIELD nome-emit-exp LIKE emitente.nome-emit
       FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
       FIELD num-pedido    LIKE pedido-compr.num-pedido
       FIELD destino      AS char
       INDEX ch-chave cod-estabel num-pedido.

/* IM0305.I5 */
