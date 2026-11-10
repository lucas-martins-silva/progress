{include/i_dbvers.i}
/********************************************************************************
***
*** app/apapi001.i - TempTables Consistˆncia Implanta‡Æo Documentos.
***
********************************************************************************/

/*MINIFLEXIBILIZA€¶O */
{include/i_dbvers.i}
            
def temp-table tt-doc-i-ap NO-UNDO 
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo        LIKE empresa.ep-codigo
&ELSE
    field ep-codigo        as integer format ">>9"        init 0
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel      as char    format "x(05)"      init ""
&ELSE
    field cod-estabel      as char    format "x(03)"      init ""
&ENDIF
    field referencia       as char    format "x(10)"      init ""
    field cod-esp          as char    format "!!"         init ""
    field data-movto       as date    format "99/99/9999" init today
    field total-movto      as decimal format ">>>,>>>,>>>,>>9.99" init 0
    field mo-codigo        as integer format ">9"         init 0
    field log-1            as logical format "Sim/NÆo"    init no
    field ind-sit-lote-implantacao-ap as integer format ">9" init 1
    field cod-versao-integ as integer format "999"        init 0
    field ind-elimina-lote as integer format "99"         init 1  
          /* 1 - Elimina lote em caso de erro */
          /* 2 - Deixa pendente lote com erro */

    index codigo is primary unique ep-codigo
                                   referencia.          
          
def temp-table tt-lin-i-ap NO-UNDO
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo        LIKE empresa.ep-codigo
&ELSE
    field ep-codigo        as integer format ">>9"        initial 0
&ENDIF
    field referencia       as char    format "x(10)"      initial ""
    field sequencia        as integer format ">>>,>>9"    initial 0
    field serie            as char    format "x(05)"      initial 0
    field nr-docto         as char    format "x(16)"      initial "" 
    field parcela          as char    format "x(02)"      initial ""
    field cod-fornec       as integer format ">>>>>9"     initial 0
    field dt-emissao       as date    format "99/99/9999" initial today
    field dt-vencimen      as date    format "99/99/9999"      initial today
    field vl-original      as decimal format "->>>>>>>,>>9.99" initial 0
    field dt-desconto      as date    format "99/99/9999"      initial ?
    field vl-desconto      as decimal format ">>>>>>>,>>9.99"  initial 0
    field estado           as integer format "9"          initial 1
    field ct-debito        as char    format "x(20)"      initial ""
    field sc-debito        as char    format "x(20)"      initial ""
    field origem           as integer format ">9"         initial 1
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel      as char    format "x(05)"      initial ""
&ELSE
    field cod-estabel      as char    format "x(03)"      initial ""
&ENDIF
    field cod-portador     as integer format ">>>>9"      initial 0
    field modalidade       as integer format "9"          initial 1
    field cod-esp          as char    format "!!"         initial ""
    field perc-multa       as decimal format ">9.99"      initial 0
    field vl-juros         as decimal format ">>>>>>>,>>9.99" initial 0
    field seq-import       as integer format ">>>>>9"     initial 0
    field dt-transacao     as date    format "99/99/9999" initial ?
    field vl-imposto       as decimal format ">>>>>>>,>>9.99"  initial 0
    field perc-juros       as decimal format ">>9.99999"       initial 0
    field dias-atraso      as integer format ">>9"             initial 0
    field perc-mora        as decimal format ">>9.99999"       initial 0
    field observacao       as char    format "x(80)"           initial ""
    field cod-barras       as char    format "x(40)"           initial ""
    field valor-ir         as decimal format "->>>>>>>,>>9.99" initial 0
    field tp-codigo        as integer format ">>9"             initial 0
    field historico        as char    format "x(80)"           initial ""
    field hp-codigo        as integer format ">>9"             initial 0
    field mo-vl-titulo     as integer format ">9"              initial 1
    field cod-retencao     as integer format ">>>>9"           initial 0
    field nr-invoice       as integer format ">>>>,>>9"        initial 0
    field valor-fasb       as decimal format ">>>,>>>,>>9.99"  initial 0
    field valor-pres       as decimal format ">>>,>>>,>>9.99"  initial 0
    field valor-cmi        as decimal format ">>>,>>>,>>9.99"  initial 0
    field cod-controle     as char    format "x(15)"           initial ""
    field tem-hist         as logical format "Sim/NÆo"         initial no
    field vl-ir-antec      as decimal format "->>>>>>>,>>9.99" initial 0
    field num-ord-inv      as integer format ">>>,>>9"         initial 0
    field tp-pagto         as integer format "99"              initial 1
    field conta-debito     as char    format "x(17)"           initial ""
    field cod-cond-pag     as integer format ">>9"             initial 0
    field cod-tax          as integer format ">>>9"            initial 0
    field cotacao-dia      as decimal format ">>>,>9.99999999" initial 1
    field diversos         as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field dt-prev-pag      as date    format "99/99/9999"      initial ?
    field vl-taxa          as decimal format ">>>,>>>,>>>,>>9.99"  initial 0
    field vl-orig-me       as decimal format "->>>,>>>,>>>,>>9.99" initial 0
    field mo-codigo        as integer format ">9"              initial 0
    field frete            as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-isr           as decimal format ">>>,>>>,>>9.99"  initial 0
    field docum-est        as integer format ">>>>>>>9"        initial 0
    field nat-operac       as char    format "x(06)"           initial ""
    field tem-credito      as logical format "yes/no"          initial yes
    field tipo-mercad      as integer format "9"               initial 0
    field vl-liquido       as decimal format "->>>,>>>,>>9.99"  initial 0
    field saldo-isr        as decimal format "->>>,>>>,>>9.99"  initial 0
    field vl-desconto-me   as decimal format ">>>>>>>,>>9.99"   initial 0
    field diversos-me      as decimal format ">>>,>>>,>>>,>>9.99"  initial 0
    field frete-me         as decimal format ">>>,>>>,>>>,>>9.99"  initial 0
    field vl-imposto-me    as decimal format ">>>,>>>,>>>,>>9.99"  initial 0
    field vl-liquido-me    as decimal format "->>>,>>>,>>>,>>9.99" initial 0
    field vl-juros-me      as decimal format "->>>>>>>,>>9.99"  initial 0
    field sit-receb        as integer format ">9"               initial 1
    field valor-ir-me      as decimal format "->>>>>>>>,>>9.99"  initial 0
    field nr-docto-vinc    as char    format "x(16)"      initial ""
    field parcela-vinc     as char    format "x(02)"      initial ""
    field esp-vinc         as char    format "!!"         initial ""
    field fornec-vinc      as integer format ">>>>>9"     initial 0
    field serie-vinc       as char    format "x(05)"      initial ""
    field char-1           as char    format "x(100)"     initial ""
    field log-1            as logical format "Sim/NÆo"    initial no
    field pedido           as char    format "x(20)"      initial ""
    &if "{&mgadm_version}" >= "2.02" &then
        field cod-banco-forn      as integer   format "999"   initial 0
        field agencia-forn        as character format "x(08)" initial ""
        field conta-corrente-forn as character format "x(20)" initial ""
        field favorecido          as character format "x(40)" initial ""
    &endif
    index codigo is primary unique ep-codigo
                                   referencia
                                   sequencia
                                   seq-import
    index documento is unique ep-codigo
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela
                              cod-fornec.    
            
def temp-table tt-l-ant-ap NO-UNDO 
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo       LIKE empresa.ep-codigo
&ELSE
    field ep-codigo       as integer  format ">>9"      initial 0
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel     as char     format "x(05)"    initial ""
&ELSE
    field cod-estabel     as char     format "x(03)"    initial ""
&ENDIF
    field cod-esp         as char     format "!!"       initial ""
    field serie           as char     format "x(05)"    initial ""
    field nr-docto        as char     format "x(16)"    initial ""
    field parcela         as char     format "x(02)"    initial ""
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-cod-ant      LIKE empresa.ep-codigo
&ELSE
    field ep-cod-ant      as integer  format ">>9"      initial 0
&ENDIF
    field cod-est-ant     as char     format "x(03)"    initial 0
    field cod-esp-ant     as char     format "!!"       initial ""
    field serie-ant       as char     format "x(05)"    initial ""
    field nr-docto-ant    as char     format "x(16)"    initial ""
    field parcela-ant     as char     format "x(02)"    initial "" 
    field vl-antecip      as decimal  format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-ant-fasb     as decimal  format ">>>,>>>,>>>,>>9.99" initial 0
    field cod-fornec      as integer  format ">>>>>9"   initial 0
    field fornec-ant      as integer  format ">>>>>9"   initial 0
    field cod-for-doc     as integer  format ">>>>>9"   initial 0
    field cod-controle    as char     format "x(15)"    initial ""
    field antec-ir        as logical  format "Sim/NÆo"  initial no
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel-transf as char  format "x(05)"    initial ""
&ELSE
    field cod-estabel-transf as char  format "x(03)"    initial ""
&ENDIF
    field conta-transf    as char     format "x(17)"    initial ""
    field vl-antecip-me   as decimal  format ">>>>>>>,>>9.99" initial 0
    field mo-codigo       as integer  format ">9"       initial 0
    field cotacao-dia     as decimal  format ">>>,>9.99999999" initial 1
    field vl-var-monet    as decimal  format "->>,>>>,>>>,>>9.99" initial 0
    field vl-var-monet-antecip as decimal format "->>,>>>,>>>,>>9.99" initial 0
    field tipo            as integer  format ">9" initial 2
    field zera-saldo      as logical  format "Sim/NÆo"  initial no
    field cta-provisao    as char     format "x(17)"    initial ""
    field origem-antecip  as integer  format "9" initial 0
    index codigo is primary ep-codigo
                            cod-est-ant
                            cod-esp-ant
                            serie-ant
                            nr-docto-ant
                            parcela-ant
                            fornec-ant.
            
def temp-table tt-l-pre-ap NO-UNDO 
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo       LIKE empresa.ep-codigo
&ELSE
    field ep-codigo       as integer  format ">>9"      initial 0
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel     as char     format "x(05)"    initial ""
&ELSE
    field cod-estabel     as char     format "x(03)"    initial ""
&ENDIF
    field cod-esp         as char     format "!!"       initial ""
    field serie           as char     format "x(05)"    initial ""
    field nr-docto        as char     format "x(16)"    initial ""
    field parcela         as char     format "(02)"     initial ""
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-cod-pre      LIKE empresa.ep-codigo
&ELSE
    field ep-cod-pre      as integer  format ">>9"      initial 0
&ENDIF
    field cod-est-pre     as char     format "x(03)"    initial ""
    field cod-esp-pre     as char     format "!!"       initial ""
    field serie-pre       as char     format "x(05)"    initial ""
    field nr-docto-pre    as char     format "x(16)"    initial ""
    field parcela-pre     as char     format "x(02)"    initial ""
    field vl-previsao     as decimal  format ">>>,>>>,>>>,>>9.99" initial 0
    field moeda-pre       as integer  format ">9"       initial 0
    field cod-fornec      as integer  format ">>>>9"    initial 0
    field cod-controle    as char     format "x(15)"    initial ""
    field vl-previsao-me  as decimal  format ">>,>>>,>>>,>>9.99" initial 0
    index codigo is primary ep-cod-pre
                            cod-est-pre
                            cod-esp-pre
                            serie-pre
                            nr-docto-pre
                            parcela-pre
                            cod-fornec.
                                   
    
            
def temp-table tt-lin-conta-ap NO-UNDO
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo         LIKE empresa.ep-codigo
&ELSE
    field ep-codigo         as integer format ">>9"    initial 0
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel       as char    format "x(05)"  initial ""
&ELSE
    field cod-estabel       as char    format "x(03)"  initial ""
&ENDIF
    field cod-esp           as char    format "!!"     initial ""
    field serie             as char    format "x(05)"  initial ""
    field nr-docto          as char    format "x(16)"  initial ""
    field parcela           as char    format "x(02)"  initial ""
    field cod-fornec        as integer format ">>>>9"  initial 0
    field vl-movto          as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field ct-codigo         as char    format "x(20)"  initial ""
    field sc-codigo         as char    format "x(20)"  initial ""
    field vl-movto-presente as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field vl-movto-cmi      as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field vl-movto-fasb     as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field cod-controle      as char    format "x(15)" initial ""
    field conta-debito      as char    format "x(17)" initial ""
    field vl-movto-me       as decimal format ">>,>>>,>>>,>>9.99" initial 0
    
    field char-1            as char    format "x(100)" initial ""  /* Cont‚m o c¢digo da unidade de neg¢cio -
                                                                     utilizado na integra‡Æo com o EMS 5.O) */
    field log-tit-iva       as logical initial no
    index codigo is primary ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            nr-docto
                            parcela
                            cod-fornec.
    
            
def temp-table tt-impto-tit-pend-ap NO-UNDO
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo     LIKE empresa.ep-codigo    
&ELSE
    field ep-codigo     as integer format ">>9"     initial 0    
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel   as char    format "x(05)"   initial ""    
&ELSE
    field cod-estabel   as char    format "x(03)"   initial ""    
&ENDIF
    field serie         as char    format "x(05)"   initial ""
    field cod-esp       as char    format "!!"      initial ""    
    field nr-docto      as char    format "x(16)"   initial ""    
    field parcela       as char    format "x(02)"   initial ""
    field cod-fornec    as integer format ">>>>9"   initial 0    
    field vl-imposto    as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field ct-imposto    as char    format "x(20)"   initial ""
    field sc-imposto    as char    format "x(20)"   initial ""
    field conta-imposto as char    format "x(17)"   initial ""
    field cod-imposto   as integer format ">>>9"    initial 0
    field tipo          as integer format "99"      initial 1
    field contabilizou  as logical format "yes/no"  initial no
    field perc-imposto  as decimal format ">>>9.99" initial 0
    field dt-transacao  as date    format "99/99/9999" initial today
    field vl-base       as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field dt-emissao    as date    format "99/99/9999" initial today
    field obs           as char    format "x(2000)" initial ""
    field ind-data-base as integer format "9"       initial 1
    field vl-saldo-imposto as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field lancamento       as integer format ">9"      initial 1
    field ct-percepcao     as char    format "x(20)"   initial ""
    field sc-percepcao     as char    format "x(20)"   initial ""
    field conta-percepcao  as char    format "x(17)"   initial ""
    field vl-percepcao     as decimal format ">>>,>>>,>>>,>>9.99" initial 0   
    field ct-retencao      as char    format "x(20)"   initial ""
    field sc-retencao      as char    format "x(20)"   initial ""
    field conta-retencao   as char    format "x(17)"   initial ""
    field perc-retencao    as decimal format ">>>9.99" initial 0    
    field vl-retencao      as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field perc-percepcao   as decimal format ">>>9.99" initial 0    
    field vl-base-me       as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-imposto-me    as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-percepcao-me  as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-retencao-me   as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-saldo-imposto-me as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field mo-codigo        as integer format ">9"      initial 0
    field hp-codigo        as integer format ">>9"     initial 0
    field historico        as char    format "x(80)"   initial ""
    field cod-retencao     as integer format ">>>>9"   initial 0
    field dt-vencimen      as date    format "99/99/9999" initial today
    field tp-codigo        as integer format ">>9"     initial 0
    field num-seq-impto    as integer format ">>>>>>>>>9" initial 0
    field cotacao-dia      as decimal format ">>>,>9.99999999"    initial 1
    field vl-var-monet     as decimal format "->>,>>>,>>>,>>9.99" initial 0
    field origem-impto     as integer format ">9"       initial 0
    field num-id-pef-pend  as integer format "99999999" initial 0
    field cod-portador     as integer format ">>>>9"    initial 0
    field trans-impto-ap   as integer format ">9"       initial 0
    field vl-iva-liberado  as decimal format ">>>,>>>,>>>,>>9.99"    initial 0
    field vl-iva-liberado-me  as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field perc-iva-liberado   as decimal format ">>>9.99"    initial 0
    field ct-iva-liberado     as char    format "x(20)"      initial ""
    field sc-iva-liberado     as char    format "x(20)"      initial ""
    field conta-iva-liberado  as char    format "x(17)"      initial ""
    field conta-saldo-credito as char    format "x(17)"      initial ""
    field ct-saldo-credito    as char    format "x(20)"      initial ""
    field sc-saldo-credito    as char    format "x(20)"      initial ""
    field nat-operacao        as char    format "9.99-xxx"   initial ""
    field cod-classificacao   as integer format ">>9"        initial 0
    field ind-tipo-imposto    as integer format ">9"         initial 0
    field char-1              as char    format "x(100)"     initial ""
    field val-deduc-inss      as decimal format ">>,>>>,>>>,>>9.99"
    field val-deduc-depend    as decimal format ">>,>>>,>>>,>>9.99"
    field val-deduc-pensao    as decimal format ">>,>>>,>>>,>>9.99"
    field val-deduc-outras    as decimal format ">>,>>>,>>>,>>9.99"
    index codigo is primary ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            nr-docto
                            parcela
                            cod-fornec
                            cod-imposto
                            num-seq-impto
    index pef-pend num-id-pef-pend.                            
    
def temp-table tt-retorno-lin-i-ap no-undo
    field cod-erro   as character format "x(10)"
    field desc-erro  as character format "x(60)"
                        view-as editor max-chars 2000 
                        scrollbar-vertical size 50 by 4
    field situacao   as logical
    field cod-chave  as character
    INDEX ch-codigo  IS PRIMARY cod-erro
                                cod-chave.
        
/* Fim de Include */
