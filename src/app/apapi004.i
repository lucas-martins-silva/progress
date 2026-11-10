/********************************************************************************
***
*** app/apapi004.i - API Previsäes Contas a Pagar (Defini‡Æo Temp-Table).
***
********************************************************************************/
        
def temp-table tt-tit-ap NO-UNDO
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo            LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo            as inte   format ">>9"
    &ENDIF
    field cod-fornec           as inte   format ">>>>>9"
    field cod-estabel          as char   format "x(3)"
    field cod-esp              as char   format "!!"
    field serie                as char   format "x(5)"
    field nr-docto             as char   format "x(16)"
    field parcela              as char   format "x(2)"
    field sequencia            as inte   format ">>>>>>>>9"
    field referencia           as char   format "x(10)"
    field portador             as inte   format ">>>>9"
    field modalidade           as inte   format "9" init 1
    field dt-emissao           as date   format "99/99/9999"
    field dt-vencimen          as date   format "99/99/9999"
    field moeda                as inte   format ">9"
    field cotacao-dia          as deci   format ">>>,>9.99999999" init 1
    field vl-original          as deci   format "->>>>>>>,>>9.99"
    field vl-orig-me           as deci   format "->>>,>>>,>>>,>>9.99"
    field valor-saldo          as deci   format "->>>>>>>,>>9.99"
    field vl-saldo-me          as deci   format ">>>>>>>,>>9.99"
    field tp-pagto             as inte   format "99" init 1
    field tp-codigo            as inte   format ">>9"
    field usuario              as char   format "x(12)"
    field observacao           as char   format "x(80)"
    INDEX codigo IS PRIMARY IS UNIQUE ep-codigo 
                                      cod-estabel
                                      cod-fornec
                                      cod-esp
                                      serie
                                      nr-docto
                                      parcela
                                      sequencia ASCENDING.
        
def temp-table tt-log-tit-ap NO-UNDO
    field ep-codigo            as inte   format ">>9"
    field cod-fornec           as inte   format ">>>>>9"
    field cod-estabel          as char   format "x(3)"
    field cod-esp              as char   format "!!"
    field serie                as char   format "x(5)"
    field nr-docto             as char   format "x(16)"
    field parcela              as char   format "x(2)"
    field descricao            as char   format "x(100)"
    INDEX codigo IS PRIMARY IS UNIQUE ep-codigo 
                                      cod-estabel
                                      cod-fornec
                                      cod-esp
                                      serie
                                      nr-docto
                                      parcela ASCENDING.
        
/* Fim de Include */

