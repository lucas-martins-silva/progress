define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field i-empresa        as integer
    field i-port-ini       as integer
    field i-port-fim       as integer
    field c-nr-gps-ini     as char
    field c-nr-gps-fim     as char
    field i-forn-ini       as integer
    field i-forn-fim       as integer
    field dt-ini-vecto     as date
    field dt-fim-vecto     as date
    field i-listagem       as integer.
