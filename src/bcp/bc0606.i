/**********************************************************************************
**
**   Arquivo....: BC0606I
**
**   Finalidade.: Defini‡Æo da Temp-Table de parƒmetros de atualiza‡Æo das
**                transa‡äes de coleta de dados.
**
**********************************************************************************/

define temp-table tt-param
    field ep-codigo         as char
    field destino           as integer
    field arq-destino       as char
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field codItemIni        as char
    field codItemFim        as char
    field cArquivo          as CHAR
    field rsProcesso        as integer.



