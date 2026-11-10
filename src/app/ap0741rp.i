/*******************************************************************************
***
*** app/ap0741rp.i - Defini‡Æo Temp_Table.
***
*******************************************************************************/
        
def {1} shared temp-table tt-mov-ap NO-UNDO
    field ep-codigo    AS CHAR FORMAT "x(3)"
    field cod-estabel  like mov-ap.cod-estabel
    field cod-fornec   like mov-ap.cod-fornec
    field cod-esp      like mov-ap.cod-esp
    field serie        like mov-ap.serie
    field nr-docto     like mov-ap.nr-docto
    field parcela      like mov-ap.parcela
    field moeda        like mov-ap.moeda
    field cod-gr-forn  like emitente.cod-gr-forn
    field nome-emit    AS CHAR FORMAT "x(40)"
    field matriz       like tit-ap.matriz
    field portador     like mov-ap.portador
    field modalidade   as character format "x(15)"
    field transacao    like mov-ap.transacao
    field referencia   like mov-ap.referencia
    field dt-transacao like mov-ap.dt-transacao
    field dt-vencimen  like mov-ap.dt-vencimen
    field dt-emissao   like mov-ap.dt-emissao
    field valor-mov    like mov-ap.valor-mov
    field esp-ant      like mov-ap.esp-ant
    field serie-ant    like mov-ap.serie-ant
    field docto-ant    like mov-ap.docto-ant
    field parc-ant     like mov-ap.parc-ant
    field vl-antecip   like mov-ap.vl-antecip
    field tipo         like mov-ap.tipo
    field lancamento   as integer
    field cod-lancto   as char format "x(02)"
    field des-erro     as character
    field row-mov-ap   as rowid
    INDEX class-1 ep-codigo
                  cod-fornec
                  dt-transacao
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela
    INDEX class-1a ep-codigo
                   moeda
                   cod-fornec
                   dt-transacao
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela
    INDEX class-2 ep-codigo
                  cod-gr-forn
                  cod-fornec
                  dt-transacao
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela
    INDEX class-2a ep-codigo
                   moeda
                   cod-gr-forn
                   cod-fornec
                   dt-transacao
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela
    INDEX class-3 ep-codigo
                  matriz
                  cod-fornec
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela
    INDEX class-3a ep-codigo
                   moeda
                   matriz
                   cod-fornec
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela
    INDEX class-4 ep-codigo
                  cod-esp
                  cod-fornec
                  dt-transacao
                  cod-estabel
                  serie
                  nr-docto
                  parcela
    INDEX class-4a ep-codigo
                   moeda
                   cod-esp
                   cod-fornec
                   dt-transacao
                   cod-estabel
                   serie
                   nr-docto
                   parcela
    INDEX class-5 ep-codigo
                  cod-fornec
                  cod-esp
                  dt-transacao
                  cod-estabel
                  serie
                  nr-docto
                  parcela
    INDEX class-5a ep-codigo
                   moeda
                   cod-fornec
                   cod-esp
                   dt-transacao
                   cod-estabel
                   serie
                   nr-docto
                   parcela.
            
def temp-table tt-erro-saldo-ant NO-UNDO
    field ep-codigo    like mov-ap.ep-codigo
    field cod-estabel  like mov-ap.cod-estabel
    field cod-fornec   like mov-ap.cod-fornec
    field cod-esp      like mov-ap.cod-esp
    field serie        like mov-ap.serie
    field nr-docto     like mov-ap.nr-docto
    field parcela      like mov-ap.parcela
    field des-erro     as character
    INDEX codigo ep-codigo
                 cod-estabel
                 cod-fornec
                 cod-esp
                 serie
                 nr-docto
                 parcela.

def {1} shared temp-table tt-espec-ap  NO-UNDO like espec-ap.
def {1} shared temp-table tt-emitente  NO-UNDO like emitente.
def {1} shared temp-table tt2-emitente NO-UNDO like emitente.
def {1} shared temp-table tt-tit-ap    NO-UNDO like tit-ap.
def {1} shared temp-table tt2-mov-ap   NO-UNDO like mov-ap.
                
/* Fim de Include */
