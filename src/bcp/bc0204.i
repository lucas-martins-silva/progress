/**********************************************************************************
**
**   Arquivo....: BC0204.I
**
**   Finalidade.: Defini‡Æo da Temp-Table de parƒmetros de atualiza‡Æo das
**                transa‡äes de coleta de dados.
**
**   VersÆo.....: 01.00.00 - Cria‡Æo - Gustavo
**
**   Observa‡Æo.: CUIDADO!!! Esta temp-table ‚ utilizada tanto pela a atualiza‡Æo
**                manual (BC0204) quanto pela via RPW.
**                O campo arq-destino ‚ usado para transa‡äes de importa‡Æo
**
**********************************************************************************/

define temp-table tt-param NO-UNDO
    field ep-codigo         like empresa.ep-codigo
    field destino           as integer
    field arquivo           as char
    field arq-destino       as char
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field classifica        as integer
    field desc-classifica   as char format "x(40)"
    field trans-ini         as decimal
    field trans-fim         as decimal
    field da-ini            as date
    field da-fim            as date
    field hr-ini            like bc-trans.horario
    field hr-fim            like bc-trans.horario
    field tp-trans-ini      like bc-tipo-trans.cd-trans
    field tp-trans-fim      like bc-tipo-trans.cd-trans
    field todos             as integer
    field coletor-ini       like bc-coletor.id-coletor
    field coletor-fim       like bc-coletor.id-coletor
    field tp-etiqueta       as logical
    field tp-movto          as logical
    FIELD tp-estado-nova    AS logical
    FIELD tp-estado-erro    AS logical.
