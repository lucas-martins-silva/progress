/*******************************************************************************
***
*** app/ap0512a.i - Defini‡Æo Temp-table.
***
*******************************************************************************/

{app/ap0512a.i3}

define temp-table tt-param-aux NO-UNDO
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
    field c-origem-ap      as char
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  
                                
/*--- Fim AP0512a.i ---*/
