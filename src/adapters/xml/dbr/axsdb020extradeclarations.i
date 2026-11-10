
{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}   /* defini‡Æo vati vel global - v_cdn_empres_usuar */

def var iContErro            as int initial 0 no-undo.
def var de-val-refer-atualiz as dec           no-undo.

/* ***defini‡Æo da temp-table tt-param-carga*** */

define temp-table tt-param-carga no-undo
    field l-estrut         AS LOGICAL INITIAL YES
    field l-operacao       AS LOGICAL INITIAL YES      
    field l-ord-prod       AS LOGICAL INITIAL YES      
    field l-saldo-estoque  AS LOGICAL INITIAL YES
    field l-pedido         AS LOGICAL INITIAL YES
    field l-ped-aprov      AS LOGICAL INITIAL YES
    field l-saldo-terc     AS LOGICAL INITIAL YES
    field l-ord-compra     AS LOGICAL INITIAL YES
    field l-item-dd        AS LOGICAL INITIAL YES
    field l-item-conf      AS LOGICAL INITIAL YES
    field da-corte-estrut  AS DATE    INITIAL TODAY
    field da-corte-oper    AS DATE    INITIAL TODAY
    field l-calend         as logical initial yes
    field l-ferr           as logical initial yes
    field l-grupo          as logical initial yes
    field l-oper-pad       as logical initial yes
    field da-refer-ord     as date    initial today
    field l-aloca-ped      as logical initial yes
    field l-aloca-prod     as logical initial yes
    FIELD l-xml            AS LOGICAL INITIAL YES
    FIELD l-depositos      AS LOGICAL INITIAL YES
    FIELD l-fornecedor     AS LOGICAL INITIAL YES
    FIELD acomp            AS HANDLE
    FIELD l-exporta        AS LOGICAL
    FIELD c-pasta-arq      AS CHARACTER
    FIELD l-item-estab     AS LOGICAL.

/* fim do include */
