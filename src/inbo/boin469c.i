def temp-table tt-tempo-turno-ctrab NO-UNDO
    field cod-area          as char     format "x(12)"
    field gm-codigo         as char     format "x(9)"
    field cod-ctrab         as char     format "x(16)"
    field dat-inic          as date     format "99/99/9999"
    field qtd-segs-inic     as integer
    field dat-fim           as date     format "99/99/9999"
    field qtd-segs-fim      as integer
    field qtd-tempo-turno   as decimal  extent 10
    index id cod-ctrab.

def temp-table tt-tempo-turno NO-UNDO
    field cod-model-turno   as char     format "x(8)"
    field dat-inic          as date     format "99/99/9999"
    field qtd-segs-inic     as integer
    field dat-fim           as date     format "99/99/9999"
    field qtd-segs-fim      as integer
    field qtd-tempo-turno   as decimal  extent 10.
