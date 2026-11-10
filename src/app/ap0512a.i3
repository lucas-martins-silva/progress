/*******************************************************************************
*** app/ap0512a.i3 - Defini‡Æo Temp-table TT-PARAM
*******************************************************************************/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field ep-codigo        as integer
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field da-limite        as date
    field gera-listagem    as logical
    field l-hist           as logical
    field l-conecta        as logical
    field l-multiplanta    as logical
    field c-origem-ap      as char.

                                
/*--- Fim AP0512a.i3 ---*/
