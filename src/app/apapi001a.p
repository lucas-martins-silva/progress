/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i APAPI001A 2.00.00.028 } /*** 010028 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i apapi001a MAP}
&ENDIF

/****************************************************************************
***
*** app/apapi001a.p - Implanta‡Æo Documentos AP.
***
****************************************************************************/

/*MINIFLEXIBILIZA€¶O */
{include/i_dbvers.i}

/*------- Defini‡Æo TempTable --------*/
{app/apapi001b.i}

def temp-table tt-impto-tit-pend-ap-old
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
    field char-1              as char    format "x(100)"     initial ""
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

procedure execute:

    /*------ Defini‡Æo Parƒmetros --------*/
    def INPUT  param table for tt-doc-i-ap.
    def INPUT  param table for tt-lin-i-ap.
    def INPUT  param table for tt-l-ant-ap.
    def INPUT  param table for tt-l-pre-ap.
    def INPUT  param table for tt-lin-conta-ap.
    def INPUT  param table for tt-impto-tit-pend-ap-old.
    def OUTPUT param table for tt-retorno-lin-i-ap.

/*------ Defini‡Æo Vari veis ---------*/
define var h-apapi001b as handle no-undo.

for each tt-impto-tit-pend-ap-old:
    create tt-impto-tit-pend-ap.
    BUFFER-COPY tt-impto-tit-pend-ap-old to tt-impto-tit-pend-ap no-error.
end.

run app/apapi001b.p persistent set h-apapi001b.
run execute in h-apapi001b (input  table tt-doc-i-ap,
                            input  table tt-lin-i-ap,
                            input  table tt-l-ant-ap,
                            input  table tt-l-pre-ap,
                            input  table tt-lin-conta-ap,
                            input  table tt-impto-tit-pend-ap,
                            output table tt-retorno-lin-i-ap).


delete procedure h-apapi001b.

END PROCEDURE.

return 'OK'.

/* Fim de Programa */



