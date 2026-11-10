/*******************************************************************************
***
*** app/ap050jb.i - Defini‡Æo Temp-Tables.
***
*******************************************************************************/

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field rw-tit-ap        as rowid.

define temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

/* Fim de Include */
