/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR0041 2.00.00.011 } /*** "010011" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bcr0041 MBC}
&ENDIF

/*****************************************************************************
**
**       Programa: bcr0041.p
**
**       Data....: 03/09/98
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Relat½rio de C½digo £nico
**
**       Vers’o..: 1.00.000 - bc
**
**       OBS.....: Este fonte foi gerado pelo Data Viewer
**
*******************************************************************************/

/****************** Defini»’o de Tabelas Temporÿrias do Relat½rio **********************/

{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */
{include/i_fnctrad.i} 

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

define temp-table tt-param NO-UNDO
    field destino              as integer
    field arquivo              as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field v_num_tip_aces_usuar as integer
    field ep-codigo        like empresa.ep-codigo
    field c-cod-estabel-ini like bc-ext-saldo-estoq.cod-estabel
    field c-cod-estabel-fim like bc-ext-saldo-estoq.cod-estabel
    field c-cod-depos-ini like bc-ext-saldo-estoq.cod-depos
    field c-cod-depos-fim like bc-ext-saldo-estoq.cod-depos
    field c-it-codigo-ini like bc-ext-saldo-estoq.it-codigo
    field c-it-codigo-fim like bc-ext-saldo-estoq.it-codigo
    field c-cod-unico-ini like bc-ext-saldo-estoq.cod-unico
    field c-cod-unico-fim like bc-ext-saldo-estoq.cod-unico
.

/****************** INCLUDE COM VARIµVEIS GLOBAIS *********************/
{utp/ut-glob.i}
/*** Fim ut-glob.i Defini‡Æo de vari veis globais ***/ /****************** FIM INCLUDE COM VARIµVEIS GLOBAIS *********************/
/****************** Defini»ao de Par³metros do Relat½rio *********************/ 

/****************** Defini»ao de Variÿveis de Sele»’o do Relat½rio *********************/ 

&IF "{&mguni_version}" >= "2.071" &THEN
def new shared var c-cod-estabel-ini like bc-ext-saldo-estoq.cod-estabel format "x(05)" initial "" no-undo.
&ELSE
def new shared var c-cod-estabel-ini like bc-ext-saldo-estoq.cod-estabel format "x(3)" initial "" no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def new shared var c-cod-estabel-fim like bc-ext-saldo-estoq.cod-estabel format "x(05)" initial "ZZZZZ" no-undo.
&ELSE
def new shared var c-cod-estabel-fim like bc-ext-saldo-estoq.cod-estabel format "x(3)" initial "ZZZ" no-undo.
&ENDIF
def new shared var c-cod-depos-ini like bc-ext-saldo-estoq.cod-depos format "x(3)" initial "" no-undo.
def new shared var c-cod-depos-fim like bc-ext-saldo-estoq.cod-depos format "x(3)" initial "ZZZ" no-undo.
def new shared var c-it-codigo-ini like bc-ext-saldo-estoq.it-codigo format "x(16)" initial "" no-undo.
def new shared var c-it-codigo-fim like bc-ext-saldo-estoq.it-codigo format "x(16)" initial "ZZZZZZZZZZZZZZZZ" no-undo.
def new shared var c-cod-unico-ini like bc-ext-saldo-estoq.cod-unico format "x(16)" initial "" no-undo.
def new shared var c-cod-unico-fim like bc-ext-saldo-estoq.cod-unico format "x(16)" initial "ZZZZZZZZZZZZZZZZ" no-undo.

/****************** Defini»ao de Variÿveis p/ Campos Virtuais do Relat½rio *******************/ 

/****************** Defini»ao de Variÿveis Campo do Layout do Relat½rio **********************/ 

def var c-deposito as character.
def var c-desc-item as character.
Def Var v-Ltr      As Character No-undo.
Def Var v-Ltr1     As Character No-undo.

/****************** Defini»ao de Variÿveis do Relat½rio N’o Pedidas em Tela ******************/ 

/****************** Defini»ao de Variÿveis de Total do Relat½rio *****************************/ 

/****************** Defini»ao de Variÿveis dos Calculos do Relat½rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Defini»ao de Variÿveis de Processamento do Relat½rio *********************/

def var h-bcr004a as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.

/****************** Defini»ao de Forms do Relat½rio 132 Colunas ***************************************/ 

form bc-ext-saldo-estoq.cod-unico column-label "£nico" format "x(16)" at 002
     bc-ext-saldo-estoq.it-codigo column-label "Item" format "x(16)" at 019
     c-desc-item column-label "Descri‡Æo Item" format "x(34)" at 036
&IF "{&mguni_version}" >= "2.071" &THEN
     bc-ext-saldo-estoq.cod-estabel column-label "Est" format "x(05)" at 071
&ELSE
     bc-ext-saldo-estoq.cod-estabel column-label "Est" format "x(3)" at 071
&ENDIF
     bc-ext-saldo-estoq.cod-depos column-label "Dep" format "x(3)" at 075
     c-deposito column-label "Descri‡Æo Dep¢sito" format "x(30)" at 079
     bc-ext-saldo-estoq.cod-localiz column-label "Localiz" format "x(20)" at 112
     bc-ext-saldo-estoq.lote column-label "Lote/S‚rie" format "x(40)" at 002
     with down width 132 no-box stream-io frame f-relat-09-132.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-09-132:Handle).
&ENDIF

create tt-param.
raw-transfer raw-param to tt-param.


def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format 'x(80)'
    index editor-id is primary unique 
          linha.

/* In¡cio i-rpvar */
{include/i-rpvar.i}
/* Fim i-rpvar */
{utp/ut-liter.i Relat¢rio_de_C¢digo_£nico *}
assign c-programa     = "bcr0041"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = Return-value.
{utp/ut-liter.i Coleta_de_Dados *}
Assign c-sistema      = Return-value.

if  tt-param.formato = 2 then do:

    /* In­cio i-rpcab.i */

   &IF  "{&stream}" = "" &THEN

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       "Folha:" at 122 page-number  at 128 format ">>>>9" skip
       fill("-", 112) format "x(110)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabec.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
            Run utp/ut-trfrrp.p (input Frame f-cabec:Handle).
   &ENDIF

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       "Folha:" at 122 page-number  at 128 format ">>>>9" skip
       "Periodo:" i-numper-x at 10 "-"
       da-iniper-x at 15 "a" da-fimper-x
       fill("-", 74) format "x(72)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabper.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
            If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
                Run utp/ut-trfrrp.p (input Frame f-cabper:Handle).
   &ENDIF

   &ELSE

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       "Folha:" at 122 page-number({&stream})  at 128 format ">>>>9" skip
       fill("-", 112) format "x(110)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabec.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
            Run utp/ut-trfrrp.p (input Frame f-cabec:Handle).
   &ENDIF

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       "Folha:" at 122 page-number({&stream})  at 128 format ">>>>9" skip
       "Periodo:" i-numper-x at 10 "-"
       da-iniper-x at 15 "a" da-fimper-x
       fill("-", 74) format "x(72)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabper.
    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
            Run utp/ut-trfrrp.p (input Frame f-cabper:Handle).
    &ENDIF

   &ENDIF

   c-rodape = "DATASUL - " + c-sistema + " - " + c-programa + " - V:" + c-versao + "." + c-revisao.
   c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

   form header
       c-rodape format "x(132)"
       with stream-io width 132 no-labels no-box page-bottom frame f-rodape.

   /* Fim i-rpcab.i */
end. /* tt-param.formato = 2 */

/*** In¡cio i-rpout.i ***/
{include/i-rpout.i}
/*** Fim i-rpout.i ***/

    assign i-ep-codigo-usuario = tt-param.ep-codigo
           v_cdn_empres_usuar  = i-ep-codigo-usuario.

    assign c-cod-estabel-ini = tt-param.c-cod-estabel-ini
           c-cod-estabel-fim = tt-param.c-cod-estabel-fim
           c-cod-estabel-fim = tt-param.c-cod-estabel-fim
           c-cod-depos-ini = tt-param.c-cod-depos-ini
           c-cod-depos-fim = tt-param.c-cod-depos-fim
           c-it-codigo-ini = tt-param.c-it-codigo-ini
           c-it-codigo-fim = tt-param.c-it-codigo-fim
           c-cod-unico-ini = tt-param.c-cod-unico-ini
           c-cod-unico-fim = tt-param.c-cod-unico-fim
.

&GLOB LANGUAGE-CODE POR 
/* Inicio var00002.i */

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Impressora
&glob val2 Arquivo
&glob val3 Terminal
&ENDIF

&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Impresora
&glob val2 Archivo
&glob val3 Terminal
&ENDIF

&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Printer
&glob val2 File
&glob val3 Terminal
&ENDIF
&if "{&val11}" <> "" &then
    &message *** ({&file-name}): Para indicadores com mais de 10 items deve ser usado o include ind11-50.i !
&endif

&if  ("{1}" = "04" or "{1}" = "4") and "{2}" = "" &then
    &message *** ({&file-name}): Para a funcao ITEM deve ser especificado o valor !
    &message *** Exemplo: ind01-10.i 04 1
&endif

&if  ("{1}" = "06"  or "{1}" = "6") and  "{2}" = "" &then
    &message *** ({&file-name}): Para a funcao IND deve ser especificado o elemento !
    &message *** Exemplo: ind01-10.i 06 string

&endif

&if  lookup("{1}", "03,04,05,06,3,4,5,6") &then
     &scop lista-items {&val1}
     &if  "{&val2}" <> "" &then
          &scop lista-items {&lista-items},{&val2}
     &endif
     &if  "{&val3}" <> "" &then
          &scop lista-items {&lista-items},{&val3}
     &endif
     &if  "{&val4}" <> "" &then
          &scop lista-items {&lista-items},{&val4}
     &endif
     &if  "{&val5}" <> "" &then
          &scop lista-items {&lista-items},{&val5}
     &endif
     &if  "{&val6}" <> "" &then
          &scop lista-items {&lista-items},{&val6}
     &endif
     &if  "{&val7}" <> "" &then
          &scop lista-items {&lista-items},{&val7}
     &endif
     &if  "{&val8}" <> "" &then
          &scop lista-items {&lista-items},{&val8}
     &endif
     &if  "{&val9}" <> "" &then
          &scop lista-items {&lista-items},{&val9}
     &endif
     &if  "{&val10}" <> "" &then
          &scop lista-items {&lista-items},{&val10}
     &endif
&endif

&if "{1}" = "01" or "{1}" = "1" &then
    "{&val1}"
    &if "{&val2}" <> "" &then
        , "{&val2}"
    &endif
    &if "{&val3}" <> "" &then
        , "{&val3}"
    &endif
    &if "{&val4}" <> "" &then
        , "{&val4}"
    &endif
    &if "{&val5}" <> "" &then
        , "{&val5}"
    &endif
    &if "{&val6}" <> "" &then
        , "{&val6}"
    &endif
    &if "{&val7}" <> "" &then
        , "{&val7}"
    &endif
    &if "{&val8}" <> "" &then
        , "{&val8}"
    &endif
    &if "{&val9}" <> "" &then
        , "{&val9}"
    &endif
    &if "{&val10}" <> "" &then
        , "{&val10}"
    &endif
&endif

&if  "{1}" = "02" or "{1}" = "2" &then
    "{&val1}", 1
    &if "{&val2}" <> "" &then
         , "{&val2}", 2
    &endif
    &if "{&val3}" <> "" &then
         , "{&val3}", 3    
    &endif
    &if "{&val4}" <> "" &then
         , "{&val4}", 4    
    &endif
    &if "{&val5}" <> "" &then
         , "{&val5}", 5    
    &endif
    &if "{&val6}" <> "" &then
         , "{&val6}", 6    
    &endif
    &if "{&val7}" <> "" &then
         , "{&val7}", 7    
    &endif
    &if "{&val8}" <> "" &then
         , "{&val8}", 8    
    &endif
    &if "{&val9}" <> "" &then
         , "{&val9}", 9    
    &endif
    &if "{&val10}" <> "" &then
         , "{&val10}", 10    
    &endif
&endif

&if  "{1}" = "03"  or "{1}" = "3" &then
     '{&lista-items}'
&endif

&if  "{1}" = "05" or "{1}" = "5" &then
     num-entries("{&lista-items}")
&endif

&if "{1}" = "04" or "{1}" = "4" &then
     entry({2}, "{&lista-items}")
&endif


&if  ("{1}" = "06" or "{1}" = "6") and "{2}" <> "" &then
     lookup({2}, "{&lista-items}")
&endif

&if "{1}" = "07" or "{1}" = "7" &then
    &if "{2}" <> "" &then
        assign {2}:list-items = "{&val1}".
        &if defined(val2) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val2}".
        &endif
        &if defined(val3) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val3}".
        &endif
        &if defined(val4) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val4}".
        &endif
        &if defined(val5) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val5}".
        &endif
        &if defined(val6) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val6}".
        &endif
        &if defined(val7) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val7}".
        &endif
        &if defined(val8) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val8}".
        &endif
        &if defined(val9) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val9}".
        &endif
        &if defined(val10) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val10}".
        &endif
    &endif
&endif

&if defined(lista-items) > 0 &then
    &undefine lista-items
&endif
&if defined(val1) > 0 &then
    &undefine val1
&endif
&if defined(val2) > 0 &then
    &undefine val2
&endif
&if defined(val3) > 0 &then
    &undefine val3
&endif
&if defined(val4) > 0 &then
    &undefine val4
&endif
&if defined(val5) > 0 &then
    &undefine val5
&endif
&if defined(val6) > 0 &then
    &undefine val6
&endif
&if defined(val7) > 0 &then
    &undefine val7
&endif
&if defined(val8) > 0 &then
    &undefine val8
&endif
&if defined(val9) > 0 &then
    &undefine val9
&endif
&if defined(val10) > 0 &then
    &undefine val10
&endif

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

/* for each e disp */

def var l-imprime as logical no-undo.

assign l-imprime = no.
if  tt-param.destino = 1
then
    assign v-cod-destino-impres = "Impressora".
else
    if  tt-param.destino = 2
    then
        assign v-cod-destino-impres = "Arquivo".
    else
        assign v-cod-destino-impres = "Terminal".

Run utp/ut-liter.p (input v-cod-destino-impres,"*","").
Assign v-cod-destino-impres = Return-value.

{utp/ut-liter.i "Descri‡Æo Item" * L}
assign c-desc-item:label = trim(return-value).
{utp/ut-liter.i "Descri‡Æo Dep¢sito" * L}
assign c-deposito:label = trim(return-value).
run utp/ut-acomp.p persistent set h-bcr004a.
{utp/ut-liter.i C¢digo_£nico *}
run pi-inicializar in h-bcr004a(input Return-value).

assign v-num-reg-lidos = 0.

for each bc-ext-saldo-estoq no-lock
         where bc-ext-saldo-estoq.cod-depos >= c-cod-depos-ini and 
               bc-ext-saldo-estoq.cod-depos <= c-cod-depos-fim and
               bc-ext-saldo-estoq.cod-estabel >= c-cod-estabel-ini and 
               bc-ext-saldo-estoq.cod-estabel <= c-cod-estabel-fim and
               bc-ext-saldo-estoq.cod-unico >= c-cod-unico-ini and 
               bc-ext-saldo-estoq.cod-unico <= c-cod-unico-fim and
               bc-ext-saldo-estoq.it-codigo >= c-it-codigo-ini and 
               bc-ext-saldo-estoq.it-codigo <= c-it-codigo-fim
    break by bc-ext-saldo-estoq.cod-unico
          by bc-ext-saldo-estoq.cod-estabel:
    assign v-num-reg-lidos = v-num-reg-lidos + 1.
    run pi-acompanhar in h-bcr004a(input string(bc-ext-saldo-estoq.cod-unico)).

    /***  C…DIGO PARA SA™DA EM 132 COLUNAS ***/

if tt-param.formato = 2 then do:

    view frame f-cabec.
    view frame f-rodape.
    assign l-imprime = yes.


        run pi-verifica-estabelec ( input bc-ext-saldo-estoq.cod-estabel,
                                    input bc-ext-saldo-estoq.cod-estabel,
                                    input 0,   /* Tipo de Acesso 0=Currente .... */
                                    input 1).

        run pi-verifica-deposito (  input bc-ext-saldo-estoq.cod-depos,
                                    input bc-ext-saldo-estoq.cod-depos,
                                    input 0,   /* Tipo de Acesso 0=Currente .... */
                                    input 1).
        if  not avail ttReturnMessages
        then assign c-deposito = ttDeposito.nome.

        run pi-verifica-item  ( input bc-ext-saldo-estoq.it-codigo,
                                input bc-ext-saldo-estoq.it-codigo,
                                input 0,   /* Tipo de Acesso 0=Currente .... */
                                input 1).
        if  not avail ttReturnMessages
        then assign c-desc-item = ttItem.desc-item.

        run pi-verifica-localizacao (   input bc-ext-saldo-estoq.cod-estabel,
                                        input bc-ext-saldo-estoq.cod-estabel,
                                        input bc-ext-saldo-estoq.cod-depos,
                                        input bc-ext-saldo-estoq.cod-depos,
                                        input bc-ext-saldo-estoq.cod-localiz,
                                        input bc-ext-saldo-estoq.cod-localiz,
                                        input 0,   /* Tipo de Acesso 0=Currente .... */
                                        input 1).

    display bc-ext-saldo-estoq.cod-unico
            bc-ext-saldo-estoq.it-codigo
            c-desc-item
            bc-ext-saldo-estoq.cod-estabel
            bc-ext-saldo-estoq.cod-depos
            c-deposito
            bc-ext-saldo-estoq.cod-localiz
            bc-ext-saldo-estoq.lote
            with stream-io frame f-relat-09-132.
    down with frame f-relat-09-132.
    end.

end.

if  l-imprime = no then do:
    if  tt-param.formato = 2 then do:
        view frame f-cabec.
        view frame f-rodape.
    end.
    disp " " with stream-io frame f-nulo.
end.


run pi-finalizar in h-bcr004a.
IF VALID-HANDLE(h-bcr004a) THEN DELETE OBJECT h-bcr004a NO-ERROR.

page.

if  tt-param.parametro then do:

   {utp/ut-liter.i SELE€ÇO *}
   disp Return-value skip(01) with stream-io frame f-imp-sel.
   disp    c-cod-estabel-ini label "Estabelecimento Inicial" colon 30
        c-cod-estabel-fim label "Estabelecimento Final" colon 30
        c-cod-depos-ini label "Dep¢sito Inicial" colon 30
        c-cod-depos-fim label "Dep¢sito Final" colon 30
        c-it-codigo-ini label "Item Inicial" colon 30
        c-it-codigo-fim label "Item Final" colon 30
        c-cod-unico-ini label "£nico Inicial" colon 30
        c-cod-unico-fim label "£nico Final" colon 30
        with stream-io side-labels overlay row 032 frame f-imp-sel.
   {utp/ut-liter.i Estabelecimento_Inicial *}
   Assign c-cod-estabel-ini:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Estabelecimento_Final *}
   c-cod-estabel-fim:label  In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Dep¢sito_Inicial *}
   c-cod-depos-ini:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Dep¢sito_Final *}
   c-cod-depos-fim:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Item_Inicial *}
   c-it-codigo-ini:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Item_Final *}
   c-it-codigo-fim:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i énico_Inicial *}
   c-cod-unico-ini:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i énico_Final *}
   c-cod-unico-fim:label In Frame f-imp-sel = Return-value.

   {utp/ut-liter.i CLASSIFICA€ÇO *}
   disp Return-value  Format "x(13)" skip(01) with stream-io frame f-imp-cla.
   {utp/ut-liter.i ___Por_Estabelecimento *}
   disp Return-value Format "x(23)"
        with stream-io side-labels overlay row 032 frame f-imp-cla.

   {utp/ut-liter.i IMPRESSÇO *}
   put unformatted skip(1) Return-value.

   {utp/ut-liter.i Destino_:_ *}
   put unformatted skip "    " Return-value v-cod-destino-impres " - " tt-param.arquivo format "x(20)".
   {utp/ut-liter.i Execu‡Æo:_ *}
   put unformatted skip "    " Return-value if i-num-ped-exec-rpw = 0 then "On-Line" else "Batch".
   {utp/ut-liter.i 80_Colunas *}
   Assign v-Ltr = Return-value.
   {utp/ut-liter.i 132_Colunas *}
   Assign v-Ltr1 = Return-value.
   {utp/ut-liter.i Formato_:_ *}
   put unformatted skip "    " Return-value if tt-param.formato = 1 then v-Ltr else v-Ltr1.
   {utp/ut-liter.i Usu rio_:_ *}
   put unformatted skip "    " Return-value tt-param.usuario.

end.

output close.

output {&stream} close.

procedure pi-print-editor:
    def input param c-editor    as char    no-undo.
    def input param i-len       as integer no-undo.

    def var i-linha  as integer no-undo.
    def var i-aux    as integer no-undo.
    def var c-aux    as char    no-undo.
    def var c-ret    as char    no-undo.

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

return 'OK'.

