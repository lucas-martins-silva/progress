/*******************************************************************
***
*** app/ap0727.i - Defini‡Æo TempTable.
***
*******************************************************************/
/* y2kready */

def temp-table tt-param no-undo
    field destino          as int
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as int
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo        as char
    &ELSE
    field ep-codigo        as int
    &ENDIF
    field c-estabel        as char
    field i-for-ini        as int
    field i-for-fim        as int
    field i-gru-ini        as int
    field i-gru-fim        as int
    field i-ano-base       as int
    field da-entrega       as date
    field c-responsavel    as char
    field i-tipo           as integer
    field c-telefone       as char
    field c-complemento1   as char.

/* Fim de Include */

