/******************************************************************************
**
**  Programa: ap1101.i - Defini‡Æo tt-param.
**
******************************************************************************/
    
define temp-table tt-param
    field destino            as integer
    field arq-destino        as char
    field arq-entrada        as char
    field todos              as integer
    field usuario            as char
    field i-ep-codigo        like empresa.ep-codigo
    field data-exec          as date
    field hora-exec          as integer
    field log-contabilizado  as logical
    field i-consistencia     as integer
    field l-aquivo-magnus    as logical init no.
            
/* Fim de Include */
