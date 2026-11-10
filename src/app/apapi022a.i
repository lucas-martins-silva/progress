/********************************************************************************
***
*** app/apapi022.i - API Antecipa‡äes Contas a Pagar (Defini‡Æo Temp-Table).
***
********************************************************************************/
        
/* Criada tt-antecip-base para nÆo estourar liminte defini‡Æo temp-table */
def temp-table tt-antecip-base no-undo  
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo            LIKE empresa.ep-codigo 
    &ELSE
    field ep-codigo            as int format ">>9"
    &ENDIF
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel           as char format "x(05)"    
    &ELSE
    field cod-estabel           as char format "x(03)"
    &ENDIF
    field cod-esp               as char format "!!"
    field serie                 as char format "x(05)"
    field nr-docto              as char format "x(16)"
    field parcela               as char format "x(02)"
    field cod-fornec            as int  format ">>>>>>>>9"
    field transacao             as int  format ">9"
    field referencia            as char format "x(10)"
    field dt-transacao          as date format "99/99/9999"
    field dt-emissao            as date format "99/99/9999"
    field dt-vencimen           as date format "99/99/9999"
    field valor-saldo           as dec  format "->>>>>>>,>>9.99"
    field ct-conta-for          as char format "x(08)"
    field sc-conta-for          as char format "x(08)"
    field dt-desconto           as date format "99/99/9999"
    field vl-desconto           as dec  format ">>>>>>>,>>9.99"
    field vl-original           as dec  format "->>>>>>,>>9.99"
    field dt-ult-pagto          as date format "99/99/9999"
    field ct-conta-db           as char format "x(08)"
    field sc-conta-db           as char format "x(08)"
    field lancamento            as int  format ">9"
    field dt-prev-pag           as date format "99/99/9999"
    field pedido                as char format "x(12)"
    field estado                as int  format "9"
    field observacao            as char format "x(80)"
    field portador              as int  format ">>>>9"
    field moeda                 as int  format ">9"
    field origem                as int  format ">9"
    field tipo                  as int  format ">9"
    field nr-cheque             as dec  format ">>>>>>>>9"
    field nr-bordero            as int  format ">>>>>>>9"
    field emissao-bord          as log  format "Sim/Nao"
    field atualiza-bor          as log  format "Sim/Nao"
    field modalidade            as int  format "9"
    field esp-ant               as char format "!!"
    field serie-ant             as char format "x(05)"
    field docto-ant             as char format "x(16)"
    field parc-ant              as char format "x(02)"
    field perc-multa            as dec  format ">9.99"
    field vl-juros-dia          as dec  format ">>>>>>>,>>9.99"
    field vl-sal-fasb           as dec  format "->>>>>>>,>>9.99"
    field vl-desc-fasb          as dec  format ">>>>>>>,>>9.99"
    field jur-dia-fasb          as dec  format ">>>,>>>,>>>,>>9.99"
    field vl-orig-fasb          as dec  format "->>>>>>>,>>9.99"
    field inst-banc             as char format "x(60)"
    field nome-abrev            as char format "x(12)"
    field cod-barras            as char format "x(40)"
    field dt-fluxo              as date format "99/99/9999"
    field nr-fluxo              as int  format ">>>>9"
    field matriz                as int  format ">>>>>>>>9"
    field vl-imposto            as dec  format ">>>>>>>,>>9.99"
    field dias-atraso           as int  format ">>9"
    field perc-mora             as dec  format ">>9.99999"
    field perc-juros            as dec  format ">>9.99999"
    field vl-fluxo              as dec  format ">>>>>>>,>>9.99"
    field calcula-fasb          as log  format "Sim/Nao"
    field calcula-cmi           as log  format "Sim/Nao"
    field taxa-emis-fasb        as dec  format ">>>,>>>,>>9.9999"
    field taxa-vencto-fasb      as dec  format ">>>,>>>,>>9.9999"
    field taxa-emis-cmi         as dec  format ">>>,>>>,>>9.99999999"
    field cgc                   as char format "x(19)"
    field taxa-emis-ambid       as dec  format ">>>,>>9.99999999"
    field valor-ir              as dec  format ">>>>>>>,>>9.99"
    field tp-codigo             as int  format ">>9"
    field dt-vencto-ori         as date format "99/99/9999"
    field cond-pagto            as int  format ">>9"
    field vl-desc-conf          as dec  format ">>>>>>>,>>9.99"
    field vl-juros-conf         as dec  format ">>>>>>>,>>9.99"
    field dt-desc-conf          as date format "99/99/9999"
    field moeda-org             as int  format ">9"
    field enviado               as log  format "Sim/Nao"
    field titulo-banco          as char format "x(20)"
    field cod-banco             as int  format "999"
    field cod-retencao          as int  format ">>>>9"
    field vl-var-monet          as dec  format "->>>>>>>,>>9.99"
    field dt-vecto-orig         as date format "99/99/9999"
    field nr-invoice            as int  format ">>>>,>>9"
    field ip-aliquota           as dec  format ">>9.99"
    field arq-remessa           as char format "x(20)"
    field ins-banc              as int  format ">>9"
    field emitiu                as log  format "Sim/Nao"
    field vl-ir-antec           as dec  format "->>>>>>>,>>9.99"
    field dt-liq                as date format "99/99/9999"
    field ir-antec              as log  format "Sim/Nao"
    field num-ord-inv           as int  format ">>>,>>9"
    field tp-pagto              as int  format "99"
    field conta-debito          as char format "x(12)"
    field conta-fornecedor      as char format "x(17)"
    field cod-tax               as int  format ">>>9"
    field cotacao-dia           as dec  format ">>>,>9.99999999"
    field diversos              as dec  format ">>>,>>>,>>>,>>9.99"
    field docum-est             as int  format ">>>>>>>9"
    field frete                 as dec  format ">>>,>>>,>>>,>>9.99"
    field nat-operac            as char format "x(06)"
    field tem-credito           as log  format "Sim/Nao"
    field tipo-mercad           as int  format "9"
    field ult-seq               as int  format ">>>>>>>>>9"
    field vl-dif-camb           as dec  format "->>>,>>>,>>>,>>9.99"
    field vl-isr                as dec  format ">>>,>>>,>>9.99"
    field vl-liquido            as dec  format "->>>,>>>,>>9.99"
    field vl-orig-me            as dec  format "->>>,>>>,>>>,>>9.99"
    field vl-taxa               as dec  format ">>>,>>>,>>>,>>9.99"
    field vl-saldo-me           as dec  format ">>>>>>>,>>9.99"
    field vl-desconto-me        as dec  format ">>>>>>>,>>9.99"
    field vl-taxa-me            as dec  format ">>>,>>>,>>>,>>9.99"
    field vl-liquido-me         as dec  format "->>>,>>>,>>>,>>9.99"
    field saldo-isr             as dec  format "->>>,>>>,>>9.99"
    field diversos-me           as dec  format ">>>,>>>,>>>,>>9.99"
    field frete-me              as dec  format ">>>,>>>,>>>,>>9.99"
    field sit-receb             as int  format ">9"
    field nr-docto-vinc         as char format "x(16)"
    field parcela-vinc          as char format "x(02)"
    field fornec-vinc           as int  format ">>>>>>>>9"
    field esp-vinc              as char format "!!"
    field serie-vinc            as char format "x(05)"
    field cod-impto-ret         as int  format ">>9"
    field char-1                as char format "x(100)"
    field char-2                as char format "x(100)"
    field dec-1                 as dec  format "->>>>>>>>>>>9.99999999"
    field dec-2                 as dec  format "->>>>>>>>>>>9.99999999"
    field int-1                 as int  format "->>>>>>>>>9"
    field int-2                 as int  format "->>>>>>>>>9"
    field log-1                 as log  format "Sim/NÆo"
    field log-2                 as log  format "Sim/NÆo"
    field data-1                as date format "99/99/9999"
    field data-2                as date format "99/99/9999"
    field autorizacao           as int  format ">>9"
    field ind-ir                as log  format "Sim/NÆo"
    field vl-juros-dia-me       as dec  format ">>>>>>>,>>9.99"
    field check-sum             as char format "x(20)".

def temp-table tt-antecip no-undo like tt-antecip-base
    field cod-banco-forn        as int  format "999"
    field agencia-forn          as char format "x(08)"
    field conta-corrente-forn   as char format "x(20)"
    field favorecido            as char format "x(50)"
    field vl-juros-tot          as dec  format ">>>>>>>,>>9.99"
    field vl-juros-tot-me       as dec  format ">>>>>>>,>>9.99"
    field vl-desconto-tot       as dec  format ">>>>>>>,>>9.99"
    field vl-desconto-tot-me    as dec  format ">>>>>>>,>>9.99"
    field vl-abatimento-tot     as dec  format ">>>>>>>,>>9.99"
    field vl-multa-tot          as dec  format ">>>>>>>,>>9.99"
    field vl-multa-tot-me       as dec  format ">>>>>>>,>>9.99"
    field vl-abatimento-tot-me  as dec  format ">>>>>>>,>>9.99"
    field leitora               as log  format "Sim/NÆo"
    field usuario               as char format "x(12)"
    field sequencia             as int    
    field cod-versao-integracao as int  format "999"
    field cod-esp-ir            as char format "!!"
    field serie-ir              as char format "x(05)"
    field nr-docto-ir           as char format "x(16)"
    field parcela-ir            as char format "x(02)"
    field vencto-ir             as date format "99/99/9999"
    field tp-codigo-ir          as int  format ">>9"
    field conta-debito-ir       as char format "x(12)"
    field de-tributavel         as dec 
    field de-aliquota           as dec
    field de-original-ir        as dec
    field cod-hist-ir           as int
    field historico-ir          as char
    field cod-imposto-ir        as int
    field informa-ir            as log 
    field cod-hist              as int
    field historico             as char
    field nominal               as int
    field literal               as char
    field tipo-implantacao      as integer
    field numero-ordem          as int 
    field seq-evento            as int 
    field nr-adiant-eec         as int
    field de-inss               as decimal
    field de-depend             as decimal
    field de-pensao             as decimal
    field de-outras             as decimal
    INDEX codigo IS PRIMARY IS UNIQUE ep-codigo 
                                      cod-estabel
                                      cod-fornec
                                      cod-esp
                                      serie
                                      nr-docto
                                      parcela
                                      sequencia ASCENDING.

def temp-table tt-antecip-1 no-undo like tt-antecip
    field cod-unid-negoc as char format "x(3)" INITIAL "".

def temp-table tt-previsao NO-UNDO
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo     LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo     as int format ">>9"                    
    &ENDIF
    &IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel   as char format "x(05)"
    &ELSE
    field cod-estabel   as char format "x(03)"
    &ENDIF
    field cod-esp       as char format "!!"
    field serie         as char format "x(05)"
    field nr-docto      as char format "x(16)"
    field parcela       as char format "x(02)"
    field cod-fornec    as int  format ">>>>>>>>9"
    field moeda         as int  format ">9"
    field vl-saldo      as dec  format ">>>>>>>,>>9.99"
    field vl-utlzdo     as dec  format ">>>>>>>,>>9.99"
    field estab-ant     as char format "x(03)"
    field esp-ant       as char format "!!"
    field serie-ant     as char format "x(05)"
    field docto-ant     as char format "x(16)"
    field parc-ant      as char format "x(02)"
    index codigo ep-codigo 
                 estab-ant
                 cod-fornec
                 esp-ant
                 serie-ant
                 docto-ant
                 parc-ant.
            
def temp-table tt-log-tit-ap no-undo
    field cod-chave  as char   
    field cod-erro   as int  format ">>>>>9"    
    field tipo-erro  as int  initial 1 /* 1 - ERRO ; 2 - ADVERTÒNCIA */
    field descricao  as char format "x(100)".
                                      
        
/* Fim de Include apapi022.i */
