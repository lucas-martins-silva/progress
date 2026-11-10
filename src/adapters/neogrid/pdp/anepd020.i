/************************************************************************
*  Include: anepd020.i    
*           Defini‡Æo temp-table tt-param.                                                            *
************************************************************************/

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)":U
    field usuario             as char format "x(12)":U
    field data-exec           as date
    field hora-exec           as INTEGER
    FIELD estab-ini           LIKE ped-venda.cod-estabel
    FIELD estab-fim           LIKE ped-venda.cod-estabel
    FIELD item-ini            LIKE ped-item.it-codigo
    FIELD item-fim            LIKE ped-item.it-codigo
    FIELD fam-com-ini         LIKE ITEM.fm-cod-com
    FIELD fam-com-fim         LIKE ITEM.fm-cod-com
    FIELD ge-codigo-ini       LIKE ITEM.ge-codigo
    FIELD ge-codigo-fim       LIKE ITEM.ge-codigo
    FIELD pa-ord-comp         AS LOGICAL
    FIELD pa-ord-prod         AS LOGICAL
    FIELD pa-planejada        AS LOGICAL
    FIELD pa-res-comp         AS LOGICAL
    FIELD pa-res-plan         AS LOGICAL
    FIELD pa-sald-est         AS LOGICAL
    FIELD pa-item-fatur       AS LOGICAL
    FIELD pa-depositos        AS LOGICAL
    FIELD pa-dep-cq           AS LOGICAL
    FIELD pa-cod-plano        AS INTEGER FORMAT ">>9"
    FIELD pa-dt-plan          AS INTEGER
    FIELD pa-dt-corte         AS INTEGER 
    FIELD pa-benefic          as integer
    FIELD pa-abertos          AS LOGICAL
    FIELD pa-at-parcial       AS LOGICAL
    FIELD pa-cons-qt-aba      AS LOGICAL
    FIELD pa-ped-apro         AS LOGICAL
    FIELD pa-ped-aval         AS LOGICAL
    FIELD pa-ped-n-av         AS LOGICAL
    FIELD pa-ped-repr         AS LOGICAL
    FIELD pa-cred-aprov       AS LOGICAL
    FIELD pa-pedidos          AS LOGICAL
    FIELD pa-entrada-benef    AS LOGICAL
    FIELD pa-remessa-benef    AS LOGICAL
    FIELD pa-entrada-consig   AS LOGICAL
    FIELD pa-remessa-consig   AS LOGICAL
    FIELD pa-transferencia    AS LOGICAL
    FIELD pa-sald-terc        AS LOGICAL
    FIELD pa-t-pedidos        AS LOGICAL
    FIELD pa-t-ord-prod       AS LOGICAL                                     
    FIELD pa-t-reservas       AS LOGICAL                                         
    FIELD pa-t-compras        AS LOGICAL
    FIELD pa-wf-desconto      AS LOGICAL.
    
/* Fim da Include */    
