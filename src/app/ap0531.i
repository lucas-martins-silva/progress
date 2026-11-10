/************************************************************************
***
*** app/ap0531.i - Defini‡Æo temp-table tt-param.
***
************************************************************************/

def temp-table tt-param
    field destino               as int
    field arquivo               as char
    field usuario               as char
    field data-exec             as date
    field hora-exec             as int
    field classifica            as int
    field ep-codigo             as int
    field l-gera-saldo          as log
    field da-ta-ini             as date
    field da-ta-fim             as date
    field c-esp-inss            like espec-ap.cod-esp
    FIELD l-elimina-reg-manual  AS LOGICAL
    FIELD minimo-rend           AS DEC.


/* Fim de Include */
