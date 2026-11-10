/**********************************************************************************
**   Arquivo....: BC0604.i
**   Finalidade.: Defini‡Æo da Temp-Table de parƒmetros 
**   VersÆo.....: 01.00.00 - Cria‡Æo - Marcio Andrade
**   Observa‡Æo.: 
**********************************************************************************/

/* Parameters Definitions ---                                           */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    FIELD iIniLayout       AS INTEGER
    FIELD iEndLayout       AS INTEGER
    FIELD lIniDatasul      AS LOGICAL
    FIELD lEndDatasul      AS LOGICAL
    FIELD iIniVersao       AS INTEGER
    FIELD iEndVersao       AS INTEGER
    FIELD lImprDescr       AS LOGICAL
    FIELD lImprEtiq        AS LOGICAL
    FIELD lImprEmit        AS LOGICAL.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.
