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
**
**********************************************************************************/

define temp-table tt-param
    field todos            as integer
    field destino          as integer
    field arq-destino      as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field coletor-ini      like bc-coletor.id-coletor
    field coletor-fim      like bc-coletor.id-coletor.
