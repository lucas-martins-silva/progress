/*********************************************************************
***
*** app/ap0718.i - Defini‡Æo Temp-Table tt-param.
***
*********************************************************************/
/* y2kready */

def temp-table tt-param no-undo
    field destino          as int
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as int
    field classifica       as int
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo        as char
    &ELSE
    field ep-codigo        as int
    &ENDIF
    field i-for-ini        as int
    field i-for-fim        as int
    field c-estabel        as char
    field i-ano-base       as int
    field da-entrega       as date
    field c-responsavel    as char
    field i-tipo           as int
    field i-ir-pis         as int
    field c-complemento1   as char
    field cod-telefone     as char
    FIELD i-tipo-emit      AS INT.                                  .

/* Fim de Include */

