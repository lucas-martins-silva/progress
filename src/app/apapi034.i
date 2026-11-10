/********************************************************************************
***
*** app/apapi001.i - TempTables API Substitui‡Æo NF por DP.
***
********************************************************************************/

{cdp/cd0666.i}

def temp-table tt-parametros
    field tt-referencia            as char        format "x(10)"
    field tt-da-transacao          as date        format "99/99/9999"
    field tt-mo-codigo             as integer     format ">9"
    field tt-cotacao-dia           as decimal     format ">,>>>,>>9.999999"
    field tt-tp-subst              as integer
    field tt-gera-autoriza         as logical
    field cod-versao-integ         as integer     format "999"        init 0.


def temp-table tt-notas
    field tt-ep-codigo             as integer     format ">>9"
    field tt-cod-estabel           as char        format "x(3)"
    field tt-cod-esp               as char        format "!!"
    field tt-serie                 as char        format "x(5)"
    field tt-nr-docto              as char        format "x(16)"
    field tt-parcela               as char        format "x(2)"
    field tt-cod-fornec            as integer     format ">>>>>>>>9"
    field tt-nome-abrev            like tit-ap.nome-abrev
    field tt-cod-port              like tit-ap.portador
    field tt-dt-emissao            like tit-ap.dt-emissao
    field tt-dt-vencimen           like tit-ap.dt-vencimen
    field tt-dt-desconto           like tit-ap.dt-desconto
    field tt-vl-desconto           like tit-ap.vl-desconto
    field tt-vl-saldo              as decimal     format ">>,>>>,>>>,>>9.99"
    field tt-referencia            like tit-ap.referencia
    field tt-selecionado           as logical
    field tt-row-id-tit-ap         as rowid
    field tt-vl-juros              like mov-ap.valor-juros
    INDEX notas-id IS UNIQUE PRIMARY tt-ep-codigo
                                             tt-cod-estabel
                                             tt-cod-esp
                                             tt-serie
                                             tt-nr-docto
                                             tt-parcela
                                             tt-cod-fornec ASCENDING.

def temp-table tt-duplicatas
    field tt-dup-ep-codigo             as integer     format ">>9"
    field tt-dup-cod-estabel           as char        format "x(3)"
    field tt-dup-cod-esp               as char        format "!!"
    field tt-dup-serie                 as char        format "x(5)"
    field tt-dup-nr-docto              as char        format "x(16)"
    field tt-dup-parcela               as char        format "x(2)"
    field tt-dup-dt-emissao            as date        format "99/99/9999"
    field tt-dup-dt-vencimen           as date        format "99/99/9999"
    field tt-dup-vl-original           as decimal     format ">>,>>>,>>>,>>9.99"
    field tt-dup-dt-desconto           as date        format "99/99/9999"
    field tt-dup-vl-desconto           as decimal     format ">>>>>>>,>>9.99"
    field tt-dup-cod-fornec            as integer     format ">>>>>>>>9"
    field tt-dup-nome-abrev            as char        format "X(12)"
    field tt-dup-cod-port              as integer     format ">>>>9"
    field tt-dup-modalidade            as integer     format "9"
    field tt-dup-tp-codigo             as integer     format ">>9"
    field tt-dup-mo-codigo             as integer     format ">9"
    field tt-dup-i-hist-padrao         as integer     format ">>9"
    field tt-dup-desc-historico        as char        format "x(80)"
    field tt-dup-row-dup               as rowid
    INDEX duplicatas-id IS UNIQUE PRIMARY tt-dup-ep-codigo
                                         tt-dup-cod-estabel
                                         tt-dup-cod-esp
                                         tt-dup-serie
                                         tt-dup-nr-docto
                                         tt-dup-parcela 
                                         tt-dup-cod-fornec ASCENDING.


/* fim include */
