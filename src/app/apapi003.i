/********************************************************************************
***
*** app/apapi003.i - Temp-Tables API Liquida‡Æo de Documentos AP.
***
********************************************************************************/

/*** Miniflexibiliza‡Æo ***/
{cdp/cdcfgfin.i}

def temp-table tt-doc-b-ap NO-UNDO
    field ep-codigo        as integer format ">>9"   initial 0
    field referencia       as char    format "x(10)" initial ""
    field cod-estabel      as char    format "x(03)" initial ""
    field cod-esp          as char    format "!!"    initial ""
    field data-movto       as date    format "99/99/9999"         initial today
    field total-movto      as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field mo-codigo        as integer format ">9"    initial 0
    field ind-sit-lote-liquidacao-ap as integer format ">9"       initial 1    
    field cod-versao-integ as integer format "999"   initial 0
    field ind-elimina-lote as integer format "99"    initial 1
    index codigo is primary unique ep-codigo
                                   referencia.  
          /* 1 - Elimina lote em caso de erro */
          /* 2 - Deixa pendente lote com erro */
          
def temp-table tt-lin-b-ap NO-UNDO
    field ep-codigo        as integer  format ">>9"     initial 0
    field referencia       as char     format "x(10)"   initial ""
    field sequencia        as integer  format ">>,>>9"  initial 0
    field transacao        as integer  format ">9"      initial 1
    field serie            as char     format "x(05)"   initial ""
    field nr-docto         as char     format "x(16)"   initial ""
    field parcela          as char     format "x(02)"   initial ""
    field nr-cheque        as decimal  format ">>>>>>>>9"    initial 0
    field dt-baixa         as date     format "99/99/9999"   initial today
    field vl-baixa         as decimal  format ">>>>>>>,>>9.99" initial 0
    field vl-desconto      as decimal  format ">>>>>>>,>>9.99" initial 0
    field vl-juros         as decimal  format ">>>>>>>,>>9.99" initial 0
    &if defined(BF_FIN_MULTA_ABATIMENTO) &then
    field vl-abatimento    as decimal format ">>>>>>>,>>9.99" initial 0
    field vl-multa         as decimal format ">>>>>>>,>>9.99" initial 0
    field vl-abatimento-me as decimal format ">>>>>>>,>>9.99" initial 0
    field vl-multa-me      as decimal format ">>>>>>>,>>9.99" initial 0
    &endif
    field portador         as integer  format ">>>>9"   initial 0
    field cod-esp          as char     format "!!"      initial ""
    field cod-estabel      as char     format "x(03)"   initial ""
    field cod-fornec       as integer  format ">>>>>9"  initial 0
    field nominal          as integer  format ">9"      initial 1
    field favorecido       as char     format "x(50)"   initial ""
    field valor-ir         as decimal  format ">>>>>>>,>>9.99" initial 0
    field cod-controle     as char     format "x(15)"   initial ""
    field origem           as integer  format ">9"      initial 1
    field vl-correcao      as decimal  format "->>>,>>>,>>9.99" initial 0
    field nr-docto-banco   as char     format "x(16)"   initial ""
    field cotacao-dia      as decimal  format ">>>,>9.99999999" initial 1
    field dt-desconto      as date     format "99/99/9999" initial today
    field dt-vencimen      as date     format "99/99/9999" initial today
    field historico        as char     format "x(50)"      initial ""
    field mo-codigo        as integer  format ">9"         initial 0
    field vl-dif-camb      as decimal  format "->>>,>>>,>>>,>>>,>>9.99" initial 0
    field bvl-orig-me      as decimal  format "->>>,>>>,>>>,>>>,>>9.99" initial 0
    field estado           as integer  format "9"          initial 1
    field vl-baixa-me      as decimal  format "->>>,>>>,>>>,>>>,>>9.99" initial 0
    field vl-desconto-me   as decimal  format ">>>>>>>,>>9.99" initial 0
    field vl-juros-me      as decimal  format ">>>>>>>,>>9.99" initial 0
    field cod-retencao     as integer  format ">>>>9"          initial 0
    field hp-codigo        as integer  format ">>9"            initial 0
    field cod-est-ant      as char     format "x(03)"          initial ""
    field cod-esp-ant      as char     format "!!"             initial ""
    field serie-ant        as char     format "x(05)"          initial ""
    field nr-docto-ant     as char     format "x(16)"          initial ""
    field parcela-ant      as char     format "x(02)"          initial ""
    field fornec-ant       as integer  format ">>>>>9"         initial 0
    field conta-debito     as char     format "x(17)"          initial ""
    field tp-codigo        as integer  format ">>9"            initial 0
    field vl-ir-antec      as decimal  format "->>>>>>>,>>9.99" initial 0
    field dt-venc-cheque   as date     format "99/99/9999"     initial today
    field ind-liberado-pag as logical format "yes/no"         initial no
    field int-2            as integer  format "->>>>>>>>>9"   initial 0 /* Modalidade */
    index codigo is primary unique ep-codigo
                                   referencia
                                   sequencia.
    
def temp-table tt-l-ant-ap NO-UNDO
    field ep-codigo            as integer  format ">>9"                initial 0
    field cod-estabel          as char     format "x(03)"              initial ""
    field cod-esp              as char     format "!!"                 initial ""
    field serie                as char     format "x(05)"              initial ""
    field nr-docto             as char     format "x(16)"              initial ""
    field parcela              as char     format "x(02)"              initial ""
    field ep-cod-ant           as integer  format ">>9"                initial 0
    field cod-est-ant          as char     format "x(03)"              initial 0
    field cod-esp-ant          as char     format "!!"                 initial ""
    field serie-ant            as char     format "x(05)"              initial ""
    field nr-docto-ant         as char     format "x(16)"              initial ""
    field parcela-ant          as char     format "x(02)"              initial "" 
    field vl-antecip           as decimal  format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-ant-fasb          as decimal  format ">>>,>>>,>>>,>>9.99" initial 0
    field cod-fornec           as integer  format ">>>>>9"             initial 0
    field fornec-ant           as integer  format ">>>>>9"             initial 0
    field cod-for-doc          as integer  format ">>>>>9"             initial 0
    field cod-controle         as char     format "x(15)"              initial ""
    field antec-ir             as logical  format "Sim/NÆo"            initial no
    field cod-estabel-transf   as char     format "x(03)"              initial ""
    field conta-transf         as char     format "x(17)"              initial ""
    field vl-antecip-me        as decimal  format ">>>>>>>,>>9.99"     initial 0
    field mo-codigo            as integer  format ">9"                 initial 0
    field cotacao-dia          as decimal  format ">>>,>9.99999999"    initial 1
    field vl-var-monet         as decimal  format "->>,>>>,>>>,>>9"    initial 0
    field vl-var-monet-antecip as decimal  format "->>,>>>,>>>,>>9"    initial 0
    field origem-antecip       as integer  format "9"                  initial 0
    index codigo is primary ep-codigo
                            cod-est-ant
                            cod-esp-ant
                            serie-ant
                            nr-docto-ant
                            parcela-ant
                            fornec-ant.
            
def temp-table tt-l-pre-ap NO-UNDO
    field ep-codigo       as integer  format ">>9"                initial 0
    field cod-estabel     as char     format "x(03)"              initial ""
    field cod-esp         as char     format "!!"                 initial ""
    field serie           as char     format "x(05)"              initial ""
    field nr-docto        as char     format "x(16)"              initial ""
    field parcela         as char     format "(02)"               initial ""
    field ep-cod-pre      as integer  format ">>9"                initial 0
    field cod-est-pre     as char     format "x(03)"              initial ""
    field cod-esp-pre     as char     format "!!"                 initial ""
    field serie-pre       as char     format "x(05)"              initial ""
    field nr-docto-pre    as char     format "x(16)"              initial ""
    field parcela-pre     as char     format "x(02)"              initial ""
    field vl-previsao     as decimal  format ">>>,>>>,>>>,>>9.99" initial 0
    field moeda-pre       as integer  format ">9"                 initial 0
    field cod-fornec      as integer  format ">>>>9"              initial 0
    field cod-controle    as char     format "x(15)"              initial ""
    field vl-previsao-me  as decimal  format ">>,>>>,>>>,>>9.99"  initial 0
    index codigo is primary ep-cod-pre
                            cod-est-pre
                            cod-esp-pre
                            serie-pre
                            nr-docto-pre
                            parcela-pre
                            cod-fornec.


def temp-table tt-lin-conta-ap NO-UNDO
    field ep-codigo         as integer format ">>9"    initial 0
    field cod-estabel       as char    format "x(03)"  initial ""
    field cod-esp           as char    format "!!"     initial ""
    field serie             as char    format "x(05)"  initial ""
    field nr-docto          as char    format "x(16)"  initial ""
    field parcela           as char    format "x(02)"  initial ""
    field cod-fornec        as integer format ">>>>9"  initial 0
    field vl-movto          as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field ct-codigo         as char    format "x(08)"  initial ""
    field sc-codigo         as char    format "x(08)"  initial ""
    field vl-movto-presente as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field vl-movto-cmi      as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field vl-movto-fasb     as decimal format ">>,>>>,>>>,>>9.99" initial 0
    field cod-controle      as char    format "x(15)" initial ""
    field conta-debito      as char    format "x(17)" initial ""
    field vl-movto-me       as decimal format ">>,>>>,>>>,>>9.99" initial 0
    index codigo is primary ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            nr-docto
                            parcela
                            cod-fornec.
    
            
def temp-table tt-impto-tit-pend-ap NO-UNDO
    field ep-codigo     as integer format ">>9"     initial 0    
    field cod-estabel   as char    format "x(03)"   initial ""    
    field serie         as char    format "x(05)"   initial ""
    field cod-esp       as char    format "!!"      initial ""    
    field nr-docto      as char    format "x(16)"   initial ""    
    field parcela       as char    format "x(02)"   initial ""
    field cod-fornec    as integer format ">>>>9"   initial 0    
    field vl-imposto    as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field ct-imposto    as char    format "x(08)"   initial ""
    field sc-imposto    as char    format "x(08)"   initial ""
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
    field ct-percepcao     as char    format "x(08)"   initial ""
    field sc-percepcao     as char    format "x(08)"   initial ""
    field conta-percepcao  as char    format "x(17)"   initial ""
    field vl-percepcao     as decimal format ">>>,>>>,>>>,>>9.99" initial 0   
    field ct-retencao      as char    format "x(08)"   initial ""
    field sc-retencao      as char    format "x(08)"   initial ""
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
    field ct-iva-liberado     as char    format "x(08)"      initial ""
    field sc-iva-liberado     as char    format "x(08)"      initial ""
    field conta-iva-liberado  as char    format "x(17)"      initial ""
    field conta-saldo-credito as char    format "x(17)"      initial ""
    field ct-saldo-credito    as char    format "x(08)"      initial ""
    field sc-saldo-credito    as char    format "x(08)"      initial ""
    field nat-operacao        as char    format "9.99-xxx"   initial ""
    field cod-classificacao   as integer format ">>9"        initial 0
    field ind-tipo-imposto    as integer format ">9"         initial 0
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



def temp-table tt-retorno-lin-b-ap NO-UNDO
    field cod-erro   as character format "x(10)"
    field desc-erro  as character format "x(60)"
                        view-as editor max-chars 2000 
                        scrollbar-vertical size 50 by 4
    field situacao   as logical
    field cod-chave  as character
    INDEX ch-codigo  IS PRIMARY cod-erro
                                cod-chave.

/* Fim de Include */
