/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR0107A 2.00.00.005 } /*** "010005" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCR0107A MBC}
&ENDIF


/*****************************************************************************
**
**       Programa: bcr0107a.p
**
**       Data....: 17/07/98
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Listagem de extensäes da Fam¡lia
**
**       VersÆo..: 1.00.000 - bc
**
**       OBS.....: Este fonte foi gerado pelo Data Viewer
**
*******************************************************************************/

/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio **********************/

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
/****************** Defini‡ao de Parƒmetros do Relat¢rio *********************/ 

/****************** Defini‡ao de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

def new shared var c-fm-codigo-ini like bc-ext-familia.fm-codigo format "x(8)" initial "" no-undo.
def new shared var c-fm-codigo-fim like bc-ext-familia.fm-codigo format "x(8)" initial "ZZZZZZZZ" no-undo.

/****************** Defini‡ao de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 

/****************** Defini‡ao de Vari veis Campo do Layout do Relat¢rio **********************/ 

def var c-linha as character.

/****************** Defini‡ao de Vari veis do Relat¢rio NÆo Pedidas em Tela ******************/ 

/****************** Defini‡ao de Vari veis de Total do Relat¢rio *****************************/ 

/****************** Defini‡ao de Vari veis dos Calculos do Relat¢rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/

def var h-bcr0107 as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.
Def Var v-Ltr      As Character No-undo.
Def Var v-Ltr1     As Character No-undo.
/****************** Defini‡ao de Forms do Relat¢rio 132 Colunas ***************************************/ 

form bc-ext-familia.fm-codigo label "Fam¡lia" format "x(8)" at 007
     c-linha no-label  format "x(1)" at 026
     familia.descricao no-label  format "x(30)" at 029
     with down width 132 side-labels no-box stream-io frame f-relat-01-132.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-01-132:Handle).
&ENDIF

form bc-ext-familia.imprime-etiq label "Imprime Etiqueta?........" format "Sim/NÆo" at 012 skip
     bc-ext-familia.qt-etiq-item label "Fator Quantidade/Etiqueta" format ">>>>,>>,>>9.9999" at 012 skip
     bc-ext-familia.tipo-etiq label "Tipo Etiqueta............" format "9999" at 012
     with down width 132 side-labels no-box stream-io frame f-relat-09-132.
{utp/ut-liter.i Sim/NÆo *}
Assign bc-ext-familia.imprime-etiq:format In Frame f-relat-09-132 = Return-value.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-09-132:Handle).
&ENDIF

/****************** Defini‡ao de Forms do Relat¢rio 80 Colunas ***************************************/ 

form bc-ext-familia.fm-codigo label "Fam¡lia" format "x(8)" at 007
     c-linha no-label  format "x(1)" at 026
     familia.descricao no-label  format "x(30)" at 029
     with down width 80 side-labels no-box stream-io frame f-relat-01-80.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-01-80:Handle).
&ENDIF

form bc-ext-familia.imprime-etiq label "Imprime Etiqueta?........" format "Sim/NÆo" at 012 skip
     bc-ext-familia.qt-etiq-item label "Fator Quantidade/Etiqueta" format ">>>>,>>,>>9.9999" at 012 skip
     bc-ext-familia.tipo-etiq label "Tipo Etiqueta............" format "9999" at 012
     with down width 80 side-labels no-box stream-io frame f-relat-09-80.
{utp/ut-liter.i Sim/NÆo *}
Assign bc-ext-familia.imprime-etiq:format In Frame f-relat-09-80 = Return-value.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-09-80:Handle).
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
{utp/ut-liter.i Listagem_de_extensäes_da_Fam¡lia *}
assign c-programa     = "bcr0107a"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = Return-value.
{utp/ut-liter.i Coleta_de_Dados *}
Assign c-sistema      = Return-value.

if  tt-param.formato = 1 then do:

   /* In¡cio i-rpcb80.i */

   &IF  "{&stream}" = "" &THEN

   form header
       fill("-", 80) format "x(80)" skip
       c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
       "Folha:" at 70 page-number  at 76 format ">>>>9" skip
       fill("-", 60) format "x(58)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 80 no-labels no-box page-top frame f-cabec-80.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
            Run utp/ut-trfrrp.p (input Frame f-cabec-80:Handle).
   &ENDIF

   form header
       fill("-", 80) format "x(80)" skip
       c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
       "Folha:" at 70 page-number  at 76 format ">>>>9" skip
       "Periodo:" i-numper-x at 10 "-"
       da-iniper-x at 15 "a" da-fimper-x
       fill("-", 22) format "x(20)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 80 no-labels no-box page-top frame f-cabper-80.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
            If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
                Run utp/ut-trfrrp.p (input Frame f-cabper-80:Handle).
   &ENDIF
   &ELSE

   form header
       fill("-", 80) format "x(80)" skip
       c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
       "Folha:" at 70 page-number({&stream})  at 76 format ">>>>9" skip
       fill("-", 60) format "x(58)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 80 no-labels no-box page-top frame f-cabec-80.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
            If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
                Run utp/ut-trfrrp.p (input Frame f-cabec-80:Handle).
   &ENDIF

   form header
       fill("-", 80) format "x(80)" skip
       c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
       "Folha:" at 70 page-number({&stream})  at 76 format ">>>>9" skip
       "Periodo:" i-numper-x at 10 "-"
       da-iniper-x at 15 "a" da-fimper-x
       fill("-", 22) format "x(20)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 80 no-labels no-box page-top frame f-cabper-80. 
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
            If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
                Run utp/ut-trfrrp.p (input Frame f-cabper-80:Handle).
   &ENDIF
   &ENDIF

   c-rodape = "DATASUL - " + c-sistema + " - " + c-programa + " - V:" + c-versao + "." + c-revisao.
   c-rodape = fill("-", 80 - length(c-rodape)) + c-rodape.

   form header
       c-rodape format "x(80)"
       with stream-io width 80 no-labels no-box page-bottom frame f-rodape-80.

   /* Fim i-rpcb80.i */
end. /* tt-param.formato = 1 */ 

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

run utp/ut-acomp.p persistent set h-bcr0107.
{utp/ut-liter.i ExtensÆo_da_Fam¡lia *}
run pi-inicializar in h-bcr0107(input Return-value).

assign v-num-reg-lidos = 0.

for each bc-ext-familia no-lock
         where bc-ext-familia.fm-codigo >= c-fm-codigo-ini and 
               bc-ext-familia.fm-codigo <= c-fm-codigo-fim,
    each familia no-lock
         where familia.fm-codigo = bc-ext-familia.fm-codigo
    break by bc-ext-familia.fm-codigo
          by bc-ext-familia.imprime-etiq:
    assign v-num-reg-lidos = v-num-reg-lidos + 1.
    run pi-acompanhar in h-bcr0107(input string(bc-ext-familia.fm-codigo)).

    assign c-linha = "-".
        /***  CàDIGO PARA SAÖDA EM 80 COLUNAS ***/

    if tt-param.formato = 1 then do:

        view frame f-cabec-80.
        view frame f-rodape-80.
        assign l-imprime = yes.

        if  first-of(bc-ext-familia.fm-codigo) then do:
            display " " with stream-io no-box frame f-branco.
        display bc-ext-familia.fm-codigo
                c-linha
                familia.descricao
                    with frame f-relat-01-80.
            display " " with stream-io no-box frame f-branco.
        end.
        display bc-ext-familia.imprime-etiq
                bc-ext-familia.qt-etiq-item
                bc-ext-familia.tipo-etiq
                with frame f-relat-09-80.
        down with frame f-relat-09-80.
    end.

        /***  CàDIGO PARA SAÖDA EM 132 COLUNAS ***/

    if tt-param.formato = 2 then do:

        view frame f-cabec.
        view frame f-rodape.
        assign l-imprime = yes.

        if  first-of(bc-ext-familia.fm-codigo) then do:
            display " " with stream-io no-box frame f-branco.
        display bc-ext-familia.fm-codigo
                c-linha
                familia.descricao
                    with frame f-relat-01-132.
            display " " with stream-io no-box frame f-branco.
        end.
        display bc-ext-familia.imprime-etiq
                bc-ext-familia.qt-etiq-item
                bc-ext-familia.tipo-etiq
                with frame f-relat-09-132.
        down with frame f-relat-09-132.
    end.

end.


if  l-imprime = no then do:
    if  tt-param.formato = 1 then do:
        view frame f-cabec-80.
        view frame f-rodape-80.
    end.

    if  tt-param.formato = 2 then do:
        view frame f-cabec.
        view frame f-rodape.
    end.
    disp " " with stream-io frame f-nulo.
end.


run pi-finalizar in h-bcr0107.
IF VALID-HANDLE(h-bcr0107) THEN DELETE OBJECT h-bcr0107 NO-ERROR.

page.

if  tt-param.parametro then do:
   {utp/ut-liter.i SELE€ÇO *}
   disp Return-value skip(01) with stream-io frame f-imp-sel.
   disp    c-fm-codigo-ini label "Fam¡lia Inicial" colon 21
        c-fm-codigo-fim label "Fam¡lia Final" colon 21
        with stream-io side-labels overlay row 038 frame f-imp-sel.
   {utp/ut-liter.i Fam¡lia_Inicial *}
   Assign c-fm-codigo-ini:label In Frame f-imp-sel = Return-value.
   {utp/ut-liter.i Fam¡lia_Final *}
   Assign c-fm-codigo-fim:label In Frame f-imp-sel = Return-value.

   {utp/ut-liter.i CLASSIFICA€ÇO *}
   disp Return-value skip(01) with stream-io frame f-imp-cla.
   {utp/ut-liter.i ___Listagem_de_extensäes_da_Fam¡lia *}
   disp Return-value Format "x(35)"
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

