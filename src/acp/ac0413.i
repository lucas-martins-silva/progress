/*************************************************************************
* Include : acp/ac0413.i tt-param 
*  Autor  : DATASUL S.A.
**************************************************************************/

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field arq-destino          as char
    field arq-entrada          as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field codigo-ini           as integer
    field codigo-fim           as integer
    field opcao-perc           as integer
    field desc-opcao           as char format "x(50)".

/* Fim include ac0413.i */
