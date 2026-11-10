/*******************************************************************************
***
*** app/apapi017.i - Temp_Table's API Integra‡Æo Nota D‚bito/Cr‚dito.
***
*******************************************************************************/
        
def temp-table tt-nota-debito-credito NO-UNDO
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character   format "x(03)"
    &ENDIF
    field cod-esp           as character   format "x(02)"
    field serie             as character   format "x(05)"
    field cod-fornec        as integer     format ">>>>>>>>9"
    field nr-docto          as character   format "x(16)"
    field parcela           as character   format "x(02)"
    field referencia        as character   format "x(10)"
    field dt-emissao        as date        format "99/99/9999"
    field dt-transacao      as date        format "99/99/9999"
    field portador          as integer     format ">>>>9"
    field tp-codigo         as integer     format ">>9"
    field conta-debito      as character   format "x(17)"
    field moeda             as integer     format ">9"
    field cotacao-dia       as decimal     format ">>>,>9.99999999"
    field vl-orig-me        as decimal     format ">>>,>>>,>>>,>>9.99"
    field diversos-me       as decimal     format ">>>,>>>,>>>,>>9.99"
    field frete-me          as decimal     format ">>>,>>>,>>>,>>9.99"
    field observacao        as character   format "x(80)"
    field usuario           as character   format "x(12)"
    field cod-versao-integ  as integer     format "999"
    field cod-programa      as character   format "x(10)"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
        
def temp-table tt-documento-original NO-UNDO
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character   format "x(03)"
    &ENDIF
    field cod-esp           as character   format "x(02)"
    field serie             as character   format "x(05)"
    field cod-fornec        as integer     format ">>>>>>>>9"
    field nr-docto          as character   format "x(16)"
    field parcela           as character   format "x(02)"
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo-orig    LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo-orig    as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel-orig  LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel-orig  as character   format "x(03)"
    &ENDIF
    field cod-esp-orig      as character   format "x(02)"
    field serie-orig        as character   format "x(05)"
    field cod-fornec-orig   as integer     format ">>>>>>>>9"
    field nr-docto-orig     as character   format "x(16)"
    field parcela-orig      as character   format "x(02)"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
        
def temp-table tt-conta-debito NO-UNDO
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character   format "x(03)"
    &ENDIF
    field cod-esp           as character   format "x(02)"
    field serie             as character   format "x(05)"
    field cod-fornec        as integer     format ">>>>>>>>9"
    field nr-docto          as character   format "x(16)"
    field parcela           as character   format "x(02)"
    field conta-debito      as character   format "x(17)"
    field titulo            as character   format "x(32)"
    field vl-movto          as decimal     format ">>>,>>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
        
def temp-table tt-imposto NO-UNDO
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character   format "x(03)"
    &ENDIF
    field cod-esp           as character   format "x(02)"
    field serie             as character   format "x(05)"
    field cod-fornec        as integer     format ">>>>>>>>9"
    field nr-docto          as character   format "x(16)"
    field parcela           as character   format "x(02)"
    field cod-imposto       as integer     format ">>>9"
    field perc-imposto      as decimal     format ">>>9.99"
    field perc-retencao     as decimal     format ">>>9.99"
    field perc-percepcao    as decimal     format ">>>9.99"
    field vl-base-me        as decimal     format ">>>,>>>,>>>,>>9.99"
    field vl-imposto-me     as decimal     format ">>>,>>>,>>>,>>9.99"
    field vl-retencao-me    as decimal     format ">>>,>>>,>>>,>>9.99"
    field vl-percepcao-me   as decimal     format ">>>,>>>,>>>,>>9.99"
    field conta-imposto     as character   format "x(17)"
    field conta-retencao    as character   format "x(17)"
    field conta-percepcao   as character   format "x(17)"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
            
def temp-table tt-novo-documento NO-UNDO
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character   format "x(03)"
    &ENDIF
    field cod-esp           as character   format "x(02)"
    field serie             as character   format "x(05)"
    field cod-fornec        as integer     format ">>>>>>>>9"
    field nr-docto          as character   format "x(16)"
    field parcela           as character   format "x(02)"
    field nr-docto-nov      as character   format "x(16)"
    field parcela-nov       as character   format "x(02)"
    field observacao        as character   format "x(80)"
    field cod-esp-ligac     as character   format "x(02)"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
        
def temp-table tt-retorno-erro NO-UNDO
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo         as integer     format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel       LIKE estabelec.cod-estabel
    &ELSE
    field cod-estabel       as character   format "x(03)"
    &ENDIF
    field cod-esp           as character   format "x(02)"
    field serie             as character   format "x(05)"
    field cod-fornec        as integer     format ">>>>>>>>9"
    field nr-docto          as character   format "x(16)"
    field parcela           as character   format "x(02)"
    field cod-erro          as integer     format ">>>>>>>>9"
    field desc-erro         as character   format "x(80)"
    field identificacao     as character   format "x(30)"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
            
/* Fim de Include */

