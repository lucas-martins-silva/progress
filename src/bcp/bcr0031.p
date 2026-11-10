/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR0031 2.00.00.012 } /*** "010012" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcr0031 MBC}
&ENDIF


/*****************************************************************************
**
**       Programa: bcr0031.p
**
**       Data....: 02/09/98
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Relat½rio de Extens„es da Fam­lia
**
**       Vers’o..: 1.00.000 - bc
**
**       OBS.....: Este fonte foi gerado pelo Data Viewer
**
*******************************************************************************/

/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio **********************/

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
    field c-fm-codigo-ini like bc-ext-familia.fm-codigo
    field c-fm-codigo-fim like bc-ext-familia.fm-codigo
.

/****************** INCLUDE COM VARIµVEIS GLOBAIS *********************/
{utp/ut-glob.i}
/*** Fim ut-glob.i Defini‡Æo de vari veis globais ***/ /****************** FIM INCLUDE COM VARIµVEIS GLOBAIS *********************/
/****************** Defini»ao de Par³metros do Relat½rio *********************/ 

/****************** Defini»ao de Variÿveis de Sele»’o do Relat½rio *********************/ 

def new shared var c-fm-codigo-ini like bc-ext-familia.fm-codigo format "x(8)" initial "" no-undo.
def new shared var c-fm-codigo-fim like bc-ext-familia.fm-codigo format "x(8)" initial "ZZZZZZZZ" no-undo.

/****************** Defini»ao de Variÿveis p/ Campos Virtuais do Relat½rio *******************/ 

/****************** Defini»ao de Variÿveis Campo do Layout do Relat½rio **********************/ 

def var c-etiqueta as character.
Def Var v-Ltr      As Character No-undo.
Def Var v-Ltr1     As Character No-undo.
/****************** Defini»ao de Variÿveis do Relat½rio N’o Pedidas em Tela ******************/ 

/****************** Defini»ao de Variÿveis de Total do Relat½rio *****************************/ 

/****************** Defini»ao de Variÿveis dos Calculos do Relat½rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Defini»ao de Variÿveis de Processamento do Relat½rio *********************/

def var h-bcr003a as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.

/****************** Defini»ao de Forms do Relat½rio 132 Colunas ***************************************/ 

form bc-ext-familia.fm-codigo column-label "Fam¡lia" format "x(8)" at 002
     ttFamilia.descricao column-label "Descri‡Æo Fam¡lia" format "x(30)" at 011
     bc-ext-familia.imprime-etiq column-label "Imp Etiq?" format "Sim/NÆo" at 042
     bc-ext-familia.qt-etiq-item column-label "Fator Qtd/Etq" format ">>>>,>>,>>9.9999" at 052
     bc-ext-familia.tipo-etiq column-label "Tp Etiq" format "9999" at 069
     c-etiqueta column-label "Descri‡Æo Etiqueta" format "x(50)" at 077
     with down width 132 no-box stream-io frame f-relat-09-132.
{utp/ut-liter.i Sim/NÆo *}
Assign bc-ext-familia.imprime-etiq:format In Frame f-relat-09-132 = Return-value.
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
{utp/ut-liter.i Relat¢rio_de_Extensäes_da_Fam¡lia *}
assign c-programa     = "bcr0031"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = Return-value.
{utp/ut-liter.i Coleta_de_Dados *}
Assign c-sistema      = Return-value.

if  tt-param.formato = 2 then do:

    /* In¡cio i-rpcab.i */
{include/i-rpcab.i}
   /* Fim i-rpcab.i */
end. /* tt-param.formato = 2 */

/*** In¡cio i-rpout.i ***/
{include/i-rpout.i}
/*** Fim i-rpout.i ***/

    assign i-ep-codigo-usuario = tt-param.ep-codigo
           v_cdn_empres_usuar  = i-ep-codigo-usuario.

    assign c-fm-codigo-ini = tt-param.c-fm-codigo-ini
           c-fm-codigo-fim = tt-param.c-fm-codigo-fim
           c-fm-codigo-fim = tt-param.c-fm-codigo-fim
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

{utp/ut-liter.i "Descri‡Æo Fam¡lia" * L}
assign ttFamilia.descricao:label = trim(return-value).
{utp/ut-liter.i "Imp Etiq?" * L}
assign bc-ext-familia.imprime-etiq:label = trim(return-value).
{utp/ut-liter.i "Fator Qtd/Etq" * L}
assign bc-ext-familia.qt-etiq-item:label = trim(return-value).
{utp/ut-liter.i "Tp Etiq" * L}
assign bc-ext-familia.tipo-etiq:label = trim(return-value).
{utp/ut-liter.i "Descri‡Æo Etiqueta" * L}
assign c-etiqueta:label = trim(return-value).
run utp/ut-acomp.p persistent set h-bcr003a.
{utp/ut-liter.i ExtensÆo_da_Fam¡lia *}
run pi-inicializar in h-bcr003a(input Return-value).

assign v-num-reg-lidos = 0.

for  each bc-ext-familia no-lock
    where bc-ext-familia.fm-codigo >= c-fm-codigo-ini
      and bc-ext-familia.fm-codigo <= c-fm-codigo-fim
    break by bc-ext-familia.fm-codigo
          by bc-ext-familia.imprime-etiq:
    assign v-num-reg-lidos = v-num-reg-lidos + 1.
    run pi-acompanhar in h-bcr003a(input string(bc-ext-familia.fm-codigo)).


    run pi-verifica-familia ( input bc-ext-familia.fm-codigo,
                              input bc-ext-familia.fm-codigo,
                              input 0,   /* Tipo de Acesso 0=Currente .... */
                              input 1).

    /***  C…DIGO PARA SA™DA EM 132 COLUNAS ***/

if tt-param.formato = 2 then do:

    view frame f-cabec.
    view frame f-rodape.
    assign l-imprime = yes.
    find first tipo-etiqueta
         where tipo-etiqueta.tipo-etiq = bc-ext-familia.tipo-etiq
         no-lock no-error.
         if avail tipo-etiqueta then
            assign c-etiqueta = tipo-etiqueta.titulo.
         else
            assign c-etiqueta = "".
    display bc-ext-familia.fm-codigo
            ttFamilia.descricao when avail ttfamilia
            bc-ext-familia.imprime-etiq
            bc-ext-familia.qt-etiq-item
            bc-ext-familia.tipo-etiq
            c-etiqueta
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


run pi-finalizar in h-bcr003a.
IF VALID-HANDLE(h-bcr003a) THEN DELETE OBJECT h-bcr003a  NO-ERROR.

page.

if  tt-param.parametro then do:

   {utp/ut-liter.i SELE€ÇO *}
   disp Return-value skip(01) with stream-io frame f-imp-sel.
   disp c-fm-codigo-ini label "Fam¡lia Inicial" colon 21
        c-fm-codigo-fim label "Fam¡lia Final" colon 21
        with stream-io side-labels overlay row 038 frame f-imp-sel.
   {utp/ut-liter.i Fam¡lia_Inicial *}
   Assign c-fm-codigo-ini:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Fam¡lia_Final *}
   Assign c-fm-codigo-fim:label In Frame f-imp-sel = Return-value.

   {utp/ut-liter.i CLASSIFICA€ÇO *}
   disp Return-value  Format "x(13)" skip(01) with stream-io frame f-imp-cla.
   {utp/ut-liter.i ___Por_Fam¡lia *}
   disp Return-value Format "x(14)"
        with stream-io side-labels overlay row 038 frame f-imp-cla.

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

