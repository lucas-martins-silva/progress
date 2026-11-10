
/*******************************************************************************
**
**     IM0660.I - Definicao de variaveis.
**
*******************************************************************************/

define temp-table tt-param
    field destino                   as integer
    field arquivo                   as char
    field usuario                   as char
    field data-exec                 as date
    field hora-exec                 as integer
    field cod-est-ini               as char format "x(03)"
    field cod-est-fim               as char format "x(03)"
    field c-emb-ini                 LIKE embarque-imp.embarque
    field c-emb-fim                 LIKE embarque-imp.embarque
    field nr-inv-ini                as char format "x(12)"
    field nr-inv-fim                as char format "x(12)"
    field dt-vencim-ini             as date format "99/99/9999"
    field dt-vencim-fim             as date format "99/99/9999"
    field c-master-ini              as char format "x(25)"
    field c-master-fim              as char format "x(25)"
    field c-house-ini               as char format "x(25)"
    field c-house-fim               as char format "x(25)"
    field l-envia                   as logical init no
    field c-destino                 as char
    field diretorio                 as char
    field l-impre                   as logical
    field l-envia-docto-exportador  as logical format "Sim/NÆo"
    field l-envia-docto-corretor    as logical format "Sim/NÆo"
    field c-arquivo-copia           as char format "x(100)"
    field l-layout-pad-fornec       as logical format "Sim/NÆo"
    field c-layout-pad-fornec       as char format "x(60)"
    field l-sobrepor                as logical format "Sim/NÆo"
    field c-dir-destino             as char format "x(80)"
    field i-agrupar                 as integer
    field i-orientacao              as integer
    field i-traducao                as integer.
                                   
/* IM0640.I  */
