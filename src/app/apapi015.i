/**********************************************************************************
**
**  apapi015.i
**
**  Defini‡Æo de temp-tables.
**
**********************************************************************************/

{app/ap0514.i}
{cdp/cd0666.i}

def temp-table tt-param-nom no-undo
    field ep-codigo           like mov-ap.ep-codigo
    field portador            like mov-ap.portador
    field nr-cheque           like mov-ap.nr-cheque
    field dt-venc-cheq        like mov-ap.dt-vencimen
    field c-literal           as char format "x(50)"
    field c-nominal           as char
    field l-vid-rel           as logical
    field cod-versao-integ    as int.


def temp-table tt-impto-tit-pend-ap
    field ep-codigo           as integer format ">>9"     initial 0    
    field cod-estabel         as char    format "x(03)"   initial ""    
    field serie               as char    format "x(05)"   initial ""
    field cod-esp             as char    format "!!"      initial ""    
    field nr-docto            as char    format "x(16)"   initial ""    
    field parcela             as char    format "x(02)"   initial ""
    field cod-fornec          as integer format ">>>>9"   initial 0    
    field vl-imposto          as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field ct-imposto          as char    format "x(08)"   initial ""
    field sc-imposto          as char    format "x(08)"   initial ""
    field conta-imposto       as char    format "x(17)"   initial ""
    field cod-imposto         as integer format ">>>9"    initial 0
    field tipo                as integer format "99"      initial 1
    field contabilizou        as logical format "yes/no"  initial no
    field perc-imposto        as decimal format ">>>9.99" initial 0
    field dt-transacao        as date    format "99/99/9999" initial today
    field vl-base             as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field dt-emissao          as date    format "99/99/9999" initial today
    field obs                 as char    format "x(2000)" initial ""
    field ind-data-base       as integer format "9"       initial 1
    field vl-saldo-imposto    as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field lancamento          as integer format ">9"      initial 1
    field ct-percepcao        as char    format "x(08)"   initial ""
    field sc-percepcao        as char    format "x(08)"   initial ""
    field conta-percepcao     as char    format "x(17)"   initial ""
    field vl-percepcao        as decimal format ">>>,>>>,>>>,>>9.99" initial 0   
    field ct-retencao         as char    format "x(08)"   initial ""
    field sc-retencao         as char    format "x(08)"   initial ""
    field conta-retencao      as char    format "x(17)"   initial ""
    field perc-retencao       as decimal format ">>>9.99" initial 0    
    field vl-retencao         as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field perc-percepcao      as decimal format ">>>9.99" initial 0    
    field vl-base-me          as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-imposto-me       as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-percepcao-me     as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-retencao-me      as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field vl-saldo-imposto-me as decimal format ">>>,>>>,>>>,>>9.99" initial 0
    field mo-codigo           as integer format ">9"      initial 0
    field hp-codigo           as integer format ">>9"     initial 0
    field historico           as char    format "x(80)"   initial ""
    field cod-retencao        as integer format ">>>>9"   initial 0
    field dt-vencimen         as date    format "99/99/9999" initial today
    field tp-codigo           as integer format ">>9"     initial 0
    field num-seq-impto       as integer format ">>>>>>>>>9" initial 0
    field cotacao-dia         as decimal format ">>>,>9.99999999"    initial 1
    field vl-var-monet        as decimal format "->>,>>>,>>>,>>9.99" initial 0
    field origem-impto        as integer format ">9"       initial 0
    field num-id-pef-pend     as integer format "99999999" initial 0
    field cod-portador        as integer format ">>>>9"    initial 0
    field trans-impto-ap      as integer format ">9"       initial 0
    field vl-iva-liberado     as decimal format ">>>,>>>,>>>,>>9.99"    initial 0
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

def temp-table tt-antecip NO-UNDO
    FIELD estabelec     AS CHAR  
    field cod-esp       AS CHAR
    FIELD serie         AS CHAR 
    FIELD nr-docto      AS CHAR
    FIELD parcela       AS CHAR
    FIELD fornec        AS INT 
    FIELD estabelec-ant AS CHAR 
    FIELD cod-esp-ant   AS CHAR 
    FIELD serie-ant     AS CHAR 
    FIELD nr-docto-ant  AS CHAR  
    FIELD parcela-ant   AS CHAR 
    FIELD fornec-ant    AS INT 
    FIELD nr-cheque     AS INT 
    FIELD dt-antecip    AS DATE 
    FIELD vl-antecip    AS DEC 
    field confirma      AS LOG  
    field rw-antecip    AS ROWID 
    FIELD estado        AS INT 
    FIELD gravado       AS LOG    
    FIELD antecip-IR    AS LOG.
