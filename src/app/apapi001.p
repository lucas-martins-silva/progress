/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i APAPI001 2.00.00.043}  /*** 010043 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i apapi001 MAP}
&ENDIF

/****************************************************************************
***
*** app/apapi001.p - Implanta‡Æo Documentos AP.
***
****************************************************************************/
/*MINIFLEXIBILIZA€¶O */
{include/i_dbvers.i}

/*------- Defini‡Æo TempTable --------*/
{app/apapi001a.i}

def temp-table tt-lin-i-ap-old
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
    field ct-debito        as char    format "x(08)"      initial ""
    field sc-debito        as char    format "x(08)"      initial ""
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
    field tem-hist         as logical format "Sim/Não"         initial no
    field vl-ir-antec      as decimal format "->>>>>>>,>>9.99" initial 0
    field num-ord-inv      as integer format ">>>,>>9"         initial 0
    field tp-pagto         as integer format "99"              initial 1
    field conta-debito     as char    format "x(17)"           initial ""
    field cod-cond-pag     as integer format ">>9"             initial 0
    field cod-tax          as integer format ">>>9"            initial 0
    field cotacao-dia      as decimal format ">>>,>9.99999999" initial 1
    field diversos         as decimal format ">>>,>>>,>>>,>>9" initial 0
    field dt-prev-pag      as date    format "99/99/9999"      initial ?
    field vl-taxa          as decimal format ">>>,>>>,>>>,>>9" initial 0
    field vl-orig-me       as decimal format "->>>,>>>,>>>,>>" initial 0
    field mo-codigo        as integer format ">9"              initial 0
    field frete            as decimal format ">>>,>>>,>>>,>>9" initial 0
    field vl-isr           as decimal format ">>>,>>>,>>9.99"  initial 0
    field docum-est        as integer format ">>>>>>>9"        initial 0
    field nat-operac       as char    format "x(06)"           initial ""
    field tem-credito      as logical format "yes/no"          initial yes
    field tipo-mercad      as integer format "9"               initial 0
    field vl-liquido       as decimal format "->>>,>>>,>>9.99"  initial 0
    field saldo-isr        as decimal format "->>>,>>>,>>9.99"  initial 0
    field vl-desconto-me   as decimal format ">>>>>>>,>>9.99"   initial 0
    field diversos-me      as decimal format ">>>,>>>,>>>,>>9"  initial 0
    field frete-me         as decimal format ">>>,>>>,>>>,>>9"  initial 0
    field vl-imposto-me    as decimal format ">>>,>>>,>>>,>>9"  initial 0
    field vl-liquido-me    as decimal format "->>>,>>>,>>>,>>9" initial 0
    field vl-juros-me      as decimal format "->>>>>>>,>>9.99"  initial 0
    field sit-receb        as integer format ">9"               initial 1
    field valor-ir-me      as decimal format "->>>>>>>>,>>9.9"  initial 0
    field nr-docto-vinc    as char    format "x(16)"      initial ""
    field parcela-vinc     as char    format "x(02)"      initial ""
    field esp-vinc         as char    format "!!"         initial ""
    field fornec-vinc      as integer format ">>>>>9"     initial 0
    field serie-vinc       as char    format "x(05)"      initial ""
    field char-1           as char    format "x(100)"     initial ""
    field log-1            as logical format "Sim/Não"    initial no
    field pedido           as char    format "x(20)"      initial ""
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
            
def temp-table tt-l-ant-ap-old
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
    field antec-ir        as logical  format "Sim/Não"  initial no
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel-transf as char  format "x(05)"    initial ""
&ELSE
    field cod-estabel-transf as char  format "x(03)"    initial ""
&ENDIF
    field conta-transf    as char     format "x(17)"    initial ""
    field vl-antecip-me   as decimal  format ">>>>>>>,>>9.99" initial 0
    field mo-codigo       as integer  format ">9"       initial 0
    field cotacao-dia     as decimal  format ">>>,>9.99999999" initial 1
    field vl-var-monet    as decimal  format "->>,>>>,>>>,>>9" initial 0
    field vl-var-monet-antecip as decimal format "->>,>>>,>>>,>>9" initial 0
    field tipo            as integer  format ">9" initial 2
    field zera-saldo      as logical  format "Sim/Não"  initial no
    field cta-provisao    as char     format "x(17)"    initial ""
    field origem-antecip  as integer  format "9" initial 0
    index codigo is primary ep-codigo
                            cod-est-ant
                            cod-esp-ant
                            serie-ant
                            nr-docto-ant
                            parcela-ant
                            fornec-ant.

/*------ Defini‡Æo Parƒmetros --------*/
def input  param table for tt-doc-i-ap.
def input  param table for tt-lin-i-ap-old.
def input  param table for tt-l-ant-ap-old.
def input  param table for tt-l-pre-ap.
def input  param table for tt-lin-conta-ap.
def input  param table for tt-impto-tit-pend-ap.
def output param table for tt-retorno-lin-i-ap.

/*------ Defini‡Æo Vari veis ---------*/
define var h-apapi001a as handle no-undo.

for each tt-lin-i-ap-old:
    create tt-lin-i-ap.
    BUFFER-COPY tt-lin-i-ap-old to tt-lin-i-ap no-error.
end.

for each tt-l-ant-ap-old:
    create tt-l-ant-ap.
    BUFFER-COPY tt-l-ant-ap-old to tt-l-ant-ap no-error.
end.

run app/apapi001a.p persistent set h-apapi001a.
run execute in h-apapi001a (input  table tt-doc-i-ap,
                            input  table tt-lin-i-ap,
                            input  table tt-l-ant-ap,
                            input  table tt-l-pre-ap,
                            input  table tt-lin-conta-ap,
                            input  table tt-impto-tit-pend-ap,
                            output table tt-retorno-lin-i-ap).


delete procedure h-apapi001a.

return 'OK'.

/* Fim de Programa */
