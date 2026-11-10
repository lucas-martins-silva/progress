/********************************************************************************
***
*** app/ap506crp.i - Defini‡Æo TempTable.
***
********************************************************************************/

def temp-table tt-param
    field destino        as integer
    field arquivo        as char
    field usuario        as char
    field i-ep-codigo    like empresa.ep-codigo
    field data-exec      as date
    field hora-exec      as integer
    field classifica     as integer
    field cod-estabel    like mov-ap.cod-estabel
    field cod-esp        like mov-ap.cod-esp
    field serie          like mov-ap.serie
    field nr-docto       like mov-ap.nr-docto
    field parcela        like mov-ap.parcela
    field cod-fornec     like mov-ap.cod-fornec
    field portador       like mov-ap.portador
    field dt-transacao   like mov-ap.dt-transacao
    field conta-contabil like mov-ap.conta-contabil
    field nr-cheque      like mov-ap.nr-cheque
    field valor-mov      like mov-ap.valor-mov
    FIELD r-mov-ap       AS ROWID.

def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

/* Fim de Include */

