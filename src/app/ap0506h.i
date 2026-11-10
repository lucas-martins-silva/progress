/********************************************************************************
***
*** app/ap506h.i - Defini‡Æo TempTable.
***
********************************************************************************/

{cdp/cdcfgfin.i}


def temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field cod-estabel      like mov-ap.cod-estabel
    field cod-esp          like mov-ap.cod-esp
    field serie            like mov-ap.serie
    field nr-docto         like mov-ap.nr-docto
    field parcela          like mov-ap.parcela
    field cod-fornec       like mov-ap.cod-fornec
    field lancamento       like mov-ap.lancamento
    field valor-mov        like mov-ap.valor-mov
    field dt-transacao     like mov-ap.dt-transacao
    field conta-contabil   like mov-ap.conta-contabil
    field i-opcao          as integer
    field referencia       like mov-ap.referencia
    field seq-enc-contas   as integer 
    .
        
def temp-table tt-raw-digita
    field raw-digita       as raw.

/* Fim de Include */

