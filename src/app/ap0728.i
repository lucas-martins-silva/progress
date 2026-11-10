define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field c-ini-est        as char
    field c-fim-est        as char
    field c-ini-esp        as char
    field c-fim-esp        as char
    field i-ini-ret        as integer
    field i-fim-ret        as integer
    field i-ini-for        as integer
    field i-fim-for        as integer
    field dt-ini-vecto     as date
    field dt-fim-vecto     as date
    field i-listagem       as integer
    field i-competencia    as integer
    field d-valor          as decimal
    field l-imp-par        as logical.
