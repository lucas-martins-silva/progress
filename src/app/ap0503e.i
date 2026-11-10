def temp-table tt-retorno-erro no-undo
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer   format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character format "x(03)"
    &ENDIF
    field cod-esp           as character format "x(02)"
    field serie             as character format "x(05)"
    field nr-docto          as character format "x(16)"
    field parcela           as character format "x(02)"
    field cod-erro          as integer   format ">>>>>>>>9"
    field desc-erro         as character format "x(200)"
    field tipo              as char      format "x(5)". 

