/*******************************************************************************
***
*** app/ap0740rp.i - Defini‡Æo temp-table tt-tit-ap.
***
*******************************************************************************/
        
def temp-table tt-tit-ap NO-UNDO
    field ep-codigo       like tit-ap.ep-codigo
    field cod-estabel     like tit-ap.cod-estabel
    field cod-fornec      like tit-ap.cod-fornec
    field cod-esp         like tit-ap.cod-esp
    field serie           like tit-ap.serie
    field nr-docto        like tit-ap.nr-docto
    field parcela         like tit-ap.parcela
    field tipo            like tit-ap.tipo
    field referencia      like tit-ap.referencia
    field dt-emissao      like tit-ap.dt-emissao
    field dt-vencimen     like tit-ap.dt-vencimen
    field dia-vencto      as integer
    field mes-vencto      as integer
    field ano-vencto      as integer
    field moeda           as integer format ">9" column-label "MO"
    field valor-saldo     like tit-ap.valor-saldo format "->,>>>,>>>,>>9.99"
    field vl-original     like tit-ap.vl-original format "->,>>>,>>>,>>9.99"
    field historico       like mov-ap.historico
    field tp-pagto        like tit-ap.tp-pagto
    field nome-abrev      like emitente.nome-abrev
    field nome-emit       like emitente.nome-emit
    field cod-gr-forn     like emitente.cod-gr-forn
    field matriz          like tit-ap.matriz
    field des-erro        as char
    field transacao       as char format "x(04)" column-label "TRA"
    field row-tit-ap      as rowid
    field lancamento      as char format "x(02)"
    field lancamento1     as char format "x(02)"
    field conta-saldo     like conta-ap.conta-saldo
    INDEX class-1 ep-codigo
                  cod-fornec
                  ano-vencto
                  mes-vencto
                  dia-vencto
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela ASCENDING
    INDEX class-1a ep-codigo
                   moeda
                   cod-fornec
                   ano-vencto
                   mes-vencto
                   dia-vencto
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela ASCENDING
    INDEX class-2 ep-codigo
                  nome-abrev
                  cod-fornec
                  ano-vencto
                  mes-vencto
                  dia-vencto
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela ASCENDING
    INDEX class-2a ep-codigo
                   moeda
                   nome-abrev
                   cod-fornec
                   ano-vencto
                   mes-vencto
                   dia-vencto
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela ASCENDING
    INDEX class-3 ep-codigo
                  nome-emit
                  cod-fornec
                  ano-vencto
                  mes-vencto
                  dia-vencto
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela ASCENDING
    INDEX class-3a ep-codigo
                   moeda
                   nome-emit
                   cod-fornec
                   ano-vencto
                   mes-vencto
                   dia-vencto
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela ASCENDING
    INDEX class-4 ep-codigo
                  matriz
                  cod-fornec
                  ano-vencto
                  mes-vencto
                  dia-vencto
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela ASCENDING
    INDEX class-4a ep-codigo
                   moeda
                   matriz
                   cod-fornec
                   ano-vencto
                   mes-vencto
                   dia-vencto
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela ASCENDING
    INDEX class-5 ep-codigo
                  cod-esp
                  cod-fornec
                  ano-vencto
                  mes-vencto
                  dia-vencto
                  cod-estabel
                  serie
                  nr-docto
                  parcela ASCENDING
    INDEX class-5a ep-codigo
                   moeda
                   cod-esp
                   cod-fornec
                   ano-vencto
                   mes-vencto
                   dia-vencto
                   cod-estabel
                   serie
                   nr-docto
                   parcela ASCENDING
    INDEX class-6 ep-codigo
                  tp-pagto
                  cod-fornec
                  ano-vencto
                  mes-vencto
                  dia-vencto
                  cod-estabel
                  cod-esp
                  serie
                  nr-docto
                  parcela ASCENDING
    INDEX class-6a ep-codigo
                   moeda
                   tp-pagto
                   cod-fornec
                   ano-vencto
                   mes-vencto
                   dia-vencto
                   cod-estabel
                   cod-esp
                   serie
                   nr-docto
                   parcela ASCENDING
    INDEX class-7  ep-codigo
                   conta-saldo
                   cod-esp
                   cod-gr-forn
                   cod-fornec
                   nr-docto
                   parcela
    INDEX class-7a ep-codigo
                   moeda
                   conta-saldo
                   cod-esp
                   cod-gr-forn
                   cod-fornec
                   nr-docto
                   parcela.
                    
def temp-table tt-resumo-conta NO-UNDO  
    field ep-codigo         like conta-ap.ep-codigo
    field conta-saldo       like conta-ap.conta-saldo
    field titulo            like conta-contab.titulo
    field de-contas-pagar   as decimal format "->>,>>>,>>>,>>9.99"
    field de-contabilidade  as decimal format "->>,>>>,>>>,>>9.99"
    field de-diferenca      as decimal format "->>,>>>,>>>,>>9.99"
    INDEX codigo ep-codigo
                 conta-saldo.
                 
/* Fim de Include */
